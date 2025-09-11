(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Lid], {
	Description->"Information for a lid that can be placed on top of a container to non-hermetically cover it.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		CoveredContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Cover],
			Description -> "The plate on which this lid is currently placed.",
			Category -> "Dimensions & Positions"
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this cover can be taken off and replaced multiple times without issue.",
			Category -> "Item Specifications"
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The weight of the lid.",
			Category -> "Item Specifications"
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the weight.",
			Category -> "Item Specifications"
		},
		WeightLog -> {
			Format -> Multiple,
			Class -> {Date, Real, Link},
			Pattern :> {_?DateObjectQ, GreaterP[0*Gram], _Link},
			Relation -> {Null, Null, Object[Protocol]|Object[User, Emerald, Developer]},
			Units -> {None, Gram, None},
			Description -> "A historical record of the measured weight of the lid.",
			Category -> "Item Specifications",
			Headers ->{"Date","Tare Weight","Responsible Party"}
		}
	}
}];
