(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Spectrophotometer], {
	Description->"Model of a UV/Vis Spectrophotometer which generates absorbance spectra of cuvettes as part of a larger instrument.",
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
		
		BeamOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the cuvette holder to the point at which the laser beam hits the cuvette. This should correspond with the window offset (Z-height) on the cuvette in use.",
			Category -> "Container Specifications"
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
		
		ElectromagneticRange->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ElectromagneticRangeP,
			Description -> "Specifies the ranges of the Electromagnetic Spectrum, in which the instrument can measure.",
			Category -> "Instrument Specifications"
		}
	}
}];
