(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Spectrophotometer], {
	Description->"Model of a UV/Vis Spectrophotometer which generates absorbance spectra of cuvettes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "Type of lamp that the instrument uses as a light source.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LightSourceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LightSourceTypeP,
			Description -> "Specifies whether the instrument lamp provides continuous light or if it is flashed at time of acquisition.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Stirring -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not magnetic stirring is available to the unit.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "The model of temperature probe used to measure temperature when taking thermodynamic readings.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NumberOfTemperatureProbes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Number of temperature probes available to the unit.",
			Category -> "Instrument Specifications"
		},
		BeamOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the cuvette holder to the point at which the light hits the cuvette. This should correspond with the window offset (Z-height) on the cuvette in use.",
			Category -> "Container Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Units -> Celsius/Minute,
			Description -> "Maximum rate at which the spectrophotometer can change temperature.",
			Category -> "Operating Limits"
		},
		MinMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Monochromator minimum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxMonochromator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Monochromator maximum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MonochromatorBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Monochromator bandpass for absorbance filtering.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the purge tubing that connects nitrogen to the instrument.",
			Category -> "Dimensions & Positions"
		},
		MinAbsorbance->{
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterEqualP[0],
			Units -> AbsorbanceUnit,
			Description-> "The minimum absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category -> "Operating Limits"
		},
		MaxAbsorbance->{
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterEqualP[0],
			Units -> AbsorbanceUnit,
			Description-> "The maximum absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category -> "Operating Limits"
		},
		LinearAbsorbanceRange -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*AbsorbanceUnit], GreaterEqualP[0*AbsorbanceUnit]},
			Units -> {AbsorbanceUnit,AbsorbanceUnit},
			Description -> "The manufacturer reported linear absorbance range of this model of instrument.",
			Headers -> {"MinAbsorbance","MaxAbsorbance"},
			Category -> "Operating Limits"
		},
		ElectromagneticRange->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ElectromagneticRangeP,
			Description -> "Specifies the ranges of the Electromagnetic Spectrum, in which the instrument can measure.",
			Category -> "Instrument Specifications"
		},
		Thermocycling-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not temperature ramping is available to the instrument, allowing for the thermodynamics analysis of the samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
