(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CalibrateDNASynthesizer], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates a DNA Synthesizer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Valves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,30],
			Units -> None,
			Description -> "The valves controlling dispensing lines on the DNA Synthesizer that were calibrated during this maintenance.",
			Category -> "General"
		},
		ValveDensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*(Gram/(Milli*Liter))],
			Units -> Gram/(Liter Milli),
			Description -> "For each member of Valves, the density of the solution dispensed by the valve.",
			Category -> "General",
			IndexMatching->Valves
		},
		DispensePoints ->{
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,6],
			Units -> None,
			Description -> "The number of points on the calibration curve (dispense time vs. volume dispensed) for each valve.",
			Category -> "General"
		},
		DispenseTimes -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{Second..}],
			Units -> Second,
			Description -> "For each member of Valves, the amount of time fluid is released from the valve.",
			Category -> "General",
			IndexMatching->Valves
		},
		NumberOfDispenses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,6],
			Units -> None,
			Description -> "The number of times fluid is dispensed at a dispense point.",
			Category -> "General"
		},
		MinRSquared->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Units -> None,
			Description -> "The minimum R-squared value allowed for a calibration curve in this model Maintenance.",
			Category -> "General"
		},
		BalanceModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The model of balance used to measure the weigh of dispensed reagents during Maintenance.",
			Category -> "General"
		},
		ReagentValves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0,30],
			Units->None,
			Description -> "The valves that require additional bottle hookup prior to starting Maintenance.",
			Category -> "General"
		},
	    PlaceholderValves -> {
	    	Format -> Multiple,
	    	Class -> Integer,
	    	Pattern :> RangeP[0,30],
	    	Units->None,
	    	Description -> "The valves that require placeholder manipulation prior to starting Maintenance.",
	    	Category -> "General"
	    },
		ConnectedReagents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "For each member of ReagentValves, the chemical attached prior to starting Maintenance.",
			Category -> "General",
			IndexMatching -> ReagentValves
		},
		ConnectedReagentVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of chemical needed for each connected reagent.",
			Category -> "General"
		}
	}
}];
