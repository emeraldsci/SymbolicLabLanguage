

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Tachometer], {
	Description->"An instrument for measuring the rotation speed of a shaft or disk.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> {TachometerModeP..},
			Description -> "List of the type(s) of sensor(s) used by the tachometer.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ManufacturerLaserModeUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The uncertainty of the tachometer sensor reading when in laser mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		ManufacturerContactModeUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerContactModeUncertainty]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The uncertainty of the tachometer sensor reading when in contact mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		ManufacturerSurfaceModeUncertainty -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerSurfaceModeUncertainty]],
			Pattern :> RangeP[0*Percent, 100*Percent],
			Description -> "The uncertainty of the tachometer sensor reading when in surface mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		MinLaserModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLaserModeMeasurement]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The minimal detection value (in RPMs) for the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxLaserModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLaserModeMeasurement]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The maximum detection value (in RPMs) for the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		LaserModeResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserModeResolution]],
			Pattern :> {{GreaterP[0], GreaterP[0], GreaterP[0]}..},
			Description -> "The resolution(s) (in RPMs) for a given range (in RPMs) of the laser sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		},
		MinLaserModeDetectionDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLaserModeDetectionDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The mimimum detection range (in millimeters) of the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxLaserModeDetectionDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLaserModeDetectionDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The maximum detection range (in millimeters) of the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		MinContactModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinContactModeMeasurement]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The minimal detection value (in RPMs) for the contact sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxContactModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxContactModeMeasurement]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The maximum detection value (in RPMs) for the contact sensor tachometer.",
			Category -> "Operating Limits"
		},
		ContactModeResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ContactModeResolution]],
			Pattern :> {{GreaterP[0], GreaterP[0], GreaterP[0]}..},
			Description -> "The resolution(s) (in RPMs) for a given range (in RPMs) of the contact sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		},
		MinSurfaceModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSurfaceModeMeasurement]],
			Pattern :> GreaterP[(0*Meter)/Minute],
			Description -> "The minimal detection value (in meters/min) for the surface sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxSurfaceModeMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSurfaceModeMeasurement]],
			Pattern :> GreaterP[(0*Meter)/Minute],
			Description -> "The maximum detection value (in meters/min) for the surface sensor tachometer.",
			Category -> "Operating Limits"
		},
		SurfaceModeResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SurfaceModeResolution]],
			Pattern :> {{GreaterP[0], GreaterP[0], GreaterP[0]}..},
			Description -> "The resolution(s) (in meters/min) for a given range (in meters/min) of the surface sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		}
	}
}];
