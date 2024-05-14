

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Model[Container, Bag], {
	Description->"A model of a bag in which inventory is stored.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of bag by default.",
			Category -> "Inventory",
			Developer->True
		}
	}
}];
