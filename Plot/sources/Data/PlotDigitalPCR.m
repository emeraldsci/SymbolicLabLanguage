(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDigitalPCR*)

DefineOptions[PlotDigitalPCR,
	Options:>{
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"The style that should be used to generate a data display.",
			ResolutionDescription->"Resolves to EmeraldListLinePlot when two channels are specified for PlotChannels, otherwise resolves to EmeraldSmoothHistogram.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[EmeraldSmoothHistogram,EmeraldListLinePlot]],
			Category->"Plot Style"
		},
		{
			OptionName->ExcitationWavelengths,
			Default->Automatic,
			Description->"The channels to be included to create a data display.",
			ResolutionDescription->"Resolves from ExcitationWavelengths and ReferenceExcitationWavelengths from input data objects.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>dPCRExcitationWavelengthP]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All]]
			],
			Category->"Data Specifications"
		},
		{
			OptionName->EmissionWavelengths,
			Default->Automatic,
			Description->"The channels to be included to create a data display.",
			ResolutionDescription->"Resolves from EmissionWavelengths and ReferenceEmissionWavelengths from input data objects.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>dPCREmissionWavelengthP]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All]]
			],
			Category->"Data Specifications"
		},
		{
			OptionName->PlotChannels,
			Default->SingleChannel,
			Description->"Channels to be plotted together to create 2D plots.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[SingleChannel]],
				{
					"X-axis channel"->Widget[Type->Enumeration,Pattern:>dPCREmissionWavelengthP],
					"Y-axis channel"->Widget[Type->Enumeration,Pattern:>dPCREmissionWavelengthP]
				}
			],
			Category->"Plot Style"
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
		]
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
		EmeraldSmoothHistogram
	}
];


(* Error messages *)
Error::PlotDigitalPCROptionMismatch="Specified values for ExcitationWavelengths and EmissionWavelengths are incompatible. Please leave one of the two options as Automatic or specify both as All or as lists of wavelengths.";
Error::PlotDigitalPCRDualChannel="Specified EmissionWavelengths does not match wavelengths specified in PlotChannels. Please verify that EmissionWavelengths matches PlotChannels or leave EmissionWavelengths as Automatic.";
Error::PlotDigitalPCRLengthMismatch="ExcitationWavelengths and EmissionWavelengths have different lengths. Please verify that the options have the same lengths and try again.";
Error::PlotDigitalPCRIncompatiblePlot="When PlotType is specified as EmeraldListLinePlot, PlotChannels must be specified as a pair of wavelengths. PlotChannels can only be specified as \"Single Channel\" to create a EmeraldSmoothHistogram. Please leave PlotType uninformed to be resolved automatically.";

(* Function overload: Quantity array dataset *)
(* Core function *)

PlotDigitalPCR[
	myData:ListableP[ObjectP[Object[Data,DigitalPCR]]],
	myOps:OptionsPattern[PlotDigitalPCR]
]:=Module[
	{
		originalOps,safeOps,output,plotData,specificOptions,plotOptions,previewPlot,
		plot,mostlyResolvedOps,resolvedOps,wavelengthOptionCheck,exEMLengthCheck,exEMChannelsCheck,
		listedData,allPackets,specifiedExcitationWavelengths,specifiedEmissionWavelengths,excitationsFromData,emissionsFromData,
		compatibleExcitationWavelengths,compatibleEmissionWavelengths,exToEM,emToEX,wavelengthsForLabels,
		specifiedPlotType,resolvedPlotType,chartLabels,plotTypeCheck,histoPlotLabels,
		resolvedExcitationWavelengths,resolvedEmissionWavelengths,allDataFromInputs
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDigitalPCR,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(****** Plot Code ******)

	listedData=ToList[myData];

	(* Download call *)
	allPackets=Quiet[
		Download[listedData,
			Packet[
				SamplesIn,
				Well,
				ExcitationWavelengths,
				EmissionWavelengths,
				ReferenceExcitationWavelengths,
				ReferenceEmissionWavelengths,
				DropletAmplitudes,
				DropletExcitationWavelengths,
				DropletEmissionWavelengths
			]
		]
	];

	(*-- Resolve options --*)

	(*- Resolving excitation/emission wavelengths -*)
	(* Get option value *)
	specifiedExcitationWavelengths=Lookup[safeOps,ExcitationWavelengths];
	specifiedEmissionWavelengths=Lookup[safeOps,EmissionWavelengths];

	(* Check the value of specified wavelength options *)
	wavelengthOptionCheck=If[MatchQ[Automatic,specifiedExcitationWavelengths|specifiedEmissionWavelengths],
		(* When either option is Automatic, they can be resolved correctly and there is no error *)
		True,
		(* When both options are specified, they must both be All or must be quantity lists and must not have unique Ex vs Em values *)
		Or[
			SameQ[All,specifiedExcitationWavelengths,specifiedEmissionWavelengths],
			And[
				MatchQ[specifiedExcitationWavelengths,{_?QuantityQ..}],
				MatchQ[specifiedEmissionWavelengths,{_?QuantityQ..}],
				ContainsNone[specifiedExcitationWavelengths,specifiedEmissionWavelengths]
			]
		]
	];

	(* Create wavelength conversion rules *)
	compatibleExcitationWavelengths={
		495.*Nanometer,
		535.*Nanometer,
		538.*Nanometer,
		647.*Nanometer,
		675.*Nanometer
	};

	compatibleEmissionWavelengths={
		517.*Nanometer,
		556.*Nanometer,
		554.*Nanometer,
		665.*Nanometer,
		694.*Nanometer
	};

	exToEM=AssociationThread[compatibleExcitationWavelengths,compatibleEmissionWavelengths];
	emToEX=AssociationThread[compatibleEmissionWavelengths,compatibleExcitationWavelengths];

	(* Create a list of emission wavelengths from all data packets *)
	{excitationsFromData,emissionsFromData}=Module[
		{allWavelengths,flatAllWavelengths,allWavelengthPairs,uniqueWavelengths},

		(* Get emission and excitation wavelengths from all related probes and reference probes *)
		allWavelengths={
			Lookup[allPackets,{ExcitationWavelengths,ReferenceExcitationWavelengths}],
			Lookup[allPackets,{EmissionWavelengths,ReferenceEmissionWavelengths}]
		};

		(* Flatten each list to create a list of excitation wavelengths and a list of emission wavelengths *)
		flatAllWavelengths=Flatten/@allWavelengths;

		(* Create a list of Ex/Em wavelength pairs *)
		allWavelengthPairs=Transpose[flatAllWavelengths];

		(* Pare down the list to only the unique wavelengths that show up in the packets *)
		uniqueWavelengths=DeleteDuplicatesBy[allWavelengthPairs,Last];

		(* Sort the wavelengths by smallest emission wavelength to largest and output Ex and Em wavelengths separately *)
		Transpose[
			SortBy[uniqueWavelengths,Last]
		]
	];

	(* Resolve excitation and emission wavelengths *)
	{resolvedExcitationWavelengths,resolvedEmissionWavelengths}=Which[
		(* Accept user input if not automatic *)
		MatchQ[specifiedExcitationWavelengths,Except[Automatic|All]]&&MatchQ[specifiedEmissionWavelengths,Except[Automatic|All]],{specifiedExcitationWavelengths,specifiedEmissionWavelengths},
		(* When only excitation wavelengths are specified, translate to emission wavelengths *)
		MatchQ[specifiedExcitationWavelengths,Except[Automatic|All]],{specifiedExcitationWavelengths,specifiedExcitationWavelengths/.exToEM},
		(* When only emission wavelengths are specified, translate to excitation wavelengths *)
		MatchQ[specifiedEmissionWavelengths,Except[Automatic|All]],{specifiedEmissionWavelengths/.emToEX,specifiedEmissionWavelengths},
		(* When PlotChannels is specified as a doublet with X-axis and Y-axis channels, use those as the emission and excitation wavelengths *)
		MatchQ[Lookup[safeOps,PlotChannels],{_?QuantityQ,_?QuantityQ}],{Lookup[safeOps,PlotChannels]/.emToEX,Lookup[safeOps,PlotChannels]},
		(* Auto-resolve to wavelengths found in input data *)
		MatchQ[specifiedExcitationWavelengths,Automatic]&&MatchQ[specifiedEmissionWavelengths,Automatic],{excitationsFromData,emissionsFromData},
		(* If one of the specified options is All, set both of them to All *)
		MatchQ[All,specifiedExcitationWavelengths|specifiedEmissionWavelengths],{All,All}
	];

	(*- Error handling for excitation/emission wavelengths -*)

	(* When PlotChannels is specified as a doublet, emission must match channels specified in PlotChannels *)
	exEMChannelsCheck=If[MatchQ[Lookup[safeOps,PlotChannels],{_?QuantityQ,_?QuantityQ}],
		ContainsExactly[resolvedEmissionWavelengths,Lookup[safeOps,PlotChannels]],
		True
	];

	(* Both options must have the same lengths if they are quantities *)
	exEMLengthCheck=If[AllTrue[ToList[resolvedExcitationWavelengths],QuantityQ]&&AllTrue[ToList[resolvedEmissionWavelengths],QuantityQ],
		SameLengthQ[resolvedExcitationWavelengths,resolvedEmissionWavelengths],
		True
	];

	Which[
		!wavelengthOptionCheck,(Message[Error::PlotDigitalPCROptionMismatch];Return[$Failed]),
		!exEMChannelsCheck,(Message[Error::PlotDigitalPCRDualChannel];Return[$Failed]),
		!exEMLengthCheck,(Message[Error::PlotDigitalPCRLengthMismatch];Return[$Failed])
	];

	(*- Resolve PlotType -*)
	(* Get specified option *)
	specifiedPlotType=Lookup[safeOps,PlotType];

	(* Resolve option depending on PlotChannel *)
	resolvedPlotType=Which[
		(* Accept any user specified input and error check *)
		MatchQ[specifiedPlotType,Except[Automatic]],specifiedPlotType,
		(* When PlotChannels is specified as a pair of wavelengths for x and y axes, use EmeraldListLinePlot *)
		!MatchQ[Lookup[safeOps,PlotChannels],SingleChannel],EmeraldListLinePlot,
		(* Default to EmeraldSmoothHistogram *)
		True,EmeraldSmoothHistogram
	];

	(* Error handling for PlotType *)
	plotTypeCheck=If[MatchQ[resolvedPlotType,EmeraldListLinePlot],
		MatchQ[Lookup[safeOps,PlotChannels],{_?QuantityQ,_?QuantityQ}],
		MatchQ[Lookup[safeOps,PlotChannels],SingleChannel]
	];

	If[!plotTypeCheck,
		Message[Error::PlotDigitalPCRIncompatiblePlot];
		Return[$Failed],
		Nothing
	];

	(*-- Populate resolved options --*)
	(* ChartLabels - used for DistributionChart - keeping it here for the future when we can actually use distributions
	chartLabels={
		allPackets[Well],
		If[SameQ[resolvedEmissionWavelengths,All],
			Lookup[First[allPackets],DropletEmissionWavelengths],
			resolvedEmissionWavelengths
		]
	};*)
	(* In order to create labels for histograms, we need a list of wells combined with wavelengths; When emission wavelengths is 'All', get a list of possible channels *)
	wavelengthsForLabels=If[SameQ[resolvedEmissionWavelengths,All],
		Lookup[First[allPackets],DropletEmissionWavelengths],
		resolvedEmissionWavelengths
	];

	(* create a list of labels "WellID, Wavelength" for each data set to be plotted*)
	histoPlotLabels=Flatten[
		Table[
			dataID<>", "<>ToString[emWavelength],
			{dataID,Lookup[allPackets,ID]},
			{emWavelength,wavelengthsForLabels}
		]
	];

	(* Gather specific options *)
	specificOptions=Join[
		{
			ExcitationWavelengths->resolvedExcitationWavelengths,
			EmissionWavelengths->resolvedEmissionWavelengths,
			PlotType->resolvedPlotType,
			PlotChannels->Lookup[safeOps,PlotChannels]
		},
		If[MatchQ[resolvedPlotType,EmeraldSmoothHistogram],
			{
				PlotLegends->histoPlotLabels
			},
			{
				Frame->True,
				FrameLabel->{
					{Last[Lookup[safeOps,PlotChannels]],None},
					{First[Lookup[safeOps,PlotChannels]],None}
				},
				LegendLabel->"Sample Well",
				PlotLegends->allPackets[Well]
			}
		]
	];

	mostlyResolvedOps=ReplaceRule[safeOps,specificOptions];

	(*-- Resolve the raw numerical data that you will plot --*)
	(* Get raw data from all channels *)
	allDataFromInputs=Lookup[allPackets,DropletAmplitudes];

	(* From each data set, isolate the columns that pertain to resolved emission wavelengths *)
	plotData=Map[
		Function[{singleInputData},
			If[MatchQ[resolvedPlotType,EmeraldListLinePlot],
				Module[
					{initialChannelPositions,channelPositions,channelData},
					(* Get the positions of channels from which data will be plotted *)
					initialChannelPositions=Map[
						Position[
							{
								517.Nanometer,
								556.*Nanometer,
								665.*Nanometer,
								694.*Nanometer
							},#]&,
						Lookup[mostlyResolvedOps,PlotChannels]/.{554.*Nanometer->556.*Nanometer}
					];

					(* Since Position adds an extra layer of nested listing, flatten to get the appropriate listing *)
					channelPositions=Flatten/@initialChannelPositions;

					(* Get data to be plotted *)
					channelData=Extract[singleInputData,channelPositions];

					(* Pair off the x/y data and output *)
					Transpose[channelData]
				],
				If[SameQ[resolvedEmissionWavelengths,All],
					singleInputData,
					Module[
						{emissionPositions,flatEmissionPositions},
						(* Data is stored in order from the smallest emission wavelength channel to the largest.
						In case the emission wavelengths option is not in order, convert wavelength to position *)
						emissionPositions=Map[
							Position[resolvedEmissionWavelengths,#]&,
							{
								517.Nanometer,
								Alternatives[556.*Nanometer,554.*Nanometer],
								665.*Nanometer,
								694.*Nanometer
							}
						];

						(* Since position adds extra lists, flatten each element *)
						flatEmissionPositions=Flatten/@emissionPositions;

						(* Remove empty lists *)
						Extract[
							singleInputData,
							flatEmissionPositions/.{{}->Nothing}
						]
					]
				]
			]
		],
		allDataFromInputs
	];

	(* Resolve all options which should go to the plot function (i.e. EmeraldListLinePlot in most cases)  *)
	plotOptions=PassOptions[
		PlotDigitalPCR,
		Lookup[mostlyResolvedOps,PlotType],
		mostlyResolvedOps
	];

	(*********************************)

	(*(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
		ReplaceRule[plotOptions,
			{Output->{Result,Options}}
		]
	];*)

	(*-- Call plot function --*)
	plot=If[MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldSmoothHistogram],
		(*Since plotData is formatted for DistributionChart, remove a level of nestedness to get the data in a list of lists format*)
		EmeraldSmoothHistogram[Flatten[plotData,1],plotOptions],
		EmeraldListLinePlot[plotData,plotOptions]
	];

	(*previewPlot=If[MatchQ[Lookup[mostlyResolvedOps,PlotType],DistributionChart],
		(*DistributionChart[plotData,LabelingFunction->None,plotOptions]*)
		ListPlot[plotData],
		EmeraldListLinePlot[plotData,plotOptions]
	];*)

	(* Combine options resolved by MM function *)
	resolvedOps=If[MatchQ[Lookup[mostlyResolvedOps,PlotType],EmeraldSmoothHistogram],
		(*Since plotData is formatted for DistributionChart, remove a level of nestedness to get the data in a list of lists format*)
		EmeraldSmoothHistogram[Flatten[plotData,1],Output->Options,plotOptions],
		EmeraldListLinePlot[plotData,Output->Options,plotOptions]
	];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->ReplaceRule[resolvedOps,specificOptions],
		Preview->SlideView[Flatten[{plot}],ImageSize->Full],
		Tests->{}
	}
]