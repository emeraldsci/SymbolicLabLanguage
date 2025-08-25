(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, MeasureWeight], {
	Description -> "A detailed set of parameters that describes measuring the weight of a sample.",
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
				Object[Container],
				Object[Item],
				Model[Item]
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
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Balance],
				Model[Instrument, Balance]
			],
			Description -> "For each member of SampleLink, indicates the model or object instrument balance to be used for the weighing.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		TransferContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Flatten[Join[{ECL`MeasureWeightContainerTypes,ECL`MeasureWeightModelContainerTypes}]],
			Description -> "For each member of SampleLink, indicates if the sample should be transferred to a new container for weighing. Note that if a TransferContainer is specified, the sample will stay in that new container and will not be transferred back to the original container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CalibrateContainer -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the TareWeight of the container will be measured instead of the weight of the sample. If True, the weight of any sample in the container must be known, unless the container is empty.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		InSitu -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the protocol should run the experiment on the SamplesIn leaving them in their current location and state rather than moving them back and forth from storage or their previous location in a parent protocol.",
			Category -> "General"
		}
	}
}]
