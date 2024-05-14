(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Unit Manipulation",
	Abstract -> "Collection of functions for manipulating units.",
	Reference -> {
		{
			{Convert, "Converts the provided physical quantity to the specified target unit."},
			{Unitless, "Removes any units from the provided input to return only the numeric value."},
			{UnitScale, "Converts the unit of the provided physical quantity to the nearest sensible metric unit such that the number is the greater than 1 if possible."},
			{UnitFlatten, "Converts the provided physical quantity to its base units (i.e. without any prefixes)."},
			{UnitForm, "Converts the provided physical quantity to a compact string representation."},
			{CurrencyForm, "Formats the provided number as a monetary amount."},
			{SignificantFigures, "Returns the specified number of significant figures for the provided number."},
			{RCFToRPM, "Converts the provided relative centrifugal force (RCF) value into revolutions per minute (RPM) value given the provided parameters."},
			{RPMToRCF, "Converts the provided revolutions per minute (RPM) value into relative centrifugal force (RCF) value given the provided parameters."},
			{QuantityPartition, "Divides the provided quantity into multiple smaller quantities that are all equal to or below the specified amount."},
			{QuantityFunction, "Applies the specified function after converting the provided quantity to the specified input unit and returns the output value with another specified output unit."},
			{RoundMatchQ, "Generates a function that rounds its arguments to the specified digits and then applies MatchQ to them."}
		}
	},
	RelatedGuides -> {
		GuideLink["Numerics"],
		GuideLink["StatisticalDistributions"],
		GuideLink["UnitPatterns"],
		GuideLink["UnitProperties"]
	}
]
