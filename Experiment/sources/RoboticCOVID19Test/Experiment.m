(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentRoboticCOVID19Test*)


(* ::Subsubsection::Closed:: *)
(*PrepareExperimentRoboticCOVID19Test Options*)


DefineOptions[PrepareExperimentRoboticCOVID19Test,
	Options:>{
		{DaySamples->{},{ObjectP[Object[Container]]...},"Samples from the day shifts for testing."},
		{NightSamples->{},{ObjectP[Object[Container]]...},"Samples from the night shifts for testing."},
		{SwingSamples->{},{ObjectP[Object[Container]]...},"Samples from the swing shifts for testing."},
		{OtherSamples->{},{ObjectP[Object[Container]]...},"Samples from non lab Operations teams for testing."},
		{EnvironmentalSample->Null,ObjectP[Object[Container]],"The environmental sample for testing. This option is required."},
		{ExternalSamples->{},{}|ListableP[ObjectP[Object[Container]]],"The external samples for testing."},
		ProtocolOptions,
		PostProcessingOptions
	}
];

Error::OutdatedCovidTestCall="This call is no longer supported. Please indicate the source of each sample by specifying the shift options. You should see these new options upon reloading the Command Center template.";
Error::EnvironmentalSampleRequired="EnvironmentalSample is missing. Please specify EnvironmentalSample as the container with samples collected from various locations in the workplace.";
Error::MaxCovidPoolSizeReached="In order to prevent tests samples from being overly diluted we've set $MaxCovidPoolSize. Given the constraints of the distinct shifts and the number of samples provided it is not possible to test all the provided samples. Please reduce the number of provided samples.";

(* In order to avoid over diluting the saliva samples, we've somewhat arbitrarily set the max pool size to 4 (i.e. no more than 4 samples in a well) *)
$MaxCovidPoolSize=8;
$CovidPlateSize=96;
$FluSC2Primers=True;

(* ::Subsubsection::Closed:: *)
(*PrepareExperimentRoboticCOVID19Test*)

PrepareExperimentRoboticCOVID19Test[
	internalSamples:ListableP[ObjectP[Object[Container]]],
	myOptions:OptionsPattern[PrepareExperimentRoboticCOVID19Test]
]:=Module[{},
	Message[Error::OutdatedCovidTestCall];
	$Failed
];


PrepareExperimentRoboticCOVID19Test[
	myOptions:OptionsPattern[PrepareExperimentRoboticCOVID19Test]
]:=Module[
	{listedOptions,safeOptions,enviromentalSample,allSamples,idFile,protocol},

	listedOptions=ToList[myOptions];
	safeOptions=SafeOptions[PrepareExperimentRoboticCOVID19Test,listedOptions,AutoCorrect->False];

	(*Throw errors if the required options are not specified*)
	If[!KeyExistsQ[listedOptions,EnvironmentalSample],
		Message[Error::EnvironmentalSampleRequired];
		Return[$Failed]
	];

	enviromentalSample=ToList[Lookup[safeOptions,EnvironmentalSample]/.(Null->{})];

	(* Assemble a list of all the Samples we want to test *)
	allSamples = Join[
		ToList[Lookup[safeOptions,DaySamples]],
		ToList[Lookup[safeOptions,SwingSamples]],
		ToList[Lookup[safeOptions,NightSamples]],
		ToList[Lookup[safeOptions,OtherSamples]],
		enviromentalSample,
		ToList[Lookup[safeOptions,ExternalSamples]]
	];

	idFile = Export[
		FileNameJoin[{
			$TemporaryDirectory, "Current Covid Samples " <> DateString[Now, {"Month", "-", "Day", "-", "Year"}] <> ".xlsx"
		}],
		Complement[allSamples,enviromentalSample][ID]
	];

	protocol = ExperimentRoboticCOVID19Test[
		allSamples,
		safeOptions
	];

	If[MatchQ[protocol, ObjectP[]],
		Email[
			{"allie.windham@emeraldcloudlab.com","hayley@emeraldcloudlab.com"},
			Subject->"Current COVID-19 Test Samples",
			Attachments->{idFile}
		]
	];

	protocol
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCOVID19Test Options*)


DefineOptions[ExperimentRoboticCOVID19Test,
	SharedOptions:>{PrepareExperimentRoboticCOVID19Test}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCOVID19Test*)


(*Main function accepting sample objects as sample inputs*)
ExperimentRoboticCOVID19Test[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:OptionsPattern[ExperimentRoboticCOVID19Test]
]:=Module[
	{outputSpecification,output,gatherTests,messages,listedSamples,listedOptions,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,optionsAssociation,
		cache,upload,confirm,parentProtocol,sampleDownloadFields,sampleContainerDownloadFields,allSamplePackets,cacheBall,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests},

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Remove temporal links*)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(*--Call SafeOptions, ValidInputLengthsQ, and ApplyTemplateOptions--*)

	(*Call SafeOptions to make sure all options match patterns*)
	{safeOps,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentRoboticCOVID19Test,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentRoboticCOVID19Test,listedOptions,AutoCorrect->False],{}}
	];

	(*If the specified options don't match their patterns, return $Failed or tests*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Call ValidInputLengthsQ to make sure all options have matching lengths*)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentRoboticCOVID19Test,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentRoboticCOVID19Test,{listedSamples},listedOptions],Null}
	];

	(*If the option lengths are invalid, return $Failed or tests*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Call ApplyTemplateOptions to get templated option values*)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentRoboticCOVID19Test,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentRoboticCOVID19Test,{listedSamples},listedOptions],Null}
	];

	(*If the template object does not exist, return $Failed or tests*)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(*Replace our safe options with the inherited options from the template*)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	optionsAssociation=Association[inheritedOptions];

	(*get assorted hidden options*)
	{cache,upload,confirm,parentProtocol}=Lookup[optionsAssociation,{Cache,Upload,Confirm,ParentProtocol}];

	(*--Download the information we need for the option resolver and resource packet function--*)

	(*Define the fields from which to download information*)
	sampleDownloadFields=Packet[DateUnsealed,UnsealedShelfLife,RequestedResources,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];
	sampleContainerDownloadFields=Packet[Container[SamplePreparationCacheFields[Object[Container]]]];

	(*Make the upfront Download call*)
	allSamplePackets=Quiet[
		Download[
			listedSamples,
				{
					sampleDownloadFields,
					sampleContainerDownloadFields
				},
			Cache->cache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(*Combine our caches*)
	cacheBall=FlattenCachePackets[{cache,allSamplePackets}];

	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentRoboticCOVID19TestOptions[listedSamples,inheritedOptions,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentRoboticCOVID19TestOptions[listedSamples,inheritedOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentRoboticCOVID19Test,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(*If option resolution failed, return early*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentRoboticCOVID19Test,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*--Build packets with resources--*)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		experimentRoboticCOVID19TestResourcePackets[listedSamples,inheritedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{experimentRoboticCOVID19TestResourcePackets[listedSamples,inheritedOptions,resolvedOptions,Cache->cacheBall],{}}
	];

	(*If we don't have to return the Result, don't bother calling UploadProtocol*)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentRoboticCOVID19Test,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*We have to return the result. Call UploadProtocol to prepare our protocol packet (and upload it if requested)*)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Cache->cache,
			Upload->upload,
			Confirm->confirm,
			ParentProtocol->parentProtocol,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,RoboticCOVID19Test]
		],
		$Failed
	];

	(*Return the requested output*)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentRoboticCOVID19Test,collapsedResolvedOptions],
		Preview->Null
	}
];


(*---Function overload accepting sample/container objects as sample inputs---*)
ExperimentRoboticCOVID19Test[
	myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[ExperimentRoboticCOVID19Test]
]:=Module[
	{outputSpecification,output,gatherTests,listedContainers,listedOptions,sampleCache,
		containerToSampleResult,containerToSampleOutput,containerToSampleTests,samples,sampleOptions},

	(*Determine the requested return value from the function*)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(*Remove temporal links*)
	{listedContainers,listedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];


	(*--Convert the given containers into samples and sample index-matched options--*)
	containerToSampleResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentRoboticCOVID19Test,
			listedContainers,
			listedOptions,
			Output->{Result,Tests},
			Cache->Lookup[listedOptions,Cache,{}]
		];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentRoboticCOVID19Test,
				listedContainers,
				listedOptions,
				Output->Result,
				Cache->Lookup[listedOptions,Cache,{}]
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];



	(*If we were given an empty container, return early*)
	If[MatchQ[containerToSampleResult,$Failed],
		(*containerToSampleOptions failed - return $Failed*)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(*Split up our containerToSample result into samples and sampleOptions*)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;
		(*Call the main function with our samples and converted options*)
		ExperimentRoboticCOVID19Test[
			samples,
			ReplaceRule[sampleOptions,{Cache->sampleCache}]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentRoboticCOVID19TestOptions*)


DefineOptions[resolveExperimentRoboticCOVID19TestOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


resolveExperimentRoboticCOVID19TestOptions[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentRoboticCOVID19TestOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,inheritedCache,optionsAssociation,
		sampleDownloadFields,sampleContainerDownloadFields,allSamplePackets,samplePackets,sampleContainerPackets,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,
		sampleContainers,gatheredSampleContainers,duplicateInvalidInputs,duplicateTest,
		name,validNameQ,invalidNameOptions,validNameTest,
		resolvedPostProcessingOptions,invalidInputs,invalidOptions,cache,fastTrack,template,parentProtocol,operator,confirm,upload,outputOption,email,
		resolvedOptions,allTests,resultRule,testsRule},


	(*---Set up the user-specified options and cache---*)

	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Fetch our options cache from the parent function*)
	inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	optionsAssociation=Association[myOptions];

	(*Define the fields from which to download information*)
	sampleDownloadFields=Packet[DateUnsealed,UnsealedShelfLife,RequestedResources,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];
	sampleContainerDownloadFields=Packet[Container[SamplePreparationCacheFields[Object[Container]]]];

	(*Make the upfront Download call*)
	allSamplePackets=Quiet[
		Download[
			myListedSamples,
			{
				sampleDownloadFields,
				sampleContainerDownloadFields
			},
			Cache->inheritedCache
		],
		{Download::FieldDoesntExist}
	];

	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleContainerPackets=allSamplePackets[[All,2]];


	(*---Input validation checks---*)

	(*--Discarded input check--*)

	(*Get the sample packets from simulatedSamples that are discarded*)
	discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status->Discarded]];

	(*Set discardedInvalidInputs to the input objects whose statuses are Discarded*)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->inheritedCache]]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->inheritedCache]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[myListedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[myListedSamples,discardedInvalidInputs],Cache->inheritedCache]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*--Duplicate samples/containers check--*)

	(*Gather the same sample containers*)
	sampleContainers=Lookup[sampleContainerPackets,Object];
	gatheredSampleContainers=GatherBy[Lookup[sampleContainerPackets,Object],Object];

	(*Set duplicateInvalidInputs to the containers that are duplicated*)
	duplicateInvalidInputs=If[AllTrue[gatheredSampleContainers,Length[#]==1&],
		{},
		DeleteDuplicates[Flatten[Select[gatheredSampleContainers,Length[#]>1&]]]
	];

	(*If there are invalid inputs and we are throwing messages (not gathering tests), throw an error message and keep track of the invalid inputs*)
	If[Length[duplicateInvalidInputs]>0&&messages,
		Message[Error::DuplicateCOVID19TestInputs,ObjectToString[duplicateInvalidInputs,Cache->inheritedCache]]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	duplicateTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[duplicateInvalidInputs]==0,
				Nothing,
				Test["Our inputs "<>ObjectToString[duplicateInvalidInputs,Cache->inheritedCache]<>" do not have duplicate samples or containers:",True,False]
			];
			passingTest=If[Length[duplicateInvalidInputs]==Length[sampleContainers],
				Nothing,
				Test["Our inputs "<>ObjectToString[Complement[sampleContainers,duplicateInvalidInputs],Cache->inheritedCache]<>" do not have duplicate samples or containers:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(*---Conflicting options checks---*)

	(*--Check that Name is properly specified--*)

	(*If the specified Name is a string, check if this name exists in the Database already*)
	name=Lookup[optionsAssociation,Name];
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,RoboticCOVID19Test,name]]],
		True
	];

	(*If validNameQ is False and we are throwing messages, then throw an error message*)
	invalidNameOptions=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"RoboticCOVID19Test protocol"];
			{Name}
		),
		{}
	];

	(*If we are gathering tests, create a test for Name*)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a RoboticCOVID19Test protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];


	(*---Resolve Post Processing Options---*)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(*---Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary---*)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		duplicateInvalidInputs
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		invalidNameOptions
	}]];

	(*Throw Error::InvalidInput if there are invalid inputs*)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->inheritedCache]]
	];

	(*Throw Error::InvalidOption if there are invalid options*)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];


	(*---Return our resolved options and tests---*)

	(*Pull out the shared ProtocolOptions*)
	{cache,fastTrack,template,parentProtocol,operator,confirm,upload,outputOption}=Lookup[optionsAssociation,{Cache,FastTrack,Template,ParentProtocol,Operator,Confirm,Upload,Output}];

	(*resolve the Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a subprotocol*)
	email=Which[
		MatchQ[Lookup[optionsAssociation,Email],Automatic]&&NullQ[parentProtocol],True,
		MatchQ[Lookup[optionsAssociation,Email],Automatic]&&MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],False,
		True,Lookup[optionsAssociation,Email]
	];

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=Flatten[{
		Cache->cache,
		FastTrack->fastTrack,
		Template->template,
		ParentProtocol->parentProtocol,
		Operator->operator,
		Confirm->confirm,
		Name->name,
		Upload->upload,
		Output->outputOption,
		Email->email,
		resolvedPostProcessingOptions
	}];

	(*Gather the tests*)
	allTests=Cases[Flatten[{
		discardedTest,
		duplicateTest,
		validNameTest
	}],_EmeraldTest];

	(*Generate the result output rule: if not returning result, result rule is just Null*)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(*Return the output as we desire it*)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(*experimentRoboticCOVID19TestResourcePackets*)


DefineOptions[experimentRoboticCOVID19TestResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


experimentRoboticCOVID19TestResourcePackets[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[experimentRoboticCOVID19TestResourcePackets]
]:=Module[
	{unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,environmentalSample,
		daySamples,nightSamples,swingSamples,otherSamples,externalSamples,internalSamples,outsideSampleCount,totalSampleCount,pooledInternalSamples,
		samplesInLength,samplesInResources,containersInResources,biosafetyCabinetResource,coolerResource,rnaExtractionPlateResource,wasteReservoirResource,elutionPlateResource,
		disinfectantResource,lysisMasterMixResource,magneticBeadsResource,proteaseSolutionResource,primaryWashSolutionResource,secondaryWashSolutionResource,elutionSolutionResource,
		noTemplateControlResource,viralRNAControlResource,n1Resource,n2Resource,rpResource,fluSC2PrimerResource,fluSC2ProbeResource,primers,probes,masterMixPrepWellsLength,masterMixResource,expectedPositives,
		protocolPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,resultRule,testsRule,
		(* primer/probes *)
		fluSC2COV2PrimerResource,fluSC2COV2ProbeResource, fluSC2RNasePPrimerResource,fluSC2RNasePProbeResource},

	(*Get the collapsed unresolved index-matching options that don't include hidden options*)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentRoboticCOVID19Test,myUnresolvedOptions];

	(*Get the collapsed resolved index-matching options that don't include hidden options*)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentRoboticCOVID19Test,
		RemoveHiddenOptions[ExperimentRoboticCOVID19Test,myResolvedOptions],
		Ignore->myUnresolvedOptions
	];

	(*Determine the requested output format of this function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests to return to the user*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Get the inherited cache*)
	inheritedCache=Lookup[ToList[myOptions],Cache,{}];

	(*Get the environmental sample from its container*)
	environmentalSample=If[!NullQ[Lookup[myUnresolvedOptions,EnvironmentalSample]],
		First[
			Download[
				Download[Lookup[myUnresolvedOptions,EnvironmentalSample],Contents[[All,2]],Cache->inheritedCache],
				Object
			],
			Null
		]
	];

	(*Get the external samples from their containers*)
	daySamples=Download[
		Flatten@Download[Lookup[myUnresolvedOptions,DaySamples],Contents[[All,2]],Cache->inheritedCache],
		Object
	];

	(*Get the external samples from their containers*)
	swingSamples=Download[
		Flatten@Download[Lookup[myUnresolvedOptions,SwingSamples],Contents[[All,2]],Cache->inheritedCache],
		Object
	];

	(*Get the external samples from their containers*)
	nightSamples=Download[
		Flatten@Download[Lookup[myUnresolvedOptions,NightSamples],Contents[[All,2]],Cache->inheritedCache],
		Object
	];

	(*Get the external samples from their containers*)
	otherSamples=Download[
		Flatten@Download[Lookup[myUnresolvedOptions,OtherSamples],Contents[[All,2]],Cache->inheritedCache],
		Object
	];

	(*Get the external samples from their containers*)
	externalSamples=Download[
		Flatten@Download[Lookup[myUnresolvedOptions,ExternalSamples],Contents[[All,2]],Cache->inheritedCache],
		Object
	];

	(*Get the internal samples by joining up all our shift samples and other team samples *)
	internalSamples=Join[
		daySamples,
		swingSamples,
		nightSamples,
		otherSamples
	];

	(* -- Determine our pooling! -- *)
	(* Figure out how many samples we actually have. Enviro sample is a single field right now, but protecting against change *)
	outsideSampleCount = Length[ToList[environmentalSample]] + Length[externalSamples];
	totalSampleCount = Length[internalSamples] + outsideSampleCount;

	pooledInternalSamples = If[totalSampleCount <= $CovidPlateSize,
		(* If all our samples will fit in the plate we don't need to do any pooling. Still want to store in pool field for consistency. Set up to make 'pools' with one sample each *)
		{#}&/@internalSamples,

		(* Gotta pool *)
		Module[{availableWells,shiftTuples,calculatedPoolTuples},
			availableWells = $CovidPlateSize - outsideSampleCount;

			(* Call poolCovidSamples to group up the samples, respecting rule that only samples in the same shift can be pooled *)
			calculatedPoolTuples = poolCovidSamples[
				DeleteCases[<|DaySamples->daySamples,NightSamples->nightSamples,SwingSamples->swingSamples,OtherSamples->otherSamples|>,{}],
				availableWells
			];

			(* Remove the shift headers and just get our pool lists *)
			If[
				MatchQ[calculatedPoolTuples,$Failed],
				$Failed,
				calculatedPoolTuples
			]
		]
	];

	(* If our pools are too big to get good results we have to ask for fewer samples *)
	If[Max[Length/@pooledInternalSamples]>$MaxCovidPoolSize,
		Message[Error::MaxCovidPoolSizeReached];Return[$Failed]
	];

	(*---Generate all the resources for the experiment---*)

	(*--Generate the samples/containers in resources--*)

	(*Samples in*)
	samplesInLength=Length[myListedSamples];

	samplesInResources=Map[
		Resource[Sample->#,Name->ToString[Unique[]],Amount->200 Microliter]&,
		myListedSamples
	];

	(*Containers in*)
	containersInResources=Map[
		Resource[Sample->#,Name->ToString[Unique[]]]&,
		Download[myListedSamples,Container[Object],Cache->inheritedCache]
	];

	(*--Generate the RNA Extraction resources for 200 uL input samples--*)

	(*Instrument*)
	biosafetyCabinetResource=Resource[Instrument->Object[Instrument,BiosafetyCabinet,"TC Hood"],Time->2 Hour];
	coolerResource=Resource[Instrument->Model[Instrument,PortableCooler,"ICECO GO20 Portable Refrigerator"],Time->5 Hour];

	(*Containers*)
	rnaExtractionPlateResource=Resource[Sample->Model[Container,Plate,"96-well 2mL Deep Well Plate"]];
	wasteReservoirResource=Resource[Sample->Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]];
	elutionPlateResource=Resource[Sample->Model[Container,Plate,"96-well PCR Plate"]];

	(*Samples*)
	(* NOTE: specifically ask that our lysis master mix is in a 50mL tube so that we can put it on the Hamilton. *)
	disinfectantResource=Resource[Sample->Model[Sample,StockSolution,"10% Bleach"],Amount->samplesInLength*20 Milliliter];
	lysisMasterMixResource=Resource[Sample->Model[Sample,StockSolution,"Lysis Master Mix (Mag-Bind Viral DNA/RNA Kit) Stock Solution"],Amount->Min[Min[samplesInLength,96]*520 Microliter, 50 Milliliter],Container->Model[Container, Vessel, "50mL Tube"]];
	magneticBeadsResource=Resource[Sample->Model[Sample,"Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)"],Amount->Min[samplesInLength,96]*10 Microliter+50 Microliter,Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]];(*50 uL extra, require a plate so we can shake on deck prior to aliquoting. MaxVolume->2 mL, WellBottom->VBottom*)
	proteaseSolutionResource=Resource[Sample->Model[Sample,"Proteinase K Solution (Mag-Bind Viral DNA/RNA Kit)"],Amount->Min[samplesInLength,96]*10 Microliter+50 Microliter,Container->Model[Container,Vessel,"2mL Tube"]];(*50 uL extra*)
	primaryWashSolutionResource=Resource[Sample->Model[Sample,StockSolution,"VHB Buffer (Mag-Bind Viral DNA/RNA Kit) Stock Solution"],Amount->Min[samplesInLength,96]*400 Microliter+2 Milliliter,Container->Model[Container,Vessel,"50mL Tube"]];(*2 mL extra*)
	secondaryWashSolutionResource=Resource[Sample->Model[Sample,StockSolution,"SPR Wash Buffer (Mag-Bind Viral DNA/RNA Kit) Stock Solution"],Amount->Min[samplesInLength,96]*1 Milliliter];(*Resource will be made in 2 50mL tubes by SM*)
	elutionSolutionResource=Resource[Sample->Model[Sample,"Nuclease-free Water (Mag-Bind Viral DNA/RNA Kit)"],Amount->Min[samplesInLength,96]*100 Microliter+2 Milliliter,Container->Model[Container,Vessel,"50mL Tube"]];(*2 mL extra, 15 uL of each sample needed for qPCR*)

	(*--Generate the RT-qPCR resources--*)
	noTemplateControlResource=Resource[Sample->Model[Sample,"Nuclease-free Water"],Amount->5 Microliter*3+35 Microliter,Container->Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]];(*35 uL extra*)
	viralRNAControlResource=Resource[Sample->Model[Sample, StockSolution, "SARS-CoV-2 RNA (MT007544.1) 100X from Aliquot"],Amount->5 Microliter*3+35 Microliter];(*35 uL extra*)

	(*$FluSC2Primers=False resources - these are the older primer/probe sets we've been using through Feb 2022*)
	{n1Resource,n2Resource,rpResource}={
		(*0.5 uL for each forward primer, reverse primer, and probe. qPCRPrepDeadVolume extra required by qPCR*)
		Resource[Sample->Model[Sample, StockSolution, "2019-nCoV_N1 CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(Min[samplesInLength,96]+2)*0.5 Microliter*3+Experiment`Private`qPCRPrepDeadVolume,Name->"Combined Primers and Probes"],
		Resource[Sample->Model[Sample, StockSolution, "2019-nCoV_N2 CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(Min[samplesInLength,96]+2)*0.5 Microliter*3+Experiment`Private`qPCRPrepDeadVolume,Name->"Combined Primers and Probes"],
		Resource[Sample->Model[Sample, StockSolution, "RNAse P CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(Min[samplesInLength,96]+2)*0.5 Microliter*3+Experiment`Private`qPCRPrepDeadVolume,Name->"Combined Primers and Probes"]
	};

	(*$FluSC2Primers=True resources - these are the newer primer/probe sets we've been using from March 2022*)
	{fluSC2COV2PrimerResource,fluSC2COV2ProbeResource}={
		Resource[Sample->Model[Sample,StockSolution,"FluSC2 SARS-CoV-2 Primers Mix"],Amount->(Min[samplesInLength,96]+2)* 3 Microliter+Experiment`Private`qPCRPrepDeadVolume,Name->"Primers SARS-Cov-2"],
		Resource[Sample->Model[Sample,StockSolution,"FluSC2 SARS-CoV-2 Probe Mix"],Amount->(Min[samplesInLength,96]+2)* 3 Microliter+Experiment`Private`qPCRPrepDeadVolume,Name->"Probe SARS-Cov-2"]
	};

	{fluSC2RNasePPrimerResource,fluSC2RNasePProbeResource}={
		Resource[Sample->Model[Sample,StockSolution,"FluSC2 Human RNaseP Primers Mix"],Amount->(Min[samplesInLength,96]+2)* 3 Microliter+Experiment`Private`qPCRPrepDeadVolume,Name->"Primers RNaseP"],
		Resource[Sample->Model[Sample,StockSolution, "FluSC2 Human RNaseP Probe Mix"],Amount->(Min[samplesInLength,96]+2)* 3 Microliter+Experiment`Private`qPCRPrepDeadVolume,Name->"Probe RNaseP"]
	};

	{primers,probes}=If[$FluSC2Primers,
		{
			{
				fluSC2COV2PrimerResource,
				fluSC2RNasePPrimerResource
			},
			{
				fluSC2COV2ProbeResource,
				fluSC2RNasePProbeResource
			}
		},
		{
			{n1Resource,n2Resource,rpResource},
			{n1Resource,n2Resource,rpResource}
		}
	];

	masterMixPrepWellsLength=Min[Ceiling[(Min[samplesInLength,96]+2)*3/2],8];

	(* Make master mix resource, account for extra volume required by qPCR *)
	masterMixResource=If[$FluSC2Primers,
		Resource[
			Sample->Model[Sample, "TaqPath 1-Step Multiplex Master Mix (No ROX)"],
			Amount->masterMixPrepWellsLength*(Experiment`Private`qPCRPrepDeadVolume+Ceiling[(Min[samplesInLength,96]+2)*2/masterMixPrepWellsLength]*6.3 Microliter*1.1)+40 Microliter,
			Container->Model[Container,Vessel,"2mL Tube"]
		],
		Resource[
			Sample->Model[Sample,"TaqMan Fast Virus 1-Step Master Mix"],
			Amount->masterMixPrepWellsLength*(Experiment`Private`qPCRPrepDeadVolume+Ceiling[(Min[samplesInLength,96]+2)*3/masterMixPrepWellsLength]*5 Microliter*1.1)+40 Microliter,
			Container->Model[Container,Vessel,"2mL Tube"]
		]
	];

	(* Pull any knowledge of expected positives from the previous protocol and copy it to the next one *)
	expectedPositives=Download[First[Search[Object[Protocol, RoboticCOVID19Test],Status==Completed,MaxResults->1],Null],ExpectedPositives];

	(*---Make the protocol packet---*)
	protocolPacket=<|
		(*===Organizational Information===*)
		Object->CreateID[Object[Protocol,RoboticCOVID19Test]],
		Type->Object[Protocol,RoboticCOVID19Test],
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
		Replace[ContainersIn]->(Link[#,Protocols]&/@containersInResources),


		(*===Options Handling===*)
		UnresolvedOptions->unresolvedOptionsNoHidden,
		ResolvedOptions->resolvedOptionsNoHidden,


		(*===Resources===*)
		Replace[Checkpoints]->{
			{"Picking Resources",2 Hour,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->2 Hour]]},
			{"Extracting RNA",8 Hour,"RNA is extracted and purified.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->8 Hour]]},
			{"RT-qPCR",5 Hour,"Thermocycling procedure is performed on the reaction mixtures.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->5 Hour]]},
			{"Returning Materials",1 Hour,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Hour]]}
		},


		(*===RNA Extraction===*)

		(*Instrument*)
		BiosafetyCabinet->Link[biosafetyCabinetResource],
		PortableCooler->Link[coolerResource],

		(*Containers*)
		RNAExtractionPlate->Link[rnaExtractionPlateResource],
		WasteReservoir->Link[wasteReservoirResource],
		ElutionPlate->Link[elutionPlateResource],

		(*Samples*)
		Disinfectant->Link[disinfectantResource],
		LysisMasterMix->Link[lysisMasterMixResource],
		MagneticBeads->Link[magneticBeadsResource],
		ProteaseSolution->Link[proteaseSolutionResource],
		PrimaryWashSolution->Link[primaryWashSolutionResource],
		SecondaryWashSolution->Link[secondaryWashSolutionResource],
		ElutionSolution->Link[elutionSolutionResource],


		(*===RT-qPCR===*)

		(*Samples*)
		ReactionVolume->If[$FluSC2Primers,
			25 Microliter,
			20 Microliter
		],
		NoTemplateControl->Link[noTemplateControlResource],
		ViralRNAControl->Link[viralRNAControlResource],
		SampleVolume->5 Microliter,

		(*Primers and Probes*)
		Replace[ForwardPrimers]->Link/@primers,
		Replace[ReversePrimers]->Link/@primers,
		Replace[Probes]->Link/@probes,

		Sequence@@If[$FluSC2Primers,
			{
				(* We want a total of 3uL of Model[Sample, StockSolution, "FluSC2 Multiplex Master Primer Mix"] *)
				(* The way qPCR is set-up will need to ask for individual cases -> forward and reverse so we set this to 3/2 *)
				ForwardPrimerVolume->1.5 Microliter,
				ReversePrimerVolume->1.5 Microliter,
				ProbeVolume->3 Microliter
			},
			{
				ForwardPrimerVolume->0.5 Microliter,
				ReversePrimerVolume->0.5 Microliter,
				ProbeVolume->0.5 Microliter
			}
		],

		Sequence@@If[$FluSC2Primers,
			{
				Replace[ProbeExcitationWavelengths]->{580 Nanometer, 640 Nanometer}, (* as close as we can get for Cy5 and Texas Red, respectively *)
				Replace[ProbeEmissionWavelengths]->{623 Nanometer, 682 Nanometer}
			},
			{
				Replace[ProbeExcitationWavelengths]->{470 Nanometer,470 Nanometer,470 Nanometer},
				Replace[ProbeEmissionWavelengths]->{520 Nanometer,520 Nanometer,520 Nanometer}
			}
		],

		(*Master Mix and Buffer*)
		MasterMix->Link[masterMixResource],
		MasterMixVolume->If[$FluSC2Primers,
			6.3 Microliter,
			5 Microliter
		],
		ReactionBuffer->Link[Model[Sample,"Nuclease-free Water"]],
		ReactionBufferVolume->If[$FluSC2Primers,
			7.7 Microliter,
			8.5 Microliter
		],

		Sequence@@If[$FluSC2Primers,
			{},
			{
				ReferenceDyeExcitationWavelength->580 Nanometer,
				ReferenceDyeEmissionWavelength->623 Nanometer,
				ReferenceDye->Model[Molecule, "id:lYq9jRxPaPGV"]
			}
		],

		(* -- Thermocycling -- *)
		Thermocycler->Link[Object[Instrument,Thermocycler,"Herbert"]],
		NumberOfCycles->45,

		(* Ramp Rates *)
		ReverseTranscriptionRampRate->1.9 Celsius/Second,
		ActivationRampRate->1.9 Celsius/Second,
		DenaturationRampRate->1.9 Celsius/Second,
		ExtensionRampRate->1.6 Celsius/Second,

		(* Stage Times and Temps *)
		Sequence@@If[$FluSC2Primers,
			{
				ReverseTranscriptionTemperature-> 50 Celsius,
				ReverseTranscriptionTime->15 Minute,

				ActivationTemperature -> 95 Celsius,
				ActivationTime -> 2 Minute,

				DenaturationTemperature -> 95 Celsius,
				DenaturationTime -> 15 Second,

				ExtensionTemperature -> 55 Celsius,
				ExtensionTime -> 30 Second
			},
			{
				ReverseTranscriptionTemperature->50 Celsius,
				ReverseTranscriptionTime->5 Minute,

				ActivationTemperature->95 Celsius,
				ActivationTime->20 Second,

				DenaturationTemperature->95 Celsius,
				DenaturationTime->3 Second,

				ExtensionTemperature->60 Celsius,
				ExtensionTime->30 Second
			}
		],

		(*===Analysis & Reports===*)
		Replace[InternalSamples]->Link[internalSamples],
		Replace[DaySamples]->Link[daySamples],
		Replace[NightSamples]->Link[nightSamples],
		Replace[SwingSamples]->Link[swingSamples],
		Replace[OtherSamples]->Link[otherSamples],
		Replace[SamplePools]->pooledInternalSamples,

		EnvironmentalSample->Link[environmentalSample],
		Replace[ExternalSamples]->Link[externalSamples],
		Replace[ExpectedPositives]->Link[expectedPositives],


		(*===Sample Post-Processing===*)
		MeasureWeight->Lookup[myResolvedOptions,MeasureWeight],
		MeasureVolume->Lookup[myResolvedOptions,MeasureVolume],
		ImageSample->Lookup[myResolvedOptions,ImageSample]
	|>;

	(*--Gather all the resource symbolic representations--*)

	(*Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed*)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];


	(*---Call fulfillableResourceQ on all the resources we created---*)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
	];


	(*---Return our options, packets, and tests---*)

	(*Generate the preview output rule; Preview is always Null*)
	previewRule=Preview->Null;

	(*Generate the options output rule*)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(*Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed*)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(*Return the output as we desire it*)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* This function will calculate how to pool samples such that we can fit them on the number of available wells we have. The logic will pool everything as much as possible and unpool it starting with the largest pools until we reach the desired number of sample. As such, it will minimize large pools. However, we remove 1 sample from each pool at a time, so if we start with 8 samples and want 4 pools, it would create 2 pools of 3 samples and 2 pools of 1 sample, instead of 4 pools of 2 samples. This can be a annoying but should not be a problem from a scientific perspective *)
Error::TooManySamplesToPool="There are too many unique sample types and so samples cannot be pooled without merging mismatching types.";


(* Authors definition for Experiment`Private`poolCovidSamples *)
Authors[Experiment`Private`poolCovidSamples]:={"hayley", "mohamad.zandian"};

poolCovidSamples[poolTuples_Association,maxSamples_Integer]:=Module[{mostExtremePooling,initialPooledSamples,initialPoolCounts,finalPoolCounts},
	
	(* Pool everything -- based on $MaxCovidPoolSize, we cannot pool anymore than this. We will unfurl the pools until we reach the sample count we need below *)
	mostExtremePooling=KeyValueMap[#1->PartitionRemainder[#2,$MaxCovidPoolSize]&,poolTuples];
	
	(* If we cannot fit everything even with the most extreme case of pooling, throw an error *)
	If[
		Total[Length/@Values[mostExtremePooling]]>maxSamples,
		Module[{},
			Message[Error::TooManySamplesToPool];
			Return[$Failed]
		]
	];
	
	(* Unpool until we get to the max sample size -- this is technically a valid pooling of samples, but the pool sizes are kind of random. We may have a pool of size 1, then a pool of size 3, then a pool of size 2. We will clean this up below *)
	initialPooledSamples=FixedPoint[
		Function[
			currentPoolingRules,
			Module[{maxPoolsize,allMaxSizePoolsUnpooled},

				(* Find the largest pool we have right now *)
				maxPoolsize=Max[Flatten[Map[Length,Values[currentPoolingRules],{2}]]];

				(* Unpool one sample from each of the max samples *)
				allMaxSizePoolsUnpooled=Replace[currentPoolingRules,pool:_List?(Length[#]==maxPoolsize&):>Sequence@@{Most[pool],{Last[pool]}},{3}];

				(* If we can unpool everything without exceeding max sample size, pass it down to the next iteration; otherwise, only unpool until we reach the max count *)
				If[
					Total[Length/@Values[allMaxSizePoolsUnpooled]]<=maxSamples,
					allMaxSizePoolsUnpooled/.{}->Nothing,
					Module[{currentTotalPoolCount,poolCountToUnpool,poolsToUnpool},

						(* Find out how many total pools we have right now *)
						currentTotalPoolCount=Total[Length/@Values[currentPoolingRules]];

						(* Calculate how many single samples we need to remove from our pools to reach max number of samples *)
						poolCountToUnpool=maxSamples-currentTotalPoolCount;

						(* Find the pools of max size that we have and take the amount we need to unpool to bring sample count to maxSamples -- we are using RandomChoice instead of Take so that the long pools aren't always in the last keys. This way, the larger pools are randomly distributed. However, this means that the function will not produce the same output if we run it again *)
						poolsToUnpool=RandomChoice[Cases[currentPoolingRules,_List?(Length[#]==maxPoolsize&),{3}],poolCountToUnpool];

						(* Unpool the pools we found above and return *)
						currentPoolingRules/.((#1->Sequence@@{Most[#],{Last[#]}})&/@poolsToUnpool)
					]
				]
			]
		],
		mostExtremePooling
	];
	
	(* Find the pool sizes in each case -- this creates a list of lists which has elements of {pool size, number of pools}. So if we have {{1,10},{2,20}}, that means we have 10 pools of 1 sample and 20 pools of 2 samples. We will use this information below so that we can split the pools in the sample order we were given. Also, this list is not guaranteed to have all values of pool size; that is, if we do not have any pools of 2, but have pool sizes of 3, we can have {{1,10},{3,30}}. We will pad the list below and add {2,0} *)
	initialPoolCounts=KeyValueMap[#1->Tally[Length/@#2]&,Association[initialPooledSamples]];
	
	(* Make a list of pool counts for each possible pool size -- this will return a single list for all possible values of $MaxCovidPoolSize. If $MaxCovidPoolSize=3, then it would return a list like {5,10,15}, which would mean 10 pools of size 1, 20 pools of size 2 and 30 pools of size 3. Importantly, we add any zero values here, so if we had the {{1,10},{3,30}} example from above, that will get converted to {10,0,30}. This is necessary for pooling code below to work since it uses MapIndexed. Without this, we will make 30 pools of size 2 below and lose 30 samples *)
	finalPoolCounts=KeyValueMap[
		Function[
			{shift,poolCounts},
			Module[{missingPoolTuples},
				
				(* Make tuples of {n,0} for any pool sizes we aren't preparing *)
				missingPoolTuples={#,0}&/@Complement[Range[$MaxCovidPoolSize],poolCounts[[All,1]]];
				
				(* Add the missing tuples to our list and remove the first element, which can be tracked through the index since all possible values of the pool size exist in our list now *)
				shift->Last/@SortBy[Join[poolCounts,missingPoolTuples],First]
			]
		],
		Association[initialPoolCounts]
	];
	
	(* Create a final pool based on the pool sizes we have for each shift and return the list *)
	Flatten[MapThread[
		Function[
			{shiftSamples,poolCounts},
			Module[{samplesSplitByPoolSize},
				
				(* Split the samples by pool size -- the first element of the list will be pool size 1, and the second element 2, etc *)
				samplesSplitByPoolSize=TakeList[shiftSamples,Flatten[MapIndexed[#1*#2&,poolCounts]]];
				
				(* Group the pools together *)
				MapIndexed[Partition[#1,#2]&,samplesSplitByPoolSize]
			]
		],
		{Values[poolTuples],Values[finalPoolCounts]}
	],2]
];

(* Authors definition for PrepareExperimentRoboticCOVID19Test *)
Authors[PrepareExperimentRoboticCOVID19Test]:={"hayley", "mohamad.zandian"};