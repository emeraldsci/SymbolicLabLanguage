(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, MeasureVolume], {
	Description -> "A detailed set of parameters that describes measuring the volume of a sample.",
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
			Description -> "The Sample that is to be weighed during this unit operation.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The Sample that is to be weighed during this unit operation.",
			Category -> "General",
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The Sample that is to be weighed during this unit operation.",
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
		ErrorTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The acceptable variance in raw liquid level measurements. Readings above this threshold will be re-taken if possible, and not used to update sample volumes.",
			Category -> "General",
			Developer -> True
		},
		Method -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> VolumeMeasurementMethodP,
			Description -> "For each member of SampleLink, indicates the preferred method by which the samples' volumes will be calculated.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		MeasureDensity -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the provided samples will have their density measured prior to volume measurement.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		MeasurementVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of the liquid that will be used for density measurement.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		RecoupSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the transferred liquid used for density measurement will be recouped or transferred back into the original container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		InSitu -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the protocol should run the experiment on the SamplesIn leaving them in their current location and state rather than moving them back and forth from storage or their previous location in a parent protocol.",
			Category -> "General"
		},
		StorageMeasurements -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this protocol is being enqueued in order to measure the volume of samples before storage.",
			Category -> "General",
			Developer -> True
		}
	}
}]