(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBarChart*)


DefineTests[EmeraldBarChart,

	{

		(* Basic Examples *)
		Example[{Basic,"Create a bar chart from a list of heights:"},
			EmeraldBarChart[{1,2,3,4}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a bar chart containing multiple data sets:"},
			EmeraldBarChart[{{1,2,3,4},{3,2,2,5}}],
			ValidGraphicsP[]
		],

		(*
			REPLICATES & ERRORS
		*)
		Example[{Additional,"Replicates","Use replicate data. The mean is used for bar height and standard deviation is used to construct an error bar:"},
			EmeraldBarChart[{{1,Replicates[2,2.2,2.5,1.9],3,4},{1,2,3,4}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Replicates","Use PlusMinus and distributions as data points:"},
			EmeraldBarChart[{1\[PlusMinus]0.2,2,NormalDistribution[3,0.05],4}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Replicates","Mix parametric distributions, empirical distributions, Replicates, and multiple data sets:"},
			EmeraldBarChart[{
				{ChiDistribution[1.5],Replicates[2,2.2`,2.5`,1.9`,2.3],3,UniformDistribution[{3.5,4.5}]},
				{1\[PlusMinus]0.2`,2,EmpiricalDistribution[RandomVariate[NormalDistribution[3,.2],1000]],4}
			}],
			ValidGraphicsP[]
		],

		(*
			UNITS
		*)
		Example[{Additional,"Units","Chart data with units:"},
			EmeraldBarChart[{1,2,3,4}*Meter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Data units can be different, but must be compatible:"},
			EmeraldBarChart[{{1,2,3,4}*Yard,{1,2,3,4}*Foot}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Can also put units on replicate and PlusMinus data points:"},
			EmeraldBarChart[{
				{1Meter,Replicates[2Meter,2.2Meter,1.9Meter],3Foot,2Yard},
				{1Meter\[PlusMinus]0.2Meter,2Meter,PlusMinus[3Meter,0.05Meter],40Inch}
			}],
			ValidGraphicsP[]
		],



		(*
			Quantity Arrays
		*)
		Example[{Additional,"Quantity Arrays","Chart a single data set given as a QuantityArray:"},
			EmeraldBarChart[QuantityArray[{1,2,3,4,5},Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of quantity array data sets:"},
			EmeraldBarChart[{QuantityArray[{1,2,3,4},Yard],QuantityArray[{4,5,6,7},Foot]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A single QuantityArray containing grouped datasets:"},
			EmeraldBarChart[QuantityArray[{{2,4,3,1},{4,2,3,5}},Meter]],
			ValidGraphicsP[]
		],


		(*
			MISSING DATA
		*)
		Example[{Additional,"Missing Data","Null values in a data set are ignored:"},
			EmeraldBarChart[{1,2,Null,4}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Data set elements are associated with one another starting from the left.  Missing elements are ignored:"},
			EmeraldBarChart[{{1,2,3,4},{3,1,6}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values in any data set are ignored:"},
			EmeraldBarChart[{{1,2,Null,4},{1,Null,3,Null}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Entire missing data sets also ignored:"},
			EmeraldBarChart[{{1,2,Null,4},Null,{1,Null,3,Null}}],
			ValidGraphicsP[]
		],


		(*
			OPTIONS
		*)
		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldBarChart[{{2.2,2.4,2.1},{1.6,5.2,3.4}},Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldBarChart[{1,2,3,4},Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldBarChart[{1,2,3,4},PlotRange->{{Automatic,3.75},{Automatic,10}}],
			ValidGraphicsP[]
		],
		Example[{Options,PlotRange,"Can mix explicit specification with Automatic resolution:"},
			{
				EmeraldBarChart[{1,2,30,4},PlotRange->{Automatic,Automatic},ImageSize->350],
				EmeraldBarChart[{1,2,30,4},PlotRange->{Automatic,{Automatic,5}},ImageSize->350]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,TargetUnits,"Specify target y-unit for data.  If Automatic, the value is taken as the data's unit.  TargetUnits must be compatible with the data's units:"},
			EmeraldBarChart[{1,2,3,4}*Meter,TargetUnits->Foot],
			ValidGraphicsP[]
		],
		Example[{Options,TargetUnits,"Incompatible target unit triggers a message and returns $Failed:"},
			EmeraldBarChart[{1,2,3,4}*Meter,TargetUnits->Second],
			$Failed,
			Messages:>{EmeraldBarChart::IncompatibleUnits}
		],

		Example[{Options,Prolog,"Use Prolog to render other graphics primitives prior to BarChart graphics, such that these graphics appear behind the bars:"},
			EmeraldBarChart[{{5,1,2,1,5}},ImageSize->400,Prolog->Inset[Import["ExampleData/spikey.tiff"]]],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Explicitly specified epilogs are joined onto any epilogs created by EmeraldBarChart:"},
			EmeraldBarChart[{1,2,3,4},Epilog->{Disk[{3,2},{1,0.5}]}],
			ValidGraphicsP[]
		],

		Example[{Options,ErrorBars,"Show error bars over averaged replicated data:"},
			EmeraldBarChart[{{1,Replicates[2,2.2,2.5,1.9],3,4},{1\[PlusMinus]0.2,2,NormalDistribution[3,0.05],4}},ErrorBars->True],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorBars,"Do not show error bars over averaged replicated data:"},
			EmeraldBarChart[{{1,Replicates[2,2.2,2.5,1.9],3,4},{1\[PlusMinus]0.2,2,NormalDistribution[3,0.05],4}},ErrorBars->False],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorType,"Specify that error bars correspond to StandardDeviation:"},
			EmeraldBarChart[{EmpiricalDistribution[RandomVariate[NormalDistribution[1,.25],100]],Replicates[2,2.2,1.8,1.9,2.1],NormalDistribution[3,0.5]},ErrorType->StandardDeviation],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorType,"Specify that error bars correspond to StandardError, when possible.  Note that StandardError is not meaningful for parametric distriubtions, so only data-based distributions will show StandardError:"},
			EmeraldBarChart[{EmpiricalDistribution[RandomVariate[NormalDistribution[1,.25],100]],Replicates[2,2.2,1.8,1.9,2.1],NormalDistribution[3,0.5]},ErrorType->StandardError],
			ValidGraphicsP[]
		],
		Test["Check that ErrorType option changes something:",
			SameQ[EmeraldBarChart[{Replicates[2,2.2,1.8,1.9,2.1]},ErrorType->StandardDeviation],EmeraldBarChart[{Replicates[2,2.2,1.8,1.9,2.1]},ErrorType->StandardError]],
			False
		],


		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldBarChart[{1,2,3,4},FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldBarChart[{1,2,3,4},FrameLabel->{Automatic,"Distance Traveled"}],
			ValidGraphicsP[]
		],

		Example[{Options,RotateLabel,"Specify if the y-axis frame label should be rotated:"},
			Table[
				EmeraldBarChart[
					{QuantityArray[{5.6,6.2,5.8},Foot]},
					ChartLabels->{"A","B","C"},
					FrameLabel->{"Group","Height"},
					PlotLabel->"Average Height by Group",
					RotateLabel->val
				],
				{val,{True,False}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,FrameUnits,"By default, the data's units are automatically appended to the frame label:"},
			EmeraldBarChart[{1,2,3,4}*Meter,FrameUnits->Automatic,FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameUnits,"If the data is unitless, no units will be appended:"},
			EmeraldBarChart[{1,2,3,4},FrameUnits->Automatic,FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameUnits,"Use FrameUnits->None to stop automatic appeneding of units.  For example, if you want to specify the units inside the frame label manually:"},
			EmeraldBarChart[{1,2,3,4}*Meter,FrameUnits->None,FrameLabel->{"Experiment","Distance Traveled (meters)"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameUnits,"Can also explicitly specify a FrameUnit to override the data's units:"},
			EmeraldBarChart[{5,1,4,2},FrameUnits->{None,Foot,None,None},FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Specify a legend:"},
			EmeraldBarChart[{{1,2,3,4},{3,2,2,5}},Legend->{"A","B","C","D"}],
			ValidGraphicsP[]
		],

		Example[{Options,Boxes,"Use swatch boxes in legend:"},
			EmeraldBarChart[{Range[3]},Legend->{"A","B","C"},Boxes->True],
			Legended[ValidGraphicsP[],{Placed[_SwatchLegend,___]}]
		],
		Example[{Options,Boxes,"Use line segments in legend instead of swatch boxes:"},
			EmeraldBarChart[{Range[3]},Legend->{"A","B","C"},Boxes->False],
			Legended[ValidGraphicsP[],{Placed[_LineLegend,___]}]
		],

		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldBarChart[{{5,2,3},{3,3,2}},Legend->{"A","B","C","D"},LegendPlacement->Top],
				EmeraldBarChart[{{5,2,3},{3,3,2}},Legend->{"A","B","C","D"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,ChartLabels,"Label the bars (columns):"},
			EmeraldBarChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {"c1", "c2", "c3"}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"Label the datasets (rows):"},
			EmeraldBarChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {{"r1", "r2"},None}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"Label the rows and columns of the data:"},
			EmeraldBarChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {{"r1", "r2"}, {"c1", "c2", "c3"}}],
			ValidGraphicsP[]
		],

		Example[{Options,Scale,"Create a Log BarChart:"},
			EmeraldBarChart[{1,10,100,1000},Scale->Log],
			(ValidGraphicsP[])?logFrameTicksQ
		],
		Example[{Options,Scale,"Error bars also get scaled in log chart:"},
			EmeraldBarChart[{1,NormalDistribution[10,2],100,NormalDistribution[10000,9000]},Scale->Log],
			(ValidGraphicsP[])?logFrameTicksQ
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldBarChart[{{1.1,2.0,4.3},{1.2, 3.0}},ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldBarChart[{{1.1,2.0,4.3},{1.2, 3.0}},ImageSize->{400,200}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldBarChart[{{1.1,2.0,4.3},{1.2,3.0}},ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ImageSizeRaw,"ImageSizeRaw is an option used for web-embedding, and otherwise has no effect on plot output:"},
			Table[EmeraldBarChart[{{1.1,2.0,4.3},{1.2, 3.0}},ImageSize->200,ImageSizeRaw->sz],{sz,{100,200,20000}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Joined,"Join the tops of the bars with a contiguous line:"},
			EmeraldBarChart[{{1,4,9,4,1}},Joined->True],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Set FrameTicks->None to disable ticks in the plot:"},
			{
				EmeraldBarChart[{{2.0,2.5,2.0},{1.0,1.3,1.0}},ImageSize->250,FrameTicks->Automatic],
				EmeraldBarChart[{{2.0,2.3,2.0},{1.0,1.3,1.0}},ImageSize->250,FrameTicks->None]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldBarChart[{{2.0,2.5,2.0},{1.0,1.3,1.0}},ImageSize->300,FrameTicksStyle->Directive[Red,Thick,16]],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldBarChart[{{2.0,2.5,2.0},{1.0,1.3,1.0}},ImageSize->300,FrameTicksStyle->{{Directive[Green,Thick],None},{Directive[Red,Thick],None}}],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->True to use a frame on all four sides of the plot:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Frame->True
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame->None to hide the frame:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Frame->None
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame with format {{left,right},{bottom,top}} to selectively enable or disable frame walls:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Frame->{{True,True},{False,False}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Frame->True,
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Frame->True,
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"Set PlotRangeClipping->False to allow the bars to display outside of the PlotRange:"},
			{
				EmeraldBarChart[{{0.6,1.3,-0.5}},PlotRange->{Automatic,{0,1.0}},Frame->True,ImageSize->300,PlotRangeClipping->True],
 				EmeraldBarChart[{{0.6,1.3,-0.5}},PlotRange->{Automatic,{0,1.0}},Frame->True,ImageSize->300,PlotRangeClipping->False]
 			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AspectRatio,"Adjust the aspect ratio of the graphic. Default is 1/GoldenRatio:"},
			Table[
				EmeraldBarChart[{{1.1,2.0,4.3},{1.2, 3.0}},ImageSize->200,AspectRatio->aspect],
				{aspect,{Automatic,1.3,0.3}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Background,"Set the background color of the plot:"},
			EmeraldBarChart[{
				{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},
				Background->LightGreen
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Supply a plot title with PlotLabel:"},
			EmeraldBarChart[{{67,98},{92,71},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group"
			],
			ValidGraphicsP[]
		],

		Example[{Options,LabelStyle,"Adjust the font size, font color, formatting, and font type of labels:"},
			EmeraldBarChart[{{67,98},{92,71},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group",
				LabelStyle->{14.`,Orange,Italic,FontFamily->"Helvetica"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to specify {vertical,horizontal} gridlines:"},
			EmeraldBarChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Explicitly specify gridlines, e.g. to increase the grid resolution around particular values:"},
			EmeraldBarChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,{1.0,1.8,2.0,2.2,3.0,4.0,5.0,6.0}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Specify each gridline as a {value,Directive} pair to apply specific styling to individual grid lines:"},
			EmeraldBarChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,{{1.8,Directive[Dashed,Thick,Red]},{2.0,Directive[Blue,Thick]},{2.2,Directive[Dashed,Thick,Red]}}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldBarChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,Automatic},
				GridLinesStyle->Directive[Red,Dashed]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ContentSelectable,"Set ContentSelectable->True to make the bars selectable by click:"},
			{
				EmeraldBarChart[{QuantityArray[{3.1,5.0,2.6},"Meter"]},ImageSize->250,PlotLabel->"Clickable Bars",ContentSelectable->True],
				EmeraldBarChart[{QuantityArray[{3.1,5.0,2.6},"Meter"]},ImageSize->250,PlotLabel->"Unclickable Bars",ContentSelectable->False]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,ColorFunction,"Use a color function to color bars as a function of each bar height:"},
			EmeraldBarChart[Table[Exp[-t^2],{t,-2,2,0.25}],ColorFunction->Function[{height},ColorData["Rainbow"][height]]],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunction,"The color function can specify both color and other graphics options, such as opacity:"},
			EmeraldBarChart[Table[Exp[-t^2],{t,-2,2,0.25}],ColorFunction->Function[{height},Directive[Purple,Opacity[height]]]],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunctionScaling,"By default, the color function uses scaled heights. Absolute heights can be used by setting ColorFunctionScaling->False:"},
			EmeraldBarChart[Table[2*Exp[-t^2],{t,-2,2,0.25}],
				ImageSize->250,
				ColorFunction->Function[{height},If[height<1.3,Blue,Red]],
				ColorFunctionScaling->#
			]&/@{True,False},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldListLinePlot[Table[{x,Sin[x]},{x,0,6.5,0.05}],
				ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,Top},
			{ValidGraphicsP[]..}
		],
		Example[{Options,AlignmentPoint,"The AlignmentPoint can be specified with explicit x-y coordinates:"},
			EmeraldListLinePlot[Table[{x,Sin[x]},{x,0,6.5,0.05}],
				ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{{1.0,2.0},{0.0,Center}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,CoordinatesToolOptions,"Pass options to the CoordinatesTool to determine how coordinates should be display. Select the plot and press \".\" to use the coordinate picker tool:"},
			{
				EmeraldBarChart[{{Replicates[3.0,3.1,3.3,3.2],Replicates[1.5,1.7,2.0,1.1]}},ImageSize->250],
				EmeraldBarChart[{{Replicates[3.0,3.1,3.3,3.2],Replicates[1.5,1.7,2.0,1.1]}},
					ImageSize->250,
					CoordinatesToolOptions->{"DisplayFunction"->Function[pt,Style[pt,Directive[18,Red,Bold]]]}
				]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelingFunction,"Use a labeling function to automatically generate a label for each bar in 15pt bolded red text:"},
			EmeraldBarChart[{1,2,3},LabelingFunction->(Placed[Panel[Style[#1,Directive[Red,Bold,15]],FrameMargins->0],Above]&)],
			ValidGraphicsP[]
		],
		Test["Default tooltips are overidden if tooltips are specified in LabelingFunction:",
			Sort@DeleteDuplicates[Rest/@Cases[
				Cases[
					EmeraldBarChart[{{3, 2, 3}, {4, 6, 5}}, LabelingFunction->(Placed[Style[#,14,Red],Tooltip]&)],
					_Tooltip,
					15
				],
				_Style,
				4
			]],
			{Style[{FontSize->14,FontWeight->Bold,FontFamily->"Arial"}],Style[14,RGBColor[1,0,0]]}
		],
		Test["Default tooltips are preserved if no tooltips are specified in LabelingFunction:",
			Rest/@Cases[
				Cases[
					EmeraldBarChart[{{3, 2, 3}, {4, 6, 5}}, LabelingFunction->(Placed[Style[#,14,Red],Above]&)],
					_Tooltip,
					15
				],
				_Style,
				4
			],
			{Style[Bold,18,FontFamily->"Arial"]..}
		],

		Example[{Options,BarSpacing,"Specify the spacing between bars:"},
			Table[EmeraldBarChart[{3.0,3.0,3.0,3.0,3.0},ImageSize->200,BarSpacing->sp],{sp,{None,Tiny,Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Specify the spacing between bars using explicit widths, where 1.0 corresponds to the width of a single bar:"},
			Table[EmeraldBarChart[{3.0,3.0,3.0,3.0,3.0},ImageSize->200,BarSpacing->sp],{sp,{0.0,0.5,1.0}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Specify the spacing between bars and the spacing between groups, with the syntax {bars, groups}:"},
			{
				EmeraldBarChart[{{5.0,5.0,5.0},{2.0,2.0,2.0}},ImageSize->300,BarSpacing->{None,2.0}],
				EmeraldBarChart[{{5.0,5.0,5.0},{2.0,2.0,2.0}},ImageSize->300,BarSpacing->{Large,None}]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Set a negative BarSpacing to force bars to overlap:"},
			EmeraldBarChart[{{3.0,6.0,9.0},{9.0,6.0,3.0}},BarSpacing->-0.3],
			ValidGraphicsP[]
		],

		Example[{Options,BarOrigin,"Specify from which side bars should be drawn:"},
			Table[EmeraldBarChart[{{1,2,3,4,5}},ImageSize->200,BarOrigin->o,PlotLabel->o],{o,{Bottom,Top,Left,Right}}],
			{ValidGraphicsP[]..}
		],

		(*
			CHART STYLE OPTIONS
		*)
		Example[{Options,ChartBaseStyle,"Apply a style directive to all bars in the bar chart:"},
			EmeraldBarChart[{{67,98},{92,71},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group",
				ChartBaseStyle->Directive[EdgeForm[Dashed]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLayout,"By default, EmeraldBarChart uses ChartLayout->Grouped:"},
			EmeraldBarChart[{{67,98},{92,71},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group"
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLayout,"Use ChartLayout->Stepped to emphasize a change over time in the bar chart:"},
			EmeraldBarChart[{35,15,-20,-10,50}*Percent,
				PlotLabel->"Project Completion",
				ChartLayout->"Stepped",
				ColorFunction->Function[{height},If[height>0,Darker@Green,Red]],
				ChartLabels->{"Jan","Feb","March","April","May"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLayout,"Use ChartLayout->Stacked to emphasize both the distribution and size of each data group:"},
			EmeraldBarChart[{{13,22,80},{90,6,12},{40,Null,13}},
				PlotLabel->"What is Cereal?",
				ChartLayout->"Stacked",
				ChartLabels->{{"Group A","Group B","Group C"},{"Soup","Salad","It's Cereal"}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLayout,"Use ChartLayout->Percentile to emphasize the percentage of each group each bar constitutes:"},
			EmeraldBarChart[{{13,22,80},{90,6,12},{40,Null,13}},
				PlotLabel->"What is Cereal?",
				ChartLayout->"Percentile",
				ChartLabels->{{"Group A","Group B","Group C"},{"Soup","Salad","It's Cereal"}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartStyle,"Pass a single argument to ChartStyle to style all bars the same way:"},
			EmeraldBarChart[{RandomInteger[{1, 10}, 5], RandomInteger[{1, 10}, 5]},ChartStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style the chart named color scheme from ColorData[]:"},
			EmeraldBarChart[{RandomInteger[{1, 10}, 5], RandomInteger[{1, 10}, 5]},ChartStyle->"Pastel"],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of arguments to ChartStyle to apply different styles to each bar in each group:"},
			EmeraldBarChart[{RandomInteger[{1, 10}, 3], RandomInteger[{1, 10}, 3]},ChartStyle->{Red,Blue,Green}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group the same way:"},
			EmeraldBarChart[{RandomInteger[{1, 10}, 3], RandomInteger[{1, 10}, 3]},ChartStyle->{{Red,Green},None}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group and each series of bars in each group, in the format { {group1, group2,..}, {bar1,bar2,bar3,...}}:"},
			EmeraldBarChart[{RandomInteger[{1, 10}, 3], RandomInteger[{1, 10}, 3]},ChartStyle->{{EdgeForm[Dotted],EdgeForm[Dashed]},{Red,Green,Blue}}],
			ValidGraphicsP[]
		],

		(*
			Options which don't do anything, but can be passed to the MM function
		*)
		Example[{Options,Axes,"Axes are unused in bar charts:"},
			Table[
				EmeraldBarChart[{{3,2,1}},ImageSize-> 250,Axes->axesValue],
				{axesValue,{True,False}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,AxesLabel,"Axes are unused in EmeraldBarChart, so the AxesLabel option should have no effect:"},
			EmeraldBarChart[{{3,2,1}},AxesLabel->{"Preposterous","Rhinoceros"}],
			ValidGraphicsP[]
		],
		Example[{Options,AxesStyle,"Axes are unused in EmeraldBarChart, so the AxesLabel option should have no effect:"},
			EmeraldBarChart[{{3,2,1}},AxesStyle->{Directive[Red,12],Blue}],
			ValidGraphicsP[]
		],
		Example[{Options,IntervalMarkers,"The IntervalMarkers used by EmeraldBarChart default to \"Fences\", and currently cannot be changed:"},
			Table[EmeraldBarChart[{{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},ImageSize->200,IntervalMarkers->type],{type,{Automatic,"Bars","Fences","Bands","Ellipses"}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,IntervalMarkersStyle,"IntervalMarkersStyle is not currently supported by EmeraldBarChart, and has no effect on the output plot:"},
			Table[EmeraldBarChart[{{0.95\[PlusMinus]0.1, 1.1\[PlusMinus]0.12, 1.0\[PlusMinus]0.05}},ImageSize->200,IntervalMarkersStyle->sty],{sty,{Automatic,None,Red}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Ticks,"Ticks is unused in EmeraldBarChart - please use FrameTicks instead:"},
			{
				EmeraldBarChart[{{1,2,3}},ImageSize->250,Ticks->None],
				EmeraldBarChart[{{1,2,3}},ImageSize->250,FrameTicks->None]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,TicksStyle,"Ticks is unused in EmeraldBarChart - please use FrameTicksStyle instead:"},
			{
				EmeraldBarChart[{{1,2,3}},ImageSize-> 250,TicksStyle->Red],
				EmeraldBarChart[{{1,2,3}},ImageSize-> 250,FrameTicksStyle->Red]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,PreserveImageOptions,"Specify whether image size and certain other options should be preserved from the previous version of a graphic if the graphic is replaced by a new one in output, e.g. by Dynamics:"},
			EmeraldBarChart[{{1, 1, 1, 1, 1}},PreserveImageOptions->True],
			ValidGraphicsP[]
		],
		Example[{Options,ColorOutput,"ColorOutput has been deprecated and does not affect the plot:"},
			EmeraldBarChart[{{1, 1, 1, 1, 1}},ColorOutput->Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,PerformanceGoal,"PerformanceGoal may be set to either \"Quality\" or \"Speed\". Note that for 2D Graphics, performance is typically comparable between these two options:"},
			{
				EmeraldBarChart[{Table[RandomReal[], {i, 100}]},
					ImageSize->300,
					PerformanceGoal->"Quality"
				]//AbsoluteTiming,
				EmeraldBarChart[{Table[RandomReal[], {i, 100}]},
					ImageSize->300,
					PerformanceGoal->"Quality"
				]//AbsoluteTiming
			},
			{{_,ValidGraphicsP[]}..}
		],

		(*
			MESSAGES
		*)
		Example[{Messages,"IncompatibleUnits","Incompatible units within a data set:"},
			EmeraldBarChart[{1*Meter,2*Foot,3*Second}],
			$Failed,
			Messages:>{EmeraldBarChart::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units across data sets:"},
			EmeraldBarChart[{{1,2,3}*Meter,{2,4,5}*Second}],
			$Failed,
			Messages:>{EmeraldBarChart::IncompatibleUnits}
		],
		Example[{Messages,"ExplicitNullOptions","Options cannot be specified with Null. Null values will be ignored and replace with default option values:"},
			EmeraldBarChart[{{1,2,3}*Meter,{2,4,5}*Meter},Frame->Null],
			ValidGraphicsP[],
			Messages:>{Warning::ExplicitNullOptions}
		],

		(* ValidDocumentationQ requests tests for the following messages, but this function does not return them. *)
		Example[{Messages,"UnresolvedPlotOptions","This message is used exclusively for development and testing, and should not be returned:"},Null,Null],

		(*
			ISSUES
		*)
		Example[{Issues,"Null values","Zero values get a bar with no height, while Null values get no bar:"},
			EmeraldBarChart[{1,0,Null,-1}],
			ValidGraphicsP[]
		],


		(*
			TESTS
		*)
		Test["List of distributions with units:",
			EmeraldBarChart[Map[EmpiricalDistribution,Second*RandomReal[10,{3,20}]]],
			ValidGraphicsP[]
		]

	}
];
