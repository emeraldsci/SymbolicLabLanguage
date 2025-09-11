(* ::Package:: *)

(* ::Title:: *)
(*Experiment MeasureDissolvedOxygen: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentMeasureDissolvedOxygen*)


(* ::Subsection::Closed:: *)
(*Options*)
 

DefineOptions[
	ExperimentMeasureDissolvedOxygen,
	Options :> {
		{
			OptionName->Instrument,
			Default->Model[Instrument, DissolvedOxygenMeter, "id:01G6nvw1qEPd"],
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Object[Instrument, DissolvedOxygenMeter],
					Model[Instrument, DissolvedOxygenMeter]
				}]
			],
			Description->"The dissolved oxygen meter to be used for measurement.",
			Category->"General"
		},
		{
			OptionName->DissolvedOxygenCalibrationType,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>OnePoint|TwoPoint
			],
			Description->"The type of calibration to performed on the dissolved oxygen meter prior to experiment. If OnePoint is selected a 100% oxygen saturated sample will be used.  If TwoPoint is selected a 100% oxygen saturated sample will be used followed by a 0% oxygen saturated sample.",
			ResolutionDescription->"Automatically set to TwoPoint if a ZeroOxygenCalibrant is provided and OnePoint otherwise.",
			Category->"Calibration"
		},
		{
			OptionName->OxygenSaturatedCalibrant,
			Default->Air,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Air]
				],
				Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
				]
			],
			Description->"The buffer with 100% oxygen saturation that should be used to calibrate the dissolved oxygen meter. If Air is selected, The probe will be calibrated in air above a milli-Q water sample.",
			Category->"Calibration"
		},
		{
			OptionName->ZeroOxygenCalibrant,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description->"The buffer with 0% oxygen saturation that should be used to calibrate the dissolved oxygen meter.",
			ResolutionDescription->"Automatically set to Model[Sample,\"Zero Oxygen Solution\"] for two point calibrations and Null otherwise.",
			Category->"Calibration"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->NumberOfReadings,
				Default->3,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern:>RangeP[1,10,1]],
				Description -> "The number of times the dissolved oxygen of each aliquot or sample will be read by taking another recording.",
				Category -> "General"
			},
			{
				OptionName->Stir,
				Default->False,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description -> "Indicates if the stir paddle attached to the meter should be turned on for the measurement.",
				Category -> "General"
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description -> "The number of times to repeat the experiment on each provided 'item'. If specified, the recorded replicate measurements will be averaged for determining the final dissolved oxygen of the sample(s). Note that specifying NumberOfReplicates is identical to providing duplicated input.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2,1]],
			Category->"General"
		},
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 35 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOption,
		SimulationOption
	}
];


(* ::Subsection:: *)
(*Main Function*)


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


(*ExperimentMeasureDissolvedOxygen - Error Messages *)

Error::MustSpecifyZeroOxygenCalibrant="The DissolvedOxygenCalibrationType is `1` and the ZeroOxygenCalibrant is `2`. Please specify the ZeroOxygenCalibrant or use a DissolvedOxygenCalibrationType of OnePoint.";
Error::ConfictingZeroOxygenCalibrant="The DissolvedOxygenCalibrationType is `1` and will not require a ZeroOxygenCalibrant, `2`. If you would like the meter calibrated with this sample select a TwoPoint DissolvedOxygenCalibrationType.";


(*container overload function*)
ExperimentMeasureDissolvedOxygen[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,containerToSampleSimulation,samples,sampleOptions,containerToSampleTests},
	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureDissolvedOxygen,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 35 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentMeasureDissolvedOxygen,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentMeasureDissolvedOxygen,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Simulation},
				Simulation->updatedSimulation
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
		ExperimentMeasureDissolvedOxygen[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];



(* ::Subsubsection::Closed:: *)
(*Sample Overload*)


(*main function*)
ExperimentMeasureDissolvedOxygen[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,specifiedInstrumentModels,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,objectSamplePacketFields,
		(*Everything needed for downloading*)
		mySamplesList,instrumentLookup,specifiedInstrumentObjects,potentialContainers,aliquotContainerLookup,
		potentialContainersWAliquot,referenceBuffers, listedSamples,modelSamplePacketFields, allObjects, objectContainerFields, modelContainerFields,
		optionsWithObjects, userSpecifiedObjects, containerObjects, modelContainerObjects, modelSampleObjects, sampleObjects,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureDissolvedOxygen,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureDissolvedOxygen,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureDissolvedOxygen,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureDissolvedOxygen,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureDissolvedOxygen,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureDissolvedOxygen,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureDissolvedOxygen,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasureDissolvedOxygen,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*listify the samples as needed*)
	mySamplesList=mySamplesWithPreparedSamples;

	(*check if the user supplied a instrument that's not in our list (e.g. a developer object)*)
	instrumentLookup=Lookup[myOptionsWithPreparedSamples,Instrument];

	(* Get any objects that were specified in the instrument list. *)
	specifiedInstrumentObjects=Cases[ToList[instrumentLookup],ObjectP[Object[Instrument,DissolvedOxygenMeter]]];
	specifiedInstrumentModels=Cases[ToList[instrumentLookup],ObjectP[Model[Instrument,DissolvedOxygenMeter]]];

	(* Get all the potential preferred containers*)
	potentialContainers=preferredDissolvedOxygenContainer[All];

	(*obtain other needed look ups*)
	aliquotContainerLookup=Lookup[listedOptions,AliquotContainer];

	(*if it's a compatible type, then add to the download*)
	potentialContainersWAliquot=If[MatchQ[aliquotContainerLookup,ObjectP[{Model[Container,Vessel]}]],Union[potentialContainers,{aliquotContainerLookup}],potentialContainers];

	(* Any options whose values could be an object *)
	optionsWithObjects = {
		OxygenSaturatedCalibrant,
		ZeroOxygenCalibrant
	};

	(* - Throw an error if any of the specified input objects or objects in Options are not members of the database - *)

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[mySamples],Lookup[ToList[myOptions],optionsWithObjects,Null]],
		ObjectP[]
	];

	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				potentialContainersWAliquot,
				(* Default objects *)
				{
					(* potential calibrant *)
					Model[Sample,"Zero Oxygen Solution"]
				},
				(* All options that could have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		],
		Object,
		Date->Now
	];

	(* Lookup our reference buffers. *)
	referenceBuffers=Lookup[safeOps,{OxygenSaturatedCalibrant,ZeroOxygenCalibrant}]/.{Null->Nothing};

	objectSamplePacketFields=Packet@@Union[Flatten[{Conductivity,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}]];
	modelSamplePacketFields=Packet[Model[Flatten[{Conductivity,IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=Join[SamplePreparationCacheFields[Object[Container]], {VacuumCentrifugeCompatibility}];
	modelContainerFields=Join[SamplePreparationCacheFields[Model[Container]], {VacuumCentrifugeCompatibility,Name,VolumeCalibrations,MaxVolume,Aperture,Dimensions,Sterile,Deprecated,Footprint}];

	(*separate the objects to download specific fields*)
	containerObjects= Cases[allObjects,ObjectP[Object[Container]]];
	modelContainerObjects= Cases[allObjects,ObjectP[Model[Container]]];
	modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
	sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];


	(* Download our information. *)
	cacheBall=FlattenCachePackets[{
		Lookup[safeOps,Cache,{}],
		Quiet[Download[
			{
				mySamplesList,
				specifiedInstrumentModels,
				specifiedInstrumentObjects,
				potentialContainersWAliquot,
				Cases[referenceBuffers,ObjectP[Object[Sample]]],
				Cases[referenceBuffers,ObjectP[Model[Sample]]]
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[Model[modelContainerFields]]],
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					Packet[Name,Object,Objects,WettedMaterials,Dimensions],
					Packet[AssociatedAccessories[[All, 1]][{Object,WettedMaterials}]]
				},
				{
					Packet[Name,Model]
				},
				{
					modelSamplePacketFields,
					Packet[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					objectSamplePacketFields
				},
				{
					modelSamplePacketFields
				}
			},
			Cache -> Lookup[safeOps, Cache, {}],
			Simulation -> updatedSimulation,
			Date -> Now
			(*some containers don't have a link to VolumeCalibrations. Need to silence those.*)
		],
		{Download::FieldDoesntExist, Download::NotLinkField}]
	}];


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureDissolvedOxygenOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureDissolvedOxygenOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

		(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureDissolvedOxygen,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureDissolvedOxygen,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		measureDissolvedOxygenResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{measureDissolvedOxygenResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureDissolvedOxygen,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
 			StartDate->Lookup[safeOps,StartDate],
 			HoldOrder->Lookup[safeOps,HoldOrder],
 			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,MeasureDissolvedOxygen],
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentMeasureDissolvedOxygen,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(*Resolver*)


DefineOptions[
	resolveExperimentMeasureDissolvedOxygenOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentMeasureDissolvedOxygenOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureDissolvedOxygenOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,cache,simulation,samplePrepOptions,measureDissolvedOxygenOptions,simulatedSamples,
		consolidateAliquots,resolvedSamplePrepOptions,updatedSimulation,measureDissolvedOxygenOptionsAssociation,invalidInputs,
		invalidOptions,acquisitionTimeLookup,objectSamplePacketFields,

		(*download variables*)
		cacheFailedRemoved,specifiedInstrumentObjects,potentialContainers,potentialContainersWAliquot,referenceBuffers,
		samplePackets,containerModelPackets,allDownloadValues,allSampleDownloadValues,allInstrumentObjDownloadValues,
		allInstrumentModelDownloadValues,potentialContainerDownloadValues,referenceObjectDownloadValues,referenceModelDownloadValues,
		instrumentObjectPackets,volumeCalibrationPackets,latestVolumeCalibrationPacket,combinedContainerPackets,instrumentModelPackets,
		potentialContainerPackets,potentialContainerModelPackets,firstPotentialCalibration,combinedPotentialContainerPackets,
		fastTrack,samplePreparation,simulatedContainers,

		(*Input validation variables*)
		lowestVolume,lowVolumeBool,lowVolumePackets,lowVolumeInvalidInputs,lowVolumeInputsTests,lowVolumeOptionBool,
		lowVolumeOptionPackets,lowVolumeOptionInvalidInputs,lowVolumeOptionInputsTests,discardedSampleBool,discardedSamplePackets,
		discardedInvalidInputs,discardedTests,instrumentLookup,volumeMeasuredBool,noVolumePackets,noVolumeInputs,noVolumeInputsTests,
		aliquotLookup,aliquotBool,aliquotVolumeLookup, instruments,dissolvedOxygenInstrumentsModels,aliquotOptionNames,
		aliquotTuples,deprecatedInstrumentQ,deprecatedInstrumentOptions,deprecatedInstrumentTest,missingZeroOxygenCalibrantOptions,
		minReach,missingZeroOxygenCalibrantInvalidOptions, missingZeroOxygenCalibrantTests, conflictingZeroOxygenCalibrantionOptions,
		conflictingZeroOxygenCalibrantionTests,smallestAperture, stirWidth, solidSamplePackets,solidInvalidInputs,solidTest,
		referencePackets,solidOptionPackets,solidInvalidOptions,solidOptionTest, conflictingZeroOxygenCalibrantionInvalidOptions,

		(*for the resolving*)
		mapThreadFriendlyOptions,resolvedzeroOxygenCalibrant,aliquotContainerLookup,aliquotVolumeList,potentialAliquotContainersList,
		minDepth,minVol,instrument,oxygenSaturatedCalibrant, numberOfReadings, stir, sampleConductivities,modelConductivityPackets,
		resolveddissolvedOxygenCalibrationType, targetContainers,resolvedAliquotOptions,alreadyInTargetContainerBools,

		(*for final resolution*)
		requiredAliquotAmounts,name,confirm,canaryBranch,template,samplesInStorageCondition,originalCache,operator,parentProtocol,
		upload,outputOption,email,imageSample,resolvedEmail,resolvedImageSample,numberOfReplicates,allTests,testsRule,
		resolvedOptions,resultRule,resolvedPostProcessingOptions,compatibleMaterialsBool, compatibleMaterialsTests,
		compatibleMaterialsInvalidOption,validContainerStorageConditionBool,validContainerStorageConditionTests,
		validContainerStoragConditionInvalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,{}];

	(*There is a chance that the container has no volume calibration. Remove such and check if we can resolve SamplePrepOptions*)
	cacheFailedRemoved = Cases[cache,Except[$Failed]];

	(* Separate out our MeasureDissolvedOxygen options from our Sample Prep options. *)
	{samplePrepOptions,measureDissolvedOxygenOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation}=resolveSamplePrepOptionsNew[ExperimentMeasureDissolvedOxygen,mySamples,samplePrepOptions,Cache->cacheFailedRemoved,Simulation->simulation];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureDissolvedOxygenOptionsAssociation = Association[measureDissolvedOxygenOptions];

	(* Get all non deprecated DissolvedOxygen models including the developer ones, for testing purposes. *)
	dissolvedOxygenInstrumentsModels=Search[Model[Instrument,DissolvedOxygenMeter],Deprecated!=True];

	(*check if the user supplied a instrument that's not in our list (e.g. a developer object)*)
	{instrumentLookup}=Lookup[myOptions,{Instrument}];

	(* Get our NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myOptions,NumberOfReplicates]/.{Null->1};

	(* Get our ConsolidateAliquots option. Replace Automatic with False since this is how it'll be resolved in the aliquot resolver. *)
	consolidateAliquots=Lookup[myOptions,ConsolidateAliquots]/.{Automatic->False};

	(* Get our AcquisitionTime option. *)
	acquisitionTimeLookup=Lookup[myOptions,AcquisitionTime];

	(* Get any objects that were specified in the instrument list. *)
	specifiedInstrumentObjects=Cases[instrumentLookup,ObjectP[Object[Instrument,DissolvedOxygenMeter]]];

	(* Get all the potential preferred containers*)
	potentialContainers=preferredDissolvedOxygenContainer[All];

	(*obtain other needed look ups*)
	aliquotContainerLookup=Lookup[myOptions,AliquotContainer];

	(*if it's a compatible type, then add to the download*)
	potentialContainersWAliquot=If[MatchQ[aliquotContainerLookup,ObjectP[{Model[Container,Vessel]}]],Union[potentialContainers,{aliquotContainerLookup}],potentialContainers];

	(* Lookup our reference buffers. *)
	referenceBuffers=Lookup[myOptions,{OxygenSaturatedCalibrant,ZeroOxygenCalibrant}]/.{Null->Nothing}/.{Air->Nothing};

	objectSamplePacketFields=Packet@@Union[Flatten[{Conductivity,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}]];

	(* Extract the packets that we need from our downloaded cache. *)
	allDownloadValues=Replace[
		Quiet[
			Download[
				{
					simulatedSamples,
					dissolvedOxygenInstrumentsModels,
					specifiedInstrumentObjects,
					potentialContainersWAliquot,
					Cases[referenceBuffers,ObjectP[Object[Sample]]],
					Cases[referenceBuffers,ObjectP[Model[Sample]]]
				},
				{
					{
						objectSamplePacketFields,
						Packet[Container[Model][{Name,VolumeCalibrations,MaxVolume, Aperture, Dimensions}]],
						Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]],
						Packet[Model[{Conductivity}]]
					},
					{
						Packet[Name,Object,Dimensions],
						Packet[AssociatedAccessories[[All, 1]][{Object,WettedMaterials}]]
					},
					{
						Packet[Name,Model]
					},
					{
						Packet[Name, MaxVolume, Aperture, Dimensions],
						Packet[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
					},
					{
						objectSamplePacketFields
					},
					{
						Packet[TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State]
					}
				},
				Cache->cacheFailedRemoved,
				Simulation->updatedSimulation
			]
		],
		$Failed->Nothing,1];
	(*split the download packet based on object type*)
	{
		allSampleDownloadValues,
		allInstrumentModelDownloadValues,
		allInstrumentObjDownloadValues,
		potentialContainerDownloadValues,
		referenceObjectDownloadValues,
		referenceModelDownloadValues
	}=allDownloadValues;

	(*pull out all the sample/sample model/container/container model packets*)
	samplePackets=allSampleDownloadValues[[All,1]];
	containerModelPackets=allSampleDownloadValues[[All,2]];
	volumeCalibrationPackets=allSampleDownloadValues[[All,3]];
	modelConductivityPackets=allSampleDownloadValues[[All,4]];
	referencePackets=referenceObjectDownloadValues[[All,1]];
	simulatedContainers=Lookup[allSampleDownloadValues[[All,1]],Container][Object];

	sampleConductivities=MapThread[
		Which[
			MatchQ[Lookup[#1,Conductivity],Except[Null]],
			Mean[Lookup[#1,Conductivity]],
			MatchQ[Lookup[#2,Conductivity],Except[Null]],
			Mean[Lookup[#2,Conductivity]],
			True,
			Null
		]&,
		{modelConductivityPackets,samplePackets}
	];

	(*only consider the calibration packets with a liquid level monitor*)
	latestVolumeCalibrationPacket=Map[If[Length[#]>0,FirstCase[#,KeyValuePattern[LiquidLevelDetectorModel->Except[Null]]],Null]&,volumeCalibrationPackets];

	(*combine the calibration information into the container model packets.*)
	combinedContainerPackets=MapThread[
		If[
			Not[NullQ[#2]],
			Append[#1,CalibrationFunction->Lookup[#2,CalibrationFunction]],
			If[
				Not[NullQ[#1]],
				Append[#1,CalibrationFunction->Null],
				{<||>}
			]
		]&,
		{containerModelPackets,latestVolumeCalibrationPacket}
	];

	(*pull out the instrument object/model information*)
	instrumentModelPackets=allInstrumentModelDownloadValues[[All,1]];
	instrumentObjectPackets=allInstrumentObjDownloadValues[[All,1]];

	(*if the user specified objects*)

	(*pull out the potential container information*)
	potentialContainerPackets=potentialContainerDownloadValues[[All,1]];
	potentialContainerModelPackets=potentialContainerDownloadValues[[All,2]];

	(*get the latest calibration for the potential containers*)
	firstPotentialCalibration=Map[
		If[Length[#]>0,
			Last[
				Cases[#,KeyValuePattern[LiquidLevelDetectorModel->Except[Null]]]
			],
			Null
		]&,
		potentialContainerModelPackets
	];

	(*combine the calibration information into the packet*)
	combinedPotentialContainerPackets=MapThread[If[Not[NullQ[#2]],
		Append[#1,CalibrationFunction->Lookup[#2,CalibrationFunction]],
		Append[#1,CalibrationFunction->Null]
		]&,
		{potentialContainerPackets,firstPotentialCalibration}];

	(*-- INPUT VALIDATION CHECKS --*)
	lowestVolume = 25 Milliliter;

	(* DISCARDED SAMPLES *)

	(* Get a boolean for which samples are discarded *)
	discardedSampleBool=Map[
		If[NullQ[#],
			False,
			MatchQ[#,KeyValuePattern[Status->Discarded]]
		]&,
		samplePackets
	];

	(* Get the sample packets that are discarded. *)
	discardedSamplePackets=PickList[samplePackets,discardedSampleBool,True];

	(*  keep track of the invalid inputs *)
	discardedInvalidInputs=If[Length[discardedSamplePackets]>0,
		Lookup[Flatten[discardedSamplePackets],Object],
	(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
			(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]<>" is/are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
			(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Simulation -> updatedSimulation]<>" is/are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*--Solid input check--*)

	(*Get the sample packets from samplePackets that are solid*)
	solidSamplePackets=Cases[samplePackets,KeyValuePattern[State->Solid],Infinity];

	(*Set solidInvalidInputs to the input objects whose states are Solid*)
	solidInvalidInputs=If[MatchQ[solidSamplePackets,{}],
		{},
		Lookup[solidSamplePackets,Object]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[solidSamplePackets]>0&&!gatherTests,
		Message[Error::SolidSamplesUnsupported,ObjectToString[solidInvalidInputs,Simulation -> updatedSimulation],ExperimentMeasureDissolvedOxygen]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	solidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[solidInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[solidInvalidInputs,Simulation -> updatedSimulation]<>" are not solid:",True,False]
			];
			passingTest=If[Length[solidInvalidInputs]==Length[Flatten[ToList@simulatedSamples]],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[Flatten[ToList@simulatedSamples],solidInvalidInputs],Simulation -> updatedSimulation]<>" are not solid:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*--Solid option check--*)

	(*Get the sample packets from samplePackets that are solid*)
	solidOptionPackets=Cases[referencePackets,KeyValuePattern[State->Solid],Infinity];

	(*Set solidInvalidInputs to the input objects whose states are Solid*)
	solidInvalidOptions=If[MatchQ[solidOptionPackets,{}],
		{},
		Lookup[solidOptionPackets,Object]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[solidOptionPackets]>0&&!gatherTests,
		Message[Error::SolidSamplesUnsupported,ObjectToString[solidInvalidOptions,Simulation -> updatedSimulation],ExperimentMeasureDissolvedOxygen]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	solidOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[solidInvalidOptions]==0,
				Nothing,
				Test["Our calibrants "<>ObjectToString[solidInvalidOptions,Simulation -> updatedSimulation]<>" are not solid:",True,False]
			];
			passingTest=If[Length[solidInvalidInputs]!=0,
				Nothing,
				Test["Our calibrants "<>ObjectToString[Complement[solidInvalidOptions,solidInvalidInputs],Simulation -> updatedSimulation]<>" are not solid:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* DEPRECATED INSTRUMENT *)

	deprecatedInstrumentQ=If[MemberQ[instrumentLookup,ObjectP[Model[Instrument]]],
		!IntersectingQ[dissolvedOxygenInstrumentsModels,Download[Cases[instrumentLookup,ObjectP[Model[Instrument]]],Object]],
		False
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[deprecatedInstrumentQ&&!gatherTests,
		Message[Error::DeprecatedInstrumentModel,ObjectToString[instrumentLookup,Simulation -> updatedSimulation]]
	];

	deprecatedInstrumentOptions=If[deprecatedInstrumentQ,{Instrument},{}];

	deprecatedInstrumentTest=If[gatherTests,
		Test["If the Instrument is specified, then it is not deprecated:",
			deprecatedInstrumentQ,
			False
		],
		Nothing
	];

	(*3. Check VOLUME is not null.*)

	(*find the packets where Volume==Null*)
	volumeMeasuredBool=Map[NullQ,Lookup[samplePackets,Volume]];

	(*get the packets with no volume and where measure==False*)
	noVolumePackets=PickList[samplePackets,volumeMeasuredBool,True];

	(*get the inputs with no volume*)
	noVolumeInputs=If[Length[noVolumePackets]>0,
		Lookup[Flatten[noVolumePackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInputs]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[noVolumeInputs,Simulation -> updatedSimulation]<>" have an associated volume value:",True,False]
			];
			passingTest=If[Length[noVolumeInputs]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,noVolumeInputs],Simulation -> updatedSimulation]<>" have an associated volume value:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*throw the error if we're not gathering tests*)
	If[Length[noVolumeInputs]>0&&!gatherTests,
		Message[Error::NoVolume,ObjectToString[noVolumeInputs,Simulation -> updatedSimulation]]
	];

	(* 4. LOW VOLUME SAMPLES *)

	(*get the lowest possible volume for measurement*)
	lowestVolume=25*Milliliter;

	(*get a boolean for which samples are low volume*)
	lowVolumeBool=Map[
		If[NullQ[#],False,MatchQ[Lookup[#,Volume],LessP[lowestVolume]]] &,
		samplePackets
	];

	(*get a boolean for which samples are low volume*)
	lowVolumeOptionBool=Map[
		If[NullQ[#],False,MatchQ[Lookup[#,Volume],LessP[lowestVolume]]] &,
		referencePackets
	];

	(*get the packets that are low volume*)
	lowVolumeOptionPackets=PickList[referencePackets,lowVolumeOptionBool,True];

	(*  keep track of the invalid inputs *)
	lowVolumeOptionInvalidInputs=If[Length[lowVolumeOptionPackets]>0,
		Lookup[Flatten[lowVolumeOptionPackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are low volumes and we are throwing messages, throw an error message *)
	If[Length[lowVolumeOptionInvalidInputs]>0&&!gatherTests,
		Message[Error::InsufficientVolume,ObjectToString[lowVolumeOptionInvalidInputs,Simulation -> updatedSimulation],ObjectToString[lowestVolume]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	lowVolumeOptionInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowVolumeOptionInvalidInputs]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The calibrants have sufficient volume for measurement:",True,False]
			];
			passingTest==If[Length[lowVolumeOptionInvalidInputs]!=0,
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The calibrants have sufficient volume for measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*5. LOW ALIQUOT VOLUME SAMPLES*)

	(*get all of the aliquot option names -- AliquotPreparation,ConsolidateAliquots are impertinent *)
	aliquotOptionNames=Complement[Map[ToExpression,Keys@Options[AliquotOptions]],{AliquotPreparation,ConsolidateAliquots}];

	(*get the aliquot options for each sample*)
	aliquotTuples=MapThread[List,Lookup[samplePrepOptions,aliquotOptionNames]];

	(*check get the Aliquot option value*)
	aliquotLookup=Lookup[samplePrepOptions,Aliquot];

	(*If any of the aliquot options were set positively, then this should be true*)
	(*of if recoup sample was set true, then should be set*)
	aliquotBool=MapThread[
		Function[{aliquotOptionsGroup, aliquotQ},
			If[MatchQ[aliquotQ,Automatic],
				MemberQ[aliquotOptionsGroup, Except[False | Null | Automatic]],
				aliquotQ
			]
		],
		{
			aliquotTuples,
			aliquotLookup
		}
	];

	(*Look up the AliquotAmount or take the Assay Volume if that's specified instead*)
	aliquotVolumeLookup = MapThread[
		Function[{assayVolume,aliquotAmount},
			If[MatchQ[assayVolume,GreaterP[0*Milliliter]],
			assayVolume,
			aliquotAmount
			]
		],
		Lookup[samplePrepOptions, {AssayVolume, AliquotAmount}]
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* pull out the options that are defaulted *)
	{
		instrument,
		oxygenSaturatedCalibrant,
		numberOfReadings,
		stir,
		fastTrack
	} =
		Lookup[measureDissolvedOxygenOptionsAssociation,
			{
				Instrument,
				OxygenSaturatedCalibrant,
				NumberOfReadings,
				Stir,
				FastTrack
			}
		];

	(*Error:MustSpecifyZeroOxygenCalibrant *)
	missingZeroOxygenCalibrantOptions =If[
		(*Is DissolvedOxygenCalibrationType two point and the ZeroOxygenCalibrant is Null?*)
		MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],TwoPoint]&&MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant],Null],
		(*return the type and calibrant*)
		{Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant]},
		Nothing
	];

	(*give the corresponding error*)
	missingZeroOxygenCalibrantInvalidOptions=If[Length[missingZeroOxygenCalibrantOptions]>0&&!gatherTests,
		Message[Error::MustSpecifyZeroOxygenCalibrant,First[missingZeroOxygenCalibrantOptions],Last[missingZeroOxygenCalibrantOptions]];
		{DissolvedOxygenCalibrationType,ZeroOxygenCalibrant},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingZeroOxygenCalibrantTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingZeroOxygenCalibrantOptions]==0,
				Test["If the DissolvedOxygenCalibrationType is TwoPoint, the ZeroOxygenCalibrant is specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingZeroOxygenCalibrantOptions]>0,
				Test["If the DissolvedOxygenCalibrationType is TwoPoint, the ZeroOxygenCalibrant is specified:",True,False],
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

	(*Error::ConfictingZeroOxygenCalibrant  *)
	conflictingZeroOxygenCalibrantionOptions =If[
		(*Is DissolvedOxygenCalibrationType one point and the ZeroOxygenCalibrant is set?*)
		MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],OnePoint]&& MemberQ[Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant],Except[Null|Automatic]],
		(*return the options*)
		{Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant]},
		Nothing
	];

	conflictingZeroOxygenCalibrantionInvalidOptions =If[
		Length[conflictingZeroOxygenCalibrantionOptions]>0&&!gatherTests,
		Message[Error::ConfictingZeroOxygenCalibrant,First[conflictingZeroOxygenCalibrantionOptions],ObjectToString[Last[conflictingZeroOxygenCalibrantionOptions],Simulation -> updatedSimulation]];
		{DissolvedOxygenCalibrationType,ZeroOxygenCalibrant},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingZeroOxygenCalibrantionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingZeroOxygenCalibrantOptions]==0,
				Test["If the DissolvedOxygenCalibrationType is OnePoint, the ZeroOxygenCalibrant is not specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingZeroOxygenCalibrantOptions]>0,
				Test["If the DissolvedOxygenCalibrationType is OnePoint, the ZeroOxygenCalibrant is not specified:",True,False],
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

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(*define some needed globals first*)
	(*the global minimum depth from the immersion instrument*)
	minDepth=1.5*Centimeter;

	(*the global minimum reach from the immersion instrument*)
	minReach=15*Centimeter;

	(*the global minimum volume from the immersion instrument*)
	minVol=25*Milliliter;

	(*get the smallest possible aperture for measurement*)
	smallestAperture=16*Millimeter;

	(*The width of container needed if the stir paddle is turned on*)
	stirWidth=40*Millimeter;

	(*look up the replicate information*)
	numberOfReplicates=Lookup[myOptions,NumberOfReplicates];

	(* Lookup our instrument option. *)
	instruments=Lookup[myOptions,Instrument];

	resolveddissolvedOxygenCalibrationType=Which[
		MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],Except[Automatic]],
		Lookup[measureDissolvedOxygenOptionsAssociation,DissolvedOxygenCalibrationType],
		MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant],Except[Automatic|Null]],
		TwoPoint,
		True,
		OnePoint
	];

	(*Resolve the calibrant before our mapthread*)
	resolvedzeroOxygenCalibrant=Which[
		(*User specified*)
		MatchQ[Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant],Except[Automatic]],
		Lookup[measureDissolvedOxygenOptionsAssociation,ZeroOxygenCalibrant],
		(*Is the DissolvedOxygenCalibrationType two point?*)
		MatchQ[resolveddissolvedOxygenCalibrationType,TwoPoint],
		Model[Sample,"Zero Oxygen Solution"],
		(*One point*)
		True,
		Null
	];

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureDissolvedOxygen, measureDissolvedOxygenOptionsAssociation];

	{
		aliquotVolumeList,
		potentialAliquotContainersList
	}=Transpose[MapThread[
		Function[
			{
				samplePacket,
				sampleContainerPacket,
				aliquotVolume,
				aliquotOption,
				aliquotContainer,
				stir
			},
			Module[{resolvedAliquotVolume,resolvedAliquotContainer},

				(* Resolve aliquot option*)
				{resolvedAliquotVolume,resolvedAliquotContainer}=If[aliquotOption,
					Switch[
						{MatchQ[aliquotVolume,GreaterP[0 Milliliter]],MatchQ[aliquotContainer,ObjectP[{Object[Container],Model[Container]}]]},

						(*if specified both, then that's our resolution*)
						{True,True},
						{aliquotVolume,aliquotContainer},

						(*if only volume specified, find an preferred container based on the specified volume*)
						{True,False},
						{aliquotVolume,preferredDissolvedOxygenContainer[aliquotVolume]},

						(*if only the container specified, or if nothing is specified, find the volume based on the calibration function, if it exists*)
						{False, _},
						Module[{containerPacket, bestVolume},
							(*extract the packet *)
							(* if no container was specified, send in our lowest volume so we get our smallest standard container *)
							containerPacket = If[MatchQ[aliquotContainer,ObjectP[]],
								First@Cases[combinedPotentialContainerPackets, KeyValuePattern[Object -> ObjectP[Download[aliquotContainer, Object]]]],
								First@Cases[combinedPotentialContainerPackets, KeyValuePattern[Object -> ObjectP[preferredDissolvedOxygenContainer[lowestVolume]]]]
							];
							(*If there is a calibration function we'll use that. Otherwise, a fraction of the max volume.*)
							bestVolume = 1.1*minDissolvedOxygenContainerVolume[containerPacket,minReach,minDepth];
							(* If we are consolidating aliquots, then we should only ask for bestVolume/NumberOfReplicates since the replicates will all be combined. *)
							If[consolidateAliquots,
								{N[bestVolume / numberOfReplicates], If[MatchQ[aliquotContainer,ObjectP[]],aliquotContainer,preferredDissolvedOxygenContainer[bestVolume]]},
								{bestVolume, If[MatchQ[aliquotContainer,ObjectP[]],aliquotContainer,preferredDissolvedOxygenContainer[bestVolume]]}
							]
						]
					],
					(*If the sample is in a bad container, it should be moved to one where the probe will fit*)
					If[
						Or[
							(*If it won't fit*)
							MatchQ[Lookup[sampleContainerPacket,Aperture],LessP[smallestAperture]],
							(*If the stir bar will hit the sides*)
							If[stir,!MatchQ[Most[Lookup[sampleContainerPacket,Dimensions]],{GreaterEqualP[stirWidth]..}],False],
							(*If the sample is too low*)
							MatchQ[minDissolvedOxygenContainerVolume[sampleContainerPacket,minReach,minDepth],GreaterP[Lookup[samplePacket,Volume]]],
							LessQ[Lookup[samplePacket,Volume],lowestVolume]
						],
						{40 Milliliter, If[stir, PreferredContainer[51*Milliliter], Model[Container,Vessel,"id:bq9LA0dBGGR6"]]}, (* 50 mL Tube *)
						{Null, Null}
					]
				];

				{
					resolvedAliquotVolume,
					resolvedAliquotContainer
				}
			]
		],
		(*Everything needed to resolve our experimental options.*)
		{
			samplePackets,
			combinedContainerPackets,
			aliquotVolumeLookup,
			aliquotBool,
			aliquotContainerLookup,
			stir
		}
	]];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)
	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[instrument, DeleteCases[Join[simulatedSamples,{oxygenSaturatedCalibrant,resolvedzeroOxygenCalibrant}],Null|Air], Output -> {Result, Tests}, Simulation -> updatedSimulation, Cache -> cacheFailedRemoved],
		{CompatibleMaterialsQ[instrument,DeleteCases[Join[simulatedSamples,{oxygenSaturatedCalibrant,resolvedzeroOxygenCalibrant}],Null|Air], Messages -> Not[gatherTests], Simulation -> updatedSimulation, Cache -> cacheFailedRemoved], {}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && Not[gatherTests],
		{Instrument},
		{}
	];

	(* get whether the SamplesInStorage option is ok *)
	samplesInStorageCondition=Lookup[myOptions, SamplesInStorageCondition];


	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples, simulatedContainers, samplesInStorageCondition, Output -> {Result, Tests}, Simulation -> updatedSimulation, Cache -> cacheFailedRemoved],
		{ValidContainerStorageConditionQ[simulatedSamples, simulatedContainers,samplesInStorageCondition, Output -> Result, Simulation -> updatedSimulation, Cache -> cacheFailedRemoved], {}}
	];

	validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	targetContainers=potentialAliquotContainersList;

	(* Get the minimum amount of volume we can possible use *)
	requiredAliquotAmounts=Map[
		Which[
			(*see if we have restrictions based on the instrument/container*)
			MatchQ[#,GreaterP[lowestVolume]],#,
			(*take the smallest amount otherwise*)
			True,lowestVolume
		]&,
		aliquotVolumeList
	];

	(* Resolve Aliquot Options *)
	resolvedAliquotOptions=resolveAliquotOptions[
		ExperimentMeasureDissolvedOxygen,
		mySamples,
		simulatedSamples,
		ReplaceRule[myOptions, resolvedSamplePrepOptions],
		Cache->cacheFailedRemoved,
		Simulation -> updatedSimulation,
		AllowSolids -> False,
		RequiredAliquotContainers->potentialAliquotContainersList,
		RequiredAliquotAmounts->(Quiet[AchievableResolution[#],{Error::MinimumAmount,Warning::AmountRounded}]&/@requiredAliquotAmounts)
	];

	(* Get a list of booleans to determine if the sample is already in its targetContainer (same model) *)
	alreadyInTargetContainerBools = MapThread[
		Function[{sampleContainerModel,targetContainer},
			MatchQ[sampleContainerModel,ObjectP[targetContainer]]
		],
		{
			Lookup[containerModelPackets,Object],
			targetContainers
		}
	];

	(*get the packets that are low volume*)
	lowVolumePackets=PickList[samplePackets,And@@@Transpose[{lowVolumeBool, alreadyInTargetContainerBools}],True];

	(*  keep track of the invalid inputs *)
	lowVolumeInvalidInputs=If[Length[lowVolumePackets]>0,
		Lookup[Flatten[lowVolumePackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are low volumes and we are throwing messages, throw an error message *)
	If[Length[lowVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::InsufficientVolume,ObjectToString[lowVolumeInvalidInputs,Simulation -> updatedSimulation],ObjectToString[lowestVolume]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	lowVolumeInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowVolumeInvalidInputs]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[lowVolumeInvalidInputs,Simulation -> updatedSimulation]<>" do have sufficient volume for measurement:",True,False]
			];
			passingTest=If[Length[noVolumeInputs]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,lowVolumeInvalidInputs],Simulation -> updatedSimulation]<>" do have sufficient volume for measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		noVolumeInputs,
		lowVolumeInvalidInputs,
		lowVolumeOptionInvalidInputs,
		solidInvalidInputs
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		deprecatedInstrumentOptions,
		missingZeroOxygenCalibrantInvalidOptions,
		validContainerStoragConditionInvalidOptions,
		compatibleMaterialsInvalidOption,
		solidInvalidOptions,
		conflictingZeroOxygenCalibrantionInvalidOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* pull out all the shared options from the input options *)
	{name, confirm, canaryBranch, template, originalCache, operator, parentProtocol, upload, outputOption, email, imageSample,samplePreparation(*), inSitu*)} = Lookup[myOptions, {Name, Confirm, CanaryBranch, Template, Cache, Operator, ParentProtocol, Upload, Output, Email, ImageSample,PreparatoryUnitOperations(*), InSitu*)}];

	(* resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[outputOption, Result]],
			True,
			False
		]
	];

	(* resolve the ImageSample option if Automatic; for this experiment, the default is False *)
	resolvedImageSample = If[MatchQ[imageSample, Automatic],
		False,
		imageSample
	];

	(* --- Do the final preparations --- *)
	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	resolvedOptions = Flatten[{
		Instrument -> instrument,
		DissolvedOxygenCalibrationType -> resolveddissolvedOxygenCalibrationType,
		OxygenSaturatedCalibrant -> oxygenSaturatedCalibrant,
		ZeroOxygenCalibrant -> resolvedzeroOxygenCalibrant,
		NumberOfReadings -> numberOfReadings,
		Stir -> stir,
		NumberOfReplicates -> numberOfReplicates,
		Confirm -> confirm,
		CanaryBranch -> canaryBranch,
		ImageSample -> resolvedImageSample,
		Name -> name,
		Template -> template,
		SamplesInStorageCondition -> samplesInStorageCondition,
		Cache -> originalCache,
		Email -> resolvedEmail,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		Upload -> upload,
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		FastTrack -> fastTrack,
		PreparatoryUnitOperations->samplePreparation
	}];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			discardedTests,
			deprecatedInstrumentTest,
			noVolumeInputsTests,
			missingZeroOxygenCalibrantTests,
			conflictingZeroOxygenCalibrantionTests,
			compatibleMaterialsTests,
			validContainerStorageConditionTests,
			solidTest,
			solidOptionTest
		}],
		_EmeraldTest
	];

	(* generate the Result output rule *)
	(* if we're not returning results, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* generate the tests rule. If we're not gathering tests, the rule is just Null *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/. {resultRule,testsRule}
];


(* ::Subsubsection:: *)
(*Resource Packets*)


DefineOptions[measureDissolvedOxygenResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


measureDissolvedOxygenResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification, output, gatherTests, cache, simulation, samplesWithoutLinks, instrument, instrumentObjects,
		instrumentResource, optionsWithReplicates, protocolPacket, numberOfReplicates, samplesWithReplicates, allResourceBlobs,
		fulfillable, frqTests, resultRule, testsRule, oxygenSaturatedCalibrant, zeroOxygenCalibrant, saturatedCalibrantObject,
		zeroOxygenCalibrantObject, saturatedCalibrantResource, zeroOxygenCalibrantResource, washContainerResource, aquisitionTime
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myOptions],Cache];
	simulation=Lookup[ToList[myOptions],Simulation];

	(* Get rid of the links in mySamples. *)
	samplesWithoutLinks=mySamples/.{link_Link:>Download[link, Object]};

	(* Get our number of replicates. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentMeasureDissolvedOxygen,samplesWithoutLinks,myResolvedOptions];

	(* Lookup some of our options that were expanded. *)
	{instrument,oxygenSaturatedCalibrant,zeroOxygenCalibrant}=Lookup[optionsWithReplicates,
		{Instrument,OxygenSaturatedCalibrant,ZeroOxygenCalibrant}];

	(* Make sure our instruments are objects. *)
	instrumentObjects=Download[instrument,Object];
	saturatedCalibrantObject=oxygenSaturatedCalibrant/.{x:ObjectP[]:>Download[x,Object]};
	zeroOxygenCalibrantObject=zeroOxygenCalibrant/.{x:ObjectP[]:>Download[x,Object]};

	(* Create resources for our calibrant solutions. *)
	saturatedCalibrantResource=If[MatchQ[saturatedCalibrantObject,ObjectP[]],
		Resource[Sample->saturatedCalibrantObject,Amount->40 Milliliter, Container->Model[Container,Vessel,"50mL Tube"]],
		Null
	];

	zeroOxygenCalibrantResource=If[MatchQ[zeroOxygenCalibrantObject,ObjectP[]],
		Resource[Sample->zeroOxygenCalibrantObject,Amount->40 Milliliter, Container->Model[Container,Vessel,"50mL Tube"]],
		Null
	];

	(* wash our probe with over a beaker. *)
	washContainerResource=Resource[Sample->Model[Container, Vessel, "id:BYDOjv1VAA8m"],Rent -> True];

	aquisitionTime=30Minute+Length[samplesWithReplicates]*15Minute+If[MatchQ[saturatedCalibrantResource,Null],5Minute,15Minute]+If[MatchQ[zeroOxygenCalibrantResource,Null],0Minute,15Minute];

	instrumentResource=Resource[
		Instrument->instrumentObjects,
		Time->aquisitionTime
	];

	(* Create our protocol packet. *)
	protocolPacket=Join[
		<|
			Type->Object[Protocol,MeasureDissolvedOxygen],
			Object->CreateID[Object[Protocol,MeasureDissolvedOxygen]],
			Replace[SamplesIn]->(Resource[Sample->#]&)/@samplesWithReplicates,
			Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Lookup[fetchPacketFromCache[#,cache],Container]&/@samplesWithReplicates],
			(*)InSitu->insitu,*)

			(* Protocol specific fields that are picked *)
			Instrument->Link[instrumentResource],
			OxygenSaturatedCalibrant->saturatedCalibrantResource,
			ZeroOxygenCalibrant->zeroOxygenCalibrantResource,
			WasteBeaker->washContainerResource,

			(*protocol specific fields that are not picked*)
			Replace[NumberOfReadings] ->Lookup[optionsWithReplicates,NumberOfReadings],
			Replace[Stir]->Lookup[optionsWithReplicates,Stir],

			Replace[Checkpoints]->{
				{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time->10 Minute]},
				{"Preparing Samples",0 Minute,"Preprocessing, such as incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator->$BaselineOperator,Time->0 Minute]},
				{"Measuring Dissolved Oxygen",aquisitionTime,"The dissolved oxygen of the requested samples is measured.",Resource[Operator->$BaselineOperator,Time->aquisitionTime]},
				{"Sample Postprocessing",0 Minute,"The samples are imaged and volumes are measured.",Resource[Operator->$BaselineOperator,Time->0 Minute]}
			},
			ResolvedOptions->myCollapsedResolvedOptions,
			UnresolvedOptions->myUnresolvedOptions
		|>,
		populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->simulation]
	];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->simulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache->cache,Simulation->simulation],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return our result. *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection:: *)

(*minDissolvedOxygenContainerVolume*)
(*The minumum volume a container needs to be measureable. If this is less than the sample volume, the sample should be moved to an aliquot*)
minDissolvedOxygenContainerVolume[containerPacket:ObjectP[Model[Container]],minReach:GreaterP[0Meter],minDepth:GreaterP[0Meter]]:=Module[
	{listedOptions,cache,calibrationFunction,containerHeight,minLiquidHeight,bestVolume,minVolume,displacedVolume,containerObject},

	containerObject=Lookup[containerPacket, Object];

	(*Lookup the calibration function*)
	calibrationFunction = Lookup[containerPacket, CalibrationFunction];

	(*calculate the displaced volume from the probe insertion*)
	displacedVolume=UnitConvert[minDepth*Pi*(1Centimeter/2)^2,Milliliter];

	(*look up the height of the container*)
	containerHeight = Last@Lookup[containerPacket, Dimensions];

	(*get the minimum liquid height needed for all of the probes*)
	minLiquidHeight = containerHeight - minReach + minDepth;

	(*If there is a calibration function we'll use that. Otherwise, a fraction of the max volume.*)
	minVolume =Which[
		MatchQ[containerObject,ObjectP[Model[Container,Vessel,"50mL Tube"]]],
		40Milliliter,
		MatchQ[containerObject,ObjectP[Model[Container, Vessel, "id:rea9jlR4LwO5"]]],
		270Milliliter,
		True,
		If[Or[NullQ[calibrationFunction], calibrationFunction[minDepth] < 0 Milliliter],
			Max[minLiquidHeight,minDepth]*Lookup[containerPacket, Dimensions][[1]]*Lookup[containerPacket, Dimensions][[2]],
			Max[
				calibrationFunction[minDepth],
				calibrationFunction[minLiquidHeight]
			]
		]-displacedVolume
	]
];

(*internal function to find the preferred container.*)
preferredDissolvedOxygenContainer[input:Alternatives[GreaterP[0 Milliliter],All]]:=Module[{},

	(*if the input requests All, then provide all the containers including BOD bottles*)
	If[MatchQ[input,All],

		(*provide everything including the BOD bottles*)
		Union[PreferredContainer[All],{Model[Container, Vessel, "id:rea9jlR4LwO5"]}],

		Which[
			MatchQ[input,RangeP[270 Milliliter,300 Milliliter]],
			Model[Container, Vessel, "id:rea9jlR4LwO5"],(*"BOD bottle"*)

			(*otherwise, use the preferred container*)
			True,
			PreferredContainer[input]
		]
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentMeasureDissolvedOxygenOptions*)

DefineOptions[ExperimentMeasureDissolvedOxygenOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"General"
		}
	},
	SharedOptions :> {ExperimentMeasureDissolvedOxygen}
];


ExperimentMeasureDissolvedOxygenOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options *)
	options = ExperimentMeasureDissolvedOxygen[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureDissolvedOxygen],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureDissolvedOxygenPreview*)

ExperimentMeasureDissolvedOxygenPreview[myInput:ListableP[ObjectP[{Object[Container],Model[Sample]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ExperimentMeasureDissolvedOxygen]]:=
		ExperimentMeasureDissolvedOxygen[myInput,Append[ToList[myOptions],Output->Preview]];



(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureDissolvedOxygenQ*)

DefineOptions[ValidExperimentMeasureDissolvedOxygenQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions :> {ExperimentMeasureDissolvedOxygen}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentMeasureDissolvedOxygenQ[myInput:ListableP[ObjectP[{Object[Container],Model[Sample]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ValidExperimentMeasureDissolvedOxygenQ]]:=Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasureDissolvedOxygen *)
	filterTests = ExperimentMeasureDissolvedOxygen[myInput, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureDissolvedOxygenQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureDissolvedOxygenQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureDissolvedOxygenQ"]

];
