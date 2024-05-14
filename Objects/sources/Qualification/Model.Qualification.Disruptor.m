(* ::Package:: *)

DefineObjectType[Model[Qualification,Disruptor],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a disruptor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DisruptionSpeed->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units:>RPM,
			Description->"Indicates the speed at which disruption should be performed.",
			Category -> "General"
		},
		DisruptionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Minute],
			Units:>Minute,
			Description->"Indicates the length of time for which disruption should be performed.",
			Category -> "General"
		}
	}
}];
