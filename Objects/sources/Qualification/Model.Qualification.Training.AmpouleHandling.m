(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,AmpouleHandling], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to transfer a sample from an ampoule.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AmpouleOpenerModel->{
				Units -> None,
				Relation -> Model[Part],
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The tool's model that will be used to open ampoules.",
				Category -> "General"
				},
			AmpouleQualUnitOperations->{
				Units -> None,
				Relation -> Null,
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SamplePreparationP,
				Description -> "The Manual Sample Preparation sub protocol that tests the user Ampoule Transfer skills.",
				Category -> "Ampoule Skills"
				}
	}
}
]