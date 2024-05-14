(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadYeastCell*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadYeastCell,
	SharedOptions :> {
		CellOptions
	}
];


InstallDefaultUploadFunction[UploadYeastCell, Model[Cell, Yeast]];
InstallValidQFunction[UploadYeastCell, Model[Cell, Yeast]];
InstallOptionsFunction[UploadYeastCell, Model[Cell, Yeast]];

InstallIdentityModelTests[
	UploadYeastCell,
	"Upload a specific strain of yeast:",
	{
		"S. cerevisiae (test for UploadYeastCell)" <> $SessionUUID,
		CellType -> Yeast,
		CultureAdhesion -> Suspension,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Cell, Yeast, "S. cerevisiae (test for UploadYeastCell)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	UploadYeastCellOptions,
	"Upload a specific strain of yeast:",
	{
		"S. cerevisiae (test for UploadYeastCellOptions)" <> $SessionUUID,
		CellType -> Yeast,
		CultureAdhesion -> Suspension,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Cell, Yeast, "S. cerevisiae (test for UploadYeastCellOptions)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	ValidUploadYeastCellQ,
	"Upload a specific strain of yeast:",
	{
		"S. cerevisiae (test for ValidUploadYeastCellQ)" <> $SessionUUID,
		CellType -> Yeast,
		CultureAdhesion -> Suspension,
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Cell, Yeast, "S. cerevisiae (test for ValidUploadYeastCellQ)" <> $SessionUUID]}
];