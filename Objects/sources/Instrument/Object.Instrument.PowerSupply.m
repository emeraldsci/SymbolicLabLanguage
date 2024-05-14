

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, PowerSupply], {
	Description->"Voltage power supply for running gel electrophoresis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> ConstantVoltage | ConstantCurrent | ConstantPower,
			Description -> "Parameter which the power supply can hold constant.  Options include ConstantVoltage, ConstantCurrent, or ConstantPower.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NumberOfLeads -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfLeads]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of gel boxes that can be run on the power supply at one time.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "Maximum voltage the power supply can provide.",
			Category -> "Operating Limits"
		},
		MaxCurrent -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCurrent]],
			Pattern :> GreaterP[0*Ampere*Milli],
			Description -> "Maximum current the power supply can provide.",
			Category -> "Operating Limits"
		},
		MaxPower -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxPower]],
			Pattern :> GreaterP[0*Watt],
			Description -> "Maximum power (in watts) that the power supply can provide.",
			Category -> "Operating Limits"
		}
	}
}];
