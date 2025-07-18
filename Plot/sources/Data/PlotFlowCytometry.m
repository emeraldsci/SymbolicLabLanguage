(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFlowCytometry*)

DefineOptions[PlotFlowCytometry,
	Options:>{
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"The style that should be used to generate a data display.",
			ResolutionDescription->"Resolves to EmeraldListLinePlot when two channels are specified for Channels, otherwise resolves to EmeraldSmoothHistogram.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[
				EmeraldListLinePlot,
				EmeraldListPointPlot3D,
				EmeraldHistogram,
				EmeraldHistogram3D,
				EmeraldSmoothHistogram,
				EmeraldListContourPlot
			]],
			Category->"Plot Style"
		},
		{
			OptionName ->Channels,
			Default -> Automatic,
			Description -> "Select specific channels for which flow cytometry data will be plotted.",
			ResolutionDescription -> "Automatically set to {488 FSC} for one channel plot types, {488 FSC, 488 SSC} for two channel plot types and {488 FSC, 488 SSC, 488 525/35} for three channel plot types.",
			Category -> "Plot Style",
			AllowNull -> False,
			Widget ->  Adder[Widget[Type -> Expression, Pattern:>FlowCytometryDetectorP,Size -> Word]]
		},
		{
			OptionName ->DataPoints,
			Default -> Area,
			Description ->  "The dimensions of the data that should be plotted.",
			Category -> "Plot Style",
			AllowNull -> False,
			Widget -> Alternatives[
				Adder[Widget[Type -> Expression, Pattern:>Alternatives[Height,Area,Width],Size -> Word]],
				Widget[Type -> Expression, Pattern:>Alternatives[Height,Area,Width],Size -> Word]
			]
		},
		OutputOption,
		ModifyOptions[EmeraldListLinePlot,
			{
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Filling,FillingStyle,InterpolationOrder,ErrorType,ErrorBars,
				SecondYCoordinates,SecondYColors,SecondYUnit,SecondYRange,SecondYStyle,
				Peaks,PeakLabels,PeakLabelStyle
			},
			Category->"Hidden"
		],
		ModifyOptions[EmeraldHistogram,{Legend},Default->None]
	},
	SharedOptions:>{
		ModifyOptions["Shared",EmeraldListLinePlot,
			{
				{
					OptionName->PlotRange,
					Default->All
				},
				{
					OptionName->ImageSize,
					Default->300
				},
				{
					OptionName->Joined,
					Default->False,
					Category->"Hidden"
				}
			}
		],
		EmeraldListLinePlot,
		EmeraldListPointPlot3D,
		EmeraldHistogram,
		EmeraldHistogram3D,
		EmeraldSmoothHistogram,
		EmeraldListContourPlot
	}
];

Error::PlotFlowCytometryIncompatiblePlot="When PlotType is specified as EmeraldListLinePlot, EmeraldHistogram3D or EmeraldListContourPlot, Channels must be specified as a pair. A single PlotChannel can only be specified to create a EmeraldHistogram or EmeraldSmoothHistogram. EmeraldHistogram3D takes 3 Channels. Please leave PlotType uninformed to be resolved automatically.";
Error::PlotFlowCytometryDataPointLength="The length of DataPoints does not match the length of Channels.";
Error::NoFlowCytometryDataToPlot = "The protocol object does not contain any associated flow cytometry data.";
Error::FlowCytometryProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotFlowCytometry or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotFlowCytometry[
	obj: ObjectP[Object[Protocol, FlowCytometry]],
	ops: OptionsPattern[PlotFlowCytometry]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFlowCytometry, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, FlowCytometry]]..}],
		Message[Error::NoFlowCytometryDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotFlowCytometry[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotFlowCytometry[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::FlowCytometryProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

PlotFlowCytometry[
	myData:ListableP[ObjectP[Object[Data,FlowCytometry]]],
	myOps:OptionsPattern[PlotFlowCytometry]
]:=Module[
	{
		originalOps,safeOps,output,plotData,specificOptions,plotOptions,previewPlot,
		plot,mostlyResolvedOps,resolvedOps,wavelengthOptionCheck,exEMLengthCheck,exEMChannelsCheck,
		listedData,allPackets,specifiedExcitationWavelengths,specifiedEmissionWavelengths,excitationsFromData,emissionsFromData,
		compatibleExcitationWavelengths,compatibleEmissionWavelengths,exToEM,emToEX,wavelengthsForLabels,
		specifiedPlotType,resolvedPlotType,chartLabels,plotTypeCheck,histoPlotLabels,
		resolvedExcitationWavelengths,resolvedEmissionWavelengths,allDataFromInputs,exapandedDataPoints,detectorLabels,
		detectors,labelRules,channelRules,resolvedFrameLabel,resolvedChannels,resolvedAxesLabel,resolvedAxes
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFlowCytometry,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(****** Plot Code ******)

	listedData=ToList[myData];

	(* Download call *)
	allPackets=Quiet[
		Download[listedData,
			Packet[
				Detectors,
				DetectionLabels,
				ForwardScatter488Excitation,
				ForwardScatter405Excitation,
				SideScatter488Excitation,
				Fluorescence488Excitation525Emission,
				Fluorescence488Excitation593Emission,
				Fluorescence488Excitation750Emission,
				Fluorescence488Excitation692Emission,
				Fluorescence561Excitation750Emission,
				Fluorescence561Excitation670Emission,
				Fluorescence561Excitation720Emission,
				Fluorescence561Excitation589Emission,
				Fluorescence561Excitation577Emission,
				Fluorescence561Excitation640Emission,
				Fluorescence561Excitation615Emission,
				Fluorescence405Excitation670Emission,
				Fluorescence405Excitation720Emission,
				Fluorescence405Excitation750Emission,
				Fluorescence405Excitation460Emission,
				Fluorescence405Excitation420Emission,
				Fluorescence405Excitation615Emission,
				Fluorescence405Excitation525Emission,
				Fluorescence355Excitation525Emission,
				Fluorescence355Excitation670Emission,
				Fluorescence355Excitation700Emission,
				Fluorescence355Excitation447Emission,
				Fluorescence355Excitation387Emission,
				Fluorescence640Excitation720Emission,
				Fluorescence640Excitation775Emission,
				Fluorescence640Excitation800Emission,
				Fluorescence640Excitation670Emission
			]
		]
	];

	(*- Resolve PlotType -*)
	(* Get specified option *)
	specifiedPlotType=Lookup[safeOps,PlotType];

	resolvedChannels=Which[
		(* Accept any user specified input and error check *)
		MatchQ[Lookup[safeOps,Channels],Except[Automatic]],
		Lookup[safeOps,Channels],
		(* one axis *)
		MatchQ[specifiedPlotType,EmeraldHistogram|EmeraldSmoothHistogram],
		{"488 FSC"},
		(* three axes *)
		MatchQ[specifiedPlotType,EmeraldListPointPlot3D],
		{"488 FSC", "488 SSC", "488 525/35"},
		(* two axes*)
		True,
		{"488 FSC", "488 SSC"}
	];

	(* Resolve option depending on PlotChannel *)
	resolvedPlotType=Which[
		(* Accept any user specified input and error check *)
		MatchQ[specifiedPlotType,Except[Automatic]],
		specifiedPlotType,
		(* one axis *)
		MatchQ[Length[ToList[resolvedChannels]],1],
		EmeraldHistogram,
		(* two axes *)
		MatchQ[Length[ToList[resolvedChannels]],2],
		EmeraldListLinePlot,
		(* three axes or more*)
		MatchQ[Length[ToList[resolvedChannels]],GreaterP[2]],
		EmeraldListPointPlot3D
	];

	(* Error handling for PlotType *)
	plotTypeCheck=Which[
		MatchQ[resolvedPlotType,EmeraldHistogram|EmeraldSmoothHistogram],
		MatchQ[Length[ToList[resolvedChannels]],1],
		MatchQ[resolvedPlotType,EmeraldListLinePlot|EmeraldHistogram3D|EmeraldListContourPlot],
		MatchQ[Length[ToList[resolvedChannels]],2],
		MatchQ[resolvedPlotType,EmeraldListPointPlot3D],
		MatchQ[Length[ToList[resolvedChannels]],3]
	];


	If[!plotTypeCheck,
		Message[Error::PlotFlowCytometryIncompatiblePlot];
		Return[$Failed],
		Nothing
	];

	exapandedDataPoints=If[
		MatchQ[Lookup[safeOps,DataPoints],_List],
		Lookup[safeOps,DataPoints],
		Table[Lookup[safeOps,DataPoints],Length[ToList[resolvedChannels]]]
	];


	If[!MatchQ[Length[exapandedDataPoints],Length[ToList[resolvedChannels]]],
		Message[Error::PlotFlowCytometryDataPointsLength];
		Return[$Failed],
		Nothing
	];

	(*If they labeled the channels then that should show up in the axis labeling, make a list of rules to convert*)
	detectors=Lookup[First[allPackets],Detectors];
	detectorLabels=Lookup[First[allPackets],DetectionLabels];
	labelRules=DeleteCases[MapThread[#1 -> #2 &,{detectors,detectorLabels}],_->Null];

	(*default the label if not specified*)
	resolvedFrameLabel=If[
		MatchQ[Lookup[safeOps,FrameLabel],Automatic],
		Which[
			MatchQ[resolvedPlotType,EmeraldHistogram|EmeraldSmoothHistogram],
			{
				(Last[ToList[resolvedChannels]]/.labelRules)<>" "<>ToString[Last[exapandedDataPoints]],
				None},
			MatchQ[resolvedPlotType,EmeraldListLinePlot|EmeraldListContourPlot],
			{
				{(First[ToList[resolvedChannels]]/.labelRules)<>" "<>ToString[First[exapandedDataPoints]],None},
				{(Last[ToList[resolvedChannels]]/.labelRules)<>" "<>ToString[Last[exapandedDataPoints]],None}
			},
			True,
			Lookup[safeOps,FrameLabel]
		],
		Lookup[safeOps,FrameLabel]
	];

	resolvedAxesLabel=If[
		MatchQ[Lookup[safeOps,AxesLabel],Automatic|None],
		Which[
			MatchQ[resolvedPlotType,EmeraldListPointPlot3D],
			{
				(ToList[resolvedChannels][[1]]/.labelRules)<>" "<>ToString[exapandedDataPoints[[1]]],
				(ToList[resolvedChannels][[2]]/.labelRules)<>" "<>ToString[exapandedDataPoints[[2]]],
				(ToList[resolvedChannels][[3]]/.labelRules)<>" "<>ToString[exapandedDataPoints[[3]]]
			},
			MatchQ[resolvedPlotType,EmeraldHistogram3D],
			{
				(ToList[resolvedChannels][[1]]/.labelRules)<>" "<>ToString[exapandedDataPoints[[1]]],
				(ToList[resolvedChannels][[2]]/.labelRules)<>" "<>ToString[exapandedDataPoints[[2]]]
			},
			True,
			Lookup[safeOps,AxesLabel]
		],
		Lookup[safeOps,AxesLabel]
	];

	resolvedAxes=If[
		MatchQ[resolvedAxesLabel,Except[Automatic|None]],
		True,
		Lookup[safeOps,Axes]
	];

	(* Gather specific options *)
	specificOptions=
		{
			PlotType->resolvedPlotType,
			Channels->resolvedChannels,
			DataPoints->Lookup[safeOps,DataPoints],
			FrameLabel->resolvedFrameLabel,
			AxesLabel->resolvedAxesLabel,
			Axes->resolvedAxes
		};

	mostlyResolvedOps=ReplaceRule[safeOps,specificOptions];

	(*-- Resolve the raw numerical data that you will plot --*)

	channelRules={
		"488 FSC" -> ForwardScatter488Excitation,
		"405 FSC"-> ForwardScatter405Excitation,
		"488 SSC"-> SideScatter488Excitation,
		"488 525/35"-> Fluorescence488Excitation525Emission,
		"488 593/52" ->Fluorescence488Excitation593Emission,
		"488 750LP"->Fluorescence488Excitation750Emission,
		"488 692/80"->Fluorescence488Excitation692Emission,
		"561 750LP"->Fluorescence561Excitation750Emission,
		"561 670/30"->Fluorescence561Excitation670Emission,
		"561 720/60"->Fluorescence561Excitation720Emission,
		"561 589/15"->Fluorescence561Excitation589Emission,
		"561 577/15"->Fluorescence561Excitation577Emission,
		"561 640/20"->Fluorescence561Excitation640Emission,
		"561 615/24"->Fluorescence561Excitation615Emission,
		"405 670/30"->Fluorescence405Excitation670Emission,
		"405 720/60" ->Fluorescence405Excitation720Emission,
		"405 750LP"->Fluorescence405Excitation750Emission,
		"405 460/22"->Fluorescence405Excitation460Emission,
		"405 420/10"->Fluorescence405Excitation420Emission,
		"405 615/24"->Fluorescence405Excitation615Emission,
		"405 525/50"->Fluorescence405Excitation525Emission,
		"355 525/50" ->Fluorescence355Excitation525Emission,
		"355 670/30"->Fluorescence355Excitation670Emission,
		"355 700LP"->Fluorescence355Excitation700Emission,
		"355 447/60"->Fluorescence355Excitation447Emission,
		"355 387/11"->Fluorescence355Excitation387Emission,
		"640 720/60"->Fluorescence640Excitation720Emission,
		"640 775/50"->Fluorescence640Excitation775Emission,
		"640 800LP"->Fluorescence640Excitation800Emission,
		"640 670/30"->Fluorescence640Excitation670Emission
	};

	(* From each data set, isolate the selected channels *)
	plotData=Map[
		Function[{singleInputData},
			Which[
				MatchQ[resolvedPlotType,EmeraldHistogram|EmeraldSmoothHistogram],
				Lookup[singleInputData,Last[ToList[resolvedChannels]]/.channelRules][[All,exapandedDataPoints[[1]]/.{Height->1,Area->2,Width->3}]],
				MatchQ[resolvedPlotType,EmeraldListLinePlot|EmeraldHistogram3D|EmeraldListContourPlot],
				Transpose[{
					Lookup[singleInputData, First[ToList[resolvedChannels]] /. channelRules][[All,exapandedDataPoints[[1]]/.{Height->1,Area->2,Width->3}]],
					Lookup[singleInputData, Last[ToList[resolvedChannels]] /. channelRules][[All,exapandedDataPoints[[2]]/.{Height->1,Area->2,Width->3}]]
				}],
				True,
				Transpose[{
					Lookup[singleInputData, ToList[resolvedChannels][[1]] /. channelRules][[All,exapandedDataPoints[[1]]/.{Height->1,Area->2,Width->3}]],
					Lookup[singleInputData,ToList[resolvedChannels][[2]] /. channelRules][[All,exapandedDataPoints[[2]]/.{Height->1,Area->2,Width->3}]],
					Lookup[singleInputData, ToList[resolvedChannels][[3]] /. channelRules][[All,exapandedDataPoints[[3]]/.{Height->1,Area->2,Width->3}]]
				}]
			]
		],
		allPackets
	];

	(* Resolve all options which should go to the plot function (i.e. EmeraldListLinePlot in most cases)  *)
	(* Convert the option names back to symbols (they come out of PassOptions as strings) *)
	plotOptions = Map[
		If[MatchQ[Keys[#], _String],
			Symbol[Keys[#]] -> Values[#],
			#
		]&,
		{
			PassOptions[
				PlotFlowCytometry,
				Lookup[mostlyResolvedOps,PlotType],
				mostlyResolvedOps
			]
		}
	];

	(*-- Call plot function --*)
	plot=Which[
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldSmoothHistogram],
			(*Since plotData is formatted for DistributionChart, remove a level of nestedness to get the data in a list of lists format*)
			EmeraldSmoothHistogram[Flatten[plotData,1], Sequence @@ ReplaceRule[plotOptions, Output -> Result]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListLinePlot],
			EmeraldListLinePlot[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Result]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListPointPlot3D],
			EmeraldListPointPlot3D[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Result]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldHistogram],
			EmeraldHistogram[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Result]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldHistogram3D],
			EmeraldHistogram3D[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Result]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListContourPlot],
			EmeraldListContourPlot[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Result]]
	];

	(* Combine options resolved by MM function *)
	resolvedOps=Which[
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldSmoothHistogram],
		(*Since plotData is formatted for DistributionChart, remove a level of nestedness to get the data in a list of lists format*)
			EmeraldSmoothHistogram[Flatten[plotData,1], Sequence @@ ReplaceRule[plotOptions, Output -> Options]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListLinePlot],
			EmeraldListLinePlot[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Options]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListPointPlot3D],
			EmeraldListPointPlot3D[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Options]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldHistogram],
			EmeraldHistogram[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Options]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldHistogram3D],
			EmeraldHistogram3D[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Options]],
		MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldListContourPlot],
			EmeraldListContourPlot[plotData, Sequence @@ ReplaceRule[plotOptions, Output -> Options]]
	];


	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->ReplaceRule[resolvedOps,specificOptions],
		Preview->SlideView[Flatten[{plot}],ImageSize->Full],
		Tests->{}
	}
]

(*
DefineOptions[PlotFlowCytometry,
	Options :> {
		{DataSet -> Automatic, Automatic | SideScatter | ForwardScatter  | FlowCytometryFluorescenceChannelP | {Repeated[Automatic | SideScatter | ForwardScatter  | FlowCytometryFluorescenceChannelP, 3]}, "The dimensions of the data that should be plotted."},
		{DataPoint -> Automatic, Automatic | Height | Area | Width, "The dimensions of the data that should be plotted."},
		{PlotType -> Automatic, Automatic | Histogram | SmoothHistogram | ScatterPlot | ContourPlot, "If Automatic, this will plot a Histogram."},
		{TargetUnits -> Automatic, _List | Automatic, "List of Units to use for the ploted x and y axes."},
		{Map -> False, True | False, "If set to false, will overlay a list of curves on the same plot, if set to true will provide a list of plots for each curve."},
		{Legend -> None, {String..} | Null | None, "List of text descriptions of each data set in the plot."},
		{BinSpec -> 50, _Integer | {_Integer} | Automatic | _String | {_, _, _}, "Bin specification for histogram. Default is 50 bins."},
		{FrameLabel -> Automatic, Automatic | {Automatic | _String, Automatic | _String}, "The labels for the plot frames."},
		{PlotRange -> Automatic, Automatic, "Range of data points to be ploted.", Category->Hidden},
		{PlotLabel -> None, Null, "Label of the plot.", Category->Hidden},
		{LabelStyle -> {Bold, 14, FontFamily -> "Arial"}, _, "Style of the plot label.", Category->Hidden},
		{ImageSize -> 600, Automatic | GreaterP[1], "Size of the plot.", Category->Hidden},
		{PlotStyle -> {PointSize[Small]}, _, "Style to be applied to the plot.", Category->Hidden},
		{Joined -> False, BooleanP, "Join the points into a line.", Category->Hidden},
		{Zoomable->True, BooleanP, "Plot is zoomable.", Category->Hidden}
	}
];


PlotFlowCytometry[flowObj:ListableP[objectOrLinkP[Object[Data,FlowCytometry]]],ops:OptionsPattern[]]:=
	PlotFlowCytometry[Download[flowObj],ops];


PlotFlowCytometry[flowPacket: packetOrInfoP[Object[Data,FlowCytometry]], ops: OptionsPattern[]] := If[
	And[
		MatchQ[Length[{ops}], 0],
		!MatchQ[Lookup[flowPacket, GatingAnalyses], {Null}|{}]
	],
	PlotGating[Last[Lookup[flowPacket, GatingAnalyses]]],
	PlotFlowCytometry[{flowPacket}, ops]
];


PlotFlowCytometry[flowPackets:{packetOrInfoP[Object[Data,FlowCytometry]]..},ops:OptionsPattern[]]:=Module[
	{safeOps,resolvedOps,dataArg,plotType,plotFunc,fields},
	safeOps = SafeOptions[PlotFlowCytometry,Flatten[ToList[ops,Joined->False]]];
	(* get data fields *)
	fields = resolveFlowCytometryDataSet[toOldDSOption[Lookup[safeOps, DataSet], Lookup[safeOps, DataPoint]]];
	(* figure out plot type based on fields *)
	plotType = resolvePlotFlowCytometryPlotType[fields,PlotType/.safeOps];
	(* reformat data arg based on plot type and fields *)
	dataArg = resolvePlotFlowCytometryData[flowPackets,plotType,fields,safeOps];
	(* lookup plotting function based on plot type & # of fields *)
	plotFunc = {plotType,fields}/.plotTypeToPlotFunctionRules;
	(* resolve a few more options, like labels *)
	resolvedOps = resolvePlotFlowOptions[plotFunc,plotType,fields,safeOps];
	(* call megaplot function *)
	plotFunc[dataArg,PassOptions[PlotFlowCytometry,plotFunc,resolvedOps]]
];



toOldDSOption[ds: FlowCytometryFluorescenceChannelP, dp: Height | Area | Width] := {ds, dp};
toOldDSOption[ds: SideScatter | ForwardScatter, dp: Height | Area | Width] := ToExpression[ToString[ds] <> ToString[dp]];
toOldDSOption[ds_List, dp_] := Map[toOldDSOption[#, dp] &, ds];
toOldDSOption[ds_, dp: Automatic] := toOldDSOption[ds, Height];
toOldDSOption[ds_, dp_] := Automatic;


resolvePlotFlowCytometryData[flowPackets_,plotType_,fields_,safeOps_List]:=Module[{units,vals},
	units = Map[lookupFlowFieldUnits,fields][[;;,2]];
	vals =Function[{packet},Map[
		lookupFlowFieldValue[#,packet]&,
		fields]
	]/@flowPackets;
	resolvePlotFlowCytometryDataArg[vals,plotType,units,Length[flowPackets],safeOps]
];

lookupFlowFieldUnits[field_Symbol]:=Lookup[LegacySLL`Private`typeUnits[Object[Data,FlowCytometry]],field];
lookupFlowFieldUnits[{_,Height}]:=Lookup[LegacySLL`Private`typeUnits[Object[Data,FlowCytometry]],FluorescenceHeight];
lookupFlowFieldUnits[{_,Area}]:=Lookup[LegacySLL`Private`typeUnits[Object[Data,FlowCytometry]],FluorescenceArea];

lookupFlowFieldValue[field_Symbol,packet_]:=Module[{},
	QuantityMagnitude[Lookup[packet,field]]
];
lookupFlowFieldValue[{fl_,pr:(Height|Area)},packet_]:=QuantityMagnitude[(pr/.getCorrectFluorescencePacket[Lookup[packet,Fluorescence],fl])];

getCorrectFluorescencePacket[flSubpacket_,fl_]:=First[Select[flSubpacket,MatchQ[ChannelName/.#,fl]&]];

resolveFlowCytometryDataSet[Automatic]:={ForwardScatterHeight};
resolveFlowCytometryDataSet[s_Symbol]:={s};
resolveFlowCytometryDataSet[f:{FlowCytometryFluorescenceChannelP,Height|Area}]:={f};
resolveFlowCytometryDataSet[list_List]:=list;

resolvePlotFlowCytometryPlotType[fields_,Automatic]:=Which[
	Length[fields]===1, Histogram,
	Length[fields]===2, ScatterPlot,
	Length[fields]===3, ScatterPlot
];
resolvePlotFlowCytometryPlotType[fields_,plotType_]:=plotType

maxFluorescenceReading = 66000;
defaultBinCount=50;
flowBinSpec[dataArg_,binCount:Automatic]:=Automatic;
flowBinSpec[dataArg_,binCount_]:=binCount;


resolvePlotFlowCytometryDataArg[dataArg_,plotType_,units_,n_Integer,safeOps_List]:=Module[{out},
	out=Map[resolvePlotFlowCytometryOneDataArg[#,plotType,units,safeOps]&,dataArg];
	If[MatchQ[n,1],
		First[out],
		out
	]
];
resolvePlotFlowCytometryOneDataArg[dataArg:{CoordinatesP,CoordinatesP},ScatterPlot|Histogram|SmoothHistogram,units_,safeOps_List]:=
    QuantityArray[Transpose[dataArg[[;;,;;,2]]],units];
resolvePlotFlowCytometryOneDataArg[dataArg:{CoordinatesP,CoordinatesP,CoordinatesP},ScatterPlot,units_,safeOps_List]:=
    QuantityArray[Transpose[dataArg[[;;,;;,2]]],units];
resolvePlotFlowCytometryOneDataArg[dataArg:{CoordinatesP,CoordinatesP},ContourPlot|DensityPlot,units_,safeOps_List]:=Module[{binCount,bins},
	binCount = Replace[BinSpec/.safeOps,Except[_Integer]->defaultBinCount];
	bins = Subdivide[0,maxFluorescenceReading,binCount];
	Transpose[BinCounts[Transpose[dataArg[[;;,;;,2]]], {bins}, {bins}]]
];
resolvePlotFlowCytometryOneDataArg[dataArg:{CoordinatesP},Histogram|SmoothHistogram|_,{unit_},safeOps_List]:=QuantityArray[dataArg[[1,;;,2]],unit];

plotTypeToPlotFunctionRules = {
	{Histogram,{_}} -> EmeraldHistogram,
	{Histogram,{_,_}} -> EmeraldHistogram3D,
	{SmoothHistogram,{_}} -> EmeraldSmoothHistogram,
	{SmoothHistogram,{_,_}} -> EmeraldSmoothHistogram3D,
	{ScatterPlot,{_,_}} -> EmeraldListLinePlot,
	{ScatterPlot,{_,_,_}} -> EmeraldListPointPlot3D,
	{ContourPlot,{_,_}} -> EmeraldListContourPlot
};


resolvePlotFlowOptions[plotFunc_,plotType_,fields_,safeOps_List]:=Module[{labelRule},
	labelRule = resolvePlotFlowLabelRule[plotFunc,fields,safeOps];
	Join[
		{
			labelRule
		},
		safeOps
	]
];

resolvePlotFlowLabelRule[plotFunc_,fields_List,safeOps_List]:=With[
	{optionName = labelOptionName[plotFunc],n=labelListLength[plotFunc]},
	(* some plots use FrameLabel, and some use AxesLabel. PlotFlowCytometry uses FrameLabel for everything, so sometimes need to covnert that to AxesLabel *)
	optionName->Replace[Lookup[safeOps,FrameLabel],Automatic->PadRight[Map[ToString,fields],n,Automatic]]
];

labelOptionName[EmeraldListPointPlot3D|EmeraldHistogram3D|EmeraldSmoothHistogram3D]:=AxesLabel;
labelOptionName[_]:=FrameLabel;
labelListLength[EmeraldListPointPlot3D]:=3
labelListLength[_]:=2
*)