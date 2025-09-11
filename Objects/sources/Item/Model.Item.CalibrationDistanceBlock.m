(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item, CalibrationDistanceBlock], {
	Description->"A model of reference block of known size and shape used for calibrating accurate distance measuring instruments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AllowedSizeTolerance  -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Millimeter],GreaterEqualP[0*Millimeter],GreaterEqualP[0*Millimeter]},
			Units -> {Millimeter,Millimeter,Millimeter},
			Description -> "The maximum permissible error (+/-) for the dimensions of this object, in each of 3 spatial dimensions.",
			Category -> "Physical Properties",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the weight is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Shape3DFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The design file that describes the 3D shape of this calibration block.",
			Category -> "Physical Properties"
		}
	}
}];