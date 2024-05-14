

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Data, TLC], {
	Description->"Thin Layer Chromatography (TLC) data used to analyze separation of mixtures by wicking a mobile phase solvent across a stationary phase plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Solvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The solvent model used in the TLC run.",
			Category -> "General"
		},
		PlateType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateBackingP,
			Description -> "Backing material used in the TLC plate.",
			Category -> "General"
		},
		LaneNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The lane index starting from the left most lane of the plate.",
			Category -> "General",
			Abstract -> True
		},
		Brightness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "Software setting for brightness adjustment of the image taken in the darkroom. May be positive or negative.",
			Category -> "General"
		},
		ExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The length of time for which a camera shutter stayed open while taking this image.",
			Category -> "General"
		},
		RelativeAperture -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RelativeApertureP,
			Description -> "The ratio of lens focal length to the diamater of the entrance pupil at the time the image was taken.",
			Category -> "General"
		},
		ISOSensitivity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ISOSensitivityP,
			Description -> "The sensitivity of a camera sensor to light at the time the image was taken.",
			Category -> "General"
		},
		Resolution -> {
			Format -> Single,
			Class -> String,
			Pattern :> ResolutionP,
			Description -> "Resolution of the image file. Must be a string of the form IntegerxInteger.",
			Category -> "General"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Nanometer,
			Description -> "The wavelength of the source of illumination of the instrument used to take the image of the plate.",
			Category -> "General"
		},
		EmissionFilter -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Nanometer, Nanometer},
			Description -> "The emission filter used to take the image of the plate.",
			Category -> "General",
			Headers -> {"Wavelength","Bandpass"}
		},
		Stain -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "The sample chemical or solution used to stain the plate after its been run.",
			Category -> "General"
		},
		StainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time the TLC plate is incubated in the stain after its been run.",
			Category -> "General"
		},
		Intensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LaneImage], Field[InvertIntensity]}, ECL`ImageIntensity[Field[LaneImage], Rotate -> True, InvertIntensity -> Field[InvertIntensity]]],
			Pattern :> CoordinatesP,
			Description -> "Computed pixel intensity in a slice down the length of the lane.",
			Category -> "Experimental Results"
		},
		LaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LaneImageFile]}, ImportCloudFile[Field[LaneImageFile]]],
			Pattern :> _Image,
			Description -> "An image of the lane containing the sample run.",
			Category -> "Experimental Results"
		},
		LaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image ofile of the lane containing the sample run.",
			Category -> "Experimental Results"
		},
		PlateImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PlateImageFile]}, ImportCloudFile[Field[PlateImageFile]]],
			Pattern :> _Image,
			Description -> "An image of the entire TLC plate (including all lines).",
			Category -> "Data Processing"
		},
		PlateImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file of the entire TLC plate (including all lines).",
			Category -> "Data Processing"
		},
		DarkroomImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[DarkroomImageFile]}, ImportCloudFile[Field[DarkroomImageFile]]],
			Pattern :> _Image,
			Description -> "An uncropped image of TLC plates taken in an UV-lamp equiped imaging system.",
			Category -> "Data Processing"
		},
		DarkroomImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An cloudfile containing an uncropped image of TLC plates taken in an UV-lamp equiped imaging system.",
			Category -> "Data Processing"
		},
		InvertIntensity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate image's colors were inverted prior to intensity calculations.",
			Category -> "Data Processing"
		},
		Scale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
			Units -> Pixel/(Centi Meter),
			Description -> "The scale in pixels/unit of the darkroom image.",
			Category -> "Data Processing",
			Abstract -> True
		},
		NeighboringLanes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, TLC][NeighboringLanes],
			Description -> "The samples or ladders that were run on the same plate.",
			Category -> "Experimental Results"
		},
		LanePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list peak-picking analyses conducted on this lane image.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		}
	}
}];
