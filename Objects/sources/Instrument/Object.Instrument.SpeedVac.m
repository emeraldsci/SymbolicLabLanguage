

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, SpeedVac], {
	Description->"A device used to concentrate samples by removing solvent through lowering pressure, increased temperature, and centrifuging the vessel to avoid bumping.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the Speed-Vac can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the Speed-Vac can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxImbalance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxImbalance]],
			Pattern :> GreaterP[0*Gram],
			Description -> "Maximum weight imbalance the rotor can tolerate in the Speed-Vac.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
