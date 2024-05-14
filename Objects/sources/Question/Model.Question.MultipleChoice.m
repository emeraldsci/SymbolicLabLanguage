(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Question,MultipleChoice],{
	Description->"Model information for a quiz question used to request information from a subject from a pre-determined list of responses.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PossibleResponses->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The pre-determined options from which a candidate can select their response to this question.",
			Category->"Answer Information"
		},
		RandomizeChoices->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the possible responses should be displayed in a random order in engine when this question is posed.",
			Category->"Answer Information"
		},
		CorrectAnswer->{
			Format->Single,
			Class->Expression,
			Pattern:>ListableP[_String],
			Description->"The correct response(s) to this question. These must be members of possible responses.",
			Category->"Answer Information"
		},
		NumberOfResponses->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The number of responses that a candidate is permitted to select for this question.",
			Category->"Answer Information"
		},
		PassingPercentage->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For questions that permit multiple responses, the percentage of correct responses that a candidate must equal, or exceed to pass this question.",
			Category->"Answer Information"
		},
		Boolean->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this question is a \"True/False\" type question.",
			Category->"Answer Information"
		},
		ResponseRules->{
			Format->Single,
			Class->Expression,
			Pattern:>{(_->_)..},
			Description->"A list of rules of displayed possible response to stored value read by engine to display this question.",
			Category->"Answer Information",
			Developer->True
		}
	}
}];
