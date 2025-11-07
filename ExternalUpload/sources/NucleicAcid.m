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
		InvalidOptions -> {},
		Tests -> {}
	|>
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadNucleicAcidModelOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{myOptionsAssociation, myOptionsWithName, myOptionsWithMolecularWeight, myOptionsWithSharedResolution,
		myOptionsWithEnthalpy, myOptionsWithEntropy, myOptionsWithFreeEnergy, myFinalizedOptions, myStructure,
		myOptionsWithSynonyms, myOptionsWithExtinctionCoefficients, myOptionsWithSimpleDefaults},

	(* Pull our things from our options. *)
	myStructure=Lookup[myOptions, Molecule];

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null. *)
	myOptionsWithName=If[MatchQ[Lookup[myOptionsAssociation, Name], Alternatives[Null, Automatic]],
		Append[myOptionsAssociation, Name -> myName],
		myOptionsAssociation
	];

	(* Overwrite the MolecularWeight option if it is Automatic. *)
	myOptionsWithMolecularWeight=If[MatchQ[Lookup[myOptionsAssociation, MolecularWeight], Alternatives[Null, Automatic]] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[{molecularWeight=Quiet[MolecularWeight[myStructure]]},
			If[MatchQ[molecularWeight, MolecularWeightP],
				Append[myOptionsWithName, MolecularWeight -> molecularWeight],
				Append[myOptionsWithName, MolecularWeight -> Null]
			]
		],
		myOptionsWithName
	];

	(* Overwrite the Enthalpy option if it is Automatic. *)
	myOptionsWithEnthalpy=If[MatchQ[Lookup[myOptionsAssociation, Enthalpy], Alternatives[Null, Automatic]] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
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
	myOptionsWithEntropy=If[MatchQ[Lookup[myOptionsAssociation, Entropy], Alternatives[Null, Automatic]] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
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
	myOptionsWithFreeEnergy=If[MatchQ[Lookup[myOptionsAssociation, FreeEnergy], Alternatives[Null, Automatic]] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
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
	myOptionsWithExtinctionCoefficients=If[MatchQ[Lookup[myOptionsAssociation, ExtinctionCoefficients], Alternatives[Null, Automatic]] && MatchQ[myStructure, _?StructureQ | _?StrandQ],
		With[{extinctionCoefficient=Quiet[ExtinctionCoefficient[myStructure]]},
			If[MatchQ[extinctionCoefficient, GreaterP[Quantity[0, ("Liters") / ("Centimeters" * "Moles")]]],
				Append[myOptionsWithFreeEnergy, ExtinctionCoefficients -> {{260 Nanometer, extinctionCoefficient}}],
				Append[myOptionsWithFreeEnergy, ExtinctionCoefficients -> Null]
			]
		],
		myOptionsWithEntropy
	];

	(* Default simple options *)
	myOptionsWithSimpleDefaults = Module[
		{simpleOptionDefaults, modifications},

		(* List of values to default Automatic to *)
		simpleOptionDefaults = <|
			State -> Solid,
			Flammable -> False,
			BiosafetyLevel -> "BSL-1",
			MSDSFile -> NotApplicable,
			IncompatibleMaterials -> {None}
		|>;

		(* For each of the automatic options in the association pull out the default values (if there is one) *)
		modifications = KeyTake[
			simpleOptionDefaults,
			Keys[Select[myOptionsAssociation, MatchQ[#, Automatic] &]]
		];

		(* Merge in the changes *)
		Merge[
			{myOptionsWithExtinctionCoefficients, modifications},
			Last
		]
	];

	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myOptionsWithSynonyms=If[MatchQ[Lookup[myOptionsWithSimpleDefaults, Synonyms], Alternatives[Null, Automatic]] || (!MemberQ[Lookup[myOptionsWithSimpleDefaults, Synonyms], Lookup[myOptionsWithSimpleDefaults, Name]] && MatchQ[Lookup[myOptionsWithSimpleDefaults, Name], _String]),
		Append[myOptionsWithSimpleDefaults, Synonyms -> (Append[Lookup[myOptionsWithSimpleDefaults, Synonyms] /. Alternatives[Null, Automatic] -> {}, Lookup[myOptionsWithSimpleDefaults, Name]])],
		myOptionsWithSimpleDefaults
	];

	(* Resolve any shared options that need custom resolution *)
	myOptionsWithSharedResolution = Module[
		{customResolvedSharedOptions},

		(* Resolve any options within the shared option sets that need custom handling *)
		customResolvedSharedOptions = resolveCustomSharedUploadOptions[myOptionsWithSynonyms];

		(* Merge the newly resolved options into the option set *)
		Join[myOptionsWithSynonyms, customResolvedSharedOptions]
	];

	(* Default key options *)
	myFinalizedOptions = Replace[
		myOptionsWithSharedResolution,
		Automatic -> Null,
		{1}
	];

	(* Return our options. *)
	Normal[myFinalizedOptions]
];


(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadNucleicAcidModelOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=resolveDefaultUploadFunctionOptions[myType, myInput, myOptions, rawOptions];
