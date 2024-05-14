(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection::Closed:: *)
(*validTransactionQTests*)


validTransactionQTests[packet:PacketP[Object[Transaction]]]:= {

	NotNullFieldTest[packet, {
		Status,
		StatusLog,
		DateCreated
	}],

	Test["The last entry in StatusLog matches the current Status:",
		If[Lookup[packet, StatusLog] == {},
			Null,
			Last[Lookup[packet, StatusLog]][[2]]
		],
		Lookup[packet, Status]
	],

	(* Tracking *)
	RequiredTogetherTest[packet, {
		TrackingNumbers,
		Shipper
	}],

	(* If informed, all dates (DateCreated,DateShipped,DateDelivered,DateCanceled)except DateExpected are in the past *)
	Test["If DateCreated is informed, it is in the past:",
		Lookup[packet, DateCreated],
		Alternatives[
			Null, {},
			_?(# <= Now&)
		]
	],
	Test["If DateShipped is informed, it is in the past:",
		Lookup[packet, DateShipped],
		Alternatives[
			Null, {},
			_?(# <= Now&)
		]
	],
	Test["If DateDelivered is informed, it is in the past:",
		Lookup[packet, DateDelivered],
		Alternatives[
			Null, {},
			_?(# <= Now&)
		]
	],
	Test["If DateCanceled is informed, it is in the past:",
		Lookup[packet, DateCanceled],
		Alternatives[
			Null, {},
			_?(# <= Now&)
		]
	],

	(* Date orders *)
	Test["If both DateExpected and DateShipped are populated, DateExpected is greater or equal to DateShipped (looking at date only, not time):",
		If[NullQ[packet[DateExpected]] || NullQ[packet[DateShipped]],
			True,
			DateObject[DateValue[packet[DateExpected], {"Year", "Month", "Day"}]] >= DateObject[DateValue[packet[DateShipped], {"Year", "Month", "Day"}]]
		],
		True
	],

	Test["If DateCanceled is informed, it is after DateCreated:",
		Lookup[packet, DateCanceled],
		Alternatives[
			Null,{},
			_?(#>Lookup[packet, DateCreated]&)
		]
	]
};

(* ::Subsubsection:: *)
(*validTransactionOrderQTests*)


validTransactionOrderQTests[packet:PacketP[Object[Transaction,Order]]]:={

	NotNullFieldTest[packet,{
		Destination,
		RequestedAutomatically,
		ShippingSpeed
	}],

	RequiredTogetherTest[packet,{Supplier,CatalogNumbers,Products,OrderQuantities}],

	RequiredTogetherTest[packet,{OrderedModels,OrderAmounts}],

	UniquelyInformedTest[packet,{Products,OrderedModels}],

	Test["Orders that are Canceled may not have a DateDelivered, and vice versa:",
		Lookup[packet,{DateCanceled,DateDelivered}],
		Except[{_DateObject,_DateObject}]
	],

	Test["Orders with DependentOrder must be requested automatically and have Products",
		Lookup[packet,{DependentOrder,Products,RequestedAutomatically}],
		{Except[Null],Except[{}],True}|{Null,_,_}
	],

	(* Dates matching statuses *)
	Test["If Status is Requested, DateOrdered/DateExpected/DateShipped/DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Pending],
			Lookup[packet,{DateOrdered,DateExpected,DateShipped,DateDelivered,DateCanceled}]
		],
		NullP
	],

	Test["If DateOrdered is informed, it is in the past:",
		Lookup[packet, DateOrdered],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	Test["If both DateExpected and DateOrdered are populated, DateExpected is greater or equal to DateOrdered (looking at date only, not time):",
		If[NullQ[packet[DateExpected]]||NullQ[packet[DateOrdered]],
			True,
			DateObject[DateValue[packet[DateExpected], {"Year", "Month", "Day"}]] >= DateObject[DateValue[packet[DateOrdered], {"Year", "Month", "Day"}]]
		],
		True
	],

	Test["If DateOrdered is informed, it is after DateCreated:",
		Lookup[packet, DateOrdered],
		Alternatives[
			Null,{},
			_?(#>Lookup[packet, DateCreated]&)
		]
	],

	Test["If both DateShipped and DateOrdered are populated, DateShipped is greater or equal to DateOrdered (looking at date only, not time):",
		If[NullQ[packet[DateShipped]]||NullQ[packet[DateOrdered]],
			True,
			DateObject[DateValue[packet[DateShipped], {"Year", "Month", "Day"}]] >= DateObject[DateValue[packet[DateOrdered], {"Year", "Month", "Day"}]]
		],
		True
	],

	Test["If DateDelivered is informed, it is after DateOrdered:",
		Lookup[packet, DateDelivered],
		Alternatives[
			Null,{},
			_?(#>Lookup[packet, DateOrdered]&)
		]
	],

	Test["If Status is Ordered or Backordered, DateOrdered must be informed, DateExpected is optional, DateShipped/DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Ordered|Backordered],
			Lookup[packet,{DateOrdered,DateExpected,DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],_,Null,Null,Null}|Null
	],

	Test["If Status is Shipped, DateOrdered/DateShipped must be informed, DateExpected is optional, DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,{DateOrdered,DateExpected,DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],_,Except[NullP],Null,Null}|Null
	],

	Test["If Status is Received, DateOrdered/DateDelivered must be informed, DateExpected/DateShipped are optional, DateCanceled must be Null:",
		If[MatchQ[Lookup[packet,Status],Received],
			Lookup[packet,{DateOrdered,DateExpected,DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],_,_,Except[NullP],Null}|Null
	],

	(* SamplesOut informed if received *)
	Test["If Status is Received, the overall number of items received must match the total expected item quantity:",
		{
			Lookup[packet,Status],
			Lookup[packet,DependentOrder],
			Length[Lookup[packet,SamplesOut]]
		},
		Module[
			{orderQuantities, samplesPerItemList, expectedOverallItemQuantity},

			(* Extract order quantity and samples per item for each product *)
			orderQuantities = Lookup[packet, OrderQuantities];
			samplesPerItemList = Download[packet, Products[NumberOfItems]];

			(* Get the total expected number of items by multiplying order qty by samples per item for each product *)
			expectedOverallItemQuantity = Total[orderQuantities * samplesPerItemList];

			(* If any member of NumberOfItems is Null, skip the check *)
			If[NullQ[samplesPerItemList],
				_,
				Alternatives[
					{Received, Null, GreaterEqualP[expectedOverallItemQuantity]},
					{Received, ObjectP[Object[Transaction]], GreaterEqualP[expectedOverallItemQuantity]},
					(* the below case is because an order isn't marked as Received until the protocol has been completed, but SamplesOut will be informed while a protocol is running *)
					{Except[Received], _, _},
					{Except[Received|Ordered], _, LessP[expectedOverallItemQuantity]}
				]
			]
		]
	],

	(* SamplesOut informed if received *)
	Test["If Status is Canceled or Pending, the overall number of items received must be less than the total expected item quantity:",
		{
			Lookup[packet,Status],
			Length[Lookup[packet,SamplesOut]]
		},
		Module[
			{orderQuantities, samplesPerItemList, expectedOverallItemQuantity},

			(* Extract order quantity and samples per item for each product *)
			orderQuantities = Lookup[packet, OrderQuantities];
			samplesPerItemList = Download[packet, Products[NumberOfItems]];

			(* Get the total expected number of items by multiplying order qty by samples per item for each product *)
			expectedOverallItemQuantity = Total[orderQuantities * samplesPerItemList];

			(* If any member of NumberOfItems is Null, skip the check *)
			If[NullQ[samplesPerItemList],
				_,
				Alternatives[
					{Canceled, LessP[expectedOverallItemQuantity]},
					{Pending, LessP[expectedOverallItemQuantity]},
					{Except[Canceled|Pending], _}
				]
			]
		]
	],

	Test["If RequestedAutomatically is False, Creator is informed:",
		If[MatchQ[Lookup[packet,RequestedAutomatically],False],
			!NullQ[Lookup[packet,Creator]],
			True
		],
		True
	],

	(* For any Transaction Orders that either Supplier or Products informed, make sure the Products come from that Supplier *)
	Test["The products are all provided by the listed Supplier:",
		If[
			!And[
				NullQ[Lookup[packet,Supplier]],
				MatchQ[Lookup[packet,Products],{}]
			],
			ContainsAll[
				Lookup[packet,Supplier][Products][Object],
				Lookup[packet,Products][Object]
			],
			True
		],
		True
	],

	(*note this test also handles case where Fulfillment is {} *)
	Test["If there are protocols informed to Fulfillment field, atleast one of them should be Completed or still Processing if Status is Received:",
		If[MatchQ[Lookup[packet,Status], Received] && Not[MatchQ[Lookup[packet,Fulfillment], NullP|{}]],
			AnyTrue[Download[Lookup[packet,Fulfillment], Status], MatchQ[#, Completed|Processing]&],
			True
		],
		True
	],

	(*note this test also handles case where Fulfillment is {Null} or {} *)
	Test["If there are protocols informed to Fulfillment field, not all of them should be canceled or failed unless transaction is canceled:",
		If[Not[MatchQ[Lookup[packet,Status], Canceled]] && Not[MatchQ[Lookup[packet,Fulfillment], NullP|{}]],
			Not[AllTrue[Download[Lookup[packet,Fulfillment], Status], MatchQ[#, Aborted|Canceled]&]],
			True
		],
		True
	],

	Test["If Emerald is the Supplier, InternalOrder must be set to True:",
		If[
			(* If this order hasn't already been Received or Canceled and the order's supplier is Emerald *)
			And[
				!MatchQ[Lookup[packet,Status],Canceled|Received],
				MatchQ[Lookup[packet,Supplier], LinkP[Object[Company,Supplier,"id:eGakld01qrkB"]]]
			],
			(* InternalOrder must be True *)
			TrueQ[Lookup[packet,InternalOrder]],
			(* Otherwise, it's likely a Transaction pointing to another Supplier, so this test passes by default *)
			True
		],
		True
	],

	(* A bug caused some InternalOrders to get placed automatically by service+lab-infrastructure by fulfilling the order with plates already in house.
	This caused orders to hang indefinitely as they weren't actually ordered and could not be ordered automatically *)
	Test["If Status is Ordered, RequestedAutomatically is True, and InternalOrder is True, then Emerald is the supplier AND Fulfillment is populated OR there is a SupplierOrder:",
		If[
			MatchQ[
				Lookup[packet,{Status,RequestedAutomatically,InternalOrder}],
				{Ordered,True,True}
			],

			(* Test the internal orders to make sure they match one of two scenarios *)
			MatchQ[
				Lookup[packet,{Supplier,Fulfillment,SupplierOrder}],
				Alternatives[
					(* Either an internal order for something we make that a protocol will fulfill *)
					{ObjectP[Object[Company,Supplier,"id:eGakld01qrkB"]], {ObjectP[Object[Protocol]]..}, Null},

					(* Or something that's being ordered via an external (supplier) order *)
					{Except[ObjectP[Object[Company,Supplier,"id:eGakld01qrkB"]]], {}, ObjectP[Object[Transaction,Order]]}
				]
			],

			(* If it's not an internal order ignore it *)
			True
		],
		True
	]

};



(* ::Subsubsection::Closed:: *)
(*validTransactionDropShippingQTests*)


validTransactionDropShippingQTests[packet:PacketP[Object[Transaction,DropShipping]]]:={

	NotNullFieldTest[packet,{
		Creator,
		Destination,
		OrderedItems,
		Provider,
		OrderNumber,
		OrderQuantities,
		QuantitiesReceived,
		QuantitiesOutstanding
	}],

	Test["If VolumeSource is UserSpecified, Volume must be populated:",
		Download[packet, {VolumeSource,Volume}],
		Alternatives[{UserSpecified,Except[{}]},{Except[UserSpecified],_}]
	],

	Test["If MassSource is UserSpecified, Volume must be populated:",
		Download[packet, {MassSource,Mass}],
		Alternatives[{UserSpecified,Except[{}]},{Except[UserSpecified],_}]
	],

	Test["If the transaction is Received and VolumeSource is ProductDocumentation or ExperimentallyMeasure, Volume must be populated:",
		Download[packet, {Status, VolumeSource,Volume}],
		Alternatives[{Except[Received],_,_},{Received,ProductDocumentation|ExperimentallyMeasure,Except[{}]},{Received,Except[ProductDocumentation|ExperimentallyMeasure],_}]
	],

	Test["If the transaction is Received and MassSource is ProductDocumentation or ExperimentallyMeasure, Mass must be populated:",
		Download[packet, {Status, MassSource,Mass}],
		Alternatives[{Except[Received],_,_},{Received,ProductDocumentation|ExperimentallyMeasure,Except[{}]},{Received,Except[ProductDocumentation|ExperimentallyMeasure],_}]
	],

	Test["If the transaction is Received and MassSource is ExperimentallyMeasure, WeightMeasurementProtocols must be populated:",
		Download[packet, {Status, MassSource,WeightMeasurementProtocols}],
		Alternatives[{Except[Received],_,_},{Received,ExperimentallyMeasure,{LinkP[Object[Protocol]]..}},{Received,Except[ExperimentallyMeasure],_}]
	],

	Test["If the transaction is Received and VolumeSource is ExperimentallyMeasure, VolumeMeasurementProtocols must be populated:",
		Download[packet, {Status, VolumeSource,VolumeMeasurementProtocols}],
		Alternatives[{Except[Received],_,_},{Received,ExperimentallyMeasure,{LinkP[Object[Protocol]]..}},{Received,Except[ExperimentallyMeasure],_}]
	],

		Test["Status may not be Pending",
		MatchQ[Lookup[packet,Status],Pending],
		False
	],

	Test["If DateOrdered is informed, it is in the past:",
		Lookup[packet, DateOrdered],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	Test["If both DateExpected and DateOrdered are populated, DateExpected is greater or equal to DateOrdered (looking at date only, not time):",
		If[NullQ[packet[DateExpected]]||NullQ[packet[DateOrdered]],
			True,
			DateObject[DateValue[packet[DateExpected], {"Year", "Month", "Day"}]] >= DateObject[DateValue[packet[DateOrdered], {"Year", "Month", "Day"}]]
		],
		True
	],
	FieldComparisonTest[packet,{DateOrdered,DateCreated},GreaterEqual],
	Test["If both DateShipped and DateOrdered are populated, DateShipped is greater or equal to DateOrdered (looking at date only, not time):",
		If[NullQ[packet[DateShipped]]||NullQ[packet[DateOrdered]],
			True,
			DateObject[DateValue[packet[DateShipped], {"Year", "Month", "Day"}]] >= DateObject[DateValue[packet[DateOrdered], {"Year", "Month", "Day"}]]
		],
		True
	],
	FieldComparisonTest[packet,{DateDelivered,DateOrdered},GreaterEqual],

	Test["If Status is Ordered, DateOrdered must be informed, DateShipped/DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Ordered],
			Lookup[packet,{DateOrdered,DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],Null,Null,Null}|Null
	],


	Test["If Status is Shipped, DateShipped must be informed, DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,{DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],Null,Null}|Null
	],

	Test["If Status is Received, DateDelivered must be informed, DateCanceled must be Null:",
		If[MatchQ[Lookup[packet,Status],Received],
			Lookup[packet,{DateDelivered,DateCanceled}]
		],
		{Except[NullP],Null}|Null
	],

	Test["The Provider is one of the models's service providers or product's supplier:",
		MemberQ[Flatten[#], LinkP[Download[packet, Provider[Object]]]] & /@ Quiet[Download[packet, OrderedItems[{ServiceProviders, Supplier}]], Download::FieldDoesntExist],
		{True..}
	],

	Test["If Status is Received, Model of the SamplesOut must match Models:",
		If[MatchQ[Lookup[packet,Status],Received],
			MatchQ[Download[packet,Models[Object]], Download[packet, SamplesOut[Model][Object]]]
		],
		True|Null
	]
};


(* ::Subsubsection::Closed:: *)
(*validTransactionSendingQTests*)


validTransactionSendingQTests[packet:PacketP[Object[Transaction,ShipToECL]]]:={

  NotNullFieldTest[packet,{
    SamplesIn,
    ContainersIn,
		Destination,
		Creator
  }],


(* Dates matching statuses *)
	Test["If Status is Pending, DateExpected/DateShipped/DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Pending],
			Lookup[packet,{DateExpected,DateShipped,DateDelivered,DateCanceled}]
		],
		NullP
	],

	Test["If Status is Shipped, DateShipped must be informed, DateDelivered/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,{DateShipped,DateDelivered,DateCanceled}]
		],
		{Except[NullP],Null,Null}|Null
	],

	Test["If Status is Received, DateDelivered must be informed, DateCanceled must be Null:",
		If[MatchQ[Lookup[packet,Status],Received],
			Lookup[packet,{DateDelivered,DateCanceled}]
		],
		{Except[NullP],Null}|Null
	]


};



(* ::Subsubsection::Closed:: *)
(*validTransactionReturningQTests*)


validTransactionReturningQTests[packet:PacketP[Object[Transaction,ShipToUser]]]:={

  NotNullFieldTest[packet,{
    Destination,
		Source,
    Creator,
		SamplesIn
  }],

	Test["If Status is Shipped, SamplesOut must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,SamplesOut]
		],
		Except[{}]|Null
	],

	Test["If Status is Shipped, ShippingPrice must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,ShippingPrice]
		],
		Except[NullP]|Null
	],

	Test["If Status is Shipped, PackageWeightData must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,PackageWeightData]
		],
		Except[{}]|Null
	],

	Test["If ColdPacking is Ice, Ice must be populated:",
		If[MatchQ[Lookup[packet,ColdPacking],Ice],
			Lookup[packet,Ice]
		],
		Except[{}]|Null
	],

	Test["If ColdPacking is DryIce, DryIce and DryIceMasses must be populated:",
		If[MatchQ[Lookup[packet,ColdPacking],DryIce],
			Lookup[packet,{DryIce,DryIceMasses}]
		],
		{Except[{}|NullP],Except[{}]}|Null
	],

	Test["If ColdPacking is Null or None, Padding and PaddingMasses must be populated",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None],
			Lookup[packet,{Padding,PaddingMasses}]
		],
		{Except[{}|NullP],Except[{}]}|Null
	],

	Test["If Status is Shipped, ShippingContainers must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,ShippingContainers]
		],
		{ObjectP[Object[Container]]..}|Null
	],

	Test["If Status is Shipped and ContainersOut is populated, SecondaryContainers must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MatchQ[Lookup[packet,ContainersOut],Except[{}]],
			Lookup[packet,SecondaryContainers]
		],
		{ObjectP[Object[Container]]..}|Null
	],

	Test["If Status is Shipped and ContainersOut contains plates, PlateSeals must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MemberQ[Lookup[packet,ContainersOut],ObjectP[Object[Container,Plate]]],
			Lookup[packet,PlateSeals]
		],
		{ObjectP[Object[Item]]..}|Null
	],

	Test["If Aliquot is True and Status is Shipped, SamplePreparationProtocols, AliquotContainers and AliquotSamples must be populated",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MatchQ[Lookup[packet,Aliquot],True],
			Lookup[packet,{SamplePreparationProtocols,AliquotSamples,AliquotContainers}]
		],
		{{ObjectP[Object[Protocol]]..},{ObjectP[Object[Sample]]..},{ObjectP[Object[Container]]..}}|Null
	],

	Test["If ColdPacking is DryIce and Status is Shipped, DryIce must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],DryIce]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,DryIce]
		],
		{ObjectP[Object[Sample]]..}|Null
	],

	Test["If ColdPacking is Null or None and Status is Shipped, Padding must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,Padding]
		],
		{ObjectP[Object[Item]]..}|Null
	],

	Test["If ColdPacking is Ice and Status is Shipped, Ice must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,Padding]
		],
		{ObjectP[Object[Item]]..}|Null
	]
};


(* ::Subsubsection::Closed:: *)
(*validTransactionSiteToSiteQTests*)


validTransactionSiteToSiteQTests[packet:PacketP[Object[Transaction,SiteToSite]]]:={

	NotNullFieldTest[packet,{
		Destination,
		Creator,
		SamplesIn
	}],

	Test["If Status is Shipped, SamplesOut must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,SamplesOut]
		],
		Except[{}]|Null
	],

	Test["If Status is Shipped, ShippingPrice must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,ShippingPrice]
		],
		Except[NullP]|Null
	],

	Test["If Status is Shipped, PackageWeightData must be populated:",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,PackageWeightData]
		],
		Except[{}]|Null
	],

	Test["If ColdPacking is Ice, Ice must be populated:",
		If[MatchQ[Lookup[packet,ColdPacking],Ice],
			Lookup[packet,Ice]
		],
		Except[{}]|Null
	],

	Test["If ColdPacking is DryIce, DryIce and DryIceMasses must be populated:",
		If[MatchQ[Lookup[packet,ColdPacking],DryIce],
			Lookup[packet,{DryIce,DryIceMasses}]
		],
		{Except[{}|NullP],Except[{}]}|Null
	],

	Test["If ColdPacking is Null or None, Padding and PaddingMasses must be populated",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None],
			Lookup[packet,{Padding,PaddingMasses}]
		],
		{Except[{}|NullP],Except[{}]}|Null
	],

	Test["If Status is Shipped, ShippingContainers must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,ShippingContainers]
		],
		{ObjectP[Object[Container]]..}|Null
	],

	Test["If Status is Shipped and ContainersOut is populated, SecondaryContainers must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MatchQ[Lookup[packet,ContainersOut],Except[{}]],
			Lookup[packet,SecondaryContainers]
		],
		{ObjectP[Object[Container]]..}|Null
	],

	Test["If Status is Shipped and ContainersOut contains plates, PlateSeals must be resolved to objects",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MemberQ[Lookup[packet,ContainersOut],ObjectP[Object[Container,Plate]]],
			Lookup[packet,PlateSeals]
		],
		{ObjectP[Object[Item]]..}|Null
	],

	Test["If Aliquot is True and Status is Shipped, SamplePreparationProtocols, AliquotContainers and AliquotSamples must be populated",
		If[MatchQ[Lookup[packet,Status],Shipped]&&MatchQ[Lookup[packet,Aliquot],True],
			Lookup[packet,{SamplePreparationProtocols,AliquotSamples,AliquotContainers}]
		],
		{{ObjectP[Object[Protocol]]..},{ObjectP[Object[Sample]]..},{ObjectP[Object[Container]]..}}|Null
	],

	Test["If ColdPacking is DryIce and Status is Shipped, DryIce must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],DryIce]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,DryIce]
		],
		{ObjectP[Object[Sample]]..}|Null
	],

	Test["If ColdPacking is Null or None and Status is Shipped, Padding must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,Padding]
		],
		{ObjectP[Object[Item]]..}|Null
	],

	Test["If ColdPacking is Ice and Status is Shipped, Ice must be resolved to an object",
		If[MatchQ[Lookup[packet,ColdPacking],Null|None]&&MatchQ[Lookup[packet,Status],Shipped],
			Lookup[packet,Padding]
		],
		{ObjectP[Object[Item]]..}|Null
	]
};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Transaction],validTransactionQTests];
registerValidQTestFunction[Object[Transaction, Order],validTransactionOrderQTests];
registerValidQTestFunction[Object[Transaction, DropShipping], validTransactionDropShippingQTests];
registerValidQTestFunction[Object[Transaction,ShipToUser],validTransactionReturningQTests];
registerValidQTestFunction[Object[Transaction,ShipToECL],validTransactionSendingQTests];
registerValidQTestFunction[Object[Transaction, SiteToSite], validTransactionSiteToSiteQTests];
