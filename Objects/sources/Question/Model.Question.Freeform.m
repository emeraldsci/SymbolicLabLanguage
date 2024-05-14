(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Question,Freeform],{
	Description->"Model information for a quiz question used to a request a freeform response from a subject.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CorrectAnswer->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[_,Null],
			Description->"The pattern that a correct response to this question will match.",
			Category->"Answer Information"
		}
	}
}];