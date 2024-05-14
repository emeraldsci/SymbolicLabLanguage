(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, GCColumnWafer], {
	Description->"A model for a ceramic wafer used to pre-score GC columns during column trimming.",
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
		}
	}
}];
