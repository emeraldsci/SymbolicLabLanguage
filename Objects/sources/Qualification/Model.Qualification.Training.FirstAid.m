(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Model[Qualification,Training,FirstAid], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate first aid kits.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		FirstAidKit -> {
			Units -> None,
			Relation -> Alternatives[Model[Item],Model[Part],Model[Container],Model[Instrument]],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The first aid kit model that the operator will utilized for searching objects based on the ECL site.",
			Category -> "General"
		}
	}
}];
