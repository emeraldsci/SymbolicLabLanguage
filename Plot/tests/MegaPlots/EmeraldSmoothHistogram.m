(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram*)


DefineTests[EmeraldSmoothHistogram,

	{

		Example[{Basic,"Create a smooth histogram:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3, .4], 500]],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a smooth histogram containing multiple data sets:"},
			EmeraldSmoothHistogram[{RandomVariate[NormalDistribution[3,.4],500],RandomVariate[NormalDistribution[4,1],600]}],
			ValidGraphicsP[]
		],

		(*
			UNITS
		*)
		Example[{Additional,"Units","Data with units:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Data units can be different, but must be compatible:"},
			EmeraldSmoothHistogram[{RandomVariate[NormalDistribution[3,.4],500]*Yard,RandomVariate[NormalDistribution[4,1],600]*Foot}],
			ValidGraphicsP[]
		],


		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","Chart a single data set given as a QuantityArray:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[NormalDistribution[3, .4], 1000],Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of quantity array data sets:"},
			EmeraldSmoothHistogram[{QuantityArray[RandomVariate[NormalDistribution[3,.4],1000],Yard],QuantityArray[RandomVariate[NormalDistribution[12,3],1000],Foot],QuantityArray[RandomVariate[NormalDistribution[2.1*3,0.3*3],1000],Meter],QuantityArray[RandomVariate[NormalDistribution[2.75*36,36],1000],Inch]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of data sets:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[2.1*3,0.3*3],1000]},Meter]],
			ValidGraphicsP[]
		],



		(*
			OPTIONS
		*)

		Example[{Options,DistributionFunction,"Specify the distribution function used for plotting the histogram. This can be PDF, CDF, and a number of other options:"},
			Table[
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,
					DistributionFunction->df,ImageSize->150,PlotLabel->df
				],
				{df,{"PDF","CDF","HF","CHF"}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,TargetUnits,"Specify target x-unit for data.  If Automatic, the value is taken as the data's unit.  TargetUnits must be compatible with the data's units:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Foot],
			ValidGraphicsP[]
		],

		Example[{Options,TargetUnits,"Incompatible target unit triggers a message and returns $Failed:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Second],
			$Failed,
			Messages:>{EmeraldSmoothHistogram::IncompatibleUnits}
		],

		Example[{Options,Frame,"Specify the frames, as {{left,right},{bottom,top}}. If True, all frames will be drawn:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,TargetUnits->Foot,Frame->{{True,True},{True,False}}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Specify the frames style, including the color and line style:"},
			EmeraldSmoothHistogram[
				{
					RandomVariate[NormalDistribution[3,.4],500]*Meter,
					RandomVariate[PoissonDistribution[1], 10]*Meter
				},
				TargetUnits->Foot,Frame->True,FrameStyle->Directive[Orange,12]
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->{{Automatic,3.75},{Automatic,10}}],
			ValidGraphicsP[]
		],
		Test["Full PlotRange does not crash (mathematica bug):",
			{EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->Full],
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],PlotRange->{Full,Full}]},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,PlotRange,"Can mix explicit specification with Automatic resolution:"},
			{
				EmeraldSmoothHistogram[{1,2,30,4},PlotRange->{Automatic,Automatic},ImageSize->350],
				EmeraldSmoothHistogram[{1,2,30,4},PlotRange->{Automatic,{Automatic,5}},ImageSize->350]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{"Distance Traveled","Recorded Instances"}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{Automatic,"Recorded Instances"}],
			ValidGraphicsP[]
		],


		Example[{Options,FrameUnits,"Specify a label and automatically append the data's units:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameUnits->Automatic,FrameLabel->{"Distance Traveled","Recorded Instances"}],
			ValidGraphicsP[]
		],

		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,LabelStyle,"Change the label style, the font, fontsize and color:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],Frame->True,PlotLabel->"My Distribution",LabelStyle->Directive[Blue,FontSize->14,FontFamily->"Helvetica"]],
			ValidGraphicsP[]
		],

		Example[{Options,Axes,"Remove the axes ticks to False:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[ExponentialDistribution[1],500],"Meter"],Axes->False],
			ValidGraphicsP[]
		],

		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[ExponentialDistribution[1],500],"Meter"],
				DistributionFunction->"CDF",ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,{-1,-1}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AspectRatio,"Change the aspect ratio of the histogram chart:"},
			EmeraldSmoothHistogram[Table[RandomVariate[WeibullDistribution[c, 2],500],{c,{0.5,2,4}}],AspectRatio->0.5],
			ValidGraphicsP[]
		],

		Example[{Options,AxesStyle,"Change the style of the axes to be orange and thick with a different font size. Note that Frame->False is required to get the correct behavior for Axes:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[ExponentialDistribution[1],500],"Meter"],Frame->False,Axes->{False,True},AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesOrigin,"Change the origin of the axes to left in the x-direction. Note that Frame->False is required to get the correct behavior for Axes:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[ExponentialDistribution[1],500],"Meter"],AxesOrigin->{0,1},Frame->False,Axes->{False,True},AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesLabel,"Add label for an axis. Note that Frame->False is required to get the correct behavior for Axes:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[ExponentialDistribution[1],500],"Meter"],AxesOrigin->{0,1},Frame->False,Axes->{False,True},AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Change the background color to light blue:"},
			EmeraldSmoothHistogram[QuantityArray[RandomVariate[RayleighDistribution[0.5],100],"Second"],Background->LightBlue],
			ValidGraphicsP[]
		],

		Example[{Options,BaseStyle,"Change the base style of the plot:"},
			EmeraldSmoothHistogram[RandomVariate[WeibullDistribution[1,0.1],100],BaseStyle->Red],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Change the clipping style to show different line styles if the data is cut in a certain region:"},
			Table[
				EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],500],
					PlotRange->{All,{0,300}},
					ClippingStyle->cs,
					ImageSize->200
				],
				{cs,{Green,Red,Dashed}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data x coordinate values:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],500],
				ColorFunction->Function[{x,y},Hue[x]],
				Filling->Axis
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Provide a custom color function based on the data y coordinate values and scaling the color based on the values:"},
			{
				EmeraldSmoothHistogram[myRandomDistribution,
					ColorFunction->Function[{x,y},Hue[y]],
					ImageSize->300,
					ColorFunctionScaling->True,
					PlotStyle->Thick
				],
				EmeraldSmoothHistogram[myRandomDistribution,
					ColorFunction->Function[{x,y},Hue[y]],
					ImageSize->300,
					ColorFunctionScaling->False,
					PlotStyle->Thick
				]
			},
			ConstantArray[ValidGraphicsP[],2],
			SetUp:>(
				myRandomDistribution=RandomVariate[ExponentialDistribution[1],500];
			)
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,0.5],500],ImageSize->300,DisplayFunction->(PopupWindow[Button["My Distribution"], #]&)],
			_Button
		],

		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldSmoothHistogram:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500],Epilog->{Disk[{3,30},{.5,20}]}],
			ValidGraphicsP[]
		],

		Example[{Options,Epilog,"Add points that approximate the distribution to the histogram line that is rendered after the line:"},
			EmeraldSmoothHistogram[randomData,Epilog->{PointSize[Medium],Point[dataPoints]}],
			ValidGraphicsP[],
			SetUp:>(
				randomData=RandomVariate[NormalDistribution[1,0.75],500];
				histogramList=HistogramList[randomData,{1},"PDF"];
				dataPoints=Transpose[{MovingAverage[histogramList[[1]],2],histogramList[[2]]}];
			)
		],

		Example[{Options,Filling,"Fill under the histogram either top, bottom or with respect to a certain axis or certain y value:"},
			Table[
				EmeraldSmoothHistogram[Range[-2,2,0.05],
					DistributionFunction->"PDF",ImageSize->150,Filling->c,PlotLabel->c
				],
				{c,{Top,Bottom,Axis,0.1}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Filling,"Fill one curve with respect to another curve:"},
			EmeraldSmoothHistogram[
				{
					RandomVariate[NormalDistribution[],14],
						RandomVariate[PoissonDistribution[1],10]
				},
				DistributionFunction->"PDF",Filling->{1->{2}},PlotLegends->Automatic
			],
			ValidGraphicsP[]
		],

		Example[{Options,FillingStyle,"Fill with gray under the surface in a certain region:"},
			Table[
				EmeraldSmoothHistogram[
					{
						RandomVariate[NormalDistribution[],14],
						RandomVariate[PoissonDistribution[1],10]
					},
					FillingStyle->c,ImageSize->300,Filling->{1->{2}}
				],
				{c,{{Opacity[0.2],Gray},Green}}
			],
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,FormatType,"Add a textbox with standard form:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],14],FormatType->StandardForm,Epilog->Inset[Framed[Style["Constant plane",20],Background->LightYellow],Center]],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->True to use a frame on all four sides of the plot:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame->None to hide the frame:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->None
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame with format {{left,right},{bottom,top}} to selectively enable or disable frame walls:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->{{True,True},{False,False}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True,
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldSmoothHistogram[QuantityArray[{RandomVariate[NormalDistribution[12,3],1000],RandomVariate[NormalDistribution[6.3,0.9],1000]},Meter],
				Frame->True,
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Custom define the location of the ticks in x and y axes:"},
			EmeraldSmoothHistogram[Range[-10,10,0.05],
				FrameTicks->{{Range[5,40,5],None},{{-10,-5,10},None}},
				FrameTicksStyle->Directive[Red,Thick,16]
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldSmoothHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				FrameTicksStyle->Directive[Red,Thick,16]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldSmoothHistogram[RandomVariate[PoissonDistribution[1.5],50],
				FrameLabel->{"Deaths per year",Automatic},
				PlotRange->{{Automatic,10},Automatic},
				PlotLabel->"Prussian soldiers killed by horse-kick per year",
				FrameTicksStyle->{{Directive[Green,Thick],None},{Directive[Red,Thick],None}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,FrameLabel->{"Distance Traveled","Recorded Instances"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],500]*Meter,DistributionFunction->"PDF",FrameLabel->{Automatic,"Probability Distribution"}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Show grid lines at specific locations in x and y axes:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],100],Mesh->10,GridLines->{{0,1,2},{100,200,300}}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Controlling the style of the grid lines:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],100],Mesh->10,GridLines->{{{0,Dashed}, {2,Thick}},{{100,Orange},200,{300,Orange}}}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Use a specific grid style for all grid lines:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],100],Mesh->10,GridLines->{{0,1,2},{100,200,300}},GridLinesStyle->Directive[Orange,Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,Mesh,"Use a specifc mesh style for 10 mesh points at certain locations:"},
			EmeraldSmoothHistogram[RandomVariate[UniformDistribution[{1,10}],100],
				Mesh->{Range[0,12,2]},MeshStyle->PointSize[Medium]
			],
			ValidGraphicsP[]
		],

		Example[{Options,MeshShading,"Use a two color pattern to show the mesh points:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],100],Mesh->10,MeshShading->{{Yellow},{Green}}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshFunctions,"Use x values to describe the mesh function to change some segments of the histogram line:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],100],Mesh->10,PlotStyle->Directive[Thick,Yellow],MeshFunctions->{#1 &},MeshShading->{Red,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshStyle,"Use a red mesh in the x direction:"},
			EmeraldSmoothHistogram[RandomVariate[WeibullDistribution[2,0.1],100],Mesh->9,MeshStyle->{Red,Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshStyle,"Use a red mesh in the x direction:"},
			EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],100],Mesh->9,MeshStyle->{Red,Blue},MeshFunctions->{#1&,#2&}],
			ValidGraphicsP[]
		],

		Example[{Options,PerformanceGoal,"Change the performance goal to either Speed or Quality:"},
			{
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],100],ImageSize->300,Mesh->9,MeshStyle->{Red,Thick},PlotRange->Automatic,PerformanceGoal->"Speed"],
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],100],ImageSize->300,Mesh->9,MeshStyle->{Red,Thick},PlotRange->Automatic,PerformanceGoal->"Quality"]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotLabel,"Add the plot label for the whole plot:"},
			EmeraldSmoothHistogram[Table[RandomVariate[NormalDistribution[c,1],500],{c,0,5}],
				Filling->Bottom,PlotLabel->"Multiple Normal Distributions",
				PlotLegends->Automatic
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLegends,"Add the plot legends for each of the distributions:"},
			EmeraldSmoothHistogram[Table[RandomVariate[WeibullDistribution[c, 2],500],{c,{0.5,2,4}}],PlotRange->{{Automatic,20},Automatic},AspectRatio->0.5,PlotLegends->{0.5,2,4}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"Allow plot range clipping:"},
			EmeraldSmoothHistogram[RandomVariate[WeibullDistribution[1,2],20000],PlotRange->Automatic,PlotRangeClipping->True,Filling->Bottom,PlotRangePadding->1,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add paddings to the graphics:"},
			EmeraldSmoothHistogram[RandomVariate[WeibullDistribution[1,2],500],Filling->Bottom,PlotRangePadding->True,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the style of the plot:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,0.1],500],DistributionFunction->"CDF",PlotStyle->{Purple,Opacity[0.25],Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotTheme,"A number of options for PlotTheme exist. Please use ctrl+k in your notebook to find out more:"},
			EmeraldSmoothHistogram[
				{
					RandomVariate[NormalDistribution[1,0.1],500],
					RandomVariate[NormalDistribution[2,0.5],1000]
				},
				PlotTheme->"Business"
			],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Add a prolog to the plot:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,0.5],500],AspectRatio->1/4,DistributionFunction->"PDF",Prolog->{LightGreen,Disk[{0.5,0},0.2],LightRed,Disk[{1,0},0.2],LightBlue,Disk[{1.5,0},0.2]}],
			ValidGraphicsP[]
		],

		Example[{Options,RotateLabel,"Specify if the labels of the y-axis should be rotated:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,0.5],500],Frame->True,FrameLabel->{None,"y axis"},RotateLabel->True],
			ValidGraphicsP[]
		],

		(* Example[{Options,ScalingFunctions,"Reverse the x axis values:"},
			{
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,0.5],500],ImageSize->300],
				EmeraldSmoothHistogram[RandomVariate[ExponentialDistribution[1],500],ImageSize->300,ScalingFunctions->{"Reverse",None}]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		], *)

		Example[{Options,MaxRecursion,"Default sampling mesh used for showing the distribution. Each level of MaxRecursion will subdivide the initial mesh into a finer mesh:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,10],100],
				MaxRecursion->0,Mesh->All,Ticks->None
			],
			ValidGraphicsP[]
		],

		Example[{Options,MaxRecursion,"Change the default sampling mesh used for showing the distribution:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,10],100],
				MaxRecursion->3,Mesh->All,FrameTicks->None
			],
			ValidGraphicsP[]
		],

		Example[{Options,RegionFunction,"Show the histogram only in a certain region:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],100],
				RegionFunction->Function[{x,y}, 2 < x^2 < 9],
				DistributionFunction->"PDF",PlotPoints->20,MaxRecursion->0
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotPoints,"Use more initial points to get a smoother curve:"},
			Table[
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[],100],
 					DistributionFunction->"PDF",PlotPoints->i,MaxRecursion->0,ImageSize->150
				],
				{i,{5,10,15,25}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,WorkingPrecision,"Change the working precision of the sampling:"},
			Table[
				EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,10],100],
					WorkingPrecision->p,Mesh->All,FrameTicks->None,ImageSize->300
				],
				{p,{2,14}}
			],
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ImageSize,"Change the size of the image:"},
			(EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,10],100],ImageSize->#]&/@{100,200,300}),
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ImageMargins,"Add margin to the graphics:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[1,10],100],ImageMargins->30,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,Scale,"Plot on log scale:"},
			EmeraldSmoothHistogram[{3.920185856700919`, 2.913439118717113`,
				2.619907765068587`, 3.506298614257064`, 2.670540868534328`,
				2.968916661260699`, 1.954655145053345`, 3.0596583766288554`,
				3.5698788321126607`, 2.7026817739623894`, 2.128331999001936`,
				3.077357537812348`, 3.001519309113299`, 3.326578110028604`,
				3.689106252617215`, 3.613595889381987`, 2.9480758386823704`,
				3.333683567708437`, 3.283862624236208`, 2.937154162391477`},
				Scale -> Log],
			ValidGraphicsP[]
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"IncompatibleUnits","Incompatible units within a data set:"},
			EmeraldSmoothHistogram[{1*Meter,2*Foot,3*Second}],
			$Failed,
			Messages:>{EmeraldSmoothHistogram::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units across data sets:"},
			EmeraldSmoothHistogram[{RandomVariate[NormalDistribution[3,.4],500]*Meter,RandomVariate[NormalDistribution[4,1],600]*Second}],
			$Failed,
			Messages:>{EmeraldSmoothHistogram::IncompatibleUnits}
		]

	}

];
