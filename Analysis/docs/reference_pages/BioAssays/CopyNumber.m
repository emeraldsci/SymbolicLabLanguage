(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeCopyNumber*)

DefineUsage[AnalyzeCopyNumber,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCopyNumber[quantificationCycles,standardCurve]","object"},
				Description->"calculates the copy number for each of the 'quantificationCycles' based on a 'standardCurve' of quantification cycle vs Log10 copy number.",
				Inputs:>{
					{
						InputName->"quantificationCycles",
						Description->"The quantification cycle analysis objects to be analyzed.",
						Widget->Adder[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
						]
					},
					{
						InputName->"standardCurve",
						Description->"The linear fit analysis object of quantification cycle vs Log10 copy number to be used for analysis. If a new standard curve is needed, copy number and quantification cycle analysis object pairs may be provided for performing a new linear fit.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]]],
							Adder[{
								"Copy Number"->Widget[Type->Number,Pattern:>GreaterP[0]],
								"Quantification Cycle Analysis"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
							}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"objects",
						Description->"The objects containing copy number analysis results.",
						Pattern:>ObjectP[Object[Analysis,CopyNumber]]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCopyNumberOptions",
			"AnalyzeCopyNumberPreview",
			"ValidAnalyzeCopyNumberQ",
			"PlotCopyNumber",
			"AnalyzeQuantificationCycle",
			"AnalyzeFit",
			"ExperimentqPCR"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"},
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
(*AnalyzeCopyNumberOptions*)

DefineUsage[AnalyzeCopyNumberOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCopyNumberOptions[quantificationCycles,standardCurve]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeCopyNumber when it is called on 'quantificationCycles' and 'standardCurve'.",
				Inputs:>{
					{
						InputName->"quantificationCycles",
						Description->"The quantification cycle analysis objects to be analyzed.",
						Widget->Adder[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
						]
					},
					{
						InputName->"standardCurve",
						Description->"The linear fit of quantification cycle vs Log10 copy number to be used for analysis. If a new standard curve is needed, copy number and quantification cycle analysis object pairs may be provided for performing a new linear fit.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]]],
							Adder[{
								"Copy Number"->Widget[Type->Number,Pattern:>GreaterP[0]],
								"Quantification Cycle Analysis"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
							}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"The resolved options when AnalyzeCopyNumber is called on the inputs.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCopyNumber",
			"AnalyzeCopyNumberPreview",
			"ValidAnalyzeCopyNumberQ"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeCopyNumberPreview*)

DefineUsage[AnalyzeCopyNumberPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCopyNumberPreview[quantificationCycles,standardCurve]","preview"},
				Description->"returns the graphical preview for AnalyzeCopyNumber when it is called on 'quantificationCycles' and 'standardCurve', generated via PlotCopyNumber.",
				Inputs:>{
					{
						InputName->"quantificationCycles",
						Description->"The quantification cycle analysis objects to be analyzed.",
						Widget->Adder[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
						]
					},
					{
						InputName->"standardCurve",
						Description->"The linear fit of quantification cycle vs Log10 copy number to be used for analysis. If a new standard curve is needed, copy number and quantification cycle analysis object pairs may be provided for performing a new linear fit.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]]],
							Adder[{
								"Copy Number"->Widget[Type->Number,Pattern:>GreaterP[0]],
								"Quantification Cycle Analysis"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
							}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"The graphical preview representing the output of AnalyzeCopyNumber.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCopyNumber",
			"AnalyzeCopyNumberOptions",
			"ValidAnalyzeCopyNumberQ"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeCopyNumberQ*)

DefineUsage[ValidAnalyzeCopyNumberQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidAnalyzeCopyNumberQ[quantificationCycles,standardCurve]","boolean"},
				Description->"checks whether the provided 'quantificationCycles', 'quantificationCycles', and specified options are valid for calling AnalyzeCopyNumber.",
				Inputs:>{
					{
						InputName->"quantificationCycles",
						Description->"The quantification cycle analysis objects to be analyzed.",
						Widget->Adder[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
						]
					},
					{
						InputName->"standardCurve",
						Description->"The linear fit of quantification cycle vs Log10 copy number to be used for analysis. If a new standard curve is needed, copy number and quantification cycle analysis object pairs may be provided for performing a new linear fit.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]]],
							Adder[{
								"Copy Number"->Widget[Type->Number,Pattern:>GreaterP[0]],
								"Quantification Cycle Analysis"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]]]
							}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"The value indicating whether the AnalyzeCopyNumber call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCopyNumber",
			"AnalyzeCopyNumberOptions",
			"AnalyzeCopyNumberPreview"
		},
		Author->{"scicomp", "brad", "kstepurska", "eqian"}
	}
];