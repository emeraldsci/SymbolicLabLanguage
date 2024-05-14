(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Microwave], {
	Description->"The model for an instrument that heats through microwave radiation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Rotating -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not the microwave has a rotating plate during operation.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the microwave.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
