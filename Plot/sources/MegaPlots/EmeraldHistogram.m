(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram*)


DefineOptions[EmeraldHistogram,
	Options :> {

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
					Default->{{"Count",None},{Automatic,None}}
				},
				{OptionName->RotateLabel}
			}
		],
		ModifyOptions[FrameUnitsOption,
			Default->{Automatic,Automatic,None,None}
		],
		ModifyOptions[ChartOptions,{ChartLabels}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[LegendOption,Default->None],
		LegendPlacementOption,
		ModifyOptions[BoxesOption,Default->True],

		(*** Data Specification options ***)
		ScaleOption,
		ModifyOptions[TargetUnitsOption,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line]
			]
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,{Background}],
		ModifyOptions[BarChartOptions,{BarOrigin}],
		ModifyOptions[ChartOptions,{ChartBaseStyle}],
		ModifyOptions[ChartOptions,{ChartElementFunction},
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["Histogram"])]],
				"Function"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart element function can be any valid pure or delayed function. For more information, evaluate ?ChartElementFunction in the notebook."]
			]
		],
		ModifyOptions[ChartOptions,{ChartElements,ChartStyle}],
		ModifyOptions[ChartOptions,{ChartLayout},
			Default->"Overlapped",
			Widget->Widget[Type->Enumeration,Pattern:>"Overlapped"|"Stacked"|Automatic]
		],
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
		ModifyOptions[ListPlotOptions,{Prolog,Epilog}],


		(*** Hidden Options ***)

		(* Options that are normally visible which should be hidden for this function only *)
		ModifyOptions[ChartOptions,
			{ChartLegends,LegendAppearance},
			Category->"Hidden"
		],

		(* Hidden options which require no changes from their defaults in the shared option sets *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,
				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PerformanceGoal,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];


(* Default internal value bspec (base width specification) to Automatic if it is not provided *)
EmeraldHistogram[in:ListableP[oneHistogramDataSetP]|QuantityArrayP[2],ops:OptionsPattern[EmeraldHistogram]]:=EmeraldHistogram[in,Automatic,ops];
EmeraldHistogram[
	in:ListableP[oneHistogramDataSetP]|QuantityArrayP[2],
	bspec:Except[_Rule|{_Rule..}],
	ops:OptionsPattern[EmeraldHistogram]
]:=Module[
	{
		chartType,originalOps,safeOps,output,dataToPlot,targetUnit,oneDatasetBool,errorValues,oneTraceP=oneChartDataSetP,tooltips=True,dists,
		chartOps,internalMMPlotOps,mostlyResolvedOps,chart,resolvedOps,unresolveableOps,optionsRule,finalChart
	},

	(* Set the chart type for internal resolutions *)
	chartType=Histogram;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldHistogram,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*** BEGIN OLD CODE ***)

	(* Primary data resolution *)
	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}=Catch[
		resolveChartData[EmeraldHistogram,chartType,in,safeOps,oneTraceP],
		"IncompatibleUnits"|"InvalidDimensions",
		Repeat[$Failed,5]&
	];

	(* Return failed and exit early if input resolution failed *)
	If[MatchQ[dataToPlot,$Failed],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(* Resolve options which will be passed into the native Mathematica plot function. *)
	chartOps=ReplaceRule[safeOps,resolveChartOptions[chartType,safeOps,targetUnit,False,dataToPlot]];

	(* Ensure that all options have symbol keys instead of string keys *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldHistogram,chartType,ops]],
		ToList@stringOptionsToSymbolOptions[Sequence@@FilterRules[chartOps,Options[chartType]]]
	];

	(*** END OLD CODE ***)

	(* Generate the chart using the MM function *)
	chart=chartType[dataToPlot,bspec,internalMMPlotOps];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps]/.{
		(* Update the FrameUnits option *)
		Rule[FrameUnits,Automatic]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		Rule[FrameUnits,{Automatic,Automatic,None,None}]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		(* Hide the ChartElements function because we make ChartElementFunction visible, and only one of the two can be used. *)
		Rule[ChartElements,Automatic]->Rule[ChartElements,Null]
	};

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[chart,mostlyResolvedOps,chartType];

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOptions,First/@unresolveableOps];
	];

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
