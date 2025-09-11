(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Analysis, ImageExposure],
	{
		Description -> "Analysis of image data objects that identifies optimally exposed image and calculates suggested exposure time for improperly exposed images. Optimal image is selected from a list of acceptable images satisfying specific statistical measures, including entropy, under/over-exposed pixel fractions. For acceptable bright field images, the best image corresponds to the image with the highest entropy. For fluorescence images, it corresponds to the image with the least amount of over exposed pixels.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			ReferenceImages -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The images analyzed for acceptable exposure times.",
				Category -> "Experimental Results"
			},
			ExposureTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millisecond],
				Units->Millisecond,
				Description -> "For each member of ReferenceImages, the length of time the camera is collecting light from a sample.",
				Category -> "Experimental Results",
				IndexMatching -> ReferenceImages
			},
			InformationEntropies -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Description -> "For each member of ReferenceImages, a measure of the information contained in an image. Images with high InformationEntropies have a large standard deviation in their pixel value distribution.",
				Category -> "Analysis & Reports",
				IndexMatching -> ReferenceImages
			},
			ImageType -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Lane, QPixImagingStrategiesP],
				Description -> "Indicates the type of image based on light source when taking the ReferenceImages. Lane is for data derived from PAGE data.",
				Category -> "Analysis & Reports"
			},
			UnderExposedPixelFractions -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ReferenceImages, the portion of normalized image pixel values in the lower quartile.",
				Category -> "Analysis & Reports",
				IndexMatching -> ReferenceImages
			},
			OverExposedPixelFractions -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0, 1],
				Description -> "For each member of ReferenceImages, the portion of normalized image pixel values above the 95th percentile.",
				Category -> "Analysis & Reports",
				IndexMatching -> ReferenceImages
			},
			DynamicRanges -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> LessP[0],
				Description -> "For each member of ReferenceImages, the logarithmic ratio between the 95th percentile and 5th percentile pixel values.",
				Category -> "Analysis & Reports",
				IndexMatching -> ReferenceImages
			},
			OptimalExposureTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millisecond],
				Units -> Millisecond,
				Description -> "The exposure time of the best image selected from a list of images with acceptable exposure satisfying specific statistical measures, including entropy, under/over-exposed pixel fractions.",
				Category -> "Analysis & Reports"
			},
			SuggestedExposureTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Millisecond],
				Units -> Millisecond,
				Description -> "Estimated exposure time for image acquisition based on analyses of a list of improperly exposed images.",
				Category -> "Analysis & Reports"
			},
			AcceptableImages -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "A list of images deemed acceptable based on statistical measures, including under- and over-exposed pixel fractions, and over all exposure pixel level.",
				Category -> "Analysis & Reports"
			},
			OptimalImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "File representing the best exposed image.",
				Category -> "Analysis & Reports"
			}
		}
	}
];
