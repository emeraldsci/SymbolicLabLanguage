(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR*)


DefineTests[PlotNMR,
	{
		Example[
			{Basic,"Plot a group of spectra data:"},
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]}]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot an NMR data in a link:"},
			PlotNMR[Link[Object[Data, NMR, "id:pZx9jonGr7RM"],Protocol]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot an NMR data linked to a given protocol object:"},
			PlotNMR[Object[Protocol, NMR, "NMR Protocol For PlotNMR Test " <> $SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[
			{Additional,"Plot timed NMR spectra in a stacked waterfall:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"]],
			_?ValidGraphicsQ
		],
		Test[
			"Plot raw timed NMR spectra:",
			PlotNMR[Download[Object[Data,NMR,"id:7X104vnMY0PZ"],TimedNMRSpectra]],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotType,"Plot a group of spectra data in a stacked waterfall:"},
				PlotNMR[{
					Object[Data,NMR,"id:pZx9jonGr7RM"],
					Object[Data,NMR,"id:aXRlGnZm8OK9"],
					Object[Data,NMR,"id:Vrbp1jG8Zd9o"]
				},
				PlotType->WaterfallPlot
			],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Display,"Display additonal information, here Peaks, PeakWidths, Intensity:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],
				Display->{Peaks}
			],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PrimaryData,"Specify which data field is displayed:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],
				PrimaryData->{NMRSpectrum}
			],
			_?ValidGraphicsQ
		],		
		Example[
			{Options,TargetUnits,"Specify the units to use for the X and Y axes:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],
				TargetUnits->{PPM,ArbitraryUnit}
			],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Peaks,"Display peak data:"},
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},NMRSpectrum],
				Peaks -> {<|Type -> Object[Analysis, Peaks],
					BaselineFunction -> Function[x, 55678.5703`],
					Position -> {1.3376`, 1.3454`, 3.9323`, 4.1368`, 4.4305`, 4.6047`},
					Height -> {6.2153134297`*^6, 1.39771394297`*^7, 1.8635460547`*^6,
						779062.4297`, 949170.9922`, 1.5806918047`*^6},
					HalfHeightWidth -> {0.0049000000000001265`, 0.0039000000000000146`,
						0.006899999999999906`, 0.006899999999999906`,
						0.005899999999999572`, 0.008800000000000807`},
					Area -> {40041.875306150076`, 88628.26314371504`,
						17648.994055090036`, 7451.247840730065`, 7781.679006965024`,
						17431.47470118017`},
					PeakRangeStart -> {1.3092`, 1.3405`, 3.9146`, 4.1202`, 4.4168`,
						4.5841`},
					PeakRangeEnd -> {1.3405`, 1.3806`, 3.9558`, 4.1505`, 4.45`,
						4.6321`},
					WidthRangeStart -> {1.3356`, 1.3435`, 3.9293`, 4.1329`, 4.4275`,
						4.6008`},
					WidthRangeEnd -> {1.3405`, 1.3474`, 3.9362`, 4.1398`, 4.4334`,
						4.6096`},
					BaselineIntercept -> {55678.5703`, 55678.5703`, 55678.5703`,
						55678.5703`, 55678.5703`, 55678.5703`},
					BaselineSlope -> {0.`, 0.`, 0.`, 0.`, 0.`, 0.`},
					TangentWidthLines -> {}, TangentWidthLineRanges -> {},
					TangentNumberOfPlates -> {}, TangentResolution -> {},
					TailingFactor -> {}, RelativeArea -> {}, RelativePosition -> {},
					PeakLabel -> {}, TangentWidth -> {}, HalfHeightResolution -> {},
					HalfHeightNumberOfPlates -> {}|>, <|
					Type -> Object[Analysis, Peaks],
					BaselineFunction -> Function[x, 76665.0625`],
					Position -> {5.3035`}, Height -> {498859.9375`},
					HalfHeightWidth -> {0.009799999999999365`},
					Area -> {5497.127402564969`}, PeakRangeStart -> {5.2869`},
					PeakRangeEnd -> {5.3172`}, WidthRangeStart -> {5.2986`},
					WidthRangeEnd -> {5.3084`}, BaselineIntercept -> {76665.0625`},
					BaselineSlope -> {0.`}, TangentWidthLines -> {},
					TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {},
					TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {},
					RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {},
					HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {}|>, <|
					Type -> Object[Analysis, Peaks],
					BaselineFunction -> Function[x, 54241.0195`],
					Position -> {2.47`, 3.2863`, 3.6788`},
					Height -> {4.4151339805`*^6, 4.5277364805`*^6, 911798.418`},
					HalfHeightWidth -> {0.02059999999999995`, 0.014699999999999935`,
						0.01949999999999985`},
					Area -> {96259.93406636003`, 67483.85401930462`,
						18210.267774940028`},
					PeakRangeStart -> {2.4416`, 3.2648`, 3.6582`},
					PeakRangeEnd -> {2.4964`, 3.3019`, 3.6993`},
					WidthRangeStart -> {2.4602`, 3.2765`, 3.67`},
					WidthRangeEnd -> {2.4808`, 3.2912`, 3.6895`},
					BaselineIntercept -> {54241.0195`, 54241.0195`, 54241.0195`},
					BaselineSlope -> {0.`, 0.`, 0.`}, TangentWidthLines -> {},
					TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {},
					TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {},
					RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {},
					HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {}|>}
			],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Map,"Plot each spectra on a separate plot:"},
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]}],Map->True],
			{_?ValidGraphicsQ..}
		],
		
		Example[
			{Options,Boxes,"Use swatch boxes instead of lines in the legend:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},Boxes->True],
			_?Core`Private`ValidLegendedQ
		],

		Example[
			{Options,Legend,"Display a custom legend:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},
				Legend->{"Data 1", "Data 2"}
			],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options,PlotRange,"Specify plot range:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],PlotRange->{{2,5},Automatic}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Normalize,"Rescale all spectras to the maximum value:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},Normalize->1.4*10^7*ArbitraryUnit],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options,Units,"Specify the units of the input data:"},
			PlotNMR[Download[Object[Data, NMR, "id:pZx9jonGr7RM"],NMRSpectrum],Units->{NMRSpectrum->{PPM,ArbitraryUnit}}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotType,"Plot a group of spectra data as independent contours in a waterfall:"},
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]}],PlotType->WaterfallPlot],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,Zoomable,"Toggle the interactive zoom feature:"},
			PlotNMR[Object[Data,NMR,"id:pZx9jonGr7RM"],Zoomable->False],
			g_/;ValidGraphicsQ[g]&&Length@Cases[{g},ZoomableP,-1]==0
		],

		Example[
			{Options,PlotLabel,"Set the caption displayed above the plot:"},
			PlotNMR[Object[Data,NMR,"id:pZx9jonGr7RM"],PlotLabel->"Example title"],
			_?ValidGraphicsQ
		],

		Example[
			{Options,FrameLabel,"Set the text displayed on each axis:"},
			PlotNMR[Object[Data,NMR,"id:pZx9jonGr7RM"],FrameLabel->{"Example axis label"}],
			_?ValidGraphicsQ
		],

		Example[
			{Options,Reflected,"Specify whether the x-axis orientation should be inverted:"},
			PlotNMR[Object[Data,NMR,"id:pZx9jonGr7RM"],Reflected->False],
			_?ValidGraphicsQ
		],

		Example[
			{Options,LegendPlacement,"Specify where curve labels are displayed:"},
			PlotNMR[{Object[Data,NMR,"id:pZx9jonGr7RM"],Object[Data,NMR,"id:aXRlGnZm8OK9"],Object[Data,NMR,"id:Vrbp1jG8Zd9o"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
				
		Example[
			{Messages, "WaterfallAxisFillingNotSupported", "Set Filling to Axis when PlotType is set to WaterfallPlot:"},
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]}],PlotType->WaterfallPlot,Filling->Axis],
			_?ValidGraphicsQ,
			Messages:>Warning::WaterfallAxisFillingNotSupported
		],
		Test[
			"Displays Peaks data if avaliable:",
			PlotNMR[Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},NMRSpectrum],
				Display->{Peaks}
			],
			_?ValidGraphicsQ
		],
		Test[
			"Specify the units for each axis:",
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},TargetUnits->{Micro PPM,Milli ArbitraryUnit}],
			_?ValidGraphicsQ
		],
		Test[
			"Plot each spectra separately when given NMR data objects:",
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},Map->True],
			_List
		],
		Test[
			"Given a packet:",
			PlotNMR[Download[Object[Data, NMR, "id:pZx9jonGr7RM"]]],
			_?ValidGraphicsQ
		],
		Test[
			"Plot each spectra separately when given NMR data info packets:",
			PlotNMR[(Download[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},NMRSpectrum]),Map->True],
			_List
		],
		Test[
			"Plot multiple spectra when given NMR data objects:",
			PlotNMR[{{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"]},{Object[Data, NMR, "id:Vrbp1jG8Zd9o"]}}],
			_List
		],
		
		Example[
			{Options,Scale,"Log-transform the spectra:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Scale->Log],
			_?ValidGraphicsQ
		],

		Example[
			{Options,Filling,"Toggle the filling under each spectrum line:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Filling->None],
			_?ValidGraphicsQ
		],
				
		Example[
			{Options,ScaleX,"Specify the x-axis margin padding:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],ScaleX->1.25],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,ScaleY,"Specify the y-axis margin padding:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],ScaleY->1.25],
			_?ValidGraphicsQ
		],

		Example[
			{Options,GridLines,"Specify where lines are overlayed on the plot:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],GridLines->{Table[x,{x,-12.5,0,2.5}],{5*10^6,10^7}}],
			_?ValidGraphicsQ
		],

		Example[
			{Options,GridLinesStyle,"Specify the format of lines overlayed on the plot:"},
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],GridLines->Automatic,GridLinesStyle->Red],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,FrameStyle,"Specify how the axes and tick labels are formatted:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},FrameStyle->Directive[Red,Thick]],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,FrameTicksStyle,"Specify only how tick labels are formatted:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},FrameTicksStyle->Directive[Red]],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,FrameTicks,"Toggle the display of tick marks:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},FrameTicks->None],
			_?ValidGraphicsQ
		],
		
		(* Peaks/Fractions/Ladder options *)
		Example[
			{Options,PeakLabels,"Directly specify peak labels to be overlayed on the plot:"},
			peaks=Object[Analysis,Peaks,"id:aXRlGnZmwPeB"];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Peaks->peaks,PeakLabels->Characters["ABCDE"]],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,PeakLabelStyle,"Specify how the peak labels are formatted:"},
			peaks=Object[Analysis,Peaks,"id:aXRlGnZmwPeB"];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Peaks->peaks,PeakLabels->Characters["ABCDE"],PeakLabelStyle->{14,Darker[Green],FontFamily->"Arial"}],
			_?ValidGraphicsQ
		],		
				
		Example[
			{Options,Fractions,"Specify fractions for the spectra:"},
			fractions=MapIndexed[{#1,#1+0.25 PPM,"A"<>ToString@First@#2}&,Range[-2.5 PPM,-1 PPM, 0.25 PPM]];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Fractions->fractions],
			_?ValidGraphicsQ
		],

		Example[
			{Options,FractionColor,"Specify fraction color:"},
			fractions=MapIndexed[{#1,#1+0.25 PPM,"A"<>ToString@First@#2}&,Range[-2.5 PPM,-1 PPM, 0.25 PPM]];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Fractions->fractions,FractionColor->Blue],
			_?ValidGraphicsQ
		],

		Example[
			{Options,FractionHighlights,"Specify fractions and fraction highlights for the spectra:"},
			fractions=MapIndexed[{#1,#1+0.25 PPM,"A"<>ToString@First@#2}&,Range[-2.5 PPM,-1 PPM, 0.25 PPM]];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Fractions->fractions,FractionHighlights->fractions[[3;;4]]],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,FractionHighlightColor,"Specify the color of fraction highlights:"},
			fractions=MapIndexed[{#1,#1+0.25 PPM,"A"<>ToString@First@#2}&,Range[-2.5 PPM,-1 PPM, 0.25 PPM]];
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Fractions->fractions,FractionHighlights->fractions[[3;;4]],FractionHighlightColor->Orange],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,Ladder,"Specify ladder sizes for the spectra:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"]},Ladder->{{1,-7.2679 PPM},{5,-3.9323 PPM},{25,-1.3454 PPM}}],
			_?ValidGraphicsQ
		],		
		
		(* WaterfallPlot options *)
		Example[
			{Options,LabelField,"When PlotType is set to WaterfallPlot, LabelField sets the object field used to annotate each contour:"},
			PlotNMR[{Object[Data, NMR, "id:pZx9jonGr7RM"],Object[Data, NMR, "id:aXRlGnZm8OK9"],Object[Data, NMR, "id:Vrbp1jG8Zd9o"]},PlotType->WaterfallPlot,LabelField->ID],
			g_/;ValidGraphicsQ[g]&&MatchQ[First@Cases[First@g,_Text,-1][[1,1,1]],"id:pZx9jonGr7RM"],
			Messages:>{Warning::NonNumericLabelField}
		],
		
		Example[
			{Options,ContourLabels,"When PlotType is set to WaterfallPlot, setting ContourLabels to a list of strings directly sets the annotation text:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ContourLabels->Characters["ABCD"]],
			g_/;ValidGraphicsQ[g]&&MatchQ[Cases[g,_Text,-1][[1,1,1,1]],"A"]
		],

		Example[
			{Options,ContourLabels,"When PlotType is set to WaterfallPlot, setting ContourLabels to None hides the annotations:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ContourLabels->None],
			g_/;ValidGraphicsQ[g]&&Length@Cases[First@g,_Text]==0
		],
		
		Example[
			{Options,ContourLabelStyle,"When PlotType is set to WaterfallPlot, setting ContourLabelStyle to a list of directives formats each annotation:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ContourLabelStyle->{Red,Large}],
			g_/;ValidGraphicsQ[g]&&MatchQ[First@Cases[g,_Text,-1][[All,1,2,1]],Red]
		],
		
		Example[
			{Options,ContourLabelPositions,"When PlotType is set to WaterfallPlot, ContourLabelPositions specifies where each annotation is placed relative to the contours:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ContourLabelPositions->Before],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options, WaterfallProjection,"When PlotType is set to WaterfallPlot and WaterfallProjection is set to Orthographic, depth is visualized isometrically:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],WaterfallProjection->Orthographic],
			g_/;ValidGraphicsQ[g]&&SameQ[ViewProjection/.Options@g,"Orthographic"]
		],
		
		Example[
			{Options,WaterfallProjection,"When PlotType is set to WaterfallPlot and WaterfallProjection is set to Parallel, Depth is visualized using an oblique cabinet projection:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],WaterfallProjection->Parallel],
			g_/;ValidGraphicsQ[g]&&MatchQ[ViewMatrix/.Options@g,{_List,_List}]
		],
				
		Example[{Options,ProjectionDepth,"When PlotType is set to WaterfallPlot, ProjectionDepth sets the spacing between contours:"},
			Manipulate[
				PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ProjectionDepth->depth],
				{{depth,1,"ProjectionDepth"},0.1,3}
			],
			_Manipulate
		],

		Example[{Options,ProjectionAngle,"When PlotType is set to WaterfallPlot and WaterfallProjection is set to Parallel, ProjectionAngle sets the angle between the X and Z axes:"},
			Manipulate[
				PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],WaterfallProjection->Parallel,ProjectionAngle->angle],
				{{angle,Pi/6,"ProjectionAngle"},0,Pi/3}
			],
			_Manipulate
		],
	
		Example[
			{Options,ViewPoint,"When PlotType is set to WaterfallPlot, ViewPoint specifies the position of the observer with respect to the plot:"},
			PlotNMR[Object[Data,NMR,"id:7X104vnMY0PZ"],ViewPoint->{1.5,0,.1}],
			g_/;ValidGraphicsQ[g]&&SameQ[(ViewPoint/.Last@g),{1.5,0,.1}]
		],
		
		(* Waterfall Axes options *)
		Example[
			{Options,Axes,"When PlotType is set to WaterfallPlot, Axes specifies which axis lines and tick marks are displayed:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"],Axes->{True,True,True}],
			_?ValidGraphicsQ
		],

		Example[
			{Options,AxesEdge,"When PlotType is set to WaterfallPlot, AxesEdge specifies where the axis lines and tick marks are displayed:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"],Axes->True,AxesEdge->{{-1,-1},{1,-1},{1,-1}}],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,AxesStyle,"When PlotType is set to WaterfallPlot, AxesStyle specifies how the axis lines and tick marks are formatted:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"],AxesStyle->Directive[Red, Thick]],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,AxesLabel,"When PlotType is set to WaterfallPlot, AxesLabel specifies the text displayed beside each axis:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"],Axes->True,AxesLabel->{"Z label","X label","Y label"}],
			_?ValidGraphicsQ
		],
		
		Example[
			{Options,AxesUnits,"When PlotType is set to WaterfallPlot, AxesUnits specifies the units appended to each axis label:"},
			PlotNMR[Object[Data, NMR, "id:7X104vnMY0PZ"],Axes->{False,True,True},AxesUnits->{Automatic,PPB,None}],
			_?ValidGraphicsQ
		],
		
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->Result],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->Preview],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns the resolved options:",
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotNMR]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotNMR]]
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotNMR[Download[Object[Data, NMR, "id:pZx9jonGr7RM"],NMRSpectrum],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotNMR]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotNMR[Object[Data, NMR, "id:pZx9jonGr7RM"],Output->Options],
			Sort@Keys@SafeOptions@PlotNMR,
			TimeConstraint->120
		]
				
	},
	SymbolSetUp :> (

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allObjects, existingObjects, protocol1, data1
			},

			(* All data objects generated for unit tests *)

			allObjects=
				{
					Object[Protocol, NMR, "NMR Protocol For PlotNMR Test " <> $SessionUUID],
					Object[Data, NMR, "NMR Data For PlotNMR Test " <> $SessionUUID]
				};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			{protocol1, data1} = CreateID[{Object[Protocol, NMR], Object[Data, NMR]}];

			Upload[
				<|
					Name -> "NMR Data For PlotNMR Test " <> $SessionUUID,
					Object -> data1,
					Type -> Object[Data, NMR],
					NMRSpectrum -> QuantityArray[{#, RandomReal[50000]} & /@ Reverse[Range[-2, 14, 0.001]], {PPM, ArbitraryUnit}]
				|>
			];

			Upload[
				<|
					Name -> "NMR Protocol For PlotNMR Test " <> $SessionUUID,
					Object -> protocol1,
					Type -> Object[Protocol, NMR],
					Replace[Data] -> {Link[data1, Protocol]}
				|>
			];
		];
	),
	SymbolTearDown :> Module[{objects},
		objects = {
			Object[Protocol, NMR, "NMR Protocol For PlotNMR Test " <> $SessionUUID],
			Object[Data, NMR, "NMR Data For PlotNMR Test " <> $SessionUUID]
		};

		EraseObject[
			PickList[objects,DatabaseMemberQ[objects],True],
			Verbose->False,
			Force->True
		]
	]
];
