(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibrateDNASynthesizer], {
	Description->"A protocol that calibrates a DNA Synthesizer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	(*---Method Information---*)
		Valves -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Valves]],
			Pattern :> RangeP[1,30],
			Description -> "The valves controlling dispensing lines on the DNA Synthesizer that were calibrated during this maintenance.",
			Category -> "General"
		},
		Dispenses -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,6],
			Units -> None,
			Description -> "The dispenses used at each calibration point.",
			Category -> "General"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance used during the calibration.",
			Category -> "General"
		},
	(*---Sensor Data---*)
		CalibrationWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "The weight of the DNA Synthesizer calibration bottle, measured at each point in the calibration.",
			Category -> "Sensor Information"
		},
		InitialPurgePressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "The pressure of the argon gas connected to the synthesizer, measured at the start of the protocol.",
			Category -> "Sensor Information"
		},
	(*---Developer---*)
		CalibrationScriptPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the AutoIt script used during calibration.",
			Category -> "General",
			Developer->True
		},
		CalibrationScriptFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing the AutoIt script used to run the calibration.",
			Category -> "General",
			Developer->True
		},
		RecalibrationScriptPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the AutoIt script used during re-calibration (if performed).",
			Category -> "General",
			Developer->True
		},
		RecalibrationScriptFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing the AutoIt script used to run the re-calibration (if performed).",
			Category -> "General",
			Developer->True
		},
		CalibrationFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the file containing the calibration data.",
			Category -> "General",
			Developer->True
		},
		CalibrationFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing the final calibration data.",
			Category -> "General",
			Developer->True
		},
		BottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sample]| Model[Sample]| Object[Container] | Model[Container], Null},
			Description -> "A list of deck placements used to place reagent bottles onto the instrument.",
			Category -> "Placements",
			Developer->True,
			Headers -> {"Reagent","Placement"}
		},
		PlaceholderBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Model[Container], Null},
			Description -> "A list of deck placements used to place the placeholder bottles on the instrument in between protocols and Maintenances.",
			Category -> "Placements",
			Developer->True,
			Headers -> {"Placeholder","Placement"}
		},
	    PlaceholderPhosphoramiditePlacements -> {
	    	Format -> Multiple,
	    	Class -> {Link, Expression},
	    	Pattern :> {_Link, {LocationPositionP..}},
	    	Relation -> {Object[Container], Null},
	    	Description -> "A list of deck placements used to place the phosphoramidite vessel placeholders on the instrument.",
	    	Category -> "Placements",
	    	Developer -> True,
	    	Headers -> {"Placeholder","Placement"}
	    },
	    CalibrationBottle -> {
	    	Format -> Single,
	    	Class -> Link,
	    	Pattern :> _Link,
	    	Relation -> Alternatives[Model[Container, Vessel],Object[Container, Vessel]],
	    	Description -> "The bottle used to collect liquid during calibration.",
	    	Category -> "Instrument Specifications",
	    	Developer -> True
	    },
	    PlaceholderPrepManipulation -> {
	    	Format -> Single,
	    	Class -> Link,
	    	Pattern :> _Link,
	    	Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
	    	Description -> "The set of instructions specifying the transfers of synthesizer wash solution to the placeholder bottles.",
	    	Category -> "General",
	    	Developer->True
	    },
		PlaceholderPrepPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "The set of instructions specifying the transfers of synthesizer wash solution to the placeholder bottles.",
			Category -> "General",
			Developer->True
		},
	(*---Maintenance Results---*)
		RSquaredValues -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "For each member of Valves, the calculated R-squared value from a linear fit of the calibration curve (dispense time vs. volume dispensed).",
			Category -> "Experimental Results",
			IndexMatching->Valves
		},
		Intercepts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _Real,
			Units -> None,
			Description -> "For each member of Valves, the calculated y-intercept from a linear fit of the calibration curve (dispense time vs. volume dispensed).",
			Category -> "Experimental Results",
			IndexMatching->Valves
		},
		Slopes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _Real,
			Units -> None,
			Description -> "For each member of Valves, the calculated slope from a linear fit of the calibration curve (dispense time vs. volume dispensed).",
			Category -> "Experimental Results",
			IndexMatching->Valves
		},
		UncalibratedValves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1, 30],
			Units -> None,
			Description -> "The valves whose calibration data from this Maintenance did not meet the MinRSquared of the Model Instrument.",
			Category -> "Experimental Results"
		},
		TaredWeights -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{Gram..}],
			Units -> Gram,
			Description -> "For each member of Valves, the weight dispensed.",
			Category -> "Experimental Results",
			IndexMatching->Valves
		}
	}
}];
