(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentFlashFreeze*)


(* ::Subsubsection:: *)
(*ExperimentFlashFreeze Options and Messages*)

DefineOptions[ExperimentFlashFreeze,
	Options:>{
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"Indicates which flash freezing dewar instrument should be used.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,Dewar],Object[Instrument,Dewar]}]],
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->FreezingTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,3*Hour,1 Second,Inclusive->None],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The amount of time the sample will be flash frozen. If FreezeUntilFrozen is specified, FreezingTime refers to the initial time at which the sample will be frozen, before an additional check is performed to determine if more time needs to be added on.",
				ResolutionDescription->"If no options are provided, the sample volume will be used to determine an estimated freezing time.",
				AllowNull->False,
				Category->"Method"
			},
			{
				OptionName->FreezeUntilFrozen,
				Default->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates whether flash freezing should be performed until the sample is entirely frozen.",
				ResolutionDescription->"If no options are provided, will default to True.",
				AllowNull->False,
				Category->"Method"
			},
			{
				OptionName->MaxFreezingTime,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Minute,$MaxExperimentTime],
					Units->Alternatives[Hour,Minute,Second]
				],
				Description->"The maximum amount of time the sample will be flash frozen if FreezeUntilFrozen is set to True. MaxFreezingTime must be larger than FreezingTime.",
				ResolutionDescription->"If no options are provided, will default to null unless FreezeUntilFrozen is turned on, in which case it will default to "<>ToString[$MaxExperimentTime]<>".",
				AllowNull->True,
				Category->"Method"
			}
		],
		(* Default SamplesInStorageCondition to Disposal. Note that this is index matched *)
		ModifyOptions[SamplesInStorageOptions,
			{
				{OptionName->SamplesInStorageCondition,Default->CryogenicStorage}
			}
		],
		FuntopiaSharedOptions
	}
];


(* ::Subsubsection:: *)
(*ExperimentFlashFreeze Errors and Warnings*)

Warning::FlashFreezeNoVolume="In ExperimentFlashFreeze, the following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if the sample can be safely flash frozen.";
Warning::FlashFreezeSampleInStorageWarnings="In ExperimentFlashFreeze, the SamplesInStorageCondition (`1`) is not CryogenicStorage for the following samples, which may result in storage at insufficiently cold temperatures: `2`.";
Warning::FlashFreezeAliquotSampleStorageWarnings="In ExperimentFlashFreeze, the AliquotSampleStorageCondition (`1`) is not CryogenicStorage for the following samples, which may result in storage at insufficiently cold temperatures: `2`.";
Error::MaxFreezeUntilFrozen="In ExperimentFlashFreeze, FreezeUntilFrozen must be True for the option value MaxFreezingTime to be set (`1`), which conflicts for the following samples: `2`.";
Error::MaxFreezingTimeMismatch="In ExperimentFlashFreeze, FreezingTime must be less than or equal to MaxFreezingTime (`1`), which conflicts for the following samples: `2`.";
Error::FlashFreezeSampleVolumeHighError="In ExperimentFlashFreeze, the stored Volume of the samples (`1`) must not be greater than 50 milliliters, which conflicts for the following samples: `2`.";

(* ::Subsubsection:: *)
(*ExperimentFlashFreeze*)

ExperimentFlashFreeze[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOptions,cacheOption,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed,
		samplePreparationCache,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		optionsWithObjects,freezeInstrumentModels,doserInstrumentModels,allInstrumentModels,objectContainerPacketFields,modelContainerPacketFields,allSamplePackets,
		instrumentModelPacket,instrumentObjectPacket,potentialContainerPacket,doserInstrumentPacket,
		objectSamplePacketFields,modelSamplePacketFields,instrumentObjects,
		modelInstrumentObjects,potentialContainers,potentialContainerFields
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption=ToList[Lookup[listedOptions,Cache,{}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentFlashFreeze,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentFlashFreeze,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFlashFreeze,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentFlashFreeze,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentFlashFreeze,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
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
		ApplyTemplateOptions[ExperimentFlashFreeze,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentFlashFreeze,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentFlashFreeze,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects={
		Instrument
	};

	instrumentObjects=Cases[Lookup[expandedSafeOps,optionsWithObjects],ObjectP[Object[Instrument,Dewar]]];
	modelInstrumentObjects=Cases[Lookup[expandedSafeOps,optionsWithObjects],ObjectP[Model[Instrument,Dewar]]];
	freezeInstrumentModels=Search[Model[Instrument,Dewar]];
	doserInstrumentModels=Search[Model[Instrument,LiquidNitrogenDoser]];
	allInstrumentModels=DeleteDuplicates@Cases[Join[modelInstrumentObjects,freezeInstrumentModels],ObjectReferenceP[]];

	(*all possible containers, in this case containers with min temperature < -195 Celsius*)
	potentialContainers=Search[Model[Container,Vessel],MinTemperature<-195 Celsius&&MaxVolume<0.05 Liter];

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
		potentialContainerPacket,
		doserInstrumentPacket
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				instrumentObjects,
				allInstrumentModels,
				potentialContainers,
				doserInstrumentModels
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					objectContainerPacketFields,
					modelContainerPacketFields
				},
				{    (*Object[Instrument]*)
					Packet[Object,Name,Status,Model,LiquidNitrogenCapacity],
					Packet[Model[{Object,Name,LiquidNitrogenCapacity}]]
				},
				{    (*Model[Instrument]*)
					Packet[Object,Name,LiquidNitrogenCapacity]
				},
				{ (*Potential Containers*)
					potentialContainerFields
				},
				{    (*liquid nitrogen doser*)
					Packet[FlowRate,FlowRatePrecision,MinVolume]
				}
			},
			Cache->Flatten[{samplePreparationCache,cacheOption}],
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	cacheBall=FlattenCachePackets[{
		samplePreparationCache,allSamplePackets,instrumentModelPacket,instrumentObjectPacket,potentialContainerPacket,doserInstrumentPacket
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentFlashFreezeOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentFlashFreezeOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentFlashFreeze,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentFlashFreeze,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		flashFreezeResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{flashFreezeResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentFlashFreeze,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,FlashFreeze],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentFlashFreeze,collapsedResolvedOptions],
		Preview->Null
	}
];

(* Note: The container overload should come after the sample overload. *)
ExperimentFlashFreeze[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		samplePreparationCache,containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,sampleCache},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers,listedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentFlashFreeze,
			ToList[listedContainers],
			ToList[listedOptions]
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentFlashFreeze,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentFlashFreeze,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Update our cache with our new simulated values. *)
	(* It is important the sample preparation cache appears first in the cache ball. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentFlashFreeze[samples,ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]]
	]
];

(* ::Subsubsection:: *)
(*resolveExperimentFlashFreezeOptions *)

DefineOptions[
	resolveExperimentFlashFreezeOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentFlashFreezeOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentFlashFreezeOptions]]:=Module[
	{
		(*Boilerplate variables*)
		outputSpecification,output,gatherTests,cache,samplePrepOptions,flashFreezeOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
		flashFreezeOptionsAssociation,invalidInputs,invalidOptions,targetContainers,targetVolumes,modifiedAliquotSampleStorageCondition,modifiedResolvedAliquotOptions,aliquotMessage,resolvedAliquotOptions,aliquotTests,

		(* Sample, container, and instrument packets to download*)
		instrumentDownloadFields,listedSampleContainerPackets,samplePackets,sampleContainerPackets,sampleContainerModelPackets,sampleModelPackets,
		simulatedSampleContainerModels,simulatedSampleContainerObjects,instrumentPacket,instrumentModel,

		(* Input validation *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,

		(* for option rounding *)
		roundedExperimentOptions,optionsPrecisionTests,allOptionsRounded,

		(* options that do not need to be rounded *)
		instrument,name,

		(* conflicting options *)
		validNameQ,nameInvalidOption,validNameTest,
		maxFreezeUntilFrozenMismatches,maxFreezeUntilFrozenMismatchInputs,maxFreezeUntilFrozenMismatchOptions,maxFreezeUntilFrozenInvalidOptions,maxFreezeUntilFrozenTest,
		maxFreezingTimeMismatches,maxFreezingTimeMismatchInputs,maxFreezingTimeMismatchOptions,maxFreezingTimeInvalidOptions,maxFreezingTimeTest,
		(* map thread*)
		mapThreadFriendlyOptions,resolvedInstrument,resolvedFreezingTime,resolvedFreezeUntilFrozen,resolvedMaxFreezingTime,resolvedVolume,resolvedPotentialAliquotContainers,volumes,

		(* Errors and Testing *)
		sampleVolumeHighErrors,sampleVolumeHighInvalidOptions,sampleVolumeHighTest,sampleContainerLargeErrors,
		freezingSuitableContainerErrors,suitableContainerSizeErrors,allTests,suitableContainerErrors,

		resolvedOptions,resolvedPostProcessingOptions,resolvedEmail,

		(* misc options *)
		emailOption,uploadOption,nameOption,confirmOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,operator,
		sampleInStorageWarnings,sampleInStorageWarningTests,aliquotSampleOutStorageWarnings,aliquotSampleOutStorageWarningTests


	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Seperate out our FlashFreeze options from our Sample Prep options. *)
	{samplePrepOptions,flashFreezeOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentFlashFreeze,mySamples,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentFlashFreeze,mySamples,samplePrepOptions,Cache->cache,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	flashFreezeOptionsAssociation=Association[flashFreezeOptions];

	(* DOWNLOAD: Extract the packets that we need from our downloaded cache. *)
	(* Get the instrument *)
	instrument=Lookup[flashFreezeOptionsAssociation,Instrument];
	name=Lookup[flashFreezeOptionsAssociation,Name];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

	instrumentDownloadFields=Which[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,LiquidNitrogenCapacity}]],

		(* If instrument is a Model, download fields*)
		MatchQ[instrument,ObjectP[Model[Instrument]]],
		Packet[Object,LiquidNitrogenCapacity],

		True,
		Nothing
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)

	{listedSampleContainerPackets}=Quiet[Download[
		{
			simulatedSamples
		},
		{
			{
				Packet[Model,Status,Container,Volume,Composition,IncompatibleMaterials,State],
				Packet[Model[{IncompatibleMaterials,Composition,Name,Solvent,Density}]],
				Packet[Container[{Model,Contents}]],
				Packet[Container[Model][{MaxVolume,MinTemperature,Name}]]
			}
		},
		Cache->simulatedCache,
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
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
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
		Message[Warning::FlashFreezeNoVolume,ObjectToString[noVolumeInvalidInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Cache->simulatedCache]<>" have volume populated:",True,False]
			];

			passingTest=If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs],Cache->simulatedCache]<>" have volume populated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

		(*-- OPTION PRECISION CHECKS --*)
	{roundedExperimentOptions,optionsPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[flashFreezeOptionsAssociation,FreezingTime,1 Second,AvoidZero->True,Output->{Result,Tests}],
		{RoundOptionPrecision[flashFreezeOptionsAssociation,FreezingTime,1 Second],Null}
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
		Not[DatabaseMemberQ[Object[Protocol,FlashFreeze,name]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"FlashFreeze protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a FlashFreeze protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* 1. FreezeUntilFrozen and MaxFreezingTime are copacetic *)
	maxFreezeUntilFrozenMismatches=MapThread[
		Function[{freezeUntilFrozen,maxFreezingTime,sampleObject},
			(* MaxFreezingTime can only be set when FreezeUntilFrozen is set to True or Automatic. *)
			If[MatchQ[maxFreezingTime,Except[Null|Automatic]]&&!MatchQ[freezeUntilFrozen,True|Automatic],
				{{freezeUntilFrozen,maxFreezingTime},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,FreezeUntilFrozen],Lookup[allOptionsRounded,MaxFreezingTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{maxFreezeUntilFrozenMismatchOptions,maxFreezeUntilFrozenMismatchInputs}=If[MatchQ[maxFreezeUntilFrozenMismatches,{}],
		{{},{}},
		Transpose[maxFreezeUntilFrozenMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxFreezeUntilFrozenInvalidOptions=If[Length[maxFreezeUntilFrozenMismatchOptions]>0&&!gatherTests,
		Message[Error::MaxFreezeUntilFrozen,maxFreezeUntilFrozenMismatchOptions,maxFreezeUntilFrozenMismatchInputs];
		{FreezeUntilFrozen,MaxFreezingTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxFreezeUntilFrozenTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,maxFreezeUntilFrozenMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option MaxFreezingTime can only be set when FreezeUntilFrozen is True or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxFreezeUntilFrozenMismatchInputs]>0,
				Test["The option MaxFreezingTime can only be set when FreezeUntilFrozen is True or Automatic for the input(s) "<>ObjectToString[maxFreezeUntilFrozenMismatchInputs,Cache->simulatedCache]<>" if supplied by the user:",True,False],
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

	(* 2. FreezingTime is less than or equal to MaxFreezingTime *)
	maxFreezingTimeMismatches=MapThread[
		Function[{freezingTime,maxFreezingTime,sampleObject},
			(* MaxFreezingTime can only be set when FreezeUntilFrozen is set to True or Automatic. *)
			If[MatchQ[maxFreezingTime,Except[Null|Automatic]]&&MatchQ[freezingTime,Except[Null|Automatic]],
				If[freezingTime>maxFreezingTime,
					{{freezingTime,maxFreezingTime},sampleObject},
					Nothing
				],
				Nothing
			]
		],
		{Lookup[allOptionsRounded,FreezingTime],Lookup[allOptionsRounded,MaxFreezingTime],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{maxFreezingTimeMismatchOptions,maxFreezingTimeMismatchInputs}=If[MatchQ[maxFreezingTimeMismatches,{}],
		{{},{}},
		Transpose[maxFreezingTimeMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxFreezingTimeInvalidOptions=If[Length[maxFreezingTimeMismatchOptions]>0&&!gatherTests,
		Message[Error::MaxFreezingTimeMismatch,maxFreezingTimeMismatchOptions,maxFreezingTimeMismatchInputs];
		{FreezingTime,MaxFreezingTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxFreezingTimeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,maxFreezingTimeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The FreezingTime must be less than or equal to the option MaxFreezingTime for the input(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxFreezingTimeMismatchInputs]>0,
				Test["The option FreezingTime must be less than or equal to the option MaxFreezingTime for the input(s) "<>ObjectToString[maxFreezingTimeMismatchInputs,Cache->simulatedCache]<>" if supplied by the user:",True,False],
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
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentFlashFreeze,allOptionsRounded];

	(* MapThread over each of our samples. *)
	{
		resolvedFreezingTime,
		resolvedFreezeUntilFrozen,
		resolvedMaxFreezingTime,

		(* Resolved Error Bools *)
		freezingSuitableContainerErrors,
		suitableContainerSizeErrors,
		sampleVolumeHighErrors,
		sampleContainerLargeErrors,

		(* sample volumes*)
		volumes
	}=Transpose[MapThread[Function[{myMapThreadFriendlyOptions,mySample,mySampleContainerModel,mySampleContainerPackets},
		Module[{
			freezingTime,
			freezeUntilFrozen,
			maxFreezingTime,

			(*other variables*)
			sampleVolume,
			mySampVol,

			(* supplied option values *)
			supFreezingTime,
			supFreezeUntilFrozen,
			supMaxFreezingTime,

			(* Error checking booleans *)
			freezingSuitableContainerError,
			suitableContainerSizeError,
			sampleVolumeHighError,
			sampleContainerLargeError
		},

			(* Setup our error tracking variables *)
			{
				freezingSuitableContainerError,
				sampleVolumeHighError,
				suitableContainerSizeError,
				sampleContainerLargeError
			}=ConstantArray[False,4];

			(* Store our options in their variables*)
			{
				supFreezingTime,
				supFreezeUntilFrozen,
				supMaxFreezingTime
			}=Lookup[
				myMapThreadFriendlyOptions,
				{
					FreezingTime,
					FreezeUntilFrozen,
					MaxFreezingTime
				}
			];

			(* Get the  volume of the sample. If the volume is missing, default to 0. We will have thrown an error above *)
			sampleVolume=Lookup[mySample,Volume];
			mySampVol=Max[Replace[sampleVolume,Null->0*Milli*Liter]];

			(* Independent options resolution *)

			(* Is the sample volume suitable for flash freezing? We are limiting to <50mL *)
			sampleVolumeHighError=If[mySampVol>50 Milliliter,
				True,
				False
			];

			(* Is the sample in a container that can withstand liquid nitrogen freezing (temperature -195C)*)
			freezingSuitableContainerError=If[MatchQ[Lookup[mySampleContainerPackets,MinTemperature],LessP[-195.*Celsius]],
				False,
				True
			];

			(* Is the sample container at maximum only 90% full*)
			suitableContainerSizeError=If[MatchQ[mySampVol,LessP[Lookup[mySampleContainerPackets,MaxVolume]*9/10]],
				False,
				True
			];

			(* Is the sample container max volume 50 Milliliter or less *)
			sampleContainerLargeError=If[Lookup[mySampleContainerPackets,MaxVolume]<= 50 Milliliter,
				False,
				True
			];

			(*Is FreezeUntilFrozen specified. Default is False. This line is to keep the naming convention*)
			freezeUntilFrozen=supFreezeUntilFrozen;

			(*Is MaxFreezingTime specified*)
			maxFreezingTime=If[MatchQ[freezeUntilFrozen,False],
				Null,
				If[MatchQ[supMaxFreezingTime,Except[Automatic]],
					supMaxFreezingTime,
					$MaxExperimentTime
				]
			];

			(*Is the FreezingTime specified by the user*)
			freezingTime=Which[
				MatchQ[supFreezingTime,Except[Automatic]],
				supFreezingTime,
				mySampVol<500.*Microliter,
				30 Second,
				mySampVol<1*Milliliter,
				1 Minute,
				True,
				2 Minute
			];

			(* Gather MapThread results *)
			{
				freezingTime,
				freezeUntilFrozen,
				maxFreezingTime,
				freezingSuitableContainerError,
				suitableContainerSizeError,
				sampleVolumeHighError,
				sampleContainerLargeError,
				mySampVol
			}
		]
	],
		{mapThreadFriendlyOptions,samplePackets,simulatedSampleContainerModels,sampleContainerModelPackets}
	]];

	(* Is the Instrument specified by the user *)
	resolvedInstrument=If[MatchQ[Lookup[allOptionsRounded,Instrument],Automatic],
		Model[Instrument,Dewar,"Low Form Foam Dewar Flask"],
		Lookup[allOptionsRounded,Instrument]
	];

	(* Pull out Miscellaneous options *)
	{emailOption,uploadOption,nameOption,confirmOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,operator}=
		Lookup[allOptionsRounded,
			{Email,Upload,Name,Confirm,ParentProtocol,FastTrack,Template,SamplesInStorageCondition,Operator}];

	(* check if the provided samples out storage condition is cryogenic storage*)
	(* Note that plate samples will be aliquoted so there is no need to check for conflicts as in ValidContainerStorageConditionQ *)
	sampleInStorageWarnings=Map[If[MatchQ[#,CryogenicStorage],False,True]&,samplesInStorageOption];

	(* Throw a warning if the sample storage condition is not cryogenic storage *)
	If[MemberQ[sampleInStorageWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::FlashFreezeSampleInStorageWarnings,ObjectToString[PickList[samplesInStorageOption,sampleInStorageWarnings],Cache->simulatedCache],ObjectToString[PickList[simulatedSamples,sampleInStorageWarnings],Cache->simulatedCache]]
	];

	(* generate the tests *)
	sampleInStorageWarningTests=If[gatherTests,
		Module[{failingSamplesInWarning,passingSamplesInWarning,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamplesInWarning=PickList[simulatedSamples,sampleInStorageWarnings];

			(* get the inputs that pass this test *)
			passingSamplesInWarning=PickList[simulatedSamples,sampleInStorageWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[MemberQ[sampleInStorageWarnings,True],
				Test["The SamplesInStorageCondition for "<>ObjectToString[failingSamplesInWarning,Cache->simulatedCache]<>" is not cryogenic storage and will result in storage of the sample at non-cryogenic temperatures:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[MemberQ[sampleInStorageWarnings,False],
				Test["The SamplesInStorageCondition for "<>ObjectToString[passingSamplesInWarning,Cache->simulatedCache]<>" is not cryogenic storage and will result in storage of the sample at non-cryogenic temperatures:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*Generate the error messages and warnings from the errors and warnings*)
	(* (1) Check for sample volume high errors *)
	sampleVolumeHighInvalidOptions=If[MemberQ[sampleVolumeHighErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{sampleVolumeHighInvalidSamples,myResolvedSampleVolumes},
			(* Get the samples that correspond to this error. *)
			sampleVolumeHighInvalidSamples=PickList[simulatedSamples,sampleVolumeHighErrors];

			(* Get the volumes of these samples. *)
			myResolvedSampleVolumes=PickList[volumes,sampleVolumeHighErrors];

			(* Throw the corresopnding error. *)
			Message[Error::FlashFreezeSampleVolumeHighError,ObjectToString[myResolvedSampleVolumes],ObjectToString[sampleVolumeHighInvalidSamples,Cache->cache]];

			{SamplesIn}
		],
		{}
	];

	(* Create the corresponding test for the sample volume error. *)
	sampleVolumeHighTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,sampleVolumeHighErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,sampleVolumeHighErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The stored Volume of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are less than 50 milliliter if they are to be flash frozen:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The stored Volume of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are less than 50 milliliter if they are to be flash frozen:",True,True],
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

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{nameInvalidOption,maxFreezeUntilFrozenInvalidOptions,maxFreezingTimeInvalidOptions,sampleVolumeHighInvalidOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	allTests=Flatten[{discardedTest,noVolumeTest,optionsPrecisionTests,validNameTest,maxFreezeUntilFrozenTest,sampleVolumeHighTest}];

	suitableContainerErrors=MapThread[
		Or[
			#1,
			#2,
			#3,
			(* ExperimentFlashFreeze does not allow Plate because there is no batching system yet. Require aliquoting when the sample is in a plate *)
			MatchQ[Lookup[#4,Type],Object[Container,Plate]]
		]&,
		{freezingSuitableContainerErrors,suitableContainerSizeErrors,sampleContainerLargeErrors,sampleContainerPackets}
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	{targetContainers,targetVolumes}=Transpose@MapThread[Function[{container,containerErrors,myVolumes},
		If[
			MatchQ[containerErrors,False],
			{Null,Null},
			{PreferredContainer[myVolumes*10/9,MinTemperature->-195*Celsius],myVolumes} (*Note: we are upping the volume for preferredContainer to make sure the volume is at most 90% of the max container*)
		]
	],{simulatedSampleContainerModels,suitableContainerErrors,volumes}];

	aliquotMessage="because the given sample is not in a vessel container that is compatible with the MinTemperature of the instrument, is not large enough for the sample to be frozen in, or is too large to be safely immersed in liquid nitrogen.";

	(* Resolve Aliquot Options *)

	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentFlashFreeze,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache->simulatedCache,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->targetVolumes,AliquotWarningMessage->aliquotMessage,Output->{Result,Tests}],
		{resolveAliquotOptions[ExperimentFlashFreeze,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache->simulatedCache,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->targetVolumes,AliquotWarningMessage->aliquotMessage,Output->Result],{}}
	];

	(* Modify AliquotSampleStorageCondition to CryogenicStorage if Aliquot is required and AliquotSampleStorageCondition was automatic *)
	(* This resolved option was NOT passed into resolveAliquotOptions because by specifying an aliquot option, we would no longer get Warning::AliquotRequired. We will only replace this option AFTER resolveAliquotOptions *)
	modifiedAliquotSampleStorageCondition=MapThread[
		If[MatchQ[#1,Automatic]&&MatchQ[#3,True],
			(* If AliquotSampleStorageCondition was Automatic, checked the resolved default Null to CryogenicStorage *)
			#2/.{Null->CryogenicStorage},
			(* Otherwise keep the resolved value *)
			#2
		]&,
		{
			(* Check unresolved AliquotSampleStorageCondition *)
			Lookup[myOptions,AliquotSampleStorageCondition],
			(* Check resolved AliquotSampleStorageCondition *)
			Lookup[resolvedAliquotOptions,AliquotSampleStorageCondition],
			(* Check resolved Aliquot *)
			Lookup[resolvedAliquotOptions,Aliquot]
		}
	];
	modifiedResolvedAliquotOptions=ReplaceRule[resolvedAliquotOptions,{AliquotSampleStorageCondition->modifiedAliquotSampleStorageCondition}];
	(* check if the aliquot samples out storage condition is cryogenic storage*)

	aliquotSampleOutStorageWarnings=MapThread[
		(*only do the check if Aliquot is True*)
		If[MatchQ[#2,True],
			(* if aliquot samples out storage condition is not cryogenic storage, throw a warning*)
			If[MatchQ[#1,CryogenicStorage],
				(* storage condition is cryogenic storage and no warning is needed*)
				False,
				(* storage condition is not cryogenic storage and a warning is needed*)
				True
			],
			(* if aliquot is not true, no need to throw an error*)
			False
		]&,
		{Lookup[modifiedResolvedAliquotOptions,AliquotSampleStorageCondition],Lookup[modifiedResolvedAliquotOptions,Aliquot]}
	];

	(* Throw a warning if the sample storage condition is not cryogenic storage *)
	If[MemberQ[aliquotSampleOutStorageWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::FlashFreezeAliquotSampleStorageWarnings,ObjectToString[PickList[Lookup[modifiedResolvedAliquotOptions,AliquotSampleStorageCondition],aliquotSampleOutStorageWarnings],Cache->simulatedCache],ObjectToString[PickList[simulatedSamples,aliquotSampleOutStorageWarnings],Cache->simulatedCache]]
	];

	(* generate the tests *)
	aliquotSampleOutStorageWarningTests=If[gatherTests,
		Module[{failingSamplesInWarning,passingSamplesInWarning,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamplesInWarning=PickList[simulatedSamples,aliquotSampleOutStorageWarnings];

			(* get the inputs that pass this test *)
			passingSamplesInWarning=PickList[simulatedSamples,aliquotSampleOutStorageWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[MemberQ[aliquotSampleOutStorageWarnings,True],
				Test["The AliquotSampleStorageCondition for "<>ObjectToString[failingSamplesInWarning,Cache->simulatedCache]<>" is not cryogenic storage and will result in storage of the sample aliquot at non-cryogenic temperatures:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[MemberQ[aliquotSampleOutStorageWarnings,False],
				Test["The AliquotSampleStorageCondition for "<>ObjectToString[passingSamplesInWarning,Cache->simulatedCache]<>" is not cryogenic storage and will result in storage of the sample aliquot at non-cryogenic temperatures:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Resolve Email option *)
	resolvedEmail=If[!MatchQ[emailOption,Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];


	(* Resolve Post Processing Options *)
	(*resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];*)
	(*We are overriding the standard post processing options. We are not doing any of this because we don't want the sample to thaw*)
	resolvedPostProcessingOptions={ImageSample->False,MeasureVolume->False,MeasureWeight->False};

	(* all resolved options *)
	resolvedOptions=ReplaceRule[Normal[allOptionsRounded],
		Join[
			modifiedResolvedAliquotOptions,
			resolvedPostProcessingOptions,
			resolvedSamplePrepOptions,
			{
				Instrument->resolvedInstrument,
				FreezingTime->resolvedFreezingTime,
				FreezeUntilFrozen->resolvedFreezeUntilFrozen,
				MaxFreezingTime->resolvedMaxFreezingTime,
				Confirm->confirmOption,
				Name->name,
				Email->resolvedEmail,
				ParentProtocol->parentProtocolOption,
				Upload->uploadOption,
				FastTrack->fastTrackOption,
				Operator->operator,
				SamplesInStorageCondition->samplesInStorageOption,
				Template->templateOption,
				Cache->cache
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
(*flashFreezeResourcePackets*)


DefineOptions[
	flashFreezeResourcePackets,
	Options:>{OutputOption,CacheOption}
];


flashFreezeResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		doserInstrumentModel,samplePackets,doserPackets,instrumentPackets,sampleVolumes,pairedSamplesInAndVolumes,sampleVolumeRules,
		sampleResourceReplaceRules,samplesInResources,instrument,instrumentTime,doserResource,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,previewRule,optionsRule,shortOptions,flashFreezeParameters,flashFreezeLengths,
		funnelResource,fillRodResource,estimatedFreezingTime,cryoGloveResource,cryotransporterPlacements,
		sampleDownloads,doserDownloads,instrumentDownloads,containersInResources,aliquotQs,aliquotVols,

		numberOfSamples,instrumentSetupTearDown,totalMeasurementTimes,processingTime,fumeHood,tweezerResource,dewarVolume,doserFlowRate,doseTime,cryotransporterResource
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentFlashFreeze,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentFlashFreeze,
		RemoveHiddenOptions[ExperimentFlashFreeze,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[myResolvedOptions,Cache];

	(* Get the instrument*)
	instrument=Lookup[myResolvedOptions,Instrument];

	(* Set the doser model *)
	doserInstrumentModel=Model[Instrument,LiquidNitrogenDoser,"UltraDoser"];

	(* --- Make our one big Download call --- *)
	{
		sampleDownloads,
		doserDownloads,
		instrumentDownloads
	}=Quiet[Download[
		{
			mySamples,
			{doserInstrumentModel},
			{instrument}
		},
		{
			{
				Packet[Container,Volume,Object]
			},
			{
				Packet[FlowRate,MinVolume]
			},
			{
				Packet[LiquidNitrogenCapacity]
			}
		},
		Cache->inheritedCache
	],
		Download::FieldDoesntExist
	];

	samplePackets=Flatten[sampleDownloads];
	doserPackets=Flatten[doserDownloads];
	instrumentPackets=Flatten[instrumentDownloads];

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* make a variable that is the number of input samples *)
	numberOfSamples=Length[mySamples];

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotQs=Lookup[myResolvedOptions,Aliquot,Null];

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotVols=Lookup[myResolvedOptions,AliquotAmount,Null];

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

	(*- Set up flash freeze parameters and lengths, to use with looping -*)
	(*make an association with only the options specific for flash freeze*)
	shortOptions=KeyTake[resolvedOptionsNoHidden,{FreezingTime,FreezeUntilFrozen,MaxFreezingTime}];

	(*transpose into a list of associations, with each one containing all the options for that index*)
	flashFreezeParameters=AssociationThread[{FreezingTime,FreezeUntilFrozen,MaxFreezingTime},#]&/@Transpose[Values[shortOptions]];

	(*store flash freeze length for looping*)
	flashFreezeLengths=ConstantArray[1,Length@flashFreezeParameters];

	(* -- Generate instrument resources -- *)

	(*- Figure out liquid nitrogen dose time -*)
	dewarVolume=Lookup[instrumentPackets,LiquidNitrogenCapacity];
	doserFlowRate=Lookup[doserPackets,FlowRate];

	(*Calculate the dose time based on the liquid nitrogen capacity of the dewar and the flow rate of the doser*)
	(*We are multiplying the dewar volume by 0.66 to fill up approx 2/3 of the liquid nitrogen capacity*)
	(*Note that we add 1 second for the delay time of the PDU before the liquid nitrogen doser can dispense liquid nitrogen*)
	doseTime=RoundOptionPrecision[dewarVolume*0.66/doserFlowRate+1 Second,1 Second];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	(*instrumentTime*)
	(*  30 Minutes for setting up the instrument, including loading the buffers and the viscometerchip; 10 minutes for cleanup*)
	instrumentSetupTearDown=(30 Minute+10 Minute);

	(*Determine measurement times*)
	totalMeasurementTimes=Plus@@Lookup[myResolvedOptions,FreezingTime];

	(* Estimate the time needed to run an experiment on the viscometer *)
	instrumentTime=Plus[

		(* Time spent actually measuring the sample is equal to the sum of the freezingtime *)
		totalMeasurementTimes,

		(* transferring sample into and out of the dewar is approximately 5 minutes *)
		5 Minute*numberOfSamples,

		instrumentSetupTearDown
	];

	(*get the processing time estimate, which is the instrumentTime - instrumentSetupTearDown*)
	processingTime=instrumentTime-instrumentSetupTearDown;

	(* make other needed resources*)

	(* Fumehood resource *)
	fumeHood=Link[Object[Instrument,FumeHood,"E6 Hood 1"]];

	(* instrument resource *)
	instrumentResource=Resource[Instrument->instrument,Time->instrumentTime];

	(* CryoPod resource *)
	cryotransporterResource=Resource[Instrument->Model[Instrument,CryogenicFreezer,"Brooks CryoPod Portable Cryogenic Freezer"],Time->instrumentTime];

	(* Liquid nitrogen doser resource *)
	doserResource=Resource[Instrument->doserInstrumentModel,Time->Sequence@@doseTime+10*Minute];

	(* Funnel resource *)
	funnelResource=Resource[Sample->Model[Part,Funnel,"CryoPod Funnel"],Name->ToString[Unique[]]];

	(* Fill rod resource *)
	fillRodResource=Resource[Sample->Model[Part,FillRod,"CryoPod Fill Rod"],Name->ToString[Unique[]]];

	(* Tweezer resource *)
	tweezerResource=Resource[Sample->Model[Item,Tweezer,"Straight flat tip tweezer"],Name->ToString[Unique[]],Rent->True];

	(* cryo glove resource *)
	cryoGloveResource=Resource[Sample->Model[Item,Glove,"Cryo Glove, Medium"],Name->ToString[Unique[]],Rent->True];

	(*estimate the total freezing time, for the danger zone estimate*)
	estimatedFreezingTime=Total[Join[Lookup[expandedResolvedOptions,FreezingTime],{Length[Lookup[expandedResolvedOptions,FreezingTime]]*2 Minute}]];

	(* generate the cryotransporter placements *)
	cryotransporterPlacements={{Link[fillRodResource],{"FillRod Slot"}},{Link[funnelResource],{"Funnel Slot"}}};

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		(*Organizational information/options handling*)
		Type->Object[Protocol,FlashFreeze],
		Object->CreateID[Object[Protocol,FlashFreeze]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->containersInResources,
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		Replace[FlashFreezeParameters]->flashFreezeParameters,
		Replace[FlashFreezeLengths]->flashFreezeLengths,

		(*General instrument set up*)
		Instrument->instrumentResource,
		Replace[LiquidNitrogenDoser]->doserResource,
		Replace[LiquidNitrogenDoseTime]->Sequence@@doseTime,
		FumeHood->fumeHood,
		Replace[CryoTransporter]->cryotransporterResource,
		Replace[Funnel]->funnelResource,
		Replace[FillRod]->fillRodResource,
		Tweezer->Link[tweezerResource],
		CryoGlove->cryoGloveResource,
		Replace[CryoTransporterPlacements]->cryotransporterPlacements,

		(*Method information*)
		Replace[FreezingTime]->Lookup[expandedResolvedOptions,FreezingTime],
		Replace[FreezeUntilFrozen]->Lookup[expandedResolvedOptions,FreezeUntilFrozen],
		Replace[MaxFreezingTime]->Lookup[expandedResolvedOptions,MaxFreezingTime],
		Replace[EstimatedFreezingTime]->estimatedFreezingTime,

		(*Post experiment*)
		Replace[SamplesInStorage]->Lookup[myResolvedOptions,SamplesInStorageCondition],
		(*Cleaning*)

		(*Resources*)
		Replace[Checkpoints]->{
			{"Picking Resources",5 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->5 Minute]]},
			{"Preparing Samples",30 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->30 Minute]]},
			{"Preparing Instrumentation",15 Minute,"The instrument is configured for the protocol.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15 Minute]]},
			{"Flash freezing",instrumentTime,"Samples are placed into the instrument and then undergone flash freezing.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->instrumentTime]]},
			{"Returning Materials",20 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->20*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
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
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(*Upload Helpers*)


uploadFlashFreezeFullyFrozen[object_]:=Upload[<|Object->object,Append[FullyFrozen]->True|>];

uploadFlashFreezeNotFullyFrozen[object_]:=Upload[<|Object->object,Append[FullyFrozen]->False|>];