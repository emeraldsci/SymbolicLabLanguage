

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, VaporTrap], {
	Description->"A refrigerated condenser for collecting solvent vapor.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		CondenserTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CondenserTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Temperature of the condenser units.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		CondenserCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CondenserCapacity]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Volume of condensate the vapor trap can hold.",
			Category -> "Operating Limits"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RotaryEvaporator][VaporTrap],
			Description -> "The rotary evaporator that is connected to this vapor trap.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument in units of millimeters.",
			Category -> "Dimensions & Positions"
		}
	}
}];
