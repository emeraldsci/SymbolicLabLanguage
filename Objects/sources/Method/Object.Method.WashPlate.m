(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method, WashPlate], {
	Description -> "The group of default settings that should be used when washing a SBS-format 96-well plate with a plate washer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, PlateWasher]],
			Description -> "The compatible plate washer models with this method.",
			Category -> "General"
		},
		AspirateTravelRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RangeP[1, 5, 1]|PlateWasherTravelRateP,
			Description -> "The rate at which the plate washer manifold travels down into the wells.",
			Category -> "Aspiration"
		},
		AspirateDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The time delay between dispensing and aspiration. When AspirationDelay is Null, aspiration and dispensing occurs simultaneously.",
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
			Description -> "The boolean indicates if a secondary aspiration in a different location within the well is performed immediately after each aspiration in a wash cycle.",
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
			Description -> "The boolean indicates if a final aspiration step is performed to minimize the residual volume left in the wells at the end of all wash cycles. There are rate 1-5, with travel rate 1 at 4.1 mm/s, rate 2 at 5.0 mm/s, rate 3 at 7.3 mm/s, rate 4 at 9.4 mm/s (slow down to 1 mm/s before reaching the aspirate height), and rate 5 at 9.4 mm/s (slow down to 2 mm/s before reaching the aspirate height).",
			Category -> "Aspiration"
		},
		FinalAspirateTravelRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RangeP[1, 5, 1]|PlateWasherTravelRateP,
			Description -> "The rate at which the plate washer manifold travels down into the wells during final aspiration.",
			Category -> "Aspiration"
		},
		FinalAspirateDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millisecond],
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
		DispenseFlowRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RangeP[3, 11, 1]|PlateWasherFlowRateP,
			Description -> "The rate at which the fluid is dispensed from the manifold tubes.",
			Category -> "Dispensing"
		},
		DispensePositionings -> {
			Format -> Multiple,
			Class -> {XOffset -> Real, YOffset -> Real, ZOffset -> Real},
			Pattern :> {XOffset -> GreaterEqualP[0 Meter], YOffset -> GreaterEqualP[0 Meter], ZOffset -> GreaterEqualP[0 Meter]},
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
			Description -> "The boolean indicates if an initial dispense/aspirate sequence is added before the first wash cycle where fluid is dispensed and aspirated from the bottom of the wells. The purpose is to create cleaning turbulence. Designed for strongly bound molecules in assays that require vigorous washing.",
			Category -> "Dispensing"
		}
	}
}];
