(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, RefrigerationUnit], {
	Description->"A refrigerator unit used to control the temperature of a sample-holding chamber.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		ConnectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Object[Instrument,SampleInspector][Refrigerator]],
			Description -> "The instrument for which this refrigeration helps to regulate temperature.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		PDU -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that controls power flow to this refrigeration unit.",
			Category -> "Part Specifications"
		},
		PDUIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU]},Download[Field[PDU],IP]],
			Pattern :> IpP,
			Description -> "The IP address of the PDU that controls power flow to this refrigeration unit.",
			Category -> "Part Specifications"
		},
		PDUPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUPart]],
			Pattern :> PDUPortP,
			Description -> "The specific PDU port to which this refrigeration unit is connected.",
			Category -> "Part Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the refrigeration unit can provide to its connected instrument.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the refrigeration unit can provide to its connected instrument.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperatureRamp]],
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Description -> "Maximum rate at which the refrigeration unit can change temperature.",
			Category -> "Operating Limits"
		}
	}
}];
