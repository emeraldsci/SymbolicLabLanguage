(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadMaterial*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadMaterial,
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
				OptionName -> ReferenceImages,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]],
				Description -> "Reference microscope images exemplifying the typical appearance of this material.",
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


installDefaultUploadFunction[UploadMaterial, Model[Material]];
installDefaultValidQFunction[UploadMaterial, Model[Material]];
installDefaultOptionsFunction[UploadMaterial, Model[Material]];


ExternalUpload`Private`InstallIdentityModelTests[UploadMaterial, "Upload a model for a mixture of several compounds that constitutes a solid, self-contained substance (e.g paper, ceramic, fiberglass):",
	{
		"Paper Towel (test for UploadMaterial)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for UploadMaterial)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadMaterialOptions, "Upload a model for a mixture of several compounds that constitutes a solid, self-contained substance (e.g paper, ceramic, fiberglass):",
	{
		"Paper Towel (test for UploadMaterialOptions)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for UploadMaterialOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadMaterialQ, "Upload a model for a mixture of several compounds that constitutes a solid, self-contained substance (e.g paper, ceramic, fiberglass):",
	{
		"Paper Towel (test for ValidUploadMaterialQ)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[Material, "Paper Towel (test for ValidUploadMaterialQ)" <> $SessionUUID]}
];