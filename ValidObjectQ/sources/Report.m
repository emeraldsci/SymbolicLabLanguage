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
(*validReportCertificateQTests*)

validReportCertificateQTests[packet:PacketP[Object[Report,Certificate]]]:= {
	(* not null general fields*)
	NotNullFieldTest[packet,{Document, CertificationSource}],

	(*Ensure that only one object exists for each Certificate document file*)
	UniqueFieldTest[packet,Document],

	(* Ensure that the batch number is unique for the certificate *)
	UniqueFieldTest[packet, BatchNumber],

	(** All receiving batch information fields required by the certified object's model are populated **)
		(* Object[Item] *)
	RequiredTogetherTest[
		SafeEvaluate[{Download[Lookup[packet,ItemsCertified],Model[ReceivingBatchInformation]]},
			Download[Lookup[packet,ItemsCertified],Model[ReceivingBatchInformation]]
		]
	],
		(* Object[Part] *)
	RequiredTogetherTest[
		SafeEvaluate[{Download[Lookup[packet,PartsCertified],Model[ReceivingBatchInformation]]},
			Download[Lookup[packet,PartsCertified],Model[ReceivingBatchInformation]]
		]
	]
};

(* ::Subsection::Closed:: *)
(*validReportCertificateAnalysisQTests*)

validReportCertificateAnalysisQTests[packet:PacketP[Object[Report,Certificate,Analysis]]]:={
	(* not null general fields*)
	NotNullFieldTest[packet,{MaterialsCertified, BatchNumber}],

	(* Ensure that Material Certified is unique *)
	UniqueFieldTest[MaterialsCertified],

	(* Don't use Certificate of Analysis for instruments or sensors*)
	NullFieldTest[packet,{InstrumentCertified, SensorCertified}],

	(* Only one object type should be informed *)
	UniquelyInformedTest[packet,{ItemsCertified, PartsCertified, MaterialsCertified}],

	(* If MaterialsCertified is Null then DownstreamSamplesCertified should also be Null *)
	Test[
		If[MatchQ[Lookup[packet,MaterialsCertified], {}],
			MatchQ[Lookup[packet,DownstreamSamplesCertified], {}],
			True
		],
		True
	],

	(** All receiving batch information fields required by the certified sample's model are populated **)
	(* Object[Sample] *)
	RequiredTogetherTest[
		SafeEvaluate[{Download[Lookup[packet, MaterialsCertified], Model[ReceivingBatchInformation]]},
			Download[Lookup[packet, MaterialsCertified], Model[ReceivingBatchInformation]]
		]
	]
};

(* ::Subsection::Closed:: *)
(*validReportCertificateCalibrationQTests*)

validReportCertificateCalibrationQTests[packet:PacketP[Object[Report,Certificate,Calibration]]]:={

	(* ModelNumber should be populated (this field can be used for either model or part numbers). *)
	NotNullFieldTest[ModelNumber],

	(* Ensure only one object type field is populated *)
	UniquelyInformedTest[packet,{ItemsCertified, PartsCertified, SensorCertified, InstrumentCertified}],

	(* If an instrument was calibrated, its serial and model number should be included. *)
	RequiredTogetherTest[packet,{InstrumentCertified, SerialNumber, ModelNumber}],

	(* Either batch number or serial number should be informed. *)
	AnyInformedTest[packet,{BatchNumber,SerialNumber}],

	(** All receiving batch information fields required by the certified sample's model are populated **)
	(* Object[Sensor] *)
	RequiredTogetherTest[
		SafeEvaluate[{Download[Lookup[packet,SensorCertified],Model[ReceivingBatchInformation]]},
			Download[Lookup[packet,SensorCertified],Model[ReceivingBatchInformation]]
		]
	]
};

(* ::Subsection::Closed:: *)
(*validReportCertificateInstrumentValidationQTests*)

validReportCertificateInstrumentValidationQTests[packet:PacketP[Object[Report,Certificate,InstrumentValidation]]]:={

	(* Only an instrument should be certified. Batch number should be Null *)
	NullFieldTest[packet,{ItemsCertified,PartsCertified,BatchNumber}],

	(* The Instrument's model and serial number should be populated *)
	NotNullFieldTest[packet, {SerialNumber,ModelNumber}]
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
registerValidQTestFunction[Object[Report, Certificate,Analysis],validReportCertificateQTests];
registerValidQTestFunction[Object[Report, Certificate,Analysis],validReportCertificateAnalysisQTests];
registerValidQTestFunction[Object[Report, Certificate,Analysis],validReportCertificateCalibrationQTests];
registerValidQTestFunction[Object[Report, Certificate,Analysis],validReportCertificateInstrumentValidationQTests];
