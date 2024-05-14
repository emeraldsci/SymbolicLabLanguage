(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Consumable, Blade], {
	Description->"A model for a consumable razer blade.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BladeWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall width of the blade.",
			Category -> "Physical Properties"
		},
		BladeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the blade.",
			Category -> "Physical Properties"
		},
		BladeMaterial-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the cutting edge of the blade.",
			Category -> "Physical Properties"
		}
	}
}];
