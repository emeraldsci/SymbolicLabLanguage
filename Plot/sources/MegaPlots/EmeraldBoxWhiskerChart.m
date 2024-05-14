(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBoxWhiskerChart*)


DefineOptions[EmeraldBoxWhiskerChart,
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
					Default->{{Automatic,None},{Automatic,None}}
				},
				{OptionName->RotateLabel}
			}
		],
		ModifyOptions[FrameUnitsOption,
			Default->{{Automatic,None},{Automatic,None}}
		],
		ModifyOptions[ChartOptions,{ChartLabels}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[LegendOption,Default->None],
		LegendPlacementOption,
		ModifyOptions[BoxesOption,Default->True],

		(*** Data Specifications Options ***)
		ScaleOption,
		ModifyOptions[TargetUnitsOption,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line]
			]
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,{Background}],
		BarChartOptions,
		ModifyOptions[ChartOptions,{ChartBaseStyle,ChartStyle}],

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

		(* Options that are notmally visible which should be hidden for this function *)
		ModifyOptions[ListPlotOptions,
			{ColorFunction,ColorFunctionScaling},
			Category->"Hidden"
		],

		(* Hidden options which require no changes from their defaults *)
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

		(* Shared options which are normally not hidden but should be hidden for this plot function *)
		ModifyOptions[ChartOptions,
			{ChartElements,ChartElementFunction,ChartLayout,ChartLegends,LegendAppearance},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


(* Set bwspec, the box whisker specification, to automatic if not provided. *)
EmeraldBoxWhiskerChart[in:ListableP[oneChartDataSetP,2]|QuantityArrayP[2]|QuantityArrayP[3],ops:OptionsPattern[EmeraldBoxWhiskerChart]]:=EmeraldBoxWhiskerChart[in,Automatic,ops];

(* Primary overload *)
EmeraldBoxWhiskerChart[
	in:ListableP[oneChartDataSetP,2]|QuantityArrayP[2]|QuantityArrayP[3],
	bwspec:Except[_Rule|{_Rule..}],
	ops:OptionsPattern[EmeraldBoxWhiskerChart]
]:=Module[
	{
		chartType,originalOps,safeOps,output,dataToPlot,targetUnit,oneDatasetBool,errorValues,oneTraceP=oneChartDataSetP,tooltips=True,dists,
		chartOps,internalMMPlotOps,mostlyResolvedOps,chart,resolvedOps,unresolveableOps,optionsRule,finalChart
	},

	(* Set the chart type for internal resolutions *)
	chartType=BoxWhiskerChart;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldBoxWhiskerChart,checkForNullOptions[originalOps]]/.{
		(* Default BarSpacing for a BoxWhiskerChart is Medium *)
		Rule[BarSpacing,Automatic]->Rule[BarSpacing,Medium]
	};

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*** BEGIN OLD CODE ***)

	(* Primary data resolution *)
	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}=Catch[
		resolveChartData[EmeraldBoxWhiskerChart,chartType,in,safeOps,oneTraceP],
		"IncompatibleUnits"|"InvalidDimensions",
		Repeat[$Failed,5]&
	];

	(* Return failed and exit early if input resolution failed *)
	If[MatchQ[dataToPlot,$Failed],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(* Resolve all options which will be passed into the native MM Plot function *)
	chartOps=ReplaceRule[safeOps,resolveChartOptions[chartType,safeOps,targetUnit,oneDataSetBool,dataToPlot]];

	(* Ensure that all options have symbol keys instead of string keys *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldBoxWhiskerChart,chartType,ops]],
		ToList@stringOptionsToSymbolOptions[Sequence@@FilterRules[chartOps,Options[chartType]]]
	];

	(*** END OLD CODE ***)

	(* Generate the chart using the MM function *)
	chart=chartType[dataToPlot,bwspec,internalMMPlotOps];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps]/.{
		(* Resolve the FrameUnits option because it isn't covered in resolveChartOptions *)
		Rule[FrameUnits,Automatic]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		Rule[FrameUnits,{Automatic,Automatic,None,None}]->Rule[FrameUnits,{{targetUnit,None},{None,None}}],
		(* ChartElements is undocumented for BoxWhisker chart so it will be hidden here. ChartElementFunction should be used instead. *)
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
