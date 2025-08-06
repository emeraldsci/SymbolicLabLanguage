(* ::Package:: *)

DefineObjectType[Model[Qualification,Refrigerator],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a Refrigerator.",
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
		MeanTarget->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The target temperature of the target Refrigerator model.",
			Category->"General"
		},
		MeanTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"The amount above or below the target temperature that the mean may deviate by for this qual to be considered a pass.",
			Category->"General"
		},
		StandardDeviationTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"The maximum amount that the temperature distribution is allowed to spread by for this qual to be considered a pass.",
			Category->"General"
		},
		MaintenanceRecoveryTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Hour],
			Units->Hour,
			Description->"The amount of time after a maintenance has been performed on the target to exclude temperature data from assessment to allow the Refrigerator to recover.",
			Category->"General"
		}
	}
}];
