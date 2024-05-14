(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, HeatGun], {
	Description->"Model information for a portable tool with a heating element used to emit a stream of heated air.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PowerType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PowerTypeP,
			Description -> "The type(s) of the power source(s) used by parts of this model.",
			Category -> "Item Specifications"
		},

		PlugRequirements -> {
			Format -> Single,
			Class -> {
				PlugNumber->Integer,
				Phases->Integer,
				Voltage->Integer,
				Current->Real,
				PlugType->String
			},
			Pattern :> {
				PlugNumber->GreaterP[0, 1],
				Phases->GreaterP[0],
				Voltage->RangeP[100*Volt, 480*Volt],
				Current->GreaterP[0*Ampere],
				PlugType->NEMADesignationP
			},
			Headers -> {
				PlugNumber->"Number of Plugs",
				Phases->"Phases",
				Voltage->"Voltage",
				Current->"Current",
				PlugType->"Plug Type"
			},
			Units -> {
				PlugNumber -> None,
				Phases -> None,
				Voltage -> Volt,
				Current -> Ampere,
				PlugType -> None
			},
			Description -> "All electrical requirements for plug-in parts of this model.",
			Category -> "Item Specifications"
		},

		CordLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Foot],
			Units -> Foot,
			Description -> "Indicates the length of the power cord.",
			Category -> "Item Specifications"
		},

		PowerConsumption -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Watt],
			Units -> Watt,
			Description -> "Estimated power consumption rate of the part in Watts (Joule/Second).",
			Category -> "Item Specifications",
			Abstract->True
		},

		AdjustableFanSpeed->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a part of this model has adjustable fan speeds.",
			Category -> "Item Specifications",
			Abstract->True
		},

		AdjustableTemperature->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a part of this model can be adjusted to multiple temperatures.",
			Category -> "Item Specifications",
			Abstract->True
		},

		MinFlowRate->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*(Liter/Minute)],
			Units -> Liter/Minute,
			Description -> "For each member of MinTemperature, minimum flow rate of air produced.",
			Category -> "Operating Limits",
			IndexMatching->MinTemperature,
			Abstract->True
		},

		MaxFlowRate->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*(Liter/Minute)],
			Units -> Liter/Minute,
			Description -> "For each member of MaxTemperature, maximum flow rate of air produced.",
			Category -> "Operating Limits",
			IndexMatching->MaxTemperature,
			Abstract->True
		},

		MinTemperature->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum air temperature produced by the part for each fan speed in celsius.",
			Category -> "Operating Limits",
			Abstract->True
		},

		MaxTemperature->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum air temperature produced by the part for each fan speed in celsius.",
			Category -> "Operating Limits",
			Abstract->True
		}
	}
}];
