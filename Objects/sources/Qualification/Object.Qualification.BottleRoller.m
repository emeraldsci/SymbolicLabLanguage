(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,BottleRoller], {
	Description->"A protocol that verifies the functionality of the bottle roller target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		(* Method Information *)
		Tachometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to measure the rotation speed of the bottle roller.",
			Category -> "General",
			Abstract -> True
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "General"
		},
		(* Experimental Results *)
		RotationRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The rotational speed measurements of the main shaft in the bottle roller using the Tachometer.",
			Category -> "Experimental Results",
			Developer -> True
		},
		RotationRateDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[RPM],
			Description -> "The statistical distribution of the measured rotation rate.",
			Category -> "Experimental Results"
		},
		FullyDissolved ->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if all components in the solution appear fully dissolved by visual inspection.",
			Category -> "Experimental Results"
		}

	}
}];
