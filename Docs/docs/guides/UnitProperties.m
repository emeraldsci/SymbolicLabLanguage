(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Unit Properties",
	Abstract -> "Collection of functions for looking up unit properties for physical quantities.",
	Reference -> {
		{
			{Units, "Returns a Quantity object containing the unit of the provided quantity."},
			{UnitBase, "Returns only the unit portion of the provided quantity in absence of the metric  prefix."},
			{UnitDimension, "Returns a description of the unit in the provided quantity."},
			{CanonicalUnit, "Returns the canonical unit of the provided quantity or unit dimension."}
		}
	},
	RelatedGuides -> {
		GuideLink["Numerics"],
		GuideLink["StatisticalDistributions"],
		GuideLink["UnitManipulation"],
		GuideLink["UnitPatterns"]
	}
]
