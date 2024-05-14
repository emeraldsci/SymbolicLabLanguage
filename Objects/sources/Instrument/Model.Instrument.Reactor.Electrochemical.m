(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Reactor, Electrochemical], {
	Description->"The model of an instrument performs electrochemical reactions and / or cyclic voltammetry measurements. The instrument can control the applied voltage or current between different electrodes inserted into a sample solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* General *)
		Modes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ElectrochemicalModeP,
			Description -> "Indicates if this electrochemical reactor model can be used for electrochemical reactions (ConstantVoltage, ConstantCurrent) or CyclicVoltammetry.",
			Category -> "Model Information",
			Abstract -> True
		},
		MaxElectrodeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Indicates the maximum positive and negative voltage the instrument can provide on the electrode for ConstantVoltage or ConstantCurrent modes.",
			Category -> "Operating Limits"
		},
		MaxElectrodeCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Ampere],
			Units -> Ampere,
			Description -> "Indicates the maximum positive and negative current the instrument can provide between the working and the counter electrode for CyclicVoltammetry, and between the cathode and the anode for ConstantVoltage or ConstantCurrent.",
			Category -> "Operating Limits"
		},
		MinOperationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the minimum operation temperature in the surrounding space for this electrochemical reactor model.",
			Category -> "Operating Limits"
		},
		MaxOperationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the maximum operation temperature in the surrounding space for this electrochemical reactor model.",
			Category -> "Operating Limits"
		},
		MaxOperationRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Indicates the maximum operation humidity in the surrounding space for this electrochemical reactor model.",
			Category -> "Operating Limits"
		},

		(* Electrochemical Reaction Related *)
		ElectrochemicalVoltageAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millivolt],
			Units -> Millivolt,
			Description -> "Indicates the level of uncertainty of voltage / potential measurement when performing electrochemical reactions.",
			Category -> "Electrochemical Synthesis"
		},
		ElectrochemicalCurrentAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliampere],
			Units -> Milliampere,
			Description -> "Indicates the level of uncertainty of current measurement when performing electrochemical reactions.",
			Category -> "Electrochemical Synthesis"
		},

		(* Cyclic Voltammetry Related *)
		MinCyclicVoltammetryPotential -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LessEqualP[0 Millivolt],
			Units -> Millivolt,
			Description -> "Indicates the minimum negative voltage / potential that the instrument can provide to the working electrode when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MaxCyclicVoltammetryPotential -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millivolt],
			Units -> Millivolt,
			Description -> "Indicates the maximum positive voltage / potential that the instrument can provide to the working electrode when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MinPotentialSweepRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millivolt/Second],
			Units -> Millivolt/Second,
			Description -> "Indicates the minimum potential sweep rate (how fast the potential is scanned) the instrument can provide when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MaxPotentialSweepRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millivolt/Second],
			Units -> Millivolt/Second,
			Description -> "Indicates the maximum potential sweep rate (how fast the potential is scanned) the instrument can provide when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		CyclicVoltammetryPotentialAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millivolt],
			Units -> Millivolt,
			Description -> "Indicates the level of uncertainty of potential measurement when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		CyclicVoltammetryCurrentAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microampere],
			Units -> Microampere,
			Description -> "Indicates the level of uncertainty of current measurement accuracy when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},

		(* Stirring Related *)
		Stirring -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this electrochemical reactor model has an attachable stirring component.",
			Category -> "Stirring"
		},
		MinStirringSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "Indicates the minimum stirring speed (revolutions per minute) this electrochemical reactor model can provide.",
			Category -> "Stirring"
		},
		MaxStirringSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Indicates the maximum stirring speed (revolutions per minute) this electrochemical reactor model can provide.",
			Category -> "Stirring"
		},
		StirringSpeedAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Indicates the level of uncertainty of stirring speed for this electrochemical reactor model.",
			Category -> "Stirring"
		},
		MaxStirringVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "Indicates the maximum amount of liquid the instrument stirrer can safety stir.",
			Category -> "Stirring"
		},
		DefaultStirringBars -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, StirBar],
			Description -> "Indicates the stir bar models that are recommended to be used with this electrochemical reactor model.",
			Category -> "Stirring"
		}
	}
}];
