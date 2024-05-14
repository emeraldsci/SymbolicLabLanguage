

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, Incubate], {
	Description->"The program used to store a batch of containers to be incubated together in a Thermal Incubation experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ContainerBatch -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "List of containers to be incubated together by this program.",
			Category -> "General"
		},
		SampleBatch -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "List of samples to be incubated together by this program.",
			Category -> "General"
		},
		IncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the thermal incubation is performed.",
			Category -> "Incubation"
		},
		IncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Minute,
			Description -> "Amount of time for which the heating or cooling element maintains the IncubationTemperature.",
			Category -> "Incubation"
		},
		MaxIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Minute,
			Description -> "Maximum amount of time for which the heating or cooling element maintains the IncubationTemperature.",
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
		IncubationStartTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time when the incubation was started.",
			Category -> "Incubation",
			Developer -> True
		},
		ThawTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "Actual length of time the sample remained at the incubation temperature before the sample was determined to be thawed.",
			Category -> "Incubation"
		},
		FullyThawed ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MultipleChoiceAnswerP,
			Description -> "For each member of SampleBatch, indicates if the sample appears fully thawed upon visual inspection.",
			Category -> "Experimental Results",
			IndexMatching -> SampleBatch
		},
		AnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "Actual length of time the sample has remained in the heating/cooling instrument after it has been turned off.",
			Category -> "Incubation"
		}
	}
}];
