(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, BubbleCounter], {
	Description->"Model of a device for measuring the air bubble count in a line.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxBubbleCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Maximum bubble count that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinBubbleCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Minimum bubble count that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "This is the smallest change that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
