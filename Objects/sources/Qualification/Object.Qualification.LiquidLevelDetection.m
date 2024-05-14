(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, LiquidLevelDetection], {
	Description->"A protocol that verifies the functionality of the liquid handler target for liquid level detection.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The liquid handler on which the Qualification is run.",
			Category -> "General"
		},
		CarrierPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Headers -> {"Rack","Deck","Position"},
			Description -> "A list of placements used to replace the movable racks on the deck after cleaning.",
			Category -> "Placements",
			Developer -> True
		},
		WashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to wash teaching needles before the Qualification is run.",
			Category -> "General"
		},
		CottonTipApplicators -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The cotton tip applicators used to dry the insides of teaching needles after washing.",
			Category -> "General"
		},
		DiagnosticFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The diagnostic file produced by the instrument software describing the results of this Qualification.",
			Category -> "Experimental Results"
		},
		DeckAndWasteCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "The outcome of the deck and waste clearance check.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Pipettor1000ulTightnessCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "The outcome of the tightness check for the 1000ul channel pipettors.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Pipettor1000ulCapacitiveLLD -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "The outcome of the capacitive liquid level detection test for the 1000ul channel pipettors.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		CopyFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The string that is pasted to a terminal in order to copy the automatically generated file to server with a predictable name.",
			Category -> "Experimental Results",
			Developer -> True
		}
	}
}];
