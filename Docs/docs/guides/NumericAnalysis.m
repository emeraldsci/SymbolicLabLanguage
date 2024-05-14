(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Numeric Analysis",
	Abstract -> "Symbolic Lab Language (SLL) data analysis functions which seamlessly connect into the linked data network, providing Constellation objects for that analysis itself which houses and connect the results of the analysis to its source data and methodology, and also serves as a template for future analysis that seeks to replicate previous analytical methodology.",
	Reference -> {
		"Peak Picking" -> {
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{PeakResolution, "Given a source of peak picking analysis, provides a measure of resolution between any two peaks."}
		},
		"Trend Fitting" -> {
			{AnalyzeFit, "Performs regression analysis to fit linear or non-linear functions connecting the results of that analysis to source data and experimental protocol information."},
			{SinglePrediction, "Given a fit object and an x value or distribution, returns a predicted distribution of y values."},
			{MeanPrediction, "Given a fit object and an x value or distribution, returns a predicted distribution of y values."},
			{InversePrediction, "Given a fit object and an y value or distribution, returns a predicted distribution of x values."},
			{PlotPrediction, "Given a fit object and first it predicts the x or y value associated with a given y or x value or distribution. Then it overlays the results to the fit line plot."},
			{AnalyzeStandardCurve, "Given a list of input data and a list of standard data, finds a fitted standard curve to the standard data and utilizes the standard curve equation to analyze the input data using interpolation or extrapolation."},
			{PlotStandardCurve, "Generates a plot of a fitted standard curve overlaid with the data points use to fit it, and the input points the standard was applied to from the provided standard curve analysis object."},
			{AnalyzeMeltingPoint, "Calculates the melting point from a melting curve, a cooling curve, or a dynamic light scattering dataset (dataset can be either from fluorescence or absorbance thermodynamics data, or thermal shift instrument which may contain both fluorescence spectra as well as dynamic light scattering data)."},
			{PlotMeltingPoint, "Generates a list plot of the source melting curve analysis along with a demarcation of the fitted melting point."},
			{AnalyzeParallelLine, "Calculates the relative potency ratio between two dose-response fitted curves."},
			{AnalyzeKinetics, "Given a reaction mechanism and a set of reaction trajectories (either simulated or from experimentation) fits rate constants which represent a best fit to the trajectory data."},
			{AnalyzeThermodynamics, "Given a set of melting curve data or analysis, performs Van't Hoff analysis to determine free-energy, enthalpy, and entropy components of a binding event."},
			{PlotThermodynamics, "Generates a Van't Hoff plot log of Keq as a function of inverse temperature and the fitted line containing the thermodynamic parameters from the provided thermodynamic analysis object."},
			{TrajectoryRegression, "Extracts concentrations of all or specified species at given time from the input trajectory."},
			{ForwardPrediction, "Computes a single or mean predicted value distribution obtained by propagating the specified input through the specified function."}
		},
		"Data Transformation" -> {
			{AnalyzeDownsampling, "Given a list of xy coordinates, downsamples the number of data points to reduce the processing time of the analysis while retaining the broader trend in the data."},
			{AnalyzeSmoothing, "Given a list of xy coordinates, applies different types of smoothing functions to the datasets in order to reduce the noise and make clear the broader trends in the data."},
			{PlotSmoothing, "Generates a line plot of smooth data along with the original un-smoothed data points from a provided smoothing analysis object."}
		},
		"Clustering Analysis" -> {
			{AnalyzeClusters, "Performs clustering analysis to classify groups of multi-dimensional data points connecting the results of the analysis to its source data and experimental protocol information."}
		}
	},
	RelatedGuides -> {
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["ImageAnalysis"],
		GuideLink["AnalysisBySubjectMatter"]
	}
]
