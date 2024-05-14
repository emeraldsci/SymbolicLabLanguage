

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Waste], {
	Description->"Model information for containers which house laboratory waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		WasteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteTypeP,
			Description -> "Indicates the type of waste collected in this container.",
			Category -> "Container Specifications"
		}
	}
}];
