(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Fluorescence Spectroscopy*)


(* ::Subsubsection::Closed:: *)
(*ExperimentFluorescenceSpectroscopy*)


DefineOptions[ExperimentFluorescenceSpectroscopy,
	Options:>{
		FluorescenceOptions,
		{
			OptionName->Instrument,
			Default->Model[Instrument,PlateReader,"CLARIOstar"],
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateReader],Object[Instrument,PlateReader]}]],
			Description->"The plate reader used to measure fluorescence intensity.",
			Category -> "Spectral Scanning"
		},
		{
			OptionName->SpectralScan,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>FluorescenceScanTypeP]],
				Widget[Type->Enumeration,Pattern:>FluorescenceScanTypeP]
			],
			Description->"Indicates if fluorescence should be recorded using a fixed excitation wavelength and a range of emission wavelengths (Emission) or using a fixed emission wavelength and a range of excitation wavelengths (Excitation). Specify Emission and Excitation to record both spectra.",
			ResolutionDescription->"If unspecified uses the emission spectrum if EmissionWavelengthRange is specified and/or the excitation spectrum if ExcitationWavelengthRange is specified, defaulting to measure both spectrum if all options are left Automatic.",
			Category->"Optics"
		},
		{
			OptionName->ExcitationWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Description->"The wavelength which should be used to excite fluorescence in the samples. Fluorescence will then be measured over 'EmissionWavelengthRange'.",
			ResolutionDescription->"If unspecified uses the wavelength 50 Nanometer below the smallest requested emission wavelength.",
			Category->"Optics"
		},
		{
			OptionName->EmissionWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Description->"The wavelength at which fluorescence emitted from the sample should be measured after the sample has been excited by each wavelength in 'ExcitationWavelengthRange'.",
			ResolutionDescription->"If unspecified uses the wavelength 50 Nanometer above the largest requested excitation wavelength.",
			Category->"Optics"
		},
		{
			OptionName->ExcitationWavelengthRange,
			Default->Automatic,
			AllowNull->True,
			Widget->Span[
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
			],
			Description->"Defines the wavelengths which should be used to excite fluorescence in the samples. Fluorescence will then be measured at 'EmissionWavelength'.",
			ResolutionDescription->"If unspecified uses the largest possible range of excitation wavelengths with the constraints that the range must be within the instrument operating limits and below the emission wavelength.",
			Category->"Optics"
		},
		{
			OptionName->EmissionWavelengthRange,
			Default->Automatic,
			AllowNull->True,
			Widget->Span[
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
			],
			Description->"Defines the wavelengths at which fluorescence emitted from the sample should be measured after the sample has been excited by 'ExcitationWavelength'.",
			ResolutionDescription->"If unspecified uses the largest possible range of emission wavelengths with the constraints that the range must be within the instrument operating limits and above the excitation wavelength.",
			Category->"Optics"
		},
		{
			OptionName->ExcitationScanGain,
			Default->Automatic,
			Description->"The gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
			ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt]
			]
		},
		{
			OptionName->EmissionScanGain,
			Default->Automatic,
			Description->"The gain which should be applied to the signal reaching the primary detector during the emission scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
			ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt]
			]
		},
		{
			OptionName->AdjustmentEmissionWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Description->"The wavelength at which fluorescence should be read in order to perform automatic adjustments of gain and focal height values at run time.",
			ResolutionDescription->"If unspecified uses the wavelength in the middle of the requested emission wavelength range if the gain is not being set directly.",
			Category->"Spectral Scanning"
		},
		{
			OptionName->AdjustmentExcitationWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Description->"The wavelength at which the sample should be excited in order to perform automatic adjustments of gain and focal height values at run time.",
			ResolutionDescription->"If unspecified uses the wavelength in the middle of the requested excitation wavelength range if the gain is not being set directly.",
			Category->"Spectral Scanning"
		},
		{
			OptionName->AdjustmentSample,
			Default->Automatic,
			Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the AdjustmentSample. The gain will be set such that the AdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments. When set to FullPlate, all wells of the assay plate are scanned and the well of the highest fluorescence intensity if perform gain and focal height adjustments.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[FullPlate]],
				Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]],
				{
					"Index"->Widget[Type->Number,Pattern:>RangeP[1,384,1]],
					"Sample"->Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]
				}
			]
		},
		{
			OptionName->FocalHeight,
			Default->Automatic,
			Description->"The distance from the bottom of the plate carrier to the focal point. If set to Automatic, the focal height will be adjusted based on the Gain adjustment, which will occur only if the gain values are set to percentages.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Millimeter,25 Millimeter],Units:>Millimeter],
				Widget[Type->Enumeration,Pattern:>Alternatives[Auto]]
			]
		}
	}
];


ExperimentFluorescenceSpectroscopy[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
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
			ExperimentFluorescenceSpectroscopy,
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
			ExperimentFluorescenceSpectroscopy,
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
				ExperimentFluorescenceSpectroscopy,
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
		ExperimentFluorescenceSpectroscopy[samples,ReplaceRule[sampleOptions,{Cache->Lookup[listedOptions,Cache,{}],Simulation->containerToSampleSimulation}]]
	]
];


ExperimentFluorescenceSpectroscopy[mySamples:ListableP[ObjectP[{Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[{
	listedSamples,listedOptions,outputSpecification,output,gatherTestsQ,messagesBoolean,safeOptions,safeOptionTests,
	upload, confirm, fastTrack, parentProt, estimatedRunTime,
	mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, safeOptionsNamed,
	validLengthsQ,validLengthTests,templateOptions,templateOptionsTests,inheritedOptions,expandedSafeOps,
	downloadedPackets,sampleObjects,cache,newCache,resolvedOptionsResult,resolvedOptions,
	resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,protocolObject,
	validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation,
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
			ExperimentFluorescenceSpectroscopy,
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
		SafeOptions[ExperimentFluorescenceSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFluorescenceSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	(* Sanitize Inputs *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed];

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
			ValidInputLengthsQ[ExperimentFluorescenceSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamplesNamed,Output->{Result,Tests}],
			{ValidInputLengthsQ[ExperimentFluorescenceSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamplesNamed],Null}
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
		ApplyTemplateOptions[ExperimentFluorescenceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFluorescenceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> Result], Null}
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
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentFluorescenceSpectroscopy,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Yell about Confirm->True Upload->False; since UploadProtocolStatus cannot access resources until after upload *)
	(* Safe to return Failed here since Upload is not a user facing option *)
	If[MatchQ[Lookup[expandedSafeOps,Upload],False]&&TrueQ[Lookup[expandedSafeOps,Confirm]],
		Message[Experiment::ConfirmUploadConflict];
		Return[$Failed]
	];

	(* --- Assemble Download --- *)
	downloadedPackets=plateReaderExperimentDownload[Object[Protocol,FluorescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,cache,samplePreparationSimulation];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	sampleObjects=Lookup[fetchPacketFromCache[#,downloadedPackets],Object]&/@mySamplesWithPreparedSamples;

	newCache=FlattenCachePackets[{cache,downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTestsQ,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolvePlateReaderOptions[Object[Protocol,FluorescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolvePlateReaderOptions[Object[Protocol,FluorescenceSpectroscopy],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentFluorescenceSpectroscopy,
		resolvedOptions,
		Ignore->ToList[myOptionsWithPreparedSamples],
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP] || MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> RemoveHiddenOptions[ExperimentFluorescenceSpectroscopy,collapsedResolvedOptions],
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
			plateReaderResourcePackets[Object[Protocol,FluorescenceSpectroscopy],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True,
			{plateReaderResourcePackets[Object[Protocol,FluorescenceSpectroscopy],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, FluorescenceSpectroscopy],
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
			Options -> RemoveHiddenOptions[ExperimentFluorescenceSpectroscopy,collapsedResolvedOptions],
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
			primitive=FluorescenceSpectroscopy@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[FluorescenceSpectroscopy,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentFluorescenceSpectroscopy,collapsedResolvedOptions];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentFluorescenceSpectroscopy so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentFluorescenceSpectroscopy, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentFluorescenceSpectroscopy]={};

				ExperimentFluorescenceSpectroscopy[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
			ConstellationMessage->Object[Protocol,FluorescenceSpectroscopy],
			Cache -> newCache,
			Simulation -> samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentFluorescenceSpectroscopy,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];
