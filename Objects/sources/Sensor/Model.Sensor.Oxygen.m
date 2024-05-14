(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Oxygen], {
	Description->"Model of a device for measuring O2 levels.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxO2 -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Maximum O2 level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinO2 -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Minimum O2 level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PPM],
			Units -> PPM,
			Description -> "This is the smallest change in O2 level that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
