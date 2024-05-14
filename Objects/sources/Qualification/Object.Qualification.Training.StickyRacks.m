(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,StickyRacks], {
	Description->"A protocol that verifies an operator's ability to move containers via the sticky rack system.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StickyRackTubes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]|Object[Container],
			Description -> "The items that need to be moved into a sticky rack in order to demonstrate understanding of sticky racks.",
			Category -> "General"
		},

		StickyRackID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A rack which the operator has selected to use in order to transfer a collection of tubes.",
			Category -> "General"
		},

		StickyRackBench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Bench] | Object[Container,Bench],
			Description -> "The bench onto which the tubes will be transferred.",
			Category -> "General"
		}
	}
}]