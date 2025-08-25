(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, DissolutionShaft], {
	Description->"Model information for a shaft used to mix media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ShaftLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units-> Millimeter,
			Description -> "The overall length of the stirrer stem from the bottom of the shaft to the top of the shaft. This does not include the length of the Paddle or a Basket attachment.",
			Category -> "Dimensions & Positions"
		},
		ShaftDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0 Millimeter],
			Units-> Millimeter,
			Description -> "The outside diameter of the stirrer stem. This is the diameter of the shaft itself, not including the Paddle or a Basket attachment.",
			Category -> "Dimensions & Positions"
		},
		ShaftType->{
			Format->Single,
			Class->Expression,
			Pattern:>ShaftTypeP,
			Description->"The means by which the shaft is attached to the shaft affector.",
			Category->"Physical Properties"
		}
	}
}];
