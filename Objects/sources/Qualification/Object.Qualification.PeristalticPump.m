(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,PeristalticPump], {
	Description->"A protocol that verifies the functionality of the peristaltic pump target.",
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
		VolumeDifference -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The percent volume difference between the sample before and after the filtration.",
			Category -> "Experimental Results"
		}
	}
}];
