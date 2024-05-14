(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,Decanting], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to seperate liquid from solid by pouring.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DecantingPreparatoryUnitOperations->{
				Units -> None,
				Relation -> Null,
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SamplePreparationP,
				Description -> "The list of sample preparation unit operations performed to prepare a slurry from which the supernatent can be decanted.",
				Category -> "General"
				},
			DecantingTransferContainerModel->{
				Units -> None,
				Relation -> Model[Container],
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model of container into which the supernatant is transferred.",
				Category -> "General"
				}
	}
}
]