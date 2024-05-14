(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeAbsorbanceQuantification*)


DefineUsage[AnalyzeAbsorbanceQuantification,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeAbsorbanceQuantification[dataObjs]", "object"},
			Description -> "calculates sample concentration using Beer's Law along with absorbance and volume measurements and calculated extinction coefficients.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "dataObjs",
						Description -> "The data objects to be analyzed.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Data, AbsorbanceSpectroscopy], Object[Data, AbsorbanceIntensity]}]]
					},
					IndexName -> "experiment data"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The quantification analyses resulting from finding volume and/or concentration from the samples and data in the quantificationProcess provided.",
					Pattern :> ObjectP[Object[Analysis,AbsorbanceQuantification]]
				}
			}
		}
	},
	MoreInformation -> {
		"Concentrations are calculated for each sample in the protocol.",
		"This function analyzes only the last absorbance spectroscopy data from each well in the quantification protocol.  If iteration occurred during the protocol, only the data from the final iteration will be analyzed."
	},

	SeeAlso -> {
		"PlotAbsorbanceQuantification",
		"AnalyzeTotalProteinQuantification",
		"Concentration"
	},
	Author -> {"Yahya.Benslimane", "pnafisi", "steven", "david.hattery", "qian", "alice", "brad", "srikant", "catherine"},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	}
}];


(* ::Subsubsection:: *)
(*AnalyzeAbsorbanceQuantificationOptions*)


DefineUsage[AnalyzeAbsorbanceQuantificationOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeAbsorbanceQuantificationOptions[quantificationProtocol]", "options"},
			Description -> "returns all 'options' for AnalyzeAbsorbanceQuantification['quantificationProtocol'] with all Automatic options resolved to fixed values.",
			Inputs :> {
				{
					InputName -> "quantificationProtocol",
					Description -> "The quantification protocol to be analyzed.",
					Widget -> Alternatives[
						Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,AbsorbanceQuantification]]],
						Adder[
							Widget[Type->Object, Pattern:>ObjectP[Object[Data,AbsorbanceSpectroscopy]]]
						]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the AnalyzeAbsorbanceQuantification call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	
	},

	SeeAlso -> {
		"AnalyzeAbsorbanceQuantification",
		"AnalyzePeaksOptions"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ValidAnalyzeAbsorbanceQuantificationQ*)


DefineUsage[ValidAnalyzeAbsorbanceQuantificationQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAnalyzeAbsorbanceQuantificationQ[quantificationProtocol]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of AnalyzeAbsorbanceQuantification['quantificationProtocol'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "quantificationProtocol",
					Description -> "The quantification protocol to be analyzed.",
					Widget -> Alternatives[
						Widget[Type->Object, Pattern:>ObjectP[Object[Protocol,AbsorbanceQuantification]]],
						Adder[
							Widget[Type->Object, Pattern:>ObjectP[Object[Data,AbsorbanceSpectroscopy]]]
						]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of AnalyzeAbsorbanceQuantification['quantificationProtocol'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		}
		
	
	},

	SeeAlso -> {
		"AnalyzeAbsorbanceQuantification",
		"ValidAnalyzePeaksQ"
	},
	Author -> {"scicomp", "brad"}
}];