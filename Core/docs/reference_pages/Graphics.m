(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[Staticize,
	{
		BasicDefinitions -> {
			{"Staticize[expression]", "staticExpression", "attempts to replace all interactive and dynamic elements in 'expression' with static versions containing the current values."}
		},
		Input :> {
			{"expression", _, "An expressions containing interactive and dynamic elements."}
		},
		Output :> {
			{"staticExpression", _, "An expression without any interactive or dynamic elements."}
		},
		SeeAlso -> {
			"Dynamic",
			"DynamicModule"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*AxisLines*)


DefineUsage[AxisLines,
	{
		BasicDefinitions -> {
			{"AxisLines[peakPoints:{{_?NumericQ,_?NumericQ}..},plotRange:{{_?NumericQ,_?NumericQ},{_?NumericQ,_?NumericQ}}]", "lines_Graphics", "draws lines from the peak point(s) to the x and y axes."}
		},
		Input :> {
			{"peakPoints", _, "The {x,y} location for each peak."},
			{"plotRange", _, "The plot range where the graphic(s) will be included."}
		},
		Output :> {
			{"lines", _, "Graphic that draws lines from the peak point(s) to the axes."}
		},
		SeeAlso -> {
			"secondYAxisTicksAndGraphics",
			"ErrorBar"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*ColorFade*)


DefineUsage[ColorFade,
	{
		BasicDefinitions -> {
			{"ColorFade[color,n]", "fade", "generates a list 'n' colors that fade from the dark 'color' to light 'color'."},
			{"ColorFade[colors, n]", "fade", "generates a list 'n' colors that fade from the start color in the list to the end color in the list."}
		},
		Input :> {
			{"n", _Integer, "The number of colors to produce."},
			{"colors", {_?ColorQ..}, "The colors to be blended (in order from first to last) to generate the fade."},
			{"color", _?ColorQ, "The single to be blended from light to dark to generate the fade."}
		},
		Output :> {
			{"fade", {_?ColorQ..}, "List of colors that fade between the provided color or colors."}
		},
		SeeAlso -> {
			"ColorQ",
			"Filling"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*EmeraldFrameTicks*)


DefineUsage[EmeraldFrameTicks,
	{
		BasicDefinitions -> {
			{"EmeraldFrameTicks[{startNumber,endNumber}]", "ticks", "automatically generates frame ticks using the provided start and end points for the ticks."},
			{"EmeraldFrameTicks[{startNumber,endNumber},{startLabel,endLabel}]", "ticks", "automatically generates frame ticks using the provided start and end points for the ticks positions, and the start and end Label for the text labels."},
			{"EmeraldFrameTicks[{startNumber,endNumber},{startLabel,endLabel},datas]", "ticks", "automatically generates frame ticks using the provided start and end points for the ticks positions, and the start and end Label for the text labels and the data being ploted (for automatic determination of the ticks)."}
		},
		MoreInformation -> {
			"When log is set to a number, EmeraldFrameTicks assumes its being used to label data that's been taken to the log of that value and that it should plot in log scale."
		},
		Input :> {
			{"startNumber", _?NumericQ, "The numer at which to start the ticks."},
			{"endNumber", _?NumericQ, "The number at which to end the ticks."},
			{"startLabel", _?NumericQ, "The starting label for the major ticks (can be different then 'startNumber'."},
			{"endLabel", _?NumericQ, "The ending label for the major ticks (can be different then the 'endNumber'."},
			{"datas", {CoordinatesP..}, "List of Lists of {x,y} data comprising the plot that the frame ticks will be included on."}
		},
		Output :> {
			{"ticks", _, "Formated frame ticks for an individual axis."}
		},
		SeeAlso -> {
			"ErrorBar",
			"AxisLines"
		},
		Author -> {
			"Frezza",
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*EmeraldPlotMarkers*)


DefineUsage[EmeraldPlotMarkers,
	{
		BasicDefinitions -> {
			{"EmeraldPlotMarkers[]", "markers", "returns the list of plot markers used by mathematica when you use PlotMarkers->Automatic."},
			{"EmeraldPlotMarkers[n]", "marker", "returns the nth marker in the plot marker list.  If n >10, returns EmeraldPlotMarkers[Mod[n,10]]."}
		},
		Input :> {
			{"n", _Integer, "Index of plot marker to return."}
		},
		Output :> {
			{"markers", {_String..}, "List of string symbols that can be used as plot markers."},
			{"marker", _String, "A single plot marker symbol."}
		},
		SeeAlso -> {
			"EmeraldListLinePlot",
			"PlotMarkers"
		},
		Author -> {"scicomp", "brad", "hayley"}
	}];


(* ::Subsubsection::Closed:: *)
(*ErrorBar*)


DefineUsage[ErrorBar,
	{
		BasicDefinitions -> {{"ErrorBar[{point:{(_?NumericQ|DateListP),_?NumericQ},error:(_?NumericQ|DateListP)}]", "bar_Graphics", "provies the graphic representation of an error bar by extending error in either direction from a central point."},
			{"ErrorBar[{startPoint:{(_?NumericQ|DateListP),_?NumericQ},endPoint:{(_?NumericQ|DateListP),_?NumericQ}}]", "bar_Graphics", "provides the graphic representation of an error bar from a given start point to a given end point."}
		},
		Input :> {
			{"startPoint", _, "The starting point of an error bar."},
			{"endPoint", _, "The ending point of an error bar."},
			{"point", _, "The central point of an error bar."},
			{"error", _, "The error on either side of a 'point'."}
		},
		Output :> {
			{"bar", _, "Graphical representation of an error bar."}
		},
		SeeAlso -> {
			"EmeraldFrameTicks",
			"AxisLines"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*fillingFade*)


DefineUsage[fillingFade,
	{
		BasicDefinitions -> {
			{"fillingFade[color_RGBColor, n_Integer]", "colors:{_RGBColor..}", "generates a list of 'n' filling style colors that fade from the dark 'color' to light 'color'."},
			{"fillingFade[colors:{_RGBColor..}, n_Integer]", "colors:{_RGBColor..}", "generates a list 'n' filling style colors that fade from the start color in the list to the end color in the list."}
		},
		Input :> {
			{"n", _Integer, "The number of colors to produce."},
			{"colors", {_RGBColor..}, "The colors to be blended (in order from first to last) to generate the fade."},
			{"color", _RGBColor, "The single to be blended from light to dark to generate the fade."}
		},
		Output :> {
			{"colors", {_RGBColor..}, "List of colors."}
		},
		SeeAlso -> {
			"ColorQ",
			"ColorFade"
		},
		Author -> {
			"frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*fractionEpilog*)


DefineUsage[fractionEpilog,
	{
		BasicDefinitions -> {
			{"fractionEpilog[fractionData]", "epilog", "generates an epilog graphic for denoting the information derived from fractions."}
		},
		Input :> {
			{"plotData", _, "The data being ploted from which the peaks will come."},
			{"fractionData", {{_?NumericQ, _?NumericQ, _String}..}, "The fractionData as determine by the fractions."}
		},
		Output :> {
			{"epilog", _Graphics, "Pictographic documentation of the fractions to be overlaied on a plot."}
		},
		SeeAlso -> {
			"PeakEpilog",
			"secondYEpilog"
		},
		Author -> {
			"frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*resolvePlotLegends*)


DefineUsage[resolvePlotLegends,
	{
		BasicDefinitions -> {
			{"resolvePlotLegends[labels]", "legend", "formats a legend specification for the PlotLegends option."}
		},
		MoreInformation -> {
			""
		},
		Input :> {
			{"labels", {_String..}, "Labels for the legend."}
		},
		Output :> {
			{"legend", _Placed, "Legend specification that can be used as a value for the PlotLegends option in a plotting function."}
		},
		SeeAlso -> {
			"PlotLegends",
			"PlotWestern"
		},
		Author -> {"scicomp", "brad", "hayley"}
	}];


(* ::Subsubsection::Closed:: *)
(*secondYEpilog*)


DefineUsage[secondYEpilog,
	{
		BasicDefinitions -> {
			{"secondYEpilog[plotData,type,{newYMin,newYMax}]", "epilog", "returns a graphics primitive that can be placed on top of a graph to show additional data."}
		},
		MoreInformation -> {
			"Providing a list of values will delete the duplicates and provide a color fade from light to dark on the remaining unique, not Null plotData."
		},
		Input :> {
			{"plotData", {{_?NumericQ, _?NumericQ}..}, "The data you wish to plot on the second y axes."},
			{"type", Symbol, "The symbol used in the display option to provide the epilog."},
			{"newYMin", _, "The minimum of the second Y axes label (Automatic is acceptable)."},
			{"newYMax", _, "The maximum of the second Y axes label (Automatic is acceptable)."}
		},
		Output :> {
			{"epilog", _List, "An epilog that provides a trace of values."}
		},
		SeeAlso -> {
			"PeakEpilog",
			"fractionEpilog"
		},
		Author -> {
			"frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*Unzoomable*)


DefineUsage[Unzoomable,
	{
		BasicDefinitions -> {
			{"Unzoomable[inPlot]", "outPlot", "transforms 'inPlot', which is the output of the function 'Zoomable', into a static Graphics image."},
			{"Unzoomable[construct]", "outConstruct", "applies Unzoomable to anything Zoomable inside any construct, such as a Grid or a Row."},
			{"Unzoomable[graphic]", "graphic", "returns input 'graphic' if it is already a _Graphics."}
		},
		Input :> {
			{"inPlot", _DynamicModule, "The output of the function 'Zoomable'."},
			{"construct", _, "Any expression, possibly containing Zoomable elements."},
			{"graphic", _Graphics, "A static Graphics plot."}
		},
		Output :> {
			{"outPlot", _Graphics, "A static Graphics plot."},
			{"outConstruct", _, "A construct containing no Zoomable elements."},
			{"graphic", _Graphics, "A static Graphics plot."}
		},
		SeeAlso -> {
			"Zoomable",
			"plot"
		},
		Author -> {"scicomp", "brad", "robert"}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidGraphicsQ*)


DefineUsage[ValidGraphicsQ,
	{
		BasicDefinitions -> {
			{"ValidGraphicsQ[g]", "bool", "check if g is a valid _Graphics (e.g. no error showing over the graphic)."},
			{"ValidGraphicsQ[g,ops]", "bool", "also checks that specified options match those in the graphic."},
			{"ValidGraphicsQ[zoomPlot]", "bool", "check if a plot produced by Zoomable is a valid graphic."}
		},
		Input :> {
			{"g", _Graphics | _Graphics3D, "A graphics object to check."},
			{"ops", _Rule | {___Rule}, "Option rules to check against the options stored in the graphic."},
			{"zoomPlot", _DynamicModule, "Output of Zoomable function."}
		},
		Output :> {
			{"bool", BooleanP, "True if g contains valid overlays, otherwise False."}
		},
		SeeAlso -> {
			"ValidGraphicsP",
			"Graphics",
			"Plot"
		},
		Author -> {"scicomp", "brad"}
	}];



DefineUsage[ValidGraphicsP,
	{
		BasicDefinitions -> {
			{"ValidGraphicsP[]", "pattern", "returns a pattern that matches on valid graphics."},
			{"ValidGraphicsP[ops]", "bool", "returns a pattern that also checks that the graphic's options match ops."}
		},
		Input :> {
			{"ops", _Rule | {___Rule}, "Option rules to check against the options stored in the graphic."}
		},
		Output :> {
			{"pattern", _, "A pattern that matches valid graphics."}
		},
		SeeAlso -> {
			"ValidGraphicsQ",
			"Graphics",
			"Plot"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*Zoomable*)


DefineUsage[Zoomable,
	{
		BasicDefinitions -> {
			{"Zoomable[inPlot]", "outPlot", "enables zooming and panning on a graphics or image object."}
		},
		MoreInformation -> {
			"This function allows a plot's Plot Range to be dynamically manipulated at the front end. To zoom, left-click and drag over the region of interest or scroll in and out on the mouse wheel. To reset to default plot range, left click once.",
			"To pan the image, hold the Shift key and then left-click and drag on the image."
		},
		Input :> {
			{"inPlot", _Graphics, "An input graphic."}
		},
		Output :> {
			{"outPlot", _DynamicModule, "A Zoomable output graphic."}
		},
		SeeAlso -> {
			"plot",
			"Unzoomable"
		},
		Author -> {
			"SciComp",
			"robert"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FullPlotRange*)


DefineUsage[FullPlotRange,
	{
		BasicDefinitions -> {
			{"FullPlotRange[range]", "fullRange", "expands a shorthand 'range' input into a list of four elements in the form {{x-min,x-max},{y-min,y-max}}."}
		},
		Input :> {
			{"range", _List | All | Automatic | Full, "The shorthand range specification to expand."}
		},
		Output :> {
			{"fullRange", {{_, _}, {_, _}}, "A full form range specification containing four elements defining the x and y ranges, with any references to All, Automatic, or Full filled into each slot."}
		},
		SeeAlso -> {
			"ListLinePlot",
			"FindPlotRange",
			"PlotRange"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*Core`Private`ValidLegendedQ*)


DefineUsage[Core`Private`ValidLegendedQ,
	{
		BasicDefinitions -> {
			{"Core`Private`ValidLegendedQ[g]", "bool", "check if g has a valid legend."},
			{"Core`Private`ValidLegendedQ[zoomPlot]", "bool", "check if a plot produced by Zoomable has a valid legend."}
		},
		Input :> {
			{"g", _Legended, "A legended object to check."},
			{"zoomPlot", _DynamicModule, "Output of Zoomable function."}
		},
		Output :> {
			{"bool", BooleanP, "True if g contains a valid legend, otherwise False."}
		},
		SeeAlso -> {
			"ValidGraphicsQ",
			"Legended"
		},
		Author -> {"scicomp", "brad"}
	}];


DefineUsage[Staticize,
	{
		BasicDefinitions -> {
			{"Staticize[expression]", "staticExpression", "attempts to replace all interactive and dynamic elements in 'expression' with static versions containing the current values."}
		},
		Input :> {
			{"expression", _, "An expressions containing interactive and dynamic elements."}
		},
		Output :> {
			{"staticExpression", _, "An expression without any interactive or dynamic elements."}
		},
		SeeAlso -> {
			"Dynamic",
			"DynamicModule"
		},
		Author -> {
			"scicomp"
		}
	}];
