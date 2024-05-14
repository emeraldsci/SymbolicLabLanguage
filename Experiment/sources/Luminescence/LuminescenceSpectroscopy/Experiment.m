(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Luminescence Spectroscopy*)


(* ::Subsubsection:: *)
(*ExperimentLuminescenceSpectroscopy*)


DefineOptions[ExperimentLuminescenceSpectroscopy,
	Options:>{
		LuminescenceOptions,
		{
			OptionName->EmissionWavelengthRange,
			Default->350 Nanometer;;740 Nanometer,
			AllowNull->False,
			Widget->Span[
				Widget[Type->Quantity,Pattern:>RangeP[350 Nanometer,740 Nanometer],Units:>Nanometer],
				Widget[Type->Quantity,Pattern:>RangeP[350 Nanometer,740 Nanometer],Units:>Nanometer]
			],
			Description->"Defines the wavelengths at which luminescence emitted from the sample should be measured.",
			ResolutionDescription->"Uses the entire wavelength range available to the specified plate reader.",
			Category->"Optics"
		},
		{
			OptionName->AdjustmentEmissionWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Description->"The wavelength at which luminescence should be read in order to perform automatic adjustments of gain and focal height values.",
			ResolutionDescription->"Uses the wavelength in the middle of the requested emission wavelength range if the gain is not being set directly.",
			Category->"Optics"
		},
		(* Here Gain is not index matching *)
		{
			OptionName->Gain,
			Default->Automatic,
			Description->"The gain which should be applied to the signal reaching the primary detector. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample intensity is at the specified percentage of the instrument's dynamic range).",
			ResolutionDescription->"Defaults to 90% if AdjustmentSamples is set or if using Model[Instrument,PlateReader,\"CLARIOstar\"] or Model[Instrument,PlateReader,\"PHERAstar FS\"] which can scan the entire plate and thus don't require an AdjustmentSample to set the gain. Otherwise defaults to 2500 Microvolt.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt]
			],
			Category->"Optics"
		},
		{
			OptionName->AdjustmentSample,
			Default->Automatic,
			Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the AdjustmentSample. The gain will be set such that the AdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments. When set to FullPlate, all wells of the assay plate are scanned and the well of the highest fluorescence intensity if perform gain and focal height adjustments.",
			ResolutionDescription->"Defaults to FullPlate when using an instrument capable of scanning the full plate during gain adjustments (Model[Instrument,PlateReader,\"CLARIOstar\"] or Model[Instrument,PlateReader,\"PHERAstar FS\"]). Otherwise the sample with the highest concentration will be used.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[FullPlate]],
				Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]],
				{
					"Index"->Widget[Type->Number,Pattern:>RangeP[1,384,1]],
					"Sample"->Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]
				}
			],
			Category->"Optics"
		},
		{
			OptionName->FocalHeight,
			Default->Automatic,
			Description->"The distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector. If set to Auto the height which corresponds to the highest AdjustmentSample signal will be used.",
			ResolutionDescription->"If an adjustment sample is provided the height which corresponds to the highest AdjustmentSample signal will be used (as indicated by Auto). Otherwise defaults to 7 Millimeter.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Millimeter,25 Millimeter],Units:>Millimeter],
				Widget[Type->Enumeration,Pattern:>Alternatives[Auto]]
			],
			Category->"Optics"
		}
	}
];

ExperimentLuminescenceSpectroscopy[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
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
			ExperimentLuminescenceSpectroscopy,
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
			ExperimentLuminescenceSpectroscopy,
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
				ExperimentLuminescenceSpectroscopy,
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
		ExperimentLuminescenceSpectroscopy[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];


ExperimentLuminescenceSpectroscopy[mySamples:ListableP[ObjectP[{Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[{
	listedSamples,listedOptions,outputSpecification,output,gatherTestsQ,messagesBoolean,validSamplePreparationResult,
	mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation,safeOptions,safeOptionsNamed,safeOptionTests,
	validLengthsQ,validLengthTests,templateOptions,templateOptionsTests,inheritedOptions,expandedSafeOps,
	downloadedPackets,sampleObjects,upload,confirm,fastTrack,parentProt,cache,newCache,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,protocolObject,
	returnEarlyQ,performSimulationQ,simulatedProtocol,simulation,estimatedRunTime
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
			ExperimentLuminescenceSpectroscopy,
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
		SafeOptions[ExperimentLuminescenceSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentLuminescenceSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	{mySamplesWithPreparedSamples,safeOptions,myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed];

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
			ValidInputLengthsQ[ExperimentLuminescenceSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
			{ValidInputLengthsQ[ExperimentLuminescenceSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentLuminescenceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentLuminescenceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> Result], Null}
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
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentLuminescenceSpectroscopy,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Yell about Confirm->True Upload->False; since UploadProtocolStatus cannot access resources until after upload *)
	(* Safe to return Failed here since Upload is not a user facing option *)
	If[MatchQ[upload,False]&&TrueQ[confirm],
		Message[Error::ConfirmUploadConflict];
		Return[$Failed]
	];

	(* --- Assemble Download --- *)
	downloadedPackets=plateReaderExperimentDownload[Object[Protocol,LuminescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,cache,samplePreparationSimulation];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	sampleObjects=Lookup[fetchPacketFromCache[#,downloadedPackets],Object]&/@mySamplesWithPreparedSamples;

	newCache=FlattenCachePackets[{cache,downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTestsQ,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolvePlateReaderOptions[Object[Protocol,LuminescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolvePlateReaderOptions[Object[Protocol,LuminescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentLuminescenceSpectroscopy,
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
			Options -> RemoveHiddenOptions[ExperimentLuminescenceSpectroscopy,collapsedResolvedOptions],
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
			plateReaderResourcePackets[Object[Protocol,LuminescenceSpectroscopy],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True,
			{plateReaderResourcePackets[Object[Protocol,LuminescenceSpectroscopy],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, LuminescenceSpectroscopy],
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
			Options -> RemoveHiddenOptions[ExperimentLuminescenceSpectroscopy,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> estimatedRunTime
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
			primitive=LuminescenceSpectroscopy@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[LuminescenceSpectroscopy,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentLuminescenceSpectroscopy,collapsedResolvedOptions];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentLuminescenceSpectroscopy so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentLuminescenceSpectroscopy, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentLuminescenceSpectroscopy]={};

				ExperimentLuminescenceSpectroscopy[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
			ConstellationMessage->Object[Protocol,LuminescenceSpectroscopy],
			Cache -> newCache,
			Simulation -> samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentLuminescenceSpectroscopy,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];
