

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Waste], {
	Description->"Information for containers which house laboratory waste.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		WasteType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], WasteType]],
			Pattern :> WasteTypeP,
			Description -> "Indicates the type of waste collected in this container.",
			Category -> "Container Specifications"
		}
	}
}];
