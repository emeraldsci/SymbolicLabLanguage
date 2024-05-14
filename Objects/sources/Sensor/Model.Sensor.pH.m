

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, pH], {
	Description->"Model of a device for measuring pH",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "Maximum pH level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "Minimum pH level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "This is the smallest change in pH level that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
