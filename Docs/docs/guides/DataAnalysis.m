(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Data Analysis",
	Abstract -> "Symbolic Lab Language (SLL) data analysis functions which seamlessly connect into the linked data network, providing Constellation objects for that analysis itself which houses and connect the results of the analysis to its source data and methodology, and also serves as a template for future analysis that seeks to replicate previous analytical methodology.",
	Reference -> {
		"Numerical Analysis" -> {
			{AnalyzeFit, "Performs regression analysis to fit linear or non-linear functions connecting the results of that analysis to source data and experimental protocol information."},
			{SinglePrediction, "Given a fit object and an x value or distribution, returns a predicted distribution of y values."},
			{MeanPrediction, "Given a fit object and an x value or distribution, returns a predicted distribution of y values."},
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{PeakResolution, "Given a source of peak picking analysis, provides a measure of resolution between any two peaks."},
			{AnalyzeGating, "Performs clustering analysis to classify groups of multi-dimensional data points connecting the results of the analysis to its source data and experimental protocol information."}
		},
		"Separation Techniques" -> {
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{AnalyzeFractions, "Selects a set of fractions to be carried forward for further analysis from chromatography data where fractions were collected."},
			{AnalyzeLadder, "Fits a standard curve function to relate position of a given band or peak to length of a nucleic acid species."}
		},
		"Quantification" -> {
			{AnalyzeAbsorbanceQuantification, "Users Beer's Law to calculate the concentration of an analyte based on its extinction coefficient and absorbance spectra."},
			{AnalyzeTotalProteinQuantification, "Calculates total protein calculation based on total protein quantification assay data."},
			{AnalyzeCopyNumber, "Calculates the estimated copy number of a given gene sequences in an analyte based on qPCR data or Quantification Cycle analysis."},
			{AnalyzeQuantificationCycle, "Calculates the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{AnalyzeCellCount, "Counts the apparent number of cells in the provided microscope image data."}
		},
		"Physical Chemistry" -> {
			{AnalyzeKinetics, "Given a reaction mechanism and a set of reaction trajectories (either simulated or from experimentation) fits rate constants which represent a best fit to the trajectory data."},
			{AnalyzeThermodynamics, "Given a set of melting curve data or analysis, performs Van't Hoff analysis to determine free-energy, enthalpy, and entropy components of a binding event."},
			{AnalyzeMeltingPoint, "Calculates the melting point from a melting curve, a cooling curve, or a dynamic light scattering dataset (dataset can be either from fluorescence or absorbance thermodynamics data, or thermal shift instrument which may contain both fluorescence spectra as well as dynamic light scattering data)."}
		},
		"Image Analysis" -> {
			{AnalyzeMicroscopeOverlay, "Generates an analytical combination of different composite fluorescent images for use in co-localization analysis."},
			{AnalyzeCellCount, "Counts the apparent number of cells in the provided microscope image data."},
			{ImageMask, "Replaces all the pixels in the input image that are outside of a given color range."},
			{ImageOverlay, "Overlays the pixel information from two images to combine them into one."},
			{ImageIntensity, "Computes the average intensity of the pixels as a function of the vertical pixel position in the image."},
			{CombineFluorescentImages, "Generates a false color RGB image of the provided composite fluorescent data."}
		}
	},
	RelatedGuides -> {
		GuideLink["PhysicalSimulations"]
	}
]
