(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*fetchPacketFromCache *)


(*  No pattern matching to make the function blazing fast. *)
fetchPacketFromCache[Null, _]:=Null;
fetchPacketFromCache[myObject_, myCachedPackets_]:=Module[
	{myObjectNoLink, naiveLookup, type, name},

	(* If given $Failed, return an empty packet. *)
	If[MatchQ[myObject, $Failed],
		Return[<||>];
	];

	(* Make sure that myObject isn't a link. *)
	myObjectNoLink=Download[myObject, Object];

	(* First try to find the packet from the cache using Object->myObject *)
	naiveLookup=FirstCase[myCachedPackets, KeyValuePattern[{Object -> myObjectNoLink}], <||>];

	(* Were we able to find a packet? *)
	If[!MatchQ[naiveLookup, <||>],
		(* Yes. *)
		naiveLookup,
		(* No. *)
		(* We may have been given a name. *)
		(* Get the type and name from the object. *)
		type=Most[myObjectNoLink];
		name=Last[myObjectNoLink];

		(* Lookup via the name and type. *)
		FirstCase[myCachedPackets, KeyValuePattern[{Type -> type, Name -> name}], <||>]
	]
];


(* ::Subsection::Closed:: *)
(*CompatibleFootprintQ*)

DefineOptions[CompatibleFootprintQ,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "locationAndSamples",
			{
				OptionName -> Tolerance,
				Default -> $DimensionTolerance,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Meter], Units -> Meter],
				NestedIndexMatching -> True,
				Description -> "Indicates the tolerance allowed to determine if the sample can fit in the position of the instrument."
			},
			{
				OptionName -> ExactMatch,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				NestedIndexMatching -> True,
				Description -> "Indicates if a direct footprint match, consdering Tolerance, is necessary. If set to False, the function only checks that the container dimensions are less than the footprint of the positions on the instrument."
			},
			{
				OptionName -> MinWidth,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0Meter], Units -> Meter],
				NestedIndexMatching -> True,
				Description -> "Indicates if there is a minimum width for positions on the instrument."
			},
			{
				OptionName -> Position,
				Default -> All,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]],
					Widget[Type -> String, Pattern :> _String, Size -> Line]
				],
				NestedIndexMatching -> True,
				Description -> "Indicates which locations in the instrument/container should be considered for footprint compatibility."
			}
		],
		{
			OptionName -> FlattenOutput,
			Default -> True,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicated if the output resuls will be flatten based on the number of input containers (FlattenOutput->True), or the output will be in a list of list regardless the number of input containers (FlattenOutput->False)."
		},
		{
			OptionName -> Output,
			Default -> Boolean,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Boolean, Positions]],
			Description -> "Indicates if a boolean should be returned, indicating if a position exists on the instrument that can fit the sample, or if the positions that are compatible with the sample should be returned."
		},
		CacheOption,
		SimulationOption
	}
];


Error::PositionNotFound="CompatibleFootprintQ was unable to find the position `1` in the list of discovered positions `2` for `3`.";
Error::CompatibleFootprintQInvalidInputLength="The number of allowed location list: '`1`' and number of containers: '`2`', must be of equal length. Please check input lengths.";
Error::CompatibleFootprintQSameOptionLength="The option sublist for locations: `1` should be in the same size as the length of the input location sublist: `2`. ";
Warning::DimensionToleranceExceedsDefault="A member of the Tolerance option exceeds the default value set by $DimensionTolerance, and may result in a move being invalid when it is executed in Engine.";

(* Overload the function *)
(* If the container input is a single sample we want to return the result as a single boolean instead of a list
CompatibleFootprintQ[myLocationSingletonObjs:ListableP[ObjectP[{Model[Instrument],Model[Container]}]],mySingleSample:ObjectP[Object[Sample]],myOptions:OptionsPattern[]]:=CompatibleFootprintQ[{myLocationSingletonObjs},mySingleSample,myOptions];
 *)

(* if the location input is a list of location, instead a list of list, we will overload the location into a list of list *)
(* we also expand the options to a listed options*)
CompatibleFootprintQ[myLocationSingletonObjs:ListableP[ObjectP[{Model[Instrument], Model[Container]}]], myListableSample:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[]]:=Module[
	{safeOps, optionsToExpand, safeOpsValuesToExpand, expandValueToList, listedOptionRules, updatedListedOptions},

	safeOps=SafeOptions[CompatibleFootprintQ, ToList[myOptions], AutoCorrect -> False];

	(* Expand the safe Ops to a list of list *)
	optionsToExpand={Tolerance, ExactMatch, MinWidth, Position};

	(* safe options to expand *)
	safeOpsValuesToExpand=Lookup[Association @@ safeOps, optionsToExpand];

	(* give the option additional list of list *)
	expandValueToList={#}& /@ safeOpsValuesToExpand;

	(* preExpanded New Option Rules *)
	listedOptionRules=Flatten[MapThread[{#1 -> #2}&, {optionsToExpand, expandValueToList}]];

	(* replace rull to  *)
	updatedListedOptions=ReplaceRule[safeOps, listedOptionRules];

	CompatibleFootprintQ[{myLocationSingletonObjs}, myListableSample, Sequence @@ updatedListedOptions]
];

(* download the container of the sample as the input. *)
CompatibleFootprintQ[
	myLocationObjs:ListableP[ListableP[ObjectP[{Model[Instrument],Model[Container]}]]],
	myListableSample:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Container]}]],
	myOptions:OptionsPattern[]
]:=Module[{cache,containerModels,listedInputs,listedObjects,fieldsToDownload,simulation},
	(* Get our passed cache and simulation. *)
	cache=Quiet[OptionValue[Cache]];
	simulation=Quiet[OptionValue[Simulation]];

	(* Ensure that options and samples are in a list, and have no temporal links *)
	listedInputs=First[removeLinks[ToList[myListableSample],{}]];

	(* make sure all objects are in object reference form *)
	listedObjects=Download[listedInputs,Object];

	(* get fields to download based on input type *)
	fieldsToDownload=Switch[#,
		ObjectReferenceP[Model[Container]],{Object},
		ObjectReferenceP[Object[Container]],{Model[Object]},
		_,{Container[Model][Object]}
	]&/@listedObjects;

	(* Download the container model from the samples. *)
	containerModels=Flatten@Download[
		listedObjects,
		fieldsToDownload,
		Cache->cache,
		Simulation->simulation
	];

	(* Call our main function. *)
	CompatibleFootprintQ[myLocationObjs,containerModels,myOptions]
];

(*
If the input a single model container, we will return a single boolean value instead of a list
CompatibleFootprintQ[myLocationSingletonObjs:ListableP[ObjectP[{Model[Instrument],Model[Container]}]],mysingleContainer:ObjectP[Model[Container]],myOptions:OptionsPattern[]]:=CompatibleFootprintQ[{myLocationSingletonObjs},mysingleContainer,myOptions];
*)

(* if the location input is a list of location, instead a list of list, we will overload the location into a list of list *)
(* we also expand the options to a listed options*)
CompatibleFootprintQ[myLocationSingletonObjs:ListableP[ObjectP[{Model[Instrument], Model[Container]}]], myListableContainer:ListableP[ObjectP[Model[Container]]], myOptions:OptionsPattern[]]:=Module[
	{safeOps, optionsToExpand, safeOpsValuesToExpand, expandValueToList, listedOptionRules, updatedListedOptions},

	safeOps=SafeOptions[CompatibleFootprintQ, ToList[myOptions], AutoCorrect -> False];

	(* Expand the safe Ops to a list of list *)
	optionsToExpand={Tolerance, ExactMatch, MinWidth, Position};

	(* safe options to expand *)
	safeOpsValuesToExpand=Lookup[Association @@ safeOps, optionsToExpand];

	(* give the option additional list of list *)
	expandValueToList={#}& /@ safeOpsValuesToExpand;

	(* preExpanded New Option Rules *)
	listedOptionRules=Flatten[MapThread[{#1 -> #2}&, {optionsToExpand, expandValueToList}]];

	(* replace rull to  *)
	updatedListedOptions=ReplaceRule[safeOps, listedOptionRules];

	CompatibleFootprintQ[{myLocationSingletonObjs}, myListableContainer, Sequence @@ updatedListedOptions]
];


CompatibleFootprintQ[myLocationObjLists:{ListableP[ObjectP[{Model[Instrument], Model[Container]}]]..}, myListableContainers:ListableP[ObjectP[Model[Container]]], myOptions:OptionsPattern[]]:=Module[
	{cache, output, listedLocations, safeOps, expandedSafeOps, locationPackets, mapThreadFriendlyOptions, results, modelDimensions,
		positions, uniqueFootprints, allowablePositions, wiggleRoom, allowableFootprintP, realContainerPacketListed, footprint,
		adapterPacketsListed, allPositions, listedContainers, locationFlattenedList, locationPacketsFlattenListed, adapterPacketsFlattenListed,
		realContainerFlattenedListPacket,
		flattenOutput,simulation
	},

	(* Lookup our cache. *)
	cache=Quiet[OptionValue[Cache]];
	simulation=Quiet[OptionValue[Simulation]];

	(* Get the value of Output. *)
	output=Quiet[OptionValue[Output]];

	(* Get the vlue of FlattenOutput *)
	flattenOutput=Quiet[OptionValue[FlattenOutput]];

	(* ToList our instruments/containers. *)
	listedLocations=ToList[myLocationObjLists];

	(* Transfer input container into a list *)
	listedContainers=ToList[myListableContainers];

	(* Get the safe options of this function. *)
	safeOps=SafeOptions[CompatibleFootprintQ, ToList[myOptions], AutoCorrect -> False];
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];
	(*	(* Expand the safe Ops to a list of list *)
		optionsToExpand={Tolerance,ExactMatch,MinWidth,Position};

		(* Grab the values that we wants to expand to a list of list *)
		safeOpsValuesToExpand=Lookup[Association@@safeOps,optionsToExpand];

		(* give the option additional list of list *)
		expandValueToList=ConstantArray[ToList[#],Length[listedLocations]]&/@safeOpsValuesToExpand;

		(* preExpanded New Option Rules *)
		preExpandedOptionRules=Flatten[MapThread[{#1->#2}&,{optionsToExpand,expandValueToList}]];


	updatedPreExpandOptions=ReplaceRule[safeOps,preExpandedOptionRules];
*)
	(* Throw a error check for the input length: if not the same, throw an error message and return an empty list. *)
	If[
		(Length[listedLocations] != Length[listedContainers]),

		Message[Error::CompatibleFootprintQInvalidInputLength, ToString[Length[listedLocations]], ToString[Length[listedContainers]]];
		Return[{}]
	];

	(* Expand index-matching options *)
	expandedSafeOps=Last[Quiet[ExpandIndexMatchedInputs[CompatibleFootprintQ, {listedLocations, listedContainers}, safeOps],Warning::UnableToExpandInputs]];

	(* Since we are dealing with a list of list or conatiners, we will download everything in a flattened list. *)
	locationFlattenedList=Flatten[listedLocations];

	(* Download the instrument/container packets as well as the packet for myContainer which we want to place. *)
	{locationPacketsFlattenListed, adapterPacketsFlattenListed, realContainerPacketListed}=Quiet[
		Download[
			{
				locationFlattenedList,
				locationFlattenedList,
				listedContainers
			},
			{
				{Packet[Object, Positions]},
				{Packet[CompatibleAdapters[Positions]]},
				{Packet[Object, Dimensions, Footprint]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField}
	];



	(* Transferred the flattened download into a pooled list *)

	locationPackets=TakeList[Flatten[locationPacketsFlattenListed], Length /@ listedLocations];

	(* Transferred the flattened download into a pooled list *)
	adapterPacketsListed=TakeList[(Flatten[ToList[#] /. {$Failed -> Nothing}]&) /@ adapterPacketsFlattenListed, Length /@ listedLocations];

	(* Flatten the list to be used later in the options*)
	realContainerFlattenedListPacket=Flatten[realContainerPacketListed];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[CompatibleFootprintQ, expandedSafeOps];

	(*if we specify a tolerance that exceeds the default precision, we need to warn that this might get rejected by VULQ*)
	If[MemberQ[Lookup[mapThreadFriendlyOptions,Tolerance], GreaterP[$DimensionTolerance]]&&!MatchQ[$ECLApplication, Engine],
		Message[Warning::DimensionToleranceExceedsDefault, ToString[Lookup[mapThreadFriendlyOptions,Tolerance]]]
	];

	(* Map over our given instruments. *)
	results=MapThread[
		Function[
			{eachLocationLoopPacket, eachAdapterLoopPacketsListed, realContainerPacket, mapThreadOptions},
			Module[{optionList, mapThreadLength, mapThreadSafeTolerance, mapThreadSafeExactMatch, mapThreadSafeMinWidth, mapThreadSafePosition,
				returnBool,returnOutput,containerFootprint,rawFootprint,containerFootprints},
				optionList=Lookup[mapThreadOptions, {Tolerance, ExactMatch, MinWidth, Position}];

				mapThreadLength=Length[eachLocationLoopPacket];

				(* cannot expand the options to cover all the edge cases so manually expand here*)
				{
					mapThreadSafeTolerance,
					mapThreadSafeExactMatch,
					mapThreadSafeMinWidth,
					mapThreadSafePosition
				}=If[Length[ToList[#]] == 1, ConstantArray[First[ToList[#]], mapThreadLength], #]& /@ optionList;

				(* Throw a error message if all the options are not in same length*)
				If[
					!SameQ @@ (Length /@ {eachLocationLoopPacket, eachAdapterLoopPacketsListed, mapThreadSafeTolerance, mapThreadSafeExactMatch, mapThreadSafeMinWidth, mapThreadSafePosition}),
					Message[Error::CompatibleFootprintQSameOptionLength, ToString[Lookup[eachLocationLoopPacket, Object]], ToString[Length[eachLocationLoopPacket]]];Return[{}]
				];

				MapThread[
					Function[{instrumentPacket, adapterPackets, eachTolerance, eachExactMatch, eachMinWidth, eachPosition},
						(* Lookup our model dimensions. *)
						modelDimensions=Lookup[realContainerPacket, Dimensions];

						(* Lookup our container's footprint. If it wasn't given to us, use _. Open footprint should match everything as well. *)
						footprint=Lookup[realContainerPacket, Footprint, _] /. {Null -> _};

						(* lookup footprint as is from the container packet *)
						rawFootprint=Lookup[realContainerPacket, Footprint];

						(* Get all of our positions that can possibly be used. If we have an Adapter, take the positions from that in addition to those in the instrument. *)
						allPositions=If[Length[adapterPackets] > 0,
							Join[Flatten[Lookup[adapterPackets, Positions]], Lookup[instrumentPacket, Positions]],
							Lookup[instrumentPacket, Positions]
						];

						(* Get the positions from our packet. *)
						positions=If[MatchQ[(eachPosition /. _Missing -> All), All],
							(* If we were told to check All positions (this is the default) pull all positions from the packet *)
							allPositions,
							(* Otherwise we must confirm the instrument has the position requested, and if so, only consider that position going forward *)
							Module[{matchingPosition},

								(* Try to get a matching position from the instrument's position list *)
								matchingPosition=Cases[
									allPositions,
									AssociationMatchP[<|Name -> eachPosition|>, AllowForeignKeys -> True]
								];

								(* Check that we found a matching position, if not throw an error *)
								If[MatchQ[matchingPosition, ListableP[_Association]],
									ToList[matchingPosition],

									(* Otherwise throw an error *)
									(
										Message[Error::PositionNotFound, eachPosition, Lookup[allPositions, Name], Lookup[instrumentPacket, Object]];
										{}(* Return an empty list to indicate no valid positions were found *)
									)
								]
							]
						];

						(* Get all of the unique MaxWidth and MaxDepth positions in this model. *)
						uniqueFootprints=DeleteDuplicates[Lookup[positions, {MaxWidth, MaxDepth, MaxHeight, Footprint, Name}]];

						containerFootprints = DeleteDuplicates[Lookup[positions,Footprint]];

						(*boolean indicating if footprints are a match and exclude cases where sample doesn't have footprint *)
						(* return this if eachExactMatch and output are true*)
						returnBool=And[
							eachExactMatch,
							MemberQ[containerFootprints,footprint],
							!NullQ[rawFootprint]
						];

						Which[
							(*if expect a boolean output and returnBool is true and eachExactMatch is true*)
							MatchQ[output,Boolean]&&returnBool&&eachExactMatch,
							returnBool,

							(*if expect a positions output and returnBool is true and eachExactMatch is true*)
							MatchQ[output,Positions]&&returnBool&&eachExactMatch,
							(*get all positions from uniqueFootprints whose Footprints, fourth element, are matching the footprint in question*)
							Module[{footprintsWithOGPositions,allPositionsWithMatchingFootprint},
								footprintsWithOGPositions = uniqueFootprints[[All,4]];
								allPositionsWithMatchingFootprint = Flatten[Position[footprintsWithOGPositions,footprint]];
								ToString/@allPositionsWithMatchingFootprint
							],

							(*footprints don't exactly match or output is a list of positions, do the rest of the dimension matching*)
							True,
							Module[{},
								(* Define a tolerance since container parameterization isn't perfect. *)
								wiggleRoom=eachTolerance;

								(* Create a pattern for the allowable footprints. *)
								allowableFootprintP=Which[
									NullQ[modelDimensions],
										{
											Null,
											Null,
											Null,
											footprint | Open | SingleItem | LabArmorBeads,
											_
										},
									eachExactMatch,
										(* If we ask for an ExactMatch, we do not have to exactly match the height. *)
										{
											Null | RangeP[modelDimensions[[1]] - wiggleRoom, modelDimensions[[1]] + wiggleRoom],
											Null | RangeP[modelDimensions[[2]] - wiggleRoom, modelDimensions[[2]] + wiggleRoom],
											Null | GreaterEqualP[modelDimensions[[3]] - wiggleRoom],
											footprint | Open | SingleItem | LabArmorBeads,
											_
										},
									True,
										{
											Null | GreaterEqualP[modelDimensions[[1]] - wiggleRoom],
											Null | GreaterEqualP[modelDimensions[[2]] - wiggleRoom],
											Null | GreaterEqualP[modelDimensions[[3]] - wiggleRoom],
											footprint | Open| SingleItem | LabArmorBeads,
											_
										}
								];

								(* For each of our slots, is there a slot that is within wiggleRoom of the dimensions of our container? *)
								allowablePositions=Cases[
									uniqueFootprints,
									allowableFootprintP
								];

								(* What's the value of Output? *)
								returnOutput=If[MatchQ[output, Boolean],
									(* Return a boolean. *)
									(* If we are allowed to put the container in a position in our instrument, the footprint is compatible. *)
									(* AND, if MinWidth is set, the container's width is above this min width. *)
									And[
										Length[allowablePositions] > 0,
										MatchQ[eachMinWidth, Null] || MatchQ[First[modelDimensions], GreaterEqualP[eachMinWidth] | Null]
									],
									(* Return the allowable position names, as strings. *)
									allowablePositions[[All, 5]]
								];

								returnOutput
							]
						]
					],
					{eachLocationLoopPacket, eachAdapterLoopPacketsListed, mapThreadSafeTolerance, mapThreadSafeExactMatch, mapThreadSafeMinWidth, mapThreadSafePosition}
				]
			]
		],
		{locationPackets, adapterPacketsListed, realContainerFlattenedListPacket, mapThreadFriendlyOptions}
	];


	(* myLocationObjLists:{ListableP[ObjectP[{Model[Instrument],Model[Container]}]]..}*)
	(* If we were given a singleton instrument, de-list our result. *)
	If[flattenOutput,
		Which[
			Length[results] > 1, results,
			Length[First[results]] > 1, First[results],
			True, First[First[results]]
		],
		results
	]

];



(* ::Subsection::Closed:: *)
(*AliquotContainers*)


DefineOptions[AliquotContainers,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "instruments",
			{
				OptionName -> Tolerance,
				Default -> $DimensionTolerance,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0Meter], Units -> Meter],
				Description -> "Indicates the tolerance allowed to determine if the sample can fit in the position of the instrument."
			},
			{
				OptionName -> ExactMatch,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if a direct footprint match, consdering Tolerance, is necessary. If set to False, the function only checks that the container dimensions are less than the footprint of the positions on the instrument."
			},
			{
				OptionName -> MinWidth,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0Meter], Units -> Meter],
				Description -> "Indicates if there is a minimum width for positions on the instrument."
			},
			{
				OptionName -> SelfStanding,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if a self-standing container is desired. Setting SelfStanding to Null means any container model is fine."
			}
		],
		CacheOption,
		SimulationOption
	}
];


AliquotContainers[myLocationObjs:ListableP[ObjectP[Model[Instrument]]], mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[]]:=Module[
	{cache, listedInstruments, safeOps, expandedSafeOps, instrumentPackets, samplePacket, realSamplePacket, sampleAmount,
		sterile, lightSensitive,filteredPreferredContainerPackets,mapThreadFriendlyOptions, filterBooleans, positions,
		uniqueFootprints, wiggleRoom, preferredContainers, preferredContainerPackets, preferredContainerDimensions, preferredContainerSelfStandingBools, results, simulation},

	(* ToList our instruments. *)
	listedInstruments=ToList[myLocationObjs];

	(* Get the safe options of this function. *)
	safeOps=SafeOptions[AliquotContainers, ToList[myOptions], AutoCorrect -> False];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[AliquotContainers, {listedInstruments, mySample}, safeOps]];

	(* Lookup our cache. *)
	cache=Lookup[safeOps, Cache];
	simulation=Lookup[safeOps, Simulation];

	(* Download the instrument packets. *)
	instrumentPackets=Download[listedInstruments, Packet[Object, Positions], Cache -> cache];

	(* Lookup our object sample from our cache. *)
	samplePacket=fetchPacketFromCache[mySample, cache];

	(* Were we able to find the instrument packet? *)
	realSamplePacket=If[MatchQ[samplePacket, <||>],
		(* Wasn't in the cache. Download our packet. *)
		Download[mySample, Packet[Object, Volume, Mass, Sterile, LightSensitive], Simulation -> simulation],
		(* Was in the cache. *)
		samplePacket
	];

	(* Get the sample amount, depending on what fields it has. If it doesn't have Mass, look at Volume, if it has neither assume 0 Liter. *)
	sampleAmount=(Switch[Lookup[realSamplePacket, Mass, $Failed],
		Except[$Failed | Null],
		Lookup[realSamplePacket, Mass, 0 Gram],
		_,
		Lookup[realSamplePacket, Volume, 0 Liter]
	]) /. Null -> 0Liter;

	(* Get the sterility and light sensitivity of our sample. *)
	sterile=TrueQ[Lookup[realSamplePacket, Sterile]];
	lightSensitive=TrueQ[Lookup[realSamplePacket, LightSensitive]];

	(* Get all of the preferred vessels that can hold the volume of our sample. *)
	preferredContainers=ToList[PreferredContainer[sampleAmount, Sterile -> sterile, LightSensitive -> lightSensitive, All -> True, Type -> All]];

	(* Get a packet for each of our preferred vessels. *)
	preferredContainerPackets=Download[preferredContainers, Packet[Object, Dimensions, SelfStanding], Cache -> cache];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[AliquotContainers, expandedSafeOps];

	(* Map over our instruments. *)
	results=MapThread[Function[{instrumentPacket, mapThreadOptions},
		(* Get the positions from our packet. *)
		positions=Lookup[instrumentPacket, Positions];

		(* Get all of the unique MaxWidth and MaxDepth positions in this model. *)
		uniqueFootprints=DeleteDuplicates[Lookup[positions, {MaxWidth, MaxDepth, MaxHeight}]];

		(* Define a tolerance since container parameterization isn't perfect. *)
		wiggleRoom=Lookup[mapThreadOptions, Tolerance];

		(* If MinWidth is set, filter our preferred containers by this MinWidth. *)
		filteredPreferredContainerPackets=If[MatchQ[Lookup[mapThreadOptions, MinWidth], Null],
			preferredContainerPackets,
			Cases[preferredContainerPackets,
				KeyValuePattern[
					Dimensions -> {
						Null | GreaterEqualP[Lookup[mapThreadOptions, MinWidth]],
						_,
						_
					}
				]
			]
		];

		(* Get the dimensions of each of our preferred vessels. *)
		preferredContainerDimensions = Lookup[filteredPreferredContainerPackets, Dimensions, {}];
		preferredContainerSelfStandingBools = Lookup[filteredPreferredContainerPackets, SelfStanding, {}];

		(* Filter our vessels by the ones that can fit onto one of the positions on our instrument. *)
		filterBooleans= MapThread[
			Function[
				{containerDimensions, containerSelfStanding},
				And[
					(* Is this preferred vessel able to fit on a position of this instrument? *)
					Length[
						Cases[
							uniqueFootprints,
							(* Are we looking for a direct footprint match? *)
							If[Lookup[mapThreadOptions, ExactMatch],
								{
									Null | RangeP[containerDimensions[[1]] - wiggleRoom, containerDimensions[[1]] + wiggleRoom],
									Null | RangeP[containerDimensions[[2]] - wiggleRoom, containerDimensions[[2]] + wiggleRoom],
									Null | RangeP[containerDimensions[[3]] - wiggleRoom, containerDimensions[[3]] + wiggleRoom]
								},
								{
									Null | GreaterEqualP[containerDimensions[[1]] - wiggleRoom],
									Null | GreaterEqualP[containerDimensions[[2]] - wiggleRoom],
									Null | GreaterEqualP[containerDimensions[[3]] - wiggleRoom]
								}
							]
						]
					] > 0,
					(* if self standing option is specified, make sure we pick the containers that meets the requirement *)
					Or[
						NullQ[Lookup[mapThreadOptions, SelfStanding]],
						MatchQ[containerSelfStanding, Lookup[mapThreadOptions, SelfStanding]]
					]
				]
			],
			{preferredContainerDimensions, preferredContainerSelfStandingBools}
		];

		(* Filter our vessels based on these boolean computations. *)
		PickList[
			Lookup[filteredPreferredContainerPackets, Object, {}],
			filterBooleans
		]
	], {instrumentPackets, mapThreadFriendlyOptions}];

	(* If we were not given a list an input, de-list the result. *)
	If[MatchQ[myLocationObjs, {ObjectP[Model[Instrument]]..}],
		results,
		First[results]
	]
];


(* ::Subsection::Closed:: *)
(*RackFinder*)

DefineOptions[RackFinder,
	Options:>{
		{
			OptionName->ReturnAllRacks,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the function should return a single rack model or all compatible racks for each input object."
		},
		{
			OptionName->RequireSinglePositionPosition,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the function should return a rack that contains only single position."
		},
		{
			OptionName->ThermalConductiveRack,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the function should return a rack that is made of thermally conductive material."
		},
		{
			OptionName->MaxDepthMargin,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterEqualP[0.0 Millimeter],
				Units->Millimeter
			],
			Description->"The maximum distance allowed between the bottom of the returned rack model and the inside bottom of its first position."
		},
		CacheOption,
		SimulationOption
	}
];

Warning::RackNotFound="RackFinder was unable to find a compatible rack for the objects: `1`.";

RackFinder[
	myInputs : ListableP[ObjectP[{Object[Sample], Object[Container], Model[Container]}]],
	myOptions : OptionsPattern[]
] := Module[
	{
		listedInputs, listedObjects, listOfRacks, listsOfBools, indices, inputSamples, inputContainers, inputContainerModels,
		safeOps, cache, simulation, rawSamplePackets, rawContainerPackets, rawContainerModelPackets, rackPackets, newCache,
		compatibleRacks, containersWithNoRack, inputSamplesFootprints, inputContainersFootprints, inputContainerModelFootprints,
		inputSamplesMatchingFootprints, inputContainerMatchingFootprints, inputContainerModelMatchingFootprints,
		compFootprintQListOfRacks, rackAvailabilities, singleRackQ, rackPacketsNotFlat, rackAvailabilitiesNotFlat,
		countList, countLookup, modelsToReturn, output, commonRackLookup, commonFootprintToRackLookup, conductiveRackQ,
		maxDepthMargin
	},

	(* Ensure that options and samples are in a list, and have no temporal links *)
	listedInputs = First[removeLinks[ToList[myInputs], {}]];

	(* make sure all objects are in object reference form *)
	listedObjects = Download[listedInputs, Object];

	(* Check if all options match their patterns *)
	safeOps = SafeOptions[RackFinder, ToList[myOptions], AutoCorrect -> False];

	(* get cache and simulation from options *)
	{cache, simulation, output, singleRackQ, conductiveRackQ, maxDepthMargin} = Lookup[
		safeOps,
		{Cache, Simulation, ReturnAllRacks, RequireSinglePositionPosition, ThermalConductiveRack, MaxDepthMargin}
	];


	(* group objects based on types *)
	inputSamples = Cases[listedObjects, ObjectReferenceP[Object[Sample]]];
	inputContainers = Cases[listedObjects, ObjectReferenceP[Object[Container]]];
	inputContainerModels = Cases[listedObjects, ObjectReferenceP[Model[Container]]];

	(* define lookup tables that contain rack models for commonly used CONTAINERS *)
	commonRackLookup = {
		(*15mL Tube*)
		Model[Container, Vessel, "id:xRO9n3vk11pw"] -> Model[Container, Rack, "id:R8e1PjRDbbo7"],
		(*50mL Tube*)
		Model[Container, Vessel, "id:bq9LA0dBGGR6"] -> Model[Container, Rack, "id:GmzlKjY5EEdE"],
		(*2mL Tube - MicrocentrifugeTube*)
		Model[Container, Vessel, "id:3em6Zv9NjjN8"] -> Model[Container, Rack, "id:vXl9j57WEJ8Z"],
		(*1.5mL Tube with 2mL Tube Skirt - MicrocentrifugeTube*)
		Model[Container, Vessel, "id:eGakld01zzpq"] -> Model[Container, Rack, "id:vXl9j57WEJ8Z"],
		(*0.5mL Tube with 2mL Tube Skirt - MicrocentrifugeTube*)
		Model[Container, Vessel, "id:o1k9jAG00e3N"] -> Model[Container, Rack, "id:vXl9j57WEJ8Z"]
	};

	(* define lookup tables that contain rack models for commonly used FOOTPRINTS *)
	commonFootprintToRackLookup = {
		Conical15mLTube -> Model[Container, Rack, "id:R8e1PjRDbbo7"], (*15mL Tube Stand*)
		Conical50mLTube -> Model[Container, Rack, "id:GmzlKjY5EEdE"], (*50mL Tube Stand*)
		MicrocentrifugeTube -> Model[Container, Rack, "id:vXl9j57WEJ8Z"], (*2mL Tube Stand*)
		Round9mLOptiTube -> Model[Container, Rack, "id:n0k9mG8EWdNp"],
		Round32mLOptiTube -> Model[Container, Rack, "id:GmzlKjY5EEdE"],
		Round94mLUltraClearTube -> Model[Container, Rack, "id:zGj91a7NxY1j"]
	};

	If[
		(* case where inputs only have the Model[Container,Vessel]s listed in commonRackLookup keys *)
		ContainsOnly[listedObjects, Keys[commonRackLookup]] && Not[TrueQ[conductiveRackQ]] && Not[MatchQ[maxDepthMargin, DistanceP]] && Not[TrueQ[output]],
		Module[{replacedListedObjects},
			replacedListedObjects = listedObjects /. commonRackLookup;
			If[MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1,
				First[replacedListedObjects],
				replacedListedObjects
			]
		],
		(* Else, case where inputs only have the Model[Container,Vessel]s listed in commonRackLookup keys OR have to do big download if thats not true*)
		Module[{rawSamplePacketsNotFlat, rawContainerPacketsNotFlat, rawContainerModelPacketsNotFlat,
			objectSamplesToFootprintLookup, objectContainersToFootprintLookup, modelContainersToFootprintLookup, replacedListedObjectsWithFootprints},

			(* Download all information *)
			{
				rawSamplePacketsNotFlat,
				rawContainerPacketsNotFlat,
				rawContainerModelPacketsNotFlat
			} = Download[
				{
					(* input Object[Sample]s *)
					inputSamples,
					(* input Object[Container]s *)
					inputContainers,
					(* input Model[Container]s *)
					inputContainerModels
				},
				{
					(* first two for tracing back to input samples *)
					{
						Packet[Container, Name],
						Packet[Container[Model]],
						Packet[Container[Model][{Dimensions, Footprint, ContainerMaterials}]]
					},
					{
						Packet[Model, Name],
						Packet[Model[{Dimensions, Footprint, ContainerMaterials}]]
					},
					{
						Packet[Dimensions, Footprint, Name, ContainerMaterials]
					}
				}
			];
			(* create a lookup of rawPackets' Object -> Footprint*)
			objectSamplesToFootprintLookup = If[Length[inputSamples] > 0,
				(Lookup[#[[1]], Object] -> Lookup[#[[3]], Footprint])& /@ rawSamplePacketsNotFlat,
				{}
			];

			(* create a lookup of rawPackets' Object -> Footprint*)
			objectContainersToFootprintLookup = If[Length[inputContainers] > 0,
				(Lookup[#[[1]], Object] -> Lookup[#[[2]], Footprint])& /@ rawContainerPacketsNotFlat,
				{}
			];

			(* create a lookup of rawPackets' Object -> Footprint*)
			modelContainersToFootprintLookup = If[Length[inputContainerModels] > 0,
				(Lookup[#, Object] -> Lookup[#, Footprint])& /@ rawContainerModelPacketsNotFlat,
				{}
			];

			(* replace listedObjects with all of replace rules just previously made *)
			replacedListedObjectsWithFootprints = listedObjects /. (Flatten[{objectSamplesToFootprintLookup, objectContainersToFootprintLookup, modelContainersToFootprintLookup}]);
			(* check if all footprints are only part of it *)
			If[ContainsOnly[replacedListedObjectsWithFootprints, Keys[commonFootprintToRackLookup]] && Not[TrueQ[conductiveRackQ]] && Not[MatchQ[maxDepthMargin, DistanceP]] && Not[TrueQ[output]],
				(* if they are, return the replace rule *)
				Module[{replacedList},
					replacedList = replacedListedObjectsWithFootprints /. commonFootprintToRackLookup;
					If[MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1,
						First[replacedList],
						replacedList
					]
				],
				(* else, copy paste all old code below into this else case - need to do big download there *)
				Module[{},
					(* search for all available rack models *)
					(* sort listOfRacks to make this function somewhat deterministic *)
					listOfRacks = Sort[Search[Model[Container, Rack], Deprecated != True]];

					(* download *)
					{
						(*rackPackets are stuff for CompatibleFootprintQ*)
						rackPacketsNotFlat,
						rackAvailabilitiesNotFlat
					} = Quiet[
						Download[
							{
								listOfRacks,
								listOfRacks
							},
							{
								{
									Packet[Object, Dimensions, Footprint, Positions, ContainerMaterials, DepthMargin]
								},
								{
									Packet[Objects[Status]]
								}
							},
							Cache -> cache,
							Simulation -> simulation
						], {Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField, Download::ObjectDoesNotExist}
					];

					(* clean up downloaded packets *)
					{
						rawSamplePackets, rawContainerPackets, rawContainerModelPackets, rackPackets
					} = Flatten /@ {
						rawSamplePacketsNotFlat, rawContainerPacketsNotFlat, rawContainerModelPacketsNotFlat, rackPacketsNotFlat
					};
					rackAvailabilities = Flatten /@ rackAvailabilitiesNotFlat;

					(* creating new cache for CompatibleFootprintQ *)
					newCache = Experiment`Private`FlattenCachePackets[{rawSamplePackets, rawContainerPackets, rawContainerModelPackets, rackPackets}];
					(*tolerances = Lookup[#,Tolerance]&/@rackPackets;*)

					(* now filter listOfRacks that only have same positions footprint as inputs footprints, filter corresponding rackPackets as well *)
					(*get inputSamples, inputContainers and inputContainerModels footprints*)
					inputSamplesFootprints = If[Length[rawSamplePackets] > 0,
						Lookup[rawSamplePackets, Footprint, Nothing],
						{}
					];

					inputContainersFootprints = If[Length[rawContainerPackets] > 0,
						Lookup[rawContainerPackets, Footprint, Nothing],
						{}
					];

					inputContainerModelFootprints = If[Length[rawContainerModelPackets] > 0,
						Lookup[#, Footprint]& /@ (rawContainerModelPackets),
						{}
					];

					(* Go through each list of footprints and filter out listOfRacks/rackPackets that have same footprints
					for inputSamples, inputContainers and inputContainerModels *)
					{
						inputSamplesMatchingFootprints,
						inputContainerMatchingFootprints,
						inputContainerModelMatchingFootprints
					} = Transpose[
						Map[
							Function[{rackPacket},
								Module[{positions, materials, depthMargin, footprints, numPositionQ, conductiveQ, depthMarginQ},

									(*Get positions*)
									{positions, materials, depthMargin} = Lookup[rackPacket, {Positions, ContainerMaterials, DepthMargin}];

									(*Get footprints*)
									footprints = DeleteDuplicates[Lookup[positions, Footprint, {}]];

									(* what if we want the return the rack that can hold only one rack *)
									numPositionQ = If[singleRackQ, (Length[positions] == 1), True];

									(* check if we want a conductive rack *)
									conductiveQ = If[conductiveRackQ, MemberQ[materials, StainlessSteel | Aluminum], True];

									(* Set a boolean indicating whether this rack satisfies the MaxDepthMargin option *)
									depthMarginQ = Switch[{maxDepthMargin, depthMargin},

										(* If MaxDepthMargin is specified and the DepthMargin of this rack is populated, then
										return True if the rack's DepthMargin is less than or equal to the MaxDepthMargin option *)
										{DistanceP, DistanceP}, depthMargin <= maxDepthMargin,

										(* If MaxDepthMargin is specified and the DepthMargin of this rack is Null, return False *)
										{DistanceP, _}, False,

										(* If MaxDepthMargin is not specified, return True regardless of the rack's DepthMargin *)
										{_, _}, True
									];

									Map[
										If[
											And[
												ContainsAny[footprints, #],
												!MatchQ[positions, {}],
												numPositionQ,
												conductiveQ,
												depthMarginQ
											],
											Lookup[rackPacket, Object],
											Null
										]&,
										{inputSamplesFootprints, inputContainersFootprints, inputContainerModelFootprints}
									]
								]
							],
							rackPackets
						]
					] /. Null -> Nothing;

					(* construct the listOfRacks to put into first argument of CompatibleFootprintQ, want to maintain order of listedObjects *)
					compFootprintQListOfRacks = Map[
						Function[{object},
							Which[
								MatchQ[object, ObjectReferenceP[Object[Sample]]],
								inputSamplesMatchingFootprints,

								MatchQ[object, ObjectReferenceP[Object[Container]]],
								inputContainerMatchingFootprints,

								MatchQ[object, ObjectReferenceP[Model[Container]]],
								inputContainerModelMatchingFootprints
							]
						],
						listedObjects
					];

					(* throw a warning and return early if there is no potential rack to check with CompatibleFootprintQ *)
					(* TODO: revisit to make sure we don't crash any function calling RackFinder with these return values *)
					If[MatchQ[Flatten@compFootprintQListOfRacks, {}],
						Return[
							Which[
								MatchQ[output, False] && MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1, Null,
								MatchQ[output, True] && MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1, Null,
								MatchQ[output, False], {},
								True, {}
							]
						]
					];

					(*return first rack that is True with CompatibleFootprintQ*)
					listsOfBools = CompatibleFootprintQ[
						(*list of potential matching racks*)
						compFootprintQListOfRacks,
						(*list of input object[sample],object[container] or model[container]*)
						listedObjects,
						(*Tolerance->tolerances,*)
						FlattenOutput -> False,
						Cache -> newCache
					];

					(* get indices of True *)
					indices = Position[#, True]& /@ listsOfBools;

					(* map over the list of indices to extract the first compatible rack for each input object *)
					(* if returning Null, it means there is no compatible model rack*)
					compatibleRacks = MapThread[
						If[Length[#1] > 0,
							Extract[#2, #1]
						]&,
						{indices, compFootprintQListOfRacks}
					];

					(* create a lookup for each rack model's objects count *)
					countList = Count[#, KeyValuePattern[Status -> Available]]& /@ rackAvailabilities;
					countLookup = AssociationThread[listOfRacks, countList];

					(* for each input object, get the compatible model with the most availability *)
					modelsToReturn = Map[
						FirstOrDefault@Keys@ReverseSort[KeyTake[countLookup, #]]&,
						compatibleRacks
					];

					(* throw a warning for inputs without found racks *)
					containersWithNoRack = PickList[listedObjects, indices, Null];
					(*If[Length[containersWithNoRack]!=0,
                        Message[Warning::RackNotFound,containersWithNoRack]
                    ];*)

					(* TODO: write comment please *)
					Which[
						MatchQ[output, False] && MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1, First[modelsToReturn],
						MatchQ[output, True] && MatchQ[myInputs, Except[_List]] && Length[listedInputs] == 1, First[compatibleRacks],
						MatchQ[output, False], modelsToReturn,
						True, compatibleRacks
					]

				]
			]
		]
	]

];
