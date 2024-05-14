(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Evaporator], {
	Description->"Multi-well plate evaporators or tube evaporators.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		NitrogenEvaporatorType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NitrogenEvaporatorType]],
			Pattern :> NitrogenEvaporatorTypeP,
			Description ->"The category of nitrogen blow down evaporator.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the evaporator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the evaporator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Minimum flow rate a flow regulator can manage.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Maximum flow rate a flow regulator can manage.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		PDUHeatBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that controls the HeatBlock component of this evaporator.",
			Category -> "Instrument Specifications"
		},
		PDUHeatBlockIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUHeatBlock]},Download[Field[PDUHeatBlock],IP]],
			Pattern :> IpP,
			Description -> "The PDU IP that the HeatBlock component is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUHeatBlockPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUHeatBlock], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDUHeatBlock], PDUHeatBlock]],
			Pattern :> PDUPortNameP,
			Description -> "The PDU port that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		TemperatureSensor ->{
			Format -> Single,
			Class -> Link,
			Pattern:> _Link,
			Relation->Object[Sensor][DevicesMonitored],
			Description->"Sensornet temperature probe used by this evaporation instrument to measure the temperature of the bath.",
			Category -> "Sensor Information"
		}

	}
}];
