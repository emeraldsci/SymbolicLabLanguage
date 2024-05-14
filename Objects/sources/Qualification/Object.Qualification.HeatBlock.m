(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,HeatBlock], {
	Description->"A protocol that verifies the functionality of the heat block target.",
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
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :>TemperatureP,
			Units -> Celsius,
			Description -> "The temperatures at which the Target instrument is qualified.",
			Category -> "General"
		}
	}
}];
