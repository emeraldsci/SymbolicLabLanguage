

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, RecirculatingPump], {
	Description->"A model for a recirculating heating/cooling liquid pump.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PumpStrength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "Strength of the pump's recirculator measured in provided pressure.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FluidVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Amount of heat transfer fluid needed to fill the pump.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the recirculating pump can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the recirculating pump can provide.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum rate at which the pump can circulate the transfer fluid.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,RotaryEvaporator][RecirculatingPump],
			Description -> "The model of rotovap this recirculating pump will move fluid through to condense evaporated solvents.",
			Category -> "Instrument Specifications"
		}
	}
}];
