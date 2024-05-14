(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentCOVID19Test*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCOVID19Test Options*)


DefineOptions[ExperimentCOVID19Test,
	Options:>{
		ProtocolOptions,
		PostProcessingOptions
	}
];


Error::COVID19TestTooManySamples="The number of input samples cannot fit onto the instrument in a single protocol. Please select fewer than `1` samples to run this protocol.";
Error::DuplicateCOVID19TestInputs="There are duplicate samples and/or containers in inputs `1`. Please check that no duplicate sample or containers are provided.";


(* ::Subsubsection::Closed:: *)
(*ExperimentCOVID19Test*)


(*Main function accepting sample objects as sample inputs*)
ExperimentCOVID19Test[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:OptionsPattern[ExperimentCOVID19Test]
]:=Module[
	{outputSpecification,output,gatherTests,messages,listedSamples,listedOptions,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,optionsAssociation,
		cache,upload,confirm,parentProtocol,sampleDownloadFields,sampleContainerDownloadFields,allSamplePackets,cacheBall,sampleCache,
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
		SafeOptions[ExperimentCOVID19Test,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCOVID19Test,listedOptions,AutoCorrect->False],{}}
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
		ValidInputLengthsQ[ExperimentCOVID19Test,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCOVID19Test,{listedSamples},listedOptions],Null}
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
		ApplyTemplateOptions[ExperimentCOVID19Test,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCOVID19Test,{listedSamples},listedOptions],Null}
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
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentCOVID19TestOptions[listedSamples,inheritedOptions,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentCOVID19TestOptions[listedSamples,inheritedOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentCOVID19Test,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(*If option resolution failed, return early*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentCOVID19Test,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*--Build packets with resources--*)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		experimentCOVID19TestResourcePackets[listedSamples,inheritedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{experimentCOVID19TestResourcePackets[listedSamples,inheritedOptions,resolvedOptions,Cache->cacheBall],{}}
	];

	(*If we don't have to return the Result, don't bother calling UploadProtocol*)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentCOVID19Test,collapsedResolvedOptions],
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
			ConstellationMessage->Object[Protocol,COVID19Test]
		],
		$Failed
	];

	(*Return the requested output*)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentCOVID19Test,collapsedResolvedOptions],
		Preview->Null
	}
];


(*---Function overload accepting sample/container objects as sample inputs---*)
ExperimentCOVID19Test[
	myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[ExperimentCOVID19Test]
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
			ExperimentCOVID19Test,
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
				ExperimentCOVID19Test,
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
		ExperimentCOVID19Test[
			samples,
			ReplaceRule[sampleOptions, {Cache -> sampleCache}]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentCOVID19TestOptions*)


DefineOptions[resolveExperimentCOVID19TestOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


resolveExperimentCOVID19TestOptions[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentCOVID19TestOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,inheritedCache,optionsAssociation,
		sampleDownloadFields,sampleContainerDownloadFields,allSamplePackets,samplePackets,sampleContainerPackets,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,
		sampleContainers,gatheredSampleContainers,duplicateInvalidInputs,duplicateTest,
		tooManySamplesQ,tooManySamplesInvalidInputs,tooManySamplesTest,
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

	(*--Too many samples check--*)

	(*Check if there are too many samples for qPCR (3 different probe reactions per sample/+control/-control)*)
	tooManySamplesQ=Length[myListedSamples]>126;

	(*Set tooManySamplesInvalidInputs to all sample objects*)
	tooManySamplesInvalidInputs=If[tooManySamplesQ,
		Lookup[samplePackets,Object],
		{}
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[tooManySamplesQ&&messages,
		Message[Error::COVID19TestTooManySamples,126]
	];

	(*If we are gathering tests, create a test for too many samples*)
	tooManySamplesTest=If[gatherTests,
		Test["There are 126 or fewer input samples:",
			tooManySamplesQ,
			False
		],
		Nothing
	];


	(*---Conflicting options checks---*)

	(*--Check that Name is properly specified--*)

	(*If the specified Name is a string, check if this name exists in the Database already*)
	name=Lookup[optionsAssociation,Name];
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,COVID19Test,name]]],
		True
	];

	(*If validNameQ is False and we are throwing messages, then throw an error message*)
	invalidNameOptions=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"COVID19Test protocol"];
			{Name}
		),
		{}
	];

	(*If we are gathering tests, create a test for Name*)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a COVID19Test protocol object name:",
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
		duplicateInvalidInputs,
		tooManySamplesInvalidInputs
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
		tooManySamplesTest,
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
(*experimentCOVID19TestResourcePackets*)


DefineOptions[experimentCOVID19TestResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


experimentCOVID19TestResourcePackets[
	myListedSamples:ListableP[ObjectP[Object[Sample]]],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[experimentCOVID19TestResourcePackets]
]:=Module[
	{unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		samplesInLength,samplesInResources,containersInResources,disinfectantResource,
		biosafetyCabinetResource,aliquotVesselsResources,cellLysisBufferResource,viralLysisBufferResource,rnaExtractionColumnsResources,
		primaryCollectionVesselsResources,secondaryCollectionVesselsResources,primaryWashSolutionResource,secondaryWashSolutionResource,elutionVesselsResources,elutionSolutionResource,
		noTemplateControlResource,viralRNAControlResource,testContainersResources,n1Resource,n2Resource,rpResource,masterMixResource,
		protocolPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,resultRule,testsRule},

	(*Get the collapsed unresolved index-matching options that don't include hidden options*)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentCOVID19Test,myUnresolvedOptions];

	(*Get the collapsed resolved index-matching options that don't include hidden options*)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentCOVID19Test,
		RemoveHiddenOptions[ExperimentCOVID19Test,myResolvedOptions],
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


	(*---Generate all the resources for the experiment---*)

	(*--Generate the samples/containers in resources--*)

	(*Samples in*)
	samplesInLength=Length[myListedSamples];

	samplesInResources=Map[
		Resource[Sample->#,Name->ToString[Unique[]],Amount->300 Microliter]&,
		myListedSamples
	];

	(*Containers in*)
	containersInResources=Map[
		Resource[Sample->#,Name->ToString[Unique[]]]&,
		Download[myListedSamples,Container[Object],Cache->inheritedCache]
	];

	(*--Generate the Reagent Preparation resources--*)
	disinfectantResource=Resource[Sample->Model[Sample,StockSolution,"10% Bleach"],Amount->samplesInLength*40 Milliliter];

	(*--Generate the RNA Extraction resources for 300 uL input samples--*)
	biosafetyCabinetResource=Resource[Instrument->Object[Instrument,BiosafetyCabinet,"TC Hood"],Time->28 Hour];
	aliquotVesselsResources=Table[Resource[Sample->Model[Container,Vessel,"2mL Tube"],Name->ToString[Unique[]]],samplesInLength];

	cellLysisBufferResource=Resource[Sample->Model[Sample,"DNA/RNA Shield 2x (Quick-RNA Viral Kit)"],Amount->samplesInLength*300 Microliter];
	viralLysisBufferResource=Resource[Sample->Model[Sample,StockSolution,"Viral RNA Buffer (Quick-RNA Viral Kit) Stock Solution"],Amount->samplesInLength*1.2 Milliliter];
	rnaExtractionColumnsResources=Table[Resource[Sample->Model[Container,Vessel,Filter,"Zymo-Spin IC Column (Quick-RNA Viral Kit)"],Name->ToString[Unique[]]],samplesInLength];

	primaryCollectionVesselsResources=Table[Resource[Sample->Model[Container,Vessel,"Zymo-Spin IC Column Collection Tube"],Name->ToString[Unique[]]],samplesInLength];
	secondaryCollectionVesselsResources=Table[Resource[Sample->Model[Container,Vessel,"Zymo-Spin IC Column Collection Tube"],Name->ToString[Unique[]]],samplesInLength];
	primaryWashSolutionResource=Resource[Sample->Model[Sample,StockSolution,"Viral Wash Buffer Concentrate (Quick-RNA Viral Kit) Stock Solution"],Amount->samplesInLength*1 Milliliter];
	secondaryWashSolutionResource=Resource[Sample->Model[Sample,"Absolute Ethanol, Molecular Biology Grade"],Amount->samplesInLength*500 Microliter];
	elutionVesselsResources=Table[Resource[Sample->Model[Container,Vessel,"Zymo-Spin IC Column Collection Tube"],Name->ToString[Unique[]]],samplesInLength];
	elutionSolutionResource=Resource[Sample->Model[Sample,"DNase/RNase-free water (Quick-RNA Viral Kit)"],Amount->samplesInLength*(15 Microliter+25 Microliter)];(*25 uL extra per sample*)

	(*--Generate the RT-qPCR resources--*)
	noTemplateControlResource=Resource[Sample->Model[Sample,"Nuclease-free Water"],Amount->5 Microliter*3+35 Microliter,Container->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"]];(*35 uL extra*)
	viralRNAControlResource=Resource[Sample->Model[Sample, StockSolution, "SARS-CoV-2 RNA (MT007544.1) 100X Dilution (Primitive Based)"],Amount->5 Microliter*3+35 Microliter];(*35 uL extra*)
	testContainersResources=Table[Resource[Sample->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Name->ToString[Unique[]]],samplesInLength];
	n1Resource=Resource[Sample->Model[Sample, StockSolution, "2019-nCoV_N1 CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(samplesInLength+2)*0.5 Microliter+10 Microliter];(*10 uL extra required by qPCR*)
	n2Resource=Resource[Sample->Model[Sample, StockSolution, "2019-nCoV_N2 CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(samplesInLength+2)*0.5 Microliter+10 Microliter];(*10 uL extra required by qPCR*)
	rpResource=Resource[Sample->Model[Sample, StockSolution, "RNAse P CDC SARS-CoV-2 Probe and Primer Mix, LGC Kit (Primitive Based)"],Amount->(samplesInLength+2)*0.5 Microliter+10 Microliter];(*10 uL extra required by qPCR*)
	masterMixResource=Resource[Sample->Model[Sample,"TaqMan Fast Virus 1-Step Master Mix"],Amount->Min[Ceiling[(samplesInLength+2)*3/2],8]*(5 Microliter+Ceiling[(samplesInLength+2)*3/Min[Ceiling[(samplesInLength+2)*3/2],8]]*5 Microliter),Container->Model[Container,Vessel,"2mL Tube"]];(*5 uL extra per 96-well deep well prep plate well required by qPCR*)


	(*---Make the protocol packet---*)
	protocolPacket=<|
		(*===Organizational Information===*)
		Object->CreateID[Object[Protocol,COVID19Test]],
		Type->Object[Protocol,COVID19Test],
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
		Replace[ContainersIn]->(Link[#,Protocols]&/@containersInResources),


		(*===Options Handling===*)
		UnresolvedOptions->unresolvedOptionsNoHidden,
		ResolvedOptions->resolvedOptionsNoHidden,


		(*===Resources===*)
		Replace[Checkpoints]->{
			{"Picking Resources",1 Hour,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Hour]]},
			{"Preparing Reagents",1 Hour,"RNA extraction reagents are prepared.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Hour]]},
			{"Extracting RNA",28 Hour,"RNA is extracted and purified.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->28 Hour]]},
			{"RT-qPCR",5 Hour,"Thermocycling procedure is performed on the reaction mixtures.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->5 Hour]]},
			{"Returning Materials",1 Hour,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Hour]]}
		},


		(*===Sample Storage===*)
		Replace[SamplesInStorage]->Table[Disposal,samplesInLength],


		(*===Reagent Preparation===*)
		Disinfectant->Link[disinfectantResource],


		(*===RNA Extraction===*)
		BiosafetyCabinet->Link[biosafetyCabinetResource],
		Replace[AliquotVessels]->Link/@aliquotVesselsResources,

		CellLysisBuffer->Link[cellLysisBufferResource],
		ViralLysisBuffer->Link[viralLysisBufferResource],
		Replace[RNAExtractionColumns]->Link/@rnaExtractionColumnsResources,

		Replace[PrimaryCollectionVessels]->Link/@primaryCollectionVesselsResources,
		Replace[SecondaryCollectionVessels]->Link/@secondaryCollectionVesselsResources,
		PrimaryWashSolution->Link[primaryWashSolutionResource],
		SecondaryWashSolution->Link[secondaryWashSolutionResource],
		Replace[ElutionVessels]->Link/@elutionVesselsResources,
		ElutionSolution->Link[elutionSolutionResource],


		(*===RT-qPCR===*)
		ReactionVolume->20 Microliter,
		NoTemplateControl->Link[noTemplateControlResource],
		ViralRNAControl->Link[viralRNAControlResource],
		Replace[TestContainers]->Link/@testContainersResources,
		SampleVolume->5 Microliter,

		(*Primers and Probes*)
		Replace[ForwardPrimers]->Link/@{n1Resource,n2Resource,rpResource},
		ForwardPrimerVolume->0.5 Microliter,
		Replace[ReversePrimers]->Link/@{n1Resource,n2Resource,rpResource},
		ReversePrimerVolume->0.5 Microliter,
		Replace[Probes]->Link/@{n1Resource,n2Resource,rpResource},
		ProbeVolume->0.5 Microliter,
		ProbeExcitationWavelength->470 Nanometer,
		ProbeEmissionWavelength->520 Nanometer,

		(*Master Mix and Buffer*)
		MasterMix->Link[masterMixResource],
		MasterMixVolume->5 Microliter,
		ReactionBuffer->Link[Model[Sample,"Nuclease-free Water"]],
		ReactionBufferVolume->8.5 Microliter,

		(*Thermocycling*)
		Thermocycler->Link[Object[Instrument,Thermocycler,"Herbert"]],
		ReverseTranscriptionRampRate->1.9 Celsius/Second,
		ReverseTranscriptionTemperature->50 Celsius,
		ReverseTranscriptionTime->5 Minute,
		ActivationRampRate->1.9 Celsius/Second,
		ActivationTemperature->95 Celsius,
		ActivationTime->20 Second,
		DenaturationRampRate->1.9 Celsius/Second,
		DenaturationTemperature->95 Celsius,
		DenaturationTime->3 Second,
		ExtensionRampRate->1.6 Celsius/Second,
		ExtensionTemperature->60 Celsius,
		ExtensionTime->30 Second,
		NumberOfCycles->45,

		(*Post-processing*)
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