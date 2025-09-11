(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFractions*)


DefineUsageWithCompanions[AnalyzeFractions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeFractions[chromData]", "pickedSamples"},
			Description -> "selects fractions from a given chromatograph to be carried forward for further analysis.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "chromData",
						Description -> "Chromatography data with collected fractions.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data,Chromatography]]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "pickedSamples",
					Description -> "Set of samples picked from the given collected fractions.",
					Pattern :> {ObjectP[Object[Sample]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzeFractions[chromProtocol]", "pickedSamples"},
			Description -> "analyzes all data in the given protocol.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "chromProtocol",
						Description -> "Chromatography protocol.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Protocol,HPLC],Object[Protocol,FPLC]}]
						]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "pickedSamples",
					Description -> "Set of samples picked from the given collected fractions.",
					Pattern :> {ObjectP[Object[Sample]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzeFractions[collectedFracs]", "pickedSamples"},
			Description -> "uses the given set of fractions as a starting point for the analysis, instead of starting by filtering based on peaks.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "collectedFracs",
						Description -> "Initial set of collected fractions.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis,Fractions]]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "pickedSamples",
					Description -> "Set of samples picked from the given collected fractions.",
					Pattern :> {ObjectP[Object[Sample]]..}
				}
			}
		}
	},
	MoreInformation -> {
		"The selection process first filters using the Peaks options followed by the Domain option.
		Within the domain, items can be excluded with the Exclude option and added back in with the Include option.
		Included items outside of the domain will not be selected."
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"ExperimentHPLC",
		"ParseHPLC"
	},
	Author -> {
		"scicomp"
	},
	Preview->True,
	PreviewOptions -> {"Domain","Include","Exclude"},
	ButtonActionsGuide->{
		{Description->"Change the visualization window", ButtonSet->"'Shift' + 'LeftDrag'"},
		{Description->"Change the analysis domain", ButtonSet->"'RightDrag' the dashed lines"},
		{Description->"Select fractions", ButtonSet->"'Shift' + 'RightClick'"}
	}
}];



(* ::Subsubsection::Closed:: *)
(*AnalyzeFractionsApp*)


DefineUsage[AnalyzeFractionsApp,
{
	BasicDefinitions -> {
		{"AnalyzeFractionsApp[chromData]", "pickedSamples", "selects fractions from a given chromatograph to be carried forward for further analysis."},
		{"AnalyzeFractionsApp[chromProtocol]", "{pickedSamples..}", "analyzes all data in the given protocol."},
		{"AnalyzeFractionsApp[collectedFracs]", "pickedSamples", "uses the given set of fractions as a starting point for the analysis, instead of starting by filtering based on peaks."}
	},
	MoreInformation -> {
		"The selection process first filters using the Peaks options, then filters against the Exclude option, and finally filters on the Include option."
	},
	Input :> {
		{"collectedFracs", ObjectP[Object[Analysis,Fractions]], "Initial set of collected fractions."},
		{"chromData", ObjectP[Object[Data,Chromatography]], "Chromatography data with collected fractions."},
		{"chromProtocol", ObjectP[{Object[Protocol,HPLC],Object[Protocol,FPLC]}], "Chromatography protocol."}
	},
	Output :> {
		{"pickedSamples", {ObjectP[Object[Sample]]..}, "Set of samples picked from the given collected fractions."}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"ExperimentHPLC",
		"AnalyzeFractionsPreview"
	},
	Author -> {
		"brad",
		"Jenny",
		"robert"
	},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	},
	Tutorials -> {

	}
}];
