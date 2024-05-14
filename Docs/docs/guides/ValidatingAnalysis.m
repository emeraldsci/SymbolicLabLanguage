(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Validating Analysis",
	Abstract -> "Collection of functions to check the validity of running analysis functions on given input and options.",
	Reference -> {
		"Chromatography" -> {
			{ValidAnalyzePeaksQ, "Checks the validity on calling AnalyzePeaks function on given input."},
			{ValidAnalyzeFractionsQ, "Checks the validity on calling AnalyzeFractions function on given input."},
			{ValidAnalyzeLadderQ, "Performs validation on fitting a standard curve function to molecular size (e.g., oligomer length) or fitting the peaks analysis results linked to the given data object."},
			{ValidAnalyzeCompositionQ, "Checks the validity on calling AnalyzeComposition on a given input."}
		},
		"Spectroscopy" -> {
			{ValidAnalyzePeaksQ, "Checks the validity on calling AnalyzePeaks function on given input."},
			{ValidAnalyzeAbsorbanceQuantificationQ, "Checks the validity on calling AnalyzeAbsorbanceQuantification function on given input."},
			{ValidAnalyzeTotalProteinQuantificationQ, "Checks the validity on calling AnalyzeTotalProteinQuantification function on given input."},
			{ValidAnalyzeDynamicLightScatteringQ, "Checks the validity on calling AnalyzeDynamicLightScattering function on given input."},
			{ValidAnalyzeDynamicLightScatteringLoadingQ, "Checks the validity on calling AnalyzeDynamicLightScatteringLoading function on given input."},
			{ValidAnalyzeCompositionQ, "Checks the validity on calling AnalyzeComposition on a given input, by returning an EmeraldTestSummary containing test results, or a single Boolean."}
		},
		"PCR" -> {
			{ValidAnalyzeCopyNumberQ, "Checks the validity of the Quantification Cycles and specified options are valid for AnalyzeCopyNumber."},
			{ValidAnalyzeQuantificationCycleQ, "Checks the validity of calling AnalyzeQuantificationCycle function on given input."}
		},
		"Bioassays" -> {
			{ValidAnalyzeBindingKineticsQ, "Checks the validity of calling AnalyzeBindingKinetics function on given input."},
			{ValidAnalyzeBindingQuantitationQ, "Checks the validity of calling AnalyzeBindingQuantitation function on given input."},
			{ValidAnalyzeEpitopeBinningQ, "Checks the validity of calling AnalyzeEpitopeBinning function on given input."},
			{ValidAnalyzeDNASequencingQ, "Checks the validity of calling AnalyzeDNASequencing function on given input."}
			(*{ValidAnalyzeCompensationMatrixQ, "Checks the validity on calling AnalyzeCompensationMatrix function on the given input."},*)
			(*{ValidAnalyzeFlowCytometryQ, "Checks if the given flow cytometry data object(s) is(are) valid inputs for downstream analysis."},*)
		},
		"Microscopy" -> {
			{ValidAnalyzeMicroscopeOverlayQ, "Checks if the input microscope data is valid."},
			{ValidAnalyzeCellCountQ, "Checks the validity of calling AnalyzeCellCount function the given microscopic data or image file to analyze the number of cells, their area and morphology."}
		},
		"Quantification" -> {
			{ValidAnalyzeAbsorbanceQuantificationQ, "Checks if the given absorbance spectroscopy data object(s) is(are) valid inputs for downstream analysis."},
			{ValidAnalyzeTotalProteinQuantificationQ, "Checks if the input protocol is valid." },
			{ValidAnalyzeCopyNumberQ, "Checks if the AnalyzeCopyNumber function call on given input is valid."},
			{ValidAnalyzeBindingQuantitationQ, "Checks if AnalyzeBindingQuantitation function call on given input is valid."}
		},
		"Thermodynamics" -> {
			{ValidAnalyzeMeltingPointQ, "Checks the validity on calling AnalyzeMeltingPoint function on the given input, by returning an EmeraldTestSummary containing test results, or a single Boolean."},
			{ValidAnalyzeParallelLineQ, "Checks the validity on calling AnalyzeParallelLine function on the given input, by returning an EmeraldTestSummary containing test results, or a single Boolean."},
			{ValidAnalyzeThermodynamicsQ, "Checks if the input thermodynamics data is valid."}
		},
		"Kinetics" -> {
			{ValidAnalyzeKineticsQ, "Checks if the given fluorescence kinetics data objects and reaction mechanisms are valid inputs for downstream analysis."},
			{ValidAnalyzeBindingKineticsQ, "Checks if the AnalyzeBindingKinetics function call on given input is valid."}

		},
		"Property Measurement" -> {
			{ValidAnalyzeBubbleRadiusQ, "Checks if the AnalyzeBubbleRadius function call on given input is valid."}
		},
		"Analytical And Physical Chemistry" -> {

		},
		"Numeric Analysis" -> {
			{ValidAnalyzeSmoothingQ, "Performs validation on applying different types of smoothing functions in order to reduce the noise and make clear the broader trends in the xy coordinate data."},
			{ValidAnalyzeClustersQ, "Performs validation on partitioning the data points in the Data field into distinct similarity groups."},
			{ValidAnalyzeFitQ, "Performs validation on the results of source data and experimental protocol information to check whether they can user regression analysis to fit."},
			{ValidAnalyzeStandardCurveQ, "Performs validation on performing a standard curve analysis on input data and standard data."}
		},
		"Image Analysis" -> {
			{ValidGraphicsP, "Is a pattern that represents valid graphics or valid graphic options."},
			{ValidAnalyzeBubbleRadiusQ,"Performs validation on computing the distribution of bubble radii at each frame of the RawVideoFile in either a DynamicFoamAnalysis data object or a DynamicFoamAnalysis protocol."}
		}
	},
	RelatedGuides -> {
		GuideLink["AnalysisBySubjectMatter"],
		GuideLink["NumericAnalysis"],
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["ImageAnalysis"]
	}
]