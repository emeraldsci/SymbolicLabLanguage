(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Experiment*)


(* ::Subsubsection:: *)
(*ExperimentImageSample*)


DefineOptions[
	ExperimentImageSample,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[
						{
							Model[Instrument, PlateImager],
							Model[Instrument, SampleImager],
							Object[Instrument, PlateImager],
							Object[Instrument, SampleImager]
						}
					]
				],
				Description -> "The instrument used to perform the imaging operation.",
				ResolutionDescription -> "Automatically resolves based on the Type and/or specific model parameters of the sample's container.",
				Category->"Protocol"
			},
			{
				OptionName -> AlternateInstruments,
				Default -> Automatic,
				Description -> "The other devices that satisfy the input specification. When Null, no devices beyond the Instrument will be considered for use.",
				ResolutionDescription -> "If the Instrument option is specified as an instrument model, automatically set to all other instrument models that support all parameters of the sample's container.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Instrument, PlateImager],Model[Instrument, SampleImager]}]
					]
				],
				Category->"Protocol"
			},
			{
				OptionName -> ImageContainer,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description -> "Indicates whether images will be taken of the whole container as opposed to the samples contained within.",
				ResolutionDescription -> "Automatically resolves based on the Type and/or specific model parameters of the sample's container.",
				Category->"Protocol"
			},
			{
				OptionName->ImagingDirection,
				Default->Automatic,
				AllowNull->False,
				Widget -> Alternatives[
					Widget[Type->Enumeration, Pattern:>ImagingDirectionP | All],
					Adder[
						Widget[Type->Enumeration, Pattern:>ImagingDirectionP]
					]
				],
				Description->"The orientation of the camera with respect to the container being imaged, where All implies both top and side images will be captured.",
				ResolutionDescription->"Automatically resolves based on the Type and/or specific model parameters of the sample's container.",
				Category->"Protocol"
			},
			{
				OptionName->IlluminationDirection,
				Default->Automatic,
				AllowNull->False,
				Widget -> Alternatives[
					Widget[Type->Enumeration, Pattern:>IlluminationDirectionP | All],
					Adder[
						Widget[Type->Enumeration, Pattern:>IlluminationDirectionP]
					]
				],
				Description->"The source(s) of illumination that will be used for imaging, where All implies all available light sources will be active simultaneously.",
				ResolutionDescription->"Automatically resolves based on the Type and/or specific model parameters of the sample's container.",
				Category->"Protocol"
			}
		],

		(* Shared Options *)
		(* Had to break apart FuntopiaSharedOptions to get rid of ImageSample option *)
		ProtocolOptions,
		SamplePrepOptions,
		AliquotOptions,
		(* This set is the post processing options, minus ImageSample and with MV/MW defaulted to False *)
		{
			OptionName -> MeasureWeight,
			Default -> False,
			Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
			AllowNull -> False,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> MeasureVolume,
			Default -> False,
			Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
			AllowNull -> False,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},

		(* SamplesIn Shared Options *)
		SamplesInStorageOption
	}
];

Error::OptionMismatch="Images can only be acquired from the Side using a SampleImager, or from Overhead using a PlateImager. Please change one or the other option.";
Error::HazardousImaging="Sample(s) `1` are set to be imaged from the top which would require us to remove the cap outside of a glove box or fume hood. This is not possible because they are marked as hazardous in open air (e.g. WaterReactive). If you would still like to image these samples, consider setting ImagingDirection->Side, but note that this may not provide a clear image of the contents."

(* Core experiment overload *)
ExperimentImageSample[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,allListedInputs,listedHealthSafetyFields,imagingFromTopPicklist,nonHazardousPicklist,nonHazardousInputs,hazardousInputs,hazardousImagingIndexPosition,hazardCheckedSamples,hazardCheckedResolvedOptions,hazardTests,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
	templatedOptions,templateTests,inheritedOptions,expandedSafeOps,downloadedPackets,cacheBall,resolvedOptionsResult,
	resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
	containerModelFields,preferredContainerModelsFieldSpec,samplePackets,sampleContainerPackets,
	sampleContainerModelPackets,preferredVessels,preferredPlates,validSamplePreparationResult,mySamplesWithPreparedSamples,
	myOptionsWithPreparedSamples,samplePreparationCache,sampleFields,objectContainerFields,modelContainerFields,
	combinedCacheWithSamplePreparation,instrumentOptionObjects,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOptionsNamed},

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{allListedInputs,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentImageSample,
			allListedInputs,
			ToList[listedOptions]
		],
		$Failed,
	 	{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentImageSample,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentImageSample,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentImageSample,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentImageSample,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
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
		ApplyTemplateOptions[ExperimentImageSample,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentImageSample,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentImageSample,{mySamplesWithPreparedSamples},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Get all of our preferred vessels. *)
	preferredVessels = Join[PreferredContainer[All, Type->Vessel], PreferredContainer[All, Type->Vessel, LightSensitive->True]];
	preferredPlates = Join[PreferredContainer[All, Type->Plate], PreferredContainer[All, Type->Plate, LightSensitive->True]];

	(* Get lists of fields required for aliquot / sample prep, and add on a few ImageSample-specific ones *)
	sampleFields = Join[SamplePreparationCacheFields[Object[Sample], Format -> Packet], Packet[RequestedResources]];
	objectContainerFields = Join[SamplePreparationCacheFields[Object[Container]], {Position, Container}];
	modelContainerFields = Join[SamplePreparationCacheFields[Model[Container]], {CompatibleCameras, NumberOfPositions, Opaque, PlateColor, WellColor, PlateImagerRack, PreferredCamera, PreferredIllumination, SampleImagerRack, Unimageable}];

	(* Using the above list, build field specs to extract container model packets from both input samples and preferred container models *)
	preferredContainerModelsFieldSpec = Packet@@modelContainerFields;

	(* Combine incoming cache with sample preparation cache *)
	combinedCacheWithSamplePreparation = FlattenCachePackets[{Lookup[safeOps, Cache], samplePreparationCache}];

	(* get all Instrument option that were specified as Object[Instrument] to download their Model *)
	instrumentOptionObjects=DeleteDuplicates@Cases[Lookup[safeOps,Instrument],ObjectP[Object[Instrument]],Infinity];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	downloadedPackets = Check[
		Quiet[
			With[
				{ctrModFields = containerModelFields},
				Download[
					{
						mySamplesWithPreparedSamples,
						mySamplesWithPreparedSamples,
						mySamplesWithPreparedSamples,
						mySamplesWithPreparedSamples,
						mySamplesWithPreparedSamples,
						(* mySamplesWithPreparedSamples, *)
						preferredVessels,
						preferredPlates,
						instrumentOptionObjects,
						mySamplesWithPreparedSamples
					},
					{
						{sampleFields},
						{Packet[Container[objectContainerFields]]},
						{Packet[Container[Model][modelContainerFields]]},
						{Packet[Container[Container][{Model}]]},
						{Packet[Container[Container][Model][modelContainerFields]]},
						(* {Packet[Container[Model][PlateImagerRack][{NumberOfPositions, AspectRatio}]]}, *)
						{preferredContainerModelsFieldSpec},
						{preferredContainerModelsFieldSpec},
						{Packet[Model]},
						{Packet[ParticularlyHazardousSubstance,HazardousBan,WaterReactive,Pyrophoric,NFPA]}(* Fields for hazard check *)
					},
					Cache->combinedCacheWithSamplePreparation
				]
			],
			Download::FieldDoesntExist
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	(* Ball it all up so we can toss it down the line *)
	cacheBall = FlattenCachePackets[{combinedCacheWithSamplePreparation, downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentImageSampleOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}=Append[resolveExperimentImageSampleOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Output->{Result}],{}],
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Check Health&Safety fields for potential hazards to avoid removing cap of hazardous samples in the imager *)
	(* Check if Health&Safety fields of input samples for potential hazards *)
	listedHealthSafetyFields=Map[
		Function[{myObject},
				Lookup[
					SelectFirst[
						cacheBall,
						MatchQ[myObject,#[Object]]&
					],
					(* all Objects should have these either inherited from the Model or updated through UploadSampleTransfer *)
					{(*ParticularlyHazardousSubstance,*)HazardousBan,WaterReactive,Pyrophoric,NFPA}
				]
		],
		mySamplesWithPreparedSamples
	];

	(* Create a non-hazardous Picklist *)
	nonHazardousPicklist=Map[
		Which[
			(* If all hazard field are False *)
			!MemberQ[#, True], True,
			(* If NFPA-Health <= 2 *)
			MemberQ[Last[#], Alternatives[(Health -> LessEqualP[2]), Null]], True,
			(* Otherwise, it's hazardous *)
			True, False
		] &,
		listedHealthSafetyFields
	];

	(* Create a imagingFromTop Picklist, including those with resolved ImagingDirections -> Top OR All *)
	imagingFromTopPicklist = Map[
		MemberQ[#, Top]||MatchQ[#, Top|All] &,
		Lookup[resolvedOptions, ImagingDirection]
	];

	(* Use nonHazardousPicklist to pick nonHazardous and hazardous inputs *)
	nonHazardousInputs=PickList[mySamplesWithPreparedSamples,nonHazardousPicklist];
	hazardousInputs=PickList[mySamplesWithPreparedSamples,nonHazardousPicklist, False];

	(* Setting hazard-checked samples and options *)
	{hazardCheckedSamples,hazardCheckedResolvedOptions} = Which[
		(* If no hazard identified, proceed with all inputs *)
		MatchQ[nonHazardousInputs,mySamplesWithPreparedSamples],
		{mySamplesWithPreparedSamples,resolvedOptions},

		(* If explicitly setting ImagingDirection->Side, throw error message but proceed with all inputs *)
		!MemberQ[Lookup[resolvedOptions, ImagingDirection],(Top|All),Infinity],
		{mySamplesWithPreparedSamples,resolvedOptions},

		(* If ImagingDirection is NOT set to Side while $ECLApplication is Engine, throw warning message and proceed with nonhazardous inputs *)
		MatchQ[$ECLApplication,Engine]&&Length[nonHazardousInputs]!=0,
		(
			hazardousImagingIndexPosition = Position[MapThread[
				If[#1==False&&(MemberQ[#2,Top]||MatchQ[#2,Top|All]),True,False]&,
				{nonHazardousPicklist,Lookup[resolvedOptions,ImagingDirection]}
			],True];
			{Delete[mySamplesWithPreparedSamples,
				hazardousImagingIndexPosition],OptionsHandling`Private`removeSelectedIndexMatchedOptions[hazardousImagingIndexPosition,resolvedOptions,ExperimentImageSample]}
		),

		(* Otherwise, throw warning message and return early *)
		True,
		(
			If[!gatherTests&&!MatchQ[$ECLApplication,Engine],
				Message[Error::HazardousImaging,DeleteNestedDuplicates[hazardousInputs]]
			];
			{Null, Null}
		)
	];

	hazardTests = If[gatherTests,
		{Test[
			"All samples requested to be imaged from the top can be safely opened:",
			Or[NullQ[hazardCheckedSamples], NullQ[hazardCheckedResolvedOptions]],
			False]},
		{}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentImageSample,
		hazardCheckedResolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed OR all samples are hazardous to be imaged, return early. *)
	If[
		Or[
			MatchQ[resolvedOptionsResult, $Failed],
			NullQ[hazardCheckedSamples],
			NullQ[hazardCheckedResolvedOptions]
		],
		Return[outputSpecification/.{
			Result -> If[MatchQ[$ECLApplication,Engine],{},$Failed],
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,hazardTests],
			Options->RemoveHiddenOptions[ExperimentImageSample,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		imageSampleResourcePackets[hazardCheckedSamples,templatedOptions,ReplaceRule[collapsedResolvedOptions, {Cache -> cacheBall, Output -> {Result, Tests}}]],
		{imageSampleResourcePackets[hazardCheckedSamples,templatedOptions,ReplaceRule[collapsedResolvedOptions,{Cache -> cacheBall, Output -> Result}]],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests,hazardTests}],
			Options -> RemoveHiddenOptions[ExperimentImageSample,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,ImageSample],
			Cache->cacheBall
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentImageSample,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* Container overload: Passes to sample overload *)
ExperimentImageSample[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,
	samples,sampleOptions,containerToSampleTests, containerModelFields,sampleCache,
	validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
	updatedCache},

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
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentImageSample,
			ToList[myContainers],
			ToList[myOptions]
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
			ExperimentImageSample,
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
				ExperimentImageSample,
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
	updatedCache=FlattenCachePackets[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

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
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentImageSample[samples,ReplaceRule[sampleOptions, Cache->Flatten[{updatedCache,sampleCache}]]]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentImageSampleOptions*)


DefineOptions[
	resolveExperimentImageSampleOptions,
	Options:>{HelperOutputOption,CacheOption}
];

Warning::PreferredIlluminationIncompatible = "The sample(s) `1`, are in containers whose PreferredIllumination is not possible on their specified imaging instrument(s), `2`. A compatible illumination direction has been selected for these samples.";
Warning::ImagingIncompatibleContainer = "The sample(s) `1` are in containers that are not compatible with any available imaging apparatus. Samples will be transferred to new containers to allow imaging to occur.";
Error::ImageSampleInvalidAlternateInstruments="The following instrument models cannot be used as alternative devices: `1`. AlternateInstruments cannot be specified if the Instrument option is an instrument object. Any models specified as AlternateInstruments cannot overlap with the Instrument option. Please specify a different model or leave AlternateInstruments option to be set automatically.";

resolveExperimentImageSampleOptions[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentImageSampleOptions]]:=Module[
	{
		outputSpecification, output, listedInputs, gatherTestsQ, messagesQ, engineQ, downloadedPackets,
		cache, samplePrepOptions, imageSampleOptions, simulatedSamples, resolvedSamplePrepOptions, simulatedCache,
		imageSampleOptionsAssociation, preferredVessels, preferredPlates, containerModelFields, preferredContainerModelsFieldSpec,
		samplePackets, sampleContainerPackets, sampleContainerModelPackets, preferredVesselPackets, preferredPlatePackets,
		instrumentObjectPackets, discardedSamplePackets, discardedInvalidInputs, discardedTest, imagerImagingDirectionMismatches,
		imagerImagingDirectionMismatchOptions, imagerImagingDirectionMismatchInputs, imagerImagingDirectionInvalidOptions,
		imagerImagingDirectionTest,	imagerIlluminationDirectionMismatches,	imagerIlluminationDirectionMismatchOptions,
		imagerIlluminationDirectionMismatchInputs, imagerIlluminationDirectionInvalidOptions, imagerIlluminationDirectionTest,
		nameOption, validNameQ, nameInvalidOptions, validNameTest, mapThreadFriendlyOptions, plateImagerModels, sampleImagerModel,
		instrumentOptionObjects, updatedSimulatedCache, instrumentModelLookup,

		(* Resolved options from MapThread *)
		instruments, alternateInstruments, imageContainers, imagingDirections, illuminationDirections,

		(* Errors from MapThread *)
		preferredIlluminationIncompatibleErrors, unimageableContainerErrors, preferredIlluminationIncompatibleTests,
		imageContainerInstIncompatibleErrors, unimageableContainerTests, potentialAliquotContainersList, invalidInputs,
		invalidOptions, targetContainers, resolvedAliquotOptions, aliquotTests, imageSample, email,	confirm, template,
		samplesInStorageCondition, fastTrack, operator, parentProtocol, upload, outputOption,	sampleFields,
		objectContainerFields, modelContainerFields, invalidAlternateInstrumentErrors, invalidAlternateInstrumentsOption,
		invalidAlternateInstrumentsTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Make sure we are dealing with a list of inputs rather than a singleton *)
	listedInputs = ToList[mySamples];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTestsQ = MemberQ[output,Tests];

	(* Determine whether messages should be thrown *)
	messagesQ = !gatherTestsQ;

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication,Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Seperate out our ImageSample options from our Sample Prep options. *)
	{samplePrepOptions,imageSampleOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,simulatedCache} = resolveSamplePrepOptions[ExperimentImageSample, listedInputs, samplePrepOptions, Cache->cache];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	imageSampleOptionsAssociation = Association[imageSampleOptions];

	(* Get all of our preferred vessels. *)
	preferredVessels = Join[PreferredContainer[All, Type->Vessel], PreferredContainer[All, Type->Vessel, LightSensitive->True]];
	preferredPlates = Join[PreferredContainer[All, Type->Plate], PreferredContainer[All, Type->Plate, LightSensitive->True]];

	(* Specify usable models of plate and sample imager *)
	(* note: there's only one model for sample imager. we have to update to a Search call when we have more *)
	plateImagerModels = Search[Model[Instrument, PlateImager]]; (* Vision M3/M4 Plate Imager *)
	sampleImagerModel = Model[Instrument, SampleImager, "id:eGakld01zVXe"]; (* Emerald DSLR Camera Imaging Station *)

	(* get all Instrument option that were specified as Object[Instrument] to download their Model *)
	instrumentOptionObjects=DeleteDuplicates@Cases[Lookup[imageSampleOptionsAssociation,Instrument],ObjectP[Object[Instrument]],Infinity];

	(* Get lists of fields required for aliquot / sample prep, and add on a few ImageSample-specific ones *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];
	objectContainerFields = Join[SamplePreparationCacheFields[Object[Container]], {Position, Container, DateUnsealed}];
	modelContainerFields = Join[SamplePreparationCacheFields[Model[Container]], {CompatibleCameras, NumberOfPositions, Opaque, PlateColor, WellColor, PlateImagerRack, PreferredCamera, PreferredIllumination, SampleImagerRack, Unimageable}];

	(* Using the above list, build field specs to extract container model packets from both input samples and preferred container models *)
	preferredContainerModelsFieldSpec = Packet@@modelContainerFields;

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	downloadedPackets = Quiet[
		Download[
			{
				simulatedSamples,
				simulatedSamples,
				simulatedSamples,
				preferredVessels,
				preferredPlates,
				instrumentOptionObjects
			},
			{
				{sampleFields},
				{Packet[Container[objectContainerFields]]},
				{Packet[Container[Model][modelContainerFields]]},
				{preferredContainerModelsFieldSpec},
				{preferredContainerModelsFieldSpec},
				{Packet[Model]}
			},
			Cache->simulatedCache
		],
		Download::FieldDoesntExist
	];

	samplePackets = Flatten[downloadedPackets[[1]]];
	sampleContainerPackets = Flatten[downloadedPackets[[2]]];
	sampleContainerModelPackets = Flatten[downloadedPackets[[3]]];
	preferredVesselPackets = Flatten[downloadedPackets[[4]]];
	preferredPlatePackets = Flatten[downloadedPackets[[5]]];
	instrumentObjectPackets = Flatten[downloadedPackets[[6]]];

	(* TODO: Delete duplicates / merge and stuff? *)
	updatedSimulatedCache = FlattenCachePackets[{simulatedCache, downloadedPackets}];


	(* === INPUT VALIDATION CHECKS === *)

	(* Extract discarded samples from sample packets *)
	discardedSamplePackets=Cases[samplePackets, KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTestsQ,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->updatedSimulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTestsQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->updatedSimulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->updatedSimulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* === CONFLICTING OPTIONS CHECKS === *)

	(* For each sample, make sure that Instrument and ImagingDirection do not conflict
	 	(Side imaging cannot be performed on the plate imager) *)
	imagerImagingDirectionMismatches = MapThread[
		Function[{imager, imagingDirection, sample},
			If[MatchQ[imager, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]] && MemberQ[ToList[imagingDirection], (Side|All)],
				{{imager, imagingDirection}, sample},
				Nothing
			]
		],
		{Lookup[imageSampleOptionsAssociation, Instrument], Lookup[imageSampleOptionsAssociation, ImagingDirection], simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{imagerImagingDirectionMismatchOptions,imagerImagingDirectionMismatchInputs}=If[MatchQ[imagerImagingDirectionMismatches,{}],
		{{},{}},
		Transpose[imagerImagingDirectionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	imagerImagingDirectionInvalidOptions=If[Length[imagerImagingDirectionMismatchOptions]>0&&messagesQ,
		(
			Message[Error::OptionMismatch,imagerImagingDirectionMismatchOptions,ObjectToString[imagerImagingDirectionMismatchInputs, Cache -> updatedSimulatedCache]];
			{Instrument, ImagingDirection}
		),
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	imagerImagingDirectionTest=If[gatherTestsQ,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,imagerImagingDirectionMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options Instrument and ImagingDirection match for the inputs "<>ObjectToString[passingInputs,Cache->updatedSimulatedCache]<>", if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[imagerImagingDirectionMismatchInputs]>0,
				Test["The options Instrument and ImagingDirection match for the inputs "<>ObjectToString[imagerImagingDirectionMismatchInputs,Cache->updatedSimulatedCache]<>", if supplied by the user:",True,False],
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


	(* For each sample, make sure that Instrument and IlluminationDirection do not conflict
	 	(Side illumination cannot be performed on the plate imager) *)
	imagerIlluminationDirectionMismatches = MapThread[
		Function[{imager, illuminationDirection, sample},
			If[MatchQ[imager, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]] && MemberQ[ToList[illuminationDirection], Side],
				{{imager, illuminationDirection}, sample},
				Nothing
			]
		],
		{Lookup[imageSampleOptionsAssociation, Instrument], Lookup[imageSampleOptionsAssociation, IlluminationDirection], simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{imagerIlluminationDirectionMismatchOptions,imagerIlluminationDirectionMismatchInputs}=If[MatchQ[imagerIlluminationDirectionMismatches,{}],
		{{},{}},
		Transpose[imagerIlluminationDirectionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	imagerIlluminationDirectionInvalidOptions=If[Length[imagerIlluminationDirectionMismatchOptions]>0&&messagesQ,
		(
			Message[Error::OptionMismatch,imagerIlluminationDirectionMismatchOptions,ObjectToString[imagerIlluminationDirectionMismatchInputs, Cache -> updatedSimulatedCache]];
			{Instrument, IlluminationDirection}
		),
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	imagerIlluminationDirectionTest=If[gatherTestsQ,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,imagerIlluminationDirectionMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options Instrument and IlluminationDirection match for the inputs "<>ObjectToString[passingInputs,Cache->updatedSimulatedCache]<>", if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[imagerIlluminationDirectionMismatchInputs]>0,
				Test["The options Instrument and IlluminationDirection match for the inputs "<>ObjectToString[imagerIlluminationDirectionMismatchInputs,Cache->updatedSimulatedCache]<>", if supplied by the user:",True,False],
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


	(* === INVALID OPTION CHECKS === *)

	(* Check to see if a reasonable Name option has been specified *)
	nameOption = Lookup[imageSampleOptionsAssociation, Name];

	validNameQ=If[MatchQ[nameOption,_String],
		Not[DatabaseMemberQ[Object[Protocol,ImageSample,nameOption]]],
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[Not[validNameQ]&&messagesQ,
		(
			Message[Error::DuplicateName,"ImageSample protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTestsQ&&MatchQ[nameOption,_String],
		Test["If specified, Name is not already an ImageSample protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];


	(* === RESOLVE EXPERIMENT OPTIONS === *)
	(* Convert options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentImageSample,imageSampleOptionsAssociation];

	(* create a model lookup for each specified Object[Instrument] *)
	(* we will try to resolve Automatic Instrument to Object[Instrument] in mapthread if possible for easy batching *)
	instrumentModelLookup=If[!MatchQ[instrumentObjectPackets,{}],
		Rule@@@Lookup[instrumentObjectPackets,{Model,Object}]/.link_Link:>Download[link,Object],
		{}
	];

	{
		instruments,
		alternateInstruments,
		imageContainers,
		imagingDirections,
		illuminationDirections,
		preferredIlluminationIncompatibleErrors,
		unimageableContainerErrors,
		imageContainerInstIncompatibleErrors,
		invalidAlternateInstrumentErrors,
		potentialAliquotContainersList
	} = Transpose[MapThread[
		Function[{mySample, myMapThreadOptions},
			Module[
				{
					(* Error variables *)
					preferredIlluminationIncompatibleError, unimageableContainerError, imageContainerInstIncompatibleError, invalidAlternateInstrumentError,

					compatibleAliquotContainers, potentialAliquotContainers, unResImageContainer, leftoverInstruments,
					samplePacket, sampleContainer, containerPacket, sampleContainerModel, containerModelPacket, errorVariables, finalContainerModel, finalContainerModelPacket,
					(* Unresolved options *)
					unresolvedInstrument, unresolvedAlternateInstrumentList, unresolvedImagingDirection, unresolvedIlluminationDirection,
					(* Model fields relevant to options resolution *)
					preferredCamera, compatibleCameras,	defaultCamera,
					(* Resolved options *)
					instrument, alternateInstrumentList, resImageContainer, imagingDirection, illuminationDirection
				},

				(* Initialize error-tracking variable to False *)
				errorVariables = {preferredIlluminationIncompatibleError, unimageableContainerError, imageContainerInstIncompatibleError, invalidAlternateInstrumentError};
				Evaluate[errorVariables] = ConstantArray[False,Length[errorVariables]];

				(* Initialize potential aliquot containers to Null; assume we won't have to aliquot *)
				potentialAliquotContainers = Null;

				(* Lookup information about our sample. *)
				samplePacket=fetchPacketFromCacheImageSample[mySample[Object], updatedSimulatedCache];

				(* Lookup information about our sample's container. *)

				(* Get the container object that our sample is in. *)
				sampleContainer=Lookup[samplePacket,Container,Null]/.{link_Link:>Download[link, Object]};

				(* Lookup information about the container of our sample *)
				containerPacket = fetchPacketFromCacheImageSample[sampleContainer[Object], updatedSimulatedCache];

				(* Get the model of this container object. *)
				sampleContainerModel=Lookup[fetchPacketFromCacheImageSample[sampleContainer[Object], updatedSimulatedCache],Model][Object];

				(* Get the packet that corresponds to the model of the container object. *)
				containerModelPacket=fetchPacketFromCacheImageSample[sampleContainerModel, updatedSimulatedCache];

				(* Pull out some other key information and store in local variables *)
				{unresolvedInstrument, unresolvedAlternateInstrumentList, unResImageContainer, unresolvedImagingDirection, unresolvedIlluminationDirection} = Lookup[
					myMapThreadOptions,
					{Instrument, AlternateInstruments, ImageContainer, ImagingDirection, IlluminationDirection}
				]/.link_Link:>Download[link,Object];

				(* Extract preferred and compatible cameras *)
				{preferredCamera, compatibleCameras} = Lookup[containerModelPacket, {PreferredCamera, CompatibleCameras}];

				(* Quick little private helper to figure out the "default" camera for a given container model
					This will be either the PreferredCamera (if populated) or the first member of CompatibleCameras (if no PreferredCamera is available) *)
				defaultCamera[containerModelPacket:PacketP[Model[Container]]] := If[!NullQ[Lookup[containerModelPacket, PreferredCamera]],
					Lookup[containerModelPacket, PreferredCamera],
					FirstOrDefault[Lookup[containerModelPacket, CompatibleCameras]]
				];

				(* Resolve our ImageContainer option based on whether the container has samples *)
				resImageContainer = If[MatchQ[unResImageContainer,Automatic],

					(* If we're resolving the Automatic, switch off whether the container has contents *)
					(* TODO: Refactor *)
					MatchQ[
						mySample,
						AssociationMatchP[<|Object->ObjectReferenceP[Object[Sample]], Name->_String?(StringMatchQ[#,"EmptyContainer Simulated Sample "<>___]&)|>]
					],

					(* We were given a value so use that *)
					unResImageContainer
				];

				(* Figure out which containers would be compatible for aliquoting if needed below *)
				(* TODO: Make smarter about solid samples? *)
				(* TODO: Make more conscious of materials compatibility? *)
				(* TODO: Separate into helper to allow for reuse later? *)
				compatibleAliquotContainers = Module[
					{opaqueContainerQ, opacitySortedPlates, opacitySortedVessels, typePrioritizedContainers, volumeFilteredContainers,
					imagerFilteredContainers},
					(*
						General algorithm:
							- Get packets for all preferred containers
							- Within plates and vessels, order based on current container's opacity
							- Assemble full list of potential containers, ordering plates vs vessels based on the current container type (plates vs vessels)
							- Filter out containers that don't satisfy volume requirements (min/max)
							- Filter out containers that are incompatible with instrument, if specified
							- Will take the first when resolving TargetContainer, so do the rest of resolution with this assumption
					*)

					(* Decide whether to consider the sample container 'Opaque'
							- For plates, WellColor==(OpaqueBlack | OpaqueWhite)
							- For vessels, Opaque==True *)
					opaqueContainerQ = Or[
						MatchQ[Lookup[containerModelPacket, WellColor], (OpaqueBlack | OpaqueWhite)],
						TrueQ[Lookup[containerModelPacket, Opaque]]
					];

					(* Within each container type, sort favoring the current container's opacity / well color *)
					opacitySortedPlates = Sort[preferredPlatePackets, MatchQ[Lookup[#, WellColor], If[opaqueContainerQ, (OpaqueBlack | OpaqueWhite), Except[(OpaqueBlack | OpaqueWhite)]]]&];
					opacitySortedVessels = Sort[preferredVesselPackets, MatchQ[Lookup[#, Opaque], If[opaqueContainerQ, True, Except[True]]]&];

					(* Favor aliquoting into the type of container the sample is already in *)
					(* TODO: May need to make an exception if user has specifically requested imaging type for which current container type is infeasible,
						e.g. sample imager but plate has been specified *)
					typePrioritizedContainers = If[MatchQ[sampleContainer, ObjectP[Object[Container, Plate]]],
						Join[opacitySortedPlates, opacitySortedVessels],
						Join[opacitySortedVessels, opacitySortedPlates]
					];

					(* If sample volume is populated, consider only containers that can accommodate the sample's volume
						Be careful to account for Null Min/MaxVolume, although in practice only MinVolume is allowed to be Null at present *)
					volumeFilteredContainers = If[VolumeQ[Lookup[samplePacket, Volume, Null]],
						Select[
							typePrioritizedContainers,
							And[
								If[!NullQ[Lookup[#, MinVolume]], Lookup[#, MinVolume] <= Lookup[samplePacket, Volume], True],
								If[!NullQ[Lookup[#, MaxVolume]], Lookup[samplePacket, Volume] <= Lookup[#, MaxVolume], True]
							]&
						],
						typePrioritizedContainers
					];

					(* If plate imager has been explicitly specified, make sure any potential tube models can be plate imaged *)
					(* TODO: Also account for sample imager being specified -- don't include any plates unless they have only one well *)
					imagerFilteredContainers = Switch[unresolvedInstrument,

						(* If plate imager has been explicitly specified, select only plates or other containers that are 
							explicitly listed as plate imageable (e.g. rackable tubes) *)
						ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}],
							Select[
								volumeFilteredContainers,
								With[{compatibleAndPreferredCameras = Append@@Lookup[#, {CompatibleCameras, PreferredCamera}]},
									Or[
										(* Is not a plate, but 'Plate' appears in compatible and/or preferred camera fields *)
										MemberQ[compatibleAndPreferredCameras, Plate],
										(* Is a plate and, if Preferred/CompatibleCameras are populated, Plate is a member *)
										And[
											MatchQ[#, ObjectP[Model[Container, Plate]]],
											Or[
												NullQ[compatibleAndPreferredCameras],
												MemberQ[compatibleAndPreferredCameras, Plate]
											]
										]
									]
								]&
							],

						(* If sample imager has been explicitly specified, exclude all plates except those that specifically list 
							S/M/L/Overhead in Preferred/CompatibleCameras *)
						ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}],
							Select[
								volumeFilteredContainers,
								With[{compatibleAndPreferredCameras = Append@@Lookup[#, {CompatibleCameras, PreferredCamera}]},
									Or[
										(* Is a vessel *)
										MatchQ[#, ObjectP[Model[Container, Vessel]]],
										(* Is a plate but is specifically listed for sample imaging *)
										And[
											MatchQ[#, ObjectP[Model[Container, Plate]]],
											MemberQ[compatibleAndPreferredCameras, Small|Medium|Large|Overhead]
										]
									]
								]&
							],

						(* If no instrument has been explicitly requested, any volume-appropriate aliquot container is OK *)
						_, volumeFilteredContainers
					];

					(* Return a list of aliquot containers that will be suitable *)
					imagerFilteredContainers[Object]
				];

				(* Determine whether current container model is completely unimageable.
					At resource packet generation time, these samples will be omitted if we're in a subprotocol
					because we don't want to do any transferring in a sub. If we're in a standalone protocol,
					we'll throw a warning and do the transferring. 
					TODO: catch subtler errors (e.g. plate imager requested for imaging a bottle) in the instrument resolution block below. *)
				unimageableContainerError = MatchQ[Lookup[containerModelPacket, Unimageable, Null], True];

				(* If container model is unimageable, populate potentialAliquotContainers with the list of compatible containers above *)
				potentialAliquotContainers = If[unimageableContainerError,
					compatibleAliquotContainers,
					(* If container is imageable, do not set error flag and do not populate potentialAliquotContainers *)
					{}
				];

				(* Decide what container model we'll use for options resolution moving forward.
					If the sample container is unimageable, use the first of potentialAliquotContainers
					If the sample container is imageable, just use it *)
				{finalContainerModel, finalContainerModelPacket} = If[MatchQ[potentialAliquotContainers, {}],
					{sampleContainerModel, containerModelPacket},
					{First[potentialAliquotContainers], fetchPacketFromCacheImageSample[First[potentialAliquotContainers], updatedSimulatedCache]}
				];

				(* Resolve the imaging instrument to be used *)
				instrument = If[!MatchQ[unresolvedInstrument, Automatic],

					(* If Instrument was specified by user, use that value and check if containers are compatible *)
					Module[{},
						(* We'll need to aliquot in the following circumstances:
							- If plate imager model/object is specified, (container is a vessel?), and container model does not have Plate in preferred or compatible cameras
							(TODO: NOT YET HANDLED) - If sample imager model/object is specified and container model does not have Small|Medium|Large|Overhead in preferred or compatible cameras *)
						If[And[
								MatchQ[unresolvedInstrument, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]],
								MatchQ[finalContainerModel, ObjectP[Model[Container, Vessel]]],
								!MemberQ[Append@@Lookup[finalContainerModelPacket, {CompatibleCameras, PreferredCamera}], Plate]
							],

							(* If we're not trying to image the container, *)
							If[!TrueQ[resImageContainer],

								(
									(* set list of potential aliquot containers to the list of compatible containers above *)
									potentialAliquotContainers = compatibleAliquotContainers;

									(* Reset final container model and packet to match the first of potential aliquot containers *)
									finalContainerModel = First[potentialAliquotContainers];
									finalContainerModelPacket = fetchPacketFromCacheImageSample[First[potentialAliquotContainers], updatedSimulatedCache];
									Null(* Return null as there's no variable being set *)
								),

								(* If we are in this state but ImageContainer -> True, then we need to throw an error*)
								(
									imageContainerInstIncompatibleError = True;
									Null
								)
							]
						];
						(* Keep specified instrument regardless *)
						unresolvedInstrument
					],

					(* If Instrument was not specified, resolve it *)
					If[MemberQ[ToList[unresolvedImagingDirection], (Side|All)] || MemberQ[ToList[unresolvedIlluminationDirection], (Side|All)],
						(* Must use sample imager if either imaging direction or illumination direction is set to Side or All *)
						(* TODO: Must aliquot if we're currently in a plate here *)
						sampleImagerModel,
						Switch[defaultCamera[finalContainerModelPacket],

							(* If the container model's 'default' camera is the plate imager, check whether we're imaging the container or the sample *)
							Plate,
								If[!TrueQ[resImageContainer],

									(* If we're imaging the samples then definitely use the plate imager *)
									(* if an Object[Instrument] of the same Model is already specified, use it *)
									First[plateImagerModels]/.instrumentModelLookup,

									(* If we're imaging the container, still default to sample imager *)
									sampleImagerModel
								],

							(* If the container model's 'default' camera is a S/M/L side camera, use the sample imager *)
							(Small | Medium | Large | Overhead), sampleImagerModel,

							(* If no 'default' camera is specified in the container model, image plates with plate imager and everything else with sample imager *)
							(* NOTE: This is no longer a hard-and-fast rule since we image 200mL robotic reservoirs using the sample imager overhead camera,
								but that particular model has PreferredCamera->Overhead, so it should never match this condition. *)
							Null,
								If[MatchQ[finalContainerModel, ObjectP[Model[Container,Plate]]],

									(* Before we hard default to plate imager for Model[Container, Plate], make sure we're not intending to image the container instead *)
									If[!TrueQ[resImageContainer],

										(* If we're imaging the samples then definitely use the plate imager *)
										(* if an Object[Instrument] of the same Model is already specified, use it *)
										First[plateImagerModels]/.instrumentModelLookup,

										(* If we're imaging the container, still default to sample imager *)
										sampleImagerModel
									],

									(* The container model is not a plate so use the sample imager *)
									sampleImagerModel
								]
						]
					]
				];

				(* Resolve the alternative instruments we can use *)

				(* get a list of instrument model with similar type that's not the resolved instrument *)
				leftoverInstruments=If[MatchQ[instrument,ObjectP[Model[Instrument,PlateImager]]],
					(* if our resolved instrument is a plate imager, use the corresponding list *)
					DeleteCases[plateImagerModels,instrument],
					(* else: our resolved instrument is a sample imager. set to {} since we currently have one device *)
					{}
				];

				(* is AlternateInstrument option specified? *)
				alternateInstrumentList=If[MatchQ[unresolvedAlternateInstrumentList,Automatic],
					(* is Instrument option specified? and do we have any leftover instrument model? *)
					If[MatchQ[unresolvedInstrument,Automatic]&&!MatchQ[leftoverInstruments,{}],
						(* yes: resolve to leftover instrument models with the same type as our resolved instrument *)
						(* note: we sort here so that it is ready to use for gathering samples in resourcepackets *)
						Sort@leftoverInstruments,
						(* else: set to Null *)
						Null
					],
					(* else: is it Null? *)
					If[NullQ[unresolvedAlternateInstrumentList],
						(* yes: don't bother checking *)
						unresolvedAlternateInstrumentList,

						(* is Instrument option specified as an instrument OBJECT? *)
						If[MatchQ[unresolvedInstrument,ObjectP[Object[Instrument]]],
							(* yes: flip the error switch and return the specified value *)
							invalidAlternateInstrumentError=True;unresolvedAlternateInstrumentList,
							(* else: is unresolvedAlternateInstrumentList a subset of our leftover list? *)
							If[ContainsAll[leftoverInstruments,unresolvedAlternateInstrumentList],
								(* yes: return as is *)
								Sort@unresolvedAlternateInstrumentList,
								(* else: specified value overlaps with Instrument option, flip the error switch and return the specified value *)
								invalidAlternateInstrumentError=True;unresolvedAlternateInstrumentList
							]
						]
					]
				];

				(* Resolve ImagingDirection *)
				imagingDirection = If[!MatchQ[unresolvedImagingDirection, Automatic],

					(* If ImagingDirection was specified by user, use that value (including lists) *)
					(* DeleteDuplicates becasue with multiple input samples unresolvedImagingDirection is a list of those specified attribute, except for All *)
					If[Length[unresolvedImagingDirection]>1,
						DeleteDuplicates[unresolvedImagingDirection],
						If[unresolvedImagingDirection=!=All,ToList[unresolvedImagingDirection],unresolvedImagingDirection]
					],

					(* If ImagingDirection is Automatic, resolve appropriately based on imager, PreferredCamera, and other container attributes *)
					(* TODO: Determine if this has to change based off of ImageContainer *)
					If[MatchQ[instrument, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]],

						(* If instrument resolved to plate imager, can only image from the top *)
						{Top},

						(* If we're ImageContainer -> True, and the container is a Plate, image overhead *)
						If[TrueQ[resImageContainer] && MatchQ[finalContainerModel, ObjectP[Model[Container,Plate]]],

							{Top},

							(* If we're not image container on a plate, and if instrument resolved to sample imager, first look at Preferred  camera*)
							If[
								MatchQ[defaultCamera[finalContainerModelPacket], Overhead],
								{Top},

								(* If overhead imaging is not preferred, make a decision based on container opacity, if the container has been previously opened, and if the sample inside the container is anhydrous and requires ventilation *)
								If[TrueQ[Lookup[finalContainerModelPacket, Opaque]]&&!NullQ[Lookup[containerPacket,DateUnsealed]]&&!TrueQ[Lookup[samplePacket,Ventilated]]&&!TrueQ[Lookup[samplePacket,Anhydrous]]&&!TrueQ[Lookup[finalContainerModelPacket,Hermetic]],

									(* If imaging an opaque, unopened container and the sample does not require a ventilated environment and is not anhydrous, top is the most revealing direction *)
									{Top},

									(* Otherwise, if imaging a transparent / translucent container, side is the most revealing direction. *)
									(*If the container is opaque but hasn't been opened or the sample requires ventilation/is anhydrous, it is better to ere on the side of not opening the container *)
									{Side}
								]
							]
						]
					]
				];

				(* Resolve IlluminationDirection *)
				illuminationDirection = If[!MatchQ[unresolvedIlluminationDirection, Automatic],

					(* If IlluminationDirection was specified by user, use that value *)
					unresolvedIlluminationDirection,

					(* If IlluminationDirection is Automatic, resolve based on instrument and container type / opacity / PreferredIllumination *)
					Switch[{Lookup[finalContainerModelPacket, PreferredIllumination], instrument},

						(* If PreferredIllumination is populated and isn't Side, it can be used without precondition (wrap it in a list to remove index matching ambiguity) *)
						{Except[Null|Side], _},
							{Lookup[finalContainerModelPacket, PreferredIllumination]},

						(* If PreferredIllumination is populated and is Side, but instrument is a sample imager, that's fine. Use IlluminationDirection->{Side}. *)
						{Side, ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}]},
							{Lookup[finalContainerModelPacket, PreferredIllumination]},

						(* Go through more specific resolution logic if EITHER:
								- PreferredIllumination->Side and instrument is a plate imager (must throw warning then resolve illumination based on container properties)
								- PreferredIllumination->Null (just resolve illumination based on container properties) *)
						(* TODO: Revisit the choices made here to improve default imaging of containers *)
						Alternatives[
							{Side, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]},
							{Null, _}
						],
							Module[{},

								(* Must first check if we have the PreferredIllumination->Side and imager=Plate Imager combo.
									If we do, set the appropriate warning variable, then proceed with automatic resolution, ignoring PreferredIllumination *)
								If[And[
									MatchQ[Lookup[finalContainerModelPacket, PreferredIllumination], Side],
									MatchQ[instrument, ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]]
									],
									preferredIlluminationIncompatibleError=True
								];

								(* First branch point: instrument *)
								Switch[instrument,
									ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}],
										(* Second branch point for plate imager: container parameters *)
										Switch[Lookup[finalContainerModelPacket, {Type, Opaque, WellColor}, Null],
											(* Opaque vessel: Ambient illumination *)
											{TypeP[Model[Container, Vessel]], True, _}, {Ambient},
											(* Opaque plate: Top illumination *)
											{TypeP[Model[Container, Plate]], _, OpaqueBlack|OpaqueWhite}, {Top},
											(* Translucent vessel: Bottom illumination *)
											{TypeP[Model[Container, Vessel]], Except[True], _}, {Bottom},
											(* Translucent plate: Bottom illumination *)
											{TypeP[Model[Container, Plate]], _, Except[OpaqueBlack|OpaqueWhite]}, {Bottom}
										],
									ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}],
										(* Second branch point for sample imager: container opacity *)
										If[TrueQ[Lookup[finalContainerModelPacket, Opaque]],
											(* Opaque container: Top illumination *)
											{Top},
											(* Translucent container: Ambient illumination *)
											{Ambient}
										]
								]
							]
					]
				];
				{
					(* Resolved options *)
					instrument, alternateInstrumentList, resImageContainer, imagingDirection, illuminationDirection,
					(* Errors *)
					preferredIlluminationIncompatibleError, unimageableContainerError, imageContainerInstIncompatibleError, invalidAlternateInstrumentError,
					(* Aliquot containers *)
					potentialAliquotContainers
				}
			]
		],
		{simulatedSamples,mapThreadFriendlyOptions}
	]];


	(* === UNRESOLVABLE OPTION CHECKS === *)
	(* TODO: Generate Tests for these warnings? *)

	(* Check for cases where a container's PreferredIllumination field is incompatible with the instrument they've specified *)
	If[Or@@preferredIlluminationIncompatibleErrors && !gatherTestsQ && !engineQ,
		Module[{preferredIlluminationIncompatibleInvalidSamples,invalidInstruments},
			(* Get the samples that correspond to this error. *)
			preferredIlluminationIncompatibleInvalidSamples = PickList[simulatedSamples,preferredIlluminationIncompatibleErrors];

			(* Get the corresponding invalid instruments. *)
			invalidInstruments = PickList[instruments,preferredIlluminationIncompatibleErrors];

			(* Throw the corresponding error. *)
			Message[Warning::PreferredIlluminationIncompatible,ObjectToString[preferredIlluminationIncompatibleInvalidSamples,Cache->updatedSimulatedCache],ObjectToString[invalidInstruments,Cache->updatedSimulatedCache]];
		]
	];

	(* Create tests for preferred illumination incompatibility warning *)
	preferredIlluminationIncompatibleTests = If[gatherTestsQ,
		Module[
			{failingInputs, passingInputs, failingInputsTest, passingInputsTest},

			(* Get a list of inputs that are failing this test *)
			failingInputs = PickList[simulatedSamples, preferredIlluminationIncompatibleErrors, True];

			(* Get the corresponding list of inputs that are passing *)
			passingInputs = PickList[simulatedSamples, preferredIlluminationIncompatibleErrors, False];

			(* Create a test for passing inputs *)
			failingInputsTest = If[Length[failingInputs]>0,
				Warning["The following samples, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", will receive different illumination than their containers' PreferredIllumination because of conflicts with the specified imager.",True,False],
				Nothing
			];

			(* Create a test for passing inputs *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", will be illuminated as specified or as indicated by their containers' PreferredIllumination fields.",True,True],
				Nothing
			];

			(* Return created tests *)
			{passingInputsTest, failingInputsTest}

		],

		(* Don't create tests if we aren't gathering them *)
		{}
	];


	(* Check for unimageable containers that will need to be transferred *)
	If[Or@@unimageableContainerErrors && !gatherTestsQ && !engineQ,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,unimageableContainerErrors];

			(* Throw the corresopnding error. *)
			Message[Warning::ImagingIncompatibleContainer,ObjectToString[invalidSamples,Cache->updatedSimulatedCache]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create tests for unimageable containers warning *)
	unimageableContainerTests = If[gatherTestsQ,
		Module[
			{failingInputs, passingInputs, failingInputsTest, passingInputsTest},

			(* Get a list of inputs that are failing this test *)
			failingInputs = PickList[simulatedSamples, unimageableContainerErrors, True];

			(* Get the corresponding list of inputs that are passing *)
			passingInputs = PickList[simulatedSamples, unimageableContainerErrors, False];

			(* Create a test for passing inputs *)
			failingInputsTest = If[Length[failingInputs]>0,
				Warning["The following samples, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", will need to be aliquoted from their current containers because those containers are not compatible with available imaging instrumentation.",True,False],
				Nothing
			];

			(* Create a test for passing inputs *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", will be imaged in their current containers.",True,True],
				Nothing
			];

			(* Return created tests *)
			{passingInputsTest, failingInputsTest}

		],

		(* Don't create tests if we aren't gathering them *)
		{}
	];

	(*If there are invalidAlternateInstrumentErrors and we are throwing messages, throw an error message*)
	invalidAlternateInstrumentsOption=If[And@@invalidAlternateInstrumentErrors&&messagesQ,
		Module[{invalidInstruments},
			invalidInstruments=DeleteDuplicates@Flatten@PickList[Lookup[mapThreadFriendlyOptions,AlternateInstruments],invalidAlternateInstrumentErrors];
			Message[Error::ImageSampleInvalidAlternateInstruments,ObjectToString[invalidInstruments,Cache->simulatedCache]];
			{AlternateInstruments}
		],
		{}
	];

	(* Create tests for AlternateInstruments error *)
	invalidAlternateInstrumentsTests=If[gatherTestsQ,
		Module[
			{unresolvedAlternateInstruments,failingInputs,passingInputs,failingInputsTest,passingInputsTest},

			(* get the index matching unresolved AlternateInstruments option *)
			unresolvedAlternateInstruments=Lookup[mapThreadFriendlyOptions,AlternateInstruments];

			(* Get a list of inputs that are failing this test *)
			failingInputs=DeleteDuplicates@Flatten@PickList[unresolvedAlternateInstruments,invalidAlternateInstrumentErrors];

			(* Get the corresponding list of inputs that are passing *)
			passingInputs=DeleteDuplicates@Flatten@PickList[unresolvedAlternateInstruments,invalidAlternateInstrumentErrors,False];

			(* Create a test for passing inputs *)
			failingInputsTest=If[Length[failingInputs]>0,
				Test["The following instrument models, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", can be used as alternative instruments.",True,False],
				Nothing
			];

			(* Create a test for passing inputs *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following instrument models, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", can be used as alternative instruments.",True,True],
				Nothing
			];

			(* Return created tests *)
			{passingInputsTest,failingInputsTest}

		],

		(* Don't create tests if we aren't gathering them *)
		{}
	];


	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve TargetAliquotContainers
		Assume that for those inputs where preferredContainers was set, we've already done the hard work in choosing containers reasonably
		and have proceeded through the rest of options resolution with the first of the preferredContainers in mind *)
	targetContainers = FirstOrDefault /@ potentialAliquotContainersList;



	(* -- MESSAGE AND RETURN --*)

	(* Get the resolved Email option; for this experiment, the default is True *)
	email=If[MatchQ[Lookup[myOptions, Email], Automatic],
		True,
		Lookup[myOptions, Email]
	];

	(* Get the rest of our options directly from SafeOptions. *)
	{confirm, template, samplesInStorageCondition, cache, fastTrack, operator, parentProtocol, upload, outputOption} = Lookup[myOptions, {Confirm, Template, SamplesInStorageCondition, Cache, FastTrack, Operator, ParentProtocol, Upload, Output}];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{imagerImagingDirectionInvalidOptions, imagerIlluminationDirectionInvalidOptions, nameInvalidOptions, invalidAlternateInstrumentsOption}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTestsQ,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->updatedSimulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTestsQ,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTestsQ,
		resolveAliquotOptions[
			ExperimentImageSample,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->updatedSimulatedCache,
			Output->{Result, Tests},
			RequiredAliquotAmounts -> Null,
			RequiredAliquotContainers -> targetContainers,
			AliquotWarningMessage -> "because the given samples are not in containers that are compatible with imaging instruments.",
			AllowSolids->True
		],
		{
			resolveAliquotOptions[
				ExperimentImageSample,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->updatedSimulatedCache,
				Output->{Result},
				RequiredAliquotAmounts -> Null,
				RequiredAliquotContainers -> targetContainers,
				AliquotWarningMessage -> "because the given samples are not in containers that are compatible with imaging instruments.",
				AllowSolids->True
			],
			{}
		}
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> ReplaceRule[
			Normal[Join[imageSampleOptionsAssociation, Association@@resolvedSamplePrepOptions, Association@@resolvedAliquotOptions]],
			{
				(* ImageSample-specific options *)
				Instrument->instruments,
				AlternateInstruments->alternateInstruments,
				ImageContainer->imageContainers,
				ImagingDirection->imagingDirections,
				IlluminationDirection->illuminationDirections,
				(* General options *)
				Email->email,
				Confirm->confirm,
				Template->template,
				SamplesInStorageCondition->samplesInStorageCondition,
				Cache->cache,
				FastTrack->fastTrack,
				Operator->operator,
				ParentProtocol->parentProtocol,
				Upload->upload,
				Output->outputOption
			}
		],
		Tests -> Flatten[{discardedTest, imagerImagingDirectionTest, imagerIlluminationDirectionTest, preferredIlluminationIncompatibleTests,
			unimageableContainerTests, validNameTest, aliquotTests, invalidAlternateInstrumentsTests}]
	}
];



compatibleImagingContainers[
	samplePacket:PacketP[Object[Sample]],
	containerModelPacket:PacketP[Model[Container]],
	preferredPlatePackets:{PacketP[Model[Container, Plate]]..},
	preferredVesselPackets:{PacketP[Model[Container, Vessel]]..}
] := Module[{sampleContainer, opaqueContainerQ, opacitySortedPlates, opacitySortedVessels, typePrioritizedContainers, volumeFilteredContainers},
	(*
		General algorithm:
			- Get packets for all preferred containers
			- Within plates and vessels, order based on current container's opacity
			- Assemble full list of potential containers, ordering plates vs vessels based on the current container type (plates vs vessels)
			- Filter out containers that don't satisfy volume requirements (min/max)
			- Will take the first when resolving TargetContainer, so do the rest of resolution with this assumption
	*)

	(* Look up sample's container *)
	sampleContainer = Download[Lookup[samplePacket, Container], Object];

	(* Decide whether to consider the sample container 'Opaque'
			- For plates, WellColor==(OpaqueBlack | OpaqueWhite)
			- For vessels, Opaque==True *)
	opaqueContainerQ = Or[
		MatchQ[Lookup[containerModelPacket, WellColor], (OpaqueBlack | OpaqueWhite)],
		TrueQ[Lookup[containerModelPacket, Opaque]]
	];

	(* Within each container type, sort favoring the current container's opacity / well color *)
	opacitySortedPlates = Sort[preferredPlatePackets, MatchQ[Lookup[#, WellColor], If[opaqueContainerQ, (OpaqueBlack | OpaqueWhite), Except[(OpaqueBlack | OpaqueWhite)]]]&];
	opacitySortedVessels = Sort[preferredVesselPackets, MatchQ[Lookup[#, Opaque], If[opaqueContainerQ, True, Except[True]]]&];

	(* Favor aliquoting into the type of container the sample is already in *)
	(* TODO: May need to make an exception if user has specifically requested imaging type for which current container type is infeasible,
		e.g. sample imager but plate has been specified *)
	typePrioritizedContainers = If[MatchQ[sampleContainer, ObjectP[Object[Container, Plate]]],
		Join[opacitySortedPlates, opacitySortedVessels],
		Join[opacitySortedVessels, opacitySortedPlates]
	];

	(* If sample volume is populated, consider only containers that can accommodate the sample's volume
		Be careful to account for Null Min/MaxVolume, although in practice only MinVolume is allowed to be Null at present *)
	volumeFilteredContainers = If[VolumeQ[Lookup[samplePacket, Volume, Null]],
		Select[
			typePrioritizedContainers,
			And[
				If[!NullQ[Lookup[#, MinVolume]], Lookup[#, MinVolume] <= Lookup[samplePacket, Volume], True],
				If[!NullQ[Lookup[#, MaxVolume]], Lookup[samplePacket, Volume] <= Lookup[#, MaxVolume], True]
			]&
		],
		typePrioritizedContainers
	];

	(* Return a list of container model objects that are compatible with the provided sample, container *)
	volumeFilteredContainers[Object]
];





(* ::Subsubsection::Closed:: *)
(* imageSampleResourcePackets (private helper) *)


(* private function to generate the list of protocol packets containing resource blobs *)
imageSampleResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}]:=Module[
	{expandedInputs, expandedResolvedOptions, aliquotQ, filteredExpandedInputs, filteredExpandedOptions, expandedImagingDirections,
	expandedIlluminationDirections, imagingExpandedResolvedOptions, cache, alternateInstrumentsOption,
	resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, sampleVolumes, instrumentOpt, simulatedSamples,
	simulatedCache, incomingAndSimulatedCache, sampleFields, samplePackets, containerPackets, containerModelPackets, secondaryContainerPackets,
	secondaryContainerModelPackets, plateImagerRackModelPackets, instrumentPackets, updatedCache, safeSecondaryContainerPackets,
	sampleImageIndexes, uniqueContainerModelPacketsForSampleImaging, containerModelFocalLengthLookup, uniqueContainerModelImagingDistances,
	uniqueContainerModelImagingPedestals, containerModelImagingDistanceLookup, containerModelPedestalLookup, instrumentGrabber,

	(* Sorting and gathering of samples *)
	sampleInformationAssocs, gatherSubgroupsAndFlatten, correctSecondaryRackQ, plateImagerAssocs, sampleImagerAssocs, plateImagerTubeAssocs,
	plateImagerPlateAssocs, illuminationGatheredPlateImagerTubeAssocs, illuminationGatheredPlateImagerPlateAssocs, containerGatheredPlateImagerPlateAssocs,
	containerModelGatheredPlateImagerTubeAssocs, rackModelGatheredPlateImagerTubeAssocs,partitionedGatheredPlateImagerTubeAssocs,
	sideImagingGatheredAssocs, pedestalGatheredSampleImagerAssocs,

	(* Generation of resources *)
	pairedInstrumentsAndImagingTimes, groupedImagingTimesByInstrument, instrumentResourceLookup, uniqueRacks, rackResourceLookup,
	aliquotVolumes, pairedSamplesInAndVolumes, sampleVolumeRules,sampleResourceReplaceRules, samplesInResources, containersIn, imagingTimeEstimate,
	containerResources, plateImagerResources, sampleImagerResources,

	(* Generation of batching fields *)
	allBatchedSamplesAssocs, batchLengths, workingContainers, plateImagerPlateBatchedContainerIndexes, plateImagerTubeBatchedContainerIndexes, sampleImagerBatchedContainerIndexes,
	batchedContainerIndexes, protocolID, protocolIDString, batchedImagingParameters,

	(* Generation of packet *)
	protocolPacket, sharedFieldPacket, finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,

	imageContainerAssocs,sampleImagingAssocs
	},

	(* expand the resolved options if they weren't expanded already *)
	(* Why is 'mySamples' in an extra list here? *)
	{{expandedInputs}, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentImageSample, {mySamples}, myResolvedOptions];

	(* Very first thing, quietly exclude any samples (and their corresponding options) for which aliquoting would be necessary IF we're in a sub *)
	{filteredExpandedInputs,filteredExpandedOptions} = If[MatchQ[Lookup[expandedResolvedOptions, ParentProtocol],ObjectP[Object[]]],

		(* If we ARE in a Subprotocol, we need to filter out Solid and Discarded samples *)
		Module[
			{invalidPositions, validSamples, lengthOfInput, indexMatchedOptions, validOptions, aliquotContainerRaw, trimmedAliquotContainerOption,
			aliquotDestinationWellRaw, trimmedAliquotDestinationWellOption},

			(* Any samples that are asking to be aliquoted are invalid if we're in a sub *)
			invalidPositions = Position[Lookup[expandedResolvedOptions, Aliquot], True];

			(* Determine the valid positions *)
			validSamples = Delete[mySamples, invalidPositions];

			(* Stash the length of the input *)
			lengthOfInput = Length[mySamples];

			(* Gather the list of option names that are index matched to the input *)
			indexMatchedOptions = Select[
				OptionDefinition[ExperimentImageSample],
				MatchQ[#["IndexMatchingInput"],"experiment samples"]&
			][[All,"OptionSymbol"]];

			(* Map over the options and for any option that is index matched to the input, delete the positions that are invalid  *)
			validOptions = MapThread[
				Function[{optionName,optionVal},
					If[MatchQ[Length[optionVal],lengthOfInput],

						(* If the length of the option matches the length of the input, assume Index Matched and trim the bad values *)
						optionName->Delete[optionVal,invalidPositions],

						(* Otherwise it isn't index matched so leave it be *)
						optionName->optionVal
					]
				],
				{indexMatchedOptions,Lookup[expandedResolvedOptions,indexMatchedOptions]}
			];

			(* Must also handle AliquotContainer and DestinationWell, which are not SamplesIn-index-matched due to the potential for NumberOfReplicates *)
			aliquotContainerRaw = Lookup[expandedResolvedOptions,AliquotContainer];
			trimmedAliquotContainerOption = Delete[aliquotContainerRaw, invalidPositions];

			aliquotDestinationWellRaw = Lookup[expandedResolvedOptions,DestinationWell];
			trimmedAliquotDestinationWellOption = Delete[aliquotDestinationWellRaw, invalidPositions];

			(* Return our new samples and options *)
			{validSamples, ReplaceRule[expandedResolvedOptions, Join[validOptions, {AliquotContainer->trimmedAliquotContainerOption, DestinationWell->trimmedAliquotDestinationWellOption}]]}
		],

		(* If we're not in a sub protocol, just return the samples we're working with and the options we already expanded *)
		{expandedInputs, expandedResolvedOptions}
	];


	(* --- Further expand any ImagingDirection or IlluminationDirection options that aren't already lists --- *)
	(* Expand / list ImagingDirection option where necessary *)
	expandedImagingDirections = Map[
		Switch[#,
			(* If option is a singleton, wrap in a list *)
			ImagingDirectionP, {#},
			(* If option is a list, delete duplicates and keep as-is *)
			{ImagingDirectionP..}, DeleteDuplicates[#],
			(* If option is 'All', expand into all directions *)
			All, {Top, Side}
		]&,
		Lookup[filteredExpandedOptions, ImagingDirection]
	];

	(* Expand / list IlluminationDirection option where necessary *)
	expandedIlluminationDirections = Map[
		Switch[#,
			(* If option is a singleton, wrap in a list *)
			IlluminationDirectionP, {#},
			(* If option is a list, delete duplicates and keep as-is *)
			{IlluminationDirectionP..}, DeleteDuplicates[#],
			(* If option is 'All', expand into all directions *)
			All, {Top, Side, Bottom, Ambient}
		]&,
		Lookup[filteredExpandedOptions, IlluminationDirection]
	];

	(* Replace existing versions of ImagingDirection/IlluminationDirection with further expanded versions above *)
	imagingExpandedResolvedOptions = ReplaceRule[
		filteredExpandedOptions,
		{
			ImagingDirection -> expandedImagingDirections,
			IlluminationDirection -> expandedIlluminationDirections
		}
	];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentImageSample,
		RemoveHiddenOptions[ExperimentImageSample, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list (and also the cache) *)
	{outputSpecification, cache} = Lookup[imagingExpandedResolvedOptions, {Output, Cache}];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Instrument option; strip off links to make everything uniform moving forward *)
	instrumentOpt = Download[Lookup[imagingExpandedResolvedOptions, Instrument],Object];

	(* get the AlternateInstruments option *)
	alternateInstrumentsOption=Lookup[imagingExpandedResolvedOptions,AlternateInstruments]/.link_Link:>Download[link,Object];
	
	(* At this point, return if the filtering above has eliminated all inputs *)
	If[Length[filteredExpandedInputs] == 0, Return[outputSpecification /. {Preview->Null, Options->resolvedOptionsNoHidden, Result->$Failed, Tests->{}}]];

	(* Simulate the samples after they go through all the sample prep *)
	{simulatedSamples, simulatedCache} = simulateSamplesResourcePackets[ExperimentImageSample, filteredExpandedInputs, imagingExpandedResolvedOptions, Cache->cache];
	
	(* Make a new cache with the inherited and simulated caches *)
	incomingAndSimulatedCache = FlattenCachePackets[{Lookup[imagingExpandedResolvedOptions, Cache], simulatedCache}];

	(* Assemble a list of sample fields to be downloaded *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];

	(* make a Download call to get all relevant information we need, being sure to download from SIMULATED SAMPLES *)
	{samplePackets, containerPackets, containerModelPackets, secondaryContainerPackets, secondaryContainerModelPackets,
	plateImagerRackModelPackets, instrumentPackets} = Flatten /@ Quiet[
		Download[
			{
				Sequence@@ConstantArray[simulatedSamples, 6],
				instrumentOpt
			},
			{
				{sampleFields},
				{Packet[Container[{Model, Container, Position}]]},
				{Packet[Container[Model][{PlateImagerRack, SampleImagerRack, PreferredCamera, Dimensions, AspectRatio, NumberOfWells}]]},
				{Packet[Container[Container][{Object, Model}]]},
				{Packet[Container[Container][Model][{NumberOfPositions, Positions, AspectRatio}]]},
				{Packet[Container[Model][PlateImagerRack][{NumberOfPositions, AspectRatio}]]},
				{Packet[Object, Model]}
			},
			Cache->incomingAndSimulatedCache
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	updatedCache = FlattenCachePackets[{incomingAndSimulatedCache, samplePackets, containerPackets, containerModelPackets, secondaryContainerPackets,
		plateImagerRackModelPackets, instrumentPackets}];

	(* Make secondary container packets safe for future Lookup calls by replacing any 'Null' entries with empty lists *)
	safeSecondaryContainerPackets = Replace[secondaryContainerPackets, Null->{}, {1}];

	(* Get a list of unique container models that will be sample imaged *)
	sampleImageIndexes = Position[instrumentOpt, ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}]];
	uniqueContainerModelPacketsForSampleImaging = DeleteDuplicates[Extract[containerModelPackets, sampleImageIndexes]];


	(* For those containers that will be imaged using the sample imager, generate a lookup table for what lens focal length they require *)
	containerModelFocalLengthLookup = If[Length[uniqueContainerModelPacketsForSampleImaging]>0,

		(* Build lookup table if there are things being imaged on a sample imager *)
		Module[{sampleImagingContainerPreferredCameras, sampleImagingContainerFocalLengths},
			(* Look up preferred camera for each container model *)
			sampleImagingContainerPreferredCameras = Lookup[uniqueContainerModelPacketsForSampleImaging, PreferredCamera, {}];

			(* Convert PreferredCamera size to focal length, defaulting to:
				- Medium camera size if Null
				- Medium camera size if Overhead -- assume the container will be positioned in the middle of the imaging chamber
				- Small camera size if Plate, under the assumption that this is a small, plate-rackable tube *)
			sampleImagingContainerFocalLengths = Lookup[
				{Small -> 55 Millimeter, Medium -> 24 Millimeter, Large -> 18 Millimeter, Null -> 24 Millimeter, Plate -> 55 Millimeter, Overhead -> 24 Millimeter},
				sampleImagingContainerPreferredCameras,
				{}
			];

			(* Build lookup table *)
			AssociationThread[Lookup[uniqueContainerModelPacketsForSampleImaging, Object], sampleImagingContainerFocalLengths]
		],

		(* If there's nothing being imaged on a sample imager, no lookup table is possible / necessary *)
		<||>
	];


	(* For all unique containers to be used on the Sample Imager, figure out imaging distance and pedestal(s) to use *)
	{uniqueContainerModelImagingDistances, uniqueContainerModelImagingPedestals} = If[Length[uniqueContainerModelPacketsForSampleImaging]>0,
		Transpose[Map[
			Module[{dimensions, modelObject, focalLength},

				(* Extract dimensions and preferred camera from packet *)
				{dimensions, modelObject} = Lookup[#, {Dimensions, Object}, Null];

				(* Look up the container model's required focal length *)
				focalLength = Lookup[containerModelFocalLengthLookup, modelObject];

				(* Call helper to calculate imaging distance and pedestals to use for this container *)
				imagingDistanceAndPedestals[dimensions, focalLength]
			]&,
			uniqueContainerModelPacketsForSampleImaging
		]],
		{{},{}}
	];

	(* Build lookup tables for imaging distances and pedestals for each unique container model going onto the sample imager *)
	containerModelImagingDistanceLookup = AssociationThread[Lookup[uniqueContainerModelPacketsForSampleImaging, Object, {}], uniqueContainerModelImagingDistances];
	containerModelPedestalLookup = AssociationThread[Lookup[uniqueContainerModelPacketsForSampleImaging, Object, {}], uniqueContainerModelImagingPedestals];


	(* Assemble packets of sample information into temporary associations for sorting within this function.
		Include only information here that is a) required for sorting, or b) is from options and will become difficult to look up after sorting
		These associations have the following keys:
			- Sample -> Sample object reference
			- Container -> Sample container object reference
			- ContainerModel -> Sample container model object reference
			- SecondaryContainerModel -> Model of sample's container's container (if any)
			- Instrument -> Imaging instrument object reference
			- PlateImagerRack -> Rack object required for imaging in plate imager (if applicable)
			- SampleImagerRack -> Rack object required for imaging in sample imager (if applicable)
			- ImagingDirection -> Imaging direction from options
			- IlluminationDirection -> Illumination direction from options
			- Distance -> Imaging distance for sample imager samples
			- Pedestals -> Pedestals to be used for sample imager samples
	*)
	sampleInformationAssocs = MapThread[
		Association[
			Sample->#1,
			Container->#2,
			ContainerModel->#3,
			SecondaryContainer->#4,
			SecondaryContainerModel->#5,
			PlateImagerRack->#6,
			SampleImagerRack->#7,
			Instrument->#8,
			AlternateInstruments->#9,
			ImageContainer -> #10,
			ImagingDirection->#11,
			IlluminationDirection->#12,
			Distance -> #13,
			Pedestals -> #14
		]&,
		{
			(*1*)Lookup[samplePackets, Object],
			(*2*)Download[Lookup[samplePackets, Container, Null], Object],
			(*3*)Download[Lookup[containerPackets, Model, Null], Object],
			(*4*)Lookup[safeSecondaryContainerPackets, Object, Null],
			(*5*)Download[Lookup[safeSecondaryContainerPackets, Model, Null], Object],
			(*6*)Download[Lookup[containerModelPackets, PlateImagerRack], Object],
			(*7*)Download[Lookup[containerModelPackets, SampleImagerRack], Object],
			(*8*)Lookup[instrumentPackets, Object],
			(*9*)alternateInstrumentsOption,
			(*10*)Lookup[imagingExpandedResolvedOptions, ImageContainer],
			(*11*)Lookup[imagingExpandedResolvedOptions, ImagingDirection],
			(*12*)Lookup[imagingExpandedResolvedOptions, IlluminationDirection],
			(*13*)Lookup[containerModelImagingDistanceLookup, Lookup[containerModelPackets, Object], Null],
			(*14*)Lookup[containerModelPedestalLookup, Lookup[containerModelPackets, Object], Null]
		}
	];


	(* --- Group input samples for batching --- *)
	(* Set up an internal helper to gather each group in an already-gathered list, then flatten to level one to prepare for future gathering operations *)
	gatherSubgroupsAndFlatten[subgroupedList:{_List...}, gatheringFunction_Function] := Flatten[
		Map[
			Function[sampleGroup,
				GatherBy[sampleGroup, gatheringFunction]
			],
			subgroupedList
		],
		1
	];

	(* Set up an internal helper to figure out whether a given sample association represents a sample that is already in the correct secondary rack *)
	correctSecondaryRackQ[sampleAssoc_Association] := SameQ[Lookup[sampleAssoc, SecondaryContainerModel], Lookup[sampleAssoc, PlateImagerRack]];

	(* Initial partition: Split samples that use plate imager instrument model from those that use sample imager instrument model *)
	(* This section assumes that PlateImager and SampleImager are the only two possibilities *)
	plateImagerAssocs = Cases[sampleInformationAssocs, KeyValuePattern[Instrument->ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]]];
	sampleImagerAssocs = Cases[sampleInformationAssocs, KeyValuePattern[Instrument->ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}]]];

	(* === Handle plate imager samples === *)

	(* Plate imager partition: Split samples in plates from samples in tubes *)
	(* This section assumes that Vessel and Plate are the only two possibilities for direct sample containers *)
	plateImagerTubeAssocs = Cases[plateImagerAssocs, KeyValuePattern[Container->ObjectP[Object[Container, Vessel]]]];
	plateImagerPlateAssocs = Cases[plateImagerAssocs, KeyValuePattern[Container->ObjectP[Object[Container, Plate]]]];


	(* --- Gather plate imager samples in plates --- *)
	(* TODO: May need to gather by actual instrument as well to future-proof
		Although we currently only have one of each, specifying a particular sample imager or plate imager should be
		treated differently from specifying a model and containers should be partitioned accordingly *)

	(* Gather all samples with the same IlluminationDirection option *)
	illuminationGatheredPlateImagerPlateAssocs = GatherBy[plateImagerPlateAssocs, Lookup[#, {Instrument, AlternateInstruments, IlluminationDirection}]&];

	(* (Gathering endpoint of this set) Within the above gathered groups, gather all samples that are in the same physical plates *)
	(* This will properly handle cases where a sample is specified repeatedly for imaging with multiple different lighting conditions *)
	(* This may fail if a sample is specified repeatedly for imaging with the SAME lighting conditions *)
	containerGatheredPlateImagerPlateAssocs = gatherSubgroupsAndFlatten[illuminationGatheredPlateImagerPlateAssocs, Lookup[#, Container]&];


	(* --- Gather plate imager samples in tubes --- *)
	(* Gather all samples with the same IlluminationDirection option *)
	illuminationGatheredPlateImagerTubeAssocs = GatherBy[plateImagerTubeAssocs, Lookup[#, IlluminationDirection]&];

	(* Gather samples in tubes based on tube rack model; all tubes to be imaged on plate imager should have a tube rack model *)
	rackModelGatheredPlateImagerTubeAssocs = gatherSubgroupsAndFlatten[illuminationGatheredPlateImagerTubeAssocs, Lookup[#, PlateImagerRack]&];

	(* (Gathering endpoint of this set) Further split groups based on which tubers are already in a rack of the desired model *)
	partitionedGatheredPlateImagerTubeAssocs = Flatten[
		Map[
			Function[currentGroup,
				Module[{secondaryRackModelPacket, numberOfPositions, alreadyInRightRack, notYetInRightRack, gatheredInRightRack, unrackedPartitioned},

					(* Look up the number of positions in the required secondary rack *)
					secondaryRackModelPacket = fetchPacketFromCacheImageSample[Lookup[First[currentGroup], PlateImagerRack], updatedCache];
					numberOfPositions = Lookup[secondaryRackModelPacket, NumberOfPositions];

					(* Select out samples that are already in the right secondary rack *)
					alreadyInRightRack = Select[currentGroup, correctSecondaryRackQ];

					(* Get a list of the remainder that are not yet in the right rack *)
					notYetInRightRack = Complement[currentGroup, alreadyInRightRack];

					(* For those that are in the right rack, separate by their actual container *)
					gatheredInRightRack = GatherBy[alreadyInRightRack, Lookup[#, SecondaryContainer]&];

					(* TODO: May want to then sort those gathered in the right rack by their position to get into ideal imaging order *)

					(* For those that are not in the right rack, partition into groups that will fit into the required secondary container *)
					unrackedPartitioned = PartitionRemainder[notYetInRightRack, numberOfPositions];

					(* Return a joined list of partitioned secondarily-racked and -unracked samples *)
					Join[gatheredInRightRack, unrackedPartitioned]

				]
			],
			rackModelGatheredPlateImagerTubeAssocs
		],
		1
	];

	(* --- Sample imager sorting: Just get containers into an order that will optimize for operational efficiency --- *)
	(* Once backlight is installed, all necessary images in all lighting conditions should be able to be taken sequentially and automatically
		without operator intervention.
		First, sort so that items with like pedestal requirements are adjacent to minimize pedestal movement.
		Next, sort so all samples that will be side imaged come first (must be last sort operation!). *)

	(* Sort based on pedestals needed
		Wrap a list around each sample before beginning because each usage of the sample imager is assumed to operate on a single sample in a single container *)
	pedestalGatheredSampleImagerAssocs = gatherSubgroupsAndFlatten[List/@sampleImagerAssocs, Lookup[#, Pedestals]&];

	(* Sort based on imaging direction so all imagings that will take side images happen before any imagings that do not take side images *)
	(*NOTE: THIS IS REQUIRED FOR IMAGE FILE NUMBERING TO COME OUT RIGHT!
		OTHERWISE, ITEMS THAT ONLY GET TOP IMAGED WILL PUSH SEQUENTIAL NUMBERING DONE BY CAMERA SOFTWARE OUT OF REGISTER! *)
	sideImagingGatheredAssocs = SortBy[
		pedestalGatheredSampleImagerAssocs,
		(* Sort groups that include 'Side' to the front so they get done first
			Counterintiutively, this ordering requires a sort function that matches items that DON'T include 'Side' in imaging direction *)
		 !MemberQ[Lookup[First[#], ImagingDirection], Side]&
	];


	(* Generate a list of lists of sample associations
		Inner lists of associations correspond to imaging batches *)
	allBatchedSamplesAssocs = Join[containerGatheredPlateImagerPlateAssocs, partitionedGatheredPlateImagerTubeAssocs, sideImagingGatheredAssocs];


	(* === Generate instrument, rack, and sample resources === *)

	(* create a local helper function to get instrument from our gathered associations *)
	instrumentGrabber[gatheredAssoc:{_Association..}]:=Module[{instrument},

		instrument=Lookup[First[gatheredAssoc],Instrument];

		If[MatchQ[instrument,ObjectP[Object[Instrument]]],
			instrument,
			Flatten[{instrument,Lookup[First[gatheredAssoc],AlternateInstruments]}]/.Null->Nothing
		]
	];

	(* --- Instrument resources --- *)
	(* For each batch, estimate total setup and run time
		This does not include one-time inital instrument setup and final teardown, which is accounted for when making resources below *)
	pairedInstrumentsAndImagingTimes=Join[
		(* ~10 seconds per sample for each plate imager plate sample, plus 5 minutes of setup per plate *)
		{instrumentGrabber[#],(5 Minute+10 Second*Length[#])}&/@containerGatheredPlateImagerPlateAssocs,

		(* ~10 seconds per sample for each plate imager tube sample, plus 5 minutes of setup, plus 30 seconds for each placement if needed *)
		{instrumentGrabber[#],(5 Minute+10 Second*Length[#]+If[correctSecondaryRackQ[First[#]],0 Second,30 Second*Length[#]])}&/@partitionedGatheredPlateImagerTubeAssocs,

		(* 90 seconds per sample for sample imager *)
		{instrumentGrabber[#],90 Second}&/@sideImagingGatheredAssocs
	];

	(* Group the above estimates by unique instrument *)
	groupedImagingTimesByInstrument = GroupBy[pairedInstrumentsAndImagingTimes, First->Last, Total];

	(* Generate a resource for each unique instrument and create a lookup of instrument model/object -> instrument resource *)
	instrumentResourceLookup = KeyValueMap[
		(* Add 10 minutes for setup / teardown of each instrument *)
		(Hold[#1] -> Resource[Instrument->#1, Time->#2 + 10 Minute, Name->ToString[Unique[]]])&,
		groupedImagingTimesByInstrument
	];
	
	(* --- Rack resources --- *)
	(* Find unique racks that will be needed, excluding the rack for tubes that are already in an appropriate rack *)
	uniqueRacks = DeleteDuplicates[Join[
		(* Currently no situation where plates require additional racks, so exclude plates from this section *)
		(* Find rack model that will be needed for each set of tubes; tubes being plate imaged will always require a secondary rack
			Exclude cases where samples are already in a rack of the correct model *)
		If[correctSecondaryRackQ[First[#]], Nothing, Lookup[First[#], PlateImagerRack]]& /@ partitionedGatheredPlateImagerTubeAssocs,
		(* Find rack model that will be needed for each sample imaging; do nothing if no secondary rack is required 
			Use ObjectQ to decide whether a sample imager rack is needed; SampleImagerRack may be either Null or $Failed in cases where one isn't needed *)
		If[!ObjectQ[Lookup[First[#], SampleImagerRack]], Nothing, Lookup[First[#], SampleImagerRack]]& /@ sideImagingGatheredAssocs
	]];

	(* Generate a resource for each unique rack and create a lookup of rack model -> rack resource *)
	(* We can safely generate only a single resource for each rack model, because only one rack-requiring set of tubes (plate imager)
		or tube (sample imager) will ever be imaged at a time *)
	rackResourceLookup = Association@@Map[#->Resource[Sample->#, Name->ToString[Unique[]], Rent->True]&, uniqueRacks];

	(* --- SamplesIn resources --- *)

	(* Determine whether we are aliquoting *)
	aliquotQ = TrueQ[#]& /@ Lookup[imagingExpandedResolvedOptions, Aliquot];

	(* Pull aliquot volumes from expanded options *)
	aliquotVolumes = Lookup[imagingExpandedResolvedOptions, AliquotAmount];

	(* get the sample volumes we need to reserve with each sample, accounting for whether we're aliquoting *)
	sampleVolumes = MapThread[
		Function[{aliquot, volume},
			(* Specify volume if aliquoting a given sample, don't if not *)
			If[aliquot, volume, Null]
		],
		{aliquotQ, aliquotVolumes}
	];

	(* Make rules correlating the volumes with each sample in (filtered to eliminate those that cannot be imaged, if in a subprotocol) *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {Download[simulatedSamples, Object], sampleVolumes}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
			]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[Download[simulatedSamples, Object], sampleResourceReplaceRules, {1}];


	(* === Build batching field entries for each group of samples === *)

	(* --- Build BatchLengths field --- *)
	batchLengths = Join[
		ConstantArray[1, Length[containerGatheredPlateImagerPlateAssocs]],
		Length /@ partitionedGatheredPlateImagerTubeAssocs,
		ConstantArray[1, Length[sideImagingGatheredAssocs]]
	];

	(* --- Build BatchedContainerIndexes --- *)
	(* Do this separately for the three distinct container types because tubes to be imaged on the plate imager require special treatment *)

	(* Get a duplicate-free list of working containers in their post-aliquoting (if any) order *)
	workingContainers = Lookup[DeleteDuplicates[containerPackets], Object];

	(* Convert plate associations to BatchedContainers entries; each group of samples becomes a single entry in BatchedContainers *)
	plateImagerPlateBatchedContainerIndexes = Flatten[FirstPosition[workingContainers, Lookup[First[#], Container]]& /@ containerGatheredPlateImagerPlateAssocs];

	(* Convert plate imager tube associations to BatchedContainers entries; each group of samples in tubes becomes a single entry in BatchedContainers *)
	plateImagerTubeBatchedContainerIndexes = Flatten[Map[
		Function[tubeGroup,
			FirstPosition[workingContainers, #]& /@ Lookup[tubeGroup, Container]
		],
		partitionedGatheredPlateImagerTubeAssocs
	]];

	(* Convert sample imager associations to BatchedContainers entries; each sample becomes a single entry in BatchedContainers *)
	sampleImagerBatchedContainerIndexes = Flatten[FirstPosition[workingContainers, Lookup[First[#], Container]]& /@ sideImagingGatheredAssocs];

	(* Gather batched container indexes from all containers *)
	batchedContainerIndexes = Join[plateImagerPlateBatchedContainerIndexes, plateImagerTubeBatchedContainerIndexes, sampleImagerBatchedContainerIndexes];

	(* --- Build BatchedImagingParameters --- *)

	(* Create protocol ID now so we can use it to create image file prefixes *)
	protocolID = CreateID[Object[Protocol, ImageSample]];

	(* Convert protocol ID into file path-friendly string; use FastTrack to avoid database member checks since this protocol hasn't been created yet *)
	protocolIDString = ObjectToFilePath[protocolID, FastTrack->True];

	(* Extract imaging parameters from plate sample associations and assemble into BatchedImagingParameters *)
	batchedImagingParameters = MapIndexed[
		Function[{sampleGroup, batchNumber},
			Module[{bareBatchNumber, firstSample,imageContainer, imagingType, secondaryRack, imageFilePrefix, runTime, wells, fieldOfView, exposureTime, focalLength},

				(* Strip useless outer list off of batchNumber *)
				bareBatchNumber = First[batchNumber];

				(* Since all imaging parameters are shared by all samples in the group, use the first sample as a representative of the rest *)
				firstSample = First[sampleGroup];

				(* get the ImageContainer boolean *)
				imageContainer = Lookup[firstSample, ImageContainer];

				(* Figure out which case this container group belongs to: Plate, plate imager tube (Rack) or sample imager (Sample) *)
				imagingType = Switch[Lookup[firstSample, {Instrument, ContainerModel}],
					{ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}], ObjectP[Model[Container, Plate]]}, Plate,
					{ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}], ObjectP[Model[Container, Vessel]]}, Rack,
					{ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}], _}, Sample
				];

				(* Decide what secondary imaging rack should be used, if any *)
				secondaryRack = Switch[imagingType,

					(* No secondary rack needed for plates *)
					Plate, Null,

					(* If tubes are already in the correct secondary rack, just link to that rack. Otherwise, look up the resource for the required rack. *)
					(* TODO: Should the known (sticky) tube rack be a resource rather than a straight object? *)
					Rack,
						If[correctSecondaryRackQ[firstSample],
							Lookup[firstSample, SecondaryContainer],
							Lookup[rackResourceLookup, Lookup[firstSample, PlateImagerRack]]
						],

					(* Look up the resource for the required sample imager rack, if any. Default to Null if no rack required. *)
					Sample, Lookup[rackResourceLookup, Lookup[firstSample, SampleImagerRack], Null]
				];

				(* Generate image file prefix *)
				imageFilePrefix = If[MatchQ[imagingType, (Plate | Rack)],
					(* For plate imager, append batch number to object ID *)
					StringJoin[protocolIDString, "_plateimager_", ToString[bareBatchNumber]],
					(* For sample imager, all images will be in one big group with auto-incremented indexes *)
					StringJoin[protocolIDString, "_sampleimager"]
				];

				(* Estimate 8 Seconds per sample in imaging time for plate imager samples; N/A for sample imager *)
				runTime = Switch[imagingType,
					(Plate|Rack), 8 Second * Length[sampleGroup],
					Sample, Null
				];

				(* Figure out what wells samples will occupy (and thus what wells will be imaged) *)
				wells = Switch[imagingType,

					(* For plates, look up samples' positions and sort to minimize imaging time *)
					Plate,
						Module[{sampleGroupPackets, samplePositions, plateModelPacket, aspectRatio, numberOfWells},

							(* Fetch sample packets *)
							sampleGroupPackets = fetchPacketFromCacheImageSample[#, updatedCache]& /@ Lookup[sampleGroup, Sample];

							(* Pull Position field from each *)
							samplePositions = Lookup[sampleGroupPackets, Position];

							(* Fetch plate model's packet from cache *)
							plateModelPacket = fetchPacketFromCacheImageSample[Lookup[firstSample, ContainerModel], updatedCache];

							(* Pull aspect ratio and number of Wells from plate model *)
							{aspectRatio, numberOfWells} = Lookup[plateModelPacket, {AspectRatio, NumberOfWells}];

							sortSerpentine[samplePositions, aspectRatio, numberOfWells]
						],

					(* For tubes, either look up container position if already in correct secondary rack or generate tube placements if not *)
					Rack,
						Module[{containerPackets, containerPositions, rackModelPacket, aspectRatio, numberOfPositions},

							(* Fetch sample container packets *)
							containerPackets = fetchPacketFromCacheImageSample[#, updatedCache]& /@ Lookup[sampleGroup, Container];

							(* Pull Position field from each (will only use if containers happen to already be in desired secondary rack) *)
							containerPositions = Lookup[containerPackets, Position];

							(* Fetch rack model's packet from cache *)
							rackModelPacket = fetchPacketFromCacheImageSample[Lookup[firstSample, PlateImagerRack], updatedCache];

							(* Pull Rows and Positions from rack model *)
							{aspectRatio, numberOfPositions} = Lookup[rackModelPacket, {AspectRatio, NumberOfPositions}];

							(* Use existing positions or populate new positions depending on whether tubes are already in the right rack
								If the first sample is in the correct rack, all will be (based on gathering above) *)
							If[correctSecondaryRackQ[firstSample],

								(* If already in the correct rack, just sort the positions occupied by existing samples into optimal imaging order *)
								sortSerpentine[containerPositions, aspectRatio, numberOfPositions],

								(* If not yet in the correct rack, generate a list of sorted positions of appropriate length for the number of tubes *)
								Take[
									sortSerpentine[
										Flatten[AllWells[AspectRatio->Rationalize[aspectRatio], NumberOfWells->numberOfPositions]],
										aspectRatio,
										numberOfPositions
									],
									Length[sampleGroup]
								]
							]
						],

					(* No well specification necessary for sample imager *)
					Sample, Null
				];

				(* Calculate field of view if applicable *)
				fieldOfView = Switch[imagingType,

					(* If imaging plate or tube in plate imager, decide on field of view depending on whether we're imaging a 96-well plate *)
					(Plate|Rack),
						Module[{parentContainerModel, containerModelPacket, numberOfWells},

							(* Figure out what the "parent" container is (plate if imaging plate, rack if imaging tubes *)
							parentContainerModel = If[!MatchQ[Lookup[firstSample, PlateImagerRack], Null|$Failed],
								Lookup[firstSample, PlateImagerRack],
								Lookup[firstSample, ContainerModel]
							];

							(* Fetch container model packet *)
							containerModelPacket = fetchPacketFromCacheImageSample[parentContainerModel, updatedCache];

							(* Pull out NumberOfWells / NumberOfPositions (the former if a plate, the latter if a rack) *)
							numberOfWells = If[!MatchQ[Lookup[containerModelPacket, NumberOfWells, Null], Null|$Failed],
								Lookup[containerModelPacket, NumberOfWells],
								Lookup[containerModelPacket, NumberOfPositions]
							];

							(* If parent container has 96 wells, image using the super-zoomed-in camera; otherwise, use the more zoomed-out camera *)
							Switch[numberOfWells,
								GreaterEqualP[96], 22 Millimeter,
								_, 35 Millimeter
							]
						],

					(* If imaging on sample imager, FieldOfView does not apply *)
					Sample, Null
				];

				(* Figure out exposure time *)
				exposureTime = Switch[imagingType,
					(Plate|Rack), 16 Millisecond,
					Sample,
						Switch[Lookup[firstSample, IlluminationDirection],
							{Ambient}, 500 Millisecond,
							{Top}, 25 Millisecond,
							{Bottom}, 50 Millisecond,
							{Side}, 33 Millisecond,
							(* If multiple illumination directions have been specified, just do a short exposure by default *)
							(* TODO: Make this more scientific *)
							_?(Count[#, (Top|Bottom|Side)] > 1&), 10 Millisecond
						]
				];

				(* Figure out focal length *)
				focalLength = Switch[imagingType,
					(* Focal length isn't a parameter that is tracked / varied for the plate imager *)
					(Plate|Rack), Null,
					(* For sample imager, look up focal length based on the container model lookup table generated above *)
					Sample, Lookup[containerModelFocalLengthLookup, Lookup[firstSample, ContainerModel]]
				];

				(* Build the BatchedImagingParameters entry *)
				<|
					Imager -> Link[Lookup[instrumentResourceLookup, Hold[Evaluate@instrumentGrabber[sampleGroup]]]],
					ImageContainer -> imageContainer,
					ImagingDirection -> Lookup[firstSample, ImagingDirection],
					IlluminationDirection -> Lookup[firstSample, IlluminationDirection],
					SecondaryRack -> Link[secondaryRack],
					ImageFilePrefix -> imageFilePrefix,
					BatchNumber -> bareBatchNumber,
					(* Plate imager specific *)
					Wells -> wells,
					PlateMethodFileName -> Null, (* Populate in compiler; don't necessarily know imager path yet *)
					RunTime -> runTime,
					FieldOfView -> fieldOfView,
					(* Sample imager specific *)
					ImagingDistance -> Lookup[firstSample, Distance],
					Pedestals -> Lookup[firstSample, Pedestals],
					ExposureTime -> exposureTime,
					FocalLength -> focalLength
				|>
			]
		],
		allBatchedSamplesAssocs
	];

	(* Estimate imaging time -- total up instrument resource time estimates, which include set-up and tear-down *)
	imagingTimeEstimate = Total[#[Time]& /@ Values[instrumentResourceLookup]];

	(* Generate duplicate-free lists of containers and instrument resources for the protocol packet *)
	containersIn = DeleteDuplicates[Lookup[containerPackets, Object]];
	containerResources = Resource[Sample->#]& /@ containersIn;

	plateImagerResources = Select[Values[instrumentResourceLookup], MatchQ[#[Instrument], ListableP@ObjectP[{Model[Instrument, PlateImager], Object[Instrument, PlateImager]}]]&];
	sampleImagerResources = Select[Values[instrumentResourceLookup], MatchQ[#[Instrument], ListableP@ObjectP[{Model[Instrument, SampleImager], Object[Instrument, SampleImager]}]]&];


	(* === Generate protocol packet === *)

	(* fill in the protocol packet with all the resources *)
	protocolPacket = <|
		Object -> protocolID,
		Name -> Lookup[imagingExpandedResolvedOptions, Name],
		Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden, (* NOTE: This will not include final expansion of imaging/illum directions *)
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ containerResources),
		Replace[Checkpoints]->{
			{"Picking Resources", 1 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->1 Minute]]},
			{"Imaging Samples", imagingTimeEstimate,"Images of the samples are taken.", Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->imagingTimeEstimate]]},
			{"Returning Materials", 5 Minute, "Samples are returned to storage.", Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->5Minute]]},
			{"Parsing Data", 5 Minute, "The database is updated to include the new sample images.", Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->5Minute]]}
		},

		(* Pipe experiment-specific resolved options in *)
		Replace[PlateImagerInstruments] -> Link/@plateImagerResources,
		Replace[SampleImagerInstruments] -> Link/@sampleImagerResources,
		Replace[ImageContainers] -> Lookup[batchedImagingParameters, ImageContainer],(* Needs to be index matched to containers *)
		Replace[ImagingDirections] -> Lookup[imagingExpandedResolvedOptions, ImagingDirection],
		Replace[IlluminationDirections]->Lookup[imagingExpandedResolvedOptions, IlluminationDirection],

		(* Batching fields *)
		(* BatchedContainers, TubeRackPlacements, and DeckPlacements will get populated at compile time *)
		Replace[BatchedImagingParameters] -> (KeyDrop[#,ImageContainer]&/@batchedImagingParameters),
		Replace[BatchedImagingParametersNew] -> batchedImagingParameters,
		Replace[BatchLengths] -> batchLengths,
		Replace[BatchedContainerIndexes] -> batchedContainerIndexes,
		Replace[SamplesInStorage] -> Lookup[imagingExpandedResolvedOptions, SamplesInStorageCondition]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[simulatedSamples, imagingExpandedResolvedOptions,Cache->updatedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource SymReps" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication,Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->updatedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages,Cache->updatedCache], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* Correlating images to sample objects (to be done in parser):

	Plate imager
		Plates:
			- Wells field in BatchedImagingParameters tells what wells were imaged and in what order
			- Plate contents tells what was there

		Tubes in rack:
			- Wells field in BatchedImagingParameters tells what wells were imaged and in what order
			- TubeRackPlacements for that batch index tells what tube was placed in what position
			- Tube contents tell what sample was in each tube

	Sample imager
		Tubes:
			- Image indexes correspond to BatchNumber, so start at whatever batch number is the first to use sample imager
			NOTE: Imager does a silly thing and increments even on the FIRST image, so these numbers are off by one (image index is batch number + 1)

	*)


(* ::Subsubsection::Closed:: *)
(*imagingDistanceAndPedestals*)


(* Based on a set of container dimensions and a focal length, determines a suitable imaging distance and pedestals to use
	Input:
		- containerDimensions: {x,y,z} dimensions of container being imaged
		- focalLength: Focal length of the lens being used to image the container
	Output:
		- List of {imaging distance, sizes of pedestals to use}

	Coordinate system: Code and comments below make reference to containers and distances in terms of height/width/depth and x/y/z.
		These terms assume a relative coordinate system in which:
		 	-'x' or 'width' refers to the left-right axis when viewing the imager from the front;
			-'y' or 'depth' refers to the front-back axis when viewing the imager from the front;
			-'z' or 'height' refers to the top-bottom axis when viewing the imager from the front
*)

imagingDistanceAndPedestals[containerDimensions_, focalLength:DistanceP] := Module[
	{lensHeight, containerHeight, containerDepth, containerWidth, availablePedestalHeights, availablePedestalCombinations, distancesFromCenter, bestDistanceFromCenter, bestCombination,
	verticalFOV, horizontalFOV, verticalFOVPadded, horizontalFOVPadded, minDistanceForVerticalFOV, minDistanceForHorizontalFOV, sensorWidth, sensorHeight, distFormula, minImagingDistanceToContainerFront,
	minImagingDistanceToContainerCenter, verticalAngleOfView, horizontalAngleOfView, bestCombinationEnumerated, lensMinimumFocusDistance},

	(* Define the height of the center of the camera lens above the floor of the sample imager *)
	lensHeight = 273 Millimeter;

	(* Define the minimum distance from the rear of the camera lens for an item to be in focus
	 	This parameter is normally the X distance from the image sensor, but here it is referenced to the approximate
			rear of the camera lens to match the focal distances calculated below *)
	lensMinimumFocusDistance = 187 Millimeter;

	(* Dimensions of the camera's image sensor are required to calculate FOV
		Dimensions are w.r.t. the camera's orientation in the imaging station (rotated 90 degrees to take portrait-oriented images)
		TODO: move these values to the Model[Instrument, SampleImager] *)
	sensorWidth = 14.9 Millimeter;
	sensorHeight = 22.3 Millimeter;

	(* Extract height of container *)
	containerHeight = Last[containerDimensions];

	(* Size of side of container that will be facing the camera (Y axis); assume the "worst" and face the broadest side towards the camera
		We'll assume the operator won't place a rectangular container diagonally w.r.t. the camera like some kind of maniac. *)
	containerDepth = Max[containerDimensions[[;;2]]];

	(* Size of the side of the container that will be facing the front of the imaging station (X axis); same assumption as above *)
	containerWidth = Min[containerDimensions[[;;2]]];

	(* Heights of pedestals available for propping up containers being imaged *)
	availablePedestalHeights = {2 Inch, 4 Inch, 6 Inch};

	(* Generate a list of all possible pedestal combinations, including no pedestal (0 Inch) *)
	availablePedestalCombinations = Append[Subsets[availablePedestalHeights, {1,3}], {0 Inch}];

	(* For each pedestal combination, calculate the height difference between the container's vertical center and the vertical center of the lens
		Could optimize by sorting pedestal combinations by total height and short-circuiting after we pass over the zero-offset point,
		 	but there are few enough combinations here that this optimization isn't necessary. *)
	distancesFromCenter = Abs[lensHeight - (Total[#] + containerHeight/2)]& /@ availablePedestalCombinations;

	(* Pick the smallest offset between object center and lens center
	 	This may place the Z center of the container either slightly below or slightly above the Z center of the lens*)
	bestDistanceFromCenter = Min[distancesFromCenter];

	(* Retrieve the combination of pedestals that yielded the smallest offset *)
	bestCombination = availablePedestalCombinations[[First[FirstPosition[distancesFromCenter, bestDistanceFromCenter]]]];

	(* Convert the pedestal heights into Small/Medium/Large combo enumerations that are easy for Engine to convert into operator instructions *)
	(* TODO: Possibly convert pedestals to actual objects and use deck placement to get them into place.
	 	The downside of this will be a decrease in operational efficiency as scanning increases. *)
	bestCombinationEnumerated = Switch[bestCombination,
		{0 Inch}, None,
		{2 Inch}, Small,
		{4 Inch}, Medium,
		{6 Inch}, Large,
		_?(ContainsExactly[#, {2 Inch, 4 Inch}]&), SmallAndMedium,
		_?(ContainsExactly[#, {2 Inch, 6 Inch}]&), SmallAndLarge,
		_?(ContainsExactly[#, {4 Inch, 6 Inch}]&), MediumAndLarge
	];


	(* === To decide how far from the camera to place the container, figure out container cross section presented to the camera that we must keep in frame === *)

	(* For the vertical direction this would just be the container height if we could rely on the container being centered about the vertical center of the lens.
		However, since the container may not be centered about the center of the lens (pedestals don't provide infinite adjustability), we must expand the vertical
		FOV by the offset in BOTH directions (i.e. add 2*offset to the container height) to make sure the container stays in frame. We must add to both directions
		evenly because we can't move the camera -- all we can do is zoom out and increase FOV symmetrically on both the top and bottom.
		In addition to the above, add 10% buffer to the container size to ensure that slight misplacements don't pull the container out of frame. *)
	verticalFOV = 1.1*(containerHeight + 2*bestDistanceFromCenter);

	(* Horizontal FOV is simple -- we can assume the container is centered about the horizontal center of the lens so it is just the container width from the camera's perspective.
		In addition to the above, add 10% buffer to the container size to ensure that slight misplacements don't pull the container out of frame. *)
	horizontalFOV = 1.1*containerDepth;


	(* === Calculate the minimum X distance the container must be from the camera to remain in-frame in each dimension === *)

	(* The equation below was derived from equations for a camera's Angle of View and Field of View:
		AOV = 2*ArcTan[sensorDimension/(2*focalLength)]
		FOV = 2*Tan[AOV/2]*distance
		Where:
			sensorDimension = size of camera sensor along the same axis as the linear FOV being calculated
			focalLength = focal length of lens
			distance = distance from object to back of lens *)
	minDistanceForVerticalFOV = (focalLength * verticalFOV) / sensorHeight;
	minDistanceForHorizontalFOV = (focalLength * horizontalFOV) / sensorWidth;

	(* Choose the _LARGEST_ of the following to ensure that the full container is in focus and in frame in both the Y and Z directions:
		- Lens minimum focus distance (corrected to take container width into account as below)
		- Minimum distance for full vertical FOV
		- Minimum distance for full horizontal FOV *)
	minImagingDistanceToContainerFront = Max[lensMinimumFocusDistance, minDistanceForVerticalFOV, minDistanceForHorizontalFOV];

	(* Since we'll be imaging on pedestals of varying sizes (and sometimes with no pedestal at all), the best consistent reference point is
		the container's X midpoint. We want the FRONT of the container rather than the MIDPOINT of the container at the distance calculated above,
			so we must add half of the container width (X direction) to the calculated distance from the lens to accomplish this.
		Round the resulting distance to the next larger quarter-inch increment to keep from asking operators to place things too precisely *)
	minImagingDistanceToContainerCenter = Ceiling[Convert[minImagingDistanceToContainerFront + 0.5*containerWidth, Centimeter], 0.5 Centimeter];

	(* Return the minimum distance from which the container can be imaged and the combination of pedestals that should be used to image it *)
	{minImagingDistanceToContainerCenter, bestCombinationEnumerated}

];


(* ::Subsubsection::Closed:: *)
(*sortSerpentine *)

ECL`Authors[sortSerpentine]:={"ben"};

(* helper to sort positions given plate/rack aspect ratio and number of wells *)
(* Can coexist with the old version in ImageSample compile file due to different input patterns *)
sortSerpentine[positions:{WellPositionP..},myAspectRatio:GreaterP[0],myPositionNumber:GreaterP[0,1]]:=Module[
	{aspectRatioRational,serpentineIndexes,serpentinePositions},

	(* get the aspect Ratio of the plate or rack *)
	aspectRatioRational=Rationalize[myAspectRatio];

	(* sort those positions in serpentine order,this returns indexes *)
	serpentineIndexes=ConvertWell[
		positions,
		AspectRatio->aspectRatioRational,
		NumberOfWells->myPositionNumber,
		InputFormat->Position,
		OutputFormat->SerpentineIndex
	];

	(* convert the index back to positions after Sorting *)
	(* need to map to distinguish case where a list of two separate indices could be interpreted as an ordered pair *)
	serpentinePositions = ConvertWell[
		Sort[serpentineIndexes],
		AspectRatio->aspectRatioRational,
		NumberOfWells->myPositionNumber,
		InputFormat->SerpentineIndex,
		OutputFormat->Position
	]

];


(* ::Subsubsection::Closed:: *)
(* fetchPacketFromCacheImageSample *)


fetchPacketFromCacheImageSample[Null,_]:=Null;
fetchPacketFromCacheImageSample[myObject:ObjectP[],myCachedPackets_List]:=FirstCase[myCachedPackets,KeyValuePattern[{Object->Download[myObject,Object]}]];


(* ::Subsubsection::Closed:: *)
(* fetchModelPacketFromCacheHPLC *)


fetchModelPacketFromCacheImageSample[Null,_]:=Null;
fetchModelPacketFromCacheImageSample[myObject:ObjectP[Object],myCachedPackets_List]:=fetchPacketFromCacheImageSample[Download[Lookup[fetchPacketFromCacheImageSample[myObject,myCachedPackets],Model],Object],myCachedPackets];


(* ::Subsection::Closed:: *)
(*ValidExperimentImageSampleQ*)


DefineOptions[ValidExperimentImageSampleQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentImageSample}
];

ValidExperimentImageSampleQ[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions:OptionsPattern[ValidExperimentImageSampleQ]]:=Module[
	{listedOptions, preparedOptions, imageSampleTests, initialTestDescription, allTests, verbose, outputFormat, listedContainers},

(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentImageSample *)
	imageSampleTests = ExperimentImageSample[listedContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[imageSampleTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedContainers,_String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedContainers,_String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, imageSampleTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentImageSampleQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests *)
	Lookup[RunUnitTest[<|"ValidExperimentImageSampleQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentImageSampleQ"]

];


(* ::Subsection::Closed:: *)
(*ExperimentImageSampleOptions*)


DefineOptions[ExperimentImageSampleOptions,
	SharedOptions :> {ExperimentImageSample},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* Containers overload *)
ExperimentImageSampleOptions[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions:OptionsPattern[ExperimentImageSampleOptions]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for ExperimentImageSample *)
	options = ExperimentImageSample[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentImageSample],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentImageSamplePreview*)


DefineOptions[ExperimentImageSamplePreview,
	SharedOptions :> {ExperimentImageSample}
];


(* Containers overload *)
ExperimentImageSamplePreview[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions:OptionsPattern[ExperimentImageSamplePreview]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentImageSample[myContainers, Append[noOutputOptions, Output -> Preview]]
];



(* ::Section:: *)
(*End Private*)
