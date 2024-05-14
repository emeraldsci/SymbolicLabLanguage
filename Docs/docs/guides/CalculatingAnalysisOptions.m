(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Calculating Analysis Options",
	Abstract -> "Collection of functions that resolves options for analysis functions organized by the subject matter they may be relevant to.",
	Reference -> {
		"Chromatography" -> {
			{AnalyzePeaksOptions, "Returns resolved options for calling AnalyzePeaks function to pick Peaks from protocol or data object."},
			{AnalyzeCompositionOptions, "Resolves options for analysis of chemical composition of chromatogram peaks in HPLC protocol."},
			{AnalyzeFractionsOptions, "Returns resolved options for the analysis of fractions when it is called on input protocol or data."},
			{AnalyzeLadderOptions, "Returns resolved options for fitting the standard curve function to molecular size for peaks or a given data object."}
		},
		"Spectroscopy" -> {
			{AnalyzePeaksOptions, "Returns resolved options for calling AnalyzePeaks function to pick Peaks from protocol or data object."},
			{AnalyzeAbsorbanceQuantificationOptions, "Returns resolved options for calling AnalyzeAbsorbanceQuantification function on quantification protocols."},
			{AnalyzeTotalProteinQuantificationOptions, "Returns resolved options for calling AnalyzeTotalProteinQuantification function to calculate total protein calculation based on total protein quantification assay data."},
			{AnalyzeDynamicLightScatteringOptions, "Returns resolved options for calling AnalyzeDynamicLightScattering function to calculate key parameters from input protocol or data object."},
			{AnalyzeDynamicLightScatteringLoadingOptions, "Returns resolved options for calling AnalyzeDynamicLightScatteringLoading function to perform threshold analysis of correlation curve data on dynamic light scattering data."}
		},
		"PCR" -> {
			{AnalyzeQuantificationCycleOptions,"Resolves options for calculating the quantification cycle of each applicable amplification curve for specified provided quantitative polymerase chain reaction (qPCR) protocol or data object."},
			{AnalyzeCopyNumberOptions, "Returns resolved options to calculate the copy number for each quantification cycle based on the standard curve of quantification cycle vs Log10 copy number."}
		},
		"Bioassays" -> {
			{AnalyzeBindingKineticsOptions, "Returns resolved options for calling AnalyzeBindingKinetics function to solve the kinetic association and dissociation rates."},
			{AnalyzeBindingQuantitationOptions, "Returns resolved options for calling AnalyzeBindingQuantitation function to determine the concentration of the analyte."},
			{AnalyzeEpitopeBinningOptions, "Returns resolved options for the classification of antibodies by their interaction with a given antigen from biolayer interferometry data."},
			(*{AnalyzeCompensationMatrixOptions, "Returns resolved options for AnalyzeCompensationMatrix when it is called on input protocol."},*)
			{AnalyzeDNASequencingOptions, "Returns the resolved options for a DNA sequencing experiment when run on a set of sequencing data."}
		},
		"Microscopy" -> {
			{AnalyzeMicroscopeOverlayOptions, "Returns resolved options for AnalyzeMicroscopeOverlay when called on microscopy data objects."},
			{AnalyzeCellCountOptions, "Returns resolved options for AnalyzeCellCount when it called on Microscopic Data or images."}
		},
		"Quantification" -> {
			{AnalyzeAbsorbanceQuantificationOptions, "Returns resolved options for calling AnalyzeAbsorbanceQuantification function to calculate concentration of an analyte using Beer's Law."},
			{AnalyzeTotalProteinQuantificationOptions, "Returns resolved options for AnalyzeTotalProteinQuantification when it is called on input protocol."},
			{AnalyzeCopyNumberOptions, "Returns resolved options for calling AnalyzeCopyNumber function to calculate the estimated copy number of a given gene sequence based on qPCR data or Qualification Cycle Analysis."},
			{AnalyzeQuantificationCycleOptions, "Returns resolved options for calling AnalyzeQuantificationCycle function to calculate the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{AnalyzePeaksOptions, "Returns resolved options for calling AnalyzePeaks function to pick Peaks from protocol or data object."},
			{AnalyzeBindingQuantitationOptions, "Returns resolved options for calling AnalyzeBindingQuantitation function to determine the concentration of the analyte."}
		},
		"Thermodynamics" -> {
			{AnalyzeThermodynamicsOptions, "Resolves options to call AnalyzeThermodynamics function based on the input."},
			{AnalyzeParallelLineOptions, "Resolves options to call AnalyzeParallelLine function which calculate the relative potency ratio between EC50 values in teo dose-response fitted curves."}
		},
		"Kinetics" -> {
			{AnalyzeKineticsOptions, "Returns resolved options for solving for the kinetic rates by AnalyzeKinetics."},
			{AnalyzeBindingKineticsOptions, "Returns resolved options for calling AnalyzeBindingKinetics function to solve the kinetic association and dissociation rates."}
		},
		"Analytical And Physical Chemistry" -> {
			{AnalyzeMeltingPointOptions, "Returns resolved options for calculating the melting temperature from melting curves by AnalyzeMeltingPoint."},
			{AnalyzeCriticalMicelleConcentrationOptions, "Resolves options to call AnalyzeCriticalMicelleConcentration based on the input data or protocol."},
			{AnalyzeBubbleRadiusOptions, "Returns resolved options for analyzing the bubble radius in the video obtained while performing dynamic foam analysis."}
		},
		"Numeric Analysis" -> {
			{AnalyzeFitOptions, "Resolves options to call AnalyzeFit function to fit on input data, with all automatic options resolved to fix values."},
			{AnalyzeSmoothingOptions,  "Returns resolved options for AnalyzeSmoothing when it is called on input data."},
			{AnalyzeStandardCurveOptions, "Returns resolved options for AnalyzeStandardCurve when it is called on input data and standard data."},
			{AnalyzeClustersOptions, "Returns resolved options for partitioning the data points into distinct similarity groups."}
		}
	},
	RelatedGuides -> {
		GuideLink["AnalysisBySubjectMatter"],
		GuideLink["NumericAnalysis"],
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["ImageAnalysis"]
	}
]