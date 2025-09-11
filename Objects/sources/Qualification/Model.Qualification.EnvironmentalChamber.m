(* ::Package:: *)

DefineObjectType[Model[Qualification, EnvironmentalChamber], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an EnvironmentalChamber.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		TimePeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Day],
			Units->Day,
			Description->"The time period over which to qualify the EnvironmentalChamber.",
			Category->"General"
		},
		SamplingRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Hour],
			Units->Hour,
			Description->"The rate at which to downsample the EnvironmentalChamber data before analysis.",
			Category->"General"
		},
		MeanTolerance->{
			Format->Single,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null},
			Description->"The amount above or below the target temperature and relative humidity that the means may deviate by for this qualification to be considered a pass.",
			Category->"General"
		},
		StandardDeviationTolerance->{
			Format->Single,
			Class->Expression,
			Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null},
			Description->"The maximum amount that the temperature, and relative humidity distributions are allowed to spread by for this qualification to be considered a pass.",
			Category->"General"
		}
	}
}];