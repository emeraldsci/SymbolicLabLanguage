(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validPartQTests*)


validPartQTests[packet:PacketP[Object[Part]]]:= Module[
	{modelPacket, productPacket},

	{modelPacket, productPacket}=If[
		MatchQ[Lookup[packet, {Model, Product}], {Null, Null}],
		{Null, Null},
		Download[Lookup[packet, Object], {Model[All], Product[All]}]];

	{

		(* General fields filled in *)
		NotNullFieldTest[
			packet,
			{
				Model,
				Status
			}
		],

		(* Expiration date tests*)
		Test["If DateStocked is informed and the model of the part has ShelfLife informed, then ExpirationDate must be informed:",
			{
				And[
					Not[NullQ[Lookup[packet,DateStocked]]],
					Not[NullQ[modelPacket]],
					Not[NullQ[modelPacket[ShelfLife]]]
				],
				Lookup[packet,ExpirationDate]
			},
			Alternatives[{True, Except[NullP]},{Except[True], _}]
		],

		Test["If UnsealedShelfLife is informed and the model of the part has DateUnsealed informed , then ExpirationDate must be informed:",
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

		Test["If DateUnsealed is informed, it is in the past:",
			Lookup[packet,DateUnsealed],
			_?(#<=Now &)|Null
		],

		Test["If DateDiscarded is informed, it is in the past:",
			Lookup[packet,DateDiscarded],
			_?(#<=Now &)|Null
		],

		FieldComparisonTest[packet,{DateDiscarded,DateUnsealed},GreaterEqual],
		FieldComparisonTest[packet,{DateUnsealed,DateStocked},GreaterEqual],
		FieldComparisonTest[packet,{ExpirationDate,DateUnsealed},GreaterEqual],

		Test["DateDiscarded is informed if only if Status is Discarded, unless Part is InUse in an Object[Maintenance[Handwash]] or Object[Maintenance[Dishwash]]:",
			Lookup[packet,{DateDiscarded,Status,CurrentProtocol}],
			{Except[Null],Discarded,_}|{Except[Null],InUse,ObjectP[{Object[Maintenance,Handwash],Object[Maintenance,Dishwash]}]}|{NullP,Except[Discarded],_}
		],

		Test["If the Status of the part is Stocked, DateDiscarded and DateUnsealed must be Null:",
			Lookup[packet,{Status,DateDiscarded,DateUnsealed}],
			{Stocked,Null,Null}|{Except[Stocked],_,_}
		],

		Test["If the Status of the part is Available, DateUnsealed must be informed:",
			Lookup[packet,{Status,DateUnsealed}],
			{Available,Except[Null]}|{Except[Available],_}
		],

		Test["The last entry in LocationLog matches the current Position and Container:",
			Module[
				{position,container,locLog},
				{position,container,locLog} = Lookup[packet,{Position,Container,LocationLog}];

				MatchQ[
					{Last[locLog][[3]][Object],Last[locLog][[4]]},
					{container[Object],position}
				]
			],
			True
		],

		Test["Parts with CleaningMethod DishwashIntensive must have their Product field informed:",
			{modelPacket[CleaningMethod],Lookup[packet,Product]},
			Alternatives[
				{DishwashIntensive,LinkP[Object[Product]]},
				{Except[DishwashIntensive],_}
			]
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

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the part:",
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

		Test["The last entry in DisposalLog matches the current AwaitingDisposal:",
			{If[Lookup[packet,DisposalLog]=={},Null,Last[Lookup[packet,DisposalLog]][[2]]],Lookup[packet,AwaitingDisposal]},
			Alternatives[
				{True, True},
				{False|Null, False|Null}
			]
		],

		Test["If Status is not Discarded, Site is filled out:",
			Lookup[packet,{Status,Site}],
			{Discarded,_}|{Except[Discarded],Except[NullP]}
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
					MatchQ[Lookup[productPacket, KitComponents], (Null | {})],
					True,

					(* product is a kit but KitComponents in the Object are not populated *)
					MatchQ[Lookup[productPacket, KitComponents], Except[Null | {}]] && MatchQ[Lookup[packet, KitComponents], (Null | {})],
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
(*validPartCrimpingJigQTests*)


validPartCrimpingJigQTests[packet:PacketP[Object[Part,CrimpingJig]]]:={};


(* ::Subsection::Closed:: *)
(*validPartCrimpingHeadQTests*)


validPartCrimpingHeadQTests[packet:PacketP[Object[Part,CrimpingHead]]]:={};



(* ::Subsection::Closed:: *)
(*validPartDecrimpingHeadQTests*)


validPartDecrimpingHeadQTests[packet:PacketP[Object[Part,DecrimpingHead]]]:={};



(* ::Subsection::Closed:: *)
(*validPartAlignmentToolQTests*)


validPartAlignmentToolQTests[packet:PacketP[Object[Part,AlignmentTool]]]:={};



(* ::Subsection::Closed:: *)
(*validPartHexKeyQTests*)


validPartHexKeyQTests[packet:PacketP[Object[Part,HexKey]]]:={};



(* ::Subsection::Closed:: *)
(*validPartAspiratorAdapterQTests*)


validPartAspiratorAdapterQTests[packet:PacketP[Object[Part,AspiratorAdapter]]]:={
};


(* ::Subsection:: *)
(*validPartApertureTubeQTests*)


validPartApertureTubeQTests[packet:PacketP[Object[Part,ApertureTube]]]:={

	(* fields that should not be null *)
	NotNullFieldTest[packet,{
		Connectors
	}],

	(* fields that should be null *)
	NullFieldTest[packet,{
		WiringConnectors,
		WiringLength,
		WiringLengthLog,
		WiringDiameters,
		WiringConnections,
		WiringConnectionLog
	}]
};




(* ::Subsection::Closed:: *)
(*validPartBalanceQTests*)


validPartBalanceQTests[packet:PacketP[Object[Part,Balance]]]:={

	NotNullFieldTest[packet,{
		Instrument,
		Manufacturer,
		UserManualFiles,
		Resolution,
		MaxWeight,
		MinWeight
	}]
};



(* ::Subsection::Closed:: *)
(*validPartHandPumpQTests*)


validPartHandPumpQTests[packet:PacketP[Object[Part,HandPump]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartBeamStopQTests*)


validPartBeamStopQTests[packet:PacketP[Object[Part,BeamStop]]]:={};



(* ::Subsection::Closed:: *)
(*validPartBarcodeReaderQTests*)


validPartBarcodeReaderQTests[packet:PacketP[Object[Part,BarcodeReader]]]:={};



(* ::Subsection::Closed:: *)
(*validPartBackdropQTests*)


validPartBackdropQTests[packet:PacketP[Object[Part,Backdrop]]]:={};



(* ::Subsection::Closed:: *)
(*validPartBLIPlateCoverQTests*)


validPartBLIPlateCoverQTests[packet:PacketP[Object[Part, BLIPlateCover]]] := {};


(* ::Subsection::Closed:: *)
(*validPartBristlePlateQTests*)


validPartBristlePlateQTests[packet:PacketP[Object[Part, BristlePlate]]] := {};


(* ::Subsection::Closed:: *)
(*validPartCameraQTests*)


validPartCameraQTests[packet:PacketP[Object[Part,Camera]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			Model,
			Status
		}
	],

	(* tests for cameras that are compatible with the ECL sensor array if they are not stocked *)
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, EmbeddedPC must be informed:",
			Lookup[packet,{Model, Status, EmbeddedPC}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], ObjectP[Object[Part, EmbeddedPC]]},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, PLCVariableName must be informed:",
			Lookup[packet,{Model, Status, PLCVariableName}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], _String},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, IP must be informed:",
			Lookup[packet,{Model, Status, IP}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], _String},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, PostRotation must be informed:",
			Lookup[packet,{Model, Status, PostRotation}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], RangeP[Quantity[-360, "Degrees"], Quantity[360, "Degrees"]]},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, Name must be informed:",
			Lookup[packet,{Model, Status, Name}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], _String},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, FieldOfView must be informed:",
			Lookup[packet,{Model, Status, FieldOfView}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], CameraFieldOfViewP},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, Illumination must be informed:",
			Lookup[packet,{Model, Status, Illumination}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], IlluminationDirectionP},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		],
		Test[
			"If it is an ECL Sensor Array and Status is not Stocked, ExposureTime must be informed:",
			Lookup[packet,{Model, Status, ExposureTime}],
				Alternatives
				[
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Except[Stocked], GreaterP[0*Second]},
					{ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}], Stocked, _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Except[Stocked], _},
					{Except[ObjectP[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:BYDOjvGp9Zlm"], Model[Part, Camera, "id:vXl9j5WmejzD"], Model[Part, Camera, "id:M8n3rx0dZmWM"], Model[Part, Camera, "id:9RdZXv1e3dAl"]}]], Stocked, _}
				]
		]
};


(* ::Subsection::Closed:: *)
(*validPartCalibrationCardQTests*)


validPartCalibrationCardQTests[packet:PacketP[Object[Part,CalibrationCard]]]:={};



(* ::Subsection::Closed:: *)
(*validPartCapillaryELISATestCartridgeQTests*)


validPartCapillaryELISATestCartridgeQTests[packet:PacketP[Object[Part,CapillaryELISATestCartridge]]]:={

	(*shared fields not null*)
	NotNullFieldTest[packet,{Model,SerialNumber}],

	(*unique fields not null*)
	NotNullFieldTest[packet,{SupportedInstrument}]

};


(* ::Subsection::Closed:: *)
(*validPartCapillaryELISATestCartridgeQTests*)

(* ::Subsection::Closed:: *)
(*validPartCapillaryArrayQTests*)


validPartCapillaryArrayQTests[packet:PacketP[Object[Part,CapillaryArray]]]:={

	(*shared fields not null*)
	NotNullFieldTest[packet,{Model,SerialNumber}],

	(*unique fields not null*)
	NotNullFieldTest[packet,{Instrument,NumberOfCapillaries,CapillaryArrayLength}]

};


validPartCentrifugeAdapterQTests[packet:PacketP[Object[Part,CentrifugeAdapter]]]:={};



(* ::Subsection::Closed:: *)
(*validPartCheckValveQTests*)


validPartCheckValveQTests[packet:PacketP[Object[Part,CheckValve]]]:={};


(* ::Subsection::Closed:: *)
(*validPartColonyHandlerHeadCassetteQ*)


validPartColonyHandlerHeadCasseteQTests[packet:PacketP[Object[Part,ColonyHandlerHeadCassette]]]:={

	NotNullFieldTest[
		packet,
		{
			ColonyHandlerHeadCassetteHolder
		}
	],

	Test["The ColonyHandlerHeadCassette of the ColonyHandlerHeadCassetteHolder must be this object",
		MatchQ[
			Download[Lookup[packet,ColonyHandlerHeadCassetteHolder,Null],ColonyHandlerHeadCassette[Object]],
			ObjectP[Lookup[packet,Object]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validPartShakerAdapterQTests*)


validPartShakerAdapterQTests[packet:PacketP[Object[Part,ShakerAdapter]]]:={};



(* ::Subsection::Closed:: *)
(*validPartChillerQTests*)


validPartChillerQTests[packet:PacketP[Object[Part,Chiller]]]:={
	NotNullFieldTest[packet, {Instrument}]
};


(* ::Subsection:: *)
(*validPartComputerQTests*)


validPartComputerQTests[packet:PacketP[Object[Part,Computer]]]:={

	Test["Is FullyQualifiedDomainName informed?",
		MatchQ[Lookup[packet, FullyQualifiedDomainName], _String], True
	],

	Test["Is Hostname informed?",
		MatchQ[Lookup[packet, Hostname], _String], True
	],

	Test["Does the FullyQualifiedDomainName contain the correct Hostname and correct site network domain?",
		MatchQ[Lookup[packet, FullyQualifiedDomainName], StringJoin[Lookup[packet, Hostname],Lookup[packet, Site][NetworkDomain]]], True
	],

	Test["If the computer is an InstrumentComputer, is the Instruments field informed with at least one element?",
		If[MatchQ[Lookup[packet, Model][ComputerType], InstrumentComputer],
			MatchQ[Lookup[packet, Instruments], {_Link..}], Null], (True|Null)
		],

	Test["If the computer is an InstrumentComputer, is the VirtualNetworkConnection field informed?",
			If[MatchQ[Lookup[packet, Model][ComputerType], InstrumentComputer],
				MatchQ[Lookup[packet, VirtualNetworkConnection], _Link], Null], (True|Null)
		],
	Test["If the computer is an TabletComputer, is the WiringConnectors field informed?",
		If[MatchQ[Lookup[packet, Model][ComputerType], TabletComputer],
			MatchQ[Lookup[packet, WiringConnectors], Except[{}]], Null], (True|Null)
	]

};


(* ::Subsection::Closed:: *)
(*validPartConductivityProbeQTests*)


validPartConductivityProbeQTests[packet:PacketP[Object[Part,ConductivityProbe]]]:={};



(* ::Subsection::Closed:: *)
(*validPartConductivitySensorQTests*)


validPartConductivitySensorQTests[packet:PacketP[Object[Part,ConductivitySensor]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[
		packet,
		{
			Model,
			NominalCellConstant,
			Connectors
		}
	]
};



(* ::Subsection::Closed:: *)
(*validDecrimperQTests*)


validDecrimperQTests[packet:PacketP[Object[Part,Decrimper]]]:={
};

(* ::Subsection::Closed:: *)
(*validCrimperQTests*)


validCrimperQTests[packet:PacketP[Object[Part,Crimper]]]:={
};

(* ::Subsection::Closed:: *)
(*validDeionizerQTests*)


validDeionizerQTests[packet:PacketP[Object[Part,Deionizer]]]:={
};

(* ::Subsection::Closed:: *)
(*validPartDialysisClipQTests*)


validPartDialysisClipQTests[packet:PacketP[Object[Part,DialysisClip]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartElectrodePolishingPlateQTests*)


validPartElectrodePolishingPlateQTests[packet:PacketP[Object[Part, ElectrodePolishingPlate]]] := {
};



(* ::Subsection::Closed:: *)
(*validPartElectrodeRackQTests*)


validPartElectrodeRackQTests[packet:PacketP[Object[Part, ElectrodeRack]]] := {
};



(* ::Subsection::Closed:: *)
(*validPartElectrochemicalReactionVesselHolderQTests*)


validPartElectrochemicalReactionVesselHolderQTests[packet:PacketP[Object[Part, ElectrochemicalReactionVesselHolder]]] := {
};



(* ::Subsection::Closed:: *)
(*validPartEluentGeneratorQTests*)


validPartEluentGeneratorQTests[packet:PacketP[Object[Part,EluentGenerator]]]:={
	NotNullFieldTest[packet,{Instrument}]
};



(* ::Subsection::Closed:: *)
(*validPartHeatExchangerQTests*)


validPartHeatExchangerQTests[packet:PacketP[Object[Part,HeatExchanger]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[
		packet,
		{
			SerialNumber
		}
	]
};


(* ::Subsection::Closed:: *)
(*validPartHexKeyQTests*)


validPartHexKeyQTests[packet:PacketP[Object[Part,HexKey]]]:={};


(* ::Subsection::Closed:: *)
(*validPartInformationTechnologyQTests*)


validPartInformationTechnologyQTests[packet:PacketP[Object[Part,InformationTechnology]]]:={};


(* ::Subsection::Closed:: *)
(*validPartFerruleQTests*)


validPartFerruleQTests[packet:PacketP[Object[Part,Ferrule]]]:={};


(* ::Subsection::Closed:: *)
(*validPartFilterQTests*)


validPartFilterQTests[packet:PacketP[Object[Part,Filter]]]:={
	AnyInformedTest[packet, {SerialNumber, BatchNumber}]
};


(* ::Subsection::Closed:: *)
(*validPartFilterAdapterQTests*)


validPartFilterAdapterQTests[packet:PacketP[Object[Part, FilterAdapter]]]:={};




(* ::Subsection::Closed:: *)
(*validPartFlowCellQTests*)


validPartFlowCellQTests[packet:PacketP[Object[Part,FlowCell]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartFlowRestrictorQTests*)


validPartFlowRestrictorQTests[packet:PacketP[Object[Part,FlowRestrictor]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartFunnelQTests*)


validPartFunnelQTests[packet:PacketP[Object[Part,Funnel]]]:={};


(* ::Subsection::Closed:: *)
(*validPartFurnitureEquipmentQTests*)


validPartFurnitureEquipmentQTests[packet:PacketP[Object[Part,FurnitureEquipment]]]:={};


(* ::Subsection::Closed:: *)
(*validPartLampQTests*)


validPartLampQTests[packet:PacketP[Object[Part,Lamp]]]:={
	AnyInformedTest[packet, {SerialNumber, BatchNumber}]
};


(* ::Subsection::Closed:: *)
(*validPartLaserQTests*)


validPartLaserQTests[packet:PacketP[Object[Part,Laser]]]:={};


(* ::Subsection::Closed:: *)
(*validPartNeedleLockingScrew*)


validPartNeedleLockingScrew[packet:PacketP[Object[Part,NeedleLockingScrew]]]:={};


(* ::Subsection::Closed:: *)
(*validPartNMRDepthGaugeQTests*)


validPartNMRDepthGaugeQTests[packet:PacketP[Object[Part,NMRDepthGauge]]]:={};


(* ::Subsection::Closed:: *)
(*validPartNozzleQTests*)


validPartNozzleQTests[packet:PacketP[Object[Part,Nozzle]]]:={};



(* ::Subsection::Closed:: *)
(*validPartNutQTests*)


validPartNutQTests[packet:PacketP[Object[Part,Nut]]]:={};


(* ::Subsection::Closed:: *)
(*validPartMeterModuleQTests*)


validPartMeterModuleQTests[packet:PacketP[Object[Part,MeterModule]]]:={};



(* ::Subsection::Closed:: *)
(*validPartMixerQTests*)


validPartMixerQTests[packet:PacketP[Object[Part,Mixer]]]:={};




(* ::Subsection::Closed:: *)
(*validPartObjectiveQTests*)


validPartObjectiveQTests[packet:PacketP[Object[Part,Objective]]]:={};


(* ::Subsection::Closed:: *)
(*validPartOpticalFilterQTests*)


validPartOpticalFilterQTests[packet:PacketP[Object[Part,OpticalFilter]]]:={};


(* ::Subsection::Closed:: *)
(*validPartOpticModuleQTests*)


validPartOpticModuleQTests[packet:PacketP[Object[Part,OpticModule]]]:={
	NotNullFieldTest[packet,SerialNumber]
};



(* ::Subsection::Closed:: *)
(*validPartInverterQTests*)


validPartInverterQTests[packet:PacketP[Object[Part,Inverter]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartPeristalticPumpQTests*)


validPartPeristalticPumpQTests[packet:PacketP[Object[Part,PeristalticPump]]]:={

	NotNullFieldTest[packet,{
		Instrument,
		Manufacturer,
		UserManualFiles,
		TubingType,
		MinFlowRate,
		MaxFlowRate
	}]
};



(* ::Subsection::Closed:: *)
(*validPartVacuumPumpQTests*)


validPartVacuumPumpQTests[packet:PacketP[Object[Part,VacuumPump]]]:={

	NotNullFieldTest[packet,{
		Manufacturer
	}]
};


(* ::Subsection::Closed:: *)
(*validPartpHProbeQTests*)


validPartpHProbeQTests[packet:PacketP[Object[Part,pHProbe]]]:={
	If[MatchQ[Lookup[packet,Status],Installed],
		NotNullFieldTest[packet,{Reservoir, StorageContainer}],
		Nothing
	]
};



(* ::Subsection::Closed:: *)
(*validPartPistonQTests*)


validPartPistonQTests[packet:PacketP[Object[Part,Piston]]]:={};



(* ::Subsection::Closed:: *)
(*validPartPressureSensorQTests*)


validPartPressureSensorQTests[packet:PacketP[Object[Part,PressureSensor]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[
		packet,
		{
			Model,
			Connectors
		}
	]
};


(* ::Subsection::Closed:: *)
(*UniversalInterfaceConverter*)


validPartUniversalInterfaceConverterQTests[packet:PacketP[Object[Part,UniversalInterfaceConverter]]] := {};



(* ::Subsection::Closed:: *)
(*validPartPowerDistributionUnitQTests*)


validPartPowerDistributionUnitQTests[packet:PacketP[Object[Part,PowerDistributionUnit]]] := {

	Test["If the Status of the part is Available, IP must be informed:",
		Lookup[packet,{Status,IP}],
		{Available,Except[Null]}|{Except[Available],_}
	],

	Test["If the Status of the part is Available, ConnectedInstruments must be informed:",
		Lookup[packet,{Status,ConnectedInstruments}],
		{Available,Except[{}]}|{Except[Available],_}
	]
};


(* ::Subsection::Closed:: *)
(*validPartSpectrophotometerQTests*)


validPartSpectrophotometerQTests[packet:PacketP[Object[Part,Spectrophotometer]]]:={
	NotNullFieldTest[
		packet,
		{
			LampType,
			LightSourceType,
			BeamOffset,
			MinMonochromator,
			MaxMonochromator,
			MonochromatorBandpass,
			MinAbsorbance,
			MaxAbsorbance,
			ElectromagneticRange
		}
	]
};





(* ::Subsection::Closed:: *)
(*validPartStirBarQTests*)


validPartStirBarQTests[packet:PacketP[Object[Part,StirBar]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartStirBarRetrieverQTests*)


validPartStirBarRetrieverQTests[packet:PacketP[Object[Part,StirBarRetriever]]]:={
};


(* ::Subsection::Closed:: *)
(*validPartStirrerShaftQTests*)


validPartStirrerShaftQTests[packet:PacketP[Object[Part,StirrerShaft]]]:={};


(* ::Subsection::Closed:: *)
(*validPartSonicationHornQTests*)


validPartSonicationHornQTests[packet:PacketP[Object[Part,SonicationHorn]]]:={};


(* ::Subsection::Closed:: *)
(*validPartDispensingHeadQTests*)


validPartDispensingHeadQTests[packet:PacketP[Object[Part,DispensingHead]]]:={
	NotNullFieldTest[
		packet,
		{
			VolumeSensor
		}
	]
};



(*validPartFittingQTests*)


(* ::Subsection::Closed:: *)
(*validPartFittingQTests*)


validPartFittingQTests[packet:PacketP[Object[Part,Fitting]]]:={};



(* ::Subsection::Closed:: *)
(*validPartSealQTests*)


validPartSealQTests[packet:PacketP[Object[Part,Seal]]]:={};



(* ::Subsection::Closed:: *)
(*validPartSensornetQTests*)


validPartSensornetQTests[packet:PacketP[Object[Part,Sensornet]]]:={};


(* ::Subsection::Closed:: *)
(*validPartSpigotQTests*)


validPartSpigotQTests[packet:PacketP[Object[Part,Spigot]]]:={};


(* ::Subsection::Closed:: *)
(*validPartEmbeddedPCQTests*)


validPartEmbeddedPCQTests[packet:PacketP[Object[Part,EmbeddedPC]]]:={
	NotNullFieldTest[
		packet,
		{
			SerialNumber,
			TCPort,
			ADSAMSNetID,
			ADSRouteName,
			IP
		}
	]
};



(* ::Subsection::Closed:: *)
(*validPartSuppressorQTests*)


validPartSuppressorQTests[packet:PacketP[Object[Part,Suppressor]]]:={
	NotNullFieldTest[
		packet,
		{
			Instrument,
			FactoryRecommendedVoltage,
			MinCurrent,
			MaxCurrent,
			MinVoltage,
			MaxVoltage
		}
	]
};


(* ::Subsection::Closed:: *)
(*validPartSyringeQTests*)


validPartSyringeQTests[packet:PacketP[Object[Part,Syringe]]]:={
	AnyInformedTest[packet, {SerialNumber, BatchNumber}]
};


(* ::Subsection::Closed:: *)
(*validPartTemperatureProbeQTests*)


validPartTemperatureProbeQTests[packet:PacketP[Object[Part,TemperatureProbe]]] := {};


(* ::Subsection::Closed:: *)
(*validPartTensiometerProbeQTests*)


validPartTensiometerProbeQTests[packet:PacketP[Object[Part,TensiometerProbe]]] := {
	NotNullFieldTest[packet,SupportedInstruments],
	NullFieldTest[packet, SerialNumber]
};


(* ::Subsection::Closed:: *)
(*validPartTensiometerProbeQTests*)


validPartTensiometerProbeCleanerQTests[packet:PacketP[Object[Part,TensiometerProbeCleaner]]] := {
	NotNullFieldTest[packet,SupportedInstruments],
	NullFieldTest[packet, SerialNumber]
};


(* ::Subsection::Closed:: *)
(*validPartThermalBlockQTests*)


validPartThermalBlockQTests[packet:PacketP[Object[Part,ThermalBlock]]]:={};


(* ::Subsection::Closed:: *)
(*validPartViscometerChipQTests*)


validPartViscometerChipQTests[packet:PacketP[Object[Part,ViscometerChip]]] := {
	NotNullFieldTest[packet,SupportedInstruments],
	RequiredTogetherTest[packet,{UsageLog,NumberOfUses}]
};


(* ::Subsection::Closed:: *)
(*validPartHeatSinkQTests*)


validPartHeatSinkQTests[packet:PacketP[Object[Part,HeatSink]]]:={};



(* ::Subsection::Closed:: *)
(*validPartNMRProbeQTests*)


validPartNMRProbeQTests[packet:PacketP[Object[Part,NMRProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validPartAmpouleOpenerQTests*)


validPartAmpouleOpenerQTests[packet:PacketP[Object[Part,AmpouleOpener]]]:={
	NullFieldTest[packet,SerialNumber]
};


(* ::Subsection::Closed:: *)
(*validPartBackfillVentQTests*)


validPartBackfillVentQTests[packet:PacketP[Object[Part,BackfillVent]]]:={};



(* ::Subsection::Closed:: *)
(*validPartPressureRegulatorQTests*)


validPartPressureRegulatorQTests[packet:PacketP[Object[Part,PressureRegulator]]]:={};


(* ::Subsection::Closed:: *)
(*validPartFoamImagingModuleQTests*)


validPartFoamImagingModuleQTests[packet:PacketP[Object[Part,FoamImagingModule]]]:={};


(* ::Subsection::Closed:: *)
(*validPartFootPedalQTests*)

validPartFootPedalQTests[packet:PacketP[Object[Part,FootPedal]]]:={};



(* ::Subsection::Closed:: *)
(*validPartLiquidConductivityModuleQTests*)


validPartLiquidConductivityModuleQTests[packet:PacketP[Object[Part,DiodeArrayModule]]]:={};


(* ::Subsection::Closed:: *)
(*validPartDiodeArrayModuleQTests*)


validPartDiodeArrayModuleQTests[packet:PacketP[Object[Part,DiodeArrayModule]]]:={};


(* ::Subsection::Closed:: *)
(*validPartDockingStationQTests*)


validPartDockingStationQTests[packet:PacketP[Object[Part, DockingStation]]]:={};


(* ::Subsection::Closed:: *)
(*validPartORingQTests*)


validPartORingQTests[packet:PacketP[Object[Part,ORing]]]:={
	NotNullFieldTest[packet,Reusable]
};



(* ::Subsection::Closed:: *)
(*validPartSpargeFilterQTests*)


validPartSpargeFilterQTests[packet:PacketP[Object[Part,SpargeFilter]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartStirBladeQTests*)


validPartStirBladeQTests[packet:PacketP[Object[Part,StirBlade]]]:={
};



(* ::Subsection::Closed:: *)
(*validPartFillRodQTests*)


validPartFillRodQTests[packet:PacketP[Object[Part,FillRod]]]:={};



(* ::Subsection::Closed:: *)
(*validPartReferenceElectrodeQTests*)


validPartReferenceElectrodeQTests[packet:PacketP[Object[Part,ReferenceElectrode]]] := {};



(* ::Subsection:: *)
(*validPartRefrigerationUnitQTests*)


validPartRefrigerationUnitQTests[packet:PacketP[Object[Part,RefrigerationUnit]]]:={};



(* ::Subsection::Closed:: *)
(*validPartFanQTests*)


validPartFanQTests[packet:PacketP[Object[Part,Fan]]] := {};



(* ::Subsection::Closed:: *)
(*validPartFanFilterUnitQTests*)


validPartFanFilterUnitQTests[packet:PacketP[Object[Part,FanFilterUnit]]] := {};



(* ::Subsection::Closed:: *)
(*validPartGauzeHolderQTests*)


validPartGauzeHolderQTests[packet:PacketP[Object[Part,GauzeHolder]]] := {};



(* ::Subsection::Closed:: *)
(*validPartGrinderClampAssemblyQTests*)


validPartGrinderClampAssemblyQTests[packet:PacketP[Object[Part, GrinderClampAssembly]]] := {};


(* ::Subsection::Closed:: *)
(*validPartBLIPlateCoverQTests*)


validPartSolenoidValveQTests[packet:PacketP[Object[Part, SolenoidValve]]] := {};


(* ::Subsection:: *)
(*validPartLighterQTests*)


validPartLighterQTests[packet:PacketP[Object[Part, Lighter]]] := {};


(* ::Subsection:: *)
(*validPartLightObscurationSensorQTests*)


validPartLightObscurationSensorQTests[packet:PacketP[Object[Part, LightObscurationSensor]]] := {};


(* ::Subsection:: *)
(*validPartSmokeGeneratorQTests*)


validPartSmokeGeneratorQTests[packet:PacketP[Object[Part, SmokeGenerator]]] := {};


(* ::Subsection:: *)
(*validPartBrakeQTests*)


validPartBrakeQTests[packet:PacketP[Object[Part, Brake]]] := {};


(* ::Subsection:: *)
(*validPartBatteryQTests*)


validPartBatteryQTests[packet:PacketP[Object[Part, Battery]]] := {};


(* ::Subsection:: *)
(*validPartCartridgeCapQTests*)


validPartCartridgeCapQTests[packet:PacketP[Object[Part, CartridgeCap]]] := {};


(* ::Subsection:: *)
(*validPartRefractometerToolQTests*)


validPartRefractometerToolQTests[packet:PacketP[Object[Part, RefractometerTool]]] := {};


(* ::Subsection:: *)
(*validPartDryingCartridgeQTests*)


validPartDryingCartridgeQTests[packet:PacketP[Object[Part, DryingCartridge]]] := {};


(* ::Subsection:: *)
(*validPartAlarmQTests*)


validPartAlarmQTests[packet:PacketP[Object[Part, Alarm]]] := {};


(* ::Subsection:: *)
(*validPartFireAlarmActivatorQTests*)


validPartFireAlarmActivatorQTests[packet:PacketP[Object[Part, FireAlarmActivator]]] := {};



(* ::Subsection:: *)
(*validPartFireExtinguisherQTests*)


validPartFireExtinguisherQTests[packet:PacketP[Object[Part, FireExtinguisher]]] := {};



(* ::Subsection:: *)
(*validPartFirstAidKitQTests*)


validPartFirstAidKitQTests[packet:PacketP[Object[Part, FirstAidKit]]] := {};


(* ::Subsection:: *)
(*validPartFloodLightQTests*)


validPartFloodLightQTests[packet:PacketP[Object[Part, FloodLight]]] := {};


(* ::Subsection:: *)
(*validPartSafetyWashStationQTests*)


validPartSafetyWashStationQTests[packet:PacketP[Object[Part, SafetyWashStation]]] := {};


(* ::Subsection:: *)
(*validPartRespiratorQTests*)


validPartRespiratorQTests[packet:PacketP[Object[Part, Respirator]]] := {};


(* ::Subsection:: *)
(*validPartRespiratorFilterQTests*)


validPartRespiratorFilterQTests[packet:PacketP[Object[Part, RespiratorFilter]]] := {};



(* ::Subsection:: *)
(*validPartStickerPrinterQTests*)


validPartStickerPrinterQTests[packet:PacketP[Object[Part, StickerPrinter]]] := {};


(* ::Subsection:: *)
(*validPartSamplingProbeQTests*)


validPartSamplingProbeQTests[packet:PacketP[Object[Part, SamplingProbe]]] := {
	Test["If the Status of the part is Available, ConnectedInstruments must be informed:",
		Lookup[packet,{Status,ConnectedInstruments}],
		{Installed,Except[{}]}|{Except[Installed],_}
	],

	NotNullFieldTest[
		packet,
		{
			ProbeLength
		}
	]
};



(* ::Subsection:: *)
(*validPartDryingCartridgeQTests*)


validPartCuttingJigQTests[packet:PacketP[Object[Part,CuttingJig]]] := {
	NotNullFieldTest[packet,TubingCutters]
};



(* ::Subsection:: *)
(*validPartGravityRackPlatformQTests*)


validPartGravityRackPlatformQTests[packet:PacketP[Object[Part,GravityRackPlatform]]]:={
	NotNullFieldTest[packet,{
		GravityRackPlatformType
	}]
};



(* ::Subsection:: *)
(*validPartFlaskRingQTests*)


validPartFlaskRingQTests[packet:PacketP[Object[Part,FlaskRing]]]:={
	NotNullFieldTest[packet,{
		Aperture,
		Dimensions
	}]
};



(* ::Subsection:: *)
(*validPartPositioningPinQTests*)


validPartPositioningPinQTests[packet:PacketP[Object[Part,PositioningPin]]]:={
	NotNullFieldTest[packet,{
		Dimensions,
		PinBodyLength
	}]
};


(* ::Subsection:: *)
(*validPartTybeBlockQTests*)


validPartTybeBlockQTests[packet:PacketP[Model[Part, TubeBlock]]]:={};


(* ::Subsection:: *)
(*validKVMSwitchQTests*)


validKVMSwitchQTests[packet:PacketP[Object[Part, KVMSwitch]]] := {};


(* ::Subsection:: *)
(*validPartClampQTests*)


validPartClampQTests[packet:PacketP[Object[Part, Clamp]]] := {};


(* ::Subsection:: *)
(**)


(* Test Registration *)


registerValidQTestFunction[Object[Part],validPartQTests];
registerValidQTestFunction[Object[Part, Backdrop],validPartBackdropQTests];
registerValidQTestFunction[Object[Part, CalibrationCard],validPartCalibrationCardQTests];
registerValidQTestFunction[Object[Part, CrimpingJig],validPartCrimpingJigQTests];
registerValidQTestFunction[Object[Part, CrimpingHead],validPartCrimpingHeadQTests];
registerValidQTestFunction[Object[Part, DecrimpingHead],validPartDecrimpingHeadQTests];
registerValidQTestFunction[Object[Part, AlignmentTool],validPartAlignmentToolQTests];
registerValidQTestFunction[Object[Part, AspiratorAdapter],validPartAspiratorAdapterQTests];
registerValidQTestFunction[Object[Part, ApertureTube],validPartApertureTubeQTests];
registerValidQTestFunction[Object[Part, BackfillVent],validPartBackfillVentQTests];
registerValidQTestFunction[Object[Part, Balance],validPartBalanceQTests];
registerValidQTestFunction[Object[Part, BarcodeReader],validPartBarcodeReaderQTests];
registerValidQTestFunction[Object[Part, Battery],validPartBatteryQTests];
registerValidQTestFunction[Object[Part, CartridgeCap],validPartCartridgeCapQTests];
registerValidQTestFunction[Object[Part, BeamStop],validPartBeamStopQTests];
registerValidQTestFunction[Object[Part, Brake],validPartBrakeQTests];
registerValidQTestFunction[Object[Part, BLIPlateCover],validPartBLIPlateCoverQTests];
registerValidQTestFunction[Object[Part, BristlePlate],validPartBristlePlateQTests];
registerValidQTestFunction[Object[Part, Camera],validPartCameraQTests];
registerValidQTestFunction[Object[Part, CapillaryELISATestCartridge],validPartCapillaryELISATestCartridgeQTests];
registerValidQTestFunction[Object[Part, CapillaryArray],validPartCapillaryArrayQTests];
registerValidQTestFunction[Object[Part, CentrifugeAdapter],validPartCentrifugeAdapterQTests];
registerValidQTestFunction[Object[Part, CheckValve],validPartCheckValveQTests];
registerValidQTestFunction[Object[Part, ColonyHandlerHeadCassette], validPartColonyHandlerHeadCasseteQTests];
registerValidQTestFunction[Object[Part, Chiller],validPartChillerQTests];
registerValidQTestFunction[Object[Part, Computer],validPartComputerQTests];
registerValidQTestFunction[Object[Part, ConductivityProbe],validPartConductivityProbeQTests];
registerValidQTestFunction[Object[Part, ConductivitySensor],validPartConductivitySensorQTests];
registerValidQTestFunction[Object[Part, Decrimper],validDecrimperQTests];
registerValidQTestFunction[Object[Part, Crimper],validCrimperQTests];
registerValidQTestFunction[Object[Part, Deionizer],validDeionizerQTests];
registerValidQTestFunction[Object[Part, DialysisClip],validPartDialysisClipQTests];
registerValidQTestFunction[Object[Part, DiodeArrayModule],validPartDiodeArrayModuleQTests];
registerValidQTestFunction[Object[Part, DockingStation],validPartDockingStationQTests];
registerValidQTestFunction[Object[Part, ElectrochemicalReactionVesselHolder], validPartElectrochemicalReactionVesselHolderQTests];
registerValidQTestFunction[Object[Part, ElectrodePolishingPlate], validPartElectrodePolishingPlateQTests];
registerValidQTestFunction[Object[Part, ElectrodeRack], validPartElectrodeRackQTests];
registerValidQTestFunction[Object[Part, EluentGenerator],validPartEluentGeneratorQTests];
registerValidQTestFunction[Object[Part, EmbeddedPC],validPartEmbeddedPCQTests];
registerValidQTestFunction[Object[Part, Fan],validPartFanQTests];
registerValidQTestFunction[Object[Part, FanFilterUnit],validPartFanFilterUnitQTests];
registerValidQTestFunction[Object[Part, Ferrule],validPartFerruleQTests];
registerValidQTestFunction[Object[Part, FillRod],validPartFillRodQTests];
registerValidQTestFunction[Object[Part, Filter],validPartFilterQTests];
registerValidQTestFunction[Object[Part, FilterAdapter],validPartFilterAdapterQTests];
registerValidQTestFunction[Object[Part, FlowCell],validPartFlowCellQTests];
registerValidQTestFunction[Object[Part, FlowRestrictor],validPartFlowRestrictorQTests];
registerValidQTestFunction[Object[Part, FoamImagingModule],validPartFoamImagingModuleQTests];
registerValidQTestFunction[Object[Part, FootPedal],validPartFootPedalQTests];
registerValidQTestFunction[Object[Part, Funnel],validPartFunnelQTests];
registerValidQTestFunction[Object[Part, FurnitureEquipment],validPartFurnitureEquipmentQTests];
registerValidQTestFunction[Object[Part, GauzeHolder],validPartGauzeHolderQTests];
registerValidQTestFunction[Object[Part, GrinderClampAssembly],validPartGrinderClampAssemblyQTests];
registerValidQTestFunction[Object[Part, HandPump],validPartHandPumpQTests];
registerValidQTestFunction[Object[Part, HeatExchanger],validPartHeatExchangerQTests];
registerValidQTestFunction[Object[Part, HexKey],validPartHexKeyQTests];
registerValidQTestFunction[Object[Part, InformationTechnology],validPartInformationTechnologyQTests];
registerValidQTestFunction[Object[Part, Inverter],validPartInverterQTests];
registerValidQTestFunction[Object[Part, Lamp],validPartLampQTests];
registerValidQTestFunction[Object[Part, Laser],validPartLaserQTests];
registerValidQTestFunction[Object[Part, LiquidConductivityModule],validPartLiquidConductivityModuleQTests];
registerValidQTestFunction[Object[Part, NeedleLockingScrew],validPartNeedleLockingScrew];
registerValidQTestFunction[Object[Part, NMRDepthGauge],validPartNMRDepthGaugeQTests];
registerValidQTestFunction[Object[Part, NMRProbe],validPartNMRProbeQTests];
registerValidQTestFunction[Object[Part, Nut],validPartNutQTests];
registerValidQTestFunction[Object[Part, Nozzle],validPartNozzleQTests];
registerValidQTestFunction[Object[Part, MeterModule],validPartMeterModuleQTests];
registerValidQTestFunction[Object[Part, Mixer],validPartMixerQTests];
registerValidQTestFunction[Object[Part, Objective],validPartObjectiveQTests];
registerValidQTestFunction[Object[Part, OpticalFilter],validPartOpticalFilterQTests];
registerValidQTestFunction[Object[Part, OpticModule],validPartOpticModuleQTests];
registerValidQTestFunction[Object[Part, ORing],validPartORingQTests];
registerValidQTestFunction[Object[Part, PeristalticPump],validPartPeristalticPumpQTests];
registerValidQTestFunction[Object[Part, VacuumPump],validPartVacuumPumpQTests];
registerValidQTestFunction[Object[Part, pHProbe],validPartpHProbeQTests];
registerValidQTestFunction[Object[Part, Piston],validPartPistonQTests];
registerValidQTestFunction[Object[Part, PressureRegulator],validPartPressureRegulatorQTests];
registerValidQTestFunction[Object[Part, PressureSensor],validPartPressureSensorQTests];
registerValidQTestFunction[Object[Part, Spectrophotometer],validPartSpectrophotometerQTests];
registerValidQTestFunction[Object[Part, PowerDistributionUnit],validPartPowerDistributionUnitQTests];
registerValidQTestFunction[Object[Part, ReferenceElectrode],validPartReferenceElectrodeQTests];
registerValidQTestFunction[Object[Part, Seal],validPartSealQTests];
registerValidQTestFunction[Object[Part, Sensornet],validPartSensornetQTests];
registerValidQTestFunction[Object[Part, ShakerAdapter], validPartShakerAdapterQTests];
registerValidQTestFunction[Object[Part, SpargeFilter],validPartSpargeFilterQTests];
registerValidQTestFunction[Object[Part, Spigot],validPartSpigotQTests];
registerValidQTestFunction[Object[Part, StirBlade],validPartStirBladeQTests];
registerValidQTestFunction[Object[Part, Suppressor],validPartSuppressorQTests];
registerValidQTestFunction[Object[Part, Syringe],validPartSyringeQTests];
registerValidQTestFunction[Object[Part, TemperatureProbe],validPartTemperatureProbeQTests];
registerValidQTestFunction[Object[Part, TensiometerProbe],validPartTensiometerProbeQTests];
registerValidQTestFunction[Object[Part, TensiometerProbeCleaner],validPartTensiometerProbeCleanerQTests];
registerValidQTestFunction[Object[Part, ThermalBlock],validPartThermalBlockQTests];
registerValidQTestFunction[Object[Part, StirBar],validPartStirBarQTests];
registerValidQTestFunction[Object[Part, StirBarRetriever],validPartStirBarRetrieverQTests];
registerValidQTestFunction[Object[Part, ViscometerChip],validPartViscometerChipQTests];
registerValidQTestFunction[Object[Part, StirrerShaft],validPartStirrerShaftQTests];
registerValidQTestFunction[Object[Part, SolenoidValve],validPartSolenoidValveQTests];
registerValidQTestFunction[Object[Part, SonicationHorn],validPartSonicationHornQTests];
registerValidQTestFunction[Object[Part, DispensingHead],validPartDispensingHeadQTests];
registerValidQTestFunction[Object[Part, Fitting],validPartFittingQTests];
registerValidQTestFunction[Object[Part, HeatSink],validPartHeatSinkQTests];
registerValidQTestFunction[Object[Part, AmpouleOpener],validPartAmpouleOpenerQTests];
registerValidQTestFunction[Object[Part, UniversalInterfaceConverter],validPartUniversalInterfaceConverterQTests];
registerValidQTestFunction[Object[Part, Lighter],validPartLighterQTests];
registerValidQTestFunction[Object[Part, LightObscurationSensor],validPartLightObscurationSensorQTests];
registerValidQTestFunction[Object[Part, SmokeGenerator],validPartSmokeGeneratorQTests];
registerValidQTestFunction[Object[Part, RefrigerationUnit],validPartRefrigerationUnitQTests];
registerValidQTestFunction[Object[Part, RefractometerTool], validPartRefractometerToolQTests];
registerValidQTestFunction[Object[Part, DryingCartridge], validPartDryingCartridgeQTests];
registerValidQTestFunction[Object[Part, Alarm], validPartAlarmQTests];
registerValidQTestFunction[Object[Part, FireAlarmActivator], validPartFireAlarmActivatorQTests];
registerValidQTestFunction[Object[Part, FireExtinguisher], validPartFireExtinguisherQTests];
registerValidQTestFunction[Object[Part, FirstAidKit], validPartFirstAidKitQTests];
registerValidQTestFunction[Object[Part, FloodLight], validPartFloodLightQTests];
registerValidQTestFunction[Object[Part, SafetyWashStation], validPartSafetyWashStationQTests];
registerValidQTestFunction[Object[Part, Respirator], validPartRespiratorQTests];
registerValidQTestFunction[Object[Part, RespiratorFilter], validPartRespiratorFilterQTests];
registerValidQTestFunction[Object[Part, StickerPrinter], validPartStickerPrinterQTests];
registerValidQTestFunction[Object[Part, SamplingProbe], validPartSamplingProbeQTests];
registerValidQTestFunction[Object[Part, CuttingJig], validPartCuttingJigQTests];
registerValidQTestFunction[Object[Part, GravityRackPlatform],validPartGravityRackPlatformQTests];
registerValidQTestFunction[Object[Part, FlaskRing],validPartFlaskRingQTests];
registerValidQTestFunction[Object[Part, PositioningPin],validPartPositioningPinQTests];
registerValidQTestFunction[Object[Part, KVMSwitch],validKVMSwitchQTests];
registerValidQTestFunction[Object[Part, TubeBlock],validPartTybeBlockQTests];
registerValidQTestFunction[Object[Part, Clamp],validPartClampQTests];
