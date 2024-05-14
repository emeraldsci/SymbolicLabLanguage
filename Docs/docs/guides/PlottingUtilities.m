(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


Guide[
	Title -> "Plotting Utilities",
	Abstract -> "Collection of utility functions used to generate plots and charts of ECL derived scientific data.",
	Reference -> {

		"Plot Functions" -> {
			{EmeraldListLinePlot, "Given raw numeric data generates a line plot designed specifically for handling laboratory data."},
			{EmeraldDateListPlot, "Given raw numeric data generates a scatter plot designed specifically for handling laboratory data."},
			{EmeraldBarChart, "Given raw numeric data generates a bar chart designed specifically for handling laboratory data."},
			{EmeraldPieChart, "Given raw numeric data generates a pie chart designed specifically for handling laboratory data."},
			{EmeraldBoxWhiskerChart, "Given raw numeric data generates a box and whisker chart designed specifically for handling laboratory data."},
			{EmeraldHistogram, "Given raw numeric data generates a histogram designed specifically for handling laboratory data."},
			{EmeraldHistogram3D, "Given raw 2D numeric data generates a 3D histogram designed specifically for handling laboratory data."},
			{EmeraldSmoothHistogram, "Given raw numeric data generates a smoothed histogram designed specifically for handling laboratory data."},
			{EmeraldSmoothHistogram3D, "Given raw 2D numeric data generates a smoothed 3D histogram designed specifically for handling laboratory data."},
			{EmeraldListContourPlot, "Given raw 3D numeric data generates a contour plot designed specifically for handling laboratory data."},
			{EmeraldListPlot3D, "Given raw 3D numeric data generates a 3D surface plot designed specifically for handling laboratory data."},
			{EmeraldListPointPlot3D, "Given raw 3D numeric data generates a 3D scatter plot designed specifically for handling laboratory data."},
			{PlotDistribution, "Given a distribution generates a plot of the probability density function of that distribution."},
			{PlotImage, "Given a raw image file or an object containing an image generates an interactive visualization of that image."},
			{PlotWaterfall, "Given a list of either raw 2D numeric data or objects containing 2D data, generates a 3D plot in which each set of 2D data is visualized as a line confined to its own 2D plane."}
		},

		"Plot Components & Graphics Primitives" -> {
			{EmeraldFrameTicks, "Given a range of data and optionally a set of points, generates frame ticks ideally spaced for plotting scientific data."},
			{EmeraldPlotMarkers, "Given an index number provides a cycling list of plot labels ideal for scientific data."},
			{ErrorBar, "Given a data point and an error generates a graphics primitive which represents an error bar."},
			{AxisLines, "Given a set of points and a plot range, generates a graphics primitive which draws intersect lines from the point to the labeled axes."},
			{PeakEpilog, "Given a set of data points and a peak analysis object, generates an interactive graphics primitive which highlights picked peaks."},
			{LabelPeaks, "Opens a graphical interface to interactively assign chemical components to peaks identified in an analysis object."}
		},

		"Plot Range Control" -> {
			{Zoomable, "Enables interactive click zooming of a plot."},
			{Unzoomable, "Disables interactive click zooming of a plot."},
			{FindPlotRange, "Given a set of data points and a plot range containing Automatics, returns a resolve plot range with the Automatics filled in."},
			{FullPlotRange, "Expands a provided plot range to the full {{x-min,x-max},{y-min,y-max}} form."},
			{AutomaticYRange, "Given a set of data points and buffer offset, provides a Y-range that covers all the data plus the buffer."}
		},

		"Image Processing" -> {
			{ImageIntensity, "Computes the average intensity of the pixels as a function of the vertical pixel position in the image."},
			{ImageMask, "Replaces all the pixels in the input image that are outside of a given color range."},
			{ImageOverlay, "Overlays the pixel information from two images to combine them into one."}
		}

	},
	RelatedGuides -> {
		GuideLink["VisualizingConstellationObjects"],
		GuideLink["PlottingBySubjectMatter"]
	}
]
