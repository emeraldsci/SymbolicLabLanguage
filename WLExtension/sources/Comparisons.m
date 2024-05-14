(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*Rounding*)


(* ::Subsubsection:: *)
(*RoundReals*)


DefineOptions[
	RoundReals,
	Options :> {
		{Force -> False, False | True, "If True, forces rounding even inside held expressions. If False, rounds inside held expressions are left unevaluated."}
	}
];

RoundReals[expr_,ops:OptionsPattern[]]:=RoundReals[expr,15,ops];

RoundReals[expr_,k_Integer,ops:OptionsPattern[]]:=Module[
	{safeOps,roundingFunction},
	
	safeOps = OptionDefaults[RoundReals, ToList[ops]];
	roundingFunction = If[TrueQ[Lookup[safeOps,"Force"]],
		roundHeldReals,
		roundReals
	];
	roundingFunction[expr,k]
];

roundOneReal[r_Real,k_Integer]:=N[Round[r,10^(Last[MantissaExponent[r]]-k)]];

roundReals[expr_,k_Integer]:=ReplaceAll[
	expr,
	{
		f_Function:>roundHeldReals[f,k],
		r_Real :> roundOneReal[r,k]
	}
];

roundHeldReals[expr_,k_Integer]:=ReplaceAll[
	expr,
	r_Real :> With[{rounded = roundOneReal[r,k]}, rounded /;True]
];


(* ::Subsubsection:: *)
(*RoundMatchQ*)


DefineOptions[
	RoundMatchQ,
	SharedOptions :> {RoundReals}
];

RoundMatchQ[n_Integer, ops:OptionsPattern[]]:=Function[{x,y},
	MatchQ[
		RoundReals[x,n,ops],
		RoundReals[y,n,ops]
	]
];


(* ::Subsection:: *)
(*Predicates*)


(* ::Subsubsection::Closed:: *)
(*InfiniteNumericQ*)


InfiniteNumericQ[value_]:=MatchQ[
  value,
  _?NumericQ | Infinity | -Infinity
];
SetAttributes[InfiniteNumericQ,Listable];


(* ::Subsubsection::Closed:: *)
(*KeyPatternsQ*)


DefineOptions[
  KeyPatternsQ,
  Options:>{
    {Verbose->False, True|False, "When true, outputs which keys are not passing the MatchQ."}
  }
];

KeyPatternsQ[data:(_Association|{RulesP..}), pattern_Rule, ops:OptionsPattern[KeyPatternsQ]]:=KeyPatternsQ[data, Association[pattern], ops];

KeyPatternsQ[data:(_Association|{RulesP..}),patterns:(_Association|{_Rule..}),ops:OptionsPattern[KeyPatternsQ]]:=Module[
  {verbose, result},

  verbose = OptionDefault[OptionValue[Verbose]];

  result=Association[MapThread[
    Function[
      {key,value,pattern},
      key -> MatchQ[value,pattern]
    ],
    (* Map thread over the values of data matching against all the patterns in the patterns assoc *)
    {
      (* #1 keys *)
      Keys[patterns],
      (* #2 data values *)
      Lookup[data, Keys[patterns]],
      (* #3 Pattern patterns *)
      Values[patterns]
    }
  ]];

  If[verbose,
    result,
    AllTrue[Values[result], TrueQ]
  ]
];

KeyPatternsQ[_,__]:=False;


(* ::Subsection:: *)
(*Null Checking*)


(* ::Subsubsection::Closed:: *)
(*SafeEvaluate*)


SafeEvaluate[input_List,expr_]:=If[AnyTrue[input,Or[MatchQ[#,{}],NullQ[#]]&],
	Null,
	expr
];

SetAttributes[SafeEvaluate,HoldRest];
