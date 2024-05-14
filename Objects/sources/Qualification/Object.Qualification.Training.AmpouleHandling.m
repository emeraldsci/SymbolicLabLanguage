(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,AmpouleHandling], {
	Description->"A protocol that verifies an operator's ability to transfer a sample from an ampoule.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AmpouleQualProtocol -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Protocol,ManualSamplePreparation],
		Description -> "The Manual Sample Preparation sub protocol that tests the user's Ampoule skills.",
		Category -> "Sample Preparation"
	},
		AmpouleOpener -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Part] | Model[Part]),
			Description -> "The model of part employed in the qual to open ampoules.",
			Category -> "General"
		}
	}}
]