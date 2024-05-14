(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPlot3D*)


DefineTests[EmeraldListPlot3D,

	{

		(*
			Basic
		*)
		Example[{Basic,"Create 3D list plot from 3D quantity array:"},
			EmeraldListPlot3D[demoQdata],
			ValidGraphicsP[]
		],

		Example[{Basic,"Create 3D list plot from 3D array:"},
			EmeraldListPlot3D[demodata],
			ValidGraphicsP[]
		],

		Example[{Basic,"Create 3D list plot from 3D list of quantities:"},
			EmeraldListPlot3D[demo2data],
			ValidGraphicsP[]
		],

		Example[{Basic,"Create 3D list plot from a list with multiple 3D arrays:"},
			EmeraldListPlot3D[{demoQdata,demoQ2data}],
			ValidGraphicsP[]
		],

		Test["PlotObject uses EmeraldListPlot3D for 3D lists of quantities:",
			PlotObject[demoQ2data],
			EmeraldListPlot3D[demoQ2data]
		],

		Test["PlotObject uses EmeraldListPlot3D for 3D quantity arrays:",
			PlotObject[demoQdata],
			EmeraldListPlot3D[demoQdata]
		],

		(*
			Additional
		*)
		Example[{Additional,"Specify PlotObject to use EmeraldListPlot3D for raw 3D lists:"},
			PlotObject[demo2data, PlotType->ListPlot3D],
			EmeraldListPlot3D[demo2data]
		],

		Example[{Additional,"Multiple 3D arrays with compatible units will be converted to the units in the first data set:"},
			EmeraldListPlot3D[{QuantityArray[demo2data, {Hour, Celsius, Molar}],demoQdata}],
			ValidGraphicsP[]
		],

		Example[{Additional,"Multiple 3D arrays with compatible units will be converted to the units in the first data set:"},
			EmeraldListPlot3D[{demoQdata, QuantityArray[demo2data, {Hour, Celsius, Molar}]}],
			ValidGraphicsP[]
		],

		Example[{Additional,"Plot multiple 3D arrays and the first array does not have units will result in a plot without units:"},
			EmeraldListPlot3D[{demoQ2data, demodata}],
			ValidGraphicsP[]
		],

		Example[{Additional,"Plot multiple 3D data with and without units results in a plot no units:"},
			EmeraldListPlot3D[{demodata, demoQ2data}],
			ValidGraphicsP[]
		],

		(*
			Options
		*)
		Example[{Options,ShowPoints,"Show the data points over the plotted surface:"},
			EmeraldListPlot3D[demodata,ShowPoints->True],
			ValidGraphicsP[]
		],

		Example[{Options,TargetUnits,"Specify target units for 3D quantity array plots:"},
			EmeraldListPlot3D[demoQdata,TargetUnits->{Hour,Kelvin,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Set plot range for 3D quantity array plots:"},
			EmeraldListPlot3D[{demoQ2data, demoQdata},PlotRange->{{0 Day, 2 Day},{0 Celsius, 2 Celsius},Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Set the aspect-ratio of the plot:"},
			{
				EmeraldListPlot3D[sinSurface,ImageSize->200,AspectRatio->0.5],
				EmeraldListPlot3D[sinSurface,ImageSize->200,AspectRatio->1],
				EmeraldListPlot3D[sinSurface,ImageSize->200,AspectRatio->2]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,Mesh,"Set the mesh points number:"},
			EmeraldListPlot3D[constantPlane,Mesh->{2,3}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshFunctions,"Set the mesh function which changes based on z values:"},
			EmeraldListPlot3D[sinSurface,MeshFunctions->{#3&},Mesh->10],
			ValidGraphicsP[]
		],

		Example[{Options,Axes,"Remove the axes ticks to False:"},
			EmeraldListPlot3D[sinSurface,Axes->False],
			ValidGraphicsP[]
		],

		Example[{Options,AxesOrigin,"Change the axes origin to be the middle of the yz plane:"},
			EmeraldListPlot3D[constantPlane,AxesOrigin->{0,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesStyle,"Change the style of the axes to be orange and thick with a different font size:"},
			EmeraldListPlot3D[inclinedPlane,AxesStyle->Directive[Orange,Thick,12],AxesOrigin->{0,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Change the background color to light blue:"},
			EmeraldListPlot3D[demoQdata,Background->LightBlue],
			ValidGraphicsP[]
		],

		Example[{Options,BaseStyle,"Change the base style of the plot:"},
			EmeraldListPlot3D[deltaSurface,BaseStyle->Red],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Change the clipping style to show nothing if the data is cut:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->{Automatic,Automatic,Automatic},BaseStyle->Red],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data:"},
			EmeraldListPlot3D[deltaSurface,ColorFunction->Function[{x,y,z},RGBColor[x,y,0.]],PlotRange->{Automatic,Automatic,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldListPlot3D[crossingPlanes,ImageSize->300,DisplayFunction->(PopupWindow[Button["Click here"], #]&)],
			_Button
		],

		Example[{Options,Epilog,"Add a text box to the graphic:"},
			EmeraldListPlot3D[constantPlane,Epilog->Inset[Framed[Style["Constant plane",20],Background->LightYellow],{Right,Bottom},{Right,Bottom}]],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill under the surface in a certain region:"},
			EmeraldListPlot3D[sinSurface,Filling->Bottom,Mesh->None],
			ValidGraphicsP[]
		],

		Example[{Options,FillingStyle,"Fill with gray under the surface in a certain region:"},
			EmeraldListPlot3D[crossingPlanes,Filling->Bottom,FillingStyle->{Opacity[0.7], Gray},Mesh->None],
			ValidGraphicsP[]
		],

		Example[{Options,FormatType,"Add a textbox with standard form:"},
			EmeraldListPlot3D[constantPlane,FormatType->StandardForm,Epilog->Inset[Framed[Style["Constant plane",20],Background->LightYellow],{Right,Bottom},{Right,Bottom}]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageMargins,"Add margin to the graphics:"},
			EmeraldListPlot3D[sinSurface,ImageMargins->30,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,InterpolationOrder,"Change the interpolation order:"},
			Table[
				EmeraldListPlot3D[sinSurfaceJagged,ImageSize->300,InterpolationOrder->n,PlotStyle->Purple,MeshStyle->Green],
				{n,0,1}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelingSize,"Change the label size of the plot labels for each of the surfaces:"},
			EmeraldListPlot3D[crossingPlanes,LabelingSize->50,Filling->Bottom,PlotLabels->{Callout["Plane 1",Above],Callout["Plane 2",Above]}],
			ValidGraphicsP[]
		],

		Example[{Options,MaxPlotPoints,"Change the maximum number of mesh points:"},
			{
				EmeraldListPlot3D[sinSurface,ImageSize->300,Mesh->All],
				EmeraldListPlot3D[sinSurface,ImageSize->300,MaxPlotPoints->10,Mesh->All]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,MeshShading,"Use a checkerboard shading for the mesh:"},
			EmeraldListPlot3D[sinSurface,MeshFunctions->{#1&,#2&},MeshShading->{{Yellow,Green},{Green,Yellow}}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshStyle,"Change the style of the mesh lines in x and y directions:"},
			EmeraldListPlot3D[sinSurface,MeshFunctions->{#1&,#2&},MeshShading->{{Yellow,Green},{Green,Yellow}},MeshStyle->{Red,Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,PerformanceGoal,"Change the performance goal to either Speed or Quality:"},
			{
				EmeraldListPlot3D[deltaSurface,ImageSize->300,PlotRange->{Automatic,Automatic,Automatic},PerformanceGoal->"Speed"],
				EmeraldListPlot3D[deltaSurface,ImageSize->300,PlotRange->{Automatic,Automatic,Automatic},PerformanceGoal->"Quality"]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotLabel,"Add the plot label for the whole plot:"},
			EmeraldListPlot3D[crossingPlanes,Filling->Bottom,PlotLabel->"Crossing Planes",PlotLabels->{Callout["Plane 1",Above],Callout["Plane 2",Above]}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabels,"Add the plot labels for each of the surfaces:"},
			EmeraldListPlot3D[crossingPlanes,Filling->Bottom,PlotLabels->{Callout["Plane 1",Above],Callout["Plane 2",Above]}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLegends,"Add the plot legends for each of the surfaces:"},
			EmeraldListPlot3D[crossingPlanes,Filling->Bottom,PlotLegends->{"Plane 1","Plane 2"}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add paddings to the graphics:"},
			EmeraldListPlot3D[sinSurface,PlotRangePadding->1,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Change the plot location with respect to the whole region:"},
			EmeraldListPlot3D[sinSurface,PlotStyle->{{0.25,0.75},{0.25,0.75}},Background->LightBlue],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the style of the plot:"},
			EmeraldListPlot3D[triangle,PlotStyle->{Purple,Opacity[0.25]}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotTheme,"A number of options for PlotTheme:"},
			EmeraldListPlot3D[sinSurface,PlotTheme->"ThickSurface"],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Add a prolog to the plot:"},
			EmeraldListPlot3D[sinSurface,Prolog->{Pink,Disk[{0,0},0.1]}],
			ValidGraphicsP[]
		],

		Example[{Options,ScalingFunctions,"Reverse the y axis values:"},
			{
				EmeraldListPlot3D[triangle,ImageSize->300],
				EmeraldListPlot3D[triangle,ImageSize->300,ScalingFunctions->{None,"Reverse"}]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,Ticks,"Specify the ticks:"},
			EmeraldListPlot3D[sinSurface,Ticks->{{0,Pi/2,Pi},{0,Pi/2,Pi},{-1,0,1}}],
			ValidGraphicsP[]
		],

		Example[{Options,TicksStyle,"Specify the tick style:"},
			EmeraldListPlot3D[sinSurface,Ticks->{{0,Pi/2,Pi},{0,Pi/2,Pi},{-1,0,1}},TicksStyle->Directive[Blue,12]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Change the size of the image:"},
			(EmeraldListPlot3D[sinSurface,ImageSize->#]&/@{100,200,300}),
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,LabelStyle,"Change the style of all labels:"},
			EmeraldListPlot3D[demoQdata,LabelStyle->Directive[Orange,12]],
			ValidGraphicsP[]
		],

		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldListPlot3D[demodata,
				ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,{-1,-1}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AxesLabel,"Set axes labels for 3D quantity array plots and units are appended to label:"},
			EmeraldListPlot3D[demoQdata,AxesLabel->{"When",None,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Suppress axes units from axes label:"},
			EmeraldListPlot3D[demoQdata,AxesLabel->{"When",None,Automatic}, AxesUnits -> {None, Automatic, Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Set axes labels for 3D quantity array plots:"},
			EmeraldListPlot3D[demoQdata,AxesUnits->{Day,None,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesEdge,"Specify where the axes labels are affixed:"},
			EmeraldListPlot3D[demodata,AxesEdge->{{1,1},Automatic,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,BoundaryStyle,"Specify the boundary of the surface style:"},
			EmeraldListPlot3D[triangle,BoundaryStyle->Directive[Red,Thick]],
			ValidGraphicsP[]
		],

		Example[{Options,Boxed,"Remove the edges of the bounding box:"},
			EmeraldListPlot3D[inclinedPlane,Boxed->False],
			ValidGraphicsP[]
		],

		Example[{Options,BoxRatios,"Change the ratio of the box side lenghs. Automatic is {1,1,0.4}:"},
			EmeraldListPlot3D[inclinedPlane,BoxRatios->{1,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,BoxStyle,"Using dashed lines for the boundary of bounding box:"},
			EmeraldListPlot3D[crossingPlanes,BoxStyle->Directive[Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,ClipPlanes,"Clip the graphics based on an infinite plane:"},
			EmeraldListPlot3D[deltaSurface,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Opacity[0.3]],
			ValidGraphicsP[]
		],

		Example[{Options,ClipPlanesStyle,"Change the style of the clipping planes:"},
			EmeraldListPlot3D[deltaSurface,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Directive[Orange,Opacity[0.3]]],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGrids,"Add grids for the bounding box:"},
			EmeraldListPlot3D[deltaSurface,FaceGrids->{{0,0,1},{0,0,-1}}],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGridsStyle,"Add grids for the bounding box with changing the color:"},
			EmeraldListPlot3D[deltaSurface,FaceGrids->All,FaceGridsStyle->Directive[Orange, Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,Lighting,"Change the light sources:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,NormalsFunction,"Change the effective normal function to the surface. Here making a flat shading:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,NormalsFunction->None,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,RegionFunction,"Plot over an annulus region:"},
			EmeraldListPlot3D[deltaSurface,RegionFunction->Function[{x,y,z},2<x^2+y^2<9]],
			ValidGraphicsP[]
		],

		Example[{Options,RotationAction,"Chage the way the rotation of the graph is handled and making it clip the axes when they go out of scope:"},
			EmeraldListPlot3D[deltaSurface,RotationAction->"Clip"],
			ValidGraphicsP[]
		],

		Example[{Options,VertexColors,"Change the color of the vertices of the graph:"},
			EmeraldListPlot3D[triangle,VertexColors->{Red,Green,Blue}],
			ValidGraphicsP[]
		],

		Example[{Options,VertexNormals,"Use the vertex normal will affect shading:"},
			EmeraldListPlot3D[triangle,VertexNormals->{Red,Green,Blue}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewAngle,"Widen the angle of the automatic camera:"},
			Table[EmeraldListPlot3D[sinSurface,ImageSize->200,ViewAngle->d Degree],{d,{20,35,50}}],
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewPoint,"Top to bottom image:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,ViewPoint->Above],
			ValidGraphicsP[]
		],

		Example[{Options,ViewProjection,"Perspective view of the graph:"},
			(EmeraldListPlot3D[inclinedPlane,ImageSize->300,ViewProjection->#]&/@{"Orthographic","Perspective"}),
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewRange,"Specify the minimum and maximum distances from the camera to be included:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewRange->{3.5,7.2}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVector,"Specify the view vectors using ordinary coordinates:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewVector->{{5,-5,5},{5,0,-5}}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVertical,"Use the direction of the x axis as the vertical direction in the final image:"},
			EmeraldListPlot3D[deltaSurface,PlotRange->Automatic,ViewVertical->{1,0,0},ViewPoint->{0,-1,.5}],
			ValidGraphicsP[]
		],

		(*
			Messages
		*)
		Example[{Messages,"compat","Setting target units to an incompatible unit type results in failure:"},
			EmeraldListPlot3D[demoQdata,TargetUnits->{Hour,Kelvin,Meter}],
			Null,
			Messages:>{Quantity::compat}
		],

		Example[{Messages,"compat","Trying to plot multiple 3D data with incompatible units results in failure:"},
			EmeraldListPlot3D[{QuantityArray[demo2data, {Quantity[1, "Days"], Quantity[1, "DegreesCelsius"],Meter}], demoQdata}],
			Null,
			Messages:>{Quantity::compat}
		]
	},

	SetUp:>
		(
			constantPlane=Flatten[Table[{i,j,1}, {i,0,1},{j,0,2}],1];
			inclinedPlane=Flatten[Table[{i,j,i}, {i,0,1},{j,0,2}],1];
			demodata = Flatten[Table[{x, y, Tanh[x] Tanh[y]}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1];
			demoQdata = QuantityArray[demodata, {Quantity[1, "Days"], Quantity[1, "DegreesCelsius"], Quantity[1, "Molar"]}];
			demo2data = Flatten[Table[{x, y, -x y /4}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1];
			demoQ2data = Flatten[Table[{x Day, y Celsius, (-x y /4) Molar}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1];
			sinSurface=Flatten[Table[{i,j,Sin[j^2 + i^2]}, {i,0,Pi,Pi/30},{j,0,Pi,Pi/30}],1];
			sinSurfaceJagged=Flatten[Table[{i,j,Sin[j^2 + i^2]}, {i,0,Pi,Pi/2},{j,0,Pi,Pi/2}],1];
			triangle={{0, 3, 1}, {1, 1, 0}, {0, -1, 0}};
			deltaSurface=Quiet[Flatten[Table[{x,y,1/(x^2+y^2)},{x,-2,2,0.1},{y,-2,2,0.1}],1]];
			crossingPlanes={Flatten[Table[{x,y,x},{x,20},{y,20}],1],Flatten[Table[{x,y,y},{x,15},{y,20}],1]};
		)

];
