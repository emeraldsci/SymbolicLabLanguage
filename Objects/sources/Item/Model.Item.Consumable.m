(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Consumable], {
	Description->"A model of a consumable item often obtained from suppliers, such as gloves or task wipes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature that this consumable is rated for.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		Pierceable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this cap can be pierced by an autosampler needle.",
			Category -> "Physical Properties"
		},
		Breathable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether vapor can pass through the seal.",
			Category -> "Physical Properties"
		}
	}
}];
