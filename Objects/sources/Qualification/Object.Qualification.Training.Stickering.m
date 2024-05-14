(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,Stickering], {
	Description->"A protocol that verifies an operator's ability to scan object and location stickers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StickeringObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel],Object[Container, Vessel], Model[Container, Plate], Object[Container, Plate]],
			Description -> "The objects that were stickered in order to test the user's knowledge of proper sticker positioning and technique.",
			Category -> "General"
		},
		PreStickeringImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of object before stickering.",
			Category -> "General"
		},
		PostStickeringImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of object after stickering.",
			Category -> "General"
		}
	}
}
]