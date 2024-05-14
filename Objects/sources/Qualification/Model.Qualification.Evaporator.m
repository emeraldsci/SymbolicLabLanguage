(* ::Package:: *)

DefineObjectType[Model[Qualification,Evaporator], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an evaporator.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		EvaporationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Hour],
			Units->Hour,
			Description->"The time period that the qualification samples are subjected to drying conditions by the target.",
			Category->"Qualification Parameters"
		},
		EvaporationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature that the qualification samples are subjected when being dried by the target.",
			Category->"Qualification Parameters"
		},
		VolumeTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"The maximum percentage of the initial volume for a well that may be measured after evaporation and be considered passing.",
			Category->"Passing Criteria"
		}
	}
}];
