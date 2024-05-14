

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Anemometer], {
	Description->"A model of an instrument for measuring air flow speed.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AirVelocityMeasurementResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Meter/Second)],
			Units -> (Meter/Second),
			Description -> "The resolution of the air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		AirVelocityMeasurementRange -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :>{GreaterP[0*(Meter/Second)],GreaterP[0*(Meter/Second)]},
			Units ->{(Meter/Second),(Meter/Second)},
			Headers->{"Minimum Velocity", "Maximum Velocity"},
			Description -> "The range of accurate air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		AirVelocityMeasurementAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The accuracy of air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The resolution of the anenometer sensor reading.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementRange -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :>{GreaterP[0*Kelvin],GreaterP[0*Kelvin]},
			Units -> {Celsius, Celsius},
			Headers->{"Minimum Temperature", "Maximum Temperature"},
			Description -> "The range of accurate air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The accuracy of temperature reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		}
	}
}];
