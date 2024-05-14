(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*RoundMatchQ*)


DefineTests[RoundMatchQ,{
	Example[
		{Basic,"Returns a pure function that rounds its arguments and then applies MatchQ:"},
		RoundMatchQ[3],
		_Function
	],
	Example[
		{Basic,"Round to three digits then apply MatchQ:"},
		RoundMatchQ[3][1.001,1.],
		True
	],
	Example[
		{Basic,"Round to five digits then apply MatchQ:"},
		RoundMatchQ[5][1.001,1.],
		False
	],
	Example[
		{Options, Force, "If 'Force' is set to its default value of False, RoundMatchQ may fail to properly round numbers inside held expressions:"},
		RoundMatchQ[2][Hold[1.1111], Hold[1.11]],
		False
	],
	Example[
		{Options, Force, "Round all real numbers, even those inside expressions whose heads have attributes Hold, HoldAll, etc., before applying MatchQ:"},
		RoundMatchQ[2, Force -> True][Hold[1.1111], Hold[1.11]],
		True
	]
}];


(* ::Subsubsection:: *)
(*RoundReals*)


DefineTests[RoundReals,
{
		Example[
			{Basic,"Round a number:"},
			RoundReals[1.2345678912345678912345`22.09151497760357],
			1.23456789123457`
		],
		Example[
			{Basic,"Round a number to a specific number of digits after the decimal:"},
			RoundReals[1.2345678912345678912345`22.09151497760357,3],
			1.23`
		],
		Example[
			{Basic,"Round all reals in the expression:"},
			RoundReals[{1.2345,pony[3.2525]},2],
			{1.2`,pony[3.3`]}
		],
		Example[
			{Basic,"Round to two significant figures:" },
			RoundReals[12345.678,2],
			12000.`
		],
		Example[
			{Options, Force, "Held expressions may prevent RoundReals from evaluating when 'Force' is set to its default value of False:"},
			RoundReals[Hold[1.3458345092], 2],
			Hold[roundOneReal[1.3458345092`,2]]
		],
		Example[
			{Options, Force, "Round all real numbers, even those inside expressions whose heads have attributes Hold, HoldAll, etc:"},
			RoundReals[Hold[1.3458345092], 2, Force -> True],
			Hold[1.3`]
		]
}];


(* ::Subsection::Closed:: *)
(*Predicates*)


(* ::Subsubsection::Closed:: *)
(*InfiniteNumericQ*)


DefineTests[
  InfiniteNumericQ,
  {
    Example[{Basic, "Returns True for \[Infinity]."},
      InfiniteNumericQ[\[Infinity]],
      True
    ],

    Test["Returns True for -\[Infinity].",
      InfiniteNumericQ[\[Infinity]],
      True
    ],

    Example[{Basic, "Returns True for an Integer."},
      InfiniteNumericQ[10],
      True
    ],

    Example[{Basic, "Returns False for a string."},
      InfiniteNumericQ["string"],
      False
    ],

    Example[{Attributes,"Listable","It is listable."},
      InfiniteNumericQ[{1, \[Infinity], -\[Infinity], asdfasdf, "string"}],
      {True, True, True,False, False}
    ]
  }
];


(* ::Subsubsection::Closed:: *)
(*KeyPatternsQ*)


DefineTests[
  KeyPatternsQ,
  {
    Example[{Basic, "Check values of first param match the patterns in the second param:"},
      KeyPatternsQ[<|a -> 1, b -> "foo"|>, <|a -> _Integer, b-> _String |>],
      True
    ],
    Example[{Basic, "Only checks the values passed into the second Association:"},
      KeyPatternsQ[<|a -> 1, b -> "foo", c->100.7|>, <|a -> _Integer, b-> _String |>],
      True
    ],
    Example[{Basic, "Fails if key in first Association is Missing:"},
      KeyPatternsQ[<|a -> 1, b -> "foo", c->100.7|>, <|a -> _Integer, b-> _String, w->_Real |>],
      False
    ],
    Example[{Basic, "Can check is something is not there by checking the _Missing pattern:"},
      KeyPatternsQ[<|a -> 1, b -> "foo", c->100.7|>, <|a -> _Integer, b-> _String, w->_Missing |>],
      True
    ],
    Example[{Basic, "Works on lists of rules:"},
      KeyPatternsQ[{a -> 1, b -> "foo"}, {a -> _Integer, b-> _String}],
      True
    ],
    Example[{Additional, "Works checking a single key with a Rule for the second param:"},
      KeyPatternsQ[{a -> 1, b -> "foo"}, b-> _String],
      True
    ],
    Example[{Options,Verbose,"Verbose->True returns an Assocation with details on what's wrong:"},
      KeyPatternsQ[<|a -> "bar", b -> "foo", c->100.7|>, <|a -> _Integer, b-> _String |>, Verbose -> True],
      <|a -> False, b -> True |>
    ],
    Example[{Options,Verbose,"Verbose->True returns all True assocation:"},
      KeyPatternsQ[<|a -> 1, b -> "foo", c->100.7|>, <|a -> _Integer, b-> _String, c->_Real |>, Verbose -> True],
      <|a -> True, b -> True, c->True |>
    ]
  }
];


(* ::Subsection::Closed:: *)
(*Null Checking*)


(* ::Subsubsection::Closed:: *)
(*SafeEvaluate*)


DefineTests[
	SafeEvaluate,
	{
		Example[
			{Basic,"Evaluates if no part of 'input' matches NullP:"},
			SafeEvaluate[{count=10},count+1],
			11
		],
		
		Example[
			{Basic,"Multiple expressions can be checked for Null-ness by passing them to 'input' in a list:"},
			SafeEvaluate[{thing1={a,b},thing2=c},Append[thing1,thing2]],
			{a,b,c}
		],
		
		Example[
			{Basic,"Returns Null if 'input' matches NullP:"},
			SafeEvaluate[{count=Null},count+1],
			Null
		],
		
		Example[
			{Additional,"Returns Null if 'input' is an empty list:"},
			SafeEvaluate[{1,{}},count+1],
			Null
		],
		
		Example[
			{Additional,"This includes any nested lists of only Null:"},
			SafeEvaluate[{thing1={Null,Null},thing2=c},Append[thing1,thing2]],
			Null
		],
		
		Example[
			{Additional,"A partially null element of the input list will still evaluate:"},
			SafeEvaluate[{things={1,2,3,4,Null}},Total[things]],
			10+Null
		],
		
		Example[
			{Attributes,HoldRest,"The expression passed in as the second argument is held and only evaluated if the proper conditions are met:"},
			SafeEvaluate[{Null},Print["Expression was not held"];2],
			Null
		]
	}
];
