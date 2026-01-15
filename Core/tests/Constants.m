(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Configuration: Tests*)



(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*DefineConstant*)


DefineTests[
	DefineConstant,
	{
		Example[{Basic, "Define a new constant with a value of \[Pi]:"},
			Unprotect[$TestConstant];
			Clear[$TestConstant];
			DefineConstant[$TestConstant, \[Pi]];
			$TestConstant == \[Pi],
			True
		],

		Example[{Basic, "Redefine a constant with a new value \"Brad\":"},
			Unprotect[$TestConstant];
			Clear[$TestConstant];
			DefineConstant[$TestConstant, \[Pi]];
			DefineConstant[$TestConstant, "Brad"];
			$TestConstant == "Brad",
			True
		],

		Example[{Basic, "Define a constant with a specified Usage message:"},
			Unprotect[$TestConstant];
			Clear[$TestConstant];
			DefineConstant[$TestConstant, "Brad", "Help text"];
			$TestConstant::usage == "Help text",
			True
		],

		Example[{Attributes, HoldAll, "All arguments are held so that on initialization the correct value is used:"},
			DefineConstant[$MyConstant, Now, "Help text"],
			_?DateObjectQ
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SafeNow*)

DefineTests[
	SafeNow,
	{
		Example[{Basic, "SafeNow returns the same DateObject as Now under normal circumstances:"},
			SafeNow[],
			RangeP[Now - 1 Millisecond, Now]
		],
		Example[{Basic, "SafeNow is not altered by Block of Now:"},
			Block[{Now = DateObject[{2025, 01, 01, 0, 0, 0}]},
				{Now, SafeNow[]}
			],
			{DateObject[{2025, 01, 01, 0, 0, 0}], RangeP[DateObject[] - 1 Millisecond, DateObject[]]}
		],
		Example[{Basic, "SafeNow is not altered by stub of Now:"},
			{Now, SafeNow[]},
			{DateObject[{2025, 01, 01, 0, 0, 0}], RangeP[DateObject[] - 1 Millisecond, DateObject[]]},
			Stubs :> {Now = DateObject[{2025, 01, 01, 0, 0, 0}]}
		],
		Example[{Additional, "SafeNow cannot be modified using Block:"},
			Block[{SafeNow},
				SafeNow[] = DateObject[{2025, 01, 01, 0, 0, 0}];
				SafeNow[]
			],
			_,
			Messages :> {Block::lockv}
		]
	}
];

(* ::Section:: *)
(*End Test Package*)
