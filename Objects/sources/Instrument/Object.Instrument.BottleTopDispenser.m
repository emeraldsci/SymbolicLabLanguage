

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, BottleTopDispenser], {
	Description->"A liquid dispenser that screws onto the top of a bottle.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Minimum volume this bottle top dispenser can dispense.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Maximum volume this bottle top dispenser can dispense.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Resolution of the bottle top dispenser's volume-indicating markings, determining the increments at which volume can be dispensed.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
