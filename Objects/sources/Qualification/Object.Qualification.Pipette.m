(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Pipette], {
	Description->"A protocol that verifies the functionality of the pipette target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample describing the liquid that will be used in this Qualification to test the linearity of the pipettors.",
			Category -> "General"
		},
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The model of the pipette tips used for this Qualification.",
			Category -> "General"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to measure the weight of the containers.",
			Category -> "General"
		},
		TransferContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "Containers which buffer will be pipetted into.",
			Category -> "General"
		},
		BufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*(Micro*Liter)],
			Units -> Microliter,
			Description -> "The volumes that will be pipetted into each container for this Qualification.",
			Category -> "General"
		},
		PipetteParameters -> {
			Format->Multiple,
			Class->{
				Container->Link,
				Volume->Real
			},
			Pattern:>{
				Container->_Link,
				Volume->VolumeP
			},
			Relation->{
				Container->Object[Container]|Object[Item],
				Volume->Null
			},
			Units->{
				Container->None,
				Volume->Microliter
			},
			Description->"Specifies how samples should be pipetted in this qualification.",
			Category -> "General"
		},
		RequestedPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Pipette],
			Description -> "The pipettes that are due for qualification which may be tested in this qualification.",
			Category -> "General"
		},
		QualifiedPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Pipette],
			Description -> "The pipettes that are tested in this qualification.",
			Category -> "General"
		},
		WeightStabilityDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and captured when measuring the weight of the samples of interest.",
			Category -> "General"
		},
		MaxWeightVariations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milligram],
			Units -> Milligram,
			Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and captured when measuring the weight of the samples of interest.",
			Category -> "General"
		},
		TareWeightStabilityDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and captured when measuring the weight of the empty balance and containers.",
			Category -> "General"
		},
		MaxTareWeightVariations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milligram],
			Units -> Milligram,
			Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and captured when measuring the weight of the empty balance and containers.",
			Category -> "General"
		}
	}
}];
