(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, MultimodeSpectrophotometer], {
	Description->"A model of a multimode spectrophotometer that can collect fluorescence and light scattering data for protein characterization (Tm, Tagg, kD, B22/G22, PDI)  during thermal incubation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits"
		},
		MinTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Celsius/Second],
			Units -> Celsius/Second,
			Description -> "The minimum rate at which the spectrophotometer can change temperature.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Celsius/Second],
			Units -> Celsius/Second,
			Description -> "The maximum rate at which the spectrophotomer can change temperature.",
			Category -> "Operating Limits"
		},
		MinSampleConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Milligram/Milliliter],
			Units -> Milligram/Milliliter,
			Description -> "The minimum sample concentration of a reference sample the spectrophotometer can measure.",
			Category -> "Operating Limits"
		},
		MaxSampleConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Milligram/Milliliter],
			Units -> Milligram/Milliliter,
			Description -> "The maximum sample concentration of a reference sample the spectrophotometer can measure.",
			Category -> "Operating Limits"
		},
		FluorescenceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units->Nanometer,
			Description -> "Indicates the laser wavelengths available on the instrument for fluorescence excitation.",
			Category -> "Instrument Specifications"
		},
		StaticLightScatteringWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units->Nanometer,
			Description -> "Indicates the laser wavelengths available on the instrument for use as static light scattering light source.",
			Category -> "Instrument Specifications"
		},
		DynamicLightScatteringWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units->Nanometer,
			Description -> "Indicates the laser wavelengths available on the instrument for use as dynamic light scattering light source.",
			Category -> "Instrument Specifications"
		},
		FluorescenceDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring emission intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		StaticLightScatteringDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring static light scattering intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		DynamicLightScatteringDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring dynamic light scattering intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		ReservoirFluid -> {
			Format -> Single,
			Class -> Link,
			Pattern:> _Link,
			Relation -> Model[Sample],
			Description ->"The model of reservoir fluid used by this instrument.",
			Category -> "Instrument Specifications"
		},
		ReservoirVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterP[0*Liter],
			Description ->"The volume of the reservior fluid used by this instrument.",
			Category -> "Instrument Specifications"
		},
		CCDArraySaturationIntensityData -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Nanometer,ArbitraryUnit}..}],
			Units->{Nanometer,ArbitraryUnit},
			Description -> "The fluorescence emission signal intensity at the saturation point of the CCD detector array across the entire fluorescence spectra.",
			Category -> "Instrument Specifications"
		}
	}
}]
