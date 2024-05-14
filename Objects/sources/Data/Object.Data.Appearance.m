(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Appearance], {
	Description->"Image representing the physical appearance of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Method Information --- *)
		ContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "The containers that were imaged to generate this data.",
			Category -> "Method Information",
			Abstract -> True
		},
		Camera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][Data],
			Description -> "The camera used to capture this image.",
			Category -> "Method Information",
			Abstract -> True
		},
		DateAcquired->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date on which the image was acquired.",
			Category->"Method Information"
		},
		Software->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The acquisition software on the instrument used to acquire the images.",
			Category->"Method Information"
		},
		SoftwareVersion->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Indicates the version of the acquisition software on the instrument used to acquire the images.",
			Category->"Method Information"
		},

		(* --- Imaging Specification --- *)
		FieldOfView -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CameraFieldOfViewP,
			Description -> "The horizontal length of the uncropped image.",
			Category -> "Imaging Specifications"
		},
		ImagingDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ImagingDirectionP,
			Description -> "The direction from which the sample image was captured.",
			Category -> "Imaging Specifications"
		},
		IlluminationDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The direction(s) from which the sample was illuminated.",
			Category -> "Imaging Specifications"
		},
		ExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Millisecond,
			Description -> "The length of time for which a camera shutter stayed open while taking this image.",
			Category -> "Imaging Specifications"
		},

		(* --- Data Processing --- *)
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AppearanceTypeP,
			Description -> "Indicates if this data contains images of the ruler used as a scale reference or analyte images of the sample.",
			Category -> "Data Processing",
			Abstract -> True
		},
		RulerData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance][AnalyteData],
			Description -> "A relation to ruler data used as a scale reference for this analyte sample.",
			Category -> "Data Processing"
		},
		AnalyteData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance][RulerData],
			Description -> "A list of all sample images that use this ruler data as a scale refrence.",
			Category -> "Data Processing"
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A cropped image file containing only the sample.",
			Category -> "Data Processing",
			Abstract -> True
		},
		UncroppedImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A raw and unprocessed image file of the sample.",
			Category -> "Data Processing"
		},
		Scale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
			Units -> Pixel/(Centi Meter),
			Description -> "The scale in pixels/distance relating pixels of the image to real world distance.",
			Category -> "Data Processing",
			Abstract -> True
		},

		(* --- Experimental Results --- *)
		Image -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[UncroppedImageFile]}, ImportCloudFile[Field[UncroppedImageFile]]],
			Pattern :> _Image,
			Description -> "Returns the cropped image of the sample.",
			Category -> "Experimental Results",
			Abstract -> True
		},

		(* === DEPRECATED === *)
		(* Replaced by multiple version called IlluminationDirection to match protocol *)
		Illumination -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The direction from which the sample was illuminated.",
			Category -> "General"
		}
	}
}];