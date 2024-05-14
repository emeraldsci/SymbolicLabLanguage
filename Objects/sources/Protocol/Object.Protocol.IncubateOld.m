(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, IncubateOld], {
	Description->"A protocol to perform thermal incubation of a sample using a heating or cooling device.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ThermalIncubator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform thermal incubation in this protocol.",
			Category -> "Incubation"
		},
		MinAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The minimum length of time the sample is to remain in the heating/cooling instrument after it has been turned off.",
			Category -> "Incubation"
		},
		PostMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is mixed after Thermal Incubation.",
			Category -> "Workup"
		},
		MixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The mixing protocols that will be executed after incubation.",
			Category -> "Workup"
		},
		PostCentrifuge -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is centrifuged after Thermal Incubation.",
			Category -> "Workup"
		},
		CentrifugeProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,Centrifuge],
			Description -> "The centrifuge protocol that will be executed after thermal incubation.",
			Category -> "Workup"
		},
		IncubatePrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "List of programs containing the containers to be incubated together that used this program.",
			Category -> "Workup",			
			Developer -> True
		},
		AnnealingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "Actual length of time the sample has remained in the heating/cooling instrument after it has been turned off.",
			Category -> "Experimental Results"
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The total amount of time the sample is to remain in the heating/cooling instrument.",
			Category -> "Incubation",
			Developer -> True
		},
		CurrentTemperature -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Measured heater/cooler temperature at the beginning on the incubation.",
			Category -> "Incubation",
			Developer -> True
		},
		FullyThawed ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MultipleChoiceAnswerP,
			Description -> "For each member of SamplesIn, indicates if the sample appears fully thawed upon visual inspection.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		}
	}
}];
