(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ReviewExperiment*)

DefineOptions[ReviewExperiment,
	Options:>{
		ExportOption,
		UploadOption
	}
];

ReviewExperiment[myProtocol:ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance]}],ops:OptionsPattern[]]:=Module[
	{safeOps,protocolPacket,subprotocolDownload,operatorDownload,allSubprotocols,allOperators,trainingLogs,allProtocols,fulfilledInstrumentResources,
	fulfilledSampleResources,instruments,instrumentQualLogs,instrumentDatesFulfilled,
	instrumentsMaintenanceLog,priorQualEntries,subsequentQualEntries,priorQualifications,
	subsequentQualifications,calibrationTypes,priorCalibrationEntries,
	subsequentCalibrationEntries,priorCalibrations,subsequentCalibrations,priorSanitizationEntries,subsequentSanitizationEntries,
	priorMaintenanceEntries,subsequentMaintenanceEntries,preventativeMaintenance,sanitizationMaintenance,stockSolutions,pHAdjustments,ssInfo,phInfo,ssSamplesOut,
	ssModels,ssFullyDissolved,pHSamplesIn,pHModels,pHsAchievedQ,resourceSamples,resourceSamplePackets,
	resourceModels,resourceRequestors,requestorRequiredResources,sampleNumberOfUses,datesInUse,datesFulfilled,
	maxNumberOfUses,resourceStorageTemperatures,allResourceFields,usedResources,usedResourceModels,
	usedResourceRequestors,usedResourceFields,usedResourceDatesInUse,usedResourceDatesFulfilled,
	usedMaxNumberOfUses,flatNumberOfUsesDownload,startingNumberOfUses,endingNumberOfUses,numberOfUses,
	resourceTable,ssFullyDissolvedPositions,ssFullyDissolvedSamples,ssFullyDissolvedModels,ssFullyDissolvedBools,ssFullyDissolvedProtocols,ssFullyDissolvedFields,fullyDissolvedCheck,pHProtocols,pHFields,pHAdjustmentCheckValue,thawedSamples,thawedModels,thawedResourceFields,thawedResourceRequestors,thawProtocols,
	numberOfThaws,freezeThawHistory,expirationSamplePositions,expirationSamples,expirationSamplePackets,
	expirationModels,expirationResourceFields,expirationResourceRequestors,expirationDatesInUse,
	expirationCheck,appearanceLogs,sampleHistories,appearanceDatas,appearanceCloudFiles,appearanceCheck,
	sampleHistory,laboratoryTraining,smProtocols,resolvedManipulations,samplesInSMPackets,samplesOutSMPackets,samplesInTransferPackets,samplesOutTransferPackets,
	resolvedUnitOperations,spProtocols,spProtocolsWithTransfers,resolvedUnitOperationPackets,resolvedUnitOperationBlobs,allTransfers,
	allSamplePackets,protocolsWithTransfers,resolvedTransfers,nestedSourceSamples,nestedDestinationSamples,
	nestedAmounts,nestedAspirationPressures,nestedDispensePressures,nestedPipettingMethods,nestedSourceModels,
	nestedDestinationModels,nestedSourceResourcePositions,nestedSourceResources,nestedSourceResourceRequestors,
	nestedSourceRequestorRequiredResources,nestedSourceResourceFields,nestedDestinationResourcePositions,nestedDestinationResources,
	nestedDestinationResourceRequestors,nestedDestinationRequestorRequiredResources,nestedDestinationResourceFields,
	transferCheck,possibleFunctionName,reviewExperimentFunction,generalPacket,generalNotebookSections,
	typeSpecificPacket,typeSpecificNotebookSections,fullPacket,exportedNotebook,uploadPacketWithNotebook},
	
	safeOps = SafeOptions[ReviewExperiment,ToList[ops],AutoCorrect->False];
	
	(* Fetch required protocol information *)
	{protocolPacket,subprotocolDownload,operatorDownload} = Download[
		myProtocol,
		{
			Packet[DateCreated,DateStarted,DateCompleted],
			Subprotocols..[Object],
			ProcedureLog[Creator][Object]
		}
	];
	
	allSubprotocols = Flatten[subprotocolDownload];
	
	(* Extract all operators *)
	allOperators = Cases[
		DeleteDuplicates[operatorDownload],
		ObjectP[Object[User, Emerald, Operator]]
	];
	
	(* Fetch operator's training *)
	trainingLogs = Download[allOperators,LabTechniqueTrainingLog];
	
	
	allProtocols = Join[{myProtocol},allSubprotocols];

	fulfilledInstrumentResources = Search[
		Object[Resource,Instrument],
		And[
			Status == Fulfilled,
			RootProtocol == myProtocol
		]
	];
	
	fulfilledSampleResources = Search[
		Object[Resource,Sample],
		And[
			Status == Fulfilled,
			RootProtocol == myProtocol
		]
	];
	
	{instruments,instrumentQualLogs,instrumentDatesFulfilled,instrumentsMaintenanceLog} = If[MatchQ[fulfilledInstrumentResources,{}],
		{{},{},{},{}},
		Transpose@Download[
			fulfilledInstrumentResources,
			{Instrument[Object],Instrument[QualificationResultsLog],DateFulfilled,Instrument[MaintenanceLog]}
		]
	];
	
	priorQualEntries = MapThread[
		Function[{log,dateUsed},
			Last[SortBy[Select[log,(#[Date] < dateUsed)&],#[Date]&],Null]
		],
		{instrumentQualLogs,instrumentDatesFulfilled}
	];
	
	subsequentQualEntries = MapThread[
		Function[{log,dateUsed},
			Last[SortBy[Select[log,(#[Date] > dateUsed)&],#[Date]&],Null]
		],
		{instrumentQualLogs,instrumentDatesFulfilled}
	];
	
	priorQualifications = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[Date],
						Link[instrument],
						Link[entry[Qualification]],
						entry[Result]
				}
			]
		],
		{instruments,priorQualEntries}
	];
	
	subsequentQualifications = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[Date],
						Link[instrument],
						Link[entry[Qualification]],
						entry[Result]
				}
			]
		],
		{instruments,subsequentQualEntries}
	];
	
	calibrationTypes = {
		Object[Maintenance, CalibrateAutosampler], Object[Maintenance, CalibrateBalance],
		Object[Maintenance, CalibrateCarbonDioxide], Object[Maintenance, CalibrateConductivity],
		Object[Maintenance, CalibrateElectrochemicalReactor], Object[Maintenance, CalibrateGasSensor],
		Object[Maintenance, CalibrateLevel], Object[Maintenance, CalibrateLightScattering],
		Object[Maintenance, CalibrateMicroscope], Object[Maintenance, CalibrateNMRShim],
		Object[Maintenance, CalibratePathLength], Object[Maintenance, CalibratepH],
		Object[Maintenance, CalibratePressure], Object[Maintenance, CalibrateRelativeHumidity],
		Object[Maintenance, CalibrateTemperature]
	};
	
	priorCalibrationEntries = MapThread[
		Function[{log,dateUsed},
			Last[
				SortBy[
					Select[
						log,
						And[
							MatchQ[#[[2]],ObjectP[calibrationTypes]],
							(#[[1]] < dateUsed)
						]&
					],
					#[[1]]&
				],
				Null
			]
		],
		{instrumentsMaintenanceLog,instrumentDatesFulfilled}
	];
	
	subsequentCalibrationEntries = MapThread[
		Function[{log,dateUsed},
			Last[
				SortBy[
					Select[
						log,
						And[
							MatchQ[#[[2]],ObjectP[calibrationTypes]],
							(#[[1]] > dateUsed)
						]&
					],
					#[[1]]&
				],
				Null
			]
		],
		{instrumentsMaintenanceLog,instrumentDatesFulfilled}
	];
	
	priorCalibrations = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[[1]],
						Link[instrument],
						Link[Download[entry[[2]],Object]]
				}
			]
		],
		{instruments,priorCalibrationEntries}
	];
	
	subsequentCalibrations = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[[1]],
						Link[instrument],
						Link[Download[entry[[2]],Object]]
				}
			]
		],
		{instruments,subsequentCalibrationEntries}
	];
	
	priorSanitizationEntries = MapThread[
		Function[{log,dateUsed},
			Last[
				SortBy[
					Select[
						log,
						And[
							MatchQ[#[[2]],ObjectP[Object[Maintenance,Clean]]],
							(#[[1]] < dateUsed)
						]&
					],
					#[[1]]&
				],
				Null
			]
		],
		{instrumentsMaintenanceLog,instrumentDatesFulfilled}
	];
	
	priorMaintenanceEntries = MapThread[
		Function[{log,dateUsed},
			Last[
				SortBy[
					Select[
						log,
						And[
							MatchQ[#[[2]],Except[ObjectP[Object[Maintenance,Clean]]|ObjectP[calibrationTypes],ObjectP[]]],
							(#[[1]] < dateUsed)
						]&
					],
					#[[1]]&
				],
				Null
			]
		],
		{instrumentsMaintenanceLog,instrumentDatesFulfilled}
	];
	
	sanitizationMaintenance = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[[1]],
						Link[instrument],
						Link[Download[entry[[2]],Object]]
				}
			]
		],
		{instruments,priorSanitizationEntries}
	];
	
	preventativeMaintenance = MapThread[
		Function[{instrument,entry},
			If[NullQ[entry],
				Nothing,
				{
						entry[[1]],
						Link[instrument],
						Link[Download[entry[[2]],Object]]
				}
			]
		],
		{instruments,priorMaintenanceEntries}
	];
	
	stockSolutions = Cases[allProtocols,ObjectP[Object[Protocol,StockSolution]]];
	pHAdjustments = Cases[allProtocols,ObjectP[Object[Protocol,AdjustpH]]];
	
	{ssInfo,phInfo} = Download[
		{stockSolutions,pHAdjustments},
		{
			{SamplesOut[Object],SamplesOut[Model][Object],FullyDissolved},
			{SamplesIn[Object],SamplesIn[Model][Object],pHsAchieved}
		}
	];
	
	
	{ssSamplesOut,ssModels,ssFullyDissolved} = If[MatchQ[ssInfo,{}],
		{{},{},{}},
		Flatten/@Transpose[ssInfo]
	];
	
	{pHSamplesIn,pHModels,pHsAchievedQ} = If[MatchQ[phInfo,{}],
		{{},{},{}},
		Flatten/@Transpose[phInfo]
	];
	
	{resourceSamples,resourceSamplePackets,resourceModels,resourceRequestors,requestorRequiredResources,
	sampleNumberOfUses,datesInUse,datesFulfilled,maxNumberOfUses,resourceStorageTemperatures} = If[MatchQ[fulfilledSampleResources,{}],
		{{},{},{},{},{},{},{},{},{},{}},
		Transpose@Quiet[
			Download[
				fulfilledSampleResources,
				{
					Sample[Object],
					Packet[Sample[{ExpirationDate,ShelfLife,UnsealedShelfLife,DateUnsealed,DateStocked}]],
					Sample[Model][Object],
					Requestor[[1]][Object],
					Requestor[[1]][RequiredResources],
					Sample[NumberOfUses],
					DateInUse,
					DateFulfilled,
					Sample[Model][MaxNumberOfUses],
					Sample[StorageCondition][Temperature]
				}
			],
			{Download::FieldDoesntExist}
		]
	];
	
	allResourceFields = MapThread[
		Function[{requiredResources,resource},
			SelectFirst[requiredResources,MatchQ[#[[1]],LinkP[resource]]&,{Null,Null,Null,Null}][[2]]
		],
		{requestorRequiredResources,fulfilledSampleResources}
	];
	
	usedResources = PickList[resourceSamples,sampleNumberOfUses,GreaterP[0]];
	usedResourceModels = PickList[resourceModels,sampleNumberOfUses,GreaterP[0]];
	usedResourceRequestors = PickList[resourceRequestors,sampleNumberOfUses,GreaterP[0]];
	usedResourceFields = PickList[allResourceFields,sampleNumberOfUses,GreaterP[0]];
	usedResourceDatesInUse = PickList[datesInUse,sampleNumberOfUses,GreaterP[0]];
	usedResourceDatesFulfilled = PickList[datesFulfilled,sampleNumberOfUses,GreaterP[0]];
	usedMaxNumberOfUses = PickList[maxNumberOfUses,sampleNumberOfUses,GreaterP[0]];
	
	flatNumberOfUsesDownload = Download[
		Join[usedResources,usedResources],
		NumberOfUses,
		Date -> Evaluate[Join[usedResourceDatesInUse,usedResourceDatesFulfilled]]
	];
	
	{startingNumberOfUses,endingNumberOfUses} = If[MatchQ[usedResources,{}],
		{{},{}},
		PartitionRemainder[flatNumberOfUsesDownload,Length[usedResources]]
	];
	
	numberOfUses = MapThread[
		Function[{fieldName,sample,model,startNumberOfUses,endNumberOfUses,maxNumberOfUses,protocol},
			Association[
				FieldName -> fieldName,
				Sample -> Link[sample],
				Model -> Link[model],
				StartNumberOfUses -> startNumberOfUses,
				EndNumberOfUses -> endNumberOfUses,
				MaxNumberOfUses -> maxNumberOfUses,
				Protocol -> Link[protocol]
			]
		],
		{
			usedResourceFields,
			usedResources,
			usedResourceModels,
			startingNumberOfUses,
			endingNumberOfUses,
			usedMaxNumberOfUses,
			usedResourceRequestors
		}
	];
	
	resourceTable = MapThread[
		Function[{fieldName,sample,model,protocol},
			Association[
				FieldName -> fieldName,
				Item -> Link[sample],
				Model -> Link[model],
				Protocol -> Link[protocol]
			]
		],
		{
			allResourceFields,
			resourceSamples,
			resourceModels,
			resourceRequestors
		}
	];
	
	ssFullyDissolvedPositions = Flatten@Position[ssFullyDissolved,BooleanP,{1}];
	ssFullyDissolvedSamples = ssSamplesOut[[ssFullyDissolvedPositions]];
	ssFullyDissolvedModels = ssModels[[ssFullyDissolvedPositions]];
	ssFullyDissolvedBools = ssFullyDissolved[[ssFullyDissolvedPositions]];
	{ssFullyDissolvedProtocols,ssFullyDissolvedFields} = If[MatchQ[ssFullyDissolvedSamples,{}],
		{{},{}},
		Transpose@Map[
			Function[sample,
				Lookup[
					SelectFirst[resourceTable,MatchQ[Lookup[#,Item],sample]&,<||>],
					{Protocol,FieldName},
					Null
				]
			],
			ssFullyDissolvedSamples
		]
	];
	
	fullyDissolvedCheck = MapThread[
		Function[{fieldName,sample,model,fullyDissolved,protocol},
			Association[
				FieldName -> fieldName,
				Sample -> Link[sample],
				Model -> Link[model],
				FullyDissolved -> fullyDissolved,
				Protocol -> Link[protocol]
			]
		],
		{
			ssFullyDissolvedFields,
			ssFullyDissolvedSamples,
			ssFullyDissolvedModels,
			ssFullyDissolvedBools,
			ssFullyDissolvedProtocols
		}
	];
	
	{pHProtocols,pHFields} = If[MatchQ[pHSamplesIn,{}],
		{{},{}},
		Transpose@Map[
			Function[sample,
				Lookup[
					SelectFirst[resourceTable,MatchQ[Lookup[#,Item],sample]&,<||>],
					{Protocol,FieldName},
					Null
				]
			],
			pHSamplesIn
		]
	];
	
	pHAdjustmentCheckValue = MapThread[
		Function[{fieldName,sample,model,fullyDissolved,protocol},
			Association[
				FieldName -> fieldName,
				Sample -> Link[sample],
				Model -> Link[model],
				pHAchieved -> fullyDissolved,
				Protocol -> Link[protocol]
			]
		],
		{
			pHFields,
			pHSamplesIn,
			pHModels,
			pHsAchievedQ,
			pHProtocols
		}
	];
	
	thawedSamples = PickList[resourceSamples,resourceStorageTemperatures,LessP[0 Celsius]];
	thawedModels = PickList[resourceModels,resourceStorageTemperatures,LessP[0 Celsius]];
	thawedResourceFields = PickList[allResourceFields,resourceStorageTemperatures,LessP[0 Celsius]];
	thawedResourceRequestors = PickList[resourceRequestors,resourceStorageTemperatures,LessP[0 Celsius]];
	
	thawProtocols = Search[
		Table[Object[Protocol,Incubate],Length[thawedSamples]],
		Evaluate@Map[
		  And[
				SamplesIn == #,
				ThawParameters != Null,
				Status == Completed
			]&,
		  thawedSamples
		]
	];
	
	numberOfThaws = Length/@thawProtocols;
	
	freezeThawHistory = MapThread[
		Function[{fieldName,sample,model,thawCount,protocol},
			Association[
				FieldName -> fieldName,
				Sample -> Link[sample],
				Model -> Link[model],
				NumberOfThaws -> thawCount,
				Protocol -> Link[protocol]
			]
		],
		{
			thawedResourceFields,
			thawedSamples,
			thawedModels,
			numberOfThaws,
			thawedResourceRequestors
		}
	];
	
	expirationSamplePositions = Flatten@Position[
		resourceSamplePackets,
		_Association?(!NullQ[Lookup[#, ExpirationDate]]&),
		{1}
	];
	expirationSamples = resourceSamples[[expirationSamplePositions]];
	expirationSamplePackets = resourceSamplePackets[[expirationSamplePositions]];
	expirationModels = resourceModels[[expirationSamplePositions]];
	expirationResourceFields = allResourceFields[[expirationSamplePositions]];
	expirationResourceRequestors = resourceRequestors[[expirationSamplePositions]];
	expirationDatesInUse = datesInUse[[expirationSamplePositions]];
	
	expirationCheck = MapThread[
		Function[
			{sample,samplePacket,model,fieldName,dateInUse,protocol},
			Association[
				FieldName -> fieldName,
				Item -> Link[sample],
				Model -> Link[model],
				ExpirationDate -> Lookup[samplePacket,ExpirationDate],
				DateUsed -> dateInUse,
				TimeRemaining -> (Lookup[samplePacket,ExpirationDate] - dateInUse),
				DateStocked -> Lookup[samplePacket,DateStocked],
				ShelfLife -> Lookup[samplePacket,ShelfLife],
				DateUnsealed -> Lookup[samplePacket,DateUnsealed],
				UnsealedShelfLife -> Lookup[samplePacket,UnsealedShelfLife],
				Protocol -> Link[protocol]
			]
		],
		{
			expirationSamples,
			expirationSamplePackets,
			expirationModels,
			expirationResourceFields,
			expirationDatesInUse,
			expirationResourceRequestors
		}
	];
	
	
	{appearanceLogs,sampleHistories} = If[MatchQ[resourceSamples,{}],
		{{},{}},
		Transpose@Quiet[
			Download[
				resourceSamples,
				{AppearanceLog,SampleHistory},
				Date -> Evaluate@datesFulfilled
			],
			{Download::FieldDoesntExist}
		]
	];
	
	appearanceDatas = Map[
		If[Length[#] > 0,
			Last[#][[2]],
			Null
		]&,
		appearanceLogs
	];
	
	appearanceCloudFiles = Download[appearanceDatas,UncroppedImageFile];
	
	appearanceCheck = MapThread[
		Function[{appearanceCloudFile,fieldName,sample,model,protocol},
			If[!NullQ[appearanceCloudFile],
				Association[
					FieldName -> fieldName,
					Sample -> Link[sample],
					Model -> Link[model],
					Appearance -> Link[appearanceCloudFile],
					Protocol -> Link[protocol]
				],
				Nothing
			]
		],
		{
			appearanceCloudFiles,
			allResourceFields,
			resourceSamples,
			resourceModels,
			resourceRequestors
		}
	];
	
	sampleHistory = MapThread[
		Function[{sampleHistoryCards,fieldName,sample,model,protocol},
			If[MatchQ[sampleHistoryCards,_List]&&Length[sampleHistoryCards]>0,
				Association[
					FieldName -> fieldName,
					Sample -> Link[sample],
					Model -> Link[model],
					SampleHistory -> sampleHistoryCards,
					Protocol -> Link[protocol]
				],
				Nothing
			]
		],
		{
			sampleHistories,
			allResourceFields,
			resourceSamples,
			resourceModels,
			resourceRequestors
		}
	];
	
	laboratoryTraining = Join@@MapThread[
		Function[{operator,log},
			Map[
				Association[
					Operator -> Link[operator],
					Date -> #[[1]],
					TrainingType -> #[[2]],
					TrainingResult -> Pass,
					Witness -> Link[Download[#[[3]],Object]]
				]&,
				log
			]
		],
		{allOperators,trainingLogs}
	];
	
	
	smProtocols = Cases[allProtocols,ObjectP[Object[Protocol,SampleManipulation]]];
	
	spProtocols = Cases[allProtocols,ObjectP[{Object[Protocol,RoboticSamplePreparation],Object[Protocol,ManualSamplePreparation]}]];
	
	{
		{resolvedManipulations,samplesInSMPackets,samplesOutSMPackets},
		{resolvedUnitOperations,samplesInTransferPackets,samplesOutTransferPackets}
	} = Map[
		If[MatchQ[#,{}],
			{{},{},{}},
			Transpose[#]
		]&,
		Download[
			{smProtocols,spProtocols},
			{
				{
					ResolvedManipulations,
					Packet[SamplesIn[{VolumeLog,Model}]],
					Packet[SamplesOut[{VolumeLog,Model}]]
				},
				{
					OutputUnitOperations[All],
					Packet[SamplesIn[{VolumeLog,Model}]],
					Packet[SamplesOut[{VolumeLog,Model}]]
				}
			},
			PaginationLength -> 10^15
		]
	];
	
	allSamplePackets = FlattenCachePackets[Join[samplesInSMPackets,samplesOutSMPackets,samplesInTransferPackets,samplesOutTransferPackets]];
	
	protocolsWithTransfers = PickList[smProtocols,resolvedManipulations,_?(MemberQ[#,_Transfer]&)];
	resolvedTransfers = Cases[#,_Transfer]&/@PickList[resolvedManipulations,resolvedManipulations,_?(MemberQ[#,_Transfer]&)];
	
	spProtocolsWithTransfers = PickList[spProtocols,resolvedUnitOperations,_?(MemberQ[#,ObjectP[Object[UnitOperation,Transfer]]]&)];
	resolvedUnitOperationPackets = Cases[#,ObjectP[Object[UnitOperation,Transfer]]]&/@PickList[resolvedUnitOperations,resolvedUnitOperations,_?(MemberQ[#,ObjectP[Object[UnitOperation,Transfer]]]&)];
	resolvedUnitOperationBlobs = Map[
		ConstellationViewers`Private`UnitOperationPrimitive[#,IncludeCompletedOptions -> True]&,
		resolvedUnitOperationPackets,
		{2}
	];
	
	allTransfers = Join[resolvedTransfers,resolvedUnitOperationBlobs];
	
	{
		nestedSourceSamples,
		nestedDestinationSamples,
		nestedAmounts,
		nestedAspirationPressures,
		nestedDispensePressures,
		nestedPipettingMethods
	} = If[MatchQ[allTransfers,{}],
		{{},{},{},{},{},{}},
		Transpose@Map[
			Transpose@Map[
				Function[manipulation,
					Module[{manipAss,numberOfTransfers},
						
						manipAss = First[manipulation];
						
						numberOfTransfers = Length[Lookup[manipAss,SourceSample]];
						
						If[KeyExistsQ[manipAss,Protocol],
							{
								Lookup[manipAss,SourceSample],
								Lookup[manipAss,DestinationSample],
								If[MatchQ[Lookup[manipAss,Amount],_List],
									Lookup[manipAss,Amount],
									Table[Lookup[manipAss,Amount],numberOfTransfers]
								],
								Lookup[manipAss,AspirationPressure,Table[Null,numberOfTransfers]],
								Lookup[manipAss,DispensePressure,Table[Null,numberOfTransfers]],
								Lookup[manipAss,PipettingMethod,Table[Null,numberOfTransfers]]
							},
							{
								Join@@Lookup[manipAss,SourceSample],
								Join@@Lookup[manipAss,DestinationSample],
								Join@@Lookup[manipAss,Amount],
								Join@@Lookup[manipAss,AspirationPressure,Table[{Null},numberOfTransfers]],
								Join@@Lookup[manipAss,DispensePressure,Table[{Null},numberOfTransfers]],
								Lookup[manipAss,PipettingMethod,Table[Null,numberOfTransfers]]
							}
						]
					]
				],
				#
			]&,
			allTransfers
		]
	];
	
	nestedSourceModels = Map[
		Lookup[fetchPacketFromCacheHPLC[#,allSamplePackets],Model,Null]&,
		nestedSourceSamples,
		{3}
	];
	
	nestedDestinationModels = Map[
		Lookup[fetchPacketFromCacheHPLC[#,allSamplePackets],Model,Null]&,
		nestedDestinationSamples,
		{3}
	];
	
	nestedSourceResourcePositions = Map[
		First@FirstPosition[resourceSamples,#,{Null}]&,
		nestedSourceSamples,
		{3}
	];
	
	nestedSourceResources = Map[
		If[NullQ[#],
			Null,
			fulfilledSampleResources[[#]]
		]&,
		nestedSourceResourcePositions,
		{3}
	];
	
	nestedSourceResourceRequestors = Map[
		If[NullQ[#],
			Null,
			resourceRequestors[[#]]
		]&,
		nestedSourceResourcePositions,
		{3}
	];
	
	nestedSourceRequestorRequiredResources = Map[
		If[NullQ[#],
			Null,
			requestorRequiredResources[[#]]
		]&,
		nestedSourceResourcePositions,
		{3}
	];
	
	nestedSourceResourceFields = MapThread[
		MapThread[
			MapThread[
				Function[{requiredResources,resource},
					If[NullQ[resource],
						Null,
						SelectFirst[requiredResources,MatchQ[#[[1]],LinkP[resource]]&,{Null,Null,Null,Null}][[2]]
					]
				],
				{#1,#2}
			]&,
			{#1,#2}
		]&,
		{nestedSourceRequestorRequiredResources,nestedSourceResources}
	];
	
	nestedDestinationResourcePositions = Map[
		First@FirstPosition[resourceSamples,#,{Null}]&,
		nestedDestinationSamples,
		{3}
	];
	
	nestedDestinationResources = Map[
		If[NullQ[#],
			Null,
			fulfilledSampleResources[[#]]
		]&,
		nestedDestinationResourcePositions,
		{3}
	];
	
	nestedDestinationResourceRequestors = Map[
		If[NullQ[#],
			Null,
			resourceRequestors[[#]]
		]&,
		nestedDestinationResourcePositions,
		{3}
	];
	
	nestedDestinationRequestorRequiredResources = Map[
		If[NullQ[#],
			Null,
			requestorRequiredResources[[#]]
		]&,
		nestedDestinationResourcePositions,
		{3}
	];
	
	nestedDestinationResourceFields = MapThread[
		MapThread[
			MapThread[
				Function[{requiredResources,resource},
					If[NullQ[resource],
						Null,
						SelectFirst[requiredResources,MatchQ[#[[1]],LinkP[resource]]&,{Null,Null,Null,Null}][[2]]
					]
				],
				{#1,#2}
			]&,
			{#1,#2}
		]&,
		{nestedDestinationRequestorRequiredResources,nestedDestinationResources}
	];
	
	transferCheck = Join@@Join@@MapThread[
		Function[
			{
				protocol,
				transferPrimitives,
				listedSourceSamples,
				listedDestinationSamples,
				listedAmounts,
				listedAspirationPressures,
				listedDispensePressures,
				listedPipettingMethods,
				listedSourceModels,
				listedDestinationModels,
				listedSourceResourceRequestors,
				listedSourceResourceFields,
				listedDestinationResourceRequestors,
				listedDestinationResourceFields
			},
			MapThread[
				Function[
					{
						transferPrimitive,
						transferSourceSamples,
						transferDestinationSamples,
						transferAmounts,
						transferAspirationPressures,
						transferDispensePressures,
						transferPipettingMethods,
						transferSourceModels,
						transferDestinationModels,
						transferSourceResourceRequestors,
						transferSourceResourceFields,
						transferDestinationResourceRequestors,
						transferDestinationResourceFields
					},
					MapThread[
						Function[
							{
								sourceSample,
								destinationSample,
								amount,
								aspirationPressure,
								dispensePressure,
								pipettingMethod,
								sourceModel,
								destinationModel,
								sourceResourceRequestor,
								sourceResourceField,
								destinationResourceRequestor,
								destinationResourceField
							},
							Association[
								Protocol -> Link[protocol],
								Primitive -> If[MatchQ[transferPrimitive[Object],ObjectP[]],
									Null,
									transferPrimitive
								],
								UnitOperation -> If[MatchQ[transferPrimitive[Object],ObjectP[]],
									Link[transferPrimitive[Object]],
									Null
								],
								SourceSampleField -> sourceResourceField,
								SourceProtocol -> Link[sourceResourceRequestor],
								SourceSample -> Link[sourceSample],
								SourceSampleModel -> Link[sourceModel],
								DestinationSampleField -> destinationResourceField,
								DestinationProtocol -> Link[destinationResourceRequestor],
								DestinationSample -> Link[destinationSample],
								DestinationSampleModel -> Link[destinationModel],
								NominalAmount -> amount,
								SourceInitialAmountDetermination -> Null,
								SourceInitialAmount -> Null,
								SourceCalculatedInitialAmount -> Null,
								DestinationInitialAmountDetermination -> Null,
								DestinationInitialAmount -> Null,
								DestinationCalculatedInitialAmount -> Null,
								TransferAmount -> Null,
								PercentTransferred -> Null,
								SourceFinalAmount -> Null,
								DestinationFinalAmount -> Null,
								AspirationPressure -> aspirationPressure,
								DispensePressure -> dispensePressure,
								PipettingMethod -> Link[pipettingMethod]
							]
						],
						{
							transferSourceSamples,
							transferDestinationSamples,
							transferAmounts,
							transferAspirationPressures,
							transferDispensePressures,
							transferPipettingMethods,
							transferSourceModels,
							transferDestinationModels,
							transferSourceResourceRequestors,
							transferSourceResourceFields,
							transferDestinationResourceRequestors,
							transferDestinationResourceFields
						}
					]
				],
				{
					transferPrimitives,
					listedSourceSamples,
					listedDestinationSamples,
					listedAmounts,
					listedAspirationPressures,
					listedDispensePressures,
					listedPipettingMethods,
					listedSourceModels,
					listedDestinationModels,
					listedSourceResourceRequestors,
					listedSourceResourceFields,
					listedDestinationResourceRequestors,
					listedDestinationResourceFields
				}
			]
		],
		{
			Join[protocolsWithTransfers,spProtocolsWithTransfers],
			Join[resolvedTransfers,resolvedUnitOperationPackets],
			nestedSourceSamples,
			nestedDestinationSamples,
			nestedAmounts,
			nestedAspirationPressures,
			nestedDispensePressures,
			nestedPipettingMethods,
			nestedSourceModels,
			nestedDestinationModels,
			nestedSourceResourceRequestors,
			nestedSourceResourceFields,
			nestedDestinationResourceRequestors,
			nestedDestinationResourceFields
		}
	];
	
	possibleFunctionName = ToExpression["reviewExperiment"<>ToString[Download[myProtocol,Type]]];
	
	reviewExperimentFunction = If[Length[DownValues[functionName]]>0,
		possibleFunctionName,
		Null
	];
	
	generalPacket = Association[
		Type -> Object[Report,ReviewExperiment],
		PriorQualifications -> priorQualifications,
		SubsequentQualifications -> subsequentQualifications,
		PriorCalibrations -> priorCalibrations,
		SubsequentCalibrations -> subsequentCalibrations,
		PreventativeMaintenance -> preventativeMaintenance,
		SanitizationMaintenance -> sanitizationMaintenance,
		FullyDissolvedCheck -> fullyDissolvedCheck,
		pHAdjustmentCheck -> pHAdjustmentCheckValue,
		NumberOfUses -> numberOfUses,
		ResourceTable -> resourceTable,
		FreezeThawHistory -> freezeThawHistory,
		ExpirationCheck -> expirationCheck,
		AppearanceCheck -> appearanceCheck,
		SampleHistory -> sampleHistory,
		LaboratoryTraining -> laboratoryTraining,
		TransferCheck -> transferCheck
	];
	
	generalNotebookSections = If[TrueQ[Lookup[safeOps,Export]],
		generateReviewProtocolSections[myProtocol,generalPacket,Cache->{protocolPacket}],
		Null
	];
	
	{typeSpecificPacket,typeSpecificNotebookSections} = If[!NullQ[reviewExperimentFunction],
		reviewExperimentFunction[myProtocol,Output->{Packet,Sections}],
		{<||>,{}}
	];
	
	fullPacket = Join[generalPacket,typeSpecificPacket];
	
	exportedNotebook = If[Lookup[safeOps,Export],
		ExportReport[
			FileNameJoin[{$TemporaryDirectory,"ReviewExperiment-"<>CreateUUID[]}],
			generalNotebookSections,
			SaveToCloud -> Lookup[safeOps,Upload],
			CloseSections -> True
		],
		Null
	];
	
	(* Add Replace head to all multiple fields and append ReviewNotebook *)
	uploadPacketWithNotebook = Append[
		Association@KeyValueMap[
			Function[{fieldName,fieldValue},
				If[MatchQ[fieldName,Type],
					fieldName -> fieldValue,
					Replace[fieldName] -> fieldValue
				]
			],
			fullPacket
		],
		ReviewNotebook -> Link[exportedNotebook]
	];
	
	If[Lookup[safeOps,Upload],
		Upload[uploadPacketWithNotebook],
		uploadPacketWithNotebook
	]
];

Options[generateReviewProtocolSections]:={Cache->{},Upload->True};
generateReviewProtocolSections[myProtocol_,myReviewPacket_,ops:OptionsPattern[]]:=Module[
	{cache,protocolPacket,protocolInformation,priorQualificationsByInstrument,
	priorQualificationsInstrumentResultsTuples,priorQualificationsTable,subsequentQualificationsByInstrument,
	subsequentQualificationsInstrumentResultsTuples,subsequentQualificationsTable,priorCalibrationsByInstrument,
	priorCalibrationsInstrumentResultsTuples,priorCalibrationsTable,subsequentCalibrationsByInstrument,
	subsequentCalibrationsInstrumentResultsTuples,subsequentCalibrationsTable,preventativeMaintenancesByInstrument,
	preventativeMaintenancesInstrumentResultsTuples,preventativeMaintenancesTable,sanitizationMaintenancesByInstrument,
	sanitizationMaintenancesInstrumentResultsTuples,sanitizationMaintenancesTable,laboratoryTrainingByOperator,
	laboratoryTrainingOperatorResultsTuples,laboratoryTrainingTable,fullyDissolvedCheckTuples,fullyDissolvedCheckTable,
	pHAdjustmentCheckTuples,thepHAdjustmentCheckTable,numberOfUsesTuples,numberOfUsesTable,freezeThawHistoryTuples,
	freezeThawHistoryTable,expirationCheckTuples,expirationCheckTable,appearanceCheckTuples,appearanceCheckTable,
	sampleHistoryTuples,sampleHistoryTable,resourceTableTuples,transferCheckTuples,transferCheckTable,
	resourceTableTable,protocolTimeline},
	
	cache = OptionValue[Cache];
	
	protocolPacket = fetchPacketFromCacheHPLC[myProtocol,cache];
	
	protocolInformation = PlotTable[
		{
			{myProtocol},
			{DateString[Lookup[protocolPacket,DateStarted]]},
			{DateString[Lookup[protocolPacket,DateCompleted]]}
		}, 
		TableHeadings -> {
			{"Protocol", "Date Started", "Date Completed"},
			None
		},
		Background -> None, 
		Dividers -> None,
		Spacings -> {2, 1},
		Tooltips -> False
	];
	
	priorQualificationsByInstrument = GatherBy[
		Lookup[myReviewPacket,PriorQualifications],
		#[[2]]&
	];
	
	priorQualificationsInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						ReplaceAll[
							qualTuples[[All,{1,3,4}]],
							Fail -> Style[Fail,Red]
						],
						TableHeadings -> {
							None,
							{"Date", "Qualification", "Result"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		priorQualificationsByInstrument
	];
	
	priorQualificationsTable = If[MatchQ[priorQualificationsInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(priorQualificationsInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				priorQualificationsInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	subsequentQualificationsByInstrument = GatherBy[
		Lookup[myReviewPacket,SubsequentQualifications],
		#[[2]]&
	];
	
	subsequentQualificationsInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						ReplaceAll[
							qualTuples[[All,{1,3,4}]],
							Fail -> Style[Fail,Red]
						],
						TableHeadings -> {
							None,
							{"Date", "Qualification", "Result"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		subsequentQualificationsByInstrument
	];
	
	subsequentQualificationsTable = If[MatchQ[subsequentQualificationsInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(subsequentQualificationsInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				subsequentQualificationsInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	priorCalibrationsByInstrument = GatherBy[
		Lookup[myReviewPacket,PriorCalibrations],
		#[[2]]&
	];
	
	priorCalibrationsInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						qualTuples[[All,{1,3}]],
						TableHeadings -> {
							None,
							{"Date", "Maintenance"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		priorCalibrationsByInstrument
	];
	
	priorCalibrationsTable = If[MatchQ[priorCalibrationsInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(priorCalibrationsInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				priorCalibrationsInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	subsequentCalibrationsByInstrument = GatherBy[
		Lookup[myReviewPacket,SubsequentCalibrations],
		#[[2]]&
	];
	
	subsequentCalibrationsInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						qualTuples[[All,{1,3}]],
						TableHeadings -> {
							None,
							{"Date", "Maintenance"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		subsequentCalibrationsByInstrument
	];
	
	subsequentCalibrationsTable = If[MatchQ[subsequentCalibrationsInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(subsequentCalibrationsInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				subsequentCalibrationsInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	preventativeMaintenancesByInstrument = GatherBy[
		Lookup[myReviewPacket,PreventativeMaintenance],
		#[[2]]&
	];
	
	preventativeMaintenancesInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						qualTuples[[All,{1,3}]],
						TableHeadings -> {
							None,
							{"Date", "Maintenance"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		preventativeMaintenancesByInstrument
	];
	
	preventativeMaintenancesTable = If[MatchQ[preventativeMaintenancesInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(preventativeMaintenancesInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				preventativeMaintenancesInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	sanitizationMaintenancesByInstrument = GatherBy[
		Lookup[myReviewPacket,SanitizationMaintenance],
		#[[2]]&
	];
	
	sanitizationMaintenancesInstrumentResultsTuples = Map[
		Function[qualTuples,
			Module[
				{instrument},
					
				instrument = qualTuples[[1]][[2]];
			
				{
					instrument,
					PlotTable[
						qualTuples[[All,{1,3}]],
						TableHeadings -> {
							None,
							{"Date", "Maintenance"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		sanitizationMaintenancesByInstrument
	];
	
	sanitizationMaintenancesTable = If[MatchQ[sanitizationMaintenancesInstrumentResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(sanitizationMaintenancesInstrumentResultsTuples[[All,2]]),
			TableHeadings -> {
				sanitizationMaintenancesInstrumentResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	laboratoryTrainingByOperator = GatherBy[
		Lookup[myReviewPacket,LaboratoryTraining],
		#[[1]]&
	];
	
	laboratoryTrainingOperatorResultsTuples = Map[
		Function[qualTuples,
			Module[
				{operator},
					
				operator = qualTuples[[1]][[1]];
			
				{
					instrument,
					PlotTable[
						ReplaceAll[
							qualTuples[[All,{2,3,4,5}]],
							Fail -> Style[Fail,Red]
						],
						TableHeadings -> {
							None,
							{"Date", "Type", "Result", "Witness"}
						},
						Tooltips -> False,
						Alignment -> Center
					]
				}
			]
		],
		laboratoryTrainingByOperator
	];
	
	laboratoryTrainingTable = If[MatchQ[laboratoryTrainingOperatorResultsTuples,{}],
		Null,
		PlotTable[
			{#}&/@(laboratoryTrainingOperatorResultsTuples[[All,2]]),
			TableHeadings -> {
				laboratoryTrainingOperatorResultsTuples[[All,1]],
				None
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	fullyDissolvedCheckTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,FullyDissolved],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,FullyDissolvedCheck]
	];
	
	fullyDissolvedCheckTable = If[MatchQ[fullyDissolvedCheckTuples,{}],
		Null,
		PlotTable[
			ReplaceAll[
				fullyDissolvedCheckTuples,
				False -> Style[Fail,Red]
			],
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Fully Dissolved","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		];
	];
		
	pHAdjustmentCheckTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,pHAchieved],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,pHAdjustmentCheck]
	];
	
	thepHAdjustmentCheckTable = If[MatchQ[pHAdjustmentCheckTuples,{}],
		Null,
		PlotTable[
			ReplaceAll[
				pHAdjustmentCheckTuples,
				False -> Style[Fail,Red]
			],
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","pH Achieved","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	numberOfUsesTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,StartNumberOfUses],
				Lookup[rules,EndNumberOfUses],
				Lookup[rules,MaxNumberOfUses],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,NumberOfUses]
	];
	
	numberOfUsesTable = If[MatchQ[numberOfUsesTuples,{}],
		Null,
		PlotTable[
			numberOfUsesTuples,
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Start NumberOfUses","End NumberOfUses","Max NumberOfUses","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		];
	];	
	
	freezeThawHistoryTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,NumberOfThaws],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,FreezeThawHistory]
	];
	
	freezeThawHistoryTable = If[MatchQ[freezeThawHistoryTuples,{}],
		Null,
		PlotTable[
			freezeThawHistoryTuples,
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Number of Thaws","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	expirationCheckTuples = Map[
		Function[rules,
			{
				Lookup[rules,Item],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,ExpirationDate],
				Lookup[rules,DateUsed],
				Lookup[rules,TimeRemaining],
				Lookup[rules,DateStocked],
				Lookup[rules,ShelfLife],
				Lookup[rules,DateUnsealed],
				Lookup[rules,UnsealedShelfLife],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,ExpirationCheck]
	];
	
	expirationCheckTable = If[MatchQ[expirationCheckTuples,{}],
		Null,
		PlotTable[
			expirationCheckTuples,
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Expiration Date","Date Used","Time Remaining",
				"Date Stocked","Shelf Life","Date Unsealed","Unsealed Shelf Life","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	appearanceCheckTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,Appearance],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,AppearanceCheck]
	];
	
	appearanceCheckTable = If[MatchQ[appearanceCheckTuples,{}],
		Null,
		PlotTable[
			appearanceCheckTuples,
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Appearance","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	
	sampleHistoryTuples = Map[
		Function[rules,
			{
				Lookup[rules,Sample],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,SampleHistory],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,SampleHistory]
	];
	
	sampleHistoryTable = If[MatchQ[sampleHistoryTuples,{}],
		Null,
		PlotTable[
			sampleHistoryTuples,
			TableHeadings -> {
				None,
				{"Sample","Source Field","Model","Sample History","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Left
		]
	];
	
	
	
	resourceTableTuples = Map[
		Function[rules,
			{
				Lookup[rules,Item],
				Lookup[rules,FieldName],
				Lookup[rules,Model],
				Lookup[rules,Protocol]
			}
		],
		Lookup[myReviewPacket,ResourceTable]
	];
	
	resourceTableTable = If[MatchQ[resourceTableTuples,{}],
		Null,
		PlotTable[
			resourceTableTuples,
			TableHeadings -> {
				None,
				{"Item","Source Field","Model","Protocol"}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	transferCheckTuples = Map[
		Function[rules,
			{
				Lookup[rules,Protocol,Null],
				If[NullQ[Lookup[rules,UnitOperation,Null]],
					Lookup[rules,Primitive,Null],
					Lookup[rules,UnitOperation]
				],
				Lookup[rules,SourceSampleField,Null],
				Lookup[rules,SourceProtocol,Null],
				Lookup[rules,SourceSample,Null],
				Lookup[rules,SourceSampleModel,Null],
				Lookup[rules,DestinationSampleField,Null],
				Lookup[rules,DestinationProtocol,Null],
				Lookup[rules,DestinationSample,Null],
				Lookup[rules,DestinationSampleModel,Null],
				Lookup[rules,NominalAmount,Null],
				If[NullQ[Lookup[rules,AspirationPressure,Null]],
					Null,
					ListLinePlot[Lookup[rules,AspirationPressure],AxesLabel -> Automatic]
				],
				If[NullQ[Lookup[rules,DispensePressure,Null]],
					Null,
					ListLinePlot[Lookup[rules,DispensePressure],AxesLabel -> Automatic]
				],
				Lookup[rules,PipettingMethod,Null],
				Lookup[rules,SourceInitialAmountDetermination,Null],
				Lookup[rules,SourceInitialAmount,Null],
				Lookup[rules,SourceCalculatedInitialAmount,Null],
				Lookup[rules,DestinationInitialAmountDetermination,Null],
				Lookup[rules,DestinationInitialAmount,Null],
				Lookup[rules,DestinationCalculatedInitialAmount,Null],
				Lookup[rules,TransferAmount,Null],
				Lookup[rules,PercentTransferred,Null],
				Lookup[rules,SourceFinalAmount,Null],
				Lookup[rules,DestinationFinalAmount,Null]
			}
		],
		Lookup[myReviewPacket,TransferCheck]
	];
	
	transferCheckTable = If[MatchQ[transferCheckTuples,{}],
		Null,
		PlotTable[
			transferCheckTuples,
			TableHeadings -> {
				None,
				{
					"Protocol",
					"Primitive",
					"Source Field",
					"Source Protocol",
					"Source Sample",
					"Source Model",
					"Destination Field",
					"Destination Protocol",
					"Destination Sample",
					"Destination Model",
					"Nominal Amount",
					"Aspiration Pressure",
					"Dispense Pressure",
					"Pipetting Method",
					"Source Initial Amount Determination",
					"Source Initial Amount",
					"Source Calculated Initial Amount",
					"Destination Initial Amount Determination",
					"Destination Initial Amount",
					"Destination Calculated Initial Amount",
					"Transfer Amount",
					"Percent Transferred",
					"Source Final Amount",
					"Destination Final Amount"
				}
			},
			Tooltips -> False,
			Alignment -> Center
		]
	];
	
	protocolTimeline = PlotProtocolTimeline[myProtocol];
	
	NamedObject[
		Join[
			{
				{Title,"Protocol Execution Report"},
				{Section,"Protocol Information"},
					protocolInformation,
				{Section,"Instrument Information"}
			},
			If[NullQ[priorQualificationsTable],
				{},
				{
					{Subsection,"Prior Qualifications"},
					priorQualificationsTable
				}
			],
			If[NullQ[subsequentQualificationsTable],
				{},
				{
					{Subsection,"Subsequent Qualifications"},
					subsequentQualificationsTable
				}
			],
			If[NullQ[priorCalibrationsTable],
				{},
				{
					{Subsection,"Prior Calibrations"},
					priorCalibrationsTable
				}
			],
			If[NullQ[subsequentCalibrationsTable],
				{},
				{
					{Subsection,"Subsequent Calibrations"},
					subsequentCalibrationsTable
				}
			],
			If[NullQ[preventativeMaintenancesTable],
				{},
				{
					{Subsection,"Preventative Maintenance"},
					preventativeMaintenancesTable
				}
			],
			If[NullQ[sanitizationMaintenancesTable],
				{},
				{
					{Subsection,"Sanitization Maintenance"},
					sanitizationMaintenancesTable
				}
			],
		{{Section,"Materials Verification"}},
			If[NullQ[resourceTableTable],
				{},
				{
					{Subsection,"Resources Table"},
					resourceTableTable
				}
			],
			If[NullQ[fullyDissolvedCheckTable],
				{},
				{
					{Subsection,"Dissolution Check"},
					fullyDissolvedCheckTable
				}
			],
			If[NullQ[thepHAdjustmentCheckTable],
				{},
				{
					{Subsection,"pH Adjustment Check"},
					thepHAdjustmentCheckTable
				}
			],
			If[NullQ[numberOfUsesTable],
				{},
				{
					{Subsection,"Number of Uses Check"},
					numberOfUsesTable
				}
			],
			If[NullQ[freezeThawHistoryTable],
				{},
				{
					{Subsection,"Freeze Thaw History"},
					freezeThawHistoryTable
				}
			],
			If[NullQ[expirationCheckTable],
				{},
				{
					{Subsection,"Expiration Check"},
					expirationCheckTable
				}
			],
			If[NullQ[appearanceCheckTable],
				{},
				{
					{Subsection,"Appearance Check"},
					appearanceCheckTable
				}
			],
			If[NullQ[sampleHistoryTable],
				{},
				{
					{Subsection,"Sample History"},
					sampleHistoryTable
				}
			],
		{{Section,"Protocol Execution"}},
			If[NullQ[protocolTimeline],
				{},
				{
					{Subsection,"Protocol Timeline"},
					protocolTimeline
				}
			],
			If[NullQ[transferCheckTable],
				{},
				{
					{Subsection,"Transfer Check"},
					transferCheckTable
				}
			]
		]
	]
];