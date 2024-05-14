(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,FilterHousing], {
	Description->"A protocol that verifies the functionality of the filter housing target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SamplePreparationProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "Sample Preparation"
		}
	}
}];
