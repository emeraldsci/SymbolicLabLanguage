(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Balance], {
	Description->"A protocol that verifies the functionality of the balance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		WeightHandles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeightHandle],
				Model[Item, Tweezer],
				Object[Item, WeightHandle],
				Object[Item, Tweezer]
			],
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, the weight tweezers/forks/handles used to pick up and move the weight to/from the balance.",
			Category -> "General"
		},
		TareWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight data recorded with nothing on the balance.",
			Category -> "Experimental Results"
		},
		TargetContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Object[Instrument]],
			Description -> "The container within which the Target is located.",
			Category -> "General"
		},
		WeightStabilityDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and measured.",
			Category -> "General"
		},
		MaxWeightVariation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milligram],
			Units -> Milligram,
			Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and measured.",
			Category -> "General"
		}
	}
}];
