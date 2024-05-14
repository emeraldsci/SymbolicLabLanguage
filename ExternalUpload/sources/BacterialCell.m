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
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, With[{insertMe=List @@ IdentityModelTypeP}, Pattern :> ObjectP[insertMe]]],
				Description -> "Antimicrobial substances that kill or inhibit the growth of this strain of bacteria.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Hosts,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "Species that are known to carry this strain of bacteria.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Morphology,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BacterialMorphologyP],
				Description -> "The morphological type of this strain of bacteria.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> GramStain,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Positive | Negative],
				Description -> "Indicates whether this strain of bacteria has a layer of peptidoglycan in its cell wall.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Flagella,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BacterialFlagellaTypeP],
				Description -> "The type of flagella that protrude from this bacterium's cell wall.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> CellLength,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Micro * Meter, 1*Meter], Units -> {1, {Micro * Meter, {Micro * Meter, Angstrom}}}],
				Description -> "The length of a single bacterium's body along its longest dimension.",
				Category -> "Physical Properties"
			}
		]
	}
];


InstallDefaultUploadFunction[UploadBacterialCell, Model[Cell, Bacteria]];
InstallValidQFunction[UploadBacterialCell, Model[Cell, Bacteria]];
InstallOptionsFunction[UploadBacterialCell, Model[Cell, Bacteria]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadBacterialCell,
	"Upload a model for a specific strain of bacterium:",
	{
		"Escherichia coli (test for UploadBacterialCell)" <> $SessionUUID,
		Morphology -> Cocci,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
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
		MSDSRequired -> False,
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
		MSDSRequired -> False,
		IncompatibleMaterials -> {None},
		CellType -> Bacterial,
		CultureAdhesion -> Suspension
	},
	{Model[Cell, Bacteria, "Escherichia coli (test for ValidUploadBacterialCellQ)" <> $SessionUUID]}
];
