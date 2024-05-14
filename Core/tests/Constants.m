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

(* ::Section:: *)
(*End Test Package*)
