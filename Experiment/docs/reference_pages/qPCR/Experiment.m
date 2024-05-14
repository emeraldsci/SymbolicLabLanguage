(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentqPCR*)


DefineUsage[ExperimentqPCR,
	{
		BasicDefinitions->{
			(*384-well plate*)
			{
				Definition->{"ExperimentqPCR[Samples,PrimerPairs]","Protocol"},
				Description->"creates a 'Protocol' object for running a quantitative Polymerase Chain Reaction (qPCR) experiment, which uses a thermocycler to amplify and quantify target sequences from the 'Samples' using 'PrimerPairs' and either a fluorescent intercalating dye or fluorescently labeled probes.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases. Specify multiple pairs for a given sample, along with suitable detection probes via the Probes option, in order to perform multiplexing.",
							Widget->Adder[{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the quantitative polymerase chain reaction (qPCR) experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,qPCR]]]
					}
				}
			},
			(*array card*)
			{
				Definition->{"ExperimentqPCR[Samples,ArrayCard]","Protocol"},
				Description->"creates a 'Protocol' object for running a quantitative polymerase chain reaction (qPCR) experiment, which uses a thermocycler to amplify and quantify target sequences from the 'Samples' using an 'arrayCard' containing primer pairs and fluorescently labeled probes.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName->"arrayCard",
						Description->"The array card containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases and detection probes.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the quantitative polymerase chain reaction (qPCR) experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,qPCR]]]
					}
				}
			}
		},
		MoreInformation->{
			"The qPCR assay will be performed in a 384-well plate. Each sample input and its corresponding primer input will be placed into a single well. If multiple primer pairs are specified for a given sample input, multiplexing will be performed. Multiplexing requires the use of the Probe option to allow for detection of multiple amplicons within a single well.",
			"The 384-well plate is loaded starting at well A1 and proceeding down columns, then across rows (e.g., A1, B1, C1, ..., A2, B2, ...) with samples loaded in the following order:",
			"-All provided input samples in order, with replicates placed sequentially (e.g., if NumberOfReplicates->2, sample 1, sample 1, sample 2, sample 2, ...)",
			"-All provided standard samples in order, with replicates of a given dilution of each standard placed sequentially (e.g., standard 1 dil 1, standard 1 dil 1, standard 1, dil 2, standard 1 dil 2, ...)",
			"If an array card input is provided, samples, master mix, and buffer will be loaded together onto the array card. The array card will then be centrifuged, sealed, and thermocycled."
		},
		SeeAlso->{
			"ExperimentqPCROptions",
			"ExperimentqPCRPreview",
			"ValidExperimentqPCRQ"
			},
		Author->{"andrey.shur", "robert", "weiran.wang", "eqian", "ben"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentqPCROptions*)


DefineUsage[ExperimentqPCROptions,
	{
		BasicDefinitions->{
			(*384-well plate*)
			{
				Definition->{"ExperimentqPCROptions[Samples,PrimerPairs]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentqPCR when it is called on the 'Samples' and 'PrimerPairs'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases. Specify multiple pairs for a given sample, along with suitable detection probes via the Probes option, in order to perform multiplexing.",
							Widget->Adder[{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentqPCR is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			(*array card*)
			{
				Definition->{"ExperimentqPCROptions[Samples,ArrayCard]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentqPCR when it is called on the 'Samples' and 'arrayCard'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName->"arrayCard",
						Description->"The array card containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases and detection probes.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentqPCR is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentqPCRPreview",
			"ValidExperimentqPCRQ"
			},
		Author->{"andrey.shur", "robert", "weiran.wang", "eqian", "ben"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentqPCRPreview*)


DefineUsage[ExperimentqPCRPreview,
	{
		BasicDefinitions->{
			(*384-well plate*)
			{
				Definition->{"ExperimentqPCRPreview[Samples,PrimerPairs]","Preview"},
				Description->"returns the graphical 'Preview' for ExperimentqPCR when it is called on the 'Samples' and 'PrimerPairs'. This preview is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases. Specify multiple pairs for a given sample, along with suitable detection probes via the Probes option, in order to perform multiplexing.",
							Widget->Adder[{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentqPCR. This value is always Null.",
						Pattern:>Null
					}
				}
			},
			(*array card*)
			{
				Definition->{"ExperimentqPCRPreview[Samples,ArrayCard]","Preview"},
				Description->"returns the graphical 'Preview' for ExperimentqPCR when it is called on the 'Samples' and 'arrayCard'. This preview is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName->"arrayCard",
						Description->"The array card containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases and detection probes.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentqPCR. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentqPCROptions",
			"ValidExperimentqPCRQ"
		},
		Author->{"andrey.shur", "robert", "weiran.wang", "eqian", "ben"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentqPCRQ*)


DefineUsage[ValidExperimentqPCRQ,
	{
		BasicDefinitions->{
			(*384-well plate*)
			{
				Definition->{"ValidExperimentqPCRQ[Samples,PrimerPairs]","Boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling ExperimentqPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases. Specify multiple pairs for a given sample, along with suitable detection probes via the Probes option, in order to perform multiplexing.",
							Widget->Adder[{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
            Description->"Whether or not the ExperimentqPCR call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			},
			(*array card*)
			{
				Definition->{"ValidExperimentqPCRQ[Samples,ArrayCard]","Boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling ExperimentqPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName->"arrayCard",
						Description->"The array card containing pairs of oligomer strands designed to bind to the templates and function as anchors for polymerases and transcriptases and detection probes.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container,Plate,Irregular,ArrayCard]],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentqPCR call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentqPCROptions",
			"ExperimentqPCRPreview"
			},
		Author->{"andrey.shur", "robert", "weiran.wang", "eqian", "ben"}
	}
]