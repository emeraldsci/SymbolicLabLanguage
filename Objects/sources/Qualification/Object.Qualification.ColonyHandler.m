(* ::Package:: *)

DefineObjectType[Object[Qualification, ColonyHandler], {
	Description -> "A protocol that verifies the functionality of the colony handler instrument target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ImagingProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticCellPreparation],
			Description -> "The ImageColonies protocol that performs on the target colony handler that tests the imaging module.",
			Category -> "General"
		},
		ImagingSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The template sample mimicking colonies to use in the qualification of imaging module.",
			Category -> "General"
		},
		ImagingSamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, mixes and incubations that will be performed in the order listed to prepare samples for the qualification of imaging module.",
			Category -> "General"
		},
		ImagingSamplePreparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ManualSamplePreparation],
			Description -> "The sample preparation protocol generated as a result of the execution of ImagingSamplePreparationUnitOperations.",
			Category -> "General"
		},
		ImagingStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[QPixImagingStrategiesP],
			Description -> "The imaging capabilities of the instrument this qualification tests. The available options include BrightField imaging, BlueWhite Screening, and Fluorescence imaging.",
			Category -> "Imaging Specifications"
		},
		ImagingChannels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[QPixFluorescenceWavelengthsP, QPixAbsorbanceWavelengthsP, BrightField],
			Description -> "The imaging channels the qualification is set to test.",
			Category -> "Imaging Specifications"
		}
	}
}];