(* ::Package:: *)

DefineObjectType[Model[Qualification, CryogenicFreezer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a cryogenic freezer.",
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
		MeanTarget -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Inch],
			Units -> Inch,
			Description -> "The target filled liquid nitrogen depth of the target cryogenic freezer model.",
			Category -> "General"
		},
		MeanTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Inch],
			Units -> Inch,
			Description -> "The amount above or below the target depth that the mean may deviate by for this qual to be considered a pass.",
			Category -> "General"
		},
		StandardDeviationTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Inch],
			Units -> Inch,
			Description -> "The maximum amount that the depth distribution is allowed to spread by for this qual to be considered a pass.",
			Category -> "General"
		}
	}
}];
