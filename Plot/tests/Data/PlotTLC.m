(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTLC*)


DefineTests[PlotTLC,
	{
		Example[
			{Basic,"Plot a TLC:"},
			PlotTLC[Object[Data, TLC, "id:jLq9jXY4o31w"]],
			_?ValidGraphicsQ
		],
		Test[
			"Given a packet:",
			PlotTLC[Download[Object[Data, TLC, "id:jLq9jXY4o31w"]]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot a TLC object in a link:"},
			PlotTLC[Link[Object[Data, TLC, "id:jLq9jXY4o31w"],Protocol]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot multiple TLC:"},
			PlotTLC[{Object[Data, TLC, "id:jLq9jXY4o31w"],Object[Data, TLC, "id:M8n3rxYER74M"]}],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options,Map,"Plot each Object[Data,TLC] object individually, returning a list of plots:"},
			PlotTLC[{Object[Data, TLC, "id:jLq9jXY4o31w"],Object[Data, TLC, "id:M8n3rxYER74M"]},Map->True],
			{_?ValidGraphicsQ,_?ValidGraphicsQ}
		]
	}
];
