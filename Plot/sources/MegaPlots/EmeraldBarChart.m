(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBarChart*)


DefineOptions[EmeraldBarChart,
	Options:>{

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio},
				{OptionName->ImageSize}
			}
		],
		ModifyOptions[ZoomableOption,Default->False,Category->"Image Format"],

		(*** Plot Range Options ***)
		ModifyOptions[ListPlotOptions,{PlotRange,PlotRangeClipping}],

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->PlotLabel},
				{
					OptionName->FrameLabel,
					Default->{{Automatic,None},{None, None}}
				},
				{OptionName->RotateLabel}
			}
		],
		ModifyOptions[FrameUnitsOption,
			Default->{None,Automatic,None,None},
			AllowNull->True
		],
		ModifyOptions[ChartOptions,{ChartLabels}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[LegendOption,Default->None],
		LegendPlacementOption,
		ModifyOptions[BoxesOption,Default->True],

		(*** Data specification options ***)
		ErrorBarsOption,
		ErrorTypeOption,
		ScaleOption,
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->TargetUnits,
					Widget->Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
							Widget[Type->Expression, Pattern:>UnitsP[], Size->Line]
					]
				}
			}
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,{Background}],
		BarChartOptions,
		ModifyOptions[ChartOptions,{ChartBaseStyle,ChartStyle,ChartLayout}],
		ModifyOptions[ListPlotOptions,{ColorFunction,ColorFunctionScaling}],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Frame},
				{OptionName->FrameStyle},
				{
					OptionName->FrameTicks,
					Default->{{Automatic, False}, {Automatic, False}}
				},
				{OptionName->FrameTicksStyle}
			}
		],

		(*** Grid Options ***)
		ModifyOptions[ListPlotOptions,{GridLines,GridLinesStyle}],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->Joined,
					Default->False
				},
				{OptionName->Prolog},
				{OptionName->Epilog}
			}
		],

		(*** Hidden Options ***)

		(* Options that are normally visible which should be hidden for this function only *)
		ModifyOptions[ChartOptions,
			{ChartElements,ChartElementFunction,ChartLegends,LegendAppearance},
			Category->"Hidden"
		],

		(* Hidden options which require no changes from their defaults in the shared option sets *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,
				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				IntervalMarkers,IntervalMarkersStyle,
				LabelingSize,Method,PerformanceGoal,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldBarChart[
	in:ListableP[oneChartDataSetP]|QuantityArrayP[2],
	ops:OptionsPattern[EmeraldBarChart]
]:=Module[
	{
		chartType,originalOps,safeOps,output,dataToPlot,targetUnit,oneDatasetBool,errorValues,oneTraceP=oneChartDataSetP,tooltips=True,dists,
		chartOps,internalMMPlotOps,mostlyResolvedOps,chart,resolvedOps,unresolveableOps,optionsRule,finalChart
	},

	(* Set the chart type for internal resolutions *)
	chartType=BarChart;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldBarChart,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*** BEGIN OLD CODE **)

	(* Primary data resolution *)
	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}=Catch[
		resolveChartData[EmeraldBarChart,chartType,in,safeOps,oneTraceP],
		"IncompatibleUnits"|"InvalidDimensions",
		Repeat[$Failed,5]&
	];

	(* Return failed and exit early if input resolution failed *)
	If[MatchQ[dataToPlot,$Failed],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(* Resolve options which will be passed into the native Mathematica plot function *)
	chartOps=ReplaceRule[safeOps,resolveChartOptions[chartType,safeOps,targetUnit,oneDataSetBool,dataToPlot]]/.{
		Rule[BarSpacing,Automatic]->Rule[BarSpacing,{Small,Medium}]
	};

	(* Disable automatic tooltips if an explicit tooltip has been specified *)
	If[!FreeQ[Lookup[originalOps,LabelingFunction],Tooltip],
		tooltips=False;
	];

	(* Add tooltips to the bars. If bars have associated error, these display wtih a PlusMinus *)
	dataToPlot=addErrorTooltips2[dataToPlot,errorValues,dists,tooltips];

	(* Ensure that all options have symbol keys instead of string keys *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldBarChart,chartType,ops]],
		ToList@stringOptionsToSymbolOptions[
			ChartElementFunction->chartErrorBarFunction["Rectangle",Lookup[chartOps,ScalingFunctions]],
			Sequence@@FilterRules[chartOps,Options[chartType]]
		]
	];

	(*** END OLD CODE ***)

	(* Generate the chart using the MM function *)
	chart=chartType[dataToPlot,internalMMPlotOps];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps]/.{
		(* Resolve the FrameUnits option because it isn't covered in resolveChartOptions *)
		Rule[FrameUnits,Automatic]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		Rule[FrameUnits,{None,Automatic,None,None}]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		(* These options don't do anything because they are overriden by chartErrorBarFunction *)
		Rule[ChartElements,Automatic]->Rule[ChartElements,Null],
		Rule[IntervalMarkers,Automatic]->Rule[IntervalMarkers,Null],
		Rule[IntervalMarkersStyle,Automatic]->Rule[IntervalMarkersStyle,Null]
	};

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[chart,mostlyResolvedOps,chartType];

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(*If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOptions,First/@unresolveableOps];
	];*)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Apply Zoomable if it was requested *)
	finalChart=If[TrueQ[Lookup[safeOps,Zoomable]],
		Zoomable[chart],
		chart
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalChart,
		optionsRule,
		Preview->finalChart/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
