(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadBacterialCell*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadBacterialCell,
	SharedOptions :> {
		CellOptions
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Antibiotics,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, With[{insertMe=List @@ IdentityModelTypeP}, Pattern :> ObjectP[insertMe]]],
				Description -> "Antimicrobial substances that kill or inhibit the growth of this strain of bacteria.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Hosts,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "Species that are known to carry this strain of bacteria.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Morphology,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BacterialMorphologyP],
				Description -> "The morphological type of this strain of bacteria.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> GramStain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Positive | Negative],
				Description -> "Indicates whether this strain of bacteria has a layer of peptidoglycan in its cell wall.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Flagella,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BacterialFlagellaTypeP],
				Description -> "The type of flagella that protrude from this bacterium's cell wall.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> CellLength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Micro * Meter, 1*Meter], Units -> {1, {Micro * Meter, {Micro * Meter, Angstrom}}}],
				Description -> "The length of a single bacterium's body along its longest dimension.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			}
		]
	}
];


installDefaultUploadFunction[UploadBacterialCell, Model[Cell, Bacteria], OptionResolver -> resolveDefaultCellUploadFunctionOptions];
installDefaultValidQFunction[UploadBacterialCell, Model[Cell, Bacteria]];
installDefaultOptionsFunction[UploadBacterialCell, Model[Cell, Bacteria]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadBacterialCell,
	"Upload a model for a specific strain of bacterium:",
	{
		"Escherichia coli (test for UploadBacterialCell)" <> $SessionUUID,
		Morphology -> Cocci,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		CellType -> Bacterial,
		CultureAdhesion -> Suspension
	},
	{Model[Cell, Bacteria, "Escherichia coli (test for UploadBacterialCell)" <> $SessionUUID]}
];


ExternalUpload`Private`InstallIdentityModelTests[
	UploadBacterialCellOptions,
	"Upload a model for a specific strain of bacterium:",
	{
		"Escherichia coli (test for UploadBacterialCellOptions)" <> $SessionUUID,
		Morphology -> Cocci,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		CellType -> Bacterial,
		CultureAdhesion -> Suspension
	},
	{Model[Cell, Bacteria, "Escherichia coli (test for UploadBacterialCellOptions)" <> $SessionUUID]}
];


ExternalUpload`Private`InstallIdentityModelTests[
	ValidUploadBacterialCellQ,
	"Upload a model for a specific strain of bacterium:",
	{
		"Escherichia coli (test for ValidUploadBacterialCellQ)" <> $SessionUUID,
		Morphology -> Cocci,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		CellType -> Bacterial,
		CultureAdhesion -> Suspension
	},
	{Model[Cell, Bacteria, "Escherichia coli (test for ValidUploadBacterialCellQ)" <> $SessionUUID]}
];
