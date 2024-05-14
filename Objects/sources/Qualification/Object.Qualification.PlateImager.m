(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, PlateImager], {
	Description->"A protocol that verifies the functionality of the plate imager target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* Method Information *)
		PreparatoryUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, consolidations, aliquots, mixes and dilutions that will be performed in the order listed to prepare samples for the qualification.",
			Category -> "Sample Preparation"
		},
		IlluminationDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {IlluminationDirectionP..},
			Description -> "For each member of QualificationSamples, the direction(s) from which the sample is illuminated.",
			Category -> "General"
		},
		SamplePreparationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description->"The sample manipulation protocol used to generate the test samples.",
			Category -> "General"
		},
		QualificationContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Containers with known expected results that are run on the target instrument.",
			Category -> "General"
		}
	}
}];
