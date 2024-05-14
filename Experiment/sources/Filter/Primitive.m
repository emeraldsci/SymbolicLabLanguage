(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* General Functions *)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveFilterMethod,
	SharedOptions:>{
		ExperimentFilter,
		CacheOption,
		SimulationOption
	}
];

DefineUsage[resolveFilterMethod,
	{
		BasicDefinitions -> {
			{
				Definition -> {"resolveFilterMethod[objects]","potentialMethods"},
				Description -> "based on the given 'objects' and options, generates the 'potentialMethods' that can be used by this protocol, either on the robotic liquid handler or manually (or both).",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "The samples that should be filtered.",
							Widget->Alternatives[
								Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								Widget[
									Type->Enumeration,
									Pattern:>Alternatives[Automatic]
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "potentialMethods",
						Description -> "The potential methods, robotic or manual, on which this filter operation can be performed.",
						Pattern :> ListableP[Robotic | Manual]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFilter",
			"Filter"
		},
		Author -> {
			"steven", "dima"
		}
	}
];

resolveFilterMethod[myContainers : ListableP[Automatic|ObjectP[{Object[Container], Object[Sample]}]], myOptions : OptionsPattern[]]:=Module[
	{safeOps, cache, simulation, outputSpecification, output, gatherTests, samplesToDownloadFrom, containersToDownloadFrom, modelsToDownloadFrom,
		modelContainersToDownloadFrom, allPackets, expandedSafeOps, containerModelPackets, plateContainerModelPackets, liquidHandlerIncompatibleContainers,
		allSamplePackets, sampleModelPackets, newCache, allSolutionsLiquidHandlerCompatibleQ, allInputVolumeOptionTuples,allBufferOptionSamples,allInputSampleLargeVolumeBoolean,allOptionSampleLargeVolumeBoolean, allSampleLargeVolumeBoolean,allSampleLargeVolumeQ, listedInputs,
		indexMatchingSamplePackets, manualRequirementStrings,roboticRequirementStrings,result,tests, fastAssoc},

	(* make sure these are a list *)
	listedInputs = ToList[myContainers];

	(* get the safe options expanded *)
	safeOps = SafeOptions[resolveFilterMethod, ToList[myOptions]];
	expandedSafeOps = Last[ExpandIndexMatchedInputs[resolveFilterMethod, {listedInputs}, safeOps]];

	(* pull out the cache, simulation, and potential methods *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* gather all the objects we're Downloading from *)
	(* for Object[Sample]s, get the input samples, the RetentateWashBuffers, and ResuspensionBuffers *)
	(* for Object[Container]s, get the input containers, CollectionContainer, RetentateContainerOut, and FiltrateContainerOut*)
	(* for Model[Sample]s, get the RetentateWashBuffers and ResuspensionBuffers that are models *)
	(* for Model[Container], CollectionContainer, RetentateContainerOut, and FiltrateContainerOut that are models *)
	samplesToDownloadFrom = Cases[Flatten[{listedInputs, Lookup[safeOps, {RetentateWashBuffer, ResuspensionBuffer}]}], ObjectP[Object[Sample]]];
	containersToDownloadFrom = Cases[Flatten[{listedInputs, Lookup[safeOps, {CollectionContainer, FiltrateContainerOut, RetentateContainerOut}]}], ObjectP[Object[Container]]];
	modelsToDownloadFrom = Cases[Flatten[Lookup[safeOps, {RetentateWashBuffer, ResuspensionBuffer}]], ObjectP[Model[Sample]]];
	modelContainersToDownloadFrom = Cases[Flatten[Lookup[safeOps, {CollectionContainer, FiltrateContainerOut, RetentateContainerOut}]], ObjectP[Model[Container]]];

	(* Download everything we need *)
	allPackets = Flatten[Quiet[Download[
		{
			samplesToDownloadFrom,
			containersToDownloadFrom,
			modelsToDownloadFrom,
			modelContainersToDownloadFrom
		},
		{
			{
				Packet[State, Mass, Volume, LiquidHandlerIncompatible, Name],
				Packet[Container[{Model, Name}]],
				Packet[Container[Model][{Footprint, Name, LiquidHandlerAdapter, LiquidHandlerPrefix}]]
			},
			{
				Packet[Model, Contents, Name],
				Packet[Contents[[All, 2]][{Name, State, Mass, Volume, LiquidHandlerIncompatible}]],
				Packet[Model[{Footprint, Name, LiquidHandlerAdapter, LiquidHandlerPrefix}]]
			},
			{
				Packet[State, LiquidHandlerIncompatible, Name]
			},
			{
				Packet[Footprint, Name, LiquidHandlerAdapter, LiquidHandlerPrefix]
			}
		},
		Cache -> cache,
		Simulation -> simulation
	], {Download::FieldDoesntExist, Download::NotLinkField}]];

	(* combine everything to make the new cache *)
	newCache = FlattenCachePackets[{cache, allPackets}];

	(* make the fast association *)
	fastAssoc = makeFastAssocFromCache[newCache];

	(* pull out all the container model packets *)
	containerModelPackets = Cases[allPackets, PacketP[Model[Container]]];
	plateContainerModelPackets = Cases[allPackets, PacketP[Model[Container,Plate]]];

	(* determine if all the container model packets in question can fit on the liquid handler *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[containerModelPackets,KeyValuePattern[Footprint->Except[LiquidHandlerCompatibleFootprintP]]],Object,{}],
			Lookup[Cases[plateContainerModelPackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];

	(* get all the Object[Sample] and Model[Sample] packets *)
	allSamplePackets = Cases[allPackets, ObjectP[Object[Sample]]];
	sampleModelPackets = Cases[allPackets, ObjectP[Model[Sample]]];

	(* make sure we don't have any samples or models that are liquid handler incompatible *)
	allSolutionsLiquidHandlerCompatibleQ = Not[MemberQ[Lookup[Flatten[{allSamplePackets, sampleModelPackets}], LiquidHandlerIncompatible], True]];

	(* make sure we don't have any samples or models that are liquid handler incompatible *)
	
	(* Volume check for inputs*)
	(* Get input volumes for all input samples AND contents of input containers - this is needed to compare with the indexed matched Volume option*)
	(* The final list of tuples is {{sample volume in database - ..Liter, Volume option value - Automatic|Volume, sample ID - Object[Sample]}..} *)
	allInputVolumeOptionTuples = If[MatchQ[Lookup[safeOps, Volume], Automatic],
		
		(* no Volume option specified*)
		(* Flatten into a list of {{sample volume in database, Automatic, sample ID - Object[Sample]}..} *)
		Flatten[
			Map[
				Function[
					{input},
					If[MatchQ[input, ObjectP[Object[Sample]]],
						(* If input is an object sample, only one set of {sample volume, Automatic, Object[Sample]}*)
						{{fastAssocLookup[fastAssoc, input, Volume],Automatic,input}},
						
						(* If input is an object container, there can be multiple sample contents and it is possible to have multiple sets of {sample volume, Automatic, Object[Sample]}*)
						Map[{fastAssocLookup[fastAssoc, #, Volume],Automatic,#} &, fastAssocLookup[fastAssoc, input, Contents][[All, 2]]]
					]
				],
				listedInputs
			],
			1
		],
		
		(* Volume option specified*)
		(* Flatten into a list of {{sample volume in database - ..Liter, Volume option value - Automatic|Volume, sample ID - Object[Sample]}..}*)
		Flatten[
			MapThread[
				Function[
					{input,volumeOption},
					If[MatchQ[input, ObjectP[Object[Sample]]],
						(* If input is an object sample, only one set of {sample volume, volume option, Object[Sample]}*)
						{{fastAssocLookup[fastAssoc, input, Volume],volumeOption,input}},
						
						(* If input is an object container, there can be multiple sample contents and it is possible to have multiple sets of {sample volume, volume option, Object[Sample]}*)
						Map[{fastAssocLookup[fastAssoc, #, Volume],volumeOption,#} &, fastAssocLookup[fastAssoc, input, Contents][[All, 2]]]
					]
				],
				{listedInputs,Lookup[expandedSafeOps,Volume]}
			],
			1
		]
	];
	
	(* If Volume option is Automatic, check the volume of the index matched sample considering a max of 40 mL*)
	(* If Volume option is not Automatic, use the Volume option to evaluate the allInputSampleLargeVolumeBoolean considering a max of 10 mL*)
	allInputSampleLargeVolumeBoolean = Map[
		If[MatchQ[#[[2]],Automatic],
			MatchQ[#[[1]],GreaterEqualP[40 Milliliter]],
			MatchQ[#[[2]],GreaterEqualP[10 Milliliter]]
		]&,
		allInputVolumeOptionTuples
	];
	
	(* Volume check for options*)
	(* Get specified object samples for options {RetentateWashBuffer, ResuspensionBuffer} to check for liquid handler compatible volumes *)
	allBufferOptionSamples = Cases[Lookup[safeOps,{RetentateWashBuffer, ResuspensionBuffer}],ObjectP[Object[Sample]]];
	
	(* Check if samples specified for the options are greater than 40 mL *)
	allOptionSampleLargeVolumeBoolean = Map[
		MatchQ[fastAssocLookup[allSamplePackets,#,Volume],GreaterEqualP[40 Milliliter]]&,
		allBufferOptionSamples
	];
	
	(* Combine the two booleans and use for Error Message later *)
	allSampleLargeVolumeBoolean=Flatten[{allInputSampleLargeVolumeBoolean,allOptionSampleLargeVolumeBoolean}];
	
	allSampleLargeVolumeQ = MemberQ[allSampleLargeVolumeBoolean,True];

	(* get the sample packets for each input *)
	indexMatchingSamplePackets = Map[
		Function[{sampleContainerOrAutomatic},
			Switch[sampleContainerOrAutomatic,
				Automatic, <||>,
				ObjectP[Object[Sample]], fetchPacketFromFastAssoc[sampleContainerOrAutomatic, fastAssoc],
				_,
					Map[
						fetchPacketFromFastAssoc[#, fastAssoc]&,
						Lookup[fetchPacketFromFastAssoc[sampleContainerOrAutomatic, fastAssoc], Contents][[All, 2]]
					]
			]
		],
		listedInputs
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible",
			Nothing
		],
		If[MatchQ[allSolutionsLiquidHandlerCompatibleQ, False],
			"the samples " <> ToString[ObjectToString/@PickList[Flatten[{allSamplePackets, sampleModelPackets}],Lookup[Flatten[{allSamplePackets, sampleModelPackets}], LiquidHandlerIncompatible]]] <> " are not liquid handler compatible",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[
				{
					ImageSample,
					MeasureVolume,
					MeasureWeight,
					CounterbalanceWeight,
					FilterHousing,
					FilterUntilDrained,
					FlowRate,
					PrefilterPoreSize,
					PrewetFilter,
					PrewetFilterTime,
					PrewetFilterBufferVolume,
					PrewetFilterCentrifugeIntensity,
					PrewetFilterBuffer,
					PrewetFilterBufferLabel,
					PrewetFilterContainerOut,
					PrewetFilterContainerLabel
				},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[False|Null|Automatic]]&)
			];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		If[MemberQ[Lookup[expandedSafeOps,FiltrationType], Alternatives[PeristalticPump,Vacuum,Syringe]],
			"the PeristalticPump, Vacuum or Syringe filtration type can only be set for manual preparation",
			Nothing
		],
		If[MemberQ[Lookup[expandedSafeOps,Filter], ObjectP[{Model[Item, Filter], Object[Item, Filter], Model[Container, Vessel, Filter], Object[Container, Vessel, Filter]}]],
			"the specified filter type can only be set for manual preparation",
			Nothing
		],
		If[MatchQ[allSampleLargeVolumeQ, True],
			"the volumes of the samples " <> ToString[PickList[Flatten[{allInputVolumeOptionTuples[[All,3]],allBufferOptionSamples}],allSampleLargeVolumeBoolean]] <> " can only be handled using manual preparation",
			Nothing
		],
		If[MemberQ[expandedSafeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[expandedSafeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		(* NOTE: No filter sample prep options for ExperimentFilter. *)
		If[MemberQ[expandedSafeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[Null|Automatic]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOps, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		Module[{roboticOnlyOptions},
			roboticOnlyOptions=Select[{Counterweight,Pressure,RetentateWashPressure,Volume},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]]&)];

			If[Length[roboticOnlyOptions]>0,
				"the following Robotic-only options were specified "<>ToString[roboticOnlyOptions],
				Nothing
			]
		],
		If[MemberQ[Lookup[expandedSafeOps,FiltrationType], AirPressure],
			"the AirPressure filtration type can only be set for robotic preparation",
			Nothing
		],
		If[MatchQ[Lookup[safeOps, Preparation], Robotic],
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
		!MatchQ[Lookup[safeOps, Preparation], Automatic],
			Lookup[safeOps, Preparation],
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
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Filter primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];


(* hard code the centrifuges and pressure filters used on the liquid handler right now *)
(* once all the fields are populated properly we can actually use this but for now we can't because they aren't*)
allLiquidHandlerCentrifuges[]:={
	Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
	Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"] (*Model[Instrument, Centrifuge, "VSpin"]*)
};
allLiquidHandlerPressureManifolds[]:={
	Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"] (* Model[Instrument, PressureManifold, "MPE2"] *)
};

(* define the phytip column object. *)
(* obviously hard coded; will make this better later when SPE happens TODO *)
phytipColumnModels[] := {
	Model[Container, Vessel, "id:zGj91a7nlzM6"] (* Model[Container, Vessel, "PhyTip 5K Desalting Column"] *)
};

(* this function is useful *)
(* so {a, b, c, b, d, e, f, c, c, c, a} would return {1, 1, 1, 2, 1, 1, 1, 2, 3, 4, 2} *)
runningTally[list_List]:=MapIndexed[
	Count[Take[list, First[#2]], #1]&,
	list
];

Options[calculateDestWells] = {Simulation -> Null, DestinationContainerLabel -> Automatic, Positions -> Automatic};
(* private function that generates what destination wells to use; probably don't actually want to use this unless we have to *)
calculateDestWells[{}, ops:OptionsPattern[]]:={};
calculateDestWells[myDestsToTransferTo : {(Null|ObjectP[{Object[Container], Model[Container], Object[Item, Filter], Model[Item, Filter]}])...}, ops : OptionsPattern[]] := Module[
	{currentOccupiedPositions, allowedDestPositions, containerDownloadFields, modelDownloadFields,
		downloadFields, inheritedSimulation, destLabels, expandedDestLabels, destsAndLabels,
		availPositionsPerDest, runningTallyDests, destinationWellsToTransferTo, labelToSpecifiedPositions,
		unoccupiedPositionsPerDest, modelContainerPackets, expandedPositions, positions, mergedLabelsToPositions,
		containerDestsToTransferTo, containerDestLabels, containerPositions, itemFilterPositions, containerOrNotBooleans},

	(* pull out the options because this is important for Downloading and resolving if given models *)
	{inheritedSimulation, destLabels, positions} = Lookup[SafeOptions[calculateDestWells, ToList[ops]], {Simulation, DestinationContainerLabel, Positions}];

	(* expand the destination labels to be the correct length *)
	expandedDestLabels = If[ListQ[destLabels],
		destLabels,
		ConstantArray[destLabels, Length[myDestsToTransferTo]]
	];
	expandedPositions = If[ListQ[positions],
		positions,
		ConstantArray[positions, Length[myDestsToTransferTo]]
	];

	(* filter out the destinations, destination labels, and positions for filters that are Items since those are just going to be Null *)
	containerDestsToTransferTo = Cases[myDestsToTransferTo, ObjectP[{Object[Container], Model[Container]}]];
	containerDestLabels = PickList[expandedDestLabels, myDestsToTransferTo, ObjectP[{Object[Container], Model[Container]}]];
	containerPositions = PickList[expandedPositions, myDestsToTransferTo, ObjectP[{Object[Container], Model[Container]}]];

	(* need different fields if we're downloading from a container or a model container (assume model container is empty) *)
	containerDownloadFields = {
		Field[Contents[[All, 1]]],
		Packet[Model[Positions]]
	};
	modelDownloadFields = {
		{},
		Packet[Positions]
	};
	downloadFields = Map[
		If[MatchQ[#, ObjectP[Model[Container]]],
			modelDownloadFields,
			containerDownloadFields
		]&,
		containerDestsToTransferTo
	];

	(* download values from the destinations *)
	{
		currentOccupiedPositions,
		modelContainerPackets
	} = If[MatchQ[containerDestsToTransferTo, {}],
		{{}, {}},
		Transpose[Download[
			containerDestsToTransferTo,
			Evaluate[downloadFields],
			Simulation -> inheritedSimulation
		]]
	];

	(* for each label, get the positions that we're saying is occupied already so we can't pick that one *)
	labelToSpecifiedPositions = MapThread[
		Function[{dest, destLabel, position},
			Which[
				StringQ[destLabel], destLabel -> position,
				MatchQ[dest, ObjectP[Object[Container]]], dest -> position,
				True, Nothing
			]
		],
		{containerDestsToTransferTo, containerDestLabels, containerPositions}
	];
	mergedLabelsToPositions = Merge[labelToSpecifiedPositions, Join];

	(* pull out the allowed destination positions *)
	allowedDestPositions = Lookup[#, Name]& /@ Lookup[modelContainerPackets, Positions, {}];

	(* get the unoccupied positions for each destination *)
	unoccupiedPositionsPerDest = MapThread[
		Function[{occupiedPositions, allowedPositions, label, dest},
			Which[
				StringQ[label], DeleteCases[allowedPositions, Alternatives @@ Join[occupiedPositions, Lookup[mergedLabelsToPositions, label]]],
				MatchQ[dest, ObjectP[Object[Container]]], DeleteCases[allowedPositions, Alternatives @@ Join[occupiedPositions, Lookup[mergedLabelsToPositions, dest]]],
				True, DeleteCases[allowedPositions, Alternatives @@ occupiedPositions]
			]
		],
		{currentOccupiedPositions, allowedDestPositions, containerDestLabels, containerDestsToTransferTo}
	];

	(* combine the labels and destinations to transfer to because if you have two models you don't necessarily mean them to be the same ones *)
	destsAndLabels = Transpose[{containerDestsToTransferTo, containerDestLabels}];

	(* Get the running tally of every destination, and make rules connecting the destination to the available positions *)
	availPositionsPerDest = DeleteDuplicates[MapThread[
		#1 -> #2&,
		{destsAndLabels, unoccupiedPositionsPerDest}
	]];
	runningTallyDests = runningTally[destsAndLabels];

	(* get the destination wells we're transferring to *)
	destinationWellsToTransferTo = MapThread[
		If[StringQ[#3],
			#3,
			(* have to do Key[#1] because at this point #1 is a list and so Lookup thinks it means two arguments; Key solves that *)
			Lookup[availPositionsPerDest, Key[#1]][[#2]]
		]&,
		{destsAndLabels, runningTallyDests, containerPositions}
	];

	(* make the list of the specified positions for item filters that we are going to use to reasemble things with RiffleAlternatives *)
	(* if anything is still Automatic here, it is going to be Null instead *)
	itemFilterPositions = PickList[expandedPositions, myDestsToTransferTo, Except[ObjectP[{Object[Container], Model[Container]}]]] /. {Automatic -> Null};

	(* make a Boolean list to indicate if we have a container or a non-container *)
	containerOrNotBooleans = MatchQ[#, ObjectP[{Object[Container], Model[Container]}]]& /@ myDestsToTransferTo;

	RiffleAlternatives[destinationWellsToTransferTo, itemFilterPositions, containerOrNotBooleans]

];
