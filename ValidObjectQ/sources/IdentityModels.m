(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelMoleculeQTests*)


validModelMoleculeQTests[packet : PacketP[Model[Molecule]]] := With[
	{
		chemicalIdentifier = FirstCase[Lookup[packet, {Name, MolecularFormula, IUPAC, CAS, UNII, InChI, InChIKey, Object}], Except[_Missing], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		],
		(* do this Search up front if we need to since AffinityLabelP[] goes slow *)
		affinityLabelP = If[!MatchQ[Lookup[packet, AffinityLabels], ({Null} | Null | {})], AffinityLabelP[], {}],
		(* do this Search up front if we need to since DetectionLabelP[] goes slow *)
		detectionLabelP = If[!MatchQ[Lookup[packet, DetectionLabels], ({Null} | Null | {})], DetectionLabelP[], {}],
		defaultSampleModelNotebookPacket = Download[packet, Packet[DefaultSampleModel[Notebook]]]
	},
	{

		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[chemicalIdentifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueObjectName],
			MessageArguments -> {chemicalIdentifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Density of solid or liquid must be \[GreaterEqual] density of liquid hydrogen *)
		Test["Density of any solid or liquid must be greater than that of liquid Hydrogen for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Null | Gas, _}, {Solid | Liquid | Consumable, Null | GreaterEqualP[Quantity[0.0708`, ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Density of solid or liquid must be \[LessEqual] density of hassium *)
		Test["Density of any solid or liquid must be less than that of Hassium for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Null | Gas, _}, {Solid | Liquid | Consumable, Null | LessEqualP[Quantity[40.7 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Density of any gas \[GreaterEqual] density of hydrogen gas *)
		Test["Density of any gas must be greater than that of Hydrogen gas for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Solid | Liquid | Consumable | Null, _}, {Gas, Null | GreaterEqualP[Quantity[0.00008988 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Density of any gas \[LessEqual] density of tungsten hexafluoride *)
		Test["Density of any gas must be less than that of tungsten hexafluoride gas for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, {State, Density}],
			Alternatives[{Solid | Liquid | Consumable | Null, _}, {Gas, Null | LessEqualP[Quantity[0.0124 , ("Grams") / ("Milliliters")]]}],
			Message -> Hold[Error::InvalidDensity],
			MessageArguments -> {chemicalIdentifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[chemicalIdentifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Shared field shaping *)
		NotNullFieldTest[packet, {State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {chemicalIdentifier}],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[chemicalIdentifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {chemicalIdentifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[chemicalIdentifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Tests that AffinityLabels and DetectionLabels conform to AffinityLableP and DetectionLabelP*)
		Module[{affinityLabelsList, patternConflictingBooleans, patternConflictingInputs, passingQ},

			affinityLabelsList = Lookup[packet, AffinityLabels];

			If[!MatchQ[affinityLabelsList, ({Null} | Null | {})],
				(
					patternConflictingBooleans = If[MemberQ[#, affinityLabelP], False, True]& /@ affinityLabelsList;
					patternConflictingInputs = PickList[affinityLabelsList, patternConflictingBooleans];

					(* decide if we are passing the test; this is important for what the MessageArguments is later (i.e., only put this if it is failing) *)
					passingQ = Length[patternConflictingInputs] === 0;

					Test["AffinityLabels conforms to AffinityLabelP:",
						passingQ,
						True,
						Message -> Hold[Error::AffinityLabelsDoNotConformToPattern],
						MessageArguments -> {StringTake[patternConflictingInputs // ToString, {2, -2}], If[Not[passingQ], StringTake[Search[Model[Molecule], AffinityLabel === True] // ToString, {2, -2}], Null]}
					]
				),
				Nothing
			]
		],
		Module[{detectionLabelsList, patternConflictingBooleans, patternConflictingInputs, passingQ},

			detectionLabelsList = Lookup[packet, DetectionLabels];

			If[!MatchQ[detectionLabelsList, ({Null} | Null | {})],

				patternConflictingBooleans = !MatchQ[#,detectionLabelP]& /@ detectionLabelsList;
				patternConflictingInputs = PickList[detectionLabelsList, patternConflictingBooleans];

				(* decide if we are passing the test; this is important for what the MessageArguments is later (i.e., only put this if it is failing) *)
				passingQ = Length[patternConflictingInputs] === 0;

				Test["DetectionLabels conforms to DetectionLabelP:",
					passingQ,
					True,
					Message -> Hold[Error::DetectionLabelsDoNotConformToPattern],
					MessageArguments -> {StringTake[patternConflictingInputs // ToString, {2, -2}], If[Not[passingQ], StringTake[Search[Model[Molecule], DetectionLabel === True] // ToString, {2, -2}]]}
				],
				Nothing
			]
		],


		(* Other tests *)
		Test["If MeltingPoint and BoilingPoint are both provided, BoilingPoint must be above MeltingPoint for " <> ToString[chemicalIdentifier] <> ":",
			Module[{meltingPoint, boilingPoint},
				{meltingPoint, boilingPoint} = Lookup[packet, {MeltingPoint, BoilingPoint}];
				If[!NullQ[meltingPoint] && !NullQ[boilingPoint],
					(meltingPoint) <= (boilingPoint),
					True
				]
			],
			True,
			Message -> Hold[Error::MeltingBoilingPoint],
			MessageArguments -> {chemicalIdentifier}
		],

		Test["If Monatomic is set to True, the MolecularFormula contains exactly one element.",
			Module[{formula, monatomic},
				{formula, monatomic} = Lookup[packet, {MolecularFormula, Monatomic}, $Failed];
				If[!MemberQ[{formula, monatomic}, $Failed] && MatchQ[monatomic, True],
					MatchQ[formula, ElementAbbreviationP],
					True
				]
			],
			True,
			Message -> Hold[Error::MoleculeIsNotMonatomic],
			MessageArguments -> {chemicalIdentifier}
		],

		RequiredTogetherTest[packet, {Fluorescent, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums}],

		Test["For each of the FluorescenceExcitationMaximums the corresponding FluorescenceEmissionMaximums are provided for " <> ToString[chemicalIdentifier] <> ":",
			Module[{exMaxs, emMaxs},
				{exMaxs, emMaxs} = Lookup[packet, {FluorescenceExcitationMaximums, FluorescenceEmissionMaximums}];
				If[!NullQ[exMaxs] && !NullQ[emMaxs],
					SameQ[Length@exMaxs, Length@emMaxs],
					True
				]
			],
			True,
			Message -> Hold[Error::FluorescenceFields],
			MessageArguments -> {chemicalIdentifier}
		],

		(* Chiral properties*)

		Test["If " <> ToString[chemicalIdentifier] <> " is a chiral molecule (Chiral -> True), please specify it's racemic form (in RacemicForm field) and non-superimposable mirror imaged form (in EnantiomerPair field):",
			Module[{chiral, racemicForm, enantiomerPair},
				{chiral, racemicForm, enantiomerPair} = Lookup[packet, {Chiral, RacemicForm, EnantiomerPair}];
				If[TrueQ[chiral],
					And[MatchQ[racemicForm, ObjectP[Model[Molecule]]], MatchQ[enantiomerPair, ObjectP[Model[Molecule]]]],
					True
				]
			],
			True
		],

		If[TrueQ[Lookup[packet, Chiral]],
			NullFieldTest[packet, {EnantiomerForms}],
			Nothing
		],

		Test["If " <> ToString[chemicalIdentifier] <> " is a racemic molecule (Racemic -> True), please specify it's enantiomer forms (2 in total) in EnantiomerForms field:",
			Module[{racemic, enantiomerForms},
				{racemic, enantiomerForms} = Lookup[packet, {Racemic, EnantiomerForms}];
				If[TrueQ[racemic],
					MatchQ[enantiomerForms, {ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}],
					True
				]
			],
			True
		],


		If[TrueQ[Lookup[packet, Racemic]],
			NullFieldTest[packet, {RacemicForm, EnantiomerPair}],
			Nothing
		],

		Test["If any of the chirality related fields (EnantiomerForms,RacemicForm,EnantiomerPair) are specified, please also specify either Chiral or Racemic field that " <> ToString[chemicalIdentifier] <> " racemic or chiral:",
			Module[{racemic, enantiomerForms, chiral, racemicForm, enantiomerPair, anyChiralityField},
				{racemic, enantiomerForms, chiral, racemicForm, enantiomerPair} = Lookup[packet, {Racemic, EnantiomerForms, Chiral, RacemicForm, EnantiomerPair}];
				anyChiralityField = Or[
					MatchQ[enantiomerForms, {ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}],
					MatchQ[racemicForm, ObjectP[Model[Molecule]]],
					MatchQ[enantiomerPair, ObjectP[Model[Molecule]]]
				];
				If[anyChiralityField,
					Or[TrueQ[racemic], TrueQ[chiral]],
					True
				]
			],
			True
		],

		Test["Chiral and Racemic cannot both be filled to True at the same time for " <> ToString[chemicalIdentifier] <> ":",
			Module[{chiral, racemic},
				{chiral, racemic} = Lookup[packet, {Chiral, Racemic}];
				If[!NullQ[chiral] && !NullQ[racemic],
					Or[(!chiral), (!racemic)],
					True
				]
			],
			True,
			Message -> Hold[Error::RacemicOrChiralMolecule],
			MessageArguments -> {chemicalIdentifier}
		],

		Test["If model is public and has DefaultSampleModel, it is public as well:",
			Or[
				MatchQ[Lookup[packet, Notebook], LinkP[Object[LaboratoryNotebook]]],
				MatchQ[Lookup[packet, DefaultSampleModel, Null], Null],
				!ProductionQ[],
				And[
					MatchQ[Lookup[packet, DefaultSampleModel], LinkP[]],
					MatchQ[Lookup[defaultSampleModelNotebookPacket, Notebook],Null]
				]
			],
			True
		]

	}
];

Error::NonUniqueObjectName="There already exists an object with the given name for input(s), `1`. Please choose a different name or use the already uploaded model.";
Error::AcidAndBase="Acid and Base are both set to True for input(s): `1`. Please change the value of one of these options in order to upload a valid object.";
Error::InvalidDensity="The density for the input(s), `1`, do not appear to be valid for the given State. Please ensure that the densities given are valid.";
Error::VentilatedRequired="The input(s), `1`, that are marked as Pungent must also be set to Ventilated->True. Please change the value of the Ventilated field.";
Error::MoleculeRequiredFields="The options {State, BiosafetyLevel, Name, Synonyms} are required for input(s), `1`. Please include these options to upload a valid object.";
Error::NameIsNotPartOfSynonyms="The Name option is not part of the Synonyms field, for the input(s) `1`. Please include the Name of the object as part of the Synonyms field.";
Error::RequiredMSDSOptions="If MSDSRequired isn't set to False, the fields {Flammable,MSDSFile,NFPA,DOTHazardClass} are requied for input(s): `1`. Please fill out the values of these fields in order to upload a valid object.";
Error::IncompatibleMaterials="The option IncompatibleMaterials must either be {None} or a list of incompatible materials for input(s): `1`. Please change the value of this option in order to upload a valid object.";
Error::MeltingBoilingPoint="The boiling point must be above the melting point for input(s): `1`. Please change the value of these options in order to upload a valid object.";
Error::FluorescenceFields="The FluorescenceExcitationMaximums and FluorescenceEmissionMaximums fields must be the same length for the input(s):`1`. For every provided fluorescence excitation maximum please provide the corresponding fluorescence emission maximum.";
Error::AffinityLabelsDoNotConformToPattern="The AffinityLabels `1` is not allowed. Allowed molecules for Affinity labels include `2`, whose AffinityLable->True.";
Error::DetectionLabelsDoNotConformToPattern="The DetectionLabels `1` is not allowed. Allowed molecules for Detection labels include `2`, whose DetectionLabel->True.";
Error::RacemicOrChiralMolecule="The molucule `1` cannot be both a racemic molecule and a chiral molecule at the same time. Please check the chirality of the molecule and set either one or both of Chiral or Racemic to be False.";
Error::MoleculeRequired = "Molecule was not specified for `1`, please make sure you specify a Molecule in order to upload it as Oligomer.";
Error::MoleculeIsNotMonatomic = "The specified MolecularFormula for `1` does not agree with Monatomic being True. Please check that molecule's formula contains only one element.";
Error::MoleculeIsMonatomic = "The specified MolecularFormula for `1` does not agree with Monatomic being False. Please check that molecule's formula contains only one element.";

errorToOptionMap[Model[Molecule]]:={
	"Error::NonUniqueObjectName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::InvalidDensity"->{Density},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{State, BiosafetyLevel, Name, Synonyms},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::MeltingBoilingPoint"->{MeltingPoint, BoilingPoint},
	"Error::FluorescenceFields"->{FluorescenceExcitationMaximums,FluorescenceEmissionMaximums},
	"Error::AffinityLabelsDoNotConformToPattern"->{AffinityLabels},
	"Error::DetectionLabelsDoNotConformToPattern"->{DetectionLabels}
};


(* ::Subsection::Closed:: *)
(*validModelMoleculecDNAQTests*)


validModelMoleculecDNAQTests[packet : PacketP[Model[Molecule, cDNA]]] := With[
	{identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]},
	{
		(*Not null*)
		NotNullFieldTest[
			packet,
			{BiosafetyLevel, Name, Synonyms, Cells, ReverseTranscriptaseBuffer, ReverseTranscriptaseEnzyme},
			Message -> Hold[Error::RequiredOptions],
			MessageArguments -> {identifier}
		],

		Test["The Molecular structure of the Nucleic Acid is required if its MolecularWeight is under 10 Kilogram/Mole::",
			Lookup[packet, {Molecule, MolecularWeight}],
			Alternatives[
				{MoleculeP | _?ECL`StructureQ | _?ECL`StrandQ, _},
				{_, GreaterEqualP[10 Kilogram / Mole]}
			],
			Message -> Hold[Error::MoleculeRequired],
			MessageArguments -> {identifier}
		]
	}
];

errorToOptionMap[Model[Molecule,cDNA]]:={
	"Error::RequiredOptions"->{BiosafetyLevel,Name,Synonyms,Cells,ReverseTranscriptaseBuffer,ReverseTranscriptaseEnzyme},
	"Error::MoleculeRequired"->{Molecule}
};


(* ::Subsection::Closed:: *)
(*validModelMoleculeOligomerQTests*)


validModelMoleculeOligomerQTests[packet : PacketP[Model[Molecule, Oligomer]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]
	},
	{
		(*Not null*)
		NotNullFieldTest[
			packet,
			{PolymerType, BiosafetyLevel, Name, Synonyms, MolecularWeight},
			Message -> Hold[Error::RequiredOptions],
			MessageArguments -> {identifier}
		],

		Test["The Molecular structure of the Nucleic Acid is required if its MolecularWeight is under 5 Kilogram/Mole::",
			Lookup[packet, {Molecule, MolecularWeight}],
			Alternatives[
				{MoleculeP | _?ECL`StructureQ | _?ECL`StrandQ, _},
				{_, GreaterEqualP[5 Kilogram / Mole]}
			],
			Message -> Hold[Error::MoleculeRequired],
			MessageArguments -> {identifier}
		],

		Test["The MolecularWeight matches the expected value calculated by MolecularWeight[]:",
			If[MatchQ[Lookup[packet, Molecule, Null], Null],
				True,
				RoundReals[Convert[Lookup[packet, MolecularWeight], Gram / Mole], 2]
			],
			If[MatchQ[Lookup[packet, Molecule, Null], Null],
				True,
				RoundReals[Convert[Total@ToList[MolecularWeight[Lookup[packet, Molecule]]], Gram / Mole], 2]
			],
			Message -> Hold[Error::InvalidMolecularWeight],
			MessageArguments -> {identifier}
		]
	}
];

errorToOptionMap[Model[Molecule, Oligomer]] := {
	"Error::RequiredOptions" -> {PolymerType, BiosafetyLevel, Name, Synonyms, MolecularWeight},
	"Error::MoleculeRequired" -> {Molecule},
	"Error::InvalidMolecularWeight" -> {MolecularWeight}
};


(* ::Subsection::Closed:: *)
(*validModelMoleculeTranscriptQTests*)


validModelMoleculeTranscriptQTests[packet : PacketP[Model[Molecule, Transcript]]] := With[
	{identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]},
	{
		(*Not null*)
		NotNullFieldTest[
			packet,
			{BiosafetyLevel, Name, Synonyms},
			Message -> Hold[Error::RequiredOptions],
			MessageArguments -> {identifier}
		],

		Test["The Molecular structure of the Nucleic Acid is required if its MolecularWeight is under 10 Kilogram/Mole::",
			Lookup[packet, {Molecule, MolecularWeight}],
			Alternatives[
				{MoleculeP | _?ECL`StructureQ | _?ECL`StrandQ, _},
				{_, GreaterEqualP[10 Kilogram / Mole]}
			],
			Message -> Hold[Error::MoleculeRequired],
			MessageArguments -> {identifier}
		]
	}
];

errorToOptionMap[Model[Molecule, Transcript]] := {
	"Error::RequiredOptions" -> {BiosafetyLevel, Name, Synonyms},
	"Error::MoleculeRequired" -> {Molecule}
};


(* ::Subsection::Closed:: *)
(*validModelMoleculeProteinQTests*)


validModelMoleculeProteinQTests[packet : PacketP[Model[Molecule, Protein]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]
	},
	{}
];

errorToOptionMap[Model[Molecule, Protein]] := {};

(* ::Subsection::Closed:: *)
(*validModelProprietaryFormulationQTests*)


validModelProprietaryFormulationQTests[packet : PacketP[Model[ProprietaryFormulation]]] := {};

errorToOptionMap[Model[ProprietaryFormulation]] := {};

(* ::Subsection::Closed:: *)
(*validModelMoleculeProteinAntibodyQTests*)


validModelMoleculeProteinAntibodyQTests[packet : PacketP[Model[Molecule, Protein, Antibody]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		secondaryAntibodySpecies = Download[Lookup[packet, SecondaryAntibodies], Species[Object]]
	},
	{
		Test["The Species of this antibody does not match the Species of any of its SecondaryAntibodies:",
			With[{species = Lookup[packet, Species]},
				If[
					Nor[
						MatchQ[species, NullP | {}],
						NullQ[MatchQ[secondaryAntibodySpecies, NullP | {}]]
					],
					Nor @@ (SameObjectQ[species, #]& /@ secondaryAntibodySpecies),
					True
				]
			],
			True,
			Message -> Hold[Error::SecondaryAntibodySpecies],
			MessageArguments -> {identifier}
		],
		Test["RecommendedDilution is specified if this antibody is suitable for western blotting:",
			If[MemberQ[Lookup[packet, AssayTypes], Western],
				!NullQ[Lookup[packet, RecommendedDilution]],
				True
			],
			True,
			Message -> Hold[Error::RequiredRecommendedDilution],
			MessageArguments -> {identifier}
		]
	}
];

Error::SecondaryAntibodySpecies="The species for the input(s), `1`, cannot be the same as the species for its SecondaryAntibodies. Please change the Species or SecondaryAntibodies option to upload a valid object.";
Error::RequiredRecommendedDilution="The RecommendedDilution option is required for the input(s), `1`, since they have been specified to be suitable for Western Blotting (via the AssayTypes option). Please specify a RecommendedDilution to upload a valid object.";

errorToOptionMap[Model[Molecule,Protein,Antibody]]:={
	Error::SecondaryAntibodySpecies->{Species,SecondaryAntibodies},
	Error::RequiredRecommendedDilution->{AssayTypes, RecommendedDilution}
};


(* ::Subsection::Closed:: *)
(*validModelMoleculeCarbohydrateQTests*)


validModelMoleculeCarbohydrateQTests[packet:PacketP[Model[Molecule,Carbohydrate]]]:=With[
	{identifier=FirstCase[Lookup[packet,{Name,Molecule}],Except[_Missing|Null],packet]},
	{}
];

errorToOptionMap[Model[Molecule,Carbohydrate]]:={};


(* ::Subsection::Closed:: *)
(*validModelMoleculePolymerQTests*)


validModelMoleculePolymerQTests[packet:PacketP[Model[Molecule,Polymer]]]:=With[
	{identifier=FirstCase[Lookup[packet,{Name,Molecule}],Except[_Missing|Null],packet]},
	{}
];

errorToOptionMap[Model[Molecule,Polymer]]:={};


(* ::Subsection::Closed:: *)
(*validModelResinQTests*)

Error::IncompleteLabels="The Labels field does not contain all elements from AffinityLabels and/or DetectionLabels.";

validModelResinQTests[packet : PacketP[Model[Resin]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueResinName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		(* Shared field shaping *)
		NotNullFieldTest[packet, {State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		],

		(* Other tests *)
		Test["If the resin has not been Download for " <> ToString[identifier] <> ", it needs to have Loading populated:",
			Lookup[packet, {Type, Loading}],
			Alternatives[
				{Model[Resin], Except[NullP]},
				{Model[Resin, SolidPhaseSupport], _}
			],
			Message -> Hold[Error::LoadingRequired],
			MessageArguments -> {identifier}
		],
		Test["Labels needs to have AffinityLabels and/or DetectionLabels:",
			Module[{affinityLabels, destinationLabels, labels, unionSet},
				{affinityLabels,destinationLabels,labels} = Lookup[packet,{AffinityLabels,DetectionLabels,Labels}]/.link_Link:>RemoveLinkID[link];
				unionSet=DeleteDuplicates@Flatten[{affinityLabels, destinationLabels}];
				ContainsExactly[unionSet,labels]
			],
			True,
			Message -> Hold[Error::IncompleteLabels]
		]
	}
];

Error::NonUniqueResinName="The name(s), `1`, are already taken for the type Model[Resin]. Please change the Name option for these inputs to upload a valid object.";
Error::LoadingRequired="The input(s), `1`, have not been Downloaded. Therefore, the Loading option must be specified for these input(s). If these resins have already been Downloaded, please upload a Model[Resin,SolidPhaseSupport] instead.";

errorToOptionMap[Model[Resin]]:={
	"Error::NonUniqueResinName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{State, BiosafetyLevel, Name, Synonyms},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::LoadingRequired"->{Loading}
};


(* ::Subsection::Closed:: *)
(*validModelResinSolidPhaseSupportQTests*)


validModelResinSolidPhaseSupportQTests[packet : PacketP[Model[Resin, SolidPhaseSupport]]] := With[
	{identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]},
	{
		Test["SourceResin is required for " <> ToString[identifier] <> " unless the resin is PreDownloaded:",
			Lookup[packet, {SourceResin, PreDownloaded}],
			{Except[NullP | {}], False | Null} | {NullP | {}, True},
			Message -> Hold[Error::SourceResinRequired],
			MessageArguments -> {identifier}
		],

		NotNullFieldTest[packet, {Strand}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}]
	}
];

Error::SourceResinRequired="Since the input(s), `1`, have already been Downloaded, the SourceResin option is required. Please specify this option to upload a valid model.";

errorToOptionMap[Model[Resin,SolidPhaseSupport]]:={
	"Error::SourceResinRequired"->{SourceResin},
	"Error::RequiredOptions"->{Strand, State, BiosafetyLevel, Name, Synonyms}
};


(* ::Subsection::Closed:: *)
(*validModelLysateQTests*)


validModelLysateQTests[packet : PacketP[Model[Lysate]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueLysateName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		(* Shared field shaping *)
		NotNullFieldTest[packet, {State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		],

		NotNullFieldTest[packet, {Cell}, Message :> Hold[Error::CellRequired], MessageArguments -> {identifier}]
	}
];

Error::NonUniqueLysateName="The name(s), `1`, are already taken for the type Model[Lysate]. Please change the Name option for these inputs to upload a valid object.";
Error::CellRequired="The Cell option is required for input(s), `1` in order to upload a valid object. Please specify the Cell option for these input(s).";

errorToOptionMap[Model[Lysate]]:={
	"Error::NonUniqueLysateName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::InvalidDensity"->{Density},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{State, BiosafetyLevel, Name, Synonyms},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::MeltingBoilingPoint"->{MeltingPoint, BoilingPoint},
	"Error::CellRequired"->{Cell}
};


(* ::Subsection::Closed:: *)
(*validModelVirusQTests*)


validModelVirusQTests[packet : PacketP[Model[Virus]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueVirusName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		],

		NotNullFieldTest[packet, {State, BiosafetyLevel, Name, Synonyms, GenomeType, Taxonomy, LatentState}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}]
	}
];

Error::NonUniqueVirusName="The name(s), `1`, are already taken for Model[Virus]. Please change the Name option for these inputs to upload a valid object.";
Error::RequiredVirusOptions="The options {GenomeType,Taxonomy,LatentState} are required for input(s), `1`. Please specify these options to upload a valid object.";

errorToOptionMap[Model[Virus]]:={
	"Error::NonUniqueVirusName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{State, BiosafetyLevel, Name, Synonyms,GenomeType,Taxonomy,LatentState},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::RequiredVirusOptions"->{GenomeType,Taxonomy,LatentState}
};


(* ::Subsection::Closed:: *)
(*validModelCellQTests*)


validModelCellQTests[packet : PacketP[Model[Cell]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		],
		(* do this Search up front if we need to since DetectionLabelP[] goes slow *)
		detectionLabelP = If[!MatchQ[Lookup[packet, DetectionLabels], ({Null} | Null | {})], DetectionLabelP[], {}]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueCellName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		],

		NotNullFieldTest[packet, {CellType, CultureAdhesion, State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["If provided, PreferredSplitThreshold must be less than PreferredMaxCellCount for " <> ToString[identifier] <> ":",
			Module[{preferredSplitThreshold, preferredMaxCellCount},
				{preferredSplitThreshold, preferredMaxCellCount} = Lookup[packet, {PreferredSplitThreshold, PreferredMaxCellCount}, Null];
				If[!MatchQ[preferredSplitThreshold, Null] && !MatchQ[preferredMaxCellCount, Null],
					preferredSplitThreshold < preferredMaxCellCount,
					True
				]
			],
			True,
			Message -> Hold[Error::SplitThresholdGreaterThanMaxCellCount],
			MessageArguments -> {identifier}
		],

		(* Tests that DetectionLabels conform to DetectionLabelP *)
		Module[{detectionLabelsList, patternConflictingBooleans, patternConflictingInputs, passingQ},

			(* get the list of DetectionLabels from our packet *)
			detectionLabelsList = Download[Lookup[packet, DetectionLabels], Object];

			If[!MatchQ[detectionLabelsList, ({Null} | Null | {})],
				(
					patternConflictingBooleans = !MatchQ[#,detectionLabelP]& /@ detectionLabelsList;
					patternConflictingInputs = PickList[detectionLabelsList, patternConflictingBooleans];

					(* decide if we are passing the test; this is important for what the MessageArguments is later (i.e., only put this if it is failing) *)
					passingQ = Length[patternConflictingInputs] === 0;

					Test["DetectionLabels conforms to DetectionLabelP:",
						passingQ,
						True,
						Message -> Hold[Error::DetectionLabelsDoNotConformToPattern],
						(* putting this Search in here for only if we are actually failing*)
						MessageArguments -> {StringTake[patternConflictingInputs // ToString, {2, -2}], If[Not[passingQ], StringTake[Search[Model[Molecule], DetectionLabel === True] // ToString, {2, -2}], Null]}
					]
				),
				Nothing
			]
		]
	}
];

Error::NonUniqueCellName="The name(s), `1`, are already taken for this type of Cell. Please change the Name option for these inputs to upload a valid object.";
Error::DetectionLabelsDoNotConformToPattern="The DetectionLabels `1` is not allowed. Allowed molecules for Detection labels include `2`, whose DetectionLabel->True.";

errorToOptionMap[Model[Cell]]:={
	"Error::NonUniqueCellName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials},
	"Error::RequiredOptions"->{State,BiosafetyLevel,Name,Synonyms},
	"Error::DetectionLabelsDoNotConformToPattern"->{DetectionLabels}
};


(* ::Subsection::Closed:: *)
(*validModelMammalianCellQTests*)


validModelMammalianCellQTests[packet : PacketP[Model[Cell, Mammalian]]] := With[
	{identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]},
	{}
];

errorToOptionMap[Model[Cell,Mammalian]]:={
};


(* ::Subsection::Closed:: *)
(*validModelBacterialCellQTests*)


validModelBacterialCellQTests[packet : PacketP[Model[Cell, Bacteria]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]
	},
	{
		Test["If the Morphology of the cell is non-Cocci, Cell Length should be informed:",
			Lookup[packet, {Morphology, CellLength}, Null],
			{Cocci, Null | {}} | {Except[Cocci], Except[Null | {}]},
			Message -> Hold[Error::CellLengthRequired],
			MessageArguments -> {identifier}
		]
	}
];

Error::CellLengthRequired="The input(s), `1`, are specified as having a non-Cocci Morphology. Please specify the Length of these bacterial cells to upload a valid object.";

errorToOptionMap[Model[Cell,Bacteria]]:={
	"Error::CellLengthRequired"->{Length}
};


(* ::Subsection::Closed:: *)
(*validModelYeastCellQTests*)


validModelYeastCellQTests[packet : PacketP[Model[Cell, Yeast]]] := With[
	{identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet]},
	{}
];

errorToOptionMap[Model[Cell,Yeast]]:={
};


(* ::Subsection::Closed:: *)
(*validModelTissueQTests*)


validModelTissueQTests[packet : PacketP[Model[Tissue]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueTissueName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		(* Shared field shaping *)
		NotNullFieldTest[packet, {Species, State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		]

	}
];

Error::NonUniqueTissueName="The name(s), `1`, are already taken for the type Model[Tissue]. Please change the Name option for these inputs to upload a valid object.";

errorToOptionMap[Model[Tissue]]:={
	"Error::NonUniqueTissueName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{Species,State, BiosafetyLevel, Name, Synonyms},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials}
};


(* ::Subsection::Closed:: *)
(*validModelMaterialQTests*)


validModelMaterialQTests[packet : PacketP[Model[Material]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		(* General fields filled in *)
		(* No message for this one because we populate the field automatically in the Upload function. *)
		NotNullFieldTest[packet, {Authors}],

		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueMaterialName],
			MessageArguments -> {identifier}
		],

		Test["Both Acid and Base cannot be True simultaneously for " <> ToString[identifier] <> ":",
			Lookup[packet, {Acid, Base}],
			Except[{True, True}],
			Message -> Hold[Error::AcidAndBase],
			MessageArguments -> {identifier}
		],

		Test["If a sample is marked as pungent it must also be set to ventilated for " <> ToString[identifier] <> ":",
			If[TrueQ[Lookup[packet, Pungent]],
				TrueQ[Lookup[packet, Ventilated]],
				True
			],
			True,
			Message -> Hold[Error::VentilatedRequired],
			MessageArguments -> {identifier}
		],

		(* Shared field shaping *)
		NotNullFieldTest[packet, {State, BiosafetyLevel, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["The contents of the Name field is a member of the Synonyms field for " <> ToString[identifier] <> ":",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		(* Tests that only apply if MSDSRequired is not False *)
		If[!MatchQ[Lookup[packet, MSDSRequired], False],
			NotNullFieldTest[packet, {Flammable, MSDSFile, NFPA, DOTHazardClass}, Message -> Hold[Error::RequiredMSDSOptions], MessageArguments -> {identifier}],
			Nothing
		],

		Test["IncompatibleMaterials is populated and contains either just None or a list of incompatible materials for " <> ToString[identifier] <> ":",
			Lookup[packet, IncompatibleMaterials],
			{None} | {MaterialP..},
			Message -> Hold[Error::IncompatibleMaterials],
			MessageArguments -> {identifier}
		]
	}
];

Error::NonUniqueMaterialName="The name(s), `1`, are already taken for the type Model[Material]. Please change the Name option for these inputs to upload a valid object.";

errorToOptionMap[Model[Material]]:={
	"Error::NonUniqueMaterialName"->{Name},
	"Error::AcidAndBase"->{Acid, Base},
	"Error::InvalidDensity"->{Density},
	"Error::VentilatedRequired"->{Pungent, Ventilated},
	"Error::RequiredOptions"->{State, BiosafetyLevel, Name, Synonyms},
	"Error::NameIsNotPartOfSynonyms"->{Name, Synonyms},
	"Error::RequiredMSDSOptions"-> {MSDSRequired,Flammable,MSDSFile,NFPA,DOTHazardClass},
	"Error::IncompatibleMaterials"->{IncompatibleMaterials}
};


(* ::Subsection::Closed:: *)
(*validModelSpeciesQTests*)


validModelSpeciesQTests[packet : PacketP[Model[Species]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Molecule}], Except[_Missing | Null], packet],
		(* only bother even checking if Name is specified and it's a new object *)
		uniqueNameQ = If[!MatchQ[Lookup[packet, Name, Null], Null] && MatchQ[Lookup[packet, Object, Null], Null],
			Not[DatabaseMemberQ[Append[Lookup[packet, Type], Lookup[packet, Name]]]],
			True
		]
	},
	{
		Test["The Name of the Model is unique for " <> ToString[identifier] <> ":",
			uniqueNameQ,
			True,
			Message -> Hold[Error::NonUniqueSpeciesName],
			MessageArguments -> {identifier}
		]
	}
];

Error::NonUniqueSpeciesName="The name(s), `1`, are already taken for the type Model[Species]. Please change the Name option for these inputs to upload a valid object.";

errorToOptionMap[Model[Species]]:={
	"Error::NonUniqueSpeciesName"->{Name}
};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Molecule],validModelMoleculeQTests];
registerValidQTestFunction[Model[Molecule,cDNA],validModelMoleculecDNAQTests];
registerValidQTestFunction[Model[Molecule,Oligomer],validModelMoleculeOligomerQTests];
registerValidQTestFunction[Model[Molecule,Transcript],validModelMoleculeTranscriptQTests];
registerValidQTestFunction[Model[Molecule,Protein],validModelMoleculeProteinQTests];
registerValidQTestFunction[Model[ProprietaryFormulation],validModelProprietaryFormulationQTests];
registerValidQTestFunction[Model[Molecule,Protein,Antibody],validModelMoleculeProteinAntibodyQTests];
registerValidQTestFunction[Model[Molecule,Carbohydrate],validModelMoleculeCarbohydrateQTests];
registerValidQTestFunction[Model[Molecule,Polymer],validModelMoleculePolymerQTests];
registerValidQTestFunction[Model[Resin],validModelResinQTests];
registerValidQTestFunction[Model[Resin,SolidPhaseSupport],validModelResinSolidPhaseSupportQTests];
registerValidQTestFunction[Model[Lysate],validModelLysateQTests];
registerValidQTestFunction[Model[Virus],validModelVirusQTests];
registerValidQTestFunction[Model[Cell],validModelCellQTests];
registerValidQTestFunction[Model[Cell,Mammalian],validModelMammalianCellQTests];
registerValidQTestFunction[Model[Cell,Bacteria],validModelBacterialCellQTests];
registerValidQTestFunction[Model[Cell,Yeast],validModelYeastCellQTests];
registerValidQTestFunction[Model[Tissue],validModelTissueQTests];
registerValidQTestFunction[Model[Material],validModelMaterialQTests];
registerValidQTestFunction[Model[Species],validModelSpeciesQTests];
