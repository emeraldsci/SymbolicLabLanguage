(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,CrossFlowFiltration],{
	Description->"Data object related to a cross-flow filtration experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* ---------- Method Information ---------- *)
		
		FiltrationMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowFiltrationModeP,
			Description->"Sequence of concentration and diafiltration steps performed in the experiment.",
			Category->"General"
		},
		
		CrossFlowFilter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,CrossFlowFilter],
				Model[Item,CrossFlowFilter],
				Object[Item, Filter, MicrofluidicChip],
				Model[Item, Filter, MicrofluidicChip]
			],
			Description->"The filter unit used to separate the sample during the experiment.",
			Category->"General"
		},
		
		AbsorbanceDataAcquisitionFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"Describes how often absorbance values are measured.",
			Category->"General"
		},
		
		(* ---------- Data Processing ---------- *)
		
		DataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Data files containing the results of the cross-flow filtration experiment.",
			Category->"Data Processing"
		},

		(* ---------- Experimental Results ---------- *)
		
		(* ----- Pressure ----- *)
		
		InletPressureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,PSI}..}],
			Units->{Minute,PSI},
			Description->"Pressure of the solution as it enters the filter module as a function of time.",
			Category->"Experimental Results"
		},
		
		RetentatePressureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,PSI}..}],
			Units->{Minute,PSI},
			Description->"Pressure of the solution retained in the filter module as a function of time.",
			Category->"Experimental Results"
		},
		
		PermeatePressureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,PSI}..}],
			Description->"Pressure of the solution extruded from the filter module as a function of time.",
			Category->"Experimental Results"
		},
		
		TransmembranePressureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,PSI}..}],
			Description->"Calculated pressure across the filter membrane as a function of time.",
			Category->"Experimental Results"
		},
		
		(* ----- Weight ----- *)
		
		RetentateWeightData -> {
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute, Gram}..}],
			Units->{Minute, Gram},
			Description->"Mass of the retentate as a function of time.",
			Category->"Experimental Results"
		},
		DiafiltrationWeightData -> {
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Gram}..}],
			Units->{Minute,Gram},
			Description->"Mass of the permeate as a function of time.",
			Category->"Experimental Results"
		},
		
		PermeateWeightData -> {
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Gram}..}],
			Units->{Minute,Gram},
			Description->"Mass of the permeate as a function of time.",
			Category->"Experimental Results"
		},
	
		(* ----- Flow Rate ----- *)
		
		PrimaryPumpFlowRateData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Milliliter/Minute}..}],
			Units->{Minute,Milliliter/Minute},
			Description->"The amount of solution moved by the primary pump as a function of time.",
			Category->"Experimental Results"
		},
		
		SecondaryPumpFlowRateData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Milliliter/Minute}..}],
			Units->{Minute,Milliliter/Minute},
			Description->"The amount of solution moved by the secondary pump as a function of time.",
			Category->"Experimental Results"
		},
		
		(* ----- Temperature and Conductivity ----- *)
		
		RetentateConductivityData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Siemens/Meter}..}],
			Units->{Minute,Milli Siemens/Centimeter},
			Description->"Conductivity of the retentate as a function of time.",
			Category->"Experimental Results"
		},
		
		PermeateConductivityData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Siemens/Meter}..}],
			Units->{Minute,Milli Siemens/Centimeter},
			Description->"Conductivity of the permeate as a function of time.",
			Category->"Experimental Results"
		},

		TemperatureData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Minute,Kelvin}..}],
			Units->{Minute,Celsius},
			Description->"The temperature of the solution as a function of time.",
			Category->"Experimental Results"
		},
		
		(* Log information *)
		FiltrationCycleLog->{
			Format -> Multiple,
			Class -> {Real, String, String},
			Pattern :> {TimeP, _String, _String},
			Units -> {Second, None, None},
			Headers -> {"Time", "Cycle", "State"},
			Description->"The log information that record the specific commands sent by instrument software to carry out an experiment..",
			Category -> "Experimental Results"
		},
		
		(* ----- Absorbance ----- *)

		RetentateAbsorbanceData->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(QuantityArrayP[{{Minute,Nanometer,ArbitraryUnit}..}]|Null)..},
			Description->"How much light is absorbed by the retentate as a function of time.",
			Category->"Experimental Results"
		},

		PermeateAbsorbanceData->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{(QuantityArrayP[{{Minute,Nanometer,ArbitraryUnit}..}]|Null)..},
			Description->"How much light is absorbed by the permeate as a function of time.",
			Category->"Experimental Results"
		},
		SampleType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (FilterPrime | Sample | FilterFlush | FilterFlushRinse | FilterPrimeRinse),
			Description -> "The type of sample run for this unit operation.",
			Category -> "General"
		}
	}
}];
