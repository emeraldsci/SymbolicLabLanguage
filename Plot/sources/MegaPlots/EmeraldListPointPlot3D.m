(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPointPlot3D*)

(*
NOTE:Options that are available in ListPointPlot3D but don't seem to be useful for EmeraldListPlot3D:
	ListPlot:
	ColorFunctionScaling,DataRange,ColorOutput,ContentSelectable,CoordinatesToolOptions,ImagePadding,
	ImageSizeRaw,Method,PreserveImageOptions,AlignmentPoint,BaselinePosition

	ListPlot3D:
	AutomaticImageSize,ControllerLinking, ControllerMethod,ControllerPath,SphericalRegion,
	TouchscreenAutoZoom,ViewCenter,ViewMatrix
*)


DefineOptions[EmeraldListPointPlot3D,
	Options:>	{

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
		ModifyOptions[ListPlot3DOptions,{AxesLabel}],
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],

		(*** Legend Options ***)
		LegendOption,
		LegendPlacementOption,

		(*** Data Specifications ***)
		ModifyOptions[ListPlot3DOptions,{ClipPlanes,ClipPlanesStyle,RegionFunction,TargetUnits}],

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,
			{Background,ColorFunction,Filling,FillingStyle,PlotStyle},
			Category->"Plot Style"
		],

		(*** Axes Options ***)
		ModifyOptions[ListPlot3DOptions,{Axes,AxesEdge}],
		ModifyOptions[ListPlotOptions,{AxesOrigin,AxesStyle,Ticks,TicksStyle},Category->"Axes"],

		(*** Box Options ***)
		ModifyOptions[ListPlot3DOptions,{Boxed,BoxRatios,BoxStyle,FaceGrids,FaceGridsStyle}],

		(*** 3D View Options ***)
		ModifyOptions[ListPlot3DOptions,{ViewAngle,ViewPoint,ViewProjection,ViewRange,ViewVector,ViewVertical}],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{Prolog,Epilog},Category->"General"],

		(*** Hidden Options ***)

		(* Options from ListPlotOptions which should be hidden *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,BaselinePosition,BaseStyle,ColorFunctionScaling,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,
				LabelingSize,Method,PerformanceGoal,PlotLabels,PlotLegends,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions
			},
			Category->"Hidden"
		],

		(* Options from ListPlot3DOptions which should be hidden *)
		ModifyOptions[ListPlot3DOptions,
			{
				AutomaticImageSize,AxesUnits,ControllerLinking,ControllerMethod,ControllerPath,
				Lighting,RotationAction,SphericalRegion,TouchscreenAutoZoom,
				ViewCenter,ViewMatrix
			},
			Category->"Hidden"
		],

		(* Output option for command builder *)
		OutputOption
	}
];


(ourPlotFunc:EmeraldListPointPlot3D)[in:ListableP[nullComplexQuantity3DP],ops:OptionsPattern[]]:=Catch[Module[{
		primaryErrorBars,xUnit,yUnit,zUnit,ymin,ymax,primarDataFullUnitless,numObjects,normalizeYVals,numPrimaryPer,
		secondaryDataFullUnitless,secondaryDataFullUnitlessScaled,safeOps,secondYTicks,plotRangeUnitless,fig,primaryDataToPlot,
		secondYColors,epilogs,scaleMin,scaleMax,imageSize,oneTraceP=nullComplexQuantity3DP,secondYUnit,reflectedTicks,plotOps={},secondXRange,
		primaryDataToPlotWithTooltips,yRangeRaw,theirPlotFunc=ListPointPlot3D,
		primaryDataFull,primaryTargetUnits,originalOps,output,internalMMPlotOps,mostlyResolvedOps
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[ourPlotFunc,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* buffer to pad plot range extremes and secondary scaling with *)
	{scaleMin,scaleMax}=1+(*0.005*) 0 *{-1,1}; (* these MUST be symmetric around 1, otherwise scaling will not put the lines in the correct place *)

	(* PRIMARY DATA RESOLUTION *)
	{primaryDataFull,numObjects,numPrimaryPer} = padAndCheckData[ourPlotFunc,in,oneTraceP,Lookup[safeOps,Scale, Null]];

	{primarDataFullUnitless,primaryTargetUnits} = convertAndStripData[ourPlotFunc,primaryDataFull,Lookup[safeOps,TargetUnits],Numerical];

	{xUnit,yUnit,zUnit} = primaryTargetUnits;
	primaryDataToPlot = Flatten[Replace[primarDataFullUnitless,{Null|{}->{{Null,Null}}},{2}],1];

	(* PLOT OPTIONS *)
	plotOps = resolve3DPlotOptions[primaryDataToPlot,primarDataFullUnitless,numObjects,numPrimaryPer,{xUnit,yUnit,zUnit},safeOps];

	(* Ensure that all options have symbol keys instead of string keys *)
	internalMMPlotOps=ReplaceRule[
		ToList[PassOptions[ourPlotFunc,theirPlotFunc,ops]],
		ToList[Sequence@@FilterRules[plotOps,Options[theirPlotFunc]]]
	];

	(* MAKE THE PLOT *)
	fig=theirPlotFunc[primaryDataToPlot,internalMMPlotOps];

	(*
		Resolving MM options using the output figure and AbsoluteOptions
	*)

	(* All options which will be pased into the MM Plot function. ReplaceRule ensures all options are kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=resolvedPlotOptions[fig,mostlyResolvedOps,theirPlotFunc];

	(* Check that all options have been resolved *)
	unresolveableOps=Select[resolvedOps,!FreeQ[#,Automatic]&];

	(* Warning message if any of the resolved options are either Automatic or contain Automatic *)
	(* If[Length[unresolveableOps]>0,
		Message[Warning::UnresolvedPlotOps,First/@unresolveableOps];
	]; *)

	(* Generate the options rule for output*)
	optionsRule=If[MemberQ[ToList[output],Options],
		Options->resolvedOps,
		Options->Null
	];

	(* Return the requested outputs *)
	output/.{
		Result->fig,
		optionsRule,
		Preview->fig/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}


],"IncompatibleUnits"|"InvalidDimensions"];


resolve3DPlotOptions[primaryDataToPlot_,primarDataFullUnitless_,numObjects_,numPrimaryPer_,{xUnit_,yUnit_,zUnit_},safeOps_]:=Module[
	{
		legend,frame,frameTicks,axesLabels,imageSize,plotStyle,tooltips,joined,
		legendBase,plotLegends
	},
	(* full frame specification *)
	frame = resolveFrame[Lookup[safeOps,Frame],secondaryDataFullUnitless];
	(* full FrameTicks specification.  Add SecondY ticks if SecondY data exists. *)
	frameTicks = resolveFrameTicks[Lookup[safeOps,FrameTicks],secondYTicks,reflectedTicks,Lookup[safeOps,Scale]];
	(*  full AxesLabel specification.  Automatics resolve based on axis units *)
	axesLabels = resolveAxesLabel[Lookup[safeOps,AxesLabel],Lookup[safeOps,AxesUnits],{xUnit,yUnit,zUnit}];
	(* need this for sizing any inset images that will be added later *)
	imageSize = resolveImageSize[Lookup[safeOps,ImageSize]];
	(* ColorFade primary data within each object *)
	plotStyle = resolvePlotStyle[Lookup[safeOps,PlotStyle],numObjects,numPrimaryPer];
	(* The PlotLegends should take precedence *)
	plotLegends=Lookup[safeOps,PlotLegends];
	(* Legend base value before resolution *)
	legendBase=Lookup[safeOps,Legend];
	(* Legend based on the PlotLegends or Legend/LegendPlacement *)
	legend = Which[
		(* Take from plotLegends if both are Null *)
		!MatchQ[plotLegends,None] && !MatchQ[legendBase,Null],
		plotLegends,

		(* If PlotLegneds is Null, take it from Legend *)
		MatchQ[plotLegends,None] && !MatchQ[legendBase,Null],
		formatPlotLegend[legendBase,numObjects,numPrimaryPer,LegendPlacement->Lookup[safeOps,LegendPlacement],Boxes->Lookup[safeOps,Boxes],LegendColors->plotStyle],

		True,
		plotLegends
	];

	{
		(* for MM's function *)
		AxesLabel-> axesLabels,
		PlotLegends->legend,
		ImageSize->imageSize,
		PlotStyle->plotStyle
	}

];
