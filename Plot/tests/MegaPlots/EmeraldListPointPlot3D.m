(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPointPlot3D*)


DefineTests[EmeraldListPointPlot3D,

	{
		(*
			Basic
		*)
		Example[{Basic,"Plot a 3D data set:"},
			EmeraldListPointPlot3D[RandomVariate[NormalDistribution[],{1000,3}]],
			_Graphics3D?ValidGraphicsQ
		],
		Example[{Basic,"Plot a 3D quantity array:"},
			EmeraldListPointPlot3D[QuantityArray[RandomVariate[NormalDistribution[],{1000,3}],{Second,Meter,Gram}]],
			_Graphics3D?ValidGraphicsQ
		],
		Example[{Basic,"Plot a list of 3D data sets:"},
			EmeraldListPointPlot3D[{
				RandomVariate[MultinormalDistribution[{0,0,0},{{1,0,0},{0,1,0},{0,0,1}}],2000],
				RandomVariate[MultinormalDistribution[{-1,3,-1},{{1,.4,0},{.4,1,0},{0,0,1}}],2000],
				RandomVariate[MultinormalDistribution[{-1,-1,3},{{1,.4,.3},{.4,1,.3},{.3,.3,1}}],2000]
			}],
			_Graphics3D?ValidGraphicsQ
		],
		Example[{Basic,"Plot a list of 3D quantity arrays:"},
			EmeraldListPointPlot3D[{
				QuantityArray[RandomVariate[MultinormalDistribution[{0,0,0},{{1,0,0},{0,1,0},{0,0,1}}],2000],{Second,Meter,Gram}],
				QuantityArray[RandomVariate[MultinormalDistribution[{-1,3,-1},{{1,.4,0},{.4,1,0},{0,0,1}}],2000],{Second,Meter,Gram}],
				QuantityArray[RandomVariate[MultinormalDistribution[{-1,-1,3},{{1,.4,.3},{.4,1,.3},{.3,.3,1}}],2000],{Second,Meter,Gram}]
			}],
			_Graphics3D?ValidGraphicsQ
		],

		(*
			Option
		*)
		Example[{Options,TargetUnits,"Specify target units for data:"},
			EmeraldListPointPlot3D[
				QuantityArray[
					RandomVariate[
						MultinormalDistribution[{0, 0,
							0}, {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}], 2000], {"Seconds",
					"Meters", "Grams"}], TargetUnits -> {Minute, Centimeter, Kilogram}],
			_Graphics3D?ValidGraphicsQ
		],

		Example[{Options,PlotRange,"Specify plot range:"},
			EmeraldListPointPlot3D[
				RandomVariate[
					MultinormalDistribution[{0, 0,
						0}, {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}], 2000],
				PlotRange -> {{0, Automatic}, Automatic, {-1, 0}}],
			_Graphics3D?ValidGraphicsQ
		],

		Example[{Options,AspectRatio,"Set the aspect-ratio of the plot to three different values:"},
			{
				EmeraldListPointPlot3D[sinSurface,PlotStyle->LightRed,ViewProjection->"Orthographic",ImageSize->200,AspectRatio->0.5],
				EmeraldListPointPlot3D[sinSurface,PlotStyle->LightRed,ViewProjection->"Orthographic",ImageSize->200,AspectRatio->1],
				EmeraldListPointPlot3D[sinSurface,PlotStyle->LightRed,ViewProjection->"Orthographic",ImageSize->200,AspectRatio->2]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldListPointPlot3D[demodata,
				ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,{-1,-1}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,Axes,"Remove the axes ticks:"},
			EmeraldListPointPlot3D[sinSurface,Axes->False],
			ValidGraphicsP[]
		],

		Example[{Options,AxesOrigin,"Change the axes origin to be the bounding box yz side:"},
			EmeraldListPointPlot3D[constantPlane,AxesOrigin->{0,1,0.5}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesStyle,"Change the style of the axes to be orange and thick with a different font size:"},
			EmeraldListPointPlot3D[inclinedPlane,AxesStyle->Directive[Orange,Thick,12],AxesOrigin->{0,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Change the background color to light blue:"},
			EmeraldListPointPlot3D[demoQ2data,Background->LightRed],
			ValidGraphicsP[]
		],

		Example[{Options,BaseStyle,"Change the base style of the entire plot including the font and font size. Note that the plot style takes precedence over BaseStyle:"},
			EmeraldListPointPlot3D[demoQ2data,BaseStyle->{Large,FontFamily->"Times",Italic}],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Providing a custom color function that chooses the color based on the data:"},
			EmeraldListPointPlot3D[demoQ2data,ColorFunction->Function[{x,y,z},RGBColor[x,y,0.]],PlotRange->{Automatic,Automatic,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldListPointPlot3D[demodata,ImageSize->300,DisplayFunction->(PopupWindow[Button["Click here"], #]&)],
			_Button
		],

		Example[{Options,Epilog,"Add a text box to the graphic after the main plot is rendered at a specific location and also background color:"},
			EmeraldListPointPlot3D[demoQ2data,Epilog->Inset[Framed[Style["Constant plane",20],Background->LightYellow],{Right,Bottom},{Right,Bottom}]],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill under the data points in a certain region specficied using the first and second components of the input:"},
			EmeraldListPointPlot3D[sinSurface,Filling->Bottom,RegionFunction->(#1^2+#2^2<5&)],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill surface 1 to the bottom with blue and surface 2 to the top with red:"},
			EmeraldListPointPlot3D[crossingPlanes,Filling->{1->{Bottom,Blue},2->{Top, Red}}],
			ValidGraphicsP[]
		],

		Example[{Options,FillingStyle,"Fill with gray under the surface in a certain region:"},
			EmeraldListPointPlot3D[crossingPlanes,Filling->Bottom,FillingStyle->{Opacity[0.7],Gray,Dashed},RegionFunction->(#1^2<100&)],
			ValidGraphicsP[]
		],

		Example[{Options,FormatType,"Add a textbox with standard form at a specific location and with a specific background color:"},
			EmeraldListPointPlot3D[constantPlane,FormatType->StandardForm,Epilog->Inset[Framed[Style["Constant plane",20],Background->LightYellow],{Right,Bottom},{Right,Bottom}]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageMargins,"Add margins to the image outside of the bounding box:"},
			EmeraldListPointPlot3D[sinSurface,ImageMargins->30,PlotStyle->Purple],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Add the plot label for the whole plot:"},
			EmeraldListPointPlot3D[crossingPlanes,Filling->Bottom,PlotLabel->"Crossing Planes"],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLegends,"Add the plot legends for each of the planes:"},
			EmeraldListPointPlot3D[crossingPlanes,Filling->Bottom,PlotLegends->{"Plane 1","Plane 2"}],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Add the plot legends for each of the planes - This effectively acts similar to PlotLegends, but the default legend placement is bottom as opposed to right in PlotLegends:"},
			EmeraldListPointPlot3D[crossingPlanes,Filling->Bottom,Legend->{"Plane 1","Plane 2"}],
			ValidGraphicsP[]
		],

		Example[{Options,LegendPlacement,"Add the plot legends for each of the planes:"},
			EmeraldListPointPlot3D[quadrupleHelix,BoxRatios->{3,1,1},Legend->{"Helix 1","Helix 2","Helix 3","Helix 4"},LegendPlacement->Right],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add paddings to the graphics with respect to the bounding box sides:"},
			EmeraldListPointPlot3D[sinSurface,PlotRangePadding->1,PlotStyle->Purple],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the style of the plot by changing the transparency and the color to purple:"},
			EmeraldListPointPlot3D[triangle,PlotStyle->{Purple,Opacity[0.25]}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotTheme,"A number of options for PlotTheme exist. Please try ctrl+k on your notebook to see all different options:"},
			EmeraldListPointPlot3D[multiSinSurface,PlotTheme->"Web",PlotStyle->66],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Add a disk before the main plot is rendered at a certain location with a certain color:"},
			EmeraldListPointPlot3D[sinSurface,Prolog->{Pink,Disk[{0,0},0.1]}],
			ValidGraphicsP[]
		],

		Example[{Options,ScalingFunctions,"Reversing the x axis values:"},
			{
				EmeraldListPointPlot3D[inclinedPlane,ImageSize->300],
				EmeraldListPointPlot3D[inclinedPlane,ImageSize->300,ScalingFunctions->{"Reverse",None}]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,Ticks,"Specify the ticks to be at specific locations:"},
			EmeraldListPointPlot3D[sinSurface,Ticks->{{0,Pi/2,Pi},{0,Pi/2,Pi},{-1,0,1}}],
			ValidGraphicsP[]
		],

		Example[{Options,TicksStyle,"Specify the tick style the color and font:"},
			EmeraldListPointPlot3D[sinSurface,Ticks->{{0,Pi/4,Pi/2,Pi},{0,Pi/4,Pi/2,Pi},{-1,0,1}},TicksStyle->Directive[Red,12]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Change the size of the image:"},
			(EmeraldListPointPlot3D[sinSurface,ImageSize->#]&/@{100,200,300}),
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,LabelStyle,"Change the style of all labels the color and the font:"},
			EmeraldListPointPlot3D[demoQdata,LabelStyle->Directive[Orange,16]],
			ValidGraphicsP[]
		],

		Example[{Options,LabelingFunction,"Specify a pure function that generates labels for each point in the plot. This function should take in coordinates and return graphics primitives. For more information, evaluate ?LabelingFunction in the notebook:"},
			EmeraldListPointPlot3D[{{1,2,3},{1,3,4},{1.5,-1,5},{2,4,5}},LabelingFunction->(Placed[Panel[#1,FrameMargins->0],Automatic]&),PlotStyle->PointSize[0.02]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesLabel,"Label the axes:"},
			EmeraldListPointPlot3D[RandomVariate[NormalDistribution[],{1000,3}],AxesLabel->{"X","Y","Z"},PlotStyle->PointSize[0.01]],
			_Graphics3D?ValidGraphicsQ
		],

		Example[{Options,AxesUnits,"Do not append units to axes labels eventhough the data has units:"},
			EmeraldListPointPlot3D[
				QuantityArray[
					RandomVariate[
						MultinormalDistribution[{0, 0, 0}, {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}], 2000
					],
					{"Seconds","Meters", "Grams"}
				], AxesUnits->{None,None,None},PlotStyle->PointSize[0.01]
			],
			_Graphics3D?ValidGraphicsQ
		],

		Example[{Options,AxesEdge,"Specify where the axes labels are affixed. -1 and 1 are associated with bottom and top or left and right for y and x axes, respectively:"},
			EmeraldListPointPlot3D[RandomVariate[NormalDistribution[],{1000,3}],AxesEdge -> {{1, 1}, Automatic, Automatic},PlotStyle->PointSize[0.01]],
			ValidGraphicsP[]
		],

		Example[{Options,Boxed,"Remove the edges of the bounding box:"},
			EmeraldListPointPlot3D[inclinedPlane,Boxed->False],
			ValidGraphicsP[]
		],

		Example[{Options,BoxRatios,"Change the ratio of the box side lenghs. Automatic is {1,1,0.4}:"},
			EmeraldListPointPlot3D[quadrupleHelix,BoxRatios->{4,1,1},PlotStyle->PointSize[0.01],PlotLegends->Automatic],
			ValidGraphicsP[]
		],

		Example[{Options,BoxStyle,"Using dashed lines and gray color for the boundary of bounding box:"},
			EmeraldListPointPlot3D[crossingPlanes,PlotStyle->PointSize[0.01],BoxStyle->Directive[Red,Dashed]],
			ValidGraphicsP[]
		],

		(*
			This next examples does not seem to be working well
		*)
		Example[{Options,ClipPlanes,"Clip the graphics based on an infinite plane - does not seem to be working well:"},
			EmeraldListPointPlot3D[deltaSurface,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Opacity[0.3]],
			ValidGraphicsP[]
		],

		Example[{Options,ClipPlanesStyle,"Change the style of the clipping planes:"},
			EmeraldListPointPlot3D[deltaSurface,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Directive[Orange,Opacity[0.3]]],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGrids,"Add grids for the bounding box:"},
			EmeraldListPointPlot3D[deltaSurface,FaceGrids->{{0,0,1},{0,0,-1}}],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGridsStyle,"Add grids for the bounding box with changing the color and the style of the lines:"},
			EmeraldListPointPlot3D[demodata,FaceGrids->All,FaceGridsStyle->Directive[Orange, Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the size of the symbols:"},
			EmeraldListPointPlot3D[multiSinSurface,PlotStyle->PointSize[0.01]],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the color of the plots:"},
			EmeraldListPointPlot3D[crossingPlanes,PlotStyle->{Purple,Green},PlotLegends->{"Plane 1","Plane 2"}],
			ValidGraphicsP[]
		],

		Example[{Options,Lighting,"Change the light sources:"},
			EmeraldListPointPlot3D[deltaSurface,PlotStyle->PointSize[0.01],PlotRange->Automatic,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,LabelingSize,"Change the label size of the plot labels for each datapoints:"},
			EmeraldListPointPlot3D[{{1,2,3},{1,3,4},{1.5,-1,5},{2,4,5}},LabelingSize->100,LabelingFunction->(Placed[Panel[#1,FrameMargins->0],Automatic]&),PlotStyle->PointSize[0.02]],
			ValidGraphicsP[]
		],

		Example[{Options,RegionFunction,"Plot over an annulus region:"},
			{
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200],
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200,RegionFunction->Function[{x,y,z},1<x^2+y^2<12]],
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200,RegionFunction->Function[{x,y,z},3<x^2+y^2<9]]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,RotationAction,"Chage the way the rotation of the graph is handled and making it clip the axes when they go out of scope:"},
			EmeraldListPointPlot3D[demoQ2data,RotationAction->"Clip"],
			ValidGraphicsP[]
		],

		Example[{Options,ViewAngle,"Widen the angle of the automatic camera:"},
			Table[EmeraldListPointPlot3D[sinSurface,ImageSize->200,ViewAngle->d Degree],{d,{20,35,50}}],
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewPoint,"A single graph with three different view points. Note that the automatic is {1.3,-2.4,2.}:"},
			{
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200,PlotRange->Automatic,ViewPoint->{0,-2,0}],
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200,PlotRange->Automatic,ViewPoint->Above],
				EmeraldListPointPlot3D[deltaSurface,ImageSize->200,PlotRange->Automatic,ViewPoint->Front]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewProjection,"Perspective view of the graph:"},
			(EmeraldListPointPlot3D[inclinedPlane,ImageSize->300,ViewProjection->#]&/@{"Orthographic","Perspective"}),
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewRange,"Specify the minimum and maximum distances from the camera to be included:"},
			EmeraldListPointPlot3D[deltaSurface,PlotStyle->PointSize[0.01],PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewRange->{3.5,7.2}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVector,"Specify the view vectors using ordinary coordinates:"},
			EmeraldListPointPlot3D[deltaSurface,PlotStyle->PointSize[0.01],PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewVector->{{5,-5,5},{5,0,-5}}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVertical,"Use the direction of the x axis as the vertical direction in the final image:"},
			EmeraldListPointPlot3D[deltaSurface,PlotStyle->PointSize[0.01],PlotRange->Automatic,ViewVertical->{1,0,0},ViewPoint->{0,-1,.5}],
			ValidGraphicsP[]
		]

	},

	SetUp:> (
		constantPlane=Flatten[Table[{i,j,1}, {i,0,1,0.1},{j,0,2,0.1}],1];
		inclinedPlane=Flatten[Table[{i,j,i}, {i,0,1,0.1},{j,0,2,0.1}],1];
		demodata=Flatten[Table[{x,y,Tanh[x]Tanh[y]},{x,-2,2,0.2},{y,-2,2,.2}],1];
		demoQdata=QuantityArray[demodata,{Quantity[1,"Days"],Quantity[1,"DegreesCelsius"],Quantity[1,"Molar"]}];
		demo2data=Flatten[Table[{x,y,-x y /4}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1];
		demoQ2data=Flatten[Table[{x Day, y Celsius, (-x y /4) Molar}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1];
		sinSurface=Flatten[Table[{i,j,Sin[j^2 + i^2]}, {i,0,Pi,Pi/30},{j,0,Pi,Pi/30}],1];
		sinSurfaceJagged=Flatten[Table[{i,j,Sin[j^2 + i^2]}, {i,0,Pi,Pi/2},{j,0,Pi,Pi/2}],1];
		multiSinSurface=Table[Flatten[Table[{i,j,Sin[j^2 + i^2]+10 n}, {i,0,Pi,Pi/30},{j,0,Pi,Pi/30}],1],{n,0,1}];
		triangle={{0, 3, 1}, {1, 1, 0}, {0, -1, 0}};
		deltaSurface=Quiet[Flatten[Table[{x,y,1/(x^2+y^2)},{x,-2,2,0.1},{y,-2,2,0.1}],1]];
		crossingPlanes={Flatten[Table[{x,y,x},{x,20},{y,20}],1],Flatten[Table[{x,y,y},{x,15},{y,20}],1]};
		quadrupleHelix=Table[Table[{t,Cos[t + s Pi/2],Sin[t + s Pi/2]},{t,0,5Pi,.2}],{s,4}];
	)

];
