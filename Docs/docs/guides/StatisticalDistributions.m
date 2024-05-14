(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Statistical Distributions",
	Abstract -> "Collection of functions for analyzing statistical distributions.",
	Reference -> {
		"Distribution Functions" -> {
			{PropagateUncertainty, "Computes the propagate uncertainty in the provided expression using the specified parameters and distributions."},
			{SampleFromDistribution, "Generates the specified number of sample values from the provided distribution."},
			{EmpiricalDistributionJoin, "Joins the provided empirical distributions into a single empirical distribution."},
			{EmpiricalDistributionPoints, "Extracts the data points from an empirical distribution."},
			{ConfidenceInterval, "Computes the 95% confidence interval for the provided distribution."}
		},
		"Distribution Patterns" -> {
			{DistributionQ, "Checks if the provided input is a valid distribution."},
			{DistributionP, "Is a pattern that matches valid distributions."},
			{EmpiricalDistributionQ, "Checks if the provided input is a valid empirical distribution."},
			{EmpiricalDistributionP, "Is a pattern that matches valid empirical distributions."},
			{QuantityDistributionQ, "Checks if the provided input is a valid quantity distribution."},
			{QuantityDistributionP, "Is a pattern that matches valid quantity distributions."}
	 	}
	},
	RelatedGuides -> {
		GuideLink["Numerics"],
		GuideLink["UnitManipulation"],
		GuideLink["UnitPatterns"],
		GuideLink["UnitProperties"]
	}
]
