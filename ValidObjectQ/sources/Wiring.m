(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validWiringQTests*)


validWiringQTests[packet:PacketP[Object[Wiring]]]:=Module[
	{modelPacket, productPacket},

	{modelPacket, productPacket}=If[
		MatchQ[Lookup[packet, {Model, Product}], {Null, Null}],
		{Null, Null},
		Download[Lookup[packet, Object], {Model[All], Product[All]}]];

	{
		(* general fields that SHOULD be informed *)
		NotNullFieldTest[packet,{
			Model,
			Status,
			DateStocked,
			StorageCondition,
			StorageConditionLog
		}],

		(* date related fields *)
		Test["If DateUnsealed is informed, it is in the past:",
			Lookup[packet,DateUnsealed],
			_?(#<=Now &)|Null
		],

		Test["If DateDiscarded is informed, it is in the past:",
			Lookup[packet,DateDiscarded],
			_?(#<=Now &)|Null
		],

		Test["If Status is not Discarded, Site is filled out:",
			Lookup[packet, {Status, Site}],
			{Discarded, _} | {Except[Discarded], Except[NullP]}
		],

		FieldComparisonTest[packet,{DateDiscarded,DateUnsealed},GreaterEqual],
		FieldComparisonTest[packet,{DateUnsealed,DateStocked},GreaterEqual],

		Test["DateDiscarded is informed if and only if Status is Discarded:",
			Lookup[packet,{DateDiscarded,Status}],
			{Except[Null],Discarded}|{Null,Except[Discarded]}
		],

		Test["If the Status of the wiring is Stocked, DateDiscarded and DateUnsealed must be Null:",
			Lookup[packet,{Status,DateDiscarded,DateUnsealed}],
			{Stocked,Null,Null}|{Except[Stocked],_,_}
		],

		Test["If the Status of the wiring is Available, DateUnsealed must be informed:",
			Lookup[packet,{Status,DateUnsealed}],
			{Available,Except[Null]}|{Except[Available],_}
		],

		(* storage related fields *)
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

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the wiring component:",
			If[!MatchQ[Lookup[packet,StoragePositions],{}],
				Module[{upConditions,providedConditions},

					(* get the provided condition of all StoragePositions *)
					upConditions=Download[Lookup[packet,StoragePositions][[All,1]],Repeated[Container][ProvidedStorageCondition],ProvidedStorageCondition==Null,HaltingCondition->Inclusive];

					(* the provided condition is the last of each of these "up condition" objects (we stopped when we hit one) *)
					providedConditions=DeleteDuplicates[Download[Cases[LastOrDefault/@upConditions,ObjectP[Model[StorageCondition]]],Object]];

					(* there should be just one provided condition, which is the sample's *)
					Which[Length[providedConditions]==1,
							MatchQ[FirstOrDefault[providedConditions],Download[Lookup[packet,StorageCondition],Object]],
						Length[providedConditions]>1,
						False,
						True,
						True
				]],
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
			Alternatives[{True, True},
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

		(* wiring connection related fields *)
		Test["All wiring connection names at the first index of the WiringConnections field match a WiringConnectors name in the model:",
			Complement[Lookup[packet,WiringConnections][[All,1]],Lookup[modelPacket,WiringConnectors][[All,1]]],
			{}
		],
		
		Test["Active WiringConnections' most recent entry in the WiringConnectionLog is a Connect event:",
			Module[{currentConnections,reversedLog,lastLogEntries},

				(* get active connections *)
				currentConnections=Lookup[packet,WiringConnections];

				(* get the connection log, and reverse it for recency first *)
				reversedLog=Reverse[Lookup[packet,WiringConnectionLog]];

				(* for each connection, get the most recent connection log entry for it *)
				lastLogEntries=Map[
					Function[connection,
						SelectFirst[reversedLog,MatchQ[#[[3]],connection[[1]]]&&MatchQ[Download[#[[4]],Object],Download[connection[[2]],Object]]&&MatchQ[#[[5]],connection[[3]]]&,$Failed]
					],
					currentConnections
				];

				(* if an entry could not be found at all, or has Disconnect at second index, it's bad *)
				If[MemberQ[lastLogEntries,$Failed]||MemberQ[lastLogEntries[[All,2]],Disconnect],
					False,
					True
			]],
			True
		],

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


(* ::Subsection:: *)
(*validWiringCircuitBreakerQTests*)


validWiringCircuitBreakerQTests[packet:PacketP[Object[Wiring,CircuitBreaker]]]:={

	NotNullFieldTest[packet,{
		LocationLog
	}],
	
	Test["If Status is not Retired, the circuit breaker has a location log:",
		Lookup[packet,{Status,LocationLog}],
		{Retired,_}|{Except[Retired],Except[{}]}
	],

	If[!TrueQ[Lookup[packet,Missing]],
		Test["The last entry in LocationLog matches the current Position and Container, if the circuit breaker is not missing:",
			{#[[4]],#[[3]][Object]}&[Last[Lookup[packet, LocationLog]]],
			{Lookup[packet,Position],Lookup[packet,Container][Object]}
		],
		Nothing
	],

	Test["If Status is not Retired, the circuit breaker has a Site:",
		Lookup[packet,{Status,Site}],
		{Retired,_}|{Except[Retired],ObjectP[Object[Container, Site]]}
	]

};


(* ::Subsection:: *)
(*validWiringNetworkHubQTests*)


validWiringNetworkHubQTests[packet:PacketP[Object[Wiring,NetworkHub]]]:={

	NotNullFieldTest[packet,{
		ConnectedLocation
	}]

};


(* ::Subsection:: *)
(*validWiringPLCComponentQTests*)


validWiringPLCComponentQTests[packet:PacketP[Object[Wiring,PLCComponent]]]:={

	NotNullFieldTest[packet,{
		LocationLog
	}],
	
	Test["If Status is not Retired, the PLC component has a location log:",
		Lookup[packet,{Status,LocationLog}],
		{Retired,_}|{Except[Retired],Except[{}]}
	],

	If[!TrueQ[Lookup[packet,Missing]],
		Test["The last entry in LocationLog matches the current Position and Container, if the PLC component is not missing:",
			{#[[4]],#[[3]][Object]}&[Last[Lookup[packet, LocationLog]]],
			{Lookup[packet,Position],Lookup[packet,Container][Object]}
		],
		Nothing
	],

	Test["If Status is not Retired, the PLC component has a Site:",
		Lookup[packet,{Status,Site}],
		{Retired,_}|{Except[Retired],ObjectP[Object[Container, Site]]}
	]

};


(* ::Subsection:: *)
(*validWiringPowerStripQTests*)


validWiringPowerStripQTests[packet:PacketP[Object[Wiring,PowerStrip]]]:={

	NotNullFieldTest[packet,{
		ConnectedLocation
	}]


};


(* ::Subsection:: *)
(*validWiringReceptacleQTests*)


validWiringReceptacleQTests[packet:PacketP[Object[Wiring,Receptacle]]]:={

	NotNullFieldTest[packet,{
		ConnectedLocation
	}]

};


(* ::Subsection:: *)
(*validWiringTransformerQTests*)


validWiringTransformerQTests[packet:PacketP[Object[Wiring,Transformer]]]:={

	NotNullFieldTest[packet,{
		LocationLog
	}],
	
	Test["If Status is not Retired, the transformer has a location log:",
		Lookup[packet,{Status,LocationLog}],
		{Retired,_}|{Except[Retired],Except[{}]}
	],

	If[!TrueQ[Lookup[packet,Missing]],
		Test["The last entry in LocationLog matches the current Position and Container, if the transformer is not missing:",
			{#[[4]],#[[3]][Object]}&[Last[Lookup[packet, LocationLog]]],
			{Lookup[packet,Position],Lookup[packet,Container][Object]}
		],
		Nothing
	],

	Test["If Status is not Retired, the transformer has a Site:",
		Lookup[packet,{Status,Site}],
		{Retired,_}|{Except[Retired],ObjectP[Object[Container, Site]]}
	]

};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Wiring],validWiringQTests];
registerValidQTestFunction[Object[Wiring,CircuitBreaker],validWiringCircuitBreakerQTests];
registerValidQTestFunction[Object[Wiring,NetworkHub],validWiringNetworkHubQTests];
registerValidQTestFunction[Object[Wiring,PLCComponent],validWiringPLCComponentQTests];
registerValidQTestFunction[Object[Wiring,PowerStrip],validWiringPowerStripQTests];
registerValidQTestFunction[Object[Wiring,Receptacle],validWiringReceptacleQTests];
registerValidQTestFunction[Object[Wiring,Transformer],validWiringTransformerQTests];
