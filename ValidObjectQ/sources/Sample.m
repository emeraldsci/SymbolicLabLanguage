(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validSampleQTests*)


validSampleQTests[packet:PacketP[Object[Sample]]]:=Module[
	{
		modelPacket, identifier, containerPacket, upStorageConditions, sampleContentModelPackets,
		uniqueSampleContentModelPackets, productCountPerSample, currentProtocolStatus, parentProtocol,
		upStorageConditionsR, sampleContentModelPacketsR, productCountPerSampleR, currentProtocolStatusR,
		parentProtocolR, modelPacketR, containerPacketR, productPacketR, productPacket, compositionNotebook,
		solventPacketR, solventPacket
	},

	(* make one single download for all the tests *)
	{
		upStorageConditionsR,
		sampleContentModelPacketsR,
		productCountPerSampleR,
		currentProtocolStatusR,
		parentProtocolR,
		modelPacketR,
		containerPacketR,
		productPacketR,
		compositionNotebook,
		solventPacketR
	} = Quiet[Download[
		{
			ToList@Lookup[packet, StoragePositions]/. (x : ObjectP[] :> {x, Null}),
			ToList@Lookup[packet, Container],
			ToList@packet,
			ToList@packet,
			ToList@Lookup[packet, Source],
			ToList@Lookup[packet, Model],
			ToList@Lookup[packet, Container],
			ToList@Lookup[packet, Product],
			ToList@packet,
			ToList@packet
		},
		{
			{Repeated[Container][ProvidedStorageCondition]}, (* super not sure if I can just move HaltingCondition to the outside + what is the ==Null doing in there? I can't seem to find this in the docs *)
			{Packet[Contents[[All, 2]][StorageCondition][{Flammable, Acid, Base, Pyrophoric}]]},
			{Product[CountPerSample]},
			{CurrentProtocol[Status]},
			{ParentProtocol..},
			{Packet[All]},
			{Packet[All]},
			{Packet[All]},
			{Packet[Composition[[All, 2]][Notebook]]},
			{Packet[ConcentratedBufferDiluent[UsedAsSolvent]]}
		},
		{
			{ProvidedStorageCondition == Null},
			{None},
			{None},
			{None},
			{None},
			{None},
			{None},
			{None},
			{None},
			{None}
		},
		HaltingCondition -> Inclusive
	], {Download::FieldDoesntExist, Download::NotLinkedField}];

	(* extract the download result from nested list *)
	{
		upStorageConditions,
		sampleContentModelPackets,
		productCountPerSample,
		currentProtocolStatus,
		parentProtocol,
		modelPacket,
		containerPacket,
		productPacket,
		solventPacket
	} = Map[
		FirstOrDefault[Flatten[#, 1], Null]&,
		{
			upStorageConditionsR,
			sampleContentModelPacketsR,
			productCountPerSampleR,
			currentProtocolStatusR,
			parentProtocolR,
			modelPacketR,
			containerPacketR,
			productPacketR,
			solventPacketR
		}
	];

	uniqueSampleContentModelPackets = DeleteDuplicates[sampleContentModelPackets /. Null -> {}];

	identifier = FirstCase[Lookup[packet, {Name, Object}], Except[_Missing], packet];

	{

		(* Expiration date tests*)
		Test["If DateStocked is informed and the model of the sample has ShelfLife informed, then ExpirationDate must be informed:",
			{
				And[
					Not[NullQ[packet[DateStocked]]],
					Not[NullQ[modelPacket]],
					Not[NullQ[modelPacket[ShelfLife]]]
				],
				Lookup[packet, ExpirationDate]
			},
			Alternatives[{True, Except[NullP]}, {Except[True], _}]
		],

		Test["If UnsealedShelfLife is informed in the model and the sample has DateUnsealed informed, then ExpirationDate must be informed:",
			{
				And[
					Not[NullQ[Lookup[packet, DateUnsealed]]],
					Not[NullQ[modelPacket]],
					Not[NullQ[modelPacket[UnsealedShelfLife]]]
				],
				Lookup[packet, ExpirationDate]
			},
			Alternatives[{True, Except[NullP]}, {Except[True], _}]
		],

		Test["If Status is not Discarded and Notebook is set, the sample has a Source:",
			If[MatchQ[Lookup[packet, Object], NonSelfContainedSampleP] && !MatchQ[Lookup[packet, Status], Discarded] && !NullQ[Lookup[packet, Notebook]] && !MatchQ[Lookup[packet, DeveloperObject], True],
				MatchQ[Lookup[packet, Source], ObjectP[]],
				True
			],
			True
		],

		(* container *)
		Test["The sample is located in a container type that can hold liquids or powders:",
			If[MatchQ[packet[Object], NonSelfContainedSampleP] && !NullQ[packet[Container]],
				MatchQ[packet[Container][Object], FluidContainerP],
				True
			],
			True
		],

		Test["The status of a fluid sample matches the status of its container:",
			If[MatchQ[Lookup[packet, Container], FluidContainerP],
				Lookup[containerPacket, Status]
			],
			Alternatives[
				Null, (* Sample's container doesn't match FluidContainerP, or it has no Container *)
				Lookup[packet, Status]
			]
		],

		Test["If sample is in a container and is AwaitingDisposal, then so is its container and vice-versa:",
			(* if sample is in container *)
			If[MatchQ[Lookup[packet, Container, Null], ObjectP[]],
				(* check that AwaitingDisposal status matches *)
				MatchQ[{Lookup[packet, AwaitingDisposal, Null], Lookup[containerPacket, AwaitingDisposal]}, {True, True}|{Except[True], Except[True]}],
				(* sample is not in container, so return True *)
				True
			],
			True
		],

		Test["If sample is in a container and is AwaitingStorageUpdate, then so is its container and vice-versa:",
			(* if sample is in container *)
			If[MatchQ[Lookup[packet, Container, Null], ObjectP[]],
				(* check that AwaitingStorageUpdate status matches *)
				MatchQ[Lookup[packet, AwaitingStorageUpdate, Null], Lookup[containerPacket, AwaitingStorageUpdate]],
				(* sample is not in container, so return True *)
				True
			],
			True
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

		(* storage *)
		Test["If Status is not Discarded, StorageCondition is filled out:",
			Lookup[packet, {Status, StorageCondition}],
			{Discarded, _} | {Except[Discarded], Except[NullP]}
		],
		Test["If the status of a fluid sample is not discarded, the sample's StorageCondition matches its container's:",
			If[
				And[
					MatchQ[packet[Object], NonSelfContainedSampleP],
					Not[MatchQ[Lookup[packet, Status], Discarded]]
				],
				SameQ[Download[Lookup[packet, StorageCondition], Object], Download[Lookup[containerPacket, StorageCondition], Object]],
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

		Test["If StoragePositions is set, all StoragePositions must provide the StorageCondition of the sample:",
			If[!MatchQ[Lookup[packet, StoragePositions], {}],
				Module[{providedStorageConditions},

					(* the provided condition is the last of each of these "up condition" objects (we stopped when we hit one) *)
					providedStorageConditions = DeleteDuplicates[Download[Cases[LastOrDefault /@ upStorageConditions, ObjectP[Model[StorageCondition]]], Object]];

					(* there should be just onbe provided condition, which is the sample's *)
					Which[
						Length[providedStorageConditions] == 1,
						MatchQ[FirstOrDefault[providedStorageConditions], Download[Lookup[packet, StorageCondition], Object]],
						Length[providedStorageConditions] > 1, False,
						True, True
					]
				],
				True
			],
			True
		],

		Test["If Status is not Discarded, Site is filled out:",
			Lookup[packet, {Status, Site}],
			{Discarded, _} | {Except[Discarded], Except[NullP]}
		],

		(* We call UploadStorageCondition in UploadEHSInformation which will throw an error for us. *)
		Test["The safety fields for all Object[Sample]s in the container match the given StorageCondition:",
			Module[{cryoOrDeepFreezerQ, modelAssociation, sampleAssociation},

				If[MatchQ[uniqueSampleContentModelPackets, {PacketP[]..}],

          (* If the storage condition is DeepFreezer or CryogenicStorage, set Flammable to True since *)
          (* we allow Flammable and non-Flammable samples to be stored under these conditions, but we *)
          (* need the values to match in this test so we don't have false failures. *)
          cryoOrDeepFreezerQ = MatchQ[
						Lookup[packet, StorageCondition],
						(* {Model[StorageCondition, "Deep Freezer"], Model[StorageCondition, "Cryogenic Storage"]} *)
						ObjectP[{Model[StorageCondition, "id:xRO9n3BVOe3z"], Model[StorageCondition, "id:6V0npvmE09vG"]}]
					];

					modelAssociation = <|
						Flammable -> If[cryoOrDeepFreezerQ,
							(* Default this to True if we have DeepFreezer or CryogenicStorage. *)
							True,
							(* With any other storage condition, we just check the value of the storage condition's Flammable field directly. *)
							AnyTrue[Lookup[uniqueSampleContentModelPackets, Flammable], TrueQ]
						],
						Acid -> If[AnyTrue[Lookup[uniqueSampleContentModelPackets, Acid], TrueQ], True],
						Base -> If[AnyTrue[Lookup[uniqueSampleContentModelPackets, Base], TrueQ], True],
						Pyrophoric -> If[AnyTrue[Lookup[uniqueSampleContentModelPackets, Pyrophoric], TrueQ], True]
					|>;

					sampleAssociation = <|
						Flammable -> If[cryoOrDeepFreezerQ,
							(* Default this to True if we have DeepFreezer or CryogenicStorage. *)
							True,
							(* With any other storage condition, we just check the value of the sample's Flammable field directly. *)
							TrueQ[Lookup[packet, Flammable]]
						],
						Acid -> If[TrueQ[Lookup[packet, Acid]], True],
						Base -> If[TrueQ[Lookup[packet, Base]], True],
						Pyrophoric -> If[TrueQ[Lookup[packet, Pyrophoric]], True]
					|>;

					MatchQ[modelAssociation, sampleAssociation],
					True
				]
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

		(* Location *)
		Test["If Status is not Discarded, the sample has a location (Container, Position informed):",
			Lookup[packet, {Status, Container, Position}],
			{Discarded, _, _} | {Except[Discarded], Except[NullP], Except[NullP]}
		],

		Test["If Status is not Discarded, the sample has a location log:",
			Lookup[packet, {Status, LocationLog}],
			{Discarded, _} | {Except[Discarded], Except[{}]}
		],

		Test["The last entry in LocationLog matches the current Position and Container:",
			{#[[4]], #[[3]][Object]}&[Last[Lookup[packet, LocationLog]]],
			{Lookup[packet, Position], Lookup[packet, Container][Object]}
		],

		(* Amounts and amount logs *)
		RequiredTogetherTest[packet, {Concentration, ConcentrationLog}],

		Test["The current Volume matches the last successful volume reading recorded in the VolumeLog:",
			TrueQ[Equal[
				Lookup[packet, Volume],
				SelectFirst[Reverse[Lookup[packet, VolumeLog]], Not[MatchQ[Last[#], VolumeMeasurementError]]&, {Null, Null, Null, Null}][[2]]
			]],
			True
		],

		Test["If the sample is not InUse and has State set to Liquid, Volume must be populated:",
			If[MatchQ[Lookup[packet, Status], Except[InUse]] && MatchQ[Lookup[packet, State], Liquid],
				VolumeQ[Lookup[packet, Volume]],
				True
			],
			True
		],

		Test["The last entry in MassLog matches the current Mass:",
			If[Lookup[packet, MassLog] == {},
				Null,
				Last[Lookup[packet, MassLog]][[2]]
			],
			Lookup[packet, Mass]
		],

		Test["The last entry in CountLog matches the current Count:",
			If[Lookup[packet, CountLog] == {},
				Null,
				Last[Lookup[packet, CountLog]][[2]]
			],
			Lookup[packet, Count]
		],

		Test["The last entry in DensityLog matches the current Density:",
			If[Lookup[packet, DensityLog] == {},
				True,
				MatchQ[Last[Lookup[packet, DensityLog]][[2]], Lookup[packet, Density]]
			],
			True
		],

		Test["If the sample's product CountPerSample field is populated, the sample's Count field also has to be populated",
			{Lookup[packet, Count], productCountPerSample},
			Alternatives[
				{Except[NullP], Except[NullP]},
				{_, _}
			]
		],

		Test["The last entry in ConcentrationLog matches the current Concentration:",
			If[Lookup[packet, ConcentrationLog] == {},
				Null,
				Last[Lookup[packet, ConcentrationLog]][[2]]
			],
			Lookup[packet, Concentration]
		],

		Test["If Status is InUse, the protocol using it must not be failed:",
			{Lookup[packet, Status], currentProtocolStatus},
			{Except[InUse], _} | {InUse, Except[Aborted]}
		],

		Test["If Status is Transit, the sample has a Destination:",
			If[MatchQ[Lookup[packet, Status], Transit],
				!NullQ[Lookup[packet, Destination]],
				True
			],
			True
		],

		(* Ownership *)
		(* Can't have samples in the lab that are public but don't have a product, since that upsets PriceMaterials *)
		Test["If Status is not Discarded or of the type Object[Sample], the sample must be linked to either a product or a notebook, or both:",
			Module[{status, source, type, product, notebook, currentProtocol, inUseByCreatorProtocol},
				If[MatchQ[Lookup[packet, DeveloperObject], True],
					True,
					(* Note: need to quiet the FieldDoesntExist Error since there is no ParentProtocol in Transaction objects *)
					{status, source, type, product, notebook, currentProtocol} = Lookup[packet, {Status, Source, Type, Product, Notebook, CurrentProtocol}];

					(* figure out if the sample is InUse by the protocol that made it because those are not invalid *)
					inUseByCreatorProtocol = (ECL`SameObjectQ[parentProtocol, currentProtocol] || ECL`SameObjectQ[source, currentProtocol]) && MatchQ[status, InUse];

					{parentProtocol, source, type, status, product, notebook, inUseByCreatorProtocol}
				]
			],

			True |

				(* we don't include samples in this check whose Root protocol is a Maintenance/Qualification as Source since those are always either Restricted or InUse and can be public/no product *)
				{ObjectP[{Object[Maintenance], Object[Qualification]}], _, _, _, _, _, _} |

				(* we don't include samples in this check that have Maintenance/Qualification as Source since those are always either Restricted or InUse and can be public/no product *)
				{_, ObjectP[{Object[Maintenance], Object[Qualification]}], _, _, _, _, _} |

				(* we don't include Waste samples in this check, since they are most of the time product- and notebook-less *)
				{_, _, Object[Sample], _, _, _, _} |

				(* we don't care if the sample is discarded, either *)
				{_, _, _, Discarded, _, _, _} |

				(* we don't care if the sample is still InUse by its creator protocol *)
				{_, _, _, InUse, _, _, True} |

				(* if the sample is neither waste nor discarded, we either have product, notebook, or both *)
				{Except[ObjectP[{Object[Maintenance], Object[Qualification]}]], Except[ObjectP[{Object[Maintenance], Object[Qualification]}]], Except[Object[Sample]], Except[Discarded], ObjectP[Object[Product]], _, _} |
				{Except[ObjectP[{Object[Maintenance], Object[Qualification]}]], Except[ObjectP[{Object[Maintenance], Object[Qualification]}]], Except[Object[Sample]], Except[Discarded], _, ObjectP[Object[LaboratoryNotebook]], _}

		],

		Test["If a sample's Source is a Maintenance/Qualification, and the sample is linked to no notebook and no product, then either its Status is InUse or the sample is Restricted:",
			If[MatchQ[Lookup[packet, Source], ObjectP[{Object[Maintenance], Object[Qualification]}] && NullQ[Lookup[packet, Notebook]]] && NullQ[Lookup[packet, Product]],
				MatchQ[Lookup[packet, Status], InUse] || MatchQ[Lookup[packet, Restricted], True],
				True],
			True
		],

		Test["All Analytes are contained within the Composition field of the Object[Sample]:",
			If[MatchQ[Lookup[packet, Analytes], _List],
				MatchQ[
					MemberQ[Lookup[packet, Composition][[All, 2]], ObjectP[#]]& /@ Download[Lookup[packet, Analytes], Object],
					{True...}
				],
				True
			],
			True,
			Message :> Hold[Error::AnalytesNotInModels],
			MessageArguments -> {identifier}
		],

		Test["If sample is public all member of Composition are public as well:",
			Or[
				MatchQ[Lookup[packet, Notebook], ObjectP[]],
				MatchQ[Lookup[packet, Composition, {}], {}],
				And[
					MatchQ[Lookup[packet, Notebook], Null],
					(* Replace any Nulls we downloaded from Composition[[All,2]][Notebook] b/c Lookup is not happy with Nulls, and will throw Lookup::invrl error *)
					With[{compositionNotebookNullReplaced=Replace[Flatten@compositionNotebook,Null->Nothing,{1}]},
						MatchQ[Lookup[compositionNotebookNullReplaced,Notebook],{Null..}]
					]
				]
			],
			True
		],

		(*If a NextQualificationDate is given,it must be for one of the qualification models specified in QualificationFrequency*)
		Test["The qualifications entered in the NextQualificationDate field are members of the QualificationFrequency field:",
			Module[{qualFrequency, nextQualDate, qualFrequencyModels, nextQualDateModels},
				{nextQualDate, qualFrequency} = Lookup[packet, {NextQualificationDate, QualificationFrequency}];

				qualFrequencyModels = If[MatchQ[qualFrequency, Alternatives[Null, {}]], {}, First /@ qualFrequency];
				nextQualDateModels = If[MatchQ[nextQualDate, Alternatives[Null, {}]], {}, First /@ nextQualDate];

				(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
				And @@ (MemberQ[qualFrequencyModels, ObjectP[#]] & /@ nextQualDateModels)
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
				And @@ (MemberQ[maintFrequencyModels, ObjectP[#]] & /@ nextMaintDateModels)
			],
			True
		],

		Test["For non-StockSolutions, if Model has at least one Product or KitProduct, object has to have Product populated",
			If[And[!NullQ[modelPacket],NullQ[Lookup[packet, Notebook]]],
				(* If Model is not Null and the object is public, do the test *)
				Module[{modelProducts, product},
					modelProducts = Flatten@Download[ToList[Lookup[modelPacket, {Products, KitProducts}]], Object];
					product = Lookup[packet, Product];
					Which[

						(* stock solution does not have to have a product - they get Price field*)
						MatchQ[Lookup[modelPacket, Object], ObjectP[Model[Sample, StockSolution]]],
						True,

						(* if we have Product populated, we are good *)
						!NullQ[product],
						True,

						(* if we don't have any  products in the Model, we are good *)
						NullQ[product]&&Length[ToList[modelProducts]]==0,
						True,

						(* if Product is not populated but there is at least one  Product for the Model, we have a problem *)
						NullQ[product]&&Length[ToList[modelProducts]]>0,
						False
					]
				],
				(* If Model is Null, skip the test *)
				True
			],
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
		],

		(* Solvent and Media Tests *)
		RequiredTogetherTest[packet, {ConcentratedBufferDilutionFactor, ConcentratedBufferDiluent}],
		Test["BaselineStock must be specified together with ConcentratedBufferDilutionFactor and ConcentratedBufferDiluent:",
			Or[
				And[
					!NullQ[Lookup[packet, ConcentratedBufferDiluent]],
					!NullQ[Lookup[packet, BaselineStock]],
					!NullQ[Lookup[packet, ConcentratedBufferDilutionFactor]]
				],
				NullQ[Lookup[packet, BaselineStock]]
			],
			True
		],

		Test["If ConcentratedBufferDiluent is populated for " <> ToString[identifier] <> ". The populated Model[Sample] must have UsedAsSolvent -> True:",
			If[!NullQ[Lookup[packet,ConcentratedBufferDiluent]],
				MatchQ[Lookup[solventPacket,UsedAsSolvent],True],
				True
			],
			True,
			Message -> Hold[Error::NonSolventConcentratedBufferDiluent],
			MessageArguments -> {identifier}
		],

		Test["If Model[UsedAsSolvent] is True or Model[UsedAsMedia] is True, Solvent and Media must be Null for " <> ToString[identifier] <> ":",
			If[!NullQ[modelPacket]&&(MatchQ[Lookup[modelPacket,UsedAsSolvent], True] || MatchQ[Lookup[modelPacket,UsedAsMedia], True]),
				MatchQ[Lookup[packet,Solvent],Null] && MatchQ[Lookup[packet,Media],Null],
				True
			],
			True,
			Message -> Hold[Error::UsedAsSolventTrueAndPopulatedSolvent],
			MessageArguments -> {identifier}
		],

		Test["If Solvent or Media is populated, Model[UsedAsSolvent] and Model[UsedAsMedia] must be False for " <> ToString[identifier] <> ":",
			If[(MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]] || MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]]) && MatchQ[modelPacket, PacketP[]],
				MatchQ[Lookup[modelPacket,UsedAsSolvent],False] && MatchQ[Lookup[modelPacket,UsedAsMedia],False],
				True
			],
			True,
			Message -> Hold[Error::UsedAsSolventTrueAndPopulatedSolvent],
			MessageArguments -> {identifier}
		],

		Test["If Model[UsedAsMedia] is set to True and Model[State] is Liquid, then Model[UsedAsSolvent] must also be set to True for " <> ToString[identifier] <> ":",
			If[!NullQ[modelPacket]&&MatchQ[Lookup[modelPacket, UsedAsMedia], True]&&MatchQ[Lookup[modelPacket, State], Liquid],
				MatchQ[Lookup[modelPacket,UsedAsSolvent], True],
				True
			],
			True
		],

		Test["If Solvent is set to a Model[Sample], then Media cannot also be set to a Model[Sample], and vice versa, for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]] && MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to True, then Solvent cannot be a Model[Sample], for " <> ToString[identifier] <> " (please use the Media field instead):",
			If[MatchQ[Lookup[packet,Living], True] && MatchQ[Lookup[packet,Solvent], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to False, then Media cannot be set to a Model[Sample], for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Living], False] && MatchQ[Lookup[packet,Media], ObjectP[Model[Sample]]],
				False,
				True
			],
			True
		],

		Test["If Living is set to True, then neither Model[UsedAsSolvent] or Model[UsedAsMedia] can be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Living], True]&&!NullQ[modelPacket],
				!(MatchQ[Lookup[modelPacket, UsedAsSolvent], True] || MatchQ[Lookup[modelPacket, UsedAsMedia], True]),
				True
			],
			True
		],

		Test["If Living is set to True, then the CellType should also be informed for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet,Living], True],
				MatchQ[Lookup[packet, CellType], Except[Null]],
				True
			],
			True
		],

		Test["If Living is set to True and CellType is set to Bacterial/Yeast, then Sterile cannot be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet, Living], True] && MatchQ[Lookup[packet, CellType], MicrobialCellTypeP],
				!MatchQ[Lookup[packet, Sterile], True],
				True
			],
			True
		],

		Test["If Living is set to True and status is not discarded, then BiohazardDisposal cannot be set to False for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet, Living], True] && MatchQ[Lookup[packet, Status], Except[Discarded]],
				!MatchQ[Lookup[packet, BiohazardDisposal], False],
				True
			],
			True
		],

		Test["If BiohazardDisposal is set to True, then DrainDisposal cannot be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet, BiohazardDisposal], True],
				!MatchQ[Lookup[packet, DrainDisposal], True],
				True
			],
			True
		],

		Test["If Living is set to True and status is not discarded, then AsepticHandling must be set to True for " <> ToString[identifier] <> ":",
			If[MatchQ[Lookup[packet, Living], True] && MatchQ[Lookup[packet, Status], Except[Discarded]],
				MatchQ[Lookup[packet, AsepticHandling], True],
				True
			],
			True
		]

	}
];

Error::AnalytesNotInModels="The input(s), `1`, have identity models specified in the Analytes option that are not included in the Composition option. Please only include Analytes that are listed as Composition of this Object[Sample].";
Error::NonSolventConcentratedBufferDiluent="The input(s), `1`, have a ConcentratedBufferDiluent that is not UsedAsSolvent -> True. The ConcentratedBufferDiluent of a sample must be a solvent. Please change this option to a valid sample.";
Error::UsedAsSolventTrueAndPopulatedSolvent="The input(s), `1`, have a specified Solvent or Media and their Model have UsedAsSolvent -> True and/or UsedAsMedia -> True. If a sample has a populated Solvent or Media, the sample's Model cannot have UsedAsSolvent or UsedAsMedia set to True. Please change the Model, Solvent, or Media fields to properly define the sameple.";

errorToOptionMap[Object[Sample]]:={
	(* Note: These messages are thrown by UploadStorageCondition: *)
	"Error::ConflictingConditionsInContainer"->{StorageCondition},
	"Error::UnsafeStorageCondition"->{StorageCondition,Flammable, Acid, Base, Pyrophoric},


	"Error::AnalytesNotInModels"->{Analytes, Composition}
};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Sample],validSampleQTests];
