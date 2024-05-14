

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, WasteBin], {
	Description->"A description for container types that store waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		WasteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteTypeP,
			Description -> "Type of waste held in container.",
			Category -> "Container Specifications"
		}
	}
}];
