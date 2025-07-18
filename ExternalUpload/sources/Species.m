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
				OptionName -> Cells,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell]]]],
				Description -> "The cells that comprise this species.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Bacteria,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Cell, Bacteria]]]],
				Description -> "The strains of bacteria that this species carries.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Tissues,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Tissue]]]],
				Description -> "The tissues that are found in this species.",
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


InstallDefaultUploadFunction[UploadSpecies, Model[Species]];
InstallValidQFunction[UploadSpecies, Model[Species]];
InstallOptionsFunction[UploadSpecies, Model[Species]];

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