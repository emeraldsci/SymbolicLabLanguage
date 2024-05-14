

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPeptideSynthesis*)


DefineUsage[ExperimentPeptideSynthesis,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPeptideSynthesis[OligomerModels]","Protocol"},
				Description->"uses a oligomer 'OligomerModels' to create a Peptide Synthesis 'Protocol' and associated synthesis cycles methods.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the Peptide synthesis experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,PeptideSynthesis]]]
					}
				}
			}
		},
		MoreInformation -> {
			"This experiment function is used to create Peptide oligomer strands from an oligomer model object.",
			"The maximum number of strands that can be synthesized in a single run is 12."
		},
		SeeAlso -> {
			"ValidExperimentPeptideSynthesisQ",
			"ExperimentPeptideSynthesisOptions",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentPeptideSynthesisQ*)


DefineUsage[ValidExperimentPeptideSynthesisQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentPeptideSynthesisQ[OligomerModels]","Boolean"},
				Description->"checks whether the provided 'OligomerModels' and specified options are valid for calling ExperimentPeptideSynthesis.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentPeptideSynthesis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern:> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This experiment function is used to create Peptide oligomer strands from an oligomer model object.",
			"The maximum number of strands that can be synthesized in a single run is 12."
		},
		SeeAlso -> {
			"ValidExperimentPeptideSynthesisQ",
			"ExperimentPeptideSynthesisOptions",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis"
		},
		Author->{"alou","waltraud.mair"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentPeptideSynthesisQ*)


DefineUsage[ValidExperimentPeptideSynthesisQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentPeptideSynthesisQ[OligomerModels]","Boolean"},
				Description->"checks whether the provided 'OligomerModels' and specified options are valid for calling ExperimentPeptideSynthesis.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentPeptideSynthesis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern:> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPeptideSynthesis",
			"ExperimentPeptideSynthesisOptions",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis"
		},
		Author->{"alou","waltraud.mair"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentPeptideSynthesisPreview*)


DefineUsage[ExperimentPeptideSynthesisPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPeptideSynthesisPreview[OligomerModels]","Preview"},
				Description->"returns the graphical preview for ExperimentPeptideSynthesis when it is called on 'OligomerModels'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentPeptideSynthesis.  This value is always Null.",
						Pattern:> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPeptideSynthesis",
			"ExperimentPeptideSynthesisOptions",
			"ValidExperimentPeptideSynthesisQ",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentPeptideSynthesisOptions*)


DefineUsage[ExperimentPeptideSynthesisOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPeptideSynthesisOptions[OligomerModels]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentPeptideSynthesis when it is called on 'OligomerModels'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentPeptideSynthesis is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPeptideSynthesis",
			"ValidExperimentPeptideSynthesisQ",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];