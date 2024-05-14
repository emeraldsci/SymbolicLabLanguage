(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,DLSPlateReader],{
	Description->"A model of a plate reader that can collect dynamic and static light scattering data for particle characterization (Tm, Tagg, kD, B22, PDI) with or without thermal incubation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		StaticLightScatteringWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nano*Meter],
			Units->Nanometer,
			Description->"Indicates the laser wavelengths available on the instrument for use as Static Light Scattering (SLS) light source.",
			Category->"Instrument Specifications"
		},
		DynamicLightScatteringWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nano*Meter],
			Units->Nanometer,
			Description->"Indicates the laser wavelengths available on the instrument for use as Dynamic Light Scattering (DLS) light source.",
			Category->"Instrument Specifications"
		},
		StaticLightScatteringDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>SpectrophotometerDetectorP,
			Description->"The apparatus used for measuring Static Light Scattering (SLS) intensity in the plate reader.",
			Category->"Instrument Specifications"
		},
		DynamicLightScatteringDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>SpectrophotometerDetectorP,
			Description->"The apparatus used for measuring Dynamic Light Scattering (DLS) intensity in the plate reader.",
			Category->"Instrument Specifications"
		},
		SampleCamera->{
			Format->Single,
			Class->Expression,
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
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the plate reader can incubate the samples.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the plate reader can incubate the samples.",
			Category->"Operating Limits"
		},
		MinTemperatureRamp->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Celsius/Second],
			Units->Celsius/Second,
			Description->"The minimum rate at which the plate reader can change the temperature of the incubation chamber.",
			Category->"Operating Limits"
		},
		MaxTemperatureRamp->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Celsius/Second],
			Units->Celsius/Second,
			Description->"The maximum rate at which the plate reader can change the temperature of the incubation chamber.",
			Category->"Operating Limits"
		},
		MinSampleMassConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milligram/Milliliter],
			Units->Milligram/Milliliter,
			Description->"The manufacturer's recommendation of the minimum sample concentration of a reference sample the plate reader can measure.",
			Category->"Operating Limits"
		},
		MaxSampleMassConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milligram/Milliliter],
			Units->Milligram/Milliliter,
			Description->"The manufacturer's recommendation of the maximum sample concentration of a reference sample the plate reader can measure.",
			Category->"Operating Limits"
		}
	}
}]
