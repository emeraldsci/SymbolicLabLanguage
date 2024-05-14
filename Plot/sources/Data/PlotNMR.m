(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR*)


DefineOptions[PlotNMR,
	optionsJoin[{
		Options:>{
			{
				OptionName->PlotType,
				Description->"Specifies the method used to visualize the input data.",
				ResolutionDescription->"If set to Automatic, PlotType will be set to LinePlot unless three-dimensional spectra are found, in which case it will be set to WaterfallPlot.",
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>Automatic|LinePlot|WaterfallPlot],
				Category->"General"
			}
		},

		generateSharedOptions[
			Object[Data, NMR],
			NMRSpectrum,
			PlotTypes->{LinePlot},
			Display->{Peaks},
			DefaultUpdates->{
				FrameLabel->{"Chemical Shift",None,None,None}
			},
			AllowNullUpdates->{
				Display->True,
				Zoomable->True,
				Peaks->True,
				PrimaryData->True,
				FrameLabel->True
			},
			CategoryUpdates->{
				Peaks->"Peaks",
				NMRSpectrum->"Hidden",
				NMRFrequencySpectrum->"Hidden",
				FreeInductionDecay->"Hidden",
				TimedNMRSpectra->"Hidden",
				TimedNMRFrequencySpectra->"Hidden",
				TimedFreeInductionDecay->"Hidden",
				SpectralDomain->"Hidden",
				IncludeReplicates->"Hidden",
				OptionFunctions->"Hidden",
				(* Hide secondary data because none of the NMR fields share compatible X-units *)
				SecondaryData->"Hidden"
			}
		],
		Options:>{

			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False
					},
					{
						OptionName->Reflected,
						Default->True
					},
					{
						OptionName->Filling,
						Default->Bottom
					},
					{
						OptionName->Frame,
						Default->{True,False,False,False},
						Category->"Hidden"
					}
				}
			],

			(* Hide some unused options *)
			ModifyOptions[EmeraldListLinePlot,{ErrorBars,ErrorType,ColorFunction,ColorFunctionScaling,InterpolationOrder,Joined,PlotMarkers,ClippingStyle,PlotRangeClipping,FrameUnits},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,{SecondYUnit,SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle},Category->"Hidden"],
			ModifyOptions[PlotWaterfall,{Boxed,BoxStyle,ContourSpacing},Category->"Hidden"],

			(* Make line-specific options allow null *)
			ModifyOptions[EmeraldListLinePlot,
				{PeakLabels,PeakLabelStyle,ScaleX,ScaleY,Ladder,Fractions,FractionColor,FractionHighlights,FractionHighlightColor,GridLines,GridLinesStyle,FrameStyle,FrameTicks,FrameTicksStyle},
				{AllowNull->True}
			],

			(* Waterfall-specific labeling options *)
			ModifyOptions[PlotWaterfall,
				{LabelField,ContourLabels,ContourLabelPositions,ContourLabelStyle},
				{Category->"Waterfall Labels",AllowNull->True}
			],

			(* Waterfall-specific 3D view options *)
			ModifyOptions[PlotWaterfall,
				{WaterfallProjection,ProjectionDepth,ProjectionAngle,ViewPoint},
				{Category->"Waterfall 3D View",AllowNull->True}
			],

			(* Waterfall-specific axes options *)
			ModifyOptions[PlotWaterfall,
				{Axes,AxesEdge,AxesStyle,AxesLabel,AxesUnits},
				{Category->"Waterfall Axes",AllowNull->True}
			],

			(* Hide less common 3D view options *)
			ModifyOptions[PlotWaterfall,
				{ViewVector,ViewAngle,ViewRange},
				{Category->"Hidden",AllowNull->True}
			]
		}
	}],
	SharedOptions:>{
		EmeraldListLinePlot,
		PlotWaterfall,
		(* {PeakEpilog,{PeakSplitting}} *)
		ModifyOptions["Shared",PeakEpilogOptions,
			{PeakSplitting}
		]
	}
];


(* ::Subsection:: *)
(*Messages*)


Warning::WaterfallAxisFillingNotSupported="The specified Filling method (`1`) is not currently supported when PlotType is set to WaterfallPlot. Defaulting Filling to Bottom.";


(* ::Subsection:: *)
(*PlotNMR Core Function*)


(* Define lists of options specific to each PlotType *)
linePlotOps={Display,Zoomable,Peaks,PeakLabels,PeakLabelStyle,ScaleX,ScaleY,Ladder,Fractions,FractionColor,FractionHighlights,FractionHighlightColor,GridLines,GridLinesStyle,FrameLabel,FrameStyle,FrameTicks,FrameTicksStyle};
waterfallPlotOps={LabelField,ContourSpacing,ContourLabels,ContourLabelPositions,ContourLabelStyle,WaterfallProjection,ProjectionDepth,ProjectionAngle,ViewPoint,ViewVector,ViewAngle,ViewRange,Axes,AxesEdge,AxesStyle,AxesLabel,AxesUnits};


(* Define helper function that overrides PlotNMR defaults when PlotType is set to WaterfallPlot  *)
plotNMRWaterfall[primaryData:UnitCoordinatesP[],inputOptions:OptionsPattern[PlotNMR]]:=plotNMRWaterfall[{primaryData},inputOptions];
plotNMRWaterfall[primaryData:{UnitCoordinatesP[]..},inputOptions:OptionsPattern[PlotNMR]]:=plotNMRWaterfall[MapIndexed[{First@#2,#1}&,primaryData],inputOptions];
plotNMRWaterfall[primaryData:plotInputP|{Plot`Private`sparseStackedDataP..},inputOptions:OptionsPattern[PlotNMR]]:=Module[
	{output,safeOps,axes,axesLabel,plotLabel,reflected,filling,resolvedFilling,waterfallPlot,resolvedOptions,resolvedWaterfallOptions,resolvedNMROptions},

	(* Call SafeOptions to get PlotNMR defaults *)
	safeOps=SafeOptions[PlotNMR,ToList[inputOptions]];

	(* By default, only display X axis and label it "Chemical Shift" *)
	axes=If[MemberQ[Keys@ToList[inputOptions],Axes],Lookup[safeOps,Axes],{False,True,False}];
	axesLabel=If[MemberQ[Keys@ToList[inputOptions],AxesLabel],Lookup[safeOps,AxesLabel],{None,"Chemical Shift",None}];

	(* By default, if a single object was provided use its name as the PlotLabel *)
	plotLabel=If[
		MemberQ[Keys@ToList[inputOptions],PlotLabel],
		Lookup[safeOps,PlotLabel],
		If[
			MatchQ[primaryData,plotInputP],
			With[{objects=ToList[primaryData]},If[Length[objects]==1,ToString@((First@objects)[Object]),None]],
			None
		]
	];

	(* Set Reflected to True by default *)
	reflected=If[
		MemberQ[Keys@ToList[inputOptions],Reflected],
		Lookup[safeOps,Reflected],
		True
		];

	(* Set filling to Bottom when user specifies Axis and throw a warning. This is because Axis Filling is liable to crash PlotWaterfall as many polygons have to be transformed *)
	filling=Lookup[safeOps,Filling];
	resolvedFilling=If[
		MemberQ[Keys@ToList[inputOptions],Filling]&&MatchQ[filling,Axis],
		Message[Warning::WaterfallAxisFillingNotSupported,filling];Bottom,
		filling
	];

	(* Compile resolved options *)
	resolvedOptions=ReplaceRule[
		ToList[inputOptions],
		{Reflected->reflected,Axes->axes,AxesLabel->axesLabel,PlotLabel->plotLabel,Filling->resolvedFilling}
		];

	(* Call PlotWaterfall to generate plot and resolved options *)
	{waterfallPlot,resolvedWaterfallOptions}=PlotWaterfall[primaryData,PassOptions[PlotWaterfall,ReplaceRule[resolvedOptions,Output->{Result,Options}]]];

	(* Set LinePlot-specific options to Null *)
	resolvedNMROptions=ReplaceRule[
		resolvedWaterfallOptions,
		#->Null&/@Join[
			(* If input is a data object, keep LabelField, otherwise set it to Null *)
			If[MatchQ[primaryData,plotInputP],{},{LabelField}],
			linePlotOps
			]
	];

	(* Return requested output *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->waterfallPlot,
		Preview->Show[waterfallPlot,ImageSize->Full],
		Options:>ReplaceRule[SafeOptions[PlotNMR,resolvedOptions],Join[{Output->output},resolvedNMROptions]],
		Tests->{}
	}
];

(* Overload for raw 3D spectra input  *)
PlotNMR[primaryData:{Plot`Private`sparseStackedDataP..},inputOptions:OptionsPattern[PlotNMR]]:=Module[
	{resolvedOps},

	(* Set PlotType to Null so it is hidden in the builder *)
	resolvedOps=ReplaceRule[ToList@inputOptions,{PlotType->Null},Append->True];

	(* Call plot waterfall *)
	plotNMRWaterfall[primaryData,Sequence@@resolvedOps]

];

(* Overload for raw 2D spectra input  *)
PlotNMR[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotNMR]]:=Module[
	{safeOps,plotType,ellpOutput,nullOps},

	safeOps=SafeOptions[PlotNMR, ToList[inputOptions]];

	(* Resolve PlotType *)
	plotType=Replace[Lookup[safeOps,PlotType],Automatic->LinePlot];

	(* If PlotType is WaterfallPlot, route to plotNMRWaterfall. Otherwise route to ELLP *)
	If[SameQ[plotType,WaterfallPlot],
		plotNMRWaterfall[primaryData,inputOptions],

		(* Call ELLP, set WaterfallPlot-specific options to Null, then return processed output *)
		ellpOutput=rawToPacket[primaryData,Object[Data,NMR],PlotNMR,safeOps];
		nullOps=(#->Null&/@waterfallPlotOps);
		processELLPOutput[ellpOutput,safeOps,Join[{PlotType->plotType,PrimaryData->Null},nullOps]]
	]

];

(* Main function for Object[Data,NMR] input  *)
(* PlotNMR[infs:plotInputP,inputOptions:OptionsPattern[PlotNMR]]:= *)
PlotNMR[infs:ListableP[ObjectP[{Object[Data,NMR],Object[Data, NMR2D]}],2],inputOptions:OptionsPattern[PlotNMR]]:=Module[
	{safeOps,plotType,resolvedPlotType,objs,fields2D,fields3D,contains2D,contains3D,ellpOutput,nullOps,waterfallOnly=False},

	safeOps=SafeOptions[PlotNMR,ToList[inputOptions]];

	(* Resolve PlotType *)
	plotType=Lookup[safeOps,PlotType];
	resolvedPlotType=If[

		(* Automatic defaults to LinePlot unless only 3D data are available *)
		!MatchQ[plotType,Automatic],
		plotType,

		(* Flatten list of input objects *)
		objs=Cases[ToList@infs, ObjectP[Object[Data, NMR]], Infinity];

		(* Determine whether all input objects share a common 2D data set *)
		fields2D={NMRSpectrum,NMRFrequencySpectrum,SpectralDomain,FreeInductionDecay};
		contains2D=Or@@(MatchQ[#,{UnitCoordinatesP[]..}]&/@Transpose@Quiet[Download[objs,fields2D],{Download::FieldDoesntExist,Download::MissingField}]);

		(* Determine whether all input objects share a common 3D data set *)
		fields3D={TimedNMRSpectra,TimedNMRFrequencySpectra,TimedFreeInductionDecay};
		contains3D=Or@@(MatchQ[#,{{Plot`Private`sparseStackedDataP..}..}]&/@Transpose@Quiet[Download[objs,fields3D],{Download::FieldDoesntExist,Download::MissingField}]);

		(* If 2D are unavailable but 3D are available, default to WaterfallPlot. Mark waterfallOnly as True so we know to set PlotType option to Null *)
		If[!contains2D&&contains3D,waterfallOnly=True;WaterfallPlot,LinePlot]
	];

	(* If PlotType is WaterfallPlot, route to plotNMRWaterfall. Otherwise route to ELLP *)
	If[SameQ[resolvedPlotType,WaterfallPlot],
		plotNMRWaterfall[infs,ReplaceRule[ToList[inputOptions],If[TrueQ@waterfallOnly,{PlotType->Null},{PlotType->WaterfallPlot}]]],

		(* Call ELLP, set WaterfallPlot-specific options to Null, then return processed output *)
		ellpOutput=packetToELLP[infs,PlotNMR,ToList[inputOptions]];
		nullOps=(#->Null&/@waterfallPlotOps);
		processELLPOutput[ellpOutput,safeOps,Join[{PlotType->resolvedPlotType},nullOps]]
	]

];
