(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Training, DeckPlacement], {
	Description -> "A protocol that verifies an operator's ability to put items to designated locations.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description -> "The Sample Preparation sub protocol (script) that tests the user's ability in avoiding stray droplet formation with micro-centrifuge.",
			Category -> "Sample Preparation"
		},
		PreparedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers created by the sample preparation sub protocol for the deck placement module.",
			Category -> "General"
		},
		PreparedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples created by the sample preparation sub protocol for the deck placement module.",
			Category -> "General"
		},
		PreparedContainerImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file of plates with dye samples.",
			Category -> "General"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, LiquidHandler],
				Object[Instrument, LiquidHandler]
			],
			Description -> "The liquid handler instrument used for the deck placement module.",
			Category -> "General"
		}
	}
}];