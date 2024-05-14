

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Microscope], {
	Description->"Optical magnification imaging device for obtaining images under bright field or fluorescent illumination.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		Modes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Modes]],
			Pattern :> {MicroscopeModeP..},
			Description -> "The types of images the microscope is capable of generating.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Orientation -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Orientation]],
			Pattern :> MicroscopeViewOrientationP,
			Description -> "Indicates if the sample is viewed from above (upright) or underneath (inverted).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IlluminationTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],IlluminationTypes]],
			Pattern :> {MicroscopeIlluminationTypeP..},
			Description -> "The sources of illumination available to image samples on the microscope.",
			Category -> "Instrument Specifications"
		},
		LampTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LampTypes]],
			Pattern :> {LampTypeP..},
			Description -> "Indicates the sources of illumination available to the microscope.",
			Category -> "Instrument Specifications"
		},
		CameraModel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CameraModel]],
			Pattern :> ObjectReferenceP[Model[Part, Camera]],
			Description -> "The model of the digital camera connected to the microscope.",
			Category -> "Instrument Specifications"
		},
		Objectives -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Contents]}, Computables`Private`getMicroscopeObjectives[Field[Contents]]],
			Pattern :> {ObjectReferenceP[Object[Part, Objective]]..},
			Description -> "A list of the viewing objectives available for this model of microscope.",
			Category -> "Instrument Specifications"
		},
		OpticModules -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Object]}, Computables`Private`getOpticModules[Field[Object]]],
			Pattern :> {ObjectReferenceP[Object[Part, OpticModule]]..},
			Description -> "A list of the optic modules that are installed on this microscope.",
			Category -> "Instrument Specifications"
		},
		EyePieceMagnification -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EyePieceMagnification]],
			Pattern :> GreaterP[0],
			Description -> "The magnification provided by the eyepiece or camera lens.",
			Category -> "Instrument Specifications"
		},
		ObjectiveMagnifications -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Objectives]}, Computables`Private`getMicroscopeObjectiveMagnifications[Field[Objectives]]],
			Pattern :> {GreaterP[0]..},
			Description -> "A list of the objective magnifications installed on this microscope.",
			Category -> "Instrument Specifications"
		},
		FluorescenceFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[OpticModules]}, Computables`Private`getFluorescenceFilters[Field[OpticModules]]],
			Pattern :> {{GreaterP[0*Meter*Nano], GreaterP[0*Meter*Nano]}..},
			Description -> "A list of the fluorescence filters available, based on the optic modules installed on this instrument.",
			Category -> "Instrument Specifications",
			Headers -> {"Excitation Wavelength","Emission Wavelength"}
		},

		(* microscope calibration *)
		MicroscopeCalibration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MicroscopeCalibration]],
			Pattern:>BooleanP,
			Description->"Indicates if the microscope can be calibrated by running a maintenance protocol.",
			Category->"Qualifications & Maintenance"
		},
		CurrentMicroscopeCalibration->{
			Format->Single,
			Class->{Expression,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Maintenance],Model[Maintenance]},
			Description->"The most recent maintenance run to calibrate the light path of this microscope.",
			Headers->{"Date","Maintenance","Maintenance Model"},
			Category->"Qualifications & Maintenance",
			Abstract->True
		},
		Camera->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Camera],
			Description->"The digital camera connected to the microscope.",
			Category->"Instrument Specifications"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedMicroscopes],
			Description -> "The liquid handler that is connected to this microscope.",
			Category -> "Integrations"
		}
	}
}];
