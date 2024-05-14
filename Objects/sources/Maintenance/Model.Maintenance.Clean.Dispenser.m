(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean, Dispenser], {
	Description->"Definition of a set of parameters for a maintenance protocol that clean dispensers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GraduatedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container]
			],
			Description -> "The models of graduated cylinders kept on the dispenser's deck for use in measuring volume when dispensing.",
			Category -> "Cleaning"
		}
	}
}];
