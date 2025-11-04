(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, Pipetting], {
	Description->"The model for a qualification test to verify the user's ability to use pipettes properly.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PipetteBufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the the buffer that will be used in this Qualification's pipetting steps.",
			Category -> "General"
		},
		PipetteBufferReservoirModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container in which the pipetting buffer is prepared in, prior to pipetting.",
			Category -> "General"
		},
		Pipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,Pipette],
			Description -> "The pipette instruments that will be used to test the user's ability to pipette volumes of a test sample.",
			Category -> "Pipetting Skills"
		},
		PipettesBufferVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0*(Micro*Liter)]..},
			IndexMatching -> Pipettes,
			Description -> "For each member of Pipettes, the volumes that will be pipetted into each container for this Qualification.",
			Category -> "General"
		},
		PipettesPracticeRuns -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			IndexMatching -> Pipettes,
			Description -> "For each member of Pipettes, indicates that the first n values of PipettesBufferVolumes will not be assessed.",
			Category -> "General"
		},
		PipettesTipModel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			IndexMatching -> Pipettes,
			Description -> "For each member of Pipettes, the model of the pipetting tip that will be used for this Qualification.",
			Category -> "General"
		},
		WasteContainerModel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"The model of vessel used to temporarily hold the water sample removed from the weighing container after each pipette test. The water sample in the vessel will be discarded at the end of the training. This is currently used only in MicropipetteP1000 and SerologicalPipettePipetus trainings.",
			Category -> "General"
		}
	}
}]