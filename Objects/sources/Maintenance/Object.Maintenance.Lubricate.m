(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Lubricate], {
	Description->"A protocol that applies a liquid to reduce friction on parts of the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the area of the lab in which this maintenance occurs.",
			Category -> "General"
		},
		Lubricant-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "The type of sample used to reduce friction on parts of the target.",
			Category -> "General"
		},
		SecondaryLubricant-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "The second type of sample used to reduce friction on parts of the instrument. Used when parts of the maintenance target needs different lubricants.",
			Category -> "General"
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location where the Target is lubricated.",
			Category -> "Equilibration",
			Developer -> True
		}

	}
}];
