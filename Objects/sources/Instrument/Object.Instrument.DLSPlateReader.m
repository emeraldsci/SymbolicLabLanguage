(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,DLSPlateReader],{
	Description->"A model of a plate reader that can collect dynamic and static light scattering data for particle characterization (Tm, Tagg, kD, B22, PDI) with or without thermal incubation.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		StaticLightScatteringWavelengths->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],StaticLightScatteringWavelengths]],
			Pattern:>GreaterP[0*Nano*Meter],
			Description->"Indicates the laser wavelengths available on the instrument for use as Static Light Scattering (SLS) light source.",
			Category->"Instrument Specifications"
		},
		DynamicLightScatteringWavelengths->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DynamicLightScatteringWavelengths]],
			Pattern:>GreaterP[0*Nano*Meter],
			Description->"Indicates the laser wavelengths available on the instrument for use as Dynamic Light Scattering (DLS) light source.",
			Category->"Instrument Specifications"
		},
		StaticLightScatteringDetector->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],StaticLightScatteringDetector]],
			Pattern:>SpectrophotometerDetectorP,
			Description->"The apparatus used for measuring Static Light Scattering (SLS) intensity in the plate reader.",
			Category->"Instrument Specifications"
		},
		DynamicLightScatteringDetector->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DynamicLightScatteringDetector]],
			Pattern:>SpectrophotometerDetectorP,
			Description->"The apparatus used for measuring Dynamic Light Scattering (DLS) intensity in the plate reader.",
			Category->"Instrument Specifications"
		},
		SampleCamera->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SampleCamera]],
			Pattern:>SampleCameraP,
			Description->"The camera used to take images of the samples in the wells.",
			Category->"Instrument Specifications"
		},
		DryGas->{
			Format->Single,
			Class->Expression,
			Pattern:>GasP,
			Description->"The dry gas used to prevent condensation within the instrument at low temperatures.",
			Category->"Instrument Specifications"
		},
		DryGasPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The target pressure of the dry gas flow.",
			Category->"Instrument Specifications"
		},
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"The minimum temperature at which the plate reader can incubate the samples.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"The maximum temperature at which the plate reader can incubate the samples.",
			Category->"Operating Limits"
		},
		MinTemperatureRamp->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperatureRamp]],
			Pattern:>GreaterP[0*Celsius/Minute],
			Description->"The minimum rate at which the plate reader can change the temperature of the incubation chamber.",
			Category->"Operating Limits"
		},
		MaxTemperatureRamp->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperatureRamp]],
			Pattern:>GreaterP[0*Celsius/Minute],
			Description->"The maximum rate at which the plate reader can change the temperature of the incubation chamber.",
			Category->"Operating Limits"
		},
		MinSampleMassConcentration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinSampleConcentration]],
			Pattern:>GreaterP[0*Milligram/Milliliter],
			Description->"The manufacturer's recommendation of the minimum sample concentration of a reference sample the plate reader can measure.",
			Category->"Operating Limits"
		},
		MaxSampleMassConcentration->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxSampleConcentration]],
			Pattern:>GreaterP[0*Milligram/Milliliter],
			Description->"The manufacturer's recommendation of the maximum sample concentration of a reference sample the plate reader can measure.",
			Category->"Operating Limits"
		},
		CalibrationLog->{
			Format->Multiple,
			Class->{Date,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Data],Object[Protocol]|Object[Maintenance]},
			Description->"A record of light scattering data generated for the calibration runs on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date","Scattering Data","Protocol"}
		},
		CalibrationStandardIntensity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The most recent scattered light intensity of a standard sample in counts per second.",
			Category->"Qualifications & Maintenance"
		}
	}
}]

