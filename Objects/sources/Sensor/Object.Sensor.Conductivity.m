

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Sensor, Conductivity], {
	Description->"Device for measuring Conductivity.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxConductivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxConductivity]],
			Pattern :> GreaterEqualP[0*Micro*Siemens],
			Description -> "Maximum conductivity that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinConductivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinConductivity]],
			Pattern :> GreaterEqualP[0*Micro*Siemens],
			Description -> "Minimum conductivity that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Micro*Siemens],
			Description -> "The smallest change in conductivity that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Sensor Information"
		},
		ManufacturerUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
			Pattern :> GreaterP[0*Percent],
			Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
			Category -> "Sensor Information"
		}
	}
}];
