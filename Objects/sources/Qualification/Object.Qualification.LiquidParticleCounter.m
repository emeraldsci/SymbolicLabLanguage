(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,LiquidParticleCounter], {
	Description->"A protocol that verifies the functionality of the liquid particle counter target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SamplePreparationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The sample preparation primitives used in the Preparatory UnitOperations in of the subprotocol.",
			Category -> "Sample Preparation"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,RoboticSamplePreparation],
				Object[Protocol,ManualSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "The sample manipulation protocol used to prepare antibody samples and standard samples for capillary ELISA experiments.",
			Category -> "Sample Preparation"
		},
		SampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Labels of the sample that goes into the subprotocol.",
			Category -> "Organizational Information"
		},
		BlankSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "Input samples for checking the behaviours of the instrument under a blank sample.",
			Category -> "Analytes"
		},
		IntensityTestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "Input samples for checking the behaviours of the instrument under a blank sample.",
			Category -> "Analytes"
		},
		DilutionTestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "Input samples for testing diluting a series of different samples, current (Dec - 2022) this test is not in use.",
			Category -> "Analytes"
		}
	}
}];
