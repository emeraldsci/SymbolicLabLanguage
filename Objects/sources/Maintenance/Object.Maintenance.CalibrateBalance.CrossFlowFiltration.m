(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateBalance, CrossFlowFiltration], {
	Description->"A protocol that calibrates the balances of a cross flow filtration instrument based on prescribed standards.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProgramFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The updated IP address to direct connect to the MicroPulse app through a web browser.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		FeedValidationResults->{
			Format-> Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The calibration weight results of the \"Feed Weighing Balance\" during this maintenance.",
			Category->"Sample Loading"
		},
		DiafiltrationValidationResults->{
			Format-> Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The calibration weight results of the \"Diafiltraiton Weighing Balance\" during this maintenance.",
			Category->"Sample Loading"
		},
		CalibrationWeightFeedPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put CalibrationWeights to the Feed Weighing Balance of the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		CalibrationWeightDiafiltrationPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put CalibrationWeights to the Diafiltration Weighing Balance of the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		ValidationWeightFeedPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put ValidationWeights to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		ValidationWeightDiafiltrationPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put ValidationWeights to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		}
	}
}];
