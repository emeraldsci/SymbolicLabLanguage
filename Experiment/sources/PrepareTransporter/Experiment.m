(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentPrepareTransporter*)

(* ::Subsubsection:: *)
(*ExperimentPrepareTransporter options*)

(* This variable defines how full we try to pack each transporter. Currently, this is set to 80%. *)
(* For simplicity, we use the inverse of 0.8 (i.e.) for calculation *)
$TransporterPackingFraction = 1.25;

DefineOptions[ExperimentPrepareTransporter,
	Options :> {
		IndexMatching[
			{
				OptionName -> Transporter,
				Default -> Automatic,
				Description -> "The portable cooler or heater to select and configure before using it to transport the input item.",
				ResolutionDescription -> "This is automatically determined based on the container size and its transporter temperature.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument, PortableHeater], Object[Instrument, PortableCooler], Model[Instrument, PortableCooler], Model[Instrument, PortableHeater]}]
				],
				Category -> "General"
			},
			{
				OptionName -> TransportTemperature,
				Default -> Automatic,
				Description -> "The temperature the portable cooler or heaters needs to be set to.",
				ResolutionDescription -> "This option is calculated from the TransportTemperature of the Object[Sample]; or if this field is not informed, it will instead match the TransportTemperature of the model.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-80 Celsius, 105 Celsius],
					Units -> Celsius
				],
				Category -> "General"
			},
			{
				OptionName -> TransporterIndex,
				Default -> Automatic,
				Description -> "An identifier for the transporter instruments being selected used to indicate if multiple instances of the same transporter model are needed.",
				ResolutionDescription -> "Different transporter models or objects will always be assigned different indices. The same transporter models will be given a single index unless there's not enough space within a single transporter to fit all input samples at a given temperature.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterEqualP[1, 1]
				],
				Category -> "Hidden"
			},
			{
				OptionName -> Resource,
				Default -> Null,
				Description -> "The resource object that needs a portable transporter, or if no resource was created the direct object being selected.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Resource, Sample], Object[Sample], Object[Container], Object[Item], Model[Container], Model[Sample], Model[Item]}]
				],
				Category -> "Hidden"
			},
			IndexMatchingInput -> "experiment samples"
		],
		{
			OptionName -> IgnoreOversizedItems,
			Default -> True,
			Description -> "Indicates if items that cannot fit into any portable coolers/heaters are removed from the input without throwing any errors.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "General"
		},
		(*===Shared Options===*)
		PreparationOption,
		ProtocolOptions,
		SimulationOption,
		SubprotocolDescriptionOption
	}
];

(* ::Subsubsection:: *)
(*ExperimentPrepareTransporter error message*)

Error::NoParentProtocol = "A standalone Object[Protocol, PrepareTransporter] is not allowed. Please specify the ParentProtocol option.";
Error::OversizedItem = "The item `1` is oversized and no portable transporters of proper temperature settings can be found to handle these items. Consider setting IgnoreOversizedItems -> True to filter out these items.";
Error::NoTransportTemperature = "TransportTemperature option of the following items `1` can't be determined. Please manually set the TransportTemperature.";
Error::UnsupportedTemperature = "No transporter can be found to fit `1` at the requested temperatures, `2`. Please adjust the TransportTemperature option.";
Warning::OversizedItem = "The items, `1`, are oversized and no portable transporters of proper temperature settings can be found to handle these items. The above item(s) will be ignored.";
Error::InsufficientTransporterSpace = "The specified transporter `1` does not have enough space to fit `2` because it has been occupied by too many other items. Please consider using a different transporter or set the option to Automatic.";
Error::InsufficientTransporterDimensions = "The specified transporter `1` cannot fit `2`. Pleas consider using a different transporter or set the option to Automatic.";
Error::InconsistentTemperatureSetting = "The specified TransportTemperature `1` for items `2` is not consistent with the current NominalTemperature of transporter `3`. Please consider changing either the Transporter or TransportTemperature option.";
Error::IncorrectTemperatureRange = "The specified TransportTemperature `1` is not within the supported temperature range of transporters `2`. Please consider changing either the Transporter or TransportTemperature option.";
Error::ConflictingTransportTemperature = "The containers `1` contain multiple samples with different TransportTemperature, therefore the TransportTemperature option cannot be automatically determined. Please specify this option manually.";

(* ::Subsubsection:: *)
(*ExperimentPrepareTransporter main function*)

ExperimentPrepareTransporter[myInputs:ListableP[ObjectP[{Object[Sample], Object[Item], Model[Item], Object[Container], Model[Container]}]], myOptions:OptionsPattern[]] := Module[
	{
		outputSpecification, listedSamples, listedOptions, output, validLengths, validLengthTests,
		safeOptionsNamed, safeOpsTests, gatherTests, samplesWithPreparedSamples, safeOps,
		templatedOptions, templateTests, inheritedOptions, upload, confirm, fastTrack, parentProtocol, cache, expandedSafeOps,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		returnEarlyQ, protocolPacket, resourcePacketTests, result, noParentProtocolTests
	},

	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	{listedSamples, listedOptions} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentPrepareTransporter, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentPrepareTransporter, listedOptions, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps} = sanitizeInputs[listedSamples, safeOptionsNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentPrepareTransporter, {samplesWithPreparedSamples}, safeOps, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentPrepareTransporter, {samplesWithPreparedSamples}, safeOps], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentPrepareTransporter, {ToList[samplesWithPreparedSamples]}, safeOps, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentPrepareTransporter, {ToList[samplesWithPreparedSamples]}, safeOps], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* This function must be called as subprotocol. Check that our RootProtocol is not Null *)
	noParentProtocolTests = If[gatherTests,
		Test["The ParentProtocol option is specified and not Null:", parentProtocol, ObjectP[ProtocolTypes[]]],
		Nothing
	];

	(* Return early if our root protocol is Null for any reason *)
	If[NullQ[parentProtocol],
		Message[Error::NoParentProtocol];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, noParentProtocolTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Expand index-matching options *)

	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentPrepareTransporter, {ToList[samplesWithPreparedSamples]}, inheritedOptions]];

	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentPrepareTransporterOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cache, Output -> {Result, Tests}],
			{resolveExperimentPrepareTransporterOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cache, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentPrepareTransporter,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		Lookup[resolvedOptions, OptionsResolverOnly], True,
		True, False
	];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> resolvedOptions,
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	{protocolPacket, resourcePacketTests} = Which[
		returnEarlyQ,
		{{$Failed, $Failed}, Null},
		gatherTests,
		prepareTransporterResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			Cache -> cache,
			Output -> {Result, Tests}
		],
		True,
		{
			prepareTransporterResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				Cache -> cache
			],
			{}
		}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentPrepareTransporter,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	result = Which[
		(* If our resource packet failed, can't upload anything *)
		MatchQ[protocolPacket, $Failed], $Failed,
		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			{protocolPacket},
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,MassSpectrometry],
			Cache->cache,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			Simulation -> Simulation[]
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentICPMS,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> Simulation[]
	}

];

(* ::Subsubsection:: *)
(*resolveExperimentPrepareTransporterOptions*)

DefineOptions[
	resolveExperimentPrepareTransporterOptions,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

resolveExperimentPrepareTransporterOptions[myInputs:{ObjectP[{Object[Item], Model[Item], Object[Container], Model[Container], Object[Sample]}]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, messages, cache, fastAssoc, optionsAssociation,
		roundedOptionsAssociation, roundingTests, unresolvedTransporters, unresolvedTransportTempertures, unresolvedTransporterIndices,
		duplicateObjectPositions, noDuplicateTransporter, noDuplicateTransporterIndex,
		noDuplicateInputs, parentProtocol, suppliedTransporterInfoAssocs, mapThreadFriendlyOptions, currentTransporterInfoAssocs,
		noDuplicateInputPackets, noDuplicateInputModels, noDuplicateInputModelPackets, transportersOnSite, ignoreOversizedItems,
		transporters, transporterIndecies, transportTemperatureNullErrors, noGoodTemperatureCandidateErrors,
		noGoodSizeCandidateErrors, insufficientSpaceErrors, insufficientDimensionsErrors, inconsistentTemperatureErrors,
		incorrectTemperatureRangeErrors, resolvedTransportTemperaturesNoDuplicate, resolvedTransportersNoDuplicate,
		resolvedTransporterIndeciesNoDuplicate, transportTemperatureNullOptions, transportTemperatureNullTests,
		noGoodTemperatureCandidateOptions, noGoodTemperatureCandidateTests, noGoodSizeCandidateOptions, noGoodSizeCandidateInputs, noGoodSizeCandidateTests,
		insufficientSpaceOptions, insufficientSpaceTests, insufficentDimensionsOptions, insufficientDimensionsTests,
		inconsistentTemperatureOptions, inconsistentTemperatureTests, inconsistentTemperatureRangeOptions, inconsistentTemperatureRangeTests,
		duplicateOptionsPositionCorrectionRule, correctedDuplicateOptionsPosition, nonDuplicatePositionsRule, allOptionsPosition,
		invalidInputs, invalidOptions, allTests, resolvedOptions, transporterObjectInOptions,
		allPortableTransporterModels, allSampleObjects, sampleContainers, sampleToContainerRule, inputsNoSample,
		allPortableTransporterModelPackets, inputPackets, inputModels, inputModelPackets, resolvedTransportTemperatures,
		inputDownloadFields, instrumentModelDownloadFields, downloadedStuff, cacheBall, currentInstrumentDownloadFields, noDuplicateInputsNoSample,
		transportTemperatureFromObjects, transportTemperatureConflictOptions, transportTemperatureConflictTests
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	parentProtocol = Lookup[myOptions, ParentProtocol, Null];

	(* Extract Object[Instrument] in supplied Transporter option *)
	transporterObjectInOptions = DeleteDuplicates[Cases[ToList[Lookup[myOptions, Transporter]], ObjectP[Object[Instrument]]]];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)

	allPortableTransporterModels = Search[
		{Model[Instrument, PortableHeater], Model[Instrument, PortableCooler]},
		Deprecated != True && InternalDimensions != Null
	];

	(* Define list of fields to download *)

	(* Define list of fields to download for supplied inputs *)
	(* input can be Model or Object; can be Sample, Container or Item *)
	inputDownloadFields = {
		Dimensions, TransportTemperature, Container, SelfStanding, TransportStable, Model, Contents
	};

	instrumentModelDownloadFields = {
		Positions, Dimensions, InternalDimensions, MaxTemperature, MinTemperature, Deprecated
	};

	currentInstrumentDownloadFields = {
		Contents, Model, NominalTemperature, EnvironmentalSensors, Status, CurrentProtocol, TemperatureControlledResources
	};

	downloadedStuff = Quiet[
		Download[
			{
				(*1*)myInputs,
				(*2*)allPortableTransporterModels,
				(*3*)transporterObjectInOptions
			},
			Evaluate[{
				(*1*){Packet[Sequence @@ inputDownloadFields], Packet[Model[inputDownloadFields]], Packet[Container[Model[inputDownloadFields]]], Packet[Container[inputDownloadFields]], Packet[Field[Contents[[All,2]]][inputDownloadFields]], Packet[Field[Contents[[All,2]]][Model][inputDownloadFields]]},
				(*2*){Packet[Sequence @@ instrumentModelDownloadFields]},
				(*3*){Packet[Sequence @@ currentInstrumentDownloadFields], Packet[Field[Contents[[All,2]]][Model][Dimensions]], Packet[Field[Contents[[All,2]]][Model, Container]]}
			}],
			Cache -> cache
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Replace samples with their containers *)
	allSampleObjects = Cases[myInputs, ObjectP[Object[Sample]]];
	sampleContainers = Download[Lookup[fetchPacketFromFastAssoc[#, fastAssoc] &/@ allSampleObjects, Container], Object];

	sampleToContainerRule = AssociationThread[allSampleObjects, sampleContainers];

	inputsNoSample = Replace[myInputs, sampleToContainerRule, 2];

	allPortableTransporterModelPackets = Experiment`Private`fetchPacketFromFastAssoc[#, fastAssoc] &/@ allPortableTransporterModels;

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	optionsAssociation = Association[myOptions];

	(*Precision checks*)
	{roundedOptionsAssociation, roundingTests} = If[gatherTests,
		RoundOptionPrecision[optionsAssociation,
			{TransportTemperature},
			{1 Celsius},
			Output -> {Result, Tests}
		],
		{RoundOptionPrecision[optionsAssociation,
			{TransportTemperature},
			{1 Celsius}
		], {}}
	];

	ignoreOversizedItems = Lookup[roundedOptionsAssociation, IgnoreOversizedItems];

	(* --------------------------------------------------- *)
	(* -------Resolve TransportTemperature option--------- *)
	(* --------------------------------------------------- *)


	unresolvedTransportTempertures = Lookup[roundedOptionsAssociation, TransportTemperature];

	inputPackets = fetchPacketFromFastAssoc[#, fastAssoc] &/@ inputsNoSample;
	inputModels = Map[
		Function[{packet},
			If[MatchQ[packet, PacketP[Object]],
				Download[Lookup[packet, Model], Object],
				Lookup[packet, Object]
			]
		],
		inputPackets
	];
	inputModelPackets = fetchPacketFromFastAssoc[#, fastAssoc] &/@ inputModels;

	(* Try to read the TransportTemperature from the object/model packets *)
	transportTemperatureFromObjects = Map[
		Function[{object},
			Switch[object,
				ObjectP[{Model[Sample], Model[Item]}],
				(* straight-forward, read from the model packet *)
					fastAssocLookup[fastAssoc, object, TransportTemperature],
				ObjectP[Model[Container]],
				(* Unable to determine TransportTemperature if input is Model[Container] *)
					Null,
				ObjectP[{Object[Sample], Object[Item]}],
				(* For these two types, read from object packet first; if TransportTemperauture is not available in object packet, then try model packet *)
					Module[{objectTransportTemperature, modelTransportTemperature},
						objectTransportTemperature = fastAssocLookup[fastAssoc, object, TransportTemperature];
						modelTransportTemperature = fastAssocLookup[fastAssoc, object, {Model, TransportTemperature}];
						If[MatchQ[objectTransportTemperature, TemperatureP],
							objectTransportTemperature,
							modelTransportTemperature
						]
					],
				ObjectP[{Object[Container]}],
				(* Need to read from the contents for containers *)
					Module[
						{contents, validContents, objectTransportTemperatures, modelTransportTemperatures},
						contents = fastAssocLookup[fastAssoc, object, Contents];
						validContents = Cases[contents[[All,2]], ObjectP[]];
						objectTransportTemperatures = DeleteDuplicates[Cases[fastAssocLookup[fastAssoc, validContents, TransportTemperature], TemperatureP]];
						modelTransportTemperatures = DeleteDuplicates[Cases[fastAssocLookup[fastAssoc, validContents, {Model, TransportTemperature}], TemperatureP]];
						Which[
							(* If there's only 1 TransportTemperature for all contents, use it *)
							MatchQ[objectTransportTemperatures, {TemperatureP}],
								First[objectTransportTemperatures],
							(* If there are more than 1, put $Failed here, will throw error later *)
							MatchQ[objectTransportTemperatures, {TemperatureP, TemperatureP..}],
								$Failed,
							(* If there's only 1 TransportTemperature for all contents model, use it *)
							MatchQ[modelTransportTemperatures, {TemperatureP}],
								First[modelTransportTemperatures],
							(* similarly, throw error if we found 2 or more *)
							MatchQ[modelTransportTemperatures, {TemperatureP, TemperatureP..}],
								$Failed,
							(* If we can't find anything, set to Null *)
							True,
								Null
						]
					]
			]
		],
		myInputs
	];

	resolvedTransportTemperatures = MapThread[
		Function[{transportTemperature, transportTemperatureFromDownload},
			Which[
				(* If TransportTemperature is specified, use that *)
				MatchQ[transportTemperature, TemperatureP], transportTemperature,
				(* If not, try read from object packet *)
				MatchQ[transportTemperatureFromDownload, TemperatureP], transportTemperatureFromDownload,
				(* Troubleshooting catch all *)
				True, Null
			]
		],
		{unresolvedTransportTempertures, transportTemperatureFromObjects}
	];

	transportTemperatureNullErrors = NullQ /@ resolvedTransportTemperatures;

	(* Null TransportTemperature errors *)
	transportTemperatureNullOptions = If[MemberQ[transportTemperatureNullErrors, True] && messages,
		Message[Error::NoTransportTemperature, PickList[myInputs, transportTemperatureNullErrors, True]];
		{TransportTemperature},
		{}
	];

	transportTemperatureNullTests = If[gatherTests,
		Test["All supplied TransportTemperature options are not Null, and can be resolved to non-Null values:", transportTemperatureNullErrors, {False...}],
		Nothing
	];

	(* Conflicting TransportTemperature errors *)
	transportTemperatureConflictOptions = If[MemberQ[resolvedTransportTemperatures, $Failed] && messages,
		Message[Error::ConflictingTransportTemperature, PickList[myInputs, resolvedTransportTemperatures, $Failed]];
		{TransportTemperature},
		{}
	];

	transportTemperatureConflictTests = If[gatherTests,
		Test["All samples in the same container either have consistent TransportTemperature, or the TransportTemperature option is manually specified:", MemberQ[transportTemperatureConflictTests, $Failed], False],
		Nothing
	];

	(* --------------------------------------------------- *)
	(* ------------Resolve Transporter option------------- *)
	(* --------------------------------------------------- *)

	(* Step 1: because user may specify an Object[Instrument] in the Transporter option, we first need to gather information on them *)
	(* The ouput will match TransporterInformationAssociationP *)

	suppliedTransporterInfoAssocs = constructInitialTransporterInfoAssoc[fastAssoc, transporterObjectInOptions];

	{
		unresolvedTransporters, unresolvedTransporterIndices
	} = Lookup[roundedOptionsAssociation,
		{Transporter, TransporterIndex}
	];

	(* Input may have duplicate Object[Container], or have multiple Object[Sample] from the same container. Make a variable to indicate positions of duplicate objects *)
	duplicateObjectPositions = MapThread[
		If[MatchQ[#1, ObjectP[Object]] && MemberQ[Take[inputsNoSample, #2 - 1], #1],
			First[FirstPosition[Take[inputsNoSample, #2 - 1], #1, Null]],
			Null
		]&,
		{inputsNoSample, Range[Length[inputsNoSample]]}
	];

	(* Filter out the duplicated Inputs and corresponding value of index-matched options *)
	{noDuplicateInputs, noDuplicateTransporter, resolvedTransportTemperaturesNoDuplicate, noDuplicateTransporterIndex, noDuplicateInputsNoSample} = Map[
		PickList[#, duplicateObjectPositions, Null] &,
		{myInputs, unresolvedTransporters, resolvedTransportTemperatures, unresolvedTransporterIndices, inputsNoSample}
	];

	noDuplicateInputPackets = fetchPacketFromFastAssoc[#, fastAssoc] &/@ noDuplicateInputsNoSample;
	noDuplicateInputModels = Map[
		Function[{packet},
			If[MatchQ[packet, PacketP[Object]],
				Download[Lookup[packet, Model], Object],
				Lookup[packet, Object]
			]
		],
		noDuplicateInputPackets
	];

	noDuplicateInputModelPackets = fetchPacketFromFastAssoc[#, fastAssoc] &/@ noDuplicateInputModels;

	(* Construct a revert of duplicateObjectPositions *)
	duplicateOptionsPositionCorrectionRule = MapIndexed[
		First[#1] -> First[#2]&,
		Position[duplicateObjectPositions, Null]
	];

	correctedDuplicateOptionsPosition = Replace[duplicateObjectPositions, duplicateOptionsPositionCorrectionRule, 1];

	nonDuplicatePositionsRule = MapIndexed[
		(First[#1] -> First[#2])&,
		Position[correctedDuplicateOptionsPosition, Null]
	];

	allOptionsPosition = ReplacePart[correctedDuplicateOptionsPosition, nonDuplicatePositionsRule];

	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPrepareTransporter,
		<|
			Transporter -> noDuplicateTransporter, TransportTemperature -> resolvedTransportTemperaturesNoDuplicate, TransporterIndex -> noDuplicateTransporterIndex
		|>
	];

	(* Include the transporters that are in the user-specified option but not Running by the protocol, construct its info assoc and append to the existing ones *)

	currentTransporterInfoAssocs = suppliedTransporterInfoAssocs;

	(* Step 2. Use MapThread to resolve options. Note that variable currentTransporterInfoAssocs will be overwritten for each iteration *)
	(* This is because we need information on resolved Transporter for previous iterations to decide whether we can store the current one into one of the previous transporters *)

	{
		(*1*)resolvedTransportersNoDuplicate,
		(*2*)resolvedTransporterIndeciesNoDuplicate,
		(*3*)noGoodTemperatureCandidateErrors,
		(*4*)noGoodSizeCandidateErrors,
		(*5*)insufficientSpaceErrors,
		(*6*)insufficientDimensionsErrors,
		(*7*)inconsistentTemperatureErrors,
		(*8*)incorrectTemperatureRangeErrors
	} = Transpose[
		MapThread[
			Function[{modelPacket, option, temperature, objectPacket},
				Module[
					{
						itemHeight, itemArea, candidateCurrentTransporters, resolvedTransporter,
						resolvedTransporterIndex, noGoodTemperatureCandidateError, sortedTransporterInfoAssocs,
						itemLength, itemWidth, noGoodSizeCandidateError, unresolvedTransporter,
						transporterAssocToUseBeforeUpdate, transporterAssocToUseAfterUpdate, insufficientSpaceError,
						insufficientDimensionsError, inconsistentTemperatureError, incorrectTemperatureRangeError,
						itemDimensions, correctedItemDimensions
					},

					(* Extract item's dimensions and construct its height and area *)
					itemDimensions = Lookup[modelPacket, Dimensions];
					(* It's possible that part of whole Dimensions field are missing for the item's model. *)
					(* replace that with dummy 1 cm length *)
					correctedItemDimensions = If[MatchQ[itemDimensions, Null],
						{0.01 Meter, 0.01 Meter, 0.01 Meter},
						Replace[itemDimensions, Null -> 0.01 Meter, 1]
					];

					(* Separate 3 dimensions of the item *)
					{itemLength, itemWidth, itemHeight} = If[MatchQ[modelPacket, PacketP[Model[Item, Column]]],
						(* Make a special treatment for columns; Dimensions of columns can be misleading so use the shortest one as height. longest one as length *)
						{Max[itemDimensions], Median[itemDimensions], Min[itemDimensions]},
						(* Other case 3rd is height; longer one of first two is length, shorter one is width *)
						{Max[correctedItemDimensions[[1;;2]]], Min[correctedItemDimensions[[1;;2]]], correctedItemDimensions[[3]]}
					];

					(* Compute item area *)
					itemArea = itemLength * itemWidth;

					(* Find the supplied Transporter option *)
					unresolvedTransporter = Lookup[option, Transporter];

					(* Sort candidate transporters by the remaining area. This maximizes packing when picking transporters *)
					sortedTransporterInfoAssocs = SortBy[currentTransporterInfoAssocs, Lookup[#, Area] &];

					(* Try to find if we can fit the item in any existing transporters *)
					candidateCurrentTransporters = Cases[
						currentTransporterInfoAssocs,
						KeyValuePattern[{
							NominalTemperature -> EqualP[temperature],
							Height -> GreaterEqualP[itemHeight],
							Area -> GreaterEqualP[itemArea * $TransporterPackingFraction]
						}]
					];

					(* Set the following error-checking variables as False (i.e., no error) *)
					{noGoodTemperatureCandidateError, noGoodSizeCandidateError} = {False, False};

					(* If we have found a current transporter as candidate, then use it. Otherwise we need to go through some more steps to find a new one *)
					{resolvedTransporter, resolvedTransporterIndex} = Which[
						(* If the supplied Transporter option is an Object[Instrument], use it. It must be in the Assoc already *)
						MatchQ[unresolvedTransporter, ObjectP[Object[Instrument]]],
							Module[{relevantTransporterAssoc},
								relevantTransporterAssoc = FirstCase[currentTransporterInfoAssocs, KeyValuePattern[Object -> unresolvedTransporter], <| Index -> Null |>];
								{unresolvedTransporter, Lookup[relevantTransporterAssoc, Index]}
							],
						(* If the supplied Transporter option is a Model, check if it's already part of the candidate *)
						MatchQ[unresolvedTransporter, ObjectP[Model[Instrument]]],
							Module[{relevantTransporterAssocs, transporterAssocToUse},
								relevantTransporterAssocs = Cases[candidateCurrentTransporters, KeyValuePattern[Model -> unresolvedTransporter]];
								(* if it is, use the first one *)
								transporterAssocToUse = If[Length[relevantTransporterAssocs] > 0,
									First[relevantTransporterAssocs],
									(* Otherwise, use a brand-new one of that model. We'll need to add it to currentTransporterInfoAssocs later *)
									fetchPacketFromFastAssoc[unresolvedTransporter, fastAssoc]
								];
								(* add it to currentTransporterInfoAssocs if we are using a brand-new model *)
								currentTransporterInfoAssocs = If[Length[relevantTransporterAssocs] == 0,
									appendTransporterInformation[currentTransporterInfoAssocs, {unresolvedTransporter, temperature, transporterAssocToUse}],
									currentTransporterInfoAssocs
								];

								(* Output result *)
								If[Length[relevantTransporterAssocs] > 0,
									(* If we use an existing one, lookup the index from transporterAssocToUse *)
									{unresolvedTransporter, Lookup[transporterAssocToUse, Index]},
									(* If we use a new one, it's always the very last index *)
									{unresolvedTransporter, Length[currentTransporterInfoAssocs]}
								]

							],
						(* If supplied Transporter option is Null, use that. This is allowed because chances are we have oversized item so we can't find any transporter *)
						NullQ[unresolvedTransporter],
							{Null, Null},
						(* Finally, the option is not specified. will need to resolve it *)
						(* If we found any existing ones that's capable of holding the item, use the first one *)
						Length[candidateCurrentTransporters] >= 1,
							Lookup[First[candidateCurrentTransporters], #] &/@ {Object, Index},
						(* Otherwise, do some work to resolve a new one *)
						True,
						Module[
							{
								temperatureLimitedCandidates, sizeLimitedCandidates, finalCandidatePackets, finalCandidates,
								finalResolvedTransporter, finalResolvedTransporterPacket
							},

							(* Find transporter models that can be adjusted to the temperature *)
							temperatureLimitedCandidates = Cases[
								allPortableTransporterModelPackets,
								KeyValuePattern[{MaxTemperature -> GreaterEqualP[temperature], MinTemperature -> LessEqualP[temperature]}]
							];

							(* If there's no transporter that has the proper temperature range, record error here *)
							(* Note that don't throw error if TransportTemperature == Null. A different error will be thrown *)
							noGoodTemperatureCandidateError = TrueQ[Length[temperatureLimitedCandidates] == 0];

							(* Find transporter models that fits the input item. Assume the item always need to be upright *)
							sizeLimitedCandidates = Cases[
								temperatureLimitedCandidates,
								Alternatives[
									KeyValuePattern[{InternalDimensions -> {GreaterEqualP[itemLength], GreaterEqualP[itemWidth], GreaterEqualP[itemHeight]}}],
									KeyValuePattern[{InternalDimensions -> {GreaterEqualP[itemWidth], GreaterEqualP[itemLength], GreaterEqualP[itemHeight]}}]
								]
							];

							(* If there's no transporter that fits the item, record error here *)
							noGoodSizeCandidateError = TrueQ[Length[sizeLimitedCandidates] == 0 && Length[temperatureLimitedCandidates] > 0];

							finalCandidatePackets = Which[
								(* If there's at least one model that satisfies both conditions, use them *)
								Length[sizeLimitedCandidates] > 0, sizeLimitedCandidates,
								(* Otherwise, if there's at least one that satisfies temperature condition, and we ignore oversized item, set to Null *)
								(* Note we are using this special format so it can go through downstream process and eventually returns Null as the resolvedTransporter *)
								Length[temperatureLimitedCandidates] > 0 && ignoreOversizedItems, {<| Object -> Null |>},
								(* If we had IgnoreOversizedItems -> False, then use the ones that at least satisfies temperature *)
								Length[temperatureLimitedCandidates] > 0, temperatureLimitedCandidates,
								(* Finally, if we really have nothing to use, set to Null *)
								True, {<| Object -> Null |>}
							];

							finalCandidates = Lookup[finalCandidatePackets, Object];

							(* If there's something available now, pick the first model; otherwise pick the first from finalCandidates *)
							finalResolvedTransporter = First[finalCandidates];

							finalResolvedTransporterPacket = fetchPacketFromFastAssoc[finalResolvedTransporter, fastAssoc];
							(* Add the information of this new transporter into currentTransporterInfoAssocs *)
							currentTransporterInfoAssocs = appendTransporterInformation[currentTransporterInfoAssocs, {finalResolvedTransporter, temperature, finalResolvedTransporterPacket}];

							(* Output result. New transporter Index is always the last one of currentTransporterInfoAssocs *)
							(* One exception is if we resolve Transporter to Null, then the index should also be Null *)
							{finalResolvedTransporter, If[NullQ[finalResolvedTransporter], Null, Length[currentTransporterInfoAssocs]]}
						]
					];

					(* Find the transporter info we resolve to before we update the remaining available area. It's possible that we resolve to Null and can't find any *)
					transporterAssocToUseBeforeUpdate = FirstCase[currentTransporterInfoAssocs, KeyValuePattern[Index -> resolvedTransporterIndex], <| Area -> Null |>];

					(* update the remaining area of the picked transporter *)
					currentTransporterInfoAssocs = updateTransporterCapacity[currentTransporterInfoAssocs, {objectPacket, modelPacket}, ContainerIndex -> resolvedTransporterIndex];

					(* find the transporter info again after we do the update *)
					transporterAssocToUseAfterUpdate = FirstCase[currentTransporterInfoAssocs, KeyValuePattern[Index -> resolvedTransporterIndex], <| Area -> Null |>];

					(* Error checks *)

					(* 1. Check if the item dimensions are within the transporter internal dimensions *)
					(* Skip the check if resolvedTransporter == Null *)
					insufficientDimensionsError = !Or[
						NullQ[resolvedTransporter],
						TrueQ[
							(* Note items are free to rotate while kept upright. So as long as item dimensions fit in one way, we say it's good *)
							Or[
								And[
									Lookup[transporterAssocToUseAfterUpdate, Height] >= itemHeight,
									Lookup[transporterAssocToUseAfterUpdate, InternalDimensions][[2]] >= itemWidth,
									Lookup[transporterAssocToUseAfterUpdate, InternalDimensions][[1]] >= itemLength
								],
								And[
									Lookup[transporterAssocToUseAfterUpdate, Height] >= itemHeight,
									Lookup[transporterAssocToUseAfterUpdate, InternalDimensions][[1]] >= itemWidth,
									Lookup[transporterAssocToUseAfterUpdate, InternalDimensions][[2]] >= itemLength
								]
							]
						]
					];

					(* 2. Check if the remaining area becomes negative *)
					(* Skip the check if insufficientDimensionsError is triggered; because in that case almost always the area becomes negative *)
					insufficientSpaceError = TrueQ[
						And[
							Lookup[transporterAssocToUseBeforeUpdate, Area] >= 0 Meter * Meter,
							Lookup[transporterAssocToUseAfterUpdate, Area] < 0 Meter * Meter,
							!insufficientDimensionsError
						]
					];

					(* 3. Check if the NominalTemperature of the resolved transporter matches the resolved TransportTemperature *)
					(* Skip the check if resolvedTransporter == Null *)
					inconsistentTemperatureError = (!NullQ[resolvedTransporter]) && (!TrueQ[Lookup[transporterAssocToUseAfterUpdate, NominalTemperature] == temperature]);

					(* 4. Check the temperature is within the Min and Max temperature of the transporter *)
					(* Skip the check if resolvedTransporter == Null *)
					incorrectTemperatureRangeError = !Or[
						NullQ[resolvedTransporter],
						TrueQ[
							And[
								Lookup[transporterAssocToUseAfterUpdate, MaxTemperature] >= temperature,
								Lookup[transporterAssocToUseAfterUpdate, MinTemperature] <= temperature
							]
						]
					];

					(* Final output *)
					{
						(*1*)resolvedTransporter,
						(*2*)resolvedTransporterIndex,
						(*3*)noGoodTemperatureCandidateError,
						(*4*)noGoodSizeCandidateError,
						(*5*)insufficientSpaceError,
						(*6*)insufficientDimensionsError,
						(*7*)inconsistentTemperatureError,
						(*8*)incorrectTemperatureRangeError
					}

				]
			],
			{noDuplicateInputModelPackets, mapThreadFriendlyOptions, resolvedTransportTemperaturesNoDuplicate, noDuplicateInputPackets}
		]
	];

	(* Step 4. Assemble error messages and tests *)

	(* Can't find transporter with correct temperature range error *)
	noGoodTemperatureCandidateOptions = If[MemberQ[noGoodTemperatureCandidateErrors, True] && messages,
		Message[Error::UnsupportedTemperature, PickList[noDuplicateInputs, noGoodTemperatureCandidateErrors, True], PickList[resolvedTransportTemperaturesNoDuplicate, noGoodTemperatureCandidateErrors, True]];
		{TransportTemperature, Transporter},
		{}
	];

	noGoodTemperatureCandidateTests = If[gatherTests,
		Test["Function were able to find transporters that provides the requested TransportTemperature for all inputs:", noGoodTemperatureCandidateErrors, {False...}],
		Nothing
	];

	(* Can't find transporter with correct size error *)
	(* Only throw hard error if IgnoreOversizedItems -> False *)
	{noGoodSizeCandidateInputs, noGoodSizeCandidateOptions} = If[MemberQ[noGoodSizeCandidateErrors, True] && messages && !ignoreOversizedItems,
		Message[Error::OversizedItem, PickList[noDuplicateInputs, noGoodSizeCandidateErrors, True]];
		{PickList[noDuplicateInputs, noGoodSizeCandidateErrors, True], {IgnoreOversizedItems}},
		{{}, {}}
	];

	(* throw a warning if IgnoreOversizedItems -> True. Skip warning in engine *)
	If[MemberQ[noGoodSizeCandidateErrors, True] && messages && ignoreOversizedItems && !MatchQ[$ECLApplication, Engine],
		Message[Warning::OversizedItem, PickList[noDuplicateInputs, noGoodSizeCandidateErrors, True]]
	];

	noGoodSizeCandidateTests = Which[
		gatherTests && ignoreOversizedItems,
			Warning["Transporter with proper size can be found for all items:", noGoodSizeCandidateErrors, {False...}],
		gatherTests,
			Test["Transporter with proper size can be found for all items:", noGoodSizeCandidateErrors, {False...}],
		True,
			Nothing
	];

	(* Check if transporters have enough space to fit all items inside *)
	insufficientSpaceOptions = If[MemberQ[insufficientSpaceErrors, True] && messages,
		Message[Error::InsufficientTransporterSpace, PickList[resolvedTransportersNoDuplicate, insufficientSpaceErrors, True], PickList[noDuplicateInputs, insufficientSpaceErrors, True]];
		{Transporter},
		{}
	];

	insufficientSpaceTests = If[gatherTests,
		Test["All transporters has sufficient space to fit all items inside:", insufficientSpaceErrors, {False...}],
		Nothing
	];

	(* Check if transporters have enough space to fit each single item separately *)
	insufficentDimensionsOptions = If[MemberQ[insufficientDimensionsErrors, True] && messages,
		Message[Error::InsufficientTransporterDimensions, PickList[resolvedTransportersNoDuplicate, insufficientDimensionsErrors, True], PickList[noDuplicateInputs, insufficientSpaceErrors, True]];
		{Transporter},
		{}
	];

	insufficientDimensionsTests = If[gatherTests,
		Test["The internal dimensions of the transporter is sufficient to fit requested items:", insufficientDimensionsErrors, {False...}],
		Nothing
	];

	(* For all specified Object[Instrument] options for Transporters, check the current NominalTemperature equal to the resolved TransportTemperature *)
	inconsistentTemperatureOptions = If[MemberQ[inconsistentTemperatureErrors, True] && messages,
		Message[
			Error::InconsistentTemperatureSetting,
			PickList[resolvedTransportTemperaturesNoDuplicate, inconsistentTemperatureErrors, True],
			PickList[noDuplicateInputs, inconsistentTemperatureErrors, True],
			PickList[resolvedTransportersNoDuplicate, inconsistentTemperatureErrors, True]
		];
		{Transporter, TransportTemperature},
		{}
	];

	inconsistentTemperatureTests = If[gatherTests,
		Test["The Temperature setting of the specified transporters are consistent with the TransportTemperature options:", inconsistentTemperatureErrors, {False...}],
		Nothing
	];

	(* For all specified Model[Instrument] options for Transporters, check the resolved TransportTemperature is within range of Min and MaxTemperature *)
	inconsistentTemperatureRangeOptions = If[MemberQ[incorrectTemperatureRangeErrors, True] && messages,
		Message[Error::IncorrectTemperatureRange, PickList[resolvedTransportTemperaturesNoDuplicate, inconsistentTemperatureErrors, True], PickList[resolvedTransportersNoDuplicate, incorrectTemperatureRangeErrors, True]];
		{Transporter, TransportTemperature},
		{}
	];

	inconsistentTemperatureRangeTests = If[gatherTests,
		Test["The requested TransportTemperature is supported by the specified Transporter model:", inconsistentTemperatureErrors, {False...}],
		Nothing
	];

	(* Step 5. Remember that we have removed duplicate Object[Container]s when resolving index-matched options. now we need to redistribute the options to index-match with initial inputs *)

	(* now distribute options *)
	transporters = resolvedTransportersNoDuplicate[[#]] &/@ allOptionsPosition;
	transporterIndecies = resolvedTransporterIndeciesNoDuplicate[[#]] &/@ allOptionsPosition;

	resolvedOptions = ReplaceRule[
		myOptions,
		{
			Transporter -> transporters,
			TransportTemperature -> resolvedTransportTemperatures,
			TransporterIndex -> transporterIndecies
		}
	];

	invalidInputs = DeleteDuplicates[noGoodSizeCandidateInputs];

	invalidOptions = DeleteDuplicates[Flatten[{
		transportTemperatureNullOptions,
		noGoodTemperatureCandidateOptions,
		noGoodSizeCandidateOptions,
		insufficientSpaceOptions,
		insufficentDimensionsOptions,
		inconsistentTemperatureOptions,
		inconsistentTemperatureRangeOptions,
		transportTemperatureConflictOptions
	}]];

	allTests = Cases[
		Flatten[{
			inconsistentTemperatureRangeTests,
			inconsistentTemperatureTests,
			insufficientDimensionsTests,
			insufficientSpaceTests,
			noGoodSizeCandidateTests,
			noGoodTemperatureCandidateTests,
			transportTemperatureNullTests,
			transportTemperatureConflictTests
		}],
		TestP
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}

];


(* ::Subsubsection:: *)
(*prepareTransporterResourcePackets*)

DefineOptions[
	prepareTransporterResourcePackets,
	Options:>{HelperOutputOption, CacheOption, SimulationOption}
];

prepareTransporterResourcePackets[myInputs:{ObjectP[{Object[Item], Model[Item], Object[Container], Model[Container], Object[Sample]}]...},myUnresolvedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..}, ops:OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, messages, cache, expandedInputs,
		expandedResolvedOptions, transporters, transporterIndecies, transportTemperature, transporterResources,
		protocolPacket, protocolObject, finalizedPacket, allResourceBlobs, fulfillable, frqTests,
		previewRule, optionsRule, resolvedOptionsNoHidden, testsRule, resultRule, resourcePlacement,
		uuid, temperatureControlledResources, transporterPickingTime, transporterConfigurationTime, checkpoints,
		transporterResourcesNoDuplicates, transporterIndexMatchingTuple, transportTemperatureNoDuplicates, transporterIndexMatchingTupleNoDup,
		fumeHoodResource, cableResources, cableResourcesNoDuplicates
	},
	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages =! gatherTests;

	(* Get our cache. *)
	cache = OptionValue[Cache];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentPrepareTransporter, {myInputs}, myResolvedOptions];

	(* make resource for Transporters *)
	{transporters, transporterIndecies, transportTemperature} = Lookup[expandedResolvedOptions, {Transporter, TransporterIndex, TransportTemperature}];

	uuid = CreateUUID[];

	transporterResources = MapThread[
		Function[{instrument, index},
			Switch[instrument,
				ObjectP[Object[Instrument]],
					Resource[Instrument -> instrument],
				ObjectP[Model[Instrument]],
					Resource[Instrument -> instrument, Name -> uuid <> ToString[index] <> Download[instrument, ID]],
				_,
					Null
			]
		],
		{transporters, transporterIndecies}
	];

	cableResources = MapThread[
		Function[{instrument, index},
			(* Request a cable resource for portable coolers. No need for heaters *)
			If[MatchQ[instrument, ObjectP[{Object[Instrument, PortableCooler], Model[Instrument, PortableCooler]}]],
				Resource[Sample -> Model[Wiring, Cable, "Universal portable cooler power cable"], Name -> uuid <> ToString[index]],
				Null
			]
		],
		{transporters, transporterIndecies}
	];

	transporterIndexMatchingTuple = Transpose[{transporterIndecies, transporterResources, transportTemperature, cableResources}];

	transporterIndexMatchingTupleNoDup = DeleteDuplicatesBy[transporterIndexMatchingTuple, First];

	{transporterResourcesNoDuplicates, transportTemperatureNoDuplicates, cableResourcesNoDuplicates} = Transpose[transporterIndexMatchingTupleNoDup][[2;;4]];

	(* compute ResourcePlacement field by pairing the Resource option and resolved Transporter option *)
	(* If Resource option is Null, then use the input item *)
	resourcePlacement = MapThread[
		Function[{resource, transporter, input},
			If[NullQ[resource],
				{Link[input], Link[transporter]},
				{Link[resource], Link[transporter]}
			]
		],
		{Lookup[expandedResolvedOptions, Resource], transporterResources, myInputs}
	];

	(* Find TemperatureControlledResources by remove entries with Transporter == Null, then take the first column *)
	temperatureControlledResources = (DeleteCases[resourcePlacement, {_, Null}])[[All,1]];

	(* Create checkpoints *)

	(* estimate picking time: 15 min base plus 2 minute per unique transporter *)
	transporterPickingTime = 15 Minute + Length[DeleteDuplicates[transporterIndecies]] * 2 Minute;
	(* estimate configuration time: 20 min base plus 5 minute per unique transporter *)
	transporterConfigurationTime = 20 Minute + Length[DeleteDuplicates[transporterIndecies]] * 5 Minute;
	checkpoints = {
		{"Configure Transporters", transporterConfigurationTime, "Portable transporters are configured to the requested temperature.", Resource[Operator -> $BaselineOperator, Time -> transporterConfigurationTime]},
		{"Equilibrate Temperature", 1 Hour, "Temperature of portable transporters are equilibrated to the requested temperature.", Resource[Operator -> $BaselineOperator, Time -> 1 Hour]},
		{"Post-Processing", 30 Minute, "Temperature during the equilibration process are recorded and uploaded.", Resource[Operator -> $BaselineOperator, Time -> 30 Minute]},
		{"Returning Materials", 5 Minute, "Any unecessary materials are returned.", Resource[Operator -> $BaselineOperator, Time -> 5 Minute]}
	};

	protocolObject = CreateID[Object[Protocol, PrepareTransporter]];

	(* Reserve a fumehood to set up heater *)
	fumeHoodResource = If[MemberQ[transporters, ObjectP[{Object[Instrument, PortableHeater], Model[Instrument, PortableHeater]}]],
		Resource[Instrument -> Model[Instrument, FumeHood, "id:P5ZnEj4P8kNO"]],
		Null
	];

	protocolPacket = <|
		Object -> protocolObject,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> myResolvedOptions,
		Replace[Transporters] -> transporterResourcesNoDuplicates,
		Replace[Temperatures] -> transportTemperatureNoDuplicates,
		Replace[ResourcePlacements] -> resourcePlacement,
		Replace[TemperatureControlledResources] -> temperatureControlledResources,
		Replace[Checkpoints] -> checkpoints,
		FumeHood -> Link[fumeHoodResource],
		Replace[PowerCables] -> cableResourcesNoDuplicates
	|>;


	(* Merge the shared fields with the specific fields *)
	finalizedPacket = protocolPacket;

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache],Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentPrepareTransporter,
		RemoveHiddenOptions[ExperimentPrepareTransporter, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

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
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];

(* ::Subsubsection:: *)
(*helpers*)

TransporterInformationAssociationP = AssociationMatchP[
	Association[
		Object -> (Null | ObjectP[{Object[Instrument, PortableCooler], Object[Instrument, PortableHeater], Model[Instrument, PortableCooler], Model[Instrument, PortableHeater]}]),
		Model -> ObjectP[{Model[Instrument, PortableCooler], Model[Instrument, PortableHeater]}],
		(* Index is a unique integer identifier to indicate multiple copies of the same model *)
		Index -> _Integer,
		(* Height of internal dimensions *)
		Height -> DistanceP,
		(* Current available area after accounting for all contents *)
		Area -> AreaP,
		MinTemperature -> TemperatureP,
		MaxTemperature -> TemperatureP,
		NominalTemperature -> (Null | TemperatureP),
		InternalDimensions -> {DistanceP, DistanceP, DistanceP}
	]
];

appendTransporterInformation[myPreviousAssocs:{TransporterInformationAssociationP...}, myNewInfoTuple:{{(ObjectP[{Object[Instrument], Model[Instrument]}] | Null), (Null|TemperatureP), (Null | TransporterInformationAssociationP | PacketP[Model[Instrument]])}...}] := Module[
	{newTransporters, nominalTemperatures, modelPackets, newAssocs},

	(* The myNewInfoTuple is always in the following format *)
	{newTransporters, nominalTemperatures, modelPackets} = Transpose[myNewInfoTuple];

	newAssocs = MapThread[
		Function[{transporter, temperature, modelPacket, index},
			If[NullQ[transporter],
				(* If transporter == Null, don't update anything *)
				Nothing,
				(* Otherwise, construct association of new transporters which format matches TransporterInformationAssociationP *)
				Association[
					Object -> transporter,
					Model -> Lookup[modelPacket, Object],
					Index -> Length[myPreviousAssocs] + index,
					Height -> Lookup[modelPacket, InternalDimensions][[3]],
					(* "Area" represents the current available area. At this point, we don't consider any contents yet *)
					Area -> Times @@ (Lookup[modelPacket, InternalDimensions][[1;;2]]),
					MinTemperature -> Lookup[modelPacket, MinTemperature],
					MaxTemperature -> Lookup[modelPacket, MaxTemperature],
					NominalTemperature -> temperature,
					InternalDimensions -> Lookup[modelPacket, InternalDimensions]
				]
			]
		],
		{newTransporters, nominalTemperatures, modelPackets, Range[1, Length[newTransporters]]}
	];

	Join[myPreviousAssocs, newAssocs]
];

(* Single tuple overload *)
appendTransporterInformation[myPreviousAssocs:{TransporterInformationAssociationP...}, myNewInfoTuple:{(ObjectP[{Object[Instrument], Model[Instrument]}] | Null), (Null|TemperatureP), (Null | PacketP[Model[Instrument]])}] := appendTransporterInformation[myPreviousAssocs, {myNewInfoTuple}];

DefineOptions[updateTransporterCapacity,
	Options :> {
		{ContainerIndex -> Null, (Null | _Integer), "a unique integer identifier to pinpoint which transporter the input content belongs to, in case multiple instances of the same model exists. When this option is specified, function will find the transporter based on this option only."}
	}
];

updateTransporterCapacity[myTransporterInfoAssocs:{TransporterInformationAssociationP...}, myNewContentPackets:{PacketP[], PacketP[Model]}, ops:OptionsPattern[]] := Module[
	{
		safeOps, containerIndex, objectPacket, modelPacket, container, relevantTransporterAssoc, otherTransporterAssocs,
		currentArea, contentDimensions, contentArea, remainingArea
	},

	safeOps = SafeOptions[updateTransporterCapacity, ToList[ops]];
	{objectPacket, modelPacket} = myNewContentPackets;

	containerIndex = Lookup[safeOps, ContainerIndex];
	container = Download[Lookup[objectPacket, Container], Object];

	(* Find the transporter that the new contents is going into. Search by ContainerIndex if it's available, otherwise search by Container *)
	relevantTransporterAssoc = FirstCase[myTransporterInfoAssocs, If[NullQ[containerIndex], KeyValuePattern[Object -> container], KeyValuePattern[Index -> containerIndex]], <||>];
	otherTransporterAssocs = DeleteCases[myTransporterInfoAssocs, relevantTransporterAssoc];

	If[MatchQ[relevantTransporterAssoc, <||>],
		Return[myTransporterInfoAssocs]
	];

	currentArea = Lookup[relevantTransporterAssoc, Area];
	contentDimensions = Lookup[modelPacket, Dimensions][[1;;2]];
	contentArea = If[MemberQ[contentDimensions, Null],
		0 Meter * Meter,
		Times @@ contentDimensions
	];
	(* We compute the packing using remaining area. Subtract the current area with area of the item. Amplify item area by certain factor $TransporterPackingFraction *)
	remainingArea = currentArea - contentArea * $TransporterPackingFraction;

	relevantTransporterAssoc[Area] = remainingArea;
	Append[otherTransporterAssocs, relevantTransporterAssoc]

];

constructInitialTransporterInfoAssoc[myFastAssoc_Association, myCurrentTransporters:{ObjectP[Object[Instrument]]...}] := Module[
	{
		initialTransportersPackets, initialTransporterModels, initialTransporterModelPackets, initialTransporterInfomationAssocsNoContents,
		initialTransporterContents, initialContentsPackets, initialContentsModels, initialContentsModelPackets, initialContentsInfoAssoc,
		nominalTemperatures
	},

	(* Short pathway: If there's no transporters, make no change *)
	If[Length[myCurrentTransporters] == 0,
		Return[{}]
	];
	(* Find out information of current portable transporters *)
	initialTransportersPackets = fetchPacketFromFastAssoc[#, myFastAssoc] &/@ myCurrentTransporters;
	initialTransporterModels = If[Length[initialTransportersPackets] > 0,
		Download[Lookup[initialTransportersPackets, Model], Object],
		{}
	];

	nominalTemperatures = Lookup[#, NominalTemperature, Null]& /@ initialTransportersPackets;
	initialTransporterModelPackets = fetchPacketFromFastAssoc[#, myFastAssoc] &/@ initialTransporterModels;

	(* Construct a list of Associations to store relevant information. See helper function for details *)
	(* Currently, we do not account for their contents, we assume they have no contents and have full capacity. Will consider that later *)
	initialTransporterInfomationAssocsNoContents = If[Length[initialTransportersPackets] > 0,
		appendTransporterInformation[{}, Transpose[{myCurrentTransporters, nominalTemperatures, initialTransporterModelPackets}]],
		{}
	];

	(* Find the contents in current transporters and the relevant packets *)
	initialTransporterContents = Download[Cases[Flatten[Lookup[#, Contents] &/@ initialTransportersPackets], ObjectP[]], Object];

	initialContentsPackets = fetchPacketFromFastAssoc[#, myFastAssoc] &/@ initialTransporterContents;

	initialContentsModels = Download[Lookup[initialContentsPackets, Model, {}], Object];

	initialContentsModelPackets = fetchPacketFromFastAssoc[#, myFastAssoc] &/@ initialContentsModels;

	If[Length[initialTransporterContents] > 0,
		(* If there are any contents, call function updateTransporterCapacity to update the available Area in the info Assoc based on dimensions of the contents *)
		Fold[updateTransporterCapacity, initialTransporterInfomationAssocsNoContents, Transpose[{initialContentsPackets, initialContentsModelPackets}]],
		(* If there's no contents, just return the calculated initialTransporterInfomationAssocsNoContents *)
		initialTransporterInfomationAssocsNoContents
	]

]