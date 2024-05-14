(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Graphics: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Graphics Testing*)


(* ::Subsubsection::Closed:: *)
(*ValidGraphicsQ*)


DefineTests[ValidGraphicsQ, {
	Example[{Basic, "A valid Disk graphic:"},
		ValidGraphicsQ@Graphics[Disk[]],
		True
	],
	Example[{Basic, "A string is not a valid graphic:"},
		ValidGraphicsQ[Graphics["hi"]],
		False
	],
	Example[{Basic, "A valid ListPlot:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}]]],
		True
	],
	Example[{Basic, "ListPlot with invalid epilog:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], Epilog -> "hi"]],
		False
	],
	Example[{Basic, "Check options of the graphic:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], PlotLabel -> "TITLE"], PlotLabel -> "TITLE"],
		True
	],
	Example[{Additional, "Check a list of graphics options:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], PlotLabel -> "TITLE", PlotRange -> {{0, 1}, {2, 4}}], {PlotLabel -> "TITLE", PlotRange -> {{0, 1}, {2, 4}}}],
		True
	],
	Example[{Additional, "Return False if graphics options don't match:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], PlotLabel -> "TITLE"], PlotLabel -> "NOT TITLE"],
		False
	],
	Example[{Messages, "InvalidOptions", "Return False if given unknown graphics option:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], PlotLabel -> "TITLE"], {PlotLabel -> "TITLE", FakeOption -> True}],
		True,
		Messages :> {ValidGraphicsQ::InvalidOptions}
	],
	Example[{Additional, "ListPlot with valid epilog:"},
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], Epilog -> Point[{0, 0}]]],
		True
	],
	Test["Emerald's plot with bad epilog:",
		ValidGraphicsQ[PlotObject[RandomReal[{-1, 1}, {10, 2}], Epilog -> "hi"]],
		False
	],
	Test["Emerald's plot with valid graphic:",
		ValidGraphicsQ[PlotObject[RandomReal[{-1, 1}, {10, 2}], Epilog -> Point[{0, 0}]]],
		True
	],
	Test["ListPlot with invalid Prolog:",
		ValidGraphicsQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], Prolog -> "hi"]],
		False
	],
	Test["String is not a graphic:",
		ValidGraphicsQ["hi"],
		False
	],
	Test["Integer is not a graphic:",
		ValidGraphicsQ[3],
		False
	],
	Example[{Additional, "A valid 3D plot:"},
		ValidGraphicsQ[ListPointPlot3D[{{1, 2 , 3}}]],
		True
	],
	Example[{Additional, "An invalid 3D plot:"},
		ValidGraphicsQ[ListPointPlot3D[{{1, 2, 3}}, Epilog -> horse]],
		False,
		Messages :> {}
	],
	Example[{Attributes, Listable, "Works on a list of inputs:"},
		ValidGraphicsQ[{3, ListPlot[RandomReal[{-1, 1}, {10, 2}]]}],
		{False, True}
	]
}];



DefineTests[ValidGraphicsP, {
	Example[{Basic, "A valid Disk graphic:"},
		MatchQ[Graphics[Disk[]], ValidGraphicsP[]],
		True
	],
	Example[{Basic, "A string is not a valid graphic:"},
		MatchQ["hi", ValidGraphicsP[]],
		False
	],
	Example[{Additional, "Check a list of graphics options:"},
		MatchQ[ListPlot[RandomReal[{-1, 1}, {10, 2}], PlotLabel -> "TITLE", PlotRange -> {{0, 1}, {2, 4}}], ValidGraphicsP[{PlotLabel -> "TITLE", PlotRange -> {{0, 1}, {2, 4}}}]],
		True
	]
}];

(* ::Subsection::Closed:: *)
(*Graphics Option Helpers*)


(* ::Subsubsection::Closed:: *)
(*EmeraldPlotMarkers*)


DefineTests[EmeraldPlotMarkers,
	{
		Example[
			{Basic, "All plot markers:"},
			EmeraldPlotMarkers[],
			{_String..}
		],
		Example[
			{Applications, "Use plot markers in plot:"},
			ListPlot[({{#1, 1}}&) /@ Range[10], PlotMarkers -> EmeraldPlotMarkers[]],
			_?ValidGraphicsQ
		],
		Example[
			{Applications, "Use plot markers in plot:"},
			ListPlot[{{{1, 1}, {2, 1}, {3, 1}}, {{1, 2}, {2, 2}, {3, 2}}}, PlotMarkers -> EmeraldPlotMarkers[]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic, "Plot marker at specific index:"},
			EmeraldPlotMarkers[3],
			"\[FilledDiamond]"
		],
		Example[
			{Basic, "Wraps around given index larger than number of unique markers:"},
			EmeraldPlotMarkers[13],
			"\[FilledDiamond]"
		],
		Example[
			{Basic, "Plot markers at specific indicies:"},
			EmeraldPlotMarkers[{1, 5, 6, 8, 11, 12, 13, 33}],
			{"\[FilledCircle]", "\[FilledDownTriangle]", "\[EmptyCircle]", "\[EmptyDiamond]", "\[FilledCircle]", "\[FilledSquare]", "\[FilledDiamond]", "\[FilledDiamond]"}
		]
	}];


(* ::Subsubsection::Closed:: *)
(*ColorFade*)


DefineTests[ColorFade, {
	Example[{Basic, "Generate colors fading from dark blue to light blue:"},
		ColorFade[Blue, 4],
		N@{RGBColor[0, 0, 2 / 5], RGBColor[0, 0, 4 / 5], RGBColor[1 / 5, 1 / 5, 1], RGBColor[3 / 5, 3 / 5, 1]}
	],

	Example[{Basic, "Generate colors fading from blue to red:"},
		ColorFade[{Blue, Red}, 4],
		N@{RGBColor[0, 0, 1], RGBColor[1 / 3, 0, 2 / 3], RGBColor[2 / 3, 0, 1 / 3], RGBColor[1, 0, 0]}
	],
	Example[{Basic, "Generate colors fading from blue to red to green:"},
		Grid[{Graphics[{#, Disk[]}]& /@ ColorFade[{Blue, Red, Green}, 6]}],
		Grid[{{ValidGraphicsP[], ValidGraphicsP[], ValidGraphicsP[], ValidGraphicsP[], ValidGraphicsP[], ValidGraphicsP[]}}]
	],
	Example[{Applications, "Use ColorFade to generate colors for lines on a plot:"},
		Plot[{.5 * x^2, x^2, 1.5x^2, 3x^2, 6x^2, 15x^2}, {x, -1, 1}, PlotStyle -> ({Thickness[0.02], #}& /@ ColorFade[Red, 6]), PlotRange -> {{-1, 1}, {0, 2}}],
		_?ValidGraphicsQ
	],
	Test["Fade over 4 colors:", ColorFade[{Blue, Red, Green, Yellow}, 6], {Repeated[_RGBColor, {6}]}],
	Test["Single value, two colors:", ColorFade[{Blue, Red}, 1], N@{RGBColor[1 / 2, 0, 1 / 2]}],
	Test["Single value, single color:", ColorFade[{Blue}, 1], N@{RGBColor[0, 0, 1]}]
}];


(* ::Subsubsection::Closed:: *)
(*fillingFade*)


DefineTests[
	fillingFade,
	{
		Example[
			{Basic, "Generates a list of 'n' filling style colors that fade from the red to blue:"},
			With[{plots=Table[y Sin[x], {y, 1, 10}]}, Plot[plots, {x, 0, 10}, PlotStyle -> ColorFade[{Red, Blue}, 10], Filling -> 0, FillingStyle -> fillingFade[{Red, Blue}, 10]]],
			ValidGraphicsP[]
		],
		Example[
			{Basic, "Generates a list of 'n' filling style colors that fade from a draker color to a lighter color:"},
			With[{plots=Table[y Sin[x], {y, 1, 5}]}, Plot[plots, {x, 0, 10}, PlotStyle -> ColorFade[Red, 5], Filling -> 0, FillingStyle -> fillingFade[Red, 5]]],
			ValidGraphicsP[]
		],
		Example[
			{Options, Opacity, "Generates a list of 'n' filling style colors that fade from a draker color to a lighter color with less opacity:"},
			With[{plots=Table[y Sin[x], {y, 1, 3}]}, Plot[plots, {x, 0, 10}, PlotStyle -> ColorFade[{Red, Blue}, 3], Filling -> 0, FillingStyle -> fillingFade[{Red, Blue}, 3, Opacity -> 0.5]]],
			ValidGraphicsP[]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*EmeraldFrameTicks*)


DefineTests[
	EmeraldFrameTicks,
	{
		Example[
			{Basic, "Automatically generates frame ticks using the provided start and end points for the ticks:"},
			EmeraldFrameTicks[{0, 10}],
			{{0, 0.`, {0.01`, 0}}, {2, 2.`, {0.01`, 0}}, {4, 4.`, {0.01`, 0}}, {6, 6.`, {0.01`, 0}}, {8, 8.`, {0.01`, 0}}, {10, 10.`, {0.01`, 0}}, {0, "", {0.005`, 0}},
				{2 / 5, "", {0.005`, 0}}, {4 / 5, "", {0.005`, 0}}, {6 / 5, "", {0.005`, 0}}, {8 / 5, "", {0.005`, 0}}, {2, "", {0.005`, 0}}, {12 / 5, "", {0.005`, 0}}, {14 / 5, "",
				{0.005`, 0}}, {16 / 5, "", {0.005`, 0}}, {18 / 5, "", {0.005`, 0}}, {4, "", {0.005`, 0}}, {22 / 5, "", {0.005`, 0}}, {24 / 5, "", {0.005`, 0}}, {26 / 5, "", {0.005`, 0}},
				{28 / 5, "", {0.005`, 0}}, {6, "", {0.005`, 0}}, {32 / 5, "", {0.005`, 0}}, {34 / 5, "", {0.005`, 0}}, {36 / 5, "", {0.005`, 0}}, {38 / 5, "", {0.005`, 0}}, {8, "", {0.005`, 0}},
				{42 / 5, "", {0.005`, 0}}, {44 / 5, "", {0.005`, 0}}, {46 / 5, "", {0.005`, 0}}, {48 / 5, "", {0.005`, 0}}, {10, "", {0.005`, 0}}}
		],
		Example[
			{Basic, "Automatically generates frame ticks using the provided start and end points for the ticks positions, and the start and end Label for the text labels:"},
			EmeraldFrameTicks[{0, 100}, {0, 10}],
			{{0, 0.`, {0.01`, 0}}, {20, 2.`, {0.01`, 0}}, {40, 4.`, {0.01`, 0}}, {60, 6.`, {0.01`, 0}}, {80, 8.`, {0.01`, 0}}, {100, 10.`, {0.01`, 0}}, {0, "", {0.005`, 0}}, {4, "", {0.005`, 0}},
				{8, "", {0.005`, 0}}, {12, "", {0.005`, 0}}, {16, "", {0.005`, 0}}, {20, "", {0.005`, 0}}, {24, "", {0.005`, 0}}, {28, "", {0.005`, 0}}, {32, "", {0.005`, 0}}, {36, "", {0.005`, 0}},
				{40, "", {0.005`, 0}}, {44, "", {0.005`, 0}}, {48, "", {0.005`, 0}}, {52, "", {0.005`, 0}}, {56, "", {0.005`, 0}}, {60, "", {0.005`, 0}}, {64, "", {0.005`, 0}}, {68, "", {0.005`, 0}},
				{72, "", {0.005`, 0}}, {76, "", {0.005`, 0}}, {80, "", {0.005`, 0}}, {84, "", {0.005`, 0}}, {88, "", {0.005`, 0}}, {92, "", {0.005`, 0}}, {96, "", {0.005`, 0}}, {100, "", {0.005`, 0}}}
		],
		Example[
			{Basic, "Automatically generates frame ticks using the provided start and end points for the ticks positions, and the start and end Label for the text labels and the data being ploted:"},
			EmeraldFrameTicks[{0, 100}, {0, 10}, Table[{x, y}, {x, 0, 10}, {y, 0, 10}]],
			{{0, 0.`, {0.01`, 0}}, {20, 2.`, {0.01`, 0}}, {40, 4.`, {0.01`, 0}}, {60, 6.`, {0.01`, 0}}, {80, 8.`, {0.01`, 0}}, {100, 10.`, {0.01`, 0}}, {0, "", {0.005`, 0}}, {4, "", {0.005`, 0}},
				{8, "", {0.005`, 0}}, {12, "", {0.005`, 0}}, {16, "", {0.005`, 0}}, {20, "", {0.005`, 0}}, {24, "", {0.005`, 0}}, {28, "", {0.005`, 0}}, {32, "", {0.005`, 0}}, {36, "", {0.005`, 0}},
				{40, "", {0.005`, 0}}, {44, "", {0.005`, 0}}, {48, "", {0.005`, 0}}, {52, "", {0.005`, 0}}, {56, "", {0.005`, 0}}, {60, "", {0.005`, 0}}, {64, "", {0.005`, 0}}, {68, "", {0.005`, 0}},
				{72, "", {0.005`, 0}}, {76, "", {0.005`, 0}}, {80, "", {0.005`, 0}}, {84, "", {0.005`, 0}}, {88, "", {0.005`, 0}}, {92, "", {0.005`, 0}}, {96, "", {0.005`, 0}}, {100, "", {0.005`, 0}}}
		],
		Example[
			{Options, MajorTicks, "Automatically generates frame ticks with specified number of major ticks:"},
			EmeraldFrameTicks[{0, 10}, MajorTicks -> 10],
			{{0, 0.`, {0.01`, 0}}, {1, 1.`, {0.01`, 0}}, {2, 2.`, {0.01`, 0}}, {3, 3.`, {0.01`, 0}}, {4, 4.`, {0.01`, 0}}, {5, 5.`, {0.01`, 0}}, {6, 6.`, {0.01`, 0}}, {7, 7.`, {0.01`, 0}}, {8, 8.`, {0.01`, 0}},
				{9, 9.`, {0.01`, 0}}, {10, 10.`, {0.01`, 0}}, {0, "", {0.005`, 0}}, {2 / 5, "", {0.005`, 0}}, {4 / 5, "", {0.005`, 0}}, {6 / 5, "", {0.005`, 0}}, {8 / 5, "", {0.005`, 0}}, {2, "", {0.005`, 0}}, {12 / 5, "", {0.005`, 0}},
				{14 / 5, "", {0.005`, 0}}, {16 / 5, "", {0.005`, 0}}, {18 / 5, "", {0.005`, 0}}, {4, "", {0.005`, 0}}, {22 / 5, "", {0.005`, 0}}, {24 / 5, "", {0.005`, 0}}, {26 / 5, "", {0.005`, 0}}, {28 / 5, "", {0.005`, 0}},
				{6, "", {0.005`, 0}}, {32 / 5, "", {0.005`, 0}}, {34 / 5, "", {0.005`, 0}}, {36 / 5, "", {0.005`, 0}}, {38 / 5, "", {0.005`, 0}}, {8, "", {0.005`, 0}}, {42 / 5, "", {0.005`, 0}}, {44 / 5, "", {0.005`, 0}},
				{46 / 5, "", {0.005`, 0}}, {48 / 5, "", {0.005`, 0}}, {10, "", {0.005`, 0}}}
		],
		Example[
			{Options, MinorTicks, "Automatically generates frame ticks with specified number of minor ticks:"},
			EmeraldFrameTicks[{0, 10}, MinorTicks -> 20],
			{{0, 0.`, {0.01`, 0}}, {2, 2.`, {0.01`, 0}}, {4, 4.`, {0.01`, 0}}, {6, 6.`, {0.01`, 0}}, {8, 8.`, {0.01`, 0}}, {10, 10.`, {0.01`, 0}}, {0, "", {0.005`, 0}}, {1 / 2, "", {0.005`, 0}}, {1, "", {0.005`, 0}},
				{3 / 2, "", {0.005`, 0}}, {2, "", {0.005`, 0}}, {5 / 2, "", {0.005`, 0}}, {3, "", {0.005`, 0}}, {7 / 2, "", {0.005`, 0}}, {4, "", {0.005`, 0}}, {9 / 2, "", {0.005`, 0}}, {5, "", {0.005`, 0}}, {11 / 2, "", {0.005`, 0}},
				{6, "", {0.005`, 0}}, {13 / 2, "", {0.005`, 0}}, {7, "", {0.005`, 0}}, {15 / 2, "", {0.005`, 0}}, {8, "", {0.005`, 0}}, {17 / 2, "", {0.005`, 0}}, {9, "", {0.005`, 0}}, {19 / 2, "", {0.005`, 0}}, {10, "", {0.005`, 0}}}
		],
		Example[
			{Options, MajorTickSize, "Change the size of major ticks:"},
			EmeraldFrameTicks[{0, 10}, MajorTickSize -> 0.05],
			{{0, 0.`, {0.05`, 0}}, {2, 2.`, {0.05`, 0}}, {4, 4.`, {0.05`, 0}}, {6, 6.`, {0.05`, 0}}, {8, 8.`, {0.05`, 0}}, {10, 10.`, {0.05`, 0}}, {0, "", {0.005`, 0}}, {2 / 5, "", {0.005`, 0}}, {4 / 5, "", {0.005`, 0}},
				{6 / 5, "", {0.005`, 0}}, {8 / 5, "", {0.005`, 0}}, {2, "", {0.005`, 0}}, {12 / 5, "", {0.005`, 0}}, {14 / 5, "", {0.005`, 0}}, {16 / 5, "", {0.005`, 0}}, {18 / 5, "", {0.005`, 0}}, {4, "", {0.005`, 0}},
				{22 / 5, "", {0.005`, 0}}, {24 / 5, "", {0.005`, 0}}, {26 / 5, "", {0.005`, 0}}, {28 / 5, "", {0.005`, 0}}, {6, "", {0.005`, 0}}, {32 / 5, "", {0.005`, 0}}, {34 / 5, "", {0.005`, 0}}, {36 / 5, "", {0.005`, 0}},
				{38 / 5, "", {0.005`, 0}}, {8, "", {0.005`, 0}}, {42 / 5, "", {0.005`, 0}}, {44 / 5, "", {0.005`, 0}}, {46 / 5, "", {0.005`, 0}}, {48 / 5, "", {0.005`, 0}}, {10, "", {0.005`, 0}}}
		],
		Example[
			{Options, MinorTickSize, "Change the size of minor ticks:"},
			EmeraldFrameTicks[{0, 10}, MinorTickSize -> 0.01],
			{{0, 0.`, {0.01`, 0}}, {2, 2.`, {0.01`, 0}}, {4, 4.`, {0.01`, 0}}, {6, 6.`, {0.01`, 0}}, {8, 8.`, {0.01`, 0}}, {10, 10.`, {0.01`, 0}}, {0, "", {0.01`, 0}}, {2 / 5, "", {0.01`, 0}}, {4 / 5, "", {0.01`, 0}},
				{6 / 5, "", {0.01`, 0}}, {8 / 5, "", {0.01`, 0}}, {2, "", {0.01`, 0}}, {12 / 5, "", {0.01`, 0}}, {14 / 5, "", {0.01`, 0}}, {16 / 5, "", {0.01`, 0}}, {18 / 5, "", {0.01`, 0}}, {4, "", {0.01`, 0}}, {22 / 5, "", {0.01`, 0}},
				{24 / 5, "", {0.01`, 0}}, {26 / 5, "", {0.01`, 0}}, {28 / 5, "", {0.01`, 0}}, {6, "", {0.01`, 0}}, {32 / 5, "", {0.01`, 0}}, {34 / 5, "", {0.01`, 0}}, {36 / 5, "", {0.01`, 0}}, {38 / 5, "", {0.01`, 0}}, {8, "", {0.01`, 0}},
				{42 / 5, "", {0.01`, 0}}, {44 / 5, "", {0.01`, 0}}, {46 / 5, "", {0.01`, 0}}, {48 / 5, "", {0.01`, 0}}, {10, "", {0.01`, 0}}}
		],
		Example[
			{Options, Log, "Use log ticks:"},
			EmeraldFrameTicks[{0, Log[E, E^10]}, Log -> E],
			{{0, 1.`, {0.01`, 0}}, {2, 7.39`, {0.01`, 0}}, {4, 54.6`, {0.01`, 0}}, {6, 403.`, {0.01`, 0}}, {8, 2980.`, {0.01`, 0}}, {10, 22000.`, {0.01`, 0}}, {1, "", {0.005`, 0}}, {3 / 2, "", {0.005`, 0}},
				{7 / 4, "", {0.005`, 0}}, {15 / 8, "", {0.005`, 0}}, {31 / 16, "", {0.005`, 0}}, {3, "", {0.005`, 0}}, {7 / 2, "", {0.005`, 0}}, {15 / 4, "", {0.005`, 0}}, {31 / 8, "", {0.005`, 0}}, {63 / 16, "", {0.005`, 0}},
				{5, "", {0.005`, 0}}, {11 / 2, "", {0.005`, 0}}, {23 / 4, "", {0.005`, 0}}, {47 / 8, "", {0.005`, 0}}, {95 / 16, "", {0.005`, 0}}, {7, "", {0.005`, 0}}, {15 / 2, "", {0.005`, 0}}, {31 / 4, "", {0.005`, 0}},
				{63 / 8, "", {0.005`, 0}}, {127 / 16, "", {0.005`, 0}}, {9, "", {0.005`, 0}}, {19 / 2, "", {0.005`, 0}}, {39 / 4, "", {0.005`, 0}}, {79 / 8, "", {0.005`, 0}}, {159 / 16, "", {0.005`, 0}}}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FullPlotRange*)


DefineTests[
	FullPlotRange,
	{
		Example[
			{Basic, "Expands a single PlotRange option symbol into a list of x and y limits:"},
			FullPlotRange[Automatic],
			{{Automatic, Automatic}, {Automatic, Automatic}}
		],
		Example[
			{Basic, "When given two PlotRange option symbols, expands the first to specify the x-limits and the second to specify the y-limits:"},
			FullPlotRange[{Full, All}],
			{{Full, Full}, {All, All}}
		],
		Example[
			{Basic, "Accepts an expanded range for one axis and a symbol for the other and expands just the unspecified range:"},
			FullPlotRange[{{1, 2}, Automatic}],
			{{1, 2}, {Automatic, Automatic}}
		],
		Example[
			{Basic, "Can accept ranges that specify date intervals:"},
			FullPlotRange[{{DateObject[{2000, 1, 1}], DateObject[{2010, 1, 1}]}, Full}],
			{{DateObject[{2000, 1, 1}], DateObject[{2010, 1, 1}]}, {Full, Full}}
		],
		Test["A fully expanded input is returned in the same form:",
			FullPlotRange[{{1, 2}, {3, 4}}],
			{{1, 2}, {3, 4}}
		],
		Test["Accepts a PlotRange option in the ymax position:",
			{{1, 2}, {3, Automatic}} // FullPlotRange,
			{{1, 2}, {3, Automatic}}
		],
		Test["Accepts a PlotRange option in the ymin position:",
			{{1, 2}, {Automatic, 4}} // FullPlotRange,
			{{1, 2}, {Automatic, 4}}
		],
		Test["Accepts a PlotRange option in the xmax position:",
			{{1, Automatic}, {2, 4}} // FullPlotRange,
			{{1, Automatic}, {2, 4}}
		],
		Test["Accepts a PlotRange option in the xmin position:",
			{{Automatic, 3}, {2, 4}} // FullPlotRange,
			{{Automatic, 3}, {2, 4}}
		],
		Test["Accepts a PlotRange option in the xmin amd xmax position:",
			{{Automatic, Automatic}, {2, 4}} // FullPlotRange,
			{{Automatic, Automatic}, {2, 4}}
		],
		Test["Expands the x-range when given as a single option, leaving the fully specified y-range untouched:",
			{Automatic, {2, 4}} // FullPlotRange,
			{{Automatic, Automatic}, {2, 4}}
		],
		Test["Expands the x-range when given as a single option in a list, leaving the fully specified y-range untouched:",
			{{Automatic}, {2, 4}} // FullPlotRange,
			{{Automatic, Automatic}, {2, 4}}
		],
		Test["Expands the y-range when given as a single option in a list, leaving the fully specified x-range untouched:",
			{{1, 2}, {Automatic}} // FullPlotRange,
			{{1, 2}, {Automatic, Automatic}}
		],
		Test["Expands the y-range when given as a single option in a list, leaving the fully specified x-range untouched. The x-range may contain PlotRange options:",
			{{1, Automatic}, {Automatic}} // FullPlotRange,
			{{1, Automatic}, {Automatic, Automatic}}
		],
		Test["When given two PlotRange options, expands the first to fully specify the x-limits and the second to fully specify the y-limits:",
			{Automatic, Full} // FullPlotRange,
			{{Automatic, Automatic}, {Full, Full}}
		],
		Test["When specifying one option for x and one for y, the options may be given as a list of lists:",
			{{Automatic}, {Full}} // FullPlotRange,
			{{Automatic, Automatic}, {Full, Full}}
		],
		Test["Uses a single option to specify the x and y ranges:",
			Automatic // FullPlotRange,
			{{Automatic, Automatic}, {Automatic, Automatic}}
		],
		Test["Uses a single option given in a list to specify the x and y ranges:",
			{Automatic} // FullPlotRange,
			{{Automatic, Automatic}, {Automatic, Automatic}}
		],
		Test["Returns unevaluated if the input is not a combination of valid PlotRange options:",
			FullPlotRange[Taco],
			_FullPlotRange
		]
	}
];


(* ::Subsection::Closed:: *)
(*Option Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolvePlotLegends*)


DefineTests[resolvePlotLegends, {
	Example[{Basic, "Specification for a plot legend:"},
		resolvePlotLegends[{"A", "B", "C"}],
		Placed[LineLegend[{Style["A", 12], Style["B", 12], Style["C", 12]}, LegendMarkers -> Automatic], Bottom]
	],
	Example[{Basic, "Place the legend in a plot:"},
		Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}]],
		_?Core`Private`ValidLegendedQ
	],
	Example[{Basic, "Use an image as the legend label:"},
		ListLinePlot[Table[{x, x^2}, {x, 1, 10}], PlotLegends -> resolvePlotLegends[{Import["ExampleData/ocelot.jpg"]}]],
		_?Core`Private`ValidLegendedQ
	],
	Example[{Basic, "Use a graphic as the legend label:"},
		Plot[{Sqrt[4 - x^2], -Sqrt[4 - x^2]}, {x, -4, 4}, PlotLegends -> resolvePlotLegends[{Graphics[Circle[{2, 0}, .01]]}]],
		_?Core`Private`ValidLegendedQ
	],

	(*
	Example[{Basic,"Associate a legend with a graphics object:"},
		Module[{graphics,legend},
			graphics = Graphics[{{ColorData[97][1],Disk[{0,0},1]},{ColorData[97][2],Disk[{1,0},1]},{ColorData[97][3],Disk[{2,0},1]}}];
			legend = resolvePlotLegends[{"First","Second","Third"}];
			Legended[graphics,legend]
		],
		_?Core`Private`ValidLegendedQ
	],
*)

	Example[{Options, Orientation, "Specification to place legend to the right of plot:"},
		resolvePlotLegends[{"A", "B", "C"}, Orientation -> Row],
		Placed[LineLegend[{Style["A", 12], Style["B", 12], Style["C", 12]}, LegendMarkers -> Automatic], Right]
	],
	Example[{Options, Orientation, "Place the legend to the right of plot:"},
		Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}, Orientation -> Row]],
		_?Core`Private`ValidLegendedQ
	],
	Example[{Options, LegendColors, "Directly specify the colors of the legend lines:"},
		Plot[{x, x^2, x^3}, {x, -1, 1}, ColorFunction -> "BlueGreenYellow", PlotLegends -> resolvePlotLegends[{"A", "B", "C"}, Orientation -> Row, LegendColors -> {Blue, Green, Yellow}]],
		_?Core`Private`ValidLegendedQ
	],

	Example[{Options, Boxes, "Specification to use swatch boxes in legend:"},
		resolvePlotLegends[{"A", "B", "C"}, Boxes -> True],
		Placed[SwatchLegend[{Style["A", 12], Style["B", 12], Style["C", 12]}, LegendMarkers -> Automatic], Bottom]
	],
	Example[{Options, Boxes, "Use swatch boxes in the legend:"},
		Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}, Boxes -> True]],
		_?Core`Private`ValidLegendedQ
	],

	Example[{Options, PlotMarkers, "Specification to use smiley faces as legend markers:"},
		resolvePlotLegends[{"A", "B", "C"}, Boxes -> True, PlotMarkers -> {{"\[SadSmiley]", 40}, {"\[NeutralSmiley]", 40}, {"\[HappySmiley]", 40}}],
		Placed[SwatchLegend[{Style["A", 12], Style["B", 12], Style["C", 12]}, LegendMarkers -> {{"\[SadSmiley]", 40}, {"\[NeutralSmiley]", 40}, {"\[HappySmiley]", 40}}], Bottom]
	],
	Example[{Options, PlotMarkers, "Use smiley face legend markers:"},
		Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}, Boxes -> True, PlotMarkers -> {{"\[SadSmiley]", 40}, {"\[NeutralSmiley]", 40}, {"\[HappySmiley]", 40}}]],
		_?Core`Private`ValidLegendedQ
	]
}];


(* ::Subsection:: *)
(*Graphics Primitives*)


(* ::Subsection::Closed:: *)
(*Plot Epilogs*)


(* ::Subsubsection::Closed:: *)
(*ErrorBar*)


DefineTests[
	ErrorBar,
	{
		Example[
			{Basic, "Draw a vertical Error bar for a list of real numbers according to its mean and standard deviation:"},
			ErrorBar[{{1, 39.14193277812586`}, 2.0494530370490853`}],
			{_?ColorQ, Line[{{1, 41.19138581517495`}, {1, 37.09247974107678`}}], Line[{{1.015`, 41.19138581517495`}, {0.985`, 41.19138581517495`}}], Line[{{1.015`, 37.09247974107678`}, {0.985`, 37.09247974107678`}}]}
		],
		Example[
			{Basic, "Draw a vertical Error bar for  a list of data according to its mean and standard deviation:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}],
			{_?ColorQ, Line[{{1, 3}, {1, 1}}], Line[{{1.015`, 3}, {0.985`, 3}}], Line[{{1.015`, 1}, {0.985`, 1}}]}
		],
		Example[
			{Basic, "The output from ErrorBar can be used to produce a graphic:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}];
			Graphics[{GrayLevel[0], Line[{{1, 3}, {1, 1}}], Line[{{1.015`, 3}, {0.985`, 3}}], Line[{{1.015`, 1}, {0.985`, 1}}]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options, PlotRange, "Draw a vertical Error bar for a list of integers given a specific PlotRange:"},
			ErrorBar[{{1, Mean[{3, 2, 5, 5, 3, 6, 2, 10, 0, 10}]}, StandardDeviation[{3, 2, 5, 5, 3, 6, 2, 10, 0, 10}]},
				PlotRange -> {{5, 10}, {5, 8}}],
			{_?ColorQ, Line[{{1, 23 / 5 + Sqrt[502 / 5] / 3}, {1, 23 / 5 - Sqrt[502 / 5] / 3}}], Line[{{1.075`, 23 / 5 + Sqrt[502 / 5] / 3}, {0.925`, 23 / 5 + Sqrt[502 / 5] / 3}}], Line[{{1.075`, 23 / 5 - Sqrt[502 / 5] / 3}, {0.925`, 23 / 5 - Sqrt[502 / 5] / 3}}]}
		],
		Example[
			{Options, Ticks, "Draw a vertical Error bar for a list of integers with a specified size of end mark ticks:"},
			ErrorBar[{{1, Mean[{3, 2, 5, 5, 3, 6, 2, 10, 0, 10}]}, StandardDeviation[{3, 2, 5, 5, 3, 6, 2, 10, 0, 10}]},
				Ticks -> 0.50],
			{_?ColorQ, Line[{{1, 23 / 5 + Sqrt[502 / 5] / 3}, {1, 23 / 5 - Sqrt[502 / 5] / 3}}], Line[{{1.25`, 23 / 5 + Sqrt[502 / 5] / 3}, {0.75`, 23 / 5 + Sqrt[502 / 5] / 3}}], Line[{{1.25`, 23 / 5 - Sqrt[502 / 5] / 3}, {0.75`, 23 / 5 - Sqrt[502 / 5] / 3}}]}
		],
		Example[
			{Options, Orientation, "Draw a horizontal Error bar for a list data:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}, Orientation -> Horizontal],
			{_?ColorQ, Line[{{0, 2}, {2, 2}}], Line[{{0, 2.015`}, {0, 1.985`}}], Line[{{2, 2.015`}, {2, 1.985`}}]}
		],
		Example[
			{Options, PlotType, "Draw a vertical Error bar based on linear log:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}, PlotType -> LogLinear],
			{_?ColorQ, Line[{{0, 3}, {0, 1}}], Line[{{0.015`, 3}, {-0.015`, 3}}], Line[{{0.015`, 1}, {-0.015`, 1}}]}
		],
		Example[
			{Options, Log, "Draw a vertical Error bar with base of the logrithm changed to 10:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}, PlotType -> LinearLog, Log -> 10],
			{_?ColorQ, Line[{{1, Log[3] / Log[10]}, {1, 0}}], Line[{{1.015`, Log[3] / Log[10]}, {0.985`, Log[3] / Log[10]}}], Line[{{1.015`, 0}, {0.985`, 0}}]}
		],
		Example[
			{Options, Color, "Change the color of the error bar:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}, Color -> ColorData[16, 10]],
			{_?ColorQ, Line[{{1, 3}, {1, 1}}], Line[{{1.015`, 3}, {0.985`, 3}}], Line[{{1.015`, 1}, {0.985`, 1}}]}
		],
		Example[
			{Options, TickUnit, "Change the TickUnit to Minute:"},
			ErrorBar[{{1, Mean[{1, 2, 3}]}, StandardDeviation[{1, 2, 3}]}, Color -> ColorData[16, 10], TickUnit -> Minute],
			{_?ColorQ, Line[{{1, 3}, {1, 1}}], Line[{{1.015`, 3}, {0.985`, 3}}], Line[{{1.015`, 1}, {0.985`, 1}}]}
		]
	}
];


(* ::Subsubsection:: *)
(*AxisLines*)


DefineTests[
	AxisLines,
	{
		Example[
			{Basic, "Draw lines from peak points to axes:"},
			AxisLines[{{500, 20}, {1000, 200}, {2000, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}],
			{
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{500, 20}, {-200, 20}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{500, 20}, {500, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {500, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{1000, 200}, {-200, 200}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 200}, {Left, Center}], Line[{{1000, 200}, {1000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {1000, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{2000, 350}, {-200, 350}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{2000, 350}, {2000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {2000, -50}, {Center, Bottom}], Null}
			}

		],
		Example[
			{Basic, "Draw lines from a pair of peak points to axes:"},
			AxisLines[{{500, 20}, {0, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}],
			{
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{500, 20}, {-200, 20}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{500, 20}, {500, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {500, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{0, 350}, {-200, 350}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{0, 350}, {0, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {0, -50}, {Center, Bottom}], Null}
			}
		],
		Example[
			{Basic, "The output from AxisLines can be used to produce a graphic:"},
			Hold[AxisLines[{{500, 20}, {0, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}]];
			Graphics[
				List[List[RGBColor[0.`, 0.5`, 1.`], Dashing[List[Small, Small]],
					Thickness[Tiny], Line[List[List[500, 20], List[-200, 20]]],
					Text[Style["20.", Rule[LineColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[FrontFaceColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[BackFaceColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[GraphicsColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[FontFamily, "Arial"], Rule[FontSize, 18],
						Rule[FontWeight, Bold], Rule[FontColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[Background, Directive[GrayLevel[1], Opacity[0.75`]]]],
						List[0, 20], List[Left, Center]],
					Line[List[List[500, 20], List[500, -2150]]],
					Text[Style["500.", Rule[LineColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[FrontFaceColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[BackFaceColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[GraphicsColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[FontFamily, "Arial"], Rule[FontSize, 18],
						Rule[FontWeight, Bold], Rule[FontColor, RGBColor[0.`, 0.5`, 1.`]],
						Rule[Background, Directive[GrayLevel[1], Opacity[0.75`]]]],
						List[500, -50], List[Center, Bottom]], Null],
					List[RGBColor[0.`, 0.5`, 1.`], Dashing[List[Small, Small]],
						Thickness[Tiny], Line[List[List[0, 350], List[-200, 350]]],
						Text[Style["350.", Rule[LineColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[FrontFaceColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[BackFaceColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[GraphicsColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[FontFamily, "Arial"], Rule[FontSize, 18],
							Rule[FontWeight, Bold], Rule[FontColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[Background, Directive[GrayLevel[1], Opacity[0.75`]]]],
							List[0, 350], List[Left, Center]],
						Line[List[List[0, 350], List[0, -2150]]],
						Text[Style["0.", Rule[LineColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[FrontFaceColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[BackFaceColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[GraphicsColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[FontFamily, "Arial"], Rule[FontSize, 18],
							Rule[FontWeight, Bold], Rule[FontColor, RGBColor[0.`, 0.5`, 1.`]],
							Rule[Background, Directive[GrayLevel[1], Opacity[0.75`]]]],
							List[0, -50], List[Center, Bottom]], Null]]
			],
			_?ValidGraphicsQ
		],
		Example[
			(* Note that this option is never used in the actual function. Hence changing the value of PeakPointSize has no effect*)
			{Options, PeakPointSize, "Increase the size of peak point by 2:"},
			AxisLines[{{500, 20}, {1000, 200}, {2000, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}, PeakPointSize -> 0.030],
			{
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{500, 20}, {-200, 20}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{500, 20}, {500, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {500, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{1000, 200}, {-200, 200}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 200}, {Left, Center}], Line[{{1000, 200}, {1000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {1000, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{2000, 350}, {-200, 350}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{2000, 350}, {2000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {2000, -50}, {Center, Bottom}], Null}
			}
		],
		Example[
			{Options, PeakPointColor, "Change the color of peak points:"},
			AxisLines[{{500, 20}, {1000, 200}, {2000, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}, PeakPointColor -> RGBColor[0., 1.0, 0.5]],
			{
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{500, 20}, {-200, 20}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{500, 20}, {500, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {500, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{1000, 200}, {-200, 200}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 200}, {Left, Center}], Line[{{1000, 200}, {1000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {1000, -50}, {Center, Bottom}], Null},
				{_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{2000, 350}, {-200, 350}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{2000, 350}, {2000, -2150}}], Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {2000, -50}, {Center, Bottom}], Null}
			}
		],
		Example[
			{Options, SecondYScaled, "SecondY with duplicated x-values are handled appropriately and do not throw errors:"},
			AxisLines[{{5, 20}, {10, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}, SecondYScaled -> {{0.`, 12.`}, {0.`, 0.`}, {0.1`, 0.`}, {5.`, 12.`}, {50.`, 37.`}, {50.1`, 100.`}, {55.`, 100.`}, {55.1`, 12.`}, {60.`, 12.`}}, SecondYUnscaled -> {{0.`, 12.`}, {0.`, 0.`}, {0.1`, 0.`}, {5.`, 12.`}, {50.`, 37.`}, {50.1`, 100.`}, {55.`, 100.`}, {55.1`, 12.`}, {60.`, 12.`}}],
			{
				{
					_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{5, 20}, {-200, 20}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{5, 20}, {5, -2150}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {5, -50}, {Center, Bottom}], {Line[{{5, 20}, {5, 12.`}}], Line[{{5, 12.`}, {300, 12.`}}], PointSize -> 0.00975`, Point[{5, 12.`}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "RightPeakGuideline"], {100, 12.`}, {Right, Center}]}
				},
				{
					_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{10, 350}, {-200, 350}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{10, 350}, {10, -2150}}],
					Text[Style["10.", _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {10, -50}, {Center, Bottom}], {Line[{{10, 350}, {10, 14.777777777777779`}}], Line[{{10, 14.777777777777779`}, {300, 14.777777777777779`}}], PointSize -> 0.00975`, Point[{10, 14.777777777777779`}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "RightPeakGuideline"], {100, 14.777777777777779`}, {Right, Center}]}
				}
			}
		],
		Example[
			{Options, SecondYUnscaled, "SecondY with duplicated x-values are handled appropriately and do not throw errors:"},
			AxisLines[{{5, 20}, {10, 350}}, PlotRange -> {{0, 100}, {-50, 1000}}, SecondYScaled -> {{0.`, 12.`}, {0.`, 0.`}, {0.1`, 0.`}, {5.`, 12.`}, {50.`, 37.`}, {50.1`, 100.`}, {55.`, 100.`}, {55.1`, 12.`}, {60.`, 12.`}}, SecondYUnscaled -> {{0.`, 12.`}, {0.`, 0.`}, {0.1`, 0.`}, {55.`, 100.`}, {55.1`, 12.`}, {60.`, 12.`}}],
			{
				{
					_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{5, 20}, {-200, 20}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 20}, {Left, Center}], Line[{{5, 20}, {5, -2150}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {5, -50}, {Center, Bottom}], {Line[{{5, 20}, {5, 12.`}}], Line[{{5, 12.`}, {300, 12.`}}], PointSize -> 0.00975`, Point[{5, 12.`}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "RightPeakGuideline"], {100, 12.`}, {Right, Center}]}
				},
				{
					_?ColorQ, Dashing[{Small, Small}], Thickness[Tiny], Line[{{10, 350}, {-200, 350}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "LeftPeakGuideline"], {0, 350}, {Left, Center}], Line[{{10, 350}, {10, -2150}}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "BottomPeakGuideline"], {10, -50}, {Center, Bottom}], {Line[{{10, 350}, {10, 14.777777777777779`}}], Line[{{10, 14.777777777777779`}, {300, 14.777777777777779`}}], PointSize -> 0.00975`, Point[{10, 14.777777777777779`}],
					Text[Style[_?StringQ, _?ColorQ, Background -> Directive[GrayLevel[1], Opacity[0.75`]], Bold, 18, FontFamily -> "Arial", "RightPeakGuideline"], {100, 14.777777777777779`}, {Right, Center}]}
				}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*secondYEpilog*)


DefineTests[
	secondYEpilog,
	{
		Example[
			{Basic, "Returns a graphics primative:"},
			Graphics[secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 1000}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}]],
			_Graphics
		],
		Example[
			{Options, Display, "Specifies Conductance will have a line drawn:"},
			Graphics[secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}]],
			_Graphics
		],
		Example[
			{Options, PlotRange, "Specify the PlotRange of the plot which will recieve the epilog:"},
			Graphics[secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}]],
			_Graphics
		],
		Example[
			{Options, Color, "Change the color of the line:"},
			Graphics[secondYEpilog[{{0, 100}, {0, 100}, {20, 50}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}]],
			_Graphics
		],
		Example[
			{Options, Style, "Plot as points, instead of lines:"},
			Graphics[secondYEpilog[{{{0, 100}, {0, 100}, {20, 50}}, {{10, 20}, {25, 30}, {45, 50}}, {{20, 30}, {40, 50}, {60, 70}}}, DataPoints, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Style -> Point]],
			_Graphics
		],
		Test[
			"Returns a graphics primative:",
			secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 1000}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}],
			{GrayLevel[0], Line[{{0, 10}, {100, 20}}]}
		],
		Test[
			"Specifies Conductance will have a line drawn:",
			secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}],
			{GrayLevel[0], Line[{{0, 100}, {100, 200}}]}
		],
		Test[
			"Specify the PlotRange of the plot which will recieve the epilog:",
			secondYEpilog[{{0, 100}, {100, 200}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}],
			{GrayLevel[0], Line[{{0, 100}, {100, 200}}]}
		],
		Test[
			"Change the color of the line:",
			secondYEpilog[{{0, 100}, {0, 100}, {20, 50}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			{RGBColor[1, 0, 0], Line[{{0, 100}, {0, 100}, {20, 50}}]}
		],
		Test[
			"Plot as points, instead of lines:",
			N@secondYEpilog[{{{0, 100}, {0, 100}, {20, 50}}, {{10, 20}, {25, 30}, {45, 50}}, {{20, 30}, {40, 50}, {60, 70}}}, DataPoints, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Style -> Point],
			N@{{RGBColor[1 / 2, 0, 0], Point[{0, 100}], Point[{0, 100}], Point[{20, 50}]}, {RGBColor[1, 0, 0], Point[{10, 20}], Point[{25, 30}], Point[{45, 50}]}, {RGBColor[1, 1 / 2, 1 / 2], Point[{20, 30}], Point[{40, 50}], Point[{60, 70}]}}
		],
		Test[
			"Plot as points, instead of lines:",
			N@secondYEpilog[{{{0, 100}, {0, 100}, {20, 50}}, {{10, 20}, {25, 30}, {45, 50}}, {{20, 30}, {40, 50}, {60, 70}}}, DataPoints, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Style -> Point],
			N@{{RGBColor[1 / 2, 0, 0], Point[{0, 100}], Point[{0, 100}], Point[{20, 50}]}, {RGBColor[1, 0, 0], Point[{10, 20}], Point[{25, 30}], Point[{45, 50}]}, {RGBColor[1, 1 / 2, 1 / 2], Point[{20, 30}], Point[{40, 50}], Point[{60, 70}]}}
		],
		Test[
			"Returns an empty list when the type and the Display option do not match:",
			secondYEpilog[{{0, 100}, {100, 200}}, Pressure, {0, 1000}, PlotRange -> {{0, 100}, {0, 100}}, Display -> {Conductance}],
			{}
		],
		Test[
			"Returns an empty list when the plot data list contains only Null:",
			secondYEpilog[{Null}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			{}
		],
		Test[
			"Returns an empty list when the plot data is Null:",
			secondYEpilog[Null, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			{}
		],
		Test[
			"Returns an empty list when the plot data list contains Null for X and Y:",
			secondYEpilog[{Null, Null}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			{}
		],
		Test[
			"Returns a list of graphics primatives when provided with multiple lists of data:",
			N@secondYEpilog[{{{0, 100}, {0, 100}, {20, 50}}, {{10, 20}, {25, 30}, {45, 50}}, {{20, 30}, {40, 50}, {60, 70}}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			N@{{RGBColor[1 / 2, 0, 0], Line[{{0, 100}, {0, 100}, {20, 50}}]}, {RGBColor[1, 0, 0], Line[{{10, 20}, {25, 30}, {45, 50}}]}, {RGBColor[1, 1 / 2, 1 / 2], Line[{{20, 30}, {40, 50}, {60, 70}}]}}
		],
		Test[
			"Ignores a Null element in a list of XY data:",
			N@secondYEpilog[{{{0, 100}, {0, 100}, {20, 50}}, Null, {{10, 20}, {25, 30}, {45, 50}}, {{20, 30}, {40, 50}, {60, 70}}}, Conductance, {0, 100}, PlotRange -> {{0, 100}, {0, 100}}, Color -> Red, Display -> {Conductance}],
			N@{{RGBColor[1 / 2, 0, 0], Line[{{0, 100}, {0, 100}, {20, 50}}]}, {RGBColor[1, 0, 0], Line[{{10, 20}, {25, 30}, {45, 50}}]}, {RGBColor[1, 1 / 2, 1 / 2], Line[{{20, 30}, {40, 50}, {60, 70}}]}}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*fractionEpilog*)


DefineTests[
	fractionEpilog,
	{
		Example[
			{Basic, "Generate a fraction plot with a list of points and labels:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions}, PlotRange -> {{0, 60}, {0, 1}}],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.983, -1}, {5.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.983, -1}, {5.483, 2}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.483, -1}, {5.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.483, -1}, {5.983, 2}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.983, -1}, {6.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.983, -1}, {6.483, 2}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.483, -1}, {6.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.483, -1}, {6.983, 2}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.983, -1}, {7.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.983, -1}, {7.483, 2}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.483, -1}, {7.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.483, -1}, {7.983, 2}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.983, -1}, {8.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.983, -1}, {8.483, 2}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.483, -1}, {8.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.483, -1}, {8.983, 2}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.983, -1}, {9.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.983, -1}, {9.483, 2}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 1 / 2}]}]}
		],
		Example[
			{Options, Display, "Display peaks of fractions:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions, Peaks}, PlotRange -> {{0, 60}, {0, 1}}],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.983, -1}, {5.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.983, -1}, {5.483, 2}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.483, -1}, {5.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.483, -1}, {5.983, 2}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.983, -1}, {6.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.983, -1}, {6.483, 2}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.483, -1}, {6.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.483, -1}, {6.983, 2}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.983, -1}, {7.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.983, -1}, {7.483, 2}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.483, -1}, {7.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.483, -1}, {7.983, 2}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.983, -1}, {8.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.983, -1}, {8.483, 2}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.483, -1}, {8.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.483, -1}, {8.983, 2}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.983, -1}, {9.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.983, -1}, {9.483, 2}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 1 / 2}]}]}
		],
		Example[
			{Options, PlotRange, "Change the plot range to make the fractions more narrow:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions}, PlotRange -> {{0, 10}, {10, 0}}],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, 20}, {2.482, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, 20}, {2.482, -10}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, 20}, {2.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, 20}, {2.983, -10}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.983, 20}, {3.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.983, 20}, {3.483, -10}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, 20}, {3.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, 20}, {3.983, -10}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, 20}, {4.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, 20}, {4.483, -10}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, 20}, {4.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, 20}, {4.983, -10}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.983, 20}, {5.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.983, 20}, {5.483, -10}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.483, 20}, {5.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.483, 20}, {5.983, -10}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.983, 20}, {6.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.983, 20}, {6.483, -10}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.483, 20}, {6.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.483, 20}, {6.983, -10}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.983, 20}, {7.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.983, 20}, {7.483, -10}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.483, 20}, {7.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.483, 20}, {7.983, -10}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.983, 20}, {8.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.983, 20}, {8.483, -10}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.483, 20}, {8.983, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.483, 20}, {8.983, -10}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 5}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.983, 20}, {9.483, -10}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.983, 20}, {9.483, -10}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 5}]}]}
		],
		Example[
			{Options, FractionHighlights, "Highlight specified fraction(s):"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions, Peaks}, PlotRange -> {{0, 60}, {0, 1}}, FractionHighlights -> {{2.983`, 3.483`, "2C12"}, {5.983`, 6.483`, "2D7"}}],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.983, -1}, {5.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.983, -1}, {5.483, 2}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.483, -1}, {5.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.483, -1}, {5.983, 2}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.483, -1}, {6.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.483, -1}, {6.983, 2}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.983, -1}, {7.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.983, -1}, {7.483, 2}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.483, -1}, {7.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.483, -1}, {7.983, 2}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.983, -1}, {8.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.983, -1}, {8.483, 2}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.483, -1}, {8.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.483, -1}, {8.983, 2}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.983, -1}, {9.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.983, -1}, {9.483, 2}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 1 / 2}]}], Mouseover[{RGBColor[0., 1., 0.4], EdgeForm[RGBColor[0., 1., 0.4]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[0., 1., 0.4], EdgeForm[RGBColor[0., 1., 0.4]], Opacity[0.30000000000000004], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[0., 1., 0.4], EdgeForm[RGBColor[0., 1., 0.4]], Opacity[0.2], Rectangle[{5.983, -1}, {6.483, 2}]}, {RGBColor[0., 1., 0.4], EdgeForm[RGBColor[0., 1., 0.4]], Opacity[0.30000000000000004], Rectangle[{5.983, -1}, {6.483, 2}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 1 / 2}]}]}
		],
		Example[
			{Options, FractionColor, "Change the color of fractions to the speficied color:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions, Peaks}, PlotRange -> {{0, 60}, {0, 1}}, FractionColor -> RGBColor[0.5, 0.4, 0.9]],
			{Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{4.983, -1}, {5.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{4.983, -1}, {5.483, 2}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{5.483, -1}, {5.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{5.483, -1}, {5.983, 2}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{5.983, -1}, {6.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{5.983, -1}, {6.483, 2}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{6.483, -1}, {6.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{6.483, -1}, {6.983, 2}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{6.983, -1}, {7.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{6.983, -1}, {7.483, 2}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{7.483, -1}, {7.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{7.483, -1}, {7.983, 2}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{7.983, -1}, {8.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{7.983, -1}, {8.483, 2}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{8.483, -1}, {8.983, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{8.483, -1}, {8.983, 2}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 1 / 2}]}], Mouseover[{RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.1], Rectangle[{8.983, -1}, {9.483, 2}]}, {RGBColor[0.5, 0.4, 0.9], EdgeForm[RGBColor[0.5, 0.4, 0.9]], Opacity[0.2], Rectangle[{8.983, -1}, {9.483, 2}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 1 / 2}]}]}
		],
		Example[
			{Options, FractionHighlightColor, "Change the highligthing color:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"},
				{4.983`, 5.483`, "2D9"}, {5.483`, 5.983`, "2D8"}, {5.983`, 6.483`, "2D7"}, {6.483`, 6.983`, "2D6"}, {6.983`, 7.483`, "2D5"}, {7.483`, 7.983`, "2D4"}, {7.983`, 8.483`, "2D3"}, {8.483`, 8.983`, "2D2"},
				{8.983`, 9.483`, "2D1"}}, Display -> {Fractions, Peaks}, PlotRange -> {{0, 60}, {0, 1}}, FractionHighlights -> {{2.983`, 3.483`, "2C12"}, {5.983`, 6.483`, "2D7"}}, FractionHighlightColor -> RGBColor[0.2, 0.1, 0.6]],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["2C10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["2C11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["2D12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["2D11", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["2D10", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.983, -1}, {5.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.983, -1}, {5.483, 2}], Text[Style["2D9", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{5.483, -1}, {5.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{5.483, -1}, {5.983, 2}], Text[Style["2D8", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {5.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.483, -1}, {6.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.483, -1}, {6.983, 2}], Text[Style["2D6", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{6.983, -1}, {7.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{6.983, -1}, {7.483, 2}], Text[Style["2D5", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.483, -1}, {7.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.483, -1}, {7.983, 2}], Text[Style["2D4", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {7.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{7.983, -1}, {8.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{7.983, -1}, {8.483, 2}], Text[Style["2D3", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.483, -1}, {8.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.483, -1}, {8.983, 2}], Text[Style["2D2", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {8.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{8.983, -1}, {9.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{8.983, -1}, {9.483, 2}], Text[Style["2D1", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {9.233, 1 / 2}]}], Mouseover[{RGBColor[0.2, 0.1, 0.6], EdgeForm[RGBColor[0.2, 0.1, 0.6]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[0.2, 0.1, 0.6], EdgeForm[RGBColor[0.2, 0.1, 0.6]], Opacity[0.30000000000000004], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["2C12", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[0.2, 0.1, 0.6], EdgeForm[RGBColor[0.2, 0.1, 0.6]], Opacity[0.2], Rectangle[{5.983, -1}, {6.483, 2}]}, {RGBColor[0.2, 0.1, 0.6], EdgeForm[RGBColor[0.2, 0.1, 0.6]], Opacity[0.30000000000000004], Rectangle[{5.983, -1}, {6.483, 2}], Text[Style["2D7", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {6.233, 1 / 2}]}]}
		],
		Example[
			{Options, FractionLabels, "Specify labels for fraction mouseovers:"},
			fractionEpilog[{{1.982`, 2.482`, "2C10"}, {2.482`, 2.983`, "2C11"}, {2.983`, 3.483`, "2C12"}, {3.483`, 3.983`, "2D12"}, {3.983`, 4.483`, "2D11"}, {4.483`, 4.983`, "2D10"}}, Display -> {Fractions}, PlotRange -> {{0, 60}, {0, 1}}, FractionLabels -> {"A", "B", "C", "D", "E", "F"}],
			{Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{1.982, -1}, {2.482, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{1.982, -1}, {2.482, 2}], Text[Style["A", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.232, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.482, -1}, {2.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.482, -1}, {2.983, 2}], Text[Style["B", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {2.7325, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{2.983, -1}, {3.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{2.983, -1}, {3.483, 2}], Text[Style["C", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.483, -1}, {3.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.483, -1}, {3.983, 2}], Text[Style["D", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {3.733, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{3.983, -1}, {4.483, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{3.983, -1}, {4.483, 2}], Text[Style["E", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.233, 1 / 2}]}], Mouseover[{RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.1], Rectangle[{4.483, -1}, {4.983, 2}]}, {RGBColor[1, 0, 1], EdgeForm[RGBColor[1, 0, 1]], Opacity[0.2], Rectangle[{4.483, -1}, {4.983, 2}], Text[Style["F", GrayLevel[0], Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[GrayLevel[1], Opacity[0.75]]], {4.733, 1 / 2}]}]}
		]
	}
];


(* ::Subsection::Closed:: *)
(*Zooming*)


(* ::Subsubsection::Closed:: *)
(*Zoomable*)


DefineTests[Zoomable, {
	Example[{Basic, "Create a Zoomable Chromatography plot:"},
		Zoomable[EmeraldListLinePlot[Object[Data, Chromatography, "id:eGakld01z03z"][Absorbance]]],
		_DynamicModule
	],
	Example[{Basic, "Create a Zoomable disk:"},
		Zoomable[Graphics[Disk[]]],
		_DynamicModule
	]
}];


(* ::Subsubsection::Closed:: *)
(*Unzoomable*)


DefineTests[Unzoomable,
	{
		Example[
			{Basic, "Change a Zoomable dynamic plot into a static graphic:"},
			Unzoomable[PlotChromatography[Object[Data, Chromatography, "id:eGakld01z03z"]]],
			_Graphics
		],
		Example[
			{Basic, "Given something that is not Zoomable, returns that same thing:"},
			Unzoomable[ListPlot[RandomReal[{-1, 1}, {10, 2}]]],
			_Graphics
		],
		Example[
			{Basic, "Pierces into expressions to find any Zoomable pieces inside:"},
			Unzoomable[Grid[List[List[".", Zoomable[Graphics[List[]]]], List[Row[List[PlotObject[Object[Data, Chromatography, "id:7X104vK9Av6X"]]]], "Duck"], List[1, 2]], Rule[ItemSize, List[Automatic, Automatic]]]],
			True,
			EquivalenceFunction -> (MatchQ[Cases[#1, ZoomableP, Infinity], {}]&)
		]
	}];


(* ::Subsection::Closed:: *)
(*Display*)
DefineTests[Core`Private`ValidLegendedQ, {
	Example[{Basic, "Returns True if the input has a valid legend:"},
		Core`Private`ValidLegendedQ[Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}]]],
		True
	],
	Example[{Basic, "Returns False if the input does not have a legend:"},
		Core`Private`ValidLegendedQ[Plot[{x, x^2, x^3}, {x, -1, 1}]],
		False
	],
	Example[{Attributes, Listable, "Works on a list of inputs:"},
		Core`Private`ValidLegendedQ[{Plot[{x, x^2, x^3}, {x, -1, 1}], Plot[{x, x^2, x^3}, {x, -1, 1}, PlotLegends -> resolvePlotLegends[{"A", "B", "C"}]]}],
		{False, True}
	]
}];


DefineTests[Core`Private`graphicsInformation, {
	Test["If ImagePadding and ImageSize are explicitly provided (along with AspectRatio->Full), the returned information should be the same:",
		UsingFrontEnd[Core`Private`graphicsInformation[
			ListLinePlot[{{1, 2}, {3, 4}, {5, 6}},
				AspectRatio -> Full,
				ImageSize -> {642., 542.},
				ImagePadding -> {{21., 22.}, {54., 23.}}
			]
		]] /. re_Real :> Rationalize[re],

		{"ImagePadding" -> {{21, 22}, {54, 23}}, "ImageSize" -> {642, 542}, "ImageMagnification" -> 1}

	],
	Test["The padding should be no more than 10 percent the size of the whole image:",
		Module[{info, padding, totalPadding, size},

			info = UsingFrontEnd[Core`Private`graphicsInformation[ListLinePlot[{{1, 2}, {3, 4}, {5, 6}}]]];

			padding = Lookup[info, "ImagePadding"];
			size = Lookup[info, "ImageSize"];

			totalPadding = Plus@@@padding;

			MapThread[Less, {totalPadding, size*0.10}]
		],
		{True, True}
	],
	Test["If FrameLabels are included, then the padding should be larger than 10 percent the full image size, but still less than 25 percent:",
		Module[{info, padding, totalPadding, size},
			info = UsingFrontEnd[
				Core`Private`graphicsInformation[
					ListLinePlot[{{1, 2}, {3, 4}, {5, 6}}, Frame -> True,
						FrameLabel -> {{"left", "right"}, {"bottom", "top"}}]]];

			padding = Lookup[info, "ImagePadding"];
			size = Lookup[info, "ImageSize"];

			totalPadding = Plus @@@ padding;

			{MapThread[Greater, {totalPadding, size*0.10}],
				MapThread[Less, {totalPadding, size*0.25}]}
		],

		{{True, True}, {True, True}}

	]
}];



DefineTests[Staticize,{
	Example[{Basic,"Remove DynamicModule:"}, 
		Staticize[DynamicModule[{x=1},x]], 
		Alternatives[
			_Image /; ECL`$CCD,
			1
		]
	],
	Test["DynamicModule with dependent variables:",
		Staticize[DynamicModule[{x=2,y},y=x; y]],
		Alternatives[
			_Image /; ECL`$CCD,
			2
		]
	],
	Example[{Basic,"Remove nested DynamicModules:"},
		Staticize[DynamicModule[{x=1},DynamicModule[{y=2},x+y]]],
		Alternatives[
			_Image /; ECL`$CCD,
			3
		]
	],
	Example[{Basic,"Remove EventHandler:"},
		Staticize[EventHandler[4,{"MouseClicked":>Print["hi"]}]],
		Alternatives[
			_Image /; ECL`$CCD,
			4
		]
	],
	Example[{Basic,"Turn a Zoomable plot static: "}, 
		Staticize[Zoomable[ListPlot[RandomReal[1,{5,2}]]]],
		Alternatives[
			_Image /; ECL`$CCD,
			_Graphics?staticQ
		]

	],
	Test["Zoomable with epilog",
		Staticize[Zoomable[ListPlot[{{0,0},{1,1},{2,2}},Epilog->AxisLines[{{1,1}},PlotRange->{{0,2},{0,2}}]]]],
		Alternatives[
			_Image /; ECL`$CCD,
			_Graphics?staticQ
		]
	],
	(*
	(* This is ignored because the way the front end shows messages depends on Manifold and the different functionality in 12.0/12.2 *)
	Test["Error if x not initialized: ",
		Staticize[
			DynamicModule[ { x, list=Range[5] },
   				{Dynamic[list[[x]]], Slider[Dynamic[x], {1, 5, 1}]}
			]
		],
		_,
		Messages:> {Part::pkspec1}
	],
	*)
	Test["Works once x is initialized: ",
		Staticize[
			DynamicModule[ { x = 1, list=Range[5] }, 
   				{Dynamic[list[[x]]], Slider[Dynamic[x], {1, 5, 1}]}
			]
		],
		Alternatives[
			_Image /; ECL`$CCD,
			{1,Slider[1,{1,5,1}]}
		]

	]
}];
