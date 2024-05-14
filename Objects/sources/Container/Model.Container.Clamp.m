

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Clamp], {
	Description->"A model of a container that can attach to a rod and hold various objects.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "The minimum diameter an object can be (on any axis) to be held by this clamp.",
			Category -> "Container Specifications"
		},
		MaxDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "The maximum diameter an object can be (on any axis) to be held by this clamp.",
			Category -> "Container Specifications"
		},
		MaxRodDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "The maximum rod diameter this clamp can attach to.",
			Category -> "Container Specifications"
		}
	}
}];