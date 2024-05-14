(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,LiquidHandler], {
	Description->"A protocol that verifies the functionality of the liquid handler target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PipettingAccuracyUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of transfers used to transfer water from a 200uL reservoir into tare weighed 2mL tubes to determine the accuracy of the pipetting channels via gravimetric weighing or ultrasonic reading after the pipetting is finished.",
			Category -> "General"
		},
		PipettingAccuracyProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation],
			Description -> "The sample preparation protocol that transfers water from a 200uL reservoir into tare weighed 2mL tubes to determine the accuracy of the pipetting channels via gravimetric weighing or ultrasonic reading after the pipetting is finished.",
			Category -> "General"
		},

		PipettingLinearityUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of transfers and fluorescence reading operations which linearly dilute fluorescein in Sodium Borate Buffer to qualify the linearity of the pipetting channels.",
			Category -> "General"
		},
		PipettingLinearityProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation],
			Description -> "The sample preparation protocol that transfers and fluorescence reading operations which linearly dilute fluorescein in Sodium Borate Buffer to qualify the linearity of the pipetting channels.",
			Category -> "General"
		},

		MixUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of mixing and absorbance spectroscopy operations that tests the efficiency of mixing by liquid handler pipette channels.",
			Category -> "General"
		},
		MixProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation] | Object[Notebook, Script],
			Description -> "The sample preparation protocol that performs mixing and absorbance spectroscopy that tests the efficiency of mixing by liquid handler pipette channels.",
			Category -> "General"
		},

		PipettingMethodUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of transfers of water and red food dye samples with different pipetting parameters to determine the accuracy of the pipetting channels.",
			Category -> "General"
		},
		PipettingMethodProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation],
			Description -> "The sample preparation protocol that transfers water and red food dye samples with different pipetting parameters to determine the accuracy of the pipetting channels..",
			Category -> "General"
		},

		FilterUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of transfers and air pressure and centrifuge filter operations that separates the silicon carbide from water using the integrated pressure manifold and centrifuge unit of the liquid handler.",
			Category -> "General"
		},
		FilterProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation],
			Description -> "The sample preparation protocol that separates the silicon carbide from water through air pressure filtration or centrifuge filtration using the integrated pressure manifold and centrifuge unit of the liquid handler.",
			Category -> "General"
		},

		MagneticBeadSeparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The series of magnetic bead separation and fluorescence reading operations that tests the recovery of IgG antibodies from Protein G magnetic beads.",
			Category -> "General"
		},
		MagneticBeadSeparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation] | Object[Protocol,RoboticCellPreparation],
			Description -> "The sample preparation protocol that tests the recovery of IgG antibodies from Protein G magnetic beads.",
			Category -> "General"
		},

		(* Sample Preparation *)
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The unit operations used to prepare samples for solid phase extraction, when the target instrument is a Gilson liquid handler.",
			Category -> "Sample Preparation"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The protocol used to prepare samples for solid phase extraction, when the target instrument is a Gilson liquid handler.",
			Category -> "Sample Preparation"
		}
	}
}];
