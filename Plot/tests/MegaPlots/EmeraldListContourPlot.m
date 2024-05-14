(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListContourPlot*)


DefineTests[EmeraldListContourPlot,{
		Example[{Basic,"Create a contour plot from data triplets:"},
			EmeraldListContourPlot[Flatten[Table[{i,j,Sin[i+j^2]},{i,0,3,0.1},{j,0,3,0.1}],1]],
			ValidGraphicsP[]
		],

		Example[{Basic,"Add a plot legend and smooth the contours:"},
			EmeraldListContourPlot[RandomReal[1, {10, 10}],	InterpolationOrder -> 3, PlotLegends -> Automatic],
			ValidGraphicsP[]
		],

		Example[{Basic,"Display a mesh on the data:"},
			EmeraldListContourPlot[Table[Sin[x y], {x, 0, 3, 0.1}, {y, 0, 3, 0.1}],	Mesh -> All],
			ValidGraphicsP[]
		],

		(*
			OPTIONS
		*)

		Example[{Options,AspectRatio,"Adjust the aspect ratio of the graphic. The default is 1.0:"},
			Table[
				EmeraldListContourPlot[fivePeaksData,ImageSize->200,AspectRatio->aspect],
				{aspect,{Automatic,2.0,0.5}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Background,"Set the background color of the plot:"},
			EmeraldListContourPlot[fivePeaksData,ContourShading->None,Background->LightGreen],
			ValidGraphicsP[]
		],
		Example[{Options,Background,"When contour shading is enabled, the background is drawn behind contour shading:"},
			EmeraldListContourPlot[fivePeaksData,Background->LightGreen],
			ValidGraphicsP[]
		],

		Example[{Options,BaseStyle,"Apply a common styling directive to all elements in the plot:"},
			EmeraldListContourPlot[RandomReal[1,{10,10}],InterpolationOrder->3,BaseStyle->Thick],
			ValidGraphicsP[]
		],
		Example[{Options,BaseStyle,"All chart elements will be styled when valid. For example, directive Dashed will apply to both contours and the plot frame:"},
			EmeraldListContourPlot[RandomReal[1,{10,10}],InterpolationOrder->3,BaseStyle->Dashed],
			ValidGraphicsP[]
		],

		Example[{Options,BoundaryStyle,"By default, no boundary is applied:"},
			EmeraldListContourPlot[Table[Sin[j^2+i],{i,0,Pi,0.05},{j,0,Pi,0.05}]],
			ValidGraphicsP[]
		],
		Example[{Options,BoundaryStyle,"Set BoundaryStyle to highlight the edges around contour areas:"},
			EmeraldListContourPlot[Table[Sin[j^2+i],{i,0,Pi,0.05},{j,0,Pi,0.05}],
				BoundaryStyle -> Red
			],
			ValidGraphicsP[]
		],
		Example[{Options,BoundaryStyle,"Boundaries applies to any holes cut by RegionFunction:"},
			EmeraldListContourPlot[Table[Sin[j^2+i],{i,0,Pi,0.05},{j,0,Pi,0.05}],
				BoundaryStyle->Red,
				RegionFunction->Function[{x,y,z},Abs[z]>=0.25]
			],
			ValidGraphicsP[]
		],
		Example[{Options,BoundaryStyle,"Boundaries apply when there are jumps in the surface, such as when interpolation order is set to zero:"},
			EmeraldListContourPlot[{{10,10,1},{6,8,10},{7,9,9},{1,1,2},{4,6,4},{7,4,9},{10,6,8}},
				InterpolationOrder->0,
				BoundaryStyle -> Red
			],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Clipped regions (e.g. infinities) are not shown by default:"},
			EmeraldListContourPlot[gammaData,
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]"
			],
			ValidGraphicsP[]
		],
		Example[{Options,ClippingStyle,"Explicitly set ClippingStyle to Automatic to color clipped regions like surrounding regions:"},
			EmeraldListContourPlot[gammaData,
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				ClippingStyle->Automatic
			],
			ValidGraphicsP[]
		],
		Example[{Options,ClippingStyle,"Fill all clipped regions with the same color:"},
			EmeraldListContourPlot[gammaData,
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				ClippingStyle->Purple
			],
			ValidGraphicsP[]
		],
		Example[{Options,ClippingStyle,"Highlight regions clipped below with Red, and regions clipped above with Green:"},
			EmeraldListContourPlot[gammaData,
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				ClippingStyle->{Red,Darker@Green}
			],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Use a color function to shade regions between contours according to their scaled z coordinate:"},
			EmeraldListContourPlot[wavyData,ColorFunction->Hue],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunction,"Use a named color function to shade regions between contours according to their scaled z coordinate:"},
			EmeraldListContourPlot[wavyData,ColorFunction->"Warm"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Color function uses scaled z-coordinates by default. Set ColorFunctionScaling->False to use absolute coordinates, for example, to label negative values in blue and positive values in red:"},
			Table[
				EmeraldListContourPlot[fourQuadrantData,ImageSize->250,ColorFunction->(If[#<0,Darker[Blue,Abs[#]],Lighter[Red,#]]&),ColorFunctionScaling->scaling],
				{scaling,{True,False}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ContourLabels,"Add labels to contour lines:"},
			EmeraldListContourPlot[fourQuadrantData,ContourLabels->All],
			ValidGraphicsP[]
		],
		Example[{Options,ContourLabels,"Use a function to generate a custom label for each contour:"},
			EmeraldListContourPlot[fourQuadrantData,ContourLabels->Function[{x,y,z},Text[Framed[z],{x,y},Background->White]]],
			ValidGraphicsP[]
		],

		Example[{Options,Contours,"By default, use automatic contour selection:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,Contours,"Use seven equally spaced contours:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->7],
			ValidGraphicsP[]
		],
		Example[{Options,Contours,"Use at most five automatically selected contours:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->{Automatic,5}],
			ValidGraphicsP[]
		],
		Example[{Options,Contours,"Use specific contour values at -0.5, 0.0, and 0.5:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->{-0.5,0,0.5}],
			ValidGraphicsP[]
		],
		Example[{Options,Contours,"Apply styling to specific contours:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->{{-0.5,Thick},{0.5,Dashed}}],
			ValidGraphicsP[]
		],
		Example[{Options,Contours,"Use a function, which takes the minimum and maximum data values, to generate contours:"},
			EmeraldListContourPlot[fourQuadrantData,Contours->Function[{min,max},Range[min,max,0.1]]],
			ValidGraphicsP[]
		],

		Example[{Options,ContourShading,"Automatic shading is dark at low values and lighter at high values:"},
			EmeraldListContourPlot[fourQuadrantData,ContourShading->Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,ContourShading,"Use ContourShading->None to only show contour lines:"},
			EmeraldListContourPlot[fourQuadrantData,ContourShading->None],
			ValidGraphicsP[]
		],
		Example[{Options,ContourShading,"Shade contours with alternating colors:"},
			EmeraldListContourPlot[fourQuadrantData,ContourShading->{Black,White}],
			ValidGraphicsP[]
		],
		Example[{Options,ContourShading,"Include style directives with the colors in the contour shadings:"},
			EmeraldListContourPlot[fourQuadrantData,ContourShading->{{Black,Opacity[0.5]},White}],
			ValidGraphicsP[]
		],
		Example[{Options,ContourShading,"When a list of colors is provided, contours will be shaded in order, repeating through the list if there are more contours than colors:"},
			EmeraldListContourPlot[Table[x+y,{x,-3,3,0.1},{y,-3,3,0.1}],Contours->10,ContourShading->{Red,Red,Blue,Green}],
			ValidGraphicsP[]
		],

		Example[{Options,ContourStyle,"The default contour style is a partially transparent line:"},
			EmeraldListContourPlot[fourQuadrantData,ContourStyle->Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,ContourStyle,"Use obnoxious green contour lines:"},
			EmeraldListContourPlot[fourQuadrantData,ContourStyle->Green],
			ValidGraphicsP[]
		],
		Example[{Options,ContourStyle,"Use None to hide contour lines:"},
			EmeraldListContourPlot[fourQuadrantData,ContourStyle->None],
			ValidGraphicsP[]
		],
		Example[{Options,ContourStyle,"Alternate between contour line styles:"},
			EmeraldListContourPlot[fourQuadrantData,ContourStyle->{Red,{Blue,Dashed}}],
			ValidGraphicsP[]
		],
		Example[{Options,ContourStyle,"Apply a style directive to use thick, red, dashed contour lines:"},
			EmeraldListContourPlot[fourQuadrantData,ContourStyle->Directive[Thick,Red,Dashed]],
			ValidGraphicsP[]
		],

		Example[{Options,DataRange,"Use DataRange to rescale the data range in the output plot. DataRange defaults to All; set DataRange to {{0,1},{0,1}} to use scaled coordinates:"},
			{
				EmeraldListContourPlot[RandomReal[1,{10,10}],InterpolationOrder->3,ImageSize->250,DataRange->All],
				EmeraldListContourPlot[RandomReal[1,{10,10}],InterpolationOrder->3,ImageSize->250,DataRange->{{0,1},{0,1}}]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotRange,"Specify plot range:"},
			EmeraldListContourPlot[
				Flatten[Table[{i, j, Sin[i + j^2]}, {i, 0, 3, 0.1}, {j, 0, 3, 0.1}],
					1], PlotRange -> {{0, 2}, {2, 3}, Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Render any graphics object behind the contour plot using Prolog:"},
			EmeraldListContourPlot[Table[i^2-j^3,{i,-1.5,1.5,0.1},{j,-1.5,1.5,0.1}],ImageSize->400,ContourShading->{Opacity[0.2]},Prolog->Inset[Import["ExampleData/spikey.tiff"]]],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Render any graphics object on top of the contour plot using Epilog:"},
			EmeraldListContourPlot[Table[i^2-j^3,{i,-1.5,1.5,0.1},{j,-1.5,1.5,0.1}],ImageSize->400,Epilog->Inset[Framed@Import["ExampleData/spikey.tiff"]]],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Set FrameTicks->None to disable ticks in the plot:"},
			{
				EmeraldListContourPlot[gammaData,FrameLabel->{"Real","Imaginary"},PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",ImageSize->250,FrameTicks->Automatic],
				EmeraldListContourPlot[gammaData,FrameLabel->{"Real","Imaginary"},PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",ImageSize->250,FrameTicks->None]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldListContourPlot[gammaData,FrameLabel->{"Real","Imaginary"},PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",ImageSize->300,FrameTicksStyle->Directive[Red,Thick,16]],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldListContourPlot[gammaData,FrameLabel->{"Real","Imaginary"},PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",ImageSize->300,FrameTicksStyle->{{Directive[Green,Thick],Directive[Blue,Thick]},{Directive[Red,Thick],Directive[Darker@Yellow,Thick]}}],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->None to hide the frame:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				Frame->None
			],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Set Frame with format {{left,right},{bottom,top}} to selectively enable or disable frame walls:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				Frame->{{True,True},{False,False}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Specify frame label:"},
			EmeraldListContourPlot[
				Flatten[Table[{i, j, Sin[i + j^2]}, {i, 0, 3, 0.1}, {j, 0, 3, 0.1}],
					1], FrameLabel -> {"x", "y"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Default frame label uses units from data:"},
			EmeraldListContourPlot[
				QuantityArray[
					Flatten[Table[{i, j, Sin[i + j^2]}, {i, 0, 3, 0.1}, {j, 0, 3, 0.1}],
						1], {Second, Meter, Gram}], FrameLabel -> Automatic],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to specify {vertical,horizontal} gridlines:"},
			EmeraldListContourPlot[fivePeaksData,
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Explicitly specify gridlines, e.g. to increase the grid resolution around particular values:"},
			EmeraldListContourPlot[fivePeaksData,
				GridLines->{
					{0.0,1.0,2.0,2.3,2.4,2.5,2.6,2.7,3.0,4.0,5.0},
					{0.0,1.0,2.0,2.3,2.4,2.5,2.6,2.7,3.0,4.0,5.0}
				}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Specify gridlines using {value,Directive} pairs to apply specific styling to individual grid lines:"},
			EmeraldListContourPlot[fivePeaksData,
				GridLines->{
					{{2.0,Directive[Dashed,Thick,Red]},{2.5,Directive[Blue,Thick]},{3.0,Directive[Dashed,Thick,Red]}},
					{{2.0,Directive[Dashed,Thick,Red]},{2.5,Directive[Blue,Thick]},{3.0,Directive[Dashed,Thick,Red]}}
				}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldListContourPlot[fivePeaksData,
				GridLines->Automatic,
				GridLinesStyle->Directive[Thick,Red,Dashed]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldListContourPlot[fivePeaksData,ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldListContourPlot[fivePeaksData,ImageSize->{400,200}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldListContourPlot[fivePeaksData,ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,InterpolationOrder,"By default, EmeraldListContourPlot uses first-order linear interpolation:"},
			EmeraldListContourPlot[Flatten[Table[{i,j,Sin[j^2 + i]}, {i, 0, Pi, 0.5}, {j, 0, Pi, 0.5}],1]],
			ValidGraphicsP[]
		],
		Example[{Options,InterpolationOrder,"Comparison of different interpolation orders for irregular (non-gridded) data:"},
			Table[
				EmeraldListContourPlot[Table[With[{xxx=RandomReal[5],yyy=RandomReal[5]},{xxx,yyy,Sin[x y]}],{200}],
					PlotLabel->"Order "<>ToString[o],
					ImageSize->200,
					InterpolationOrder->o
				],
				{ o,{0,1,2,3} }
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelStyle,"Apply a style directive or list of style elements to all label-like elements in the plot:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				LabelStyle->{14.`,Orange,Italic,FontFamily->"Helvetica"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,MaxPlotPoints,"When a contour plot is plotted, a mesh connecting all input data points is created. We can view the mesh by disabling Contours and showing the Mesh - in this example, data points were sampled randomly:"},
			{
				EmeraldListContourPlot[randomGrid,ImageSize->250,PlotLabel->"Contour Plot"],
				EmeraldListContourPlot[randomGrid,ImageSize->250,PlotLabel->"Underlying Mesh",ContourShading->None,Contours->0,Mesh->All]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,MaxPlotPoints,"MaxPlotPoints limits the number of sampling points in the underlying mesh in each direction. If the input data has an uneven mesh, as in this example, data will be resampled to a regular grid:"},
			{
				EmeraldListContourPlot[randomGrid,ImageSize->250,PlotLabel->"Contour Plot",MaxPlotPoints->10],
				EmeraldListContourPlot[randomGrid,ImageSize->250,PlotLabel->"Underlying Mesh",ContourShading->None,Contours->0,Mesh->All,MaxPlotPoints->10]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,Mesh,"Show the initial and final sampling mesh:"},
			{
				EmeraldListContourPlot[parabolicData,ImageSize->250,PlotLabel->"Full Mesh",Mesh->Full],
				EmeraldListContourPlot[parabolicData,ImageSize->250,PlotLabel->"Final (All) Mesh",Mesh->All]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,Mesh,"Use five mesh levels in each direction:"},
			EmeraldListContourPlot[parabolicData,Mesh->5,MeshFunctions->{#1&,#2&},MeshStyle->Darker[Red]],
			ValidGraphicsP[]
		],

		Example[{Options,MeshFunctions,"MeshFunctions determine how mesh lines are drawn, defaulting to showing the x- and y-values of the mesh lines:"},
			EmeraldListContourPlot[parabolicData,Mesh->5,MeshFunctions->{#1&,#2&},MeshStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,MeshFunctions,"Use mesh functions to show the real and imaginary parts of a complex-valued function:"},
			EmeraldListContourPlot[
 				Table[Abs[Sqrt[(x + I y)^3]], {x, -3, 3, 0.1}, {y, -3, 3, 0.1}],
				MeshFunctions->{Re[Sqrt[(#1 + I #2)^3]]&,Im[Sqrt[(#1 + I #2)^3]] &},
				Mesh->10,
				MeshStyle->{Blue,Red},
				ColorFunction->GrayLevel
			],
			ValidGraphicsP[]
		],

		Example[{Options,MeshStyle,"Specify how mesh lines should be drawn. Here, use red mesh lines:"},
			EmeraldListContourPlot[parabolicData,Mesh->5,MeshFunctions->{#1&,#2&},MeshStyle->Red],
			ValidGraphicsP[]
		],
		Example[{Options,MeshStyle,"Use red mesh lines in the x-direction and blue, dashed mesh lines in the y-direction:"},
			EmeraldListContourPlot[parabolicData,Mesh->5,MeshFunctions->{#1&,#2&},MeshStyle->{Red,{Blue,Dashed}}],
			ValidGraphicsP[]
		],

		Example[{Options,PerformanceGoal,"Set PerformanceGoal to \"Quality\" to generate a high-quality plot at the expense of computation time:"},
			Timing[EmeraldListContourPlot[denseData,ImageSize->300,PerformanceGoal->"Quality"]],
			{NumericP,ValidGraphicsP[]}
		],
		Example[{Options,PerformanceGoal,"Set PerformanceGoal to \"Speed\" to emphasize performance, possibly at the cost of quality:"},
			Timing[EmeraldListContourPlot[denseData,ImageSize->300,PerformanceGoal->"Speed"]],
			{NumericP,ValidGraphicsP[]}
		],
		Example[{Options,PerformanceGoal,"The MaxPlotPoints option will override the \"Speed\" PerformanceGoal:"},
			{
				EmeraldListContourPlot[denseData,ImageSize->300,PerformanceGoal->"Speed",PlotLabel->"MaxPlotPoints->Automatic"],
				EmeraldListContourPlot[denseData,ImageSize->300,PerformanceGoal->"Speed",PlotLabel->"MaxPlotPoints->\[Infinity\]",MaxPlotPoints->\[Infinity]]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotLabel,"Supply a plot title with PlotLabel:"},
			EmeraldListContourPlot[gammaData,PlotLabel->"Imaginary Component of \[CapitalGamma\](x+iy)"],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLegends,"By default, no legend is used:"},
			EmeraldListContourPlot[fivePeaksData],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLegends,"Use Placed[] to set the location of the Legend:"},
			Table[
				EmeraldListContourPlot[fivePeaksData,ImageSize->250,PlotLabel->pos,PlotLegends->Placed[Automatic,pos]],
				{pos,{Above,Below,Left,Right}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotRangeClipping,"PlotRangeClipping determines whether plot elements should be drawn outside of the PlotRange:"},
			{
				EmeraldListContourPlot[fivePeaksData,PlotRange->{{1,4},{1,4}},ImageSize->250,FrameStyle->Red,PlotRangeClipping->True],
 				EmeraldListContourPlot[fivePeaksData,PlotRange->{{1,4},{1,4}},ImageSize->250,FrameStyle->Red,PlotRangeClipping->False]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotTheme,"Apply a named plot theme to the contour plot:"},
			EmeraldListContourPlot[Table[i^2-j^3,{i,-1.5,1.5,0.1},{j,-1.5,1.5,0.1}],PlotTheme->"Monochrome"],
			ValidGraphicsP[]
		],
		Example[{Options,PlotTheme,"Change the tone of the Monochrome plot theme:"},
			EmeraldListContourPlot[Table[i^2-j^3,{i,-1.5,1.5,0.1},{j,-1.5,1.5,0.1}],PlotTheme->{"Monochrome",Darker@Green}],
			ValidGraphicsP[]
		],

		Example[{Options,RegionFunction,"Use a RegionFunction to plot only areas where Abs[z]>0.25:"},
			EmeraldListContourPlot[Table[Sin[j^2+i],{i,0,Pi,0.05},{j,0,Pi,0.05}],
				BoundaryStyle->Red,
				RegionFunction->Function[{x,y,z},Abs[z]>=0.25]
			],
			ValidGraphicsP[]
		],
		Example[{Options,RegionFunction,"The regions specified by RegionFunction can be discontinuous:"},
			EmeraldListContourPlot[Table[Sin[j^2+i],{i,0,Pi,0.07},{j,0,Pi,0.07}],
 				RegionFunction->Function[{x,y,z},0<Mod[x^2+y^2,2]<1],
				DataRange->{{0,Pi},{0,Pi}},
				BoundaryStyle->Red
			],
			ValidGraphicsP[]
		],
		Example[{Options,RegionFunction,"RegionFunction may consist of any logical combination of conditions:"},
			EmeraldListContourPlot[Table[Sin[x+y^2],{x,-2,2,0.1},{y,-2,2,0.1}],
				RegionFunction->Function[{x,y,z},(x-1/2)^2+y^2>1 && (x+1/2)^2+y^2>1],
				BoundaryStyle->Red,
				DataRange->{{-2, 2}, {-2, 2}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,RotateLabel,"Specify if the y-axis Frame label should be rotated. Default is False:"},
			Table[
				EmeraldListContourPlot[gammaData,ImageSize->300,FrameLabel->{"Real","Imaginary"},PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",RotateLabel->rot],
				{rot,{True,False}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,TargetUnits,"Data will be converted to TargetUnits:"},
			EmeraldListContourPlot[
				QuantityArray[
					Flatten[Table[{i, j, Sin[i + j^2]}, {i, 0, 3, 0.1}, {j, 0, 3, 0.1}],
						1], {Second, Meter, Gram}], TargetUnits -> {Hour, Inch, Kilogram}],
			ValidGraphicsP[]
		],

		Example[{Options,Zoomable,"Make the plot Zoomable:"},
			EmeraldListContourPlot[gammaData,
				FrameLabel->{"Real","Imaginary"},
				PlotLabel->"Im[ \[CapitalGamma\](x+iy) ]",
				Zoomable->True
			],
			ValidGraphicsP[]
		]
	},

	Variables:>{denseData,fourQuadrantData,fivePeaksData,gammaData,parabolicData,randomGrid,wavyData},
	SetUp:>(
		denseData=Table[Sin[j^2+i],{i,0,Pi,0.02},{j,0,Pi,0.01}];
		fourQuadrantData=Table[Sin[x]Sin[y],{x,-3,3,0.1},{y,-3,3,0.1}];
		fivePeaksData=Flatten[Table[
    	{x,y,0.7*Exp[-((x - 2.5)^2+(y - 2.5)^2)/1.8]+
				Exp[-((x - 0.5)^2 + (y - 0.5)^2)/0.5] +
	      Exp[-((x - 0.5)^2 + (y - 4.5)^2)/0.5] +
	      Exp[-((x - 4.5)^2 + (y - 4.5)^2)/0.5] +
	      Exp[-((x - 4.5)^2 + (y - 0.5)^2)/0.5]
     	},
    	{x, 0, 5, 0.1`}, {y, 0, 5, 0.1`}
		],1];
		gammaData=Flatten[Table[{x,y,Im[Gamma[x + I y]]},{y,-3.5,3.5,0.1},{x,-3.5,3.5,0.1}],1];
		parabolicData=Table[Sin[x+y^2],{x,-3,3,0.2},{y,-2,2,0.2}];
		randomGrid=Table[With[{xxx=RandomReal[Pi],yyy=RandomReal[Pi]},{xxx,yyy,xxx+yyy^2}],{100}];
		wavyData=Table[x+Sin[3 x+y^2],{x,-3,3,0.1},{y,-3,3,0.1}];
	)

];
