(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*DownloadUnitOperation*)
(* NOTE: This should be REMOVED as soon as we have alternative class support in fields and UnitOperation no longer does this. *)
(* NOTE: Since this is a workaround (and should be removed as soon as possible), we don't support all of the fancy syntax that *)
(* Download does w.r.t. index matching. *)
DownloadUnitOperation[myObject:unitOperationObjectP|unitOperationAbbreviatedLinkP, myField_]:=First@DownloadUnitOperation[{myObject}, myField];
DownloadUnitOperation[myObjects:{(unitOperationObjectP|unitOperationAbbreviatedLinkP)..}, myField_]:=Module[
	{listedObjects, types, allFieldsForTypes, fieldsDontExistQ, objectsExistQ, validObjects, validObjectsPositions, validObjectsNormalized, normalizedObjectToValue},

	(* Get a listed form of our objects. *)
	listedObjects=Download[ToList[myObjects], Object];

	(* Make sure that our field exists for each of our objects. *)
	types=Download[listedObjects, Type];

	(* These are the fields that are created by combining the split fields together but don't actually exist in the *)
	(* types. *)
	allFieldsForTypes=(Join[Keys[getUnitOperationsSplitFieldsLookup[#]], Fields[#, Output->Short]]&)/@types;

	(* Figure out which fields don't exist in the object types at all so we can return $Failed. *)
	fieldsDontExistQ=(!MemberQ[#, myField]&)/@allFieldsForTypes;
	If[MemberQ[fieldsDontExistQ, True],
		Message[
			Download::FieldDoesntExist,
			myField,
			Extract[listedObjects, Position[fieldsDontExistQ, True]]
		]
	];

	(* Find the objects that don't exist. *)
	objectsExistQ=DatabaseMemberQ[listedObjects];
	If[MemberQ[objectsExistQ, False],
		Message[
			Download::ObjectDoesNotExist,
			Extract[listedObjects, Position[objectsExistQ, False]]
		]
	];

	(* For each object, figure out the field (or fields) that we should download from it. *)
	validObjectsPositions=Position[MapThread[!#1&&#2&, {fieldsDontExistQ, objectsExistQ}], True];
	validObjects=Extract[listedObjects, validObjectsPositions];
	validObjectsNormalized=Download[validObjects, Object];

	(* Figure out what the correct value of the given field is for our normalized objects that exist. *)
	normalizedObjectToValue=Module[{validObjectsNormalizedNoDuplicates, packetSyntaxForObjects, downloadInformation},
		(* DeleteDuplicates to save work. *)
		validObjectsNormalizedNoDuplicates=DeleteDuplicates[validObjectsNormalized];

		(* Create our packet syntax from which to download with. *)
		packetSyntaxForObjects=(
			Module[{splitFieldsLookup},
				splitFieldsLookup=getUnitOperationsSplitFieldsLookup[Download[#, Type]];

				If[KeyExistsQ[splitFieldsLookup, myField],
					Packet[Sequence@@Lookup[splitFieldsLookup, myField]],
					Packet[myField]
				]
			]
		&)/@validObjectsNormalizedNoDuplicates;

		(* Download. *)
		downloadInformation=Flatten@Download[List/@validObjectsNormalizedNoDuplicates, Evaluate[List/@packetSyntaxForObjects]];

		(* Stich batch together split fields. *)
		MapThread[
			Function[{object, packetSyntax, packet},
				object->If[KeyExistsQ[packet, myField],
					Lookup[packet, myField],
					Module[{splitFieldValues, safeSplitFieldValues, recombinedValue},
						(* Transpose our split fields together. *)
						splitFieldValues=(ToList[Lookup[packet, #]]&)/@List@@packetSyntax;

						(* NOTE: Our split field values may not be of the same length. Make them the same length in the case we have {}. *)
						(* Developers may forget to fill out the other split fields if they're just using one of them. *)
						safeSplitFieldValues=If[Length[DeleteDuplicates[Length/@splitFieldValues]]==1,
							splitFieldValues,
							Module[{longestSplitFieldValue},
								longestSplitFieldValue=Max[Length/@splitFieldValues];

								(If[MatchQ[#, {}], ConstantArray[Null, longestSplitFieldValue], #]&)/@splitFieldValues
							]
						];

						(FirstCase[#, Except[Null], Null]&)/@Transpose[safeSplitFieldValues]
					]
				]
			],
			{validObjects, packetSyntaxForObjects, downloadInformation}
		]
	];

	ReplacePart[
		(* Objects that don't exist or don't contain this field should return $Failed. *)
		ConstantArray[$Failed, Length[listedObjects]],
		(* Replace objects with their normalized form. *)
		Rule@@@Transpose[{validObjectsPositions, validObjectsNormalized}]
		(* Replace normalized objects with their stitched field value. *)
	]/.normalizedObjectToValue
];