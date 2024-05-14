(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,ElectrodePolishingPad], {
	Description->"Model information for a circular pad as the substrate for the electrode polishing procedure.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PadColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColorP,
			Description -> "The color of this electrode polishing pad model.",
			Category -> "Physical Properties"
		},
		DefaultPolishingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended polishing solution model to be used with this electrode polishing pad model.",
			Category -> "General"
		},
		DefaultPolishingPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, ElectrodePolishingPlate],
			Description -> "The recommend type of supporting plate to use underneath the polishing pad during the electrode polishing.",
			Category -> "General"
		}
	}
}];
