(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Lyophilizer], {
	Description -> "A model of instrument that uses vacuum pressures and controlled sample freezing to induce sublimation of solvent.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument,VacuumPump]],
			Description -> "The model of pump used to generate a vacuum inside the lyophilizer by removing air and evaporated solvent from it's evaporation chamber.",
			Category -> "Instrument Specifications"
		},
		ProbeModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part]],
			Description -> "The thermocouples models used by this type of lyophilizer to monitor the temperature of samples during the run.",
			Category -> "Instrument Specifications"
		},
		MaxShelfHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centimeter,
			Description -> "The maximum distance between an open shelf and the shelf above it or the top of the chamber.",
			Category -> "Operating Limits"
		},
		MinShelfHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centimeter,
			Description -> "The maximum operable distance between an open shelf and the shelf above it or the top of the chamber.",
			Category -> "Operating Limits"
		},
		CondenserCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume under the sample chamber that is available for re-collecting sumblimated solvent to prevent it from passing through the vacuum.",
			Category -> "Instrument Specifications"
		},
		MinCondenserTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum achievable temperature of the cooling coils used to condense submlimated solvent downstream of the samples and upstream of the vacuum pump.",
			Category -> "Operating Limits"
		},
		MinShelfTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum achievable temperature of the sample shelves, which actively freeze the samples.",
			Category -> "Operating Limits"
		},
		MaxShelfTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum achievable temperature the sample shelves when heating the samples to increase the rate of sublimation.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Torr],
			Units -> Millitorr,
			Description -> "The minimum achievable pressure that the instrument can be safely operated at.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius/Minute],
			Units -> Celsius/Minute,
			Description -> "Maximum rate at which the lyophilizer can change temperature.",
			Category -> "Operating Limits"
		},
		MaxPressureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millitorr/Minute],
			Units -> Millitorr/Minute,
			Description -> "Maximum rate at which the lyophilizer can change pressure.",
			Category -> "Operating Limits"
		}
	}
}];
