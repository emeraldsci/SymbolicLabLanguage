(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryGelElectrophoresisSDS*)


DefineOptions[PlotCapillaryGelElectrophoresisSDS,
	Options:>{
		{
			OptionName -> PrimaryData,
			Default -> Automatic,
			Description -> "The data to be plotted. This applies to all data objects plotted. To include data in a different unit in this plot, use the SecondaryData option.",
			AllowNull -> False,
			Category -> "CapillaryGelElectrophoresisSDS",
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>Alternatives[ProcessedUVAbsorbanceData|RelativeMigrationData|CurrentData|VoltageData]
			]
		},
		{
			OptionName -> SecondaryData,
			Default -> Automatic,
			Description -> "The additional data to be plotted. This applies to all data objects plotted. These data must have the same unit for the x-axis as the Primary data.",
			AllowNull -> True,
			Category -> "CapillaryGelElectrophoresisSDS",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[ProcessedUVAbsorbanceData|RelativeMigrationData|CurrentData|VoltageData]]
			]
		},
		{
			OptionName -> ProcessedUVAbsorbanceData,
			Default -> Null,
			Description -> "The UV absorbance trace as a factor of distance in the capillary to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> VoltageData,
			Default -> Null,
			Description -> "The voltage trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		},
		{
			OptionName -> CurrentData,
			Default -> Null,
			Description -> "The current trace to display on the plot.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> _?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size -> Paragraph
			]
		}
	},
	SharedOptions :> {
		ZoomableOption,
		PlotLabelOption,
		UnitsOption,
		MapOption,
		EmeraldListLinePlot
	}
];

(* Messages *)
Warning::RelativeMigrationDataUnavailable="No RelativeMigrationData was found for inputs `1`. Please run AnalyzePeaks on these inputs and use the ParentPeaks option to specify the internal standard peak which should be used as a reference for RMT.";
Error::NoCapillaryGelElectrophoresisSDSDataToPlot = "The protocol object does not contain any associated capillary gel electrophoresis data.";
Error::CapillaryGelElectrophoresisSDSProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotCapillaryGelElectrophoresisSDS or PlotObject on an individual data object to identify the missing values.";


(* Raw Definition *)
PlotCapillaryGelElectrophoresisSDS[primaryData:rawPlotInputP,inputOptions:OptionsPattern[]]:=Module[{outputs},
	outputs = rawToPacket[
		primaryData,
		Object[Data,CapillaryGelElectrophoresisSDS],
		PlotCapillaryGelElectrophoresisSDS,
		(*we need to check if the primary data was specified, if not then we need to figure out what kind of data is present instead of just assuming absorbance*)
		Module[{safeOptions,primaryDataOption},
			safeOptions=SafeOptions[PlotCapillaryGelElectrophoresisSDS, ToList[inputOptions]];
			(*is the primary data still automatic?*)
			primaryDataOption=Lookup[safeOptions,PrimaryData];
			(*if so try to figure out what should be plotted, otherwise leave as is*)
			If[MatchQ[primaryDataOption,Automatic],
				(* see the units of the primary data*)
				Switch[primaryData,
					(*if they are in Absorbance Unit as would be expected of UVAbsorbance data, *)
					_?(UnitCoordinatesQ[#1, {Second, AbsorbanceUnit}] &) | {_?(UnitCoordinatesQ[#1, {Second, AbsorbanceUnit}] &) ..} | {{_?(UnitCoordinatesQ[#1, {Second, AbsorbanceUnit}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->ProcessedUVAbsorbanceData],
					(*if they are in Milliampere as would be expected of Current data *)
					_?(UnitCoordinatesQ[#1, {Second,Milliampere}] &) | {_?(UnitCoordinatesQ[#1, {Second,Milliampere}] &) ..} | {{_?(UnitCoordinatesQ[#1, {Second,Milliampere}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->CurrentData],
					(*if they are in Volt as would be expected of Voltage data *)
					_?(UnitCoordinatesQ[#1, {Second,Volt}] &) | {_?(UnitCoordinatesQ[#1, {Second,Volt}] &) ..} | {{_?(UnitCoordinatesQ[#1, {Second,Volt}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->VoltageData],
					(* otherwise safely assume absorbance *)
					_,ReplaceRule[safeOptions,PrimaryData->ProcessedUVAbsorbanceData]
				],
				(* and if not automatic just go with whatever the specification was *)
				safeOptions
			]
		]];

	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[outputs,SafeOptions[PlotCapillaryGelElectrophoresisSDS,ToList@inputOptions]]
];

(* Protocol Overload *)
PlotCapillaryGelElectrophoresisSDS[
	obj: ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]],
	ops: OptionsPattern[PlotCapillaryGelElectrophoresisSDS]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCapillaryGelElectrophoresisSDS, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, CapillaryGelElectrophoresisSDS]]..}],
		Message[Error::NoCapillaryGelElectrophoresisSDSDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotCapillaryGelElectrophoresisSDS[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotCapillaryGelElectrophoresisSDS[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::CapillaryGelElectrophoresisSDSProtocolDataNotPlotted];
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
PlotCapillaryGelElectrophoresisSDS[infs:ListableP[ObjectP[Object[Data,CapillaryGelElectrophoresisSDS]]],inputOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,gatherTests,dataObjects,listedOptions,outputOptions,output, safeOptions,safeOptionTests,
		requestedPrimaryData,requestedSecondaryData ,primaryDataFields,secondaryDataFields, allDownload, packets,uvAbsTraces,
		currentTraces,voltageTraces,relativeTraces,uvAbsDataQ,currentDataQ,voltageDataQ,rawDataQ,relativeDataQ,
		resolvedPrimaryData,resolvedSecondaryData,resolvedFrameLabel,resolvedPeaks,
		plotLabel,resolvedOpsWithOutput,ellpResult,result,options,newestPks
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
		SafeOptions[PlotCapillaryGelElectrophoresisSDS,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[PlotCapillaryGelElectrophoresisSDS,listedOptions,AutoCorrect->False],Null}
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
	requestedSecondaryData = OptionDefault[OptionValue[SecondaryData]]/. Null:>{};

	(* download things we might need *)
	{allDownload,newestPks} = Transpose@Quiet[
		Download[
			dataObjects,
			{
				Packet[ProcessedUVAbsorbanceData, CurrentData, VoltageData, RelativeMigrationData],
				Packet[PeaksAnalyses[[-1]][All]]
			}
		],
		{Download::MissingField,Download::Part}
	];

	(* Assign each type of data to its own variable or grab it from options if we got raw data - I am confident
	there's a better way of doing this and I'm probably missing something, but hey - this should work too..*)
	uvAbsTraces = If[MatchQ[ToList@Lookup[allDownload, ProcessedUVAbsorbanceData], {$Failed..}],
		Lookup[listedOptions, ProcessedUVAbsorbanceData]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, ProcessedUVAbsorbanceData]
	];

	currentTraces = If[MatchQ[ToList@Lookup[allDownload, CurrentData], {$Failed..}],
		Lookup[listedOptions, CurrentData]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, CurrentData]
	];

	voltageTraces = If[MatchQ[ToList@Lookup[allDownload, VoltageData], {$Failed..}],
		Lookup[listedOptions, VoltageData]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, VoltageData]
	];

	relativeTraces = If[MatchQ[ToList@Lookup[allDownload, RelativeMigrationData], {$Failed..}],
		Lookup[listedOptions, RelativeMigrationData]/. Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload, RelativeMigrationData]
	];

	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets = If[MatchQ[Lookup[allDownload,Object],{$Failed..}],
		KeyDrop[allDownload,Object],
		allDownload
	];

	(* -- ERROR CHECK AND OPTION RESOLUTION -- *)

	(* Check what data data was collected/passed (The user can only control whether or not to collect FL data,
	but if raw data is passed, we need to avoid trying data that's not there *)
	uvAbsDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@uvAbsTraces;
	currentDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@currentTraces;
	voltageDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@voltageTraces;
	relativeDataQ = !MatchQ[#, {{}..}|{}|Null|$Failed]&/@relativeTraces;
	rawDataQ = !(And@@uvAbsDataQ&&And@@currentDataQ&&And@@voltageDataQ);

	(* Special error handling if we request RMT before peaks analysis has been done *)
	If[MatchQ[requestedPrimaryData,RelativeMigrationData]&&!(And@@relativeDataQ),
		Message[Warning::RelativeMigrationDataUnavailable,Part[Download[ToList[infs],Object],First/@Position[relativeDataQ,False,1]]];
		If[MatchQ[relativeDataQ,{False..}],
			Return[outputSpecification/.{
				Result -> $Failed,
				Tests -> safeOptionTests,
				Options -> $Failed,
				Preview -> Null
			}]
		]
	];

	(* lets resolve the data we'd want to present - for primary data, we would present FL data if present, or UVAbs data if not.
	We always default to the longest exposure. If multiple exposures are specified by the user, we will make multiple data traces
	as primary for them rather than on the same plot as primary and secondary.*)
	primaryDataFields = {ProcessedUVAbsorbanceData};
	secondaryDataFields = {CurrentData, VoltageData};

	(*now, let's resolve the primary and secondary data at the same time - the goal is to have data plotted from EITHER the primary and secondary data thats available. we can only plot FL/UVAbs OR current/voltage because they have different X values *)
	{resolvedPrimaryData,resolvedSecondaryData}=
		Switch[{requestedPrimaryData, requestedSecondaryData},
			(*check to see if both are specified, in which case our job is easy*)
			{Except[Automatic],Except[Automatic]},
			{
				PrimaryData->requestedPrimaryData,
				SecondaryData->requestedSecondaryData
			},
			(* If RMT is plotted, disable secondary data because the x-axis units will be different *)
			{RelativeMigrationData,Automatic},
			{
				PrimaryData->RelativeMigrationData,
				SecondaryData->{}
			},
			(*check if the primary is chosen, then we'll suggest*)
			{Except[Automatic],Automatic},
			{
				PrimaryData->requestedPrimaryData,
				(* this case needs to cover raw data as well so we need to be prepared for a case in which the data is not available *)
				SecondaryData->Module[{field},
					field= If[MemberQ[primaryDataFields,requestedPrimaryData]||!MemberQ[primaryDataFields,requestedPrimaryData]&&!MemberQ[secondaryDataFields,requestedPrimaryData],
						First@Complement[secondaryDataFields,ToList[requestedPrimaryData]],
						First@Complement[primaryDataFields,ToList[requestedPrimaryData]]
					];
					(* account for raw data *)
					If[MatchQ[Lookup[allDownload, field], {$Failed..}],
						{},
						field
					]
				]
			},
			(*the weird case of the secondary selected but not the primary*)
			{Automatic,Except[Automatic]},
			{
				PrimaryData->Module[{field},
					field= If[MemberQ[primaryDataFields,requestedSecondaryData]||!MemberQ[primaryDataFields,requestedSecondaryData]&&!MemberQ[secondaryDataFields,requestedSecondaryData],
						First@Complement[secondaryDataFields,ToList[requestedSecondaryData]],
						First@Complement[primaryDataFields,ToList[requestedSecondaryData]]
					];
					(* account for raw data *)
					If[MatchQ[Lookup[allDownload, field], {$Failed..}],
						{},
						field
					]
				],
				SecondaryData->requestedSecondaryData
			},
			(*if neither then stick with the best options*)
			{Automatic,Automatic},
			{
				PrimaryData->First[primaryDataFields],
				SecondaryData->First[secondaryDataFields]
			}
		];

	(* -- PREPARE OUTPUT -- *)

	(* to make things cleaner, we will no present object ID as the plot label when there are two or more object or when plotting raw data*)
	plotLabel=If[MatchQ[Lookup[listedOptions, PlotLabel, Automatic], Automatic]&&!rawDataQ,
		If[Length[dataObjects]>1, Null, ToString[First[dataObjects]]],
		Lookup[listedOptions, PlotLabel]
	];

	(* Add a frame label when RMT is plotted *)
	resolvedFrameLabel=If[MatchQ[resolvedPrimaryData,Rule[PrimaryData,RelativeMigrationData]],
		FrameLabel->Lookup[safeOptions,FrameLabel]/.{Automatic->{"Relative Migration Time","Absorbance (AU)"}},
		Nothing
	];

	(* Grab the most recent peaks analysis when available *)
	resolvedPeaks=If[MatchQ[resolvedPrimaryData,Rule[PrimaryData,ProcessedUVAbsorbanceData]],
		Peaks->Lookup[safeOptions,Peaks]/.{Automatic|Null->newestPks/.{$Failed->Null}},
		Peaks->Lookup[safeOptions,Peaks]
	];

	(* Force output of Result and Options *)
	resolvedOpsWithOutput=ReplaceRule[listedOptions,
		{
			resolvedPrimaryData,
			resolvedSecondaryData,
			resolvedFrameLabel,
			resolvedPeaks,
			PlotLabel->plotLabel,
			Output->{Result, Options}
		}
	];

	(* Call EmeraldListLinePlot with these resolved options, forcing Output\[Rule]{Result,Options}. *)
	ellpResult=packetToELLP[packets,PlotCapillaryGelElectrophoresisSDS,resolvedOpsWithOutput];

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
			fullOptions=Normal[Join[Association[safeOptions],Association[resolvedPrimaryData], Association[resolvedSecondaryData],Association[listLinePlotOptions]]];

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
