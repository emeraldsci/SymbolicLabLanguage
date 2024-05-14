(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, SampleImager], {
	Description->"The model for an imager that takes brightfield images of vessels ranging from small conical tubes to large carboys.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Cameras -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "A list of the cameras available for this model of Sample Imager.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Illumination -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The directions from which the imager can illuminate samples.",
			Category -> "General",
			Abstract -> True
		},
		ImageScales -> {
			Format -> Multiple,
			Class -> {FieldOfView -> Expression, Scale -> Real},
			Pattern :> {FieldOfView -> CameraFieldOfViewP, Scale -> GreaterP[0*(Pixel / Centimeter)]},
			Units -> {FieldOfView -> None, Scale -> Pixel / Centimeter},
			Headers -> {
				FieldOfView -> "Field of View",
				Scale -> "Image Scale"
			},
			Description -> "The scale in pixels/centimeter relating pixels of the image to real world distance for the output data of this instrument.",
			Category -> "Data Processing"
		}
	}
}];
