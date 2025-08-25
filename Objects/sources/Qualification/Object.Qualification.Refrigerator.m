(* ::Package:: *)

DefineObjectType[Object[Qualification,Refrigerator],{
	Description->"A protocol that verifies the functionality of the Refrigerator target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		TimePeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Day],
			Units->Day,
			Description->"The time period over which to qualify the Refrigerator.",
			Category->"General"
		},
		SamplingRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Hour],
			Units->Hour,
			Description->"The rate at which to downsample the Refrigerator data before analysis.",
			Category->"General"
		},
		TemperatureData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{None,Celsius}],
			Units->{None,Celsius},
			Description->"The downsampled data assessed by this qualification.",
			Category->"Experimental Results"
		},
		MaintenanceTimePeriods->{
			Format->Multiple,
			Class->{Link,Date,Date},
			Pattern:>{_Link,_?DateObjectQ,_?DateObjectQ},
			Relation->{Object[Maintenance],Null,Null},
			Description->"The start datetime and end datetime for any time periods within the qual assessment period that the target is actively undergoing a maintenance.",
			Category->"Experimental Results",
			Headers->{"Maintenance","Start Date","End Date"}
		}
	}
}];
