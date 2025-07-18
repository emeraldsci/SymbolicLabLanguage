(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeComposition*)


DefineUsage[AnalyzeComposition,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeComposition[protocol]", "object"},
			Description -> "analyzes the chemical composition of chromatogram peaks in a HPLC protocol.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "The HPLC protocol that contains the SamplesIn/Standards that will be analyzed.",
					Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,HPLC]]]
				}
			},
			Outputs:>{
				{
					OutputName -> "object",
					Description -> "The analysis object that contains the analyzed compositions of the SamplesIn based on the Standards.",
					Pattern :> ObjectP[Object[Analysis,Composition]]
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"ExperimentHPLC"
	},
	Author -> {"melanie.reschke", "kevin.hou", "thomas"},
	Preview->True
}];


(* ::Subsubsection:: *)
(*AnalyzeCompositionOptions*)


DefineUsage[AnalyzeCompositionOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeCompositionOptions[protocol]", "options"},
			Description -> "returns the resolved options for the analysis of chemical composition of chromatogram peaks in a HPLC protocol.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "The HPLC protocol that contains the SamplesIn/Standards that will be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, HPLC]]]
				}
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for a composition analysis.",
					Pattern :> {_Rule..}
				}
			}
		}

	},
	SeeAlso -> {
		"AnalyzeComposition",
		"AnalyzeCompositionPreview",
		"ValidAnalyzeCompositionQ"
	},
	Author -> {"melanie.reschke", "kevin.hou", "thomas"}
}];


(* ::Subsubsection:: *)
(*AnalyzeCompositionPreview*)


DefineUsage[AnalyzeCompositionPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeCompositionPreview[protocol]", "preview"},
			Description -> "generates a tabular preview of the results of an AnalyzeComposition analysis.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "The HPLC protocol that contains the SamplesIn/Standards that will be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, HPLC]]]
				}
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "A summary table of the retention time, peak area, and analyte concentration of each of the SamplesIn peaks in the input HPLC protocol.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		}

	},
	SeeAlso -> {
		"AnalyzeComposition",
		"AnalyzeCompositionOptions",
		"ValidAnalyzeCompositionQ"
	},
	Author -> {"melanie.reschke", "kevin.hou", "thomas"}
}];


(* ::Subsubsection:: *)
(*ValidAnalyzeCompositionQ*)


DefineUsage[ValidAnalyzeCompositionQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAnalyzeCompositionQ[protocol]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity of an AnalyzeComposition[] function call.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "The HPLC protocol that contains the SamplesIn/Standards that will be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, HPLC]]]
				}
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating whether issues were found when performing the analysis.",
					Pattern :> _EmeraldTestSummary| Boolean
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeComposition",
		"AnalyzeCompositionOptions",
		"AnalyzeCompositionPreview"
	},
	Author -> {"melanie.reschke", "kevin.hou", "thomas"}
}];