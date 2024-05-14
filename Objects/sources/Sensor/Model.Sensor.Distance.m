(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: andre *)
(* :Date: 2023-04-06 *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, Distance], {
	Description->"Model of a device for reporting the values measured by a Mitutoyo DistanceGauge.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Millimeter,
			Description -> "Maximum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Millimeter,
			Description -> "Minimum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Milli Meter,
			Description -> "The smallest change in value that the sensor can interpret. Also known as readability, increment, scale division.",
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