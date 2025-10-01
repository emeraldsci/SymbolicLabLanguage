(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentPlateMedia*)
$WellSpecificResources = False;

(* ::Subsubsection:: *)
(*ExperimentPlateMedia Options and Messages*)
(* resolver will need to reject plates that cannot be used with the pourer *)

DefineOptions[ExperimentPlateMedia,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"media",
			{
				OptionName->Instrument,
				Default->Automatic,
				Description->"The instrument used to transfer the heated media from the bottle in which it was prepared to the incubation plates.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Instrument,PlatePourer],Object[Instrument,PlatePourer],Model[Instrument,Pipette],Object[Instrument,Pipette]}],
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Instruments",
								"Liquid Handling",
								"Serological Pipettes"
							}(* Add this back if/when plate pourers go online
							,
							{
								Object[Catalog,"Root"],
								"Instruments",
								"Cell Culture",
								"Plate Pourer"
							}*)
						}
					]
				],
				ResolutionDescription->"Automatically set to Model[Instrument,PlatePourer,\"Serial Filler\"] if PlatingMethod is set to Pump and/or if PumpFlowRate is specified, or to Model[Instrument,Pipette,\"pipetus\"] if PlatingMethod is set to Pour."
			},
			{
				OptionName->PlateOut,
				Default->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				Description->"The models of plates into which the prepared media will be transferred.",
				AllowNull->False,
				Category->"General",
				Widget->Alternatives[
					"New Plate"->Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container,Plate]],
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Containers",
								"Plates",
								"Cell Incubation Plates"
							}
						}
					],
					"New Plate with Index"->{
						"Index"->Widget[
							Type->Number,
							Pattern:>GreaterEqualP[1,1]
						],
						"Plate"->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Container,Plate]]
						]
					},
					"Existing Plate"->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Container,Plate]]
					]
					(* list of Object[Container,Plate] *)
				]
			},
			{
				OptionName->NumberOfPlates,
				Default->1,
				Description->"The number of plates to which the prepared media should be transferred.",
				AllowNull->True,
				Category->"General",
				Widget->Alternatives[
					Widget[
						Type->Number,
						Pattern:>RangeP[1,10,1]
					]
				]
			},
			{
				OptionName->DestinationWell,
				Default->All,
				ResolutionDescription->"Automatically set to all wells of the PlateOut.",
				AllowNull->False,
				Widget->Alternatives[
					Adder[
						Widget[
							Type->String,
							Pattern:>WellPositionP,
							Size->Line,
							PatternTooltip->"Enumeration must be any well from A1 to H12."
						]
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				],
				Description->"The position in the destination container in which the source media sample will be placed.",
				Category->"General"
			},
			{
				OptionName->PlatingVolume,
				Default->Automatic,
				Description->"The volume of media transferred from its source container into each incubation plate.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Milliliter,$MaxTransferVolume],
						Units->Milliliter
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Automatic]
					]
				],
				ResolutionDescription->"Automatically set to 50% of the MaxVolume of each PlateOut model."
			},
			{
				OptionName->PlatingMethod,
				Default->Pour,
				Description->"Indicates how the liquid media will be transferred from its source container to the incubation plates.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>MediaPlatingMethodP
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				],
				ResolutionDescription->"Automatically set to Pump if PlateMedia is set to True and PlatePourer and/or PumpFlowRate are specified, or Null if PlateMedia is set to False."
			},
			{
				OptionName->PrePlatingIncubationTime,
				Default->40*Minute,
				Description->"The duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,$MaxExperimentTime],
						Units->{1,{Hour,{Minute,Hour}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->MaxPrePlatingIncubationTime,
				Default->Automatic,
				Description->"The maximum duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature. If the media is not liquid after the PrePlatingIncubationTime, it will be allowed to incubate further and checked in cycles of PrePlatingIncubationTime up to the MaxIncubationTime to see if it has become liquid and can thus be poured. If the media is not liquid after MaxPrePlatingIncubationTime, the plates will not be poured, and this will be indicated in the PouringFailed field in the protocol object.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,$MaxExperimentTime],
						Units->{1,{Hour,{Minute,Hour}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				],
				ResolutionDescription->"Automatically set to three times the duration of the PrePlatingIncubationTime setting."
			},
			(* This option is temporarily suspended, but we may bring it back at some point, so we'll keep this portion commented out rather than deleted *)
			(*{
				OptionName->PrePlatingMixRate,
				Default->100*RPM,(*TODO test in lab, may need to calibrate *)
				Description->"The rate at which the stir bar within the liquid media is rotated prior to pumping the media into incubation plates.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[$MinMixRate,$MaxMixRate],
						Units->RPM
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},*)
			{
				OptionName->PlatingTemperature,
				Default->Automatic,
				Description->"The temperature at which the autoclaved media with gelling agents is incubated prior to and during the media plating process.",
				AllowNull->False,
				Category->"Plating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$AmbientTemperature,$MaxTemperatureProfileTemperature],
					Units->{1,{Celsius,{Celsius,Fahrenheit}}}
				],
				ResolutionDescription->"Automatically set to 1.025 times the melting temperature (in Kelvin) of the GellingAgents if MediaPhase is set to Solid/SemiSolid and/or if GellingAgents is specified."
			},
			{
				OptionName->PumpFlowRate,
				Default->Automatic(* TODO need to determine the best pour rate *),
				Description->"The volume of liquid media pumped per unit time from its source container into incubation plates by the serial filler instrument.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Milliliter/Second,8*Milliliter/Second],
						Units->CompoundUnit[
							{1,{Milliliter,{Microliter,Milliliter,Liter}}},
							{-1,{Second,{Second,Minute,Hour}}}
						]
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				],
				ResolutionDescription->"Automatically set to TBD if PlatePourer is specified or PlatingMethod is set to Pump, otherwise set to Null."
			},
			{
				OptionName->SolidificationTime,
				Default->1*Hour,
				Description->"The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,1*Day],
						Units->{1,{Hour,{Hour,Day}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->PlatedMediaShelfLife,
				Default->1*Week,
				Description->"The duration of time after which the prepared plates are considered to be expired.",
				AllowNull->False,
				Category->"Storage Information",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Day],
						Units->{1,{Week,{Hour,Day,Week,Month,Year}}}
					]
				]
			}
		],
		(* --- Shared Standard Protocol Options --- *)
		ProtocolOptions,
		OutputOption,
		BiologyPostProcessingOptions,
		SamplesOutStorageOption,
		SimulationOption
	}
];

Error::InconsistentPlateOutFormat = "The PlateOut option is specified as a combination of un-indexed (`1`) and indexed (`2`) values. Please revise the PlateOut option so that they are all indexed or un-indexed.";
Error::PlatingMethodPumpInstrumentMismatch = "At positions `1` for media `2`, the PlatingMethod option is set by the user to {Pump} but the Instrument options are set to `3`, which is not of type Object[Instrument,PlatePourer] or Model[Instrument,PlatePourer].";
Error::PlateOutDestinationWellMismatch = "At positions `1` for media `2`, not all of the DestinationWell option `3` set by the user exist in the PlateOut `4` set by the user. The allowed DestinationWell option values for PlateOut `4` are `5`.";
Error::InsufficientMediaVolumePerInput = "At positions `1` for media `2`, approximately `3` of media sample is necessary to complete the transfer to `4` of `5`, each filled at positions `6`. Please revise the NumberOfPlates, PlateOut, DestinationWell, and/or PlatingVolume options.";
Error::InsufficientMediaVolumeConsolidatedInputs = "At positions `1` for media `2`, approximately `3` of media sample is necessary to prepare `4`, but only `5` of `2` is available.";
Warning::PlatingTemperatureLowerThanRecommended = "At positions `1` for media `2`, the specified PlatingTemperature options `3` are lower than the recommended values `4` based on the highest melting point `5` of the gelling agents `6` present in the media. Please revise the PlatingTemperature option to be greater than or equal to `4` but no higher than `5`.";
Error::PlatingVolumeExceedsMaxVolume = "At positions `1` for media `2`, the specified PlatingVolume options `3` is greater than the maximum volume `5` for each well in the specified PlateOut `4`. Please revise the PlatingVolume options `3` to be equal to or less than half of `5`, or set the PlateOut option to a container whose MaxVolume is greater than twice the specified PlatingVolume.";
Warning::PlatingVolumeExceedsHalfMaxVolume = "At positions `1` for media `2`, the specified PlatingVolume options `3` is greater than the recommended `5`, which are 50% of the MaxVolume for the specified PlateOut `4`. Please revise the PlatingVolume options `3` to be equal to or less than `5`, or set the PlateOut option to a container whose MaxVolume is greater than twice the specified PlatingVolume.";
Error::InsufficientMediaForPlating = "In order to plate the following media samples `1` as specified, a combined volume of `2` is needed, but only `3` is present. Please revise options {PlatingVolume,DestinationWell,NumberOfPlates} or specify a Model[Sample,Media] as the input to guarantee that all requested media plates can be prepared.";

DefineOptions[resolvePlateMediaOptions,
	Options:>{HelperOutputOption,CacheOption}
];

$PercentPlatable = 0.95;
$DefaultPumpFlowRate = 4*Milliliter/Second;
$PreferredPreparatoryContainers = {Model[Container,Vessel,"100 mL Glass Bottle"],
	Model[Container,Vessel,"150 mL Glass Bottle"],
	Model[Container,Vessel,"250mL Glass Bottle"],
	Model[Container,Vessel,"500mL Glass Bottle"],
	Model[Container,Vessel,"1L Glass Bottle"],
	Model[Container,Vessel,"2L Glass Bottle"]
};
$MinimumMediaVolume = 20 Milliliter;

resolvePlateMediaOptions[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolvePlateMediaOptions]]:=Module[{outputSpecification,output,gatherTests,messages,
	fastTrack,fastAssoc,cache,specifiedInstruments,specifiedPlateOuts,specifiedDestinationWells,specifiedNumbersOfPlates,
	specifiedPlatingMethods,specifiedPrePlatingIncubationTimes,specifiedMaxPrePlatingIncubationTimes,specifiedPrePlatingMixRates,
	specifiedPlatingTemperatures,specifiedPlatingVolumes,specifiedPumpFlowRates,specifiedSolidificationTimes,specifiedPlatedMediaShelfLifes,
	uniqueSpecifiedPlateOutsModels,samplePackets,unindexedPlateOuts,indexedPlateOuts,inconsistentPlateOutFormatErrorQ,resolvedPlateOuts,
	specifiedPlateOutModels,PlateOutPackets,gellingAgentPackets,sampleContainerPackets,platingMethodPumpInstrumentMismatchErrorQs,
	platingMethodPumpInstrumentMismatchPositions,platingMethodPumpInstrumentMismatchInputs,platingMethodPumpInstrumentMismatchOptions,platingMethodPumpInstrumentMismatchInvalidOptions,platingMethodPumpFlowRateMismatchErrorQs,platingMethodPumpFlowRateMismatchPositions,
	platingMethodPumpFlowRateMismatchInputs,platingMethodPumpFlowRateMismatchOptions,platingMethodPumpFlowRateMismatchInvalidOptions,
	destinationWellPlateOutMismatchErrorQs,destinationWellPlateOutMismatchPositions,destinationWellPlateOutMismatchInputs,
	destinationWellPlateOutMismatchDestinationWellOptions,destinationWellPlateOutMismatchPlateOutOptions,destinationWellPlateOutMismatchInvalidOptions,
	containerMaxVolumes,plateOutMissingMaxVolumeErrorQ,plateOutMissingMaxVolumePositions,plateOutMissingMaxVolumeInputs,plateOutMissingMaxVolumeContainers,
	plateOutMissingMaxVolumeInvalidOptions,platingVolumeExceedsMaxVolumeErrorQs,platingVolumeExceedsMaxVolumePositions,platingVolumeExceedsMaxVolumeInputs,
	platingVolumeExceedsMaxVolumePlatingVolumes,platingVolumeExceedsMaxVolumePlateOuts,platingVolumeExceedsMaxVolumeMaxVolumes,
	platingVolumeExceedsMaxVolumeInvalidOptions,platingVolumeExceedsHalfMaxVolumeErrorQs,platingVolumeExceedsHalfMaxVolumePositions,
	platingVolumeExceedsHalfMaxVolumeInputs,platingVolumeExceedsHalfMaxVolumePlatingVolumes,platingVolumeExceedsHalfMaxVolumePlateOuts,
	platingVolumeExceedsHalfMaxVolumeMaxVolumes,resolvedInstruments,gellingAgentsPresent,gellingAgentsMeltingPoints,gellingAgentsMaxMeltingPoints,
	recommendedPlatingTemperatures,resolvedPlatingMethods,resolvedPlatingInstruments,resolvedMaxPrePlatingIncubationTimes,
	resolvedOptions,invalidOptions,allTests,plateOutResources,resolvedPlatingTemperatures,platingTemperatureLowerThanRecommendedWarningQs,
	platingTemperatureLowerThanRecommendedPositions,platingTemperatureLowerThanRecommendedInputs,platingTemperatureLowerThanRecommendedTemperatureOptions,
	platingTemperatureRecommendations,platingTemperatureLowerThanRecommendedGellingAgents,platingTemperatureLowerThanRecommendedRecommendedTemperature,
	resolvedPlatingVolumes,unspecifiedPlatingVolumeInputs,resolvedDestinationWells,PlateOutWellTuples,gatheredPlateOutWellTuples,
	needPlatingVolumeOptionErrorQs,optionsForGrouping,inputsAndOptionsForGrouping,inputsGroupedByObject,consolidatedMediaVolumesNeeded,
	InsufficientMediaVolumeConsolidatedErrorQs,unspecifiedDestinationWellQs,unspecifiedDestinationWellPositions,unspecifiedNumberOfPlatesQs,
	unspecifiedNumberOfPlatesPositions,sampleVolumes,insufficientMediaVolumeErrorQs,mediaVolumesNeeded,insufficientMediaVolumePositions,
	insufficientMediaVolumeInputs,insufficientMediaVolumeTotalNeededVolumes,insufficientMediaVolumePlateOutOptions,insufficientMediaVolumeNumberOfPlatesOptions,insufficientMediaVolumeOptions,insufficientMediaVolumeDestinationWellOptions,unspecifiedDestinationWellInputs,possibleWellPositions,optionPrecisions,roundedExperimentOptions,optionPrecisionTests,
	resolvedPumpFlowRates,email,resolvedPostProcessingOptions, specifiedSite, resolvedSite},
	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];
	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	
	fastAssoc = makeFastAssocFromCache[cache];

	(* - Round the experiment options - *)
	(* First, define the option precisions that need to be checked for PlateMedia *)
	optionPrecisions = {
		{PlatingVolume, 10^-1 * Milliliter},
		{PrePlatingIncubationTime, {10^0 * Minute, 10^-1 Hour}},
		{MaxPrePlatingIncubationTime, {10^0 * Minute, 10^-1 Hour}},
		{PlatingTemperature, 10^-1 * Celsius},
		{SolidificationTime, {10^0 * Minute, 10^-1 Hour}},
		{PumpFlowRate, 10^0 * (Milliliter / Second)},
		{PlatedMediaShelfLife, {10^0 * Day, 10^0 * Month}}
	};

	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,

		(*If we are gathering tests *)
		RoundOptionPrecision[Association[myOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

		(* Otherwise *)
		{RoundOptionPrecision[Association[myOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];
	
	(* Pull out the relevant options *)
	{
		(*1*)specifiedInstruments,
		(*3*)specifiedPlateOuts,
		(*4*)specifiedDestinationWells,
		(*5*)specifiedNumbersOfPlates,
		(*6*)specifiedPlatingMethods,
		(*7*)specifiedPrePlatingIncubationTimes,
		(*8*)specifiedMaxPrePlatingIncubationTimes,
		(*9*)(*specifiedPrePlatingMixRates,*)
		(*10*)specifiedPlatingTemperatures,
		(*11*)specifiedPlatingVolumes,
		(*12*)specifiedPumpFlowRates,
		(*13*)specifiedSolidificationTimes,
		(*14*)specifiedPlatedMediaShelfLifes
	} = Lookup[roundedExperimentOptions,
		{
			(*1*)Instrument,
			(*3*)PlateOut,
			(*4*)DestinationWell,
			(*5*)NumberOfPlates,
			(*6*)PlatingMethod,
			(*7*)PrePlatingIncubationTime,
			(*8*)MaxPrePlatingIncubationTime,
			(*9*)(*PrePlatingMixRate,*)
			(*10*)PlatingTemperature,
			(*11*)PlatingVolume,
			(*12*)PumpFlowRate,
			(*13*)SolidificationTime,
			(*14*)PlatedMediaShelfLife
		}
	];
	
	samplePackets = Map[fetchPacketFromFastAssoc[#,fastAssoc]&,myMedia];

	(* We get plates out here by objects and then by models *)
	resolvedPlateOuts = reIndexContainerOut[myMedia,roundedExperimentOptions];
	specifiedPlateOutModels = resolvedPlateOuts[[All,2]];
	uniqueSpecifiedPlateOutsModels = DeleteDuplicates[specifiedPlateOutModels];
	PlateOutPackets = Map[fetchPacketFromFastAssoc[#,fastAssoc]&,uniqueSpecifiedPlateOutsModels];
	
	(* ERROR CHECK #2 *)
	(* PlatingMethod is set to Pump but something other than Automatic or PlatePourer is specified for Instrument *)
	platingMethodPumpInstrumentMismatchErrorQs = MapThread[
		If[
			MatchQ[#1,Pump] && !MatchQ[#2,Alternatives[Automatic,ObjectP[{Model[Instrument,PlatePourer],Object[Instrument,PlatePourer]}]]],
			True,
			False
		]&,
		{specifiedPlatingMethods,specifiedInstruments}
	];
	platingMethodPumpInstrumentMismatchPositions = Flatten[Position[platingMethodPumpInstrumentMismatchErrorQs,True]];
	platingMethodPumpInstrumentMismatchInputs = myMedia[[platingMethodPumpInstrumentMismatchPositions]];
	platingMethodPumpInstrumentMismatchOptions = specifiedInstruments[[platingMethodPumpInstrumentMismatchPositions]];
	platingMethodPumpInstrumentMismatchInvalidOptions = If[messages && Length[platingMethodPumpInstrumentMismatchPositions] > 0,
		Message[Error::PlatingMethodPumpInstrumentMismatch,
			platingMethodPumpInstrumentMismatchPositions,
			ObjectToString[platingMethodPumpInstrumentMismatchInputs],
			platingMethodPumpInstrumentMismatchOptions
		];
		{PlatingMethod,Instrument},
		{}
	];
	
	(* ERROR CHECK #3 *)
	(* PlatingMethod is set to Pour and PumpFlowRate is specified simultaneously *)
	platingMethodPumpFlowRateMismatchErrorQs = MapThread[
		If[
			MatchQ[#1,Pour] && !MatchQ[#2,Automatic|Null],
			True,
			False
		]&,
		{specifiedPlatingMethods,specifiedPumpFlowRates}
	];
	platingMethodPumpFlowRateMismatchPositions = Flatten[Position[platingMethodPumpFlowRateMismatchErrorQs,True]];
	platingMethodPumpFlowRateMismatchInputs = ObjectToString[myMedia[[platingMethodPumpFlowRateMismatchPositions]]];
	platingMethodPumpFlowRateMismatchOptions = specifiedPumpFlowRates[[platingMethodPumpInstrumentMismatchPositions]];
	platingMethodPumpFlowRateMismatchInvalidOptions = If[messages && Length[platingMethodPumpFlowRateMismatchPositions] > 0,
		Message[Error::PlatingMethodPumpFlowRateMismatch,
			platingMethodPumpFlowRateMismatchPositions,
			ObjectToString[platingMethodPumpFlowRateMismatchInputs],
			platingMethodPumpFlowRateMismatchOptions
		];
		{PlatingMethod,PumpFlowRate},
		{}
	];
	
	(* ERROR CHECK #4 *)
	(* Incompatible DestinationWell & PlateOut options. If DestinationWell is specified, make sure its values actually exist in the specified PlateOut *)
	destinationWellPlateOutMismatchErrorQs = MapThread[Function[{specifiedDestinationWell,specifiedPlateOutModel},
		Module[{allowedDestinationWells},
			allowedDestinationWells = List@@Lookup[Lookup[fastAssoc,specifiedPlateOutModel],AllowedPositions];
			If[MatchQ[specifiedDestinationWell,All],
				False,
				!SubsetQ[allowedDestinationWells,specifiedDestinationWell]
			]
		]
	],{specifiedDestinationWells,specifiedPlateOutModels}];
	destinationWellPlateOutMismatchPositions = Flatten[Position[destinationWellPlateOutMismatchErrorQs,True]];
	destinationWellPlateOutMismatchInputs = myMedia[[destinationWellPlateOutMismatchPositions]];
	destinationWellPlateOutMismatchDestinationWellOptions = specifiedDestinationWells[[destinationWellPlateOutMismatchPositions]];
	destinationWellPlateOutMismatchPlateOutOptions = specifiedPlateOutModels[[destinationWellPlateOutMismatchPositions]];
	destinationWellPlateOutMismatchInvalidOptions = If[messages && Length[destinationWellPlateOutMismatchPositions] > 0,
		Message[Error::PlateOutDestinationWellMismatch,
			destinationWellPlateOutMismatchPositions,
			ObjectToString[destinationWellPlateOutMismatchInputs],
			destinationWellPlateOutMismatchDestinationWellOptions,
			ObjectToString[destinationWellPlateOutMismatchPlateOutOptions],
			Map[List@@Lookup[Lookup[fastAssoc,#],AllowedPositions]&,destinationWellPlateOutMismatchPlateOutOptions]
		];
		{PlateOut,DestinationWell},
		{}
	];
	
	(* Resolution of DestinationWell option, which will be automatically set to all wells from AvailablePositions if nothing is specified. *)
	resolvedDestinationWells = MapThread[Function[{specifiedDestinationWell,specifiedPlateOut},
		Module[{allWells},
			allWells = List@@Lookup[Lookup[fastAssoc,specifiedPlateOut],AllowedPositions];
			If[MatchQ[specifiedDestinationWell,All],
				allWells,
				specifiedDestinationWell
			]
		]
	],{specifiedDestinationWells,specifiedPlateOutModels}];
	
	(* TODO tentatively defaulting resolvedPlatingMethod->Pour *)
	resolvedPlatingMethods = Map[Pour&,myMedia];
	resolvedPumpFlowRates = MapThread[Function[{specifiedPlatingMethod,specifiedPumpFlowRate},
		If[MatchQ[specifiedPlatingMethod,Pour],
			Null,
			specifiedPumpFlowRate/.{Automatic->$DefaultPumpFlowRate}
		]
	],{specifiedPlatingMethods,specifiedPumpFlowRates}];
	
	resolvedInstruments = Map[Function[{resolvedPlatingMethod},
		Which[
			MatchQ[resolvedPlatingMethod,Pump],
			Model[Instrument, PlatePourer, "id:rea9jlRpkzqL"] (* Model[Instrument, PlatePourer, "Serial Filler"] *),
			
			MatchQ[resolvedPlatingMethod,Pour | Automatic],
			Model[Instrument, Pipette, "id:3em6ZvLlDkBY"] (* Model[Instrument, Pipette, "pipetus"] *)
		]
	],resolvedPlatingMethods];
	
	(* WARNING CHECK #1: PlatingTemperature is less than 95% of the highest melting temperature of all gelling agents, which presents risk of media solidifying during the plating process. *)
	gellingAgentsPresent = Flatten[Quiet[Download[myMedia,{Model[GellingAgents][[All,2]][Object],GellingAgents[[All,2]][Object]}],{Download::FieldDoesntExist,Download::NotLinkField}]/.{$Failed->Nothing},1];
	gellingAgentsMeltingPoints = Map[Function[{gellingAgents},N[Convert[Map[Lookup[Lookup[fastAssoc,#],MeltingPoint]&,gellingAgents],Celsius]]],gellingAgentsPresent];
	gellingAgentsMaxMeltingPoints = Map[Max[#]&,gellingAgentsMeltingPoints];
	recommendedPlatingTemperatures = Map[N[Convert[N[Convert[#,Kelvin]*1.025],Celsius]]&,gellingAgentsMaxMeltingPoints];
	resolvedPlatingTemperatures = MapThread[Function[{specifiedPlatingTemperature,recommendedPlatingTemperature},
		If[MatchQ[specifiedPlatingTemperature,TemperatureP],
			specifiedPlatingTemperature,
			RoundOptionPrecision[recommendedPlatingTemperature, 10^-1*Celsius, Round->Up]
		]
	],{specifiedPlatingTemperatures,recommendedPlatingTemperatures}];
	
	platingTemperatureLowerThanRecommendedWarningQs = MapThread[Function[{recommendedPlatingTemperature,resolvedPlatingTemperature},
		resolvedPlatingTemperature < recommendedPlatingTemperature
	],{recommendedPlatingTemperatures,resolvedPlatingTemperatures}];
	
	platingTemperatureLowerThanRecommendedPositions = Flatten[Position[platingTemperatureLowerThanRecommendedWarningQs,True]];
	platingTemperatureLowerThanRecommendedInputs = myMedia[[platingTemperatureLowerThanRecommendedPositions]];
	platingTemperatureLowerThanRecommendedTemperatureOptions = resolvedPlatingTemperatures[[platingTemperatureLowerThanRecommendedPositions]];
	platingTemperatureRecommendations = recommendedPlatingTemperatures[[platingTemperatureLowerThanRecommendedPositions]];
	platingTemperatureLowerThanRecommendedGellingAgents = gellingAgentsPresent[[platingTemperatureLowerThanRecommendedPositions]];
	
	If[messages && Length[platingTemperatureLowerThanRecommendedPositions]>0,
		Message[Warning::PlatingTemperatureLowerThanRecommended,
			platingTemperatureLowerThanRecommendedPositions,
			ObjectToString[platingTemperatureLowerThanRecommendedInputs],
			platingTemperatureLowerThanRecommendedTemperatureOptions,
			platingTemperatureRecommendations,
			gellingAgentsMaxMeltingPoints[[platingTemperatureLowerThanRecommendedPositions]],
			ObjectToString[platingTemperatureLowerThanRecommendedGellingAgents],
			gellingAgentsMaxMeltingPoints[[platingTemperatureLowerThanRecommendedPositions]]
		]
	];
	
	(* WARNING CHECK #2: Check that no two or more inputs are plated into the same single well. Possible, but just warn the user that this is happening, and to specify unique indices for the PlateOut if each media is supposed to go into its own well. *)
	PlateOutWellTuples = MapThread[Append[#1,#2]&,{resolvedPlateOuts,specifiedDestinationWells}];
	gatheredPlateOutWellTuples = Gather[PlateOutWellTuples];
	
	(* Resolution of PlatingVolume option, which will be automatically set to 50% of the MaxVolume of PlateOut model. *)
	containerMaxVolumes = Map[Lookup[Lookup[fastAssoc,#],MaxVolume]&,specifiedPlateOutModels];
	
	(* ERROR CHECK #4: Before resolving the PlatingVolume option, throw an error if the specified Model[Container,Plate] does not have its MaxVolume field populated. *)
	(* This information is necessary, since the option will be resolved to 50% of the plate's MaxVolume when unspecified by the user. *)
	plateOutMissingMaxVolumeErrorQ = MapThread[NullQ[#1]&&MatchQ[#2,Automatic]&,{containerMaxVolumes,specifiedPlatingVolumes}];
	plateOutMissingMaxVolumePositions = Flatten[Position[containerMaxVolumes,Null]];
	plateOutMissingMaxVolumeInputs = myMedia[[plateOutMissingMaxVolumePositions]];
	plateOutMissingMaxVolumeContainers = DeleteDuplicates[specifiedPlateOutModels[[plateOutMissingMaxVolumePositions]]];
	plateOutMissingMaxVolumeInvalidOptions = If[messages && Length[plateOutMissingMaxVolumePositions]>0,
		Message[Error::plateOutMissingMaxVolume,
			plateOutMissingMaxVolumePositions,
			ObjectToString[plateOutMissingMaxVolumeInputs],
			plateOutMissingMaxVolumeContainers
		];
		{PlateOut},
		{}
	];
	
	(* If MaxVolume is specified, throw an error if the specified volume exceeds the max volume. *)
	platingVolumeExceedsMaxVolumeErrorQs = MapThread[#1<#2&,{containerMaxVolumes,specifiedPlatingVolumes}];
	platingVolumeExceedsMaxVolumePositions = Flatten[Position[platingVolumeExceedsMaxVolumeErrorQs,True]];
	platingVolumeExceedsMaxVolumeInputs = myMedia[[platingVolumeExceedsMaxVolumePositions]];
	platingVolumeExceedsMaxVolumePlatingVolumes = specifiedPlatingVolumes[[platingVolumeExceedsMaxVolumePositions]];
	platingVolumeExceedsMaxVolumePlateOuts = specifiedPlateOutModels[[platingVolumeExceedsMaxVolumePositions]];
	platingVolumeExceedsMaxVolumeMaxVolumes = containerMaxVolumes[[platingVolumeExceedsMaxVolumePositions]];
	platingVolumeExceedsMaxVolumeInvalidOptions = If[messages && Length[platingVolumeExceedsMaxVolumePositions]>0,
		Message[Error::PlatingVolumeExceedsMaxVolume,
			platingVolumeExceedsMaxVolumePositions,
			ObjectToString[platingVolumeExceedsMaxVolumeInputs],
			platingVolumeExceedsMaxVolumePlatingVolumes,
			ObjectToString[platingVolumeExceedsMaxVolumePlateOuts],
			platingVolumeExceedsMaxVolumeMaxVolumes
		];
		{PlateOut,PlatingVolume},
		{}
	];
	
	(* Throw a warning, but not an error, if the specified volume exceeds 50% of the max volume. *)
	platingVolumeExceedsHalfMaxVolumeErrorQs = MapThread[0.5*#1<#2&,{containerMaxVolumes,specifiedPlatingVolumes}];
	platingVolumeExceedsHalfMaxVolumePositions = Flatten[Position[platingVolumeExceedsHalfMaxVolumeErrorQs,True]];
	platingVolumeExceedsHalfMaxVolumeInputs = myMedia[[platingVolumeExceedsHalfMaxVolumePositions]];
	platingVolumeExceedsHalfMaxVolumePlatingVolumes = specifiedPlatingVolumes[[platingVolumeExceedsHalfMaxVolumePositions]];
	platingVolumeExceedsHalfMaxVolumePlateOuts = specifiedPlateOutModels[[platingVolumeExceedsHalfMaxVolumePositions]];
	platingVolumeExceedsHalfMaxVolumeMaxVolumes = containerMaxVolumes[[platingVolumeExceedsHalfMaxVolumePositions]];
	If[messages && Length[platingVolumeExceedsHalfMaxVolumePositions]>0,
		Message[Warning::PlatingVolumeExceedsHalfMaxVolume,
			platingVolumeExceedsHalfMaxVolumePositions,
			ObjectToString[platingVolumeExceedsHalfMaxVolumeInputs],
			platingVolumeExceedsHalfMaxVolumePlatingVolumes,
			ObjectToString[platingVolumeExceedsHalfMaxVolumePlateOuts],
			platingVolumeExceedsHalfMaxVolumeMaxVolumes
		]
	];
	
	resolvedPlatingVolumes = MapThread[Function[{specifiedPlatingVolume,containerMaxVolume,destinationWells},
		Module[{platingVolume},
			platingVolume = If[!MatchQ[specifiedPlatingVolume,Automatic],
				specifiedPlatingVolume,
				RoundOptionPrecision[
					Convert[
						0.5*containerMaxVolume,
						Milliliter
					],
					10^-1*Milliliter,
					Round->Up
				]
			];
			Table[platingVolume,Length[destinationWells]]
		]],{specifiedPlatingVolumes,containerMaxVolumes,resolvedDestinationWells}
	];
	
	(* The actual insufficient media volume error check using auto-resolved DestinationWell & PlatingVolume options. *)
	(* At this point, there should be no Automatic values for options {NumberOfPlates, DestinationWell, PlatingVolume}. *)
	(* If the user is not satisfied with the auto-resolved options, they should go back and specify them. *)
	sampleVolumes = Lookup[samplePackets,Volume];
	{mediaVolumesNeeded,insufficientMediaVolumeErrorQs} = Transpose[MapThread[Function[{myMedium,sampleVolume,specifiedNumberOfPlates,resolvedPlatingVolume,resolvedDestinationWell},
		Module[{totalMediaVolumeNeeded,insufficientMediaVolumeErrorQ},
			totalMediaVolumeNeeded = Convert[
				1.15*specifiedNumberOfPlates*Length[resolvedDestinationWell]*resolvedPlatingVolume / $PercentPlatable,
				Milliliter
			];
			insufficientMediaVolumeErrorQ = Which[
				MatchQ[myMedium,ObjectP[Model[Sample,Media]]],
				False,
			
				MatchQ[myMedium,ObjectP[Object[Sample]]],
				totalMediaVolumeNeeded > sampleVolume
			];
			{
				totalMediaVolumeNeeded,
				insufficientMediaVolumeErrorQ
			}
		]
	],{myMedia,sampleVolumes,specifiedNumbersOfPlates,resolvedPlatingVolumes,resolvedDestinationWells}]];
	
	insufficientMediaVolumePositions = Flatten[Position[insufficientMediaVolumeErrorQs,True]];
	insufficientMediaVolumeInputs = ObjectToString[myMedia[[insufficientMediaVolumePositions]]];
	insufficientMediaVolumeTotalNeededVolumes = mediaVolumesNeeded[[insufficientMediaVolumePositions]];
	insufficientMediaVolumeNumberOfPlatesOptions = specifiedNumbersOfPlates[[insufficientMediaVolumePositions]];
	insufficientMediaVolumePlateOutOptions = ObjectToString[specifiedPlateOutModels[[insufficientMediaVolumePositions]]];
	insufficientMediaVolumeDestinationWellOptions = resolvedDestinationWells[[insufficientMediaVolumePositions]];
	insufficientMediaVolumeOptions = If[messages && Length[insufficientMediaVolumePositions]>0,
		Message[Error::InsufficientMediaVolumePerInput,
			insufficientMediaVolumePositions,
			ObjectToString[insufficientMediaVolumeInputs],
			insufficientMediaVolumeTotalNeededVolumes,
			insufficientMediaVolumeNumberOfPlatesOptions,
			ObjectToString[insufficientMediaVolumePlateOutOptions],
			insufficientMediaVolumeDestinationWellOptions
		];
		{PlatingVolume,NumberOfPlates},
		{}
	];
	
	(* ERROR CHECK #5 *)
	(* The same Object[Sample] may be specified multiple times as an input. While Check #3 considers the validity of NumberOfPlates & NumberOfWells options for a single Object[Sample] input, it does not check whether there is enough sample media to go around for ALL. *)
	
	optionsForGrouping = {
		PlateOut->specifiedPlateOuts,
		NumberOfPlates->specifiedNumbersOfPlates,
		DestinationWell->resolvedDestinationWells,
		PlatingVolume->resolvedPlatingVolumes,
		TotalMediaVolume->sampleVolumes,
		Index->Range[Length[myMedia]]
	};
	inputsAndOptionsForGrouping = Prepend[optionsForGrouping,Object->myMedia];
	inputsGroupedByObject = groupByKey[inputsAndOptionsForGrouping,{Object}][[All,2]];
	
	(* Resolve MaxPrePlatingIncubationTime option *)
	(* Don't need to round because PrePlatingIncubationTime is already rounded *)
	resolvedMaxPrePlatingIncubationTimes = MapThread[
		If[MatchQ[#2,Automatic],
			3*#1,
			#2
		]&,{specifiedPrePlatingIncubationTimes,specifiedMaxPrePlatingIncubationTimes}
	];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[roundedExperimentOptions, Email], Automatic] && NullQ[Lookup[roundedExperimentOptions,ParentProtocol]], True,
		MatchQ[Lookup[roundedExperimentOptions, Email], Automatic] && MatchQ[Lookup[roundedExperimentOptions,ParentProtocol], ObjectP[ProtocolTypes[]]], False,
		True, Lookup[roundedExperimentOptions, Email]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions,Sterile->True];
	
	resolvedOptions = ReplaceRule[
		Normal[roundedExperimentOptions],
		Flatten[{
			Instrument->resolvedInstruments,
			PlateOut->resolvedPlateOuts,
			DestinationWell->resolvedDestinationWells,
			PlatingVolume->resolvedPlatingVolumes,
			PlatingMethod->resolvedPlatingMethods,
			PlatingTemperature->resolvedPlatingTemperatures,
			PumpFlowRate->resolvedPumpFlowRates,
			MaxPrePlatingIncubationTime->resolvedMaxPrePlatingIncubationTimes,
			Email->email,
			resolvedPostProcessingOptions
		}]
	];
	
	invalidOptions = DeleteDuplicates[Flatten[{platingMethodPumpInstrumentMismatchInvalidOptions,platingMethodPumpFlowRateMismatchInvalidOptions,destinationWellPlateOutMismatchInvalidOptions,plateOutMissingMaxVolumeInvalidOptions,platingVolumeExceedsMaxVolumeInvalidOptions,insufficientMediaVolumeOptions}]];
	allTests = {};
	
	If[messages && Length[invalidOptions] > 0,
		Message[Error::InvalidOption,invalidOptions]
	];
	
	plateOutResources = plateMediaPlateOutResources[myMedia,resolvedOptions];
	
	outputSpecification/.{Result->resolvedOptions,Tests->allTests}
];

(* This is a helper function to, basically, order the plates by objects and then by models *)
reIndexContainerOut[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:KeyValuePattern[{PlateOut->platesOut_}]]:=Module[{mediaIndices,zeroIndexedList,zeroPlateIndexTuples,indexedPlates,unindexedPlates,newIndices,reindexedPlates,reorderedIndexedPlates},
	mediaIndices=Range[Length[myMedia]];

	(* Makes a list either of plate objects with per-media indices, or sets of {media index, 0, model of plate out} *)
	zeroIndexedList=MapThread[Function[{mediaIndex,plateOut},
		If[MatchQ[plateOut,ObjectP[Model[Container,Plate]]],
			{mediaIndex,0,plateOut},
			Prepend[plateOut,mediaIndex]
		]
	],{mediaIndices,platesOut}];

	(* Grabs all of the aforementioned indices with objects of plates out *)
	indexedPlates = Select[zeroIndexedList,!MatchQ[#[[2]],0]&];

	(* Grabs all of the aforementioned indices with models of plates out *)
	unindexedPlates = Select[zeroIndexedList,MatchQ[#[[2]],0]&];

	(* Grabs the number of indices corresponding to the numbers of models of plates out from the end of the overall list of indices *)
	newIndices = mediaIndices[[-Length[unindexedPlates];;]];

	(* Makes a newly indexed list of form: {old index, new index, plate model} *)
	reindexedPlates = MapThread[{#1[[1]],#2,#1[[3]]}&,{unindexedPlates,newIndices}];

	(* Reorders the plates: first objects, then models *)
	reorderedIndexedPlates = SortBy[Join[indexedPlates,reindexedPlates],First];

	(* Gets rid of redundant sub-indices *)
	reorderedIndexedPlates[[All,2;;3]]
];

expandedPlateOutByNumberOfPlate[indexedPlate:{plateIndex_Integer,plate:ObjectP[Model[Container]]},numberOfPlates_Integer]:=Module[{replicateIndices,plateReplicateIndices},
	replicateIndices = Map[ToString[#]&,Range[numberOfPlates]];
	plateReplicateIndices = Map[ToString[plateIndex]<>"."<>#&,replicateIndices];
	Map[{#,plate}&,plateReplicateIndices]
];

(* Helper function to get associations for resources for plating objects *)
samplesInPlatesResourceAssociation[myMedia:{ObjectP[{Object[Sample],Model[Sample, Media]}]..},myResolvedOptions:KeyValuePattern[{PlateOut->platesOut_,PlatingVolume->platingVolumes_,DestinationWell->destinationWells_,NumberOfPlates->numbersOfPlates_}]]:=Module[{numPlateExpandedMedia,numPlateExpandedPlatesOut,numPlateExpandedPlatingVolumes,numPlateExpandedDestinationWells,resourceKeyValueAssociations,resourceAssociationGroupedBySample},
	
	numPlateExpandedMedia = Flatten[
		MapThread[Function[{media,numberOfPlates},
			Table[media,numberOfPlates]
		],{myMedia,numbersOfPlates}],
		1
	];
		
	numPlateExpandedPlatesOut = Join@@MapThread[Function[{indexedPlate,numberOfPlates},
		expandedPlateOutByNumberOfPlate[indexedPlate,numberOfPlates]
	],{platesOut,numbersOfPlates}];
	
	numPlateExpandedPlatingVolumes = Flatten[
		MapThread[Function[{platingVolume,numberOfPlates},
			Table[platingVolume,numberOfPlates]
		],{platingVolumes,numbersOfPlates}],
		1
	];
	numPlateExpandedDestinationWells = Flatten[
		MapThread[Function[{destinationWell,numberOfPlates},
			Table[destinationWell,numberOfPlates]
		],{destinationWells,numbersOfPlates}],
		1
	];
	
	resourceKeyValueAssociations =
		MapThread[Function[{media,plate,wells,volume},
			Association[
				Sample->media,
				Container->plate,
				Well->wells,
				Amount->volume
			]
		],{numPlateExpandedMedia,numPlateExpandedPlatesOut,numPlateExpandedDestinationWells,numPlateExpandedPlatingVolumes}
	];
	
	resourceAssociationGroupedBySample = GatherBy[resourceKeyValueAssociations,Lookup[#,Sample]&];
	{
		resourceKeyValueAssociations,
		Map[Merge[#,Flatten]&,resourceAssociationGroupedBySample]
	}
];

(* Helper function to create the actual resources, either divided by well or not *)
sampleResourcesPerPlatePerWell[resourceAssociation:KeyValuePattern[{Sample->mySample:ObjectP[{Object[Sample],Model[Sample,Media]}],Container->{plateName_String,plateModel:ObjectP[Model[Container]]},Well->wells_,Amount->volumes_}]]:=Module[{},
	If[$WellSpecificResources,
		MapThread[Function[{well,volume},
			Resource[
				Sample->mySample,
				Container->plateModel,
				ContainerName->plateName,
				Well->well,
				Amount->volume
			]
		],{wells,ToList[volumes]}],
		Map[Function[{volume},
			Resource[
				Sample->mySample,
				Container->plateModel,
				Amount->volume
			]
		],ToList[volumes]]
	]
];

sufficientMediaForPlatingCheck[sampleResourceAssociation:KeyValuePattern[{Sample->myMedia:{ObjectP[{Model[Sample,Media],Object[Sample]}]..},Amount->amounts_}],Cache->cache_]:=Module[{media,totalVolumeNeeded,totalVolumePresent,insufficientMediaQ},
	media=First[myMedia];
	totalVolumeNeeded=1.15*Total[amounts];
	totalVolumePresent=If[MatchQ[media,ObjectP[Model[Sample,Media]]],Null,Download[media,Volume,Cache->cache]];
	insufficientMediaQ=!Or[NullQ[totalVolumePresent],totalVolumePresent>totalVolumeNeeded];
	{media,totalVolumeNeeded,totalVolumePresent,insufficientMediaQ}
];

resourceSampleContainer[mySample:ObjectP[{Model[Sample,Media],Object[Sample]}],volume:VolumeP,Cache->cache_]:=Module[{preferredPreparatoryContainerPackets,defaultPreparatoryContainerPacket},
	If[MatchQ[mySample,ObjectP[Model[Sample,Media]]],
		(
			preferredPreparatoryContainerPackets=Map[fetchPacketFromCache[#,cache]&,$PreferredPreparatoryContainers];
			(* Because in the overwhelming majority of cases we will be autoclaving, we need a bottle where the volume of the stock solution is no more than 75% of the volume of the container *)
			defaultPreparatoryContainerPacket=First[Select[preferredPreparatoryContainerPackets,
				Lookup[#,MaxVolume]>(4/3)*volume&&Lookup[#,MinVolume]<volume&]
			];
			Lookup[defaultPreparatoryContainerPacket,Object]
		),
		Download[mySample,Container[Object],Cache->cache]
	]
];

resourceSampleVolume[mySample:ObjectP[{Model[Sample,Media],Object[Sample]}],mySampleContainer:ObjectP[{Model[Container],Object[Container]}],volume:VolumeP,Cache->cache_]:=Module[{preparatoryContainerMinVolume},
	If[MatchQ[mySample,ObjectP[Model[Sample,Media]]],
		(
			preparatoryContainerMinVolume = Lookup[Lookup[cache,mySampleContainer],MinVolume];
			If[volume < $MinimumMediaVolume,
				$MinimumMediaVolume,
				volume
			]
		),
		Lookup[Lookup[cache,mySample],Volume]
	]
];

DefineOptions[plateMediaResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

plateMediaResourcePackets[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myUnresolvedOptions:{___Rule},myResolvedOptions:KeyValuePattern[{PlateOut->platesOut_,NumberOfPlates->numbersOfPlates_}],myOptions:OptionsPattern[]]:=Module[{
	safeOptionsPlateMediaResources,outputSpecification,listedOutput,gatherTests,messages,plateMediaResourceCache,plateMediaResourceFastAssoc,
	sampleResourceAssociationsPerSample,mediaResourceSamples,volumesNeeded,volumesPresent,insufficientMediaVolumeErrorQs,
	insufficientMediaVolumeErrorPositions,insufficientMediaVolumeErrorSamples,insufficientMediaVolumeErrorSampleVolumesNeeded,
	insufficientMediaVolumeErrorSampleVolumesPresent,insufficientMediaVolumeErrorInvalidOptions,resourceSampleAmounts,samplesInResourceAssociations,
	samplesInResources,expandedSamplesInResources,plateResourceLabels,containerModels,platesOutResources,resolvedPlatingMethods,resolvedPlatingVolumes,
	resolvedDestinationWells,resolvedPrePlatingMixRates,resolvedPlatingTemperatures,resolvedPumpFlowRates,resolvedSolidificationTimes,allResourceBlobs,
	fulfillable,frqTests,resourceSampleContainers,sampleResourceAssociationsPerContainer,invalidOptions,protocolPacket,preview,options,result,tests,
	resolvedInstruments,resolvedPrePlatingIncubationTimes,resolvedMaxPrePlatingIncubationTimes,instrumentResources,resourcePickingTime,
	incubationTime,transferTime,expandedPlatingVolumes,expandedDestinationWells,tipsResources,transferEnvironmentResource,
	biosafetyWasteBinResource,biosafetyWasteBagResource,flameSourceResource,plateBagsResources
},
	
	(* Determine the requested return value from the function *)
	safeOptionsPlateMediaResources = SafeOptions[plateMediaResourcePackets, ToList[myOptions]];
	outputSpecification = Lookup[safeOptionsPlateMediaResources, Output];
	listedOutput = ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput,Tests];
	messages = !gatherTests;
	
	plateMediaResourceCache = Lookup[myOptions,Cache];
	plateMediaResourceFastAssoc = makeFastAssocFromCache[plateMediaResourceCache];

	(* Here we are getting two sets of associations for resources: one divided by output container, and another divided by the samples that are going in *)
	{sampleResourceAssociationsPerContainer,sampleResourceAssociationsPerSample} = samplesInPlatesResourceAssociation[myMedia,myResolvedOptions];

	(* We're using the second division of resources above to make sure whether or not we have enough media to do all the plating. *)
	{mediaResourceSamples,volumesNeeded,volumesPresent,insufficientMediaVolumeErrorQs} = Transpose[Map[sufficientMediaForPlatingCheck[#,Cache->plateMediaResourceCache]&,sampleResourceAssociationsPerSample]];
	
	insufficientMediaVolumeErrorPositions = Flatten[Position[insufficientMediaVolumeErrorQs,True]];
	insufficientMediaVolumeErrorSamples = myMedia[[insufficientMediaVolumeErrorPositions]];
	insufficientMediaVolumeErrorSampleVolumesNeeded = volumesNeeded[[insufficientMediaVolumeErrorPositions]];
	insufficientMediaVolumeErrorSampleVolumesPresent = volumesPresent[[insufficientMediaVolumeErrorPositions]];
	
	insufficientMediaVolumeErrorInvalidOptions = If[messages && Length[insufficientMediaVolumeErrorPositions] > 0,
		Message[Error::InsufficientMediaForPlating,
			insufficientMediaVolumeErrorSamples,
			insufficientMediaVolumeErrorSampleVolumesNeeded,
			insufficientMediaVolumeErrorSampleVolumesPresent
		];
		{PlatingVolume,DestinationWell,NumberOfPlates},
		{}
	];
	
	resourceSampleContainers = MapThread[Function[{sample,volume},
		resourceSampleContainer[sample,volume,Cache->plateMediaResourceCache]
	],{mediaResourceSamples,volumesNeeded}];
	
	resourceSampleAmounts = MapThread[Function[{sample,container,volumeNeeded},
		resourceSampleVolume[sample,container,volumeNeeded,Cache->plateMediaResourceFastAssoc]
	],{mediaResourceSamples,resourceSampleContainers,volumesNeeded}];
	
	samplesInResourceAssociations = Association[
		MapThread[Function[{sample,container,volume,name},
			<|sample-><|Container->container,Volume->volume,Name->ToString[name]|>|>
		],{mediaResourceSamples,resourceSampleContainers,resourceSampleAmounts,Range[Length[mediaResourceSamples]]}]
	];
	
	samplesInResources = Map[Function[{media},
		Module[{mediaResourceAssociation, liquidMedia, container, amount, name},
			mediaResourceAssociation = Lookup[samplesInResourceAssociations,media];
			liquidMedia = Quiet[FirstOrDefault@Download[fastAssocLookup[plateMediaResourceFastAssoc, media, LiquidMedia], Object]];
			{container,amount,name} = Lookup[mediaResourceAssociation,{Container,Volume,Name}];
			Which[
				(* If the media has LiquidMedia field populated, it is a MediaPhase->Solid and this resource will ask for its liquid form*)
				MatchQ[liquidMedia, ObjectP[Model[Sample, Media]]],
					Resource[Sample -> liquidMedia, Container -> container, Amount -> amount, Name -> name],
				(* It is otherwise a media model, request the resource in an appropriate container *)
				MatchQ[media, ObjectP[Model[Sample, Media]]],
					Resource[Sample -> media, Container -> container, Amount -> amount, Name -> name],
				(* Otherwise requesting an object *)
				True,
					Resource[Sample->media,Amount->amount,Name->name]
			]
		]
	],myMedia];
	
	plateResourceLabels = Map[Table[CreateUUID[],#]&,numbersOfPlates];
	containerModels = platesOut[[All,2]];
	platesOutResources = Flatten[MapThread[Function[{containerModel,plateResourceLabel},
		Map[Link[Resource[Sample->containerModel,Name->#]]&,plateResourceLabel]
	],{containerModels,plateResourceLabels}]];
	
	{
		resolvedPlatingMethods,
		resolvedPlatingVolumes,
		resolvedDestinationWells,
		(*resolvedPrePlatingMixRates,*)
		resolvedPlatingTemperatures,
		resolvedPumpFlowRates,
		resolvedSolidificationTimes,
		resolvedInstruments,
		resolvedPrePlatingIncubationTimes,
		resolvedMaxPrePlatingIncubationTimes
	} = Lookup[myResolvedOptions,
		{
			PlatingMethod,
			PlatingVolume,
			DestinationWell,
			(*PrePlatingMixRate,*)
			PlatingTemperature,
			PumpFlowRate,
			SolidificationTime,
			Instrument,
			PrePlatingIncubationTime,
			MaxPrePlatingIncubationTime
		}
	];

	(* Use expanded plating volume *)
	{expandedPlatingVolumes,expandedDestinationWells} = Lookup[sampleResourceAssociationsPerSample, #]&/@{Amount, Well};

	(* Instrument resource *)
	instrumentResources = DeleteDuplicates[Flatten[Resource[Instrument -> #]&/@resolvedInstruments]];

	(* In the majority of cases, we are going to default to the exact same set of the following resources, so we will hardcode them here *)
	{
		tipsResources, transferEnvironmentResource, biosafetyWasteBinResource, biosafetyWasteBagResource, flameSourceResource,
		plateBagsResources
	} = If[MatchQ[containerModels,{ObjectP[Model[Container,Plate,"id:O81aEBZjRXvx"]]..}] && MatchQ[resolvedPlatingMethods, {Pour..}], (*"Omni Tray Sterile Media Plate"*)
		{
			ConstantArray[Link[Resource[Sample->Model[Item, Tips, "id:aXRlGnZmOJdv"]]], Length[samplesInResources]], (*"50 mL glass barrier serological pipets, sterile"*)
			Link[Resource[Instrument->Model[Instrument, HandlingStation, BiosafetyCabinet, "id:XnlV5jNYpXYP"]]], (*"Biosafety Cabinet Handling Station with Analytical Balance"*)
			Link[Resource[Sample->Model[Container, WasteBin, "id:1ZA60vzK7jl8"]]], (*"Biohazard Waste Container, BSC (Aseptic Transfer)"*)
			Link[Resource[Sample->Model[Item, Consumable, "id:7X104v6oeYNJ"]]], (*"Biohazard Waste Bags, 8x12"*)
			Link[Resource[Sample->Model[Part, Lighter, "id:M8n3rx07ZGa9"]]], (*"BIC Grill Lighter"*)
			ConstantArray[Link[Resource[Sample ->
				If[Length[
					Search[
						Object[Container, Bag, Aseptic],
						Model == Model[Container, Bag, Aseptic, "id:BYDOjvRD18Bq"] &&	(*"8x8 inch aseptic bag"*)
          	Status == (Available | Stocked) &&
					 	ContentsLog == {} &&
           	Notebook == (Null | $Notebook)
						&& Site == $Site
					]
				] > Length[platesOutResources],
					Model[Container, Bag, Aseptic, "id:BYDOjvRD18Bq"],
					Model[Container, Bag, Aseptic, "id:eGakldea0Kmo"] (*"12x12 inch aseptic bag"*)
				]
			]], Length[platesOutResources]]
		},
		{
			ConstantArray[Null, Length[samplesInResources]],
			Null,
			Null,
			Null,
			Null,
			ConstantArray[Null, Length[platesOutResources]]
		}
	];
	
	(* Fulfillable resources check *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[{samplesInResources,tipsResources,transferEnvironmentResource,biosafetyWasteBinResource,biosafetyWasteBagResource, flameSourceResource,
		plateBagsResources}],_Resource, Infinity]];
	{fulfillable,frqTests} = Which[
		MatchQ[$ECLApplication,Engine], {True,{}},
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages, Cache->plateMediaResourceCache, Simulation->Simulation[plateMediaResourceCache]], {}}
	];
	
	invalidOptions = DeleteDuplicates[Flatten[{insufficientMediaVolumeErrorInvalidOptions}]];

	(* Very roughly separate the time it will take to gather resources into whether we've requested an object or a model *)
	resourcePickingTime = If[MatchQ[myMedia,{ObjectP[Object[Sample]]..}],
		15*Minute,
		8*Hour
	];

	incubationTime = If[NullQ[resolvedPrePlatingIncubationTimes],1*Minute,Max[Cases[resolvedPrePlatingIncubationTimes,TimeP]]];

	transferTime = 30*Minute + If[NullQ[resolvedSolidificationTimes],1*Minute,Max[Cases[resolvedSolidificationTimes,TimeP]]];
	
	protocolPacket = <|
		Object->CreateID[Object[Protocol,PlateMedia]],
		Type->Object[Protocol,PlateMedia],
		Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
		Replace[PlatesOut]->Map[Link[#]&,platesOutResources],
		Replace[NumbersOfPlates]->numbersOfPlates,
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		
		Replace[PlatingMethods]->resolvedPlatingMethods,
		Replace[Volumes]->expandedPlatingVolumes,
		Replace[DestinationWells]->expandedDestinationWells,
		(*Replace[MixRates]->resolvedPrePlatingMixRates,*)
		Replace[Temperatures]->resolvedPlatingTemperatures,
		Replace[PouringRates]->resolvedPumpFlowRates,
		Replace[SolidificationTimes]->resolvedSolidificationTimes,
		Replace[Instruments]->instrumentResources,
		Replace[PrePlatingIncubationTimes]->resolvedPrePlatingIncubationTimes,
		Replace[MaxPrePlatingIncubationTimes]->resolvedMaxPrePlatingIncubationTimes,
		Replace[TotalIncubationTimes]->ConstantArray[0*Minute,Length[resolvedPrePlatingIncubationTimes]],
		Replace[PouringFailed]->ConstantArray[False,Length[resolvedPrePlatingIncubationTimes]],
		Replace[Incubators]->ConstantArray[Link[Model[Instrument, HeatBlock, "id:eGakldJWknme"]],Length[resolvedPrePlatingIncubationTimes]],(*"Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters"*)
		Replace[Tips]->tipsResources,
		TransferEnvironment->transferEnvironmentResource,
		Replace[BiosafetyWasteBin]->biosafetyWasteBinResource,
		Replace[BiosafetyWasteBag]->biosafetyWasteBagResource,
		FlameSource->flameSourceResource,
		Replace[PlateBags]->plateBagsResources,

		Replace[Checkpoints]->{
			{"Picking Resources",resourcePickingTime,"Samples, containers, and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.",
				Link[Resource[Operator -> $BaselineOperator, Time -> resourcePickingTime]]},
			{"Incubation",incubationTime,"The media are incubated prior to plating.",Link[Resource[Operator -> $BaselineOperator, Time -> incubationTime]]},
			{"Plating",transferTime,"The media are poured into plates and allowed to solidify.",Link[Resource[Operator -> $BaselineOperator, Time -> transferTime]]},
			{"Sample Post-Processing",30 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]}
		}
	|>;
	
	(* --- Outputs --- *)
	(* Generate Preview output *)
	preview = Null;
	
	(* Generate Options output *)
	options = If[MemberQ[listedOutput, Options],
		RemoveHiddenOptions[ExperimentPlateMedia, myResolvedOptions],
		Null
	];
	
	(* Generate Tests output *)
	tests = If[gatherTests,
		frqTests,
		{}
	];
	
	(* Generate Result output *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	result = If[Length[invalidOptions]==0 && MemberQ[listedOutput, Result] && TrueQ[fulfillable],
		protocolPacket,
		Message[Error::InvalidOption,invalidOptions];
		$Failed
	];
	
	outputSpecification/.{Preview->preview,Options->options,Result->result,Tests->tests}
];

ExperimentPlateMedia[myMedium:ObjectP[{Object[Sample],Model[Sample,Media]}],myOptions:OptionsPattern[ExperimentPlateMedia]]:=ExperimentPlateMedia[{myMedium},myOptions];

ExperimentPlateMedia[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:OptionsPattern[ExperimentPlateMedia]]:=Module[{outputSpecification,listedOutput,gatherTests,messages,listedMediaNamed,listedPlateMediaOptionsNamed,safeOptionsPlateMediaNamed,safeOptionsPlateMediaTests,cache,fastTrack,upload,simulation,listedMedia,safeOptionsPlateMedia,validLengths,validLengthTests,templatedPlateMediaOptions,templatedOptionsPlateMediaTests,inheritedPlateMediaOptions,expandedPlateMediaOptions,specifiedInstruments,specifiedPlateOuts,uniqueSpecifiedPlateOutsModels,pipetteInstrumentFields,sourceContainerFields,destinationContainerFields,preparatoryContainerFields,specifiedInstrumentsWithoutAutomatic,samplesDownloads,PlateOutDownloads,preparatoryContainerDownloads,instrumentsDownloads,newCache,resolvedPlateMediaOptionsResult,resolvedPlateMediaOptions,resolvedPlateMediaOptionsTests,collapsedResolvedPlateMediaOptions,returnEarlyQ,protocolPacket,protocolObject,result},
	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	listedOutput = ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput,Tests];
	messages = !gatherTests;
	
	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedMediaNamed,listedPlateMediaOptionsNamed} = removeLinks[ToList[myMedia],ToList[myOptions]];
	
	(* Call SafeOptions to make sure the option values match their patterns *)
	{safeOptionsPlateMediaNamed,safeOptionsPlateMediaTests} = If[gatherTests,
		SafeOptions[ExperimentPlateMedia,listedPlateMediaOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPlateMedia,listedPlateMediaOptionsNamed,AutoCorrect->False],{}}
	];
	If[MatchQ[safeOptionsPlateMediaNamed,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionsPlateMediaTests,
			Options->$Failed,
			Preview->Null,
			RunTime->0 Minute
		}]
	];
	
	{fastTrack,upload} = Lookup[safeOptionsPlateMediaNamed,{FastTrack,Upload}];
	cache = Lookup[safeOptionsPlateMediaNamed,Cache,{}];
	simulation = Lookup[safeOptionsPlateMediaNamed,Simulation,Null];
	
	{listedMedia,safeOptionsPlateMedia} = sanitizeInputs[listedMediaNamed,safeOptionsPlateMediaNamed, Simulation->simulation];

	(* If the specified options don't match their patterns or if sanitization failed return $Failed *)
	If[MatchQ[safeOptionsPlateMedia, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->safeOptionsPlateMediaTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];
	
	(* Check that the options are of correct lengths *)
	{validLengths,validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentPlateMedia,{listedMedia},safeOptionsPlateMedia,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentPlateMedia,{listedMedia},safeOptionsPlateMedia],{}}
	];
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionsPlateMediaTests,validLengthTests],
			Options->$Failed,
			Preview->Null,
			RunTime->0 Minute
		}]
	];
	
	(* Apply template options given a template protocol *)
	{templatedPlateMediaOptions,templatedOptionsPlateMediaTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentPlateMedia,{listedMedia},safeOptionsPlateMedia,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentPlateMedia,{listedMedia},safeOptionsPlateMedia],{}}
	];
	If[MatchQ[templatedPlateMediaOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionsPlateMediaTests,validLengthTests,templatedOptionsPlateMediaTests],
			Options->$Failed,
			Preview->Null,
			RunTime->0 Minute
		}]
	];
	
	inheritedPlateMediaOptions = ReplaceRule[safeOptionsPlateMedia,templatedPlateMediaOptions];
	expandedPlateMediaOptions = Last[ExpandIndexMatchedInputs[ExperimentPlateMedia,{listedMedia},inheritedPlateMediaOptions]];
	
	{specifiedInstruments,specifiedPlateOuts} = Lookup[expandedPlateMediaOptions,{Instrument,PlateOut}];
	uniqueSpecifiedPlateOutsModels = DeleteDuplicates[
		Map[If[MatchQ[#,{_Integer,ObjectP[Model[Container,Plate]]}],
			#[[2]],
			#
		]&,specifiedPlateOuts]
	];
	
	pipetteInstrumentFields = Sequence@@{MinVolume,MaxVolume};
	sourceContainerFields = Sequence@@{Dimensions};
	destinationContainerFields = Sequence@@{AllowedPositions,MinVolume,MaxVolume};
	preparatoryContainerFields = Sequence@@{AllowedPositions,Dimensions,MinVolume,MaxVolume};
	specifiedInstrumentsWithoutAutomatic = specifiedInstruments/.{Automatic->Nothing};
	
	{samplesDownloads,PlateOutDownloads,preparatoryContainerDownloads,instrumentsDownloads}=Quiet[Download[
		{
			myMedia,
			uniqueSpecifiedPlateOutsModels,
			$PreferredPreparatoryContainers,
			specifiedInstrumentsWithoutAutomatic
		},
		{
			{
				Packet[Model, Container, Volume, GellingAgents, LiquidMedia],
				Packet[Container][Model][Dimensions],
				Packet[Model[GellingAgents, LiquidMedia]],
				Packet[Model][GellingAgents[[All,2]]][Object,MeltingPoint],
				Packet[GellingAgents[[All,2]][Object,MeltingPoint]]
			},
			{
				Evaluate[Packet[destinationContainerFields]]
			},
			{
				Evaluate[Packet[preparatoryContainerFields]]
			},
			{
				Evaluate[Packet[pipetteInstrumentFields]]
			}
		}
	],{Download::FieldDoesntExist,Download::NotLinkField}];
	newCache = Cases[FlattenCachePackets[{samplesDownloads,PlateOutDownloads,preparatoryContainerDownloads,instrumentsDownloads}],PacketP[]];
	
	resolvedPlateMediaOptionsResult = Check[
		{resolvedPlateMediaOptions,resolvedPlateMediaOptionsTests} = If[gatherTests,
			resolvePlateMediaOptions[listedMedia,expandedPlateMediaOptions,Cache->newCache,Output->{Result,Tests}],
			{resolvePlateMediaOptions[listedMedia,expandedPlateMediaOptions,Cache->newCache],{}}
		],
		$Failed,
		{Error::InvalidOption}
	];
	
	(* Collapse the resolved options *)
	collapsedResolvedPlateMediaOptions = CollapseIndexMatchedOptions[
		ExperimentPlateMedia,
		resolvedPlateMediaOptions,
		Ignore->listedPlateMediaOptionsNamed,
		Messages->False
	];
	
	returnEarlyQ = Which[
		MatchQ[resolvedPlateMediaOptionsResult,$Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests"->resolvedPlateMediaOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True, False
	];
	
	If[returnEarlyQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOptionsPlateMediaTests,validLengthTests,resolvedPlateMediaOptionsTests}],
			Options->RemoveHiddenOptions[ExperimentPlateMedia,collapsedResolvedPlateMediaOptions],
			Preview->Null
		}]
	];
	
	protocolPacket = plateMediaResourcePackets[listedMedia,expandedPlateMediaOptions,resolvedPlateMediaOptions,Cache->newCache];
	protocolObject = Which[
		
		returnEarlyQ,
		$Failed,
		
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacket, $Failed],
		$Failed,

		(* If result is not in the output specification, return $Failed *)
		!MemberQ[listedOutput, Result],
		$Failed,
		
		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			protocolPacket,
			Upload->Lookup[safeOptionsPlateMedia, Upload],
			Confirm->Lookup[safeOptionsPlateMedia, Confirm],
			CanaryBranch -> Lookup[safeOptionsPlateMedia, CanaryBranch],
			ParentProtocol->Lookup[safeOptionsPlateMedia, ParentProtocol],
			Priority->Lookup[safeOptionsPlateMedia, Priority],
			StartDate->Lookup[safeOptionsPlateMedia, StartDate],
			HoldOrder->Lookup[safeOptionsPlateMedia, HoldOrder],
			QueuePosition->Lookup[safeOptionsPlateMedia, QueuePosition],
			ConstellationMessage->Object[Protocol,PlateMedia]
		]
	];

	result = protocolObject;

	outputSpecification /. {
		Result -> result,
		Options -> RemoveHiddenOptions[ExperimentPlateMedia,collapsedResolvedPlateMediaOptions],
		Tests -> resolvedPlateMediaOptionsTests,
		Preview -> Null
	}
];

(* --- SISTER FUNCTIONS ---*)

(* ::Subsubsection:: *)
(*ExperimentPlateMediaOptions*)

DefineOptions[ExperimentPlateMediaOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentPlateMedia}
];

(* --- Overloads --- *)

(* Overload 1: Singleton media model (pass to Overload 2) *)
ExperimentPlateMediaOptions[myMedium:ObjectP[{Object[Sample],Model[Sample,Media]}],myOptions:OptionsPattern[ExperimentPlateMediaOptions]]:=ExperimentPlateMediaOptions[{myMedium}, myOptions];

(* Overload 2: List of media models *)
ExperimentPlateMediaOptions[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:OptionsPattern[ExperimentPlateMediaOptions]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentNMR *)
	options = ExperimentPlateMedia[myMedia, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentPlateMedia],
		options
	]

];

(* ::Subsubsection:: *)
(*ValidExperimentPlateMediaQ*)

DefineOptions[ValidExperimentPlateMediaQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentPlateMedia}
];

(* --- Overloads --- *)

(* Overload 1: Singleton media model (pass to Overload 2) *)
ValidExperimentPlateMediaQ[myMedium:ObjectP[{Object[Sample],Model[Sample,Media]}],myOptions:OptionsPattern[ValidExperimentPlateMediaQ]]:=ValidExperimentPlateMediaQ[{myMedium}, myOptions];

(* Overload 2: List of media models *)
ValidExperimentPlateMediaQ[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:OptionsPattern[ValidExperimentPlateMediaQ]]:=Module[
	{listedOptions,optionsWithoutOutput,tests,initialTestDescription,allTests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)|(Verbose->_)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests = ExperimentPlateMedia[myMedia,Append[optionsWithoutOutput,Output->Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[tests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myMedia], _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myMedia], _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, tests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentPlateMediaQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentPlateMediaQ"]
];

(* ::Subsubsection:: *)
(*ExperimentPlateMediaPreview*)

DefineOptions[ExperimentPlateMediaPreview,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentPlateMedia}
];


(* --- Overloads --- *)

(* Overload 1: Singleton media model (pass to Overload 2) *)
ExperimentPlateMediaPreview[myMedium:ObjectP[{Object[Sample],Model[Sample,Media]}],myOptions:OptionsPattern[ExperimentPlateMediaPreview]]:=ExperimentPlateMediaPreview[{myMedium}, myOptions];

(* Overload 2: List of media models *)
ExperimentPlateMediaPreview[myMedia:{ObjectP[{Object[Sample],Model[Sample,Media]}]..},myOptions:OptionsPattern[ExperimentPlateMediaPreview]]:=Module[
	{listedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* add back in explicitly just the Preview Output option for passing to core function to get just preview *)
	ExperimentPlateMedia[myMedia,Append[listedOptions,Output->Preview]]
];

