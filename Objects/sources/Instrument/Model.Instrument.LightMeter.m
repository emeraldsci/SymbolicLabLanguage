

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, LightMeter], {
	Description->"A model for instrument[LightMeter] - an instrument for measuring light intensity.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinMeasurableIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Watt)/Centimeter^2],
			Units -> (Micro Watt)/Centimeter^2,
			Description -> "The minimum measurable intensity (in µW/cm^2) of the instrument.",
			Category -> "Operating Limits"
		},
		MaxMeasurableIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Watt)/Centimeter^2],
			Units -> (Micro Watt)/Centimeter^2,
			Description -> "The maximum measurable intensity (in µW/cm^2) of the instrument.",
			Category -> "Operating Limits"
		},
		IntensityAccuracy -> {
			Format -> Multiple,
			Class -> {Real, Integer},
			Pattern :> {_?PercentQ, GreaterP[0]},
			Units -> {Quantity[1, "Percent"], None},
			Description -> "The accuracy of the instrument in {percent accuracy, digits}.",
			Category -> "Operating Limits",
			Headers->{"Intensity Accuracy(%)","Digits"}
		},
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength (in nm) at which the instrument is able to operate.",
			Category -> "Operating Limits"
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength (in nm) at which the instrument is able to operate.",
			Category -> "Operating Limits"
		},
		MinOperationalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?TemperatureQ,
			Units -> Celsius,
			Description -> "The minumum temperature (in Celsius) at which the instrument is able to operate at.",
			Category -> "Operating Limits"
		},
		MaxOperationalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?TemperatureQ,
			Units -> Celsius,
			Description -> "The maximum temperature (in Celsius) at which the instrument is able to operate at.",
			Category -> "Operating Limits"
		},
		MinOperationalRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?PercentQ,
			Units -> Quantity[1, "Percent"],
			Description -> "The minimum relative humidity (in percent) at which the instrument is able to operate at.",
			Category -> "Operating Limits"
		},
		MaxOperationalRelativeHumidty -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?PercentQ,
			Units -> Quantity[1, "Percent"],
			Description -> "The maximum relative humidity (in percent) at which the instrument is able to operate at.",
			Category -> "Operating Limits"
		}
	}
}];
