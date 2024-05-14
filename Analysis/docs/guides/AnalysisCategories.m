

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Section:: *)
(*Analysis Categories Guide*)


Guide[
  Title->"Analysis Categories",
  Abstract->"",
  Reference->{
		"Signal Processing"->{
			{AnalyzePeaks,"Find peaks in a signal or image's intensity."},
			{AnalyzeFractions},
			{AnalyzeMeltingPoint},
			{AnalyzeQuantificationCycle},
            		{AnalyzeDynamicLightScatteringLoading}
		},
		"Fitting & Standard Curves"->{
			{AnalyzeFit,""},
			{AnalyzeCopyNumber},
			{AnalyzeAbsorbanceQuantification},
			{AnalyzeTotalProteinQuantification}
		},
		"Model Fitting"->{
			{AnalyzeKinetics},
			{AnalyzeThermodynamics}
		},
		"Clustering"->{
			{AnalyzeGating}
		},
		"Image Processing"->{
			{AnalyzeCellCount},
			{AnalyzeMicroscopeOverlay}
		}

	},
	RelatedGuides->{GuideLink["Experiment Analysis"]}
];
