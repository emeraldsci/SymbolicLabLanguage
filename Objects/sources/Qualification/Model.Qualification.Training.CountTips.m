(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,CountTips], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to count the number of tips in a box of tips.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		QualTrainingTips->{
				Units -> None,
				Relation -> Model[Item],
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "Box of 200ul non-sterile tips for Training only.",
				Category -> "General"
				}
	}
}
]