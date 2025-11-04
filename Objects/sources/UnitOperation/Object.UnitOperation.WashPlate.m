(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, WashPlate], {
	Description -> "The group of default settings that should be used when washing a SBS-format 96-well plate robotically.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, PlateWasher],
				Object[Instrument,  PlateWasher]
			],
			Description -> "The plate washer used to wash the input plate in this unit operation.",
			Category -> "General"
		},
		MethodLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Method, WashPlate]],
			Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing.",
			Category -> "General",
			Migration -> SplitField
		},
		MethodExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Custom],
			Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing.",
			Category -> "General",
			Migration -> SplitField
		},
		BufferLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The solution used to rinse off unbound molecules from the input plate.",
			Category -> "General",
			Migration -> SplitField
		},
		BufferString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The solution used to rinse off unbound molecules from the input plate.",
			Category -> "General",
			Migration -> SplitField
		},
		BufferExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[Object[Sample], Model[Sample]],
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The solution used to rinse off unbound molecules from the input plate.",
			Category -> "General",
			Migration -> SplitField
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The number of cycles that washing is performed. Each wash cycle first aspirates from, and then dispenses buffer to, the input plate.",
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
		PrimeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of liquid needed to flush all the tubing prior to its use.",
			Category -> "Priming"
		},
		AspirateTravelRateInteger -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 5, 1],
			Description -> "The rate at which the plate washer manifold travels down into the wells.",
			Category -> "Aspiration",
			Migration -> SplitField
		},
		AspirateTravelRateExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateWasherTravelRateP,
			Description -> "The rate at which the plate washer manifold travels down into the wells.",
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
		AspiratePositionings -> {
			Format -> Multiple,
			Class -> {XOffset -> Real, YOffset -> Real, ZOffset -> Real},
			Pattern :> {XOffset -> GreaterEqualP[0 Meter], YOffset -> GreaterEqualP[0 Meter], ZOffset -> GreaterEqualP[0 Meter]},
			Units -> {XOffset -> Meter, YOffset -> Meter, ZOffset -> Meter},
			Description -> "The aspiration coordinates, where the X/Y offsets represent the horizontal distance from the center of the well (with leftward positions as negative values), while the Z offset specifies the vertical distance above the carrier surface.",
			Headers -> {XOffset -> "XOffset", YOffset -> "YOffset", ZOffset -> "ZOffset"},
			Category -> "Aspiration"
		},
		CrosswiseAspiration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The boolean indicates if a secondary aspiration in a different location within the well is performed immediately after each aspiration in a wash cycle. Default to True.",
			Category -> "Aspiration"
		},
		CrosswiseAspiratePositionings -> {
			Format -> Multiple,
			Class -> {XOffset -> Real, YOffset -> Real, ZOffset -> Real},
			Pattern :> {XOffset -> GreaterEqualP[0 Meter], YOffset -> GreaterEqualP[0 Meter], ZOffset -> GreaterEqualP[0 Meter]},
			Units -> {XOffset -> Meter, YOffset -> Meter, ZOffset -> Meter},
			Description -> "The secondary aspiration coordinates, where the X/Y offsets represent the horizontal distance from the center of the well (with leftward positions as negative values), while the Z offset specifies the vertical distance above the carrier surface.",
			Headers -> {XOffset -> "XOffset", YOffset -> "YOffset", ZOffset -> "ZOffset"},
			Category -> "Aspiration"
		},
		FinalAspirate -> {
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
		FinalAspirateTravelRateExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateWasherTravelRateP,
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
		FinalAspiratePositionings -> {
			Format -> Multiple,
			Class -> {XOffset -> Real, YOffset -> Real, ZOffset -> Real},
			Pattern :> {XOffset -> GreaterEqualP[0 Meter], YOffset -> GreaterEqualP[0 Meter], ZOffset -> GreaterEqualP[0 Meter]},
			Units -> {XOffset -> Meter, YOffset -> Meter, ZOffset -> Meter},
			Description -> "The final aspiration coordinates, where the X/Y offsets represent the horizontal distance from the center of the well (with leftward positions as negative values), while the Z offset specifies the vertical distance above the carrier surface.",
			Headers -> {XOffset -> "XOffset", YOffset -> "YOffset", ZOffset -> "ZOffset"},
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
		DispenseFlowRateExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateWasherFlowRateP,
			Description -> "The rate at which the fluid is dispensed from the manifold tubes.",
			Category -> "Dispensing",
			Migration -> SplitField
		},
		DispensePositionings -> {
			Format -> Multiple,
			Class -> {XOffset -> Real, YOffset -> Real, ZOffset -> Real},
			Pattern :> {XOffset -> GreaterEqualP[0 Meter], YOffset->GreaterEqualP[0 Meter], ZOffset -> GreaterEqualP[0 Meter]},
			Units -> {XOffset -> Meter, YOffset -> Meter, ZOffset -> Meter},
			Description -> "The dispensing coordinates, where the X/Y offsets represent the horizontal distance from the center of the well (with leftward positions as negative values), while the Z offset specifies the vertical distance above the carrier surface.",
			Headers -> {XOffset -> "XOffset", YOffset -> "YOffset", ZOffset -> "ZOffset"},
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
