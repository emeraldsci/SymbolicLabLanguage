

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, VolumetricFlowMeter], {
	Description->"Model of a device for measuring Volumetric Flow Rate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxVolumetricFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "Maximum volumetric flow rate that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinVolumetricFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "Minimum volumetric flow rate  that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter^3/Second],
			Units -> Meter^3/Second,
			Description -> "The smallest change in volumetric flow rate  that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
