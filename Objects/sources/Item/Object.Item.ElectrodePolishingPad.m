(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,ElectrodePolishingPad], {
	Description->"Object information for a circular pad as the substrate for the electrode polishing procedure.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		PadColor -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PadColor]],
			Pattern :> ColorP,
			Description -> "The color of this electrode polishing pad object.",
			Category -> "Physical Properties"
		},
		DefaultPolishingSolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DefaultPolishingSolution]],
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended polishing solution model to be used with this electrode polishing pad object.",
			Category -> "General"
		},
		DefaultPolishingPlate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DefaultPolishingPlate]],
			Pattern :> _Link,
			Relation -> Model[Item, ElectrodePolishingPlate],
			Description -> "The recommended polishing plate model to be used with this electrode polishing pad object.",
			Category -> "General"
		},
		PolishingLog -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Electrode][PolishingLog, 3],
			Description -> "Record the historical electrode polishings performed using this PolishingPad object.",
			Category -> "Usage Information"
		},
		SolutionLog -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "Record the historical solution samples used upon this PolishingPad object to perform electrode polishing.",
			Category -> "Usage Information"
		}
	}
}];
