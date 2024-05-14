(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram*)


DefineTests[EmeraldHistogram,

	{

		Example[{Basic,"Create a histogram:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3, .4], 500]],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a histogram containing multiple data sets:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,1],600]}],
			ValidGraphicsP[]
		],


		(*
			UNITS
		*)
		Example[{Additional,"Units","Data with units:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Data units can be different, but must be compatible:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[3,.4],500]*Yard,RandomVariate[NormalDistribution[4,1],600]*Foot}],
			ValidGraphicsP[]
		],


		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","Chart a single data set given as a QuantityArray:"},
			EmeraldHistogram[QuantityArray[RandomVariate[NormalDistribution[3, .4], 1000],Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of quantity array data sets:"},
			EmeraldHistogram[{QuantityArray[RandomVariate[NormalDistribution[3,.4],1000],Yard],QuantityArray[RandomVariate[NormalDistribution[12,3],1000],Foot],QuantityArray[RandomVariate[NormalDistribution[2.1*3,0.3*3],1000],Meter],QuantityArray[RandomVariate[NormalDistribution[2.75*36,36],1000],Inch]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of data sets:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[2.1*3,0.3*3],1000]},Meter]],
			ValidGraphicsP[]
		],



		(*
			MISSING DATA
		*)
		Example[{Additional,"Missing Data","Null values in a data set are ignored:"},
			EmeraldHistogram[{1,2,Null,4,3,2,2,2,5,4}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values in any data set are ignored:"},
			EmeraldHistogram[{{1,2,Null,4,3,2,2,2,5,4},{2,4,2,Null,3,2,Null,1,2,5}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Entire missing data sets also ignored:"},
			EmeraldHistogram[{{1,2,Null,4,3,2,2,2,5,4},Null,{2,4,2,Null,3,2,Null,1,2,5}}],
			ValidGraphicsP[]
		],


		(*
			OPTIONS
		*)
		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->{{Automatic,3.75},{Automatic,10}}],
			ValidGraphicsP[]
		],
		Test["Full PlotRange does not crash (mathematica bug):",
			{EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->Full],
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->{Full,Full}]},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,PlotRange,"Can mix explicit specification with Automatic resolution:"},
			{
				EmeraldHistogram[{1,2,30,4},PlotRange->{Automatic,Automatic},ImageSize->350],
				EmeraldHistogram[{1,2,30,4},PlotRange->{Automatic,{Automatic,5}},ImageSize->350]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,TargetUnits,"Specify target x-unit for data.  If Automatic, the value is taken as the data's unit.  TargetUnits must be compatible with the data's units:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Foot],
			ValidGraphicsP[]
		],
		Example[{Options,TargetUnits,"Incompatible target unit triggers a message and returns $Failed:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Second],
			$Failed,
			Messages:>{EmeraldHistogram::IncompatibleUnits}
		],

		Example[{Options,AspectRatio,"Adjust the ratio of height to width in the output plot. Default is 1/GoldenRatio:"},
			Table[
				EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],ImageSize->200,AspectRatio->aspect],
				{aspect,{1/GoldenRatio,1.3,0.3}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,BarOrigin,"Specify from which direction histogram bars should be drawn:"},
			Table[
				EmeraldHistogram[RandomVariate[NormalDistribution[2.0,0.5],100]*Second,ImageSize->250,PlotLabel->o,BarOrigin->o],
				{o,{Bottom,Top,Left,Right}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Background,"Set the background color of the plot:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],Background->LightGreen],
			ValidGraphicsP[]
		],

		Example[{Options,ChartBaseStyle,"Apply a style directive to all bars in the histogram:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,4,6,8}}],
					ChartBaseStyle->Directive[Thick,EdgeForm[Dashed]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartElementFunction,"Choose a chart element function from a list of presets, which can be viewed by running ChartElementData[\"Histogram\"] in the notebook. Automatic defaults to \"Rectangle\":"},
			Table[
				EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,4,6,8}}],
					ImageSize->300,
					PlotLabel->cf,
					ChartElementFunction->cf
				],
				{cf,{"Rectangle","ArrowRectangle","EdgeFadingRectangle","FadingRectangle"}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,ChartElementFunction,"Write a custom chart element function which maps the corners of a rectangle to an arbitrary grahpics primitive:"},
			hourglassFunc[{{xmin_,xmax_},{ymin_,ymax_}},___]:=Polygon[{{xmin, ymin}, {xmax, ymax}, {xmin, ymax}, {xmax, ymin}}];
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,5}}],
				ChartElementFunction->hourglassFunc
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElementFunction,"Some built-in chart element functions take options. As an example, you can view the options for the default Rectangle function by running ChartElementData[\"Rectangle\", \"Options\"] in the notebook:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,4,6,8}}],
				ChartElementFunction->ChartElementData["Rectangle","RoundingRadius"->15]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLayout,"The ChartLayout for EmeraldHistogram can be specified as either \"Overlapped\" or \"Stacked\":"},
			Table[
				EmeraldHistogram[{dataset1,dataset2},ImageSize->350,PlotLabel->layout,ChartLayout->layout],
				{layout,{"Overlapped","Stacked"}}
			],
			{ValidGraphicsP[]..},
			SetUp:>(
				dataset1=RandomVariate[NormalDistribution[3,2.0],1000];
				dataset2=RandomVariate[NormalDistribution[6,2.0],1000];
			)
		],

		Example[{Options,ChartStyle,"Pass a single argument to ChartStyle to style all bars the same way:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.7],1000],{x,{0,5,10}}],ChartStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style the chart named color scheme from ColorData[]:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.7],1000],{x,{0,5,10}}],ChartStyle->"Pastel"],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of arguments to ChartStyle to apply different styles to each bar in each group:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.7],1000],{x,{0,5,10}}],ChartStyle->{Red,Blue,Green}],
			ValidGraphicsP[]
		],

		Example[{Options,ChartElements,"Use any graphics primitive instead of bars in the histogram:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[2.0,0.5],100]*Second,
				ChartElements->Graphics[Disk[]]
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElements,"Use an image instead of bars in the histogram:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[2.0,0.5],10]*Second,
				ChartElements->Import["ExampleData/spikey.tiff"]
		 	],
			ValidGraphicsP[]
		],

		Example[{Options,ChartElements,"Stretch a graphic vertically to the bar height instead of generating additional copies:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[2.0, 0.5], 100]*Second,
		 		ChartElements->{Graphics[Disk[]],All}
		 	],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElements,"Use different chart elements for each dataset in the plot:"},
			EmeraldHistogram[{
					RandomVariate[NormalDistribution[2.0,0.5],1000]*Second,
					RandomVariate[NormalDistribution[4.0,0.5],1000]*Second,
					RandomVariate[NormalDistribution[6.0,0.5],1000]*Second
				},
				ChartElements->{Graphics[RegularPolygon[3]],Graphics[RegularPolygon[4]],Graphics[RegularPolygon[5]]}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLabels,"When multiple input datasets are provided, label each dataset:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,4,6,8}}],
					ChartLabels->{"Group A","Group B","Group C","Group D"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelStyle,"Apply a style directive to all label-like elements of the plot:"},
			EmeraldHistogram[Table[RandomVariate[NormalDistribution[x,0.5],1000],{x,{2,4,6,8}}],
					ChartLabels->{"Group A","Group B","Group C","Group D"},
					LabelStyle->{20,Orange,Italic,FontFamily->"Helvetica"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[5,0.5],1000],ColorFunction->"Rainbow"],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunction,"The color function for a histogram can be given explicitly as a function which converts a count to a style directive:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[5,0.5],1000],
				ColorFunction->Function[{height},Directive[Purple,Opacity[height]]]
			],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunctionScaling,"By default, the color function uses scaled heights, where 1.0 is the maximum count. Absolute counts can be used by setting ColorFunctionScaling->False:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[5,0.5],1000],
				ImageSize->250,
				ColorFunction->Function[{height},If[height<100,Blue,Red]],
				ColorFunctionScaling->#
			]&/@{True,False},
			{ValidGraphicsP[]..}
		],

		Example[{Options,Prolog,"Use Prolog to render graphics primitives prior to Histogram graphics such that they are rendered behind histogram bars:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Prolog->{Style[Disk[{3,30},{1.2,25}],Red]}],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldHistogram:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Epilog->{Disk[{3,30},{.5,20}]}],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->True to use a frame on all four sides of the plot:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame->None to hide the frame:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->None
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame with format {{left,right},{bottom,top}} to selectively enable or disable frame walls:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->{{True,True},{False,False}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True,
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True,
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Set FrameTicks->None to disable ticks in the plot:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				FrameTicks->None
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				FrameTicksStyle->Directive[Red,Thick,16]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				FrameTicksStyle->{{Directive[Green,Thick],None},{Directive[Red,Thick],None}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{"Distance Traveled","Recorded Instances"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{Automatic,"Recorded Instances"}],
			ValidGraphicsP[]
		],
		Example[{Options,RotateLabel,"By default, the y-axis frame label is rotated. Set RotateLabel->False to leave the label horizontal:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{"Distance Traveled","Recorded Instances"},RotateLabel->False],
			ValidGraphicsP[]
		],

		Example[{Options,FrameUnits,"Specify a label and automatically append the data's units:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameUnits->Automatic,FrameLabel->{"Distance Traveled","Recorded Instances"}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to specify {vertical,horizontal} gridlines:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Explicitly specify gridlines, e.g. to increase the grid resolution around particular values:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				GridLines->{None,{5,9,10,11,15,20}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Specify each gridline as a {value,Directive} pair to apply specific styling to individual grid lines:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				GridLines->{None,
					{5,{9,Directive[Dashed,Thick,Red]},{10,Directive[Blue,Thick]},{11,Directive[Dashed,Thick,Red]},15,20}
				}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				GridLines->{None,Automatic},
				GridLinesStyle->Directive[Red,Dashed]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],ImageSize->{400,200}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ImageSizeRaw,"ImageSizeRaw is an option used for web-embedding, and otherwise has no effect on plot output:"},
			Table[EmeraldHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,2.5],1000],RandomVariate[NormalDistribution[6.3,1.1],1000]},AbsorbanceUnit],ImageSize->200,ImageSizeRaw->sz],{sz,{100,200,20000}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelingFunction,"Use a labeling function to automatically generate a label showing the counts in each histogram bar, in 15pt bolded red text:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[2.0,0.7],100],
				PlotRange->{Automatic,{0,40}},
				LabelingFunction->(Placed[Panel[Style[#1,Directive[Red,Bold,15]],FrameMargins->0],Above]&)
			],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Specify a legend:"},
			EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Legend->{"A","B","C","D"}],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Specify a legend:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,1],600]},Legend->{"A","B","C","D"}],
			ValidGraphicsP[]
		],

		Example[{Options,Boxes,"Use swatch boxes in legend:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[2,.4],500],RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,.4],500]},Legend->{"A","B","C","D"},Boxes->True],
			Legended[ValidGraphicsP[],{Placed[_SwatchLegend,___]}]
		],
		Example[{Options,Boxes,"Use line segments in legend instead of swatch boxes:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[2,.4],500],RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,.4],500]},Legend->{"A","B","C","D"},Boxes->False],
			Legended[ValidGraphicsP[],{Placed[_LineLegend,___]}]
		],


		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Legend->{"A","B","C","D"},LegendPlacement->Top],
				EmeraldHistogram[RandomVariate[NormalDistribution[3,.4],500],Legend->{"A","B","C","D"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotLabel,"Supply a plot title with PlotLabel:"},
			EmeraldHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year"
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"PlotRangeClipping determines whether plot elements will be drawn outside of the plot range, and is set to True by default:"},
			{
				EmeraldHistogram[{RandomVariate[NormalDistribution[5.0,0.1],1000],RandomVariate[NormalDistribution[4.0,0.5],1000]},
					PlotRange->{Automatic,{0,300}},
					Frame->True,
					ImageSize->300,
					PlotLabel->"With Clipping",
					PlotRangeClipping->True
				],
				EmeraldHistogram[{RandomVariate[NormalDistribution[5.0,0.1],1000],RandomVariate[NormalDistribution[4.0,0.5],1000]},
					PlotRange->{Automatic,{0,300}},
					Frame->True,
					ImageSize->300,
					PlotLabel->"No Clipping",
					PlotRangeClipping->False
				]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,Scale,"Create a Log Histogram:"},
			EmeraldHistogram[RandomVariate[CauchyDistribution[1000,5],5000],Scale->Log],
			(ValidGraphicsP[])?logFrameTicksQ
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"IncompatibleUnits","Incompatible units within a data set:"},
			EmeraldHistogram[{1*Meter,2*Foot,3*Second}],
			$Failed,
			Messages:>{EmeraldHistogram::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units across data sets:"},
			EmeraldHistogram[{RandomVariate[NormalDistribution[3,.4],500]*Meter,RandomVariate[NormalDistribution[4,1],600]*Second}],
			$Failed,
			Messages:>{EmeraldHistogram::IncompatibleUnits}
		]

	}

];
