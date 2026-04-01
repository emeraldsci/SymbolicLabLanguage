(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*WaterPreparation*)


(* ::Subsubsection:: *)
(*ExperimentWaterPreparation defaults *)
$DefaultWaterSourceInstrumentFlushTime = 10 Second;
$DefaultRinseContainerTimePerLiter = 5 (Second/Liter);
$MaxRinseContainerTime = 15 Second;
$DefaultRinseCapTime = 3 Second;
$DefaultNumberOfContainerRinses = 2;
$DefaultNumberOfCapRinses = 2;
$WaterSourceInstruments = allWaterSourcesSearch["Memoization"];

(* ::Subsubsection:: *)
(*ExperimentWaterPreparation Options*)


DefineOptions[ExperimentWaterPreparation,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
				{
					OptionName -> WaterSourceInstrument,
					Default -> Automatic,
					Description -> "The water purifier or sink that supplies the water sample generated.",
					AllowNull -> False,
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Instrument, WaterPurifier], Object[Instrument, WaterPurifier], Model[Instrument, Sink], Object[Instrument, Sink]}]
					],
					ResolutionDescription -> "Automatically set to the Model[Instrument] with WaterGenerated that is the same the input water model.",
					Category -> "General"
				},
				{
					OptionName -> WaterSourceInstrumentFlushTime,
					Default -> Automatic,
					Description -> "The duration for which water run through the lines of the WaterSourceInstrument when corresponding index-matching WaterSourceInstrumentFlush is True, in order to rid the lines stagnant water prior to use. Flushing is only done once right before the washing and dispensing of the first water generation for a batch of water resources utilizing the same WaterSourceInstrument.",
					ResolutionDescription -> "Automatically set to $DefaultWaterSourceInstrumentFlushTime.",
					AllowNull -> True,
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Second],
						Units -> {Second, {Second, Minute}}
					],
					Category -> "General"
				},
				{
					OptionName -> RinseContainer,
					Default -> True,
					Description -> "Indicates if the water is ran along the inner surface of the container, for a duration of RinseContainerTime, in order to remove contaminants.",
					AllowNull -> False,
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Category -> "General"
				},
				{
					OptionName -> RinseContainerTime,
					Default -> Automatic,
					Description -> "The duration that water run along the inner surface of the container in order to remove contaminants.",
					ResolutionDescription->"If RinseContainer is set to True, set to 10 seconds per 1 Liter of MaxVolume of the container.",
					AllowNull -> True,
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Second],
						Units -> {Second, {Second, Minute}}
					],
					Category -> "General"
				},
				{
					OptionName -> NumberOfContainerRinses,
					Default -> Automatic,
					AllowNull -> True,
					Widget -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					],
					Description -> "The number of times water is ran along the inner surface of the container,  for a duration of RinseContainerTime each time, in order to remove contaminants.",
					ResolutionDescription -> "Automatically set to 2 if RinseContainer is set to True. Otherwise, is set to Null.",
					Category -> "General"
				},
				{
					OptionName -> RinseCap,
					Default -> True,
					Description -> "Indicates if the water is ran along the inner surface of the cap, for a duration of RinseCapTime each time, in order to remove contaminants.",
					AllowNull -> False,
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Category -> "General"
				},
				{
					OptionName -> RinseCapTime,
					Default -> Automatic,
					Description -> "The duration that water run along the inner surface of the cap in order to remove contaminants.",
					ResolutionDescription->"If RinseCap is set to True, automatically set to $DefaultRinseCapTime.",
					AllowNull -> True,
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Second],
						Units -> {Second, {Second, Minute}}
					],
					Category -> "General"
				},
				{
					OptionName -> NumberOfCapRinses,
					Default -> Automatic,
					AllowNull -> True,
					Widget -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					],
					Description -> "The number of times water is ran along the inner surface of the cap,  for a duration of RinseCapTime each time, in order to remove contaminants.",
					ResolutionDescription -> "Automatically set to 2 if RinseCap is set to True. Otherwise, is set to Null.",
					Category -> "General"
				},
				{
					OptionName->PreparedResources,
					Default->Null,
					AllowNull->True,
					Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Resource,Sample]],ObjectTypes->{Object[Resource,Sample]}],
					Description->"Model resources in the ParentProtocol that are being transferred into an appropriate container model by this experiment call.",
					Category->"Hidden"
				}
		],
		ProtocolOptions,
		SimulationOption,
		OutputOption,
		CacheOption
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentWaterPreparation Source Code *)
Error::InvalidWaterSourceInstrument="The WaterSourceInstrument specified (`1`) are not valid for the respective input water models (`2`) at indices (`3`). Please specify an instrument that has a WaterGenerated field value matching that of the input water model, respectively OR allow to automatically resolve.";
Error::InvalidRinseContainerTime="The RinseContainerTime (`1`) are not valid for the RinseContainer (`2`) at indices (`3`). RinseContainerTime can only be specified as a quantity if, and only if, RinseContainer is True. Please modify the specified options or allow to resolve automatically.";
Error::InvalidRinseCapTime="The RinseCapTime (`1`) are not valid for the RinseCap (`2`) at indices (`3`). RinseCapTime can only be specified as a quantity if, and only if, RinseCap is True. Please modify the specified options or allow to resolve automatically.";
Error::InvalidNumberOfContainerRinses="The NumberOfContainerRinses (`1`) are not valid for the RinseContainer (`2`) at indices (`3`). NumberOfContainerRinses can only be specified as an integer if, and only if, RinseContainer is True. Please modify the specified options or allow to resolve automatically.";
Error::InvalidNumberOfCapRinses="The NumberOfCapRinses (`1`) are not valid for the RinseCap (`2`) at indices (`3`). NumberOfCapRinses can only be specified as an integer if, and only if, RinseCap is True. Please modify the specified options or allow to resolve automatically.";
Error::InvalidPreparedResources="The PreparedResources (`1`) are not valid for the input water models (`2`) at indices (`3`). The model requested in the resource must match the input water model. Please modify the specified options or allow to resolve automatically.";
Error::OverfilledContainer="The specified amount(s) (`1`) cannot be handled by the MaxVolume of the specified container(s) (`2`). Please modify the input amount to be less than the MaxVolume of the specified container.";

(*ExperimentWaterPreparation*)

(* ExperimentWaterPreparation[a, b, c] -> Experiment[{a}, {b}, {c}] *)
ExperimentWaterPreparation[
	myWaterModels:ObjectP[List @@ WaterModelP],
	myDestination:ObjectP[{Object[Container], Model[Container]}],
	myAmount:VolumeP,
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[{myWaterModels}, {myDestination}, {myAmount}, myOptions];

(* ExperimentWaterPreparation[{a, a, a}, b, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myDestination:ObjectP[{Object[Container], Model[Container]}],
	myAmount:VolumeP,
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[myWaterModels, ConstantArray[myDestination, Length[myWaterModels]], ConstantArray[myAmount, Length[myWaterModels]], myOptions];


(* ExperimentWaterPreparation[a, b, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	mySource:ObjectP[List @@ WaterModelP],
	myDestination:ObjectP[{Object[Container], Model[Container]}],
	myAmounts:{VolumeP..},
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[ConstantArray[mySource, Length[myAmounts]], ConstantArray[myDestination, Length[myAmounts]], myAmounts, myOptions];


(* ExperimentWaterPreparation[a, {b, b, b}, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	mySource:ObjectP[List @@ WaterModelP],
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmount:VolumeP,
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[ConstantArray[mySource, Length[myContainers]], myContainers, ConstantArray[myAmount, Length[myContainers]], myOptions];


(* ExperimentWaterPreparation[{a, a, a}, {b, b, b}, c] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmount:VolumeP,
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[myWaterModels, myContainers, ConstantArray[myAmount, Length[myContainers]], myOptions];


(* ExperimentWaterPreparation[{a, a, a}, b, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myDestination:ObjectP[{Object[Container], Model[Container]}],
	myAmounts:{VolumeP..},
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[myWaterModels, ConstantArray[myDestination, Length[myWaterModels]], myAmounts, myOptions];


(* ExperimentWaterPreparation[a, {b, b, b}, {c, c, c}] -> Experiment[{a, a, a}, {b, b, b}, {c, c, c}] *)
ExperimentWaterPreparation[
	mySource:ObjectP[List @@ WaterModelP],
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmounts:{VolumeP
		..},
	myOptions:OptionsPattern[]
] := ExperimentWaterPreparation[ConstantArray[mySource, Length[myContainers]], myContainers, myAmounts, myOptions];


(* -- Main Overload --*)
ExperimentWaterPreparation[
	myWaterModels:ListableP[ObjectP[List @@ WaterModelP]],
	myContainers:ListableP[ObjectP[{Object[Container], Model[Container]}]],
	myAmounts:ListableP[VolumeP],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedOptions,cache,outputSpecification,output,gatherTests,messages,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,waterPrepOptionsAssociation,listedAmounts,listedDestinations,
		listedSources,initialSimulation,

		objectsExistTests,objectsExistQs,simulatedSampleQ,userSpecifiedObjects,
		
		suppliedWaterSourceInstrument,
		suppliedPreparedResources,
		parentProtocol,

		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePacketTests,
		result,resourceResult,performSimulationQ,returnEarlyBecauseFailuresQ,simulatedProtocol,simulation,
		
		waterSourceInstruments,
		
		sourcesWithoutTemporalLinks, destinationsWithoutTemporalLinks, listedSourcesNamed, listedDestinationsNamed,
		safeOpsNamed, listedOptionsNamed, returnEarlyBecauseOptionsResolverOnly, optionsResolverOnly, initialFastAssoc,
		
		

		listedSourcesAndDests,
		allDownloadedStuff, userSpecifiedObjectsStatus, notDiscardedSampleQs, samplesNotDiscardedTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;
	
	(* remove all temporal links *)
	(* quieting because we could throw an ObjectDoesNotExist error here, but if we do we will already do that in a more robust way later so silence it for now *)
	{{sourcesWithoutTemporalLinks, destinationsWithoutTemporalLinks}, listedOptionsNamed} = removeLinks[{myWaterModels, myContainers}, ToList[myOptions]];

	cache = Lookup[listedOptionsNamed, Cache, {}];
	initialFastAssoc = makeFastAssocFromCache[cache];
	initialSimulation = Lookup[listedOptionsNamed, Simulation, Null];
	
	listedSourcesNamed= ToList[sourcesWithoutTemporalLinks];
	listedDestinationsNamed= ToList[destinationsWithoutTemporalLinks];
	listedAmounts=ToList[myAmounts];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentWaterPreparation,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentWaterPreparation,listedOptionsNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	(* important for the first variable here to be a signle one because it could return $Failed and we don't want a set error *)
	{listedSourcesAndDests, safeOps, listedOptions} = sanitizeInputs[{listedSourcesNamed, listedDestinationsNamed}, safeOpsNamed, listedOptionsNamed, Simulation -> initialSimulation];
	{listedSources, listedDestinations} = If[MatchQ[listedSourcesAndDests, $Failed],
		{$Failed, $Failed},
		listedSourcesAndDests
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

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentWaterPreparation,{listedSources,listedDestinations,listedAmounts},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentWaterPreparation,{listedSources,listedDestinations,listedAmounts},listedOptions],Null}
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
		ApplyTemplateOptions[ExperimentWaterPreparation,{listedSources,listedDestinations,listedAmounts},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentWaterPreparation,{listedSources,listedDestinations,listedAmounts},listedOptions],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentWaterPreparation,{listedSources,listedDestinations,listedAmounts},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* - Throw an error if any of the specified input objects or objects in Options are not members of the database - *)
	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{listedSources,listedDestinations,myOptions}],
		ObjectReferenceP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = TrueQ[fastAssocLookup[initialFastAssoc, #, Simulated]]&/@userSpecifiedObjects;
	objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False], Simulation->initialSimulation];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	userSpecifiedObjectsStatus = Quiet[
		Download[userSpecifiedObjects, Status, Cache -> cache, Simulation -> initialSimulation],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
	];

	notDiscardedSampleQs = MatchQ[#, Except[Discarded]]& /@ userSpecifiedObjectsStatus;

	(* Build tests for discarded samples *)
	samplesNotDiscardedTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` has not been discarded:"][#1], #2, True]&,
			{userSpecifiedObjects, notDiscardedSampleQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@notDiscardedSampleQs),
		If[!gatherTests,
			Message[Error::DiscardedSamples, PickList[userSpecifiedObjects, notDiscardedSampleQs, False]];
			Message[Error::InvalidInput, PickList[userSpecifiedObjects, notDiscardedSampleQs, False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, objectsExistTests, samplesNotDiscardedTests],
			Options -> safeOps,
			Preview -> Null
		}]
	];
	
	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	waterPrepOptionsAssociation=Association[expandedSafeOps];

	(* --- make our big Download here so we can pass our cache to the resolver and to the resource packets function --- *)
	
	{
		suppliedWaterSourceInstrument,
		suppliedPreparedResources,
		parentProtocol
	} = Lookup[waterPrepOptionsAssociation,
		{
			WaterSourceInstrument,
			PreparedResources,
			ParentProtocol
		}
	];

	(* Resolve our sample prep options *)
	waterSourceInstruments = DeleteDuplicates[Download[Join[$WaterSourceInstruments, Cases[Flatten[suppliedWaterSourceInstrument],ObjectP[]]],Object]];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	allDownloadedStuff = Quiet[
		Download[
			{
				listedDestinations,
				waterSourceInstruments,
				{parentProtocol},
				suppliedPreparedResources
			},
			{
				{
					Packet[Model[{MaxVolume}]],
					Packet[Model, Cover],
					Packet[MaxVolume]
				},
				{
					Packet[MaxFlowRate, WaterGenerated],
					Packet[Model[{MaxFlowRate, WaterGenerated}]],
					Packet[Model, WaterReservoir, WaterSample, WaterGenerated, StorageCapacity],
					Packet[Objects[{WaterReservoir, WaterSample, WaterGenerated}]]
				},
				{
					Packet[ParentProtocol, PreparedResources, OutputUnitOperations, Site, Author]
				},
				{
					Packet[RentContainer,Models]
				}
			},
			Cache -> cache,
			Simulation -> initialSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[{cache, allDownloadedStuff}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentWaterPreparationOptions[
			listedSources,
			listedDestinations,
			listedAmounts,
			expandedSafeOps,
			Simulation->initialSimulation,
			Cache->cacheBall,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentWaterPreparationOptions[
				listedSources,
				listedDestinations,
				listedAmounts,
				expandedSafeOps,
				Simulation->initialSimulation,
				Cache->cacheBall
			],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentWaterPreparation,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* NOTE: We need to perform simulation if Result is asked for in Transfer since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Simulation];

	(* If option resolution failed (or we're asked to return early) and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options-> RemoveHiddenOptions[ExperimentWaterPreparation,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* resourceResult is in the form {protocolPacket, unitOperationPackets} or $Failed. *)
	{resourceResult, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		MatchQ[gatherTests, True],
			waterPreparationResourcePackets[
				listedSources,
				listedDestinations,
				listedAmounts,
				templatedOptions,
				resolvedOptions,
				Simulation -> initialSimulation,
				Cache -> cacheBall,
				Output -> {Result, Tests}
			],
		True,
			{
				waterPreparationResourcePackets[
					listedSources,
					listedDestinations,
					listedAmounts,
					templatedOptions,
					resolvedOptions,
					Simulation -> initialSimulation,
					Cache -> cacheBall
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentWaterPreparation[
			resourceResult,
			listedSources,
			listedDestinations,
			listedAmounts,
			resolvedOptions,
			Cache->cacheBall,
			Simulation->initialSimulation,
			ParentProtocol->Lookup[safeOps,ParentProtocol]
		],
		{Null, initialSimulation}
	];
	
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentWaterPreparation,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
		
		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				resourceResult[[1]], (* protocolPacket *)
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, WaterPreparation],
				Cache -> cacheBall,
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentWaterPreparation, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];

(* ::Subsection:: *)
(* resolveExperimentWaterPreparationOptions *)

DefineOptions[
	resolveExperimentWaterPreparationOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentWaterPreparationOptions[
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmounts:{VolumeP..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveExperimentWaterPreparationOptions]
]:=Module[
	{
		outputSpecification,
		output,
		gatherTests,
		messages,
		warnings,
		cache,
		fastAssoc,
		simulation,
		fastAssocKeysIDOnly,
		waterPreparationOptions,
		resolvedOptions,
		mapThreadFriendlyResolvedOptions,
		
		
		(* supplied Options *)
		suppliedWaterSourceInstrument,
		suppliedWaterSourceInstrumentFlushTime,
		suppliedRinseContainer,
		suppliedRinseContainerTime,
		suppliedRinseCapTime,
		suppliedNumberOfContainerRinses,
		suppliedNumberOfCapRinses,
		suppliedPreparedResources,
		parentProtocol,
		
		resolvedWaterSourceInstrument,
		resolvedWaterSourceInstrumentFlushTime,
		resolvedRinseContainer,
		resolvedRinseContainerTime,
		resolvedRinseCap,
		resolvedRinseCapTime,
		resolvedNumberOfContainerRinses,
		resolvedNumberOfCapRinses,
		
		invalidWaterSourceInstrumentErrors,
		invalidRinseContainerTimeErrors,
		invalidRinseCapTimeErrors,
		invalidNumberOfContainerRinsesErrors,
		invalidNumberOfCapRinsesErrors,
		invalidPreparedResourcesErrors,
		overfilledErrors,
		
		invalidWaterSourceInstrumentErrorsTest,
		invalidRinseContainerTimeErrorsTest,
		invalidRinseCapTimeErrorsTest,
		invalidNumberOfContainerRinsesErrorsTest,
		invalidNumberOfCapRinsesErrorsTest,
		invalidPreparedResourcesErrorsTest,
		overfilledErrorsTest,
		
		waterPreparationOptionsAssociation,
		
		(* *)
		optionsAndPrecisions, roundedOptions, roundedOptionTests,
		mapThreadFriendlyOptions,
		
		(* Final *)
		invalidInputs, invalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	(* warnings assume we're not in engine; if we are they are not surfaced *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;
	warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	fastAssoc = makeFastAssocFromCache[cache];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* get the fastAssoc Keys, but only the ones in the ID form (not the name form) *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];

	(* Separate out our Transfer options from our Sample Prep options. *)
	waterPreparationOptions=myOptions;
	
	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	waterPreparationOptionsAssociation = Association[waterPreparationOptions];

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedWaterSourceInstrument,
		suppliedWaterSourceInstrumentFlushTime,
		suppliedRinseContainer,
		suppliedRinseContainerTime,
		suppliedRinseCapTime,
		suppliedNumberOfContainerRinses,
		suppliedNumberOfCapRinses,
		suppliedPreparedResources,
		parentProtocol
	}=Lookup[waterPreparationOptionsAssociation,
		{
			WaterSourceInstrument,
			WaterSourceInstrumentFlushTime,
			RinseContainer,
			RinseContainerTime,
			RinseCapTime,
			NumberOfContainerRinses,
			NumberOfCapRinses,
			PreparedResources,
			ParentProtocol
		}
	];

	(* -- SETUP ERROR CHECKING -- *)
	
	invalidWaterSourceInstrumentErrors = {};
	invalidRinseContainerTimeErrors = {};
	invalidRinseCapTimeErrors = {};
	invalidNumberOfContainerRinsesErrors = {};
	invalidNumberOfCapRinsesErrors = {};
	invalidPreparedResourcesErrors = {};
	overfilledErrors = {};

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	
	(* -- ROUND OUR OPTIONS -- *)

	(* NOTE: We need to do further precision checks after we've done our resolving to make sure that our instruments can *)
	(* actually achieve the precisions that were asked for. *)
	optionsAndPrecisions={
		{RinseContainerTime, 1 Second},
		{RinseCapTime, 1 Second},
		{WaterSourceInstrumentFlushTime, 1 Second}
	};

	{roundedOptions,roundedOptionTests} = If[!messages,
		RoundOptionPrecision[Association@waterPreparationOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]],Output->{Result,Tests}],
		{RoundOptionPrecision[Association@waterPreparationOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]]],{}}
	];
	
	(* Convert our options into a MapThread friendly version. *)
	(* Also replace with our pre-resolved multichannel options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentWaterPreparation,
		roundedOptions
	];
	
	{
		(*1*)resolvedWaterSourceInstrument,
		(*2*)resolvedWaterSourceInstrumentFlushTime,
		(*3*)resolvedRinseContainer,
		(*4*)resolvedRinseContainerTime,
		(*5*)resolvedRinseCap,
		(*6*)resolvedRinseCapTime,
		(*7*)resolvedNumberOfContainerRinses,
		(*8*)resolvedNumberOfCapRinses
	}=Transpose@MapThread[
		Function[{waterModel, container, amount, manipulationIndex, options},
			Module[
				{
					filteredWaterSourceInstruments,
					waterSourceInstrument,
					waterSourceInstrumentFlushTime,
					rinseContainer,
					rinseContainerTime,
					rinseCap,
					rinseCapTime,
					numberOfContainerRinses,
					numberOfCapRinses,
					preparedResources,
					
					containerMaxVolume
				},
				
				waterSourceInstrument = If[MatchQ[Lookup[options,WaterSourceInstrument],Except[Automatic]],
						Lookup[options,WaterSourceInstrument],
					
						(* Select models that generate the correct water model *)
						filteredWaterSourceInstruments=Select[
							$WaterSourceInstruments,
							MatchQ[fastAssocLookup[fastAssoc, #, WaterGenerated], ObjectP[waterModel]]&
						];
						
						(*Further refine based on storage capacity - if no storage capacity is available (eg sinks), set to 1 in order for RandomChoice to work since RandomChoice only works on positive values *)
						RandomChoice[
							((Unitless[Convert[fastAssocLookup[fastAssoc,#,StorageCapacity]&/@filteredWaterSourceInstruments,Liter]])/.($Failed|Null->1))
								->filteredWaterSourceInstruments
						]
				];
				
				waterSourceInstrumentFlushTime = If[
					MatchQ[Lookup[options,WaterSourceInstrumentFlushTime],Except[Automatic]],
						Lookup[options,WaterSourceInstrumentFlushTime],
						$DefaultWaterSourceInstrumentFlushTime
				];
				
				rinseContainer = Lookup[options, RinseContainer];
				
				rinseContainerTime = Which[
					MatchQ[Lookup[options,RinseContainerTime],Except[Automatic]],
					Lookup[options,RinseContainerTime],
					
					(* 5 second per Liter of container MaxVolume, and maxed at 30 seconds *)
					MatchQ[rinseContainer,True]&&MatchQ[container,ObjectP[Model[Container]]],
					Min[Ceiling[fastAssocLookup[fastAssoc, container, MaxVolume], 1 Liter] * $DefaultRinseContainerTimePerLiter, $MaxRinseContainerTime],
					
					MatchQ[rinseContainer,True]&&MatchQ[container,ObjectP[Object[Container]]],
					Min[Ceiling[fastAssocLookup[fastAssoc, fastAssocLookup[fastAssoc, container, Model], MaxVolume], 1 Liter] * $DefaultRinseContainerTimePerLiter, $MaxRinseContainerTime],
					
					True,
					Null
					
				];
				
				numberOfContainerRinses = Which[
					MatchQ[Lookup[options,NumberOfContainerRinses],Except[Automatic]],
					Lookup[options,NumberOfContainerRinses],
					
					MatchQ[rinseContainer, True],
					$DefaultNumberOfContainerRinses,
					
					True,
					Null
				];
				
				rinseCap = Lookup[options, RinseCap];
				
				rinseCapTime = Which[
					MatchQ[Lookup[options,RinseCapTime],Except[Automatic]],
					Lookup[options,RinseCapTime],
					
					(* 5 second per Liter of container MaxVolume, and maxed at 30 seconds *)
					MatchQ[rinseCap,True],
					$DefaultRinseCapTime,
					
					True,
					Null
				
				];
				
				numberOfCapRinses = Which[
					MatchQ[Lookup[options,NumberOfCapRinses],Except[Automatic]],
					Lookup[options,NumberOfCapRinses],
					
					MatchQ[rinseContainer, True],
					$DefaultNumberOfCapRinses,
					
					True,
					Null
				];
				
				(* Errors and Warnings *)
				(* WaterSourceInstrument is specific to WaterGenerated *)
				If[
					And[
						MatchQ[Lookup[options,WaterSourceInstrument],ObjectP[]],
						!MatchQ[fastAssocLookup[fastAssoc,Lookup[options,WaterSourceInstrument],WaterGenerated],ObjectP[waterModel]]
					],
					AppendTo[invalidWaterSourceInstrumentErrors,{Lookup[options,WaterSourceInstrument], waterModel, manipulationIndex}]
				];
				
				(* RinseContainerTime can only be a quantity if RinseContainer is True. Otherwise, Null *)
				If[
					Or[
						MatchQ[Lookup[options, RinseContainer],True]&&MatchQ[Lookup[options,RinseContainerTime],Null],
						MatchQ[Lookup[options, RinseContainer],False]&&MatchQ[Lookup[options,RinseContainerTime],_Quantity]
					],
					AppendTo[invalidRinseContainerTimeErrors,{Lookup[options,RinseContainer], Lookup[options, RinseContainerTime], manipulationIndex}]
				];
				
				(* NumberOfContainerRinses can only be an integer if RinseContainer is True. Otherwise, Null *)
				If[
					Or[
						MatchQ[Lookup[options, RinseContainer],True]&&MatchQ[Lookup[options,NumberOfContainerRinses],Null],
						MatchQ[Lookup[options, RinseContainer],False]&&MatchQ[Lookup[options,NumberOfContainerRinses],_Integer]
					],
					AppendTo[invalidNumberOfContainerRinsesErrors,{Lookup[options,RinseContainer], Lookup[options, RinseContainerTime], manipulationIndex}]
				];
				
				(* RinseCapTime can only be a quantity if RinseCap is True. Otherwise, Null *)
				If[
					Or[
						MatchQ[Lookup[options, RinseCap],True]&&MatchQ[Lookup[options,RinseCapTime],Null],
						MatchQ[Lookup[options, RinseCap],False]&&MatchQ[Lookup[options,RinseCapTime],_Quantity]
					],
					AppendTo[invalidRinseCapTimeErrors,{Lookup[options,RinseCap], Lookup[options, RinseCapTime], manipulationIndex}]
				];
			
				(* NumberOfCapRinses can only be an integer if RinseContainer is True. Otherwise, Null *)
				If[
					Or[
						MatchQ[Lookup[options, RinseCap],True]&&MatchQ[Lookup[options,NumberOfCapRinses],Null],
						MatchQ[Lookup[options, RinseCap],False]&&MatchQ[Lookup[options,NumberOfCapRinses],_Integer]
					],
					AppendTo[invalidNumberOfCapRinsesErrors,{Lookup[options,RinseCap], Lookup[options, NumberOfCapRinses], manipulationIndex}]
				];
				
				(* check if the preparedResources is appropriate *)
				preparedResources = Lookup[options,PreparedResources];
				
				If[
					And[
						MatchQ[preparedResources,ObjectP[]],
						!MemberQ[fastAssocLookup[fastAssoc, preparedResources, Models], ObjectP[waterModel]]
					],
					AppendTo[invalidPreparedResourcesErrors, {Lookup[options, PreparedResources], waterModel, manipulationIndex}]
				];
				
				(* Check for Overfilling *)
				containerMaxVolume = If[MatchQ[container, ObjectP[Object[Container]]],
					fastAssocLookup[fastAssoc, fastAssocLookup[fastAssoc, container, Model], MaxVolume],
					fastAssocLookup[fastAssoc, container, MaxVolume]
				];
				
				If[
					MatchQ[amount, GreaterP[containerMaxVolume]],
					AppendTo[overfilledErrors,{amount, container, manipulationIndex}]
				];
				
				(* return resolved values *)
				{
					(*1*)waterSourceInstrument,
					(*2*)waterSourceInstrumentFlushTime,
					(*3*)rinseContainer,
					(*4*)rinseContainerTime,
					(*5*)rinseCap,
					(*6*)rinseCapTime,
					(*7*)numberOfContainerRinses,
					(*8*)numberOfCapRinses
				}
			]
		],
		{
			myWaterModels, myContainers, myAmounts, Range[Length[myAmounts]], mapThreadFriendlyOptions
		}
	];
	
	(* Gather these options together in a list. *)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			WaterSourceInstrument -> resolvedWaterSourceInstrument,
			WaterSourceInstrumentFlushTime -> resolvedWaterSourceInstrumentFlushTime,
			RinseContainer -> resolvedRinseContainer,
			RinseContainerTime -> resolvedRinseContainerTime,
			NumberOfContainerRinses -> resolvedNumberOfContainerRinses,
			RinseCap -> resolvedRinseCap,
			RinseCapTime -> resolvedRinseCapTime,
			NumberOfCapRinses -> resolvedNumberOfCapRinses,
			PreparedResources -> suppliedPreparedResources
		}
	];

	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentWaterPreparation,resolvedOptions];
	
	(*-- UNRESOLVABLE OPTION CHECKS --*)
	
	invalidWaterSourceInstrumentErrorsTest=If[Length[invalidWaterSourceInstrumentErrors]==0,
		Test["The specified WaterSourceInstrument is appropriate for the water model:",True,True],
		Test["The specified WaterSourceInstrument is appropriate for the water model:",False,True]
	];
	
	If[Length[invalidWaterSourceInstrumentErrors]>0&&messages,
		Message[
			Error::InvalidWaterSourceInstrument,
			ObjectToString[invalidWaterSourceInstrumentErrors[[All,1]], Cache->cache],
			ObjectToString[invalidWaterSourceInstrumentErrors[[All,2]], Cache->cache],
			invalidWaterSourceInstrumentErrors[[All,3]]
		]
	];
	
	invalidRinseCapTimeErrorsTest=If[Length[invalidRinseCapTimeErrors]==0,
		Test["The RinseCapTime is a quantity if, and only if, RinseCap is True:",True,True],
		Test["The RinseCapTime is a quantity if, and only if, RinseCap is True:",False,True]
	];
	
	If[Length[invalidRinseCapTimeErrors]>0&&messages,
		Message[
			Error::InvalidRinseCapTime,
			invalidRinseCapTimeErrors[[All,1]],
			invalidRinseCapTimeErrors[[All,2]],
			invalidRinseCapTimeErrors[[All,3]]
		]
	];
	
	invalidNumberOfCapRinsesErrorsTest=If[Length[invalidNumberOfCapRinsesErrors]==0,
		Test["The NumberOfCapRinses is a quantity if, and only if, RinseCap is True:",True,True],
		Test["The NumberOfCapRinses is a quantity if, and only if, RinseCap is True:",False,True]
	];
	
	If[Length[invalidNumberOfCapRinsesErrors]>0&&messages,
		Message[
			Error::InvalidNumberOfCapRinses,
			invalidNumberOfCapRinsesErrors[[All,1]],
			invalidNumberOfCapRinsesErrors[[All,2]],
			invalidNumberOfCapRinsesErrors[[All,3]]
		]
	];
	
	invalidPreparedResourcesErrorsTest=If[Length[invalidPreparedResourcesErrors]==0,
		Test["The model requested in the resources matches the input water model:",True,True],
		Test["The model requested in the resources matches the input water model:",False,True]
	];
	
	If[Length[invalidPreparedResourcesErrors]>0&&messages,
		Message[
			Error::InvalidPreparedResources,
			ObjectToString[invalidPreparedResourcesErrors[[All,1]], Cache->cache],
			ObjectToString[invalidPreparedResourcesErrors[[All,2]], Cache->cache],
			invalidPreparedResourcesErrors[[All,3]]
		]
	];
	
	invalidRinseContainerTimeErrorsTest=If[Length[invalidRinseContainerTimeErrors]==0,
		Test["The RinseContainerTime is a quantity if, and only if, RinseContainer is True:",True,True],
		Test["The RinseContainerTime is a quantity if, and only if, RinseContainer is True:",False,True]
	];
	
	If[Length[invalidRinseContainerTimeErrors]>0&&messages,
		Message[
			Error::InvalidRinseContainerTime,
			invalidRinseContainerTimeErrors[[All,1]],
			invalidRinseContainerTimeErrors[[All,2]],
			invalidRinseContainerTimeErrors[[All,3]]
		]
	];
	
	invalidNumberOfContainerRinsesErrorsTest=If[Length[invalidNumberOfContainerRinsesErrors]==0,
		Test["The NumberOfContainerRinses is a quantity if, and only if, RinseContainer is True:",True,True],
		Test["The NumberOfContainerRinses is a quantity if, and only if, RinseContainer is True:",False,True]
	];
	
	If[Length[invalidNumberOfContainerRinsesErrors]>0&&messages,
		Message[
			Error::InvalidNumberOfContainerRinses,
			invalidNumberOfContainerRinsesErrors[[All,1]],
			invalidNumberOfContainerRinsesErrors[[All,2]],
			invalidNumberOfContainerRinsesErrors[[All,3]]
		]
	];
	
	overfilledErrorsTest=If[Length[overfilledErrors]==0,
		Test["All containers specified can fit the specified amount:",True,True],
		Test["All containers specified can fit the specified amount:",False,True]
	];
	
	If[Length[overfilledErrors] > 0 && messages,
		Message[
			Error::OverfilledContainer,
			overfilledErrors[[All,1]],
			ObjectToString[overfilledErrors[[All,2]], Cache->cache]
		]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		overfilledErrors[[All,1]],
		overfilledErrors[[All,2]]
	}]];
	
	invalidOptions=DeleteDuplicates[Flatten[{
		If[Length[invalidWaterSourceInstrumentErrors]>0,
			{WaterSourceInstrument},
			{}
		],
		If[Length[invalidRinseCapTimeErrors]>0,
			{RinseCap, RinseCapTime},
			{}
		],
		If[Length[invalidNumberOfCapRinsesErrors]>0,
			{RinseCap, NumberOfCapRinses},
			{}
		],
		If[Length[invalidRinseContainerTimeErrors]>0,
			{RinseContainer,RinseContainerTime},
			{}
		],
		If[Length[invalidNumberOfContainerRinsesErrors]>0,
			{RinseContainer,NumberOfContainerRinses},
			{}
		],
		If[Length[invalidPreparedResourcesErrors]>0,
			{PreparedResources},
			{}
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Flatten[{
			resolvedOptions
		}],
		Tests -> Flatten[{
			invalidWaterSourceInstrumentErrorsTest,
			invalidRinseCapTimeErrorsTest,
			invalidNumberOfCapRinsesErrorsTest,
			invalidRinseContainerTimeErrorsTest,
			invalidNumberOfContainerRinsesErrorsTest,
			overfilledErrorsTest
		}]
	}
];

(* ::Subsection:: *)
(* waterPreparationResourcePackets *)

DefineOptions[
	waterPreparationResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption, OutputOption}
];

waterPreparationResourcePackets[
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmounts:{VolumeP..},
	myTemplatedOptions:{(_Rule|_RuleDelayed)...},
	myResolvedOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]
]:=Module[
	{
		expandedInputs, expandedResolvedOptions, outputSpecification, output, gatherTests, messages,
		inheritedCache, simulation, mapThreadFriendlyOptions, modifiedMapThreadFriendlyOptions, groupedWaterResourceOptions, instrumentChangePositions, waterSourceInstrumentLookup, gatheringWaterTime,
		
		finalSamplesIn,
		finalContainersIn,
		finalContainersOut,
		finalAmounts,
		finalDisplayedAmountAsVolume,
		finalWaterSourceInstruments,
		finalWaterSourceInstrumentFlushes,
		finalWaterSourceInstrumentFlushTimes,
		finalWaterSourceInstrumentFlushFlowRates,
		finalRinseContainers,
		finalRinseContainerTimes,
		finalNumberOfContainerRinses,
		finalRinseContainerFlowRates,
		finalRinseCaps,
		finalRinseCapTimes,
		finalNumberOfCapRinses,
		finalRinseCapFlowRates,
		finalPreparedResources,
		containerResources,
		
		protocolPacket,  allResourceBlobs, resourcesOk,resourceTests, testsRule, resultRule,
	    fastAssoc, fastAssocKeysIDOnly,
		parentProtocol, parentProtocolTree, rootProtocol, parentProtocolSite, upload
	},


	(* check if we are uploading or not *)
	upload = Lookup[myResolvedOptions, Upload];

	(* -- SHARED LOGIC BETWEEN ROBOTIC AND MANUAL -- *)

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentWaterPreparation, {myWaterModels, myContainers, myAmounts}, myResolvedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation = Lookup[ToList[ops],Simulation];
	fastAssoc = makeFastAssocFromCache[inheritedCache];
	(* get the fastAssoc Keys, but only the ones in the ID form (not the name form) *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];

	(* Figure out the parent protocol information *)
	parentProtocol=Lookup[myResolvedOptions,ParentProtocol,Null];
	(* recursively go up the ParentProtocol chain *)
	parentProtocolTree = If[NullQ[parentProtocol],
		{},
		Prepend[repeatedFastAssocLookup[fastAssoc, parentProtocol, ParentProtocol],parentProtocol]
	];
	rootProtocol = LastOrDefault[parentProtocolTree];
	(* If we are in a subprotocol, we must have the same site as the parent/root protocol *)
	parentProtocolSite = If[!MatchQ[parentProtocolTree,{}],
		Lookup[fetchPacketFromFastAssoc[Last[parentProtocolTree],fastAssoc],Site,Automatic]/.{Null->Automatic},
		Automatic
	];
	
	(* SamplesIn, ContainersIn and ContainersOut are updated in the Compiler *)
	finalSamplesIn = myWaterModels/.x:ObjectP[]->Link[x, Protocols];
	finalPreparedResources=Lookup[myResolvedOptions,PreparedResources]/.x:ObjectP[]->Link[x, Preparation];
	
	containerResources = MapThread[
		Resource[
			Sample->#1,
			Rent->fastAssocLookup[fastAssoc,#2,RentContainer]/.Null->True,
			Name->CreateUUID[]
		]&,
		{myContainers, finalPreparedResources}
	];
	
	finalContainersIn =If[MatchQ[#,ObjectP[Object[Container]]],
		Link[#,Protocols],
		Link[#]
	]&/@containerResources;
	
	finalContainersOut= If[MatchQ[#,ObjectP[Object[Container]]],
		Link[#,Protocols],
		Link[#]
	]&/@containerResources;
	
	finalAmounts=myAmounts;
	
	(* we're displaying in mL or L since operators are only dispensing in approximation anyway *)
	finalDisplayedAmountAsVolume = Map[
		Function[{amount},
			If[MatchQ[amount,LessP[1 Liter]],
				ToString[Ceiling[Round[Convert[amount, Milliliter], 0.1], 0.1 Milliliter]],
				ToString[Ceiling[Round[Convert[amount, Liter], 0.1], 0.1 Liter]]
			]
		],
		finalAmounts
	];
	
	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentWaterPreparation,
		myResolvedOptions
	];
	
	modifiedMapThreadFriendlyOptions = MapThread[
		Function[{options, amount},
			Append[
				options,
				{
					Amount->amount,
					WaterSourceInstrumentModel -> If[MatchQ[Lookup[options,WaterSourceInstrument], ObjectP[Object[Instrument]]],
						Download[fastAssocLookup[fastAssoc, Lookup[options,WaterSourceInstrument], Model], Object],
						Lookup[options, WaterSourceInstrument]
					],
					WaterSourceInstrumentFlowRate -> Which[
						MatchQ[Lookup[options,WaterSourceInstrument], ObjectP[Model[Instrument,WaterPurifier]]],
						fastAssocLookup[fastAssoc, Lookup[options,WaterSourceInstrument], MaxFlowRate],
						
						MatchQ[Lookup[options,WaterSourceInstrument], ObjectP[Object[Instrument,WaterPurifier]]],
						fastAssocLookup[fastAssoc, fastAssocLookup[fastAssoc, Lookup[options,WaterSourceInstrument], Model], MaxFlowRate],
						
						True,
						2 (Liter/Minute)
					]
				}
			]
		],
		{
			mapThreadFriendlyOptions,
			finalAmounts
		}
	];
	
	(* WaterFlush is done only at the beginning of a group of rinsing so group all resources that use the same instrument *)
	groupedWaterResourceOptions = GatherBy[
		modifiedMapThreadFriendlyOptions,
		Download[Lookup[#, WaterSourceInstrument],Object]&
	];
	
	(* identify the position index where there is instrument change, thus requiring a flush *)
	instrumentChangePositions = Prepend[Flatten@Position[Partition[Download[Lookup[modifiedMapThreadFriendlyOptions, WaterSourceInstrument],Object], 2, 1], {a_, b_} /; a =!= b] + 1,1];
	
	(* to determine time for each instrument resource, use the grouped resources *)
	waterSourceInstrumentLookup = Map[
		Function[{groupedOptions},
			Module[{instrument, flushTime, instrumentFlowRate, totalInstrumentTime},
				instrument = First[Lookup[groupedOptions, WaterSourceInstrument]];
				flushTime = Max[Cases[Lookup[groupedOptions, WaterSourceInstrumentFlushTime],_Quantity]/.{}->{0 Second}];
				(* WaterSourceInstrumentFlowRate is NOT an actual option but is based on the max flow rate of the instrument *)
				instrumentFlowRate = First[Lookup[groupedOptions, WaterSourceInstrumentFlowRate]];
				
				(* Total the times for Flush, Rinsing and Dispensing *)
				totalInstrumentTime  = Total[
					Cases[
						Flatten[
							{
								flushTime,
								(Cases[Lookup[groupedOptions,RinseContainerTime],_Quantity]*Cases[Lookup[groupedOptions,NumberOfContainerRinses],_Integer])*1.2,
								(Cases[Lookup[groupedOptions,RinseCapTime],_Quantity]*Cases[Lookup[groupedOptions,NumberOfCapRinses],_Integer])*1.2,
								(Total[Lookup[groupedOptions,Amount]]/instrumentFlowRate)*1.2
							}
						],
						_Quantity
					]
				];
				<|
					WaterSourceInstrument->instrument,
					WaterSourceInstrumentFlushTime->flushTime,
					Resource->Resource[
						Instrument->instrument,
						Time->totalInstrumentTime,
						Name->CreateUUID[]
					]
				|>
			]
		],
		groupedWaterResourceOptions
	];
	
	{
		finalWaterSourceInstruments,
		finalWaterSourceInstrumentFlushTimes,
		finalWaterSourceInstrumentFlushFlowRates,
		finalRinseContainers,
		finalRinseContainerTimes,
		finalRinseContainerFlowRates,
		finalNumberOfContainerRinses,
		finalRinseCaps,
		finalRinseCapTimes,
		finalRinseCapFlowRates,
		finalNumberOfCapRinses,
		finalWaterSourceInstrumentFlushes
	}=Transpose[MapIndexed[
		Function[{options, index},
			Module[
				{
					finalWaterSourceInstrument,
					finalWaterSourceInstrumentFlushTime,
					finalWaterSourceInstrumentFlushFlowRate,
					finalRinseContainer,
					finalRinseContainerTime,
					finalRinseContainerFlowRate,
					finalRinseCap,
					finalRinseCapTime,
					finalRinseCapFlowRate,
					finalWaterSourceInstrumentFlush,
					finalNumberOfContainerRinse,
					finalNumberOfCapRinse
				},
				
				finalWaterSourceInstrument = Lookup[FirstCase[
					waterSourceInstrumentLookup,
					KeyValuePattern[{WaterSourceInstrument->Download[Lookup[options,WaterSourceInstrument],Object]}]
				], Resource];
				
				finalWaterSourceInstrumentFlushTime = Lookup[options,WaterSourceInstrumentFlushTime];
				finalWaterSourceInstrumentFlushFlowRate = Lookup[options, WaterSourceInstrumentFlowRate];
				finalRinseContainer = Lookup[options,RinseContainer ];
				finalRinseContainerTime = Lookup[options,RinseContainerTime ];
				finalRinseContainerFlowRate = Lookup[options, WaterSourceInstrumentFlowRate];
				finalNumberOfContainerRinse = Lookup[options, NumberOfContainerRinses];
				finalRinseCap = Lookup[options,RinseCap];
				finalRinseCapTime = Lookup[options,RinseCapTime];
				finalRinseCapFlowRate = Lookup[options, WaterSourceInstrumentFlowRate];
				finalNumberOfCapRinse = Lookup[options, NumberOfCapRinses];
				
				(* we set Flush to True if we are in the first index or an index that requires change in instrument*)
				finalWaterSourceInstrumentFlush = If[MemberQ[instrumentChangePositions, index[[1]]],
					True,
					False
				];
				
				{
					finalWaterSourceInstrument,
					finalWaterSourceInstrumentFlushTime,
					finalWaterSourceInstrumentFlushFlowRate,
					finalRinseContainer,
					finalRinseContainerTime,
					finalRinseContainerFlowRate,
					finalNumberOfContainerRinse,
					finalRinseCap,
					finalRinseCapTime,
					finalRinseCapFlowRate,
					finalNumberOfCapRinse,
					finalWaterSourceInstrumentFlush
				}
				
			]
		],
		modifiedMapThreadFriendlyOptions
	]];

	gatheringWaterTime = Total[Lookup[Lookup[waterSourceInstrumentLookup,Resource][[All,1]],Time]];
	
	(* Generate our protocol packet *)
	protocolPacket = Association[
		Type->Object[Protocol, WaterPreparation],
		Object->CreateID[Object[Protocol, WaterPreparation]],
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentTransfer,myTemplatedOptions],
		ResolvedOptions->myResolvedOptions,
		Replace[SamplesIn]->finalSamplesIn,
		Replace[ContainersIn]->finalContainersIn,
		Replace[ContainersOut]->finalContainersOut,
		Replace[Amounts]->finalAmounts,
		Replace[DisplayedAmountAsVolume]->finalDisplayedAmountAsVolume,
		Replace[WaterSourceInstruments]->finalWaterSourceInstruments,
		Replace[WaterSourceInstrumentFlushes]->finalWaterSourceInstrumentFlushes,
		Replace[WaterSourceInstrumentFlushTimes]->finalWaterSourceInstrumentFlushTimes,
		Replace[WaterSourceInstrumentFlushFlowRates]->finalWaterSourceInstrumentFlushFlowRates,
		Replace[RinseContainers]->finalRinseContainers,
		Replace[RinseContainerTimes]->finalRinseContainerTimes,
		Replace[RinseContainerFlowRates]->finalRinseContainerFlowRates,
		Replace[NumberOfContainerRinses]->finalNumberOfContainerRinses,
		Replace[RinseCaps]->finalRinseCaps,
		Replace[RinseCapTimes]->finalRinseCapTimes,
		Replace[RinseCapFlowRates]->finalRinseCapFlowRates,
		Replace[NumberOfCapRinses]->finalNumberOfCapRinses,
		Replace[PreparedResources]->finalPreparedResources,
		Replace[ParentProtocol]->Link[parentProtocol,Subprotocols],
		Replace[Checkpoints]->{
			{"Picking Resources",2 Minute * Length[finalSamplesIn],"Containers required to execute this protocol are gathered from storage.",
				Resource[Operator -> $BaselineOperator,Time -> 2 Minute * Length[finalSamplesIn]]},
			{"Gathering Water Resources",gatheringWaterTime,"Containers are rinsed, if applicable, and water is dispensed into the containers.",
				Resource[Operator -> $BaselineOperator,Time -> gatheringWaterTime]},
			{"Returning Materials",2 Minute * Length[finalSamplesIn],"Materials no longer needed are returned to storage.",
				Resource[Operator -> $BaselineOperator,Time -> 2 Minute * Length[finalSamplesIn]]}
		}
	];
	

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket]}],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],RootProtocol->rootProtocol,Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],RootProtocol->rootProtocol,Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->inheritedCache],Null}
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
		{protocolPacket},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentWaterPreparation,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentWaterPreparation[
	myProtocolPacket:(PacketP[Object[Protocol, WaterPreparation], {Object, ResolvedOptions}]|$Failed|Null),
	myWaterModels:{ObjectP[List @@ WaterModelP]..},
	myContainers:{ObjectP[{Object[Container], Model[Container]}]..},
	myAmounts:{(VolumeP)..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentWaterPreparation]
]:=Module[
	{
		protocolObject, currentSimulation, simulation, cache, myContainerResources, containersOutObjects, containersOutSamples, protocolUpdatePacket
	},
	
	(* Lookup our cache and simulation *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	
	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol,WaterPreparation]],
		Lookup[myProtocolPacket, Object]
	];
	
	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	
	
	currentSimulation=If[MatchQ[myProtocolPacket, $Failed],
		myContainerResources = (Resource[Sample->#]&)/@myContainers;
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[ContainersIn]->myContainerResources,
				Replace[ContainersOut]->myContainerResources,
				Replace[SamplesIn]->(Link[Resource[Sample->#],Protocols]&)/@myWaterModels,
				Replace[Amounts]->myAmounts,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],
		SimulateResources[
			myProtocolPacket,
			Cache->cache,
			Simulation->simulation
		]
	];
	
	(*Downloads*)
	{
		containersOutObjects
	}=Download[protocolObject,
		{
			ContainersOut
		},
		Simulation->currentSimulation
	];
	
	(* create water samples based on input models to be contained in ContainersOut *)
	containersOutSamples = UploadSample[
		myWaterModels,
		{"A1",#}&/@containersOutObjects,
		InitialAmount->myAmounts,
		Simulation -> currentSimulation,
		UpdatedBy->protocolObject,
		Upload->False,
		SimulationMode -> True
	];
	
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[containersOutSamples]];
	
	(* update SamplesOut *)
	protocolUpdatePacket = Upload[
		Replace[SamplesOut]->Link[#, Protocols]&/@containersOutSamples,
		Volume->myAmounts,
		Simulation -> currentSimulation,
		UpdatedBy->protocolObject,
		Upload->False
	];
	
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[protocolUpdatePacket]];
	
	{
		protocolObject,
		currentSimulation
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentWaterPreparationOptions*)

DefineOptions[ExperimentWaterPreparationOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{ExperimentWaterPreparation}
];

ExperimentWaterPreparationOptions[
	myWaterModels:ListableP[ObjectP[List @@ WaterModelP]],
	myContainers:ListableP[ObjectP[{Object[Container], Model[Container]}]],
	myAmounts:ListableP[VolumeP],
	myOptions:OptionsPattern[ExperimentWaterPreparationOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},
	
	(*Get the options as a list*)
	listedOptions=ToList[myOptions];
	
	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];
	
	resolvedOptions=ExperimentWaterPreparation[myWaterModels,myContainers,myAmounts,preparedOptions];
	
	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];
	
	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentWaterPreparation],
		resolvedOptions
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentWaterPreparationQ*)

DefineOptions[ValidExperimentWaterPreparationQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentWaterPreparation}
];

ValidExperimentWaterPreparationQ[
	myWaterModels:ListableP[ObjectP[List @@ WaterModelP]],
	myContainers:ListableP[ObjectP[{Object[Container], Model[Container]}]],
	myAmounts:ListableP[VolumeP],
	myOptions:OptionsPattern[ValidExperimentWaterPreparationQ]
]:=Module[
	{listedOptions,preparedOptions,waterPreparationTests,initialTestDescription,allTests,verbose,outputFormat},
	
	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	
	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];
	
	(* Return only the tests for ExperimentWaterPreparation *)
	waterPreparationTests=ExperimentWaterPreparation[myWaterModels,myContainers,myAmounts,Append[preparedOptions,Output->Tests]];
	
	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";
	
	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[waterPreparationTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},
			
			(* Generate the initial test, which we know will pass if we got this far *)
			initialTest=Test[initialTestDescription,True,True];
			
			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[Flatten[ToList[myWaterModels,myContainers,myAmounts]],Except[ObjectP[]]],OutputFormat->Boolean];
			
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[Flatten[ToList[myWaterModels,myContainers,myAmounts]],Except[ObjectP[]]],validObjectBooleans}
			];
			
			(* Get all the tests/warnings *)
			Flatten[{initialTest,waterPreparationTests,voqWarnings}]
		]
	];
	
	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];
	
	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentWaterPreparationQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentWaterPreparationQ"]

];

(* ::Subsection:: *)
(*ExperimentWaterPreparationPreview*)

DefineOptions[ExperimentWaterPreparationPreview,
	SharedOptions:>{ExperimentWaterPreparation}
];

ExperimentWaterPreparationPreview[
	myWaterModels:ListableP[ObjectP[List @@ WaterModelP]],
	myContainers:ListableP[ObjectP[{Object[Container], Model[Container]}]],
	myAmounts:ListableP[VolumeP],
	myOptions:OptionsPattern[ExperimentWaterPreparationPreview]
]:=Module[
	{listedOptions},
	
	listedOptions=ToList[myOptions];
	
	ExperimentWaterPreparation[myWaterModels,myContainers,myAmounts,ReplaceRule[listedOptions,Output->Preview]]
];

(* ::Subsubsection::Closed:: *)
(*allWaterSourcesSearch*)

(* Function to search the database for all non-deprecated water purifier and sinks.
 	Memoizes the result after first execution to avoid repeated database trips within a single kernel session. *)
allWaterSourcesSearch[fakeString:_String] := allWaterSourcesSearch[fakeString] = Module[{},
	(*Add allWaterSourcesSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allWaterSourcesSearch];
	
	DeleteCases[Join[
		(* Water Purifiers *)
		Search[
			Model[Instrument,WaterPurifier],
			WaterGenerated==(WaterModelP)&&Deprecated!=True
		],
		Search[
			Model[Instrument,Sink],
			WaterGenerated==(WaterModelP)&&Deprecated!=True
		]
	],ObjectP[Model[Instrument, Sink, "id:7X104vPn6aoZ"]]] (* don't include the sink that is used specifically for disoolution washing station *)
];

