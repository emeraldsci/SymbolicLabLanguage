(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Options and Messages*)


(* ::Subsubsection::Closed:: *)
(*Options*)

$PelletSharedResuspensionMixOptions={
	Mix, MixType, MixUntilDissolved, Instrument, StirBar, Time, MaxTime, DutyCycle,
	MixRate, MixRateProfile, NumberOfMixes, MaxNumberOfMixes, MixVolume,
	Temperature, TemperatureProfile, MaxTemperature, OscillationAngle,
	Amplitude, MixFlowRate, MixPosition, MixPositionOffset,
	CorrectionCurve, Tips, TipType, TipMaterial, MultichannelMix,
	DeviceChannel, ResidualIncubation, ResidualTemperature, ResidualMix,
	ResidualMixRate, Preheat
};

$PelletSharedResuspensionMixOptionMap={
	Mix -> ResuspensionMix,
	MixType -> ResuspensionMixType,
	MixUntilDissolved -> ResuspensionMixUntilDissolved,
	Instrument -> ResuspensionMixInstrument,
	StirBar -> ResuspensionMixStirBar,
	Time -> ResuspensionMixTime,
	MaxTime -> ResuspensionMixMaxTime,
	DutyCycle -> ResuspensionMixDutyCycle,
	MixRate -> ResuspensionMixRate,
	MixRateProfile -> ResuspensionMixRateProfile,
	NumberOfMixes -> ResuspensionNumberOfMixes,
	MaxNumberOfMixes -> ResuspensionMaxNumberOfMixes,
	MixVolume -> ResuspensionMixVolume,
	Temperature -> ResuspensionMixTemperature,
	TemperatureProfile -> ResuspensionMixTemperatureProfile,
	MaxTemperature -> ResuspensionMixMaxTemperature,
	OscillationAngle -> ResuspensionMixOscillationAngle,
	Amplitude -> ResuspensionMixAmplitude,
	MixFlowRate -> ResuspensionMixFlowRate,
	MixPosition -> ResuspensionMixPosition,
	MixPositionOffset -> ResuspensionMixPositionOffset,
	CorrectionCurve -> ResuspensionMixCorrectionCurve,
	Tips -> ResuspensionMixTips,
	TipType -> ResuspensionMixTipType,
	TipMaterial -> ResuspensionMixTipMaterial,
	MultichannelMix -> ResuspensionMixMultichannelMix,
	DeviceChannel -> ResuspensionMixDeviceChannel,
	ResidualIncubation -> ResuspensionMixResidualIncubation,
	ResidualTemperature -> ResuspensionMixResidualTemperature,
	ResidualMix -> ResuspensionMixResidualMix,
	ResidualMixRate -> ResuspensionMixResidualMixRate,
	Preheat -> ResuspensionMixPreheat
};

DefineOptions[ExperimentPellet,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* NOTE: A major difference between manual and robotic work cell resolution is that our labels don't need to resolve automatically *)
			(* for manual primitives. *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples whose denser or insoluble contents will be concentrated to the bottom of a given container, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples whose denser or insoluble contents will be concentrated to the bottom of a given container, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples transferred into SupernatantDestinations, for use in downstream unit operations. If SupernatantDestination is set to Waste, SampleOutLabel should be Null as the sample out cannot be labeled for further use.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples transferred into SupernatantDestinations, for use in downstream unit operations. If SupernatantDestination is set to Waste, ContainerOutLabel should be Null as the waste container cannot be labeled for further use.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->Instrument,
				Default->Automatic,
				AllowNull -> False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Centrifuges"}
					}
				],
				Description->"The centrifuge that will be used to spin the provided samples.",
				ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, temperature, and sterility and (if possible) that is compatible with the sample in its current container.",
				Category->"Centrifugation"
			},
			{
				OptionName -> Intensity,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed], Units->Alternatives[RPM]],
					Widget[Type -> Quantity, Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce], Units->Alternatives[GravitationalAcceleration]]
				],
				Description -> "The rotational speed or the force that will be applied to the samples by centrifugation in order to create a pellet.",
				ResolutionDescription -> "Automatically set to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision.",
				Category->"Centrifugation"
			},
			{
				OptionName -> Time,
				Default -> 5 Minute,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units->Alternatives[Second, Minute, Hour]],
				Description -> "The amount of time that the samples will be centrifuged.",
				Category->"Centrifugation"
			},
			{
				OptionName->Temperature,
				Default-> Ambient,
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity, Pattern:>RangeP[-10 Celsius,40Celsius], Units->Alternatives[Celsius, Fahrenheit, Kelvin]]
				],
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged.",
				Category->"Centrifugation"
			},
			{
				OptionName->SupernatantVolume,
				Default-> Automatic,
				AllowNull->False,
				Widget->Alternatives[
					"All"->Widget[Type->Enumeration, Pattern:>Alternatives[All]],
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					]
				],
				Description->"The volume of supernatant that will be aspirated from the source sample.",
				ResolutionDescription->"Automatically set based on Preparation: All for Preparation is Manual and half of the sample volume for Preparation is Robotic.",
				Category->"Supernatant Aspiration"
			},
			{
				OptionName->SupernatantDestination,
				Default-> Automatic,
				AllowNull->False,
				Widget->Alternatives[
					"Waste"->Widget[Type->Enumeration, Pattern:>Alternatives[Waste]],
					"Destination Sample/Container"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample], Object[Container], Model[Container]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					]
				],
				Description->"The destination that the supernatant should be dispensed into, after aspirated from the source sample.",
				ResolutionDescription->"SupernatantDestination is set to Waste if performing the aspiration manually using an aspirator. Otherwise, SupernatantDestination is set to an empty liquid handler container to dispense the supernatant into.",
				Category->"Supernatant Aspiration"
			},
			ModifyOptions[
				TransferInstrumentOption,
				{
					Description->"The instrument that will be used to transfer the supernatant from the source sample into the supernatant destination.",
					ResolutionDescription->"Automatically set to a pipette or aspirator that can aspirate the volume of the source sample and can fit into the container of the source sample if Preparation->Manual. Otherwise, is set to Null if Preparation->Robotic (the built in Hamilton pipettes are used).",
					Category->"Hidden"
				}
			]/.{Verbatim[Rule][OptionName, Instrument] :> (OptionName->SupernatantTransferInstrument)},
			(* Copy over all of the Transfer Tip Options, prepend SupernatantTransfer for the option name. *)
			Sequence@@(ModifyOptions[
				TransferTipOptions,
				ToExpression /@ Options[TransferTipOptions][[All, 1]],
				{Category->"Hidden"}
			]/.(Verbatim[Rule][OptionName, ToExpression[#]] :> (OptionName->ToExpression["SupernatantTransfer" <> #]) &) /@ Options[TransferTipOptions][[All, 1]]),
			(* Copy over all of the Robotic Transfer Tip Options, prepend SupernatantTransfer for the option name. *)
			Sequence@@(ModifyOptions[
				TransferRoboticTipOptions,
				ToExpression /@ Options[TransferRoboticTipOptions][[All, 1]],
				{Category->"Hidden"}
			]/.(Verbatim[Rule][OptionName, ToExpression[#]] :> (OptionName->ToExpression["SupernatantTransfer" <> #]) &) /@ Options[TransferRoboticTipOptions][[All, 1]]),

			{
				OptionName->Resuspension,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the pellet should be resuspended after the supernatant is aspirated.",
				ResolutionDescription->"Automatically set to True if any of the other resuspension options are set.",
				Category->"Resuspension"
			},
			{
				OptionName->ResuspensionSource,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],
					Dereference->{Object[Container]->Field[Contents[[All,2]]]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				Description->"The sample that should be used to resuspend the pellet from the source sample.",
				ResolutionDescription->"Automatically set to Model[Sample, \"Milli-Q water\"] if any of the other Resuspension options are set.",
				Category->"Resuspension"
			},
			{
				OptionName -> ResuspensionSourceLabel,
				Default -> Automatic,
				Description -> "The label of the samples that should be used to resuspend the pellet from the source sample, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category->"Resuspension",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ResuspensionSourceContainerLabel,
				Default -> Automatic,
				Description -> "The label of the containers of the samples that should be used to resuspend the pellet from the source sample, which is used for identification elsewhere in sample preparation.",
				AllowNull -> True,
				Category->"Hidden",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->ResuspensionVolume,
				Default-> Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"All"->Widget[Type->Enumeration, Pattern:>Alternatives[All]],
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					]
				],
				Description->"The volume of ResuspensionSource that should be used to resuspend the pellet from the source sample.",
				ResolutionDescription->"Automatically set to 1/4 of the source sample container's volume or the volume of the provided ResuspensionSource (whichever is smaller), if any of the other Resuspension options are set.",
				Category->"Resuspension"
			},
			ModifyOptions[
				TransferInstrumentOption,
				{
					Description->"The instrument that will be used to resuspend the pellet from the source sample.",
					ResolutionDescription->"Automatically set to a pipette that can aspirate the ResuspensionVolume and can fit into the source sample's container.",
					Category->"Hidden"
				}
			]/.{Verbatim[Rule][OptionName, Instrument] :> (OptionName->ResuspensionInstrument)},
			(* Copy over all of the Transfer Tip Options, prepend Resuspension for the option name. *)
			Sequence@@(ModifyOptions[
				TransferTipOptions,
				ToExpression /@ Options[TransferTipOptions][[All, 1]],
				{Category->"Hidden", AllowNull->True}
			]/.(Verbatim[Rule][OptionName, ToExpression[#]] :> (OptionName->ToExpression["Resuspension" <> #]) &) /@ Options[TransferTipOptions][[All, 1]]),

			(* Copy over all of the Robotic Transfer Tip Options, prepend Resuspension for the option name. *)
			Sequence@@(ModifyOptions[
				TransferRoboticTipOptions,
				ToExpression /@ Options[TransferRoboticTipOptions][[All, 1]],
				{Category->"Hidden", AllowNull->True}
			]/.(Verbatim[Rule][OptionName, ToExpression[#]] :> (OptionName->ToExpression["Resuspension" <> #]) &) /@ Options[TransferRoboticTipOptions][[All, 1]]),

			(* Copy over all of the Incubate/Mix options, unless if it includes "Thaw" in the name, or is a FuntopiaSharedOption. *)
			Sequence@@(ModifyOptions[
				ExperimentMix,
				$PelletSharedResuspensionMixOptions,
				{Category->"Resuspension Mix", AllowNull->True}
			]/.{Verbatim[Rule][OptionName, name_] :> (OptionName -> (name/.$PelletSharedResuspensionMixOptionMap))})
		],

		PreparationOption,
		SimulationOption,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SamplesOutStorageOption,
		SubprotocolDescriptionOption,
		WorkCellOption,
		SterileTechniqueOption,
		ModelInputOptions
	}
];



(* ::Subsubsection::Closed:: *)
(*Messages*)
Error::ResuspensionMismatch="The input(s), `1`, have the following resuspension options set, `3`, but also have the following resuspension options set to Null `2`. These options are in conflict. Please fix this option conflict in order to enqueue a valid experiment.";
Error::NoSuitableMixInstrument="There are no suitable mix instrument available for the given sample(s). Please use the function MixDevices to see the instruments/mix types that are compatible with the given samples";
Error::LabelingDiscardedSupernatant="The input(s), `1`, have the SupernatantDestination set to Waste, but have also specified SampleOutLabel, `2`, or ContainerOutLabel, `3`. The discarded supernantant and its container cannot be used by downstream operations. Please set a valid destination for supernantant or allow it to be set automatically in order to label it for downstream operation. Note that if the intention was to use the resuspended samples downstream, they are the same objects as the SamplesIn, please set SampleOutLabel and ContainerOutLabel to Null or allow them to be set automatically.";
Error::LabelsCannotBeNullForCollectedSupernatant="The input(s), `1`, have the SupernatantDestination set to `2`, but have also specified Null for SampleOutLabel, `3`, or ContainerOutLabel, `4`. The labels are only allowed to be Null when the SupernatantDestination is set to Waste. Please check if the set SupernatantDestination is intended, and adjust SampleOutLabel and ContainerOutLabel accordingly or allow them to be set automatically.";

(* ::Subsection::Closed:: *)
(* ExperimentPellet*)


(* - Container to Sample Overload - *)

ExperimentPellet[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		cache, listedOptions,listedContainers,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,samplePreparationSimulation,containerToSampleSimulation
	},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Get the containers and options as lists. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions *)
	cache=ToList[Lookup[listedOptions, Cache, {}]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentPellet,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
	(* Return early. *)
	(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentPellet,
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
				ExperimentPellet,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];


	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
	(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
	(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentPellet[samples,ReplaceRule[sampleOptions,Simulation->samplePreparationSimulation]]
	]
];

(* -- Main Overload --*)
ExperimentPellet[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		cache, cacheBall, collapsedResolvedOptions, downloadFields, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
		listedSamples, messages, myOptionsWithPreparedSamples, myOptionsWithPreparedSamplesNamed, mySamplesWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed, resuspensionSourceSampleObjects, output, outputSpecification, pelletCache, performSimulationQ, resultQ,
		protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
		optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, safeOps, safeOpsNamed,
		safeOpsTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation,
		samplePreparationSimulation, validLengths, validLengthTests, validSamplePreparationResult, simulatedProtocol, simulation,
		estimatedTime
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentPellet,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentPellet,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPellet,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentPellet,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentPellet,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentPellet,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentPellet,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentPellet,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(* Fetch the cache from expandedSafeOps *)
	cache=ToList[Lookup[expandedSafeOps, Cache, {}]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	downloadFields={
		SamplePreparationCacheFields[Object[Sample], Format->Packet],
		Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
		Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
		Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]]
	};

	resuspensionSourceSampleObjects = DeleteDuplicates@Cases[Lookup[expandedSafeOps,ResuspensionSource,{}],ObjectP[Object]];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	pelletCache=Quiet[
		Download[
			Join[ToList[mySamplesWithPreparedSamples],resuspensionSourceSampleObjects],
			Evaluate@downloadFields,
			Cache->cache,
			Simulation ->samplePreparationSimulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[{cache,pelletCache}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentPelletOptions[ToList[Download[mySamples,Object]], expandedSafeOps,Cache->cacheBall,Simulation ->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentPelletOptions[ToList[Download[mySamples,Object]],expandedSafeOps,Cache->cacheBall,Simulation ->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentPellet,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* NOTE: We need to perform simulation if Result is asked for in Pellet since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
	resultQ = MemberQ[output, Result];

	(* If option resolution failed, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentPellet,collapsedResolvedOptions],
			Preview->Null,
			Simulation -> Simulation[]
		}]
	];


	(* Build packets with resources *)
	(* NOTE: If our resource packets function, if Preparation->Robotic, we call RSP in order to get the robotic unit operation *)
	(* packets. We also get a robotic simulation at the same time. *)
	{{resourceResult, roboticSimulation}, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{{$Failed, $Failed}, {}},
		gatherTests,
			pelletResourcePackets[ToList[Download[mySamples,Object]],templatedOptions,resolvedOptions,Cache->cacheBall,Simulation -> samplePreparationSimulation,Output->{Result,Tests}],
		True,
			{pelletResourcePackets[ToList[Download[mySamples,Object]],templatedOptions,resolvedOptions,Cache->cacheBall,Simulation -> samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[resourceResult, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
		simulateExperimentPellet[
			First[resourceResult], (* protocolPacket *)
			Rest[resourceResult], (* unitOperationPackets *)
			ToList[Download[mySamples,Object]],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->roboticSimulation,
			ParentProtocol->Lookup[safeOps,ParentProtocol]
		],
		True, {Null, roboticSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentPellet,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];
	(* estimate how long the protocol would take. Add an extra 10 minutes for bioSTAR/microbioSTAR because things are slow when HMotion is involved *)
	(* Centrifugation Time + 30 Second for other transfers, per sample. *)
	estimatedTime = Plus[
		Total[ToList[Lookup[collapsedResolvedOptions, Time]]],
		(Length[ToList[mySamples]]*30 Second),
		If[MatchQ[Lookup[safeOps, WorkCell], bioSTAR|microbioSTAR], 10 Minute, 0 Minute]
	];
	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			Rest[resourceResult], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
		Module[{primitive,nonHiddenOptions,samplesMaybeWithModels},

			(* convert the samples to models if we had model inputs originally *)
			(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
			(* NOTE: this is important. Need to use samplePreparationSimulation here and not simulation. This is because mySamples needs to get converted to model via the simulation _before_ SimulateResources is called in simulateExperimentPellet *)
			(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
			samplesMaybeWithModels=If[NullQ[samplePreparationSimulation] || Not[MatchQ[Lookup[resolvedOptions,PreparatoryUnitOperations],{_[_LabelSample]}]],
				mySamples,
				simulatedSamplesToModels[
					Lookup[resolvedOptions,PreparatoryUnitOperations][[1,1]],
					samplePreparationSimulation,
					mySamples
				]
			];
			(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
			primitive=Pellet@@Join[
				{
					Sample->samplesMaybeWithModels
				},
				RemoveHiddenPrimitiveOptions[Pellet,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentPellet,collapsedResolvedOptions];

			(* Memoize the value of ExperimentPellet so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentPellet,$PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentPellet]={};

				ExperimentPellet[___,options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification=Lookup[ToList[options],Output];

					frameworkOutputSpecification/.{
						Result->Rest[resourceResult],
						Options->nonHiddenOptions,
						Preview->Null,
						Simulation->simulation,

						RunTime->estimatedTime
					}
				];
				Module[{experimentFunction,resolvedWorkCell},
					(* look up which workcell we've chosen *)
					resolvedWorkCell=Lookup[resolvedOptions,WorkCell];

					(* pick the corresponding function from the association above *)
					experimentFunction=Lookup[$WorkCellToExperimentFunction,resolvedWorkCell];

					experimentFunction[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			]
		],

		(* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualSamplePreparation, generate an *)
		(* Object[Protocol, ManualSamplePreparation]. *)
		And[
			!MatchQ[Lookup[safeOps,ParentProtocol], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]],
			MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], Null|{}],
			MatchQ[Lookup[resolvedOptions, Incubate], {False..}],
			MatchQ[Lookup[resolvedOptions, Centrifuge], {False..}],
			MatchQ[Lookup[resolvedOptions, Filtration], {False..}],
			MatchQ[Lookup[resolvedOptions, Aliquot], {False..}]
		],
		Module[{primitive, nonHiddenOptions},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=Pellet@@Join[
					{
						Sample->Download[ToList[mySamples], Object]
					},
					RemoveHiddenPrimitiveOptions[Pellet,ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentPellet,collapsedResolvedOptions];

				(* Memoize the value of ExperimentPellet so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentPellet, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentPellet]={};

					ExperimentPellet[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation
						}
					];

					ExperimentManualSamplePreparation[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			(* NOTE: If Preparation->Manual, we don't have auxillary unit operation packets since there aren't batches. *)
			(* We only have unit operation packets when doing robotic. *)
			UploadProtocol[
				resourceResult[[1]],
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,Pellet],
				Cache->cache,
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentPellet,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedTime
	}
];


(* ::Subsection:: *)
(* resolvePelletMethod *)

DefineOptions[resolvePelletMethod,
	SharedOptions:>{
		ExperimentPellet,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySources can be Automatic when the user has not yet specified a value for autofill. *)
resolvePelletMethod[
	mySamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container], Model[Sample]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOptions, simulation, outputSpecification, output, gatherTests, centrifugeMethods, mapThreadFriendlyOptions, transferMethods,
		preResolvedMixOptions, resuspensionMixSamples, mixMethods, manualRequirementStrings, roboticRequirementStrings,
		expandedOptions, result, tests
	},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolvePelletMethod, ToList[myOptions]];

	simulation=Lookup[safeOptions, Simulation];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* See what methods we can do via Centrifuge. *)
	centrifugeMethods=resolveCentrifugeMethod[
		mySamples,
		Instrument->Lookup[safeOptions, Instrument, Automatic],
		Intensity->Lookup[safeOptions, Intensity, Automatic],
		Time->Lookup[safeOptions, Time, 5 Minute],
		Temperature->Lookup[safeOptions, Temperature, Ambient],
		Simulation->simulation
	];

	(* Get our map thread options. *)
	expandedOptions=Last[ExpandIndexMatchedInputs[ExperimentPellet,{mySamples},safeOptions]];
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentPellet,expandedOptions];

	(* See what methods we can do via Transfer. *)
	(* NOTE: The two transfers we can do are the supernatant transfer and resuspension transfer. Assume that resuspension *)
	(* is 1 Microliter of Milli-Q water since this is robotic compatible. Doesn't really matter if we resolve the resuspenion *)
	(* to False later, we just want to pass down the resuspension tip options to make sure they're not robot incompatible. *)
	transferMethods=resolveTransferMethod[
		Sequence@@Join@@@Transpose@MapThread[
			Function[{sample, options},
				{
					{
						sample,
						If[MatchQ[Lookup[options, ResuspensionSource], Automatic],
							Model[Sample, "Milli-Q water"],
							Lookup[options, ResuspensionSource]
						]
					},
					{
						Lookup[options, SupernatantDestination],
						sample
					},
					{
						Lookup[options, SupernatantVolume],
						If[MatchQ[Lookup[options, ResuspensionVolume], Automatic],
							1 Microliter,
							Lookup[options, ResuspensionVolume]
						]
					}
				}
			],
			{mySamples, mapThreadFriendlyOptions}
		],
		{
			Instrument->Riffle[Lookup[expandedOptions, SupernatantTransferInstrument], Lookup[expandedOptions, ResuspensionInstrument]],
			Sequence@@(
				ToExpression[#]->Riffle[Lookup[expandedOptions, ToExpression["SupernatantTransfer"<>#]], Lookup[expandedOptions, ToExpression["Resuspension"<>#]]]
			&)/@Options[TransferTipOptions][[All, 1]],
			Sequence@@(
				ToExpression[#]->Riffle[Lookup[expandedOptions, ToExpression["SupernatantTransfer"<>#]], Lookup[expandedOptions, ToExpression["Resuspension"<>#]]]
			&)/@Options[TransferRoboticTipOptions][[All, 1]],
			Simulation->Lookup[safeOptions, Simulation]
		}
	];

	(* Do some pre-resolving of ResuspensionMix and ResuspensionMixType. *)
	preResolvedMixOptions=Map[
		Function[{singletonOptions},
			Module[{resuspensionMixOptions},
				(* Pull out our resuspension mix options from all the options. *)
				resuspensionMixOptions=MapThread[
					(#1->#2&),
					{
						$PelletSharedResuspensionMixOptionMap[[All,2]],
						Lookup[singletonOptions, $PelletSharedResuspensionMixOptionMap[[All,2]]]
					}
				];

				(* If any resuspension mix options are set, resolve ResuspensionMix->True. *)
				If[MemberQ[Values[resuspensionMixOptions], Except[Automatic|Null]],
					ReplaceRule[resuspensionMixOptions, {ResuspensionMix->True}],
					ReplaceRule[resuspensionMixOptions, {ResuspensionMix->False, ResuspensionMixUntilDissolved->False}]
				]
			]
		],
		mapThreadFriendlyOptions
	];

	(* Pass down the samples that we are doing a resuspension mix on. *)
	resuspensionMixSamples=PickList[
		mySamples,
		Lookup[preResolvedMixOptions, ResuspensionMix],
		True
	];

	(* See what methods we can do via Mix. *)
	mixMethods=If[Length[resuspensionMixSamples]==0,
		{Manual, Robotic},
		resolveIncubateMethod[
			resuspensionMixSamples,
			Module[{resuspensionMixOptions,renamedOptions},
				resuspensionMixOptions=Cases[preResolvedMixOptions, KeyValuePattern[ResuspensionMix->True]];

				renamedOptions=(#[[1]] -> Lookup[resuspensionMixOptions,#[[2]]]&)/@$PelletSharedResuspensionMixOptionMap;
				Append[renamedOptions,Simulation->simulation]
			]
		]
	];

	(* Gather our manual requirement strings. *)
	manualRequirementStrings={
		If[MatchQ[ToList[centrifugeMethods], {Manual}],
			"the centrifuge options (Instrument, Intensity, Time, Temperature) dictate that the pelleting has to occur on a Manual centrifuge",
			Nothing
		],
		If[MatchQ[ToList[transferMethods], {Manual}],
			"the transfer options (supernatant aspiration and resuspension) dictate that the transfer has to occur Manually",
			Nothing
		],
		If[MatchQ[ToList[mixMethods], {Manual}],
			"the resuspension mix options dictate that the mixing has to occur Manually",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Gather our robotic requirement strings. *)
	roboticRequirementStrings={
		If[MatchQ[ToList[centrifugeMethods], {Robotic}],
			"the centrifuge options (Instrument, Intensity, Time, Temperature) dictate that the pelleting has to occur on a Robotic centrifuge",
			Nothing
		],
		If[MatchQ[ToList[transferMethods], {Robotic}],
			"the transfer options (supernatant aspiration and resuspension) dictate that the transfer has to occur Robotically",
			Nothing
		],
		If[MatchQ[ToList[mixMethods], {Robotic}],
			"the resuspension mix options dictate that the mixing has to occur Robotically",
			Nothing
		],
		If[MatchQ[ToList[mixMethods], {Robotic}],
			"the resuspension mix options dictate that the mixing has to occur Robotically",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};
	
	(* Return our result and tests. *)
	result=Which[
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Transfer primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];


(* ::Subsection:: *)
(* resolvePelletWorkCell *)

DefineOptions[resolvePelletWorkCell,
	SharedOptions :> {
		ExperimentPellet,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolvePelletWorkCell[
	mySamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container], Model[Sample]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, cache, simulation, initialFastAssoc, initialFastAssocKeys, workCell, preparation},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolvePelletWorkCell, ToList[myOptions]];
	{cache, simulation} = Lookup[safeOptions, {Cache, Simulation}];

	initialFastAssoc = makeFastAssocFromCache[cache];
	initialFastAssocKeys = Keys[initialFastAssoc];

	workCell = Lookup[myOptions, WorkCell, Automatic];
	preparation = Lookup[myOptions, Preparation];

	(* Determine the WorkCell that can be used *)
	Which[
		(* If WorkCell is specified, use that *)
		MatchQ[workCell, Except[Automatic]],
			{workCell},
		(* For Manual preparation, no work cell *)
		MatchQ[preparation, Manual],
			{},
		(* Otherwise, resolve based on SterileTechnique option and sample properties *)
		True,
			Module[
				{
					fastAssoc, allSpecifiedSampleObjs, allSpecifiedContainerModelObjs, allSpecifiedSampleModelObjs,
					samplePacketsExistQs, containerModelPacketExistQs, sampleModelPacketExistQs, remainingSampleObjs, remainingSampleModelObjs,
					remainingContainerModelObjs, allDownloadedStuff, allPackets, livingQ, mammalianQ, asepticHandlingQ
				},

				(* get all the relevant sample/container objects/models from the sources and destinations*)
				allSpecifiedSampleObjs = Download[DeleteDuplicates[Cases[ToList@mySamples, ObjectP[Object[Sample]]]], Object];
				allSpecifiedContainerModelObjs = Download[DeleteDuplicates[Cases[ToList@mySamples, ObjectP[Model[Container]]]], Object];
				allSpecifiedSampleModelObjs = Download[DeleteDuplicates[Cases[ToList@mySamples, ObjectP[Model[Sample]]]], Object];

				(* get all the specified tip models and objects from the option s*)

				(* figure out if we have all the information about input samples, containers, and models *)
				(* for input models this is easy: just do we have the packet at all? *)
				(* for samples, this means do we have packets for the container models, the containers, and the samples? *)
				samplePacketsExistQs = Map[
					Function[specifiedSampleObj,
						And[
							MemberQ[initialFastAssocKeys, specifiedSampleObj],
							MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Object}]],
							MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Model, Object}]]
						]
					],
					allSpecifiedSampleObjs
				];
				sampleModelPacketExistQs = Map[
					Function[specifiedSampleModel,
						MemberQ[initialFastAssocKeys, specifiedSampleModel]
					],
					allSpecifiedSampleModelObjs
				];
				containerModelPacketExistQs = Map[
					Function[specifiedContainerModel,
						MemberQ[initialFastAssocKeys, specifiedContainerModel]
					],
					allSpecifiedContainerModelObjs
				];

				(* get the remaining objects that we don't have any information about *)
				remainingSampleObjs = PickList[allSpecifiedSampleObjs, samplePacketsExistQs, False];
				remainingSampleModelObjs = PickList[allSpecifiedSampleModelObjs, sampleModelPacketExistQs, False];
				remainingContainerModelObjs = PickList[allSpecifiedContainerModelObjs, containerModelPacketExistQs, False];

				allDownloadedStuff = Quiet[
					Download[
						{
							remainingSampleObjs,
							remainingSampleModelObjs,
							remainingContainerModelObjs
						},
						{
							{
								Packet[Contents[[All,2]][{Name, CellType, Living, Sterile, AsepticHandling, Container, Position}]],
								Packet[Name, Sterile, AsepticHandling, Model, Contents],
								Packet[Model[{Name, CellType, Living, Sterile, AsepticHandling}]]
							},
							{Packet[Name, CellType, Sterile, AsepticHandling]},
							{Packet[Name, Sterile]}
						},
						Cache -> cache,
						Simulation -> simulation
					],
					{Download::NotLinkField, Download::FieldDoesntExist}
				];

				(* Join all packets. *)
				allPackets = FlattenCachePackets[{cache, allDownloadedStuff}];
				fastAssoc = makeFastAssocFromCache[allPackets];

				(* Get information that we need from our samples. *)
				livingQ = Or@@Map[
					Which[
						MatchQ[#, ObjectP[Object[Sample]]],
						TrueQ[fastAssocLookup[fastAssoc, #, Living]],
						MatchQ[#, ObjectP[Model[Sample]]],
						TrueQ[fastAssocLookup[fastAssoc, #, Living]],
						True,
						False
					]&,
					Join[allSpecifiedSampleModelObjs, allSpecifiedSampleObjs]
				];

				mammalianQ = Or@@Map[
					Which[
						MatchQ[#, ObjectP[Object[Sample]]],
						MatchQ[fastAssocLookup[fastAssoc, #, CellType], NonMicrobialCellTypeP],
						MatchQ[#, ObjectP[Model[Sample]]],
						MatchQ[fastAssocLookup[fastAssoc, #, CellType], NonMicrobialCellTypeP],
						True,
						False
					]&,
					Join[allSpecifiedSampleModelObjs, allSpecifiedSampleObjs]
				];

				asepticHandlingQ = And@@Map[
					Which[
						MatchQ[#, ObjectP[Object[Sample]]],
						MemberQ[{fastAssocLookup[fastAssoc, #, AsepticHandling], fastAssocLookup[fastAssoc, #, Sterile]}, True],
						MatchQ[#, ObjectP[Model[Sample]]],
						MemberQ[{fastAssocLookup[fastAssoc, #, AsepticHandling], fastAssocLookup[fastAssoc, #, Sterile]}, True],
						MatchQ[#, ObjectP[Model[Container]]],
						TrueQ[fastAssocLookup[fastAssoc, #, Sterile]],
						True,
						False
					]&,
					Join[allSpecifiedContainerModelObjs, allSpecifiedSampleModelObjs, allSpecifiedSampleObjs]
				];
				(* Return all available hamilton work cells *)
				Which[
					(* Default to bioSTAR for mammalian samples *)
					TrueQ[mammalianQ],
						{bioSTAR},
					(* Default to microbioSTAR for microbial samples *)
					!TrueQ[mammalianQ] && TrueQ[livingQ],
						{microbioSTAR},
					(* Default to bioSTAR or microbioSTAR when SterileTechnique is specified *)
					MemberQ[Lookup[myOptions, SterileTechnique], True],
						{bioSTAR, microbioSTAR},
					(* Default to bioSTAR for sterile but non-living samples, but allow using STAR when sterility is not a concern *)
					(* Typically, the first available work cell, bioSTAR, will be selected. However, in cases where sterility is not required, *)
					(* STAR can STILL be used for robotic transfers, even with initially sterile source/destination samples. *)
					(* This flexibility is useful when chaining primitives in SP/CP, as it allows evaluating all potential work cells to optimize consolidation. *)
					(* To prevent unintended use of STAR for sterile samples without explicit work cell specification from SP/CP, *)
					(* an error will be thrown if the Transfer option resolver detects a conflict between SterileTechnique and the selected WorkCell. *)
					Or[
						TrueQ[livingQ],
						TrueQ[asepticHandlingQ]
					],
						{bioSTAR, microbioSTAR, STAR},
					True,
						(* Otherwise return all hamilton workcells, and sort STAR as the first choice *)
						{STAR, bioSTAR, microbioSTAR}
				]
			]
	]
];
(* ::Subsection::Closed:: *)
(* resolveExperimentPelletOptions *)

DefineOptions[
	resolveExperimentPelletOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentPelletOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentPelletOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,cache,samplePrepOptions,simulatedSamples,resolvedSamplePrepOptions,pelletOptions,
		pelletOptionsAssociation,optionPrecisions,roundedExperimentOptions,optionPrecisionTests,resuspensionSetOptions,
		samplePrepTests,invalidInputs,invalidOptions,resolvedAliquotOptions, mapThreadFriendlyOptions,
		capVolumesForRoboticPrep,emptySimulationReturned,supernatantVolumeProxies,supernatantDestinationProxies,supernatantVolumeRoboticCapped,resuspensionVolumeRoboticCapped,uploadSampleVolumeChangePackets,resolvedSupernatantTransferSimulation,uploadResuspensionVolumeChangePackets,
		transferSharedOptionKeys, supernatantTransferOptionKeys, supernatantTransferOptionMap,supernatantTransferOptions,mapThreadFriendlySupernatantTransferOptions, resuspensionTransferOptionKeys, resuspensionTransferOptionMap,
		resolvedSupernatantTransferOptions, resolvedSupernatantTransferTests,resuspensionTransferInput,resuspensionTransferOptions,mapThreadFriendlyResuspensionTransferOptions,resolvedResuspensionOptions,resolvedResuspensionSimulation, resolvedResuspensionTests,

		invalidResuspensionResult, invalidResuspensionSamples, invalidResuspensionOptionValues, invalidResuspensionOptions, invalidResuspensionSourceSamples, invalidResuspensionSourceOptions,
		aliquotOptionsSymbols, resolvedCentrifugeOptions, centrifugeTests, expandedCentrifugeOptions,
		resolvedPostProcessingOptions, simulatedAliquotSamples, simulatedAliquotSamplePackets, simulatedAliquotContainerModelPackets,
		invalidLabelsForWasteDestination,invalidLabelsForWasteDestinationOptions,invalidLabelsForWasteDestinationTest,
		invalidNullLabelsForNonWasteDestination, invalidNullLabelsForNonWasteDestinationOptions, invalidNullLabelsForNonWasteDestinationTest,
		invalidResuspensionTest, invalidResuspensionSourceTest,

		email, resolvedOptions, pelletToMixOptions, preResolvedMixOptions, rawResolvedMixOptions, mixTests,
		resolvedMixOptions, invalidMixOptions, incubateResult, resolvedResuspensionBooleans, rawResolvedCentrifugeOptions,
		currentSimulation,resolvedSupernatantDestination, resolvedSampleLabel, resolvedSampleContainerLabel,
		resolvedSampleOutLabel, resolvedContainerOutLabel, resolvedSupernatantVolumes, resolvedResuspensionSources,
		resolvedResuspensionSourceLabels,resolvedResuspensionSourceContainerLabels, resolvedResuspensionVolumes, resolvedSterileTechniqueBooleans,
		resolvedPreparation, preparationTests, allowedPreparation,resolvedWorkCell,allowedWorkCells
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions,pelletOptions}=splitPrepOptions[myOptions];
	pelletOptionsAssociation=Association@@pelletOptions;

	(* Lookup our simulation. *)
	currentSimulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,currentSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentPellet,mySamples,samplePrepOptions,Cache->cache,Simulation->currentSimulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentPellet,mySamples,samplePrepOptions,Cache->cache,Simulation->currentSimulation,Output->Result],{}}
	];

	(* Resolve our preparation option. *)
	{allowedPreparation, preparationTests} = If[MatchQ[gatherTests, True],
		resolvePelletMethod[
			simulatedSamples,
			ReplaceRule[myOptions, {Simulation->currentSimulation, Output->{Result, Tests}}]
		],
		{
			resolvePelletMethod[
				simulatedSamples,
				ReplaceRule[myOptions, {Simulation->currentSimulation, Output->Result}]
			],
			{}
		}
	];
	
	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells = resolvePelletWorkCell[mySamples, ReplaceRule[myOptions, {Preparation -> resolvedPreparation, Cache -> cache, Simulation -> currentSimulation, Output -> Result}]];

	resolvedWorkCell = FirstOrDefault[allowedWorkCells];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(*-- OPTION PRECISION CHECKS --*)

	(* Note: We call the centrifuge and incubate resolvers which do the precision checks for us. This is so that we don't *)
	(* get out of sync with those resolver's precisions. *)

	(* First, define the option precisions that need to be checked for TotalProteinQuantification *)
	optionPrecisions={
		{SupernatantVolume,1*Microliter},
		{ResuspensionVolume,1*Microliter}
	};

	(* There are still a few options that we need to check the precisions of though. *)
	{roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,
		(*If we are gathering tests *)
		RoundOptionPrecision[pelletOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
		(* Otherwise *)
		{RoundOptionPrecision[pelletOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentPellet,roundedExperimentOptions];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* 1) The Resuspension options must be compatible. *)
	(* That is, if any of the resuspension options are set, we cannot have any Nulls. *)
	resuspensionSetOptions=Flatten@{
		Resuspension,
		ResuspensionSource,
		ResuspensionSourceLabel,
		ResuspensionVolume,
		ResuspensionInstrument,
		Values[$PelletSharedResuspensionMixOptionMap]
	};

	invalidResuspensionResult=MapThread[
		Function[{simulatedSample,singletonOptions},
			Module[{nullResuspensionOptions,nonNullResuspensionOptions},
				(* Get all of the resuspension options that are Null. *)
				nullResuspensionOptions=Cases[Normal@singletonOptions, (Verbatim[Rule][Alternatives@@resuspensionSetOptions,ListableP[Null|False]])];

				(* Get all of the resuspension options that are not Null. *)
				nonNullResuspensionOptions=Cases[Normal@singletonOptions, (Verbatim[Rule][Alternatives@@resuspensionSetOptions,ListableP[Except[Automatic, Except[Null|False]]]])];

				(* See if we have Null, non-Null, and Boolean options (or if the Resuspension boolean is on/off). *)
				If[Length[nullResuspensionOptions]>0 && Length[nonNullResuspensionOptions]>0,
					{simulatedSample, {Keys[nullResuspensionOptions], Keys[nonNullResuspensionOptions]}},
					Nothing
				]
			]
		],
		{simulatedSamples,mapThreadFriendlyOptions}
	];

	{invalidResuspensionSamples, invalidResuspensionOptionValues} = If[Length[invalidResuspensionResult]==0,
		{{},{}},
		Transpose[invalidResuspensionResult]
	];

	invalidResuspensionOptions=If[Length[invalidResuspensionResult] > 0,
		Message[Error::ResuspensionMismatch, ObjectToString[invalidResuspensionSamples, Cache->cache], invalidResuspensionOptionValues[[All,1]], invalidResuspensionOptionValues[[All,2]]];
		DeleteDuplicates[Flatten[invalidResuspensionOptionValues]],
		{}
	];

	invalidResuspensionTest=If[Length[invalidResuspensionResult] > 0,
		Test["The resuspension options are not conflicting with one another (a combination of set and Null values):", True, False],
		Test["The resuspension options are not conflicting with one another (a combination of set and Null values):", True, True]
	];

	(* 2) ResuspensionSource cannot be a Model[Sample] if ResuspensionVolume is All. *)
	(* Otherwise, we don't know how much ResuspensionSource to add. *)
	invalidResuspensionSourceSamples=MapThread[
		Function[{simulatedSample, singletonOptions},
			If[MatchQ[Lookup[singletonOptions, ResuspensionSource], ObjectP[Model[Sample]]] && MatchQ[Lookup[singletonOptions, ResuspensionVolume], All],
				simulatedSample,
				Nothing
			]
		],
		{simulatedSamples,mapThreadFriendlyOptions}
	];

	invalidResuspensionSourceOptions=If[Length[invalidResuspensionSourceSamples] > 0,
		Message[Error::ResuspensionSourceCannotBeModel, ObjectToString[invalidResuspensionSourceSamples, Cache->cache]];
		{ResuspensionSource, ResuspensionVolume},
		{}
	];

	invalidResuspensionSourceTest=If[Length[invalidResuspensionSourceSamples] > 0,
		Test["If ResuspensionSource is specified as a Model[Sample], ResuspensionVolume is not specified as All (otherwise, we do not know how much volume to use to resuspend the sample):", True, False],
		Test["If ResuspensionSource is specified as a Model[Sample], ResuspensionVolume is not specified as All (otherwise, we do not know how much volume to use to resuspend the sample):", True, True]
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	aliquotOptionsSymbols=Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"];

	(* 1) Call the centrifuge resolver to resolve {Instrument, Intensity, Time, Temperature}. *)
	(* Note: These options have the same name in ExperimentCentrifuge and our experiment. *)
	(* Additional Note: We pipe the aliquot options into ExperimentCentrifuge and let it resolve any aliquot options for us. *)
	(* This is because our sample could be in a non-centrifuge compatible container. *)
	(* This also means that we don't call the aliquot resolver ourselves at the bottom of our experiment. *)
	{rawResolvedCentrifugeOptions, centrifugeTests}=If[gatherTests,
		ExperimentCentrifuge[
			simulatedSamples,

			(* Pass down the centrifuge options. *)
			Time->Lookup[roundedExperimentOptions,Time],
			Intensity->Lookup[roundedExperimentOptions,Intensity],
			Instrument->Lookup[roundedExperimentOptions,Instrument],
			Temperature->Lookup[roundedExperimentOptions,Temperature],

			(* Pass down the Aliquot options. *)
			Sequence@@Map[
				(#[[1]]->#[[2]]&),
				Transpose[{aliquotOptionsSymbols, Lookup[samplePrepOptions,aliquotOptionsSymbols]}]
			],

			Preparation->resolvedPreparation,
			WorkCell->If[NullQ[resolvedWorkCell],Automatic,resolvedWorkCell],
			EnableSamplePreparation->False,
			Cache->cache,
			Simulation->currentSimulation,
			OptionsResolverOnly -> True,
			Output->{Options,Tests}
		],
		{
			ExperimentCentrifuge[
				simulatedSamples,

				(* Pass down the centrifuge options. *)
				Time->Lookup[roundedExperimentOptions,Time],
				Intensity->Lookup[roundedExperimentOptions,Intensity],
				Instrument->Lookup[roundedExperimentOptions,Instrument],
				Temperature->Lookup[roundedExperimentOptions,Temperature],

				(* Pass down the Aliquot options. *)
				Sequence@@Map[
					(#[[1]]->#[[2]]&),
					Transpose[{aliquotOptionsSymbols, Lookup[samplePrepOptions,aliquotOptionsSymbols]}]
				],

				Preparation->resolvedPreparation,
				WorkCell->If[NullQ[resolvedWorkCell],Automatic,resolvedWorkCell],
				EnableSamplePreparation->False,
				Cache->cache,
				Simulation->currentSimulation,
				OptionsResolverOnly -> True,
				Output->Options
			],
			{}
		}
	];

	(* Pull out the centrifuge options that are specific to pelleting. *)
	resolvedCentrifugeOptions=(#->Lookup[rawResolvedCentrifugeOptions,#]&)/@{Instrument, Intensity, Instrument, Time, Temperature};

	(* since some options will be collapsed in this output, make sure we expand them all *)
	expandedCentrifugeOptions=ExpandIndexMatchedInputs[ExperimentCentrifuge,{simulatedSamples},resolvedCentrifugeOptions];

	(* Pull out the aliquot options and simulate our aliquotted samples. *)
	resolvedAliquotOptions=(#->Lookup[rawResolvedCentrifugeOptions, #]&)/@aliquotOptionsSymbols;

	{simulatedAliquotSamples, currentSimulation} = simulateSamplesResourcePacketsNew[ExperimentPellet, simulatedSamples, resolvedAliquotOptions, Cache->cache,Simulation->currentSimulation];

	(* Get the container model and sample of the simulated aliquot sample. *)
	{simulatedAliquotSamplePackets, simulatedAliquotContainerModelPackets}=Download[
		{
			simulatedAliquotSamples,
			simulatedAliquotSamples
		},
		{
			{Packet[Volume, Composition]},
			{Packet[Container[Model][MaxVolume]]}
		},
		Simulation -> currentSimulation
	];
	{simulatedAliquotSamplePackets, simulatedAliquotContainerModelPackets}=Flatten/@{simulatedAliquotSamplePackets, simulatedAliquotContainerModelPackets};

	(* 2) Resolve our Supernatant and Resuspension options, simulating any aliquots from the centrifuge. *)
	{
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedSupernatantDestination,
		resolvedSampleOutLabel,
		resolvedContainerOutLabel,
		resolvedSupernatantVolumes,
		resolvedResuspensionBooleans,
		resolvedResuspensionSources,
		resolvedResuspensionSourceLabels,
		resolvedResuspensionSourceContainerLabels,
		resolvedResuspensionVolumes,
		resolvedSterileTechniqueBooleans
	} = Transpose@MapThread[
		Function[{sample, samplePacket, containerModelPacket, options},
			Module[
				{
					sampleLabel, containerLabel, supernatantDestination, sampleOutLabel, containerOutLabel, resuspensionBoolean,
					resuspensionSource, resuspensionVolume, resuspensionSourceLabel, simulatedResuspensionSourceContainerLabel, resuspensionSourceContainerLabel, supernatantTransferAspirationPosition,
					supernatantTransferAspirationPositionOffset, resolvedSupernatantVolume, sterileTechniqueBoolean
				},

				(* Resolve sample label. *)
				sampleLabel=Which[
					MatchQ[Lookup[options, SampleLabel], Except[Automatic]],
						Lookup[options, SampleLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[sample, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[sample, Object]],
					True,
						CreateUniqueLabel["pellet sample"]
				];

				(* Resolve container label. *)
				containerLabel=Which[
					MatchQ[Lookup[options, SampleContainerLabel], Except[Automatic]],
						Lookup[options, SampleContainerLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[Lookup[samplePacket, Container], Object]], _String],
						LookupObjectLabel[currentSimulation, Download[Lookup[samplePacket, Container], Object]],
					True,
						CreateUniqueLabel["pellet sample container"]
				];
				
				(* Resolve supernatant destination. *)
				supernatantDestination=Which[
					MatchQ[Lookup[options, SupernatantDestination], Except[Automatic]],
						Lookup[options, SupernatantDestination],
					And[
						MatchQ[Lookup[options, SupernatantDestination], Automatic],
						MatchQ[resolvedPreparation, Manual],

						(* NOTE: We can't use the aspirator to transfer into waste if we're not using an aspirator or transferring all. *)
						MatchQ[Lookup[options, SupernatantTransferInstrument], Automatic|ObjectP[{Model[Instrument, Aspirator],Object[Instrument, Aspirator]}]],
						MatchQ[Lookup[options, SupernatantVolume], All|Automatic],
						(*We can only resolve to waste if the user did not specify a SampleOutLabel or ContainerOutLabel, indicating that they wanted to use the supernatant downstream*)
						MatchQ[SampleOutLabel,Automatic|Null],
						MatchQ[ContainerOutLabel,Automatic|Null]
					],
						Waste,
					MatchQ[Lookup[options, SupernatantDestination], Automatic] && MatchQ[resolvedPreparation, Robotic],
						PreferredContainer[Lookup[samplePacket, Volume], LiquidHandlerCompatible->True],
					True,
						PreferredContainer[Lookup[samplePacket, Volume]]
				];

				(* Resolve sample out label/supernatant destination container label. *)
				sampleOutLabel=Which[
					MatchQ[Lookup[options, SampleOutLabel], Except[Automatic]],
						Lookup[options, SampleOutLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[supernatantDestination, ObjectP[Object[Sample]]] && MatchQ[LookupObjectLabel[currentSimulation, Download[supernatantDestination, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[supernatantDestination, Object]],
					MatchQ[supernatantDestination,Waste],
						Null,
					True,
						CreateUniqueLabel["pellet supernatant sample"]
				];
				containerOutLabel=Which[
					MatchQ[Lookup[options, ContainerOutLabel], Except[Automatic]],
						Lookup[options, ContainerOutLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[supernatantDestination, ObjectP[Object[Container]]] && MatchQ[LookupObjectLabel[currentSimulation, Download[supernatantDestination, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[supernatantDestination, Object]],
					MatchQ[supernatantDestination,Waste],
						Null,
					True,
						CreateUniqueLabel["pellet supernatant container"]
				];

				(* Resolve the Resuspension boolean. *)
				resuspensionBoolean=Which[
					MatchQ[Lookup[options, Resuspension], Except[Automatic]],
						Lookup[options, Resuspension],
					Length[Cases[Normal@options, (Verbatim[Rule][Alternatives@@resuspensionSetOptions,ListableP[Except[Null|Automatic|False]]])]]>0,
						True,
					True,
						False
				];

				(* Resolve Resuspension Source. *)
				resuspensionSource=Which[
					MatchQ[Lookup[options, ResuspensionSource], Except[Automatic]],
						Lookup[options, ResuspensionSource],
					MatchQ[resuspensionBoolean, True],
						Model[Sample, "Milli-Q water"],
					True,
						Null
				];
				resuspensionSourceLabel=Which[
					MatchQ[Lookup[options, ResuspensionSourceLabel], Except[Automatic]],
						Lookup[options, ResuspensionSourceLabel],
					MatchQ[resuspensionSource, Null],
						Null,
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[resuspensionSource, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[resuspensionSource, Object]],
					True,
						CreateUniqueLabel["pellet resuspension sample"]
				];

				(* This is a hidden field just to pass information. It is needed for manual preparation as all the labels must be present in the Pellet unit operation. *)
				simulatedResuspensionSourceContainerLabel=Quiet[LookupObjectLabel[currentSimulation, Lookup[fetchPacketFromCache[Download[resuspensionSource, Object],cache],Container]]];

				resuspensionSourceContainerLabel=Which[
					MatchQ[resuspensionSource, Null],
						Null,
					MatchQ[currentSimulation, SimulationP] && MatchQ[simulatedResuspensionSourceContainerLabel, _String],
						simulatedResuspensionSourceContainerLabel,
					True,
						CreateUniqueLabel["pellet resuspension source sample container"]
				];

				(* Resolve Resuspension Volume. *)
				resuspensionVolume=Which[
					MatchQ[Lookup[options, ResuspensionVolume], Except[Automatic]],
						Lookup[options, ResuspensionVolume],
					MatchQ[resuspensionBoolean, True],
						If[MatchQ[resolvedPreparation, Robotic],
							Min[{N[(Lookup[containerModelPacket, MaxVolume] - (Lookup[samplePacket, Volume]/.{Null->0 Milliliter}))/4], 970 Microliter}],
							N[(Lookup[containerModelPacket, MaxVolume] - (Lookup[samplePacket, Volume]/.{Null->0 Milliliter}))/4]
						],
					True,
						Null
				];

				(* Resolve aspiration position/position offset. *)
				supernatantTransferAspirationPosition=Which[
					MatchQ[Lookup[options, SupernatantTransferAspirationPosition], Except[Automatic]],
						Lookup[options, SupernatantTransferAspirationPosition],
					MatchQ[resolvedPreparation, Robotic],
						Bottom,
					True,
						Null
				];
				supernatantTransferAspirationPositionOffset=Which[
					MatchQ[Lookup[options, SupernatantTransferAspirationPositionOffset], Except[Automatic]],
						Lookup[options, SupernatantTransferAspirationPositionOffset],
					MatchQ[resolvedPreparation, Robotic],
						1.5 Centimeter,
					True,
						Null
				];
				
				(* Before calls the ExperimentTransfer option resolvers we first need to resolve the SupernatantVolume based on method*)
				resolvedSupernatantVolume=Which[
					
					(* Use what user specified *)
					MatchQ[Lookup[options, SupernatantVolume],Except[Automatic]],Lookup[options, SupernatantVolume],
					
					(* If user specified robotic set this as the half of the sample volume *)
					MatchQ[resolvedPreparation,Robotic], 0.5*(Lookup[samplePacket,Volume,0Microliter]),
					
					(* Default to All *)
					True, All
				
				];

				(* -- Resolve the SterileTechnique for the supernatant transfer. -- *)
				sterileTechniqueBoolean = Which[
					(* Use what the user specified. *)
					MatchQ[Lookup[options, SterileTechnique], Except[Automatic]],
						Lookup[options, SterileTechnique],
					(* If we're dealing with cells (of any type) in the sample, use sterile technique. *)
					MemberQ[Flatten[Lookup[samplePacket, Composition]], ObjectP[Model[Cell]]],
						True,
					(* If we're on the bioSTAR/microbioSTAR, we should use sterile technique. *)
					MatchQ[resolvedWorkCell, (bioSTAR|microbioSTAR)],
						True,
					(* Otherwise, no sterile technique. *)
					True,
						False
				];

				{
					sampleLabel,
					containerLabel,
					supernatantDestination,
					sampleOutLabel,
					containerOutLabel,
					resolvedSupernatantVolume,
					resuspensionBoolean,
					resuspensionSource,
					resuspensionSourceLabel,
					resuspensionSourceContainerLabel,
					resuspensionVolume,
					sterileTechniqueBoolean
				}
			]
		],
		{simulatedAliquotSamples, simulatedAliquotSamplePackets, simulatedAliquotContainerModelPackets, mapThreadFriendlyOptions}
	];
	(* Supernantant labeling error checking --1-- *)
	(* SampleOutLabel and ContainerOutLabel cannot be set to strings if SupernatantDestination is set to Waste *)
	invalidLabelsForWasteDestination=MapThread[
		Function[{simulatedSample, supernatantDestination,sampleOutLabel,containerOutLabel},
			If[
				MatchQ[supernatantDestination, Waste] && Or[
					MatchQ[sampleOutLabel, _String],
					MatchQ[containerOutLabel, _String]
				],
				Module[{invalidLabelOption},
					invalidLabelOption = PickList[{SampleOutLabel,ContainerOutLabel},{sampleOutLabel,containerOutLabel},_String];
					{simulatedSample,sampleOutLabel,containerOutLabel,invalidLabelOption}
				],
				Nothing
			]
		],
		{simulatedSamples,resolvedSupernatantDestination,resolvedSampleOutLabel,resolvedContainerOutLabel}
	];

	invalidLabelsForWasteDestinationOptions=If[Length[invalidLabelsForWasteDestination] > 0,
		Message[Error::LabelingDiscardedSupernatant,
			ObjectToString[invalidLabelsForWasteDestination[[All,1]], Cache->cache],(* simulated samples *)
			invalidLabelsForWasteDestination[[All,2]],(* sample out labels *)
			invalidLabelsForWasteDestination[[All,3]] (* container out labels *)
		];
		invalidLabelsForWasteDestination[[All,4]],
		{}
	];

	invalidLabelsForWasteDestinationTest=If[Length[invalidLabelsForWasteDestination] > 0,
		Test["If SupernatantDestination is specified as Waste, SampleOutLabel and ContainerOutLabel are not specified as strings as they cannot be further used downstream:", True, False],
		Test["If SupernatantDestination is specified as Waste, SampleOutLabel and ContainerOutLabel are not specified as strings as they cannot be further used downstream:", True, True]
	];

	(* Supernantant labeling error checking --2-- *)
	(* SampleOutLabel and ContainerOutLabel cannot be set to Null if SupernatantDestination is set to non-Waste *)
	invalidNullLabelsForNonWasteDestination=MapThread[
		Function[{simulatedSample, supernatantDestination,sampleOutLabel,containerOutLabel},
			If[
				MatchQ[supernatantDestination, ObjectP[]] && Or[
					MatchQ[sampleOutLabel, Null],
					MatchQ[containerOutLabel, Null]
				],
				Module[{invalidNullLabelOption},
					invalidNullLabelOption = PickList[{SampleOutLabel,ContainerOutLabel},{sampleOutLabel,containerOutLabel},Null];
					{simulatedSample,supernatantDestination,sampleOutLabel,containerOutLabel,invalidNullLabelOption}
				],
				Nothing
			]
		],
		{simulatedSamples,resolvedSupernatantDestination,resolvedSampleOutLabel,resolvedContainerOutLabel}
	];

	invalidNullLabelsForNonWasteDestinationOptions=If[Length[invalidNullLabelsForNonWasteDestination] > 0,
		Message[Error::LabelsCannotBeNullForCollectedSupernatant,
			ObjectToString[invalidNullLabelsForNonWasteDestination[[All,1]], Cache->cache],(* simulated samples *)
			ObjectToString[invalidNullLabelsForNonWasteDestination[[All,2]], Cache->cache],(* supernatant destinations *)
			invalidNullLabelsForNonWasteDestination[[All,3]],(* sample out labels *)
			invalidNullLabelsForNonWasteDestination[[All,4]](* container out labels *)
		];
		invalidNullLabelsForNonWasteDestination[[All,5]],
		{}
	];

	invalidNullLabelsForNonWasteDestinationTest=If[Length[invalidNullLabelsForNonWasteDestination] > 0,
		Test["If SupernatantDestination is specified as a non-waste destination, SampleOutLabel and ContainerOutLabel are not specified as Null (otherwise it might break framework):", True, False],
		Test["If SupernatantDestination is specified as a non-waste destination, SampleOutLabel and ContainerOutLabel are not specified as Null (otherwise it might break framework):", True, True]
	];

	(* 2.5 Resolve the shared transfer options for SupernatantTransfer and Resuspension *)
	(* Build option maps and preresolved option lists for using resolveSharedOptions *)
	(*List the shared transfer options mirroring whats in DefinedOptions for ExperimentPellet*)
	transferSharedOptionKeys = Join[{Instrument},ToExpression[#]&/@Keys[Join[Options[TransferTipOptions],Options[TransferRoboticTipOptions]]]];
	(*Construct the option maps and *)
	supernatantTransferOptionKeys = ToExpression["SupernatantTransfer" <> ToString[#]] & /@transferSharedOptionKeys;
	(*Also add a few options that we preresolved*)
	supernatantTransferOptionMap = Join[
		Normal[AssociationThread[supernatantTransferOptionKeys -> transferSharedOptionKeys]],
		{
			SterileTechnique -> SterileTechnique,
			SampleLabel -> SourceLabel,
			SampleContainerLabel -> SourceContainerLabel,
			SampleOutLabel -> DestinationLabel,
			ContainerOutLabel -> DestinationContainerLabel
		}
	];
	(* Take the shared transfer options from myOptions to pass to resolveSharedOptions[...] plus the supernatant transfer options that we just pre-resolved *)
	supernatantTransferOptions = ReplaceRule[
		Normal[KeyTake[myOptions, supernatantTransferOptionKeys], Association],
		{
			SterileTechnique -> resolvedSterileTechniqueBooleans,
			(*Also give Transfer the labels so that we can extract the packets for next resuspension's call*)
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			SampleOutLabel -> resolvedSampleOutLabel/.Null->Automatic(*Cannot be Null for Transfer, just feed Automatic for it to work with*),
			ContainerOutLabel -> resolvedContainerOutLabel/.Null->Automatic(*Cannot be Null for Transfer, just feed Automatic for it to work with*)
		}
	];
	mapThreadFriendlySupernatantTransferOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPellet, supernatantTransferOptions];

	(* TODO:: This is a temporary hacky work around to avoid resolve to using aspirators. Please revisit and remove when we have BSCs equipped with aspirators. Similar logic is also in the experiment function. *)
	(* Replace "All" in resolved supernatnant volume, replace with 90% sample volume at the time. Otherwise leave as is. *)
	supernatantVolumeProxies = MapThread[
		Function[{samplePacket,supernatantVolume},
			If[MatchQ[supernatantVolume,All],
				Module[{sampleVolume},
					sampleVolume = Lookup[samplePacket,Volume];
					Switch[sampleVolume,
						GreaterP[10Milliliter],
							SafeRound[0.9*sampleVolume,1Milliliter],
						GreaterP[1Milliliter],
							SafeRound[0.9*sampleVolume,0.1Milliliter],
						_,
						SafeRound[0.9*sampleVolume,1Microliter]
					]
				],
				supernatantVolume
			]
		],
		{simulatedAliquotSamplePackets,resolvedSupernatantVolumes}
	];
	(*Define a little local helper to cap the volume used in ExperimentTransfer call (in resolveSharedOptions with OptionsResolverOnly->True) when using robotic prep.*)
	capVolumesForRoboticPrep[volumes:{(VolumeP|All|Null)..},samplePackets:{PacketP[]..},preparation:Robotic|Manual]:=If[MatchQ[preparation,Robotic],
		(*If doing robotic prep, we further manipulate the volume here and cap the volume at 970uL-150uL so that the ExperimentTransfer call below would not error out while also avoid complications of having to split the transfers. The resolved transfer instrument and tips options should be the same, and simulation will be updated by UploadSampleTransfer packets with correct volumes.*)
		(* Note that the 150uL reduction in cap volume is because Transfer might add volume for considerations like overDispenseVolume, overAspirationVolume, and correction curve.*)
		(* We don't want to combine with the proxy above because the above is also going to be used in the UploadSampleTransfer call as the "real" transfer amount.*)
		MapThread[
			Function[{samplePacket,volume},
				Which[
					MatchQ[volume,All],
						Module[{sampleVolume},
							sampleVolume = Lookup[samplePacket,Volume];
							Min[SafeRound[0.9*sampleVolume,1Microliter],$MaxRoboticSingleTransferVolume-150Microliter]
						],
					MatchQ[volume,Null],
						volume,
					True,
						Min[volume,$MaxRoboticSingleTransferVolume-150Microliter]
				]
			],
			{samplePackets,volumes}
		],
		(*Otherwise no need to do anything*)
		volumes
	];
	(*Call the helper to process the supernatant volumes *)
	supernatantVolumeRoboticCapped = capVolumesForRoboticPrep[supernatantVolumeProxies,simulatedAliquotSamplePackets,resolvedPreparation];
	(*Replace "Waste" in resolved supernatant destination with a preferred container for the volume at the time. Otherwise leave as is.*)
	supernatantDestinationProxies = MapThread[
		Function[{samplePacket,supernatantDestination},
			Switch[{supernatantDestination,resolvedPreparation},
				{Waste,Robotic},
					PreferredContainer[Lookup[samplePacket, Volume], LiquidHandlerCompatible->True],
				{Waste,_},
					PreferredContainer[Lookup[samplePacket, Volume]],
				{_,_},
					supernatantDestination
			]
		],
		{simulatedAliquotSamplePackets,resolvedSupernatantDestination}
	];
	(* TODO:: End *)

	(* Call ExperimentTransfer to resolve the SupernatantTransferXX options. Here we really just want to resolve the instrument and tips options for the a sake of error checking and pass the resolved hidden options along. For the case of robotic preparation with >970 uL transfer volume, these options should be the same as using 970uL. Therefore we use the proxy volumes to resolve the options, and in the UploadSampleTransfer call, we use the actual volume *)
	{resolvedSupernatantTransferOptions,emptySimulationReturned, resolvedSupernatantTransferTests} =Quiet[
		resolveSharedOptions[
			(*Child resolver to call*)
			ExperimentTransfer,
			(*Message prefix to inform which process is throwing the error/warning*)
			"The following message was thrown when calculating the supernatant transfer options for the following samples, ",
			(*Input sample packets for the transfer. It should be the samples out from Centrifuge, but theoretically the same as aliquoted samples for resolving purpose*)
			simulatedAliquotSamplePackets,
			(*Masterswitches, always true for supernatant transfer*)
			ConstantArray[True,Length[simulatedAliquotSamples]],(*Supernatant transfer is performed for every sample*)
			(*Option map from Pellet to Transfer options*)
			supernatantTransferOptionMap,
			(*Options to resolve by Transfer, including the preresolved ones*)
			supernatantTransferOptions,
			(* No option needs to be set constant across all samples *)
			{Preparation -> resolvedPreparation,OptionsResolverOnly->True},
			mapThreadFriendlySupernatantTransferOptions,
			gatherTests,
			(*Destination and Amount are 2nd and 3rd input to ExperimentTransfer call *)
			AdditionalInputs -> {supernatantDestinationProxies,supernatantVolumeRoboticCapped},
			Simulation -> currentSimulation
		],
		{Warning::ConflictingSourceAndDestinationAsepticHandling}
	];
	(* Just update the volume here to avoid complications of finding the actual sample in supernatantDestination *)
	uploadSampleVolumeChangePackets = Module[{currentSampleVolumes,volumesAfterSupernatantTransfer},
		currentSampleVolumes = Lookup[simulatedAliquotSamplePackets,Volume];
		volumesAfterSupernatantTransfer = currentSampleVolumes - supernatantVolumeProxies;
		(*Generate the update packets*)
		UploadSampleProperties[simulatedAliquotSamples,Volume->volumesAfterSupernatantTransfer,Simulation->currentSimulation, Upload->False]
	];

	(* Update our simulation. *)
	resolvedSupernatantTransferSimulation=UpdateSimulation[currentSimulation, Simulation[uploadSampleVolumeChangePackets]];

	(*This is not ideal to call ExperimentTransfer twice, but kind of what we have to do here in resolver to have proper option returns and nice message handling*)
	resuspensionTransferInput = MapThread[
		Function[{samplePacket,resuspensionSource},
			Which[
				(*If resuspension is performed and resuspension source is an object, use its packet*)
				MatchQ[resuspensionSource,ObjectP[Object[Sample]]],
					fetchPacketFromCache[resuspensionSource,cache],
				(*If resuspension is performed and resuspension source is a model, use as is*)
				MatchQ[resuspensionSource,ObjectP[Model[Sample]]],
					resuspensionSource,
				(*Otherwise resuspension is not performed, we can just put in the input sample here for resolveSharedOptions to return Nulls for shared transfer options*)
				True,
					samplePacket
			]
		],
		{simulatedAliquotSamplePackets,resolvedResuspensionSources}
	];
	(*Call the helper to process the supernatant volumes *)
	resuspensionVolumeRoboticCapped = capVolumesForRoboticPrep[resolvedResuspensionVolumes,simulatedAliquotSamplePackets,resolvedPreparation];
	resuspensionTransferOptionKeys = ToExpression["Resuspension" <>  ToString[#]] & /@transferSharedOptionKeys;
	resuspensionTransferOptionMap =  Join[
		Normal[AssociationThread[resuspensionTransferOptionKeys -> transferSharedOptionKeys]],
		{
			SterileTechnique -> SterileTechnique
		}
	];
	(* Take the shared transfer options from myOptions to pass to resolveSharedOptions[...] plus the resuspension transfer options that we just pre-resolved *)
	resuspensionTransferOptions = ReplaceRule[
		Normal[KeyTake[myOptions, resuspensionTransferOptionKeys], Association],
		{
			SterileTechnique -> resolvedSterileTechniqueBooleans
		}
	];
	mapThreadFriendlyResuspensionTransferOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPellet, resuspensionTransferOptions];
	(* Call ExperimentTransfer to resolve the SupernatantTransferXX options *)
	{resolvedResuspensionOptions,emptySimulationReturned, resolvedResuspensionTests} =Quiet[
		resolveSharedOptions[
			(*Child resolver to call*)
			ExperimentTransfer,
			(*Message prefix to inform which process is throwing the error/warning*)
			"The following message was thrown when calculating the resuspension transfer options for the following samples, ",
			(*Input sample packets for the transfer. This is the resuspension media *)
			resuspensionTransferInput,
			(*Masterswitches of resolved resuspension*)
			If[Length[invalidResuspensionSamples]>0,
				(*If there is any mismatched resuspension options, don't let the shared option resolver actually call Transfer. It will likely crash if the pattern is off for destination or amount. Just let it return Nulls for these hidden options. Protocol won't be generated anyway.*)
				ConstantArray[False,Length[resuspensionTransferInput]],
				resolvedResuspensionBooleans
			],
			(*Option map from Pellet to Transfer options*)
			resuspensionTransferOptionMap,
			(*Options to resolve by Transfer, including the preresolved ones*)
			resuspensionTransferOptions,
			(* No option needs to be set constant across all samples *)
			{Preparation -> resolvedPreparation,OptionsResolverOnly->True},
			mapThreadFriendlyResuspensionTransferOptions,
			gatherTests,
			(*Destination and Amount are 2nd and 3rd input to ExperimentTransfer call. Here destinations are actually the input sample to Pellet that already has supernatant removed *)
			AdditionalInputs -> {simulatedAliquotSamples,resuspensionVolumeRoboticCapped},
			Simulation -> resolvedSupernatantTransferSimulation
		],
		{Warning::ConflictingSourceAndDestinationAsepticHandling}
	];
	(* Just update the volume here to avoid complications of simulate Models of ResuspensionMedia*)
	uploadResuspensionVolumeChangePackets = If[Length[invalidResuspensionSamples]==0 && MemberQ[resolvedResuspensionBooleans,True],
		(*If there is any resuspension happening, gather the volume change packets*)
		Module[{samplesToUpdate,currentSampleVolumes,volumesAfterResuspension},
			samplesToUpdate = PickList[simulatedAliquotSamplePackets,resolvedResuspensionBooleans,True];
			currentSampleVolumes = Download[samplesToUpdate,Volume,Simulation->resolvedSupernatantTransferSimulation];
			volumesAfterResuspension = currentSampleVolumes + PickList[resolvedResuspensionVolumes,resolvedResuspensionBooleans,True];
			(*Generate the update packets*)
			UploadSampleProperties[samplesToUpdate,Volume->volumesAfterResuspension,Simulation->resolvedSupernatantTransferSimulation, Upload->False]
		],
		(*Otherwise no resuspension is happening, Null for the simulation update*)
		Null
	];
	(* Update our simulation. *)
	resolvedResuspensionSimulation=UpdateSimulation[resolvedSupernatantTransferSimulation, Simulation[uploadResuspensionVolumeChangePackets]];


	(* 3) Call the incubate/mix resolver to resolve the ResuspensionMix options (simulating any aliquots from the centrifuge). *)
	(* Note: In the procedure we will spin off a mix subprotocol to do the mixing, unless we are mixing via pipette. *)
	(* We only call the incubate/mix resolver if we're resuspending the pellet (by default we're not). *)
	pelletToMixOptions=Reverse/@$PelletSharedResuspensionMixOptionMap;

	(* Do some pre-resolving of ResuspensionMix and ResuspensionMixType. *)
	preResolvedMixOptions=MapThread[
		Function[{singletonOptions, resuspensionVolume},
			Module[{resuspensionMixOptions},
				(* Pull out our resuspension mix options from all the options. *)
				resuspensionMixOptions=MapThread[
					(#1->#2&),
					{
						pelletToMixOptions[[All,1]],
						Lookup[singletonOptions, pelletToMixOptions[[All,1]]]
					}
				];

				Which[
					(* 1) If we are resuspending and none of the ResuspensionMix options are set, pre-resolve to mix by pipette. *)
					MatchQ[resuspensionVolume, VolumeP|All] && !MemberQ[Values[resuspensionMixOptions], Except[Automatic]],
						Merge[{
							resuspensionMixOptions,
							{
								ResuspensionMix->True,
								ResuspensionMixType->Pipette
							}
						}, Last],

					(* 2) If we are not resuspending and none of the ResuspensionMix options are set, resolve all ResuspensionMix options to False/Null. *)
					MatchQ[resuspensionVolume, Null] && !MemberQ[Values[resuspensionMixOptions], Except[Automatic|Null]],
						(If[MatchQ[#, ResuspensionMix|ResuspensionMixUntilDissolved], #->False, #->Null]&)/@Keys[resuspensionMixOptions],

					(* 3) If any resuspension mix options are set, resolve ResuspensionMix->True. *)
					MemberQ[Values[resuspensionMixOptions], Except[Automatic]] && MatchQ[Lookup[resuspensionMixOptions, ResuspensionMix], Automatic|True],
						Merge[{
							resuspensionMixOptions,
							{
								ResuspensionMix->True
							}
						}, Last],

					(* 4) Otherwise, resolve ResuspensionMix to False if it's Automatic. *)
					True,
						Merge[{
							resuspensionMixOptions,
							{
								ResuspensionMix->Lookup[resuspensionMixOptions, ResuspensionMix]/.{Automatic->False},
								ResuspensionMixUntilDissolved->Lookup[resuspensionMixOptions, ResuspensionMixUntilDissolved]/.{Automatic->False}
							}
						}, Last]/.{Automatic->Null}
				]
			]
		],
		{mapThreadFriendlyOptions,resolvedResuspensionVolumes}
	];

	(* Quiet any messages thrown by incubate so that we can throw our own error. *)
	incubateResult=Quiet[
		Check[
			(* Pass our pre-resolved mix options down to ExperimentIncubate. *)
			{rawResolvedMixOptions, mixTests}=If[MemberQ[Lookup[preResolvedMixOptions, ResuspensionMix], True],
				(* We have at least one sample we need to pass down to Incubate. *)
				If[gatherTests,
					ExperimentIncubate[
						PickList[simulatedAliquotSamples, Lookup[preResolvedMixOptions, ResuspensionMix], True],

						(* Pass down the mix options. *)
						Sequence@@(
							If[MatchQ[#[[2]], MaxTemperature],
								#[[2]]->PickList[Lookup[preResolvedMixOptions, #[[1]]], Lookup[preResolvedMixOptions, ResuspensionMix], True]/.{Automatic->Null},
								#[[2]]->PickList[Lookup[preResolvedMixOptions, #[[1]]], Lookup[preResolvedMixOptions, ResuspensionMix], True]
							]
						&)/@pelletToMixOptions,

						(* We cannot aliquot in this situation. *)
						Aliquot->False,
						Preparation->resolvedPreparation,

						EnableSamplePreparation->False,
						Cache->cache,
						Simulation->resolvedResuspensionSimulation,
						OptionsResolverOnly -> True,
						Output->{Options,Tests}
					],
					{
						ExperimentIncubate[
							PickList[simulatedAliquotSamples, Lookup[preResolvedMixOptions, ResuspensionMix], True],

							(* Pass down the mix options. *)
							Sequence@@(
								If[MatchQ[#[[2]], MaxTemperature],
									#[[2]]->PickList[Lookup[preResolvedMixOptions, #[[1]]], Lookup[preResolvedMixOptions, ResuspensionMix], True]/.{Automatic->Null},
									#[[2]]->PickList[Lookup[preResolvedMixOptions, #[[1]]], Lookup[preResolvedMixOptions, ResuspensionMix], True]
								]
							&)/@pelletToMixOptions,

							(* We cannot aliquot in this situation. *)
							Aliquot->False,
							Preparation->resolvedPreparation,

							EnableSamplePreparation->False,
							Cache->cache,
							Simulation->resolvedResuspensionSimulation,
							OptionsResolverOnly -> True,
							Output->Options
						],
						{}
					}
				],
				{{},{}}
			],
			$Failed,
			{Error::AliquotOptionConflict, Error::InvalidOption, Error::InvalidInput}
		],
		{Error::AliquotOptionConflict, Error::InvalidOption, Error::InvalidInput}
	];

	invalidMixOptions=If[MatchQ[incubateResult,$Failed],
		Message[Error::NoSuitableMixInstrument];
		{ResuspensionMixType},
		{}
	];

	(* Map our mix options to use the pelleting namespace. *)
	resolvedMixOptions=(
		Module[{incubationIndices},
			incubationIndices=Flatten[Position[Lookup[preResolvedMixOptions, ResuspensionMix], True]];

			(* We need to replace the indices that had ResuspensionMix->True. *)
			#[[1]]->ReplacePart[
				Lookup[preResolvedMixOptions, #[[1]]],
				MapThread[#1->#2&,{incubationIndices, Lookup[rawResolvedMixOptions, #[[2]], {}]}]
			]
		]
	&)/@pelletToMixOptions;

	(* since some options will be collapsed in this output, make sure we expand them all *)
	expandedCentrifugeOptions=If[!MatchQ[centrifugeOptions,$Failed],
		ExpandIndexMatchedInputs[ExperimentCentrifuge,{simulatedSamples},resolvedCentrifugeOptions][[2]],
		$Failed
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[
		ReplaceRule[myOptions, Preparation->resolvedPreparation],
		Living -> MemberQ[Lookup[simulatedAliquotSamplePackets,Living,Null],True],
		Sterile -> MemberQ[resolvedSterileTechniqueBooleans,True]
	];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions,ParentProtocol]], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions,ParentProtocol], ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* Overwrite our rounded options with our resolved options. Everything else has a default. *)
	resolvedOptions=Normal[
		Join[
			Association@roundedExperimentOptions,
			Association@{
				(* Centrifugation Options *)
				Instrument -> Lookup[expandedCentrifugeOptions, Instrument],
				Intensity -> Lookup[expandedCentrifugeOptions, Intensity],
				Time -> Lookup[expandedCentrifugeOptions, Time],
				Temperature -> Lookup[expandedCentrifugeOptions, Temperature],

				(* Special centrifuge options. *)
				resolvedCentrifugeOptions,

				(* Supernatant Options *)
				SampleLabel->resolvedSampleLabel,
				SampleContainerLabel->resolvedSampleContainerLabel,
				SupernatantDestination->resolvedSupernatantDestination,
				SampleOutLabel->resolvedSampleOutLabel,
				ContainerOutLabel->resolvedContainerOutLabel,
				SupernatantVolume->resolvedSupernatantVolumes,

				Resuspension->resolvedResuspensionBooleans,
				ResuspensionSource->resolvedResuspensionSources,
				ResuspensionSourceLabel->resolvedResuspensionSourceLabels,
				ResuspensionSourceContainerLabel -> resolvedResuspensionSourceContainerLabels,
				ResuspensionVolume->resolvedResuspensionVolumes,

				(* Sterile Technique for the transfer step. *)
				SterileTechnique -> resolvedSterileTechniqueBooleans,

				(* Special resuspension mix options. *)
				resolvedMixOptions,

				Preparation->resolvedPreparation,

				resolvedSamplePrepOptions,
				resolvedAliquotOptions,
				resolvedPostProcessingOptions,

				Email -> email,

				WorkCell->resolvedWorkCell
			},
			(* Supernatant transfer options *)
			KeyDrop[resolvedSupernatantTransferOptions,{SterileTechnique,SampleLabel,SampleContainerLabel,SampleOutLabel,ContainerOutLabel}],
			(* Resuspension transfer options *)
			KeyDrop[resolvedResuspensionOptions,{SterileTechnique}]
		],
		Association
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		invalidResuspensionSamples,
		invalidResuspensionSourceSamples
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		invalidResuspensionOptions,
		invalidResuspensionSourceOptions,
		invalidMixOptions,
		invalidLabelsForWasteDestinationOptions,
		invalidNullLabelsForNonWasteDestinationOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Flatten[{
			samplePrepTests,
			preparationTests,
			optionPrecisionTests,
			centrifugeTests,
			invalidResuspensionTest,
			invalidResuspensionSourceTest,
			invalidLabelsForWasteDestinationTest,
			invalidNullLabelsForNonWasteDestinationTest,
			resolvedSupernatantTransferTests,
			resolvedResuspensionTests
		}]
	}
];


(* ::Subsection::Closed:: *)
(* pelletResourcePackets *)


(* --- pelletResourcePackets --- *)

DefineOptions[
	pelletResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

pelletResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
		messages, inheritedCache, uniqueSamplesInResources, resolvedPreparation, mapThreadFriendlyOptions, labelSampleUOFromPreparedModels, oldSampleToLabelRules, oldSampleToModelRules,
		samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources, resolvedPrepUOs,
		protocolPacket,allResourceBlobs,resourcesOk,resourceTests,previewRule, optionsRule,testsRule,resultRule, modelInputQ,
		allUnitOperationPackets, currentSimulation, simulatedObjectsToLabel, expandedResolvedOptionsWithLabels,
		parentProtocol
	},
	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache,{}];

	(* Get the simulation *)
	currentSimulation=Lookup[ToList[ops],Simulation,{}];

	(* Lookup the resolved Preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentPellet, {mySamples}, myResolvedOptions];

	(* determine which objects in the simulation are simulated and make replace rules for those *)
	simulatedObjectsToLabel = If[NullQ[currentSimulation],
		{},
		Module[{allObjectsInSimulation, simulatedQ},
			(* Get all objects out of our simulation. *)
			allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

			(* Figure out which objects are simulated. *)
			simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, currentSimulation];

			(Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
		]
	];

	(* get the resolved options with simulated objects replaced with labels *)
	expandedResolvedOptionsWithLabels = expandedResolvedOptions /. simulatedObjectsToLabel;

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentPellet,
		RemoveHiddenOptions[ExperimentPellet,myResolvedOptions],
		Ignore->myTemplatedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	parentProtocol = Lookup[myResolvedOptions, ParentProtocol];

	(* Create resources for our samples in. *)
	uniqueSamplesInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[Download[mySamples, Object]];
	samplesInResources=(Download[mySamples, Object])/.uniqueSamplesInResources;

	(* Create resources for our containers in. *)
	sampleContainersIn=Download[mySamples, Container[Object], Cache->inheritedCache];
	uniqueSampleContainersInResources=(#->Resource[Sample->#, Name->CreateUUID[]]&)/@DeleteDuplicates[sampleContainersIn];
	containersInResources=(Download[sampleContainersIn, Object])/.uniqueSampleContainersInResources;

	(* pull out the parent protocol option*)
	parentProtocol = Lookup[myResolvedOptions, ParentProtocol];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentPellet,
		myResolvedOptions
	];

	(* --- Create the protocol packet --- *)


	(* if we have a model input LabelSample here and we're on the robot, set this bool to True and use it below *)
	resolvedPrepUOs = Lookup[myResolvedOptions, PreparatoryUnitOperations];
	modelInputQ = MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedPrepUOs, {_[_LabelSample]}];

	(* make the LabelSample unit operation; importantly here, we do NOT have resources; we just have models and labels *)
	(* also make rules converting model input samples to labels, and also those same model input samples back to their models *)
	{labelSampleUOFromPreparedModels, oldSampleToLabelRules, oldSampleToModelRules} = If[modelInputQ,
		Module[{resolvedUO, simLabelRules, labelToSampleRules, sampleToModelRules},
			resolvedUO = resolvedPrepUOs[[1, 1]];
			simLabelRules = currentSimulation[[1]][Labels];
			labelToSampleRules = Flatten[Map[
				Function[{label},
					SelectFirst[simLabelRules, MatchQ[label, #[[1]]]&, {}]
				],
				Flatten[{resolvedUO[Label], resolvedUO[ContainerLabel]}]
			]];

			sampleToModelRules = MapThread[
				(#1 /. labelToSampleRules) -> #2 &,
				{
					Join[resolvedUO[Label], resolvedUO[ContainerLabel]],
					Join[resolvedUO[Sample], resolvedUO[Container]]
				}
			];

			{
				resolvedUO,
				Reverse /@ labelToSampleRules,
				sampleToModelRules
			}
		],
		{Null, {}, {}}
	];

	(* update the simulation to _not_ have the labels that we are adding above *)
	currentSimulation = If[NullQ[currentSimulation],
		Null,
		With[{oldLabelRules = Lookup[First[currentSimulation], Labels], labelsToRemove = Values[oldSampleToLabelRules]},
			Simulation[
				Append[
					First[currentSimulation],
					Labels -> Select[oldLabelRules, Not[MemberQ[labelsToRemove, #[[1]]]]&]
				]
			]
		]
	];

	(* make unit operation packets for the UOs we just made here *)
	{protocolPacket, allUnitOperationPackets, currentSimulation} = If[MatchQ[resolvedPreparation, Manual],
		Module[{packet, prepPacket},
			(* Create our protocol packet. *)
			packet=<|
				Object->CreateID[Object[Protocol,Pellet]],
				Type->Object[Protocol,Pellet],

				Author->If[MatchQ[parentProtocol,Null],
					Link[$PersonID,ProtocolsAuthored]
				],
				ParentProtocol->If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
					Link[parentProtocol,Subprotocols]
				],

				Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
				Replace[ContainersIn]->(Link[#,Protocols]&/@containersInResources),

				Replace[Centrifugation]->(<|Instrument->Link[#[[1]]], Intensity->#[[2]], Time->#[[3]], Temperature->#[[4]]|>&)/@Transpose[{
					Lookup[expandedResolvedOptions, Instrument],
					Lookup[expandedResolvedOptions, Intensity],
					Lookup[expandedResolvedOptions, Time],
					Lookup[expandedResolvedOptions, Temperature]/.{Ambient -> $AmbientTemperature}
				}],

				Replace[SupernatantVolumes]->Lookup[expandedResolvedOptions, SupernatantVolume]/.{All->Null},
				Replace[SupernatantDestinations]->(Link/@(Lookup[expandedResolvedOptions, SupernatantDestination]/.{Waste->Null})),

				Replace[Resuspension]->Lookup[expandedResolvedOptions, Resuspension],

				Replace[ResuspensionSources]->(Link/@Lookup[expandedResolvedOptions, ResuspensionSource]),
				Replace[ResuspensionVolumes]->Lookup[expandedResolvedOptions, ResuspensionVolume]/.{All->Null},

				Replace[ResuspensionMix]->(<|
					Mix->#[[1]],
					MixType->#[[2]],
					MixUntilDissolved->#[[3]],
					Instrument->Link[#[[4]]],
					StirBar->Link[#[[5]]],
					Time->#[[6]],
					MaxTime->#[[7]],
					DutyCycle->#[[8]],
					MixRate->#[[9]],
					MixRateProfile -> #[[10]],
					NumberOfMixes->#[[11]],
					MaxNumberOfMixes->#[[12]],
					MixVolume->#[[13]],
					Temperature->#[[14]]/.{Ambient -> $AmbientTemperature},
					TemperatureProfile->#[[15]],
					MaxTemperature->#[[16]]/.{Ambient -> $AmbientTemperature},
					OscillationAngle->#[[17]],
					Amplitude->#[[18]],
					MixFlowRate->#[[19]],
					MixPosition->#[[20]],
					MixPositionOffset->#[[21]],
					CorrectionCurve->#[[22]],
					Tips->Link[#[[23]]],
					TipType->#[[24]],
					TipMaterial->#[[25]],
					MultichannelMix->#[[26]],
					DeviceChannel->#[[27]],
					ResidualIncubation->#[[28]],
					ResidualTemperature->#[[29]]/.{Ambient -> $AmbientTemperature},
					ResidualMix->#[[30]],
					ResidualMixRate->#[[31]],
					Preheat->#[[32]]
				|>&)/@Transpose[{
					Lookup[expandedResolvedOptions, ResuspensionMix],
					Lookup[expandedResolvedOptions, ResuspensionMixType],
					Lookup[expandedResolvedOptions, ResuspensionMixUntilDissolved],
					Lookup[expandedResolvedOptions, ResuspensionMixInstrument],
					Lookup[expandedResolvedOptions, ResuspensionMixStirBar],
					Lookup[expandedResolvedOptions, ResuspensionMixTime],
					Lookup[expandedResolvedOptions, ResuspensionMixMaxTime],
					Lookup[expandedResolvedOptions, ResuspensionMixDutyCycle],
					Lookup[expandedResolvedOptions, ResuspensionMixRate],
					Lookup[expandedResolvedOptions, ResuspensionMixRateProfile],
					Lookup[expandedResolvedOptions, ResuspensionNumberOfMixes],
					Lookup[expandedResolvedOptions, ResuspensionMaxNumberOfMixes],
					Lookup[expandedResolvedOptions, ResuspensionMixVolume],
					Lookup[expandedResolvedOptions, ResuspensionMixTemperature],
					Lookup[expandedResolvedOptions, ResuspensionMixTemperatureProfile],
					Lookup[expandedResolvedOptions, ResuspensionMixMaxTemperature],
					Lookup[expandedResolvedOptions, ResuspensionMixOscillationAngle],
					Lookup[expandedResolvedOptions, ResuspensionMixAmplitude],
					Lookup[expandedResolvedOptions, ResuspensionMixFlowRate],
					Lookup[expandedResolvedOptions, ResuspensionMixPosition],
					Lookup[expandedResolvedOptions, ResuspensionMixPositionOffset],
					Lookup[expandedResolvedOptions, ResuspensionMixCorrectionCurve],
					Lookup[expandedResolvedOptions, ResuspensionMixTips],
					Lookup[expandedResolvedOptions, ResuspensionMixTipType],
					Lookup[expandedResolvedOptions, ResuspensionMixTipMaterial],
					Lookup[expandedResolvedOptions, ResuspensionMixMultichannelMix],
					Lookup[expandedResolvedOptions, ResuspensionMixDeviceChannel],
					Lookup[expandedResolvedOptions, ResuspensionMixResidualIncubation],
					Lookup[expandedResolvedOptions, ResuspensionMixResidualTemperature],
					Lookup[expandedResolvedOptions, ResuspensionMixResidualMix],
					Lookup[expandedResolvedOptions, ResuspensionMixResidualMixRate],
					Lookup[expandedResolvedOptions, ResuspensionMixPreheat]
				}],

				Replace[SterileTechnique] -> Lookup[expandedResolvedOptions, SterileTechnique],

				UnresolvedOptions->RemoveHiddenOptions[ExperimentPellet,myTemplatedOptions],
				ResolvedOptions->myResolvedOptions,
				Name->Lookup[expandedResolvedOptions, Name],

				Replace[SamplesInStorage]->Lookup[expandedResolvedOptions, SamplesInStorageCondition, Null],
				Replace[SamplesOutStorage]->Lookup[expandedResolvedOptions, SamplesOutStorageCondition, Null],
				Replace[Checkpoints]->{
					{"Preparing Samples",15*Minute,"Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]},
					{"Picking Resources",15*Minute,"Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]},
					{"Pelleting",15*Minute,"The samples are centrifuged in order to precipitate solids that are present, the supernatant is aspirated, then the pellet is optionally resuspended.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]},
					{"Returning Materials",30*Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->30 Minute]]}
				}
			|>;

			(* Get our sample prep fields. *)
			prepPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

			(* Return. *)
			{Join[packet, prepPacket], {}, currentSimulation}
		],

		(* Robotic branch *)
		Module[
			{
				primitives,roboticUnitOperationPackets,roboticRunTime,roboticSimulation,
				centrifugePrimitive,transferPrimitives,pelletUnitOperationPacket},
			(*Centrifuge primitives*)

			centrifugePrimitive=Centrifuge@{
				Sample->mySamples,
				Instrument->Lookup[mapThreadFriendlyOptions,Instrument],
				Intensity->Lookup[mapThreadFriendlyOptions,Intensity],
				Time->Lookup[mapThreadFriendlyOptions,Time],
				Temperature->Lookup[mapThreadFriendlyOptions,Temperature]
			} /. oldSampleToLabelRules;

			transferPrimitives=Flatten@MapThread[
				Function[{sample,options},
					Module[{primitive},

						(* NOTE: Resuspension is optional, supernatant aspiration is not. *)
						primitive=If[MatchQ[Lookup[options,Resuspension],True],
							Transfer@{
								Source->{sample,Lookup[options,ResuspensionSource]},
								Destination->{Lookup[options,SupernatantDestination],sample},
								Amount->{Lookup[options,SupernatantVolume],Lookup[options,ResuspensionVolume]},
								If[MatchQ[resolvedPreparation,Manual],
									Supernatant->{True,False},
									Nothing
								],
								SterileTechnique->Lookup[options,SterileTechnique],
								Instrument->{
									Lookup[options,SupernatantTransferInstrument],
									Lookup[options,ResuspensionInstrument]
								},
								SourceLabel->{Lookup[options,SampleLabel],Lookup[options,ResuspensionSourceLabel]},
								SourceContainerLabel->{Lookup[options,SampleContainerLabel],Automatic},
								DestinationLabel->{Lookup[options,SampleOutLabel],Automatic},
								DestinationContainerLabel->{Lookup[options,ContainerOutLabel],Automatic},
								(* NOTE: these options might be automatic at this point *)
								Sequence@@(
									ToExpression[#]->{
										Lookup[options,ToExpression["SupernatantTransfer"<>#]],
										Lookup[options,ToExpression["Resuspension"<>#]]
									}
										&)/@Options[TransferTipOptions][[All,1]],
								Sequence@@(
									ToExpression[#]->{
										Lookup[options,ToExpression["SupernatantTransfer"<>#]],
										Lookup[options,ToExpression["Resuspension"<>#]]
									}
										&)/@Options[TransferRoboticTipOptions][[All,1]]
							},
							Transfer@{
								Source->{sample},
								Destination->{Lookup[options,SupernatantDestination]},
								Amount->{Lookup[options,SupernatantVolume]},
								If[MatchQ[resolvedPreparation,Manual],
									Supernatant->{True},
									Nothing
								],
								SterileTechnique->Lookup[options,SterileTechnique],
								Instrument->{Lookup[options,SupernatantTransferInstrument]},
								SourceLabel->{Lookup[options,SampleLabel]},
								SourceContainerLabel->{Lookup[options,SampleContainerLabel]},
								DestinationLabel->{Lookup[options,SampleOutLabel]},
								DestinationContainerLabel->{Lookup[options,ContainerOutLabel]},
								(* NOTE: these options might be automatic at this point *)
								Sequence@@(
									ToExpression[#]->{
										Lookup[options,ToExpression["SupernatantTransfer"<>#]]
									}
										&)/@Options[TransferTipOptions][[All,1]],
								Sequence@@(
									ToExpression[#]->{
										Lookup[options,ToExpression["SupernatantTransfer"<>#]]
									}
										&)/@Options[TransferRoboticTipOptions][[All,1]]
							}
						];

						{primitive /. oldSampleToLabelRules}
					]
				],
				{mySamples,mapThreadFriendlyOptions}
			];

			(* Combine to together *)
			primitives=Flatten[{
				If[NullQ[labelSampleUOFromPreparedModels], Nothing, labelSampleUOFromPreparedModels],
				centrifugePrimitive,
				transferPrimitives
			}];
			Module[{experimentFunction,resolvedWorkCell},
				(* look up which workcell we've chosen *)
				resolvedWorkCell=Lookup[myResolvedOptions,WorkCell];
				(* pick the corresponding function from the association above *)
				experimentFunction=Lookup[$WorkCellToExperimentFunction,resolvedWorkCell,ExperimentRoboticSamplePreparation];
				(* run the experiment *)
				(* Get our robotic unit operation packets. *)
				{{roboticUnitOperationPackets,roboticRunTime},roboticSimulation}= Quiet[
					experimentFunction[
						primitives,
						UnitOperationPackets->True,
						Output->{Result,Simulation},
						(* NOTE: We don't want the order of the centrifuge and transfers to change. The transfers should occur after the *)
						(* centrifuge so the pellet doesn't start dissolving. *)
						OptimizeUnitOperations->False,
						FastTrack->Lookup[expandedResolvedOptions,FastTrack],
						ParentProtocol->Lookup[expandedResolvedOptions,ParentProtocol],
						Name->Lookup[expandedResolvedOptions,Name],
						Simulation->currentSimulation,
						Upload->False,
						ImageSample->Lookup[expandedResolvedOptions,ImageSample],
						MeasureVolume->Lookup[expandedResolvedOptions,MeasureVolume],
						MeasureWeight->Lookup[expandedResolvedOptions,MeasureWeight],
						Priority->Lookup[expandedResolvedOptions,Priority],
						StartDate->Lookup[expandedResolvedOptions,StartDate],
						HoldOrder->Lookup[expandedResolvedOptions,HoldOrder],
						QueuePosition->Lookup[expandedResolvedOptions,QueuePosition]
					],
					Warning::ConflictingSourceAndDestinationAsepticHandling
				];
			];

			(* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
			pelletUnitOperationPacket=UploadUnitOperation[
				Module[{nonHiddenOptions},
					(* Only include non-hidden options from Transfer. *)
					nonHiddenOptions=allowedKeysForUnitOperationType[Object[UnitOperation,Pellet]];

					Pellet@Join[
						Cases[Normal[expandedResolvedOptionsWithLabels],Verbatim[Rule][Alternatives@@nonHiddenOptions,_]],
						{
							(* convert to the sample or instrument objects that go in the resource *)
							(* this is because we can't have the resources in here twice (in this one and in the subs) *)
							(* ONLY do this if we have Model inputs because it messes everything up if we don't *)
							Sample->If[modelInputQ,
								samplesInResources/.{x_Resource :> Lookup[First[x], Sample, Lookup[First[x], Instrument]]},
								samplesInResources
							],
							RoboticUnitOperations->(Link/@Lookup[roboticUnitOperationPackets,Object])
						}
					]

				],
				Preparation->Robotic,
				UnitOperationType->Output,
				Upload->False
			];

			(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
			roboticSimulation = updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations];

			(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
			roboticSimulation=If[Length[roboticUnitOperationPackets]==0,
				roboticSimulation,
				updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations]
			];

			(* Return back our packets and simulation. *)
			{
				Null,
				(* don't want simulated samples to still be int his packet; need to go back to models if necessary (i.e., if we're having a model input) *)
				Flatten[{pelletUnitOperationPacket /. oldSampleToModelRules, roboticUnitOperationPackets}],
				roboticSimulation
			}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs=If[MatchQ[resolvedPreparation, Manual],
		DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]],
		{}
	];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		(* NOTE: If we're robotic, the framework will call FRQ for us. *)
		MatchQ[$ECLApplication,Engine] || MatchQ[resolvedPreparation, Robotic],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->currentSimulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache,Simulation->currentSimulation],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation},
		{$Failed, currentSimulation}
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsection::Closed:: *)
(*Simulation*)

(* ::Subsubsection::Closed:: *)
(*simulateExperimentPellet*)

DefineOptions[
	simulateExperimentPellet,
	Options:>{CacheOption, SimulationOption}
];

simulateExperimentPellet[
	myProtocolPacket:(PacketP[Object[Protocol, Pellet], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]...}|$Failed),
	mySamples:{ObjectP[Object[Sample]]..},
	myResolvedOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[simulateExperimentPellet]
] := Module[
	{cache, simulation, samplePackets, protocolObject, mapThreadFriendlyOptions, resolvedPreparation, simulatedSamples, currentSimulation,
		simulationWithLabels},
	cache= Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	(* Download containers from our sample packets. *)
	samplePackets = Download[
		mySamples,
		Packet[Container],
		Cache -> cache,
		Simulation -> simulation
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[Lookup[myResolvedOptions, Preparation], Robotic],
			SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol,Pellet]],
		True,
			Lookup[myProtocolPacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentPellet,
		myResolvedOptions
	];

	(* Lookup our resolved preparation. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			SimulateResources[
				<|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					ResolvedOptions -> myResolvedOptions
				|>,
				myUnitOperationPackets,
				Simulation->simulation
			],
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Pellet]. *)
		True,
			SimulateResources[
				myProtocolPacket,
				myUnitOperationPackets,
				ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null],
				Simulation->simulation
			]
	];

	(* NOTE: Pellet is a little non-standard in that we're really just relying on Centrifuge/Transfer under the hood. *)

	(* First, simulate the sample preparation. This includes the aliquot that will put the sample into a centrifuge compatible *)
	(* container, if we're doing this manually. *)
	{simulatedSamples, currentSimulation} = simulateSamplesResourcePacketsNew[
		ExperimentPellet,
		mySamples,
		myResolvedOptions,
		Cache -> cache,(*This is needed to properly pass sample info e.g. State through to the simulated samples*)
		Simulation->currentSimulation
	];

	(* Then, form our transfer call that will do the rest of the simulation. *)
	(* NOTE: If we're in robotic or don't have a protocol packet, don't do any simulating. For robotic, we did the simulating already *)
	(* in the option resolver. *)
	currentSimulation=If[MatchQ[myProtocolPacket, $Failed|Null] || MatchQ[resolvedPreparation, Robotic],
		currentSimulation,
		Module[{transposedInputsAndOptions, newSimulation,sanitizedSampleOutLabels,sanitizedContainerOutLabels,labelsToRemoveFromSimulation,sanitizedNewSimulation,
			(*variables for the no-aspirator hack*)
			simulatedSampleVolumes,supernatantVolumeProxies,supernatantDestinationProxies},
			(* TODO:: This is a temporary hacky work around to avoid resolve to using aspirators. Please revisit and remove when we have BSCs equipped with aspirators. Similar logic is also in option resolver and compiler. *)
			(*get the sample volumes post aliquot*)
			simulatedSampleVolumes = Download[simulatedSamples,Volume,Simulation->currentSimulation];
			(* Replace "All" in resolved supernatnant volume, replace with 90% sample volume at the time. Otherwise leave as is. *)
			supernatantVolumeProxies = MapThread[
				Function[{sampleVolume,options},
					If[MatchQ[Lookup[options,SupernatantVolume],All],
						Switch[sampleVolume,
							GreaterP[10Milliliter],
							SafeRound[0.9*sampleVolume,1Milliliter],
							GreaterP[1Milliliter],
							SafeRound[0.9*sampleVolume,0.1Milliliter],
							_,
							SafeRound[0.9*sampleVolume,1Microliter]
						],
						Lookup[options,SupernatantVolume]
					]
				],
				{simulatedSampleVolumes,mapThreadFriendlyOptions}
			];
			(*Replace "Waste" in resolved supernatant destination with a preferred container for the volume at the time. Otherwise leave as is.*)
			supernatantDestinationProxies = MapThread[
				Function[{sampleVolume,options},
					Switch[{Lookup[options,SupernatantDestination],resolvedPreparation},
						{Waste,Robotic},
						PreferredContainer[sampleVolume, LiquidHandlerCompatible->True],
						{Waste,_},
						PreferredContainer[sampleVolume],
						{_,_},
						Lookup[options,SupernatantDestination]
					]
				],
				{simulatedSampleVolumes,mapThreadFriendlyOptions}
			];
			(* Need to manipulate the labels because 1) we used proxies above so that Transfer takes actual objects instead of Waste, they have to be labeled, 2) we need to remove those waste labels from simulation when in manual prep as it will make FutureLabeledObjects point to Transfer field.*)
			sanitizedSampleOutLabels = Map[
				Function[{options},
					Module[{sampleOutLabel,destination},
						sampleOutLabel = Lookup[options,SampleOutLabel];
						destination = Lookup[options,SupernatantDestination];
						Switch[{destination,resolvedPreparation},
							(*If supernatant destination is waste, and using manual prep, the resolved SampleOutLabel would be Null here, but we need to feed Transfer a label to make it through, and then use this label to delete in the simulation*)
							{Waste,Manual},
								CreateUniqueLabel["pellet manual waste to remove in simulation"],
							(*If supernatant destination is waste, and using robotic prep, the resolved SampleOutLabel would be Null here, but we need to feed Transfer a label to make it through, and it is okay to have a label for it in robotic prep*)
							{Waste,Robotic},
								Automatic,
							{_,_},
								sampleOutLabel
						]
					]
				],
				mapThreadFriendlyOptions
			];
			sanitizedContainerOutLabels = Map[
				Function[{options},
					Module[{containerOutLabel,destination},
						containerOutLabel = Lookup[options,ContainerOutLabel];
						destination = Lookup[options,SupernatantDestination];
						Switch[{destination,resolvedPreparation},
							(*If supernatant destination is waste, and using manual prep, the resolved SampleOutLabel would be Null here, but we need to feed Transfer a label to make it through, and then use this label to delete in the simulation*)
							{Waste,Manual},
								CreateUniqueLabel["pellet manual waste to remove in simulation"],
							(*If supernatant destination is waste, and using robotic prep, the resolved SampleOutLabel would be Null here, but we need to feed Transfer a label to make it through, and it is okay to have a label, the simulation will point to a field in RoboticUnitOperations*)
							{Waste,Robotic},
								Automatic,
							{_,_},
								containerOutLabel
						]
					]
				],
				mapThreadFriendlyOptions
			];
			(*Extract a list of labels to remove from simulation*)
			labelsToRemoveFromSimulation = Select[Flatten[{sanitizedSampleOutLabels,sanitizedContainerOutLabels}],StringContainsQ["pellet manual waste to remove in simulation"]];
			(* TODO:: End *)

			(* Create a list of inputs/options to pass down to ExperimentTransfer. *)
			transposedInputsAndOptions=MapThread[
				Function[{sample, options, supernatantVolumeProxy,supernatantDestinationProxy,sanitizedSampleOutLabel,sanitizedContainerOutLabel},
					(* NOTE: Resuspension is optional, supernatant aspiration is not. *)
					If[MatchQ[Lookup[options, Resuspension], True],
						{
							Source->{sample, Lookup[options, ResuspensionSource]},
							Destination->{supernatantDestinationProxy, sample},
							Amount->{supernatantVolumeProxy, Lookup[options, ResuspensionVolume]},
							Supernatant -> If[MatchQ[resolvedPreparation, Manual],
								{True, False},
								Automatic
							],
							Instrument -> {
								Lookup[options, SupernatantTransferInstrument],
								Lookup[options, ResuspensionInstrument]
							},
							SourceLabel -> {Lookup[options, SampleLabel], Lookup[options, ResuspensionSourceLabel]},
							SourceContainerLabel -> {Lookup[options, SampleContainerLabel], Lookup[options, ResuspensionSourceContainerLabel]},
							DestinationLabel -> {sanitizedSampleOutLabel, Lookup[options, SampleLabel]},
							DestinationContainerLabel -> {sanitizedContainerOutLabel, Lookup[options, SampleContainerLabel]},
							Sequence @@ (
								ToExpression[#] -> {
									Lookup[options, ToExpression["SupernatantTransfer" <> #]],
									Lookup[options, ToExpression["Resuspension" <> #]]
								}
							&) /@ Options[TransferTipOptions][[All, 1]],
							Sequence @@ (
								ToExpression[#] -> {
									Lookup[options, ToExpression["SupernatantTransfer" <> #]],
									Lookup[options, ToExpression["Resuspension" <> #]]
								}
							&) /@ Options[TransferRoboticTipOptions][[All, 1]]
						},
						{
							Source->{sample},
							Destination->{supernatantDestinationProxy},
							Amount->{supernatantVolumeProxy},
							Supernatant -> If[MatchQ[resolvedPreparation, Manual],
								{True},
								Automatic
							],
							Instrument -> {Lookup[options, SupernatantTransferInstrument]},
							SourceLabel -> {Lookup[options, SampleLabel]},
							SourceContainerLabel -> {Lookup[options, SampleContainerLabel]},
							DestinationLabel -> {sanitizedSampleOutLabel},
							DestinationContainerLabel -> {sanitizedContainerOutLabel},
							Sequence @@ (
								ToExpression[#] -> {
									Lookup[options, ToExpression["SupernatantTransfer" <> #]]
								}
							&) /@ Options[TransferTipOptions][[All, 1]],
							Sequence @@ (
								ToExpression[#] -> {
									Lookup[options, ToExpression["SupernatantTransfer" <> #]]
								}
							&) /@ Options[TransferRoboticTipOptions][[All, 1]]
						}
					]
				],
				{simulatedSamples, mapThreadFriendlyOptions,supernatantVolumeProxies,supernatantDestinationProxies,sanitizedSampleOutLabels,sanitizedContainerOutLabels}
			];

			(*Call ExperimentTransfer directly if manual, call ExperimentRoboticSamplePreparation for possibly splitting the transfers if Robotic*)
			sanitizedNewSimulation = If[MatchQ[resolvedPreparation,Manual],
				(*For manual preparation, we need to process the returned simulation to remove the waste labels we arbitrarilyy fed*)
				newSimulation=ExperimentTransfer[
					Join @@ Lookup[transposedInputsAndOptions, Source],
					Join @@ Lookup[transposedInputsAndOptions, Destination],
					Join @@ Lookup[transposedInputsAndOptions, Amount],
					Join[
						(#->Join@@Lookup[transposedInputsAndOptions, #]&)/@Cases[Keys[transposedInputsAndOptions[[1]]], Except[Source|Destination|Amount]],
						{
							Simulation->currentSimulation,
							Output->Simulation
						}
					]
				];
				If[Length[labelsToRemoveFromSimulation]>0,
					DeleteCases[newSimulation,Alternatives[Sequence @@Flatten[{#->ObjectP[],#->Field[_]}&/@labelsToRemoveFromSimulation]],3],
					newSimulation
				],
				(*Robotic mode needs to call RSP to deal with potentially need to split transfers*)
				ExperimentRoboticSamplePreparation[
					Transfer[
						Source -> Join @@ Lookup[transposedInputsAndOptions, Source],
						Destination -> Join @@ Lookup[transposedInputsAndOptions, Destination],
						Amount -> Join @@ Lookup[transposedInputsAndOptions, Amount],
						(#->Join@@Lookup[transposedInputsAndOptions, #]&)/@Cases[Keys[transposedInputsAndOptions[[1]]], Except[Source|Destination|Amount]]
					],
					Simulation->currentSimulation,
					Output->Simulation
				]
			];

			UpdateSimulation[currentSimulation,sanitizedNewSimulation]
		]
	];

	(* NOTE: The labels should already be filled out via ExperimentTransfer. *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleOutLabel], (Field[SupernatantDestinationLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, ContainerOutLabel], (Field[SupernatantDestinationLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, ResuspensionSourceLabel], (Field[ResuspensionSourceLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, ResuspensionSourceContainerLabel], (Field[ResuspensionSourceLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];
