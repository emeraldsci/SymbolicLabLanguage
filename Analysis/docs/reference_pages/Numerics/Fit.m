(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFit*)


DefineUsage[AnalyzeFit,
{
	BasicDefinitions -> {
		(* two inputs *)
		{
			Definition -> {"AnalyzeFit[coordinates, fitType]", "f"},
			Description -> "fits a function 'f' of type 'fitType' to the given coordinates.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Alternatives[
						Adder[
							{
								"X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						],
						Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | _?QuantityMatrixQ | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), PatternTooltip->"The set of data points to fit to.", Size->Paragraph]
					]
				},
				{
					InputName -> "fitType",
					Description -> "Type of expression to fit, e.g. Polynomial or Exponential, or, a pure function to fit to.",
					Widget -> Alternatives[
						(* Widget[Type->Enumeration, Pattern:>Linear|Cubic|Polynomial|Exponential|Gaussian|Sigmoid|Log|LogLinear|LinearLog|LogPolynomial|Tanh|ArcTan|Erf|Logistic|LogisticBase10|GeneralizedLogistic|LogisticFourParam|Automatic], *)
						Widget[Type->Enumeration, Pattern:> (FitTypeP | Automatic)],
						Widget[Type->Expression,Pattern:>_Function,PatternTooltip->"A pure function that will be used to fit the data.",Size->Paragraph]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "f",
					Description -> "The function of type 'fitType' that best fits the data 'xy'.",
					Pattern :> _Function
				}
			}
		}
	},

	SeeAlso -> {
		"PlotFit",
		"AnalyzeThermodynamics",
		"AnalyzeLadder",
		"NonlinearModelFit",
		"FindFit"
	},
	Author -> {"scicomp", "brad", "amir.saadat"},
	Preview->True
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzeFitOptions*)


DefineUsage[AnalyzeFitOptions,
{
	BasicDefinitions -> {
		(* two inputs *)
		{
			Definition -> {"AnalyzeFitOptions[coordinates, fitType]", "options"},
			Description -> "returns all 'options' for AnalyzeFit['coordinates', 'fitType'] with all Automatic options resolved to fixed values.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				},
				{
					InputName -> "fitType",
					Description -> "Type of expression to fit, e.g. Polynomial or Exponential, or, a pure function to fit to.",
					Widget -> Widget[Type->Enumeration, Pattern:>(FitTypeP | Automatic)]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeFit call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},

		(* one input *)
		{
			Definition -> {"AnalyzeFitOptions[coordinates]", "options"},
			Description -> "returns all 'options' for AnalyzeFit['coordinates'] with all Automatic options resolved to fixed values.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeFit call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}

	},

	SeeAlso -> {
		"AnalyzeFit",
		"AnalyzePeaksOptions"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzeFitPreview*)


DefineUsage[AnalyzeFitPreview,
{
	BasicDefinitions -> {
		(* two inputs *)
		{
			Definition -> {"AnalyzeFitPreview[coordinates, fitType]", "preview"},
			Description -> "returns a graphical display representing AnalyzeFit['coordinates', 'fitType'] output.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				},
				{
					InputName -> "fitType",
					Description -> "Type of expression to fit, e.g. Polynomial or Exponential, or, a pure function to fit to.",
					Widget -> Widget[Type->Enumeration, Pattern:>(FitTypeP | Automatic)]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the AnalyzeFit call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
		},

		(* one input *)
		{
			Definition -> {"AnalyzeFitPreview[coordinates]", "preview"},
			Description -> "returns a graphical display representing AnalyzeFit['coordinates'] output.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the AnalyzeFit call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
		}

	},

	SeeAlso -> {
		"AnalyzeFit",
		"AnalyzePeaksPreview"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeFitQ*)


DefineUsage[ValidAnalyzeFitQ,
{
	BasicDefinitions -> {
		(* two inputs *)
		{
			Definition -> {"ValidAnalyzeFitQ[coordinates, fitType]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeFit['coordinates', 'fitType'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				},
				{
					InputName -> "fitType",
					Description -> "Type of expression to fit, e.g. Polynomial or Exponential, or, a pure function to fit to.",
					Widget -> Widget[Type->Enumeration, Pattern:>(FitTypeP | Automatic)]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeFit['coordinates', 'fitType'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		},

		(* one input *)
		{
			Definition -> {"ValidAnalyzeFitQ[coordinates]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeFit['coordinates'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "coordinates",
					Description -> "The set of data points to fit to. Points can be numbers, quantities, distributions, or objects.",
					Widget -> Widget[Type->Expression, Pattern:>(MatrixP[UnitsP[] | _?DistributionParameterQ | ObjectReferenceP[] | FieldReferenceP[]] | {({UnitsP[]..} | {ObjectP[]..} | {FieldReferenceP[]..} | ObjectReferenceP[] | FieldReferenceP[])..}), Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeFit['coordinates'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		}

	},

	SeeAlso -> {
		"AnalyzeFit",
		"ValidAnalyzePeaksQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ConvertGradient*)


DefineUsage[ConvertGradient,
{
	BasicDefinitions -> {
		{"ConvertGradient[{{time, {percentA, percentB, percentC, percentD}, flowRate, curveNumber}..}]", "{{currentTime, currentA, currentB, currentC, currentD, currentFowRate}..}", "approximates the flow rate percent over gradient segment time based on curve number as showed in Waters Empower software."}
	},
	Input :> {
		{"time", _?TimeQ, "The time length of gradient segment."},
		{"percentA", _?PercentQ, "Percent composition setting of solvent A."},
		{"percentB", _?PercentQ, "Percent composition setting of solvent B."},
		{"percentC", _?PercentQ, "Percent composition setting of solvent C."},
		{"percentD", _?PercentQ, "Percent composition setting of solvent D."},
		{"flowRate", GreaterP[0 Milliliter/Minute], "The flow rate."},
		{"curveNumber", RangeP[1,11], "Different kinds of gradient curve as indicated in integers range from 1 to 11. 1 and 11 are step fuctions, 2-5 are convex curves and 6-10 are concave curves."}
	},
	Output :> {
		{"currentTime", _?TimeQ, "The current sampling time by which each solvent composition is sampled."},
		{"currentA", _?PercentQ, "The resulting percent composition of solvent A at each sampling time point."},
		{"currentB", _?PercentQ, "The resulting percent composition of solvent B at each sampling time point."},
		{"currentC", _?PercentQ, "The resulting percent composition of solvent C at each sampling time point."},
		{"currentD", _?PercentQ, "The resulting percent composition of solvent D at each sampling time point."},
		{"currentFowRate", GreaterP[0 Milliliter/Minute], "The current flow rate of the current time."}
	},
	SeeAlso -> {
		"ExperimentHPLC",
		"UploadGradientMethod"
	},
	Author -> {"scicomp", "brad"}
}];