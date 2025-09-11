(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Lubricate], {
	Description->"Definition of a set of parameters for a maintenance protocol that applies a liquid to reduce friction on parts of the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Lubricant-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "The type of lubricant used to reduce friction on parts of the target.",
			Category -> "General"
		},
		SecondaryLubricant-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "The second type of lubricant used to reduce friction on parts of the instrument. Used when parts of the maintenance target needs different lubricants.",
			Category -> "General"
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]|Model[Container],
			Description -> "The location where Target is lubricated.",
			Category -> "General",
			Developer -> True
		}
	}
}];
