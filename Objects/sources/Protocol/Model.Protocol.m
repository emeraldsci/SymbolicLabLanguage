(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Protocol],{
	Description->"Model containing information to run a specific protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Purpose->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The purpose or intent of this model protocol.",
			Category->"Organizational Information",
			Abstract->True
		},
		Authors->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User],
			Description->"The person(s) who created this Protocol model.",
			Category->"Organizational Information"
		},
		Deprecated->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this model protocol is historical and no longer used in the lab.",
			Category->"Organizational Information",
			Abstract->True
		},
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		}
	}
}];