(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadTissue*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadTissue,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of the identity model.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> DefaultSampleModel,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "List of possible alternative names this model goes by.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Species,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "The species that this cell was originally cultivated from.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Cells,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell]]]],
				Description -> "The cells that make up this tissue.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> ReferenceImages,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]],
				Description -> "Reference microscope images exemplifying the typical appearance of this tissue.",
				Category -> "Experimental Results"
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[UploadTissue, Model[Tissue]];
InstallValidQFunction[UploadTissue, Model[Tissue]];
InstallOptionsFunction[UploadTissue, Model[Tissue]];

InstallIdentityModelTests[
	UploadTissue,
	"Upload model information for a functional grouping of cells:",
	{
		"Mouse Tissue (test for UploadTissue)" <> $SessionUUID,
		Species -> Model[Species, "Mouse"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Tissue, "Mouse Tissue (test for UploadTissue)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	UploadTissueOptions,
	"Upload model information for a functional grouping of cells:",
	{
		"Mouse Tissue (test for UploadTissueOptions)" <> $SessionUUID,
		Species -> Model[Species, "Mouse"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Tissue, "Mouse Tissue (test for UploadTissueOptions)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	ValidUploadTissueQ,
	"Upload model information for a functional grouping of cells:",
	{
		"Mouse Tissue (test for ValidUploadTissueQ)" <> $SessionUUID,
		Species -> Model[Species, "Mouse"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Tissue, "Mouse Tissue (test for ValidUploadTissueQ)" <> $SessionUUID]}
];
