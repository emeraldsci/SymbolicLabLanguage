(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Decrimper], {
	Description -> "A model for a handheld part that can remove crimped caps from containers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		CapDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the diameter of crimped caps that this part can remove from containers.",
			Category -> "Operating Limits"
		},
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "Indicates the cover footprint of the caps that this decrimper can remove from containers.",
			Category -> "Operating Limits"
		}
	}
}];
