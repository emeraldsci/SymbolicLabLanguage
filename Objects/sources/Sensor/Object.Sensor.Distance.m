(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: andre *)
(* :Date: 2023-04-06 *)

DefineObjectType[Object[Sensor, Distance], {
	Description->"A device for reporting the values measured by a Mitutoyo DistanceGauge.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxDistance -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDistance]],
			Pattern :> DistanceP,
			Description -> "Maximum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinDistance -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDistance]],
			Pattern :> DistanceP,
			Description -> "Minimum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> DistanceP,
			Description -> "The smallest change in value that the sensor can interpret. Also known as readability, increment, scale division.",
			Category -> "Sensor Information"
		},
		ManufacturerUncertainty -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
			Pattern :> GreaterP[0*Percent],
			Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
			Category -> "Sensor Information"
		}
	}
}];