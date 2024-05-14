(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram3D*)


DefineTests[EmeraldSmoothHistogram3D,

	{

		(*
			Basic
		*)
		Example[{Basic,"Create a smooth 3D histogram from bivariate distribution samples:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],1000]],
			ValidGraphicsP[]
		],
		Example[{Basic,"Overlay several smooth 3D histograms:"},
			EmeraldSmoothHistogram3D[
				Table[RandomVariate[BinormalDistribution[c],
					50], {c, {-0.95, 0., 0.95}}]],
			ValidGraphicsP[]
		],
		Example[{Basic,"Smooth 3D histogram of mixture distribution:"},
			EmeraldSmoothHistogram3D[
				RandomVariate[
					MixtureDistribution[{.5, .5}, {MultinormalDistribution[{-2, -2},
						IdentityMatrix[2]],
						MultinormalDistribution[{0, 0}, .5 IdentityMatrix[2]]}], 250]],
			ValidGraphicsP[]
		],

		(*
			Additional
		*)


		(*
			Options
		*)
		Example[{Options,DistributionFunction,"Specify the distribution function used for plotting the histogram. This can be PDF, CDF, and a number of other options:"},
			Table[
				EmeraldSmoothHistogram3D[QuantityArray[RandomVariate[BinormalDistribution[{0.1,0.5},0.5],500],{Meter,Second}],
					DistributionFunction->df,ImageSize->200,PlotLabel->df
				],
				{df,{"PDF","CDF","CHF"}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldSmoothHistogram3D[singleDoubleNormal,PlotRange->{{Automatic,3.75},{Automatic,10},Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Use an explicit z range to emphasize features and mix with Automatic for the other directions:"},
			EmeraldSmoothHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",PlotRange->{Automatic,Automatic,{0,0.5}}],
			ValidGraphicsP[]
		],



		Example[{Options,AlignmentPoint,"When this graphic is used within an Inset, AlignmentPoint determines the coordinates in this graphic to which it will be aligned in the enclosing graphic:"},
			EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{500,2}],
				DistributionFunction->"PDF",ImageSize->350,
				Epilog->Inset[EmeraldBarChart[{{2.0,2.2,2.0}},ImageSize->150,AlignmentPoint->#]]
			]&/@{Bottom,Center,{-1,-1}},
			{ValidGraphicsP[]..}
		],

		Example[{Options,AspectRatio,"Change the aspect ratio of the histogram chart:"},
			EmeraldSmoothHistogram3D[Table[RandomVariate[NormalDistribution[c, 2],{500,2}],{c,{0.5,2,4}}],AspectRatio->0.5],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Three different aspect ratios:"},
			Table[
				EmeraldSmoothHistogram3D[Table[RandomVariate[NormalDistribution[c, 2],{500,2}],{c,{0.5,2,4}}],AspectRatio->ar,ImageSize->200],
				{ar,{0.5,1,1.5}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Mesh,"Use a specifc mesh style at certain locations:"},
			EmeraldSmoothHistogram3D[RandomVariate[UniformDistribution[{1,10}],{100,2}],
				Mesh->{Range[0,12,2]},MeshStyle->{Thick,Red}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Mesh,"Show the complete sampling mesh:"},
			EmeraldSmoothHistogram3D[multiBinormal,Mesh->All],
			ValidGraphicsP[]
		],

		Example[{Options,Mesh,"Use a specifc mesh style for 10 mesh points at certain locations:"},
			EmeraldSmoothHistogram3D[RandomVariate[UniformDistribution[{1,10}],{100,2}],
				Mesh->{Range[0,12,2]},MeshStyle->{Thick,Red}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Mesh,"Remove the mesh from the histogram surface:"},
			EmeraldSmoothHistogram3D[RandomVariate[UniformDistribution[{1,10}],{100,2}],Mesh->None],
			ValidGraphicsP[]
		],

		Example[{Options,MeshFunctions,"Use 3 mesh lines in the x direction and 6 mesh lines in the y direction:"},
			EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{100,2}],Mesh -> {3, 6},PlotStyle->Directive[Yellow],MeshFunctions->{#1&,#2&}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshFunctions,"Specify the number of mesh lines and the style in the z direction:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,PlotStyle->Directive[Thick,White],Mesh->5,MeshFunctions->{#3&},MeshShading->{Red,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,Axes,"Remove the axes ticks to False:"},
			EmeraldSmoothHistogram3D[QuantityArray[singleDoubleNormal,{Meter,Nano Meter}],Axes->False],
			ValidGraphicsP[]
		],

		Example[{Options,AxesOrigin,"Move the axes to a different than {0,0,0} location:"},
			EmeraldSmoothHistogram3D[QuantityArray[singleDoubleNormal,{Meter,Nano Meter}],Axes->True,AxesStyle->Directive[LightBlue,Thick,12],AxesOrigin->{0,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshShading,"Use a two color pattern to show the mesh points that changes for each row:"},
			EmeraldSmoothHistogram3D[singleDoubleNormal,Mesh->{10,4},MeshFunctions->{#1&,#2&},MeshShading->{{Yellow,Green},{Black,Red}}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshShading,"MeshShading has a higher priority than PlotStyle:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,Mesh->7,MeshFunctions->{#3&},PlotStyle->Red,MeshShading->{Black,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesStyle,"Change the style of the axes to be orange and thick with a different font size:"},
			EmeraldSmoothHistogram3D[multiDoubleNormal,Axes->True,AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,AxesLabel,"Add label for an axis. Note that Automatic does not return expected behavior:"},
			EmeraldSmoothHistogram3D[QuantityArray[multiDoubleNormal,{"Meter","Second"}],AxesLabel->{"X","Y","Z"},Axes->True,AxesStyle->Directive[Orange,Thick,12]],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Change the background color to light blue:"},
			EmeraldSmoothHistogram3D[RandomVariate[RayleighDistribution[0.5],{100,2}],Background->LightBlue],
			ValidGraphicsP[]
		],

		Example[{Options,BaseStyle,"Change the base style of the plot that changes the mesh style:"},
			EmeraldSmoothHistogram3D[RandomVariate[WeibullDistribution[1,0.1],{100,2}],BaseStyle->Red],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Change the clipping style to show different line styles if the data is cut in a certain region:"},
			Table[
				EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{500,2}],
					PlotRange->{All,All,{0,300}},
					Mesh->None,
					ClippingStyle->cs,
					ImageSize->200
				],
				{cs,{Green,Red,Dashed}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ClippingStyle,"Do not draw clipped regions:"},
			EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{500,2}],
				PlotRange->{All,All,{0,300}},
				Mesh->None,
				ClippingStyle->None,
				ImageSize->200
			],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Make clipped regions partially transparent:"},
			EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{500,2}],
				PlotRange->{All,All,{0,300}},
				Mesh->None,
				ClippingStyle->Opacity[0.5],
				ImageSize->200
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data in x, y, and z coordinate values:"},
			Table[
				EmeraldSmoothHistogram3D[singleBinormal,
					ColorFunction->Function[{x,y,z},Evaluate[f]],PlotLabel->f,Mesh->None,ImageSize->200
				],
				{f,{Hue[x],Hue[y],Hue[z]}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ColorFunction,"Provide a custom color function based on the data z coordinate values:"},
			EmeraldSmoothHistogram3D[singleBinormal,
				ColorFunction->Function[{x,y,z},Hue[.65 (1-z)]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Provide a built in color function that is also taking priority than PlotStyle:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],
				ColorFunction->"DarkRainbow",
				PlotStyle->Directive[Opacity[0.8],Red],MeshFunctions->{#3&}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Provide a custom color function based on the data y coordinate values. If True, ColorFunctionScaling will apply the color function to a 0-1 value basis:"},
			{
				EmeraldSmoothHistogram3D[singleBinormal,
					ColorFunction->Function[{x,y},Hue[y]],
					ImageSize->300,
					ColorFunctionScaling->True,
					PlotStyle->Thick
				],
				EmeraldSmoothHistogram3D[singleBinormal,
					ColorFunction->Function[{x,y},Hue[y]],
					ImageSize->300,
					ColorFunctionScaling->False,
					PlotStyle->Thick
				]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,0.5],{500,2}],ImageSize->300,DisplayFunction->(PopupWindow[Button["My Distribution"], #]&)],
			_Button
		],

		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldSmoothHistogram3D:"},
			EmeraldSmoothHistogram3D[
				RandomVariate[NormalDistribution[3,.4],{500,2}],
				Epilog->{Yellow,Disk[{0,0.75},{0.12,0.12}],Black,Disk[{0,0.75},{0.1,0.1}]}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill under the histogram either top, bottom or with respect to a certain axis or certain y value:"},
			Table[
				EmeraldSmoothHistogram3D[singleDoubleNormal,
					DistributionFunction->"PDF",RegionFunction->Function[{x,y,z},z>0.02],ImageSize->200,Filling->c,PlotLabel->c
				],
				{c,{Top,Bottom,0.1}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Filling,"Fill one histogram with CDF distribution function:"},
			EmeraldSmoothHistogram3D[
				RandomVariate[NormalDistribution[],{14,2}],
				DistributionFunction->"CDF",Filling->Top,PlotLegends->Automatic,MeshFunctions->{#3&}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FillingStyle,"Fill with gray under the surface in a certain region:"},
			Table[
				EmeraldSmoothHistogram3D[
					RandomVariate[PoissonDistribution[1],{10,2}],
					FillingStyle->c,ImageSize->300,Filling->Top,RegionFunction->Function[{x,y,z},z>0.02]
				],
				{c,{{Opacity[0.2]},{Directive[Blue,Opacity[.6]]}}}
			],
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,FormatType,"Add a textbox with standard form:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[],{14,2}],FormatType->StandardForm,Epilog->Inset[Framed[Style["Normal Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]],
			ValidGraphicsP[]
		],

		Example[{Options,ImageMargins,"Add a textbox with standard form:"},
			{
				EmeraldSmoothHistogram3D[mixtureDistribution,ImageSize->300,FormatType->StandardForm,Epilog->Inset[Framed[Style["Mixture Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]],
				EmeraldSmoothHistogram3D[mixtureDistribution,ImageMargins->20,ImageSize->300,FormatType->StandardForm,Epilog->Inset[Framed[Style["Mixture Distribution",20],Background->Directive[Opacity[0.2],Green]],Center]]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,MeshStyle,"Use a red mesh in the x direction and thick in the y direction:"},
			EmeraldSmoothHistogram3D[RandomVariate[WeibullDistribution[2,0.1],{100,2}],Mesh->9,MeshStyle->{Red,Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,MeshStyle,"Use a red and thick mesh in the z direction:"},
			EmeraldSmoothHistogram3D[RandomVariate[ExponentialDistribution[1],{100,2}],Mesh->9,MeshStyle->{Red,Thick},MeshFunctions->{#3&}],
			ValidGraphicsP[]
		],

		Example[{Options,PerformanceGoal,"Change the performance goal to either Speed or Quality -- It does not seem to affect the final result:"},
			{
				EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[],{100,2}],ImageSize->300,Mesh->All,MeshStyle->{Red,Thick},PlotRange->Automatic,PerformanceGoal->"Speed"],
				EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[],{100,2}],ImageSize->300,Mesh->All,MeshStyle->{Red,Thick},PlotRange->Automatic,PerformanceGoal->"Quality"]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,PlotLabel,"Add the plot label for the whole plot:"},
			EmeraldSmoothHistogram3D[Table[RandomVariate[NormalDistribution[c,1],{500,2}],{c,0,5}],
				PlotLabel->"Multiple Normal Distributions",
				PlotLegends->Automatic
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLegends,"Add the plot legends for each of the distributions:"},
			EmeraldSmoothHistogram3D[Table[RandomVariate[WeibullDistribution[c, 2],{500,2}],{c,{0.5,2,4}}],PlotRange->{{Automatic,2},{Automatic,2},Automatic},AspectRatio->0.5,PlotLegends->{0.5,2,4}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add paddings to the graphics:"},
			EmeraldSmoothHistogram3D[RandomVariate[WeibullDistribution[1,2],{500,2}],PlotRangePadding->True,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangePadding,"Add specific value for padding of the main histogram:"},
			EmeraldSmoothHistogram3D[RandomVariate[WeibullDistribution[1,2],{20000,2}],PlotRange->{{0,10},{0,10}, Automatic},PlotRangePadding->5,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Change the style of the plot:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,0.1],{500,2}],DistributionFunction->"CDF",PlotStyle->{Purple,Opacity[0.25],Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotTheme,"A number of options for PlotTheme exist. Please use ctrl+k in your notebook to find out more:"},
			EmeraldSmoothHistogram3D[{mixtureDistribution,singleDoubleNormal},PlotTheme->"BoldScheme"],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Add a prolog to the plot:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,0.5],{500,2}],
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

		Example[{Options,MaxRecursion,"Default sampling mesh used for showing the distribution. Each level of MaxRecursion will subdivide the initial mesh into a finer mesh:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,10],{100,2}],
				MaxRecursion->0,Mesh->All
			],
			ValidGraphicsP[]
		],

		Example[{Options,MaxRecursion,"Change the default sampling mesh used for showing the distribution:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,10],{100,2}],
				MaxRecursion->3,Mesh->All
			],
			ValidGraphicsP[]
		],

		Example[{Options,MaxRecursion,"Show the impact of changing the maximum recursion with respect to the default value:"},
			Table[
				EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],
					Mesh->All,Axes->False,PlotPoints->2,MaxRecursion->r,ImageSize->200
				],
				{r,{0,2,3}}
			],
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,RegionFunction,"Show the histogram only in a certain region:"},
			EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[],{100,2}],
				RegionFunction->Function[{x,y,z}, 2 < x^2+y^2 < 9],
				DistributionFunction->"PDF",PlotPoints->20,MaxRecursion->0
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotPoints,"Use more initial points to get a smoother curve -- this does seem to be doing the reverse behavior:"},
			Table[
				EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[0.5],100],
					DistributionFunction->"PDF",Mesh->None,PlotPoints->i,MaxRecursion->0,ImageSize->200
				],
				{i,{5,20,100}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,WorkingPrecision,"Change the working precision of the sampling -- The impact is not quite obvious:"},
			Table[
				EmeraldSmoothHistogram3D[RandomVariate[NormalDistribution[1,10],{100,2}],
					WorkingPrecision->p,Mesh->All,ImageSize->300
				],
				{p,{2,14}}
			],
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ImageSize,"Change the size of the image:"},
			(EmeraldSmoothHistogram3D[multiBinormal,ImageSize->#]&/@{100,200,300}),
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ImageMargins,"Add margin to the graphics:"},
			EmeraldSmoothHistogram3D[multiDoubleNormal,ImageMargins->30,PlotStyle->Purple,MeshStyle->Green],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Suppress axes units from axes label -- The behvaior is incorrect now:"},
			EmeraldSmoothHistogram3D[QuantityArray[multiDoubleNormal,{"Second","Hour"}], AxesUnits -> {None, Automatic, Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesUnits,"Set axes labels for 3D quantity array plots -- The behavior is incorrect:"},
			EmeraldSmoothHistogram3D[QuantityArray[singleDoubleNormal,{"Second","Hour"}],AxesUnits->{Day,None,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,AxesEdge,"Specify where the axes labels are affixed. -1 and 1 are associated with either left-right or bottom-top for the axes. The default value would be -1 for all:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,AxesEdge->{{1,1},Automatic,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,BoundaryStyle,"Specify the boundary of the surface style:"},
			EmeraldSmoothHistogram3D[singleMultiPoisson,BoundaryStyle->Directive[Red,Thick]],
			ValidGraphicsP[]
		],

		Example[{Options,BoundaryStyle,"Remove the boundary:"},
			EmeraldSmoothHistogram3D[singleMultiPoisson,BoundaryStyle->None],
			ValidGraphicsP[]
		],

		Example[{Options,BoundaryStyle,"Specify the boundary of the surface style in a certain region:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],
				BoundaryStyle->Thick,RegionFunction->Function[{x,y,z},x^2+y^2>=1],MeshFunctions->{#3&}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Boxed,"Remove the edges of the bounding box:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,Boxed->False],
			ValidGraphicsP[]
		],

		Example[{Options,BoxRatios,"Change the ratio of the box side lenghs. Automatic is {1,1,0.4}:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],BoxRatios->{1,1,1}],
			ValidGraphicsP[]
		],

		Example[{Options,BoxStyle,"Using dashed lines for the boundary of bounding box:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],BoxStyle->Directive[Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,ClipPlanes,"Clip the graphics based on an infinite plane:"},
			{
				EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ImageSize->300],
				EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ImageSize->300,ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Opacity[0.3]]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ClipPlanesStyle,"Change the style of the clipping planes:"},
			EmeraldSmoothHistogram3D[RandomVariate[BinormalDistribution[.5],10],DistributionFunction->"CDF",ClipPlanes->InfinitePlane[{{10,0,0},{0,10,1},{1,0,1}}],ClipPlanesStyle->Directive[Orange,Opacity[0.3]]],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGrids,"Add grids for the bounding box:"},
			EmeraldSmoothHistogram3D[singleBinormal,MeshFunctions->{#3&},FaceGrids->{{0,0,1},{0,0,-1}}],
			ValidGraphicsP[]
		],

		Example[{Options,FaceGridsStyle,"Add grids for the bounding box with changing the color:"},
			EmeraldSmoothHistogram3D[singleBinormal,MeshFunctions->{#3&},FaceGrids->All,FaceGridsStyle->Directive[Orange, Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,Lighting,"Change the light sources:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,PlotRange->Automatic,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,NormalsFunction,"Change the effective normal function to the surface. Here making a flat shading:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,PlotRange->Automatic,NormalsFunction->None,Lighting->{{"Directional",RGBColor[1,.7,.1],{{5,5,4},{5,5,0}}}}],
			ValidGraphicsP[]
		],

		Example[{Options,RegionFunction,"Plot over an annulus region:"},
			EmeraldSmoothHistogram3D[mixtureDistribution,RegionFunction->Function[{x,y,z},2<x^2+y^2<9]],
			ValidGraphicsP[]
		],

		Example[{Options,RotationAction,"Chage the way the rotation of the graph is handled and making it clip the axes when they go out of scope:"},
			{
				EmeraldSmoothHistogram3D[singleMultiPoisson,ImageSize->300,RotationAction->"Clip"],
				EmeraldSmoothHistogram3D[singleMultiPoisson,ImageSize->300,RotationAction->"Fit"]
			},
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewAngle,"Widen the angle of the automatic camera:"},
			Table[EmeraldSmoothHistogram3D[singleDoubleNormal,MeshFunctions->{#3&},ImageSize->200,ViewAngle->d Degree],{d,{20,35,50}}],
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewPoint,"A single graph with three different view points. Note that the automatic is {1.3,-2.4,2.}:"},
			{
				EmeraldSmoothHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->{-2,0,0}],
				EmeraldSmoothHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->Above],
				EmeraldSmoothHistogram3D[singleDoubleNormal,DistributionFunction->"CDF",ImageSize->200,PlotRange->Automatic,ViewPoint->Front]
			},
			ConstantArray[ValidGraphicsP[],3]
		],

		Example[{Options,ViewProjection,"Perspective view of the graph:"},
			(EmeraldSmoothHistogram3D[multiDoubleNormal,ImageSize->300,Mesh->20,MeshFunctions->{#3&},MeshStyle->{Thick},PlotStyle->{LightRed,LightGreen},ViewProjection->#]&/@{"Orthographic","Perspective"}),
			ConstantArray[ValidGraphicsP[],2]
		],

		Example[{Options,ViewRange,"Specify the minimum and maximum distances from the camera to be included:"},
			EmeraldSmoothHistogram3D[singleDoubleNormal,PlotStyle->PointSize[0.01],Mesh->20,MeshFunctions->{#3&},PlotRange->Automatic,ViewPoint->{0,-1,.5},ViewRange->{100,700}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVector,"Specify the view vectors using ordinary coordinates:"},
			EmeraldSmoothHistogram3D[singleMultiPoisson,PlotStyle->PointSize[0.01],MeshFunctions->{#3&},MeshStyle->{Thick},PlotRange->Automatic,ViewPoint->{0,-2,.5},ViewVector->{{5,-5,5},{5,0,-5}}],
			ValidGraphicsP[]
		],

		Example[{Options,ViewVertical,"Use the direction of the x axis as the vertical direction in the final image:"},
			EmeraldSmoothHistogram3D[singleMultiPoisson,PlotStyle->PointSize[0.01],MeshFunctions->{#3&},MeshStyle->{Thick},PlotRange->Automatic,ViewVertical->{1,0,0},ViewPoint->{0,-1,.5}],
			ValidGraphicsP[]
		],

		Example[{Options,LabelStyle,"Change the label style, the font, fontsize and color:"},
			EmeraldSmoothHistogram[RandomVariate[NormalDistribution[3,.4],{500,2}],Frame->True,PlotLabel->"My Distribution",LabelStyle->Directive[Blue,FontSize->14,FontFamily->"Helvetica"]],
			ValidGraphicsP[]
		]

	},

	SetUp:>
		(
			singleBinormal=RandomVariate[BinormalDistribution[.5], 100];
			singleDoubleNormal=RandomVariate[NormalDistribution[0,1],{200,2}];
			multiBinormal=Table[RandomVariate[BinormalDistribution[c],50],{c,{-0.95,0.,0.95}}];
			multiDoubleNormal=
				{
					RandomVariate[NormalDistribution[0,1],{200,2}],
					RandomVariate[NormalDistribution[1, 2], {200, 2}]
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
			singleMultiPoisson=RandomVariate[MultivariatePoissonDistribution[1,{2,3}],500];
		)

];
