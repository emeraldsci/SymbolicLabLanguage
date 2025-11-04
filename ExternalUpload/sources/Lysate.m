(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadLysate*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadLysate,
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
				OptionName -> Cell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Cell]]],
				Description -> "The model of cell line that this lysate is extracted from.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


installDefaultUploadFunction[UploadLysate, Model[Lysate]];
installDefaultValidQFunction[UploadLysate, Model[Lysate]];
installDefaultOptionsFunction[UploadLysate, Model[Lysate]];


ExternalUpload`Private`InstallIdentityModelTests[UploadLysate, "Upload a model for the contents of a HEK293T cell after it has been lysed:",
	{
		"HEK293T Lysate (test for UploadLysate)" <> $SessionUUID,
		Cell -> Model[Cell, Mammalian, "293T"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Lysate, "HEK293T Lysate (test for UploadLysate)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadLysateOptions, "Upload a model for the contents of a HEK293T cell after it has been lysed:",
	{
		"HEK293T Lysate (test for UploadLysateOptions)" <> $SessionUUID,
		Cell -> Model[Cell, Mammalian, "293T"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Lysate, "HEK293T Lysate (test for UploadLysateOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadLysateQ, "Upload a model for the contents of a HEK293T cell after it has been lysed:",
	{
		"HEK293T Lysate (test for ValidUploadLysateQ)" <> $SessionUUID,
		Cell -> Model[Cell, Mammalian, "293T"],
		BiosafetyLevel -> "BSL-2",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Lysate, "HEK293T Lysate (test for ValidUploadLysateQ)" <> $SessionUUID]}
];