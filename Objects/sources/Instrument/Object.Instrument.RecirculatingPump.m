

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, RecirculatingPump], {
	Description->"A recirculating heating/cooling liquid pump.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		PumpStrength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PumpStrength]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "Strength of the pump's recirculator measured in provided pressure.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FluidVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FluidVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Amount of heat transfer fluid needed to fill the pump.",
			Category -> "Instrument Specifications"
		},
		FluidType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RecirculatingFluidTypeP,
			Description -> "Type of recirculating fluid used for heat transfer.",
			Category -> "Instrument Specifications"
		},
		FluidModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Model of recirculating fluid used for heat transfer.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the recirculating pump can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the recirculating pump can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Maximum rate at which the pump can circulate the transfer fluid.",
			Category -> "Operating Limits"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][RecirculatingPump],
			Description -> "The liquid handler that is connected to this recirculating pump.",
			Category -> "Instrument Specifications"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RotaryEvaporator][RecirculatingPump],
			Description -> "The rotary evaporator that is connected to this recirculating pump.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Internal diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
