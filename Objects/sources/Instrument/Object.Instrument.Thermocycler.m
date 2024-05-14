

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Thermocycler], {
	Description->"Rapid temperature cycling device for use in polymerase chain reaction (PCR).",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> qPCR | PCR,
			Description -> "Indicates if the instrument is capable of providing real time quantification (qPCR) or only end-point quantification (PCR).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LampType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LampType]],
			Pattern :> LampTypeP,
			Description -> "Type of optical source that the thermocycler uses to assess test samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DetectorType]],
			Pattern :> Append[OpticalDetectorP,MultiPixelPhotonCounter],
			Description -> "Type of sensor used to obtain signals from test samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the thermocycler can reach.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the thermocycler can reach.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperatureRamp]],
			Pattern :> GreaterP[(0*Celsius)/Second],
			Description -> "Maximum rate at which the thermocycler can change temperature.",
			Category -> "Operating Limits"
		},
		TemperatureGradient -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureGradient]],
			Pattern:> BooleanP,
			Description -> "Indicates if the instrument can use a gradation of temperatures for annealing.",
			Category -> "Instrument Specifications"
		},
		TemperatureGradientOrientation -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureGradientOrientation]],
			Pattern :> Alternatives[Columns,Rows,Dual],
			Description -> "The direction in which the gradation of temperature can be set. 'Columns' indicates a change in temperature across columns such that each row has a constant temperature. 'Rows' indicates a change in temperature across rows such that each column has a constant temperature. 'Dual' indicates that the temperature gradient can be set across columns or rows.",
			Category -> "Instrument Specifications"
		},
		GradientTemperatureRange -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],GradientTemperatureRange]],
			Pattern:> {GreaterP[0],GreaterP[0]},
			Description -> "The minimum and maximum temperatures that can be used to set the span of gradients.",
			Category -> "Instrument Specifications"
		},
		MinEmissionMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinEmissionMonochromator]],
			Pattern :> GreaterP[1*Nano*Meter, 1*Nano*Meter],
			Description -> "Emission monochromator minimum wavelength.",
			Category -> "Operating Limits"
		},
		MaxEmissionMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxEmissionMonochromator]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "Emission monochromator maximum wavelength.",
			Category -> "Operating Limits"
		},
		EmissionMonochromatorBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionMonochromatorBandpass]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "Emission monochromator bandpass.",
			Category -> "Operating Limits"
		},
		MinExcitationMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinExcitationMonochromator]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "Excitation monochromator minimum wavelength.",
			Category -> "Operating Limits"
		},
		MaxExcitationMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxExcitationMonochromator]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "Excitation monochromator maximum wavelength.",
			Category -> "Operating Limits"
		},
		ExcitationMonochromatorBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationMonochromatorBandpass]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "Excitation monochromator bandpass.",
			Category -> "Operating Limits"
		},
		EmissionFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionFilters]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "Fluorescent emission filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ExcitationLEDs->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationLEDs]],
			Pattern:>{{GreaterP[0],GreaterP[0]}..},
			Description->"Light-emitting diode sources available to the instrument. The first quantity is the Center Wavelength, which is the midpoint between the wavelengths where transmittance is 50% (known as Full Width at Half Maximum (FWHM)). The second quantity is the bandwidth or the FWHM of the light source.",
			Category->"Instrument Specifications"
		},
		ExcitationLEDPower->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationLEDPower]],
			Pattern:>{GreaterP[0]..},
			Description->"For each member of ExcitationLEDs, the power output of the light source.",
			Category->"Instrument Specifications"
		},
		ExcitationFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationFilters]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "Fluorescent excitation filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		CutoffFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CutoffFilters]],
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter]..},
			Description -> "Fluorescent cutoff filters available to the instrument. The distance represents the wavelength at which the transmission decreases to 50% throughput in a shortpass filter.",
			Category -> "Operating Limits"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedThermocyclers],
			Description -> "The liquid handler that is connected to this thermocycler.",
			Category -> "Integrations"
		}
	}
}];
