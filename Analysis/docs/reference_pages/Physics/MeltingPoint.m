(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeMeltingPoint*)


DefineUsage[AnalyzeMeltingPoint,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeMeltingPoint[meltingData]", "object"},
			Description -> "calculates melting temperature from melting curves that are stored in 'meltingData' object.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingData",
						Description -> "Thermodynamics data objects that will be analyzed for melting temperature.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{
								Object[Data, MeltingCurve], Object[Data, FluorescenceThermodynamics], Object[Data, qPCR],
								Object[Data, MeltingPoint]
							}]
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The Analysis object containing melting temperature calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, MeltingPoint]]
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPoint[meltingProtocol]", "object"},
			Description -> "calculates melting temperature from melting curves that are stored in 'meltingProtocol' object.",
			Inputs :> {
					{
						InputName -> "meltingProtocol",
						Description -> "Protocol objects that contains thermodynamics data objects for melting temperature analysis.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{
								Object[Protocol,UVMelting], Object[Protocol,FluorescenceThermodynamics], Object[Protocol,ThermalShift],
								Object[Protocol, DynamicLightScattering], Object[Protocol, MeasureMeltingPoint]
							}]
						],
						Expandable -> False
					}
			},

			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The Analysis object containing melting temperature calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, MeltingPoint]]
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPoint[meltingRaw]", "object"},
			Description -> "calculates melting temperature from raw data points.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "meltingRaw",
						Description -> "Raw data points that require melting temperature analysis.",
						Widget -> Widget[
							Type -> Expression,
							Pattern :> CoordinatesP | QuantityCoordinatesP[{Celsius,AbsorbanceUnit}] | QuantityCoordinatesP[{Celsius,RFU}] | QuantityCoordinatesP[{Celsius,ArbitraryUnit}],
							PatternTooltip -> "Please input a list of numerical coordinates, or a list of quantities with x-axis being temperature and y-axis being absorbance.",
							Size -> Paragraph
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The Analysis object containing melting temperature calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, MeltingPoint]]
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPoint[meltingDataSet]", "object"},
			Description -> "calculates melting temperature from temperature and response data stored in a list of objects 'meltingDataSet', where each object contain one data point.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "meltingDataSet",
						Description -> "Intensity data objects that require melting temperature analysis.",
						Widget -> Adder[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Data,AbsorbanceIntensity]],
								PatternTooltip -> "A single custom data objects."
							]
						],
						Expandable -> False
          },
					IndexName -> "main input"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The Analysis object containing melting temperature calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, MeltingPoint]]
				}
			}
		}

	},

	SeeAlso -> {
		"AnalyzeFit",
		"SimulateMeltingTemperature",
		"PlotMeltingPoint"
	},
	Author -> {
		"scicomp",
		"amir.saadat",
		"brad",
		"jay.li"
	},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	},
	Tutorials -> {

	},
	Preview->True
}];



(* ::Subsubsection::Closed:: *)
(*AnalyzeMeltingPointOptions*)


DefineUsage[AnalyzeMeltingPointOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeMeltingPointOptions[meltingData]", "options"},
			Description -> "resolve options to conduct AnalyzeMeltingPoint based on input 'meltingData'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingData",
						Description -> "Thermodynamics data objects that require melting temperature analysis.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzeMeltingPoint.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPointOptions[meltingProtocol]", "options"},
			Description -> "resolve options to conduct AnalyzeMeltingPoint based on input 'meltingProtocol'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingProtocol",
						Description -> "Protocol object that contains thermodynamics data objects for melting temperature analysis.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol,UVMelting], Object[Protocol,FluorescenceThermodynamics]}]],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzeMeltingPoint.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPointOptions[meltingRaw]", "options"},
			Description -> "resolve options to conduct AnalyzeMeltingPoint based on input 'meltingRaw'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingRaw",
						Description -> "Raw data points that require melting temperature analysis.",
						Widget -> Widget[
							Type -> Expression,
							Pattern :> CoordinatesP | QuantityCoordinatesP[Celsius | ArbitraryUnit],
							PatternTooltip -> "Please input a list of numerical coordinates, or a list of quantities with x-axis being temperature and y-axis being absorbance.",
							Size -> Paragraph
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzeMeltingPoint.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeMeltingPoint",
		"AnalyzeMeltingPointPreview",
		"ValidAnalyzeMeltingPointQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzeMeltingPointPreview*)


DefineUsage[AnalyzeMeltingPointPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeMeltingPointPreview[meltingData]", "preview"},
			Description -> "generate a graph as a preview of AnalyzeMeltingPoint result based on input 'meltingData'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingData",
						Description -> "Thermodynamics data objects that require melting temperature analysis.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzeMeltingPoint result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPointPreview[meltingProtocol]", "preview"},
			Description -> "generate a graph as a preview of AnalyzeMeltingPoint result based on input 'meltingProtocol'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingProtocol",
						Description -> "Protocol objects that contains thermodynamics data objects for melting temparature analysis.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Protocol,UVMelting], Object[Protocol,FluorescenceThermodynamics], Object[Protocol,ThermalShift]}]
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzeMeltingPoint result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AnalyzeMeltingPointPreview[meltingRaw]", "preview"},
			Description -> "generate a graph as a preview of AnalyzeMeltingPoint result based on input 'meltingRaw'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingRaw",
						Description -> "Raw data points that require melting temperature analysis.",
						Widget -> Widget[
							Type -> Expression,
							Pattern :> CoordinatesP | QuantityCoordinatesP[Celsius | ArbitraryUnit],
							PatternTooltip -> "Please input a list of numerical coordinates, or a list of quantities with x-axis being temperature and y-axis being absorbance.",
							Size -> Paragraph
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzeMeltingPoint result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeMeltingPoint",
		"AnalyzeMeltingPointOptions",
		"ValidAnalyzeMeltingPointQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeMeltingPointQ*)


DefineUsage[ValidAnalyzeMeltingPointQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAnalyzeMeltingPointQ[meltingData]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingData",
						Description -> "Thermodynamics data objects that require melting temperature analysis.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary| Boolean
				}
			}
		},
		{
			Definition -> {"ValidAnalyzeMeltingPointQ[meltingProtocol]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingProtocol",
						Description -> "Protocol objects that contains thermodynamics data objects for melting temparature analysis.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Protocol,UVMelting], Object[Protocol,FluorescenceThermodynamics], Object[Protocol,ThermalShift]}]
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary | Boolean
				}
			}
		},
		{
			Definition -> {"ValidAnalyzeMeltingPointQ[meltingRaw]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "meltingRaw",
						Description -> "Raw data points that require melting temperature analysis.",
						Widget -> Widget[
							Type -> Expression,
							Pattern :> CoordinatesP | QuantityCoordinatesP[Celsius | ArbitraryUnit],
							PatternTooltip -> "Please input a list of numerical coordinates, or a list of quantities with x-axis being temperature and y-axis being absorbance.",
							Size -> Paragraph
						],
						Expandable -> False
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary| Boolean
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeMeltingPoint",
		"AnalyzeMeltingPointOptions",
		"AnalyzeMeltingPointPreview"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*PlotMeltingPoint*)


DefineUsage[PlotMeltingPoint,
{
	BasicDefinitions -> {
		{"PlotMeltingPoint[analysisObject]", "fractionBoundCurve", "plots a melting curve normalized to fraction bound."}
	},
	Input :> {
		{"analysisObject", ObjectP[Object[Analysis, MeltingPoint]], "Melting point analysis object to plot."}
	},
	Output :> {
		{"fractionBoundCurve", _?ValidGraphicsQ, "Plot of the normalized melting curve generated by melting points analysis."}
	},
	SeeAlso -> {
		"AnalyzeMeltingPoint",
		"SimulateMeltingTemperature",
		"AnalyzeFit"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];
