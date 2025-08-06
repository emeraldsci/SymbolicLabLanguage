(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Polarization Kinetics*)


(* ::Subsubsection::Closed:: *)
(*ExperimentFluorescencePolarizationKinetics*)


DefineOptions[ExperimentFluorescencePolarizationKinetics,
	Options:>{
		IndexMatching[
			{
				OptionName->ExcitationWavelength,
				Default->Automatic,
				Description->"The wavelength(s) which should be used to excite fluorescence in the samples.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Category -> "Optics"
			},
			{
				OptionName->EmissionWavelength,
				Default->Automatic,
				Description->"The wavelength(s) at which fluorescence emitted from the sample should be measured.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Category -> "Optics"
			},
			{
				OptionName->DualEmissionWavelength,
				Default->Automatic,
				Description->"The wavelength at which fluorescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Category -> "Optics"
			},
			{
				OptionName->Gain,
				Default->Automatic,
				Description->"The gain which should be applied to the signal reaching the primary detector. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
				ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
					Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
				]
			},
			{
				OptionName->DualEmissionGain,
				Default->Automatic,
				Description->"The gain to apply to the signal reaching the secondary detector. This may be specified either as a direct voltage, or as a percentage relative to the AdjustmentSample option.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
					Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
				]
			},
			{
				OptionName->AdjustmentSample,
				Default->Automatic,
				Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the AdjustmentSample. The gain will be set such that the AdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments.",
				AllowNull->True,
				Widget->Alternatives[
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
			},
			IndexMatchingParent->ExcitationWavelength
		],
		{
			OptionName->TargetPolarization,
			Default->Automatic,
			Description->"The target polarization value  which should be used to perform automatic adjustments of gain and/or focal height values at run time on the chosen adjustment sample.",
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:>RangeP[0 PolarizationUnit Milli, 500 PolarizationUnit Milli], Units:>PolarizationUnit Milli]
		},
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"The plate reader used to measure fluorescence intensity.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateReader],Object[Instrument,PlateReader]}]],
			Category -> "Optics"
		},
		{
			OptionName->RetainCover,
			Default->False,
			Description->"Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->MoatSize,
			Default->Automatic,
			Description->"Indicates the number of concentric perimeters of wells which should be should be filled with MoatBuffer in order to decrease evaporation from the assay samples during the run.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
			Category->"Sample Handling"
		},
		{
			OptionName->MoatVolume,
			Default->Automatic,
			Description->"Indicates the volume which should be added to each moat well.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
		},
		{
			OptionName->MoatBuffer,
			Default->Automatic,
			Description->"Indicates the buffer which should be used to fill each moat well.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Handling"
		},
		FluorescenceBaseOptions,
		NonBiologyFuntopiaSharedOptions,
		(* Overwrite ConsolidateAliquots pattern since it can never be set to True since we will never read the same well multiple times *)
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[False]]
		},
		AnalyticalNumberOfReplicatesOption,
		{
			OptionName->RunTime,
			Default->45 Minute,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			AllowNull->False,
			Description->"The length of time over which fluorescence measurements should be made."
		},
		{
			OptionName->ReadOrder,
			Default->Parallel,
			Description->"Indicates if all measurements and injections should be done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>ReadOrderP]
		},
		{
			OptionName->PlateReaderMixSchedule,
			Default->Automatic,
			Description-> "Indicates the points at which mixing should occur in the plate reader.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>MixingScheduleP]
		},
		AdditionalInjectionsOptions,
		{
			OptionName->PrimaryInjectionTime,
			Default->Null,
			Description->"The time at which the first round of injections should start.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
		},
		{
			OptionName->SecondaryInjectionTime,
			Default->Null,
			Description->"The time at which the second round of injections should start.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
		},
		{
			OptionName->TertiaryInjectionTime,
			Default->Null,
			Description->"The time at which the third round of injections should start.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
		},
		{
			OptionName->QuaternaryInjectionTime,
			Default->Null,
			Description->"The time at which the fourth round of injections should start.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
		},
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 200 Microliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Plate, \"96-well UV-Star Plate\"]."
			}
		]
	}
];


ExperimentFluorescencePolarizationKinetics[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,
		samples,sampleOptions,containerToSampleTests,validSamplePreparationResult,mySamplesWithPreparedSamples,containerToSampleSimulation,
		myOptionsWithPreparedSamples,samplePreparationSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* convert inoput into links *)
	{listedContainers,listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentFluorescencePolarizationKinetics,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 200 Microliter,
			DefaultPreparedModelContainer -> Model[Container, Plate, "96-well UV-Star Plate"]
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
			ExperimentFluorescencePolarizationKinetics,
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
				ExperimentFluorescencePolarizationKinetics,
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
		ExperimentFluorescencePolarizationKinetics[samples,ReplaceRule[sampleOptions, {Cache -> Lookup[listedOptions, Cache, {}], Simulation -> containerToSampleSimulation}]]
	]
];


ExperimentFluorescencePolarizationKinetics[mySamples:ListableP[ObjectP[{Object[Sample]}]],myOptions:OptionsPattern[]]:=Module[{
	listedSamples,listedOptions,outputSpecification,output,gatherTestsQ,messagesBoolean,validSamplePreparationResult,
	upload, confirm, canaryBranch, fastTrack, parentProt, estimatedRunTime,
	mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOptionsNamed,
	mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation,safeOptions,safeOptionTests,
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
			ExperimentFluorescenceKinetics,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
		SafeOptions[ExperimentFluorescencePolarizationKinetics,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFluorescencePolarizationKinetics,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	{mySamplesWithPreparedSamples,safeOptions,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed,Simulation->samplePreparationSimulation];

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
			ValidInputLengthsQ[ExperimentFluorescencePolarizationKinetics,{mySamplesWithPreparedSamples},safeOptions,Output->{Result,Tests}],
			{ValidInputLengthsQ[ExperimentFluorescencePolarizationKinetics,{mySamplesWithPreparedSamples},safeOptions],Null}
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
	{upload, confirm, canaryBranch, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options - no need to specify the definition number since we only have samples defined as input *)
	{templateOptions, templateOptionsTests} = If[gatherTestsQ,
		ApplyTemplateOptions[ExperimentFluorescencePolarizationKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFluorescencePolarizationKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> Result], Null}
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
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentFluorescencePolarizationKinetics,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Yell about Confirm->True Upload->False; since UploadProtocolStatus cannot access resources until after upload *)
	(* Safe to return Failed here since Upload is not a user facing option *)
	If[MatchQ[upload,False]&&TrueQ[confirm],
		Message[Error::ConfirmUploadConflict];
		Return[$Failed]
	];

	(* --- Assemble Download --- *)
	downloadedPackets=plateReaderExperimentDownload[Object[Protocol,FluorescencePolarizationKinetics],mySamplesWithPreparedSamples,expandedSafeOps,cache,samplePreparationSimulation];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	sampleObjects=Lookup[fetchPacketFromCache[#,downloadedPackets],Object]&/@mySamplesWithPreparedSamples;

	newCache=FlattenCachePackets[{cache,downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTestsQ,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolvePlateReaderOptions[Object[Protocol,FluorescencePolarizationKinetics],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolvePlateReaderOptions[Object[Protocol,FluorescencePolarizationKinetics],mySamplesWithPreparedSamples,expandedSafeOps,Cache->newCache,Simulation->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentFluorescencePolarizationKinetics,
		resolvedOptions,
		Ignore->ToList[myOptions],
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
			Options -> RemoveHiddenOptions[ExperimentFluorescencePolarizationKinetics,collapsedResolvedOptions],
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
			plateReaderResourcePackets[Object[Protocol,FluorescencePolarizationKinetics],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True,
			{plateReaderResourcePackets[Object[Protocol,FluorescencePolarizationKinetics],sampleObjects,templateOptions,resolvedOptions,Cache->newCache,Simulation->samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, FluorescencePolarizationKinetics],
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
		(Lookup[resolvedOptions,RunTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentFluorescencePolarizationKinetics,collapsedResolvedOptions],
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
			primitive=FluorescencePolarizationKinetics@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[FluorescencePolarizationKinetics,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentFluorescencePolarizationKinetics,collapsedResolvedOptions];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentFluorescencePolarizationKinetics so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentFluorescencePolarizationKinetics, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentFluorescencePolarizationKinetics]={};

				ExperimentFluorescencePolarizationKinetics[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
					CanaryBranch->Lookup[safeOptions,CanaryBranch],
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
			CanaryBranch->Lookup[safeOptions,CanaryBranch],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,FluorescencePolarizationKinetics],
			Cache -> newCache,
			Simulation -> samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateOptionsTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentFluorescencePolarizationKinetics,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];
