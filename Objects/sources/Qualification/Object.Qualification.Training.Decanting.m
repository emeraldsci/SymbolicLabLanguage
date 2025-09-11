(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,Decanting], {
	Description->"A protocol that verifies an operator's ability to separate liquid from solid by pouring.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DecantingTransferContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container] | Model[Container]),
			Description -> "The container into which the supernatant is transferred.",
			Category -> "General"
		},
		DecantingSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ManualSamplePreparation],
			Description -> "The manual sample preparation sub protocol that prepares the sample from which the supernatent is decanted.",
			Category -> "General"
		}
	}
}
]