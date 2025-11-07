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
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Tissue]]],
				Description -> "The types of tissue that this cell helps comprise.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Morphology,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> MammalianCellMorphologyP],
				Description -> "The morphological type of the cell line.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			}
		]
	}
];


installDefaultUploadFunction[UploadMammalianCell, Model[Cell, Mammalian], OptionResolver -> resolveDefaultCellUploadFunctionOptions];
installDefaultValidQFunction[UploadMammalianCell, Model[Cell, Mammalian]];
installDefaultOptionsFunction[UploadMammalianCell, Model[Cell, Mammalian]];

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
		MSDSFile -> NotApplicable,
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
		Diameter -> 15 Micro * Meter,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
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
		Diameter -> 15 Micro * Meter,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		CellType -> Mammalian,
		CultureAdhesion -> Adherent
	},
	{Model[Cell, Mammalian, "HEK293T (test for ValidUploadMammalianCellQ)" <> $SessionUUID]}
];
