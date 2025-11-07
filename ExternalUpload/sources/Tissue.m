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
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of the identity model.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> DefaultSampleModel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "List of possible alternative names this model goes by.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Species,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "The species that this cell was originally cultivated from.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Cells,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell]]]],
				Description -> "The cells that make up this tissue.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> ReferenceImages,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]],
				Description -> "Reference microscope images exemplifying the typical appearance of this tissue.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Experimental Results"
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


installDefaultUploadFunction[UploadTissue, Model[Tissue]];
installDefaultValidQFunction[UploadTissue, Model[Tissue]];
installDefaultOptionsFunction[UploadTissue, Model[Tissue]];

InstallIdentityModelTests[
	UploadTissue,
	"Upload model information for a functional grouping of cells:",
	{
		"Mouse Tissue (test for UploadTissue)" <> $SessionUUID,
		Species -> Model[Species, "Mouse"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
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
		MSDSFile -> NotApplicable,
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
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Tissue, "Mouse Tissue (test for ValidUploadTissueQ)" <> $SessionUUID]}
];
