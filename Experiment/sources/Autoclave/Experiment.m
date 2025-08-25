(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment Autoclave: Source*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(* Options *)


DefineOptions[ExperimentAutoclave,
	Options:>{
		{
			OptionName->AutoclaveProgram,
			Default->Automatic,
			Description->"Indicates the type of autoclave cycle to run. Liquid cycle is recommended for liquid samples, and Universal cycle is recommended for everything else.",
			ResolutionDescription->"The AutoclaveProgram is automatically resolved based on the state of the sample input(s).",
			AllowNull->False,
			Category->"Method",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Automatic,AutoclaveProgramP]
			]
		},
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"Specifies the instrument or model of the instrument on which this protocol will be run.",
			ResolutionDescription->"Currently the Instrument is automatically resolved to the only Model of Autoclave.",
			AllowNull->False,
			Category->"Method",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Instrument,Autoclave],Model[Instrument,Autoclave]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Sanitary Devices",
						"Autoclaves"
					}
				}
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SterilizationBag,
				Default->Automatic,
				Description->"The autoclave bag into which the sample is sealed before autoclaving. The bag protects the sample's sterility after autoclaving.",
				ResolutionDescription->"Automatically set to an autoclave bag model big enough to fit the sample if the SterilizationBag Field of the Model of the input sample is True. Automatically set to Null otherwise, indicating that the sample is not put into an autoclave bag.",
				AllowNull->True,
				Category->"Method",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,Bag,Autoclave],Object[Container,Bag,Autoclave]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Labware",
							"Cleaning Supplies",
							"Autoclave Supplies"
						}
					}
				]
			}
		],
		SimulationOption,
		NonBiologyFuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		ModelInputOptions
	}
];

(* --- Errors go here ---- *)
(* Messages before the option resolution *)
Error::InvalidAutoclaveContainer="The following input sample(s), `1`, are in containers that are not of Model[Container,Vessel]. Please transfer these samples to an appropriate container, or enter a different sample.";
Error::DuplicateAutoclaveInputs="The following input object(s), `1`, is present more than one time as an input to ExperimentAutoclave. Each input to be autoclaved can only be present in the input list one time - please remove duplicate instances of this input.";
Error::NotEnoughAutoclaveSpace="The sum of the footprint areas (Length times Width in the Model's Dimensions field) of the input list, `1`, is `2`. The maximum allowed footprint area is 0.25 square meters. Please input fewer objects.";
Error::InputTooLargeForAutoclave="The following input(s), `1`, cannot fit inside the autoclave, as one of it's dimensions is longer than 0.5 meters. Please enter a different input.";
Error::InvalidEmptyAutoclaveContainer="The following input, `1`, is an empty container that cannot be safely autoclaved, as its MaxTemperature is lower than 120 Celsius.";
Error::UnsafeAutoclaveContainerContents="The following input(s), `1`, have contents that are at least one of the following: Flammable, Acid, Base, Pyrophoric, WaterReactive, or Radioactive, and are thus not safe to autoclave. Please remove these inputs.";
Error::ContainerWithSolidContentsNotAutoclaveSafe="The following containers, `1` are not safe to autoclave, and have solid contents that cannot be automatically transferred. Please remove this input, or transfer the contents to an autoclave-safe container.";
(* Messages during option resolution *)
Error::InvalidAutoclaveProgram="The user-specified AutoclaveProgram Option of Universal is not valid because there is at least one liquid input. Please set the AutoclaveOption to Automatic or Liquid, or remove liquid inputs.";
Error::InvalidAutoclaveProgramForBags="AutoclaveProgram is specified to Liquid, but some samples are specified to be placed in autoclave bags. Autoclave bags can not be used with the Liquid AutoclaveProgram. Please set AutoclaveProgram to Dry or Universal or set SterilizationBag to Null.";
Warning::IncompatibleSterilizationMethods="The following inputs, `1`, were specified sterilization bags, `2`, which are incompatible with autoclaving. We will instead put these inputs in bags that are compatible with autoclaving, `3`. If this is not desired, please choose different autoclave bags or set SterilizationBag->Null to autoclave the inputs without bags.";
Error::InputTooLargeForAutoclaveBag="The following inputs, `1`, are too large to fit in the autoclave bags to which they are assigned, `2`. Please select or order a larger type of autoclave bag or set SterilizationBag->Null to autoclave the inputs without bags.";
Error::NoValidAutoclaveBagModels="The following inputs, `1`, automatically resolved to use an autoclave bag, but there are no autoclave bag models present in the database that have SterilizationMethods compatible with autoclaving. Please order a model of autoclave bag with SterilizationMethods->{Autoclave} or set SterilizationBag->Null to autoclave the inputs without bags.";
Warning::AutoclaveContainerTooFull="The following containers, `1`, have Contents with Volumes larger than 3/4 of the MaxVolume of the container. We will attempt to move the contents into the following containers, `2`, so that they can be autoclaved. If this is not desired, please choose a different input container or transfer the contents to a desired container.";
Warning::NonEmptyContainerNotAutoclaveSafe="The following containers, `1`, are not autoclave-safe and have non-Solid Contents. We will attempt to move the contents into the following autoclave-safe containers, `2`. If this is not desired, please choose a different input container or transfer the contents to a desired container.";


(* ::Subsection::Closed:: *)
(*ExperimentAutoclave *)

(* Helper function that memoizes the Search for autoclave bag Models. *)
possibleAutoclaveBagModelsSearch[memoizationString_]:=possibleAutoclaveBagModelsSearch[memoizationString]=Module[{},
	If[!MemberQ[$Memoization,Experiment`Private`possibleAutoclaveBagModelsSearch],
		AppendTo[$Memoization,Experiment`Private`possibleAutoclaveBagModelsSearch]
	];
	Search[Model[Container,Bag,Autoclave],Any[SterilizationMethods==Autoclave]]
];

(* --- Main definition, the least permissive input pattern-wise. Does not accept non-self-contained samples --- *)
ExperimentAutoclave[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Item]}]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,listedInputs,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
		mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,itemInputs,containerInputs,
		sterilizationBagOption,bagModelInputs,bagObjectInputs,bagModelDownloadFields,bagObjectDownloadFields,bagModelPacketsNested,bagObjectPacketsNested,
		instrumentOption,instrumentDownloadFields,allPossibleInstrumentModels,
		possibleAutoclaveBagModels,possibleAutoclaveBagDownloadFields,possibleAutoclaveBagModelPacketsNested,possibleAutoclaveBagModelPackets,
		possibleInstrumentDownloadFields,objectSamplePacketFields,modelSamplePacketFields,objectSampleFields,possibleInstrumentPackets,
		instrumentOptionPackets,objectContainerPacketFields,modelContainerFields, updatedSimulation,
		listedSamplePackets,listedContainerPackets,preferredContainersPackets,preferredContainers,inputsInOrder,cacheBall,inputObjects,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,preferredContainersPacketsNested
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedInputs,listedOptions}=removeLinks[ToList[myInputs],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAutoclave,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentAutoclave,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentAutoclave,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentAutoclave,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentAutoclave,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentAutoclave,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentAutoclave,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentAutoclave,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(* -- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
	(* Sort the input samples into two lists based on if the inputs are containers or samples *)
	itemInputs=Cases[mySamplesWithPreparedSamples,ObjectP[Object[Item]]];

	containerInputs=Cases[mySamplesWithPreparedSamples,ObjectP[Object[Container]]];

	(* Get the SterilizationBag options from the Safe ops *)
	sterilizationBagOption=Lookup[expandedSafeOps,SterilizationBag];

	(* Get members of the SterilizationBag Option that are Models, index matched with the option, Null if not a Model *)
	bagModelInputs=If[
		MatchQ[#,ObjectP[Model[Container,Bag,Autoclave]]],
		#,
		Null
	]&/@sterilizationBagOption;

	(* Get members of the SterilizationBag Option that are Objects, index matched with the option, Null if not a Object *)
	bagObjectInputs=If[MatchQ[#,ObjectP[Object[Container,Bag,Autoclave]]],
		#,
		Null
	]&/@sterilizationBagOption;

	(* Choose the fields we download from the autoclave bag based on if the given option is a Model versus an Object *)
	bagModelDownloadFields={Packet@@Append[SamplePreparationCacheFields[Model[Container]],SterilizationMethods]};
	bagObjectDownloadFields={
		Packet@@Append[SamplePreparationCacheFields[Object[Container]],Model],
		Packet[Model@@Append[SamplePreparationCacheFields[Model[Container]],SterilizationMethods]]
	};

	(* get the Instrument option from the Safe ops *)
	instrumentOption=Lookup[expandedSafeOps,Instrument,Automatic];

	(* Choose the fields we download from the instrument based on if the given option is a Model versus and Object versus Automatic *)
	instrumentDownloadFields=Switch[instrumentOption,
		ObjectP[Model[Instrument]],{Packet[Name,InternalDimensions]},
		ObjectP[Object[Instrument]],{Packet[Model,Status],Packet[Model[{Name,InternalDimensions}]]},
		_,{}
	];

	(* List of all PreferredContainers*)
	preferredContainers=PreferredContainer[All];

	(* List of all the possible autoclave models that automatic could resolve to *)
	allPossibleInstrumentModels={Model[Instrument,Autoclave,"id:KBL5DvYl3z1N"]};

	(* Memoized Search for compatible autoclave bag Models: Search[Model[Container,Bag,Autoclave],Any[SterilizationMethods==Autoclave]] *)
	possibleAutoclaveBagModels=possibleAutoclaveBagModelsSearch["Memoization"];

	(* Fields to download from autoclave models *)
	possibleInstrumentDownloadFields={Packet[Name,InternalDimensions]};

	(* Fields to download from autoclave bag models *)
	possibleAutoclaveBagDownloadFields={Packet@@Join[SamplePreparationCacheFields[Object[Container]],{SterilizationMethods,Dimensions}]};

	(* Create the Packet and List Download syntax for our Object and Model samples and containers *)
	objectSampleFields=Flatten[{Flammable,Acid,Base,Pyrophoric,WaterReactive,Radioactive,SamplePreparationCacheFields[Object[Sample]]}];
	objectSamplePacketFields=Packet@@objectSampleFields;
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,Composition,SterilizationBag,SterilizationMethods,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerPacketFields=SamplePreparationCacheFields[Object[Container],Format->Packet];
	modelContainerFields=Flatten[{SterilizationBag,SterilizationMethods,SamplePreparationCacheFields[Model[Container]]}];

	(* Download all of the information we need from the inputs *)
	{
		listedSamplePackets,
		listedContainerPackets,
		inputsInOrder,
		instrumentOptionPackets,
		possibleInstrumentPackets,
		preferredContainersPacketsNested,
		possibleAutoclaveBagModelPacketsNested,
		bagModelPacketsNested,
		bagObjectPacketsNested
	}=Quiet[
		Download[
			{
				itemInputs,
				containerInputs,
				mySamplesWithPreparedSamples,
				{(instrumentOption/.{Automatic->Null})},
				allPossibleInstrumentModels,
				preferredContainers,
				possibleAutoclaveBagModels,
				bagModelInputs,
				bagObjectInputs
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields
				},
				{
					objectContainerPacketFields,
					Packet[Model[modelContainerFields]],
					Packet[Field[Contents[[All,2]][Evaluate[objectSampleFields]]]]
				},
				{
					Packet[Object]
				},
				instrumentDownloadFields,
				possibleInstrumentDownloadFields,
				{
					Evaluate[Packet@@modelContainerFields]
				},
				possibleAutoclaveBagDownloadFields,
				bagModelDownloadFields,
				bagObjectDownloadFields
			},
			Cache -> Lookup[expandedSafeOps, Cache, {}],
			Simulation -> updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	cacheBall = FlattenCachePackets[{listedSamplePackets, listedContainerPackets}];

	inputObjects=Lookup[Flatten[inputsInOrder],Object];

	(*Downloaded Packet lists are in the form of {{Association}..}. Flatten them.*)
	preferredContainersPackets=preferredContainersPacketsNested//Flatten;
	possibleAutoclaveBagModelPackets=possibleAutoclaveBagModelPacketsNested//Flatten;


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentAutoclaveOptions[inputObjects, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentAutoclaveOptions[inputObjects, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentAutoclave,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentAutoclave,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		autoclaveResourcePackets[inputObjects, templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{autoclaveResourcePackets[inputObjects, templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentAutoclave,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=If[!MatchQ[resourcePackets,$Failed],
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
			ConstellationMessage->Object[Protocol,Autoclave],
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options->RemoveHiddenOptions[ExperimentAutoclave,collapsedResolvedOptions],
		Preview->Null
	}
];

(* --- ExperimentAutoclave overload that takes all objects and all samples --- *)
ExperimentAutoclave[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,listedInputs,outputSpecification,output,gatherTests,messages,allInputSamples,nonSelfContainedSamples,nonSelfContainedSampleContainers,validSampleInputs,invalidSampleInputs,
		inputSampleContainerTests,sampleToContainerReplaceRules,myNewInputs,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples, updatedSimulation
	},

	(* Make sure we're working with a list of options and list of inputs *)
	listedOptions=ToList[myOptions];
	listedInputs=ToList[myInputs];
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAutoclave,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Make a list of the non-container inputs (not containers containing input samples) *)
	allInputSamples=Cases[mySamplesWithPreparedSamples,Except[ObjectP[Object[Container]]]];

	(* Make a list of the NonSelfContainedSamples *)
	nonSelfContainedSamples=Cases[allInputSamples,Except[ObjectP[SelfContainedSampleTypes]]];

	(* Download the container of the non-self-contained samples*)
	nonSelfContainedSampleContainers=Quiet[
		Download[nonSelfContainedSamples,Container[Object], Simulation -> updatedSimulation],
		{Download::ObjectDoesNotExist}
	];

	(* Make a list of invalid sample inputs, the non-self-contained samples that are not in an Object[Container,Vessel] *)
	invalidSampleInputs=PickList[nonSelfContainedSamples,nonSelfContainedSampleContainers,Except[ObjectP[Object[Container,Vessel]]]];

	(* Also make a list of the valid sample inputs, the non-self-contained samples that are in an Object[Container,Vessel] *)
	validSampleInputs=PickList[nonSelfContainedSamples,nonSelfContainedSampleContainers,ObjectP[Object[Container,Vessel]]];

	(* If we are throwing messages, throw two error messages if there are any invalid sample inputs *)
	If[Length[invalidSampleInputs]>0&&messages,
		{Message[Error::InvalidAutoclaveContainer,ObjectToString[invalidSampleInputs, Simulation -> updatedSimulation]],Message[Error::InvalidInput,ObjectToString[invalidSampleInputs, Simulation -> updatedSimulation]]}
	];

	(* If we are gathering tests, define the tests the user will see to check if the nonselfcontainedsample inputs are in appropriate containers *)
	inputSampleContainerTests=If[Length[invalidSampleInputs]>0&&gatherTests,
		Module[{passingTest,failingTest},
			failingTest=If[Length[invalidSampleInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[invalidSampleInputs, Simulation -> updatedSimulation]<>" are in Containers of Model[Container,Vessel]:",True,False]
			];
			passingTest=If[Length[validSampleInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[validSampleInputs, Simulation -> updatedSimulation]<>" are in Containers of Model[Container,Vessel]:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* we need to recreate the list of inputs with any self-contained samples converted to their containers *)
	(* First, make the replace rules *)
	sampleToContainerReplaceRules=MapThread[
		(#1->#2)&,
		{nonSelfContainedSamples,nonSelfContainedSampleContainers}
	];

	(* Then use the rules to replace instances of selfcontainedsamples in myInputs with their respective containers *)
	myNewInputs=mySamplesWithPreparedSamples/.sampleToContainerReplaceRules;

	(* If we are given a sample in a container that is not a Vessel, we need to return early here *)
	If[Length[invalidSampleInputs]>0,
		(* Return early here *)
		outputSpecification/.{
			Result->$Failed,
			Tests->inputSampleContainerTests,
			Options->$Failed,
			Preview->Null
		},

		(* Otherwise, call the core function with nonSelfContainedSamples replaced by their containers *)
		ExperimentAutoclave[myNewInputs, ReplaceRule[myOptionsWithPreparedSamples, Simulation -> updatedSimulation]]
	]
];


(* ::Subsubsection:: *)
(*resolveExperimentAutoclaveOptions*)


DefineOptions[
	resolveExperimentAutoclaveOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentAutoclaveOptions[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}]],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentAutoclaveOptions]]:=Module[
	{
		outputSpecification,output,listedInputs,gatherTests,messages,notInEngine,cache,samplePrepOptions,autoclaveOptions,simulatedSamples,
		resolvedSamplePrepOptions,autoclaveOptionsAssociation,autoclaveProgramOption,name,itemInputs,containerInputs,
		sterilizationBagOption,bagModelInputs,bagObjectInputs,bagModelDownloadFields,bagObjectDownloadFields,bagModelPacketsNested,bagModelPackets,bagObjectPacketsNested,
		instrumentOption,instrumentDownloadFields,
		allPossibleInstrumentModels,possibleInstrumentDownloadFields,objectSamplePacketFields,modelSamplePacketFields,objectSampleFields,
		possibleAutoclaveBagModels,possibleAutoclaveBagDownloadFields,possibleAutoclaveBagModelPacketsNested,possibleAutoclaveBagModelPackets,
		listedSamplePackets,listedContainerPackets,inputsInOrder,instrumentOptionPackets,possibleInstrumentPackets,
		sampleObjectPackets,sampleModelPackets,containerObjectPackets,containerModelPackets,containerContentsObjectPackets,
		joinedObjectPackets,joinedModelPackets,joinedContentsObjectPackets,combinedUnsortedPackets,
		combinedSortedPackets,inputObjectPackets,inputModelPackets,inputContentsObjectPackets,objectAndContentsObjectPackets,
		discardedObjectPackets,nonDiscardedObjectPackets,discardedInvalidInputs,nonDiscardedInputs,discardedTests,duplicateInvalidInputs,duplicateValidInputs,
		duplicateInputTests,allInputsFitInAutoclaveTogetherBool,totalFootprintArea,notEnoughAutoclaveSpaceInvalidInputs,notEnoughAutoclaveSpaceTests,shortestAutoclaveDimension,
		invalidDimensionsInputs,validDimensionsInputs,
		inputTooLargeTests,emptyContainers,emptyContainerModelPackets,emptyContainerMaxTemperatures,invalidEmptyContainerInputs,validEmptyContainerInputs,invalidEmptyContainerTests,
		contentsSafetyBooleanLists,contentsSafetyBooleans,invalidUnsafeContentsInputs,validUnsafeContentsInputs,invalidUnsafeContentsTests,invalidNonEmptyContainerInputs,invalidNonEmptyContainersTest,
		validNameQ,invalidNameOption,validNameTest,resolvedInstrument,autoclaveInternalDimensions,autoclaveWorksurfaceArea,validNonEmptyContainerInputs,
		suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedAssayBuffers,suppliedAliquotContainers,suppliedTargetConcentrations,
		suppliedConcentratedBuffer,suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAliquotSampleStorageCondition,suppliedConsolidateAliquots,suppliedAliquotLiquidHandlingScale,
		nonEmptyContainerObjectPackets,nonEmptyContainers,nonEmptyContainerContentsObjectPackets,
		nonEmptyContainerModelPackets,listOfContainerTypes,listOfVolumes,listOfVolumesNoNull,listOfMaxVolumes,listOfMaxTemperatures,listOfContentsStates,listOfContentsStatesNoNull,nonEmptyContainersWithSolids,
		nonEmptyContainersWithLiquids,nonEmptyAutoclaveBagContainers,listOfVolumeRatios,tooFullContainers,notTooFullContainers,volumeOfTooFullTransfers,safeTooFullTransferContainers,
		nonEmptyContainersWithTooLowMaxTemp,nonAutoclavableContainersLiquidInputs,autoclavableContainersLiquidInputs,volumeOfNonAutoclavableLiquidContainers,
		safeNotAutoclaveSafeTransferContainers,invalidContainersSolidInputs,validContainersSolidInputs,validSolidContainersTests,
		universalProgramPreferredInputs,liquidProgramPreferredInputs,preferredAutoclaveProgram,
		invalidAutoclaveProgramForBagsError,invalidAutoclaveProgramForBagsOption,invalidAutoclaveProgramForBagsTest,
		invalidAutoclaveProgramOption,validAutoclaveProgramTests,resolvedAutoclaveProgram,
		sterilizationMethodWarningInputs,sterilizationMethodWarningBags,sterilizationMethodWarningResolvedBags,sterilizationMethodTest,
		sterilizationBagModelField,resolvedSterilizationBag,
		bagModels,bagPositions,bagDimensions,bagHeights,bagWidths,bagLengths,bagSizes,tightnessFactor,sterilizationMethodWarnings,inputTooLargeErrors,noBagModelsErrors,
		tooLargeForBagInvalidInputs,invalidInputBags,tooLargeForBagTest,noBagModelsInvalidInputs,noBagModelsTest,
		containerTooFullTests, simulation, updatedSimulation, samplePrepTests,
		nonAutoclavableLiquidContainerTests,selfContainedSampleTargetContainerReplaceRules,emptyContainerTargetContainerReplaceRules,containerWithSolidTargetContainerReplaceRules,autoclaveBagTargetContainerReplaceRules,
		containersWithLiquidsThatNeedToBeTransferred,containersWithLiquidsDontNeedToTransfer,noTransferLiquidContainerReplaceRules,simulatedSamplesToTransfer,volumeOfTransfers,
		safePreferredTransferContainers,transferLiquidContainerReplaceRules,allAliquotContainerReplaceRules,
		invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests,email,preResolvedPostProcessingOptions,resolvedPostProcessingOptions,
		confirm,canaryBranch,template,fastTrack,operator,parentProtocol,upload,outputOption,cacheOption,preferredContainersPackets,preferredContainers,autoclavablePreferredContainerPackets,preferredContainersPacketsNested,findPreferredAutoclavableContainer,
		samplesInStorage,objectContainerPacketFields,modelContainerFields
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* make sure we are dealing with a list of inputs *)
	listedInputs=ToList[myInputs];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our Autoclave options from our Sample Prep options. *)
	{samplePrepOptions,autoclaveOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentAutoclave, listedInputs, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentAutoclave, listedInputs, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	autoclaveOptionsAssociation=Association[autoclaveOptions];

	(* --- Make our one big Download call --- *)

	(* pull out some of the options from the option association *)
	{autoclaveProgramOption,name}=Lookup[autoclaveOptionsAssociation,{AutoclaveProgram,Name}];

	(* Sort the input samples into two lists based on if the inputs are containers or samples *)
	itemInputs=Cases[simulatedSamples,ObjectP[Object[Item]]];

	containerInputs=Cases[simulatedSamples,ObjectP[Object[Container]]];

	(* Get the SterilizationBag options from the Safe ops *)
	sterilizationBagOption=Lookup[autoclaveOptionsAssociation,SterilizationBag];

	(* Get members of the SterilizationBag Option that are Models, index matched with the option, Null if not a Model *)
	bagModelInputs=If[MatchQ[#,ObjectP[Model[Container,Bag,Autoclave]]],
		#,
		Null
	]&/@sterilizationBagOption;

	(* Get members of the SterilizationBag Option that are Objects, index matched with the option, Null if not an Object *)
	bagObjectInputs=If[MatchQ[#,ObjectP[Object[Container,Bag,Autoclave]]],
		#,
		Null
	]&/@sterilizationBagOption;

	(* Choose the fields we download from the autoclave bag based on if the given option is a Model versus an Object *)
	bagModelDownloadFields={Packet@@Join[SamplePreparationCacheFields[Model[Container]], {Positions, SterilizationMethods}]};
	bagObjectDownloadFields={
		Packet@@Append[SamplePreparationCacheFields[Object[Container]],Model],
		Packet[Model@@Join[SamplePreparationCacheFields[Model[Container]], {SterilizationMethods, Positions}]]
	};

	(* get the Instrument option from the Safe ops *)
	instrumentOption=Lookup[autoclaveOptionsAssociation,Instrument,Automatic];

	(* Choose the fields we download from the instrument based on if the given option is a Model versus and Object versus Automatic *)
	instrumentDownloadFields=Switch[instrumentOption,
		ObjectP[Model[Instrument]],{Packet[Name,InternalDimensions]},
		ObjectP[Object[Instrument]],{Packet[Model,Status],Packet[Model[{Name,InternalDimensions}]]},
		_,{}
	];

	(* List of all PreferredContainers*)
	preferredContainers=PreferredContainer[All];

	(* List of all the possible autoclave models that automatic could resolve to *)
	allPossibleInstrumentModels={Model[Instrument,Autoclave,"id:KBL5DvYl3z1N"]};

	(* Memoized Search for compatible autoclave bag Models: Search[Model[Container,Bag,Autoclave],Any[SterilizationMethods==Autoclave]] *)
	possibleAutoclaveBagModels=possibleAutoclaveBagModelsSearch["Memoization"];

	(* Fields to download from autoclave models *)
	possibleInstrumentDownloadFields={Packet[Name,InternalDimensions]};

	(* Fields to download from autoclave bag models *)
	possibleAutoclaveBagDownloadFields={Packet@@Join[SamplePreparationCacheFields[Object[Container]],{SterilizationMethods,Dimensions,Positions}]};

	(* Create the Packet and List Download syntax for our Object and Model samples and containers *)
	objectSampleFields=Flatten[{Flammable,Acid,Base,Pyrophoric,WaterReactive,Radioactive,SamplePreparationCacheFields[Object[Sample]]}];
	objectSamplePacketFields=Packet@@objectSampleFields;
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,Composition,SterilizationBag,SterilizationMethods,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerPacketFields=SamplePreparationCacheFields[Object[Container],Format->Packet];
	modelContainerFields=Flatten[{SterilizationBag,SterilizationMethods,SamplePreparationCacheFields[Model[Container]]}];

	(* Extract the packets that we need from our downloaded cache. *)
	{
		listedSamplePackets,
		listedContainerPackets,
		inputsInOrder,
		instrumentOptionPackets,
		possibleInstrumentPackets,
		preferredContainersPacketsNested,
		possibleAutoclaveBagModelPacketsNested,
		bagModelPacketsNested,
		bagObjectPacketsNested
	}=Quiet[
		Download[
			{
				itemInputs,
				containerInputs,
				simulatedSamples,
				{(instrumentOption/.{Automatic->Null})},
				allPossibleInstrumentModels,
				preferredContainers,
				possibleAutoclaveBagModels,
				bagModelInputs,
				bagObjectInputs
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields
				},
				{
					objectContainerPacketFields,
					Packet[Model[modelContainerFields]],
					Packet[Field[Contents[[All,2]][Evaluate[objectSampleFields]]]]
				},
				{
					Packet[Object]
				},
				instrumentDownloadFields,
				possibleInstrumentDownloadFields,
				{
					Evaluate[Packet@@modelContainerFields]
				},
				possibleAutoclaveBagDownloadFields,
				bagModelDownloadFields,
				bagObjectDownloadFields
			},
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* extract out the packets *)
	(* The first two are packets downloaded from myInputs that are samples or items *)
	sampleObjectPackets=listedSamplePackets[[All,1]];
	sampleModelPackets=listedSamplePackets[[All,2]];

	(* The next 4 are packets downloaded my myInputs that are containers, either empty or with a sample in them (could be a sample input in a container) *)
	containerObjectPackets=listedContainerPackets[[All,1]];
	containerModelPackets=listedContainerPackets[[All,2]];
	containerContentsObjectPackets=listedContainerPackets[[All,3]];

	(*Downloaded Packet lists are in the form of {{Association}..}. Flatten them.*)
	preferredContainersPackets=preferredContainersPacketsNested//Flatten;
	possibleAutoclaveBagModelPackets=possibleAutoclaveBagModelPacketsNested//Flatten;

	(* Get the Model packet for each autoclave bag specified in the SterilizationBag Option *)
	bagModelPackets=MapThread[
		Function[{option,modelPacket,objectPacket},
			Switch[option,
				ObjectP[Model[Container,Bag,Autoclave]],First[modelPacket],
				ObjectP[Object[Container,Bag,Autoclave]],Last[objectPacket],
				Automatic|Null,<||>
			]
		],
		{sterilizationBagOption,bagModelPacketsNested,bagObjectPacketsNested}
	];

	(* --- stitch together the various sample and container packets so that they are in the correct order (order of myInputs) --- *)
	(* First, join each type of packet together, for joinedContentsModelPackets and joinedContentsObjectPackets, we join a list of empty lists to to it, since sample inputs don't have contents, and we need these lists to be the same length for transpose *)
	joinedObjectPackets=Join[sampleObjectPackets,containerObjectPackets];
	joinedModelPackets=Join[sampleModelPackets,containerModelPackets];
	joinedContentsObjectPackets=Join[Table[{},Length[itemInputs]],containerContentsObjectPackets];

	(* Next, rearrange the joined lists of packets based on the order of the input samples *)
	combinedUnsortedPackets=Transpose[{joinedObjectPackets,joinedModelPackets,joinedContentsObjectPackets}];

	combinedSortedPackets=Map[
		Function[{object},
			SelectFirst[combinedUnsortedPackets,MatchQ[#[[1]],ObjectP[object]]&]
		],
		simulatedSamples
	];

	(* Then, define the subPackets of combinedSortedPackets *)
	{inputObjectPackets,inputModelPackets,inputContentsObjectPackets}=Transpose[combinedSortedPackets];

	(* --- INPUT VALIDATION CHECKS --- *)
	(* -- Get the inputs from myInputs that are discarded -- *)
	(* First, going to define a flattened list of inputObjectPackets and inputContentsObjectPackets (so the input containers/samples or any samples they contain), to test for Status->Discarded *)
	objectAndContentsObjectPackets=Flatten[Join[inputObjectPackets,inputContentsObjectPackets]];

	(* Then determine which input objects and their contents are discarded or not discarded *)
	discardedObjectPackets=Cases[objectAndContentsObjectPackets,KeyValuePattern[Status->Discarded]];
	nonDiscardedObjectPackets=Cases[objectAndContentsObjectPackets,Except[KeyValuePattern[Status->Discarded]]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedObjectPackets,{}],
		{},
		Lookup[discardedObjectPackets,Object]
	];

	(* For the user-facing test, create a list of the non-discarded inputs*)
	nonDiscardedInputs=If[MatchQ[nonDiscardedObjectPackets,{}],
		{},
		Lookup[nonDiscardedObjectPackets,Object]
	];

	(* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our inputs and their contents " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
			];

			passingTest=If[Length[nonDiscardedInputs]==0,
				Nothing,
				Test["Our inputs and their contents " <> ObjectToString[nonDiscardedInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check for any inputs that occur more than one time in myInputs, cannot have duplicates -- *)
	duplicateInvalidInputs=Select[Tally[listedInputs],Last[#]>1&][[All,1]];

	(* And another list of inputs that are not repeated *)
	duplicateValidInputs=Cases[listedInputs,Except[Alternatives@@duplicateInvalidInputs]];

	(* If there are duplicate inputs, then throw error *)
	If[Length[duplicateInvalidInputs]>0&&messages,
		Message[Error::DuplicateAutoclaveInputs, ObjectToString[duplicateInvalidInputs, Simulation -> updatedSimulation]]
	];

	(* Define the user-facing tests if we are gathering tests *)
	duplicateInputTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[duplicateInvalidInputs]==0,
				Nothing,
				Test["The input object(s) " <> ObjectToString[duplicateInvalidInputs, Simulation -> updatedSimulation] <> " is only present once in the list of input objects:", True, False]
			];

			passingTest=If[Length[duplicateValidInputs]==0,
				Nothing,
				Test["The input object(s) " <> ObjectToString[duplicateValidInputs, Simulation -> updatedSimulation] <> "is only present once in the list of input objects:", True, True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* If any empty containers cannot safely be autoclaved (for now based on MaxTemperature, TODO later probably based on ContainerMaterials) *)
	(* First, make a list of the empty containers *)
	emptyContainers=PickList[containerInputs,containerContentsObjectPackets,{}];

	(* Next, make a list of the packets of the container models of the empty containers *)
	emptyContainerModelPackets=PickList[containerModelPackets,containerContentsObjectPackets,{}];

	(* Then find the MaxTemperatures of the empty containers' Models*)
	emptyContainerMaxTemperatures=Lookup[emptyContainerModelPackets,MaxTemperature,Null];

	(* Any containers whose max temp is below 120 C cannot safely be autoclaved *)
	invalidEmptyContainerInputs=If[Length[emptyContainers]>0,
		PickList[emptyContainers,emptyContainerMaxTemperatures,LessP[120*Celsius]],
		{}
	];

	validEmptyContainerInputs=If[Length[emptyContainers]>0,
		PickList[emptyContainers,emptyContainerMaxTemperatures,GreaterEqualP[120*Celsius]],
		{}
	];

	(* If any of the empty containers are not safe to autoclave, and we are throwing messages, throw an Error *)
	If[Length[invalidEmptyContainerInputs]>0&&messages,
		Message[Error::InvalidEmptyAutoclaveContainer, ObjectToString[invalidEmptyContainerInputs, Simulation -> updatedSimulation]]
	];

	(* If gathering tests, write user-facing tests for InvalidEmptyContainer Error *)
	invalidEmptyContainerTests=If[gatherTests&&Length[emptyContainers]>0,
		Module[{failingTest,passingTest},

			failingTest=If[Length[invalidEmptyContainerInputs]==0,
				Nothing,
				Test["The input empty container(s) " <> ObjectToString[invalidEmptyContainerInputs, Simulation -> updatedSimulation] <> " have MaxTemperatures greater or equal to 120 C and are safe to autoclave:", True, False]
			];
			passingTest=If[Length[validEmptyContainerInputs]==0,
				Nothing,
				Test["The input empty container(s) " <> ObjectToString[validEmptyContainerInputs, Simulation -> updatedSimulation] <> " have MaxTemperatures greater or equal to 120 C and are safe to autoclave:", True, True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If any of the contents of the input containers have any of the Flammable, Acid, Base, Pyrophoric, WaterReactive, or Radioactive booleans set to true, they are not safe to autoclave *)
	(* Lookup the safety-related booleans from the model of the container contents, grouped in lists of 6 long *)
	contentsSafetyBooleanLists=Partition[
		Flatten[
			Map[
				Lookup[#,{Flammable,Acid,Base,Pyrophoric,WaterReactive,Radioactive},Null]&,
				inputContentsObjectPackets
			]
		],6
	];

	(* Determine whether any input is dangerous to autoclave *)
	contentsSafetyBooleans=Map[
		MemberQ[#,True]&,
		contentsSafetyBooleanLists
	];

	(* Make a list of the simulated samples which have contents that are not safe to autoclave *)
	invalidUnsafeContentsInputs=PickList[simulatedSamples,contentsSafetyBooleans,True];

	(* Make a list of the simulated samples which do not have contents that are not safe to autoclave *)
	validUnsafeContentsInputs=PickList[simulatedSamples,contentsSafetyBooleans,False];

	If[Length[invalidUnsafeContentsInputs]>0&&messages,
		Message[Error::UnsafeAutoclaveContainerContents, ObjectToString[invalidUnsafeContentsInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, define the user-facing tests for Error::UnsafeAutoclaveContainerContents *)
	invalidUnsafeContentsTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[invalidUnsafeContentsInputs]==0,
				Nothing,
				Test["The input container(s), " <> ObjectToString[invalidUnsafeContentsInputs, Simulation -> updatedSimulation] <> ", have Contents that are safe to autoclave, because none of the following Fields are True: Flammable, Acid, Base, Pyrophoric, WaterReactive, Radioactive:", True, False]
			];
			passingTest=If[Length[validUnsafeContentsInputs]==0,
				Nothing,
				Test["The input(s), " <> ObjectToString[validUnsafeContentsInputs, Simulation -> updatedSimulation] <> ", are safe to autoclave because they either have no Contents, or their Contents have False for all of the following Fields:Flammable, Acid, Base, Pyrophoric, WaterReactive, Radioactive:", True, True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Here see if there are any options which are invalid --- *)
	(* -- Check to see if the Name option is properly specified -- *)
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,Autoclave,Lookup[autoclaveOptions,Name]]]],
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make invalidNameOption = {Name}; otherwise, {} is fine *)
	invalidNameOption=If[Not[validNameQ]&&messages,
		(
			Message[Error::DuplicateName,"Autoclave protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already an Autoclave protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* --- Resolve Experimental Options (Instrument, AutoclaveProgram, and SterilizationBag) --- *)
	(* -- Resolve the Instrument Option -- *)
	resolvedInstrument=If[MatchQ[instrumentOption,Automatic],
		Model[Instrument,Autoclave,"id:KBL5DvYl3z1N"],
		instrumentOption
	];

	(* -- Resolve the AutoclaveProgram option -- *)
	(* First, make a list of the input object packets that have something in them (non-empty containers) *)
	nonEmptyContainerObjectPackets=PickList[inputObjectPackets,inputContentsObjectPackets,Except[{}]];

	(* Make a list of non empty containers, if there are no containers or no empty containers, return an empty list*)
	nonEmptyContainers=Lookup[nonEmptyContainerObjectPackets,Object,{}];

	(* Make a list of the packets of the objects of stuff inside the non empty containers *)
	nonEmptyContainerContentsObjectPackets=Flatten[Cases[containerContentsObjectPackets,Except[{}]]];

	(* If any of the nonempty containers are not vessels, and we are throwing messages, throw an Error *)
	invalidNonEmptyContainerInputs=Cases[nonEmptyContainers,Except[ObjectP[Object[Container,Vessel]]]];
	validNonEmptyContainerInputs=Cases[nonEmptyContainers,ObjectP[Object[Container,Vessel]]];

	If[Length[invalidNonEmptyContainerInputs]>0&&messages,
		Message[Error::InvalidAutoclaveContainer, ObjectToString[invalidNonEmptyContainerInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	invalidNonEmptyContainersTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidNonEmptyContainerInputs]==0,
				Nothing,
				Test["The input non-empty containers " <> ObjectToString[invalidNonEmptyContainerInputs, Simulation -> updatedSimulation] <> " are not suitable for autoclave since there are not Object[Container,Vessel]:", True, False]
			];
			passingTest=If[Length[validNonEmptyContainerInputs]==0,
				Nothing,
				Test["The input non-empty containers with samples are all container vessels:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* --- Resolve AutoclaveProgram --- *)
	(* TODO also here plastics need to be sterilized in liquid cycle when this information is available *)
	(* First, figure out if each individual input would be ideally run using the universal program or the liquid program - liquid program if it is a non empty container whose contents have a state that is not Solid *)
	{universalProgramPreferredInputs,liquidProgramPreferredInputs}=Module[
		{
			liquidProgramNonEmptyContainers,universalProgramNonEmptyContainers,universalProgramInputs,emptyContainerAndSampleObjectPackets,emptyContainersAndSamples
		},

		(* the non empty containers which would prefer the liquid autoclave program are those whose contents are not Solids *)
		liquidProgramNonEmptyContainers=PickList[nonEmptyContainers,nonEmptyContainerContentsObjectPackets,Except[KeyValuePattern[State->Solid]]];

		(* the non empty containers which would prefer the universal autoclave program are those whose contents are Solids (won't happen much) *)
		universalProgramNonEmptyContainers=PickList[nonEmptyContainers,nonEmptyContainerContentsObjectPackets,KeyValuePattern[State->Solid]];

		(* Make a list of all of the input object packets which are not containers with stuff in them (so empty containers and self-contained samples *)
		emptyContainerAndSampleObjectPackets=PickList[inputObjectPackets,inputContentsObjectPackets,{}];

		(* Make a list of the empty containers and the self contained samples *)
		emptyContainersAndSamples=Lookup[emptyContainerAndSampleObjectPackets,Object,{}];

		(* The inputs that would prefer the universal program are the empty containers, self contained samples, containers with solids in them, and autoclave bag containers *)
		universalProgramInputs=Union[emptyContainersAndSamples,universalProgramNonEmptyContainers];

		(* Return lists of the inputs that would prefer universal program and those that would prefer liquid program *)
		{universalProgramInputs,liquidProgramNonEmptyContainers}
	];

	(* determine which autoclave program SHOULD be run based on the inputs *)
	preferredAutoclaveProgram=If[Length[liquidProgramPreferredInputs]==0,
		Universal,
		Liquid
	];

	(* Resolve the AutoclaveProgram Option *)
	resolvedAutoclaveProgram=If[MatchQ[autoclaveProgramOption,Automatic],
		preferredAutoclaveProgram,
		autoclaveProgramOption
	];

	(* -- Resolve the SterilizationBag Option -- *)

	(* Lookup the SterilizationBag Option which is index-matched to samples *)
	sterilizationBagOption=Lookup[autoclaveOptionsAssociation,SterilizationBag];

	(* Lookup the SterilizationBag fields of the models of the inputs *)
	sterilizationBagModelField=Lookup[inputModelPackets,SterilizationBag];

	(* Lookup the models of the possible autoclave bags
	TODO: throw error if SterilizationBag tries to resolve to a bag type, but possibleAutoclaveBagModelPackets is {} *)
	bagModels=Lookup[possibleAutoclaveBagModelPackets,Object,{Null}];

	(* Lookup the positions instead of dimensions of the possible autoclave bags, because the dimensions are set to smaller values in order to store them folded *)
	bagPositions = First[Lookup[#,Positions,{<|Name -> "A1", Footprint -> Open, MaxWidth -> 0*Meter, MaxDepth -> 0*Meter, MaxHeight -> 0*Meter|>}]]&/@(possibleAutoclaveBagModelPackets/.{}->{<||>});
	bagDimensions = Lookup[#, {MaxWidth, MaxDepth, MaxHeight}] & /@ bagPositions;

	(* Label the dimensions using the convention: height <= width <= length *)
	{bagHeights,bagWidths,bagLengths}=Transpose[Sort/@bagDimensions];

	(* Use areas as a proxy for the sizes of the bags since their heights are negligible *)
	bagSizes=bagLengths*bagWidths;

	(* Set a tightness factor to ensure the objects fit
	Make smaller if objects aren't fitting in the bags they are assigned
	Or higher if objects are being assigned to bigger bags than necessary *)
	tightnessFactor=0.9;

	(* MapThread to resolve the SterilizationBag Option and to collect errors *)
	{
		(*1*)resolvedSterilizationBag,
		(*2*)sterilizationMethodWarnings,
		(*3*)inputTooLargeErrors,
		(*4*)noBagModelsErrors
	}=Transpose[
		MapThread[
			Function[{bagOption,bagModelField,inputModelPacket,bagModelPacket},
				Module[{inputTooLargeError,sterilizationMethodWarning,inputDimensions,inputHeight,inputWidth,inputLength,
					compatibleBagBools,compatibleBagModels,compatibleBagSizes,incompatibleBagModels,
					preferredBag,sterilizationMethods,sterilizationBag,noBagModelsError},

					(* Lookup the sterilization methods with which the user-specified autoclave bag is compatible *)
					sterilizationMethods=Lookup[bagModelPacket,SterilizationMethods,{}];

					(* Flip a warning switch (for Warning::IncompatibleSterilizationMethods) indicating that the specified sterilization bag is incompatible with autoclaving *)
					sterilizationMethodWarning=MatchQ[bagOption,AutoclaveBagP]&&!MemberQ[sterilizationMethods,Autoclave];

					(* Get the Dimensions of the input object to place in a bag *)
					inputDimensions=Lookup[inputModelPacket,Dimensions];

					(* Label the input object's dimensions using the convention: height <= width <= length *)
					{inputHeight,inputWidth,inputLength}=Sort[inputDimensions];

					(* A list of Boolean values indicating whether this input object would fit into each possible autoclave bag model *)
					compatibleBagBools=MapThread[And,
						{
							(* Perimeter upper bounds assuming that the object is a rectangular prism - any other shape would fit less tightly *)
							inputLength+inputHeight<#&/@(bagLengths*tightnessFactor),
							inputWidth+inputHeight<#&/@(bagWidths*tightnessFactor)
						}
					];

					(* Pick out the autoclave bag models that are compatible with the input and their sizes *)
					compatibleBagModels=PickList[bagModels,compatibleBagBools];
					compatibleBagSizes=PickList[bagSizes,compatibleBagBools];

					(* Pick out the autoclave bag models that are incompatible with the input *)
					incompatibleBagModels=PickList[bagModels,compatibleBagBools,False];

					(* Flip an error switch (for Error::InputTooLargeForAutoclaveBag) indicating that the sample is too large for its assigned autoclave bag if... *)
					inputTooLargeError=Or[

						(* The SterilizationBag Option is Automatic and the Model of the input sample has SterilizationBag->True
						and there are no compatible bag models based on size and there are compatible bag models based on SterilizationMethods *)
						MatchQ[bagOption,Automatic]&&TrueQ[bagModelField]&&MatchQ[compatibleBagModels,{}]&&!MatchQ[possibleAutoclaveBagModels,{}],

						(* Or the SterilizationBag Option is specified to one of the incompatible bag models based on size *)
						MatchQ[bagOption,AutoclaveBagP]&&MemberQ[incompatibleBagModels,bagOption],

						(* Or the SterilizationBag Option is specified to a bag that is incompatible with autoclaving
						and none of the available bag models (that are compatible with autoclaving) are compatible based on the size of the item *)
						sterilizationMethodWarning&&MatchQ[compatibleBagModels,{}]
					];

					(* If there are no compatible bag models... *)
					preferredBag=If[MatchQ[compatibleBagModels,{}],

						(* Then choose the biggest possible bag Model as the preferred bag
						This will be Null if bagModels is {Null} which is the case when possibleAutoclaveBagModels is {}
						Since Error::InputTooLargeForAutoclaveBag will trigger InvalidInput, this will only be used to populate the error message *)
						First[PickList[bagModels,bagSizes,Max[bagSizes]]],

						(* Otherwise choose the smallest bag Model that can fit the input object as the preferred bag *)
						First[PickList[compatibleBagModels,compatibleBagSizes,Min[compatibleBagSizes]]]
					];

					(* Resolve the SterilizationBag Option *)
					sterilizationBag=Switch[{bagOption,bagModelField},

						(* If the SterilizationBag Option is Automatic and the Model of the sample has SterilizationBag->True,
						then resolve to the preferred autoclave bag *)
						{Automatic,True},preferredBag,

						(* If the SterilizationBag Option is Automatic and the Model of the sample has SterilizationBag->False|Null,
						then resolve to Null *)
						{Automatic,False|Null},Null,

						(* If the SterilizationBag Option is specified to an autoclave bag Object or Model, then resolve to
						the specified Object or Model if it is compatible with autoclaving or to the preferred autoclave bag if not *)
						{AutoclaveBagP,_},If[sterilizationMethodWarning,preferredBag,bagOption],

						(* If the SterilizationBag Option is specified to Null,
						then resolve to Null *)
						{Null,_},Null,

						(* Shouldn't get here since the SterilizationBag Option should only be Automatic|AutoclaveBagP|Null
						and the Model SterilizationBag Field should only be True|False|Null *)
						{_,_},Null
					];

					(* Flip an error switch for Error::NoValidAutoclaveBagModels if... *)
					noBagModelsError=And[

						(* the SterilizationBag Option is Automatic *)
						MatchQ[bagOption,Automatic],

						(* and the Model of the sample has SterilizationBag->True *)
						MatchQ[bagModelField,True],

						(* and no valid autoclave bag models based on SterilizationMethods exist *)
						MatchQ[possibleAutoclaveBagModels,{}]
					];

					(* Return the resolved Option and the error switch *)
					{
						(*1*)sterilizationBag,
						(*2*)sterilizationMethodWarning,
						(*3*)inputTooLargeError,
						(*4*)noBagModelsError
					}
				]
			],
			{sterilizationBagOption,sterilizationBagModelField,inputModelPackets,bagModelPackets}
		]
	];

	(* -- Checks for unresolvable options, or inputs or options that are invalid based on the option resolution --*)

	(* Flip an error switch if the resolved AutoclaveProgram is Liquid, and there are resolved autoclave bags *)
	invalidAutoclaveProgramForBagsError=And[
		MatchQ[resolvedAutoclaveProgram,Liquid],
		MemberQ[resolvedSterilizationBag,AutoclaveBagP]
	];

	(* Throw an error if the resolved AutoclaveProgram is Liquid, and there are resolved autoclave bags *)
	invalidAutoclaveProgramForBagsOption=If[invalidAutoclaveProgramForBagsError,
		Message[Error::InvalidAutoclaveProgramForBags];
		{AutoclaveProgram,SterilizationBag},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidAutoclaveProgramForBags *)
	invalidAutoclaveProgramForBagsTest=If[gatherTests,
		Test["If autoclave bags are being used, then the AutoclaveProgram is not Liquid:",
			invalidAutoclaveProgramForBagsError,
			False
		]
	];

	(* If the user set the AutoclaveProgram option to Universal, but there are some input samples or containers with samples in them that are liquids, the option is not valid, since Liquid cycle would need to be run *)
	invalidAutoclaveProgramOption=If[MatchQ[autoclaveProgramOption,Universal]&&MatchQ[preferredAutoclaveProgram,Liquid],
		{AutoclaveProgram},
		{}
	];

	(* If the AutoclaveProgram Option is invalid and we are throwing messages, throw an Error *)
	If[Length[invalidAutoclaveProgramOption]>0&&messages,
		Message[Error::InvalidAutoclaveProgram]
	];

	(* user facing tests, if we are gathering tests *)
	validAutoclaveProgramTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[invalidAutoclaveProgramOption]==0,
				Nothing,
				Test["The user-specified AutoclaveProgram of Universal is valid because there are no inputs that are liquids or contain liquids:",True,False]
			];

			passingTest=If[Length[invalidAutoclaveProgramOption]!=0,
				Nothing,
				Test["The AutoclaveProgram is appropriate for the inputs:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Throw an Warning for the user-specified bags that are incompatible with autoclaving *)

	(* Pick out the inputs that were user-specified bags that are incompatible with autoclaving *)
	sterilizationMethodWarningInputs=PickList[listedInputs,sterilizationMethodWarnings];

	(* Pick out the autoclave bags to which those inputs were user-specified *)
	sterilizationMethodWarningBags=PickList[sterilizationBagOption,sterilizationMethodWarnings];

	(* Pick out the autoclave bags to which those inputs were re-assigned *)
	sterilizationMethodWarningResolvedBags=PickList[resolvedSterilizationBag,sterilizationMethodWarnings];

	(* If at least one specified autoclave bag is incompatible with autoclaving, throw a warning *)
	If[Or@@sterilizationMethodWarnings&&messages&&notInEngine,
		Message[Warning::IncompatibleSterilizationMethods,
			ObjectToString[sterilizationMethodWarningInputs, Simulation -> updatedSimulation],
			ObjectToString[sterilizationMethodWarningBags, Simulation -> updatedSimulation],
			ObjectToString[sterilizationMethodWarningResolvedBags, Simulation -> updatedSimulation]
		]
	];

	(* User-facing test, if we are gathering tests *)
	sterilizationMethodTest=If[gatherTests,
		Test["The assigned sterilization bags are compatible with autoclaving:",
			Or@@sterilizationMethodWarnings,
			False
		],
		Nothing
	];

	(* Throw an error for the inputs that are too large for autoclave bags *)

	(* Pick out the inputs that are too large for their assigned autoclave bags *)
	tooLargeForBagInvalidInputs=PickList[listedInputs,inputTooLargeErrors];

	(* Pick out the autoclave bags to which those inputs were assigned *)
	invalidInputBags=PickList[resolvedSterilizationBag,inputTooLargeErrors];

	(* If at least one input was too large for its assigned bag, throw an error *)
	If[Or@@inputTooLargeErrors&&messages,
		Message[Error::InputTooLargeForAutoclaveBag,
			ObjectToString[tooLargeForBagInvalidInputs, Simulation -> updatedSimulation],
			ObjectToString[invalidInputBags, Simulation -> updatedSimulation]
		]
	];

	(* User-facing test, if we are gathering tests *)
	tooLargeForBagTest=If[gatherTests,
		Test["The inputs are small enough to fit in the autoclave bags to which they are assigned:",
			Or@@inputTooLargeErrors,
			False
		],
		Nothing
	];

	(* Throw an error if no compatible autoclave bags exist in the database, but some inputs resolved to use autoclave bags *)

	(* Pick out the inputs that would have been assigned autoclave bags if any existed *)
	noBagModelsInvalidInputs=PickList[listedInputs,noBagModelsErrors];

	(* If at least one input would have been assigned an autoclave bag, but none exist, throw an error *)
	If[Or@@noBagModelsErrors&&messages,
		Message[Error::NoValidAutoclaveBagModels,
			ObjectToString[noBagModelsInvalidInputs, Simulation -> updatedSimulation]
		]
	];

	(* User-facing test, if we are gathering tests *)
	noBagModelsTest=If[gatherTests,
		Test["Autoclave-compatible bag models exist for any inputs that require autoclave bags:",
			Or@@noBagModelsErrors,
			False
		],
		Nothing
	];

	(* - Here, we have a section of code that deals with containers with stuff in them.  Need to get information about the Volume and the State - will use this information for throwing volume warnings and aliquotting and State. Need to transfer if containers too full - *)

	(* Get a list of autoclavable containers within the Preferred container Packet list*)
	autoclavablePreferredContainerPackets=If[#[MaxTemperature]>=121Celsius,#,Nothing]&/@preferredContainersPackets;

	(* Make a list of the model packets of the non-empty containers *)
	nonEmptyContainerModelPackets=PickList[containerModelPackets,containerContentsObjectPackets,Except[{}]];

	(* Make a list of the types of the non-empty containers *)
	listOfContainerTypes=Lookup[nonEmptyContainerModelPackets,Type,{}];

	(* Make a list of the Volumes of the contents of the non-empty containers *)
	listOfVolumes=Lookup[nonEmptyContainerContentsObjectPackets,Volume,Null];

	(* Make a list of the volumes of the contents of the non-empty containers, with Null replaced with 0 uL *)
	listOfVolumesNoNull=listOfVolumes/.{Null->0*Microliter};

	(* Make a list of the max volumes of the non-empty containers - doing this to check if any of them are too full *)
	listOfMaxVolumes=Lookup[nonEmptyContainerModelPackets,MaxVolume,{}];

	(* Make a list of the max temperatures of the non-empty containers - doing this to check if any of them arent safe to put in the autoclave - would aliquot out *)
	listOfMaxTemperatures=Lookup[nonEmptyContainerModelPackets,MaxTemperature,{}];

	(* Make a list of the states of the contents in the non-empty containers *)
	listOfContentsStates=Lookup[nonEmptyContainerContentsObjectPackets,State,{}];

	(* Make a list of the states of the contents in the non-empty containers, with any Null replaced with Liquid *)
	listOfContentsStatesNoNull=listOfContentsStates/.{Null->Liquid};

	(* Make a list of the input non-empty containers whose contents are solids and those with liquids *)
	nonEmptyContainersWithSolids=PickList[nonEmptyContainers,listOfContentsStatesNoNull,Solid];
	nonEmptyContainersWithLiquids=PickList[nonEmptyContainers,listOfContentsStatesNoNull,Liquid];

	(* Make a list of all non-empty containers that are autoclave bags *)
	nonEmptyAutoclaveBagContainers=PickList[nonEmptyContainers,listOfContainerTypes,Model[Container,Bag,Autoclave]];

	(* make a list of the ratios of Volume to MaxVolume of non-empty container contents*)
	listOfVolumeRatios=(listOfVolumesNoNull/listOfMaxVolumes);

	(* The containers that are more than 3/4 full with liquid are too full *)
	tooFullContainers=PickList[nonEmptyContainers,listOfVolumeRatios,GreaterP[0.75]];

	(* create a list of the containers that either have solids in them or have liquids with volumes that aren't too high *)
	notTooFullContainers=PickList[nonEmptyContainers,listOfVolumeRatios,LessEqualP[0.75]];

	(* Need to figure out which containers we will try to aliquot the contents of the too full containers into for the warning message *)
	(* First, find the volumes of the contents that are too full for the container they are in *)
	volumeOfTooFullTransfers=If[MatchQ[Head[listOfVolumesNoNull],List],
		PickList[listOfVolumesNoNull,nonEmptyContainers,Alternatives@@tooFullContainers],
		{}
	];
	(*
	(* Figure out which preferred vessel these contents should be transferred into *)
	tooFullTransferContainers=Map[
		PreferredContainer[#]&,
		(volumeOfTooFullTransfers*1.5)
	];

	(* The 50 mL Tube is not autoclave safe, so replace it with the 250 mL glass bottle *)
	safeTooFullTransferContainers=tooFullTransferContainers/.{Model[Container, Vessel, "id:bq9LA0dBGGR6"]->Model[Container, Vessel, "id:J8AY5jwzPPR7"]};
**)
	(* Helper function to find minimum volume container among the autoclavablePreferredContainerPackets*)
	findPreferredAutoclavableContainer[liquidVolume_]:=FirstOrDefault[MinimalBy[
		Cases[autoclavablePreferredContainerPackets,_?(#[MaxVolume]>=liquidVolume&)],
		(#[MaxVolume] &)][Object]];

	(* Figure out which preferred vessel these contents should be transferred into *)
	safeTooFullTransferContainers=Map[
		findPreferredAutoclavableContainer,
		(volumeOfTooFullTransfers*1.5)
	];

	(* -- Section about containers that are not safe to autoclave, and aren't empty -- *)
	(* Make a list of the max temperatures of the non-empty containers - doing this to check if any of them arent safe to put in the autoclave - would aliquot out *)
	listOfMaxTemperatures=Lookup[nonEmptyContainerModelPackets,MaxTemperature,{}];

	(* Any containers that have stuff in them and cannot safely be autoclaved must have their contents aliquoted to a new container*)
	nonEmptyContainersWithTooLowMaxTemp=PickList[nonEmptyContainers,listOfMaxTemperatures,LessP[120*Celsius]];

	(* If there are any non-solids in containers that are not compatible with the autoclave, we must transfer them to autoclave-safe containers *)
	nonAutoclavableContainersLiquidInputs=Intersection[nonEmptyContainersWithLiquids,nonEmptyContainersWithTooLowMaxTemp];

	(* If there are any non-solids in containers that are compatible with the autoclave, they can stay in their container *)
	autoclavableContainersLiquidInputs=Complement[nonEmptyContainersWithLiquids,nonAutoclavableContainersLiquidInputs];

	(* Need to figure out which containers we will try to aliquot the contents of the not autoclave safe liquid sample containers for the warning message *)
	(* First, find the volumes of the contents that are in non-autoclave safe containers for the container they are in *)
	volumeOfNonAutoclavableLiquidContainers=If[MatchQ[Head[listOfVolumesNoNull],List],
		PickList[listOfVolumesNoNull,nonEmptyContainers,Alternatives@@nonAutoclavableContainersLiquidInputs],
		{}
	];

	(*
	(* Figure out which preferred vessel these contents should be transferred into *)
	notAutoclaveSafeTransferContainers=Map[
		PreferredContainer[#]&,
		(volumeOfNonAutoclavableLiquidContainers*1.5)
	];
	(* The 50 mL Tube is not autoclave safe, so replace it with the 250 mL glass bottle *)
	safeNotAutoclaveSafeTransferContainers=notAutoclaveSafeTransferContainers/.{Model[Container, Vessel, "id:bq9LA0dBGGR6"]->Model[Container, Vessel, "id:J8AY5jwzPPR7"]};
	*)

	(* Figure out which preferred vessel these contents should be transferred into *)
	safeNotAutoclaveSafeTransferContainers=Map[
		findPreferredAutoclavableContainer,
		(volumeOfNonAutoclavableLiquidContainers*1.5)
	];

	(* - If there are any solids in containers that are not compatible with the autoclave, we must hard error. cannot transfer them - *)
	invalidContainersSolidInputs=Intersection[nonEmptyContainersWithSolids,nonEmptyContainersWithTooLowMaxTemp];

	(* Make a list of the containers with solid contents that are also containers safe to autoclave *)
	validContainersSolidInputs=Complement[nonEmptyContainersWithSolids,invalidContainersSolidInputs];


	(* If we are throwing messages, throw an error if there are any containers that are not autoclave safe with solid contents *)
	If[Length[invalidContainersSolidInputs]>0&&messages,
    Message[Error::ContainerWithSolidContentsNotAutoclaveSafe, ObjectToString[invalidContainersSolidInputs, Simulation -> updatedSimulation]]
  ];

	(* If we are gathering tests, generate the user-facing tests *)
	validSolidContainersTests=If[gatherTests&&Length[nonEmptyContainersWithSolids]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidContainersSolidInputs]==0,
				Nothing,
        Test["The following containers with contents that are Solid are safe to autoclave, " <> ObjectToString[invalidContainersSolidInputs, Simulation -> updatedSimulation] <> ":", True, False]
      ];
			passingTest=If[Length[validContainersSolidInputs]==0,
				Nothing,
        Test["The following containers with contents that are Solid are safe to autoclave, " <> ObjectToString[validContainersSolidInputs, Simulation -> updatedSimulation] <> ":", True, True]
      ];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Here determine if we need to transfer contents due to containers with stuff in them either having MaxTemps that are too low, or contents volumes that are too high --- *)
	(* If any container has non-solid inputs that have volumes greater than 3/4 of the max volume of the container they are in, they will need to be transferred during aliquotting, throw warning *)
	If[Length[tooFullContainers]>0&&messages&&notInEngine,
    Message[Warning::AutoclaveContainerTooFull, ObjectToString[tooFullContainers, Simulation -> updatedSimulation], ObjectToString[safeTooFullTransferContainers, Simulation -> updatedSimulation]]
  ];

	(* If we are gathering tests, and there are non empty containers with liquids that didnt undergo Aliquot simulation, generate the user-facing tests for the previous message *)
	containerTooFullTests=If[gatherTests&&Length[tooFullContainers]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooFullContainers]==0,
				Nothing,
        Test["The following containers have non-Solid Contents that take up less than 3/4 the MaxVolume of the container " <> ObjectToString[tooFullContainers, Simulation -> updatedSimulation] <> ":", True, False]
      ];
			passingTest=If[Length[notTooFullContainers]==0,
				Nothing,
        Test["The following containers have Contents that take up less than 3/4 the MaxVolume of the container " <> ObjectToString[notTooFullContainers, Simulation -> updatedSimulation] <> ":", True, True]
      ];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Here check if there are any nonSolid samples inside of containers that are not autoclave-safe - if so, we will need to aliquot these samples into autoclave-safe containers --- *)
	(* If any containers containing liquids are not safe to autoclave, the contents will need to be transferred to an autoclave safe container during the aliquotting step *)
	If[Length[nonAutoclavableContainersLiquidInputs]>0&&messages&&notInEngine,
    Message[Warning::NonEmptyContainerNotAutoclaveSafe, ObjectToString[nonAutoclavableContainersLiquidInputs, Simulation -> updatedSimulation], ObjectToString[safeNotAutoclaveSafeTransferContainers, Simulation -> updatedSimulation]]
  ];

	(* If we are gathering tests, and there are non empty containers with liquids that didnt undergo Aliquot simulation, generate the user-facing tests for the previous message *)
	nonAutoclavableLiquidContainerTests=If[gatherTests&&Length[noAliquotNonEmptyLiquidContainers]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonAutoclavableContainersLiquidInputs]==0,
				Nothing,
        Test["The following containers with non-Solid Contents are autoclave-safe " <> ObjectToString[nonAutoclavableContainersLiquidInputs, Simulation -> updatedSimulation] <> ":", True, False]
      ];
			passingTest=If[Length[autoclavableContainersLiquidInputs]==0,
				Nothing,
        Test["The following containers with non-Solid Contents are autoclave-safe " <> ObjectToString[autoclavableContainersLiquidInputs, Simulation -> updatedSimulation] <> ":", True, True]
      ];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- HERE THROW ERRORS IF THE INPUTS CANT FIT IN THE RESOLVED AUTOCLAVE -- *)
	autoclaveInternalDimensions=If[MatchQ[instrumentOption,Automatic],
		(* If option is automatic, lookup the internal dimensions from the packet that corresponds to the model we resolved to (currently the only model) *)
		Flatten[Lookup[Flatten[possibleInstrumentPackets],InternalDimensions,Nothing]],
		(* Otherwise, lookup the internal dimensions from the packet of the object or model that the user provided as the Instrument option *)
		Flatten[Lookup[Flatten[instrumentOptionPackets],InternalDimensions,Nothing]]
	];

	(* To give ourselves some wiggle room and make sure things will always fit, the worksurface area is defined as half of the total Width*Depth of the internal dimensions of autoclave *)
	autoclaveWorksurfaceArea=Floor[(autoclaveInternalDimensions[[1]]*autoclaveInternalDimensions[[2]]/2),0.01*Meter*Meter];

	(* -- Check if the inputs can fit into the autoclave in a single run, if not, throw an Error -- *)
	(* set a boolean to say if everything fits (True) or does not (False), and find the total footprint area that the inputs take up *)
	{allInputsFitInAutoclaveTogetherBool,totalFootprintArea}=Module[
		{objectDimensions,objectFootprints,totalFootprint},

		(* Get the dimensions of the items to be autoclaved *)
		objectDimensions=Lookup[inputModelPackets,Dimensions];

		(* Get the footprint of each item by multiplying its width by its depth *)
		objectFootprints=(#[[1]]*#[[2]])&/@objectDimensions;

		(* Get the total area that the input objects will take up in the autoclave *)
		totalFootprint=Total[objectFootprints];

		(* Return a boolean that says whether the worksurface area is larger than the total footprint of the objects, and the total footprint of the objects*)
		{GreaterEqual[autoclaveWorksurfaceArea,totalFootprint],totalFootprint}
	];

	notEnoughAutoclaveSpaceInvalidInputs=If[MatchQ[allInputsFitInAutoclaveTogetherBool,True],
		{},
		listedInputs
	];

	(* If all of the inputs together cannot fit into the autoclave, and we are throwing messages, throw an error *)
	If[Length[notEnoughAutoclaveSpaceInvalidInputs]>0&&messages,
    Message[Error::NotEnoughAutoclaveSpace, ObjectToString[notEnoughAutoclaveSpaceInvalidInputs, Simulation -> updatedSimulation], totalFootprintArea]
  ];

	(* Define the user-facing tests if we are gathering tests *)
	notEnoughAutoclaveSpaceTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[notEnoughAutoclaveSpaceInvalidInputs]==0,
				Nothing,
				Test["The total cross sectional area of the inputs, "<>ToString[totalFootprintArea]<>", is less than 0.25 square meters:",True,False]
			];

			passingTest=If[Length[notEnoughAutoclaveSpaceInvalidInputs]>0,
				Nothing,
				Test["The total cross sectional area of the inputs, "<>ToString[totalFootprintArea]<>", is less than 0.25 square meters:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check to see if any particular input has a dimension that is longer than the shortest dimension of the autoclave, if so, it won't fit into the autoclave -- *)
	shortestAutoclaveDimension=Floor[First[Sort[autoclaveInternalDimensions]],0.1*Meter];

	{invalidDimensionsInputs,validDimensionsInputs}=Module[
		{listOfInputsDimensions,inputTooLongBools,tooLongInputs,notTooLongInputs},

		(* First, find the dimensions of the inputs, as a list of lists *)
		listOfInputsDimensions=Lookup[inputModelPackets,Dimensions];

		(* Next we check if any of the list of dimensions contains a length that is longer than 0.5 Meters, the shortest internal autoclave dimension *)
		inputTooLongBools=Map[
			MemberQ[#,GreaterP[shortestAutoclaveDimension]]&,
			listOfInputsDimensions
		];

		(* The inputs which have a dimension that is longer than 0.5 Meters are too big to fit into the autoclave *)
		tooLongInputs=PickList[simulatedSamples,inputTooLongBools,True];

		(* The inputs which do not have a dimension that is longer than 0.5 Meters are not too big to fit into the autoclave *)
		notTooLongInputs=PickList[simulatedSamples,inputTooLongBools,False];

		{tooLongInputs,notTooLongInputs}
	];

	(* If any of the inputs cannot individually fit into the autoclave and we are throwing messages, throw an error *)
	If[Length[invalidDimensionsInputs]>0&&messages,
    Message[Error::InputTooLargeForAutoclave, ObjectToString[invalidDimensionsInputs, Simulation -> updatedSimulation]]
  ];

	inputTooLargeTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[invalidDimensionsInputs]==0,
				Nothing,
        Test["The input(s) " <> ObjectToString[invalidDimensionsInputs, Simulation -> updatedSimulation] <> " have no dimensions longer than 0.5 meters and can fit into the autoclave:", True, False]
      ];

			passingTest=If[Length[validDimensionsInputs]==0,
				Nothing,
        Test["The input(s) " <> ObjectToString[validDimensionsInputs, Simulation -> updatedSimulation] <> " have no dimensions longer than 0.5 meters and can fit into the autoclave:", True, True]
      ];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- CONTAINER GROUPING RESOLUTION --- *)
	(* Get user-supplied aliquot options *)
	{
		suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedAssayBuffers,suppliedAliquotContainers,suppliedTargetConcentrations,suppliedConcentratedBuffer,
		suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAliquotSampleStorageCondition,suppliedConsolidateAliquots,suppliedAliquotLiquidHandlingScale
	}
		=Lookup[
		samplePrepOptions,
		{
			Aliquot,AssayVolume,AliquotAmount,AssayBuffer,AliquotContainer,TargetConcentration,ConcentratedBuffer,BufferDilutionFactor,BufferDiluent,AliquotSampleStorageCondition,
			ConsolidateAliquots,AliquotPreparation
		}
	];

	(* -- Resolve RequiredAliquotContainers -- *)
	(* - Write the replace rules for TargetContainers - *)
	(* Self contained samples, empty containers, and containers with solid contents get Null as Target Container *)
	selfContainedSampleTargetContainerReplaceRules=Map[(#->Null)&,itemInputs];
	emptyContainerTargetContainerReplaceRules=Map[(#->Null)&,emptyContainers];
	containerWithSolidTargetContainerReplaceRules=Map[(#->Null)&,nonEmptyContainersWithSolids];
	autoclaveBagTargetContainerReplaceRules=Map[(#->Null)&,nonEmptyAutoclaveBagContainers];

	(* Create a list of containers with liquid contents that need to be transferred *)
	containersWithLiquidsThatNeedToBeTransferred=DeleteDuplicates[Join[nonAutoclavableContainersLiquidInputs,tooFullContainers]];

	(* Create a list of containers with liquid contents that don't need to be transferred *)
	containersWithLiquidsDontNeedToTransfer=Complement[nonEmptyContainersWithLiquids,containersWithLiquidsThatNeedToBeTransferred];

	(* These containers with liquids that don't need to be transferred will get Null as Target Container *)
	noTransferLiquidContainerReplaceRules=Map[(#->Null)&,containersWithLiquidsDontNeedToTransfer];

	(* For the liquid contents that need to be transferred, get them in the correct order, so they will be index matched to the volumeOfTransfers below *)
	simulatedSamplesToTransfer=Cases[simulatedSamples,Alternatives@@containersWithLiquidsThatNeedToBeTransferred];

	(* find the volume of the simulatedSamplesToTransfer - If statement here in the case the user gives one empty container input or one self contained sample, to avoid error *)
	volumeOfTransfers=If[MatchQ[Head[listOfVolumesNoNull],List],
		PickList[listOfVolumesNoNull,nonEmptyContainers,Alternatives@@simulatedSamplesToTransfer],
		{}
	];
	(*
	(* to get a list of the containers we should transfer to, call PreferredContainer on the volume of the samples * 1.5, so we get a bigger container for the too full containers *)
	preferredTransferContainers=Map[
		PreferredContainer[#]&,
		(volumeOfTransfers*1.5)
	];

	(* 50mL tube is a preferred container, but cannot withstand the heat of autoclave, so replace instances of 50mL tube with 250 mL glass bottle *)
	safePreferredTransferContainers=preferredTransferContainers/.{Model[Container, Vessel, "id:bq9LA0dBGGR6"]->Model[Container, Vessel, "id:J8AY5jwzPPR7"]};
	*)

	safePreferredTransferContainers=Map[
		findPreferredAutoclavableContainer,
		(volumeOfTransfers*1.5)
	];

	(* Set the replace rules for all of the simulated samples with liquid contents that need to be transferred *)
	transferLiquidContainerReplaceRules=MapThread[
		(#1->#2)&,
		{simulatedSamplesToTransfer,safePreferredTransferContainers}
	];

	(* Join the lists of replace rules to get the total replace rule list *)
	allAliquotContainerReplaceRules=Join[selfContainedSampleTargetContainerReplaceRules,emptyContainerTargetContainerReplaceRules,containerWithSolidTargetContainerReplaceRules,
		autoclaveBagTargetContainerReplaceRules,noTransferLiquidContainerReplaceRules,transferLiquidContainerReplaceRules
	];

	(* replacing the simulatedSamples with the allAliquotContainerReplaceRules gives us the TargetContainer we will pass to resolveAliquotOptions *)
	targetContainers=simulatedSamples/.allAliquotContainerReplaceRules;

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs, duplicateInvalidInputs,tooLargeForBagInvalidInputs,noBagModelsInvalidInputs,notEnoughAutoclaveSpaceInvalidInputs,
		invalidDimensionsInputs,invalidEmptyContainerInputs, invalidNonEmptyContainerInputs,invalidUnsafeContentsInputs,invalidContainersSolidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{invalidNameOption,invalidAutoclaveProgramForBagsOption,invalidAutoclaveProgramOption}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Simulation -> updatedSimulation]]
  ];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];


	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentAutoclave,
			myInputs,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
      Cache -> cache,
      Simulation -> updatedSimulation,
      RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AliquotWarningMessage->Null,
			AllowSolids->True,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentAutoclave,
				myInputs,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
        Cache -> cache,
        Simulation -> updatedSimulation,
        RequiredAliquotContainers->targetContainers,
				RequiredAliquotAmounts->Null,
				AliquotWarningMessage->Null,
				AllowSolids->True,
				Output->Result
			],
			{}
		}
	];

	(* get the resolved Email option; for this experiment. the default is True *)
	email=If[MatchQ[Lookup[myOptions,Email],Automatic],
		True,
		Lookup[myOptions,Email]
	];

	(* Pre-resolve Post Processing Options *)
	preResolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions,Sterile->True];

	(* ExperimentImageSample, ExperimentMeasureVolume, and ExperimentMeasureWeight don't take Object[Item] as input. *)
	(* So if any of the inputs is an Item... *)
	resolvedPostProcessingOptions=If[MemberQ[listedInputs,ObjectP[Object[Item]]],

		(* Then set the options that would enqueue those experiment functions to False *)
		Normal[Join[
			{
				Association@@preResolvedPostProcessingOptions,
				<|ImageSample->False,MeasureVolume->False,MeasureWeight->False|>
			}
		]],

		(* Otherwise, use the pre-resolved option values *)
		preResolvedPostProcessingOptions
	];

	(* get the rest directly *)
	{confirm,canaryBranch,template,fastTrack,operator,parentProtocol,upload,outputOption,cacheOption,samplesInStorage}=Lookup[myOptions,{Confirm,CanaryBranch,Template,FastTrack,Operator,ParentProtocol,Upload,Output,Cache,SamplesInStorageCondition}];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->ReplaceRule[Normal[Join[autoclaveOptionsAssociation,Association@@resolvedSamplePrepOptions,Association@@resolvedAliquotOptions,Association@@resolvedPostProcessingOptions]],
			{
				AutoclaveProgram->resolvedAutoclaveProgram,
				Instrument->resolvedInstrument,
				SterilizationBag->resolvedSterilizationBag,
				Confirm->confirm,
				CanaryBranch->canaryBranch,
				Name->name,
				Template->template,
				Cache->cacheOption,
				Email->email,
				FastTrack->fastTrack,
				Operator->operator,
				Output->outputOption,
				ParentProtocol->parentProtocol,
				Upload->upload,
				SamplesInStorageCondition->samplesInStorage
			}
		],
		Tests->Cases[Flatten[
			{
				samplePrepTests, discardedTests,duplicateInputTests,notEnoughAutoclaveSpaceTests,inputTooLargeTests,invalidEmptyContainerTests,
				invalidUnsafeContentsTests,invalidNonEmptyContainersTest, invalidAutoclaveProgramForBagsTest,validAutoclaveProgramTests,
				sterilizationMethodTest,tooLargeForBagTest,noBagModelsTest,validNameTest,validSolidContainersTests,containerTooFullTests,
				nonAutoclavableLiquidContainerTests,aliquotTests
			}
		],_EmeraldTest]
	}
];



(* ::Subsubsection::Closed:: *)
(*autoclaveResourcePackets (private helper)*)


(* --- pageNEWResourcePackets --- *)

DefineOptions[
	autoclaveResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* Private function to generate the list of protocol packets containing resource blobs *)
autoclaveResourcePackets[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item]}]],myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myResourceOptions:OptionsPattern[autoclaveResourcePackets]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,cache,simulation,listedInputs,itemInputs,containerInputs,
		aliquotVolumes,autoclaveInstrument,autoclaveProgram,autoclaveBag,
		autoclaveResource,steamIntegrator,steamIntegratorResource,aluminumFoilResource,autoclaveTapeResource,sterilizationTime,sterilizationTemperature,secondaryContainerResource,listedSamplePackets,listedContainerPackets,
		sampleObjectPackets,sampleModelPackets,containerObjectPackets,containerModelPackets,containerContentsObjectPackets,joinedObjectPackets,joinedModelPackets,
		joinedContentsObjectPackets,combinedUnsortedPackets,combinedSortedPackets,inputObjectPackets,inputModelPackets,inputContentsObjectPackets,
		emptyContainers,containersInLinks,emptyContainerReplaceRules,
		containerResourceLinks,containerResourceReplaceRules,itemNullReplaceRules,containersInReplaceRules,containersInLinksIndexMatched,
		selfContainedSampleResources,selfContainedSampleResourceLinks,selfContainedSampleReplaceRules,aliquottedContainerInputs,aliquottedSamplePackets,aliquottedSampleObjects,aliquotSampleRequiredVolumes,
		aliquotSampleResources,aliquotSampleResourceLinks,aliquotSampleResourceReplaceRules,nonAliquotContainerInputs,nonAliquotSamplePackets,nonAliquotSampleObjects,nonAliquotSampleResources,
		nonAliquotSampleResourceLinks,nonAliquotSampleResourceReplaceRules,samplesInReplaceRules,samplesInLinks,
		autoclaveBagsResources,autoclaveBagsLinksIndexMatched,inputsInLinksIndexMatched,autoclaveBagsLinks,baggedInputsLinks,baggedInputsNoBacklinks,autoclaveBagPositions,sterilizationBagPlacements,
		autoclaveID,author,
		protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule
	},

	(* Expand the resolved options *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentAutoclave,{myInputs},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentAutoclave,
		RemoveHiddenOptions[ExperimentAutoclave,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification=Lookup[ToList[myResourceOptions],Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; If True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the cache and simulation *)
	cache=Lookup[ToList[myResourceOptions],Cache];
	simulation=Lookup[ToList[myResourceOptions],Simulation];

	(* Make sure the inputs to this function are a list *)
	listedInputs=ToList[myInputs];

	(* Separate the container inputs and the self-contained sample inputs *)
	itemInputs=Cases[myInputs,ObjectP[Object[Item]]];
	containerInputs=Cases[myInputs,ObjectP[Object[Container]]];

	(* Pull out relevant info from the resolved options *)
	{aliquotVolumes,autoclaveInstrument,autoclaveProgram,autoclaveBag}=
		Lookup[myResolvedOptions,{AliquotAmount,Instrument,AutoclaveProgram,SterilizationBag}];

	(* -- Make the resources that are shared across all the Autoclave protocols -- *)
	(* Make the autoclave resource *)
	autoclaveResource=Resource[Instrument->autoclaveInstrument,Time->90Minute];

	(* Make the steam integrator resource *)
	steamIntegrator=Model[Item,Consumable,"3M Autoclave Steam Integrator"];

	steamIntegratorResource=Resource[Sample->steamIntegrator,Untracked->True];

	(* Make the aluminium foil and autoclave tape resources *)
	aluminumFoilResource=Resource[Sample->Model[Item,Consumable,"id:xRO9n3vk166w"],Untracked->True];
	autoclaveTapeResource=Resource[Sample->Model[Item,Consumable,"id:R8e1PjRDbb9X"],Untracked->True];

	(* Set the sterilization time, the sterilization temperature based on the autoclave program *)
	{sterilizationTime,sterilizationTemperature,secondaryContainerResource}=If[MatchQ[autoclaveProgram,Universal],
		{7*Minute,134*Celsius,{}},
		{20*Minute,121*Celsius,{Link[Resource[Sample->Model[Container,Rack,"id:Vrbp1jG800Jb"],Rent->True]]}}
	];

	(* --- Make resources for the input containers and samples --- *)
	(* -- First, need to Download information about the input samples and containers to figure out how to structure SamplesIn and Containers In and which resources to make -- *)
	{listedSamplePackets,listedContainerPackets}=Quiet[
		Download[
			{
				itemInputs,
				containerInputs
			},
			{
				{
					Packet[Object],
					Packet[Model[{Name,Dimensions}]]
				},
				{
					Packet[Object],
					Packet[Model[{Name,Dimensions}]],
					Packet[Contents[[All,2]][{Name,Count}]]
				}
			},
			Cache->cache,
			Simulation->simulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* extract out the packets *)
	(* The first two are packets downloaded from myInputs that are samples (items in the future) *)
	sampleObjectPackets=listedSamplePackets[[All,1]];
	sampleModelPackets=listedSamplePackets[[All,2]];

	(* The next 4 are packets downloaded my myInputs that are containers, either empty or with a sample in them (could be a sample input in a container) *)
	containerObjectPackets=listedContainerPackets[[All,1]];
	containerModelPackets=listedContainerPackets[[All,2]];
	containerContentsObjectPackets=listedContainerPackets[[All,3]];

	(* --- stitch together the various sample and container packets so that they are in the correct order (order of myInputs) --- *)
	(* First, join each type of packet together, for joinedContentsModelPackets and joinedContentsObjectPackets, we join a list of empty lists to to it, since sample inputs don't have contents, and we need these lists to be the same length for transpose *)
	joinedObjectPackets=Join[sampleObjectPackets,containerObjectPackets];
	joinedModelPackets=Join[sampleModelPackets,containerModelPackets];
	joinedContentsObjectPackets=Join[Table[{},Length[itemInputs]],containerContentsObjectPackets];

	(* Next, rearrange the joined lists of packets based on the order of the input samples *)
	combinedUnsortedPackets=Transpose[{joinedObjectPackets,joinedModelPackets,joinedContentsObjectPackets}];

	combinedSortedPackets=Map[
		Function[{object},
			SelectFirst[combinedUnsortedPackets,MatchQ[#[[1]],ObjectP[object]]&]
		],
		myInputs
	];

	(* Then, define the subPackets of combinedSortedPackets *)
	{inputObjectPackets,inputModelPackets,inputContentsObjectPackets}=Transpose[combinedSortedPackets];

	(* -- Make a list of resource links for ContainersIn -- *)

	(* Make a list of resource links for all container inputs *)
	containerResourceLinks=Map[
		Link[
			Resource[
				Sample->#,
				Name->ToString[Unique[]]
			],
			Protocols
		]&,
		containerInputs
	];

	(* Define the replacement rules to replace Containers from listedInputs with links to resources *)
	containerResourceReplaceRules=MapThread[
		(#1->#2)&,
		{containerInputs,containerResourceLinks}
	];

	(* Define the replacement rules to replace Items from listedInputs with Null *)
	itemNullReplaceRules=Map[
		(#->Null)&,
		itemInputs
	];

	(* Join the replacement rules together *)
	containersInReplaceRules=Join[containerResourceReplaceRules,itemNullReplaceRules];

	(* Use the replacement rules on listedInputs to get a list index-matched to listedInputs in which all Containers are replaced with resources and all Items are replaced with Null *)
	containersInLinksIndexMatched=listedInputs/.containersInReplaceRules;

	(* Remove the Null elements, leaving a list of links to container resources *)
	containersInLinks=Cases[containersInLinksIndexMatched,Except[Null]];

	(* -- Make a list of Links and Nulls for the SamplesIn resources do this by defining replace rules for myInputs - mySamples needs to be index matched to myInputs -- *)

	(* First, find the empty containers *)
	emptyContainers=PickList[containerInputs,containerContentsObjectPackets,{}];

	(* - Define the replace rules for empty containers - these will be Null because they contain no sample - *)
	emptyContainerReplaceRules=Map[
		(#->Null)&,
		emptyContainers
	];

	(* - Next, define the SamplesIn replace rules for any self contained samples - *)
	(* Make resources for the self-contained samples *)
	selfContainedSampleResources=Map[
		Resource[
			Sample->#,
			Name->ToString[Unique[]]
		]&,
		itemInputs
	];

	(* Wrap Links around these resources so they match the pattern required for SamplesIn *)
	selfContainedSampleResourceLinks=Map[
		Link[#,Protocols]&,
		selfContainedSampleResources
	];

	(* Define the SamplesIn replace rules for the self contained sample inputs (all sample inputs to this function) *)
	selfContainedSampleReplaceRules=MapThread[
		(#1->#2)&,
		{itemInputs,selfContainedSampleResourceLinks}
	];

	(* - Next, define the replace rules for any container inputs that have samples which require aliquotting - *)
	(* Find the containers which have samples inside that need to be aliquotted (we need the aliquot volume of these samples in the resources) *)
	aliquottedContainerInputs=PickList[myInputs,aliquotVolumes,Except[Null]];

	(* Make a list of the sample object packets inside of these containers *)
	aliquottedSamplePackets=PickList[inputContentsObjectPackets,aliquotVolumes,Except[Null]];

	(* From these packets, make a list of the sample objects *)
	aliquottedSampleObjects=Lookup[Flatten[aliquottedSamplePackets],Object,{}];

	(* Find the aliquot volumes of the samples to be aliquotted - need to request this amount in the resources for these samples *)
	aliquotSampleRequiredVolumes=Cases[aliquotVolumes,Except[Null]];

	(* Make the resources for the samples which need to be aliquoted *)
	aliquotSampleResources=MapThread[
		Resource[
			Sample->#1,
			Amount->#2,
			Name->ToString[Unique[]]
		]&,
		{aliquottedSampleObjects,aliquotSampleRequiredVolumes}
	];

	(* Wrap Links around these resources so they match the pattern required for SamplesIn *)
	aliquotSampleResourceLinks=Map[
		Link[#,Protocols]&,
		aliquotSampleResources
	];

	(* Define the SamplesIn replace rules for the container inputs with contents that are to be aliquoted *)
	aliquotSampleResourceReplaceRules=MapThread[
		(#1->#2)&,
		{aliquottedContainerInputs,aliquotSampleResourceLinks}
	];

	(* - Next, define the replace rules for any container inputs that have samples which do not require aliquotting - *)

	(* Find the containers which have samples inside that do not need to be aliquoted *)
	nonAliquotContainerInputs=Cases[containerInputs,Except[Alternatives@@Join[emptyContainers,aliquottedContainerInputs]]];

	(* Make a list of the sample object packets inside of these containers *)
	nonAliquotSamplePackets=PickList[inputContentsObjectPackets,myInputs,Alternatives@@nonAliquotContainerInputs];

	(* From these packets, make a list of the sample objects *)
	nonAliquotSampleObjects=Lookup[Flatten[nonAliquotSamplePackets],Object,{}];

	(* Make the resources for the samples that do not need to be aliquoted *)
	nonAliquotSampleResources=Map[
		Resource[
			Sample->#,
			Name->ToString[Unique[]]
		]&,
		nonAliquotSampleObjects
	];

	(* Wrap Links around these resources so they match the pattern required for SamplesIn *)
	nonAliquotSampleResourceLinks=Map[
		Link[#,Protocols]&,
		nonAliquotSampleResources
	];

	(* Define the SamplesIN replace rules for the container inputs with contents that don't need to be aliquotted *)
	nonAliquotSampleResourceReplaceRules=MapThread[
		(#1->#2)&,
		{nonAliquotContainerInputs,nonAliquotSampleResourceLinks}
	];

	(* Join all of these lists of replace rules to form a big list of replace rules that will turn myInputs into the SamplesIn list of sample resources and Nulls, index matched to myInputs *)
	samplesInReplaceRules=Join[emptyContainerReplaceRules,selfContainedSampleReplaceRules,aliquotSampleResourceReplaceRules,nonAliquotSampleResourceReplaceRules];

	(* Create the list of links to sample resources and Nulls which is index matched to myInputs - Nulls where there are empty containers *)
	samplesInLinks=listedInputs/.samplesInReplaceRules;

	(* -- Make the autoclave bag resources -- *)

	(* Make a list of resources for these autoclave bags (or Nulls for indices where the SterilizationBag Option is Null) *)
	autoclaveBagsResources=Map[
		If[NullQ[#],
			Null,
			Resource[
				Sample->#,
				Name->ToString[Unique[]]
			]
		]&,
		autoclaveBag
	];

	(* Wrap links around the autoclave bag resource blobs (Link[Null] is Null) *)
	autoclaveBagsLinksIndexMatched=Map[
		Link[#]&,
		autoclaveBagsResources
	];

	(* Get a list of the links to resources made for all inputs *)
	(* If an element of containersInLinksIndexMatched is Null, that means the element of samplesInLinks is self-contained (an Object[Item]) *)
	inputsInLinksIndexMatched=MapThread[
		If[NullQ[#2],
			#1,
			#2
		] &,
		{samplesInLinks,containersInLinksIndexMatched}
	];

	(* Get a list of links to resources for the inputs that should be bagged *)
	baggedInputsLinks=PickList[inputsInLinksIndexMatched,autoclaveBag,Except[Null]];

	(* Get a list of links to resources for the autoclave bags into which those inputs will be sealed *)
	autoclaveBagsLinks=PickList[autoclaveBagsLinksIndexMatched,autoclaveBag,Except[Null]];

	(* Remove the backlink Field from the bagged inputs links to match the storage pattern of SterilizationBagPlacements *)
	baggedInputsNoBacklinks=Take[#,1]&/@baggedInputsLinks;

	(* Get a list of the positions of the bags that the items will be placed into *)
	autoclaveBagPositions="A1"&/@autoclaveBagsLinks;

	(* Arrange the lists of bagged inputs, bags, and bag positions into the storage pattern of the SterilizationBagPlacements Field *)
	sterilizationBagPlacements=Transpose[{baggedInputsNoBacklinks,autoclaveBagsLinks,autoclaveBagPositions}];

	(* -- General Protocol packet fields -- *)
	(* Create the Autoclave protocol ID *)
	autoclaveID=CreateID[Object[Protocol,Autoclave]];

	(* get the author *)
	author=$PersonID;

	protocolPacket=
		<|
			Object->autoclaveID,
			Type->Object[Protocol,Autoclave],
			Template->Link[Lookup[resolvedOptionsNoHidden,Template],ProtocolsTemplated],
			Replace[SamplesIn]->samplesInLinks,
			Replace[ContainersIn]->containersInLinks,
			Replace[SterilizationBagPlacements]->sterilizationBagPlacements,
			SteamIntegrator->Link[steamIntegratorResource],
			Instrument->Link[autoclaveResource],
			AluminumFoil->Link[aluminumFoilResource],
			AutoclaveTape->Link[autoclaveTapeResource],
			Replace[AutoclaveProgram]->{autoclaveProgram},
			SterilizationTime->sterilizationTime,
			SterilizationTemperature->sterilizationTemperature,
			Replace[SecondaryContainer]->secondaryContainerResource,
			ResolvedOptions->myResolvedOptions,
			UnresolvedOptions->myUnresolvedOptions,
			ParentProtocol->If[MatchQ[Lookup[myResolvedOptions,ParentProtocol],ObjectP[]],Link[Lookup[myResolvedOptions,ParentProtocol],Subprotocols]],
			Author->If[MatchQ[Lookup[myResolvedOptions,ParentProtocol],ObjectP[]],Null,Link[author,ProtocolsAuthored]],
			Replace[Checkpoints]->{
				{"Preparing Samples",5 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->5 Minute]]},
				{"Picking Resources",10*Minute,"Empty containers and resources required for the autoclave are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
				{"Loading",30Minute,"Samples are loaded into the autoclave instrument.",Link[Resource[Operator->$BaselineOperator,Time->30 Minute]]},
				{"Autoclaving",90Minute,"Samples are autoclaved.",Link[Resource[Operator->$BaselineOperator,Time->90 Minute]]},
				{"Unloading",15Minute,"Autoclaved samples are unloaded.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]},
				{"Cooling",30Minute,"Autoclaved samples are cooled down to ambient conditions.",Link[Resource[Operator->$BaselineOperator,Time->30 Minute]]},
				{"Sample Post-Processing",30Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->$BaselineOperator,Time->30 Minute]]},
				{"Returning Materials",15Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]}
			},
			ImageSample->Lookup[expandedResolvedOptions,ImageSample],
			Replace[SamplesInStorage]->Lookup[expandedResolvedOptions,SamplesInStorageCondition]
		|>;

	(* Generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[listedInputs,expandedResolvedOptions,Cache->cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* --- fulfillableResourceQ --- *)

	(* Get all the resource blobs *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation -> Simulation[cache]],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache, Simulation -> Simulation[cache]],Null}
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
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];



(* ::Subsection::Closed:: *)
(*ExperimentAutoclaveOptions*)


(* ExperimentAutoclaveOptions *)
DefineOptions[ExperimentAutoclaveOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Determines whether the function returns a table or a list of the options."
		}},
	SharedOptions:>{ExperimentAutoclave}
];

ExperimentAutoclaveOptions[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for ExperimentAutoclave *)
	options=ExperimentAutoclave[myInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		(*LegacySLL`Private`optionsToTable[DeleteCases[options,TargetSampleGroupings->_],ExperimentAutoclave],*)
		LegacySLL`Private`optionsToTable[options,ExperimentAutoclave],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentAutoclavePreview*)


(* ExperimentAutoclavePreview *)
DefineOptions[ExperimentAutoclavePreview,
	SharedOptions:>{ExperimentAutoclave}
];

ExperimentAutoclavePreview[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* Return Null *)
	ExperimentAutoclave[myInputs,Append[noOutputOptions,Output->Preview]]
];



(* ::Subsection::Closed:: *)
(*ValidExperimentAutoclaveQ*)


(* ValidExperimentAutoclaveQ *)
DefineOptions[ValidExperimentAutoclaveQ,
	Options:>
		{
			VerboseOption,
			OutputFormatOption
		},
	SharedOptions:>{ExperimentAutoclave}
];

ValidExperimentAutoclaveQ[myInputs:ListableP[ObjectP[{Object[Container,Vessel],Object[Container,Rack],Object[Sample],Object[Item],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,experimentAutoclaveTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentAutoclave *)
	experimentAutoclaveTests=ExperimentAutoclave[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[experimentAutoclaveTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myInputs],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,experimentAutoclaveTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentAutoclaveQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentAutoclaveQ"]
];
