(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Western], {
	Description->"A protocol that verifies the functionality of the Western blot instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "Sample Preparation"
		},
		(*ExperimentWestern qualification protocol*)
		WesternQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,Western],
			Description -> "The western protocol used to interrogate capillary-based Western Instrument performance.",
			Category -> "General"
		},
		(*ExperimentTotalProteinDetection qualification protocol*)
		TotalProteinDetectionQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, TotalProteinDetection],
			Description -> "The TotalProteinDetection protocol used to interrogate capillary-based Western Instrument performance.",
			Category -> "General"
		}
	}
}];
