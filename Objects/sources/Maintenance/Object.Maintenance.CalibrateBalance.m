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
		},
		CoverWrench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item], Model[Item]],
			Description -> "The wrench used to remove the button cover before maintenance, and reinstall after maintenance is done.",
			Category -> "General"
		},
		ButtonCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :>BooleanP,
			Description -> "Indicates if the balance that is being calibrated has a button cover on it that prevents operator from accessing touchscreen and buttons.",
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
