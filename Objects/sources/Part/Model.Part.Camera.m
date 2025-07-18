(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Camera], {
	Description->"A model of a camera used by instruments for taking images of samples and containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TargetSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CameraCategoryP,
			Description -> "The approximate size of the items which this model of camera is intended to image.",
			Category ->"Part Specifications"
		},
		MinHeightOfTarget -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Minimum height (z-dimensions) of the imaged item this model camera can take images.",
			Category ->"Part Specifications"
		},
		MaxHeightOfTarget ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Maximum height (z-dimensions) of the imaged item this model camera can take images.",
			Category ->"Part Specifications"
		},
		ImageScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Pixel / Centimeter)],
			Units -> Pixel / Centimeter,
			Description -> "For cameras configured with fixed focal length, the scale in pixels/centimeter relating pixels of the camera's output image to physical distance at the camera's focal length.",
			Category -> "Data Processing"
		},
		SensorDimensions -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Meter], GreaterEqualP[0*Meter]},
			Units ->{Millimeter, Millimeter},
			Description -> "The physical dimensions of this camera model's imaging sensor.",
			Category -> "Data Processing",
			Headers -> {"X Dimension (Width)", "Y Dimension (Height)"}
		},
		ImagePixelDimensions -> {
			Format -> Single,
			Class -> {Integer, Integer},
			Pattern :> {GreaterEqualP[0*Pixel],GreaterEqualP[0*Pixel]},
			Units ->{Pixel,Pixel},
			Description -> "The pixel dimensions of the images output by this camera as configured.",
			Category -> "Data Processing",
			Headers -> {"X Dimension (Width)", "Y Dimension (Height)"}
		},
		StreamKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The stream key GoPros use to access streaming server.",
			Category -> "Data Processing"
		}
	}
}];
