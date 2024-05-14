(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Aliquot], {
	Description -> "A detailed set of parameters that specifies the information of how to perform an aliquoting or diluting action.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Todo: N-Multiples *)
		Source -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (_String | ObjectP[{Object[Sample], Object[Container]}]) | {(_String | ObjectP[{Object[Sample], Object[Container]}])..},
			Description -> "Source sample to be aliquoted into the destination for this experiment.",
			Category -> "General"
		},
		(* these are fields that match the option patterns exactly *)
		SourceSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description -> "Source sample to be aliquoted into the destination for this experiment. This is the flattened version of Source.",
			Category -> "General",
			Developer -> True
		},
		(* Todo: N-Multiples *)
		SourceLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String | {_String..},
			Description -> "For each member of Source, the label of the sample that is being aliquoted in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		(* Todo: N-Multiples *)
		SourceContainerLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String | {_String..},
			Description -> "For each member of Source, the label of the container of the sample that is being aliquoted in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		AssayBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the sample that will be used to dilute the aliquoted sample, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		ConcentratedBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the concentrated buffer that is diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent), which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		BufferDiluentLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},
		(* Todo: N-Multiples *)
		Amount -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (GreaterP[0 Milliliter] | GreaterP[0 Milligram] | GreaterP[0, 1] | GreaterP[0 Unit, 1 Unit] | All) | {(GreaterP[0 Milliliter] | GreaterP[0 Milligram] | GreaterP[0, 1] | GreaterP[0 Unit, 1 Unit] | All)..},
			Description -> "For each member of Source, the amount of the sample to be aliquoted into ContainerOut.",
			Category -> "General",
			IndexMatching -> Source
		},
		SampleOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Source, the destination sample we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		SampleOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the destination sample we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		SampleOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_, ObjectP[{Model[Container], Object[Container]}] | _String} | Waste,
			Relation -> Null,
			Description -> "For each member of Source, the destination sample we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		ContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of Source, the destination container we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		ContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the destination container we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		ContainerOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_, ObjectP[{Model[Container], Object[Container]}] | _String} | Waste,
			Relation -> Null,
			Description -> "For each member of Source, the destination container we should aliquot into.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> Source
		},
		MixOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if the incubate/centrifuge steps for Manual are done for one sample before advancing to the next (Serial) or all at once to all samples (Parallel).",
			Category -> "General"
		}
	}
}];