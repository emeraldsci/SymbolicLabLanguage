(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Tensiometer], {
	Description -> "A protocol that verifies the functionality of the tensiometer target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		QualificationWettingLiquids->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Wetting liquids with known expected results that are run on the target instrument.",
			Category->"General"
		}
	}
}];
