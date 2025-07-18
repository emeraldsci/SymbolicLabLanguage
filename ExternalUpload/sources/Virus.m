(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadVirus*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadVirus,
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
				OptionName -> Molecule,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Atomic Structure" -> Widget[
						Type -> Molecule,
						Pattern :> MoleculeP
					],
					"Polymer Strand/Structure" -> Widget[Type -> Expression, Pattern :> _?StructureQ | _?StrandQ, Size -> Line]
				],
				Description -> "The chemical structure that represents this molecule.",
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
				OptionName -> GenomeType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ViralGenomeP],
				Description -> "The type of genetic material carried by the virus.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Taxonomy,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ViralTaxonomyP],
				Description -> "The taxonomic class of the virus as defined by its phenotypic characteristics.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> LatentState,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> LatentStateP],
				Description -> "The state of the virus in a latently infected cell.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> ViralTranscripts,
				Default -> Null,
				AllowNull -> True,
				Widget -> {
					"Transcript" -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Transcript]]],
					"Production Stage" -> Widget[Type -> Enumeration, Pattern :> ViralLifeCycleP]
				},
				Description -> "All of the transcripts this virus is known to produce, along with the timing of their production during infection (defined by ViralLifeCycleP).",
				Category -> "Organizational Information"
			},
			{
				OptionName -> PreferredMALDIMatrix,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Sample, Matrix]]]],
				Description -> "The model of the MALDI mass spectrometry matrix that is optimal for obtaining the mass of this virus.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> CapsidGeometry,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CapsidGeometryP],
				Description -> "A description of the virus's capsid structure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Height,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Micro * Meter], Units -> Alternatives[Micro * Meter, Angstrom]],
				Description -> "The height of the virion.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Width,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Micro * Meter], Units -> Alternatives[Micro * Meter, Angstrom]],
				Description -> "The width of the virion.",
				Category -> "Physical Properties"
			}
		]
	},

	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions
	},

	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> LiteratureReferences,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Report, Literature]]]
				],
				Description -> "Literature references that discuss this virus.",
				Category -> "Analysis & Reports"
			},
			{
				OptionName -> ReferenceImages,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]
				],
				Description -> "Images of this virus, either obtained from an electron micrograph or a diagram.",
				Category -> "Experimental Results"
			}
		]
	},

	SharedOptions :> {
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[UploadVirus, Model[Virus]];
InstallValidQFunction[UploadVirus, Model[Virus]];
InstallOptionsFunction[UploadVirus, Model[Virus]];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadVirus,
	"Upload a model for a small infectious agent that only replicates inside the living cells of an organism:",
	{
		"SARS Coronavirus (test for UploadVirus)" <> $SessionUUID,
		GenomeType -> "+ssRNA",
		Taxonomy -> Coronavirus,
		LatentState -> Integrated,
		CapsidGeometry -> Helical,
		BiosafetyLevel -> "BSL-3",
		HazardousBan -> True,
		ParticularlyHazardousSubstance -> True,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Virus, "SARS Coronavirus (test for UploadVirus)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[
	UploadVirusOptions,
	"Upload a model for a small infectious agent that only replicates inside the living cells of an organism:",
	{
		"SARS Coronavirus (test for UploadVirusOptions)" <> $SessionUUID,
		GenomeType -> "+ssRNA",
		Taxonomy -> Coronavirus,
		LatentState -> Integrated,
		CapsidGeometry -> Helical,
		BiosafetyLevel -> "BSL-3",
		HazardousBan -> True,
		ParticularlyHazardousSubstance -> True,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Virus, "SARS Coronavirus (test for UploadVirusOptions)" <> $SessionUUID]}
];

ExternalUpload`Private`InstallIdentityModelTests[
	ValidUploadVirusQ,
	"Upload a model for a small infectious agent that only replicates inside the living cells of an organism:",
	{
		"SARS Coronavirus (test for ValidUploadVirusQ)" <> $SessionUUID,
		GenomeType -> "+ssRNA",
		Taxonomy -> Coronavirus,
		LatentState -> Integrated,
		CapsidGeometry -> Helical,
		BiosafetyLevel -> "BSL-3",
		HazardousBan -> True,
		ParticularlyHazardousSubstance -> True,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Virus, "SARS Coronavirus (test for ValidUploadVirusQ)" <> $SessionUUID]}
];
