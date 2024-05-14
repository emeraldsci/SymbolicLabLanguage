

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Model[Container, Shipping], {
	Description->"A model of a container in which inventory is received.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of container by default.",
			Category -> "Inventory",
			Developer->True
		}
	}
}];
