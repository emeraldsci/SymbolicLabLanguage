(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateBalance], {
	Description->"A protocol that calibrates a balance based on prescribed standards.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CalibrationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight],
				Object[Item, CalibrationWeight]
			],
			Description -> "The weights used to calibrate the balance.",
			Category -> "General"
		},
		CalibrationWeightNominalWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Gram],
			Units:>Gram,
			Description -> "The nominal weights used to calibrate the balance.",
			Category -> "General"
		},
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
			IndexMatching -> CalibrationWeights,
			Description -> "For each member of CalibrationWeights, the weight tweezers/forks/handles used to pick up and move the weight to/from the balance.",
			Category -> "General"
		},
		ValidationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight],
				Object[Item, CalibrationWeight]
			],
			Description -> "The weights used to validate the balance calibration.",
			Category -> "General"
		},
		ValidationWeightHandles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeightHandle],
				Model[Item, Tweezer],
				Object[Item, WeightHandle],
				Object[Item, Tweezer]
			],
			IndexMatching -> ValidationWeights,
			Description -> "For each member of ValidationWeights, the weight tweezers/forks/handles used to pick up and move the weight to/from the balance.",
			Category -> "General"
		},
		Validated -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :>BooleanP,
			Description -> "Indicated whether the calibration was successfully validated using a subset of CalibrationWeights.",
			Category -> "Analysis & Reports"
		},
		TareWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight data recorded after the balance was zeroed.",
			Category -> "Experimental Results"
		},
		CalibrationNotebook->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A notebook containing analysis of the data collected by this qualification.",
			Category -> "Analysis & Reports"
		}
	}
}];
