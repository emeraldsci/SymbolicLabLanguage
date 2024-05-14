

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, Counterweight], {
	Description->"A precisely weighted container used to counterbalance a centrifuge.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Weight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Weight]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The nominal net weight of this counterweight, including container, contents, and plate seal.",
			Category -> "Item Specifications"
		}
	}
}];
