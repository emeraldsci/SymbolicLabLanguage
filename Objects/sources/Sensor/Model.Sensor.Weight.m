

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, Weight], {
	Description->"Model of a device for measuring Weight.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "Maximum weight that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "Minimum weight that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "This is the smallest change in weight that the sensor can reliably measure. Also known as readability, increment, scale division.",
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
