

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, HandPump], {
	Description->"A manual pump used to transfer liquid out of solvent drums.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		DispenseHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],DispenseHeight]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The minimum height from which this pump dispenses liquid when attached to the appropriate source container.",
			Category -> "Dimensions & Positions"
		}
	}
}];
