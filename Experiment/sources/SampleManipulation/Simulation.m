(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*SampleManipulation Simulation*)


(* ::Subsubsection:: *)
(*simulateSampleManipulation*)


Authors[simulateSampleManipulation]:={"robert", "alou"};


(* simulateSampleManipulation returns a tuple in the form: {packets, defined name lookup}
	where 'packets' is a list of all relevant packets with field values reflecting the state of the objects after the input primitives have executed.
	and 'defined name lookup' is a list of rules associating a defined name with its object *)
simulateSampleManipulation[myRawManipulations:{SampleManipulationP..},myOptions:OptionsPattern[ExperimentSampleManipulation]]:=Module[
	{protocolPacket,requiredObjects,liquidHandlingScale,requiredObjectsLookup,requiredSampleModelResourceTuples,
	requiredSampleModels,requiredSampleModelResources,requiredContainerModelResourceTuples,requiredContainerModels,requiredContainerModelResources,
	requiredSampleContainerModels,requiredSampleModelAmountRules,simulatedSampleObjects,simulatedSamplesContainersIn,simulatedSamplesIn,
	simulatedSamplesInContainers,simulatedContainersIn,resolvedRequiredObjectRules,
	resolvedManipulations,resolvedDefinePrimitives,defineReplacements,allReplacements,definePrimitives,definedModels,definedNamesLookup,samples,models,sampleAllFields,modelAllFields,definedModelFields,containerAllFields,downloadPackets,containers,allPackets,uniqueSamplePackets,uniqueContainerPackets,allSamplePackets,specifiedManipulations,
	samplePackets,extraUpdatePackets,rawSamplePackets,parentProtocol,rootProtocol,
	spoofedCoreSamples,extraPacketsWithMergedContents,fullNewSamplePackets,allNewPackets,fullySpecifiedManipulations,manipulationTuples,sampleTransferUpdates,rawPackets,mergedPackets,replacementsWithSampleReferences,resolvedDefinitions},

	(* Build the protocol packet that would be generated for the input manipulations *)
	protocolPacket = ExperimentSampleManipulation[myRawManipulations,Upload->False,Simulation->True,myOptions];

	(* Extract the RequiredObjects field *)
	requiredObjects = Lookup[protocolPacket,Key[Replace[RequiredObjects]]];

	(* Extract the resolved liquid handling scale *)
	liquidHandlingScale = Lookup[protocolPacket,LiquidHandlingScale];

	(* Build lookup table to conver a container or tagged model to its resource *)
	requiredObjectsLookup = Association[Rule@@@requiredObjects];

	(* Models that need to be resolved to samples will have the form (in RequiredObjects) as:
	 	{{tag,Model[Sample]},Link[_Resource]} or
		{_String,Link[_Resource]} where the Resourcee's sample is a Model[Sample]
	Extract these tuples and strip off the Resource's link *)
	requiredSampleModelResourceTuples = Cases[
		requiredObjects,
		{modelIdentifier:({_,ObjectP[Model[Sample]]}|_String),resourceLink:Link[_Resource]}:>If[
			MatchQ[First[resourceLink][Sample],ObjectP[Model[Sample]]],
			{modelIdentifier,First[resourceLink]},
			Nothing
		]
	];

	(* Extract the resources for each required model *)
	requiredSampleModelResources = requiredSampleModelResourceTuples[[All,2]];

	(* Extract the actual requested model from the resource *)
	requiredSampleModels = (#[Sample])&/@requiredSampleModelResources;

	(* Container models that need to be resolved to containers will have the form (in RequiredObjects) as:
	 	{{tag,Model[Container]},Link[_Resource]} or
		{_String,Link[_Resource]} where the Resourcee's sample is a Model[Container]
	Extract these tuples and strip off the Resource's link *)
	requiredContainerModelResourceTuples = Cases[
		requiredObjects,
		{modelIdentifier:({_,ObjectP[Model[Container]]}|_String),resourceLink:Link[_Resource]}:>If[
			MatchQ[First[resourceLink][Sample],ObjectP[Model[Container]]],
			{modelIdentifier,First[resourceLink]},
			Nothing
		]
	];

	(* Extract the resources for each required container model *)
	requiredContainerModelResources = requiredContainerModelResourceTuples[[All,2]];

	(* Extract the actual requested container model from the resource *)
	requiredContainerModels = (#[Sample])&/@requiredContainerModelResources;

	(* For each required sample model, determine the container it will be in
	NOTE: we restrict the container model in order to do make things deterministic *)
	requiredSampleContainerModels = Map[
		(#[Container])&,
		requiredSampleModelResources
	];

	(* Extract the amount required from the Resource and build the amount-related field-value rules *)
	requiredSampleModelAmountRules = Map[
		Join[
			{ExpirationDate -> Null},
			Switch[#[Amount],
				VolumeP,
					{
						Volume -> #[Amount],
						VolumeLog -> {},
						Mass -> Null,
						MassLog -> {},
						Count -> Null,
						CountLog -> {}
					},
				MassP,
					{
						Volume -> Null,
						VolumeLog -> {},
						Mass -> #[Amount],
						MassLog -> {},
						Count -> Null,
						CountLog -> {}
					},
				_Integer,
					{
						Volume -> Null,
						VolumeLog -> {},
						Mass -> Null,
						MassLog -> {},
						Count -> #[Amount],
						CountLog -> {}
					},
				_,
					{}
			]
		]&,
		requiredSampleModelResources
	];

	(* Simulate the sample and container that will fulfill each required model
	return in the form: {{{sample packet},container packet}..} *)
	simulatedSamplesContainersIn = If[Length[requiredSampleModels]>0,
		MapThread[
			SimulateSample[{#1},#2,{#3},#4,#5]&,
			{
				requiredSampleModels,
				Table["",Length[requiredSampleModels]],
				Table["A1",Length[requiredSampleModels]],
				requiredSampleContainerModels,
				requiredSampleModelAmountRules
			}
		],
		{}
	];

	(* Extract the simulated sample packets. NOTE: SimulateSample returns a list of sample packets
	in each first index (corresponding to all samples in the container in index 2).
	In our case, we assume there will only be one sample per container. *)
	simulatedSamplesIn = simulatedSamplesContainersIn[[All,1]][[All,1]];

	(* Extract the simulated container packets *)
	simulatedSamplesInContainers = simulatedSamplesContainersIn[[All,2]];

	(* Build simulated container packets that will fulfill container model requests *)
	simulatedContainersIn = Map[
		Module[{type},

			type = Object@@Download[#,Type];

			Association[
				Type -> type,
				Object -> SimulateCreateID[type],
				Model -> Link[#,Objects],
				Contents -> {},
				Simulated -> True,
				Site -> Link[$Site],
				Notebook -> Link[$Notebook, Objects]
			]
		]&,
		requiredContainerModels
	];

	(* Replace the resources in RequiredObjects' 2nd indices with the simulated objects *)
	resolvedRequiredObjectRules = Join[
		MapThread[
			#1[[1]] -> Lookup[#2,Object]&,
			{requiredSampleModelResourceTuples,simulatedSamplesIn}
		],
		MapThread[
			#1[[1]] -> Lookup[#2,Object]&,
			{requiredContainerModelResourceTuples,simulatedContainersIn}
		]
	];

	(* Extract Define primitives *)
	definePrimitives = Cases[Lookup[protocolPacket,Key[Replace[ResolvedManipulations]]],_Define];

	(* Extract any forced model casts *)
	definedModels = Cases[#[Model]&/@definePrimitives,ObjectP[]];

	(* Build association lookup of "Name" -> Define primitive *)
	definedNamesLookup = Association@Flatten@Map[
		{
			(#[Name] -> #),
			If[MatchQ[#[SampleName],_String],
				#[SampleName] -> #,
				Nothing
			],
			If[MatchQ[#[ContainerName],_String],
				#[ContainerName] -> #,
				Nothing
			]
		}&,
		definePrimitives
	];

	(* Replace any resolved references in Define primitives  *)
	resolvedDefinePrimitives = Map[
		Define[
			Prepend[
				(* If there's a reference to a resolved object, it will be replaced here *)
				KeyDrop[First[#],{Name,ContainerName}]/.resolvedRequiredObjectRules,
				(* But we still need to consider the case where a resolved RequiredObject is explicitly defined
				by the Define primitive. Ie: The Name or ContainerName string exists in resolvedRequiredObjectRules *)
				Join[
					If[KeyExistsQ[First[#],Name],
						{
							Name -> #[Name],
							Which[
								KeyExistsQ[First[#],Sample]&&KeyExistsQ[resolvedRequiredObjectRules,#[Name]],
									Sample -> Lookup[resolvedRequiredObjectRules,#[Name]],
								KeyExistsQ[First[#],Container]&&KeyExistsQ[resolvedRequiredObjectRules,#[Name]],
									Container -> Lookup[resolvedRequiredObjectRules,#[Name]],
								True,
									Nothing
							]
						},
						{}
					],
					If[KeyExistsQ[First[#],ContainerName],
						{
							ContainerName -> #[ContainerName],
							If[KeyExistsQ[First[#],Container]&&KeyExistsQ[resolvedRequiredObjectRules,#[ContainerName]],
								Container -> Lookup[resolvedRequiredObjectRules,#[ContainerName]],
								{}
							]
						},
						{}
					]
				]
			]
		]&,
		definePrimitives
	];

	(* Build replacement rules for defined names *)
	defineReplacements = Join@@Map[
		Function[primitive,
			Module[{defineAssociation},

				defineAssociation = First[primitive];

				{
					Which[
						KeyExistsQ[defineAssociation,Sample],
							defineAssociation[Name] -> defineAssociation[Sample],
						KeyExistsQ[defineAssociation,Container]&&!KeyExistsQ[defineAssociation,Sample]&&!KeyExistsQ[defineAssociation,Well],
							defineAssociation[Name] -> defineAssociation[Container],
						KeyExistsQ[defineAssociation,Container]&&!KeyExistsQ[defineAssociation,Sample]&&KeyExistsQ[defineAssociation,Well],
							defineAssociation[Name] -> {defineAssociation[Container],defineAssociation[Well]},
						True,
							Nothing
					],
					If[KeyExistsQ[defineAssociation,ContainerName],
						defineAssociation[ContainerName] -> defineAssociation[Container],
						Nothing
					]
				}
			]
		],
		resolvedDefinePrimitives
	];

	(* Join both the RequiredObjects replacements and the Defined names replacements *)
	allReplacements = Merge[Join[resolvedRequiredObjectRules,defineReplacements],Last];

	(* Replace all references to simulated objects in the manipulations *)
	resolvedManipulations = Map[
		(* Don't replace anything in a Define *)
		If[MatchQ[#,_Define],
			#,
			#/.allReplacements
		]&,
		Lookup[protocolPacket, Key[Replace[ResolvedManipulations]]]
	];

	(* Find all samples and models in primitives. Use original ResolvedManipulations since updated
	manipulations will have simulated samples in them. *)
	samples = findObjectsOfTypeInPrimitive[Lookup[protocolPacket,Key[Replace[ResolvedManipulations]]],Object[Sample]];
	models = findObjectsOfTypeInPrimitive[Lookup[protocolPacket,Key[Replace[ResolvedManipulations]]],Model[Sample]];
	containers = findObjectsOfTypeInPrimitive[Lookup[protocolPacket,Key[Replace[ResolvedManipulations]]],Object[Container]];
	parentProtocol = Lookup[ToList@myOptions,ParentProtocol,Null];

	(* Build list of sample fields required *)
	(* These $ global variables store the list of fields needed for all experiment functions, including SM. *)
	sampleAllFields = {
		Packet@@InternalUpload`Private`$RequiredObjectSampleFields,
		Packet[Model[InternalUpload`Private`$RequiredModelSampleFields]]
	};

	(* Build list of model fields required *)
	modelAllFields = {Packet@@InternalUpload`Private`$RequiredModelSampleFields};

	(* Build list of fields required for defined models *)
	definedModelFields = {Packet@@InternalUpload`Private`$RequiredModelSampleFields};

	(* Build list of model fields required *)
	containerAllFields = {Packet@@(InternalUpload`Private`$RequiredObjectContainerFields)};

	(* Download *)
	downloadPackets = Quiet[Download[
		{samples,models,definedModels,containers,{parentProtocol}},
		{sampleAllFields,modelAllFields,definedModelFields,containerAllFields,{ParentProtocol..}}
	],{Download::MissingField,Download::FieldDoesntExist,Download::NotLinkField}];

	(* Merge all packets so we can use it as a psuedo cache *)
	allPackets = DeleteDuplicatesBy[
		DeleteCases[Flatten[Most[downloadPackets]],Null|$Failed],
		#[Object]&
	];

	rootProtocol=Last[Flatten[Last[downloadPackets]], parentProtocol];

	(* Extract downloaded sample packets *)
	uniqueSamplePackets = Cases[allPackets,ObjectP[Object[Sample]]];

	(* Extract downloaded container packets *)
	uniqueContainerPackets = Cases[allPackets,ObjectP[Object[Container]]];

	(* Join simulated sample packets with real sample packets *)
	allSamplePackets = Join[
		Cases[simulatedSamplesIn,PacketP[Object[Sample]]],
		uniqueSamplePackets
	];

	(* Fill out further manipulation information now that all samples and containers are fulfilled *)
	specifiedManipulations = Map[
		specifyManipulation[#,Cache->allSamplePackets,DefineLookup->definedNamesLookup]&,
		resolvedManipulations
	];

	(* Call compiler helper that generates all new packets from a sample manipulation *)
	{samplePackets,extraUpdatePackets} = newObjectsForTransfers[
		protocolPacket,
		specifiedManipulations,
		Cache -> Flatten[{
			allPackets,
			simulatedSamplesIn,
			simulatedSamplesInContainers,
			simulatedContainersIn,
			protocolPacket
		}],
		DefineLookup -> definedNamesLookup,
		RootProtocol -> rootProtocol
	];

	(* Strip off change packet Append, Replace, Transfer heads in samplePackets *)
	rawSamplePackets = Map[
		KeyMap[
			If[MatchQ[#,_Replace|_Append|_Transfer],
				First[#],
				#
			]&,
			#
		]&,
		samplePackets
	];

	(* Since UploadSample doesn't prepare packets with the Container field,
	and since specifyManipulation needs to know that, spoof it*)
	spoofedCoreSamples=If[MatchQ[extraUpdatePackets,{}],
		{},
		Map[
			Association[
				Object->FirstCase[Flatten[#[[2]]], ObjectP[]][Object],
				Container->Link[#[[1]]],
				Well->#[[2]][[1]][[1]],
				Position->#[[2]][[1]][[1]],
				Volume -> Null,
				VolumeLog -> {},
				Mass -> Null,
				MassLog -> {},
				Count -> Null,
				CountLog -> {}
			]&,
			Lookup[
				Cases[Flatten[extraUpdatePackets],KeyValuePattern[{Object -> ObjectP[Object[Container]],Append[Contents] -> _}]],
				{Object, Append[Contents]}
			]
		]
	];

	(* If multiple packets of the same container exist with contents, we need to merge their contents *)
	extraPacketsWithMergedContents = Map[
		If[And[MatchQ[Lookup[#[[1]],Object],ObjectP[Object[Container]]],Length[#]>0],
			Append[
				#[[1]],
				{
					Append[Contents] -> Join@@Map[
						Lookup[#,Key[Append[Contents]],{}]&,
						#
					],
					Append[ContentsLog] -> Join@@Map[
						Lookup[#,Key[Append[ContentsLog]],{}]&,
						#
					]
				}
			],
			#[[1]]
		]&,
		GatherBy[extraUpdatePackets,Lookup[#,Object]&]
	];

	(* Combine the core sample packets created by UploadSample with the more specific ones
	we have been making via the graph traversal;
	UploadSample created IDs for us, so we have Object key in these now *)
	fullNewSamplePackets=MapThread[
		Join[
			(* A "Null packet" so-to-speak that populates fields needed by sample-prep *)
			Association[
				Simulated -> True,
				MassConcentration -> Null,
				Concentration -> Null,
				TotalProteinConcentration -> Null,
				Status -> Null,
				Sterile -> Null,
				StorageCondition -> Null,
				ThawTime -> Null,
				ThawTemperature -> Null,
				Density -> Null,
				LightSensitive -> Null,
				State -> Null,
				pH -> Null,
				DensityLog -> {},
				RequestedResources -> {},
				MaintenanceLog -> {},
				Protocols -> {},
				QualificationLog -> {},
				BoilingPoint -> Null,
				DOTHazardClass->Null,
				DrainDisposal->Null,
				ExpirationHazard->Null,
				Fuming->Null,
				IncompatibleMaterials->{},
				LiquidHandlerIncompatible->Null,
				MSDSFile->Null,
				MSDSRequired->Null,
				NFPA->Null,
				ParticularlyHazardousSubstance->Null,
				Pungent->Null,
				Radioactive->Null,
				WaterReactive->Null,
				Tags->{},
				Analytes->{},
				Composition->{},
				Solvent -> {}
			],
			#1,
			#2
		]&,
		{rawSamplePackets,spoofedCoreSamples}
	];

	(* Build list of all real, simulated, and generated packets *)
	allNewPackets = Join[
		fullNewSamplePackets,
		simulatedSamplesIn,
		uniqueSamplePackets,
		uniqueContainerPackets,
		simulatedSamplesInContainers,
		simulatedContainersIn
	];

	(* Now all information is generated to fully specify primitives *)
	fullySpecifiedManipulations = Map[
		specifyManipulation[#,Cache->Join[allSamplePackets,allNewPackets],DefineLookup->definedNamesLookup]&,
		specifiedManipulations
	];

	(* Build tuples representing transfers in the set of primitives in the form: {source, destination, amount} *)
	manipulationTuples = Join@@expandManipulations[fullySpecifiedManipulations,Priority->Sample];

	(* Create transfer change packets *)
	(* UploadSampleTransfer updates the safety fields for our Model[Sample]s. *)
	sampleTransferUpdates = UploadSampleTransfer[
		manipulationTuples[[All,1]],
		manipulationTuples[[All,2]],
		manipulationTuples[[All,3]],
		Cache -> Join[allPackets,allNewPackets],
		UpdateModel -> False,
		FastTrack -> True,
		Upload -> False
	];

	(* Strip off change packet Append, Replace, Transfer heads *)
	rawPackets = Map[
		KeyMap[
			If[MatchQ[#,_Replace|_Append|_Transfer],
				First[#],
				#
			]&,
			#
		]&,
		Cases[
			Join[allNewPackets,sampleTransferUpdates,extraPacketsWithMergedContents],
			ObjectP[{Object[Sample],Object[Container],Model[Sample],Model[Container]}]
		]
	];

	(* Merge packets for the same object *)
	mergedPackets = Map[
		Join@@#&,
		GatherBy[
			rawPackets,
			Lookup[#,Object]&
		]
	];

	(* If there is reference to an {container, well} tuple, replace it with the sample at that position *)
	replacementsWithSampleReferences = KeyValueMap[
		If[MatchQ[#2,{ObjectP[],WellPositionP}],
			#1 -> FirstCase[
				Lookup[fetchPacketFromCacheHPLC[#2[[1]],mergedPackets],Contents],
				{#2[[2]],sample:ObjectP[]}:>Download[sample,Object]
			],
			#1 -> #2
		]&,
		Association[allReplacements]
	];

	(* Build lookup relating Define names to the simulated (or existing) objects *)
	resolvedDefinitions = KeyValueMap[
		Function[{name,primitive},
			Which[
				(* If a defined name is in the resolved RequiredObjects, use that object,
				If it is not, it means that a specific sample or container was defined *)
				KeyExistsQ[replacementsWithSampleReferences,name],
					name -> Lookup[replacementsWithSampleReferences,name],
				MatchQ[primitive[ContainerName],name],
					name -> If[MatchQ[primitive[Sample],{ObjectP[Object[Container]],WellPositionP}],
						primitive[Sample][[1]],
						primitive[Container]
					],
				MatchQ[primitive[Sample],ObjectP[]],
					name -> primitive[Sample],
				MatchQ[primitive[Sample],{ObjectP[],WellPositionP}],
					name -> FirstCase[
						Lookup[fetchPacketFromCacheHPLC[primitive[Sample][[1]],mergedPackets],Contents],
						{primitive[Sample][[2]],sample:ObjectP[]}:>Download[sample,Object]
					],
				MatchQ[primitive[Sample],{_String,WellPositionP}],
					Module[{containerObject},

						(* Lookup container referenced by Defined string *)
						containerObject = If[KeyExistsQ[resolvedRequiredObjectRules,primitive[Sample][[1]]],
							Lookup[resolvedRequiredObjectRules,primitive[Sample][[1]]],
							Lookup[definedNamesLookup,primitive[Sample][[1]]][Container]
						];

						name -> FirstCase[
							Lookup[fetchPacketFromCacheHPLC[containerObject,mergedPackets],Contents],
							{primitive[Sample][[2]],sample:ObjectP[]}:>Download[sample,Object]
						]
					],
				MatchQ[{primitive[Container],primitive[Well]},{ObjectP[],WellPositionP}],
					name -> FirstCase[
						Lookup[fetchPacketFromCacheHPLC[primitive[Container],mergedPackets],Contents],
						{primitive[Well],sample:ObjectP[]}:>Download[sample,Object]
					],
				MatchQ[primitive[Container],ObjectP[]],
					name -> primitive[Container]
			]
		],
		definedNamesLookup
	];

	(* Return expected tuple *)
	{mergedPackets,resolvedDefinitions}
];


(* ::Subsubsection:: *)
(*newObjectsForTransfers*)


Options[newObjectsForTransfers]:={Cache->{},DefineLookup-><||>,RootProtocol->Null};

newObjectsForTransfers[myProtocolPacket:ObjectP[],myManipulations_List,ops:OptionsPattern[]]:=Module[
	{allSamplePackets,transferGraph,orderedVertices,definedNamesLookup,definePrimitives,
	fetchDefinePrimitive,definedLocationLookup,fillToVolumeLocations,transferGraphWithSampleInfomation,
	vertexList,nonNullSampleSimulationPositions,simulatedSampleModels,updatedVertexList,
	potentialNewSampleVertices,simulatedSamplePackets,manipulationTuples,sampleTransferTuples,
	uploadSampleTransferPackets,newSampleVertices,uniqueNewSampleVertices,newSampleLocations,
	newSampleSourcePackets,newSampleCompositions,newSampleOptions,combinedNewSampleOptions,
	newMoveDestinations,storageConditions,rawUploadSampleCache,mergedUploadSampleCache,uploadSampleCache,
	extraUpdatePackets,fullNewSamplePackets,updatedFullNewSamplePackets,rootProtocol},

	allSamplePackets = Cases[OptionValue[Cache],ObjectP[Object[Sample]]];
	rootProtocol = OptionValue[RootProtocol];

	(* construct a graph to represent the state-dependent progression of the manipulations through the locations;
	 	- graph vertices are locations (with a state identifier to disambiguate locations that are changed multiple times),
			and edges are transfers between locations;
		- vertices are specified in the form {location,state index}
		- state index is only incremented when a location serves as both a source AND a destination *)
	transferGraph = manipulationGraph[myManipulations];

	(* use MM's TopologicalSort to return a flat list of the transfer graph vertices such that every vertex appears only after ALL
	 of the vertices that direct transfers at it; for us, this means that for each vertex in this ordered list, if we process
	the list in order, we can be confident that all vertices that are "before" the vertex in question have already been inspected *)
	orderedVertices = TopologicalSort[transferGraph];

	definedNamesLookup = OptionValue[DefineLookup];
	definePrimitives = Values[definedNamesLookup];

	(* Fetch define primitive corresponding to a name *)
	fetchDefinePrimitive[name_String]:=Lookup[definedNamesLookup,name,Null];
	(* Fetch define primitive of a location that includes a name  *)
	fetchDefinePrimitive[namePositionTuple:{_String,WellPositionP}]:=SelectFirst[
		definePrimitives,
		MatchQ[#[Sample],namePositionTuple]&,
		Null
	];
	fetchDefinePrimitive[_]:=Null;

	(* Create a lookup relating a location to a definition in the form <|location -> define primitive...|> *)
	definedLocationLookup = Association[
		DeleteCases[
			Join@@MapThread[
				Function[{unresolvedManipulation,specifiedManipulation},
					Switch[unresolvedManipulation,
						_Transfer,
							Join[
								Join@@MapThread[
									#2 -> fetchDefinePrimitive[#1]&,
									{unresolvedManipulation[Source],specifiedManipulation[ResolvedSourceLocation]},
									2
								],
								Join@@MapThread[
									#2 -> fetchDefinePrimitive[#1]&,
									{unresolvedManipulation[Destination],specifiedManipulation[ResolvedDestinationLocation]},
									2
								]
							],
						_FillToVolume,
							{
								specifiedManipulation[ResolvedSourceLocation] -> fetchDefinePrimitive[unresolvedManipulation[Source]],
								specifiedManipulation[ResolvedDestinationLocation] -> fetchDefinePrimitive[unresolvedManipulation[Destination]]
							},
						_Filter,
							Join[
								MapThread[
									#2 -> fetchDefinePrimitive[#1]&,
									{unresolvedManipulation[Sample],specifiedManipulation[ResolvedSourceLocation]}
								],
								If[MatchQ[unresolvedManipulation[CollectionContainer],_String],
									Map[
										If[MatchQ[specifiedManipulation[ResolvedCollectionLocation], {_,WellPositionP}],
											{specifiedManipulation[ResolvedCollectionLocation][[1]],#} -> fetchDefinePrimitive[{unresolvedManipulation[CollectionContainer],#}],
											{specifiedManipulation[ResolvedCollectionLocation],#} -> fetchDefinePrimitive[{unresolvedManipulation[CollectionContainer],#}]
										]&,
										specifiedManipulation[ResolvedSourceLocation][[All,2]]
									],
									{}
								]
							],
						_,
							{}
					]
				],
				{Lookup[myProtocolPacket,Key[Replace[ResolvedManipulations]]],myManipulations}
			],
			_ -> Null
		]
	];

	(* Extract all the position in which we fill-to-volume. This is used downstream to tell if we can
	update the MassConcentration of a sample at a position (ie: we know the volume of this sample so
	if we've transferred in mass (which may modify the volume to be different than the liquid volume
	transferred in), then we know the mass concentration *)
	fillToVolumeLocations = Map[
		#[ResolvedDestinationLocation]&,
		Cases[myManipulations,_FillToVolume]
	];

	(* Add further information to the transfer graph: {location, state index, samplesin packets, simulated sample packet} *)
	transferGraphWithSampleInfomation = Fold[
		Function[{currentGraph,vertexToResolve},
			Module[
				{location,existingSampleIn,verticesWithSampleIndex,vertexWithSampleForLocation,sourceEdges,
				sourceVertices,sourceEdgesWithSamples,sourceVerticesWithSamples,sourceSamplePackets,
				simulatedSampleModel},
				
				(* Pull out just the location; the graph vertex also includes a location state identifier *)
				location = vertexToResolve[[1]];

				(* First, check if we can find an existing SamplesIn packet that is in this location
				 	if the location is a flat container, we can just check the container field
					otherwise check container AND well (it's in a plate) *)
				existingSampleIn = If[MatchQ[location,ObjectP[Object[Container]]],
					SelectFirst[allSamplePackets,MatchQ[Download[Lookup[#,Container],Object],Download[location,Object]]&],
					SelectFirst[allSamplePackets,MatchQ[Download[Lookup[#,Container],Object],Download[location[[1]],Object]]&&MatchQ[Lookup[#,Well],location[[2]]]&]
				];
				
				(* also must check the current graph's vertices as we may have created a new sample packet at this location already
				 	only vertices that have add a third and fourth index added could possible qualify here *)
				verticesWithSampleIndex=Select[VertexList[currentGraph],Length[#]>=3&];

				(* if any of the vertices with already-resolved sample packets have the same location, take that sample packet *)
				vertexWithSampleForLocation=SelectFirst[verticesWithSampleIndex,MatchQ[#[[1]],location]&];

				(* pull out all of the edges/vertices that are direct sources for this location *)
				sourceEdges=Select[EdgeList[currentGraph],MatchQ[#[[2]],vertexToResolve]&];
				sourceVertices=sourceEdges[[All,1]];

				(* isolate edges/vertices where we already have sample information *)
				sourceEdgesWithSamples=Select[sourceEdges,Length[First[#]]>2&];
				sourceVerticesWithSamples=Select[sourceVertices,Length[#]>2&];

				(* Pull all sample/model packets from the source vertices;
				Flatten the sample list in case there are multiple samples in. *)
				sourceSamplePackets = Join[
					If[MatchQ[existingSampleIn,ObjectP[]],
						{existingSampleIn},
						{}
					],
					Flatten[sourceVerticesWithSamples[[All,3]]]
				];
				
				(* If the location has only one source whose sample has a model, inherit that model
				Also if it has multiple sources, all with the same model, inherit that model *)
				simulatedSampleModel = Which[
					MatchQ[existingSampleIn,ObjectP[]],
						Null,
					And[
						Length[sourceSamplePackets] >= 1,
						!MatchQ[Lookup[sourceSamplePackets,Model],{Null..}],
						SameQ@@Download[Lookup[sourceSamplePackets,Model],Object]
					],
						Download[Lookup[sourceSamplePackets[[1]],Model],Object],
					True,
						Model[Sample,"Milli-Q water"]
				];

				(* add the new sample packet and model packets (for later resolution) to this vertex *)
				VertexReplace[currentGraph,vertexToResolve->Join[vertexToResolve,{sourceSamplePackets,simulatedSampleModel}]]
			]
		],
		transferGraph,
		orderedVertices
	];
	
	(* get the graph's vertex lists *)
	vertexList = VertexList[transferGraphWithSampleInfomation];
	
	(* Find positions that have a simulated sample model in the 4th position *)
	nonNullSampleSimulationPositions = Flatten@Position[
		vertexList,
		{_,_,_,ObjectP[]},
		{1},
		Heads -> False
	];

	(* Pull out those models and pass into the simulator *)
	simulatedSampleModels = (vertexList[[All,4]][[nonNullSampleSimulationPositions]]);
	simulatedSamplePackets = First@SimulateSample[
		simulatedSampleModels,
		"",
		(* This is a wild hack to be able to call SimulateSample "listably". We don't really care about
		the well of the sample (in fact we barely care about any of this except the default fields
		but SimulateSample only allows a single container to be taken as input, so we just move all the samples
		into unique "wells" *)
		Map[("A"<>ToString[#])&,Range[Length[simulatedSampleModels]]],
		(* We don't actually care what container we're in. Pick the largest one. *)
		Model[Container,Vessel,"10L Polypropylene Carboy"],
		Table[Volume -> 0 Liter,Length[simulatedSampleModels]],
		InitializeComposition -> False
	];
	
	(* Update vertex list with simulated packets *)
	updatedVertexList = ReplacePart[
		vertexList,
		MapThread[
			#1 -> Join[vertexList[[#1]][[;;3]],{#2}]&,
			{nonNullSampleSimulationPositions,simulatedSamplePackets}
		]
	];
	
	(* Create a list of {source,destination,amount} tuples *)
	manipulationTuples = Join@@Experiment`Private`expandManipulations[myManipulations,Priority->Sample];
	
	(* Convert any location references to samples *)
	sampleTransferTuples = Map[
		Function[tuple,
			Module[{source,destination,amount,sourceSample,destinationSample},
				
				{source,destination,amount} = tuple;
				
				sourceSample = Switch[source,
					ObjectP[Object[Sample]],
						source,
					{ObjectP[Object[Container,Vessel]],_String},
						Lookup[SelectFirst[updatedVertexList,MatchQ[#[[1]],source[[1]]]&][[4]],Object],
					_,
						Lookup[SelectFirst[updatedVertexList,MatchQ[#[[1]],source]&][[4]],Object]
				];
				
				destinationSample = Switch[destination,
					ObjectP[Object[Sample]],
						destination,
					{ObjectP[Object[Container,Vessel]],_String},
						Lookup[SelectFirst[updatedVertexList,MatchQ[#[[1]],destination[[1]]]&][[4]],Object],
					_,
						Lookup[SelectFirst[updatedVertexList,MatchQ[#[[1]],destination]&][[4]],Object]
				];
				
				{sourceSample,destinationSample,amount}
			]
		],
		manipulationTuples
	];

	(* We call UploadSampleTransfer such that it simulates all the samples and determines the Composition
	of the new samples *)
	uploadSampleTransferPackets = UploadSampleTransfer[
		sampleTransferTuples[[All,1]],
		sampleTransferTuples[[All,2]],
		sampleTransferTuples[[All,3]],
		Cache -> Join[simulatedSamplePackets,OptionValue[Cache]],
		Upload -> False
	];
	
	(* screen out any vertices that do not even have a third index - this means we could not locate any source information and won't make a new sample *)
	potentialNewSampleVertices=Select[updatedVertexList,Length[#]>2&];
	
	(* Pull out all of the vertices corresponding to new samples *)
	newSampleVertices = Select[
		potentialNewSampleVertices,
		Function[vertex,
			(* If an existing sample doesn't exist at vertex's location, we need to make a new sample *)
			NullQ@If[MatchQ[vertex[[1]],ObjectP[Object[Container]]],
				SelectFirst[allSamplePackets,MatchQ[Download[Lookup[#,Container],Object],Download[vertex[[1]],Object]]&,Null],
				SelectFirst[allSamplePackets,MatchQ[Download[Lookup[#,Container],Object],Download[vertex[[1]][[1]],Object]]&&MatchQ[Lookup[#,Well],vertex[[1]][[2]]]&,Null]
			]
		]
	];
	
	(* given how the graph was set up, we might still have multiple vertices for the same location;
	 	at this point, these MUST have the same (and only one) sample packet associated with them,
		so we can safely delete duplicates by the location index (first index) *)
	uniqueNewSampleVertices = DeleteDuplicatesBy[newSampleVertices,First];
	
	newSampleLocations = uniqueNewSampleVertices[[All,1]];
	newSampleSourcePackets = uniqueNewSampleVertices[[All,3]];

	(* Build list where each element is either a model or composition representing the input to
	UploadSample for each new sample we need to create *)
	{newSampleCompositions,newSampleOptions} = If[Length[uniqueNewSampleVertices] > 0,
		Transpose@Map[
			Function[vertex,
				Module[
					{container,well,locationDefinePrimitive,options,simulatedSampleID,
					simulatedSamplePacket,composition},
					
					(* Extract location *)
					{container,well} = If[MatchQ[vertex[[1]],ObjectP[Object[Container]]],
						{Download[vertex[[1]],Object],"A1"},
						vertex[[1]]
					];

					(* If the model for the sample is defined at this location, return that model *)
					locationDefinePrimitive = Lookup[definedLocationLookup,Key[vertex[[1]]],Null];
					
					(* If Define primitive specifies sample properties, extract those specifications *)
					options = If[!NullQ[locationDefinePrimitive],
						{
							ExpirationDate -> Lookup[First[locationDefinePrimitive],ExpirationDate,Automatic],
							TransportWarmed -> Lookup[First[locationDefinePrimitive],TransportWarmed,Automatic],
							State -> Lookup[First[locationDefinePrimitive],State,Automatic],
							Expires -> Lookup[First[locationDefinePrimitive],Expires,Automatic],
							ShelfLife -> Lookup[First[locationDefinePrimitive],ShelfLife,Automatic],
							UnsealedShelfLife -> Lookup[First[locationDefinePrimitive],UnsealedShelfLife,Automatic]
						},
						{
							ExpirationDate -> Automatic,
							TransportWarmed -> Automatic,
							State -> Automatic,
							Expires -> Automatic,
							ShelfLife -> Automatic,
							UnsealedShelfLife -> Automatic
						}
					];

					If[
						And[
							!NullQ[locationDefinePrimitive],
							MatchQ[locationDefinePrimitive[Model],ObjectP[]]
						],
						Return[{locationDefinePrimitive[Model],options},Module]
					];
					
					(* If the location has only one source whose sample has a model, inherit that model
					Also if it has multiple sources, all with the same model, inherit that model *)
					If[
						And[
							Length[vertex[[3]]] >= 1,
							!MatchQ[Lookup[vertex[[3]],Model],{Null..}],
							SameQ@@Download[Lookup[vertex[[3]],Model],Object]
						],
						Return[{Download[Lookup[vertex[[3]][[1]],Model],Object],options},Module]
					];
					
					(* Otherwise, find the simulated sample packet in the UploadSampleTransfer return cache *)
					simulatedSampleID = Lookup[vertex[[4]],Object];
					
					(* Find sample packet for simulated sample *)
					(* Just in case we have an empty container, give a different empty packet for our fake simulated sample so we don't have Lookup error *)
					simulatedSamplePacket = SelectFirst[
							uploadSampleTransferPackets,
							And[
								MatchQ[Lookup[#,Object],simulatedSampleID],
								KeyExistsQ[#,Replace[Composition]]
							]&,
							<|Object->simulatedSampleID|>
						];
					
					(* Extract composition *)
					composition = Lookup[simulatedSamplePacket,Replace[Composition],{}];
					
					{composition,options}
				]
			],
			uniqueNewSampleVertices
		],
		{{},{}}
	];
	
	(* Transform option values into index matched lists *)
	combinedNewSampleOptions = Normal@Merge[newSampleOptions,Identity];
	
	(* turn the new sample locations into valid move destinations (flip {plate,well} around and add "A1" to vessels) *)
	newMoveDestinations = Map[
		If[MatchQ[#,{ObjectP[Object[Container,Plate]],_String}],
			Reverse[#],
			{"A1",#}
		]&,
		newSampleLocations
	];
	
	(* we need to manually resolve potential storage condition conflicts here;
	 	determine explicitly what storage condition to set each item to *)
	storageConditions=If[MatchQ[storageCondition,SampleStorageTypeP],
		Map[
			If[
				And[
					!NullQ[Lookup[definedLocationLookup,Key[#],Null]],
					MatchQ[Lookup[definedLocationLookup,Key[#]][StorageCondition],Except[_Missing|Null|Automatic]]
				],
				Lookup[definedLocationLookup,Key[#]][StorageCondition],
				storageCondition
			]&,
			newSampleLocations
		],
		Module[
			{allContainers,uniqueDestinationContainers,sourcePacketsByContainer,
			storageConditionsByContainer,containerConditionLookup},

			(* get all of the unique containers we are moving a new sample into *)
			allContainers = Last/@newMoveDestinations;
			uniqueDestinationContainers = DeleteDuplicates[allContainers];

			(* for each destination container, get a list of all sample packets being put in that container *)
			sourcePacketsByContainer = Map[
				Join@@Extract[newSampleSourcePackets,Position[allContainers,#,{1},Heads->False]]&,
				uniqueDestinationContainers
			];

			(* for each model packet group, decide on a storage condition symbol based on the sample packets' storage condition object *)
			storageConditionsByContainer = Map[
				Function[samplePacketsForContainer,
					FirstOrDefault[Keys[Select[
						$StorageConditions,
						Equal[#[Temperature],Min[Lookup[Experiment`Private`storageConditionTemperatureLookup,Download[Lookup[samplePacketsForContainer,StorageCondition],Object]]]]&
					]],Automatic]
				],
				sourcePacketsByContainer
			];

			(* create a lookup of unique destination container to the storage condition we want to set for all new samples going into it *)
			containerConditionLookup=AssociationThread[uniqueDestinationContainers,storageConditionsByContainer];

			(* return a conditions list index-matched to the full new models list *)
			MapThread[
				If[
					And[
						!NullQ[Lookup[definedLocationLookup,Key[#1],Null]],
						MatchQ[Lookup[definedLocationLookup,Key[#1]][StorageCondition],Except[_Missing|Null|Automatic]]
					],
					Lookup[definedLocationLookup,Key[#1]][StorageCondition],
					Lookup[containerConditionLookup,Key[#2]]
				]&,
				{newSampleLocations,allContainers}
			]
		]
	];

	{fullNewSamplePackets,extraUpdatePackets}=If[Length[uniqueNewSampleVertices]>0,
		TakeDrop[
			If[MatchQ[rootProtocol,ObjectP[]],
				UploadSample[
					newSampleCompositions,
					newMoveDestinations,
					Sequence@@combinedNewSampleOptions,
					StorageCondition->storageConditions,
					FastTrack->True,
					Upload->False,
					InitializeComposition->True,
					Cache->OptionValue[Cache],
					UpdateReadyCheckCache -> False,
					UpdatedBy->rootProtocol
				],
				UploadSample[
					newSampleCompositions,
					newMoveDestinations,
					Sequence@@combinedNewSampleOptions,
					StorageCondition->storageConditions,
					FastTrack->True,
					Upload->False,
					InitializeComposition->True,
					Cache->OptionValue[Cache],
					UpdateReadyCheckCache -> False
				]
			],
			Length[uniqueNewSampleVertices]
		],
		{{},{}}
	];

	(* since Upload->False, unspecified multiple fields may not get correct format in the output packets *)
	(* e.g. Replace[IncompatibleMaterials] -> Null in the packets may cause problem in IncompatibleMaterialsQ for simulated samples *)
	updatedFullNewSamplePackets=Map[
		If[MatchQ[Lookup[#,Replace[IncompatibleMaterials]],Null],
			Association[
				ReplaceRule[
					Normal[#],{Replace[IncompatibleMaterials]->{}}
				]
			],
			#
		]&,fullNewSamplePackets];

	{updatedFullNewSamplePackets,extraUpdatePackets}
];


(* ::Subsubsection::Closed:: *)
(*newSample*)


(*Given a list of source sample packets and their models return a new sample packet and the list of models from which the sample's model must be resolved*)
newSample[mySourceSamplePackets:{PacketP[Object[Sample]]..},myModelPackets:{PacketP[Model[Sample]]..},myDefinePrimitive:(_Define|Null)]:=Module[
	{sourceTypes,highestPriorityType,highestPriorityModelType,highestPriorityModels,allExpirationDates,
		newExpirationDate,compositionRule,newSamplePacket},

	(* lookup the types of the source samples *)
	sourceTypes=Lookup[mySourceSamplePackets,Type];

	(* use the sampleTypeHierarchy to identify the type with the highest priority;
	 	this will be the new sample's type; MAJOR HACK FOR BIOGEN HERE FOR THEIR CONTROL CHEMICAL *)
	highestPriorityType = If[
		And[
			!NullQ[myDefinePrimitive],
			MatchQ[myDefinePrimitive[ModelType],TypeP[]]
		],
		Object[Sample],
		If[Length[myModelPackets] == 1,
			Object[Sample],
			If[MemberQ[Lookup[myModelPackets,Object],Model[Sample,"id:pZx9jo8A8dDM"]],
				Object[Sample],
				First[MaximalBy[sourceTypes,sampleTypeHierarchy[#]/.(_Missing->0)&]]
			]
		]
	];

	(* turn the highest priority type into a Model *)
	highestPriorityModelType=Apply[Model,highestPriorityType];

	(* pull out the model packets of this type, deleting any duplicates *)
	(* if we are dealing with a mixture of TransfectionReagent/Chemical/StockSolution/Media/Matrix, return all the models since we're going to make a new stock solution as the mixture of all of these *)
	highestPriorityModels=If[MatchQ[highestPriorityModelType, TypeP[{Model[Sample], Model[Sample], Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]],
		DeleteDuplicates[myModelPackets],
		DeleteDuplicates[Cases[myModelPackets,PacketP[highestPriorityModelType],{1}]]
	];

	(* pull out all of the sample expiration dates, removing Nulls *)
	allExpirationDates=DeleteCases[Lookup[mySourceSamplePackets,ExpirationDate],Null];

	(* Sort the dates by converting to AbsoluteTime and take the earliest *)
	newExpirationDate=If[
		And[
			!NullQ[myDefinePrimitive],
			MatchQ[myDefinePrimitive[ExpirationDate],_?DateObjectQ]
		],
		myDefinePrimitive[ExpirationDate],
		FirstOrDefault[SortBy[allExpirationDates,AbsoluteTime]]
	];

	(*  if we have just one source that's an SS, use it to pass PreparedAmounts to child sample *)
	compositionRule=If[
		And[
			MatchQ[highestPriorityType,TypeP[{Object[Sample],Object[Sample],Object[Sample]}]],
			Length[mySourceSamplePackets]==1,
			MatchQ[First[mySourceSamplePackets],PacketP[{Object[Sample],Object[Sample],Object[Sample]}]]
		],
		Module[{stockSolutionSourcePacket,compositionToPass},

			(* actually assign the stock solution source packet that we now know is the only one *)
			stockSolutionSourcePacket=First[mySourceSamplePackets];

			(* get the composition from the right field; maybe this ss source is ALSO a change packet, fuuuuck *)
			compositionToPass=If[MatchQ[stockSolutionSourcePacket,PacketP[]],
				Lookup[stockSolutionSourcePacket,Replace[PreparedAmounts]],
				Lookup[stockSolutionSourcePacket,PreparedAmounts]
			];

			(* might just not have composition; so only make the update rule if the thing to pass is a thing *)
			If[MatchQ[compositionToPass,{{ObjectP[],_String,NumericP,_?QuantityQ}..}],
				Replace[PreparedAmounts]->({Link[#[[1]]],#[[2]],#[[3]],#[[4]]}&/@compositionToPass),
				Nothing
			]
		],
		Nothing
	];

	(* make the new sample packet with the fields that can be determined now *)
	(* note that if we are mixing multiple chemicals or transfection reagents, we are instead going to make a stock solution *)
	newSamplePacket = <|
		Type -> If[
			And[
				Or[
					NullQ[myDefinePrimitive],
					!MatchQ[myDefinePrimitive[ModelType],TypeP[]]
				],
				Length[highestPriorityModels] > 1,
				MatchQ[highestPriorityType, TypeP[{Model[Sample], Model[Sample]}]]
			],
			Object[Sample],
			highestPriorityType
		],
		ExpirationDate->newExpirationDate,
		compositionRule
	|>;

	(* return the new sample packet and the list of models from which the sample's model must be resolved *)
	{newSamplePacket,highestPriorityModels}
];


(* ::Subsubsection:: *)
(*modelFromSourceModels*)


(* TODO: This function will be drastically different after samplefest v2. After a transfer, the model should just be Nulled out. *)
(* Any keys passed in the define primitive should set those fields in the Object[Sample] (it's the Model[Sample] right now). *)

(*This function creates a new model oligomer out of a list of model oligomers.*)
(*
	Overload 1: Model[Sample]
*)
modelFromSourceModels[myOligomerModelPackets:{PacketP[Model[Sample]]..}, myDefinePrimitive:(_Define|Null), myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=Module[
	{newName,oligomerStructures,singleStrandStructures,newStructure,existingModels,newPolymerType,newBiosafetyLevel,
	newAuthors,newExpires,newShelfLife, newUnsealedShelfLife,modelPacket,newDefaultStorageCondition},

	(* if the length of the input list is one, this is the model; return the packet as a single item *)
	If[Length[myOligomerModelPackets]==1,
		Return[First[myOligomerModelPackets]]
	];

	(* make a new name for the new model *)
	newName = If[!NullQ[myDefinePrimitive]&&!MatchQ[myDefinePrimitive[ModelName],_Missing],
		myDefinePrimitive[ModelName],
		StringJoin["Mixture of ",StringJoin@@Riffle[Lookup[myOligomerModelPackets,Name]," "]]
	];

	(* We may have already created an oliomer model with this name. Search for it. *)
	If[DatabaseMemberQ[Model[Sample,newName]],
		Return[Download[Model[Sample,newName]]];
	];

	(* pull out the Structures of the model packets *)
	oligomerStructures=Lookup[myOligomerModelPackets,Structure];

	(* de-construct the structures into all unbound single strands *)
	singleStrandStructures=ToStructure/@Flatten[ToStrand/@oligomerStructures];

	(* make a  Structure of the new model should be a Structure containing the unbonded Structures of the input models; we'll use this if we don't find existing models *)
	newStructure=First[Fold[StructureJoin,#]&/@{singleStrandStructures}];

	(* depending on how many oligo packets are inputs, try to find existing model; the permutations of the strands can get ABSURD
	 	if there are more than 5 distinct input models; just make a new model in that case *)
	existingModels=If[
		And[
			Length[myOligomerModelPackets]<=5,
			Or[
				NullQ[myDefinePrimitive],
				MatchQ[myDefinePrimitive[ModelName],_Missing]
			]
		],
		Module[{allNewNamePermutations,potentialCurrentModels,databaseMemberQs,modelsAlreadyInDatabaseWithName,
			naiveStructures,pairedStructures,allPossibleNewStructures},

			(* Construct the possible new Names by combining the names of all of the input models; if we have an oligo with any of these name, assume it's the same mixture *)
			allNewNamePermutations=StringJoin["Mixture of ",StringJoin@@Riffle[Lookup[#,Name],"; "]]&/@Permutations[myOligomerModelPackets];

			(* assemble the full name-based object references the oligos might have *)
			potentialCurrentModels=Model[Sample,#]&/@allNewNamePermutations;

			(* check database membership of these names *)
			databaseMemberQs=DatabaseMemberQ[potentialCurrentModels];

			(* get the first potential model that is in the database already; default to Null *)
			modelsAlreadyInDatabaseWithName=PickList[potentialCurrentModels,databaseMemberQs,True];

			(* return an existing model if we got it by Name *)
			If[MatchQ[modelsAlreadyInDatabaseWithName,{ObjectReferenceP[Model[Sample]]..}],
				Return[modelsAlreadyInDatabaseWithName,Module]
			];

			(* create all possible naive permutations of the structures joined together; Permutations becomes intractably slow after 8 strands, so don't try there *)
			naiveStructures=If[Length[singleStrandStructures]>8,
				Fold[StructureJoin,#]&/@{singleStrandStructures},
				Fold[StructureJoin,#]&/@Permutations[singleStrandStructures]
			];

			(* also try to create a base-paired structure if we're specifically dealing with 2 strands *)
			pairedStructures=If[Length[oligomerStructures]==2,
				Pairing[Sequence@@oligomerStructures,MinLevel->3],
				{}
			];

			(* compile the full list of both naively-joined and paired structures *)
			allPossibleNewStructures=Join[naiveStructures,pairedStructures];

			(* Figure out if a Model[Sample] already exists with this Structure, and return it if so
			 	the structure query can get super long and can throw this error, but we're okay with that; Quiet it *)
			With[
				{
					query=Structure==#&/@allPossibleNewStructures
				},
				TimeConstrained[Quiet[Search[Model[Sample],Or@@query],{HTTPRequestJSON::URLTooLong}],1]
			]
		],
		{}
	];

	(* if we got back a models that matches the structure of the oligo mixture, return the first one *)
	If[MatchQ[existingModels,{ObjectReferenceP[Model[Sample]]..}],
		Return[First[existingModels]]
	];

	(* determine the PolymerType of the new oligomer; if the inputs match, use it, otherwise default to mixed *)
	newPolymerType=If[SameQ@@Lookup[myOligomerModelPackets,PolymerType],
		Lookup[First[myOligomerModelPackets],PolymerType],
		Mixed
	];

	(* Choose the highest Biosafety Level *)
	newBiosafetyLevel=Last[Sort[Lookup[myOligomerModelPackets,BiosafetyLevel]]];
	(* Combine the Authors of the existing models *)
	newAuthors=DeleteDuplicates[Download[Flatten[Lookup[myOligomerModelPackets,Authors]],Object]];

	(* find the DefaultStorageCondition that has the lowest temperature based on a hard-coded lookup for now *)
	newDefaultStorageCondition = If[!NullQ[myDefinePrimitive]&&MatchQ[myDefinePrimitive[DefaultStorageCondition],SampleStorageTypeP|ObjectP[Model[StorageCondition]]],
		myDefinePrimitive[DefaultStorageCondition],
		FirstOrDefault[SortBy[Download[Lookup[myOligomerModelPackets,DefaultStorageCondition],Object],Lookup[storageConditionTemperatureLookup,#]&]]
	];

	(* if any of the input models expire, the new Model must too *)
	newExpires = If[!NullQ[myDefinePrimitive]&&MatchQ[myDefinePrimitive[Expires],BooleanP],
		myDefinePrimitive[Expires],
		If[MemberQ[Lookup[myOligomerModelPackets,Expires],True],
			True,
			False
		]
	];

	(* if the new model expires, one of its inputs MUST have ShelfLife; choose the shortest *)
	newShelfLife = If[newExpires,
		If[!NullQ[myDefinePrimitive]&&MatchQ[myDefinePrimitive[ShelfLife],GreaterP[0 Day]],
			myDefinePrimitive[ShelfLife],
			Min[DeleteCases[Lookup[myOligomerModelPackets,ShelfLife],Null]]
		],
		Null
	];

	newUnsealedShelfLife = If[newExpires,
		If[!NullQ[myDefinePrimitive]&&MatchQ[myDefinePrimitive[UnsealedShelfLife],GreaterP[0 Day]],
			myDefinePrimitive[UnsealedShelfLife],
			Min[DeleteCases[Lookup[myOligomerModelPackets,ShelfLife],Null]]
		],
		Null
	];

	(* We upload the identity model here because we can only return one packet to preserve index matching. *)
	(* This violates multiple uploads, but this is just a quick patch before we completely remove this helper function *)
	(* in the second round of samplefest porting. *)
	oligomerModel=If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
		UploadOligomer[
			newStructure,
			newPolymerType,
			newName
		],
		Model[Molecule,Oligomer,newName]
	];

	(* Upload our sample model. *)
	sampleModelPacket=First@UploadSampleModel[
		newName,
		Composition->{{100 MassPercent,oligomerModel}},
		DefaultStorageCondition -> newDefaultStorageCondition,
		Expires->newExpires,
		ShelfLife->newShelfLife,
		UnsealedShelfLife->newUnsealedShelfLife,
		MSDSRequired->False,
		Flammable->False,
		IncompatibleMaterials->{None},
		(* set the state of new oligomer mixture models to liquid for now because it's breaking commputed volume and volume checks *)
		State->Liquid,
		BiosafetyLevel->"BSL-1",
		Upload->False
	];

	Append[
		(* Drop created ID because downstream we detect a new model by pulling out packets without Object key *)
		KeyDrop[sampleModelPacket,{Object,ID}],
		{
			If[!NullQ[myDefinePrimitive]&&MatchQ[myDefinePrimitive[TransportWarmed],GreaterP[0 Kelvin]],
				TransportWarmed -> myDefinePrimitive[TransportWarmed],
				Nothing
			],
			Replace[Authors]->Link[newAuthors],
			Type->Model[Sample]
		}
	]
];

(*
 	Overload 2: Non-Oligomer Models
		- For now, just take the first one
*)
modelFromSourceModels[myModelPackets:{PacketP[Model[Sample]]..}, myDefinePrimitive_Define, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=Module[
	{uploadOptions,modelPacket},

	(* If we're not forcing a new model creation, take the first packet *)
	If[!MatchQ[myDefinePrimitive[ModelName],_String],
		Return[First[myModelPackets]]
	];

	uploadOptions = {
		If[MatchQ[myDefinePrimitive[State],Except[_Missing|Null|Automatic]],
			State -> myDefinePrimitive[State],
			State -> Liquid
		],
		If[MatchQ[myDefinePrimitive[Expires],Except[_Missing|Null|Automatic]],
			Expires -> myDefinePrimitive[Expires],
			If[AnyTrue[myModelPackets,TrueQ[Lookup[#,Expires]]&],
				Expires -> True,
				Expires -> False
			]
		],
		If[MatchQ[myDefinePrimitive[ShelfLife],Except[_Missing|Null|Automatic]],
			ShelfLife -> myDefinePrimitive[ShelfLife],
			If[AnyTrue[myModelPackets,!NullQ[Lookup[#,ShelfLife]]&],
				ShelfLife -> Min[DeleteCases[myModelPackets[[All,Key[ShelfLife]]],Null]],
				Nothing
			]
		],
		If[MatchQ[myDefinePrimitive[UnsealedShelfLife],Except[_Missing|Null|Automatic]],
			UnsealedShelfLife -> myDefinePrimitive[UnsealedShelfLife],
			If[AnyTrue[myModelPackets,!NullQ[Lookup[#,UnsealedShelfLife]]&],
				UnsealedShelfLife -> Min[DeleteCases[myModelPackets[[All,Key[UnsealedShelfLife]]],Null]],
				Nothing
			]
		],
		If[MatchQ[myDefinePrimitive[DefaultStorageCondition],Except[_Missing|Null|Automatic]],
			DefaultStorageCondition -> myDefinePrimitive[DefaultStorageCondition],
			If[AnyTrue[myModelPackets,!NullQ[Lookup[#,DefaultStorageCondition]]&],
				DefaultStorageCondition -> First[DeleteCases[myModelPackets[[All,Key[DefaultStorageCondition]]],Null]],
				Nothing
			]
		],
		If[AnyTrue[myModelPackets,!NullQ[Lookup[#,BiosafetyLevel]]&],
			BiosafetyLevel -> First[DeleteCases[myModelPackets[[All,Key[BiosafetyLevel]]],Null]],
			BiosafetyLevel -> "BSL-1"
		],
		If[AnyTrue[myModelPackets,!NullQ[Lookup[#,Flammable]]&],
			Flammable -> First[DeleteCases[myModelPackets[[All,Key[Flammable]]],Null]],
			Nothing
		],
		If[AnyTrue[myModelPackets,!NullQ[Lookup[#,Acid]]&],
			Acid -> First[DeleteCases[myModelPackets[[All,Key[Acid]]],Null]],
			Nothing
		],
		If[AnyTrue[myModelPackets,!NullQ[Lookup[#,Base]]&],
			Base -> First[DeleteCases[myModelPackets[[All,Key[Base]]],Null]],
			Nothing
		],
		If[AnyTrue[myModelPackets,!NullQ[Lookup[#,Pyrophoric]]&],
			Pyrophoric -> First[DeleteCases[myModelPackets[[All,Key[Pyrophoric]]],Null]],
			Nothing
		],
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	};

	modelPacket = Quiet[
		UploadSampleModel[
			myDefinePrimitive[ModelName],
			Synonyms -> {myDefinePrimitive[ModelName]},
			Sequence@@uploadOptions,
			Upload -> False
		],
		{Warning::SimilarChemicals}
	];

	(* Make sure we have the actual packet. *)
	modelPacket=If[MatchQ[modelPacket,_List],
		First[modelPacket],
		modelPacket
	];

	If[MatchQ[myDefinePrimitive[TransportWarmed],GreaterP[0 Kelvin]],
		Append[
			modelPacket,
			TransportWarmed -> myDefinePrimitive[TransportWarmed]
		],
		modelPacket
	]
];


(*
	Overload 3: Formula input
		- Automatically generate a stock solution model based on the formula
		- Note that if we actually _can't_ make this stock solution, just do what modelFromSourceModels was already doing
*)
(* Overload where the Define primitive has already defined the sample's model *)
modelFromSourceModels[myModelPackets:{PacketP[Model[Sample,StockSolution]]}, _Define, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=First[myModelPackets];
modelFromSourceModels[myFormula:{{PacketP[Model[Sample]],UnitsP[Gram]|UnitsP[Liter]|GreaterEqualP[1,1]}..}, Null, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=Module[
	{stockSolutionType, restrictiveFormulaP, componentModelPackets, newStockSolutionValue, highestPriorityType},

	(* transpose out the component model packets and their amounts *)
	componentModelPackets = myFormula[[All, 1]];

	(* this is the restrictive pattern for formula (i.e., what we can _actually_ make; this is the same as the input pattern of UploadStockSolutionModel) *)
	restrictiveFormulaP = {{PacketP[Model[Sample]],MassP|VolumeP|GreaterEqualP[1,1]}..};

	(* get the stock solution type that we are going to be making *)
	stockSolutionType = Which[
		MemberQ[componentModelPackets, PacketP[Model[Sample, Media]]], Media,
		MemberQ[componentModelPackets, PacketP[Model[Sample, Matrix]]], Matrix,
		True, StockSolution
	];

	(* get the highest-priority hierarchy (in case we can't make the stock solution) *)
	highestPriorityType = Which[
		MatchQ[stockSolutionType, Media|Matrix], Model[Sample, stockSolutionType],
		MemberQ[componentModelPackets, PacketP[Model[Sample, StockSolution]]], Model[Sample, StockSolution],
		MemberQ[componentModelPackets, PacketP[Model[Sample]]], Model[Sample],
		True, Model[Sample]
	];

	(* get the new stock solution packet that we are making *)
	(* note that if we don't match the restrictive formula, we are just going to do what we had already done before (take the first type of the highest hierarchy) *)
	newStockSolutionValue = If[MatchQ[myFormula, restrictiveFormulaP],
		(* Note: Formula used to be defined in the form {Sample, Amount} but we have reversed it to be {Amount, Sample}. *)
		(* The SM compiler is way too complicated to change the order so just reverse at the end. *)
		UploadStockSolution[Reverse/@myFormula, Type -> stockSolutionType, Upload -> False, FastTrack -> True, Author -> myRootProtocolAuthor, Preparable -> False],
		FirstCase[componentModelPackets, PacketP[highestPriorityType]]
	];

	(* return the new stock solution packet we are making *)
	newStockSolutionValue
];

modelFromSourceModels[myFormula:{{PacketP[Model[Sample]],UnitsP[Gram]|UnitsP[Liter]|GreaterEqualP[1,1]}..}, myDefinePrimitive_Define, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=Module[
	{uploadOptions,modelPacket},

	uploadOptions = {
		If[MatchQ[myDefinePrimitive[ModelName],_String],
			Name -> myDefinePrimitive[ModelName],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[Expires],Except[_Missing|Null|Automatic]],
			Expires -> myDefinePrimitive[Expires],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[ShelfLife],Except[_Missing|Null|Automatic]],
			ShelfLife -> myDefinePrimitive[ShelfLife],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[UnsealedShelfLife],Except[_Missing|Null|Automatic]],
			UnsealedShelfLife -> myDefinePrimitive[UnsealedShelfLife],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[DefaultStorageCondition],Except[_Missing|Null|Automatic]],
			DefaultStorageCondition -> myDefinePrimitive[DefaultStorageCondition],
			Nothing
		]
	};

	(* Note: Formula used to be defined in the form {Sample, Amount} but we have reversed it to be {Amount, Sample}. *)
	(* The SM compiler is way too complicated to change the order so just reverse at the end. *)
	modelPacket = UploadStockSolution[
		Reverse/@myFormula,
		Sequence@@uploadOptions,
		Upload -> False,
		Author -> myRootProtocolAuthor,
		FastTrack -> True,
		Preparable -> False
	];

	If[MatchQ[myDefinePrimitive[TransportWarmed],GreaterP[0 Kelvin]],
		Append[
			modelPacket,
			TransportWarmed -> myDefinePrimitive[TransportWarmed]
		],
		modelPacket
	]
];

(* This overload is for sample types that do not have an upload function *)
modelFromSourceModels[myModelPackets:{PacketP[Model[Sample]]..}, myDefinePrimitive_Define, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=Module[
	{modelType,fieldValues,synonyms,authors,state},

	(* Fetch specified model type *)
	modelType = myDefinePrimitive[ModelType];

	(* If ModelType is not defined, take the first model *)
	If[!MatchQ[modelType,TypeP[]],
		Return[First[myModelPackets]]
	];

	(* Fetch any specified model parameters *)
	fieldValues = {
		If[MatchQ[myDefinePrimitive[ModelName],_String],
			Name -> myDefinePrimitive[ModelName],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[Expires],Except[_Missing|Null|Automatic]],
			Expires -> myDefinePrimitive[Expires],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[ShelfLife],Except[_Missing|Null|Automatic]],
			ShelfLife -> myDefinePrimitive[ShelfLife],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[UnsealedShelfLife],Except[_Missing|Null|Automatic]],
			UnsealedShelfLife -> myDefinePrimitive[UnsealedShelfLife],
			Nothing
		],
		If[MatchQ[myDefinePrimitive[DefaultStorageCondition],Except[_Missing|Null|Automatic]],
			DefaultStorageCondition -> myDefinePrimitive[DefaultStorageCondition],
			Nothing
		]
	};

	(* If specified, use Name as synonym *)
	synonyms = {If[MatchQ[myDefinePrimitive[ModelName],_String],
		myDefinePrimitive[ModelName],
		Nothing
	]};

	(* Use protocol author as Author *)
	authors = Link[{myRootProtocolAuthor}];

	(* Ibherit State *)
	state = Lookup[First[myModelPackets,State],Null];

	(* This may create an invalid model, but it's all the information we have *)
	Association[
		Join[
			{
				Type -> modelType,
				Replace[Synonyms] -> synonyms,
				Replace[Authors] -> authors,
				Status -> state
			},
			fieldValues
		]
	]
];

modelFromSourceModels[myModelPackets:{PacketP[Model[Sample]]..}, Null, myRootProtocolAuthor:(Null|ObjectP[Object[User]])]:=First[myModelPackets];


(* ::Subsubsection:: *)
(*sampleTypeHierarchy*)


(* Hard-code the type inheritance hierarchy for new samples *)
sampleTypeHierarchy=Module[
	{typeOrdering},

	(* encode the order of priority of types when creating a new sample, where increasing place
	in list indicates increasing priority *)
	typeOrdering={
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample],
		Object[Sample]
	};

	(* thread the types with ordinals that indicate their priority position to create the hierarchy lookup *)
	AssociationThread[typeOrdering,Range[Length[typeOrdering]]]
];


(* Hard-code a priority lookup for storage condition objects by temperature *)
(* not a great solution, Cam is sorry, did not want to get into a fuller refactor of this shite during SC object transition *)
storageConditionTemperatureLookup=<|
	Model[StorageCondition,"id:BYDOjvGNDpvm"]->37 Celsius,(*Mammalian Incubation*)
	Model[StorageCondition,"id:mnk9jORxkYOO"]->37 Celsius,(*Bacterial Incubation*)
	Model[StorageCondition,"id:O81aEBZ3KMvp"]->40 Celsius,(*"Environmental Chamber, Accelerated Testing"*)
	Model[StorageCondition,"id:9RdZXv1WdGvZ"]->30 Celsius,(*"Yeast Incubation"*)
	Model[StorageCondition,"id:GmzlKjPoJMNk"]->30 Celsius,(*"Environmental Chamber, Intermediate Testing"*)
	Model[StorageCondition,"id:AEqRl9KXBMx5"]->25 Celsius,(*"Environmental Chamber, Long Term Testing"*)
	Model[StorageCondition,"id:o1k9jAG5NBoG"]->25 Celsius,(*"Environmental Chamber, UV-Vis Photostability Testing"*)
	Model[StorageCondition,"id:7X104vnR18vX"]->22 Celsius,(*"Ambient Storage"*)
	Model[StorageCondition,"id:vXl9j57YrPlN"]->22 Celsius,(*"Ambient Storage, Flammable"*)
	Model[StorageCondition,"id:BYDOjvGNn6Dm"]->22 Celsius,(*"Ambient Storage, Flammable Acid"*)
	Model[StorageCondition,"id:M8n3rx0lR6nM"]->22 Celsius,(*"Ambient Storage, Flammable Base"*)
	Model[StorageCondition,"id:WNa4ZjKvkVaL"]->22 Celsius,(*"Ambient Storage, Acid"*)
	Model[StorageCondition,"id:54n6evLEOmn7"]->22 Celsius,(*"Ambient Storage, Base"*)
	Model[StorageCondition,"id:bq9LA0JdKXW6"]->22 Celsius,(*"Ambient Storage, Desiccated"*)
	Model[StorageCondition,"id:01G6nvwkxl84"]->22 Celsius,(*"Ambient Storage, Desiccated Under Vacuum"*)
	Model[StorageCondition,"id:N80DNj1r04jW"]->4 Celsius,(*"Refrigerator"*)
	Model[StorageCondition,"id:dORYzZJVX3RE"]->4 Celsius,(*"Refrigerator, Flammable"*)
	Model[StorageCondition,"id:Vrbp1jKDY4bm"]->4 Celsius,(*"Refrigerator, Flammable Acid"*)
	Model[StorageCondition,"id:XnlV5jKzPXlb"]->4 Celsius,(*"Refrigerator, Base"*)
	Model[StorageCondition,"id:qdkmxzqoPakV"]->4 Celsius,(*"Refrigerator, Acid"*)
	Model[StorageCondition,"id:O81aEBZ5Gnvx"]->4 Celsius,(*"Refrigerator, Flammable Pyrophoric"*)
	Model[StorageCondition,"id:3em6ZvL9x4Zv"]->4 Celsius,(*"Refrigerator, Desiccated"*)
	Model[StorageCondition,"id:vXl9j57YlZ5N"]->-20 Celsius,(*"Freezer"*)
	Model[StorageCondition,"id:jLq9jXqwBdl6"]->4 Celsius,(*"Crystal Incubation"*)
	Model[StorageCondition,"id:n0k9mG8Bv96n"]->-20 Celsius,(*"Freezer, Flammable"*)
	Model[StorageCondition,"id:xRO9n3BVOe3z"]->-80 Celsius,(*"Deep Freezer"*)
	Model[StorageCondition,"id:6V0npvmE09vG"]->-165 Celsius,(*"Cryogenic Storage"*)
	Model[StorageCondition, "id:o1k9jAG98ZL4"]->37 Celsius,(*"Bacterial Incubation with Shaking"*)
	Model[StorageCondition, "id:lYq9jRx9anbV"]->30 Celsius(*"Yeast Incubation with Shaking"*)
|>;




(* ::Subsubsection::Closed:: *)
(*expandManipulations*)


DefineOptions[
	expandManipulations,
	Options:>{{Priority->Location,Location|Sample,"Determines whether the expanded manipulations will represent sources and destinations by location or by the source/destination sample/model (if possible)."}}
];

expandManipulations[{},OptionsPattern[]]:={};


(* This function takes in a list of manipulations and returns a list of tupples in the form {source,destination,amount} *)
expandManipulations[myManipulations:{SampleManipulationP..},myOptions:OptionsPattern[]]:=Module[
	{safeOptions,priority,drainSample,drainContainer},

	(* default all unspecified or incorrectly-specified options *)
	safeOptions=SafeOptions[expandManipulations, ToList[myOptions]];

	(* assign the Priority option to a local variable *)
	priority=Priority/.safeOptions;

	(*  Get a drain waste sample to use in the case of Pelleting. *)
	drainSample[]:=drainSample[]=First[Search[Object[Sample], Waste == True && WasteType == Drain && Status != Discarded]];
	drainContainer[]:=drainContainer[]=Download[drainSample[], Container[Object]];

	(* Map through the manipulations, compiling an ordered list of {sourceSample,destinationSample,amount} tuples
		start with an empty list and build it by looking at each of the manipulations in the order in which they are provided
		If a Sample does not exist for source/destination, the order of substitute information is as follows:
	 	- ResolvedSourceLocation/ResolvedDestinationLocation
		- Source/Destination *)

	Map[
		Function[currentManipulation,
			Module[{manipulationHead},

				(* determine what type of manipulation this is by taking its Head *)
				manipulationHead=Head[currentManipulation];

				(* add rules differently depending on the manipulation head *)
				Switch[manipulationHead,
					(* --- Transfer --- *)
					Transfer,
						Module[{sources,destinations,amounts},

							(* determine whether the source samples exist, or are still a location only *)
							sources = MapThread[
								Function[{sourceSample,sourceLocation,rawSource},
									SelectFirst[
										If[MatchQ[priority,Location],
											{sourceLocation,sourceSample,rawSource},
											{sourceSample,rawSource,sourceLocation}
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[SourceSample],currentManipulation[ResolvedSourceLocation],currentManipulation[Source]},
								2
							];

							(* determine whether each of the destination samples exists, or the destination is still a location *)
							destinations = MapThread[
								Function[{destinationSample,destinationLocation,rawDestination},
									SelectFirst[
										If[MatchQ[priority,Location],
											{destinationLocation,destinationSample,rawDestination},
											{destinationSample,rawDestination,destinationLocation}
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[DestinationSample],currentManipulation[ResolvedDestinationLocation],currentManipulation[Destination]},
								2
							];

							(* Extract amounts *)
							amounts = currentManipulation[Amount];

							(* make tuples for each individual source and amount to the destination  *)
							Join@@MapThread[
								{#1,#2,#3}&,
								{sources,destinations,amounts},
								2
							]


						],

				(* --- Transfer --- *)
					FillToVolume,
					Module[{source,destination},

					(* determine how the source will be represented, obeying the importance order outlined in the mega-comment *)
						source=SelectFirst[
							currentManipulation/@If[MatchQ[priority,Location],
								{ResolvedSourceLocation,SourceSample,Source},
								{SourceSample,Source,ResolvedSourceLocation}
							],
							!NullQ[#]&
						];

						(* determine whether the destination sample exists, or the destination is still a location *)
						destination=SelectFirst[
							currentManipulation/@If[MatchQ[priority,Location],
								{ResolvedDestinationLocation,DestinationSample,Destination},
								{DestinationSample,Destination,ResolvedDestinationLocation}
							],
							!NullQ[#]&
						];

						(* return a tuple with the source, destination, and amount of the Transfer *)
						(* double-listed so it can be Join-ed to the existing tuple list *)
						{{source,destination,currentManipulation[FinalVolume]}}
					],
					Pellet,
						Module[{workingSamples,supernatantDestinations,supernatantVolumes,resuspensionSources,resuspensionVolumes},
							(* determine how the source will be represented, obeying the importance order outlined in the mega-comment *)
							workingSamples=MapThread[
								Function[{sourceSample,sourceLocation,rawSource},
									SelectFirst[
										If[MatchQ[priority,Location],
											{sourceLocation,sourceSample,rawSource},
											{sourceSample,rawSource,sourceLocation}
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[SourceSample],currentManipulation[ResolvedSourceLocation],currentManipulation[Sample]}
							];

							(* determine whether the destination sample exists, or the destination is still a location *)
							supernatantDestinations=MapThread[
								Function[{destinationSample,destinationLocation,rawDestination},
									SelectFirst[
										If[MatchQ[rawDestination, Waste],
											If[MatchQ[priority,Location],
												{drainContainer[],drainSample[],rawDestination},
												{drainSample[],rawDestination,drainContainer[]}
											],
											If[MatchQ[priority,Location],
												{destinationLocation,destinationSample,rawDestination},
												{destinationSample,rawDestination,destinationLocation}
											]
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[SupernatantDestinationSample],currentManipulation[ResolvedSupernatantDestinationLocation],currentManipulation[SupernatantDestination]}
							];

							(* Extract amounts *)
							supernatantVolumes = currentManipulation[SupernatantVolume];

							(* determine how the source will be represented, obeying the importance order outlined in the mega-comment *)
							resuspensionSources=MapThread[
								Function[{sourceSample,sourceLocation,rawSource},
									SelectFirst[
										If[MatchQ[priority,Location],
											{sourceLocation,sourceSample,rawSource},
											{sourceSample,rawSource,sourceLocation}
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[ResuspensionSourceSample],currentManipulation[ResolvedResuspensionSourceLocation],currentManipulation[ResuspensionSource]}
							];

							(* Extract amounts *)
							resuspensionVolumes = currentManipulation[ResuspensionVolume];

							(* make tuples for each individual source and amount to the destination  *)
							Join[
								(* Add all non-Null cases of supernatant transfers. *)
								Cases[
									MapThread[
										{#1,#2,#3}&,
										{workingSamples,supernatantDestinations,supernatantVolumes}
									],
									{_,_,Except[Null]}
								],
								(* Add all non-Null casese of resuspensions. *)
								Cases[
									MapThread[
										{#1,#2,#3}&,
										{resuspensionSources,workingSamples,resuspensionVolumes}
									],
									{_,_,Except[Null]}
								]
							]
						],
					Filter,
						Module[{sources,destinations},

							(* determine whether the source samples exist, or are still a location only *)
							sources = MapThread[
								Function[{sourceSample,sourceLocation,rawSource},
									SelectFirst[
										If[MatchQ[priority,Location],
											{sourceLocation,sourceSample,rawSource},
											{sourceSample,rawSource,sourceLocation}
										],
										!NullQ[#]&
									]
								],
								{currentManipulation[SourceSample],currentManipulation[ResolvedSourceLocation],currentManipulation[Sample]}
							];

							(* determine destination *)
							destinations = If[
								Or[
									MatchQ[priority,Location],
									!MatchQ[currentManipulation[CollectionSample],ListableP[ObjectP[Object[Sample]]]]
								],
								Which[
									(* For Micro, or Macro with plates (only FilterBlock), Destination will always be a 1-to-1 map from the filter plate position to the collection plate position
									So just sub in the collection plate in place of the filter plate. We map because we may have several samples in the source plate so we will create multiple destinations like this: {{plate,A1},{plate,A2}} *)
									MatchQ[currentManipulation[ResolvedSourceLocation],({{_String,WellPositionP}..}|{{ObjectP[Object[Container,Plate]],WellPositionP}..})],
										(* in Macro, all primitive keys are listed, so we need to take first. In ExpSM we've already errorred if there were more than one plate, so we can securely assume there is only one *)
										If[MatchQ[currentManipulation[ResolvedCollectionLocation],_List],
											Map[
												{First[currentManipulation[ResolvedCollectionLocation]],#[[2]]}&,
												currentManipulation[ResolvedSourceLocation]
											],
											(* In Micro, ResolvedCollectionLocation is always just a plate *)
											Map[
												{currentManipulation[ResolvedCollectionLocation],#[[2]]}&,
												currentManipulation[ResolvedSourceLocation]
											]
										],
									(* Is our collection container a plate even though our sources are in vessels? *)
									(* This is the case when using phytips. *)
									(* TODO: Right now, we just use the transpose of AllWells[] but we should probably look this up from the vessel rack placements. *)
									MatchQ[currentManipulation[ResolvedSourceLocation],({_String..}|{ObjectP[Object[Container,Vessel]]..})] && MatchQ[currentManipulation[ResolvedCollectionLocation],(_String|{ObjectP[Object[Container,Plate]],"A1"})],
										Map[
											{First[currentManipulation[ResolvedCollectionLocation]],#}&,
											Take[Flatten[Transpose[AllWells[]]], Length[sources]]
										],
									(* Otherwise, just use the resolved collection location if it's a list, or expand it out (without well numbers) if it isn't *)
									True,
										If[MatchQ[currentManipulation[ResolvedCollectionLocation], _List],
											currentManipulation[ResolvedCollectionLocation],
											ConstantArray[currentManipulation[ResolvedCollectionLocation], Length[sources]]
										]
								],
								ToList[currentManipulation[CollectionSample]]
							];
							
							MapThread[
								{#1,#2,All}&,
								{sources,destinations}
							]
						],
					(* --- Mix|Incubate|Wait --- *)
					_,
					{}
				]
			]
		],
		myManipulations
	]
];


(* ::Subsubsection::Closed:: *)
(*manipulationGraph*)


DefineOptions[
	manipulationGraph,
	Options:>{
		{VertexIdentifier->Location,Location|Sample,"Determines whether graph vertices will be represented by absolute locations or by samples."}
	}
];

(* create an empty graph for no transfer manipulations *)
manipulationGraph[{},OptionsPattern[]]:=Graph[{}];

(*
	This function takes in a list of sample manipulations and will return a graph of all transfers the would results from them
*)
manipulationGraph[myManipulations:{SampleManipulationP..},myOptions:OptionsPattern[]]:=Module[
	{safeOptions,sourceDestinationAmountTuples,expandedPrimitives,relevantSourceDestinationAmountTuples,
	relevantExpandedPrimitives,sourceDestinationEdges,transferAmounts,sourceDestinationEdgesWithState,
	convertedTransferAmounts},
	(* default all unspecified or incorrectly-specified options *)
	safeOptions=SafeOptions[manipulationGraph, ToList[myOptions]];

	(* use expandManipulations to create a set of tuples specifying the low-level order of transfer operations in the form {{source,destination,amount}..} *)
	sourceDestinationAmountTuples=expandManipulations[myManipulations,Priority->(VertexIdentifier/.safeOptions)];

	expandedPrimitives = MapThread[
		Table[#1,Length[#2]]&,
		{myManipulations,sourceDestinationAmountTuples}
	];

	relevantSourceDestinationAmountTuples = Join@@DeleteCases[sourceDestinationAmountTuples,{}];
	relevantExpandedPrimitives = Join@@DeleteCases[expandedPrimitives,{}];

	(* pull out the sources and destinations from the expansions call and turn them into edges *)
	sourceDestinationEdges=MapThread[Rule,{relevantSourceDestinationAmountTuples[[All,1]],relevantSourceDestinationAmountTuples[[All,2]]}];

	(* pull out all of the transfer amounts *)
	transferAmounts=relevantSourceDestinationAmountTuples[[All,3]];

	(* move through the edges and modify the locations to contain a specification indicating the "state" of the location
	 	if a source is not yet current edge list, add both that edge and a "Start"->source edge
		if the source already exists in the edge list, build from that vertex
		if the DESTINATION already exists in the edge list as a SOURCE, increment the destination state indicator *)
	{sourceDestinationEdgesWithState,convertedTransferAmounts}=Fold[
		Function[{currentEdgesAmountsTuple,rawEdgeToAdd},
			Module[
				{newSource,newDestination,currentManipulation,currentSources,currentDestinations,
				currentVertices,sameSourceVertices,newSourceStateIndex,
				sameDestinationVertices,currentTransferAmounts,newTransferAmount,
				newDestinationStateIndex,edgeToAdd},

				(* separate out the source and destination for the new edge to add *)
				newSource=rawEdgeToAdd[[1,1]];
				newDestination=rawEdgeToAdd[[1,2]];

				currentManipulation = rawEdgeToAdd[[3]];

				(* take out every source and destination vertex from the current list,
					also creating a full list of all vertices *)
				currentSources=currentEdgesAmountsTuple[[1,All,1]];
				currentDestinations=currentEdgesAmountsTuple[[1,All,2]];
				currentVertices=DeleteDuplicates[Join[currentSources,currentDestinations]];

				(* pull out all of the vertices that match the new source (with any depth) *)
				sameSourceVertices=Select[currentVertices,MatchQ[#[[1]],newSource]&];

				(* take the maximum of these vertices' depths; use this as the state for the new source,
				 	defaulting to 1 if sameSourceVertices is empty*)
				newSourceStateIndex=Max[sameSourceVertices[[All,2]],1];

				(* find all vertices with the new destination at any depth *)
				sameDestinationVertices=Select[currentVertices,MatchQ[#[[1]],newDestination]&];

				(* Get current list of transfer amounts *)
				currentTransferAmounts = currentEdgesAmountsTuple[[2]];

				(* If we're transfering ALL of the source, find all positions where our SOURCE is the
				destination of previous transfers and total the amounts transfered into our source and
				subtract any amounts transferred out of our source already. *)
				newTransferAmount = Which[
					MatchQ[rawEdgeToAdd[[2]],All],
						Total[
							Cases[
								currentTransferAmounts[[
									Flatten[Position[currentDestinations,{newSource,_},{1}]]
								]],
								VolumeP
							]
						] - Total[Cases[currentTransferAmounts[[Flatten[Position[currentSources,{newSource,_},{1}]]]],VolumeP]],
					(* If we're filling a destination to a specific FinalVolume with a source, find all positions
					where our DESTINATION is the destination of previous transfers and total the amounts transfered
					into our destination. Then subtract all previous transfers where the source was our destination,
					total their amounts. Then subtract this volume from the FinalVolume to find the volume transferred. *)
					MatchQ[currentManipulation,_FillToVolume],
						Max[
							currentManipulation[FinalVolume] - (
								Total[Cases[currentTransferAmounts[[Flatten[Position[currentDestinations,{newDestination,_},{1}]]]],VolumeP]] -
								Total[Cases[currentTransferAmounts[[Flatten[Position[currentSources,{newDestination,_},{1}]]]],VolumeP]]
							),
							0 Microliter
						],
					True,
					rawEdgeToAdd[[2]]
				];

				(* take the maximum of these vertices' depths; use this as the depth for the new destination,
				 	defaulting to 1 if sameDestinationVertices is empty;
					if the destination appears specifically in the SOURCE list, add 1 to the destination depth *)
				newDestinationStateIndex=If[MemberQ[currentSources[[All,1]],newDestination],
					Max[sameDestinationVertices[[All,2]],1]+1,
					Max[sameDestinationVertices[[All,2]],1]
				];

				(* construct the depth-indexed new edge *)
				edgeToAdd = {newSource,newSourceStateIndex}->{newDestination,newDestinationStateIndex};

				(* add the new edge to the edge list *)
				{
					Append[currentEdgesAmountsTuple[[1]],edgeToAdd],
					Append[currentEdgesAmountsTuple[[2]],newTransferAmount]
				}
			]
		],
		{{},{}},
		Transpose[{sourceDestinationEdges,transferAmounts,relevantExpandedPrimitives}]
	];

	(* create the graph from the final depth-spec'd edges, including the volumes from the manipulation expansion
	 	as the edge weights, and adding on the start edges (with dummy edge weights of 1) *)
	Graph[sourceDestinationEdgesWithState,EdgeWeight->convertedTransferAmounts]
];