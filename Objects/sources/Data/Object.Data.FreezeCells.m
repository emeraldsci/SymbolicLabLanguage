(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,FreezeCells],{
	Description->"Data object related to a cell freezing experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* ---------- Method Information ---------- *)
		
		Batches->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ObjectP[Object[Sample]]..},
			Description->"Describes the group of cells that are frozen together.",
			Category->"General"
		},
		
		FreezingMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FreezeCellMethodP,
			Description->"For each member of Batches, describes which process is used to freeze the cells.",
			Category->"General",
			IndexMatching->Batches
		},
		
		Instruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,ControlledRateFreezer],
				Object[Instrument,ControlledRateFreezer],
				Model[Instrument,Freezer],
				Object[Instrument,Freezer]
			],
			Description->"For each member of Batches, the cooling device that is used to lower the temperature of samples.",
			Category->"General",
			IndexMatching->Batches
		},
		
		FreezingProfiles->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Kelvin],GreaterEqualP[0 Minute]}..},
			Description->"For each member of Batches, describes the series of steps that are taken to cool the cells.",
			Category->"General",
			IndexMatching->Batches
		},
		
		FreezingRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius/Minute],
			Units->Celsius/Minute,
			Description->"For each member of Batches, the decrease in temperature per unit time if cooling at a constant rate is desired.",
			Category->"General",
			IndexMatching->Batches
		},
		
		Durations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of Batches, the amount of time the cells are cooled at FreezingRate.",
			Category->"General",
			IndexMatching->Batches
		},
		
		ResidualTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Kelvin,
			Description->"For each member of Batches, the final temperature at which the cells are kept before moving to final storage.",
			Category->"General",
			IndexMatching->Batches
		},
		
		(* ---------- Experimental Results ---------- *)

		ExpectedTemperatureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"For each member of Batches, programmed temperature of the cooling block as a function of time.",
			Category->"Experimental Results",
			IndexMatching->Batches
		},
		
		MeasuredTemperatureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"For each member of Batches, experimentally measured temperature of the solution as a function of time.",
			Category->"Experimental Results",
			IndexMatching->Batches
		}
	}
}];
