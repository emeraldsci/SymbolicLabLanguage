(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[ManifoldEcho,
	{
		Example[{Basic,"ManifoldEcho with an input expression, returns the expression:"},
			ManifoldEcho[1],
			1
		],
		Example[{Basic,"ManifoldEcho with an input expression and label, returns the expression:"},
			ManifoldEcho[1, "one"],
			1
		],
		Example[{Basic,"ManifoldEcho with an input expression, label, and function, outside of $ManifoldRunTime, returns the expression:"},
			Block[
				{ECL`$ManifoldRunTime = False},
				ManifoldEcho[1, "one"]
			],
			1
		]
	}
];
