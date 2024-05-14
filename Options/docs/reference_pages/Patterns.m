(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*Help Files*)


(* ::Subsubsection::Closed:: *)
(*DuplicateFreeListableP*)


DefineUsage[DuplicateFreeListableP,
	{
		BasicDefinitions->{
			{"DuplicateFreeListableP[pattern]","outputPattern","generates an 'outputPattern' which matches 'pattern' or a list of 'pattern' (which must be duplicate free)."}
		},
		MoreInformation->{
			"When making a Multiselect Widget, DuplicateFreeListableP must be used."
		},
		Input:>{
			{"pattern",_,"Pattern to repeat in list form."}
		},
		Output:>{
			{"outputPattern",_Alternatives,"Nested List pattern."}
		},
		SeeAlso->{"ListableP", "NestList","Span","Alternatives","Repeated"},
		Author->{"scicomp", "brad"}
	}];

(* ::Subsubsection::Closed:: *)
(*ListableP*)


DefineUsage[ListableP,
	{
		BasicDefinitions -> {
			{"ListableP[pattern]", "outputPattern", "generates an 'outputPattern' which matches 'pattern' or a list of 'pattern'."},
			{"ListableP[pattern,maxLevel]", "outputPattern", "generates an 'outputPattern' which matches 'pattern', or a nested list of 'pattern' up to 'maxLevel'."},
			{"ListableP[pattern,{maxLevel}]", "outputPattern", "generates an 'outputPattern' which matches a nested list of 'pattern' only at the given 'maxLevel'."},
			{"ListableP[pattern,{minLevel,maxLevel}]", "outputPattern", "generates an 'outputPattern' which matches a nested list of 'pattern' between 'minLevel' and 'maxLevel'."}
		},
		MoreInformation -> {
			"ListableP does not generate a pattern which will match an empty list at any level."
		},
		Input :> {
			{"pattern", _, "Pattern to repeat in list form."},
			{"maxLevel", _Integer?NonNegative, "Maximum level to nest the pattern."},
			{"minLevel", _Integer?NonNegative, "Minimum level to nest the pattern."}
		},
		Output :> {
			{"outputPattern", _Alternatives, "Nested List pattern."}
		},
		SeeAlso -> {"NestList", "Span", "Alternatives", "Repeated"},
		Author -> {"scicomp", "brad"}
	}];