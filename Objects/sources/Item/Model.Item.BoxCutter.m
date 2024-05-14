(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, BoxCutter], {
	Description->"Model information for a tool with a blade used to cut through soft materials.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BladeMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the cutting edge of the blade.",
			Category -> "Physical Properties"
		},
		CasingMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the outer casing which houses the blade.",
			Category -> "Physical Properties"
		},
		ReplaceableBlade -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the box cutter has a replaceable blade.",
			Category -> "Physical Properties"
		},
		CutterWidth-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall width of the box cutter.",
			Category -> "Dimensions & Positions"
		},
		CutterLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the box cutter with the blade retracted.",
			Category -> "Dimensions & Positions"
		}
	}
}];
