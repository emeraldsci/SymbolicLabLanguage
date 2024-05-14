(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldPieChart*)



(* ::Subsubsection:: *)
(*EmeraldPieChart*)


DefineOptions[EmeraldPieChart,
	Options :> {

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio,Default->1},
				{OptionName->ImageSize}
			}
		],

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel}],
		ModifyOptions[ChartOptions,{ChartLabels}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[LegendOption,Default->None],
		LegendPlacementOption,
		ModifyOptions[BoxesOption,Default->True],

		(*** Data Specification Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->TargetUnits,
					Widget->Widget[Type->Expression,Pattern:>(UnitsP[]|_?KnownUnitQ|Automatic),Size->Word]
				}
			}
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,{Background}],
		ModifyOptions[ChartOptions,{ChartElementFunction},
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["PieChart"])]],
				"Function"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart element function can be any valid pure or delayed function. For more information, evaluate ?ChartElementFunction in the notebook."]
			],
			AllowNull->True
		],
		ModifyOptions[ChartOptions,{ChartBaseStyle,ChartStyle}],
		ModifyOptions[ChartOptions,{ChartLayout},
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives["Grouped","Stacked"]],
			Description->"Specify \"Grouped\" to chart multiple datasets as concentric rings, and \"Stacked\" to include all datasets in the same pie chart."
		],
		ModifyOptions[ListPlotOptions,{ColorFunction,ColorFunctionScaling}],
		ModifyOptions[PieChartOptions,{SectorOrigin,SectorSpacing}],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->Frame,
					Default->{{False,False},{False,False}}
				},
				{OptionName->FrameStyle},
				{
					OptionName->FrameTicks,
					Default->None
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
					OptionName->DisplayFunction,
					Category->"Hidden"
				},
				{OptionName->Prolog},
				{OptionName->Epilog}
			}
		],

		(*** Hidden Options ***)

		(* Options that are normally visible which should be hidden for this function only *)
		ModifyOptions[ListPlotOptions,
			{PlotRange,FrameLabel,RotateLabel},
			Category->"Hidden"
		],
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->PlotRangeClipping,Default->False,Category->"Hidden"}
			}
		],

		(* Hidden options which require no changes from their default definitions *)
		ModifyOptions[PieChartOptions,{PolarAxes,PolarAxesOrigin,PolarGridLines,PolarTicks}],
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,
				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PerformanceGoal,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Disable native MM Legend functions because we have defined our own LegendFunction *)
		ModifyOptions[ChartOptions,
			{ChartLegends,LegendAppearance},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldPieChart[
	rawInput:ListableP[oneChartDataSetP|{(_Tooltip|_Labeled)..}]|QuantityArrayP[2],
	ops:OptionsPattern[]
]:=Module[
	{
		in,chartType,originalOps,safeOps,output,dataToPlot,targetUnit,oneDataSetBool,errorValues,oneTraceP=oneChartDataSetP,dists,
		chartOps,chartOpsResolvedAutos,internalMMPlotOps,mostlyResolvedOps,chart,resolvedOps,unresolveableOps,optionsRule
	},

	(* Set the chartType *)
	chartType=PieChart;

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldPieChart,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Handle a list of Tooltips as input *)
	in=If[MatchQ[rawInput,{(_Tooltip|_Labeled)..}],
		First/@rawInput,
		rawInput
	];

	(*** BEGIN OLD CODE ***)

	(* Primary data resolution *)
	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}=Catch[
		resolveChartData[EmeraldPieChart,chartType,in,safeOps,oneTraceP],
		"IncompatibleUnits"|"InvalidDimensions",
		Repeat[$Failed,5]&
	];

	(* Return failed and exit early if input resolution failed *)
	If[MatchQ[dataToPlot,$Failed],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(* Resolve options which will be passed into the native Mathematica plot function *)
	chartOps=ReplaceRule[safeOps,resolveChartOptions[chartType,safeOps,targetUnit,False,dataToPlot]]/.{
		(* Options unique to PieChart which have special resolutions *)
		Rule[SectorSpacing,Automatic]->Rule[SectorSpacing,Medium],
		Rule[SectorOrigin,Automatic]->Rule[SectorOrigin,{Pi,"Clockwise"}]
	};

	(* Make sure that all options have symbol keys instead of string keys *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldPieChart,chartType,ops]],
		ToList@stringOptionsToSymbolOptions[Sequence@@FilterRules[chartOps,Options[chartType]]]
	];

	(*** END OLD CODE ***)

	(* Generate the plot using the Mathematica plot function *)
	chart=chartType[If[MatchQ[rawInput,{(_Tooltip|_Labeled)..}],rawInput,dataToPlot],internalMMPlotOps];

	(* All options which will be pased into the MM Plot function. ReplaceRule ensures all options are kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[chart,mostlyResolvedOps,chartType];

	(* Check that all options have been resolved *)
	unresolveableOps=DeleteCases[Select[resolvedOps,MatchQ[Last[#],Automatic]&],Rule[PolarAxes,_]];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(*If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOptions,First/@unresolveableOps];
	];*)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Return the requested outputs *)
	output/.{
		Result->chart,
		optionsRule,
		Preview->chart/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
