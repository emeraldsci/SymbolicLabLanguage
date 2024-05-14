

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Mixer], {
	Description -> "Model information a liquid chromatography module designed to homogenize passing liquids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The limit of the applied force over area on the liquid surface of the part.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the part can handle.",
			Category -> "Operating Limits"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the part can handle.",
			Category -> "Operating Limits"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The amount of liquid held in the part at any given time.",
			Category -> "Part Specifications"
		}
	}
}];
