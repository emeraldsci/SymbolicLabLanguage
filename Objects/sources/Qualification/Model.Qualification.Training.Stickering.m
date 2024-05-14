(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,Stickering], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to scan object and location stickers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StickeringModels->{
				Units -> None,
				Relation -> Alternatives[Model[Container, Vessel], Model[Container, Plate]],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model(s) of object(s) that the user will be asked to sticker to test their knowledge of proper sticker positioning and technique.",
				Category -> "Stickering Skills"
				}
	}
}
]