(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Generic patterns*)


(* ::Subsubsection:: *)
(*InfiniteNumericQ*)


DefineTests[
	InfiniteNumericQ,
	{
		Example[{Basic, "Returns True for \[Infinity]:"},
			InfiniteNumericQ[\[Infinity]],
			True
		],
		Test["Returns True for -\[Infinity]:",
			InfiniteNumericQ[-\[Infinity]],
			True
		],
		Example[{Basic, "Returns True for an Integer:"},
			InfiniteNumericQ[10],
			True
		],
		Example[{Basic, "Returns False for a string:"},
			InfiniteNumericQ["string"],
			False
		],
		Example[{Attributes,Listable,"The function can take in a list:"},
			InfiniteNumericQ[{1, \[Infinity], -\[Infinity], asdfasdf, "string"}],
			{True, True, True, False, False}
		]
	}
];



(* ::Subsubsection:: *)
(* PatternUnion *)


DefineTests[PatternUnion, {
	Example[{Basic, "When multiple patterns are given as input, returns a pattern that checks for a match on all of them:"},
		{
			MatchQ[27, PatternUnion[_Integer, _?(#>2&), _?(#<99&)]],
			MatchQ[27, PatternUnion[_Integer, _?(#>2&), _String, _?(#<99&)]]
		},
		{
			True,
			False
		}
	],
	
	Example[{Basic, "Returns the same pattern when only one pattern is given as input:"},
		{MatchQ[27.3, PatternUnion[_Integer]], MatchQ[27.3, PatternUnion[_Real]]},
		{False, True}
	],

	Example[{Basic, "Does not resolve when no patterns are given as input:"},
		PatternUnion[],
		_PatternUnion
	]

}];
