(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,FreezeCells],{
	Description->"Data object related to a cell freezing experiment using a controlled rate cell freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* ---------- Method Information ---------- *)

		Freezer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,ControlledRateFreezer],
				Object[Instrument,ControlledRateFreezer],
				Model[Instrument,Freezer],
				Object[Instrument,Freezer]
			],
			Description->"For each member of Batches, the cooling device that is used to lower the temperature of samples.",
			Category->"General"
		},
		
		(* ---------- Experimental Results ---------- *)

		ExpectedTemperatureData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"For each member of Batches, programmed temperature of the cooling block as a function of time.",
			Category->"Experimental Results"
		},
		
		MeasuredTemperatureData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"For each member of Batches, experimentally measured temperature of the solution as a function of time.",
			Category->"Experimental Results"
		}
	}
}];
