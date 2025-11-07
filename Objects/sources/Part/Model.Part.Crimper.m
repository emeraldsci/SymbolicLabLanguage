(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Crimper], {
	Description -> "A model for a handheld part that can attach crimped caps to containers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		CapDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the diameter of crimped caps that this crimper can affix to containers.",
			Category -> "Operating Limits"
		},
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "Indicates the cover footprint of the caps that this crimper can affix to containers.",
			Category -> "Operating Limits"
		}
	}
}];
