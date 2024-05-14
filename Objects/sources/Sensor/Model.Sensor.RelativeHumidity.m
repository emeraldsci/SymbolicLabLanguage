

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, RelativeHumidity], {
	Description->"Model of a device for measuring Relative Humidity.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "Maximum relative humidity percentage that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "Minimum relative humidity percentage that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "This is the smallest change in relative humidity percentage that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Sensor Information"
		},
		ManufacturerUncertainty -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
			Category -> "Sensor Information"
		}
	}
}];
