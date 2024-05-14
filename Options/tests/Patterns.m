(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsubsection:: *)
(*DuplicateFreeListableP*)


DefineTests[
	DuplicateFreeListableP,
	{
		Example[{Basic,"Creates a pattern that matches the given pattern, or a list of the given pattern (which must be duplicate free):"},
			DuplicateFreeListableP[x],
			Verbatim[x|{x..}?DuplicateFreeQ]
		],

		Example[{Basic,"If the list given is not duplicate free, will not match the given list:"},
			MatchQ[{a,b,c,d,a}, DuplicateFreeListableP[a|b|c|d]],
			False
		],

		Example[{Basic,"If the list given is  duplicate free, will match the given list:"},
			MatchQ[{a,b,c,d}, DuplicateFreeListableP[a|b|c|d]],
			True
		]
	}
];


(* ::Subsubsection:: *)
(*ListableP*)


DefineTests[
	ListableP,
	{
		Example[{Basic,"If given no level-spec generates a pattern of single element or list of elements:"},
			ListableP[x],
			Verbatim[x|{x..}]
		],

		Example[{Basic,"If given single level spec integer, generates pattern from level 0 to integer:"},
			ListableP[x,2],
			Verbatim[x|{x..}|{{x..}..}]
		],

		Example[{Basic,"If single element in list as level spec, generates listed pattern at only that level:"},
			ListableP[x,{2}],
			Verbatim[{{x..}..}]
		],

		Example[{Basic,"If given span as level spec, generates pattern between given levels:"},
			ListableP[x,{1,2}],
			Verbatim[{x..}|{{x..}..}]
		],

		Example[{Additional,"Does not evaluate if level-spec is negative:"},
			ListableP[x,-1],
			HoldPattern[ListableP[x,-1]]
		],

		Example[{Additional,"Does not evaluate if minLevel > maxLevel:"},
			ListableP[x,{3,2}],
			HoldPattern[ListableP[x,{3,2}]]
		]
	}
];
