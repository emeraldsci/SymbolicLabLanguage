(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Rounding*)


(* ::Subsubsection::Closed:: *)
(*RoundMatchQ*)


DefineUsage[RoundMatchQ,
{
	BasicDefinitions->
		{
			{"RoundMatchQ[n]","f","generate a function that rounds its arguments to 'n' digits using 'RoundReals', and then applies MatchQ."}
		},
	Input:>
		{
			{"n",_Integer,"Number of digits to round to."}
		},
	Output:>
		{
			{"f",_Function,"A pure function that rounds and applies MatchQ."}
		},
	SeeAlso->
		{
			"RoundReals",
			"MatchQ"
		},
	Author->{"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*RoundReals*)


DefineUsage[RoundReals,
{
	BasicDefinitions->
		{
			{"RoundReals[expr, n]","newExpr","rounds all _Real numbers in 'expr' to 'n' digits."},
			{"RoundReals[expr]","newExpr","rounds all _Real numbers in 'expr' to 15 digits."}
		},
	Input:>
		{
			{"expr",_,"An expression containing zero or more real numbers."},
			{"n",_Integer,"Number of digits to round to."}
		},
	Output:>
		{
			{"newExpr",_,"An expression containing reals that were rounded to 'n' digits."}
		},
	SeeAlso->{"RoundMatchQ", "MantissaExponent", "Round"},
	Author->{"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*InfiniteNumericQ*)


DefineUsage[InfiniteNumericQ, {
	BasicDefinitions->{
		{"InfiniteNumericQ[val]","out","returns true if the input is either numeric, \[Infinity], or -\[Infinity]."}
	},
	Input:>{
		{"val",_,"Data to test."}
	},
	Output:>{
		{"out",True|False,"True if input is numeric or +/-\[Infinity], False otherwise."}
	},
	SeeAlso->{"NumericQ","MatchQ"},
	Author->{"brad"}
}];

(* ::Subsubsection::Closed:: *)
(*KeyPatternsQ*)


DefineUsage[KeyPatternsQ,
{
	BasicDefinitions->
		{
			{"KeyPatternsQ[data,patterns]","result","does a key-wise MatchQ comparison of the keys in 'data' with the patterns specified by the keys in 'patterns'."}
		},
	MoreInformation->{
			"When Verbose->True, the output is an Association with the results of each of the comparisons.",
      "You can check if something is missing with the form <|key->_Missing|>"
	},
	Input:>
		{
			{"data",_Assocation|{RulesP...},"The data with which to pattern match."},
      {"patterns",_Association|{RulesP...},"The patterns to match in the data."}
		},
	Output:>
		{
			{"result",True|False|_Association,"If everything matches, True or False, or True/False on each of the keys checked."}
		},
	SeeAlso->
		{
			"MatchQ",
			"Association",
			"AllTrue"
		},
	Author->{"platform"}
}];

(* ::Subsection::Closed:: *)
(*Null Checking*)

(* ::Subsubsection::Closed:: *)
(*SafeEvaluate*)

DefineUsage[SafeEvaluate,
	{
		BasicDefinitions->
			{
				{"SafeEvaluate[input,expr]","out","evaluates 'expr' if no members of the list 'input' match NullP|{}; otherwise, returns Null."}
			},
		MoreInformation->
			{
				"Always pass items to be checked for Null-ness as a list, ESPECIALLY when only passing one item."
			},
		Input:>
			{
				{"input",_List,"A list of inputs to be checked for Null-ness before evaluating 'expr'. An input is considered 'Null' only if all parts of it are Null."},
				{"expr",_,"An expression to be evaluated only if no members of 'input' match NullP."}
			},
		Output:>
			{
				{"out",_,"Either 'Null' or the result of the evaluation of 'expr'."}
			},
		SeeAlso->
			{
				"NullQ",
				"ToList"
			},
		Author->{"ben", "olatunde.olademehin"}
	}
];