(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Dilute], {
	Description -> "A detailed set of parameters that specifies the information of how to dilute samples in a solvent.",
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
			Description -> "The samples that are being diluted.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being diluted.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		AmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit],
			Description -> "For each member of SampleLink, the amount of a sample that should be diluted with a diluent.",
			Category -> "Method Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		AmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> All,
			Description -> "For each member of SampleLink, the amount of a sample that should be diluted with a diluent.",
			Category -> "Method Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		TotalVolume -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Description -> "For each member of SampleLink, the desired total volume of the sample plus diluent.",
			Category -> "Method Information",
			Abstract -> True,
			IndexMatching -> SampleLink
		},
		InitialVolume -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Description -> "For each member of SampleLink, the amount of liquid that goes into the initial container, prior to any potential transfers to a new container.",
			Category -> "Method Information",
			Abstract -> True,
			IndexMatching -> SampleLink
		},
		ContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]|Object[Container],
			Description -> "For each member of SampleLink, the desired type of container that should be used to prepare and house the diluted samples, with indices indicating grouping of samples in the same plates, if desired.",
			Category->"Method Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		ContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the desired type of container that should be used to prepare and house the diluted samples, with indices indicating grouping of samples in the same plates, if desired.",
			Category->"Method Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		ContainerOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_, ObjectP[{Model[Container], Object[Container]}] | _String} | Waste,
			Relation -> Null,
			Description -> "For each member of SampleLink, the desired type of container that should be used to prepare and house the diluted samples, with indices indicating grouping of samples in the same plates, if desired.",
			Category -> "Method Information",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		DiluentLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the sample that should be added to the input sample, where the volume of this sample added is the TotalVolume option - the current sample volume.",
			Category ->  "Method Information",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		DiluentString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the sample that should be added to the input sample, where the volume of this sample added is the TotalVolume option - the current sample volume.",
			Category ->  "Method Information",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		DiluentLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the diluent that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ConcentratedBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the concentrated buffer that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		BufferDiluentLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the buffer diluent that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		NumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"For each member of SampleLink, the number of times the sample is mixed for discrete mixing processes such as Pipette or Invert.",
			IndexMatching->SampleLink,
			Category->"General"
		},
		MixOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description ->"Indicates if mixing/incubating are done for one sample after addition of liquid before advancing to the next (Serial) or all at once after liquid is added to all samples (Parallel).",
			Category -> "General"
		}
	}
}];