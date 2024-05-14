(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDigitalPCR*)


DefineUsage[ExperimentDigitalPCR,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDigitalPCR[Samples,PrimerPairs,Probes]","Protocol"},
				Description->"creates a digital polymerase chain reaction 'Protocol', which uses a digital PCR instrument to quantify DNA or RNA targets by partitioning a mixture of 'Samples', 'PrimerPairs' and fluorescent 'Probes' into droplets, performing PCR and counting droplets with or without fluorescence signal.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"One or more pairs of short oligomer strands designed to bind the template sequence and function as an anchor for polymerases and transcriptases. Specify multiple pairs for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									{
										"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}],
										"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
									}
								],
								{
									"Forward Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
									"Reverse Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"One or more short oligomer strands containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence. Specify multiple probes for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
								],
								Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the Digital PCR experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol, DigitalPCR]]]
					}
				}
			},
			{
				Definition->{"ExperimentDigitalPCR[Samples]","Protocol"},
				Description->"creates a digital polymerase chain reaction 'Protocol', which uses a digital PCR instrument to quantify DNA or RNA targets by partitioning reaction mixture provided in 'Samples' into droplets, performing PCR and counting droplets with or without fluorescence signal.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Model[Sample],Object[Sample]},
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
						Description->"The protocol object describing how to run the Digital PCR experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol, DigitalPCR]]]
					}
				}
			}
		},
		MoreInformation->{
			"Multiple genetic targets can be detected in each sample by multiplexing primer pairs and probes using the following strategies:
			\tUp to four genetic targets can be multiplexed using probes, each with a fluorophore with emission specific to one of the four channels [Detection wavelengths: 517 nm, 556 nm, 665 nm, 694 nm].
			\tGenetic targets can be multiplexed within each channel using graded primer and probe concentrations that will affect the fluorescence signal amplitude of the droplets with the corresponding target gene and result in droplet populations separated by signal amplitude.",
			"Primer sets containing a forward primer and a reverse primer can be used to conduct ExperimentDigitalPCR by using the same primer set object as primerPair inputs for \"Forward Primer\" and \"Reverse Primer\".",
			"Target assays containing a forward primer, a reverse primer and a probe can be used to conduct ExperimentDigitalPCR by using the same target assay object as primerPair inputs for \"Forward Primer\" and \"Reverse Primer\" and probe input."
		},
		SeeAlso->{
			"ExperimentPCR",
			"ExperimentqPCR",
			"ExperimentDigitalPCROptions",
			"ExperimentDigitalPCRPreview",
			"ValidExperimentDigitalPCRQ"
		},
		Author->{"tyler.pabst", "daniel.shlian", "nont.kosaisawe", "malav.desai"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDigitalPCROptions*)


DefineUsage[ExperimentDigitalPCROptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDigitalPCROptions[Samples,PrimerPairs,Probes]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' for ExperimentDigitalPCR when it is called on 'Samples', 'PrimerPairs' and fluorescent 'Probes'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"One or more pairs of short oligomer strands designed to bind the template sequence and function as an anchor for polymerases and transcriptases. Specify multiple pairs for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									{
										"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}],
										"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
									}
								],
								{
									"Forward Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
									"Reverse Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"One or more short oligomer strands containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence. Specify multiple probes for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
								],
								Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentDigitalPCR is called on the inputs samples, PrimerPairs and probes.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"ExperimentDigitalPCROptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentDigitalPCR when it is called on the input 'Samples' that already contain primers and probes.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Model[Sample],Object[Sample]},
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
						Description->"The resolved options when ExperimentDigitalPCR is called on the inputs samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDigitalPCR",
			"ExperimentDigitalPCRPreview",
			"ValidExperimentDigitalPCRQ"
		},
		Author->{"malav.desai", "waseem.vali"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDigitalPCRPreview*)


DefineUsage[ExperimentDigitalPCRPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDigitalPCRPreview[Samples,PrimerPairs,Probes]","Preview"},
				Description->"returns a graphical 'Preview' for ExperimentDigitalPCR when it is called on 'Samples', 'PrimerPairs' and fluorescent 'Probes'. The output value is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"One or more pairs of short oligomer strands designed to bind the template sequence and function as an anchor for polymerases and transcriptases. Specify multiple pairs for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									{
										"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}],
										"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
									}
								],
								{
									"Forward Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
									"Reverse Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"One or more short oligomer strands containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence. Specify multiple probes for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
								],
								Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentDigitalPCR. The output value is always Null.",
						Pattern:>Null
					}
				}
			},
			{
				Definition->{"ExperimentDigitalPCRPreview[Samples]","Preview"},
				Description->"returns a graphical 'Preview' for ExperimentDigitalPCR when it is called on input 'Samples'. The output value is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Model[Sample],Object[Sample]},
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
						Description->"The graphical preview representing the output of ExperimentDigitalPCR. The output value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDigitalPCR",
			"ExperimentDigitalPCROptions",
			"ValidExperimentDigitalPCRQ"
		},
		Author->{"malav.desai", "waseem.vali"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentDigitalPCRQ*)


DefineUsage[ValidExperimentDigitalPCRQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentDigitalPCRQ[Samples,PrimerPairs,Probes]","Boolean"},
				Description->"checks whether the provided 'Samples', 'PrimerPairs', 'Probes', and specified options are valid for calling ExperimentDigitalPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"One or more pairs of short oligomer strands designed to bind the template sequence and function as an anchor for polymerases and transcriptases. Specify multiple pairs for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									{
										"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}],
										"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
									}
								],
								{
									"Forward Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
									"Reverse Primer"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"One or more short oligomer strands containing a reporter and quencher, which when separated during the synthesis reaction will result in fluorescence. Specify multiple probes for a given sample to perform multiplexing.",
							Widget->Alternatives[
								Adder[
									Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],ObjectTypes->{Model[Sample], Object[Sample]},Dereference->{Object[Container]->Field[Contents[[All,2]]]}]
								],
								Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentDigitalPCR call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>Alternatives[_EmeraldTestSummary,BooleanP]
					}
				}
			},
			{
				Definition->{"ValidExperimentDigitalPCRQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentDigitalPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample from which the target will be partitioned and amplified.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Model[Sample],Object[Sample]},
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Boolean",
						Description->"The value indicating whether the ExperimentDigitalPCR call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>Alternatives[_EmeraldTestSummary,BooleanP]
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDigitalPCR",
			"ExperimentDigitalPCROptions",
			"ExperimentDigitalPCRPreview"
		},
		Author->{"malav.desai", "waseem.vali"}
	}
];