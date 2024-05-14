(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Vessel, GasWashingBottle], {
	Description->"A model for a vessel container used to hold the solvent which saturates the pass-through inert gas.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InletFritted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Specifies if the gas inlet tube is equipped with a piece of porous (fritted) glass the end of the tube. The fritted glass filters the gas before it goes into the solution contained within the GasWashingBottle.",
			Category -> "Model Information",
			Abstract -> True
		},
		InletPorosity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GasWashingBottlePorosityP,
			Description -> "Specifies pore size of the gas inlet tube fritted end.",
			Category -> "Model Information"
		}
	}
}];
