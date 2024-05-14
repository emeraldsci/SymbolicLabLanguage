(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Moisture], {
	Description->"Model of a device for measuring trace amounts of moisture.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxMoisture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Maximum moisture that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinMoisture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Minimum moisture that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PPM],
			Units -> PPM,
			Description -> "This is the smallest change in moisture that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
