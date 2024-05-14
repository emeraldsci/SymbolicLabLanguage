(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, HeatSink], {
	Description->"Model information for a passive heat exchanger that dissipates heat into the surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		FinShape ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FinShapeP,
			Description -> "The shape of the fin integrated/attached to the heat sink in the z-direction.",
			Category -> "Dimensions & Positions"
		},
		
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of this model of heat sink in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		
		Dimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The external dimensions of this model of heat sink.",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"},
			Category -> "Dimensions & Positions",
			Abstract -> True
		}
	}
}];
