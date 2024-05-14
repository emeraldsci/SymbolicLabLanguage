(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Darkroom], {
	Description->"Darkroom cabinet for photographic imaging of gels, blots, and plates under bright field or UV illumination.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CameraModel -> {
			Format -> Single,
			Class -> String,
			Pattern :> DarkroomCameraTypeP,
			Description -> "Model of camera installed in the darkroom.",
			Category -> "Instrument Specifications"
		},
		CameraResolution -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Pixel], GreaterP[0*Pixel]},
			Units -> {Mega Pixel, Mega Pixel},
			Description -> "Resolution of the camera.",
			Category -> "Instrument Specifications",
			Headers->{"Row Pixels", "Column Pixels"}
		},
		LightSources -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {DarkroomIlluminationP, GreaterP[0*Meter]},
			Units -> {None, Meter Nano},
			Description -> "Available light sources for illumination of the darkroom.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Illumination Type", "Wavelength"}
		},
		LensFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Description -> "List of available emission filters in the form: {wavelength, bandpass}.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Wavelength","Bandpass"}
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the darkroom.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
