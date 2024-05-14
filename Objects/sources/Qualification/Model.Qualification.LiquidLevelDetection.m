(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, LiquidLevelDetection], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a liquid handler for liquid level detection.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		WashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The wash solution used to soak and clean all the dispense needles on the instrument.",
			Category -> "General"
		},
		WashSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of wash solution needed to soak and clean all the dispense needles on the instrument.",
			Category -> "General"
		},
		WashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that should be used to hold the WashSolution.",
			Category -> "General"
		},
		CottonTipApplicators -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Model[Item,Consumable],(* TODO: Remove after item migration. *)
			Description -> "The model of cotton tip applicators used to dry the dispense needles after washing.",
			Category -> "General"
		}				
	}
}];
