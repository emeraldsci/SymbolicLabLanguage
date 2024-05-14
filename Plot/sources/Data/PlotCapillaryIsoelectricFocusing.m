(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCapillaryIsoelectricFocusing*)


DefineOptions[PlotCapillaryIsoelectricFocusing,
	Options:>{
		IndexMatching[
			{
				OptionName->FluorescenceExposureTime,
				Default->Automatic,
				Description->"Indicates the exposure times for which to plot data.",
				ResolutionDescription->"When Automatic, and if PrimaryData or SecondaryData are NativeFluorescnece, resolves to plot the longest exposure data was collected in. If no data was collected by Native Fluorescence, resolves to Null",
				AllowNull->True,
				Category->"CapillaryIsoelectricFocusing",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}]]
				]
			},
			IndexMatchingInput->"dataObject"
		],
		{
			OptionName->PrimaryData,
			Default->Automatic,
			Description->"The data to be plotted. This applies to all data objects plotted. To include data in a different unit in this plot, use the SecondaryData option.",
			ResolutionDescription->"By default, NativeFluorescence data, if collected, will be plotted. Otherwise, UVAbsorbance data will be plotted.",
			AllowNull->False,
			Category->"CapillaryIsoelectricFocusing",
			Widget->Alternatives[
				Widget[Type->Enumeration,
					Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration,
					Pattern:>Alternatives[ProcessedFluorescenceData|ProcessedUVAbsorbanceData|CurrentData|VoltageData]]
			]
		},
		{
			OptionName->SecondaryData,
			Default->Automatic,
			Description->"The additional data to be plotted. This applies to all data objects plotted. These data must have the same unit for the x-axis as the Primary data.",
			ResolutionDescription->"By default, secondary data will be resolved to null if the primary data is either Fluorescence or UVAbsorbance, and to either Current or Voltage, depending on which is set for Primary data.",
			AllowNull->True,
			Category->"CapillaryIsoelectricFocusing",
			Widget->Alternatives[
				Widget[Type->Enumeration,
					Pattern:>Alternatives[Automatic,Null,{}]],
				Widget[Type->Enumeration,
					Pattern:>Alternatives[ProcessedFluorescenceData|ProcessedUVAbsorbanceData|CurrentData|VoltageData]]
			]
		},
		{
			OptionName->ProcessedUVAbsorbanceData,
			Default->Null,
			Description->"The UV absorbance trace as a factor of distance in the capillary to display on the plot.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Expression,
				Pattern:>_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({_?NumericQ,{{_?NumericQ,_?NumericQ}..}}|{{_?NumericQ,{{_?NumericQ,_?NumericQ}..}}..}|{{{_?NumericQ,{{_?NumericQ,_?NumericQ}..}}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size->Paragraph
			]
		},
		{
			OptionName->ProcessedFluorescenceData,
			Default->Null,
			Description->"The Native Fluorescence trace as a factor of distance in the capillary to display on the plot.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Expression,
				Pattern:>_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({_?NumericQ,{{_?NumericQ,_?NumericQ}..}}|{{_?NumericQ,{{_?NumericQ,_?NumericQ}..}}..}|{{{_?NumericQ,{{_?NumericQ,_?NumericQ}..}}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size->Paragraph
			]
		},
		{
			OptionName->VoltageData,
			Default->Null,
			Description->"The voltage trace to display on the plot.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Expression,
				Pattern:>_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size->Paragraph
			]
		},
		{
			OptionName->CurrentData,
			Default->Null,
			Description->"The current trace to display on the plot.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[
				Type->Expression,
				Pattern:>_?(MatchQ[Flatten[ToList[#1]],{Null..}]&)|(({{_?NumericQ,_?NumericQ}..}|{{{_?NumericQ,_?NumericQ}..}..}|{{{{_?NumericQ,_?NumericQ}..}..}..})|(QuantityArrayP[]|{QuantityArrayP[]..}|{{QuantityArrayP[]..}..})),
				Size->Paragraph
			]
		}
	},
	SharedOptions:>{
		ZoomableOption,
		PlotLabelOption,
		UnitsOption,
		MapOption,
		EmeraldListLinePlot
	}
];

(* cief specific messages *)
Warning::InvalidFluorescneceExposureTime="The data packet (`1`) does not contain data collected at the specified FluorescenceExposureTime. Data is present for the following exposures `2`. Defaulting to plot data at the longest exposure present (`3`).";

(* Raw Definition *)
PlotCapillaryIsoelectricFocusing[primaryData:rawPlotInputP,inputOptions:OptionsPattern[]]:=Module[{outputs},
	outputs=rawToPacket[
		primaryData,
		Object[Data,CapillaryIsoelectricFocusing],
		PlotCapillaryIsoelectricFocusing,
		(*we need to check if the primary data was specified, if not then we need to figure out what kind of data is present instead of just assuming absorbance*)
		Module[{safeOptions,primaryDataOption},
			safeOptions=SafeOptions[PlotCapillaryIsoelectricFocusing,ToList[inputOptions]];
			(*is the primary data still automatic?*)
			primaryDataOption=Lookup[safeOptions,PrimaryData];
			(*if so try to figure out what should be plotted, otherwise leave as is*)
			If[MatchQ[primaryDataOption,Automatic],
				(* see the units of the primary data*)
				Switch[primaryData,
					(*if they are in Absorbance Unit as would be expected of UVAbsorbance data, *)
					_?(UnitCoordinatesQ[#1,{Pixel,MilliAbsorbanceUnit}] &)|{_?(UnitCoordinatesQ[#1,{Pixel,MilliAbsorbanceUnit}] &) ..}|{{_?(UnitCoordinatesQ[#1,{Pixel,MilliAbsorbanceUnit}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->ProcessedUVAbsorbanceData],
					(*if they are in RFU as would be expected of nativeFluorescence data. Remember that the format is {exposure time, {{pixel, rfu}..}} *)
					_?(UnitCoordinatesQ[#1,{Pixel,RFU}] &)|{_?(UnitCoordinatesQ[#1,{Pixel,RFU}] &) ..}|{{_?(UnitCoordinatesQ[#1,{Pixel,RFU}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->ProcessedFluorescenceData],
					(*if they are in Milliampere as would be expected of Current data *)
					_?(UnitCoordinatesQ[#1,{Second,Milliampere}] &)|{_?(UnitCoordinatesQ[#1,{Second,Milliampere}] &) ..}|{{_?(UnitCoordinatesQ[#1,{Second,Milliampere}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->CurrentData],
					(*if they are in Volt as would be expected of Voltage data *)
					_?(UnitCoordinatesQ[#1,{Second,Volt}] &)|{_?(UnitCoordinatesQ[#1,{Second,Volt}] &) ..}|{{_?(UnitCoordinatesQ[#1,{Second,Volt}] &) ..} ..},
					ReplaceRule[safeOptions,PrimaryData->VoltageData],
					(* otherwise safely assume absorbance *)
					_,ReplaceRule[safeOptions,PrimaryData->ProcessedUVAbsorbanceData]
				],
				(* and if not automatic just go with whatever the specification was *)
				safeOptions
			]
		]];

	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[outputs,SafeOptions[PlotCapillaryIsoelectricFocusing,ToList@inputOptions]]
];

(* Packet Definition *)
PlotCapillaryIsoelectricFocusing[infs:ListableP[ObjectP[Object[Data,CapillaryIsoelectricFocusing]]],inputOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,gatherTests,dataObjects,listedOptions,outputOptions,output,safeOptions,safeOptionTests,
		requestedPrimaryData,requestedSecondaryData ,exposureTimes,fluorescenceExposureTimes,allDownload,packets,
		flTraces,uvAbsTraces,currentTraces,voltageTraces,fluorescenceDataQ,uvAbsDataQ,currentDataQ,voltageDataQ,
		rawDataQ,flExposures,longestFlExposures,invalidExposures,resolvedFLExposure,primaryDataFields,secondaryDataFields,
		resolvedPrimaryData,resolvedSecondaryData,updatedPackets,resolvedLegend,optionLegend,finalLegend,imageSize,
		plotLabel,resolvedOpsWithOutput,ellpResult,result,options
	},

	(* -- DOWNLOAD AND OPTIONS LOOKUP -- *)

	(* make sure we're working with a list of objects *)
	dataObjects=ToList[infs];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[inputOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[OptionValue[Output]];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Determine if we should output the resolved options *)
	outputOptions=MemberQ[output,Options];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotCapillaryIsoelectricFocusing,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[PlotCapillaryIsoelectricFocusing,listedOptions,AutoCorrect->False],Null}
	];

	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Don't call safeOps since packetToELLP will distribute listed options *)
	requestedPrimaryData=OptionDefault[OptionValue[PrimaryData]];
	requestedSecondaryData=OptionDefault[OptionValue[SecondaryData]]/.Null:>{};
	exposureTimes=OptionDefault[OptionValue[FluorescenceExposureTime]];

	(* expand options *)
	(* get user specifies FL exposures to plot, make sure they are in the correct unit *)
	fluorescenceExposureTimes=Map[
		Function[specifiedExposure,If[MatchQ[specifiedExposure,Except[Automatic]],
			Map[N[UnitConvert[#,Second]]&,DeleteDuplicates[ToList[exposureTimes]]],
			Automatic
		]],
		(* if you need to expand the option (nested multiple again) do that before mapthreading *)
		If[Depth[exposureTimes]<4||!MatchQ[exposureTimes,{Automatic..}],
			ConstantArray[exposureTimes,Length[dataObjects]],
			exposureTimes
		]
	];

	(* download things we might need *)
	allDownload=Quiet[Download[
		dataObjects,
		Packet[ProcessedFluorescenceData,ProcessedUVAbsorbanceData,CurrentData,VoltageData]
	],Download::MissingField];

	(* Assign each type of data to its own variable or grab it from options if we got raw data - I am confident
	there's a better way of doing this and I'm probably missing something, but hey - this should work too..*)
	flTraces=If[MatchQ[ToList@Lookup[allDownload,ProcessedFluorescenceData],{$Failed..}],
		Lookup[listedOptions,ProcessedFluorescenceData]/.Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,ProcessedFluorescenceData]
	];

	uvAbsTraces=If[MatchQ[ToList@Lookup[allDownload,ProcessedUVAbsorbanceData],{$Failed..}],
		Lookup[listedOptions,ProcessedUVAbsorbanceData]/.Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,ProcessedUVAbsorbanceData]
	];

	currentTraces=If[MatchQ[ToList@Lookup[allDownload,CurrentData],{$Failed..}],
		Lookup[listedOptions,CurrentData]/.Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,CurrentData]
	];

	voltageTraces=If[MatchQ[ToList@Lookup[allDownload,VoltageData],{$Failed..}],
		Lookup[listedOptions,VoltageData]/.Null:>ConstantArray[$Failed,Length[dataObjects]],
		Lookup[allDownload,VoltageData]
	];


	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets=If[MatchQ[Lookup[allDownload,Object],{$Failed..}||{ObjectP[Object[Data, CapillaryIsoelectricFocusing, "id:packetplaceholder"]]..}],
		KeyDrop[allDownload,Object],
		allDownload
	];

	(* -- ERROR CHECK AND OPTION RESOLUTION -- *)

	(* Check what data data was collected/passed (The user can only control whether or not to collect FL data,
	but if raw data is passed, we need to avoid trying data that's not there *)
	fluorescenceDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@flTraces;
	uvAbsDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@uvAbsTraces;
	currentDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@currentTraces;
	voltageDataQ=!MatchQ[#,{{}..}|{}|Null|$Failed]&/@voltageTraces;

	rawDataQ=!(And@@uvAbsDataQ&&And@@currentDataQ&&And@@voltageDataQ);

	(* if we are handling raw data we might have FL data but nothing else, so we need to add a sham exposure time -
	once again, there's probably a better way to handle this, but this is what it is. *)
	flTraces=MapThread[If[#1&&!#2&&!#3&&!#4,
		{{Null,#5}},
		#5]&,
		{fluorescenceDataQ,uvAbsDataQ,currentDataQ,voltageDataQ,flTraces}
	];

	(* get FL exposure times present in the data (and make sure its all in seconds) *)
	flExposures=MapThread[Function[{dataAvailableQ,trace},
		If[dataAvailableQ,
			Map[If[!NullQ[#],UnitConvert[#,Second],Null]&,trace[[All,1]]],
			{}
		]],
		{fluorescenceDataQ,flTraces}
	];

	(* resolve the longest exposure present in the data *)
	longestFlExposures=MapThread[Function[{dataAvailableQ,exposures},
		If[dataAvailableQ,
			Max[exposures],
			{}
		]],
		{fluorescenceDataQ,flExposures}
	];

	(* check if we have any invalid inputs for exposure times *)
	invalidExposures=MapThread[Function[{dataAvailableQ,object,specifiedExposures,presentExposures,longestExposure},
		If[dataAvailableQ&&Length[Complement[specifiedExposures,presentExposures]]>0&&MatchQ[requestedPrimaryData,Alternatives[Automatic,ProcessedFluorescenceData]],
			{ToString[object],ToString[presentExposures],ToString[longestExposure]},
			Nothing
		]],
		{fluorescenceDataQ,dataObjects,fluorescenceExposureTimes/.Automatic:>{},flExposures,longestFlExposures}
	];

	(* Warn if the user specified exposure time is not present when plotting fluorescence *)
	If[Length[invalidExposures]>0,
		Message[Warning::InvalidFluorescneceExposureTime,invalidExposures[[All,1]],invalidExposures[[All,2]],invalidExposures[[All,3]]]
	];

	(* resolve exposure time to plot. if automatic or invalid, resolve to the longest exposure present, otherwise, resolve to whatever teh user specified *)
	resolvedFLExposure=MapThread[Function[{dataAvailableQ,specifiedExposures,presentExposures,longestExposure},
		Which[
			!dataAvailableQ,Null,
			MatchQ[specifiedExposures,Automatic],ToList[longestExposure]/.{}:>Null,
			MatchQ[specifiedExposures,Except[Automatic]]&&Length[Complement[specifiedExposures,presentExposures]]>0,ToList[longestExposure],
			MatchQ[specifiedExposures,Except[Automatic]]&&Length[Complement[specifiedExposures,presentExposures]]==0,ToList[specifiedExposures],
			True,Null
		]],
		{fluorescenceDataQ,fluorescenceExposureTimes,flExposures,longestFlExposures}
	];

	(* lets resolve the data we'd want to present - for primary data, we would present FL data if present, or UVAbs data if not.
	We always default to the longest exposure. If multiple exposures are specified by the user, we will make multiple data traces
	as primary for them rather than on the same plot as primary and secondary.*)
	primaryDataFields={ProcessedFluorescenceData,ProcessedUVAbsorbanceData};
	secondaryDataFields={CurrentData,VoltageData};

	(*now, let's resolve the primary and secondary data at the same time - the goal is to have data plotted from EITHER the primary and secondary data thats available. we can only plot FL/UVAbs OR current/voltage because they have different X values *)
	{resolvedPrimaryData,resolvedSecondaryData}=
		Switch[{requestedPrimaryData,requestedSecondaryData},
			(*check to see if both are specified, in which case our job is easy*)
			{Except[Automatic],Except[Automatic]},
			{
				PrimaryData->requestedPrimaryData,
				SecondaryData->requestedSecondaryData
			},
			(*check if the primary is chosen, then we'll suggest*)
			{Except[Automatic],Automatic},
			{
				PrimaryData->requestedPrimaryData,
				(* this case needs to cover raw data as well so we need to be prepared for a case in which the data is not available *)
				SecondaryData->Module[{field},
					field=If[MemberQ[primaryDataFields,requestedPrimaryData]||!MemberQ[primaryDataFields,requestedPrimaryData]&&!MemberQ[secondaryDataFields,requestedPrimaryData],
						First@Complement[primaryDataFields,ToList[requestedPrimaryData]],
						First@Complement[secondaryDataFields,ToList[requestedPrimaryData]]
					];
					(* account for raw data *)
					If[MatchQ[Lookup[allDownload,field],{$Failed..}],
						{},
						field
					]
				]
			},
			(*the weird case of the secondary selected but not the primary*)
			{Automatic,Except[Automatic]},
			{
				PrimaryData->Module[{field},
					field=If[MemberQ[primaryDataFields,requestedSecondaryData]||!MemberQ[primaryDataFields,requestedSecondaryData]&&!MemberQ[secondaryDataFields,requestedSecondaryData],
						First@Complement[primaryDataFields,ToList[requestedSecondaryData]],
						First@Complement[secondaryDataFields,ToList[requestedSecondaryData]]
					];
					(* account for raw data *)
					If[MatchQ[Lookup[allDownload,field],{$Failed..}],
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
				SecondaryData->Last[primaryDataFields]
			}
		];

	(* -- PREPARE OUTPUT -- *)

	(* for each data object/packet, we will create a list of associated data based *)
	updatedPackets=Flatten[MapThread[Function[{packet,exposureTimes},
		Which[
			(*if all the values are failed then just leave as is -- this done during the raw data transformation*)
			MatchQ[Values[KeyDrop[packet,{Type,ID}]],{$Failed..}]||MemberQ[Values[packet],ObjectP[Object[Data, CapillaryIsoelectricFocusing,"id:packetplaceholder"]]],packet,
			(* If we're dealing with FL data, we need to make a packet for each exposure time requested *)
			MatchQ[Values[resolvedPrimaryData],ProcessedFluorescenceData]||MatchQ[Values[resolvedSecondaryData],ProcessedFluorescenceData],
			(* we need to pull out the data for the correct exposure time and place it in the packet as ProcessedFluorescenceData *)
			Map[Function[exposure,Merge[{packet,<|ProcessedFluorescenceData->First[Select[Lookup[packet,ProcessedFluorescenceData],#[[1]]==exposure&]][[2]]|>},Last]],exposureTimes],
			(*otherwise, don't need to do anything*)
			True,packet
		]],
		{packets,resolvedFLExposure}
	]];

	(* If we're plotting the trajectories make our legend point to the relevant wavelengths *)
	resolvedLegend=If[MatchQ[Values[resolvedPrimaryData],ProcessedFluorescenceData]||MatchQ[Values[resolvedSecondaryData],ProcessedFluorescenceData],
		Flatten@MapThread[
			Function[{packet,exposureTimes,index},
				Map[Function[exposure,ToString[Lookup[packet,Object]/. {ObjectP[Object[Data, CapillaryIsoelectricFocusing, "id:packetplaceholder"]]->"Data Set "<>ToString[index],$Failed->"Data Set "<>ToString[index]},InputForm]<>If[!NullQ[exposure]," ("<>ToString[exposure]<>")",""]],exposureTimes]
			],
			{packets,resolvedFLExposure,Range[Length[packets]]}
		],
		Automatic
	];

	(* The value of the legend taken from the provided options *)
	optionLegend=Lookup[listedOptions,Legend];

	(* Make sure the legends provided in options take precedence *)
	finalLegend=If[MatchQ[optionLegend,_Missing|Automatic],
		resolvedLegend,
		optionLegend
	];

	imageSize=If[MatchQ[Lookup[listedOptions,ImageSize],_Missing|Automatic],
		500,
		Lookup[listedOptions,ImageSize]
	];

	(* to make things cleaner, we will no present object ID as the plot label when there are two or more object or when plotting raw data*)
	plotLabel=If[MatchQ[Lookup[listedOptions,PlotLabel,Automatic],Automatic]&&!rawDataQ,
		If[Length[dataObjects]>1,Null,ToString[First[Download[dataObjects,Object]]]],
		If[!rawDataQ,
			Lookup[listedOptions,PlotLabel],
			"Raw CIEF Data Packets"
		]
	];

	(* Force output of Result and Options *)
	resolvedOpsWithOutput=ReplaceRule[listedOptions,{resolvedPrimaryData,resolvedSecondaryData,Legend->finalLegend,ImageSize->imageSize,PlotLabel->plotLabel,Output->{Result,Options}}];

	(* Call EmeraldListLinePlot with these resolved options, forcing Output\[Rule]{Result,Options}. *)
	ellpResult=packetToELLP[updatedPackets,PlotCapillaryIsoelectricFocusing,resolvedOpsWithOutput];

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
			fullOptions=Normal[Join[Association[safeOptions],Association[FluorescenceExposureTime->resolvedFLExposure],Association[resolvedPrimaryData],Association[resolvedSecondaryData],Association[listLinePlotOptions]]];

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
