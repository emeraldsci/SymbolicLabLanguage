(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsubsection:: *)
(*MakeBoxes for cloud files *)

(* NOTE: We assume that we have all the fields that we need in this packet already. *)
UnitOperationPrimitive[myUnitOperationPacket_, myOptions:OptionsPattern[]]:=Module[
	{includeCompletedOptions,includeEmptyOptions,collapseOptionsQ,splitFieldsLookup,nonSplitFieldsFromPacket,recombinedSplitFields,
		allValuesFromPacket,finalValuesFromPacket,unitOperationHead,filteredValuesFromPacket},

	(* Should we include completed options? *)
	includeCompletedOptions=Lookup[ToList[myOptions], IncludeCompletedOptions, True];
	includeEmptyOptions=Lookup[ToList[myOptions], IncludeEmptyOptions, False];

	(* Should we collapse options? *)
	collapseOptionsQ=Lookup[ToList[myOptions], CollapseOptions, False];

	(* These are the fields that are created by combining the split fields together but don't actually exist in the *)
	(* types. *)
	splitFieldsLookup=Constellation`Private`getUnitOperationsSplitFieldsLookup[Lookup[myUnitOperationPacket, Type]];

	(* Get the split fields from the packet and the non split fields. *)
	(* Note that we need to consider both Rule and RuleDelayed here since we may have RuleDelayed in our Download packets. They should still be considered as valid fields in the packet *)
	nonSplitFieldsFromPacket=Cases[Normal[myUnitOperationPacket], Verbatim[Rule][Except[Alternatives@@DeleteDuplicates[Flatten[{Values[splitFieldsLookup], Object, ID, Name, Type, DeveloperObject, RequiredResources}]]], _]|Verbatim[RuleDelayed][Except[Alternatives@@DeleteDuplicates[Flatten[{Values[splitFieldsLookup], Object, ID, Name, Type, DeveloperObject, RequiredResources}]]], _]];

	(* Piece together the split fields. *)
	recombinedSplitFields=KeyValueMap[
		Function[{combinedField,splitFields},
			(* If we're dealing with a split single field, just take the first single field that isn't set to Null. *)
			If[MatchQ[Lookup[LookupTypeDefinition[Lookup[myUnitOperationPacket,Type],splitFields[[1]]],Format],Single],
				combinedField->FirstCase[(Lookup[myUnitOperationPacket,#]&)/@splitFields,Except[Null],Null],
				Module[{splitFieldValues,safeSplitFieldValues,recombinedValue},
					(* Transpose our split fields together. *)
					splitFieldValues=(ToList[Lookup[myUnitOperationPacket,#,{}]]&)/@splitFields;

					(* NOTE: Our split field values may not be of the same length. Make them the same length in the case we have {}. *)
					(* Developers may forget to fill out the other split fields if they're just using one of them. *)
					safeSplitFieldValues=If[Length[DeleteDuplicates[Length/@splitFieldValues]]==1,
						splitFieldValues,
						Module[{longestSplitFieldValue},
							longestSplitFieldValue=Max[Length/@splitFieldValues];

							(If[MatchQ[#,{}],ConstantArray[Null,longestSplitFieldValue],#]&)/@splitFieldValues
						]
					];

					recombinedValue=(FirstCase[#,Except[Null],Null]&)/@Transpose[safeSplitFieldValues];

					combinedField->If[MatchQ[collapseOptionsQ, True] && Length[DeleteDuplicates[recombinedValue/.{link_Link:>LinkedObject[link]}]]==1,
						FirstOrDefault[recombinedValue]/.{link_Link:>Download[link, Object]},
						recombinedValue
					]
				]
			]
		],
		splitFieldsLookup
	];

	(* Join this with the non split fields. *)
	allValuesFromPacket=Join[nonSplitFieldsFromPacket, recombinedSplitFields];

	(* Filter out empty fields if IncludeEmptyOptions is set. *)
	(* Note that we need to consider both Rule and RuleDelayed here since we may have RuleDelayed in our Download packets. They should still be considered as valid entries in the packet *)
	finalValuesFromPacket=If[MatchQ[includeEmptyOptions, False],
		Cases[allValuesFromPacket, Verbatim[Rule][_, Except[{}|Null]]|Verbatim[RuleDelayed][_, Except[{}|Null]]],
		allValuesFromPacket
	];

	(* Get the unit operation head. *)
	unitOperationHead=Last[Lookup[myUnitOperationPacket, Type]];

	(* Filter, if we're not supposed to include the completed options. *)
	filteredValuesFromPacket=If[MatchQ[includeCompletedOptions, True],
		finalValuesFromPacket,
		RemoveHiddenPrimitiveOptions[unitOperationHead,finalValuesFromPacket]
	];

	(* Put it into primitive form . *)
	Last[Lookup[myUnitOperationPacket, Type]][Association@filteredValuesFromPacket]
];

$UnitOperationStore = <||>;

(* NOTE: We assume that we have all the fields that we need in this packet already. *)
UnitOperationBlob[myUnitOperationPacket_, originalValue_]:=Module[
	{primitive,primitiveWithObject,boxes},

	(* Get the object in primitive form then call MakeBoxes. *)
	primitive=UnitOperationPrimitive[myUnitOperationPacket, IncludeEmptyOptions->False, CollapseOptions->True];
	primitiveWithObject=Head[primitive]@Append[primitive[[1]], Object->Download[originalValue, Object]];
	boxes=With[{insertMe=primitiveWithObject}, MakeBoxes[insertMe]];

	With[{insertMe=boxes}, InterpretationBox[insertMe,originalValue,SelectWithContents->False]]
];

OnLoad[
	$UnitOperationBlobs=True;
	With[{
		(* Unit operation packets that have all the info we need already *)
		singlePacket=KeyValuePattern[{Type->Object[UnitOperation, ___],Object->ObjectP[Object[UnitOperation]]}],
		(* Unit operation objects that are not already a complete packet *)
		nonPacket=LinkP[Object[UnitOperation]] | ObjectReferenceP[Object[UnitOperation]],
		(* Packets that might reference a unit operation in one of the fields *)
		nonUnitOperationPacket=Except[PacketP[Object[UnitOperation]],PacketP[]]
	},
		(* This overload is for a single packet and does all the formatting that we want for cloud file blobs. No downloading is required. *)
		MakeBoxes[
			unitOperationPacket:singlePacket,
			StandardForm
		] := Block[{$UnitOperationBlobs=False},
			If[MemberQ[Keys[unitOperationPacket], Replace[_Symbol]],
				MakeBoxes[unitOperationPacket],
				UnitOperationBlob[unitOperationPacket, unitOperationPacket]
			]
		]/;(TrueQ[$UnitOperationBlobs] && DatabaseMemberQ[Lookup[unitOperationPacket, Object]]);

		(* This is the overload that takes non-packets, downloads them in one call, then passes to the overload that does the formatting *)
		MakeBoxes[
			unitOperationObject:nonPacket,
			StandardForm
		] := Block[{$UnitOperationBlobs=False},
			Module[{objectID, packet, oldCAS, currentCAS, objectRef},
				objectID = Download[unitOperationObject, ID];
				(* NOTE: We need to download ALL of the fields so that we can stich them together in our blob. If we don't send this option, *)
				(* some of the fields won't actually be downloaded and we'll end up mapping Download. *)
				oldCAS = Lookup[Lookup[$UnitOperationStore, objectID, <||>], ECL`CAS, Null];
				packet=If[KeyExistsQ[$UnitOperationStore, objectID],
					(
						(* find the current cas of the object with the help of a nifty constellation helper *)
						objectRef = Download[unitOperationObject, Object];
						currentCAS = Lookup[Lookup[Constellation`Private`peekObjects[{objectRef}], objectRef], "cas"];

						(* if it's the same as the old one in the store, then just used the cached download from before *)
						(* NOTE: this is important b/c it can be very, very slow to download an entire robotic unit operation, and we only want to do that if we have to *)
						If[currentCAS === oldCAS,
							Lookup[$UnitOperationStore, objectID],
							Quiet[Download[unitOperationObject, PaginationLength -> 10^15, IncludeCAS -> True]]
						]
					),
					Quiet[Download[unitOperationObject, PaginationLength -> 10^15, IncludeCAS -> True]]
				];

				$UnitOperationStore = Join[$UnitOperationStore, <|packet[ID] -> packet|>];

				If[!MatchQ[packet, $Failed],
					UnitOperationBlob[packet, unitOperationObject],
					MakeBoxes[unitOperationObject]
				]
			]
		]/;(TrueQ[$UnitOperationBlobs] && DatabaseMemberQ[unitOperationObject]);

		(* This is to speed up the display of packets that have unit operations *)
		MakeBoxes[
			packets:nonUnitOperationPacket,
			StandardForm
		] := Block[{$UnitOperationBlobs=False},
			Module[
				{
					unitOperationObjects, unitOperationIDs, objectsAndPackets, unitOperationPackets, findUnitOperationPacket,
					cloudFilePackets, finalPacket, currentCAStokens, oldCAStokens, cachedUnitOpQ, unitOperationAndCacheTags
				},

				unitOperationObjects=DeleteDuplicates[Flatten[Download[Cases[#,ObjectP[Object[UnitOperation]],Infinity],Object]&/@ToList[packets]]];

				(* find the current cas of the object with the help of a nifty constellation helper *)
				currentCAStokens = If[unitOperationObjects === {},
					{},
					Lookup[Lookup[Constellation`Private`peekObjects[unitOperationObjects], unitOperationObjects, <||>]  /. {Null -> <||>}, "cas", Null]
				];

				(* get the id's to check against the unit operation cache store *)
				unitOperationIDs = Download[unitOperationObjects, ID];

				(* find the old CAS tokens for each unit operation id *)
				(* if they don't exist in the cache, then set them to null *)
				oldCAStokens = If[unitOperationObjects === {},
					{},
					Lookup[Lookup[$UnitOperationStore, unitOperationIDs, <||>], ECL`CAS, Null]
				];

				(* figure out if the current cas tokens are in the cache store *)
				cachedUnitOpQ = MapThread[SameQ, {currentCAStokens, oldCAStokens}];

				(* transpose for convenience to create {objectReference, True|False} pairs. A True tag means the object is in the cache. *)
				unitOperationAndCacheTags = Transpose[{unitOperationObjects, cachedUnitOpQ}];

				(* replace the object references with packets if they are in the cache by using the True/False booleans in the second position *)
				(* if true look up the packet from the cache store; if false, strip off the Boolean and return the object reference to be downloaded *)
				objectsAndPackets = Replace[
					unitOperationAndCacheTags,
					{
						{object: Object[__, id_String], True} :> Lookup[$UnitOperationStore, id, object],
						{object_, False} :> object
					},
					{1}
				];

				(*
					NOTE: replacing objects with their cached packets will provide speedups in 95% of cases;
					the download will quickly lookup and return the values from the packets and download the contents of the objects that need to be updated
				*)
				(* NOTE: We need to download ALL of the fields so that we can stich them together in our blob. If we don't send this option, *)
				(* some of the fields won't actually be downloaded and we'll end up mapping Download. *)
				unitOperationPackets=Quiet[Download[objectsAndPackets, PaginationLength -> 10^15, IncludeCAS -> True]];

				(* add packets to cache to speed up any further copy-pasting of these blobs around the notebook *)
				addToCache[packet_] := ($UnitOperationStore = Join[$UnitOperationStore, <|packet[ID] -> packet|>]);
				Map[addToCache, unitOperationPackets];

				(* Make a helper to find the packet for a corresponding cloud object since we don't want to map download *)
				findUnitOperationPacket[object_]:=FirstCase[unitOperationPackets,KeyValuePattern[Object->Download[object,Object]],object];

				(* Convert any cloud file objects in the packet to their corresponding packets. MakeBoxes will take care of doing the display, but this will prevent mapping download. *)
				(* ReplaceAll doesn't work on associations like named singles, so do replace to infinity instead *)
				cloudFilePackets=Replace[#, x:LinkP[Object[UnitOperation]] :> findUnitOperationPacket[x],Infinity]&/@ToList[packets];

				(* If we are displaying a single packet, get it out of list form *)
				finalPacket=If[MatchQ[packets,_List],cloudFilePackets,cloudFilePackets[[1]]];

				ToBoxes[finalPacket]
			]
		]/;TrueQ[$UnitOperationBlobs]
	]
];

(* ::Subsection::Closed:: *)
