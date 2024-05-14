(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validReportQTests*)


validReportQTests[packet:PacketP[Object[Report]]]:={

	NotNullFieldTest[packet,DateCreated],

	Test["If DateCreated is informed, it is in the past:",
		Lookup[packet, DateCreated],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	]
};


(* ::Subsection::Closed:: *)
(*validReportDependenciesQTests*)


validReportDependenciesQTests[packet:PacketP[Object[Report,Dependencies]]]:={

	(* Fields that should be filled! *)
	NotNullFieldTest[packet,{
		Commit,
		Branch,
		Graph
	}]
};


(* ::Subsection::Closed:: *)
(*validReportLiteratureQTests*)


validReportLiteratureQTests[packet:PacketP[Object[Report,Literature]]]:={

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		Title,
		Authors,
		PublicationDate,
		DocumentType
	}],

	(* book editions *)
	Test[
		"If DocumentType is not Book or Book Section, Edition should be Null:",
		If[
			MatchQ[Lookup[packet,DocumentType],(Book|BookSection)],
			True,
			NullQ[Lookup[packet,Edition]]
		],
		True
	],

	(* scientific papers *)
	RequiredTogetherTest[packet,{ContactInformation,Journal}],

	(* if document type is JournalArticle, above Fields must be informed *)
	Test[
		"If DocumentType is JournalArticle, journal-related Fields must be informed:",
		If[MatchQ[Lookup[packet,DocumentType],JournalArticle],
			!MemberQ[Lookup[packet,{ContactInformation, Journal}],Null],
			True
		],
		True
	],

	(* publication date *)
	Test[
		"PublicationDate is in the past:",
		Lookup[packet,PublicationDate],
		_?(# <= Now &)
	]
};


(* ::Subsection::Closed:: *)
(*validReportLocationsQTests*)


validReportLocationsQTests[packet:PacketP[Object[Report,Locations]]]:={
	(* not null *)
	NotNullFieldTest[packet,
		{
			TypesIndexed,
			CachedLocations
		}
	]

};


(* ::Subsection::Closed:: *)
(*validReportNotebookQTests*)


validReportNotebookQTests[packet:PacketP[Object[Report,Notebook]]]:={
	(* not null *)
	NotNullFieldTest[packet,
		{
			Name,
			NotebookSource
		}
	]
};


(* ::Subsection::Closed:: *)
(*validReportQueueTimesQTests*)


validReportQueueTimesQTests[packet:PacketP[Object[Report,QueueTimes]]]:={
	(* not null *)
	NotNullFieldTest[packet,
		{
			QueueInterval,
			AverageQueueTime,
			MinQueueTime
		}
	],
	(* comments should be in the past *)
	Test[
		"ProtocolQueueTimes should be Non-Null except when AverageQueueTime is 1 Hour:",
		Lookup[packet,{ProtocolQueueTimes, AverageQueueTime}],
		{Except[NullP],Except[1 Hour]}|{_,1 Hour}
	]
};


(* ::Subsection::Closed:: *)
(*validReportReceiptQTests*)


validReportReceiptQTests[packet:PacketP[Object[Report,Receipt]]]:={

	(* Unique fields *)
	NotNullFieldTest[packet,{
		Transactions,
		Supplier
	}],

	(* Receipt and transactions share the same supplier *)
	FieldSyncTest[Join[{packet},Download[Lookup[packet, Transactions]]],Supplier],

	(* At least one of the documentation fields is informed *)
	AnyInformedTest[packet,
		{
			ConfirmationNumber,
			ConfirmationEmails,
			Invoices,
			PurchaseOrders,
			PackingSlips,
			OtherDocumentation
		}
	]

};

(* ::Subsection::Closed:: *)
(*validReportShippingPricesQTests*)


validReportShippingPricesQTests[packet:PacketP[Object[Report,ShippingPrices]]]:={
	(* not null *)
	NotNullFieldTest[packet,{Source,Shipper,ShippingSpeed,BoxModel,ShippingPrices}]
};


(* ::Subsection::Closed:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Report],validReportQTests];
registerValidQTestFunction[Object[Report, Dependencies],validReportDependenciesQTests];
registerValidQTestFunction[Object[Report, Literature],validReportLiteratureQTests];
registerValidQTestFunction[Object[Report, Locations],validReportLocationsQTests];
registerValidQTestFunction[Object[Report, Receipt],validReportReceiptQTests];
registerValidQTestFunction[Object[Report, QueueTimes],validReportQueueTimesQTests];
registerValidQTestFunction[Object[Report, ShippingPrices],validReportShippingPricesQTests];
