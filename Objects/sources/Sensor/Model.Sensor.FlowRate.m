

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, FlowRate], {
	Description->"Model of a device for measuring Flow Rate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "Maximum flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "Minimum flow rate  that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "This is the smallest change in flow rate  that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
