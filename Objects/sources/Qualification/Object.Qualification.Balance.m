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
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight data recorded after the balance was zeroed.",
			Category -> "Experimental Results"
		},
		TargetContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Object[Instrument]],
			Description -> "The container within which the Target is located.",
			Category -> "General"
		}
	}
}];
