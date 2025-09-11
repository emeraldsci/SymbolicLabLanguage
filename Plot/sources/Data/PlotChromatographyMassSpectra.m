(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Patterns *)

(* Custom Patterns *)
plotLCMSTypeP=Alternatives[
	WaterfallPlot,
	MassSpectrum,
	AbsorbanceChromatogram,
	ExtractedIonChromatogram,
	TotalIonCurrent,
	BasePeakChromatogram
];



(* ::Subsection:: *)
(* Options *)
DefineOptions[PlotChromatographyMassSpectra,
	Options :> {
		{
			OptionName -> DownsampledData,
			Default -> Automatic,
			Description -> "Specify the downsampling analysis object from which downsampled LCMS data for the input should be downloaded.",
			ResolutionDescription -> "Automatic defaults to the most recent entry in the DownsamplingAnalyses field of the input object.",
			AllowNull -> False,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Downsampling]]],
				Widget[Type->Enumeration, Pattern:>Alternatives[None]]
			],
			Category -> "LCMS Data"
		},
		{
			OptionName -> PlotType,
			Default -> WaterfallPlot,
			Description -> "Specify which type of plot to generate. Default is a waterfall plot showing the evolution of the mass spectra over time.",
			AllowNull -> False,
			Widget->Widget[Type->Enumeration,
				Pattern:>Alternatives[
					WaterfallPlot,
					MassSpectrum,
					AbsorbanceChromatogram,
					ExtractedIonChromatogram,
					TotalIonCurrent,
					BasePeakChromatogram,
					ReactionMonitoringMassChromatogram,
					IonMonitoringMassChromatogram
				]
			],
			Category -> "LCMS Data"
		},
		{
			OptionName -> NumberOfWaterfallSlices,
			Default -> Automatic,
			Description -> "Specify the number of 2D mass spectra plots in include in the waterfall plot.",
			ResolutionDescription -> "Automatic resolves to 7 if PlotType is WaterfallPlot, and Null otherwise.",
			AllowNull->True,
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0,1]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> WaterfallReductionFunction,
			Default -> Automatic,
			Description -> "The function used to slice 3D data into 2D plots for the waterfall plot. Use None to slice single time points without further reduction.",
			ResolutionDescription -> "Automatic resolves to Mean if PlotType is WaterfallPlot, and Null otherwise.",
			AllowNull -> True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Mean,Total,Max,None]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> WaterfallReferencePlot,
			Default -> Automatic,
			Description -> "The two-dimensional plot to show on the side of the waterfall plot, on the signal vs. time plane.",
			ResolutionDescription -> "Automatic resolves to Absorbance if PlotType is WatefallPlot, and Null otherwiser.",
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[AbsorbanceChromatogram,TotalIonCurrent,BasePeakChromatogram,None]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> MassSpectrumTimeRange,
			Default -> Automatic,
			Description -> "The range of collection times from which a single mass spectrum should be sliced. Set the minimum and maximum to the same value to slice a single time point.",
			ResolutionDescription -> "Automatic resolves to the full time range if PlotType is MassSpectrum, and Null otherwise.",
			AllowNull -> True,
			Widget->Adder[Span[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Minute],Units->Alternatives[Minute,Second]],
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Minute],Units->Alternatives[Minute,Second]]
			]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> MassSpectrumReductionFunction,
			Default -> Automatic,
			Description -> "The function used to reduce data points with the same m/z value in the MassSpectrumTimeRange.",
			ResolutionDescription -> "Automatic resolves to Mean if PlotType is MassSpectrum, and Null otherwise.",
			AllowNull -> True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Mean,Total,Min,Max]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> ExtractedIonMassRange,
			Default -> Automatic,
			Description -> "The range of m/z values from which the ExtractedIonChromatogram should be sliced.",
			ResolutionDescription -> "Automatic resolves to the full range of recorded m/z if PlotType is ExtractedIonChromatogram, and Null otherwise.",
			AllowNull -> True,
			Widget->Adder[Span[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Dalton],Units->Alternatives[Dalton]],
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Dalton],Units->Alternatives[Dalton]]
			]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> ExtractedIonReductionFunction,
			Default -> Automatic,
			Description -> "The function used to reduce data points at the same collection time in the ExtractedIonMassRange.",
			ResolutionDescription -> "Automatic resolves to Mean if PlotType is ExtractedIonChromatogram, and Null otherwise.",
			AllowNull -> True,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Mean,Total,Min,Max]],
			Category -> "LCMS Data"
		},
		{
			OptionName -> ShowNoiseThreshold,
			Default -> Automatic,
			Description -> "Specify whether to graphically show the noise threshold used in data downsampling.",
			ResolutionDescription -> "Automatic resolves to False if PlotType is two dimensional, and Null otherwise.",
			AllowNull -> True,
			Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
			Category -> "LCMS Data"
		},
		{
			OptionName->ExcludeRange,
			Default->None,
			Description->"Specify a span of m/z values to exclude from the plot, for example to hide the signal from a solvent.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Span[
					Widget[Type->Quantity,Pattern:>RangeP[0*Dalton,\[Infinity]*Dalton],Units->Dalton],
					Widget[Type->Quantity,Pattern:>RangeP[0*Dalton,\[Infinity]*Dalton],Units->Dalton]
				]],
				Widget[Type->Enumeration,Pattern:>Alternatives[None]]
			],
			Category -> "Plot Range"
		},

		(* just in case user calls Map->True *)
		ModifyOptions[MapOption,Category->"Plot"],

		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				PlotRangeClipping,ClippingStyle,ScaleX,ScaleY,LegendLabel,LabelingFunction,
				ErrorBars,ErrorType,Reflected,Scale,Joined,InterpolationOrder,FrameUnits,TargetUnits,
				PeakLabels,PeakLabelStyle,FractionColor,FractionHighlightColor,Tooltip,VerticalLine,
				Fractions,FractionHighlights,Ladder,ColorFunction,ColorFunctionScaling,PlotMarkers
			},
			AllowNull->True,
			Category->"Hidden"
		],
		OutputOption,
		CacheOption
	},
	SharedOptions:>{
		(* Common shared option to all plot types *)
		ModifyOptions["Shared",EmeraldListLinePlot,
			{AspectRatio},
			AllowNull->True
		],
		(* Common shared option to all plot types *)
		ModifyOptions["Shared",EmeraldListLinePlot,
			{
				ImageSize,PlotRange,PlotLabel,PlotStyle,
				Background,Filling,FillingStyle
			}
		],
		(* ELLP specific options *)
		ModifyOptions["Shared",EmeraldListLinePlot,
			{
				Zoomable,FrameLabel,Legend,LegendPlacement,Boxes,
				Background,PlotStyle,Peaks,Frame,FrameStyle,FrameTicks,FrameTicksStyle,
				GridLines,GridLinesStyle
			},
			AllowNull->True
		],
		(* Waterfall only options *)
		ModifyOptions["Shared",PlotWaterfall,
			{AxesLabel,ContourLabelPositions,ContourLabelStyle},
			AllowNull->True,
			Category->"Plot Labeling"
		],
		ModifyOptions["Shared",PlotWaterfall,
			{Boxed,BoxStyle},
			AllowNull->True
		],
		ModifyOptions["Shared",PlotWaterfall,
			{WaterfallProjection,ViewPoint,ViewAngle},
			AllowNull->True,
			Category->"3D View"
		],
		(* Common shared option to all plot types *)
		ModifyOptions["Shared",EmeraldListLinePlot,
			{LabelStyle,RotateLabel,Prolog,Epilog}
		]
	}
];




(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)
Error::DataFormat="The DownsampledDataFile in linked downsampling object `1` did not resolve to a SparseArray. Please re-run AnalyzeDownsampling on input object `2`.";
Error::DownsampledDataNotFound="Input object `1` has no linked downsampled data in field DownsamplingAnalyses. Please run AnalyzeDownsampling on `1`, or if that is not possible, set DownsampledData to None to plot unprocessed data.";
Warning::DownsampledDataNotPartOfDataObject="Input analysis object `1` for the DownsampledData option is not linked to `2` in the DownsamplingAnalyses field. Please select DownsampledData that is linked to `2`. Because of this, instead of `1`, the most recent downsampling object is used.";
Error::DownsampledDataNotReady="Input object `2` was created recently and data is still being downsampled by the ECL. Please check back at `1`, or run AnalyzeDownsampling on input object `2` locally. Plotting cannot continue until data has been downsampled.";
Error::InvalidDataDimensions="The dimensions of the downsampled data array `1` are incompatible with the dimensions of its sampling points `2`. Please verify that the input data object was downsampled correctly, and re-analyze the data with AnalyzeDownsampling if it was not.";
Error::MissingLCTrace="No Absorbance Chromatogram could be found in the input data object. Please verify that the field \"Absorbance\" in the input object is not empty and contains a list of {x,y} data points.";
Warning::WaterfallSidePlotMissing="The requested waterfall reference plot `1` could not be resolved from the input data. The waterfall plot will be generated with no reference.";
Error::ReactionMonitoringDataNotFound="Input object `1` has no Reaction Monitoring Mass Chromatogram data. Please verify that the input data object is correct.";
Error::IonMonitoringDataNotFound="Input object `1` has no Ion Monitoring Mass Chromatogram data. Please verify that the input data object is correct.";
Error::InconsistentAcquisitionModes="Input objects `1` have inconsistent data acquisition modes. Please verify input data objects are correct.";
Error::AmbiguousData = "Input objects `1` have multiple data acquisition modes. Consequently the plot cannot be automatically generated based on input data alone. Please verify input data objects are correct and specify plot type.";
Error::NoChromatographyMassSpectraDataToPlot = "The protocol object does not contain any associated chromatography mass spectrometry data.";
Error::ChromatographyMassSpectraProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotChromatographyMassSpectra or PlotObject on an individual data object to identify the missing values.";

(* ::Subsection::Closed:: *)
(*Overloads*)

(* original listable overload *)
plotChromatographyMassSpectra[
	dataObjects:{ObjectP[Object[Data,ChromatographyMassSpectra]]..},
	myOps:OptionsPattern[PlotChromatographyMassSpectra]
]:=Module[
	{
		outputSpecification,suppliedCache,output,listedOptions,listedInputs,
		dataPackets,newCacheplotResults,groupedOutputRules
	},

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Cache, if it was provided *)
	suppliedCache=Lookup[listedOptions,Cache,{}];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Download all data which may be used by the function and cache it *)
	dataPackets=Quiet@Download[dataObjects,
		{
			Packet[Absorbance,AbsorbanceWavelength],
			Packet[DownsamplingAnalyses[[-1]][{Object,DataUnits,SamplingGridPoints,NoiseThreshold,DownsampledDataFile}]],
			Packet[AbsorbancePeaksAnalyses[[-1]][All]]
		},
		Cache->suppliedCache
	]/.{$Failed->Null};

	(* Append new downloads to the existing cache *)
	newCache=Join[suppliedCache,Flatten[dataPackets]];

	(* Map AnalyzeDNASequencing across the lists of packets *)
	plotResults=Map[
		plotChromatographyMassSpectra[#,
			(* Need to use the listed form of output for combined option rules below (e.g. {Result} instead of Result) *)
			ReplaceRule[listedOptions,{Output->output,Cache->newCache}]
		]&,
		dataObjects
	];

	(* Since the AnalyzeDownsampling call was mapped on lists of data, we must consolidate the options, preview, and tests for builder *)
	groupedOutputRules=MapIndexed[
		Function[{requestedOutput,idx},
			requestedOutput->Switch[requestedOutput,
				(* Extract just the results from each function call *)
				Result,If[Length[dataObjects]==1,
					First[Part[#,First[idx]]&/@plotResults],
					(Part[#,First[idx]]&/@plotResults)
				],
				(* AnalyzeDNASequencing resolves the same options for each function call, so we can just take the first one *)
				Options,First[Part[#,First[idx]]&/@plotResults],
				(* Incorporate all previews into a single slide view *)
				Preview,If[Length[dataObjects]==1,
					First[Part[#,First[idx]]&/@plotResults],
					SlideView[Part[#,First[idx]]&/@plotResults]
				],
				(* There are no tests for plot functions *)
				Tests,{}
			]
		],
		output
	];

	(* Return the requested output *)
	outputSpecification/.groupedOutputRules
];

(* Protocol Overload *)
PlotChromatographyMassSpectra[
	obj: Alternatives[ObjectP[Object[Protocol, LCMS]], ObjectP[Object[Protocol, SupercriticalFluidChromatography]]],
	ops: OptionsPattern[PlotChromatographyMassSpectra]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotChromatographyMassSpectra, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, ChromatographyMassSpectra]]..}],
		Message[Error::NoChromatographyMassSpectraDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotChromatographyMassSpectra[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotChromatographyMassSpectra[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::ChromatographyMassSpectraProtocolDataNotPlotted];
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

(* ---------------------------- *)
(* --- NEW PRIMARY OVERLOAD --- *)
(* ---------------------------- *)
(* the new primary overload to handle ReactionMonitoringMassChromatogram *)
PlotChromatographyMassSpectra[
	dataObjects:ObjectP[Object[Data,ChromatographyMassSpectra]]|{ObjectP[Object[Data,ChromatographyMassSpectra]]..},
	myOps:OptionsPattern[PlotChromatographyMassSpectra]
]:=Module[{originalOps, output, plotType, singletonQ, dataPackets, acquisitionMode, resolvedAcquisitionMode},

	(* identify singleton input or list of input *)
	singletonQ=Not[ListQ[dataObjects]];

	(* convert original options into a list *)
	originalOps=ToList[myOps];

	(* check plot type *)
	plotType = Lookup[originalOps,PlotType];

	(* get experiment acquisition mode *)
	acquisitionMode=Download[dataObjects,AcquisitionModes];

	(* call a helper to identify acquisition mode *)
	resolvedAcquisitionMode=If[(!MatchQ[acquisitionMode,{}|{{}..}])&&(MatchQ[acquisitionMode,{{___},{___}}]),
		checkInconsistentAcquisitionModes[acquisitionMode,plotType],
		If[Length[acquisitionMode]==1,acquisitionMode[[1]],acquisitionMode]
	];

	(* if MRM data acquisition mode is mixed with other modes, throw an error and return $Failed *)
	If[MatchQ[resolvedAcquisitionMode,"InconsistentModes"|"AmbiguousData"],
		(* Determine the requested function return value *)
		output=OptionValue[Output];
		Switch[resolvedAcquisitionMode,
			"InconsistentModes",Message[Error::InconsistentAcquisitionModes,dataObjects],
			"AmbiguousData",Message[Error::AmbiguousData,dataObjects]
		];
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* call the correct plot function based on plot type or data acquisition mode *)
	Which[
		(* ReactionMonitoringMassChromatogram *)
		MatchQ[plotType,ReactionMonitoringMassChromatogram]||MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring],
		(* a single download to get all data packets *)
		dataPackets=Download[dataObjects,Packet[ReactionMonitoringMassChromatogram]];
		(* pass valid data packet to MRM plot function, singleton case needs to be wrapped in {} *)
		Which[
			singletonQ, plotReactionMonitoringMassChromatogram[{dataPackets}, myOps],
			Not[singletonQ], plotReactionMonitoringMassChromatogram[dataPackets, myOps]
		],

		(* IonMonitoringMassChromatogram *)
		MatchQ[plotType,IonMonitoringMassChromatogram]||MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring],
		(* a single download to get all data packets *)
		dataPackets=Download[dataObjects,Packet[IonMonitoringMassChromatogram]];

		(* pass valid data packet to MRM plot function, singleton case needs to be wrapped in {} *)
		Which[
			singletonQ, plotIonMonitoringMassChromatogram[{dataPackets}, myOps],
			Not[singletonQ], plotIonMonitoringMassChromatogram[dataPackets, myOps]
		],

		(* Else *)
		True,
		(* not MRM data, call original Chromatography mass spectra plot ==== *)
		plotChromatographyMassSpectra[dataObjects, myOps]
	]
];

(* helper to check acquisition modes *)
checkInconsistentAcquisitionModes[modes_, plotTypeOption_] := Module[
	{consistentModes},

	consistentModes = Fold[Intersection, First[modes], Rest[modes]];

	Which[
		consistentModes === {},
		Return["InconsistentModes"],

		Length[consistentModes] > 1,
		If[plotTypeOption === ReactionMonitoringMassChromatogram && MemberQ[consistentModes, MultipleReactionMonitoring],
			MultipleReactionMonitoring,
			Return["AmbiguousData"]
		],
		True,
		If[Length[consistentModes]>=1,consistentModes[[1]],consistentModes]
	]
];

(* ::Subsection::Closed:: *)
(*Primary Function*)

(* --------------------------------- *)
(* --- ORIGINAL PRIMARY OVERLOAD --- *)
(* --------------------------------- *)
plotChromatographyMassSpectra[
	dataObject:ObjectP[Object[Data,ChromatographyMassSpectra]],
	myOps:OptionsPattern[PlotChromatographyMassSpectra]
]:=Module[
	{
		originalOps,suppliedCache,safeOps,output,lcTrace,lcWavelength,lcPeaks,
		downsamplePacket,downsampleObject, allDownSamplingAnalyses,useDefaultDownsampledDataQ, downsampledDataObj,downsampledData,
		peakPacket,peakOps,
		expandedDownsamplePacket,plotData,partlyResolvedOps,plotFunc,plotOptions,plot,
		finalPlot,mostlyResolvedOps,resolvedOps,nullOps,filteredMostlyResolvedOps
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Peak packet(s) provided to the peaks option *)
	peakPacket=Analysis`Private`stripAppendReplaceKeyHeads@FirstOrDefault[
		ToList@Download[Lookup[originalOps,Peaks,{}]]
	];

	(* Inherit options from the peaks, replacing Automatics  *)
	peakOps=If[MatchQ[peakPacket,PacketP[Object[Analysis,Peaks]]],
		Switch[Round[Lookup[peakPacket,ReferenceDataSliceDimension]],
			(* Dimension 1 is slicing on elution time, producing a mass spectrum *)
			1|{1},
				{
					PlotType->MassSpectrum,
					MassSpectrumTimeRange->{Span@@FirstOrDefault[Lookup[peakPacket,ReferenceDataSlice,Null]]},
					MassSpectrumReductionFunction->FirstOrDefault[Lookup[peakPacket,SliceReductionFunction,Null]]
				},
			(* Dimension 2 is slicing on m/z, producing an EIC *)
			2|{2},
				{
					PlotType->ExtractedIonChromatogram,
					ExtractedIonMassRange->{Span@@FirstOrDefault[Lookup[peakPacket,ReferenceDataSlice,Null]]},
					ExtractedIonReductionFunction->FirstOrDefault[Lookup[peakPacket,SliceReductionFunction,Null]]
				},
			_,{}
		],
		{}
	];

	(* Cache, if it was provided *)
	suppliedCache=Lookup[originalOps,Cache,{}];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotChromatographyMassSpectra,ReplaceRule[peakOps,originalOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* The requested downsampling analysis of the input object to plot. Automatic will plot the most recent *)
	downsampleObject=Lookup[safeOps,DownsampledData];

	(*Get all the DownsamplingAnalyses objects to check if the specified objects in the DownsampledData option are part of the given data object*)
	allDownSamplingAnalyses = Download[dataObject,DownsamplingAnalyses];

	(*Compare the input DownsampledData with those of the data object*)
	(*The default downsampled data should be used if DownsampledData is Automatic|None or if the specified object in for the option is not linked to the data i.e. it belongs to a different data object.*)
	useDefaultDownsampledDataQ = If[MatchQ[downsampleObject,Automatic|None],
		True,
		(*If downsampleObject does match the linked analyses, useDefaultDownsampledDataQ should be False as we don't want to go to the default*)
		If[MatchQ[downsampleObject,ObjectP[allDownSamplingAnalyses]],
			False,
			Message[Warning::DownsampledDataNotPartOfDataObject,downsampleObject,dataObject];
			True
		]
		];

	(* Download necessary fields from the downsampling packet *)
	{lcTrace,lcWavelength,lcPeaks,downsamplePacket}=If[useDefaultDownsampledDataQ,
		(* Most recent downsampling analysis *)
		Quiet@Download[dataObject,
			{
				Absorbance,
				AbsorbanceWavelength,
				Packet[AbsorbancePeaksAnalyses[[-1]][All]],
				Packet[DownsamplingAnalyses[[-1]][
					{Object,DataUnits,SamplingGridPoints,NoiseThreshold,DownsampledDataFile}
				]]
			},
			Cache->suppliedCache
		],
		(* A user-specified downsampling analysis *)
		Flatten[
			Quiet@Download[{dataObject,downsampleObject},
				{
					{Absorbance,AbsorbanceWavelength,Packet[AbsorbancePeaksAnalyses[[-1]][All]]},
					{Packet[Object,DataUnits,SamplingGridPoints,NoiseThreshold,DownsampledDataFile]}
				},
				Cache->suppliedCache
			],
			1
		]
	];

	(* Return early fail state if the data can't be resolved *)
	If[(MatchQ[downsamplePacket,$Failed]||MemberQ[Values[downsamplePacket],$Failed])&&!MatchQ[Lookup[safeOps, DownsampledData], None],
		If[(Now-dataObject[DateCreated])<(12 Hour),
			(* Object was created recently *)
			Message[Error::DownsampledDataNotReady,DateString[dataObject[DateCreated]+(12 Hour)],dataObject],
			(* Object was not created recently *)
			Message[Error::DownsampledDataNotFound,dataObject]
		];
		Message[Error::InvalidInput,dataObject[Object]];
		(* Fail state where no options could be resolved *)
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* Main pathway - use downsampling data. Bypass if DownsampledData option is set to None *)
	If[!MatchQ[Lookup[safeOps, DownsampledData], None],
		(* Get the object reference of the cloud file in which the downsampled data is stored *)
		downsampledDataObj=Lookup[downsamplePacket,DownsampledDataFile];

		(* Import the downsampled data .MX file into a sparse array, memoizing for performance. *)
		downsampledData=ImportCloudFile[downsampledDataObj];

		(* If the field did not resolve to a sparse array, return an early fail state *)
		If[!MatchQ[downsampledData,_SparseArray],
			Message[Error::DataFormat,downsamplePacket[Object],dataObject[Object]];
			Message[Error::InvalidInput,dataObject[Object]];
			(* Fail state where no options could be resolved *)
			Return[output/.{
				Result->$Failed,
				Options->$Failed,
				Preview->Null,
				Tests->{}
			}]
		];,

		(* If we are not downsampling, then just download the raw data *)
		downsampledData=Download[dataObject, IonAbundance3D];
	];

	(* With $FastDownload, Download no longer expands the packet to include Key->$Failed if the parent type is missing
	 (it just returns a blanket $Failed instead). If this happen, expand it back out to preserve the expected behavior*)
	expandedDownsamplePacket=If[MatchQ[downsamplePacket,$Failed],
		<|
			Object -> $Failed,
			Type -> $Failed,
			ID -> $Failed,
			DataUnits -> $Failed,
			DownsampledDataFile -> $Failed,
			NoiseThreshold -> $Failed,
			SamplingGridPoints -> $Failed
		|>,
		downsamplePacket
	];

	(* Resolve the input by slicing it according to the option specifications and plot type, slicing as needed *)
	{plotData,partlyResolvedOps}=resolveLCMSData[downsampledData,expandedDownsamplePacket,lcTrace,originalOps,safeOps];

	(* Early return if input data couldn't be resolved*)
	If[MatchQ[plotData,$Failed],
		Message[Error::InvalidInput,dataObject];
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* Resolve specific plot formatting options for each plot type specification  *)
	{plotFunc,plotOptions}=resolveSpecificPlotOptions[
		plotData,
		expandedDownsamplePacket,
		{lcPeaks,lcWavelength},
		originalOps,
		ReplaceRule[safeOps,partlyResolvedOps]
	];

	(* Results of calling the plot function *)
	{plot,mostlyResolvedOps}=plotFunc[plotData,
		ReplaceRule[
			ToList[stringOptionsToSymbolOptions@PassOptions[PlotChromatographyMassSpectra,plotFunc,plotOptions]],
			Output->{Result,Options}
		]
	];

	(* Update the legend option manually because ELLP resolves it funny *)
	mostlyResolvedOps=ReplaceRule[mostlyResolvedOps,
		{Legend->Lookup[plotOptions,Legend]}
	];

	(* Options which should be set to Null because they are specific to a plot type not being used *)
	nullOps=Switch[plotFunc,
		EmeraldListLinePlot,
			Join[
				Complement[
					First/@Options[PlotWaterfall],
					First/@Options[EmeraldListLinePlot]
				],
				{AxesLabel}
			],
		PlotWaterfall,
			Join[
				Complement[
					First/@Options[EmeraldListLinePlot],
					First/@Options[PlotWaterfall]
				],
				{AspectRatio,Legend,LegendPlacement}
			],
		_,
			{}
	];

	(* Set options specific to a plot type (PlotWaterfall or EmeraldListLinePlot) to Null *)
	filteredMostlyResolvedOps=ReplaceRule[
		mostlyResolvedOps,
		(#->Null)&/@nullOps
	];

	(* Resolved plot options from the first plot type *)
	resolvedOps=ReplaceRule[
		ToList[stringOptionsToSymbolOptions@PassOptions[plotFunc,PlotChromatographyMassSpectra,filteredMostlyResolvedOps]],
		partlyResolvedOps
	]/.{
		(* Round numeric values so they're neat *)
		x:UnitsP[]:>RoundReals[x,3]
	};

	(* Set the waterfall plot to static and add a side plot, otherwise just return the plot *)
	finalPlot=If[MatchQ[Lookup[plotOptions,PlotType],WaterfallPlot],
		addSidePlot[plot,plotData,downsampledData,downsamplePacket,lcTrace,resolvedOps],
		plot
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		Options->RemoveHiddenOptions[PlotChromatographyMassSpectra,resolvedOps],
		Preview->finalPlot,
		Tests->{}
	}
];


(* overload for ReactionMonitoringMassChromatogram *)
DefineOptions[plotReactionMonitoringMassChromatogram,
	SharedOptions :>
  {
		PlotChromatographyMassSpectra
	}
];

plotReactionMonitoringMassChromatogram[
	dataPackets:PacketP[]|{PacketP[]..},
	myOps:OptionsPattern[plotReactionMonitoringMassChromatogram]
]:=Module[
	{
		data, plotOptions, intensityData, numberOfObjects, numberOfFragments, fragments, dataIsEmpty,
		output, finalPlotOptions, listedOptions, finalPlots, legends, safeOps, resolvedOptions
	},

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	plotOptions=KeyDrop[listedOptions,{PlotType,Output}]//Normal;

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[EmeraldListLinePlot, plotOptions];

	(* Determine the requested function return value *)
	output=OptionValue[Output];

	(* get all MRM data*)
	data = #[[Key[ReactionMonitoringMassChromatogram]]] & /@ dataPackets;

	(* check if data field is empty *)
	dataIsEmpty=If[MatchQ[Flatten[data],{}],True,False];

	(*	 Return early fail state if there is no MRM data  *)
	If[dataIsEmpty,
		Message[Error::ReactionMonitoringDataNotFound,dataPackets[Object]];
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* get the total number of data objects *)
	numberOfObjects=Length[dataPackets];

	(* get total number of fragments monitored for each data object *)
	numberOfFragments = First[Dimensions[#]]&/@data;

	(* get MassSelection-to-FragmentMassSelection labels for each object *)
	(* data is of the format: *)
	(* object1 : {{fragment11, fragment12, {data1}}, {fragment21, fragment22, {data2}} ..} ( for object 1 *)
	(* object2 : {{fragment11, fragment12, {data1}}, {fragment21, fragment22, {data2}} ..} ( for object 2 *)
	(* ...  *)
		fragments = Map[
		Function[{dataNumber}, Array[(data[[1]][[#]][[;;2]][[1]] -> data[[1]][[#]][[;;2]][[2]]) &,
							numberOfFragments[[dataNumber]]]],
		Range[numberOfObjects]
	];

	(* convert fragments into legends. this is necessary because EmeraldListLine plot only takes text string as legends *)
	legends = Table[
		(ToString[Floor[#[[1,1]]]]<>" "<>FromCharacterCode[8594]<>" "<>ToString[Floor[#[[2,1]]]]<>" g/mol")&/@fragments[[i]],
		{i, numberOfObjects}
	];

	(* get intensity data for all MS-MS, mapping over all fragments for each objects *)
	intensityData = Function[{var}, data[[#]][[var, 3]]][Range[numberOfFragments[[#]]]] & /@ Range[numberOfObjects];

	finalPlotOptions=Array[ReplaceRule[safeOps,{Legend->legends[[#]]}]&,numberOfObjects];
	finalPlots=Which[
		MatchQ[numberOfObjects,1], EmeraldListLinePlot[intensityData[[1]],finalPlotOptions[[1]]],
		numberOfObjects>1, Array[EmeraldListLinePlot[intensityData[[#]],finalPlotOptions[[#]]]&,numberOfObjects]
	];

	(* need to add PlotType back to options *)
	resolvedOptions=Join[{PlotType->ToExpression["ReactionMonitoringMassChromatogram"]},finalPlotOptions];

	(* return the requested outputs *)
	output/.{
		Result->finalPlots,
		Options->RemoveHiddenOptions[EmeraldListLinePlot,resolvedOptions],
		Preview->finalPlots,
		Tests->{}
	}
];

(* overload for IonMonitoringMassChromatogram *)
DefineOptions[plotIonMonitoringMassChromatogram,
	SharedOptions :>
			{
				PlotChromatographyMassSpectra
			}
];

plotIonMonitoringMassChromatogram[
	dataPackets:PacketP[]|{PacketP[]..},
	myOps:OptionsPattern[plotIonMonitoringMassChromatogram]
]:=Module[
	{
		data, plotOptions, intensityData, numberOfObjects, numberOfFragments, fragments, dataIsEmpty,
		output, finalPlotOptions, listedOptions, finalPlots, legends, safeOps, resolvedOptions
	},

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	plotOptions=KeyDrop[listedOptions,{PlotType,Output}]//Normal;

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[EmeraldListLinePlot, plotOptions];

	(* Determine the requested function return value *)
	output=OptionValue[Output];

	(* get all MRM data*)
	data = #[[Key[IonMonitoringMassChromatogram]]] & /@ dataPackets;

	(* check if data field is empty *)
	dataIsEmpty=If[MatchQ[Flatten[data],{}],True,False];

	(*	 Return early fail state if there is no MRM data  *)
	If[dataIsEmpty,
		Message[Error::IonMonitoringDataNotFound,dataPackets[Object]];
		Return[output/.{
			Result->$Failed,
			Options->$Failed,
			Preview->Null,
			Tests->{}
		}]
	];

	(* get the total number of data objects *)
	numberOfObjects=Length[dataPackets];

	(* get total number of fragments monitored for each data object *)
	numberOfFragments = First[Dimensions[#]]&/@data;

	(* get MassSelection-to-FragmentMassSelection labels for each object *)
	(* data is of the format: *)
	(* object1 : {{fragment1, {data1...}}( for object 1 *)
	(* object2 : {{fragment2, {data2...}}( for object 2 *)
	(* ...  *)
	fragments = Map[
		Function[{dataNumber}, Array[(data[[1]][[#]][[;;2]][[1]] -> data[[1]][[#]][[;;2]][[2]]) &,
			numberOfFragments[[dataNumber]]]],
		Range[numberOfObjects]
	];

	(* convert fragments into legends. this is necessary because EmeraldListLine plot only takes text string as legends *)
	legends = Table[
		(ToString[Floor[#[[1,1]]]]<>" g/mol")&/@fragments[[i]],
		{i, numberOfObjects}
	];

	(* get intensity data for all MS-MS, mapping over all fragments for each objects *)
	intensityData = data[[#]][[1, 2]] & /@ Range[numberOfObjects];

	finalPlotOptions=ReplaceRule[safeOps,{Legend->legends}];
	finalPlots=EmeraldListLinePlot[intensityData,finalPlotOptions];

	(* need to add PlotType back to options *)
	resolvedOptions=Join[{PlotType->ToExpression["IonMonitoringMassChromatogram"]},finalPlotOptions];

	(* return the requested outputs *)
	output/.{
		Result->finalPlots,
		Options->RemoveHiddenOptions[EmeraldListLinePlot,resolvedOptions],
		Preview->finalPlots,
		Tests->{}
	}
];


(* ::Subsection::Closed:: *)
(*resolveLCMSData*)

(* Given the downsampled data, packet, and defaulted options, slice the downsampled data for plotting *)
resolveLCMSData[
	sparseData_SparseArray,
	downPacket_Association,
	lcTrace_,
	origOps:{(_Rule|_RuleDelayed)...},
	safeOps:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		plotType,gridPts,units,fullRangeTime,fullRangeMass,optionDefaultFunc,
		maxIntensities,maxNonzeroIndex,autoMassMax,slicingOptions,slicedData,excludedData
	},

	(* Get the requested plot type *)
	plotType=Lookup[safeOps,PlotType]/.{Automatic->WaterfallPlot};

	(* Extract grid points and units from downsampling packet *)
	gridPts=Lookup[downPacket,SamplingGridPoints];
	units=Lookup[downPacket,DataUnits];

	(* Full range of data points in the time and mass directions *)
	fullRangeTime=Span@@(Most[gridPts[[1]]]*units[[1]]);
	fullRangeMass=Span@@(Most[gridPts[[2]]]*units[[2]]);

	(* Repeated pattern for defaulting options under a master switch *)
	optionDefaultFunc[op_Symbol,type_,default_]:=If[MatchQ[plotType,type],
		Lookup[safeOps,op]/.{Automatic->default},
		Null
	];

	(* Get the maximum index in m/z for which intensity is greater than zero at at least one time point. *)
	(* If there are at least 10^6 columns and the matrix is sufficiently sparse (< ~300,000 elements), it's faster *)
	(* to work with a purely sparse representation *)
	If[Last@Dimensions[sparseData] > 1000000 || Length[sparseData["NonzeroValues"]] < 300000,
		(* Sparse algorithm *)
		maxNonzeroIndex=Part[
			MaximalBy[
				(* All expllicitly specified elements of the sparse array. Most drops the wildcard element {_,_}->0 *)
				Most@ArrayRules[sparseData],
				(* Select iy from elements of the form Rule[{ix, iy}, intensity] *)
		 		Function[{x}, Last[First[x]]],
				(* Only return the first one found. We're looking for a maximal index in m/z, don't care which time it occurs *)
				1
			],
			1,1,-1
		];,

		(* Largest mass index in nonzero intensity using threaded Map on sparse array *)
		(* This is substantially faster up until there are about 10^6 columns in the array, at which point sparsity helps  *)
		maxIntensities=Max/@Transpose[sparseData];
		maxNonzeroIndex=Length[maxIntensities]-First@FirstPosition[Reverse@maxIntensities,GreaterP[0.0]]+1;
	];

	(* Largest mass in automatic plot range *)
	autoMassMax=gridPts[[2,1]]+((maxNonzeroIndex-1)*gridPts[[2,-1]]);

	(* Resolve options related to data slicing *)
	slicingOptions={
		(* All plot types share these options *)
		DownsampledData->downPacket[Object],
		PlotType->plotType,
		PlotRange->Lookup[safeOps,PlotRange]/.{
			Automatic->Switch[plotType,
				WaterfallPlot,{All,{Automatic,autoMassMax},All},
				MassSpectrum,{{Automatic,autoMassMax},All},
				_,Automatic
			]
		},
		WaterfallReductionFunction->optionDefaultFunc[WaterfallReductionFunction,WaterfallPlot,Mean],
		WaterfallReferencePlot->optionDefaultFunc[WaterfallReferencePlot,WaterfallPlot,
			If[MatchQ[lcTrace,Null|$Failed],None,AbsorbanceChromatogram]
		],
		NumberOfWaterfallSlices->optionDefaultFunc[NumberOfWaterfallSlices,WaterfallPlot,7],
		MassSpectrumTimeRange->optionDefaultFunc[MassSpectrumTimeRange,MassSpectrum,{fullRangeTime}],
		MassSpectrumReductionFunction->optionDefaultFunc[MassSpectrumReductionFunction,MassSpectrum,Mean],
		ExtractedIonMassRange->optionDefaultFunc[ExtractedIonMassRange,ExtractedIonChromatogram,{fullRangeMass}],
		ExtractedIonReductionFunction->optionDefaultFunc[ExtractedIonReductionFunction,ExtractedIonChromatogram,Mean],
		ShowNoiseThreshold->optionDefaultFunc[ShowNoiseThreshold,MassSpectrum,False],
		ExcludeRange->Lookup[safeOps,ExcludeRange,None],
		Zoomable->Lookup[origOps,Zoomable,Automatic]/.{
			Automatic->If[MatchQ[plotType,WaterfallPlot],Null,True]
		}
	};

	(* Exclude m/z values from the input data *)
	excludedData=applyExcludeRange[sparseData,downPacket,Lookup[slicingOptions,ExcludeRange]];

	(* Slice the data according to slice options and plot type *)
	slicedData=sliceLCMSData[plotType,excludedData,downPacket,lcTrace,slicingOptions];

	(* Return the sliced data and sliced options *)
	{slicedData,slicingOptions}
];


(* If the data provided is not sparse, then group the 3D data into a series of 2D plots for waterfall *)
resolveLCMSData[
	rawData:QuantityArrayP[],
	downPacket_Association,
	lcTrace_,
	origOps:{(_Rule|_RuleDelayed)...},
	safeOps:{(_Rule|_RuleDelayed)..}
]:=Module[
	{unitlessRawData, dataUnits, groupedData, optionDefaultFunc, slicingOptions},

	(* Unitless Data *)
	unitlessRawData=RoundReals[Unitless[rawData],8];

	(* Units of the data *)
	dataUnits=Flatten@Units[rawData[[1]]];

	(* Gather spectra by timestamp {time \[Rule] {{m/z, intensity}...}..}  *)
	groupedData=Map[
		{RoundReals[#[[1,1]],3]*dataUnits[[1]], Rest/@#}&,
		GatherBy[unitlessRawData, First]
	];

	(* Repeated pattern for defaulting options under a master switch *)
	optionDefaultFunc[op_Symbol,type_,default_]:=If[MatchQ[plotType,type],
		Lookup[safeOps,op]/.{Automatic->default},
		Null
	];

	(* Resolve options related to data slicing *)
	slicingOptions={
		(* All plot types share these options *)
		DownsampledData->None,
		AxesUnits->dataUnits,
		PlotType->WaterfallPlot,
		PlotRange->Lookup[safeOps,PlotRange],
		WaterfallReductionFunction->optionDefaultFunc[WaterfallReductionFunction,WaterfallPlot,Mean],
		WaterfallReferencePlot->optionDefaultFunc[WaterfallReferencePlot,WaterfallPlot,
			If[MatchQ[lcTrace,Null|$Failed],None,AbsorbanceChromatogram]
		],
		NumberOfWaterfallSlices->optionDefaultFunc[NumberOfWaterfallSlices,WaterfallPlot,7],
		MassSpectrumTimeRange->Null,
		MassSpectrumReductionFunction->Null,
		ExtractedIonMassRange->Null,
		ExtractedIonReductionFunction->Null,
		ShowNoiseThreshold->Null,
		ExcludeRange->Lookup[safeOps,ExcludeRange,None],
		Zoomable->Null
	};

	(* Return the sliced data and sliced options *)
	{groupedData,slicingOptions}
];


(*** LCMS slicing functions ***)

(* Waterfall plot: lots of stuff to do here *)
sliceLCMSData[type:WaterfallPlot,
	data_SparseArray,
	downPacket_Association,
	lcTrace_,
	slicingOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		numWaterfalls,redFunc,plotRange,timeGrid,timePoints,massGrid,massPoints,dataUnits,
		waterfallSliceIndices,waterfallSliceSpans,slicedData,spanMidpoints,cutPts,
		waterfallTimePoints,reducedPoints,xyPoints,maxIndex,maxY,trimmedPts,finalPts
	},

	(* Get options from slicing options *)
	{numWaterfalls,redFunc,plotRange}=Lookup[slicingOptions,
		{NumberOfWaterfallSlices,WaterfallReductionFunction,PlotRange}
	];

	(* Implement None to First *)
	redFunc=redFunc/.{None->First};

	(* Get the grid points in the time dimension *)
	timeGrid=First@Lookup[downPacket,SamplingGridPoints];
	timePoints=Range@@timeGrid;

	(* Get the grid points in the mass dimension *)
	massGrid=Part[Lookup[downPacket,SamplingGridPoints],2];
	massPoints=Range@@massGrid;

	(* Get units of time and mass *)
	dataUnits=Lookup[downPacket,DataUnits];

	(* Indices to slice the data at *)
	waterfallSliceIndices=Round@Range[0,Length[data],Length[data]/numWaterfalls];

	(* Divide time points into numWaterfalls even spans *)
	waterfallSliceSpans=Map[
		Span[First[#]+1,Last[#]]&,
		Partition[waterfallSliceIndices,2,1]
	];

	(* Slice the sparse array into even segments for waterfalling *)
	slicedData=Part[data,#]&/@waterfallSliceSpans;

	(* Midway points for each span *)
	spanMidpoints=Map[
		Round[Mean[List@@#]]&,
		waterfallSliceSpans
	];

	(* Convert the waterfall slices into time points *)
	waterfallTimePoints=First[dataUnits]*RoundReals[
		Part[timePoints,Min[#+1,Length[timePoints]]]&/@spanMidpoints,
		2
	];

	(* Maximum intensity value *)
	maxY=Switch[plotRange,
		{_,{_,NumericP}},plotRange[[2,-1]],
		{_,_,{_,NumericP}},plotRange[[3,-1]],
		(* Default is the maximum intensity value of the data *)
		_,Max[data]
	];

	(* Apply a reduction function to flatten each slice *)
	reducedPoints=Map[
		(* Discard points with y values less than max intensity/777.0, since these are too small to see in a waterfall plot *)
		sparseMapTranspose[redFunc, #, maxY/777.0]&,
		slicedData
	];

	(* Make sure the units have the correct units before we transpose *)
	If[Length[massPoints]<Length[First@reducedPoints]||Length[massPoints]>Length[First@reducedPoints]+1,
		Message[Error::InvalidDataDimensions,
			Dimensions[data],
			Flatten[Dimensions/@(Range@@@Most[Lookup[downPacket,SamplingGridPoints]])]
		];
		Return[$Failed];
	];

	(* Convert to xy points *)
	xyPoints=Map[
		Transpose[{massPoints[[;;Length[#]]],#}]&,
		reducedPoints
	];

	(* Slice by plot range if the range was given explicitly *)
	maxIndex=Switch[plotRange,
		{{_,NumericP},_},
			Ceiling[(plotRange[[1,-1]]-First[massGrid])/Last[massGrid]],
		{_,{_,NumericP},_},
			Ceiling[(plotRange[[2,-1]]-First[massGrid])/Last[massGrid]],
		_,Null
	];

	(* Slice the data accordingly *)
	trimmedPts=If[MatchQ[maxIndex,Null],
		xyPoints,
		Part[#,;;Min[maxIndex,Length[#]]]&/@xyPoints
	];

	(* Convert each sliced data in to xy points *)
	finalPts=Map[
		QuantityArray[
			fastRemoveInternalRepeats[#],
			{dataUnits[[2]],dataUnits[[3]]}
		]&,
		trimmedPts
	];

	(* Stack and return the data *)
	MapThread[
		{#1,#2}&,
		{waterfallTimePoints,finalPts}
	]
];


(* AbsorbanceChromatogram - return the lc trace if it is valid, else return a fail state *)
sliceLCMSData[type:AbsorbanceChromatogram,
	data_SparseArray,
	downPacket_Association,
	lcTrace_,
	slicingOptions:{(_Rule|_RuleDelayed)..}
]:=If[MatchQ[lcTrace,$Failed|Null|{}],
	Message[Error::MissingLCTrace];
	$Failed,
	lcTrace
];

(* TotalIonCurrent/BasePeakChromatogram - total/max over all m/z values *)
sliceLCMSData[type:TotalIonCurrent|BasePeakChromatogram,
	data_SparseArray,
	downPacket_Association,
	lcTrace_,
	slicingOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{totaledData,gridPoints,dataUnits,xyPoints},

	(* Transpose across the m/z dimension s*)
	totaledData=If[MatchQ[type,TotalIonCurrent],
		Total@Transpose[data],
		Max/@data
	];

	(* Get the grid points *)
	gridPoints=Range@@First[Lookup[downPacket,SamplingGridPoints]];

	(* Get units from the downsampling packet *)
	dataUnits=Lookup[downPacket,DataUnits];

	(* Make sure the units have the correct units before we transpose *)
	If[Length[gridPoints]<Length[totaledData]||Length[gridPoints]>Length[totaledData]+1,
		Message[Error::InvalidDataDimensions,
			Dimensions[data],
			Flatten[Dimensions/@(Range@@@Most[Lookup[downPacket,SamplingGridPoints]])]
		];
		Return[$Failed];
	];

	(* Stich the points together *)
	xyPoints=Transpose[{gridPoints[[;;Length[totaledData]]],totaledData}];

	(* Append units to the quantity array *)
	QuantityArray[
		fastRemoveInternalRepeats[xyPoints],
		{First[dataUnits],Last[dataUnits]}
	]
];

(* MassSpectrum - slice data in the selected range of time points and apply a reduction function *)
sliceLCMSData[type:MassSpectrum,
	data_SparseArray,
	downPacket_Association,
	lcTrace_,
	slicingOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		sliceRanges,sliceFunc,plotRange,timeGrid,timePoints,massGrid,massPoints,dataUnits,
		sliceRangesConverted,sliceRangesIndices,dataSlices,collapsedData,xyPoints,trimmedPts,
		maxY,cutPts
	},

	(* Get slicing parameters from options *)
	{sliceRanges,sliceFunc,plotRange}=Lookup[slicingOptions,
		{MassSpectrumTimeRange,MassSpectrumReductionFunction,PlotRange}
	];

	(* Get the grid points in the time dimension *)
	timeGrid=First@Lookup[downPacket,SamplingGridPoints];
	timePoints=Range@@timeGrid;

	(* Get the grid points in the mass dimension *)
	massGrid=Part[Lookup[downPacket,SamplingGridPoints],2];
	massPoints=Range@@massGrid;

	(* Get units from the downsampling packet *)
	dataUnits=Lookup[downPacket,DataUnits];

	(* Convert the time range specification into consistent units *)
	sliceRangesConverted=Map[
		{
			Unitless[First[#],First[dataUnits]],
			Unitless[Last[#],First[dataUnits]]
		}&,
		sliceRanges
	];

	(* Convert the range into indices of the array *)
	sliceRangesIndices=Map[
		Function[{range},
			Min[Length[data],
				Max[1,
					(1+Round[(#-First[timeGrid])/Last[timeGrid]])
				]
			]&/@range
		],
		sliceRangesConverted
	];

	(* Slice only the requested range *)
	dataSlices=Map[
		data[[Span@@#]]&,
		sliceRangesIndices
	];

	(* Maximum intensity value *)
	maxY=If[MatchQ[plotRange],{_,{_,NumericP}},
		plotRange[[2,-1]],
		Max[data]
	];

	(* Transpose across the m/z dimension s*)
	collapsedData=Map[
		(* Discard y values for points less than the max intensity/2000.0, since they would be too small to see *)
		sparseMapTranspose[sliceFunc, #, maxY/2000.0]&,
		dataSlices
	];

	(* Make sure the units have the correct units before we transpose *)
	If[Length[massPoints]<Length[First@collapsedData]||Length[massPoints]>Length[First@collapsedData]+1,
		Message[Error::InvalidDataDimensions,
			Dimensions[data],
			Flatten[Dimensions/@(Range@@@Most[Lookup[downPacket,SamplingGridPoints]])]
		];
		Return[$Failed];
	];

	(* Stich the points together *)
	xyPoints=Map[
		Transpose[{massPoints[[;;Length[#]]],#}]&,
		collapsedData
	];

	(* Slice by plot range if the range was given explicitly *)
	maxIndex=If[MatchQ[plotRange,{{_,NumericP},_}],
		Ceiling[(plotRange[[1,-1]]-First[massGrid])/Last[massGrid]],
		Null
	];

	(* Slice the data accordingly *)
	trimmedPts=If[MatchQ[maxIndex,Null],
		xyPoints,
		Part[#,;;Min[maxIndex,Length[#]]]&/@xyPoints
	];

	(* Return a list of quantity arrays with appropriate units *)
	Map[
		QuantityArray[
			fastRemoveInternalRepeats[#],
			{dataUnits[[2]],dataUnits[[3]]}
		]&,
		trimmedPts
	]
];

(* ExtractedIonChromatogram - slice data according to given range of mass values *)
sliceLCMSData[type:ExtractedIonChromatogram,
	data_SparseArray,
	downPacket_Association,
	lcTrace_,
	slicingOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		sliceRanges,sliceFunc,timeGrid,timePoints,massGrid,massPoints,dataUnits,
		sliceRangesConverted,sliceRangesIndices,dataSlices,collapsedData,xyPoints
	},

	(* Get slicing parameters from options *)
	{sliceRanges,sliceFunc}=Lookup[slicingOptions,
		{ExtractedIonMassRange,ExtractedIonReductionFunction}
	];

	(* Get the grid points in the time dimension *)
	timeGrid=First@Lookup[downPacket,SamplingGridPoints];
	timePoints=Range@@timeGrid;

	(* Get the grid points in the mass dimension *)
	massGrid=Part[Lookup[downPacket,SamplingGridPoints],2];
	massPoints=Range@@massGrid;

	(* Get units from the downsampling packet *)
	dataUnits=Lookup[downPacket,DataUnits];

	(* Convert the time range specification into consistent units *)
	sliceRangesConverted=Map[
		{
			Unitless[First[#],Part[dataUnits,2]],
			Unitless[Last[#],Part[dataUnits,2]]
		}&,
		sliceRanges
	];

	(* Convert the range into indices of the array *)
	sliceRangesIndices=Map[
		Function[{range},
			Min[Length[Transpose@data],
				Max[1,
					(1+Round[(#-First[massGrid])/Last[massGrid]])
				]
			]&/@range
		],
		sliceRangesConverted
	];

	(* Slice only the requested range *)
	dataSlices=Map[
		Part[data,All,Span@@#]&,
		sliceRangesIndices
	];

	(* Transpose across the m/z dimension s*)
	collapsedData=Map[
		Function[{slicedData},
			sliceFunc/@slicedData
		],
		dataSlices
	];

	(* Make sure the units have the correct units before we transpose *)
	If[Length[timePoints]<Length[First@collapsedData]||Length[timePoints]>Length[First@collapsedData]+1,
		Message[Error::InvalidDataDimensions,
			Dimensions[data],
			Flatten[Dimensions/@(Range@@@Most[Lookup[downPacket,SamplingGridPoints]])]
		];
		Return[$Failed];
	];

	(* Stich the points together *)
	xyPoints=Map[
		Transpose[{timePoints[[;;Length[#]]],#}]&,
		collapsedData
	];

	(* Return a list of quantity arrays with appropriate units *)
	Map[
		QuantityArray[
			fastRemoveInternalRepeats[#],
			{dataUnits[[1]],dataUnits[[3]]}
		]&,
		xyPoints
	]
];


(* ::Subsection::Closed:: *)
(*applyExcludeRange*)

(* If the ExcludeRange option is a span wiht correct units, apply the exclude option *)
applyExcludeRange[
	sparseData:_SparseArray,
	downPacket:_Association,
	sliceSpans:{Span[UnitsP[Dalton],UnitsP[Dalton]]..}
]:=Module[
	{massGrid,unitlessSpans},

	(* Need to do this because function arguments are subbed in*)
	newData=sparseData;

	(* Get the grid points in the mass dimension *)
	massGrid=Part[Lookup[downPacket,SamplingGridPoints],2];

	(* Convert spans to the correct units *)
	unitlessSpans=Unitless[#,Dalton]&/@sliceSpans;

	(* Convert the provided ranges to indices *)
	spanIndices=Map[
		Span[
			Max[1,1+Ceiling[(First[#]-First[massGrid])/Last[massGrid]]],
			Min[1+Floor[(Last[#]-First[massGrid])/Last[massGrid]],Length[Transpose@newData]]
		]&,
		unitlessSpans
	];

	(* Zero out the excluded ranges *)
	Map[
		(Part[newData,All,#]=0)&,
		spanIndices
	];

	(* Return the updated sparse array *)
	newData
];

(* Do nothing if range doesn't match pattern *)
applyExcludeRange[sparseData_,downPacket_,_]:=sparseData;


(* ::Subsection::Closed:: *)
(*sparseMapTranspose*)

(* Map transpose on columns of a sparse array while taking advantage of sparsity *)
sparseMapTranspose[func_, sparseArr_, YThreshold_]:=Module[
	{nrows, ncols, groupByMz, newFunc, indexToReduced},

	(* Number of columns in the sparse array *)
	{nrows, ncols} = Dimensions[sparseArr];

	(* If the array has less than 10^6 columns, or is not sparse enough (has more than 300k values), Map to the transpose directly *)
	If[ncols<1000000 || Length[sparseArr["NonzeroValues"]] > 300000,
		With[{combinedFunc = Function[{x}, If[func[x]>=YThreshold, func[x], 0.0]]},
			Return[combinedFunc/@Transpose[sparseArr]]
		];
	];

	(* Group the sparse data points by their m/z/second index value *)
	groupByMz=GroupBy[
		(* Most is for dropping off the wildcard from ArrayRules for performance *)
		Most@ArrayRules[sparseArr],
		Function[{coord},Last[First[coord]]]
	];

	(* If we are doing a sparse mean, make sure to account for implicit zeros *)
	newFunc = If[MatchQ[func,Mean],
		Function[{x},Total[x]/N[nrows]],
		func
	];

	(* Paired indices with reduced values *)
	indexToReduced=KeyValueMap[
		Function[{key,val},
			With[{newY=newFunc[Last/@val]},
				key->If[newY>=YThreshold, newY, 0.0]
			]
		],
		KeySort[groupByMz]
	];

	(* Fill in the missing zeros *)
	Normal[SparseArray[Append[indexToReduced,ncols->0]]]
];


(* ::Subsection::Closed:: *)
(*resolveSpecificPlotOptions*)

(* Given resolved plot data *)
resolveSpecificPlotOptions[
	plotData_,
	downPacket_Association,
	{lcPeaks_,lcWavelength_},
	originalOps:{(_Rule|_RuleDelayed)...},
	partOps:{(_Rule|_RuleDelayed)...}
]:=Module[
	{plotType,resolvedPlotFunc,commonPlotOps,specificPlotOps,resolvedPlotOps},

	(* The requested plot type *)
	plotType=Lookup[partOps,PlotType];

	(* All plot types resolve to ELLP except for plot waterfall *)
	resolvedPlotFunc=Switch[plotType,
		WaterfallPlot,PlotWaterfall,
		_,EmeraldListLinePlot
	];

	(* Plot formatting options common to all plot types *)
	commonPlotOps=ReplaceRule[
		{
			Filling->Bottom,
			Zoomable->MatchQ[resolvedPlotFunc,EmeraldListLinePlot]
		},
		DeleteCases[originalOps,Rule[_,Automatic]],
		Append->True
	];

	(* Resolve specific plot options based on the plot type, making sure that original options take precedent *)
	specificPlotOps=ReplaceRule[
		commonPlotOps,
		specificPlotOptions[plotType,
			downPacket,
			lcPeaks,
			lcWavelength,
			originalOps,
			partOps
		],
		Append->True
	];

	(*If the PlotRange resolves to All in the x-direction for WaterfallPlot, Mathematicas Graphics does not actually
    resolve that further to capture all the slices.  So here I compute the fully resolved PlotRange in the x-direction
    so it encompasses all the slices.*)
	If[MatchQ[plotType, WaterfallPlot|PlotWaterfall],
		Module[{oldWaterfallPlotRange, xRange, padding, newXRange},
			oldWaterfallPlotRange = Lookup[partOps, PlotRange];

			If[Length[oldWaterfallPlotRange] == 3 && oldWaterfallPlotRange[[1]] === All,

				(*Use the smallest and largest of the sliced data x-values to determine the new PlotRange in x-direction.*)
				xRange = MinMax[ECL`Unitless[plotData[[All,1]]]];
				(*We need to add a little padding in order for the data at the boundaries to show up in Plot3D.*)
				(*We will use 10% of the span as the padding.*)
				padding = 0.1*Abs[Subtract@@xRange];
				(* Lower the lower bound by padding, and raise the upper bound by padding *)
				newXRange = {xRange[[1]] - padding, xRange[[2]] + padding};

				(*Update the PlotRange from specificPlotOps*)
				specificPlotOps = ECL`ReplaceRule[specificPlotOps,
					PlotRange -> ReplacePart[oldWaterfallPlotRange, 1 -> newXRange]
				];
			]
		]
	];

	(* Resolvedplot options  *)
	resolvedPlotOps=ReplaceRule[
		partOps,
		Join[
			commonPlotOps,
			specificPlotOps
		]
	];

	(* {Plot function, options} *)
	{resolvedPlotFunc,resolvedPlotOps}
];


(*** LCMS plot formatting options ***)

(* AbsorbanceChromatogram, i.e. the LC Trace *)
specificPlotOptions[AbsorbanceChromatogram,
	downPacket_,
	lcPeaks_,
	lcWavelength_,
	originalOps_,
	partOps_
]:={
	PlotLabel->"Absorbance ("<>ToString[Round@Unitless[lcWavelength,Nanometer]]<>" nm)",
	Peaks->If[MatchQ[lcPeaks,PacketP[Object[Analysis,Peaks]]],lcPeaks,Null]
};

(* TotalIonCurrent and BasePeakChromatogram (no slicing options) *)
specificPlotOptions[plot:TotalIonCurrent|BasePeakChromatogram,
	downPacket_,
	lcPeaks_,
	lcWavelength_,
	originalOps_,
	partOps_
]:={
	FrameLabel->{
		Automatic,
		Switch[plot,
			TotalIonCurrent,"Total Intensity",
			BasePeakChromatogram,"Max Intensity"
		]
	},
	PlotLabel->Switch[plot,
		TotalIonCurrent,"Total Ion Current",
		BasePeakChromatogram,"Base Peak Chromatogram"
	]
};

(* MassSpectrum *)
specificPlotOptions[plot:MassSpectrum,
	downPacket_,
	lcPeaks_,
	lcWavelength_,
	originalOps_,
	partOps_
]:=Module[
	{massPts,threshold,timeRanges,redFunc,legendLabels,noiseLIne},

	(* Look up mass points *)
	massPts=Part[Lookup[downPacket,SamplingGridPoints],2];

	(* Noise threshold *)
	threshold=Lookup[downPacket,NoiseThreshold,Null];

	(* Look up values from the partially resolved options *)
	{timeRanges,redFunc}=Lookup[
		partOps,
		{MassSpectrumTimeRange,MassSpectrumReductionFunction}
	];

	(* Labels for the legends *)
	legendLabels=Map[
		StringJoin[
			removeTerminalDecimal@ToString[Round[Unitless[First[#]],0.01]],
			"-",
			removeTerminalDecimal@ToString[Round[Unitless[Last[#]],0.01]],
			" ",
			ToString@QuantityUnit[First[#]]
		]&,
		timeRanges
	];

	(* Create a line to show the noise threshold *)
	noiseLine=Line[{{massPts[[1]],threshold},{massPts[[2]],threshold}}];

	(* Construct the plot options *)
	{
		FrameLabel->{
			"m/z (Da)",
			Switch[redFunc,
				Total,"Total Intensity (Arb.)",
				Mean,"Average Intensity (Arb.)",
				Min,"Minimum Intensity (Arb.)",
				Max,"Maximum Intensity (Arb.)"
			]
		},
		FrameUnits->{Dalton,ArbitraryUnit},
		PlotLabel->If[Length[legendLabels]>1,"Mass Spectra","Mass Spectrum"],
		InterpolationOrder->1,
		Legend->legendLabels,
		Epilog->If[TrueQ[Lookup[partOps,ShowNoiseThreshold]],
			{Thick,Red,Dashed,noiseLine},
			Null
		]
	}
];

(* ExtractedIonChromatogram *)
specificPlotOptions[plot:ExtractedIonChromatogram,
	downPacket_,
	lcPeaks_,
	lcWavelength_,
	originalOps_,
	partOps_
]:=Module[
	{timePts,massRanges,redFunc,legendLabels},

	(* Look up mass points *)
	timePts=Part[Lookup[downPacket,SamplingGridPoints],1];

	(* Look up values from the partially resolved options *)
	{massRanges,redFunc}=Lookup[
		partOps,
		{ExtractedIonMassRange,ExtractedIonReductionFunction}
	];

	(* Labels for the legends *)
	legendLabels=Map[
		StringJoin[
			"m/z: ",
			removeTerminalDecimal@ToString[Round[Unitless[First[#]],0.001]],
			"-",
			removeTerminalDecimal@ToString[Round[Unitless[Last[#]],0.001]]
		]&,
		massRanges
	];

	(* Construct the plot options *)
	{
		FrameLabel->{
			Automatic,
			Switch[redFunc,
				Total,"Total Intensity",
				Mean,"Average Intensity",
				Min,"Minimum Intensity",
				Max,"Maximum Intensity"
			]
		},
		PlotLabel->If[Length[legendLabels]>1,"Extracted Ion Chromatograms","Extracted Ion Chromatogram"],
		Legend->legendLabels
	}
];

(* TotalIonCurrent and BasePeakChromatogram (no slicing options) *)
specificPlotOptions[plot:WaterfallPlot,
	downPacket_,
	lcPeaks_,
	lcWavelength_,
	originalOps_,
	partOps_
]:=Module[
	{dataUnits,massRanges,redFunc,legendLabels},

	(* Look up mass points *)
	dataUnits=Lookup[downPacket,DataUnits,Automatic]/.{$Failed->Automatic};

	(* Look up values from the partially resolved options *)
	{massRanges,redFunc}=Lookup[
		partOps,
		{ExtractedIonMassRange,WaterfallReductionFunction}
	];

	(* Construct the plot options *)
	{
		AxesLabel->{
			"Time",
			"m/z",
			Switch[redFunc,
				Total,"Total Intensity",
				Mean,"Average Intensity",
				Min,"Minimum Intensity",
				Max,"Maximum Intensity",
				_,"Intensity"
			]
		},
		Axes->{True,True,True},
		AxesEdge->{{1,-1},{1,-1},{1,-1}},
		AxesUnits->dataUnits,
		ContourLabels->None,
		ContourSpacing->Value,
		Boxed->True,
		ViewPoint->{2.7917744338092843`,0.9619683003472058`,0.5004123298400626`},
		PlotRange->{Automatic,Automatic,{0,Automatic}},
		ImageSize->600
	}
];

(* Catch-all returns no specific options *)
specificPlotOptions[___]:={};


(* ::Subsection::Closed:: *)
(*addSidePlot*)

(* Add the side plot to the waterfall plot according to the WaterfallReferencePlot option *)
addSidePlot[
	plot_,
	data_,
	downsampledData_,
	downsamplePacket_,
	lcTrace_,
	resOps:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		refPlot,wfPlotRange,scaleCorrectionX,scaleCorrectionY,vertLines,
		timePoints,sidePlotVals,sidePlotData,lcWallPlot,lcWallTexture,combinedPlot
	},

	(* Look up the requested side plot type *)
	refPlot=Lookup[resOps,WaterfallReferencePlot];

	(* Plot range of the 3D waterfall plot to embed side plot into *)
	wfPlotRange=PlotRange[plot];

	(* Transform the plot because of plot range padding *)
	scaleCorrectionX=Abs[2*0.010204081632653073`*(wfPlotRange[[1,2]]-wfPlotRange[[1,1]])];
	scaleCorrectionY=Abs[0.010204081632653073`*wfPlotRange[[3,2]]];

	(* Resolve data to put on the side plot *)
	sidePlotData=Switch[refPlot,
		(* Use the lc trace if the AbsorbanceChromatogram was asked for *)
		AbsorbanceChromatogram,
			Unitless[lcTrace],
		(* TIC *)
		TotalIonCurrent,
			Unitless@sliceLCMSData[TotalIonCurrent,downsampledData,downsamplePacket,lcTrace,resOps],
		(* BPC *)
		BasePeakChromatogram,
			Unitless@sliceLCMSData[TotalIonCurrent,downsampledData,downsamplePacket,lcTrace,resOps],
		(* Default is null *)
		_,Null
	];

	(* Warning if no side plot data could be resolved *)
	If[MatchQ[sidePlotData,$Failed|Null],
		If[MatchQ[refPlot,Except[None|Null]],
			Message[Warning::WaterfallSidePlotMissing,refPlot];
		];
		Return[plot];
	];

	(* Time points for waterfall slices *)
	timePoints=First/@data;

	(* yvalues for each time point *)
	sidePlotVals=Map[
		Function[{time},
			SelectFirst[Unitless[sidePlotData],First[#]>Unitless[time]&]
		],
		timePoints
	];

	(* Vertical line for each time point *)
	vertLines=Map[
		{{First[#],Min[Unitless[Last/@sidePlotData]]},#}&,
		sidePlotVals
	];

	(* Generate a graphic for the wall of the waterfall plot *)
	lcWallPlot=ListLinePlot[
		{
			sidePlotData,
			Sequence@@vertLines
		},
		PlotRange->{First[wfPlotRange],All},
		PlotRangePadding->Scaled[0.02],
		Axes->False,
		PlotStyle->{Darker@Gray,Sequence@@Repeat[{Gray,Dashed},Length[vertLines]]}
	];

	(* Embed the graphic into the wall of the 3D plot *)
	lcWallTexture=Graphics3D[{
		Texture[Rasterize[lcWallPlot,Background->None,ImageResolution->300]],
		EdgeForm[None],
		Polygon[
			{
				{wfPlotRange[[1,1]]-scaleCorrectionX,wfPlotRange[[2,1]],0-scaleCorrectionY},
				{wfPlotRange[[1,2]]+scaleCorrectionX,wfPlotRange[[2,1]],0-scaleCorrectionY},
				{wfPlotRange[[1,2]]+scaleCorrectionX,wfPlotRange[[2,1]],wfPlotRange[[3,2]]+scaleCorrectionY},
				{wfPlotRange[[1,1]]-scaleCorrectionX,wfPlotRange[[2,1]],wfPlotRange[[3,2]]+scaleCorrectionY}
			},
			VertexTextureCoordinates->{{0,0},{1,0},{1,1},{0,1}}
		]
	}];

	(* Join the side plot with the waterfall plot *)
	combinedPlot=Show[plot,lcWallTexture];

	(* Disable dynamics for stability *)
	combinedPlot
];



(* ::Subsection::Closed:: *)
(*Utility Functions*)

(* Delete interior repeated data points in the plot to reduce the number of plots that need to be displayed *)
removeInternalRepeats[xy_]:=Map[
	If[Length[#]>1,
		Sequence@@{First[#],Last[#]},
		Sequence@@#
	]&,
	SplitBy[xy,Last]
];

(* Compiled binary for O(N) construction of a duplicate list with internal zeros removed *)
fastRemoveInternalRepeats=Core`Private`SafeCompile[
	{
		{coords, _Real, 2}
	},

	Block[{i=2, imax=Length[coords],newList={coords[[1]]}},
		For[i=2,i<imax,i++,
			(* Construct a new list, skipping any y=0 pairs bordered by two xy coordinates with y = 0 *)
			If[Not[coords[[i-1]][[-1]]==0.0&&coords[[i+1]][[-1]]==0.0&&coords[[i]][[-1]]==0.0],newList=Append[newList,coords[[i]]]]
		];
		(* Add the last element of the list *)
		Append[newList,coords[[imax]]]
	]
];

(* Remove period from end of a string *)
removeTerminalDecimal[str_String]:=If[StringTake[str,-1]==".",
	StringTake[str,;;-2],
	str
];
