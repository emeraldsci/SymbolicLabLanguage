(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryIsoelectricFocusingEvolution*)


DefineOptions[PlotCapillaryIsoelectricFocusingEvolution,
	Options:>{
		IndexMatching[
			{
				OptionName->FramesToPlot,
				Default->All,
				Description->"Defines which frames to plot .",
				AllowNull->False,
				Category->"Data Specifications",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[All]],
					Adder[Widget[Type->Number,Pattern:>GreaterP[0,1]]]
				]
			},
			{
				OptionName->Duration,
				Default->Automatic,
				Description->"The total duration of the specified separation data.",
				ResolutionDescription->"When set to automatic, The total duration will be set based on the VoltageDurationProfile in the data object, or Null if it is unavailable.",
				AllowNull->True,
				Category->"Data Specifications",
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Automatic]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Second],
						Units:>Minute
					]
				]
			},
			{
				OptionName->SubtractFirstFrame,
				Default->True,
				Description->"Defines whether the first frame serves as a background reading and should be subtracted from all other frames.",
				AllowNull->False,
				Category->"Data Specifications",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			IndexMatchingInput->"dataObject"
		],
		{
			OptionName->OutputFormat,
			Default->SingleInteractivePlot,
			Description->"Indicates if the output should be a an interactive plot for all time points, a single static plot with all timepoints, or a list of static plots for each time point.",
			AllowNull->False,
			Category->"Output",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SingleInteractivePlot|SingleStaticPlot|MultipleStaticPlots
			]
		},
		{
			OptionName->SeparationData,
			Default->Null,
			Description->"UV absorbance traces as a factor of distance in the capillary over time to display on the plot.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Expression,
				Pattern:>_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|({QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size->Paragraph
			]
		},
		ModifyOptions[EmeraldListLinePlot,
			{
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Filling,FillingStyle,InterpolationOrder,ErrorType,ErrorBars,
				SecondYCoordinates,SecondYColors,SecondYUnit,SecondYRange,SecondYStyle,
				Peaks,PeakLabels,PeakLabelStyle,Joined
			},
			Category->"Hidden"
		]
	},
	SharedOptions:>{
		OutputOption,
		EmeraldListLinePlot
	}
];

Warning::InvalidFramesToPlot="The data packet in index (`1`) does not contain data collected for frame `2` (data is present for `3` frames). Please make sure to specify a valid value. Defaulting FramesToPlot option to All.";
Warning::InvalidDuration="The data packet (`1`) was collected over `3`, while `2` was specified as Duration.";
Error::NoCapillaryIsoelectricFocusingDataToPlot = "The protocol object does not contain any associated capillary isoelectric focusing data.";
Error::CapillaryIsoelectricFocusingProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotCapillaryIsoelectricFocusingEvolution or PlotObject on an individual data object to identify the missing values.";

(* Raw Definition *)
PlotCapillaryIsoelectricFocusingEvolution[primaryData:rawPlotInputP,inputOptions:OptionsPattern[]]:=
	Module[{nullPacket},
		nullPacket = <|
			Type-> Object[Data,CapillaryIsoelectricFocusing],
			SeparationData -> primaryData
		|>;

		PlotCapillaryIsoelectricFocusingEvolution[nullPacket, inputOptions]
];

(* Protocol Overload *)
PlotCapillaryIsoelectricFocusingEvolution[
	obj: ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]],
	ops: OptionsPattern[PlotCapillaryIsoelectricFocusingEvolution]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCapillaryIsoelectricFocusingEvolution, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, CapillaryIsoelectricFocusing]]..}],
		Message[Error::NoCapillaryIsoelectricFocusingDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotCapillaryIsoelectricFocusingEvolution[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotCapillaryIsoelectricFocusingEvolution[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::CapillaryIsoelectricFocusingProtocolDataNotPlotted];
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

(* Packet Definition *)
PlotCapillaryIsoelectricFocusingEvolution[infs:ListableP[ObjectP[Object[Data,CapillaryIsoelectricFocusing]]],inputOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,gatherTests,dataObjects,listedOptions,outputOptions,output,safeOptions,safeOptionTests,
		allDownload,packets,separationTraces,currentTraces,voltageTraces,separationDataQ,currentDataQ,voltageDataQ,rawDataQ,
		subtractFirstFrames,framesToPlot,framesPresent,invalidFrameToPlot,resolveFramesToPlot,dataDuration,durationFromDataObjects,
		invalidSpecifiedDuration,resolveDuration,timeStamps,outputFormat,

		result,options,flattenedResults, flattenedOptions, preview
	},

	(* -- DOWNLOAD AND OPTIONS LOOKUP -- *)

	(* make sure we're working with a list of objects *)
	dataObjects=ToList[infs];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[inputOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Determine if we should output the resolved options *)
	outputOptions=MemberQ[output,Options];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotCapillaryIsoelectricFocusingEvolution,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[PlotCapillaryIsoelectricFocusingEvolution,listedOptions,AutoCorrect->False],Null}
	];

	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* download things we might need *)
	allDownload=Quiet[Download[
		dataObjects,
		Packet[VoltageDurationProfile,SeparationData,CurrentData,VoltageData]
	],Download::MissingField];

	(* Assign each type of data to its own variable or grab it from options if we got raw data - I am confident
	there's a better way of doing this and I'm probably missing something, but hey - this should work too..*)
	separationTraces=If[MatchQ[ToList@Lookup[allDownload,SeparationData],{$Failed..}],
		Lookup[listedOptions,SeparationData]/.Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,SeparationData]
	];

	currentTraces=If[MatchQ[ToList@Lookup[allDownload,CurrentData],{$Failed..}],
		ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,CurrentData]
	];

	voltageTraces=If[MatchQ[ToList@Lookup[allDownload,VoltageData],{$Failed..}],
		ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,VoltageData]
	];

	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets=If[MatchQ[Lookup[allDownload,Object],{$Failed..}],
		KeyDrop[allDownload,Object],
		allDownload
	];

	(* -- ERROR CHECK AND OPTION RESOLUTION -- *)

	(* Check what data was collected/passed but if raw data is passed, we need to avoid trying data that's not there *)
	separationDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@separationTraces;
	currentDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@currentTraces;
	voltageDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@voltageTraces;

	(* are we using raw data or data objects? *)
	rawDataQ = And@@separationDataQ&&!And@@currentDataQ;

	(* Expand if we need to subtruct first frames from the rest of the data *)
	subtractFirstFrames=If[Length[ToList@Lookup[safeOptions,SubtractFirstFrame]]==1&&Length[ToList@Lookup[safeOptions,SubtractFirstFrame]]<Length[ToList@dataObjects],
		ConstantArray[Lookup[safeOptions,SubtractFirstFrame],Length[ToList@dataObjects]],
		ToList@Lookup[safeOptions,SubtractFirstFrame]
	];

	(* check if we have all the frames specified for plotting, expand if needed *)
	framesToPlot=Lookup[safeOptions,FramesToPlot];
	framesToPlot=If[Depth[ToList@framesToPlot]==2||Length[ToList@framesToPlot]<Length[ToList@dataObjects],
		ConstantArray[ToList@framesToPlot,Length[ToList@dataObjects]],
		framesToPlot
	];

	(* how many frames do we have ? (we are subtracting 1 from the present if SubtractFirstFrame is False) *)
	framesPresent=MapThread[Function[{subtractFirst,trace},
		If[subtractFirst,
			Length[trace]-1,
			Length[trace]
		]],
		{subtractFirstFrames,separationTraces}
	];

	(* see if we have any specified frame to plot that are invalid *)
	invalidFrameToPlot=MapThread[Function[{index,toPlot,present},
		If[MatchQ[ToList[toPlot],Except[{All}]]&&Length[Complement[ToList[toPlot],Range[present]]]>0,
			{index,toPlot,present},
			{}
		]],
		{Range[Length[dataObjects]],framesToPlot,framesPresent}
	];

	(* Warn if the user specified exposure time is not present when plotting fluorescence *)
	If[Length[Flatten@invalidFrameToPlot]>0,
		Message[Warning::InvalidFramesToPlot,invalidFrameToPlot[[All,1]],invalidFrameToPlot[[All,2]],invalidFrameToPlot[[All,3]]]
	];

	(* resolve number of frames to plot *)
	resolveFramesToPlot=MapThread[Function[{toPlot,present},
		Which[
			(* a valid integer value was specified for FramesToPlot *)
			MatchQ[ToList[toPlot],{_Integer..}]&&Length[Complement[ToList[toPlot],Range[present]]]==0,ToList[toPlot],
			(* an invalid integer value was specified for FramesToPlot, default to All *)
			MatchQ[ToList[toPlot],{_Integer..}]&&Length[Complement[ToList[toPlot],Range[present]]]>0,ToList[present],
			(* All was specified for FramesToPlot, default to All *)
			MatchQ[ToList[toPlot],All],Range[present],
			True,Range[present]
		]],
		{framesToPlot,framesPresent}
	];

	(* check if durations conform *)
	dataDuration=Lookup[safeOptions,Duration];
	dataDuration=If[Length[ToList@dataDuration]==1&&Length[ToList@dataDuration]<Length[ToList@dataObjects],
		ConstantArray[dataDuration,Length[ToList@dataObjects]],
		ToList@dataDuration
	];

	(* get the voltage duration profiles to get the total time the method was running (the Maurice is taking 32 images throughout the separation *)
	durationFromDataObjects=If[!MatchQ[Lookup[allDownload,VoltageDurationProfile], {$Failed..}],
		Map[Function[{profile},
			If[MatchQ[profile,Except[{}]],
				Total[profile[[All,2]]],
				Null
			]],
			Lookup[allDownload,VoltageDurationProfile]
		],
		ConstantArray[Null,Length[ToList@dataObjects]]
	];

	(* check if any durations are invalid *)
	invalidSpecifiedDuration=MapThread[Function[{object,specifiedDuration,presentDuration},
		If[MatchQ[presentDuration,Except[Null]]&&MatchQ[specifiedDuration,Except[Automatic]]&&specifiedDuration!=presentDuration,
			{Download[object,Object],specifiedDuration,presentDuration},
			{}
		]],
		{dataObjects,dataDuration,durationFromDataObjects}
	];

	(* Warn if the user specified duration is not compatible with the duration in the object *)
	If[Length[Flatten@invalidSpecifiedDuration]>0,
		Message[Warning::InvalidDuration,invalidSpecifiedDuration[[All,1]],invalidSpecifiedDuration[[All,2]],invalidSpecifiedDuration[[All,3]]]
	];

	(* resolve number of frames to plot *)
	resolveDuration=MapThread[Function[{specifiedDuration,presentDuration},
		Which[
			(* a value was specified for Duration and data is raw*)
			MatchQ[specifiedDuration,Except[Automatic]]&&rawDataQ,specifiedDuration,
			(* a value was specified for Duration and is compatible with what we have *)
			MatchQ[specifiedDuration,Except[Automatic]]&&!rawDataQ&&specifiedDuration==presentDuration,specifiedDuration,
			(* a value was specified for Duration and it is not compatible with what we have*)
			MatchQ[specifiedDuration,Except[Automatic]]&&!rawDataQ&&specifiedDuration!=presentDuration,specifiedDuration,
			(* Automatic was specified for Duration and there is a value from the data object,resolve to duration in the data object *)
			MatchQ[specifiedDuration,Automatic]&&MatchQ[presentDuration,Except[Null]],presentDuration,
			True,Null
		]],
		{dataDuration,durationFromDataObjects}
	];

	(* we are assuming data is taken in consistent intervals between all frames over duration *)
	timeStamps=MapThread[Function[{numberOfFrames,duration},
		If[NullQ[duration],
			Map[{#+1,#+1}&,Range[0,numberOfFrames-1]],
			Map[{#+1,RoundOptionPrecision[Convert[(duration/(numberOfFrames-1))*#,Second],1*Second]}&,Range[0,numberOfFrames-1]]
		]
	],
		{framesPresent,resolveDuration}
	];

	(* -- PREPARE OUTPUT -- *)
	outputFormat=Lookup[safeOptions,OutputFormat];

	{result,options}=Transpose@MapThread[Function[{object,traces,subtractFirst,framesToPlot,timeStamp},
		Switch[outputFormat,
			SingleInteractivePlot,
			Module[{data,frameToTime,epilogs,almostResolvedOptions,plotLabel,yrange,plots,resolvedOptions},

				(* get relevant data (depends on SubtractFirstFrame is False) *)
				data=If[subtractFirst,
					(* we're mapping to only subtract the UVAbs reading and not position, while converting to MilliAU in the process*)
					Map[Function[singleTrace,Module[{position,signal,background},
						position=singleTrace[[All,1]];
						signal=singleTrace[[All,2]]*1000;
						background=traces[[1]][[All,2]]*1000;

						Transpose[{position,background-signal}]
					]],
						Part[traces[[2;;]],framesToPlot]
					],
					Part[traces,framesToPlot]
				];

				(* make sure we have a consistent range across all images *)
				yrange=Module[{allYValues,maxY,minY,buffer},
					allYValues=Flatten[data,1][[All,2]];
					{maxY,minY}={Max[allYValues],Min[allYValues]};
					(* make a buffer based on the whole range *)
					buffer=(maxY-minY)*0.1;
					(* return the range we'd want across all plots *)
					{minY-buffer,maxY+buffer}
				];

				(* get relevant time stamps *)
				frameToTime=If[MatchQ[timeStamp[[All,2]], {TimeP..}],
					Part[timeStamp[[All,2]],framesToPlot],
					("Frame "<>ToString[#])&/@Part[timeStamp[[All,2]],framesToPlot]
				];

				(* plotLabels *)
				plotLabel=If[!rawDataQ,
					Style[ToString[object],Bold,12],
					Null
				];

				(* construct insets with the time stamp for each frame *)
				epilogs=Map[Function[time,{Inset[Style[ToString[time],Italic,12],Scaled[{0.14,0.05}]]}],frameToTime];

				(* get everything to associations and merge into plotOptions*)
				almostResolvedOptions=MapThread[Merge[{{
					PlotLabel->#1,
					Epilog->#2,
					Frame->{True,True,False,False},
					PlotRange->{Automatic,#3},
					FrameLabel->{
						Style["Distance (Pixels)",12],Style["Absorbance (mAU)",12]
					},
					FrameTicksStyle -> Directive[10],
					ImageSize->350
				},safeOptions},First]&,
					{ConstantArray[plotLabel,Length[frameToTime]],epilogs,ConstantArray[yrange,Length[frameToTime]]}
				];

				almostResolvedOptions=Map[Function[options,KeyValueMap[#1->#2&,options]],almostResolvedOptions];

				(* plot *)
				{plots,resolvedOptions}=Transpose@MapThread[EmeraldListLinePlot[
					#1,
					PassOptions[
						PlotCapillaryIsoelectricFocusingEvolution,
						EmeraldListLinePlot,
						ReplaceRule[#2,{Output->{Result,Options}}]]
				]&,
					{data,almostResolvedOptions}
				];

				(* return data and options *)
				{ListAnimate[plots, SaveDefinitions -> True],resolvedOptions[[1]]}
			],
			SingleStaticPlot,
			Module[{data,frameToTime,legend,plotLabel,almostResolvedOptions,plots,resolvedOptions,legendLabel},

				(* get relevant data (depends on SubtractFirstFrame is False) *)
				data=If[subtractFirst,
					(* we're mapping to only subtract the UVAbs reading and not position *)
					Map[Function[singleTrace,Module[{position,signal,background},
						position=singleTrace[[All,1]];
						signal=singleTrace[[All,2]];
						background=traces[[1]][[All,2]];

						Transpose[{position,background-signal}]
					]],
						Part[traces[[2;;]],framesToPlot]
					],
					Part[traces,framesToPlot]
				];

				(* get relevant time stamps *)
				frameToTime=If[MatchQ[timeStamp[[All,2]], {TimeP..}],
					Part[timeStamp[[All,2]],framesToPlot],
					("Frame "<>ToString[#])&/@Part[timeStamp[[All,2]],framesToPlot]
				];

				(* plotLabels *)
				plotLabel=If[!rawDataQ,
					ToString[object],
					""
				];

				(* Legend *)
				legend=ToString/@frameToTime;

				(* If we have time stamps, we can call the legend that.. *)
				legendLabel = If[And@@(MatchQ[#,TimeP]&/@timeStamps),
					"Separation Times",
					"Separation Frames"
				];

				(* get everything to associations and merge into plotOptions*)
				almostResolvedOptions=Merge[{{
					PlotLabel->plotLabel,
					Frame->{True,True,False,False},
					FrameLabel->{
						"Distance (Pixels)","Absorbance (AU)"
					},
					LegendLabel->legendLabel,
					Legend->legend
				},safeOptions},Last];

				almostResolvedOptions=KeyValueMap[#1->#2&,almostResolvedOptions];

				(* plot *)
				{plots,resolvedOptions}=EmeraldListLinePlot[
					data,
					PassOptions[
						PlotCapillaryIsoelectricFocusingEvolution,
						EmeraldListLinePlot,
						ReplaceRule[almostResolvedOptions,{Output->{Result,Options}}]]
				];

				(* return data and options *)
				{plots,resolvedOptions}
			],
			MultipleStaticPlots,
			Module[{data,frameToTime,yrange,plotLabels,almostResolvedOptions,plots,resolvedOptions },

				(* get relevant data (depends on SubtractFirstFrame is False) *)
				data=If[subtractFirst,
					(* we're mapping to only subtract the UVAbs reading and not position *)
					Map[Function[singleTrace,Module[{position,signal,background},
						position=singleTrace[[All,1]];
						signal=singleTrace[[All,2]];
						background=traces[[1]][[All,2]];

						Transpose[{position,background-signal}]
					]],
						Part[traces[[2;;]],framesToPlot]
					],
					Part[traces,framesToPlot]
				];

				(* make sure we have a consistent range across all images *)
				yrange=Module[{allYValues,maxY,minY,buffer},
					allYValues=Flatten[data,1][[All,2]];
					{maxY,minY}={Max[allYValues],Min[allYValues]};
					(* make a buffer based on the whole range *)
					buffer=(maxY-minY)*0.1;
					(* return the range we'd want across all plots *)
					{minY-buffer,maxY+buffer}
				];

				(* get relevant time stamps *)
				frameToTime=If[MatchQ[timeStamp[[All,2]], {TimeP..}],
					Part[timeStamp[[All,2]],framesToPlot],
					("Frame "<>ToString[#])&/@Part[timeStamp[[All,2]],framesToPlot]
				];

				(* plotLabels *)
				plotLabels=If[!rawDataQ,
					(ToString[object]<>"\n"<>ToString[#])&/@frameToTime,
					("Frame "<>ToString[#])&/@frameToTime
				];

				(* get everything to associations and merge into plotOptions*)
				almostResolvedOptions=MapThread[Merge[{{
					PlotLabel->#1,
					Frame->{True,True,False,False},
					PlotRange->{Automatic,#2},
					FrameLabel->{
						"Distance (Pixels)","Absorbance (AU)"
					}
				},safeOptions},Last]&,
					{plotLabels,ConstantArray[yrange,Length[frameToTime]]}
				];

				almostResolvedOptions=Map[Function[options,KeyValueMap[#1->#2&,options]],almostResolvedOptions];

				(* plot *)
				{plots,resolvedOptions}=Transpose@MapThread[EmeraldListLinePlot[
					#1,
					PassOptions[
						PlotCapillaryIsoelectricFocusingEvolution,
						EmeraldListLinePlot,
						ReplaceRule[#2,{Output->{Result,Options}}]]
				]&,
					{data,almostResolvedOptions}
				];

				(* return data and options *)
				{plots,resolvedOptions[[1]]}
			]
		]],
		{dataObjects,separationTraces,subtractFirstFrames,resolveFramesToPlot,timeStamps}
	];

	outputOptions = Normal[Join[Association[options],
		Association[{
			FramesToPlot->resolveFramesToPlot,
			Duration->resolveDuration,
			SubtractFirstFrame->subtractFirstFrames,
			OutputFormat->outputFormat,
			SeparationData->Lookup[safeOptions, SeparationData]
		}]]];

	{flattenedResults, preview} = Switch[outputFormat,
		SingleInteractivePlot,
			If[Length[dataObjects]==1,
				First/@{result, result},
				{result, result[[1]]}
		],
		SingleStaticPlot,
			If[Length[dataObjects]==1,
				First/@{result, result},
				{result, result[[1]]}
		],
		MultipleStaticPlots,
			If[Length[dataObjects]==1,
				First/@{result,Flatten[result,1]},
				{result,  Flatten[result,1][[1]]}
		]
	];

	(* Return the requested outputs *)
	outputSpecification/.{
		Result->flattenedResults,
		Options->outputOptions,
		Preview->preview,
		Tests->{}
	}
];
