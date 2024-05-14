(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldPieChart*)


DefineTests[EmeraldPieChart,

	{

		Example[{Basic,"Create a pie chart of a list of heights:"},
			EmeraldPieChart[{1,2,3,4}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Create a pie chart containing multiple data sets:"},
			EmeraldPieChart[{{1,2,3,4},{3,2,2,5}}],
			ValidGraphicsP[]
		],


		(*
			UNITS
		*)
		Example[{Additional,"Units","Chart data with units:"},
			EmeraldPieChart[{1,2,3,4}*Meter],
			ValidGraphicsP[]
		],
		Example[{Additional,"Units","Data units can be different, but must be compatible:"},
			EmeraldPieChart[{{1,2,3,4}*Yard,{1,2,3,4}*Foot}],
			ValidGraphicsP[]
		],


		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","Chart a single data set given as a QuantityArray:"},
			EmeraldPieChart[QuantityArray[{1,2,3,4,5},Meter]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","A list of quantity array data sets:"},
			EmeraldPieChart[{QuantityArray[{1,2,3,4},Yard],QuantityArray[{4,5,6,7},Foot]}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of data sets:"},
			EmeraldPieChart[QuantityArray[{{1,2,3,4},{2,3,4,5}},Meter]],
			ValidGraphicsP[]
		],


		(*
			MISSING DATA
		*)
		Example[{Additional,"Missing Data","Null values in a data set are ignored:"},
			EmeraldPieChart[{1,2,Null,4}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Data set elements are associated with one another starting from the left.  Missing elements are ignored:"},
			EmeraldPieChart[{{1,2,3,4},{3,1,6}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values in any data set are ignored:"},
			EmeraldPieChart[{{1,2,Null,4},{1,Null,3,Null}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Entire missing data sets also ignored:"},
			EmeraldPieChart[{{1,2,Null,4},Null,{1,Null,3,Null}}],
			ValidGraphicsP[]
		],


		(*
			OPTIONS
		*)
		Example[{Options,Prolog,"Prologs are drawn before chart elements, such that they appear behind the pie chart:"},
			EmeraldPieChart[{1,2,3,4},Prolog->{Disk[{.5, .5}, {.55, 0.75}]}],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldPieChart:"},
			EmeraldPieChart[{1,2,3,4},Epilog->{Disk[{.5, .5}, {.55, 0.75}]}],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Adjust the aspect ratio of the graphic. Default is 1.0:"},
			Table[
				EmeraldPieChart[{{3.0,2.0,2.0,4.0}},ImageSize->200,AspectRatio->aspect],
				{aspect,{Automatic,1.5,0.5}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Background,"Set the background color of the plot:"},
			EmeraldPieChart[{1,2,3,4},Background->LightGreen],
			ValidGraphicsP[]
		],

		Example[{Options,DisplayFunction,"Provide the output as a clickable button:"},
			EmeraldPieChart[g7populationData,ImageSize->300,DisplayFunction->(PopupWindow[Button["Click here"], #]&)],
			_Button
		],

		Example[{Options,FrameTicks,"If Frame->True, set FrameTicks->None to disable ticks in the plot. Note that in a PieChart the FrameTicks run from zero to one, and are disabled by default:"},
			{
				EmeraldPieChart[{1,2,3,4},ImageSize->250,Frame->True,FrameTicks->Automatic],
				EmeraldPieChart[{1,2,3,4},ImageSize->250,Frame->True,FrameTicks->None]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,FrameTicksStyle,"Apply styling to all FrameTicks in the plot:"},
			EmeraldPieChart[{1,2,3,4},ImageSize->300,Frame->True,FrameTicks->Automatic,FrameTicksStyle->Directive[Red,Thick,16]],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Apply a different styling to each frame wall, using {{left,right},{bottom,top}} syntax:"},
			EmeraldPieChart[{1,2,3,4},ImageSize->300,Frame->True,FrameTicks->Automatic,FrameTicksStyle->{{Directive[Green,Thick],None},{Directive[Red,Thick],None}}],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Set Frame->True to use a frame on all four sides of the plot:"},
			EmeraldPieChart[{1,2,3,4},Frame->True],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"By default, Frame->None in a PieChart:"},
			EmeraldPieChart[{1,2,3,4}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"The FrameLabel option is disabled for pie charts:"},
			EmeraldPieChart[{1,2,3,4},Frame->True,FrameLabel->{"Bottom Label","Left Label"}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Apply styling to the frame of the plot:"},
			EmeraldPieChart[{1,2,3,4},
				Frame->True,
				FrameStyle->Directive[Red,Dotted]
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Apply different stylings to each frame wall, referenced using {{left,right},{bottom,top}}:"},
			EmeraldPieChart[{1,2,3,4},
				Frame->True,
				FrameStyle->{{Directive[Thick], Directive[Thick, Dashed]}, {Blue, Red}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to specify {vertical,horizontal} gridlines:"},
			EmeraldPieChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Explicitly specify gridlines. By default, the PieChart runs from {-1,1} in both directions:"},
			EmeraldPieChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{{-1,1},{-1,-0.6,-0.5,-0.4,0,0.4,0.5,0.6,1.0}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Specify each gridline as a {value,Directive} pair to apply specific styling to individual grid lines:"},
			EmeraldPieChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,{{-1,Directive[Dashed,Thick,Red]},{0.0,Directive[Blue,Thick]},{1,Directive[Dashed,Thick,Red]}}}
			],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldPieChart[{{1.9,6.2,6.0,2.1}},
				ChartLabels->{"A","B","C","D"},
				GridLines->{None,Automatic},
				GridLinesStyle->Directive[Thick,Red,Dashed]
			],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldPieChart[{1,2,3,4},ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldPieChart[{1,2,3,4},ImageSize->{400,200}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldPieChart[{1,2,3,4},ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Legend,"Specify a legend:"},
			EmeraldPieChart[{1,2,3,4},Legend->{"A","B","C","D"}],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Specify a legend:"},
			EmeraldPieChart[{{1,2,3,4},{3,2,2,5}},Legend->{"A","B","C","D"}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Supply a title with PlotLabel:"},
			EmeraldPieChart[g7populationData,PlotLabel->"Population of Each G7 Nation"],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"The plot range for a pie chart runs from -1 to 1 in both directions, and cannot be changed:"},
			{
				EmeraldPieChart[RandomInteger[30,50],ImageSize->250,Frame->True,FrameTicks->True,PlotRange->Automatic],
				EmeraldPieChart[RandomInteger[30,50],ImageSize->250,Frame->True,FrameTicks->True,PlotRange->{{-0.5,20},{-0.5,0.5}}]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,PlotTheme,"PlotTheme is disabled in Emerald plot functions:"},
			{
				EmeraldPieChart[Permutations[{1,4}],ImageSize->250,PlotTheme->"Default"],
				EmeraldPieChart[Permutations[{1,4}],ImageSize->250,PlotTheme->"Marketing"]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,PolarAxes,"Explicitly set PolarAxes->Automatic to quantitatively show sector angle magnitudes:"},
			EmeraldPieChart[{{1,1,1},{1,2,1,2,1,2}}*Meter,PolarAxes->Automatic],
			ValidGraphicsP[]
		],

		Example[{Options,SectorOrigin,"Specify where sectors should be drawn from and which direction they should be drawn. Default is {\[Pi\],-1}:"},
			{
				EmeraldPieChart[{1,2,3,4},ImageSize->250,ChartLabels->{"First","Second","Third","Fourth"},PlotLabel->"Default"],
				EmeraldPieChart[{1,2,3,4},ImageSize->250,ChartLabels->{"First","Second","Third","Fourth"},SectorOrigin->{Pi,"Counterclockwise"},PlotLabel->"Reversed Direction"]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,SectorOrigin,"Use different starting positions for the pie chart:"},
			Table[
				EmeraldPieChart[{1,2,3,4},ImageSize->200,ChartLabels->{"First","Second","Third","Fourth"},SectorOrigin->{start,"Clockwise"}],
				{start,{0,Pi/3,2*Pi/3,Pi,4*Pi/3,5*Pi/3}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,SectorSpacing,"Define the spacing between datasets when multiple datasets are plotted in the same pie chart:"},
			Table[
				EmeraldPieChart[{{1,3,4},{3,3,2}},ImageSize->200,SectorSpacing->sp,PlotLabel->sp],
				{sp,{None,Tiny,Small,Medium,Large}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,SectorSpacing,"Define the spacing between sectors for a pie chart showing a single dataset. Default is None:"},
			Table[
				EmeraldPieChart[{1,3,4},ImageSize->200,SectorSpacing->{sp,Automatic},PlotLabel->sp],
				{sp,{None,Tiny,Small,Medium,Large}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,SectorSpacing,"Use explicit numbers to define spacings between {sectors,datasets}:"},
			Table[
				EmeraldPieChart[{{1,3,4},{2,2,2}},ImageSize->200,SectorSpacing->sp,PlotLabel->ToString[sp]],
				{sp,{Automatic,{0.05,0.2},{0.1,0.5}}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,TargetUnits,"Set the units that the chart tooltips should be converted to. Compatible units must be provided:"},
			Table[
				EmeraldPieChart[{1 Foot,1 Yard,1 Meter},ImageSize->250,ChartLabels->{"1 Foot","1 Yard","1 Meter"},TargetUnits->un],
				{un,{Foot,Yard,Meter}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Boxes,"Use swatch boxes in legend:"},
			EmeraldPieChart[Range[3],Legend->{"A","B","C"},Boxes->True],
			Legended[ValidGraphicsP[],{Placed[_SwatchLegend,___]}]
		],
		Example[{Options,Boxes,"Use line segments in legend instead of swatch boxes:"},
			EmeraldPieChart[Range[3],Legend->{"A","B","C"},Boxes->False],
			Legended[ValidGraphicsP[],{Placed[_LineLegend,___]}]
		],

		Example[{Options,ChartBaseStyle,"Use ChartBaseStyle to sector styling:"},
			Table[
				EmeraldPieChart[{1,2,3},ImageSize->300,ChartBaseStyle->s],
				{s,{EdgeForm[Dashed],EdgeForm[Thick]}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,ChartBaseStyle,"ChartStyle overrides settings for ChartBaseStyle:"},
			{
				EmeraldPieChart[{1,2,3},ImageSize->300,ChartBaseStyle->{Opacity[0.5],EdgeForm[Dashed]}],
				EmeraldPieChart[{1,2,3},ImageSize->300,ChartBaseStyle->{Opacity[0.5],EdgeForm[Dashed]},ChartStyle->EdgeForm[None]]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,ChartBaseStyle,"ColorFunction may override settings for ChartBaseStyle:"},
			{
				EmeraldPieChart[{1,2,3},ImageSize->300,ChartBaseStyle->{Opacity[0.5],EdgeForm[Dashed]}],
				EmeraldPieChart[{1,2,3},ImageSize->300,ChartBaseStyle->{Opacity[0.5],EdgeForm[Dashed]},ColorFunction->(EdgeForm[None]&)]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,ChartElementFunction,"Use a named, preset chart element function (To see all options, please run ChartElementData[\"PieChart\"] in the notebook):"},
			Table[
				EmeraldPieChart[{1,2,3,4,5},ImageSize->200,ChartElementFunction->f,PlotLabel->f],
				{f,ChartElementData["PieChart"]}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,ChartElementFunction,"Write a custom chart element function for PieChart:"},
			g[{{t0_,t1_},{r0_,r1_}},___]:=GraphicsGroup[{
				Circle[{0, 0}, r0, {t0, t1}],
				Circle[{0, 0}, r1, {t0, t1}],
				Line[{r0 {Cos[t0], Sin[t0]},r1 {Cos[t1], Sin[t1]}}]
			}];
			EmeraldPieChart[{1,2,3,4,5},ImageSize->300,ChartBaseStyle->Thick,ChartElementFunction->g],
			ValidGraphicsP[]
		],
		Example[{Options,ChartElementFunction,"Built-in element functions may have options; use Palettes \[FilledRightTriangle] ChartElementSchemes to set them:"},
			Table[
				EmeraldPieChart[{1,2,3},
					ImageSize->250,
					ChartElementFunction->ChartElementData["GradientSector",
						"ColorScheme"->"DeepSeaColors",
						"GradientDirection" -> dir
					],
					PlotLabel->dir
				],
				{dir,{"Angular","Radial","DescendingAngular","DescendingRadial"}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ChartLabels,"Add labels to each sector in the pie chart:"},
			EmeraldPieChart[g7populationData,
				PlotLabel->"Population of Each G7 Nation",
				ChartLabels->g7names
			],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLabels,"When multiple datasets are provided, ChartLabels 'rows' correspond to datasets, and 'columns' correspond to single entries:"},
			EmeraldPieChart[{{1,2,3},{4,5,6}},ChartLabels->{{"r1","r2"},{"c1","c2","c3"}}],
			ValidGraphicsP[]
		],

		Example[{Options,ChartLayout,"ChartLayout determines how multiple datasets are plotted, and can be set to either \"Grouped\" (default) or \"Stacked\":"},
			Table[
				EmeraldPieChart[{{1,2,3},{4,1,2}},ImageSize->250,ChartLayout->layout,PlotLabel->layout],
				{layout,{"Grouped","Stacked"}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ChartStyle,"Pass a single argument to ChartStyle to style all sectors the same way:"},
			EmeraldPieChart[RandomInteger[{1, 10}, 5],ChartStyle->Darker[Red]],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style the chart using a named color scheme from ColorData[]:"},
			EmeraldPieChart[RandomInteger[{1, 10}, 5],ChartStyle->"Pastel"],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of colors to ChartStyle to apply different styles to each sector in each group:"},
			EmeraldPieChart[{RandomInteger[{1, 10}, 5],RandomInteger[{1, 10}, 5]},ChartStyle->{Red,Blue,Green,Yellow,Purple}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Pass a list of style directives to ChartStyle to apply different styles to each sector in each group:"},
			EmeraldPieChart[{RandomInteger[{1, 10}, 5],RandomInteger[{1, 10}, 5]},ChartStyle->{Red,Directive[Blue,EdgeForm[Dotted]],Directive[Green,EdgeForm[Thick]],Directive[Yellow,EdgeForm[Dashed]],Directive[Purple,Opacity[0.5]]}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group the same way:"},
			EmeraldPieChart[{RandomInteger[{1, 10}, 3], RandomInteger[{1, 10}, 3]},ChartStyle->{{Red,Green},None}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Style each group and each series of sector in each input dataset, in the format { {in1, in2,..}, {sec1,sec2,sec3,..}}:"},
			EmeraldPieChart[{RandomInteger[{1, 10}, 3], RandomInteger[{1, 10}, 3]},ChartStyle->{{EdgeForm[Dotted],EdgeForm[Dashed]},{Red,Green,Blue}}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartStyle,"Use indexed colors for charting. Run ColorData[\"Charting\"] to see possible index values:"},
			Table[
				EmeraldPieChart[RandomInteger[{1, 3}, 10],
					ChartStyle->idx,
					ImageSize->250,
					PlotLabel->ColorData[idx,"PrivateStandardNames"][[1,2]]
				],
				{idx,44,62,5}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,ColorFunction,"Apply a named color function to color sectors by angle:"},
			EmeraldPieChart[Table[Exp[-t^2],{t,-2,2,0.25}],ColorFunction->"Rainbow"],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunction,"Supply a pure function to style each sector with an opacity equal to its angle:"},
			EmeraldPieChart[Table[Exp[-t^2],{t,-2,2,0.25}],ChartStyle->Purple,ColorFunction->Function[{angle},Opacity[angle]]],
			ValidGraphicsP[]
		],
		Example[{Options,ColorFunction,"ColorFunction overrides ChartStyle:"},
			{
				EmeraldPieChart[{1,2,3},ImageSize->250,ChartStyle->{Red,Blue,Green}],
				EmeraldPieChart[{1,2,3},ImageSize->250,ChartStyle->{Red,Blue,Green},ColorFunction->"Rainbow"]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,ColorFunctionScaling,"By default, the color function takes scaled sector angles (i.e. angle/2*pi). Set ColorFunctionScaling->False to receive absolute sector angles:"},
			{
				EmeraldPieChart[Range[25],ImageSize->250,ColorFunction->Function[{y},ColorData[2][y]],PlotLabel->"Scaled Sector Angles"],
				EmeraldPieChart[Range[25],ImageSize->250,ColorFunction->Function[{y},ColorData[2][y]],PlotLabel->"Unscaled Sector Angles",ColorFunctionScaling->False]
			},
			{ValidGraphicsP[]..}
		],

		Example[{Options,LabelingFunction,"By default, each sector in the pie chart is labeled with a tooltip which shows its magnitude:"},
			EmeraldPieChart[{1,2,3},LabelingFunction->Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Set LabelingFunction->None to disable tooltips:"},
			EmeraldPieChart[{1,2,3},LabelingFunction->None],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Change the LabelingFunction to a named default to get different labels:"},
			Table[
				EmeraldPieChart[{1,2,3},ImageSize->250,LabelingFunction->lf],
				{lf,{Automatic,"RadialOutside","RadialEdge","RadialCallout","VerticalCallout"}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,LabelingFunction,"Change the LabelingFunction to a named default to get different labels for multi-dataset plots:"},
			Table[
				EmeraldPieChart[{{1,2,3},{4,5,6}},ImageSize->250,LabelingFunction->lf],
				{lf,{Automatic,"RadialOutside","RadialEdge","RadialCallout","VerticalCallout"}}
			],
			{ValidGraphicsP[]..}
		],
		Example[{Options,LabelingFunction,"Use a pure function to programatically generate labels for the elements. The function input is the individual sector magnitude:"},
			EmeraldPieChart[RandomReal[{1,10},5],LabelingFunction->(Callout[Row[{"$",NumberForm[#,{2,2}]}],Automatic]&)],
			ValidGraphicsP[]
		],

		Example[{Options,LabelStyle,"Adjust the font size, font color, formatting, and font type of all label-like elements in the chart:"},
			EmeraldPieChart[g7populationData,
				PlotLabel->"Population of Each G7 Nation",
				ChartLabels->g7names,
				Frame->True,
				FrameTicks->True,
				LabelStyle->{18.`,Purple,Italic,FontFamily->"Helvetica"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,LegendAppearance,"Specify they layout of the chart legend:"},
			{
				EmeraldPieChart[{1,2,3,4},ImageSize->300,Legend->{"A","B","C","D"},LegendAppearance->"Row"],
				EmeraldPieChart[{1,2,3,4},ImageSize->300,Legend->{"A","B","C","D"},LegendAppearance->"Column"]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldPieChart[{1,2,3,4},ImageSize->300,Legend->{"A","B","C","D"},LegendPlacement->Top],
				EmeraldPieChart[{1,2,3,4},ImageSize->300,Legend->{"A","B","C","D"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,ChartLegends,"Label the bars (columns):"},
			EmeraldPieChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {"c1", "c2", "c3"}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLegends,"Label the datasets (rows):"},
			EmeraldPieChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {{"r1", "r2"},None}],
			ValidGraphicsP[]
		],
		Example[{Options,ChartLegends,"Label the rows and columns of the data:"},
			EmeraldPieChart[{{1, 2, 3}, {4, 1}}, ChartLabels -> {{"r1", "r2"}, {"c1", "c2", "c3"}}],
			ValidGraphicsP[]
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"IncompatibleUnits","Incompatible units within a data set:"},
			EmeraldPieChart[{1*Meter,2*Foot,3*Second}],
			$Failed,
			Messages:>{EmeraldPieChart::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units across data sets:"},
			EmeraldPieChart[{{1,2,3}*Meter,{2,4,5}*Second}],
			$Failed,
			Messages:>{EmeraldPieChart::IncompatibleUnits}
		],

		(*
			ISSUES
		*)
		Example[{Issues,"Null values","Null, zero, and negative values are all treated the same way and do not get pie slices:"},
			{
					EmeraldPieChart[{1,0,3}],
					EmeraldPieChart[{1,Null,3}],
					EmeraldPieChart[{1,-5,3}]
			},
			{ValidGraphicsP[],ValidGraphicsP[],ValidGraphicsP[]}
		]


		(*
			TESTS
		*)


	},

	(*** Test Setup ***)
	Variables:>{
		g7populationData,g7names
	},
	SetUp:>(
		g7populationData={Tooltip[Quantity[37411038, "People"],
  Graphics[{Thickness[0.00125],
    {FaceForm[{RGBColor[1., 0., 0.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 0.}, {0., 400.}, {800., 400.}, {800., 0.}}}]},
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{200., 400.}, {600., 400.}, {600., 0.}, {200., 0.}}}]},
    {FaceForm[{RGBColor[1., 0., 0.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {1, 3, 3}, {0, 1, 0}, {0, 1, 0}, {1, 3, 3},
        {0, 1, 0}, {0, 1, 0}, {1, 3, 3}, {0, 1, 0}, {0, 1, 0}, {1, 3, 3},
        {0, 1, 0}, {0, 1, 0}, {1, 3, 3}, {0, 1, 0}, {1, 3, 3}, {1, 3, 3},
        {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {1, 3, 3}, {1, 3, 3}, {0, 1, 0},
        {1, 3, 3}, {0, 1, 0}, {0, 1, 0}, {1, 3, 3}, {0, 1, 0}, {0, 1, 0},
        {1, 3, 3}, {0, 1, 0}, {0, 1, 0}, {1, 3, 3}, {0, 1, 0}, {0, 1, 0},
        {1, 3, 3}}}, {{{399.99199999999996, 362.5},
        {372.703, 311.60200000000003}, {369.605, 306.066},
        {364.059, 306.582}, {358.512, 309.672}, {338.754, 319.902},
        {353.477, 241.71899999999997}, {356.574, 227.43800000000002},
        {346.641, 227.43800000000002}, {341.734, 233.61299999999997},
        {307.254, 272.215}, {301.656, 252.60899999999998},
        {301.012, 250.035}, {298.172, 247.33200000000002},
        {293.914, 247.977}, {250.312, 257.14500000000004},
        {261.76599999999996, 215.508}, {264.219, 206.242},
        {266.129, 202.406}, {259.289, 199.965}, {243.75, 192.66},
        {318.809, 131.695}, {321.777, 129.38700000000003},
        {323.277, 125.238}, {322.22299999999996, 121.48400000000001},
        {315.65200000000004, 99.926}, {341.4959999999999, 102.906},
        {364.65200000000004, 107.387}, {390.508, 110.148},
        {392.789, 110.391}, {396.613, 106.62499999999999},
        {396.59799999999996, 103.98}, {393.172, 25.},
        {405.73799999999994, 25.}, {403.758, 103.809}, {403.742, 106.453},
        {407.21099999999996, 110.391}, {409.49199999999996, 110.148},
        {435.348, 107.387}, {458.504, 102.906}, {484.348, 99.926},
        {477.777, 121.48400000000001}, {476.72299999999996, 125.238},
        {478.22299999999996, 129.38700000000003}, {481.191, 131.695},
        {556.25, 192.66}, {540.711, 199.965}, {533.871, 202.406},
        {535.7810000000001, 206.242}, {538.234, 215.508},
        {549.6880000000001, 257.14500000000004}, {506.08599999999996,
         247.977}, {501.828, 247.33200000000002}, {498.98799999999994,
         250.035}, {498.34400000000005, 252.60899999999998},
        {492.746, 272.215}, {458.26599999999996, 233.61299999999997},
        {453.35900000000004, 227.43800000000002}, {443.42599999999993,
         227.43800000000002}, {446.52299999999997, 241.71899999999997},
        {461.246, 319.902}, {441.48799999999994, 309.672},
        {435.941, 306.582}, {430.395, 306.066}, {427.29699999999997,
         311.60200000000003}}}]}}, {ImageSize -> {{128}, {85}},
    AspectRatio -> Automatic, ImageSize -> {481., 241.},
    PlotRange -> {{0., 800.}, {0., 400.}}}]],
 Tooltip[Quantity[65129731, "People"],
  Graphics[{Thickness[0.001388888888888889],
    {FaceForm[{RGBColor[0.9294119999999999, 0.160784, 0.223529],
       Opacity[1.]}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 0.}, {0., 480.}, {720., 480.}, {720., 0.}}}]},
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 480.}, {480., 480.}, {480., 0.}, {0., 0.}}}]},
    {FaceForm[{RGBColor[0., 0.13725500000000002, 0.5843139999999999],
       Opacity[1.]}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 480.}, {240., 480.}, {240., 0.}, {0., 0.}}}]}},
   {ImageSize -> {{128}, {85}}, AspectRatio -> Automatic,
    ImageSize -> {501., 336.}, PlotRange -> {{0., 720.}, {0., 480.}}}]],
 Tooltip[Quantity[83517046, "People"],
  Graphics[{Thickness[0.00125], {Thickness[0.00125],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 0.}, {0., 480.}, {800., 480.}, {800., 0.}}}]},
    {FaceForm[{RGBColor[0.8666670000000001, 0., 0.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 320.}, {800., 320.}, {800., 0.}, {0., 0.}}}]},
    {FaceForm[{RGBColor[1., 0.8078430000000001, 0.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 160.}, {800., 160.}, {800., 0.}, {0., 0.}}}]}},
   {ImageSize -> {{128}, {85}}, AspectRatio -> Automatic,
    ImageSize -> {500., 300.}, PlotRange -> {{0., 800.}, {0., 480.}}}]],
 Tooltip[Quantity[60550092, "People"],
  Graphics[{Thickness[0.0008333333333333334],
    {FaceForm[{RGBColor[0., 0.5725490000000001, 0.27451000000000003],
       Opacity[1.]}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 800.}, {400., 800.}, {400., 0.}, {0., 0.}}}]},
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{400., 800.}, {800., 800.}, {800., 0.}, {400., 0.}}}]},
    {FaceForm[{RGBColor[0.8078430000000001, 0.168627,
        0.21568600000000002], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{800., 800.}, {1200., 800.}, {1200., 0.}, {800., 0.}}}]}},
   {ImageSize -> {{128}, {85}}, AspectRatio -> Automatic,
    ImageSize -> {478.5, 319.}, PlotRange -> {{0., 1200.}, {0., 800.}}}]],
 Tooltip[Quantity[126860299, "People"],
  Graphics[{Thickness[0.001388888888888889],
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 0.}, {0., 480.}, {720., 480.}, {720., 0.}}}]},
    {FaceForm[{RGBColor[0.737255, 0., 0.17647100000000002], Opacity[1.]}],
     FilledCurve[{{{1, 4, 3}, {1, 3, 3}, {1, 3, 3}, {1, 3, 3}}},
      {{{504., 240.}, {504., 160.47299999999998}, {439.527, 96.},
        {360., 96.}, {280.47299999999996, 96.},
        {216., 160.47299999999998}, {216., 240.}, {216., 319.527},
        {280.47299999999996, 384.}, {360., 384.}, {439.527, 384.},
        {504., 319.527}, {504., 240.}}}]}}, {ImageSize -> {{128}, {85}},
    AspectRatio -> Automatic, ImageSize -> {480., 319.},
    PlotRange -> {{0., 720.}, {0., 480.}}}]],
 Tooltip[Quantity[67530161, "People"],
  Graphics[{{RGBColor[0., 0.141176, 0.49019599999999997],
     Polygon[{{0, 201}, {400, 201}, {400, 401}, {0, 401}}]},
    {{Thickness[0.00125], {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
       FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0},
          {0, 1, 0}}, {{0, 2, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0},
          {0, 1, 0}}}, {{{0., 401.}, {0., 378.641}, {355.277, 201.},
          {400., 201.}, {400., 223.359}, {44.723000000000006, 401.}},
         {{400., 401.}, {400., 378.641}, {44.723000000000006, 201.},
          {0., 201.}, {0., 223.363}, {355.277, 401.}}}]},
      {FaceForm[{RGBColor[0.8117650000000001, 0.07843140000000001,
          0.168627], Opacity[1.]}], FilledCurve[
        {{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}, {{0, 2, 0}, {0, 1, 0},
          {0, 1, 0}}, {{0, 2, 0}, {0, 1, 0}, {0, 1, 0}},
         {{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
        {{{0., 201.}, {133.33200000000002, 267.668}, {163.148, 267.668},
          {29.812, 201.}}, {{0., 401.}, {133.33200000000002, 334.332},
          {103.52, 334.332}, {0., 386.094}}, {{236.85200000000003,
           334.332}, {370.188, 401.}, {400., 401.}, {266.668, 334.332}},
         {{400., 201.}, {266.668, 267.668}, {296.47999999999996, 267.668},
          {400., 215.906}}}]}}, {{RGBColor[1., 1., 1.],
       Polygon[{{{166.668, 401.}, {166.668, 201.}, {233.33200000000002,
           201.}, {233.33200000000002, 401.}}, {{0., 334.332},
          {0., 267.668}, {400., 267.668}, {400., 334.332}}}]},
      {RGBColor[0.8117650000000001, 0.07843140000000001, 0.168627],
       Polygon[{{{0., 321.}, {0., 281.}, {400., 281.}, {400., 321.}},
         {{180., 401.}, {180., 201.}, {220., 201.}, {220., 401.}}}]}}}},
   {ImageSize -> {{128}, {85}}, ImageSize -> {441., Automatic},
    PlotRange -> {{0, 400}, {201, 401}}}]],
 Tooltip[Quantity[329064917, "People"],
  Graphics[{Thickness[0.0010121457489878543],
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 0.}, {0., 520.}, {988., 520.}, {988., 0.}}}]},
    {FaceForm[{RGBColor[0.698039, 0.133333, 0.20392200000000002],
       Opacity[1.]}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 520.}, {988., 520.}, {988., 480.}, {0., 480.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 440.}, {988., 440.}, {988., 400.}, {0., 400.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 360.}, {988., 360.}, {988., 320.}, {0., 320.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 280.}, {988., 280.}, {988., 240.}, {0., 240.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 200.}, {988., 200.}, {988., 160.}, {0., 160.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 120.}, {988., 120.}, {988., 80.}, {0., 80.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 40.}, {988., 40.}, {988., 0.}, {0., 0.}}}]},
    {FaceForm[{RGBColor[0.23529400000000003, 0.231373,
        0.43137300000000006], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}}},
      {{{0., 520.}, {395.199, 520.}, {395.199, 240.}, {0., 240.}}}]},
    {FaceForm[{RGBColor[1., 1., 1.], Opacity[1.]}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 489.262}, {24.387, 479.363}, {29.59, 495.379}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 487.371}, {18.566, 497.27}, {35.406, 497.27}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{28.598, 492.32}, {33.800999999999995, 508.33599999999996},
        {39.004, 492.32}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 497.27}, {49.031, 497.27}, {35.406, 487.371}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 495.379}, {43.215, 479.363}, {29.59, 489.262}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 489.262}, {89.906, 479.363}, {95.109, 495.379}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 487.371}, {84.086, 497.27},
        {100.93, 497.27}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{94.117, 492.32}, {99.32, 508.33599999999996},
        {104.523, 492.32}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 497.27}, {114.551, 497.27},
        {100.93, 487.371}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 495.379}, {108.73400000000001, 479.363},
        {95.109, 489.262}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 489.262}, {155.42600000000002, 479.363},
        {160.629, 495.379}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 487.371}, {149.60899999999998, 497.27},
        {166.44899999999998, 497.27}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{159.637, 492.32},
        {164.84, 508.33599999999996}, {170.04299999999998, 492.32}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 497.27}, {180.07, 497.27}, {166.44899999999998,
         487.371}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 495.379}, {174.254, 479.363},
        {160.629, 489.262}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{234.57, 489.262}, {220.945, 479.363}, {226.148, 495.379}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 487.371}, {215.129, 497.27}, {231.969, 497.27}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{225.156, 492.32}, {230.359, 508.33599999999996},
        {235.562, 492.32}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 497.27}, {245.594, 497.27}, {231.969, 487.371}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{234.57, 495.379}, {239.77299999999997, 479.363},
        {226.148, 489.262}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 489.262}, {286.465, 479.363}, {291.672, 495.379}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 487.371}, {280.648, 497.27},
        {297.48799999999994, 497.27}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{290.676, 492.32},
        {295.879, 508.33599999999996}, {301.082, 492.32}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 497.27}, {311.113, 497.27},
        {297.48799999999994, 487.371}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{300.09, 495.379}, {305.29299999999995,
         479.363}, {291.672, 489.262}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{365.60900000000004, 489.262},
        {351.984, 479.363}, {357.191, 495.379}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 487.371}, {346.168, 497.27},
        {363.008, 497.27}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{356.195, 492.32}, {361.39799999999997, 508.33599999999996},
        {366.605, 492.32}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 497.27}, {376.633, 497.27},
        {363.008, 487.371}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 495.379}, {370.812, 479.363},
        {357.191, 489.262}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{70.77, 461.18}, {57.145, 451.28099999999995},
        {62.352, 467.29699999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{64.953, 459.289}, {51.328, 469.188},
        {68.16799999999999, 469.188}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{61.355, 464.23799999999994},
        {66.559, 480.258}, {71.766, 464.23799999999994}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{64.953, 469.188}, {81.793, 469.188}, {68.16799999999999,
         459.289}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{70.77, 467.29699999999997}, {75.973, 451.28099999999995},
        {62.352, 461.18}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 461.18}, {122.66799999999999, 451.28099999999995},
        {127.871, 467.29699999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{130.47299999999998, 459.289},
        {116.848, 469.188}, {133.68800000000002, 469.188}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{126.87499999999999, 464.23799999999994}, {132.078, 480.258},
        {137.285, 464.23799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{130.47299999999998, 469.188},
        {147.312, 469.188}, {133.68800000000002, 459.289}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 467.29699999999997}, {141.49200000000002,
         451.28099999999995}, {127.871, 461.18}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 461.18}, {188.18800000000002, 451.28099999999995},
        {193.39100000000002, 467.29699999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{195.99200000000002, 459.289}, {182.36700000000002, 469.188},
        {199.207, 469.188}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{192.395, 464.23799999999994}, {197.602, 480.258},
        {202.805, 464.23799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{195.99200000000002, 469.188},
        {212.83200000000002, 469.188}, {199.207, 459.289}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 467.29699999999997}, {207.016, 451.28099999999995},
        {193.39100000000002, 461.18}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{267.328, 461.18},
        {253.707, 451.28099999999995}, {258.90999999999997,
         467.29699999999997}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 459.289}, {247.88700000000003, 469.188},
        {264.727, 469.188}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{257.91799999999995, 464.23799999999994}, {263.121, 480.258},
        {268.324, 464.23799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{261.512, 469.188},
        {278.35200000000003, 469.188}, {264.727, 459.289}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 467.29699999999997}, {272.53499999999997,
         451.28099999999995}, {258.90999999999997, 461.18}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 461.18}, {319.227, 451.28099999999995},
        {324.42999999999995, 467.29699999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 459.289}, {313.40599999999995, 469.188},
        {330.25, 469.188}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{323.43799999999993, 464.23799999999994}, {328.641, 480.258},
        {333.84400000000005, 464.23799999999994}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 469.188}, {343.871, 469.188},
        {330.25, 459.289}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 467.29699999999997},
        {338.055, 451.28099999999995}, {324.42999999999995, 461.18}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 433.10200000000003}, {24.387, 423.203},
        {29.59, 439.219}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 431.21099999999996}, {18.566, 441.10900000000004},
        {35.406, 441.10900000000004}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{28.598, 436.16}, {33.800999999999995,
         452.176}, {39.004, 436.16}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{32.191, 441.10900000000004},
        {49.031, 441.10900000000004}, {35.406, 431.21099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 439.219}, {43.215, 423.203},
        {29.59, 433.10200000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{103.531, 433.10200000000003},
        {89.906, 423.203}, {95.109, 439.219}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 431.21099999999996},
        {84.086, 441.10900000000004}, {100.93, 441.10900000000004}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{94.117, 436.16}, {99.32, 452.176}, {104.523, 436.16}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 441.10900000000004},
        {114.551, 441.10900000000004}, {100.93, 431.21099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 439.219}, {108.73400000000001, 423.203},
        {95.109, 433.10200000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 433.10200000000003}, {155.42600000000002,
         423.203}, {160.629, 439.219}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{163.23, 431.21099999999996},
        {149.60899999999998, 441.10900000000004}, {166.44899999999998,
         441.10900000000004}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{159.637, 436.16}, {164.84, 452.176}, {170.04299999999998,
         436.16}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 441.10900000000004}, {180.07, 441.10900000000004},
        {166.44899999999998, 431.21099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 439.219}, {174.254, 423.203},
        {160.629, 433.10200000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{234.57, 433.10200000000003},
        {220.945, 423.203}, {226.148, 439.219}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 431.21099999999996}, {215.129, 441.10900000000004},
        {231.969, 441.10900000000004}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{225.156, 436.16}, {230.359, 452.176},
        {235.562, 436.16}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 441.10900000000004}, {245.594, 441.10900000000004},
        {231.969, 431.21099999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{234.57, 439.219}, {239.77299999999997,
         423.203}, {226.148, 433.10200000000003}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 433.10200000000003}, {286.465, 423.203},
        {291.672, 439.219}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 431.21099999999996},
        {280.648, 441.10900000000004}, {297.48799999999994,
         441.10900000000004}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{290.676, 436.16}, {295.879, 452.176}, {301.082, 436.16}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 441.10900000000004},
        {311.113, 441.10900000000004}, {297.48799999999994,
         431.21099999999996}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 439.219}, {305.29299999999995, 423.203},
        {291.672, 433.10200000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 433.10200000000003}, {351.984, 423.203},
        {357.191, 439.219}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 431.21099999999996},
        {346.168, 441.10900000000004}, {363.008, 441.10900000000004}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{356.195, 436.16}, {361.39799999999997, 452.176},
        {366.605, 436.16}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 441.10900000000004},
        {376.633, 441.10900000000004}, {363.008, 431.21099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 439.219}, {370.812, 423.203},
        {357.191, 433.10200000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{70.77, 405.02}, {57.145, 395.121},
        {62.352, 411.141}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{64.953, 403.129}, {51.328, 413.027}, {68.16799999999999,
         413.027}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{61.355, 408.078}, {66.559, 424.09799999999996},
        {71.766, 408.078}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{64.953, 413.027}, {81.793, 413.027}, {68.16799999999999,
         403.129}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{70.77, 411.141}, {75.973, 395.121}, {62.352, 405.02}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 405.02}, {122.66799999999999, 395.121},
        {127.871, 411.141}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 403.129}, {116.848, 413.027},
        {133.68800000000002, 413.027}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{126.87499999999999, 408.078},
        {132.078, 424.09799999999996}, {137.285, 408.078}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 413.027}, {147.312, 413.027},
        {133.68800000000002, 403.129}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{136.289, 411.141},
        {141.49200000000002, 395.121}, {127.871, 405.02}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 405.02}, {188.18800000000002, 395.121},
        {193.39100000000002, 411.141}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{195.99200000000002, 403.129},
        {182.36700000000002, 413.027}, {199.207, 413.027}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{192.395, 408.078}, {197.602, 424.09799999999996},
        {202.805, 408.078}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{195.99200000000002, 413.027}, {212.83200000000002, 413.027},
        {199.207, 403.129}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 411.141}, {207.016, 395.121}, {193.39100000000002,
         405.02}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 405.02}, {253.707, 395.121}, {258.90999999999997,
         411.141}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 403.129}, {247.88700000000003, 413.027},
        {264.727, 413.027}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{257.91799999999995, 408.078}, {263.121, 424.09799999999996},
        {268.324, 408.078}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 413.027}, {278.35200000000003, 413.027},
        {264.727, 403.129}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 411.141}, {272.53499999999997, 395.121},
        {258.90999999999997, 405.02}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{332.85200000000003, 405.02},
        {319.227, 395.121}, {324.42999999999995, 411.141}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 403.129}, {313.40599999999995, 413.027},
        {330.25, 413.027}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{323.43799999999993, 408.078}, {328.641, 424.09799999999996},
        {333.84400000000005, 408.078}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{327.03099999999995, 413.027},
        {343.871, 413.027}, {330.25, 403.129}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 411.141}, {338.055, 395.121},
        {324.42999999999995, 405.02}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{38.012, 376.941}, {24.387, 367.043},
        {29.59, 383.059}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 375.051}, {18.566, 384.949}, {35.406, 384.949}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{28.598, 380.}, {33.800999999999995, 396.01599999999996},
        {39.004, 380.}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 384.949}, {49.031, 384.949}, {35.406, 375.051}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 383.059}, {43.215, 367.043}, {29.59, 376.941}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 376.941}, {89.906, 367.043}, {95.109, 383.059}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 375.051}, {84.086, 384.949},
        {100.93, 384.949}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{94.117, 380.}, {99.32, 396.01599999999996}, {104.523, 380.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 384.949}, {114.551, 384.949},
        {100.93, 375.051}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 383.059}, {108.73400000000001, 367.043},
        {95.109, 376.941}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 376.941}, {155.42600000000002, 367.043},
        {160.629, 383.059}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 375.051}, {149.60899999999998, 384.949},
        {166.44899999999998, 384.949}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{159.637, 380.},
        {164.84, 396.01599999999996}, {170.04299999999998, 380.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 384.949}, {180.07, 384.949}, {166.44899999999998,
         375.051}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 383.059}, {174.254, 367.043},
        {160.629, 376.941}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{234.57, 376.941}, {220.945, 367.043}, {226.148, 383.059}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 375.051}, {215.129, 384.949}, {231.969, 384.949}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{225.156, 380.}, {230.359, 396.01599999999996},
        {235.562, 380.}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 384.949}, {245.594, 384.949}, {231.969, 375.051}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{234.57, 383.059}, {239.77299999999997, 367.043},
        {226.148, 376.941}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 376.941}, {286.465, 367.043}, {291.672, 383.059}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 375.051}, {280.648, 384.949},
        {297.48799999999994, 384.949}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{290.676, 380.},
        {295.879, 396.01599999999996}, {301.082, 380.}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 384.949}, {311.113, 384.949},
        {297.48799999999994, 375.051}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{300.09, 383.059}, {305.29299999999995,
         367.043}, {291.672, 376.941}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{365.60900000000004, 376.941},
        {351.984, 367.043}, {357.191, 383.059}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 375.051}, {346.168, 384.949},
        {363.008, 384.949}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{356.195, 380.}, {361.39799999999997, 396.01599999999996},
        {366.605, 380.}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 384.949}, {376.633, 384.949},
        {363.008, 375.051}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 383.059}, {370.812, 367.043},
        {357.191, 376.941}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{70.77, 348.85900000000004}, {57.145, 338.96099999999996},
        {62.352, 354.97999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{64.953, 346.97299999999996},
        {51.328, 356.871}, {68.16799999999999, 356.871}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{61.355, 351.92199999999997}, {66.559, 367.93799999999993},
        {71.766, 351.92199999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{64.953, 356.871}, {81.793, 356.871},
        {68.16799999999999, 346.97299999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{70.77, 354.97999999999996}, {75.973, 338.96099999999996},
        {62.352, 348.85900000000004}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{136.289, 348.85900000000004},
        {122.66799999999999, 338.96099999999996},
        {127.871, 354.97999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 346.97299999999996}, {116.848, 356.871},
        {133.68800000000002, 356.871}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{126.87499999999999, 351.92199999999997},
        {132.078, 367.93799999999993}, {137.285, 351.92199999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 356.871}, {147.312, 356.871},
        {133.68800000000002, 346.97299999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 354.97999999999996}, {141.49200000000002,
         338.96099999999996}, {127.871, 348.85900000000004}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 348.85900000000004}, {188.18800000000002,
         338.96099999999996}, {193.39100000000002, 354.97999999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{195.99200000000002, 346.97299999999996}, {182.36700000000002,
         356.871}, {199.207, 356.871}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{192.395, 351.92199999999997},
        {197.602, 367.93799999999993}, {202.805, 351.92199999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{195.99200000000002, 356.871}, {212.83200000000002, 356.871},
        {199.207, 346.97299999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{201.809, 354.97999999999996},
        {207.016, 338.96099999999996}, {193.39100000000002,
         348.85900000000004}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 348.85900000000004}, {253.707, 338.96099999999996},
        {258.90999999999997, 354.97999999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 346.97299999999996}, {247.88700000000003, 356.871},
        {264.727, 356.871}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{257.91799999999995, 351.92199999999997},
        {263.121, 367.93799999999993}, {268.324, 351.92199999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 356.871}, {278.35200000000003, 356.871},
        {264.727, 346.97299999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{267.328, 354.97999999999996},
        {272.53499999999997, 338.96099999999996}, {258.90999999999997,
         348.85900000000004}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 348.85900000000004},
        {319.227, 338.96099999999996}, {324.42999999999995,
         354.97999999999996}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 346.97299999999996}, {313.40599999999995,
         356.871}, {330.25, 356.871}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{323.43799999999993, 351.92199999999997},
        {328.641, 367.93799999999993}, {333.84400000000005,
         351.92199999999997}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 356.871}, {343.871, 356.871},
        {330.25, 346.97299999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 354.97999999999996},
        {338.055, 338.96099999999996}, {324.42999999999995,
         348.85900000000004}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{38.012, 320.78099999999995}, {24.387, 310.883},
        {29.59, 326.89799999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{32.191, 318.89099999999996},
        {18.566, 328.789}, {35.406, 328.789}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{28.598, 323.84000000000003}, {33.800999999999995, 339.855},
        {39.004, 323.84000000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{32.191, 328.789}, {49.031, 328.789},
        {35.406, 318.89099999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{38.012, 326.89799999999997},
        {43.215, 310.883}, {29.59, 320.78099999999995}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 320.78099999999995}, {89.906, 310.883},
        {95.109, 326.89799999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{97.71100000000001, 318.89099999999996},
        {84.086, 328.789}, {100.93, 328.789}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{94.117, 323.84000000000003}, {99.32, 339.855},
        {104.523, 323.84000000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{97.71100000000001, 328.789},
        {114.551, 328.789}, {100.93, 318.89099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 326.89799999999997}, {108.73400000000001, 310.883},
        {95.109, 320.78099999999995}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 320.78099999999995}, {155.42600000000002,
         310.883}, {160.629, 326.89799999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 318.89099999999996}, {149.60899999999998, 328.789},
        {166.44899999999998, 328.789}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{159.637, 323.84000000000003},
        {164.84, 339.855}, {170.04299999999998, 323.84000000000003}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 328.789}, {180.07, 328.789}, {166.44899999999998,
         318.89099999999996}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 326.89799999999997}, {174.254, 310.883},
        {160.629, 320.78099999999995}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{234.57, 320.78099999999995},
        {220.945, 310.883}, {226.148, 326.89799999999997}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 318.89099999999996}, {215.129, 328.789},
        {231.969, 328.789}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{225.156, 323.84000000000003}, {230.359, 339.855},
        {235.562, 323.84000000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{228.75, 328.789}, {245.594, 328.789},
        {231.969, 318.89099999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{234.57, 326.89799999999997},
        {239.77299999999997, 310.883}, {226.148, 320.78099999999995}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 320.78099999999995}, {286.465, 310.883},
        {291.672, 326.89799999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 318.89099999999996}, {280.648, 328.789},
        {297.48799999999994, 328.789}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{290.676, 323.84000000000003},
        {295.879, 339.855}, {301.082, 323.84000000000003}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 328.789}, {311.113, 328.789},
        {297.48799999999994, 318.89099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 326.89799999999997}, {305.29299999999995, 310.883},
        {291.672, 320.78099999999995}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 320.78099999999995}, {351.984, 310.883},
        {357.191, 326.89799999999997}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 318.89099999999996}, {346.168, 328.789},
        {363.008, 328.789}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{356.195, 323.84000000000003}, {361.39799999999997, 339.855},
        {366.605, 323.84000000000003}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{359.79299999999995, 328.789},
        {376.633, 328.789}, {363.008, 318.89099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 326.89799999999997}, {370.812, 310.883},
        {357.191, 320.78099999999995}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{70.77, 292.703}, {57.145, 282.805},
        {62.352, 298.82}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{64.953, 290.812}, {51.328, 300.71099999999996},
        {68.16799999999999, 300.71099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{61.355, 295.762}, {66.559, 311.777}, {71.766, 295.762}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{64.953, 300.71099999999996}, {81.793, 300.71099999999996},
        {68.16799999999999, 290.812}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{70.77, 298.82}, {75.973, 282.805},
        {62.352, 292.703}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 292.703}, {122.66799999999999, 282.805},
        {127.871, 298.82}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 290.812}, {116.848, 300.71099999999996},
        {133.68800000000002, 300.71099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{126.87499999999999, 295.762}, {132.078, 311.777},
        {137.285, 295.762}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{130.47299999999998, 300.71099999999996},
        {147.312, 300.71099999999996}, {133.68800000000002, 290.812}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{136.289, 298.82}, {141.49200000000002, 282.805},
        {127.871, 292.703}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 292.703}, {188.18800000000002, 282.805},
        {193.39100000000002, 298.82}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{195.99200000000002, 290.812},
        {182.36700000000002, 300.71099999999996},
        {199.207, 300.71099999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{192.395, 295.762}, {197.602, 311.777},
        {202.805, 295.762}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{195.99200000000002, 300.71099999999996}, {212.83200000000002,
         300.71099999999996}, {199.207, 290.812}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{201.809, 298.82}, {207.016, 282.805}, {193.39100000000002,
         292.703}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 292.703}, {253.707, 282.805}, {258.90999999999997,
         298.82}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 290.812}, {247.88700000000003, 300.71099999999996},
        {264.727, 300.71099999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{257.91799999999995, 295.762},
        {263.121, 311.777}, {268.324, 295.762}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{261.512, 300.71099999999996}, {278.35200000000003,
         300.71099999999996}, {264.727, 290.812}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{267.328, 298.82}, {272.53499999999997, 282.805},
        {258.90999999999997, 292.703}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{332.85200000000003, 292.703},
        {319.227, 282.805}, {324.42999999999995, 298.82}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 290.812}, {313.40599999999995,
         300.71099999999996}, {330.25, 300.71099999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{323.43799999999993, 295.762}, {328.641, 311.777},
        {333.84400000000005, 295.762}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{327.03099999999995, 300.71099999999996},
        {343.871, 300.71099999999996}, {330.25, 290.812}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{332.85200000000003, 298.82}, {338.055, 282.805},
        {324.42999999999995, 292.703}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{38.012, 264.621},
        {24.387, 254.72299999999998}, {29.59, 270.73799999999994}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 262.72999999999996}, {18.566, 272.629},
        {35.406, 272.629}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{28.598, 267.68}, {33.800999999999995, 283.695},
        {39.004, 267.68}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{32.191, 272.629}, {49.031, 272.629},
        {35.406, 262.72999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{38.012, 270.73799999999994},
        {43.215, 254.72299999999998}, {29.59, 264.621}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{103.531, 264.621}, {89.906, 254.72299999999998},
        {95.109, 270.73799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{97.71100000000001, 262.72999999999996},
        {84.086, 272.629}, {100.93, 272.629}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{94.117, 267.68}, {99.32, 283.695}, {104.523, 267.68}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{97.71100000000001, 272.629}, {114.551, 272.629},
        {100.93, 262.72999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{103.531, 270.73799999999994},
        {108.73400000000001, 254.72299999999998}, {95.109, 264.621}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 264.621}, {155.42600000000002,
         254.72299999999998}, {160.629, 270.73799999999994}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{163.23, 262.72999999999996}, {149.60899999999998, 272.629},
        {166.44899999999998, 272.629}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{159.637, 267.68}, {164.84, 283.695},
        {170.04299999999998, 267.68}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{163.23, 272.629}, {180.07, 272.629},
        {166.44899999999998, 262.72999999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{169.05100000000002, 270.73799999999994},
        {174.254, 254.72299999999998}, {160.629, 264.621}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{234.57, 264.621}, {220.945, 254.72299999999998},
        {226.148, 270.73799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{228.75, 262.72999999999996},
        {215.129, 272.629}, {231.969, 272.629}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{225.156, 267.68}, {230.359, 283.695}, {235.562, 267.68}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{228.75, 272.629}, {245.594, 272.629},
        {231.969, 262.72999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{234.57, 270.73799999999994},
        {239.77299999999997, 254.72299999999998}, {226.148, 264.621}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 264.621}, {286.465, 254.72299999999998},
        {291.672, 270.73799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 262.72999999999996}, {280.648, 272.629},
        {297.48799999999994, 272.629}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}}, {{{290.676, 267.68}, {295.879, 283.695},
        {301.082, 267.68}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{294.27299999999997, 272.629}, {311.113, 272.629},
        {297.48799999999994, 262.72999999999996}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{300.09, 270.73799999999994}, {305.29299999999995,
         254.72299999999998}, {291.672, 264.621}}}],
     FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 264.621}, {351.984, 254.72299999999998},
        {357.191, 270.73799999999994}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 262.72999999999996}, {346.168, 272.629},
        {363.008, 272.629}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{356.195, 267.68}, {361.39799999999997, 283.695},
        {366.605, 267.68}}}], FilledCurve[{{{0, 2, 0}, {0, 1, 0}}},
      {{{359.79299999999995, 272.629}, {376.633, 272.629},
        {363.008, 262.72999999999996}}}], FilledCurve[
      {{{0, 2, 0}, {0, 1, 0}}},
      {{{365.60900000000004, 270.73799999999994},
        {370.812, 254.72299999999998}, {357.191, 264.621}}}]}},
   {ImageSize -> {{128}, {85}}, AspectRatio -> Automatic,
    ImageSize -> {475.00000000000006, 250.},
    PlotRange -> {{0., 988.}, {0., 520.}}}]]};
		g7names={"Canada","France","Germany","Italy","Japan","UnitedKingdom","UnitedStates"};
	)
];
