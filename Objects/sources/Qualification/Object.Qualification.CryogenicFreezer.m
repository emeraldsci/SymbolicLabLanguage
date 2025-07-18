(* ::Package:: *)

DefineObjectType[Object[Qualification, CryogenicFreezer], {
	Description -> "A protocol that verifies the functionality of the cryogenic freezer target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TimePeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Day],
			Units -> Day,
			Description -> "The time period over which to qualify the cryogenic freezer.",
			Category -> "General"
		},
		SamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The rate at which to downsample the cryogenic freezer data before analysis.",
			Category -> "General"
		},
		DepthData -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None, Inch}],
			Units -> {None, Inch},
			Description -> "The downsampled data assessed by this qualification.",
			Category -> "Experimental Results"
		}
	}
}];
