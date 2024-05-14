

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, PowerSupply], {
	Description->"Model of a power supply unit for running gel electrophoresis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ConstantVoltage | ConstantCurrent | ConstantPower,
			Description -> "Parameter which the power supply can hold constant.  Options include ConstantVoltage, ConstantCurrent, or ConstantPower.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NumberOfLeads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of gel boxes that can be run on the power supply at once.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage the power supply can provide.",
			Category -> "Operating Limits"
		},
		MaxCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere*Milli],
			Units -> Ampere Milli,
			Description -> "Maximum current the power supply can provide.",
			Category -> "Operating Limits"
		},
		MaxPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Watt],
			Units -> Watt,
			Description -> "Maximum power the power supply can provide.",
			Category -> "Operating Limits"
		}
	}
}];
