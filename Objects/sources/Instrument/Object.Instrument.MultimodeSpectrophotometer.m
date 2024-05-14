(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, MultimodeSpectrophotometer], {
	Description->"A multimode spectrophotometer that can collect fluorescence and light scattering data for protein characterization (Tm, Tagg, kD, B22/G22, PDI)  during thermal incubation.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MinTemperature -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern:> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern:> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits"
		},
		MinTemperatureRamp -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperatureRamp]],
			Pattern:> GreaterP[0*Celsius/Minute],
			Description -> "The minimum rate at which the spectrophotometer can change temperature.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperatureRamp]],
			Pattern:> GreaterP[0*Celsius/Minute],
			Description -> "The maximum rate at which the spectrophotometer can change temperature.",
			Category -> "Operating Limits"
		},
		MinSampleConcentration -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSampleConcentration]],
			Pattern:> GreaterP[0*Milligram/Milliliter],
			Description -> "The minimum sample concentration of a reference sample the spectrophotometer can measure.",
			Category -> "Operating Limits"
		},
		MaxSampleConcentration -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxSampleConcentration]],
			Pattern:> GreaterP[0*Milligram/Milliliter],
			Description ->  "The maximum sample concentration of a reference sample the spectrophotometer can measure.",
			Category -> "Operating Limits"
		},

		FluorescenceWavelengths -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], FluorescenceWavelengths]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "The laser wavelengths available on the instrument for fluorescence excitation.",
			Category -> "Instrument Specifications"
		},
		StaticLightScatteringWavelengths -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], StaticLightScatteringWavelengths]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "The laser wavelengths available on the instrument for use as static light scattering light source.",
			Category -> "Instrument Specifications"
		},
		DynamicLightScatteringWavelengths -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], DynamicLightScatteringWavelengths]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "The laser wavelengths available on the instrument for use as dynamic light scattering light source.",
			Category -> "Instrument Specifications"
		},

		FluorescenceDetector -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], FluorescenceDetector]],
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring emission intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		StaticLightScatteringDetector -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], StaticLightScatteringDetector]],
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring static light scattering intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		DynamicLightScatteringDetector -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], DynamicLightScatteringDetector]],
			Pattern:> SpectrophotometerDetectorP,
			Description -> "The apparatus used for measuring dynamic light scattering intensity in the multimode spectrophotometer.",
			Category -> "Instrument Specifications"
		},
		ReservoirFluid -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], ReservoirFluid]],
			Pattern:> _Link,
			Description ->"The model of reservoir fluid used by this instrument.",
			Category -> "Instrument Specifications"
		},
		ReservoirVolume -> {
			Format -> Computable,
			Expression:> SafeEvaluate[{Field[Model]}, Download[Field[Model], ReservoirVolume]],
			Pattern:> GreaterP[0*Liter],
			Description ->"The volume of the reservior fluid used by this instrument.",
			Category -> "Instrument Specifications"
		},
		CalibrationStandardIntensity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The most recent scattered light intensity of a standard sample in counts per second.",
			Category->"Instrument Specifications"
		}
	}
}]

