

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Tachometer], {
	Description->"A model of an instrument for measuring the rotation speed of a shaft or disk.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TachometerModeP,
			Description -> "List of the type(s) of sensor(s) used by the tachometer.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ManufacturerLaserModeUncertainty -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The uncertainty of the tachometer sensor reading when in laser mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		ManufacturerContactModeUncertainty -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The uncertainty of the tachometer sensor reading when in contact mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		ManufacturerSurfaceModeUncertainty -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The uncertainty of the tachometer sensor reading when in surface mode according to the manufacturer specifications. Here uncertainty is specifed as a percentage, varying with the magnitude of the reading.",
			Category -> "Instrument Specifications"
		},
		MinLaserModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The minimal detection value (in RPMs) for the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxLaserModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The maximum detection value (in RPMs) for the laser sensor tachometer.",
			Category -> "Operating Limits"
		},
		LaserModeResolution -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*RPM], GreaterP[0*RPM], GreaterP[0*RPM]},
			Units -> {RPM, RPM, RPM},
			Description -> "The resolution(s) (in RPMs) for a given range (in RPMs) of the laser sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		},
		MinLaserModeDetectionDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The mimimum detection range (in millimeters) of the laser sensor tachomter.",
			Category -> "Operating Limits"
		},
		MaxLaserModeDetectionDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The maximum detection range (in millimeters) of the laser sensor tachomter.",
			Category -> "Operating Limits"
		},
		MinContactModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The minimal detection value (in RPMs) for the contact sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxContactModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The maximum detection value (in RPMs) for the contact sensor tachometer.",
			Category -> "Operating Limits"
		},
		ContactModeResolution -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*RPM], GreaterP[0*RPM], GreaterP[0*RPM]},
			Units -> {RPM, RPM, RPM},
			Description -> "The resolution(s) (in RPMs) for a given range (in RPMs) of the contact sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		},
		MinSurfaceModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Meter)/Minute],
			Units -> Meter/Minute,
			Description -> "The minimal detection value (in meters/min) for the surface sensor tachometer.",
			Category -> "Operating Limits"
		},
		MaxSurfaceModeMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Meter)/Minute],
			Units -> Meter/Minute,
			Description -> "The maximum detection value (in meters/min) for the surface sensor tachometer.",
			Category -> "Operating Limits"
		},
		SurfaceModeResolution -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[(0*Meter)/Minute], GreaterP[(0*Meter)/Minute], GreaterP[(0*Meter)/Minute]},
			Units -> {Meter/Minute, Meter/Minute, Meter/Minute},
			Description -> "The resolution(s) (in meters/min) for a given range (in meters/min) of the surface sensor tachometer.",
			Category -> "Operating Limits",
			Headers->{"Resolution","Lower Bound","Upper Bound"}
		}
	}
}];
