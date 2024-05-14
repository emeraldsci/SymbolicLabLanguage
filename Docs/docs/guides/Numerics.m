(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Numerics",
	Abstract -> "Collection of functions for numeric data manipulation.",
	Reference -> {
		"Numeric Functions" -> {
			{InvertData, "Inverts the provided xy data so that the x-values are the same, but the y-values are in reverse order."},
			{RescaleY, "Rescales only the y-values of provided xy data to a new maximum and minimum based upon an old maximum and minimum value."},
			{RescaleData, "Rescales both x- and y-values of the provided xy data to a new maximum and minimum based upon an old maximum and minimum value."},
			{AutomaticYRange, "Returns the maximum and minimum of y-values of the provided data set."},
			{FindPlotRange, "Returns a plot range from the provided plot data."},
			{TranslateCoordinates, "Adjusts the provided xy data by the specified amounts."},
			{Domains, "Cuts the plot data into subsections based on the specified ranges."},
			{RoundReals, "Rounds the provided real numbers to the specified digits."},
			{RSquared, "Computes the R-Squared value between measured values and modeled values."},
			{CoefficientOfVariation, "Computes the coefficient of variation for the provided mean and standard deviation."},
			{SumSquaredError, "Computes the sum of squares of differences between two provided lists of data points."},
			{ND, "Computes the numerical derivative of the provided xy data."}
		},
		"Numeric Patterns" -> {
			{AllGreater, "Checks if every element in the provided array is greater than the specified value."},
			{AllGreaterEqual, "Checks if every element in the provided array is greater than or equal to the specified value."},
			{AllLess, "Checks if every element in the provided array is less than the specified value."},
			{AllLessEqual, "Checks if every element in the provided array is less than or equal to the specified value."},
			{InfiniteNumericQ, "Checks if the input is either numeric, ∞, or -∞."},
			{MatrixP, "Is a pattern that matches any matrix, which is an Nx2 array."},
			{LinearFunctionQ, "Checks if the provided function is a linear function."},
			{DomainP, "Is a pattern that matches the type of number and checks if the minimum value is smaller than the maximum value."}
		}
	},
	RelatedGuides -> {
		GuideLink["StatisticalDistributions"],
		GuideLink["UnitManipulation"],
		GuideLink["UnitPatterns"],
		GuideLink["UnitProperties"]
	}
]
