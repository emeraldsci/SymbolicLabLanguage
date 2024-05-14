(* ::Package:: *)

DefineObjectType[Model[Qualification,Electrophoresis],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of an electrophoresis instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Tolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Meter],
			Units->Millimeter,
			Description->"The maximum difference between the expected and actual position of a gel band that will allow that band to be considered a pass by this qualification model.",
			Category->"General"
		}
	}
}];
