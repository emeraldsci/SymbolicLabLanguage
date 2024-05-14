
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Inventory, Product], {
	Description->"An object representing instructions for keeping a product that is ordered from a vendor in stock.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ModelStocked -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Model[Part],
				Model[Container],
				Model[Plumbing],
				Model[Wiring],
				Model[Sensor]
			],
			Description -> "The model that is kept in stock by this inventory object.",
			Category -> "Inventory"
		}
	}
}];