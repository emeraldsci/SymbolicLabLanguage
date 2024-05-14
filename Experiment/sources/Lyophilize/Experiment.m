(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentLyophilize Options and Messages*)


DefineOptions[ExperimentLyophilize,
	Options:>{
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "Indicates which lyophilizer should be used to sublimate solvent out of the provided input samples.",
			AllowNull -> False,
			Category->"General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument,Lyophilizer],Object[Instrument,Lyophilizer]}]
			]
		},
		{
			OptionName -> ProbeSamples,
			Default -> Null,
			Description -> "A list of up to four input samples into which a thermocouple may be inserted to monitor sample temperature over the course of the run.",
			AllowNull -> True,
			Category -> "InstrumentSetUp",
			Widget -> Adder[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample],Object[Container]}]
				]
			]
		},
		{
			OptionName -> TemperaturePressureProfile,
			Default -> Automatic,
			Description -> "A list of time points in the form {time, temperature, pressure} that specify the pressure and temperature gradients that will facilitate the sublimation of solvent from the input samples over the course of the run.",
			ResolutionDescription -> "Automatically set to the combination of the Temperature, Pressure, and LyophilizationTime options. If all of those are Null, it will default to Freezing the samples for 2 hours, before dropping to 100millitorr.",
			AllowNull -> False,
			Category -> "Lyophilization",
			Widget -> Adder[
				{
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Minute],
						Units -> {Minute,{Second,Minute,Hour}}
					],
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[-55 Celsius, 60 Celsius],
						Units -> Celsius
					],
					"Pressure" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[100 Millitorr, 760 Torr],
						Units -> {Millitorr,{Millitorr,Torr, Atmosphere}}
					]
				},
				Orientation->Vertical
			]
		},
		{
			OptionName -> Temperature,
			Default -> Automatic,
			Description -> "A single temperature to hold the samples at over the course of the run, or a paired list of {time, temperature} that specifies the temperature of the cooling shelves over time.",
			ResolutionDescription -> "Automatically set to the temperature gradient found in the contents of the TemperaturePressureProfile option.",
			AllowNull -> False,
			Category -> "Lyophilization",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[-55 Celsius, 60 Celsius],
					Units -> Celsius
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute,{Second,Minute,Hour}}
						],
						"Temperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-55 Celsius, 60 Celsius],
							Units -> Celsius
						]
					},
					Orientation->Vertical
				]
			]
		},
		{
			OptionName -> Pressure,
			Default -> Automatic,
			Description -> "A single pressure to hold the samples at over the course of the run, or a paired list of {time, pressure} that specifies the pressure of the sample chamber over time.",
			ResolutionDescription -> "Automatically set to the pressure gradient found in the contents of the TemperaturePressureProfile option.",
			AllowNull -> False,
			Category -> "Lyophilization",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[100*Millitorr, 760 Torr],
					Units -> {Millitorr,{Millitorr,Torr, Atmosphere}}
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute,{Second,Minute,Hour}}
						],
						"Pressure" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[100 Millitorr, 760 Torr],
							Units -> {Millitorr,{Millitorr,Torr, Atmosphere}}
						]
					},
					Orientation->Vertical
				]
			]
		},
		{
			OptionName -> LyophilizationTime,
			Default -> Automatic,
			Description -> "The length of time the samples will be exposed to the pressure and temperature gradients.",
			ResolutionDescription -> "Automatically set to the length of the temperature pressure profile.",
			AllowNull -> False,
			Category -> "Lyophilization",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units->{Hour,{Hour,Minute,Second}}
			]
		},
		{
			OptionName -> LyophilizeUntilDry,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
			Description -> "If the sample is not fully dried after the LyophilizationTime has completed, indicates if the lyophilization is repeated with the same settings until the sample is dried or the MaxLyophilizationTime is reached.",
			ResolutionDescription -> "Automatically set to the False unless a MaxLyophlization time greater than the Lyophilization time is provided.",
			Category->"Lyophilization"
		},
		{
			OptionName -> MaxLyophilizationTime,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "Lyophilization",
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Minute, $MaxExperimentTime],
				Units->{Hour,{Hour,Minute,Second}}
			],
			Description -> "If the sample is not fully dried after the LyophilizationTime has completed, the samples may be exposed to lyophilization conditions repeatedly until this time has been reached. Must match a multiple of the LyophilizationTime.",
			ResolutionDescription -> "If LyophilizeUntilDry is set to True, automatically set to three times the LyophilizationTime, up to a maximum of 72 Hours. Otherwise set to the LyophilizationTime."
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> PerforateCover,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates whether the seal or cap placed on the containers in will be punctured to allow more access for solvent vapor to escape from the container.",
				ResolutionDescription -> "Automatically set to False if ContainerCover is specified. Otherwise, if no cover was specified, it will resolve to Null.",
				Category->"Lyophilization"(*"Hidden"*)
			},
			{
				OptionName -> ContainerCover,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> LyophilizationCoverP],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item,Cap],Object[Item,Cap],Model[Item,PlateSeal],Object[Item,PlateSeal]}]
					]
				],
				Description -> "Indicates whether a cap or seal is placed on the containers in to prevent escape of solid material while allowing solvent vapors to escape the container.",
				ResolutionDescription -> "Automatically resolves to a compatible seal or cap, if one exits. If not it resolves to Chemwipe for vessels and Null for plates.",
				Category->"Lyophilization"
			}
		],
		{
			OptionName -> PreFrozenSamples,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
			Description -> "Indicates whether the SamplesIn were already frozen, prior to the start of the experiment, which will reduce the amount of freezing time necessary inside the lyophilizer.",
			ResolutionDescription -> "Automatically set to the False unless a MaxLyophlization time greater than the Lyophilization time is provided.",
			Category->"Hidden" (* TODO: Fix parser and return this category to Lyophilization *)
		},
		{
			OptionName -> ResidualTemperature,
			Default -> 20*Celsius,
			Description -> "The temperature the cooling shelves will maintain once the lyophilization method is complete.",
			ResolutionDescription -> "Automatically set to the ResidualTemperature field value of any method object provided to the TemperaturePressureProfile option. If no method object was provided, it will be set to 25*C.",
			AllowNull -> False,
			Category -> "SampleStorage",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-55 Celsius, 60 Celsius],
				Units -> Celsius
			]
		},
		{
			OptionName -> ResidualPressure,
			Default -> 1*Torr,
			Description -> "The pressure the sample chamber will maintain once the lyophilization method is complete.",
			ResolutionDescription -> "Automatically set to the ResidualPressure field value of any method object provided to the TemperaturePressureProfile option. If no method object was provided, it will be set to 1*Torr.",
			AllowNull -> False,
			Category -> "SampleStorage",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[100*Millitorr, 760 Torr],
				Units -> {Millitorr,{Millitorr,Torr, Atmosphere}}
			]
		},
		{
			OptionName -> NitrogenFlush,
			Default -> True,
			Description -> "Indicates if the sample chamber will be flushed with nitrogen before and after the sublimation to prevent excess water from contaminating the samples.",
			AllowNull -> False,
			Category -> "SampleStorage",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat the freezing and sublimation cycle on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[2,1]
			],
			Category->"General"
		},
		FuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions
	}
];


Error::NotEnoughProbes = "ExperimentLyophilize only supports `1` ProbeSamples at this time, but `2` samples were provided. Please select no more than `1` of the samples provided: `3`.";
Error::ProbeSamplesInvalid = "Some of the probe samples (`1`) are not members of the input samples `2`. Please ensure ProbeSamples only calls members of the inputs samples.";
Error::LyophilizeContainerMaximum = "Too many containers have been provided to ExperimentLyophilize, and the instrument deck cannot be loaded correctly. Please reduce the number of containers to be lyophilized.";
Error::LyophilizationTimeZero = "The final TemperaturePressureProfile was 0 minutes in length. Please make sure the following options provide timing information: `1`";
Error::InvalidMaxLyoTime = "The MaxLyophilizationTime (`1`) must be greater than or equal to the LyophilizationTime (`2`). Please check these option values, and increase the MaxLyophilizationTime or decrease the LyophilizationTime.";


(* ::Subsection::Closed:: *)
(*ExperimentLyophilize*)


(* - Container to Sample Overload - *)
ExperimentLyophilize[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed,
		samplePreparationCache,safeOps,safeOpsTests,validLengths,validLengthTests,allDownloads,cache,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		sampleFieldsRequired,containerFieldsRequired,containerModelFieldsRequired,sampleModelFieldsRequired,unresPierce,
		unresCover,possibleCovers
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Stash a cache *)
	cache = Quiet[OptionValue[Cache]];

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentLyophilize,
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentLyophilize,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentLyophilize,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentLyophilize,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentLyophilize,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentLyophilize,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentLyophilize,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentLyophilize,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Stash variables that hold which fields to download *)
	sampleFieldsRequired = SamplePreparationCacheFields[Object[Sample],Format->Packet];
	sampleModelFieldsRequired = Packet[Model[DeleteDuplicates@Flatten[{Products, Deprecated, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerFieldsRequired = Packet[Container[{Model,Contents,Container,Position,Sequence@@SamplePreparationCacheFields[Object[Container]]}]];
	containerModelFieldsRequired = Packet[Container[Model][{Dimensions,Sequence@@SamplePreparationCacheFields[Model[Container]]}]];

	(*- Determine which objects we must download information from for the capping and sealing options -*)
	(* gather unresolved options*)
	unresPierce = Lookup[expandedSafeOps,PerforateCover];
	unresCover = Lookup[expandedSafeOps,ContainerCover];

	(* Search for objects based on whether we'll have to resolve automatics *)
	possibleCovers = If[MemberQ[unresCover,Automatic|BreathableSeal],
		Search[{Model[Item,Cap],Model[Item,PlateSeal]},Or[Pierceable==True, Breathable==True],SubTypes->False],
		{}
	];

	(* Download all the needed things *)
	allDownloads = Flatten@Quiet[
		Download[
			{
				mySamplesWithPreparedSamples,
				possibleCovers
			},
			{
				{
					(* Sample Packet *)Evaluate[sampleFieldsRequired],
					(* Model Sample Packet *)Evaluate[sampleModelFieldsRequired],
					(* Container Packet *)Evaluate[containerFieldsRequired],
					(* Container Model Packet *)Evaluate[containerModelFieldsRequired]
				},
				{
					(* Cap and Seal Packets *)Packet[Deprecated,Pierceable,Breathable]
				}
			},
			Cache->cache
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::Part}
	];

	(* Add the new packets to the cache *)
	cacheBall = FlattenCachePackets[Cases[Join[samplePreparationCache,cache,allDownloads],PacketP[]]];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentLyophilizeOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentLyophilizeOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentLyophilize,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentLyophilize,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		lyophilizeResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{lyophilizeResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentLyophilize,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],

			Priority -> Lookup[safeOps,Priority],
			StartDate -> Lookup[safeOps,StartDate],
			HoldOrder -> Lookup[safeOps,HoldOrder],
			QueuePosition -> Lookup[safeOps,QueuePosition],

			ConstellationMessage->Object[Protocol,Lyophilize],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentLyophilize,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* --- Container Overload --- *)

(* Note: The container overload should come after the sample overload. *)
ExperimentLyophilize[myContainers:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..}, myOptions:OptionsPattern[ExperimentLyophilize]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,sampleCache,
		containerToSampleTests, inputSamples, samplesOptions, aliquotResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationCache, updatedCache},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentLyophilize,
			ToList[myContainers],
			ToList[myOptions]
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

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentLyophilize, myOptionsWithPreparedSamples, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentLyophilize, myOptionsWithPreparedSamples, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		containerToSampleOptions[ExperimentLyophilize, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache, Output -> {Result, Tests}],
		{containerToSampleOptions[ExperimentLyophilize, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];

	(* Update our cache with our new simulated values. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions, sampleCache} = containerToSampleResult;

	(* call ExperimentLyophilize and get all its outputs *)
	aliquotResults = ExperimentLyophilize[inputSamples, ReplaceRule[samplesOptions,Cache->updatedCache]];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, aliquotResults}
		],
		{outputSpecification -> aliquotResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentLyophilize call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection::Closed:: *)
(*resolveExperimentLyophilizeOptions *)


DefineOptions[resolveExperimentLyophilizeOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveExperimentLyophilizeOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentLyophilizeOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,samplePrepOptions,lyophilizeOptions,simulatedSamples,
		resolvedSamplePrepOptions,simulatedCache,samplePrepTests,lyophilizeOptionsAssociation,fastTrack,
		samplePacketsToCheckIfDiscarded,discardedSamplePackets,discardedInvalidInputs,discardedTest,
		modelPacketsToCheckIfDeprecated,deprecatedModelPackets,deprecatedInvalidInputs,deprecatedTest,preResTemperature,
		preResPressure,instTempPrecision,instPressurePrecision,instTimePrecision,tempPrecision,pressurePrecision,
		preResolvedLyoAssociation,roundedLyophilizeOptions,precisionTests,maxProbeSamples,probeSamplesInvalidOptions,
		probeSamplesTest,unresProbeSamples,messages,simulatedSamplePacks,sampleModelPackets,cacheBall,
		profileTimeErrorQ,profileTimeInvalidOptions,profileTimeInvalidTest,probeSamplesSamplesInInvalidOptions,
		maxLyoTimeTooLowQ,maxLyoTimeTooLowInvalidOptions,maxLyoTimeTooLowTest,validSampleStorageConditionQ,
		invalidStorageConditionOptions,invalidStorageConditionTest,uniqueContainers,containerTypeTally,tooManyContainersBool,
		tooManyContainersInvalidInputs,tooManyContainersTest,samplesInStorageTemperatures,lyoTimeGreaterThanProfileWarning,
		temperatureToProfileConflictWarning,pressureToProfileConflictWarning,maxLyoError,unresInst,unResProfile,unResTemp,
		unResPres,lyoTime,maxLyoTime,residTemp,residPres,lyoTillDry,unresPreFreeze,	resInst,resProfile,resTemp,resPres,
		resLyoTime,resMaxLyoTime,resLyoTilDry,resPreFreeze,samplesInStorage,samplesOutStorage,invalidInputs,invalidOptions,
		targetContainers,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,allTests,possibleCoverPackets,
		sampleContainerPacks,sampleContainerModelPacks,resCover,resPerforate
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Seperate out our Lyophilize options from our Sample Prep options. *)
	{samplePrepOptions,lyophilizeOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{
		{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},
		samplePrepTests
	} = If[gatherTests,
		resolveSamplePrepOptions[ExperimentLyophilize,mySamples,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentLyophilize,mySamples,samplePrepOptions,Cache->cache,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	lyophilizeOptionsAssociation = Association[lyophilizeOptions];

	(* Determine if this is getting run with FastTrack *)
	fastTrack = Lookup[lyophilizeOptionsAssociation,FastTrack];

	{simulatedSamplePacks,sampleModelPackets,samplesInStorageTemperatures,sampleContainerPacks,sampleContainerModelPacks} = Quiet[
		Transpose@Download[
			simulatedSamples,
			{
				Packet[Name,Container,Position,Status,State,Volume,Sterile,StorageCondition],
				Packet[Model[{Name,Deprecated,Status}]],
				StorageCondition[Temperature],
				Packet[Container[{Model}]],
				Packet[Container[Model][{Footprint}]]
			},
			Cache -> simulatedCache
		],
		Download::FieldDoesntExist
	];

	(* Build the cacheball from simulated cache and our new download *)
	cacheBall = FlattenCachePackets[
		Cases[
			Join[simulatedCache,cache,simulatedSamplePacks,sampleModelPackets,sampleContainerPacks,sampleContainerModelPacks],
			PacketP[]
		]
	];

	(* Gather the caps and seals that may be used during this experiment *)
	possibleCoverPackets = Cases[
		cacheBall,
		AssociationMatchP[<|Pierceable->_|>,AllowForeignKeys->True]|AssociationMatchP[<|Breathable->_|>,AllowForeignKeys->True]
	];

	(*-- INPUT VALIDATION CHECKS --*)

	(* get all the sample packets together that are going to be checked for whether they are discarded *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	samplePacketsToCheckIfDiscarded = Cases[simulatedSamplePacks, PacketP[Object[Sample]]];

	(* get the samples that are discarded; if on the FastTrack, don't bother checking *)
	discardedSamplePackets = If[Not[fastTrack],
		Select[samplePacketsToCheckIfDiscarded, MatchQ[Lookup[#, Status], Discarded]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {PacketP[]..}] && messages,
		(
			Message[Error::DiscardedSamples, Lookup[discardedSamplePackets, Object, {}]];
			Lookup[discardedSamplePackets, Object, {}]
		),
		Lookup[discardedSamplePackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[samplePacketsToCheckIfDiscarded],
				Nothing,
				Test["Provided input samples " <> ObjectToString[Download[Complement[samplePacketsToCheckIfDiscarded, discardedInvalidInputs], Object], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Determine how many unique containers are in the protocol *)
	uniqueContainers = DeleteDuplicates@Download[Lookup[simulatedSamplePacks,Container],Object,Cache->cacheBall];

	(* Calculate how many containers of each type we have *)
	containerTypeTally = Tally[
		DeleteCases[Flatten[uniqueContainers],_String,Infinity](* Remove id strings *)
	];

	(* Calculate whether we have too many containers to be container in the instrument *)
	tooManyContainersBool = If[Not[fastTrack],
		MemberQ[
			containerTypeTally,
			Alternatives[
				{TypeP[Object[Container,Plate]],GreaterP[6]}
			]
		]
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManyContainersInvalidInputs = If[TrueQ[tooManyContainersBool] && messages,
		(
			Message[Error::LyophilizeContainerMaximum];
			uniqueContainers
		),
		Nothing
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyContainersTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[TrueQ[tooManyContainersBool],
				Test["The number of containers provided was below the loading limit of the instrument's deck.", True, False],
				Nothing
			];

			passingTest = If[TrueQ[tooManyContainersBool],
				Nothing,
				Test["The number of containers provided was below the loading limit of the instrument's deck.", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets = If[Not[fastTrack],
		Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Cache -> cacheBall] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* Because the Temperature and Pressure options can be given to us in various forms, we should first format the options *)
	{preResTemperature, preResPressure} = Which[

		(* If the option value is automatic we can return it since RoundOptionPrecision will pass us back Automatic *)
		MatchQ[#,Automatic],
			#,

		(* If the option value is already a list of list, leave it. We'll check it later *)
		MatchQ[#,{{TimeP,_}..}],
			#,

		(* Otherwise we need to expand it to have any time values we can find *)
		(* If the option value is a single temperature value, check the other options for time values *)
		MatchQ[#,TemperatureP],

			Which[

				(* If TemperaturePressureProfile has values, use the times from that option *)
				MatchQ[Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile],{{TimeP,TemperatureP,PressureP}..}],
					Transpose[
						Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile][[All,1]],
						Table[#,Length[Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile]]]
					],

				(* If LyophilizationTime was provided*)
				MatchQ[Lookup[lyophilizeOptionsAssociation,LyophilizationTime],TimeP],
					{{0Minute,#},{Lookup[lyophilizeOptionsAssociation,LyophilizationTime],#}},

				(* If Pressure has time values, use those *)
				MatchQ[Lookup[lyophilizeOptionsAssociation,Pressure],{{TimeP,PressureP}..}],
					Transpose[
						Lookup[lyophilizeOptionsAssociation,Pressure][[All,1]],
						Table[#,Length[Lookup[lyophilizeOptionsAssociation,Pressure]]]
					],

				(* If MaxLyophilizationTime was provided*)
				MatchQ[Lookup[lyophilizeOptionsAssociation,MaxLyophilizationTime],TimeP],
					{{0Minute,#},{Lookup[lyophilizeOptionsAssociation,MaxLyophilizationTime],#}},

					(* We have no where else to look for time values so simply return the temperature *)
				True,
					#
			],

		(* If the option value is a single pressure value, check the other options for time values *)
		MatchQ[#,PressureP],

			Which[

				(* If TemperaturePressureProfile has values, use the times from that option *)
				MatchQ[Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile],{{TimeP,TemperatureP,PressureP}..}],
					Transpose[
						Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile][[All,1]],
						Table[#,Length[Lookup[lyophilizeOptionsAssociation,TemperaturePressureProfile]]]
					],

				(* If LyophilizationTime was provided*)
				MatchQ[Lookup[lyophilizeOptionsAssociation,LyophilizationTime],TimeP],
					{{0Minute,#},{Lookup[lyophilizeOptionsAssociation,LyophilizationTime],#}},

				(* If Temperature has time values, use those *)
				MatchQ[Lookup[lyophilizeOptionsAssociation,Temperature],{{TimeP,TemperatureP}..}],
					Transpose[
						Lookup[lyophilizeOptionsAssociation,Temperature][[All,1]],
						Table[#,Length[Lookup[lyophilizeOptionsAssociation,Temperature]]]
					],

				(* If MaxLyophilizationTime was provided*)
				MatchQ[Lookup[lyophilizeOptionsAssociation,MaxLyophilizationTime],TimeP],
					{{0Minute,#},{Lookup[lyophilizeOptionsAssociation,MaxLyophilizationTime],#}},

				(* We have no where else to look for time values so simply return the temperature *)
				True,
					#
			],

		(* Our option value isn't Automatic, a Temperature, or a Pressure, so don't try to handle it any differently *)
		True,
			#

	]&/@Lookup[lyophilizeOptionsAssociation,{Temperature,Pressure}];(* Map the block above over Pressure and Temperature options *)

	instTempPrecision = 1.`Celsius;
	instPressurePrecision = 1.`Millitorr;
	instTimePrecision = .001Hour;

	(* Determine which precisions we should use *)
	{tempPrecision,pressurePrecision} = Which[

		(* If we're given a time/value tuple, then return a listed set of precisions *)
		MatchQ[#,{{TimeP,_}..}],
			Which[
				MatchQ[#[[1,2]],TemperatureP], {instTimePrecision,instTempPrecision},
				MatchQ[#[[1,2]],PressureP], {instTimePrecision,instPressurePrecision},
				True, {instTimePrecision,1.`}
			],

		(* If we're working with a single temp value, return a temp *)
		MatchQ[#,TemperatureP],
			instTempPrecision,

		(* If we're working with a single pressure value, return a pressure *)
		MatchQ[#,PressureP],
			instPressurePrecision,

		(* If we're working with anything else (Automatic or a problematic value) return a unitless 1. for the precision *)
		True,
			1.`
	]&/@{preResTemperature, preResPressure};

	(* Substitute our pre-resolved options back into our options associations *)
	preResolvedLyoAssociation = Append[
		lyophilizeOptionsAssociation,
		{Temperature->preResTemperature, Pressure->preResPressure}
	];

	(* ensure that all the numerical options have the proper precision *)
	{roundedLyophilizeOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			preResolvedLyoAssociation,
			{
				TemperaturePressureProfile,
				Temperature,
				Pressure,
				LyophilizationTime,
				MaxLyophilizationTime,
				ResidualTemperature,
				ResidualPressure
			},
			{
				{instTimePrecision,instTempPrecision,instPressurePrecision},
				tempPrecision,
				pressurePrecision,
				instTimePrecision,
				instTimePrecision,
				instPressurePrecision,
				instPressurePrecision
			}, Output -> {Result, Tests}],
		{RoundOptionPrecision[
			preResolvedLyoAssociation,
			{
				TemperaturePressureProfile,
				Temperature,
				Pressure,
				LyophilizationTime,
				MaxLyophilizationTime,
				ResidualTemperature,
				ResidualPressure
			},
			{
				{instTimePrecision,instTempPrecision,instPressurePrecision},
				tempPrecision,
				pressurePrecision,
				instTimePrecision,
				instTimePrecision,
				instPressurePrecision,
				instPressurePrecision
			},
			Output -> Result
		],{}}
	];

	{
		lyoTimeGreaterThanProfileWarning,
		temperatureToProfileConflictWarning,
		pressureToProfileConflictWarning,
		maxLyoError
	} = Table[
		False,
		Length[{
			lyoTimeGreaterThanProfileWarning,
			temperatureToProfileConflictWarning,
			pressureToProfileConflictWarning,
			maxLyoError
		}]
	];


	(* Make some variables for our unresolved option values *)
	{
		unResProfile,
		unResTemp,
		unResPres,
		lyoTime,
		maxLyoTime,
		residPres,
		residTemp,
		lyoTillDry,
		unresInst,
		unresProbeSamples,
		unresPreFreeze
	} = Lookup[
		roundedLyophilizeOptions,
		{
			TemperaturePressureProfile,
			Temperature,
			Pressure,
			LyophilizationTime,
			MaxLyophilizationTime,
			ResidualPressure,
			ResidualTemperature,
			LyophilizeUntilDry,
			Instrument,
			ProbeSamples,
			PreFrozenSamples
		}
	];

	(* Resolve PreFrozenSamples *)
	resPreFreeze = If[MatchQ[unresPreFreeze,Automatic],

		(* Automatically resolve to True/False based on whether any of the samples' present storage condition is NOT Freezer, DeepFreezer, or CryogenicFreezer *)
		(* We can only set PreFrozenSamples to True if all samples have been stored below -20, as we need to know ALL samples are frozen *)
		(* TODO: Work off of samples' expected frozen *)
		MatchQ[samplesInStorageTemperatures,{LessEqualP[-20Celsius]..}],

		(* If it wasn't automatic, use the author's *)
		unresPreFreeze
	];

	(* Resolve TemperateurePressureProfile *)
	resProfile = Module[
		{builtProfile},

		(* Determine where to get our info for our profile construction*)
		builtProfile = Which[

			(* If we were given a full profile, ensure it starts at 0Hour but otherwise return it*)
			MatchQ[unResProfile,{{TimeP,TemperatureP,PressureP}..}],

				(* If the first timepoint of the sorted profile is not 0, append a timepoint there *)
				Module[{sortedUnResProf},

					(* Sort the timepoints by the time values *)
					sortedUnResProf = SortBy[unResProfile,First];

					(* If the starting point isn't 0Minutes then we need to prepend that to our profile *)
					If[!PossibleZeroQ[Unitless[First[First[sortedUnResProf]]]],
						Prepend[sortedUnResProf,{0.`*Minute,First[sortedUnResProf][[2]],First[sortedUnResProf][[3]]}],
						sortedUnResProf
					]
				],

			(* Otherwise we have to combine Pressure *)
			MatchQ[unResProfile,Automatic] && Or[MatchQ[unResTemp,{{TimeP,TemperatureP}..}],MatchQ[unResPres,{{TimeP,PressureP}..}]],

				(* We'll build a profile out of the pressure, time and temperature values we were given *)
				Module[
					{lastKnownTimepoint,nonAutomaticTemp,nonAutomaticPressure,specifiedTimePoints,fullTempsList,fullPresList},

					(* Determine the last timepoint we were given *)
					lastKnownTimepoint = Max[
						Cases[
							Join[ToList[unResTemp],ToList[unResPres]],
							TimeP,
							Infinity
						]
					];

					(* Convert any automatics into default time points and make sure any single values are converted to timepoints *)
					nonAutomaticTemp = If[MatchQ[unResTemp,Automatic|TemperatureP],

						(* Since we didn't get any times here, set the start point, and we'll expand the list of times later *)
						{{0.`Hour, Replace[unResTemp,Automatic -> -20.`Celsius]},{lastKnownTimepoint,Replace[unResTemp,Automatic -> -20.`Celsius]}},

						(* We got a list of timepoints so we can return them after we sort them by time *)
						Module[{sortedUnResTemp},
							sortedUnResTemp = SortBy[unResTemp,First];
							If[!PossibleZeroQ[Unitless[First[First[sortedUnResTemp]]]],
								Prepend[sortedUnResTemp,{0.`*Minute,Last[First[sortedUnResTemp]]}],
								sortedUnResTemp
							]
						]
					];

					(* Convert any automatics into default time points and make sure any single values are converted to timepoints *)
					nonAutomaticPressure = If[MatchQ[unResPres,Automatic|PressureP],

						(* Since we didn't get any times here, set the start point, and we'll expand the list of times later *)
						{{0.`Hour, Replace[unResPres,Automatic -> 100*Millitorr]},{lastKnownTimepoint,Replace[unResPres,Automatic -> 100*Millitorr]}},

						(* We got a list of timepoints so we can return them after we sort them by time *)
						Module[{sortedUnResPres},
							sortedUnResPres = SortBy[unResPres,First];
							If[!PossibleZeroQ[Unitless[First[First[sortedUnResPres]]]],
								Prepend[sortedUnResPres,{0.`*Minute,Last[First[sortedUnResPres]]}],
								sortedUnResPres
							]
						]
					];

					(* Build the list of all times specified in the timepoints we found/built, delete the duplicates, then sort them *)
					specifiedTimePoints = Sort@DeleteDuplicates[
						Convert[
							Join[nonAutomaticTemp[[All,1]],nonAutomaticPressure[[All,1]]],
							Minute
						],
						Equal
					];

					(* Make sure the times found aren't all 0 minutes then proceed with gradient interpolation *)
					{fullTempsList,fullPresList} = If[!MatchQ[specifiedTimePoints,{EqualP[0Minute]..}],

						(* Use an interpolation function to build a new list of temperature values that is index matched to our timepoints *)
						(* getInterpolationValuesForTimes currently requires times are in Minutes. Since we just need Temp/Pres values
						we can conver the time values in those points into minutes temporarily. The units of the final profile willl remain
						in the correct units as given by the user *)
						{
							Experiment`Private`getInterpolationValuesForTimes[nonAutomaticTemp/.timeX:TimeP:>Convert[timeX,Minute],specifiedTimePoints],
							Experiment`Private`getInterpolationValuesForTimes[nonAutomaticPressure/.timeX:TimeP:>Convert[timeX,Minute],specifiedTimePoints]
						},

						(* Otherwise we encountered a timing error. We'll doublecheck this again later on and throw a hard error further down,
						so for now just make a stand-in gradient *)
						With[{maxLength = Max[Length[nonAutomaticTemp],Length[nonAutomaticPressure]]},
							{
								{First@Cases[nonAutomaticTemp,TemperatureP,Infinity]},
								{First@Cases[nonAutomaticPressure,PressureP,Infinity]}
							}
						]
					];

					(* Now we have all the times, all the temps, and pressures. Put them together to build our profile *)
					(* Take[..] is added here to avoid errors where we'll throw a LyophilizationTimeZero below so we only have 1 temp and one pressure to transpose here *)
					Transpose[{specifiedTimePoints,fullTempsList,Take[fullPresList,Length[specifiedTimePoints]]}]
				],

			(* Our samples are pre-frozen, and we don't have a profile so we have to start from scratch using whatever temperature, pressure and lyo time we were given *)
			TrueQ[resPreFreeze],
				Module[
					{timePoints,defaultedGradient},

					(* Build a list of timepoints, such that Lyo time is roughly divided according to the default lyo gradient *)
					timePoints = If[MatchQ[lyoTime,Automatic],
						{0.`Hour,1*Hour,2.`Hour,15.`Hour,20.`Hour},

						{
							0.`Hour,
							SafeRound[lyoTime*(1/20),1Minute],
							SafeRound[lyoTime*(1/20),1Minute],
							SafeRound[lyoTime*(3/4),1Minute],
							lyoTime
						}
					];

					(* Build a default gradient, but use any temp, time or pressure values provided as single values by the user *)
					defaultedGradient = {
						{0.`*Hour,Replace[unResTemp,Automatic -> 25.`*Celsius],Replace[unResPres,Automatic -> 900.`*Millitorr]},
						{timePoints[[2]],Replace[unResTemp,Automatic -> -40.`*Celsius],Replace[unResPres,Automatic-> 900.`*Millitorr]},
						{timePoints[[3]],Replace[unResTemp,Automatic -> -40.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]},
						{timePoints[[4]],Replace[unResTemp,Automatic -> -20.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]},
						{timePoints[[5]],Replace[unResTemp,Automatic -> 25.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]}
					}
				],

			(* We don't have a profile so we have to start from scratch using whatever temperature, pressure and lyo time we were given *)
			True,
				Module[
					{timePoints,defaultedGradient},

					(* Build a list of timepoints, such that Lyo time is roughly divided according to the default lyo gradient *)
					timePoints = If[MatchQ[lyoTime,Automatic],
						{0.`Hour,10.`Hour,12.`Hour,13 Hour,24.`Hour},

						{
							0.`Hour,
							SafeRound[lyoTime*(10/24),1Minute],
							SafeRound[lyoTime*(12/24),1Minute],
							SafeRound[lyoTime*(13/24),1Minute],
							lyoTime
						}
					];

					(* Build a default gradient, but use any temp, time or pressure values provided as single values by the user *)
					(* NOTE: The following gradient was given to me by Conway, Chris <Chris.Conway@scientificproducts.com> *)
					(* the technicians use this default gradient when testing out the instrument. *)
					defaultedGradient = {
						(* If our samples aren't pre-frozen, then freeze them at -40 Celsius for 10 hours first, by default. *)
						{0.`*Hour,Replace[unResTemp,Automatic -> -40.`*Celsius],Replace[unResPres,Automatic -> 1*Atmosphere]},
						{timePoints[[2]],Replace[unResTemp,Automatic -> -40.`*Celsius],Replace[unResPres,Automatic-> 1*Atmosphere]},

						(* Then drop the pressure down to 101 mTorr over 2 hours. *)
						{timePoints[[3]],Replace[unResTemp,Automatic -> -40.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]},

						(* Then turn on the heat to 20 Celsius for 12 hours. *)
						{timePoints[[4]],Replace[unResTemp,Automatic -> 20.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]},
						{timePoints[[5]],Replace[unResTemp,Automatic -> 20.`*Celsius],Replace[unResPres,Automatic-> 101.`*Millitorr]}
					}
				]
		];

		If[
			(* If the lyo time is greater than the last time point of the profile: *)
			!MatchQ[lyoTime,Automatic] && Greater[lyoTime,First[Last[builtProfile]]],

			(
				(* Firs throw save a warning that we're expanding the profile to match Lyo time *)
				lyoTimeGreaterThanProfileWarning = True;

				(* Then build an additional time point at the end of the lyo time with the same values as the end of the profile *)
				Append[builtProfile,{lyoTime,Last[builtProfile][[2]],Last[builtProfile][[3]]}]
			),

			(* Othwerise we're fine to return the value we determined above *)
			builtProfile
		]
	];

	(* Determine if the Temperature option conflicts with TemperaturePressureProfile *)
	resTemp = Which[

		(* Temperature was automatic or a single temperature value so use the temperature portion of the resolved TemperaturePressureProfile *)
		MatchQ[unResTemp,Automatic|TemperatureP],
			resProfile[[All,{1,2}]],

		(* Temperature was provided as a gradient but TemperaturePressureProfile was also provided, so check they don't conflict *)
		MatchQ[unResTemp,{{TimeP,TemperatureP}..}] && MatchQ[unResProfile,{{TimeP,TemperatureP,PressureP}..}],

			If[

				(* Make sure each point in the specified temperature option showed up in the temperature profile *)
				And@@(MatchQ[#,Alternatives@@(SortBy[unResProfile[[All,{1,2}]],First])]&/@SortBy[unResTemp,First]),

				(* We've made sure each timepoint in Temperature showed up in the TemperatureProfile so return the temp gradient *)
				SortBy[unResTemp,First],

				(* We determined there was a problem so set an warning to True and return the user value *)
				(
					temperatureToProfileConflictWarning = True;
					SortBy[unResTemp,First]
				)
			],

		(* Temperature was provided but Profile was not so we can just return the temp gradient without problem *)
		True,
			SortBy[unResTemp,First]
	];

	(* Determine if the Temperature option conflicts with TemperaturePressureProfile *)
	resPres = Which[

		(* Temperature was automatic or a single temperature value so use the temperature portion of the resolved TemperaturePressureProfile *)
		MatchQ[unResPres,Automatic|PressureP],
			resProfile[[All,{1,3}]],

		(* Temperature was provided as a gradient but TemperaturePressureProfile was also provided, so check they don't conflict *)
		MatchQ[unResPres,{{TimeP,PressureP}..}] && MatchQ[unResProfile,{{TimeP,TemperatureP,PressureP}..}],

			If[

				(* Make sure each point in the specified temperature option showed up in the temperature profile *)
				And@@(MatchQ[#,Alternatives@@(SortBy[unResProfile[[All,{1,3}]],First])]&/@SortBy[unResPres,First]),

				(* We've made sure each timepoint in Temperature showed up in the TemperatureProfile so return the temp gradient *)
				SortBy[unResPres,First],

				(* We determined there was a problem so set an warning to True and return the user value *)
				(
					pressureToProfileConflictWarning = True;
					SortBy[unResPres,First]
				)
			],

		(* Temperature was provided but Profile was not so we can just return the temp gradient without problem *)
		True,
			SortBy[unResPres,First]
	];

	(* Get the lyophilization time *)
	resLyoTime = If[MatchQ[lyoTime,TimeP],
		lyoTime,
		First[Last[resProfile]]
	];

	(* Get the max lyophiliztaion time *)
	resMaxLyoTime = Which[

		(* MaxLyoTime is Automatic and LyTilDry is true so we must default it *)
		MatchQ[maxLyoTime,Automatic] && Or[TrueQ[lyoTillDry],MemberQ[lyoTillDry,True]],

			(* We have to default lyo time so make it three times the lyo time *)
			3*resLyoTime,

		(* MaxLyoTime is a Time and LyoTilDry is True so just return that *)
		MatchQ[maxLyoTime,TimeP] && Or[TrueQ[lyoTillDry],MemberQ[lyoTillDry,True]],
			maxLyoTime,

		(* MaxLyoTime is Null and LyoTilDry is True, return max lyo time but stash an error *)
		MatchQ[maxLyoTime,Null] && Or[TrueQ[lyoTillDry],MemberQ[lyoTillDry,True]],
			(
				maxLyoError = True;
				maxLyoTime
			),

		(* We've determine LyoTillDry is false so if we see a time throw an error *)
		MatchQ[maxLyoTime,TimeP] && !Or[TrueQ[lyoTillDry],MemberQ[lyoTillDry,True]],
			(
				maxLyoError = True;
				maxLyoTime
			),

		(* Otherwise we don't care so return MaxLyo with a of Automatic to Null *)
		True,
			Replace[maxLyoTime,Automatic->Null]
	];

	(* If LyophilizeUntilDry -> Automatic and a MaxLyophilizationTime was provided, set LyophilizeUntilDray to True*)
	resLyoTilDry = If[MatchQ[lyoTillDry,Automatic],

		(* To resolve the Automatic, check MaxLyophilization time and make sure the resolved max lyo time and lyo time are not equal *)
		If[MatchQ[maxLyoTime,TimeP] && !EqualQ[resMaxLyoTime,resLyoTime],
			True,
			False
		],

		(* Otherwise just use what the user gave us *)
		lyoTillDry
	];

	(* Resolve the instrument option by default the automatic value *)
	resInst = Replace[unresInst,Automatic -> Model[Instrument, Lyophilizer, "id:KBL5Dvw6MWxJ"]];(*"Advantage Pro EL Freeze Dryer"*)

	(* Resolve ContainerCover *)
	resCover = MapThread[
		If[MatchQ[#1,Automatic|BreathableSeal],

			(* Automatic resolution: Determine which type of cover to use. When possible include a cover *)
			Which[

				(* For 50mL tubes, resolve to default breathable 50mL caps *)
				MatchQ[Lookup[#2,Footprint],Conical50mLTube],
					Model[Item, Cap, "50 mL Bio-Reaction Vented Tube Cap"],

						(* For plates, resolve to the default breathable plate seal *)
				MatchQ[Lookup[#2,Footprint],Plate],
					Model[Item, PlateSeal, "id:vXl9j57mandN"],

				(* For vessels, we can put Chemwipes on vessels but not plates and resolve as such *)
				MatchQ[#2,ObjectP[{Model[Container,Vessel]}]],
					Chemwipe,

				(* This container likely can't handle covers *)
				True,
					Null
			],

			(* Otherwise leave the user's option in place *)
			#1
		]&,
		{
			Lookup[roundedLyophilizeOptions,ContainerCover],
			sampleContainerModelPacks
		}
	];

	(* Resolve the perforate cover option *)
	resPerforate = MapThread[
		If[MatchQ[#1,Automatic],

			Which[
				(* If no cover will be used, specify Null for PerforateCover *)
				NullQ[#2],
					Null,

				(* If Chemwipe is the cover, set PerforateCover to False *)
				MatchQ[#2,Chemwipe],
					False,

				(* If the cover model provided is not breathable and it is pierceable set it to True *)
				MatchQ[
					Lookup[Experiment`Private`fetchPacketFromCache[Download[#2,Object],cacheBall],{Breathable,Pierceable}],
					{False|Null,True}
				],
					True,

				True,
					Null
			],

			(* Otherwise leave the user's option in place *)
			#1
		]&,
		{
			Lookup[roundedLyophilizeOptions,PerforateCover],
			resCover
		}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check that the number of probe samples provided isn't too great. Throw an error if it is and we're not gathering tests *)
	maxProbeSamples = 4;
	probeSamplesInvalidOptions = If[
		And[
			!NullQ[unresProbeSamples],
			Greater[Length[ToList[unresProbeSamples]],maxProbeSamples]
		],

		(
			(* Throw the corresopnding error. *)
			If[!gatherTests,
				Message[
					Error::NotEnoughProbes,
					maxProbeSamples,(* Max ProbeSamples allowed *)
					Length[ToList[unresProbeSamples]],(* Number Provided *)
					ObjectToString[ToList[unresProbeSamples], Cache -> cacheBall](* Samples provided *)
				]
			];

			{ProbeSamples}
		),

		{}
	];

	(* Make sure Probe Samples are members of the simulated samples *)
	probeSamplesSamplesInInvalidOptions = If[
		And[
			!NullQ[unresProbeSamples],
			!ContainsAll[
				Download[simulatedSamples,Object],
				Download[ToList[unresProbeSamples],Object]
			]
		],

		(
			(* Throw the corresopnding error. *)
			If[!gatherTests,
				Message[
					Error::ProbeSamplesInvalid,
					ObjectToString[ToList[unresProbeSamples], Cache -> cacheBall],
					ObjectToString[ToList[simulatedSamples], Cache -> cacheBall]
				]
			];

			{ProbeSamples}
		),

		{}
	];

	(* Double check the LyophilizationTime wasn't requested to be greater than the MaxLyophilizationTime *)
	maxLyoTimeTooLowQ = !MatchQ[maxLyoTime,Automatic] && !MatchQ[lyoTime,Automatic] && GreaterQ[lyoTime,maxLyoTime];

	(* If we have an error, stash LyophilizationTime and MaxLyophilizationTime as invalid options *)
	maxLyoTimeTooLowInvalidOptions = If[TrueQ[maxLyoTimeTooLowQ],

		(* We do have an error *)
		(* If not gathering tests, throw an error *)
		(
			If[!gatherTests,
				Message[Error::InvalidMaxLyoTime,maxLyoTime,lyoTime]
			];
			{MaxLyophilizationTime,LyophilizationTime}
		),

		(* No Error was detected so empty list it *)
		{}
	];

	(* Build a test to make sure this isn't the case *)
	maxLyoTimeTooLowTest = If[gatherTests,

		(* If the error was thrown, compare the two values in the test *)
		If[TrueQ[maxLyoTimeTooLowQ],
			Test["The MaxLyophilizationTime is greater than or equal to the LyophilizationTime",maxLyoTime,lyoTime],
			(* Otherwise just return a test that is True *)
			Test["The MaxLyophilizationTime is greater than or equal to the LyophilizationTime",True,True]
		],

		(* If we're not gatherting tests, just return empty list *)
		{}
	];

	(* Now we have to check that the resProfile is > 0 min long *)
	profileTimeErrorQ = Module[
		{profTimePoints,maxTimePoint},

		(* Get all of the time points out of the resolved profile *)
		profTimePoints = Sort[resProfile[[All,1]]];

		(* Get the max time point *)
		maxTimePoint = Max[Flatten@profTimePoints];

		!Greater[maxTimePoint,0.`Minute]
	];

	(* If we have an error, determine which errors caused the error *)
	profileTimeInvalidOptions = If[TrueQ[profileTimeErrorQ],

		(* No we have to determine if the TemperaturePressureProfile given was wrong or if there were multiple contributing factors *)
		If[MatchQ[unResProfile,{{EqualP[0Minute],TemperatureP,PressureP}}],

			(* We established the user asked for a dumb profile so just blame the profile *)
			{TemperaturePressureProfile},

			(* Otherwise there must have been multiple options provided to make this dumb profile. Figure out which weren't automatic and blame them *)
			PickList[
				{TemperaturePressureProfile,Pressure,Temperature,LyophilizationTime},
				{unResProfile,unResPres,unResTemp,lyoTime},
				Except[Automatic]
			]
		],

		(* No Error was detected so empty list it *)
		{}
	];

	(* Throw an error if we're not gathering tests and we found something wrong *)
	If[!gatherTests && TrueQ[profileTimeErrorQ],
		Message[Error::LyophilizationTimeZero,profileTimeInvalidOptions]
	];

	(* Make a test *)
	profileTimeInvalidTest = If[gatherTests,

		(* Make a test based on what the bool was *)
		Test["The resolved TemperaturePressureProfile has a time greater than 0 minutes in length:",TrueQ[profileTimeErrorQ],False],

		(* Otherwise we're not making tests so don't bother making one *)
		{}
	];

	(*get the samplesIn and SamplesOut Storage Options*)
	{samplesInStorage,samplesOutStorage}=Lookup[roundedLyophilizeOptions,{SamplesInStorageCondition,SamplesOutStorageCondition}];

	validSampleStorageConditionQ=If[!MatchQ[samplesInStorage,ListableP[Automatic|Null]],
		If[!gatherTests,
			ValidContainerStorageConditionQ[mySamples,samplesInStorage],
			Quiet[ValidContainerStorageConditionQ[mySamples,samplesInStorage]]
		],
		True
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(* generate test for storage condition *)
	invalidStorageConditionTest=Test[
		"The specified SamplesInStorageCondition can be filled for sample in a particular container or for samples sharing a container:",
		And@@validSampleStorageConditionQ,
		True
	];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,tooManyContainersInvalidInputs,deprecatedInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{probeSamplesInvalidOptions,probeSamplesSamplesInInvalidOptions,maxLyoTimeTooLowInvalidOptions,profileTimeInvalidOptions,invalidStorageConditionOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* We don't care what container they use and after resolving aliquot info we will check container compatibility *)
	targetContainers=Null;

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids->True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentLyophilize,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache -> cacheBall,RequiredAliquotAmounts->Null,RequiredAliquotContainers->targetContainers,AllowSolids->True,Output->{Result,Tests}],
		{resolveAliquotOptions[ExperimentLyophilize,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache -> cacheBall,RequiredAliquotAmounts->Null,RequiredAliquotContainers->targetContainers,AllowSolids->True,Output->Result],{}}
	];


	(* Stash all of our tests *)
	allTests = Flatten[{
		samplePrepTests,
		discardedTest,
		tooManyContainersTest,
		deprecatedTest,
		precisionTests,
		(*probeSamplesTest,*) (*probeSamplesTest is not defined above. commenting this out*)
		profileTimeInvalidTest,
		maxLyoTimeTooLowTest,
		invalidStorageConditionTest
	}];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];


	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> ReplaceRule[
			Join[Normal[roundedLyophilizeOptions],samplePrepOptions],
			Join[
				{
					Instrument -> resInst,
					TemperaturePressureProfile -> resProfile,
					Temperature -> resTemp,
					Pressure -> resPres,
					LyophilizationTime -> resLyoTime,
					MaxLyophilizationTime -> resMaxLyoTime,
					LyophilizeUntilDry -> resLyoTilDry,
					ResidualPressure -> Replace[residPres,Automatic -> 1.`Torr],
					PreFrozenSamples -> resPreFreeze,
					ResidualTemperature -> Replace[residTemp,Automatic -> 20.`Celsius],
					PerforateCover -> resPerforate,
					ContainerCover -> resCover,
					SamplesInStorageCondition -> samplesInStorage,
					SamplesOutStorageCondition -> samplesOutStorage
				},
				resolvedSamplePrepOptions,
				resolvedAliquotOptions,
				resolvedPostProcessingOptions
			]
		],
		Tests -> allTests
	}
];



(* ::Subsection::Closed:: *)
(*lyophilizeResourcePackets *)


DefineOptions[lyophilizeResourcePackets,
	Options :> {HelperOutputOption, CacheOption}
];



lyophilizeResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:Alternatives[{_Rule..},{}],myResolvedOptions:{_Rule..},myOptions:OptionsPattern[]]:=Module[
	{safeOps,outputSpecification,output,gatherTests,messages,inheritedCache,parentProtocol,resolvedOptionsNoHidden,
		simulatedSampObjects,simulatedCache,simulatedSamps,samplesPackets,containerPackets,containerModelPackets,
		samplesInResourceMap,samplesInResources,containersIn,containersInResources,lyophilizationTotalTime,instrumentResource,protocolPacket,protocolID,
		sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule,
		lyoTillDry,probeSamplesResources,coversExpanded,coversPerContainer,coverResources},

	(* Stash safe options *)
	safeOps = SafeOptions[lyophilizeResourcePackets,ToList[myOptions]];

	(* Determine the requested output format of this function. *)
	outputSpecification = Lookup[safeOps,Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* get the cache that was passed from the main function *)
	inheritedCache= Lookup[safeOps,Cache,{}];

	(* Store the ParentProtocol of the protocol being created *)
	parentProtocol = Lookup[myResolvedOptions,ParentProtocol];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentLyophilize,
		RemoveHiddenOptions[ExperimentLyophilize, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Regenerate the simulations done in the option resolver *)
	{simulatedSampObjects,simulatedCache} = simulateSamplesResourcePackets[ExperimentLyophilize,mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Pull the sample packets from the simulated cache *)
	simulatedSamps = cacheLookup[simulatedCache,#,Object]&/@simulatedSampObjects;

	{samplesPackets,containerPackets,containerModelPackets} = Transpose@Download[
		simulatedSamps,
		{
			(* Sample Packet *)Packet[Composition,Model],
			(* Container Packet *)Packet[Container[{Model,Contents,Container,Position}]],
			(* Container Model Packet *)Packet[Container[Model][{Dimensions}]]
		},
		Cache->simulatedCache
	];

	(* create containers in and samples in lists; use original input lists to start,
	 removing any indices that we cut out (this only happens if ParentProtocol is not Null) *)
	samplesInResourceMap = Map[
		(# -> Resource[Sample->#, Name->ToString[Unique[]], ThawRequired->False])&,
		DeleteDuplicates[Lookup[samplesPackets,Object]]
	];

	(* Now replace our samples in list with resources for them *)
	samplesInResources = Lookup[samplesInResourceMap,#]&/@Lookup[samplesPackets,Object];

	(* ContainersIn should be a duplicate free list *)
	containersIn = DeleteDuplicates[Lookup[containerPackets,Object]];

	containersInResources=Map[
		Resource[Sample->#, ThawRequired->False]&,
		containersIn
	];

	(* Determine if we're suppose to lyo till dry *)
	lyoTillDry = If[MatchQ[Lookup[resolvedOptionsNoHidden,LyophilizeUntilDry],BooleanP],
		ConstantArray[Lookup[resolvedOptionsNoHidden,LyophilizeUntilDry],Length[mySamples]],
		Lookup[resolvedOptionsNoHidden,LyophilizeUntilDry]
	];

	(* Calculate how long the total time will be *)
	lyophilizationTotalTime = If[Or[TrueQ[lyoTillDry],MemberQ[lyoTillDry,True]],
		Lookup[resolvedOptionsNoHidden,MaxLyophilizationTime],
		Lookup[resolvedOptionsNoHidden,LyophilizationTime]
	];

	(* Generate a resource for the insturment *)
	instrumentResource = Resource[
		Instrument -> Lookup[resolvedOptionsNoHidden,Instrument],
		Time -> lyophilizationTotalTime
	];

	(* Generate a list of ProbeSamples resources, that are a subset of SamplesIn *)
	probeSamplesResources = Download[
		Lookup[resolvedOptionsNoHidden,ProbeSamples],
		Object,
		Cache->simulatedCache
	]/.samplesInResourceMap;

	(* Expand Covers to be index matched all the way in case only a single option was passed *)
	coversExpanded = If[MatchQ[Lookup[resolvedOptionsNoHidden,ContainerCover],_List],
		Lookup[resolvedOptionsNoHidden,ContainerCover],
		Table[Lookup[resolvedOptionsNoHidden,ContainerCover],Length[mySamples]]
	];
	(* Since we already error-checked that only one cover model (or chemwipe) per container, group then take the first for each container *)
	coversPerContainer = First[First[#]]&/@GatherBy[Transpose[{coversExpanded,containerPackets}],Last];

	(* Now replace any Item Cap and plate seal covers with their own resource *)
	coverResources = coversPerContainer/.{
		Chemwipe->Null,
		capObj:ObjectP[{Model[Item,Cap],Object[Item,Cap],Model[Item,PlateSeal],Object[Item,PlateSeal]}]:>Link@Resource[Sample->capObj, Name->ToString[Unique[]]]
	};

	(* Create ID *)
	protocolID = CreateID[Object[Protocol,Lyophilize]];

	protocolPacket = <|
		Object -> protocolID,
		Type -> Object[Protocol,Lyophilize],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden,
		ParentProtocol -> Link[parentProtocol,Subprotocols],
		Replace[ContainersIn] -> (Link[#,Protocols]&)/@containersInResources,
		Replace[SamplesIn] -> (Link[#,Protocols]&/@samplesInResources),
		Replace[TemperaturePressureProfile] -> Lookup[myResolvedOptions,TemperaturePressureProfile],
		Replace[TemperatureGradient] -> Lookup[myResolvedOptions,TemperaturePressureProfile][[All,{1,2}]],
		Replace[PressureGradient] -> Lookup[myResolvedOptions,TemperaturePressureProfile][[All,{1,3}]],
		LyophilizationTime -> Lookup[myResolvedOptions,LyophilizationTime],
		MaxLyophilizationTime -> Lookup[myResolvedOptions,MaxLyophilizationTime],
		Replace[ProbeSamples] -> (Link/@probeSamplesResources),
		Instrument -> Link[instrumentResource],
		PreFrozenSamples -> Lookup[myResolvedOptions,PreFrozenSamples],
		Replace[LyophilizeUntilDry] -> lyoTillDry,
		Replace[FullyLyophilized] -> ConstantArray[False,Length[samplesInResources]],
		ResidualTemperature -> Lookup[myResolvedOptions,ResidualTemperature],
		ResidualPressure -> Lookup[myResolvedOptions,ResidualPressure],
		Replace[ContainerCovers] -> coverResources,
		Replace[PerforateCover] -> Lookup[myResolvedOptions,PerforateCover],
		Replace[SamplesInStorage] -> Lookup[myResolvedOptions,SamplesInStorageCondition],
		Replace[SamplesOutStorage] -> Lookup[myResolvedOptions,SamplesOutStorageCondition],

		Replace[Checkpoints] -> {
			{"Preparing Samples", 5*Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time -> 0*Minute]]},
			{"Picking Resources",If[NullQ[parentProtocol],5 Minute,1 Minute],"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> If[NullQ[parentProtocol],5 Minute,1 Minute]]]},
			{"Lyophilizing Samples",Convert[lyophilizationTotalTime,Minute] * 1.1,"Samples are placed into the instrument and then undergo sublimation to remove unwanted solvents.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> Length[containersIn]*7 Minute]]},
			{"Returning Materials",5 Minute,"Samples are returned to storage.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 5 Minute]]}
		}
	|>;

	(* Get the prep options to populate resources and field values *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[protocolPacket,sharedFieldPacket];

	(* Gather the resources blobs we've created *)
	allResourceBlobs = DeleteDuplicates[Cases[Values[finalizedPacket], _Resource, Infinity]];

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
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];
