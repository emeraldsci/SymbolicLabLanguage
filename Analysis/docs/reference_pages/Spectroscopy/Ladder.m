(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeLadder*)


DefineUsageWithCompanions[AnalyzeLadder,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeLadder[peaks]", "object"},
			Description -> "fits a standard curve function to molecular size (e.g. oligomer length) from peak position.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "peaks",
						Description -> "An Object[Analysis, Peaks] Object whose positions will be used in the standard curve fitting.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Analysis,Peaks]]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis results from fitting the standard curve.",
					Pattern :> ObjectP[Object[Analysis, Ladder]]
				}
			}
		},

		{
			Definition -> {"AnalyzeLadder[data]", "object"},
			Description -> "fits the standard curve to peak positions taken from the most recent peaks analysis linked to the given data object. Runs AnalyzePeaks if no linked analysis object is found.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "data",
						Description -> "A data object that has peaks associated.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Data,Chromatography],
							Object[Data,PAGE],
							Object[Data,Western],
							Object[Data, AgaroseGelElectrophoresis],
							Object[Data,CapillaryGelElectrophoresisSDS]}]
						]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis results from fitting the standard curve.",
					Pattern :> ObjectP[Object[Analysis, Ladder]]
				}
			}
		}

	},

	SeeAlso -> {
		"AnalyzePeaks",
		"PlotLadder",
		"AnalyzeFit"
	},
	Author -> {"scicomp"},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	},
	Preview->True

}];
