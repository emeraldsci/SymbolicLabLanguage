(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, WashPlate], {
	Description -> "The group of default settings that should be used when washing a SBS-format 96-well plate robotically.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The samples or containers that the instrument dispenses to and aspirates from during this washing.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The samples or containers that the instrument dispenses to and aspirates from during this washing.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The samples or containers that the instrument dispenses to and aspirates from during this washing.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, PlateWasher],
				Object[Instrument,  PlateWasher]
			],
			Description -> "The instrument designed to dispense, aspirate, and wash liquid contents from input sample containers in 96-well plate format in this unit operation.",
			Category -> "General"
		},
		MethodLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Method, WashPlate]],
			Description -> "Either Custom or the file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing.",
			Category -> "General",
			Migration -> SplitField
		},
		MethodExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Custom],
			Description -> "Either Custom or the file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing.",
			Category -> "General",
			Migration -> SplitField
		},
		WashPlateMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, WashPlate],
			Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing.",
			Category -> "General"
		},
		MethodFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The LHC format method file containing the aspiration and dispensing parameters.",
			Category -> "General",
			Developer -> True
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name of the LHC format method file containing the run parameters for this unit operation.",
			Category -> "General",
			Developer -> True
		},
		BufferLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The solution used to rinse off unbound molecules from the input sample containers.",
			Category -> "General",
			Migration -> SplitField
		},
		BufferString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The solution used to rinse off unbound molecules from the input sample containers.",
			Category -> "General",
			Migration -> SplitField
		},
		BufferLine -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[BufferA, BufferB, BufferC, BufferD],
			Relation -> Null,
			Description -> "The buffer line (Buffer A, B, C, or D) assigned to this unit operation, through which the Buffer is pumped into the plate washer.",
			Category -> "General"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The number of cycles that washing is performed. Each wash cycle first aspirates from, and then dispenses buffer to, the input sample containers.",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of Buffer added to rinse off unbound molecule per wash cycle.",
			Category -> "General"
		},
		Priming -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The boolean indicates whether an initial priming step is performed to minimizing the residual air or buffer in the manifold tubes prior to plate washing.",
			Category -> "General"
		},
		PrimeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The total amount of buffer dispensed through 96-Tube manifold during the priming step.",
			Category -> "Priming"
		},
		AspirateTravelRateInteger -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 5, 1],
			Description -> "The speed at which the plate washer manifold travels down into the wells.",
			Category -> "Aspiration",
			Migration -> SplitField
		},
		AspirateTravelRateReal -> {
			Format -> Single,
			Class -> Real,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The speed at which the plate washer manifold travels down into the wells.",
			Category -> "Aspiration",
			Migration -> SplitField
		},
		AspirateDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The time delay between dispensing and aspiration. When AspirationDelay is Null or 0 Millisecond, aspiration and dispensing occurs simultaneously.",
			Category -> "Aspiration"
		},
		AspirationPositionOffset -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The aspiration coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface.",
			Category -> "Aspiration"
		},
		CrosswiseAspiration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The boolean indicates if a secondary aspiration in a different location within the well is performed immediately after each aspiration in a wash cycle. Default to True.",
			Category -> "Aspiration"
		},
		CrosswiseAspirationPositionOffset -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The crosswise aspiration coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface.",
			Category -> "Aspiration"
		},
		FinalAspiration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The boolean indicates if a final aspiration step is performed to minimizing the residual left in the wells at the end of all wash cycles.",
			Category -> "Aspiration"
		},
		FinalAspirateTravelRateInteger -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 5, 1],
			Description -> "The rate at which the plate washer manifold travels down into the wells during the final aspiration.",
			Category -> "Aspiration",
			Migration -> SplitField
		},
		FinalAspirateTravelRateReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The rate at which the plate washer manifold travels down into the wells during the final aspiration.",
			Category -> "Aspiration",
			Migration -> SplitField
		},
		FinalAspirateDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The time delay between dispensing and the final aspiration. When FinalAspirationDelay is Null or 0 Millisecond, the final aspiration and dispensing occurs simultaneously.",
			Category -> "Aspiration"
		},
		FinalAspirationPositionOffset -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The final aspiration coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface.",
			Category -> "Aspiration"
		},
		DispenseFlowRateInteger -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[3, 11, 1],
			Description -> "The rate at which the fluid is dispensed from the manifold tubes.",
			Category -> "Dispensing",
			Migration -> SplitField
		},
		DispenseFlowRateReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The speed at which the fluid is dispensed from the manifold tubes.",
			Category -> "Dispensing",
			Migration -> SplitField
		},
		DispensePositionOffset -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The dispense coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface.",
			Category -> "Dispensing"
		},
		DispenseVacuumDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Microliter,
			Description -> "The dispensed volume per well after which the vacuum pump is triggered to start normal aspiration.",
			Category -> "Dispensing"
		},
		BottomWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The boolean indicates if an initial dispense/aspirate sequence is added before the first wash cycle where Buffer is dispensed and aspirated from the bottom of the wells.",
			Category -> "Dispensing"
		}
	}
}];
