(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram*)


DefineOptions[EmeraldSmoothHistogram,
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
		ModifyOptions[ListPlotOptions,{PlotRange,PlotRangeClipping,ClippingStyle}],

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
		ModifyOptions[ListPlotOptions,{LabelStyle}],

		(*** Data Specification options ***)
		ModifyOptions[ChartOptions,{DistributionFunction}],
		ScaleOption,
		ModifyOptions[TargetUnitsOption,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line]
			]
		],

		(*** PlotStyle Options ***)
		ModifyOptions[ListPlotOptions,{Background,ColorFunction,ColorFunctionScaling,Filling,FillingStyle,PlotStyle}],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->Frame,
					Default->{{True,False},{True,False}}
				},
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

		(*** Hidden options which require no changes from their defaults in the shared option sets ***)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,
				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,LabelingSize,
				Mesh,MeshFunctions,MeshShading,MeshStyle,
				Method,PerformanceGoal,PlotLegends,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],
		ModifyOptions[SmoothHistogramOptions,
			{MaxRecursion,RegionFunction,PlotPoints,WorkingPrecision},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldSmoothHistogram[in:ListableP[oneChartDataSetP]|QuantityArrayP[2],ops:OptionsPattern[]]:=
	EmeraldSmoothHistogram[in,Automatic,ops];
EmeraldSmoothHistogram[in:ListableP[oneChartDataSetP]|QuantityArrayP[2],bspec:Except[_Rule|{_Rule..}],ops:OptionsPattern[]]:=Module[
	{
		safeOps,chart,dataToPlot,debug=False,targetUnit,oneDataSetBool,errorValues,dists,plotRange,
		chartOps,tooltips=True,chartType=SmoothHistogram,oneTraceP = oneChartDataSetP,
		originalOps,output,finalChart,mostlyResolvedOps,unresolveableOps,optionsRule,
		distributionFunction,distFuncLabel,updatedFrameLabel
	},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldSmoothHistogram,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*  PRIMARY DATA RESOLUTION  *)
	{dataToPlot,targetUnit,oneDataSetBool,errorValues,dists}=Catch[
		resolveChartData[EmeraldSmoothHistogram,chartType,in,safeOps,oneTraceP],
		"IncompatibleUnits"|"InvalidDimensions",
		Repeat[$Failed,5]&
	];

	(* Return failed and exit early if input resolution failed *)
	If[MatchQ[dataToPlot,$Failed],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(*  PLOT OPTIONS *)
	chartOps=resolveChartOptions[chartType,safeOps,targetUnit,False,dataToPlot];

	(* Ensure that all options have symbol keys instead of string keys *)
	(* Need this weirdness b/c plot functions barf on some options with string names *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldSmoothHistogram,chartType,ops]],
		ToList@stringOptionsToSymbolOptions[Sequence@@FilterRules[chartOps,Options[chartType]]]
	];

	(* The distribution function to use for the histogram *)
	distributionFunction=Lookup[safeOps,DistributionFunction];

	(* Default y-axis label for each distribution function *)
	distFuncLabel=Switch[distributionFunction,
		"Intensity","Count",
		"PDF","Probability",
		"CDF","Probability",
		"SF","Probability",
		_,None
	];

	(* Update the default frame label to match the distribution function *)
	updatedFrameLabel=If[MatchQ[distributionFunction,Except["Intensity"]]&&MatchQ[Lookup[originalOps,FrameLabel],_Missing|Automatic],
		FrameLabel->{{distFuncLabel,None},{Automatic,None}},
		FrameLabel->Lookup[internalMMPlotOps,FrameLabel]
	];

	(* Generate the chart using the MM function *)
	chart=chartType[dataToPlot,
		bspec,
		distributionFunction,
		ReplaceRule[internalMMPlotOps,updatedFrameLabel]
	];

	(* Apply Zoomable if it was requested *)
	finalChart = If[TrueQ[Lookup[safeOps,Zoomable]],
		Zoomable[chart],
		chart
	];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps];

	(* Use the resolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[chart,mostlyResolvedOps,chartType];

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(* If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOptions,First/@unresolveableOps];
	]; *)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalChart,
		optionsRule,
		Preview->finalChart/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}

];
