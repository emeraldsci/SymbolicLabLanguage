(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Consumable, Sandpaper], {
	Description->"A model for a consumable sandpaper used to polish rough surfaces.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Grit -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The FEPA category indicating the roughness of this sandpaper model. A higher number indicates a smoother sandpaper and a lower number indicates a rougher sandpaper.",
			Category -> "Physical Properties"
		}
	}
}];
