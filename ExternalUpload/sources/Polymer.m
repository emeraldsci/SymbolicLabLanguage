(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadPolymer*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadPolymer,
	SharedOptions :> {
		MoleculeOptions,
		ExternalUploadHiddenOptions
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Monomers,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]],
				Description -> "The structural repeating units that this polymer is composed of.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> DegreeOfPolymerization,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Expression, Pattern :> DistributionP[], Size -> Line]
				],
				Description -> "The number of monomeric units in this given polymer (not the number of repeat units).",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Arrangement,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> PolymerArrangementP],
				Description -> "The structural repeating units that this polymer is composed of.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Tacticity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> PolymerTacticityP],
				Description -> "The relative stereochemistry of the chiral centers in adjacent repeating structural units within the polymer.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Copolymers,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Polymer]]]],
				Description -> "Other polymers that have the same arrangement of monomeric units, but different degrees of polymerization.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			}
		]
	}
];


installDefaultUploadFunction[UploadPolymer, Model[Molecule, Polymer]];
installDefaultValidQFunction[UploadPolymer, Model[Molecule, Polymer]];
installDefaultOptionsFunction[UploadPolymer, Model[Molecule, Polymer]];

ExternalUpload`Private`InstallIdentityModelTests[UploadPolymer, "Upload a model for a macromolecule composed of repeating subunits whose sequence may be fully or semi-controlled, but whose overall length is not exact:",
	{
		"PTFE (test for UploadPolymer)" <> $SessionUUID,
		State->Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for UploadPolymer)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadPolymerOptions, "Upload a model for a macromolecule composed of repeating subunits whose sequence may be fully or semi-controlled, but whose overall length is not exact:",
	{
		"PTFE (test for UploadPolymerOptions)" <> $SessionUUID,
		State->Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for UploadPolymerOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadPolymerQ, "Upload a model for a macromolecule composed of repeating subunits whose sequence may be fully or semi-controlled, but whose overall length is not exact:",
	{
		"PTFE (test for ValidUploadPolymerQ)" <> $SessionUUID,
		State->Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for ValidUploadPolymerQ)" <> $SessionUUID]}
];
