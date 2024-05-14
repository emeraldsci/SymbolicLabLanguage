(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, PlateSealRoller], {
	Description->"Model information for a tool used to roll on plate seals on to plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		RollerMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the rolling part of the plate roller.",
			Category -> "Physical Properties"
		},
		HandleMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the plate roller handle.",
			Category -> "Physical Properties"
		},
		RollerLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the plate roller.",
			Category -> "Dimensions & Positions"
		},
		RollerDiameter-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The roller width of the plate roller.",
			Category -> "Dimensions & Positions"
		}
	}
}];
