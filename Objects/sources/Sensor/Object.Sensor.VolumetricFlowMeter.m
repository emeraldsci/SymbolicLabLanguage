

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Sensor, VolumetricFlowMeter], {
	Description->"Device for measuring volumetric flow rate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MaxVolumetricFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVolumetricFlowRate]],
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Description -> "Maximum volumetric flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinVolumetricFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVolumetricFlowRate]],
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Description -> "Minimum volumetric flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Meter^3/Second],
			Description -> "The smallest change in volumetric flow rate that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Sensor Information"
		},
		ManufacturerUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
			Pattern :> GreaterP[0*Percent],
			Description -> "The variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
			Category -> "Sensor Information"
		},
		GasType -> {
		    Format -> Single,
		    Class -> Expression,
		    Pattern :> GasP,
		    Description -> "The specific gas type being measured by this sensor.",
		    Category -> "Sensor Information"
		},
	    KFactor -> {
	        Class -> Real,
	        Format -> Computable,
	        Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],KFactor]],
	        Pattern :> GreaterP[0],
            Description -> "The dimensionless conversion factor used to measure the flow rate of a specific gas using a flow meter calibrated for Nitrogen.",
            Category -> "Sensor Information"
	        }

	}
}];
