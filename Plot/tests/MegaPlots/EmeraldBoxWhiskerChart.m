(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBoxWhiskerChart*)


DefineTests[EmeraldBoxWhiskerChart,

	{

		Example[{Basic,"Create a Box-Whisker chart from a data set:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3, .4], 1000]],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a Box-Whisker chart comparing multiple data sets:"},
			EmeraldBoxWhiskerChart[{RandomVariate[NormalDistribution[3,.4],1000],RandomVariate[NormalDistribution[4,1],1000],RandomVariate[NormalDistribution[3.5,0.6],1000],RandomVariate[NormalDistribution[2.75,1],1000]}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a Box-Whisker chart comparing groups of data sets:"},
			EmeraldBoxWhiskerChart[{{RandomVariate[NormalDistribution[2,.4],1000],RandomVariate[NormalDistribution[4,0.7],1000]},{RandomVariate[NormalDistribution[2.1,0.6],1000],RandomVariate[NormalDistribution[3.75,.6],1000]},{RandomVariate[NormalDistribution[2.2,0.5],1000],RandomVariate[NormalDistribution[4.2,.9],1000]}}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a Box-Whisker from a QuantityArray:"},
			EmeraldBoxWhiskerChart[QuantityArray[RandomVariate[NormalDistribution[3, .4], 1000],Meter]],
			ValidGraphicsP[]
		],


		(*
			UNITS
		*)
		Example[{Additional,"Units","Data with units:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500]*Meter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Data units can be different, but must be compatible:"},
			EmeraldBoxWhiskerChart[{RandomVariate[NormalDistribution[3,.4],1000]*Yard,RandomVariate[NormalDistribution[12,3],1000]*Foot,RandomVariate[NormalDistribution[2.1*3,0.3*3],1000]*Meter,RandomVariate[NormalDistribution[2.75*36,36],1000]*Inch}],
			ValidGraphicsP[]
		],

		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","Chart a single data set given as a QuantityArray:"},
			EmeraldBoxWhiskerChart[QuantityArray[RandomVariate[NormalDistribution[3, .4], 1000],Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of quantity array data sets:"},
			EmeraldBoxWhiskerChart[{QuantityArray[RandomVariate[NormalDistribution[3,.4],1000],Yard],QuantityArray[RandomVariate[NormalDistribution[12,3],1000],Foot],QuantityArray[RandomVariate[NormalDistribution[2.1*3,0.3*3],1000],Meter],QuantityArray[RandomVariate[NormalDistribution[2.75*36,36],1000],Inch]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of data sets:"},
			EmeraldBoxWhiskerChart[QuantityArray[RandomVariate[PoissonDistribution[3], {4,10}],Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a 3D QuantityArray containing multiple groups of data sets:"},
			EmeraldBoxWhiskerChart[QuantityArray[RandomVariate[PoissonDistribution[3], {4,2,10}],Meter]],
			ValidGraphicsP[]
		],



		(*
			MISSING DATA
		*)
		Example[{Additional,"Missing Data","Null values in a data set are ignored:"},
			EmeraldBoxWhiskerChart[{1,2,Null,4,3,2,2,2,5,4}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values in any data set are ignored:"},
			EmeraldBoxWhiskerChart[{{1,2,Null,4,3,2,2,2,5,4},{2,4,2,Null,3,2,Null,1,2,5}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Entire missing data sets also ignored:"},
			EmeraldBoxWhiskerChart[{{1,2,Null,4,3,2,2,2,5,4},Null,{2,4,2,Null,3,2,Null,1,2,5}}],
			ValidGraphicsP[]
		],


		(*
			OPTIONS
		*)
		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],PlotRange->{{Automatic,3.75},{Automatic,10}}],
			ValidGraphicsP[]
		],
		Example[{Options,PlotRange,"Can mix explicit specification with Automatic resolution:"},
			{
				EmeraldBoxWhiskerChart[{1,2,30,4},PlotRange->{Automatic,Automatic},ImageSize->350],
				EmeraldBoxWhiskerChart[{1,2,30,4},PlotRange->{Automatic,{Automatic,5}},ImageSize->350]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,TargetUnits,"Specify target x-unit for data.  If Automatic, the value is taken as the data's unit.  TargetUnits must be compatible with the data's units:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Foot],
			ValidGraphicsP[]
		],
		Example[{Options,TargetUnits,"Incompatible target unit triggers a message and returns $Failed:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Second],
			$Failed,
			Messages:>{EmeraldBoxWhiskerChart::IncompatibleUnits}
		],

		Example[{Options,AspectRatio,"Adjust the ratio of height to width in the chart:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],ImageSize->300,AspectRatio->1.5],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Set the background color of the plot:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[2, 0.4], 500],
					RandomVariate[NormalDistribution[3, 0.4], 500],
					RandomVariate[NormalDistribution[4, 0.4], 500]
				}},
				Background->LightGreen
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartBaseStyle,"Apply a style directive to all chart elements:"},
			EmeraldBoxWhiskerChart[{{87,88,80,82,85},{92,91,93},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group",
				ChartBaseStyle->Directive[EdgeForm[Directive[Thick,Dashed]]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLabels,"Label each box:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},PlotLabel->"Average Exam Score",ChartLabels->{"Group 1","Group 2"}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"Given nested data, label only the groups:"},
			EmeraldBoxWhiskerChart[{{RandomVariate[NormalDistribution[2,.4],1000],RandomVariate[NormalDistribution[4,0.7],1000]},{RandomVariate[NormalDistribution[2.1,0.6],1000],RandomVariate[NormalDistribution[3.75,.6],1000]},{RandomVariate[NormalDistribution[2.2,0.5],1000],RandomVariate[NormalDistribution[4.2,.9],1000]}},
				ChartLabels -> {{"Data Group 1", "Data Group 2","Data Group 3"},None}
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"Label the rows and columns of the data:"},
			EmeraldBoxWhiskerChart[{{RandomVariate[NormalDistribution[2,.4],1000],RandomVariate[NormalDistribution[4,0.7],1000]},{RandomVariate[NormalDistribution[2.1,0.6],1000],RandomVariate[NormalDistribution[3.75,.6],1000]},{RandomVariate[NormalDistribution[2.2,0.5],1000],RandomVariate[NormalDistribution[4.2,.9],1000]}},
				ChartLabels -> {{"Data Group 1", "Data Group 2","Data Group 3"},{"Test A","Test B"}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLayout,"By default, EmeraldBoxWhiskerChart uses ChartLayout->Grouped:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},
				ChartLabels->{{"Sample 1","Sample 2","Sample 3"},None},
				PlotLabel->"Absorbance Measurement Distribution"
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLayout,"ChartLayout options are residual, as box whisker charts are built off of bar charts. Though they can be used, chart layouts such as \"Stacked\" and \"Percentile\" are not sensible for box-whisker charts:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},
				ChartLabels->{{"Sample 1","Sample 2","Sample 3"},None},
				PlotLabel->"Absorbance Measurement Distribution",
				ChartLayout->"Stacked"
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartStyle,"Pass a single argument to ChartStyle to style all boxes the same way:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},ChartStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style the chart using a named color scheme from ColorData[]:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},ChartStyle->"Pastel"],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of arguments to ChartStyle to apply different styles to each box in each group:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},ChartStyle->{Red,Blue,Green}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group the same way:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},ChartStyle->{{Red,Green},None}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group and each series of boxes in each group, in the format { {group1, group2,..}, {box1,box2,box3,...}}:"},
			EmeraldBoxWhiskerChart[{absData1,absData2},ChartStyle->{{EdgeForm[Dotted],EdgeForm[Dashed]},{Red,Green,Blue}}],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Use Prolog to add graphics to the plot that should be rendered before the plot data:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],Prolog->{Disk[{1,3.05},{1,1.2}]}],
			ValidGraphicsP[]
		],

		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldHistogram:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],Epilog->{Disk[{3,2},{1,0.5}]}],
			ValidGraphicsP[]
		],

		Example[{Options,BarSpacing,"Specify the spacing between chart elements:"},
			Table[EmeraldBoxWhiskerChart[{Repeat[RandomVariate[NormalDistribution[3, 0.5],100],3]},ImageSize->200,BarSpacing->sp],{sp,{None,Tiny,Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Specify the spacing between chart elements using explicit widths, where 1.0 corresponds to the width of a single box:"},
			Table[EmeraldBoxWhiskerChart[{Repeat[RandomVariate[NormalDistribution[3, 0.5],100],3]},ImageSize->200,BarSpacing->sp],{sp,{0.0,0.5,1.0}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Specify the spacing between boxes and the spacing between groups, with the syntax {bars, groups}:"},
			{
				EmeraldBoxWhiskerChart[{absData1,absData2},ImageSize->300,Frame->True,BarSpacing->{None,2.0}],
				EmeraldBoxWhiskerChart[{absData1,absData2},ImageSize->300,Frame->True,BarSpacing->{Medium,None}]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,BarSpacing,"Set a negative spacing to force chart elements to overlap:"},
			EmeraldBoxWhiskerChart[{absData1},ImageSize->250,BarSpacing->-0.7],
			ValidGraphicsP[]
		],

		Example[{Options,BarOrigin,"Specify the direction from which the box-whisker elements should be drawn:"},
			Table[
				EmeraldBoxWhiskerChart[{{
						RandomVariate[NormalDistribution[1, 0.2], 500],
						RandomVariate[NormalDistribution[3, 0.4], 500],
						RandomVariate[NormalDistribution[4, 1.2], 500]
					}},
					ImageSize->250,
					PlotLabel->ToString[dir],
					BarOrigin->dir
				],
				{dir,{Bottom,Top,Left,Right}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],ImageSize->{300,400}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ImageSizeRaw,"ImageSizeRaw is an option used for web-embedding, and otherwise has no effect on plot output:"},
			Table[EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],ImageSize->200,ImageSizeRaw->sz],{sz,{100,200,20000}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelingFunction,"Use a labeling function to automatically generate a label for each bar in 15pt bolded red text:"},
			EmeraldBoxWhiskerChart[AbsorbanceUnit*{{1.2,2,2,2,3},{4,4,4,5,1}},LabelingFunction->(Placed[Panel[Style[#1,Directive[Red,Bold,15]],FrameMargins->0],Above]&)],
			ValidGraphicsP[]
		],
		Example[{Options,LabelStyle,"Adjust the font size, font color, formatting, and font type of all labels in the plot:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],
				PlotLabel->"Average Score by Group",
				LabelStyle->{14.`,Orange,Italic,FontFamily->"Helvetica"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->True to use a frame on all four sides of the plot:"},
			EmeraldBoxWhiskerChart[randomDataTwoByThree,Frame->True],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame->None to hide the frame:"},
			EmeraldBoxWhiskerChart[randomDataTwoByThree,Frame->None],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame with format {{left,right},{bottom,top}} to selectively enable or disable frame walls:"},
			EmeraldBoxWhiskerChart[randomDataTwoByThree,Frame->{{True,True},{False,False}}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],FrameLabel->{Automatic,"Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,RotateLabel,"By default, the y-axis frame label is rotated. Set RotateLabel->False to leave this label horizontal:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500],FrameLabel->{"Experiment","Distance Traveled"},RotateLabel->False],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[2, 0.4], 500],
					RandomVariate[NormalDistribution[3, 0.4], 500],
					RandomVariate[NormalDistribution[4, 0.4], 500]
				}},
				Frame->True,
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[2, 0.4], 500],
					RandomVariate[NormalDistribution[3, 0.4], 500],
					RandomVariate[NormalDistribution[4, 0.4], 500]
				}},
				Frame->True,
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Set FrameTicks->None to remove ticks from the plot:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				FrameTicks->None
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				FrameTicksStyle->Directive[Red,Thick,16]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				FrameTicksStyle->{{Directive[Green,Thick],None},{Directive[Red,Thick],None}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameUnits,"Specify a label and automatically append the data's units:"},
			EmeraldBoxWhiskerChart[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameUnits->Automatic,FrameLabel->{"Experiment","Distance Traveled"}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to specify {vertical,horizontal} gridlines:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Explicitly specify gridlines, e.g. to increase the grid resolution around particular values:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				GridLines->{None,{0,20,40,60,75,70,75,80,100}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Specify each gridline as a {value,Directive} pair to apply specific styling to individual grid lines:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				GridLines->{None,{{60,Directive[Dashed,Thick,Red]},{70,Directive[Blue,Thick]},{80,Directive[Dashed,Thick,Red]}}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldBoxWhiskerChart[{testDataGroup1,testDataGroup2},
				PlotLabel->"Average Exam Score",
				ChartLabels->{"Group 1","Group 2"},
				GridLines->{None,Automatic},
				GridLinesStyle->Directive[Red,Dashed]
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Label the plot with a centered plot title:"},
			EmeraldBoxWhiskerChart[{{87,88,80,82,85},{92,91,93},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->"Average Score by Group"
			],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel,"Apply a style directive to the plot label:"},
			EmeraldBoxWhiskerChart[{{87,88,80,82,85},{92,91,93},{87,89}},
				ChartLabels->{{"Group 1","Group 2","Group 3"},{"A","B"}},
				PlotLabel->Style["Average Score by Group",Directive[Red,Bold,16]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,Joined,"Join box-whiskers in the same data grouping with a line:"},
			EmeraldBoxWhiskerChart[randomDataTwoByThree,Joined->True],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Specify a legend:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[2, 0.4], 500],
	  			RandomVariate[NormalDistribution[3, 0.4], 500],
	  			RandomVariate[NormalDistribution[4, 0.4], 500]
				}},
				Legend->{"A","B","C","D"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Specify a legend:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[2, 0.4], 500],
	  			RandomVariate[NormalDistribution[3, 0.4], 500],
	  			RandomVariate[NormalDistribution[4, 0.4], 500]
				}},
				Legend->{"A","B","C","D"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Boxes,"Use swatch boxes in legend:"},
			EmeraldBoxWhiskerChart[List@{RandomVariate[NormalDistribution[2,.4],500],RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,.4],500]},Legend->{"A","B","C","D"},Boxes->True],
			Legended[ValidGraphicsP[],{Placed[_SwatchLegend,___]}]
		],
		Example[{Options,Boxes,"Use line segments in legend instead of swatch boxes:"},
			EmeraldBoxWhiskerChart[List@{RandomVariate[NormalDistribution[2,.4],500],RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,.4],500]},Legend->{"A","B","C","D"},Boxes->False],
			Legended[ValidGraphicsP[],{Placed[_LineLegend,___]}]
		],


		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldBoxWhiskerChart[{{
						RandomVariate[NormalDistribution[2, 0.4], 500],
		  			RandomVariate[NormalDistribution[3, 0.4], 500],
		  			RandomVariate[NormalDistribution[4, 0.4], 500]
					}},Legend->{"A","B","C","D"},LegendPlacement->Top],
				EmeraldBoxWhiskerChart[{{
						RandomVariate[NormalDistribution[2, 0.4], 500],
		  			RandomVariate[NormalDistribution[3, 0.4], 500],
		  			RandomVariate[NormalDistribution[4, 0.4], 500]
					}},Legend->{"A","B","C","D"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotRangeClipping,"Set PlotRangeClipping->False to allow chart elements to display outside of the PlotRange:"},
			EmeraldBoxWhiskerChart[{{
					RandomVariate[NormalDistribution[1, 0.2], 500],
	  			RandomVariate[NormalDistribution[5, 3], 500],
	  			RandomVariate[NormalDistribution[1.5, 1.2], 500]
				}},
				PlotRange->{{0.5,Automatic},{0,6}},
				Frame->True,
				ImageSize->{300,270},
				PlotRangeClipping->False
			],
			ValidGraphicsP[]
		],

		Example[{Options,Scale,"Create a Log BoxWhiskerChart:"},
			EmeraldBoxWhiskerChart[Table[RandomVariate[NormalDistribution[m,m/5],500],{m,{1,10,100,1000}}],Scale->Log],
			(ValidGraphicsP[])?logFrameTicksQ
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"IncompatibleUnits","Incompatible units within a data set:"},
			EmeraldBoxWhiskerChart[{1*Meter,2*Foot,3*Second}],
			$Failed,
			Messages:>{EmeraldBoxWhiskerChart::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units across data sets:"},
			EmeraldBoxWhiskerChart[{RandomVariate[NormalDistribution[3,.4],500]*Meter,RandomVariate[NormalDistribution[4,1],600]*Second}],
			$Failed,
			Messages:>{EmeraldBoxWhiskerChart::IncompatibleUnits}
		]



		(*
			ISSUES
		*)


		(*
			TESTS
		*)


	},

	SetUp:>{
		randomDataTwoByThree=Table[RandomVariate[NormalDistribution[RandomInteger[5],1],100],{2},{3}];
		testDataGroup1={77,73,74,79,72,71,70,79,96,23,78,83,85};
		testDataGroup2={91,92,90,94,92,90,65,62,63,64,62,68,0};
		absData1={RandomVariate[NormalDistribution[1, 0.5], 500],RandomVariate[NormalDistribution[1.2, 0.3], 500],RandomVariate[NormalDistribution[1.1, 0.2], 500]}*AbsorbanceUnit;
		absData2={RandomVariate[NormalDistribution[2.1, 0.4], 500],RandomVariate[NormalDistribution[1.7, 0.3], 500],RandomVariate[NormalDistribution[1.6, 0.2], 500]}*AbsorbanceUnit;
	}
];
