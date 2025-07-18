(* ::Package:: *)

DefineObjectType[Model[Qualification, PortableHeater], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a portable Heater.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TimePeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The time period over which to qualify the portable Heater.",
			Category -> "General"
		},
		SamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The rate at which to downsample the portable Heater data before analysis.",
			Category -> "General"
		},
		MeanTarget -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The target temperature of the target portable Heater model.",
			Category -> "General"
		},
		MeanTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The amount above or below the target temperature that the mean may deviate by for this qual to be considered a pass.",
			Category -> "General"
		},
		StandardDeviationTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The maximum amount that the temperature distribution is allowed to spread by for this qual to be considered a pass.",
			Category -> "General"
		},
		MaintenanceRecoveryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The amount of time after a maintenance has been performed on the target to exclude temperature data from assessment to allow the portable Heater to recover.",
			Category -> "General"
		},
		DefaultTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The default temperature of the PortableHeater for its idle status.",
			Category -> "General"
		}
	}
}];
