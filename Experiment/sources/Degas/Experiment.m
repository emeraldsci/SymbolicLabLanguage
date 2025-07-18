(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDegas*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDegas Options and Messages*)


DefineOptions[ExperimentDegas,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(* --- Shared --- *)
			{
				OptionName->DegasType,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>DegasTypeP
				],
				Description->"Indicates which degassing type (freeze-pump-thaw, sparging, or vacuum degassing) should be used. Freeze-pump-thaw involves freezing the liquid, applying a vacuum to evacuate the headspace above the liquid, and then thawing the liquid to allow the decreased pressure of the headspace to lower the solubility of dissolved gases; this is usually repeated a few times to ensure thorough degassing. Sparging involves bubbling a chemically inert gas through the liquid for an extended period of time to aid in removal of dissolved gases. Vacuum degassing involves lowering the pressure of the headspace above the liquid to decrease solubility of the dissolved gases, while continually removing any bubbled out dissolved gases from the headspace.",
				ResolutionDescription->"If no options are provided, the sample volume will be used to determine the degassing type. Volumes under 50ml will default to freeze-pump-thaw, volumes between 50ml and 1L will default to vacuum degassing, while volumes above 1L will default to sparging.",
				AllowNull->False,
				Category->"General"
			},
			{
				OptionName->Instrument,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[
						{
							Model[Instrument,SpargingApparatus],
							Model[Instrument,VacuumDegasser],
							Model[Instrument,FreezePumpThawApparatus],
							Object[Instrument,SpargingApparatus],
							Object[Instrument,VacuumDegasser],
							Object[Instrument,FreezePumpThawApparatus]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Degassers"
						}
					}
				],
				Description->"Indicates which degassing instrument should be used.",
				ResolutionDescription->"If no options are provided, the instrument will be selected based on the degassing type.",
				AllowNull->False,
				Category->"General"
			},
			{
				OptionName->DissolvedOxygen,
				Default->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates whether dissolved oxygen measurements should be taken on a 25 milliliter aliquot of a sample using the dissolved oxygen meter, before and after the degassing procedure is performed. Aliquots are returned to their parent sample following measurements.  The dissolved oxygen measurements can only be taken on aqueous solutions and will expose the degassed sample to air.",
				AllowNull->False,
				Category->"General"
			},

			(* --- Freeze-Pump-Thaw --- *)
			(*Limited to 50ml or smaller*)
			{
				OptionName->FreezeTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,60*Minute],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be flash frozen by submerging the container in a dewar filled with liquid nitrogen during the freeze-pump-thaw procedure. This is the first step in the freeze-pump-thaw cycle.",
				ResolutionDescription->"If no options are provided, the freezing time will default to 3 minutes.",
				AllowNull->True,
				Category->"Freeze-Pump-Thaw"
			},
			{
				OptionName->PumpTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,60*Minute],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be vacuumed during the pump step of the freeze-pump-thaw procedure. The pump step evacuates the headspace above the frozen sample in preparation for the thawing step.",
				ResolutionDescription->"If no options are provided, the pump time will default to 2 minutes.",
				AllowNull->True,
				Category->"Freeze-Pump-Thaw"
			},
			{
				OptionName -> ThawTemperature,
				Default -> Automatic,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[$AmbientTemperature, 40 Celsius],
					Units -> Alternatives[Celsius, Fahrenheit, Kelvin]
				],
				Description -> "The temperature that the heat bath regulator will be set to for thawing the sample during the freeze-pump-thaw procedure.",
				ResolutionDescription -> "If no options are provided, automatically resolved to ambient temperature.",
				AllowNull -> True,
				Category -> "Freeze-Pump-Thaw"
			},
			{
				OptionName->ThawTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,6*Hour],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The minimum amount of time the sample will be thawed during the freeze-pump-thaw procedure. During the thaw step, the decreased headspace pressure from the pump step will decrease the solubility of dissolved gases in the thawed liquid, thereby causing dissolved gases to bubble out from the liquid as it thaws.",
				ResolutionDescription->"If no options are provided, the sample volume will be used to determine an estimated thawing time.",
				AllowNull->True,
				Category->"Freeze-Pump-Thaw"
			},
			{
				OptionName->NumberOfCycles,
				Default->Automatic,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,10]
				],
				Description->"The number of cycles of freezing the sample, evacuating the headspace above the sample, and then thawing the sample that will be performed as part of a single freeze-pump-thaw protocol.",
				ResolutionDescription->"If no options are provided, will default to 3 cycles for effective degassing.",
				AllowNull->True,
				Category->"Freeze-Pump-Thaw"
			},
			{
				OptionName -> FreezePumpThawContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[
						{
							Model[Container,Vessel],
							Object[Container,Vessel]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "The container that will hold the sample during Freeze Pump Thaw. No more than 50% of the volume of the container can be filled during Freeze Pump Thaw.",
				Category -> "Freeze-Pump-Thaw"
			},

			(* --- Vacuum Degas --- *)
			(*Toped off at bottle sizes,no Carboys,min size TBA,caps TBA*)
			{
				OptionName->VacuumPressure,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Milli*Bar,1050*Milli*Bar],
					Units->Alternatives[
						{Bar,{Milli*Bar,Bar}},
						{Torr,{Torr}},
						{Kilo*Pascal,{Kilo*Pascal,Pascal}},
						{PSI,{PSI}}
					]
				],
				Description->"The vacuum pressure that the vacuum pump regulator will be set to during the vacuum degassing procedure.",
				ResolutionDescription->"If no options are provided, will default to house vacuum pressure (150 mbar).",
				AllowNull->True,
				Category->"Vacuum Degas"
			},
			{
				OptionName->VacuumSonicate,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates whether or not the sample will be agitated by immersing the container in a sonicator during the vacuum degassing method.",
				ResolutionDescription->"If no options are provided, will default to True.",
				AllowNull->True,
				Category->"Vacuum Degas"
			},
			{
				OptionName->VacuumTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,$MaxExperimentTime],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be vacuumed during the vacuum degassing method.",
				ResolutionDescription->"If no options are provided, will default to 1 hour.",
				AllowNull->True,
				Category->"Vacuum Degas"
			},
			{
				OptionName->VacuumUntilBubbleless,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates whether vacuum degassing should be performed until the sample is entirely bubbleless, during the vacuum degassing method.",
				ResolutionDescription->"If no options are provided, will default to False.",
				AllowNull->True,
				Category->"Vacuum Degas"
			},
			{
				OptionName->MaxVacuumTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Minute,$MaxExperimentTime],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The maximum amount of time the sample will be vacuumed during the vacuum degassing procedure. This option is used when VacuumUntilBubbleless is set, and allows the user to set a maximum amount of experiment time that is allowed for the sample to reach a bubbleless state. The experiment will first vacuum degas the sample for the specified VacuumTime, then perform a check to see if the sample appears bubbleless. If not, additional vacuum time will be addded, up to a maximum of the specified MaxVacuumTime.",
				ResolutionDescription->"If no options are provided, will default to null unless VacuumUntilBubbleless is turned on, in which case it will default to"<>ToString[$MaxExperimentTime]<>".",
				AllowNull->True,
				Category->"Vacuum Degas"
			},


			(* --- Sparging --- *)
			(*No max size limit,small size limit>TBA ml*)
			{
				OptionName->SpargingGas,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>DegasGasP
				],
				Description->"Describes which inert gas (nitrogen, argon, or helium) will be used during the sparging method.",
				ResolutionDescription->"If no options are provided, will default to nitrogen gas.",
				AllowNull->True,
				Category->"Sparging"
			},
			{
				OptionName->SpargingTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,$MaxExperimentTime],(*TimeP*)
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be sparged during the sparging method.",
				ResolutionDescription->"If no options are provided, will default based on the sample volume.",
				AllowNull->True,
				Category->"Sparging"
			},
			{
				OptionName -> SpargingMix,
				Default -> Automatic,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sample undergoing sparging will be mixed during the sparing method.",
				ResolutionDescription -> "Automatically resolved to False if DegasType is set to Sparging. Otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Sparging"
			},

			(* --- Post-processing --- *)
			{
				OptionName->HeadspaceGasFlush,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[None,DegasGasP]
				],
				Description->"Describes which inert gas will be used to replace the headspace after degassing. None indicates that no specific gas will be used and that the sample will be exposed to the atmosphere when capping. For sparging, no headspace gas flushing can be performed.",
				AllowNull->False,
				Category->"PostProcessing"
			},
			{
				OptionName->HeadspaceGasFlushTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,$MaxExperimentTime],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be flushed with the headspace gas after degassing.",
				ResolutionDescription->"If HeadspaceGasFlush is None, will default to Null. If HeadspaceGasFlush is selected, will default based on the container volume. For sparging, no headspace gas flushing can be performed.",
				AllowNull->True,
				Category->"PostProcessing"
			},
			(* label options for manual primitives *)
				{
					OptionName -> SampleLabel,
					Default->Automatic,
					AllowNull->False,
					Widget->Widget[Type->String,Pattern:>_String,Size->Line],
					Description->"The label of the samples that are being analyzed, which is used for identification elsewhere in cell preparation.",
					Category->"General",
					UnitOperation -> True
				},
				{
					OptionName->SampleContainerLabel,
					Default->Automatic,
					AllowNull->False,
					Widget->Widget[Type->String,Pattern:>_String,Size->Line],
					Description->"The label of the sample's container that are being analyzed which is used for identification elsewhere in cell preparation.",
					Category->"General",
					UnitOperation -> True
				}

		],
		(*Note: not including NumberOfReplicates. For Sparging and VacuumDegas, you can just set the time to go on longer. For FreezePumpThaw, you would just add in more NumberOfCycles*)
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		SimulationOption,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelAmount
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve\"]."
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDegas Errors and Warnings*)
(*Messages thrown before options resolution*)


Error::DegasNoVolume="In ExperimentDegas, the following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if the sample can be degassed.";
Error::DegasNotLiquid="In ExperimentDegas, the following samples `1` are not liquid. The State of the sample must be liquid in order for the sample to be flash frozen.";

(* Conflicting options errors *)
Error::DegasTypeInstrumentMismatch="In ExperimentDegas, the option values for DegasType and Instrument (`1`) conflict for the following samples: `2`. Please specify a degas-type specific instrument, or select Automatic to allow the instrument to be resolved automatically.";
Error::FreezePumpThawOnlyMismatch="In ExperimentDegas, the DegasType must be FreezePumpThaw or Automatic for the option values FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles to be set (`1`), which conflicts for the following samples: `2`. Please modify the options accordingly, or set them as Automatic.";
Error::VacuumDegasOnlyMismatch="In ExperimentDegas, the DegasType must be VacuumDegas or Automatic for the option values VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVacuumTime to be set (`1`), which conflicts for the following samples: `2`. Please modify the options accordingly, or set them as Automatic.";
Error::SpargingOnlyMismatch="In ExperimentDegas, the DegasType must be Sparging or Automatic for the option values SpargingGas/SpargingTime to be set (`1`), which conflicts for the following samples: `2`. Please modify the options accordingly, or set them as Automatic.";
Error::DegasHeadspaceGasFlushOptions="In ExperimentDegas, if the HeadspaceGasFlush is None, the option HeadspaceGasFlushTime cannot be set (`1`), which conflicts for the following samples: `2`. Please modify either HeadSpaceGasFlush or HeadSpaceGasFlushTime accordingly, or set them as Automatic.";
Error::DegasHeadspaceGasFlushTimeOptions="In ExperimentDegas, if the HeadspaceGasFlush is not None, the option HeadspaceGasFlushTime cannot be Null (`1`), which conflicts for the following samples: `2`. Please modify either HeadSpaceGasFlush or HeadSpaceGasFlushTime accordingly, or set them as Automatic.";
Error::DegasMaxVacuumUntilBubbleless="In ExperimentDegas, VacuumUntilBubbleless must be True or Automatic for the option value MaxVacuumTime to be set (`1`), which conflicts for the following samples: `2`. Please change either MaxVacuumTime or VacuumUntilBubbleless accordingly, or set them as Automatic.";
Error::DegasGeneralOptionMismatch="In ExperimentDegas, options that correspond to more than one DegasType (`1`) cannot be simultaneously selected, which conflicts for the following samples:`2`. Please ensure that you have selected options corresponding to only one DegasType, or allow the options to resolve automatically.";
Error::DegasHeadspaceGasFlushTypeMismatch="In ExperimentDegas, the option values specified for HeadspaceGasFlush and Degas Type (`1`), conflict for the following samples: `2`. Please make sure that HeadspaceGasFlush is only set if the degas type is FreezePumpThaw or VacuumDegas, or leave this option as Automatic.";
Error::DegasSpargingNullMismatch="In ExperimentDegas, the option values specified for SpargingGas, SpargingTime cannot be Null if DegasType is Sparging (`1`), which conflict for the following samples: `2`. Please make sure that these options are not Null, or leave them as Automatic.";
Error::DegasVacuumDegasNullMismatch="In ExperimentDegas, the option values specified for VacuumPressure, VacuumSonicate, VacuumTime, VacuumUntilBubbleless, and MaxVacuumTime cannot be Null if DegasType is VacuumDegas (`1`), which conflict for the following samples: `2`. Please make sure that these options are not Null, or leave them as Automatic.";
Error::DegasFreezePumpThawNullMismatch="In ExperimentDegas, the option values specified for FreezeTime, PumpTime, ThawTemperature, ThawTime, NumberOfCycles, FreezePumpThawContainer cannot be Null if DegasType is FreezePumpThaw (`1`), which conflict for the following samples: `2`. Please make sure that these options are not Null, or leave them as Automatic.";
Error::DegasInstrumentOptionMismatch="In ExperimentDegas, options that do not correspond to the degas type related to the instrument selected (`1`) cannot be specified, which conflicts for the following samples:`2`. Please ensure that you have selected options corresponding to only the same DegasType as the specified Instrument would allow, or allow the options to resolve automatically.";
Error::DegasMaxVacuumTimeMismatch="In ExperimentDegas, VacuumTime must be less than or equal to MaxVacuumTime (`1`), which conflicts for the following samples: `2`.";

(*Other errors*)
Error::FreezePumpThawVolumeError="In ExperimentDegas, samples to be freeze-pump-thawed must have volumes (`1`) less than 50 mL, which conflicts for the following samples: `2`.";
Error::VacuumDegasVolumeError="In ExperimentDegas, samples to be vacuum degassed must have volumes (`1`) less than 4 L and greater than 5 mL, which conflicts for the following samples: `2`. Please use aliquot options to modify the sample volume in order for this experiment to be run.";
Error::SpargingVolumeError="In ExperimentDegas, samples to be sparged must have volumes (`1`) less than 16 L and greater than 50 mL, which conflicts for the following samples: `2`. Please use aliquot options to modify the sample volume in order for this experiment to be run.";
Error::FreezePumpThawInstrument="In ExperimentDegas, samples to be freeze-pump-thawed must have instruments (`1`) that are freeze-pump-thaw apparatuses, which conflicts for the following samples: `2`.";
Error::VacuumDegasInstrument="In ExperimentDegas, samples to be vacuum degassed must have instruments (`1`) that are vacuum degassers, which conflicts for the following samples: `2`.";
Error::SpargingInstrument="In ExperimentDegas, samples to be sparged must have instruments (`1`) that are sparging apparatuses, which conflicts for the following samples: `2`.";
Error::FreezePumpThawContainerError="In ExperimentDegas, the container specified for FreezePumpThawContainer `1`, is too small to safely be used to freeze-pump-thaw the sample, `2` or is not the right type of container. Please make sure that the FreezePumpThawContainer is a Schlenk flask and that the MaxVolume is at least 2x as much as the sample volume, or leave this option as Automatic.";
Error::HeadspaceGasFlushSpargingError="In ExperimentDegas, samples with degas type (`1`), are not compatible to have their headspace gas flushed after degassing, for the sample, `2`. Please make sure that HeadspaceGasFlush and HeadspaceGasFlushTime are only set if no sparging options are set, or leave these options as Automatic.";
Error::DegasDissolvedOxygenError="In ExperimentDegas, the value specified for DissolvedOxygen (`1`), are not compatible to be safely used to measure dissolved oxygen for the sample, `2`. Please make sure that DissolvedOxygen is only set to True if the sample is an aqueous sample, or leave this option as Automatic.";
Error::DegasDissolvedOxygenVolumeError="In ExperimentDegas, samples to have their DissolvedOxygen measured must have volumes (`1`) greater than 25 mL, which conflicts for the following samples: `2`. Please make sure that DissolvedOxygen is only set to True if the sample has at least 25 milliliter volume, or leave this option as Automatic.";

Warning::DegasVacuumTimeLow="In ExperimentDegas, the resolved VacuumTime (`1`) is too low for samples (`2`) and may result in insufficient degassing during vacuum degassing.";
Warning::DegasSpargingTimeLow="In ExperimentDegas, the resolved SpargingTime (`1`) is too low for samples (`2`) and may result in insufficient degassing during sparging.";

(* ::Subsubsection::Closed:: *)
(*ExperimentDegas*)
(* - Container to Sample Overload - *)

ExperimentDegas[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,listedContainers,cache,containerToSampleSimulation,
		samplePreparationSimulation},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions *)
	cache=ToList[Lookup[listedOptions, Cache, {}]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDegas,
			listedContainers,
			listedOptions,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*"10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"*)
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentDegas,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentDegas,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::EmptyWells, Error::WellDoesNotExist}
		]
	];


	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = {containerToSampleOutput[[1]],containerToSampleOutput[[2]]};

		(* Call our main function with our samples and converted options. *)
		ExperimentDegas[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

ExperimentDegas[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOptions,cacheOption,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		samplePreparationCache,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		optionsWithObjects,degasInstrumentModels,allInstrumentModels,possibleFreezePumpThawContainers,objectContainerPacketFields,modelContainerPacketFields,potentialContainerFields,allSamplePackets,
		instrumentModelPacket,instrumentObjectPacket,potentialContainerPacket,freezePumpThawContainerPacket,
		allObjects,objectSamplePacketFields,modelSamplePacketFields,modelContainerObjects,instrumentObjects,modelSampleObjects,sampleObjects,
		modelInstrumentObjects,containerObjects,objectContainerFields,modelContainerFields,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,updatedSimulation,
		returnEarlyQ, performSimulationQ,simulatedProtocol, simulation,cache
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(*Remove temporal links*)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption=ToList[Lookup[listedOptions,Cache,{}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDegas,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentDegas,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentDegas,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];
	
	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];
	
	cache = cacheOption;

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentDegas,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentDegas,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentDegas,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentDegas,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentDegas,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects={
		Instrument
	};

	instrumentObjects=Cases[Flatten@Lookup[expandedSafeOps,optionsWithObjects],ObjectP[{Object[Instrument,FreezePumpThawApparatus],Object[Instrument,VacuumDegasser],Object[Instrument,SpargingApparatus]}]];
	modelInstrumentObjects=Cases[Flatten@Lookup[expandedSafeOps,optionsWithObjects],ObjectP[{Model[Instrument,FreezePumpThawApparatus],Model[Instrument,VacuumDegasser],Model[Instrument,SpargingApparatus]}]];
	degasInstrumentModels=Search[{Model[Instrument,FreezePumpThawApparatus],Model[Instrument,VacuumDegasser],Model[Instrument,SpargingApparatus]}];
	allInstrumentModels=DeleteDuplicates@Cases[Join[modelInstrumentObjects,degasInstrumentModels],ObjectReferenceP[]];

	(*This is all of the possible freeze pump thaw flasks, which are schlenk flasks*)
	possibleFreezePumpThawContainers=DeleteDuplicates@Join[
		ToList[Lookup[safeOps,FreezePumpThawContainer]]/.Automatic->Nothing,
		{
			Model[Container, Vessel, "id:pZx9joxev3k0"], (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
			Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
			Model[Container, Vessel, "id:lYq9jRq5NE5O"], (*Model[Container, Vessel, "50 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
			Model[Container, Vessel, "id:o1k9jAkdNE0x"] (*Model[Container, Vessel, "100 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
		}
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet[
		(*For sample prep*)
		Sequence@@SamplePreparationCacheFields[Object[Sample]],
		(* For Experiment *)
		Density,RequestedResources,Notebook,IncompatibleMaterials,
		(*Safety and transport, previously from model*)
		Ventilated
	];

	modelSamplePacketFields=Packet[Model[Join[SamplePreparationCacheFields[Model[Sample]],{Notebook,
		IncompatibleMaterials,Density,Products}]]];

	objectContainerPacketFields=Packet[Container[SamplePreparationCacheFields[Object[Container]]]];

	modelContainerPacketFields=Packet[Container[Model][{
		Sequence@@SamplePreparationCacheFields[Model[Container]]
	}]];

	potentialContainerFields=Packet@@SamplePreparationCacheFields[Model[Container]];

	{
		allSamplePackets,
		instrumentObjectPacket,
		instrumentModelPacket,
		freezePumpThawContainerPacket
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				instrumentObjects,
				allInstrumentModels,
				possibleFreezePumpThawContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					objectContainerPacketFields,
					modelContainerPacketFields,

					(* Model Composition *)
					Packet[Composition[[All,2]][{Name,State,Density,Concentration,MolecularWeight}]]
				},
				{    (*Object[Instrument]*)
					Packet[Object,Name,Status,Model,SchlenkLine,VacuumPump,Dewar,HeatBlock,Sonicator,Mixer],
					Packet[Model[{Object,Name,Status,SchlenkLine,VacuumPump,Dewar,HeatBlock,Sonicator,NumberOfChannels,Mixer}]]
				},
				{    (*Model[Instrument]*)
					Packet[Object,Name,Status,Model,SchlenkLine,VacuumPump,Dewar,HeatBlock,Sonicator,NumberOfChannels,Mixer]
				},
				{
					potentialContainerFields
				}
			},
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	cacheBall=FlattenCachePackets[{
		cacheOption,allSamplePackets,instrumentModelPacket,instrumentObjectPacket,freezePumpThawContainerPacket
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentDegasOptions[ToList[mySamples],expandedSafeOps,Simulation->updatedSimulation,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentDegasOptions[ToList[mySamples],expandedSafeOps,Simulation->updatedSimulation,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentDegas,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentDegas,collapsedResolvedOptions],
			Preview->Null,
			Simulation->updatedSimulation
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets, resourcePacketTests} = If[returnEarlyQ,
		{$Failed, {}},
		If[gatherTests,
			degasResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Simulation -> updatedSimulation, Cache -> cacheBall, Output -> {Result, Tests}],
			{degasResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Simulation -> updatedSimulation, Cache -> cacheBall], {}}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentDegas[
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				ToList[resourcePackets[[2]]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation],
		{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentDegas,collapsedResolvedOptions],
			Preview->Null,
			Simulation->simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If we want to upload an actual protocol object. *)
		True,
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			ToList[resourcePackets[[2]]], (* unitOperationPackets *)
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			Cache -> cacheBall,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,Degas],
			Simulation->simulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentDegas,collapsedResolvedOptions],
		Preview->Null,
		Simulation->simulation
	}
];




(* ::Subsubsection::Closed:: *)
(*resolveExperimentDegasOptions *)


DefineOptions[
	resolveExperimentDegasOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentDegasOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentDegasOptions]]:=Module[
	{
		(*Boilerplate variables*)
		outputSpecification,output,gatherTests,cache,samplePrepOptions,degasOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
		degasOptionsAssociation,invalidInputs,invalidOptions,targetContainers,targetVolumes,resolvedAliquotOptions,aliquotTests,

		(* Sample, container, and instrument packets to download*)
		instrumentDownloadFields,listedSampleContainerPackets,samplePackets,sampleContainerPackets,sampleContainerModelPackets,sampleModelPackets,
		simulatedSampleContainerModels,simulatedSampleContainerObjects,sampleSolvents,

		(* Input validation *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,
		notLiquidInvalidInputs,notLiquidSamplePackets,notLiquidTest,

		(* for option rounding *)
		roundedExperimentOptions,optionsPrecisionTests,allOptionsRounded,

		(* options that do not need to be rounded *)
		instrument,name,

		(* conflicting options *)
		validNameQ,nameInvalidOption,validNameTest,
		degasTypeInstrumentMismatches,degasTypeInstrumentMismatchOptions,degasTypeInstrumentMismatchInputs,degasTypeInstrumentInvalidOptions,degasTypeInstrumentTest,
		freezePumpThawOnlyMismatches,freezePumpThawOnlyMismatchInputs,freezePumpThawOnlyMismatchOptions,freezePumpThawOnlyInvalidOptions,freezePumpThawOnlyTest,
		vacuumDegasOnlyMismatches,vacuumDegasOnlyMismatchInputs,vacuumDegasOnlyMismatchOptions,vacuumDegasOnlyInvalidOptions,vacuumDegasOnlyTest,
		maxVacuumUntilBubblelessMismatches,maxVacuumUntilBubblelessMismatchInputs,maxVacuumUntilBubblelessMismatchOptions,maxVacuumUntilBubblelessInvalidOptions,maxVacuumUntilBubblelessTest,
		spargingOnlyMismatches,spargingOnlyMismatchInputs,spargingOnlyMismatchOptions,spargingOnlyInvalidOptions,spargingOnlyTest,
		headSpaceGasFlushMismatches,headSpaceGasFlushMismatchInputs,headSpaceGasFlushMismatchOptions,headSpaceGasFlushInvalidOptions,headSpaceGasFlushOptionsTest,
		freezePumpThawExclusiveOptions,vacuumDegasExclusiveOptions,spargingExclusiveOptions,headspaceGasFlushTypeMismatchOptions,headspaceGasFlushTypeMismatchInputs,headspaceGasFlushTypeMismatchTest,headspaceGasFlushTypeMismatches,headspaceGasFlushTypeMismatchInvalidOptions,
		generalMismatchOptions,generalMismatchInputs,generalOptionMismatches,generalInvalidOptions,generalTest,
		headSpaceGasFlushTimeMismatches,headSpaceGasFlushTimeMismatchOptions,headSpaceGasFlushTimeMismatchInputs,headSpaceGasFlushTimeInvalidOptions,headSpaceGasFlushTimeOptionsTest,
		spargingNullMismatches,spargingNullMismatchOptions,spargingNullMismatchInputs,spargingNullInvalidOptions,spargingNullTest,
		vacuumDegasNullMismatches,vacuumDegasNullMismatchOptions,vacuumDegasNullMismatchInputs,vacuumDegasNullInvalidOptions,vacuumDegasNullTest,
		freezePumpThawNullMismatches,freezePumpThawNullMismatchOptions,freezePumpThawNullMismatchInputs,freezePumpThawNullInvalidOptions,freezePumpThawNullTest,
		instrumentOptionMismatches,instrumentMismatchOptions,instrumentMismatchInputs,instrumentInvalidOptions,instrumentOptionTest,
		maxVacuumTimeMismatches,maxVacuumTimeMismatchOptions,maxVacuumTimeMismatchInputs,maxVacuumTimeInvalidOptions,maxVacuumTimeTest,

		(* map thread*)
		mapThreadFriendlyOptions,volumes,
		resolvedDegasType,resolvedInstrument,resolvedFreezeTime,resolvedVacuumPressure,resolvedPumpTime,resolvedThawTemperature,
		resolvedThawTime,resolvedNumberOfCycles,resolvedFreezePumpThawContainer,resolvedVacuumSonicate,resolvedVacuumTime,resolvedVacuumUntilBubbleless,resolvedMaxVacuumTime,
		resolvedSpargingGas,resolvedSpargingTime,resolvedSpargingMix,resolvedHeadspaceGasFlush,resolvedHeadspaceGasFlushTime,resolvedDissolvedOxygen,

		(* Errors and Testing *)
		freezePumpThawInstrumentErrors,freezePumpThawVolumeErrors,freezePumpThawContainerErrors,freezePumpThawContainerWarnings,vacuumDegassingInstrumentErrors,vacuumDegassingVolumeErrors,vacuumDegassingSuitableContainerErrors,
		spargingInstrumentErrors,spargingVolumeErrors,spargingVolumeContainerLowErrors,spargingSuitableContainerErrors,headspaceGasFlushSpargingErrors,dissolvedOxygenErrors,allTests,suitableContainerErrors,vacuumTimeWarnings,aliquotMessage,
		dissolvedOxygenVolumeErrors,dissolvedOxygenVolumeInvalidOptions,dissolvedOxygenVolumeTest,
		freezePumpThawVolumeTest,freezePumpThawVolumeInvalidOptions,vacuumDegassingVolumeTest,vacuumDegassingVolumeInvalidOptions,spargingVolumeTest,spargingVolumeInvalidOptions,
		freezePumpThawInstrumentTest,freezePumpThawInstrumentInvalidOptions,vacuumDegassingInstrumentTest,vacuumDegassingInstrumentInvalidOptions,spargingInstrumentTest,spargingInstrumentInvalidOptions,
		vacuumTimeWarningTests,vacuumTimeWarningOptions,freezePumpThawContainerInvalidOptions,freezePumpThawContainerTest,headspaceGasFlushSpargingTest,headspaceGasFlushSpargingInvalidOptions,dissolvedOxygenInvalidOptions,dissolvedOxygenTest,
		spargingTimeWarnings,spargingTimeWarningTests,spargingTimeWarningOptions,
		resolvedOptions,resolvedPostProcessingOptions,resolvedEmail,

		(* misc options *)
		emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,samplesOutStorageOption,operator,
		validSampleStorageConditionQ,invalidStorageConditionOptions,

		(*unit operation support*)
		simulation,updatedSimulation,resolvedSampleLabel,resolvedSampleContainerLabel

	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our Degas options from our Sample Prep options. *)
	{samplePrepOptions,degasOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDegas,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDegas,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	degasOptionsAssociation=Association[degasOptions];

	(* DOWNLOAD: Extract the packets that we need from our downloaded cache. *)
	(* Get the instrument and name*)
	instrument=Lookup[degasOptionsAssociation,Instrument,Null];
	name=Lookup[degasOptionsAssociation,Name,Null];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	instrumentDownloadFields=Which[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument,FreezePumpThawApparatus]]],
		Packet[Model[{Object,LiquidNitrogenCapacity,InternalDimensions}]],

		(* If instrument is a Model, download fields*)
		MatchQ[instrument,ObjectP[Model[Instrument,FreezePumpThawApparatus]]],
		Packet[Object,LiquidNitrogenCapacity,InternalDimensions],

		True,
		Nothing
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our cache *)

	{listedSampleContainerPackets}=Quiet[Download[
		{
			simulatedSamples
		},
		{
			{
				Packet[Model,Status,Container,Volume,Composition,IncompatibleMaterials,State],
				Packet[Model[{IncompatibleMaterials,Composition,Name,Solvent,Density}]],
				Packet[Container[{Model,Contents}]],
				Packet[Container[Model][{MaxVolume,MinTemperature,Name,Object}]]
			}
		},
		Cache->cache,
		Simulation->updatedSimulation,
		Date->Now
	],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleContainerPackets=listedSampleContainerPackets[[All,3]];
	sampleContainerModelPackets=listedSampleContainerPackets[[All,4]];
	simulatedSampleContainerModels=Lookup[sampleContainerPackets,Model][Object];
	simulatedSampleContainerObjects=Lookup[sampleContainerPackets,Object,{}];
	sampleSolvents = Lookup[Flatten[samplePackets],Solvent,{}];

	(* -- TODO: Instrument packet --*)
	(*(* - Find the Model of the instrument, if it was specified - *)
	instrumentModel=If[
		MatchQ[instrumentPacket,{}],
		Null,
		FirstOrDefault[Lookup[Flatten[instrumentPacket],Object]]
	];*)

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(*- 1. Check if samples are discarded -*)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->cache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->cache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*- 2. Check if the samples have volume -*)
	(* Get the samples from simulatedSamples that do not have volume populated. *)
	noVolumeSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Volume->NullP]];
	noVolumeInvalidInputs=Lookup[noVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::DegasNoVolume,ObjectToString[noVolumeInvalidInputs,Cache->cache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Cache->cache]<>" have volume populated:",True,False]
			];

			passingTest=If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs],Cache->cache]<>" have volume populated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*- 3. Check if the samples are liquid -*)
	(*Get the samples from simulatedSamples that are not liquid*)
	notLiquidSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[State->Solid|Gas|Null]];
	notLiquidInvalidInputs=Lookup[notLiquidSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[notLiquidInvalidInputs]>0&&!gatherTests,
		Message[Error::DegasNotLiquid,ObjectToString[notLiquidInvalidInputs,Cache->cache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	notLiquidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[notLiquidInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[notLiquidInvalidInputs,Cache->cache]<>" are liquid:",True,False]
			];

			passingTest=If[Length[notLiquidInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,notLiquidInvalidInputs],Cache->cache]<>" are liquid:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	{roundedExperimentOptions,optionsPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[
			degasOptionsAssociation,
			{
				ThawTemperature,
				FreezeTime,
				PumpTime,
				ThawTime,
				VacuumTime,
				MaxVacuumTime,
				SpargingTime,
				HeadspaceGasFlushTime,
				VacuumPressure
			},
			{
				1 Celsius,
				1 Second,
				1 Second,
				1 Second,
				1 Second,
				1 Second,
				1 Second,
				1 Second,
				1 Milli*Bar
			},
			AvoidZero->{False,True,True,True,True,True,True,False,True},
			Output->{Result,Tests}
		],
		{
			RoundOptionPrecision[
				degasOptionsAssociation,
				{
					ThawTemperature,
					FreezeTime,
					PumpTime,
					ThawTime,
					VacuumTime,
					MaxVacuumTime,
					SpargingTime,
					HeadspaceGasFlushTime,
					VacuumPressure
				},
				{
					1 Celsius,
					1 Second,
					1 Second,
					1 Second,
					1 Second,
					1 Second,
					1 Second,
					1 Second,
					1 Milli*Bar
				}
			],
			Null
		}
	];

	allOptionsRounded=ReplaceRule[
		myOptions,
		Normal[roundedExperimentOptions],
		Append->False
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* - Check that the protocol name is unique - *)
	validNameQ=If[MatchQ[name,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,Degas,name]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"Degas protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a Degas protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(*- 1. DegasType and Instrument are compatible -*)
	degasTypeInstrumentMismatches=MapThread[
		Function[{degasType,instrument,sampleObject},
			(* Based on our mix type, make sure that the mix instrument matches. *)
			(* If the mix instrument doesn't match, return the options that mismatch and the input for which they mismatch. *)

			Switch[degasType,
				Sparging,
				If[MatchQ[instrument,ObjectP[{Model[Instrument,SpargingApparatus],Object[Instrument,SpargingApparatus]}]|Automatic],
					Nothing,
					{{degasType,instrument},sampleObject}
				],
				FreezePumpThaw,
				If[MatchQ[instrument,ObjectP[{Model[Instrument,FreezePumpThawApparatus],Object[Instrument,FreezePumpThawApparatus]}]|Automatic],
					Nothing,
					{{degasType,instrument},sampleObject}
				],
				VacuumDegas,
				If[MatchQ[instrument,ObjectP[{Model[Instrument,VacuumDegasser],Object[Instrument,VacuumDegasser]}]|Automatic],
					Nothing,
					{{degasType,instrument},sampleObject}
				],
				Automatic,
				Nothing,
				_,
				{{degasType,instrument},sampleObject}
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,Instrument],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{degasTypeInstrumentMismatchOptions,degasTypeInstrumentMismatchInputs}=If[MatchQ[degasTypeInstrumentMismatches,{}],
		{{},{}},
		Transpose[degasTypeInstrumentMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	degasTypeInstrumentInvalidOptions=If[Length[degasTypeInstrumentMismatchOptions]>0,
		Message[Error::DegasTypeInstrumentMismatch,degasTypeInstrumentMismatchOptions,ObjectToString[degasTypeInstrumentMismatchInputs,Cache->cache]];
		{DegasType,Instrument},

		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	degasTypeInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,degasTypeInstrumentMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options DegasType and Instrument match, for the inputs "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[degasTypeInstrumentMismatchInputs]>0,
				Test["The options DegasType and Instrument match, for the inputs "<>ObjectToString[degasTypeInstrumentMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 2. DegasType and FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles/FreezePumpThawContainer are compatible *)
	freezePumpThawOnlyMismatches=MapThread[
		Function[{degasType,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,sampleObject},
			(* FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles can only be set when DegasType is FreezePumpThaw or Automatic *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[freezeTime,Except[Null|Automatic]]||MatchQ[pumpTime,Except[Null|Automatic]]||MatchQ[thawTemperature,Except[Null|Automatic]]||MatchQ[thawTime,Except[Null|Automatic]]||MatchQ[numberOfCycles,_Integer]||MatchQ[freezePumpThawContainer,Except[Null|Automatic]])&&!MatchQ[degasType,FreezePumpThaw|Automatic],
				{{degasType,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,FreezeTime],Lookup[allOptionsRounded,PumpTime],Lookup[allOptionsRounded,ThawTemperature],Lookup[allOptionsRounded,ThawTime],Lookup[allOptionsRounded,NumberOfCycles],Lookup[allOptionsRounded,FreezePumpThawContainer],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{freezePumpThawOnlyMismatchOptions,freezePumpThawOnlyMismatchInputs}=If[MatchQ[freezePumpThawOnlyMismatches,{}],
		{{},{}},
		Transpose[freezePumpThawOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	freezePumpThawOnlyInvalidOptions=If[Length[freezePumpThawOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::FreezePumpThawOnlyMismatch,freezePumpThawOnlyMismatchOptions,freezePumpThawOnlyMismatchInputs];
		{DegasType,FreezeTime,PumpTime,ThawTemperature,ThawTime,NumberOfCycles,FreezePumpThawContainer},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	freezePumpThawOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,freezePumpThawOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles/FreezePumpThawContainer are only set when DegasType is FreezePumpThaw or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[freezePumpThawOnlyMismatchInputs]>0,
				Test["The options FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles/FreezePumpThawContainer are only set when DegasType is FreezePumpThaw or Automatic for the input(s) "<>ObjectToString[freezePumpThawOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 3. DegasType and VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVacuumTime are compatible *)
	vacuumDegasOnlyMismatches=MapThread[
		Function[{degasType,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,sampleObject},
			(* VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVacuumTime can only be set when DegasType is VacuumDegas or Automatic *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[vacuumPressure,Except[Null|Automatic]]||MatchQ[vacuumSonicate,Except[Null|Automatic]]||MatchQ[vacuumTime,Except[Null|Automatic]]||MatchQ[vacuumUntilBubbleless,Except[Null|Automatic]]||MatchQ[maxVacuumTime,Except[Null|Automatic]])&&!MatchQ[degasType,VacuumDegas|Automatic],
				{{degasType,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,VacuumPressure],Lookup[allOptionsRounded,VacuumSonicate],Lookup[allOptionsRounded,VacuumTime],Lookup[allOptionsRounded,VacuumUntilBubbleless],Lookup[allOptionsRounded,MaxVacuumTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{vacuumDegasOnlyMismatchOptions,vacuumDegasOnlyMismatchInputs}=If[MatchQ[vacuumDegasOnlyMismatches,{}],
		{{},{}},
		Transpose[vacuumDegasOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	vacuumDegasOnlyInvalidOptions=If[Length[vacuumDegasOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::VacuumDegasOnlyMismatch,vacuumDegasOnlyMismatchOptions,vacuumDegasOnlyMismatchInputs];
		{DegasType,VacuumPressure,VacuumSonicate,VacuumTime,VacuumUntilBubbleless,MaxVacuumTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	vacuumDegasOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,vacuumDegasOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVacuumTime are only set when DegasType is VacuumDegas or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[vacuumDegasOnlyMismatchInputs]>0,
				Test["The options VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVacuumTime are only set when DegasType is VacuumDegas or Automatic for the input(s) "<>ObjectToString[vacuumDegasOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 4. VacuumUntilBubbleless and MaxVacuumTime are compatible *)
	maxVacuumUntilBubblelessMismatches=MapThread[
		Function[{vacuumUntilBubbleless,maxVacuumTime,sampleObject},
			(* MaxVacuumTime can only be set when VacuumUntilBubbleless is set to True or Automatic. *)
			If[MatchQ[maxVacuumTime,Except[Null|Automatic]]&&!MatchQ[vacuumUntilBubbleless,True|Automatic],
				{{vacuumUntilBubbleless,maxVacuumTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,VacuumUntilBubbleless],Lookup[allOptionsRounded,MaxVacuumTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{maxVacuumUntilBubblelessMismatchOptions,maxVacuumUntilBubblelessMismatchInputs}=If[MatchQ[maxVacuumUntilBubblelessMismatches,{}],
		{{},{}},
		Transpose[maxVacuumUntilBubblelessMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxVacuumUntilBubblelessInvalidOptions=If[Length[maxVacuumUntilBubblelessMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasMaxVacuumUntilBubbleless,maxVacuumUntilBubblelessMismatchOptions,maxVacuumUntilBubblelessMismatchInputs];
		{DegasType,VacuumUntilBubbleless,MaxVacuumTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxVacuumUntilBubblelessTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,maxVacuumUntilBubblelessMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option MaxVacuumTime can only be set when VacuumUntilBubbleless is True or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxVacuumUntilBubblelessMismatchInputs]>0,
				Test["The option MaxVacuumTime can only be set when VacuumUntilBubbleless is True or Automatic for the input(s) "<>ObjectToString[maxVacuumUntilBubblelessMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 5. DegasType and SpargingGas/SpargingTime are compatible *)
	spargingOnlyMismatches=MapThread[
		Function[{degasType,spargingGas,spargingTime,sampleObject},
			(* SpargingGas/SpargingTime can only be set when DegasType is Sparging or Automatic *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[spargingGas,Except[Null|Automatic]]||MatchQ[spargingTime,Except[Null|Automatic]])&&!MatchQ[degasType,Sparging|Automatic],
				{{degasType,spargingGas,spargingTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,SpargingGas],Lookup[allOptionsRounded,SpargingTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{spargingOnlyMismatchOptions,spargingOnlyMismatchInputs}=If[MatchQ[spargingOnlyMismatches,{}],
		{{},{}},
		Transpose[spargingOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	spargingOnlyInvalidOptions=If[Length[spargingOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::SpargingOnlyMismatch,spargingOnlyMismatchOptions,spargingOnlyMismatchInputs];
		{DegasType,SpargingGas,SpargingTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	spargingOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,spargingOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options SpargingGas/SpargingTime are only set when DegasType is Sparging or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[spargingOnlyMismatchInputs]>0,
				Test["The options SpargingGas/SpargingTime are only set when DegasType is Sparging or Automatic for the input(s) "<>ObjectToString[spargingOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 6. HeadspaceGasFlush and HeadspaceGasFlushTime are compatible *)
	headSpaceGasFlushMismatches=MapThread[
		Function[{headSpaceGasFlush,headSpaceGasFlushTime,sampleObject},
			(* HeadspaceGasFlushTime can only be set when HeadspaceGasFlush is not None. *)
			If[(MatchQ[headSpaceGasFlushTime,Except[Null|Automatic]])&&MatchQ[headSpaceGasFlush,None],
				{{headSpaceGasFlush,headSpaceGasFlushTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,HeadspaceGasFlush],Lookup[allOptionsRounded,HeadspaceGasFlushTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{headSpaceGasFlushMismatchOptions,headSpaceGasFlushMismatchInputs}=If[MatchQ[headSpaceGasFlushMismatches,{}],
		{{},{}},
		Transpose[headSpaceGasFlushMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	headSpaceGasFlushInvalidOptions=If[Length[headSpaceGasFlushMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasHeadspaceGasFlushOptions,headSpaceGasFlushMismatchOptions,headSpaceGasFlushMismatchInputs];
		{HeadspaceGasFlush,HeadspaceGasFlushTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	headSpaceGasFlushOptionsTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,headSpaceGasFlushMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option HeadspaceGasFlushTime can only be set when HeadspaceGasFlush is not None for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[headSpaceGasFlushMismatchInputs]>0,
				Test["The option HeadspaceGasFlushTime can only be set when HeadspaceGasFlush is not None for the input(s) "<>ObjectToString[headSpaceGasFlushMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 7. If HeadspaceGasFlush is set, HeadspaceGasFlushTime cannot be Null *)
	headSpaceGasFlushTimeMismatches=MapThread[
		Function[{headSpaceGasFlush,headSpaceGasFlushTime,sampleObject},
			(* HeadspaceGasFlushTime can only be set when HeadspaceGasFlush is not None. *)
			If[(MatchQ[headSpaceGasFlushTime,Null])&&MatchQ[headSpaceGasFlush,Except[None|Automatic]],
				{{headSpaceGasFlush,headSpaceGasFlushTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,HeadspaceGasFlush],Lookup[allOptionsRounded,HeadspaceGasFlushTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{headSpaceGasFlushTimeMismatchOptions,headSpaceGasFlushTimeMismatchInputs}=If[MatchQ[headSpaceGasFlushTimeMismatches,{}],
		{{},{}},
		Transpose[headSpaceGasFlushTimeMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	headSpaceGasFlushTimeInvalidOptions=If[Length[headSpaceGasFlushTimeMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasHeadspaceGasFlushTimeOptions,headSpaceGasFlushTimeMismatchOptions,headSpaceGasFlushTimeMismatchInputs];
		{HeadspaceGasFlush,HeadspaceGasFlushTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	headSpaceGasFlushTimeOptionsTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,headSpaceGasFlushTimeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option HeadspaceGasFlushTime cannot be Null when HeadspaceGasFlush is not None for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[headSpaceGasFlushMismatchInputs]>0,
				Test["The option HeadspaceGasFlushTime cannot be Null when HeadspaceGasFlush is not None for the input(s) "<>ObjectToString[headSpaceGasFlushTimeMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Stash the list of options that are FreezePumpThaw Specific *)
	freezePumpThawExclusiveOptions={
		FreezeTime,
		PumpTime,
		ThawTemperature,
		ThawTime,
		NumberOfCycles,
		FreezePumpThawContainer
	};

	(* Stash the list of options that are VacuumDegas Specific *)
	vacuumDegasExclusiveOptions={
		VacuumPressure,
		VacuumSonicate,
		VacuumTime,
		VacuumUntilBubbleless,
		MaxVacuumTime
	};

	(* Stash the list of options that are Sparging Specific *)
	spargingExclusiveOptions={
		SpargingGas,
		SpargingTime,
		SpargingMix
	};

	(* 7. No conflicting options from different degas experiment types are picked at the same time *)

	generalOptionMismatches=MapThread[
		Function[{spargingGas,spargingTime,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,sampleObject},
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)
			Module[{spargingOptionsSet,freezePumpThawOptionsSet,vacuumDegasOptionsSet},

				(*Get the options that are set*)
				spargingOptionsSet=Select[{SpargingGas->spargingGas,SpargingTime->spargingTime},(MatchQ[#[[2]],Except[Null|Automatic]]&)];
				vacuumDegasOptionsSet=Select[{VacuumPressure->vacuumPressure,VacuumSonicate->vacuumSonicate,VacuumTime->vacuumTime,VacuumUntilBubbleless->vacuumUntilBubbleless,MaxVacuumTime->maxVacuumTime},(MatchQ[#[[2]],Except[Null|Automatic]]&)];
				freezePumpThawOptionsSet=Select[{FreezeTime->freezeTime,PumpTime->pumpTime,ThawTemperature->thawTemperature,ThawTime->thawTime,NumberOfCycles->numberOfCycles,FreezePumpThawContainer->freezePumpThawContainer},(MatchQ[#[[2]],Except[Null|Automatic]]&)];

				(* Do we have a conflict? *)
				Which[
					Length[spargingOptionsSet]>0&&Length[vacuumDegasOptionsSet]>0&&Length[freezePumpThawOptionsSet]==0,
					{{spargingOptionsSet,vacuumDegasOptionsSet},sampleObject},

					Length[spargingOptionsSet]>0&&Length[freezePumpThawOptionsSet]>0&&Length[vacuumDegasOptionsSet]==0,
					{{spargingOptionsSet,freezePumpThawOptionsSet},sampleObject},

					Length[vacuumDegasOptionsSet]>0&&Length[freezePumpThawOptionsSet]>0&&Length[spargingOptionsSet]==0,
					{{vacuumDegasOptionsSet,freezePumpThawOptionsSet},sampleObject},

					Length[vacuumDegasOptionsSet]>0&&Length[freezePumpThawOptionsSet]>0&&Length[spargingOptionsSet]>0,
					{{vacuumDegasOptionsSet,freezePumpThawOptionsSet,spargingOptionsSet},sampleObject},
					True,
					Nothing
				]
			]
		],
		{
			Lookup[allOptionsRounded,SpargingGas],
			Lookup[allOptionsRounded,SpargingTime],
			Lookup[allOptionsRounded,VacuumPressure],
			Lookup[allOptionsRounded,VacuumSonicate],
			Lookup[allOptionsRounded,VacuumTime],
			Lookup[allOptionsRounded,VacuumUntilBubbleless],
			Lookup[allOptionsRounded,MaxVacuumTime],
			Lookup[allOptionsRounded,FreezeTime],
			Lookup[allOptionsRounded,PumpTime],
			Lookup[allOptionsRounded,ThawTemperature],
			Lookup[allOptionsRounded,ThawTime],
			Lookup[allOptionsRounded,NumberOfCycles],
			Lookup[allOptionsRounded,FreezePumpThawContainer],
			simulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{generalMismatchOptions,generalMismatchInputs}=If[MatchQ[generalOptionMismatches,{}],
		{{},{}},
		Transpose[generalOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	generalInvalidOptions=If[Length[generalMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasGeneralOptionMismatch,generalMismatchOptions,ObjectToString[generalMismatchInputs,Cache->cache]];
		First/@Flatten[generalMismatchOptions],

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	generalTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,generalMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause DegasType to be ambiguously resolved "<>ObjectToString[passingInputs,Cache->cache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[generalMismatchInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause DegasType to be ambiguously resolved "<>ObjectToString[generalMismatchInputs,Cache->cache]<>":",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 8. DegasType and HeadspaceGasFlush/HeadspaceGasFlushTime are compatible *)
	headspaceGasFlushTypeMismatches=MapThread[
		Function[{degasType,headspaceGasFlush,headspaceGasFlushTime,sampleObject},
			(* headspaceGasFlush/headspaceGasFlushTime can only be set when DegasType is VacuumDegas, FreezePumpThaw or Automatic *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[headspaceGasFlush,Except[None|Automatic]]||MatchQ[headspaceGasFlushTime,Except[Null|Automatic]])&&!MatchQ[degasType,VacuumDegas|FreezePumpThaw|Automatic],
				{{degasType,headspaceGasFlush,headspaceGasFlushTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,HeadspaceGasFlush],Lookup[allOptionsRounded,HeadspaceGasFlushTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{headspaceGasFlushTypeMismatchOptions,headspaceGasFlushTypeMismatchInputs}=If[MatchQ[headspaceGasFlushTypeMismatches,{}],
		{{},{}},
		Transpose[headspaceGasFlushTypeMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	headspaceGasFlushTypeMismatchInvalidOptions=If[Length[headspaceGasFlushTypeMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasHeadspaceGasFlushTypeMismatch,headspaceGasFlushTypeMismatchOptions,headspaceGasFlushTypeMismatchInputs];
		{DegasType,HeadspaceGasFlush,HeadspaceGasFlushTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	headspaceGasFlushTypeMismatchTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,headspaceGasFlushTypeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options HeadspaceGasFlush/HeadspaceGasFlushTime are only set when DegasType is VacuumDegas, FreezePumpThaw, or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[spargingOnlyMismatchInputs]>0,
				Test["The options HeadspaceGasFlush/HeadspaceGasFlushTime are only set when DegasType is VacuumDegas, FreezePumpThaw, or Automatic for the input(s) "<>ObjectToString[spargingOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 9. If Sparging, SpargingGas/SpargingTime must not be null *)
	spargingNullMismatches=MapThread[
		Function[{degasType,spargingGas,spargingTime,sampleObject},
			(* SpargingGas/SpargingTime must not be Null when DegasType is Sparging *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[spargingGas,Null]||MatchQ[spargingTime,Null])&&MatchQ[degasType,Sparging],
				{{degasType,spargingGas,spargingTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,SpargingGas],Lookup[allOptionsRounded,SpargingTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{spargingNullMismatchOptions,spargingNullMismatchInputs}=If[MatchQ[spargingNullMismatches,{}],
		{{},{}},
		Transpose[spargingNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	spargingNullInvalidOptions=If[Length[spargingNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasSpargingNullMismatch,spargingNullMismatchOptions,spargingNullMismatchInputs];
		{DegasType,SpargingGas,SpargingTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	spargingNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,spargingNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options SpargingGas, SpargingTime cannot be Null when DegasType is Sparging, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[spargingNullMismatchInputs]>0,
				Test["The options SpargingGas, SpargingTime cannot be Null when DegasType is Sparging, for the input(s) "<>ObjectToString[spargingNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 10. If VacuumDegas, VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVauumTime must not be null *)
	vacuumDegasNullMismatches=MapThread[
		Function[{degasType,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,sampleObject},
			(* VacuumPressure/VacuumSonicate/VacuumTime/VacuumUntilBubbleless/MaxVauumTime must not be Null when DegasType is VacuumDegas *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[vacuumPressure,Null]||MatchQ[vacuumSonicate,Null]||MatchQ[vacuumTime,Null]||MatchQ[vacuumUntilBubbleless,Null]||MatchQ[maxVacuumTime,Null])&&MatchQ[degasType,VacuumDegas],
				{{degasType,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,VacuumPressure],Lookup[allOptionsRounded,VacuumSonicate],Lookup[allOptionsRounded,VacuumTime],Lookup[allOptionsRounded,VacuumUntilBubbleless],Lookup[allOptionsRounded,MaxVacuumTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{vacuumDegasNullMismatchOptions,vacuumDegasNullMismatchInputs}=If[MatchQ[vacuumDegasNullMismatches,{}],
		{{},{}},
		Transpose[vacuumDegasNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	vacuumDegasNullInvalidOptions=If[Length[vacuumDegasNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasVacuumDegasNullMismatch,vacuumDegasNullMismatchOptions,vacuumDegasNullMismatchInputs];
		{DegasType,VacuumPressure,VacuumSonicate,VacuumTime,VacuumUntilBubbleless,MaxVacuumTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	vacuumDegasNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,vacuumDegasNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options VacuumPressure, VacuumSonicate, VacuumTime, VacuumUntilBubbleless, and MaxVacuumTime cannot be Null when DegasType is VacuumDegas, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[vacuumDegasNullMismatchInputs]>0,
				Test["The options VacuumPressure, VacuumSonicate, VacuumTime, VacuumUntilBubbleless, and MaxVacuumTime cannot be Null when DegasType is VacuumDegas, for the input(s) "<>ObjectToString[vacuumDegasNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 11. If FreezePumpThaw, FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles/FreezePumpThawContainer must not be null *)
	freezePumpThawNullMismatches=MapThread[
		Function[{degasType,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,sampleObject},
			(* FreezeTime/PumpTime/ThawTemperature/ThawTime/NumberOfCycles/FreezePumpThawContainer must not be Null when DegasType is FreezePumpThaw *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[freezeTime,Null]||MatchQ[pumpTime,Null]||MatchQ[thawTemperature,Null]||MatchQ[thawTime,Null]||MatchQ[numberOfCycles,Null]||MatchQ[freezePumpThawContainer,Null])&&MatchQ[degasType,FreezePumpThaw],
				{{degasType,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DegasType],Lookup[allOptionsRounded,FreezeTime],Lookup[allOptionsRounded,PumpTime],Lookup[allOptionsRounded,ThawTemperature],Lookup[allOptionsRounded,ThawTime],Lookup[allOptionsRounded,NumberOfCycles],Lookup[allOptionsRounded,FreezePumpThawContainer],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{freezePumpThawNullMismatchOptions,freezePumpThawNullMismatchInputs}=If[MatchQ[freezePumpThawNullMismatches,{}],
		{{},{}},
		Transpose[freezePumpThawNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	freezePumpThawNullInvalidOptions=If[Length[freezePumpThawNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasFreezePumpThawNullMismatch,freezePumpThawNullMismatchOptions,freezePumpThawNullMismatchInputs];
		{DegasType,FreezeTime,PumpTime,ThawTemperature,ThawTime,NumberOfCycles,FreezePumpThawContainer},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	freezePumpThawNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,freezePumpThawNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options FreezeTime, PumpTime, ThawTemperature, ThawTime, NumberOfCycles, FreezePumpThawContainer cannot be Null when DegasType is FreezePumpThaw, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[freezePumpThawNullMismatchInputs]>0,
				Test["The options FreezeTime, PumpTime, ThawTemperature, ThawTime, NumberOfCycles, FreezePumpThawContainer cannot be Null when DegasType is FreezePumpThaw, for the input(s) "<>ObjectToString[freezePumpThawNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 12. If an instrument is set, options from a different conflicting degas type options have not been set *)

	instrumentOptionMismatches=MapThread[
		Function[{instrument,spargingGas,spargingTime,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,sampleObject},
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)
			Module[{spargingOptionsSet,freezePumpThawOptionsSet,vacuumDegasOptionsSet},

				(*Get the options that are set*)
				spargingOptionsSet=Select[{SpargingGas->spargingGas,SpargingTime->spargingTime},(MatchQ[#[[2]],Except[Null|Automatic]]&)];
				vacuumDegasOptionsSet=Select[{VacuumPressure->vacuumPressure,VacuumSonicate->vacuumSonicate,VacuumTime->vacuumTime,VacuumUntilBubbleless->vacuumUntilBubbleless,MaxVacuumTime->maxVacuumTime},(MatchQ[#[[2]],Except[Null|Automatic]]&)];
				freezePumpThawOptionsSet=Select[{FreezeTime->freezeTime,PumpTime->pumpTime,ThawTemperature->thawTemperature,ThawTime->thawTime,NumberOfCycles->numberOfCycles,FreezePumpThawContainer->freezePumpThawContainer},(MatchQ[#[[2]],Except[Null|Automatic]]&)];

				(* Do we have a conflict? *)
				Which[
					(Length[spargingOptionsSet]>0||Length[vacuumDegasOptionsSet]>0)&&MatchQ[instrument,ObjectP[{Object[Instrument,FreezePumpThawApparatus],Model[Instrument,FreezePumpThawApparatus]}]],
					{{instrument,spargingOptionsSet,vacuumDegasOptionsSet},sampleObject},

					(Length[spargingOptionsSet]>0||Length[freezePumpThawOptionsSet]>0)&&MatchQ[instrument,ObjectP[{Object[Instrument,VacuumDegasser],Model[Instrument,VacuumDegasser]}]],
					{{instrument,spargingOptionsSet,freezePumpThawOptionsSet},sampleObject},

					(Length[vacuumDegasOptionsSet]>0||Length[freezePumpThawOptionsSet]>0)&&MatchQ[instrument,ObjectP[{Object[Instrument,SpargingApparatus],Model[Instrument,SpargingApparatus]}]],
					{{instrument,vacuumDegasOptionsSet,freezePumpThawOptionsSet},sampleObject},

					True,
					Nothing
				]
			]
		],
		{
			Lookup[allOptionsRounded,Instrument],
			Lookup[allOptionsRounded,SpargingGas],
			Lookup[allOptionsRounded,SpargingTime],
			Lookup[allOptionsRounded,VacuumPressure],
			Lookup[allOptionsRounded,VacuumSonicate],
			Lookup[allOptionsRounded,VacuumTime],
			Lookup[allOptionsRounded,VacuumUntilBubbleless],
			Lookup[allOptionsRounded,MaxVacuumTime],
			Lookup[allOptionsRounded,FreezeTime],
			Lookup[allOptionsRounded,PumpTime],
			Lookup[allOptionsRounded,ThawTemperature],
			Lookup[allOptionsRounded,ThawTime],
			Lookup[allOptionsRounded,NumberOfCycles],
			Lookup[allOptionsRounded,FreezePumpThawContainer],
			simulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{instrumentMismatchOptions,instrumentMismatchInputs}=If[MatchQ[instrumentOptionMismatches,{}],
		{{},{}},
		Transpose[instrumentOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	instrumentInvalidOptions=If[Length[instrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasInstrumentOptionMismatch,instrumentMismatchOptions,ObjectToString[instrumentMismatchInputs,Cache->cache]];
		First/@Flatten[instrumentMismatchOptions],

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	instrumentOptionTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,instrumentMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have instrument objects set that conflict with options for other degas types, for the inputs "<>ObjectToString[passingInputs,Cache->cache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[instrumentMismatchInputs]>0,
				Test["The following object(s) do not have instrument objects set that conflict with options for other degas types, for the inputs "<>ObjectToString[generalMismatchInputs,Cache->cache]<>":",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 13. VacuumTime is less than or equal to MaxVacuumTime *)
	maxVacuumTimeMismatches=MapThread[
		Function[{vacuumTime,maxVacuumTime,sampleObject},
			(* MaxFreezingTime can only be set when FreezeUntilFrozen is set to True or Automatic. *)
			If[MatchQ[maxVacuumTime,Except[Null|Automatic]]&&MatchQ[vacuumTime,Except[Null|Automatic]],
				If[vacuumTime>maxVacuumTime,
					{{vacuumTime,maxVacuumTime},sampleObject},
					Nothing
				],
				Nothing
			]
		],
		{Lookup[allOptionsRounded,VacuumTime],Lookup[allOptionsRounded,MaxVacuumTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{maxVacuumTimeMismatchOptions,maxVacuumTimeMismatchInputs}=If[MatchQ[maxVacuumTimeMismatches,{}],
		{{},{}},
		Transpose[maxVacuumTimeMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxVacuumTimeInvalidOptions=If[Length[maxVacuumTimeMismatchOptions]>0&&!gatherTests,
		Message[Error::DegasMaxVacuumTimeMismatch,maxVacuumTimeMismatchOptions,maxVacuumTimeMismatchInputs];
		{VacuumTime,MaxVacuumTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxVacuumTimeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,maxVacuumTimeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The VacuumTime must be less than or equal to the MaxVacuumTime for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxVacuumTimeMismatchInputs]>0,
				Test["The VacuumTime must be less than or equal to the MaxVacuumTime for the input(s) "<>ObjectToString[maxVacuumTimeMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Pull out all the options *)
	(* These options are defaulted and are outside of the main map thread *)
	name=Lookup[allOptionsRounded,Name,Null];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentDegas,allOptionsRounded];

	(* MapThread over each of our samples. *)
	{
		resolvedDegasType,
		resolvedInstrument,
		resolvedFreezeTime,
		resolvedPumpTime,
		resolvedThawTemperature,
		resolvedThawTime,
		resolvedNumberOfCycles,
		resolvedFreezePumpThawContainer,
		resolvedVacuumPressure,
		resolvedVacuumSonicate,
		resolvedVacuumTime,
		resolvedVacuumUntilBubbleless,
		resolvedMaxVacuumTime,
		resolvedSpargingGas,
		resolvedSpargingTime,
		resolvedSpargingMix,
		resolvedHeadspaceGasFlush,
		resolvedHeadspaceGasFlushTime,
		resolvedDissolvedOxygen,

		(* Resolved Error Bools *)
		freezePumpThawInstrumentErrors,
		freezePumpThawVolumeErrors,
		freezePumpThawContainerErrors,
		freezePumpThawContainerWarnings,
		vacuumDegassingInstrumentErrors,
		vacuumDegassingVolumeErrors,
		vacuumDegassingSuitableContainerErrors,
		spargingInstrumentErrors,
		spargingVolumeErrors,
		spargingVolumeContainerLowErrors,
		spargingSuitableContainerErrors,
		headspaceGasFlushSpargingErrors,
		dissolvedOxygenErrors,
		dissolvedOxygenVolumeErrors,
		vacuumTimeWarnings,
		spargingTimeWarnings,
		volumes
	}=Transpose[MapThread[Function[{myMapThreadFriendlyOptions,mySample,mySampleContainerPackets,mySampleModelPackets},
		Module[{
			degasType,
			instrument,
			freezeTime,
			pumpTime,
			thawTemperature,
			thawTime,
			numberOfCycles,
			freezePumpThawContainer,
			vacuumPressure,
			vacuumSonicate,
			vacuumTime,
			vacuumUntilBubbleless,
			maxVacuumTime,
			spargingGas,
			spargingTime,
			spargingMix,
			headSpaceGasFlush,
			headSpaceGasFlushTime,
			dissolvedOxygen,

			(* Error checking booleans *)
			freezePumpThawInstrumentError,
			freezePumpThawVolumeError,
			freezePumpThawContainerError,
			freezePumpThawContainerWarning,
			vacuumDegassingInstrumentError,
			vacuumDegassingVolumeError,
			vacuumDegassingSuitableContainerError,
			spargingInstrumentError,
			spargingVolumeError,
			spargingVolumeContainerLowError,
			spargingSuitableContainerError,
			headspaceGasFlushSpargingError,
			dissolvedOxygenError,
			dissolvedOxygenVolumeError,
			vacuumTimeWarning,
			spargingTimeWarning,

			(*other variables*)
			sampleVolume,
			mySampVol,
			sampleContainerModelName,
			sampleContainerMaxVolume,
			composition,
			myComposition,
			freezePumpThawOptionValues,
			vacuumDegasOptionValues,
			spargingOptionValues,

			(* supplied option values *)
			supDegasType,
			supInstrument,
			supFreezeTime,
			supPumpTime,
			supThawTemperature,
			supThawTime,
			supNumberOfCycles,
			supFreezePumpThawContainer,
			supVacuumPressure,
			supVacuumSonicate,
			supVacuumTime,
			supVacuumUntilBubbleless,
			supMaxVacuumTime,
			supSpargingGas,
			supSpargingTime,
			supSpargingMix,
			supHeadspaceGasFlush,
			supHeadspaceGasFlushTime,
			supDissolvedOxygen
		},

			(* Setup our error and warning tracking variables *)
			{
				freezePumpThawInstrumentError,
				freezePumpThawVolumeError,
				freezePumpThawContainerError,
				freezePumpThawContainerWarning,
				vacuumDegassingInstrumentError,
				vacuumDegassingVolumeError,
				vacuumDegassingSuitableContainerError,
				spargingInstrumentError,
				spargingVolumeError,
				spargingVolumeContainerLowError,
				spargingSuitableContainerError,
				headspaceGasFlushSpargingError,
				dissolvedOxygenError,
				dissolvedOxygenVolumeError,
				vacuumTimeWarning,
				spargingTimeWarning
			}=ConstantArray[False,16];

			(* Store our general options in their variables*)
			{
				supDegasType,
				supInstrument,
				supHeadspaceGasFlush,
				supHeadspaceGasFlushTime,
				supDissolvedOxygen
			}=Lookup[myMapThreadFriendlyOptions,
				{
					DegasType,
					Instrument,
					HeadspaceGasFlush,
					HeadspaceGasFlushTime,
					DissolvedOxygen
				}
			];

			(* Store our FreezePumpThaw specific options in their variables *)
			freezePumpThawOptionValues={
				supFreezeTime,
				supPumpTime,
				supThawTemperature,
				supThawTime,
				supNumberOfCycles,
				supFreezePumpThawContainer
			}=Lookup[myMapThreadFriendlyOptions,freezePumpThawExclusiveOptions];

			(*Store our VacuumDegas specific options in their variables*)
			vacuumDegasOptionValues={
				supVacuumPressure,
				supVacuumSonicate,
				supVacuumTime,
				supVacuumUntilBubbleless,
				supMaxVacuumTime
			}=Lookup[myMapThreadFriendlyOptions,vacuumDegasExclusiveOptions];

			(*Store our VacuumDegas specific options in their variables*)
			spargingOptionValues={
				supSpargingGas,
				supSpargingTime,
				supSpargingMix
			}=Lookup[myMapThreadFriendlyOptions,spargingExclusiveOptions];

			(* Get the  volume of the sample. If the volume is missing, default to 0. We will have thrown an error above *)
			sampleVolume=Lookup[mySample,Volume];
			mySampVol=Max[Replace[sampleVolume,Null->0*Milli*Liter]];

			(*Get the container that the sample is in*)
			sampleContainerModelName=Lookup[mySampleContainerPackets,Name];

			(*Get the max volume of the container that the sample is in*)
			sampleContainerMaxVolume=Lookup[mySampleContainerPackets,MaxVolume];

			(*Get the solvent of the sample*)
			composition=Lookup[mySample,Composition][[All,2]][Object];
			myComposition=Lookup[cacheLookup[cache,composition],Name];

			(* Resolve Degas master switches *)

			degasType=Which[

				(* User has specified a degas type *)
				MatchQ[supDegasType,Except[Automatic]],
				supDegasType,

				(* User has specified an instrument. If this conflicts with the other options specified, we will have thrown an error already *)
				MatchQ[supInstrument,Except[Automatic|Null]],
				(* Pull the instrument's degas type *)
				Switch[supInstrument,
					Alternatives[ObjectP[Object[Instrument, FreezePumpThawApparatus]],ObjectP[Model[Instrument, FreezePumpThawApparatus]]],
					FreezePumpThaw,
					Alternatives[ObjectP[Object[Instrument, VacuumDegasser]],ObjectP[Model[Instrument, VacuumDegasser]]],
					VacuumDegas,
					Alternatives[ObjectP[Object[Instrument, SpargingApparatus]],ObjectP[Model[Instrument, SpargingApparatus]]],
					Sparging
				],

				(* Determine if FreezePumpThaw specific options are provided and no other option types are provided*)
				And[
					MemberQ[freezePumpThawOptionValues,Except[Automatic|Null]],
					!MemberQ[Join[vacuumDegasOptionValues,spargingOptionValues],Except[Automatic|Null]]
				],
				FreezePumpThaw,

				(* Determine if VacuumDegas specific options are provided and no other option types are provided*)
				And[
					MemberQ[vacuumDegasOptionValues,Except[Automatic|Null]],
					!MemberQ[Join[freezePumpThawOptionValues,spargingOptionValues],Except[Automatic|Null]]
				],
				VacuumDegas,

				(* Determine if Sparging specific options are provided and no other option types are provided*)
				And[
					MemberQ[spargingOptionValues,Except[Automatic|Null]],
					!MemberQ[Join[freezePumpThawOptionValues,vacuumDegasOptionValues],Except[Automatic|Null]]
				],
				Sparging,

				(*Sort remaining by sample volume && checking to ensure options for that one were not null*)
				Less[mySampVol,50*Milli*Liter]&&!MemberQ[freezePumpThawOptionValues,Null],
				FreezePumpThaw,
				Less[mySampVol,1*Liter]&&!MemberQ[vacuumDegasOptionValues,Null],
				VacuumDegas,
				!MemberQ[spargingOptionValues,Null],(*This takes care of the rest of the options. If the volume is >4L, an error will be thrown later*)
				Sparging,
				True,(*This takes care of the rest of the options. If the volume is not right, an error will be thrown later*)
				VacuumDegas
			];

			(* Based on the master switch, enter option resolution for the specific degas types *)
			{
				instrument,
				freezeTime,
				pumpTime,
				thawTemperature,
				thawTime,
				numberOfCycles,
				freezePumpThawContainer,
				vacuumPressure,
				vacuumSonicate,
				vacuumTime,
				vacuumUntilBubbleless,
				maxVacuumTime,
				spargingGas,
				spargingTime,
				spargingMix
			}=Switch[degasType,

				(* Resolved options for FreezePumpThaw *)
				FreezePumpThaw,
				Module[{resInst,resFreezeTime,resPumpTime,resThawTemperature,resThawTime,resNumberOfCycles,resFreezePumpThawContainer,
					defaultedUnnecessaryOptions},
					(* Is the Instrument specified by the user *)
					resInst=If[MatchQ[supInstrument,Automatic],
						Model[Instrument,FreezePumpThawApparatus,"High Tech FreezePumpThaw Apparatus"],
						supInstrument
					];

					(*Did the user specify an instrument that isn't a freeze pump thaw apparatus*)
					If[
						!MatchQ[resInst,ObjectP[{Object[Instrument,FreezePumpThawApparatus],Model[Instrument,FreezePumpThawApparatus]}]],
						freezePumpThawInstrumentError=True,

						(* Is the volume of the sample > 50 mL*)
						If[
							mySampVol>50*Milli*Liter,
							freezePumpThawVolumeError=True,

							(*Determine which freeze pump thaw flask size is appropriate. Sample volume cannot be more than 50% of the volume of the flask*)
							resFreezePumpThawContainer=Which[
								(*User supplied flask. Check volume for error and flask to be the right flask*)
								!MatchQ[supFreezePumpThawContainer,Automatic],
								If[And[
										Less[mySampVol,0.5*Lookup[cacheLookup[cache,supFreezePumpThawContainer],MaxVolume]],
										MatchQ[supFreezePumpThawContainer, ObjectP[{
											Model[Container, Vessel, "id:pZx9joxev3k0"], (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
											Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
											Model[Container, Vessel, "id:lYq9jRq5NE5O"], (*Model[Container, Vessel, "50 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
											Model[Container, Vessel, "id:o1k9jAkdNE0x"] (*Model[Container, Vessel, "100 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
										}]]
									],

									(*okay*)
									supFreezePumpThawContainer,

									(*Not compatible, cannot use*)
									(
										freezePumpThawContainerError=True;
										supFreezePumpThawContainer
									)
								],

								(*check to see if the actual flask is already a schlenk flask*)
								MatchQ[Lookup[mySampleContainerPackets,Object],ObjectP[{
									Model[Container, Vessel, "id:pZx9joxev3k0"], (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									Model[Container, Vessel, "id:lYq9jRq5NE5O"], (*Model[Container, Vessel, "50 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									Model[Container, Vessel, "id:o1k9jAkdNE0x"] (*Model[Container, Vessel, "100 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
								}]],
								Lookup[mySampleContainerPackets,Object],

								(*If no user supplied flask and not already a schlenk flask, then assign one based on volume*)
								True,
								Switch[2*mySampVol,
									LessEqualP[10 Milliliter],
										freezePumpThawContainerWarning=True;
										Model[Container, Vessel, "id:pZx9joxev3k0"], (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									RangeP[10 Milliliter,25 Milliliter,Inclusive->Right],
										freezePumpThawContainerWarning=True;
										Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									RangeP[25 Milliliter, 50 Milliliter,Inclusive->Right],
										freezePumpThawContainerWarning=True;
										Model[Container, Vessel, "id:lYq9jRq5NE5O"], (*Model[Container, Vessel, "50 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
									RangeP[50 Milliliter, 100 Milliliter,Inclusive->Right],
										freezePumpThawContainerWarning=True;
										Model[Container, Vessel, "id:o1k9jAkdNE0x"] (*Model[Container, Vessel, "100 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
								]

							];

							(*Is freezeTime specified*)
							resFreezeTime=If[
								MatchQ[supFreezeTime,Except[Automatic]],
								supFreezeTime,
								3 Minute
							];

							(*Is PumpTime specified*)
							resPumpTime=If[MatchQ[supPumpTime,Automatic],
								2 Minute,
								supPumpTime
							];

							(*Is ThawTemperature specified*)
							resThawTemperature=If[MatchQ[supThawTemperature,Automatic],
								$AmbientTemperature,
								supThawTemperature
							];

							(*Is ThawTime specified*)
							resThawTime=Which[
								MatchQ[supThawTime,Except[Automatic]],
								supThawTime,
								mySampVol<10*Milliliter,
								30 Minute,
								True,
								45 Minute
							];

							(*Is the NumberOfCycles specified*)
							resNumberOfCycles=If[MatchQ[supNumberOfCycles,Automatic],
								3,
								supNumberOfCycles
							];

						]
					];

					(* Default any options that are still automatic to Null. Leave user values untouched *)
					defaultedUnnecessaryOptions=Replace[#,Automatic->Null]&/@Join[vacuumDegasOptionValues,spargingOptionValues];
					{
						resInst,
						resFreezeTime,
						resPumpTime,
						resThawTemperature,
						resThawTime,
						resNumberOfCycles,
						resFreezePumpThawContainer,
						Sequence@@defaultedUnnecessaryOptions
					}
				],

				(* Resolved options for Vacuum Degas*)
				VacuumDegas,
				Module[{resInst,resVacuumPressure,resVacuumSonicate,resVacuumTime,resVacuumUntilBubbleless,resMaxVacuumTime,
					defaultedFreezePumpThawOptions,defaultedSpargingOptions},
					(* Is the Instrument specified by the user *)
					resInst=If[MatchQ[supInstrument,Automatic],
						Model[Instrument,VacuumDegasser,"High Tech Vacuum Degasser"],
						supInstrument
					];

					(*Did the user specify an instrument that isn't a vacuum degasser*)
					If[
						!MatchQ[resInst,ObjectP[{Object[Instrument,VacuumDegasser],Model[Instrument,VacuumDegasser]}]],
						vacuumDegassingInstrumentError=True,

						(* Is the volume of the sample > 3 L or < 5 mL*)
						If[
							!(4 Liter>mySampVol>5*Milli*Liter),
							vacuumDegassingVolumeError=True,

							(*Is the container either a glass bottle or a 50 mL tube*)
							If[!(StringContainsQ[sampleContainerModelName,"Glass Bottle"]||StringContainsQ[sampleContainerModelName,"50mL Tube"]),
								vacuumDegassingSuitableContainerError=True
							];

							(*Is VacuumPressure specified*)
							resVacuumPressure=If[MatchQ[supVacuumPressure,Automatic],
								150*Milli*Bar,(*defaults to house vacuum pressure *)
								supVacuumPressure
							];

							(*Is VacuumSonicate specified*)
							resVacuumSonicate=If[MatchQ[supVacuumSonicate,Automatic],
								True,
								supVacuumSonicate
							];

							(*Is VacuumUntilBubbleless specified*)
							resVacuumUntilBubbleless=If[MatchQ[supVacuumUntilBubbleless,Automatic],
								If[MatchQ[supMaxVacuumTime,Except[Automatic|Null]],
									True,
									False
								],
								supVacuumUntilBubbleless
							];

							(*Is MaxVacuumTime specified*)
							resMaxVacuumTime=If[MatchQ[resVacuumUntilBubbleless,False],
								Null,
								If[MatchQ[supMaxVacuumTime,Except[Automatic]],
									supMaxVacuumTime,
									$MaxExperimentTime
								]
							];

							(*Is VacuumTime specified*)
							resVacuumTime=If[MatchQ[supVacuumTime,Except[Automatic]],
								supVacuumTime,
								If[MatchQ[resMaxVacuumTime,Except[Null]],
									If[Less[resMaxVacuumTime,1 Hour],resMaxVacuumTime,1 Hour],
									1 Hour
								]
							];

							If[Greater[15 Minute,resVacuumTime],
								vacuumTimeWarning=True
							];
						]
					];

					(* Default any options that are still automatic to Null. Leave user values untouched *)
					defaultedFreezePumpThawOptions=Replace[#,Automatic->Null]&/@freezePumpThawOptionValues;
					defaultedSpargingOptions=Replace[#,Automatic->Null]&/@spargingOptionValues;

					{
						resInst,
						Sequence@@defaultedFreezePumpThawOptions,
						resVacuumPressure,
						resVacuumSonicate,
						resVacuumTime,
						resVacuumUntilBubbleless,
						resMaxVacuumTime,
						Sequence@@defaultedSpargingOptions
					}
				],

				(* Resolved options for Sparging*)
				Sparging,
				Module[{resInst,resSpargingGas,resSpargingTime,resSpargingMix,defaultedFreezePumpThawOptions,defaultedVacuumDegasOptions},
					(* Is the Instrument specified by the user *)
					resInst=If[MatchQ[supInstrument, Automatic],

						(* High Tech Sparging Apparatus *)
						Model[Instrument, SpargingApparatus, "id:BYDOjvGWoYa8"],
						supInstrument
					];


					(* Did the user specify an instrument that isn't a sparging apparatus *)
					spargingInstrumentError = !MatchQ[resInst,ObjectP[{Object[Instrument,SpargingApparatus],Model[Instrument,SpargingApparatus]}]];
					
					(* Is the volume of the sample < 15 L or > 50 mL *)
					spargingVolumeError = !(16 Liter>mySampVol>50*Milli*Liter);
					
					(* Is the sample less than 50% of the volume of the container *)
					spargingVolumeContainerLowError = If[!spargingVolumeError,
						mySampVol<0.5*sampleContainerMaxVolume,
						False
      					];

					(*Did the user specify an instrument that isn't a sparging apparatus*)
					spargingInstrumentError = !MatchQ[resInst, ObjectP[{Object[Instrument, SpargingApparatus],Model[Instrument,SpargingApparatus]}]];

					(* Is the volume of the sample < 15 L or > 50 mL*)
					spargingVolumeError = !(16 Liter > mySampVol > 50*Milli*Liter);

					(*Is the sample less than 50% of the volume of the container*)
					spargingVolumeContainerLowError = mySampVol < 0.5*sampleContainerMaxVolume;

					(*Is SpargingGas specified*)
					resSpargingGas = If[MatchQ[supSpargingGas, Automatic],
						Nitrogen,
						supSpargingGas
					];

					(*Is SpargingTime specified*)
					resSpargingTime = If[MatchQ[supSpargingTime, Automatic],
						30 Minute,(*TODO: need to test*)
						supSpargingTime
					];

					(* If a user provides the SpargingMix option, use the provide value.
					 Otherwise, it is resolved to False (it is defaulted to be False for now). *)
					resSpargingMix = If[MatchQ[supSpargingMix, Automatic],
						False,
						supSpargingMix
					];

					If[Greater[15 Minute, resSpargingTime],
						spargingTimeWarning=True
					];
					
					(* Additional sparging-related option checks provided that a sparging apparatus is specified *)
					resSpargingGas=If[MatchQ[supSpargingGas,Automatic],
						Nitrogen,
						supSpargingGas
					];
					
					(*Is SpargingTime specified*)
					resSpargingTime=If[MatchQ[supSpargingTime,Automatic],
						30 Minute,(*TODO: need to test*)
						supSpargingTime
					];
					
					If[Greater[15 Minute,resSpargingTime],
						spargingTimeWarning=True
					];
					
					(* Default any degas type specific options that are still automatic to Null. Leave user values untouched *)
					defaultedFreezePumpThawOptions=Replace[#,Automatic->Null]&/@freezePumpThawOptionValues;
					defaultedVacuumDegasOptions=Replace[#,Automatic->Null]&/@vacuumDegasOptionValues;
					
					{
						resInst,
						Sequence@@defaultedFreezePumpThawOptions,
						Sequence@@defaultedVacuumDegasOptions,
						resSpargingGas,
						resSpargingTime,
						resSpargingMix
					}
				]
			];

			(* Independent options resolution *)
			(*Head space gas flush*)
			headSpaceGasFlush=If[!MatchQ[supHeadspaceGasFlush,Except[Automatic]],
				(*If headspacegasflush was not supplied*)
				If[MatchQ[supHeadspaceGasFlushTime,Except[Null|Automatic]],
					(*If HeadspaceGasFlushTime was supplied*)
					If[!MatchQ[degasType,Sparging],
						(*If degastype did not resolve to sparging, then we are okay with flushing headspace gas*)
						Nitrogen,

						(*If degastype did resolve to sparging, throw an error since sparging should not have headspace gas flush, and set as None*)
						headspaceGasFlushSpargingError=True;
						None
					],

					(*If HeadspaceGasFlushTime was not supplied, default to None*)
					None
				],

				If[!MatchQ[degasType,Sparging],
					(*okay*)
					supHeadspaceGasFlush,

					(*If degasType is sparging, then throw an error if the supplied headspaceGasFlush was anything other than None*)
					(
						If[MatchQ[supHeadspaceGasFlush,Except[None]],
							headspaceGasFlushSpargingError=True];
						supHeadspaceGasFlush
					)
				]
			];

			(*Head space gas flush time*)
			(* check to see if it has been assigned. If there is a conflict we will have thrown an error above*)
			headSpaceGasFlushTime=If[MatchQ[supHeadspaceGasFlushTime,Except[Null|Automatic]],
				(* store saved value *)
				supHeadspaceGasFlushTime,

				(* if no specified, value, resolved based on if headspacegasflush was set*)
				If[MatchQ[headSpaceGasFlush,None],
				Null,
				10 Minute]
			];

			(*Resolve dissolved oxygen*)

			dissolvedOxygen=If[!MatchQ[supDissolvedOxygen,Except[Null|Automatic]],
				(* not specified, set to False*)
				False,

				(* specified. First check composition*)
				If[Nand[!MemberQ[ToList[myComposition],"Water"],supDissolvedOxygen==True],
					(* composition is okay, check volume next. If it isn't high enough to do dissolved oxygen before and after, throw an error*)
					If[Less[mySampVol,50 Milliliter]&&supDissolvedOxygen==True,
						dissolvedOxygenVolumeError=True;
					];
					supDissolvedOxygen,

					(*Not compatible, cannot use. Must be aqueous to use the dissolved oxygen sensor*)
					(
					dissolvedOxygenError=True;
					supDissolvedOxygen
					)
				]
			];

			(* Gather MapThread results *)
			{
				degasType,
				instrument,
				freezeTime,
				pumpTime,
				thawTemperature,
				thawTime,
				numberOfCycles,
				freezePumpThawContainer,
				vacuumPressure,
				vacuumSonicate,
				vacuumTime,
				vacuumUntilBubbleless,
				maxVacuumTime,
				spargingGas,
				spargingTime,
				spargingMix,
				headSpaceGasFlush,
				headSpaceGasFlushTime,
				dissolvedOxygen,

				(* Error checking booleans *)
				freezePumpThawInstrumentError,
				freezePumpThawVolumeError,
				freezePumpThawContainerError,
				freezePumpThawContainerWarning,
				vacuumDegassingInstrumentError,
				vacuumDegassingVolumeError,
				vacuumDegassingSuitableContainerError,
				spargingInstrumentError,
				spargingVolumeError,
				spargingVolumeContainerLowError,
				spargingSuitableContainerError,
				headspaceGasFlushSpargingError,
				dissolvedOxygenError,
				dissolvedOxygenVolumeError,
				vacuumTimeWarning,
				spargingTimeWarning,
				mySampVol
			}
		]
	],
		{mapThreadFriendlyOptions,samplePackets,sampleContainerModelPackets,sampleModelPackets}
	]];

	(* Pull out Miscellaneous options *)
	{emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,samplesOutStorageOption,operator}=
		Lookup[allOptionsRounded,
			{Email,Upload,Name,Confirm,CanaryBranch,ParentProtocol,FastTrack,Template,SamplesInStorageCondition,SamplesOutStorageCondition,Operator}];

	(*Generate the error messages and warnings from the errors and warnings*)
	(*Volumes*)
	(* (1) Check for FreezePumpThaw sample volume >50L errors *)
	freezePumpThawVolumeInvalidOptions=If[Or@@freezePumpThawVolumeErrors&&!gatherTests,
		Module[{freezePumpThawVolumeInvalidSamples,sampleVolumes},
			(* Get the samples that correspond to this error. *)
			freezePumpThawVolumeInvalidSamples=PickList[simulatedSamples,freezePumpThawVolumeErrors];

			(* Get the volumes of these samples. *)
			sampleVolumes=PickList[volumes,freezePumpThawVolumeErrors];

			(* Throw the corresopnding error. *)
			Message[Error::FreezePumpThawVolumeError,ObjectToString[sampleVolumes],ObjectToString[freezePumpThawVolumeInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DegasType,Volume}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	freezePumpThawVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,freezePumpThawVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,MapThread[(Xor[#1,MatchQ[#2,FreezePumpThaw]]&),{freezePumpThawVolumeErrors,resolvedDegasType}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are under 50 mL if they are to be freeze-pump-thawed.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are under 50 mL if they are to be freeze-pump-thawed.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (2) Check for VacuumDegas sample volume >1 L errors *)
	vacuumDegassingVolumeInvalidOptions=If[Or@@vacuumDegassingVolumeErrors&&!gatherTests,
		Module[{vacuumDegassingVolumeInvalidSamples,sampleVolumes},
			(* Get the samples that correspond to this error. *)
			vacuumDegassingVolumeInvalidSamples=PickList[simulatedSamples,vacuumDegassingVolumeErrors];

			(* Get the volumes of these samples. *)
			sampleVolumes=PickList[volumes,vacuumDegassingVolumeErrors];

			(* Throw the corresopnding error. *)
			Message[Error::VacuumDegasVolumeError,ObjectToString[sampleVolumes],ObjectToString[vacuumDegassingVolumeInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DegasType,Volume}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	vacuumDegassingVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,vacuumDegassingVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,MapThread[(Xor[#1,MatchQ[#2,VacuumDegas]]&),{vacuumDegassingVolumeErrors,resolvedDegasType}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are under 4 L and greater than 5 mL if they are to be vacuum degassed.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are under 4 L and greater than 5 mL if they are to be vacuum degassed.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (3) Check for Sparging sample volume < 4L errors *)
	spargingVolumeInvalidOptions=If[Or@@spargingVolumeErrors&&!gatherTests,
		Module[{spargingVolumeInvalidSamples,sampleVolumes},
			(* Get the samples that correspond to this error. *)
			spargingVolumeInvalidSamples=PickList[simulatedSamples,spargingVolumeErrors];

			(* Get the volumes of these samples. *)
			sampleVolumes=PickList[volumes,spargingVolumeErrors];

			(* Throw the corresopnding error. *)
			Message[Error::SpargingVolumeError,ObjectToString[sampleVolumes],ObjectToString[spargingVolumeInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DegasType,Volume}
		],
		{}
	];

	(* Create the corresponding test for the sparging sample volume error. *)
	spargingVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,spargingVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,MapThread[(Xor[#1,MatchQ[#2,Sparging]]&),{spargingVolumeErrors,resolvedDegasType}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are under 16 L and greater than 50 mL if they are to be sparged.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are under 16 L and greater than 50 mL if they are to be sparged.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*instruments*)
	(* (4) Check for user given incompatible instruments for freeze pump thaw. *)
	freezePumpThawInstrumentInvalidOptions=If[Or@@freezePumpThawInstrumentErrors&&!gatherTests,
		Module[{freezePumpThawInstrumentInvalidSamples,freezePumpThawInvalidInstruments},
			(* Get the samples that correspond to this error. *)
			freezePumpThawInstrumentInvalidSamples=PickList[simulatedSamples,freezePumpThawInstrumentErrors];

			(* Get the corresponding invalid thaw instruments. *)
			freezePumpThawInvalidInstruments=PickList[resolvedInstrument,freezePumpThawInstrumentErrors];

			(* Throw the corresopnding error. *)
			Message[Error::FreezePumpThawInstrument,ObjectToString[freezePumpThawInvalidInstruments,Cache->cache],ObjectToString[freezePumpThawInstrumentInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{Instrument,DegasType}
		],
		{}
	];

	(* Create the corresponding test for the invalid thaw instrument error. *)
	freezePumpThawInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,freezePumpThawInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,freezePumpThawInstrumentErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have instruments that match the FreezePumpThaw DegasType.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have instruments that match the FreezePumpThaw DegasType.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (5) Check for user given incompatible instruments for vacuum degas. *)
	vacuumDegassingInstrumentInvalidOptions=If[Or@@vacuumDegassingInstrumentErrors&&!gatherTests,
		Module[{vacuumDegassingInstrumentInvalidSamples,vacuumDegassingInvalidInstruments},
			(* Get the samples that correspond to this error. *)
			vacuumDegassingInstrumentInvalidSamples=PickList[simulatedSamples,vacuumDegassingInstrumentErrors];

			(* Get the corresponding invalid thaw instruments. *)
			vacuumDegassingInvalidInstruments=PickList[resolvedInstrument,vacuumDegassingInstrumentErrors];

			(* Throw the corresopnding error. *)
			Message[Error::VacuumDegasInstrument,ObjectToString[vacuumDegassingInvalidInstruments,Cache->cache],ObjectToString[vacuumDegassingInstrumentInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{Instrument,DegasType}
		],
		{}
	];

	(* Create the corresponding test for the invalid thaw instrument error. *)
	vacuumDegassingInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,vacuumDegassingInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,vacuumDegassingInstrumentErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have instruments that match the VacuumDegas DegasType.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have instruments that match the VacuumDegas DegasType.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (6) Check for user given incompatible instruments for sparging. *)
	spargingInstrumentInvalidOptions=If[Or@@spargingInstrumentErrors&&!gatherTests,
		Module[{spargingInstrumentInvalidSamples,spargingInvalidInstruments},
			(* Get the samples that correspond to this error. *)
			spargingInstrumentInvalidSamples=PickList[simulatedSamples,spargingInstrumentErrors];

			(* Get the corresponding invalid thaw instruments. *)
			spargingInvalidInstruments=PickList[resolvedInstrument,spargingInstrumentErrors];

			(* Throw the corresopnding error. *)
			Message[Error::SpargingInstrument,ObjectToString[spargingInvalidInstruments,Cache->cache],ObjectToString[spargingInstrumentInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{Instrument,DegasType}
		],
		{}
	];

	(* Create the corresponding test for the invalid thaw instrument error. *)
	spargingInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,spargingInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,spargingInstrumentErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have instruments that match the Sparging DegasType.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have instruments that match the Sparging DegasType.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (7) Throw a Warning message if the user specified a VacuumTime < 15 minutes *)
	If[MemberQ[vacuumTimeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::DegasVacuumTimeLow,ObjectToString[PickList[resolvedVacuumTime,vacuumTimeWarnings],Cache->cache],ObjectToString[PickList[simulatedSamples,vacuumTimeWarnings],Cache->cache]]
	];

	(* generate the tests *)
	vacuumTimeWarningTests=If[gatherTests,
		Module[{failingVacuumTimes,passingVacuumTimes,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingVacuumTimes=PickList[resolvedVacuumTime,vacuumTimeWarnings];

			(* get the inputs that pass this test *)
			passingVacuumTimes=PickList[resolvedVacuumTime,vacuumTimeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[MemberQ[vacuumTimeWarnings,True],
				Test["The VacuumTime, "<>ObjectToString[failingVacuumTimes,Cache->cache]<>" is less than 15 minutes and may result in insufficient degassing during the vacuum degassing procedure:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[MemberQ[vacuumTimeWarnings,False],
				Test["The VacuumTime, "<>ObjectToString[passingVacuumTimes,Cache->cache]<>" is less than 15 minutes and may result in insufficient degassing during the vacuum degassing procedure:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	vacuumTimeWarningOptions=If[MemberQ[vacuumTimeWarnings,True],
		{VacuumTime},
		Nothing
	];

	(* (8) Check for FreezePumpThaw container errors *)
	freezePumpThawContainerInvalidOptions=If[Or@@freezePumpThawContainerErrors&&!gatherTests,
		Module[{freezePumpThawContainerInvalidSamples,fptContainers},
			(* Get the samples that correspond to this error. *)
			freezePumpThawContainerInvalidSamples=PickList[simulatedSamples,freezePumpThawContainerErrors];

			(* Get the volumes of these samples. *)
			fptContainers=PickList[resolvedFreezePumpThawContainer,freezePumpThawContainerErrors];

			(* Throw the corresopnding error. *)
			Message[Error::FreezePumpThawContainerError,ObjectToString[fptContainers],ObjectToString[freezePumpThawContainerInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DegasType,FreezePumpThawContainer}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	freezePumpThawContainerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,freezePumpThawContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,MapThread[(Xor[#1,MatchQ[#2,FreezePumpThaw]]&),{freezePumpThawContainerErrors,resolvedDegasType}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The freeze pump thaw containers for the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are not freeze-pump-thaw compatible containers.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The freeze-pump-thaw containers for the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are not freeze-pump-thaw compatible containers.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (9) Check for dissolved oxygen meter errors *)
	dissolvedOxygenInvalidOptions=If[Or@@dissolvedOxygenErrors&&!gatherTests,
		Module[{dissolvedOxygenInvalidSamples,dissolvedOxygenMeasurements},
			(* Get the samples that correspond to this error. *)
			dissolvedOxygenInvalidSamples=PickList[simulatedSamples,dissolvedOxygenErrors];

			(* Get the volumes of these samples. *)
			dissolvedOxygenMeasurements=PickList[resolvedDissolvedOxygen,dissolvedOxygenErrors];

			(* Throw the corresopnding error. *)
			Message[Error::DegasDissolvedOxygenError,ObjectToString[dissolvedOxygenMeasurements],ObjectToString[dissolvedOxygenInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DissolvedOxygen}
		],
		{}
	];

	(* Create the corresponding test for the invalid dissolved oxygen error. *)
	dissolvedOxygenTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,dissolvedOxygenErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,dissolvedOxygenErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" can have their dissolved oxygen levels measured using the dissolved oxygen meter (aqueous samples only).",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" can have their dissolved oxygen levels measured using the dissolved oxygen meter (aqueous samples only).",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (10) Check for headspaceGasFlush Sparging errors *)
	headspaceGasFlushSpargingInvalidOptions=If[Or@@headspaceGasFlushSpargingErrors&&!gatherTests,
		Module[{headspaceGasFlushSpargingInvalidSamples,pickedDegasTypes},
			(* Get the samples that correspond to this error. *)
			headspaceGasFlushSpargingInvalidSamples=PickList[simulatedSamples,headspaceGasFlushSpargingErrors];

			(* Get the volumes of these samples. *)
			pickedDegasTypes=PickList[resolvedDegasType,headspaceGasFlushSpargingErrors];

			(* Throw the corresopnding error. *)
			Message[Error::HeadspaceGasFlushSpargingError,ObjectToString[pickedDegasTypes],ObjectToString[headspaceGasFlushSpargingInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DegasType,HeadspaceGasFlush,HeadSpaceGasFlushTime}
		],
		{}
	];

	(* Create the corresponding test for the invalid dissolved oxygen error. *)
	headspaceGasFlushSpargingTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,headspaceGasFlushSpargingErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,headspaceGasFlushSpargingErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" cannot have their headspace gas flushed after the experiment if the degas type is sparging.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" cannot have their headspace gas flushed after the experiment if the degas type is sparging.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (11) Check for dissolved oxygen volume errors *)
	dissolvedOxygenVolumeInvalidOptions=If[Or@@dissolvedOxygenVolumeErrors&&!gatherTests,
		Module[{dissolvedOxygenVolumeInvalidSamples,sampleVolumes},
			(* Get the samples that correspond to this error. *)
			dissolvedOxygenVolumeInvalidSamples=PickList[simulatedSamples,dissolvedOxygenVolumeErrors];

			(* Get the volumes of these samples. *)
			sampleVolumes=PickList[volumes,dissolvedOxygenVolumeErrors];

			(* Throw the corresopnding error. *)
			Message[Error::DegasDissolvedOxygenVolumeError,ObjectToString[sampleVolumes],ObjectToString[dissolvedOxygenVolumeInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DissolvedOxygen,Volume}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	dissolvedOxygenVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,dissolvedOxygenVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,dissolvedOxygenVolumeErrors];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are at least 50 mL if they are to have their dissolved oxygen measured before and after degassing.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are at least 50 mL if they are to have their dissolved oxygen measured before and after degassing.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* (12) Throw a Warning message if the user specified a SpargingTime < 15 minutes *)
	If[MemberQ[spargingTimeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::DegasSpargingTimeLow,ObjectToString[PickList[resolvedSpargingTime,spargingTimeWarnings],Cache->cache],ObjectToString[PickList[simulatedSamples,spargingTimeWarnings],Cache->cache]]
	];

	(* generate the tests *)
	spargingTimeWarningTests=If[gatherTests,
		Module[{failingSpargingTimes,passingSpargingTimes,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSpargingTimes=PickList[resolvedSpargingTime,spargingTimeWarnings];

			(* get the inputs that pass this test *)
			passingSpargingTimes=PickList[resolvedSpargingTime,spargingTimeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[MemberQ[spargingTimeWarnings,True],
				Test["The SpargingTime, "<>ObjectToString[failingSpargingTimes,Cache->cache]<>" is less than 15 minutes and may result in insufficient degassing during the sparging procedure:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[MemberQ[spargingTimeWarnings,False],
				Test["The SpargingTime, "<>ObjectToString[passingSpargingTimes,Cache->cache]<>" is less than 15 minutes and may result in insufficient degassing during the sparging procedure:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	spargingTimeWarningOptions=If[MemberQ[spargingTimeWarnings,True],
		{SpargingTime},
		Nothing
	];


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,noVolumeInvalidInputs,notLiquidInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{nameInvalidOption,degasTypeInstrumentInvalidOptions,freezePumpThawOnlyInvalidOptions,vacuumDegasOnlyInvalidOptions,
		maxVacuumUntilBubblelessInvalidOptions,spargingOnlyInvalidOptions,headSpaceGasFlushInvalidOptions,headSpaceGasFlushTimeInvalidOptions,generalInvalidOptions,headspaceGasFlushTypeMismatchOptions,freezePumpThawVolumeInvalidOptions,
		vacuumDegassingVolumeInvalidOptions,spargingVolumeInvalidOptions,freezePumpThawContainerInvalidOptions,headspaceGasFlushSpargingInvalidOptions,dissolvedOxygenInvalidOptions,dissolvedOxygenVolumeInvalidOptions,
		spargingNullInvalidOptions,vacuumDegasNullInvalidOptions,freezePumpThawNullInvalidOptions,instrumentInvalidOptions,maxVacuumTimeInvalidOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	allTests=Flatten[{discardedTest,noVolumeTest,notLiquidTest,optionsPrecisionTests,validNameTest,degasTypeInstrumentTest,freezePumpThawOnlyTest,vacuumDegasOnlyTest,
		maxVacuumUntilBubblelessTest,spargingOnlyTest,headSpaceGasFlushOptionsTest,headSpaceGasFlushTimeOptionsTest,generalTest,freezePumpThawVolumeTest,vacuumDegassingVolumeTest,
		spargingVolumeTest,freezePumpThawInstrumentTest,vacuumDegassingInstrumentTest,spargingInstrumentTest,vacuumTimeWarningTests,freezePumpThawContainerTest,dissolvedOxygenTest,dissolvedOxygenVolumeTest,
		spargingNullTest,vacuumDegasNullTest,freezePumpThawNullTest,instrumentOptionTest,maxVacuumTimeTest}];

	suitableContainerErrors=MapThread[Or,{vacuumDegassingSuitableContainerErrors,spargingVolumeContainerLowErrors,spargingSuitableContainerErrors,freezePumpThawContainerWarnings}];
	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	{targetContainers,targetVolumes}=Transpose@MapThread[Function[{container,containerErrors,myVolumes,myDegasType,myFreezePumpThawContainer},
		If[
			MatchQ[containerErrors,False],
			{Null,Null},

			Switch[myDegasType,
				VacuumDegas,
				{PreferredContainer[myVolumes],myVolumes},
				Sparging,
				{PreferredContainer[myVolumes],myVolumes},
				FreezePumpThaw,
				{myFreezePumpThawContainer,myVolumes}
			]
		]
	],{simulatedSampleContainerModels,suitableContainerErrors,volumes,resolvedDegasType,resolvedFreezePumpThawContainer}];

	aliquotMessage="because the given sample is not in a container that is appropriate for the sample to be degassed in using the selected degassing method.";

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentDegas,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache->cache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->targetVolumes,AliquotWarningMessage->aliquotMessage,Output->{Result,Tests}],
		{resolveAliquotOptions[ExperimentDegas,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache->cache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->targetVolumes,AliquotWarningMessage->aliquotMessage,Output->Result],{}}
	];

	(* Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["degas sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[allOptionsRounded, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["degas sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[allOptionsRounded, SampleContainerLabel]}
		]
	];


	(* Resolve Email option *)
	resolvedEmail = If[!MatchQ[emailOption, Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* all resolved options *)
	resolvedOptions=ReplaceRule[Normal[allOptionsRounded],
		Join[
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			resolvedSamplePrepOptions,
			{
				DegasType->resolvedDegasType,
				Instrument->resolvedInstrument,
				FreezeTime->resolvedFreezeTime,
				VacuumPressure->resolvedVacuumPressure,
				PumpTime->resolvedPumpTime,
				ThawTemperature->resolvedThawTemperature,
				ThawTime->resolvedThawTime,
				NumberOfCycles->resolvedNumberOfCycles,
				FreezePumpThawContainer->resolvedFreezePumpThawContainer,
				VacuumSonicate->resolvedVacuumSonicate,
				VacuumTime->resolvedVacuumTime,
				VacuumUntilBubbleless->resolvedVacuumUntilBubbleless,
				MaxVacuumTime->resolvedMaxVacuumTime,
				SpargingGas->resolvedSpargingGas,
				SpargingTime->resolvedSpargingTime,
				SpargingMix -> resolvedSpargingMix,
				HeadspaceGasFlush->resolvedHeadspaceGasFlush,
				HeadspaceGasFlushTime->resolvedHeadspaceGasFlushTime,
				DissolvedOxygen->resolvedDissolvedOxygen,
				Confirm -> confirmOption,
				CanaryBranch -> canaryBranchOption,
				Name -> name,
				Email -> resolvedEmail,
				ParentProtocol -> parentProtocolOption,
				Upload -> uploadOption,
				FastTrack -> fastTrackOption,
				Operator -> operator,
				SamplesInStorageCondition -> samplesInStorageOption,
				SamplesOutStorageCondition -> samplesOutStorageOption,
				Template -> templateOption,
				Cache -> cache,
				Simulation->updatedSimulation,
				SampleLabel->resolvedSampleLabel,
				SampleContainerLabel->resolvedSampleContainerLabel
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}
];


(* ::Subsubsection:: *)
(*degasResourcePackets*)


DefineOptions[
	degasResourcePackets,
	Options:>{OutputOption,CacheOption,SimulationOption}
];

degasResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		samplePackets,sampleVolumes,pairedSamplesInAndVolumes,sampleVolumeRules,
		sampleResourceReplaceRules,samplesInResources,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,testsRule,resultRule,previewRule,optionsRule,workingContainers,workingContainerModels,workingSamples,
		sampleDownloads,containersInResources,aliquotQs,aliquotVols,intAliquotContainers,aliquotContainers,

		degasType,instrument,freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,
		spargingGas,spargingTime,spargingMix,headSpaceGasFlush,headSpaceGasFlushTime,totalInstrumentProcessTimes,totalTimeAllInstruments,
		wasteContainerResource,

		expandedCaps,expandedAdapters,expandedImpellerGuides,expandedImpellers,capResourcesNoNull,adapterResourcesNoNull,impellerResourcesNoNull,impellerGuideResourcesNoNull,impellerBoxResources,
		rawDegasParameters,batchParameterPackets,degasParameters,instrumentProcessTimes,totalInstrumentTime,instrumentSetupTearDown,groupedBatches,finalSampleIndexes,finalContainerIndexes,batchContainerLengths,batchSampleLengths,
		degasParameterTypes,batchedConnections,batchedConnectionLengths,
		schlenkLineResource,freezePumpThawResources,dewarResources,heatBlockResources,freezePumpThawContainerResources,freezePumpThawContainerResourcesNoNull,septumResources,septumResourcesNoNull,liquidNitrogenResources,vacuumDegasResources,sonicatorResources,spargingResources, teflonTapeResource,
		simulation,updatedSimulation,simulationRule,simulatedSamples,unitOperationPacket,rawResourceBlobs,resourcesWithoutName,
		resourceToNameReplaceRules,resourcesOk,resourceTests,cache,cacheBall
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentDegas,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentDegas,
		RemoveHiddenOptions[ExperimentDegas,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];
	cache = Lookup[ToList[ops], Cache];

	(* Get the inherited cache *)
	inheritedCache=Lookup[myResolvedOptions,Cache];
	cacheBall = FlattenCachePackets[{cache, inheritedCache}];
	simulation = Lookup[ToList[ops], Simulation];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentDegas, mySamples, myResolvedOptions, Cache -> cacheBall, Simulation -> simulation];

	(* --- Make our one big Download call --- *)
	{sampleDownloads}=Quiet[Download[
		{mySamples},
		{Packet[Container, Volume, Object]},
		Cache->cacheBall,
		Simulation->updatedSimulation
	],
		Download::FieldDoesntExist
	];

	samplePackets=Flatten[sampleDownloads];

	(* Get the working container of the sample after SamplePrep. We need this info for figuring out what caps and adapters etc we need *)
	workingContainers=MapThread[
		If[MatchQ[#1,ObjectP[]],
			#1,(* If we are aliquoting, take the Aliquot Container, otherwise, take the SamplesIn container*)
			#2
		]&,
		{Lookup[samplePackets,AliquotContainer],Lookup[samplePackets,Container][Object]}
	];

	workingContainerModels=cacheLookup[cacheBall,#,Model]&/@workingContainers;

	workingSamples=Lookup[samplePackets,Object];

	(* --- Make all the resources needed in the experiment --- *)

	(*Option lookup*)
	{
		degasType,instrument,
		freezeTime,pumpTime,thawTemperature,thawTime,numberOfCycles,freezePumpThawContainer,
		vacuumPressure,vacuumSonicate,vacuumTime,vacuumUntilBubbleless,maxVacuumTime,
		spargingGas,spargingTime,spargingMix,
		headSpaceGasFlush,headSpaceGasFlushTime
	}=Lookup[expandedResolvedOptions,
		{
			DegasType,Instrument,
			FreezeTime,PumpTime,ThawTemperature,ThawTime,NumberOfCycles,FreezePumpThawContainer,
			VacuumPressure,VacuumSonicate,VacuumTime,VacuumUntilBubbleless,MaxVacuumTime,
			SpargingGas,SpargingTime,SpargingMix,
			HeadspaceGasFlush,HeadspaceGasFlushTime
		}
	];

	(* -- Generate resources for the SamplesIn -- *)

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotQs=Lookup[myResolvedOptions,Aliquot,Null];

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotVols=Lookup[myResolvedOptions,AliquotAmount,Null];

	(*Get the aliquot containers*)
	intAliquotContainers=Lookup[myResolvedOptions,AliquotContainer,Null];

	(*Extract only the model information of the aliquoted containers *)
	aliquotContainers=If[MatchQ[#,Null],Null,#[[All;2]]]&/@intAliquotContainers;

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)
	(* if the samples is NOT getting aliquot, we'll reserve the whole sample without an amount request *)
	sampleVolumes=Flatten[MapThread[
		Function[{aliquot,volume},
			Which[
				aliquot,volume,
				True,Null
			]
		],
		{aliquotQs,aliquotVols}
	]];

	(* Pair the SamplesIn and their Volumes - this combines anything with a volume listed*)
	pairedSamplesInAndVolumes=MapThread[
		#1->#2&,
		{mySamples,sampleVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules=Merge[pairedSamplesInAndVolumes,Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules=KeyValueMap[
		Function[{sample,volume},
			If[VolumeQ[volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]]]
			]
		],
		sampleVolumeRules
	];


	(* Use the replace rules to get the sample resources *)
	samplesInResources=Replace[Flatten[expandedInputs],sampleResourceReplaceRules,{1}];

	(* ContainersIn *)
	containersInResources=(Link[Resource[Sample->#],Protocols]&)/@Lookup[samplePackets,Container][Object];

	(* ---- BATCHING CALCULATIONS ---- *)
	(* TODO: If you change the following index format, be sure to change all the references to the indexes below this section! *)
	groupedBatches=GatherBy[
		Transpose[{
			(* Required Matching *)
			(* General *)
			(*1*)samplePackets,
			(*2*)workingContainers,

			(*3*)degasType,
			(*4*)Link/@instrument,

			(* Sparging Parameters *)
			(*5*)spargingGas,
			(*6*)spargingTime,
			(*7*)spargingMix,

			(* Vacuum Degas parameters*)
			(*7*)vacuumPressure,
			(*8*)vacuumSonicate,
			(*9*)vacuumTime,
			(*10*)vacuumUntilBubbleless,
			(*11*)maxVacuumTime,

			(* Freeze Pump Thaw Parameters*)
			(*12*)freezeTime,
			(*13*)pumpTime,
			(*14*)thawTime,
			(*15*)numberOfCycles,
			(*16*)thawTemperature,
			(*17*)Link/@freezePumpThawContainer,

			(*Shared*)
			(*18*)headSpaceGasFlush,
			(*19*)headSpaceGasFlushTime,

			(*Group by container model*)
			(*20*)workingContainerModels
		}],

		(* Group by everything but the samples and containers themselves*)
		{#[[3]],#[[4]],#[[5]],#[[6]],#[[7]],#[[8]],#[[9]],#[[10]],#[[11]],#[[12]],#[[13]],#[[14]],#[[15]],#[[16]],#[[17]],#[[18]],#[[19]],#[[20]],#[[21]]}&
	];

	{instrumentProcessTimes,batchContainerLengths,batchSampleLengths,rawDegasParameters}=Transpose@Map[
		Function[{groupedDegasSamples},
			Module[{batchDegasType,sharedBatchPacket,instrumentTiming,containers,containerModel,samples,numberOfSamples,adapter,degasCap,impeller,impellerGuide,maxContainersPerBatch,
				regroupedContainers,regroupedSamples,groupedContainerIndexes,groupedSampleIndexes,withObjectSharedBatchPatckets,instrumentResourceSharedBatchPackets,newSharedBatchPackets},

				(*Get the degas type,containers,and samples. Note that we are deleting duplicates so that we can get the right batch indexes later*)
				batchDegasType=First[groupedDegasSamples][[3]];
				containers=groupedDegasSamples[[All,2]];
				containerModel=First[groupedDegasSamples][[21]];
				samples=Lookup[groupedDegasSamples[[All,1]],Object];

				(* make a variable that is the number of input samples *)
				numberOfSamples=Length[samples];

				(*All the things that this batch have in common*)
				sharedBatchPacket=AssociationThread[
					(*All the keys IN ORDER of the batched parameters*)
					{
						DegasType,Instrument,SpargingGas,SpargingTime,SpargingMix,VacuumPressure,VacuumSonicate,VacuumTime,VacuumUntilBubbleless,MaxVacuumTime,
						FreezeTime,PumpTime,ThawTime,NumberOfCycles,ThawTemperature,FreezePumpThawContainer,HeadspaceGasFlush,HeadspaceGasFlushTime
					},
					First[groupedDegasSamples][[Range[3,20]]]
				];

				{instrumentTiming,maxContainersPerBatch,adapter,degasCap,impeller,impellerGuide}=Switch[batchDegasType,
					FreezePumpThaw,
					Module[
						{
							totalFPTTimes,instrumentTime,maxContainersPerBatchFPT,FPTadapter
						},

						(*Determine total measurement times: sum up freeze,pump,thaw times, and multiply by numberofcycles*)
						totalFPTTimes=Plus@@Flatten[{Lookup[sharedBatchPacket,FreezeTime],Lookup[sharedBatchPacket,PumpTime],Lookup[sharedBatchPacket,ThawTime]}*Lookup[sharedBatchPacket,NumberOfCycles]/.Null->0];

						(* Estimate the time needed to run an experiment on the viscometer *)
						instrumentTime=Plus[

							(* Time spent actually measuring the sample is equal to the sum of the freezeTime *)
							totalFPTTimes,
							Lookup[sharedBatchPacket,HeadspaceGasFlushTime]/.Null->0,

							(* transferring samples into and out of the instrument is approximately 5 minutes *)
							5 Minute*numberOfSamples
						];

						(*Grab the instrument. If it is an object, grabe the corresponding model*)
						instrument=Which[
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Model[Instrument]]],
							Lookup[sharedBatchPacket,Instrument],
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Object[Instrument]]],
							Lookup[cacheLookup[cacheBall,Lookup[sharedBatchPacket,Instrument]],Model]
						];

						(*grab the number of samples that can be run simultaneously*)
						maxContainersPerBatchFPT=Lookup[cacheLookup[cacheBall,instrument],NumberOfChannels];

						(*grab the correct freeze pump thaw adapter*)
						FPTadapter=Model[Plumbing, Tubing, "High Vac Adapter"];

						{
							Lookup[sharedBatchPacket,Instrument]->instrumentTime,
							maxContainersPerBatchFPT,
							FPTadapter,
							Null, (*no special caps for freeze pump thaw*)
							Null, (*no sparging impeller*)
							Null (*no sparging impeller guide*)
						}

					],
					VacuumDegas,
					Module[
						{
							totalVDTimes,instrumentTime,maxContainersPerBatchVD,VDadapter,VDcap
						},

						(*Determine total measurement times*)
						totalVDTimes=Plus@@Flatten[{Lookup[sharedBatchPacket,VacuumTime],Lookup[sharedBatchPacket,HeadspaceGasFlushTime]}/.Null->0];

						(* Estimate the time needed to run an experiment on the viscometer *)
						instrumentTime=Plus[

							(* Time spent actually measuring the sample is equal to the sum of the freezeTime *)
							totalVDTimes,

							(* transferring samples into and out of the instrument is approximately 5 minutes *)
							5 Minute*numberOfSamples
						];

						(*Grab the instrument. If it is an object, grabe the corresponding model*)
						instrument=Which[
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Model[Instrument]]],
							Lookup[sharedBatchPacket,Instrument],
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Object[Instrument]]],
							Lookup[cacheLookup[cacheBall,Lookup[sharedBatchPacket,Instrument]],Model]
						];

						(*grab the number of samples that can be run simultaneously*)
						maxContainersPerBatchVD=Lookup[cacheLookup[cacheBall,instrument],NumberOfChannels];

						(*grab the correct vacuum degas caps*)
						VDcap=Which[
							MatchQ[containerModel,ObjectP[{Model[Container,Vessel,"5L Glass Bottle"],Model[Container,Vessel,"2L Glass Bottle"],Model[Container,Vessel,"1L Glass Bottle"],Model[Container,Vessel,"500mL Glass Bottle"],Model[Container,Vessel,"250mL Glass Bottle"],Model[Container,Vessel,"150 mL Glass Bottle"],Model[Container,Vessel,"100 mL Glass Bottle"]}]],
							Model[Item,Cap,"Glass bottle degas cap"],
							MatchQ[containerModel,ObjectP[{Model[Container,Vessel,"Amber Glass Bottle 4L"],Model[Container,Vessel,"500mL Amber Glass Bottle"],Model[Container,Vessel,"250mL Amber Glass Bottle"]}]],
							Model[Item,Cap,"4L amber bottle degas cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"50mL Tube"]]],
							Model[Item,Cap,"50mL tube degas cap"]
						];

						(*grab the correct vacuum degas adapters*)
						VDadapter=Link[Model[Plumbing, Tubing, "Low Vac Adapter"]];

						{
							Lookup[sharedBatchPacket,Instrument]->instrumentTime,
							maxContainersPerBatchVD,
							VDadapter,
							VDcap,
							Null, (*no sparging impeller*)
							Null (* no sparging impeller guide*)
						}

					],
					Sparging,
					Module[
						{
							totalSpargingTimes,instrumentTime,maxContainersPerBatchSpar,spargCap,spargAdapter,spargImpeller,spargImpellerGuide
						},

						(*Determine total measurement times*)
						totalSpargingTimes=Plus@@Flatten[{Lookup[sharedBatchPacket,SpargingTime],Lookup[sharedBatchPacket,HeadspaceGasFlushTime]}/.Null->0];

						(* Estimate the time needed to run an experiment on the viscometer *)
						instrumentTime=Plus[

							(* Time spent actually measuring the sample is equal to the sum of the freezeTime *)
							totalSpargingTimes,

							(* transferring samples into and out of the instrument is approximately 5 minutes *)
							5 Minute*numberOfSamples
						];

						(*Grab the instrument. If it is an object, grabe the corresponding model*)
						instrument=Which[
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Model[Instrument]]],
							Lookup[sharedBatchPacket,Instrument],
							MatchQ[Lookup[sharedBatchPacket,Instrument],ObjectP[Object[Instrument]]],
							Lookup[cacheLookup[cacheBall,Lookup[sharedBatchPacket,Instrument]],Model]
						];

						(*grab the number of samples that can be run simultaneously*)
						maxContainersPerBatchSpar=Lookup[cacheLookup[cacheBall,instrument],NumberOfChannels];

						(*grab the correct sparging caps*)
						spargCap=Which[
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"20L Polypropylene Carboy"]]],
							Model[Item,Cap,"20L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"10L Polypropylene Carboy"]]],
							Model[Item,Cap,"10L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"Amber Glass Bottle 4L"]]],
							Model[Item,Cap,"4L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"5L Glass Bottle"]]],
							Model[Item,Cap,"5L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"2L Glass Bottle"]]],
							Model[Item,Cap,"2L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"1L Glass Bottle"]]],
							Model[Item,Cap,"1L Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"500mL Glass Bottle"]]],
							Model[Item,Cap,"500mL Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"250mL Glass Bottle"]]],
							Model[Item,Cap,"250mL Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"150 mL Glass Bottle"]]],
							Model[Item,Cap,"150mL Sparge Cap"],
							MatchQ[containerModel,ObjectP[Model[Container,Vessel,"100 mL Glass Bottle"]]],
							Model[Item,Cap,"100mL Sparge Cap"]
						];

						(*grab the correct sparging adapters*)
						spargAdapter=Link[Model[Plumbing, Tubing, "Low Vac Adapter"]];

						(*grab the correct impeller*)
						spargImpeller=Which[
							MatchQ[containerModel,ObjectP[{Model[Container,Vessel,"20L Polypropylene Carboy"],Model[Container,Vessel,"10L Polypropylene Carboy"]}]],
							Model[Part, StirrerShaft, "id:54n6evKYj8xL"],
							MatchQ[containerModel,ObjectP[{Model[Container,Vessel,"5L Glass Bottle"],Model[Container,Vessel,"Amber Glass Bottle 4 L"],Model[Container,Vessel,"2L Glass Bottle"],Model[Container,Vessel,"1L Glass Bottle"],Model[Container,Vessel,"500mL Glass Bottle"],Model[Container,Vessel,"250mL Glass Bottle"],Model[Container,Vessel,"150 mL Glass Bottle"],Model[Container,Vessel,"100 mL Glass Bottle"]}]],
							Model[Part, StirrerShaft, "id:pZx9jo8eAR7P"]
						];

						(* grab the correct impeller guide*)
						spargImpellerGuide=Model[Part,AlignmentTool,"Sparge Cap Impeller Guide"];

						{
							Lookup[sharedBatchPacket,Instrument]->instrumentTime,
							maxContainersPerBatchSpar,
							spargAdapter,
							spargCap,
							spargImpeller,
							spargImpellerGuide
						}
					]
				];

				(*Partition the containers based on how many containers can be run in each batch*)
				regroupedContainers=Flatten/@PartitionRemainder[containers,maxContainersPerBatch];

				regroupedSamples=Flatten/@PartitionRemainder[samples,maxContainersPerBatch];

				(*determine the index of working containers these batched containers correspond to, so we can pull it out later*)
				groupedContainerIndexes=Flatten[
					Position[
						workingContainers,
						Alternatives@@#
					]
				]&/@regroupedContainers;

				groupedSampleIndexes=Flatten[
					Position[
						workingSamples,
						Alternatives@@#
					]
				]&/@regroupedSamples;

				withObjectSharedBatchPatckets=Join[sharedBatchPacket,
					<|
						SchlenkAdapter->If[!NullQ[adapter],Link@Resource[Sample -> adapter, Name -> ToString[Unique[]],Rent->True],Null],
						DegasCap->If[!NullQ[degasCap],Link@Resource[Sample -> degasCap, Name -> ToString[Unique[]],Rent->True],Null],
						Impeller->If[!NullQ[impeller],Link@Resource[Sample -> impeller, Name -> ToString[Unique[]],Rent->True],Null],
						ImpellerGuide->If[!NullQ[impellerGuide],Link@Resource[Sample -> impellerGuide, Name -> ToString[Unique[]],Rent->True],Null]
					|>
				];

				instrumentResourceSharedBatchPackets=MapAt[Resource[Instrument->#[Object],Time->Values[instrumentTiming],Name -> ToString[Unique[]]]&,withObjectSharedBatchPatckets,Key[Instrument]];

				newSharedBatchPackets=MapThread[
					Join[instrumentResourceSharedBatchPackets,
						<|
							GroupedSampleIndex->#1,
							GroupedContainerIndex->#2
						|>
					]&,
					{
						groupedSampleIndexes,
						groupedContainerIndexes
					}
					];

				{instrumentTiming,Length/@regroupedContainers,Length/@regroupedSamples,newSharedBatchPackets}
			]
		],
		groupedBatches
	];

	(*Pull stuff out*)
	finalSampleIndexes=Lookup[#,GroupedSampleIndex]&/@rawDegasParameters;
	finalContainerIndexes=Lookup[#,GroupedContainerIndex]&/@rawDegasParameters;

	(*Drop unnecessary keys*)
	batchParameterPackets=KeyDrop[#,
		{
			Experiment`Private`GroupedSampleIndex,
			Experiment`Private`GroupedContainerIndex
		}
	]&/@Flatten[rawDegasParameters];

	(* Append the key BatchNumber to each batch association to indicate which batch it is *)
	degasParameters = MapThread[Append[#1,{BatchNumber->#2,NumberOfChannels->#3}]&,{batchParameterPackets,Range[Length[batchParameterPackets]],Flatten[batchContainerLengths]}];

	(*Generate batched connections list*)
	degasParameterTypes=Lookup[degasParameters,DegasType];

	(*Expand the batched lists to allow for resource picking of the right number of caps, adapters, impeller, gas dispersion tubes*)
	expandedCaps=Join @@ MapThread[Table, {Lookup[degasParameters,DegasCap],Flatten[batchSampleLengths]}];
	expandedAdapters=Join @@ MapThread[Table, {Lookup[degasParameters,SchlenkAdapter],Flatten[batchSampleLengths]}];
	expandedImpellers=Join @@ MapThread[Table, {Lookup[degasParameters,Impeller],Flatten[batchSampleLengths]}];
	expandedImpellerGuides=Join @@ MapThread[Table, {Lookup[degasParameters,ImpellerGuide],Flatten[batchSampleLengths]}];

	(*Resource pick the above items*)
	(* degas caps*)
	capResourcesNoNull=expandedCaps/.Null->Sequence[];

	(* adapters*)
	adapterResourcesNoNull=expandedAdapters/.Null->Sequence[];

	(* impeller*)
	impellerResourcesNoNull=expandedImpellers/.Null->Sequence[];

	(* gas dispersion tubes*)
	impellerGuideResourcesNoNull=expandedImpellerGuides/.Null->Sequence[];

	(* if we are using degasCap, we need to grab some teflon tape *)
	(* we are using Model[Item, Consumable, "Teflon tape"] *)
	teflonTapeResource = If[MatchQ[capResourcesNoNull, Except[Null|{}]],
		Resource[Sample->Model[Item, Consumable, "id:N80DNjlYwV3o"], Rent->True]];

	(*Add the instrument process times from above*)
	totalInstrumentProcessTimes=Merge[instrumentProcessTimes,Total];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
			this will probably look like set-up time + time/sample + tear-down time *)
	(*instrumentTime*)
	(*  30 Minutes for setting up the instrument; 10 minutes for cleanup*)
	instrumentSetupTearDown=(30 Minute+10 Minute);

	totalInstrumentTime=Map[#+instrumentSetupTearDown&,totalInstrumentProcessTimes];

	totalTimeAllInstruments=Total[Values[totalInstrumentTime]];

	(*Resources that all instruments will use*)
	(*schlenk line*)
	schlenkLineResource = Resource[
		Instrument -> Model[Instrument, SchlenkLine, "id:R8e1Pjp8vOK4"], (* High Tech Schlenk Line  *)
		Time -> totalTimeAllInstruments,
		Name -> ToString[Unique[]]
	];

	instrumentResource=Map[
		Resource[Instrument->#[[1]],Time->#[[2]]]&,
		Transpose[{Keys[totalInstrumentProcessTimes],Values[totalInstrumentProcessTimes]}]
	];

	(*FreezePumpThaw specific resources*)
	freezePumpThawResources=Transpose[If[MatchQ[#[[1]],ObjectP[{Model[Instrument,FreezePumpThawApparatus],Object[Instrument,FreezePumpThawApparatus]}]],
		{
			(*Dewar*)
			Module[{dewar},
				dewar=Lookup[cacheLookup[cacheBall,#[[1]][Object]],Dewar];
				Resource[
					Instrument->dewar[Object],
					Time->#[[2]]
				]
			],

			(*heat block*)
			Module[{heatblock},
				heatblock=Lookup[cacheLookup[cacheBall,#[[1]][Object]],HeatBlock];
				Resource[
					Instrument->heatblock[Object],
					Time->#[[2]]
				]
			],

			(*liquid nitrogen doser*)
			Module[{doser},
				doser=Model[Instrument,LiquidNitrogenDoser,"id:GmzlKjPWrV3E"] (* UltraDoser *);
				Resource[
					Instrument->doser,
					Time->#[[2]]
				]
			]
		},
		{Null,Null,Null}
	]&/@Transpose[{Keys[totalInstrumentProcessTimes],Values[totalInstrumentProcessTimes]}]];

	(*split up freeze pump thaw resources, remove the nulls, and swap empty lists back to a singular Null*)
	{dewarResources,heatBlockResources,liquidNitrogenResources}=Map[
		Sequence@@#&,
		(freezePumpThawResources/.Null->Sequence[])/.{}->Null
	];

	(* Freeze Pump Thaw flask resources *)
	freezePumpThawContainerResources = If[!NullQ[#],Resource[Sample -> #, Name -> ToString[Unique[]],Rent->True],Null]&/@Lookup[myResolvedOptions,FreezePumpThawContainer];
	freezePumpThawContainerResourcesNoNull=freezePumpThawContainerResources/.Null->Sequence[];

	(* Waste container resource for the vapor trap draining *)
	wasteContainerResource = Model[Container, Vessel, "1000mL Glass Beaker"];

	(* Septum resources *)
	septumResources = If[!NullQ[#],Resource[Sample -> Model[Item, Cap, "14/20 Joint Septum, Rubber"], Name -> ToString[Unique[]]],Null]&/@Lookup[myResolvedOptions,FreezePumpThawContainer];
	septumResourcesNoNull=septumResources/.Null->Sequence[];

	(*VacuumDegas specific resources*)
	vacuumDegasResources=Transpose[If[MatchQ[#[[1]],ObjectP[{Model[Instrument,VacuumDegasser],Object[Instrument,VacuumDegasser]}]],
		{
			(*Sonicator*)
			Module[{sonicator},
				sonicator=Lookup[cacheLookup[cacheBall,#[[1]][Object]],Sonicator];
				cacheLookup[cacheBall,#[[1]][Object]];
				Resource[
					Instrument->sonicator[Object],
					Time->#[[2]]
				]
			]
			(*Vacuum degas caps*)
				(*Connectors*)
		},
		{Null}
	]&/@Transpose[{Keys[totalInstrumentProcessTimes],Values[totalInstrumentProcessTimes]}]];

	(*split up vacuum degassing resources, remove the nulls, and swap empty lists back to a singular Null*)
	{sonicatorResources}=Map[
		Sequence@@#&,
		(vacuumDegasResources/.Null->Sequence[])/.{}->Null
	];

	(*Sparging specific resources*)
	spargingResources=Transpose[If[MatchQ[#[[1]],ObjectP[{Model[Instrument,SpargingApparatus],Object[Instrument,SpargingApparatus]}]],
		{
			(*impellers*)
			Module[{impellerBox},
				impellerBox=Lookup[cacheLookup[cacheBall,#[[1]][Object]],Mixer];
				Resource[
					Instrument->impellerBox[Object],
					Time->#[[2]]
				]
			]
		},
		{Null}
	]&/@Transpose[{Keys[totalInstrumentProcessTimes],Values[totalInstrumentProcessTimes]}]];

	(*split up sparging resources, remove the nulls, and swap empty lists back to a singular Null*)
	{impellerBoxResources}=Map[
		Sequence@@#&,
		(spargingResources/.Null->Sequence[])/.{}->Null
	];

	(*batched connections*)
	batchedConnections=MapThread[
		Function[{currentDegasType,currentDegasParameters},
			(*Generate a different type of connection depending on what kind of degas type we have*)
				Which[
					MatchQ[currentDegasType,VacuumDegas],
					{
						(*Between the instrument and the adapter*)
						{schlenkLineResource,"Fumehood Wall Outlet A",Lookup[currentDegasParameters,SchlenkAdapter],"Vac Inlet"},
						(*Between the adapter and the cap*)
						{Lookup[currentDegasParameters,SchlenkAdapter],"Gas Outlet",Lookup[currentDegasParameters,DegasCap],"Cap Inlet"}
					},
					MatchQ[currentDegasType,Sparging],
					{
						(*Between the instrument and the adapter*)
						{schlenkLineResource,"Fumehood Wall Outlet A",Lookup[currentDegasParameters,SchlenkAdapter],"Vac Inlet"},
						(*Between the adapter and the cap*)
						{Lookup[currentDegasParameters,SchlenkAdapter],"Gas Outlet",Lookup[currentDegasParameters,DegasCap],"Cap Inlet"}
					},
					MatchQ[currentDegasType,FreezePumpThaw],
					{
						(*Between the instrument and the adapter*)
						{schlenkLineResource,"Fumehood Wall Outlet A",Lookup[currentDegasParameters,SchlenkAdapter],"Vac Inlet"}
					}
				]
		],
		{
			degasParameterTypes,
			degasParameters
		}
	];

	batchedConnectionLengths=Length/@batchedConnections;

	unitOperationPacket=Module[{nonHiddenDegasOptions},

		(* Only include non-hidden options. Exclude prep primitives*)
		nonHiddenDegasOptions=DeleteCases[Lookup[
			Cases[OptionDefinition[ExperimentDegas], KeyValuePattern["Category"->Except["Hidden"]]],
			"OptionSymbol"
		],PreparatoryUnitOperations|Name];

		UploadUnitOperation[
			Degas@@Join[
				{
					Sample->samplesInResources
				},
				ReplaceRule[
					Cases[expandedResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenDegasOptions, _]],
					{
						Instrument -> instrumentResource,
						FreezePumpThawContainer->freezePumpThawContainerResourcesNoNull
					}
				]
			],
			Preparation->Manual,
			UnitOperationType->Batched,
			FastTrack->True,
			Upload->False
		]
	];

	(* --- Generate the protocol packet --- *)
	protocolPacket=Join[
		<|
			(*Organizational information/options handling*)
			Type->Object[Protocol,Degas],
			Object->CreateID[Object[Protocol,Degas]],
			Replace[SamplesIn]->samplesInResources,
			Replace[ContainersIn]->containersInResources,
			Replace[BatchedContainerIndexes]->Flatten[finalContainerIndexes],
			Replace[BatchedSampleIndexes]->Flatten[finalSampleIndexes],
			Replace[BatchLengths]->Flatten[batchContainerLengths],
			Replace[BatchedSampleLengths]->Flatten[batchSampleLengths],
			Replace[BatchedConnections]->Flatten[batchedConnections,1],(* This is currently grouped so we want to flatten to list of lists *)
			Replace[BatchedConnectionLengths]->Flatten[batchedConnectionLengths],
			Replace[BatchedDegasParameters]->degasParameters,
			UnresolvedOptions->myUnresolvedOptions,
			ResolvedOptions->myResolvedOptions,

			(*General instrument set up*)
			Replace[Instrument]->instrumentResource,
			Replace[SchlenkLine]->schlenkLineResource,

			(*Specific instrument set up*)
			Replace[Dewar]->dewarResources,
			Replace[LiquidNitrogenDoser]->liquidNitrogenResources,
			Replace[HeatBlock]->heatBlockResources,
			Replace[Septum]->septumResourcesNoNull,
			Replace[FreezePumpThawContainer]->freezePumpThawContainerResourcesNoNull,
			Replace[Sonicator]->sonicatorResources,
			Replace[DegasCap]->capResourcesNoNull,
			TeflonTape->teflonTapeResource,
			Replace[ImpellerGuide]->impellerGuideResourcesNoNull,
			Replace[Mixer]->impellerBoxResources,
			Replace[Impeller]->impellerResourcesNoNull,
			Replace[SchlenkAdapter]->adapterResourcesNoNull,

			(*Method information*)
			Replace[DegasType]->Lookup[expandedResolvedOptions,DegasType],
			Replace[MethodTime]->totalTimeAllInstruments,

			Replace[FreezeTime]->Lookup[expandedResolvedOptions,FreezeTime],
			Replace[PumpTime]->Lookup[expandedResolvedOptions,PumpTime],
			Replace[ThawTime]->Lookup[expandedResolvedOptions,ThawTime],
			Replace[ThawTemperature]->Lookup[expandedResolvedOptions,ThawTemperature],
			Replace[NumberOfCycles]->Lookup[expandedResolvedOptions,NumberOfCycles],

			Replace[VacuumTime]->Lookup[expandedResolvedOptions,VacuumTime],
			Replace[VacuumUntilBubbleless]->Lookup[expandedResolvedOptions,VacuumUntilBubbleless],
			Replace[MaxVacuumTime]->Lookup[expandedResolvedOptions,MaxVacuumTime],
			Replace[VacuumSonicate]->Lookup[expandedResolvedOptions,VacuumSonicate],
			Replace[VacuumPressure]->Lookup[expandedResolvedOptions,VacuumPressure],

			Replace[SpargingGas]->Lookup[expandedResolvedOptions,SpargingGas],
			Replace[SpargingTime]->Lookup[expandedResolvedOptions,SpargingTime],
			Replace[SpargingMix]->Lookup[expandedResolvedOptions,SpargingMix],

			Replace[HeadspaceGasFlush]->Lookup[expandedResolvedOptions,HeadspaceGasFlush],
			Replace[HeadspaceGasFlushTime]->Lookup[expandedResolvedOptions,HeadspaceGasFlushTime],
			Replace[DissolvedOxygen]->Lookup[expandedResolvedOptions,DissolvedOxygen],

			(*Post experiment*)
			Replace[SamplesInStorage]->Lookup[myResolvedOptions,SamplesInStorageCondition],
			Replace[SamplesOutStorage]->Lookup[myResolvedOptions,SamplesOutStorageCondition],
			(*Cleaning*)
			WasteContainer -> Link[wasteContainerResource],

			(*Resources*)
			Replace[Checkpoints]->{
				{"Picking Resources",30 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
				{"Preparing Samples",45 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->1 Minute]]},
				{"Degassing Samples",totalTimeAllInstruments,"Samples are placed into the instrument and then degassing is performed.",Link[Resource[Operator->$BaselineOperator,Time->28 Hour]]},
				{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->$BaselineOperator,Time->1*Hour]]},
				{"Returning Materials",20 Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->10*Minute]]}
			},
			Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@ToList[Lookup[unitOperationPacket, Object]]
		|>
	];

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* make list of all the resources we need to check in FRQ *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPacket]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cacheBall,Simulation -> updatedSimulation],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cacheBall,Simulation -> updatedSimulation],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		Null
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{finalizedPacket, unitOperationPacket}/.resourceToNameReplaceRules,
		$Failed
	];

	(* generate the simulation output rule *)
	simulationRule = Simulation -> If[MemberQ[output, Simulation] && !MemberQ[output, Result],
		finalizedPacket,
		Null
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule,simulationRule}
];

(* Primitive Support*)
(* ::Subsection:: *)
(* resolveDegasMethod *)

resolveDegasMethod[]:=Manual;

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentDegas,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentDegas[
	myProtocolPacket:(PacketP[Object[Protocol, Degas], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentDegas]
]:=Module[
		{mapThreadFriendlyOptions,resolvedPreparation,cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels},

		(* Lookup our cache and simulation. *)
		cache=Lookup[ToList[myResolutionOptions], Cache, {}];
		simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

		(* Download containers from our sample packets. *)
		samplePackets=Download[
			mySamples,
			Packet[Container],
			Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
			Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
		];

		(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
		protocolObject=Which[
			(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
			MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol,Degas]],
			True,
			Lookup[myProtocolPacket, Object]
		];

		(* Get our map thread friendly options. *)
		mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
			ExperimentDegas,
			myResolvedOptions
		];

		(* Simulate the fulfillment of all resources by the procedure. *)
		(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
		(* just make a shell of a protocol object so that we can return something back. *)
		fulfillmentSimulation=Which[
			(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
			(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
			MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, ListableP[PacketP[]]],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, ToList[myUnitOperationPackets], ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],

			(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
			(* and skipped resource packet generation. *)
			MatchQ[myProtocolPacket, $Failed],
			SimulateResources[
				<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					ResolvedOptions->myResolvedOptions
				|>,
				Cache->cache,
				Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
			],

			(* Otherwise, our resource packets went fine and we have an Object[Protocol, Transfer]. *)
			True,
			SimulateResources[
				myProtocolPacket,
				Cache->cache,
				Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
			]
		];

		(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
		(* SamplesIn field. *)
		simulationWithLabels=Simulation[
			Labels->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
					{_String, ObjectP[]}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
					{_String, ObjectP[]}
				]
			],
			LabelFields->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				]
			]
		];

		(* Merge our packets with our labels. *)
		{
			protocolObject,
			UpdateSimulation[fulfillmentSimulation, simulationWithLabels]
		}
];
