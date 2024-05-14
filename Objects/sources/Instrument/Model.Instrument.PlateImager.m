(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PlateImager], {
	Description->"The model for an automated imager that takes brightfield images of samples in SBS format plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Cameras -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "A list of the cameras available for this model of Plate Imager.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Ruler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "A ruler used to determine the scale of images taken by this imager.",
			Category -> "Instrument Specifications",
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
		},
		Illumination -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The directions from which the imager can illuminate samples.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},

		CameraTravelSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Minute],
			Units -> Millimeter/Minute,
			Description -> "The speed at which the camera arm travels when moving between wells.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		ImagingInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum amount of time between each imaging that allows for the both movement of the camera arm to the next positions and camera focusing.",
			Category -> "Instrument Specifications",
			Developer->True
		}

	}
}];
