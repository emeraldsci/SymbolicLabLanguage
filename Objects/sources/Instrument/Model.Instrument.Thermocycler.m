

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Thermocycler], {
	Description->"Model of a rapid temperature cycling device for use in polymerase chain reaction (PCR).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> qPCR | PCR,
			Description -> "Indicates if the instrument is capable of providing real time quantification (qPCR) or only end-point quantification (PCR).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "Type of optical source that the thermocycler uses to assess test samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Append[OpticalDetectorP,MultiPixelPhotonCounter],
			Description -> "Type of sensor used to obtain signals from test samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the thermocycler can reach.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the thermocycler can reach.",
			Category -> "Operating Limits"
		},
		MinTemperatureRamp->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*Celsius)/Second],
			Units->Celsius/Second,
			Description->"Minimum rate at which the thermocycler can change temperature.",
			Category->"Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "Maximum rate at which the thermocycler can change temperature.",
			Category -> "Operating Limits"
		},
		TemperatureGradient -> {
			Format -> Single,
			Class -> Boolean,
			Pattern:> BooleanP,
			Description -> "Indicates if the instrument can use a gradation of temperatures for annealing.",
			Category -> "Instrument Specifications"
		},
		TemperatureGradientOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Columns,Rows,Dual],
			Description -> "The direction in which the gradation of temperature can be set. 'Columns' indicates a change in temperature across columns such that each row has a constant temperature. 'Rows' indicates a change in temperature across rows such that each column has a constant temperature. 'Dual' indicates that the temperature gradient can be set across columns or rows.",
			Category -> "Instrument Specifications"
		},
		GradientTemperatureRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern:> {GreaterP[0*Kelvin],GreaterP[0*Kelvin]},
			Units -> {Celsius,Celsius},
			Description -> "The minimum and maximum temperatures that can be used to set the span of gradients.",
			Headers -> {"Minimum Temperature","Maximum Temperature"},
			Category -> "Instrument Specifications"
		},
		MinEmissionMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Emission monochromator minimum wavelength.",
			Category -> "Operating Limits"
		},
		MaxEmissionMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Emission monochromator maximum wavelength.",
			Category -> "Operating Limits"
		},
		EmissionMonochromatorBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Emission monochromator bandpass.",
			Category -> "Operating Limits"
		},
		MinExcitationMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Excitation monochromator minimum wavelength.",
			Category -> "Operating Limits"
		},
		MaxExcitationMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Excitation monochromator maximum wavelength.",
			Category -> "Operating Limits"
		},
		ExcitationMonochromatorBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Excitation monochromator bandpass.",
			Category -> "Operating Limits"
		},
		ExcitationLEDs->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0*Nano*Meter,1*Nano*Meter],GreaterP[0*Nano*Meter,1*Nano*Meter]},
			Units->{Meter*Nano,Meter*Nano},
			Headers->{"Center Wavelength","Bandwidth"},
			Description->"Light-emitting diode sources available to the instrument. The first quantity is the Center Wavelength, which is the midpoint between the wavelengths where transmittance is 50% (known as Full Width at Half Maximum (FWHM)). The second quantity is the bandwidth or the FWHM of the light source.",
			Category->"Instrument Specifications"
		},
		ExcitationLEDPower->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Watt],
			Units->Watt,
			Description->"For each member of ExcitationLEDs, the power output of the light source.",
			Category->"Instrument Specifications",
			IndexMatching->ExcitationLEDs
		},
		EmissionFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Headers -> {"Center Wavelength","Bandwidth"},
			Description -> "Fluorescent emission filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ExcitationFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Headers -> {"Center Wavelength","Bandwidth"},
			Description -> "Fluorescent excitation filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		CutoffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Fluorescent cutoff filters available to the instrument. The distance represents the wavelength at which the transmission decreases to 50% throughput in a shortpass filter.",
			Category -> "Operating Limits"
		}
	}
}];
