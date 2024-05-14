

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Reactor, Electrochemical], {
	Description->"Object information of an instrument performs electrochemical reactions and / or cyclic voltammetry measurements. The instrument can control the applied voltage or current between different electrodes inserted into a sample solution.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* General *)
		Modes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Modes]],
			Pattern :> ElectrochemicalModeP,
			Description -> "Indicates if this electrochemical reactor model can be used for electrochemical reactions (ConstantVoltage, ConstantCurrent) or CyclicVoltammetry.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,SchlenkLine],
			Description -> "The Schlenk line used as the vacuum and inert gas source during degassing.",
			Category -> "Instrument Specifications"
		},
		ElectrodeImagingDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck],
			Description -> "Indicates the deck to place the ElectrodeImagingRack when the electrode is being imaged.",
			Category -> "Instrument Specifications"
		},
		MaxElectrodeVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxElectrodeVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "Indicates the maximum positive and negative voltage the instrument can provide on the electrode for ConstantVoltage or ConstantCurrent modes.",
			Category -> "Operating Limits"
		},
		MaxElectrodeCurrent -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxElectrodeCurrent]],
			Pattern :> GreaterP[0*Ampere],
			Description -> "Indicates the maximum positive and negative current the instrument can provide between the working and the counter electrode for CyclicVoltammetry, and between the cathode and the anode for ConstantVoltage or ConstantCurrent.",
			Category -> "Operating Limits"
		},
		MinOperationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinOperationTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Indicates the minimum operation temperature in the surrounding space for this electrochemical reactor instrument.",
			Category -> "Operating Limits"
		},
		MaxOperationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOperationTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Indicates the maximum operation temperature in the surrounding space for this electrochemical reactor instrument.",
			Category -> "Operating Limits"
		},
		MaxOperationRelativeHumidity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOperationRelativeHumidity]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Indicates the maximum operation humidity in the surrounding space for this electrochemical reactor instrument.",
			Category -> "Operating Limits"
		},

		(* Electrochemical Reaction Related *)
		ElectrochemicalVoltageAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ElectrochemicalVoltageAccuracy]],
			Pattern :> GreaterP[0*Millivolt],
			Description -> "Indicates the level of uncertainty of voltage / potential measurement when performing electrochemical reactions.",
			Category -> "Electrochemical Synthesis"
		},
		ElectrochemicalCurrentAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ElectrochemicalCurrentAccuracy]],
			Pattern :> GreaterP[0*Milliampere],
			Description -> "Indicates the level of uncertainty of current measurement when performing electrochemical reactions.",
			Category -> "Electrochemical Synthesis"
		},

		(* Cyclic Voltammetry Related *)
		MinCyclicVoltammetryPotential -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinCyclicVoltammetryPotential]],
			Pattern :> VoltageP,
			Description -> "Indicates the minimum negative voltage / potential that the instrument can provide to the working electrode when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MaxCyclicVoltammetryPotential -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxCyclicVoltammetryPotential]],
			Pattern :> VoltageP,
			Description -> "Indicates the maximum positive voltage / potential that the instrument can provide to the working electrode when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MinPotentialSweepRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinPotentialSweepRate]],
			Pattern :> GreaterEqualP[0*Millivolt/Second],
			Description -> "Indicates the minimum potential sweep rate (how fast the potential is scanned) the instrument can provide when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		MaxPotentialSweepRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPotentialSweepRate]],
			Pattern :> GreaterEqualP[0*Millivolt/Second],
			Description -> "Indicates the maximum potential sweep rate (how fast the potential is scanned) the instrument can provide when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		CyclicVoltammetryPotentialAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],CyclicVoltammetryPotentialAccuracy]],
			Pattern :> GreaterP[0*Millivolt],
			Description -> "Indicates the level of uncertainty of potential measurement when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},
		CyclicVoltammetryCurrentAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],CyclicVoltammetryCurrentAccuracy]],
			Pattern :> GreaterP[0*Microampere],
			Description -> "Indicates the level of uncertainty of current measurement accuracy when performing cyclic voltammetry measurements.",
			Category -> "Cyclic Voltammetry"
		},

		(* Stirring Related *)
		Stirring -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Stirring]],
			Pattern :> BooleanP,
			Description -> "Indicates if this electrochemical reactor instrument has an attachable stirring component.",
			Category -> "Stirring"
		},
		MinStirringSpeed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinStirringSpeed]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "Indicates the minimum stirring speed (revolutions per minute) this electrochemical reactor instrument can provide.",
			Category -> "Stirring"
		},
		MaxStirringSpeed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxStirringSpeed]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Indicates the maximum stirring speed (revolutions per minute) this electrochemical reactor instrument can provide.",
			Category -> "Stirring"
		},
		StirringSpeedAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirringSpeedAccuracy]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Indicates the level of uncertainty of stirring speed for this electrochemical reactor instrument.",
			Category -> "Stirring"
		},
		MaxStirringVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxStirringVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "Indicates the maximum amount of liquid the instrument stirrer can safety stir.",
			Category -> "Stirring"
		},
		DefaultStirringBars -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],DefaultStirringBars]],
			Pattern :> _Link,
			Relation -> Model[Part, StirBar],
			Description -> "Indicates the stir bar models that are recommended to be used with this electrochemical reactor model.",
			Category -> "Stirring"
		},

		ModeLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, ElectrochemicalModeP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date", "Electrochemical Mode", "Responsible Party"},
			Description -> "The historical record of the electrochemical operation modes of this instrument.",
			Category -> "Usage Information"
		}
	}
}];
