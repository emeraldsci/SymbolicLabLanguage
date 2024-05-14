(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram3D*)


DefineTests[EmeraldHistogram3D,

	{
		Example[{Basic,"Create a 3D histogram from bivariate distribution samples:"},
			EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],1000]],
			ValidGraphicsP[]
		],

		Example[{Basic,"Create a 3D histogram from normal distribution samples:"},
			EmeraldHistogram3D[RandomVariate[NormalDistribution[0, 1], {100, 2}]],
			ValidGraphicsP[]
		],

		Example[{Basic,"Overlay two 3D histograms:"},
			EmeraldHistogram3D[{RandomVariate[NormalDistribution[0, 1], {100, 2}],
				RandomVariate[NormalDistribution[1, 2], {200, 2}]}],
			ValidGraphicsP[]
		],

		(*
			Options
		*)
		Example[{Options,DistributionFunction,"Specify the distribution function used for plotting the histogram. This can be PDF, CDF, and a number of other options:"},
			Table[
				EmeraldHistogram3D[QuantityArray[RandomVariate[BinormalDistribution[{0.1,0.5},0.5],100],{Meter,Second}],
					DistributionFunction->df,ImageSize->200,PlotLabel->df
				],
				{df,{"PDF","CDF","CHF"}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldHistogram3D[singleDoubleNormal,PlotRange->{{Automatic,3.75},{Automatic,5},Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Use an explicit z range to emphasize features and mix with Automatic for the other directions:"},
			EmeraldHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",PlotRange->{Automatic,Automatic,{0,0.5}}],
			ValidGraphicsP[]
		],

		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldHistogram3D[RandomVariate[ExponentialDistribution[1],{100,2}],
				DistributionFunction->"PDF",ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,{-1,-1}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AspectRatio,"Change the aspect ratio of the histogram chart:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[c,2],{500,2}],{c,{0.5,2,4}}],AspectRatio->0.5],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Three different aspect ratios:"},
			Table[
				EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[c, 2],{100,2}],{c,{0.5,2,4}}],AspectRatio->ar,ImageSize->200],
				{ar,{0.5,1,1.5}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Axes,"Remove the axes ticks to False:"},
			EmeraldHistogram3D[QuantityArray[singleDoubleNormal,{Meter,Nano Meter}],Axes->False,ChartElements->Graphics3D[Cylinder[]]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesOrigin,"Move the axes to a different than {0,0,0} location:"},
			EmeraldHistogram3D[QuantityArray[singleDoubleNormal,{Meter,Nano Meter}],Axes->True,ChartElements->Graphics3D[Cylinder[]],AxesStyle->Directive[LightBlue,Thick,12],AxesOrigin->{0,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesStyle,"Change the style of the axes to be orange and thick with a different font size:"},
			EmeraldHistogram3D[multiDoubleNormal,Axes->True,AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesLabel,"Add label for an axis. Note that Automatic does not return expected behavior:"},
			EmeraldHistogram3D[QuantityArray[multiDoubleNormal,{"Meter","Second"}],AxesLabel->{"X","Y","Z"},Axes->True,AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Change the background color to light blue:"},
			EmeraldHistogram3D[RandomVariate[RayleighDistribution[0.5],{100,2}],Background->LightBlue],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data in x, y, and z coordinate values:"},
			EmeraldHistogram3D[singleBinormal,
				ColorFunction->Function[{height},ColorData["Rainbow"][height]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data z combining with ChartStyle:"},
			EmeraldHistogram3D[singleBinormal,
				ColorFunction->Function[{height},Opacity[height]],ChartStyle->Purple
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Use ColorFunctionScaling->False to get unscaled height values:"},
			EmeraldHistogram3D[singleBinormal,
				ColorFunction->(Which[#<5,Yellow,5<=#<15,Orange,True,Red] &),ColorFunctionScaling->False
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Provide a custom color function based on the data y coordinate values. If True, ColorFunctionScaling will apply the color function to a 0-1 value basis:"},
			{
				EmeraldHistogram3D[RandomVariate[NormalDistribution[0,1],{100,2}],
					ColorFunction->Function[{height},ColorData["Rainbow"][height]],ImageSize->300,
					ColorFunctionScaling->True
				],
				EmeraldHistogram3D[RandomVariate[NormalDistribution[0,1], {100, 2}],
					ColorFunction->Function[{height},ColorData["Rainbow"][height]],ImageSize->300,
					ColorFunctionScaling->False
				]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldHistogram3D[RandomVariate[NormalDistribution[1,0.5],{100,2}],ImageSize->300,DisplayFunction->(PopupWindow[Button["My Distribution"], #]&)],
			_Button
		],

		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldSmoothHistogram3D:"},
			EmeraldHistogram3D[
				RandomVariate[NormalDistribution[3,.4],{100,2}],
				Epilog->{Yellow,Disk[{0,0.75},{0.12,0.12}],Black,Disk[{0,0.75},{0.1,0.1}]}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FormatType,"Add a textbox with standard form:"},
			EmeraldHistogram3D[RandomVariate[NormalDistribution[],{14,2}],FormatType->StandardForm,Epilog->Inset[Framed[Style["Normal Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageMargins,"Add a textbox with standard form:"},
			{
				EmeraldHistogram3D[mixtureDistribution,ImageSize->300,FormatType->StandardForm,Epilog->Inset[Framed[Style["Mixture Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]],
				EmeraldHistogram3D[mixtureDistribution,ImageMargins->20,ImageSize->300,FormatType->StandardForm,Epilog->Inset[Framed[Style["Mixture Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,PerformanceGoal,"Change the performance goal to either Speed or Quality -- It does not seem to affect the final result:"},
			{
				EmeraldHistogram3D[RandomVariate[NormalDistribution[],{100,2}],ImageSize->300,PlotRange->Automatic,PerformanceGoal->"Speed"],
				EmeraldHistogram3D[RandomVariate[NormalDistribution[],{100,2}],ImageSize->300,PlotRange->Automatic,PerformanceGoal->"Quality"]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotLabel,"Add the plot label for the whole plot:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[c,1],{500,2}],{c,0,5}],
				PlotLabel->"Multiple Normal Distributions",
				ChartLegends->Automatic
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLegends,"Add the plot legends for each of the distributions:"},
			EmeraldHistogram3D[Table[RandomVariate[WeibullDistribution[c, 2],{500,2}],{c,{0.5,2,4}}],PlotRange->{{Automatic,2},{Automatic,2},Automatic},AspectRatio->0.5,ChartLegends->{0.5,2,4}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add paddings to the graphics:"},
			EmeraldHistogram3D[RandomVariate[WeibullDistribution[1,2],{500,2}],PlotRangePadding->1,ChartStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add specific value for padding of the main histogram:"},
			EmeraldHistogram3D[RandomVariate[WeibullDistribution[1,2],{20000,2}],PlotRange->{{0,10},{0,10}, Automatic},PlotRangePadding->5],
			ValidGraphicsP[]
		],

		Example[{Options,PlotTheme,"A number of options for PlotTheme exist. Please use ctrl+k in your notebook to find out more:"},
			EmeraldHistogram3D[{mixtureDistribution,singleDoubleNormal},PlotTheme->"BoldScheme"],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Add a prolog to the plot:"},
			EmeraldHistogram3D[RandomVariate[NormalDistribution[1,0.5],{500,2}],
				AspectRatio->1,DistributionFunction->"CDF",Prolog->{LightGreen,polygon,LightRed,disk1,LightBlue,disk2}
			],
			ValidGraphicsP[],
			SetUp:>
			(
				polygon = Polygon[{{0.25, 0.25}, {0, Sqrt[0.3]}, {-0.25, 0}}];
				disk1 = Disk[{.25, 0}, 0.2];
				disk2 = Disk[{0.75, 0}, 0.2];
			)
		],

		Example[{Options,ImageSize,"Change the size of the image:"},
			(EmeraldHistogram3D[multiBinormal,ImageSize->#]&/@{100,200,300}),
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ImageMargins,"Add margin to the graphics:"},
			EmeraldHistogram3D[multiDoubleNormal,ImageMargins->30],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Suppress axes units from axes label -- The behvaior is incorrect now:"},
			EmeraldHistogram3D[QuantityArray[multiDoubleNormal,{"Second","Hour"}], AxesUnits -> {None, Automatic, Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Set axes labels for 3D quantity array plots -- The behavior is incorrect:"},
			EmeraldHistogram3D[QuantityArray[singleDoubleNormal,{"Second","Hour"}],AxesUnits->{Day,None,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesEdge,"Specify where the axes labels are affixed. -1 and 1 are associated with either left-right or bottom-top for the axes. The default value would be -1 for all:"},
			EmeraldHistogram3D[mixtureDistribution,AxesEdge->{{1,1},Automatic,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,Boxed,"Remove the edges of the bounding box:"},
			EmeraldHistogram3D[mixtureDistribution,Boxed->False],
			ValidGraphicsP[]
		],

		Example[{Options,BoxRatios,"Change the ratio of the box side lenghs. Automatic is {1,1,0.4}:"},
			EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],10],BoxRatios->{1,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,BoxStyle,"Using dashed lines for the boundary of bounding box:"},
			EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],10],BoxStyle->Directive[Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,ClipPlanes,"Clip the graphics based on an infinite plane:"},
			{
				EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ImageSize->300],
				EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ImageSize->300,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Opacity[0.3]]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ClipPlanesStyle,"Change the style of the clipping planes:"},
			EmeraldHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Directive[Orange,Opacity[0.3]]],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGrids,"Add grids for the bounding box:"},
			EmeraldHistogram3D[singleBinormal,FaceGrids->{{0,0,1},{0,0,-1}}],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGridsStyle,"Add grids for the bounding box with changing the color:"},
			EmeraldHistogram3D[singleBinormal,FaceGrids->All,FaceGridsStyle->Directive[Orange, Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,Lighting,"Change the light sources:"},
			EmeraldHistogram3D[mixtureDistribution,PlotRange->Automatic,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,RotationAction,"Chage the way the rotation of the graph is handled and making it clip the axes when they go out of scope:"},
			{
				EmeraldHistogram3D[singleMultiPoisson,ImageSize->300,RotationAction->"Clip"],
				EmeraldHistogram3D[singleMultiPoisson,ImageSize->300,RotationAction->"Fit"]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewAngle,"Widen the angle of the automatic camera:"},
			Table[EmeraldHistogram3D[singleDoubleNormal,ImageSize->200,ViewAngle->d Degree],{d,{20,35,50}}],
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewPoint,"A single graph with three different view points. Note that the automatic is {1.3,-2.4,2.}:"},
			{
				EmeraldHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->{-2,0,0}],
				EmeraldHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->Above],
				EmeraldHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->Front]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewProjection,"Perspective view of the graph:"},
			(EmeraldHistogram3D[multiDoubleNormal,ImageSize->300,ViewProjection->#]&/@{"Orthographic","Perspective"}),
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewRange,"Specify the minimum and maximum distances from the camera to be included:"},
			EmeraldHistogram3D[singleDoubleNormal,PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewRange->{1,2}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVector,"Specify the view vectors using ordinary coordinates:"},
			EmeraldHistogram3D[singleMultiPoisson,PlotRange->Automatic,ViewPoint->{0,-2,.5},ViewVector->{{5,-10,5},{5,0,-5}}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVertical,"Use the direction of the x axis as the vertical direction in the final image:"},
			EmeraldHistogram3D[singleMultiPoisson,PlotRange->Automatic,ViewVertical->{1,0,0},ViewPoint->{0,-1,.5}],
			ValidGraphicsP[]
		],

		Example[{Options,ChartBaseStyle,"Apply a style directive to all bars in the histogram:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				ChartBaseStyle->Directive[Thick,EdgeForm[Dashed]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartElementFunction,"Choose a chart element function from a list of presets, which can be viewed by running ChartElementData[\"Histogram\"] in the notebook. Automatic defaults to \"Cube\":"},
			Table[
				EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
					ImageSize->300,
					PlotLabel->cf,
					ChartElementFunction->cf
				],
				{cf,{"Cube","Cylinder","TriangleWaveCube","GradientScaleCube"}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,ChartElementFunction,"Write a custom ChartElementFunction:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,5}}],
				ChartElementFunction->hourglassFunc
			],
			ValidGraphicsP[],
			SetUp:>
				(
					hourglassFunc[{{xmin_,xmax_},{ymin_,ymax_},{zmin_,zmax_}},___]:=Cuboid[{xmin,ymin,zmin},{xmax,ymax,zmax}]
				)
		],
		Example[{Options,ChartElementFunction,"Write a custom ChartElementFunction:"},
			{
				EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,5}}],ChartElementFunction->chartFunc1],
				EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,5}}],ChartElementFunction->chartFunc2]
			},
			ConstantArray[ValidGraphicsP[],2],
			SetUp:>
				(
					chartFunc1[{{xmin_,xmax_},{ymin_,ymax_},{zmin_,zmax_}},___]:=Cuboid[{xmin,ymin,zmin},{xmax,ymax,zmax}];
					chartFunc2[b:{{xmin_,xmax_},{ymin_,ymax_},{zmin_,zmax_}},c_,m___]:=ChartElementDataFunction["ProfileCube","Profile"->2.,"TaperRatio"->0.6][b,c,m]
				)
		],
		Example[{Options,ChartElementFunction,"Some built-in chart element functions take options. As an example, you can view the options for the default Rectangle function by running ChartElementData[\"Histogram3D\"] in the notebook:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				ChartElementFunction->ChartElementDataFunction["Cube","Shape"->"Diamond","Shading"->"Solid","TaperRatio"->1]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLegends,"Specify the legends for multiple histograms:"},
			EmeraldHistogram3D[{dataset1,dataset2},
				ChartStyle->"Pastel",ChartLegends->{"Dataset 1","Dataset 2"}
			],
			ValidGraphicsP[],
			SetUp:>(
				dataset1=RandomVariate[NormalDistribution[3,2.0],{100,2}];
				dataset2=RandomVariate[NormalDistribution[6,2.0],{100,2}];
			)
		],
		Example[{Options,ChartLegends,"Use Placed for specifying the location of the legends:"},
			Table[
				EmeraldHistogram3D[{dataset1,dataset2},ImageSize->350,
					ChartLegends->Placed[{"Dataset 2","Dataset 1"}, p],ChartStyle->"Pastel"
				],
				{p,{Below,Above}}
			],
			{ValidGraphicsP[]..},
			SetUp:>(
				dataset1=RandomVariate[NormalDistribution[3,2.0],{100,2}];
				dataset2=RandomVariate[NormalDistribution[6,2.0],{100,2}];
			)
		],

		Example[{Options,ChartLayout,"The ChartLayout for EmeraldHistogram3D can be specified as either \"Overlapped\" or \"Stacked\":"},
			Table[
				EmeraldHistogram3D[{dataset1,dataset2},ImageSize->350,PlotLabel->layout,ChartLayout->layout],
				{layout,{"Overlapped","Stacked"}}
			],
			{ValidGraphicsP[]..},
			SetUp:>(
				dataset1=RandomVariate[NormalDistribution[3,2.0],{100,2}];
				dataset2=RandomVariate[NormalDistribution[6,2.0],{100,2}];
			)
		],

		Example[{Options,ChartStyle,"Pass a single argument to ChartStyle to style all bars the same way:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.7],{100,2}],{x,{0,5,10}}],ChartStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style the chart named color scheme from ColorData[]:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.7],{100,2}],{x,{0,5,10}}],ChartStyle->"Pastel"],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of arguments to ChartStyle to apply different styles to each bar in each group:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.7],{100,2}],{x,{0,5,10}}],ChartStyle->{EdgeForm[Thick],Blue,Directive[Green,EdgeForm[Thick]]}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"ChartElements may override settings for ChartStyle:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.7],{100,2}],{x,{0,5,10}}],ChartElements->Graphics3D[Cylinder[]],ChartStyle->{Red,Blue,Green}],
			ValidGraphicsP[]
		],

		Example[{Options,ChartElements,"Use any graphics primitive instead of bars in the histogram:"},
			EmeraldHistogram3D[QuantityArray[RandomVariate[NormalDistribution[2.0,0.5],{100,2}],{Second,Meter}],
				ChartElements->Graphics3D[Cylinder[]]
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElements,"Stretch a graphic vertically to the bar height instead of generating additional copies:"},
			EmeraldHistogram3D[QuantityArray[RandomVariate[NormalDistribution[2.0,0.5],{100,2}],{Second,Meter}],
				ChartElements->{Graphics3D[Cone[]]}
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElements,"Use different chart elements for each dataset in the plot:"},
			EmeraldHistogram3D[{
					QuantityArray[RandomVariate[NormalDistribution[2.0,0.5],{100,2}],{Second,Meter}],
					QuantityArray[RandomVariate[NormalDistribution[2.0,0.5],{100,2}],{Second,Meter}],
					QuantityArray[RandomVariate[NormalDistribution[2.0,0.5],{100,2}],{Second,Meter}]
				},
				ChartElements->{Graphics3D[Cylinder[]],Graphics3D[Cone[]],Graphics3D[Sphere[]]}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLabels,"When multiple input datasets are provided, label each dataset:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				ChartLabels->{"Group A","Group B","Group C","Group D"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"When multiple input datasets are provided, label each dataset in a frame:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				ChartLabels->Placed[{"Group A","Group B","Group C","Group D"},Above,"Framed"],PlotRange->All
			],
			ValidGraphicsP[]
		],

		Example[{Options,LabelingFunction,"Use automatic labeling by values through Tooltip and StatusArea:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				LabelingFunction->Automatic
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Do no labeling:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				LabelingFunction->None
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Control the formatting of labels:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				LabelingFunction->(Placed[Row[{"$",#}],Tooltip]&)
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Using different custom labeling functions. First one uses the dataset position index to generate the label and the second places complete labels as tooltips:"},
			Table[
				EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
					LabelingFunction->lf
				],
				{lf,{labeler1,labeler2}}
			],
			{ValidGraphicsP[]..},
			SetUp:>(
				labeler1[v_,{i_,j_},{ri_,cj_}]:=Placed[{IntegerString[j,"Roman"],v},Tooltip,Row[#,"-"] &];
				labeler2[v_,{i_,j_},{ri_,cj_}]:=Placed[Join[ri,{v}],Tooltip,Column]
			)
		],

		Example[{Options,LegendAppearance,"Specify the appearance of the legends for multiple histograms:"},
			EmeraldHistogram3D[{dataset1,dataset2},
				ChartStyle->"Pastel",ChartLegends->{"Dataset 1","Dataset 2"},LegendAppearance->"Row"
			],
			ValidGraphicsP[]
		],

		Example[{Options,BarOrigin,"Change the bar origin:"},
			Table[
				EmeraldHistogram3D[{dataset1,dataset2},
					ChartStyle->"Pastel",BarOrigin->o,ImageSize->200
				],
				{o,{Top,Bottom,Left,Right}}
			],
			{ValidGraphicsP[]..},
			SetUp:>(
				dataset1=RandomVariate[NormalDistribution[3,2.0],{100,2}];
				dataset2=RandomVariate[NormalDistribution[6,2.0],{100,2}];
			)
		],

		Example[{Options,LabelStyle,"Use automatic labeling by values through Tooltip and StatusArea:"},
			EmeraldHistogram3D[Table[RandomVariate[NormalDistribution[x,0.5],{100,2}],{x,{2,4,6,8}}],
				LabelingFunction->Automatic,LabelStyle->Red,AxesLabel->{"X","Y","Z"}
			],
			ValidGraphicsP[]
		]

	},

	SetUp:>
		(
			singleBinormal=RandomVariate[BinormalDistribution[.5], 100];
			singleDoubleNormal=RandomVariate[NormalDistribution[0,1],{100,2}];
			multiBinormal=Table[RandomVariate[BinormalDistribution[c],50],{c,{-0.95,0.,0.95}}];
			multiDoubleNormal=
				{
					RandomVariate[NormalDistribution[0,1],{100,2}],
					RandomVariate[NormalDistribution[1, 2], {100, 2}]
				};
			mixtureDistribution=
				RandomVariate[
					MixtureDistribution[{.5,.5},
						{
							MultinormalDistribution[{-2, -2},IdentityMatrix[2]],
							MultinormalDistribution[{0, 0}, .5 IdentityMatrix[2]]
						}
					],250
				];
			singleMultiPoisson=RandomVariate[MultivariatePoissonDistribution[1,{2,3}],100];
		)

];
