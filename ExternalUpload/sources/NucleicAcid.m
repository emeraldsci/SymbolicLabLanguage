(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*resolveUploadNucleicAcidModelOptions*)


(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
(* This is a basic legacy resolver that doesn't throw messages, so can just map over all the inputs *)
resolveUploadNucleicAcidModelOptions[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
	{result},

	(* Map over the singleton function - this is legacy code *)
	result = MapThread[resolveUploadNucleicAcidModelOptions[myType, #1, #2, #3] &, {myInput, myOptions, rawOptions}];

	(* Return the output in the expected format *)
	<|
		Result -> result,
		InvalidInputs -> {},
		InvalidOptions -> {}
	|>
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadNucleicAcidModelOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{outputOption, myOptionsAssociation, myOptionsWithName, myOptionsWithMolecularWeight,
		myOptionsWithEnthalpy, myOptionsWithEntropy, myOptionsWithFreeEnergy, myFinalizedOptions, myStructure,
		myOptionsWithExtinctionCoefficients},

	(* Pull our things from our options. *)
	myStructure=Lookup[myOptions, Molecule];

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null. *)
	myOptionsWithName=If[MatchQ[Lookup[myOptionsAssociation, Name], Null],
		Append[myOptionsAssociation, Name -> myName],
		myOptionsAssociation
	];

	(* Overwrite the MolecularWeight option if it is Automatic. *)
	myOptionsWithMolecularWeight=If[MatchQ[Lookup[myOptionsAssociation, MolecularWeight], Null] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[{molecularWeight=Quiet[MolecularWeight[myStructure]]},
			If[MatchQ[molecularWeight, MolecularWeightP],
				Append[myOptionsWithName, MolecularWeight -> molecularWeight],
				Append[myOptionsWithName, MolecularWeight -> Null]
			]
		],
		myOptionsWithName
	];

	(* Overwrite the Enthalpy option if it is Automatic. *)
	myOptionsWithEnthalpy=If[MatchQ[Lookup[myOptionsAssociation, Enthalpy], Null] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[
			{
				enthalpy=Quiet[
					Lookup[
						(* Make sure we quiet all messages for global message tracking *)
						Block[{Message[msg_, vars___]:=Null},
							SimulateEnthalpy[myStructure, Upload -> False]
						],
						Enthalpy
					]
				]
			},
			If[MatchQ[enthalpy, UnitsP[Quantity[1, Times["KilocaloriesThermochemical", Power["Moles", -1]]]]],
				Append[myOptionsWithMolecularWeight, Enthalpy -> enthalpy],
				Append[myOptionsWithMolecularWeight, Enthalpy -> Null]
			]
		],
		myOptionsWithMolecularWeight
	];

	(* Overwrite the Entropy option if it is Automatic. *)
	myOptionsWithEntropy=If[MatchQ[Lookup[myOptionsAssociation, Entropy], Null] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[
			{
				entropy=Quiet[
					Lookup[
						Block[{Message[msg_, vars___]:=Null},
							SimulateEntropy[myStructure, Upload -> False]
						],
						Entropy
					]
				]
			},
			If[MatchQ[entropy, EntropyP],
				Append[myOptionsWithEnthalpy, Entropy -> entropy],
				Append[myOptionsWithEnthalpy, Entropy -> Null]
			]
		],
		myOptionsWithEnthalpy
	];

	(* Overwrite the FreeEnergy option if it is Automatic. *)
	myOptionsWithFreeEnergy=If[MatchQ[Lookup[myOptionsAssociation, FreeEnergy], Null] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[
			{
				freeEnergy=Quiet[
					Lookup[
						Block[{Message[msg_, vars___]:=Null},
							SimulateFreeEnergy[myStructure, Upload -> False]
						],
						FreeEnergy
					]
				]
			},
			If[MatchQ[freeEnergy, UnitsP[Quantity[1, "KilocaloriesThermochemical" / "Moles"]]],
				Append[myOptionsWithEntropy, FreeEnergy -> freeEnergy],
				Append[myOptionsWithEntropy, FreeEnergy -> Null]
			]
		],
		myOptionsWithEntropy
	];

	(* Overwrite the ExtinctionCoefficients option if it is Automatic. *)
	myOptionsWithExtinctionCoefficients=If[MatchQ[Lookup[myOptionsAssociation, ExtinctionCoefficients], Null] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[{extinctionCoefficient=Quiet[ExtinctionCoefficient[myStructure]]},
			If[MatchQ[extinctionCoefficient, GreaterP[Quantity[0, ("Liters") / ("Centimeters" * "Moles")]]],
				Append[myOptionsWithFreeEnergy, ExtinctionCoefficients -> {{260 Nanometer, extinctionCoefficient}}],
				Append[myOptionsWithFreeEnergy, ExtinctionCoefficients -> Null]
			]
		],
		myOptionsWithEntropy
	];

	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myFinalizedOptions=If[MatchQ[Lookup[myOptionsWithExtinctionCoefficients, Synonyms], Null] || (!MemberQ[Lookup[myOptionsWithExtinctionCoefficients, Synonyms], Lookup[myOptionsWithExtinctionCoefficients, Name]] && MatchQ[Lookup[myOptionsWithExtinctionCoefficients, Name], _String]),
		Append[myOptionsWithExtinctionCoefficients, Synonyms -> (Append[Lookup[myOptionsWithExtinctionCoefficients, Synonyms] /. Null -> {}, Lookup[myOptionsWithExtinctionCoefficients, Name]])],
		myOptionsWithExtinctionCoefficients
	];

	(* Return our options. *)
	Normal[myFinalizedOptions]
];


(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadNucleicAcidModelOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=Module[
	{objectPacket, fields, resolvedOptions},

	(* Lookup our packet from our cache. *)
	objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]];

	(* Get the definition of this type. *)
	fields=Association@Lookup[LookupTypeDefinition[myType], Fields];

	(* For each of our options, see if it exists as a field of the same name in the object. *)
	resolvedOptions=Association@KeyValueMap[
		Function[{fieldSymbol, fieldValue},
			Module[{fieldDefinition, formattedOptionSymbol, formattedFieldValue},
				(* If field does not exist as an option do not include it in the resolved options *)
				If[!KeyExistsQ[myOptions, fieldSymbol],
					Nothing,

					(* If the user has specified this option, use that. *)
					If[KeyExistsQ[rawOptions, fieldSymbol],
						fieldSymbol -> Lookup[rawOptions, fieldSymbol],

						(* ELSE: Get the information about this specific field. *)
						fieldDefinition=Association@Lookup[fields, fieldSymbol];

						(* Strip off all links from our value. *)
						formattedFieldValue=ReplaceAll[fieldValue, link_Link :> RemoveLinkID[link]];

						(* Based on the class of our field, we have to format the values differently. *)
						Switch[Lookup[fieldDefinition, Class],
							Computable,
								Nothing,
							{_Rule..},
								fieldSymbol -> formattedFieldValue,
							_List,
								fieldSymbol -> formattedFieldValue[[All, 2]],
							_,
								fieldSymbol -> formattedFieldValue
						]
					]
				]
			]
		],
		Association@objectPacket
	];

	(* Return our resolved options as a list. *)
	Normal[resolvedOptions]
];
