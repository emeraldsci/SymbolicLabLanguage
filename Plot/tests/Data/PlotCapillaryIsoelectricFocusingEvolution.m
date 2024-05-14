(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryIsoelectricFocusingEvolution*)


DefineTests[PlotCapillaryIsoelectricFocusingEvolution,
	{
		Example[
			{Basic,"Plots capillary isoelectric focusing separation data when given an CapillaryIsoelectricFocusing data object:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]],
			_Manipulate,
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotCapillaryIsoelectricFocusingEvolution[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]]],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary isoelectric focusing separation data when given an CapillaryIsoelectricFocusing data link:"},
			PlotCapillaryIsoelectricFocusingEvolution[Link[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Protocol]],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary isoelectric focusing separation data when given a list of XY coordinates representing the trace:"},
			PlotCapillaryIsoelectricFocusingEvolution[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],SeparationData]],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of separation data:"},
			PlotCapillaryIsoelectricFocusingEvolution[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"]}],
			{_Manipulate..},
			TimeConstraint->120
		],
		Example[
			{Options,OutputFormat,"Output separation data as a single interactive Plot/animation:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],OutputFormat->SingleInteractivePlot],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Options,OutputFormat,"Output separation data with all traces on the same plot:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],OutputFormat->SingleStaticPlot],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,OutputFormat,"Output separation data with a separate plot for each frame:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],OutputFormat->MultipleStaticPlots],
			{_?ValidGraphicsQ..},
			TimeConstraint->120
		],
		Example[
			{Options,SubtractFirstFrame,"Specify whether the first frame should serve as background data and be subtracted from the rest:"},
			PlotCapillaryIsoelectricFocusingEvolution[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]},SubtractFirstFrame->{True, False}],
			{_Manipulate,_Manipulate},
			TimeConstraint->120
		],
		Example[
			{Options,FramesToPlot,"Specify the frames  to plot from a separation progression:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],FramesToPlot->Range[1, 33, 4]],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Options,Duration,"Specify the duration of separation data:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Duration->5.5Minute],
			_Manipulate,
			TimeConstraint->120
		],
		Example[
			{Messages,"InvalidFramesToPlot","Raise a warning when invalid frames that are not present in the dataset are specified and default to All:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],FramesToPlot->{40}],
			_Manipulate,
			TimeConstraint->120,
			Messages:>{Warning::InvalidFramesToPlot}
		],
		Example[
			{Messages,"InvalidDuration","Raise a warning when the specified duration is not copacetic with the data object's VoltageDurationProfile, but use the specified duration:"},
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Duration->6Minute],
			_Manipulate,
			TimeConstraint->120,
			Messages:>{Warning::InvalidDuration}
		],
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Result],
			_Manipulate,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Preview],
			_Manipulate,
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotCapillaryIsoelectricFocusingEvolution]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_Manipulate]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryIsoelectricFocusingEvolution]]
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotCapillaryIsoelectricFocusingEvolution[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],SeparationData],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_Manipulate]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryIsoelectricFocusingEvolution]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotCapillaryIsoelectricFocusingEvolution[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Options],
			Sort@Keys@SafeOptions@PlotCapillaryIsoelectricFocusingEvolution,
			TimeConstraint->120
		]
	}
];
