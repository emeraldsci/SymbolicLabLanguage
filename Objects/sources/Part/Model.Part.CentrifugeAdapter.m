

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, CentrifugeAdapter], {
	Description->"Model information for an adapter that is used to convert containers into a footprint that is compatible with a centrifuge rotor/bucket.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AdapterFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "The standard form factor that this adapter will convert the inserted container into such that is can be placed in a standard centrifuge rotor/bucket.",
			Category -> "Dimensions & Positions"
		}
	}
}];
