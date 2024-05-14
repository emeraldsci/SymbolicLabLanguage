(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,ControlledRateFreezer], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a controlled rate freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		QualificationSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The sample models used to assess whether the freezer is reaching desired temperatures.",
			Category -> "General"
		}
	}
}];
