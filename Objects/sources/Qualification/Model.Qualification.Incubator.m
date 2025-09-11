(* ::Package:: *)

DefineObjectType[Model[Qualification, Incubator], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an incubator.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		TimePeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Day],
			Units->Day,
			Description->"The time period over which to qualify the Incubator.",
			Category->"General"
		},
		SamplingRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Hour],
			Units->Hour,
			Description->"The rate at which to downsample the Incubator data before analysis.",
			Category->"General"
		},
		MeanTarget->{
			Format->Single,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null,GreaterEqualP[0 Percent]|Null},
			Description->"The target temperature, CO2 concentration, and relative humidity of the target Incubator model.",
			Category->"General"
		},
		MeanTolerance->{
			Format->Single,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null,GreaterEqualP[0 Percent]|Null},
			Description->"The amount above or below the target temperature, CO2 concentration, and relative humidity that the means may deviate by for this qualification to be considered a pass.",
			Category->"General"
		},
		StandardDeviationTolerance->{
			Format->Single,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null,GreaterEqualP[0 Percent]|Null},
			Description->"The maximum amount that the temperature, CO2 concentration, and relative humidity distributions are allowed to spread by for this qualification to be considered a pass.",
			Category->"General"
		}
	}
}];