(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Evaporator], {
	Description->"A protocol that verifies the functionality of the evaporator target.",
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
		},
		EvaporationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Hour],
			Units -> Hour,
			Description -> "The time period that the qualification samples are subjected to drying conditions by the target.",
			Category -> "Qualification Parameters"
		},
		EvaporationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature that the qualification samples are subjected when being dried by the target.",
			Category->"Qualification Parameters"
		}
	}
}];
