(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sensor, pH], {
	Description->"Device for measuring pH.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxpH]],
			Pattern :> RangeP[0, 14],
			Description -> "Maximum pH level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinpH]],
			Pattern :> RangeP[0, 14],
			Description -> "Minimum pH level that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0],
			Description -> "This is the smallest change in pH level that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Sensor Information"
		},
		ManufacturerUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
			Pattern :> GreaterP[0*Percent],
			Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
			Category -> "Sensor Information"
		},
		TransmitterCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,Sensor,pH],
			Description -> "The most recent calibration of the pH meter's transmitter created using a pH simulator.",
			Category -> "Sensor Information"
		}	
	}
}];
