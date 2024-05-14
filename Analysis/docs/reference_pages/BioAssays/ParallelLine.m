(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeParallelLine*)


DefineUsage[AnalyzeParallelLine,
{
	BasicDefinitions -> {
		(* single analyte input *)
		{
			Definition -> {"AnalyzeParallelLine[standardXY, analyteXY]", "object"},
			Description -> "calculate the relative potency ratio between EC50 values in two dose-response fitted curves.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXY",
					Description -> "The set of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The parallel line object containing analysis results from the fitted curves.",
					Pattern :> ObjectP[Object[Analysis, ParallelLine]]
				}
			}
		}(*,
		
		(* list of analyte inputs *)
		{
			Definition -> {"AnalyzeParallelLine[standardXY, analyteXYs]", "objects"},
			Description -> "calculate the relative potency ratio between 'standardXY' and each of 'analyteXYs' in the two dose-response fitted curves.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXYs",
					Description -> "A list of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Adder[Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]]
				}
			},
			Outputs :> {
				{
					OutputName -> "objects",
					Description -> "The parallel line objects containing analysis results from the fitted curves.",
					Pattern :> {ObjectP[Object[Analysis, ParallelLine]]..}
				}
			}
		}*)

	},
	MoreInformation -> {
		"This function uses Four Parameter Logistic Regression method to analyze dose-response curves, as described in Object[Report,Literature,\"id:4pO6dM55jxYr\"]: Gottschalk, P.D. and Dunn, J.R. 2005. Measuring parallelism, linearity, and relative potency in bioassay and immunoassay data. Journal of Biopharmaceutical Statistics 15(3): 437-463.."
	},
	
	SeeAlso -> {
		"AnalyzeFit",
		"PlotFit"
	},
	Author -> {"scicomp", "brad"},
	Preview->True
}];


(* ::Subsubsection:: *)
(*AnalyzeParallelLineOptions*)


DefineUsage[AnalyzeParallelLineOptions,
{
	BasicDefinitions -> {
	
		{
			Definition -> {"AnalyzeParallelLineOptions[standardXY, analyteXY]", "options"},
			Description -> "returns all 'options' for AnalyzeParallelLine['standardXY', 'analyteXY'] with all Automatic options resolved to fixed values.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXY",
					Description -> "The set of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeParallelLine call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		
		(* list of analyte data input *)
		{
			Definition -> {"AnalyzeParallelLineOptions[standardXY, analyteXYs]", "options"},
			Description -> "returns all 'options' for AnalyzeParallelLine['standardXY', 'analyteXYs'] with all Automatic options resolved to fixed values.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXYs",
					Description -> "A list of of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Adder[Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeParallelLine call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
		
	},
	
	SeeAlso -> {
		"AnalyzeParallelLine",
		"AnalyzeFitOptions"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*AnalyzeParallelLinePreview*)


DefineUsage[AnalyzeParallelLinePreview,
{
	BasicDefinitions -> {
	
		{
			Definition -> {"AnalyzeParallelLinePreview[standardXY, analyteXY]", "preview"},
			Description -> "returns a graphical display representing AnalyzeParallelLine['standardXY', 'analyteXY'] output.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXY",
					Description -> "The set of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the AnalyzeParallel call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
		},
		
		{
			Definition -> {"AnalyzeParallelLinePreview[standardXY, analyteXYs]", "preview"},
			Description -> "returns a graphical display representing AnalyzeParallelLine['standardXY', 'analyteXYs'] output.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXYs",
					Description -> "A list of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Adder[Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the AnalyzeParallel call output.",
					Pattern :> {(ValidGraphicsP[] | Null)..}
				}
			}
		}

	},
	
	SeeAlso -> {
		"AnalyzeParallel",
		"AnalyzeFitPreview"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ValidAnalyzeParallelLineQ*)


DefineUsage[ValidAnalyzeParallelLineQ,
{
	BasicDefinitions -> {

		{
			Definition -> {"ValidAnalyzeParallelLineQ[standardXY, analyteXY]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeParallelLine['standardXY', 'analyteXY'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXY",
					Description -> "The set of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeParallelLine['standardXY', 'analyteXY'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		},
		
		{
			Definition -> {"ValidAnalyzeParallelLineQ[standardXY, analyteXYs]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeParallelLine['standardXY', 'analyteXYs'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "standardXY",
					Description -> "The set of standard data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "analyteXYs",
					Description -> "A list of analyte data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Adder[Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Object, Pattern:>ObjectP[Object[Analysis, Fit]]],
						Widget[Type->Expression, Pattern:>(ObjectP[Object[Analysis, Fit]] | DataPointsP), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeParallelLine['standardXY', 'analyteXYs'].",
					Pattern :> {(EmeraldTestSummary| Boolean)..}
				}
			}
		}
	},
	
	SeeAlso -> {
		"AnalyzeParallelLine",
		"ValidAnalyzeFitQ"
	},
	Author -> {"scicomp", "brad"}
}];