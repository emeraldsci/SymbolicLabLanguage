(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGating*)


DefineOptions[PlotGating,
	Options :> {
		{
			OptionName->DataSet,
			Default->Automatic,
			Description->"The dimensions of the data that should be plotted. {{Channels, Dimensions}..}.",
			AllowNull->False,
			Category->"Gating",
			Widget->Adder[{
				"Channel"->Widget[Type->Enumeration,Pattern:>Flatten[GatingChannelsP]],
				"Dimension"->Widget[Type->Enumeration,Pattern:>GatingDimensionsP]
			}]
		},
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"The type of plot used to visualize clustering.",
			ResolutionDescription->"Automatic resolves to ScatterPlot",
			AllowNull->False,
			Category->"Gating",
			Widget->Widget[Type->Enumeration,Pattern:>ScatterPlot|ContourPlot|Histogram|SmoothHistogram]
		},

		(* Options specific to Histogram, allowing Null so they can be hidden *)
		{
			OptionName->BinSpec,
			Default->50,
			Description->"Bin specification for histogram. Default is 50 bins.",
			AllowNull->True,
			Category->"Histogram",
			Widget->Alternatives[
				"Number of bins"->Widget[Type->Number,Pattern:>GreaterP[0,1]],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				"Other"->Widget[Type->Expression,Pattern:>({_Integer}|_String|{_,_,_}),Size->Line]
			]
		},
		ModifyOptions[EmeraldHistogram,{BarOrigin},Category->"Histogram",AllowNull->True],

		(* Default legend placement is on the right side *)
		ModifyOptions[LegendPlacementOption,Default->Right],

		(* Output options for the command builder *)
		OutputOption
	},
	SharedOptions :> {
		{EmeraldListLinePlot,
			(* Options common to EmeraldListLinePlot, EmeraldHistogram, and EmeraldSmoothHistogram *)
			{
				AlignmentPoint,AspectRatio,Axes,AxesLabel,AxesOrigin,AxesStyle,
				Background,BaselinePosition,BaseStyle,ColorFunction,
				ColorFunctionScaling,ColorOutput,ContentSelectable,
				CoordinatesToolOptions,DisplayFunction,Epilog,FormatType,Frame,
				FrameLabel,FrameStyle,FrameTicks,FrameTicksStyle,
				GridLines,GridLinesStyle,ImageMargins,ImagePadding,ImageSize,
				ImageSizeRaw,LabelingSize,LabelStyle,Legend,LegendPlacement,Method,
				PerformanceGoal,PlotLabel,PlotRange,PlotRangeClipping,
				PlotRangePadding,PlotRegion,PlotTheme,PreserveImageOptions,
				Prolog,RotateLabel,Scale,ScalingFunctions,TargetUnits,Ticks,
				TicksStyle,Zoomable
			}
		}
	}
];

(* Messages and Errors *)
PlotGating::badTargetUnits="The length of TargetUnits does not match the length of DataSet.";
PlotGating::noSuchDataSet="The DataSet `1` does not exist in `2`.";


(* Object[Analysis,Gating] - Download appropriate fields and pass to primary overload *)
PlotGating[data:ListableP[objectOrLinkP[Object[Analysis,Gating]]],ops:OptionsPattern[PlotGating]]:=Module[
	{safeOps,output},

	(* Populate unspecified options with defaults *)
	safeOps=SafeOptions[PlotGating,ToList[ops]];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Error out and return early if the input cannot be found in the database *)
	If[!(And@@DatabaseMemberQ[data]),
		Message[Generic::MissingObject, PlotGating, data];
		output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}},
		(PlotGating[Download[data, Packet[Channels, Dimensions, GroupLabels, ClusterChannels, ClusterDimensions, GroupData, DimensionUnits]], ops])
	]
];

(* Object[Data,FlowCytometry] - Download object and pass to Packet[Data,FlowCytometry] overload *)
PlotGating[object:ListableP[objectOrLinkP[Object[Data,FlowCytometry]]],ops:OptionsPattern[PlotGating]]:=Module[
	{safeOps,output},

	(* Populate unspecified options with defaults *)
	safeOps=SafeOptions[PlotGating,ToList[ops]];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Error out and return early if the input cannot be found in the database *)
	If[!(And@@DatabaseMemberQ[object]),
		Message[Generic::MissingObject,PlotGating,object];
		output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}},
		(PlotGating[Download[object, Packet[GatingAnalyses]],ops])
	]
];

(* PacketP[Object[Data,FlowCytomery]] - Check if a linked Gating Analysis exists, and pass on if it does. *)
PlotGating[inf:PacketP[Object[Data,FlowCytometry]],ops:OptionsPattern[PlotGating]]:=Module[
	{safeOps,output},

	(* Populate unspecified options with defaults *)
	safeOps=SafeOptions[PlotGating,ToList[ops]];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Error out and return early if the input cannot be found in the database *)
	If[MatchQ[GatingAnalyses/.inf,{}],
		output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}},
		PlotGating[Last[GatingAnalyses/.inf][Object],ops]
	]
];

(* Listable Overload *)
PlotGating[
	objs:{PacketP[{Object[Analysis,Gating],Object[Data,FlowCytometry]}]..},
	ops:OptionsPattern[PlotGating]
]:=Map[PlotGating[#,ops]&,objs];


(*** Primary Overload ***)
PlotGating[inf:PacketP[Object[Analysis,Gating]],ops:OptionsPattern[PlotGating]]:=Module[
	{
		originalOps,safeOps,plottypeOpt,targetUnitsOpt,datasetOpt,frameLabelOpt,xDim,yDim,zDim,
		mergeFieldName,allFieldList,clusterFieldList,frameLabel,groupedData,labels,
		result,mostlyResolvedOps,resolvedOps
	},

	(* original options passed to the function *)
	originalOps=ToList[ops];

	(* default the options *)
	safeOps=SafeOptions[PlotGating, originalOps];

	(* requested output from command builder *)
	output=Lookup[safeOps,Output];

	(* pull out some option values *)
	plottypeOpt=Lookup[safeOps,PlotType];
	datasetOpt=Lookup[safeOps,DataSet];
	targetUnitsOpt=Lookup[safeOps,TargetUnits];
	frameLabelOpt=Lookup[safeOps,FrameLabel];
	labels=Lookup[inf,GroupLabels];

	(* quit if list of target units is not the same length as list of datasets *)
	If[!MatchQ[targetUnitsOpt,Automatic]&&!MatchQ[datasetOpt,Automatic]&&Length[targetUnitsOpt]!=Length[ToList@datasetOpt],
		Message[PlotGating::badTargetUnits];
		Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]
	];

	(* Generate lists of names for the fields and clusters *)
	mergeFieldName[ch_, dim_]:=ToExpression[ToString[ch]<>ToString[dim]];
	allFieldList=MapThread[mergeFieldName[#1,#2]&,{Lookup[inf,Channels],Lookup[inf,Dimensions]}];
	clusterFieldList=MapThread[mergeFieldName[#1,#2]&,{Lookup[inf,ClusterChannels],Lookup[inf,ClusterDimensions]}];

	(* Resolved default value of the DataSet option *)
	defaultDataSet=Transpose@{Lookup[inf,ClusterChannels],Lookup[inf,ClusterDimensions]};

	(* Group Data from info packet *)
	groupedData = Normal[Values[Lookup[inf, GroupData]]];

	(* Find x-indices of raw data *)
	xDim=If[MatchQ[datasetOpt, Automatic],
		First[First[Position[allFieldList, First[clusterFieldList]]]],
		First[FirstOrDefault[
			Position[allFieldList,mergeFieldName[Sequence@@First[ToList@datasetOpt]]],
			Hold[Message[PlotGating::noSuchDataSet,First[ToList@datasetOpt],Object/.inf]; Null]
		]]
	];

	(* Find y-indices of raw data *)
	yDim=If[Length[datasetOpt]>=2,
		First[FirstOrDefault[
			Position[allFieldList,mergeFieldName[Sequence@@(ToList@datasetOpt)[[2]]]],
			Hold[Message[PlotGating::noSuchDataSet,(ToList@datasetOpt)[[2]],Object/.inf]; Null]
		]],
		First[First[Position[allFieldList, (clusterFieldList)[[2]]]]]
	];

	(*if there is a third dimensions set zDim*)
	zDim=If[Length[datasetOpt]==3,
		First[FirstOrDefault[
			Position[allFieldList,(ToList@datasetOpt)[[3]]],
			Hold[Message[PlotGating::noSuchDataSet,(ToList@datasetOpt)[[3]],Object/.inf]; Null]
		]],
		Null
	];

	(* quit if the DataSet was not found in allFieldList *)
	If[MatchQ[xDim, Null],Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]];

	(* resolve Automatic frameLabel *)
	frameLabel=Switch[frameLabelOpt,
		Automatic|{Automatic,Automatic}|{Automatic,Automatic,Automatic}, Automatic,
		{Automatic,_String}, {ToString@allFieldList[[xDim]], frameLabelOpt[[2]]},
		{_String,Automatic}, {frameLabelOpt[[1]], ToString@allFieldList[[yDim]]},
		{_String,_String}|{_String,_String,_String}, frameLabelOpt,
		{Automatic,Automatic,_String}, {ToString@allFieldList[[xDim]], ToString@allFieldList[[yDim]], frameLabelOpt[[3]]},
		{Automatic,_String,Automatic}, {ToString@allFieldList[[xDim]], frameLabelOpt[[2]], ToString@allFieldList[[zDim]]},
		{_String,Automatic,Automatic}, {frameLabelOpt[[1]], ToString@allFieldList[[yDim]], ToString@allFieldList[[zDim]]},
		{_String,_String,Automatic}, {frameLabelOpt[[1]], frameLabelOpt[[2]], ToString@allFieldList[[zDim]]},
		{_String,Automatic,_String}, {frameLabelOpt[[1]], ToString@allFieldList[[yDim]], frameLabelOpt[[3]]},
		{Automatic,_String,_String}, {ToString@allFieldList[[xDim]], frameLabelOpt[[2]], frameLabelOpt[[3]]},
		_,frameLabelOpt
	];

	(* -------------------- pass off to core function -------------------- *)
	{result,mostlyResolvedOps}=Switch[plottypeOpt,

		Histogram, Module[{axes, targetUnits},
			(*find units for those axes*)
			axes = If[MatchQ[DimensionUnits/.inf, {Null}],
				Table[None, {i,1,Length[ClusterDimensions/.inf]}],
				((DimensionUnits/.inf)[[xDim]])
			];
			targetUnits = If[MatchQ[targetUnitsOpt, Automatic], {axes}, targetUnitsOpt];
			(* pass to core function *)
			EmeraldHistogram[QuantityArray[#, axes]& /@ groupedData[[All,All,xDim]],BinSpec/.safeOps,
				ReplaceRule[
					ToList@stringOptionsToSymbolOptions[PassOptions[PlotGating, EmeraldHistogram, safeOps]],
					{
						FrameLabel->If[MatchQ[frameLabel, Automatic],{ToString@allFieldList[[xDim]], "Count", None, None}, {frameLabel, "Count", None, None}],
						TargetUnits->First@targetUnits,
						Legend->(Legend/.safeOps)/.{Automatic->None},
						Output->{Result,Options}
					}
				]
			]
		],

		SmoothHistogram, Module[{axes, targetUnits},
			(*find units for those axes*)
			axes = If[MatchQ[DimensionUnits/.inf, {Null}],
				Table[None, {i,1,Length[ClusterDimensions/.inf]}],
				((DimensionUnits/.inf)[[xDim]])
			];
			targetUnits = If[MatchQ[targetUnitsOpt, Automatic], {axes}, targetUnitsOpt];
			(* pass to core function *)
			EmeraldSmoothHistogram[QuantityArray[#, axes]& /@ groupedData[[All,All,xDim]],BinSpec/.safeOps,
				ReplaceRule[
					ToList@stringOptionsToSymbolOptions[PassOptions[PlotGating,EmeraldSmoothHistogram,safeOps]],
					{
						FrameLabel->If[MatchQ[frameLabel, Automatic],{ToString@allFieldList[[xDim]], "Count", None, None}, {frameLabel, "Count", None, None}],
						TargetUnits->First@targetUnits,
						PlotLegends->(Legend/.safeOps)/.{Automatic->None},
						Output->{Result,Options}
					}
				]
			]
		],

		ContourPlot, Module[{axes, targetUnits},
			If[MatchQ[yDim,Null], Return[Null]];
			(*find units for those axes*)
			axes = If[MatchQ[DimensionUnits/.inf,{Null}],
				Table[None,{i,1,Length[ClusterDimensions/.inf]}],
				((DimensionUnits/.inf)[[{xDim, yDim}]])
			];
			targetUnits = If[MatchQ[targetUnitsOpt, Automatic], axes, targetUnitsOpt];
			(* pass to core function *)
			contourPlotGating[
				Convert[#,axes,targetUnits]& /@ groupedData[[All,All,{xDim,yDim}]],
				Join[{TargetUnits->targetUnits, DataSet->allFieldList[[{xDim,yDim}]]}, safeOps]
			]
		],

		ScatterPlot|Automatic,
			(*plot in 3d in 3 dimensions are specified*)
			If[Length[OptionValue[DataSet]]==3,

				(* 3D Data *)
				Module[{axes, targetUnits},
					If[MatchQ[zDim, Null]|MatchQ[yDim,Null], Return[Null]];
					(*find units for those axes*)
					axes = If[MatchQ[DimensionUnits/.inf, {Null}],
						Table[None, {i,1,3}],
						((DimensionUnits/.inf)[[{xDim, yDim, zDim}]])
					];
					targetUnits = If[MatchQ[targetUnitsOpt, Automatic], axes, targetUnitsOpt];
					(* pass to core function *)
					EmeraldListPointPlot3D[QuantityArray[#, axes]& /@ groupedData[[All,All,{xDim,yDim,zDim}]],
						ReplaceRule[
							ToList@stringOptionsToSymbolOptions[PassOptions[PlotGating,EmeraldListPointPlot3D,safeOps]],
							{
								Legend->labels,
								AxesLabel->If[MatchQ[frameLabel, Automatic],Append[ToString /@ allFieldList[[{xDim, yDim, zDim}]], None],Append[frameLabel, None]],
								TargetUnits->targetUnits,
								Output->{Result,Options}
							}
						]
					]
				],

				(* 2D Data *)
				Module[{axes, targetUnits},
					If[MatchQ[yDim,Null], Return[Null]];
					(*find units for those axes*)
					axes = If[MatchQ[DimensionUnits/.inf,{Null}],
						Table[None,{i,1,Length[ClusterDimensions/.inf]}],
						((DimensionUnits/.inf)[[{xDim, yDim}]])
					];
					targetUnits = If[MatchQ[targetUnitsOpt, Automatic], axes, targetUnitsOpt];
					(* pass to core function *)
					EmeraldListLinePlot[QuantityArray[#, axes]& /@ groupedData[[All,All,{xDim,yDim}]],
						ReplaceRule[
							ToList@stringOptionsToSymbolOptions[PassOptions[PlotGating,EmeraldListLinePlot,safeOps]],
							{
								Tooltip->labels,
								Joined->False,
								TargetUnits->targetUnits,
								FrameLabel-> If[MatchQ[frameLabel, Automatic],ToString /@ allFieldList[[{xDim, yDim}]],frameLabel],
								Legend->If[MemberQ[originalOps,Legend->_],Lookup[originalOps,Legend],labels],
								Boxes->True,
								Output->{Result,Options}
							}
						]
					]
				]
			],

		(* Plot resolution failed *)
		_, {$Failed,$Failed}
	];

	(* Return early if plotting failed *)
	If[MatchQ[result,$Failed],
		Return[output/.{Result->$Failed,Options->$Failed,Preview->Null,Tests->{}}]
	];

	(* Finish resolving options *)
	resolvedOps=ReplaceRule[
		(* Swap in options from the subfunction calls *)
		ReplaceRule[safeOps,mostlyResolvedOps,Append->False],
		(* Options unique to PlotGating*)
		{
			(* sub in original output option *)
			Output->output,
			(* Default PlotType is ScatterPlot *)
			PlotType->plottypeOpt/.{Automatic->ScatterPlot},
			(* Default DataSet was resolved Above*)
			DataSet->datasetOpt/.{Automatic->defaultDataSet},
			(* Extract text from placed legends *)
			Legend->Lookup[mostlyResolvedOps,Legend]/.{Placed[x_,___]:>Sequence@@Cases[x,{_Style ..},Infinity]},
			(* If plot type isn't histogram, set the histogram-specific options to Null *)
			Sequence@@If[plottypeOpt=!=Histogram,{BinSpec->Null,BarOrigin->Null},{Nothing}]
		},
		Append->True
	];

	(* Return the requested outputs *)
	output/.{
		Result->result,
		Preview->result/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
];


(* --- Core Function: Contour Plot --- *)
contourPlotGating[raw:{{{(_?NumericQ|_?FluorescenceQ),(_?NumericQ|_?FluorescenceQ)}..}..},ops_List]:=Module[
	{unitsOpt,datasetOpt,plotrangeOpt,frameLabelOpt,
	unitsForPlotting,datasets,converted,numClusters,plotrange,plot,resolvedOps,finalPlot,joinedPlot,framelabels},

	(* pull out some option values *)
	unitsOpt = TargetUnits/.ops;
	datasetOpt = DataSet/.ops;
	plotrangeOpt = PlotRange/.ops;
	frameLabelOpt = FrameLabel/.ops;

	(*get the units information - if TargetUnits->Automatic, set to {Null,Null}*)
	unitsForPlotting = If[MatchQ[unitsOpt,Automatic],{None,None},unitsOpt];

	(*get the information on the datasets being plotted - if DataSet->Automatic, set to {"",""}*)
	datasets = If[MatchQ[datasetOpt,Automatic],{"",""},ToString/@datasetOpt];

	(* Convert the data to Unitless form *)
	converted=Unitless[raw];

	(* Compute the number of clusters *)
	numClusters = Length[converted];

	(* Determine the plot range *)
	plotrange = FindPlotRange[plotrangeOpt,Flatten[converted,1]];

	(*make the frame labels*)
	framelabels = Switch[frameLabelOpt,
		Automatic,{First[datasets]<>" "<>UnitForm[First[unitsForPlotting],Number->False],Last[datasets]<>" "<>UnitForm[Last[unitsForPlotting],Number->False]},
		{Automatic,_String},{First[datasets]<>" "<>UnitForm[First[unitsForPlotting],Number->False],frameLabelOpt[[2]]},
		{_String,Automatic},{frameLabelOpt[[1]],Last[datasets]<>" "<>UnitForm[Last[unitsForPlotting],Number->False]},
		_,frameLabelOpt
	];

	(* Plot the data as a scatter plot and overlay the convex hulls of the clusters *)
	{plot,resolvedOps}=EmeraldListLinePlot[
		{Sequence@@Repeat[Null,numClusters],(Join@@converted)[[All,1;;2]]},
		ReplaceRule[
			ToList@stringOptionsToSymbolOptions[PassOptions[PlotGating,EmeraldListLinePlot,ops]],
			{
				PlotRange->plotrange,
				FrameLabel->framelabels,
				Legend->Lookup[ToList[ops],Legend,None],
				Joined->False,
				TargetUnits->Automatic,
				Zoomable->False,
				Output->{Result,Options}
			}
		]
	];

	(* Generate the final plot *)
	joinedPlot=Show[plot,
		Sequence@@Table[
			HighlightMesh[
				ConvexHullMesh[converted[[i,All,1;;2]]],
				{Style[1,Thick,ColorData[97][i]],Style[2,Opacity[0]]}
			],
		{i,1,numClusters}]
	];

	(* Apply the Zoomable option if requested *)
	finalPlot=If[TrueQ[Zoomable/.ops],Zoomable[joinedPlot],joinedPlot];

	(* Return the last plot and the resolved options *)
	{finalPlot,resolvedOps}
];


(*  Raw Data overload - mostly unused but keeping for posterity *)
PlotGating[raw:{{{_?NumericQ..}..}..}|{QuantityArrayP[]..},ops:OptionsPattern[PlotGating]]:=Module[
	{defaultedOptions,plottypeOpt,datasetOpt,targetUnitsOpt,frameLabelOpt,xDim,yDim,zDim},

	(* default the options *)
	defaultedOptions = SafeOptions[PlotGating, ToList[ops]];

	(* pull out some option values *)
	plottypeOpt = PlotType/.defaultedOptions;
	datasetOpt = DataSet/.defaultedOptions;
	targetUnitsOpt = TargetUnits/.defaultedOptions;
	frameLabelOpt = FrameLabel/.defaultedOptions;

	(*find x and y indices for the raw data*)
	xDim=If[MatchQ[datasetOpt, Automatic],
		1,
		First[ToList@datasetOpt]
	];

	If[xDim > Length[raw[[1,1]]], Message[PlotGating::noSuchDataSet,xDim,"the given raw data."]; xDim = Null];
	yDim=Which[
		MatchQ[plottypeOpt, Histogram|HistogramList], Null,
		Length[datasetOpt]>=2,(ToList@datasetOpt)[[2]],
		MatchQ[datasetOpt, Automatic], 2
	];
	If[Not[MatchQ[yDim,Null]] && (yDim > Length[raw[[1,1]]]), Message[PlotGating::noSuchDataSet,yDim,"the given raw data."]; yDim = Null];

	(*if there is a third dimensions set zDim*)
	zDim=If[Length[datasetOpt]==3,
		(ToList@datasetOpt)[[3]],
		Null
	];

	(* quit if the given DataSet exceeded the dimensions of the data *)
	If[MatchQ[xDim, Null], Return[Null]];

	Switch[plottypeOpt,

		Histogram,
			Quiet@EmeraldHistogram[
				raw[[All, All, xDim]],
				BinSpec/.defaultedOptions,
				FrameLabel->If[MatchQ[frameLabelOpt, Automatic],Automatic, {ToString@frameLabelOpt, "Count", None, None}],
				PassOptions[PlotGating, EmeraldHistogram, defaultedOptions]
			],

		SmoothHistogram,
			Quiet@EmeraldSmoothHistogram[
				raw[[All, All, xDim]],
				BinSpec/.defaultedOptions,
				FrameLabel->If[MatchQ[frameLabelOpt, Automatic], Automatic, {ToString@frameLabelOpt, "Count", None, None}],
				PlotLegends->Legend/.defaultedOptions,
				PassOptions[PlotGating, EmeraldSmoothHistogram, defaultedOptions]
			],

		ContourPlot,
			If[MatchQ[yDim,Null], Return[$Failed]];
			contourPlotGating[
				raw[[All, All, {xDim, yDim}]],
				defaultedOptions
			],

		ScatterPlot|Automatic,
			(*plot in 3d in 3 dimensions are specified*)
			If[Length[OptionValue[DataSet]]==3,
				If[MatchQ[zDim, Null]|MatchQ[yDim,Null], Return[$Failed]];
				EmeraldListPointPlot3D[
					raw[[All,All,{xDim,yDim,zDim}]],
					AxesLabel->If[MatchQ[frameLabelOpt, Automatic], Automatic, Append[frameLabelOpt, None]],
					PassOptions[PlotGating,EmeraldListPointPlot3D,defaultedOptions]
				],
				If[MatchQ[yDim,Null], Return[$Failed]];
				Quiet@EmeraldListLinePlot[
					raw[[All,All,{xDim,yDim}]],
					Joined->False,
					PassOptions[PlotGating,EmeraldListLinePlot,defaultedOptions]
				]
			],

		_, $Failed
	]
];
