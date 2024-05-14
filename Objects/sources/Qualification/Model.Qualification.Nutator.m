(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Nutator],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a nutator.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		NutationSpeed->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units:>RPM,
			Description->"Indicates the speed at which nutation should be performed.",
			Category -> "General"
		},
		NutationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units:>Minute,
			Description->"Indicates the length of time for which nutation should be performed.",
			Category -> "General"
		}
	}
}];
