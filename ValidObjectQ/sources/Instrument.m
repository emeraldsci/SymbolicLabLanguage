(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validInstrumentQTests*)


validInstrumentQTests[packet:PacketP[Object[Instrument]]]:={
	NotNullFieldTest[packet,{
		Model,
		Status,
		ImageFile,
		DatePurchased,
		DateInstalled,
		SerialNumbers,
		LocationLog,
		Cost,
		Name
	}],

	Test["The Balances field matches the Balances that are inside of the instrument:",
		ContainsExactly[
			Download[Lookup[packet, Balances], Object],
			Download[
				Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Instrument, Balance]]],
				Object
			]
		],
		True
	],

	Test["If Status is not Retired, the instrument has a location log:",
		Lookup[packet,{Status,LocationLog}],
		{Retired,_}|{Except[Retired],Except[{}]}
	],

	If[!TrueQ[Lookup[packet,Missing]],
		Test["The last entry in LocationLog matches the current Position and Container, if the instrument is not missing:",
			{#[[4]],#[[3]][Object]}&[Last[Lookup[packet, LocationLog]]],
			{Lookup[packet,Position],Lookup[packet,Container][Object]}
		],
		Nothing
	],

	Test["If Status is not Retired, the instrument has a Site:",
		Lookup[packet,{Status,Site}],
		{Retired,_}|{Except[Retired],ObjectP[Object[Container, Site]]}
	],

	(* Dates *)
	Test["If DatePurchased is informed, it is in the past:",
		Lookup[packet, DatePurchased],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	Test["If DateInstalled is informed, it is in the past:",
		Lookup[packet, DateInstalled],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	Test["If DateRetired is informed, it is in the past:",
		Lookup[packet, DateRetired],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	FieldComparisonTest[packet,{DatePurchased,DateInstalled},LessEqual],
	FieldComparisonTest[packet,{DateInstalled,DateRetired},LessEqual],

	Test["If Status is Retired, DateRetired must be informed. If Status is not Retired, DateRetired may not be informed:",
		Lookup[packet,{Status,DateRetired}],
		{Retired,Except[Null]}|{Except[Retired],Null}
	],

	(* Decks *)
	Test["Status of instrument should correspond to statuses of any decks, if Decks is informed:",
		Module[
			{decks,status},
			{decks,status}=Lookup[packet,{Decks,Status}];
			If[decks!={},
				{status,DeleteDuplicates[Download[decks,Status]]},
				True
			]
		],
		{(Available|Running|UndergoingMaintenance),{Available}}|{Retired,{Discarded}}|True
	],

	(* contents status test *)
	Test["Instrument status should match with down container status:",
		With[
			{contents=Lookup[packet,Contents][[All,2]]},
			{
				Lookup[packet,Status],
				DeleteDuplicates[Download[contents,Status]]
			}
		],
		Alternatives[
			{Retired, {(Inactive|Retired)...}},
			{UndergoingMaintenance, {___}}, (* Don't require status change of contents for instruments that are temporarily undergoing maintenance *)
			{Except[Retired | UndergoingMaintenance], {Except[(Inactive|Retired)]...}},
			True
		]
	],

	Test[
		"The DataFilePath must be different from the DefaultDataFilePath. DataFilePath should only be populated if it is distinct from the DefaultDataFilePath:",
		Module[{path,defaultPath},
			{path,defaultPath}=Download[packet,{DataFilePath,Model[DefaultDataFilePath]}];
			(* If default is populated, it must be different than path *)
			MatchQ[defaultPath,Null] || !MatchQ[path,defaultPath]
		],
		True
	],

	Test[
		"The MethodFilePath must be different from the DefaultMethodFilePath. MethodFilePath should only be populated if it is distinct from the DefaultMethodFilePath:",
		Module[{path,defaultPath},
			{path,defaultPath}=Download[packet,{MethodFilePath,Model[DefaultMethodFilePath]}];
			(* If default is populated, it must be different than path *)
			MatchQ[defaultPath,Null] || !MatchQ[path,defaultPath]
		],
		True
	],

	(* Cameras *)
	Test["Positions monitored by the cameras exist on the Instrument:",
		Module[{allowedPosition, monitoredLocations},

			allowedPosition = Lookup[packet, AllowedPositions];

			monitoredLocations = Lookup[packet, Cameras][[All, 1]];

			If[monitoredLocations == {}, Return[True]];

			AllTrue[MemberQ[allowedPosition, #] & /@ monitoredLocations, TrueQ]
		],
		True
	],

	(* Reservoir Slot *)
	Test["Instruments with Reservoir slot must have its Contents filled in:",
		Module[{positions,status,positionList,posIndex,contents,positionName},
			{positions,status}=Download[packet,{AllowedPositions,Status}];
			posIndex=If[!NullQ[positions],
				positionList=ToList[Sequence@@positions];
				Flatten[Position[StringPosition[positionList,"Reservoir"],{{_Integer..}}]],
				{}
			];
			If[MatchQ[status,Available]&&MatchQ[posIndex,{_Integer..}],
				positionName=positionList[[posIndex]];
				contents=Cases[Download[packet,Contents],{First[positionName],ObjectP[Object[Container]]}];
				MatchQ[contents,{{_String,ObjectP[Object[Container]]}}],
				True
			]
		],
		True
	],

	(* Neither the Position nor the Contents index of any entry of Contents may be Null *)
	Test["No entries in the Contents field contain Null:",
		MemberQ[Lookup[packet, Contents], {Null, _} | {_, Null}],
		False
	],
	
	Test["If LocalCache is populated, its LocalCacheStorage field is True in all local cache containers:",
		If[MatchQ[Lookup[packet,LocalCache],{ObjectP[]..}],
			And@@(TrueQ/@Download[Lookup[packet,LocalCache],LocalCacheStorage]),
			True
		],
		True
	],

	Test["If the instrument's model has LocalCacheContents and the instrument is active, the LocalCache contents and any deck contents satisfy the model's LocalCacheContents requirements:",
		If[MatchQ[Lookup[packet,Status],Available|Running],
			Module[{modelLocalCacheContents,allContentPackets,localCacheValidityBools},

				(* get the local cache contents of the model *)
				modelLocalCacheContents=Download[Lookup[packet,Model],LocalCacheContents];

				(* return a True now if this is empty *)
				If[MatchQ[modelLocalCacheContents,{}],
					Return[True]
				];

				(* now download everything in instrument's contents, and LocalCache contents *)
				allContentPackets=Flatten@Download[Lookup[packet,Object],
					{
						Packet[Repeated[Contents[[All,2]]][{Model}]],
						Packet[LocalCache[Repeated[Contents[[All,2]]]][{Model}]]
					}
				];

				(* for each entry in model's requirements, see if we have the right count in allContentPackets *)
				localCacheValidityBools=Map[
					Function[localCacheContentEntry,
						Module[{requiredModel,quantity,modelCount},

							(* separate the modle and quantity required by this entry *)
							{requiredModel,quantity}={Download[localCacheContentEntry[[1]],Object],localCacheContentEntry[[2]]};

							(* get the count of this model in the contents of local cache/inst *)
							modelCount=Length[Select[allContentPackets,MatchQ[Download[Lookup[#,Model],Object],requiredModel]&]];

							modelCount>=quantity
						]
					],
					modelLocalCacheContents
				];

				AllTrue[localCacheValidityBools]
			],
			True
		],
		True
	],

	(* ----------- Fine-grained tests ---------- *)
	(* All contents occupy positions that exist in the modelContainer *)
	containerContentsValid[packet],

	(* No container loops exist anywhere in the container's tree *)
	(* THIS TEST CAN BE VERY SLOW DEPENDING ON THE SIZE AND CONNECTEDNESS OF THE CONTAINER TREE *)
	containerLoopsAbsent[packet],

	(* If the Object has Connectors in its Model, then it must have corresponding entries in the Object's Connectors field *)
	Test["All Connector positions from this Object's Model have entries in the Object and vice versa:",
		Module[{modelConnectors,modelConnectorNames, objectConnectors, objectConnectorNames},
			modelConnectors = Download[Lookup[packet,Model],Connectors];
			modelConnectorNames = First/@modelConnectors;

			objectConnectors = Lookup[packet,Connectors];
			objectConnectorNames = First/@objectConnectors;

			If[MatchQ[modelConnectors,{}],
				MatchQ[objectConnectorNames,{}],
				MatchQ[objectConnectorNames, {OrderlessPatternSequence @@ modelConnectorNames}]
			]
		],
		True
	],

	Test["All Nuts are placed at positions present in the Object's Connectors field:",
		Complement[Lookup[packet,Nuts][[All,1]],Lookup[packet,Connectors][[All,1]]],
		{}
	],

	Test["All Ferrules are placed at positions present in the Object's Connectors field:",
		Complement[Lookup[packet,Ferrules][[All,1]],Lookup[packet,Connectors][[All,1]]],
		{}
	],

	(* the latest entry of the PlumbingFittingsLog agrees with the Nuts and Ferrules present *)
	Test["The latest entry of the PlumbingFittingsLog for each connector contains the installed Nuts and Ferrules:",
		Module[{nuts, ferrules, fittingsLog, logConnectors, mostRecentEntries, connectorNut, connectorFerrule, logNut, logFerrule, logsMatchFittingsBools},
			{nuts, ferrules, fittingsLog} = Lookup[packet,{Nuts, Ferrules, PlumbingFittingsLog}];

			(* get all the connectors in the log *)
			logConnectors = DeleteDuplicates[fittingsLog[[All,2]]];

			(* if any nuts or ferrules are at positions not in logConnectors, return False immediately *)
			If[!MatchQ[Complement[nuts[[All,1]],logConnectors],{}] || !MatchQ[Complement[ferrules[[All,1]],logConnectors],{}],
				Return[False],
				Nothing
			];

			(* get the last entry for each connector *)
			mostRecentEntries = If[!MatchQ[fittingsLog,{}],
				Map[
					Function[{connector},
						(* sort the entries by most recent first, then pick the first instance of each connector in the log *)
						SelectFirst[SortBy[fittingsLog,Function[logEntry,Now-logEntry[[1]]]], StringMatchQ[#[[2]], connector] &]
					],
					logConnectors
				],
				{}
			];

			(* Map by each connector to determine if the log entry agrees with the expected nut and ferrule *)
			logsMatchFittingsBools = Map[Function[{connector},
				Module[{connectorLogEntry},
					(* this guy should always exist, it was created from the log *)
					connectorLogEntry = SelectFirst[mostRecentEntries, StringMatchQ[#[[2]], connector] &];
					(* these may not exist and return Missing. if so turn them into Null as they will be present in the log if they had been removed. strip links *)
					connectorNut = SelectFirst[nuts, StringMatchQ[#[[1]], connector] &][[2]]/.{x_Link :> Download[x,Object], _Missing->Null};
					connectorFerrule = SelectFirst[ferrules, StringMatchQ[#[[1]], connector] &][[2]]/.{x_Link :> Download[x,Object], _Missing->Null};
					(* strip links if there are any. they may be Null *)
					logNut = connectorLogEntry[[4]]/.{x_Link :> Download[x,Object]};
					logFerrule = connectorLogEntry[[5]]/.{x_Link :> Download[x,Object]};
					(* compare and return the result *)
					MatchQ[connectorNut,logNut] && MatchQ[connectorFerrule,logFerrule]
				]
			],
				logConnectors
			];

			(* return the And of the results from each connector *)
			And@@logsMatchFittingsBools
		],
		True
	],

	(* -- Wiring -- *)
	(* If the Object has WiringConnectors in its Model, then it must have corresponding entries in the Object's WiringConnectors field *)
	Test["All WiringConnectors positions from this Object's Model have entries in the Object and vice versa:",
		Module[{modelConnectors,modelConnectorNames, objectConnectors, objectConnectorNames},
			modelConnectors = Download[Lookup[packet,Model],WiringConnectors];
			modelConnectorNames = First/@modelConnectors;

			objectConnectors = Lookup[packet,WiringConnectors];
			objectConnectorNames = First/@objectConnectors;

			If[MatchQ[modelConnectors,{}],
				MatchQ[objectConnectorNames,{}],
				MatchQ[objectConnectorNames, {OrderlessPatternSequence @@ modelConnectorNames}]
			]
		],
		True
	],

	(*If a NextQualificationDate is given,it must be for one of the qualification models specified in QualificationFrequency*)
	Test["The qualifications entered in the NextQualificationDate field are members of the QualificationFrequency field:",
		Module[{qualFrequency, nextQualDate, qualFrequencyModels, nextQualDateModels},
			{nextQualDate, qualFrequency} =	Lookup[packet, {NextQualificationDate, QualificationFrequency}];

			qualFrequencyModels = If[MatchQ[qualFrequency, Alternatives[Null, {}]], {}, First /@ qualFrequency];
			nextQualDateModels = If[MatchQ[nextQualDate, Alternatives[Null, {}]], {}, First /@ nextQualDate];

			(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
			And @@ (MemberQ[qualFrequencyModels, ObjectP[#]] & /@nextQualDateModels)
		],
		True
	],

	(*If a NextMaintenanceDate is given,it must be for one of the maintenance models specified in MaintenanceFrequency*)
	Test["The maintenance entered in the NextMaintenanceDate field are members of the MaintenanceFrequency field:",
		Module[{maintFrequency, nextMaintDate, maintFrequencyModels, nextMaintDateModels},
			{nextMaintDate, maintFrequency} = Lookup[packet, {NextMaintenanceDate, MaintenanceFrequency}];

			maintFrequencyModels = If[MatchQ[maintFrequency, Alternatives[Null, {}]], {}, First /@ maintFrequency];
			nextMaintDateModels = If[MatchQ[nextMaintDate, Alternatives[Null, {}]], {}, First /@ nextMaintDate];

			(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
			And @@ (MemberQ[maintFrequencyModels, ObjectP[#]] & /@nextMaintDateModels)
		],
		True
	],

	Test["If Mobile is True, the instrument or its model has a StoragePositions:",
		With[
			{
				mobile=Lookup[packet,Mobile],
				storageContainer=Lookup[packet,StoragePositions][[All,1]],
				modelMobile=Download[Lookup[packet,Object],Model[Mobile]],
				modelContainers=Download[Lookup[packet,Object],Model[StoragePositions]][[All,1]]
			},
			{
				mobile,
				storageContainer,
				modelMobile,
				modelContainers
			}
		],
		Alternatives[
			(* if explicitly true, the object or model must have a storage container *)
			{True,{ObjectP[]..},_,_},
			{True,_,_,{ObjectP[]..}},
			(* if implicitly true, model or object must have a storage container *)
			{Null,ObjectP[],True,_},
			{Null,_,True,{ObjectP[]..}},
			(* if explicitly false, no storage container is required anywhere *)
			{False,_,_,_},
			(* if implicitly false, no storage container is required anywhere *)
			{Except[True],_,Except[True],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentAnemometerQTests*)


validInstrumentAnemometerQTests[packet:PacketP[Object[Instrument,Anemometer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentAcousticLiquidHandlerQTests*)


validInstrumentAcousticLiquidHandlerQTests[packet:PacketP[Object[Instrument,LiquidHandler,AcousticLiquidHandler]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentAspiratorQTests*)


validInstrumentAspiratorQTests[packet:PacketP[Object[Instrument,Aspirator]]]:={
(* Shared fields which should be null *)
	NullFieldTest[packet, {
		Dongle,
		IP,
		DataFilePath,
		MethodFilePath,
		Software
	}
	],

	NotNullFieldTest[packet,
		{
			VacuumPump
		}
	],
	Test["If the instrument's vacuum pump is an instrument, WasteContainer is informed:",
		If[MatchQ[Lookup[packet,VacuumPump],ObjectP[Object[Instrument]]],
			MatchQ[Lookup[packet,WasteContainer],Except[Null]],
			True
		],
		True
	],
	Test["If the instrument's vacuum pump is an instrument, AspiratorConnectors is informed:",
		If[MatchQ[Lookup[packet,VacuumPump],ObjectP[Object[Instrument]]],
			MatchQ[Lookup[packet,AspiratorConnectors],Except[Null]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentAutoclaveQTests*)


validInstrumentAutoclaveQTests[packet:PacketP[Object[Instrument,Autoclave]]]:={
(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
	(* Shared fields which should be null *)
		Decks,
		WasteContainer
	}],

	NotNullFieldTest[packet, PostAutoclaveCoolingArea],

	Test["The instrument has PostAutoclaveCoolingArea at the same site:",
		MatchQ[
			(* The field is in the form of {position, Object[Container]} if populated *)
			Download[FirstCase[Lookup[packet,PostAutoclaveCoolingArea],ObjectP[],Null],
				Site],
			ObjectP[Lookup[packet,Site]]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentBlowGunQTests*)


validInstrumentBlowGunQTests[packet:PacketP[Object[Instrument, BlowGun]]]:={
	NotNullFieldTest[packet, NitrogenValve],
	NullFieldTest[packet, ArgonValve]
};



(* ::Subsection::Closed:: *)
(*validInstrumentBalanceQTests*)


validInstrumentBalanceQTests[packet:PacketP[Object[Instrument,Balance]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		OperatingSystem,
		Dongle,
		WasteContainer,
		ArgonValve,
		NitrogenValve
	}]
};

validInstrumentDistanceGaugeQTests[packet:PacketP[Object[Instrument,DistanceGauge]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		OperatingSystem,
		Dongle,
		WasteContainer,
		ArgonValve,
		NitrogenValve
	}],
	(* fields which should be defined *)
	NotNullFieldTest[packet, {Mode, MaxDistance}]
};

(* ::Subsection::Closed:: *)
(*validInstrumentpHMeterQTests*)


Authors[validInstrumentpHMeterQTests]:={"xiwei.shan"};

validInstrumentpHMeterQTests[packet:PacketP[Object[Instrument,pHMeter]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		MethodFilePath,
		Decks,
		Dongle,
		ArgonValve,
		NitrogenValve
	}],

	NotNullFieldTest[packet,{Probe, ProbeReservoir, ProbeStorageContainer}],
	RequiredTogetherTest[packet,{SecondaryProbe,SecondaryProbeReservoir,SecondaryProbeStorageContainer}],
	RequiredTogetherTest[packet,{TertiaryProbe,TertiaryProbeReservoir,TertiaryProbeStorageContainer}],


	Test["The connected probes match those expected by the instrument model:",
		(* Only check this for SevenExcellence (for pH) probes.
		Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"] and Model[Instrument, pHMeter, "Mettler Toledo InLab Reach 225"] are not checked
		because these two models do not have Probes filed populated *)
		If[MatchQ[Lookup[packet,Model],ObjectP[Model[Instrument, pHMeter, "id:dORYzZJx7zpw"]]],(*Model[Instrument, pHMeter, "SevenExcellence (for pH)"]*)
			MatchQ[
				Download[DeleteCases[Lookup[packet, {Probe, SecondaryProbe, TertiaryProbe}], Null], Model[Object]],
				DeleteCases[Download[packet,Model[Probes][Object]],Null]
			],
			True
			],
		True
	],

	(* The seven excellence meters require DataFilePath based on how the code is set up now.
		This test assumes this is true for any additional pH meters we buy with computers, but can be made more specific if needed *)
	Test["If the instrument has an associated computer DataFilePath must be set:",
		If[MatchQ[Lookup[packet,Computer],Null],
			True,
			MatchQ[Lookup[packet,DataFilePath],Except[Null]]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentpHTitratorQTests*)

Authors[validInstrumentpHTitratorQTests]:={"xu.yi"};

validInstrumentpHTitratorQTests[packet:PacketP[Object[Instrument,pHTitrator]]]:={

	(* Shared fields which should be not be null *)
	NotNullFieldTest[packet,
		{
			IP,
			PDU,
			MixInstrument,
			pHMeter
		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentConductivityMeterQTests*)


validInstrumentConductivityMeterQTests[packet:PacketP[Object[Instrument,ConductivityMeter]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet,
	{
		IP,
		PDU,
		Decks,
		Dongle,
		WasteContainer,
		ArgonValve,
		NitrogenValve
	}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSterilizationIndicatorReaderQTests*)


validInstrumentSterilizationIndicatorReaderQTests[packet:PacketP[Object[Instrument,SterilizationIndicatorReader]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		WasteContainer,
		ArgonValve,
		NitrogenValve
	}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet, {PDU, IP}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSyringePumpQTests*)


validInstrumentSyringePumpQTests[packet:PacketP[Object[Instrument,SyringePump]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentBioLayerInterferometerQTests*)


validInstrumentBioLayerInterferometerQTests[packet:PacketP[Object[Instrument,BioLayerInterferometer]]]:= {

	(*shared fields which should be null*)

	NullFieldTest[
		packet,
		{
			CO2Valve,
			NitrogenValve,
			ArgonValve,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			IP,
			PDU,
			WasteScale
		}
	],

	(*Shared and unique fields which should be informed*)

	NotNullFieldTest[
		packet,
		{
			OperatingSystem,
			Software,
			DataFilePath,
			MethodFilePath
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentBiosafetyCabinetQTests*)


validInstrumentBiosafetyCabinetQTests[packet:PacketP[Object[Instrument,BiosafetyCabinet]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		ArgonValve
	}],

	NotNullFieldTest[packet, {
		BiosafetyWasteBin
	}],

	Test["The BiosafetyWasteBin field matches the BiosafetyWasteBin that are stored under the instrument:",
		And[
			ContainsAll[
				Download[
					Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Container, WasteBin]]],
					Object
				],
				{Download[Lookup[packet, BiosafetyWasteBin], Object]}
			],
			ContainsAll[
				Download[
					Cases[Flatten[Download[Lookup[packet, BiosafetyWasteBin], StoragePositions]], ObjectP[]],
					Object
				],
				{Lookup[packet, Object]}
			]
		],
		True
	],

	Test["The Pipettes field matches the Pipettes that are inside of the instrument:",
		ContainsAll[
			Download[
				Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Instrument, Pipette]]],
				Object
			],
			Download[Lookup[packet, Pipettes], Object]
		],
		True
	]
};




(* ::Subsection::Closed:: *)
(*validInstrumentHandlingStationBiosafetyCabinetQTests*)


validInstrumentHandlingStationBiosafetyCabinetQTests[packet:PacketP[Object[Instrument,HandlingStation,BiosafetyCabinet]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		ArgonValve
	}],

	NotNullFieldTest[packet, {
		BiosafetyWasteBin
	}],

	Test["The BiosafetyWasteBin field matches the BiosafetyWasteBin that are stored under the instrument:",
		And[
			ContainsAll[
				Download[
					Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Container, WasteBin]]],
					Object
				],
				{Download[Lookup[packet, BiosafetyWasteBin], Object]}
			],
			ContainsAll[
				Download[
					Cases[Flatten[Download[Lookup[packet, BiosafetyWasteBin], StoragePositions]], ObjectP[]],
					Object
				],
				{Lookup[packet, Object]}
			]
		],
		True
	],

	Test["The Pipettes field matches the Pipettes that are inside of the instrument:",
		ContainsAll[
			Download[
				Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Instrument, Pipette]]],
				Object
			],
			Download[Lookup[packet, Pipettes], Object]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentGloveBoxQTests*)


validInstrumentGloveBoxQTests[packet:PacketP[Object[Instrument,GloveBox]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		ArgonValve
	}],

	Test["The Pipettes field matches the Pipettes that are inside of the instrument:",
		ContainsAll[
			Download[
				Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Instrument, Pipette]]],
				Object
			],
			Download[Lookup[packet, Pipettes], Object]
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentHandlingStationGloveBoxQTests*)


validInstrumentHandlingStationGloveBoxQTests[packet:PacketP[Object[Instrument,HandlingStation,GloveBox]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		ArgonPressureSensor,
		CO2PressureSensor,
		ArgonValve
	}],

	Test["The Pipettes field matches the Pipettes that are inside of the instrument:",
		ContainsAll[
			Download[
				Cases[Flatten[Quiet[Download[Lookup[packet, Object], Repeated[Contents[[All,2]]]]]], ObjectP[Object[Instrument, Pipette]]],
				Object
			],
			Download[Lookup[packet, Pipettes], Object]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentBottleRollerQTests*)


validInstrumentBottleRollerQTests[packet:PacketP[Object[Instrument,BottleRoller]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{
		IP,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		WasteContainer,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}],

	NotNullFieldTest[packet,PDU]
};



(* ::Subsection::Closed:: *)
(*validInstrumentBottleTopDispenserQTests*)


validInstrumentBottleTopDispenserQTests[packet:PacketP[Object[Instrument,BottleTopDispenser]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		WasteContainer,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentCentrifugeQTests*)


validInstrumentCentrifugeQTests[packet:PacketP[Object[Instrument,Centrifuge]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet,{
		Decks,
		WasteContainer,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentColonyHandlerQTests*)


validInstrumentColonyHandlerQTests[packet:PacketP[Object[Instrument,ColonyHandler]]]:={
	(* The instrument should always have a deck *)
	NotNullFieldTest[packet,{ColonyHandlerDeck}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentColonyImagerQTests*)


validInstrumentColonyImagerQTests[packet:PacketP[Object[Instrument,ColonyImager]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentChromatographyQTests*)


validInstrumentChromatographyQTests[packet:PacketP[Object[Instrument,Chromatography]]]:={

	NotNullFieldTest[packet,{DataFilePath,Software,Decks,WasteContainer}],

	NullFieldTest[packet, {ArgonPressureSensor,CO2PressureSensor,NitrogenPressureSensor,IP,PDU,ArgonValve,NitrogenValve}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentCrossFlowFiltrationQTests*)


validInstrumentCrossFlowFiltrationQTests[packet:PacketP[Object[Instrument,CrossFlowFiltration]]]:={

	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		Positions,
		PositionPlotting,
		WettedMaterials
	}],
	
	(* KR2i unique fields*)
	If[
		MatchQ[Download[Lookup[packet, Model],Object],ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "id:vXl9j57jJnoD"]]],
		NotNullFieldTest[packet,{
			PrimaryPump,
			SecondaryPump,
			FeedScale,
			PermeateScale,
			FeedPressureSensor,
			RetentatePressureSensor,
			PermeatePressureSensor,
			PermeateConductivitySensor,
			RetentateConductivitySensor,
			AbsorbanceDetector
		}],
		Nothing
	],

	NullFieldTest[packet,{
		ArgonPressureSensor,
		ArgonValve,
		CO2PressureSensor,
		CO2Valve,
		Dongle,
		NitrogenPressureSensor,
		NitrogenValve
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentCrystalIncubatorQTests*)


validInstrumentCrystalIncubatorQTests[packet:PacketP[Object[Instrument,CrystalIncubator]]]:={
	NotNullFieldTest[packet, {
		DefaultTemperature,
		Capacity
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentCuvetteWasherQTests*)


validInstrumentCuvetteWasherQTests[packet:PacketP[Object[Instrument,CuvetteWasher]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		IP,
		PDU,
		DataFilePath,
		MethodFilePath,
		Software,
		Decks,
		WasteContainer,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}],

	(* Unique fields *)
	Test["If the Status is not retired, VacuumPump is informed:",
		Lookup[packet,{Status,VacuumPump}],
		{Retired,_}|{Except[Retired],Except[Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDensityMeterQTests*)


validInstrumentDensityMeterQTests[packet:PacketP[Object[Instrument,DensityMeter]]]:={

	(* Defined fields which should NOT be null *)
	NotNullFieldTest[packet, {
		Software,
		WettedMaterials,
		(*Density meter specific*)
		DensityAccuracy,
		TemperatureAccuracy,
		ManufacturerDensityRepeatability,
		ManufacturerTemperatureRepeatability,
		ManufacturerReproducibility
	}
	],

	(* Unique fields *)
	Test["If the Status is not retired, DensityMeter is informed:",
		Lookup[packet,{Status,DensityMeter}],
		{Retired,_}|{Except[Retired],Except[Null]}
	]

};



(* ::Subsection::Closed:: *)
(*validInstrumentDialyzerQTests*)


validInstrumentDialyzerQTests[packet:PacketP[Object[Instrument,Dialyzer]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet,
		{
			IP,
			PDU,
			Decks,
			Dongle,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentFPLCQTests*)


validInstrumentFPLCQTests[packet:PacketP[Object[Instrument,FPLC]]]:={

	NullFieldTest[packet,{
		IP,
		PDU,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}],

	NotNullFieldTest[packet,{
		Software,
		BufferDeck,
		WasteContainer
	}],


	(* logic tests *)
	Test["If populated, Decks field should contain AutosamplerDeck and WashFluidDeck:",
		Module[
			{decks,autosamplerDeck,washFluidDeck},

			{decks,autosamplerDeck,washFluidDeck} = Download[packet,{Decks[Object],AutosamplerDeck[Object],WashFluidDeck[Object]}];

			Or[
				MatchQ[{decks, autosamplerDeck, washFluidDeck}, {{}, Null, Null}],
				ContainsAll[
					decks,
					(Cases[Union[ToList[autosamplerDeck],ToList[washFluidDeck]], ObjectP[]]/. {} -> {Null})
				]
			]
		],
		True
	],

	(* AKTA must have a buffer line reservoir *)
	If[MatchQ[Lookup[packet,Model],ObjectP[Model[Instrument, FPLC, "id:jLq9jXY4kkBa"]]],
		NotNullFieldTest[packet,{BufferLineReservoir}],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentHPLCQTests*)


validInstrumentHPLCQTests[packet:PacketP[Object[Instrument,HPLC]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve
		}
	],

	(* Shared fields which should NOT be null *)

	(* Individual fields *)
	NotNullFieldTest[
		packet,
		{
			Software,
			Decks,
			Scale,
			BufferDeck,
			WasteContainer,
			BufferAInlet,
			BufferBInlet,
			BufferCInlet,
			AutomaticWasteEvacuation,
			ColumnCapRack
		}
	],

	(* Non-Dionex tests *)
	If[MatchQ[Lookup[packet,Model],Except[LinkP[{Model[Instrument, HPLC, "id:N80DNjlYwwJq"],Model[Instrument, HPLC, "id:M8n3rx098xbO"], Model[Instrument, HPLC, "id:P5ZnEjdExnnn"], Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]}]]],
		NotNullFieldTest[
			packet,
			{
				WastePump,
				BufferDInlet,
				BufferDCap,
				NeedleWashCap,
				NeedleWashSolutionInlet
			}
		],
		Nothing
	],

	(* logic tests *)
	Test[
		"If instrument scale is preparative, then AutosamplerDeck and FractionCollectorDeck must be informed:",
		Lookup[packet,{Scale, FractionCollectorDeck, AutosamplerDeck}],
		{Analytical,_,_}|{SemiPreparative|Preparative,Except[NullP], Except[NullP]}
	],
	(*if the instrument is an ELSD one, the nitrogen sensor and valve should be informed. Otherwise, both fields should be null.*)
	Test[
		"If the instrument is an ELSD one, the nitrogen sensor and valve should be informed. Otherwise, both fields should be null:",
		Lookup[packet,{Model,NitrogenValve,NitrogenPressureSensor}],
		{ObjectP[Model[Instrument, HPLC, "id:dORYzZn6p31E"]],Except[Null|{}],Except[{}|Null]}|{Except[ObjectP[Model[Instrument, HPLC, "id:dORYzZn6p31E"]]],Null,Null}
	],
	Test[
		"Decks field should contain AutosamplerDeck, BufferDeck, FractionCollectorDeck, WashBufferDeck and RearSealWashBufferDeck:",
		Module[{decks,autosamplerDeck,bufferDeck,fractionCollectorDeck,washBufferDeck,rearSealWashBufferDeck,deckslink,autosamplerDecklink,bufferDecklink,fractionCollectorDecklink,washBufferDeckLink,rearSealWashBufferDeckLink},
			{deckslink,autosamplerDecklink,bufferDecklink,fractionCollectorDecklink,washBufferDeckLink,rearSealWashBufferDeckLink}=Lookup[Download[Object[Instrument,HPLC,"id:Y0lXejGKd8Lo"]],{Decks,AutosamplerDeck,BufferDeck,FractionCollectorDeck,WashBufferDeck,RearSealWashBufferDeck}];
			decks = Download[deckslink,Object];
			{autosamplerDeck,bufferDeck,fractionCollectorDeck,washBufferDeck,rearSealWashBufferDeck} = Download[{autosamplerDecklink,bufferDecklink,fractionCollectorDecklink,washBufferDeckLink,rearSealWashBufferDeckLink},Object];
			ContainsAll[decks,(Cases[Union[ToList[autosamplerDeck], ToList[bufferDeck], ToList[fractionCollectorDeck],ToList[washBufferDeck],ToList[rearSealWashBufferDeck]], ObjectP[]]/. {} -> {Null})]
		],
		True
	],
	Test[
		"Dionex and Agilent bottle sensors must be Balluff BUS004F and carboy sensors must be UM18-212126111:",
		{
			Lookup[packet,Model],
			Download[
				Lookup[packet,{BufferABottleSensor,BufferBBottleSensor,BufferCBottleSensor,BufferDBottleSensor,BufferACarboySensor,BufferBCarboySensor,BufferCCarboySensor,BufferDCarboySensor}],
				Model[Object]
			]
		},
		Alternatives[
			{Except[LinkP[{Model[Instrument, HPLC, "id:N80DNjlYwwJq"],Model[Instrument, HPLC, "id:R8e1Pjp1md8p"], Model[Instrument, HPLC, "id:M8n3rx098xbO"], Model[Instrument, HPLC, "id:P5ZnEjdExnnn"], Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]}]],_},
			{
				LinkP[{Model[Instrument, HPLC, "id:N80DNjlYwwJq"],Model[Instrument, HPLC, "id:R8e1Pjp1md8p"], Model[Instrument, HPLC, "id:M8n3rx098xbO"], Model[Instrument, HPLC, "id:P5ZnEjdExnnn"], Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]}],
				Alternatives[
					{Model[Sensor,Volume,"id:eGakld0bbMVq"],Model[Sensor,Volume,"id:eGakld0bbMVq"],Model[Sensor,Volume,"id:eGakld0bbMVq"],Model[Sensor,Volume,"id:eGakld0bbMVq"]|Null,
					Model[Sensor,Volume,"id:54n6evKx08nL"],Model[Sensor,Volume,"id:54n6evKx08nL"],Model[Sensor,Volume,"id:54n6evKx08nL"],Model[Sensor,Volume,"id:54n6evKx08nL"]|Null},
					{Null,Null,Null,Null,Null,Null,Null,Null}
				]
			}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentSFCQTests*)


validInstrumentSFCQTests[packet:PacketP[Object[Instrument,SupercriticalFluidChromatography]]]:={

	If[MatchQ[Lookup[packet,Status],Available|Running],
		NotNullFieldTest[
			packet,
			{
				CosolventAInlet,
				CosolventBInlet,
				CosolventCInlet,
				CosolventDInlet,
				MakeupSolventInlet,
				CosolventACap,
				CosolventBCap,
				CosolventCCap,
				CosolventDCap,
				MakeupSolventCap,
				WastePump,
				WasteScale,
				WastePump,
				AutosamplerDeck,
				CosolventDeck,
				WashBufferDeck,
				CosolventABottleSensor,
				CosolventBBottleSensor,
				CosolventCBottleSensor,
				CosolventDBottleSensor,
				MakeupSolventBottleSensor,
				NitrogenValve,
				CO2PressureSensor,
				NitrogenPressureSensor
			}
		],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFlashChromatographyQTests*)


validInstrumentFlashChromatographyQTests[packet:PacketP[Object[Instrument,FlashChromatography]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			Software,
			Decks,
			BufferDeck,
			FractionCollectorDeck
		}
	],

	Test[
		"Decks field should contain BufferDeck and FractionCollectorDeck:",
		Module[{decks,bufferDeck,fractionCollectorDeck,deckslink,bufferDecklink,fractionCollectorDecklink},
			{deckslink,bufferDecklink,fractionCollectorDecklink}=Lookup[packet,{Decks,BufferDeck,FractionCollectorDeck}];
			decks = Download[deckslink,Object];
			{bufferDeck,fractionCollectorDeck} = Download[Flatten[{bufferDecklink,fractionCollectorDecklink}],Object];
			ContainsAll[decks,(Cases[Union[ToList[bufferDeck], ToList[fractionCollectorDeck]], ObjectP[]]/. {} -> {Null})]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFluorescenceActivatedCellSorterQTests*)


validInstrumentFluorescenceActivatedCellSorterQTests[packet:PacketP[Object[Instrument,FluorescenceActivatedCellSorter]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentCapillaryELISAQTests*)


validInstrumentCapillaryELISAQTests[packet:PacketP[Object[Instrument,CapillaryELISA]]]:={

	(* Shared fields shaping *)
	NullFieldTest[
		packet,
		{
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			PDU,
			Decks
		}
	],

	NotNullFieldTest[
		packet,
		{
			Software,
			IP
		}
	],

	(* Special fields that should not be Null *)
	NotNullFieldTest[
		packet,
		{
			BarcodeReader,
			TestCartridge,
			MovementLockPosition
		}
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentCellThawQTests*)


validInstrumentCellThawQTests[packet:PacketP[Object[Instrument,CellThaw]]]:={
	(* Shared fields shaping *)
	NullFieldTest[
		packet,
		{
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentControlledRateFreezerQTests*)


validInstrumentControlledRateFreezerQTests[packet:PacketP[Object[Instrument,ControlledRateFreezer]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet,{
		WasteContainer,
		ArgonPressureSensor,
		CO2PressureSensor,
		NitrogenPressureSensor,
		ArgonValve,
		NitrogenValve
	}],

	NotNullFieldTest[packet,{
		DataFilePath,
		MinTemperature,
		MinCoolingRate,
		MaxCoolingRate
	}]
};


(* ::Subsection:: *)
(*validInstrumentCoulterCounterQTests*)


validInstrumentCoulterCounterQTests[packet:PacketP[Object[Instrument,CoulterCounter]]]:={

	(* fields that should not be Null *)
	NotNullFieldTest[packet,{

		(* Unique fields *)
		ElectrolyteSolutionContainer,
		ParticleTrapContainer,
		InternalWasteContainer,
		WasteContainer

	}],

	(* fields that should be null *)
	NullFieldTest[packet,{
		CO2Valve,
		NitrogenValve,
		ArgonValve,
		HeliumValve,
		ArgonPressureSensor,
		ArgonPressureRegulators,
		CO2PressureSensor,
		CO2PressureRegulators,
		HeliumPressureSensor,
		HeliumPressureRegulators,
		NitrogenPressureSensor,
		NitrogenPressureRegulators
	}],

	(* ApertureTube should be disconnected from the instrument when it is not running or undergoing maintenance *)
	Test[
		"Aperture tube should be disconnected from the instrument when the instrument is not actively running experiments or qualifications or undergoing maintenance.",
		MatchQ[Lookup[packet,{Status,ApertureTube}],Alternatives[
			{Running,Except[NullP|{}]}, (* running - should have a ApertureTube installed *)
			{Available|Retired,NullP|{}}, (* available or retired - should not have ApertureTube installed *)
			{UndergoingMaintenance,_} (* UndergoingMaintenance can either have ApertureTube installed or not installed, either is fine*)
		]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentCryogenicFreezerQTests*)


validInstrumentCryogenicFreezerQTests[packet:PacketP[Object[Instrument,CryogenicFreezer]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Fields to be filled out*)
	NotNullFieldTest[packet,
		{
			HighTemperatureAlarm
		}
	],

	(* Alarm comparisons *)
	FieldComparisonTest[packet,{LowLevelAlarm,HighLevelAlarm},Less],

	Test["ProvidedStorageCondition is informed if status is not retired:",
		Lookup[packet,{Status,ProvidedStorageCondition}],
		{Except[Retired],Except[Null]}|{Retired,_}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDarkroomQTests*)


validInstrumentDarkroomQTests[packet:PacketP[Object[Instrument,Darkroom]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	NotNullFieldTest[
		packet,
		{
			DataFilePath,
			Software
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentDehydratorQTests*)


validInstrumentDehydratorQTests[packet:PacketP[Object[Instrument,Dehydrator]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			WasteContainer
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDesiccatorQTests*)


validInstrumentDesiccatorQTests[packet:PacketP[Object[Instrument,Desiccator]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],
	NotNullFieldTest[packet, {Desiccant, SampleType, DrierDeck}],

	(* tests for the Vacuum pump *)
	Test[
		"If Vacuumable is True, VacuumPump must be informed:",
		If[
			TrueQ[Lookup[packet,Vacuumable]],
			!NullQ[Lookup[packet,VacuumPump]],
			True
		],
		True
	],

	(*Requirements when SampleType is set to Closed:*)

	(* test for ProvidedStorageCondition *)
	Test["ProvidedStorageCondition is informed if status is not retired and SampleType is Closed:",
		If[
			And[
				MatchQ[Lookup[packet,SampleType],Closed],
				MatchQ[Lookup[packet,Status],Except[Retired]]
			],
			!MatchQ[Lookup[packet,ProvidedStorageCondition],NullP|{}],
			True
		],
		True
	],

	Test["if SampleType is set to Closed, Desiccant must be informed:",
		If[MatchQ[Lookup[packet,SampleType],Closed],
			!MatchQ[Lookup[packet,Desiccant],NullP|{}],
			True
		],
		True
	],

	(*Requirements when SampleType is set to Open:*)
	Test["if SampleType is set to Open, Cameras must be informed:",
		If[
			MatchQ[Lookup[packet,SampleType],Open],
			!MatchQ[Lookup[packet,Cameras],NullP|{}],
			True
		],
		True
	],

	Test["if SampleType is set to Open, PressureSensor must be informed:",
		If[
			MatchQ[Lookup[packet,SampleType],Open],
			!MatchQ[Lookup[packet,PressureSensor],NullP|{}],
			True
		],
		True
	],

	Test["if SampleType is set to Open, SampleDeck must be informed:",
		If[
			MatchQ[Lookup[packet,SampleType],Open],
			!MatchQ[Lookup[packet,SampleDeck],NullP|{}],
			True
		],
		True
	],

	Test["if SampleType is set to Open, Lid must be informed:",
		If[
			MatchQ[Lookup[packet,SampleType],Open],
			!MatchQ[Lookup[packet,Lid],NullP|{}],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDiffractometerQTests*)


validInstrumentDiffractometerQTests[packet:PacketP[Object[Instrument,Diffractometer]]]:={
	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			SystemInterfaceVersion,
			InstrumentSoftware
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDishwasherQTests*)


validInstrumentDishwasherQTests[packet:PacketP[Object[Instrument,Dishwasher]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			WasteContainer
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDispenserQTests*)


validInstrumentDispenserQTests[packet:PacketP[Object[Instrument,Dispenser]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			WasteContainer
		}
	],

	Test["If the Reservoir Slot exists in the model positions, then Reservoir must be populated:",
		With[{positionNames = Lookup[Download[Lookup[packet, Model], Positions], Name, {}]},
			If[MemberQ[positionNames, "Reservoir Slot"],
				Not[NullQ[Lookup[packet, Reservoir]]],
				True
			]
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentDissolvedOxygenMeterQTests*)


validInstrumentDissolvedOxygenMeterQTests[packet:PacketP[Object[Instrument,DissolvedOxygenMeter]]]:={
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			WasteContainer
		}
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentDNASynthesizerQTests*)


validInstrumentDNASynthesizerQTests[packet:PacketP[Object[Instrument,DNASynthesizer]]]:=Join[
	{
		(* Shared field shaping *)
		NullFieldTest[
			packet,
			{
				IP,
				PDU,
				CO2PressureSensor,
				NitrogenPressureSensor,
				NitrogenValve
			}
		],

		NotNullFieldTest[
			packet,
			{
				Decks,
				Software,
				WasteContainer,
				ArgonPressureSensor,
				ArgonValve,
				PlaceholderBottles
			}
		],

		(* Unique Fields *)
		(* Sensible Max/Min Checks*)
		RequiredTogetherTest[packet,{MinSlopes,MaxSlopes}],
		RequiredTogetherTest[packet,{MinIntercepts,MaxIntercepts}]
	},

	Map[
		Test[
			StringJoin["The minimum slope of ", #," Banks 1 and 3 must be less than the maximum slope of the same valve.:"],
			(Last[FirstCase[Lookup[packet,MinSlopes], {#, "Banks 1 and 3", _}]]) < (Last[FirstCase[Lookup[packet,MaxSlopes], {#, "Banks 1 and 3", _}]]),
			True
		]&,
		{"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash",
			"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash"}
	],

	Map[
		Test[
			StringJoin["The minimum slope of ", #," Banks 2 and 4 must be less than the maximum slope of the same valve.:"],
			(Last[FirstCase[Lookup[packet,MinSlopes], {#, "Banks 2 and 4", _}]]) < (Last[FirstCase[Lookup[packet,MaxSlopes], {#, "Banks 2 and 4", _}]]),
			True
		]&,
		{"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash",
			"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash"}
	],

	Map[
		Test[
			StringJoin["The minimum intercept of ", #," Banks 2 and 4 must be less than the maximum intercept of the same valve.:"],
			(Last[FirstCase[Lookup[packet,MinIntercepts], {#,"Banks 2 and 4", _}]]) < (Last[FirstCase[Lookup[packet,MaxIntercepts], {#, "Banks 2 and 4", _}]]),
			True]&,
		{"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash",
			"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash"}
	],

	Map[
		Test[
			StringJoin["The minimum intercept of ", #," Banks 1 and 3 must be less than the maximum intercept of the same valve.:"],
			(Last[FirstCase[Lookup[packet,MinIntercepts], {#, "Banks 1 and 3", _}]]) < (Last[FirstCase[Lookup[packet,MaxIntercepts], {#, "Banks 1 and 3", _}]]),
			True
		]&,
		{"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash",
			"Deblock", "Oxidizer", "CapA", "CapB", "ACN1", "A", "G", "Activator", "C", "T", "ACN2", "5", "6", "7", "ActivatorWash"}
	]
];


(* ::Subsection::Closed:: *)
(*validInstrumentDifferentialScanningCalorimeterQTests*)


validInstrumentDifferentialScanningCalorimeterQTests[packet:PacketP[Object[Instrument,DifferentialScanningCalorimeter]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor
		}
	],

	NotNullFieldTest[
		packet,
		{
			Decks,
			Software,
			WasteContainer,
			NitrogenValve,
			NitrogenPressureSensor
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentElectrophoresisQTests*)


validInstrumentElectrophoresisQTests[packet:PacketP[Object[Instrument,Electrophoresis]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Software,
			Decks,
			WasteContainer
		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentFragmentAnalyzerQTests*)


validInstrumentFragmentAnalyzerQTests[packet:PacketP[Object[Instrument,FragmentAnalyzer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Software,
			WasteContainer,
			ConditioningLinePlaceholderContainer,
			PrimaryGelLinePlaceholderContainer,
			SecondaryGelLinePlaceholderContainer,
			ConditioningLineCap,
			PrimaryGelLineCap,
			SecondaryGelLineCap,
			WasteLineCap
		}
	]
};





(* ::Subsection::Closed:: *)
(*validInstrumentEnvironmentalChamberQTests*)


validInstrumentEnvironmentalChamberQTests[packet:PacketP[Object[Instrument,EnvironmentalChamber]]]:={
		
	NotNullFieldTest[
		packet,
		{
			ProvidedStorageCondition
		}
	],
	
	Test["ProvidedStorageCondition is informed if status is not retired:",
		Lookup[packet,{Status,ProvidedStorageCondition}],
		{Except[Retired],Except[Null]}|{Retired,_}
	]
	
};


(* ::Subsection::Closed:: *)
(*validInstrumentCondensateRecirculatorQTests*)


validInstrumentCondensateRecirculatorQTests[packet:PacketP[Object[Instrument,CondensateRecirculator]]]:={

	NotNullFieldTest[
		packet,
		{
			Status
		}
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentEvaporatorQTests*)


validInstrumentEvaporatorQTests[packet:PacketP[Object[Instrument,Evaporator]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve
		}
	],

	NotNullFieldTest[
		packet,
		{PDU}
	],

	(* All computer information should be informed if any is *)
	RequiredTogetherTest[packet,{Software,DataFilePath}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFilterBlockQTests*)


validInstrumentFilterBlockQTests[packet:PacketP[Object[Instrument,FilterBlock]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFilterHousingQTests*)


validInstrumentFilterHousingQTests[packet:PacketP[Object[Instrument,FilterHousing]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFlowCytometerQTests*)


validInstrumentFlowCytometerQTests[packet:PacketP[Object[Instrument,FlowCytometer]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			PDU,
			Decks,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFreezerQTests*)


validInstrumentFreezerQTests[packet:PacketP[Object[Instrument,Freezer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Fields to be filled out *)
	NotNullFieldTest[
		packet,
		{
			Temperature
		}
	],

	Test["ProvidedStorageCondition is informed if status is not retired:",
		Lookup[packet,{Status,ProvidedStorageCondition}],
		{Except[Retired],Except[Null]}|{Retired,_}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPortableCoolerQTests*)


validInstrumentPortableCoolerQTests[packet:PacketP[Object[Instrument,PortableCooler]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	If[
		MatchQ[Lookup[packet, Model], ObjectP[Model[Instrument, PortableCooler, "Brooks CryoPod Portable Cryogenic Freezer"]]],

		(* tests for portable cryogenic freezers *)
		{
			(* Fields to be filled out*)
			NotNullFieldTest[packet,
				{
					HighTemperatureAlarm
				}
			],

			(* Alarm comparisons *)
			FieldComparisonTest[packet, {LowLevelAlarm, HighLevelAlarm}, Less],
			Test["ProvidedStorageCondition is informed if status is not retired:",
				Lookup[packet, {Status, ProvidedStorageCondition}],
				{Except[Retired], Except[Null]} | {Retired, _}
			]
		},

		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPortableHeaterQTests*)


validInstrumentPortableHeaterQTests[packet:PacketP[Object[Instrument,PortableHeater]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentFumeHoodQTests*)


validInstrumentFumeHoodQTests[packet:PacketP[Object[Instrument,FumeHood]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			CO2PressureSensor
		}
	],

	NotNullFieldTest[packet,{
		NitrogenPressureSensor
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentHandlingStationFumeHoodQTests*)


validInstrumentHandlingStationFumeHoodQTests[packet:PacketP[Object[Instrument,HandlingStation,FumeHood]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			CO2PressureSensor
		}
	],

	NotNullFieldTest[packet,{
		NitrogenPressureSensor
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentGelBoxQTests*)


validInstrumentGelBoxQTests[packet:PacketP[Object[Instrument,GelBox]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentGasGeneratorQTests*)


(* TODO: IMPROVE *)
validInstrumentGasGeneratorQTests[packet:PacketP[Object[Instrument,GasGenerator]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
		DeliveryPressure,
		GasGenerated
	}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentGasChromatographQTests*)


validInstrumentGasChromatographQTests[packet:PacketP[Object[Instrument,GasChromatograph]]]:={
	(* Shared fields that are not available on GC objects *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			Decks,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve
		}
	],
	(* If the instrument status is Available (or technically, running) *)
	If[MatchQ[Lookup[packet,Status],Available|Running],
		NotNullFieldTest[
			packet,
			{
				Detectors,
				CarrierGases,
				Inlets,
				ColumnOvenSize,(*
				ColumnInletConnectors,
				ColumnOutletConnectors,*)
				MaxInletPressure,
				MaxNumberOfColumns,
				MinColumnOvenTemperature,
				MaxColumnOvenTemperature,
				MaxColumnCageDiameter
				(*NitrogenValve,
				NitrogenPressureSensor,
				HeliumTankPressureSensor,
				HeliumDeliveryPressureSensor,*)
			}
		],
		Nothing
	],
	FieldComparisonTest[packet,{MinColumnOvenTemperature,MaxColumnOvenTemperature},Less]

};


(* ::Subsection::Closed:: *)
(*validInstrumentGasFlowSwitchQTests*)


validInstrumentGasFlowSwitchQTests[packet:PacketP[Object[Instrument,GasFlowSwitch]]]:={

	(* Shared fields which should be NOT be null *)
	NotNullFieldTest[
		packet,
		{
			IP,
			RightCylinder,
			LeftCylinder,
			TurnsToOpen
		}
	],

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentGravityRackQTests*)
validInstrumentGravityRackQTests[packet:PacketP[Object[Instrument,GravityRack]]]:={
	NotNullFieldTest[
		packet,
		{
			CollectionRackAttached,
			Platforms,
			Positions,
			Dimensions,
			WettedMaterials
		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentHandlingStationQTests*)


validInstrumentHandlingStationQTests[packet:PacketP[Object[Instrument,HandlingStation]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentHandlingStationAmbientQTests*)


validInstrumentHandlingStationAmbientQTests[packet:PacketP[Object[Instrument,HandlingStation,Ambient]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentInfraredProbeQTests*)


validInstrumentInfraredProbeQTests[packet:PacketP[Object[Instrument,InfraredProbe]]]:={};

(* ::Subsection::Closed:: *)
(*validInstrumentKarlFischerTitratorQTests*)

validInstrumentKarlFischerTitratorQTests[packet:PacketP[Object[Instrument, KarlFischerTitrator]]]:={
	(* Individual fields *)
	NotNullFieldTest[
		packet,
		{
			MediumCap,
			WasteContainerCap,
			MediumWeightSensor,
			StirBarRetriever,
			ContainerDisconnectionSlot
		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentIonChromatographyQTests*)


validInstrumentIonChromatographyQTests[packet:PacketP[Object[Instrument,IonChromatography]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve
		}
	],

	(* Shared fields which should NOT be null *)

	(* Individual fields *)
	NotNullFieldTest[
		packet,
		{
			Software,
			Decks,
			BufferDeck,
			WasteContainer,
			BufferAInlet,
			BufferBInlet,
			BufferCInlet,
			BufferDInlet,
			NeedleWashSolutionInlet
		}
	],

	If[MatchQ[packet[AnalysisChannels],Except[Null|{}]],
		NotNullFieldTest[
			AnionDetector,
			CationDetector,
			EluentGeneratorInletSolutionInlet
		],
		Nothing
	],

	If[MemberQ[packet[Detectors],UVVis],
		NotNullFieldTest[packet,{
			DetectorLampType,
			MinAbsorbanceWavelength,
			MaxAbsorbanceWavelength,
			AbsorbanceWavelengthBandpass
		}],
		Nothing
	],

	If[MemberQ[packet[Detectors],ElectrochemicalDetector],
		NotNullFieldTest[packet,{
			ElectrochemicalDetectionMode,
			ReferenceElectrode,
			MinDetectionTemperature,
			MaxDetectionTemperature,
			MinDetectionVoltage,
			MaxDetectionVoltage,
			MinFlowCellpH,
			MaxFlowCellpH
		}],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentGeneticAnalyzerQTests*)


validInstrumentGeneticAnalyzerQTests[packet:PacketP[Object[Instrument,GeneticAnalyzer]]]:={

	(* Shared fields shaping *)
	NullFieldTest[
		packet,
		{
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			PDU,
			Decks
		}
	],

	NotNullFieldTest[
		packet,
		{
			Software,
			IP,
			InstrumentPIN
		}
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentGrinderQTests*)


validInstrumentGrinderQTests[packet:PacketP[Object[Instrument,Grinder]]]:={

	NotNullFieldTest[packet,
		{
			Container,
			Positions,
			GrinderType,
			GrindingMaterial
		}
	],


	NullFieldTest[
		packet,
		{
			Decks,
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	Test["If GrinderType is set to MortarGrinder, Cameras must be informed:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,Cameras],NullP|{}],
			True
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentLiquidHandlerQTests*)


validInstrumentLiquidHandlerQTests[packet:PacketP[Object[Instrument,LiquidHandler]]]:=Module[{manufacturer},
	manufacturer = First@ToList@Download[Lookup[packet,{Model}], Manufacturer];
	{
	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Software
		}
	],

	NullFieldTest[
		packet,
		{
			ArgonPressureSensor,
			ArgonValve,
			CO2PressureSensor
		}
	],

	(* Exclude tests that do not apply to AcousticLiquidHandler subtype *)
	Sequence@@If[MatchQ[packet, ObjectP[Object[Instrument, LiquidHandler, AcousticLiquidHandler]]],

		Nothing,

		{
			(* tests for Hamiltons fields *)
			Test[
				"If the TipType of the instrument is DisposableTip, LogFilePath must informed:",
				If[(Lookup[packet,TipType])=== DisposableTip,
					!NullQ[Lookup[packet,LogFilePath]],
					True
				],
				True
			],

			Test["If the instrument is a Hamilton, must have MethodFilePath and DataFilePath populated either in the object or in the model:",
				If[MatchQ[manufacturer, ObjectP[Object[Company, Supplier, "id:vXl9j5qErxNJ"]]],
					Or[
						!NullQ[Lookup[packet, MethodFilePath]] && !NullQ[Lookup[packet, DataFilePath]],
						!NullQ[Download[Lookup[packet, Model], DefaultMethodFilePath]] && !NullQ[Download[Lookup[packet, Model], DefaultDataFilePath]]
					],
					True
				],
				True
			],

			Test["If the instrument is a Hamilton, the Model of the Deck must match the Model of the Deck in the Instrument Model:",
				If[MatchQ[manufacturer, ObjectP[Object[Company, Supplier, "id:vXl9j5qErxNJ"]]],
					MatchQ[
						Download[Lookup[packet,Decks][[1]],Model[Object]],
						Download[Lookup[packet,Model],Deck[Object]]
					],
					True
				],
				True
			],

			Test["All individual integrated instruments are populated in the IntegratedInstruments field:",
				SubsetQ[
					Download[Lookup[packet,IntegratedInstruments],Object],
					DeleteDuplicates@DeleteCases[
						Download[
							Flatten[
								Lookup[
									packet,
									{
										IntegratedCentrifuge, IntegratedIncubator, IntegratedPressureManifold,
										IntegratedShakers, IntegratedHeatBlocks, IntegratedPlateTilters,
										IntegratedPlateSealer, IntegratedThermocyclers, IntegratedMicroscopes,
										IntegratedPlateReader, IntegratedNephelometer, IntegratedPlateWasher,
										IntegratedExternalRobotArm
									}
								]
							],
							Object
						],
						Null|{}
					]
				],
				True
			],

			Test["Models of the IntegratedInstruments match what is populated in the current instrument Model:",
				With[{
					modelIntegratedInstruments=Download[Lookup[packet,Model],IntegratedInstruments[Object]],
					integratedInstrumentModels=Download[Lookup[packet,IntegratedInstruments],Model[Object]]
				},
					(* integrated instruments of the object must be populated, otherwise we don't care *)
					Or[
						MatchQ[Lookup[packet,IntegratedInstruments],Null|{}],
						And[
							!MatchQ[modelIntegratedInstruments,Null],
							(* both length and the count of each model have to match *)
							Length[modelIntegratedInstruments]==Length[integratedInstrumentModels],
							MatchQ[Sort@modelIntegratedInstruments,Sort@integratedInstrumentModels]
						]
					]
				],
				True
			],


			(* tests for all Gilson fields *)
			Test["If the TipType of the instrument is FixedTip or Scale is MacroLiquidHandler, NitrogenValve must be informed:",
				Lookup[packet,{TipType,Scale, Status,NitrogenValve}],
				Alternatives[
					{DisposableTip,MicroLiquidHandling,_,_},
					{FixedTip,MicroLiquidHandling,Except[(Retired|UndergoingMaintenance)],Except[Null]},
					{FixedTip,MicroLiquidHandling,(Retired|UndergoingMaintenance),_},
					{Null,MacroLiquidHandling,_,Except[Null]}
				]
			],

			Test["If the TipType of the instrument is FixedTip, NitrogenPressureSensor must be informed (not informed otherwise):",
				Lookup[packet,{TipType,Scale,Status,NitrogenPressureSensor}],
				{DisposableTip,MicroLiquidHandling,_,NullP}|{FixedTip,MicroLiquidHandling,Except[(Retired|UndergoingMaintenance)],Except[Null]}|{FixedTip,MicroLiquidHandling,(Retired|UndergoingMaintenance),_}|{Null,MacroLiquidHandling,_,Except[Null]}

			],

			(* tests for Gilson that are solid phase extractor *)
			Test[
				"If the solid phase extractor, WashLineVessel must be informed:",
				If[MemberQ[{Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"]},Lookup[packet,Model][Object]],
					!NullQ[Lookup[packet,WashLineVessel]],
					True
				],
				True
			],

			(* Test for Macro liquid handlers *)
			Test[
				"If the scale of the instrument is Macro, EmbeddedPC must be informed (Null otherwise):",
				Module[{scale,embeddedPC},
					{scale,embeddedPC}=Lookup[packet,{Scale,EmbeddedPC}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],

			Test[
				"If the scale of the instrument is Macro, MediumCylinderSensorArrayAddress and LargeCylinderSensorArrayAddress must be populated:",
				Lookup[packet,{Scale,MediumCylinderSensorArrayAddress,LargeCylinderSensorArrayAddress}],
				{MacroLiquidHandling,Except[Null],Except[Null]}|{MicroLiquidHandling,Null,Null}
			],

			Test[
				"If the scale of the instrument is Macro, AqueousWashSolutionScale must be informed (Null otherwise):",
				Module[{scale,aqueousWashSolutionScale},
					{scale,aqueousWashSolutionScale}=Lookup[packet,{Scale,AqueousWashSolutionScale}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],

			Test[
				"If the scale of the instrument is Macro, OrganicWashSolutionScale must be informed (Null otherwise):",
				Module[{scale,organicWashSolutionScale},
					{scale,organicWashSolutionScale}=Lookup[packet,{Scale,OrganicWashSolutionScale}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],

			Test[
				"If informed, all members of the OffDeckHeaterShakers of Hamilton must be in IntegratedShakers as well:",
				Or[
					MatchQ[Lookup[packet,OffDeckHeaterShakers],{}|Null],
					EqualQ[
						Length[Intersection[Download[Lookup[packet,OffDeckHeaterShakers],Object],Download[Lookup[packet,IntegratedShakers],Object]]],
						Length[Lookup[packet,OffDeckHeaterShakers]]
					]
				],
				True
			],

			Test["Hamilton robotic liquid handlers should have TopLight and VideoCaptureComputer informed:",
				If[MatchQ[manufacturer,ObjectP[Object[Company,Supplier,"id:vXl9j5qErxNJ"]]],
					And[
						!NullQ[Lookup[packet,TopLight]],
						!NullQ[Lookup[packet,VideoCaptureComputer]]
					],
					True
				],
				True
			]
		}
	]
}
	];



(* ::Subsection::Closed:: *)
(*validInstrumentLyophilizerQTests*)


validInstrumentLyophilizerQTests[packet:PacketP[Object[Instrument,Lyophilizer]]]:=Module[
	{shelfHeight, modelMaxShelfHeight,modelMinShelfHeight},

	shelfHeight = Lookup[packet, ShelfHeight];

	{modelMaxShelfHeight,modelMinShelfHeight} = Download[Lookup[packet,Model],{MaxShelfHeight,MinShelfHeight}];

	{
		(* Shared fields which should NOT be null *)
		NotNullFieldTest[
			packet,
			{
				NitrogenValve,
				DeckLayout,
				ShelfHeight,
				Software,
				DataFilePath,
				ShelfHeight,
				VacuumPump
			}
		],

		NullFieldTest[
			packet,
			{
				ArgonPressureSensor,
				ArgonValve,
				CO2Valve,
				CO2PressureSensor,
				WasteScale,
				IP,
				MethodFilePath
			}
		],

		Test["The ShelfHeight of the instrument is not greater than the MaxShelfHeight of the Model:",
			Or[NullQ[shelfHeight], NullQ[modelMaxShelfHeight], !Greater[Lookup[packet, ShelfHeight],modelMaxShelfHeight]],
			True
		],

		Test["The ShelfHeight of the instrument is not less than the MinShelfHeight of the Model:",
			Or[NullQ[shelfHeight], NullQ[modelMinShelfHeight], !Less[Lookup[packet, ShelfHeight],modelMinShelfHeight]],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validInstrumentHeatBlockQTests*)


validInstrumentHeatBlockQTests[packet:PacketP[Object[Instrument,HeatBlock]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentHeatExchangerQTests*)


validInstrumentHeatExchangerQTests[packet:PacketP[Object[Instrument,HeatExchanger]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Fields which should not be null *)
	NotNullFieldTest[packet,IntegratedInstrument]
};


(* ::Subsection::Closed:: *)
(*validInstrumentIncubatorQTests*)


validInstrumentIncubatorQTests[packet:PacketP[Object[Instrument,Incubator]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Decks,NominalCellType,Temperature}],

	Test["Integrations should NOT be null if the incubator uses robotic access. Integrations should be null if the incubator uses manual access:",
		(MatchQ[Lookup[packet,Mode],Robotic] && !NullQ[Lookup[packet,IntegratedLiquidHandler]]) || (MatchQ[Lookup[packet,Mode],Manual] && NullQ[Lookup[packet,IntegratedLiquidHandler]]),
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentLightMeterQTests*)


validInstrumentLightMeterQTests[packet:PacketP[Object[Instrument,LightMeter]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentLiquidLevelDetectorQTests*)


validInstrumentLiquidLevelDetectorQTests[packet:PacketP[Object[Instrument,LiquidLevelDetector]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentLiquidParticleCounterQTests*)


validInstrumentLiquidParticleCounterQTests[packet:PacketP[Object[Instrument,LiquidParticleCounter]]]:={
	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			SamplingProbe,
			Syringe,
			ProbeStorageContainer
		}
	],

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentLiquidNitrogenDoserQTests*)


validInstrumentLiquidNitrogenDoserQTests[packet:PacketP[Object[Instrument,LiquidNitrogenDoser]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentMassSpectrometerQTests*)


validInstrumentMassSpectrometerQTests[packet:PacketP[Object[Instrument,MassSpectrometer]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			CO2PressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Software
		}
	],

	If[
		And[MatchQ[Lookup[packet,MassAnalyzer],TOF], MatchQ[Lookup[packet,IonSources], {MALDI}],MatchQ[Lookup[packet,Status], Except[Retired]]],
		Test["For Microflex MALDI-TOF instrument, if the status is not retired, the InstrumentSettingsTemplate need to be specified for compleMassSpectrometry:",
			Not[NullQ[Lookup[packet,InstrumentSettingsTemplate]]],
			True
		],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentMeltingPointApparatusQTests*)

validInstrumentMeltingPointApparatusQTests[packet:PacketP[Object[Instrument,MeltingPointApparatus]]]:={



	NotNullFieldTest[packet,
		{
			(* Shared fields which should not be null *)
			OperatingSystem,
			Software,
			ComputerIP,
			Container,

			(* Specific fields which should not be null *)

			MinTemperature,
			MaxTemperature,
			TemperatureResolution,
			MinTemperatureRampRate,
			MaxTemperatureRampRate
		}
	],

	(* Shared fields which should be null *)
	NullFieldTest[packet,
		{
			PDU,
			Decks,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, Less],

	FieldComparisonTest[packet, {MinTemperatureRampRate, MaxTemperatureRampRate}, LessEqual]

};


(* ::Subsection::Closed:: *)
(*validInstrumentMicroscopeQTests*)


validInstrumentMicroscopeQTests[packet:PacketP[Object[Instrument,Microscope]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentMicroscopeProbeQTests*)


validInstrumentMicroscopeProbeQTests[packet:PacketP[Object[Instrument,MicroscopeProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentMicrowaveQTests*)


validInstrumentMicrowaveQTests[packet:PacketP[Object[Instrument,Microwave]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			PDU,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(*Individual fields*)
	NotNullFieldTest[
		packet,
		{
			Rotating
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentMicrowaveReactorQTests*)


validInstrumentReactorMicrowaveQTests[packet:PacketP[Object[Instrument,Reactor, Microwave]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			WasteContainer
		}
	],

	NotNullFieldTest[
		packet,
		{
			MethodFilePath,
			DataFilePath,
			Software
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentNMRQTests*)


validInstrumentNMRQTests[packet:PacketP[Object[Instrument,NMR]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[
		packet,
		{
			NitrogenPressureSensor
		}
	],

	(* non-shared fields that should not be null *)
	NotNullFieldTest[
		packet,
		{
			SystemDefaultProbe
		}
	],

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			DataFilePath,
			MethodFilePath,
			PDU,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentOvenQTests*)


validInstrumentOvenQTests[packet:PacketP[Object[Instrument,Oven]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			MinTemperature,
			MaxTemperature

		}
	],

	(*Individual fields*)
	NotNullFieldTest[
		packet,
		{

		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentHotPlateQTests*)


validInstrumentHotPlateQTests[packet:PacketP[Object[Instrument, HotPlate]]]:= {
	FieldComparisonTest[packet, {MaxTemperature, NominalTemperature, MaxTemperature}, GreaterEqual];
};


(* ::Subsection::Closed:: *)
(*validInstrumentOverheadStirrerQTests*)


validInstrumentOverheadStirrerQTests[packet:PacketP[Object[Instrument, OverheadStirrer]]]:={
	NotNullFieldTest[
		packet,
		{
			CompatibleImpellers,
			MinRotationRate,
			MaxRotationRate
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPackingDeviceQTests*)

validInstrumentPackingDeviceQTests[packet:PacketP[Object[Instrument,PackingDevice]]]:={

	NotNullFieldTest[packet,
		{
			Container,
			Cameras,
			NumberOfCapillaries,
			PDU
		}
	],


	NullFieldTest[packet,
		{
			Decks,
			IP,
			ComputerIP,
			DataFilePath,
			MethodFilePath,
			Software,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentParticleSizeProbeQTests*)


validInstrumentParticleSizeProbeQTests[packet:PacketP[Object[Instrument,ParticleSizeProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentPeptideSynthesizerQTests*)


validInstrumentPeptideSynthesizerQTests[packet:PacketP[Object[Instrument,PeptideSynthesizer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			DataFilePath,
			PDU,
			ArgonPressureSensor,
			ArgonValve,
			CO2PressureSensor
		}
	],

	NotNullFieldTest[
		packet,{
		IP,
		Decks,
		WasteContainer,
		SecondaryWasteContainer,
		NitrogenPressureSensor,
		NitrogenValve,
		BufferDeck,
		SynthesisDeck
	}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPeristalticPumpQTests*)


validInstrumentPeristalticPumpQTests[packet:PacketP[Object[Instrument,PeristalticPump]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],
	NotNullFieldTest[
		packet,
		{OperationalSpeed}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPressureManifoldQTests*)


validInstrumentPressureManifoldQTests[packet:PacketP[Object[Instrument,PressureManifold]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentPlatePourerQTests*)


validInstrumentPlatePourerQTests[packet:PacketP[Object[Instrument,PlatePourer]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentPipetteQTests*)


validInstrumentPipetteQTests[packet:PacketP[Object[Instrument,Pipette]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			PDU,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	Test["If the pipette's Status is not Retired, it must have the StoragePositions populated, so that it can be returned to where it was if used elsewhere:",
		If[MatchQ[Lookup[packet,Status], Except[Retired]],
			MatchQ[Lookup[packet,StoragePositions][[All,1]], {ObjectP[]..}],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPlateImagerQTests*)


validInstrumentPlateImagerQTests[packet:PacketP[Object[Instrument,PlateImager]]]:={
	(* Shared fields - Null *)
	NullFieldTest[
		packet,
		{
			IP,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields - Not Null *)
	NotNullFieldTest[
		packet,
		{
			Decks,
			PDU,
			Software,
			RulerOffsets,
			StartPointOffsets
		}
	],

	(* Software must match PlateImagerSoftwareP *)
	Test["Software must match any of the following "<>ToString[List@@PlateImagerSoftwareP]<>":",
		MatchQ[Lookup[packet,Software],PlateImagerSoftwareP],
		True
	]
};


(* ::Subsection:: *)
(*validInstrumentNephelometerQTests*)


validInstrumentNephelometerQTests[packet:PacketP[Object[Instrument, Nephelometer]]] := {
	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			Software
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentPlateReaderQTests*)


validInstrumentPlateReaderQTests[packet:PacketP[Object[Instrument,PlateReader]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[
		packet,
		{
			Software
		}
	],

	NullFieldTest[
		packet,
		{
			ArgonPressureSensor,
			ArgonValve
		}
	],

	Test["If the instrument is a BMG instrument, must have MethodFilePath and DataFilePath populated:",
		If[MatchQ[Download[Lookup[packet,{Model}], Manufacturer], ObjectP[Object[Company, Supplier, "id:n0k9mGzREWm6"]]],
			Not[NullQ[Lookup[packet, MethodFilePath]]] && Not[NullQ[Lookup[packet, DataFilePath]]],
			True
		],
		True
	],

	If[MatchQ[Lookup[packet,Model],ObjectP[Model[Instrument, PlateReader, "Ekko"]]],
		NotNullFieldTest[packet,{
			NitrogenValve,
			PDU
		}],
		Nothing
	]


};



(* ::Subsection::Closed:: *)
(*validInstrumentPlateTilterQTests*)


validInstrumentPlateTilterQTests[packet:PacketP[Object[Instrument,PlateTilter]]]:={};




(* ::Subsection::Closed:: *)
(*validInstrumentShakerQTests*)


validInstrumentPlateWasherQTests[packet:PacketP[Object[Instrument,PlateWasher]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	NotNullFieldTest[
		packet,
		{
			WasteContainer,
			BufferAInlet
		}
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentPowerSupplyQTests*)


validInstrumentPowerSupplyQTests[packet:PacketP[Object[Instrument,PowerSupply]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentPurgeBoxQTests*)


validInstrumentPurgeBoxQTests[packet:PacketP[Object[Instrument,PurgeBox]]]:={};



(* ::Subsection::Closed:: *)
(*validInstrumentRamanProbeQTests*)


validInstrumentRamanProbeQTests[packet:PacketP[Object[Instrument,RamanProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentRamanSpectrometerQTests*)


validInstrumentRamanSpectrometerQTests[packet:PacketP[Object[Instrument,RamanSpectrometer]]]:={

	(* Shared fields which should be null *)
		NullFieldTest[
		packet,
		{
			IP,
			WasteScale,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields to be filled out *)
		NotNullFieldTest[
		packet,
		{
			Cost,
			SerialNumbers,
			DataFilePath,
			MethodFilePath,
			Software
		}
	],

	(* unique fields *)
	NotNullFieldTest[packet,
		{
			MaxPower,
			MaxDetectionSignal,
			MinStokesScatteringFrequency,
			MaxStokesScatteringFrequency,
			SpectralResolution,
			LaserWavelength,
			OpticsOrientation,
			WellSampling,
			OpticalImaging,
			Objectives
		}
	],

	(* if the instument collects anti stokes scatterin, both bounds of the detection range must be given *)
	RequiredTogetherTest[packet, {MinAntiStokesScatteringFrequency, MaxAntiStokesScatteringFrequency}]

};


(* ::Subsection::Closed:: *)
(*validInstrumentReactorQTests*)


validInstrumentReactorQTests[packet:PacketP[Object[Instrument,Reactor]]]:={
	(* Good tests, good tests! *)
};


(* ::Subsection::Closed:: *)
(*validInstrumentReactorElectrochemicalQTests*)


validInstrumentReactorElectrochemicalQTests[packet:PacketP[Object[Instrument,Reactor,Electrochemical]]]:={
	(* Fields which should be null *)
	NullFieldTest[
		packet,
		{
			PDU,
			CO2PressureSensor,
			LegacyID
		}
	],

	(* Fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			(* Shared Fields *)
			Software,
			DataFilePath,
			SchlenkLine
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentRecirculatingPumpQTests*)


validInstrumentRecirculatingPumpQTests[packet:PacketP[Object[Instrument,RecirculatingPump]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};

(* ::Subsection::Closed:: *)
(*validInstrumentRefractometerQTests*)

validInstrumentRefractometerQTests[packet:PacketP[Object[Instrument,Refractometer]]]:={

	(* Defined fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Software,
		WettedMaterials,
		MeasuringWavelength,
		MinTemperature,
		MaxTemperature,
		TemperatureResolution,
		TemperatureAccuracy,
		TemperatureStability,
		MinRefractiveIndex,
		MaxRefractiveIndex,
		RefractiveIndexResolution,
		RefractiveIndexAccuracy,
		MinSampleVolume
	}],

	(* Unique fields *)
	Test["If the Status is not retired, Refractometer is informed:",
		Lookup[packet,{Status,Refractometer}],
		{Retired,_}|{Except[Retired],Except[Null]}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentRefrigeratorQTests*)


validInstrumentRefrigeratorQTests[packet:PacketP[Object[Instrument,Refrigerator]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Fields to be filled out *)
	NotNullFieldTest[
		packet,
		{
			NominalTemperature,
			Temperature
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentRollerQTests*)


validInstrumentRollerQTests[packet:PacketP[Object[Instrument, Roller]]]:={
	NotNullFieldTest[
		packet,
		{
			MinRotationRate,
			MaxRotationRate
		}
	]
};
(* ::Subsection::Closed:: *)
(*validInstrumentRobotArmQTests*)


validInstrumentRobotArmQTests[packet:PacketP[Object[Instrument, RobotArm]]]:= {
	RequiredTogetherTest[packet, {IntegratedLiquidHandler, LiquidHandlerIntegrationOffset}]
};

(* ::Subsection::Closed:: *)
(*validInstrumentRockerQTests*)


validInstrumentRockerQTests[packet:PacketP[Object[Instrument, Rocker]]]:={
	NotNullFieldTest[
		packet,
		{
			MinRotationRate,
			MaxRotationRate
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentRotaryEvaporatorQTests*)


validInstrumentRotaryEvaporatorQTests[packet:PacketP[Object[Instrument,RotaryEvaporator]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection:: *)
(*validInstrumentSampleImagerQTests*)


validInstrumentSampleImagerQTests[packet:PacketP[Object[Instrument,SampleImager]]]:={
	(* Shared fields - Null *)
	NullFieldTest[
		packet,
		{
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			IP,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields - Not Null *)
	NotNullFieldTest[
		packet,
		{
			Software
		}
	],

	(* Camera type *)
	Test[
		"If sample imager has multiple cameras, SmallCamera, MediumCamera and LargeCamera are informed:",
		Module[
			{cameras,smallCamera,mediumCamera,largeCamera},
			cameras = Lookup[packet,Model][Cameras];
			{smallCamera,mediumCamera,largeCamera}=Lookup[packet,{SmallCamera,MediumCamera,LargeCamera}];
			If[Length[cameras]>1,
				(* Ensure none of the related fields are null *)
				!NullQ[smallCamera]&&!NullQ[mediumCamera]&&!NullQ[largeCamera],
				True
			]
		],
		True
	],
	
	(* Ensure that instances have necessary illumination *)
	Test[
		"Sample imager has fields populated for all illumination directions specified in its model:",
		Module[
			{topLight, bottomLight, modelIllumination},
			{topLight, bottomLight} = Lookup[packet, {TopLight, BottomLight}];
			modelIllumination = Download[Lookup[packet, Model], Illumination];
			And[
				If[MemberQ[modelIllumination, Top], !NullQ[topLight], True],
				(* The same light box is used for both bottom and side illumination in the current ECL sample imager instruments *)
				If[MemberQ[modelIllumination, Bottom|Side], !NullQ[bottomLight], True]
			]
		],
		True
	]
};




(* ::Subsection:: *)
(*validInstrumentSampleInspectorQTests*)


validInstrumentSampleInspectorQTests[packet:PacketP[Object[Instrument,SampleInspector]]]:={
NotNullFieldTest[
		packet,
		{
			Camera,
			MinTemperature,
			MaxTemperature,
			MaxRotationRate,
			MinRotationRate,
			MaxAgitationTime,
			MinAgitationTime
		}
	],
	Test[
		"Sample inspector has fields populated for all illumination directions specified in its model:",
		Module[
			{topLight, frontLight, backLight, modelIllumination},
			{topLight, frontLight, backLight} = Lookup[packet, {TopLight, FrontLight, BackLight}];
			modelIllumination = Download[Lookup[packet, Model], Illumination];
			And[
				If[MemberQ[modelIllumination, Top], !NullQ[topLight], True],
				If[MemberQ[modelIllumination, Back], !NullQ[backLight], True],
				If[MemberQ[modelIllumination, Front], !NullQ[frontLight], True]
			]
		],
		True
	]
};




(* ::Subsection::Closed:: *)
(*validInstrumentShakerQTests*)


validInstrumentShakerQTests[packet:PacketP[Object[Instrument,Shaker]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSolidDispenserQTests*)


validInstrumentSolidDispenserQTests[packet:PacketP[Object[Instrument,SolidDispenser]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentSonicatorQTests*)


validInstrumentSonicatorQTests[packet:PacketP[Object[Instrument,Sonicator]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should not be null *)
	NotNullFieldTest[packet, PDU]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSpectrophotometerQTests*)


validInstrumentSpectrophotometerQTests[packet:PacketP[Object[Instrument,Spectrophotometer]]]:={
	(* Shared field shaping *)
	NullFieldTest[
		packet,
		{
			IP,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor
		}
	],

	NotNullFieldTest[
		packet,
		{
			Software,
			(* new *)
			LampType
		}
	],

	(* If the instrument supports heating and cooling, all fields related to the thermocycling must be informed *)
	Test[
		"If the instrument can do thermocycling, all related fields must be informed:",
		If[MatchQ[Download[Lookup[packet,Model],Thermocycling],True],
			(* Ensure none of the related fields are null *)
			!MemberQ[Lookup[packet,{NitrogenPressureSensor,NitrogenValve,PurgePressureSensor}],Null],
			True
		],
		True
	],

	Test[
		"If the instrument is a bruker Alpha, we should ensure the ATR surface is clean if not running:",
		If[MatchQ[Lookup[packet,Model],ObjectP[Model[Instrument,Spectrophotometer,"Bruker ALPHA"]]]&&MatchQ[Lookup[packet,Status],Available],
			(* Ensure that no samples on the ATR surface *)
			Length[Flatten@Download[Lookup[packet, Object],Contents[[All, 2]][Contents][[All, 2]][Object]]]==0,
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSpeedVacQTests*)


validInstrumentSpeedVacQTests[packet:PacketP[Object[Instrument,SpeedVac]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentSurfacePlasmonResonanceQTests*)


validInstrumentSurfacePlasmonResonanceQTests[packet:PacketP[Object[Instrument,SurfacePlasmonResonance]]]:={};


(* ::Subsection::Closed:: *)
(*validInstrumentTachometerQTests*)


validInstrumentTachometerQTests[packet:PacketP[Object[Instrument,Tachometer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentTensiometerQTests*)


validInstrumentTensiometerQTests[packet:PacketP[Object[Instrument,Tensiometer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			WasteContainer,
			WasteScale,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve,
			LegacyID,
			Cameras,
			Decks
		}
	],
	(* Shared fields which should not be null *)
	NotNullFieldTest[
		packet,
		{
			Software,
			DataFilePath,
			MethodFilePath,
			AssociatedAccessories
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentThermocyclerQTests*)


validInstrumentThermocyclerQTests[packet:PacketP[Object[Instrument,Thermocycler]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* If the Thermocycler is connected to a computer, none of the associated information is null *)
	If[!MatchQ[Lookup[packet,Mode],PCR],
		RequiredTogetherTest[packet,{Software,DataFilePath}],
		Nothing
	],


	(* we use this to communicate and in the procedure, so it should not be Null *)
	NotNullFieldTest[packet,IP]
};


(* ::Subsection::Closed:: *)
(*validInstrumentDigitalPCRQTests*)


validInstrumentDigitalPCRQTests[packet:PacketP[Object[Instrument,Thermocycler,DigitalPCR]]]:={

	(* Fields must be informed *)
	NotNullFieldTest[
		packet,
		{
			Software,
			MethodFilePath,
			DataFilePath,
			ProgramFilePath
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentPlateSealerQTests*)


validInstrumentPlateSealerQTests[packet:PacketP[Object[Instrument,PlateSealer]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],
		(* If the PlateSealer is connected to a computer, none of the associated information is null *)
		RequiredTogetherTest[packet, {Computer,Software}]
};


(* ::Subsection::Closed:: *)
(*validInstrumentVacuumCentrifugeQTests*)


validInstrumentVacuumCentrifugeQTests[packet:PacketP[Object[Instrument,VacuumCentrifuge]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			Software,
			Decks,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	NotNullFieldTest[packet, WasteContainer]
};



(* ::Subsection::Closed:: *)
(*validInstrumentVacuumManifoldQTests*)


validInstrumentVacuumManifoldQTests[packet:PacketP[Object[Instrument,VacuumManifold]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	NotNullFieldTest[
		packet,
		{
			Decks,
			WasteContainer
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentVacuumPumpQTests*)


validInstrumentVacuumPumpQTests[packet:PacketP[Object[Instrument,VacuumPump]]]:= {
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentVaporTrapQTests*)


validInstrumentVaporTrapQTests[packet:PacketP[Object[Instrument,VaporTrap]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet, PDU]
};


(* ::Subsection::Closed:: *)
(*validInstrumentVerticalLiftQTests*)


validInstrumentVerticalLiftQTests[packet:PacketP[Object[Instrument,VerticalLift]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Fields that should not be Null *)
	NotNullFieldTest[
		packet,
		{
			NumberOfTrays,
			TemperatureSensor,
			Temperature
		}
	],

	Test["ProvidedStorageCondition is informed if status is not retired:",
		Lookup[packet,{Status,ProvidedStorageCondition}],
		{Except[Retired],Except[Null]}|{Retired,_}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentVortexQTests*)


validInstrumentVortexQTests[packet:PacketP[Object[Instrument,Vortex]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentViscometerQTests*)


validInstrumentViscometerQTests[packet:PacketP[Object[Instrument,Viscometer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			ArgonValve,
			LegacyID,
			Cameras,
			Decks
		}
	],
	(* Shared fields which should not be null *)
	NotNullFieldTest[
		packet,
		{
			NitrogenValve,
			Software,
			DataFilePath,
			MethodFilePath,
			AssociatedAccessories,
			WasteContainer
		}
	]
};


(* ::Subsection::Closed:: *)
(*validInstrumentWaterPurifierQTests*)


validInstrumentWaterPurifierQTests[packet:PacketP[Object[Instrument,WaterPurifier]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			PDU,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentSinkQTests*)


validInstrumentSinkQTests[packet:PacketP[Object[Instrument,Sink]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			PDU,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentWesternQTests*)


validInstrumentWesternQTests[packet:PacketP[Object[Instrument,Western]]]:={
	NullFieldTest[
		packet,
		{
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			PDU,
			Decks,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			IP,
			Software
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentMultimodeSpectrophotometerQTests*)


validInstrumentMultimodeSpectrophotometerQTests[packet:PacketP[Object[Instrument,MultimodeSpectrophotometer]]]:={
	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Unique*)
		StaticLightScatteringWavelengths,
		DynamicLightScatteringWavelengths,
		StaticLightScatteringDetector,
		DynamicLightScatteringDetector,
		SampleCamera,
		MinTemperature,
		MaxTemperature,
		MinTemperatureRamp,
		MaxTemperatureRamp,
		MinSampleMassConcentration,
		MaxSampleMassConcentration,
		CalibrationLog,
		CalibrationStandardIntensity
		}],

	(*Min/Max temperature sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],

	(*Min/max temperature ramp rate sanity check*)
	FieldComparisonTest[packet, {MinTemperatureRamp, MaxTemperatureRamp}, LessEqual]

};



(* ::Subsection::Closed:: *)
(*validInstrumentDLSPlateReaderQTests*)


validInstrumentDLSPlateReaderQTests[packet:PacketP[Object[Instrument,DLSPlateReader]]]:={
	(*Fields that must be populated*)
	NullFieldTest[packet,{
		CO2PressureSensor,
		ArgonPressureSensor,
		Decks,
		WasteContainer,
		PDU,
		IP,
		ArgonValve,
		CO2Valve
	}
	],

	NotNullFieldTest[packet, {
		(*Shared*)
		Positions,
		PositionPlotting,
		NitrogenPressureSensor,
		MethodFilePath,
		DataFilePath,
		Software,
		NitrogenValve,
		(*Unique*)
		CalibrationStandardIntensity
		}]

};



(* ::Subsection::Closed:: *)
(*validInstrumentProteinCapillaryElectrophoresisQTests*)


validInstrumentProteinCapillaryElectrophoresisQTests[packet:PacketP[Object[Instrument,ProteinCapillaryElectrophoresis]]]:={
	NullFieldTest[
		packet,
		{
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			PDU,
			Decks,
			ArgonValve,
			NitrogenValve
		}
	],

	(* Shared and unique fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Software,
			MethodFilePath,
			DataFilePath,
			OnBoardMixing,
			MaxVoltageSteps
		}
	],

	(* Other tests *)
	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validInstrumentOsmometerQTests*)


validInstrumentOsmometerQTests[packet:PacketP[Object[Instrument,Osmometer]]]:={

	(* Shared fields which should be null *)

	(* Defined fields which should not be null *)
	NotNullFieldTest[packet,{
		DataFilePath,
		OsmolalityMethod,
		MinOsmolality,
		MaxOsmolality,
		MinSampleVolume,
		MaxSampleVolume,
		DedicatedSolvent,
		CustomCalibrants,
		CustomCleaningSolution,
		CleaningSolutionContainer,
		WasteContainer
	}
	],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MaxOperatingTemperature,MinOperatingTemperature},GreaterEqual],
	FieldComparisonTest[packet,{MaxOsmolality,MinOsmolality},GreaterEqual],
	FieldComparisonTest[packet,{MaxSampleVolume,MinSampleVolume},GreaterEqual],
	FieldComparisonTest[packet,{MeasurementChamberMaxTemperature,MeasurementChamberMinTemperature},GreaterEqual],

	(*Total time of experiment must be greater than time of components*)
	FieldComparisonTest[packet,{MeasurementTime,EquilibrationTime},Greater],

	(*Resolution, Accuracy and Repeatability are provided as either a constant, or as a variable quantity, not both*)
	UniquelyInformedTest[packet,{ManufacturerOsmolalityResolution,ManufacturerOsmolalityResolutionScoped}],
	UniquelyInformedTest[packet,{ManufacturerOsmolalityAccuracy,ManufacturerOsmolalityAccuracyScoped}],
	UniquelyInformedTest[packet,{ManufacturerOsmolalityRepeatability,ManufacturerOsmolalityRepeatabilityScoped}],

	(*If calibrants are provided, the osmolalities are populated*)
	RequiredTogetherTest[packet,{ManufacturerCalibrants,ManufacturerCalibrantOsmolalities}],

	(* If CustomCalibrants is False, manufacturer calibrants must be informed.*)
	Test["If CustomCalibrants is False, ManufacturerCalibrants is informed:",
		Lookup[packet,{CustomCalibrants,ManufacturerCalibrants}],
		Alternatives[{False,Except[Null]},{True,_}]
	],

	(* If not custom cleaning solution, manufacturer cleaning solution is informed *)
	Test["If CustomCleaningSolution is False, ManufacturerCleaningSolution is informed:",
		Lookup[packet,{CustomCleaningSolution,ManufacturerCleaningSolution}],
		Alternatives[{False,Except[Null]},{True,_}]
	]

};


(* ::Subsection::Closed:: *)
(*validInstrumentSchlenkLineQTests*)


validInstrumentSchlenkLineQTests[packet:PacketP[Object[Instrument,SchlenkLine]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			CO2PressureSensor
		}
	],
	(* Defined fields which should not be null *)
	NotNullFieldTest[packet,{
		HeliumValve,
		NitrogenValve,
		ArgonValve,
		HighVacuumPump,
		LowVacuumPump,
		NitrogenPressureSensor,
		ArgonPressureSensor,
		HeliumPressureSensor,
		VacuumGasDiverterValve,
		VacuumDiverterValve,
		VacuumSensor,
		VaporTrap
	}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentSpargingApparatusQTests*)


validInstrumentSpargingApparatusQTests[packet:PacketP[Object[Instrument,SpargingApparatus]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor
		}
	],
	NotNullFieldTest[packet,{
		DegasType,
		SchlenkLine,
		NumberOfChannels,
		GasType,
		MinFlowRate,
		MaxFlowRate,
		Mixer
	}
	],

	(*Min/Max flow rate sanity check*)
	FieldComparisonTest[packet, {MinFlowRate, MaxFlowRate}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validInstrumentVacuumDegasserQTests*)


validInstrumentVacuumDegasserQTests[packet:PacketP[Object[Instrument,VacuumDegasser]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],
	NotNullFieldTest[packet,{
		DegasType,
		SchlenkLine,
		NumberOfChannels,
		VacuumPump,
		MinVacuumPressure,
		MaxVacuumPressure,
		Sonicator
	}
	],
	(*Min/Max flow rate sanity check*)
	FieldComparisonTest[packet, {MinVacuumPressure, MaxVacuumPressure}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validInstrumentFreezePumpThawApparatusQTests*)


validInstrumentFreezePumpThawApparatusQTests[packet:PacketP[Object[Instrument,FreezePumpThawApparatus]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	],
	NotNullFieldTest[packet,{
		DegasType,
		SchlenkLine,
		NumberOfChannels,
		Dewar,
		VacuumPump,
		MinVacuumPressure,
		HeatBlock,
		MaxThawTemperature,
		MinThawTemperature
	}
	],

	(*Min/Max thaw temperature sanity check*)
	FieldComparisonTest[packet, {MinThawTemperature, MaxThawTemperature}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validInstrumentDewarQTests*)


validInstrumentDewarQTests[packet:PacketP[Object[Instrument,Dewar]]]:={
	(*Fields that must be populated*)
	NotNullFieldTest[
		packet,
		{
			LiquidNitrogenCapacity,
			InternalDimensions,
			StoragePositions
		}
	],
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			IP,
			DataFilePath,
			MethodFilePath,
			Software,
			Decks,
			WasteContainer,
			ArgonPressureSensor,
			CO2PressureSensor,
			NitrogenPressureSensor,
			ArgonValve,
			NitrogenValve
		}
	]
};



(* ::Subsection::Closed:: *)
(*validInstrumentDynamicFoamAnalyzerQTests*)


validInstrumentDynamicFoamAnalyzerQTests[packet:PacketP[Object[Instrument,DynamicFoamAnalyzer]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[
		packet,
		{
			ArgonPressureSensor,
			ArgonValve
		}
	],

	(*fields that must be populated*)
	NotNullFieldTest[packet,{
		DataFilePath,
		DetectionMethods,
		AgitationTypes,
		IlluminationWavelengths,
		MethodFilePath
	}
	],

	RequiredTogetherTest[packet,{AvailableGases,MinGasPressure,MaxGasPressure,MinFlowRate,MaxFlowRate}],

	(*Min/Max flow rate sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinColumnHeight, MaxColumnHeight}, LessEqual],
	FieldComparisonTest[packet, {MinColumnDiameter, MaxColumnDiameter}, LessEqual],
	FieldComparisonTest[packet, {MinGasPressure, MaxGasPressure}, LessEqual],
	FieldComparisonTest[packet, {MinFlowRate, MaxFlowRate}, LessEqual],
	FieldComparisonTest[packet, {MinStirRate, MaxStirRate}, LessEqual],
	FieldComparisonTest[packet, {MinOscillationPeriod, MaxOscillationPeriod}, LessEqual],
	FieldComparisonTest[packet, {MinFoamHeightSamplingFrequency, MaxFoamHeightSamplingFrequency}, LessEqual]
};

(* ::Subsection::Closed:: *)
(*validInstrumentElectroporatorQTests*)


validInstrumentElectroporatorQTests[packet:PacketP[Object[Instrument,Electroporator]]]:={
};


(* ::Subsection::Closed:: *)
(*validInstrumentSpargeFilterCleanerQTests*)


validInstrumentSpargeFilterCleanerQTests[packet:PacketP[Object[Instrument,SpargeFilterCleaner]]]:={
};


(* ::Subsection::Closed:: *)
(*validInstrumentUVLampQTests*)


validInstrumentUVLampQTests[packet:PacketP[Object[Instrument,UVLamp]]]:={
};



(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Instrument],validInstrumentQTests];
registerValidQTestFunction[Object[Instrument, Anemometer],validInstrumentAnemometerQTests];
registerValidQTestFunction[Object[Instrument, Aspirator],validInstrumentAspiratorQTests];
registerValidQTestFunction[Object[Instrument, Autoclave],validInstrumentAutoclaveQTests];
registerValidQTestFunction[Object[Instrument, Balance],validInstrumentBalanceQTests];
registerValidQTestFunction[Object[Instrument, DistanceGauge],validInstrumentDistanceGaugeQTests];
registerValidQTestFunction[Object[Instrument, BioLayerInterferometer], validInstrumentBioLayerInterferometerQTests];
registerValidQTestFunction[Object[Instrument, BiosafetyCabinet],validInstrumentBiosafetyCabinetQTests];
registerValidQTestFunction[Object[Instrument, BlowGun],validInstrumentBlowGunQTests];
registerValidQTestFunction[Object[Instrument, DistanceGauge],validInstrumentDistanceGaugeQTests];
registerValidQTestFunction[Object[Instrument, BottleRoller],validInstrumentBottleRollerQTests];
registerValidQTestFunction[Object[Instrument, BottleTopDispenser],validInstrumentBottleTopDispenserQTests];
registerValidQTestFunction[Object[Instrument, CapillaryELISA],validInstrumentCapillaryELISAQTests];
registerValidQTestFunction[Object[Instrument, CellThaw],validInstrumentCellThawQTests];
registerValidQTestFunction[Object[Instrument, Centrifuge],validInstrumentCentrifugeQTests];
registerValidQTestFunction[Object[Instrument, CrossFlowFiltration],validInstrumentCrossFlowFiltrationQTests];
registerValidQTestFunction[Object[Instrument, ColonyHandler],validInstrumentColonyHandlerQTests];
registerValidQTestFunction[Object[Instrument, ColonyImager],validInstrumentColonyImagerQTests];
registerValidQTestFunction[Object[Instrument, ConductivityMeter],validInstrumentConductivityMeterQTests];
registerValidQTestFunction[Object[Instrument, ControlledRateFreezer],validInstrumentControlledRateFreezerQTests];
registerValidQTestFunction[Object[Instrument, CoulterCounter],validInstrumentCoulterCounterQTests];
registerValidQTestFunction[Object[Instrument, CryogenicFreezer],validInstrumentCryogenicFreezerQTests];
registerValidQTestFunction[Object[Instrument, CrystalIncubator],validInstrumentCrystalIncubatorQTests];
registerValidQTestFunction[Object[Instrument, CuvetteWasher],validInstrumentCuvetteWasherQTests];
registerValidQTestFunction[Object[Instrument, Darkroom],validInstrumentDarkroomQTests];
registerValidQTestFunction[Object[Instrument, DensityMeter],validInstrumentDensityMeterQTests];
registerValidQTestFunction[Object[Instrument, Desiccator],validInstrumentDesiccatorQTests];
registerValidQTestFunction[Object[Instrument, Dewar],validInstrumentDewarQTests];
registerValidQTestFunction[Object[Instrument, Dialyzer],validInstrumentDialyzerQTests];
registerValidQTestFunction[Object[Instrument, Diffractometer],validInstrumentDiffractometerQTests];
registerValidQTestFunction[Object[Instrument, Dishwasher],validInstrumentDishwasherQTests];
registerValidQTestFunction[Object[Instrument, Dispenser],validInstrumentDispenserQTests];
registerValidQTestFunction[Object[Instrument, DissolvedOxygenMeter],validInstrumentDissolvedOxygenMeterQTests];
registerValidQTestFunction[Object[Instrument, DLSPlateReader],validInstrumentDLSPlateReaderQTests];
registerValidQTestFunction[Object[Instrument, DNASynthesizer],validInstrumentDNASynthesizerQTests];
registerValidQTestFunction[Object[Instrument, DifferentialScanningCalorimeter],validInstrumentDifferentialScanningCalorimeterQTests];
registerValidQTestFunction[Object[Instrument, DynamicFoamAnalyzer],validInstrumentDynamicFoamAnalyzerQTests];
registerValidQTestFunction[Object[Instrument, Electrophoresis],validInstrumentElectrophoresisQTests];
registerValidQTestFunction[Object[Instrument, FragmentAnalyzer],validInstrumentFragmentAnalyzerQTests];
registerValidQTestFunction[Object[Instrument, EnvironmentalChamber],validInstrumentEnvironmentalChamberQTests];
registerValidQTestFunction[Object[Instrument, CondensateRecirculator],validInstrumentCondensateRecirculatorQTests];
registerValidQTestFunction[Object[Instrument, Evaporator],validInstrumentEvaporatorQTests];
registerValidQTestFunction[Object[Instrument, Electroporator],validInstrumentElectroporatorQTests];
registerValidQTestFunction[Object[Instrument, FilterBlock],validInstrumentFilterBlockQTests];
registerValidQTestFunction[Object[Instrument, FilterHousing],validInstrumentFilterHousingQTests];
registerValidQTestFunction[Object[Instrument, FlashChromatography],validInstrumentFlashChromatographyQTests];
registerValidQTestFunction[Object[Instrument, FlowCytometer],validInstrumentFlowCytometerQTests];
registerValidQTestFunction[Object[Instrument, FluorescenceActivatedCellSorter],validInstrumentFluorescenceActivatedCellSorterQTests];
registerValidQTestFunction[Object[Instrument, FPLC],validInstrumentFPLCQTests];
registerValidQTestFunction[Object[Instrument, FreezePumpThawApparatus],validInstrumentFreezePumpThawApparatusQTests];
registerValidQTestFunction[Object[Instrument, Freezer],validInstrumentFreezerQTests];
registerValidQTestFunction[Object[Instrument, PortableCooler],validInstrumentPortableCoolerQTests];
registerValidQTestFunction[Object[Instrument, PortableHeater],validInstrumentPortableHeaterQTests];
registerValidQTestFunction[Object[Instrument, FumeHood],validInstrumentFumeHoodQTests];
registerValidQTestFunction[Object[Instrument, GasFlowSwitch],validInstrumentGasFlowSwitchQTests];
registerValidQTestFunction[Object[Instrument, GasChromatograph],validInstrumentGasChromatographQTests];
registerValidQTestFunction[Object[Instrument, GasGenerator],validInstrumentGasGeneratorQTests];
registerValidQTestFunction[Object[Instrument, GelBox],validInstrumentGelBoxQTests];
registerValidQTestFunction[Object[Instrument, GeneticAnalyzer],validInstrumentGeneticAnalyzerQTests];
registerValidQTestFunction[Object[Instrument, GloveBox],validInstrumentGloveBoxQTests];
registerValidQTestFunction[Object[Instrument, Grinder],validInstrumentGrinderQTests];
registerValidQTestFunction[Object[Instrument, HeatBlock],validInstrumentHeatBlockQTests];
registerValidQTestFunction[Object[Instrument, HeatExchanger],validInstrumentHeatExchangerQTests];
registerValidQTestFunction[Object[Instrument, HotPlate],validInstrumentHotPlateQTests];
registerValidQTestFunction[Object[Instrument, HPLC],validInstrumentHPLCQTests];
registerValidQTestFunction[Object[Instrument, SupercriticalFluidChromatography],validInstrumentSFCQTests];
registerValidQTestFunction[Object[Instrument, Incubator],validInstrumentIncubatorQTests];
registerValidQTestFunction[Object[Instrument, InfraredProbe],validInstrumentInfraredProbeQTests];
registerValidQTestFunction[Object[Instrument, IonChromatography],validInstrumentIonChromatographyQTests];
registerValidQTestFunction[Object[Instrument, KarlFischerTitrator],validInstrumentKarlFischerTitratorQTests];
registerValidQTestFunction[Object[Instrument, LightMeter],validInstrumentLightMeterQTests];
registerValidQTestFunction[Object[Instrument, LiquidHandler],validInstrumentLiquidHandlerQTests];
registerValidQTestFunction[Object[Instrument, LiquidHandler, AcousticLiquidHandler],validInstrumentAcousticLiquidHandlerQTests];
registerValidQTestFunction[Object[Instrument, LiquidLevelDetector],validInstrumentLiquidLevelDetectorQTests];
registerValidQTestFunction[Object[Instrument, LiquidParticleCounter],validInstrumentLiquidParticleCounterQTests];
registerValidQTestFunction[Object[Instrument, LiquidNitrogenDoser],validInstrumentLiquidNitrogenDoserQTests];
registerValidQTestFunction[Object[Instrument, Lyophilizer],validInstrumentLyophilizerQTests];
registerValidQTestFunction[Object[Instrument, MassSpectrometer],validInstrumentMassSpectrometerQTests];
registerValidQTestFunction[Object[Instrument, MeltingPointApparatus],validInstrumentMeltingPointApparatusQTests];
registerValidQTestFunction[Object[Instrument, Microscope],validInstrumentMicroscopeQTests];
registerValidQTestFunction[Object[Instrument, MicroscopeProbe],validInstrumentMicroscopeProbeQTests];
registerValidQTestFunction[Object[Instrument, Microwave],validInstrumentMicrowaveQTests];
registerValidQTestFunction[Object[Instrument, Reactor, Microwave],validInstrumentReactorMicrowaveQTests];
registerValidQTestFunction[Object[Instrument, NMR],validInstrumentNMRQTests];
registerValidQTestFunction[Object[Instrument, Osmometer],validInstrumentOsmometerQTests];
registerValidQTestFunction[Object[Instrument, Oven],validInstrumentOvenQTests];
registerValidQTestFunction[Object[Instrument, OverheadStirrer],validInstrumentOverheadStirrerQTests];
registerValidQTestFunction[Object[Instrument, PackingDevice],validInstrumentPackingDeviceQTests];
registerValidQTestFunction[Object[Instrument, ParticleSizeProbe],validInstrumentParticleSizeProbeQTests];
registerValidQTestFunction[Object[Instrument, PeptideSynthesizer],validInstrumentPeptideSynthesizerQTests];
registerValidQTestFunction[Object[Instrument, PeristalticPump],validInstrumentPeristalticPumpQTests];
registerValidQTestFunction[Object[Instrument, PressureManifold],validInstrumentPressureManifoldQTests];
registerValidQTestFunction[Object[Instrument, PlatePourer],validInstrumentPlatePourerQTests];
registerValidQTestFunction[Object[Instrument, pHMeter],validInstrumentpHMeterQTests];
registerValidQTestFunction[Object[Instrument, pHTitrator],validInstrumentpHTitratorQTests];
registerValidQTestFunction[Object[Instrument, Pipette],validInstrumentPipetteQTests];
registerValidQTestFunction[Object[Instrument, PlateImager],validInstrumentPlateImagerQTests];
registerValidQTestFunction[Object[Instrument, PlateReader],validInstrumentPlateReaderQTests];
registerValidQTestFunction[Object[Instrument, PlateTilter],validInstrumentPlateTilterQTests];
registerValidQTestFunction[Object[Instrument, PlateWasher],validInstrumentPlateWasherQTests];
registerValidQTestFunction[Object[Instrument, PowerSupply],validInstrumentPowerSupplyQTests];
registerValidQTestFunction[Object[Instrument, PurgeBox],validInstrumentPurgeBoxQTests];
registerValidQTestFunction[Object[Instrument, RamanProbe],validInstrumentRamanProbeQTests];
registerValidQTestFunction[Object[Instrument, RamanSpectrometer], validInstrumentRamanSpectrometerQTests];
registerValidQTestFunction[Object[Instrument, Reactor],validInstrumentReactorQTests];
registerValidQTestFunction[Object[Instrument, Reactor, Electrochemical],validInstrumentReactorElectrochemicalQTests];
registerValidQTestFunction[Object[Instrument, RecirculatingPump],validInstrumentRecirculatingPumpQTests];
registerValidQTestFunction[Object[Instrument, Refractometer],validInstrumentRefractometerQTests];
registerValidQTestFunction[Object[Instrument, Refrigerator],validInstrumentRefrigeratorQTests];
registerValidQTestFunction[Object[Instrument, RobotArm],validInstrumentRobotArmQTests];
registerValidQTestFunction[Object[Instrument, Rocker],validInstrumentRockerQTests];
registerValidQTestFunction[Object[Instrument, Roller],validInstrumentRollerQTests];
registerValidQTestFunction[Object[Instrument, RotaryEvaporator],validInstrumentRotaryEvaporatorQTests];
registerValidQTestFunction[Object[Instrument, SampleImager],validInstrumentSampleImagerQTests];
registerValidQTestFunction[Object[Instrument, SampleInspector],validInstrumentSampleInspectorQTests];
registerValidQTestFunction[Object[Instrument, SchlenkLine],validInstrumentSchlenkLineQTests];
registerValidQTestFunction[Object[Instrument, Shaker],validInstrumentShakerQTests];
registerValidQTestFunction[Object[Instrument, SolidDispenser],validInstrumentSolidDispenserQTests];
registerValidQTestFunction[Object[Instrument, Sonicator],validInstrumentSonicatorQTests];
registerValidQTestFunction[Object[Instrument, SpargeFilterCleaner],validInstrumentSpargeFilterCleanerQTests];
registerValidQTestFunction[Object[Instrument, SpargingApparatus],validInstrumentSpargingApparatusQTests];
registerValidQTestFunction[Object[Instrument, Spectrophotometer],validInstrumentSpectrophotometerQTests];
registerValidQTestFunction[Object[Instrument, SpeedVac],validInstrumentSpeedVacQTests];
registerValidQTestFunction[Object[Instrument, SterilizationIndicatorReader],validInstrumentSterilizationIndicatorReaderQTests];
registerValidQTestFunction[Object[Instrument, SurfacePlasmonResonance],validInstrumentSurfacePlasmonResonanceQTests];
registerValidQTestFunction[Object[Instrument, SyringePump],validInstrumentSyringePumpQTests];
registerValidQTestFunction[Object[Instrument, Tachometer],validInstrumentTachometerQTests];
registerValidQTestFunction[Object[Instrument, Tensiometer],validInstrumentTensiometerQTests];
registerValidQTestFunction[Object[Instrument, Thermocycler],validInstrumentThermocyclerQTests];
registerValidQTestFunction[Object[Instrument, Thermocycler,DigitalPCR],validInstrumentDigitalPCRQTests];
registerValidQTestFunction[Object[Instrument, PlateSealer],validInstrumentPlateSealerQTests];
registerValidQTestFunction[Object[Instrument, UVLamp],validInstrumentUVLampQTests];
registerValidQTestFunction[Object[Instrument, VacuumCentrifuge],validInstrumentVacuumCentrifugeQTests];
registerValidQTestFunction[Object[Instrument, VacuumDegasser],validInstrumentVacuumDegasserQTests];
registerValidQTestFunction[Object[Instrument, VacuumManifold],validInstrumentVacuumManifoldQTests];
registerValidQTestFunction[Object[Instrument, VacuumPump],validInstrumentVacuumPumpQTests];
registerValidQTestFunction[Object[Instrument, VaporTrap],validInstrumentVaporTrapQTests];
registerValidQTestFunction[Object[Instrument, VerticalLift],validInstrumentVerticalLiftQTests];
registerValidQTestFunction[Object[Instrument, Viscometer],validInstrumentViscometerQTests];
registerValidQTestFunction[Object[Instrument, Vortex],validInstrumentVortexQTests];
registerValidQTestFunction[Object[Instrument, WaterPurifier],validInstrumentWaterPurifierQTests];
registerValidQTestFunction[Object[Instrument, Sink],validInstrumentSinkQTests];
registerValidQTestFunction[Object[Instrument, Western],validInstrumentWesternQTests];
registerValidQTestFunction[Object[Instrument, MultimodeSpectrophotometer],validInstrumentMultimodeSpectrophotometerQTests];
registerValidQTestFunction[Object[Instrument, ProteinCapillaryElectrophoresis],validInstrumentProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Object[Instrument, Dehydrator],validInstrumentDehydratorQTests];
registerValidQTestFunction[Object[Instrument,GravityRack],validInstrumentGravityRackQTests];
registerValidQTestFunction[Object[Instrument,HandlingStation],validInstrumentHandlingStationQTests];
registerValidQTestFunction[Object[Instrument, HandlingStation, Ambient], validInstrumentHandlingStationAmbientQTests];
registerValidQTestFunction[Object[Instrument, HandlingStation, BiosafetyCabinet], validInstrumentHandlingStationBiosafetyCabinetQTests];
registerValidQTestFunction[Object[Instrument, HandlingStation, FumeHood], validInstrumentHandlingStationFumeHoodQTests];
registerValidQTestFunction[Object[Instrument, HandlingStation, GloveBox], validInstrumentHandlingStationGloveBoxQTests];
registerValidQTestFunction[Object[Instrument, Nephelometer], validInstrumentNephelometerQTests];
