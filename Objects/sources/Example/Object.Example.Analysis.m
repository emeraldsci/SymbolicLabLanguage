(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Example, Analysis], {
	Description->"Analysis of fake example data.",
	CreatePrivileges->Developer,
	Fields -> {
		DataAnalysis -> {
			Format -> Single,
			Class -> TemporalLink,
			Pattern :> _Link,
			Relation -> Object[Example, Data][DataAnalysis] | Object[Example, Data][DataAnalysisTemporal]
				| Object[Example, TimelessData][DataAnalysis] | Object[Example, TimelessData][DataAnalysisTemporal],
			Description -> "The example data analyzed in this example analysis.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		DataAnalysisTimeless -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, TimelessData][DataAnalysis] | Object[Example, TimelessData][DataAnalysisTemporal],
			Description -> "The example data analyzed in this example analysis.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		StringData -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Some random string data.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		TableName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "A table name of this analysis, which makes no sense but is fake.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		}
	}
}];
