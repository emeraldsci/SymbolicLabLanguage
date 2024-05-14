

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Company, Shipper], {
	Description->"A company that provides shipping services by transporting goods such as samples or instruments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Transactions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][Shipper],
			Description -> "A list of transactions delivered by this shipping company.",
			Category -> "Order Activity"
		},
		TrackingURL -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The URL for tracking shipments with this company.",
			Category -> "Order Activity"
		},
		ShippingSpeedCodes -> {
			Format -> Multiple,
			Class -> {ShippingSpeed->Expression,Code->String},
			Pattern :> {ShippingSpeed->ShippingSpeedP,Code->_String},
			Description -> "A lookup between shipping speeds supported by ECL and codes this shipper uses to refer to those shipping speeds in their API.",
			Headers->{ShippingSpeed->"Shipping Speed",Code->"Code"},
			Category -> "Shipping Information",
			Developer -> True
		},
		APIEndpoints -> {
			Format -> Multiple,
			Class -> {API -> Expression, Test -> Boolean, URL -> String},
			Pattern :> {API -> UPSAPINameP, Test -> BooleanP, URL -> URLP},
			Description -> "A lookup for shipper API URL based on the API name and whether it is a test (Test->True) or a production (Test->False) endpoint.",
			Headers -> {API -> "API Name", Test -> "Test Endpoint", URL -> "URL"},
			Category -> "Shipping Information",
			Developer -> True
		}
	}
}];
