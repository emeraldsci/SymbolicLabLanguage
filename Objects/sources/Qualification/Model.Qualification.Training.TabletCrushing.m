(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: hanming.yang*)
(* :Date: 2023-6-26 *)

DefineObjectType[Model[Qualification,Training,TabletCrushing], {
	Description->"The model for a qualification test to test operator's ability to crush tablet into powder with tablet crusher.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TabletSampleModel->{
			Units -> None,
			Relation -> Model[Sample],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The model of tablet sample that will be used to test the users ability to crush tablets. Note that the same model can be repeated for fidelity.",
			Category -> "Tablet Crushing Skills"
		}
	}
}
]