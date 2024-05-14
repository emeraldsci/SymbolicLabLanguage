(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldDateListPlot*)


DefineTests[EmeraldDateListPlot,

	{
		Example[{Basic,"Generate an empty plot if no date data is given:"},
			EmeraldDateListPlot[{}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Plot the weekly average temperature in San Francisco over the span of three year:"},
			EmeraldDateListPlot[sanFranTemp],
			ValidGraphicsP[]
		],
		Example[{Basic,"Compare the average temperatures of San Francisco and Boston:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Plot temperatures in several California cities over one year:"},
			EmeraldDateListPlot[californiaTemps,Legend->{"San Francisco","Los Angeles","San Diego","Sacramento"},LegendPlacement->Right,Boxes->True],
			ValidGraphicsP[]
		],


		(*
			DATE FORMATS
		*)
		Example[{Additional,"Date Formats","Dates can be DateObjects:"},
			EmeraldDateListPlot[{{DateObject[{2012,1,3}],169.91895`},{DateObject[{2012,2,1}],175.683236`},{DateObject[{2012,3,1}],180.863071`},{DateObject[{2012,3,29}],190.69687`},{DateObject[{2012,4,27}],189.360054`},{DateObject[{2012,5,25}],178.650907`},{DateObject[{2012,6,25}],177.326883`},{DateObject[{2012,7,24}],175.009843`},{DateObject[{2012,8,21}],183.430394`},{DateObject[{2012,9,19}],190.614327`}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Date Formats","Dates can be DateStrings:"},
			EmeraldDateListPlot[{{"Tue 3 Jan 2012",169.91895`},{"Wed 1 Feb 2012",175.683236`},{"Thu 1 Mar 2012",180.863071`},{"Thu 29 Mar 2012",190.69687`},{"Fri 27 Apr 2012",189.360054`},{"Fri 25 May 2012",178.650907`},{"Mon 25 Jun 2012",177.326883`},{"Tue 24 Jul 2012",175.009843`},{"Tue 21 Aug 2012",183.430394`},{"Wed 19 Sep 2012",190.614327`}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Date Formats","Dates can be DateLists:"},
			EmeraldDateListPlot[{{{2012,1,3},169.91895`},{{2012,8,7},183.827452`},{{2013,3,15},200.161383`},{{2013,10,17},164.405331`},{{2014,5,23},177.784704`},{{2014,12,26},157.206395`},{{2015,8,3},155.940587`}}],
			ValidGraphicsP[]
		],


		(*
			REPLICATES
		*)
		Example[{Additional,"Replicates","Plot the average temperature across several california cities by using Replicates:"},
			EmeraldDateListPlot[Replicates@@californiaTemps],
			ValidGraphicsP[]
		],

		(*
			OPTIONS
		*)
		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldDateListPlot[sanFranTemp,Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldDateListPlot[sanFranTemp,Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldDateListPlot[sanFranTemp,PlotRange->{Automatic,{0*Fahrenheit,100*Fahrenheit}}],
			ValidGraphicsP[]
		],

		Example[{Options,TargetUnits,"Specify target units for primary data.  If Automatic, the value is taken as the data's unit.  TargetUnits must be compatible with the primary data's units:"},
			EmeraldDateListPlot[sanFranTemp,TargetUnits->{Automatic,Fahrenheit}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYCoordinates,"Specify data for second-y axis:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->sanFranPressure],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYCoordinates,"Specify multiple data sets for second-y axis:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->{sanFranPressure,sanFranRain}],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYCoordinates,"Specify second-y data for multilpe primary data sets:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},SecondYCoordinates->{sanFranPressure,bostonPressure}],
			ValidGraphicsP[]
		],


		Example[{Options,SecondYColors,"Specify colors for second-y data:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->{sanFranPressure,sanFranRain},SecondYColors->{Orange,Purple}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYUnit,"Unit for secondary data axis:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->sanFranPressure,SecondYUnit->PSI],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYRange,"Plot range for secondary data axis:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->sanFranPressure,SecondYRange->{700 Millibar, 1200 Millibar}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYStyle,"Change the style for the secondary data:"},
			EmeraldDateListPlot[sanFranTemp,SecondYCoordinates->sanFranPressure,SecondYRange->{700 Millibar, 1200 Millibar},SecondYStyle->{Dashed,Thick}],
			ValidGraphicsP[]
		],

		Example[{Options,ErrorBars,"Show error bars over averaged replicated data:"},
			EmeraldDateListPlot[Replicates@@californiaTemps,ErrorBars->True],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorBars,"Do not show error bars over averaged replicated data:"},
			EmeraldDateListPlot[Replicates@@californiaTemps,ErrorBars->False],
			ValidGraphicsP[]
		],

		Example[{Options,ErrorType,"Show error bars corresponding to StandardDeviation:"},
			EmeraldDateListPlot[Replicates@@californiaTemps,ErrorType->StandardDeviation],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorType,"Show error bars corresponding to StandardError:"},
			EmeraldDateListPlot[Replicates@@californiaTemps,ErrorType->StandardError],
			ValidGraphicsP[]
		],
		Test["ErrorType option changes something:",
			SameQ[EmeraldDateListPlot[Replicates@@californiaTemps,ErrorType->StandardDeviation],EmeraldDateListPlot[Replicates@@californiaTemps,ErrorType->StandardError]],
			False
		],

		Example[{Options,AspectRatio,"Specify the ratio of height to width of the plot:"},
			EmeraldDateListPlot[sanFranRain,ImageSize->200,AspectRatio->2.0],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Specify how clipped values should be styled in the plot. For more information, evaluate ?ClippingStyle in the notebook:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				PlotRange->{Automatic,{1.95,2.5}},
				ClippingStyle->Directive[Red,Dashed]
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],

		Example[{Options,Scale,"Plot data using a log scale on the y-axis:"},
			EmeraldDateListPlot[Table[{Today+x*Month,5^x},{x,1,5,0.1}],Scale->Log],
			ValidGraphicsP[]?logFrameTicksQ
		],

		Example[{Options,Prolog,"Use Prolog to render additional graphics prior to plotting, such that they appear before the plot:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				Filling->Bottom,
				FillingStyle->Gray,
				Prolog->Inset[Import["ExampleData/spikey.tiff"]]
			],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Use Epilog to render additional graphics after plotting, such that they appear in front of the plot:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				Filling->Bottom,
				FillingStyle->Gray,
				Epilog->Inset[Framed@Import["ExampleData/spikey.tiff"]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Specify the background color of the plot:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				Background->LightGreen
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, ColorFunction -> "BlueGreenYellow"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, ColorFunction -> "ThermometerColors"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, ColorFunction -> "DeepSeaColors"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Specify if the coloring function should be scaled to the range of this plot:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, ColorFunction -> "TemperatureMap", ColorFunctionScaling -> False],
			ValidGraphicsP[]
		],

		Example[{Options,DateTicksFormat,"Apply MM/DD formatting to the date ticks, using the \"MonthShort\" and \"Day\" date strings as placeholders for the month and day in the data. To see a full list of special DateStrings, please run ?DateString in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},DateTicksFormat->{"MonthShort","/","Day"}],
			ValidGraphicsP[]
		],
		Example[{Options,DateTicksFormat,"Use the abbreviated name of the month and the last two digits of the year to format date ticks:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},DateTicksFormat->{"MonthNameShort"," ","YearShort"}],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Specify which parts of the plot's frame should be visible. Frame is specified in the format {{Left Frame, Right Frame},{Bottom Frame, Top Frame}}. In the following example, all frame borders are visible:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, Frame -> {{True, True}, {True, True}}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Specify which parts of the plot's frame should be visible. Frame is specified in the format {{Left Frame, Right Frame},{Bottom Frame, Top Frame}}. In the following example, only the left and bottom frame borders are visible:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, Frame -> {{True, False}, {True, False}}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, FrameStyle -> Dotted],
			ValidGraphicsP[]
		],
		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp}, FrameStyle -> Dashed],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Turn off all frame ticks:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp},FrameTicks->None],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicks,"Turn off only the bottom frame ticks, using the {{left,right},{bottom,top}} format:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp},FrameTicks->{{Automatic,Automatic},{None,None}}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicksStyle,"Specify the style of the plot's frame ticks. FrameTicksStyle can be set to any valid graphics directive. For more information, evaluate ?FrameTicksStyle in the notebook:"},
			EmeraldDateListPlot[{sanFranTemp, bostonTemp},FrameTicksStyle -> Directive[Orange, 12]],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill the area above the plot data:"},
			EmeraldDateListPlot[bostonTemp,Filling->Top],
			ValidGraphicsP[]
		],
		Example[{Options,Filling,"Fill the area below the plot data:"},
			EmeraldDateListPlot[bostonTemp,Filling->Top],
			ValidGraphicsP[]
		],
		Example[{Options,Filling,"Fill the area between the plot data and the x-axis:"},
			EmeraldDateListPlot[bostonTemp,Filling->Axis],
			ValidGraphicsP[]
		],
		Example[{Options,Filling,"Fill the area between the plot data and a numerical y-value:"},
			EmeraldDateListPlot[bostonTemp,Filling->10],
			ValidGraphicsP[]
		],
		Example[{Options,Filling,"Fill the area between two datasets:"},
			EmeraldDateListPlot[{bostonTemp,sanFranTemp},Filling->{1->{2}}],
			ValidGraphicsP[]
		],
		Example[{Options,FillingStyle,"Style the plot filling. Please run ?FillingStyle in the notebook for more information on possible style options:"},
			EmeraldDateListPlot[bostonTemp,Filling->Bottom,FillingStyle->Directive[Orange,Opacity[0.5]]],
			ValidGraphicsP[]
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldDateListPlot[Unitless[sanFranTemp],FrameLabel->{"Date","Temperature (Celsius)"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldDateListPlot[sanFranTemp,FrameLabel->{"Date",Automatic}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"When specifying a flat list, frame order is {bottom, left, top, right}:"},
			EmeraldDateListPlot[Unitless[sanFranTemp],SecondYCoordinates->Unitless[sanFranPressure],FrameLabel->{"Date","Average Temperature",None,"Average Pressure"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"When specifying a pair of lists, frame order is {{left, right},{bottom, top}}:"},
			EmeraldDateListPlot[Unitless[sanFranTemp],SecondYCoordinates->Unitless[sanFranPressure],FrameLabel->{{"Date","Average Pressure"},{"Average Temperature",None}}],
			ValidGraphicsP[]
		],

		Example[{Options,RotateLabel,"By default, the y-axis frame label is rotated:"},
			EmeraldDateListPlot[Unitless[sanFranTemp],FrameLabel->{"Date","Temperature (Celsius)"}],
			ValidGraphicsP[]
		],
		Example[{Options,RotateLabel,"Set FrameLabel->False to prevent the y-axis frame label from being rotated:"},
			EmeraldDateListPlot[Unitless[sanFranTemp],FrameLabel->{"Date","Temperature (Celsius)"},RotateLabel->False],
			ValidGraphicsP[]
		],

		Test["FrameTicks on x-axis should be date ticks:",
			EmeraldDateListPlot[Table[{Today+x*Second,x},{x,1,5,0.1}]],
			ValidGraphicsP[]?dateFrameTicksQ
		],

		Example[{Options,FrameUnits,"Specify a label and automatically append the data's units:"},
			EmeraldDateListPlot[sanFranTemp,FrameUnits->Automatic,FrameLabel->{"Date","Average Temperature"}],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Use either None or Automatic to include {vertical,horizontal} gridlines:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				GridLines->{None,Automatic}
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],
		Example[{Options,GridLines,"Explicitly specify gridlines, usine date strings for the vertical grid lines and numerical values for the horizontal grid lines:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				GridLines->{{"March 3","March 5","March 8"},{2.0,2.5,3.0}}
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],
		Example[{Options,GridLines,"Specify each gridline as a {value,Directive} pair to apply styling to individual grid lines:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				GridLines->{
					{
						{"March 2",Directive[Dashed,Thick,Red]},
						{"March 5 8:00 AM",Directive[Blue,Thick]},
						{"March 9",Directive[Dashed,Thick,Red]}
					},
					None
				}
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],

		Example[{Options,GridLinesStyle,"Apply the same style to all grid lines in the plot:"},
			EmeraldDateListPlot[tpdata,
				FrameLabel->{Automatic,"Estimated Price of Toilet Paper (USD)"},
				GridLines->{None,Automatic},
				GridLinesStyle->Directive[Red,Dashed]
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],

		Example[{Options,ImageSize,"Adjust the size of the output image:"},
			EmeraldDateListPlot[sanFranRain,FrameLabel->{Automatic,"Average Monthly Rainfall (inch)"},ImageSize->200],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size as a {width,height} pair:"},
			EmeraldDateListPlot[sanFranRain,FrameLabel->{Automatic,"Average Monthly Rainfall (inch)"},ImageSize->{600,300}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Specify the size using keywords Small, Medium, or Large:"},
			Table[EmeraldDateListPlot[sanFranRain,FrameLabel->{Automatic,"Average Monthly Rainfall (inch)"},ImageSize->size],{size,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,InterpolationOrder,"Set the degree of polynomial used to interpolate between data points in the plot:"},
			Table[
				EmeraldDateListPlot[{sanFranTemp,bostonTemp},
					ImageSize->400,
					PlotLabel->"Interpolation Order "<>ToString[ord],
					InterpolationOrder->ord
				],
				{ord,{0,1,2}}
			],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Joined,"Do not join the data points:"},
			EmeraldDateListPlot[Table[{Today + x*Second, x^3}, {x, -1, 1, 0.1}],Joined -> False],
			ValidGraphicsP[]
		],
		Example[{Options,Joined,"Do not join the data points for SF rain data:"},
			EmeraldDateListPlot[sanFranRain,Joined -> False],
			ValidGraphicsP[]
		],

		Example[{Options,LabelStyle,"Specify how label-like elements in the plot should be styled. Evaluate ?LabelStyle in the notebook for more information:"},
			EmeraldDateListPlot[sanFranRain,
				PlotLabel->"Average Rainfall in San Francisco",
				LabelStyle->Directive[14,Bold,Orange]
			],
			ValidGraphicsP[]
		],
		Example[{Options,LabelingFunction,"Specify a pure function that generates labels for each point in the plot. This function should take in coordinates and return graphics primitives. For example, the following LabelingFunction creates a text label for each data point with a y-value greater than 4.0. For more information, evaluate ?LabelingFunction in the notebook:"},
			EmeraldDateListPlot[sanFranRain,
				PlotLabel->"Average Rainfall in San Francisco",
				LabelingFunction->Function[{xy},
					If[Last[xy]>4.0,
						Placed[Panel[Style[ToString[Last[xy]]<>" Inches",Directive[16,Bold]], FrameMargins -> 0], Automatic],
						None
					]
				]
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Label the plot with a centered title:"},
			EmeraldDateListPlot[tpdata,
				PlotLabel->"Average Price of Toilet Paper",
				FrameLabel->{Automatic,"Price (USD)"}
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],
		Example[{Options,PlotLabel,"Use style directives in the plot label:"},
			EmeraldDateListPlot[tpdata,
				PlotLabel->Style["Average Price of Toilet Paper",Directive[Red,FontFamily->"Comic Sans MS"]],
				FrameLabel->{Automatic,"Price (USD)"}
			],
			ValidGraphicsP[],
			SetUp:>(
				tpdata=MapIndexed[{#1,(2+N@Exp[-(Sequence@@#2-800)^2/1600])}&,DateRange["February 1 2020","April 1 2020",Hour]];
			)
		],

		Example[{Options,PlotMarkers,"Specify how data points on the plot should be marked:"},
			EmeraldDateListPlot[sanFranRain,PlotMarkers->\[FilledCircle]],
			ValidGraphicsP[]
		],
		Example[{Options,PlotMarkers,"Apply style directives to the plot markers:"},
			EmeraldDateListPlot[sanFranRain,
				PlotMarkers->Style[\[FilledCircle],Directive[10,Red]]
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"PlotRangeClipping specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange or should be allowed to extend to the actual edge of the image:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},
				PlotRange->{Automatic,{-10,20}},
				PlotRangeClipping->False,
				ImageSize->{300,300}
			],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Specify a plot style to apply to all input data:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},PlotStyle->Orange],
			ValidGraphicsP[]
		],
		Example[{Options,PlotStyle,"Given a list of inputs, specify a list of plot styles to apply to each input:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},PlotStyle->{Directive[Orange,Dashed],Directive[Blue,Dotted]}],
			ValidGraphicsP[]
		],

		Example[{Options,Tooltip,"Specify tooltips for primary data:"},
			EmeraldDateListPlot[Table[Table[{Today+x*Second,x^p},{x,-1,1,0.1}],{p,{1,2,3}}],Tooltip->{{"A","B","C"}},Zoomable->True],
			{Tooltip[_,"A"],Tooltip[_,"B"],Tooltip[_,"C"],___},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],
		Example[{Options,Tooltip,"Specify tooltips for grouped primary data:"},
			EmeraldDateListPlot[Table[Table[Table[{Today+x*Second,a*x^p},{x,-1,1,0.1}],{a,{0.9,1.1}}],{p,{1,2,3}}],Tooltip->{{"A1","A2"},{"B1","B2"},{"C1","C2"}},Zoomable->True],
			{Tooltip[_,"A1"],Tooltip[_,"A2"],Tooltip[_,"B1"],Tooltip[_,"B2"],Tooltip[_,"C1"],Tooltip[_,"C2"],___},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],
		Example[{Options,Tooltip,"Incomplete tooltip specification is padded with Nulls:"},
			EmeraldDateListPlot[Table[Table[{Today+x*Second,x^p},{x,-1,1,0.1}],{p,{1,2,3}}],Tooltip->{{"A","B"}},Zoomable->True],
			{(Tooltip[_,"A"]|Tooltip[_,"B"])..},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],


		Example[{Options,Legend,"Specify a legend:"},
			EmeraldDateListPlot[
				{sanFranTemp,bostonTemp},
				Legend->{"San Francisco","Boston"}
			],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Legend elements can be styled:"},
			EmeraldDateListPlot[
				{sanFranTemp,bostonTemp},
				Legend->{Style["San Francisco",Italic,Purple,16],"Boston"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldDateListPlot[{sanFranTemp,bostonTemp},Legend->{"San Francisco","Boston"},LegendPlacement->Top],
				EmeraldDateListPlot[{sanFranTemp,bostonTemp},Legend->{"San Francisco","Boston"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,Boxes,"Use swatch boxes instead of lines in the legend:"},
			EmeraldDateListPlot[{sanFranTemp,bostonTemp},Legend->{"San Francisco","Boston"},Boxes->True],
			ValidGraphicsP[]
		]



		(*
			MESSAGES
		*)



		(*
			TESTS
		*)



	},

	Variables:>{
		sanFranTemp,bostonTemp,sanFranPressure,bostonPressure,sanFranRain,californiaTemps
	},
	SetUp:>(
		sanFranTemp=TemporalData[TimeSeries, {{{Quantity[10.37, "DegreesCelsius"], Quantity[10.87, "DegreesCelsius"], Quantity[8.77, "DegreesCelsius"], Quantity[10.93, "DegreesCelsius"], Quantity[11.04, "DegreesCelsius"], Quantity[12.75, "DegreesCelsius"], Quantity[10.4, "DegreesCelsius"], Quantity[11.36, "DegreesCelsius"], Quantity[9.29, "DegreesCelsius"], Quantity[11.17, "DegreesCelsius"], Quantity[11.99, "DegreesCelsius"], Quantity[10.57, "DegreesCelsius"], Quantity[12.18, "DegreesCelsius"], Quantity[10.6, "DegreesCelsius"], Quantity[11.67, "DegreesCelsius"], Quantity[13.02, "DegreesCelsius"], Quantity[14.94, "DegreesCelsius"], Quantity[12.29, "DegreesCelsius"], Quantity[13.97, "DegreesCelsius"], Quantity[12.44, "DegreesCelsius"], Quantity[13.17, "DegreesCelsius"], Quantity[13.22, "DegreesCelsius"], Quantity[13.33, "DegreesCelsius"], Quantity[15.53, "DegreesCelsius"], Quantity[15.36, "DegreesCelsius"], Quantity[15.31, "DegreesCelsius"], Quantity[15.28, "DegreesCelsius"], Quantity[14.23, "DegreesCelsius"], Quantity[16.09, "DegreesCelsius"], Quantity[16.06, "DegreesCelsius"], Quantity[14.19, "DegreesCelsius"], Quantity[15.12, "DegreesCelsius"], Quantity[14.48, "DegreesCelsius"], Quantity[13.9, "DegreesCelsius"], Quantity[16.22, "DegreesCelsius"], Quantity[14.38, "DegreesCelsius"], Quantity[14.72, "DegreesCelsius"], Quantity[14.23, "DegreesCelsius"], Quantity[13.13, "DegreesCelsius"], Quantity[18.64, "DegreesCelsius"], Quantity[14.94, "DegreesCelsius"], Quantity[17.61, "DegreesCelsius"], Quantity[14.6, "DegreesCelsius"], Quantity[14.83, "DegreesCelsius"], Quantity[15.24, "DegreesCelsius"], Quantity[13.46, "DegreesCelsius"], Quantity[14.28, "DegreesCelsius"], Quantity[14.16, "DegreesCelsius"], Quantity[13.71, "DegreesCelsius"], Quantity[10.98, "DegreesCelsius"], Quantity[10.62, "DegreesCelsius"], Quantity[10.45, "DegreesCelsius"], Quantity[8.72, "DegreesCelsius"], Quantity[8.31, "DegreesCelsius"], Quantity[8.99, "DegreesCelsius"], Quantity[8.41, "DegreesCelsius"], Quantity[11.38, "DegreesCelsius"], Quantity[10.18, "DegreesCelsius"], Quantity[9.4, "DegreesCelsius"], Quantity[10.62, "DegreesCelsius"], Quantity[9.24, "DegreesCelsius"], Quantity[10.46, "DegreesCelsius"], Quantity[10.09, "DegreesCelsius"], Quantity[11.28, "DegreesCelsius"], Quantity[10.99, "DegreesCelsius"], Quantity[11.69, "DegreesCelsius"], Quantity[13.14, "DegreesCelsius"], Quantity[12.29, "DegreesCelsius"], Quantity[11.62, "DegreesCelsius"], Quantity[13.55, "DegreesCelsius"], Quantity[16.6, "DegreesCelsius"], Quantity[14.18, "DegreesCelsius"], Quantity[13.36, "DegreesCelsius"], Quantity[12.43, "DegreesCelsius"], Quantity[13.96, "DegreesCelsius"], Quantity[14.67, "DegreesCelsius"], Quantity[14.91, "DegreesCelsius"], Quantity[14.16, "DegreesCelsius"], Quantity[17.9, "DegreesCelsius"], Quantity[16.69, "DegreesCelsius"], Quantity[15.05, "DegreesCelsius"], Quantity[14.22, "DegreesCelsius"], Quantity[14.88, "DegreesCelsius"], Quantity[14.9, "DegreesCelsius"], Quantity[14.99, "DegreesCelsius"], Quantity[17.13, "DegreesCelsius"], Quantity[17.62, "DegreesCelsius"], Quantity[18.06, "DegreesCelsius"], Quantity[19., "DegreesCelsius"], Quantity[16.96, "DegreesCelsius"], Quantity[16.99, "DegreesCelsius"], Quantity[16.26, "DegreesCelsius"], Quantity[17.85, "DegreesCelsius"], Quantity[15.79, "DegreesCelsius"], Quantity[16.23, "DegreesCelsius"], Quantity[12.02, "DegreesCelsius"], Quantity[13.4, "DegreesCelsius"], Quantity[14.55, "DegreesCelsius"], Quantity[13.73, "DegreesCelsius"], Quantity[13.37, "DegreesCelsius"], Quantity[13.01, "DegreesCelsius"], Quantity[10.3, "DegreesCelsius"], Quantity[7.94, "DegreesCelsius"], Quantity[11.66, "DegreesCelsius"], Quantity[12.47, "DegreesCelsius"], Quantity[13.19, "DegreesCelsius"], Quantity[10.61, "DegreesCelsius"], Quantity[12.17, "DegreesCelsius"], Quantity[14.55, "DegreesCelsius"], Quantity[14.4, "DegreesCelsius"], Quantity[13.45, "DegreesCelsius"], Quantity[10.67, "DegreesCelsius"], Quantity[13.15, "DegreesCelsius"], Quantity[13.63, "DegreesCelsius"], Quantity[13.71, "DegreesCelsius"], Quantity[14.04, "DegreesCelsius"], Quantity[16.9, "DegreesCelsius"], Quantity[14.85, "DegreesCelsius"], Quantity[14.7, "DegreesCelsius"], Quantity[12.33, "DegreesCelsius"], Quantity[16.21, "DegreesCelsius"], Quantity[14.52, "DegreesCelsius"], Quantity[14.44, "DegreesCelsius"], Quantity[19.11, "DegreesCelsius"], Quantity[15.41, "DegreesCelsius"], Quantity[19.81, "DegreesCelsius"], Quantity[15.99, "DegreesCelsius"], Quantity[16.66, "DegreesCelsius"], Quantity[15.01, "DegreesCelsius"], Quantity[18.18, "DegreesCelsius"], Quantity[17.07, "DegreesCelsius"], Quantity[17.4, "DegreesCelsius"], Quantity[17.95, "DegreesCelsius"], Quantity[17.32, "DegreesCelsius"], Quantity[19.35, "DegreesCelsius"], Quantity[20.94, "DegreesCelsius"], Quantity[18.04, "DegreesCelsius"], Quantity[18.14, "DegreesCelsius"], Quantity[19.3, "DegreesCelsius"], Quantity[17.93, "DegreesCelsius"], Quantity[18.62, "DegreesCelsius"], Quantity[19.43, "DegreesCelsius"], Quantity[17.51, "DegreesCelsius"], Quantity[20.55, "DegreesCelsius"], Quantity[20.55, "DegreesCelsius"], Quantity[22.41, "DegreesCelsius"], Quantity[18.91, "DegreesCelsius"], Quantity[21.02, "DegreesCelsius"], Quantity[19.82, "DegreesCelsius"], Quantity[17.41, "DegreesCelsius"], Quantity[16.54, "DegreesCelsius"], Quantity[16.66, "DegreesCelsius"], Quantity[15.91, "DegreesCelsius"], Quantity[14.52, "DegreesCelsius"], Quantity[16.31, "DegreesCelsius"], Quantity[15.39, "DegreesCelsius"], Quantity[13.25, "DegreesCelsius"], Quantity[14.14, "DegreesCelsius"], Quantity[11.53, "DegreesCelsius"]}}, CompressedData["
1:eJxdlUtuHEcQRGnAK91CN6jMqvwdQYBWOoIWBrzSQr6Pr+roXrAeTALEBGYY
U/0iK+Prz18//vrj4+Pj95/68/3v3//8T/1L9e2LXuzYZ+fptT7l5OSVEXXO
lWk1DlmtNz9l7W5Y1cyGVcc0rOSzYTW9+lqddcyv1bFllZDpfq2Ou5dD9mP8
KZ8nhNVjDauT+r0yPAxW0ZGw0mcXrGplwKqyFqzaK2D1orlyTgN7rNXAHisH
2HWkAfawWcCuIy9gj20G7IrBgF04HNh1Dgd2/Wxgj7QN7JF1gD1qH2CPmgB2
kQtgj7EE9phKYM+lUzrkFLCnRQN7ujWwp9cAe+49wP58CbA/AQJ76pPAntEG
7KmBxQPqwIYUFLYjhax0pJDtGylk90YKT7pIodZ7qCt1rmslMoEUFGcihfKT
OGTtVUihdEWRgvJrpFAaSqRQmgakoO8cpPBMN1IofRNSqBpDCtVhSKFeX0id
+lq1FgFS6DUbKbS9u+JT+hvRlc9DXLmfrQQ5Aex9NB6wCktgbz0EsHfuAvbO
aWDvCs5G9zsaV9YAe89ZwD76ILDPSgN2oTJgH2sH9vHjwD57bWDXvt3APu91
hewD7KPlB+x6GcA+qfGHVXkC+2i1bb7biRS05wspzKxCCiM093/1sffeXNlz
U8hlZ24KudzWTUGyVsFqb3NY7bGElZa7wUpbNWGlu2Kwyvf6XqkIYaWrErDS
jC5YaTgCVm8LQg4KN0236KagSTAUrmShcNN8o3AlB4WrZR0o3DStq4bVaRSu
dupB4T67GYUrmShcvXYUrmSjcFP9gsJNtRMKVzJRuOnKD9g12yhcrfaDwlXL
LxSuZKJwUxOIwpVsFK525EHh5lOSwK5LhMJNT0fhSjYKVw0TKFzteUPhStZb
uP8BjRt80A==
"], 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]["DatePath"];
		bostonTemp=TemporalData[TimeSeries, {{{Quantity[1.26, "DegreesCelsius"], Quantity[2.26, "DegreesCelsius"], Quantity[-3.02, "DegreesCelsius"], Quantity[1.93, "DegreesCelsius"], Quantity[2.5, "DegreesCelsius"], Quantity[1.5, "DegreesCelsius"], Quantity[0.79, "DegreesCelsius"], Quantity[3.34, "DegreesCelsius"], Quantity[1.65, "DegreesCelsius"], Quantity[5.16, "DegreesCelsius"], Quantity[6.64, "DegreesCelsius"], Quantity[13.71, "DegreesCelsius"], Quantity[5.21, "DegreesCelsius"], Quantity[6.65, "DegreesCelsius"], Quantity[9.22, "DegreesCelsius"], Quantity[14.55, "DegreesCelsius"], Quantity[9.73, "DegreesCelsius"], Quantity[8.8, "DegreesCelsius"], Quantity[12.55, "DegreesCelsius"], Quantity[15.36, "DegreesCelsius"], Quantity[15.96, "DegreesCelsius"], Quantity[18.1, "DegreesCelsius"], Quantity[13.79, "DegreesCelsius"], Quantity[17.62, "DegreesCelsius"], Quantity[20.64, "DegreesCelsius"], Quantity[20.69, "DegreesCelsius"], Quantity[24.02, "DegreesCelsius"], Quantity[23.57, "DegreesCelsius"], Quantity[24.47, "DegreesCelsius"], Quantity[22.04, "DegreesCelsius"], Quantity[21.24, "DegreesCelsius"], Quantity[23.19, "DegreesCelsius"], Quantity[23.25, "DegreesCelsius"], Quantity[20.65, "DegreesCelsius"], Quantity[22.29, "DegreesCelsius"], Quantity[20.23, "DegreesCelsius"], Quantity[18.36, "DegreesCelsius"], Quantity[16.31, "DegreesCelsius"], Quantity[15.7, "DegreesCelsius"], Quantity[15.41, "DegreesCelsius"], Quantity[10.49, "DegreesCelsius"], Quantity[13.32, "DegreesCelsius"], Quantity[12.18, "DegreesCelsius"], Quantity[11.17, "DegreesCelsius"], Quantity[4.09, "DegreesCelsius"], Quantity[6.5, "DegreesCelsius"], Quantity[4.6, "DegreesCelsius"], Quantity[1.45, "DegreesCelsius"], Quantity[5.69, "DegreesCelsius"], Quantity[4.93, "DegreesCelsius"], Quantity[4.52, "DegreesCelsius"], Quantity[0.16, "DegreesCelsius"], Quantity[-3.18, "DegreesCelsius"], Quantity[-2.7, "DegreesCelsius"], Quantity[3.15, "DegreesCelsius"], Quantity[2.85, "DegreesCelsius"], Quantity[-6.02, "DegreesCelsius"], Quantity[-0.39, "DegreesCelsius"], Quantity[-3.76, "DegreesCelsius"], Quantity[0.29, "DegreesCelsius"], Quantity[-1.46, "DegreesCelsius"], Quantity[1.82, "DegreesCelsius"], Quantity[1.85, "DegreesCelsius"], Quantity[2.65, "DegreesCelsius"], Quantity[-0.77, "DegreesCelsius"], Quantity[4.65, "DegreesCelsius"], Quantity[3.89, "DegreesCelsius"], Quantity[6.43, "DegreesCelsius"], Quantity[10.51, "DegreesCelsius"], Quantity[7.71, "DegreesCelsius"], Quantity[10.07, "DegreesCelsius"], Quantity[12.05, "DegreesCelsius"], Quantity[13.13, "DegreesCelsius"], Quantity[13.87, "DegreesCelsius"], Quantity[17.59, "DegreesCelsius"], Quantity[18.45, "DegreesCelsius"], Quantity[16.87, "DegreesCelsius"], Quantity[18.74, "DegreesCelsius"], Quantity[21.29, "DegreesCelsius"], Quantity[23.9, "DegreesCelsius"], Quantity[22.86, "DegreesCelsius"], Quantity[25.83, "DegreesCelsius"], Quantity[21.05, "DegreesCelsius"], Quantity[21.25, "DegreesCelsius"], Quantity[20.43, "DegreesCelsius"], Quantity[21.59, "DegreesCelsius"], Quantity[22.12, "DegreesCelsius"], Quantity[20.33, "DegreesCelsius"], Quantity[19.9, "DegreesCelsius"], Quantity[19.48, "DegreesCelsius"], Quantity[15.47, "DegreesCelsius"], Quantity[14.38, "DegreesCelsius"], Quantity[17.22, "DegreesCelsius"], Quantity[14.99, "DegreesCelsius"], Quantity[14.07, "DegreesCelsius"], Quantity[10.25, "DegreesCelsius"], Quantity[9.73, "DegreesCelsius"], Quantity[5.79, "DegreesCelsius"], Quantity[5.42, "DegreesCelsius"], Quantity[6.16, "DegreesCelsius"], Quantity[-0.01, "DegreesCelsius"], Quantity[4.63, "DegreesCelsius"], Quantity[-2.97, "DegreesCelsius"], Quantity[-1.05, "DegreesCelsius"], Quantity[0.48, "DegreesCelsius"], Quantity[0.56, "DegreesCelsius"], Quantity[-9.24, "DegreesCelsius"], Quantity[-1.39, "DegreesCelsius"], Quantity[5.27, "DegreesCelsius"], Quantity[-6.2, "DegreesCelsius"], Quantity[-4.08, "DegreesCelsius"], Quantity[-1.17, "DegreesCelsius"], Quantity[-3.43, "DegreesCelsius"], Quantity[-0.97, "DegreesCelsius"], Quantity[-2.18, "DegreesCelsius"], Quantity[-3.14, "DegreesCelsius"], Quantity[1.9, "DegreesCelsius"], Quantity[1.43, "DegreesCelsius"], Quantity[1.63, "DegreesCelsius"], Quantity[3.98, "DegreesCelsius"], Quantity[8.78, "DegreesCelsius"], Quantity[9.76, "DegreesCelsius"], Quantity[9.45, "DegreesCelsius"], Quantity[8.8, "DegreesCelsius"], Quantity[12.83, "DegreesCelsius"], Quantity[17.43, "DegreesCelsius"], Quantity[13.37, "DegreesCelsius"], Quantity[13.16, "DegreesCelsius"], Quantity[16.36, "DegreesCelsius"], Quantity[18.28, "DegreesCelsius"], Quantity[21.32, "DegreesCelsius"], Quantity[19.33, "DegreesCelsius"], Quantity[23.15, "DegreesCelsius"], Quantity[23.29, "DegreesCelsius"], Quantity[22.45, "DegreesCelsius"], Quantity[21.64, "DegreesCelsius"], Quantity[21.25, "DegreesCelsius"], Quantity[22.1, "DegreesCelsius"], Quantity[20.33, "DegreesCelsius"], Quantity[19.33, "DegreesCelsius"], Quantity[20.83, "DegreesCelsius"], Quantity[23.84, "DegreesCelsius"], Quantity[18.31, "DegreesCelsius"], Quantity[14.55, "DegreesCelsius"], Quantity[16.45, "DegreesCelsius"], Quantity[15.16, "DegreesCelsius"], Quantity[14.7, "DegreesCelsius"], Quantity[14.96, "DegreesCelsius"], Quantity[10.7, "DegreesCelsius"], Quantity[10.6, "DegreesCelsius"], Quantity[7.83, "DegreesCelsius"], Quantity[7.01, "DegreesCelsius"], Quantity[1.38, "DegreesCelsius"], Quantity[5.95, "DegreesCelsius"], Quantity[4.91, "DegreesCelsius"], Quantity[1.46, "DegreesCelsius"], Quantity[2.94, "DegreesCelsius"], Quantity[5.07, "DegreesCelsius"], Quantity[1.93, "DegreesCelsius"]}}, CompressedData["
1:eJxdlUtuHEcQRGnAK91CN6jMqvwdQYBWOoIWBrzSQr6Pr+roXrAeTALEBGYY
U/0iK+Prz18//vrj4+Pj95/68/3v3//8T/1L9e2LXuzYZ+fptT7l5OSVEXXO
lWk1DlmtNz9l7W5Y1cyGVcc0rOSzYTW9+lqddcyv1bFllZDpfq2Ou5dD9mP8
KZ8nhNVjDauT+r0yPAxW0ZGw0mcXrGplwKqyFqzaK2D1orlyTgN7rNXAHisH
2HWkAfawWcCuIy9gj20G7IrBgF04HNh1Dgd2/Wxgj7QN7JF1gD1qH2CPmgB2
kQtgj7EE9phKYM+lUzrkFLCnRQN7ujWwp9cAe+49wP58CbA/AQJ76pPAntEG
7KmBxQPqwIYUFLYjhax0pJDtGylk90YKT7pIodZ7qCt1rmslMoEUFGcihfKT
OGTtVUihdEWRgvJrpFAaSqRQmgakoO8cpPBMN1IofRNSqBpDCtVhSKFeX0id
+lq1FgFS6DUbKbS9u+JT+hvRlc9DXLmfrQQ5Aex9NB6wCktgbz0EsHfuAvbO
aWDvCs5G9zsaV9YAe89ZwD76ILDPSgN2oTJgH2sH9vHjwD57bWDXvt3APu91
hewD7KPlB+x6GcA+qfGHVXkC+2i1bb7biRS05wspzKxCCiM093/1sffeXNlz
U8hlZ24KudzWTUGyVsFqb3NY7bGElZa7wUpbNWGlu2Kwyvf6XqkIYaWrErDS
jC5YaTgCVm8LQg4KN0236KagSTAUrmShcNN8o3AlB4WrZR0o3DStq4bVaRSu
dupB4T67GYUrmShcvXYUrmSjcFP9gsJNtRMKVzJRuOnKD9g12yhcrfaDwlXL
LxSuZKJwUxOIwpVsFK525EHh5lOSwK5LhMJNT0fhSjYKVw0TKFzteUPhStZb
uP8BjRt80A==
"], 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]["DatePath"];
		sanFranPressure = TemporalData[TimeSeries, {{{Quantity[1023.83, "Millibars"], Quantity[1020.84, "Millibars"], Quantity[1021.47, "Millibars"], Quantity[1022.9, "Millibars"], Quantity[1020.84, "Millibars"], Quantity[1018.27, "Millibars"], Quantity[1019.71, "Millibars"], Quantity[1020.69, "Millibars"], Quantity[1021.04, "Millibars"], Quantity[1021.59, "Millibars"], Quantity[1015.79, "Millibars"], Quantity[1014.73, "Millibars"], Quantity[1015.07, "Millibars"], Quantity[1021., "Millibars"], Quantity[1013.53, "Millibars"], Quantity[1020.36, "Millibars"], Quantity[1015.44, "Millibars"], Quantity[1016.06, "Millibars"], Quantity[1014.89, "Millibars"], Quantity[1016.19, "Millibars"], Quantity[1014.39, "Millibars"], Quantity[1016.23, "Millibars"], Quantity[1016.59, "Millibars"], Quantity[1011.54, "Millibars"], Quantity[1011.39, "Millibars"], Quantity[1016.27, "Millibars"], Quantity[1013.74, "Millibars"], Quantity[1013.51, "Millibars"], Quantity[1014.61, "Millibars"], Quantity[1014.04, "Millibars"], Quantity[1014.6, "Millibars"], Quantity[1014.34, "Millibars"], Quantity[1011.01, "Millibars"], Quantity[1012.71, "Millibars"], Quantity[1013.56, "Millibars"], Quantity[1015.4, "Millibars"], Quantity[1015.76, "Millibars"], Quantity[1016.93, "Millibars"], Quantity[1012.63, "Millibars"], Quantity[1015.01, "Millibars"], Quantity[1016.23, "Millibars"], Quantity[1015.74, "Millibars"], Quantity[1016.7, "Millibars"], Quantity[1016.63, "Millibars"], Quantity[1016.97, "Millibars"], Quantity[1019.9, "Millibars"], Quantity[1020.41, "Millibars"], Quantity[1015.67, "Millibars"], Quantity[1019.16, "Millibars"], Quantity[1015.91, "Millibars"], Quantity[1017.3, "Millibars"], Quantity[1017.51, "Millibars"], Quantity[1019.4, "Millibars"], Quantity[1023.5, "Millibars"], Quantity[1021.34, "Millibars"], Quantity[1024.81, "Millibars"], Quantity[1019.76, "Millibars"], Quantity[1023.33, "Millibars"], Quantity[1020.01, "Millibars"], Quantity[1022.64, "Millibars"], Quantity[1017.54, "Millibars"], Quantity[1024.57, "Millibars"], Quantity[1016.43, "Millibars"], Quantity[1021.27, "Millibars"], Quantity[1019.11, "Millibars"], Quantity[1016.91, "Millibars"], Quantity[1019.27, "Millibars"], Quantity[1016.17, "Millibars"], Quantity[1018., "Millibars"], Quantity[1016.11, "Millibars"], Quantity[1014.54, "Millibars"], Quantity[1015.14, "Millibars"], Quantity[1017.34, "Millibars"], Quantity[1015.94, "Millibars"], Quantity[1016.09, "Millibars"], Quantity[1010.63, "Millibars"], Quantity[1013.27, "Millibars"], Quantity[1016.76, "Millibars"], Quantity[1013.86, "Millibars"], Quantity[1009.5, "Millibars"], Quantity[1012.63, "Millibars"], Quantity[1014.49, "Millibars"], Quantity[1013.74, "Millibars"], Quantity[1014.74, "Millibars"], Quantity[1016.06, "Millibars"], Quantity[1015.07, "Millibars"], Quantity[1011.64, "Millibars"], Quantity[1013.71, "Millibars"], Quantity[1013.83, "Millibars"], Quantity[1010.8, "Millibars"], Quantity[1010.4, "Millibars"], Quantity[1014.31, "Millibars"], Quantity[1017.1, "Millibars"], Quantity[1013.47, "Millibars"], Quantity[1016.56, "Millibars"], Quantity[1016.26, "Millibars"], Quantity[1015.07, "Millibars"], Quantity[1017.86, "Millibars"], Quantity[1017.34, "Millibars"], Quantity[1015.29, "Millibars"], Quantity[1019.26, "Millibars"], Quantity[1019.21, "Millibars"], Quantity[1024.7, "Millibars"], Quantity[1018.29, "Millibars"], Quantity[1023.14, "Millibars"], Quantity[1020.57, "Millibars"], Quantity[1019., "Millibars"], Quantity[1022.2, "Millibars"], Quantity[1024.66, "Millibars"], Quantity[1018.81, "Millibars"], Quantity[1018.83, "Millibars"], Quantity[1017.11, "Millibars"], Quantity[1021.33, "Millibars"], Quantity[1019.47, "Millibars"], Quantity[1009.54, "Millibars"], Quantity[1018.2, "Millibars"], Quantity[1019.23, "Millibars"], Quantity[1018.06, "Millibars"], Quantity[1017.26, "Millibars"], Quantity[1016.27, "Millibars"], Quantity[1016.83, "Millibars"], Quantity[1014.24, "Millibars"], Quantity[1017.07, "Millibars"], Quantity[1018.96, "Millibars"], Quantity[1016.53, "Millibars"], Quantity[1017.91, "Millibars"], Quantity[1015.02, "Millibars"], Quantity[1014.67, "Millibars"], Quantity[1010.97, "Millibars"], Quantity[1009.99, "Millibars"], Quantity[1013.09, "Millibars"], Quantity[1014.36, "Millibars"], Quantity[1011.96, "Millibars"], Quantity[1013.63, "Millibars"], Quantity[1014.57, "Millibars"], Quantity[1015.14, "Millibars"], Quantity[1014.26, "Millibars"], Quantity[1014.7, "Millibars"], Quantity[1013.86, "Millibars"], Quantity[1012.94, "Millibars"], Quantity[1013.3, "Millibars"], Quantity[1009.17, "Millibars"], Quantity[1011.31, "Millibars"], Quantity[1010.4, "Millibars"], Quantity[1014.13, "Millibars"], Quantity[1013.39, "Millibars"], Quantity[1012.93, "Millibars"], Quantity[1013.59, "Millibars"], Quantity[1014.47, "Millibars"], Quantity[1015.71, "Millibars"], Quantity[1021.09, "Millibars"], Quantity[1014.44, "Millibars"], Quantity[1019.6, "Millibars"], Quantity[1022.37, "Millibars"], Quantity[1012.46, "Millibars"], Quantity[1016., "Millibars"], Quantity[1016.99, "Millibars"], Quantity[1021.43, "Millibars"], Quantity[1023.75, "Millibars"]}}, CompressedData["
1:eJxdlUtuHEcQRGnAK91CN6jMqvwdQYBWOoIWBrzSQr6Pr+roXrAeTALEBGYY
U/0iK+Prz18//vrj4+Pj95/68/3v3//8T/1L9e2LXuzYZ+fptT7l5OSVEXXO
lWk1DlmtNz9l7W5Y1cyGVcc0rOSzYTW9+lqddcyv1bFllZDpfq2Ou5dD9mP8
KZ8nhNVjDauT+r0yPAxW0ZGw0mcXrGplwKqyFqzaK2D1orlyTgN7rNXAHisH
2HWkAfawWcCuIy9gj20G7IrBgF04HNh1Dgd2/Wxgj7QN7JF1gD1qH2CPmgB2
kQtgj7EE9phKYM+lUzrkFLCnRQN7ujWwp9cAe+49wP58CbA/AQJ76pPAntEG
7KmBxQPqwIYUFLYjhax0pJDtGylk90YKT7pIodZ7qCt1rmslMoEUFGcihfKT
OGTtVUihdEWRgvJrpFAaSqRQmgakoO8cpPBMN1IofRNSqBpDCtVhSKFeX0id
+lq1FgFS6DUbKbS9u+JT+hvRlc9DXLmfrQQ5Aex9NB6wCktgbz0EsHfuAvbO
aWDvCs5G9zsaV9YAe89ZwD76ILDPSgN2oTJgH2sH9vHjwD57bWDXvt3APu91
hewD7KPlB+x6GcA+qfGHVXkC+2i1bb7biRS05wspzKxCCiM093/1sffeXNlz
U8hlZ24KudzWTUGyVsFqb3NY7bGElZa7wUpbNWGlu2Kwyvf6XqkIYaWrErDS
jC5YaTgCVm8LQg4KN0236KagSTAUrmShcNN8o3AlB4WrZR0o3DStq4bVaRSu
dupB4T67GYUrmShcvXYUrmSjcFP9gsJNtRMKVzJRuOnKD9g12yhcrfaDwlXL
LxSuZKJwUxOIwpVsFK525EHh5lOSwK5LhMJNT0fhSjYKVw0TKFzteUPhStZb
uP8BjRt80A==
"], 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]["DatePath"];
		bostonPressure = TemporalData[TimeSeries, {{{Quantity[1010.21, "Millibars"], Quantity[1012.87, "Millibars"], Quantity[1018.66, "Millibars"], Quantity[1019.05, "Millibars"], Quantity[1018.27, "Millibars"], Quantity[1018.09, "Millibars"], Quantity[1014.36, "Millibars"], Quantity[1009.66, "Millibars"], Quantity[1018.05, "Millibars"], Quantity[1016.5, "Millibars"], Quantity[1023.77, "Millibars"], Quantity[1022.2, "Millibars"], Quantity[1012.41, "Millibars"], Quantity[1008.36, "Millibars"], Quantity[1009.94, "Millibars"], Quantity[1015.91, "Millibars"], Quantity[1005.92, "Millibars"], Quantity[1020.11, "Millibars"], Quantity[1015.58, "Millibars"], Quantity[1018.41, "Millibars"], Quantity[1019.99, "Millibars"], Quantity[1013.5, "Millibars"], Quantity[1010.19, "Millibars"], Quantity[1021.27, "Millibars"], Quantity[1015.86, "Millibars"], Quantity[1005.93, "Millibars"], Quantity[1009.37, "Millibars"], Quantity[1016.46, "Millibars"], Quantity[1013.01, "Millibars"], Quantity[1010.46, "Millibars"], Quantity[1015.49, "Millibars"], Quantity[1014.7, "Millibars"], Quantity[1011.66, "Millibars"], Quantity[1017., "Millibars"], Quantity[1016.07, "Millibars"], Quantity[1014.73, "Millibars"], Quantity[1019.03, "Millibars"], Quantity[1017.64, "Millibars"], Quantity[1017.8, "Millibars"], Quantity[1014.61, "Millibars"], Quantity[1019.2, "Millibars"], Quantity[1013.36, "Millibars"], Quantity[1017.63, "Millibars"], Quantity[1002.2, "Millibars"], Quantity[1014.19, "Millibars"], Quantity[1029.16, "Millibars"], Quantity[1024.39, "Millibars"], Quantity[1020.61, "Millibars"], Quantity[1021.69, "Millibars"], Quantity[1019.51, "Millibars"], Quantity[1008.34, "Millibars"], Quantity[1013.2, "Millibars"], Quantity[1008.2, "Millibars"], Quantity[1014.04, "Millibars"], Quantity[1024.24, "Millibars"], Quantity[1020.21, "Millibars"], Quantity[1016.26, "Millibars"], Quantity[1016.46, "Millibars"], Quantity[1015.84, "Millibars"], Quantity[1013.44, "Millibars"], Quantity[1012.69, "Millibars"], Quantity[1012.92, "Millibars"], Quantity[1011.91, "Millibars"], Quantity[1015.27, "Millibars"], Quantity[1012.33, "Millibars"], Quantity[1010.01, "Millibars"], Quantity[1015.45, "Millibars"], Quantity[1017.07, "Millibars"], Quantity[1019.76, "Millibars"], Quantity[1026.09, "Millibars"], Quantity[1028.53, "Millibars"], Quantity[1019.89, "Millibars"], Quantity[1012.3, "Millibars"], Quantity[1015.67, "Millibars"], Quantity[1016.86, "Millibars"], Quantity[1014.01, "Millibars"], Quantity[1010.93, "Millibars"], Quantity[1016.7, "Millibars"], Quantity[1010.87, "Millibars"], Quantity[1017.39, "Millibars"], Quantity[1016.14, "Millibars"], Quantity[1017.89, "Millibars"], Quantity[1012.19, "Millibars"], Quantity[1015.07, "Millibars"], Quantity[1015.07, "Millibars"], Quantity[1015.6, "Millibars"], Quantity[1018.07, "Millibars"], Quantity[1016.19, "Millibars"], Quantity[1012.72, "Millibars"], Quantity[1013.97, "Millibars"], Quantity[1019.86, "Millibars"], Quantity[1014.73, "Millibars"], Quantity[1017.19, "Millibars"], Quantity[1022.56, "Millibars"], Quantity[1018.73, "Millibars"], Quantity[1012.37, "Millibars"], Quantity[1016.64, "Millibars"], Quantity[1023.5, "Millibars"], Quantity[1018.77, "Millibars"], Quantity[1020.71, "Millibars"], Quantity[1020.64, "Millibars"], Quantity[1018.57, "Millibars"], Quantity[1023.6, "Millibars"], Quantity[1016.5, "Millibars"], Quantity[1021.27, "Millibars"], Quantity[1019.15, "Millibars"], Quantity[1023.83, "Millibars"], Quantity[1018.94, "Millibars"], Quantity[1010.2, "Millibars"], Quantity[1011.3, "Millibars"], Quantity[1016.24, "Millibars"], Quantity[1020.64, "Millibars"], Quantity[1016.48, "Millibars"], Quantity[1013.81, "Millibars"], Quantity[1014.2, "Millibars"], Quantity[1023.64, "Millibars"], Quantity[1006.26, "Millibars"], Quantity[1017.16, "Millibars"], Quantity[1017.2, "Millibars"], Quantity[1014.79, "Millibars"], Quantity[1013.36, "Millibars"], Quantity[1024.4, "Millibars"], Quantity[1013.44, "Millibars"], Quantity[1017.5, "Millibars"], Quantity[1013.96, "Millibars"], Quantity[1018.91, "Millibars"], Quantity[1015.65, "Millibars"], Quantity[1017.04, "Millibars"], Quantity[1014.94, "Millibars"], Quantity[1015.56, "Millibars"], Quantity[1014.27, "Millibars"], Quantity[1016.86, "Millibars"], Quantity[1014.49, "Millibars"], Quantity[1013.23, "Millibars"], Quantity[1014.96, "Millibars"], Quantity[1015.89, "Millibars"], Quantity[1014.04, "Millibars"], Quantity[1015.11, "Millibars"], Quantity[1016.82, "Millibars"], Quantity[1014.79, "Millibars"], Quantity[1018.2, "Millibars"], Quantity[1015.66, "Millibars"], Quantity[1019.63, "Millibars"], Quantity[1019.93, "Millibars"], Quantity[1021.97, "Millibars"], Quantity[1018.58, "Millibars"], Quantity[1015.92, "Millibars"], Quantity[1017.17, "Millibars"], Quantity[1009.53, "Millibars"], Quantity[1010.67, "Millibars"], Quantity[1011.14, "Millibars"], Quantity[1016.43, "Millibars"], Quantity[1016.94, "Millibars"], Quantity[1016.11, "Millibars"], Quantity[1026.71, "Millibars"], Quantity[1012.83, "Millibars"], Quantity[1013.5, "Millibars"], Quantity[1019.96, "Millibars"], Quantity[1020.45, "Millibars"]}}, CompressedData["
1:eJxdlUtuHEcQRGnAK91CN6jMqvwdQYBWOoIWBrzSQr6Pr+roXrAeTALEBGYY
U/0iK+Prz18//vrj4+Pj95/68/3v3//8T/1L9e2LXuzYZ+fptT7l5OSVEXXO
lWk1DlmtNz9l7W5Y1cyGVcc0rOSzYTW9+lqddcyv1bFllZDpfq2Ou5dD9mP8
KZ8nhNVjDauT+r0yPAxW0ZGw0mcXrGplwKqyFqzaK2D1orlyTgN7rNXAHisH
2HWkAfawWcCuIy9gj20G7IrBgF04HNh1Dgd2/Wxgj7QN7JF1gD1qH2CPmgB2
kQtgj7EE9phKYM+lUzrkFLCnRQN7ujWwp9cAe+49wP58CbA/AQJ76pPAntEG
7KmBxQPqwIYUFLYjhax0pJDtGylk90YKT7pIodZ7qCt1rmslMoEUFGcihfKT
OGTtVUihdEWRgvJrpFAaSqRQmgakoO8cpPBMN1IofRNSqBpDCtVhSKFeX0id
+lq1FgFS6DUbKbS9u+JT+hvRlc9DXLmfrQQ5Aex9NB6wCktgbz0EsHfuAvbO
aWDvCs5G9zsaV9YAe89ZwD76ILDPSgN2oTJgH2sH9vHjwD57bWDXvt3APu91
hewD7KPlB+x6GcA+qfGHVXkC+2i1bb7biRS05wspzKxCCiM093/1sffeXNlz
U8hlZ24KudzWTUGyVsFqb3NY7bGElZa7wUpbNWGlu2Kwyvf6XqkIYaWrErDS
jC5YaTgCVm8LQg4KN0236KagSTAUrmShcNN8o3AlB4WrZR0o3DStq4bVaRSu
dupB4T67GYUrmShcvXYUrmSjcFP9gsJNtRMKVzJRuOnKD9g12yhcrfaDwlXL
LxSuZKJwUxOIwpVsFK525EHh5lOSwK5LhMJNT0fhSjYKVw0TKFzteUPhStZb
uP8BjRt80A==
"], 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]["DatePath"];
		sanFranRain = TemporalData[TimeSeries, {{{0, 0, 3.31000001728535, 0, 0, 0.280000001192093, 0.100000001490116, 0, 0.609999999403954, 0, 0, 0, 4.54999995231628, 1.75999994575977, 0.639999985694885, 0, 1.01999998092651, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0299999993294477, 0, 0, 0.889999985694885, 0.150000002235174, 0, 0, 4.76999999582767, 4.26999998092651, 0.100000001490116, 0.880000025033951, 7.220000077039, 0.0500000007450581, 0, 0.250000007450581, 0, 0.0299999993294477, 0, 0.280000001192093, 0, 0, 0, 0.330000013113022, 0, 0.0500000007450581, 0, 0.380000002682209, 0, 0, 0, 0, 0, 0, 0, 0.0299999993294477, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.579999983310699, 0, 0.0299999993294477, 0, 0, 0, 0, 0, 0.610000014305115, 0, 0.200000002980232, 0.150000005960464, 0, 0, 0, 0, 0, 0, 0, 0, 2.2600000873208, 0, 0, 1.38000002503395, 0.300000011920929, 0, 0, 1.61999996006489, 2.79999998025596, 0, 0, 0.939999997615814, 0, 0, 0, 0, 0, 0, 0, 0, 0.0299999993294477, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.71000000834465, 0, 0, 0.150000005960464, 0.379999995231628, 2.67000010423362, 5.82000017166138, 0.0299999993294477, 0.100000001490116, 0}}, CompressedData["
1:eJxdlUtuHEcQRGnAK91CN6jMqvwdQYBWOoIWBrzSQr6Pr+roXrAeTALEBGYY
U/0iK+Prz18//vrj4+Pj95/68/3v3//8T/1L9e2LXuzYZ+fptT7l5OSVEXXO
lWk1DlmtNz9l7W5Y1cyGVcc0rOSzYTW9+lqddcyv1bFllZDpfq2Ou5dD9mP8
KZ8nhNVjDauT+r0yPAxW0ZGw0mcXrGplwKqyFqzaK2D1orlyTgN7rNXAHisH
2HWkAfawWcCuIy9gj20G7IrBgF04HNh1Dgd2/Wxgj7QN7JF1gD1qH2CPmgB2
kQtgj7EE9phKYM+lUzrkFLCnRQN7ujWwp9cAe+49wP58CbA/AQJ76pPAntEG
7KmBxQPqwIYUFLYjhax0pJDtGylk90YKT7pIodZ7qCt1rmslMoEUFGcihfKT
OGTtVUihdEWRgvJrpFAaSqRQmgakoO8cpPBMN1IofRNSqBpDCtVhSKFeX0id
+lq1FgFS6DUbKbS9u+JT+hvRlc9DXLmfrQQ5Aex9NB6wCktgbz0EsHfuAvbO
aWDvCs5G9zsaV9YAe89ZwD76ILDPSgN2oTJgH2sH9vHjwD57bWDXvt3APu91
hewD7KPlB+x6GcA+qfGHVXkC+2i1bb7biRS05wspzKxCCiM093/1sffeXNlz
U8hlZ24KudzWTUGyVsFqb3NY7bGElZa7wUpbNWGlu2Kwyvf6XqkIYaWrErDS
jC5YaTgCVm8LQg4KN0236KagSTAUrmShcNN8o3AlB4WrZR0o3DStq4bVaRSu
dupB4T67GYUrmShcvXYUrmSjcFP9gsJNtRMKVzJRuOnKD9g12yhcrfaDwlXL
LxSuZKJwUxOIwpVsFK525EHh5lOSwK5LhMJNT0fhSjYKVw0TKFzteUPhStZb
uP8BjRt80A==
"], 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]["DatePath"];
		californiaTemps=Through[{TemporalData[TimeSeries, {{{Quantity[10.37, "DegreesCelsius"], Quantity[10.87, "DegreesCelsius"], Quantity[8.77, "DegreesCelsius"], Quantity[10.93, "DegreesCelsius"], Quantity[11.04, "DegreesCelsius"], Quantity[12.75, "DegreesCelsius"], Quantity[10.4, "DegreesCelsius"], Quantity[11.36, "DegreesCelsius"], Quantity[9.29, "DegreesCelsius"], Quantity[11.17, "DegreesCelsius"], Quantity[11.99, "DegreesCelsius"], Quantity[10.57, "DegreesCelsius"], Quantity[12.18, "DegreesCelsius"], Quantity[10.6, "DegreesCelsius"], Quantity[11.67, "DegreesCelsius"], Quantity[13.02, "DegreesCelsius"], Quantity[14.94, "DegreesCelsius"], Quantity[12.29, "DegreesCelsius"], Quantity[13.97, "DegreesCelsius"], Quantity[12.44, "DegreesCelsius"], Quantity[13.17, "DegreesCelsius"], Quantity[13.22, "DegreesCelsius"], Quantity[13.33, "DegreesCelsius"], Quantity[15.53, "DegreesCelsius"], Quantity[15.36, "DegreesCelsius"], Quantity[15.31, "DegreesCelsius"], Quantity[15.28, "DegreesCelsius"], Quantity[14.23, "DegreesCelsius"], Quantity[16.09, "DegreesCelsius"], Quantity[16.06, "DegreesCelsius"], Quantity[14.19, "DegreesCelsius"], Quantity[15.12, "DegreesCelsius"], Quantity[14.48, "DegreesCelsius"], Quantity[13.9, "DegreesCelsius"], Quantity[16.22, "DegreesCelsius"], Quantity[14.38, "DegreesCelsius"], Quantity[14.72, "DegreesCelsius"], Quantity[14.23, "DegreesCelsius"], Quantity[13.13, "DegreesCelsius"], Quantity[18.64, "DegreesCelsius"], Quantity[14.94, "DegreesCelsius"], Quantity[17.61, "DegreesCelsius"], Quantity[14.6, "DegreesCelsius"], Quantity[14.83, "DegreesCelsius"], Quantity[15.24, "DegreesCelsius"], Quantity[13.46, "DegreesCelsius"], Quantity[14.28, "DegreesCelsius"], Quantity[14.16, "DegreesCelsius"], Quantity[13.71, "DegreesCelsius"], Quantity[10.98, "DegreesCelsius"], Quantity[10.62, "DegreesCelsius"], Quantity[10.45, "DegreesCelsius"], Quantity[8.72, "DegreesCelsius"]}}, {TemporalData`DateSpecification[{2012, 1, 1, 0, 0, 0.}, {2012, 12, 30, 0, 0, 0.}, {1, "Week"}]}, 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2],TemporalData[TimeSeries, {{{Quantity[15.21, "DegreesCelsius"], Quantity[14.04, "DegreesCelsius"], Quantity[11.63, "DegreesCelsius"], Quantity[15.58, "DegreesCelsius"], Quantity[14.15, "DegreesCelsius"], Quantity[14.64, "DegreesCelsius"], Quantity[12.87, "DegreesCelsius"], Quantity[12.72, "DegreesCelsius"], Quantity[12.27, "DegreesCelsius"], Quantity[14.64, "DegreesCelsius"], Quantity[12.56, "DegreesCelsius"], Quantity[11.28, "DegreesCelsius"], Quantity[12.15, "DegreesCelsius"], Quantity[15.01, "DegreesCelsius"], Quantity[13.31, "DegreesCelsius"], Quantity[14.32, "DegreesCelsius"], Quantity[14.99, "DegreesCelsius"], Quantity[15.55, "DegreesCelsius"], Quantity[16.33, "DegreesCelsius"], Quantity[16.03, "DegreesCelsius"], Quantity[16.88, "DegreesCelsius"], Quantity[16.94, "DegreesCelsius"], Quantity[17.83, "DegreesCelsius"], Quantity[17.48, "DegreesCelsius"], Quantity[17.01, "DegreesCelsius"], Quantity[17.44, "DegreesCelsius"], Quantity[17.76, "DegreesCelsius"], Quantity[17.83, "DegreesCelsius"], Quantity[19.15, "DegreesCelsius"], Quantity[17.28, "DegreesCelsius"], Quantity[18.29, "DegreesCelsius"], Quantity[20.21, "DegreesCelsius"], Quantity[21.3, "DegreesCelsius"], Quantity[20.46, "DegreesCelsius"], Quantity[21.52, "DegreesCelsius"], Quantity[20.76, "DegreesCelsius"], Quantity[21.95, "DegreesCelsius"], Quantity[20.79, "DegreesCelsius"], Quantity[19.46, "DegreesCelsius"], Quantity[20.42, "DegreesCelsius"], Quantity[18.09, "DegreesCelsius"], Quantity[21.1, "DegreesCelsius"], Quantity[19.75, "DegreesCelsius"], Quantity[16.91, "DegreesCelsius"], Quantity[16.93, "DegreesCelsius"], Quantity[15.51, "DegreesCelsius"], Quantity[14.25, "DegreesCelsius"], Quantity[15.32, "DegreesCelsius"], Quantity[15.28, "DegreesCelsius"], Quantity[12.79, "DegreesCelsius"], Quantity[11.99, "DegreesCelsius"], Quantity[11.98, "DegreesCelsius"], Quantity[9.92, "DegreesCelsius"]}}, {TemporalData`DateSpecification[{2012, 1, 1, 0, 0, 0.}, {2012, 12, 30, 0, 0, 0.}, {1, "Week"}]}, 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2],TemporalData[TimeSeries, {{{Quantity[15.66, "DegreesCelsius"], Quantity[14.1, "DegreesCelsius"], Quantity[10.89, "DegreesCelsius"], Quantity[13.1, "DegreesCelsius"], Quantity[12.8, "DegreesCelsius"], Quantity[14.15, "DegreesCelsius"], Quantity[11.57, "DegreesCelsius"], Quantity[13., "DegreesCelsius"], Quantity[11.41, "DegreesCelsius"], Quantity[14.63, "DegreesCelsius"], Quantity[12.74, "DegreesCelsius"], Quantity[11.72, "DegreesCelsius"], Quantity[12.65, "DegreesCelsius"], Quantity[14.54, "DegreesCelsius"], Quantity[14.36, "DegreesCelsius"], Quantity[14.43, "DegreesCelsius"], Quantity[15.74, "DegreesCelsius"], Quantity[15.75, "DegreesCelsius"], Quantity[16.12, "DegreesCelsius"], Quantity[16.72, "DegreesCelsius"], Quantity[16.48, "DegreesCelsius"], Quantity[16.47, "DegreesCelsius"], Quantity[16.79, "DegreesCelsius"], Quantity[16.27, "DegreesCelsius"], Quantity[17.38, "DegreesCelsius"], Quantity[18.68, "DegreesCelsius"], Quantity[17.99, "DegreesCelsius"], Quantity[19.94, "DegreesCelsius"], Quantity[20.37, "DegreesCelsius"], Quantity[19.11, "DegreesCelsius"], Quantity[19.02, "DegreesCelsius"], Quantity[22.02, "DegreesCelsius"], Quantity[24.19, "DegreesCelsius"], Quantity[21.85, "DegreesCelsius"], Quantity[22.96, "DegreesCelsius"], Quantity[23.76, "DegreesCelsius"], Quantity[23.08, "DegreesCelsius"], Quantity[22.82, "DegreesCelsius"], Quantity[21.18, "DegreesCelsius"], Quantity[22., "DegreesCelsius"], Quantity[18.07, "DegreesCelsius"], Quantity[21.31, "DegreesCelsius"], Quantity[16.86, "DegreesCelsius"], Quantity[16.64, "DegreesCelsius"], Quantity[16.93, "DegreesCelsius"], Quantity[14.02, "DegreesCelsius"], Quantity[14.13, "DegreesCelsius"], Quantity[15.38, "DegreesCelsius"], Quantity[15.51, "DegreesCelsius"], Quantity[12.64, "DegreesCelsius"], Quantity[11.28, "DegreesCelsius"], Quantity[10.91, "DegreesCelsius"], Quantity[8.25, "DegreesCelsius"]}}, {TemporalData`DateSpecification[{2012, 1, 1, 0, 0, 0.}, {2012, 12, 30, 0, 0, 0.}, {1, "Week"}]}, 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2],TemporalData[TimeSeries, {{{Quantity[7.9, "DegreesCelsius"], Quantity[7.4, "DegreesCelsius"], Quantity[6.18, "DegreesCelsius"], Quantity[9.37, "DegreesCelsius"], Quantity[9.72, "DegreesCelsius"], Quantity[11.11, "DegreesCelsius"], Quantity[9.63, "DegreesCelsius"], Quantity[12.65, "DegreesCelsius"], Quantity[9.21, "DegreesCelsius"], Quantity[12.05, "DegreesCelsius"], Quantity[12.1, "DegreesCelsius"], Quantity[11.17, "DegreesCelsius"], Quantity[12.28, "DegreesCelsius"], Quantity[11.36, "DegreesCelsius"], Quantity[11.79, "DegreesCelsius"], Quantity[17.09, "DegreesCelsius"], Quantity[17.31, "DegreesCelsius"], Quantity[16.53, "DegreesCelsius"], Quantity[21.27, "DegreesCelsius"], Quantity[19.69, "DegreesCelsius"], Quantity[19.52, "DegreesCelsius"], Quantity[20.42, "DegreesCelsius"], Quantity[18.9, "DegreesCelsius"], Quantity[24.88, "DegreesCelsius"], Quantity[22.21, "DegreesCelsius"], Quantity[18.97, "DegreesCelsius"], Quantity[21.76, "DegreesCelsius"], Quantity[24.87, "DegreesCelsius"], Quantity[20.79, "DegreesCelsius"], Quantity[22.24, "DegreesCelsius"], Quantity[24.2, "DegreesCelsius"], Quantity[25.01, "DegreesCelsius"], Quantity[26.2, "DegreesCelsius"], Quantity[22.45, "DegreesCelsius"], Quantity[20.55, "DegreesCelsius"], Quantity[22.56, "DegreesCelsius"], Quantity[22.46, "DegreesCelsius"], Quantity[20.43, "DegreesCelsius"], Quantity[21.69, "DegreesCelsius"], Quantity[21.71, "DegreesCelsius"], Quantity[15.97, "DegreesCelsius"], Quantity[19.97, "DegreesCelsius"], Quantity[14.01, "DegreesCelsius"], Quantity[15.81, "DegreesCelsius"], Quantity[13.01, "DegreesCelsius"], Quantity[9.29, "DegreesCelsius"], Quantity[12.47, "DegreesCelsius"], Quantity[11.82, "DegreesCelsius"], Quantity[11.79, "DegreesCelsius"], Quantity[6.92, "DegreesCelsius"], Quantity[7.83, "DegreesCelsius"], Quantity[6.57, "DegreesCelsius"], Quantity[6.06, "DegreesCelsius"]}}, {TemporalData`DateSpecification[{2012, 1, 1, 0, 0, 0.}, {2012, 12, 30, 0, 0, 0.}, {1, "Week"}]}, 1, {"Continuous", 1}, {"Discrete", 1}, 1, {ValueDimensions -> 1, DateFunction -> Automatic, ResamplingMethod -> {"Interpolation", InterpolationOrder -> 1}}}, True, 10.2]}["DatePath"]];
	)
];
