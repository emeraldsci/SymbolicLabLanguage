(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, DensityMeter], {
	Description->"A model describing a device for high precision measurement of density using the oscillating U-tube method.
	The instrument uses the measured oscillation of a U-shaped glass tube filled with a gas or liquid to determine the density of the sample with a high degree of accuracy",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DensityAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Units -> Gram/(Centimeter^3),
			Description -> "The accuracy of a calibrated density measurement result under ideal conditions and for low densities/viscosities.",
			Category -> "Instrument Specifications"
		},
		TemperatureAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The accuracy of a calibrated temperature measurement result under ideal conditions and for low densities/viscosities.",
			Category -> "Instrument Specifications"
		},
		ManufacturerDensityRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Units -> Gram/(Centimeter^3),
			Description -> "The variation in density measurements taken under the same repeated conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		ManufacturerTemperatureRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The variation in temperature measurements taken under the same repeated conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		ManufacturerReproducibility -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Units -> Gram/(Centimeter^3),
			Description -> "The variation between distinct density measurements taken under the same conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		MinDensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram/(Centimeter^3)],
			Units -> Gram/(Centimeter^3),
			Description -> "Minimum density the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxDensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Units -> Gram/(Centimeter^3),
			Description -> "Maximum density the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "Minimum sample volume the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
