(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadLysate*)


(* ::Subsubsection:: *)
(*Options and Messages *)


DefineOptions[UploadProprietaryFormulation,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of this proprietary formulation.",
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
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


installDefaultUploadFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];
installDefaultValidQFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];
installDefaultOptionsFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];

ExternalUpload`Private`InstallIdentityModelTests[UploadProprietaryFormulation, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for UploadProprietaryFormulation)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for UploadProprietaryFormulation)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadProprietaryFormulationOptions, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for UploadProprietaryFormulationOptions)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for UploadProprietaryFormulationOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadProprietaryFormulationQ, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for ValidUploadProprietaryFormulationQ)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for ValidUploadProprietaryFormulationQ)" <> $SessionUUID]}
];