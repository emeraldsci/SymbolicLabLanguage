(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,FragmentAnalyzer],{
	Description->"A protocol that verifies the functionality of the FragmentAnalyzer instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the prepared plate that contains the samples to be used for the qualification.",
			Category -> "Sample Preparation"
		}
	}
}];
