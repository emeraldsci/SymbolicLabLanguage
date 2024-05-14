(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotCellCount*)

DefineTests[PlotCellCount,{

	Example[{Basic, "Plot components of over a microscope image:"},
		PlotCellCount[Object[Analysis, CellCount, "id:J8AY5jDMmLZK"]],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Basic, "Plot cell count from a link:"},
		PlotCellCount[Link[Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"],Reference]],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Test["Given a packet:",
		PlotCellCount[Download[Object[Analysis, CellCount, "id:J8AY5jDMmLZK"]]],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Basic, "Plot a list of cell counts:"},
		PlotCellCount[{452,523,474,389,527,525,583,556,423,522}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Additional,"Input Type","Plot groups of cell counts:"},
		PlotCellCount[{{452,523,474,389,527,525,583,556,423,522},{690,665,590,522,609,604,646,550,628,639}}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Additional, "Input Type","Plot microscope data:"},
		PlotCellCount[Object[Analysis, CellCount, "id:J8AY5jDMmLZK"]],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Additional, "Input Type","Plot cell counts using an image and its components:"},
		PlotCellCount[First@ImportCloudFile@Download[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], ReferenceImage],Download[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], ImageComponents]],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, PlotType, "Plot a pie chart of sizes of cell components:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], PlotType->PieChart],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, PlotType, "Plot the text stats of the cell counts:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], PlotType->Text],
		_Column,
		TimeConstraint -> 600
	],

	Example[{Options, BlendingFraction, "Change the alpha blending of image components into the cell image:"},
		Grid[{{PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],BlendingFraction->0.25,ImageSize->300],PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],BlendingFraction->0.75,ImageSize->300]}}],
		_Grid,
		TimeConstraint -> 600
	],

	Example[{Options, FrameLabel, "Specify the frame label for the bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},FrameLabel->{"Cell Samples","Cell Counts"}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartLabels, "Specify the chart labels for the bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},ChartLabels->{1,2,3,4}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartLabelOrientation, "Specify the chart label orientation for the bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},ChartLabels->{1,2,3,4},ChartLabelOrientation->Vertical],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, PlotRange, "Specify the plot range for the bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},PlotRange->{Automatic,{0,500}}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, PlotLabel, "Label the bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},PlotLabel->"THIS IS MY DATA!!!!"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, Legend, "Add a legend:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], PlotType->PieChart, Legend->{"my data"}],
		_Legended,
		TimeConstraint -> 600
	],

	Example[{Options, ImageSize, "Resize the plot:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], ImageSize->700],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, SingleCell, "Only label single celled component:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], SingleCell->True],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, DisplayCellCount, "Turn off labeling of cell counts:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], DisplayCellCount->False],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, CellCount, "Specify the number of cells in the BrightField image:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], CellCount->50],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, CellCountError, "Specify the error associated with the cells count in the BrightField image:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], CellCountError->2],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, MinSingleCellArea, "Specify the minimum size for a component to be considered a cell:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], MinSingleCellArea->300],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, MaxSingleCellArea, "Specify the maximum size for a component to be considered a cell:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"], MaxSingleCellArea->3000],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Example[{Options, SectorOrigin, "Specify the angular orientation of a PieChart:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,SectorOrigin->Pi/2],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartElementFunction, "Specify the element styling function for a PieChart:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,ChartElementFunction->"GlassSector"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, AspectRatio, "Set the height to width ratio of a cell counts bar chart:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},AspectRatio->1/3],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartBaseStyle, "Specify the base style of a cell counts BarChart:"},
		PlotCellCount[{452,523,474,389,527,525,583,556,423,522},ChartBaseStyle->Directive[Opacity[0.3]]],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartStyle, "Specify the style of a cell counts BarChart:"},
		PlotCellCount[{452,523,474,389,527,525,583,556,423,522},ChartStyle->"Rainbow"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, BarSpacing, "Specify the distance between adjacent bars in a cell counts BarChart:"},
		PlotCellCount[{452,523,474,389,527,525,583,556,423,522},BarSpacing->1],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ChartLayout, "Plot cumulative cell counts in a cell counts BarChart:"},
		PlotCellCount[RandomInteger[100,10],ChartLayout->"Stepped"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, LabelStyle, "Set the label font:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},LabelStyle->{Bold,Red,"Section"}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, LabelingFunction, "Position the ChartLabels:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},LabelingFunction->Top],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, FrameTicks, "Set the tick mark positions:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},FrameTicks->{None,{0,100,200,300}}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, FrameTicksStyle, "Set the tick mark font:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},FrameTicksStyle->"Section"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, Frame, "Specify which axes are drawn:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},Frame->{{True,True},{True,True}}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, FrameStyle, "Format the drawn axes:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},FrameStyle->Red],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, Prolog, "Draw graphics primitives behind the plot:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},Prolog->{Red,Disk[{2.75,150},Scaled[.2]]}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, Epilog, "Draw graphics primitives in front of the plot:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},Epilog->{Red,Disk[{2.75,150},Scaled[.2]]}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, GridLines, "Specify position at which to draw guide lines:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},GridLines->{None,{100,200}}],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, GridLinesStyle, "Format the drawn guide lines:"},
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]},GridLines->{None,{100,200}},GridLinesStyle->Directive[Dashed,Thick,Red]],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, Background, "Format the displayed area behind the plot:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,Background->LightYellow],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ColorFunction, "Specify the colormap used to format chart elements in the plot:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,ColorFunction->"AlpineColors"],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Options, ColorFunctionScaling, "Specify whether the colormap is normalized to a [0-1] interval:"},
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,ColorFunction->"AlpineColors",ColorFunctionScaling->False],
		_Graphics,
		TimeConstraint -> 600
	],

	Example[{Messages, "imageNotFound", "Throw an error if there is no image to generate components from:"},
		PlotCellCount[Association[<|Type -> Object[Analysis, CellCount],Reference -> Null|>]],
		Null,
		Messages:>Message[PlotCellCount::imageNotFound]
	],

	Example[{Messages, "NoCounts", "Throw an error if one or more of your inputs does not have calculated cell counts:"},
		PlotCellCount[{<|Type -> Object[Data, Microscope],CellCountAnalyses -> Null|>}],
		Null,
		Messages:>Message[PlotCellCount::NoCounts]
	],

	Test["Plot the brightfield cell counts from Object[Analysis,CellCount] objects as a barchart:",
		PlotCellCount[{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:Vrbp1jKMlDMO"]}],
		_Graphics,
		TimeConstraint -> 600
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot when input contains an image:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Result],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Test["Setting Output to Preview returns the plot when input contains an image:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Preview],
		TabView[{(_String -> _DynamicModule) ..}],
		TimeConstraint -> 600
	],

	Test["Setting Output to Options returns the resolved options when input contains an image:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to Tests returns a list of tests when input contains an image:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Tests],
		{(_EmeraldTest|_Example)...},
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when input contains an image:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to Options returns all of the defined options when input contains an image:",
		Sort@Keys@PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Output->Options],
		Sort@Keys@SafeOptions@PlotCellCount,
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when PlotType is set to PieChart:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->PieChart,Output->{Result,Options}],
		output_List/;MatchQ[First@output,_]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when PlotType is set to Text:",
		PlotCellCount[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],PlotType->Text,Output->{Result,Options}],
		output_List/;MatchQ[First@output,_]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when input is a list of cell count objects:",
		PlotCellCount[{{1,2,3,4},{1,2,4}},Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when input is a list of numeric cell counts:",
		PlotCellCount[
			{{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:1ZA60vLYqLN5"]},
			{Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],Object[Analysis, CellCount, "id:1ZA60vLYqLN5"]}},
			Output->{Result,Options}
		],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options when input consists of an image and a list of components:",
		PlotCellCount[
			First@ImportCloudFile[Download[Object[Analysis, CellCount, "id:1ZA60vLYqLN5"],ReferenceImage]],
			Download[Object[Analysis, CellCount,"id:1ZA60vLYqLN5"], ImageComponents],
			Output->{Result,Options}
		],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCellCount]],
		TimeConstraint -> 600
	]

}];
