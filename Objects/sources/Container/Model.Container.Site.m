(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Site], {
	Description->"Model information for a ECL location or ECL user location.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SalesTaxRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The current statewide sales tax rate in the state that this ECL facility is located in.",
			Category -> "Pricing Information",
			Developer->True
		},

		ReceivingModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Maintenance, ReceiveInventory],
			Description -> "The model of maintenance protocol used for receiving items at this ECL location.",
			Category -> "Inventory"
		},

		ShippingModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Maintenance, Shipping],
			Description -> "The model of maintenance protocol used for tracking facility wide parameters involved in shipping items to users from this ECL location.",
			Category -> "Inventory"
		}
	}
}];
