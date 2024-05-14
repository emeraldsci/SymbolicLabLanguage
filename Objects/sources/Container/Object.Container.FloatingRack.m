

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, FloatingRack], {
	Description->"A container used to submerge tubes inside a liquid.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		NumberOfSlots -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfPSlots]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of slots in the rack that are capable of holding tubes.",
			Category -> "Dimensions & Positions"
		}
	}
}];
