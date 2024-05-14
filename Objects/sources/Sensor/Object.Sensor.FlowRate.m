

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Sensor, FlowRate], {
	Description->"Device for measuring flow rate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Description -> "Maximum flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Description -> "Minimum flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Meter^3/Second],
			Description -> "This is the smallest change in flow rate that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
