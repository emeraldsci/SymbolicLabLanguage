(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Report, ShippingPrices], {
	Description->"A report on the estimated shipping prices from a source site to a representative set of ZIP codes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Shipper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Shipper],
			Description -> "The shipping company whose shipping interface was queried to determine the shipping prices tabulated in this report.",
			Category -> "Shipping Information"
		},
		Source -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The site or supplier considered as the origin of shipment for which shipping prices are tabulated in this report.",
			Category -> "Shipping Information"
		},
		ShippingSpeed -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShippingSpeedP,
			Description -> "The delivery speed for which shipping prices are tabulated in this report.",
			Category -> "Shipping Information"
		},
		BoxModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Box],
			Description -> "The shipping container model for which shipping prices are tabulated in this report.",
			Category -> "Shipping Information"
		},
		ShippingPrices -> {
			Format -> Multiple,
			Class -> {PostalCode->String,Price->Real},
			Pattern :> {PostalCode->PostalCodeP, Price->GreaterP[0 USD]},
			Units -> {PostalCode->None, Price->USD},
			Description -> "A listing of destination postal codes and the price of shipping a package from the source site to that location, with the indicated box volume and shipping speed.",
			Category -> "Shipping Information",
			Headers -> {PostalCode->"Destination Postal Code",Price->"Price"}
		}
	}
}];
