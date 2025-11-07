(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadProtein*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadProtein,
	SharedOptions :> {
		MoleculeOptions,
		ExternalUploadHiddenOptions
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Species,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "The source species that this protein is found in.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> PDBIDs,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> String, Pattern :> PDBIDP, Size -> Word]
				],
				Description -> "The list of Protein Data Bank IDs for any structures of this protein that have been previously reported in literature or are publicly available.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Antibodies,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Protein, Antibody]]],
				Description -> "Antibodies that are known to bind to this protein.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Transcripts,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Transcript]]],
				Description -> "RNA templates that synthesize this protein inside of a cell.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			}
		]
	}
];


installDefaultUploadFunction[UploadProtein, Model[Molecule, Protein]];
installDefaultValidQFunction[UploadProtein, Model[Molecule, Protein]];
installDefaultOptionsFunction[UploadProtein, Model[Molecule, Protein]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadProtein,
	"Upload a model for a biological macromolecule composed of one or more amino acids chains:",
	{
		"P-selectin (test for UploadProtein)" <> $SessionUUID,
		Species -> Model[Species, "Human"],
		Antibodies -> {Model[Molecule, Protein, Antibody, "Crizanlizumab"]},
		Synonyms -> {"SELP", "CD62", "CD62P", "GMP140", "GRMP", "LECAM3", "PADGEM", "PSEL", "selectin P"},
		PDBIDs -> {"1FSB", "1G1Q", "1G1R", "1G1S", "1HES"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	Model[Molecule, Protein, "P-selectin (test for UploadProtein)" <> $SessionUUID]
];


ExternalUpload`Private`InstallIdentityModelTests[
	UploadProteinOptions,
	"Upload a model for a biological macromolecule composed of one or more amino acids chains:",
	{
		"P-selectin (test for UploadProteinOptions)" <> $SessionUUID,
		Species -> Model[Species, "Human"],
		Antibodies -> {Model[Molecule, Protein, Antibody, "Crizanlizumab"]},
		Synonyms -> {"SELP", "CD62", "CD62P", "GMP140", "GRMP", "LECAM3", "PADGEM", "PSEL", "selectin P"},
		PDBIDs -> {"1FSB", "1G1Q", "1G1R", "1G1S", "1HES"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	Model[Molecule, Protein, "P-selectin (test for UploadProteinOptions)" <> $SessionUUID]
];

ExternalUpload`Private`InstallIdentityModelTests[
	ValidUploadProteinQ,
	"Upload a model for a biological macromolecule composed of one or more amino acids chains:",
	{
		"P-selectin (test for ValidUploadProteinQ)" <> $SessionUUID,
		Species -> Model[Species, "Human"],
		Antibodies -> {Model[Molecule, Protein, Antibody, "Crizanlizumab"]},
		Synonyms -> {"SELP", "CD62", "CD62P", "GMP140", "GRMP", "LECAM3", "PADGEM", "PSEL", "selectin P"},
		PDBIDs -> {"1FSB", "1G1Q", "1G1R", "1G1S", "1HES"},
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None}
	},
	Model[Molecule, Protein, "P-selectin (test for ValidUploadProteinQ)" <> $SessionUUID]
];
