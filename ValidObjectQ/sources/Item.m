(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validItemQTests*)


validItemQTests[packet:PacketP[Object[Item]]]:=Module[
	{modelPacket, productPacket},

	{modelPacket, productPacket}=If[
		MatchQ[Lookup[packet, {Model, Product}], {Null, Null}],
		{Null, Null},
		Download[Lookup[packet, Object], {Model[All], Product[All]}]];

	{

		(* Expiration date tests*)
		Test["If DateStocked is informed and the model of the sample has ShelfLife informed, then ExpirationDate must be informed:",
			{
				And[
					Not[NullQ[packet[DateStocked]]],
					Not[NullQ[modelPacket]],
					Not[NullQ[modelPacket[ShelfLife]]]
				],
				Lookup[packet,ExpirationDate]
			},
			Alternatives[{True, Except[NullP]},{Except[True], _}]
		],

		Test["If UnsealedShelfLife is informed in the model and the sample has DateUnsealed informed, then ExpirationDate must be informed:",
			{
				And[
					Not[NullQ[Lookup[packet,DateUnsealed]]],
					Not[NullQ[modelPacket]],
					Not[NullQ[modelPacket[UnsealedShelfLife]]]
				],
				Lookup[packet,ExpirationDate]
			},
			Alternatives[{True, Except[NullP]},{Except[True], _}]
		],

		(* storage *)
		Test["If Status is not Discarded, StorageCondition is filled out:",
			Lookup[packet,{Status,StorageCondition}],
			{Discarded,_}|{Except[Discarded],Except[NullP]}
		],

		Test["The last entry in StorageConditionLog matches the current StorageCondition:",
			If[Lookup[packet,StorageConditionLog]=={},
				Null,
				Download[Last[Lookup[packet,StorageConditionLog]][[2]],Object]
			],
			Download[Lookup[packet,StorageCondition],Object]
		],

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the sample:",
			If[!MatchQ[Lookup[packet,StoragePositions],{}],
				Module[{upConditions,providedConditions},

					(* get the provided condition of all StoragePositions *)
					upConditions=Download[Lookup[packet,StoragePositions][[All,1]],Repeated[Container][ProvidedStorageCondition],ProvidedStorageCondition==Null,HaltingCondition->Inclusive];

					(* the provided condition is the last of each of these "up condition" objects (we stopped when we hit one) *)
					providedConditions=DeleteDuplicates[Download[Cases[LastOrDefault/@upConditions,ObjectP[Model[StorageCondition]]],Object]];

					(* there should be just onbe provided condition, which is the sample's *)
					Which[
						Length[providedConditions]==1,
							MatchQ[FirstOrDefault[providedConditions],Download[Lookup[packet,StorageCondition],Object]],
						Length[providedConditions]>1,False,
						True,True
					]
				],
				True
			],
			True
		],

		Test["If AwaitingDisposal is True, then AwaitingStorageUpdate must also be True:",
			Lookup[packet,{Status,AwaitingDisposal,AwaitingStorageUpdate}],
			{InUse,_,_}|{Except[InUse, SampleStatusP|Null],True,True}|{Except[InUse, SampleStatusP|Null],(False|Null),_}
		],

		Test["The last entry in DisposalLog matches the current AwaitingDisposal:",
			{If[Lookup[packet,DisposalLog]=={},Null,Last[Lookup[packet,DisposalLog]][[2]]],Lookup[packet,AwaitingDisposal]},
			Alternatives[
				{True, True},
				{False|Null, False|Null}
			]
		],

		(* Check to see if the object is in the ScheduledMoves of an Object[Maintenance, StorageUpdate] and prioritize this if so
			if not you should enqueue a new StorageUpdate to make this move *)
		Test["If the object has a new requested storage category, or needs to be thrown out it has not been waiting more than 7 days for this change to take place:",
			Module[{updateNeeded, disposalLog, storageConditionLog, currentProtocol, notebook, lastUpdateRequest, gracePeriod, status},
				{updateNeeded, disposalLog, storageConditionLog, currentProtocol, notebook, status} = Lookup[packet, {AwaitingStorageUpdate, DisposalLog, StorageConditionLog, CurrentProtocol, Notebook, Status}];

				(* Ugly check to get the most recent request to change the storage condition or discard the object *)
				lastUpdateRequest = Max[{First[Last[disposalLog, {}], Now], First[Last[storageConditionLog, {}], Now]}];

				(* Give ops 7 days to complete the request - can change based on our current expectations *)
				gracePeriod = 7 Day;

				(* If we need to update the storage location and it's been longer than our expected time, we're in trouble and need to get the Maintenace done or enqueued! *)
				(* Don't worry if it's in a protocol since this will handle the clean up *)
				(* Only complain about customer samples for right now *)
				(* ignore things that are discarded *)
				MatchQ[updateNeeded, True] && lastUpdateRequest < (Now - gracePeriod) && currentProtocol === Null && notebook =!= Null && Not[MatchQ[status, Discarded]]
			],
			False
		],

		(* Location *)
		Test["If Status is not Discarded, the sample has a location (Container, Position informed):",
			If[MatchQ[Lookup[packet, Type], Alternatives@@Patterns`Private`coveringTypesObjects],

				(* caps that are on containers dont have location and thats ok *)
				If[MatchQ[Lookup[packet, CoveredContainer], Null],
					MatchQ[Lookup[packet,{Status,Container,Position}], {Discarded,_,_}|{Except[Discarded],Except[NullP],Except[NullP]}],
					True
				],

				(* we dont have a cap - do the normal test *)
				MatchQ[Lookup[packet,{Status,Container,Position}], {Discarded,_,_}|{Except[Discarded],Except[NullP],Except[NullP]}]
			],
			True
		],

		(* dont check for location if the item is a cap/lid/seal that is on a container *)
		Test["If Status is not Discarded, the sample has a location log:",
			If[MatchQ[
				Lookup[packet, {Type, CoveredContainer}],
				{Alternatives@@Patterns`Private`coveringTypesObjects, ObjectP[]}
			],
				True,
				MatchQ[Lookup[packet,{Status,LocationLog}],{Discarded,_}|{Except[Discarded],Except[{}]}]
			],
			True
		],

		Test["The last entry in LocationLog matches the current Position and Container:",
			If[
				MatchQ[
					Lookup[packet, {Type, CoveredContainer}],
					{Alternatives@@Patterns`Private`coveringTypesObjects, ObjectP[]}
				],
				True,
				MatchQ[{#[[4]],#[[3]][Object]}&[Last[Lookup[packet, LocationLog]]], {Lookup[packet, Position],Lookup[packet, Container][Object]}]
			],
			True
		],

		Test["If Status is InUse, the protocol using it must not be failed:",
			Download[packet,{Status,CurrentProtocol[Status]}],
			{Except[InUse],_}|{InUse,Except[Aborted]}
		],

		Test["If Status is Transit, the sample has a Destination:",
			If[MatchQ[Lookup[packet,Status],Transit],
				!NullQ[Lookup[packet,Destination]],
				True
			],
			True
		],

		Test["If Status is not Discarded, Site is filled out:",
			Lookup[packet,{Status,Site}],
			{Discarded,_}|{Except[Discarded],Except[NullP]}
		],

		(* Ownership *)

		(* Can't have samples in the lab that are public but don't have a product, since that upsets PriceMaterials *)
		Test["If Status is not Discarded or of the type Object[Sample], the sample must be linked to either a product or a notebook, or both:",
			Module[{parentProtocol, status, source, type, product, notebook, currentProtocol, inUseByCreatorProtocol,coveredContainer},
				(* Note: need to quiet the FieldDoesntExist Error since there is no ParentProtocol in Transaction objects *)
				parentProtocol = LastOrDefault[Quiet[Download[Lookup[packet,Source],ParentProtocol..],Download::FieldDoesntExist]];
				{coveredContainer,status, source, type, product, notebook, currentProtocol} = Lookup[packet, {CoveredContainer,Status, Source, Type, Product, Notebook, CurrentProtocol}];

				(* figure out if the sample is InUse by the protocol that made it because those are not invalid *)
				inUseByCreatorProtocol = (ECL`SameObjectQ[parentProtocol, currentProtocol] || ECL`SameObjectQ[source, currentProtocol]) && MatchQ[status, InUse];

				{coveredContainer,parentProtocol, source, type, status, product, notebook, inUseByCreatorProtocol}
			],
			Alternatives[
				(* if this is a cap on a container, skip this check *)
				{ObjectP[],__},

				(* we don't include samples in this check whose Root protocol is a Maintenance/Qualification as Source since those are always either Restricted or InUse and can be public/no product *)
				{_,ObjectP[{Object[Maintenance],Object[Qualification]}],__},

				(* we don't include samples in this check that have Maintenance/Qualification as Source since those are always either Restricted or InUse and can be public/no product *)
				{_,_,ObjectP[{Object[Maintenance],Object[Qualification]}],__},

				(* we don't include Waste samples in this check, since they are most of the time product- and notebook-less *)
				{_,_,_,Object[Sample],__},

				(* we don't include the following types in this check, since they are "made" at ECL and are product- and notebook-less *)
				{_,_,_,Object[Item, ColumnHolder],__},
				{_,_,_,Object[Item, Counterweight],__},
				{_,_,_,Object[Item, LidSpacer],__},

				(* we don't include screwdrivers or rulers because that seems silly and we didn't used to check this anyway *)
				{_,_,_,Object[Item, Screwdriver],__},
				{_,_,_,Object[Item, ScrewdriverBit],__},
				{_,_,_,Object[Item, Wrench],__},
				{_,_,_,Object[Item, MagnifyingGlass],__},
				{_,_,_,Object[Item, Ruler],__},
				{_,_,_,Object[Item, Plier],__},

				(* don't include gc tools either *)
				{_,_,_,Object[Item, GCColumnWafer],__},
				{_,_,_,Object[Item, SwagingTool],__},

				(* we don't care if the sample is discarded, either *)
				{_,_,_,_,Discarded,__},

				(* we don't care if the sample is still InUse by its creator protocol *)
				{_,_, _, _, InUse, _, _, True},

				(* if the sample is neither waste nor discarded, we either have product, notebook, or both *)
				{_,Except[ObjectP[{Object[Maintenance],Object[Qualification]}]],Except[ObjectP[{Object[Maintenance],Object[Qualification]}]],Except[Object[Sample]],Except[Discarded],ObjectP[Object[Product]],_, _},
				{_,Except[ObjectP[{Object[Maintenance],Object[Qualification]}]],Except[ObjectP[{Object[Maintenance],Object[Qualification]}]],Except[Object[Sample]],Except[Discarded],_,ObjectP[Object[LaboratoryNotebook]], _}
			]
		],

		Test["If a sample's Source is a Maintenance/Qualification, and the sample is linked to no notebook and no product, then either its Status is InUse or the sample is Restricted:",
			If[MatchQ[Lookup[packet,Source],ObjectP[{Object[Maintenance],Object[Qualification]}]&&NullQ[Lookup[packet,Notebook]]]&&NullQ[Lookup[packet,Product]],
				MatchQ[Lookup[packet,Status],InUse] || MatchQ[Lookup[packet,Restricted],True],
			True],
			True
		],

		(* If the Object has Connectors in its Model, then it must have corresponding entries in the Object's Connectors field *)
		Test["All Connector positions from this Object's Model have entries in the Object and vice versa:",
			Module[{modelConnectors,modelConnectorNames, objectConnectors, objectConnectorNames},
				modelConnectors = Lookup[modelPacket,Connectors];
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

		(* the latest entry of the PlumbingSizeLog agrees with the current Size *)
		Test["The latest entry of the PlumbingSizeLog contains the current size of the Object:",
			Module[{size, sizeLog, mostRecentEntry},
				{size, sizeLog} = Lookup[packet,{Size, PlumbingSizeLog}];

				(* get the last entry in the size log *)
				mostRecentEntry = If[MatchQ[sizeLog,Except[{}]],
					First@SortBy[sizeLog,Function[logEntry,Now-logEntry[[1]]]],
					{}
				];

				(* as long as any of the lists are not empty, carry out the following check, otherwise no problem *)
				If[And[!NullQ[size],!MatchQ[mostRecentEntry,{}]],
					MatchQ[mostRecentEntry[[4]],EqualP[size]],
					True
				]
			],
			True
		],

		(* -- Wiring -- *)
		(* If the Object has WiringConnectors in its Model, then it must have corresponding entries in the Object's WiringConnectors field *)
		Test["All WiringConnectors positions from this Object's Model have entries in the Object and vice versa:",
			Module[{modelConnectors,modelConnectorNames, objectConnectors, objectConnectorNames},
				modelConnectors = Lookup[modelPacket,WiringConnectors];
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

		(* The latest entry of the WiringLengthLog agrees with the current WiringLength *)
		Test["The latest entry of the WiringLengthLog agrees with the current WiringLength:",
			Module[{wiringLength, wiringLengthLog, mostRecentEntry},
				{wiringLength, wiringLengthLog} = Lookup[packet,{WiringLength, WiringLengthLog}];

				(* get the last entry in the wiringLength log *)
				mostRecentEntry = If[MatchQ[wiringLengthLog,Except[{}]],
					First@SortBy[wiringLengthLog,Function[logEntry,Now-logEntry[[1]]]],
					{}
				];

				(* as long as any of the lists are not empty, carry out the following check, otherwise no problem *)
				If[And[!NullQ[wiringLength],!MatchQ[mostRecentEntry,{}]],
					MatchQ[mostRecentEntry[[4]],EqualP[wiringLength]],
					True
				]
			],
			True
		],

		Test["If Model has at least one Product or KitProduct, object has to have Product populated",
			Module[{modelProducts, product},
				modelProducts = Flatten@Download[ToList[Lookup[modelPacket, {Products, KitProducts}]], Object];
				product = Lookup[packet, Product];
				Which[
					(* if we have Product populated, we are good *)
					!NullQ[product],
					True,

					(* if we don't have any  products in the Model, we are good *)
					NullQ[product]&&Length[ToList[modelProducts]]==0,
					True,

					(* if Product is not populated but there is at least one  Product for the Model, we have a problem *)
					NullQ[product]&&Length[ToList[modelProducts]]>0,
					False
				]],
			True
		],

		Test["If Product is a Kit, KitComponents should be populated:",
			If[!NullQ[packet],
				Which[
					(* if we don't have a product, pass *)
					NullQ[Lookup[packet, Product]],
					True,

					(* we have a product but it is not a kit*)
					MatchQ[Lookup[productPacket,KitComponents], (Null|{})],
					True,

					(* product is a kit but KitComponents in the Object are not populated *)
					MatchQ[Lookup[productPacket,KitComponents], Except[Null|{}]]&&MatchQ[Lookup[packet,KitComponents], (Null|{})],
					False,

					(* otherwise, pass the test *)
					True,
					True
				],
				True
			],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validItemArrayCardSealerQTests*)


validItemArrayCardSealerQTests[packet:PacketP[Object[Item,ArrayCardSealer]]]:={};


(* ::Subsection::Closed:: *)
(*validItemBLIProbeQTests*)


validItemBLIProbeQTests[packet : PacketP[Object[Item, BLIProbe]]] := {

	(*shared fields not Null*)
	NotNullFieldTest[packet,{Count}]
};

(* ::Subsection::Closed:: *)
(*validItemClampQTests*)


validItemClampQTests[packet:PacketP[Object[Item,Clamp]]]:={};



(* ::Subsection::Closed:: *)
(*validItemConsumableQTests*)


validItemConsumableQTests[packet:PacketP[Object[Item,Consumable]]]:={};


(* ::Subsection::Closed:: *)
(*validItemCapQTests*)

validCoverObjectsQTests[packet:PacketP[{Object[Item, Cap], Object[Item,PlateSeal], Object[Item,Lid], Object[Item,Septum], Object[Item, Stopper]}]]:=Module[
	{coveredContainerNotebook, debugPacket},
	debugPacket = packet;
	(* Make one Download for all tests *)
	{{coveredContainerNotebook}} = Quiet[Download[
		{
			ToList@Lookup[packet, CoveredContainer]
		},
		{
			{Notebook[Object]}
		}
	], {Download::FieldDoesntExist, Download::NotLinkedField}];


	(*--  Tests  --*)
	{
		(*shared fields not null*)
		NotNullFieldTest[packet,{Model,DateStocked}],


		(* shared fields null *)
		NullFieldTest[packet,{
			ExpirationDate,
			TransfersOut,
			Volume,
			Mass
		}
		],

		UniquelyInformedTest[packet, {CoveredContainer, Container}],

		(* If CoveredContainer is informed, it should have the same public status or belong to the same Notebook *)
		Test["If Cap is public and has CoveredContainer, it also must be public:",
			Or[
				(* no covered container *)
				MatchQ[Lookup[packet, CoveredContainer], Null],

				(* private cap and private CoveredContainer *)
				And[
					MatchQ[Lookup[packet, CoveredContainer], ObjectP[]],
					MatchQ[Lookup[packet, Notebook], ObjectP[]],
					MatchQ[First@ToList@coveredContainerNotebook, ObjectP[]],
					MatchQ[Download[Lookup[packet, Notebook],Object],First@ToList@coveredContainerNotebook]
				],

				(* public cap and CoveredContainer *)
				And[
					MatchQ[Lookup[packet, CoveredContainer], ObjectP[]],
					MatchQ[Lookup[packet, Notebook], Null],
					MatchQ[First@ToList@coveredContainerNotebook, Null]
				]
			],
			True
		]
	}];


(* ::Subsection::Closed:: *)
(*validItemCapElectrodeCapQTests*)


validItemCapElectrodeCapQTests[packet:PacketP[Object[Item, Cap, ElectrodeCap]]] := {
};


(* ::Subsection::Closed:: *)
(*validItemCapElectrodeCapCalibrationCapQTests*)


validItemCapElectrodeCapCalibrationCapQTests[packet:PacketP[Object[Item, Cap, ElectrodeCap, CalibrationCap]]] := {
};


(* ::Subsection::Closed:: *)
(*validItemPlungerQTests*)


validItemPlungerQTests[packet:PacketP[Object[Item, Plunger]]] := {
};



(* ::Subsection::Closed:: *)
(*validItemLidSpacerQTests*)


validItemLidSpacerQTests[packet:PacketP[Object[Item,LidSpacer]]]:={

	(*shared fields not null*)
	NotNullFieldTest[packet,{Model, DateStocked}],

	(* shared fields null *)
	NullFieldTest[packet,{
			ExpirationDate,
			TransfersOut,
			Volume,
			Mass,
			Product
		}
	]

};


(* ::Subsection::Closed:: *)
(*validItemColumnQTests*)


validItemColumnQTests[packet:PacketP[Object[Item,Column]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {TransfersOut,Volume}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Model,Product}],


	(* Other tests *)
	Test["For non joining columns, NumberOfUses should be informed if the column was used in a chromatographic experiment:",
		{
			Lookup[packet,NumberOfUses],
			(* doing this because if there is only one protocol that has been using this and it is not done yet, then it might be ok to not have NumberOfUses populated yet *)
			With[
				{
					simpleStatusLog = Cases[
						Lookup[packet, StatusLog],
						Alternatives[
							{_,Available,ObjectP[{Object[Protocol,HPLC], Object[Protocol,FPLC], Object[Protocol,SupercriticalFluidChromatography], Object[Protocol,LCMS], Object[Protocol, IonChromatography], Object[Qualification,HPLC], Object[Qualification,FPLC], Object[Qualification,SupercriticalFluidChromatography], Object[Qualification,IonChromatography]}]},
							{_,Installed|Available,ObjectP[{Object[Protocol,GasChromatography],Object[Qualification,GasChromatography]}]}
						]
					]
				},
				Length[simpleStatusLog] >= 1 && MatchQ[Download[simpleStatusLog[[1, 3]], Status], Completed|Aborted|Canceled]
			],
			Download[packet, Model[ColumnType]]
		},
		Alternatives[
			{_,_,Join},
			{Null|0,False,_},
			{Except[Null|0],True,_}
		]
	],

	Test["NumberOfUses should be equal to or greater than the number of non-prime/flush data objects associated with the sample, if status is anything other than InUse:",
		If[MatchQ[Lookup[packet,Status],Except[InUse]],
			((Lookup[packet,NumberOfUses]) /. {Null -> 0}) >= Length[(DeleteCases[Download[Lookup[packet, Data],DataType], Alternatives[Prime, Flush]])],
			True
		],
		True
	],

	(* required inlet and outlet connecotrs in model, this may be redundant since Object.Item is required to have same connectors as model *)
	Test["Connectors must contain entries for 'Column Inlet' and 'Column Outlet' if Model's ChromatographyType is GasChromatography:",
		If[MatchQ[Download[Lookup[packet,Model],ChromatographyType],GasChromatography],
			MemberQ[Lookup[packet,Connectors],{"Column Inlet",___}] && MemberQ [Lookup[packet,Connectors],{"Column Outlet",___}],
			True
		],
		True
	],

	(* if the column's ChromatographyType is GasChromatography, Size must be specified: *)
	If[MatchQ[Download[packet,Model[ChromatographyType]],GasChromatography],
		NotNullFieldTest[packet,{Size}],
		Nothing
	]

};


(* ::Subsection::Closed:: *)
(*validItemColumnHolderQTests*)


validItemColumnHolderQTests[packet:PacketP[Object[Item,ColumnHolder]]]:={};


(* ::Subsection::Closed:: *)
(*validItemCartridgeQTests*)


validItemCartridgeQTests[packet:PacketP[Object[Item,Cartridge]]]:={

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Model,CartridgeType}]
};


(* ::Subsection::Closed:: *)
(*validItemCartridgeColumnQTests*)


validItemCartridgeColumnQTests[packet:PacketP[Object[Item,Cartridge, Column]]]:={

(* Shared fields which should be null *)
	NullFieldTest[packet, {TransfersOut,Volume}],

(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Model,Product}],


(* Other tests *)
	Test["NumberOfUses should be informed if Status is anything other than Stocked or InUse:",
		Lookup[packet,{NumberOfUses,Status}],
		Alternatives[
			{Null|0,Stocked},
			{_,InUse|Discarded},
			{Except[Null|0],Except[Stocked|InUse|Discarded]}
		]
	],
	Test["NumberOfUses should be equal to or greater than the number of non-prime/flush data objects associated with the sample, if status is anything other than InUse:",
		If[MatchQ[Lookup[packet,Status],Except[InUse]],
			((Lookup[packet,NumberOfUses]) /. {Null -> 0}) >= Length[(DeleteCases[Download[Lookup[packet, Data],DataType], Alternatives[Prime, Flush]])],
			True
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validItemConsumableBladeQTests*)


validItemConsumableBladeQTests[packet:PacketP[Object[Item,Consumable,Blade]]]:={

};


(* ::Subsection::Closed:: *)
(*validItemConsumableSandpaperQTests*)


validItemConsumableSandpaperQTests[packet:PacketP[Object[Item,Consumable,Sandpaper]]]:={

};


(* ::Subsection::Closed:: *)
(*validItemFilterQTests*)


validItemFilterQTests[packet:PacketP[Object[Item,Filter]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet,{TransfersOut,TransfersIn,Volume,Mass}],
	AnyInformedTest[packet, {SerialNumber, BatchNumber}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,Model]



};

(* ::Subsection::Closed:: *)
(*validItemFilterMicrofluidicChipQTests*)


validItemFilterMicrofluidicChipQTests[packet:PacketP[Object[Item, Filter,MicrofluidicChip]]]:={
	
	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,Model]
	
};



(* ::Subsection::Closed:: *)
(*validItemCrossFlowFilterQTests*)


validItemCrossFlowFilterQTests[packet:PacketP[Object[Item,CrossFlowFilter]]]:={
	
	NotNullFieldTest[packet,{
		Model,
		ModuleFamily,
		SizeCutoff,
		MembraneMaterial,
		FilterSurfaceArea,
		ModuleCondition,
		MinVolume,
		MaxVolume,
		DefaultFlowRate,
		FilterType
	}],
	
	Test[
		"Object has at least three connectors with names \"Feed Pressure Sensor Inlet\", \"Retentate Pressure Sensor Outlet\" and \"Permeate Pressure Sensor Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Feed Pressure Sensor Inlet","Retentate Pressure Sensor Outlet","Permeate Pressure Sensor Inlet"},
		{True,True,True}
	]
};


(* ::Subsection::Closed:: *)
(*validItemDialysisMembraneQTests*)


validItemDialysisMembraneQTests[packet:PacketP[Object[Item,DialysisMembrane]]]:={

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Model
	}]



};


(* ::Subsection::Closed:: *)
(*validItemGelQTests*)


validItemGelQTests[packet:PacketP[Object[Item,Gel]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		TransfersOut,
		Mass
		}
	],


	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Model,Product,DateStocked}]
};


(* ::Subsection::Closed:: *)
(*validItemNeedleQTests*)


validItemNeedleQTests[packet:PacketP[Object[Item,Needle]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet,{
			TransfersOut,
			TransfersIn,
			Volume,
			Mass
		}
	],

	(* shared fields not null *)
	NotNullFieldTest[packet,Model]
};


(* ::Subsection::Closed:: *)
(*validItemTipsQTests*)


validItemTipsQTests[packet:PacketP[Object[Item,Tips]]]:={
	(* Shared fields which should be null *)
	NullFieldTest[packet, {ExpirationDate,TransfersOut,Volume}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet, {Product, DateStocked, Model}]
};


(* ::Subsection::Closed:: *)
(*validItemRulerQTests*)


validItemRulerQTests[packet:PacketP[Object[Item,Ruler]]]:={
	AnyInformedTest[packet, {SerialNumber, BatchNumber}]
};




(* ::Subsection::Closed:: *)
(*validItemBoxCutterQTests*)


validItemBoxCutterQTests[packet:PacketP[Object[Item,BoxCutter]]]:={};

(* ::Subsection::Closed:: *)
(*validItemCalibrationDistanceBlockQTests*)

validItemCalibrationDistanceBlockQTests[packet:PacketP[Object[Item,CalibrationDistanceBlock]]]:={
	(* filed that must be filled in *)
	NotNullFieldTest[
		packet,
		{
			PreciseDimensions
		}
	]
};

(* ::Subsection::Closed:: *)
(*validItemCalibrationWeightQTests*)


validItemCalibrationWeightQTests[packet:PacketP[Object[Item,CalibrationWeight]]]:={
	(* at least one of these should be filled in *)
	AnyInformedTest[
		packet,
		{
			SerialNumber,
			BatchNumber
		}
	],

	(* filed that must be filled in *)
	NotNullFieldTest[
		packet,
		{
			NominalWeight,
			Weight,
			WeightUncertainty,
			CalibrationCertificateFile
		}
	],

	(* NominalWeight is synced between Model and object *)
	FieldSyncTest[Cases[{Download[Lookup[packet,Model]],packet},PacketP[]],NominalWeight]
};



(* ::Subsection::Closed:: *)
(*validItemCounterweightQTests*)


validItemCounterweightQTests[packet:PacketP[Object[Item,Counterweight]]]:={

	(* Shared field shaping - Null *)
	NullFieldTest[
		packet,
		{
			SerialNumber
		}
	]
};


(* ::Subsection::Closed:: *)
(*validItemElectrodeQTests*)


validItemElectrodeQTests[packet:PacketP[Object[Item,Electrode]]]:={
	NotNullFieldTest[
		packet,
		{
			NumberOfUses
		}
	],
	Test["The NumberOfPolishings and PolishingLog should be informed only when the electrode is not Coated::",
		Module[{coated, numberOfPolishings, polishingLog},
			{coated, numberOfPolishings, polishingLog} = Lookup[packet, {Coated, NumberOfPolishings, PolishingLog}]
		],
		Alternatives[{True, NullP, {}}, {False, Alternatives[GreaterEqualP[0], Null], _}]
	],
	Test["If NumberOfPolishings or PolishingLog are informed, the NumberOfPolishings is the same with the length of the PolishingLog if the electrode is not Coated:",
		Module[{coated, numberOfPolishings, polishingLog},
			{coated, numberOfPolishings, polishingLog} = Lookup[packet, {Coated, NumberOfPolishings, PolishingLog}];
			If[TrueQ[coated],
				{True, True},
				Module[{},
					If[Or[IntegerQ[numberOfPolishings], !MatchQ[polishingLog, {}]],
						{False, MatchQ[numberOfPolishings, Length[polishingLog]]},
						{False, True}
					]
				]
			]
		],
		Alternatives[{True, True}, {False, True}]
	]
};



(* ::Subsection::Closed:: *)
(*validItemElectrodeReferenceElectrodeQTests*)


validItemElectrodeReferenceElectrodeQTests[packet:PacketP[Object[Item,Electrode,ReferenceElectrode]]]:=Module[
	{
		model, modelPacket,

		modelWiringConnectors, modelWiringDiameters, modelWiringLength, modelReferenceSolution,
		objectWiringConnectors, objectWiringDiameters, objectWiringLength, objectReferenceElectrodeModelLog, objectRefreshLog,
		mostRecentModelEntry, mostRecentRefreshEntry,

		wiringDiameterMismatchBool, referenceElectrodeModelMismatchBool, referenceSolutionModelMismatchBool
	},

	(* get the model *)
	model = packet[Model] /. {x:ObjectP[]:>Download[x, Object]};
	modelPacket = If[Not[NullQ[model]],
		Download[model]
	];

	{modelWiringConnectors, modelWiringDiameters, modelWiringLength, modelReferenceSolution} = Lookup[modelPacket, {WiringConnectors, WiringDiameters, WiringLength, ReferenceSolution}] /. {x:ObjectP[]:>Download[x, Object]};

	{objectWiringConnectors, objectWiringDiameters, objectWiringLength, objectReferenceElectrodeModelLog, objectRefreshLog} = Lookup[packet, {WiringConnectors, WiringDiameters, WiringLength, ReferenceElectrodeModelLog, RefreshLog}];

	(* Check if the WiringDiameters match with the model *)
	wiringDiameterMismatchBool = If[SameLengthQ[modelWiringDiameters, objectWiringDiameters],

		(* If the are of the same lengths, we continue *)
		Module[{checkingResults},
			checkingResults = MapThread[
				Which[
					(* When both are Nulls *)
					MatchQ[#1, Null] && MatchQ[#2, Null],
					False,

					(* When both are distances *)
					DistanceQ[#1] && DistanceQ[#2],
					Not[EqualQ[#1, #2]],

					(* Otherwise, return True *)
					True,
					True
				]&,
				{modelWiringDiameters, objectWiringDiameters}
			];

			(* Return the result *)
			Or@@checkingResults
		],

		(* Otherwise, we return True *)
		True
	];

	(* Get the latest entry of the ReferenceElectrodeModelLog *)
	mostRecentModelEntry = If[MatchQ[objectReferenceElectrodeModelLog,Except[{}]],
		First@SortBy[objectReferenceElectrodeModelLog,Function[logEntry,Now-logEntry[[1]]]],
		{}
	] /. {x:ObjectP[]:>Download[x, Object]};

	(* Check if the latest model agrees with the electrode's model *)
	referenceElectrodeModelMismatchBool = If[!MatchQ[mostRecentModelEntry,{}],
		!MatchQ[mostRecentModelEntry[[2]],model],
		False
	];

	(* Get the latest entry of the RefreshLog *)
	mostRecentRefreshEntry = If[MatchQ[objectRefreshLog,Except[{}]],
		First@SortBy[objectRefreshLog,Function[logEntry,Now-logEntry[[1]]]],
		{}
	] /. {x:ObjectP[]:>Download[x, Object]};

	(* Check if the latest model agrees with the electrode's model *)
	referenceSolutionModelMismatchBool = If[!MatchQ[mostRecentRefreshEntry,{}],
		!MatchQ[mostRecentRefreshEntry[[2]],modelReferenceSolution],
		False
	];

	{
		Test["The WiringConnector field is identical with the electrode's Model:",
			MatchQ[modelWiringConnectors, objectWiringConnectors],
			True
		],

		Test["The WiringDiameters field is identical with the electrode's Model:",
			wiringDiameterMismatchBool,
			False
		],

		Test["The WiringLength field is identical with the electrode's Model:",
			EqualQ[modelWiringLength, objectWiringLength],
			True
		],

		Test["The last entry of the ReferenceElectrodeModelLog matches the Model",
			referenceElectrodeModelMismatchBool,
			False
		],

		Test["The last entry of the RefreshLog matches the Model's ReferenceSolution",
			referenceSolutionModelMismatchBool,
			False
		]
	}
];



(* ::Subsection::Closed:: *)
(*validItemElectrodePolishingPadQTests*)


validItemElectrodePolishingPadQTests[packet:PacketP[Object[Item,ElectrodePolishingPad]]]:={
	(* Shared Fields: *)
	NotNullFieldTest[packet, {NumberOfUses}],

	(* Non-Shared Fields: *)
	RequiredTogetherTest[packet,{PolishingLog,SolutionLog}],
	Test["The length of PolishingLog and SolutionLog are the same:",
		Module[{polishingLog, solutionLog},
			{polishingLog, solutionLog} = Lookup[packet, {PolishingLog, SolutionLog}];
			SameLengthQ[polishingLog, solutionLog]
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validItemElectrodePolishingPlateQTests*)


validItemElectrodePolishingPlateQTests[packet:PacketP[Object[Item,ElectrodePolishingPlate]]]:={
	(* Shared Fields: *)
	NotNullFieldTest[packet, {NumberOfUses}]
};



(* ::Subsection::Closed:: *)
(*validItemIceScraperQTests*)


validItemIceScraperQTests[packet:PacketP[Object[Item,IceScraper]]]:={};



(* ::Subsection::Closed:: *)
(*validItemFloorMatQTests*)


validItemFloorMatQTests[packet:PacketP[Object[Item,FloorMat]]]:={};


(* ::Subsection::Closed:: *)
(*validItemPlateSealRollerQTests*)


validItemPlateSealRollerQTests[packet:PacketP[Object[Item,PlateSealRoller]]]:={};


(* ::Subsection::Closed:: *)
(*validItemRodQTests*)


validItemRodQTests[packet:PacketP[Object[Item, Rod]]]:={};


(* ::Subsection::Closed:: *)
(*validItemRubberMalletQTests*)


validItemRubberMalletQTests[packet:PacketP[Object[Item,RubberMallet]]]:={};



(* ::Subsection::Closed:: *)
(*validItemScrewdriverQTests*)


validItemScrewdriverQTests[packet:PacketP[Object[Item,Screwdriver]]]:={};



(* ::Subsection::Closed:: *)
(*validItemScrewdriverBitQTests*)


validItemScrewdriverBitQTests[packet:PacketP[Object[Item,ScrewdriverBit]]]:={};



(* ::Subsection::Closed:: *)
(*validItemSequencingCartridgeQTests*)


validItemSequencingCartridgeQTests[packet:PacketP[Object[Item,SequencingCartridge]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		TransfersOut
	}
	],


	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Model,
		Product,
		DateStocked
	}],

	(* Other tests *)
	Test["NumberOfUses should be informed if Status is anything other than Stocked or InUse:",
		Lookup[packet,{NumberOfUses,Status}],
		Alternatives[
			{Null|0,Stocked},
			{_,InUse|Discarded},
			{Except[Null|0],Except[Stocked|InUse|Discarded]}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validItemTabletCutterQTests*)


validItemTabletCutterQTests[packet:PacketP[Object[Item,TabletCutter]]]:={};


(* ::Subsection::Closed:: *)
(*validItemTabletCrusherQTests*)


validItemTabletCrusherQTests[packet:PacketP[Object[Item,TabletCrusher]]]:={

};


(* ::Subsection::Closed:: *)
(*validItemTabletCrusherBagQTests*)


validItemTabletCrusherBagQTests[packet:PacketP[Object[Item,TabletCrusherBag]]]:={

};


(* ::Subsection::Closed:: *)
(*validItemTweezerQTests*)


validItemTweezerQTests[packet:PacketP[Object[Item,Tweezer]]]:={};



(* ::Subsection::Closed:: *)
(*validItemViperMountingToolQTests*)


validItemViperMountingToolQTests[packet:PacketP[Object[Item,ViperMountingTool]]]:={};


(* ::Subsection::Closed:: *)
(*validItemFaceShieldQTests*)


validItemFaceShieldQTests[packet:PacketP[Object[Item,FaceShield]]]:={};


(* ::Subsection::Closed:: *)
(*validItemHeatGunQTests*)


validItemHeatGunQTests[packet:PacketP[Object[Item,HeatGun]]]:={};


(* ::Subsection::Closed:: *)
(*validItemGloveQTests*)


validItemGloveQTests[packet:PacketP[Object[Item,Glove]]]:={};


(* ::Subsection::Closed:: *)
(*validItemWeightHandleQTests*)


validItemWeightHandleQTests[packet:PacketP[Object[Item,WeightHandle]]]:={};


(* ::Subsection::Closed:: *)
(*validItemWrenchQTests*)


validItemWrenchQTests[packet:PacketP[Object[Item,Wrench]]]:={};


(* ::Subsection::Closed:: *)
(*validItemGCColumnWaferQTests*)


validItemGCColumnWaferQTests[packet:PacketP[Object[Item,GCColumnWafer]]]:= {};


(* ::Subsection::Closed:: *)
(*validItemGrindingBeadQTests*)


validItemGrindingBeadQTests[packet:PacketP[Object[Item, GrindingBead]]]:= {};


(* ::Subsection::Closed:: *)
(*validItemSwagingToolQTests*)


validItemSwagingToolQTests[packet:PacketP[Object[Item,SwagingTool]]]:= {};


(* ::Subsection::Closed:: *)
(*validItemMagnifyingGlassQTests*)


validItemMagnifyingGlassQTests[packet:PacketP[Object[Item,MagnifyingGlass]]]:={};


(* ::Subsection::Closed:: *)
(*validItemCartridgeDNASequencingQTests*)


validItemCartridgeDNASequencingQTests[packet:PacketP[Object[Item,Cartridge,DNASequencing]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {
		TransfersOut
	}
	],


	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Model,
		Product,
		DateStocked
	}],

	(* Other tests *)
	Test["NumberOfUses should be informed if Status is anything other than Stocked or InUse:",
		Lookup[packet,{NumberOfUses,Status}],
		Alternatives[
			{Null|0,Stocked},
			{_,InUse|Discarded},
			{Except[Null|0],Except[Stocked|InUse|Discarded]}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validItemCartridgeProteinCapillaryElectrophoresisQTests*)


validItemCartridgeProteinCapillaryElectrophoresisQTests[packet:PacketP[Object[Item,Cartridge,ProteinCapillaryElectrophoresis]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {TransfersOut,Volume}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{Model,MaxNumberOfUses,Expires}],

	(* Other Tests - can be larger than log because instrument can automatically reinject when issues arise *)
	Test["NumberOfUses should be equal to or larger than length of InjectionLog:",
		If[MatchQ[Lookup[packet,Status],Except[InUse]],
			((Lookup[packet,NumberOfUses]) /. {Null -> 0}) === Length[Download[Lookup[packet, InjectionLog]]],
			True
		],
		True
	],

	(*Min/Max voltage sanity check*)
	FieldComparisonTest[packet, {MinVoltage, MaxVoltage}, LessEqual],

	(*Min/max sample volume sanity check*)
	FieldComparisonTest[packet, {MinAssayVolume, MaxAssayVolume}, LessEqual],

	(*Min/max pI/MW sanity check*)
	FieldComparisonTest[packet, {MinIsoelectricPointCIEF, MaxIsoelectricPointCIEF}, LessEqual],
	FieldComparisonTest[packet, {MinMolecularWeightCESDS, MaxMolecularWeightCESDS}, LessEqual]

};



(* ::Subsection::Closed:: *)
(*validItemInoculationPaperQTests*)


validItemInoculationPaperQTests[packet:PacketP[Object[Item,InoculationPaper]]]:={

	(* Shared fields which should be null *)

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Model,
		Product,
		DateStocked,
		Shape
	}],


	(*If paper is Disk shape, diameter must be specified*)
	Test["Diameter must be specified if and only if shape is Disk:",
		Lookup[packet,{Shape,Diameter}],
		Alternatives[{Disk,Except[Null]},{Except[Disk],Null}]
	]

};



(* ::Subsection::Closed:: *)
(*validItemCartridgeDesiccantQTests*)


validItemCartridgeDesiccantQTests[packet:PacketP[Object[Item,Cartridge,Desiccant]]]:={

	NotNullFieldTest[packet,{
		Rechargeable
	}],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},Greater],

	(* Check that a pair of indicator colors are given *)
	RequiredTogetherTest[packet,{InitialIndicatorColor,ExhaustedIndicatorColor}]

};


(* ::Subsection:: *)
(*validItemConsumableWickQTests*)


validItemConsumableWickQTests[packet:PacketP[Object[Item,Consumable,Wick]]]:={};


(* ::Subsection::Closed:: *)
(*validItemMagnetizationRackQTests*)


validItemMagnetizationRackQTests[packet:PacketP[Object[Item,MagnetizationRack]]]:={};


(* ::Subsection::Closed:: *)
(*validItemPinchValveCoverQTests*)


validItemPinchValveCoverQTests[packet:PacketP[Object[Item,PinchValveCover]]]:={};


(* ::Subsection::Closed:: *)
(*validItemPlierQTests*)


validItemPlierQTests[packet:PacketP[Object[Item,Plier]]]:={};


(* ::Subsection:: *)
(*validItemDeliveryNeedleQTests*)


validItemDeliveryNeedleQTests[packet:PacketP[Object[Item,DeliveryNeedle]]]:={
	NotNullFieldTest[packet, {
		DeliveryTipDimensions
	}]
};


(* ::Subsection:: *)
(*validItemSupportRodQTests*)


validItemSupportRodQTests[packet:PacketP[Object[Item,SupportRod]]]:={
};


(* ::Subsection:: *)
(*validItemWasherQTests*)


validItemWasherQTests[packet:PacketP[Object[Item,Washer]]]:={
	NotNullFieldTest[packet, {
		InnerDiameter
	}]
};

(* ::Subsection:: *)
(*validItemCalibrationDistanceBlock*)
validItemCalibrationDistanceBlockQTests[packet:PacketP[Object[Item,CalibrationDistanceBlock]]]:={
	NotNullFieldTest[packet, {
		PreciseDimensions
	}]
};
(* ::Subsection:: *)
(*validItemWilhelmyPlateQTests*)


validItemWilhelmyPlateQTests[packet:PacketP[Object[Item,WilhelmyPlate]]]:={
	Test["If WettedLength of model is known, it should be populated and the same in the object:",
		Module[{modelWettedLength},
			modelWettedLength=Download[Lookup[packet,Model],WettedLength];
			If[NullQ[modelWettedLength],
				True,
				SameQ[Lookup[packet,WettedLength],modelWettedLength]
			]
		],
		True
	]
};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Item],validItemQTests];
registerValidQTestFunction[Object[Item,ArrayCardSealer],validItemArrayCardSealerQTests];
registerValidQTestFunction[Object[Item,BLIProbe],validItemBLIProbeQTests];
registerValidQTestFunction[Object[Item, Consumable],validItemConsumableQTests];
registerValidQTestFunction[Object[Item, Cap, ElectrodeCap], validItemCapElectrodeCapQTests];
registerValidQTestFunction[Object[Item, Cap, ElectrodeCap, CalibrationCap], validItemCapElectrodeCapCalibrationCapQTests];
registerValidQTestFunction[Object[Item,CalibrationDistanceBlock],validItemCalibrationDistanceBlockQTests];
registerValidQTestFunction[Object[Item,LidSpacer],validItemLidSpacerQTests];
registerValidQTestFunction[Object[Item,Column],validItemColumnQTests];
registerValidQTestFunction[Object[Item,ColumnHolder],validItemColumnHolderQTests];
registerValidQTestFunction[Object[Item,Consumable,Blade],validItemConsumableBladeQTests];
registerValidQTestFunction[Object[Item,Consumable,Sandpaper],validItemConsumableSandpaperQTests];
registerValidQTestFunction[Object[Item,CrossFlowFilter],validItemCrossFlowFilterQTests];
registerValidQTestFunction[Object[Item,Filter],validItemFilterQTests];
registerValidQTestFunction[Object[Item,Filter,MicrofluidicChip],validItemFilterMicrofluidicChipQTests];
registerValidQTestFunction[Object[Item,Gel],validItemGelQTests];
registerValidQTestFunction[Object[Item,Needle],validItemNeedleQTests];
registerValidQTestFunction[Object[Item,Plunger],validItemPlungerQTests];
registerValidQTestFunction[Object[Item,Tips],validItemTipsQTests];
registerValidQTestFunction[Object[Item,Ruler],validItemRulerQTests];
registerValidQTestFunction[Object[Item,BoxCutter],validItemBoxCutterQTests];
registerValidQTestFunction[Object[Item,CalibrationWeight],validItemCalibrationWeightQTests];
registerValidQTestFunction[Object[Item,CalibrationDistanceBlock],validItemCalibrationDistanceBlockQTests];
registerValidQTestFunction[Object[Item,Clamp],validItemClampQTests];
registerValidQTestFunction[Object[Item,Counterweight],validItemCounterweightQTests];
registerValidQTestFunction[Object[Item, Electrode],validItemElectrodeQTests];
registerValidQTestFunction[Object[Item, Electrode, ReferenceElectrode],validItemElectrodeReferenceElectrodeQTests];
registerValidQTestFunction[Object[Item, ElectrodePolishingPad], validItemElectrodePolishingPadQTests];
registerValidQTestFunction[Object[Item, ElectrodePolishingPlate], validItemElectrodePolishingPlateQTests];
registerValidQTestFunction[Object[Item,IceScraper],validItemIceScraperQTests];
registerValidQTestFunction[Object[Item,InoculationPaper],validItemInoculationPaperQTests];
registerValidQTestFunction[Object[Item,FloorMat],validItemFloorMatQTests];
registerValidQTestFunction[Object[Item,PlateSealRoller],validItemPlateSealRollerQTests];
registerValidQTestFunction[Object[Item, Rod],validItemRodQTests];
registerValidQTestFunction[Object[Item,RubberMallet],validItemRubberMalletQTests];
registerValidQTestFunction[Object[Item,Screwdriver],validItemScrewdriverQTests];
registerValidQTestFunction[Object[Item,ScrewdriverBit],validItemScrewdriverBitQTests];
registerValidQTestFunction[Object[Item,SequencingCartridge],validItemSequencingCartridgeQTests];
registerValidQTestFunction[Object[Item, TabletCutter], validItemTabletCutterQTests];
registerValidQTestFunction[Object[Item, TabletCrusher], validItemTabletCrusherQTests];
registerValidQTestFunction[Object[Item, TabletCrusherBag], validItemTabletCrusherBagQTests];
registerValidQTestFunction[Object[Item,Tweezer],validItemTweezerQTests];
registerValidQTestFunction[Object[Item,ViperMountingTool],validItemViperMountingToolQTests];
registerValidQTestFunction[Object[Item,FaceShield],validItemFaceShieldQTests];
registerValidQTestFunction[Object[Item,HeatGun],validItemHeatGunQTests];
registerValidQTestFunction[Object[Item,Glove],validItemGloveQTests];
registerValidQTestFunction[Object[Item,WeightHandle],validItemWeightHandleQTests];
registerValidQTestFunction[Object[Item,Wrench],validItemWrenchQTests];
registerValidQTestFunction[Object[Item,DialysisMembrane],validItemDialysisMembraneQTests];
registerValidQTestFunction[Object[Item, GCColumnWafer],validItemGCColumnWaferQTests];
registerValidQTestFunction[Object[Item, GrindingBead],validItemGrindingBeadQTests];
registerValidQTestFunction[Object[Item, SwagingTool],validItemSwagingToolQTests];
registerValidQTestFunction[Object[Item,Cartridge],validItemCartridgeQTests];
registerValidQTestFunction[Object[Item,Cartridge,Column],validItemCartridgeColumnQTests];
registerValidQTestFunction[Object[Item,Cartridge,DNASequencing],validItemCartridgeDNASequencingQTests];
registerValidQTestFunction[Object[Item,Cartridge,ProteinCapillaryElectrophoresis],validItemCartridgeProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Object[Item,Cartridge,Desiccant],validItemCartridgeDesiccantQTests];
registerValidQTestFunction[Object[Item,Consumable,Wick],validItemConsumableWickQTests];
registerValidQTestFunction[Object[Item,MagnifyingGlass],validItemMagnifyingGlassQTests];
registerValidQTestFunction[Object[Item,MagnetizationRack],validItemMagnetizationRackQTests];
registerValidQTestFunction[Object[Item,PinchValveCover],validItemPinchValveCoverQTests];
registerValidQTestFunction[Object[Item, Plier],validItemPlierQTests];
registerValidQTestFunction[Object[Item, DeliveryNeedle],validItemDeliveryNeedleQTests];
registerValidQTestFunction[Object[Item, SupportRod],validItemSupportRodQTests];
registerValidQTestFunction[Object[Item, Washer],validItemWasherQTests];
registerValidQTestFunction[Object[Item, WilhelmyPlate],validItemWilhelmyPlateQTests];

registerValidQTestFunction[Object[Item,Cap],validCoverObjectsQTests];
registerValidQTestFunction[Object[Item,PlateSeal],validCoverObjectsQTests];
registerValidQTestFunction[Object[Item,Septum],validCoverObjectsQTests];
registerValidQTestFunction[Object[Item,Lid],validCoverObjectsQTests];
registerValidQTestFunction[Object[Item,Stopper],validCoverObjectsQTests];

