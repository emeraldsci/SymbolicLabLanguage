(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, DensityMeter], {
	Description->"A device for high precision measurement of density using the oscillating U-tube method. The instrument uses the measured oscillation
	of a U-shaped glass tube filled with a gas or liquid to determine the density of the sample with a high degree of accuracy",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		DensityAccuracy -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DensityAccuracy]],
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Description -> "The accuracy of a calibrated density measurement result under ideal conditions and for low densities/viscosities.",
			Category -> "Instrument Specifications",
			Abstract -> True

		},
		TemperatureAccuracy -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],TemperatureAccuracy]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The accuracy of a calibrated temperature measurement result under ideal conditions and for low densities/viscosities.",
			Category -> "Instrument Specifications"
		},
		ManufacturerDensityRepeatability -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerDensityRepeatability]],
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Description -> "The variation in density measurements taken under the same repeated conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		ManufacturerTemperatureRepeatability -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerTemperatureRepeatability]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The variation in temperature measurements taken under the same repeated conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		ManufacturerReproducibility -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerReproducibility]],
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Description -> "The variation between distinct density measurements taken under the same conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		MinDensity -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinDensity]],
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Description -> "Minimum density the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxDensity -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxDensity]],
			Pattern :> GreaterP[0*Gram/(Centimeter^3)],
			Description -> "Maximum density the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinVolume -> {
			Format -> Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "Minimum sample volume the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
