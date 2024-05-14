(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, CalibrationDistanceBlock], {
	Description->"A reference block of known size and shape used for calibrating accurate distance measuring instruments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PreciseDimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Millimeter],GreaterEqualP[0*Millimeter],GreaterEqualP[0*Millimeter]},
			Units ->{Millimeter,Millimeter,Millimeter},
			Description -> "The exact dimensions of this specific block, measured to a precision greater than the model's AllowedSizeTolerance.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"},
			Abstract -> True
		}
	}
}];