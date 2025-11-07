(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Uncover*)

(* ::Subsubsection:: *)
(*ExperimentUncover Options*)


DefineOptions[ExperimentUncover,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the sample which is uncovered, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				]
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the container of the sample which is uncovered, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				]
			},
			{
				OptionName -> DiscardCover,
				Default -> Automatic,
				Description -> "Indicates if the cover is discarded after it's taken off of the container.",
				ResolutionDescription -> "Automatically set based on the Reusable field of the cover and the UncappedTime. All caps that are not Reusable will always be discarded. Reusable caps will be discarded if the UncappedTime is greater than 15 minutes so that fresh caps can be applied after processing.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			{
				OptionName -> UncappedTime,
				Default -> 5 Minute,
				Description -> "Indicates the length of time the cover is expected to be off the container after it is removed.",
				AllowNull -> False,
				Category -> "Hidden",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxExperimentTime],
					Units->Minute
				]
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				Description -> "The device used to remove the cover from the top of the container.",
				ResolutionDescription -> "Automatically set to a Model[Instrument, Crimper] that has the same CoverFootprint as Cover, if using a crimped cover. Automatically set to Model[Part, CapPrier] if CoverType->Pry. Otherwise, set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument, Crimper],
						Object[Instrument, Crimper],
						Model[Part, CapPrier],
						Object[Part, CapPrier],
						Model[Part, Decrimper],
						Object[Part, Decrimper],
						Model[Part, AmpouleOpener],
						Object[Part, AmpouleOpener]
					}]
				]
			},
			{
				OptionName -> DecrimpingHead,
				Default -> Automatic,
				Description -> "Used in conjunction with a Model[Instrument, Crimper] to remove the crimped cap from the covered container. Note that this is not used if using a handheld Model[Part, Decrimper].",
				ResolutionDescription -> "Automatically set to a Model[Part, DecrimpingHead] that has the same CoverFootprint as the Cover, if the Cover is a Model[Item, Cap] with CoverType->Crimp, and if not using a manual decrimper.",
				AllowNull -> True,
				Category -> "General",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Part, DecrimpingHead],
						Object[Part, DecrimpingHead]
					}]
				]
			},
			{
				OptionName -> CrimpingPressure,
				Default -> Automatic,
				Description -> "The pressure of the gas that is connected to the pneumatic Model[Instrument, Crimper] that determines the strength used to crimp or decrimp the crimped cap. Note that this is not used if using a handheld Model[Part, Decrimper].",
				ResolutionDescription -> "Automatically set to the CrimpingPressure field in the Model[Item, Cap] if CoverType->Crimp. If this field is empty, set to 35 PSI. Otherwise, if CoverType is not Crimp, set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 PSI, 90 PSI],
					Units->PSI
				]
			},
			{
				OptionName->Environment,
				Default->Automatic,
				ResolutionDescription -> "Automatically set to the specific BSC, fume hood, glove box, or bench that the sample is currently on (if applicable). Otherwise, if SterileTechnique->True, this option will be set to a BSC. Otherwise, defaults to a fume hood.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument],
						Model[Container, Bench],
						Model[Container, OperatorCart],

						Object[Instrument],
						Object[Container, Bench],
						Object[Container, OperatorCart]
					}],
					PreparedContainer->False
				],
				Description->"The environment in which the covering should be performed (Biosafety Cabinet, Fume Hood, Glove Box, or Bench). This option will be set to Null when Preparation->Robotic (the covering will be performed inside of the Liquid Handler enclosure).",
				Category->"General"
			},
			ModifyOptions[
				SterileTechniqueOption,
				Category->"General"
			]
		],
		(*===Shared Options===*)
		PreparationOption,
		ProtocolOptions,
		NonBiologyPostProcessingOptions,
		SimulationOption,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentUncover Source Code *)

(* Procedure writers should not ask to uncap on instruments where container is not accessible - solution is to move Uncover task *)
(* WARNING: If updating this probably need to update the field patterns in Cover, Uncover protocol and unit operation objects *)
(* CapRacks will be placed directly on the surfaces here *)
(* Don't include carts here since we don't want to uncover on a cart that doesn't match our ActiveCart, which we will default to *)
$CoverEnvironmentTypes := {
	Object[Instrument, HandlingStation],
	Object[Instrument, GloveBox],
	Object[Instrument, FumeHood],
	Object[Instrument, BiosafetyCabinet],
	Object[Container, Bench]
};



(*ExperimentUncover*)

(* NOTE: No Container to Sample overload since we have to be able to cover/uncover empty containers. *)
(* NOTE: Internal to the experiment function, we actually convert samples into containers since we care about the container, not the sample. *)

(* -- Main Overload --*)
ExperimentUncover[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],myOptions:OptionsPattern[]]:=Module[
	{
		cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
		listedInputs, messages, myOptionsWithPreparedSamples, myOptionsWithPreparedSamplesNamed, myInputsWithPreparedSamples,
		myInputsWithPreparedSamplesNamed, output, outputSpecification, coverCache, performSimulationQ,
		protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
		safeOps, safeOpsNamed, safeOpsTests, templatedOptions, templateTests, resolvedPreparation,
		samplePreparationSimulation, validLengths, validLengthTests, validSamplePreparationResult, simulatedProtocol, simulation,
		listedContainers, objectContainerFields, objectContainerPacketFields, modelContainerFields, objectSampleFields,
		modelSampleFields, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links *)
	{listedInputs, listedOptions}=removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentUncover,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentUncover,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentUncover,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{myInputsWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[myInputsWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentUncover,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentUncover,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentUncover,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentUncover,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentUncover,{ToList[myInputsWithPreparedSamples]},inheritedOptions]];

	(* Fetch the cache from expandedSafeOps *)
	cache=ToList[Lookup[expandedSafeOps, Cache, {}]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Normalize our inputs all into containers. This is because Uncover cares about the container, not about the sample. *)
	listedContainers=If[Length[Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]]]>0,
		Module[{samplePackets},
			(* Get the packets of any sample inputs we have. *)
			samplePackets=Download[
				Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]],
				Packet[Container],
				Simulation->samplePreparationSimulation
			];

			(* Replace samples with their container. *)
			myInputsWithPreparedSamples/.Rule@@@Transpose[{ObjectP/@Lookup[samplePackets, Object], Download[Lookup[samplePackets, Container], Object]}]
		],
		myInputsWithPreparedSamples
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	objectContainerFields=DeleteDuplicates[Flatten[{Cover,Septum,SamplePreparationCacheFields[Object[Container]], Name}]];
	objectContainerPacketFields=Packet@@objectContainerFields;
	modelContainerFields=Join[SamplePreparationCacheFields[Model[Container]],{CoverFootprints, CoverTypes}];
	objectSampleFields=Join[SamplePreparationCacheFields[Object[Sample]],{Pungent, Ventilated, Name}];
	modelSampleFields=SamplePreparationCacheFields[Model[Sample]];

	coverCache=Flatten@Quiet[
		Download[
			{
				listedContainers,
				listedContainers,
				listedContainers,
				listedContainers,
				listedContainers,
				Cases[ToList[myOptions], ObjectP[Object[Part, DecrimpingHead]], Infinity],
				ToList@Lookup[safeOps,ParentProtocol]
			},
			{
				List@objectContainerPacketFields,
				List@Packet[Model[modelContainerFields]],
				List@Packet[Contents[[All,2]][objectSampleFields]],
				List@Packet[Contents[[All,2]][Model][modelSampleFields]],
				{Packet[Cover[{Model, Reusable, Name}]], Packet[Cover[Model][{Name, Reusable, CleaningMethod, CoverType, Barcode, CrimpingPressure, Products, CoverFootprint}]]},
				List@Packet[Model[{CoverFootprint, Name}]],
				{Packet[ActiveCart]}
			},
			Cache->cache,
			Simulation->samplePreparationSimulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Combine our downloaded and passed cache. *)
	cacheBall=FlattenCachePackets[{cache,coverCache}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentUncoverOptions[
			listedInputs,
			listedContainers,
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->samplePreparationSimulation,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={
				resolveExperimentUncoverOptions[
					listedInputs,
					listedContainers,
					expandedSafeOps,
					Cache->cacheBall,
					Simulation->samplePreparationSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentUncover,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* check if we are simulating *)
	performSimulationQ = Or[
		MemberQ[output, Simulation],
		And[
			MemberQ[output, Result],
			MatchQ[resolvedPreparation, Robotic]
		]
	];

	(* If option resolution failed, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentUncover,collapsedResolvedOptions],
			Preview->Null,
			Simulation -> Simulation[]
		}]
	];


	(* Build packets with resources *)
	(* NOTE: resourceResult is either $Failed or {protocolPacket, unitOperationPackets} where protocolPacket will be Null if *)
	(* Preparation->Robotic. *)
	{resourceResult, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{$Failed, {}},
		gatherTests,
			uncoverResourcePackets[
				listedInputs,
				listedContainers,
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->samplePreparationSimulation,
				Output->{Result,Tests}
			],
		True,
			{
				uncoverResourcePackets[
					listedInputs,
					listedContainers,
					templatedOptions,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->samplePreparationSimulation
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		!performSimulationQ,
			{Null, samplePreparationSimulation},
		True,
			simulateExperimentUncover[
				If[MatchQ[resourceResult, $Failed],
					$Failed,
					resourceResult[[1]]
				],
				If[MatchQ[resourceResult, $Failed],
					$Failed,
					resourceResult[[2]]
				],
				listedInputs,
				listedContainers,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->samplePreparationSimulation,
				ParentProtocol->Lookup[safeOps,ParentProtocol]
			]
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentUncover,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			(* Uncovering should only take 10 seconds at the max per container. *)
			RunTime -> (10 Second) * Length[listedInputs]
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			resourceResult[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=Uncover@@Join[
					{
						Sample->Download[ToList[listedInputs], Object]
					},
					RemoveHiddenPrimitiveOptions[Uncover,ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentUncover,collapsedResolvedOptions];

				(* Memoize the value of ExperimentUncover so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentUncover, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentUncover]={};

					ExperimentUncover[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> resourceResult[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							(* Uncovering should only take 10 seconds at the max per container. *)
							RunTime -> (10 Second) * Length[listedInputs]
						}
					];

					ExperimentRoboticSamplePreparation[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				resourceResult[[1]],
				resourceResult[[2]],
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,Pellet],
				Cache->cache,
				Simulation->simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentUncover,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		(* Uncovering should only take 10 seconds at the max per container. *)
		RunTime -> (10 Second) * Length[listedInputs]
	}
];

(* ::Subsection:: *)
(* resolveUncoverMethod *)

DefineOptions[resolveUncoverMethod,
	SharedOptions:>{
		ExperimentUncover,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: myContainers can be Automatic when the user has not yet specified a value for autofill. *)
resolveUncoverMethod[
	myContainers:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, allModelContainerPackets, allModelUncoverPackets, manualRequirementStrings, roboticRequirementStrings,
		result, tests},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveUncoverMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download information that we need from our inputs and/or options. *)
	allModelContainerPackets=Quiet[
		Download[
			Cases[ToList[myContainers], ObjectP[]],
			Packet[Model[{Name, Footprint}]],
			Cache->Lookup[ToList[myOptions], Cache, {}],
			Simulation->Lookup[ToList[myOptions], Simulation, Null]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	allModelUncoverPackets=Cases[Flatten[{allModelContainerPackets}], ObjectP[Model[]]];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[MemberQ[Lookup[allModelContainerPackets, Footprint], Except[Plate]],
			"the sample container(s) "<>ToString[Cases[Transpose[{(ObjectToString[#, Cache->allModelContainerPackets]&)/@Lookup[allModelContainerPackets, Object], Lookup[allModelContainerPackets, Footprint]}], {_, Except[Plate]}][[All,1]]]<>" cannot be robotically covered on a liquid handler (only Plates can be covered robotically)",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[
				{ImageSample, MeasureVolume, MeasureWeight, Instrument, DecrimpingHead, CrimpingPressure},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|False|Automatic]]&)
			];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Uncover primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];

(* ::Subsubsection::Closed:: *)
(*resolveExperimentUncoverWorkCell*)

resolveExperimentUncoverWorkCell[
	myContainers:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[resolveExperimentUncoverWorkCell]
]:={STAR,bioSTAR,microbioSTAR};

(* ::Subsection:: *)
(* resolveExperimentUncoverOptions *)

DefineOptions[
	resolveExperimentUncoverOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

Error::ContainerIsAlreadyUncovered="The container(s), `1`, do not have covers on them. In order to remove the cover, the container must first be covered. All unit operations will automatically Cover and Uncover containers, if necessary. Please only call the Cover and Uncover if you'd like to override the default behavior of the unit operations.";
Error::DecrimperConflict="The covers at indices, `1`, are crimped caps and must be removed with a decrimping head that has the same CoverFootprint as the crimped cap. However, the Instrument option is set to `2` and the DecrimpingHead option is set to `3` for these caps. Please let the Instrument/DecrimpingHead option resolve automatically to a suitable decrimper to remove the crimped cap.";
Error::UnsafeDiscard="The containers, `1`, are set to have their cover discarded however there are no alternative covers that can be used to re-cover the container in subsequent steps. If you do wish to discard the cover please check its products or the products of the container's other possible covering options (see the CoverFootprints field). Otherwise consider setting DiscardCover to False.";
Error::NoActiveCartForCover="The ActiveCart must be set in the ParentProtocol of this Uncover/Cover as it will be used as the cover/uncover environment. If the cart should not be used check $CoverEnvironmentTypes and make sure the container is contained in one of these (at any level). Alternatively verify that this call is running from within Engine with the cart correctly set. The value received was `1`.";

resolveExperimentUncoverOptions[
	myInputs:{ObjectP[{Object[Container], Object[Sample]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveExperimentUncoverOptions]
]:=Module[
	{outputSpecification, output, gatherTests, messagesQ, warningsQ, cache, currentSimulation, samplePrepOptions, coverOptions,
		resolvedSamplePrepOptions, objectContainerFields, objectContainerPacketFields,
		modelContainerFields, objectSampleFields, modelSampleFields, objectContainerPackets, modelContainerPackets, objectSamplePacketList, modelSamplePacketList,
		crimperInstrumentModelPackets, decrimpingHeadPartModelPackets, plateSealerInstrumentModelPackets, capModelPackets,
		lidModelPackets, septumModelPackets, specifiedDecrimpingHeadPartObjectPackets, currentCoverPackets, currentCoverModelPackets,activeCartPackets,
		defaultCrimperInstrumentModelPackets, defaultCrimpingHeadPartModelPackets, defaultDecrimpingHeadPartModelPackets, defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets, defaultLidModelPackets, defaultSeptumModelPackets, defaultClampModelPackets, cacheBall, fastCacheBall, defaultPlateSealModelPackets,
		preparationResult, allowedPreparation, preparationTest, resolvedPreparation, mapThreadFriendlyOptions,
		coverTypes, compatibleFootprintsLists, searchConditions, suitableCoverModelLists, decrimperPartModelPackets,
		uniqueTypeFootprintTuples,safeDiscardBooleansInitial,safeDiscardLookup, safeDiscardBooleans, invalidDiscardBooleans, resolvedSampleLabels,
		resolvedSampleContainerLabels, resolvedInstruments, resolvedDiscardCovers, resolvedEnvironments, resolvedSterileTechniques,
		resolvedPostProcessingOptions, resolvedOptions, mapThreadFriendlyResolvedOptions, defaultCapPrierInstrumentModelPackets,
		unsafeDiscardTest, sterileTechniqueErrors, sterileTechniqueTest, decrimperTest, decrimperErrors, specifiedCapPrierInstrumentObjectPackets,
		objectContainerRepeatedContainerList, alreadyUncoveredTest, alreadyUncoveredErrors, invalidInputs, invalidOptions,
		capPrierInstrumentModelPackets, capPrierErrors, capPrierTest, activeCart, resolvedCrimpingPressures, resolvedDecrimpingHeads,
		defaultAmpouleOpenerModelPackets, ampouleBooleans, defaultCrimperPartModelPackets
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	(* warnings assume we're not in engine; if we are they are not surfaced *)
	gatherTests = MemberQ[output,Tests];
	messagesQ = !gatherTests;
	warningsQ = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Lookup our simulation. *)
	currentSimulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions, coverOptions}=splitPrepOptions[myOptions];

	(* ExperimentUncover does not have sample prep options so we are skipping those *)

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectContainerFields=DeleteDuplicates[Flatten[{Cover,Septum,ContainerMaterials,SamplePreparationCacheFields[Object[Container]]}]];
	objectContainerPacketFields=Packet@@objectContainerFields;
	modelContainerFields=Join[SamplePreparationCacheFields[Model[Container]],{CoverFootprints}];
	objectSampleFields=Join[SamplePreparationCacheFields[Object[Sample]],{Pungent, Ventilated}];
	modelSampleFields=SamplePreparationCacheFields[Model[Sample]];

	(* Get our default instrument, cover, and septum packets. *)
	{
		defaultCrimperInstrumentModelPackets,
		defaultCrimperPartModelPackets,
		decrimperPartModelPackets,
		defaultCrimpingHeadPartModelPackets,
		defaultDecrimpingHeadPartModelPackets,
		defaultCapPrierInstrumentModelPackets,
		defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets,
		defaultLidModelPackets,
		defaultPlateSealModelPackets,
		defaultSeptumModelPackets,
		defaultClampModelPackets,
		defaultAmpouleOpenerModelPackets
	}=coverModelPackets[myOptions];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	{
		objectContainerPackets,
		modelContainerPackets,
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList,
		specifiedDecrimpingHeadPartObjectPackets,
		specifiedCapPrierInstrumentObjectPackets,
		currentCoverPackets,
		currentCoverModelPackets,
		activeCartPackets
	}=Quiet[
		Download[
			{
				myContainers,
				myContainers,
				myContainers,
				myContainers,
				myContainers,
				Cases[ToList[myOptions], ObjectP[Object[Part, DecrimpingHead]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Part, CapPrier]], Infinity],
				myContainers,
				myContainers,
				{Lookup[myOptions,ParentProtocol]}
			},
			{
				List@objectContainerPacketFields,
				List@Packet[Model[modelContainerFields]],
				{Container..},
				List@Packet[Contents[[All,2]][objectSampleFields]],
				List@Packet[Contents[[All,2]][Model][modelSampleFields]],
				List@Packet[Model[{CoverFootprint, Name}]],
				List@Packet[Model[{CoverFootprint, Name}]],
				List@Packet[Cover[{Reusable}]],
				List@Packet[Cover[Model][{Name, Reusable, CleaningMethod, CoverType, Barcode, CrimpingPressure, Products, CoverFootprint}]],
				{Packet[ActiveCart]}
			},
			Cache->cache,
			Simulation->currentSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	{
		crimperInstrumentModelPackets,
		decrimpingHeadPartModelPackets,
		capPrierInstrumentModelPackets,
		plateSealerInstrumentModelPackets,
		capModelPackets,
		lidModelPackets,
		septumModelPackets
	}={
		defaultCrimperInstrumentModelPackets,
		Flatten[{
			defaultDecrimpingHeadPartModelPackets,
			Cases[Flatten@specifiedDecrimpingHeadPartObjectPackets, PacketP[Model[Part]]]
		}],
		Flatten[{
			defaultCapPrierInstrumentModelPackets,
			Cases[Flatten@specifiedCapPrierInstrumentObjectPackets, PacketP[Model[Part]]]
		}],
		defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets,
		defaultLidModelPackets,
		defaultSeptumModelPackets
	};

	{
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList
	}=Map[
		Flatten,
		{
			objectContainerRepeatedContainerList,
			objectSamplePacketList,
			modelSamplePacketList
		},
		{2}
	];

	{
		objectContainerPackets,
		modelContainerPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		currentCoverPackets,
		currentCoverModelPackets
	}=Flatten/@{
		objectContainerPackets,
		modelContainerPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		currentCoverPackets,
		currentCoverModelPackets
	};

	(* We've had to download with extra lists, clean this up *)
	activeCart=If[MatchQ[activeCartPackets,{Null}],
		Null,
		Lookup[activeCartPackets[[1,1]],ActiveCart]
	];

	cacheBall=FlattenCachePackets[{
		objectContainerPackets,
		modelContainerPackets,
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList,
		specifiedDecrimpingHeadPartObjectPackets,
		defaultCrimperInstrumentModelPackets,
		defaultDecrimpingHeadPartModelPackets,
		defaultCapPrierInstrumentModelPackets,
		defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets,
		defaultLidModelPackets,
		defaultPlateSealModelPackets,
		defaultSeptumModelPackets,
		decrimperPartModelPackets
	}];

	(* make the fast association *)
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* Resolve our preparation option. *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveUncoverMethod[myContainers, ReplaceRule[coverOptions, {Cache->cacheBall, Output->Result}]],
				{}
			},
			resolveUncoverMethod[myContainers, ReplaceRule[coverOptions, {Cache->cacheBall, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* - Determine if we have suitable replacement covers - *)
	(* It's safe to discard our cover if we keep its model in stock or if user has some *)
	(* Also safe if we have another cover with the same footprint *)

	(* Get all the covers types we're working with *)
	coverTypes=Download[currentCoverModelPackets,Type];

	(* For the containers we're working with check what types of covers can be used to cover *)
	compatibleFootprintsLists=Lookup[modelContainerPackets,CoverFootprints];
	ampouleBooleans = Lookup[modelContainerPackets, Ampoule];

	(* Get only our unique conditions for Search since this should be faster *)
	(* Case out instances where we don't have any CoverFootprints - we're already in trouble and just want to stop here *)
	uniqueTypeFootprintTuples=DeleteCases[DeleteDuplicates[Transpose[{coverTypes,compatibleFootprintsLists}]],{_,{}}];

	(* Set up search to see if any of the possible cover types have products *)
	searchConditions=(CoverFootprint == Alternatives @@ # && (Products != Null) && (RentByDefault != True))&/@(uniqueTypeFootprintTuples[[All,2]]);

	(* Do the listable search on Model[Item, Cap] (etc.) to see if we have options  *)
	suitableCoverModelLists=Search[uniqueTypeFootprintTuples[[All,1]],Evaluate[searchConditions]];

	(* If we have any covers with products that will fit on our container we're safe to discard the current one *)
	safeDiscardBooleansInitial=Length[#]>0&/@suitableCoverModelLists;

	(* Make a lookup of caps we can safely dispose for later so we can restore index-matching to our input *)
	safeDiscardLookup=AssociationThread[uniqueTypeFootprintTuples,safeDiscardBooleansInitial];


	safeDiscardBooleans=MapThread[
		(* If we have an ampoule we can only discard the cover and should not expect to recover it. *)
		If[TrueQ[#3],
			True,
			(* Else, for each input container look-up to see if we're safe to discard the cover (restore index-matching) *)
			(* Since we deleted cases with no CoverFootprints, default to False since we don't expect to find replacement caps *)
			Lookup[safeDiscardLookup,Key[{#1,#2}],False]
		]&,
		{coverTypes, compatibleFootprintsLists, ampouleBooleans}
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentUncover,Normal@coverOptions];

	(* Resolve our map thread options. *)
	{
		resolvedSampleLabels,
		resolvedSampleContainerLabels,
		resolvedDiscardCovers,
		resolvedInstruments,
		resolvedEnvironments,
		resolvedSterileTechniques,
		resolvedDecrimpingHeads,
		resolvedCrimpingPressures
	}=Transpose@MapThread[
		Function[{originalInputObject, objectSamplePackets, containerPacket, coverPacket, coverModelPacket, containerRepeatedContainers, discardSafe, options},
			Module[
				{sampleLabel, sampleContainerLabel, uncappedTime, discardCover, instrument, environment, sterileTechnique, containerContainer, cleanableQ,
					decrimpingHead, crimpingPressure, specifiedDecrimpingHead, specifiedCrimpingPressure, coverModelFootprint},

				uncappedTime=Lookup[options, UncappedTime];

				cleanableQ = !NullQ[Lookup[coverModelPacket, CleaningMethod, Null]];

				(* Resolve the DiscardCover option. *)
				discardCover=Which[
					MatchQ[Lookup[options, DiscardCover], Except[Automatic]],
						Lookup[options, DiscardCover],

					(* Always discard ampoule caps. *)
					MatchQ[Lookup[containerPacket, Ampoule], True],
						True,

					(* Lids do not need to be discarded. *)
					MatchQ[coverModelPacket, ObjectP[Model[Item, Lid]]],
						False,

					(* Always discard crimped caps. *)
					MatchQ[Lookup[coverModelPacket, CoverType], Crimp],
						True,

					(* If the non-cleanable cap is just sitting around for more than 15 minutes we want to toss it even if we can use it again *)
					uncappedTime>15 Minute && discardSafe && !cleanableQ,
						True,

					(* Discard if Reusable->False|Null *)
					(* Reusable is defined to mean that the cover can be put back on the same container *)
					MatchQ[coverPacket, ObjectP[{Object[Item, Cap], Object[Item, PlateSeal]}]],
						If[MatchQ[Lookup[coverPacket, Reusable]/.{Null->False}, False],
							True,
							False
					],

					(* Default to keeping the cover *)
					True,
						False
				];

				(* pull out the specified decrimping head and pressures ahead of time *)
				{
					specifiedDecrimpingHead,
					specifiedCrimpingPressure
				} = Lookup[
					options,
					{
						DecrimpingHead,
						CrimpingPressure
					}
				];

				(* going to use the cover footprint a lot so just pull it out here *)
				coverModelFootprint = Lookup[coverModelPacket, CoverFootprint];

				(* Resolve the instrument option. *)
				instrument=Which[
					MatchQ[Lookup[options, Instrument], Except[Automatic]],
						Lookup[options, Instrument],

					MatchQ[resolvedPreparation, Robotic],
						Null,

					(* if we're doing the following, use a manual decrimper: *)
					(* 1.) we are doing a crimp cap *)
					(* 2.) a manual decrimper exists for the cover footprint of the cap *)
					(* 3.) DecrimpingHead and CrimpingPressure were not specified*)
					And[
						MatchQ[coverModelPacket, ObjectP[Model[Item, Cap]]],
						MatchQ[Lookup[coverModelPacket, CoverType], Crimp],
						MemberQ[Lookup[decrimperPartModelPackets, CoverFootprint, {}], coverModelFootprint],
						MatchQ[specifiedDecrimpingHead, Automatic | Null],
						MatchQ[specifiedCrimpingPressure, Automatic | Null]
					],
						(* don't need a third argument to FirstCase because we already checked whether this cover footprint existed already *)
						FirstCase[
							decrimperPartModelPackets,
							packet: KeyValuePattern[{CoverFootprint -> coverModelFootprint}] :> Lookup[packet, Object]
						],

					(* Otherwise, if we're using a crimp cap, we need to get a decrimping instrument. *)
					MatchQ[coverModelPacket, ObjectP[Model[Item, Cap]]] && MatchQ[Lookup[coverModelPacket, CoverType], Crimp],
						Lookup[
							defaultCrimperInstrumentModelPackets[[1]],
							Object
						],

					(* If we're using a pried, we need to get a prying instrument. *)
					MatchQ[coverModelPacket, ObjectP[Model[Item, Cap]]] && MatchQ[Lookup[coverModelPacket, CoverType], Pry],
						Lookup[
							FirstCase[
								capPrierInstrumentModelPackets,
								KeyValuePattern[{CoverFootprint -> coverModelFootprint}],
								<|Object -> Null|>
							],
							Object
						],

					(* If we're working with a (glass) Ampoule, we'll want an AmpouleOpener. *)
					MatchQ[
						Lookup[containerPacket, {Ampoule, ContainerMaterials}],
						{True, Alternatives[Null, {}, {___, Alternatives[Glass, BorosilicateGlass], ___}]}
					],
						Lookup[
							FirstCase[
								defaultAmpouleOpenerModelPackets,
								KeyValuePattern[{
									MinVolume -> LessEqualP[Lookup[containerPacket, MaxVolume]],
									MaxVolume -> GreaterEqualP[Lookup[containerPacket, MaxVolume]]}],
								<|Object -> Null|>
							],
							Object
						],

					(* Otherwise, we don't need an instrument. *)
					True,
						Null
				];


				(* Resolve the decrimping head option. *)
				decrimpingHead=Which[
					MatchQ[Lookup[options, DecrimpingHead], Except[Automatic]],
					Lookup[options, DecrimpingHead],

					MatchQ[resolvedPreparation, Robotic],
					Null,

					(* If we're using a crimp cap, we need to get a decrimping head. *)
					(* only if we're not using a manual decrimper though *)
					MatchQ[Lookup[coverModelPacket, CoverType], Crimp] && Not[MatchQ[instrument, ObjectP[{Model[Part, Decrimper], Object[Part, Decrimper]}]]],
					Lookup[
						FirstCase[
							decrimpingHeadPartModelPackets,
							KeyValuePattern[{CoverFootprint->coverModelFootprint}],
							Null
						],
						Object
					],

					(* Otherwise, we don't need a decrimping head. *)
					True,
					Null
				];

				(* Resolve the crimping pressure option. *)
				crimpingPressure=Which[
					MatchQ[Lookup[options, CrimpingPressure], Except[Automatic]],
					Lookup[options, CrimpingPressure],

					MatchQ[resolvedPreparation, Robotic],
					Null,

					(* If we're using a crimp cap, we need to get a decrimping head. *)
					(* only if we're not using a manual decrimper though *)
					MatchQ[Lookup[coverModelPacket, CoverType], Crimp] && Not[MatchQ[instrument, ObjectP[{Model[Part, Decrimper], Object[Part, Decrimper]}]]],
					If[MatchQ[Lookup[coverModelPacket, CrimpingPressure], GreaterEqualP[0 PSI]],
						Lookup[coverModelPacket, CrimpingPressure],
						35 PSI
					],

					(* Otherwise, we don't need a crimping pressure. *)
					True,
					Null
				];

				containerContainer=First[containerRepeatedContainers,Null];

				(* Resolve the environment option - outsource to helper shared by Cover and Uncover *)
				(* Send in updated Prep value for proper environment determination *)
				environment=calculateCoverEnvironment[
					objectSamplePackets,
					containerRepeatedContainers,
					Join[options, <|Preparation -> resolvedPreparation, ActiveCart -> activeCart|>]
				];

				(* Resolve the SterileTechnique option to True if we have cells in our sample. *)
				sterileTechnique=Which[
					MatchQ[Lookup[options, SterileTechnique], Except[Automatic]],
						Lookup[options, SterileTechnique],

					(* If the user has told us to use a BSC, use sterile technique. *)
					MatchQ[environment, ObjectP[{Model[Instrument, BiosafetyCabinet], Object[Instrument, BiosafetyCabinet], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
						True,

					(* Otherwise, no sterile technique. *)
					True,
						False
				];

				(* Resolve the SampleLabel option. *)
				sampleLabel=Which[
					MatchQ[Lookup[options, SampleLabel], Except[Automatic]],
						Lookup[options, SampleLabel],
					And[
						MatchQ[originalInputObject, ObjectP[Object[Sample]]],
						MatchQ[currentSimulation, SimulationP],
						MatchQ[LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]], _String]
					],
						LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]],
					MatchQ[originalInputObject, ObjectP[Object[Sample]]],
						CreateUniqueLabel["uncovered sample"],
					True,
						Null
				];

				(* Resolve the SampleContainerLabel option. *)
				sampleContainerLabel=Which[
					MatchQ[Lookup[options, SampleContainerLabel], Except[Automatic]],
						Lookup[options, SampleContainerLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Lookup[containerPacket, Object]], _String],
						LookupObjectLabel[currentSimulation, Lookup[containerPacket, Object]],
					True,
						CreateUniqueLabel["uncovered container"]
				];

				{
					sampleLabel,
					sampleContainerLabel,
					discardCover,
					instrument,
					environment,
					sterileTechnique,
					decrimpingHead,
					crimpingPressure
				}
			]
		],
		{myInputs, objectSamplePacketList, objectContainerPackets, currentCoverPackets, currentCoverModelPackets, objectContainerRepeatedContainerList, safeDiscardBooleans, mapThreadFriendlyOptions}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[ReplaceRule[myOptions, Preparation->resolvedPreparation]];

	(* Gather these options together in a list. *)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			Preparation->resolvedPreparation,
			SampleLabel->resolvedSampleLabels,
			SampleContainerLabel->resolvedSampleContainerLabels,
			DiscardCover->resolvedDiscardCovers,
			Instrument->resolvedInstruments,
			Environment->resolvedEnvironments,
			SterileTechnique->resolvedSterileTechniques,
			DecrimpingHead->resolvedDecrimpingHeads,
			CrimpingPressure->resolvedCrimpingPressures,

			Name->Lookup[myOptions, Name],
			ImageSample -> Lookup[resolvedPostProcessingOptions, ImageSample],
			MeasureVolume -> Lookup[resolvedPostProcessingOptions, MeasureVolume],
			MeasureWeight -> Lookup[resolvedPostProcessingOptions, MeasureWeight],
			SamplesInStorageCondition -> Lookup[myOptions, SamplesInStorageCondition]
		}
	];

	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentUncover,resolvedOptions];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Make sure we're not discarding an irreplacable cover - CleanUp task doesn't use Uncover so we should never want this *)
	(* Check resolvedDiscardCovers instead of input options just in case we resolved it wrong
		but we only expect to see this error if user directly asked *)
	invalidDiscardBooleans=MapThread[
		(MatchQ[#1,True]&&!#2)&,
		{resolvedDiscardCovers,safeDiscardBooleans}
	];

	unsafeDiscardTest=If[Or@@invalidDiscardBooleans,
		Test["If a cover is set to be discarded it can be replaced with another as the cover is kept in stock or there exist alternate stocked covers:",True,False],
		Test["If a cover is set to be discarded it can be replaced with another as the cover is kept in stock or there exist alternate stocked covers:",True,True]
	];

	If[Or@@invalidDiscardBooleans && messagesQ,
		Message[
			Error::UnsafeDiscard,
			ObjectToString[PickList[myContainers,invalidDiscardBooleans,True], Cache->cacheBall]
		]
	];

	(* If SterileTechnique->True, Environment has to be a BSC (unless robotic). *)
	sterileTechniqueErrors=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{sterileTechnique, environment, index},
				If[MatchQ[sterileTechnique, True] && !MatchQ[environment, ObjectP[{Model[Instrument, BiosafetyCabinet], Object[Instrument, BiosafetyCabinet], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
					{sterileTechnique, environment, index},
					Nothing
				]
			],
			{resolvedSterileTechniques, resolvedEnvironments, Range[Length[myContainers]]}
		]
	];

	sterileTechniqueTest=If[Length[sterileTechniqueErrors]==0,
		Test["If SterileTechnique->True, the Environment option must be set to a BiosafetyCabinet:",True,True],
		Test["If SterileTechnique->True, the Environment option must be set to a BiosafetyCabinet:",False,True]
	];

	If[Length[sterileTechniqueErrors] > 0 && messagesQ,
		Message[
			Error::SterileTechniqueEnvironmentConflict,
			sterileTechniqueErrors[[All,3]],
			ObjectToString[sterileTechniqueErrors[[All,1]], Cache->cacheBall],
			ObjectToString[sterileTechniqueErrors[[All,2]], Cache->cacheBall]
		]
	];

	(* Crimper must match the cover. *)
	decrimperErrors=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{instrument, decrimpingHead, coverModelPacket, index},
				If[
					Or[
						(* If we're supposed to be crimping and don't have the crimper, we can't proceed *)
						(* it's a little more complicated with the crimping or decrimping head; this must be Null if we're using the manual decrimper, but can't be Null for the fancy one *)
						And[
							MatchQ[Lookup[coverModelPacket, CoverType], Crimp],
							Or[
								!MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper], Model[Part, Decrimper], Object[Part, Decrimper]}]],
								And[
									MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]],
									!MatchQ[decrimpingHead, ObjectP[{Model[Part, DecrimpingHead], Object[Part, DecrimpingHead]}]]
								],
								And[
									MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]],
									!MatchQ[Lookup[fetchPacketFromFastAssoc[decrimpingHead, fastCacheBall], {CoverFootprint}], Lookup[coverModelPacket, {CoverFootprint}]]
								]
							]
						],
						And[
							!MatchQ[Lookup[coverModelPacket, CoverType], Crimp],
							Or[
								MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper], Model[Part, Decrimper], Object[Part, Decrimper]}]],
								MatchQ[decrimpingHead, ObjectP[{Model[Part, DecrimpingHead], Object[Part, DecrimpingHead]}]]
							]
						]
					],
					{index, instrument, decrimpingHead},
					Nothing
				]
			],
			{resolvedInstruments, resolvedDecrimpingHeads, currentCoverModelPackets, Range[Length[myContainers]]}
		]
	];

	decrimperTest=If[Length[decrimperErrors]==0,
		Test["When using a crimped cap as a cover, a crimping instrument and decrimping head that matches the CoverFootprint of the cover must be specified in the Instrument and DecrimpingHead options:",True,True],
		Test["When using a crimped cap as a cover, a crimping instrument and decrimping head that matches the CoverFootprint of the cover must be specified in the Instrument and DecrimpingHead options:",False,True]
	];

	If[Length[decrimperErrors] > 0 && messagesQ,
		Message[
			Error::DecrimperConflict,
			decrimperErrors[[All,1]],
			ObjectToString[decrimperErrors[[All,2]], Cache->cacheBall],
			ObjectToString[decrimperErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* Cap Prier must match the cover. *)
	capPrierErrors=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{instrument, coverModelPacket, index},
				If[
					Or[
						And[
							MatchQ[instrument, ObjectP[{Model[Part, CapPrier], Object[Part, CapPrier]}]],
							Or[
								!MatchQ[coverModelPacket, ObjectP[Model[Item, Cap]]],
								!MatchQ[Lookup[coverModelPacket, CoverType], Pry],
								!MatchQ[
									Lookup[coverModelPacket, CoverFootprint],
									If[MatchQ[instrument, ObjectP[Object[]]],
										Lookup[fetchModelPacketFromCache[instrument, cacheBall], CoverFootprint],
										Lookup[fetchPacketFromCache[instrument, cacheBall], CoverFootprint]
									]
								]
							]
						],
						And[
							MatchQ[coverModelPacket, ObjectP[Model[Item, Cap]]],
							MatchQ[Lookup[coverModelPacket, CoverType], Pry],
							!MatchQ[instrument, ObjectP[{Model[Part, CapPrier], Object[Part, CapPrier]}]]
						]
					],
					{index, instrument, Lookup[coverModelPacket, Object]},
					Nothing
				]
			],
			{resolvedInstruments, currentCoverModelPackets, Range[Length[myContainers]]}
		]
	];

	capPrierTest=If[Length[capPrierErrors]==0,
		Test["When using a pried cap as a cover, a cap prier that matches the CoverFootprint of the cover must be specified in the Instrument option:",True,True],
		Test["When using a pried cap as a cover, a cap prier that matches the CoverFootprint of the cover must be specified in the Instrument option:",False,True]
	];

	If[Length[capPrierErrors] > 0 && messagesQ,
		Message[
			Error::CapPrierConflict,
			capPrierErrors[[All,1]],
			ObjectToString[capPrierErrors[[All,2]], Cache->cacheBall],
			ObjectToString[capPrierErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* If the Cover field is not set in the Object[Container], it does not have a cover and cannot be uncovered. *)
	alreadyUncoveredErrors=Flatten[{
		MapThread[
			Function[{containerPacket, index},
				If[!MatchQ[Lookup[containerPacket, Cover], ObjectP[]],
					Lookup[containerPacket, Object],
					Nothing
				]
			],
			{objectContainerPackets, Range[Length[myContainers]]}
		],
		(* If we have repeated container objects in myContainers for RSP, it may be because samples in a plate were provided as input instead of container. This is OK as we will just do one uncover in RSP *)
		If[!MatchQ[resolvedPreparation,Robotic],
			Cases[Tally[myContainers], {_, GreaterP[1]}][[All, 1]],
			{}
		]
	}];

	alreadyUncoveredTest=If[Length[alreadyUncoveredErrors]==0,
		Test["The containers that are to be covered cannot already have a cover on them:",True,True],
		Test["The containers that are to be covered cannot already have a cover on them:",False,True]
	];

	If[Length[alreadyUncoveredErrors] > 0 && messagesQ,
		Message[
			Error::ContainerIsAlreadyUncovered,
			ObjectToString[alreadyUncoveredErrors, Cache->cacheBall]
		]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		If[Length[alreadyUncoveredErrors]>0,
			alreadyUncoveredErrors,
			Nothing
		]
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		If[Or@@invalidDiscardBooleans,
			{DiscardCover},
			Nothing
		],
		If[Length[sterileTechniqueErrors]>0,
			{SterileTechnique, Environment},
			Nothing
		],
		If[Length[decrimperErrors]>0,
			{Instrument, DecrimpingHead},
			Nothing
		],
		If[Length[capPrierErrors]>0,
			{Instrument},
			Nothing
		],
		If[MatchQ[preparationResult, $Failed],
			{Preparation},
			Nothing
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Flatten[{
			resolvedOptions,
			resolvedPostProcessingOptions
		}],
		Tests -> Flatten[{
			unsafeDiscardTest,
			sterileTechniqueTest,
			decrimperTest,
			capPrierTest,
			alreadyUncoveredTest,
			preparationTest
		}]
	}
];

(* ::Subsection:: *)
(* uncoverResourcePackets *)

DefineOptions[
	uncoverResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

uncoverResourcePackets[
	myInputs:{ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myTemplatedOptions:{(_Rule|_RuleDelayed)...},
	myResolvedOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]
]:=Module[
	{expandedInputs, expandedResolvedOptions, outputSpecification, output, gatherTests, messages, inheritedCache, simulation,
		resolvedPreparation, mapThreadFriendlyResolvedOptions, protocolPacket, unitOperationPackets, rawResourceBlobs,
		resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs, resourcesOk, resourceTests, testsRule, resultRule,
		containerPackets, capPackets},

	(* -- SHARED LOGIC BETWEEN ROBOTIC AND MANUAL -- *)

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentUncover, {myContainers}, myResolvedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation = Lookup[ToList[ops],Simulation];

	(* Lookup the Preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get a map thread friendly version of our resolved options. *)
	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentUncover, myResolvedOptions];

	(* Download information about the container and its cover. *)
	{containerPackets, capPackets}=Flatten/@Quiet[
		Download[
			{
				myContainers,
				myContainers
			},
			{
				{Packet[Name, Cover, Contents]},
				{Packet[Cover[{Model, Name}]], Packet[Cover[Model][{Barcode, Name}]]}
			},
			Simulation->simulation,
			Cache->inheritedCache
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Are we making resources for Manual or Robotic? *)
	{protocolPacket, unitOperationPackets}=If[MatchQ[resolvedPreparation, Manual],
		Module[
			{sampleResources, uniqueInstrumentResources, uniqueEnvironmentResources, capRackResources, uncoverManualUnitOperationPackets,
				manualProtocolPacket, sharedFieldPacket, finalizedPacket, nonHiddenUncoverOptions, mapThreadOptionsWithResources,
				groupedMapThreadOptionsWithResources, uniqueDecrimpingHeadResources},

			(* Create resources for our samples and containers. *)
			(* NOTE: If the object is already in our environment, we don't actually resource pick it to save time. This can lead to *)
			(* incorrect outstanding resource errors downstream. *)
			sampleResources=(Which[
				MatchQ[#, ObjectP[Model[]]],
					Resource[Sample->#],
				MatchQ[#, ObjectP[Object[]]],
					Link[Download[#, Object]],
				True,
					Null
			]&)/@myInputs;

			(* Create resources for our instruments. *)
			uniqueInstrumentResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
					Resource[Instrument->#, Name->CreateUUID[]],
				MatchQ[#, ObjectP[{Model[Part, Decrimper], Object[Part, Decrimper]}]],
					Resource[Sample -> #, Name -> "Decrimper"],
				MatchQ[#, ObjectP[{Model[Part, AmpouleOpener], Object[Part, AmpouleOpener]}]],
					Resource[Sample -> #, Name -> CreateUUID[], Rent -> True],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, Instrument]];

			(* Create resources for our decrimping heads. *)
			uniqueDecrimpingHeadResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Part], Object[Part]}]],
					Resource[Sample->#, Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, DecrimpingHead]];

			(* Create resources for each of our environments. *)
			uniqueEnvironmentResources=(#->Which[
				(* special treatment for fumehood, we do not really care which model to use for uncovering if we are really going to use a fumehood, so just allow all models *)
				MatchQ[#, ObjectP[Model[Instrument, HandlingStation, FumeHood, "id:1ZA60vzEmYv0"]]],
					With[{currentFumeHoodModels= UnsortedComplement[Cases[transferModelsSearch["Memoization"][[23]], ObjectP[Model[Instrument, HandlingStation, FumeHood]]], $SpecializedHandlingStationModels]},
						Resource[Instrument -> currentFumeHoodModels]
					],
				MatchQ[#, ObjectP[{Model[Container], Object[Container]}]],
					Resource[Sample->#],
				MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
					Resource[Instrument->#],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, Environment]];

			(* Create a resource for a cap rack if the cover we're taking off is a cap that has Barcode->False|Null and
			if the cover is not being discarded *)
			capRackResources=MapThread[
				(
					If[And[
							MatchQ[Lookup[#1, Cover], ObjectP[Object[Item, Cap]]],
							MatchQ[Lookup[fetchModelPacketFromCache[Lookup[#1, Cover], capPackets], Barcode], False|Null],
							MatchQ[#2,Except[True]]
						],
						Resource[Sample->Model[Container, Rack, "id:1ZA60vLllqk8"], Name->CreateUUID[]], (* Universal Cap Rack *)
						Null
					]
				&),
				{containerPackets,Lookup[myResolvedOptions, DiscardCover]}
			];

			(* Replace our option values with these resources in our map threaded options. *)
			mapThreadOptionsWithResources=MapThread[
				Function[{originalOptions, newOptionsWithResources},
					ReplaceRule[Normal[originalOptions], Normal[newOptionsWithResources]]
				],
				{
					mapThreadFriendlyResolvedOptions,
					(AssociationThread[
						{
							Sample,
							CapRack,
							Instrument,
							Environment,
							DecrimpingHead
						},
						#
					]&)/@Transpose[{
						sampleResources,
						capRackResources,
						(Lookup[uniqueInstrumentResources, #]&)/@Lookup[myResolvedOptions, Instrument],
						(Lookup[uniqueEnvironmentResources, #]&)/@Lookup[myResolvedOptions, Environment],
						(Lookup[uniqueDecrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, DecrimpingHead]
					}]
				}
			];

			(* Group these map threaded options by the Environment and Instrument. *)
			groupedMapThreadOptionsWithResources=Values@GroupBy[
				mapThreadOptionsWithResources,
				({Lookup[#, Instrument], Lookup[#, Environment], Lookup[#, DecrimpingHead]}&)
			];

			(* Only include non-hidden options from Uncover. *)
			nonHiddenUncoverOptions=Complement[
				Join[
					Lookup[
						Cases[OptionDefinition[ExperimentUncover], KeyValuePattern["Category"->Except["Hidden"]]],
						"OptionSymbol"
					],
					{
						Sample,
						CapRack,
						Instrument,
						Environment,
						BarcodeCoverContainers,
						DecrimpingHead
					}
				],
				{
					ImageSample,
					MeasureVolume,
					MeasureWeight,
					Template
				}
			];

			(* For each of our environments, *)
			uncoverManualUnitOperationPackets=UploadUnitOperation[
				Map[
					Function[{options},
						Module[{mergedOptions, finalOptions, nullCapRackContainers, discardedCoverContainers, barcodeCoverContainers},
							(* NOTE: Our options are still a list of map thread friendly options at this point, we need to merge them. *)
							mergedOptions=Normal@Merge[options, Join];

							(* Get the containers with covers that aren't going on cap racks *)
							nullCapRackContainers=PickList[Lookup[mergedOptions, Sample], Lookup[mergedOptions, CapRack], Null];

							(* Get the containers with covers that are being discarded *)
							discardedCoverContainers=PickList[Lookup[mergedOptions, Sample], Lookup[mergedOptions, DiscardCover], True];

							(* Get the containers with covers that should be barcoded: the containers with covers that
							aren't going on cap racks and aren't being discarded. *)
							barcodeCoverContainers=Complement[nullCapRackContainers, discardedCoverContainers];

							(* Add BarcodeContainerCovers as a field to upload. These are the containers that should have barcoded covers. *)
							finalOptions=Append[
								mergedOptions,
								BarcodeCoverContainers->barcodeCoverContainers
							];

							Uncover@Cases[finalOptions, Verbatim[Rule][Alternatives@@nonHiddenUncoverOptions, _]]
						]

					],
					groupedMapThreadOptionsWithResources
				],
				UnitOperationType->Batched,
				Preparation->Manual,
				Upload->False
			];

			(* Return our final protocol packet. *)
			manualProtocolPacket=<|
				Object->CreateID[Object[Protocol, Uncover]],

				Replace[SamplesIn]->(Link[#, Protocols]&)/@DeleteDuplicates@Download[Cases[Lookup[containerPackets, Contents], ObjectP[Object[Sample]], Infinity], Object],
				Replace[ContainersIn]->(Link[#, Protocols]&)/@DeleteDuplicates[myContainers],

				Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@Lookup[uncoverManualUnitOperationPackets, Object],

				Replace[Instruments]->(Lookup[uniqueInstrumentResources, #]&)/@Lookup[myResolvedOptions, Instrument],
				Replace[Environment]->Link/@((Lookup[uniqueEnvironmentResources,#]&)/@Lookup[myResolvedOptions,Environment]),
				Replace[SterileTechnique]->Lookup[myResolvedOptions, SterileTechnique],
				Replace[DecrimpingHeads]->(Lookup[uniqueDecrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, DecrimpingHead],
				Replace[CrimpingPressures]->Lookup[myResolvedOptions, CrimpingPressure],

				Replace[CapRacks]->capRackResources,

				Replace[Checkpoints]->{
					{"Performing Uncovering",1*Minute*Length[uncoverManualUnitOperationPackets],"The containers are uncovered.",Link[Resource[Operator -> $BaselineOperator, Time -> (1*Minute*Length[uncoverManualUnitOperationPackets])]]}
				},

				Author->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],Null],
					Link[$PersonID,ProtocolsAuthored]
				],
				ParentProtocol->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],ObjectP[ProtocolTypes[]]],
					Link[Lookup[myResolvedOptions, ParentProtocol],Subprotocols]
				],

				UnresolvedOptions->RemoveHiddenOptions[ExperimentUncover,myTemplatedOptions],
				ResolvedOptions->myResolvedOptions,

				Name->Lookup[myResolvedOptions, Name]
			|>;

			(* generate a packet with the shared fields *)
			sharedFieldPacket = populateSamplePrepFields[myContainers, myResolvedOptions, Cache -> inheritedCache];

			(* Merge the shared fields with the specific fields *)
			finalizedPacket = Join[sharedFieldPacket, manualProtocolPacket];

			(* Return our protocol packet and unit operation packets. *)
			{finalizedPacket, uncoverManualUnitOperationPackets}
		],
		Module[
			{inputResources, containerResources, uncoverUnitOperationPacket, uncoverUnitOperationPacketWithLabeledObjects},

			(* Create resources for our samples and containers. *)
			inputResources=(Resource[Sample->#]&)/@myInputs;
			containerResources=(Resource[Sample->#]&)/@myContainers;

			(* Upload our UnitOperation with the Source/Destination/Tips options replaced with resources. *)
			uncoverUnitOperationPacket=Module[{nonHiddenUncoverOptions},
				(* Only include non-hidden options from Uncover. *)
				nonHiddenUncoverOptions=Lookup[
					Cases[OptionDefinition[ExperimentUncover], KeyValuePattern["Category"->Except["Hidden"]]],
					"OptionSymbol"
				];

				UploadUnitOperation[
					Uncover@@Join[
						{
							Sample->containerResources
						},
						(* NOTE: We allow for MultichannelUncoverName (developer field) since it's used in the exporter. *)
						ReplaceRule[
							Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenUncoverOptions, _]],
							{
								(* NOTE: Don't pass Name down. *)
								Name->Null
							}
						]
					],
					Preparation->Robotic,
					UnitOperationType->Output,
					FastTrack->True,
					Upload->False
				]
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			uncoverUnitOperationPacketWithLabeledObjects=Append[
				uncoverUnitOperationPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleLabel], inputResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], containerResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					]
				]
			];

			(* Return our protocol packet (we don't have one) and our unit operation packet. *)
			{Null, {uncoverUnitOperationPacketWithLabeledObjects}}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->inheritedCache],Null}
	];

	(* --- Output --- *)

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{protocolPacket, unitOperationPackets}/.resourceToNameReplaceRules,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentUncover,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentUncover[
	myProtocolPacket:(PacketP[Object[Protocol, Uncover], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	myInputs:{ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentUncover]
]:=Module[
	{protocolObject, parentProtocol, rootProtocol, mapThreadFriendlyOptions, resolvedPreparation, currentSimulation, containerPackets, uploadCoverPackets,
		coverPackets, discardCoverPackets, previousCoverPackets, simulationWithLabels},

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[Lookup[myResolvedOptions, Preparation], Robotic],
			SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol,Uncover]],
		True,
			Lookup[myProtocolPacket, Object]
	];

	(* Get our parent and root protocol *)
	parentProtocol=Lookup[ToList[myResolutionOptions], ParentProtocol, Null];
	rootProtocol=If[NullQ[parentProtocol],
		protocolObject,
		LastOrDefault[Download[parentProtocol,Repeated[ParentProtocol][Object]],parentProtocol]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentUncover,
		myResolvedOptions
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],

		(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateResources[
					<|
						Object->protocolObject,
						Replace[ContainersIn]->(Link[Resource[Sample->#]]&)/@DeleteDuplicates[myContainers],
						ResolvedOptions->myResolvedOptions
					|>,
					Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
					Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
				],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Uncover]. *)
		True,
			SimulateResources[myProtocolPacket, myUnitOperationPackets, Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
	];

	(* Download information from our simulated resources. *)
	containerPackets=Quiet[
		Download[
			myContainers,
			Packet[Cover, Name],
			Simulation->currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Call UploadSampleUncover on our containers and covers. *)
	uploadCoverPackets=UploadCover[
		myContainers,
		Cover->ConstantArray[Null, Length[myContainers]],
		Upload->False,
		Simulation->currentSimulation
	];

	(* Sever the two-way link from cover to the container too. In real Upload, this should be done with UploadCover since it is a two-way link. However, since we don't really upload in simulation, we have to do this manually *)
	coverPackets=Map[
		If[MatchQ[#,ObjectP[]],
			<|
				Object->Download[#,Object],
				CoveredContainer->Null
			|>
		]&,
		Lookup[containerPackets, Cover]
	];

	(* Discard covers that we were told to. *)
	(* We are forcing to prevent bugs if simulating a Cover UO before an Uncover UO *)
	discardCoverPackets=If[MemberQ[Lookup[myResolvedOptions, DiscardCover], True],
		UploadSampleStatus[
			DeleteDuplicates@Cases[
				PickList[Lookup[containerPackets, Cover], Lookup[myResolvedOptions, DiscardCover]],
				ObjectP[]
			],
			Waste,
			Simulation->currentSimulation,
			Upload->False,
			UpdatedBy->rootProtocol,
			Force->True
		],
		{}
	];

	(* For the covers that we are not discarding, set the PreviousCover field in the Object[Container]. *)
		previousCoverPackets=If[MemberQ[Lookup[myResolvedOptions, DiscardCover], False],
		(
			<|
				Object->Lookup[#, Object],
				PreviousCover->Link@Lookup[#, Cover]
			|>
		&)/@PickList[containerPackets, Lookup[myResolvedOptions, DiscardCover], False],
		{}
	];

	(* Update our simulation. *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[Flatten[{uploadCoverPackets, coverPackets, discardCoverPackets, previousCoverPackets}]]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Rule@@@Join[
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], myInputs}],
				{_String, ObjectP[Object[Sample]]}
			],
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], myContainers}],
				{_String, ObjectP[Object[Container]]}
			]
		],
		LabelFields->If[MatchQ[resolvedPreparation, Manual],
			Rule@@@Join[
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[myContainers]]}],
					{_String, _}
				],
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel],  (Field[SampleLink[[#]][Container]]&)/@Range[Length[myContainers]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];

(*
	calculateCoverEnvironment - Determines where the uncovering/covering should happen
		Inputs:
			objectSamplePackets:{PacketP[Object[Sample]]..} - Sample download for the ContainerIn
			containerRepeatedContainers:{ObjectP[Object[Container]]..} - Download of all up containers for the ContainerIn
			options_Association - ExperimentCover/UnCover MapThread options with current resolution
		Outputs:
			out:ObjectP[{Object[Container],Object[Instrument],Model[Container],Model[Instrument]}] - Location where the container should be uncovered
*)
(*this must never resolve to an Object unless it is determined that the cover is already in that object. coverSubprotocolAssociation and uncoverSubprotocolAssociation depend on Object meaning that we are already in the right spot.*)
calculateCoverEnvironment[objectSamplePackets_,containerRepeatedContainers_,options_]:=Which[
	MatchQ[Lookup[options, Environment], Except[Automatic]],
		Lookup[options, Environment],

	(* No CoverEnvironment when Robotic. *)
	MatchQ[Lookup[options, Preparation], Robotic],
		Null,

	(* Is our container already in a suitable environment (and we were told to use SterileTechnique or a crimper)? *)
	And[
		Or[
			MatchQ[Lookup[options, SterileTechnique], True],
			MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]]
		],
		MemberQ[
			containerRepeatedContainers,
			ObjectP[{Object[Instrument, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]
		]
	],
		Download[FirstCase[containerRepeatedContainers,ObjectP[{Object[Instrument, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],Object],

	(* Put the container in a BSC if SterileTechnique->True. *)
	MemberQ[Lookup[objectSamplePackets, CellType, Null], MicrobialCellTypeP] && MatchQ[Lookup[options, SterileTechnique], True],
		Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"], (*Biosafety Cabinet Handling Station for Microbiology*)

	MemberQ[Lookup[objectSamplePackets, CellType, Null], NonMicrobialCellTypeP] && MatchQ[Lookup[options, SterileTechnique], True],
		Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"], (*Biosafety Cabinet Handling Station for Tissue Culture*)

	MatchQ[Lookup[options, SterileTechnique], True],
		Model[Instrument, HandlingStation, BiosafetyCabinet, "id:54n6evJ3G4nl"], (*Biosafety Cabinet Handling Station for Microbiology*)

	(* BSC is required for crimping (right now). *)
	MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]],
		Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"], (*Biosafety Cabinet Handling Station for Tissue Culture*)

	(* Is our container already in a suitable environment (and not SterileTechnique or crimping)? *)
	And[
		!Or[
			MatchQ[Lookup[options, SterileTechnique], True],
			MatchQ[Lookup[options, Instrument], ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]]
		],
		MemberQ[
			containerRepeatedContainers,
			ObjectP[$CoverEnvironmentTypes]
		]
	],
		(* Prefer handling station, benches, and carts first over other cover environments. *)
		Download[
			FirstCase[
				containerRepeatedContainers,
				ObjectP[{Object[Instrument,HandlingStation],Object[Container,Bench],Object[Container,OperatorCart]}],
				FirstCase[containerRepeatedContainers,ObjectP[$CoverEnvironmentTypes]]
			],
			Object
		],

	(* Use our current cart to uncap if we didn't hit anything else *)
	MatchQ[Download[Lookup[options,ActiveCart],Object],ObjectP[]],
		Download[Lookup[options,ActiveCart],Object],

	(* Fume Hood is required for ventilated and pungent samples *)
	(* This will only get hit if it container isn't already in any of the allowed $CoverEnvironmentTypes *)
	(* we set to this model for now, we will replace it with a list of fumehood models in the resource packets *)
	AnyTrue[Join@@{Lookup[objectSamplePackets,Ventilated, Null], Lookup[objectSamplePackets,Pungent, Null]},TrueQ],
		Model[Instrument, HandlingStation, FumeHood, "id:1ZA60vzEmYv0"],

	(* If we are called by ExperimentTransfer during option resolving stage (FastTrack->True), do not worry about missing ActiveCart because we haven't started anything yet *)
	MatchQ[Lookup[options,FastTrack],True],
		Null,

	(* if we are in engine and cant find anywhere to do the uncover, error *)
	True,
		Message[Error::NoActiveCartForCover, Lookup[options,ActiveCart]];$Failed
];
