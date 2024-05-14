(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*PlotAbsorbanceQuantification*)


DefineTests[PlotAbsorbanceQuantification,{

	Example[(*24662*)
		{Basic,"Plot the Object[Data,AbsorbanceSpectroscopy] associated with an Object[Analysis,AbsorbanceQuantification] object:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"]],
		_?ValidGraphicsQ
	],

	Test["Given a packet:",
		PlotAbsorbanceQuantification[Download[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"]]],
		_?ValidGraphicsQ
	],

	Example[
		{Basic,"Plot absorbance spectroscopy data from a link:"},
		PlotAbsorbanceQuantification[Link[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Reference]],
		_?ValidGraphicsQ
	],

	Example[
		{Basic,"Plot the Object[Data,AbsorbanceSpectroscopy] associated with an protocol[AbsorbanceQuantification] object:"},
		PlotAbsorbanceQuantification[Object[Protocol, AbsorbanceQuantification, "id:pZx9jonGXGM0"]],
		_?ValidGraphicsQ
	],

	Example[
		{Options,DataField,"Specify the field in the Object[Analysis,AbsorbanceQuantification] object from which the Object[Data,AbsorbanceSpectroscopy] will be pulled and plotted:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],DataField->AbsorbanceSpectra],
		_?ValidGraphicsQ
	],

	Example[
		{Options,DataField,"Specify the field in the Object[Analysis,AbsorbanceQuantification] object from which the Object[Data,AbsorbanceSpectroscopy] will be pulled and plotted:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],DataField->AbsorbanceSpectraBlank],
		_?ValidGraphicsQ
	],

	Example[
		{Options,DataField,"Specify the field in the Object[Analysis,AbsorbanceQuantification] object from which the Object[Data,AbsorbanceSpectroscopy] will be pulled and plotted:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],DataField->{AbsorbanceSpectra,AbsorbanceSpectraBlank}],
		_?ValidGraphicsQ
	],



	Example[
		{Options,SecondaryData,"Specify a data Field to be plotted on the second vertical axis:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],SecondaryData->{Temperature}],
		_?ValidGraphicsQ
	],

	Example[
		{Options,PlotLabel,"Allow the function to automatically label the plot with the sample Object and Name:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],PlotLabel->Automatic],
		_?ValidGraphicsQ
	],

	Example[
		{Options,PlotLabel,"Specify the label for the plot:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],PlotLabel->"PNA Data"],
		_?ValidGraphicsQ
	],

	Example[
		{Options,ImageSize,"Specify the dimensions of the plot:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],ImageSize->Medium],
		_?ValidGraphicsQ
	],

	Example[
		{Additional,"All of the options for PlotAbsorbanceSpectroscopy will work for PlotAbsorbanceQuantification:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],PlotStyle->ColorFade[{Red,Blue},2],FillingStyle->Core`Private`fillingFade[{Red,Blue},2]],
		_?ValidGraphicsQ
	],

	Example[
		{Attributes,"Listable","Plot the Object[Data,AbsorbanceSpectroscopy] associated with several Object[Analysis,AbsorbanceQuantification] objects:"},
		PlotAbsorbanceQuantification[{Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Object[Analysis, AbsorbanceQuantification, "id:Z1lqpMGjDdX9"]}],
		{_?ValidGraphicsQ..}
	],

	Example[
		{Attributes,"Listable","Plot the Object[Data,AbsorbanceSpectroscopy] associated with several protocol[AbsorbanceQuantification] objects:"},
		PlotAbsorbanceQuantification[{Object[Protocol, AbsorbanceQuantification, "id:pZx9jonGXGM0"]}],
		{_?ValidGraphicsQ..}
	],

	Example[
		{Messages,"NoData","There must be Object[Data,AbsorbanceSpectroscopy] objects associated with the provided Object[Analysis,AbsorbanceQuantification] object:"},
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:WNa4ZjRrk06z"]],
		Null,
		Messages:>PlotAbsorbanceQuantification::NoData
	],

	Example[
		{Messages,"NoData","There must be an Object[Analysis,AbsorbanceQuantification] object associated with the provided protocol[AbsorbanceQuantification] object:"},
		PlotAbsorbanceQuantification[Object[Protocol, AbsorbanceQuantification, "id:n0k9mGzRelb1"]],
		Null,
		Messages:>PlotAbsorbanceQuantification::NoData
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->Result],
		_?ValidGraphicsQ
	],

	Test["Setting Output to Preview returns the plot:",
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->Preview],
		_?ValidGraphicsQ
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotAbsorbanceQuantification]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for Analysis input:",
		PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotAbsorbanceQuantification]]
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for Protocol input:",
		PlotAbsorbanceQuantification[Object[Protocol, AbsorbanceQuantification, "id:pZx9jonGXGM0"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotAbsorbanceQuantification]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotAbsorbanceQuantification[Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],Output->Options],
		Sort@Keys@SafeOptions@PlotAbsorbanceQuantification
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for two inputs:",
		PlotAbsorbanceQuantification[
			{
				Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"],
				Object[Analysis, AbsorbanceQuantification, "id:01G6nvkK4oZA"]
			},
			Output->{Result,Options}],
		output_List/;MatchQ[First@output,{_?ValidGraphicsQ,_?ValidGraphicsQ}]&&MatchQ[Last@output,OptionsPattern[PlotAbsorbanceQuantification]]
	]
}
];
