(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, VacuumPump], {
	Description->"A device that removes gas from a sealed volume in order to create a partial vacuum.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		PumpType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PumpType]],
			Pattern :> VacuumPumpTypeP,
			Description -> "Type of vacuum pump. Options include Oil, Diaphragm, Rocker, or Scroll.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		VacuumPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VacuumPressure]],
			Pattern :> RangeP[0*Atmosphere, 1*Atmosphere],
			Description -> "Minimum absolute pressure (zero-referenced against perfect vacuum) that this pump can achieve.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Maximum amount of air that the pump can displace for a given time under ideal circumstances.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Instrument Specifications"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][WastePump],
			Description -> "The liquid handler that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		SecondaryLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][WastePump],
			Description -> "The second liquid handler that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		Lyophilizer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Lyophilizer][VacuumPump],
			Description -> "The lyophilizer that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RotaryEvaporator][VacuumPump],
			Description -> "The rotary evaporator that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		FPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, FPLC][WastePump],
			Description -> "The FPLC instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		HPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, HPLC][WastePump],
			Description -> "The HPLC instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		IonChromatographySystem -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, IonChromatography][WastePump],
			Description -> "The Ion Chromatography instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		SupercriticalFluidChromatography -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SupercriticalFluidChromatography][WastePump],
			Description -> "The SupercriticalFluidChromatography instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		PlateWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateWasher][WastePump],
			Description -> "The plate washer instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		CuvetteWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, CuvetteWasher][VacuumPump],
			Description -> "The cuvette washer instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		VacuumManifold -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumManifold][VacuumPump],
			Description -> "The vacuum manifold instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		FilterBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, FilterBlock][VacuumPump],
			Description -> "The filter block instrument that is connected to this vacuum pump.",
			Category -> "Instrument Specifications"
		},
		IntegratedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][IntegratedVacuumPumps],
			Description -> "The Instrument that is directly hooked up to this vacuum pump.",
			Category -> "Integrations"
		}
	}
}];
