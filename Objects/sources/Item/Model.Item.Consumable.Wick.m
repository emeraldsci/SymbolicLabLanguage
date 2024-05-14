(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Consumable, Wick], {
	Description->"A model for a consumable wick rated for a steady rate of burn.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BurnTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units-> Minute,
			Description -> "The total length of time for which the wick is rated to burn.",
			Category -> "Model Information"
		},
		WickLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of a full unburned wick.",
			Category -> "Model Information"
		}
	}
}];
