(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


DefineOptions[ExperimentLuminescenceIntensity,
	Options:>{LuminescenceIntensityAndKineticsOptions}
];


(* ::Subsubsection:: *)
(*ExperimentLuminescenceIntensity*)


ExperimentLuminescenceIntensity[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,
		samples,sampleOptions,containerToSampleTests,validSamplePreparationResult,mySamplesWithPreparedSamples,containerToSampleSimulation,
		myOptionsWithPreparedSamples,samplePreparationSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and throw warnings *)
	{listedContainers,listedOptions}=removeLinks[ToList[myContainers],ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentLuminescenceIntensity,
			listedContainers,
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentLuminescenceIntensity,
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
				ExperimentLuminescenceIntensity,
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
		ExperimentLuminescenceIntensity[samples,ReplaceRule[sampleOptions,{Cache->Lookup[listedOptions,Cache,{}],Simulation->containerToSampleSimulation}]]
	]
];


ExperimentLuminescenceIntensity[mySamples:ListableP[ObjectP[{Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[{
	listedSamples,listedOptions,outputSpecification,output,gatherTestsQ,messagesBoolean,validSamplePreparationResult,
	mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOptionsNamed,
	mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation,safeOptions,safeOptionTests,
	upload, confirm, fastTrack, parentProt, estimatedRunTime,
	validLengthsQ,validLengthTests,templateOptions,templateOptionsTests,inheritedOptions,expandedSafeOps,
	downloadedPackets,sampleObjects,cache,newCache,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,protocolObject,
	returnEarlyQ,performSimulationQ,simulatedProtocol,simulation
},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output,Tests];
	messagesBoolean=!gatherTestsQ;

	(* Remove temporal links and throw warnings *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentLuminescenceIntensity,
			listedSamples,
			listedOptions
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

	(* --- Downloading Required Information --- *)

	(* Default any unspecified or incorrectly-specified options; assign re-used values to local variables *)
	{safeOptionsNamed,safeOptionTests}=If[gatherTestsQ,
		SafeOptions[ExperimentLuminescenceIntensity,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentLuminescenceIntensity,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	{mySamplesWithPreparedSamples,safeOptions,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	{validLengthsQ,validLengthTests} = Quiet[
		If[gatherTestsQ,
			ValidInputLengthsQ[ExperimentLuminescenceIntensity,{mySamplesWithPreparedSamples},safeOptions,Output->{Result,Tests}],
			{ValidInputLengthsQ[ExperimentLuminescenceIntensity,{mySamplesWithPreparedSamples},safeOptions],Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengthsQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* apply the template options - no need to specify the definition number since we only have samples defined as input *)
	{templateOptions, templateOptionsTests} = If[gatherTestsQ,
		ApplyTemplateOptions[ExperimentLuminescenceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentLuminescenceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> Result], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templateOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,templateOptionsTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the two sets of options (the ones specified and the ones from the template protocol) *)
	inheritedOptions=ReplaceRule[safeOptions,templateOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentLuminescenceIntensity,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Yell about Confirm->True Upload->False; since UploadProtocolStatus cannot access resources until after upload *)
	(* Safe to return Failed here since Upload is not a user facing option *)
	If[MatchQ[upload,False]&&TrueQ[confirm],
		Message[Error::ConfirmUploadConflict];
		Return[$Failed]
	];

	(* --- Assemble Download --- *)
	downloadedPackets=plateReaderExperimentDownload[Object[Protocol,LuminescenceIntensity],mySamplesWithPreparedSamples,expandedSafeOps,cache,samplePreparationSimulation];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	sampleObjects=Lookup[fetchPacketFromCache[#,downloadedPackets],Object]&/@mySamplesWithPreparedSamples;

	newCache=FlattenCachePackets[{cache,downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTestsQ,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolvePlateReaderOptions[Object[Protocol,LuminescenceIntensity],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolvePlateReaderOptions[Object[Protocol,LuminescenceIntensity],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentLuminescenceIntensity,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTestsQ, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP] || MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> RemoveHiddenOptions[ExperimentLuminescenceIntensity,collapsedResolvedOptions],
			Preview -> Null,
			Tests -> Join[safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests],
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{$Failed,{}},
		gatherTestsQ,
			plateReaderResourcePackets[Object[Protocol,LuminescenceIntensity],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True,
			{plateReaderResourcePackets[Object[Protocol,LuminescenceIntensity],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, LuminescenceIntensity],
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
			Cache->newCache,
			Simulation->samplePreparationSimulation
		],
		{Null, Null}
	];

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentLuminescenceIntensity,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[

		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, return $Failed *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic]&&MatchQ[upload,False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic],
		Module[{primitive, nonHiddenOptions,experimentFunction},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive=LuminescenceIntensity@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[LuminescenceIntensity,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentLuminescenceIntensity,collapsedResolvedOptions];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentLuminescenceIntensity so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentLuminescenceIntensity, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentLuminescenceIntensity]={};

				ExperimentLuminescenceIntensity[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification=Lookup[ToList[options], Output];

					frameworkOutputSpecification/.{
						Result -> resourcePackets[[2]],
						Options -> nonHiddenOptions,
						Preview -> Null,
						Simulation -> simulation,
						RunTime -> estimatedRunTime
					}
				];

				experimentFunction[
					{primitive},
					Name->Lookup[safeOptions,Name],
					Upload->Lookup[safeOptions,Upload],
					Confirm->Lookup[safeOptions,Confirm],
					ParentProtocol->Lookup[safeOptions,ParentProtocol],
					Priority->Lookup[safeOptions,Priority],
					StartDate->Lookup[safeOptions,StartDate],
					HoldOrder->Lookup[safeOptions,HoldOrder],
					QueuePosition->Lookup[safeOptions,QueuePosition],
					Cache->newCache
				]
			]
		],

		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			Upload->Lookup[safeOptions,Upload],
			Confirm->Lookup[safeOptions,Confirm],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,LuminescenceIntensity],
			Cache -> newCache,
			Simulation -> samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentLuminescenceIntensity,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];
