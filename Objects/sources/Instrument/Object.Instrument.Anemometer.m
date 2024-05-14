

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Anemometer], {
	Description->"An instrument for measuring air flow speed.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AirVelocityMeasurementResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AirVelocityMeasurementResolution]],
			Pattern :> GreaterP[0*(Meter/Second)],
			Description -> "The resolution of the air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		AirVelocityMeasurementRange -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AirVelocityMeasurementRange]],
			Pattern :>{GreaterP[0*(Meter/Second)],GreaterP[0*(Meter/Second)]},
			Description -> "The range of accurate air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		AirVelocityMeasurementAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AirVelocityMeasurementAccuracy]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The accuracy of air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureMeasurementResolution]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The resolution of the anenometer sensor reading.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementRange -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureMeasurementRange]],
			Pattern :> {GreaterP[0*Kelvin],GreaterP[0*Kelvin]},
			Description -> "The range of accurate air velocity reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		},
		TemperatureMeasurementAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureMeasurementAccuracy]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The accuracy of temperature reading with the anenometer sensor.",
			Category -> "Instrument Specifications"
		}
	}
}];

