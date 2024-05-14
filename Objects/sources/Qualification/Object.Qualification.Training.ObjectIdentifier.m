(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,ObjectIdentifier], {
	Description->"A protocol that verifies an operator's ability to use the Object Identifier.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ObjectIdentifierObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The model of object(s) that the user will be asked to store to test their knowledge of proper storage techniques.",
			Category -> "Storage Skills"
		},
		ObjectIdentifierAnswers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The user input location history answers in the procedure.",
			Category -> "Object Identifier Skills"
		}
		}}
]