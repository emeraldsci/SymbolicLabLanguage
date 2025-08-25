(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, ImageSample], {
	Description -> "A detailed set of parameters that describes photographing a sample or container.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The Sample that is to be photographed during this unit operation.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The Sample that is to be photographed during this unit operation.",
			Category -> "General",
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The Sample that is to be photographed during this unit operation.",
			Category -> "General",
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source container that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,PlateImager],
				Model[Instrument, SampleImager],
				Object[Instrument, PlateImager],
				Object[Instrument, SampleImager]
			],
			Description -> "For each member of SampleLink, the instrument used to perform the imaging operation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		AlternateInstruments -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[{Model[Instrument, PlateImager],Model[Instrument, SampleImager]}] | Null)...},
			Description -> "For each member of SampleLink, the other devices that satisfy the input specification. When Null, no devices beyond the Instrument will be considered for use.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ImageContainer -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates whether images will be taken of the whole container as opposed to the samples contained within.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ImagingDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[ImagingDirectionP | All],
			Description -> "For each member of SampleLink, the orientation of the camera with respect to the container being imaged, where All implies both top and side images will be captured.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		IlluminationDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[IlluminationDirectionP | All],
			Description -> "For each member of SampleLink, the source(s) of illumination that will be used for imaging, where All implies all available light sources will be active simultaneously.",
			Category -> "General",
			IndexMatching -> SampleLink
		}
	}
}]
