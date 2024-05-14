(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Darkroom], {
	Description->"Darkroom cabinet for photographic imaging of gels, blots, and plates under bright field or UV illumination.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		CameraModel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CameraModel]],
			Pattern :> DarkroomCameraTypeP,
			Description -> "Model of camera installed in the darkroom.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		CameraResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CameraResolution]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "Resolution of the camera in the form: {pixels per row, pixels per columm}.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Row Pixels", "Column Pixels"}
		},
		LightSources -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightSources]],
			Pattern :> {{DarkroomIlluminationP, GreaterP[0] | Null}..},
			Description -> "Available light sources for illumination of the darkroom in the form: {Type of illumination, wavelength}.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Illumination Type", "Wavelength"}
		},
		LensFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LensFilters]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "List of available filter wavelengths and band passes.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Wavelength","Bandpass"}
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the darkroom in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		}
	}
}];
