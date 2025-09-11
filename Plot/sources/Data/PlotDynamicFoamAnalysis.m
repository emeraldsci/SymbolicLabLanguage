(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicFoamAnalysis*)

DefineOptions[PlotDynamicFoamAnalysis,
	Options:>{
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"Indicates which type(s) of the dynamic foam analysis data are being plotted.",
			AllowNull->False,
			Widget -> Alternatives[
				"Single Type"->Widget[Type->Enumeration, Pattern:>DynamicFoamAnalysisPlotTypeP],
				"Multiple Types"->Adder[
					Widget[Type->Enumeration, Pattern:>DynamicFoamAnalysisPlotTypeP]
				]
			],
			Category->"Data Specifications"
		}
	},
	SharedOptions:>{
		EmeraldListLinePlot
	}
];

(* specific error messages *)
Error::NoDataForPlotDynamicFoamAnalysisPlotType="The requested plot type `1` requires data which is not included in the input DynamicFoamAnalysis data object.";
Error::NoDynamicFoamAnalysisDataToPlot = "The protocol object does not contain any associated dynamic foam analysis data.";
Error::DynamicFoamAnalysisProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotDynamicFoamAnalysis or PlotObject on an individual data object to identify the missing values.";

(* Protocol Overload *)
PlotDynamicFoamAnalysis[
	obj: ObjectP[Object[Protocol, DynamicFoamAnalysis]],
	ops: OptionsPattern[PlotDynamicFoamAnalysis]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDynamicFoamAnalysis, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, DynamicFoamAnalysis]]..}],
		Message[Error::NoDynamicFoamAnalysisDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotDynamicFoamAnalysis[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotDynamicFoamAnalysis[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::DynamicFoamAnalysisProtocolDataNotPlotted];
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
PlotDynamicFoamAnalysis[input:ObjectP[Object[Data,DynamicFoamAnalysis]],inputOptions:OptionsPattern[]]:=Module[
	{
		listedInput,download,sampleName,finalPlots,mostlyResolvedOps,resolvedOps,finalResolvedOps,output,originalOps,safeOps,plotOptions,detectionMethod,plotDataPerType,plotOptionsPerType,plotResults,
		foamHeightData,foamVolumeData,bubbleCountData,meanBubbleAreaData,averageBubbleRadiusData,plotType,resolvedPlotType,heightData,imagingData,liquidConductivityData,plotsPerType,resolvedOpsPerType
	},

	(* Convert the original options into a list *)
	originalOps=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDynamicFoamAnalysis,ToList[inputOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Listify the input *)
	listedInput=ToList[input];

	(* --- perform our download to get all of the data we need --- *)
	download=Download[listedInput];

	(* grab the data for each method *)
	heightData={
		Lookup[download,FoamHeight],
		Lookup[download,LiquidHeight],
		Lookup[download,TotalFoamLiquidHeight],
		Lookup[download,FoamVolume],
		Lookup[download,LiquidVolume],
		Lookup[download,TotalFoamLiquidVolume],
		Lookup[download,FoamVolumeStability],
		Lookup[download,FoamLiquidStability],
		Lookup[download,FoamTemperature]
	};

	imagingData={
		Lookup[download,BubbleCount],
		Lookup[download,MeanBubbleArea],
		Lookup[download,StandardDeviationBubbleArea],
		Lookup[download,AverageBubbleRadius],
		Lookup[download,MeanSquareBubbleRadius],
		Lookup[download,BubbleSauterMeanRadius]
	};

	liquidConductivityData={
		Lookup[download,LiquidContentSensor1],
		Lookup[download,LiquidContentSensor2],
		Lookup[download,LiquidContentSensor3],
		Lookup[download,LiquidContentSensor4],
		Lookup[download,LiquidContentSensor5],
		Lookup[download,LiquidContentSensor6],
		Lookup[download,LiquidContentSensor7]
	};

	(* --- Resolve plotType and Plot options --- *)
	(* look up user specified plot type *)
	plotType=ToList[Lookup[safeOps,PlotType]];

	(* look up detection method *)
	detectionMethod=Sequence@@Lookup[download,DetectionMethod];

	(* look up sample name *)
	sampleName=ECL`InternalUpload`ObjectToString[Sequence@@Lookup[download,SamplesIn]];

	(* resolve plot type*)
	resolvedPlotType=If[MatchQ[plotType,Except[{Automatic}]],
		(* if the user specified a plot type, keep that one *)
		plotType,

		(* otherwise, resolved based on what detection methods were used *)
		Module[{newPlotType},
			(* since height method is always used, we start with foam height and foam volume *)
			newPlotType={FoamHeight,FoamVolume};

			If[MemberQ[detectionMethod,ImagingMethod],
				newPlotType=Flatten@Append[newPlotType,{BubbleCount,MeanBubbleArea,AverageBubbleRadius}]
			];

			If[MemberQ[detectionMethod,LiquidConductivityMethod],
				newPlotType=Flatten@Append[newPlotType,{LiquidContent}]
			];

			newPlotType
		]
	];

	(* pull out the plot options to pass directly to EmeraldListLinePlot *)
	plotOptions=KeyDrop[safeOps,{PlotType}];

	(* --- Error checking to make sure we can plot the appropriate plot types --- *)
	If[
		(* If PlotType is set to an ImagingMethod-related plot and we do not have the data *)
		MemberQ[resolvedPlotType,Alternatives[BubbleCount,MeanBubbleArea,AverageBubbleRadius]]&&MatchQ[imagingData,({}|{{Null ..} ..})],
		Message[Error::NoDataForPlotDynamicFoamAnalysisPlotType,resolvedPlotType];
		Return[$Failed]
	];

		(* If PlotType is set to LiquidConductivityMethod and we do not have the data *)
	If[MemberQ[resolvedPlotType,LiquidContent]&&MatchQ[liquidConductivityData,({}|{{Null}..})],
		Message[Error::NoDataForPlotDynamicFoamAnalysisPlotType,resolvedPlotType];
		Return[$Failed]
	];

	(* --- split resolved plot data into separate data for each plot type --- *)
	(* Foam height*)
	foamHeightData=Take[heightData,3];

	(* foam volume *)
	foamVolumeData=Take[heightData,{4,6}];

	(* bubble count *)
	bubbleCountData=imagingData[[1]];

	(* mean bubble area *)
	meanBubbleAreaData=imagingData[[2]];

	(* average bubble radius *)
	averageBubbleRadiusData=imagingData[[4]];

	(* gather the plot data we need for each given plot type requested*)
	plotDataPerType=Map[
		Switch[#,
			FoamHeight,
			foamHeightData,

			FoamVolume,
			foamVolumeData,

			BubbleCount,
			bubbleCountData,

			MeanBubbleArea,
			meanBubbleAreaData,

			AverageBubbleRadius,
			averageBubbleRadiusData,

			LiquidContent,
			liquidConductivityData
	]&,resolvedPlotType];

	(* Resolve your own custom plot options (labels, epilogs etc.) for each plot type. *)
	(* PassOptions[] and ReplaceRule[] are usually helpful here, e.g. to pass options to EmeraldListLinePlot *)
	plotOptionsPerType=Map[
		Which[
			MatchQ[#,FoamHeight],
			Module[{heightLegends,heightTitle,heightLabel},
				(* generate the legends *)
				heightLegends={"Foam","Liquid","Total Foam+Liquid"};

				(* generate a title *)
				heightTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Height Method: Height Plot"}];

				(* generate a label *)
				heightLabel={Automatic,"Height"};

				(* return a list of rules with the new options*)
				{Legend->heightLegends,PlotLabel->Style[heightTitle,12],FrameLabel->heightLabel}
			],

			MatchQ[#,FoamVolume],
			Module[{volumeLegends,volumeTitle},
				(* generate the legends *)
				volumeLegends={"Foam","Liquid","Total Foam+Liquid"};

				(* generate a title *)
				volumeTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Height Method: Volume Plot"}];

				(* return a list of rules with the new options*)
				{Legend->volumeLegends,PlotLabel->Style[volumeTitle,12]}
			],

			MatchQ[#,BubbleCount],
			Module[{bubbleCountTitle,bubbleCountLabel},
				(* generate a title *)
				bubbleCountTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Imaging Method: Bubble Count Plot"}];

				(* generate a label *)
				bubbleCountLabel={Automatic,"Bubble Count Per Area"};

				(* return a list of rules with the new options*)
				{PlotLabel->Style[bubbleCountTitle,12],FrameLabel->bubbleCountLabel}
			],

			MatchQ[#,MeanBubbleArea],
			Module[{bubbleAreaTitle},
				(* generate a title *)
				bubbleAreaTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Imaging Method: Bubble Area Plot"}];

				(* return a list of rules with the new options*)
				{PlotLabel->Style[bubbleAreaTitle,12]}
			],

			MatchQ[#,AverageBubbleRadius],
			Module[{averageBubbleRadiusTitle,averageBubbleRadiusLabel},
				(* generate a title *)
				averageBubbleRadiusTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Imaging Method: Average Bubble Radius Plot"}];

				(* generate a label *)
				averageBubbleRadiusLabel={Automatic,"Radius"};

				(* return a list of rules with the new options*)
				{PlotLabel->Style[averageBubbleRadiusTitle,12],FrameLabel->averageBubbleRadiusLabel}
			],

			MatchQ[#,LiquidContent],
			Module[{liquidContentLegends,liquidContentTitle,liquidContentLabel},
				(* generate the legends *)
				liquidContentLegends={"Sensor 1","Sensor 2","Sensor 3","Sensor 4","Sensor 5","Sensor 6","Sensor 7"};

				(* generate a title *)
				liquidContentTitle=StringJoin[{"SamplesIn: ",sampleName,"\n","Liquid Conductivity Method: Liquid Content Plot"}];

				(* generate a label *)
				liquidContentLabel={Automatic,"Liquid Content"};

				(* return a list of rules with the new options*)
				{Legend->liquidContentLegends,PlotLabel->Style[liquidContentTitle,12],FrameLabel->liquidContentLabel}
			]
		]&,
		resolvedPlotType
	];

	(*********************************)

	(* Call EmeraldListLinePlot (or another function) to get options and results for each plot *)
	(* Returns a mapping of {(TypeOption\[Rule]{plot,ops})..} *)
	plotResults=MapThread[
		#1->EmeraldListLinePlot[#2,ReplaceRule[Normal[plotOptions],Join[#3,{Output->{Result,Options}}]]]&,
		{resolvedPlotType,plotDataPerType,plotOptionsPerType}
	];

	(* Extract plots and options from each *)
	{plotsPerType,resolvedOpsPerType}=Transpose@(Last/@plotResults);

	(* Generate the final plot *)
	finalPlots=If[Length[resolvedPlotType]==1,
		First[plotsPerType],
		TabView[plotResults/.{Rule[a_,b_]:>Rule[a,First[b]]}]
	];

	(* Resolved plot options from the first plot type *)
	mostlyResolvedOps=First[resolvedOpsPerType];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps,Append->False];

	(* Any special resolutions specific to your plot (which are not covered by underlying plot function) *)
	finalResolvedOps=ReplaceRule[resolvedOps,PlotType->resolvedPlotType];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlots,
		Options->finalResolvedOps,
		Preview->SlideView[Flatten[{finalPlots}],ImageSize->Full],
		Tests->{}
	}
];

PlotDynamicFoamAnalysis[myData:{ObjectP[Object[Data, DynamicFoamAnalysis]]...},ops:OptionsPattern[]]:=Module[

	{plotLabels,plots,names,returnedPlotOps,mergedReturnedOps,originalOps,safeOps,output,resolvedOps},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotDynamicFoamAnalysis,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Names associated with the data packets *)
	names=First[#[Append[Reference]][Name]]&/@myData;

	(* The label based on the name of the object. If singlet, no label is used *)
	plotLabels=If[Length[plots] === 1,
		Automatic,
		If[MatchQ[#,Null|{}|Name]||MissingQ[#],Automatic,#]&/@names
	];

	(* Place all figures into a slide show *)
	{plots,returnedPlotOps}=Transpose[
		MapIndexed[
			PlotDynamicFoamAnalysis[#1,Sequence@@ReplaceRule[safeOps,{PlotLabel->plotLabels[[First[#2]]],Output->{Result,Options}}]]&,
			myData
		]
	];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[safeOps,
		Prepend[mergedReturnedOps,
			{
				Output->output,
				Epilog->Lookup[safeOps,Epilog],
				Prolog->Lookup[safeOps,Prolog]
			}
		]
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result-> (If[Length[plots] === 1, Zoomable@First[plots], SlideView[Zoomable@plots]]),
		Preview->(If[Length[plots] === 1, Zoomable@First[plots], SlideView[Zoomable@plots]]),
		Tests->{},
		Options->resolvedOps
	}

];