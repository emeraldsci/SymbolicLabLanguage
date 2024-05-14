(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram3D*)


DefineOptions[EmeraldHistogram3D,
	Options :> {

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio,Default->Automatic},
				{OptionName->ImageSize}
			}
		],

		(*** Plot Range Options ***)
		ModifyOptions[ListPlot3DOptions,{PlotRange}],

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel}],
		ModifyOptions[ChartOptions,{ChartLabels}],
		ModifyOptions[ListPlot3DOptions,{AxesLabel}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		ModifyOptions[ChartOptions,{ChartLegends,LegendAppearance}],

		(*** Data Specification options ***)
		ModifyOptions[ListPlot3DOptions,{ClipPlanes,ClipPlanesStyle}],
		ModifyOptions[ChartOptions,
			{
				OptionName->DistributionFunction,
				Widget->Widget[Type->Enumeration, Pattern:>Alternatives["Count","CumulativeCount","SurvivalCount","Probability","PDF","Intensity","CDF","SF","HF","CHF"]]
			}
		],

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background}],
		ModifyOptions[BarChartOptions,{BarOrigin},Category->"Plot Style"],
		ModifyOptions[ChartOptions,{ChartBaseStyle}],
		ModifyOptions[ChartOptions,{ChartElementFunction},
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration,Pattern:>Alternatives[(Sequence@@ChartElementData["Histogram3D"])]],
				"Function"->Widget[Type->Expression, Pattern:>_, Size->Line, PatternTooltip->"The chart element function can be any valid pure or delayed function. For more information, evaluate ?ChartElementFunction in the notebook."]
			],
			Category->"Plot Style"
		],
		ModifyOptions[ChartOptions,{ChartElements,ChartStyle}],
		ModifyOptions[ChartOptions,{ChartLayout},
			Default->"Overlapped",
			Widget->Widget[Type->Enumeration,Pattern:>"Overlapped"|"Stacked"]
		],
		ModifyOptions[ListPlotOptions,{ColorFunction,ColorFunctionScaling}],
		ModifyOptions[ListPlot3DOptions,{Lighting}],
		ModifyOptions[ListPlotOptions,{PlotTheme},Category->"Plot Style"],

		(*** Axes Options ***)
		ModifyOptions[ListPlot3DOptions,{Axes,AxesEdge}],
		ModifyOptions[ListPlotOptions,{AxesOrigin,AxesStyle},Category->"Axes"],

		(*** Box Options ***)
		ModifyOptions[ListPlot3DOptions,{Boxed,BoxRatios,BoxStyle,FaceGrids,FaceGridsStyle}],

		(*** 3D View Options ***)
		ModifyOptions[ListPlot3DOptions,{ViewAngle,ViewPoint,ViewProjection,ViewRange,ViewVector,ViewVertical}],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{PerformanceGoal,Prolog,Epilog},Category->"General"],

		(*** Hidden Options ***)

		(* Options from ListPlotOptions which should be hidden *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PlotRangePadding,PlotRegion,
				PreserveImageOptions,ScalingFunctions,TicksStyle
			},
			Category->"Hidden"
		],
		ModifyOptions[ListPlotOptions,{Ticks},Default->Automatic],

		(* Options from ListPlot3DOptions which should be hidden *)
		ModifyOptions[ListPlot3DOptions,
			{
				AutomaticImageSize,AxesUnits,ControllerLinking,ControllerMethod,ControllerPath,
				NormalsFunction,RotationAction,SphericalRegion,
				TextureCoordinateFunction,TextureCoordinateScaling,TouchscreenAutoZoom,
				ViewCenter,ViewMatrix
			},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


EmeraldHistogram3D[in_,ops:OptionsPattern[EmeraldHistogram3D]]:=Module[
	{
		plotType,originalOps,safeOps,output,plot,internalMMPlotOps,
		resolvedOps,unresolveableOps,optionsRule,finalPlot,distributionFunction,inputLength
	},

	(* Set the plot type for internal resolutions *)
	plotType=Histogram3D;

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldHistogram3D,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Finding the number of datasets to use for ChartStyle *)
	(** TODO: does not work for QuantityArrays **)
	inputLength=Which[
		(* Only one dataset in a double list *)
		MatchQ[in,{{_,_}..}],1,
		(* For nested list equals to the length of the list *)
		MatchQ[in,{{{_,_}..}..}],Length[in]
	];

	(* EmeraldHistogram3D calls MM's Histogram3D directly *)
	internalMMPlotOps=FilterRules[safeOps,Options[plotType]]/.{
		(* Workaround for weird handling of the PlotTheme option under the hood in MM *)
		RuleDelayed[PlotTheme,$PlotTheme]->Rule[PlotTheme,Automatic]
		(* The default style in MM plots is ColorData[97] *)
		(* Rule[ChartStyle,Automatic]->Rule[ChartStyle,ColorData[97][[1;;inputLength]]], *)
	};

	(* The distribution function to use for the histogram *)
	distributionFunction=Lookup[safeOps,DistributionFunction];

	(* Generate the plot *)
	(** TODO: the third argument can take more possible values **)
	plot=plotType[in,Automatic,distributionFunction,internalMMPlotOps];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=ReplaceRule[resolvedPlotOptions[plot,internalMMPlotOps,plotType],{DistributionFunction->distributionFunction}]/.{
		(* TargetUnits doesn't have an effect in histogram because the output is a unitless count. Unit conversions are handled in Histogram3D. *)
		Rule[TargetUnits,Automatic]->Rule[TargetUnits,Null]
	};

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,MatchQ[Last[#],Automatic]&];

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Apply Zoomable if it was requested *)
	finalPlot=If[TrueQ[Lookup[safeOps,Zoomable]],
		Zoomable[plot],
		plot
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		optionsRule,
		Preview->finalPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
