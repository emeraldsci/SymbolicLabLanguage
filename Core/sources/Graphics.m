(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Graphics Testing*)

(* InteractiveImageP *)
InteractiveImageP = Alternatives[
	
	(*With ScrollZoom*)
	HoldPattern[
		DynamicModule[_List,
			DynamicModule[_List,
				EventHandler[Pane[Grid[{{Graphics[{


					(*AutoDownsampling*)
					DynamicModule[_List,
						DynamicBox[
							SciCompFramework`Private`rasterBoxDownsamplingFunction[
								SciCompFramework`Private`zoomFactor][_NumericArray],
							___], ___] |

						(*No AutoDownsampling*)
						RasterBox[_NumericArray, _],

					___}, ___], ___}, ___}, ___],
					___], ___], ___], ___]],
	
	
	(*Without ScrollZoom*)
	HoldPattern[
		DynamicModule[_List,
			Graphics[{
				(*AutoDownsampling*)
				DynamicModule[_List,
					DynamicBox[
						SciCompFramework`Private`rasterBoxDownsamplingFunction[
							SciCompFramework`Private`zoomFactor][_NumericArray],
						___], ___] |

					(*No AutoDownsampling*)
					RasterBox[_NumericArray, _],
				___}, ___], ___]]

];

(* ZoomableP *)
ZoomableP=Alternatives[
	(* Scroll Zoom Overload *)
	HoldPattern[
		DynamicModule[_List,
			DynamicModule[_List,
				EventHandler[Pane[Grid[{{_Graphics, ___}, ___}, ___], ___], ___], ___], ___]] /; ECL`$CCD,

	(* Original Zoomable Overload *)
	HoldPattern[DynamicModule[_List, EventHandler[Dynamic[_Graphics], ___], ___]]
];

(* ::Subsubsection::Closed:: *)
(*ValidOutputQ*)

ValidOutputQ[x_]:=Module[
	{nb, result},

	UsingFrontEnd[
		nb = NotebookPut[Notebook[{Cell[BoxData[ToBoxes[x, StandardForm]]]}, Visible -> False]];
		SelectionMove[nb, All, Notebook];
		result =! FrontEndExecute[FrontEnd`ErrorIconIsDisplayedPacket[nb]];
		NotebookClose[nb];
		result
	]

]/; Not[TrueQ[$CloudConnected]];


ValidOutputQ[g_]:=Module[{overlayGraphics, graphicsData, graphicColors},

	(* extract all the Epilog and Prolog graphics as data *)
	overlayGraphics=Cases[g, Rule[(Epilog | Prolog), rhs_] :> Graphics[rhs], Infinity];

	(* get the image data from all the graphics *)
	graphicsData=Flatten[Rasterize[#, "Data"], 1]& /@ Prepend[overlayGraphics, g];

	(* pull the most frequently occurring RGB value from all the points *)
	graphicColors=Table[Sort[Tally[one], #1[[2]] > #2[[2]]&][[1, 1]], {one, graphicsData}];

	(* Check if any of the graphics are mostly the evil error color *)
	Apply[
		And,
		Map[
			!errorColorQ[#]&,
			graphicColors
		]
	]
]/;True; (*TrueQ[$CloudConnected]; *)



errorColorQ[color:{_Integer, _Integer, _Integer}]:=MemberQ[
	{
		(*OSX*)
		{255, 230, 230},
		(* MM 13.2 *)
		{255, 242, 242},
		(*Windows*)
		{255, 239, 239},
		{255, 231, 231},
		(*Linux*)
		{255, 84, 84}
	},
	color
];

SetAttributes[ValidOutputQ, Listable];

(* ::Subsubsection::Closed:: *)

(*InteractiveImage*)
ValidGraphicsQ::InvalidOptions="Cannot check the options `1`";

ValidGraphicsQ[d:InteractiveImageP] := True;

ValidGraphicsQ[d:ZoomableP] := ValidGraphicsQ[Unzoomable[d]];

(* should remove _Legended from this pattern *)
ValidGraphicsQ[g:(_Graphics | _Graphics3D | _Legended)]:=ValidOutputQ[g];
ValidGraphicsQ[_]:=False;


ValidGraphicsQ[fig_, ops:(_Rule | {___Rule})]:=Module[{opsList, opNames, opPatts, easyFigOps,
	figOpVals, easyOps, check2, hardOps, hardFigOps, badOps},
	(* check that graphic is OK *)
	If[Not[ValidGraphicsQ[fig]],
		Return[False]
	];

	opsList=ToList[ops];

	(* check the easy ops already in the figure *)
	easyFigOps=fig[[2]];
	easyOps=Intersection[Keys[opsList], Keys[easyFigOps]];
	(* In MM 13.2, PlotRange converts to float, so we have to change everything to float to compare here *)
	(* Notably EmeraldListLinePlot will change the PlotRange so this test will fail if looking for matching options *)
	check2=And @@ Map[MatchQ[N[# /. easyFigOps], N[# /. opsList]]&, easyOps];
	If[Or[check2 === False, Length[easyOps] === Length[ops]],
		Return[check2]
	];

	(* check any options not stored directly in the graphic *)
	hardOps=Complement[Keys[opsList], easyOps];
	hardFigOps=Quiet[Values[AbsoluteOptions[fig, hardOps]]];
	badOps=Complement[Keys[opsList], Keys[easyFigOps], Keys[hardFigOps]];
	If[Length[badOps] > 0,
		Message[ValidGraphicsQ::InvalidOptions, badOps]
	];
	And @@ Map[MatchQ[# /. hardFigOps, # /. opsList]&, Complement[hardOps, badOps]]

];

ValidGraphicsQ[in_List]:=Map[ValidGraphicsQ, in];
ValidGraphicsQ[in_List, ops:(_Rule | {___Rule})]:=Map[ValidGraphicsQ[#, ops]&, in];



(* ::Subsubsection::Closed:: *)
(*ValidGraphicsP[]*)


ValidGraphicsP[]:=_?ValidGraphicsQ;
ValidGraphicsP[args__]:=_?(ValidGraphicsQ[#, args]&);



(* ::Subsubsection::Closed:: *)
(*ValidLegendedQ*)


ValidLegendedQ[d:HoldPattern[DynamicModule[_List, EventHandler[Dynamic[_Graphics], ___], ___]]]:=ValidLegendedQ[Unzoomable[d]];
ValidLegendedQ[Legended[g_, leg_]]:=ValidGraphicsQ[g];
ValidLegendedQ[_]:=False;

SetAttributes[ValidLegendedQ, Listable];




(* ::Subsection::Closed:: *)
(*Graphics Option Helpers*)


(* ::Subsubsection::Closed:: *)
(*EmeraldPlotMarkers*)


EmeraldPlotMarkers[]:={"\[FilledCircle]", "\[FilledSquare]", "\[FilledDiamond]", "\[FilledUpTriangle]", "\[FilledDownTriangle]", "\[EmptyCircle]", "\[EmptySquare]", "\[EmptyDiamond]", "\[EmptyUpTriangle]", "\[EmptyDownTriangle]"};
EmeraldPlotMarkers[n:(_Integer | {_Integer..})]:=EmeraldPlotMarkers[][[Mod[n, 10]]];


(* ::Subsubsection::Closed:: *)
(*ColorFade*)


ColorFade[colors:{(_RGBColor | _GrayLevel | _Hue | _CMYKColor), (_RGBColor | _GrayLevel | _Hue | _CMYKColor)..}, n:1]:=N[{Blend[colors, 1 / 2]}];
ColorFade[color:(_RGBColor | _GrayLevel | _Hue | _CMYKColor) | {(_RGBColor | _GrayLevel | _Hue | _CMYKColor)}, n_Integer/;n > 0]:=N[Rest[Most[ColorFade[{Black, (color /. {x_} :> x), White}, n + 2]]]];
ColorFade[colors:{(_RGBColor | _GrayLevel | _Hue | _CMYKColor)..}, n_Integer/;n > 0]:=N[Table[Blend[colors, (i - 1) / (n - 1)], {i, 1, n}]];


(* ::Subsubsection::Closed:: *)
(*fillingFade*)


DefineOptions[fillingFade,
	Options :> {
		{Opacity -> 0.1, _Real, "The opacity at which to color in each filling style."}
	}];


Options[fillingFade]={Opacity -> 0.1};
fillingFade[color:(_RGBColor | _GrayLevel | _Hue | _CMYKColor) | {(_RGBColor | _GrayLevel | _Hue | _CMYKColor)}, n_Integer/;n > 0, ops:OptionsPattern[fillingFade]]:=MapIndexed[(First[#2] -> Directive[Opacity[OptionValue[Opacity]], #1])&, Rest[Most[ColorFade[{Black, (color /. {x_} :> x), White}, n + 2]]]];
fillingFade[colors:{(_RGBColor | _GrayLevel | _Hue | _CMYKColor)..}, n_Integer/;n > 0, ops:OptionsPattern[fillingFade]]:=MapIndexed[(First[#2] -> Directive[Opacity[OptionValue[Opacity], #1]])&, Table[Blend[colors, (i - 1) / (n - 1)], {i, 1, n}]];
fillingFade[colors:{(_RGBColor | _GrayLevel | _Hue | _CMYKColor)..}, n_Integer/;n == 1, ops:OptionsPattern[fillingFade]]:=MapIndexed[(First[#2] -> Directive[Opacity[OptionValue[Opacity]], #1])&, {Blend[colors, 1 / 2]}];


(* ::Subsubsection::Closed:: *)
(*EmeraldFrameTicks*)


DefineOptions[EmeraldFrameTicks,
	Options :> {
		{MajorTicks -> 5, _Integer, "Number of major (labeled) ticks to include."},
		{MinorTicks -> 25, _Integer, "Number of minor (unlabeled) ticks to include."},
		{MajorTickSize -> 0.01, _Real, "Relative size of the Major tick marks."},
		{MinorTickSize -> 0.005, _Real, "Relative size of the Minor tick marks."},
		{Log -> None, None | _?NumericQ, "If Log is none, standard linear ticks are used.  If Log -> a number then log scale ticks are used with log as the base.  In this case, startNumber and endNumber should match the PlotRange plotted."},
		{SignificantFigures -> 3, _Integer, "Number of significant figures to include.", Category -> Hidden},
		{Round -> False, BooleanP, "Round the numbers next to the ticks.", Category -> Hidden}
	}
];


(* Non-existing span returns nothing rather than crashing *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, ___]:={}/;startNumber == endNumber;

(* Automatic Labeling matches the actual position of the ticks *)
EmeraldFrameTicks[{start_?NumericQ, end_?NumericQ}, ops:OptionsPattern[EmeraldFrameTicks]]:=EmeraldFrameTicks[{start, end}, {start, end}, ops];

EmeraldFrameTicks[{y1min,y1max},{y2min*scaleMin,y2max*scaleMax}]

(* --- Core Function: Linear --- *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, {startLabel_?NumericQ, endLabel_?NumericQ}, ops:OptionsPattern[EmeraldFrameTicks]]:=Module[
	{roundNumber, roundNumberLabel, roundMajorTickNumber, majorTickIncrement, majorTickLabelIncrement, majorTickSize, minorTickSize, majorTicks, minorTickIncrement, minorTicks},

	(*round factor is the cleanest number to round to*)
	roundNumber=10^Round[N[Log[10, (endNumber - startNumber) / OptionValue[MajorTicks]]]] / 2;
	roundNumberLabel=10^Round[N[Log[10, (endLabel - startLabel) / OptionValue[MajorTicks]]]] / 2;

	(* Calculate the size of a single major tick label increment *)
	majorTickLabelIncrement=If[OptionValue[Round],
		Round[(endLabel - startLabel) / OptionValue[MajorTicks], roundNumberLabel],
		(endLabel - startLabel) / OptionValue[MajorTicks]
	];

	(*Rounding may require a slightly different number of ticks*)
	roundMajorTickNumber=Ceiling[(endLabel - startLabel) / majorTickLabelIncrement];

	(* Calculate the size of a single major tickmark increment *)
	(* the end and starts may be adjusted by rounding in the step before. This difference needs to be accounted for here*)
	majorTickIncrement=If[OptionValue[Round],
		((endNumber - startNumber) * (majorTickLabelIncrement) / (endLabel - startLabel)),
		(endNumber - startNumber) / OptionValue[MajorTicks]
	];

	(* Major Tick marks should be this big (formatted the way FrameTicks likes it) *)
	majorTickSize={OptionValue[MajorTickSize], 0};
	(* Note that these tick mark sizes scale with the scaling of the image, so will get bigger and smaller as the image does *)

	correspondingPrimaryData[labelValue_]:=((startNumber-endNumber)/(startLabel-endLabel))*(labelValue-startLabel)+startNumber;

	(* Build the major ticks with labels *)
	majorTicks=If[OptionValue[Round],
		Table[
			{
				(*there is an offset between the ideal start and actual start*)
				correspondingPrimaryData[tickNum*majorTickLabelIncrement+startLabel],
				(* replace non integer ticks with decimals *)
				(Round[startLabel, roundNumberLabel] + tickNum * majorTickLabelIncrement)/.tickValue : Except[_Integer, _?NumericQ]:>N[tickValue],
				majorTickSize
			},
			(*improvise the number of major ticks*)
			{tickNum, 0, roundMajorTickNumber}
		],
		(*else do it exactly as given*)
		Table[
			{
				startNumber + tickNum * majorTickIncrement,
				SignificantFigures[N[startLabel + tickNum majorTickLabelIncrement], OptionValue[SignificantFigures]] // N,
				majorTickSize
			},
			{tickNum, 0, OptionValue[MajorTicks]}
		]
	];

	(* Calculate the size of a single minor tickmark increment *)
	minorTickIncrement=If[OptionValue[Round],
		(majorTickIncrement) * (OptionValue[MajorTicks] / OptionValue[MinorTicks]),
		(endNumber - startNumber) / OptionValue[MinorTicks]
	];

	(* Minor tick marks should be this big (formatted the way FrameTicks likes it) *)
	minorTickSize={OptionValue[MinorTickSize], 0};
	(* Note that these tick mark sizes scale with the scaling of the image, so will get bigger and smaller as the image does *)

	(* Build the minor ticks without labels *)
	minorTicks=If[OptionValue[Round],
		Table[{i, "", minorTickSize}, {i, correspondingPrimaryData[startLabel], correspondingPrimaryData[endLabel], minorTickIncrement}],
		Table[{i, "", minorTickSize}, {i, startNumber, endNumber, minorTickIncrement}]
	];

	(* Join the major with the minor tickmarks *)
	Join[majorTicks, minorTicks]

]/;MatchQ[OptionValue[Log], None];

(* --- Core Function: Log scale --- *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, ops:OptionsPattern[EmeraldFrameTicks]]:=Module[
	{base, majorTickIncrement, majorTickNumber, majorTickLabelIncrement, majorTickSize, majorTicks, endNumberRound, startNumberRound,
		divisionsPerMajorTick, minorTickSize, minorTickPerMajor, allMinorTicks, minorTicks},

	(* Base of the exponent *)
	base=OptionValue[Log];
	startNumberRound=Round[startNumber];
	endNumberRound=Round[endNumber];

	(* Calculate the size of a single major tickmark increment. The max of 1 ensures is at least two major ticks *)
	majorTickIncrement=If[OptionValue[ Round], Max[1, Round[(endNumberRound - startNumberRound) / OptionValue[MajorTicks]]], (endNumber - startNumber) / OptionValue[MajorTicks]];

	(* Calculate the size of a single major tick label increment *)
	majorTickLabelIncrement=If[OptionValue[ Round], Max[1, Round[(endNumberRound - startNumberRound) / OptionValue[MajorTicks]]], (endNumber - startNumber) / OptionValue[MajorTicks]];

	(*the tick number may need an adjustment*)
	majorTickNumber=If[OptionValue[ Round], (endNumberRound - startNumberRound) / majorTickIncrement , OptionValue[MajorTicks]];

	(* Major Tick marks should be this big (formated the way FrameTicks likes it) *)
	majorTickSize={OptionValue[MajorTickSize], 0};
	(* Note that these tick mark sizes scale with the scaling of the image, so will get bigger and smaller as the image does *)

	(* Build the major ticks with labels *)
	majorTicks=Table[
		{
			If[OptionValue[ Round], startNumberRound, startNumber] + tickNum * majorTickIncrement,
			SignificantFigures[N[base^(If[OptionValue[ Round], startNumberRound, startNumber] + tickNum majorTickLabelIncrement)], OptionValue[SignificantFigures]] // N,
			majorTickSize
		},
		{tickNum, 0, majorTickNumber}
	];

	(* Calculate the number of ticks between each major tick *)
	divisionsPerMajorTick=Round[OptionValue[MinorTicks] / majorTickNumber];

	(* Calculate the positions of the minor ticks between one majorTick block *)
	minorTickPerMajor=Table[Total[majorTickIncrement / 2^#& /@ Range[minorTickNum]], {minorTickNum, divisionsPerMajorTick}];
	(* now repeat the minor ticks per major tick for each major tick *)
	allMinorTicks=Flatten[Table[# + If[OptionValue[ Round], startNumberRound, startNumber] + tickNum * majorTickIncrement& /@ minorTickPerMajor, {tickNum, 0, majorTickNumber - 1}]];

	(* Minor tick marks should be this big (formated the way FrameTicks likes it) *)
	minorTickSize={OptionValue[MinorTickSize], 0};
	(* Note that these tick mark sizes scale with the scaling of the image, so will get bigger and smaller as the image does *)

	(* Build the minor ticks without labels *)
	minorTicks={#, "", minorTickSize}& /@ allMinorTicks;

	(* Join the major with the minor tickmarks *)
	Join[majorTicks, minorTicks]

]/;MatchQ[OptionValue[Log], _?NumericQ];

(* EmeraldFrameTicks sent an empty dataset, so calculate as if no dataset were provided *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, {startLabel_?NumericQ, endLabel_?NumericQ}, Null | {Null..}, ops:OptionsPattern[EmeraldFrameTicks]]:=EmeraldFrameTicks[{startNumber, endNumber}, {startLabel, endLabel}, ops];

(* No label passed, return None which puts on no frame Ticks *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, {startLabel_, endLabel_}, Null | {Null..}, ops:OptionsPattern[EmeraldFrameTicks]]:=None;

(* --- Data provided in addition to span --- *)
EmeraldFrameTicks[{startNumber_?NumericQ, endNumber_?NumericQ}, {startLabel_, endLabel_}, datas:{({{_?NumericQ, _?NumericQ}..} | Null | {Null})..}, ops:OptionsPattern[EmeraldFrameTicks]]:=Module[{notNull, max, min},

	(* Select out the null traces *)
	notNull=Select[datas, !MatchQ[#, Null | {Null}]&];

	(* find the minimum and maximums of the traces *)
	min=If[Length[notNull] > 0, SignificantFigures[Min[Min /@ notNull[[All, All, 2]]], OptionValue[SignificantFigures]], startNumber];
	max=If[Length[notNull] > 0, SignificantFigures[Max[Max /@ notNull[[All, All, 2]]], OptionValue[SignificantFigures]], endNumber];

	(* now deliver the actual frame ticks used the filled in values if for instance Automatic has been selected *)
	EmeraldFrameTicks[{startNumber, endNumber}, {Switch[startLabel, _?NumericQ, startLabel, _, min], Switch[endLabel, _?NumericQ, endLabel, _, max]}, ops]
];


(* ::Subsection::Closed:: *)
(*Option Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolvePlotLegends*)

DefineOptions[resolvePlotLegends,
	Options :> {
		{Orientation -> Column, Column | Row, "Controls placement of legend.  If Column, legend is placed below plot.  If Row, legend is placed to the right of plot."},
		{Boxes -> False, True | False, "Indicates if the legend's color swatches should appear as squares (True) or lines (False)."},
		{PlotMarkers -> Automatic, _, "Indicates the appearance of marks used to plot points."},
		{LegendColors -> Automatic, Automatic | {_RGBColor..}, "Indicates the colors to use when creating the legend."}
	}];


resolvePlotLegends[labels:{(_String | _Image | _Graphics)..}, ops:OptionsPattern[]]:=Module[
	{placement, legendType, labelsFormatted, markers, lineColors, safeOps},
	safeOps=SafeOptions[resolvePlotLegends, ToList[ops]];
	placement=Replace[Lookup[safeOps, Orientation], {Column -> Bottom, Row -> Right}];
	legendType=Switch[Lookup[safeOps, Boxes],
		True, SwatchLegend,
		False, LineLegend
	];
	markers=Lookup[safeOps, PlotMarkers];
	labelsFormatted=Map[Style[#, 12]&, labels];

	(* Line/Box Color option *)
	lineColors=Lookup[safeOps, LegendColors];
	If[lineColors === Automatic,
		Placed[legendType[labelsFormatted, LegendMarkers -> markers], placement],
		Placed[legendType[lineColors, labelsFormatted, LegendMarkers -> markers], placement]
	]
];

(* Null case *)
(* No legend obtained by passing empty list to PlotLegends option or None to ChartLegends option *)
resolvePlotLegends[{} | Null | None | Automatic, ops:OptionsPattern[]]:=Module[{legendType, safeOps},
	safeOps=SafeOptions[resolvePlotLegends, ToList[ops]];
	legendType=Switch[Lookup[safeOps, Boxes],
		True, None,
		False, {}
	]
];


(* ::Subsubsection::Closed:: *)
(*FullPlotRange*)


FullPlotRange[plotRange:(_List | Automatic | All | Full)]:=Module[
	{plotP, expand, unwrap},

	(* List of all possible plot range symbols *)
	plotP={Automatic} | {All} | {Full} | Automatic | All | Full;

	(* List of rules which expand to a list of 4 things *)
	expand={
		good:{{_, _}, {_, _}} :> good,
		{x:plotP, y:{_, _}} :> {{x, x}, y},
		{x:{_, _}, y:plotP} :> {x, {y, y}},
		{x:plotP, y:plotP} :> {{x, x}, {y, y}},
		alone:plotP :> {{alone, alone}, {alone, alone}}
	};

	(* List of rules for unwrapping any over listed stuff like {Automatic} -> Automatic *)
	unwrap=wrapped:{Automatic} | {Full} | {Automatic} :> First[wrapped];

	(* Expand the plot range to full and unwrap any unnecessary wrapping *)
	plotRange /. expand /. unwrap

];


(* ::Subsection::Closed:: *)
(*Plot Epilogs*)


(* ::Subsubsection::Closed:: *)
(*ErrorBar*)


DefineOptions[ErrorBar,
	Options :> {
		{PlotRange -> Automatic, {{_?NumericQ, _?NumericQ}, {_?NumericQ, _?NumericQ}} | Automatic, "The plot range where the error bar graphic(s) will be included."},
		{Ticks -> 0.03, _?NumericQ, "The size of the end mark ticks.  If the PlotRange is specified, the number is relative to the span of the plot range. If PlotRange is set to Automatic, the ticks are in absolute Units."},
		{Orientation -> Vertical, Vertical | Horizontal, "If a 'point' and 'error' are specified 'Orientation' is used to determine the direction of the error bars."},
		{PlotType -> Linear, Linear | LinearLog | LogLinear | LogLog, "Defines if logrithms should be taken for the bars, depending on whether its a: Linear, LinearLog, LogLinear, or  LogLog plot."},
		{Log -> E, _?NumericQ, "Base of the logrithm if a log plot is used.  Assumes natural log by default."},
		{Color -> GrayLevel[0], Automatic | _GrayLevel | _RGBColor, "Sets the color of the error bars."},
		{TickUnit -> Hour, _?TimeQ, "Sets the unit for the ticks if the points are of the form {DateListP,_?NumericQ}."}
	}];


(* --- Core function --- *)
ErrorBar[points:{p1:{p1x:(_?NumericQ | DateListP | _DateObject), p1y_?NumericQ}, p2:{p2x:(_?NumericQ | DateListP | _DateObject), p2y_?NumericQ}}, ops:OptionsPattern[ErrorBar]]:=Module[
	{ticksize, tickunit, orientation, tickWidth, tickLines, bar},

	(*set the automatic tick size and unit if necessary*)
	ticksize=Switch[OptionValue[Ticks],
		Automatic, If[MatchQ[p1x, DateListP], 0.1, 0.03],
		_?NumericQ, OptionValue[Ticks],
		_?TimeQ, First[OptionValue[Ticks]]
	];
	tickunit=Switch[OptionValue[Ticks],
		Automatic, Day,
		_?NumericQ, Day,
		_?TimeQ, Last[OptionValue[Ticks]]
	];

	(* Determine the Orientation if set to automatic by examining if the points are in a vertical or horizontal line *)
	orientation=Switch[OptionValue[Orientation],
		Automatic, If[p1y == p2y, Horizontal, Vertical],
		_, OptionValue[Orientation]
	];

	(* Determine the with of the ticks as a fration of the plot range using the Ticks option *)
	tickWidth=Switch[orientation,
		Horizontal, OptionValue[PlotRange] /. {{_, {ymin_?NumericQ, ymax_?NumericQ}} :> (ymax - ymin) * ticksize, _ -> ticksize},
		Vertical, If[MatchQ[p1x, _?NumericQ],
			OptionValue[PlotRange] /. {{{xmin_?NumericQ, xmax_?NumericQ}, _} :> (xmax - xmin) * ticksize, _ -> ticksize},
			OptionValue[PlotRange] /. {{{xmin:DateListP, xmax:DateListP}, _} :> QuantityMagnitude[DateDifference[xmax, xmin]] * ticksize, _ -> ticksize}
		]
	];

	(* Draw the tick lines around the end points know what we know the tick width *)
	(*Only draw the bottom tick is it's a positive number unless it is the linear case*)
	tickLines=
		Switch[orientation,
			Horizontal, If[p1x > 0 || MatchQ[OptionValue[PlotType], Linear],
			{Line[{{p1x, p1y + tickWidth / 2}, {p1x, p1y - tickWidth / 2}}], Line[{{p2x, p2y + tickWidth / 2}, {p2x, p2y - tickWidth / 2}}]},
			{Line[{{p2x, p2y + tickWidth / 2}, {p2x, p2y - tickWidth / 2}}]}],
			Vertical, If[MatchQ[p1x, _?NumericQ],
			If[p1y > 0 || MatchQ[OptionValue[PlotType], Linear],
				{Line[{{p1x + tickWidth / 2, p1y}, {p1x - tickWidth / 2, p1y}}], Line[{{p2x + tickWidth / 2, p2y}, {p2x - tickWidth / 2, p2y}}]},
				{Line[{{p2x + tickWidth / 2, p2y}, {p2x - tickWidth / 2, p2y}}]}],
			If[p1y > 0,
				{
					Line[{{DatePlus[p1x, N[tickWidth / 2] * tickunit], p1y}, {DatePlus[p1x, -N[tickWidth / 2] * tickunit], p1y}}],
					Line[{{DatePlus[p2x, N[tickWidth / 2] * tickunit], p2y}, {DatePlus[p2x, -N[tickWidth / 2] * tickunit], p2y}}]
				},
				{Line[{{DatePlus[p2x, N[tickWidth / 2] * tickunit], p2y}, {DatePlus[p2x, -N[tickWidth / 2] * tickunit], p2y}}]}]
		]
		];


	(* Draw the error bar itself (sans the ticks) *)
	(*if the bar goes below 0 just 0 instead. this only matters if it is a log scale, otherwise it fine to go below 0*)
	bar=If[MatchQ[OptionValue[PlotType], Linear], Line[points], Switch[orientation,
		Horizontal, If[p1x > 0, Line[points], Line[{{0, p1y}, {p2x, p2y}}]],
		Vertical, If[p1y > 0, Line[points], Line[{{p1x, 0}, {p2x, p2y}}]]
	]
	];

	(* Combine the bar with the bar's ticks and return *)
	Prepend[Prepend[tickLines, bar], OptionValue[Color]]
];

(* --- Single point with error bars ---*)

ErrorBar[point:{{px:(_?NumericQ | DateListP), py_?NumericQ}, error:(_?NumericQ | DateListP | _DateObject)}, ops:OptionsPattern[ErrorBar]]:=Module[{adjPx},
	(*-- adjust minimum values for logs to avoid complex numbers*)
	adjPx=If[(px - error) > 0, px - error, .000001];
	Switch[OptionValue[PlotType],
		Linear, ErrorBar[{{px - error, py}, {px + error, py}}, ops],
		LinearLog, ErrorBar[{{px - error, Log[OptionValue[Log], py]}, {px + error, Log[OptionValue[Log], py]}}, ops],
		LogLinear, ErrorBar[{{Log[OptionValue[Log], adjPx], py}, {Log[OptionValue[Log], px + error], py}}, ops],
		LogLog, ErrorBar[{{Log[OptionValue[Log], adjPx], Log[OptionValue[Log], py]}, {Log[OptionValue[Log], px + error], Log[OptionValue[Log], py]}}, ops]
	]]/;MatchQ[OptionValue[Orientation], Horizontal];

ErrorBar[point:{{px:(_?NumericQ | DateListP | _DateObject), py_?NumericQ}, error:(_?NumericQ | DateListP | _DateObject)}, ops:OptionsPattern[ErrorBar]]:=Module[{adjPy},
	(*-- adjust minimum values for logs to avoid complex numbers*)
	adjPy=If[(py - error) > 0, py - error, .000001];
	Switch[OptionValue[PlotType],
		Linear, ErrorBar[{{px, py + error}, {px, py - error}}, Orientation -> Vertical, ops],
		LinearLog, ErrorBar[{{px, Log[OptionValue[Log], py + error]}, {px, Log[OptionValue[Log], adjPy]}}, Orientation -> Vertical, ops],
		LogLinear, ErrorBar[{{Log[OptionValue[Log], px], py + error}, {Log[OptionValue[Log], px], py - error}}, Orientation -> Vertical, ops],
		LogLog, ErrorBar[{{Log[OptionValue[Log], px], Log[OptionValue[Log], py + error]}, {Log[OptionValue[Log], px], Log[OptionValue[Log], adjPy]}}, Orientation -> Vertical, ops]
	]]/;MatchQ[OptionValue[Orientation], Vertical] || MatchQ[OptionValue[Orientation], Automatic];

(* --- Listable --- *)
ErrorBar[bars:{{{(_?NumericQ | DateListP | _DateObject), _?NumericQ}, ({(_?NumericQ | DateListP | _DateObject), _?NumericQ} | (_?NumericQ | DateListP | _DateObject))}..}, ops:OptionsPattern[ErrorBar]]:=
	ErrorBar[#, ops]& /@ bars;


(* ::Subsubsection::Closed:: *)
(*AxisLines*)


DefineOptions[AxisLines,
	Options :> {
		{PeakPointSize -> 0.015, _?NumericQ, "Defines the size of the peak point(s) on the graphic."},
		{PeakPointColor -> RGBColor[0., 0.5, 1.], _?ColorQ, "Defines the color of the peak point(s) and line graphics."},
		{SecondYScaled -> {}, {{_?NumericQ, _?NumericQ}...} | Null, "Values of the second y-axis data scaled to the primary y-axis."},
		{SecondYUnscaled -> {}, {{_?NumericQ, _?NumericQ}...} | Null, "Values of the second y-axis left unscaled to primary y-axis."},
		{SignificantFigures -> 6, _Integer, "Number of significant figures to include.", Category -> Hidden},
		{Label -> True, BooleanP, "Indicates whether or not to label the axis lines.", Category -> Hidden},
		{Yaxis -> True, BooleanP, "Indicates whether or not to include the y-axis.", Category -> Hidden},
		{Reflected -> False, BooleanP, "Indicates whether the axis lines are reflected.", Category -> Hidden},
		{PlotRange -> Automatic, _, "Indicates the plot range of the axis lines.", Category -> Hidden},
		{LabelStyle -> {Bold, 18, FontFamily -> "Arial"}, _, "Indicates the font style of the labels.", Category -> Hidden},
		{Scale -> Linear, Alternatives[Linear,LogLinear,LinearLog,Log], "Scaling of the x and y axes.", Category->Hidden}
	}
];


AxisLines[peakPoints:{{_?NumericQ, _?NumericQ}..}, ops:OptionsPattern[AxisLines]]:=Module[
	{
		xmin, xmax, ymin, ymax, plotRange, scale, labelTransform
	},

	safeOps = SafeOptions[AxisLines, ToList[ops]];

	(* check the plot scale to transform labels appropriately *)
	scale = Lookup[safeOps, Scale];
	labelTransform = If[MatchQ[scale, Alternatives[LogLinear, Log]],
		10^#1&,
		#&
	];

	{{xmin, xmax}, {ymin, ymax}}=OptionValue[PlotRange];
	plotRange=OptionValue[PlotRange];
	Map[Function[peak, {
		OptionValue[PeakPointColor],
		Dashed,
		Thin,
		If[OptionValue[Yaxis], Line[{peak, {xmin - 2(xmax - xmin), Last[peak]}}]],
		If[OptionValue[Label] && OptionValue[Yaxis],
			Text[
				Style[ToString[SignificantFigures[Last[peak], OptionValue[SignificantFigures]] // N], OptionValue[PeakPointColor], Background -> Directive[White, Opacity[0.75]], Sequence @@ OptionValue[LabelStyle], "LeftPeakGuideline"],
				{xmin, Last[peak]},
				{Left, Center}
			]
		],
		Line[{peak, {First[peak], ymin - 2(ymax - ymin)}}],
		If[OptionValue[Label],
			Text[
				Style[ToString[If[OptionValue[Reflected], -1, 1] * SignificantFigures[labelTransform[First[peak]], OptionValue[SignificantFigures]] // N], OptionValue[PeakPointColor], Background -> Directive[White, Opacity[0.75]], Sequence @@ OptionValue[LabelStyle], "BottomPeakGuideline"],
				{First[peak], ymin},
				{Center, Bottom}
			]
		],
		If[MatchQ[OptionValue[SecondYScaled], {{_?NumericQ, _?NumericQ}..}],
			Module[{secondYScaled, secondYUnscaled, bufferedSecondYScaled, bufferedSecondYUnscaled},
				secondYScaled=DeleteDuplicatesBy[OptionValue[SecondYScaled], First];
				bufferedSecondYScaled=If[First[Last[secondYScaled]] < xmax, Append[secondYScaled, {xmax, Last[Last[secondYScaled]]}], secondYScaled];
				secondYUnscaled=DeleteDuplicatesBy[OptionValue[SecondYUnscaled], First];
				bufferedSecondYUnscaled=If[First[Last[secondYUnscaled]] < xmax, Append[secondYUnscaled, {xmax, Last[Last[secondYUnscaled]]}], secondYUnscaled];
				{
					Line[{peak, {First[peak], Interpolation[bufferedSecondYScaled, InterpolationOrder -> 1][First[peak]]}}],
					Line[{{First[peak], Interpolation[bufferedSecondYScaled, InterpolationOrder -> 1][First[peak]]}, {xmax + 2(xmax - xmin), Interpolation[bufferedSecondYScaled, InterpolationOrder -> 1][First[peak]]}}],
					PointSize -> OptionValue[PeakPointSize]0.65,
					Point[{First[peak], Interpolation[bufferedSecondYScaled, InterpolationOrder -> 1][First[peak]]}],
					If[OptionValue[Label],
						Text[
							Style[ToString[SignificantFigures[Interpolation[bufferedSecondYUnscaled, InterpolationOrder -> 1][labelTransform[First[peak]]], OptionValue[SignificantFigures]] // N], OptionValue[PeakPointColor], Background -> Directive[White, Opacity[0.75]], Sequence @@ OptionValue[LabelStyle], "RightPeakGuideline"],
							{xmax, Interpolation[bufferedSecondYScaled, InterpolationOrder -> 1][First[peak]]},
							{Right, Center}
						]
					]
				}
			]
		]
	}], peakPoints]
];


(* ::Subsubsection::Closed:: *)
(*secondYEpilog*)


DefineOptions[secondYEpilog,
	Options :> {
		{Display -> {Gradient, Fractions, Peaks, PassiveReference, DataPoints}, {_Symbol...}, "The list of valid symbols whose members will have a line drawn for."},
		{PlotRange -> Automatic, {{_?NumericQ | _?UnitsQ, _?NumericQ | _?UnitsQ | Full} | Full | Automatic, {_?NumericQ | _?UnitsQ, _?NumericQ | _?UnitsQ | Full} | Full | Automatic} | Automatic, "The plotrange of the plot you are providing an expilog for.  MUST BE EXPLICIT."},
		{Color -> GrayLevel[0], _?ColorQ, "The base color to use for the line.  If listable is envoked a ColorFade from light to dark around the provided color will be used to color the lines."},
		{Scale -> 1, _?NumericQ, "When automatic Max/Min's are envoked, will scale the max/min data by this fraction."},
		{Style -> Line, Line | Point, "Sets the display to be lines or points."}
	}];


(* --- Core Function --- *)
secondYEpilog[(Null | {Null..} | {{Null..}..} | {}), type_, {yMin_, yMax_}, ops:OptionsPattern[secondYEpilog]]:={};
secondYEpilog[plotData:{{_?NumericQ, _?NumericQ}..}, type_, {yMin_, yMax_}, ops:OptionsPattern[secondYEpilog]]:=
	If[MemberQ[OptionValue[Display], type],
		Module[{min, max, lineData},

			max=Switch[yMax,
				_?NumericQ, yMax,
				_, Max[plotData[[All, 2]]] * OptionValue[Scale]
			];

			min=Switch[yMin,
				_?NumericQ, yMin,
				_, Min[plotData[[All, 2]]] * OptionValue[Scale]
			];

			(* Scale the Y Axes values *)
			lineData=RescaleY[plotData, {min, max}, Last[OptionValue[PlotRange]]];

			Flatten[{OptionValue[Color], If[MatchQ[OptionValue[Style], Line], Line[lineData], Point /@ lineData]}]
		],
		{}
	];

(* --- Listable --- *)
secondYEpilog[plotDatas:{({{_?NumericQ, _?NumericQ}...} | Null)..}, type_, {yMin_, yMax_}, ops:OptionsPattern[secondYEpilog]]:=Module[{uniqueData, max, min, colors},

	uniqueData=DeleteDuplicates[Select[plotDatas, !MatchQ[#, Null]&]];

	If[Length[uniqueData] > 0,
		Module[{},
			max=Switch[yMax,
				_?NumericQ, yMax,
				_, Max[uniqueData[[All, All, 2]]] * OptionValue[Scale]
			];

			min=Switch[yMin,
				_?NumericQ, yMin,
				_, Min[uniqueData[[All, All, 2]]] * OptionValue[Scale]
			];

			colors=If[MatchQ[OptionValue[Color], {_?ColorQ..}],
				PadRight[OptionValue[Color], Length[uniqueData], OptionValue[Color]],
				ColorFade[{OptionValue[Color]}, Length[uniqueData]]
			];

			MapThread[secondYEpilog[#1, type, {min, max}, Color -> #2, ops]&, {uniqueData, colors}]
		],
		{}
	]
];


(* ::Subsubsection::Closed:: *)
(*fractionEpilog*)


DefineOptions[fractionEpilog,
	Options :> {
		{Display -> {Gradient, Fractions, Peaks}, {_Symbol...}, "Option pass through from plot.  Must contain Fractions in the list to return the epilog."},
		{PlotRange -> Automatic, {{_?NumericQ | _?UnitsQ, _?NumericQ | _?UnitsQ | Full} | Full | Automatic, {_?NumericQ | _?UnitsQ, _?NumericQ | _?UnitsQ | Full} | Full | Automatic} | Automatic, "Option pass through from plot. PlotRange of the plot that the epilog will be included on and MUST BE EXPLICIT."},
		{FractionHighlights -> Null, ListableP[{({_?NumericQ, _?NumericQ, _String} | {Null, Null, Null} | Null)..} | Null] | ListableP[Null], "List of fractions to be highlighted in an alternative color.  If listable form of fractionData is provided, Fraction Highlights must also be listable (same dimensions)."},
		{FractionColor -> RGBColor[1, 0, 1], _?ColorQ, "Color to apply to the fractions (will be transparent)."},
		{FractionHighlightColor -> RGBColor[0., 1., 0.4], _?ColorQ, "Color to apply to the Highlighted fractions (will be transparent)."},
		{FractionLabels -> Null, Null | _List, "List of labels to display during mouseover on fractions."}
	}];


fractionEpilog[fractionData:(Null | {} | {{Null, Null, Null}} | {Null}), ops:OptionsPattern[]]:={};

fractionEpilog[fractionData:{FractionP...}, ops:OptionsPattern[]]:=Module[
	{fracs, highlightFracs, allLabels, labels, highlightLabels, highlightInds, otherInds},

	(* Divy up the fractions to be highlighted vs. the numral fractions *)
	highlightInds=Flatten[Position[fractionData, Alternatives @@ OptionValue[FractionHighlights]]];
	otherInds=Complement[Range[Length[fractionData]], highlightInds];
	fracs=fractionData[[otherInds]];
	highlightFracs=fractionData[[highlightInds]];
	allLabels=OptionValue[FractionLabels];

	If[
		Or[
			!MatchQ[allLabels, _List],
			!MatchQ[Length[allLabels], Length[fractionData]]
		],
		allLabels=fractionData[[;;, 3]];
	];
	allLabels=Map[ToString, allLabels];

	highlightLabels=allLabels[[highlightInds]];
	labels=allLabels[[otherInds]];
	(* Display the fraction using the graphics code in fractionGraphic *)
	If[MemberQ[OptionValue[Display], Fractions],
		Join[
			fractionGraphic[Unitless[fracs], OptionValue[FractionColor], 0.1, OptionValue[PlotRange], labels],
			fractionGraphic[Unitless[highlightFracs], OptionValue[FractionHighlightColor], 0.2, OptionValue[PlotRange], highlightLabels]
		],
		{}
	]
];


fractionGraphic[fracs:(Null | {Null} | {} | {{}} | {{Null}} | {{Null, Null , Null}}), color_, opacity_, {{xmin_, xmax_}, {ymin_, ymax_}}, _]:={};
fractionGraphic[fracs:{{_?NumericQ, _?NumericQ, _String}..}, color_, opacity_, {{xmin_, xmax_}, {ymin_, ymax_}}, labels_]:=Module[{yRange, midY},
	yRange=(ymax - ymin);
	midY=Mean[{ymin, ymax}];
	MapThread[
		Function[
			{frac, samp},
			Mouseover[
				Append[{color, EdgeForm[color], Opacity[opacity]}, Rectangle[{frac[[1]], ymin - yRange}, {frac[[2]], ymax + yRange}]],
				Join[
					{color, EdgeForm[color], Opacity[opacity + 0.1]},
					{Rectangle[{frac[[1]], ymin - yRange}, {frac[[2]], ymax + yRange}]},
					{Text[Style[samp, Black, Opacity[1], 14, Bold, FontFamily -> "Arial", Background -> Directive[White, Opacity[0.75]]], {Mean[{frac[[1]], frac[[2]]}], midY}]}
				]
			]
		],
		{fracs, labels}
	]
];


(* ::Subsection::Closed:: *)
(*Zooming*)


(* ::Subsubsection:: *)
(*Zoomable*)

Zoomable[graphics_Graphics] /; ECL`$CCD :=
	Module[{options, xMinFull, xMaxFull, yMinFull, yMaxFull, graphicsMetadata, newGraphics, resolvedImageSize, resolvedImagePadding, prevLabel, newLabel, resolvedImageMagnification},

		(*Normally, the set of Graphics primitives are enclosed in a List.
		But if there is only one primitive, Mathematica allows Graphics to take that primitive without enclosing it in a List,
		In order to facilitate inserting in the layers below, we need to insert that List in case it is absent.*)
		newGraphics = MapAt[ToList, graphics, {1}];

		(*On MacOSX, the default software rendering engine is slow to fill polygons with many vertices.
		Inserting a PointBox with VertexColors forces the GraphicsBox to be rendered with a different engine that is faster.*)
		If[$OperatingSystem==="MacOSX",
			newGraphics = Insert[newGraphics, {PointBox[{0, 0}, VertexColors -> GrayLevel[1]]}, {1,1}]
		];

		(*Get the absolute PlotRange*)
		{{xMinFull, xMaxFull},{yMinFull, yMaxFull}} = OptionValue[AbsoluteOptions[newGraphics, PlotRange],PlotRange];

		(*Truncate any explicitly specified Ticks so that their sizes are not rendered with with fixed size*)
		options = Options[graphics];
		newGraphics = Insert[newGraphics, Ticks -> truncateFrameTicks[Lookup[options,Ticks], {{xMinFull, xMaxFull},{yMinFull, yMaxFull}}], 2];

		newGraphics = Insert[newGraphics, FrameTicks -> truncateFrameTicks[Lookup[options,FrameTicks], {{xMinFull, xMaxFull},{yMinFull, yMaxFull}}], 2];

		(*Use graphicsInformation function to get the absolute options*)
		graphicsMetadata = graphicsInformation[newGraphics];

		resolvedImagePadding = Lookup[graphicsMetadata, "ImagePadding"];
		resolvedImageSize = Lookup[graphicsMetadata, "ImageSize"];
		resolvedImageMagnification =Lookup[graphicsMetadata, "ImageMagnification"];

		(*Change PlotLabel font size if Magnification is too small*)
		prevLabel = Quiet[OptionValue[AbsoluteOptions[newGraphics, PlotLabel], PlotLabel]];
		newLabel = changeTitleFontSize[prevLabel, resolvedImageMagnification];

		newGraphics = Insert[newGraphics, PlotLabel -> newLabel, 2];

		DynamicModule[{
			SciCompFramework`Private`graphicsBoxImageSize = resolvedImageSize,
			SciCompFramework`Private`xMin = xMinFull,
			SciCompFramework`Private`xMax = xMaxFull,
			SciCompFramework`Private`yMin = yMinFull,
			SciCompFramework`Private`yMax = yMaxFull,
			SciCompFramework`Private`scrollBarPosition =
				{0, SciCompFramework`Private`$InteractiveGraphicsSettings["InternalScrollPositionStart"]}},

			(*Insert the click-zoom layer*)
			newGraphics = Insert[newGraphics, SciCompFramework`Private`clickZoomLayer[True, {{xMinFull,xMaxFull},{yMinFull,yMaxFull}}, {0,0}, False], {1, -1}];

			(*Bring the Epilog and Prolog into the list of primitives*)
			newGraphics = absorbEpilogAndPrologSingle[newGraphics];

			(*Insert the panning layer*)
			newGraphics = Insert[newGraphics, SciCompFramework`Private`panningLayer[{{xMinFull, xMaxFull}, {yMinFull, yMaxFull}}, "ShiftKey"], {1, -1}];


			(*Make the PlotRange dynamicaly update*)
			newGraphics = Insert[newGraphics,
				PlotRange -> Dynamic[{
					{SciCompFramework`Private`xMin, SciCompFramework`Private`xMax},
					{SciCompFramework`Private`yMin, SciCompFramework`Private`yMax}
				}], 2];

			(*Fix the image size*)
			newGraphics = Insert[newGraphics, AspectRatio -> Full, 2];
			newGraphics = Insert[newGraphics, ImageSize -> Dynamic[SciCompFramework`Private`graphicsBoxImageSize], 2];
			newGraphics = Insert[newGraphics, ImagePadding -> resolvedImagePadding, 2];

			newGraphics //
				SciCompFramework`Private`scrollZoomWrapper[
					True, {{xMinFull, xMaxFull}, {yMinFull, yMaxFull}}, {0, 0},
					Dynamic[SciCompFramework`Private`graphicsBoxImageSize], Automatic, {False, False}]

		]
	];

truncateFrameTicks[_Missing, _] := Automatic;
truncateFrameTicks[ticks : {{left_, right_}, {bottom_, top_}}, {{xMin_, xMax_},{yMin_, yMax_}}] :=
	{
		truncateTicks /@ Replace[{left, right}, (tickFunction:_Charting`ScaledTicks|_Charting`DateTicksFunction) :> tickFunction[yMin,yMax], {1}],
		truncateTicks /@ Replace[{bottom, top}, (tickFunction:_Charting`ScaledTicks|_Charting`DateTicksFunction) :> tickFunction[xMin,xMax], {1}]
	};
truncateFrameTicks[ticks_, _] := ticks;

truncateTicks[spec_List] := truncateEachTick /@ spec;
truncateTicks[spec_] := spec;

truncateEachTick[{pos_, label_, __}] := {pos, label};
truncateEachTick[tick_] := tick;

changeTitleFontSize[Pane[Style[title_, fontSize_?NumericQ, styleRest___], ops___], magnification_] := Module[{newFontSize, factor},
	(*factor of adjusted font size. 1 is no change, 0.5 is half of the default font size.
    The factor is 1 if the magnification is greater than 0.8,
    The factor is 0.6 if the magnification is less than 0.5,
    The factor changes linearly between 0.6 to 1 when the magnification change from 0.5 to 0.8.
    *)
	factor = Min[0.6+(1-0.6)/(0.8-0.5)*(magnification-0.5), 1];
	newFontSize = If[$OperatingSystem==="MacOSX",
		fontSize,
		Round[fontSize*factor]
	];
	Pane[Style[title, newFontSize, styleRest], ops]
];

(* 
    sometimes FontSize is in an option rule -- pull it out and redirect to main defintition
*)
changeTitleFontSize[Pane[Style[title_, styleRules___Rule], ops___], magnification_]  := Module[{fontSize,otherRules},
	fontSize = FirstCase[{styleRules},Rule["FontSize"|FontSize, val_] :> val, Null];
	otherRules = Select[{styleRules},Not[MatchQ[First[#], "FontSize"|FontSize]]&];
	If[fontSize === Null,
		Pane[Style[title,otherRules], ops],
		changeTitleFontSize[Pane[Style[title, fontSize, Sequence@@otherRules], ops], magnification]
	]
];

changeTitleFontSize[others_, magnification_]:=others;

absorbEpilogAndProlog[expression_] := Module[{},
	(*
		Find all _Graphics in expression and flatten them in place
	*)
	ReplaceAll[expression, g_Graphics :> absorbEpilogAndPrologSingle[g]]

];

absorbEpilogAndPrologSingle[Graphics[primitives_, ops___]] := Module[{allOptions, epilog, prolog},

	(* depending on where graphics came from, could ops could be list or sequence *)
	allOptions = Flatten[{ops}];

	(* need ToList somewhere because these can be non-listed *)
	epilog = ToList[Lookup[allOptions, Epilog,{}]];
	prolog = ToList[Lookup[allOptions, Prolog,{}]];

	Graphics[
		{
			prolog,
			primitives,
			epilog
		},
		(* need to preserve all other options *)
		Sequence@@FilterRules[allOptions,Except[Epilog|Prolog]]
	]

];


Zoomable[graph_Graphics]:=With[{
	(* Extract the graphics primitives in the graphics obect. *)
	(* Only apply the OSX-specific workaround when on OSX. *)
	graphicsPrimitives=If[MatchQ[$OperatingSystem, "MacOSX"],
		First[vertexColorWorkaround[graph]],
		First[graph]
	],

	(* Extract the graphics original options *)
	orignalOptions=Sequence @@ Options[graph],

	(* Extract the PlotRange from the orignal graphics *)
	orignalPlotRange=PlotRange /. Options[graph, PlotRange],

	(* Extract FrameTicks from the original graphics *)
	orignalFrameTicks=FrameTicks /. Options[graph, FrameTicks],

	(* Extract the lower x-axis FrameTicks from the original graphics *)
	orignalXTicks=If[MatchQ[Lookup[Options[graph], FrameTicks], {{_, _}, {_, _}}],
		Part[Lookup[Options[graph], FrameTicks], 2, 1],
		Null
	],

	(* Graphics primitive generating function for the selector rectangle *)
	makeRectangle={Opacity[0.25], EdgeForm[{Thin, Dashing[Small], Opacity[0.5]}], FaceForm[RGBColor[0.89013625`, 0.8298584999999999`, 0.762465`]], Rectangle[#1, #2]}&
},

	(* Dynamic Module for the Plot Dragging. NOTE: The first two entire must be PlotRange and FrameTicks for Unzoomable to work properly *)
	DynamicModule[{
		range=orignalPlotRange, ticks=orignalFrameTicks, zoomDownAction, zoomDragAction, zoomUpAction, first, second,
		newSecond, dragging=False, panDownAction, panDragAction, panUpAction, posBefore, posAfter,
		xReflectedQ, reversedTicks, peakPointRules
	},

		(* True if the X-axis was reflected *)
		xReflectedQ=MatchQ[orignalXTicks, {{_, _, _, _}..}] && (orignalXTicks[[1, 1]] === -orignalXTicks[[1, 2]]);

		(* Define how to update plot range when clicking and dragging *)
		zoomDownAction[mousePosition_]:=(first=(mousePosition /. None -> first));
		zoomDragAction[mousePosition_]:=(dragging=True;newSecond=mousePosition;If[MatchQ[newSecond, None], dragging=False, second=newSecond]);
		zoomUpAction[mousePosition_]:=If[dragging, dragging=False;range=Transpose@{first, second}, range=orignalPlotRange];

		(* Define how to update plot range when panning *)
		panDownAction[mousePosition_]:=(posBefore=mousePosition /. None -> First[range]);
		panDragAction[mousePosition_]:=(posAfter=mousePosition;range=range + (posBefore - posAfter));
		panUpAction[mousePosition_]:=Null;

		(* Generate new frame ticks by reversing the sign of the lower x-axis *)
		reversedTicks[{{xmin_, xmax_}, {ymin_, ymax_}}]:=ReplacePart[orignalFrameTicks,
			{2, 1} -> MapAt[# * -1&, First[Lookup[AbsoluteOptions[Graphics[{Point[{-xmin, ymax}]}, PlotRange -> {{-xmax, -xmin}, {ymin, ymax}}]], Ticks]], {;;, 1}]
		];
		reversedTicks[_]:=orignalFrameTicks;

		(* Rules for updating peak point text graphics *)
		peakPointRules={
			Text[str:Style[_String, ___, "LeftPeakGuideline", ___], {x:NumericP, y:NumericP}, pos:{Left, Center}] :> Text[str, {Min[Part[range, 1]], y}, pos],
			Text[str:Style[_String, ___, "BottomPeakGuideline", ___], {x:NumericP, y:NumericP}, pos:{Center, Bottom}] :> Text[str, {x, Min[Part[range, 2]]}, pos],
			Text[str:Style[_String, ___, "RightPeakGuideline", ___], {x:NumericP, y:NumericP}, pos:{Right, Center}] :> Text[str, {Max[Part[range, 1]], y}, pos]
		};

		EventHandler[
			Dynamic[
				Graphics[
					If[dragging, {graphicsPrimitives, makeRectangle[first, second]}, graphicsPrimitives],
					If[xReflectedQ,
						(* Regenerate the Frame ticks if the x-axis was reflected *)
						Sequence @@ ReplaceRule[{orignalOptions} /. peakPointRules, {PlotRange -> range, FrameTicks -> reversedTicks[range]}],
						Sequence @@ ReplaceRule[{orignalOptions} /. peakPointRules, {PlotRange -> range}]
					]
				]
			],
			{
				{"MouseDown", 1} :> If[CurrentValue["ShiftKey"], panDownAction, zoomDownAction][MousePosition["Graphics"]],
				{"MouseDragged", 1} :> If[CurrentValue["ShiftKey"], panDragAction, zoomDragAction][MousePosition["Graphics"]],
				{"MouseUp", 1} :> If[CurrentValue["ShiftKey"], panUpAction, zoomUpAction][MousePosition["Graphics"]]
			}
		]
	]
];

(* Overloads for Images and composits with Graphics/Images in them *)
Zoomable[img_Image]:=Zoomable[Show[img]];
Zoomable[other_]:=other /. {g:ZoomableP:>g, g:(_Graphics | _Image) :> Zoomable[g]};


(*This is specifically to get around poor plotting performance on OSX and forces a different rendering engine to be used. Given directly from WRI*)
vertexColorWorkaround[gexpr_]:=Module[{glist=Part[gexpr, 1]}, ReplacePart[gexpr, 1 -> {{AbsolutePointSize[0.5], PointBox[{0, 0}, VertexColors -> GrayLevel[1]]}, glist}]];


(* ::Subsubsection:: *)

(*Unzoomable*)

(*Do nothing on the new PlotImage that calls InteractiveGraphics*)

Unzoomable[interactiveImage: InteractiveImageP] := interactiveImage;


(*Stripping away the new scrollzoom*)
Unzoomable[HoldPattern[
	DynamicModule[_List,
		DynamicModule[_List,
			EventHandler[Pane[Grid[{{Graphics[{prolog_, {originalPrimitives___, _},
				epilog_, _}, _, _, _, _, _, _,
				originalOptions___], ___}, ___}, ___], ___], ___], ___], ___]]] /; ECL`$CCD :=
	Graphics[{originalPrimitives}, Epilog->epilog, Prolog->prolog, originalOptions];


Unzoomable[HoldPattern[DynamicModule[list_List, EventHandler[Dynamic[g_Graphics], ___], ___]]]:= Module[{},

	(* This line looks useless, but without it list cannot be sliced with First or Part *)
	list;
	(* extract the underlying Graphics and substitute in the initial plot range values *)
	g /. {Rule[PlotRange, _] -> Rule[PlotRange, First[list]], Rule[FrameTicks, _] -> Rule[FrameTicks, Part[list, 2]]}
	(* NOTE: THIS DEPENDS ON THE POSITION OF THE PLOTRANGE IN THE DYNAMIC MODULE INSIDE OF ZOOMABLE TO BE THE FIRST POSITION *)
	(* NOTE: And for the position of FrameTicks in the dynamic module to be the last position *)

];

Unzoomable[g_Graphics]:=g;

Unzoomable[construct_]:=construct /. z:ZoomableP :> Unzoomable[z];


(* ::Subsubsection::Closed:: *)
(*ZoomableP*)

(* These are placeholders used to make the expression "inert" before pulling out dynamic/interactive things*)
SetAttributes[EventHandlerPlaceholder,HoldAll];
SetAttributes[DynamicPlaceholder,HoldAll];
SetAttributes[DynamicModulePlaceholder,HoldAll];

Staticize[expr_] /; ECL`$CCD := Rasterize[expr];

Staticize[expr_]:= Module[{exprPlaceholdered},

	(* first replace all the troublsome heads with inert wrappers, to prevent unintended evaluation along the way *)
	exprPlaceholdered = ReplaceAll[expr, {
		Dynamic->DynamicPlaceholder,
		EventHandler->EventHandlerPlaceholder,
		DynamicModule -> DynamicModulePlaceholder
	}];

	(*
		then strip off the dynamic heads and retain the actual values in the underlying expressions
		Using Replace here to work from bottom to top (ReplaceAll/ReplaceRepeated goes top to bottom, which can break nested things)
	*)
	Replace[
		exprPlaceholdered,
		{
			d_DynamicPlaceholder :> First[d],
			ev_EventHandlerPlaceholder :> First[ev],
			dm_DynamicModulePlaceholder :> staticizeDynamicModule[dm]

		}, {0,Infinity}
	]

];

(* need 'Block' here instead of module *)
staticizeDynamicModule[HoldPattern[(DynamicModule|DynamicModulePlaceholder)[vars_List,guts_,ops___]]] := Block[vars,
	(*
		DynamicModuleValues is a delayed rule that contains Set calls for DownValvues of the local variables.
		Since it contains Set calls, just Lookup-ing it causes it to evaluate.
	*)
	Lookup[Flatten[{ops}],DynamicModuleValues,{}];
	(* with that evaluated, now the guts should have those values inside *)
	guts
];

staticQ[expr_] := MatchQ[Count[expr,Dynamic|DynamicModule|EventHandler],0];


(* ::Subsubsection:: *)
(*GraphicsInformation*)

(*
	helper that removes the frame label spaces.
	If the frame label has a space in it and there is a plot label present FrontEndExecute will fail on manifold
*)
removeFrameLabelSpace[plot_]:=Module[
	{
		plotOptions, plotLabel, frameLabel, frameLabelNoSpace
	},

	(* pull out plot options *)
	plotOptions = Options[plot];

	{plotLabel, frameLabel} = Lookup[plotOptions, {PlotLabel, FrameLabel}, Null];

	(* if the PlotLabel is null, return the plot as is *)
	If[plotLabel === Null || frameLabel === Null,
		Return[plot]
	];

	(* replace spaces with "a" in the frame labels *)
	frameLabelNoSpace = Replace[
		frameLabel,
		{HoldForm[Style[myString_, a_]]:>With[{newString = StringReplace[myString, " "->"a"]}, HoldForm[Style[newString, a]]]},
		3
	];

	(* replace the frame label in the plot *)
	Replace[
		plot,
		{HoldPattern[FrameLabel -> _] -> FrameLabel->frameLabelNoSpace},
		3
	]
];

(*
 Based on ResourceFunction by Carl Woll.
 https://resources.wolframcloud.com/FunctionRepository/resources/GraphicsInformation/
 Reduced and documented here for maintainability.

 Used by the new Zoomability to determine the resolved values of ImagePadding and ImageSize.
*)



(* Authors definition for Core`Private`graphicsInformation *)
Authors[Core`Private`graphicsInformation]:={"xu.yi"};

graphicsInformation[graphicsIn_Graphics]:=
	Module[{
		annotatedGraphicsIn, notebookExpression, frontEndReturnedPacket, plotRangeAnnotation, imageSizeAnnotation,
		strippedSpaceGraphic, imageMagnification, imagePadding, correctedImagePadding, windowSize, magnification
	},

		(* removes spaces and puts an "a" in their place from FrameLabel, because spaces cause issues with FrontEndExecute on manifold in MM 13.2 *)
		strippedSpaceGraphic = removeFrameLabelSpace[graphicsIn];

		(*Add Annotated Scaled and ImageScaled rectangles over the entire Graphics.
		The front end will return data about its positions in the "Regions" key in the ExportPacket call below*)
		annotatedGraphicsIn =
			Insert[strippedSpaceGraphic, {
				Annotation[Rectangle[Scaled[{0, 0}], Scaled[{1, 1}]], "PlotRange", 1],
				Annotation[Rectangle[ImageScaled[{0, 0}], ImageScaled[{1, 1}]], "ImageSize", 1]},
				{1, -1}
			];

		(* If EvaluationNotebook[] returns $Failed as we have seen in scripts, use the WindowSize and Magnification of *)
		(* the $FutureScriptNotebook, which is set in a Block[] call within RunScriptJSON. *)
		windowSize = If[MatchQ[AbsoluteCurrentValue[EvaluationNotebook[], WindowSize], $Failed],
			AbsoluteCurrentValue[$FutureScriptNotebook, WindowSize],
			AbsoluteCurrentValue[EvaluationNotebook[], WindowSize]
		];
		magnification = If[MatchQ[AbsoluteCurrentValue[EvaluationNotebook[], Magnification], $Failed],
			AbsoluteCurrentValue[$FutureScriptNotebook, Magnification],
			AbsoluteCurrentValue[EvaluationNotebook[], Magnification]
		];

		(*Build a notebook expression that contains the box form of the annotatedGraphics.
		The WindowSize of the notebook must be resolved; otherwise the ImagePadding is incorrect on Windows.*)
		notebookExpression = UsingFrontEnd[
			Notebook[
				{Cell[BoxData@ToBoxes@annotatedGraphicsIn, "Output"]},
				WindowSize -> windowSize,
				Magnification -> magnification,
				Evaluator -> None
			]
		];

		(*Send notebook to front end to provide information about the annotated graphics primitives
		which are in the "Regions" key.*)
		frontEndReturnedPacket = Lookup[
			UsingFrontEnd[
				FrontEndExecute[
					ExportPacket[notebookExpression, "BoundingBox", Verbose -> True]
				]
			],
			"Regions"
		];

		(*Lookup the data associated with the annotations*)
		{plotRangeAnnotation, imageSizeAnnotation} =
			Lookup[(Rule @@@ frontEndReturnedPacket), {Key[{"PlotRange", 1}], Key[{"ImageSize", 1}]}];

		imagePadding = Abs[imageSizeAnnotation - plotRangeAnnotation];

		(*get the magnification value*)
		imageMagnification = OptionValue[Options@notebookExpression, Magnification];

		(*ImagePadding will be either too small or too big when Magnification is not 100%. Here it uses empirical corrections to adjust the ImagePadding*)
		correctedImagePadding = If[$OperatingSystem==="MacOSX",
			imagePadding + Max[-0.8, (1-imageMagnification)]*{{50, 50}, {40, 40}},
			imagePadding + Max[0, (1-imageMagnification)]*{{60, 60}, {50, 50}}
		];


		(*Return the ImagePadding and ImageSize from the front end parameters.*)
		{
			"ImagePadding" -> correctedImagePadding,
			"ImageSize" -> Abs[Subtract @@@ imageSizeAnnotation],
			"ImageMagnification" -> imageMagnification
		}
	]
