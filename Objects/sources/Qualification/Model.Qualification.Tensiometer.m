(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Tensiometer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a tensiometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MinCriticalMicelleConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>ConcentrationP,
			Units->Millimolar,
			Description->"The minimum calculated value for the concentration above which micelles form that will be accepted as a pass for this model of qualification.",
			Category->"General",
			Abstract->True
		},
		MaxCriticalMicelleConcentration->{
			Format->Single,
			Class->Real,
			Pattern:>ConcentrationP,
			Units->Millimolar,
			Description->"The maximum calculated value for the concentration above which micelles form that will be accepted as a pass for this model of qualification.",
			Category->"General",
			Abstract->True
		},
		NumberOfCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of times that the sample stage is raised and lowered such that the advancing contact angle is measured when raising and receding contact angle is measured when lowering.",
			Category->"General"
		},
		WettedLengthTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>PercentP,
			Units->Percent,
			Description->"The percent amount by which the measured wetted length can differ from the expected wetted length and be considered a pass for this model of qualification.",
			Category->"General"
		},
		MinRSquared->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Units->None,
			Description->"The minimum R-squared value allowed for the wetted length curve in this model of qualification.",
			Category->"General"
		}
	}
}];
