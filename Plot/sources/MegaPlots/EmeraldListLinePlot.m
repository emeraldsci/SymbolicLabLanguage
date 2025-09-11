(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListLinePlot*)


DefineOptions[EmeraldListLinePlot,
	Options :> {

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
		{
			OptionName -> ScaleX,
			Default -> 1,
			Description -> "Scales plot range padding in x-direction by this factor beyond the specified or resolved values.",
			AllowNull -> False,
			Category -> "Plot Range",
			Widget -> Widget[Type -> Number, Pattern :> GreaterP[0.]]
		},
		{
			OptionName -> ScaleY,
			Default -> 1.075,
			Description -> "Scales plot range padding in y-direction by this factor beyond the specified or resolved values.",
			AllowNull -> False,
			Category -> "Plot Range",
			Widget -> Widget[Type -> Number, Pattern :> GreaterP[0.]]
		},

		(*** Plot Labeling Options ***)
		ModifyOptions[ListPlotOptions,{PlotLabel,FrameLabel,RotateLabel}],
		FrameUnitsOption,
		ModifyOptions[ListPlotOptions,{LabelingFunction,LabelStyle}],
		TooltipOption,
		{
			OptionName -> VerticalLine,
			Default -> Null,
			Description -> "Specification for vertical line epilogs.  Full specification is {x-coordinate, relative y-height, label, style}.  Can mix different levels of specification in a list.",
			AllowNull -> True,
			Category -> "Plot Labeling",
			Widget -> Widget[Type -> Expression, Pattern :> Null|ListableP[_?UnitsQ|{_?UnitsQ,PercentP}|{_?UnitsQ,PercentP,_String|_Style}|{_?UnitsQ,PercentP,_String|_Style,__}], Size -> Line]
		},

		(*** Legend Options ***)
		LegendOption,
		LegendLabelOption,
		LegendPlacementOption,
		BoxesOption,

		(*** Secondary Data Options ***)
		SecondYOptions,

		(*** Data Specifications ***)
		ErrorBarsOption,
		ErrorTypeOption,
		ReflectedOption,
		ScaleOption,
		TargetUnitsOption,

		(*** Plot Style Options ***)
		ModifyOptions[ListPlotOptions,{Background,ColorFunction,ColorFunctionScaling,Filling,FillingStyle,InterpolationOrder}],
		ModifyOptions[ListPlotOptions,{Joined},Category->"Plot Style"],
		ModifyOptions[ListPlotOptions,{PlotMarkers,PlotStyle}],

		(*** Frame Options ***)
		ModifyOptions[ListPlotOptions,{Frame,FrameStyle,FrameTicks,FrameTicksStyle}],

		(*** Grid Options ***)
		ModifyOptions[ListPlotOptions,{GridLines,GridLinesStyle}],

		(*** Peaks Options ***)
		ModifyOptions[PeaksOption,{Peaks},Category->"Peaks"],
		{
			OptionName -> PeakLabels,
			Default -> Automatic,
			Description -> "Specification of labels which should be displayed with each set of peaks.",
			ResolutionDescription -> "If automatic, use peak labels in peaks object.",
			AllowNull -> True,
			Category -> "Peaks",
			Widget -> Widget[Type -> Expression, Pattern :> _String|ListableP[Automatic|Null|None|{_String..}], Size -> Paragraph]
		},
		{
			OptionName -> PeakLabelStyle,
			Default -> {12,RGBColor[0., 0.5, 1.],FontFamily->"Arial"},
			Description -> "The styling which should be used for the plot title.",
			AllowNull -> False,
			Category -> "Peaks",
			Widget ->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Red,Green,Blue,Black,White,Gray,Cyan,Magenta,Yellow,Brown,Orange,Pink,Purple]],
				{
					"Font Size"->Widget[Type->Number,Pattern:>GreaterP[0]],
					"Font Type"->Alternatives[
						Widget[Type->Expression,Pattern:>_,Size->Line],
						Widget[Type->Enumeration,Pattern:>Alternatives[Bold,Italic,Underlined]],
						Widget[Type->Color,Pattern:>ColorP]
					],
					"Font Family"->Alternatives[
						Widget[Type->Expression,Pattern:>_Rule,Size->Line,PatternTooltip->"The font family of the label, in the form FontFamily->_String."]
					]
				},
				Widget[Type -> Expression, Pattern :>_, Size -> Line, PatternTooltip->"The LabelStyle can be set to any valid graphics directive. Evaluate ?LabelStyle in the notebook for more information."]
			]
		},

		(*** Fractions Options ***)
		ModifyOptions[FractionsOption,{Fractions},Category->"Fractions"],
		{
			OptionName -> FractionColor,
			Default -> RGBColor[1,0,1],
			Description -> "Color for the fraction markers.",
			AllowNull -> False,
			Category -> "Fractions",
			Widget -> Widget[Type -> Color, Pattern :> ColorP]
		},
		{
			OptionName -> FractionHighlights,
			Default -> Null,
			Description -> "Fractions to highlight on the plot.",
			AllowNull -> True,
			Category -> "Fractions",
			Widget -> Widget[Type -> Expression, Pattern :> NullP|{(NullP|FractionP)...}|{{(NullP|FractionP)...}...}, Size -> Line]
		},
		{
			OptionName -> FractionHighlightColor,
			Default -> RGBColor[0.`,1.`,0.4`],
			Description -> "Color for the highlighted fraction markers.",
			AllowNull -> False,
			Category -> "Fractions",
			Widget -> Widget[Type -> Color, Pattern :> ColorP]
		},

		(*** Ladder Options ***)
		ModifyOptions[LadderOption,{Ladder},Category->"Ladder"],

		(*** General Options ***)
		ModifyOptions[ListPlotOptions,{Prolog,Epilog}],

		(*** Hidden Options ***)

		(* Hidden options specific to EmeraldListLinePlot *)
		NormalizeOption,
		IndexMatching[
			IndexMatchingParent->InsetImages,
			{
			OptionName -> InsetImages,
			Default -> Null,
			Description -> "Image or list of images to inset horizontally across the top of the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[Type -> Expression, Pattern :> NullP|_Image, Size -> Paragraph]
			},
			{
				OptionName->InsetImageSizeX,
				Default->Automatic,
				AllowNull->False,
				Category->"Hidden",
				Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0.]],
				Description->"The list of widths of the InsetImages in pixel."
			},
			{
				OptionName->InsetImagePositionX,
				Default->Automatic,
				AllowNull->False,
				Category->"Hidden",
				Widget->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
				Description->"The x-coordinate position that the InsetImage is placed on the overall plot graphic."
			}
		],
		{
			OptionName->XTransformationFunction,
			Default->Null,
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[Type->Expression,Pattern:>_List,Size->Line],
			Description->"List of symbolic functions which will transform the x-axis of the peak data."
		},
		
		{
			OptionName->InsetImageSizeY,
			Default->Automatic,
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Number,Pattern:> GreaterEqualP[0.]],
			Description->"The height of the InsetImages in pixel."
		},
		{
			OptionName->InsetImagePositionY,
			Default->Automatic,
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Number,Pattern:> RangeP[-Infinity,Infinity]],
			Description->"The y-coordinate position that the InsetImage is placed on the overall plot graphic."
		},

		(* Shared options from PeakEpilog which should be hidden *)
		ModifyOptions[PeakEpilogOptions,
			{
				Display,SecondYUnscaled,SecondYScaled,Yaxis,PeakSplitting,
				PeakPointSize,PeakPointColor,PeakWidthColor,PeakAreaColor
			},
			Category->"Hidden"
		],


		(* Hidden options to be inherited from the ListPlotOptions shared option set, without modification *)
		ModifyOptions[ListPlotOptions,
			{
				AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,AxesUnits,
				BaselinePosition,BaseStyle,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DataRange,DisplayFunction,FormatType,
				ImageMargins,ImagePadding,ImageSizeRaw,LabelingSize,
				MaxPlotPoints,Method,PerformanceGoal,PlotLabels,
				PlotLayout,PlotLegends,PlotRangePadding,PlotRegion,
				PlotTheme,PreserveImageOptions,ScalingFunctions,Ticks,TicksStyle
			}
		],

		(* Output option for command builder *)
		OutputOption
	}
];



(* Messages *)
EmeraldListLinePlot::PeakLabels="The peak label specifications could not be associated with the peaks. For each set of peaks, please provide a list of the strings you would like to use to label the peaks.";


(* ::Subsubsubsection:: *)
(*Source Code*)


EmeraldListLinePlot[in:oneDataSetP|{(oneDataSetP|{oneDataSetP..})..},ops:OptionsPattern[]]:=Catch[Module[{
		originalOps,safeOps,output,internalMMPlotOps,finalPlot,mostlyResolvedOps,resolvedOps,unresolveableOps,optionsRule,
		primaryErrorBars,xUnit,yUnit,ymin,ymax,primarDataFullUnitless,numObjects,normalizeYVals,numPrimaryPer,
		secondaryDataFullUnitless,secondaryDataFullUnitlessScaled,secondYTicks,plotRangeUnitless,primaryDataToPlot,
		secondYColors,epilogs,imageSize,oneTraceP,secondYUnit,reflectedTicks,plotOptions,secondXRange,
		primaryDataToPlotWithTooltips,yRangeRaw, primaryDataFull, primaryTargetUnits, xmin,xmax,
		secondaryDataFull,numSecondaryDimensions,emptyPositions, secondaryYUnits, xUnitNew,
		secondXRanges,secondYRanges, secondYGraphic,fractions,peaks,ladders,verticalLineEpilog,frame,
		frameTicks, secondYColor, frameLabels,	plotStyle, legend, joined, tooltips, junk,
		xyMeansQxStdDevsQyStdDevsQ,xyMeansQ,xStdDevsQ,yStdDevsQ, xStdDevsUnitless, yStdDevsUnitless,
		plotRangeApprox,unzoomableFig,expandedSafeOps,insetImages,updatedUnzoomableFig,allResolvedOptions,validResolvedOptions,secondYStyle,el,
		definitionToUse
	},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[EmeraldListLinePlot,Quiet[checkForNullOptions[originalOps]]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* pattern of a single trace *)
	oneTraceP = QuantityCoordinatesP[]|nullCoordinatesP|Null|{}|_Replicates | dateCoordinatesP | _?(And[MatchQ[Dimensions[#], {_Integer, 2}],
		MatrixQ[#,Function[{el},Or[UnitsQ[el],DistributionParameterQ[el]]]]]&);

	(*
		PRIMARY DATA RESOLUTION
	*)

	(* pad the data to be list of list of list, and make sure dimensions are consistent *)
	{primaryDataFull,numObjects,numPrimaryPer} = padAndCheckData[EmeraldListLinePlot,in,oneTraceP,Lookup[safeOps,Scale, Null]];

	(* ColorFade primary data within each object *)
 	plotStyle= resolvePlotStyle[Lookup[safeOps,PlotStyle],numObjects,numPrimaryPer];

	(*  *)
	xyMeansQxStdDevsQyStdDevsQ = Map[Analysis`Private`resolveDistributionInputs,primaryDataFull,{2}];
	xyMeansQ = xyMeansQxStdDevsQyStdDevsQ[[;;,;;,1]];
	(* these have extra layer of lists because possibly multi-dimensional independent variables *)
	xStdDevsQ = xyMeansQxStdDevsQyStdDevsQ[[;;,;;,2,;;,1]];
	yStdDevsQ = xyMeansQxStdDevsQyStdDevsQ[[;;,;;,3]];

	(* convert all QAs to the same unit.  Need this so their magnitudes are all on same scale *)
	(* if anything can't be converted due to incompatbile units, then exit *)
	(* this also converts things inside Replicates head but does not average yet *)
	(* also return the units that things were converted to *)
	{primarDataFullUnitless,primaryTargetUnits} = convertAndStripData[EmeraldListLinePlot,xyMeansQ,Lookup[safeOps,TargetUnits],Numerical];
	{xStdDevsUnitless,junk} = convertAndStripData[EmeraldListLinePlot,xStdDevsQ,First[primaryTargetUnits],Numerical];
	{yStdDevsUnitless,junk} = convertAndStripData[EmeraldListLinePlot,yStdDevsQ,Last[primaryTargetUnits],Numerical];
	
	{xUnit,yUnit} = primaryTargetUnits;

	(* average replicates and replace them with numeric data set *)
	{primarDataFullUnitless,primaryErrorBars} = processReplicates[primarDataFullUnitless,Lookup[safeOps,ErrorBars],Lookup[safeOps,ErrorType],2];

	(* normalize and/or reverse the primary data, if desired *)
	{primarDataFullUnitless,{xmin,xmax},{ymin,ymax},normalizeYVals,reflectedTicks} = scalePrimaryData[
		EmeraldListLinePlot,primarDataFullUnitless,yUnit,
		Lookup[safeOps,Normalize,False],Lookup[safeOps,Reflected,False],Lookup[safeOps,Scale],Numerical
	];

	If[
		And[MatchQ[Lookup[safeOps,ErrorBars],True],MatchQ[primaryErrorBars,{{{}...}...}]],
		(* need approximate plot range to get size scaling for error bars *)
		plotRangeApprox = Quiet[
			resolvePlotRange[Lookup[safeOps,PlotRange],Flatten[primarDataFullUnitless,1],primaryTargetUnits,{},ScaleX->1,ScaleY->1],
			{Warning::InvalidRangeSpecification}
		];
		primaryErrorBars = MapThread[
			MapThread[
				Function[{xy,xstd,ystd,color},errorBarsXY[xy,xstd,ystd,plotRangeApprox,color]],
				{#1,#2,#3,#4}
			]&,
			{primarDataFullUnitless,xStdDevsUnitless,yStdDevsUnitless,ArrayReshape[ToList[plotStyle], {numObjects,numPrimaryPer}]}
		];
	];

	(* need exact plot range (with no padding) for scaling the second-y data *)
	(* Our data can contain Null values which resolvePlotRange can handle. Swap out these Null values with zeros. *)
	yRangeRaw = Quiet[
		Last[resolvePlotRange[Lookup[safeOps,PlotRange],Flatten[primarDataFullUnitless,1]/.Null->0,primaryTargetUnits,{},ScaleX->1,ScaleY->1]],
		{Warning::InvalidRangeSpecification}
	];

	(* resolve the plot range.  Look at data if not specified *)
	plotRangeUnitless = resolvePlotRange[
		Lookup[safeOps,PlotRange],Flatten[primarDataFullUnitless,1],primaryTargetUnits,primaryErrorBars,
		Reflected->Lookup[safeOps,Reflected,False],ScaleX->Lookup[safeOps,ScaleX],ScaleY->Lookup[safeOps,ScaleY]
	];

	(* If reflected ticks were generated, update them to account for the resolved plot range *)
	reflectedTicks=If[MatchQ[reflectedTicks,Except[Null]]&&MatchQ[plotRangeUnitless,{{NumericP,NumericP},{NumericP,NumericP}}],
		Last@reflectAllPrimaryData[primarDataFullUnitless,plotRangeUnitless/.({{x_,y_},rest_}:>{{-y,-x},rest})],
		Null
	];

	(* flatten to list of traces and replace empty placeholders with a thing that LLP can handle *)
	primaryDataToPlot = Flatten[Replace[primarDataFullUnitless,{Null|{}->{{Null,Null}}},{2}],1];


	(*
		SECONDARY DATA RESOLUTION
	*)

	(* Expand to be list of coordinate sets, with corresponding things in common units *)
	{secondaryDataFull,numSecondaryDimensions,emptyPositions} = padAndCheckSecondaryData[EmeraldListLinePlot,Lookup[safeOps,SecondYCoordinates],numObjects,oneTraceP];

	(* convert to common units and strip units.  Also return list of y-units corresponding to each different dimension. Reflect data if desired *)
	{secondaryDataFullUnitless,secondaryYUnits,secondYUnit,xUnitNew} = convertAndStripSecondaryData[EmeraldListLinePlot,secondaryDataFull,xUnit,Lookup[safeOps,SecondYUnit],Lookup[safeOps,Reflected,False],Numerical];

	(* get y-range for second-y.  Just fully resolve it and then ignore the x domain *)
	{secondXRanges,secondYRanges} = resolveSecondPlotRanges[Lookup[safeOps,SecondYRange],secondaryDataFullUnitless,xUnit,secondaryYUnits,{1,1},numSecondaryDimensions,emptyPositions];
	(* scale everything to the plot range *)

	(* scale secondary data by scaling the secondYRange to the primary data range (NOT the primary plotrange) *)
	secondaryDataFullUnitlessScaled = scaleSecondYData[EmeraldListLinePlot,secondaryDataFullUnitless,secondYRanges,yRangeRaw,{1,1}];

	(* scale the x and y data if the scale is log, loglinear, or linearlog *)
	secondaryDataFullUnitlessScaled = logSecondData[EmeraldListLinePlot,secondaryDataFullUnitlessScaled,Lookup[safeOps,Scale]];

	(* ticks for right frame, if there is secondary data *)
	(* use primary data extremes here, not the primary range *)
	secondYTicks = makeSecondYTicks[secondaryDataFullUnitless,First[secondYRanges,Null],yRangeRaw,{1,1}];

	(* colors for secondary traces *)
	secondYColors = resolveSecondYColors[Lookup[safeOps,SecondYColors],secondaryDataFullUnitless];

	(* handle case of no primary and no secondary data *)
	secondXRange = Replace[First[secondXRanges,Null],Null->{0,1}];
	xUnit = Replace[xUnitNew,Automatic->1];

	(* Style for the secondary data lines *)
	secondYStyle = Lookup[safeOps,SecondYStyle];

	(* if primary data is all null, then set x-range based on secondary data *)
	If[And[MatchQ[primaryDataToPlot,{{{Null,Null}}}],MatchQ[First[plotRangeUnitless],Automatic|{Automatic,Automatic}]],
		plotRangeUnitless = {secondXRange,Last[plotRangeUnitless]};
	];

	(*
		EPILOGS
	*)

	(* format the scaled data into colored lines *)
	secondYGraphic = makeSecondYGraphic[secondaryDataFullUnitlessScaled,secondYColors,secondYStyle];

	(* make peak graphic for primary data *)
	peaks = makePeakEpilogs[
        Analysis`Private`stripAppendReplaceKeyHeads[Lookup[safeOps,Peaks]],
        primarDataFullUnitless,
        secondaryDataFullUnitless,
        secondaryDataFullUnitlessScaled,
        plotRangeUnitless,{xUnit,yUnit},
        normalizeYVals,
        Lookup[safeOps,Reflected,False],
        safeOps]
    ;

	(* make fractions graphic *)
	fractions = makeFractionEpilogs[Lookup[safeOps,Fractions],Lookup[safeOps,FractionHighlights],Lookup[safeOps,FractionLabels],plotRangeUnitless,xUnit,Numerical,Lookup[safeOps,FractionColor],Lookup[safeOps,FractionHighlightColor]];

	ladders = makeLadderEpilogs[Lookup[safeOps,Ladder],primarDataFullUnitless,plotRangeUnitless,xUnit];

	(* vertical line epilogs *)
	verticalLineEpilog = makeVerticalLineEpilog[Lookup[safeOps,VerticalLine,Null],xUnit,plotRangeUnitless];

	(* put it all together *)
	epilogs = {secondYGraphic,fractions,peaks,ladders,verticalLineEpilog,primaryErrorBars,Lookup[safeOps,Epilog]};

	(*
		PLOT OPTIONS
	*)

	frame = If[SameQ[Lookup[safeOps,Frame],Automatic],
		resolveFrame[Lookup[safeOps,Frame],secondaryDataFullUnitless],
		Lookup[safeOps,Frame]
	];

	(* full FrameTicks specification.  Add SecondY ticks if SecondY data exists. *)
	frameTicks = If[MemberQ[Flatten[ToList[Lookup[safeOps,FrameTicks]]],Automatic],
		resolveFrameTicks[Lookup[safeOps,FrameTicks],secondYTicks,reflectedTicks,Lookup[safeOps,Scale]],
		Lookup[safeOps,FrameTicks]
	];


	(*
		A bug in MM 13.2 breaks GridLines when Frame and FrameTicks are
		specified as {{_,_},{_,_}}, but it works ok if they're {_,_,_,_}.
		Only matching our known failing cases here to avoid unintended fallout
	*)
	If[$VersionNumber >= 13.2,
 		If[MatchQ[frame, {{True, False}, {True, False}}],
  			frame = {True, True, False, False}; 
  		];
 		If[MatchQ[frameTicks, {{True, False}, {True, False}}],
  			frameTicks = {True, True, False, False};
  		];
	];


	(*  full FrameLabel Autoamtics resolve based on axis units *)
	secondYColor = Which[
		MatchQ[secondYColors,{}],
		Null,

		(* If the number of colors are the same as the inputs and the secondY is only a list of *)
		(numSecondaryDimensions==1 && !MatchQ[Lookup[safeOps,SecondYColors],Automatic] && Length[Lookup[safeOps,SecondYColors]]==Length[secondYGraphic]),
		GrayLevel[0.3],

		True,
		secondYColors[[1,1]]
	];

	(* Only try to resolve the frame label if it's automatic. *)
	frameLabels =	If[MemberQ[ToList[Lookup[safeOps,FrameLabel]],Automatic],
		resolveFrameLabel[Lookup[safeOps,FrameLabel],Lookup[safeOps,FrameUnits],{xUnit,yUnit},secondYUnit,secondYColor],
		Lookup[safeOps,FrameLabel]
	];

	(* need this for sizing any inset images that will be added later *)
	imageSize = resolveImageSize[Lookup[safeOps,ImageSize]];
	(* legend *)
	legend = formatPlotLegend[Replace[Lookup[safeOps,Legend],Automatic->Null],numObjects,numPrimaryPer,LegendPlacement->Lookup[safeOps,LegendPlacement],Boxes->Lookup[safeOps,Boxes],LegendColors->plotStyle,
		LegendLabel->Replace[Lookup[safeOps,LegendLabel],(Automatic|Null)->None]
	];
	(*  *)
	joined = resolveJoinedOption[primarDataFullUnitless,Lookup[safeOps,Joined]];
	(* tooltips for primary data *)
	tooltips = resolvePrimaryTooltips[primarDataFullUnitless,Lookup[safeOps,Tooltip]];

	(* Strip units from GridLines *)
	gridLines=Lookup[safeOps,GridLines]/.quantity:_?QuantityQ:>Unitless[quantity];

	(* Gather our resolved options that will be piped directly into the mathematica plot function. *)
	plotOptions = {
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
		GridLines->gridLines,
		(* our option *)
		Tooltip->tooltips
	};

	(* Gather our resolved options that informed the creation of our Mathematica options. *)
	resolvedOptions={
		Legend->legend,
		PlotRange->plotRangeUnitless,
		SecondYColors->Flatten[secondYColors],
		SecondYUnit->secondYUnit,
		SecondYRange->If[MatchQ[secondYRanges,{_List..}],
			First[secondYRanges],
			secondYRanges
		],
		SecondYStyle->secondYStyle,
		(* FrameStyle is somehow overridden in the AbsoluteOptions of the plot. Force it to not resolve to the default. *)
		FrameStyle->OptionValue[FrameStyle]
	};

	(*
		FINAL DATA ADJUSTMENTS
	*)
	(* add Tooltip option to data, if desired *)
	primaryDataToPlotWithTooltips = addTooltipsToPrimaryData[primaryDataToPlot,Lookup[plotOptions,Tooltip]];

	(* Filter options for the internal call to ListLinePlot, replacing options with our resolved values *)
	internalMMPlotOps=ReplaceRule[
		ToList@stringOptionsToSymbolOptions[PassOptions[EmeraldListLinePlot,ListLinePlot,Quiet@checkForNullOptions[originalOps]]],
		ToList@stringOptionsToSymbolOptions[
			Sequence@@FilterRules[plotOptions,Options[ListLinePlot]],
			PlotRange->plotRangeUnitless,
			Epilog->epilogs
		]
	];

	(*
		MAKE THE PLOT
	*)

	(* Generate the plot *)
	unzoomableFig=ListLinePlot[primaryDataToPlotWithTooltips,internalMMPlotOps];
	
	(* add InsetImages if applicable *)
	insetImages = Cases[ToList[Lookup[safeOps,InsetImages]],_Image]/.{}->Null;
	(* For the ExpandIndexMatchedInputs, need to specify which definition we need to use for the checks. *)
	definitionToUse = If[MatchQ[in, oneDataSetP],
		1,
		3
	];
	expandedSafeOps=ExpandIndexMatchedInputs[EmeraldListLinePlot,{in},safeOps/.{(InsetImages->x_) -> (InsetImages->insetImages)}, definitionToUse][[2]];
	
	updatedUnzoomableFig = If[MatchQ[Length[insetImages],GreaterP[0]],
		Module[{expandedInsetImageSizeX,expandedInsetImagePositionX},
			expandedInsetImageSizeX = Lookup[expandedSafeOps,InsetImageSizeX];
			
			expandedInsetImagePositionX = Lookup[expandedSafeOps,InsetImagePositionX];
			
			addInsetImages[unzoomableFig,insetImages,plotRangeUnitless,Lookup[plotOptions,ImageSize],expandedInsetImageSizeX,Lookup[safeOps,InsetImageSizeY],expandedInsetImagePositionX,Lookup[safeOps,InsetImagePositionY]]
		],
		
		unzoomableFig
	];
	

	(* Mostly resolved options to emerald plot function, using ReplaceRule to ensure all options have been kept. *)
	mostlyResolvedOps=ReplaceRule[safeOps,ReplaceRule[plotOptions,resolvedOptions],Append->False]/.{
		(* ELLP-specific Automatic resolutions *)
		(* If PeakLabels did not resolve, replace them with none *)
		Rule[PeakLabels,Automatic]->Rule[PeakLabels,None],
		(* PeakSplitting should be False by default *)
		Rule[PeakSplitting,Automatic]->Rule[PeakSplitting,False],
		(* DataRange is bugged in MM's ListContourPlot so disable it for now *)
		Rule[DataRange,Automatic]->Rule[DataRange,Null],
		(* Resolve the FrameUnits option *)
		Rule[FrameUnits,Automatic]->Rule[FrameUnits,
			(* {{left,right},{bottom,top}} syntax*)
			{{yUnit,secondYUnit},{xUnit,None}}/.{Null->None}
		],
		(* Target units default resolve to provided units *)
		Rule[TargetUnits,Automatic]->Rule[TargetUnits,{xUnit,yUnit}]
	};


	MOSTLYRESOLVEDOPS=mostlyResolvedOps;

	(* Use the ResolvedPlotOptions helper to extract resolved options from the MM Plot (e.g. PlotRange) *)
	resolvedOps=Quiet[
		resolvedPlotOptions[updatedUnzoomableFig,mostlyResolvedOps,ListLinePlot],
		(* Absolute Options is bugged, remove this quiet once WRI has fixed it *)
		{Axes::axes}
	];

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

	(* Combine all of our options together, favoring our resolved options. *)
	(* allResolvedOptions=Normal[Association[Join[safeOps,Quiet[AbsoluteOptions[unzoomableFig]],plotOptions,resolvedOptions]]]; *)

	(* Make sure that these resolved options are filtered and are valid. *)
	(* Make sure to return the keys as symbols, not strings. *)
	(* validResolvedOptions=(ToExpression[#[[1]]]->#[[2]]&)/@ToList[Quiet[PassOptions[EmeraldListLinePlot,allResolvedOptions]]]; *)

	(* Apply Zoomable if it was requested*)
	finalPlot=If[TrueQ[Lookup[safeOps,Zoomable]],
		Zoomable[updatedUnzoomableFig],
		updatedUnzoomableFig
	];

	(* Return the result, according to the output option. *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{},
		optionsRule
	}

],"IncompatibleUnits"|"InvalidDimensions"];


(* ::Subsubsection:: *)
(*packetToELLP*)

OnLoad[
	Warning::MixedDataTypes="You are trying to plot data with types `1`. Only one type of data can be plotted at a time.";
	Error::InvalidPrimaryDataSpecification="The data you supplied could not be interpreted. Make sure your input listedness is compatible with the PrimaryData option. When plotting multiple sets of data, you may need to insert Nulls to keep the data correctly grouped.";
	Error::NullPrimaryData="No primary data was supplied/could be found in field `1`. Please check your input. You can also change the PrimaryData option to: `2`";
	Warning::MappedNullPrimaryData="No primary data was found in field(s) `1` of `2`. Please check your inputs.";
	Warning::NonMappableOption="Please check option `1`. You can specify a single value which will be applied to all plots. Alternatively you can specify a list with one value per plot. The default value will be used for this option.";
];

(*
packetToELLP creates a ListLinePlot using the values of relevant fields stored in the object.
"Except in the case of epilogs, the function requires that all options specifying data to plot must match a field name (e.g. SecondaryData->{MyTemperature} will fail if the field is called Temperature).",
"When epilog field names don't match their option names (e.g. Peaks vs. ChromatogramPeaksAnalyses), they are determined using look-up tables.",
"Any field values directly specified as options (e.g. Temperature -> t1) will override values in the packet and will be shown regardless of the default display options. If you don't wish to see the value, simply don't directly specify it in the plot call."
 *)
packetToELLP[inf:packetOrInfoP[],fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=packetToELLP[{inf},fnc,inputOptions];

packetToELLP[initialPackets:{packetOrInfoP[]..},fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=Module[
	{
		dataTypes,dataType,
		initialOps,opsWithDisplay,initialOpsNames,initialOpsValues,positionsOfUserOps,ops,
		linkedObjects,linkedPackets,joinedPackets,overriddenPackets,ellpOps,
		optionsFunctions,newOptionRules,plotFunctionOps,userSpecifiedOptions,safeUserOptions,
		primaryData,secondaryDataRule,epilogFields,epilogValues,epilogRules,imageRule,legendRule,labelRule,
		includeReplicates, replicates, primaryDataField, type, primaryMultipleQ, secondaryDataField, secondaryMultipleQ,
		flatPrimaryData, flatSecondaryDataRule, displayOp,imageSize
	},

	dataTypes = Lookup[#,Type]&/@initialPackets;

	If[Length[DeleteDuplicates[dataTypes]]>1,
		(Message[Warning::MixedDataTypes,dataTypes];Return[]),
		dataType = First[dataTypes]
	];

	(* Format options *)
	initialOps=Association[SafeOptions[fnc, ToList[inputOptions]]];
	initialOps[PrimaryData]=Flatten[{Lookup[initialOps,PrimaryData,{}]}];
	opsWithDisplay=Association[updateDisplayOptionsToShowSpecified[initialOps,First[Type/.initialPackets]]];

	(* Modify packets and list of packets to include linked and/or user specified data *)
	linkedObjects=DeleteDuplicatesBy[Cases[opsWithDisplay[LinkedObjects]/.initialPackets,ObjectP[],Infinity],#[Object]&];
	linkedPackets=DeleteDuplicatesBy[Download[linkedObjects],#[Object]&]; (* need this b/c duplicated objects can sneak into linkedObjects as objects vs links *)
	joinedPackets=Join[initialPackets,linkedPackets];
	overriddenPackets=overrideFieldsWithSpecified[joinedPackets,opsWithDisplay];

	(* Run functions to specially determine plot style options for a given parent plot type *)
	optionsFunctions = Lookup[opsWithDisplay, OptionFunctions, {}];

	newOptionRules=Flatten[#[overriddenPackets,opsWithDisplay]&/@optionsFunctions,1];

	plotFunctionOps=Association[ReplaceRule[Normal[opsWithDisplay],newOptionRules,Append->False]];

	(* Ultimately override all options with safe user options. *)
	userSpecifiedOptions = inputOptions[[All,1]];
	initialOpsNames = (Normal@initialOps)[[All,1]];
	initialOpsValues = (Normal@initialOps)[[All,2]];
	positionsOfUserOps = Flatten[Position[initialOpsNames,#]&/@userSpecifiedOptions];
	safeUserOptions = Association[MapThread[(#1->#2)&,{initialOpsNames[[positionsOfUserOps]],initialOpsValues[[positionsOfUserOps]]}]];

	(* In an association with repeated keys, the last key-value pair is used *)
	ops=Join[plotFunctionOps,safeUserOptions];

	displayOp=ToList[ops[Display]];

	(* pull out the IncludeReplicates option and Replicates field *)
	(* somehow, sometimes the IncludeReplicates option isn't included at all and so we need to default to False if it isn't there *)
	includeReplicates = Lookup[ops, IncludeReplicates, False];
	replicates = Lookup[overriddenPackets, Replicates];

	(* figure out if each PrimaryData and SecondaryData fields are multiple or not *)
	{primaryDataField, secondaryDataField} = Lookup[ops, {PrimaryData, SecondaryData}, {}];
	type = Lookup[First[overriddenPackets], Type];
	primaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[type, #], Format], Multiple]&,
		primaryDataField
	];
	secondaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[type, #], Format], Multiple]&,
		secondaryDataField
	];

	(* Pull core data set from packet *)
	(* If IncludeReplicates is set to true, get the primary data in all associated Replicates *)
	primaryData = MapThread[
		If[includeReplicates && Not[MatchQ[#2, Null|{}]],
			Module[{replicatePackets,correctedReplicatePackets,replicateRawData},
				replicatePackets=Download[#2];

				(* Add special handling for AbsThermo replicates - which need their spectrum extracted *)
				correctedReplicatePackets=If[MatchQ[replicatePackets,{PacketP[Object[Data, MeltingCurve]]..}],
					addCoordinatesToAbsThermoPackets[replicatePackets],
					replicatePackets
				];
				replicateRawData=Transpose[lookupWithUnits[correctedReplicatePackets,ops[PrimaryData]]];
				Replicates@@#1&/@replicateRawData
			],
			lookupWithUnits[#1,ops[PrimaryData]]
		]&,
		{overriddenPackets, replicates}
	];

	(* semi-flatten the primary data if we are dealing with a multiple primary data field *)
	flatPrimaryData = If[MatchQ[primaryMultipleQ, {True..}],
		Sequence @@@ primaryData,
		primaryData
	];

	If[MatchQ[flatPrimaryData,{{Null..}..}|{{}}],
		Message[
			Error::NullPrimaryData,
				ops[PrimaryData],
				Complement[linePlotTypeUnits[dataType][[All,1]],ops[PrimaryData]]
		];
		Return[];
	];

	(* Pull all secondary data and add units *)
	secondaryDataRule = SecondYCoordinates->(lookupWithUnits[#,ops[SecondaryData]]&/@overriddenPackets);

	(* semi-flatten if input is only one input data object with multiple secondary rules *)
	flatSecondaryDataRule = If[MatchQ[secondaryMultipleQ, {True}],
		SecondYCoordinates -> Sequence @@@ Last[secondaryDataRule],
		secondaryDataRule
	]/.{
		(* Fix for long-standing unit test failures *)
		Rule[SecondYCoordinates,{{}...}]->Rule[SecondYCoordinates,None],
		Rule[SecondYCoordinates,{{$Failed}...}]->Rule[SecondYCoordinates,None]
	};

	(* Resolve peak and fraction epilogs *)
	epilogFields=optionNameToFieldName[displayOp,First[Type/.overriddenPackets],ops[PrimaryData]];
	epilogValues=lookupWithUnits[overriddenPackets,#]&/@epilogFields;

	epilogRules=Switch[{epilogValues,displayOp},
		(* If no epilogs values were found, just return a dummy rule *)
		{NullP|{}|Null,_},{},
		(*if it's the fractions field, we need to convert*)
		{_,_},(MapThread[
			If[MatchQ[#1,Fractions],
				#1->#2/.{x_Association :> Values[x][[{4, 5, 3}]]},
				#1->#2
			]&,
			{displayOp,epilogValues}])
	];

	(* Resolve images *)
	imageRule=InsetImages->Flatten[Lookup[overriddenPackets,ops[Images],Null]];

	(* Automatically resolve legend *)
	legendRule = If[Lookup[ops, Legend] === Automatic,
		Legend -> autoResolveLegend[overriddenPackets, Length[linkedObjects], ops],
		Legend -> Lookup[ops, Legend]
	];

	(* Resolve the image size -- we need to do this so that we can feed it into autoResolvePlotLabel we are defaulting to 500 here because that is the ELLP default. If that changes, this will need to change as well *)
	imageSize=Switch[Lookup[ops,ImageSize,500],
		_?NumericQ,Lookup[ops,ImageSize,500],
		{_?NumericQ,_?NumericQ},First[Lookup[ops,ImageSize]],
		{{_?NumericQ,_?NumericQ},{_?NumericQ,_?NumericQ}},Last[First[Lookup[ops,ImageSize]]],
		_,500
	];

	(* Automatically resolve plot label *)
	labelRule=If[ops[PlotLabel]===Automatic,
		If[Length[inf]>1,
			PlotLabel->Null,
			PlotLabel-> If[MatchQ[dataType, Object[Data,FluorescenceSpectroscopy] | Object[Data,PAGE]],
				autoResolvePlotLabel[("\n" <> ToString[#,InputForm]) & /@ Lookup[overriddenPackets,Object,Null],{Bold, 14, FontFamily->"Arial"},imageSize],
				autoResolvePlotLabel[ToString[#,InputForm]&/@Lookup[overriddenPackets,Object,Null],ops[LabelStyle],imageSize]
			]
		],
		PlotLabel->ops[PlotLabel]
	];

	ellpOps = Join[
		{
			imageRule,
			legendRule,
			labelRule
		},
		FilterRules[Normal[ops],inputOptions],
		epilogRules,
		Normal[ops]
	];

	(* Call the plot function with the resolved options *)
	EmeraldListLinePlot[
		flatPrimaryData,
		flatSecondaryDataRule,
		PassOptions[EmeraldListLinePlot,ellpOps]
	]
];


(* Always map over outer lists *)
packetToELLP[infs:{{packetOrInfoP[]..}..},fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=(packetToELLP[#,fnc,inputOptions]&/@infs);
(* Convert allowed objects patterns to packets *)
packetToELLP[objs:(ListableP[ObjectReferenceP[],1]|ListableP[LinkP[],1]),fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=packetToELLP[Download[objs],fnc,inputOptions];
(* Download can't take double list, so Download entire flat list, then map over double list *)
packetToELLP[objs:(ListableP[ObjectReferenceP[],{2}]|ListableP[LinkP[],{2}]),fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=Module[{packets},
	packets = Download[Flatten[objs]];
	packetToELLP[Map[Download[#,Cache->Session]&,objs],fnc,inputOptions]
];


(* Map over inner lists when specified *)
packetToELLP[infs:{packetOrInfoP[]..},fnc_,inputOptions:{(_Rule|_RuleDelayed)...}]:=Module[
	{mappedOptions,optionsForEachPlot,mappedPlots,nullPrimaryIndices, nullObjs, nullPrimaryFields},

	(* Generate a separate list of options for each mapped plot function *)
	mappedOptions=updateOptionsForMapping[fnc,Length[infs],inputOptions];
	optionsForEachPlot=ReplaceRule[#,{Map->False,Output->Lookup[inputOptions,Output]}]&/@mappedOptions;

	(* The results of mapping, with extra error handling for NullPrimaryData errors *)
	mappedPlots=Quiet[
		MapThread[
			Check[
				packetToELLP[#1,fnc,#2],
				"NoPrimaryData",
				{Error::NullPrimaryData}
			]&,
			{infs,optionsForEachPlot}
		],
		{Error::NullPrimaryData}
	];

	(* Input indices which threw a NullPrimaryData error, empty list if no such errors were thrown. *)
	nullPrimaryIndices=Flatten@Position[mappedPlots,"NoPrimaryData"];

	(* Objects for which no primary data could be resolved *)
	nullObjs=Lookup[#,Object]&/@(Flatten@Part[infs,nullPrimaryIndices]);

	(* The requested primary data fields in the null outputs *)
	nullPrimaryFields=Lookup[SafeOptions[fnc,#],PrimaryData]&/@(Part[optionsForEachPlot,nullPrimaryIndices]);

	(* Warning message *)
	If[Length[nullPrimaryIndices]>1,
		Message[Warning::MappedNullPrimaryData,
			If[Length[DeleteDuplicates[nullPrimaryFields]]===1,First[nullPrimaryFields],nullPrimaryFields],
			nullObjs
		]
	];

	(* Return the mapped result *)
	mappedPlots/.{"NoPrimaryData"->Null}
]/;(Map/.inputOptions);


updateOptionsForMapping[functionName_,numberOfPlots_,ops_]:=Module[{optionNames,paddedOptions,specifiedOptionsForEachPlot,optionsForEachPlot},
	optionNames=ops[[All,1]];
	paddedOptions=padOptionForMapping[functionName,#,numberOfPlots,ops]&/@optionNames;
	specifiedOptionsForEachPlot=Transpose[paddedOptions]
];

(* This is the little helper function to recreate the OptionPatterns of old SLL2 *)
optionPatterns[functionName_]:=Module[{optionDef,allOptions,allPatterns,oldOptionPatternsOutput},
	optionDef = OptionDefinition[functionName];
	allOptions = Map[ToExpression[#["OptionName"]]&, optionDef];
	allPatterns = Map[
		If[KeyExistsQ[#,"SingletonPattern"],
			ReleaseHold[#["SingletonPattern"]],
			ReleaseHold[#["Pattern"]]
		]&,
		optionDef
	];

	oldOptionPatternsOutput = MapThread[#1 -> #2&, {allOptions, allPatterns}];

	oldOptionPatternsOutput

];

padOptionForMapping[functionName_,optionName_,numberOfPlots_,ops_]:=Module[{optionValue,optionList,pattern},
	optionValue=optionName/.ops;
	pattern=optionName/.Join[optionPatterns[functionName],optionPatterns[EmeraldListLinePlot]];
	optionList=
		optionList=Switch[{optionValue,Length[optionValue]},
			{{pattern..},numberOfPlots},optionValue,
			{pattern|singleOptionValues|Except[_List],_}, ConstantArray[optionValue,numberOfPlots],
			{_,_}, Message[Warning::NonMappableOption,optionName];Nothing
	];
	(optionName->#)&/@optionList
];

singleOptionValues=Alternatives[{#1&},{}];
