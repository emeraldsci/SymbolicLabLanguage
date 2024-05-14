(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Preview Analysis",
	Abstract -> "A collection of functions used to display the results of a given analysis on the appropriate data objects without the corresponding analysis object creation.",
	Reference -> {
		"Chromatography" -> {
			{AnalyzePeaksPreview, "Displays a preview peak picking result of experiment data."},
			{AnalyzeFractionsPreview, "Displays a preview absorbance vs time graph, with indicated peaks and fractions, when run on a protocol or a set of chromatography data."},
			{AnalyzeLadderPreview, "Displays a plot of peak positions taken from the peak analysis linked to a given chromatography or electrophoresis data object."},
			{AnalyzeCompositionPreview, "Displays a tabular preview of AnalyzeComposition results on input protocol object."}
		},
		"Spectrometry" -> {
			{AnalyzePeaksPreview, "Displays a preview peak picking result of experiment data."},
			{AnalyzeTotalProteinQuantificationPreview, "Displays a preview of calculating total protein concentration based on total protein quantification assay data."},
			{AnalyzeDynamicLightScatteringPreview, "Displays a preview of calculating key parameters from dynamic light scattering experiment result on input protocol or data objects."},
			{AnalyzeDynamicLightScatteringLoadingPreview, "Displays a preview of running AnalyzeDynamicLightScatteringLoading function on input objects."}
		},
		"PCR" -> {
			{AnalyzeQuantificationCyclePreview, "Displays a plot of the normalized and baseline-subtracted amplification curve and quantification cycle in the provided quantitative PCR data object."},
			{AnalyzeCopyNumberPreview,"Previews the graphic results for calculating the copy number for each of the QuantificationCycles based on a StandardCurve of quantification cycle vs Log10 copy number."}
		},
		"Bioassays" -> {
			{AnalyzeBindingKineticsPreview, "Displays a graphical preview of solving kinetic association and dessociation rates from biolayer interferometry binding kinetics data."},
			{AnalyzeBindingQuantitationPreview, "Displays a graphical preview of determining the concentration of the analyte."},
			{AnalyzeDNASequencingPreview, "Generates a graph of the output of AnalyzeDNASequencing when it is called on input."},
			(*{AnalyzeCompensationMatrixPreview, "Returns a graphical preview of the compensation matrix when run on a flow cytometry protocol."},*)
			{AnalyzeEpitopeBinningPreview,"Previews the graphic results for classifying of antibodies by their interaction with a given antigen using the data collected by biolayer interferometry."},
			{AnalyzeCompensationMatrixPreview, "Returns a graphical preview of the compensation matrix when run on a flow cytometry protocol."}
		},
		"Microscopy" -> {
			{AnalyzeMicroscopeOverlayPreview, "Generates a graphical display representing the output of the AnalyzeMicroscopeOverlay when called on the input image."},
			{AnalyzeCellCountPreview, "Displays a graphical preview that counts the number of cells and their area and morphology given a microscope data object according to the type of cells in the acquired image."}

		},
		"Quantification" -> {
			{AnalyzeTotalProteinQuantificationPreview, "Displays a preview plot showing total protein quantification results given a total protein quantification protocol."},
			{AnalyzeCopyNumberPreview, "Displays a preview plot which calculates the estimated copy number of a given gene sequence in qPCR result."},
			{AnalyzeQuantificationCyclePreview, "Displays a preview which calculates the the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{AnalyzePeaksPreview, "Displays a preview peak picking result of experiment data."},
			{AnalyzeBindingQuantitationPreview, "Displays a graphical preview of determining the concentration of the analyte."}
		},
		"Thermodynamics" -> {
			{AnalyzeMeltingPointPreview, "Displays a preview which calculates the melting point from a melting curve dataset."},
			{AnalyzeThermodynamicsPreview, "Generates a graph of the output of AnalyzeThermodynamics when it is called on the input."},
			{AnalyzeParallelLinePreview, "Displays a preview which calculates the relative potency ratio between two dose-response fitted curves."}
		},
		"Kinetics" -> {
			{AnalyzeKineticsPreview, "Generates a graph of the output of AnalyzeKinetics whne it is called on the input."},
			{AnalyzeBindingKineticsPreview, "Displays a graphical preview of solving kinetic association and dessociation rates from biolayer interferometry binding kinetics data."}
		},
		"Property Measurement" -> {
			{AnalyzeBubbleRadiusPreview, "Displays the bubble radius distribution for videos contained in a dynamic foam analysis object."}
		},
		"Analytical And Physical Chemistry" -> {
			{AnalyzeMeltingPointPreview,"Preview the result of calculating melting temperature from melting curves that are stored in a protocol object, or a data object or in raw data."},
			{AnalyzeCriticalMicelleConcentrationPreview, "Displays a preview which calculates the critical micelle concentration of a target molecule above which surface tension is constant and below which the surface tension decreases with concentration."}
		},
		"Numeric Analysis" -> {
			{AnalyzeClustersPreview, "Returns an interactive graphical preview of the clustering analysis performed on input data."},
			{AnalyzeFitPreview, "Displays a preview plot which performs regression analysis to fit linear or non-linear functions connecting the results of that analysis to source data and experimental protocol information."},
			{PlotFitPreview, "Displays a plot for the calculated fit function overlaid on the input data."},
			{AnalyzeSmoothingPreview, "Displays a preview plot representing smoothed vs original data."},
			{AnalyzeStandardCurvePreview, "Displays a preview plot showing experimental data compared to a standard curve."},
			{AnalyzePeaksPreview, "Previews the peak picking results of either a data object, a protocol or a list of coordination."}
		}
	},
	RelatedGuides -> {
		GuideLink["AnalysisBySubjectMatter"],
		GuideLink["NumericAnalysis"],
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["ImageAnalysis"]
	}
]