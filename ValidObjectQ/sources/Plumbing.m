(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validPlumbingQTests*)


validPlumbingQTests[packet:PacketP[Object[Plumbing]]]:=Module[
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

		Test["If the Status of the part is Stocked, DateDiscarded and DateUnsealed must be Null:",
			Lookup[packet,{Status,DateDiscarded,DateUnsealed}],
			{Stocked,Null,Null}|{Except[Stocked],_,_}
		],

		Test["If the Status of the part is Available, DateUnsealed must be informed:",
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

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the plumbing component:",
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

		(* connection related fields *)
		Test["All connection names at the first index of the Connections field match a Connector name in the model:",
			Complement[Lookup[packet,Connections][[All,1]],Lookup[modelPacket,Connectors][[All,1]]],
			{}
		],
		
		Test["Active Connections' most recent entry in the ConnectionLog is a Connect event:",
			Module[{currentConnections,reversedLog,lastLogEntries},

				(* get active connections *)
				currentConnections=Lookup[packet,Connections];

				(* get the connection log, and reverse it for recency first *)
				reversedLog=Reverse[Lookup[packet,ConnectionLog]];

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

		(* If the Object has ConnectorGrips in its Model, then it must have corresponding entries in the Object's Connectors field *)
		Test["All ConnectorGrips from this Object's Model have entries in the Object and vice versa:",
			Module[{modelConnectorGrips, nonNullModelConnectorGrips, objectConnectorGrips, nonNullObjectConnectorGrips},
				modelConnectorGrips = Lookup[modelPacket, ConnectorGrips, {}];
				nonNullModelConnectorGrips = Cases[modelConnectorGrips, Except[Null]];

				objectConnectorGrips = Lookup[packet, ConnectorGrips, {}];
				nonNullObjectConnectorGrips = Cases[objectConnectorGrips, Except[Null]];

				If[MatchQ[nonNullModelConnectorGrips, {}],
					True,
					MatchQ[nonNullObjectConnectorGrips, {OrderlessPatternSequence @@ nonNullModelConnectorGrips}]
				]
			],
			True
		],

		(* The name for each non-Null ConnectorGrip entry matches the name of the index-matched Connector. *)
		Test["The name of each non-Null ConnectorGrip matches that the name of the index-matched Connector:",
			Module[{connectors, connectorGrips},
				{connectors, connectorGrips} = Lookup[packet, {Connectors, ConnectorGrips}, {}];

				If[MatchQ[connectorGrips, {}],
					True,
					(* Name is the first index of both Connectors and ConnectorGrips *)
					And @@ (MatchQ[#[[1,1]], #[[2,1]]]& /@ PickList[Transpose[{connectors, connectorGrips}], connectorGrips, Except[Null]])
				]
			],
			True
		],

		(* Min is less than Max for ConnectorGrip torque. *)
		Test["Each ConnectorGrip Min Torque is less than or equal to its Max Torque:",
			Module[{connectorGrips, minTorques, maxTorques},
				connectorGrips = Cases[Lookup[packet, ConnectorGrips], {_, _, _, Except[Null], Except[Null]}];

				If[MatchQ[connectorGrips, {}],
					True,

					(* Pull out the min and max torques for the field. *)
					minTorques = connectorGrips[[All, 4]];
					maxTorques = connectorGrips[[All, 5]];

					(* Name is the first index of both Connectors and ConnectorGrips *)
					And @@ MapThread[LessEqualQ[#1, #2]&, {minTorques, maxTorques}]
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
(*validPlumbingAspirationCapQTests*)


validPlumbingAspirationCapQTests[packet:PacketP[Object[Plumbing, AspirationCap]]] := {

};


(* ::Subsection:: *)
(*validPlumbingCableQTests*)


validPlumbingCableQTests[packet:PacketP[Object[Plumbing,Cable]]]:={

};


(* ::Subsection:: *)
(*validPlumbingCapQTests*)


validPlumbingCapQTests[packet:PacketP[Object[Plumbing,Cap]]]:={

};


(* ::Subsection:: *)
(*validPlumbingColumnJoinQTests*)


validPlumbingColumnJoinQTests[packet:PacketP[Object[Plumbing, ColumnJoin]]] := {

};


(* ::Subsection:: *)
(*validPlumbingFittingQTests*)


validPlumbingFittingQTests[packet:PacketP[Object[Plumbing,Fitting]]]:={

};



(* ::Subsection:: *)
(*validPlumbingGasDispersionTubeQTests*)


validPlumbingGasDispersionTubeQTests[packet:PacketP[Object[Plumbing,GasDispersionTube]]]:={

};


(* ::Subsection:: *)
(*validPlumbingFerruleQTests*)


validPlumbingFerruleQTests[packet:PacketP[Object[Plumbing,Ferrule]]]:={

};


(* ::Subsection:: *)
(*validPlumbingFerruleNutQTests*)


validPlumbingFerruleNutQTests[packet:PacketP[Object[Plumbing,FerruleNut]]]:={

};


(* ::Subsection:: *)
(*validPlumbingPipeQTests*)


validPlumbingPipeQTests[packet:PacketP[Object[Plumbing,Pipe]]]:={

};


(* ::Subsection:: *)
(*validPlumbingManifoldQTests*)


validPlumbingManifoldQTests[packet:PacketP[Object[Plumbing,Manifold]]]:={

};


(* ::Subsection:: *)
(*validPlumbingSampleLoopQTests*)


validPlumbingSampleLoopQTests[packet:PacketP[Object[Plumbing,SampleLoop]]]:={

};



(* ::Subsection:: *)
(*validPlumbingTubingQTests*)


validPlumbingTubingQTests[packet:PacketP[Object[Plumbing,Tubing]]]:={

};



(* ::Subsection:: *)
(*validPlumbingPrecutTubingQTests*)


validPlumbingPrecutTubingQTests[packet:PacketP[Object[Plumbing,PrecutTubing]]]:={
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Gauge,
		ParentTubing
	}]
	
};



(* ::Subsection:: *)
(*validPlumbingValveQTests*)


validPlumbingValveQTests[packet:PacketP[Object[Plumbing,Valve]]]:={

	Test["The last entry in ValvePositionLog matches the current ValvePosition:",
		Module[{valvePosition,valveLog},
			{valvePosition,valveLog} = Lookup[packet,{ValvePosition,ValvePositionLog}];
			If[!MatchQ[valveLog,{}],
				MatchQ[Last[valveLog][[2]],valvePosition],
				MatchQ[valvePosition,Null]
			]
		],
		True
	],

	Test["If Actuator is Electrical, PDU must be informed if the valve's Status is Available or InUse:",
		Module[{model, pdu, actuator,status},
			{model,pdu,status}=Lookup[packet,{Model,PDU,Status}];
			actuator = If[MatchQ[status,(Available|InUse)],
				Lookup[Download[model],Actuator],
				Null
			];
			{actuator,pdu}
		],
		{Electrical,Except[Null]}|{Except[Electrical],Null}
	]
};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Plumbing],validPlumbingQTests];
registerValidQTestFunction[Object[Plumbing,AspirationCap],validPlumbingAspirationCapQTests];
registerValidQTestFunction[Object[Plumbing,Cable],validPlumbingCableQTests];
registerValidQTestFunction[Object[Plumbing,Cap],validPlumbingCapQTests];
registerValidQTestFunction[Object[Plumbing,ColumnJoin],validPlumbingColumnJoinQTests];
registerValidQTestFunction[Object[Plumbing,Ferrule],validPlumbingFerruleQTests];
registerValidQTestFunction[Object[Plumbing,FerruleNut],validPlumbingFerruleNutQTests];
registerValidQTestFunction[Object[Plumbing,Fitting],validPlumbingFittingQTests];
registerValidQTestFunction[Object[Plumbing,GasDispersionTube],validPlumbingGasDispersionTubeQTests];
registerValidQTestFunction[Object[Plumbing,Manifold],validPlumbingManifoldQTests];
registerValidQTestFunction[Object[Plumbing,Pipe],validPlumbingPipeQTests];
registerValidQTestFunction[Object[Plumbing,SampleLoop],validPlumbingSampleLoopQTests];
registerValidQTestFunction[Object[Plumbing,Tubing],validPlumbingTubingQTests];
registerValidQTestFunction[Object[Plumbing,PrecutTubing],validPlumbingPrecutTubingQTests];
registerValidQTestFunction[Object[Plumbing,Valve],validPlumbingValveQTests];
