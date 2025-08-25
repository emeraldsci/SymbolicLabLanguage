(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFragmentAnalysis*)


DefineOptions[PlotFragmentAnalysis,
	
		Options:>{
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Filling,
						Default->Bottom,
						Description->"Indicates how the region under the spectrum should be shaded.",
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[ScaleOption,
				{
					{
						OptionName->Scale,
						Default->Linear,
						Description->"Specifies the type of scaling the x and y axis will have.",
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[ImagesOption,
				{
					{
						OptionName->Images,
						Default->LaneImage,
						Widget->Alternatives[
							Widget[Type->Enumeration, Pattern:>Alternatives[LaneImage]],
							Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
						],
						Category->"Hidden"
					}
				}
			],
			{
				OptionName -> PrimaryData,
				Default -> Automatic,
				Description -> "The data to be plotted. This applies to all data objects plotted.",
				AllowNull -> False,
				Category -> "FragmentAnalysis",
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Electropherogram|DNAFragmentSizeAnalyses|RNAFragmentSizeAnalyses]
				]
			}
		}(*,
		generateSharedOptions[
			Object[Data,FragmentAnalysis],
			Electropherogram,
			PlotTypes -> {LinePlot},
			Display -> {Peaks},
			DefaultUpdates -> {
				FrameLabel -> {"Time (Second)", "Fluorescence (RFU)"
				}}
		],
		generateSharedOptions[
			Object[Data,FragmentAnalysis],
			DNAFragmentSizeAnalyses,
			PlotTypes -> {LinePlot},
			Display -> {Peaks},
			DefaultUpdates -> {
				FrameLabel -> {"Fragment Size (BasePair)", "Fluorescence (RFU)"
				}}
		],
		generateSharedOptions[
			Object[Data,FragmentAnalysis],
			RNAFragmentSizeAnalyses,
			PlotTypes -> {LinePlot},
			Display -> {Peaks},
			DefaultUpdates -> {
				FrameLabel -> {"Fragment Size (Nucleotide)", "Fluorescence (RFU)"
				}}
		]
		*)
	,
	SharedOptions :> {
		ZoomableOption,
		PlotLabelOption,
		UnitsOption,
		MapOption,
		EmeraldListLinePlot
	}
];

Error::NoFragmentAnalysisDataToPlot = "The protocol object does not contain any associated fragment analysis data.";
Error::FragmentAnalysisProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotFragmentAnalysis or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotFragmentAnalysis[
	obj: ObjectP[Object[Protocol, FragmentAnalysis]],
	ops: OptionsPattern[PlotFragmentAnalysis]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFragmentAnalysis, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, FragmentAnalysis]]..}],
		Message[Error::NoFragmentAnalysisDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotFragmentAnalysis[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotFragmentAnalysis[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::FragmentAnalysisProtocolDataNotPlotted];
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

PlotFragmentAnalysis[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:=Module[{primaryDataPackets,outputs},
	primaryDataPackets=Download[
		primaryData,
		Packet[Electropherogram,DNAFragmentSizeAnalyses,RNAFragmenSizeAnalyses,SimulatedGelImage]
	];
	
	outputs = rawToPacket[
		primaryData,
		Object[Data,FragmentAnalysis],
		PlotFragmentAnalysis,
		(*we need to check if the primary data was specified, if not then we need to figure out what kind of data is present instead of just assuming absorbance*)
		Module[{safeOptions,primaryDataOption},
			safeOptions=SafeOptions[PlotFragmentAnalysis, ToList[inputOptions]];
			(*is the primary data still automatic?*)
			primaryDataOption=Lookup[safeOptions,PrimaryData];
			(*if so try to figure out what should be plotted, otherwise leave as is*)
			If[MatchQ[primaryDataOption,Automatic],
				(* see the units of the primary data*)
				Which[
					(* If RNAFragmentSizeAnalyses is not empty, use this *)
					MatchQ[Lookup[primaryDataPackets,RNAFragmentSizeAnalyses],_?(QuantityCoordinatesQ[#1, {Nucleotide, RFU}] &) | {_?(QuantityCoordinatesQ[#1, {Nucleotide, RFU}] &) ..} | {{_?(QuantityCoordinatesQ[#1, {Nucleotide, RFU}] &) ..} ..}],
					ReplaceRule[safeOptions,PrimaryData->RNAFragmentSizeAnalyses],
					
					(* If DNAFragmentSizeAnalyses is not empty, use this *)
					MatchQ[Lookup[primaryDataPackets,DNAFragmentSizeAnalyses],_?(QuantityCoordinatesQ[#1, {BasePair, RFU}] &) | {_?(QuantityCoordinatesQ[#1, {BasePair, RFU}] &) ..} | {{_?(QuantityCoordinatesQ[#1, {BasePair, RFU}] &) ..} ..}],
					ReplaceRule[safeOptions,PrimaryData->DNAFragmentSizeAnalyses],
					
					(* If Electropherogram is not empty, use this *)
					MatchQ[Lookup[primaryDataPackets,Electropherogram],_?(QuantityCoordinatesQ[#1, {Second, RFU}] &) | {_?(QuantityCoordinatesQ[#1, {Second, RFU}] &) ..} | {{_?(QuantityCoordinatesQ[#1, {Second, RFU}] &) ..} ..}],
					ReplaceRule[safeOptions,PrimaryData->Electropherogram]
				],
				(* and if not automatic just go with whatever the specification was *)
				safeOptions
			]
		]];
	
	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[outputs,SafeOptions[PlotFragmentAnalysis,ToList@inputOptions]]
	
];

PlotFragmentAnalysis[infs:ListableP[ObjectP[Object[Data,FragmentAnalysis]]],inputOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,gatherTests,dataObjects,listedOptions,outputOptions,output, safeOptions,safeOptionTests,
		requestedPrimaryData,requestedSecondaryData ,primaryDataFields,secondaryDataFields, allDownload, packets,electropherogramDataSets,
		dnaFragmentSizeDataSets,rnaFragmentSizeDataSets,relativeTraces,electropherogramDataQ,dnaFragmentSizeDataQ,rnaFragmentSizeDataQ,rawDataQ,relativeDataQ,
		resolvedPrimaryData,resolvedSecondaryData,resolvedFrameLabel,positionWidthTuple,resolvedPeaks,
		plotLabel,resolvedOpsWithOutput,ellpResult,result,options,newestPks,xPosition
	},
	
	(* -- DOWNLOAD AND OPTIONS LOOKUP -- *)
	
	(* make sure we're working with a list of objects *)
	dataObjects = ToList[infs];
	
	(* Make sure we're working with a list of options *)
	listedOptions = ToList[inputOptions];
	
	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[OptionValue[Output]];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	
	(* Determine if we should output the resolved options *)
	outputOptions = MemberQ[output, Options];
	
	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotFragmentAnalysis,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[PlotFragmentAnalysis,listedOptions,AutoCorrect->False],Null}
	];
	
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];
	
	(* Don't call safeOps since packetToELLP will distribute listed options *)
	requestedPrimaryData = OptionDefault[OptionValue[PrimaryData]];
	
	(* download things we might need *)
	allDownload = Quiet[
		Download[
			dataObjects,
			Packet[Electropherogram,DNAFragmentSizeAnalyses,RNAFragmentSizeAnalyses,LaneImageFile,LaneImage,SampleAnalyteType]
		],
		{Download::MissingField,Download::Part}
	];
	
	(* Assign each type of data to its own variable or grab it from options if we got raw data - I am confident
	there's a better way of doing this and I'm probably missing something, but hey - this should work too..*)
	electropherogramDataSets = If[MatchQ[ToList@Lookup[allDownload, Electropherogram], {$Failed..}],
		Lookup[listedOptions, Electropherogram]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, Electropherogram]
	];
	
	dnaFragmentSizeDataSets = If[MatchQ[ToList@Lookup[allDownload, DNAFragmentSizeAnalyses], {$Failed..}],
		Lookup[listedOptions, DNAFragmentSizeAnalyses]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, DNAFragmentSizeAnalyses]
	];
	
	rnaFragmentSizeDataSets = If[MatchQ[ToList@Lookup[allDownload,RNAFragmentSizeAnalyses], {$Failed..}],
		Lookup[listedOptions, RNAFragmentSizeAnalyses]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, RNAFragmentSizeAnalyses]
	];
	
	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets = If[MatchQ[Lookup[allDownload,Object],{$Failed..}],
		KeyDrop[allDownload,Object],
		allDownload
	];
	
	(* -- ERROR CHECK AND OPTION RESOLUTION -- *)
	
	(* Check what data data was collected/passed (The user can only control whether or not to collect FL data,
	but if raw data is passed, we need to avoid trying data that's not there *)
	electropherogramDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@electropherogramDataSets;
	dnaFragmentSizeDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@dnaFragmentSizeDataSets;
	rnaFragmentSizeDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@rnaFragmentSizeDataSets;
	
	(*now, let's resolve the primary and secondary data at the same time - the goal is to have data plotted from EITHER the primary and secondary data thats available. we can only plot FL/UVAbs OR current/voltage because they have different X values *)
	resolvedPrimaryData = Which[
		MatchQ[Lookup[listedOptions,PrimaryData,Null],(Electropherogram|DNAFragmentSizeAnalyses|RNAFragmentSizeAnalyses)],
		PrimaryData->Lookup[listedOptions,PrimaryData],
		
		MatchQ[rnaFragmentSizeDataQ,{True..}],
		PrimaryData->RNAFragmentSizeAnalyses,
		
		MatchQ[dnaFragmentSizeDataQ,{True..}],
		PrimaryData->DNAFragmentSizeAnalyses,
		
		True,
		PrimaryData->Electropherogram
	];
	
	(* -- PREPARE OUTPUT -- *)
	
	(* to make things cleaner, we will no present object ID as the plot label when there are two or more object or when plotting raw data*)
	plotLabel=If[MatchQ[Lookup[listedOptions, PlotLabel, Automatic], Automatic],
		If[Length[dataObjects]>1, Null, Style[ToString[First[dataObjects][Object]],"Text"]],
		Lookup[listedOptions, PlotLabel,Null]
	];
	
	(* Add a frame label when RMT is plotted *)
	resolvedFrameLabel=Which[
		MatchQ[resolvedPrimaryData,Rule[PrimaryData,RNAFragmentSizeAnalyses]],
		FrameLabel->Lookup[safeOptions,FrameLabel]/.{Automatic->{"Fragment Size (Nucleotide)","RFU"}},
		
		MatchQ[resolvedPrimaryData,Rule[PrimaryData,DNAFragmentSizeAnalyses]],
		FrameLabel->Lookup[safeOptions,FrameLabel]/.{Automatic->{"Fragment Size (BasePair)","RFU"}},
		
		True,
		FrameLabel->Lookup[safeOptions,FrameLabel]/.{Automatic->{"Time (Second)","RFU"}}
	];
	(* the x-coordinate (position) on the graphic that inset image is positioned on and the width of the inset image is calculated based on the peaks of the electropherogram *)
	positionWidthTuple = If[MatchQ[resolvedPrimaryData,PrimaryData->Electropherogram],
		MapThread[
			Function[{electropherogramData,analyteType},
				Module[{peakAnalysis,peaks,xmin,xmax,width},
					
					peakAnalysis = ECL`AnalyzePeaks[electropherogramData,Upload->False];
					
					(* identify the peaks *)
					peaks = Lookup[peakAnalysis,Replace[Position],{}];
					
					(* the position of the left edge of the inset image is 200 pixels to the left of the first peak *)
					xmin = If[MatchQ[peaks,Except[{}]],
						peaks[[1]]-200.,
						Null
					];
					
					(* For DNA methods, there is a upper maker (highest peak) and the right edge of the inset image is peak + 100 *)
					(* For RNA methods, there is no upper maker and the right edge of the inset image is first peak + 750 (entire separation window) *)
					(* the position of the right edge of the inset image is 200 pixels to the left of the first peak *)
					xmax = Which[
						MatchQ[analyteType,DNA]&&MatchQ[peaks,Except[{}]],
						peaks[[-1]]+100.,
						
						MatchQ[peaks,Except[{}]],
						peaks[[1]]+750,
						
						True,
						Null
					];
					
					width=If[MatchQ[xmax-xmin,_Real],
						xmax-xmin,
						Automatic
					];
					
					{xmin,width}
				]
			],
			{
				electropherogramDataSets,
				Lookup[allDownload,SampleAnalyteType]
			}
		],
		dataObjects/.ObjectP[]-> {Automatic,Automatic}
	];
	
	xPosition = positionWidthTuple[[All,1]];
	
	(* Force output of Result and Options *)
	resolvedOpsWithOutput=ReplaceRule[listedOptions,
		{
			resolvedPrimaryData,
			resolvedFrameLabel,
			PlotLabel->plotLabel,
			InsetImageSizeX->positionWidthTuple[[All,2]],
			InsetImageSizeY->30., (* height of the gel image is set to 30 *)
			InsetImagePositionX->xPosition,
			InsetImagePositionY->0., (* the y-coordinate at 0 of the inset image is used to orient the inset image on the graphic *)
			Output->{Result, Options}
		}
	];
	
	(* Call EmeraldListLinePlot with these resolved options, forcing Output\[Rule]{Result,Options}. *)
	ellpResult=packetToELLP[packets,PlotFragmentAnalysis,resolvedOpsWithOutput];
	
	(* If the result from ELLP was Null or $Failed, return $Failed. *)
	{result,options}=If[MatchQ[ellpResult,Null|$Failed],
		{$Failed,$Failed},
		(* Check to see if we're mapping. If so, then we have to Transpose our result. *)
		Module[{listLinePlot,listLinePlotOptions,fullOptions},
			{listLinePlot,listLinePlotOptions}=If[OptionValue[Map],
				Module[{transposedResult,plots,ellpOptions},
					transposedResult=Transpose[ellpResult];
					(* The plots are simply the first element in the list. *)
					plots=First[transposedResult];
					(* We are given back a list of options. (Options for each plot). We can't really return multiple so just pick the first. *)
					ellpOptions=transposedResult[[2]][[1]];
					{plots,ellpOptions}
				],
				(* There is no mapping going on. Don't transpose anything. *)
				If[Not[MatchQ[ellpResult,_List]],
					{ellpResult,{}},
					ellpResult
				]];
			
			(* Before we return, make sure that we include all of our safe options. *)
			(* Overwrite our SafeOptions with our resolved EmeraldListLinePlot options. *)
			
			(* Return packetToELLP output, adding any missing options *)
			fullOptions=Normal[Join[Association[safeOptions],Association[resolvedPrimaryData], Association[listLinePlotOptions]]];
			
			(* Return our result and options. *)
			{listLinePlot,fullOptions}
		]
	];
	
	(* Return the requested outputs *)
	outputSpecification/.{
		Result->result,
		Options->options,
		Preview->result,
		Tests->{}
	}
];
(*rawToPacket[primaryData,Object[Data,PlotFragmentAnalysis],PlotFragmentAnalysis,SafeOptions[PlotFragmentAnalysis, ToList[inputOptions]]];*)
(* PlotFragmentAnalysis[infs:plotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:=
PlotFragmentAnalysis[infs:plotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:=Quiet[packetToELLP[infs,PlotFragmentAnalysis,ToList[inputOptions]],CompiledFunction::cfnlts];
*)