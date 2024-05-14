(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASequencing*)

DefineUsage[ExperimentDNASequencing,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDNASequencing[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for running a Sanger DNA sequencing experiment, which uses fluorescently labeled DNA 'Samples', with a genetic analyzer instrument containing a capillary electrophoresis array to determine the nucleotide sequences from the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The fluorescently labeled nucleic acid template samples, prepared for Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the Sanger DNA sequencing experiment.",
						Pattern:>ObjectP[Object[Protocol,DNASequencing]]
					}
				}
			},
			{
				Definition->{"ExperimentDNASequencing[Samples,primers]","Protocol"},
				Description->"creates a 'Protocol' object for running a Sanger DNA sequencing experiment, which uses fluorescent dideoxynucleotide chain-terminating PCR to label provided 'Samples' using provided 'primers' and then a genetic analyzer instrument with a capillary electrophoresis array to determine the nucleotide sequences from the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The nucleic acid template samples to be mixed with a Master Mix composed of the polymerase, nucleotides, fluorescently-labeled dideoxynucleotides, primer, and buffer, that will then undergo the chain-terminating polymerase reaction, purification if desired, and Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"primers",
							Description->"The oligomer strand designed to bind to the templates and serve as an anchor for the polymerase in the chain-terminating polymerase reaction.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the Sanger DNA sequencing experiment.",
						Pattern:>ObjectP[Object[Protocol,DNASequencing]]
					}
				}
			}
		},
		MoreInformation->{
			"If the input samples are not in compatible containers, aliquots will automatically be transferred to the appropriate containers."
		},
		SeeAlso->{
			"ExperimentPCR",
			"ExperimentqPCR",
			"ExperimentDNASequencingOptions",
			"ExperimentDNASequencingPreview",
			"ValidExperimentDNASequencingQ"
		},
		Author->{
			"clayton.schwarz",
			"hailey.hibbard"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASequencingOptions*)


DefineUsage[ExperimentDNASequencingOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDNASequencingOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentDNASequencing when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The fluorescently labeled nucleic acid template samples, prepared for Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentDNASequencing is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"ExperimentDNASequencingOptions[Samples,primers]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentDNASequencing when it is called on 'Samples' and 'primers'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The nucleic acid template samples to be mixed with a Master Mix composed of the polymerase, nucleotides, fluorescently-labeled dideoxynucleotides, primer, and buffer, that will then undergo the chain-terminating polymerase reaction, purification if desired, and Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"primers",
							Description->"The oligomer strand designed to bind to the templates and serve as an anchor for the polymerase in the chain-terminating polymerase reaction.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentDNASequencing is called on the input samples and primers.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDNASequencing",
			"ExperimentDNASequencingPreview",
			"ValidExperimentDNASequencingQ"
		},
		Author->{"clayton.schwarz", "hailey.hibbard"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASequencingPreview*)


DefineUsage[ExperimentDNASequencingPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDNASequencingPreview[Samples]","Preview"},
				Description->"returns a graphical preview for ExperimentDNASequencing when it is called on 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The fluorescently labeled nucleic acid template samples, prepared for Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentDNASequencing. This value is always Null.",
						Pattern:>Null
					}
				}
			},
			{
				Definition->{"ExperimentDNASequencingPreview[Samples,primers]","Preview"},
				Description->"returns a graphical preview for ExperimentDNASequencing when it is called on 'Samples' and 'primers'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The nucleic acid template samples to be mixed with a Master Mix composed of the polymerase, nucleotides, fluorescently-labeled dideoxynucleotides, primer, and buffer, that will then undergo the chain-terminating polymerase reaction, purification if desired, and Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"primers",
							Description->"The oligomer strand designed to bind to the templates and serve as an anchor for the polymerase in the chain-terminating polymerase reaction.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentDNASequencing. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDNASequencing",
			"ExperimentDNASequencingOptions",
			"ValidExperimentDNASequencingQ"
		},
		Author->{"clayton.schwarz", "hailey.hibbard"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentDNASequencingQ*)


DefineUsage[ValidExperimentDNASequencingQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentDNASequencingQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentDNASequencing.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The fluorescently labeled nucleic acid template samples, prepared for Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentDNASequencing call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			},
			{
				Definition->{"ValidExperimentDNASequencingQ[Samples,primers]","Boolean"},
				Description->"checks whether the provided 'Samples' and 'primers' and specified options are valid for calling ExperimentDNASequencing.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The nucleic acid template samples to be mixed with a Master Mix composed of the polymerase, nucleotides, fluorescently-labeled dideoxynucleotides, primer, and buffer, that will then undergo the chain-terminating polymerase reaction, purification if desired, and Sanger DNA sequencing by capillary electrphoresis to determine the nucleotide sequences.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"primers",
							Description->"The oligomer strand designed to bind to the templates and serve as an anchor for the polymerase in the chain-terminating polymerase reaction.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentDNASequencing call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDNASequencing",
			"ExperimentDNASequencingOptions",
			"ExperimentDNASequencingPreview"
		},
		Author->{
			"clayton.schwarz",
			"hailey.hibbard"
		}
	}
];