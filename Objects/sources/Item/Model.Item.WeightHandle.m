(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, WeightHandle], {
	Description->"Model information for weight forks or handles that are made of clean room suitable materials and allow professional weight handling and balance testing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CalibrationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight][WeightHandle]
			],
			Description -> "The calibration weights for which this weight handle is appropriate.",
			Category -> "Model Information"
		}
	}
}];
