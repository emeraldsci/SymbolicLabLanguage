(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validContainerQTests*)


validContainerQTests[packet:PacketP[Object[Container]]]:=Module[
	{modelPacket, productPacket},

	{modelPacket, productPacket}=If[
		MatchQ[Lookup[packet, {Model, Product}], {Null, Null}],
		{Null, Null},
		Download[Lookup[packet, Object], {Model[All], Product[All]}]];

	{
		(* --------- Shared field shaping --------- *)
		NotNullFieldTest[packet, {Model}],

		(* ---------- Other specific tests --------- *)

		Test["If this container is covered, Model[CoverFootprints] != {}:",
			If[MatchQ[Lookup[packet, Cover], ObjectP[]],
				!MatchQ[Download[Lookup[packet, Object], Model[CoverFootprints]], {}|Null],
				True
			],
			True
		],

		Test["If Status is Stocked, DateStocked must be informed and DateUnsealed must be Null:",
			Lookup[packet, {Status, DateStocked, DateUnsealed}],
			{Stocked, Except[Null], Null} | {Except[Stocked], _, _}
		],

		Test["If Status is Available or InUse, DateUnsealed must be informed:",
			Lookup[packet, {Status, DateUnsealed}],
			{Available | InUse, Except[Null]} | {Except[Available | InUse], _}
		],

		Test["If Status is InUse, the protocol using it must not be failed:",
			Download[packet, {Status, CurrentProtocol[Status]}],
			{Except[InUse], _} | {InUse, Except[Aborted]}
		],

		Test["If DateDiscarded is informed, it is in the past:",
			Lookup[packet, DateDiscarded],
			Alternatives[
				Null, {},
				_?(# <= Now&)
			]
		],

		(* if the container itself is a site, then Site doesn't need to be filled out *)
		Test["If Status is not Discarded, Site is filled out:",
			Lookup[packet, {Type, Status, Site}],
			{Object[Container, Site], _, _} | {Except[Object[Container, Site]], Discarded, _} | {Except[Object[Container, Site]], Except[Discarded], Except[NullP]}
		],

		(* If a container is actively being washed, skip this check because status may be InUse and DateDiscarded still populated until the parser is run *)
		Test["If Status is Discarded, DateDiscarded must be informed. If Status is not Discarded, DateDiscarded may not be informed:",
			Lookup[packet, {Status, DateDiscarded, CurrentProtocol}],
			{Discarded, Except[Null], _} | {Except[Discarded], Null, _} | {_, _, ObjectP[{Object[Maintenance, Dishwash], Object[Maintenance, Handwash]}]}
		],

		FieldComparisonTest[packet, {DateStocked, DateUnsealed}, LessEqual],
		FieldComparisonTest[packet, {DateUnsealed, DateDiscarded}, LessEqual],

		Test["If Status is not Discarded, the container (except for Object[Container, Building] and Object[Container,Site]) has a location (Container, Position informed):",
			If[
				!MatchQ[packet, ObjectP[{Object[Container, Building], Object[Container, Site]}]],
				Lookup[packet, {Status, Container, Position}],
				{"Automatic Pass", "Automatic Pass", "Automatic Pass"}
			],
			{Discarded, _, _} | {Except[Discarded], Except[Null], Except[Null]}
		],

		Test["If Status is not Discarded, the container (except for Object[Container, Building] and Object[Container,Site]) has a location log:",
			(* doing these shenanigans because LocationLog can be super long for some objects and Downloading Length makes it much faster *)
			With[{locationLogLength=Download[Lookup[packet, Object], Length[LocationLog]]},
				If[!MatchQ[packet, ObjectP[{Object[Container, Building], Object[Container, Site]}]],
					{Lookup[packet, Status], locationLogLength},
					{"Automatic Pass", "Automatic Pass"}
				]
			],
			{Discarded, _} | {Except[Discarded], GreaterP[0]} | {"Automatic Pass", "Automatic Pass"},
			TimeConstraint -> 120
		],

		Test["If Status is not Discarded or AwaitingDisposal, the container's model is not Deprecated:",
			{Lookup[modelPacket, Deprecated], Lookup[packet, AwaitingDisposal], Lookup[packet, Status]},
			Alternatives[
				{_, _, Discarded},
				{_, True, _},
				{False | Null, False | Null, Except[Discarded | Null]}
			]
		],

		Test["The last entry in LocationLog matches the current Position and Container (except for Buildings and Sites, which can have empty positions/containers):",
			If[!MatchQ[packet, ObjectP[{Object[Container, Building], Object[Container, Site]}]],
				Module[
					{lastLog, container, position},
					(* Looking up the LocationLog in the packet will cause it to be downloaded at this time (since it's RuleDelayed) *)
					(* Download Container/Position too so all the info we're working with is from the same time; Cache->Download to leave no doubt *)
					{lastLog, container, position}=Download[Lookup[packet, Object], {LocationLog[[-1]], Container, Position}, Cache -> Download];

					MatchQ[
						{lastLog[[4]], lastLog[[3]][Object]},
						{position, container[Object]}
					]
				],
				True
			],
			True,
			TimeConstraint -> 120
		],


		Test["If Status is Available or Stocked and AsepticTransportContainerType is Bulk, the container's container must be aseptic bag:",
			If[MatchQ[Lookup[packet, Status], Available|Stocked] && MatchQ[Lookup[packet, AsepticTransportContainerType], Bulk],
				MatchQ[Lookup[packet, Container], ObjectP[Object[Container, Bag, Aseptic]]],
				True
			],
			True
		],

		Test["If Status is Available or Stocked, and the container's container is an aseptic bag, AsepticTransportContainerType must be informed unless it is for training:",
			If[MatchQ[Lookup[packet, Status], Available|Stocked] && MatchQ[Lookup[packet, Container], ObjectP[Object[Container, Bag, Aseptic]]],
				(* Note:currently we use Model[Sample, Media, "LB (Solid Agar) Bulk Storage For Training"] for QualificationTrainingAsepticTechnique *)
				Or[
					MatchQ[Lookup[packet, AsepticTransportContainerType], AsepticTransportContainerTypeP],
					!MatchQ[Lookup[packet, Contents], {}] && MemberQ[Download[Lookup[packet, Contents][[All, 2]], Model], ObjectP[Model[Sample, Media, "id:O81aEBv4ZNLO"]]]
					],
				True
			],
			True
		],

		(* Cameras *)
		Test["Positions monitored by the cameras exist on the Container:",
			Module[{allowedPosition, monitoredLocations},

				allowedPosition=Lookup[packet, AllowedPositions];

				monitoredLocations=Lookup[packet, Cameras][[All, 1]];

				If[monitoredLocations == {}, Return[True]];

				AllTrue[MemberQ[allowedPosition, #] & /@ monitoredLocations, TrueQ]
			],
			True
		],


		Test["For any fluid-containing container, all contents (except for sensors) have match the status of the container:",
			If[
				MatchQ[packet, FluidContainerP],
				Download[Lookup[packet, Contents][[All, 2]], Status],
				Null
			],
			Alternatives[
				Null, (* Doesn't match FluidContainerP, or has no Contents*)
				{(Lookup[packet, Status])...}
			]
		],

		(* storage *)
		Test["For any non-Discarded fluid container with contents, StorageCondition is filled out and matches the StorageCondition of all contents:",
			If[
				And[
					MatchQ[packet[Object], FluidContainerP],
					Not[MatchQ[Lookup[packet, Status], Discarded]],
					Not[MatchQ[Lookup[packet, Contents], {}]]
				],
				SameQ @@ Append[Download[Lookup[packet, Contents][[All, 2]], StorageCondition[Object]], Download[Lookup[packet, StorageCondition], Object]],
				True
			],
			True
		],
		Test["The last entry in StorageConditionLog matches the current StorageCondition:",
			If[Lookup[packet, StorageConditionLog] == {},
				Null,
				Download[Last[Lookup[packet, StorageConditionLog]][[2]], Object]
			],
			Download[Lookup[packet, StorageCondition], Object]
		],

		Test["ProvidedStorageCondition AND StorageCondition cannot both be populated:",
			Lookup[packet, {StorageCondition, ProvidedStorageCondition}],
			Except[{Except[Null], Except[Null]}]
		],

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the container:",
			If[!MatchQ[Lookup[packet, StoragePositions], {}],
				Module[{upConditions, providedConditions},

					(* get the provided condition of all StoragePositions *)
					upConditions=Download[Lookup[packet, StoragePositions][[All,1]], Repeated[Container][ProvidedStorageCondition], ProvidedStorageCondition == Null, HaltingCondition -> Inclusive];

					(* the provided condition is the last of each of these "up condition" objects (we stopped when we hit one) *)
					providedConditions=DeleteDuplicates[Download[Cases[LastOrDefault /@ upConditions, ObjectP[Model[StorageCondition]]], Object]];

					(* there should be just onbe provided condition, which is the sample's *)
					Which[
						Length[providedConditions] == 1,
						MatchQ[FirstOrDefault[providedConditions], Download[Lookup[packet, StorageCondition], Object]],
						Length[providedConditions] > 1, False,
						True, True
					]
				],
				True
			],
			True
		],
		
		Test["If StoragePositions is set, at least one StoragePositions must be at the same site as the container:",
			If[!MatchQ[Lookup[packet, StoragePositions], {}],
				Module[{storagePositionsSites, containerSite},

					storagePositionsSites = Download[Lookup[packet, StoragePositions][[All,1]],Site[Object]];
					
					containerSite = Download[Lookup[packet, Site],Object];
					
					MemberQ[storagePositionsSites,containerSite]
				],
				True
			],
			True
		],

		Test["If AwaitingDisposal is True, then AwaitingStorageUpdate must also be True:",
			Lookup[packet, {Status, AwaitingDisposal, AwaitingStorageUpdate}],
			{InUse, _, _} | {Except[InUse, SampleStatusP | Null], True, True} | {Except[InUse, SampleStatusP | Null], (False | Null), _}
		],

		Test["The last entry in DisposalLog matches the current AwaitingDisposal:",
			{If[Lookup[packet, DisposalLog] == {}, Null, Last[Lookup[packet, DisposalLog]][[2]]], Lookup[packet, AwaitingDisposal]},
			Alternatives[
				{True, True},
				{False | Null, False | Null}
			]
		],

		(* Check to see if the object is in the ScheduledMoves of an Object[Maintenance, StorageUpdate] and prioritize this if so
			if not you should enqueue a new StorageUpdate to make this move
		*)
		Test["If the object has a new requested storage category, or needs to be thrown out it has not been waiting more than 7 days for this change to take place:",
			Module[{updateNeeded, disposalLog, storageConditionLog, currentProtocol, notebook, lastUpdateRequest, gracePeriod, status},
				{updateNeeded, disposalLog, storageConditionLog, currentProtocol, notebook, status}=Lookup[packet, {AwaitingStorageUpdate, DisposalLog, StorageConditionLog, CurrentProtocol, Notebook, Status}];

				(* Ugly check to get the most recent request to change the storage condition or discard the object *)
				lastUpdateRequest=Max[{First[Last[disposalLog, {}], Now], First[Last[storageConditionLog, {}], Now]}];

				(* Give ops 7 days to complete the request - can change based on our current expectations *)
				gracePeriod=7 Day;

				(* If we need to update the storage location and it's been longer than our expected time, we're in trouble and need to get the Maintenace done or enqueued! *)
				(* Don't worry if it's in a protocol since this will handle the clean up *)
				(* Only complain about customer samples for right now *)
				(* ignore things that are discarded *)
				MatchQ[updateNeeded, True] && lastUpdateRequest < (Now - gracePeriod) && currentProtocol === Null && notebook =!= Null && Not[MatchQ[status, Discarded]]
			],
			False
		],

		(* TareWeight  tests *)
		RequiredTogetherTest[packet, {TareWeight, TareWeightDistribution, TareWeightLog}],

		Test["The last entry in the TareWeightLog matches the current TareWeight:",
			If[!NullQ[packet[TareWeight]] && !MatchQ[packet[TareWeightLog], {}],
				Equal[packet[TareWeight], Last[packet[TareWeightLog]][[2]]],
				True
			],
			True
		],

		Test["For medium to large containers, Object[Container] TareWeight is within 5% of the Model[Container] TareWeight, if both are uploaded:",
			Module[{containerTareWeight, modelContainerTareWeight},
				containerTareWeight=Lookup[packet, TareWeight];
				modelContainerTareWeight=Lookup[modelPacket, TareWeight, Null];
				If[MassQ[containerTareWeight] && MassQ[modelContainerTareWeight],
					(* both fields are uploaded, so check inequality *)
					If[modelContainerTareWeight > (2 Gram),
						(* it is a large container, check *)
						(Abs[modelContainerTareWeight - containerTareWeight] / modelContainerTareWeight) <= 0.05,
						(* not a large container, so return True *)
						True
					],
					(* not both fields are uploaded, so return True *)
					True
				]
			],
			True
		],

		Test["For small containers, Object[Container] TareWeight is within 15% of the Model[Container] TareWeight, if both are uploaded:",
			Module[{containerTareWeight, modelContainerTareWeight},
				containerTareWeight=Lookup[packet, TareWeight];
				modelContainerTareWeight=Lookup[modelPacket TareWeight, Null];
				If[MassQ[containerTareWeight] && MassQ[modelContainerTareWeight],
					(* both fields are uploaded, so check inequality *)
					(* at 2 Grams or less stickers can make a difference. So 2mL tubes coming from vendors (like Invitrogen sybr gold are affected. so increase the threshold test *)
					If[modelContainerTareWeight <= (2 Gram),
						(* it is a small container, check *)
						(Abs[modelContainerTareWeight - containerTareWeight] / modelContainerTareWeight) <= 0.15,
						(* not a small container, so return True *)
						True
					],
					(* not both fields are uploaded, so return True *)
					True
				]
			],
			True
		],

		Test["Containers with a crimped cover should be marked as Hermetic:",
			{Download[Lookup[packet, Cover], Model[CoverType]], Lookup[packet, Hermetic]},
			{Crimp, True}|{Except[Crimp], _}
		],

		Test["Containers with CleaningMethod DishwashIntensive must have their Product field informed:",
			{Lookup[modelPacket CleaningMethod, Null], Lookup[packet, Product]},
			Alternatives[
				{DishwashIntensive, LinkP[Object[Product]]},
				{Except[DishwashIntensive], _}
			]
		],

		(* Reservoir containers *)
		Test["Containers with Reservoir slot must have its Contents filled in:",
			Module[{positions, positionList, posIndex, contents, positionName},
				positions=Download[packet, AllowedPositions];
				If[NullQ[positions],
					Return[True]
				];
				positionList=ToList[Sequence @@ positions];
				posIndex=Flatten[Position[StringPosition[positionList, "Reservoir"], {{_Integer..}}]];
				positionName=positionList[[posIndex]];
				If[MatchQ[posIndex, {_Integer..}],
					contents=Cases[Download[packet, Contents], {First[positionName], ObjectP[{Object[Container], Object[Instrument]}]}];
					MatchQ[contents, {{_String, ObjectP[{Object[Container], Object[Instrument]}]}}],
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

		(* Reusable can only be True if model's Reusable is True *)
		Test["Reusable is only True if Reusable of Model is also True:",
			{Lookup[packet, Reusable], Lookup[modelPacket, Reusable]},
			{True, True} | {Except[True], _}
		],

		(* All contents occupy positions that exist in the modelContainer *)
		containerContentsValid[packet],

		(* No container loops exist anywhere in the container's tree *)
		(* THIS TEST CAN BE VERY SLOW DEPENDING ON THE SIZE AND CONNECTEDNESS OF THE CONTAINER TREE *)
		containerLoopsAbsent[packet],

	(* If the Object has Connectors, then it must have corresponding entries in the Model's Connectors field *)
	Test["All Connector positions from this Object have entries in the Model:",
		Module[{modelConnectors,modelConnectorNames, objectConnectors, objectConnectorNames},
			modelConnectors = Download[Lookup[packet,Model],Connectors];
			modelConnectorNames = First/@modelConnectors;

				objectConnectors=Lookup[packet, Connectors];
				objectConnectorNames=First /@ objectConnectors;

			(*just check that Connectors in the Object are also in the Model*)
			MatchQ[Complement[objectConnectorNames,modelConnectorNames],{}]
		],
		True
	],

		Test["All Nuts are placed at positions present in the Object's Connectors field:",
			Complement[Lookup[packet, Nuts][[All, 1]], Lookup[packet, Connectors][[All, 1]]],
			{}
		],

		Test["All Ferrules are placed at positions present in the Object's Connectors field:",
			Complement[Lookup[packet, Ferrules][[All, 1]], Lookup[packet, Connectors][[All, 1]]],
			{}
		],

		(* the latest entry of the PlumbingFittingsLog agrees with the Nuts and Ferrules present *)
		Test["The latest entry of the PlumbingFittingsLog for each connector contains the installed Nuts and Ferrules:",
			Module[{nuts, ferrules, fittingsLog, logConnectors, mostRecentEntries, connectorNut, connectorFerrule, logNut, logFerrule, logsMatchFittingsBools},
				{nuts, ferrules, fittingsLog}=Lookup[packet, {Nuts, Ferrules, PlumbingFittingsLog}];

				(* get all the connectors in the log *)
				logConnectors=DeleteDuplicates[fittingsLog[[All, 2]]];

				(* if any nuts or ferrules are at positions not in logConnectors, return False immediately *)
				If[!MatchQ[Complement[nuts[[All, 1]], logConnectors], {}] || !MatchQ[Complement[ferrules[[All, 1]], logConnectors], {}],
					Return[False],
					Nothing
				];

				(* get the last entry for each connector *)
				mostRecentEntries=If[!MatchQ[fittingsLog, {}],
					Map[
						Function[{connector},
							(* sort the entries by most recent first, then pick the first instance of each connector in the log *)
							SelectFirst[SortBy[fittingsLog, Function[logEntry, Now - logEntry[[1]]]], StringMatchQ[#[[2]], connector] &]
						],
						logConnectors
					],
					{}
				];

				(* Map by each connector to determine if the log entry agrees with the expected nut and ferrule *)
				logsMatchFittingsBools=Map[Function[{connector},
					Module[{connectorLogEntry},
						(* this guy should always exist, it was created from the log *)
						connectorLogEntry=SelectFirst[mostRecentEntries, StringMatchQ[#[[2]], connector] &];
						(* these may not exist and return Missing. if so turn them into Null as they will be present in the log if they had been removed. strip links *)
						connectorNut=SelectFirst[nuts, StringMatchQ[#[[1]], connector] &][[2]] /. {x_Link :> Download[x, Object], _Missing -> Null};
						connectorFerrule=SelectFirst[ferrules, StringMatchQ[#[[1]], connector] &][[2]] /. {x_Link :> Download[x, Object], _Missing -> Null};
						(* strip links if there are any. they may be Null *)
						logNut=connectorLogEntry[[4]] /. {x_Link :> Download[x, Object]};
						logFerrule=connectorLogEntry[[5]] /. {x_Link :> Download[x, Object]};
						(* compare and return the result *)
						MatchQ[connectorNut, logNut] && MatchQ[connectorFerrule, logFerrule]
					]
				],
					logConnectors
				];

				(* return the And of the results from each connector *)
				And @@ logsMatchFittingsBools
			],
			True
		],

		(* the latest entry of the PlumbingSizeLog agrees with the current Size *)
		Test["The latest entry of the PlumbingSizeLog contains the current size of the Object:",
			Module[{size, sizeLog, mostRecentEntry},
				{size, sizeLog}=Lookup[packet, {Size, PlumbingSizeLog}];

				(* get the last entry in the size log *)
				mostRecentEntry=If[MatchQ[sizeLog, Except[{}]],
					First@SortBy[sizeLog, Function[logEntry, Now - logEntry[[1]]]],
					{}
				];

				(* as long as any of the lists are not empty, carry out the following check, otherwise no problem *)
				If[And[!NullQ[size], !MatchQ[mostRecentEntry, {}]],
					MatchQ[mostRecentEntry[[4]], EqualP[size]],
					True
				]
			],
			True
		],

		(* -- Wiring -- *)
		(* If the Object has WiringConnectors in its Model, then it must have corresponding entries in the Object's WiringConnectors field *)
		Test["All WiringConnectors positions from this Object's Model have entries in the Object and vice versa:",
			Module[{modelConnectors, modelConnectorNames, objectConnectors, objectConnectorNames},
				modelConnectors=Lookup[modelPacket, WiringConnectors];
				modelConnectorNames=First /@ modelConnectors;

				objectConnectors=Lookup[packet, WiringConnectors];
				objectConnectorNames=First /@ objectConnectors;

				If[MatchQ[modelConnectors, {}],
					MatchQ[objectConnectorNames, {}],
					MatchQ[objectConnectorNames, {OrderlessPatternSequence @@ modelConnectorNames}]
				]
			],
			True
		],

		(* The latest entry of the WiringLengthLog agrees with the current WiringLength *)
		Test["The latest entry of the WiringLengthLog agrees with the current WiringLength:",
			Module[{wiringLength, wiringLengthLog, mostRecentEntry},
				{wiringLength, wiringLengthLog}=Lookup[packet, {WiringLength, WiringLengthLog}];

				(* get the last entry in the wiringLength log *)
				mostRecentEntry=If[MatchQ[wiringLengthLog, Except[{}]],
					First@SortBy[wiringLengthLog, Function[logEntry, Now - logEntry[[1]]]],
					{}
				];

				(* as long as any of the lists are not empty, carry out the following check, otherwise no problem *)
				If[And[!NullQ[wiringLength], !MatchQ[mostRecentEntry, {}]],
					MatchQ[mostRecentEntry[[4]], EqualP[wiringLength]],
					True
				]
			],
			True
		],

		(*If a NextQualificationDate is given,it must be for one of the qualification models specified in QualificationFrequency*)
		Test["The qualifications entered in the NextQualificationDate field are members of the QualificationFrequency field:",
			Module[{qualFrequency, nextQualDate, qualFrequencyModels, nextQualDateModels},
				{nextQualDate, qualFrequency}=Lookup[packet, {NextQualificationDate, QualificationFrequency}];

				qualFrequencyModels=If[MatchQ[qualFrequency, Alternatives[Null, {}]], {}, First /@ qualFrequency];
				nextQualDateModels=If[MatchQ[nextQualDate, Alternatives[Null, {}]], {}, First /@ nextQualDate];

				(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
				And @@ (MemberQ[qualFrequencyModels, ObjectP[#]] & /@ nextQualDateModels)
			],
			True
		],

		(*If a NextMaintenanceDate is given,it must be for one of the maintenance models specified in MaintenanceFrequency*)
		Test["The maintenance entered in the NextMaintenanceDate field are members of the MaintenanceFrequency field:",
			Module[{maintFrequency, nextMaintDate, maintFrequencyModels, nextMaintDateModels},
				{nextMaintDate, maintFrequency}=Lookup[packet, {NextMaintenanceDate, MaintenanceFrequency}];

				maintFrequencyModels=If[MatchQ[maintFrequency, Alternatives[Null, {}]], {}, First /@ maintFrequency];
				nextMaintDateModels=If[MatchQ[nextMaintDate, Alternatives[Null, {}]], {}, First /@ nextMaintDate];

				(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
				And @@ (MemberQ[maintFrequencyModels, ObjectP[#]] & /@ nextMaintDateModels)
			],
			True
		],

		Test["If Model has at least one Product or KitProduct, object has to have Product populated",
			Module[{modelProducts, product},
				modelProducts=Download[Flatten@Lookup[modelPacket, {Products, KitProducts}], Object];
				product=Lookup[packet, Product];
				Which[
					(* if we have Product populated, we are good *)
					!NullQ[product],
					True,

					(* if we don't have any  products in the Model, we are good *)
					NullQ[product] && Length[ToList[modelProducts]] == 0,
					True,

					(* if Product is not populated but there is at least one  Product for the Model, we have a problem *)
					NullQ[product] && Length[ToList[modelProducts]] > 0,
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


(* All contents occupy positions that are defined in the corresponding modelContainer *)
(* Delete instances of {Null,Null} to allow for empty containers to pass *)
containerContentsValid[packet:PacketP[]]:=Module[
	{contModel,contents,allowedPositions},

	contModel = packet[Model];

	If[NullQ[contModel],
		Return[Nothing]
	];

	contents = packet[Contents];

	allowedPositions = Download[contModel,AllowedPositions];

	Test["All members of Contents occupy valid positions:",
		Module[
			{invalid},
			(* Any member of Contents that occupies a nonexistent position is invalid *)
			invalid = Select[
				contents,
				Not[
					MatchQ[
						First[#],
						allowedPositions
					]
				]&
			];

			MatchQ[invalid,{}]
		],
		True
	]
];


(* Make sure containers are not connected in a circular fashion *)
containerLoopsAbsent[packet:PacketP[]]:=With[
	{},
	Test["No container loops exist in this container's tree",
		containerLoopQ[packet],
		False,
		TimeConstraint->1200
	]
];


containerLoopQ[item:PacketP[]]:=Module[
	{downResult,upResult},

	downResult = Quiet[Check[Download[item[Object], Container ..],$Failed,{Download::Cycle}],{Download::Cycle,Download::FieldDoesntExist}];
	upResult = Quiet[Check[Download[item[Object], Container ..],$Failed,{Download::Cycle}],{Download::Cycle}];

	If[Or@@(MatchQ[#,$Failed]&/@{downResult,upResult}),
		True,
		False
	]
];


(* ::Subsection::Closed:: *)
(*validContainerBagQTests*)


validContainerBagQTests[packet:PacketP[Object[Container,Bag]]]:={};


(* ::Subsection::Closed:: *)
(*validContainerBagDishwasherQTests*)


validContainerBagDishwasherQTests[packet:PacketP[Object[Container,Bag,Dishwasher]]]:={
	(* Shared Fields which should be null *)
};

(* ::Subsubsection:: *)
(*validContainerBagAutoclaveQTests*)


validContainerBagAutoclaveQTests[packet:PacketP[Object[Container,Bag,Autoclave]]]:={};

validContainerBagAsepticQTests[packet:PacketP[Object[Container,Bag,Aseptic]]]:={};


(* ::Subsection::Closed:: *)
(*validContainerBoxQTests*)


validContainerBoxQTests[packet:PacketP[Object[Container,Box]]]:={};


(* ::Subsection::Closed:: *)
(*validContainerBenchQTests*)


validContainerBenchQTests[packet:PacketP[Object[Container, Bench]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet,{Product,Order,BatchNumber,DateStocked}]
};


(* ::Subsection::Closed:: *)
(*validContainerBenchReceivingQTests*)


validContainerBenchReceivingQTests[packet:PacketP[Object[Container, Bench, Receiving]]]:={
	(* ReceivingPosition should not be Null *)
	NotNullFieldTest[packet, {ReceivingPosition}]
};


(* ::Subsection::Closed:: *)
(*validContainerBuildingQTests*)


validContainerBuildingQTests[packet:PacketP[Object[Container,Building]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet,
		{
			(* Shared Fields which should be null *)
			Product,
			Order,
			BatchNumber,
			DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerCabinetQTests*)


validContainerCabinetQTests[packet:PacketP[Object[Container,Cabinet]]]:={

	NullFieldTest[packet,{
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};

(* ::Subsection::Closed:: *)
(*validContainerCapillaryQTests*)


validContainerCapillaryQTests[packet:PacketP[Object[Container, Capillary]]]:={};


(* ::Subsection::Closed:: *)
(*validContainerExtractionCartridgeQTests*)


validContainerExtractionCartridgeQTests[packet:PacketP[Object[Container,ExtractionCartridge]]]:={
	NotNullFieldTest[packet,Model]
};


(* ::Subsection::Closed:: *)
(*validContainerCartDockQTests*)


validContainerCartDockQTests[packet:PacketP[Object[Container,CartDock]]]:={
	NotNullFieldTest[packet,{
		(* Shared Fields which should not be null *)
		MicroControllerIP,
		CartDockStatus,
		Occupied
	}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerCentrifugeRotorQTests*)


validContainerCentrifugeRotorQTests[packet:PacketP[Object[Container,CentrifugeRotor]]]:={
	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};



(* ::Subsection::Closed:: *)
(*validContainerCentrifugeBucketQTests*)


validContainerCentrifugeBucketQTests[packet:PacketP[Object[Container,CentrifugeBucket]]]:={
	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		BatchNumber
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerColonyHandlerHeadCassetteHolderQTests*)


validContainerColonyHandlerHeadCassetteHolderQTests[packet:PacketP[Object[Container,ColonyHandlerHeadCassetteHolder]]]:={

	NotNullFieldTest[
		packet,
		{
			ColonyHandlerHeadCassette
		}
	],

	Test["The ColonyHandlerHeadCassetteHolder of the ColonyHandlerHeadCassette must be this object",
		MatchQ[
			Download[Lookup[packet,ColonyHandlerHeadCassette,Null],ColonyHandlerHeadCassetteHolder[Object]],
			ObjectP[Lookup[packet,Object]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validContainerCuvetteQTests*)


validContainerCuvetteQTests[packet:PacketP[Object[Container,Cuvette]]]:={
	NotNullFieldTest[
		packet,
		{
			Product,
			DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerDeckQTests*)


validContainerDeckQTests[packet:PacketP[Object[Container,Deck]]]:={
	NullFieldTest[
		packet,
		{
			(* Shared Fields which should be null *)
			Product,
			Order,
			BatchNumber,
			DateStocked
		}
	],

	(* Unique fields which should not be null*)
	NotNullFieldTest[packet,Instruments]
};


(* ::Subsection::Closed:: *)
(*validContainerDosingHeadQTests*)


validContainerDosingHeadQTests[packet:PacketP[Object[Container,DosingHead]]]:={
};


(* ::Subsection:: *)
(*validContainerElectricalPanelQTests*)


validContainerElectricalPanelQTests[packet:PacketP[Object[Container,ElectricalPanel]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerEnclosureQTests*)


validContainerEnclosureQTests[packet:PacketP[Object[Container,Enclosure]]]:={

	NullFieldTest[
		packet,
		{
			(* Shared Fields which should be null *)
			Product,
			Order,
			BatchNumber,
			DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerFlammableCabinetQTests*)


validContainerFlammableCabinetQTests[packet:PacketP[Object[Container,FlammableCabinet]]]:={

	NullFieldTest[
		packet,
		{
			(* Shared Fields which should be null *)
			Product,
			Order,
			BatchNumber,
			DateStocked
		}
	]
};



(* ::Subsection::Closed:: *)
(*validContainerFiberSampleHolderQTests*)


validContainerFiberSampleHolderQTests[packet:PacketP[Object[Container,FiberSampleHolder]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerFloatingRackQTests*)


validContainerFloatingRackQTests[packet:PacketP[Object[Container,FloatingRack]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerFloorQTests*)


validContainerFloorQTests[packet:PacketP[Object[Container,Floor]]]:={

	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerGasCylinderQTests*)


validContainerGasCylinderQTests[packet:PacketP[Object[Container,GasCylinder]]]:={

	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		BatchNumber
		}
	],

	Test["If the gas cylinder is InUse the PressureSensor field must be populated:",
		{Lookup[packet,Status],Lookup[packet,PressureSensor],Lookup[packet, LiquidLevelSensor], Lookup[packet,CurrentProtocol]},
		(*If a cylinder is InUse by a protocol it should not have a sensor yet. It is resource picked and the sensor is added in the parser*)
		{InUse, NullP, NullP, ObjectP[Object[Maintenance,InstallGasCylinder]]} |
			(*After installation a cylinder should be InUse with a sensor and no current protocol*)
			{InUse,ObjectP[Object[Sensor,Pressure]],NullP,NullP} | {InUse,NullP,ObjectP[Object[Sensor,LiquidLevel]],NullP} | {Except[InUse],NullP,NullP,NullP}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerGraduatedCylinderQTests*)


validContainerGraduatedCylinderQTests[packet:PacketP[Object[Container,GraduatedCylinder]]]:={
	NotNullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		DateStocked
	}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerGrindingContainerQTests*)


validContainerGrindingContainerQTests[packet:PacketP[Object[Container, GrindingContainer]]]:={};

(* ::Subsection::Closed:: *)
(*validContainerGrinderTubeHolderQTests*)


validContainerGrinderTubeHolderQTests[packet:PacketP[Object[Container, GrinderTubeHolder]]] := {};


(* ::Subsection::Closed:: *)
(*validContainerHemocytometerQTests*)


validContainerHemocytometerQTests[packet:PacketP[Object[Container,Hemocytometer]]]:={

};


(* ::Subsection:: *)
(*validContainerJunctionBoxQTests*)


validContainerJunctionBoxQTests[packet:PacketP[Object[Container,JunctionBox]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerMicrofluidicChipQTests*)


validContainerMicrofluidicChipQTests[packet:PacketP[Object[Container,MicrofluidicChip]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerNMRSpinnerQTests*)


validContainerNMRSpinnerQTests[packet:PacketP[Object[Container,NMRSpinner]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerMagazineRackQTests*)


validContainerMagazineRackQTests[packet:PacketP[Object[Container,MagazineRack]]]:={
	NotNullFieldTest[packet,{
		Model
	}]
};

(* ::Subsection::Closed:: *)
(*validContainerPhaseSeparatorQTests*)


validContainerPhaseSeparatorQTests[packet:PacketP[Object[Container,PhaseSeparator]]]:= {

	NotNullFieldTest[packet, {
		Model,
		CartridgeWorkingVolume,
		Tabbed,
		MaxRetentionTime,
		ContainerMaterials
	}]

};


(* ::Subsection::Closed:: *)
(*validContainerPlateSealMagazineQTests*)


validContainerPlateSealMagazineQTests[packet:PacketP[Object[Container,PlateSealMagazine]]]:={
	NotNullFieldTest[packet,{
		Model
	}]
};

(* ::Subsection::Closed:: *)
(*validContainerMicroscopeSlideQTests*)


validContainerMicroscopeSlideQTests[packet:PacketP[Object[Container,MicroscopeSlide]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerOperatorCartQTests*)


validContainerOperatorCartQTests[packet:PacketP[Object[Container,OperatorCart]]]:={

	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	],

	Test["A standard lab cart has all its expected accoutrements in its contents list:",
		Module[{cartContents,maintenance,download,contentModels,expectedModels},
			cartContents=Lookup[packet,Contents][[All,2]];
			maintenance=Search[Model[Maintenance, Clean, OperatorCart],Any[Targets==Lookup[packet,Model]],MaxResults->1];

			download=Download[
				{cartContents,maintenance},
				{
					{Model[Object]},
					{Ethanol[Object], Acetone[Object], Isopropanol[Object], Methanol[Object], Water[Object], Blade[Object], BoxCutter[Object], PlateSealRoller[Object], WasteBin[Object]}
				}
			];

			contentModels=Flatten[download[[1]],1];
			expectedModels=Flatten[download[[2]],1];

			MatchQ[Complement[expectedModels,contentModels],{}]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validContainerPlateQTests*)


validContainerPlateQTests[packet:PacketP[Object[Container,Plate]]]:={

	NotNullFieldTest[packet,{
		(* Shared Fields which should not be null *)
		DateStocked
		}
	],

	(*If the plate is a custom printed Uncle adapter plate, the product should not be informed since we printed it in house*)
		If[MatchQ[packet[Model],ObjectP[Model[Container, Plate, "id:GmzlKjP9KdJ9"]]],
			NullFieldTest[packet,Product],
			NotNullFieldTest[packet,Product]
		],

	Test["Any given well may not be occupied by more than one sample:",
		With[{counts = Values[CountsBy[Lookup[packet, Contents], #[[1]]&]]},
			If[MemberQ[counts, GreaterP[1]],
				False,
				True
			]
		],
		True
	],

	(* Test that the plate hasn't had multiple uses by the same MALDI protocol as it indicates the parser was run too many times *)
	Module[{cleaningHistoryTally},

		(* Tally the objects responsible for cleanings *)
		cleaningHistoryTally = Tally@Download[
			Lookup[packet,UsageLog][[All,2]],
			Object
		];

		(* Generate a test that ensures the number of protocols that used the plate doesn't include any duplicates for MALDI protocols (parsed too many times) *)
		Test["The CleaningLog does not contain any duplicate protocol entries:",
			cleaningHistoryTally,
			Null|{}|{{ObjectP[Object[Protocol]],LessEqualP[1]}..}
		]
	],

	Test["NumberOfUses matches the length of UsageLog:",
		Or[
			(* Either there is no UsageLog so NumberOfUses -> Null or 0 *)
			MatchQ[Lookup[packet,UsageLog],{}] && Or[NullQ[Lookup[packet,NumberOfUses]],MatchQ[NullQ[Lookup[packet,NumberOfUses]],0]],
			(* Or if UsageLog is filled in, the length of UsageLog matches NumberOfUses*)
			MatchQ[Length[Lookup[packet,UsageLog]],Lookup[packet,NumberOfUses]]
		],
		True
	],

	Test["If a container is marked as Available it should have contents or be restricted or reusable:",
		Or[
			(* If it is not Available, then we are good *)
			!MatchQ[Lookup[packet,Status],Available],
			MatchQ[Lookup[packet,Status],Available]&&(!MatchQ[Lookup[packet,Contents],{}]||MatchQ[Lookup[packet,Restricted],True]||MatchQ[Download[packet[Model],Reusable],True])
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validContainerPlateDialysisQTests*)


validContainerPlateDialysisQTests[packet:PacketP[Object[Container,Plate,Dialysis]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerPlateFilterQTests*)


validContainerPlateFilterQTests[packet:PacketP[Object[Container,Plate,Filter]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerPlateIrregularQTests*)


validContainerPlateIrregularQTests[packet:PacketP[Object[Container,Plate,Irregular]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerPlateIrregularArrayCardQTests*)


validContainerPlateIrregularArrayCardQTests[packet:PacketP[Object[Container,Plate,Irregular,ArrayCard]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerPlateIrregularRamanQTests*)


validContainerPlateIrregularRamanQTests[packet:PacketP[Object[Container, Plate, Irregular, Raman]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerPlateIrregularCapillaryELISAQTests*)


validContainerPlateIrregularCapillaryELISAQTests[packet:PacketP[Object[Container,Plate,Irregular,CapillaryELISA]]]:={

	(* Shared Fields which should not be Null *)
	NotNullFieldTest[packet,{
		Status,
		Reusable,
		Product,
		Order,
		BatchNumber,
		DateStocked,
		StorageCondition
		(*
		ExpirationDate,
		Expires
		*)
	}]

};


(* ::Subsection::Closed:: *)
(*validContainerPlateIrregularCrystallizationQTests*)


validContainerPlateIrregularCrystallizationQTests[packet:PacketP[Object[Container,Plate,Irregular,Crystallization]]]:={
};

(* ::Subsection::Closed:: *)
(*validContainerPortableCoolerQTests*)


validContainerPortableCoolerQTests[packet:PacketP[Object[Container,PortableCooler]]]:={

	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Order,
		BatchNumber,
		DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerPortableHeaterQTests*)


validContainerPortableHeaterQTests[packet:PacketP[Object[Container,PortableHeater]]]:={

	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Order,
		BatchNumber,
		DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerProteinCapillaryElectrophoresisCartridgeQTests*)


validContainerProteinCapillaryElectrophoresisCartridgeQTests[packet:PacketP[Object[Container,ProteinCapillaryElectrophoresisCartridge]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {TransfersOut,Volume}],

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Status,Reusable,Product,Model,ExperimentType,MaxNumberOfUses,Expires,MaxInjections,OptimalMaxInjections,MaxInjectionsPerBatch,
		NumberOfUses
	}],

	(* Other Tests  *)
	Test["NumberOfUses should be equal to length of InjectionLog:",
		If[MatchQ[Lookup[packet,Status],Except[InUse]],
			((Lookup[packet,NumberOfUses]) /. {Null -> 0}) === Length[Download[Lookup[packet, InjectionLog]]],
			True
		],
		True
	],

	(* if the experiment is CESDS or CESDS-Plus, OnBoard Insert and OnBoardRunningBuffer need to be informed, otherwise, electrolytes need to be informed *)\
	If[MatchQ[Lookup[packet, ExperimentType], Alternatives[CESDS, CESDSPlus],
		NotNullFieldTest[packet,{OnBoardRunningBuffer,OnBoardInsert}],
		NotNullFieldTest[packet,{OnBoardElectrolytes}]
	]],

	(*Min/Max voltage sanity check*)
	FieldComparisonTest[packet, {MinVoltage, MaxVoltage}, LessEqual],

	(*Min/max sample volume sanity check*)
	FieldComparisonTest[packet, {MinAssayVolume, MaxAssayVolume}, LessEqual],

	(*Min/max pI/MW sanity check*)
	If[MatchQ[Lookup[packet, ExperimentType], Alternatives[CESDS, CESDSPlus],
		FieldComparisonTest[packet, {MinMolecularWeightCESDS, MaxMolecularWeightCESDS}, LessEqual],
		FieldComparisonTest[packet, {MinIsoelectricPointCIEF, MaxIsoelectricPointCIEF}, LessEqual]
	]]
};



(* ::Subsection::Closed:: *)
(*validContainerProteinCapillaryElectrophoresisCartridgeInsertQTests*)


validContainerProteinCapillaryElectrophoresisCartridgeInsertQTests[packet:PacketP[Object[Container,ProteinCapillaryElectrophoresisCartridgeInsert]]]:={

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Status,Reusable,Product,Model
	}]
};



(* ::Subsection::Closed:: *)
(*validContainerRackQTests*)


validContainerRackQTests[packet:PacketP[Object[Container,Rack]]]:={
	NotNullFieldTest[packet,{
		Model
	}],

	(* Make sure parts storage racks can never used for regular storage  *)
	Test["Racks intended for Instrument part storage can never be used for general storage:",
		If[MatchQ[Lookup[packet,InstrumentSupplied],{ObjectP[]..}],
			MatchQ[Lookup[packet, {ProvidedStorageCondition,TopLevelStorageDestination}], {Null, Except[True]}],
			True
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validContainerRackDishwasherQTests*)


validContainerRackDishwasherQTests[packet:PacketP[Object[Container,Rack,Dishwasher]]]:={

};


(* ::Subsubsection::Closed:: *)
(*validContainerRackInsulatedCoolerQTests*)


validContainerRackInsulatedCoolerQTests[packet:PacketP[Object[Container,Rack,InsulatedCooler]]]:={
	
	NotNullFieldTest[packet,{
		DefaultContainer
	}]
};



(* ::Subsection::Closed:: *)
(*validContainerReactionVesselQTests*)


validContainerReactionVesselQTests[packet:PacketP[Object[Container,ReactionVessel]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerReactionVesselMicrowaveQTests*)


validContainerReactionVesselMicrowaveQTests[packet:PacketP[Object[Container,ReactionVessel, Microwave]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerReactionVesselSolidPhaseSynthesisQTests*)


validContainerReactionVesselSolidPhaseSynthesisQTests[packet:PacketP[Object[Container,ReactionVessel, SolidPhaseSynthesis]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerReactionVesselElectrochemicalSynthesisQTests*)


validContainerReactionVesselElectrochemicalSynthesisQTests[packet:PacketP[Object[Container,ReactionVessel,ElectrochemicalSynthesis]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerRoomQTests*)


validContainerRoomQTests[packet:PacketP[Object[Container,Room]]]:={
	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerSafeQTests*)


validContainerSafeQTests[packet:PacketP[Object[Container,Safe]]]:={
	NullFieldTest[packet,{
	(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
	}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerShelfQTests*)


validContainerShelfQTests[packet:PacketP[Object[Container,Shelf]]]:={
	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};



(* ::Subsection::Closed:: *)
(*validContainerShelvingUnitQTests*)


validContainerShelvingUnitQTests[packet:PacketP[Object[Container,ShelvingUnit]]]:={
	NullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		Order,
		BatchNumber,
		DateStocked
		}
	]
};



(* ::Subsection::Closed:: *)
(*validContainerShippingQTests*)


validContainerShippingQTests[packet:PacketP[Object[Container, Shipping]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[
		packet,
		{
			Product,
			BatchNumber
		}
	]
};



(* ::Subsection::Closed:: *)
(*validContainerSyringeQTests*)


validContainerSyringeQTests[packet:PacketP[Object[Container,Syringe]]]:={

	NotNullFieldTest[packet,{
		(* Shared Fields which should be null *)
		Product,
		DateStocked,
		Order
	}
	]
};


(* ::Subsection::Closed:: *)
(*validContainerSyringeQTests*)


validContainerSyringeToolQTests[packet:PacketP[Object[Container,SyringeTool]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerVesselQTests*)


validContainerVesselQTests[packet:PacketP[Object[Container,Vessel]]]:={

	Test["If a container is marked as Available it should have contents or be restricted or resuable:",
		Or[
			(* If it is not Available, then we are good *)
			!MatchQ[Lookup[packet,Status],Available],
			MatchQ[Lookup[packet,Status],Available]&&(!MatchQ[Lookup[packet,Contents],{}]||MatchQ[Lookup[packet,Restricted],True]||MatchQ[Download[packet[Model],Reusable],True])
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(* validContainerVesselBagQTests *)


validContainerVesselBagQTests[packet:PacketP[Object[Container,Vessel,Bag]]]:={
};


(* ::Subsection::Closed:: *)
(* validContainerVesselBufferCartridgeQTests *)


validContainerVesselBufferCartridgeQTests[packet:PacketP[Object[Container,Vessel,BufferCartridge]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerVesselDialysisQTests*)


validContainerVesselDialysisQTests[packet:PacketP[Object[Container,Vessel,Dialysis]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerVesselFilterQTests*)


validContainerVesselFilterQTests[packet:PacketP[Object[Container,Vessel,Filter]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerVesselVolumetricFlaskQTests*)


validContainerVesselVolumetricFlaskQTests[packet:PacketP[Object[Container,Vessel,VolumetricFlask]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerVesselGasWashingBottleQTests*)


validContainerVesselGasWashingBottleQTests[packet:PacketP[Object[Container,Vessel,GasWashingBottle]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerWashBathQTests*)


validContainerWashBathQTests[packet:PacketP[Object[Container,WashBath]]]:={};


(* ::Subsection::Closed:: *)
(*validContainerWashBinQTests*)


validContainerWashBinQTests[packet:PacketP[Object[Container,WashBin]]]:={

	NotNullFieldTest[packet,{CleaningType}],

	Test["The CleaningType must match the CleaningType of the washbin's model:",
		SameQ[Lookup[packet,CleaningType],Download[Lookup[packet,Model],CleaningType]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validContainerWasteBinQTests*)


validContainerWasteBinQTests[packet:PacketP[Object[Container,WasteBin]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerWasteQTests*)


validContainerWasteQTests[packet:PacketP[Object[Container,Waste]]]:={
(* Shared Fields which should be null *)
	NotNullFieldTest[packet, WasteType],

	NullFieldTest[packet, {
		Order,
		BatchNumber,
		Product
	}]
};


(* ::Subsection::Closed:: *)
(*validContainerSiteQTests*)


validContainerSiteQTests[packet:PacketP[Object[Container, Site]]]:={

	NotNullFieldTest[packet,{StreetAddress,PostalCode,Country}],

	Test["If RepresentativeDestinations is populated, at least the first digit of each US ZIP code has a representative address on file:",
		If[!MatchQ[Lookup[packet,RepresentativeDestinations],{}],
			Module[{repDestinations,regions,firstDiggies},
				repDestinations=Lookup[packet,RepresentativeDestinations];

				(* get the regions covered; we check for duplicates in another test, so ignore here *)
				regions=DeleteDuplicates@Lookup[repDestinations,PostalCodeRegion];

				(* pare these all down to their first digit *)
				firstDiggies=StringFirst/@regions;

				(* these first diggies better cover 0-9 *)
				ContainsAll[firstDiggies,CharacterRange["0","9"]]
			],
			True
		],
		True
	],

	Test["If RepresentativeDestinations is populated, no duplicates or overlapping PostalCodeRegion entries are present:",
		If[!MatchQ[Lookup[packet,RepresentativeDestinations],{}],
			Module[{repDestinations,regions},
				repDestinations=Lookup[packet,RepresentativeDestinations];

				(* get the regions covered *)
				regions=Lookup[repDestinations,PostalCodeRegion];

				(* has to be duplicate free *)
				If[!DuplicateFreeQ[regions],
					Return[False]
				];

				(* for each of these, there shouldn't be something else in the list that is the "larger" region (i.e. starts with the same first few digits) *)
				regionValidities=MapIndexed[
					Function[{regionZipShard,index},
						Module[{zipShardCharacters,pattern},

							(* separate zip shard into digit characters; we just want Most to look "up" for larger regions *)
							zipShardCharacters=Characters[regionZipShard];

							(* generate a string pattern for Most of the zip shard, recursively *)
							pattern=Alternatives@@Most[FoldList[StringJoin,zipShardCharacters]];

							(* see if this pattern is in the overall list; don't check this exact entry! *)
							If[MemberQ[Drop[regions,index],patt],
								False,
								True
							]
						]
					],
					regions
				];

				(* all have to be valid *)
				And@@regionValidities
			],
			True
		],
		True
	],

	Test["Notebook is populated (unless this is a public ECL site):",
		If[MatchQ[Lookup[packet,Object],ObjectP[$Site] | ObjectP[Object[Container, Site, "GENEWIZ"]]],
			True,
			!NullQ[Lookup[packet, Notebook]]
		],
		True
	],

	(* make sure we have all necessary address information for the shipping *)
	Test["State should be populated for Australia, Malaysia and US:",
		Lookup[packet, {Country, State}],
		Alternatives[
			{"United States", UnitedStateAbbreviationP},
			{"Australia", AustralianStatesP},
			{"Malaysia", MalaysianStatesP},
			{Except[CountryWithStatesP], NullP}
		]
	],

	Test["Province should be populated for Canada:",
		Lookup[packet, {Country, Province}],
		Alternatives[
			{CountryWithProvincesP, CanadianProvincesP},
			{Except[CountryWithProvincesP], NullP}
		]
	],

	Test["City should be populated for all countries except Malaysia and Ireland:",
		Lookup[packet, {Country, City}],
		Alternatives[
			{Except[CountryWithLocalityP],CityP},
			{CountryWithLocalityP, __}
		]
	],

	Test["Locality should be populated for Malaysia, United Kingdom, and Ireland:",
		Lookup[packet, {Country, Locality}],
		Alternatives[
			{Except[CountryWithLocalityP],NullP},
			{CountryWithLocalityP, LocalityP}
		]
	],

	Test["County should be populated for Ireland and United Kingdom:",
		Lookup[packet, {Country, County}],
		Alternatives[
			{Except[CountryWithCountyP],NullP},
			{CountryWithCountyP, CountyP}
		]
	]

};



(* ::Subsection::Closed:: *)
(*validContainerBumpTrapQTests*)


validContainerBumpTrapQTests[packet:PacketP[Object[Container,BumpTrap]]]:={

};



(* ::Subsubsection::Closed:: *)
(*validContainerPlateCapillaryStripQTests*)


validContainerPlateCapillaryStripQTests[packet:PacketP[Object[Container, Plate, CapillaryStrip]]] :={

	(*Shared fields*)
	NotNullFieldTest[packet, {
		Reusable,
		RecommendedFillVolume
	}]
};


(* ::Subsubsection::Closed:: *)
(*validContainerPlateDropletCartridgeQTests*)


validContainerPlateDropletCartridgeQTests[packet:PacketP[Object[Container, Plate, DropletCartridge]]] :={

	(*Shared fields*)
	NotNullFieldTest[packet, {
		Model,
		DropletsFromSampleVolume,
		AverageDropletVolume
	}]
};


(* ::Subsection::Closed:: *)
(*validContainerCrossFlowQTests*)


validContainerVesselCrossFlowQTests[packet:PacketP[Object[Container,Vessel,CrossFlowContainer]]]:={

	NotNullFieldTest[packet,{
		Model,
		Connectors
	}],
	
	Test[
		"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
		{True,True,True}
	]
};



(* ::Subsection::Closed:: *)
(*validWashContainerCrossFlowQTests*)


validWashContainerVesselCrossFlowQTests[packet:PacketP[Object[Container,Vessel,CrossFlowWashContainer]]]:={
	
	NotNullFieldTest[packet,{
		Model,
		Connectors
	}],
	
	Test[
		"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
		{True,True,True}
	]
	
};


(* ::Subsection::Closed:: *)
(*validContainerPlateMALDIQTests*)


validContainerPlateMALDIQTests[packet:PacketP[Object[Container,Plate,MALDI]]]:={

};

(* ::Subsection::Closed:: *)
(*validContainerPlatePhaseSeparatorQTests*)


validContainerPlatePhaseSeparatorQTests[packet:PacketP[Object[Container,Plate,PhaseSeparator]]]:={

};



(* ::Subsection::Closed:: *)
(*validContainerLightBoxQTests*)


validContainerLightBoxQTests[packet:PacketP[Object[Container,LightBox]]]:={

};


(* ::Subsection::Closed:: *)
(*validContainerFoamAgitationModuleQTests*)


validContainerFoamAgitationModuleQTests[packet:PacketP[Object[Container,FoamAgitationModule]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerFoamColumnQTests*)


validContainerFoamColumnQTests[packet:PacketP[Object[Container,FoamColumn]]]:={
};



(* ::Subsection::Closed:: *)
(*validContainerStandQTests*)


validContainerStandQTests[packet:PacketP[Object[Container,Stand]]]:={
};



(* ::Subsection::Closed:: *)
(*validContainerClampQTests*)


validContainerClampQTests[packet:PacketP[Object[Container,Clamp]]]:={
};


(* ::Subsection::Closed:: *)
(*validContainerSpillKitQTests*)


validContainerSpillKitQTests[packet:PacketP[Object[Container,SpillKit]]]:={
};



(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Container],validContainerQTests];
registerValidQTestFunction[Object[Container, Bag],validContainerBagQTests];
registerValidQTestFunction[Object[Container, Bag, Dishwasher],validContainerBagDishwasherQTests];
registerValidQTestFunction[Object[Container, Bag, Aseptic],validContainerBagAsepticQTests];
registerValidQTestFunction[Object[Container, Bag, Autoclave],validContainerBagAutoclaveQTests];
registerValidQTestFunction[Object[Container, Box],validContainerBoxQTests];
registerValidQTestFunction[Object[Container, Bench],validContainerBenchQTests];
registerValidQTestFunction[Object[Container, Bench, Receiving],validContainerBenchReceivingQTests];
registerValidQTestFunction[Object[Container, Building],validContainerBuildingQTests];
registerValidQTestFunction[Object[Container, BumpTrap],validContainerBumpTrapQTests];
registerValidQTestFunction[Object[Container, Cabinet],validContainerCabinetQTests];
registerValidQTestFunction[Object[Container, Capillary],validContainerCapillaryQTests];
registerValidQTestFunction[Object[Container, CartDock],validContainerCartDockQTests];
registerValidQTestFunction[Object[Container, Clamp],validContainerClampQTests];
registerValidQTestFunction[Object[Container, ExtractionCartridge],validContainerExtractionCartridgeQTests];
registerValidQTestFunction[Object[Container, CentrifugeBucket],validContainerCentrifugeBucketQTests];
registerValidQTestFunction[Object[Container, CentrifugeRotor],validContainerCentrifugeRotorQTests];
registerValidQTestFunction[Object[Container, ColonyHandlerHeadCassetteHolder],validContainerColonyHandlerHeadCassetteHolderQTests];
registerValidQTestFunction[Object[Container, Cuvette],validContainerCuvetteQTests];
registerValidQTestFunction[Object[Container, Deck],validContainerDeckQTests];
registerValidQTestFunction[Object[Container, DosingHead],validContainerDosingHeadQTests];
registerValidQTestFunction[Object[Container, ElectricalPanel],validContainerElectricalPanelQTests];
registerValidQTestFunction[Object[Container, Enclosure],validContainerEnclosureQTests];
registerValidQTestFunction[Object[Container, FlammableCabinet],validContainerFlammableCabinetQTests];
registerValidQTestFunction[Object[Container, FiberSampleHolder],validContainerFiberSampleHolderQTests];
registerValidQTestFunction[Object[Container, FloatingRack],validContainerFloatingRackQTests];
registerValidQTestFunction[Object[Container, Floor],validContainerFloorQTests];
registerValidQTestFunction[Object[Container, FoamAgitationModule],validContainerFoamAgitationModuleQTests];
registerValidQTestFunction[Object[Container, FoamColumn],validContainerFoamColumnQTests];
registerValidQTestFunction[Object[Container, GasCylinder],validContainerGasCylinderQTests];
registerValidQTestFunction[Object[Container, GraduatedCylinder],validContainerGraduatedCylinderQTests];
registerValidQTestFunction[Object[Container, GrinderTubeHolder],validContainerGrinderTubeHolderQTests];
registerValidQTestFunction[Object[Container, GrindingContainer],validContainerGrindingContainerQTests];
registerValidQTestFunction[Object[Container,Hemocytometer],validContainerHemocytometerQTests];
registerValidQTestFunction[Object[Container,JunctionBox],validContainerJunctionBoxQTests];
registerValidQTestFunction[Object[Container,LightBox],validContainerLightBoxQTests];
registerValidQTestFunction[Object[Container,MagazineRack],validContainerMagazineRackQTests];
registerValidQTestFunction[Object[Container,MicrofluidicChip],validContainerMicrofluidicChipQTests];
registerValidQTestFunction[Object[Container,MicroscopeSlide],validContainerMicroscopeSlideQTests];
registerValidQTestFunction[Object[Container,NMRSpinner],validContainerNMRSpinnerQTests];
registerValidQTestFunction[Object[Container,OperatorCart],validContainerOperatorCartQTests];
registerValidQTestFunction[Object[Container,Plate],validContainerPlateQTests];
registerValidQTestFunction[Object[Container,Plate,Dialysis],validContainerPlateDialysisQTests];
registerValidQTestFunction[Object[Container,Plate,DropletCartridge],validContainerPlateDropletCartridgeQTests];
registerValidQTestFunction[Object[Container,Plate,Filter],validContainerPlateFilterQTests];
registerValidQTestFunction[Object[Container,Plate,Irregular],validContainerPlateIrregularQTests];
registerValidQTestFunction[Object[Container,Plate,Irregular,ArrayCard],validContainerPlateIrregularArrayCardQTests];
registerValidQTestFunction[Object[Container,Plate, Irregular, Raman], validContainerPlateIrregularRamanQTests];
registerValidQTestFunction[Object[Container,Plate,Irregular,CapillaryELISA],validContainerPlateIrregularCapillaryELISAQTests];
registerValidQTestFunction[Object[Container,Plate,Irregular,Crystallization],validContainerPlateIrregularCrystallizationQTests];
registerValidQTestFunction[Object[Container,PlateSealMagazine],validContainerPlateSealMagazineQTests];
registerValidQTestFunction[Object[Container,PortableCooler],validContainerPortableCoolerQTests];
registerValidQTestFunction[Object[Container,PortableHeater],validContainerPortableHeaterQTests];
registerValidQTestFunction[Object[Container,Rack],validContainerRackQTests];
registerValidQTestFunction[Object[Container,Rack,Dishwasher],validContainerRackDishwasherQTests];
registerValidQTestFunction[Object[Container,Rack,InsulatedCooler],validContainerRackInsulatedCoolerQTests];
registerValidQTestFunction[Object[Container,ReactionVessel],validContainerReactionVesselQTests];
registerValidQTestFunction[Object[Container,ReactionVessel, Microwave],validContainerReactionVesselMicrowaveQTests];
registerValidQTestFunction[Object[Container,ReactionVessel, SolidPhaseSynthesis],validContainerReactionVesselSolidPhaseSynthesisQTests];
registerValidQTestFunction[Object[Container,ReactionVessel,ElectrochemicalSynthesis],validContainerReactionVesselElectrochemicalSynthesisQTests];
registerValidQTestFunction[Object[Container,Room],validContainerRoomQTests];
registerValidQTestFunction[Object[Container,Safe],validContainerSafeQTests];
registerValidQTestFunction[Object[Container,Shelf],validContainerShelfQTests];
registerValidQTestFunction[Object[Container,ShelvingUnit],validContainerShelvingUnitQTests];
registerValidQTestFunction[Object[Container,Shipping],validContainerShippingQTests];
registerValidQTestFunction[Object[Container,Stand],validContainerStandQTests];
registerValidQTestFunction[Object[Container,Syringe],validContainerSyringeQTests];
registerValidQTestFunction[Object[Container,SyringeTool],validContainerSyringeToolQTests];
registerValidQTestFunction[Object[Container,Vessel],validContainerVesselQTests];
registerValidQTestFunction[Object[Container,Vessel,Bag],validContainerVesselBagQTests];
registerValidQTestFunction[Object[Container,Vessel,BufferCartridge],validContainerVesselBufferCartridgeQTests];
registerValidQTestFunction[Object[Container,Vessel,CrossFlowContainer],validContainerVesselCrossFlowQTests];
registerValidQTestFunction[Object[Container,Vessel,CrossFlowWashContainer],validWashContainerVesselCrossFlowQTests];
registerValidQTestFunction[Object[Container,Vessel,Dialysis],validContainerVesselDialysisQTests];
registerValidQTestFunction[Object[Container,Vessel,Filter],validContainerVesselFilterQTests];
registerValidQTestFunction[Object[Container,Vessel,VolumetricFlask],validContainerVesselVolumetricFlaskQTests];
registerValidQTestFunction[Object[Container,Vessel,GasWashingBottle],validContainerVesselGasWashingBottleQTests];
registerValidQTestFunction[Object[Container,WashBath],validContainerWashBathQTests];
registerValidQTestFunction[Object[Container,WashBin],validContainerWashBinQTests];
registerValidQTestFunction[Object[Container,WasteBin],validContainerWasteBinQTests];
registerValidQTestFunction[Object[Container,Waste],validContainerWasteQTests];
registerValidQTestFunction[Object[Container,Site],validContainerSiteQTests];
registerValidQTestFunction[Object[Container,Plate,CapillaryStrip],validContainerPlateCapillaryStripQTests];
registerValidQTestFunction[Object[Container,Plate,MALDI],validContainerPlateMALDIQTests];
registerValidQTestFunction[Object[Container,Plate,PhaseSeparator],validContainerPlatePhaseSeparatorQTests];
registerValidQTestFunction[Object[Container,ProteinCapillaryElectrophoresisCartridge],validContainerProteinCapillaryElectrophoresisCartridgeQTests];
registerValidQTestFunction[Object[Container,ProteinCapillaryElectrophoresisCartridgeInsert],validContainerProteinCapillaryElectrophoresisCartridgeInsertQTests];
registerValidQTestFunction[Object[Container,PhaseSeparator],validContainerPhaseSeparatorQTests];
registerValidQTestFunction[Object[Container,SpillKit],validContainerSpillKitQTests];
