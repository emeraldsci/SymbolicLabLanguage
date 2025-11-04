(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadAntibody*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadAntibody,
	SharedOptions :> {
		UploadProtein
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Species,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
				Description -> "The species in which the antibody was raised. Determines the type of secondary antibody required for labeling.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Targets,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Protein]]]],
				Description -> "Protein or antibody targets to which this antibody binds selectively.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> SecondaryAntibodies,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Protein, Antibody]]]],
				Description -> "Secondary antibody models that bind to this antibody and can be used for labeling.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> Isotype,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> AntibodyIsotypeP],
				Description -> "The subgroup of immunoglobulin this antibody belongs to, based on variations within the constant regions of its heavy and/or light chains.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Clonality,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> AntibodyClonalityP],
				Description -> "Specifies whether the antibody is produced by one type of cells to recognize a single epitope (monoclonal) or several types of immune cells to recognize multiple epitopes (polyclonal).",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> AssayTypes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Enumeration, Pattern :> AntibodyAssayCompatibilityP]],
				Description -> "Types of experiments in which this antibody is known to perform well.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "General"
			},
			{
				OptionName -> RecommendedDilution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 1]],
				Description -> "The dilution that is recommended for use of this antibody in a capillary electrophoresis western blot assay.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "General"
			}
		]
	}
];


installDefaultUploadFunction[UploadAntibody, Model[Molecule, Protein, Antibody]];
installDefaultValidQFunction[UploadAntibody, Model[Molecule, Protein, Antibody]];
installDefaultOptionsFunction[UploadAntibody, Model[Molecule, Protein, Antibody]];

ExternalUpload`Private`InstallIdentityModelTests[UploadAntibody, "Upload a model for a Y-shaped immune component that targets a specific antigen:",
	{
		"Crizanlizumab (test for UploadAntibody)" <> $SessionUUID,
		Species -> Model[Species, "id:GmzlKjPbjmap"],
		Targets -> {Model[Molecule, Protein, "P-selectin"]},
		Clonality -> Monoclonal,
		Isotype -> IgG1,
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		RecommendedDilution -> 0.01
	},
	{Model[Molecule, Protein, Antibody, "Crizanlizumab (test for UploadAntibody)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[UploadAntibodyOptions, "Upload a model for a Y-shaped immune component that targets a specific antigen:",
	{
		"Crizanlizumab (test for UploadAntibodyOptions)" <> $SessionUUID,
		Species -> Model[Species, "id:GmzlKjPbjmap"],
		Targets -> {Model[Molecule, Protein, "P-selectin"]},
		Clonality -> Monoclonal,
		Isotype -> IgG1,
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		RecommendedDilution -> 0.01
	},
	{Model[Molecule, Protein, Antibody, "Crizanlizumab (test for UploadAntibodyOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[ValidUploadAntibodyQ, "Upload a model for a Y-shaped immune component that targets a specific antigen:",
	{
		"Crizanlizumab (test for ValidUploadAntibodyQ)" <> $SessionUUID,
		Species -> Model[Species, "id:GmzlKjPbjmap"],
		Targets -> {Model[Molecule, Protein, "P-selectin"]},
		Clonality -> Monoclonal,
		Isotype -> IgG1,
		State -> Solid,
		BiosafetyLevel -> "BSL-1",
		Flammable -> False,
		MSDSFile -> NotApplicable,
		IncompatibleMaterials -> {None},
		RecommendedDilution -> 0.01
	},
	{Model[Molecule, Protein, Antibody, "Crizanlizumab (test for ValidUploadAntibodyQ)" <> $SessionUUID]}
];