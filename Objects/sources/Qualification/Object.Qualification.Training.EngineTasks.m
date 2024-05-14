(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,EngineTasks], {
	Description -> "A qualification object to test the user's ability to perform each type of Engine task.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

	GatheredWater -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample]
		],
		Description -> "The water that the operator resource pick for the training.",
		Category -> "General"
	},
	GatheredDye -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample]
		],
		Description -> "The food dye sample that the operator resource pick for the training.",
		Category -> "General"
	},
	PipetteTips -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Item],
			Model[Item]
		],
		Description -> "The serological pipet tips used with the pipetus for the sample transfers.",
		Category -> "General"
	},
	PreparatoryContainer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Container,Vessel],
			Model[Container,Vessel]
		],
		Description -> "The 50 mL tube used for mixing samples.",
		Category -> "General"
	},
	Pipette -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Instrument],
			Model[Instrument]
		],
		Description -> "The pipetus for the sample transfers.",
		Category -> "General"
	},
	TransferBench -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Container,Bench],
			Model[Container,Bench]
		],
		Description -> "The bench for the sample transfers.",
		Category -> "General"
	},
	GuessedVolume -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0 Milliliter],
		Units -> Milliliter,
		Relation -> Null,
		Description -> "The approximate volume of the mixed sample guessed by an operator during the quantity entry task.",
		Category -> "General"
	},
	ScannedContainer -> {
		Format -> Single,
		Class -> String,
		Pattern :> _String,
		Relation -> Null,
		Description -> "The container that an operator scanned during the text entry task.",
		Category -> "General"
	},
	ContainerImage -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[EmeraldCloudFile],
		Description -> "An image of container that has sample in it, and the cap has a sticker.",
		Category -> "General"
	},
	OperatorResponse -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> MultipleChoiceAnswerP,
		Description -> "An operator's response regarding whether a source dye sample has enough sample to begin the qualification.",
		Category -> "General"
	}
  }
}];