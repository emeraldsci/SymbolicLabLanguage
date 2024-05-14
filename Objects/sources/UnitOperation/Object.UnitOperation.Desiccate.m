(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, Desiccate], {
	Description -> "A detailed set of parameters that specifies a desiccation step in a larger protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* input *)
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
			Description -> "The Sample that is to be desiccated during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The Sample that is to be desiccated during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[{Object[Container], Object[Sample]}]..} | {_String..},
			Relation -> Null,
			Description -> "The Sample that is to be desiccated during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The Sample that is to be desiccated during this unit operation.",
			Category -> "General"
		},
		(*Experiment Options*)
		AmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milligram],
			Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
			Category -> "General",
			Migration->SplitField
		},
		AmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> All,
			Description -> "For each member of SampleLink, the mass of each sample to transfer from the sample's container into a desired container before drying via a desiccator (absorbing water molecules from the exposed sample by a chemical desiccant through the shared atmosphere around the sample in a desiccator).",
			Category -> "General",
			Migration->SplitField
		},
		SampleType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Open|Closed,
			Description->"The type of sample that are desiccated by implementing this protocol. Open SampleType leaves the container of the sample open and isolated to actively dry the sample inside whereas Closed SampleType is for long term storage and leaves the containers closed while sharing the desiccator with many containers.",
			Category -> "General"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, DesiccantUnderVacuum, and Vacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			Category -> "General"
		},
		ValvePosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Open|Closed,
			Description -> "The state of the of vacuum valve of the desiccator. Open or Closed respectively indicate if the valve is open or closed to the vacuum pump.",
			Category -> "General"
		},
		Desiccator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument,Desiccator],Object[Instrument,Desiccator]],
			Description -> "The instrument that is used to dry the sample by exposing the sample with its container lid open in a bell jar which includes a chemical desiccant either at atmosphere or vacuum.",
			Category -> "General"
		},
		DesiccantPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Solid, Liquid],
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		Desiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "A hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		DesiccantContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "The container that holds the desiccant in the desiccator during desiccation to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		DesiccantAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 Gram], GreaterEqualP[0 Milliliter]],
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		SampleContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container],Object[Container]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation.",
			Category -> "Drying"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Duration of time that the sample is dried with the lid off via desiccation inside a desiccator.",
			Category->"Drying"
		},
		DesiccationImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[EmeraldCloudFile]],
			Description -> "A link to image files from the desiccant and samples in the desiccator before and after desiccation.",
			Category -> "General"
		},
		(* output object *)
		ContainerOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation.",
			Category -> "General"
		},

		(* label for simulation *)
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
			Description -> "For each member of SampleLink, the label of the SampleContainer that contains the sample during desiccation, which is used for identification elsewhere in sample preparation.",
			Category -> "General"
		},
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the output sample, which is used for identification elsewhere in sample preparation. In this experiment, an output sample is considered a new sample if the output container is different from the input sample's container.",
			Category -> "General"
		},
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the ContainerOut container that contains the output sample, which is used for identification elsewhere in sample preparation.",
			Category -> "General"
		},
		SamplesOutStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the non-default condition under which the desiccated sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration->SplitField
		},
		SamplesOutStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the non-default condition under which the desiccated sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration->SplitField
		}
	}
}]







