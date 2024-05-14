(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureWeight*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureWeight - Options*)


DefineOptions[ExperimentMeasureWeight,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull-> False,
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument,Balance],
						Object[Instrument,Balance]
					}]],
				Description-> "For each member of 'items', indicates the model or object instrument balance to be used for the weighing.",
				ResolutionDescription-> "Automatic will resolve to an appropriate balance based on the PreferredBalance of the input container's model and the weight of its contents, if known."
			},
			{
				OptionName -> TransferContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget-> Widget[
					Type->Object,
					Pattern:>ObjectP[Flatten[Join[{MeasureWeightContainerTypes,MeasureWeightModelContainerTypes}]]]
					],
				Description-> "For each member of 'items', indicates if the sample should be transferred to a new container for weighing. Note that if a TransferContainer is specified, the sample will stay in that new container and will not be transferred back to the original container.",
				ResolutionDescription-> "If Automatic, the protocol examines if the existing container holding the sample has a TareWeight associated with it; if no TareWeight is informed, then a new container similar to the existing vessel is determined as TransferContainer for weighing."
			},
			{
				OptionName -> CalibrateContainer,
				Default -> Automatic,
				AllowNull-> False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description-> "For each member of 'items, indicates if the TareWeight of the container will be measured instead of the weight of the sample. If True, the weight of any sample in the container must be known, unless the container is empty.",
				ResolutionDescription-> "Automatic will resolve to False if Mass (in Object[Sample]) is unknown or True if Mass is already informed."
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description -> "The number of times to repeat the experiment on each provided 'item'. If specified, the recorded replicate measurements will be averaged for determining the final Mass of the sample(s). Note that specifying NumberOfReplicates is identical to providing duplicated input.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[2,10,1]]
		},
		AliquotOptions,
		ProtocolOptions,
		SamplePrepOptions,
		ImageSampleOption,
		SamplesInStorageOptions,
		SamplesOutStorageOption,
		SubprotocolDescriptionOption,
		InSituOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureWeight - Error Messages*)


(* Invalid Input errors *)
Error::MissingContainer="The input sample(s), `1`, do(es) not have a container. Please provide only samples that are contained in a container.";
Error::IncompatibleContainerType="The following input container(s), `1`, are of the type(s) `2` which is incompatible with ExperimentMeasureWeight. Please remove these input container(s) from the input or transfer the samples to a container of the type MeasureWeightContainerP before proceeding with the experiment.";
Error::VentilatedSamples="The input sample(s), `1`, cannot be measured because Ventilated->True. The sample(s) must be handled in a fume hood.";

(* Invalid Options errors (prior to resolving options)*)
Error::ConflictingOptions="For the following input container(s), `1`, CalibrateContainer is specified as True while TransferContainer is also specified. Consider leaving either TransferContainer or CalibrateContainer Automatic/Null.";
Error::SampleMassUnknown="For the following input container(s), `1`, CalibrateContainer is specified as True, while it contains a sample with unknown mass. CalibrateContainer can only be true if the input container is empty or the sample it contains has a known mass. Please consider setting CalibrateContainer to False or leaving it blank to measure the mass of the sample contained in the input container.";
Warning::SampleMassMayBeInaccurate ="For the following input container(s), `1`, CalibrateContainer is specified as True, while it contains a sample with a recorded Mass that may be outdated since other protocols have manipulated this sample after the latest weight measurement. Please consider leaving CalibrateContainer Automatic in order to record the accurate mass of the sample before calibrating the container.";
Error::TransferContainerNotEmpty="For the following input container(s), `1`, the specified TransferContainer is not empty. Consider transferring its content before using it as TransferContainer or choose a different container as TransferContainer.";
Error::NoContentsToBeTransferred="For the following input container(s), `1`, there is no sample to be transferred to the specified TransferContainer. Please consider not specifying TransferContainer for these input containers.";
Error::UnsuitableMicroBalance="For the following input container(s), `1`, the chosen micro-balance `2` cannot be used  since its current mass (including sample if any) is close to the limit of the balance. Please consider using an Analytical balance (Model[Instrument, Balance, \"id:vXl9j5qEnav7\"]) or  not specifying the option Instrument for those containers.";
Error::InSituTransferContainer = "You may not use the InSitu option in conjunction with the TransferContainer option. Please set InSitu to False or do not specify a TransferContainer.";

(* Unresolvable Error checking (post resolving options) *)
Error::UnsuitableBalance="For the following input container(s) `1`, the chosen balance `2` does not match the recommended balance model `3`. Please consider using `3` or an object of that model as Instrument or not specifying the option Instrument.";
Error::ContainerIncompatibleWithBalance="For the following input container(s), `1`, a micro-balance, `2`, was requested, which requires containers of the model `3`. Consider using the TransferContainer option (if the container contains a sample), not specifying the option Instrument, or specifying Instrument to an Analytical balance.";
Error::TareWeightNeeded="For the following input container(s), `1`, TransferContainer is specified to Null and the input container(s) contain(s) a sample but no tareweight. Consider leaving TransferContainer blank or setting it to True in order to measure the weight of the sample.";



(* ::Subsubsection:: *)
(*ExperimentMeasureWeight*)


(* Sample overload. Note that samples must be in a container, i.e. they cannot be self-contained samples *)
ExperimentMeasureWeight[mySamples:ListableP[ObjectP[Object[Sample]]|ObjectP[Object[Container]]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedInputs,listedOptions,listedSamples,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
	myOptionsWithPreparedSamples,samplePreparationCache,containers,invalidSamples,samplesToContainerTests,updatedCache},

 	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Make sure we're working with a list of options *)
	(* Remove temporal links and throw warnings *)
	{listedInputs,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentMeasureWeight,
			listedInputs,
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

	(* Get the samples from our list. *)
	listedSamples=Cases[mySamplesWithPreparedSamples,ObjectP[Object[Sample]]];

	(* pull out containers *)
	(* Quiet any messages related to non-existing containers which may happen if we have, for instance, discarded samples *)
	containers=Quiet[
		Download[listedSamples,Container[Object],Cache->samplePreparationCache,Date->Now],
		{Download::ObjectDoesNotExist}
	];

	(* collect the invalid samples for which we could not find any container in the database *)
	invalidSamples=PickList[listedSamples,containers,Null];

	(* If we're not gathering tests but throwing messages, throw an appropriate message, also throw the InvalidInput message *)
	If[!MatchQ[invalidSamples,{}]&&!gatherTests,
		{Message[Error::MissingContainer,ObjectToString[invalidSamples],Cache->samplePreparationCache],Message[Error::InvalidInput,ObjectToString[invalidSamples,Cache->samplePreparationCache]]}
	];

	(* for each input, make a test that matches the above message *)
	samplesToContainerTests = If[!MatchQ[invalidSamples,{}]&&gatherTests,
		MapThread[
			Test["The input sample(s),"<>ToString[#]<>", is/are contained in containers on which the experiment can act", MatchQ[#,$Failed], False]&,
			{listedSamples,containers}
		],
		{}
	];

	(* Update our cache with our new simulated values. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[ToList[myOptions],Cache,{}]
	}];

	(* If we were given a sample without a container, we need to return early here *)
	If[!MatchQ[invalidSamples,{}],
		(* sampleToContainer conversion failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> samplesToContainerTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* sampleToContainer conversion worked - call our main function with our containers and options. *)
		(* Update any samples in our list to their containers. *)
		ExperimentMeasureWeight[mySamplesWithPreparedSamples/.MapThread[#1->#2&,{listedSamples,containers}],ReplaceRule[myOptionsWithPreparedSamples,Cache->updatedCache]]
	]
];

ExperimentMeasureWeight[myContainers:ListableP[ObjectP[Object[Container]]],myOptions:OptionsPattern[]]:=Module[
{
	listedOptions,listedContainers,outputSpecification,output,gatherTests,messages,safeOps,safeOpsTests,validLengths,validLengthTests,
	upload,confirm,fastTrack,parentProt,cache,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,
	transferContainerObjects,transferContainerModels,instrumentObjects,instrumentModels,objectSampleFields,modelSampleFields,objectContainerFields,objectContainerPacket,modelContainerFields,allSamplePackets,allContainerPackets,microBalanceAllowedContainers,microBalanceAllowedContainersFields,microBalanceAllowedContainersPacket,
	allTransferContainerPackets,transferContainerModelPackets,microBalanceAllowedContainerPackets,instrumentModelPackets,instrumentObjectPackets,filteredContainersIn,filteredExpandedOptions,
	resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,allTests,
	validQ,previewRule,optionsRule,testsRule,resultRule,allMetaContainerPackets,validSamplePreparationResult,mySamplesWithPreparedSamples,
	myOptionsWithPreparedSamples,samplePreparationCache,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOptionsNamed
},

	(* Make sure we're working with a list of options *)
	(* Remove temporal links and throw warnings *)
	{listedContainers,listedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentMeasureWeight,
			listedContainers,
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
		SafeOptions[ExperimentMeasureWeight,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureWeight,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureWeight,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureWeight,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, cache} = Lookup[safeOps, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureWeight,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureWeight,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasureWeight,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* let's get the transfer container objects, if specified, so we can download from it for the cache *)
	transferContainerObjects=If[MatchQ[#,ObjectP[Object[Container]]],
		#,
		Null]&/@Lookup[expandedSafeOps,TransferContainer];

	(* let's get the transfer container models, if specified, so we can download from it for the cache *)
	transferContainerModels=If[MatchQ[#,ObjectP[Model[Container]]],
		#,
		Null]&/@Lookup[expandedSafeOps,TransferContainer];

	(* let's get the instrument objects, if specified, so we can download from it for the cache *)
	instrumentObjects=If[MatchQ[#,ObjectP[Object[Instrument,Balance]]],
		#,
		Null]&/@Lookup[expandedSafeOps,Instrument];

	(* let's get the instrument models, if specified, so we can download from it for the cache *)
	instrumentModels=If[MatchQ[#,ObjectP[Model[Instrument,Balance]]],
		#,
		Null]&/@Lookup[expandedSafeOps,Instrument];

	(* define the fields we want to download for the samples inside the containers *)
	objectSampleFields=Union[{MassLog, VolumeLog, Density,Protocols, MaintenanceLog, QualificationLog,TransfersOut,TransfersIn,
		(* for resource packet *)Ventilated,LiquidHandlerIncompatible,Tablet,TabletWeight,TransportWarmed,TransportChilled},
		(* for SamplePrep stuff: *)SamplePreparationCacheFields[Object[Sample]]];

	modelSampleFields=Union[{Density,Tablet,TabletWeight},SamplePreparationCacheFields[Model[Sample]]];

	(* define the fields we want to download for the object containers *)
	objectContainerFields=Sequence@@Union[{Container,Position},SamplePreparationCacheFields[Object[Container]]];
	objectContainerPacket=Packet[objectContainerFields];

	(* define the fields we want to download for the model containers *)
	modelContainerFields=Union[{Ampoule, Immobile, PreferredBalance, Products, TareWeight},SamplePreparationCacheFields[Model[Container]]];

	(* containers that are allowed in micro-balance, If not using weigh boat. We limit the dimensions of the containers so that they can fit onto Micro balance *)
	microBalanceAllowedContainers = Search[Model[Container, Vessel], Dimensions[[1]] <= 0.015Meter && Dimensions[[2]] <= 0.015Meter && Dimensions[[3]] <= 0.04Meter && Stocked==True && SelfStanding==True];

	(* Define the fields to download for the microBalanceAllowedContainers, only need Name in ExperimentMeasureWeight, but including SamplePreparationCacheFields prevents Download::MissingCacheField messages in downstream functions (ExperimentCentrifuge) *)
	microBalanceAllowedContainersFields=Sequence@@Union[{Name},SamplePreparationCacheFields[Model[Container]]];
	microBalanceAllowedContainersPacket=Packet[microBalanceAllowedContainersFields];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* need the NotLinkFields in case there is no sample, then we can't download from the samples' Protocols *)
	(* need to DeleteCases for $Failed in case we don't have a MaintenanceLog or QualificationLog, then we get $Failed entry since it's impossible to dereference from {} *)
	cacheBall= DeleteCases[FlattenCachePackets[{
		samplePreparationCache,
		Quiet[

			{allSamplePackets,allContainerPackets,allMetaContainerPackets,allTransferContainerPackets,transferContainerModelPackets,microBalanceAllowedContainerPackets,instrumentModelPackets,instrumentObjectPackets}=Download[
				{
					mySamplesWithPreparedSamples,
					mySamplesWithPreparedSamples,
					mySamplesWithPreparedSamples,
					transferContainerObjects,
					transferContainerModels,
					microBalanceAllowedContainers,
					instrumentModels,
					instrumentObjects
				},
				{
					{(* The sample stuff *)
						Packet[Contents[[All,2]][objectSampleFields]],
						Packet[Contents[[All,2]][Model][modelSampleFields]],
						Packet[Contents[[All,2]][Protocols[{Status,DateCompleted}]]],
						Packet[Contents[[All,2]][MaintenanceLog[[All,2]][{Status,DateCompleted}]]],
						Packet[Contents[[All,2]][QualificationLog[[All,2]][{Status,DateCompleted}]]]
					},
					{(* The input container stuff *)
						objectContainerPacket,
						Packet[Model[modelContainerFields]]
					},
					{
						(* Container of the Container for InSitu decision trees *)
						Packet[Container[{Model,Container,Position,Mode}]],
						(* Container of the Container's Container (you read the right) for InSitu decision trees *)
						Packet[Container[Container][{Model,Container,Position,Mode}]]
						(* Container of the Containers Container...It's because you could go Container->Rack->Deck->Instrument. Maybe *),
						Packet[Container[Container][Container][{Model,Container,Position,Mode}]]
					},
					{(* the transfer container stuff if Object *)
						Packet[Contents,Model,MaxVolume],
						Packet[Model[{PreferredBalance,MaxVolume, TareWeight,SelfStanding,Immobile,Footprint}]]
					},(* the transfer container stuff if Model *)
					{Packet[PreferredBalance,(* for getStockedContainers *) Products,MaxVolume, TareWeight,SelfStanding,Immobile,Footprint]},
					(* Information about the Micro balance compatible model. *)
					{microBalanceAllowedContainersPacket},
					(* the instrument stuff *)
					{Packet[Mode]},
					{Packet[Model[Mode]]}
				},
				Cache->Flatten[{Lookup[ToList[myOptions],Cache,{}],samplePreparationCache}],
				Date->Now
			],
			{Download::NotLinkField,(* need this one since if we have plates they won't have SlefStanding, InternalDepth, and Internal Diameter*)Download::FieldDoesntExist, Download::MissingCacheField}
		]}],
		$Failed
	];

	(* If we are in a Subprotocol, this section will filter out containers (and options) that are incapable of being weight-measured, before the option resolver *)
	(* If there is no ParentProtocol (ergo we're not in a Subprotocol) we will keep these input options, and the resolver will throw appropriate errors, but we want to avoid these errors when we're in a subprotocol *)
	{filteredContainersIn,filteredExpandedOptions} = If[!MatchQ[Lookup[safeOps,ParentProtocol],ObjectP[]],

		(* If we're not in a Subprotocol, just return the containers we're working with and the options we already expanded *)
		{mySamplesWithPreparedSamples,expandedSafeOps},

		(* If we ARE in a Subprotocol, we need to filter out Discarded samples as well as containers that are not compatible with MeasureWeight (use MeasureWeightContainerP)*)

		Module[
			{invalidPositionsDiscarded,invalidPositionsContainer,invalidPositionsImmobile,invalidPositionsAmpoule,invalidPositions,indexMatchedOptions},

			(* Find the positions of all packets of discarded samples *)
			invalidPositionsDiscarded = Position[allSamplePackets[[All,1]],KeyValuePattern[Status->Discarded]];

			(* Find the positions of all packets of non-compatible containers *)
			invalidPositionsContainer = Position[allContainerPackets[[All,1]],KeyValuePattern[Object->Except[MeasureWeightContainerP]]];

			(* Find the positions of all packets of immobile containers *)
			invalidPositionsImmobile = Position[allContainerPackets[[All,2]],KeyValuePattern[Immobile->True]];

			(* Find the positions of all packets of ampoule containers *)
			invalidPositionsAmpoule = Position[allContainerPackets[[All,2]],KeyValuePattern[Ampoule->True]];

			(* Join the invalid positions *)
			invalidPositions=Join[invalidPositionsDiscarded,invalidPositionsContainer,invalidPositionsImmobile,invalidPositionsAmpoule];

			(* Gather the list of option names that are index matched to the input *)
			indexMatchedOptions = Select[
				OptionDefinition[ExperimentMeasureWeight],
				MatchQ[#["IndexMatchingInput"],"experiment samples"]&
			][[All,"OptionSymbol"]];

			(* use the helper to delete the appropriate indexmatched options - ADD ALIQUOT CONTAINER HERE since it is not an indexmatched option but it DOES get expanded in ExpandIndexMatchedInputs *)
			trimInvalidOptions[mySamplesWithPreparedSamples,expandedSafeOps,Join[indexMatchedOptions,{AliquotContainer,DestinationWell}],invalidPositions]
		]
	];


	(* If filteredContainersIn returns an empty list, this means we don't have any samples anymore to work with, and we quietly return early to make Engine get past this point *)
	If[MatchQ[filteredContainersIn, {}]&&MatchQ[Lookup[safeOps,ParentProtocol],ObjectP[]],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Flatten[Join[safeOpsTests,validLengthTests,templateTests]],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Build the resolved options - check whether we need to return early *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureWeightOptions[filteredContainersIn,filteredExpandedOptions, Cache->cacheBall,Output->{Result,Tests}];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],
		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption; if those were thrown, we encountered a failure *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureWeightOptions[filteredContainersIn,filteredExpandedOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureWeight,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed, return early; messages would have been thrown already *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Flatten[Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests]],
			Options->RemoveHiddenOptions[ExperimentMeasureWeight,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		measureWeightResourcePackets[filteredContainersIn,templatedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{measureWeightResourcePackets[filteredContainersIn,templatedOptions,resolvedOptions,Cache->cacheBall],{}}
	];
	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* if the Output option includes Tests _and_ Result, messages will be suppressed.Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed *)
	(* Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[resourcePackets, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

		(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentMeasureWeight,collapsedResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* Upload the resulting protocol/resource objects; must upload protocol and resource before Status change for UPS' ShippingMaterials shite *)
	resultRule = Result -> If[MemberQ[output, Result] && validQ,
		UploadProtocol[
			(* hard code a replacement of PA124 model with a list containing both PA124 and PA224 balances within the resource objects only*)
			ReplaceAll[resourcePackets, Lookup[resourcePackets,Replace[Batching]] ->
					ReplaceAll[Lookup[resourcePackets,Replace[Batching]], ObjectP[Model[Instrument, Balance, "id:vXl9j5qEnav7"]] ->
							{Model[Instrument, Balance, "id:vXl9j5qEnav7"], Model[Instrument, Balance, "id:KBL5DvYl3zGN"]}]
			],
			Confirm -> confirm,
			Upload -> upload,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,MeasureWeight],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentMeasureWeightOptions*)


(* ========== resolveMeasureWeight Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)
(* the inputs are the sample packet, the model packet, and the input options (safeOptions) *)

DefineOptions[
	resolveExperimentMeasureWeightOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentMeasureWeightOptions[myContainers:{ObjectP[Object[Container]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureWeightOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,inheritedCache,samplePrepOptions,measureCountOptions,measureWeightOptionsAssociation,listedContainerContents,containsSampleBool,
		listedSamples,samplePrepOptionKeys,specifiedSamplePrepOptionValues,emptyContainerSamplePrepOptions,measureWeightOptions,samplePrepOptionAutomaticCheck,invalidSamplePrepOptionsWithoutReplicates,
		invalidSamplePrepOptions,invalidSamplePrepContainers,invalidSamplePrepTests,samplePrepOptionValuesNoNull,samplePrepOptionsNoNull,
		listedSamplesNoNull,resolvedSamplePrepOptionsNoNull,simulatedCacheNoNull,simulatedCache,resolvedSamplePrepOptionsTEMP,
    	sortedResolvedSamplePrepOptionsNoNull,samplePrepOptionKeysSorted,emptyContainerResolvedSamplePrepOptionSingle,emptyContainerResolvedSamplePrepOptions, resolvedSamplePrepOptionsAll,
		samplePrepOptionsAssociation,resolvedSamplePrepOptions,samplePrepOptionsTransposed, indexMatchedSamplePrepOptions,samplePrepOptionsTransposedWithoutNumReplicates,samplePrepOptionKeysTransposed,
		(* from download and down *)
		simulatedIndexMatchedSamples,simulatedContainers,transferContainerObjects,transferContainerModels,instrumentObjects,instrumentModels,allSamplePackets,allContainerPackets,
		allTransferContainerPackets,transferContainerModelPackets,transferContainerPackets,instrumentModelPackets,instrumentObjectPackets,
		samplePackets,inputContainerPackets,inputContainerModelPackets,preferredBalancePacket,transferContainerPreferredBalancePackets,instrumentPackets,
		protocolPackets,maintenancePackets,controlsPackets,allProtocolsPackets,latestSampleWeights,sampleWeightCanBeTrustedBool,sampleMovedQ,
		discardedSampleBool,discardedSamplePackets,discardedInvalidInputs,discardedTests,incompatibleContainersBool,incompatibleContainerPackets,incompatibleContainerInputs,
		incompatibleContainerType,incompatibleContainerTests,immobileContainers,immobileContainerTests,
		conflictingContainerInput,calibrateContainerWarningInput,calibrateContainerWarning,calibrateContainerTests,
		conflictingTransferCalibrateOptions,conflictingTransferCalibrateTests,samplesMass,samplesVolume,samplesDensity,sampleModelPackets,sampleModelsDensity,sampleModelsTablet,sampleModelsTabletWeight,sampleMassUnknownInput,sampleMassUnknownOptions,sampleMassUnknownTests,
		noContentsToBeTransferredInput,noContentsToBeTransferredOptions,noContentsToBeTransferredTests,transferContainerContents,transferContainerNotEmptyInput,
		transferContainerNotEmptyOptions,transferContainerNotEmptyInputTests,specifiedBalanceType,unsuitableMicroBalanceResults,unsuitableMicroBalanceInput,
		unsuitableMicroBalance,unsuitableMicroBalanceOptions,unsuitableMicroBalanceTests,allMetaContainerPackets,inSitu,
		inSituTransferContainerConflicts,inSituTransferContainerInvalidOptions,inSituBools,inSituInvalidOptions,
		metaContainers,metaMetaContainers,metaMetaMetaContainers,
		(* mapthread and down *)
		mapThreadFriendlyOptions,transferContainers,calibrateContainers,instruments,tareWeightNeededErrors,unsuitableBalanceErrors,containerIncompatibleWithBalanceErrors,preferredBalances,recommendedBalances,
		tareWeightNeededOptions,tareWeightNeededTests,unsuitableBalanceOptions,unsuitableBalanceTests,microBalanceAllowedContainers,containerIncompatibleWithBalanceOptions,
		containerIncompatibleWithBalanceTests,invalidTransferSamples,invalidTransferSampleTests,invalidInputs,invalidOptions,invalidPositions,
		indexMatchedOptions,indexMatchedOptionsWithAliquotContainer,validSamplesForAliquotting,validOptionsForAliquotting,validOptionsForAliquottingInSub,
  		resolvedAliquotOptions,aliquotTests,sortedResolvedAliquotOptionsNoNull,aliquotOptionKeysSorted,aliquotOptionsResolvingToNull,resolvedAliquotOptionsNoNulls,emptyContainerResolvedAliquotOptionSingle,emptyContainerResolvedAliquotOptions,resolvedAliquotOptionsAll,resolvedAliquotOptionsAssoc,
		name,confirm,template,samplesInStorageCondition,cache,operator,parentProtocol,upload,outputOption,email,
		numberOfReplicates,resolvedEmail,resolvedPostProcessingOptions,resolvedOptions,allTests,resultRule,testsRule
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* when OptionValue doesn't work we can use this (make sure to call the funciton with the Output option so we can look it up)*)
	(* output=Lookup[ToList[myOptions],Output]; *)
	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Separate out our MeasureWeight options from our SamplePrep options. *)
	{samplePrepOptions,measureWeightOptions}=splitPrepOptions[myOptions];

	(* For the MeasureWeight options, convert list of rules into an to Association so we can Lookup, Append, Join as usual. *)
	measureWeightOptionsAssociation = Association[measureWeightOptions];

	(* === In the next part we are going to resolve the sample prep options. Since we're dealing with containers and not samples, and we may have been handed empty containers, we need to do some special handling here === *)

	(* In particular we need to check whether the user specified any sample prep options for EMPTY containers, in which case we throw an error *)
	(* If not, we resolve the sample prep options for all the containers with samples, and resolve the sample prep options manually for the empty container, and then patch the lists back together *)

	(* Get the contents of the containers *)
	listedContainerContents=Download[myContainers,
		Contents[[All,2]][Object],
		Cache->inheritedCache,
		Date->Now
	];

	(* first figure out which containers we can pass to the sample prep resolver (True); if the container is empty, this will be False *)
	containsSampleBool=Map[
		Switch[#,
			{}, False,
			{ObjectP[Object[Sample]]...}, True,
			_, False
		] &, listedContainerContents
	];

	(* get a flat sample list, indexmatched to myContainers. For empty containers, we put Null. Whenever there are multiple samples (for instance for plates), we take the first sample - we will throw invalid input error further down for these anyways *)
	listedSamples=Map[
		If[MatchQ[#,{}],
		Null,
		First[#]
	]&,
	listedContainerContents];

	{simulatedContainers,resolvedSamplePrepOptions,simulatedCache}=If[MatchQ[myContainers,{}],
		{{},{},inheritedCache},
		resolveSamplePrepOptions[ExperimentMeasureWeight,myContainers,samplePrepOptions, Cache->inheritedCache]
	];

	(* containers that are allowed in micro-balance, If not using weigh boat. We limit the dimensions of the containers so that they can fit onto Micro balance *)
	microBalanceAllowedContainers = Search[Model[Container, Vessel], Dimensions[[1]] <= 0.015Meter && Dimensions[[2]] <= 0.015Meter && Dimensions[[3]] <= 0.04Meter && Stocked==True && SelfStanding==True];

	(*-- DOWNLOAD CALL --*)

	simulatedIndexMatchedSamples = If[MatchQ[#, {}],
		Null,
		First[#[[All,2]]]
	] & /@ Download[simulatedContainers,Contents,Cache->simulatedCache,Date->Now];

	(* let's get the transfer container, if specified *)
	transferContainerObjects=If[MatchQ[#,ObjectP[Object[Container]]],
		#,
		Null]&/@Lookup[measureWeightOptionsAssociation,TransferContainer];

	(* let's get the transfer container, if specified *)
	transferContainerModels=If[MatchQ[#,ObjectP[Model[Container]]],
		#,
		Null]&/@Lookup[measureWeightOptionsAssociation,TransferContainer];

	(* let's get the instrument objects, if specified *)
	instrumentObjects=If[MatchQ[#,ObjectP[Object[Instrument,Balance]]],
		#,
		Null]&/@Lookup[measureWeightOptionsAssociation,Instrument];

		(* let's get the instrument models, if specified *)
	instrumentModels=If[MatchQ[#,ObjectP[Model[Instrument,Balance]]],
		#,
		Null]&/@Lookup[measureWeightOptionsAssociation,Instrument];

	(* need the NotLinkFields in case there is no sample, then we can't download from the samples' Protocols *)
	{allSamplePackets,allContainerPackets,allMetaContainerPackets,allTransferContainerPackets,transferContainerModelPackets,instrumentModelPackets,instrumentObjectPackets}=Quiet[Download[
		{
			simulatedIndexMatchedSamples,
			simulatedContainers,
			simulatedContainers,
			transferContainerObjects,
			transferContainerModels,
			instrumentModels,
			instrumentObjects
		},
		{
			{(* The sample stuff *)
				Packet[Status, Mass, Count,MassLog,Volume, VolumeLog, Density,Protocols, MaintenanceLog, QualificationLog,TransfersOut,TransfersIn,Ventilated,Sterile,LiquidHandlerIncompatible,State,Name,Tablet,TabletWeight,TransportWarmed],
				Packet[Protocols[{Status,DateCompleted}]],
				Packet[MaintenanceLog[{Status,DateCompleted}]],
				Packet[QualificationLog[{Status,DateCompleted}]],
				Packet[Model[{Density,Tablet,TabletWeight}]]
			},
			{(* The input container stuff *)
				Packet[Type,Contents,TareWeight,Model,Container],
				Packet[Model[{Object,PreferredBalance,TareWeight,Immobile}]]
			},
			{(* The Meta Container stuff (parent and parent's parent) *)
				(* Container of the Container info - Used for InSitu *)
				Packet[Container[{Model,Container,Position,Mode}]],
				(* Container of the Container's Container - Used for InSitu *)
				Packet[Container[Container][{Model,Container,Position,Mode}]],
				(* Container of the Container's Container's Container - Used for InSitu *)
				Packet[Container[Container][Container][{Model,Container,Position,Mode}]]
			},
			{(* the transfer container stuff if Object *)
				Packet[Contents,Model],
				Packet[Model[{PreferredBalance,TareWeight}]]
			},(* the transfer container stuff if Model *)
			{Packet[PreferredBalance,MaxVolume,TareWeight]},
			(* the instrument stuff *)
			{Packet[Mode]},
			{Packet[Model[Mode]]}
		},
		Cache->simulatedCache,
		Date->Now
	],{Download::NotLinkField,Download::FieldDoesntExist}];

	(* get the packets for the samples (as opposed to the protocols/maintenanceLog/) *)
	samplePackets=If[NullQ[#],
		{},
		If[MatchQ[#[[1]],$Failed],
			{},
			#[[1]]
		]
		]&/@allSamplePackets;

  (* input container packets - Object vs Models *)
	inputContainerPackets=allContainerPackets[[All, 1]];
	inputContainerModelPackets = allContainerPackets[[All, 2]];

	(* Transfer packets - Object vs Model *)
	transferContainerPackets=Map[If[NullQ[#],Null,#[[1]]]&,allTransferContainerPackets];
	preferredBalancePacket=Map[If[NullQ[#],Null,#[[2]]]&,allTransferContainerPackets];

	(* since we downloaded PreferredBalance from both the Object[Model] and from the Model (if given) combine these packets now; make sure we have a flat list of packets now *)
	transferContainerPreferredBalancePackets=Flatten[MapThread[
		Which[
			(* If the instrument is not specified at all, return Null *)
			(MatchQ[#1,Null]&&MatchQ[#2,Null]), Null,
			(* If the instrument is specified as a Model, grab the packet from the Model download; get rid of the list since it can only be one entry *)
			MatchQ[#1,ObjectP[Model[Container]]],#3,
			(* If the instrument is specified as a Model, grab the packet from the Model download; get rid of the list since it can only be one entry *)
			MatchQ[#2,ObjectP[Object[Container]]],#4,
			True, Null
		]&,
	{transferContainerModels,transferContainerObjects,transferContainerModelPackets,preferredBalancePacket}
	],1];

	(* also assemble to instrument packets by combining the information we downloaded from either the object or the model instrument, if specified *)
	(* note that these packets for the Model in either case, since we transversed to the Model when downloading from the object *)
	instrumentPackets=MapThread[
		Which[
			(* If the instrumnt is not specified at all, return Null *)
			(MatchQ[#1,Null]&&MatchQ[#2,Null]), Null,
			(* If the instrument is specified as a Model, grab the packet from the Model download; get rid of the list since it can only be one entry *)
			MatchQ[#1,ObjectP[Model[Instrument,Balance]]],FirstOrDefault[#3],
			(* If the instrument is specified as a Model, grab the packet from the Object download; get rid of the list since it can only be one entry *)
			MatchQ[#2,ObjectP[Object[Instrument,Balance]]],FirstOrDefault[#4],
			True, Null
		]&,
	{instrumentModels,instrumentObjects,instrumentModelPackets,instrumentObjectPackets}
	];

	(* If we have samples, get the packets for the samples' protocols. Need to be wary of $Failed entries since we may have downloaded from {} *)
	protocolPackets=If[NullQ[#],
		{},
			If[MatchQ[#[[2]],$Failed],
				{},
				#[[2]]
			]
	]&/@allSamplePackets;

	(* If we have samples, get the packets for the samples' maintenance protocols. Need to be wary of $Failed entries since we may have downloaded from {} *)
	maintenancePackets=If[NullQ[#],
		{},
			If[MatchQ[#[[3]],$Failed],
				{},
				#[[3]]
			]
	]&/@allSamplePackets;

	(* If we have samples, get the packets for the samples' control protocols. Need to be wary of $Failed entries since we may have downloaded from {} *)
	controlsPackets=If[NullQ[#],
		{},
			If[MatchQ[#[[4]],$Failed],
				{},
				#[[4]]
			]
	]&/@allSamplePackets;

	(* Join all the protocols that each sample has. This may be an empty list if there was no sample in the container to start with, or if the sample has no protocols affiliated with itself *)
	allProtocolsPackets=MapThread[
		Flatten[Join[#1,#2,#3]]&,
	{protocolPackets,maintenancePackets,controlsPackets}
	];

	(* If there is a sample, get its latest weight, plus check whether we can trust the latest weight *)
	(* This is information we'll need for the InvalidOption checks and the resolving MapThread below *)
	{latestSampleWeights,sampleWeightCanBeTrustedBool}=Transpose[MapThread[
		Function[{sample,protocolPackets,samplePacket},
			If[
				!NullQ[sample],
				Module[{sampWeight,sampWeightLog,sampVolume, sampVolumeLog, sampDensity,sampWeightByVolume,sampWeightDate,
				sampVolumeDate,latestSampWeight,latestWeightDate,sampleWeightCanBeTrusted},

					(* get pertinent sample information *)
					{sampWeight, sampWeightLog, sampVolume, sampVolumeLog, sampDensity} = Lookup[samplePacket,{Mass, MassLog, Volume,VolumeLog, Density}];

					(* get sample Weight from Volume. Note: this may not evalute to a Mass if Density field doesn't exist, is not informed etc. This will be handled. *)
					sampWeightByVolume = sampVolume*sampDensity;

					(* get the latest date on which the samp weight was updated. Return Default date before the start of Emerald if empty list for whatever reason *)
					sampWeightDate = LastOrDefault[sampWeightLog[[All,1]], DateObject[0]];

					(* get the latest date on which the sample volume was updated. Return Default date before the start of Emerald if empty list for whatever reason *)
					sampVolumeDate = LastOrDefault[sampVolumeLog[[All,1]], DateObject[0]];

					(* determine the sampWeight by choosing the latest measurement, or return Null *)
					{latestSampWeight,latestWeightDate} = Which[
						MassQ[sampWeight] && MassQ[sampWeightByVolume],

						(* If both the weight and the weight by volume exist, set the latestSampWeight to the weight which was measured latest *)
						If[sampWeightDate >= sampVolumeDate,
							{sampWeight,sampWeightDate},
							{sampWeightByVolume,sampVolumeDate}
						],
						(* otherwise return the weight *)
						MassQ[sampWeight], {sampWeight,sampWeightDate},
						MassQ[sampWeightByVolume], {sampWeightByVolume,sampVolumeDate},
						(* if neither weight nor weight by volume could be found, return Null *)
						True, {Null,Null}
					];

					If[
						MassQ[latestSampWeight],

						(* since there is a sample weight, check if sample is untouched since the last weighing/VolumeCheck *)
						sampleWeightCanBeTrusted = sampleWeightCanBeTrustedQ[samplePacket, protocolPackets,latestWeightDate],

						(* if sampleWeight is Null, then sample need not be examined when making decision *)
						sampleWeightCanBeTrusted = False
					];

					{latestSampWeight,sampleWeightCanBeTrusted}
				],
				(
					{Null,False}
				)
			]
		],
	{simulatedIndexMatchedSamples,allProtocolsPackets,samplePackets}
	]];

  (* Also, construct a boolean as to whether the sample was moved, we need this further down in the mapThread *)
  (* Need to download object here in case myContainers is defined via the name and not ID *)
  sampleMovedQ=MapThread[If[SameQ[#1,#2],False,True]&,{Download[simulatedContainers,Object],Download[myContainers,Object]}];

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. DISCARDED SAMPLES *)

	(* Get a boolean for which samples are discarded *)
	discardedSampleBool=Map[
		If[NullQ[#],
			False,
			MatchQ[#, KeyValuePattern[Status -> Discarded]]
		]
	&, samplePackets];

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
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" is/are not discarded:",True,False]
			];
 			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedIndexMatchedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedIndexMatchedSamples,discardedInvalidInputs],Cache->simulatedCache]<>" is/are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 2. INVALID INPUT CONTAINERS *)

	(* create a boolean for whether the containers are measure-weight measurable *)
	incompatibleContainersBool=Map[MatchQ[#, Except[MeasureWeightContainerP]]&,simulatedContainers];

	(* collect all container packets that are not measure-weight measurable *)
	incompatibleContainerPackets=PickList[inputContainerPackets,incompatibleContainersBool,True];

	(* if we have invalid packets, get the invalid containers and their type *)
	{incompatibleContainerInputs,incompatibleContainerType}=If[Length[incompatibleContainerPackets]>0,
		Transpose[Lookup[Flatten[incompatibleContainerPackets],{Object,Type}]],
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[incompatibleContainerPackets]>0&&!gatherTests,
		Message[Error::IncompatibleContainerType,ObjectToString[incompatibleContainerInputs,Cache->simulatedCache],ObjectToString[DeleteDuplicates[incompatibleContainerType]]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleContainerTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleContainerInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The following input container(s), "<>ObjectToString[incompatibleContainerInputs,Cache->simulatedCache]<>", is/are compatible with total weight measurement:",True,False]
			];
 			passingTest=If[Length[incompatibleContainerInputs]==Length[simulatedContainers],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The following input container(s), "<>ObjectToString[Complement[simulatedContainers,incompatibleContainerInputs],Cache->simulatedCache]<>", is/are compatible with total weight measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 3. IMMOBILE CONTAINERS *)

	(* Get containers marked as immobile *)
	immobileContainers=Lookup[
		PickList[inputContainerPackets,inputContainerModelPackets,_?(TrueQ[Lookup[#,Immobile]]&)],
		Object,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[immobileContainers]>0&&!gatherTests,
		Message[Error::ImmobileSamples,"weighed","balance",ObjectToString[immobileContainers,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	immobileContainerTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleContainerInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The following input container(s), "<>ObjectToString[immobileContainers,Cache->simulatedCache]<>", is/are compatible with total weight measurement:",True,False]
			];
			passingTest=If[Length[immobileContainers]==Length[simulatedContainers],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The following input container(s), "<>ObjectToString[Complement[simulatedContainers,immobileContainers],Cache->simulatedCache]<>", is/are compatible with total weight measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)

	(* there are no option precision checks in ExperimentMeasureWeight *)

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* 1. CalibrateContainer VS TransferContainer Error *)

	(* CalibrateContainer is False when TransferContainer is specified, otherwise we can't perform the experiment *)
	conflictingContainerInput=MapThread[
		Function[{calibrateContainer,transferContainer,containerObject},
			Switch[{calibrateContainer,transferContainer},
			(* If the calibrateContainer boolean is set to True but we have a TransferContainer specified as well, return the sample with the mismatching option value *)
				{True,ObjectP[Object[Container]]},
					containerObject,
				(* we're fine if CalibrateContainer is false or automatic and the TransferContainer is specified or Automatic *)
				{False|Automatic,ObjectP[Object[Container]]|Automatic},
					Nothing,
				_,
					Nothing
			]
		],
		{Lookup[measureWeightOptionsAssociation,CalibrateContainer],Lookup[measureWeightOptionsAssociation,TransferContainer,{}],simulatedContainers}
	];


	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	conflictingTransferCalibrateOptions=If[(Length[conflictingContainerInput]>0 && messages),
		Message[Error::ConflictingOptions,ObjectToString[conflictingContainerInput,Cache->simulatedCache]];
		{CalibrateContainer,TransferContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingTransferCalibrateTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,conflictingContainerInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option CalibrateContainer is not True when the option TransferContainer is specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingContainerInput]>0,
				Test["For the input container(s) "<>ObjectToString[conflictingContainerInput,Cache->simulatedCache]<>", the option CalibrateContainer is not True when the option TransferContainer is specified:",True,False],
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

	(* 2. CalibrateContainer VS SampleMass Error *)

	(* get the Mass from the sample packets, be wary of the Nulls we may have (for empty containers) *)
	(* below we also check whether the mass is trustworthy, if not, we throw a warning *)
	samplesMass=Map[
		If[NullQ[#],
			Null,
			Lookup[#,Mass,Null]
		]
	&,samplePackets];
	
	(* Get the sample volumes, be wary of the Nulls we may have (for empty containers) *)
	samplesVolume=If[
		NullQ[#],
		Null,
		Lookup[#,Volume,Null]
	]&/@samplePackets;
	
	(* Get the sample density, be wary of the Nulls we may have (for empty containers) *)
	samplesDensity=If[
		NullQ[#],
		Null,
		Lookup[#,Density,Null]
	]&/@samplePackets;
	
	(* Get the sample model packets -- empty containers have {} so we need to return a Null for those *)
	sampleModelPackets=If[
		MatchQ[#,{}],
		Null,
		fetchPacketFromCache[Download[Lookup[#,Model],Object],simulatedCache]
	]&/@samplePackets;
	
	(* Get the densities from the samples, be wary of the Nulls we may have (for empty containers) *)
	sampleModelsDensity=If[
		NullQ[#],
		Null,
		Lookup[#,Density,Null]
	]&/@sampleModelPackets;
	
	(* Get the tablet bool from the samples, be wary of the Nulls we may have (for empty containers) *)
	sampleModelsTablet=If[
		NullQ[#],
		Null,
		Lookup[#,Tablet,Null]
	]&/@sampleModelPackets;
	
	(* Get the tablet weight from the samples, be wary of the Nulls we may have (for empty containers) *)
	sampleModelsTabletWeight=If[
		NullQ[#],
		Null,
		Lookup[#,Density,Null]
	]&/@sampleModelPackets;
	
	(* CalibrateContainer is only True when the container is empty or the sample inside the container has a known weight, or volume/density, otherwise we can't perform the experiment *)
	sampleMassUnknownInput=MapThread[
		Function[{calibrateContainer,sample,sampleMass,containerObject,sampleVolume,sampleDensity,sampleModelDensity,tabletBool,tabletWeight},
			Switch[{calibrateContainer,sample,sampleMass,sampleVolume,sampleDensity,sampleModelDensity,tabletBool,tabletWeight},
				
				(* we're fine if CalibrateContainer is false or Automatic *)
				{False|Automatic,_,_,_,_,_,_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we don't have a sample, we're good *)
				{True,Null,_,_,_,_,_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we have a sample with known weight, we're good too *)
				{True,ObjectP[Object[Sample]],GreaterEqualP[0*Gram],_,_,_,_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we have a sample with known volume and density, we are good *)
				{True,ObjectP[Object[Sample]],_,GreaterEqualP[0 Milliliter],GreaterEqualP[0 Gram/Milliliter],_,_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we have a sample with known volume and model density, we are good *)
				{True,ObjectP[Object[Sample]],_,GreaterEqualP[0 Milliliter],_,GreaterEqualP[0 Gram/Milliliter],_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we only know the sample volume, we are not good, but we will still move forward. Some containers are received with no known sample mass or density. ParameterizeContainer will measure the density if that can be done but there are still cases where we cannot. In those cases, we still want to measure the weight and try to move forward with assuming the density. It is not great, but an educated guess is better than the protocol getting blocked *)
				{True,ObjectP[Object[Sample]],Null,GreaterEqualP[0 Milliliter],Null,Null,_,_},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we have a sample that is made up of tablets with a known mass, we're good *)
				{True,ObjectP[Object[Sample]],_,_,_,_,True,GreaterEqualP[0 Gram]},Nothing,
				
				(* If the calibrateContainer boolean is set to True, and we have a sample with unknown weight, volume and density, we can't proceed *)
				{True,ObjectP[Object[Sample]],Null,Null,Null,Null,Null,Null},containerObject,
				
				(* Default condition *)
				_,Nothing
			]
		],
		{Lookup[measureWeightOptionsAssociation,CalibrateContainer],simulatedIndexMatchedSamples,samplesMass,simulatedContainers,samplesVolume,samplesDensity,sampleModelsDensity,sampleModelsTablet,sampleModelsTabletWeight}
	];
	
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	sampleMassUnknownOptions=If[(Length[sampleMassUnknownInput]>0 && messages),
		Message[Error::SampleMassUnknown,ObjectToString[sampleMassUnknownInput,Cache->simulatedCache]];
		{CalibrateContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	sampleMassUnknownTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,sampleMassUnknownInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option CalibrateContainer is True when the container is empty or the contained samples's mass is known:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[sampleMassUnknownInput]>0,
				Test["For the input container(s) "<>ObjectToString[sampleMassUnknownInput,Cache->simulatedCache]<>", the option CalibrateContainer is True when the container is empty or the contained samples's mass is known:",True,False],
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

	(* 3. CalibrateContainer VS non-trustworthy sample warning *)

	(* When CalibrateContainer is specified by the user to True, and we have a sample with a weight that we may not trust, we throw a warning *)
	calibrateContainerWarningInput=MapThread[
		Function[{calibrateContainer,sample,sampleMass,trustMass,containerObject},
			Switch[{calibrateContainer,sample,sampleMass,trustMass},
				(* If the calibrateContainer boolean is set to True, and we have a sample with known weight but we don't trust its weight, we throw a warning *)
				{True,ObjectP[Object[Sample]],GreaterEqualP[0*Gram],False},
					containerObject,
				_,
					Nothing
			]
		],
		{Lookup[measureWeightOptionsAssociation,CalibrateContainer],simulatedIndexMatchedSamples,samplesMass,sampleWeightCanBeTrustedBool,simulatedContainers}
	];

	(* If there are invalid options and we are throwing messages, throw a warning message (we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine)*)
	calibrateContainerWarning=If[(Length[calibrateContainerWarningInput]>0 && messages && !MatchQ[$ECLApplication,Engine]),
		Message[Warning::SampleMassMayBeInaccurate,ObjectToString[calibrateContainerWarningInput,Cache->simulatedCache]],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	calibrateContainerTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,calibrateContainerWarningInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option CalibrateContainer is set to True when the sample's weight is trustworthy:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[calibrateContainerWarningInput]>0,
				Warning["For the input container(s) "<>ObjectToString[calibrateContainerWarningInput,Cache->simulatedCache]<>",  the option CalibrateContainer is set to True when the sample's weight is trustworthy:",True,False],
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

	(* 4. TransferContainer VS empty input container error *)

	(* When TransferContainer is specified by the user, we have to have a sample in the inputer that can be transfered, otherwise we can't perform the experiment as desired *)
	noContentsToBeTransferredInput=MapThread[
		Function[{transferContainer,sample,containerObject},
			Switch[{transferContainer,sample},
				(* when TransferContainer is neither Null nor Automatic but a model or object container, and we don't have a sample to transfer, we can't proceed *)
				{ObjectP[{Object[Container],Model[Container]}],Null},
					containerObject,
				(* If the calibrateContainer boolean is set to Null or Automatic, we don't care whether there is a sample *)
				{Null|Automatic,_},
					Nothing,
				_,
					Nothing
			]
		],
		{Lookup[measureWeightOptionsAssociation,TransferContainer],simulatedIndexMatchedSamples,simulatedContainers}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	noContentsToBeTransferredOptions=If[(Length[noContentsToBeTransferredInput]>0 && messages),
		Message[Error::NoContentsToBeTransferred,ObjectToString[noContentsToBeTransferredInput,Cache->simulatedCache]];
		{TransferContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	noContentsToBeTransferredTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,noContentsToBeTransferredInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option TransferContainer is specified when the input container is not empty:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[noContentsToBeTransferredInput]>0,
				Test["For the input container(s) "<>ObjectToString[noContentsToBeTransferredInput,Cache->simulatedCache]<>", the option TransferContainer is specified when the input container is not empty:",True,False],
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

	(* 4. TransferContainer not empty Error *)

	(* get the Contents from the transfer container pacekts, be wary of the Nulls we may have (for non-specified or Null or model containers *)
		transferContainerContents=Map[
		If[NullQ[#],
			{},
			Lookup[#,Contents][[All,2]]
		]
	&,Flatten[transferContainerPackets]];


	(* When TransferContainer is specified by the user to a specific container object, that container has to be empty, otherwise we can't perform the experiment as desired *)
	transferContainerNotEmptyInput=MapThread[
		Function[{transferContainer,contents,containerObject},
			Switch[{transferContainer,contents},
				(* when TransferContainer is specified and the content is anything but an empty list, collect the corresponding input container  *)
				{ObjectP[{Object[Container]}],Except[{}]},
					containerObject,
				(* in all other cases we're fine *)
				_,
					Nothing
			]
		],
		{Lookup[measureWeightOptionsAssociation,TransferContainer],transferContainerContents,simulatedContainers}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	transferContainerNotEmptyOptions=If[(Length[transferContainerNotEmptyInput]>0 && messages),
		Message[Error::TransferContainerNotEmpty,ObjectToString[transferContainerNotEmptyInput,Cache->simulatedCache]];
		{TransferContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	transferContainerNotEmptyInputTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,transferContainerNotEmptyInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option TransferContainer is either Automatic, or specified to Null or a Model, or is specified to a container object that is empty:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[sampleMassUnknownInput]>0,
				Test["For the input container(s) "<>ObjectToString[transferContainerNotEmptyInput,Cache->simulatedCache]<>", the option TransferContainer is either Automatic, or specified to Null or a Model, or is specified to a container object that is empty:",True,False],
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

	(* 5. Instrument Unsuitable Micro Balance Error *)

	(* get the Type of the balance, if user specified *)
	specifiedBalanceType = Map[
		If[NullQ[#],
			Null,
			Lookup[#, Mode]
		]&,
	instrumentPackets
	];

	(* When the Instrument is specified by the user to a Micro balance, and the input container contains a sample with a trustworthy mass above 0.8 * 6 gams, we know for sure we can't perform the experiment as desired *)
	unsuitableMicroBalanceResults=MapThread[
		Function[{type,weight,trustWeight,containerObject,instrument},
			Switch[{type,weight,trustWeight},
				(* when Instrument is specified to a Micro balance object or Model, and the input sample is heavier than 4.8 Grams, then we can't use Micro for sure *)
				{Micro,GreaterEqualP[0.8*6*Gram],True},
					{containerObject,instrument},
				(* in all other cases we're OK, since we either are below this threshold, or we don't have a trustworthy mass (then we can't help but go for it) *)
				_,
					Nothing
			]
		],
		{specifiedBalanceType,latestSampleWeights,sampleWeightCanBeTrustedBool,simulatedContainers,Lookup[measureWeightOptionsAssociation,Instrument]}
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified balance *)
	{unsuitableMicroBalanceInput,unsuitableMicroBalance}=If[Length[unsuitableMicroBalanceResults]>0,
		Transpose[unsuitableMicroBalanceResults],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	unsuitableMicroBalanceOptions=If[(Length[unsuitableMicroBalanceInput]>0 && messages),
		Message[Error::UnsuitableMicroBalance,ObjectToString[unsuitableMicroBalanceInput,Cache->simulatedCache],ObjectToString[unsuitableMicroBalance,Cache->simulatedCache]];
		{Instrument},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	unsuitableMicroBalanceTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,unsuitableMicroBalanceInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>", the option Instrument is specified to a Micro balance, when the current sample's mass (if any) is below the limit of the micro balance:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[sampleMassUnknownInput]>0,
				Test["For the input container(s) "<>ObjectToString[unsuitableMicroBalanceInput,Cache->simulatedCache]<>", the option Instrument is specified to a Micro balance, when the current sample's mass (if any) is below the limit of the micro balance:",True,False],
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

	(* 6. InSitu vs TransferContainer *)

	(* stash the InSitu option *)
	inSitu = Lookup[measureWeightOptionsAssociation,InSitu];

	(* A User would violate the InSitu designation by requiring a TransferContainer, so make sure there were no conflicts *)
	inSituTransferContainerConflicts = And[TrueQ[inSitu],MatchQ[#,ObjectP[]]]&/@Lookup[measureWeightOptionsAssociation,TransferContainer];

	(* If there were conflicts, throw an error but make no tests as we don't want to return this to non-developer users *)
	inSituTransferContainerInvalidOptions = If[(MemberQ[inSituTransferContainerConflicts,True] && messages),
		Message[Error::InSituTransferContainer];
		{InSitu,TransferContainer},
		{}
	];

	(* 7. InSitu possibility check *)
	{metaContainers,metaMetaContainers,metaMetaMetaContainers}=Transpose[allMetaContainerPackets];

	(* Resolve the InSitu option *)
	inSituBools = If[inSitu,

		(* Determine whether all the samples are actually on a balance or not *)
		MapThread[
			(* We can state InSitu is possible if one of the next three containers above the sample's container is a balance *)
			Function[{containerX,metaContX,metaMetaContX,metaMetaMetaContX},
				Which[
					(* The container is on a balance so InSitu is possible *)
					MatchQ[metaContX,ObjectP[Object[Instrument,Balance]]]||MatchQ[metaMetaContX,ObjectP[Object[Instrument,Balance]]]||MatchQ[metaMetaMetaContX,ObjectP[Object[Instrument,Balance]]],
						True,

					(* We determined the container is not on an instrument and thus InSitu is not possible *)
					True,
						False
				]
			],
			{allContainerPackets,metaContainers,metaMetaContainers,metaMetaMetaContainers}
		],

		(* If InSitu is False, just set the InSituBools to false as none should be conducted InSitu*)
		ConstantArray[False,Length[simulatedContainers]]
	];

	(* No tests are required here as this is a Developer only, hidden option and we don't want to publicize it *)
	(* We do need to throw an error however if there are errors to be thrown *)
	inSituInvalidOptions = If[inSitu&&MemberQ[inSituBools,False],
		Message[Error::InSituImpossible,ObjectToString[PickList[simulatedContainers,inSituBools,False],Cache->simulatedCache]];

		(* Store the errant options for later InvalidOption checks *)
		{InSitu},

		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* 6. Check if AliquotSampleStorageCondition does not match SamplesInStorageCondition *)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

 	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMeasureWeight,measureWeightOptionsAssociation];

	(* MapThread over each of our samples. *)
	{transferContainers,calibrateContainers,instruments,tareWeightNeededErrors,unsuitableBalanceErrors,containerIncompatibleWithBalanceErrors,preferredBalances,recommendedBalances}=Transpose[
		MapThread[
			Function[{samplePacket,inputContainerPacket,inputContainerModelPacket,transferContainerPrefBalancePacket,sample,options,sampleWeight,trustBool,specifiedInstrumentMode,instrumentPacket,sampleWasMovedQ},
				Module[{tareWeightNeededError,unsuitableBalanceError,containerIncompatibleWithBalanceError,
				tareWeight,tareWeightFromModel,inputContainerModel,inputContainer,transferContainerPreferredBalance,specifiedInstrumentModel,inputContainerPreferredBalance,getStockedTransferContainer,getSuitableBalance,
				specifiedCalibrateContainer,specifiedTransferContainer,specifiedInstrument,recommendedBalance,
				calibrateContainer,transferContainer,preferredBalance,modelContainerThatWillBeWeighed,instrument
				},

					(* Setup our error tracking variables *)
					{tareWeightNeededError,unsuitableBalanceError,containerIncompatibleWithBalanceError}={False,False,False};

					(* grab the TareWeight, Model, and PreferredBalance from the input Container object packets *)
					{tareWeight,inputContainerModel,inputContainer}=Lookup[inputContainerPacket,{TareWeight,Model,Object}];


					(* grab the PreferredBalance mode for the transferContainer if specified by the user - the packet is in a list so need to take FirstOrDefault to get just the mode *)
					transferContainerPreferredBalance=If[NullQ[transferContainerPrefBalancePacket],
						Null,
						Lookup[transferContainerPrefBalancePacket,PreferredBalance]
					];

					(* grab the instrument model, if it was userspecified, from the instrumentPacket *)
					specifiedInstrumentModel=If[NullQ[instrumentPacket],
						Null,
						Lookup[instrumentPacket,Object]
					];

					(* grab the PreferredBalance mode for the model input container, from the inputContainerModelPacket *)
					inputContainerPreferredBalance=If[NullQ[inputContainerModelPacket],
						Null,
						Lookup[inputContainerModelPacket,PreferredBalance]
					];

					(* grab the PreferredBalance mode for the model input container, from the inputContainerModelPacket *)
					tareWeightFromModel=If[NullQ[inputContainerModelPacket],
						Null,
						Lookup[inputContainerModelPacket,TareWeight]
					];


					(* getStockedTransferContainer helper file for finding a suitable TransferContainer model *)
					(* the output is a Model container that is either the exact same Model as the input container, or a preferred vessel output *)
					(* TODO do not download here ! Pass Cache!   *)
					getStockedTransferContainer[modelCont:ObjectP[Model[Container]]]:=Module[
						{products, maxVolume, standardVessels, objectVolumeTuples},

						{products, maxVolume} = Download[modelCont,{Products,MaxVolume},Date->Now];

						(* If we stock the container currently holding the sample, we can transfer it into a new container with the same model *)
						If[MatchQ[products,{ObjectP[]..}],
							Return[Download[modelCont,Object]]
						];

						standardVessels = PreferredContainer[All];

						objectVolumeTuples = SortBy[Download[standardVessels,{Object,MaxVolume},Date->Now],Last];

						First[SelectFirst[objectVolumeTuples, Last[#] >= maxVolume &]]
					];

					(* getSuitableBalance helper file for finding a suitable Balance model *)
					(* the output is a balance that fits to the PreferredBalance Mode of the model container that is being measured (which is either input or transfer container) and if available and trustworthy, considers the weight of the sample *)
					getSuitableBalance[myContainer:PacketP[Object[Container]], myMode_,mylatestWeight_,myTrustWeightBool_,inSituBool_]:=Which[
						(* If we're doing things InSitu, then we just want to take the container the sample is sitting *)
						TrueQ[inSituBool],
								Module[{myMetaContainer,myMetaMetaContainer,myMetaMetaMetaContainer},

									(* get the meta container (this is possible if it's container->balance) *)
									myMetaContainer = FirstCase[
										Flatten[allMetaContainerPackets],
										KeyValuePattern[Object->Download[Lookup[myContainer,Container],Object]],
										Null
									];

									(* get the meta meta container (this is possible if it's container->rack->balance) *)
									myMetaMetaContainer = If[!NullQ[myMetaContainer],
										FirstCase[
											Flatten[allMetaContainerPackets],
											KeyValuePattern[Object->Download[Lookup[myMetaContainer,Container],Object]],
											Null
										],
										Null
									];

									(* get the meta meta meta container (this is possible if it's container->rack->deck->balance) *)
									myMetaMetaMetaContainer = If[!NullQ[myMetaMetaContainer],
										FirstCase[
											Flatten[allMetaContainerPackets],
											KeyValuePattern[Object->Download[Lookup[myMetaMetaContainer,Container],Object]],
											Null
										],
										Null
									];

									Which[
										(* If the container is in an instrument, return that balance *)
										MatchQ[myMetaContainer,ObjectP[Object[Instrument,Balance]]],
											Download[myMetaContainer,Object],
										(* If the container is in a rack on the instrument, return that balance *)
										MatchQ[myMetaMetaContainer,ObjectP[Object[Instrument,Balance]]],
											Download[myMetaMetaContainer,Object],
										(* If the container is in a rack, on a deck of the instrument, return that balance *)
										MatchQ[myMetaMetaMetaContainer,ObjectP[Object[Instrument,Balance]]],
											Download[myMetaMetaMetaContainer,Object],
										(* If the container isn't sitting on a balance at all, return an error *)
										True,
											Null
									]
								],

						(* preferred balance type -> Micro AND ( either cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)6 Gram ) *)
						MatchQ[myMode, Micro] && (!myTrustWeightBool || (myTrustWeightBool && (mylatestWeight <= (0.8)6 Gram)) ),
							Model[Instrument,Balance,"id:54n6evKx08XN"],

						(* preferred balance type -> Analytical|Micro AND ( either cannot be trusted, then we don't care, OR sample can be trusted and weight < 120 Gram ) *)
						MatchQ[myMode, Analytical|Micro] && (!myTrustWeightBool || (myTrustWeightBool && (mylatestWeight < (0.8)120 Gram)) ),
							Model[Instrument,Balance,"id:vXl9j5qEnav7"],

						(* preferred balance type -> Macro|Analytical|Micro AND ( either cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)6000 Gram ) *)
						MatchQ[myMode, Macro|Analytical|Micro] && (!myTrustWeightBool || (myTrustWeightBool && (mylatestWeight < (0.8)6000 Gram)) ),
							Model[Instrument,Balance,"id:o1k9jAGvbWMA"],

						(* preferred balance type -> Macro|Analytical|Micro|Bulk AND ( eeither cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)25000 Gram ) *)
						MatchQ[myMode, Macro|Analytical|Micro|Bulk] && (!myTrustWeightBool || (myTrustWeightBool && (mylatestWeight < (0.8)60000  Gram)) ),
							Model[Instrument,Balance,"id:aXRlGn6V7Jov"],

						(* doesn't fit any of the previous parameters (meaning, we don't have a PreferredBalance thus no Mode, then need to do scout balance so leave as Null *)
						True,
							Null
					];

					(* pull out the option values for CalibrateContainer,TransferContainer, and Instrument *)
					{specifiedCalibrateContainer,specifiedTransferContainer,specifiedInstrument}= Lookup[options,{CalibrateContainer,TransferContainer,Instrument}];

					(* 1)  Resolve CalibrateContainer *)

					calibrateContainer=Switch[{specifiedCalibrateContainer,specifiedTransferContainer,sample,tareWeight,sampleWeight,trustBool},

						(* if CalibrateContainer is specified by the user to False, return False *)
						{False,_,_,_,_,_}, specifiedCalibrateContainer,

						(* if CalibrateContainer is specified by the user to True, return True - we will already have thrown conflicting options or SampleMassUnknown above if necessary *)
						{True,_,_,_,_,_}, specifiedCalibrateContainer,

						(* if CalibrateContainer is Automatic, and TransferContainer specified to an object or model container, return False *)
						{Automatic,ObjectP[{Object[Container],Model[Container]}],_,_,_,_}, False,

						(* if CalibrateContainer is Automatic, and TransferContainer not specified, and the input container is empty, return True (we can calibrate empty containers without problems *)
						{Automatic,_,Null,_,_,_}, True,

						(* if CalibrateContainer is Automatic, and TransferContainer not specified, and the input container contains a sample, but the container does have a Tareweight, then return False (no need to CalibrateContaienr if Tareweight is known already) *)
						{Automatic,_,ObjectP[Object[Sample]],GreaterEqualP[0*Gram],_,_}, False,

						(* if CalibrateContainer is Automatic, and TransferContainer not specified, and the input container does NOT have a Tareweight, and the sample it contains has a weight that we trust, then return True *)
						{Automatic,_,ObjectP[Object[Sample]],Null,GreaterEqualP[0*Gram],True},True,

						(* if CalibrateContainer is Automatic, and TransferContainer not specified, and the input container does not have a Tareweight, and we don't trust the sample's weight (is also False if we don't know the weight at all), then return False *)
						{Automatic,_,ObjectP[Object[Sample]],GreaterEqualP[0*Gram],_,False},False,

						(* a catch-all for any other nonsense combination *)
						_,False

					];

					(* 2) Resolve TransferContainer *)
					(* Importantly: use the resolved calibrateContainer here and not the userspecified value *)
					{transferContainer,tareWeightNeededError}=Switch[{specifiedTransferContainer,calibrateContainer,sample,tareWeight,sampleWasMovedQ,tareWeightFromModel},

						(* if TransferContainer is userspecified as Null and CalibrateContainer is False, and there is a sample, and we don't have the Tareweight of the input container nor the model container, we can't proceed, need to throw error *)
						{Null,False,ObjectP[Object[Sample]],Except[GreaterEqualP[0*Gram]],_,Except[GreaterEqualP[0*Gram]]}, {specifiedTransferContainer,True},

						(* in all other cases that TransferContainer is Null, we're fine *)
						{Null,_,_,_,_,_}, {specifiedTransferContainer,tareWeightNeededError},

						(* if TransferContainer is userspecified to an object or model container, we will use that - we've already thrown any errors above if the specified container contains a sample or if there is no content to be transferred *)
						{ObjectP[{Object[Container],Model[Container]}],_,_,_,_,_}, {specifiedTransferContainer,tareWeightNeededError},

            (* If TransferContainer is Automatic, and there was a sample that was moved to a different container by the SamplePrep experiments, then we will definitively have a tare-weight, thus we do not need a TransferContainer *)
            (* This is since the SampleManipulation will enqueue a MeasureWeight which will first tare the container, then transfer. *)
            (* need to check for this separately, since the simulatedContainer does not have a tareweight yet so it will fall through the cracks in the next Switch statement *)
            {Automatic,_,ObjectP[Object[Sample]],_,True,_}, {Null,tareWeightNeededError},

						(* if TransferContainer is Automatic, and CalibrateContainer resolved to False, the input container has contents, and neither the container's TareWeight nor the model's TareWeight is unknown, we will need a TransferContainer *)
						{Automatic,False,ObjectP[Object[Sample]],Except[GreaterEqualP[0*Gram]],_,Except[GreaterEqualP[0*Gram]]}, {getStockedTransferContainer[inputContainerModel],tareWeightNeededError},

						(* in all other cases we'll not transfer *)
						{Automatic,_,_,_,_}, {Null,tareWeightNeededError},

						(* a catch-all for any other nonsense combination *)
						_,{Null,tareWeightNeededError}

					];

					(* 3) Resolve Instrument *)

					(* For this we need the PreferredBalance information. Now that we have resolved TransferContainer, we know which container is going to be measured - we'll get PreferredBalance (which is BalanceModeP), from either the input container, of the transferContainer, if specified or resovled to !!! *)
					preferredBalance=Switch[{specifiedTransferContainer,transferContainer},

						(* If the transferContainer was specified to a container or model, we can grab PreferredBalance from the transferContainerPreferredBalancePackets *)
						{ObjectP[{Object[Container],Model[Container]}],_}, transferContainerPreferredBalance,

						(* If the transferContainer was resolved to a container or model, we need to Download here from it. Alternatively one could store a hardcoded list for all available container models but that is suboptimal *)
						{Automatic|Null,ObjectP[Model[Container]]}, Download[transferContainer,PreferredBalance,Date->Now],

						(* If the transferContainer was Null to begin with or was resolved to it, we don't have one, use the preferredBalance from the input container *)
						{_,Null}, inputContainerPreferredBalance

					];

					(* determine the container model that will be weighed. This could be the transferContainer OR the inputContainer !!! *)
					modelContainerThatWillBeWeighed=Switch[{specifiedTransferContainer,transferContainer},

						(* If the transferContainer was specified to a container or model, we can grab Model from the transferContainerPreferredBalancePackets *)
						{ObjectP[{Object[Container],Model[Container]}],_}, Lookup[transferContainerPrefBalancePacket,Object],

						(* If the transferContainer was resolved, then we know for sure it's a Model, just take that *)
						{Automatic|Null,ObjectP[Model[Container]]},transferContainer,

						(* If the transferContainer was Null to begin with or was resolved to it, we don't have one, use the model from the input container *)
						(* If for some odd reason the container does not have a Model, it will be Null *)
						{_,Null},If[MatchQ[inputContainerModelPacket,{}],Null,Lookup[inputContainerModelPacket,Object]],

						(* else, something went wrong. Put Null here, it will resolve the instrument to Null *)
						_, Null

					];

					(* Resolve instrument with the help of preferredBalance (remember, this is Mode and not actual Object/Model). *)
					(* Importantly: use the resolved calibrateContainer and transferContainer here and not the userspecified values for CalibrateContainer and TransferContainer *)
					instrument = Switch[{specifiedInstrument,preferredBalance,sample,trustBool,specifiedInstrumentMode,transferContainer,modelContainerThatWillBeWeighed,inSitu},

						(* If InSitu is True, try to get the instrument the balance is on, if Null is returned, generate an error *)
						{_,_,_,_,_,_,_,True},
							getSuitableBalance[inputContainerPacket,preferredBalance,Null,False,inSitu],

						(* If for some reason we could not get the model of the container to be weighed, need to return Null no matter what, sicne something went clearly wrong *)
						{_,_,_,_,_,_,Null,_},
							Null,

						(* If Automatic, and we don't have a PreferredBalance, leave Instrument Null since we need to do a scout balance round first, and we'll populate the instrument later *)
						{Automatic,Null,_,_,_,_,_,_},
							Null,

						(* If Automatic, and we have a PreferredBalance plus we don't have a sample inside the input container, get the suitable balance *)
						{Automatic,BalanceModeP,Null,_,_,_,_,_},
							getSuitableBalance[inputContainerPacket,preferredBalance,Null,False,inSitu],

						(* If Automatic, and we have a PreferredBalance plus we have a sample inside whose mass we don't know or don't trust, get the suitable balance *)
						{Automatic,BalanceModeP,ObjectP[Object[Sample]],False,_,_,_,_},
							getSuitableBalance[inputContainerPacket,preferredBalance,Null,False,inSitu],

						(* If Automatic, and we have a PreferredBalance plus we have a sample inside whose mass we trust, get the suitable balance by looking at the weight *)
						{Automatic,BalanceModeP,ObjectP[Object[Sample]],True,_,_,_,_},
							getSuitableBalance[inputContainerPacket,preferredBalance,sampleWeight,trustBool,inSitu],

						(* If userspecified to Macro/Analytical/Bulk but we know that preferredBalance was Null, we need to throw UnsuitableBalance error *)
						{Except[Automatic],Null,_,_ ,_,_,_,_},
							(
								unsuitableBalanceError = True;
								specifiedInstrument
							),

						(* If userspecified to Macro/Analytical/Bulk and we have a preferredBalance, we will check whether userspecified Model instrument (!!! do not just check the specified instrument !!!) is the same that we would have resolved to; if not, need to throw UnsuitableBalance error *)
						{Except[Automatic],BalanceModeP,_,_,(Macro|Analytical|Bulk),_,_,_},
							If[MatchQ[specifiedInstrumentModel,getSuitableBalance[inputContainerPacket,preferredBalance,sampleWeight,trustBool,inSitu]],
						specifiedInstrument,
								(
									unsuitableBalanceError = True;
									specifiedInstrument
								)
							],

						(* If userspecified to Micro, and we don't have a TransferContainer, and the input container model is not  "2mL Glass CE Vials" or "Micro Glass Sample Vial", throw the appropriate error *)
						{Except[Automatic],_,_,_,Micro,Null,Except[Alternatives@@microBalanceAllowedContainers],_},
							(
								containerIncompatibleWithBalanceError = True;
								specifiedInstrument
							),

						(* If userspecified to Micro, in all other cases, we're good - we have a TransferContainer or the allowed input containers, and/or we've thrown an error already above if the sample weight is known and above the threshold *)
						{Except[Automatic],_,_,_,Micro,_,_,_},
							specifiedInstrument,

						(* a catch-all for any other nonsense combination, put Instrument to Null *)
						_,
							Null
					];

					(* If we triggered the unsuitableBalanceError, then collect here the recommended balance, we will use this in the error we throw post-option-resolution *)
					recommendedBalance=If[MatchQ[unsuitableBalanceError,True],
						getSuitableBalance[inputContainerPacket,preferredBalance,sampleWeight,trustBool,inSitu],
						Null
					];

					(* Gather MapThread results *)
					{transferContainer,calibrateContainer,instrument,tareWeightNeededError,unsuitableBalanceError,containerIncompatibleWithBalanceError,preferredBalance,recommendedBalance}
				]
			],
			{samplePackets,inputContainerPackets,inputContainerModelPackets,transferContainerPreferredBalancePackets,simulatedIndexMatchedSamples,mapThreadFriendlyOptions,latestSampleWeights,sampleWeightCanBeTrustedBool,specifiedBalanceType,instrumentPackets,sampleMovedQ}
		]
	];

	(*-- POST OPTION RESOLUTION ERROR CHECKING --*)

	(* 1) TareWeightNeeded Error *)

	(* Check for unsuitableBalanceErrors and throw the corresponding Error if we're throwing messages, and keep track of the InvalidOption *)
	tareWeightNeededOptions=If[Or@@tareWeightNeededErrors&&messages,
		Message[Error::TareWeightNeeded,ObjectToString[PickList[simulatedContainers,tareWeightNeededErrors],Cache->simulatedCache]];
		{TransferContainer},
		{}
	];

	(* Create the corresponding test for the unsuitableBalanceErrors if we're collecting tests *)
	tareWeightNeededTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedContainers,tareWeightNeededErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", TransferContainer is set to Null when the input container is empty or has a tareweight:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" TransferContainer is set to Null when the input container is empty or has a tareweight:",True,True],
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

	(* 2) UnsuitableBalance Error *)

	(* Check for unsuitableBalanceErrors and throw the corresponding Error if we're throwing messages, and keep track of the InvalidOption *)
	unsuitableBalanceOptions=If[Or@@unsuitableBalanceErrors&&messages,
		Message[Error::UnsuitableBalance,ObjectToString[PickList[simulatedContainers,unsuitableBalanceErrors,True],Cache->simulatedCache],ObjectToString[PickList[instruments,unsuitableBalanceErrors,True],Cache->simulatedCache],ObjectToString[PickList[recommendedBalances,unsuitableBalanceErrors,True],Cache->simulatedCache]];
		{Instrument},
		{}
	];

	(* Create the corresponding test for the unsuitableBalanceErrors if we're collecting tests *)
	unsuitableBalanceTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedContainers,unsuitableBalanceErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", the option Instrument is specified to a suitable balance:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" the option Instrument is specified to a suitable balance:",True,True],
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


	(* 3) ContainerIncompatibleWithBalance Error *)

	(* Check for unsuitableBalanceErrors and throw the corresponding Error if we're throwing messages, and keep track of the InvalidOption *)
	containerIncompatibleWithBalanceOptions=If[Or@@containerIncompatibleWithBalanceErrors&&messages,
		Message[Error::ContainerIncompatibleWithBalance,ObjectToString[PickList[simulatedContainers,containerIncompatibleWithBalanceErrors,True],Cache->simulatedCache],ObjectToString[PickList[instruments,containerIncompatibleWithBalanceErrors,True],Cache->simulatedCache],ObjectToString[microBalanceAllowedContainers,Cache->simulatedCache]];
		{Instrument},
		{}
	];

	(* Create the corresponding test for the unsuitableBalanceErrors if we're collecting tests *)
	containerIncompatibleWithBalanceTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedContainers,containerIncompatibleWithBalanceErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedContainers,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[failingInputs,Cache->simulatedCache]<>", the option Instrument is specified to Microbalance while the input container type is "<>ObjectToString[microBalanceAllowedContainers,Cache->simulatedCache]<>" or TransferContainer is specified:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input container(s) "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" the option Instrument is specified to Microbalance while the input container type is "<>ObjectToString[microBalanceAllowedContainers,Cache->simulatedCache]<>" or TransferContainer is specified:",True,True],
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

	(* 4) Ventilated Sample Error *)
	(* We can't use transfer containers if the sample is ventilated since this transfer won't be done in a fumehood *)
	invalidTransferSamples=MapThread[
		If[MatchQ[#2,ObjectP[]&&TrueQ[Lookup[#1,Ventilated]]],
			#1,
			Nothing
		]&,
		{samplePackets,transferContainers}
	];

	(* Throw a message if any of our samples are ventilated and need to be transferred *)
	If[!MatchQ[invalidTransferSamples,{}]&&!gatherTests,
		Message[Error::VentilatedSamples,ObjectToString[invalidTransferSamples,Cache->simulatedCache]];
	];

	invalidTransferSampleTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[samplePackets,invalidTransferSamples];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test[ObjectToString[invalidTransferSamples,Cache->simulatedCache]<>" can be safely transferred into a new container as they do not have to be handled in a fume hood:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test[ObjectToString[passingInputs,Cache->simulatedCache]<>" can be safely transferred into a new container as they do not have to be handled in a fume hood:",True,True],
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

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,incompatibleContainerInputs,immobileContainers,invalidTransferSamples (*,invalidSamplePrepContainers *)}]];
	invalidOptions=DeleteDuplicates[Flatten[{sampleMassUnknownOptions,conflictingTransferCalibrateOptions,noContentsToBeTransferredOptions,transferContainerNotEmptyOptions,unsuitableMicroBalanceOptions,
		tareWeightNeededOptions,unsuitableBalanceOptions,containerIncompatibleWithBalanceOptions,inSituTransferContainerInvalidOptions,
		inSituInvalidOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs and we're throwing messages. *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options and we're throwing messages. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve TargetContainers and TargetSampleGroupings *)
	(* No grouping necessary since we deal with one sample after the other. No TargetContainer since we don't move the sample unless the user specified it. *)
	(* Note that TransferContainer is a different thing - we do NOT want to make a new ID when we need to move the sample when the TareWeight of the container is unknown, thus TargetContaienr is handled without SampleManipulation and within MeasureWeight procedure *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentMeasureWeight,
			myContainers,
			simulatedContainers,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			(* we don't have any restriction on what can be aliquotted *)
			RequiredAliquotAmounts -> Null,
			AliquotWarningMessage -> Null,
			AllowSolids->True,
			Cache->simulatedCache,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMeasureWeight,
				myContainers,
				simulatedContainers,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				(* we don't have any restriction on what can be aliquotted *)
				RequiredAliquotAmounts -> Null,
				AliquotWarningMessage -> Null,
				AllowSolids->True,
				Cache->simulatedCache,
				Output->Result
			],
			{}
		}
	];

	(*-- CONSTRUCT THE RESOLVED OPTIONS AND TESTS OUTPUTS --*)
	(* pull out all the shared options from the input options *)
	{name, confirm, template, samplesInStorageCondition, cache, operator, parentProtocol, upload, outputOption, email, numberOfReplicates} = Lookup[myOptions, {Name, Confirm, Template, SamplesInStorageCondition, Cache, Operator, ParentProtocol, Upload, Output, Email, NumberOfReplicates}];

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

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* construct the final resolved options. We don't collapse here - that is happening in the main function *)
	resolvedOptions = ReplaceRule[measureWeightOptions,
		Join[
			{
				TransferContainer -> transferContainers,
				Instrument -> instruments,
				CalibrateContainer -> calibrateContainers,
				NumberOfReplicates -> numberOfReplicates,
				InSitu -> inSitu,
				Confirm -> confirm,
				Name -> name,
				Template -> template,
				SamplesInStorageCondition -> samplesInStorageCondition,
				Cache -> cache,
				Email -> resolvedEmail,
				Operator -> operator,
				Output -> outputOption,
				ParentProtocol -> parentProtocol,
				Upload -> upload
			},
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		]
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			invalidSamplePrepTests,
			discardedTests,
			immobileContainerTests,
			incompatibleContainerTests,
			conflictingTransferCalibrateTests,
			sampleMassUnknownTests,
			noContentsToBeTransferredTests,
			transferContainerNotEmptyInputTests,
			unsuitableMicroBalanceTests,
			tareWeightNeededTests,
			unsuitableBalanceTests,
			containerIncompatibleWithBalanceTests,
			invalidTransferSampleTests,
			aliquotTests
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
	(* Return our resolved options and/or tests, as desired *)
	outputSpecification/. {resultRule,testsRule}
];



(* ::Subsubsection:: *)
(* measureWeightResourcePackets (private helper)*)


DefineOptions[
	measureWeightResourcePackets,
	Options:>{HelperOutputOption,CacheOption}
];

(* Private function to generate the list of protocol packets containing resource blobs needing for running the procedure *)
measureWeightResourcePackets[myContainers:{ObjectP[Object[Container]]...},myUnresolvedOptions:Alternatives[{_Rule..},{}],myResolvedOptions:{_Rule..},myResourcePacketOptions:OptionsPattern[measureWeightResourcePackets]]:=Module[
	{outputSpecification,output,gatherTests,messages,expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,inheritedCache,
	instruments,listedContainerContents,listedSamples,indexMatchedOptions,indexMatchedOptionsWithAliquotContainer,invalidPositions,listedSamplesNoNull,resolvedOptionsNoNull,
	simulatedSamples,simulatedSamplesNoNull,simulatedCacheNoNull,simulatedCache,metaContainerPackets,
	transferContainerObjects,transferContainerModels,availableHolders,transferContainerObjectPackets,
	transferContainerModelPackets,holderPackets,containerPackets,samplePackets,instrumentPackets,numReplicates,numReplicatesNoNull,containersIn,
	containersInResources,containersInResourcesExpanded,containsSampleBool,simulatedContainers,containersInExpanded,containerToResourceRule,
  samplesIn,fakeSample,modes,balance,scoutbalance,balanceType,transferContainers,sampleState,sampleVolume,containerMaxVolume,testVolume,pipette,
	pipetteTips,weighPaper,weighBoat,analyteModelContainerPacket,selfStandingBool,analyteContainerModel,analyteContainerFootprint,availableHolderFootprints,openHolderFootprintQ,defaultOpenHolder,
		holders,commonContainerHolderRule,holderResources,commonInstrumentRule,commonSampleRule,balanceResources,scoutBalanceResources,pipetteResources,
	weighBoatResources,weighPaperResources,pipetteTipResources,transferResources,calibrateContainer,gatheringTimeEstimate,weighingTimeEstimate,
	postProcessingTimeEstimate,returningTimeEstimate,selfStanding,index,expScoutBalanceResources,expBalanceResources,expPipetteResources,expPipetteTipResources,
	expWeighPaperResources,expWeighBoatResources,expTransferResources,expCalibrateContainer,expHolderResources,fieldsToBeGrouped,
	sortingIndexRules,sortingIndex,sortedFields,sortedFieldsWithIndex,keys,indexMatchedKeys,analyteMetaContainerModels,
	batchingField,scoutBalancesSorted,scoutBalancesBatchLength,remainingBatchesLengths,batchingLengths,inSitu,
	protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureWeight, {myContainers}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMeasureWeight,
		RemoveHiddenOptions[ExperimentMeasureWeight, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* get the cache that was passed from the main function *)
	inheritedCache= Lookup[ToList[myResourcePacketOptions],Cache,{}];

	(* get the instruments that we resolved to so that we can download the mode *)
	instruments = Lookup[expandedResolvedOptions,Instrument];

	(* determine whether this will be InSitu or not *)
	inSitu = Lookup[expandedResolvedOptions,InSitu];

	(* Get the contents of the containers - need them now so that we can do the sampleSimulation (simulateSamplesResourcePackets helper, see below) *)
	listedContainerContents=Download[myContainers,
		Contents[[All,2]][Object],
		Cache->inheritedCache,
		Date->Now
	];

	(* get a flat sample list, index-matched to myContainers. For empty containers, we put Null. Whenever there are multiple samples (for instance for plates), we take the first sample - we will have thrown invalid input error already or these anyways *)
	listedSamples=Map[
		If[MatchQ[#,{}],
		Null,
		First[#]
	]&,
	listedContainerContents];

	(* get the simulated contaienrs so that we can download some things we need from those *)
	{simulatedContainers,simulatedCache}=simulateSamplesResourcePackets[ExperimentMeasureWeight,myContainers,expandedResolvedOptions,Cache->inheritedCache];

	(* get the transferContainer from the options so we can download from it *)
	transferContainers=Lookup[expandedResolvedOptions,TransferContainer];

	(* let's get the transfer container, if specified *)
	transferContainerObjects=If[MatchQ[#,ObjectP[Object[Container]]],
		#,
		Null]&/@transferContainers;

	(* let's get the transfer container, if specified *)
	transferContainerModels=If[MatchQ[#,ObjectP[Model[Container]]],
		#,
		Null]&/@transferContainers;

	(* make a of container racks that we currently support to utilize for non-selfstanding containers during the weighing process *)
	(* non-selfstanding containers include: Conical15mL tube, Conical50mL tube and some micro tubes. Here we find all of them by adding Search condition TareWeight!=Null *)
	availableHolders = Search[Model[Container, Rack], TareWeight!=Null&&Deprecated!=True];

	(* using the simulated cache and the simulated samples, download the things we need to create our resource below *)
	(* we may need to get SelfStandingContainers from the db since it is not in the cache if we resolve a transfer container model *)
	{
		listedContainerContents,
		containerPackets,
		samplePackets,
		metaContainerPackets,
		instrumentPackets,
		transferContainerObjectPackets,
		transferContainerModelPackets,
		holderPackets
	}=Quiet[Download[
		{
			myContainers,
      simulatedContainers,
			simulatedContainers,
			simulatedContainers,
      instruments,
			transferContainerObjects,
			transferContainerModels,
			availableHolders
		},
		{
			{Contents[[All,2]][Object]},
      {Packet[Model[{MaxVolume,SelfStanding,Footprint}]]},
      {Packet[Contents[[All,2]][{State,Volume}]]},
			{Packet[Container[Model]]},
      (* mode is in both the instrument object and model, so no need to do fancy splitting here *)
		  {Packet[Mode]},
			{Packet[Model[{SelfStanding,Footprint}]]},
			{Packet[SelfStanding,Footprint]},
			{Packet[Positions,TareWeight,Dimensions, Objects]}
		},
		Cache->simulatedCache,
		Date->Now
	],
		Download::MissingCacheField
	];

	(* get a flat sample list, index-matched to myContainers. For empty containers, we put Null. Whenever there are multiple samples (for instance for plates), we take the first sample - we will have thrown invalid input error already or these anyways *)
	listedSamples=Map[
		If[MatchQ[#,{}],
			Null,
			First[#]
		]&,
		Flatten[listedContainerContents,1]];

	(* === Make resources for SamplesIn and ContainersIn === *)

	(* get the number of replicates so that we can expand the fields (samplesIn etc.) accordingly  *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates=Lookup[expandedResolvedOptions,NumberOfReplicates];
	numReplicatesNoNull =numReplicates /. {Null -> 1};

  (* make resources for the ContainersIn - do not add the Link here since we'll use it below in one-way and two-way links in the ContainersIn and the batched field *)
  (* Note: do NOT use the simulated containers here, use the original containers that the user gave us *)
  containersInResources=Map[Resource[Sample->#,Name->ToString[Unique[]]]&,DeleteDuplicates[myContainers]];

  (* construct the ContainersInExpanded field which needs to contain resources as well, make sure to replace them with the identical resources that we have in the unique conatinersInResources *)
  containersInExpanded=Flatten[Map[ConstantArray[#,numReplicatesNoNull]&,myContainers]];
  containerToResourceRule=MapThread[(#1->#2)&,{DeleteDuplicates[myContainers],containersInResources}];
  containersInResourcesExpanded=containersInExpanded/.containerToResourceRule;

	(* get the SamplesIn (expanded by NumberOfReplicates) in from the sample's containers; note that we are NOT using the simulated samples for these *)
	(* We're not making resources of these since we're not resource-picking them, we have ContainersIn for that, but we need to link them *)
	samplesIn = Flatten[Map[ConstantArray[#, numReplicatesNoNull]&,listedSamples]];

	(* Get the Balance mode from the instrument packet *)
	modes=Map[
		If[NullQ[#],
			Null,
			Lookup[#,Mode]]&,
		Flatten[instrumentPackets,1]
	];

	(* from the resolved instrument and the resolved instrument mode, determine the scoutbalance, balance, and balanceType *)
	{balance,scoutbalance,balanceType}=Transpose@MapThread[
		Function[{instrument,mode},
			Switch[instrument,
				(* if Instrument option is specified or resolved to instrument, then we use that for balance, and we need no scout balance *)
				ObjectReferenceP[{Model[Instrument],Object[Instrument]}],{instrument,Null,mode},
				(* if instrument is Null, we need the scout balance ("D31P60BL" - floor standing, up to 60 Kg) and we also don't have a mode yet *)
				Null,{Null,Model[Instrument,Balance,"id:aXRlGn6V7Jov"],Null}
			]
		],
		{instruments,modes}
	];

	(* check what status the sample is in (be wary of the Nulls for empty Containers) *)
	sampleState=Map[
		If[NullQ[#],
			Null,
			Lookup[#,State]]&,
	Flatten[samplePackets,1]
	];

	(* get the volume of the sample (be wary of the Nulls for empty Containers) *)
	sampleVolume=Map[
		If[NullQ[#],
			Null,
			Lookup[#,Volume]
		]&,
	Flatten[samplePackets,1]
	];

	(* get the MaxVolume of the container that the sample is in *)
	containerMaxVolume=Map[
		If[NullQ[#],
			Null,
			Lookup[#,MaxVolume]
		]&,
	Flatten[containerPackets,1]
	];

	(* For all samples that are liquid, make sure we have a volume that we can use to determine the appropriate pipette and tips when needed *)
	testVolume = MapThread[
		Function[{sampVol,contVol,state},
			If[MatchQ[state,Liquid],
				Which[
					(* If sample volume is specified use that to determine pipette *)
					VolumeQ[sampVol], sampVol,
					(* If sample volume is unspecified, but container volume is then use that to determine pipette *)
					VolumeQ[contVol], contVol,
					(* If both volumes are not specified then use very large volume to get largest pipette *)
					True, 10000 Micro Liter
				],
				Null
			]
		],{sampleVolume,containerMaxVolume,sampleState}
	];

	(* determine the pipette, tips, and weighpaper depending on the state of the sample and whether we're transferring or not*)
	(* note that in cases we're transferring, we always get a weigh paper no matter what the state, since also liquid samples could be solid after lyophilization so we let the operator decide at experiment time *)
	{pipette,pipetteTips,weighPaper}=Transpose[MapThread[
		Function[{state,volume,transfer},
			Switch[{state,volume,transfer},

				(* if we don't have a transfer container, we don't need any weighing resources *)
				{_,_,Null},{Null,Null,Null},

				(* if we're dealing with a liquid and the volume is below or equal to 2.5 Microliter, get P2.5 pipet and "0.1 - 10 uL Tips, Low Retention, Non-Sterile" pipet tips. *)
				{Liquid,LessEqualP[2.5*Microliter],_},{Model[Instrument,Pipette,"id:54n6evLmRbaY"],Model[Item, Tips, "id:8qZ1VW0Vx7jP"],Model[Item,Consumable,"id:3em6Zv9Njj5W"]},

				(* if we're dealing with a liquid and the volume is below or equal to 20 Microliter, get P20 pipet and "Olympus 20 ul Filter tips, sterile" pipet tips. *)
				{Liquid,LessEqualP[20*Microliter],_},{Model[Instrument,Pipette,"id:n0k9mG8Pwod4"],Model[Item,Tips,"id:rea9jl1or6YL"],Model[Item,Consumable,"id:3em6Zv9Njj5W"]},

				(* if we're dealing with a liquid and the volume is below or equal to 200 Microliter, get P200 pipet and "Olympus 200 ul tips, sterile" pipet tips. *)
				{Liquid,LessEqualP[200*Microliter],_},{Model[Instrument,Pipette,"id:01G6nvwRpbLd"],Model[Item,Tips,"id:P5ZnEj4P88jR"],Model[Item,Consumable,"id:3em6Zv9Njj5W"]},

				(* if we're dealing with a liquid and the volume is below or equal to 1000 Microliter, get P1000 pipet and "1000 ul reach tips, sterile" pipet tips *)
				{Liquid,LessEqualP[1000*Microliter],_},{Model[Instrument,Pipette,"id:1ZA60vL547EM"],Model[Item,Tips,"id:n0k9mGzRaaN3"],Model[Item,Consumable,"id:3em6Zv9Njj5W"]},

				(* if we're dealing with a liquid and the volume is above 1000 Microliter, get P5000 pipet and "D5000 TIPACK 5 ml tips" pipet tips *)
				{Liquid,GreaterP[1000*Microliter],_},{Model[Instrument,Pipette,"id:KBL5Dvw6eLDk"],Model[Item,Tips,"id:mnk9jO3qD6R7"],Model[Item,Consumable,"id:3em6Zv9Njj5W"]},

				(* if we're dealing with a solid, we don't any Pipette and tips but we do need weigh paper *)
				_,{Null,Null,Model[Item,Consumable,"id:3em6Zv9Njj5W"]}

		]],
	{sampleState,testVolume,transferContainers}]
	];

	(* Determine whether we need an aluminium weighboat. Only need one, if we are transferring, and the balance is micro - we don't care whether sample is liquid or solid as sometimes after lyophilization it is solid. So we need to ask operator to make decision at run time.*)
	weighBoat=MapThread[
		If[NullQ[#1],
			Null,
			If[MatchQ[#2, Micro],
				(* "Aluminum Round Micro Weigh Dish" *)
				Model[Item,WeighBoat,"id:7X104vn4qJkw"],
				Null
			]
		]&,
	{transferContainers,balanceType}
	];

	(* for determining the container holders we may need, first figure out which container we're actually weighing - if we have a transfer container, it's going to be that, if not, it's going to be the input container *)
	(* note that these are packets from the model container since we want the Model and the SelfStanding field from that *)
	analyteModelContainerPacket=Flatten[MapThread[
		If[!NullQ[#1],
			If[MatchQ[#,ObjectP[Object[Container]]],
				#2,
				#3],
			#4]&,
		{transferContainers,transferContainerObjectPackets,transferContainerModelPackets,containerPackets}
	],1];

	(* get the SelfStanding flag and the model of the analyte container *)
	selfStandingBool = Lookup[analyteModelContainerPacket,SelfStanding];
	analyteContainerModel = Lookup[analyteModelContainerPacket,Object];
	analyteContainerFootprint = Lookup[analyteModelContainerPacket,Footprint];

	(* get the meta container model, if we're InSitu there should be no TransferContainer so just look at the sample container's container *)
	analyteMetaContainerModels = Download[FirstCase[metaContainerPackets,Download[Lookup[#,Container],Object]],Object]&/@containerPackets;

	(* get information about the holders *)
	(* Foorprint information *)
	availableHolderFootprints=Lookup[Flatten[Lookup[#,Positions],1],Footprint]&/@holderPackets;

	(* Get the holder that has an Open Footprint *)
	openHolderFootprintQ = Map[
	    MemberQ[#,Open]&,
	    availableHolderFootprints
	];
	defaultOpenHolder = FirstOrDefault[
	    PickList[availableHolders,openHolderFootprintQ]
	];

	(* If the container is not SelfStanding, and we find a holder for it, we will need a holder, otherwise, this is Null *)
	holders=MapThread[
		Function[{selfStanding,containerModel,containerFootprint,metaContainerModel},
			If[inSitu,
				(* If we are InSitu, just pick the rack it is in, if it's currently in a rack at all *)
				If[MatchQ[metaContainerModel,ObjectP[Object[Container,Rack]]],
					metaContainerModel,
					Null
				],

				(* If we're not InSitu, resolve a holder if necessary *)
				If[MatchQ[selfStanding,False],

					Module[
						{footprintCompatibleQ,specifiedHolder,bestHolder},
						footprintCompatibleQ=Map[
							MemberQ[#,containerFootprint]&,
							availableHolderFootprints
						];

						(* if the container has a specific holder it's supposed to use to stand, then use that one *)
						specifiedHolder=Quiet[rackFinder[containerModel]];

						If[MatchQ[specifiedHolder,ObjectP[]],Return[specifiedHolder,Module]];

						(* otherwise use the best guess *)
						bestHolder=If[MemberQ[footprintCompatibleQ,True],
							(* If we get a compatible footprint *)
							Module[{tareWeight,models,objects,holdersArrayToSort,suitableHolders,sortedByWeight,threshold,objectNumbersAssos},

								(* list of tare weight *)
								tareWeight=Flatten[Lookup[#,TareWeight]&/@holderPackets];

								(* list of racks models *)
								models=Flatten[Lookup[#,Object]&/@holderPackets];

								(* list with number of objects of this model *)
								objects=Flatten[Length[Lookup[#,Objects][[1]]]&/@holderPackets];

								(* combine tare weight, models, and  number of model's objects together *)
								holdersArrayToSort=Transpose[{tareWeight,models, objects}];

								(* filter by compatible footprint *)
								suitableHolders=PickList[holdersArrayToSort,footprintCompatibleQ];

								(*  sort out by tare weight: from the smallest  *)
								sortedByWeight=SortBy[suitableHolders, First];

								(* 5% from the max number - we are going to filter out all model that has smaller number of objects*)
								threshold=Max[sortedByWeight[[All, 3]]]*0.05;

								(* create assosiation to filter by the number of model's objects*)
								objectNumbersAssos=Association@MapThread[Rule[#1, #2] &, {sortedByWeight[[All, 2]], sortedByWeight[[All, 3]]}];

								(* take first model after removing 5% *)
								First@Keys@Select[objectNumbersAssos, # > threshold&]
							],
							(* otherwise, fill in with the default rack *)
							defaultOpenHolder
						]
					],
					Null
				]
			]
		],
		{selfStandingBool,analyteContainerModel,analyteContainerFootprint,analyteMetaContainerModels}
	];

	(* helper that constructs a rule for replacing identical instrument objects or models with a unique resource so that we don't resource-pick unnecessarily many instruments (keep Null as is) *)
	(* This can be used to make the resources of the scoutbalance, balance, and pipette *)
	commonInstrumentRule[objects:{(ObjectP[{Model[Instrument],Object[Instrument]}]|Null)..},field_]:=MapThread[
		If[NullQ[#1],
			Nothing,
			(* The Time is calculated by the number of replicates times the count of how many objects need this instrument *)
			(* In the case of ScoutBalance and Pipette though we will only need that instrumment once, so Time is only calculated by the count of objects and not NumberOfReplictes *)
			(#1->Link[Resource[Instrument -> #1, Time -> If[MatchQ[field,Balance],(#2*numReplicatesNoNull*5*Minute),(#2*5*Minute)],Name->ToString[Unique[]]]])
		]&,
		(* the first item is the object, the second is the number of objects that are identical (to calculate the time estimate) *)
		Transpose[Tally[objects]](*{Tally[objects][[All,1]],Tally[objects][[All,2]]}*)
	];

	(* helper that constructs a rule for replacing identical counted consumable objects or models with a unique resource so that we don't resourcepick unnecessarily many samples (keep Null as is) *)
	(* This can be used to make the resources of the weighboat and the weighpaper *)
	commonSampleRule[objects:{(ObjectP[{Model[Sample], Object[Sample],Object[Item],Model[Item]}]|Null)..}]:=MapThread[
		If[NullQ[#1],
			Nothing,
			(* The Amount is calculated by the number of replicates times the count of how many objects need this Resource *)
			(#1 -> Link[Resource[Sample -> #1, Amount-> (#2*numReplicatesNoNull),Name->ToString[Unique[]]]])
		]&,
		(* the first item is the object, the second is the number of objects that are identical (to calculate the time estimate) *)
		Transpose[Tally[objects]](*{Tally[objects][[All,1]],Tally[objects][[All,2]]}*)
	];

	(* helper that constructs a rule for replacing identical container holders with a unique resource so that we don't resourcepick unnecessarily many holders (keep Null as is) *)
	commonContainerHolderRule[objects:{(ObjectP[{Object[Container],Model[Container]}]|Null)..}]:=MapThread[
		If[NullQ[#1],
			Nothing,
			(* The Amount is calculated by the number of replicates times the count of how many objects need this Resource *)
			(#1 -> Link[Resource[Sample -> #1, Name->ToString[Unique[]]]])
		]&,
		(* the first item is the object, the second is the number of objects that are identical (to calculate the time estimate) *)
		Transpose[Tally[objects]](*{Tally[objects][[All,1]],Tally[objects][[All,2]]}*)
	];

	(* make the resources using the helpers *)
	balanceResources = balance/.commonInstrumentRule[balance,Balance];
	scoutBalanceResources = scoutbalance/.commonInstrumentRule[scoutbalance,ScoutBalance];
	pipetteResources = pipette/.commonInstrumentRule[pipette,Pipette];
	weighBoatResources = weighBoat/.commonSampleRule[weighBoat];
	weighPaperResources = weighPaper/.commonSampleRule[weighPaper];
	(* TODO figure out why they were Untracked before in the old function and whether they should stay Untracked *)
	pipetteTipResources = pipetteTips/.commonSampleRule[pipetteTips];
	(* we only make a resource for the TransferContainer if we have a transferContainer, otherwise leave Null *)
	transferResources = If[NullQ[#],Null,Link[Resource[Sample->#, Name->ToString[Unique[]]]]]&/@transferContainers;
	holderResources = holders/.commonContainerHolderRule[holders];

	(* also get the calibrateContainer boolean from the options *)
	calibrateContainer = Lookup[expandedResolvedOptions,CalibrateContainer];

	(* === Estimate timing === *)

	(* Resource gathering of containers will only be necessary if this is not a subprotocol *)
	(* TODO optimize this depending on whether we have TransferContainer or not  *)
	gatheringTimeEstimate = If[(NullQ[Lookup[myResolvedOptions, ParentProtocol]] || MatchQ[Lookup[myResolvedOptions, ParentProtocol], None]),
		1 Minute * Length[myContainers],
		1 Minute
	];

	weighingTimeEstimate = 3 Minute * Length[myContainers] * numReplicatesNoNull;

	postProcessingTimeEstimate = If[TrueQ[Lookup[myResolvedOptions,ImageSample]],
		20 Minute,
		1 Minute
	];

	(* Returning materials will only be necessary if this is not a subprotocol *)
	returningTimeEstimate = If[(NullQ[Lookup[myResolvedOptions, ParentProtocol]] || MatchQ[Lookup[myResolvedOptions, ParentProtocol], None]),
		1 Minute * Length[myContainers],
		1 Minute
	];

	(* == Batching == *)

	(* we need an index inside the batching field telling us at which position inside the current batch we are for our Q functions determining whether we release the balances etc *)
	(* if we have 15 ContainersIn (the expanded list) then we'll have a list of {1,2,3,...15} *)
	index=Range[Length[containersInResourcesExpanded]];

	(* expand all the resources and fields for the Batching field according to NumberOfReplicates (which is a single) *)
	{expScoutBalanceResources,expBalanceResources,expPipetteResources,expPipetteTipResources,
		expWeighPaperResources,expWeighBoatResources,expCalibrateContainer,expHolderResources}=Flatten[
		ConstantArray[#,numReplicatesNoNull],
		1
	]&/@{scoutBalanceResources,balanceResources,pipetteResources,pipetteTipResources,weighPaperResources,weighBoatResources,calibrateContainer,holderResources};

	(* we only transfer the sample once if using a TransferContainer, thus we pad the transfer container with Nulls to expand. By padding right, we make sure the entry with the TransferContainer comes first *)
	(* expTransferResources=Flatten[Map[PadRight[#, numReplicatesNoNull, Null] &, ToList /@ transferResources]]; *)
	(* TODO turn this back off until I find a way of pulling out the TareData for the replicate measurements *)
	expTransferResources = Flatten[ConstantArray[transferResources, numReplicatesNoNull], 1];

	(* whenever we have replicates and a TransferContainer, make sure we're analyzing the TransferContainer in the replicate samples since we only transfer once *)
	(* this is a list of linked resources *)
	(* For example if we have {TC1, TC2, Null}, we would expand {c1,c2,c3} into {c1,TC1,c2,TC2,c3,c3} *)
	(* analytContainerResources=Flatten[
		MapThread[
			Function[{containerIn,transferContainer},
				If[!NullQ[transferContainer],
					PadRight[containerIn,numReplicatesNoNull,transferContainer],
					PadRight[containerIn,numReplicatesNoNull,containerIn]
				]
			],
		{ToList/@Map[Link[#]&,containersInResources],ToList/@transferResources}
		]
	]; *)

  sortingIndexRules = MapThread[Rule,{DeleteDuplicates[myContainers],Range[Length[DeleteDuplicates[myContainers]]]}];

  sortingIndex = containersInExpanded/.sortingIndexRules;

	(* transpose containers and its needed resources/fields so that we get list of the following shape {{workingcontainer, container,scout,balance.......}..} *)
	(* Note that for WorkingContainers we will use a list of Nulls which we will populate in the Execute function at the very beginning of the procedure (after SamplePrep)*)
	fieldsToBeGrouped = Transpose[{Table[Null,Length[containersInResourcesExpanded]],Map[Link[#]&,containersInResourcesExpanded],expScoutBalanceResources,expBalanceResources,expPipetteResources,expPipetteTipResources,expWeighPaperResources,expWeighBoatResources,expTransferResources,expHolderResources,expCalibrateContainer,sortingIndex}];

	(* Sort these lists by the Balance (expBalanceResources) the container needs (which is the fourth entry in these lists) *)
	(* This way the containers that need a scout balance are going to be listed first, since they have Null as the Balance *)
	sortedFields = SortBy[fieldsToBeGrouped,#[[4]]&];

	(* Append to each list an index {1,2,3,....} so that we now have a list like this: {{container,scout,balance.......,index}..}  *)
	sortedFieldsWithIndex = MapThread[
		Append[#1,#2]&,
	{sortedFields,index}
	];

	(* construct a list of the keys we want to have in the named multiple field for the batching*)
	keys = {WorkingContainerIn,ContainerIn,ScoutBalance,Balance,Pipette,PipetteTips,WeighPaper,WeighBoat,TransferContainer,Holder,CalibrateContainer,SortingIndex,Index};

	(* expand the keys so they indexmatch the sortedFields, also Transpose them so they indexmatch the sorted fields *)
	indexMatchedKeys = Transpose[Table[#, Length[sortedFieldsWithIndex]] & /@ keys];

	(* make the batching field *)
	batchingField=Association /@MapThread[
		Function[{key, objects},
			MapThread[Rule[#1, #2]&,
			{key,objects}]
			],
		{indexMatchedKeys,sortedFieldsWithIndex}
	];

	(* to do the partitioning and determine the length of each batch, we look at the scout balances (which is the second third in the batchingField) *)
	scoutBalancesSorted=Transpose[sortedFieldsWithIndex][[3]];

	(* for the first batch, get the number of samples that need scout balance (we want all these to be in the first batch so that we can compile once *)
	(* we need to look at the second level here since the balance resources are wrapped in Links *)
	scoutBalancesBatchLength=Length[Cases[scoutBalancesSorted,_Resource,2]];

	(* divide all the remaining entries into partitions of 25 (this will be an empty list if there is only scout balance entries) *)
	remainingBatchesLengths=Length/@PartitionRemainder[Take[scoutBalancesSorted,-(Length[scoutBalancesSorted]-scoutBalancesBatchLength)],25];

	(* now join the scouting batch number and the remaining batch numbers together, this list should look like {3, 25, 25, 25 ... 4} *)
	batchingLengths=If[scoutBalancesBatchLength==0,
		remainingBatchesLengths,
		Join[{scoutBalancesBatchLength},remainingBatchesLengths]
	];

	(* == Construct the protocol packet == *)


  protocolPacket = <|
		Object -> CreateID[Object[Protocol,MeasureWeight]],
		Type -> Object[Protocol, MeasureWeight],
		Replace[SamplesIn]->Map[
			If[NullQ[#],
        Null,
				Link[Resource[Sample->#],Protocols]
			]&,
			samplesIn
		],
		Replace[ContainersIn]->Map[Link[#,Protocols]&,DeleteDuplicates[containersInResources]],
		Replace[ContainersInExpanded]->Map[Link[#]&,containersInResourcesExpanded],
		InSitu->inSitu,
		NumberOfReplicates->numReplicates,
		ResolvedOptions->resolvedOptionsNoHidden,
		UnresolvedOptions->myUnresolvedOptions,

		(* -- MeasureWeight specific options -- *)
		Replace[Batching] -> batchingField,
		Replace[BatchingLengths]-> batchingLengths,
		Replace[Checkpoints] -> {
        {"Preparing Samples", 0*Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> 0*Minute]},
				{"Picking Resources", gatheringTimeEstimate, "Samples and materials required to execute this protocol are gathered from storage.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> gatheringTimeEstimate]},
				{"Weighing", weighingTimeEstimate, "The appropriate balance is selected and the sample is weighed.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> weighingTimeEstimate]},
				{"Sample Post-Processing",postProcessingTimeEstimate, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> postProcessingTimeEstimate]},
				{"Returning Materials", returningTimeEstimate, "Samples are returned to storage.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> returningTimeEstimate]}
		},
		Template -> Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated],
		ParentProtocol -> Link[Lookup[myResolvedOptions,ParentProtocol],Subprotocols],
		Name->Lookup[myResolvedOptions,Name],
	  Replace[SamplesInStorage]->Lookup[myResolvedOptions,SamplesInStorageCondition],
	  Replace[SamplesOutStorage]->Lookup[myResolvedOptions,SamplesOutStorageCondition],
	  Replace[AliquotStorage]->Lookup[myResolvedOptions,AliquotSampleStorageCondition]

	|>;

	(* generate a packet with the shared fields *)
	(* certainly do NOT want to replicate the sample prep fields if we have replicates (like obviously we don't want to mix/centrifuge twice on the same sample) *)
	sharedFieldPacket = populateSamplePrepFields[myContainers, expandedResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
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
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];



(* ::Subsubsection::Closed:: *)
(*trimInvalidOptions*)


(* ==== Helper that deletes indexmatched options for invalid input  *)
(* Input: input including the invalid stuff, the options that we want to get trimmed, the keys of the options that are indexmatched, and the invalid positions *)
(* Output: {validSamples, validOptons} -> the list of samples and the corresponding otpions with correctly indexmatching options when applicable *)


(* Get the options that were specified for the valid input*)
trimInvalidOptions[input:{(ObjectP[]|Null)..},optionsToBeTrimmed_,indexMatchedOptionKeys_List,invalidPositions_List]:=Module[
	{validInput,lengthOfInput,validOptions},

	(* Determine the valid input *)
	validInput=Delete[input,invalidPositions];

	(* Stash the length of the input *)
	lengthOfInput=Length[input];

	(* Map over the options and for any option that is index matched to the input, delete the positions that are invalid *)
	validOptions=MapThread[
		Function[{optionName,optionVal},
			If[MatchQ[Length[optionVal],lengthOfInput],
				(*If the length of the option matches the length of the input,assume Index Matched and trim the bad values*)
				optionName->Delete[optionVal,invalidPositions],
				(*Otherwise it isn't index matched so leave it be*)
				optionName->optionVal]
			],
	{indexMatchedOptionKeys,Lookup[optionsToBeTrimmed,indexMatchedOptionKeys]}
	];

	(* Return our new samples and options (both the indexmatched and single options *)
	{validInput,ReplaceRule[optionsToBeTrimmed,validOptions]}

];


(* ::Subsubsection::Closed:: *)
(*sampleWeightCanBeTrustedQ*)


(* ==== Helper that determines whether we can trust the latest recorded sample mass, by checking whether the sample has since been touched by other protocols, in which case we cannot be 100% sure anymore that the mass is accurate *)
(* Input: samplePacket, protocolPacket, and the date that the latest weight was recorded *)
(* Output: True|False \[Rule] True only if the latest date that the sample was touched is the date the latest weight was recorded, otherwise return False *)


sampleWeightCanBeTrustedQ[samplePacket_, protocolPacket_,date: _?DateObjectQ|Null] := Module[
	{
		massLog, massDates, latestMassDate, transfersIn, transferInDates, latestTransferInDate,transfersOut, transferOutDates, latestTransferOutDate,
		completedProtocolsPackets, protocolDates, latestProtocolDate
	},

	latestMassDate = If[
		NullQ[date],
		(
			(* get the mass log *)
			massLog = Lookup[samplePacket, MassLog];
			(* get dates *)
			massDates = Cases[massLog[[All,1]], _?DateObjectQ];
			(* get the date of last mass inform. Null means mass measurement date is UNKNOWN!! *)
			If[MatchQ[massDates,{}], Null, Max[massDates]]
		),
		date
	];

	(* get all transfers into sample *)
	transfersIn = Lookup[samplePacket,TransfersIn];
	(* if there have been no transfersIn, then set latestDate as before the start of Emerald *)
	latestTransferInDate = If[
		MatchQ[transfersIn,{}],
		DateObject[0],
		(
			(* get the dates for the transfersIn *)
			transferInDates = Cases[transfersIn[[All,1]], _?DateObjectQ];
			(* get the date of last transfer. Null means transferIn date is UNKNOWN!! *)
			If[MatchQ[transferInDates,{}], Null, Max[transferInDates]]
		)
	];

	(* get all transfers out of sample *)
	transfersOut = Lookup[samplePacket,TransfersOut];

	(* if there have been no transfersOut, then set latestDate as 1900 *)
	latestTransferOutDate = If[
		MatchQ[transfersOut,{}],
		DateObject[0],
		(
			(* get the dates for the transfersIn *)
			transferOutDates = Cases[transfersOut[[All,1]], _?DateObjectQ];
			(* get the date of last transfer. Null means transferOut date is UNKNOWN !! *)
			If[MatchQ[transferOutDates,{}], Null, Max[transferOutDates]]
		)
	];

	(* get all protocols that sample has been part of, this is a flat list of packets, or an empty list*)
	completedProtocolsPackets=If[MatchQ[protocolPacket,{}],
			{},
			Select[protocolPacket, Lookup[#,Status]==Completed &]
		];

	(* get all the dates from protocols that are completed *)
	protocolDates=If[MatchQ[completedProtocolsPackets,{}],
		{},
		Lookup[completedProtocolsPackets,DateCompleted]
	];

	(* get the last date *)
	latestProtocolDate=Which[
		(* there were no completed protocols, set latestDate far back in time *)
		MatchQ[completedProtocolsPackets,{}], DateObject[0],
		(* there were completed protocols but datecompleted was not set, so we dunno when it happened. Set to Null *)
		MatchQ[protocolDates, {}], Null,
		(* there are dates, take the largest *)
		True, Max[protocolDates]
	];

	(* perform logic to decide whether the sample's latest weight recording is trustworthy, or not *)
	(* return True only if the latest date is mass Date *)
	If[
		NullQ[latestMassDate]||NullQ[latestTransferInDate]||NullQ[latestTransferOutDate] || NullQ[latestProtocolDate],
		(* if any dates are unknown, we cannot be sure so cannot calibrate container *)
		False,
		(* else check that massdate is after the other dates *)
		(latestMassDate > latestTransferInDate) && (latestMassDate > latestTransferOutDate) && (latestMassDate > latestProtocolDate)
	]

];


(* ::Subsection::Closed:: *)
(*ExperimentMeasureWeightOptions*)


DefineOptions[ExperimentMeasureWeightOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
      Description -> "Determines whether the function returns a table or a list of the options.",
      Category->"Protocol"
    }
  },
  SharedOptions :> {ExperimentMeasureWeight}
];

ExperimentMeasureWeightOptions[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

(* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

  (* get only the options for DropShipSamples *)
  options = ExperimentMeasureWeight[myInput, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentMeasureWeight],
    options
  ]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureWeightPreview*)


(* currently we only accept either a list of containers, or a list of samples *)
ExperimentMeasureWeightPreview[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]],myOptions:OptionsPattern[ExperimentMeasureWeight]]:=
    ExperimentMeasureWeight[myInput,Append[ToList[myOptions],Output->Preview]];


(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureWeightQ*)


DefineOptions[ValidExperimentMeasureWeightQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions :> {ExperimentMeasureWeight}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentMeasureWeightQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]],myOptions:OptionsPattern[ValidExperimentMeasureWeightQ]]:=Module[
  {listedOptions, listedInput, oOutputOptions, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
  listedOptions = ToList[myOptions];
  listedInput = ToList[myInput];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentMeasureWeight *)
  filterTests = ExperimentMeasureWeight[myInput, Append[preparedOptions, Output -> Tests]];

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
      validObjectBooleans = ValidObjectQ[listedInput, OutputFormat -> Boolean];
      voqWarnings = MapThread[
        Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {listedInput, validObjectBooleans}
      ];

      (* get all the tests/warnings *)
      Flatten[{initialTest, filterTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentMeasureCountQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureCountQ"]


];
