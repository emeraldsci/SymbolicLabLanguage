(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryIsoelectricFocusing*)


DefineTests[PlotCapillaryIsoelectricFocusing,
	{
		Example[
			{Basic,"Plots capillary isoelectric focusing data when given an CapillaryIsoelectricFocusing data object:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotCapillaryIsoelectricFocusing[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary isoelectric focusing data when given an CapillaryIsoelectricFocusing data link:"},
			PlotCapillaryIsoelectricFocusing[Link[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Protocol]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary isoelectric focusing data when given a list of XY coordinates representing the spectra:"},
			PlotCapillaryIsoelectricFocusing[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],ProcessedFluorescenceData[[1,2]]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots capillary isoelectric focusing data when given a list of XY coordinates representing the spectra:"},
			PlotCapillaryIsoelectricFocusing[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],CurrentData]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of data on the same graph:"},
			PlotCapillaryIsoelectricFocusing[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Plot the x-axis in units of Minutes:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],PrimaryData->CurrentData,TargetUnits->{Minute,Milliampere}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotCapillaryIsoelectricFocusing[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"]},Map->True],
			{_?ValidGraphicsQ,_?ValidGraphicsQ},
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a custom legend for the data:"},
			PlotCapillaryIsoelectricFocusing[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"]},Legend->{"Standard 1","Standard 2"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[
			{Options,Units,"Specify relevant units:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Units->{ProcessedFluorescenceData->{Pixel,RFU},ProcessedUVAbsorbanceData->{Pixel,MilliAbsorbanceUnit}}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PrimaryData,"Plots the current-voltage plot for the relevant data:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],PrimaryData->CurrentData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Plots the current-voltage plot for the relevant data:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],SecondaryData->VoltageData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FluorescenceExposureTime,"Specify the fluorescence data to plot by exposure time:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],FluorescenceExposureTime->5Second],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FluorescenceExposureTime,"Plot data for each exposure time specified:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],FluorescenceExposureTime->{5Second,20Second}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Messages,"InvalidFluorescneceExposureTime","Raise a warning when invalid exposure time is specified:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],FluorescenceExposureTime->6Second],
			_?ValidGraphicsQ,
			TimeConstraint->120,
			Messages:>{Warning::InvalidFluorescneceExposureTime}
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],PlotTheme->"Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,ImageSize,"Specify the dimensions of the plot:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],ImageSize->Medium],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PlotLabel,"Provide a title for the plot:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],PlotLabel->"cIEF System Suitability Test"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],SecondaryData->{},
				FrameLabel->{"Position in Capillary","FL Signal",None,None}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotCapillaryIsoelectricFocusing[
				{Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]},
				LegendPlacement->Right
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotCapillaryIsoelectricFocusing[
				{Object[Data,CapillaryIsoelectricFocusing,"id:01G6nvw6KWpD"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]},
				Boxes->True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Plots many sets of data on the same graph:",
			PlotCapillaryIsoelectricFocusing[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Accepts EmeraldListLinePlot options:",
			PlotCapillaryIsoelectricFocusing[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]},PlotStyle->ColorFade[{Red,Blue},Length[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]}]],FillingStyle->Core`Private`fillingFade[{Red,Blue},Length[{Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"]}]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Result],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Preview],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotCapillaryIsoelectricFocusing]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryIsoelectricFocusing]]
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotCapillaryIsoelectricFocusing[Download[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],ProcessedUVAbsorbanceData],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCapillaryIsoelectricFocusing]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotCapillaryIsoelectricFocusing[Object[Data,CapillaryIsoelectricFocusing,"id:qdkmxzqPomX1"],Output->Options],
			Sort@Keys@SafeOptions@PlotCapillaryIsoelectricFocusing,
			TimeConstraint->120
		]
	}
];
