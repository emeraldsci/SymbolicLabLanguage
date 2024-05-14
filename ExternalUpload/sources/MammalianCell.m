(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadMammalianCell*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadMammalianCell,
	SharedOptions :> {
		CellOptions
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Tissues,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Tissue]]],
				Description -> "The types of tissue that this cell helps comprise.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Morphology,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> MammalianCellMorphologyP],
				Description -> "The morphological type of the cell line.",
				Category -> "Physical Properties"
			}
		]
	}
];


InstallDefaultUploadFunction[UploadMammalianCell, Model[Cell, Mammalian]];
InstallValidQFunction[UploadMammalianCell, Model[Cell, Mammalian]];
InstallOptionsFunction[UploadMammalianCell, Model[Cell, Mammalian]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadMammalianCell,
	"Upload a model for a cell line that is derived from a mammalian organism:",
	{
		"HEK293T (test for UploadMammalianCell)" <> $SessionUUID,
		ATCCID -> "CRL-11268",
		Species -> Model[Species, "Human"],
		DoublingTime -> 20 Hour,
		Diameter -> 15 Micro * Meter,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None},
		CellType -> Mammalian,
		CultureAdhesion -> Adherent
	},
	{Model[Cell, Mammalian, "HEK293T (test for UploadMammalianCell)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadMammalianCellOptions,
	"Upload a model for a cell line that is derived from a mammalian organism:",
	{
		"HEK293T (test for UploadMammalianCellOptions)" <> $SessionUUID,
		ATCCID -> "CRL-11268",
		Species -> Model[Species, "Human"],
		DoublingTime -> 20 Hour,
		IncubationTemperature -> 37 Celsius,
		Diameter -> 15 Micro * Meter,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None},
		CellType -> Mammalian,
		CultureAdhesion -> Adherent
	},
	{Model[Cell, Mammalian, "HEK293T (test for UploadMammalianCellOptions)" <> $SessionUUID]}
];


ExternalUpload`Private`InstallIdentityModelTests[
	ValidUploadMammalianCellQ,
	"Upload a model for a cell line that is derived from a mammalian organism:",
	{
		"HEK293T (test for ValidUploadMammalianCellQ)" <> $SessionUUID,
		ATCCID -> "CRL-11268",
		Species -> Model[Species, "Human"],
		DoublingTime -> 20 Hour,
		IncubationTemperature -> 37 Celsius,
		Diameter -> 15 Micro * Meter,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None},
		CellType -> Mammalian,
		CultureAdhesion -> Adherent
	},
	{Model[Cell, Mammalian, "HEK293T (test for ValidUploadMammalianCellQ)" <> $SessionUUID]}
];
