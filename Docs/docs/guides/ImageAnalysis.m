(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Image Analysis",
	Abstract -> "Symbolic Lab Language (SLL) data analysis functions which seamlessly connect into the linked data network, providing Constellation objects for that analysis itself which houses and connect the results of the analysis to its source data and methodology, and also serves as a template for future analysis that seeks to replicate previous analytical methodology.",
	Reference -> {
		"Image Analysis" -> {
			{AnalyzeCellCount, "Counts the apparent number of cells in the provided microscope image data."},
			{AnalyzeColonies, "Counts the cell colonies or plaques on solid media in the provided microscope image data."},
			{AnalyzeMicroscopeOverlay, "Generates an analytical combination of different composite fluorescent images for use in co-localization analysis."},
			{CombineFluorescentImages, "Generates a false color RGB image of the provided composite fluorescent data."},
			{ImageMask, "Replaces all the pixels in the input image that are outside of a given color range."},
			{ImageOverlay, "Overlays the pixel information from two images to combine them into one."},
			{ImageIntensity, "Computes the average intensity of the pixels as a function of the vertical pixel position in the image."}
		},
		"Image Visualization" -> {
			{PlotMicroscope, "Plots microscope image data."},
			{PlotMicroscopeOverlay, "Generates a false color combination of the provided microscope overlay analysis."},
			{PlotImage, "Given an image file or data objects containing images, provides a visualization of these images that includes a measurement of absolute size scales when possible."},
			{PlotCellCount, "Generates an image of the microscope data with the putative cell areas indicated from the provided cell counting image analysis highlighted."},
			{PlotCellCountSummary, "Generates an image of the microscope data with the putative cell areas highlighted, along with a pie cart of relative areas of cell groupings from the provided cell counting image analysis highlighted."},
			{PlotColonies, "Generates a graphical representation of the number of colonies or plaques."}
		}
	},
	RelatedGuides -> {
		GuideLink["NumericAnalysis"],
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["AnalysisBySubjectMatter"]
	}
]
