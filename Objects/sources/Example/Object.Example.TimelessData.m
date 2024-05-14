(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*<MIGRATION-TAG: DO-NOT-MIGRATE>*)

DefineObjectType[Object[Example, TimelessData], {
	Description->"Fake data for unit testing",
	CreatePrivileges->Developer,
	Timeless -> True,
	Fields -> {
		DataAnalysis -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis][DataAnalysis] | Object[Example, Analysis][DataAnalysisTimeless],
			Description -> "Example analysis of this example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		DataAnalysisTemporal -> {
			Format -> Multiple,
			Class -> TemporalLink,
			Pattern :> _Link,
			Relation -> Object[Example, Analysis][DataAnalysis] | Object[Example, Analysis][DataAnalysisTimeless],
			Description -> "Example analysis of this historical example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?TemperatureQ,
			Units -> Celsius,
			Description -> "The temperature of the example data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		Number -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A number.",
			Category -> "Experiments & Simulations",
			Required -> True,
			Abstract -> False
		}
	}
}];
