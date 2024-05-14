(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[TrainingMaterial], {
	Description->"Stores information about a training material that needs to be reviewed by an operator as they take a training module.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		ReviewedOn->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date on which the operator reviewed this training material.",
			Category->"General"
		}
	}
}];
