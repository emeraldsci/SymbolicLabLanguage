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
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of this proprietary formulation.",
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
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];
InstallValidQFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];
InstallOptionsFunction[UploadProprietaryFormulation, Model[ProprietaryFormulation]];

ExternalUpload`Private`InstallIdentityModelTests[UploadProprietaryFormulation, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for UploadProprietaryFormulation)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for UploadProprietaryFormulation)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadProprietaryFormulationOptions, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for UploadProprietaryFormulationOptions)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for UploadProprietaryFormulationOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadProprietaryFormulationQ, "Upload a mixture of compounds whose formulation is unknown (ex. NanoJuice Proprietary Formulation):",
	{
		"NanoJuice Proprietary Formulation (test for ValidUploadProprietaryFormulationQ)" <> $SessionUUID,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[ProprietaryFormulation, "NanoJuice Proprietary Formulation (test for ValidUploadProprietaryFormulationQ)" <> $SessionUUID]}
];