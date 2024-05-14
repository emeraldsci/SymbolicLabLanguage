

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, HandPump], {
	Description->"Model information for a manual pump used to transfer liquid out of solvent drums.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DispenseHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "The minimum height from which this pump dispenses liquid when attached to the appropriate source container.",
			Category -> "Dimensions & Positions"
		}
	}
}];
