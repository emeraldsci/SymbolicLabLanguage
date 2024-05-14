

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, VaporTrap], {
	Description->"The model of a refrigerated condenser for collecting solvent vapor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CondenserTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature of the condenser Units.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		CondenserCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Volume of condensate the vapor trap can hold.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument in units of millimeters.",
			Category -> "Dimensions & Positions"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,RotaryEvaporator][VaporTrap],
			Description -> "The model of rotary evaporator this VaporTrap model connects to.",
			Category -> "Instrument Specifications"
		}
	}
}];
