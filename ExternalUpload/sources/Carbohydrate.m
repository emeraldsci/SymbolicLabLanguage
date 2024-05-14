(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadCarbohydrate*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadCarbohydrate,
	SharedOptions :> {
		UploadMolecule
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> GlyTouCanID,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
				Description -> "The GlyTouCan IDs for this carbohydrate.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> WURCS,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Paragraph],
				Description -> "The Web3 Unique Representation of Carbohydate Structures notation for this carbohydrate.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> MonoisotopicMass,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Dalton], Units -> Dalton],
				Description -> "The monoisotopic, underivatised, uncharged mass of this carbohydrate, calculated from experimental data for individual monosaccarides.",
				Category -> "Physical Properties"
			}
		]
	}
];


InstallDefaultUploadFunction[UploadCarbohydrate, Model[Molecule, Carbohydrate]];
InstallValidQFunction[UploadCarbohydrate, Model[Molecule, Carbohydrate]];
InstallOptionsFunction[UploadCarbohydrate, Model[Molecule, Carbohydrate]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadCarbohydrate,
	"Upload a model for a biological macromolecule composed of monosaccharide monomers:",
	{
		"Acarbose (test for UploadCarbohydrate)" <> $SessionUUID,
		MonoisotopicMass -> 645.248014 Gram / Mole,
		Synonyms -> {"Glucobay", "Precose"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Molecule, Carbohydrate, "Acarbose (test for UploadCarbohydrate)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadCarbohydrateOptions,
	"Upload a model for a biological macromolecule composed of monosaccharide monomers:",
	{
		"Acarbose (test for UploadCarbohydrateOptions)" <> $SessionUUID,
		MonoisotopicMass -> 645.248014 Gram / Mole,
		Synonyms -> {"Glucobay", "Precose"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Molecule, Carbohydrate, "Acarbose (test for UploadCarbohydrateOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[
	ValidUploadCarbohydrateQ,
	"Upload a model for a biological macromolecule composed of monosaccharide monomers:",
	{
		"Acarbose (test for ValidUploadCarbohydrateQ)" <> $SessionUUID,
		MonoisotopicMass -> 645.248014 Gram / Mole,
		Synonyms -> {"Glucobay", "Precose"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Molecule, Carbohydrate, "Acarbose (test for ValidUploadCarbohydrateQ)" <> $SessionUUID]}
];