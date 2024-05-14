(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldDateListPlot*)


DefineOptions[EmeraldDateListPlot,
	Options:>{

		(*** Image Format Options ***)
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->AspectRatio},
				{OptionName->ImageSize,Default->500}
			}
		],
		ModifyOptions[ZoomableOption,Default->False,Category->"Image Format"],

		(*** Plot Range Options ***)
		ModifyOptions[ListPlotOptions,{PlotRange,PlotRangeClipping,ClippingStyle}],

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel,FrameLabel,RotateLabel}],
		FrameUnitsOption,
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],
		TooltipOption,

		(*** Legend Options ***)
		ModifyOptions[LegendOption,Default->None],
		LegendPlacementOption,
		BoxesOption,

		(*** Secondary Data Options ***)
		SecondYOptions,

		(*** Data Specification Options ***)
		ErrorBarsOption,
		ErrorTypeOption,
		ScaleOption,
		TargetUnitsOption,

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background,ColorFunction,ColorFunctionScaling}],
		{
			OptionName->DateTicksFormat,
			Default->Automatic,
			Description->"Specify how date tick labels should be formatted.",
			AllowNull->False,
			Category->"Plot Style",
			Widget->Widget[Type->Expression,Pattern:>ListableP[_String],Size->Line]
		},
		ModifyOptions[ListPlotOptions,{Filling,FillingStyle,InterpolationOrder}],
		ModifyOptions[ListPlotOptions,{Joined},Category->"Plot Style"],
		ModifyOptions[ListPlotOptions,{PlotMarkers,PlotStyle}],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,{Frame,FrameStyle,FrameTicks,FrameTicksStyle}],

		(*** Grid Options ***)
		ModifyOptions[ListPlotOptions,{GridLines,GridLinesStyle}],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{Prolog,Epilog}],

		(*** Hidden Options ***)

		(* Hidden options which require no changes from their defaults in the shared option sets *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,

				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,IntervalMarkers,IntervalMarkersStyle,
				LabelingSize,MaxPlotPoints,Mesh,MeshFunctions,MeshShading,MeshStyle,
				Method,PerformanceGoal,PlotLayout,PlotLegends,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];

EmeraldDateListPlot[in:{},ops:OptionsPattern[]]:=EmeraldDateListPlot[{{Today,0}},ops];
EmeraldDateListPlot[
	in:oneDateListDataSetP|{(oneDateListDataSetP|{oneDateListDataSetP..})..},
	ops:OptionsPattern[]
]:=Catch[Module[{
		originalOps,safeOps,output,oneTraceP,primaryDataFull,numObjects,numPrimaryPer,
		primarDataFullUnitless,primaryTargetUnits,primaryErrorBars,xUnit,yUnit,xmin,xmax,ymin,ymax,
		normalizeYVals,reflectedTicks,plotRangeUnitless,yRangeRaw,primaryDataToPlot,
		secondaryDataFull,numSecondaryDimensions,emptyPositions,
		secondaryDataFullUnitless,secondaryYUnits,secondYUnit,xUnitNew,scaleMin,scaleMax,
		secondXRange,secondXRanges,secondYRanges,secondaryDataFullUnitlessScaled,secondYTicks,secondYColors,
		secondYGraphic,fractions,peaks,ladders,verticalLineEpilog,epilogs,
		frame,frameTicks,secondYColor,frameLabels,imageSize,plotStyle,legend,joined,tooltips,plotOptions,
		primaryDataToPlotWithTooltips,internalMMPlotOps,resolvedOps,unresolveableOps,optionsRule,plot,finalPlot,
		secondYStyle, mostlyResolvedOps
	},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldDateListPlot,checkForNullOptions[originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Set the pattern for a single trace *)
	oneTraceP=oneDateListDataSetP;

	(*** BEGIN OLD CODE ***)

	(** Primary Data Resolution **)
	(* Pad inputs and get their sizes *)
	{primaryDataFull,numObjects,numPrimaryPer}=padAndCheckData[EmeraldDateListPlot,in,oneTraceP,Lookup[safeOps,Scale, Null]];

	(* Convert all QAs to the sae units. Exit if anything can't be converted, and return the units they were converted to. *)
	{primarDataFullUnitless,primaryTargetUnits}=convertAndStripData[EmeraldDateListPlot,primaryDataFull,Lookup[safeOps,TargetUnits],Date];

	(* Unpack the target units for primary data *)
	{xUnit,yUnit}=primaryTargetUnits;

	(* Average any replicates in the input to produce a numeric dataset *)
	{primarDataFullUnitless,primaryErrorBars}=processReplicates[primarDataFullUnitless,Lookup[safeOps,ErrorBars],Lookup[safeOps,ErrorType],2];

	(* Normalize and/or reverse the primary data, if desired *)
	{primarDataFullUnitless,{xmin,xmax},{ymin,ymax},normalizeYVals,reflectedTicks}=scalePrimaryData[
		EmeraldDateListPlot,
		primarDataFullUnitless,
		yUnit,
		Lookup[safeOps,Normalize,False],
		Lookup[safeOps,Reflected,False],
		Lookup[safeOps,Scale],
		Date
	];

	(* Plot Range Resolution *)
	plotRangeUnitless=resolvePlotRange[Lookup[safeOps,PlotRange],Flatten[primarDataFullUnitless,1],primaryTargetUnits,primaryErrorBars,Reflected->Lookup[safeOps,Reflected,False],ScaleX->Lookup[safeOps,ScaleX],ScaleY->Lookup[safeOps,ScaleY]];
	yRangeRaw=Quiet[
		Last[resolvePlotRange[Lookup[safeOps,PlotRange],Flatten[primarDataFullUnitless,1],primaryTargetUnits,primaryErrorBars,ScaleX->1,ScaleY->1]],
		{Warning::InvalidRangeSpecification}
	];

	(* Flatten data to a list of traces and replace empty placeholders with something that LLP can handle *)
	primaryDataToPlot=Flatten[Replace[primarDataFullUnitless,{Null|{}->{{Null,Null}}},{2}],1];

	(** Secondary Data Resolution **)
	(* Expand to be list of coordinate sets, with corresponding things in common units *)
	{secondaryDataFull,numSecondaryDimensions,emptyPositions}=padAndCheckSecondaryData[EmeraldDateListPlot,Lookup[safeOps,SecondYCoordinates],numObjects,oneTraceP];

	(* convert to common units and strip units. Also return list of y-units corresponding to each different dimension. Reflect data if desired *)
	{secondaryDataFullUnitless,secondaryYUnits,secondYUnit,xUnitNew}=convertAndStripSecondaryData[EmeraldDateListPlot,secondaryDataFull,xUnit,Lookup[safeOps,SecondYUnit],Lookup[safeOps,Reflected,False],Date];

	(* Pad the plot range extremes for secondary scaling. This MUST be symmetric about 1 *)
	{scaleMin,scaleMax}=1+0.005*{-1,1};

	(* Resolve the y-range for second y value. Call full resolution but ignore the X-domain *)
	{secondXRanges,secondYRanges}=resolveSecondPlotRanges[Lookup[safeOps,SecondYRange],secondaryDataFullUnitless,xUnit,secondaryYUnits,{scaleMin,scaleMax},numSecondaryDimensions,emptyPositions];

	(* Scale secondYrange to the primary DataRange (NOT the primary PlotRange) *)
	secondaryDataFullUnitlessScaled=scaleSecondYData[EmeraldDateListPlot,secondaryDataFullUnitless,secondYRanges,yRangeRaw,{scaleMin,scaleMax}];

	(* Generate ticks for the right frame. Use primary data extremes, not the primary range. *)
	secondYTicks=makeSecondYTicks[secondaryDataFullUnitless,First[secondYRanges,Null],yRangeRaw,{scaleMin,scaleMax}];

	(* Colors for secondary colors *)
	secondYColors=resolveSecondYColors[Lookup[safeOps,SecondYColors],secondaryDataFullUnitless];

	(* Handle edge case with no primary and no secondary data *)
	secondXRange=Replace[First[secondXRanges,Null],Null->{0,1}];
	xUnitNew=Replace[xUnitNew,Automatic->1];

	(* Style for the secondary data lines *)
	secondYStyle = Lookup[safeOps,SecondYStyle];

	(* Handle edge case if primary data is Null but secondary data is provided *)
	If[And[MatchQ[primaryDataToPlot,{{{Null,Null}}}],MatchQ[First[plotRangeUnitless],Automatic|{Automatic,Automatic}]],
		plotRangeUnitless = {secondXRange,Last[plotRangeUnitless]};
	];

	(** Resolve Epilogs **)

	(* Format scaled data into colored lines *)
	secondYGraphic=makeSecondYGraphic[secondaryDataFullUnitlessScaled,secondYColors,secondYStyle];

	(* make peak graphic for primary data *)
	peaks=makePeakEpilogs[Analysis`Private`stripAppendReplaceKeyHeads[Lookup[safeOps,Peaks]],primarDataFullUnitless,secondaryDataFullUnitless,secondaryDataFullUnitlessScaled,plotRangeUnitless,{xUnit,yUnit},normalizeYVals,Lookup[safeOps,Reflected,False],safeOps];

	(* make fractions graphic *)
	fractions=makeFractionEpilogs[Lookup[safeOps,Fractions],Lookup[safeOps,FractionHighlights],Lookup[safeOps,FractionLabels],plotRangeUnitless,xUnit,Date,Lookup[safeOps,FractionColor],Lookup[safeOps,FractionHighlightColor]];

	(* make ladder graphics *)
	ladders=makeLadderEpilogs[Lookup[safeOps,Ladder],primarDataFullUnitless,plotRangeUnitless,xUnit];

	(* vertical line epilogs *)
	verticalLineEpilog = makeVerticalLineEpilog[Lookup[safeOps,VerticalLine,Null],xUnit,plotRangeUnitless];

	(* Join all the epilogs *)
	epilogs = {secondYGraphic,fractions,peaks,ladders,verticalLineEpilog,primaryErrorBars,Lookup[safeOps,Epilog]};

	(** Resolve remaining options **)
	(* Plot Frame *)
	frame = If[MatchQ[Lookup[safeOps,Frame],Automatic],
		resolveFrame[Lookup[safeOps,Frame],secondaryDataFullUnitless],
		Lookup[safeOps,Frame]
	];

	(* FrameTicks - add secondYTicks if secondary data was provided *)
	frameTicks = If[MatchQ[Lookup[safeOps,FrameTicks],Automatic],
		resolveFrameTicks[Lookup[safeOps,FrameTicks],secondYTicks,reflectedTicks,Lookup[safeOps,Scale]],
		Lookup[safeOps,FrameTicks]
	];

	(* In MM12 they stopped supporting True as a Frame option to DateListPlot *)
	If[$VersionNumber >= 12.0,frameTicks = Replace[frameTicks,True -> Automatic,{2}]];

	(* FrameLabel; Automatics resolve based on axis units *)
	secondYColor=If[MatchQ[secondYColors,{}],Null,secondYColors[[1,1]]];
	frameLabels = resolveFrameLabel[Lookup[safeOps,FrameLabel],Lookup[safeOps,FrameUnits],{xUnit,yUnit},secondYUnit,secondYColor];

	(* Image size option *)
	imageSize = resolveImageSize[Lookup[safeOps,ImageSize]];

	(* ColorFade primary data within each object *)
	plotStyle = resolvePlotStyle[Lookup[safeOps,PlotStyle],numObjects,numPrimaryPer];

	(* Legend resolution *)
	legend = formatPlotLegend[Replace[Lookup[safeOps,Legend],Automatic->Null],numObjects,numPrimaryPer,LegendPlacement->Lookup[safeOps,LegendPlacement],Boxes->Lookup[safeOps,Boxes],LegendColors->plotStyle];

	(* Resolve the Joined option *)
	joined = resolveJoinedOption[primarDataFullUnitless,Lookup[safeOps,Joined]];

	(* Resolve tooltips for primary data *)
	tooltips = resolvePrimaryTooltips[primarDataFullUnitless,Lookup[safeOps,Tooltip]];

	(* Join all the resolved plot options together *)
	plotOptions={
		(* for MM's function *)
		Axes->False,
		Frame->frame,
		FrameTicks->frameTicks,
		FrameLabel->frameLabels,
		PlotLegends->legend,
		ImageSize->imageSize,
		PlotStyle->plotStyle,
		Joined -> joined,
		PlotLabel->Replace[Lookup[safeOps,PlotLabel],Automatic->Null],
		(* our option *)
		Tooltip->tooltips
	};

	(* Add the tooltips option to data *)
	primaryDataToPlotWithTooltips=addTooltipsToPrimaryData[primaryDataToPlot,Lookup[plotOptions,Tooltip]];

	(*** END OLD CODE ***)

	(* Mostly resolved options to the emerald plot function *)

	(*
		MAKE THE PLOT
	*)

	(* Filter options for the internal call to DateListPlot, replacing options with our resolved values. *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldDateListPlot,DateListPlot,Quiet@checkForNullOptions[originalOps]]],
		ToList@stringOptionsToSymbolOptions[
			Sequence@@FilterRules[plotOptions,Options[DateListPlot]],
			PlotRange->plotRangeUnitless,
			Epilog->epilogs
		]
	];

	(* Since Mathematica 13, TargetUnits in DateListPlot function can only take a singleton instead of a list*)
	internalMMPlotOps = internalMMPlotOps/.Rule[TargetUnits, {__, y_}]->Rule[TargetUnits, y];

	(* Generate the plot *)
	plot=DateListPlot[primaryDataToPlotWithTooltips,internalMMPlotOps];

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options have been kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,internalMMPlotOps,Append->False];

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=Quiet[
		resolvedPlotOptions[plot,mostlyResolvedOps,DateListPlot],
		{Axes::axes}
	];

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

	(* This Catch/Throw is unfortunate. TODO: Rework helper functions *)
],"IncompatibleUnits"|"InvalidDimensions"];
