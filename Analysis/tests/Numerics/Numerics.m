(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Numerics: Tests*)


(* ::Section::Closed:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Domain and Range*)


(* ::Subsubsection::Closed:: *)
(*selectInDomain*)


DefineTests[selectInDomain, {
	Example[{Basic, "Select coordinates with x value within 'domain' from 'originalCoordinates':"},
		selectInDomain[originalCoordinates, {6.04, 14.83}],
		{{6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],
	
	Example[{Options, Inclusive, "Not select coordinates with same x value as the right boundary of restriction domain:"},
		selectInDomain[originalCoordinates, {6.04, 14.83}, Inclusive -> Left],
		{{6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}}
	],

	Example[{Options, Inclusive, "Not select coordinates with same x value as the left boundary of restriction domain:"},
		selectInDomain[originalCoordinates, {6.04, 14.83}, Inclusive -> Right],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],

	Example[{Options, Inclusive, "Not select coordinates with same x value as the boundary of restriction domain:"},
		selectInDomain[originalCoordinates, {6.04, 14.83}, Inclusive -> None],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}}
	]	
},
Variables :> {originalCoordinates},
SetUp :> {
	originalCoordinates = {{2.82, 12.99}, {3.59, 13.24}, {6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}, {15.35, 25.60}, {18.69, 27.37}, {20.14, 30.69}}
}
];


(* ::Subsubsection::Closed:: *)
(*selectInRange*)


DefineTests[selectInRange, {
	Example[{Basic, "Select coordinates with y value within 'domain' from 'originalCoordinates':"},
		selectInRange[originalCoordinates, {16.47, 23.05}],
		{{6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],
	
	Example[{Options, Inclusive, "Not select coordinates with same y value as the right boundary of restriction domain:"},
		selectInRange[originalCoordinates, {16.47, 23.05}, Inclusive -> Left],
		{{6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}}
	],

	Example[{Options, Inclusive, "Not select coordinates with same y value as the left boundary of restriction domain:"},
		selectInRange[originalCoordinates, {16.47, 23.05}, Inclusive -> Right],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],

	Example[{Options, Inclusive, "Not select coordinates with same y value as the boundary of restriction domain:"},
		selectInRange[originalCoordinates, {16.47, 23.05}, Inclusive -> None],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}}
	]	
},
Variables :> {originalCoordinates},
SetUp :> {
	originalCoordinates = {{2.82, 12.99}, {3.59, 13.24}, {6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}, {15.35, 25.60}, {18.69, 27.37}, {20.14, 30.69}}
}
];


(* ::Subsubsection::Closed:: *)
(*selectInDomainAndRange*)


DefineTests[selectInDomainAndRange, {
	Example[{Basic, "Select coordinates with x value within 'domain' from 'originalCoordinates':"},
		selectInDomainAndRange[originalCoordinates, {6.04, 14.83}, {17.36, 27.37}],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],
	
	Example[{Options, DomainInclusive, "Not select coordinates with same x value as the right boundary of restriction domain:"},
		selectInDomainAndRange[originalCoordinates, {6.04, 14.83}, {17.36, 27.37}, DomainInclusive -> Left],
		{{7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}}
	],

	Example[{Options, RangeInclusive, "Not select coordinates with same y value as the left boundary of restriction range:"},
		selectInDomainAndRange[originalCoordinates, {6.04, 14.83}, {17.36, 27.37}, RangeInclusive -> Right],
		{{10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	],

	Example[{Options, RangeInclusive, "Not select coordinates with same y value as the boundary of restriction range, but select coordinates with the same x value as the boundary of restriction domain:"},
		selectInDomainAndRange[originalCoordinates, {6.04, 14.83}, {17.36, 27.37}, DomainInclusive -> All, RangeInclusive -> None],
		{{10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}}
	]	
},
Variables :> {originalCoordinates},
SetUp :> {
	originalCoordinates = {{2.82, 12.99}, {3.59, 13.24}, {6.04, 16.47}, {7.03, 17.36}, {10.29, 19.27}, {12.84, 22.88}, {14.83, 23.05}, {15.35, 25.60}, {18.69, 27.37}, {20.14, 30.69}}
}
];


(* ::Subsubsection::Closed:: *)
(*selectInInterval*)


DefineTests[selectInInterval, {
	Example[{Basic, "Select coordinates with y value within 'domain' from 'originalCoordinates':"},
		selectInInterval[originalList, {6.04, 14.83}],
		{6.04, 7.03, 10.29, 12.84, 14.83}
	],
	
	Example[{Options, Inclusive, "Not select coordinates with same y value as the right boundary of restriction domain:"},
		selectInInterval[originalList, {6.04, 14.83}, Inclusive -> Left],
		{6.04, 7.03, 10.29, 12.84}
	],

	Example[{Options, Inclusive, "Not select coordinates with same y value as the left boundary of restriction domain:"},
		selectInInterval[originalList, {6.04, 14.83}, Inclusive -> Right],
		{7.03, 10.29, 12.84, 14.83}
	],

	Example[{Options, Inclusive, "Not select coordinates with same y value as the boundary of restriction domain:"},
		selectInInterval[originalList, {6.04, 14.83}, Inclusive -> None],
		{7.03, 10.29, 12.84}
	]	
},
Variables :> {originalList},
SetUp :> {
	originalList = {2.82, 3.59, 6.04, 7.03, 10.29, 12.84, 14.83, 15.35, 18.69, 20.14}
}
];


(* ::Section:: *)
(*End Test Package*)
