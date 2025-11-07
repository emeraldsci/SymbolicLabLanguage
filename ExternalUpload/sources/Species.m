(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadSpecies*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadSpecies,
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
				OptionName -> Cells,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell]]]],
				Description -> "The cells that comprise this species.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Bacteria,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell, Bacteria]]]],
				Description -> "The strains of bacteria that this species carries.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Tissues,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Tissue]]]],
				Description -> "The tissues that are found in this species.",
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


installDefaultUploadFunction[UploadSpecies, Model[Species]];
installDefaultValidQFunction[UploadSpecies, Model[Species]];
installDefaultOptionsFunction[UploadSpecies, Model[Species]];

InstallIdentityModelTests[
	UploadSpecies,
	"Upload model information for an animal, plant, fungi, or unicellular microorganism:",
	{
		"Human (test for UploadSpecies)" <> $SessionUUID
	},
	{Model[Species, "Human (test for UploadSpecies)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	UploadSpeciesOptions,
	"Upload model information for an animal, plant, fungi, or unicellular microorganism:",
	{
		"Human (test for UploadSpeciesOptions)" <> $SessionUUID
	},
	{Model[Species, "Human (test for UploadSpeciesOptions)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	ValidUploadSpeciesQ,
	"Upload model information for an animal, plant, fungi, or unicellular microorganism:",
	{
		"Human (test for ValidUploadSpeciesQ)" <> $SessionUUID
	},
	{Model[Species, "Human (test for ValidUploadSpeciesQ)" <> $SessionUUID]}
];