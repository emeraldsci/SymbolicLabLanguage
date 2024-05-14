(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*PlotCellCountSummary*)


DefineTests[PlotCellCountSummary,{

	Example[{Basic, "Visualize a cell count:"},
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"]],
		_Column
	],

	Example[{Basic, "Visualize a cell count:"},
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"]],
		_Column
	],

	Example[{Options,ImageSize, "Resize the visualization:"},
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], ImageSize->700],
		_Column
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Result],
		(* g_/;MatchQ[g,_?Core`Private`ValidOutputQ] *)
		_Column
	],

	Test["Setting Output to Preview returns the plot:",
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Preview],
		(* g_/;MatchQ[g,_?Core`Private`ValidOutputQ] *)
		_Column
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotCellCountSummary]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
		PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->{Result,Options}],
		output_List/;MatchQ[g,_?Core`Private`ValidOutputQ]&&MatchQ[Last@output,OptionsPattern[PlotCellCountSummary]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotCellCountSummary[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Options],
		Sort@Keys@SafeOptions@PlotCellCountSummary
	]

}];
