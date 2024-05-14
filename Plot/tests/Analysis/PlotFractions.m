(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotFractions*)


DefineTests[PlotFractions,
	{
	Example[{Basic, "Plot fractions analysis:"},
		PlotFractions[Object[Analysis, Fractions, "id:kEJ9mqaVZ6DX"]],
		_?ValidGraphicsQ
	],
		Example[{Basic, "Plot fractions analysis with Fractions field:"},
			PlotFractions[AnalyzeFractions[Object[Data, Chromatography, "id:AEqRl9KVpYNa"]]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot fractions analysis from a link:"},
			PlotFractions[Link[Object[Analysis, Fractions, "id:kEJ9mqaVZ6DX"],Reference]],
			_?ValidGraphicsQ
		],
		Test["Given a packet:",
			PlotFractions[Download[Object[Analysis, Fractions, "id:kEJ9mqaVZ6DX"]]],
			_?ValidGraphicsQ
		],
	Example[{Basic, "FractionLabels default to well positions when no sample information available:"},
		PlotFractions[
			{{22.55133333`,24.046`,"1C11"},{24.18316667`,25.3045`,"1C12"},{25.32116667`,26.405`,"1D1"},{26.42166667`,27.14533333`,"1D2"},{27.162`,28.0375`,"1D3"},{28.05416667`,29.8545`,"1D4"},{29.8545`,30.`,"1D5"}},
			{{28.05416667`,29.8545`,"1D4"},{29.8545`,30.`,"1D5"}},
			Unzoomable[PlotChromatography[Object[Data, Chromatography, "id:WNa4ZjRrYrVz"], Display -> {Peaks}]]
		],
		_?ValidGraphicsQ
	],

	Example[{Options, Range, "Specify the range of fractions samples could be in:"},
		PlotFractions[Object[Analysis, Fractions, "id:kEJ9mqaVZ6DX"], Range->{20,35}],
		_?ValidGraphicsQ
	],
	Example[{Options,FractionLabels, "Plot fractions analysis:"},
		PlotFractions[Object[Analysis, Fractions, "id:kEJ9mqaVZ6DX"],FractionLabels->Range[7]],
		_?ValidGraphicsQ
	],


	Test[
		"Testing core definition passing fractions to plot atop a line plot:",
		PlotFractions[
			{{1.982`,2.482`,"2C10"},{2.482`,2.983`,"2C11"},{2.983`,3.483`,"2C12"},{3.483`,3.983`,"2D12"},{3.983`,4.483`,"2D11"},{4.483`,4.983`,"2D10"},{4.983`,5.483`,"2D9"},{5.483`,5.983`,"2D8"},{5.983`,6.483`,"2D7"},{6.483`,6.983`,"2D6"},{6.983`,7.483`,"2D5"},{7.483`,7.983`,"2D4"},{7.983`,8.483`,"2D3"},{8.483`,8.983`,"2D2"},{8.983`,9.483`,"2D1"}},
			{{Null, Null, Null}},
			ListLinePlot[Table[{xp,xp},{xp,Range[20]}]]
		],
		_?ValidGraphicsQ
	],

	Test[
		"Testing core definition passing fractions to plot atop a line plot with fractions selected:",
		PlotFractions[
			{{1.982`,2.482`,"2C10"},{2.482`,2.983`,"2C11"},{2.983`,3.483`,"2C12"},{3.483`,3.983`,"2D12"},{3.983`,4.483`,"2D11"},{4.483`,4.983`,"2D10"},{4.983`,5.483`,"2D9"},{5.483`,5.983`,"2D8"},{5.983`,6.483`,"2D7"},{6.483`,6.983`,"2D6"},{6.983`,7.483`,"2D5"},{7.483`,7.983`,"2D4"},{7.983`,8.483`,"2D3"},{8.483`,8.983`,"2D2"},{8.983`,9.483`,"2D1"}},
			{{1.982`,2.482`,"2C10"}},
			ListLinePlot[Table[{xp,xp},{xp,Range[20]}]]
		],
		_?ValidGraphicsQ
	]

}];
