(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,ControlledRateFreezer], {
	Description->"A protocol that verifies the functionality of the controlled rate freezer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* ---------- Experimental Results ---------- *)
		
		FreezingTestResult->{
			Format->Single,
			Class->Expression,
			Pattern:>Pass|Fail,
			Description->"Describes whether all of the qualification samples were frozen during the qualification run.",
			Category->"Experimental Results"
		},
		
		ExpectedTemperatureData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"Programmed temperature of the cooling block as a function of time.",
			Category->"Experimental Results"
		},
		
		MeasuredTemperatureData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"Experimentally measured temperature of the solution as a function of time.",
			Category->"Experimental Results"
		},

		FreezingStartTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the recording of environmental data inside the freezer begins.",
			Category -> "Cell Freezing",
			Developer -> True
		},

		FreezerSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sensor, Temperature]],
			Description -> "The temperature sensor object(s) inside Freezers whose data are recorded while the cell samples are being frozen.",
			Category -> "Cell Freezing",
			Developer -> True
		},

		FreezerEnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data, Temperature]],
			Description -> "For each member of FreezerSensors, the temperature data recorded from the sensor during freezing.",
			Category -> "Cell Freezing",
			IndexMatching -> FreezerSensors,
			Developer -> True
		}

	}
}];
