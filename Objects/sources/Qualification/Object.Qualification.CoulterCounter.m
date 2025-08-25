(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, CoulterCounter], {
	Description -> "A protocol that verifies the functionality of the coulter counter target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The chemicals with known particle sizes or particle concentrations that are used to test the sizing and counting capability of the coulter counter instrument.",
			Category -> "General"
		}
	}
}];
