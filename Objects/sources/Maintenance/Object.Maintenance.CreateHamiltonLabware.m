(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CreateHamiltonLabware], {
	Description->"A protocol that generates the labware definitions for containers used on Hamilton liquid handlers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ParameterizationModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of Containers, the model of the container that this maintenance is parameterizing.",
			Category -> "Qualifications & Maintenance",
			IndexMatching -> Containers,
			Abstract -> True
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container],Object[Container]],
			Description -> "The specific container vessels that this maintenance is parameterizing.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		WellLabwareDefinitions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Containers, the filename of the labware definition for the container if the container is a vessel or the well if the container is plate.",
			Category -> "Qualifications & Maintenance",
			IndexMatching -> Containers
		},
		RackLabwareDefinitions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Containers, the filename of the labware definition for the rack or plate.",
			Category -> "Qualifications & Maintenance",
			IndexMatching -> Containers
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument,LiquidHandler],Object[Instrument, LiquidHandler]],
			Description -> "The liquid handler instrument on which the maintenance created and tested the labware.",
			Category -> "Qualifications & Maintenance"
		},
		CommitMessage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The contents of the commit command used to upload the newly created labware to the Hamilton repository.",
			Category -> "Qualifications & Maintenance"
		},
		MeasuredXPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The measured x position of the channel probe after the operator has moved the probe to be 1mm over the center of the well bottom.",
			Category -> "Container Specifications",
			Developer -> True
		},
		MeasuredYPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The measured y position of the channel probe after the operator has moved the probe to be 1mm over the center of the well bottom.",
			Category -> "Container Specifications",
			Developer -> True
		},
		MeasuredZPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The measured z position of the channel probe after the operator has moved the probe to be 1mm over the center of the well bottom.",
			Category -> "Container Specifications",
			Developer -> True
		},
		WellTypeFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Containers, the path of the well type (.ctr) file to select during the process of creating new labware on Hamilton software.",
			Category -> "Container Specifications",
			IndexMatching -> Containers,
			Developer -> True
		}
	}
}];
