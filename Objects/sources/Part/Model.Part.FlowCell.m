

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, FlowCell], {
	Description -> "Model information a fluid channel transparent for chromatography detectors.",
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
		PathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The distance that the light from the detector must pass through the liquid.",
			Category -> "Part Specifications",
			Abstract -> True
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
