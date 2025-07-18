(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureCount*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureCount - Options*)


DefineOptions[ExperimentMeasureCount,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> ParameterizeSolidUnits,
				Default -> Automatic,
				AllowNull-> False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description-> "For each input, indicates if a small number of tablets or sachets should be weighed to determine the average solid unit weight of this sample. If specified when SolidUnitWeight is already informed, the newly recorded weight of the tablets or sachets will overwrite the existing SolidUnitWeight.",
				ResolutionDescription-> "Automatic will resolve to True if SolidUnitWeight is unknown and/or SolidUnitParameterizationReplicates is specified, or False if SolidUnitWeight is already informed."
			},
			{
				OptionName -> SolidUnitParameterizationReplicates,
				Default -> Automatic,
				AllowNull -> True,
				Widget-> Widget[Type->Number, Pattern :> RangeP[5, 20, 1]],
				Description-> "For each input, the number of tablets or sachets that should be weighed to determine the average solid unit weight of this sample. Cannot be specified if ParameterizeSolidUnits is set to False. If specified when SolidUnitWeight is already informed, the newly recorded weight of the tablets or sachets will overwrite the existing SolidUnitWeight.",
				ResolutionDescription-> "If the SolidUnitWeight is unknown or ParameterizeSolidUnits is set to True, automatically resolves to 10, if enough are available. If SolidUnitWeight is already informed and/or ParameterizeSolidUnits is set to False, resolves to Null."
			},
			{
				OptionName -> MeasureTotalWeight,
				Default -> Automatic,
				AllowNull-> False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description-> "For each input, indicates if the total weight of this sample should be measured. If specified when Mass (in Object[Sample]) is already informed, the newly recorded total weight of the sample will overwrite the existing Mass.",
				ResolutionDescription-> "Automatic will resolve to True if Mass (in Object[Sample]) is unknown or False if Mass is already informed."
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description -> "The number of times to repeat the experiment on each provided sample. Note that if specified, the recorded measurements will be pooled for determining the count of the sample(s): the SolidUnitWeight and the Mass in Object[Sample] (if determined in this experiment) will be calculated from the average of all experimental replicates and the count of the sample is calculated from the average SolidUnitWeight and the average Mass.",
			AllowNull->True,
			(* Category->"Protocol",*)
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2,1]]
		},
		ProtocolOptions,
		ImageSampleOption,
		PreparatoryUnitOperationsOption,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 1."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		SamplesInStorageOptions,
		SubprotocolDescriptionOption,
		SimulationOption
	}
];


(* === ERRORS go there === *)

(* Errors before the resolution *)
Warning::NonTabletOrSachetSamples="The sample(s) `1` do(es) not contain tablets or sachets, as indicated by the fields Tablet and Sachet. Remove the sample(s) from the inputs or double check that the sample(s) do(es) contain tablets or sachets.";
Error::IncompatibleContainer="The following sample(s), `1`, need(s) to be total-weight measured but are in container(s) that is/are not compatible with ExperimentMeasureWeight. Consider moving the sample(s) into a container that matches MeasureWeightContainerP or remove them from the input before proceeding.";
Error::ParameterizationRequired="For sample(s) `1`, ParameterizeSolidUnits is set to False, although the SolidUnitWeight is not known. As a result, the count of the sample(s) cannot be determined. Consider setting ParametererizeSolidUnits to True (or leave it blank) in order to parameterize the tablets or sachets and record a SolidUnitWeight.";
Error::InvalidParameterizationOptions="For sample(s) `1`, SolidUnitParameterizationReplicates is specified but ParameterizeSolidUnits is set to False. SolidUnitParameterizationReplicates can only be specified when tablets or sachets are being parameterized. Consider setting ParametererizeSolidUnits to True in order to parameterize the tablets or sachets, or leave SolidUnitParameterizationReplicates blank if the SolidUnitWeight is known and you would like to use the currently recorded solid unit weight to calculate the count.";
Error::ParameterizationReplicatesRequired="For sample(s) `1`, tablets and sachets need to be parameterized (because ParameterizeSolidUnits is True and/or the SolidUnitWeight is not known), however SolidUnitParameterizationReplicates is set to Null. Consider specifying SolidUnitParameterizationReplicates to the number of tablets or sachets you would like to use for paramteterization (or leave it blank), or remove the sample(s) `1` from the input before proceeding.";
Error::TotalWeightRequired="For sample(s) `1`, MeasureTotalWeight is set to False although the Mass of the samples is not known. As a result, the count of the sample(s) cannot be determined.  SolidUnitParameterizationReplicates can only be specified when tablets or sachets are being parameterized. Consider setting MeasureTotalWeight to True (or leave it blank) in order to record the total weight of the sample(s).";
(* Warnings before the resolution *)
Warning::MassKnown="For samples `1`, the MeasureTotalWeight is set to True although the Mass of the sample(s) is known. As a result the total weight of the sample(s) will be re-measured and the Mass in Object[Sample] overwritten with the newly recorded value. Consider leaving MeasureTotalWeight blank or set it to False, if you would like to calculate the count using the currently recorded Mass.";
Warning::SolidUnitWeightKnown="For sample(s) `1`, the option `2` is specified although the SolidUnitWeight is known. As a result the tablets or sachets will be re-parameterized and the SolidUnitWeight overwritten with the newly recorded value. Consider leaving `2` blank if you would like to keep the currently existing SolidUnitWeight.";


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureCount*)


ExperimentMeasureCount[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Object[Item],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
	myOptionsWithPreparedSamples,containerToSampleSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleCache,
	sampleOptions,containerToSampleTests,updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureCount,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 1,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentMeasureCount,
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
				ExperimentMeasureCount,
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
		ExperimentMeasureCount[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]

];


ExperimentMeasureCount[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,listedSamples,outputSpecification,output,gatherTests,messages,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,safeOps,safeOptionsNamed,safeOpsTests,validLengths,validLengthTests,
		upload,confirm,canaryBranch,fastTrack,parentProt,cache,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,
		objectSampleFields,objectContainerFields,modelContainerFields,cacheBall,resolvedOptionsResult,resolvedOptions,
		resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,allTests,validQ,previewRule,optionsRule,
		testsRule,resultRule,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed
	},

	(* Make sure we're working with a list of options *)
	(* Remove temporal links and throw warnings *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureCount,
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
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureCount,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureCount,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureCount,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureCount,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	{upload, confirm, canaryBranch, fastTrack, parentProt, cache} = Lookup[safeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureCount,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureCount,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasureCount,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Define the fields to download from objects *)
	objectSampleFields=Union[{SolidUnitWeight,Tablet,Sachet},SamplePreparationCacheFields[Object[Sample]]];

	(* Define the fields to download from container of objects *)
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];

	(* Define the fields to download from container model of objects *)
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	cacheBall=FlattenCachePackets[{
		cache,
		Quiet[
			Download[
				ToList@mySamplesWithPreparedSamples,
				{
					Evaluate@Packet[objectSampleFields],
					Packet[Container[objectContainerFields]],
					Packet[Container[Model[modelContainerFields]]]
				},
				Cache -> cache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist, Download::MissingCacheField}
		]
	}];

	(* TODO here we should filter out invalid input if we're in a sub protocol like MeasureVolume and MeasureWeight do it as well (see "filteredContainersIn" in MW) - only valid input get's passed into the resolver below *)
	(* invalid input here would be any samples that are no tablets or sachets, are discarded, or are in containers not compatible with MW and we would have to do MW on the entire container *)

	(* Build the resolved options - check whether we need to return early *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureCountOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption; if those were thrown, we encountered a failure *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureCountOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureCount,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed, return early; messages would have been thrown already *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Flatten[Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests]],
			Options->RemoveHiddenOptions[ExperimentMeasureCount,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		measureCountResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{measureCountResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
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
		RemoveHiddenOptions[ExperimentMeasureCount,collapsedResolvedOptions],
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
			resourcePackets,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Upload -> upload,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,MeasureCount],
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* return the output as we desire it *)
		outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];



(* ::Subsubsection::Closed:: *)
(*resolveMeasureCountOptions*)


(* ========== resolveMeasureCount Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)
(* the inputs are the sample packet, and the input options (safeOptions) *)

DefineOptions[
	resolveExperimentMeasureCountOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentMeasureCountOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureCountOptions]]:=Module[
	{
		outputSpecification, output, gatherTests, messages, inheritedCache, simulation, samplePrepOptions, measureCountOptions,
		measureCountOptionsAssociation, simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
		allSamplePackets, discardedSamplePackets, discardedInvalidInputs, discardedTests, nonTabletOrSachetBoolean,incompatibleContainerSamples,incompatibleContainerTests,
		nonTabletOrSachetSamplePackets, nonTabletOrSachetInvalidInputs, tabletOrSachetsTests, nonTabletOrSachetInvalidInputMessage,
		replicatesNotRequiredSamples,replicatesNotRequiredWarning,replicatesNotRequiredTests,
		parameterizationNotRequiredSamples,parameterizationNotRequiredWarning,parameterizationNotRequiredTests,
		requireParameterizationMismatches,parameterizeSolidUnitsMismatchOption, invalidParameterizeSolidUnitsInputs, invalidParameterizeSolidUnitsOption, parameterizeSolidUnitsOptionInvalidTests,
		massKnownMismatchSamples, massKnownWarning, massKnownTests, parameterizationOptionsMismatches, parameterizeReplicateMismatchOptions,
		invalidParameterizeReplicateInput, invalidParameterizeOptions, parameterizeOptionsInvalidTests, replicatesRequiredMismatches,
		requireReplicatesOptions, invalidRequireReplicatesInput, requireReplicatesInvalidOptions, replicatesRequiredTests,
		requireTotalWeightMismatches, weightMismatchOptions, invalidTotalWeightInputs, invalidTotalWeightOption, totalWeightNeededTests,
		mapThreadFriendlyOptions, measureTotalWeightList, parameterizeSolidUnitsList, solidUnitParameterizationReplicatesList, replicates,
		name, confirm, canaryBranch, template, samplesInStorageCondition, operator, parentProtocol, upload, outputOption, email,
		imageSample, resolvedEmail, resolvedImageSample, numberOfReplicates, resolvedOptions, allTests, resultRule, testsRule,
		invalidInputs, invalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*when OptionValue doesn't work we can use this (make sure to call the function with the Output option so we can look it up)*)
	(* output=Lookup[ToList[myOptions],Output]; *)

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions],Simulation,{}];

	(* Separate out our MeasureCount options from our Sample Prep options. *)
	{samplePrepOptions,measureCountOptions}=splitPrepOptions[myOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureCountOptionsAssociation = Association[measureCountOptions];

	(* Resolve our sample prep options. *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMeasureCount,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMeasureCount,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	allSamplePackets=Flatten[
		Quiet[
			Download[
				{
					ToList[simulatedSamples]
				},
				{
					Packet[Status,Container,Mass,Type,Model,SolidUnitWeight,Tablet,Sachet,State]
				},
				Simulation->updatedSimulation,
				Cache->inheritedCache,
				Date->Now
			],
			Download::FieldDoesntExist
		]
	];

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. DISCARDED SAMPLES *)

	(* Get the sample packets that are discarded. *)
	discardedSamplePackets=Cases[Flatten[allSamplePackets],KeyValuePattern[Status->Discarded]];

	(*  keep track of the invalid inputs *)
	discardedInvalidInputs=If[Length[discardedSamplePackets]>0,
		Lookup[discardedSamplePackets,Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]<>" is/are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Simulation->updatedSimulation]<>" is/are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 2. NON-TABLET OR SACHET SAMPLES *)

	(* Get the sample packets that are no tablets or sachets. *)
	nonTabletOrSachetBoolean = Map[
		If[!MemberQ[#,True],
			True,
			False
		]&,
	Lookup[allSamplePackets, {Tablet,Sachet},{}]
	];

	nonTabletOrSachetSamplePackets = PickList[allSamplePackets, nonTabletOrSachetBoolean, True];

 (*  keep track of the invalid inputs. *)
	nonTabletOrSachetInvalidInputs = If[Length[nonTabletOrSachetSamplePackets]>0,
		Lookup[nonTabletOrSachetSamplePackets,Object],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw a warning message *)
  (* NOTE: we're not throwing a hard error since we want to be open to users using a Object[Sample] to register a tablet sample (to list composition), and the Tablet flag is inside Chemical currently. We'll roll with this odd decision and simply throw warning here *)
	nonTabletOrSachetInvalidInputMessage=If[Length[nonTabletOrSachetInvalidInputs]>0&&!gatherTests && !MatchQ[$ECLApplication,Engine],
		Message[Warning::NonTabletOrSachetSamples,ObjectToString[nonTabletOrSachetInvalidInputs,Simulation->updatedSimulation]],
		(* if there are no non-tablet inputs, we don't throw a warning and the list is empty*)
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tabletOrSachetsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonTabletOrSachetInvalidInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Warning["The input sample(s) "<>ObjectToString[nonTabletOrSachetInvalidInputs,Simulation->updatedSimulation]<>" contain(s) tablets",True,False]
			];

			passingTest=If[Length[nonTabletOrSachetInvalidInputs]==Length[mySamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Warning["The input sample(s) "<>ObjectToString[Complement[mySamples,nonTabletOrSachetInvalidInputs],Simulation->updatedSimulation]<>" contain(s) tablets:",True,True]
			];

			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* 3. Incompatible Container Error *)

	(* collect all samples for which either MeasureTotalWeight is set to True and or Mass is not informed, and that are in a container that is not measure-weight compatible *)
	incompatibleContainerSamples=MapThread[
		Function[{measureWeight,mass,container,sampleObject},
			Switch[{measureWeight,mass,container},
				(* If MeasureTotalWeight is set to true, we need the container to be measure-weight compatible *)
				{True,_,Except[MeasureWeightContainerP]},
					sampleObject,
				(* If Mass is not known we also need the container to be measure-weight compatible *)
				{_,Null,Except[MeasureWeightContainerP]},
					sampleObject,
				(* in all other cases we're fine *)
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,MeasureTotalWeight],Lookup[allSamplePackets,Mass,{}],Lookup[allSamplePackets,Container,{}],mySamples}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[incompatibleContainerSamples]>0&& messages,
		Message[Error::IncompatibleContainer,ObjectToString[incompatibleContainerSamples,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleContainerTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleContainerSamples]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The container of the following input sample(s), "<>ObjectToString[incompatibleContainerSamples,Simulation->updatedSimulation]<>", is/are compatible with total weight measurement:",True,False]
			];

			passingTest=If[Length[incompatibleContainerSamples]==Length[mySamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The container of the following input sample(s), "<>ObjectToString[Complement[mySamples,incompatibleContainerSamples],Simulation->updatedSimulation]<>", is/are compatible with total weight measurement:",True,True]
			];

			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)

	(* there are no option precision checks in ExperimentMeasureCount *)

	(*-- CONFLICTING OPTIONS CHECKS --*)


	(* 1. SolidUnitParameterizationReplicates VS SolidUnitWeight Warning *)

	(* collect all samples for which SolidUnitParameterizationReplicates is specified and SolidUnitWeight is informed *)
	replicatesNotRequiredSamples=MapThread[
		Function[{replicates,solidUnitWeight,sampleObject},
			Switch[{replicates,solidUnitWeight},
			(* If the SolidUnitParameterizationReplicates is specified although we know the SolidUnitWeight, collect the sample *)
				{RangeP[5, 20, 1],GreaterEqualP[0*Gram]},
					sampleObject,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,SolidUnitParameterizationReplicates],Lookup[allSamplePackets,SolidUnitWeight,{}],mySamples}
	];

	(* If there are such samples and we are throwing messages, throw a warning message *)
	replicatesNotRequiredWarning=If[(Length[replicatesNotRequiredSamples]>0 && messages && !MatchQ[$ECLApplication,Engine]),
		Message[Warning::SolidUnitWeightKnown,ObjectToString[replicatesNotRequiredSamples,Simulation->updatedSimulation],SolidUnitParameterizationReplicates],
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	replicatesNotRequiredTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,replicatesNotRequiredSamples];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option SolidUnitParameterizationReplicates is set to True while the sample(s)'s SolidUnitWeight is unknown:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[replicatesNotRequiredSamples]>0,
				Warning ["For the input sample(s) "<>ObjectToString[replicatesNotRequiredSamples,Simulation->updatedSimulation]<>", the option SolidUnitParameterizationReplicates is set to True while the sample(s)'s SolidUnitWeight is unknown:",True,False],
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


	(* 2. ParameterizeSolidUnits VS SolidUnitWeight Warning *)

	(* collect all samples for which ParameterizeSolidUnits is set to True and SolidUnitWeight is informed *)
	parameterizationNotRequiredSamples=MapThread[
		Function[{parameterize,solidUnitWeight,sampleObject},
			Switch[{parameterize,solidUnitWeight},
			(* If the ParameterizeSolidUnits is specified althoug we know the SolidUnitWeight, collect the sample *)
				{True,GreaterEqualP[0*Gram]},
					sampleObject,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,ParameterizeSolidUnits],Lookup[allSamplePackets,SolidUnitWeight,{}],mySamples}
	];

	(* If there are such samples and we are throwing messages, throw a warning message *)
	parameterizationNotRequiredWarning=If[(Length[parameterizationNotRequiredSamples]>0 && messages && !MatchQ[$ECLApplication,Engine]),
		Message[Warning::SolidUnitWeightKnown,ObjectToString[parameterizationNotRequiredSamples,Simulation->updatedSimulation],ParameterizeSolidUnits],
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	parameterizationNotRequiredTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,parameterizationNotRequiredSamples];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to True while the sample(s)'s SolidUnitWeight is unknown:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[parameterizationNotRequiredSamples]>0,
				Warning ["For the input sample(s) "<>ObjectToString[parameterizationNotRequiredSamples,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to True while the sample(s)'s SolidUnitWeight is unknown:",True,False],
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

	(* 3. ParameterizeSolidUnits VS SolidUnitWeight Error *)

	(* ParameterizeSolidUnits is False when SolidUnitWeight is informed, otherwise we can't perform the experiment *)
	requireParameterizationMismatches=MapThread[
		Function[{parameterize,solidUnitWeight,sampleObject},
			Switch[{parameterize,solidUnitWeight},
			(* If the parameterization boolean is set to False but we don't know the SolidUnitWeight, return the sample with the mismatching option value *)
				{False,Null},
					{parameterize,sampleObject},
				{False|Automatic,GreaterEqualP[0*Gram]},
					Nothing,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,ParameterizeSolidUnits],Lookup[allSamplePackets,SolidUnitWeight,{}],mySamples}
	];

	(* Transpose our invalid option and input values if there were mismatches *)
	{parameterizeSolidUnitsMismatchOption,invalidParameterizeSolidUnitsInputs}=If[MatchQ[requireParameterizationMismatches,{}],
		{{},{}},
		Transpose[requireParameterizationMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	invalidParameterizeSolidUnitsOption=If[(Length[parameterizeSolidUnitsMismatchOption]>0 && messages),
		Message[Error::ParameterizationRequired,ObjectToString[invalidParameterizeSolidUnitsInputs,Simulation->updatedSimulation]];
		{ParameterizeSolidUnits},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	parameterizeSolidUnitsOptionInvalidTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,invalidParameterizeSolidUnitsInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to False while the sample(s)'s SolidUnitWeight is known:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidParameterizeSolidUnitsInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[invalidParameterizeSolidUnitsInputs,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to False while the sample(s)'s SolidUnitWeight is known:",True,False],
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


	(* 4a. SolidUnitParameterizationReplicates VS ParameterizeSolidUnits Error *)

	(* ParameterizeSolidUnits is False when SolidUnitParameterization is not specified, otherwise we have conflicting options and can't perform the experiment *)
	parameterizationOptionsMismatches=MapThread[
		Function[{parameterize,replicates,sampleObject},
			Switch[{parameterize,replicates},
			(* If the parameterization boolean is set to False but the replicates were, return the sample with the mismatch *)
				{False,RangeP[5, 20, 1]},
					{parameterize,sampleObject},
				{False|Automatic,Null},
					Nothing,
				{True|_},
					Nothing,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,ParameterizeSolidUnits],Lookup[measureCountOptionsAssociation,SolidUnitParameterizationReplicates],mySamples}
	];

	(* Transpose our result if there were mismatches. *)
	{parameterizeReplicateMismatchOptions,invalidParameterizeReplicateInput}=If[MatchQ[parameterizationOptionsMismatches,{}],
		{{},{}},
		Transpose[parameterizationOptionsMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	invalidParameterizeOptions=If[(Length[parameterizeReplicateMismatchOptions]>0 && messages),
		Message[Error::InvalidParameterizationOptions,ObjectToString[invalidParameterizeReplicateInput,Simulation->updatedSimulation]];
		{ParameterizeSolidUnits,SolidUnitParameterizationReplicates},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	parameterizeOptionsInvalidTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,invalidParameterizeReplicateInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to False while the option SolidUnitParameterizationReplicates is not specified:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidParameterizeReplicateInput]>0,
				Test["For the input sample(s) "<>ObjectToString[invalidParameterizeReplicateInput,Simulation->updatedSimulation]<>", the option ParameterizeSolidUnits is set to False while the option SolidUnitParameterizationReplicates is not specified:",True,False],
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


	(* 4b. SolidUnitParameterizationReplicates VS ParameterizeSolidUnits Error *)

	(* If ParameterizeSolidUnits is True (or Automatic while SolidUnitWeight is unknown) when SolidUnitParameterization is Null, we can't perform the experiment *)
	replicatesRequiredMismatches=MapThread[
		Function[{parameterize,solidUnitWeight,replicates,sampleObject},
			Switch[{parameterize,solidUnitWeight,replicates},
			(* If the parameterization boolean is set to False but the replicates were, return the sample with the mismatch *)
				{True,_,Null},
					{parameterize,sampleObject},
				{Automatic,Null,Null},
					{parameterize,sampleObject},
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,ParameterizeSolidUnits],Lookup[allSamplePackets,SolidUnitWeight,{}],Lookup[measureCountOptionsAssociation,SolidUnitParameterizationReplicates],mySamples}
	];

	(* Transpose our result if there were mismatches. *)
	{requireReplicatesOptions,invalidRequireReplicatesInput}=If[MatchQ[replicatesRequiredMismatches,{}],
		{{},{}},
		Transpose[replicatesRequiredMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	requireReplicatesInvalidOptions=If[(Length[requireReplicatesOptions]>0 && messages),
		Message[Error::ParameterizationReplicatesRequired,ObjectToString[invalidRequireReplicatesInput,Simulation->updatedSimulation]];
		{ParameterizeSolidUnits,SolidUnitParameterizationReplicates},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	replicatesRequiredTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,invalidRequireReplicatesInput];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option SolidUnitParameterizationReplicates is Null when the option ParameterizeSolidUnits is set to False and/or tablet weight is known:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidRequireReplicatesInput]>0,
				Test["For the input sample(s) "<>ObjectToString[invalidRequireReplicatesInput,Simulation->updatedSimulation]<>", the option SolidUnitParameterizationReplicates is Null when the option ParameterizeSolidUnits is set to False and/or tablet/sachet weight is known:",True,False],
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




	(* 5. MeasureTotalWeight VS Mass Warning *)

	(* collect all samples for which MeasureTotalWeight is True and Mass is informed *)
	massKnownMismatchSamples=MapThread[
		Function[{measure,mass,sampleObject},
			Switch[{measure,mass},
			(* If the MeasureTotalWeight boolean is set to True although we know the Mass, return the sample *)
				{True,GreaterEqualP[0*Gram]},
					sampleObject,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,MeasureTotalWeight],Lookup[allSamplePackets,Mass],mySamples}
	];

	(* If there are such samples and we are throwing messages, throw a warning message *)
	massKnownWarning=If[(Length[massKnownMismatchSamples]>0 && messages && !MatchQ[$ECLApplication,Engine]),
		Message[Warning::MassKnown,ObjectToString[massKnownMismatchSamples,Simulation->updatedSimulation]],
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	massKnownTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,massKnownMismatchSamples];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option MeasureTotalWeight is set to True while the sample(s)'s Mass is unknown:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[massKnownMismatchSamples]>0,
				Warning ["For the input sample(s) "<>ObjectToString[massKnownMismatchSamples,Simulation->updatedSimulation]<>", the option MeasureTotalWeight is set to True while the sample's Mass is unknown:",True,False],
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


	(* 6. MeasureTotalWeight VS Mass Error *)

	(* MeasureTotalWeight is False when Mass is informed, otherwise we can't perform the experiment *)
	requireTotalWeightMismatches=MapThread[
		Function[{measure,mass,sampleObject},
			Switch[{measure,mass},
			(* If the MeasureTotalWeight boolean is set to False but we don't know the Mass, return the sample *)
				{False,Null},
					{measure,sampleObject},
				{False|Automatic,GreaterEqualP[0*Gram]},
					Nothing,
				_,
					Nothing
			]
		],
		{Lookup[measureCountOptionsAssociation,MeasureTotalWeight],Lookup[allSamplePackets,Mass],mySamples}
	];

	(* Transpose our result if there were mismatches. *)
	{weightMismatchOptions,invalidTotalWeightInputs}=If[MatchQ[requireTotalWeightMismatches,{}],
		{{},{}},
		Transpose[requireTotalWeightMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	invalidTotalWeightOption=If[(Length[weightMismatchOptions]>0 && messages),
		Message[Error::TotalWeightRequired,ObjectToString[invalidTotalWeightInputs,Simulation->updatedSimulation]];
		{MeasureTotalWeight},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	totalWeightNeededTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,invalidTotalWeightInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the option MeasureTotalWeight is set to False while the sample's Mass is known:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidTotalWeightInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[invalidTotalWeightInputs,Simulation->updatedSimulation]<>", the option MeasureTotalWeight is set to False while the sample's Mass is known:",True,False],
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

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMeasureCount,measureCountOptionsAssociation];

	(* MapThread over each of our samples. *)
	{measureTotalWeightList,parameterizeSolidUnitsList,solidUnitParameterizationReplicatesList}=Transpose[
		MapThread[
			Function[{samplePacket,options},
				Module[{specifiedParameterizeSolidUnits,specifiedSolidUnitParameterizationReplicates,specifiedMeasureTotalWeight,
				solidUnitWeight,sampleMass,parameterizeSolidUnits,solidUnitParameterizationReplicates,measureTotalWeight
				},

					(* pull out the option values for ParameterizeSolidUnits, SolidUnitParameterizationReplicates, MeasureTotalWeight and TransferContainer *)
					{specifiedParameterizeSolidUnits,specifiedSolidUnitParameterizationReplicates,specifiedMeasureTotalWeight}= Lookup[options,{ParameterizeSolidUnits,SolidUnitParameterizationReplicates,MeasureTotalWeight}];

					(* also pull out some information from the packets that we will need later *)
					solidUnitWeight=Lookup[samplePacket,SolidUnitWeight,{}];
					sampleMass=Lookup[samplePacket,Mass];

					(* === Independent options resolution === *)

					(* resolve the ParameterizeSolidUnits and SolidUnitParameterizationReplicates option values *)
					{parameterizeSolidUnits,solidUnitParameterizationReplicates} = Switch[{specifiedParameterizeSolidUnits,specifiedSolidUnitParameterizationReplicates,solidUnitWeight},

						(* If ParameterizeSolidUnits is Automatic and SolidUnitParameterizationReplicates is specified by the user, we will parameterize *)
						(* we do this no matter what the SolidUnitWeight says - a warning will have been thrown above that we parameterize although the tablet/sachet weight is known *)
						{Automatic,RangeP[5, 20, 1],_},{True,specifiedSolidUnitParameterizationReplicates},

						(* If ParameterizeSolidUnits is Automatic and SolidUnitParameterizationReplicates is NOT specified by the user, we will not parameterize if the tablet/sachet weight is known *)
						{Automatic,Automatic,GreaterEqualP[0*Gram]},{False,Null},

						(* ... and if the solid unit weight is not known, we will parameterize and default the replicates to 10 *)
						{Automatic,Automatic,Null},{True,10},

						(* If ParameterizeSolidUnits is set to True by the user and the SolidUnitParameterizationReplicates specified by the user, we will paramtereize *)
						(* we do this no matter what the SolidUnitWeight says - a warning will have been thrown above that we parameterize although the tablet/sachet weight is known *)
						{True,RangeP[5, 20, 1],_},{specifiedParameterizeSolidUnits,specifiedSolidUnitParameterizationReplicates},

						(* If ParameterizeSolidUnits is set to True by the user and the SolidUnitParameterizationReplicates is not specified, we will paramtereize and default the replicates to 10  *)
						(* we do this no matter what the SolidUnitWeight says - a warning will have been thrown above that we parameterize although the tablet/sachet weight is known *)
						{True,Automatic,_},{specifiedParameterizeSolidUnits,10},

						(* If ParameterizeSolidUnits is set to False by the user we will not parameterize (no matter what the SolidUnitWeight or the replicates options says *)
						(* we will already have thrown an Error above if there is a conflict (if for instance no SolidUnitWeight is known or the SolidUnitParameterizationReplicates is specified *)
						{False,_,_},{specifiedParameterizeSolidUnits,Null},

						(* if ParameterizeSolidUnits is set to True by the user but the SolidUnitParameterizationReplicates is set to Null, we can't parameterize and return what was specified *)
						(* we will already have thrown a conflicting options Error above *)
						{True,Null,_},{specifiedParameterizeSolidUnits,specifiedSolidUnitParameterizationReplicates},

						(* if ParameterizeSolidUnits is set to Automatic and the SolidUnitWeight is not known,but theSolidUnitParameterizationReplicates is set to Null, we can't parameterize and return what was specified *)
						(* we will already have thrown a conflicting options Error above *)
						{Automatic,Null,GreaterEqualP[0*Gram]},{True,specifiedSolidUnitParameterizationReplicates},

						(* a catch-all for any other nonsense combination *)
						_,{False,Null}
					];

					(* resolve the MeasureTotalWeight option value *)
					measureTotalWeight=Switch[{specifiedMeasureTotalWeight,sampleMass},

						(* if MeasureTotalWeight is not specified by the user and the sample mass is known, we don't do a total weight measurement *)
						{Automatic,GreaterEqualP[0*Gram]},False,

						(* if MeasureTotalWeight is not specified by the user and the sample mass is NOT known, we do a total weight measurement *)
						{Automatic,Null},True,

						(* if the MeasureTotalWeight option is set to True by the user, we will measure the weight *)
						(* if Mass is known we will have thrown a Warning further up that this will overwrite the recorded mass *)
						{True,_},specifiedMeasureTotalWeight,

						(* if the MeasureTotalWeight option is set to False by the user, we will not measure the weight *)
						(* if Mass is not known we will have thrown an Error further up *)
						{False,_},specifiedMeasureTotalWeight,

						(* a catch-all for any other nonsense combination *)
						_,False

					];

					(* Gather MapThread results *)
					{measureTotalWeight,parameterizeSolidUnits,solidUnitParameterizationReplicates}
				]
			],
			{allSamplePackets,mapThreadFriendlyOptions}
		]
	];


	(*-- POST OPTION RESOLUTION ERROR CHECKING --*)

	(* we have no errors to throw *)

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,incompatibleContainerSamples,invalidParameterizeSolidUnitsInputs,invalidTotalWeightInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{invalidParameterizeSolidUnitsOption,invalidParameterizeOptions,requireReplicatesInvalidOptions,invalidTotalWeightOption}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION AND ALIQUOTING  --*)

	(* Note: no need for Aliquoting options nor Target containers since we're dealing with tablets or sachets. *)
	(* Note: no grouping necessary either - samples have to be done one by one, grouping not applicable *)

	(*-- CONSTRUCT THE RESOLVED OPTIONS AND TESTS OUTPUTS --*)

	(* --- pull out all the shared options from the input options --- *)
	{replicates, name, confirm, canaryBranch, template, samplesInStorageCondition, operator, parentProtocol, upload, outputOption, email, imageSample,numberOfReplicates} = Lookup[myOptions, {NumberOfReplicates,Name, Confirm, CanaryBranch, Template, SamplesInStorageCondition, Operator, ParentProtocol, Upload, Output, Email, ImageSample,NumberOfReplicates}];

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

	(* construct the final resolved options. We don't collapse here - that is happening in the main function *)
	resolvedOptions = ReplaceRule[
		measureCountOptions,
			{
				MeasureTotalWeight -> measureTotalWeightList,
				ParameterizeSolidUnits -> parameterizeSolidUnitsList,
				SolidUnitParameterizationReplicates -> solidUnitParameterizationReplicatesList,
				NumberOfReplicates -> numberOfReplicates,
				Confirm -> confirm,
				CanaryBranch -> canaryBranch,
				ImageSample -> resolvedImageSample,
				Name -> name,
				Template -> template,
				SamplesInStorageCondition -> samplesInStorageCondition,
				Cache -> inheritedCache,
				Email -> resolvedEmail,
				Operator -> operator,
				Output -> outputOption,
				ParentProtocol -> parentProtocol,
				PreparatoryUnitOperations -> Lookup[myOptions,PreparatoryUnitOperations],
				Upload -> upload
			}
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			discardedTests,
			tabletOrSachetsTests,
			incompatibleContainerTests,
			parameterizeSolidUnitsOptionInvalidTests,
			parameterizeOptionsInvalidTests,
			totalWeightNeededTests,
			massKnownTests,
			replicatesNotRequiredTests,
			parameterizationNotRequiredTests
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


(* ::Subsubsection::Closed:: *)
(* measureCountResourcePackets (private helper)*)


DefineOptions[
	measureCountResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

(* Private function to generate the list of protocol packets containing resource blobs needing for running the procedure *)
measureCountResourcePackets[mySamples:{ObjectP[Object[Sample]]...},myUnresolvedOptions:Alternatives[{_Rule..},{}],myResolvedOptions:{_Rule..},myResourcePacketOptions:OptionsPattern[measureCountResourcePackets]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,
		inheritedCache,simulation,downloadPackets,containerPackets,samplePackets,
		numReplicates,numReplicatesNoNull,samplesIn,samplesInResources,containersIn,
		parameterizeSolidUnitsBool,expandedParameterizeSolidUnitsBool,expandedResourcesNeedingParameterization,solidUnitReplicates,
		expandedSolidUnitReplicates,estimatedWeighingTime,measureTotalWeightBool,expandedMeasureTotalWeightBool,
		expandedResourcesNeedingTotalWeight,operator,protocolPacket,sharedFieldPacket,finalizedPacket,allResources,
		fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule,parameterizationQ,balance,weighboats,tweezer
  },

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureCount, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMeasureCount,
		RemoveHiddenOptions[ExperimentMeasureCount, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* get the cache that was passed from the main function *)
	inheritedCache=Lookup[ToList[myResourcePacketOptions],Cache,{}];
	simulation=Lookup[ToList[myResourcePacketOptions],Simulation];

	(* using the inherited cache, download the things we need to create our resource below *)
	downloadPackets = Download[
		mySamples,
		{
			Packet[Container],
			Packet[Container[Object]]
		},
		Cache -> inheritedCache,
		Simulation -> simulation,
		Date -> Now
	];

	samplePackets = downloadPackets[[All, 1]];
	containerPackets = downloadPackets[[All, 2]];

	(* === Make resources for SamplesIn === *)

	(* get the number of replicates so that we can expand the fields (samplesIn etc.) accordingly  *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates=Lookup[expandedResolvedOptions,NumberOfReplicates];
	numReplicatesNoNull =numReplicates /. {Null -> 1};

	(* get the SamplesIn expanded, accounting for the number of replicates *)
	samplesIn = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[samplePackets, Object]
	]];

	(* make resources for the expanded SamplesIn *)
	samplesInResources = Map[
		Resource[Sample->#, Name->ToString[Unique[]]]&,
		samplesIn
	];

	(* get the containers in from the sample's containers - these are unique lists and not expanded. *)
	(* We're not making resources of these since we're not resource-picking them, we have SamplesIn for that *)
	containersIn = DeleteDuplicates[Lookup[containerPackets,Object]];

	(* === Determine which sample resources to be parameterized (the field SolidUnitWeightParameterizations) === *)

	(* extract the ParameterizeSolidUnits option value from the resolved options *)
	parameterizeSolidUnitsBool=Lookup[expandedResolvedOptions,ParameterizeSolidUnits];

	(* expand to account for the number of experimental replicates *)
	expandedParameterizeSolidUnitsBool=Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
	parameterizeSolidUnitsBool
	]];

	(* filter the samplesIn resources for those that will get parameterized *)
	expandedResourcesNeedingParameterization=PickList[samplesInResources,expandedParameterizeSolidUnitsBool,True];

	(* also determine the parameterization replicates number *)
	solidUnitReplicates=Lookup[expandedResolvedOptions,SolidUnitParameterizationReplicates];

	(* expand to account for the number of experimental replicates - make sure to get rid of the Null's when there is no parameterization *)
	expandedSolidUnitReplicates=Flatten[
	Map[If[NullQ[#],
		Nothing,
		ConstantArray[#, numReplicatesNoNull]]&,
		solidUnitReplicates
	]];

	(* also get the estimated time we're going to be using the balance *)
	(* note that this is only the part where we are parameterizing the tablets/sachets - the TotalWeight procedure part has its own time estimates since it's a subprotocol *)
	estimatedWeighingTime=If[MatchQ[expandedResourcesNeedingParameterization,{}],
		3*Minute,
		5*Minute*Length[expandedResourcesNeedingParameterization]
	];

	(* === Determine which sample resources need to be total-weight measured (the field TotalWeightMeasurementSamples) === *)

	(* extract the MeasureTotalWeight option value from the resolved options *)
	measureTotalWeightBool=Lookup[expandedResolvedOptions,MeasureTotalWeight];

	(* expand to account for the number of experimental replicates *)
	expandedMeasureTotalWeightBool=Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
	measureTotalWeightBool
	]];

	(* filter the samplesIn resources for those that will get total-weight measured *)
	expandedResourcesNeedingTotalWeight=PickList[samplesInResources,expandedMeasureTotalWeightBool,True];

	(* === get the operator value from the resolved options *)
	operator=Lookup[expandedResolvedOptions,Operator];


	(* === figure out whether we need the balance, tweezers, and the weighboat - we'll only create those resources if we're doing parameterization === *)

	(* if ParameterizeSolidUnits is True for at least one sample we're paramterizing *)
	parameterizationQ = MemberQ[parameterizeSolidUnitsBool,True];

	(* If we are parameterizing, we need balance, tweezers, and weighboats - otherwise we can leave these empty since ExperimentMeasureWeight will take care of its own resources *)
	balance=If[parameterizationQ,
		Resource[
			Instrument->Model[Instrument,Balance,"Ohaus Pioneer PA124"],
			Time->estimatedWeighingTime
		],
		Null
	];

	(* If we're parameterizing: since we need 1 weighboat for counting out 10 tablets/sachets, and 1 for weighing the individual tablet/sachet, 'Amount' needs to be twice the amount of samples that are being parameterized *)
	weighboats = If[parameterizationQ,
		Resource[
			Sample -> Model[Item, WeighBoat, "Weigh boats, medium"],
			Amount -> 2 * Length[expandedResourcesNeedingParameterization]
		],
		Null
	];

	tweezer=If[parameterizationQ,
		Resource[Sample->Model[Item,Tweezer,"Straight flat tip tweezer"]],
		Null
	];

  (* --- Generate the protocol packet --- *)

	(* fill in the protocol packet with all the resources *)
	protocolPacket=Association[
		Type->Object[Protocol, MeasureCount],
		Object->CreateID[Object[Protocol, MeasureCount]],
		Replace[SamplesIn]-> Map[Link[#,Protocols]&,samplesInResources],
		Replace[ContainersIn]-> (Link[Resource[Sample->#],Protocols]&)/@containersIn,
		Replace[SolidUnitWeightParameterizations] -> expandedResourcesNeedingParameterization,
		Replace[SolidUnitParameterizationReplicates] -> expandedSolidUnitReplicates,
		WeighBoat -> Link[weighboats],
		Tweezer -> Link[tweezer],
		Balance-> Link[balance],
		Replace[TotalWeightMeasurementSamples]->expandedResourcesNeedingTotalWeight,
		Replace[NumberOfReplicates]->numReplicates,
    ImageSample->Lookup[resolvedOptionsNoHidden,ImageSample],
    ResolvedOptions->resolvedOptionsNoHidden,
		UnresolvedOptions->myUnresolvedOptions,
		Replace[Checkpoints]->{
			{"Picking Resources",5 Minute,"Samples required to execute this protocol are gathered from storage",
				Resource[Operator -> $BaselineOperator,Time -> 5 Minute]},
			{"Weighing Solid Units",(5*Minute*Length[expandedResourcesNeedingParameterization]+1*Minute),"The weight of a subset of the samples' tablets or sachets is determined.",
				Resource[Operator -> $BaselineOperator,Time -> (5*Minute*Length[expandedResourcesNeedingParameterization]+1*Minute)]},
			{"Weighing Samples",0 Minute,"Total weight measurements of the provided samples are made.",
				Resource[Operator -> $BaselineOperator,Time -> 0 Minute]},
			{"Parsing Data",0 Minute,"The database is updated with the weight and count information of the provided samples.",
				Null},
			{"Returning Materials",5 Minute,"Samples are returned to storage.",
				Resource[Operator -> $BaselineOperator,Time -> 5 Minute]}
		},
    Template -> Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated],
    ParentProtocol -> Link[Lookup[myResolvedOptions,ParentProtocol],Subprotocols],
    Name->Lookup[myResolvedOptions,Name]
  ];

	(* Generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[protocolPacket,sharedFieldPacket];

	(* get all the resources that we are going to create so that we can call FRQ on those *)
	allResources = DeleteDuplicates[Cases[Values[finalizedPacket], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResources, Site->Lookup[myResolvedOptions,Site], Output -> {Result, Tests}, Cache -> inheritedCache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResources, Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> inheritedCache, Simulation -> simulation], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

 	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(*generate the tests rule*)
	testsRule=Tests->If[gatherTests,
		Flatten[frqTests],
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
    protocolPacket,
		$Failed
	];

		(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsection::Closed:: *)
(*ExperimentMeasureCountOptions*)


DefineOptions[ExperimentMeasureCountOptions,
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
	SharedOptions :> {ExperimentMeasureCount}
];

ExperimentMeasureCountOptions[myInput:ListableP[ObjectP[{Object[Container]}]] | ListableP[NonSelfContainedSampleP],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for DropShipSamples *)
	options = ExperimentMeasureCount[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureCount],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureCountPreview*)


DefineOptions[ExperimentMeasureCountPreview,
	SharedOptions :> {ExperimentMeasureCount}
];

ExperimentMeasureCountPreview[myInput:ListableP[ObjectP[{Object[Container]}]] | ListableP[NonSelfContainedSampleP],myOptions:OptionsPattern[ExperimentMeasureCount]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentMeasureCount[myInput,Append[noOutputOptions,Output->Preview]];
];



(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureCountQ*)


DefineOptions[ValidExperimentMeasureCountQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions :> {ExperimentMeasureCount}
];

ValidExperimentMeasureCountQ[myInput:ListableP[ObjectP[{Object[Container]}]] | ListableP[NonSelfContainedSampleP],myOptions:OptionsPattern[ValidExperimentMeasureCountQ]]:=Module[
	{listedOptions, listedInput, oOutputOptions, preparedOptions, measureCountTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasureCount *)
	measureCountTests = ExperimentMeasureCount[myInput, Append[preparedOptions, Output -> Tests]];

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
			Flatten[{initialTest, measureCountTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureCountQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureCountQ"]


];
