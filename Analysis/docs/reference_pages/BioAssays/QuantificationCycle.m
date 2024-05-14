(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeQuantificationCycle*)

DefineUsage[AnalyzeQuantificationCycle,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeQuantificationCycle[protocol]","object"},
				Description->"calculates the quantification cycle of each applicable amplification curve in the data linked to the provided quantitative polymerase chain reaction (qPCR) 'protocol'.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"The quantitative polymerase chain reaction (qPCR) protocol whose data are to be analyzed.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,qPCR]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"objects",
						Description->"The objects containing quantification cycle analysis results from the quantitative polymerase chain reaction (qPCR) protocol.",
						Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]
					}
				}
			},
			{
				Definition->{"AnalyzeQuantificationCycle[data]","object"},
				Description->"calculates the quantification cycle of each applicable amplification curve in the provided quantitative polymerase chain reaction (qPCR) 'data'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"data",
							Description->"The quantitative polymerase chain reaction (qPCR) data to be analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Data,qPCR]]
							]
						},
						IndexName->"input data"
					]
				},
				Outputs:>{
					{
						OutputName->"objects",
						Description->"The objects containing quantification cycle analysis results from the quantitative polymerase chain reaction (qPCR) data.",
						Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]
					}
				}
			}
		},
		MoreInformation->{
			"The quantification cycle is defined by default as the cycle at which the normalized and baseline-subtracted amplification curve crosses the fluorescence signal threshold set for that amplification target. If Method->Threshold, the amplification targets are defined by the unique sets of ForwardPrimer, ReversePrimer, and Probe (if applicable), and the quantification cycle for each amplification curve is determined via interpolation.",
			"The quantification cycle is defined alternatively as the inflection point of the normalized and baseline-subtracted amplification curve. If Method->InflectionPoint, the quantification cycle is determined by fitting a logistic curve of the form a+b/(1+Exp[c*(x-InflectionPoint)]) to each amplification curve."
		},
		SeeAlso->{
			"AnalyzeQuantificationCycleOptions",
			"AnalyzeQuantificationCyclePreview",
			"ValidAnalyzeQuantificationCycleQ",
			"PlotQuantificationCycle",
			"AnalyzeCopyNumber",
			"ExperimentqPCR"
		},
		Author->{"lige.tonggu", "waseem.vali", "josh.kenchel", "kstepurska", "eqian", "brad"},
		Guides->{
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials->{
		},
		Preview->True
	}
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeQuantificationCycleOptions*)

DefineUsage[AnalyzeQuantificationCycleOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeQuantificationCycleOptions[protocol]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeQuantificationCycle when it is called on 'protocol'.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"The quantitative polymerase chain reaction (qPCR) protocol whose data are to be analyzed.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,qPCR]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"The resolved options when AnalyzeQuantificationCycle is called on the input protocol.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"AnalyzeQuantificationCycleOptions[data]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeQuantificationCycle when it is called on 'data'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"data",
							Description->"The quantitative polymerase chain reaction (qPCR) data to be analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Data,qPCR]]
							]
						},
						IndexName->"input data"
					]
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"The resolved options when AnalyzeQuantificationCycle is called on the input data.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeQuantificationCycle",
			"AnalyzeQuantificationCyclePreview",
			"ValidAnalyzeQuantificationCycleQ"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeQuantificationCyclePreview*)

DefineUsage[AnalyzeQuantificationCyclePreview,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeQuantificationCyclePreview[protocol]","preview"},
				Description->"returns the graphical preview for AnalyzeQuantificationCycle when it is called on 'protocol', generated via PlotQuantificationCycle.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"The quantitative polymerase chain reaction (qPCR) protocol whose data are to be analyzed.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,qPCR]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"The graphical preview representing the output of AnalyzeQuantificationCycle.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"AnalyzeQuantificationCyclePreview[data]","preview"},
				Description->"returns the graphical preview for AnalyzeQuantificationCycle when it is called on 'data', generated via PlotQuantificationCycle.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"data",
							Description->"The quantitative polymerase chain reaction (qPCR) data to be analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Data,qPCR]]
							]
						},
						IndexName->"input data"
					]
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"The graphical preview representing the output of AnalyzeQuantificationCycle.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeQuantificationCycle",
			"AnalyzeQuantificationCycleOptions",
			"ValidAnalyzeQuantificationCycleQ"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeQuantificationCycleQ*)

DefineUsage[ValidAnalyzeQuantificationCycleQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidAnalyzeQuantificationCycleQ[protocol]","boolean"},
				Description->"checks whether the provided 'protocol' and specified options are valid for calling AnalyzeQuantificationCycle.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"The quantitative polymerase chain reaction (qPCR) protocol whose data are to be analyzed.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,qPCR]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"The value indicating whether the AnalyzeQuantificationCycle call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			},
			{
				Definition->{"ValidAnalyzeQuantificationCycleQ[data]","boolean"},
				Description->"checks whether the provided 'data' and specified options are valid for calling AnalyzeQuantificationCycle.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"data",
							Description->"The quantitative polymerase chain reaction (qPCR) data to be analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Data,qPCR]]
							]
						},
						IndexName->"input data"
					]
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"The value indicating whether the AnalyzeQuantificationCycle call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeQuantificationCycle",
			"AnalyzeQuantificationCycleOptions",
			"AnalyzeQuantificationCyclePreview"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];