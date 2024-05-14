(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)
$PriceSystemSwitchDate=DateObject[{2021, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`];
$WasteResourcePricingDate=DateObject[{2025, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`];

(* ::Subsection:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*PricingOutputP*)


(* pattern for the different kinds of output for the pricing functions *)
PricingOutputP=Table | Association | TotalPrice | JSON;



(* ::Subsubsection::Closed:: *)
(*PricingConsolidationP*)


PricingConsolidationP=PricingCategory | Notebook | Source;



(* ::Subsubsection::Closed:: *)
(*StoragePricingConsolidationP*)


StoragePricingConsolidationP=Sample | Notebook | StorageCondition;



(* ::Subsubsection::Closed:: *)
(*WastePricingConsolidationP*)


WastePricingConsolidationP=Protocol | Notebook | WasteType;



(* ::Subsubsection::Closed:: *)
(*InstrumentPricingConsolidationP*)


InstrumentPricingConsolidationP=Instrument | Notebook | Protocol;


(* ::Subsubsection::Closed:: *)
(*OperatorPricingConsolidationP*)


OperatorPricingConsolidationP=Operator | Notebook | Protocol;


(* ::Subsubsection::Closed:: *)
(*MaterialsPricingConsolidationP *)


MaterialsPricingConsolidationP=Notebook | Source | Material;


(* ::Subsubsection::Closed:: *)
(*TransactionPricingConsolidationP *)


TransactionPricingConsolidationP=Notebook | Source | Material;



(* ::Subsubsection::Closed:: *)
(*MaintenancePricingConsolidationP *)


MaintenancePricingConsolidationP=Notebook | CleaningMethod | Container;

(* ::Subsubsection::Closed:: *)
(*CleaningPricingConsolidationP *)


CleaningPricingConsolidationP=Notebook | CleaningCategory | ContainerModel | Protocol;

(* ::Subsubsection::Closed:: *)
(*CleaningPricingConsolidationP *)

StockingPricingConsolidationP=Notebook | Protocol | Model | StorageCondition;

(* ::Subsubsection::Closed:: *)
(*ProtocolPricingConsolidationP *)

ProtocolPricingConsolidationP=Notebook | Priority;


(* ::Subsubsection::Closed:: *)
(*PriceTableP*)


(* Pattern matching the output of Pricing when OutputFormat -> Association *)
PriceTableP=AssociationMatchP[
	Association[
		(* the notebook to which this item belongs *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that this entry came from *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction], Model[Maintenance]}] | Null,

		(* the name of the pricing category, whether storage or instrument time or waste or materials *)
		PricingCategory -> "Storage" | "Waste" | "Instrument Time" | "Materials" | "Transactions" | "Maintenance",

		(* the relevant item model name; for Storage it will be the name of the item being stored; for waste it will be the type of waste; for instrument time it will be the instrument name *)
		ModelName -> _String,

		(* the amount of time, or weight that this item has consumed *)
		Amount -> GreaterEqualP[0 * Hour] | GreaterEqualP[0 * Kilogram] | "N/A" | GreaterEqualP[0 * Milli * Liter] | GreaterEqualP[0],

		(* the price per unit specified that this item costs *)
		PricingRate -> GreaterEqualP[0 * USD / Month] | GreaterEqualP[0 * USD / Kilogram] | GreaterEqualP[0 * USD / Hour] | GreaterEqualP[0 * USD / Liter] | GreaterEqualP[0 * USD],

		(* The amount of money this storage/instrument time/waste cost *)
		Price -> GreaterEqualP[0 * USD]
	]
];



(* ::Subsubsection::Closed:: *)
(*ExperimentPriceTableP*)


(* Pattern matching the output of Pricing when OutputFormat -> Association *)
ExperimentPriceTableP=AssociationMatchP[
	Association[
		(* the notebook to which this item belongs *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that this entry came from *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction], Model[Maintenance]}] | Null,

		(* the name of the pricing category, whether storage or instrument time or waste or materials *)
		PricingCategory -> "Stocking" | "Waste" | "Instrument Time" | "Materials" | "Operator Time" | "Cleaning" | "Protocol",

		(* the relevant item model name; for Storage it will be the name of the item being stored; for waste it will be the type of waste; for instrument time it will be the instrument name *)
		ModelName -> _String,

		(* the amount of time, or weight that this item has consumed *)
		Amount -> GreaterEqualP[0 * Hour] | GreaterEqualP[0 * Kilogram] | "N/A" | GreaterEqualP[0 * Milli * Liter] | GreaterEqualP[0],

		(* the price per unit specified that this item costs *)
		PricingRate -> GreaterEqualP[0 * USD / Month] | GreaterEqualP[0 * USD / Kilogram] | GreaterEqualP[0 * USD / Hour] | GreaterEqualP[0 * USD / Liter] | GreaterEqualP[0 * USD] | "N/A" | Null,

		(* The amount of money this storage/instrument time/waste cost *)
		Price -> GreaterEqualP[0 * USD]
	]
];

(* ::Subsubsection::Closed:: *)
(*StoragePriceTableP*)


(* Pattern matching the output of PriceStorage when OutputFormat -> Association *)
StoragePriceTableP=AssociationMatchP[
	Association[
		(* the notebook to which this item belongs *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the object being stored.  Note that NonSelfContainedSamples will never be listed here, as they all must be in containers and that's what we are computing storage from *)
		Object -> ObjectP[{Object[Container], Object[Sample], Object[Part], Object[Item], Object[Plumbing], Object[Wiring]}],

		(* the name of the object being stored *)
		Name -> _String | Null,

		(* the name of the model of item being stored *)
		ModelName -> _String,

		(* the Name of the storage condition we were/are storing this item at *)
		StorageCondition -> _String,

		(* The length of time this item has been stored at a given storage condition (maximum being the length of time between the specified start and end times) *)
		Time -> GreaterEqualP[0 * Hour],

		(* the price per day per liter of storage of this container *)
		PricingRate -> GreaterEqualP[0 * USD / Month],

		(* The amount of money this storage cost *)
		Price -> GreaterEqualP[0 * USD],

		(* the date last used of the item *)
		DateLastUsed -> Null | _?DateObjectQ,

		(* the Source of the item itself *)
		Source -> Null | ObjectP[{Object[Transaction], Object[Protocol], Object[Qualification], Object[Maintenance]}],

		(* the contents of all the containers; will be Null if the Object is not a container at all. There are legitimate instances where containers can have containers as contents and we do not want to bill those *)
		(* issues of invalid contents will be found as a part of other maintenances. *)
		Contents -> Null | {ObjectP[{Object[Container], Object[Sample], Object[Part], Object[Item], Object[Plumbing], Object[Wiring]}]...},

		(*volume output*)
		Volume -> Null | UnitsP[Centimeter^3],

		(* site where the object was stored in *)
		Site -> ObjectP[Object[Container, Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*WastePriceTableP*)


(* Pattern matching the output of PriceWaste when OutputFormat -> Association *)
WastePriceTableP=AssociationMatchP[
	Association[
		(* the notebook of the protocol generating this waste *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that generated this waste *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],

		(* The type of the waste generated *)
		WasteType -> WasteTypeP,

		(* the description of the waste *)
		WasteDescription -> _String | Null,

		(* The amount of waste generated *)
		Weight -> GreaterEqualP[0 * Kilogram],

		(* The price of this waste per kilogram *)
		PricePerKilogram -> GreaterEqualP[0 * USD / Kilogram],

		(* The amount of money this waste cost *)
		Price -> GreaterEqualP[0 * USD],

		(* date completed for the protocol is used for waste disposal date *)
		Date -> _?DateObjectQ | Null,

		(* site where this charge originated *)
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*InstrumentPriceTableP*)


(* Pattern matching the output to PriceInstrumentTime when OutputFormat -> Association *)
InstrumentPriceTableP=AssociationMatchP[
	Association[
		(* date completed *)
		DateCompleted -> _?DateObjectQ | Null,

		(* the notebook of the protocol using this instrument *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that used this instrument *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],

		(* The ID of this specific instrument *)
		Instrument -> ObjectP[Object[Instrument]],

		(* The name of this model instrument *)
		ModelName -> _String,

		(* The amount of time this instrument was being used *)
		Time -> GreaterEqualP[0 * Hour],

		(* The price of this instrument per hour *)
		PricePerHour -> GreaterEqualP[0 * USD / Hour],

		(* The amount of money this use of the instrument cost *)
		Price -> GreaterEqualP[0 * USD],

		(* The amount of money this use of the instrument cost *)
		PricingCategory -> PricingCategoryP,

		(* The pricing tier *)
		PricingTier -> GreaterEqualP[1, 1],

		(* site where the experiment was performed *)
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*OperatorPriceTableP*)


(* Pattern matching the output to PriceOperatorTime when OutputFormat -> Association *)
OperatorPriceTableP=AssociationMatchP[
	Association[
		(* date completed *)
		DateCompleted -> _?DateObjectQ | Null,

		(* the notebook of the protocol using this operator *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that used this operator *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],

		(* The ID of this specific operator *)
		Operator -> ObjectP[{Object[User, Emerald, Operator], Object[User, Emerald, Developer]}],

		(* The name of this model operator *)
		ModelName -> _String,

		(* operator tier *)
		(*		QualificationLevel -> GreaterP[0, 1];*)

		(* The amount of time this operator was working *)
		Time -> GreaterEqualP[0 * Hour],

		(* The price of this operator per hour *)
		PricePerHour -> GreaterEqualP[0 * USD / Hour],

		(* The amount of money this use of the operator cost *)
		Price -> GreaterEqualP[0 * USD],

		(* site where the protocol happened *)
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*StockingPriceTableP*)


(* Pattern matching the output to PriceMaterials when OutputFormat -> Association *)
StockingPriceTableP=AssociationMatchP[
	Association[

		(* the notebook of the protocol using this material *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that used this material *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction, Order]}],

		(* The ID of this specific material *)
		Material -> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Plumbing], Model[Plumbing], Object[Wiring], Model[Wiring], Model[Sample], Model[Container], Model[Part], Object[Product], Model[Item], Object[Item]}]],

		(* The name of materials model *)
		MaterialName -> ListableP[_String] | Null,

		(* the storage condition model *)
		StorageCondition -> ListableP[ObjectP[Model[StorageCondition]]],

		(* the pricing category of this entry *)
		UsageFrequency -> UsageFrequencyP | Null,

		(* The amount of material that was being used *)
		Volume -> ListableP[GreaterEqualP[0 * Gram]] | ListableP[GreaterEqualP[0 * Milli * Liter]] | ListableP[GreaterEqualP[0 * (Centimeter^3)]],

		(* The price of this material per unit *)
		PricingRate -> GreaterEqualP[0 * USD / (Milli * Liter)] | GreaterEqualP[0 * USD / Gram] | GreaterEqualP[0 * USD / (Centimeter^3)] | "N/A",

		(* The amount of money this use of the material cost *)
		Price -> GreaterEqualP[0 * USD],

		(* site for this entry *)
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*MaterialsPriceTableP*)


(* Pattern matching the output to PriceMaterials when OutputFormat -> Association *)
MaterialsPriceTableP=AssociationMatchP[
	Association[

		(* the notebook of the protocol using this material *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that used this material *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction, Order]}],

		(* The ID of this specific material *)
		Material -> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Plumbing], Model[Plumbing], Object[Wiring], Model[Wiring], Model[Sample], Model[Container], Model[Part], Object[Product], Model[Item], Object[Item]}]],

		(* The name of materials catalog number *)
		MaterialName -> ListableP[_String],

		(* the pricing category of this entry *)
		PricingCategory -> "Product List Price" | "Product Tax",

		(* The amount of material that was being used *)
		Amount -> ListableP[GreaterEqualP[0 * Gram]] | ListableP[GreaterEqualP[0 * Milli * Liter]] | ListableP[GreaterEqualP[0]],

		(* The price of this material per unit *)
		PricePerUnit -> GreaterEqualP[0 * USD / (Milli * Liter)] | GreaterEqualP[0 * USD / Gram] | GreaterEqualP[0 * USD] | "N/A",

		(* The amount of money this use of the material cost *)
		Price -> GreaterEqualP[0 * USD],

		(* The date the charged protocols were completed or the transactions were delivered *)
		DateCompleted -> _?DateObjectQ | Null,

		(* the Site this material was purchased at*)
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*TransactionsPriceTableP*)


(* Pattern matching the output to PriceTransactions when OutputFormat -> Association *)
TransactionsPriceTableP=AssociationMatchP[
	Association[

		(* the notebook of the transaction affiliated with this material *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the transaction affiliated with this material *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction]}],

		(* The ID of this specific material *)
		Material -> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring], Model[Sample], Model[Container], Model[Part], Model[Plumbing], Model[Wiring], Object[Product], Model[Item], Object[Item]}]] | "N/A",

		(* The name of materials catalog number *)
		MaterialName -> ListableP[_String],

		(* the pricing category of this entry *)
		PricingCategory -> "Stocking" | "Receiving" | "Shipping" | "Handling" | "Packaging Materials" | "Aliquoting",

		(* The amount of material that was being used *)
		Amount -> ListableP[GreaterEqualP[0 * Gram]] | ListableP[GreaterEqualP[0 * Milli * Liter]] | ListableP[GreaterEqualP[0]],

		(* The price of this material per unit *)
		PricePerUnit -> GreaterEqualP[0 * USD / (Milli * Liter)] | GreaterEqualP[0 * USD / Gram] | GreaterEqualP[0 * USD] | "N/A",

		(* The amount of money this use of the material cost *)
		Price -> GreaterEqualP[0 * USD],

		(* The date the charged protocols were completed or the transactions were delivered *)
		DateCompleted -> _?DateObjectQ | Null,

		(* the weight of the package *)
		Weight -> GreaterEqualP[0 Kilogram] | Null,

		(* Tax *)
		Tax -> GreaterEqualP[0 USD] | Null,

		(* Site where this transaction was priced - source site for sending things and destination for receiving *)
		Site -> ObjectP[Object[Container,Site]]
	]
];



(* ::Subsubsection::Closed:: *)
(*CleaningPriceTableP*)


(* Pattern matching the output to PriceCleaning when OutputFormat -> Association *)
CleaningPriceTableP=AssociationMatchP[
	Association[

		(* the notebook of the cleaning affiliated with this material *)
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,

		(* the protocol that used the container *)
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],

		(* The  ID of this specific container *)
		Container -> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring], Model[Sample], Model[Container], Model[Part], Model[Plumbing], Model[Wiring], Object[Product], Model[Item], Object[Item]}]],

		(* The name of the container model *)
		Name -> ListableP[_String],

		(* the type of cleaning this container underwent *)
		CleaningMethod -> Alternatives[CleaningMethodP, Autoclave],

		(* the pricing category of this entry *)
		CleaningCategory -> CleaningP,

		(* The amount of money it cost to perform the cleaningMethod on the object*)
		Price -> GreaterEqualP[0 * USD],

		(* the date cleaned *)
		Date -> _?DateObjectQ | Null,

		(* site for where the cleaning protocol was run *)
		Site -> ObjectP[Object[Container,Site]]
	]
];

(* ::Subsubsection::Closed:: *)
(*DataPriceTableP*)

(* Pattern matching the output to PriceProtocol when OutputFormat -> Association *)
ProtocolPriceTableP=AssociationMatchP[
	Association[
		Notebook -> ObjectP[Object[LaboratoryNotebook]] | Null,
		Source -> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}],
		Priority -> ("Priority" | "Regular"),
		Price -> GreaterEqualP[0 * USD],
		Author -> ObjectP[Object[User]] | Null,
		DateCompleted -> _?DateObjectQ | Null,
		Site -> ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*DataPriceTableP*)

(* Pattern matching the output to PriceData when OutputFormat -> Association *)
DataPriceTableP=AssociationMatchP[
	Association[
		TeamName -> _String,
		Object -> ObjectP[Object[Team, Financing]],
		PricingRate -> UnitsP[0 * USD / Unit],
		NumberOfObjects -> UnitsP[Unit],
		Total -> UnitsP[0 * USD],
		Site->ObjectP[Object[Container,Site]]
	]
];


(* ::Subsubsection::Closed:: *)
(*RecurringPriceTableP*)

(* Pattern matching the output to PriceData when OutputFormat -> Association *)
RecurringPriceTableP=AssociationMatchP[
	Association[
		TeamName -> _String,
		Object -> ObjectP[Object[Team, Financing]],
		CommandCenterPrice -> UnitsP[0 * USD],
		NumberOfBaselineUsers -> GreaterEqualP[0, 1],
		MaxUsers -> GreaterEqualP[0, 1],
		CommandCenterTotal -> UnitsP[0 * USD],
		LabAccessFee -> UnitsP[0 * USD],
		PrivateTutoringFee -> UnitsP[0 * USD],
		Total -> UnitsP[0 * USD],
		Site->ObjectP[Object[Container,Site]]
	]
];

(* ::Subsection:: *)
(*PriceExperiment*)


(* ::Subsubsection::Closed:: *)
(*PriceExperiment*)

Authors[PriceExperiment]={"andrey.shur", "lei.tian", "jihan.kim", "dima", "alou"};

(* PriceExperiment replaces Pricing - it is different in that it only calculates the costs associated with a protocol, not general costs such as transactions, shipping, storage, adn data. *)
(* Calls pricing functions: PriceInstrumentTime, PriceOperatorTime, PriceCleaning, PriceMaterials, PriceWaste, PriceStocking *)

DefineOptions[PriceExperiment,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function return sa table for all pricing information, or an association matching PriceExperimentTableP with the same information, or a combined price of all costs used by the input protocol(s), transaction(s), notebook(s), or team(s).",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Automatic | PricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Source, or PricingCategory. Note that if consolidating by Source, all storage information will be placed in its own row because it is independent of protocol or transaction.",
			ResolutionDescription -> "Automatic resolves to PricingCategory for Team and Notebook inputs, to PricingCategory if only one Protocol/Transaction was entered and Source for more than one Protocols/Transactions.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceExperiment::ProtocolNotCompleted="The provided protocols contain protocols which were not completed. Only price completed protocols.";
PriceExperiment::ParentProtocolRequired="The provided protocols contain subprotocols without the parent protocol. Every parent protocol must be included.";
Pricing::NoPricingInfo="Provided team does not have pricing configured correctly and displayed prices might be not accurate. Please contact ECL to address the issue.";


(* empty list case *)
PriceExperiment[{}, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceExperiment, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]

];

(* singleton Protocol/Transaction overload *)
PriceExperiment[mySource:ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}], ops:OptionsPattern[]]:=PriceExperiment[{mySource}, ops];

(* core Protocol/Transaction overload *)
(* note that storage pricing is not provided for specific protocols/transactions because storage information is independent of protocol/transaction *)
PriceExperiment[mySources:{ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]..}, ops:OptionsPattern[]]:=Module[
	{
		safeOps, cache,
		protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket,
		materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket,
		protocolPricing, materialsPricing, operatorTimePricing, stockingPricing, cleaningPricing, wastePricing, instrumentTimePricing,
		allPricingInformation, stringProtocols, title, consolidation,
		resolvedConsolidation, resolvedOptions, protocols
	},

	(* get the safe options and pull out the option values *)
	safeOps=SafeOptions[PriceExperiment, ToList[ops]];
	{consolidation, cache}=Lookup[safeOps, {Consolidation, Cache}];

	(* if Consolidation -> Automatic, resolve to Source (either Protocol or Transaction) *)
	resolvedConsolidation=Which[
		!MatchQ[consolidation, Automatic],
		consolidation,

		(* if this is called with one protocol, show categories *)
		Length[mySources] == 1,
		PricingCategory,

		(* in all other cases default to Source *)
		TrueQ[True],
		Source
	];

	(* use ReplaceRule to include the resolved consolidation *)
	resolvedOptions=ReplaceRule[safeOps, Consolidation -> resolvedConsolidation];

	(* separate out the protocols and transactions *)
	protocols=Cases[mySources, ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]];

	(* run all the pricing functions on the protocols *)
	{
		protocolPricingPacket,
		wastePricingPacket,
		instrumentTimePricingPacket,
		operatorTimePricingPacket,
		materialsPricingPacket,
		stockingPricingPacket,
		cleaningPricingPacket
	}=Map[
		priceAndSurfaceErrors[protocols, #]&,
		{
			PriceProtocol,
			PriceWaste,
			PriceInstrumentTime,
			PriceOperatorTime,
			PriceMaterials,
			PriceStocking,
			PriceCleaning
		}
	];

	(* pull out the results from the Result Key *)
	{
		protocolPricing,
		wastePricing,
		instrumentTimePricing,
		operatorTimePricing,
		materialsPricing,
		stockingPricing,
		cleaningPricing
	}=Map[Lookup[#, Result]&,
		{
			protocolPricingPacket,
			wastePricingPacket,
			instrumentTimePricingPacket,
			operatorTimePricingPacket,
			materialsPricingPacket,
			stockingPricingPacket,
			cleaningPricingPacket
		}
	];

	(* check for errors *)
	If[MemberQ[Lookup[#, Incomplete]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ProtocolNotCompleted]
	];
	If[MemberQ[Lookup[#, Subprotocol]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ParentProtocolRequired]
	];

	(* combine all the pricing information *)
	allPricingInformation=Flatten[{wastePricing, instrumentTimePricing, operatorTimePricing, materialsPricing, stockingPricing, cleaningPricing, protocolPricing}];

	(* make the inputs into a string, getting rid of the list if possible *)
	stringProtocols=If[Length[mySources] == 1,
		ToString[Download[First[mySources], Object], InputForm],
		ToString[Download[mySources, Object], InputForm]
	];

	(* pass the title to the core function *)
	title=StringJoin["Total Pricing for ", stringProtocols];

	(* if any of the pricing functions return $Failed, then also return $Failed *)
	If[Or[
		MatchQ[wastePricing, $Failed],
		MatchQ[instrumentTimePricing, $Failed],
		MatchQ[materialsPricing, $Failed],
		MatchQ[stockingPricing, $Failed],
		MatchQ[cleaningPricing, $Failed],
		MatchQ[operatorTimePricing, $Failed],
		MatchQ[protocolPricing, $Failed]
	],
		Return[$Failed]
	];

	(* all overloads of Pricing pass to this core function that constructs the table or other outputs and returns it*)
	constructPricingTable[allPricingInformation, Null, title, resolvedOptions]
];

(* singleton Notebook overload with no date range *)
PriceExperiment[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceExperiment[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* singleton Notebook overload with date range *)
PriceExperiment[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceExperiment[{myNotebook}, myDateRange, ops];

(* reverse listable Notebook overload with no date range *)
PriceExperiment[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceExperiment[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* core reverse listable Notebook overload with date span*)
PriceExperiment[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{
		safeOps, consolidation, cache, resolvedConsolidation,
		resolvedOptions, today, now, alternativesNotebooks, sortedDateRange, startDate,
		endDate, endDateWithTime, allProtocols, allCorrectOrders,
		allShipToECLDropShipping, allShipToUserTransactions, allContainers,
		wastePricing, instrumentTimePricing,
		operatorTimePricing, protocolPricing, materialsPricing,
		stockingPricing, cleaningPricing, allPricingInformation,
		stringNotebooks, title,
		protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket,
		materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket
	},

	(* get the safe options and pull out the option values *)
	safeOps=SafeOptions[PriceExperiment, ToList[ops]];
	{consolidation, cache}=Lookup[safeOps, {Consolidation, Cache}];

	(* if Consolidation -> Automatic, resolve to PriceExperimentCategory *)
	resolvedConsolidation=If[MatchQ[consolidation, Automatic],
		PricingCategory,
		consolidation
	];

	(* use ReplaceRule to include the resolved consolidation *)
	resolvedOptions=ReplaceRule[safeOps, Consolidation -> resolvedConsolidation];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* THIS IS A TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTION CURRENTLY (ASK WAL)*)
	(* get all the completed parent protocols in these notebooks *)
	{
		allProtocols,
		allCorrectOrders,
		allShipToECLDropShipping,
		allShipToUserTransactions,
		allContainers
	}=Search[
		{
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			{Object[Transaction, Order]},
			{Object[Transaction, DropShipping], Object[Transaction, ShipToECL]},
			{Object[Transaction, ShipToUser]},
			{Object[Container]}
		},
		{
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
			Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
			Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime,
			DateShipped > startDate && DateShipped < endDateWithTime,
			DishwashLog != Null && (DishwashLog[[1]] > startDate && DishwashLog[[1]] < endDateWithTime || AutoclaveLog[[1]] > startDate && AutoclaveLog[[1]] < endDateWithTime)
		},
		Notebooks -> {
			alternativesNotebooks,
			alternativesNotebooks,
			alternativesNotebooks,
			alternativesNotebooks,
			alternativesNotebooks
		},
		PublicObjects -> {False, False, False, False, False}
	];


	(* run all the pricing functions on the protocols *)
	{
		protocolPricingPacket,
		wastePricingPacket,
		instrumentTimePricingPacket,
		operatorTimePricingPacket,
		materialsPricingPacket,
		stockingPricingPacket,
		cleaningPricingPacket
	}=Map[
		priceAndSurfaceErrors[allProtocols, #]&,
		{
			PriceProtocol,
			PriceWaste,
			PriceInstrumentTime,
			PriceOperatorTime,
			PriceMaterials,
			PriceStocking,
			PriceCleaning
		}
	];


	(* pull out the results from the Result Key *)
	{
		protocolPricing,
		wastePricing,
		instrumentTimePricing,
		operatorTimePricing,
		materialsPricing,
		stockingPricing,
		cleaningPricing
	}=Map[Lookup[#, Result]&,
		{
			protocolPricingPacket,
			wastePricingPacket,
			instrumentTimePricingPacket,
			operatorTimePricingPacket,
			materialsPricingPacket,
			stockingPricingPacket,
			cleaningPricingPacket
		}
	];

	(* check for errors *)
	If[MemberQ[Lookup[#, Incomplete]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ProtocolNotCompleted]
	];
	If[MemberQ[Lookup[#, Subprotocol]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ParentProtocolRequired]
	];


	(* combine all the pricing information *)
	allPricingInformation=Flatten[{wastePricing, instrumentTimePricing, operatorTimePricing, materialsPricing, stockingPricing, cleaningPricing, protocolPricing}];

	(* make the inputs into a string, getting rid of the list if possible *)
	stringNotebooks=If[Length[myNotebooks] == 1,
		ToString[Download[First[myNotebooks], Object], InputForm],
		ToString[Download[myNotebooks, Object], InputForm]
	];

	(* pass the title to the core function *)
	title=StringJoin["Total Pricing for ", stringNotebooks, "\nfrom ", DateString[startDate], " to ", DateString[endDate]];

	(* if any of the pricing functions return $Failed, then also return $Failed *)
	If[Or[
		MatchQ[wastePricing, $Failed],
		MatchQ[instrumentTimePricing, $Failed],
		MatchQ[materialsPricing, $Failed],
		MatchQ[stockingPricing, $Failed],
		MatchQ[cleaningPricing, $Failed],
		MatchQ[operatorTimePricing, $Failed],
		MatchQ[protocolPricing, $Failed]
	],
		Return[$Failed]
	];

	(* all overloads of Pricing pass to this core function that constructs the table or other outputs and returns it*)
	constructPricingTable[allPricingInformation, Null, title, resolvedOptions]

];

(* -- Financing Team overload -- *)

(* singleton Team overload with no date range *)
PriceExperiment[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceExperiment[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* singleton Team overload with date range *)
PriceExperiment[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceExperiment[{myTeam}, myDateRange, ops];

(* reverse listable Team overload with no date range *)
PriceExperiment[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceExperiment[myTeams, Span[Now, Now - 1 * Month], ops];

(* core reverse listable Team overload with date span *)
PriceExperiment[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{
		safeOps, cache, consolidation, resolvedConsolidation,
		resolvedOptions, alternativesTeams, allNotebooks, today, now,
		alternativesNotebooks, sortedDateRange, startDate, endDate, endDateWithTime,
		allProtocols, allCorrectOrders, allShipToECLDropShipping,
		allShipToUserTransactions, allContainers, allTemsBillingInfo,
		wastePricing, instrumentTimePricing, protocolPricing,
		materialsPricing, operatorTimePricing, cleaningPricing,
		stockingPricing, allPricingInformation,
		stringTeams, title,
		protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket,
		operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket
	},

	(* get the safe options and pull out the option values *)
	safeOps=SafeOptions[PriceExperiment, ToList[ops]];
	{consolidation, cache}=Lookup[safeOps, {Consolidation, Cache}];

	(* if Consolidation -> Automatic, resolve to PriceExperimentCategory *)
	resolvedConsolidation=If[MatchQ[consolidation, Automatic],
		PricingCategory,
		consolidation
	];

	(* use ReplaceRule to include the resolved consolidation *)
	resolvedOptions=ReplaceRule[safeOps, Consolidation -> resolvedConsolidation];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols, received transactions, and dishwashed containers in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	(* TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTION CURRENTLY (ASK WAL)*)
	{
		allProtocols,
		allCorrectOrders,
		allShipToECLDropShipping,
		allShipToUserTransactions,
		allContainers
	}=If[MatchQ[allNotebooks, {}],
		{{}, {}, {}, {}, {}},
		Search[
			{
				{Object[Protocol], Object[Qualification], Object[Maintenance]},
				{Object[Transaction, Order]},
				{Object[Transaction, DropShipping], Object[Transaction, ShipToECL]},
				{Object[Transaction, ShipToUser]},
				{Object[Container]}
			},
			{
				Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
				Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
				Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime,
				DateShipped > startDate && DateShipped < endDateWithTime,
				DishwashLog != Null && (DishwashLog[[1]] > startDate && DishwashLog[[1]] < endDateWithTime || AutoclaveLog[[1]] > startDate && AutoclaveLog[[1]] < endDateWithTime)
			},
			Notebooks -> {
				alternativesNotebooks,
				alternativesNotebooks,
				alternativesNotebooks,
				alternativesNotebooks,
				alternativesNotebooks
			},
			PublicObjects -> {False, False, False, False, False}
		]
	];

	(* grab the information about the billing for the teams *)
	allTemsBillingInfo = Download[Download[myTeams, Object], BillingHistory];

	(* throw a warning if we don't have a bill for the team *)
	If[AnyTrue[Length /@ allTemsBillingInfo, MatchQ[#, GreaterEqual[1]] &], Message[Pricing::NoPricingInfo]];

	(* run all the pricing functions on the protocols *)
	{
		protocolPricingPacket,
		wastePricingPacket,
		instrumentTimePricingPacket,
		operatorTimePricingPacket,
		materialsPricingPacket,
		stockingPricingPacket,
		cleaningPricingPacket
	}=Map[
		priceAndSurfaceErrors[allProtocols, #]&,
		{
			PriceProtocol,
			PriceWaste,
			PriceInstrumentTime,
			PriceOperatorTime,
			PriceMaterials,
			PriceStocking,
			PriceCleaning
		}
	];


	(* pull out the results from the Result Key *)
	{
		protocolPricing,
		wastePricing,
		instrumentTimePricing,
		operatorTimePricing,
		materialsPricing,
		stockingPricing,
		cleaningPricing
	}=Map[Lookup[#, Result]&,
		{
			protocolPricingPacket,
			wastePricingPacket,
			instrumentTimePricingPacket,
			operatorTimePricingPacket,
			materialsPricingPacket,
			stockingPricingPacket,
			cleaningPricingPacket
		}
	];

	(* check for errors *)
	If[MemberQ[Lookup[#, Incomplete]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ProtocolNotCompleted]
	];
	If[MemberQ[Lookup[#, Subprotocol]& /@ {protocolPricingPacket, wastePricingPacket, instrumentTimePricingPacket, operatorTimePricingPacket, materialsPricingPacket, stockingPricingPacket, cleaningPricingPacket}, True],
		Message[PriceExperiment::ParentProtocolRequired]
	];

	(* combine all the pricing information *)
	allPricingInformation=Flatten[{wastePricing, instrumentTimePricing, operatorTimePricing, materialsPricing, stockingPricing, cleaningPricing, protocolPricing}];

	(* make the inputs into a string, getting rid of the list if possible *)
	stringTeams=If[Length[myTeams] == 1,
		ToString[Download[First[myTeams], Object], InputForm],
		ToString[Download[myTeams, Object], InputForm]
	];

	(* pass the title to the core function *)
	title=StringJoin["Total Pricing for ", stringTeams, "\nfrom ", DateString[startDate], " to ", DateString[endDate]];

	(* if any of the pricing functions return $Failed, then also return $Failed *)
	If[
		Or[
			MatchQ[wastePricing, $Failed],
			MatchQ[instrumentTimePricing, $Failed],
			MatchQ[materialsPricing, $Failed],
			MatchQ[operatorTimePricing, $Failed],
			MatchQ[stockingPricing, $Failed],
			MatchQ[cleaningPricing, $Failed],
			MatchQ[protocolPricing, $Failed]
		],
		Return[$Failed]
	];

	(* all overloads of Pricing pass to this core function that constructs the table or other outputs and returns it*)
	constructPricingTable[allPricingInformation, Null, title, resolvedOptions]

];



(* ::Subsubsection::Closed:: *)
(*constructPricingTable (private) *)


(* This function is called in the protocol, notebook, and team overloads of PriceExperiment and combines the information yielded from PriceWaste, PriceInstrumentTime, PriceOperatorTime, PriceStocking, PriceMaterials, and PriceCleaning to one output *)
(* the inputs are as follows: *)
(* 1.) The list of the raw pricing information for Waste, Instrument, Stocking, and Maintenance.  These inputs match the pricing associations detailed above (StoragePriceTableP, WastePriceTableP, InstrumentPriceTableP, OperatorPriceTableP, MaterialsPriceTableP, StockingPriceTableP, CleaningPriceTableP)*)
(* 2.) The title of the table we will be using *)
(* 3.) The safe options gotten above *)
(* the output depends on the Consolidation and OutputFormat options; this could come in the form of a table, an association matching PricingTableP, or a combined total price *)
constructPricingTable[
	myInputs:{(WastePriceTableP | InstrumentPriceTableP | OperatorPriceTableP | MaterialsPriceTableP | StockingPriceTableP | CleaningPriceTableP | ProtocolPriceTableP)...},
	priorityProtocolPricing_,
	myTitle_String,
	myResolvedOptions:{__Rule}
]:=Module[
	{
		(*setup*)
		consolidation, output, wasteValues,
		instrumentValues, operatorValues, stockingValues, cleaningValues,
		(* totals *)
		totalWastePrice, totalInstrumentPrice, totalTotalPrice, pricingCategoryTable, totalCleaningPrice, totalStockingPrice, totalOperatorPrice,
		totalOperatorPriceNoZero, totalStockingPriceNoZero, totalCleaningPriceNoZero,
		(* organization *)
		pricingGroupedByNotebook, allNotebooksNoDupes, totalPricePerNotebook, notebookTable, pricingGroupedBySource, allSourcesNoDupes, totalPricePerSource,
		(* tables *)
		sourceTable, wasteTable, instrumentTimeTable, materialsTable,
		operatorTimeTable, stockingTable, cleaningTable,
		(* combine association, output *)
		combinedAssocOutput, tableToUse, subtotalRows, columnHeaders,
		dataWithSubtotal, tableOutput, totalWastePriceNoZero,
		totalInstrumentPriceNoZero, allNotebooksSourceConsolidation,
		materialsValues, totalMaterialsPrice, totalMaterialsPriceNoZero,
		protocolTable, totalProtocolPriceNoZero, totalProtocolPrice, protocolValues
	},

	(* pull out the Consolidation and OutputFormat options *)
	{consolidation, output}=Lookup[myResolvedOptions, {Consolidation, OutputFormat}];

	(* separate out the waste, instrument, materials, operator, stocking, and cleaning inputs *)
	wasteValues=Cases[myInputs, WastePriceTableP];
	instrumentValues=Cases[myInputs, InstrumentPriceTableP];
	operatorValues=Cases[myInputs, OperatorPriceTableP];
	materialsValues=Cases[myInputs, MaterialsPriceTableP];
	stockingValues=Cases[myInputs, StockingPriceTableP];
	cleaningValues=Cases[myInputs, CleaningPriceTableP];
	protocolValues=Cases[myInputs, ProtocolPriceTableP];

	(* get the total waste price, total instrument price, total materials price, total stocking price, total cleaning price, and total operator price *)
	totalWastePrice=Total[Lookup[wasteValues, Price, {}]];
	totalInstrumentPrice=Total[Lookup[instrumentValues, Price, {}]];
	totalMaterialsPrice=Total[Lookup[materialsValues, Price, {}]];
	totalOperatorPrice=Total[Lookup[operatorValues, Price, {}]];
	totalStockingPrice=Total[Lookup[stockingValues, Price, {}]];
	totalCleaningPrice=Total[Lookup[cleaningValues, Price, {}]];
	totalProtocolPrice=Total[Lookup[protocolValues, Price, {}]];

	(* if any of the above prices are 0, convert them to 0*USD *)
	totalWastePriceNoZero=If[TrueQ[totalWastePrice == 0], 0 * USD, totalWastePrice];
	totalInstrumentPriceNoZero=If[TrueQ[totalInstrumentPrice == 0], 0 * USD, totalInstrumentPrice];
	totalMaterialsPriceNoZero=If[TrueQ[totalMaterialsPrice == 0], 0 * USD, totalMaterialsPrice];
	totalOperatorPriceNoZero=If[TrueQ[totalOperatorPrice == 0], 0 * USD, totalOperatorPrice];
	totalStockingPriceNoZero=If[TrueQ[totalStockingPrice == 0], 0 * USD, totalStockingPrice];
	totalCleaningPriceNoZero=If[TrueQ[totalCleaningPrice == 0], 0 * USD, totalCleaningPrice];
	totalProtocolPriceNoZero=If[TrueQ[totalProtocolPrice == 0], 0 * USD, totalProtocolPrice];

	(* get the total price of everything *)
	totalTotalPrice=Total[{totalProtocolPriceNoZero, totalWastePriceNoZero, totalInstrumentPriceNoZero, totalMaterialsPriceNoZero, totalStockingPriceNoZero, totalOperatorPriceNoZero, totalCleaningPriceNoZero}];

	(* --- Construct the tables --- *)

	(* generate a table for the case where Consolidation -> PriceExperimentCategory and OutputFormat -> Table; this one is rather simple *)
	pricingCategoryTable={
		{"Waste", NumberForm[totalWastePriceNoZero, {\[Infinity], 2}]},
		{"Instrument Time", NumberForm[totalInstrumentPriceNoZero, {\[Infinity], 2}]},
		{"Operator Time", NumberForm[totalOperatorPriceNoZero, {\[Infinity], 2}]},
		{"Materials", NumberForm[totalMaterialsPriceNoZero, {\[Infinity], 2}]},
		{"Stocking", NumberForm[totalStockingPriceNoZero, {\[Infinity], 2}]},
		{"Cleaning", NumberForm[totalCleaningPriceNoZero, {\[Infinity], 2}]},
		{"Protocol", NumberForm[totalProtocolPriceNoZero, {\[Infinity], 2}]}
	};

	(* ------------------ *)
	(* -- GROUP OUTPUT -- *)
	(* ------------------ *)

	(* -- group by notebook -- *)

	(* group the inputs by what notebook they came from *)
	pricingGroupedByNotebook=GatherBy[myInputs, Lookup[#, Notebook]&];

	(* get the notebooks we want in the table *)
	allNotebooksNoDupes=First[Lookup[#, Notebook]]& /@ pricingGroupedByNotebook;

	(* get the total price by each notebook *)
	totalPricePerNotebook=Total[Lookup[#, Price]]& /@ pricingGroupedByNotebook;

	(* generate a table for the case where Consolidation -> Notebook and OutputFormat -> Table *)
	notebookTable=MapThread[
		{#1, NumberForm[#2, {\[Infinity], 2}]}&,
		{allNotebooksNoDupes, totalPricePerNotebook}
	];

	(* -- group by protocol -- *)

	(* group the inputs by what protocol they came from *)
	pricingGroupedBySource=GatherBy[Flatten[{wasteValues, instrumentValues, operatorValues, materialsValues, stockingValues, cleaningValues, protocolValues}], Lookup[#, Source]&];

	(* get all the notebooks we want in the _protocol-consolidated_ table *)
	allNotebooksSourceConsolidation=First[Lookup[#, Notebook]]& /@ pricingGroupedBySource;

	(* get the protocols we want in the table *)
	allSourcesNoDupes=First[Lookup[#, Source]]& /@ pricingGroupedBySource;

	(* get the total price by each protocol *)
	totalPricePerSource=Total[Lookup[#, Price]]& /@ pricingGroupedBySource;

	(* generate the table for the case where Consolidation -> Protocol and OutputFormat -> Table NOT INCLUDING the storage and maintenance information *)
	(* this also includes the Notebook information *)
	sourceTable=MapThread[
		{#1, #2, NumberForm[#3, {\[Infinity], 2}]}&,
		{allNotebooksSourceConsolidation, allSourcesNoDupes, totalPricePerSource}
	];

	(* ------------------- *)
	(* -- Prepare Table -- *)
	(* ------------------- *)

	(* pick the table to use from the Consolidation option *)
	tableToUse=Switch[consolidation,
		PricingCategory, pricingCategoryTable,
		Notebook, notebookTable,
		Source, sourceTable
	];

	(* generate the subtotal row; in all cases the number of columns are the same *)
	subtotalRows=If[MatchQ[consolidation, Source],
		{{"", "", ""}, {"", "Total Price", totalTotalPrice}},
		{{"", ""}, {"Total Price", totalTotalPrice}}
	];

	(* generate the column header row depending on the Consolidation option *)
	columnHeaders=Switch[consolidation,
		PricingCategory, {"Pricing Category", "Price"},
		Notebook, {"Notebook", "Price"},
		Source, {"Notebook", "Source (Protocol, Transaction or CleaningMethod)", "Price"}
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[tableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if tableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[tableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> myTitle]
	];

	(* --- get all the information that will be combined into a table; this will come in a different way for each pricing category --- *)

	(* make the waste associations that will match PriceTableP *)
	wasteTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Waste",
			ModelName -> ToString[Lookup[#, WasteType]],
			Amount -> Lookup[#, Weight],
			PricingRate -> Lookup[#, PricePerKilogram],
			Price -> Lookup[#, Price]
		|>&,
		wasteValues
	];

	(* make the instrument time associations that will match PriceTableP *)
	instrumentTimeTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Instrument Time",
			ModelName -> ToString[Lookup[#, ModelName]],
			Amount -> Lookup[#, Time],
			PricingRate -> Lookup[#, PricePerHour],
			Price -> Lookup[#, Price]
		|>&,
		instrumentValues
	];

	(* make the operator time associations that will match PriceTableP *)
	operatorTimeTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Operator Time",
			ModelName -> ToString[Lookup[#, ModelName]],
			Amount -> Lookup[#, Time],
			PricingRate -> Lookup[#, PricePerHour],
			Price -> Lookup[#, Price]
		|>&,
		operatorValues
	];

	(* make the materials associations that will match PriceTableP *)
	materialsTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Materials",
			ModelName -> ToString[Lookup[#, MaterialName]],
			Amount -> Lookup[#, Amount],
			PricingRate -> Lookup[#, PricePerUnit],
			Price -> Lookup[#, Price]
		|>&,
		materialsValues
	];

	(* make the stocking associations that will match PriceTableP *)
	stockingTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Stocking",
			ModelName -> ToString[Lookup[#, MaterialName]],
			Amount -> Lookup[#, Volume],
			PricingRate -> Lookup[#, PricingRate],
			Price -> Lookup[#, Price]
		|>&,
		stockingValues
	];

	(* make the cleaning associations that will match PriceTableP *)
	cleaningTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Cleaning",
			ModelName -> ToString[Lookup[#, CleaningCategory]],
			Amount -> 1,
			PricingRate -> Null,
			Price -> Lookup[#, Price]
		|>&,
		cleaningValues
	];

	(* this one is a little silly but also look per experiment fee *)
	protocolTable=Map[
		<|
			Notebook -> Lookup[#, Notebook],
			Source -> Lookup[#, Source],
			PricingCategory -> "Protocol",
			ModelName -> Lookup[#, Priority],
			Amount -> "N/A",
			PricingRate -> Null,
			Price -> Lookup[#, Price]
		|>&,
		protocolValues
	];

	(* make the output if OutputFormat -> Association *)
	combinedAssocOutput=Flatten[{wasteTable, instrumentTimeTable, operatorTimeTable, materialsTable, stockingTable, cleaningTable, protocolTable}];

	(* if OutputFormat -> Association or TotalPrice, ignore the Consolidation option and just return those values *)
	(* if OutputFormat -> Table, return the correct table depending on the Consolidation option *)
	Switch[output,
		Table, tableOutput,
		Association, combinedAssocOutput,
		TotalPrice, totalTotalPrice
	]

];

(* -------------------------------------------------------------- *)
(* -- small helper function to surface errors at the top level -- *)
(* -------------------------------------------------------------- *)

(* check for specific errors and quiet them, then look up from the association which errors were thrown *)
priceAndSurfaceErrors[input_, function_]:=
	Module[{output, outputWithTracker},
		Flatten[
			(* quiet these errors since we want to surface them only once *)
			Quiet[
				Check[
					outputWithTracker=Check[
						(* run the pricing subfunction with output -> association on the protocols *)
						output=(Result ->
							function[input, OutputFormat -> Association]),
						{output, Incomplete -> True},
						{function::ProtocolNotCompleted}
					],
					{outputWithTracker, Subprotocol -> True},
					{function::ParentProtocolRequired}
				],
				{function::ProtocolNotCompleted, function::ParentProtocolRequired}
			]
		]
	];




(* ::Subsection:: *)
(*PriceStorage*)


(* ::Subsubsection::Closed:: *)
(*PriceStorage*)

Authors[PriceStorage]={"alou", "robert", "dima"};

DefineOptions[PriceStorage,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching StoragePriceTableP with the same information, or a combined price of all storage costs used by the input notebook(s) or team(s).",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | StoragePricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing and timing information by Notebook, Sample, StorageCondition, or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceStorage::MissingBill="The following items had no bills associated with them: `1`.  Please contact ECL to fix the connection to a bill.";
PriceStorage::BillMissingStorageCondition="The bills for the following items did not have complete storage pricing information: `1`. Please contact ECL to fix the connection to a bill.";



(* ::Subsubsection::Closed:: *)
(*PriceStorage (no date range overloads)*)


(* empty list case *)
PriceStorage[{}, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceStorage, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]

];

(* Null case; most likely will be used in the PriceStorage[$Notebook] going forward *)
PriceStorage[Null, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceStorage, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]
];

(* no-input overload just uses $Notebook *)
PriceStorage[ops:OptionsPattern[]]:=PriceStorage[$Notebook, ops];

(* singleton Notebook overload with no date range*)
PriceStorage[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceStorage[{myNotebook}, ops];

(* reverse listable Notebook overload with no date range (core function called by front end) *)
PriceStorage[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=Module[
	{alternativesNotebooks, searchConditions, samplesAndContainers, searchTypes},

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* generate the Search conditions for all the samples and containers that are not Discarded*)
	searchConditions=And[DateDiscarded == Null, AwaitingDisposal!=True, Status!=Transit, Missing!=True];

	(* exclude any covering type objects from search. Even if they are not currently on a contaienr we do not need to charge for them. *)
	searchTypes = DeleteCases[
		Join[SelfContainedSampleTypes, FluidContainerTypes, {Object[Part], Object[Plumbing], Object[Wiring]}],
		Alternatives[Object[Item],Object[Item, Lid], Object[Item, Cap], Object[Item, PlateSeal], Object[Item, Stopper], Object[Item, Septum],Object[Item, LidSpacer],Object[Item, Clamp]]
	];

	(* get all the SelfContainedSamples, FluidContainers, and Parts separately *)
	(*warm up search*)
	Quiet[Search[
		searchTypes,
		searchConditions,
		MaxResults -> 50,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	]];

	(*do the real search*)
	samplesAndContainers=Search[
		searchTypes,
		searchConditions,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass the samples and containers in question to the core storage pricing function *)
	priceStorageMonthlyRate[samplesAndContainers, ops]
];

(* singleton Team overload with no date range *)
PriceStorage[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceStorage[{myTeam}, ops];

(* reverse listable Team overload with no date range *)
PriceStorage[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=Module[
	{alternativesTeams, allNotebooks},

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* pass the notebooks financed by these teams to the core notebook function (or the empty list overload, if no notebooks were found) *)
	PriceStorage[allNotebooks, ops]
];

(* singleton Protocol/Transaction overload with no date range *)
PriceStorage[myProtocol:ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction]}], ops:OptionsPattern[]]:=PriceStorage[{myProtocol}, ops];

(* reverse listable Protocol/Transaction overload with no date range *)
PriceStorage[myProtocols:{ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance], Object[Transaction]}]..}, ops:OptionsPattern[]]:=Module[
	{inputProtocols, inputTransactions, allSubprotocols, allSearchConditions, allSearchTypes, allSearchResults},

	(* get all the protocols from the inputs (excluding transactions) *)
	inputProtocols=Cases[myProtocols, ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]];
	inputTransactions=Cases[myProtocols, ObjectP[Object[Transaction]]];

	(* get all the subprotocols of all these input protocols *)
	allSubprotocols=Download[inputProtocols, Repeated[Subprotocols][Object], Date -> Now];

	(* get the search conditions for all sources *)
	allSearchConditions=And[
		Source == (Alternatives @@ Flatten[{inputTransactions, inputProtocols, allSubprotocols}]),
		Status!=Transit
	];

	(* get the search types for the samples; in effect this is the same across the board *)
	(* TODO should I include Samples too?  Like if a sample is in a container with a different source, it definitely could be *)
	allSearchTypes=DeleteCases[
		Flatten[{SelfContainedSampleTypes, FluidContainerTypes, Object[Part], Object[Plumbing], Object[Wiring]}],
		Alternatives[Object[Item, Lid], Object[Item, Cap], Object[Item, PlateSeal], Object[Item, Stopper], Object[Item, Septum],Object[Item, LidSpacer],Object[Item, Clamp]]
	];

	(* get all the samples/containers/parts that correspond to each protocol/transaction *)
	(* warm up search first *)
	Quiet[Search[allSearchTypes, Evaluate[allSearchConditions], MaxResults -> 50]];
	(*do the real search*)
	allSearchResults=Search[allSearchTypes, Evaluate[allSearchConditions]];

	(* pass all the searched items to the core private function, as well as the safe options *)
	priceStorageMonthlyRate[Flatten[allSearchResults], ops]
];



(* ::Subsubsection::Closed:: *)
(*priceStorageMonthlyRate (private function)*)


(* this private function is called from several different PriceStorage overloads that ultimately funnel here *)
(* this private function takes the following input: *)
(* 1.) The list of all the items in question (Items, Containers, or Parts) *)
(* The output is either a table, list of associations matching StoragePriceTableP, a JSON output, or a USD/Month pricing rate (depending on the OutputFormat option)*)
priceStorageMonthlyRate[myItems:{ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Item], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{allDownloadValues,allStorageConditionPackets,allDimensionPackets,allSampleContainerContentsPackets,
		nullPricingPackets,allModelNames,allVolumes,safeAllVolumes,storageRates,allSampleContainers,
		storageConditionNames,totalStoragePrices,allItemPackets,
		allNotebooks,totalFinalPrice,allDataTable,associationOutput,preJSONOutput,jsonOutput,allColumnsDataTable,
		noNotebookDataTable,gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,
		notebookConsolidatedTable,gatheredByObject,objectConsolidatedPreTotal,objectConsolidatedTotals,
		objectConsolidatedTable,gatheredByStorageCondition,storageConditionConsolidatedPreTotal,objectBillPackets,
		storageConditionConsolidatedTotals,storageConditionConsolidatedTable,numNotebooks,numObjs,dataTableToUse,
		subtotalRows,columnHeaders,dataWithSubtotal,tableOutput,datesLastUsed,itemSources,safeOps,cache,
		consolidation,output,allObjNames,allItemsDisposalDate,currentStoragePricing,
		billForEachMaterial,currentStoragePricingRules,initialStorageRates,allSites},

	(* get the safe options, and pull the values out *)
	safeOps=SafeOptions[PriceStorage, ToList[ops]];
	{cache, consolidation, output}=Lookup[safeOps, {Cache, Consolidation, OutputFormat}];

	(* Download all the information we need from the samples and the containers *)
	(* need to Quiet because not all the myItems are Containers that don't have the Contents field *)
	allDownloadValues=Quiet[
		Download[myItems,
			{
				Packet[Notebook, DateDiscarded, DateLastUsed, Source, Name, DisposalLog, DatePurchased, AwaitingDisposal, Site],
				Packet[StorageCondition[{Name, PricingRate}]],
				Packet[Model[{Dimensions, Name}]],
				Contents[[All, 2]],
				Container[Object],
				Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, StoragePricing, Site}]]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* get all the item packets from the big Download call *)
	allItemPackets=allDownloadValues[[All, 1]];

	(* get all the storage condition objects that are relevant to us as a flat list from the big Download call *)
	allStorageConditionPackets=allDownloadValues[[All, 2]];

	(* get all the model packets from the big Download call *)
	allDimensionPackets=allDownloadValues[[All, 3]];

	(* get all the contents of all the items *)
	allSampleContainerContentsPackets=allDownloadValues[[All, 4]] /. {$Failed -> Null};

	(* get the container of the objects we are working with *)
	allSampleContainers = allDownloadValues[[All,5]];

	(*separate out the object bill packets*)
	objectBillPackets=allDownloadValues[[All, 6]];


	(* determine the end billing time for each container *)
	allItemsDisposalDate=Map[Function[{eachMaterialPacket},
		Module[
			{discardedQ, disposalLog, falsePositions, finishDate, lastBool, awaitingDisposalQ},

			discardedQ=!NullQ[Lookup[eachMaterialPacket, DateDiscarded]];
			awaitingDisposalQ=TrueQ[Lookup[eachMaterialPacket, AwaitingDisposal]];
			disposalLog=Lookup[eachMaterialPacket, DisposalLog];
			(*positions where AwaitingDisposal was changed to False by Protocol, Operator or User*)
			falsePositions=Flatten@Position[disposalLog, {_, False, _?(MatchQ[#, ObjectP[{Object[User], Object[Protocol], Object[User, Emerald, Operator]}]]&)}];
			(* find the last bool in the disposal log *)
			lastBool=If[Length[disposalLog] == 0, False, Last[disposalLog[[All, 2]]]];
			(* if we do have those positions, grab the first True after it *)
			finishDate=Switch[{discardedQ, falsePositions, Length[disposalLog], lastBool, awaitingDisposalQ},

				(* sample is not discarded, return Null  *)
				{False, {}, 0, _, _},
				Null,

				{False, _, _, _, False},
				Null,

				(*if we don't have a log but the sample is discarded, return the date discarded *)
				{True, {}, 0, _, _},
				Lookup[eachMaterialPacket, DateDiscarded],

				(* AwaitingDisposal was not set to False after True - use the first entry in the DisposalLog *)
				{_, {}, GreaterP[0], _, _},
				disposalLog[[1, 1]],

				(* if the sample was ultimately marked as not to be discarded *)
				{False, _, Last[falsePositions], _, _},
				Null,

				(* if the sample was marked as discarded *)
				{_, _?(Length[#] == 1&), _, _, _},
				disposalLog[[1, 1]],

				(* if we somehow have a case where the object was discarded but the last entry in the log is False take the first true of the position before it *)
				{_, _, GreaterP[0], False, _},
				disposalLog[[falsePositions[[-2]] + 1, 1]],

				(* if AwaitingDisposal was set to False at some point, use the first True after false position *)
				{_, _, GreaterP[0], _, _},
				disposalLog[[Last[falsePositions] + 1, 1]]
			];
			(* if order of uploads was off, we might mark item for disposal before we mark it as purchased, in those cases set the date to 1 Second after Purchase *)
			If[Or[NullQ[finishDate], finishDate > Lookup[eachMaterialPacket, DatePurchased]], finishDate, Lookup[eachMaterialPacket, DatePurchased] + 1Second]
		]],
		allItemPackets];

	(* pull out the date last used of each item *)
	datesLastUsed=Lookup[allItemPackets, DateLastUsed, {}];

	(* pull out the Source value of each item *)
	itemSources=Lookup[allItemPackets, Source, {}];

	(*get the best bill for each material*)
	(*if the material is not yet discarded, then we take the open bill, otherwise, we look when it was discarded and take from there*)
	billForEachMaterial=MapThread[
		Function[{billList, disposalDate, objectPacket},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				If[NullQ[disposalDate],
					KeyValuePattern[{Status -> Open}],
					Alternatives[KeyValuePattern[{Status -> Open, DateStarted -> LessEqualP[disposalDate]}], KeyValuePattern[{DateStarted -> LessEqualP[disposalDate], DateCompleted -> GreaterEqualP[disposalDate], Site->LinkP[Download[Lookup[objectPacket,Site], Object]]}]]
				],
				(*indicate if we couldn't find a bill -- note, this symbol is ultimately inconsequential and just for debugging purposes*)
				NoBillFound
			]
		],
		{
			objectBillPackets,
			allItemsDisposalDate,
			allItemPackets
		}
	];

	(* pull out the storage condition packets that have null pricing rate *)
	nullPricingPackets=Select[allStorageConditionPackets, NullQ[Lookup[#, PricingRate]]&];

	(* get all the names of the objects themselves *)
	allObjNames=Lookup[allItemPackets, Name, {}];

	(* get all the names of all the models *)
	allModelNames=Lookup[allDimensionPackets, Name, {}];

	(* get all the volumes of the items we Downloaded *)
	allVolumes=Map[
		If[NullQ[#] || MemberQ[#, Null],
			Null,
			(* need to do this convert call because currently Units don't play nice with Dollars + conversions, and so USD*Meter^3/Centimeter^3 doesn't know how to simplify.  So converting to Centimeter^3 for now to fix that *)
			Convert[Times @@ #, Centimeter^3]
		]&,
		Lookup[allDimensionPackets, Dimensions, {}]
	];

	(* get the storage rates from the bill or before*)
	initialStorageRates=MapThread[
		Function[{eachDateDiscarded, eachOldSchoolPricingRate, eachStorageCondition, eachBillPacket, container},
			Which[

				(* if this item is inside a container that we are also pricing (item inside a container for example), do not charge for it *)
				MemberQ[myItems,ObjectP[container]],
				Quantity[0, Times[Power["Centimeters", -3], Power["Hours", -1], "USDollars"]],

				(*check if this is old and school discarded*)
				If[DateObjectQ[eachDateDiscarded], eachDateDiscarded < $PriceSystemSwitchDate, False],
				eachOldSchoolPricingRate,

				(*otherwise get from the bill packet*)
				True,
				If[MatchQ[eachBillPacket, PacketP[]], (
					(*get the storage pricing from the bill and dereference the links*)
					currentStoragePricing=Lookup[eachBillPacket, StoragePricing] /. {x_Link :> Download[x, Object]};
					(*convert the tuples to rules*)
					currentStoragePricingRules=Map[Rule @@ #&, currentStoragePricing];
					(*check whether the current storage is in the rules*)
					If[MemberQ[Part[currentStoragePricing, All, 1], eachStorageCondition],
						ReplaceAll[eachStorageCondition, currentStoragePricingRules],
						(*if it's not included, we indicate with a temporary symbol and replace out later*)
						NoPricingForStorageFound
					]
				),
					NoBillFound
				]
			]
		],
		{
			allItemsDisposalDate,
			Lookup[allStorageConditionPackets, PricingRate, {}],
			Lookup[allStorageConditionPackets, Object, {}],
			billForEachMaterial,
			allSampleContainers
		}
	];

	(*do some error checking*)
	If[MemberQ[initialStorageRates, NoBillFound],
		Message[PriceStorage::MissingBill, PickList[Lookup[allItemPackets, Object], initialStorageRates, NoBillFound]]
	];

	(*do some error checking*)
	If[MemberQ[initialStorageRates, NoPricingForStorageFound],
		Message[
			PriceStorage::BillMissingStorageCondition,
			PickList[Lookup[allItemPackets, Object], initialStorageRates, NoPricingForStorageFound]
		]
	];

	(*remove the error state conditions*)
	(* TODO: When all teams with existing samples have been migrated to ECL-2 pricing schemes, hard error for NoPricingForStorageFound/NoBillFound to better surface issues *)
	storageRates=initialStorageRates /. {NoPricingForStorageFound -> Null, NoBillFound -> Null};

	storageConditionNames=Lookup[allStorageConditionPackets, Name, {}];

	(* get the total storage price for each item, accounting for volumes *)
	totalStoragePrices=MapThread[
		If[NullQ[#1] || NullQ[#2],
			Null,
			Convert[#1 * #2, USD / Month]
		]&,
		{storageRates, allVolumes}
	];

	(* get the sample and container notebooks *)
	allNotebooks=Download[Lookup[allItemPackets, Notebook, {}], Object];

	(* get the total total price *)
	totalFinalPrice=If[MatchQ[DeleteCases[totalStoragePrices, Null], {}],
		0 * USD / Month,
		Total[DeleteCases[totalStoragePrices, Null]]
	];

	allSites=Map[
		Download[
			Lookup[Experiment`Private`fetchPacketFromCache[#,allItemPackets], Site],
			Object
		]&,
		Download[myItems,Object]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points, but no further manipulations of the numbers *)
	(* if Consolidation -> Except[Null], then we're going to do NumberForm shenanigans later *)
	allDataTable=MapThread[
		Function[{notebook, object, objectName, modelName, storageName, time, rate, price, dateLastUsed, source, contents, site},
			Which[
				NullQ[rate], Nothing,
				MatchQ[output, Table] && NullQ[consolidation], {notebook, site, object, modelName, storageName, NumberForm[rate, {\[Infinity], 2}]},
				MatchQ[output, Association | JSON], {notebook, site, object, objectName, modelName, storageName, time, rate, price, dateLastUsed, Download[source, Object], contents},
				True, {notebook, site, object, modelName, storageName, rate}
			]
		],
		{
			allNotebooks,
			myItems,
			allObjNames,
			allModelNames,
			storageConditionNames,
			(* the times are all 1 Month because this is the no-date-range overload *)
			ConstantArray[1 * Month, Length[allNotebooks]],
			totalStoragePrices,
			(* multiplying the monthly rate by the 1 month we are worrying about anyway *)
			totalStoragePrices * 1 * Month,
			datesLastUsed,
			itemSources,
			allSampleContainerContentsPackets,
			allSites
		}
	];

	(*pair down the volumes in the same was as the data table*)
	safeAllVolumes=MapThread[
		Function[{time, rate, volume},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				volume
			]
		],
		{
			ConstantArray[1 * Month, Length[allNotebooks]],
			totalStoragePrices,
			allVolumes
		}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match StoragePriceTableP *)
	associationOutput=If[MatchQ[output, Association | JSON],
		Map[
			AssociationThread[{Notebook, Site, Object, Name, ModelName, StorageCondition, Time, PricingRate, Price, DateLastUsed, Source, Contents, Volume}, #]&,
			MapThread[Join[#1, {#2}]&, {allDataTable, safeAllVolumes}]
		],
		{}
	];

	(* generate the precursor to the JSON output *)
	preJSONOutput=Map[
		Function[{assoc},
			{
				"Notebook" -> ToString[Lookup[assoc, Notebook]],
				"Site" -> ToString[Lookup[assoc, Site]],
				"Object" -> ToString[Lookup[assoc, Object]],
				"ModelName" -> Lookup[assoc, ModelName],
				"StorageCondition" -> Lookup[assoc, StorageCondition],
				"Time" -> Unitless[Lookup[assoc, Time], Hour],
				"PricingRate" -> Unitless[Lookup[assoc, PricingRate], USD / Month],
				"Price" -> Unitless[Lookup[assoc, Price], USD],
				"DateLastUsed" -> ToString[Lookup[assoc, DateLastUsed]],
				"Source" -> ToString[Lookup[assoc, Source]],
				"Contents" -> If[NullQ[Lookup[assoc, Contents]],
					ToString[Null],
					ToString[#]& /@ Lookup[assoc, Contents]
				]
			}
		],
		associationOutput
	];

	(* get the json output *)
	jsonOutput=ExportJSON[preJSONOutput];

	(* generate the table of items that will be displayed if all the information is needed *)
	(* different from allDataTable above because here we are setting the decimal points properly *)
	allColumnsDataTable=MapThread[
		Function[{notebook, object, objectName, storageName, rate, site},
			If[NullQ[rate],
				Nothing,
				{notebook, site, object, objectName, storageName, NumberForm[rate, {\[Infinity], 2}]}
			]
		],
		{allNotebooks, myItems, allModelNames, storageConditionNames, totalStoragePrices, allSites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{object, objectName, storageName, rate, site},
			Which[
				NullQ[rate], Nothing,
				MatchQ[output, Table] && NullQ[consolidation], {object, site, objectName, storageName, NumberForm[rate, {\[Infinity], 2}]},
				True, {object, site, objectName, storageName, rate}
			]
		],
		{myItems, allModelNames, storageConditionNames, totalStoragePrices, allSites}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 6]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Object *)
	gatheredByObject=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	objectConsolidatedPreTotal=Map[
		{#[[1, 2]], #[[1, 3]], DeleteCases[#[[All, 5]], Null]}&,
		gatheredByObject
	];

	(* get the total for each object *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	objectConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		objectConsolidatedPreTotal
	];
	(* TODO is this correct here with columns? I got lost in the processing steps *)
	(* generate the simplified-by-object table *)
	objectConsolidatedTable=MapThread[
		{First[#1], #1[[2]], #2}&,
		{objectConsolidatedPreTotal, objectConsolidatedTotals}
	];

	(* group all the rows in the data table by StorageCondition *)
	gatheredByStorageCondition=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by StorageCondition, before we do the Total call *)
	storageConditionConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 6]], Null]}&,
		gatheredByStorageCondition
	];

	(* get the total for each storage condition *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	storageConditionConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		storageConditionConsolidatedPreTotal
	];

	(* generate the simplified-by-storage condition table *)
	storageConditionConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{storageConditionConsolidatedPreTotal, storageConditionConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of objects specified in this function *)
	numNotebooks=Length[DeleteDuplicates[allNotebooks]];
	numObjs=Length[DeleteDuplicates[myItems]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook  column as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks},
		{Notebook, _}, notebookConsolidatedTable,
		{Sample, _}, objectConsolidatedTable,
		{StorageCondition, _}, storageConditionConsolidatedTable,
		{_, 1}, noNotebookDataTable,
		{_, _}, allColumnsDataTable
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks},
		{Notebook | StorageCondition, _}, {{"", ""}, {"Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}},
		{Sample, _}, {{"", "", "", ""}, {"", "", "Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}},
		{_, 1}, {{"", "", "", "", ""}, {"", "", "", "Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}},
		{_, _}, {{"", "", "", "", "", ""}, {"", "", "", "", "Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks},
		{Notebook, _}, {"Notebook", "Price (per month)"},
		{StorageCondition, _}, {"Storage Condition", "Price (per month)"},
		{Sample, _}, {"Object", "Site", "Model Name", "Price (per month)"},
		{_, 1}, {"Object", "Site", "Model Name", "Storage Condition", "Price (per month)"},
		{_, _}, {"Notebook", "Site", "Object", "Model Name", "Storage Condition", "Price (per month)"}
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> "Storage Pricing"]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		Table, tableOutput,
		Association, associationOutput,
		JSON, jsonOutput,
		TotalPrice, totalFinalPrice
	]

];


(* ::Subsubsection::Closed:: *)
(*PriceStorage (date overloads)*)
(* --- Date range overloads --- *)


(* singleton Notebook overload with date range *)
PriceStorage[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceStorage[{myNotebook}, myDateRange, ops];

(* core reverse listable Notebook overload with date span*)
PriceStorage[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps,sortedDateRange,startDate,endDate,alternativesNotebooks,
		today,now,cache,output,searchConditions,samplesAndContainers,allSampleContainers,
		allSampleContainerPackets,storageConditionLogs,resolvedStartDates,
		resolvedEndDates,allStorageConditionPackets,allDimensionPackets,priceReplaceRules,nameReplaceRules,
		allVolumes,datePairs,storageConditionsFromLogs,relevantDatePairs,searchTypes,
		datePairTimes,storageRates,totalStoragePrices,storageNames,indexMatchedPackets,indexMatchedObjs,
		indexMatchedNotebooks,flatPrices,totalFinalPrice,flatStorageRates,flatStorageNames,flatTimes,
		consolidation,allDataTable,associationOutput,noNotebookDataTable,gatheredByNotebook,
		notebookConsolidatedPreTotal,notebookConsolidatedTotals,gatheredByObject,objectConsolidatedPreTotal,
		objectConsolidatedTotals,objectConsolidatedTable,gatheredByStorageCondition,storageConditionConsolidatedPreTotal,
		storageConditionConsolidatedTotals,storageConditionConsolidatedTable,numNotebooks,numObjs,dataTableToUse,
		allModelNames,indexMatchedNames,notebookConsolidatedTable,subtotalRows,datePairsAbsoluteTiming,
		columnHeaders,dataWithSubtotal,tableOutput,allColumnsDataTable,nullPricingPackets,
		allSampleContainerContentsPackets,indexMatchedContentsPackets,
		safeAllVolumes,allSampleContainerDisposalDate,allSampleContainerDisposalDateRaw,
		preJSONOutput,jsonOutput,allSampleContainerPacketsRaw,selectionBools,
		monthlyStorageRates,flatDateLastUsed,allDatesLastUsed,allSources,flatSources,allObjNames,
		indexMatchedModelNames,endDateWithTime,billForEachMaterial,
		initialStorageRates,allDimensionPacketsRaw,allSampleContainerContentsPacketsRaw,allSampleContainersRaw,
		allExistingStorageConditions,objectBillPacketsPerNotebook,notebookBillLookup,allObjectsAssociation,siteLogs,sites,siteConditionsLogs,sitesFromLogs,simplifiedSiteStorageConditionLogs,relevantStorageConditionSitePairs,flatSites},

	(* get the safe options, and pull out some of those items *)
	safeOps=SafeOptions[PriceStorage, ToList[ops]];
	{cache, output, consolidation}=Lookup[safeOps, {Cache, OutputFormat, Consolidation}];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* generate the Search conditions for all the samples and containers *)
	(* the item must either not be discarded or discarded after the date range in question, AND the item must have been purchased before the end date *)
	searchConditions=And[
		Or[
			DateDiscarded == Null,
			DateDiscarded > startDate
			],
		DatePurchased < endDateWithTime,
		Status!=Transit,
		Missing!=True
		];

	(*remove covering types from our search even if they are not on containers, we are not going to bill for storing them*)
	searchTypes = DeleteCases[
		Join[SelfContainedSampleTypes, FluidContainerTypes, {Object[Part], Object[Plumbing], Object[Wiring]}],
		Alternatives[Object[Item],Object[Item, Lid], Object[Item, Cap], Object[Item, PlateSeal], Object[Item, Stopper], Object[Item, Septum],Object[Item, LidSpacer],Object[Item, Clamp]]
	];

	(* get all the SelfContainedSamples and Containers separately *)
	(*warm up search*)
	Quiet[Search[
		searchTypes,
		searchConditions,
		MaxResults -> 50,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	]];

	(*do the search*)
	samplesAndContainers=Search[
		searchTypes,
		searchConditions,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* if we have no containers for this input, skip the function and return the result *)
	If[MatchQ[samplesAndContainers, {}],
		Return[
			Switch[output,
				Table, {},
				Association, {},
				TotalPrice, 0 * USD
			]
		]
	];

	allExistingStorageConditions=Search[Model[StorageCondition],DeveloperObject!=True];

	(* Download all the information we need from the samples and the containers *)
	(* need to Quiet because not all the samplesAndContainers are Containers that have the Contents field *)
	{
		allSampleContainerPacketsRaw,
		allDimensionPacketsRaw,
		allSampleContainerContentsPacketsRaw,
		allSampleContainersRaw,
		allStorageConditionPackets,
		objectBillPacketsPerNotebook
	}=Quiet[
		Download[
			{
				samplesAndContainers,
				samplesAndContainers,
				samplesAndContainers,
				samplesAndContainers,
				allExistingStorageConditions,
				myNotebooks
			},
			{
				{Packet[Name,DateDiscarded,DisposalLog,AwaitingDisposal,StorageConditionLog,DatePurchased,Notebook,DateLastUsed,Source,Notebook,Site,SiteLog]},
				{Packet[Model[{Dimensions,Name}]]},
				{Contents[[All,2]]},
				{Container[Object]},
				{Packet[Name,PricingRate]},
				{Packet[Financers[BillingHistory][[All,2]][{DateStarted,DateCompleted,Status,StoragePricing,Site}]]}
			},
			Cache->cache,
			SquashResponses->True,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	{
		allSampleContainerPacketsRaw,
		allDimensionPacketsRaw,
		allSampleContainerContentsPacketsRaw,
		allSampleContainersRaw,
		allStorageConditionPackets,
		objectBillPacketsPerNotebook
	}=Flatten[#,1]&/@{
		allSampleContainerPacketsRaw,
		allDimensionPacketsRaw,
		allSampleContainerContentsPacketsRaw,
		allSampleContainersRaw,
		allStorageConditionPackets,
		objectBillPacketsPerNotebook
	};

	(* determine the end billing time for each container *)
	allSampleContainerDisposalDateRaw=Map[Function[{eachMaterialPacket},
		Module[
			{discardedQ, disposalLog, falsePositions, finishDate, lastBool, awaitingDisposalQ},

			discardedQ=!NullQ[Lookup[eachMaterialPacket, DateDiscarded]];
			awaitingDisposalQ=TrueQ[Lookup[eachMaterialPacket, AwaitingDisposal]];
			disposalLog=Lookup[eachMaterialPacket, DisposalLog];
			(*positions where AwaitingDisposal was changed to False by Protocol, Operator or User*)
			falsePositions=Flatten@Position[disposalLog, {_, False, _?(MatchQ[#, ObjectP[{Object[User], Object[Protocol], Object[User, Emerald, Operator]}]]&)}];
			(* find the last bool in the disposal log *)
			lastBool=If[Length[disposalLog] == 0, False, Last[disposalLog[[All, 2]]]];
			(* if we do have those positions, grab the first True after it *)
			finishDate=Switch[{discardedQ, falsePositions, Length[disposalLog], lastBool, awaitingDisposalQ},

				(* sample is not discarded, return Null  *)
				{False, {}, 0, _, _},
				Null,

				{False, _, _, _, False},
				Null,

				(*if we don't have a log but the sample is discarded, return the date discarded *)
				{True, {}, 0, _, _},
				Lookup[eachMaterialPacket, DateDiscarded],

				(* AwaitingDisposal was not set to False after True - use the first entry in the DisposalLog *)
				{_, {}, GreaterP[0], _, _},
				disposalLog[[1, 1]],

				(* if the sample was ultimately marked as not to be discarded *)
				{False, _, Last[falsePositions], _, _},
				Null,

				(* if the sample was marked as discarded *)
				{_, _?(Length[#] == 1&), _, _, _},
				disposalLog[[1, 1]],

				(* if we somehow have a case where the object was discarded but the last entry in the log is False take the first true of the position before it *)
				{_, _, GreaterP[0], False, _},
				disposalLog[[falsePositions[[-2]] + 1, 1]],

				(* if AwaitingDisposal was set to False at some point, use the first True after false position *)
				{_, _, GreaterP[0], _, _},
				disposalLog[[Last[falsePositions] + 1, 1]]
			];
			(* if order of uploads was off, we might mark item for disposal before we mark it as purchased, in those cases set the date to 1 Second after Purchase *)
			If[Or[NullQ[finishDate], finishDate > Lookup[eachMaterialPacket, DatePurchased]], finishDate, Lookup[eachMaterialPacket, DatePurchased] + 1Second]
		]],
		allSampleContainerPacketsRaw];

	(* since we searched based on DateDiscarded but bill based on the date of setting AwaitingDisposal->True *)
	selectionBools=Map[Or[(# > endDateWithTime), NullQ[#]]&, allSampleContainerDisposalDateRaw];

	(* work only on the containers that were not disposed before start of the billing system *)
	allSampleContainerDisposalDate=PickList[allSampleContainerDisposalDateRaw, selectionBools];

	(* work only on the containers that were not disposed before start of the billing system *)
	allSampleContainerPackets=PickList[allSampleContainerPacketsRaw, selectionBools];

	(* get all the contents of all the items *)
	allSampleContainerContentsPackets=PickList[allSampleContainerContentsPacketsRaw, selectionBools] /. {$Failed -> Null};
	(* release the memory we used for this *)
	Clear[allSampleContainerContentsPacketsRaw];

	(* get all containers of all items *)
	allSampleContainers = PickList[allSampleContainersRaw, selectionBools];
	(* release the memory we used for this *)
	Clear[allSampleContainersRaw];

	(* get all the dimensions of the thing we Downloaded from the big Download call *)
	allDimensionPackets=PickList[allDimensionPacketsRaw, selectionBools];
	(* release the memory we used for this *)
	Clear[allDimensionPacketsRaw];

	(* pull out the date last used of all the sample/container packets *)
	allDatesLastUsed=Lookup[allSampleContainerPackets, DateLastUsed, {}];

	(* pull out the Source of all the sample/container packets *)
	allSources=Lookup[allSampleContainerPackets, Source, {}];

	(* pair up bill objects with notebook they belong to (in case there are different Financers *)
	notebookBillLookup=MapThread[Rule[#1,#2]&,{Download[myNotebooks,Object],objectBillPacketsPerNotebook}];

	(*get the best bill for each material*)
	(*if the material is not yet discarded, then we take the open bill, otherwise, we look when it was discarded and take from there*)
	(* we get packets for bills from _all_ sites here so we can expand properly later and take Site into account *)
	billForEachMaterial=MapThread[
		Function[{disposalDate, itemPacket},Module[{itemNotebook,notebookBills},
			itemNotebook=Download[Lookup[itemPacket,Notebook],Object];
			notebookBills=Lookup[notebookBillLookup,itemNotebook];
			(*the bill can either be ongoing or it's a historical one*)
			Cases[
				Flatten[ToList@notebookBills],
				If[
					Or[
						(* if the object is not discarded *)
						NullQ[disposalDate],
						(* or is discarded after the end date of this bill *)
						disposalDate > endDateWithTime
					],
					KeyValuePattern[{Status -> Open}],
					Alternatives[KeyValuePattern[{Status -> Open, DateStarted -> LessEqualP[disposalDate]}], KeyValuePattern[{DateStarted -> LessEqualP[disposalDate], DateCompleted -> GreaterEqualP[disposalDate]}]]
				]
			]/.{}->NoBillFound(*indicate if we couldn't find a bill -- note, this symbol is ultimately inconsequential and just for debugging purposes*)
		]],
		{
			allSampleContainerDisposalDate,
			allSampleContainerPackets
		}
	];

	(* create replace rules for the prices and storage condition names from the given storage condition object *)
	priceReplaceRules=Map[
		Lookup[#, Object] -> Lookup[#, PricingRate]&,
		allStorageConditionPackets
	];
	nameReplaceRules=Map[
		Lookup[#, Object] -> Lookup[#, Name]&,
		allStorageConditionPackets
	];

	(* pull out the storage condition packets that have null pricing rate *)
	nullPricingPackets=Select[allStorageConditionPackets, NullQ[Lookup[#, PricingRate]]&];

	(* if there are any storage condition objects that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullPricingPackets, {}]],
		Message[PriceStorage::MissingPricingRate, Lookup[nullPricingPackets, Object]]
	];

	(* get all the names of the objects themselves *)
	allObjNames=Lookup[allSampleContainerPackets, Name, {}];

	(* get all the names of all the models *)
	allModelNames=Lookup[allDimensionPackets, Name, {}];

	(* get all the volumes of the items we Downloaded *)
	allVolumes=Map[
		If[NullQ[#] || MemberQ[#, Null],
			0*Centimeter^3,
			(* need to do this convert call because currently Units don't play nice with Dollars + conversions, and so USD*Meter^3/Centimeter^3 doesn't know how to simplify.  So converting to Centimeter^3 for now to fix that *)
			Convert[Times @@ #, Centimeter^3]
		]&,
		Lookup[allDimensionPackets, Dimensions, {}]
	];

	(* get the storage condition logs for all the samples and containers *)
	storageConditionLogs=Lookup[allSampleContainerPackets, StorageConditionLog, {}];
	siteLogs=Lookup[allSampleContainerPackets,SiteLog,{}];
	sites=Download[Lookup[allSampleContainerPackets,Site,Null],Object];

	(* combine storage condition and site log into one *)
	siteConditionsLogs=MapThread[Function[{storageConditionLog,siteLog,site},With[{
		(* the only time we might have a Site->Null is on old objects, so we can assume that their Site is ECL-2 (or we are doing legacy pricing) *)
		safeSite=If[NullQ[site],$Site,Download[site,Object]]
	},
		Which[
			(* if we don't have SiteLog populated, assume that the objects was always at the current Site *)
			MatchQ[siteLog,{} | {Null} | Null],
			{#[[1]],Download[#[[2]],Object],safeSite}&/@storageConditionLog,

			(* this should never be the case *)
			MatchQ[storageConditionLog,{} | {Null} | Null],
			{},

			(* general case - we have to combine both logs *)
			True,
			Module[{combinedTimeLog,expandedSiteLog},
				combinedTimeLog=Sort[Join[storageConditionLog[[All,1]],siteLog[[All,1]]]];
				(* because SiteLog might be not populated, pad it with the earliest date from our combined log and the first entry from SiteLog *)
				(* technically, this can be not true for legacy items (before SiteLog system), but we should not be pricing anything in that timeframe *)
				expandedSiteLog=Prepend[siteLog,{First[combinedTimeLog],siteLog[[1,2]],Null}];
				DeleteDuplicates@Map[Function[{currentTime},
					With[{
						currentSite=FirstCase[Reverse@expandedSiteLog,{LessEqualP[currentTime],_,_},First@expandedSiteLog][[2]],
						currentStorageCondition=FirstCase[Reverse@storageConditionLog,{LessEqualP[currentTime],_,_},First@storageConditionLog][[2]]
					},
						{currentTime,Download[currentStorageCondition,Object],Download[currentSite,Object]}
					]
				],combinedTimeLog]
			]
		]]],{storageConditionLogs,siteLogs,sites}];

	(* narrow the storage condition logs to delete duplicate storage condition/site pairs that are adjacent *)
	(* as a trivial case, doing this operation to {1, 2, 2, 2, 3, 4, 5, 2, 2, 2, 3, 3, 7} would yield {1, 2, 3, 4, 5, 2, 3, 7} *)
	simplifiedSiteStorageConditionLogs=Map[
		Function[{siteConditionsLog},
			First/@SplitBy[siteConditionsLog,{Download[#[[2]],Object],Download[#[[3]],Object]}&]
		],
		siteConditionsLogs
	];

	(* get the storage condition objects that correspond to each entry of the simplifiedStorageConditionLogs *)
	storageConditionsFromLogs=Map[
		Download[#[[All,2]],Object] &,
		simplifiedSiteStorageConditionLogs
	];
	sitesFromLogs=Map[
		Download[#[[All,3]],Object] &,
		simplifiedSiteStorageConditionLogs
	];

	(* get the date from which we are going to start the pricing (i.e., either startDate, or the DatePurchased, whichever is later) *)
	(* need to do AbsoluteTime shenanigans to prevent cases where two dates "overlap" even though they don't actually (like this weird MM bug, where DateObject[{2018, 4, 5, 12, 11, 44.7152124`}, "Instant", "Gregorian", -7.`] >= DateObject[{2018, 4, 5, 12, 11, 44.6592068`}, "Instant", "Gregorian", -7.`] should be True but actually throws errors) *)
	resolvedStartDates=Map[
		Which[
			NullQ[#],AbsoluteTime[startDate],
			AbsoluteTime[startDate]>=AbsoluteTime[#],AbsoluteTime[startDate],
			AbsoluteTime[startDate]<AbsoluteTime[#],AbsoluteTime[#],
			True,Null
		]&,
		Lookup[allSampleContainerPackets,DatePurchased,{}]
	];

	(* get the date from which we are going to end the pricing (i.e., either the endDateWithTime or the time when we changed to AwaitingDisposal, whichever is earlier) *)
	(* need to do AbsoluteTime shenanigans to prevent cases where two dates "overlap" even though they don't actually (like this weird MM bug, where DateObject[{2018, 4, 5, 12, 11, 44.7152124`}, "Instant", "Gregorian", -7.`] >= DateObject[{2018, 4, 5, 12, 11, 44.6592068`}, "Instant", "Gregorian", -7.`] should be True but actually throws errors) *)
	resolvedEndDates=Map[
		Which[
			NullQ[#],AbsoluteTime[endDateWithTime],
			AbsoluteTime[endDateWithTime]>=AbsoluteTime[#],AbsoluteTime[#],
			AbsoluteTime[endDateWithTime]<AbsoluteTime[#],AbsoluteTime[endDateWithTime],
			True,AbsoluteTime[endDateWithTime]
		]&,
		allSampleContainerDisposalDate
	];

	(* get the date pairs we are concerned with.  This is a list of pairs of dates from when the first storage condition was set to when it was next set, or to Now *)
	(* the length of each nested list is the same as the length of the storage condition log itself *)
	datePairs=Map[
		Partition[Join[#[[All,1]],{now}],2,1]&,
		simplifiedSiteStorageConditionLogs
	];

	(* get the date pairs as absolute time *)
	(* need to do AbsoluteTime shenanigans to prevent cases where two dates "overlap" even though they don't actually (like this weird MM bug, where DateObject[{2018, 4, 5, 12, 11, 44.7152124`}, "Instant", "Gregorian", -7.`] >= DateObject[{2018, 4, 5, 12, 11, 44.6592068`}, "Instant", "Gregorian", -7.`] should be True but actually throws errors) *)
	datePairsAbsoluteTiming=datePairs/.{date_DateObject:>AbsoluteTime[date]};

	(* get the date pairs that are relevant, taking into account the start and end date of the spans specified here *)
	relevantDatePairs=MapThread[
		Function[{pairs,start,end},
			Map[
				Which[
					Between[start,#] && Between[end,#],{start,end},
					Between[start,#],{start,#[[2]]},
					Between[end,#],{#[[1]],end},
					(#[[1]]>start && #[[2]]<end),#,
					True,Nothing
				]&,
				pairs
			]
		],
		{datePairsAbsoluteTiming,resolvedStartDates,resolvedEndDates}
	];

	(* get the length of time spanned by the date pairs, and flatten it *)
	datePairTimes=Map[
		If[NullQ[#],
			Nothing,
			DateObject[#[[2]]] - DateObject[#[[1]]]
		]&,
		relevantDatePairs,
		{2}
	];
	flatTimes=Flatten[datePairTimes];

	(* get the storage condition objects that correspond to the storage condition during the date pairs in relevantDatePairs above *)
	relevantStorageConditionSitePairs=MapThread[
		Function[{pairs,start,end,storageConditions,sites},
			MapThread[
				If[Between[start,#1] || Between[end,#1] || (#1[[1]]>start && #1[[2]]<end),
					{#2,#3},
					Nothing
				]&,
				{pairs,storageConditions,sites}
			]
		],
		{datePairsAbsoluteTiming,resolvedStartDates,resolvedEndDates,storageConditionsFromLogs,sitesFromLogs}
	];

	(* make a weird association so we can use KeyExistsQ for speed inside the loop *)
	allObjectsAssociation=Association[(#->Null)&/@Lookup[allSampleContainerPackets,Object]];

	(* get the storage rates from the bill or before*)
	initialStorageRates=MapThread[
		Function[{eachDateDiscarded,eachStorageConditionSiteList,eachBillPackets,container},
			Which[
				(*if we are storing this item inside another item in this billing, don't charge for storing it*)
				KeyExistsQ[allObjectsAssociation,container],
				ConstantArray[Quantity[0,Times[Power["Centimeters",-3],Power["Hours",-1],"USDollars"]],Length[eachStorageConditionSiteList]],

				(*check if this is old and school discarded -> we do not account for Site in this case*)
				If[DateObjectQ[eachDateDiscarded],eachDateDiscarded<$PriceSystemSwitchDate,False],
				eachStorageConditionSiteList[[All,1]]/.priceReplaceRules,

				(*otherwise get from the bill packet*)
				True,
				If[MatchQ[eachBillPackets,{PacketP[]..}],
					Module[{billsToUse,currentStoragePricing,currentStoragePricingRules},
						(* find the appropriate bill for each site *)
						billsToUse=FirstCase[eachBillPackets,KeyValuePattern[Site->ObjectP[#[[2]]]],<||>]&/@eachStorageConditionSiteList;
						(*get the storage pricing from the bill and dereference the links*)
						currentStoragePricing=Map[Lookup[#,StoragePricing,{}]/.{x_Link:>Download[x,Object]}&,billsToUse];
						(*convert the tuples to rules*)
						currentStoragePricingRules=Map[Rule@@#&,currentStoragePricing,{2}];
						(*check whether the current storage is in the rules*)
						(*replace any leftovers with not found*)
						ReplaceAll[
							MapThread[ReplaceAll[#1,#2]&,{eachStorageConditionSiteList[[All,1]],currentStoragePricingRules}],
							x:ObjectP[]:>NoPricingForStorageFound
						]
					],
					(* we did not have bill packets *)
					ReplaceAll[
						eachStorageConditionSiteList[[All,1]],
						x:ObjectP[]:>NoBillFound
					]
				]
			]
		],
		{
			allSampleContainerDisposalDate,
			relevantStorageConditionSitePairs,
			billForEachMaterial,
			allSampleContainers
		}
	];

	(*do some error checking*)
	If[MemberQ[initialStorageRates,{___,NoBillFound,___}],
		Message[PriceStorage::MissingBill,PickList[Lookup[allSampleContainerPackets,Object],initialStorageRates,{___,NoBillFound,___}]]
	];

	(*do some error checking*)
	If[MemberQ[initialStorageRates,{___,NoPricingForStorageFound,___}],
		Message[
			PriceStorage::BillMissingStorageCondition,
			PickList[Lookup[allSampleContainerPackets,Object],initialStorageRates,{___,NoPricingForStorageFound,___}]
		]
	];

	(*remove the error state conditions by pricing them as free storage. We do not want to cause the function to fail because of a few bad items as we will still receive notification currently.*)
	(* TODO: When all teams with existing samples have been migrated to ECL-2 pricing schemes, hard error for NoPricingForStorageFound/NoBillFound to better surface issues *)
	(* the previous behavior of setting theses to {} was changed to Null to match the error state checking below *)
	storageRates=initialStorageRates/.{NoPricingForStorageFound->Null,NoBillFound->Null};

	(* get the monthly storage cost by multiplying the rate by the volumes; need to do the shenanigans with mapping since Nulls get in the way *)
	monthlyStorageRates=MapThread[
		Function[{volume,rates},
			If[MemberQ[rates,Null] || NullQ[volume],
				Map[
					If[NullQ[volume] || NullQ[#],
						Null,
						Convert[volume * #,USD / Month]
					]&,
					rates
				],
				Convert[volume * rates,USD / Month]
			]
		],
		{allVolumes,storageRates}
	];

	(* flatten the storage rate out *)
	flatStorageRates=Flatten[monthlyStorageRates];

	(* get the total storage price for each item, and flatten those numbers *)
	totalStoragePrices=MapThread[
		Function[{times,rates},
			MapThread[
				If[NullQ[#1] || NullQ[#2],
					Null,
					#1 * #2
				]&,
				{times,rates}
			]
		],
		{datePairTimes,monthlyStorageRates}
	];
	flatPrices=Flatten[totalStoragePrices];
	(* get the names of the storage conditions, and flatten it out *)
	storageNames=relevantStorageConditionSitePairs[[All,All,1]]/.nameReplaceRules;
	flatStorageNames=Flatten[storageNames];

	(* pull out sites where we stored our items *)
	flatSites=Flatten[relevantStorageConditionSitePairs[[All,All,2]]];

	(* get the packets of the items being stored index matched with the storage conditions *)
	(* need to handle case where totalStoragePrices is Null to keep the index matching *)
	indexMatchedPackets=Flatten[MapThread[
		If[MatchQ[#2, Null],
			#1,
			ConstantArray[#1,Length[#2]]
		]&,
		{allSampleContainerPackets,totalStoragePrices}
	]];

	(* get the packets of the contents of the items being stored index matched with the storage conditions *)
	(* need to handle case where totalStoragePrices is Null to keep the index matching *)
	indexMatchedContentsPackets=Flatten[MapThread[
		If[MatchQ[#2,Null],
			Null,
			ConstantArray[#1,Length[#2]]
		]&,
		{allSampleContainerContentsPackets,totalStoragePrices}
	],1];


	(* get the index matched objects and notebooks for these items *)
	indexMatchedObjs=Lookup[indexMatchedPackets,Object,{}];
	indexMatchedNotebooks=Download[Lookup[indexMatchedPackets,Notebook,{}],Object];

	(* get the names of the item being stored index matched with the storage conditions *)
	(* need to handle case where totalStoragePrices is Null to keep the index matching *)
	indexMatchedModelNames=Flatten[MapThread[
		If[MatchQ[#2, Null],
			#1,
			ConstantArray[#1,Length[#2]]
		]&,
		{allModelNames,totalStoragePrices}
	]];

	(* get the names of the item itself being stored index matched with storage conditions *)
	indexMatchedNames=Flatten[MapThread[
		If[MatchQ[#2, Null],
			#1,
			ConstantArray[#1,Length[#2]]
		]&,
		{allObjNames,totalStoragePrices}
	]];

	(* get the date last used of the item in question index matched with the storage conditions *)
	(* if DateLastUsed is after the end of the bill (when we are doing historical billing), use end date instead *)
	flatDateLastUsed=If[#>endDateWithTime,endDateWithTime,#]&/@Flatten[MapThread[
		If[MatchQ[#2, Null],
			#1,
			ConstantArray[#1,Length[#2]]
		]&,
		{allDatesLastUsed,totalStoragePrices}
	]];

	(* get the Source of the item in question index matched with the storage conditions *)
	flatSources=Flatten[MapThread[
		If[MatchQ[#2, Null],
			#1,
			ConstantArray[#1,Length[#2]]
		]&,
		{allSources,totalStoragePrices}
	]];

	(* flatten out the storage prices, and use Total to get the combined total price *)
	totalFinalPrice=If[MatchQ[DeleteCases[flatPrices,Null],{}],
		0 * USD,
		Total[Unitless[DeleteCases[flatPrices,Null], USD]]*USD
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points, but no further manipulations of the numbers *)
	(* if Consolidation -> Except[Null], then we're going to do NumberForm shenanigans later *)
	allDataTable=MapThread[
		Function[{notebook,object,objectName,modelName,storageName,time,rate,price,dateLastUsed,source,contents,site},
			Which[
				NullQ[time] || NullQ[rate],Nothing,
				MatchQ[output,Table] && NullQ[consolidation],{notebook,site,object,modelName,storageName,NumberForm[time,{\[Infinity],1}],NumberForm[rate,{\[Infinity],2}],NumberForm[Round[price,0.01 * USD],{\[Infinity],2}]},
				MatchQ[output,Association | JSON],{notebook,site,object,objectName,modelName,storageName,time,rate,price,dateLastUsed,Download[source,Object],contents},
				True,{notebook,site,object,modelName,storageName,time,rate,Round[price,0.01 * USD]}
			]
		],
		{
			indexMatchedNotebooks,
			indexMatchedObjs,
			indexMatchedNames,
			indexMatchedModelNames,
			flatStorageNames,
			UnitConvert[flatTimes,"Hours"],
			flatStorageRates,
			flatPrices,
			flatDateLastUsed,
			flatSources,
			indexMatchedContentsPackets,
			flatSites
		}
	];

	(* treat the volumes the same as the data table after expanding to match storage conditions *)
	safeAllVolumes=MapThread[
		Function[{time,rate,volume},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				volume
			]
		],
		{
			UnitConvert[flatTimes,"Hours"],
			flatStorageRates,
			Flatten[
				MapThread[If[Length[ToList[#2]]>1,ConstantArray[#1,Length[ToList[#2]]],#1]&,{allVolumes,totalStoragePrices}]
			]
		}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match StoragePriceTableP *)
	associationOutput=If[MatchQ[output,Association | JSON],
		Map[
			AssociationThread[{Notebook,Site,Object,Name,ModelName,StorageCondition,Time,PricingRate,Price,DateLastUsed,Source,Contents,Volume},#]&,
			MapThread[Join[#1,{#2}]&,{allDataTable,safeAllVolumes}]
		],
		{}
	];

	(* generate the precursor to the JSON output *)
	preJSONOutput=Map[
		Function[{assoc},
			{
				"Notebook"->ToString[Lookup[assoc,Notebook]],
				"Site"->ToString[Lookup[assoc,Site]],
				"Object"->ToString[Lookup[assoc,Object]],
				"ModelName"->Lookup[assoc,ModelName],
				"StorageCondition"->Lookup[assoc,StorageCondition],
				"Time"->Unitless[Lookup[assoc,Time],Hour],
				"PricingRate"->Unitless[Lookup[assoc,PricingRate],USD / Month],
				"Price"->Unitless[Lookup[assoc,Price],USD],
				"DateLastUsed"->ToString[Lookup[assoc,DateLastUsed]],
				"Source"->ToString[Lookup[assoc,Source]],
				"Contents"->If[NullQ[Lookup[assoc,Contents]],
					ToString[Null],
					ToString[#]&/@Lookup[assoc,Contents]
				]
			}
		],
		associationOutput
	];

	(* get the json output *)
	jsonOutput=ExportJSON[preJSONOutput];

	(* generate the table of items that will be displayed if all the information is needed *)
	(* different from allDataTable above because here we are setting the decimal points properly *)
	allColumnsDataTable=MapThread[
		Function[{notebook,object,objectName,storageName,time,rate,price,site},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				{notebook,site,object,objectName,storageName,NumberForm[time,{\[Infinity],1}],NumberForm[rate,{\[Infinity],2}],NumberForm[Round[price,0.01 * USD],{\[Infinity],2}]}
			]
		],
		{indexMatchedNotebooks,indexMatchedObjs,indexMatchedNames,flatStorageNames,UnitScale[flatTimes,Simplify->False],flatStorageRates,flatPrices,flatSites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{object,objectName,storageName,time,rate,price,site},
			Which[
				NullQ[time] || NullQ[rate],Nothing,
				MatchQ[output,Table] && NullQ[consolidation],{site,object,objectName,storageName,NumberForm[time,{\[Infinity],1}],NumberForm[rate,{\[Infinity],2}],NumberForm[Round[price,0.01 * USD],{\[Infinity],2}]},
				True,{site,object,objectName,storageName,time,rate,Round[price,0.01 * USD]}
			]
		],
		{indexMatchedObjs,indexMatchedNames,flatStorageNames,UnitScale[flatTimes,Simplify->False],flatStorageRates,flatPrices,flatSites}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable,#[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1,1]],DeleteCases[#[[All,8]],Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]],{\[Infinity],2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1],#2}&,
		{notebookConsolidatedPreTotal,notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Object *)
	gatheredByObject=GatherBy[allDataTable,#[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	objectConsolidatedPreTotal=Map[
		{#[[1,2]],#[[1,3]],DeleteCases[#[[All,8]],Null]}&,
		gatheredByObject
	];

	(* get the total for each object *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	objectConsolidatedTotals=Map[
		NumberForm[Total[Last[#]],{\[Infinity],2}]&,
		objectConsolidatedPreTotal
	];

	(* generate the simplified-by-object table *)
	objectConsolidatedTable=MapThread[
		{First[#1],#1[[2]],#2}&,
		{objectConsolidatedPreTotal,objectConsolidatedTotals}
	];

	(* group all the rows in the data table by StorageCondition *)
	gatheredByStorageCondition=GatherBy[allDataTable,#[[4]]&];

	(* make a simplified table for pricing grouped by StorageCondition, before we do the Total call *)
	storageConditionConsolidatedPreTotal=Map[
		{#[[1,4]],DeleteCases[#[[All,8]],Null]}&,
		gatheredByStorageCondition
	];

	(* get the total for each storage condition *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	storageConditionConsolidatedTotals=Map[
		NumberForm[Total[Last[#]],{\[Infinity],2}]&,
		storageConditionConsolidatedPreTotal
	];

	(* generate the simplified-by-storage condition table *)
	storageConditionConsolidatedTable=MapThread[
		{First[#1],#2}&,
		{storageConditionConsolidatedPreTotal,storageConditionConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of objects specified in this function *)
	numNotebooks=Length[DeleteDuplicates[indexMatchedNotebooks]];
	numObjs=Length[DeleteDuplicates[indexMatchedObjs]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook  column as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation,numNotebooks},
		{Notebook,_},notebookConsolidatedTable,
		{Sample,_},objectConsolidatedTable,
		{StorageCondition,_},storageConditionConsolidatedTable,
		{_,1},noNotebookDataTable,
		{_,_},allColumnsDataTable
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation,numNotebooks},
		{Notebook | StorageCondition,_},{{"",""},{"Total Price",NumberForm[totalFinalPrice,{\[Infinity],2}]}},
		{Sample,_},{{"","",""},{"","Total Price",NumberForm[totalFinalPrice,{\[Infinity],2}]}},
		{_,1},{{"","","","","","",""},{"","","","","","Total Price",NumberForm[totalFinalPrice,{\[Infinity],2}]}},
		{_,_},{{"","","","","","","",""},{"","","","","","","Total Price",NumberForm[totalFinalPrice,{\[Infinity],2}]}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation,numNotebooks},
		{Notebook,_},{"Notebook","Price"},
		{StorageCondition,_},{"Storage Condition","Price"},
		{Sample,_},{"Object","Model Name","Price"},
		{_,1},{"Site","Object","Model Name","Storage Condition","Time","Price (per month)","Price"},
		{_,_},{"Notebook","Site","Object","Model Name","Storage Condition","Time","Price (per month)","Price"}
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse,subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse,{}],
		{},
		PlotTable[dataWithSubtotal,TableHeadings->{None,columnHeaders},UnitForm->False,Title->"Storage Pricing"]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		Table,tableOutput,
		Association,associationOutput,
		JSON,jsonOutput,
		TotalPrice,totalFinalPrice
	]
	];

(* singleton Team overload with date range *)
PriceStorage[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceStorage[{myTeam}, myDateRange, ops];

(* core reverse listable Team overload with date span *)
PriceStorage[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{alternativesTeams, allNotebooks},

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* pass the notebooks financed by these teams to the core notebook function (or the empty list overload, if no notebooks were found) *)
	PriceStorage[allNotebooks, myDateRange, ops]

];


(* ::Subsection:: *)
(*PriceWaste*)


(* ::Subsubsection::Closed:: *)
(*PriceWaste*)

Authors[PriceWaste]={"alou", "robert", "dima"};

DefineOptions[PriceWaste,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching InstrumentPriceTableP with the same information, or a combined price of all instrument costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | WastePricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing and timing information by Notebook, Protocol, WasteType, or not at all.",
			Category -> "General"
		},
		CacheOption,
		FastTrackOption
	}
];

PriceWaste::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus waste pricing cannot be calculated: `1`.  Please wait until these protocols are completed and then call this function again.";
PriceWaste::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`. These protocols' prices are already included in the price of their parent protocols.  Please provide only completed parent protocols to the inputs of PriceWaste.";
PriceWaste::MissingPricingRate="The following waste models used do not have a listed pricing rate: `1`.  These waste models have been filtered out of the displayed results.  Please contact ECL to ensure this field is properly populated for all waste models.";

(* singleton Protocol overload *)
PriceWaste[myProtocol:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceWasteCore[{myProtocol}, Null, ops];

(* reverse listable Core Protocol overload *)
(* also the empty list overload *)
PriceWaste[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceWasteCore[myProtocols, Null, ops];

(* singleton Notebook overload with no date range*)
PriceWaste[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceWaste[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* singleton Notebook overload with date range *)
PriceWaste[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceWaste[{myNotebook}, myDateRange, ops];

(* reverse listable Notebook overload with no date range *)
PriceWaste[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceWaste[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* core reverse listable Notebook overload with date span*)
PriceWaste[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{sortedDateRange, startDate, endDate, alternativesNotebooks, allProtocols, today, now, endDateWithTime},

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceWasteCore[allProtocols, myDateRange, ops]
];

(* singleton Team overload with no date range *)
PriceWaste[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceWaste[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* singleton Team overload with date range *)
PriceWaste[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceWaste[{myTeam}, myDateRange, ops];

(* reverse listable Team overload with no date range *)
PriceWaste[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceWaste[myTeams, Span[Now, Now - 1 * Month], ops];

(* reverse listable Core Notebook overload *)
PriceWaste[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{alternativesTeams, sortedDateRange, allNotebooks, allProtocols, alternativesNotebooks, startDate, endDate, today, now, endDateWithTime},

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceWasteCore[allProtocols, myDateRange, ops]

];


(* ::Subsubsection::Closed:: *)
(*PriceWasteCore (private)*)


(*
	Private helper that creates the table for instrument time; all PriceWaste overloads point at this

	Input:
		1.) list of protocols
		2.) Date range specified (or Null)

	Output:
		A table, list of associations, or a single price
*)

(* core function that all PriceWaste overloads call *)
priceWasteCore[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]), ops:OptionsPattern[]]:=Module[
	{
		safeOps,output,cache,fastTrack,allDownloadValues,
		protocolSortingDate,oldWastePricingPacketsRaw,newWastePricingPacketsRaw,oldWastePricingPackets,newWastePricingPackets,
		wasteDescriptions,priceWasteGeneratedDataTable,priceWasteGeneratedDataTableDateCompleted,
		priceWasteResourcesDataTable,priceWasteResourcesDataTableDateCompleted,
		flatProtocolsIndexMatched,flatNotebooksIndexMatched,flatWasteAmounts,flatTotalCost,
		totalPrice,allDataTable,associationOutput,tableOutput,consolidation,now,
		pricingRate,noNotebookDataTable,noProtocolDataTable,
		gatheredByNotebook,notebookConsolidatedTable,gatheredByProtocol,protocolConsolidatedTable,numNotebooks,
		numProts,dataTableToUse,subtotalRows,columnHeaders,dataWithSubtotal,
		notebookConsolidatedPreTotal,notebookConsolidatedTotals,protocolConsolidatedPreTotal,startDate,endDate,
		protocolConsolidatedTotals,dataTableDateCompleted,oldPricingResults,newPricingResults,
		singleTableTitle,wasteTypes,gatheredByWaste,wasteConsolidatedPreTotal,wasteConsolidatedTotals,wasteConsolidatedTable,
		flatSitesIndexMatched,flatSites},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceWaste, ToList[ops]];
	{output, consolidation, cache, fastTrack}=Lookup[safeOps, {OutputFormat, Consolidation, Cache, FastTrack}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		{First[Sort[myDateRange]], Last[Sort[myDateRange]]}
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* Download the needed information about the protocol and its waste measurements *)
	allDownloadValues=Quiet[Download[
		myProtocols,
		{
			(* date to sort for new/old waste pricing subfunction *)
			(* TODO change this date if we decide to go with not DateCreated but something else *)
			DateCreated,

			(* data for old pricing function *)
			(* information about the protocol(s) *)
			Packet[Notebook, ParentProtocol, Status, WasteGenerated, DateCompleted, Site],
			Packet[Repeated[Subprotocols][WasteGenerated]],

			(* information about the pricing rate of the WasteGenerated *)
			Packet[WasteGenerated[[All, Waste]][{WasteType, Name}]],
			Packet[Repeated[Subprotocols][WasteGenerated][[All, Waste]][{WasteType, Name}]],

			(* information about the troubleshooting reports *)
			Packet[UserCommunications[Refund]],

			(* information about the pricing of the site *)
			Packet[Site[WastePrices]],

			(* data for new pricing function *)
			(* information about the protocol(s) *)
			Packet[Notebook, ParentProtocol, Status, DateCompleted, Site],

			(* information about the troubleshooting reports *)
			Packet[UserCommunications[Refund]],

			(* get all of the resources*)
			Packet[SubprotocolRequiredResources[{Amount, WasteType, WasteDescription, Status}]],
			Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, WastePricing, Site}]]
		},
		Cache -> cache,
		SquashResponses -> True,
		Date -> Now
	],
		{Download::FieldDoesntExist, Download::NotLinkedField}];

	(* split the downloaded data into variables *)
	protocolSortingDate=allDownloadValues[[All, 1]];
	oldWastePricingPacketsRaw=allDownloadValues[[All, 2;;7]];
	newWastePricingPacketsRaw=allDownloadValues[[All, 8;;]];

	(* leave only relevant packets *)
	(* in super old protocols, DateCreated is not populated so we put them into the old function *)
	oldWastePricingPackets=PickList[oldWastePricingPacketsRaw, protocolSortingDate, (LessP[$WasteResourcePricingDate] | Null)];
	newWastePricingPackets=PickList[newWastePricingPacketsRaw, protocolSortingDate, GreaterEqualP[$WasteResourcePricingDate]];

	(* call subfunctions to price waste depending how it was tracked *)
	oldPricingResults=priceWasteGenerated[oldWastePricingPackets, output, fastTrack];
	newPricingResults=priceWasteResources[newWastePricingPackets, output, fastTrack];

	(* Fail if any of the subfunctions failed or assign the variables and keep going*)
	If[MatchQ[oldPricingResults, $Failed], Return[$Failed], {priceWasteGeneratedDataTable, priceWasteGeneratedDataTableDateCompleted}=oldPricingResults];
	If[MatchQ[newPricingResults, $Failed], Return[$Failed], {priceWasteResourcesDataTable, priceWasteResourcesDataTableDateCompleted}=newPricingResults];

	(* combine data from the subfunction outputs *)
	allDataTable=Join[priceWasteGeneratedDataTable, priceWasteResourcesDataTable];
	dataTableDateCompleted=Join[priceWasteGeneratedDataTableDateCompleted, priceWasteResourcesDataTableDateCompleted];

	(* generate the output association; this will be returned to the main function *)
	associationOutput=Map[
		AssociationThread[{Notebook, Source, Site, WasteType, WasteDescription, Weight, PricePerKilogram, Price, Date}, #]&,
		MapThread[Join[#1, {#2}]&, {allDataTable, dataTableDateCompleted}]
	];

	(* extract data from the association for output formatting *)
	flatNotebooksIndexMatched=ToList@Lookup[associationOutput, Notebook, Null];
	flatProtocolsIndexMatched=ToList@Lookup[associationOutput, Source, Null];
	flatSitesIndexMatched=ToList@Lookup[associationOutput, Site, Null];
	wasteTypes=ToList@Lookup[associationOutput, WasteType, Null];
	wasteDescriptions=ToList@Lookup[associationOutput, WasteDescription, Null];
	flatWasteAmounts=ToList@Lookup[associationOutput, Weight, Null];
	pricingRate=ToList@Lookup[associationOutput, PricePerKilogram, Null];
	flatTotalCost=ToList@Lookup[associationOutput, Price, Null];
	flatSites=ToList@Lookup[associationOutput, Site, Null];


	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, wasteType, wasteDescription, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {protocol, site, wasteType, wasteDescription, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {protocol, site, wasteType, wasteDescription, amount, rate, price}
			]
		],
		{flatProtocolsIndexMatched, wasteTypes, wasteDescriptions, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate, flatTotalCost, flatSitesIndexMatched,flatSites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{wasteType, wasteName, amount, rate, price},
			Switch[{amount, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {wasteType, wasteName, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {wasteType, wasteName, amount, rate, price}
			]
		],
		{wasteTypes, wasteDescriptions, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate, flatTotalCost}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 7]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 7]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* group all the rows in the data table by WasteType *)
	gatheredByWaste=GatherBy[allDataTable, #[[3]]&];

	(* make a simplified table for pricing grouped by WasteType, before we do the Total call *)
	wasteConsolidatedPreTotal=Map[
		{#[[1, 3]], DeleteCases[#[[All, 7]], Null]}&,
		gatheredByWaste
	];

	(* get the total for each waste type *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	wasteConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		wasteConsolidatedPreTotal
	];

	(* generate the simplified-by-waste table *)
	wasteConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{wasteConsolidatedPreTotal, wasteConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[flatNotebooksIndexMatched]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Protocol, _, _}, protocolConsolidatedTable,
		{WasteType, _, _}, wasteConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];

	(* get the total price for the waste *)
	totalPrice=If[MatchQ[DeleteCases[flatTotalCost, Null], {}],
		0 * USD,
		Total[DeleteCases[flatTotalCost, Null]]
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Protocol | WasteType, _, _}, {{"", ""}, {"Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", "", "", ""}, {"", "", "", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", "", "", ""}, {"", "", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", "", "", ""}, {"", "", "", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Notebook", "Price"},
		{Protocol, _, _}, {"Protocol", "Price"},
		{WasteType, _, _}, {"Waste Type", "Waste Name", "Price"},
		{_, 1, 1}, {"Waste Type", "Waste Name", "Amount", "Price (per kilogram)", "Price"},
		{_, 1, _}, {"Protocol", "Site", "Waste Type", "Waste Name", "Amount", "Price (per kilogram)", "Price"},
		{_, _, _}, {"Notebook", "Site", "Protocol", "Waste Type", "Waste Name", "Amount", "Price (per kilogram)", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Waste Generated Pricing",
		StringJoin["Waste Generated Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option and whether tableOutput is a table or list of tables to provide the output *)
	Switch[{output, tableOutput},
		{Table, _}, tableOutput,
		{Association, _}, associationOutput,
		{TotalPrice, _}, totalPrice
	]
];


(* prices the waste based off the old system - through WasteGenerated *)
priceWasteGenerated[allDownloadValues_, output:PricingOutputP, fastTrack:BooleanP]:=Module[
	{
		allProtocolPackets,protocolObjects,protocolNotebooks,subprotocols,
		notCompletedProts,allSubprotocolPackets,wasteGeneratedByRoot,parentProtWastePackets,subprotocolWastePackets,
		wastePacketsByRoot,wastePacketsNoDuplicates,gatheredWasteAmounts,combinedWasteAmounts,wastePricingRatesByRoot,
		flatProtocolsIndexMatched,flatNotebooksIndexMatched,flatWasteAmounts,flatWastePackets,flatTotalCost,
		totalPrice,allDataTable,consolidation,allTSReportPackets,
		refundStatus,nonRefundedProtPackets,pricingRate,wasteNames,nullWastes,allSitePackets,
		indexMatchedDateCompleted,dataTableDateCompleted,wasteGeneratedByRootWithPrice,wasteTypes,sites},

	(* get the protocol packets from the big Download *)
	allProtocolPackets=allDownloadValues[[All, 1]];

	(* get all the troubleshooting report packets from the big Download, each as a flat list *)
	allTSReportPackets=Flatten[#]& /@ allDownloadValues[[All, 5]];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		allTSReportPackets
	];

	(* get all the non-refunded protocol packets *)
	nonRefundedProtPackets=PickList[allProtocolPackets, refundStatus, False];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[nonRefundedProtPackets, Object, {}];
	protocolNotebooks=Download[Lookup[nonRefundedProtPackets, Notebook, {}], Object];

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[nonRefundedProtPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!fastTrack && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceWaste::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[nonRefundedProtPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceWaste::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(* get the subprotocol and site packets from the big Download *)
	allSubprotocolPackets=PickList[allDownloadValues[[All, 2]], refundStatus, False];
	allSitePackets=PickList[allDownloadValues[[All, 6]], refundStatus, False];

	(* group the PriceWaste by root protocol *)
	wasteGeneratedByRoot=MapThread[
		Flatten[Lookup[Flatten[{#1, #2}], WasteGenerated]]&,
		{nonRefundedProtPackets, allSubprotocolPackets}
	];

	(* get the model waste packets corresponding to the parent protocols *)
	parentProtWastePackets=PickList[allDownloadValues[[All, 3]], refundStatus, False];
	subprotocolWastePackets=PickList[allDownloadValues[[All, 4]], refundStatus, False];

	(* get the relevant waste packets grouped by root protocol *)
	wastePacketsByRoot=MapThread[
		Flatten[{#1, #2}]&,
		{parentProtWastePackets, subprotocolWastePackets}
	];

	(* Get the waste packets with no duplicates; this will make making the pricing table easier *)
	wastePacketsNoDuplicates=DeleteDuplicates[#]& /@ wastePacketsByRoot;

	(* get the combined waste prices for each of the waste types *)
	wastePricingRatesByRoot=MapThread[
		Function[{wastePackets, sitePacket},
			Map[
				With[{wasteType=Lookup[#, WasteType]},
					LastOrDefault[SelectFirst[Lookup[sitePacket, WastePrices], MatchQ[#[[1]], wasteType] &, Null]]
				]&,
				wastePackets
			]
		],
		{wastePacketsByRoot, allSitePackets}
	];

	(* adding the pricing rate to the association we already have as a fake field *)
	(* not really supposed to do this but whatever *)
	wasteGeneratedByRootWithPrice=MapThread[
		Function[{pricingRates, wasteGeneratedAssocs},
			MapThread[
				Append[#2, PricingRate -> #1]&,
				{pricingRates, wasteGeneratedAssocs}
			]
		],
		{wastePricingRatesByRoot, wasteGeneratedByRoot}
	];

	(* Gather all the waste that comes from the same waste model*)
	gatheredWasteAmounts=Map[
		Function[{allWastePerParent},
			GatherBy[allWastePerParent, Download[Lookup[#, Waste], Object]&]
		],
		wasteGeneratedByRootWithPrice
	];

	(* Combine the waste amounts that come from the same waste model *)
	combinedWasteAmounts=Map[
		Total[#[[All, 2]]]&,
		gatheredWasteAmounts,
		{2}
	];

	(* get the parent protocol IDs index matched with the prices *)
	flatProtocolsIndexMatched=Flatten[MapThread[
		ConstantArray[Lookup[#1, Object], Length[#2]]&,
		{nonRefundedProtPackets, wastePacketsNoDuplicates}
	]];

	(* get the Notebook index matched with the prices *)
	flatNotebooksIndexMatched=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Download[Lookup[nonRefundedProtPackets, Notebook, {}], Object], wastePacketsNoDuplicates}
	]];

	(* get the protocol's date completed matched with the rest *)
	indexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[nonRefundedProtPackets, DateCompleted, {}], wastePacketsNoDuplicates}
	]];

	(* Flatten out the waste amounts and model waste packets*)
	flatWasteAmounts=Flatten[combinedWasteAmounts];
	flatWastePackets=Flatten[wastePacketsNoDuplicates];

	(* get the pricing rate for all the model wastes, and the names of all the wastes *)
	pricingRate=Flatten[Map[
		Lookup[#[[1]], PricingRate]&,
		gatheredWasteAmounts,
		{2}
	]];
	wasteTypes=Lookup[flatWastePackets, WasteType, {}];
	wasteNames=Lookup[flatWastePackets, Name, {}];

	(* get the waste models that don't have any pricing information *)
	nullWastes=PickList[Lookup[flatWastePackets, Object, {}], pricingRate, Null];

	(* if there are any wastes that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullWastes, {}]],
		Message[PriceWaste::MissingPricingRate, nullWastes]
	];

	(* get the total cost for each weight *)
	flatTotalCost=MapThread[
		If[NullQ[#1] || NullQ[#2],
			Null,
			#1 * #2
		]&,
		{flatWasteAmounts, pricingRate}
	];

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[flatTotalCost, Null], {}],
		0 * USD,
		Total[DeleteCases[flatTotalCost, Null]]
	];

	(* pull out protocols for each protocol *)
	sites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,allProtocolPackets],
				Site],
			Object]&,
		flatProtocolsIndexMatched];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, wasteType, wasteName, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, wasteType, wasteName, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, wasteType, wasteName, amount, rate, price}
			]
		],
		{flatNotebooksIndexMatched, flatProtocolsIndexMatched, wasteTypes, wasteNames, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate, flatTotalCost, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, time, rate},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				date
			]
		],
		{indexMatchedDateCompleted, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate}
	];

	(* return the data to the parent function *)
	{allDataTable, dataTableDateCompleted}
];

priceWasteResources[allDownloadValues_, output:PricingOutputP, fastTrack:BooleanP]:=Module[
	{
		allProtocolPackets,protocolObjects,protocolNotebooks,subprotocols,
		notCompletedProts,wasteResources,myObjectBillPackets,billForEachProtocol,
		wastePacketsNoDuplicates,gatheredWasteAmounts,combinedWasteAmounts,
		flatProtocolsIndexMatched,flatNotebooksIndexMatched,flatWasteAmounts,flatWastePackets,flatTotalCost,
		totalPrice,allDataTable,consolidation,allTSReportPackets,
		refundStatus,pricingRate,wasteDescriptions,nullWastes,flatWasteTypes,indexMatchedDateCompleted,
		dataTableDateCompleted,wasteGeneratedByRootWithPrice,sites},

	(* get the protocol packets from the big Download *)
	allProtocolPackets=allDownloadValues[[All, 1]];

	(* get all the troubleshooting report packets from the big Download, each as a flat list *)
	allTSReportPackets=Flatten[#]& /@ allDownloadValues[[All, 2]];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		allTSReportPackets
	];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[allProtocolPackets, Object, {}];
	protocolNotebooks=Download[Lookup[allProtocolPackets, Notebook, {}], Object];

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[allProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!fastTrack && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceWaste::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[allProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceWaste::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(*get only the resource waste resources*)
	wasteResources=Map[Cases[#, ObjectP[Object[Resource, Waste]]]&, allDownloadValues[[All, 3]]];

	(*get all of the bill packets*)
	myObjectBillPackets=allDownloadValues[[All, 4]];

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket, billList},
			(*the bill can either be ongoing or it's a historical one*)
			With[{protocolSite=Download[Lookup[eachProtocolPacket,Site],Object]},
			FirstCase[
				Flatten[ToList[billList]],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], Status -> Open, DateCompleted -> Null, Site->LinkP[protocolSite]}],
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], DateCompleted -> GreaterEqualP[Lookup[eachProtocolPacket, DateCompleted]], Site->LinkP[protocolSite]}]
				],
				(*indicate if we couldn't find a bill*)
				NoBillFound
			]]
		],
		{
			allProtocolPackets,
			myObjectBillPackets
		}
	];

	(* Get the waste packets with no duplicates; this will make making the pricing table easier *)
	wastePacketsNoDuplicates=DeleteDuplicates[#]& /@ wasteResources;

	(* adding the pricing rate to the association we already have as a fake field *)
	(* not really supposed to do this but whatever *)
	wasteGeneratedByRootWithPrice=MapThread[
		Function[{billPacketForEachProtocol, wastePacketsForEachProtocol, refundQ},
			Map[
				Function[{eachWastePacket},
					Append[
						eachWastePacket,
						(*first check to see if we have a bill *)
						PricingRate -> Which[
							refundQ, 0 USD / Kilogram,
							MatchQ[billPacketForEachProtocol, PacketP[]],
							(* then check to see if this specific waste type is represented in the bill*)
							If[MemberQ[Lookup[billPacketForEachProtocol, WastePricing][[All, 1]], Lookup[eachWastePacket, WasteType]],
								(*look up the pricing rate from the bill*)
								ReplaceAll[
									Lookup[eachWastePacket, WasteType],
									Map[
										Rule @@ #&,
										Lookup[billPacketForEachProtocol, WastePricing]
									]
								]
							],
							True, Null
						]
					]
				],
				wastePacketsForEachProtocol
			]
		],
		{billForEachProtocol, wasteResources, refundStatus}
	];

	(* Gather all the waste that comes from the same waste model*)
	gatheredWasteAmounts=Map[
		Function[{allWastePerParent},
			GatherBy[allWastePerParent, Download[Lookup[#, Waste], Object]&]
		],
		wasteGeneratedByRootWithPrice
	];

	(* Combine the waste amounts that come from the same waste model *)
	combinedWasteAmounts=Map[
		Total[#[[All, 2]]]&,
		gatheredWasteAmounts,
		{2}
	];

	(* get the parent protocol IDs index matched with the prices *)
	flatProtocolsIndexMatched=Flatten[MapThread[
		ConstantArray[Lookup[#1, Object], Length[#2]]&,
		{allProtocolPackets, wastePacketsNoDuplicates}
	]];

	(* get the Notebook index matched with the prices *)
	flatNotebooksIndexMatched=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Download[Lookup[allProtocolPackets, Notebook, {}], Object], wastePacketsNoDuplicates}
	]];

	(* get the protocol's date completed matched with the rest *)
	indexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[allProtocolPackets, DateCompleted, {}], wastePacketsNoDuplicates}
	]];

	(* Flatten out the waste amounts and model waste packets*)
	flatWastePackets=Flatten[wasteGeneratedByRootWithPrice];
	flatWasteAmounts=Lookup[flatWastePackets, Amount, {}];
	flatWasteTypes=Lookup[flatWastePackets, WasteType, {}];

	(* get the pricing rate for all the model wastes, and the names of all the wastes *)
	pricingRate=Lookup[flatWastePackets, PricingRate, {}];
	wasteDescriptions=Lookup[flatWastePackets, WasteDescription, {}];

	(* get the waste models that don't have any pricing information *)
	nullWastes=If[Length[flatWastePackets] > 0, PickList[Lookup[flatWastePackets, Object, {}], pricingRate, Null], {}];

	(* if there are any wastes that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullWastes, {}]],
		Message[PriceWaste::MissingPricingRate, nullWastes]
	];

	(* get the total cost for each weight *)
	flatTotalCost=MapThread[
		If[NullQ[#1] || NullQ[#2],
			Null,
			#1 * #2
		]&,
		{flatWasteAmounts, pricingRate}
	];

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[flatTotalCost, Null], {}],
		0 * USD,
		Total[DeleteCases[flatTotalCost, Null]]
	];

	(* pull out protocols for each protocol *)
	sites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,allProtocolPackets],
				Site],
			Object]&,
		flatProtocolsIndexMatched];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, wasteType, wasteDescription, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, wasteType, wasteDescription, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, wasteType, wasteDescription, amount, rate, price}
			]
		],
		{flatNotebooksIndexMatched, flatProtocolsIndexMatched, flatWasteTypes, wasteDescriptions, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate, flatTotalCost, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, time, rate},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				date
			]
		],
		{indexMatchedDateCompleted, UnitScale[flatWasteAmounts, Simplify -> False], pricingRate}
	];

	(* return the results to the parent function *)
	{allDataTable, dataTableDateCompleted}
];





(* ::Subsection:: *)
(*PriceInstrumentTime*)

Authors[PriceInstrumentTime]={"andrey.shur", "lei.tian", "jihan.kim", "dima", "alou"};

(* ::Subsubsection::Closed:: *)
(*PriceInstrumentTime*)


DefineOptions[PriceInstrumentTime,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching InstrumentPriceTableP with the same information, or a combined price of all instrument costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | InstrumentPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing and timing information by Notebook, Protocol, Instrument Model, or not at all.",
			Category -> "General"
		},
		{
			OptionName -> Time,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> EstimatedTime | Time | Automatic],
			Description -> "Determines whether the price provided is based on the Estimated or actual amount of time used.",
			ResolutionDescription -> "Automatically picks the smaller time between Estimated and a real time.",
			Category -> "General"
		},
		{
			OptionName -> Fail,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP],
			Description -> "Fails the function automatically.",
			Category -> "Hidden"
		},
		CacheOption
	}
];

PriceInstrumentTime::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus pricing from instrument time cannot be calculated: `1`.  Please wait until these protocols are completed and then call this function again.";
PriceInstrumentTime::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`.  These protocols' prices are already included in the price of their parent protocols.  Please provide only completed parent protocols to the inputs of PriceInstrumentTime.";
PriceInstrumentTime::MissingPricingLevel="The following instruments used do not have a listed pricing level: `1`.  These instruments have been filtered out of the displayed results.  Please contact ECL to ensure this field is properly populated for all instruments.";

(* singleton Protocol overload *)
PriceInstrumentTime[myProtocol:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceInstrumentTimeCore[{myProtocol}, Null, ops];

(* reverse listable Core Protocol overload *)
(* also the empty list overload *)
PriceInstrumentTime[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceInstrumentTimeCore[myProtocols, Null, ops];

(* singleton Notebook overload with no date range *)
PriceInstrumentTime[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceInstrumentTime[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* singleton Notebook overload with date range *)
PriceInstrumentTime[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceInstrumentTime[{myNotebook}, myDateRange, ops];

(* reverse listable Notebook overload with no date range *)
PriceInstrumentTime[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceInstrumentTime[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* core function featuring reverse listable Notebook overload with date span *)
PriceInstrumentTime[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, alternativesNotebooks, sortedDateRange, allProtocols, startDate, endDate, endDateWithTime},

	(* get the safe options *)
	safeOps=SafeOptions[PriceInstrumentTime, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceInstrumentTimeCore[allProtocols, myDateRange, safeOps]

];

(* Singleton Team overload with no date range *)
PriceInstrumentTime[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceInstrumentTime[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* singleton Team overload with date range *)
PriceInstrumentTime[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceInstrumentTime[{myTeam}, myDateRange, ops];

(* reverse listable Team overload with no date range*)
PriceInstrumentTime[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceInstrumentTime[myTeams, Span[Now, Now - 1 * Month], ops];

(* reverse listable Core Team overload with date range *)
PriceInstrumentTime[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, alternativesTeams, sortedDateRange, allNotebooks, endDateWithTime, allProtocols, alternativesNotebooks, startDate, endDate},

	(* get the safe option *)
	safeOps=SafeOptions[PriceInstrumentTime, ToList[ops]];

	(* if we are failing early, do that *)
	If[Lookup[safeOps, Fail], Return[$Failed]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceInstrumentTimeCore[allProtocols, myDateRange, safeOps]

];


(* ::Subsubsection::Closed:: *)
(*priceInstrumentTimeCore (private)*)


(*
	Private helper that creates the table for instrument time; all PriceInstrumentTime overloads point at this

	Input:
		1.) list of protocols
		2.) Date range specified (or Null)

	Output:
		A table, list of associations, or a single price
*)

(* core function that all PriceInstrumentTime overloads call *)
priceInstrumentTimeCore[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]), ops:OptionsPattern[]]:=Module[
	{safeOps,output,consolidation,cache,now,
		allDownloadValues,protocolPackets,tsReportPackets,allResourcePackets,instrumentModelPackets,
		pricingLists,notebooks,protocols,datesCompleted,instObjs,modelInstNames,usageTimes,pricingRates,pricings,pricingCategories,
		totalPrice,allDataTable,dataTableTier,pricingTiers,dataTableDateCompleted,associationOutput,noNotebookDataTable,noProtocolDataTable,
		gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,
		gatheredByProtocol,protocolConsolidatedPreTotal,protocolConsolidatedTotals,protocolConsolidatedTable,
		gatheredByInstrument,instrumentConsolidatedPreTotal,instrumentConsolidatedTotals,instrumentConsolidatedTable,
		numNotebooks,numProts,dataTableToUse,subtotalRows,columnHeaders,singleTableTitle,dataWithSubtotal,tableOutput,
		startDate,endDate,timeSource,objectBillPackets,sites},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceInstrumentTime, ToList[ops]];
	{output, consolidation, cache, timeSource}=Lookup[safeOps, {OutputFormat, Consolidation, Cache, Time}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		With[{sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange, $TimeZone]]},{First[sortedDateRange], Last[sortedDateRange]}]
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* Download the information about the the instruments used by this protocol and all its subs, the pricing rates of those instruments, the name of the models of these instruments, and the notebook of the protocol *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not instrument resources and we need to distinguish these cases *)
	allDownloadValues=Quiet[
		Download[
			myProtocols,
			{
				Packet[Notebook, ParentProtocol, Status, DateCompleted, Site],
				Packet[UserCommunications[Refund]],
				Packet[SubprotocolRequiredResources[{Time, EstimatedTime, Instrument, Status, Requestor}]],
				Packet[SubprotocolRequiredResources[Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
				Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, InstrumentPricing, IncludedInstrumentHours, Site}]]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* slice out the individual downloaded lists for passing to core private helper *)
	protocolPackets=allDownloadValues[[All, 1]];
	tsReportPackets=allDownloadValues[[All, 2]];
	allResourcePackets=allDownloadValues[[All, 3]];
	instrumentModelPackets=allDownloadValues[[All, 4]];
	objectBillPackets=allDownloadValues[[All, 5]];

	(* get the info required for pricing table generation from a core helper; might return a failure *)
	pricingLists=priceInstrumentTimeProtocols[
		protocolPackets,
		tsReportPackets,
		allResourcePackets,
		instrumentModelPackets,
		objectBillPackets,
		Time -> timeSource
	];
	If[MatchQ[pricingLists, $Failed],
		Return[$Failed]
	];

	(* get the info required for pricing table generation from a core helper *)
	{notebooks, protocols, datesCompleted, instObjs, modelInstNames, usageTimes, pricingRates, pricings, pricingCategories, pricingTiers, sites}=pricingLists;

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[pricings, Null], {}],
		0 * USD,
		Total[DeleteCases[pricings, Null]]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, instrument, instrumentModel, time, rate, price, category, site},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, instrument, instrumentModel, category, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, instrument, instrumentModel, category, time, rate, price}
			]
		],
		{notebooks, protocols, instObjs, modelInstNames, usageTimes, pricingRates, pricings, pricingCategories, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, time, rate},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				date
			]
		],
		{datesCompleted, usageTimes, pricingRates}
	];

	(* do the same for the tier. We are doing this because it is part of the association output, but not the tables *)
	dataTableTier=MapThread[
		Function[{tier, time, rate},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				tier
			]
		],
		{pricingTiers, usageTimes, pricingRates}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match InstrumentPriceTableP *)
	associationOutput=Map[
		AssociationThread[{DateCompleted, Notebook, Source, Site, Instrument, ModelName, PricingCategory, Time, PricePerHour, Price, PricingTier}, #]&,
		MapThread[Join[{#1}, #2, {#3}]&, {dataTableDateCompleted, allDataTable, dataTableTier}]
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, instrument, instrumentModel, category, time, rate, price, site},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {protocol, site, instrument, instrumentModel, category, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {protocol, site, instrument, instrumentModel, category, time, rate, price}
			]
		],
		{protocols, instObjs, modelInstNames, pricingCategories, usageTimes, pricingRates, pricings, sites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{instrument, instrumentModel, category, time, rate, price},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {instrument, instrumentModel, category, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {instrument, instrumentModel, category, time, rate, price}
			]
		],
		{instObjs, modelInstNames, pricingCategories, usageTimes, pricingRates, pricings}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* group all the rows in the data table by instrument model *)
	gatheredByInstrument=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by instrument, before we do the Total call *)
	instrumentConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByInstrument
	];

	(* get the total for each instrument *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	instrumentConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		instrumentConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	instrumentConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{instrumentConsolidatedPreTotal, instrumentConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[notebooks]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Protocol, _, _}, protocolConsolidatedTable,
		{Instrument, _, _}, instrumentConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Protocol | Instrument, _, _}, {{"", ""}, {"Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", "", "", "", ""}, {"", "", "", "", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Notebook", "Price"},
		{Protocol, _, _}, {"Protocol", "Price"},
		{Instrument, _, _}, {"Instrument Model Name", "Price"},
		{_, 1, 1}, {"Instrument Object", "Model Name", "Pricing Category", "Time Used", "Price (per hour)", "Price"},
		{_, 1, _}, {"Protocol", "Site", "Instrument Object", "Model Name", "Pricing Category", "Time Used", "Price (per hour)", "Price"},
		{_, _, _}, {"Notebook", "Protocol", "Site", "Instrument Object", "Model Name", "Pricing Category", "Time Used", "Price (per hour)", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Instrument Time Pricing",
		StringJoin["Instrument Time Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalPrice
	]
];



(* ::Subsubsection::Closed:: *)
(*priceInstrumentTimeProtocols (private)*)


(*
	Private helper that does the core calculating for PriceInstrumentTime based on protocols and their associated instrument UsageFrequency
		- determines amount of time each instrument resource was used
		- uses pricing rate to calculate price
		- NOTE: also called directly by priceTransactionsToUser in PriceTransactions

	Input:

	Output:
	{indexMatchedNotebooks, indexMatchedProtocols, instObjs, modelInstNames, UnitScale[timeUsed, Simplify -> False], pricingRate, pricing}
*)

DefineOptions[priceInstrumentTimeProtocols,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for instrument time pricing."},
		{Time -> EstimatedTime, EstimatedTime | Time | Automatic, "Determines whether the price provided is based on the Estimated or actual amount of time used.", Category -> Hidden}
	}
];

priceInstrumentTimeProtocols[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myResourcePackets:{{PacketP[Object[Resource]]...}...},
	myInstrumentModelPackets:{{(PacketP[Model[Instrument]] | $Failed | Null)...}...},
	myObjectBillPackets:{
		({
			({PacketP[Object[Bill]]...} | $Failed | Null)...
		} | Null)...
	},
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,allowSubprotocolsQ,refundStatus,nonRefundedProtPackets,protocolObjects,
		protocolNotebooks,allInstrumentResourcePackets,allModelInstrumentPackets,allInstrumentResourceStatuses,
		allFulfilledInstrumentResourcePackets,allFulfilledModelInstrumentPackets,subprotocols,notCompletedProts,
		billForEachProtocol,indexMatchedBills,pricingLevel,indexMatchedRefundStatus,
		indexMatchedNotebooks,indexMatchedProtocols,indexMatchedDateCompleted,flatInstResourcePackets,flatModelInstPackets,
		pricingRate,timeUsed,pricingCategory,instObjs,nullInstruments,pricing,modelInstNames,timeSource,missingBillsQ,indexMatchedSites},

	(* get safe options *)
	safeOptions=SafeOptions[priceInstrumentTimeProtocols, ToList[myOptions]];
	{allowSubprotocolsQ, timeSource}=Lookup[safeOptions, {AllowSubprotocols, Time}];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* get all the non-refunded protocol packets *)
	nonRefundedProtPackets=PickList[myProtocolPackets, refundStatus, False];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[myProtocolPackets , Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets , Notebook, {}], Object];

	(* get all the instrument resource packets that were used *)
	(* this is a list of lists that is index matched with the input protocols *)
	allInstrumentResourcePackets=Map[
		Cases[#, PacketP[Object[Resource, Instrument]]]&,
		myResourcePackets
	];

	(* get all the model instrument packets *)
	(* this is a list of lists that is index matched with the input protocols *)
	(* each nested list is index matched with the instrument resource above *)
	allModelInstrumentPackets=MapThread[
		PickList[#2, #1, PacketP[Object[Resource, Instrument]]]&,
		{myResourcePackets, myInstrumentModelPackets}
	];

	(* get the status of all the instrument resource packets *)
	allInstrumentResourceStatuses=Lookup[#, Status, {}]& /@ allInstrumentResourcePackets;

	(* get only the fulfilled instrument resource packets *)
	allFulfilledInstrumentResourcePackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allInstrumentResourcePackets, allInstrumentResourceStatuses}
	];

	(* get the instrument models of only the fulfilled instrument resources *)
	allFulfilledModelInstrumentPackets=MapThread[
		Cases[PickList[#1, #2, Fulfilled], PacketP[Model[Instrument]]]&,
		{allModelInstrumentPackets, allInstrumentResourceStatuses}
	];

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceInstrumentTime::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceInstrumentTime::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket, billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], Status -> Open, DateCompleted -> Null, Site->LinkP[Download[Lookup[eachProtocolPacket,Site],Object]]}],
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], DateCompleted -> GreaterEqualP[Lookup[eachProtocolPacket, DateCompleted]], Site->LinkP[Download[Lookup[eachProtocolPacket,Site],Object]]}]
				],
				(*indicate if we couldn't find a bill*)
				NoBillFound
			]
		],
		{
			myProtocolPackets,
			myObjectBillPackets
		}
	];

	(* get the notebook index matched with the rest *)
	indexMatchedNotebooks=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{protocolNotebooks, allFulfilledInstrumentResourcePackets}
	]];

	(* get the protocol index matched with the rest *)
	indexMatchedProtocols=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, Object, {}], allFulfilledInstrumentResourcePackets}
	]];

	(* get the protocol's date completed matched with the rest *)
	indexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, DateCompleted, {}], allFulfilledInstrumentResourcePackets}
	]];

	(* make an index matching list for the bills *)
	indexMatchedBills=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{billForEachProtocol, allFulfilledInstrumentResourcePackets}
	]];

	(* make an index matching list for the refund status *)
	indexMatchedRefundStatus=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{refundStatus, allFulfilledInstrumentResourcePackets}
	]];

	(* get all the instrument resource packets and modelInstrument packets flattened out *)
	flatInstResourcePackets=Flatten[allFulfilledInstrumentResourcePackets];
	flatModelInstPackets=Flatten[allFulfilledModelInstrumentPackets];

	(* get the pricing rate for all the model instruments, the amount of time used for each resource, the pricing category, and the instrument objects themselves *)

	(* set up small error tracking list *)
	missingBillsQ = {};

	(*this code currently straddles the old system, where the pricing was inherited from the instrument model directly,
	and the new system, where the pricing is in the Object[Bill] associated to each financing team*)
	pricingRate=MapThread[
		Function[{refundedQ, dateCompleted, modelInstrumentPacket, billPacket},
			(*we check if the protocol finished before or after the pricing system date*)
			Which[
				(*we don't charge for refunded protocols*)
				refundedQ, 0 USD / Hour,

				(*if this completed before the pricing system switch, then there's no Object.Bill to associate to*)
				dateCompleted < $PriceSystemSwitchDate,
				Lookup[modelInstrumentPacket, PricingRate],

				(*if it's after the switch, then we'll want to do it based of the PricingLevel*)
				True,
				If[MatchQ[Lookup[modelInstrumentPacket, PricingLevel], _Integer] && MatchQ[billPacket, PacketP[]],
					ReplaceAll[
						Lookup[modelInstrumentPacket, PricingLevel],
						Map[
							Rule @@ #&,
							Lookup[billPacket, InstrumentPricing]
						]
					],

					(* if we don't have a bill, use PricingRate field from the Instrument *)
					AppendTo[missingBillsQ, True]; Lookup[modelInstrumentPacket, PricingRate]
				]
			]
		],
		{
			indexMatchedRefundStatus,
			indexMatchedDateCompleted,
			flatModelInstPackets,
			indexMatchedBills
		}
	];


	(* throw an error if we don't have pricing info for some of the entries that should be priced based on the financing Model *)
	If[Length[missingBillsQ]>0, Message[Pricing::NoPricingInfo]];

	(* note that if we have an estimated time, just use that estimated time; if we have no estimated time but a real time, then divide the total time by 2, and if neither, use Null *)
	(* note that this also depends on the Time option, where we are going to divide by 2 if we want to use EstimatedTime but don't actually have it *)
	timeUsed=Map[
		Which[
			MatchQ[timeSource, Automatic] && (MatchQ[Lookup[#, EstimatedTime], UnitsP[Minute]] || MatchQ[Lookup[#, Time], UnitsP[Minute]]), Min[DeleteCases[Lookup[#, {Time, EstimatedTime}], Null]],
			MatchQ[timeSource, Time], Lookup[#, Time],
			MatchQ[timeSource, EstimatedTime] && MatchQ[Lookup[#, EstimatedTime], UnitsP[Minute]], Lookup[#, EstimatedTime],
			MatchQ[timeSource, EstimatedTime] && MatchQ[Lookup[#, Time], UnitsP[Minute]], Lookup[#, Time] / 2.,
			True, Null
		]&,
		flatInstResourcePackets
	];
	pricingCategory=Lookup[flatModelInstPackets, PricingCategory, {}];
	pricingLevel=Lookup[flatModelInstPackets, PricingLevel, {}];
	instObjs=Download[Lookup[flatInstResourcePackets, Instrument, {}], Object];

	(* get the instruments that don't have any pricing information *)
	nullInstruments=PickList[instObjs, pricingLevel, Null];

	(* if there are any instruments that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullInstruments, {}]],
		Message[PriceInstrumentTime::MissingPricingLevel, nullInstruments]
	];

	(* get the price for each entry; if Time is Null for a given resource, then that protocol is not yet completed, and so we will use Null here *)
	pricing=MapThread[
		If[NullQ[#1] || NullQ[#2],
			Null,
			#1 * #2
		]&,
		{pricingRate, timeUsed}
	];

	(* get the model names of all the instruments *)
	modelInstNames=Lookup[flatModelInstPackets, Name, {}];

	(* lookup the site for each protocol *)
	indexMatchedSites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,myProtocolPackets],
				Site],
			Object]&,
		indexMatchedProtocols];

	(* return the info required to make the price tables *)
	{indexMatchedNotebooks, indexMatchedProtocols, indexMatchedDateCompleted, instObjs, modelInstNames, UnitScale[timeUsed, Simplify -> False], pricingRate, pricing, pricingCategory, pricingLevel, indexMatchedSites}
];




(* ::Subsection:: *)
(*PriceOperatorTime*)

Authors[PriceOperatorTime]={"alou", "robert", "dima"};


(* ::Subsubsection::Closed:: *)
(*PriceOperatorTime*)


DefineOptions[PriceOperatorTime,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching OperatorPriceTableP with the same information, or a combined price of all instrument costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | OperatorPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing and timing information by Notebook, Protocol, Operator Model, or not at all.",
			Category -> "General"
		},
		{
			OptionName -> Time,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> EstimatedTime | Time | Automatic],
			Description -> "Determines whether the price provided is based on the Estimated or actual amount of time used.",
			ResolutionDescription -> "Automatically picks the smaller time between Estimated and a real time.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceOperatorTime::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus pricing from instrument time cannot be calculated: `1`.  Please wait until these protocols are completed and then call this function again.";
PriceOperatorTime::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`.  These protocols' prices are already included in the price of their parent protocols.  Please provide only completed parent protocols to the inputs of PriceOperatorTime.";

(* singleton Protocol overload *)
PriceOperatorTime[myProtocol:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceOperatorTimeCore[{myProtocol}, Null, ops];

(* reverse listable Core Protocol overload *)
(* also the empty list overload *)
PriceOperatorTime[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceOperatorTimeCore[myProtocols, Null, ops];

(* singleton Notebook overload with no date range *)
PriceOperatorTime[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceOperatorTime[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* singleton Notebook overload with date range *)
PriceOperatorTime[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceOperatorTime[{myNotebook}, myDateRange, ops];

(* reverse listable Notebook overload with no date range *)
PriceOperatorTime[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceOperatorTime[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* core function featuring reverse listable Notebook overload with date span *)
PriceOperatorTime[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, sortedDateRange, alternativesNotebooks, allProtocols, startDate, endDate, endDateWithTime},

	(* get the safe options *)
	safeOps=SafeOptions[PriceOperatorTime, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	(* warm up the DB *)
	Quiet[Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False,
		MaxResults->False
	]];
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceOperatorTimeCore[allProtocols, myDateRange, safeOps]

];

(* Singleton Team overload with no date range *)
PriceOperatorTime[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceOperatorTime[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* singleton Team overload with date range *)
PriceOperatorTime[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceOperatorTime[{myTeam}, myDateRange, ops];

(* reverse listable Team overload with no date range*)
PriceOperatorTime[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceOperatorTime[myTeams, Span[Now, Now - 1 * Month], ops];

(* reverse listable Core Team overload with date range *)
PriceOperatorTime[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, sortedDateRange, alternativesTeams, allNotebooks, endDateWithTime, allProtocols, alternativesNotebooks, startDate, endDate},

	(* get the safe option *)
	safeOps=SafeOptions[PriceOperatorTime, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		(* warm up the DB *)
		Quiet[Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]];
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceOperatorTimeCore[allProtocols, myDateRange, safeOps]

];


(* ::Subsubsection::Closed:: *)
(*priceOperatorTimeCore (private)*)


(*
	Private helper that creates the table for operator time; all PriceOperatorTime overloads point at this

	Input:
		1.) list of protocols
		2.) Date range specified (or Null)

	Output:
		A table, list of associations, or a single price
*)

(* core function that all PriceOperatorTime overloads call *)
priceOperatorTimeCore[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]), ops:OptionsPattern[]]:=Module[
	{
		safeOps,output,consolidation,cache,now,
		allDownloadValues,protocolPackets,tsReportPackets,allResourcePackets,operatorModelPackets,
		pricingLists,notebooks,protocols,datesCompleted,operatorObjects,modelOperatorNames,usageTimes,pricingRates,pricings,
		totalPrice,allDataTable,dataTableDateCompleted,associationOutput,noNotebookDataTable,noProtocolDataTable,
		gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,
		gatheredByProtocol,protocolConsolidatedPreTotal,protocolConsolidatedTotals,protocolConsolidatedTable,
		gatheredByOperatorModel,operatorConsolidatedPreTotal,operatorConsolidatedTotals,operatorConsolidatedTable,
		numNotebooks,numProts,dataTableToUse,subtotalRows,columnHeaders,singleTableTitle,dataWithSubtotal,tableOutput,
		startDate,endDate,timeSource,objectBillPackets,operatorModelPacketsFromObject,
		requestedUserObjectPositions,requestedUserObjectModelPackets,objectModelReplacementRules,finalOperatorModelPackets,sites},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceOperatorTime, ToList[ops]];
	{output, consolidation, cache, timeSource}=Lookup[safeOps, {OutputFormat, Consolidation, Cache, Time}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		With[{sortedDateRange=Sort[TimeZoneConvert[List@@myDateRange, $TimeZone]]},{First[sortedDateRange], Last[sortedDateRange]}]
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* Download the information about the the instruments used by this protocol and all its subs, the pricing rates of those instruments, the name of the models of these instruments, and the notebook of the protocol *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not instrument resources and we need to distinguish these cases *)
	allDownloadValues=Quiet[
		Download[
			myProtocols,
			{
				Packet[Notebook, ParentProtocol, Status, DateCompleted, Priority, Site],
				Packet[UserCommunications[Refund]],
				Packet[SubprotocolRequiredResources[{Time, EstimatedTime, Operator, Status}]],
				Packet[SubprotocolRequiredResources[RequestedOperators][{Name, QualificationLevel}]],
				Packet[SubprotocolRequiredResources[RequestedOperators][Model][{Name, QualificationLevel}]],
				Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, OperatorTimePrice, OperatorPriorityTimePrice, Site}]]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* slice out the individual downloaded lists for passing to core private helper *)
	protocolPackets=allDownloadValues[[All, 1]];
	tsReportPackets=allDownloadValues[[All, 2]];
	allResourcePackets=allDownloadValues[[All, 3]];
	operatorModelPackets=allDownloadValues[[All, 4]];
	operatorModelPacketsFromObject=allDownloadValues[[All, 5]];
	objectBillPackets=allDownloadValues[[All, 6]];

	(* if we have ever requested Object for Operator, convert to packet for a Model *)
	requestedUserObjectPositions = Position[operatorModelPackets, PacketP[Object[User]]];
	requestedUserObjectModelPackets =  operatorModelPacketsFromObject[[Sequence @@ #]] & /@ requestedUserObjectPositions;
	objectModelReplacementRules = Rule @@@ Transpose@{requestedUserObjectPositions, requestedUserObjectModelPackets};
	finalOperatorModelPackets = ReplacePart[operatorModelPackets, objectModelReplacementRules];

	(* get the info required for pricing table generation from a core helper; might return a failure *)
	pricingLists=priceOperatorTimeProtocols[
		protocolPackets,
		tsReportPackets,
		allResourcePackets,
		finalOperatorModelPackets,
		objectBillPackets,
		Time -> timeSource
	];
	If[MatchQ[pricingLists, $Failed],
		Return[$Failed]
	];

	(* get the info required for pricing table generation from a core helper *)
	{notebooks, protocols, datesCompleted, operatorObjects, modelOperatorNames, usageTimes, pricingRates, pricings, sites}=pricingLists;

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[pricings, Null], {}],
		0 * USD,
		Total[DeleteCases[pricings, Null]]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, operator, operatorModel, time, rate, price, site},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, operator, operatorModel, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, operator, operatorModel, time, rate, price}
			]
		],
		{notebooks, protocols, operatorObjects, modelOperatorNames, usageTimes, pricingRates, pricings, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, time, rate},
			If[NullQ[time] || NullQ[rate],
				Nothing,
				date
			]
		],
		{datesCompleted, usageTimes, pricingRates}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match OperatorPriceTableP *)
	associationOutput=Map[
		AssociationThread[{DateCompleted, Notebook, Source, Site, Operator, ModelName, Time, PricePerHour, Price}, #]&,
		MapThread[Join[{#1}, #2]&, {dataTableDateCompleted, allDataTable}]
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, operator, operatorModel, time, rate, price, site},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {protocol, site, operator, operatorModel, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {protocol, site, operator, operatorModel, time, rate, price}
			]
		],
		{protocols, operatorObjects, modelOperatorNames, usageTimes, pricingRates, pricings, sites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{operator, operatorModel, time, rate, price},
			Switch[{time, rate, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {operator, operatorModel, NumberForm[time, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {operator, operatorModel, time, rate, price}
			]
		],
		{operatorObjects, modelOperatorNames, usageTimes, pricingRates, pricings}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)
	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call. Remove any elements fro which there is no pricing rate *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 7]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* group all the rows in the data table by instrument model *)
	gatheredByOperatorModel=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by instrument, before we do the Total call *)
	operatorConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByOperatorModel
	];

	(* get the total for each instrument *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	operatorConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		operatorConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	operatorConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{operatorConsolidatedPreTotal, operatorConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[notebooks]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Protocol, _, _}, protocolConsolidatedTable,
		{Operator, _, _}, operatorConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Protocol | Operator, _, _}, {{"", ""}, {"Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", "", "", ""}, {"", "", "", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", "", "", "", ""}, {"", "", "", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Notebook", "Price"},
		{Protocol, _, _}, {"Protocol", "Price"},
		{Operator, _, _}, {"Operator Model Name", "Price"},
		{_, 1, 1}, {"Operator Object", "Model Name", "Time Used", "Price (per hour)", "Price"},
		{_, 1, _}, {"Protocol", "Site", "Operator Object", "Model Name", "Time Used", "Price (per hour)", "Price"},
		{_, _, _}, {"Notebook", "Protocol", "Site", "Operator Object", "Model Name", "Time Used", "Price (per hour)", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Operator Time Pricing",
		StringJoin["Operator Time Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalPrice
	]
];



(* ::Subsubsection::Closed:: *)
(*priceOperatorTimeProtocols (private)*)


(*
	Private helper that does the core calculating for PriceOperatorTime based on protocols and their associated instrument UsageFrequency
		- determines amount of time each instrument resource was used
		- uses pricing rate to calculate price
		- NOTE: also called directly by priceTransactionsToUser in PriceTransactions

	Input:

	Output:
	{indexMatchedNotebooks, indexMatchedProtocols, operatorObjects, modelOperatorNames, UnitScale[timeUsed, Simplify -> False], pricingRate, pricing}
*)

DefineOptions[priceOperatorTimeProtocols,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for operator time pricing."},
		{Time -> EstimatedTime, EstimatedTime | Time | Automatic, "Determines whether the price provided is based on the Estimated or actual amount of time used.", Category -> Hidden}
	}
];

priceOperatorTimeProtocols[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myResourcePackets:{{PacketP[Object[Resource]]...}...},
	myOperatorModelPackets:{{({PacketP[Model[User]]} | $Failed | Null)...}...},
	myObjectBillPackets:{
		({
			({PacketP[Object[Bill]]...} | $Failed | Null)...
		} | Null)...
	},
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,allowSubprotocolsQ,refundStatus,priorityBool,nonRefundedProtPackets,protocolObjects,
		protocolNotebooks,allOperatorResourcePackets,allModelOperatorPackets,allOperatorResourceStatuses,
		allFulfilledOperatorResourcePackets,allFulfilledModelOperatorPackets,subprotocols,notCompletedProts,
		billForEachProtocol,indexMatchedBills,qualificationLevel,indexMatchedRefundStatus,indexMatchedPriorityBool,
		indexMatchedNotebooks,indexMatchedProtocols,indexMatchedDateCompleted,flatOperatorResourcePackets,flatModelOperatorPackets,
		pricingRate,timeUsed,operatorObjects,pricing,modelOperatorNames,timeSource,missingBillsQ,indexMatchedSites},

	(* get safe options *)
	safeOptions=SafeOptions[priceOperatorTimeProtocols, ToList[myOptions]];
	{allowSubprotocolsQ, timeSource}=Lookup[safeOptions, {AllowSubprotocols, Time}];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* get the priority of each inputted protocol, making sure that it is a boolean *)
	priorityBool=Map[
		MatchQ[Lookup[#, Priority], True]&,
		myProtocolPackets
	];

	(* get all the non-refunded protocol packets *)
	nonRefundedProtPackets=PickList[myProtocolPackets, refundStatus, False];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[myProtocolPackets, Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets, Notebook, {}], Object];

	(* get all the operator resource packets that were used *)
	(* this is a list of lists that is index matched with the input protocols *)
	allOperatorResourcePackets=Map[
		Cases[#, PacketP[Object[Resource, Operator]]]&,
		myResourcePackets
	];

	(* get all the model operator packets *)
	(* this is a list of lists that is index matched with the input protocols *)
	(* each nested list is index matched with the operator resource above *)
	allModelOperatorPackets=MapThread[
		Flatten[PickList[#2, #1, PacketP[Object[Resource, Operator]]]]&,
		{myResourcePackets, myOperatorModelPackets}
	];

	(* get the status of all the instrument resource packets *)
	allOperatorResourceStatuses=Lookup[#, Status, {}]& /@ allOperatorResourcePackets;

	(* get only the fulfilled instrument resource packets *)
	allFulfilledOperatorResourcePackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allOperatorResourcePackets, allOperatorResourceStatuses}
	];

	(* get the instrument models of only the fulfilled operator resources *)
	allFulfilledModelOperatorPackets=MapThread[
		Cases[PickList[#1, #2, Fulfilled], PacketP[Model[User, Emerald, Operator]]]&,
		{allModelOperatorPackets, allOperatorResourceStatuses}
	];

	(* -------------------- *)
	(* -- Error tracking -- *)
	(* -------------------- *)

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceOperatorTime::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceOperatorTime::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket, billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList[billList]],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], Status -> Open, DateCompleted -> Null, Site->LinkP[Download[Lookup[eachProtocolPacket,Site],Object]]}],
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], DateCompleted -> GreaterEqualP[Lookup[eachProtocolPacket, DateCompleted]], Site->LinkP[Download[Lookup[eachProtocolPacket,Site],Object]]}]
				],
				(*indicate if we couldn't find a bill*)
				NoBillFound
			]
		],
		{
			myProtocolPackets,
			myObjectBillPackets
		}
	];

	(* get the notebook index matched with the rest *)
	indexMatchedNotebooks=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{protocolNotebooks, allFulfilledOperatorResourcePackets}
	]];

	(* get the protocol index matched with the rest *)
	indexMatchedProtocols=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, Object, {}], allFulfilledOperatorResourcePackets}
	]];

	(* get the protocol's date completed matched with the rest *)
	indexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, DateCompleted, {}], allFulfilledOperatorResourcePackets}
	]];

	(* make an index matching list for the bills *)
	indexMatchedBills=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{billForEachProtocol, allFulfilledOperatorResourcePackets}
	]];

	(* make an index matching list for the refund status *)
	indexMatchedRefundStatus=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{refundStatus, allFulfilledOperatorResourcePackets}
	]];

	(* make an index matching list for the priority bool *)
	indexMatchedPriorityBool=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{priorityBool, allFulfilledOperatorResourcePackets}
	]];

	(* get all the operator resource packets and model operator packets flattened out *)
	flatOperatorResourcePackets=Flatten[allFulfilledOperatorResourcePackets];
	flatModelOperatorPackets=Flatten[allFulfilledModelOperatorPackets];

	(* get the pricing rate for all the model operator, the amount of time used for each resource, the pricing category, and the instrument objects themselves *)

	(*set up error tracking list*)
	missingBillsQ = {};

	(*this code currently straddles the old system, where the pricing was inherited from the instrument model directly,
	and the new system, where the pricing is in the Object[Bill] associated to each financing team*)
	pricingRate=MapThread[
		Function[{refundQ, priorityQ, dateCompleted, modelOperatorPacket, billPacket},
			(*we check if the protocol finished before or after the pricing system date*)
			Which[
				(* if it was refunded, no charge *)
				refundQ,
				0 USD / Hour,

				(* if it was competed prior to the switch date, there will be no bill *)
				(* we are using one price for all qualification levels of the operators *)
				dateCompleted < $PriceSystemSwitchDate,
				25 USD / Hour,

				(*make another switch here for priority vs non priority*)
				(*if it's after the switch, then we'll want to do it based of the PricingLevel*)
				priorityQ,
				If[MatchQ[Lookup[modelOperatorPacket, QualificationLevel], _Integer] && MatchQ[billPacket, PacketP[]],
					ReplaceAll[
						Lookup[modelOperatorPacket, QualificationLevel, {}] /. {x:_Integer :> 1},
						Map[
							Rule @@ #&,
							Lookup[billPacket, OperatorPriorityTimePrice]
						]
					],
					(*this shouldn't happen but it will have already warned us and it can be reconciled*)
					Append[missingBillsQ, True];0 USD / Hour
				],

				True,
				If[MatchQ[Lookup[modelOperatorPacket, QualificationLevel], _Integer] && MatchQ[billPacket, PacketP[]],
					ReplaceAll[
						Lookup[modelOperatorPacket, QualificationLevel, {}] /. {x:_Integer :> 1},
						Map[
							Rule @@ #&,
							Lookup[billPacket, OperatorTimePrice]
						]
					],
					(*this shouldn't happen but it will have already warned us and it can be reconciled*)
					Append[missingBillsQ, True];0 USD / Hour
				]

			]
		],
		{
			indexMatchedRefundStatus,
			indexMatchedPriorityBool,
			indexMatchedDateCompleted,
			flatModelOperatorPackets,
			indexMatchedBills
		}
	];

	(* throw and error if we don't have bill info for some entries *)
	If[Length[missingBillsQ]>1,Message[Pricing::NoPricingInfo]];

	(* note that if we have an estimated time, just use that estimated time; if we have no estimated time but a real time, then divide the total time by 2, and if neither, use Null *)
	(* note that this also depends on the Time option, where we are going to divide by 2 if we want to use EstimatedTime but don't actually have it *)

	timeUsed=Map[
		Which[
			(* automatically grab the lowest number between Time and EstimatedTime in case both are populated *)
			MatchQ[timeSource, Automatic] && (MatchQ[Lookup[#, EstimatedTime], UnitsP[Minute]] && MatchQ[Lookup[#, Time], UnitsP[Minute]]), Min[DeleteCases[Lookup[#, {Time, EstimatedTime}], Null]],
			MatchQ[timeSource, Automatic] && (NullQ[Lookup[#, EstimatedTime]] && MatchQ[Lookup[#, Time], UnitsP[Minute]]), Lookup[#, Time] / 2.,
			MatchQ[timeSource, Time], Lookup[#, Time],
			MatchQ[timeSource, EstimatedTime] && MatchQ[Lookup[#, EstimatedTime], UnitsP[Minute]], Lookup[#, EstimatedTime],
			MatchQ[timeSource, EstimatedTime] && MatchQ[Lookup[#, Time], UnitsP[Minute]], Lookup[#, Time] / 2.,
			True, Null
		]&,
		flatOperatorResourcePackets
	];


	qualificationLevel=Lookup[flatModelOperatorPackets, QualificationLevel, {}];
	operatorObjects=Download[Lookup[flatOperatorResourcePackets, Operator, {}], Object];

	(* get the price for each entry; if Time is Null for a given resource, then that protocol is not yet completed, and so we will use Null here *)
	pricing=MapThread[
		If[NullQ[#1] || NullQ[#2],
			Null,
			#1 * #2
		]&,
		{pricingRate, timeUsed}
	];

	(* get the model names of all the instruments *)
	modelOperatorNames=Lookup[flatModelOperatorPackets, Name, {}];

	(* lookup the site for each protocol *)
	indexMatchedSites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,myProtocolPackets],
				Site],
			Object]&,
		indexMatchedProtocols];

	(* return the info required to make the price tables *)
	{indexMatchedNotebooks, indexMatchedProtocols, indexMatchedDateCompleted, operatorObjects, modelOperatorNames, UnitScale[timeUsed, Simplify -> False], pricingRate, pricing, indexMatchedSites}
];




(* ::Subsection:: *)
(*PriceMaterials*)

Authors[PriceMaterials]={"andrey.shur", "lei.tian", "jihan.kim", "dima", "alou"};


(* ::Subsubsection::Closed:: *)
(*PriceMaterials*)


DefineOptions[PriceMaterials,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching MaterialsPriceTableP with the same information, or a combined price of all materials costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | MaterialsPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Source, Material, or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceMaterials::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus pricing for materials used cannot be calculated: `1`. Please wait until these protocols are completed and then call this function again.";
PriceMaterials::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`. These protocols' prices are already included in the price of their parent protocols. Please provide only completed parent protocols to the inputs of PriceMaterials.";
PriceMaterials::MissingProductInformation="The following materials are not associated with a product, or if a stock solution do not have Price populated in the model and thus do not have pricing information available: `1`. These materials have been filtered out of the displayed results.";
PriceMaterials::SiteNotFound="The site at which the protocol `1` was run could not be determined. Please provide only completed protocols that are passing ValidObjectQ.";

(* Singleton Protocol/Transaction overload *)
PriceMaterials[mySource:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification], Object[Transaction, Order]}], ops:OptionsPattern[]]:=PriceMaterials[{mySource}, ops];

(* Listed Protocol/Transaction (and empty list), substitute  transactions that were fulfilled internally with StockSolution/SampleManipulation by their protocols *)
PriceMaterials[mySources:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification], Object[Transaction, Order]}]...}, ops:OptionsPattern[]]:=Module[
	{allTransactions, orderData, fulfillmentProtocols, allSources, sourcesFiltered, internalFullfilmentOrders},

	(* separate orders *)
	allTransactions=Cases[mySources, ObjectP[Object[Transaction, Order]]];

	(* get information to check that they are fulfillment internal orders *)
	orderData=Download[allTransactions, {Object, InternalOrder, Fulfillment}];

	(* grab fulfillment protocols - we would price those instead *)
	fulfillmentProtocols=Download[DeleteCases[Flatten[orderData[[All, 3]]], Null], Object];

	(* separate internal fullfilment orders from the rest *)
	internalFullfilmentOrders=Cases[orderData, _?(MatchQ[#[[2;;3]], {True, {ObjectP[{Object[Protocol, StockSolution], Object[Protocol, SampleManipulation]}]..}}]&)][[All, 1]];
	sourcesFiltered=DeleteCases[mySources, Alternatives @@ internalFullfilmentOrders];

	allSources=Flatten[{fulfillmentProtocols, sourcesFiltered}];
	priceMaterialsCore[allSources, Null, Null, Null, ops]
];


(* Singleton Notebook overload with no date range *)
PriceMaterials[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceMaterials[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* Singleton Notebook overload with date range *)
PriceMaterials[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceMaterials[{myNotebook}, myDateRange, ops];

(* Reverse listable Notebook overload with no date range *)
PriceMaterials[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceMaterials[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Notebook overload with date range ---> Passes to CORE helper function *)
PriceMaterials[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, alternativesNotebooks, sortedDateRange, startDate, endDate, endDateWithTime, allProtocols, allCorrectOrders, allSources},

	(* get the safe options *)
	safeOps=SafeOptions[PriceMaterials, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols and received transaction orders in these notebooks *)
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* allTransactions = Search[{Object[Transaction,Order],Object[Transaction,DropShipping],Object[Transaction,ShipToECL]}, Status == Received && Notebook == alternativesNotebooks && DateDelivered > startDate && DateDelivered < endDateWithTime]; *)
	(* THIS IS A TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTION CURRENTLY *)
	allCorrectOrders=Search[
		{Object[Transaction, Order]},
		Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* join all transaction orders and protocols *)
	allSources=Join[allProtocols, allCorrectOrders];

	(* pass all the sources (transactions and protocols) found in these notebooks to the core function *)
	priceMaterialsCore[allSources, startDate, endDateWithTime, now, safeOps]

];


(* Singleton Team overload with no date range *)
PriceMaterials[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceMaterials[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* Singleton Team overload with date range *)
PriceMaterials[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceMaterials[{myTeam}, myDateRange, ops];

(* Reverse listable Team overload with no date range*)
PriceMaterials[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceMaterials[myTeams, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Team overload with date range ---> Passes to CORE helper function *)
PriceMaterials[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, alternativesTeams, sortedDateRange, allNotebooks, allProtocols, allCorrectOrders, allSources,
		alternativesNotebooks, startDate, endDateWithTime, endDate},

	(* get the safe options *)
	safeOps=SafeOptions[PriceMaterials, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the completed parent protocols and delivered transaction orders in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* allTransactions = Search[{Object[Transaction,Order],Object[Transaction,DropShipping],Object[Transaction,ShipToECL]}, Status == Received && Notebook == alternativesNotebooks && DateDelivered > startDate && DateDelivered < endDateWithTime]; *)
	(* THIS IS A TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTION CURRENTLY *)
	allCorrectOrders=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Transaction, Order]},
			Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* Join all protocols and transaction orders *)
	allSources=Join[allProtocols, allCorrectOrders];

	(* pass all the sources (transactions and protocols) found in these notebooks to the core function *)
	priceMaterialsCore[allSources, startDate, endDateWithTime, now, safeOps]

];


(* ::Subsubsection::Closed:: *)
(* priceMaterialsCore (private) *)


(* --- CORE HELPER FUNCTION --- *)

(* This function is called by the the reverse-listable Protocol/Transaction, Notebook, and Team overloads *)
(* It uses priceMaterialsProtocols and priceMaterialsTransactionOrder helper functions to gather product/tax pricing information from protocols and transaction orders and then produces an output formate displaying the combined pricing information *)
(* The inputs are lists of protocols and transaction orders, and start and end date (or Null if called by the Protocol/Transaction overlaod) *)
(* The output is (depending on the OutputFormat option) either an association matching MaterialsPriceTableP or a table displaying the pricing information (such as notebook, samples, names, prices, etc.), or a total price of the materials *)

priceMaterialsCore[
	mySources:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification], Object[Transaction, Order]}]...},
	myStartDate:(Null | _?DateObjectQ),
	myEndDate:(Null | _?DateObjectQ),
	myNow:(Null | _?DateObjectQ),
	ops:OptionsPattern[]
]:=Module[
	{
		safeOps, output, cache, consolidation, allProtocols, allTransactionsOrders,
		allProtocolValues, allTransactionValues,
		uniqueModels, uniqueProducts, uniqueContainers, uniqueSites, uniqueDefaultContainers,
		allProtocolsDownloadPacketsRaw, packetRulesProtocols, resourceProducts,
		protocolPackets, resourcePackets, resourceProductPackets,
		resourceSamplePackets, resourceSampleModelPackets, resourceSampleContainerModelPackets, resourceContainerModelPackets, defaultStorageConditionPackets,
		containerResourcePackets, siteModelPackets, troubleshootingReportPackets, outputTransactionsOrders, outputProtocols, joinedAmounts, joinedPricingRate, joinedPrice, joinedDate, joinedTags,
		joinedNotebooks, joinedSources, joinedSamples, joinedNames, joinedNamesNoNull, outputListsSortedBySources, outputListsSortedByMaterials, pricingOutputOrderPriority,
		outputListsSortedByPricing, sortedNotebooks, sortedSources, sortedSamples, sortedNames, sortedAmounts, sortedPricingRate, sortedPrice, sortedDate,
		sortedTags, transposedOutputs, allDataTable, associationDataTable, associationOutput, tableOutput, noNotebookDataTable, noProtocolDataTable,
		gatheredByNotebook, notebookConsolidatedPreTotal, notebookConsolidatedTotals, notebookConsolidatedTable, gatheredByProtocol, protocolConsolidatedPreTotal,
		protocolConsolidatedTotals, protocolConsolidatedTable, gatheredByMaterial, materialConsolidatedPreTotal, materialConsolidatedTotals, materialConsolidatedTable,
		numNotebooks, numProts, dataTableToUse, totalInputPrice, subtotalRows, dataWithSubtotal, columnHeaders, dataTableDateCompleted, tableTitle,
		sortedFlattenedData, filteredResourceSampleContentsPackets, joinedSite, sortedSite,

		(* error checking *)
		likelyNoAccessObjects, veryLikelyNoAccessObjects, noAccessObjectPositions,
		filteredResourcePackets, filteredResourceSamplePackets, filteredModels, filteredContainers, filteredDefaultContainers,
		processedModels, fastAssoc
	},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceMaterials, ToList[ops]];
	{output, consolidation, cache}=Lookup[safeOps, {OutputFormat, Consolidation, Cache}];

	(* split the input by protocols and transactions *)
	allProtocols=Cases[mySources, ObjectP[{Object[Protocol]}]];
	allTransactionsOrders=Cases[mySources, ObjectP[{Object[Transaction, Order]}]];

	(* download all the information from the transactions and protocols) *)
	(* for the protocols, download the information about the notebook and status of the protocol, the resources used by this protocol and all its subs (including the amount that was used), and the price information of the corresponding products *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not sample resources and we need to distinguish these cases *)
	(* for the transactions, download the information about the notebook and status of the protocol, the price and quantity and the model of its associated samples*)
	{allProtocolValues, allTransactionValues}=Quiet[
		Download[
			{allProtocols, allTransactionsOrders},
			{
				{
					Packet[Notebook, ParentProtocol, Status, DateCompleted, Author, Site],
					Packet[UserCommunications[Refund]],
					Packet[SubprotocolRequiredResources[{Status, Amount, Purchase, Sample, Requestor, RootProtocol}]],
					Packet[SubprotocolRequiredResources[Sample][{Product, KitComponents, Model, Contents}]],
					Packet[OrdersFulfilled[UserCommunications][Refund]],
					SubprotocolRequiredResources[Models][Object],
					SubprotocolRequiredResources[ContainerResource][Sample][Model][Object],
					Site[Object],
					SubprotocolRequiredResources[Sample][Product][DefaultContainerModel][Object],
					Packet[SubprotocolRequiredResources[Sample][Contents][[All, 2]][{Product, KitComponents, Model}]],
					Packet[SubprotocolRequiredResources[Sample][Model][{ProductsContained, KitProductsContainers}]]
				},
				{
					(* these are transaction order specific fields*)
					Packet[Products[ProductModel][{State, Name, DefaultStorageCondition, Tablet}]],
					Packet[Products, Models, InternalOrder, OrderQuantities (*new *), SupplierOrder],
					Packet[Products[{NumberOfItems, Price, UsageFrequency, DefaultContainerModel, ProductModel, Name}]],
					Packet[Destination[Model][SalesTaxRate]],
					Packet[SupplierOrder[Notebook]],
					(* these are transaction common fields *)
					Packet[Destination, Notebook, Status, DateDelivered, Fulfillment],
					Packet[UserCommunications[Refund]]
				}
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::Part}];


	(* very important: we need to validate that all our packets are in order. using any invalid packets we should be able to implicitly determine whether the user has access to certain objects *)
	(* the easiest way to identify a malformed packet where we don't have access to the requested object seems to be to search for an object packet wherein Model -> $Failed, since all Objects have a Model field *)
	likelyNoAccessObjects=Lookup[Flatten@Cases[allProtocolValues, KeyValuePattern[{Object -> ObjectP[], Model -> $Failed}], All], Object, {}];

	(* verify any objects that clearly exist but are not database members *)
	veryLikelyNoAccessObjects=PickList[likelyNoAccessObjects, DatabaseMemberQ[likelyNoAccessObjects], False];

	(* if we have any objects that meet these criterion, throw an error and return $Failed instead of trying to proceed, since these objects will pass broken packets in the code below.
	 if we'd like to change this to a warning by culling all the broken objects, this IS possible, but it's not going to make sense from a pricing perspective. *)
	If[Length[veryLikelyNoAccessObjects] > 0,
		Message[Warning::PricingObjectsArePrivate, veryLikelyNoAccessObjects]
	];

	(* determine the positions of the packets that we need to remove. packets and downloads in allProtocolValues positions {3,4,6,7,9} are index matched (by SubprotocolRequiredResources), so use the objects packets to pick which of these resources to ignore as a result of lack of access *)
	noAccessObjectPositions=Position[allProtocolValues[[All, 4]], KeyValuePattern[Object -> Alternatives @@ veryLikelyNoAccessObjects]];

	(*make sure that we have flat lists for the models with Nulls to keep index matching - replace any {} with Null*)
	processedModels=Map[FirstOrDefault[#, Null]&, allProtocolValues[[All, 6]], {2}];

	{filteredResourcePackets, filteredResourceSamplePackets, filteredModels, filteredContainers, filteredDefaultContainers, filteredResourceSampleContentsPackets} = Delete[#, noAccessObjectPositions]& /@ {allProtocolValues[[All, 3]], allProtocolValues[[All, 4]], processedModels, allProtocolValues[[All, 7]], allProtocolValues[[All, 9]], allProtocolValues[[All, 10]]};

	(* reduce the number of Models/Products we will be downloading packets for *)
	uniqueModels=DeleteDuplicates@Cases[filteredModels, ObjectReferenceP[], Infinity];
	uniqueProducts=DeleteDuplicates[Flatten[{
		Cases[Lookup[Cases[filteredResourceSamplePackets, PacketP[], Infinity], Product], x:LinkP[] :> Download[x, Object]],
		Cases[Lookup[Cases[filteredResourceSampleContentsPackets, PacketP[], Infinity], Product], x:LinkP[] :> Download[x, Object]]
	}]];
	uniqueContainers=DeleteDuplicates@Cases[filteredContainers, ObjectReferenceP[], Infinity];
	uniqueSites=DeleteDuplicates@Cases[allProtocolValues[[All, 8]], ObjectReferenceP[]];
	uniqueDefaultContainers=DeleteDuplicates@Cases[filteredDefaultContainers, ObjectReferenceP[], Infinity];

	allProtocolsDownloadPacketsRaw=Quiet[
		Download[
			{
				uniqueProducts,
				uniqueModels,
				uniqueDefaultContainers,
				uniqueProducts,
				uniqueModels,
				uniqueContainers,
				uniqueSites
			},
			{
				{Packet[Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel]},
				{Packet[Name, DefaultStorageCondition, Price, Reusability]},
				{Packet[Dimensions]},
				{Packet[ProductModel[Dimensions]]},
				{Packet[DefaultStorageCondition[StockingPrices]]},
				{Packet[Dimensions]},
				{Packet[Model[SalesTaxRate]]}
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::Part}];

	(* combine everything that we downloaded into a fastAssoc *)
	fastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{allProtocolValues, allTransactionValues, allProtocolsDownloadPacketsRaw}]];

	(* covert the packets we got to a list of rules Object->Packet *)
	(* this is a touch ugly, but since we are jumping from Object->Model in a couple of cases this is the most reliable way to do this *)
	packetRulesProtocols=Map[
		Function[{index},
			MapThread[(#1 -> First@ToList@#2)&,
				{
					{
						uniqueProducts,
						uniqueModels,
						uniqueDefaultContainers,
						uniqueProducts,
						uniqueModels,
						uniqueContainers,
						uniqueSites
					}[[index]],
					allProtocolsDownloadPacketsRaw[[index]]
				}
			]
		],
		Range[Length[allProtocolsDownloadPacketsRaw]]];

	(* also, chunk out the index-matched download lists for the protocols for passing to the helper priceMaterialsProtocols *)
	protocolPackets=allProtocolValues[[All, 1]];
	(* we need to combine the TS reports for the protocol as well as for the transaction if this is a fulfillment order *)
	(* we need to do some flattening because of the multiples fields along the way *)
	(* we do not want to handle $Failed later, so let's remove them now and substitute with an empty list *)
	troubleshootingReportPackets=MapThread[
		Flatten[{#1, Flatten[#2]}, 1] &,
		{
			allProtocolValues[[All, 2]],
			ReplaceAll[allProtocolValues[[All, 5]],
				$Failed -> {}]
		}];

	resourcePackets=filteredResourcePackets;
	resourceSamplePackets=filteredResourceSamplePackets;

	(* product for each each Sample in the Resource - structure preserved *)
	resourceProducts = Map[
		Function[{filteredResourceSamplePacket},
			Which[
				MatchQ[filteredResourceSamplePacket, PacketP[]] && MatchQ[Lookup[filteredResourceSamplePacket, Product], ObjectP[]],
					Lookup[filteredResourceSamplePacket, Product, Null] /. x : LinkP[] :> Download[x, Object],
				MatchQ[filteredResourceSamplePacket, PacketP[Object[Container]]],
					Module[{contentsPackets, potentialProduct, containerModelPacket},
						(* first get the packets of the contents inside this container.  Then figure out if those contents have a product *)
						contentsPackets = Experiment`Private`fetchPacketFromFastAssoc[#, fastAssoc]& /@ Lookup[filteredResourceSamplePacket, Contents][[All, 2]];
						potentialProduct = FirstCase[Lookup[contentsPackets, Product, Null], ObjectP[Object[Product]], Null] /. x : LinkP[] :> Download[x, Object];

						(* finally, make sure the container we're considering is the DefaultContainerModel (kit or not) of the product we are considering*)
						containerModelPacket = Experiment`Private`fetchPacketFromFastAssoc[Lookup[filteredResourceSamplePacket, Model], fastAssoc];

						If[MemberQ[Flatten[Lookup[containerModelPacket, {ProductsContained, KitProductsContainers}]], ObjectP[potentialProduct]],
							potentialProduct,
							Null
						]
					],
				MatchQ[filteredResourceSamplePacket, PacketP[]],
					Lookup[filteredResourceSamplePacket, Product, Null],
				True, filteredResourceSamplePacket
			]
		],
		filteredResourceSamplePackets,
		{2}
	];

	(* for each protocol grab the Product and replace it with the packet *)
	resourceProductPackets=resourceProducts /. packetRulesProtocols[[1]];

	(* need to take FirstOrDefault of a list of packets if those exist because otherwise the listedness is going to be broken (since going through links to the Models field in resources makes an extra list even though Models will always have at most one entry)*)
	resourceSampleModelPackets=Map[
		If[MatchQ[#, _List],
			FirstOrDefault[#],
			#
		]&,
		(filteredModels /. (packetRulesProtocols[[2]])),
		{2}
	];
	resourceSampleContainerModelPackets=filteredDefaultContainers /. (packetRulesProtocols[[3]]);
	resourceContainerModelPackets=resourceProducts /. packetRulesProtocols[[4]];

	(* need to take FirstOrDefault of a list of packets if those exist because otherwise the listedness is going to be broken (since going through links to the Models field in resources makes an extra list even though Models will always have at most one entry)*)
	defaultStorageConditionPackets=Map[
		If[MatchQ[#, _List],
			FirstOrDefault[#],
			#
		]&,
		filteredModels /. packetRulesProtocols[[5]],
		{2}
	];
	containerResourcePackets=filteredContainers /. packetRulesProtocols[[6]];
	siteModelPackets=allProtocolValues[[All, 8]] /. packetRulesProtocols[[7]];

	(* get the output lists from priceMaterialsProtocols and outputTransactionsOrders if there are any*)
	(* the output contains the following lists in that exact order: notebooks, sources, objects, names, price-categories, amounts, pricePerUnits, prices, and dates *)
	outputProtocols=If[MatchQ[allProtocolValues, {}],
		{{}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
		priceMaterialsProtocols[
			protocolPackets, troubleshootingReportPackets, resourcePackets, resourceProductPackets, resourceSamplePackets, resourceSampleModelPackets,
			resourceSampleContainerModelPackets, resourceContainerModelPackets, defaultStorageConditionPackets, containerResourcePackets, siteModelPackets
		]
	];

	outputTransactionsOrders=If[MatchQ[allTransactionValues, {}],
		{{}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
		priceMaterialsTransactionOrder[allTransactionValues]
	];

	(* return $Failed if any of the outputs returned as $Failed *)
	(* since we're mapping over several outputs, we need to put Return[$Failed, Module] in order to exit from the Module and not return a list *)
	Map[
		If[MatchQ[#, $Failed],
			Return[$Failed, Module],
			#
		]&,
		{outputProtocols, outputTransactionsOrders}
	];

	(* transpose the outputs such that corresponding lists are grouped together (notebooks with notebooks, objects with objects, etc.) *)
	transposedOutputs=Transpose[{outputProtocols, outputTransactionsOrders}];

	(* extract the individual output lists that will serve as input for the output table *)
	{joinedNotebooks, joinedSources, joinedSamples, joinedNames, joinedTags, joinedAmounts, joinedPricingRate, joinedPrice, joinedDate, joinedSite}=Map[
		Flatten[transposedOutputs[[#]]] &, Range[Length[outputProtocols]]];

	(* add the Model ID instead of the name in case we don't have a Name *)
	joinedNamesNoNull=MapThread[
		If[NullQ[#2],
			ToString[#1[ID]],
			#2
		]&,
		{joinedSources, joinedNames}
	];

	(* transpose all output lists and gather by the sources (joinedSources) *)
	outputListsSortedBySources=GatherBy[Transpose[{joinedSamples, joinedNotebooks, joinedSources, joinedNamesNoNull, joinedTags, joinedAmounts, joinedPricingRate, joinedPrice, joinedDate, joinedSite}], Part[#, 3]&];

	(* gather the protocol-gathered lists by materials (joinedSamples) *)
	outputListsSortedByMaterials=Flatten[Map[GatherBy[#, First] &, outputListsSortedBySources], 1];

	(* define the order in which we want the pricing categories to appear in the output table (within each material) *)
	pricingOutputOrderPriority={"Product List Price", "Product Tax"};

	(* sort the gathered output lists such that the pricing categories are displayed in the desired order *)
	outputListsSortedByPricing=Map[SortBy[#, Position[pricingOutputOrderPriority, #[[5]]]&]&, outputListsSortedByMaterials];

	(* grab the sorted lists and flatten them before filtering *)
	sortedFlattenedData=Map[
		Flatten[outputListsSortedByPricing[[All, All, #]]]&,
		Range[Length[outputProtocols]]
	];

	(* extract the values after filtering our items that are priced by weight/volume but have Amount not in those units *)
	(* we achieve this by checking if units are compatible after inverting price rate and removing USD from it *)
	{sortedSamples, sortedNotebooks, sortedSources, sortedNames, sortedTags, sortedAmounts, sortedPricingRate, sortedPrice, sortedDate, sortedSite}=If[
		MatchQ[sortedFlattenedData, ConstantArray[{}, 10]],
		ConstantArray[{}, 10],
		Transpose[
			DeleteCases[
				Transpose[sortedFlattenedData],
				_?(!CompatibleUnitQ[#[[6]], 1 * USD * Power[#[[7]], -1]]&)
			]
		]
	];

	(* generate the table of items that will be displayed in a table *)
	allDataTable=MapThread[
		Function[{tag, notebook, source, sample, modelname, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				(* delete all the cases where the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {notebook, source, site, sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {notebook, source, site, sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedNotebooks, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedSite}
	];

	(* generate the table of items that will be displayed in an association. Contains additional key with the protocols' DateCompleted and transactions' DateReceived *)
	associationDataTable=MapThread[
		Function[{tag, notebook, source, sample, modelname, amount, rate, price, dateCompleted, site},
			Switch[{amount, rate},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _}, Nothing,
				{_, Null}, Nothing,
				{_, _}, {notebook, source, site, sample, modelname, tag, amount, rate, price, dateCompleted}
			]
		],
		{sortedTags, sortedNotebooks, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedDate, sortedSite}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null amount or pricing rate removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, amount, rate},
			If[NullQ[amount] || NullQ[rate],
				Nothing,
				date
			]
		],
		{sortedDate, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match MaterialsPriceTableP *)
	associationOutput=
		If[output == Association,
			Map[
				AssociationThread[{Notebook, Source, Site, Material, MaterialName, PricingCategory, Amount, PricePerUnit, Price, DateCompleted}, #]&,
				associationDataTable
			],
			Null
		];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{tag, source, sample, modelname, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {source, site, site, sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {source, site, sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedSite}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{tag, sample, modelname, amount, rate, price},
			Switch[{amount, rate, output, consolidation},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by source *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each source *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* group all the rows in the data table by material *)
	gatheredByMaterial=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by material, before we do the Total call *)
	materialConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByMaterial
	];

	(* get the total for each material *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	materialConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		materialConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	materialConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{materialConsolidatedPreTotal, materialConsolidatedTotals}
	];

	(* --- Construct the tables --- *)

	(* get the number of notebooks and number of sources specified in this function *)
	numNotebooks=Length[DeleteDuplicates[sortedNotebooks]];
	numProts=Length[DeleteDuplicates[sortedSources]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Source columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		(* the below 3 cases are the different consolidated datatables when the Consolidation -> Notebook, Source or Material *)
		{Notebook, _, _}, notebookConsolidatedTable,
		{Source, _, _}, protocolConsolidatedTable,
		{Material, _, _}, materialConsolidatedTable,
		(* when no Consolidation is chosen and only a single Notebook and a single Source are present, omit the notebook and Source column *)
		{_, 1, 1}, noProtocolDataTable,
		(* when no Consolidation is chosen and only a single Notebook (with several Sources) are present, omit the notebook column *)
		{_, 1, _}, noNotebookDataTable,
		(* in all other cases, display the entire DataTable *)
		{_, _, _}, allDataTable
	];

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalInputPrice=If[MatchQ[DeleteCases[sortedPrice, Null], {}],
		0 * USD,
		Total[DeleteCases[sortedPrice, Null]]
	];

	(* generate the subtotal row with the appropriate number of columns *)
	(* use myStartDate as an indicator whether we are dealing with the team/notebook overload or not *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		(* when Consolidation -> Notebook, Source, or Material *)
		{Notebook | Source | Material, _, _}, {{"", ""}, {"Total Price", totalInputPrice}},
		(* when the output is single notebook and a single protocol and both the notebook and protocol columns are omitted *)
		{_, 1, 1}, {{"", "", "", "", "", ""}, {"", "", "", "", "Total Price", totalInputPrice}},
		(* for protocol overload, when the output is single notebook and the notebook column is omitted *)
		{_, 1, _}, {{"", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "Total Price", totalInputPrice}},
		(* for protocol overload, when the entire data table is displayed without omitting any columns *)
		{_, _, _}, {{"", "", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "", "Total Price", totalInputPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		(* the below 3 cases are when Consolidation -> Notebook, Source, or Material *)
		{Notebook, _, _}, {"Notebook", "Price"},
		{Source, _, _}, {"Source", "Price"},
		{Material, _, _}, {"Material Name", "Price"},
		(* when the output is single notebook and a single Source and both the notebook and Source columns are omitted *)
		{_, 1, 1}, {"Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"},
		(* when the output is single notebook and the notebook column is omitted *)
		{_, 1, _}, {"Source", "Site", "Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"},
		(* when the entire data table is displayed without omitting any columns *)
		{_, _, _}, {"Notebook", "Source", "Site", "Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"}
	];

	(* make the title for the table *)
	tableTitle=If[NullQ[myStartDate],
		"Material Pricing",
		StringJoin["Material Pricing from ", DateString[myStartDate], " to ", DateString[myEndDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> tableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalInputPrice
	]
];



(* ::Subsubsection::Closed:: *)
(* priceMaterialsProtocols (private) *)


(* --- PROTOCOL MATERIALS PRICING --- *)

(* This function is called in the core function (priceMaterialsCore) and combines the information yielded from listprice and tax pricing of protocols' materials *)
(* NOTE: Stocking pricing is calculated in PriceTransactions since that is a transactional fee! *)
(* The function is split up into 2 parts.
				In PART 1 the list price and associated tax price is calculated.
				In PART 2, all remaining information needed for the output table is gathered and the output lists are constructed by consolidation of all identical materials within each protocol *)
(* The inputs are the protocol packets from the big Download Call in PriceMaterials *)
(* The outputs are lists of information about notebook, samples, names, prices, etc for the PriceMaterials output table *)

(* NOTE: this helper is also called directly by priceTransactionsToUser in PriceTransactions *)

DefineOptions[priceMaterialsProtocols,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for materials pricing."}
	}
];

priceMaterialsProtocols[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myResourcePackets:{{PacketP[Object[Resource]]...}...},
	myResourceProductPackets:{{(PacketP[Object[Product]] | Null | $Failed | Association[Rule[_, $Failed] ...])...}...},
	myResourceSamplePackets:{{(PacketP[] | Null | $Failed)...}...},
	myResourceSampleModelPackets:{{(PacketP[Model] | Null | $Failed | Association[Rule[_, $Failed] ...])...}...},
	mySampleContainerModelPackets:{{(PacketP[Model[Container]] | Null | $Failed)...}...},
	myProductModelPackets:{{(PacketP[Model] | Null | $Failed)...}...},
	myDefaultStorageConditionPackets:{{(PacketP[Model[StorageCondition]] | Null | $Failed)...}...},
	myContainerResourcePackets:{{(PacketP[Model[Container]] | Null | $Failed)...}...},
	mySiteModelPackets:{(PacketP[Model[Container, Site]] | Null)...},
	myOptions:OptionsPattern[]
]:=Module[{safeOptions, allowSubprotocolsQ, allResourcePackets, allSampleResourcePackets,
	protocolNotebooks, protocolObjects, protocolDates, subprotocols, notCompletedProts, resourceSampleBool, onlySamplePackets,
	payableSampleProducts, productExistsBool, nullSamples, nullSamplesModels, noWaterNullSamples, payableSamplePackets, payableSamples, payableSamplesKitComponents,
	kitSampleTuples, nonRedundantKitSampleTuples, nonRedundantKitDuplicatesBool, sampleFromKitBool,
	flatSampleResourcePackets, flatSampleProductPackets, resourceStatus, usedForMaintenanceBool, flatFulfilledProductPackets,
	flatFulfilledResourcePackets, flatFulfilledModelPackets, purchasableProductPackets, purchasableResourcePackets, purchasableModelPackets, payableSampleModelPackets, productPricePerUnit,
	noSiteProtocols, indexMatchedSiteSalesTax, fulfilledSiteSalesTax, payableSiteSalesTax, productSamplesPerItem, productAmount,
	productName, productCountPerSample, nonNullproductCountPerSample, nonNullProductPricePerUnit, productPricingRate, productListPrice, productTaxPricingRate,
	productTaxPrice, resourcePurchaseBool, resourceAmountUsed, stockSolutionPricePerUnit, resourceSampleAndNonMaintenanceBool,
	indexmatchFilterForProtocols, fulfilledAndNonMaintenanceBool, onlySampleProductPackets,
	payableNotebooks, payableProtocols, payableSampleModel, payableModelName, payableAmounts, payableDateCompleted,
	allNonmaintenaceSampleResourcePackets, totalProtocolPrices, totalProtocolPricePerUnit, totalProtocolNotebooks, totalProtocolObjects, totalProtocolSamplesObjects,
	totalProtocolSampleNames, totalProtocolSampleAmounts, totalProtocolSampleAmountsMixed, totalProtocolDateCompleted, totalProtocolTags, transposedProtocolsAndObjects, gatheredObjects, gatheredProtocols, gatheredTags,
	gatherByObjectAndProtocolAndTag, gatheredProtocolNotebooks, gatheredProtocolSampleNames, gatheredProtocolPrices, gatheredProtocolPricePerUnit, gatheredProtocolSampleAmounts,
	gatheredProtocolDateCompleted, consolidatedProtocolNotebooks, consolidatedProtocolNames, consolidatedProtocols, consolidatedObjects, consolidatedProtocolTags,
	consolidatedProtocolPricePerUnit, consolidatedProtocolDates, consolidatedProtocolSampleAmounts, consolidatedProtocolPrices, totalProtocolOutput, maintenanceBool,
	refundedProtocols, refundStatus, refundedResourceBool, reusabilityLookup, sampleToModelLookup, protocolSites, payableSites,
	totalProtocolSites, gatheredInformation, gatheredSite, consolidatesSite
	},

	(* default the unspecified or incorrectly specified options; pull out AllowSubprotocols *)
	safeOptions=SafeOptions[priceMaterialsProtocols, ToList[myOptions]];
	allowSubprotocolsQ=Lookup[safeOptions, AllowSubprotocols];

	(* pull out the Object value for each protocol, the Notebook, and the DateCompleted. These lists are indexmatched with the input protocols *)
	protocolObjects=Lookup[myProtocolPackets , Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets , Notebook, {}], Object];
	protocolDates=Lookup[myProtocolPackets, DateCompleted, {}];
	protocolSites=Download[Lookup[myProtocolPackets,Site],Object];

	(* find the Protocols that are Subprotocols (as in, they have a ParentProtocol) *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided Protocols are Subprotocols, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceMaterials::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the Protocols that are not yet completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any Protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceMaterials::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(*this is not really reliable, though in this case because we are only refunding things that are reusable items, it should not cause an issue. The more robust thing to do would be to use the model from the resource rather than the Sample[Model]*)
	(* sample to model lookup *)
	sampleToModelLookup=DeleteDuplicates[Map[(#[[1]] -> Download[#[[2]], Object])&, Lookup[DeleteDuplicates[Cases[Flatten[myResourceSamplePackets], PacketP[]]], {Object, Model}]]];

	(* model to Reusability lookup *)
	reusabilityLookup=DeleteDuplicates[Map[(#[[1]] -> #[[2]])&, Lookup[DeleteDuplicates[Cases[Flatten[myResourceSampleModelPackets], PacketP[]]], {Object, Reusability}]]];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* get all the non-refunded protocol packets *)
	refundedProtocols=Lookup[PickList[myProtocolPackets, refundStatus, True], Object];

	(* get all Resource Packets that were used (including Operator and Instrument resources) *)
	(* this is a list of lists that is index matched with the input protocols *)
	allResourcePackets=Cases[#, PacketP[Object[Resource]]] & /@ myResourcePackets;

	(* get a Boolean list for whether the Resource is a Sample (True) or not (False) *)
	resourceSampleBool=MatchQ[#, PacketP[Object[Resource, Sample]]]& /@ Flatten[allResourcePackets];

	(*check if any of the resources were used for a maintenance*)
	usedForMaintenanceBool=MemberQ[Lookup[#, Requestor, {}], LinkP[Object[Maintenance]]] & /@ Flatten[allResourcePackets];

	(*figure out if it's a sample and Not used in a maintenance*)
	resourceSampleAndNonMaintenanceBool=MapThread[
		Function[{eachSampleQ, maintenanceQ},
			And[eachSampleQ, Not[maintenanceQ]]
		],
		{
			resourceSampleBool,
			usedForMaintenanceBool
		}
	];

	(*get one that's just for maintenance assuming that we're working with sample packets*)
	maintenanceBool=Not /@ PickList[usedForMaintenanceBool, resourceSampleBool];

	(* get all Sample Resource packets that were used (excluding Operator and Instrument resources) *)
	(* this is a list of lists that is index matched with the input protocols. We will use this list for indexmatching later (e.g. sales tax)*)
	allSampleResourcePackets=Cases[#, PacketP[Object[Resource, Sample]]] & /@ allResourcePackets;

	(*exclude any maintenance requested samples*)
	allNonmaintenaceSampleResourcePackets=Map[
		Function[{eachSet},
			Select[eachSet, !MemberQ[Lookup[#, Requestor, {}], LinkP[Object[Maintenance]]] &]
		],
		allSampleResourcePackets
	];

	(* get the Sample Resource packets flattened out and filter for only those Samples that have Products associated with them *)
	(* this will be a flat list with all the resources with product information, used by all the non-refunded input protocols *)
	flatSampleResourcePackets=Flatten[allSampleResourcePackets];

	(* filter for entries that derive from Resource samples (as opposed to operator or instrument resources).*)
	(* flatten to be index matched with the resource list *)
	flatSampleProductPackets=PickList[Flatten[myResourceProductPackets], Flatten[allResourcePackets], PacketP[Object[Resource, Sample]]];

	(* get the Status of all Resources *)
	resourceStatus=Lookup[flatSampleResourcePackets, Status, {}];

	(*check whether the resource is fulfilled and a non maintenance resource and not refunded *)
	fulfilledAndNonMaintenanceBool=MapThread[
		Function[{eachSamplePacket, eachStatus},
			And[
				MatchQ[eachStatus, Fulfilled],
				FreeQ[Lookup[eachSamplePacket, Requestor, {}], LinkP[Object[Maintenance]]]
			]
		], {
			flatSampleResourcePackets,
			resourceStatus
		}
	];

	(* filter for the Sample Packets with fulfilled resources *)
	flatFulfilledProductPackets=PickList[flatSampleProductPackets, fulfilledAndNonMaintenanceBool];

	(* filter for the Resource Packets with fulfilled resources *)
	flatFulfilledResourcePackets=PickList[flatSampleResourcePackets, fulfilledAndNonMaintenanceBool];

	(* filter out $Failed entries due to Resource Operators and Resource Instruments, then filter for fulfilled Resources *)
	flatFulfilledModelPackets=PickList[
		PickList[Flatten[myResourceSampleModelPackets], resourceSampleAndNonMaintenanceBool],
		PickList[fulfilledAndNonMaintenanceBool, maintenanceBool]
	];

	(* --- Calculate resource pricing --- *)

	(* get the information which of the materials are being purchased *)
	(* if Purchase is Null for a given Resource, then that Resource is either a reusable item and thus not charged, or the resource has been purchased previously by the user or the user's team *)
	resourcePurchaseBool=Lookup[flatFulfilledResourcePackets, Purchase, {}];

	(* filter out the $Failed entries from the Sample Packets originating from Resources other than Samples and filter for the fulfilled resources *)
	(* also do the same for the product packets *)
	onlySamplePackets=PickList[
		PickList[Flatten[myResourceSamplePackets], resourceSampleAndNonMaintenanceBool, True],
		PickList[fulfilledAndNonMaintenanceBool, maintenanceBool]
	];
	onlySampleProductPackets = PickList[
		PickList[Flatten[myResourceProductPackets], resourceSampleAndNonMaintenanceBool, True],
		PickList[fulfilledAndNonMaintenanceBool, maintenanceBool]
	];

	(* In the next part we will check whether the samples have a product affiliated with them. We can only price if we have a product.
	We will throw an error if that is not the case *)
	(* Note that we're assuming that the the myProductModelPackets has this information already passed down so we're relying on that being accurate *)

	(* extract from the Sample Packets the list of associated products *)
	payableSampleProducts=PickList[onlySampleProductPackets, resourcePurchaseBool, True];

	(* filter for those Sample Model Packets that are to be purchased *)
	payableSampleModelPackets=PickList[flatFulfilledModelPackets, resourcePurchaseBool, True];

	(* get a Boolean list for whether the Sample has a Product associated with it (True) or not (False).  Note that if it is a StockSolution, we are saying Yes only if Price is populated in that stock solution *)
	productExistsBool=MapThread[
		If[MatchQ[#2, ObjectP[Model[Sample, StockSolution]]],
			MatchQ[Lookup[#2, Price], UnitsP[USD / Liter] | UnitsP[USD / Gram]],
			Not[NullQ[#1]]
		]&,
		{payableSampleProducts, payableSampleModelPackets}
	];

	(* get the Samples that don't have any Product associated with them *)
	nullSamples=PickList[PickList[Download[onlySamplePackets, Object], resourcePurchaseBool, True], productExistsBool, False];

	(* filter for samples that don't have a product associated with them *)
	nullSamplesModels=Lookup[PickList[payableSampleModelPackets, productExistsBool, False], Object, {}];

	(* filter the nullSamples (samples with no product associated) for samples that are not water sources coming from the pipes (WaterModelP) *)
	(* any water sample matching the pattern WaterModelP is not purchased from a supplier but produced in the lab *)
	noWaterNullSamples=PickList[nullSamples, nullSamplesModels, Except[WaterModelP]];

	(* if there are Samples that don't have any Product associated with them (except water), throw a soft message *)
	If[Not[MatchQ[noWaterNullSamples, {}]],
		Message[PriceMaterials::MissingProductInformation, DeleteDuplicates[noWaterNullSamples]]; (*missingProductTask[DeleteDuplicates[noWaterNullSamples]];*)
	];

	(* The next part is going to filter out resources pointing to samples that come from the same kit
		This is because the entire kit is purchased the moment the protocol requests any of it.
		So if within the same protocol another sample from that same kit is requested, we would double charge  unless we filter out those resource *)

	(* filter the sample packets for those that we will purchase and those that have a product associated with them *)
	payableSamplePackets=PickList[PickList[onlySamplePackets, resourcePurchaseBool, True], productExistsBool, True];

	(* get the samples the resource is pointing to, as well as its corresponding KitComponents (all other samples from the same kit) that each sample is point to. If the sample is not from a kit, this is going to be an empty list *)
	payableSamples=Lookup[payableSamplePackets, Object, {}];
	payableSamplesKitComponents=Download[#, Object]& /@ Lookup[payableSamplePackets, KitComponents, {}];

	(* make tuples of the form {{sample,kitComponents}..} *)
	kitSampleTuples=Transpose[{payableSamples, payableSamplesKitComponents}];

	(* delete entries for which the union of sample and kitComponents occurs more than once *)
	nonRedundantKitSampleTuples=DeleteDuplicatesBy[kitSampleTuples, Sort[Flatten[#]]&];

	(* get a boolean list for whichever samples we are kicking out because they are samples from the same kit *)
	nonRedundantKitDuplicatesBool=Map[
		If[MemberQ[nonRedundantKitSampleTuples, #], True, False]&, kitSampleTuples
	];

	(* construct a bool for whether the resource stems from a kit or not. We filter out resources pointing to samples from the same kit since we only charge once the full price of the whole kit with all its affiliated items *)
	sampleFromKitBool=PickList[MatchQ[#, {ObjectP[]..}]& /@ payableSamplesKitComponents, nonRedundantKitDuplicatesBool, True];

	(* filter the Sample Packets for materials that are being purchased and have a product affiliated and no kit-duplicates *)
	purchasableProductPackets=PickList[PickList[PickList[flatFulfilledProductPackets, resourcePurchaseBool], productExistsBool, True], nonRedundantKitDuplicatesBool, True];

	(* filter the Product Packets for materials that are being purchased and have a product affiliated *)
	purchasableResourcePackets=PickList[PickList[PickList[flatFulfilledResourcePackets, resourcePurchaseBool], productExistsBool, True], nonRedundantKitDuplicatesBool, True];

	(* filter the Model Packets for materials that are being purchased and have a product affiliated *)
	purchasableModelPackets=PickList[PickList[PickList[flatFulfilledModelPackets, resourcePurchaseBool], productExistsBool, True], nonRedundantKitDuplicatesBool, True];

	(* extract the Model of the samples to be purchased *)
	(*TODO: In cases where the Object[Sample] has been transferred into with a sample of a different Model, its Model will be severed, so we may have to look at the product instead*)
	(*it seems like a bad idea to look in the resource, as that may not have a model either, so its best to fall back on the product*)
	payableSampleModel=MapThread[
		Function[{kitBool, productID, modelID},
			If[kitBool,
				(* if the sample is from a kit, we want to display the name of the product (which is the kit) rather than the name of the model of the sample *)
				Lookup[productID, Object, {}],
				If[MatchQ[modelID, Except[Alternatives[Null, $Failed]]],
					Lookup[modelID, Object, {}],
					(*fall back on teh product if the model was severed*)
					Lookup[productID, Object, {}]
				]
			]
		],
		{sampleFromKitBool, purchasableProductPackets, purchasableModelPackets}
	];

	(* refund bool *)
	(*if there was a refund set the bool to True, unless the purchased item was reusable and they now own it (like a column)*)
	(*refundedResourceBool=MatchQ[Lookup[#, RootProtocol, {}], LinkP[refundedProtocols]]&/@purchasableResourcePackets;*)
	refundedResourceBool=Map[
		(*check if the root protocol was refunded - if it was not skip to the end with False*)
		If[MatchQ[Lookup[#, RootProtocol, {}], LinkP[refundedProtocols]],
			(*for refunded protocol, get the Sample key and navigate back to Reusability in the Model*)
			Module[{sample, model, reusabilityBool},

				(*navigate from sample to Reusability*)
				sample=Download[Lookup[#, Sample, Null], Object];

				model=Lookup[sampleToModelLookup, sample, Null];
				(*if anything has gone wrong, we need to set Reusability to false and err on the side of caution for refunding*)
				reusabilityBool=Lookup[reusabilityLookup, model, False];

				(*if the model is reusable do not refund it*)
				If[And[MatchQ[reusabilityBool, True], MatchQ[model, ObjectP[Model[Item, Column]]]],
					False,
					True
				]
			],
			False
		]&,
		purchasableResourcePackets
	];

	(* for all Materials to be purchased, extract the amount used and its unit *)
	(* The Unit unit is internal and shouldn't be shown to users - drop it since it doesn't have an effect *)
	resourceAmountUsed=MapThread[
		Function[{amount, refundQ},
			Switch[{amount, refundQ},
				{_?(UnitsQ[#, Unit]&), True}, 0,
				{_, True}, 0 * Units[amount],
				{_?(UnitsQ[#, Unit]&), False}, Unitless[amount],
				{_, False}, amount
			]
		],
		{Lookup[purchasableResourcePackets, Amount, {}], refundedResourceBool}
	];

	(* for all Materials to be purchased, extract all product information. This includes: *)
	(* 1) pricing (list price before tax) for entire product (can be multiple samples) *)
	(* 2) samples per item (if multiple items (objects) arrive for that product (e.g. 10 bottles, or 50 boxes), *)
	(* 3) amount per sample and 4) sample amount unit in the case of liquids or solids with a unit (e.g. 5g of salt or 5L of acetonitrile, per sample object) *)
	(* 5) count per sample (if more than one count per sample object but no unit (e.g. 96 tips per sample object)) *)
	(* 6) name of the product - this is needed for kit items where we don't want to display the name of the model of the sample, but rather the  *)
	{productPricePerUnit, productSamplesPerItem, productAmount, productCountPerSample, productName}=Map[
		Function[{optionName},
			Map[
				If[NullQ[#],
					Null,
					Lookup[#, optionName]
				]&,
				purchasableProductPackets
			]
		],
		{Price, NumberOfItems, Amount, CountPerSample, Name}
	];

	(* also pull out the stock solution price information; this will be $Failed if not a stock solution *)
	stockSolutionPricePerUnit=Lookup[purchasableModelPackets, Price, {}];

	(* make sure there is no Nulls in the price list (originating from StockSolutions that are not yet priced at this point in time but will in the future) *)
	nonNullProductPricePerUnit=Map[
		If[NullQ[#],
			0.00 * USD,
			#
		] &,
		productPricePerUnit
	];

	(* for materials with ProductCount -> Null, fill in a count of 1 since it can be assumed that the product price refers to 1 item *)
	nonNullproductCountPerSample=Map[
		If[NullQ[#],
			1,
			#
		] &, productCountPerSample];

	(* select protocols that have no site *)
	noSiteProtocols=Lookup[PickList[myProtocolPackets, mySiteModelPackets, Except[PacketP[Model[Container, Site]]]], Object];

	(* if we find protocols without site (if there are any), we need to throw hard error since we cannot calculate tax rate *)
	If[(!MatchQ[myProtocolPackets, {}] && !MatchQ[mySiteModelPackets, {PacketP[Model[Container, Site]]..}]),
		(Message[PriceMaterials::SiteNotFound, noSiteProtocols];
		Return[$Failed]
		)
	];

	(* get the SalesTaxRate from the SiteModelPackets and index match them with the flat Resource and flat Product packets *)
	indexMatchedSiteSalesTax=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[mySiteModelPackets, SalesTaxRate, {}], allSampleResourcePackets}]];

	(* filter for entries that contain samples whose Resource status is fulfilled *)
	fulfilledSiteSalesTax=PickList[
		PickList[indexMatchedSiteSalesTax, maintenanceBool],
		PickList[fulfilledAndNonMaintenanceBool, maintenanceBool]
	];

	(* filter for entries that contain resources to be purchased and have a product affiliated *)
	payableSiteSalesTax=PickList[
		PickList[PickList[fulfilledSiteSalesTax, resourcePurchaseBool, True], productExistsBool, True],
		nonRedundantKitDuplicatesBool,
		True
	];

	(* calculate the pricing rate for each entry (in $/unit for non-self-contained samples or $/1 count for self-contained samples) for the product list price*)
	productPricingRate=MapThread[
		Function[{resourceunitused, productcount, price, samplesPerItem, amount, kitBool, stockSolutionPrice},
			Which[
				kitBool && Not[NullQ[samplesPerItem]],
				(* samples from kits only have one price per unit since we're always charging the whole thing - it's always whats stored in the field Price *)
				(* however if NumberOfItems is populated then we have a sort of kit of kits so we want to divide by that quantity *)
				price / samplesPerItem,
				kitBool,
				price,
				(* if we are dealing with a stock solution then put its price here and not the product one *)
				MatchQ[stockSolutionPrice, UnitsP[USD / Liter] | UnitsP[USD / Gram]],
				stockSolutionPrice,
				(* If there is no resource amount unit (or if it's counted), that means the material is self contained *)
				MatchQ[resourceunitused, UnitsP[Unit]] || NullQ[resourceunitused],
				If[MatchQ[productcount, Null],
					(* if the material is self-contained and has no CountPerSample in its product,the pricingrate is simply the product price divided by the NumberOfItems, since the count is assumed to be 1.*)
					price / samplesPerItem,
					(* if the materials is self-contained and has CountPerSample is populated,the pricingrate is calculated by dividing the product price by the NumberOfItems and the CountPerSample,resulting in $/count*)
					price / (samplesPerItem * productcount)
				],
				True,
				(* if material is non-selfcontained (i.e.has a volume or mass),then the pricing rate is calculated by dividing the product price by the NumberOfItems and Amount,resulting in $/unit (for instance $/grams or $/liter)*)
				price / (samplesPerItem * amount)
			]
		],
		{resourceAmountUsed, nonNullproductCountPerSample, nonNullProductPricePerUnit, productSamplesPerItem, productAmount, sampleFromKitBool, stockSolutionPricePerUnit}
	];

	(* calculate the tax pricing rate for each Material to be purchased, prorated for the volume and mass used *)
	(* this is the sales tax rate multiplied by the productPricingRate *)
	productTaxPricingRate=productPricingRate * Map[Convert[#, 1] &, payableSiteSalesTax];

	(* calculate the list price for each Material to to be purchased by prorating for the volume and mass used *)
	productListPrice=MapThread[
		Function[{productcount, amountused, pricingrate, kitBool},
			Which[
				kitBool,
				(* we always charge the whole kit so it's simply the price *)
				1 * pricingrate,
				(* if the material is self-contained and has Amount->Null, the entire object is purchased and the pricing rate is multiplied by the productcount *)
				NullQ[amountused],
				pricingrate * productcount,
				(* if the material is self-contained and an Amount, the pricingrate is multiplied by the count used *)
				MatchQ[amountused, UnitsP[Unit]],
				pricingrate * amountused,
				True,
				(* if the material non-selfcontained, there has to be an Amount specified. The pricing is the pricingrate multiplied by the amount*)
				(pricingrate * amountused)
			]
		], {nonNullproductCountPerSample, resourceAmountUsed, productPricingRate, sampleFromKitBool}
	];

	(*calculate the tax price for each Material to to be purchased by prorating for the volume and mass used *)
	(* this is the sales tax rate multiplied by the productListPrice *)
	productTaxPrice=productListPrice * Map[Convert[#, 1] &, payableSiteSalesTax];

	(* extract the amounts used *)
	payableAmounts=MapThread[
		Function[{amountused, productcount, kitBool},
			Which[
				(* for samples from kits we don't want to prorate since we purchase the entire kit, so the amount will always be 1 *)
				kitBool, 1,
				(* for materials that don't have an associated amount, return the CountPerSample of the product *)
				NullQ[amountused], productcount,
				(* for materials that have an amount but no unit associated (self-contained samples), return the amount (count) that was used, without a unit *)
				MatchQ[amountused, UnitsP[Unit]], amountused,
				(* for materials that have an amount with a unit associated with it, return the amount that was used*)
				True, amountused
			]
		], {resourceAmountUsed, nonNullproductCountPerSample, sampleFromKitBool}
	];

	(* --- PART 2: Get all the remaining information for the protocol output table --- *)

	(* ==define Function:indexmatchFilterForProtocols == *)
	(* Use this helper function to indexmatch all lists that indexmatch with protocols, with the list of sample resources that are used by these protocols *)
	(* Then filter them for samples with an affiliated product, fulfilled resources, and that are to be purchased *)
	indexmatchFilterForProtocols[myMultipleListsOfObjects_List]:=Module[
		{indexMatchedLists, fulfilledLists, payableLists, productExistsLists, noKitRedundanciesLists},

		(*get the objects and index match them with the flat Resource and Product packets*)
		indexMatchedLists=Map[
			Function[{myobject},
				Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {myobject, allNonmaintenaceSampleResourcePackets}]]
			],
			myMultipleListsOfObjects
		];

		(*filter for items that contain samples with fulfilled resources*)
		fulfilledLists=Map[PickList[
			#,
			PickList[resourceStatus, maintenanceBool], Fulfilled]&,
			indexMatchedLists
		];

		(*filter for items that contain resources to be purchased*)
		payableLists=Map[PickList[#, resourcePurchaseBool, True]&, fulfilledLists];

		(*filter for items tha contain samples that are affiliated with products*)
		productExistsLists=Map[PickList[#, productExistsBool, True]&, payableLists];

		(*filter for items that contain samples from the same kits only once *)
		noKitRedundanciesLists=Map[PickList[#, nonRedundantKitDuplicatesBool, True]&, productExistsLists]
	];

	(* apply this helper function to the notebooks, protocols, and protocols dates which are all indexmatched with the input protocols and unfiltered at this point *)
	{payableNotebooks, payableProtocols, payableDateCompleted, payableSites}=indexmatchFilterForProtocols[{protocolNotebooks, protocolObjects, protocolDates, protocolSites}];

	(* for all Materials to be purchased, extract the appropriate name *)
	payableModelName=MapThread[
		If[#,
			(* if the sample is from a kit, we want to display the name of the product (which is the kit) rather than the name of the model of the sample *)
			Lookup[#2, Name],
			Lookup[#3, Name]
		]&, {sampleFromKitBool, purchasableProductPackets, purchasableModelPackets}
	];

	(* --- construct the individual row entries for product price, and tax price of the protocols --- *)

	(* join all price lists:product price,tax price,and stocking price *)
	totalProtocolPrices=Join[productListPrice, productTaxPrice];
	totalProtocolPricePerUnit=Join[productPricingRate, productTaxPricingRate];

	(* join all notebooks, protocols, resource objects, names and amounts. These are identical for both lists (1 for product, 1 for tax price) *)
	{totalProtocolNotebooks, totalProtocolObjects, totalProtocolSamplesObjects, totalProtocolSampleNames, totalProtocolSampleAmountsMixed, totalProtocolDateCompleted, totalProtocolSites}=Map[
		Join[#, #]&, {payableNotebooks, payableProtocols, payableSampleModel, payableModelName, payableAmounts, payableDateCompleted, payableSites}];

	(* make sure that the counts are rounded to integers *)
	totalProtocolSampleAmounts=Map[If[QuantityQ[#], #, Round[#]] &, totalProtocolSampleAmountsMixed];

	(* make the protocol tags for the output table indicating the pricing category for each line *)
	totalProtocolTags=Join[ConstantArray["Product List Price", Length[productListPrice]], ConstantArray["Product Tax", Length[productTaxPrice]]];

	(*---in the next part, list items are gathered and consolidated into one list entry if they originate from the same protocol, plus if the associated objects are from the same model, plus if the price tag is identical ---*)
	(*in the first step bring the protocol, object, site, and price tag together into one*)
	transposedProtocolsAndObjects=Transpose[{totalProtocolSamplesObjects, totalProtocolObjects, totalProtocolTags, totalProtocolSites}];

	(*in the second step gather them if list entries (protocol, material object, and tag)) are identical,and extract back the gathered protocol, object, and tag lists *)
	gatheredInformation=Gather[transposedProtocolsAndObjects];
	gatheredObjects=gatheredInformation[[All, All, 1]];
	gatheredProtocols=gatheredInformation[[All, All, 2]];
	gatheredTags=gatheredInformation[[All, All, 3]];
	gatheredSite=gatheredInformation[[All,All,4]];

	(* ==Define Function:gatherByObjectAndProtocolAndTag==*)
	(*Use this helper function to consolidate the lists by sample objects that originate from the same protocol and are from the same model*)
	gatherByObjectAndProtocolAndTag[myflatlists_List]:=Module[{objects, protocols, tags, transposedLists},
		(*get the model, protocol and tags *)
		objects=totalProtocolSamplesObjects;
		protocols=totalProtocolObjects;
		tags=totalProtocolTags;
		(*transpose lists with all three *)
		transposedLists=Map[Transpose[{objects, protocols, tags, #}]&, myflatlists];
		(*gather the lists if object, protocol and tags are identical, and extract the gathered list*)
		Map[GatherBy[#, Most][[All, All, 4]]&, transposedLists]
	];

	(*using the helper function, gather notebook,name,prices, date and tag lists*)
	{gatheredProtocolNotebooks, gatheredProtocolSampleNames, gatheredProtocolPrices, gatheredProtocolPricePerUnit, gatheredProtocolSampleAmounts, gatheredProtocolDateCompleted}=
		gatherByObjectAndProtocolAndTag[{totalProtocolNotebooks, totalProtocolSampleNames, totalProtocolPrices, totalProtocolPricePerUnit, totalProtocolSampleAmounts, totalProtocolDateCompleted}];

	(*consolidate the gathered notebook,objects,models,names,dates, priceperunit and tags list so that there is one item per list. Since they should be identical,the first entry can be taken*)
	{
		consolidatedProtocolNotebooks, consolidatedProtocolNames, consolidatedProtocols, consolidatedObjects,
		consolidatedProtocolTags, consolidatedProtocolPricePerUnit, consolidatedProtocolDates, consolidatesSite
	}=Map[First /@ #&, {gatheredProtocolNotebooks, gatheredProtocolSampleNames, gatheredProtocols, gatheredObjects, gatheredTags, gatheredProtocolPricePerUnit, gatheredProtocolDateCompleted, gatheredSite}];

	(*consolidate the gathered price and amount lists, by summing up the list entries *)
	{consolidatedProtocolSampleAmounts, consolidatedProtocolPrices}=Map[
		Function[{pricelist},
			Map[
				If[NullQ[#],
					Null,
					Total[#]
				]&, pricelist
			]
		], {gatheredProtocolSampleAmounts, gatheredProtocolPrices}
	];

	(* put together the output lists in the correct order for the output table *)
	totalProtocolOutput={
		consolidatedProtocolNotebooks, consolidatedProtocols, consolidatedObjects, consolidatedProtocolNames, consolidatedProtocolTags, consolidatedProtocolSampleAmounts,
		consolidatedProtocolPricePerUnit, consolidatedProtocolPrices, consolidatedProtocolDates, consolidatesSite
		}

];


(* ::Subsubsection::Closed:: *)
(*priceMaterialsTransactionOrder (private) *)


(* --- PRICING OF TRANSACTION ORDER MATERIALS --- *)

(* This function is called in the core function (priceMaterialsCore) and combines the information yielded from listprice, tax,of transaction orders. Receiving and measurement fees are not included here, they are priced in PriceTransactions *)
(* This function retrieves pricing information of samples no matter whether they have been received yet or not. In the protocol/transaction overload, only cancelled transactions are filtered out. Notebook and Team overloads only look at received transactions *)
(* In the first part materials object ID, quantities, notebook and date information is extracted. In the second part the transaction order product price and tax price is extracted *)
(* In the third and fourth part, the lists are consolidated by sample models/ transaction objects, and the lists for the output tables are constructed *)

(* The inputs are the transaction packets from the big Download Call in PriceMaterials *)

(* The outputs are lists of information about notebook, samples, names, prices, etc for the PriceMaterials output table *)

priceMaterialsTransactionOrder[myTransactionOrderPackets:{{({(PacketP[{Object[], Model[]}] | Null)...} | PacketP[{Object[], Model[]}] ... | {Null} | Null) ...} ...}]:=Module[{
	allTransactionPackets, transactionCanceledBool, allSupplierTransactionPackets, transactionHasSupplierBool, toBeIgnoredBool,
	toBePricedTransactionPackets, fulfillmentBool, allTransactionOrderPackets,
	orderQuantities, allTransactionOrderProductPackets, productModels, samplesPerItemInOrders, indexMatchedProductPackets, allTransactionModelPackets,
	flatTransactionModelNames, transactionObjects, indexMatchedTransactionObjects, transactionNotebooks, indexMatchedTransactionNotebooks, transactionDates,
	indexMatchedTransactionDates, indexMatchedProducts, gatheredProducts, indexMatchedOrderProductPackets,
	transactionOrderProductPricePerUnit, transactionOrderSamplesPerItem, transactionOrderListPrice, allTransactionOrderSitePackets, transactionOrderTaxrate,
	indexMatchedTaxrate, transactionOrderTaxPrice, flatCancelledTransactionBool, allCancelledTransactionModels, flatFulfilledTransactionBool,
	indexmatchFilterForTransactions, transactionProductPricing, transactionTaxPricing, flatTransactionMaterialObject, recTransactionNotebooks,
	recTransactionObjects, recTransactionMaterialObject, recTransactionNames, recTransactionDates, filtTransactionNotebooks, filtTransactionObjects,
	filtTransactionMaterialObject, filtTransactionNames, filtTransactionDates, transposedTransactionProducts, gatheredTransactionMaterial,
	gatheredTransactionObjects, gatherByModelAndObject, gatheredTransactionNotebooks, gatheredTransactionName, gatheredTransactionProductPrice,
	gatheredTransactionTaxPrice, gatheredTransactionDates, consolidatedTransactionNotebooks, consolidatedTransactionNames,
	consolidatedTransactionObjects, consolidatedTransactionMaterial, consolidatedTransactionDates, consolidatedTransactionProductPrice,
	consolidatedTransactionTaxPrice, consolidatedTransactionAmounts, consolidatedTransactionProductPricingRate, consolidatedTransactionTaxPricingRate,
	allTransactionPrices, transactionPriceNotNullBool, totalTransactionPrices, totalTransactionPricePerUnit, totalTransactionNotebooks,
	totalTransactionObjects, totalTransactionMaterial, totalTransactionNames, totalTransactionAmounts, totalTransactionDates, totalTransactionTags,
	totalTransactionOutput, orderModels, refundBool, totalTransactionSites
},

	(* --- PART 1: this section extracts information of the individual materials affiliated with the transactions orders such as models, names, quantities, notebooks, dates  --- *)

	(*get all the Transaction Packets from the Transaction Download*)
	allTransactionPackets=myTransactionOrderPackets[[All, 6]];

	(*extract a Boolean list for whether the Transaction item is not Canceled - True will indicate we want to ignore this transaction *)
	transactionCanceledBool=Map[MatchQ[Lookup[#, Status, {}], Canceled]&, allTransactionPackets];

	(*get all the Transaction Supplier Packets from the Transaction Download - since we only have Orders and no DropShipping and ShipToUser, we don't have to worry about those *)
	allSupplierTransactionPackets=myTransactionOrderPackets[[All, 5]];

	(* extract a Boolean list for whether the Transaction links to a Supplier Order that has a notebook *)
	transactionHasSupplierBool=Map[
		(* need to make the Null check in case there is no SupplierOrder (no need to worry about DropShipping and ShipToUser since they are not priced here, we only look at Orders) *)
		If[NullQ[#],
			False,
			(* If there is a SupplierOrder, check whether it has a notebook - True will indicate we want to ignore this transaction *)
			MatchQ[Lookup[#, Notebook, {}], ObjectP[Object[LaboratoryNotebook]]]
		]&,
		allSupplierTransactionPackets];

	(* get the refund status of the transactions *)
	refundBool=Map[Lookup[#, Refund, {}]&, myTransactionOrderPackets[[All, 7]]];

	(* construct a boolean for whether we want to ignore this transaction on the basis of its Status and SupplierOrder Notebook *)
	toBeIgnoredBool=MapThread[
		TrueQ[#1] || TrueQ[#2] || MemberQ[#3, True]&,
		{transactionCanceledBool, transactionHasSupplierBool, refundBool}
	];

	(* extract a Boolean list for whether the Transaction has a SupplierOrder linked  *)
	toBePricedTransactionPackets=PickList[allTransactionPackets, toBeIgnoredBool, False];

	(* extract a Boolean list for whether the Transaction has a protocol that was used to fulfill the order *)
	(* Orders with Fulfillment populated are ignored since they are priced by the protocol *)
	fulfillmentBool=Map[
		MatchQ[Lookup[#, Fulfillment, {}], {ObjectP[{Object[Protocol, SampleManipulation], Object[Protocol, StockSolution]}] ..}]&,
		toBePricedTransactionPackets
	];

	(* get the model packets of all ordered transaction items *)
	allTransactionOrderPackets=myTransactionOrderPackets[[All, 2]];

	(* get the order quantities all ordered transaction products *)
	orderQuantities=Map[Lookup[#, OrderQuantities]&, allTransactionOrderPackets];

	(* get the product packets of all ordered transaction items and pull out the Productmodel and the SamplesPerItems *)
	allTransactionOrderProductPackets=myTransactionOrderPackets[[All, 3]];
	productModels=Map[Download[Lookup[#, ProductModel], Object]&, allTransactionOrderProductPackets];
	samplesPerItemInOrders=Map[Lookup[#, NumberOfItems]&, allTransactionOrderProductPackets];

	(* expand the Product packets of ordered transactions with the samples ordered *)
	(* need to multiple by the number of samples per product and by the quantity ordered *)
	indexMatchedProductPackets=MapThread[
		Function[{models, orderQuants, samplesPerItem},
			Flatten[
				MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}
				]
			]
		], {allTransactionOrderProductPackets, orderQuantities, samplesPerItemInOrders}
	];

	(* get the models of ordered transactions as a list of models per transaction for instance  {{model1,model1,model1,model2},{model3}} *)
	(* Since we want them flattened as a list of models for each transaction, need to multiple the ProductModel by the number of samples per product and by the quantity ordered *)
	orderModels=MapThread[
		Function[{models, orderQuants, samplesPerItem},
			Flatten[
				MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}
				]
			]
		],
		{productModels, orderQuantities, samplesPerItemInOrders}
	];

	(* get the model packets from Transaction Order Packet *)
	(* since we are getting this via the ProductModel, need to expand the list by multiplying the quantity order and the samples per item *)
	allTransactionModelPackets=
		MapThread[
			Function[{models, orderQuants, samplesPerItem},
				Flatten[MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}]]],
			{myTransactionOrderPackets[[All, 1]], orderQuantities, samplesPerItemInOrders}
		];

	(* construct a flat list of the name of the models shipped with each transaction, for Transaction Orders use the product name instead since Model name can be ambiguous (in cases where there are multiple products per Model) *)
	flatTransactionModelNames=Flatten[Map[Lookup[#, Name, {}]&, indexMatchedProductPackets]];

	(* get the transaction Object IDs from the big transaction packet *)
	transactionObjects=Map[Lookup[#, Object, {}]&, allTransactionPackets];

	(* construct a fat list of Transaction Objects indexmatched with the models shipped by each transaction *)
	indexMatchedTransactionObjects=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionObjects, orderModels}]];

	(* get the transaction Notebook IDs from the big transaction packet *)
	transactionNotebooks=Map[Lookup[#, Notebook, {}]&, allTransactionPackets];

	(* construct a fat list of Transaction Notebooks, indexmatched with the models shipped by each transaction *)
	indexMatchedTransactionNotebooks=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionNotebooks, orderModels}]];

	(* get the transaction DateDelivered from the big transaction packet *)
	(* this may be Null for partial deliveries or transactions that are pending. Since notebook overloads only look at received transactions, for billing purposes the date will always be populated *)
	transactionDates=Map[Lookup[#, DateDelivered, {}]&, allTransactionPackets];
	indexMatchedTransactionDates=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionDates, orderModels}]];


	(* --- PART 2: this section only looks at Transaction.Orders and extracts the pricing of the Transaction Order products plus the affiliated stocking prices affiliated with them --- *)

	(* extract a product list from the transaction packets. This list is indexmatched to the transactions as in {{prod1,prod2},{prod3},{prod4,prod5,prod6}}*)
	indexMatchedProducts=Map[Lookup[#, Object] &, indexMatchedProductPackets];

	(* create a gathered product list that will have identical products in each transaction gathered together. This list will be used to indexmatch the pricing information *)
	gatheredProducts=Flatten[Map[Gather, indexMatchedProducts], 1];

	(* indexMatch the ProductPackets (which are a list of non-duplicate products that are shipped in the transaction) with the gathered Model list *)
	indexMatchedOrderProductPackets=MapThread[ConstantArray[#1, Length[#2]]&, {Flatten[allTransactionOrderProductPackets, 1], gatheredProducts}];

	(* get the product price from the indexmatched TransactionOrderProductPackets *)
	(* note that this is the price for one item of the product ordered which can consist of several samples, so this will need to be corrected by the NumberOfItems count *)
	transactionOrderProductPricePerUnit=Flatten[Map[Lookup[#, Price, {}]&, indexMatchedOrderProductPackets]];

	(* get the NumberOfItems count from the TransactionOrderProductPackets *)
	transactionOrderSamplesPerItem=Flatten[Map[Lookup[#, NumberOfItems, {}]&, indexMatchedOrderProductPackets]];

	(* to get the price for each sample object (as opposed to each product), divide the Product Price by the number of samples (NumberOfItems) in that product *)
	transactionOrderListPrice=transactionOrderProductPricePerUnit / transactionOrderSamplesPerItem;

	(* get the Site Model Packet from the Transaction Order Download in order to extract the tax rate for the site at which this transaction was shipped *)
	allTransactionOrderSitePackets=myTransactionOrderPackets[[All, 4]];

	(* extract the sales tax rate from the site model *)
	transactionOrderTaxrate=Lookup[allTransactionOrderSitePackets, SalesTaxRate, {}];

	(* get this list indexmatched with the samples (use the list of models for this *)
	indexMatchedTaxrate=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionOrderTaxrate, orderModels}]];

	(* calculate the tax payable for the transaction products *)
	(* need to Convert the percentage into the decimal format before multiplying since Mathematica has issue to simplify percentages *)
	transactionOrderTaxPrice=transactionOrderListPrice * Map[Convert[#, 1]&, indexMatchedTaxrate];


	(* modify the cancelled-transaction bool to be indexmatch with the individual objects shipped *)
	flatCancelledTransactionBool=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {toBeIgnoredBool, orderModels}]];

	(* filter the Transaction Models for the Cancelled ones such that this list can be used for indexmatching the fulfillmentBool *)
	allCancelledTransactionModels=PickList[orderModels, toBeIgnoredBool, False];

	(* modify the fulfilled-transaction bool to be indexmatched with the individual objects shipped *)
	flatFulfilledTransactionBool=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {fulfillmentBool, allCancelledTransactionModels}]];

	(* ==define Function:indexmatchFilterForTransaction== *)
	(* Use this helper function to indexmatch all transaction order price lists with the entire list of transactions, then filter out tranactions that have been cancelled and are fulfilled by protocols *)
	indexmatchFilterForTransactions[myMultipleListsOfPrices_List]:=Module[{notCancelledPriceLists, notFulfilledPriceLists},

		(* filter the product and stocking price lists for transactions that are received and don't have fulfillment protocols in order to indexmatch the price lists with the transaction sample objects to be priced *)
		notCancelledPriceLists=Map[PickList[#, flatCancelledTransactionBool, False] &, myMultipleListsOfPrices];
		notFulfilledPriceLists=Map[PickList[#, flatFulfilledTransactionBool, False] &, notCancelledPriceLists]

	];

	(* apply the  helper function to the 4 transaction order price lists and the instantTransfer bool *)
	{transactionProductPricing, transactionTaxPricing}=indexmatchFilterForTransactions[{transactionOrderListPrice, transactionOrderTaxPrice}];


	(*---PART 3:in the next part,list items are gathered and consolidated into one list entry if they originate from the same transaction plus if the associated objects are from the same product ---*)

	(* get a flat list of models which is indexmatched with all other flat indexmatched lists (like samples, dates, prices etc *)
	(* for transaction orders, use the product (since the Model can be ambiguous if multiple products exist per Model) *)
	flatTransactionMaterialObject=Flatten[indexMatchedProducts];

	(*filter all output lists for the output table for transactions that have not been canceled *)
	{recTransactionNotebooks, recTransactionObjects, recTransactionMaterialObject, recTransactionNames, recTransactionDates}=Map[
		PickList[#, flatCancelledTransactionBool, False]&,
		{indexMatchedTransactionNotebooks, indexMatchedTransactionObjects, flatTransactionMaterialObject, flatTransactionModelNames, indexMatchedTransactionDates}
	];

	(* filter the received output lists for transactions that have no fulfilled Protocols *)
	{filtTransactionNotebooks, filtTransactionObjects, filtTransactionMaterialObject, filtTransactionNames, filtTransactionDates}=Map[
		PickList[#, flatFulfilledTransactionBool, False]&,
		{recTransactionNotebooks, recTransactionObjects, recTransactionMaterialObject, recTransactionNames, recTransactionDates}
	];

	(* in the first step bring the transaction and product lists together into one *)
	transposedTransactionProducts=Transpose[{filtTransactionMaterialObject, filtTransactionObjects}];

	(* in the second step gather them if list entries (transaction ID and Product ID)) are identical,and extract back the gathered Product list and the Transactions *)
	gatheredTransactionMaterial=Gather[transposedTransactionProducts][[All, All, 1]];
	gatheredTransactionObjects=Gather[transposedTransactionProducts][[All, All, 2]];

	(* ==define Function:gatherByModelAndObject==*)
	(* Use this helper function to consolidate the lists by sample objects that originate from the same transaction and are from the same material *)
	gatherByModelAndObject[myflatlists_List]:=Module[{material, transactions, transposedLists},

		(*get the model and transaction IDs*)
		material=filtTransactionMaterialObject;
		transactions=filtTransactionObjects;

		(*transpose lists with both the model and transaction ID*)
		transposedLists=Map[Transpose[{material, transactions, #}]&, myflatlists];

		(*gather the lists if model and transaction ID are identical,and extract the gathered list*)
		Map[GatherBy[#, Most][[All, All, 3]]&, transposedLists]
	];

	(* using the helper function, gather notebook,name, prices, date and tag lists *)
	{gatheredTransactionNotebooks, gatheredTransactionName, gatheredTransactionProductPrice, gatheredTransactionTaxPrice, gatheredTransactionDates, gatheredTransactionMaterial}=
		gatherByModelAndObject[{Download[filtTransactionNotebooks, Object], filtTransactionNames, transactionProductPricing, transactionTaxPricing, filtTransactionDates, filtTransactionMaterialObject}];

	(* consolidate the gathered notebook,objects,models,names, dates,and tags list so that there is one item per list. Since they should be identical, the first entry can be taken *)
	(* this can also be done for the receiving pricing since only one receiving cost is applied for each model. The other price lists will be treated differently (see below) *)
	{consolidatedTransactionNotebooks, consolidatedTransactionNames, consolidatedTransactionObjects, consolidatedTransactionMaterial, consolidatedTransactionDates}=Map[
		First /@ # &,
		{gatheredTransactionNotebooks, gatheredTransactionName, gatheredTransactionObjects, gatheredTransactionMaterial, gatheredTransactionDates}
	];

	(*sum up the price for each consolidated transaction entry *)
	{consolidatedTransactionProductPrice, consolidatedTransactionTaxPrice}=Map[
		Function[{pricelist},
			Map[
				If[NullQ[#],
					Null,
					Total[#]
				]&, pricelist
			]
		],
		{gatheredTransactionProductPrice, gatheredTransactionTaxPrice}
	];

	(*count the number of objects for a particular model and a particular transaction*)
	consolidatedTransactionAmounts=Length /@ gatheredTransactionObjects;

	(* calculate the price per unit by dividing the summed price by the amount of items in the transaction *)
	{consolidatedTransactionProductPricingRate, consolidatedTransactionTaxPricingRate}=Map[
		(# / consolidatedTransactionAmounts)&,
		{consolidatedTransactionProductPrice, consolidatedTransactionTaxPrice}
	];

	(*--- PART 4: Construct the final lists for the output tables. Since each price ist listed as an individual row entry, this is done by joining all prices into one big list and constructing the other lists accordingly---*)

	(*join all transaction price lists:product price,tax price,and stocking&receiving price,and delete list items where the price is Null*)
	(*Null entries originate from Transaction[DropShipping] and Transaction[ShipToECL] since there are no Product and Tax prices associated*)
	allTransactionPrices=Join[consolidatedTransactionProductPrice, consolidatedTransactionTaxPrice];

	(*make a boolean for Null entries,these will be filtered out in all other indexmatched lists*)
	transactionPriceNotNullBool=Map[If[NullQ[#], False, True]&, allTransactionPrices];

	(*filter the transaction price list for those entries where the price is not Null*)
	totalTransactionPrices=PickList[allTransactionPrices, transactionPriceNotNullBool, True];

	(*join all transaction price per units and filter for those entries where the price is not Null*)
	totalTransactionPricePerUnit=PickList[Join[consolidatedTransactionProductPricingRate, consolidatedTransactionTaxPricingRate], transactionPriceNotNullBool, True];

	(*join all transaction notebooks,objects,product models,model names.These are identical for all 2 lists (1 list for the product price, 1 list for the tax price).Filter for those entries where the price is not Null*)
	{totalTransactionNotebooks, totalTransactionObjects, totalTransactionMaterial, totalTransactionNames, totalTransactionAmounts, totalTransactionDates}=Map[
		PickList[Join[#, #], transactionPriceNotNullBool, True]&,
		{consolidatedTransactionNotebooks, consolidatedTransactionObjects, consolidatedTransactionMaterial, consolidatedTransactionNames, consolidatedTransactionAmounts, consolidatedTransactionDates}
	];

	(*construct the tag list,which consists of a list of Product strings,tax strings *)
	totalTransactionTags=PickList[
		Join[ConstantArray["Product List Price", Length[consolidatedTransactionObjects]],
			ConstantArray["Product Tax", Length[consolidatedTransactionObjects]]
		],
		transactionPriceNotNullBool, True
	];

	(*lookup up the site for each transaction so we can add it to the output*)
	totalTransactionSites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,allTransactionPackets],
				Destination],
			Object]&,
		totalTransactionObjects];

	(* join all the lists into one output *)
	totalTransactionOutput={
		totalTransactionNotebooks, totalTransactionObjects, totalTransactionMaterial, totalTransactionNames, totalTransactionTags, totalTransactionAmounts,
		totalTransactionPricePerUnit, totalTransactionPrices, totalTransactionDates, totalTransactionSites
		}

];

(* ::Subsubsection::Closed:: *)
(*missingProductTask (private) *)

Authors[missingProductTask]={"dima"};

(* helper function to make tasks to address missing pricing information for Materials that were  *)
missingProductTask[objects_, ops:OptionsPattern[]]:=Module[
	{asanaPacket, body},

	(* construct the body of the task *)
	body = StringJoin[Flatten@{
		"The following materials are missing their Product or Price (for StockSolution):",
		{"\n",ToString[#]}&/@objects
	}];

	asanaPacket=<|
			Name -> "Materials are missing pricing information",
			Completed -> False,
			Notes -> body,
			Followers -> billingTeam,
			Projects -> {"Business Operations"},
			Tags -> {"P5"},
			DueDate -> (Now + 3 Day)
		|>;

	(* create the asana task or output the packet if we are on test db *)
	If[ProductionQ[]&&MatchQ[$PersonID, Object[User, Emerald, Developer, "id:vXl9j57W0PqJ"]],
		ECL`CreateAsanaTask[asanaPacket],
		asanaPacket
	]
];



(* ::Subsection:: *)
(*PriceTransactions*)

Authors[PriceTransactions]={"alou", "robert", "dima"};

(* ::Subsubsection::Closed:: *)
(*PriceTransactions*)


DefineOptions[PriceTransactions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching TransactionsPriceTableP with the same information, or a combined price of all materials costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | TransactionPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Source, Material, or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];


(* Singleton Transaction and Protocol overload *)
PriceTransactions[mySource:ObjectP[Object[Transaction]], ops:OptionsPattern[]]:=PriceTransactions[{mySource}, ops];

(* Listed Transaction and Protocol (and empty list) overload ---> Passes to CORE helper function *)
PriceTransactions[mySources:{ObjectP[Object[Transaction]]...}, ops:OptionsPattern[]]:=priceTransactionsCore[mySources, Null, ops];

(* Singleton Notebook overload with no date range *)
PriceTransactions[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceTransactions[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* Singleton Notebook overload with date range *)
PriceTransactions[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceTransactions[{myNotebook}, myDateRange, ops];

(* Reverse listable Notebook overload with no date range *)
PriceTransactions[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceTransactions[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Notebook overload with date range ---> Passes to CORE helper function *)
PriceTransactions[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, alternativesNotebooks, sortedDateRange, startDate, endDate, endDateWithTime, allSources, allCorrectOrders, allShipToECLDropShipping, allShipToUser},

	(* get the safe options *)
	safeOps=SafeOptions[PriceTransactions, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* allTransactions = Search[{Object[Transaction,Order],Object[Transaction,DropShipping],Object[Transaction,ShipToECL]}, Status == Received && Notebook == alternativesNotebooks && DateDelivered > startDate && DateDelivered < endDateWithTime]; *)
	(* THIS IS A TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTSION CURRENTLY *)
	allShipToECLDropShipping=Search[
		{Object[Transaction, DropShipping], Object[Transaction, ShipToECL]},
		Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];
	allCorrectOrders=Search[
		{Object[Transaction, Order]},
		Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* get all the completed shipping transactions in these notebooks *)
	allShipToUser=Search[
		Object[Transaction, ShipToUser],
		DateShipped > startDate && DateShipped < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* combine all transactions and protocols into one list *)
	allSources=Join[allShipToECLDropShipping, allCorrectOrders, allShipToUser];

	(* pass all the transactions and protocols found in these notebooks to the core function *)
	priceTransactionsCore[allSources, myDateRange, safeOps]

];


(* Singleton Team overload with no date range *)
PriceTransactions[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceTransactions[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* Singleton Team overload with date range *)
PriceTransactions[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceTransactions[{myTeam}, myDateRange, ops];

(* Reverse listable Team overload with no date range*)
PriceTransactions[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceTransactions[myTeams, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Team overload with date range ---> Passes to CORE helper function *)
PriceTransactions[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps,now,today,sortedDateRange,startDate,endDate,endDateWithTime,alternativesTeams,allNotebooks,alternativesNotebooks,
		allSources,allCorrectOrders,allShipToECLDropShipping,allShipToUser,allSiteToSite},

	(* get the safe options *)
	safeOps=SafeOptions[PriceTransactions, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the received transactions in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no transactions *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	(* allTransactions = If[MatchQ[allNotebooks, {}],
		{},
		Search[{Object[Transaction,Order],Object[Transaction,DropShipping],Object[Transaction,ShipToECL]}, Status == Received && Notebook == alternativesNotebooks && DateDelivered > startDate && DateDelivered < endDateWithTime]
	]; *)
	(* THIS IS A TEMPORARY HACK: WE SEARCH FOR TRANSACTION ORDERS THAT HAVE PRODUCTS FIELD POPULATED, SO WE IGNORE INTERNAL TRANSACTSION CURRENTLY *)
	allShipToECLDropShipping=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Transaction, DropShipping], Object[Transaction, ShipToECL]},
			Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];
	allCorrectOrders=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Transaction, Order]},
			Status == Received && DateDelivered > startDate && DateDelivered < endDateWithTime && Products != Null,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* get all the completed shipping transactions protocols in these notebooks *)
	allShipToUser=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			Object[Transaction, ShipToUser],
			DateShipped > startDate && DateShipped < endDateWithTime,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* get all the completed site-to-site transactions in these notebooks *)
	allSiteToSite=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			Object[Transaction, SiteToSite],
			DateShipped > startDate && DateShipped < endDateWithTime,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* combine all transactions and protocols into one list *)
	allSources=Join[allShipToECLDropShipping, allCorrectOrders, allShipToUser, allSiteToSite];

	(* pass all the transactions and protocols found in these notebooks to the core function *)
	priceTransactionsCore[allSources, myDateRange, safeOps]

];



(* ::Subsubsection::Closed:: *)
(* priceTransactionsCore (private) *)


(* --- CORE HELPER FUNCTION --- *)

(* This function is called by the the reverse-listable Transaction, Notebook, and Team overloads *)
(* It uses priceTransactionsToECL and priceTransactionsToUser helper functions (price stocking is now its own thing) to gather receiving/handling/shipping/stocking pricing information from all transactions and protocols, and then produces an output format displaying the combined pricing information *)
(* The inputs are lists of materials sources (transactions and protocols), and start and end date (or Null if called by the Protocol/Transaction overload) *)
(* The output is (depending on the OutputFormat option) either an association matching TransactionsPriceTableP or table(s) displaying the pricing information (such as notebook, samples, names, prices, etc.), or a total price of the materials *)


priceTransactionsCore[
	mySources:{ObjectP[Object[Transaction]]...},
	myDateRange:Span[_?DateObjectQ, _?DateObjectQ] | Null,
	ops:OptionsPattern[]
]:=Module[
	{
		safeOps,output,cache,consolidation,allTransactionShipToUser,allTransactionsOrder,allTransactionsShipToECL,allTransactions,
		allDownloadValues,allTransactionsDropShipping,allTransactionOrderDownloadValues,allTransactionDropShippingDownloadValues,
		allTransactionSendingDownloadValues,allTransactionDownloadValues,
		outputTransactionsToECL,outputTransactionsToUser,joinedNotebooks,joinedSources,joinedSamples,joinedNames,joinedNamesNoNull,
		joinedAmounts,joinedPricingRate,joinedPrice,joinedDate,joinedTags,outputListsSortedByMaterials,pricingOutputOrderPriority,
		outputListsSortedByPricing,outputListsSortedBySources,sortedNotebooks,sortedSources,sortedSamples,sortedNames,sortedAmounts,
		sortedPricingRate,sortedPrice,sortedDate,sortedTags,transposedOutputs,allDataTable,associationDataTable,
		associationOutput,tableOutput,noNotebookDataTable,noTransactionDataTable,gatheredByNotebook,
		notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,gatheredByTransaction,transactionConsolidatedPreTotal,
		transactionConsolidatedTotals,transactionConsolidatedTable,gatheredByMaterial,materialConsolidatedPreTotal,materialConsolidatedTotals,materialConsolidatedTable,
		numNotebooks,numTrans,dataTableToUse,totalInputPrice,subtotalRows,dataWithSubtotal,columnHeaders,dataTableDateCompleted,tableTitle,
		allTransactionShipToUserDownloadValues,startDate,endDate,now,joinedWeight,joinedTax,sortedTax,sortedWeight,
		allTransactionsSiteToSite,allTransactionSiteToSiteDownloadValues,joinedSites,sortedSites},

	(* ------------ *)
	(* -- Set up -- *)
	(* ------------ *)

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceTransactions, ToList[ops]];
	{output, consolidation, cache}=Lookup[safeOps, {OutputFormat, Consolidation, Cache}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		{First[Sort[myDateRange]], Last[Sort[myDateRange]]}
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* sort the input into transactions and the transactions also into the Transaction types *)
	(* `allTransactions` is going to be sorted by Type 1) DropShipping 2) Order 3) ShipToECL *)

	allTransactionShipToUser=Sort[Cases[mySources, ObjectP[{Object[Transaction, ShipToUser]}]]];
	allTransactionsOrder=Sort[Cases[mySources, ObjectP[{Object[Transaction, Order]}]]];
	allTransactionsDropShipping=Sort[Cases[mySources, ObjectP[{Object[Transaction, DropShipping]}]]];
	allTransactionsShipToECL=Sort[Cases[mySources, ObjectP[{Object[Transaction, ShipToECL]}]]];
	allTransactionsSiteToSite=Sort[Cases[mySources, ObjectP[{Object[Transaction, SiteToSite]}]]];
	allTransactions=Sort[Cases[mySources, ObjectP[{Object[Transaction, DropShipping], Object[Transaction, Order], Object[Transaction, ShipToECL], Object[Transaction, SiteToSite]}]]];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* download all the information from the transactions *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not sample resources and we need to distinguish these cases *)
	allDownloadValues=Quiet[
		Download[
			{
				allTransactionShipToUser,
				allTransactionsOrder,
				allTransactionsDropShipping,
				allTransactionsShipToECL,
				allTransactionsSiteToSite,
				allTransactions
			},
			{
				(*SHIPTOUSER PACKETS*)
				{
					(* the transaction packet itself; everything we need whether the transaction is pending or shipped *)
					(*1*)Packet[
					Status, ShippingSpeed, Aliquot, ShippingContainers, SecondaryContainers, PlateSeals, Ice, Shipper, Source, Destination,
					DryIce, Padding, ShippingPrice, SamplePreparationProtocols, DryIceMasses, PaddingMasses, DateCreated, Notebook],

					(* TS Report packets against the transaction *)
					(*2*)Packet[UserCommunications[{Refund}]],

					(* for estimating of shipping cost; want rough size of shipping containers, and addresses of source/destination *)
					(*3*)Packet[ShippingContainers[{Dimensions}]],
					(*4*)Packet[Source[{}]],
					(*5*)Packet[Destination[{PostalCode}]],

					(* product packets for the shipping stuff, as if the transaction is Pending and they are still Models *)
					(*6*)Packet[ShippingContainers[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*7*)Packet[SecondaryContainers[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*8*)Packet[PlateSeals[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*9*)Packet[Ice[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*10*)Packet[DryIce[Products][{Name, Price, Amount, ProductModel, NumberOfItems}]],
					(*11*)Packet[Padding[Products][{Name, Price, Amount, ProductModel, NumberOfItems}]],

					(* as if the transaction is Shipped and they are all Samples; need sample packets too to jump to Model *)
					(*12*)Packet[ShippingContainers[{Model}]],
					(*13*)Packet[SecondaryContainers[{Model}]],
					(*14*)Packet[PlateSeals[{Model}]],
					(*15*)Packet[Ice[{Model}]],
					(*16*)Packet[DryIce[{Model}]],
					(*17*)Packet[Padding[{Model}]],

					(* as if the transaction is Shipped and they are all Samples; get Product right from samples *)
					(*18*)Packet[ShippingContainers[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*19*)Packet[SecondaryContainers[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*20*)Packet[PlateSeals[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*21*)Packet[Ice[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*22*)Packet[DryIce[Product][{Name, Price, Amount, NumberOfItems, ProductModel}]],
					(*23*)Packet[Padding[Product][{Name, Price, Amount, NumberOfItems, ProductModel}]],

					(* get the model of shipping used *)
					(*24*)Packet[Source[Model][ShippingModel][{HandlingPrice, AliquotPrice}]],

					(* ==================================================== *)
					(* == SamplePreparationProtocols: SampleManipulation == *)
					(* ==================================================== *)

					(* ---  for PriceMaterials on the Aliquot subprotocols ---  *)

					(* NOTE: we CANNOT use SubprotocolRequiredResources field like PriceMaterials/PriceInstrumentTime because the aliquot protocols are SUB protocols; this field is only populated in root protocols;
						have to manually find resource packets in all places they may be, including Aliquot-specific program objects. That's why this is so shitty. *)
					(* protocol packets we will need to send any aliquot prep protocols to PriceMaterials (NOTE we also get WasteGenerated for PriceWaste) *)

					(* -- A. General packet for SM sub (25) --*)
					(*25 - 1*)Packet[SamplePreparationProtocols[{Notebook, ParentProtocol, Status, DateCompleted, WasteGenerated, Site}]],

					(* -- B. Resources details (26 - 53) -- *)
					(* resource packets themselves (NOTE we are also getting extra fields for PriceInstrumentTime here which also wants the resource packets) *)
					(*26 - 2*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*27 - 3*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*28 - 4*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*29 - 5*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],

					(* resource product packets *)
					(*30 - 6*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*31 - 7*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*32 - 8*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*33 - 9*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],

					(* resource sample packets *)
					(*34 - 10*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][{Product}]],
					(*35 - 11*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][{Product}]],
					(*36 - 12*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][{Product}]],
					(*37 - 13*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][{Product}]],

					(* resource sample model packets *)
					(*38 - 14*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*39 - 15*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*40 - 16*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*41 - 17*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],

					(* product container model packets *)
					(*42 - 18*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*43 - 19*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*44 - 20*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*45 - 21*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],

					(* product model packets *)
					(*46 - 22*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*47 - 23*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*48 -24*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*49 - 25*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],

					(* default storage condition packets *)
					(*50 - 26*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*51 - 27*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*52 - 28*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*53 - 29*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],

					(* -- C. Site tax rate (54) -- *)
					(* site model packets *)
					(*54 - 30*)Packet[SamplePreparationProtocols[Site][Model][{SalesTaxRate}]],

					(* -- D.  for PriceInstrumentTime on the Aliquot SM subprotocols (55-58) --- *)

					(* we already got all protocol packets, ts report packets, and resource packets for PriceMaterials; need instrument model packets from resources only *)
					(*55 - 31*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*56 - 32*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*57 - 33*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*58 - 34*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],

					(* -- E. for PriceWaste on the Aliquot SM subprotocols (59-61) --- *)

					(* we already got all protocol packets, ts report packets for PriceMaterials; need waste generated packets and subprotocol packets *)
					(*59 - 35*)Packet[SamplePreparationProtocols[Repeated[Subprotocols]][WasteGenerated]],
					(*60 - 36*)Packet[SamplePreparationProtocols[WasteGenerated][[All, Waste]][{PricingRate, Name}]],
					(*61 - 37*)Packet[SamplePreparationProtocols[Repeated[Subprotocols]][WasteGenerated][[All, Waste]][{PricingRate, Name}]],

					(* =============================== *)
					(* == SamplePreparation packets == *)
					(* =============================== *)


					(* -- B. Resources details (XX - XX) -- *)
					(* resource packets themselves (NOTE we are also getting extra fields for PriceInstrumentTime here which also wants the resource packets) *)
					(*62 - 1*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*63 -2*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],

					(* resource product packets *)
					(*64 - 3*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*65 - 4*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],


					(* resource sample packets *)
					(*66 - 5*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][{Product}]],
					(*67 - 6*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][{Product}]],

					(* resource sample model packets *)
					(*68 - 7*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*69 - 8*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],

					(* product container model packets *)
					(*70 - 9*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*71 - 10*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],


					(* product model packets *)
					(*72 - 11*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*73 - 12*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],

					(* default storage condition packets *)
					(*74 - 13*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*75- 14*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],

					(* -- D.  for PriceInstrumentTime on the Aliquot SM subprotocols (78 - 82) --- *)

					(* we already got all protocol packets, ts report packets, and resource packets for PriceMaterials; need instrument model packets from resources only *)
					(*76 - 15*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*77 - 16*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],


					(* -- Bill fields --- *)
					(*these are needed for priceIntrumentTimeProtocols*)
					(*78*)Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, InstrumentPricing, IncludedInstrumentHours, Site}]]
				},

				(* == ORDER PACKETS ==*)
				(*these are the packets of the Transaction.Order inputs*)

				{
					Packet[Products[ProductModel][{State, Name, DefaultStorageCondition, Tablet}]],
					Packet[Products, Models, InternalOrder, OrderQuantities],
					Packet[Products[{NumberOfItems, Price, UsageFrequency, DefaultContainerModel, ProductModel, Name}]],
					Packet[Products[DefaultContainerModel][Dimensions]],
					Packet[Products[ProductModel][Dimensions]],
					Packet[Products[ProductModel][DefaultStorageCondition][StockingPrices]],
					Packet[Destination[Model][SalesTaxRate]]
				},

				(* == DROPSHIPPING PACKETS == *)
				(*these are the packets of the Transaction.DropShipping inputs*)

				{
					Packet[Models],
					Packet[Models[{State, Name, Tablet}]]
				},

				(* == SHIPTOECL PACKETS == *)
				(*these are the packets of the Transaction.ShipToECL inputs*)
				{
					Packet[SamplesOut[Model][{State, Name, Tablet}]],
					Packet[SamplesOut[Model]],
					Packet[ContainersOut[Model]],
					Packet[ContainersOut[Model][{Name}]],
					Packet[ReceivedSamples[Model]],
					Packet[ReceivedSamples[Model][{Name}]]
				},

				(* == SiteToSite fields - combination of ShipToECL and ShipToUser == *)
				(* these are the packets of the Transaction.SiteToSite inputs *)
				{
					(* the transaction packet itself; everything we need whether the transaction is pending or shipped *)
					(*1*)Packet[
					Status, ShippingSpeed, Aliquot, ShippingContainers, SecondaryContainers, PlateSeals, Ice, Shipper, Source, Destination,
					DryIce, Padding, ShippingPrice, SamplePreparationProtocols, DryIceMasses, PaddingMasses, DateCreated, Notebook],

					(* TS Report packets against the transaction *)
					(*2*)Packet[UserCommunications[{Refund}]],

					(* for estimating of shipping cost; want rough size of shipping containers, and addresses of source/destination *)
					(*3*)Packet[ShippingContainers[{Dimensions}]],
					(*4*)Packet[Source[{}]],
					(*5*)Packet[Destination[{PostalCode}]],

					(* product packets for the shipping stuff, as if the transaction is Pending and they are still Models *)
					(*6*)Packet[ShippingContainers[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*7*)Packet[SecondaryContainers[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*8*)Packet[PlateSeals[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*9*)Packet[Ice[Products][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*10*)Packet[DryIce[Products][{Name, Price, Amount, ProductModel, NumberOfItems}]],
					(*11*)Packet[Padding[Products][{Name, Price, Amount, ProductModel, NumberOfItems}]],

					(* as if the transaction is Shipped and they are all Samples; need sample packets too to jump to Model *)
					(*12*)Packet[ShippingContainers[{Model}]],
					(*13*)Packet[SecondaryContainers[{Model}]],
					(*14*)Packet[PlateSeals[{Model}]],
					(*15*)Packet[Ice[{Model}]],
					(*16*)Packet[DryIce[{Model}]],
					(*17*)Packet[Padding[{Model}]],

					(* as if the transaction is Shipped and they are all Samples; get Product right from samples *)
					(*18*)Packet[ShippingContainers[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*19*)Packet[SecondaryContainers[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*20*)Packet[PlateSeals[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*21*)Packet[Ice[Product][{Name, Price, ProductModel, Amount, NumberOfItems}]],
					(*22*)Packet[DryIce[Product][{Name, Price, Amount, NumberOfItems, ProductModel}]],
					(*23*)Packet[Padding[Product][{Name, Price, Amount, NumberOfItems, ProductModel}]],

					(* get the model of shipping used *)
					(*24*)Packet[Source[Model][ShippingModel][{HandlingPrice, AliquotPrice}]],

					(* ==================================================== *)
					(* == SamplePreparationProtocols: SampleManipulation == *)
					(* ==================================================== *)

					(* ---  for PriceMaterials on the Aliquot subprotocols ---  *)

					(* NOTE: we CANNOT use SubprotocolRequiredResources field like PriceMaterials/PriceInstrumentTime because the aliquot protocols are SUB protocols; this field is only populated in root protocols;
						have to manually find resource packets in all places they may be, including Aliquot-specific program objects. That's why this is so shitty. *)
					(* protocol packets we will need to send any aliquot prep protocols to PriceMaterials (NOTE we also get WasteGenerated for PriceWaste) *)

					(* -- A. General packet for SM sub (25) --*)
					(*25 - 1*)Packet[SamplePreparationProtocols[{Notebook, ParentProtocol, Status, DateCompleted, WasteGenerated, Site}]],

					(* -- B. Resources details (26 - 53) -- *)
					(* resource packets themselves (NOTE we are also getting extra fields for PriceInstrumentTime here which also wants the resource packets) *)
					(*26 - 2*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*27 - 3*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*28 - 4*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*29 - 5*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],

					(* resource product packets *)
					(*30 - 6*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*31 - 7*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*32 - 8*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*33 - 9*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],

					(* resource sample packets *)
					(*34 - 10*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][{Product}]],
					(*35 - 11*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][{Product}]],
					(*36 - 12*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][{Product}]],
					(*37 - 13*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][{Product}]],

					(* resource sample model packets *)
					(*38 - 14*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*39 - 15*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*40 - 16*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*41 - 17*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],

					(* product container model packets *)
					(*42 - 18*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*43 - 19*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*44 - 20*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*45 - 21*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],

					(* product model packets *)
					(*46 - 22*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*47 - 23*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*48 -24*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*49 - 25*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],

					(* default storage condition packets *)
					(*50 - 26*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*51 - 27*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*52 - 28*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*53 - 29*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],

					(* -- C. Site tax rate (54) -- *)
					(* site model packets *)
					(*54 - 30*)Packet[SamplePreparationProtocols[Site][Model][{SalesTaxRate}]],

					(* -- D.  for PriceInstrumentTime on the Aliquot SM subprotocols (55-58) --- *)

					(* we already got all protocol packets, ts report packets, and resource packets for PriceMaterials; need instrument model packets from resources only *)
					(*55 - 31*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*56 - 32*)Packet[SamplePreparationProtocols[MacroTransfers][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*57 - 33*)Packet[SamplePreparationProtocols[SolventTransfers][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*58 - 34*)Packet[SamplePreparationProtocols[DispensingPrograms][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],

					(* -- E. for PriceWaste on the Aliquot SM subprotocols (59-61) --- *)

					(* we already got all protocol packets, ts report packets for PriceMaterials; need waste generated packets and subprotocol packets *)
					(*59 - 35*)Packet[SamplePreparationProtocols[Repeated[Subprotocols]][WasteGenerated]],
					(*60 - 36*)Packet[SamplePreparationProtocols[WasteGenerated][[All, Waste]][{PricingRate, Name}]],
					(*61 - 37*)Packet[SamplePreparationProtocols[Repeated[Subprotocols]][WasteGenerated][[All, Waste]][{PricingRate, Name}]],

					(* =============================== *)
					(* == SamplePreparation packets == *)
					(* =============================== *)


					(* -- B. Resources details (XX - XX) -- *)
					(* resource packets themselves (NOTE we are also getting extra fields for PriceInstrumentTime here which also wants the resource packets) *)
					(*62 - 1*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],
					(*63 -2*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][{Status, Amount, Purchase, Sample, Time, EstimatedTime, Instrument}]],

					(* resource product packets *)
					(*64 - 3*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],
					(*65 - 4*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][{Name, CatalogNumber, Price, NumberOfItems, Amount, CountPerSample, UsageFrequency, DefaultContainerModel}]],


					(* resource sample packets *)
					(*66 - 5*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][{Product}]],
					(*67 - 6*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][{Product}]],

					(* resource sample model packets *)
					(*68 - 7*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],
					(*69 - 8*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Model][{Name, DefaultStorageCondition}]],

					(* product container model packets *)
					(*70 - 9*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],
					(*71 - 10*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][DefaultContainerModel][{Dimensions}]],


					(* product model packets *)
					(*72 - 11*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],
					(*73 - 12*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Product][ProductModel][{Dimensions}]],

					(* default storage condition packets *)
					(*74 - 13*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],
					(*75- 14*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Sample][Model][DefaultStorageCondition][{StockingPrices}]],

					(* -- D.  for PriceInstrumentTime on the Aliquot SM subprotocols (78 - 82) --- *)

					(* we already got all protocol packets, ts report packets, and resource packets for PriceMaterials; need instrument model packets from resources only *)
					(*76 - 15*)Packet[SamplePreparationProtocols[RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],
					(*77 - 16*)Packet[SamplePreparationProtocols[Subprotocols..][RequiredResources][[All, 1]][Instrument][Model][{Name, PricingRate, PricingCategory, PricingLevel}]],


					(* -- Bill fields --- *)
					(*these are needed for priceIntrumentTimeProtocols*)
					(*78*)Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, InstrumentPricing, IncludedInstrumentHours, Site}]],

					(*79*)Packet[SamplesOut[Model][{State, Name, Tablet}]],
					(*80*)Packet[SamplesOut[Model]],
					(*81*)Packet[ContainersOut[Model]],
					(*82*)Packet[ContainersOut[Model][{Name}]],
					(*83*)Packet[ReceivedSamples[Model]],
					(*84*)Packet[ReceivedSamples[Model][{Name}]]
				},

				(* == GENERAL TRANSACTION PACKETS == *)
				(*these are the packets of all transaction inputs*)

				{
					Packet[Destination, Source, Notebook, Status, DateDelivered, Fulfillment, (* New stuff *)SupplierOrder],
					Packet[Destination[Model][ReceivingModel][{ReceivingPrice, MeasureVolumePrice, MeasureWeightPrice, MeasureCountPrice}]],
					Packet[SupplierOrder[Notebook]]
				}
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}];

	(* get all the individual Download Packets from the big Download Call *)
	allTransactionShipToUserDownloadValues=Part[allDownloadValues, 1];
	allTransactionOrderDownloadValues=Part[allDownloadValues, 2];
	allTransactionDropShippingDownloadValues=Part[allDownloadValues, 3];
	allTransactionSendingDownloadValues=Part[allDownloadValues, 4];
	allTransactionSiteToSiteDownloadValues=Part[allDownloadValues, 5];
	allTransactionDownloadValues=Part[allDownloadValues, 6];


	(* ------------------------------ *)
	(* -- compute pricing per type -- *)
	(* ------------------------------ *)

	(* get the output lists from:
		\[Bullet]priceTransactionsToECL (Transaction Orders, Transaction ShipToECL, Transaction DropShipping, receiving part of the TransactionSiteToSite)
		\[Bullet]priceTransactionsToUser (Transaction ShipToUser, sending part of the Transaction SiteToSite)

	each output contains the following lists in that exact order:
		\[Bullet]notebooks
		\[Bullet]sources
		\[Bullet]objects
		\[Bullet]names
		\[Bullet]price-categories
		\[Bullet]amounts
		\[Bullet]pricePerUnits
		\[Bullet]prices
		\[Bullet]dates
		\[Bullet]sites
	 *)
	outputTransactionsToECL=If[
		And[
			MatchQ[allTransactionOrderDownloadValues,{}],
			MatchQ[allTransactionDropShippingDownloadValues,{}],
			MatchQ[allTransactionSendingDownloadValues,{}],
			MatchQ[allTransactionSiteToSiteDownloadValues,{}]
		],
		ConstantArray[{},12],
		priceTransactionsToECL[
			allTransactionOrderDownloadValues,
			allTransactionDropShippingDownloadValues,
			allTransactionSendingDownloadValues,
			allTransactionSiteToSiteDownloadValues,
			allTransactionDownloadValues
		]
	];

	(*TODO: this is a really bad temporary fix while I repair the other functions. Need to get the actual weight and price*)
	(* get pricing for Object[Transaction, ShipToUser] *)
	(*priceTransactionsToUser does all the things that it needs - price for materials, handling, shipping and aliquoting*)
	(*last 2 elements that we are adding here are weight (weight of the samples+shipping materials?) and tax*)
	outputTransactionsToUser=If[MatchQ[allTransactionShipToUserDownloadValues, {}]&&MatchQ[allTransactionSiteToSiteDownloadValues, {}],
		ConstantArray[{},12],
		Module[{pricedData},
			pricedData=priceTransactionsToUser[
				Join[allTransactionShipToUserDownloadValues,allTransactionSiteToSiteDownloadValues],
				allTransactionDownloadValues];
			If[MatchQ[pricedData, {}],
				ConstantArray[{},11],
				Transpose[
					Map[
						If[MatchQ[#, _List],
							Join[#, {0 Kilogram, 0 USD}],
							#
						]&,
						Values[pricedData]
					]
				]
			]]
	];

	(* ------------------------------- *)
	(* -- Collect and format output -- *)
	(* ------------------------------- *)

	(* return $Failed if any of the outputs returned as $Failed *)
	(* since we're mapping over several outputs, we need to put Return[$Failed, Module] in order to exit from the Module and not return a list *)
	Map[
		If[MatchQ[#, $Failed],
			Return[$Failed, Module],
			#
		]&,
		{outputTransactionsToECL, outputTransactionsToUser}
	];

	(* transpose the outputs such that corresponding lists are grouped together (notebooks with notebooks, transactions with transactions, etc.) *)
	transposedOutputs=Transpose[{outputTransactionsToECL, outputTransactionsToUser}];

	(* extract the individual output lists that will serve as input for the output table *)
	{
		joinedNotebooks,
		joinedSources,
		joinedSites,
		joinedSamples,
		joinedNames,
		joinedTags,
		joinedAmounts,
		joinedPricingRate,
		joinedPrice,
		joinedDate,
		joinedWeight,
		joinedTax
	}=Map[
		Flatten[transposedOutputs[[#]]] &, Range[Length[outputTransactionsToECL]]];

	(* add the Model ID instead of the name in case we don't have a Name *)
	joinedNamesNoNull=MapThread[
		If[NullQ[#2],
			ToString[#1[ID]],
			#2
		]&,
		{joinedSources, joinedNames}
	];

	(* transpose all output lists and gather by the sources (joinedSources) *)
	outputListsSortedBySources=GatherBy[Transpose[{joinedSamples, joinedNotebooks, joinedSources, joinedNamesNoNull, joinedTags, joinedAmounts, joinedPricingRate, joinedPrice, joinedDate, joinedWeight, joinedTax, joinedSites}], Part[#, 3]&];

	(* gather the source-gathered lists by materials (joinedSamples) *)
	outputListsSortedByMaterials=Flatten[Map[GatherBy[#, First] &, outputListsSortedBySources], 1];

	(* define the order in which we want the pricing categories to appear in the output table (within each material) *)
	pricingOutputOrderPriority={"Stocking", "Receiving", "Shipping", "Handling", "Packaging Materials", "Aliquoting"};

	(* sort the gathered output lists such that the pricing categories are displayed in the desired order *)
	outputListsSortedByPricing=Map[SortBy[#, Position[pricingOutputOrderPriority, #[[5]]]&]&, outputListsSortedByMaterials];

	(* extract the sorted lists and flatten them *)
	{sortedSamples, sortedNotebooks, sortedSources, sortedNames, sortedTags, sortedAmounts, sortedPricingRate, sortedPrice, sortedDate, sortedWeight, sortedTax, sortedSites}=Map[
		Flatten[outputListsSortedByPricing[[All, All, #]]]&,
		Range[Length[outputTransactionsToECL]]
	];

	(* generate the table of items that will be displayed in a table *)
	allDataTable=MapThread[
		Function[{tag, notebook, source, sample, modelname, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				(* delete all the cases where the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {notebook, source, site, sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {notebook, source, site, sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedNotebooks, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedSites}
	];

	(* generate the table of items that will be displayed in an association. Contains additional key with the transactions' DateReceived *)
	associationDataTable=MapThread[
		Function[{tag, notebook, source, sample, modelname, amount, rate, price, dateCompleted, weight, tax, site},
			Switch[{amount, rate},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _}, Nothing,
				{_, Null}, Nothing,
				{_, _}, {notebook, source, site, sample, modelname, tag, amount, rate, price, dateCompleted, weight, tax}
			]
		],
		{sortedTags, sortedNotebooks, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedDate, sortedWeight, sortedTax, sortedSites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null amount or pricing rate removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, amount, rate},
			If[NullQ[amount] || NullQ[rate],
				Nothing,
				date
			]
		],
		{sortedDate, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match TransactionsPriceTableP *)
	associationOutput=
		If[output == Association,
			Map[
				AssociationThread[{Notebook, Source, Site, Material, MaterialName, PricingCategory, Amount, PricePerUnit, Price, DateCompleted, Weight, Tax}, #]&,
				associationDataTable
			],
			Null
		];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{tag, source, sample, modelname, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {source, site, sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {source, site, sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedSources, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedSites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Transaction columns (because all items belong to the same Notebook and Transaction) *)
	(* as opposed to all other Price* functions, we still include Site here since SiteToSite transaction will have charges on both sides *)
	noTransactionDataTable=MapThread[
		Function[{tag, sample, modelname, amount, rate, price, site},
			Switch[{amount, rate, output, consolidation},
				(* the below 2 cases are when the amount used or pricing rate is Null *)
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
				{_, _, Table, Null}, {site, sample, modelname, tag, NumberForm[amount, {\[Infinity], 1}], NumberForm[rate, {\[Infinity], 2}], NumberForm[price, {\[Infinity], 2}]},
				(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
				{_, _, _, _}, {site, sample, modelname, tag, amount, rate, price}
			]
		],
		{sortedTags, sortedSamples, sortedNames, UnitScale[sortedAmounts, Simplify -> False], sortedPricingRate, sortedPrice, sortedSites}
	];

	(* --- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified --- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* group all the rows in the data table by Transaction *)
	gatheredByTransaction=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	transactionConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByTransaction
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	transactionConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		transactionConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	transactionConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{transactionConsolidatedPreTotal, transactionConsolidatedTotals}
	];

	(* group all the rows in the data table by material *)
	gatheredByMaterial=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by material, before we do the Total call *)
	materialConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 9]], Null]}&,
		gatheredByMaterial
	];

	(* get the total for each material *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	materialConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		materialConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	materialConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{materialConsolidatedPreTotal, materialConsolidatedTotals}
	];

	(* ---------------------------- *)
	(* --- Construct the tables --- *)
	(* ---------------------------- *)

	(* get the number of notebooks and number of sources specified in this function *)
	numNotebooks=Length[DeleteDuplicates[sortedNotebooks]];
	numTrans=Length[DeleteDuplicates[sortedSources]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Source columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numTrans},
		(* the below 3 cases are the different consolidated datatables when the Consolidation -> Notebook, Source or Material *)
		{Notebook, _, _}, notebookConsolidatedTable,
		{Source, _, _}, transactionConsolidatedTable,
		{Material, _, _}, materialConsolidatedTable,
		(* when no Consolidation is chosen and only a single Notebook and a single Transaction are present, omit the notebook and Source column *)
		{_, 1, 1}, noTransactionDataTable,
		(* when no Consolidation is chosen and only a single Notebook (with several Sources) are present, omit the notebook column *)
		{_, 1, _}, noNotebookDataTable,
		(* in all other cases, display the entire DataTable *)
		{_, _, _}, allDataTable
	];

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalInputPrice=If[MatchQ[DeleteCases[sortedPrice, Null], {}],
		0 * USD,
		Total[DeleteCases[sortedPrice, Null]]
	];

	(* generate the subtotal row with the appropriate number of columns *)
	(* use myStartDate as an indicator whether we are dealing with the team/notebook overload or not *)
	subtotalRows=Switch[{consolidation, numNotebooks, numTrans},
		(* when Consolidation -> Notebook, Source, or Material *)
		{Notebook | Source | Material, _, _}, {{"", ""}, {"Total Price", totalInputPrice}},
		(* when the output is single notebook and a single transaction and both the notebook and transaction columns are omitted *)
		{_, 1, 1}, {{"", "", "", "", "", "", ""}, {"", "", "", "", "", "Total Price", totalInputPrice}},
		(* for protocol/transaction overload, when the output is single notebook and the notebook column is omitted *)
		{_, 1, _}, {{"", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "Total Price", totalInputPrice}},
		(* for protocol/transaction overload, when the entire data table is displayed without omitting any columns *)
		{_, _, _}, {{"", "", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "", "Total Price", totalInputPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numTrans},
		(* the below 3 cases are when Consolidation -> Notebook, Source, or Material *)
		{Notebook, _, _}, {"Notebook", "Price"},
		{Source, _, _}, {"Source", "Price"},
		{Material, _, _}, {"Material Name", "Price"},
		(* when the output is single notebook and a single Source and both the notebook and Source columns are omitted *)
		{_, 1, 1}, {"Site", "Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"},
		(* when the output is single notebook and the notebook column is omitted *)
		{_, 1, _}, {"Source", "Site", "Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"},
		(* when the entire data table is displayed without omitting any columns *)
		{_, _, _}, {"Notebook", "Source", "Site", "Material", "Material Name", "Pricing Category", "Amount", "Price per Unit", "Price"}
	];

	(* make the title for the table *)
	tableTitle=If[NullQ[startDate],
		"Transaction Pricing",
		StringJoin["Transaction Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> tableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalInputPrice
	]
];



(* ::Subsubsection::Closed:: *)
(*priceTransactionsToUser (private) *)

(*because we recursively download Subprotocol, packets may come at any nestedness*)
priceTransactionsToUser[
	(*myTransactionShipToUserPackets:{{({{(PacketP[{Object[], Model[]}] | Null | $Failed)...}} | {(PacketP[{Object[], Model[]}] | Null | $Failed)|_...} | PacketP[{Object[], Model[]}]... | {Null} | Null | $Failed | (___))...}...|___},*)
	myTransactionShipToUserPackets_,
	myTransactionsPackets_,
	ops:OptionsPattern[]
]:=Module[{safeOps,cache,transactionPackets,tsReportPackets,pendingPriceAssociations,shippedPriceAssociations,allPriceAssociations},

	(* get the safe options and pull out the Cache option *)
	safeOps=SafeOptions[PriceTransactions, ToList[ops]];
	cache=Lookup[safeOps, Cache];

	(* get out all of the core transaction packets and ts report packets, first and second index of each tuple *)
	transactionPackets=myTransactionShipToUserPackets[[All, 1]];
	tsReportPackets=myTransactionShipToUserPackets[[All, 2]];

	(* --- begin internal Module for pricing PENDING transactions ---  *)
	pendingPriceAssociations=Module[
		{pendingTransactionsToPricePositions,pendingTransactionPackets,pendingTransactionShippingContainerPackets,pendingTransactionSourcePackets,
			pendingTransactionDestinationPackets,pendingUniqueProductPackets,pendingModelMaintenancePackets,productPacketForModelFunction,
			standaloneMaterialPrices,byAmountMaterialPrices,totalShippingMaterialPrices,handlingPrices,aliquotPrices,sourceShipperShipSpeedBoxModelTuples,
			uniqueSourceShipperShipSpeedBoxModelTuples,shippingPriceReportSearchQueries,relevantPricingReports,pricingReportPackets,shippingPrices,pendingTransactionSites},

		(* get the positions of Pending transactions that do not have any troubleshooting reports with Refund->True against them *)
		pendingTransactionsToPricePositions=MapThread[
			Function[{transactionPacket, tsReportPacketsForTransaction, index},
				If[MatchQ[Lookup[transactionPacket, Status], Pending] && !AnyTrue[Lookup[tsReportPacketsForTransaction, Refund, {}], TrueQ],
					{index},
					Nothing
				]
			],
			{transactionPackets, tsReportPackets, Range[Length[transactionPackets]]}
		];

		(* extract the downloaded tuples we will need to price the Pending transactions *)
		pendingTransactionPackets=Extract[transactionPackets, pendingTransactionsToPricePositions];
		pendingTransactionShippingContainerPackets=Extract[myTransactionShipToUserPackets[[All, 3]], pendingTransactionsToPricePositions];
		pendingTransactionSourcePackets=Extract[myTransactionShipToUserPackets[[All, 4]], pendingTransactionsToPricePositions];
		pendingTransactionDestinationPackets=Extract[myTransactionShipToUserPackets[[All, 5]], pendingTransactionsToPricePositions];
		pendingUniqueProductPackets=DeleteDuplicatesBy[Cases[Flatten[Extract[myTransactionShipToUserPackets[[All, 6;;11]], pendingTransactionsToPricePositions]], PacketP[Object[Product]]], Lookup[#, Object]&];
		pendingModelMaintenancePackets=Extract[myTransactionShipToUserPackets[[All, 24]], pendingTransactionsToPricePositions];

		(* make a quick helper that will let us get the product packet for a given model *)
		productPacketForModelFunction[myModel:ObjectP[Model]]:=SelectFirst[
			pendingUniqueProductPackets,
			MatchQ[Download[Lookup[#, ProductModel], Object], Download[myModel, Object]]&
		];

		(* get the shipping materials price for each Pending transaction; look at each product's price per unit for the shipping materials in the transaction *)
		(* the following fields are just one product<->one item, so we can take Price straight up for any of these *)
		standaloneMaterialPrices=Map[
			Function[transactionPacket,
				Total@Map[
					Function[fieldName,
						Module[{fieldValue, productPackets},

							(* get the field value from the transaction; assume it is Models since we're Pending *)
							fieldValue=Lookup[transactionPacket, fieldName];

							(* for each member of the field (assume list, find the product packet) *)
							productPackets=productPacketForModelFunction /@ fieldValue;

							(* total the price across the product packets *)
							Total[Lookup[productPackets, Price, {}] / (If[NullQ[Lookup[productPackets, Amount]], 1, Lookup[productPackets, Amount]] * Lookup[productPackets, NumberOfItems])]
						]
					],
					{ShippingContainers, SecondaryContainers, PlateSeals, Ice}
				]
			],
			pendingTransactionPackets
		];

		(* price the materials that had amounts; gotta take the amount fields into account *)
		byAmountMaterialPrices=Map[
			Function[transactionPacket,
				Total@MapThread[
					Function[{itemField, amountField},
						Module[{fieldValue, productPackets, pricingRates},

							(* get the field value from the transaction; assume it is Models since we're Pending *)
							fieldValue=Lookup[transactionPacket, itemField];

							(* for each member of the field (assume list, find the product packet) *)
							productPackets=productPacketForModelFunction /@ fieldValue;

							(* get the pricing rate by amount for each product packet *)
							pricingRates=Map[
								Lookup[#, Price] / (Lookup[#, NumberOfItems] * Lookup[#, Amount])&,
								productPackets
							];

							(* total the price across the product packets, scaling by amount used *)
							Total[Lookup[transactionPacket, amountField] * pricingRates]
						]
					],
					{{DryIce, Padding}, {DryIceMasses, PaddingMasses}}
				]
			],
			pendingTransactionPackets
		];

		(* get the total shipping material cost for each transaction *)
		totalShippingMaterialPrices=If[MatchQ[#, 0], 0 USD, #]& /@ (standaloneMaterialPrices + byAmountMaterialPrices);

		(* the handling price is just what's in each model maintennace *)
		handlingPrices=Lookup[pendingModelMaintenancePackets, HandlingPrice, {}];

		(* the aliquot prices are just the estimated aliquot prices for anything with Aliquot->True *)
		aliquotPrices=MapThread[
			Function[{transactionPacket, modelMaintenancePacket},
				If[TrueQ[Lookup[transactionPacket, Aliquot]],
					Lookup[modelMaintenancePacket, AliquotPrice],
					0 USD
				]
			],
			{pendingTransactionPackets, pendingModelMaintenancePackets}
		];

		(* determine the unique combinations of boxes/sources/shipping speeds/shippers that we are deailng with; needed to get shipping price reports  *)
		sourceShipperShipSpeedBoxModelTuples=Flatten[MapThread[
			Function[{transactionPacket, shippingContainerModelPackets, sourceSitePacket},
				Map[
					{Lookup[sourceSitePacket, Object], Download[Lookup[transactionPacket, Shipper], Object], Lookup[transactionPacket, ShippingSpeed], Lookup[#, Object]}&,
					shippingContainerModelPackets
				]
			],
			{pendingTransactionPackets, pendingTransactionShippingContainerPackets, pendingTransactionSourcePackets}
		], 1];
		uniqueSourceShipperShipSpeedBoxModelTuples=DeleteDuplicates[sourceShipperShipSpeedBoxModelTuples];

		(* construct search queries for EACH of the unique combos *)
		shippingPriceReportSearchQueries=Map[
			Source == #[[1]] && Shipper == #[[2]] && ShippingSpeed == #[[3]] && BoxModel == #[[4]]&,
			uniqueSourceShipperShipSpeedBoxModelTuples
		];

		(* use MapThread search to get report objects for each of our queries; we just want all of these in a pool, so flatten for downloading info *)
		relevantPricingReports=DeleteDuplicates[Flatten[
			With[
				{queries=shippingPriceReportSearchQueries},
				Search[ConstantArray[Object[Report, ShippingPrices], Length[queries]], queries]
			]
		]];

		(* download packets for the pricing reports; need to download the fields we used to triangulate the right ones, since we've pooled together for use as lookup;
			WAY faster to only do this second download if we happen to have pending transactions, as opposed to searching for ALL pricing reports and downloading ALL of them in case needed *)
		pricingReportPackets=Download[
			relevantPricingReports,
			Packet[DateCreated, ShippingPrices, Source, Shipper, ShippingSpeed, BoxModel],
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		];

		(* estimate shipper cost by using values that would most affect it; shipping speed, start/end points, package size *)
		shippingPrices=MapThread[
			Function[{transactionPacket, shippingContainerModelPackets, sourceSitePacket, destinationSitePacket},
				Module[{sourceSite, destinationZIP, shippingSpeed, shipper, boxPrices},

					(* assign some local variables for useful bits of info for accessing correct shipping price report, getting values out *)
					sourceSite=Lookup[sourceSitePacket, Object];
					destinationZIP=Lookup[destinationSitePacket, PostalCode];
					shippingSpeed=Lookup[transactionPacket, ShippingSpeed];
					shipper=Download[Lookup[transactionPacket, Shipper], Object];

					(* for EACH of the shipping container model packets, get the price estimate using the appropriate report shipping price from the lookup outside the larger MapThread *)
					boxPrices=Map[
						Function[boxModelPacket,
							Module[{relevantPricingReportPackets, latestPricingReportPacket, zipToPriceLookup, entryForDestinationZIP},

								(* find all appropriate shipping reports based on the transaction/bx parameters; uniqueSourceShipperShipSpeedBoxModelTuples guarantees we have it *)
								relevantPricingReportPackets=Select[pricingReportPackets,
									And[
										MatchQ[Download[Lookup[#, Source], Object], sourceSite],
										MatchQ[Download[Lookup[#, Shipper], Object], shipper],
										MatchQ[Lookup[#, ShippingSpeed], shippingSpeed],
										MatchQ[Download[Lookup[#, BoxModel], Object], Lookup[boxModelPacket, Object]]
									]&
								];

								(* let's use the most recent one *)
								latestPricingReportPacket=Last[SortBy[relevantPricingReportPackets, Lookup[#, DateCreated]&]];

								(* get the giant table of zip codes and prices assigned as our lookup *)
								zipToPriceLookup=Lookup[latestPricingReportPacket, ShippingPrices];

								(* find the entry with our zip *)
								entryForDestinationZIP=SelectFirst[zipToPriceLookup, MatchQ[Lookup[#, PostalCode], destinationZIP]&];

								(* get its price; this is our estimate for the price of shipping this box according to the info in the pending transaction *)
								Lookup[entryForDestinationZIP, Price]
							]
						],
						shippingContainerModelPackets
					];

					(* the total estimated price for the transaction is simply the total of all the individual box prices *)
					Total[boxPrices]
				]
			],
			{pendingTransactionPackets, pendingTransactionShippingContainerPackets, pendingTransactionSourcePackets, pendingTransactionDestinationPackets}
		];
		pendingTransactionSites=Download[Lookup[pendingTransactionPackets,Source,{}],Object];

		(* generate the price associations for the pending transactions; make separate associations for each pricing category, by transaction *)
		Flatten@MapThread[
			Function[{transactionPacket, materialPrice, handlingPrice, aliquotPrice, shippingPrice, sourceSite},
				MapThread[
					Function[{priceCategory, price},
						<|
							Notebook -> Download[Lookup[transactionPacket, Notebook], Object],
							Transaction -> Lookup[transactionPacket, Object],
							Site -> sourceSite,
							Material -> "N/A",
							Name -> "N/A",
							PricingCategory -> priceCategory,
							Amount -> 1,
							PricePerUnit -> price,
							Price -> price,
							Date -> Lookup[transactionPacket, DateCreated]
						|>
					],
					{{"Shipping (estimated)", "Handling", "Packaging Materials", "Aliquoting (estimated)"}, {shippingPrice, handlingPrice, materialPrice, aliquotPrice}}
				]
			],
			{pendingTransactionPackets, totalShippingMaterialPrices, handlingPrices, aliquotPrices, shippingPrices, pendingTransactionSites}
		]
	];

	(* --- begin internal Module for pricing SHIPPED transactions ---  *)
	shippedPriceAssociations=Module[
		{
			shippedTransactionsToPricePositions,shippedTransactionPackets,
			shippedUniqueSamplePackets,shippedUniqueProductPackets,shippedModelMaintenancePackets,shippedAliquotPrepTuples,shippedSPAliquotPrepTuples,aliquotProtocolPackets,
			requiredResourceTraversalFunctionForSubs,requiredResourceTraversalFunction,aliquotResourcePacketsByTransaction,
			aliquotResourceProductPacketsByTransaction,aliquotResourceSamplePacketsByTransaction,aliquotResourceSampleModelPacketsByTransaction,aliquotResourceProductContainerModelPacketsByTransaction,
			aliquotResourceProductModelPacketsByTransaction,aliquotResourceDefaultStorageConditionPacketsByTransaction,aliquotSiteModelPacketsByTransaction,aliquotResourceInstrumentModelPacketsByTransaction,
			aliquotSubprotocolPacketsByTransaction,aliquotWasteGeneratedPacketsByTransaction,aliquotSubprotocolWasteGeneratedPacketsByTransaction,
			productPacketForSampleFunction,standaloneMaterialPrices,byAmountMaterialPrices,totalShippingMaterialPrices,handlingPrices,
			aliquotPrices,shippingPrices,spAliquotResourcePacketsByTransaction,spAliquotResourceProductPacketsByTransaction,spAliquotResourceSamplePacketsByTransaction,spAliquotResourceSampleModelPacketsByTransaction,
			spAliquotResourceProductContainerModelPacketsByTransaction,spAliquotResourceProductModelPacketsByTransaction,spAliquotResourceDefaultStorageConditionPacketsByTransaction,
			spAliquotResourceInstrumentModelPacketsByTransaction,billInfo,shippedTransactionSites
		},

		(* get the positions of Shipped transactions that do not have any troubleshooting reports with Refund->True against them *)
		shippedTransactionsToPricePositions=MapThread[
			Function[{transactionPacket, tsReportPacketsForTransaction, index},
				If[MatchQ[Lookup[transactionPacket, Status], Shipped|Received] && !AnyTrue[Lookup[tsReportPacketsForTransaction, Refund, {}], TrueQ],
					{index},
					Nothing
				]
			],
			{transactionPackets, tsReportPackets, Range[Length[transactionPackets]]}
		];

		(* extract the downloaded tuples we will need to price the Shipped transactions *)
		shippedTransactionPackets=Extract[transactionPackets, shippedTransactionsToPricePositions];
		shippedUniqueSamplePackets=DeleteDuplicatesBy[Cases[Flatten[Extract[myTransactionShipToUserPackets[[All, 12;;17]], shippedTransactionsToPricePositions]], PacketP[Object]], Lookup[#, Object]&];
		shippedUniqueProductPackets=DeleteDuplicatesBy[Cases[Flatten[Extract[myTransactionShipToUserPackets[[All, 18;;23]], shippedTransactionsToPricePositions]], PacketP[Object[Product]]], Lookup[#, Object]&];
		shippedModelMaintenancePackets=Extract[myTransactionShipToUserPackets[[All, 24]], shippedTransactionsToPricePositions];

		(* --- BIG Download parsing section: need to calculate aliquoting cost; re-format all the packets we downloaded from aliquot prep protocols ---  *)


		(* ------------------------------------------- *)
		(* -- Parse out packets related to aliquots -- *)
		(* ------------------------------------------- *)

		(* -- Shared Packets for SM and SP -- *)

		(* get the tuples full of aliquot-resource-related packets for only those transactions that shipped (should be all empty for non-shipped stuff anyways) *)
		shippedAliquotPrepTuples=Extract[myTransactionShipToUserPackets[[All, 25;;61]], shippedTransactionsToPricePositions];
		shippedSPAliquotPrepTuples = Extract[myTransactionShipToUserPackets[[All, 62;;77]], shippedTransactionsToPricePositions];
		billInfo = Extract[myTransactionShipToUserPackets[[All, 78]], shippedTransactionsToPricePositions];

		(* pull out the aliquot protocol packets; this will be a list of protocol packets for each transaction *)
		aliquotProtocolPackets=shippedAliquotPrepTuples[[All, 1]];


		(* -- sort out the SM Aliquot packets -- *)

		(* make a function that takes the format in which we downloaded through RequiredResources fields, and stitches resources together by aliquot protocol, by transaction *)
		(* assume we have the tuple: {listOfPackets,{listOfPackets...},{listOfPackets...},{listOfPackets...}} *)
		requiredResourceTraversalFunction[myDownloadTupleSet_List]:=Map[
			Function[traversalTuple,
				MapThread[
					Join[#1, Flatten[{#2}], Flatten[{#3}], Flatten[{#4}]]&,
					traversalTuple
				]
			],
			myDownloadTupleSet
		];

		(* get resource packets from the different fields in the aliquot protocols *)
		aliquotResourcePacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 2;;5]]];
		aliquotResourceProductPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 6;;9]]];
		aliquotResourceSamplePacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 10;;13]]];
		aliquotResourceSampleModelPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 14;;17]]];
		aliquotResourceProductContainerModelPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 18;;21]]];
		aliquotResourceProductModelPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 22;;25]]];
		aliquotResourceDefaultStorageConditionPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 26;;29]]];
		(* and finally, some stuff for InstrumentTime/WasteGenerated *)
		aliquotResourceInstrumentModelPacketsByTransaction=requiredResourceTraversalFunction[shippedAliquotPrepTuples[[All, 31;;34]]];



		(*Shared packets between SM and RSP/MSP*)
		(* also slice out the site model packets *)
		aliquotSiteModelPacketsByTransaction=shippedAliquotPrepTuples[[All, 30]];
		aliquotSubprotocolPacketsByTransaction=shippedAliquotPrepTuples[[All, 35]];
		aliquotWasteGeneratedPacketsByTransaction=shippedAliquotPrepTuples[[All, 36]];
		aliquotSubprotocolWasteGeneratedPacketsByTransaction=shippedAliquotPrepTuples[[All, 37]];


		(* -- sort out the MSP and RSP packets -- *)

		(*for RSP/MSP we do it differently: here just squash all the packets, the first is the main protocol, the second is subs*)
		requiredResourceTraversalFunctionForSubs[myDownloadTupleSet_List]:=Map[
			Function[traversalTuple,
				MapThread[
					Join[#1, Flatten[{#2}]]&,
					traversalTuple
				]
			],
			myDownloadTupleSet
		];

		(* get resource packets from the different fields in the aliquot protocols *)
		spAliquotResourcePacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 1;;2]]];
		spAliquotResourceProductPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 3;;4]]];
		spAliquotResourceSamplePacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 5;;6]]];
		spAliquotResourceSampleModelPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 7;;8]]];
		spAliquotResourceProductContainerModelPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 9;;10]]];
		spAliquotResourceProductModelPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 11;;12]]];
		spAliquotResourceDefaultStorageConditionPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 13;;14]]];
		(* and finally, some stuff for InstrumentTime/WasteGenerated *)
		spAliquotResourceInstrumentModelPacketsByTransaction=requiredResourceTraversalFunctionForSubs[shippedSPAliquotPrepTuples[[All, 15;;16]]];


		(* --- still with us? alright now we can actually price --- *)

		(* ============= *)
		(* == Pricing == *)
		(* ============= *)

		(* first, calculate shipping material prices *)
		(* make a quick helper that will let us get the product packet for a given sample *)
		productPacketForSampleFunction[mySample:ObjectP[{Object[Sample], Object[Item], Object[Container]}]]:=Module[{samplePacket},

			(* jump from the sample to the sample packet *)
			samplePacket=SelectFirst[shippedUniqueSamplePackets, MatchQ[Download[Lookup[#, Object], Object], Download[mySample, Object]]&];

			(* assume we have Model; jump to product packet from model using ProductModel *)
			SelectFirst[shippedUniqueProductPackets, MatchQ[Download[Lookup[#, ProductModel], Object], Download[Lookup[samplePacket, Model], Object]]&]
		];

		(* get the shipping materials price for each Pending transaction; look at each product's price per unit for the shipping materials in the transaction *)
		(* the following fields are just one product<->one item, so we can take Price straight up for any of these *)
		standaloneMaterialPrices=Map[
			Function[transactionPacket,
				Total@Map[
					Function[fieldName,
						Module[{fieldValue, productPackets},

							(* get the field value from the transaction; assume it is Models since we're Pending *)
							fieldValue=Lookup[transactionPacket, fieldName];

							(* for each member of the field (assume list, find the product packet) *)
							productPackets=productPacketForSampleFunction /@ fieldValue;

							(* total the price across the product packets - be careful about items that come in packs of 25 or so *)
							Total[
								Lookup[productPackets, Price, {}] / (Lookup[productPackets, NumberOfItems] * If[NullQ[Lookup[productPackets, Amount]], 1, Lookup[productPackets, Amount]])
							]
						]
					],
					{ShippingContainers, SecondaryContainers, PlateSeals, Ice}
				]
			],
			shippedTransactionPackets
		];

		(* price the materials that had amounts; gotta take the amount fields into account *)
		byAmountMaterialPrices=Map[
			Function[transactionPacket,
				Total@MapThread[
					Function[{itemField, amountField},
						Module[{fieldValue, productPackets, pricingRates, amountValue},

							(* get the field value from the transaction; assume it is Models since we're Pending *)
							fieldValue=DeleteCases[Lookup[transactionPacket, itemField],Null];

							(* for each member of the field (assume list, find the product packet) *)
							productPackets=productPacketForSampleFunction /@ fieldValue;

							(* get the pricing rate by amount for each product packet *)
							pricingRates=Map[
								Lookup[#, Price] / (Lookup[#, NumberOfItems] * Lookup[#, Amount])&,
								productPackets
							];

							amountValue = DeleteCases[Lookup[transactionPacket, amountField],Null];

							(* total the price across the product packets, scaling by amount used *)
							Total[amountValue * pricingRates]
						]
					],
					(* we assume we only deal with one shipping and one secondary box per shipment *)
					{{DryIce, Padding}, {DryIceMasses, PaddingMasses}}
				]
			],
			shippedTransactionPackets
		];

		(* get the total shipping material cost for each transaction *)
		totalShippingMaterialPrices=standaloneMaterialPrices + byAmountMaterialPrices;

		(* the handling price is just what's in each model maintennace *)
		handlingPrices=Lookup[shippedModelMaintenancePackets, HandlingPrice, {}];


		(* for the aliquot prices; pierce into the aliquot prep protocols for each transaction, and ALL the material we downloaded, and use other pricing functions to get exact price *)
		aliquotPrices=MapThread[
			Function[
				{
					(* these are all by transaction but still multiple (may have multiple aliquots per transaction, they will all be either SM or SP) *)
					(*shared packets*)
					(*1*)aliquotProtocolPackets,
					(*2*)siteModelPackets,
					(*3*)subprotocolPackets,
					(*4*)wasteGeneratedPackets,
					(*5*)subprotocolWasteGeneratedPackets,
					(*6*)billPackets,

					(*SM specific*)
					(*7*)aliquotResourcePackets,
					(*8*)resourceProductPackets,
					(*9*)resourceSamplePackets,
					(*10*)resourceModelPackets,
					(*11*)productContainerModelPackets,
					(*12*)productModelPackets,
					(*13*)productModelDefaultStorageConditionPackets,
					(*14*)resourceInstrumentModelPackets,

					(*SP packets*)
					(*15*)spaliquotResourcePackets,
					(*16*)spresourceProductPackets,
					(*17*)spresourceSamplePackets,
					(*18*)spresourceModelPackets,
					(*19*)spproductContainerModelPackets,
					(*20*)spproductModelPackets,
					(*21*)spproductModelDefaultStorageConditionPackets,
					(*22*)spresourceInstrumentModelPackets
				},

				(* determine what to do based on if we have aliquot protocols and if they are SM or something else *)
				Which[
					(* no aliquotting happened, skip this *)
					MatchQ[aliquotProtocolPackets, {}],
					0 USD,

					(*SM aliquotting happened, price the SM packets*)
					MatchQ[aliquotProtocolPackets, {PacketP[Object[Protocol, SampleManipulation]]..}],
					Module[{aliquotMaterialsPrices, aliquotMaterialsPrice, aliquotInstrumentTimePrices, aliquotInstrumentTimePrice,
						aliquotWastePrice},

						(* call the helper from PriceMaterials, priceMaterialsProtocols, to get the price of materials from the aliquot protocols for this transaction;
							 we just want to extract the total prices, which are stored at the second to last index of the fat return *)
						aliquotMaterialsPrices=priceMaterialsProtocols[
							aliquotProtocolPackets,
							ConstantArray[{}, Length[aliquotProtocolPackets]], (* subprotocols can't have TS reports; just pass nothing here *)
							Cases[#, PacketP[]]&/@aliquotResourcePackets,
							resourceProductPackets,
							resourceSamplePackets,
							resourceModelPackets,
							productContainerModelPackets,
							productModelPackets,
							productModelDefaultStorageConditionPackets,
							productContainerModelPackets,
							siteModelPackets,
							AllowSubprotocols -> True (* pass option to ensure this core helper doesn't freak out if it sees a subprotocol *)
						][[-3]];
						aliquotMaterialsPrice=Total[DeleteCases[aliquotMaterialsPrices, Null]];

						(* get the instrument time price for the aliquot protocols, need to call the core private function that has the special AllowSubprotocols option *)
						aliquotInstrumentTimePrices=priceInstrumentTimeProtocols[
							aliquotProtocolPackets,
							ConstantArray[{}, Length[aliquotProtocolPackets]], (* subprotocols can't have TS reports; just pass nothing here *)
							aliquotResourcePackets,
							resourceInstrumentModelPackets,
							ConstantArray[billPackets, Length[aliquotProtocolPackets]],
							AllowSubprotocols -> True (* pass option to ensure this core helper doesn't freak out if it sees a subprotocol *)
						][[-4]];
						aliquotInstrumentTimePrice=Total[DeleteCases[aliquotInstrumentTimePrices, Null]];

						(* get the waste generated price for the aliquot protocols; PriceWaste doesn't need SubprotocolRequiredResources,
							  so we can call the parent function directly *)
						aliquotWastePrice=PriceWaste[Lookup[aliquotProtocolPackets, Object, {}], Cache -> {}, FastTrack -> True, OutputFormat -> TotalPrice];

						(* sum up for the total aliquot price *)
						aliquotMaterialsPrice + aliquotInstrumentTimePrice + aliquotWastePrice
					],

					(*-- We have aliquotting subprotocols not using SM -- *)
					MatchQ[aliquotProtocolPackets, {PacketP[Object[Protocol]]..}],

					Module[{aliquotMaterialsPrices, aliquotMaterialsPrice, aliquotInstrumentTimePrices, aliquotInstrumentTimePrice,
						aliquotWastePrice},

						(* call the helper from PriceMaterials, priceMaterialsProtocols, to get the price of materials from the aliquot protocols for this transaction;
							 we just want to extract the total prices, which are stored at the second to last index of the fat return *)
						aliquotMaterialsPrices=priceMaterialsProtocols[
							aliquotProtocolPackets,
							ConstantArray[{}, Length[aliquotProtocolPackets]], (* subprotocols can't have TS reports; just pass nothing here *)
							Cases[#, PacketP[]]&/@spaliquotResourcePackets,
							spresourceProductPackets,
							spresourceSamplePackets,
							spresourceModelPackets,
							spproductContainerModelPackets,
							spproductModelPackets,
							spproductModelDefaultStorageConditionPackets,
							spproductContainerModelPackets,
							siteModelPackets,
							AllowSubprotocols -> True (* pass option to ensure this core helper doesn't freak out if it sees a subprotocol *)
						][[-3]];
						aliquotMaterialsPrice=Total[DeleteCases[aliquotMaterialsPrices, Null]];

						(* get the instrument time price for the aliquot protocols, need to call the core private function that has the special AllowSubprotocols option *)
						aliquotInstrumentTimePrices=priceInstrumentTimeProtocols[
							aliquotProtocolPackets,
							ConstantArray[{}, Length[aliquotProtocolPackets]], (* subprotocols can't have TS reports; just pass nothing here *)
							spaliquotResourcePackets,
							spresourceInstrumentModelPackets,
							ConstantArray[billPackets, Length[aliquotProtocolPackets]],
							AllowSubprotocols -> True (* pass option to ensure this core helper doesn't freak out if it sees a subprotocol *)
						][[-4]];
						aliquotInstrumentTimePrice=Total[DeleteCases[aliquotInstrumentTimePrices, Null]];

						(* get the waste generated price for the aliquot protocols; PriceWaste doesn't need SubprotocolRequiredResources,
							  so we can call the parent function directly *)
						aliquotWastePrice=PriceWaste[Lookup[aliquotProtocolPackets, Object, {}], Cache -> {}, FastTrack -> True, OutputFormat -> TotalPrice];

						(* sum up for the total aliquot price *)
						aliquotMaterialsPrice + aliquotInstrumentTimePrice + aliquotWastePrice
					],

					(* probably unnecessary catch-all *)
					True,
					0*USD
				]
			],
			{
				(*shared packets - site, bill, all subprotocol waste*)
				(*1*)aliquotProtocolPackets,
				(*2*)aliquotSiteModelPacketsByTransaction,
				(*3*)aliquotSubprotocolPacketsByTransaction,
				(*4*)aliquotWasteGeneratedPacketsByTransaction,
				(*5*)aliquotSubprotocolWasteGeneratedPacketsByTransaction,
				(*6*)billInfo,

				(*SM specific packets*)
				(*7*)aliquotResourcePacketsByTransaction,
				(*8*)aliquotResourceProductPacketsByTransaction,
				(*9*)aliquotResourceSamplePacketsByTransaction,
				(*10*)aliquotResourceSampleModelPacketsByTransaction,
				(*11*)aliquotResourceProductContainerModelPacketsByTransaction,
				(*12*)aliquotResourceProductModelPacketsByTransaction,
				(*13*)aliquotResourceDefaultStorageConditionPacketsByTransaction,
				(*14*)aliquotResourceInstrumentModelPacketsByTransaction,

				(*SP packets*)
				(*15*)spAliquotResourcePacketsByTransaction,
				(*16*)spAliquotResourceProductPacketsByTransaction,
				(*17*)spAliquotResourceSamplePacketsByTransaction,
				(*18*)spAliquotResourceSampleModelPacketsByTransaction,
				(*19*)spAliquotResourceProductContainerModelPacketsByTransaction,
				(*20*)spAliquotResourceProductModelPacketsByTransaction,
				(*21*)spAliquotResourceDefaultStorageConditionPacketsByTransaction,
				(*22*)spAliquotResourceInstrumentModelPacketsByTransaction
			}
		];

		(* the shipping prices are easy; it is stored in the transaction object  *)
		shippingPrices=Lookup[shippedTransactionPackets, ShippingPrice, {}];

		(* get the Site that we can relate for this price *)
		shippedTransactionSites=Download[Lookup[shippedTransactionPackets,Source,{}],Object];

		(* generate the price associations for the pending transactions; make separate associations for each pricing category, by transaction *)
		Flatten@MapThread[
			Function[{transactionPacket, materialPrice, handlingPrice, aliquotPrice, shippingPrice, sourceSite},
				MapThread[
					Function[{priceCategory, price},
						<|
							Notebook -> Download[Lookup[transactionPacket, Notebook], Object],
							Transaction -> Lookup[transactionPacket, Object],
							Site -> sourceSite,
							Material -> "N/A",
							Name -> "N/A",
							PricingCategory -> priceCategory,
							Amount -> 1,
							PricePerUnit -> price,
							Price -> price,
							Date -> Lookup[transactionPacket, DateCreated]
						|>
					],
					{{"Shipping", "Handling", "Packaging Materials", "Aliquoting"}, {shippingPrice, handlingPrice, materialPrice, aliquotPrice}}
				]
			],
			{shippedTransactionPackets, totalShippingMaterialPrices, handlingPrices, aliquotPrices, shippingPrices, shippedTransactionSites}
		]
	];

	(* join together the pricing associations into a single list; only want ones where the Price is not 0 *)
	allPriceAssociations=Select[Join[pendingPriceAssociations, shippedPriceAssociations], Lookup[#, Price] > 0 USD&]
];



(* ::Subsubsection::Closed:: *)
(*priceTransactionsToECL (private) *)


(* --- PRICING OF TRANSACTIONS SHIPPED TO ECL --- *)

(* This function is called in the core function (priceTransactionsCore) and combines the information yielded from listprice, tax, receiving, measurement and stocking pricing of transaction items shipped to ECL *)
(* This function retrieves pricing information of samples no matter whether they have been received yet or not. In the protocol/transaction overload, only cancelled transactions are filtered out. Notebook and Team overloads only look at received transactions *)
(* In the first part all pricing information regarding Receiving and Measurement of all transactions is calculated. In the second part information about the transaction order product price, tax price, and stocking price is extracted *)
(* In the third and fourth part, the lists are consolidated by sample models/ transaction objects, and the lists for the output tables are constructed *)

(* The inputs are the transaction packets from the big Download Call in PriceTransactions *)

(* 1. packets from Transaction[Order] *)
(* 2. packets from Transaction[DropShipping] *)
(* 3. packets from Transaction[ShipToECL] *)
(* 4. packets from Transaction[SiteToSite] *)
(* 4. packets from Transaction[] (any of the above) *)

priceTransactionsToECL::InputPattern = "Achtung!! Inputs for priceTransactionsToECL don't match their pattern!!";

(* The outputs are lists of information about notebook, samples, names, prices, etc for the PriceMaterials output table *)
priceTransactionsToECL[
	myTransactionOrderPackets_,
	myTransactionDropShippingPackets_,
	myTransactionSendingPackets_,
	mySiteToSitePackets_,
	myTransactionAllPackets_
]:=Module[{
	allTransactionPackets,allSupplierTransactionPackets,transactionHasSupplierBool,toBeIgnoredBool,toBePricedTransactionPackets,
	transactionCanceledBool,fulfillmentBool,
	allTransactionDropShippingPackets,dropShippingModels,allTransactionOrderPackets,productModels,samplesPerItemInOrders,indexMatchedProductPackets,
	orderQuantities,orderModels,allTransactionSendingContainerOutPackets,sendingModels,
	allTransactionsModels,allTransactionDropShippingModelPackets,allTransactionOrderModelPackets,allTransactionSendingModelPackets,
	flatTransactionModelNames,allTransactionReceivingPackets,
	allTransactionReceivingPrice,indexMatchedReceivingPrice,
	transactionMeasurementPricing,transactionObjects,indexMatchedTransactionObjects,
	transactionNotebooks,indexMatchedTransactionNotebooks,
	transactionDates,indexMatchedTransactionDates,allTransactionOrderProductPackets,indexMatchedProducts,
	gatheredProducts,indexMatchedOrderProductPackets,transactionOrderProductPricePerUnit,transactionOrderSamplesPerItem,transactionOrderListPrice,
	cappedTransactionOrderStockingPrice,flatCancelledTransactionBool,allCancelledTransactionModels,flatFulfilledTransactionBool,
	indexmatchFilterForTransactions,instantTransferOrderBool,indexMatchedInstantTransfer,flatTransactionMaterialObject,transactionStockingPricing,transactionInstantTransfer,
	recTransactionNotebooks,recTransactionMaterialObject,recTransactionObjects,recTransactionNames,recTransactionDates,recReceivingPrice,recMeasurementPricing,filtTransactionNotebooks,
	filtTransactionObjects,filtTransactionMaterialObject,filtTransactionNames,filtTransactionDates,filtReceivingPrice,filtMeasurementPricing,transposedTransactionProducts,gatheredTransactionMaterial,
	gatheredTransactionObjects,gatherByModelAndObject,gatheredTransactionNotebooks,gatheredTransactionName,gatheredTransactionDates,
	gatheredReceivingPrice,gatheredMeasurementPrice,gatheredInstantTransfer,gatheredStockingPrice,consolidatedTransactionNotebooks,consolidatedTransactionNames,consolidatedTransactionObjects,consolidatedTransactionMaterial,
	consolidatedTransactionDates,consolidatedReceivingPrice,consolidatedInstantTransfer,
	consolidatedTransactionMeasurementPrice,consolidatedStockingPrice,consolidatedTransactionAmounts,consolidatedReceivingMeasurementCost,consolidatedTransactionReceivingStockingPrice,
	transactionReceivingTag,transactionReceivingStockingTag,consolidatedTransactionReceivingStockingPricingRate,
	transactionPriceNotNullBool,totalTransactionPrices,totalTransactionPricePerUnit,totalTransactionNotebooks,totalTransactionObjects,totalTransactionMaterial,
	totalTransactionNames,totalTransactionAmounts,totalTransactionDates,totalTransactionTags,totalTransactionOutput,totalTransactionSites,allSiteToSiteContainerOutPackets,siteToSiteModels,allSiteToSiteModelPackets},

	(* ============ *)
	(* == PART 0 == *)
	(* MM is horrible about pattern matching inputs, so we are allowing everything and checking inputs here *)
	If[And[
		MatchQ[myTransactionOrderPackets, {{({(PacketP[{Object[], Model[]}] | Null)...} | PacketP[{Object[], Model[]}] ... | {Null} | Null ) ...} ...}],
		MatchQ[myTransactionDropShippingPackets, {{({PacketP[{Object[], Model[]}] ...} | PacketP[{Object[], Model[]}] ... | {Null}) ...} ...}],
		MatchQ[myTransactionSendingPackets, {{({(PacketP[{Object[], Model[]}]|Null) ...} | (PacketP[{Object[], Model[]}]|Null) ... | {Null} ) ...} ...}],
		MatchQ[myTransactionAllPackets, {{({PacketP[{Object[], Model[]}] ...} | PacketP[{Object[], Model[]}] ... | {Null} | Null | $Failed) ...} ...}]
	],Null,Message[priceTransactionsToECL::InputPattern];Return[$Failed, Module]];

	(* ============ *)
	(* == PART 1 == *)
	(* ============ *)

	(*--- This section extracts all pricing information for Receiving and Measurement of all Transactions ---*)

	(*get all the Transaction Packets from the Transaction Download*)
	allTransactionPackets=myTransactionAllPackets[[All, 1]];

	(*extract a Boolean list for whether the Transaction item is not Canceled *)
	transactionCanceledBool=Map[MatchQ[Lookup[#, Status, {}], Canceled]&, allTransactionPackets];

	(*get all the Transaction Packets from the Transaction Download*)
	allSupplierTransactionPackets=myTransactionAllPackets[[All, 3]];

	(* extract a Boolean list for whether the Transaction links to a Supplier Order that has a notebook *)
	transactionHasSupplierBool=Map[
		(* need to make the Null check in case there is no SupplierOrder, and the $Failed check in case we're dealing with a ShipToUser or DropShipping transaction *)
		If[NullQ[#] || MatchQ[#, $Failed],
			False,
			(* If there is a SupplierOrder, check whether it has a notebook *)
			MatchQ[Lookup[#, Notebook, {}], ObjectP[Object[LaboratoryNotebook]]]
		]&,
		allSupplierTransactionPackets
	];

	(* construct a boolean for whether we want to ignore this transaction on the basis of its Status and SupplierOrder Notebook *)
	(* If either the transaction is cancelled, and/or it has an owned Supplier order, we ignore that transaction *)
	toBeIgnoredBool=MapThread[
		TrueQ[#1] || TrueQ[#2]&,
		{transactionCanceledBool, transactionHasSupplierBool}
	];

	(* extract a Boolean list for whether the Transaction has a SupplierOrder linked  *)
	toBePricedTransactionPackets=PickList[allTransactionPackets, toBeIgnoredBool, False];

	(* extract a Boolean list for whether the Transaction has a protocol that was used to fulfill the order *)
	(* Orders with Fulfillment populated are ignored since they are priced by the protocol *)
	fulfillmentBool=Map[MatchQ[Lookup[#, Fulfillment, {}], {ObjectP[{Object[Protocol, SampleManipulation], Object[Protocol, StockSolution]}] ..}] &, toBePricedTransactionPackets];

	(* ------------------------ *)
	(* -- Get Shipped Models -- *)
	(* ------------------------ *)

	(* -- Object[Transaction, DropShipping] -- *)
	(* get the model packets of Object[Transaction, DropShipping] *)
	allTransactionDropShippingPackets=myTransactionDropShippingPackets[[All, 1]];

	(* extract the models of Object[Transaction, DropShipping] *)
	dropShippingModels=Download[Lookup[allTransactionDropShippingPackets, Models, {}], Object];

	(* get the model packets of all ordered transaction items *)
	allTransactionOrderPackets=myTransactionOrderPackets[[All, 2]];

	(* get the order quantities all ordered transaction products *)
	orderQuantities=Map[Lookup[#, OrderQuantities]&, allTransactionOrderPackets];

	(* get the product packets of all ordered transaction items and pull out the ProductModel and the SamplesPerItems *)
	allTransactionOrderProductPackets=myTransactionOrderPackets[[All, 3]];
	productModels=Map[Download[Lookup[#, ProductModel, {}], Object]&, allTransactionOrderProductPackets];
	samplesPerItemInOrders=Map[Lookup[#, NumberOfItems, {}]&, allTransactionOrderProductPackets];

	(* expand the Product packets of ordered transactions with the samples ordered *)
	(* need to multiple by the number of samples per product and by the quantity ordered *)
	indexMatchedProductPackets=MapThread[
		Function[{models, orderQuants, samplesPerItem},
			Flatten[
				MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}
				]
			]
		],
		{allTransactionOrderProductPackets, orderQuantities, samplesPerItemInOrders}
	];

	(* get the models of ordered transactions as a list of models per transaction for instance  {{model1,model1,model1,model2},{model3}} *)
	(* Since we want them flattened as a list of models for each transaction, need to multiple the ProductModel by the number of samples per product and by the quantity ordered *)
	orderModels=MapThread[
		Function[{models, orderQuants, samplesPerItem},
			Flatten[
				MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}
				]
			]
		],
		{productModels, orderQuantities, samplesPerItemInOrders}
	];

	(* -- Object[Transaction, ShipToECL] -- *)

	(* get the model packets for ShipToECL transactions - get all of the ContainerOut + Model.Item for things that we received *)
	allTransactionSendingContainerOutPackets=MapThread[
		Function[{containerPackets, receivedItemPackets},
			Join[
				Cases[containerPackets, PacketP[Object[Container]]],
				Cases[receivedItemPackets, PacketP[Object[Item]]]
			]],
		{myTransactionSendingPackets[[All, 3]], myTransactionSendingPackets[[All, 5]]}];

	(* get the models of ShipToECL transactions *)
	sendingModels=Map[Download[Lookup[#, Model, {}], Object]&, allTransactionSendingContainerOutPackets];

	(* -- Object[Transaction, SiteToSite] -- *)

	(* get the model packets for SiteToSite transactions - get all of the ContainerOut + Model.Item for things that we received *)
	allSiteToSiteContainerOutPackets=MapThread[
		Function[{containerPackets, receivedItemPackets},
			Join[
				Cases[containerPackets, PacketP[Object[Container]]],
				Cases[receivedItemPackets, PacketP[Object[Item]]]
			]],
		{mySiteToSitePackets[[All,81]],mySiteToSitePackets[[All,83]]}];

	(* get the models of SiteToSite transactions *)
	siteToSiteModels=Map[Download[Lookup[#, Model, {}], Object]&, allSiteToSiteContainerOutPackets];

	(* join the models from all transactions *)
	allTransactionsModels=Join[dropShippingModels, orderModels, sendingModels, siteToSiteModels];

	(* -- Object[Transaction, Order] -- *)

	(* since we are getting this via the ProductModel, need to expand the list by multiplying the quantity ordered and the samples per item *)
	allTransactionOrderModelPackets=
		MapThread[
			Function[{models, orderQuants, samplesPerItem},
				Flatten[MapThread[
					ConstantArray[#1, #2 * #3] &,
					{models, orderQuants, samplesPerItem}]]],
			{myTransactionOrderPackets[[All, 1]], orderQuantities, samplesPerItemInOrders}
		];

	(* get the model packets from DropShipping, ShipToECL, and SiteToSite packets *)
	allTransactionDropShippingModelPackets=myTransactionDropShippingPackets[[All, 2]];
	allTransactionSendingModelPackets=MapThread[
		Function[{containerPackets, receivedItemPackets},
			Join[
				Cases[containerPackets, PacketP[Model[Container]]],
				Cases[receivedItemPackets, PacketP[Model[Item]]]
			]],
		{myTransactionSendingPackets[[All, 4]], myTransactionSendingPackets[[All, 6]]}];
	allSiteToSiteModelPackets=MapThread[
		Function[{containerPackets, receivedItemPackets},
			Join[
				Cases[containerPackets, PacketP[Model[Container]]],
				Cases[receivedItemPackets, PacketP[Model[Item]]]
			]],
		{mySiteToSitePackets[[All, 82]], mySiteToSitePackets[[All, 84]]}];

	(* construct a flat list of the name of the models shipped with each transaction, for Transaction Orders use the product name instead since Model name can be ambiguous (in cases where there are multiple products per Model) *)
	flatTransactionModelNames=Flatten[Map[Lookup[#, Name, {}]&, Join[allTransactionDropShippingModelPackets, indexMatchedProductPackets, allTransactionSendingModelPackets, allSiteToSiteModelPackets]]];

	(*get all the Transaction Packets from the Transaction Download*)
	allTransactionReceivingPackets=myTransactionAllPackets[[All, 2]];

	(* ---------------------------- *)
	(* -- Index matching packets -- *)
	(* ---------------------------- *)

	(* get the costs for receiving, volume-measure, weight-measure and measure-count protocols from the Transaction Receiving packets *)
	allTransactionReceivingPrice=Lookup[allTransactionReceivingPackets, ReceivingPrice, {}];

	(* indexmatch the receiving prices with the flat sample model list *)
	indexMatchedReceivingPrice=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {allTransactionReceivingPrice, allTransactionsModels}]];

	(* we are not charging for volume measurements anymore, so just set it to 0 USD *)
	transactionMeasurementPricing=ConstantArray[0 USD, Length[flatTransactionModelNames]];

	(* get the transaction Object IDs from the big transaction packet *)
	transactionObjects=Map[Lookup[#, Object, {}]&, allTransactionPackets];

	(* construct a fat list of Transaction Objects indexmatched with the models shipped by each transaction *)
	indexMatchedTransactionObjects=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionObjects, allTransactionsModels}]];

	(* get the transaction Notebook IDs from the big transaction packet *)
	transactionNotebooks=Map[Lookup[#, Notebook, {}]&, allTransactionPackets];

	(* construct a fat list of Transaction Notebooks, indexmatched with the models shipped by each transaction *)
	indexMatchedTransactionNotebooks=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionNotebooks, allTransactionsModels}]];

	(* get the transaction DateDelivered from the big transaction packet *)
	(* this may be Null for partial deliveries or transactions that are pending. Since notebook overloads only look at received transactions, for billing purposes the date will always be populated *)
	transactionDates=Map[Lookup[#, DateDelivered, {}]&, allTransactionPackets];
	indexMatchedTransactionDates=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {transactionDates, allTransactionsModels}]];


	(* ============= *)
	(* == PART 2: == *)
	(* ============= *)

	(* --- this section only looks at Object[Transaction,Order] and extracts the pricing of the Transaction Order products plus the affiliated stocking prices affiliated with them --- *)

	(* extract a product list from the transaction packets. This list is indexmatched to the transactions as in {{prod1,prod2},{prod3},{prod4,prod5,prod6}}*)
	indexMatchedProducts=Map[Lookup[#, Object, {}] &, indexMatchedProductPackets];

	(* create a gathered product list that will have identical products in each transaction gathered together. This list will be used to indexmatch the pricing information *)
	gatheredProducts=Flatten[Map[Gather, indexMatchedProducts], 1];

	(* indexMatch the ProductPackets (which are a list of non-duplicate products that are shipped in the transaction) with the gathered Model list *)
	indexMatchedOrderProductPackets=MapThread[ConstantArray[#1, Length[#2]]&, {Flatten[allTransactionOrderProductPackets, 1], gatheredProducts}];

	(* get the product price from the indexmatched TransactionOrderProductPackets *)
	(* note that this is the price for one item of the product ordered which can consist of several samples, so this will need to be corrected by the NumberOfItems count *)
	transactionOrderProductPricePerUnit=Flatten[Map[Lookup[#, Price, {}]&, indexMatchedOrderProductPackets]];

	(* get the NumberOfItems count from the TransactionOrderProductPackets *)
	transactionOrderSamplesPerItem=Flatten[Map[Lookup[#, NumberOfItems, {}]&, indexMatchedOrderProductPackets]];

	(* to get the price for each sample object (as opposed to each product), divide the Product Price by the number of samples (NumberOfItems) in that product *)
	transactionOrderListPrice=transactionOrderProductPricePerUnit / transactionOrderSamplesPerItem;

	(* --------------------------------------------------------------- *)
	(* -- more index matching for stocking calculation (deprecated) -- *)
	(* --------------------------------------------------------------- *)

	(* get a list of all InternalOrder -> True occurrences within the Transaction Orders*)
	(* samples with InternalOrder -> True are purchased in house. They are not charged the Receiving Pricing but the stocking pricing instead *)
	instantTransferOrderBool=Map[Lookup[#, InternalOrder, {}]&, allTransactionOrderPackets];

	(* get this list indexmatched with the number of samples. Use the transaction order model list for this *)
	indexMatchedInstantTransfer=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {instantTransferOrderBool, orderModels}]];

	(* ------------------------------ *)
	(* -- Calculate Stocking Price -- *)
	(* ------------------------------ *)

	(* we aren't charging for stocking anymore since these will be charged storage *)
	cappedTransactionOrderStockingPrice=ConstantArray[0 USD, Length[transactionOrderListPrice]];

	(* modify the cancelled-transaction bool to be indexmatch with the individual objects shipped *)
	flatCancelledTransactionBool=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {toBeIgnoredBool, allTransactionsModels}]];

	(* filter the Transaction Models for the Cancelled ones such that this list can be used for indexmatching the fulfillmentBool *)
	allCancelledTransactionModels=PickList[allTransactionsModels, toBeIgnoredBool, False];

	(* modify the fulfilled-transaction bool to be indexmatched with the individual objects shipped *)
	flatFulfilledTransactionBool=Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {fulfillmentBool, allCancelledTransactionModels}]];

	(* ==define Function:indexmatchFilterForTransaction== *)
	(* Use this helper function to indexmatch all transaction order price lists with the entire list of transactions, then filter out transactions that have been cancelled and are fulfilled by protocols *)
	indexmatchFilterForTransactions[myMultipleListsOfPrices_List]:=Module[
		{dropShippingCount,sendingCount,entirePriceLists,notCancelledPriceLists,notFulfilledPriceLists,siteToSiteCount},

		(* count the number of dropShipped samples *)
		dropShippingCount=Length[Flatten[dropShippingModels]];

		(* count the number of sending samples via ShipToECL *)
		sendingCount=Length[Flatten[sendingModels]];
		siteToSiteCount=Length[Flatten[siteToSiteModels]];

		(* make a list of product and stocking prices for the entire list of Transactions by filling in Null for Transaction DropShipping and ShipToECL) *)
		entirePriceLists=Map[
			Join[
				Table[Null, dropShippingCount],
				#,
				Table[Null, sendingCount],
				Table[Null, siteToSiteCount]
			]&,
			myMultipleListsOfPrices
		];

		(* filter the product and stocking price lists for transactions that are received and don't have fulfillment protocols in order to indexmatch the price lists with the transaction sample objects to be priced *)
		notCancelledPriceLists=Map[PickList[#, flatCancelledTransactionBool, False] &, entirePriceLists];
		notFulfilledPriceLists=Map[PickList[#, flatFulfilledTransactionBool, False] &, notCancelledPriceLists]
	];

	(*TODO: this is a little silly but the output is ok*)
	(* apply the  helper function to the 4 transaction order price lists and the instantTransfer bool *)
	{transactionStockingPricing, transactionInstantTransfer}=indexmatchFilterForTransactions[
		{cappedTransactionOrderStockingPrice, indexMatchedInstantTransfer}
	];


	(* ============ *)
	(* == PART 3 == *)
	(* ============ *)

	(*--- in the next part,list items are gathered and consolidated into one list entry if they originate from the same transaction plus if the associated objects are from the same product ---*)

	(* get a flat list of models which is indexmatched with all other flat indexmatched lists (like samples, dates, prices etc *)
	(* for transaction orders, use the product (since the Model can be ambiguous if multiple products exist per Model) *)
	flatTransactionMaterialObject=Flatten[Join[dropShippingModels, indexMatchedProducts, sendingModels, siteToSiteModels]];

	(*filter all output lists for the output table for transactions that have not been canceled *)
	{
		recTransactionNotebooks,
		recTransactionObjects,
		recTransactionMaterialObject,
		recTransactionNames,
		recTransactionDates,
		recReceivingPrice,
		recMeasurementPricing
	}=Map[
		PickList[#, flatCancelledTransactionBool, False]&,
		{
			indexMatchedTransactionNotebooks,
			indexMatchedTransactionObjects,
			flatTransactionMaterialObject,
			flatTransactionModelNames,
			indexMatchedTransactionDates,
			indexMatchedReceivingPrice,
			transactionMeasurementPricing
		}
	];

	(* filter the received output lists for transactions that have no fulfilled Protocols *)
	{
		filtTransactionNotebooks,
		filtTransactionObjects,
		filtTransactionMaterialObject,
		filtTransactionNames,
		filtTransactionDates,
		filtReceivingPrice,
		filtMeasurementPricing
	}=Map[
		PickList[#, flatFulfilledTransactionBool, False]&,
		{
			recTransactionNotebooks,
			recTransactionObjects,
			recTransactionMaterialObject,
			recTransactionNames,
			recTransactionDates,
			recReceivingPrice,
			recMeasurementPricing
		}
	];

	(* in the first step bring the transaction and product lists together into one *)
	transposedTransactionProducts=Transpose[{filtTransactionMaterialObject, filtTransactionObjects}];

	(* in the second step gather them if list entries (transaction ID and Product ID)) are identical,and extract back the gathered Product list and the Transactions *)
	gatheredTransactionMaterial=Gather[transposedTransactionProducts][[All, All, 1]];
	gatheredTransactionObjects=Gather[transposedTransactionProducts][[All, All, 2]];

	(* ==define Function:gatherByModelAndObject==*)
	(* Use this helper function to consolidate the lists by sample objects that originate from the same transaction and are from the same material *)
	gatherByModelAndObject[myflatlists_List]:=Module[{material, transactions, transposedLists},

		(*get the model and transaction IDs*)
		material=filtTransactionMaterialObject;
		transactions=filtTransactionObjects;

		(*transpose lists with both the model and transaction ID*)
		transposedLists=Map[Transpose[{material, transactions, #}]&, myflatlists];

		(*gather the lists if model and transaction ID are identical,and extract the gathered list*)
		Map[GatherBy[#, Most][[All, All, 3]]&, transposedLists]
	];

	(* using the helper function, gather notebook,name, prices, date and tag lists *)
	{
		gatheredTransactionNotebooks,
		gatheredTransactionName,
		gatheredTransactionDates,
		gatheredReceivingPrice,
		gatheredMeasurementPrice,
		gatheredInstantTransfer,
		gatheredStockingPrice,
		gatheredTransactionMaterial
	}=gatherByModelAndObject[
		{
			Download[filtTransactionNotebooks, Object],
			filtTransactionNames,
			filtTransactionDates,
			filtReceivingPrice,
			filtMeasurementPricing,
			transactionInstantTransfer,
			transactionStockingPricing,
			filtTransactionMaterialObject
		}
	];

	(* consolidate the gathered notebook,objects,models,names, dates,and tags list so that there is one item per list. Since they should be identical, the first entry can be taken *)
	(* this can also be done for the receiving pricing since only one receiving cost is applied for each model. The other price lists will be treated differently (see below) *)
	{
		consolidatedTransactionNotebooks,
		consolidatedTransactionNames,
		consolidatedTransactionObjects,
		consolidatedTransactionMaterial,
		consolidatedTransactionDates,
		consolidatedReceivingPrice,
		consolidatedInstantTransfer
	}=Map[
		First /@ #&,
		{
			gatheredTransactionNotebooks,
			gatheredTransactionName,
			gatheredTransactionObjects,
			gatheredTransactionMaterial,
			gatheredTransactionDates,
			gatheredReceivingPrice,
			gatheredInstantTransfer
		}
	];

	(*sum up the price for each consolidated transaction entry (this applies to all prices except the Receiving price: Product price, Tax price, Measurement Price (0 USD), and Stocking Price (0 USD)). The receiving fee is charged once per model and not once per item)*)
	{consolidatedTransactionMeasurementPrice, consolidatedStockingPrice}=Map[
		Function[{pricelist},
			Map[
				If[NullQ[#],
					Null,
					Total[#]
				]&,
				pricelist
			]
		],
		{gatheredMeasurementPrice, gatheredStockingPrice}
	];

	(*count the number of objects for a particular model and a particular transaction*)
	consolidatedTransactionAmounts=Length /@ gatheredTransactionObjects;

	(* sum up the measurement and receiving price for each list entry, consisting of 1 receiving cost per model and 1 measurement cost per sample *)
	consolidatedReceivingMeasurementCost=consolidatedTransactionMeasurementPrice + consolidatedReceivingPrice;

	(* instead of the receiving price, charge the stocking price whenever the model was purchased via Instant Transfer *)
	consolidatedTransactionReceivingStockingPrice=MapThread[
		Function[{instantTransfer, stocking, receiving},
			If[TrueQ[instantTransfer],
				stocking,
				receiving
			]
		],
		{consolidatedInstantTransfer, consolidatedStockingPrice, consolidatedReceivingMeasurementCost}
	];

	(* make a tag for the category Receiving for all received samples *)
	transactionReceivingTag=ConstantArray["Receiving", Length[consolidatedReceivingMeasurementCost]];

	(* correct this tag for the samples that were purchased in-house since those are not being charged the receiving/measurement cost, but the stocking prices instead *)
	transactionReceivingStockingTag=MapThread[Function[{instantTransfer, receivingTag}, If[TrueQ[instantTransfer], "Stocking", receivingTag]], {consolidatedInstantTransfer, transactionReceivingTag}];

	(* calculate the price per unit by dividing the summed price by the amount of items in the transaction *)
	(* TODO simplify: *)
	{consolidatedTransactionReceivingStockingPricingRate}=Map[
		(# / consolidatedTransactionAmounts)&,
		{consolidatedTransactionReceivingStockingPrice}
	];

	(*--- PART 4: Construct the final lists for the output tables. Since each price ist listed as an individual row entry, this is done by joining all prices into one big list and constructing the other lists accordingly---*)

	(*join all transaction price lists:product price,tax price,and stocking&receiving price,and delete list items where the price is Null*)
	(*Null entries originate from Transaction[DropShipping], Transaction[SiteToSite], and Transaction[ShipToECL] since there are no Product and Tax prices associated*)

	(*make a boolean for Null entries,these will be filtered out in all other indexmatched lists*)
	transactionPriceNotNullBool=Map[If[NullQ[#], False, True]&, consolidatedTransactionReceivingStockingPrice];

	(*filter the transaction price list for those entries where the price is not Null*)
	totalTransactionPrices=PickList[consolidatedTransactionReceivingStockingPrice, transactionPriceNotNullBool, True];

	(*join all transaction price per units and filter for those entries where the price is not Null*)
	totalTransactionPricePerUnit=PickList[consolidatedTransactionReceivingStockingPricingRate, transactionPriceNotNullBool, True];

	(*join all transaction notebooks,objects,product models,model names. Filter for those entries where the price is not Null*)
	{totalTransactionNotebooks, totalTransactionObjects, totalTransactionMaterial, totalTransactionNames, totalTransactionAmounts, totalTransactionDates}=Map[
		PickList[#, transactionPriceNotNullBool, True]&,
		{consolidatedTransactionNotebooks, consolidatedTransactionObjects, consolidatedTransactionMaterial, consolidatedTransactionNames, consolidatedTransactionAmounts, consolidatedTransactionDates}
	];

	(* get the Site that we will assign the price towards. This is always Destination *)
	totalTransactionSites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,Flatten@myTransactionAllPackets],
				Destination],
			Object]&,
		totalTransactionObjects];

	(*construct the tag list,which consists of a list of Product strings,tax strings,and the previously constructed tag for Receiving&Stocking*)
	totalTransactionTags=PickList[transactionReceivingStockingTag, transactionPriceNotNullBool, True];

	(* join all the lists into one output *)
	totalTransactionOutput={totalTransactionNotebooks, totalTransactionObjects, totalTransactionSites, totalTransactionMaterial, totalTransactionNames, totalTransactionTags, totalTransactionAmounts, totalTransactionPricePerUnit, totalTransactionPrices, totalTransactionDates, ConstantArray[0 Kilogram, Length[totalTransactionDates]], ConstantArray[0 USD, Length[totalTransactionDates]]}
];

(* ::Subsection:: *)
(*PriceStocking*)

Authors[PriceStocking]={"alou", "robert", "dima"};


(* ::Subsubsection::Closed:: *)
(*PriceStocking*)

(* price stocking charges a stocking fee based on how frequently something is use, how much was used and the storage condition *)
(* it needs to look for (public?) samples that are used in protocols and charge accordingly. I'm nto sure if we charge stocking for plates/glassware etc.*)
(*the field in billing has the form of: *)

DefineOptions[PriceStocking,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching TransactionsPriceTableP with the same information, or a combined price of all materials costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | StockingPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Protocol, Material, StorageCondition/UsageFrequency or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceStocking::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus restocking pricing for materials used cannot be calculated: `1`. Please wait until these protocols are completed and then call this function again.";
PriceStocking::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`. These protocols' prices are already included in the restocking pricing of their parent protocols. Please provide only completed parent protocols to the inputs of PriceMaterials.";


(* Singleton Protocol overload *)
PriceStocking[mySource:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceStockingCore[{mySource}, Null, ops];

(* Listed Protocol (and empty list) overload ---> Passes to CORE helper function *)
PriceStocking[mySources:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceStockingCore[mySources, Null, ops];

(* Empty list overload with no date range *)
PriceStocking[myInput:{}, ops:OptionsPattern[]]:=PriceStocking[myInput, Span[Now, Now - 1 * Month], ops];

(* Empty list overload with date range *)
PriceStocking[myInput:{}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[{safeOps, output},

	(* get the safe options *)
	safeOps=SafeOptions[PriceStocking, ToList[ops]];

	(* pull out the OutputFormat *)
	output=Lookup[safeOps, OutputFormat];

	(* depending on the OutputFormat, return an empty list or $0*)
	Switch[{output},
		{Association}, {},
		{Table}, {},
		{TotalPrice}, 0 * USD
	]
];

(* Singleton Notebook overload with no date range *)
PriceStocking[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceStocking[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* Singleton Notebook overload with date range *)
PriceStocking[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceStocking[{myNotebook}, myDateRange, ops];

(* Reverse listable Notebook overload with no date range *)
PriceStocking[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceStocking[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Notebook overload with date range ---> Passes to CORE helper function *)
PriceStocking[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, allNotebooks, sortedDateRange, startDate, endDate, endDateWithTime, allProtocols},

	(* get the safe options *)
	safeOps=SafeOptions[PriceStocking, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	allNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks->allNotebooks,
		PublicObjects->False
	];

	(* pass all the transactions and protocols found in these notebooks to the core function *)
	priceStockingCore[allProtocols, myDateRange, safeOps]

];


(* Singleton Team overload with no date range *)
PriceStocking[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceStocking[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* Singleton Team overload with date range *)
PriceStocking[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceStocking[{myTeam}, myDateRange, ops];

(* Reverse listable Team overload with no date range*)
PriceStocking[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceStocking[myTeams, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Team overload with date range ---> Passes to CORE helper function *)
PriceStocking[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, sortedDateRange, startDate, endDate, endDateWithTime, alternativesTeams, allNotebooks, alternativesNotebooks,
		allProtocols},

	(* get the safe options *)
	safeOps=SafeOptions[PriceStocking, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=Alternatives@@allNotebooks;

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Protocol],Object[Qualification],Object[Maintenance]},
			Status==Completed && ParentProtocol==Null && DateCompleted>startDate && DateCompleted<endDateWithTime,
			Notebooks->allNotebooks,
			PublicObjects->False
		]
	];

	(* pass all the transactions and protocols found in these notebooks to the core function *)
	priceStockingCore[allProtocols, myDateRange, safeOps]
];







(* ::Subsubsection::Closed:: *)
(* priceStockingCore (private) *)


(* --- CORE HELPER FUNCTION --- *)

(* This function is called by the reverse-listable Notebook and Team overloads *)
(* It uses priceMaintenanceCleaning helper function to gather pricing information from dishwashed and autoclaved containers, and then produces an output format displaying the combined pricing information *)
(* Note that we no longer look for dishwash and autoclave protocol/maintenance since the goal is to charge for all glassware that is washed as a result of the customer protocol, not just the washing of things they own*)
(* The inputs are lists of protocols that fall into the correct time range, and start and end date *)
(* The output is (depending on the OutputFormat option) either an association matching StockingPriceTableP or table(s) displaying the pricing information (such as notebook, samples, names, prices, etc.), or a total price of the materials *)

priceStockingCore[
	myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]),
	ops:OptionsPattern[]
]:=Module[
	{
		safeOps,output,cache,consolidation,startDate,endDate,now,

		(* downloads and helper outputs *)
		allInitialDownloadValues,uniqueModels,uniqueProducts,uniqueKitProducts,uniqueBills,secondaryDownload,
		packetRules,protocolPackets,tsReportPackets,allResourcePackets,allObjectPackets,allModelPackets,
		allProductPackets,allKitProductPackets,objectBillPackets,
		notebooks,protocols,datesCompleted,objs,modelNames,pricing,pricingLists,storageCondition,volume,pricingRate,usageFrequency,

		(*table and association variables*)
		allDataTable,associationOutput,totalPrice,tableOutput,numProts,
		noNotebookDataTable,noProtocolDataTable,

		(*consolidation variables*)
		gatheredByProtocol,protocolConsolidatedPreTotal,protocolConsolidatedTotals,protocolConsolidatedTable,
		gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,
		gatheredByModel,modelConsolidatedPreTotal,modelConsolidatedTotals,modelConsolidatedTable,
		gatheredByUsage,usageConsolidatedPreTotal,usageConsolidatedTotals,usageConsolidatedTable,
		numNotebooks,

		(*formatted output*)
		dataTableToUse,subtotalRows,dataWithSubtotal,
		columnHeaders,dataTableDateCompleted,singleTableTitle,

		(* error checking *)
		likelyNoAccessObjects,veryLikelyNoAccessObjects,noAccessObjectPositions,
		filteredResourcePackets,filteredObjectPackets,filteredProducts,filteredKitProducts
		,sites},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceStocking, ToList[ops]];
	{output, consolidation, cache}=Lookup[safeOps, {OutputFormat, Consolidation, Cache}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		With[{sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]]},{First[sortedDateRange], Last[sortedDateRange]}]
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;


	(* to price stocking we need to know product/kit product info, model info, and the amount and status from teh resource *)
	(* Download the information about the the resources used by this protocol and all its subs, the , the name of the models of these objects (containers, parts, items, etc - anything that can be washed), and the notebook of the protocol *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not sample resources and we need to distinguish these cases *)
	allInitialDownloadValues=Quiet[
		Download[
			myProtocols,
			{
				Packet[Notebook, ParentProtocol, Status, DateCompleted, Site],
				Packet[UserCommunications[Refund]],
				Packet[SubprotocolRequiredResources[{Sample, Status, Amount}]],
				Packet[SubprotocolRequiredResources[Sample][{Model}]],
				SubprotocolRequiredResources[Sample][Model][Products][Object],
				SubprotocolRequiredResources[Sample][Model][KitProducts][Object],
				Notebook[Financers][BillingHistory][[All, 2]][Object]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* very important: we need to validate that all our packets are in order. using any invalid packets we should be able to implicitly determine whether the user has access to certain objects *)
	(* the easiest way to identify a malformed packet where we don't have access to the requested object seems to be to search for an object packet wherein Model -> $Failed, since all Objects have a Model field *)
	likelyNoAccessObjects=Lookup[Flatten@Cases[allInitialDownloadValues[[All, 4]], KeyValuePattern[{Object -> ObjectP[], Model -> $Failed}], All], Object, {}];

	(* verify any objects that clearly exist but are not database members *)
	veryLikelyNoAccessObjects=PickList[likelyNoAccessObjects, DatabaseMemberQ[likelyNoAccessObjects], False];

	(* if we have any objects that meet these criterion, throw an error and return $Failed instead of trying to proceed, since these objects will pass broken packets in the code below.
	 if we'd like to change this to a warning by culling all the broken objects, this IS possible, but it's not going to make sense from a pricing perspective. *)
	If[Length[veryLikelyNoAccessObjects] > 0,
		Message[Warning::PricingObjectsArePrivate, veryLikelyNoAccessObjects]
	];

	(* determine the positions of the packets that we need to remove. packets and downloads in allProtocolValues positions {3,4,5,6} are index matched (by SubprotocolRequiredResources), so use the objects packets to pick which of these resources to ignore as a result of lack of access *)
	noAccessObjectPositions=Position[allInitialDownloadValues[[All, 4]], KeyValuePattern[Object -> Alternatives @@ veryLikelyNoAccessObjects]];

	{filteredResourcePackets, filteredObjectPackets, filteredProducts, filteredKitProducts}=Delete[#, noAccessObjectPositions]& /@ {allInitialDownloadValues[[All, 3]], allInitialDownloadValues[[All, 4]], allInitialDownloadValues[[All, 5]], allInitialDownloadValues[[All, 6]]};

	(* extract unique inputs for the second Download *)
	uniqueModels=DeleteDuplicates@Cases[Lookup[Cases[filteredObjectPackets, PacketP[], Infinity], Model], x:LinkP[] :> Download[x, Object]];
	uniqueProducts=DeleteDuplicates@Cases[filteredProducts, ObjectReferenceP[], Infinity];
	uniqueKitProducts=DeleteDuplicates@Cases[filteredKitProducts, ObjectReferenceP[], Infinity];
	uniqueBills=DeleteDuplicates@Cases[allInitialDownloadValues[[All, 7]], ObjectReferenceP[], Infinity];

	(* secondary Download *)
	secondaryDownload=Quiet[
		Download[
			{
				uniqueModels,
				uniqueProducts,
				uniqueKitProducts,
				uniqueBills
			},
			{
				{Packet[Notebook, DefaultStorageCondition, Name, TabletWeight]},
				{Packet[UsageFrequency, Deprecated, NotForSale, Stocked, Notebook]},
				{Packet[KitComponents, NumberOfItems, UsageFrequency, Deprecated, NotForSale, Stocked, Notebook]},
				{Packet[DateStarted, DateCompleted, Status, StockingPricing, IncludedStockingFees, Site]}
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(*- slice out the individual downloaded lists for passing to core private helper -*)

	(* these values are easy - they come directly from the core function *)
	protocolPackets=allInitialDownloadValues[[All, 1]];
	tsReportPackets=allInitialDownloadValues[[All, 2]];
	allResourcePackets=filteredResourcePackets;
	allObjectPackets=filteredObjectPackets;

	(* these values have to be re-organized once we have the data *)
	packetRules=Map[Function[{index}, MapThread[(#1 -> First@ToList@#2)&,
		{
			{
				uniqueModels,
				uniqueProducts,
				uniqueKitProducts,
				uniqueBills
			}[[index]],
			secondaryDownload[[index]]
		}]],
		Range[Length[secondaryDownload]]];

	allModelPackets=(filteredObjectPackets /. (x:PacketP[] :> Download[Lookup[x, Model], Object])) /. packetRules[[1]];
	allProductPackets=filteredProducts /. packetRules[[2]];
	allKitProductPackets=filteredKitProducts /. packetRules[[3]];
	objectBillPackets=allInitialDownloadValues[[All, 7]] /. packetRules[[4]];

	(* get the info required for pricing table generation from a core helper; might return a failure *)
	pricingLists=priceStockingProtocols[
		protocolPackets,
		tsReportPackets,
		allResourcePackets,
		allObjectPackets,
		allModelPackets,
		allProductPackets,
		allKitProductPackets,
		objectBillPackets
	];
	If[MatchQ[pricingLists, $Failed],
		Return[$Failed]
	];

	(* get the info required for pricing table generation from a core helper *)
	{
		notebooks,
		protocols,
		datesCompleted,
		objs,
		modelNames,
		storageCondition,
		usageFrequency,
		volume,
		pricingRate,
		pricing,
		sites
	}=pricingLists;

	(* ------------------------- *)
	(* -- gather pricing info -- *)
	(* ------------------------- *)

	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[pricing, Null], {}],
		0 * USD,
		Total[DeleteCases[pricing, Null]]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, container, containerModel, condition, frequency, vol, rate, price, site},
			Switch[{condition, frequency, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, container, containerModel, condition, frequency, N@vol, N@rate, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, container, containerModel, condition, frequency, vol, rate, price}
			]
		],
		{notebooks, protocols, objs, modelNames, storageCondition, usageFrequency, volume, pricingRate, pricing, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, condition, frequency, vol},
			If[NullQ[condition] || NullQ[frequency] || NullQ[vol],
				Nothing,
				date
			]
		],
		{datesCompleted, storageCondition, usageFrequency, volume}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match StockingPriceTableP *)
	associationOutput=Map[
		AssociationThread[{Notebook, Source, Site, Material, MaterialName, StorageCondition, UsageFrequency, Volume, PricingRate, Price}, #]&,
		allDataTable
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, material, model, storage, frequency, volume, rate, price, site},
			Switch[{storage, frequency, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {protocol, site, material, model, storage, frequency, N@volume, N@rate, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {protocol, site, material, model, storage, frequency, volume, rate, price}
			]
		],
		{protocols, objs, modelNames, storageCondition, usageFrequency, volume, pricingRate, pricing, sites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{material, model, storage, frequency, volume, rate, price},
			Switch[{storage, frequency, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {material, model, storage, frequency, N@volume, N@rate, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {material, model, storage, frequency, volume, rate, price}
			]
		],
		{objs, modelNames, storageCondition, usageFrequency, volume, pricingRate, pricing}
	];


	(* ------------------------- *)
	(* -- Consolidated Tables -- *)
	(* ------------------------- *)

	(* gather by modelname, storagecondition, usagefrequency *)

	(* -- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified -- *)

	(* -- Consolidation: Notebook -- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call. Remove any elements fro which there is no pricing rate *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 10]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* -- Consolidation: Protocol -- *)

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 10]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* -- Consolidation: Model name -- *)

	(* group all the rows in the data table by instrument model *)
	gatheredByModel=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by instrument, before we do the Total call *)
	modelConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 10]], Null]}&,
		gatheredByModel
	];

	(* get the total for each container Model *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	modelConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		modelConsolidatedPreTotal
	];

	(* generate the simplified-by-container model table *)
	modelConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{modelConsolidatedPreTotal, modelConsolidatedTotals}
	];

	(* -- Consolidation: storage method/frequency -- *)

	(* group all the rows in the data table by cleaning method*)
	gatheredByUsage=GatherBy[allDataTable, #[[6;;7]]&];

	(* make a simplified table for pricing grouped by usage/storage method, before we do the Total call *)
	usageConsolidatedPreTotal=Map[
		{#[[1, 6;;7]], DeleteCases[#[[All, 10]], Null]}&,
		gatheredByUsage
	];

	(* get the total for each usage/storage method *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	usageConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		usageConsolidatedPreTotal
	];

	(* generate the simplified-by-usage frequency table *)
	usageConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{usageConsolidatedPreTotal, usageConsolidatedTotals}
	];


	(* ---------------------------- *)
	(* --- Construct the tables --- *)
	(* ---------------------------- *)

	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[notebooks]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Protocol, _, _}, protocolConsolidatedTable,
		{Model, _, _}, modelConsolidatedTable,
		{StorageCondition, _, _}, usageConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];


	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Protocol | Model | StorageCondition, _, _}, {{"", ""}, {"Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", "", "", "", "", ""}, {"", "", "", "", "", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Notebook", "Price"},
		{Protocol, _, _}, {"Protocol", "Price"},
		{Model, _, _}, {"Material Model Name", "Price"},
		{StorageCondition, _, _}, {"Storage Condition and Usage Frequency", "Price"},
		{_, 1, 1}, {"Material", "Material Model Name", "Storage Condition", "Usage Frequency", "Volume", "Pricing Rate", "Price"},
		{_, 1, _}, {"Protocol", "Site", "Material", "Material Model Name", "Storage Condition", "Usage Frequency", "Volume", "Pricing Rate", "Price"},
		{_, _, _}, {"Notebook", "Protocol", "Site", "Material", "Material Model Name", "Storage Condition", "Usage Frequency", "Volume", "Pricing Rate", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Stocking Pricing",
		StringJoin["Stocking Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalPrice
	]
];


(* ::Subsubsection::Closed:: *)
(* priceStockingProtocols (private) *)


(* --- STOCKING PRICING --- *)

(* This function is called in the core function (priceStockingCore) to generate the pricing information *)

(* The inputs are the container packets from the big Download Call in PriceStocking *)
(* The outputs are lists of information about notebook, samples, names, prices, etc for the PriceStocking output table *)

DefineOptions[priceStockingProtocols,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for pricing stocking."}
	}
];

priceStockingProtocols[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myResourcePackets:{{PacketP[Object[Resource]]...}...},
	myObjectPackets:{{(PacketP[Object[]] | $Failed | Null)...}...},
	myModelPackets:{{(PacketP[Model[]] | $Failed | Null)...}...},
	myProductPackets:{{({PacketP[Object[Product]]...} | $Failed | Null)...}...},
	myKitProductPackets:{{({PacketP[Object[Product]]...} | $Failed | Null)...}...},
	myObjectBillPackets:{
		({
			({PacketP[Object[Bill]]...} | $Failed | Null)...
		} | Null)...
	},
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOptions,allowSubprotocolsQ,refundStatus,nonRefundedProtPackets,protocolObjects,protocolNotebooks,

		(* filtering out the washable packets *)
		allStockableObjectPackets,allStockableModelPackets,allStockedObjectStatuses,allStockableProductPackets,
		allStockableKitProductPackets,stockableObjectsP,

		(* index matching lists *)
		billForEachProtocol,
		indexMatchedBills,indexMatchedRefundStatus,indexMatchedNotebooks,indexMatchedProtocols,indexMatchedDateCompleted,
		allStockableResourcePackets,

		allFulfilledStockedObjectPackets,allFulfilledStockedModelPackets,allFulfilledStockedResourcePackets,
		allFulfilledStockedProductPackets,allFulfilledStockedKitProductPackets,

		(* pricing *)
		flatStockedObjectPackets,flatStockedModelPackets,flatStockedResourcePackets,flatStockedProductPackets,flatStockedKitProductPackets,
		stockingPricing,allPackets,volume,

		(* flattened packet lists *)
		flatObjectPackets,flatModelPackets,flatResourcePackets,flatProductPackets,flatKitProductPackets,
		flatIndexMatchedNotebooks,flatIndexMatchedProtocols,flatIndexMatchedDateCompleted,flatIndexMatchedBills,flatIndexMatchedRefundStatus,

		(* error checking *)
		subprotocols,notCompletedProts,noProductsBool,missingBillsQ,

		(* output *)
		stockedObjects,stockedModelNames,storageCondition,usageFrequency,pricingRate,flatIndexMatchedSites},


	(* ----------- *)
	(* -- setup -- *)
	(* ----------- *)

	(* get safe options *)
	safeOptions=SafeOptions[priceStockingProtocols, ToList[myOptions]];
	allowSubprotocolsQ=Lookup[safeOptions, AllowSubprotocols];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* get all the non-refunded protocol packets *)
	nonRefundedProtPackets=PickList[myProtocolPackets, refundStatus, False];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[myProtocolPackets , Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets , Notebook, {}], Object];

	(* ------------------------------ *)
	(* -- identify stocked objects -- *)
	(* ------------------------------ *)

	(*
	objects that need to be restocked are:
	 1) samples that are public
	 1a) samples are Object[Samples] - we are not looking at containers, parts, items etc
	 2) have models
	 3) have products
	 4) entire kits need to be restocked when a component is used
	 *)

	stockableObjectsP=ObjectP[Object[Sample]];

	(* this is a list of lists that is index matched with the input protocols *)
	allStockableObjectPackets=Map[
		Cases[#, stockableObjectsP]&,
		myObjectPackets
	];

	(* extract the matching model packets for each stockable object *)
	allStockableModelPackets=MapThread[
		PickList[#2, #1, stockableObjectsP]&,
		{myObjectPackets, myModelPackets}
	];

	(* extract the matching product packets for each stockable object *)
	allStockableProductPackets=MapThread[
		PickList[#2, #1, stockableObjectsP]&,
		{myObjectPackets, myProductPackets}
	];

	(* extract the matching kit packets for each stockable object *)
	allStockableKitProductPackets=MapThread[
		PickList[#2, #1, stockableObjectsP]&,
		{myObjectPackets, myKitProductPackets}
	];

	(* extract the resources *)
	allStockableResourcePackets=MapThread[
		PickList[#2, #1, stockableObjectsP]&,
		{myObjectPackets, myResourcePackets}
	];

	(* -- check for fulfilled  resources -- *)

	(* get the status of all the selected resource packets *)
	allStockedObjectStatuses=Lookup[#, Status, {}]& /@ allStockableResourcePackets;

	(* collect the fulfilled resources also since we will need ot look at the amount key later for pricing *)
	allFulfilledStockedResourcePackets=Cases[#, KeyValuePattern[Status -> Fulfilled]]& /@ allStockableResourcePackets;

	(* get only the fulfilled resource packets for restocking *)
	allFulfilledStockedObjectPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allStockableObjectPackets, allStockedObjectStatuses}
	];

	(* get the models of only the fulfilled resources for restocking *)
	allFulfilledStockedModelPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allStockableModelPackets, allStockedObjectStatuses}
	];

	(* get the products of only the fulfilled resources for restocking *)
	allFulfilledStockedProductPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allStockableProductPackets, allStockedObjectStatuses}
	];

	allFulfilledStockedKitProductPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allStockableKitProductPackets, allStockedObjectStatuses}
	];

	(* -------------------- *)
	(* -- Error Checking -- *)
	(* -------------------- *)

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceStocking::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceStocking::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(* -------------------------------- *)
	(* -- gather bills and notebooks -- *)
	(* -------------------------------- *)
	(* do the index matching wrt protocols, date completed, etc *)

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket, billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], Status -> Open, DateCompleted -> Null}],
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], DateCompleted -> GreaterEqualP[Lookup[eachProtocolPacket, DateCompleted]]}]
				],
				(*indicate if we couldn't find a bill*)
				NoBillFound
			]
		],
		{
			myProtocolPackets,
			myObjectBillPackets
		}
	];

	(* get the notebook index matched with the rest *)
	indexMatchedNotebooks=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{protocolNotebooks, allFulfilledStockedObjectPackets}
	]];

	(* get the protocol index matched with the rest *)
	indexMatchedProtocols=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, Object, {}], allFulfilledStockedObjectPackets}
	]];

	(* get the protocol's date completed matched with the rest *)
	indexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, DateCompleted, {}], allFulfilledStockedObjectPackets}
	]];

	(* make an index matching list for the bills *)
	indexMatchedBills=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{billForEachProtocol, allFulfilledStockedObjectPackets}
	]];

	(* make an index matching list for the refund status *)
	indexMatchedRefundStatus=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{refundStatus, allFulfilledStockedObjectPackets}
	]];

	(* ------------------------------------- *)
	(* -- prepare the packets for pricing -- *)
	(* ------------------------------------- *)

	(* get all the object, model, and product packets flattened out for stocking*)
	flatStockedObjectPackets=Flatten[allFulfilledStockedObjectPackets];
	flatStockedModelPackets=Flatten[allFulfilledStockedModelPackets];
	flatStockedResourcePackets=Flatten[allFulfilledStockedResourcePackets];

	(* products are a little tricky since they might be multiple. at this point we could filter out deprecated ones adn choose the first of whats left *)
	flatStockedProductPackets=Flatten[
		Map[
			First[Cases[#, KeyValuePattern[{Deprecated -> (False | Null)}]] /. {} -> {Null}]&,
			allFulfilledStockedProductPackets,
			{2}
		]
	];

	(* do the same for kits *)
	flatStockedKitProductPackets=Flatten[
		Map[
			First[Cases[#, KeyValuePattern[{Deprecated -> (False | Null)}]] /. {} -> {Null}]&,
			allFulfilledStockedKitProductPackets,
			{2}
		]
	];

	(* --  filter out things that lack models or products -- *)

	(* make a big nested list of all the things *)
	allPackets=Transpose[
		{
			flatStockedObjectPackets,
			flatStockedModelPackets,
			flatStockedResourcePackets,
			flatStockedProductPackets,
			flatStockedKitProductPackets,

			indexMatchedNotebooks,
			indexMatchedProtocols,
			indexMatchedDateCompleted,
			indexMatchedBills,
			indexMatchedRefundStatus
		}
	];

	(* we are looking for there to be a model, the notebook to be Null, and at least one product informed *)
	{
		flatObjectPackets,
		flatModelPackets,
		flatResourcePackets,
		flatProductPackets,
		flatKitProductPackets,

		flatIndexMatchedNotebooks,
		flatIndexMatchedProtocols,
		flatIndexMatchedDateCompleted,
		flatIndexMatchedBills,
		flatIndexMatchedRefundStatus
	}=Module[{goodElements},

		(* identify usable  product/object/model combinations *)
		goodElements=Cases[
			allPackets,
			Alternatives[
				{_, KeyValuePattern[Notebook -> Null], _, PacketP[], _, _, _, _, _, _},
				{_, KeyValuePattern[Notebook -> Null], _, _, PacketP[], _, _, _, _, _}
			]
		];

		(* if we found matching elements transpose that, other wise just give each an empty list *)
		If[MatchQ[goodElements, {ConstantArray[_, 10]..}],
			Transpose[goodElements],
			ConstantArray[{}, 10]
		]
	];

	(* check if we have any products to check at this point *)
	noProductsBool=If[
		MatchQ[
			Flatten[{flatObjectPackets, flatModelPackets,
				flatResourcePackets, flatProductPackets, flatKitProductPackets, flatIndexMatchedNotebooks,
				flatIndexMatchedProtocols, flatIndexMatchedDateCompleted, flatIndexMatchedBills, flatIndexMatchedRefundStatus}],
			{}
		],
		True,
		False
	];

	(* If we're working with an empty list at this point, skip the rest *)
	If[MatchQ[noProductsBool, True],
		Return[ConstantArray[{}, 11]]
	];

	(* ------------------------ *)
	(* -- price the stocking -- *)
	(* ------------------------ *)

	(*set up error tracking list*)
	missingBillsQ = {};

	(* look up the pricing and the type of washing that is being done *)
	(*this code (kind of) currently straddles the old system, in that there is no charge for dishwashing - we weren't really charging anyway*)
	{stockingPricing, pricingRate, volume}=Transpose[
		MapThread[
			Function[{refundedQ, dateCompleted, modelPacket, productPacket, kitProductPacket, resourcePacket, billPacket},
				(*we check if the protocol finished before or after the pricing system date*)
				Which[
					(*we don't charge for refunded protocols*)
					refundedQ,
					{0 USD, 0 USD / (Centimeter^3), 0 (Centimeter^3)},

					(*if this completed before the pricing system switch, then there's no Object.Bill to associate to and also we aren't charging for dishwashing really*)
					dateCompleted < $PriceSystemSwitchDate,
					{0 USD, 0 USD / (Centimeter^3), 0 (Centimeter^3)},

					(*if it's after the switch, then we'll want to do it based of the CleaningMethod*)
					(*Note: need to reconcile CleaningMethodP and CleaningP - they are different. Not sure if we intend to make these the same or not*)
					True,
					If[MatchQ[Lookup[modelPacket, Notebook], Null] && MatchQ[billPacket, PacketP[]],

						(*determine the price differently for kit and non-kit products*)
						Switch[{productPacket, kitProductPacket},

							(* -- non-kit product -- *)
							{PacketP[], _},
							(* determine the pricing based on the stocking frequency, volume, and storage condition for a non kit product *)
							Module[{safeVolume, pricePerVolume},

								(* figure out a safe volume - assume a density of 1 for everything for now since we are stocking liquids and solids. *)
								safeVolume=Which[

									(* if its a volume, leave it *)
									VolumeQ[Lookup[resourcePacket, Amount]],
									Lookup[resourcePacket, Amount] * 1 (Centimeter^3) / Milliliter,

									(* if its a volume, leave it *)
									MassQ[Lookup[resourcePacket, Amount]],
									UnitConvert[Lookup[resourcePacket, Amount] * 1 (Centimeter^3) / Gram,"Centimeters"^3],

									(* if it is a tablet, determine the mass of the tablet *)
									IntegerQ[Lookup[resourcePacket, Amount]],
									UnitConvert[Lookup[modelPacket, TabletWeight, 0 Gram] * Lookup[resourcePacket, Amount] * 1 (Centimeter^3) / Gram,"Centimeters"^3],

									(* sometimes Amount is also specified as Unities, have to account for this case as well *)
									CompatibleUnitQ[Lookup[resourcePacket, Amount],Quantity[1, "Unities"]],
									UnitConvert[Lookup[modelPacket, TabletWeight, 0 Gram] * Unitless@Lookup[resourcePacket, Amount] * 1 (Centimeter^3) / Gram,"Centimeters"^3],

									(* this should not happen, but it is better to have 0 cm3 than Null *)
									NullQ[Lookup[resourcePacket, Amount]],
									0 Centimeter^3
								];

								(*TODO: as per finances instructions, we are going to remove UsageFrequency from the pricing equation. The commented line below is if we want to re-incorporate it*)
								(* look up the price per volume stocked - note that we may need to look at kit products unless we have integrated the two at this point with a map thread *)
								pricePerVolume=ReplaceAll[
									(*{Lookup[productPacket, UsageFrequency], Download[Lookup[modelPacket, DefaultStorageCondition],Object]},*)
									Download[Lookup[modelPacket, DefaultStorageCondition], Object],
									Map[(Download[#[[1]], Object] -> #[[2]])&, Lookup[billPacket, StockingPricing]]
								];

								(* calculate the price *)
								{pricePerVolume * safeVolume, pricePerVolume, safeVolume}
							],

							(* -- kit product -- *)
							{_, PacketP[]},
							Module[{kitComponents, kitComponentVolumes, kitComponentTotalVolume, pricePerVolume},
								kitComponents=Lookup[kitProductPacket, KitComponents];
								kitComponentVolumes=Lookup[kitComponents, Amount] /. {x:VolumeP :> (UnitConvert[x, Milliliter] * (Centimeter^3) / Gram), x:MassP :> (UnitConvert[y, Gram] * (Centimeter^3) / Gram)};
								(* check that all the kit components have mass or volume. If they dont, just drop those ones *)
								(* also check that the number of items is 1?  *)
								kitComponentTotalVolume=Total[Cases[kitComponentVolumes, VolumeP]] /. {0 -> 0 (Centimeter^3)};

								(*TODO: same comment as above - if the decision to exclude usage frequency is reversed, uncomment*)
								(* calculate the price per volume *)
								pricePerVolume=ReplaceAll[
									(*{Lookup[productPacket, UsageFrequency], Download[Lookup[modelPacket, DefaultStorageCondition], Object]},
									Map[({#[[1]], Download[#[[2]], Object]}->#[[3]])&, Lookup[billPacket,StockingPricing]]*)
									Download[Lookup[modelPacket, DefaultStorageCondition], Object],
									Map[(Download[#[[1]], Object] -> #[[2]])&, Lookup[billPacket, StockingPricing]]
								];

								(* calculate the price *)
								{pricePerVolume * kitComponentTotalVolume, pricePerVolume, kitComponentTotalVolume}
							],


							(* -- if there is no product, its not going to be restocked anyway so there shouldn't be a charge -- *)
							(* this really shouldn't happen but in the case that it does, 0 is fine. *)
							{_, _},
							{0 USD, 0 USD / (Centimeter^3), 0 (Centimeter^3)}
						],
						Append[missingBillsQ, True];{0 USD, 0 USD / (Centimeter^3), 0 (Centimeter^3)}
					]
				]
			],
			{
				flatIndexMatchedRefundStatus,
				flatIndexMatchedDateCompleted,
				flatModelPackets,
				flatProductPackets,
				flatKitProductPackets,
				flatResourcePackets,
				flatIndexMatchedBills
			}
		]
	];

	(* throw and error if we don't have bill info for some entries *)
	If[Length[missingBillsQ]>1,Message[Pricing::NoPricingInfo]];

	(* ------------------------- *)
	(* -- prepared the output -- *)
	(* ------------------------- *)

	(* look up everything else from the flat model/object packets  *)
	usageFrequency=Module[{combinedPackets},
		(* make a list of packets since some resources will have pointed to a kit product and some to a non kit product *)
		combinedPackets=MapThread[
			Which[
				MatchQ[#1, PacketP[]],
				#1,
				MatchQ[#2, PacketP[]],
				#2,
				True,
				<||>
			]&,
			{flatProductPackets, flatKitProductPackets}
		];

		(* pull out the usage frequency *)
		Lookup[combinedPackets, UsageFrequency, {}]
	];
	storageCondition=Lookup[flatModelPackets, DefaultStorageCondition, {}];
	stockedObjects=Download[Lookup[flatObjectPackets, Object, {}], Object];
	stockedModelNames=Lookup[flatModelPackets, Name, {}];
	(* should we also track the volume stocked and the pricing rate from the pricing calculation *)

	(* lookup the site for each protocol *)
	flatIndexMatchedSites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,myProtocolPackets],
				Site],
			Object]&,
		flatIndexMatchedProtocols];

	(* format the joined output *)
	{flatIndexMatchedNotebooks, flatIndexMatchedProtocols, flatIndexMatchedDateCompleted, stockedObjects, stockedModelNames, storageCondition, usageFrequency, volume, pricingRate, UnitConvert[stockingPricing,"USDollars"], flatIndexMatchedSites}
];






(* ::Subsection::Closed:: *)
(*PriceCleaning*)

Authors[PriceCleaning]={"alou", "robert", "dima"};


(* ::Subsubsection::Closed:: *)
(*PriceCleaning*)


(* == PriceCleaning is replacing Price Maintenance! == *)


DefineOptions[PriceCleaning,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching CleaningPriceTableP with the same information, or a combined price of all materials costs used by the input.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | CleaningPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Source, Container Model, Cleaning Category, or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceCleaning::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus pricing from instrument time cannot be calculated: `1`.  Please wait until these protocols are completed and then call this function again.";
PriceCleaning::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`.  These protocols' prices are already included in the price of their parent protocols.  Please provide only completed parent protocols to the inputs of PriceCleaning.";
Warning::PricingObjectsArePrivate="Full pricing information cannot be displayed because the following object(s) are no longer accessible by members of the current financing team as they may have changed ownership: `1`. Please note that these items may still result in usage charges.";


(* singleton Protocol overload *)
PriceCleaning[myProtocol:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceCleaningCore[{myProtocol}, Null, ops];

(* reverse listable Core Protocol overload *)
(* also the empty list overload *)
PriceCleaning[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceCleaningCore[myProtocols, Null, ops];


(* Empty list overload with no date range *)
PriceCleaning[myInput:{}, ops:OptionsPattern[]]:=PriceCleaning[myInput, Span[Now, Now - 1 * Month], ops];

(* Empty list overload with date range *)
PriceCleaning[myInput:{}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[{safeOps, output},

	(* get the safe options *)
	safeOps=SafeOptions[PriceCleaning, ToList[ops]];

	(* pull out the OutputFormat *)
	output=Lookup[safeOps, OutputFormat];

	(* depending on the OutputFormat, return an empty list or $0*)
	Switch[{output},
		{Association}, {},
		{Table}, {},
		{TotalPrice}, 0 * USD
	]
];

(* Singleton Notebook overload with no date range *)
PriceCleaning[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceCleaning[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* Singleton Notebook overload with date range *)
PriceCleaning[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceCleaning[{myNotebook}, myDateRange, ops];

(* Reverse listable Notebook overload with no date range *)
PriceCleaning[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceCleaning[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Notebook overload with date range ---> Passes to CORE helper function *)
PriceCleaning[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, alternativesNotebooks, sortedDateRange, startDate, endDate, endDateWithTime, allProtocols},

	(* get the safe options *)
	safeOps=SafeOptions[PriceCleaning, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceCleaningCore[allProtocols, myDateRange, safeOps]



];


(* Singleton Team overload with no date range *)
PriceCleaning[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceCleaning[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* Singleton Team overload with date range *)
PriceCleaning[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceCleaning[{myTeam}, myDateRange, ops];

(* Reverse listable Team overload with no date range*)
PriceCleaning[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceCleaning[myTeams, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Team overload with date range ---> Passes to CORE helper function *)
PriceCleaning[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, sortedDateRange, startDate, endDate, endDateWithTime, alternativesTeams, allNotebooks, allProtocols, alternativesNotebooks},

	(* get the safe options *)
	safeOps=SafeOptions[PriceCleaning, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceCleaningCore[allProtocols, myDateRange, safeOps]
];



(* ::Subsubsection::Closed:: *)
(* priceCleaningCore (private) *)


(* --- CORE HELPER FUNCTION --- *)

(* This function is called by the reverse-listable Notebook and Team overloads *)
(* It uses priceMaintenanceCleaning helper function to gather pricing information from dishwashed and autoclaved containers, and then produces an output format displaying the combined pricing information *)
(* Note that we no longer look for dishwash and autoclave protocol/maintenance since the goal is to charge for all glassware that is washed as a result of the customer protocol, not just the washing of things they own*)
(* The inputs are lists of protocols that fall into the correct time range, and start and end date *)
(* The output is (depending on the OutputFormat option) either an association matching CleaningPriceTableP or table(s) displaying the pricing information (such as notebook, samples, names, prices, etc.), or a total price of the materials *)

priceCleaningCore[
	myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]),
	ops:OptionsPattern[PriceCleaning]
]:=Module[
	{
		safeOps,output,cache,consolidation,startDate,endDate,now,

		(* downloads and helper outputs *)
		allDownloadValues,objectBillPackets,allModelPackets,allResourcePackets,allObjectPackets,tsReportPackets,protocolPackets,
		notebooks,protocols,datesCompleted,objs,modelNames,cleaningMethod,cleaningCategory,pricing,pricingLists,

		(*table and association variables*)
		allDataTable,associationOutput,totalPrice,tableOutput,numProts,
		noNotebookDataTable,noProtocolDataTable,

		(*consolidation variables*)
		gatheredByProtocol,protocolConsolidatedPreTotal,protocolConsolidatedTotals,protocolConsolidatedTable,
		gatheredByContainerModel,containerModelConsolidatedPreTotal,containerModelConsolidatedTotals,containerModelConsolidatedTable,
		gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,gatheredByCleaningMethod,cleaningMethodConsolidatedPreTotal,
		cleaningMethodConsolidatedTotals,cleaningMethodConsolidatedTable,
		numNotebooks,

		(*formatted output*)
		dataTableToUse,subtotalRows,dataWithSubtotal,
		columnHeaders,dataTableDateCompleted,singleTableTitle,

		(* error checking *)
		likelyNoAccessObjects,veryLikelyNoAccessObjects,noAccessObjectPositions,
		allResourcePacketsFiltered,allObjectPacketsFiltered,allModelPacketsFiltered,sites
	},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceCleaning, ToList[ops]];
	{output, consolidation, cache}=Lookup[safeOps, {OutputFormat, Consolidation, Cache}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		With[{sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]]},{First[sortedDateRange], Last[sortedDateRange]}]
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* Download the information about the the resources used by this protocol and all its subs, the , the name of the models of these objects (containers, parts, items, etc - anything that can be washed), and the notebook of the protocol *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not sample resources and we need to distinguish these cases *)
	allDownloadValues=Quiet[
		Download[
			myProtocols,
			{
				Packet[Notebook, ParentProtocol, Status, DateCompleted, Site],
				Packet[UserCommunications[Refund]],
				Packet[SubprotocolRequiredResources[{Sample, Status}]],
				Packet[SubprotocolRequiredResources[Sample][{Reusable, Model}]],
				Packet[SubprotocolRequiredResources[Sample][Model][{Reusability, CleaningMethod, Sterile, Name}]],
				Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, CleanUpPricing, IncludedCleanings, Site}]]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* slice out the individual downloaded lists for passing to core private helper *)
	protocolPackets=allDownloadValues[[All, 1]];
	tsReportPackets=allDownloadValues[[All, 2]];
	allResourcePackets=allDownloadValues[[All, 3]];
	allObjectPackets=allDownloadValues[[All, 4]];
	allModelPackets=allDownloadValues[[All, 5]];
	objectBillPackets=allDownloadValues[[All, 6]];

	(* very important: we need to validate that all our packets are in order. using any invalid packets we should be able to implicitly determine whether the user has access to certain objects *)
	(* the easiest way to identify a malformed packet where we don't have access to the requested object seems to be to search for an object packet wherein Model -> $Failed, since all Objects have a Model field *)
	likelyNoAccessObjects=Lookup[Flatten@Cases[allObjectPackets, KeyValuePattern[{Object -> ObjectP[], Model -> $Failed}], All], Object, {}];

	(* verify any objects that clearly exist but are not database members *)
	veryLikelyNoAccessObjects=PickList[likelyNoAccessObjects, DatabaseMemberQ[likelyNoAccessObjects], False];

	(* if we have any objects that meet these criterion, throw an error and return $Failed instead of trying to proceed, since these objects will pass broken packets in the code below.
	 if we'd like to change this to a warning by culling all the broken objects, this IS possible, but it's not going to make sense from a pricing perspective. *)
	If[Length[veryLikelyNoAccessObjects] > 0,
		Message[Warning::PricingObjectsArePrivate, veryLikelyNoAccessObjects]
	];

	(* determine the positions of the packets that we need to remove (packets are index matched, so use the objects packets) *)
	noAccessObjectPositions=Position[allObjectPackets, KeyValuePattern[Object -> Alternatives @@ veryLikelyNoAccessObjects]];

	{allResourcePacketsFiltered, allObjectPacketsFiltered, allModelPacketsFiltered}=Delete[#, noAccessObjectPositions]& /@ {allResourcePackets, allObjectPackets, allModelPackets};

	(* get the info required for pricing table generation from a core helper; might return a failure *)
	pricingLists=priceCleaningProtocols[
		protocolPackets,
		tsReportPackets,
		allResourcePacketsFiltered,
		allObjectPacketsFiltered,
		allModelPacketsFiltered,
		objectBillPackets
	];
	If[MatchQ[pricingLists, $Failed],
		Return[$Failed]
	];


	(* get the info required for pricing table generation from a core helper *)
	{notebooks, protocols, datesCompleted, objs, modelNames, pricing, cleaningMethod, cleaningCategory}=pricingLists;

	(* get Site corresponding to the protocols *)
	sites=Map[
		Download[
			Lookup[
				Experiment`Private`fetchPacketFromCache[#,protocolPackets],
				Site],
			Object]&,
		protocols];

	(* ------------------------- *)
	(* -- gather pricing info -- *)
	(* ------------------------- *)


	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[pricing, Null], {}],
		0 * USD,
		Total[DeleteCases[pricing, Null]]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all the cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, container, containerModel, method, category, price, site},
			Switch[{method, category, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {notebook, protocol, site, container, containerModel, method, category, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {notebook, protocol, site, container, containerModel, method, category, price}
			]
		],
		{notebooks, protocols, objs, modelNames, cleaningMethod, cleaningCategory, pricing, sites}
	];

	(* generate a list with the DateCompleted of each row in the DataTable generated above, with the rows with null Time or Rates removed *)
	dataTableDateCompleted=MapThread[
		Function[{date, method, category},
			If[NullQ[method] || NullQ[category],
				Nothing,
				date
			]
		],
		{datesCompleted, cleaningMethod, cleaningCategory}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match CleaningPriceTableP *)
	associationOutput=Map[
		AssociationThread[{Notebook, Source, Site, Container, Name, CleaningMethod, CleaningCategory, Price, Date}, #]&,
		MapThread[Join[#1, {#2}]&, {allDataTable, dataTableDateCompleted}]
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, container, containerModel, method, category, price, site},
			Switch[{method, category, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {protocol, site, container, containerModel, method, category, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {protocol, site, container, containerModel, method, category, price}
			]
		],
		{protocols, objs, modelNames, cleaningMethod, cleaningCategory, pricing, sites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{container, containerModel, method, category, price},
			Switch[{method, category, output, consolidation},
				{Null, _, _, _}, Nothing,
				{_, Null, _, _}, Nothing,
				{_, _, Table, Null}, {container, containerModel, method, category, NumberForm[price, {\[Infinity], 2}]},
				{_, _, _, _}, {container, containerModel, method, category, price}
			]
		],
		{objs, modelNames, cleaningMethod, cleaningCategory, pricing}
	];


	(* ------------------------- *)
	(* -- Consolidated Tables -- *)
	(* ------------------------- *)

	(* -- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified -- *)

	(* -- Consolidation: Notebook -- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call. Remove any elements fro which there is no pricing rate *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* -- Consolidation: Protocol -- *)

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* -- Consolidation: Container Model -- *)

	(* group all the rows in the data table by instrument model *)
	gatheredByContainerModel=GatherBy[allDataTable, #[[4]]&];

	(* make a simplified table for pricing grouped by instrument, before we do the Total call *)
	containerModelConsolidatedPreTotal=Map[
		{#[[1, 4]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByContainerModel
	];

	(* get the total for each container Model *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	containerModelConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		containerModelConsolidatedPreTotal
	];

	(* generate the simplified-by-container model table *)
	containerModelConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{containerModelConsolidatedPreTotal, containerModelConsolidatedTotals}
	];

	(* -- Consolidation: Cleaning Method -- *)

	(* group all the rows in the data table by cleaning method*)
	gatheredByCleaningMethod=GatherBy[allDataTable, #[[6]]&];

	(* make a simplified table for pricing grouped by cleaning method, before we do the Total call *)
	cleaningMethodConsolidatedPreTotal=Map[
		{#[[1, 6]], DeleteCases[#[[All, 8]], Null]}&,
		gatheredByCleaningMethod
	];

	(* get the total for each cleaning method *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	cleaningMethodConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		cleaningMethodConsolidatedPreTotal
	];

	(* generate the simplified-by-cleaning method table *)
	cleaningMethodConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{cleaningMethodConsolidatedPreTotal, cleaningMethodConsolidatedTotals}
	];


	(* ---------------------------- *)
	(* --- Construct the tables --- *)
	(* ---------------------------- *)


	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[notebooks]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Protocol, _, _}, protocolConsolidatedTable,
		{ContainerModel, _, _}, containerModelConsolidatedTable,
		{CleaningCategory, _, _}, cleaningMethodConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];


	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Protocol | ContainerModel | CleaningCategory, _, _}, {{"", ""}, {"Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", "", "", ""}, {"", "", "", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", "", "", "", ""}, {"", "", "", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", "", "", "", ""}, {"", "", "", "", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Notebook", "Price"},
		{Protocol, _, _}, {"Protocol", "Price"},
		{ContainerModel, _, _}, {"Container Model Name", "Price"},
		{CleaningCategory, _, _}, {"Cleaning Method", "Price"},
		{_, 1, 1}, {"Container Object", "Container Model Name", "Cleaning Method", "Cleaning Category", "Price"},
		{_, 1, _}, {"Protocol", "Site", "Container Object", "Model Name", "Cleaning Method", "Cleaning Category", "Price"},
		{_, _, _}, {"Notebook", "Protocol", "Site", "Container Object", "Model Name", "Cleaning Method", "Cleaning Category", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Cleaning Pricing",
		StringJoin["Cleaning Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalPrice
	]
];


(* ::Subsubsection::Closed:: *)
(* priceCleaningProtocols (private) *)


(* --- DISHWASHING AND AUTOCLAVING PRICING --- *)

(* This function is called in the core function (priceCleaningCore) and combines the information yielded from dishwash and autoclave pricing from containers owned by the user *)
(* The function is split into two major parts. In the first part all pricing information regarding dishwashing is calculated. In the second part information regarding the autoclaving is calculated *)

(* The inputs are the container packets from the big Download Call in PriceCleaning *)
(* The outputs are lists of information about notebook, samples, names, prices, etc for the PriceCleaning output table *)

DefineOptions[priceCleaningProtocols,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for instrument time pricing."}
	}
];

priceCleaningProtocols[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myResourcePackets:{{PacketP[Object[Resource]]...}...},
	myObjectPackets:{{(PacketP[Object[]] | $Failed | Null)...}...},
	myModelPackets:{{(PacketP[Model[]] | $Failed | Null)...}...},
	myObjectBillPackets:{
		({
			({PacketP[Object[Bill]]...} | $Failed | Null)...
		} | Null)...
	},
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOptions, allowSubprotocolsQ, refundStatus, nonRefundedProtPackets, protocolObjects, protocolNotebooks,

		(* filtering out the washable packets *)
		allWashableObjectPackets, allWashableModelPackets, allWashedObjectStatuses, washableObjectsP,
		allAutoclavedObjectPackets, allAutoclavedModelPackets,
		allWashedModelPackets, allWashedObjectPackets, allWashableThingsTuples,
		allFulfilledWashedObjectPackets, allFulfilledWashedModelPackets, allAutoclavedObjectStatuses,
		allFulfilledAutoclavedObjectPackets, allFulfilledAutoclavedModelPackets,

		(* index matching lists *)
		billForEachProtocol,
		washIndexMatchedBills, washIndexMatchedRefundStatus, washIndexMatchedNotebooks, washIndexMatchedProtocols, washIndexMatchedDateCompleted,
		autoclaveIndexMatchedBills, autoclaveIndexMatchedRefundStatus, autoclaveIndexMatchedNotebooks, autoclaveIndexMatchedProtocols, autoclaveIndexMatchedDateCompleted,
		allAutoclavedResourcePackets, allWashedResourcePackets, allWashableResourcePackets,

		(* pricing *)
		cleaningMethodLookup, defaultCleanUpPricingLookup, flatWashedObjectPackets, flatWashedModelPackets,
		flatAutoclavedModelPackets, flatAutoclavedObjectPackets, autoclavePricing, washPricing,

		(* error checking *)
		subprotocols, notCompletedProts, missingBillsQ,

		(* output *)
		joinedOutput, washingMethod, washedObjects, washedModelNames,
		autoclavedObjects, autoclavedModelNames, autoclaveMethod,
		autoclaveCategory, washingCategory
	},

	(* ----------- *)
	(* -- setup -- *)
	(* ----------- *)

	(* get safe options *)
	safeOptions=SafeOptions[priceCleaningProtocols, ToList[myOptions]];
	allowSubprotocolsQ=Lookup[safeOptions, AllowSubprotocols];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* get all the non-refunded protocol packets *)
	nonRefundedProtPackets=PickList[myProtocolPackets, refundStatus, False];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[myProtocolPackets , Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets , Notebook, {}], Object];

	(* -------------------------------------------- *)
	(* -- identify the washed/autoclaved objects -- *)
	(* -------------------------------------------- *)

	(* Currently, the way dishwashing is done is by looking at the Reusable field of the Object, and the CleaningMethod field of the model *)
	(* Objects with Object[Reusable] -> True and Object[Model][CleaningMethod] -> Except[Null] are washed *)
	(* the pricing is based on the CleaningMethod (CleaningMethodP) *)

	(* autoclaving is based on the Sterile Field of the Model (Sterile -> True) means it will get autoclaved after dishwashing *)

	(* make a pattern for washable types in case this needs to get updated in the future *)
	washableObjectsP=ObjectP[{Object[Container], Object[Item], Object[Part]}];

	(* this is a list of lists that is index matched with the input protocols *)
	allWashableObjectPackets=Map[
		Cases[#, washableObjectsP]&,
		myObjectPackets
	];

	(* extract the matching model packets for each washable object *)
	allWashableModelPackets=MapThread[
		PickList[#2, #1, washableObjectsP]&,
		{myObjectPackets, myModelPackets}
	];

	(* extract the resources *)
	allWashableResourcePackets=MapThread[
		PickList[#2, #1, washableObjectsP]&,
		{myObjectPackets, myResourcePackets}
	];

	(* from the washable packets, determine which ones were actually washed *)
	allWashableThingsTuples=MapThread[
		Transpose[{#1, #2, #3}]&,
		{allWashableObjectPackets, allWashableModelPackets, allWashableResourcePackets}
	];

	(* -- dishwash -- *)

	(* pull out object packets for objects that will be dishwashed *)
	allWashedObjectPackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[CleaningMethod -> CleaningMethodP], _}][[All, 1]]&,
		allWashableThingsTuples
	];
	(* pull out model packets for objects that will be dishwashed *)
	allWashedModelPackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[CleaningMethod -> CleaningMethodP], _}][[All, 2]]&,
		allWashableThingsTuples
	];
	(* do the same for the resources since we will need ot check later if they were actually fulfilled *)
	allWashedResourcePackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[CleaningMethod -> CleaningMethodP], _}][[All, 3]]&,
		allWashableThingsTuples
	];

	(* -- autoclave -- *)

	(* do the same thing for autoclaved objects *)
	allAutoclavedModelPackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[Sterile -> True], _}][[All, 2]]&,
		allWashableThingsTuples
	];
	(* pull out object packets for objects that will be dishwashed *)
	allAutoclavedObjectPackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[Sterile -> True], _}][[All, 1]]&,
		allWashableThingsTuples
	];
	allAutoclavedResourcePackets=Map[
		Cases[#, {KeyValuePattern[Reusable -> True], KeyValuePattern[Sterile -> True], _}][[All, 3]]&,
		allWashableThingsTuples
	];

	(* -- dishwash -- *)

	(* get the status of all the selected resource packets *)
	allWashedObjectStatuses=Lookup[#, Status, {}]& /@ allWashedResourcePackets;

	(* get only the fulfilled resource packets for washing *)
	allFulfilledWashedObjectPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allWashedObjectPackets, allWashedObjectStatuses}
	];

	(* get the models of only the fulfilled resources for washing *)
	allFulfilledWashedModelPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allWashedModelPackets, allWashedObjectStatuses}
	];

	(* -- autoclave -- *)

	(* get the status of all the selected resource packets *)
	allAutoclavedObjectStatuses=Lookup[#, Status, {}]& /@ allAutoclavedResourcePackets;

	(* get only the fulfilled resource packets for autoclave*)
	allFulfilledAutoclavedObjectPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allAutoclavedObjectPackets, allAutoclavedObjectStatuses}
	];

	(* get the models of only the fulfilled resources for autoclave *)
	allFulfilledAutoclavedModelPackets=MapThread[
		PickList[#1, #2, Fulfilled]&,
		{allAutoclavedModelPackets, allAutoclavedObjectStatuses}
	];

	(* -------------------- *)
	(* -- Error Checking -- *)
	(* -------------------- *)

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceCleaning::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceCleaning::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(* -------------------------------- *)
	(* -- gather bills and notebooks -- *)
	(* -------------------------------- *)
	(* do the index matchin wrt protocols, date completed, etc *)

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket,billList},
			(*the bill can either be ongoing or it's a historical one*)
			With[{protocolSite=Download[Lookup[eachProtocolPacket,Site],Object]},
				FirstCase[
					Flatten[ToList@billList],
					Alternatives[
						KeyValuePattern[{DateStarted->LessEqualP[Lookup[eachProtocolPacket,DateCompleted]],Status->Open,DateCompleted->Null,Site->LinkP[protocolSite]}],
						KeyValuePattern[{DateStarted->LessEqualP[Lookup[eachProtocolPacket,DateCompleted]],DateCompleted->GreaterEqualP[Lookup[eachProtocolPacket,DateCompleted]],Site->LinkP[protocolSite]}]
					],
					(*indicate if we couldn't find a bill*)
					NoBillFound
				]]
		],
		{
			myProtocolPackets,
			myObjectBillPackets
		}
	];

	(* -- dishwash -- *)

	(* get the notebook index matched with the rest *)
	washIndexMatchedNotebooks=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{protocolNotebooks, allFulfilledWashedObjectPackets}
	]];

	(* get the protocol index matched with the rest *)
	washIndexMatchedProtocols=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, Object, {}], allFulfilledWashedObjectPackets}
	]];

	(* get the protocol's date completed matched with the rest *)
	washIndexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, DateCompleted, {}], allFulfilledWashedObjectPackets}
	]];

	(* make an index matching list for the bills *)
	washIndexMatchedBills=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{billForEachProtocol, allFulfilledWashedObjectPackets}
	]];

	(* make an index matching list for the refund status *)
	washIndexMatchedRefundStatus=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{refundStatus, allFulfilledWashedObjectPackets}
	]];


	(* -- autoclave -- *)

	(* get the notebook index matched with the rest *)
	autoclaveIndexMatchedNotebooks=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{protocolNotebooks, allFulfilledAutoclavedObjectPackets}
	]];

	(* get the protocol index matched with the rest *)
	autoclaveIndexMatchedProtocols=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, Object, {}], allFulfilledAutoclavedObjectPackets}
	]];

	(* get the protocol's date completed matched with the rest *)
	autoclaveIndexMatchedDateCompleted=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[myProtocolPackets, DateCompleted, {}], allFulfilledAutoclavedObjectPackets}
	]];

	(* make an index matching list for the bills *)
	autoclaveIndexMatchedBills=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{billForEachProtocol, allFulfilledAutoclavedObjectPackets}
	]];

	(* make an index matching list for the refund status *)
	autoclaveIndexMatchedRefundStatus=Flatten[MapThread[
		ConstantArray[#1, Length[#2]]&,
		{refundStatus, allFulfilledAutoclavedObjectPackets}
	]];

	(* ------------------------------------- *)
	(* -- prepare the packets for pricing -- *)
	(* ------------------------------------- *)

	(* get all the resource packets and model packets flattened out for dishwashing*)
	flatWashedObjectPackets=Flatten[allFulfilledWashedObjectPackets];
	flatWashedModelPackets=Flatten[allFulfilledWashedModelPackets];

	(* get all the resource packets and model packets flattened out for autoclave*)
	flatAutoclavedObjectPackets=Flatten[allFulfilledAutoclavedObjectPackets];
	flatAutoclavedModelPackets=Flatten[allFulfilledAutoclavedModelPackets];


	(* ------------------------ *)
	(* -- price the cleaning -- *)
	(* ------------------------ *)

	(* -- dishwashing -- *)

	(* because the bill clean up pricing is based on different categories than CleaningMethodP, we need make a map to transition *)
	cleaningMethodLookup={
		(DishwashIntensive | DishwashPlastic) -> "Dishwash glass/plastic bottle",
		DishwashPlateSeals -> "Dishwash plate seals",
		Handwash -> "Handwash large labware"
	};

	defaultCleanUpPricingLookup={
		{"Dishwash glass/plastic bottle", Quantity[7., "USDollars"]},
		{"Dishwash plate seals", Quantity[1., "USDollars"]},
		{"Handwash large labware", Quantity[9., "USDollars"]},
		{"Autoclave sterile labware", Quantity[9., "USDollars"]}
	};

	(*set up error tracking list*)
	missingBillsQ = {};

	(* look up the pricing and the type of washing that is being done *)
	(*this code (kind of) currently straddles the old system, in that there is no charge for dishwashing - we weren't really charging anyway*)
	washPricing=MapThread[
		Function[{refundedQ, dateCompleted, modelPacket, billPacket},
			(*we check if the protocol finished before or after the pricing system date*)
			Which[
				(*we don't charge for refunded protocols*)
				refundedQ,
				0 USD,

				(*if this completed before the pricing system switch, then there's no Object.Bill to associate to and also we aren't charging for dishwashing really*)
				dateCompleted < $PriceSystemSwitchDate,
				0 USD,

				(*if it's after the switch, then we'll want to do it based of the CleaningMethod*)
				(*Note: need to reconcile CleaningMethodP and CleaningP - they are different. Not sure if we intend to make these the same or not*)
				True,
				If[MatchQ[Lookup[modelPacket, CleaningMethod], CleaningMethodP] && MatchQ[billPacket, PacketP[]],

					(* use replace repeated to first switch the washing categories, then lookup the price *)
					ReplaceRepeated[
						Lookup[modelPacket, CleaningMethod],
						Join[
							Map[Rule @@ #&, Lookup[billPacket, CleanUpPricing]],
							cleaningMethodLookup
						]
					],

					(* use replace repeated to first switch the washing categories, then lookup the price *)
					Append[missingBillsQ, True];
					ReplaceRepeated[
						Lookup[modelPacket, CleaningMethod],
						Join[
							Map[Rule @@ #&, defaultCleanUpPricingLookup],
							cleaningMethodLookup
						]
					]
				]
			]
		],
		{
			washIndexMatchedRefundStatus,
			washIndexMatchedDateCompleted,
			flatWashedModelPackets,
			washIndexMatchedBills
		}
	];

	(* -- autoclave -- *)
	(*this code (kind of) currently straddles the old system, in that there is no charge for autoclaving - we weren't really charging anyway*)
	autoclavePricing=MapThread[
		Function[{refundedQ, dateCompleted, modelPacket, billPacket},
			(*we check if the protocol finished before or after the pricing system date*)
			Which[
				(*we don't charge for refunded protocols*)
				refundedQ,
				0 USD,

				(*if this completed before the pricing system switch, then there's no Object.Bill to associate to and also we aren't charging for dishwashing really*)
				dateCompleted < $PriceSystemSwitchDate,
				0 USD,

				(*if it's after the switch, then we'll want to do it based on the autoclave price*)
				True,
				If[MatchQ[Lookup[modelPacket, Sterile], True] && MatchQ[billPacket, PacketP[]],
					(* look up the price to autoclave *)
					ReplaceAll[
						"Autoclave sterile labware",
						Map[Rule @@ #&, Lookup[billPacket, CleanUpPricing]]
					],

					(* use default prices if we don't have a bill *)
					Append[missingBillsQ, True];
					ReplaceAll[
						"Autoclave sterile labware",
						Map[Rule @@ #&, defaultCleanUpPricingLookup]
					]
				]
			]
		],
		{
			autoclaveIndexMatchedRefundStatus,
			autoclaveIndexMatchedDateCompleted,
			flatAutoclavedModelPackets,
			autoclaveIndexMatchedBills
		}
	];

	(* throw and error if we don't have bill info for some entries *)
	If[Length[missingBillsQ]>1,Message[Pricing::NoPricingInfo]];

	(* ------------------------- *)
	(* -- prepared the output -- *)
	(* ------------------------- *)

	(* -- washing output -- *)

	(* look up everything else from the flat model/object packets  *)
	washingMethod=Lookup[flatWashedModelPackets, CleaningMethod, {}];
	washingCategory=washingMethod /. cleaningMethodLookup;
	washedObjects=Download[Lookup[flatWashedObjectPackets, Object, {}], Object];
	washedModelNames=Lookup[flatWashedModelPackets, Name, {}];


	(* -- autoclave output -- *)

	autoclavedObjects=Download[Lookup[flatAutoclavedObjectPackets, Object, {}], Object];
	autoclavedModelNames=Lookup[flatAutoclavedModelPackets, Name, {}];
	autoclaveCategory=ConstantArray["Autoclave sterile labware", Length[flatAutoclavedModelPackets]];
	autoclaveMethod=ConstantArray[Autoclave, Length[flatAutoclavedModelPackets]];


	(* -- consolidate the dishwash and autoclave entries -- *)
	(* Transpose the whole thing together and then map join over it. This will give the correct format for output *)

	joinedOutput=Transpose[
		{
			{washIndexMatchedNotebooks, washIndexMatchedProtocols, washIndexMatchedDateCompleted, washedObjects, washedModelNames, washPricing, washingMethod, washingCategory},
			{autoclaveIndexMatchedNotebooks, autoclaveIndexMatchedProtocols, autoclaveIndexMatchedDateCompleted, autoclavedObjects, autoclavedModelNames, autoclavePricing, autoclaveMethod, autoclaveCategory}
		}
	];

	(* return the info required to make the price tables *)
	Flatten /@ joinedOutput
];




(* ::Subsection:: *)
(*PriceData*)

Authors[PriceData]={"alou", "robert", "dima"};


(* ::Subsubsection::Closed:: *)
(*PriceData*)


DefineOptions[PriceData,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching StoragePriceTableP with the same information, or a combined price of all storage costs used by the input notebook(s) or team(s).",
			Category -> "General"
		},
		CacheOption
	}
];

PriceData::MissingPricingRate="The following team objects do not have a listed pricing rate: `1`.  These teams have been filtered out of the displayed results.  Please contact ECL to ensure this field is properly populated for the Object[Bill].";
PriceData::MissingBill="The following items had no bills associated with them: `1`.  Please contact ECL to fix the connection to a bill.";
PriceData::MissingNumberOfObjects="The number of objects could not be queried for the following object teams: `1`. Please notify ECL personnel to this issue.";


(* ::Subsubsection::Closed:: *)
(*PriceData (no date range overloads)*)


(* empty list case *)
PriceData[{}, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceData, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]

];

(* Null case; most likely will be used in the PriceData[$Notebook] going forward *)
PriceData[Null, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceData, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]
];

(* no-input overload just uses $Notebook *)
PriceData[ops:OptionsPattern[]]:=PriceData[$Notebook, ops];

(* singleton Notebook overload with no date range*)
PriceData[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceData[{myNotebook}, ops];

(* reverse listable Notebook overload with no date range (core function called by front end) *)
PriceData[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=Module[
	{},

	(*for notebooks, we merely use the first financing teams*)
	PriceData[Download[myNotebooks, Financers[[1]]], Now, ops]

];

(* singleton Team overload with no date overload *)
PriceData[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceData[{myTeam}, ops];

(* reverse listable Team overload with no date range *)
PriceData[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceData[myTeams, Now, ops];


(* ::Subsubsection::Closed:: *)
(*PriceData core overload*)

(* The output is either a table, list of associations matching DataPriceTableP, a JSON output, or a USD price (depending on the OutputFormat option)*)
PriceData[myTeams:{ObjectP[Object[Team, Financing]]..}, date:_?DateObjectQ, ops:OptionsPattern[]]:=Module[
	{allDownloadValues,constellationPricingRates,numberOfObjectsAssociations,numberOfObjectsList,
		billForEachTeam,nullPricingPackets,teamIDs,safeOps,cache,totalDataPrices,
		totalFinalPrice,allDataTable,associationOutput,preJSONOutput,jsonOutput,
		objectBillPackets,dataTableToUse,subtotalRows,columnHeaders,dataWithSubtotal,tableOutput,teamNames,
		output,teamSites},

	(* get the safe options, and pull the values out *)
	safeOps=SafeOptions[PriceData, ToList[ops]];
	{cache, output}=Lookup[safeOps, {Cache, OutputFormat}];

	(* Download the billing information *)
	allDownloadValues=Quiet[
		Download[myTeams,
			{
				Packet[BillingHistory[[All, 2]][{DateStarted, DateCompleted, Status, ConstellationPrice, PlanType, Site}]],
				ID,
				Name
			},
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(*separate out the object bill packets*)
	objectBillPackets=allDownloadValues[[All, 1]];

	(*get the team IDs*)
	teamIDs=allDownloadValues[[All, 2]];

	(*get the team name*)
	teamNames=allDownloadValues[[All, 3]];

	(*get the best bill for each data and financing team*)
	billForEachTeam=Map[
		Function[{billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[date], DateCompleted -> GreaterEqualP[date]}],
					KeyValuePattern[{DateStarted -> LessEqualP[date], Status -> Open, DateCompleted -> Null}]
				],
				(*indicate if we couldn't find a bill -- note, this symbol is ultimately inconsequential and just for debugging purposes*)
				NoBillFound
			]
		],
		objectBillPackets
	];

	(*do some error checking*)
	If[MemberQ[billForEachTeam, NoBillFound],
		Message[PriceData::MissingBill, PickList[myTeams, billForEachTeam, NoBillFound]]
	];

	(* pull out the storage condition packets that have null pricing rate *)
	nullPricingPackets=Select[billForEachTeam, If[MatchQ[#, PacketP[]], NullQ[Lookup[#, ConstellationPrice]], False]&];

	(* if there are any bill objects that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullPricingPackets, {}]],
		Message[PriceData::MissingPricingRate, Lookup[nullPricingPackets, Object]]
	];

	(*get the constellation pricing rate*)
	constellationPricingRates=billForEachTeam /. {x_Association :> Lookup[x, ConstellationPrice ], NoBillFound :> Null};

	(*get the data usage for each team*)
	(*GetNumOwnedObjects returns a list of associations each with two keys, the id for the financing team and the number of objects*)
	numberOfObjectsAssociations=GetNumOwnedObjects[Download[myTeams, Object], Date -> date];

	(*we want an index-matched list of the number of objects*)
	numberOfObjectsList=Map[
		Function[{eachID},
			Lookup[
				FirstCase[numberOfObjectsAssociations, KeyValuePattern["team_id" -> eachID], <|"num_objects" -> NotFound|>],
				"num_objects"
			]
		],
		teamIDs
	];

	(*check to see if we didn't find the number of objects*)
	If[MemberQ[numberOfObjectsList, NotFound],
		Message[PriceData::MissingNumberOfObjects, PickList[myTeams, numberOfObjectsList, NotFound]]
	];

	(* convert to GB using 50GB per 1 million objects - this estimate will be good to +/- 10% according to engineering*)
	(* price is per TB of data *)
	(* get the total storage price for each item, accounting for volumes *)
	totalDataPrices=MapThread[Function[{pricePerTB, numbOfObjects},
		If[NullQ[pricePerTB] || NullQ[numbOfObjects] || MatchQ[numbOfObjects, NotFound],
			Null,
			Convert[pricePerTB * (numbOfObjects * Unit) * 0.05 / (10^6), USD]
		]],
		{constellationPricingRates, numberOfObjectsList}
	];

	(* get the total total price *)
	totalFinalPrice=If[MatchQ[DeleteCases[totalDataPrices, Null], {}],
		0 * USD / Month,
		Total[DeleteCases[totalDataPrices, Null]]
	];

	(* get the sites for the used bills *)
	teamSites=Download[Lookup[billForEachTeam/.NoBillFound-><||>,Site,Null],Object];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points, but no further manipulations of the numbers *)
	(* if Consolidation -> Except[Null], then we're going to do NumberForm shenanigans later *)
	allDataTable=MapThread[
		Function[{ teamName, teamObject, pricingRate, numberOfObjects, total},
			Which[
				NullQ[pricingRate] || NullQ[numberOfObjects /. {NotFound -> Null}], Nothing,
				MatchQ[output, Table], {teamName, teamObject, NumberForm[pricingRate, {\[Infinity], 2}], numberOfObjects, total},
				MatchQ[output, Association | JSON], {teamName, teamObject, pricingRate, numberOfObjects, total},
				True, {teamName, teamObject, pricingRate, numberOfObjects, total}
			]
		],
		{
			teamNames,
			myTeams,
			constellationPricingRates,
			numberOfObjectsList,
			totalDataPrices
		}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match StoragePriceTableP *)
	associationOutput=If[MatchQ[output, Association | JSON],
		Map[
			AssociationThread[{TeamName, Object, PricingRate, NumberOfObjects, Total, Site}, #]&,
			MapThread[Append[#1,#2]&,{allDataTable,teamSites}]
		],
		{}
	];

	(* generate the precursor to the JSON output *)
	preJSONOutput=Map[
		Function[{assoc},
			{
				"TeamName" -> ToString[Lookup[assoc, TeamName]],
				"Object" -> ToString[Lookup[assoc, Object]],
				"PricingRate" -> Unitless[Lookup[assoc, PricingRate], USD / (10^6 Unit)],
				"NumberOfObjects" -> Unitless[Lookup[assoc, NumberOfObjects], (10^6 Unit)],
				"Total" -> Unitless[Lookup[assoc, Total], USD]
			}
		],
		associationOutput
	];

	(* get the json output *)
	jsonOutput=ExportJSON[preJSONOutput];

	(* generate the table of items that will be displayed if all the information is needed *)
	(* different from allDataTable above because here we are setting the decimal points properly *)
	dataTableToUse=MapThread[
		Function[{ teamName, teamObject, pricingRate, numberOfObjects, total},
			If[NullQ[numberOfObjects] || NullQ[pricingRate],
				Nothing,
				{teamName, teamObject, ToString[NumberForm[Unitless[pricingRate, USD / Unit] * 10^6, {\[Infinity], 2}]]<>" USD per million objects", numberOfObjects, NumberForm[Round[total, 0.01 * USD], {\[Infinity], 2}]}
			]
		],
		{
			teamNames,
			myTeams,
			constellationPricingRates,
			numberOfObjectsList,
			totalDataPrices
		}
	];

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows={{"", "", "", "Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}};

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders={"Team Name", "Team Object", "Pricing Rate", "Number of Objects", "Price"};

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> "Data Pricing"]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		Table, tableOutput,
		Association, associationOutput,
		JSON, jsonOutput,
		TotalPrice, totalFinalPrice
	]

];


(* ::Subsubsection::Closed:: *)
(*PriceData (date overloads)*)
(* --- Date range overloads --- *)


(* singleton Notebook overload with date *)
PriceData[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceData[{myNotebook}, myDate, ops];

(* core reverse listable Notebook overload with date *)
PriceData[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceData[Download[myNotebooks, Financers[[1]]], myDate, ops];

(* singleton Team overload with date *)
PriceData[myTeam:ObjectP[Object[Team, Financing]], myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceData[{myTeam}, myDate, ops];



(* ::Subsection:: *)
(*PriceRecurring*)

Authors[PriceRecurring]={"alou", "robert", "dima"};

(* ::Subsubsection::Closed:: *)
(*PriceRecurring*)


DefineOptions[PriceRecurring,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching StoragePriceTableP with the same information, or a combined price of all storage costs used by the input notebook(s) or team(s).",
			Category -> "General"
		},
		CacheOption
	}
];

PriceRecurring::MissingRecurringPriceInformation="The following team objects do not have all of the recurring price information for their bill object: `1`.  These teams have been filtered out of the displayed results.  Please contact ECL to ensure this field is properly populated for the Object[Bill].";
PriceRecurring::MissingBill="The following items had no bills associated with them: `1`.  Please contact ECL to fix the connection to a bill.";


(* ::Subsubsection::Closed:: *)
(*PriceRecurring (no date range overloads)*)


(* empty list case *)
PriceRecurring[{}, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceRecurring, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]

];

(* Null case; most likely will be used in the PriceRecurring[$Notebook] going forward *)
PriceRecurring[Null, ops:OptionsPattern[]]:=Module[
	{safeOps, output},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceRecurring, ToList[ops]];
	output=Lookup[safeOps, OutputFormat];

	(* return either an empty list or 0*USD depending on what the OutputFormat option is *)
	Switch[output,
		Table, {},
		Association, {},
		TotalPrice, 0 * USD
	]
];

(* no-input overload just uses $Notebook *)
PriceRecurring[ops:OptionsPattern[]]:=PriceRecurring[$Notebook, ops];

(* singleton Notebook overload with no date range*)
PriceRecurring[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceRecurring[{myNotebook}, ops];

(* reverse listable Notebook overload with no date range (core function called by front end) *)
PriceRecurring[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=Module[
	{},

	(*for notebooks, we merely use the first financing teams*)
	PriceRecurring[Download[myNotebooks, Financers[[1]]], Now, ops]

];

(* singleton Team overload with no date overload *)
PriceRecurring[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceRecurring[{myTeam}, ops];

(* reverse listable Team overload with no date range *)
PriceRecurring[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceRecurring[myTeams, Now, ops];


(* ::Subsubsection::Closed:: *)
(*PriceRecurring core overload*)

(* The output is either a table, list of associations matching DataPriceTableP, a JSON output, or a USD price (depending on the OutputFormat option)*)
PriceRecurring[myTeams:{ObjectP[Object[Team, Financing]]..}, date:_?DateObjectQ, ops:OptionsPattern[]]:=Module[
	{allDownloadValues,totalCommandCenterPriceList,
		billForEachTeam,nullPricingPackets,safeOps,cache,totalRecurringPrices,
		totalFinalPrice,allDataTable,associationOutput,preJSONOutput,jsonOutput,maxNumberOfUsers,
		objectBillPackets,dataTableToUse,subtotalRows,columnHeaders,dataWithSubtotal,tableOutput,teamNames,
		output,commandCenterPriceList,labAccessFeeList,numberOfBaselineUsersList,
		privateTutoringFeeList,teamSites},

	(* get the safe options, and pull the values out *)
	safeOps=SafeOptions[PriceRecurring, ToList[ops]];
	{cache, output}=Lookup[safeOps, {Cache, OutputFormat}];

	(* Download the billing information *)
	allDownloadValues=Quiet[
		Download[myTeams,
			{
				Packet[BillingHistory[[All, 2]][{DateStarted, DateCompleted, Status, CommandCenterPrice,
					LabAccessFee, NumberOfBaselineUsers, PrivateTutoringFee, PlanType, Site}]],
				Name,
				MaxUsers
			},
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(*separate out the object bill packets*)
	objectBillPackets=allDownloadValues[[All, 1]];

	(*get the team name*)
	teamNames=allDownloadValues[[All, 2]];

	(*get the maximum number of users*)
	maxNumberOfUsers=allDownloadValues[[All, 3]];

	(*get the best bill for each data and financing team*)
	billForEachTeam=Map[
		Function[{billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[date], DateCompleted -> GreaterEqualP[date]}],
					KeyValuePattern[{DateStarted -> LessEqualP[date], Status -> Open, DateCompleted -> Null}]
				],
				(*indicate if we couldn't find a bill -- note, this symbol is ultimately inconsequential and just for debugging purposes*)
				NoBillFound
			]
		],
		objectBillPackets
	];

	(*do some error checking*)
	If[MemberQ[billForEachTeam, NoBillFound],
		Message[PriceRecurring::MissingBill, PickList[myTeams, billForEachTeam, NoBillFound]]
	];

	(* pull out the packets that have null pricing information *)
	nullPricingPackets=Select[billForEachTeam, If[MatchQ[#, PacketP[]], MemberQ[Lookup[#, {CommandCenterPrice,
		LabAccessFee, NumberOfBaselineUsers, PrivateTutoringFee}], Null], False]&];

	(* if there are any bill objects that don't have any pricing information, throw a soft message *)
	If[Not[MatchQ[nullPricingPackets, {}]],
		Message[PriceRecurring::MissingRecurringPriceInformation, Lookup[nullPricingPackets, Object]]
	];

	(*get all of the relevant information*)
	commandCenterPriceList=billForEachTeam /. {x_Association :> Lookup[x, CommandCenterPrice ], NoBillFound :> Null};
	labAccessFeeList=billForEachTeam /. {x_Association :> Lookup[x, LabAccessFee ], NoBillFound :> Null};
	numberOfBaselineUsersList=billForEachTeam /. {x_Association :> Lookup[x, NumberOfBaselineUsers ], NoBillFound :> Null};
	privateTutoringFeeList=billForEachTeam /. {x_Association :> Lookup[x, PrivateTutoringFee ], NoBillFound :> Null};

	(* get the total storage price for each item, accounting for volumes *)
	totalCommandCenterPriceList=MapThread[
		Function[{eachCommandCenterPrice, eachNumberOfBaselineUsers, eachMaxNumberOfUsers},
			If[MemberQ[{eachCommandCenterPrice, eachNumberOfBaselineUsers, eachMaxNumberOfUsers}, Null],
				Null,
				(*figure out how many extra users are on the team compared to what's allowed in the baseline*)
				eachCommandCenterPrice * Max[0, eachMaxNumberOfUsers - eachNumberOfBaselineUsers]
			]
		],
		{commandCenterPriceList, numberOfBaselineUsersList, maxNumberOfUsers}
	];

	(*calculate the total recurring price now*)
	totalRecurringPrices=MapThread[
		Function[{totalCommandCenter, labAccess, privateTutoring},
			If[MemberQ[{totalCommandCenter, labAccess, privateTutoring}, Null],
				Null,
				Total[{totalCommandCenter, labAccess, privateTutoring}]
			]
		],
		{
			totalCommandCenterPriceList,
			labAccessFeeList,
			privateTutoringFeeList
		}
	];

	(* get the total total price *)
	totalFinalPrice=If[MatchQ[DeleteCases[totalRecurringPrices, Null], {}],
		0 * USD / Month,
		Total[DeleteCases[totalRecurringPrices, Null]]
	];
	teamSites=Download[Lookup[billForEachTeam/.NoBillFound-><||>,Site,Null],Object];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* delete all cases where the amount of time used or pricing rate is Null *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points, but no further manipulations of the numbers *)
	(* if Consolidation -> Except[Null], then we're going to do NumberForm shenanigans later *)
	allDataTable=MapThread[
		Function[{ teamName, teamObject, commandCenterPrice, numberOfBaselineUsers, eachNumberOfUsers, totalCommandCenterPrice, eachLabAccessFee, privateTutoring, eachTotal, site},
			Which[
				NullQ[eachTotal], Nothing,
				MatchQ[output, Table], {teamName, teamObject, NumberForm[commandCenterPrice, {\[Infinity], 2}], numberOfBaselineUsers, eachNumberOfUsers, NumberForm[totalCommandCenterPrice, {\[Infinity], 2}], NumberForm[eachLabAccessFee, {\[Infinity], 2}], NumberForm[privateTutoring, {\[Infinity], 2}], NumberForm[eachTotal, {\[Infinity], 2}]},
				MatchQ[output, Association | JSON], {teamName, teamObject, commandCenterPrice, numberOfBaselineUsers, eachNumberOfUsers, totalCommandCenterPrice, eachLabAccessFee, privateTutoring, eachTotal, site},
				True, {teamName, teamObject, commandCenterPrice, numberOfBaselineUsers, eachNumberOfUsers, totalCommandCenterPrice, eachLabAccessFee, privateTutoring, eachTotal}
			]
		],
		{
			teamNames,
			myTeams,
			commandCenterPriceList,
			numberOfBaselineUsersList,
			maxNumberOfUsers,
			totalCommandCenterPriceList,
			labAccessFeeList,
			privateTutoringFeeList,
			totalRecurringPrices,
			teamSites
		}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match StoragePriceTableP *)
	associationOutput=If[MatchQ[output, Association | JSON],
		Map[
			AssociationThread[{TeamName, Object, CommandCenterPrice, NumberOfBaselineUsers, MaxUsers, CommandCenterTotal, LabAccessFee, PrivateTutoringFee, Total, Site}, #]&,
			allDataTable
		],
		{}
	];

	(* generate the precursor to the JSON output *)
	preJSONOutput=Map[
		Function[{assoc},
			{
				"TeamName" -> ToString[Lookup[assoc, TeamName]],
				"Object" -> ToString[Lookup[assoc, Object]],
				"CommandCenterPrice" -> Unitless[Lookup[assoc, CommandCenterPrice], USD],
				"NumberOfBaselineUsers" -> Unitless[Lookup[assoc, NumberOfBaselineUsers]],
				"MaxUsers" -> Unitless[Lookup[assoc, MaxUsers]],
				"CommandCenterTotal" -> Unitless[Lookup[assoc, CommandCenterTotal], USD],
				"LabAccessFee" -> Unitless[Lookup[assoc, LabAccessFee], USD],
				"PrivateTutoringFee" -> Unitless[Lookup[assoc, PrivateTutoringFee], USD],
				"Total" -> Unitless[Lookup[assoc, Total], USD]
			}
		],
		associationOutput
	];

	(* get the json output *)
	jsonOutput=ExportJSON[preJSONOutput];

	(* generate the table of items that will be displayed if all the information is needed *)
	(* different from allDataTable above because here we are setting the decimal points properly *)
	dataTableToUse=MapThread[
		Function[{ teamName, teamObject, commandCenterPrice, numberOfBaselineUsers, eachNumberOfUsers, totalCommandCenterPrice, eachLabAccessFee, privateTutoring, eachTotal},
			If[NullQ[eachTotal],
				Nothing,
				{
					teamName,
					teamObject,
					NumberForm[Unitless[commandCenterPrice, USD], {Infinity, 2}],
					numberOfBaselineUsers,
					eachNumberOfUsers,
					NumberForm[Unitless[totalCommandCenterPrice, USD], {Infinity, 2}],
					NumberForm[Unitless[eachLabAccessFee, USD], {Infinity, 2}],
					NumberForm[Unitless[privateTutoring, USD], {Infinity, 2}],
					NumberForm[Unitless[eachTotal, USD], {Infinity, 2}]
				}
			]
		],
		{
			teamNames,
			myTeams,
			commandCenterPriceList,
			numberOfBaselineUsersList,
			maxNumberOfUsers,
			totalCommandCenterPriceList,
			labAccessFeeList,
			privateTutoringFeeList,
			totalRecurringPrices
		}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders={
		"Team Name",
		"Team Object",
		"Command Center Price (per additional user)",
		"Number of Baseline Users",
		"Max Number Of Users",
		"Command Center Total",
		"Lab Access Fee",
		"Private Tutoring Fee",
		"Recurring Total"
	};

	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows={{Sequence @@ ConstantArray["", Length[columnHeaders] - 2], "Total Price", NumberForm[totalFinalPrice, {\[Infinity], 2}]}};

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> "Recurring Pricing"]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		Table, tableOutput,
		Association, associationOutput,
		JSON, jsonOutput,
		TotalPrice, totalFinalPrice
	]

];


(* ::Subsubsection::Closed:: *)
(*PriceRecurring (date overloads)*)
(* --- Date range overloads --- *)


(* singleton Notebook overload with date *)
PriceRecurring[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceRecurring[{myNotebook}, myDate, ops];

(* core reverse listable Notebook overload with date *)
PriceRecurring[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceRecurring[Download[myNotebooks, Financers[[1]]], myDate, ops];

(* singleton Team overload with date *)
PriceRecurring[myTeam:ObjectP[Object[Team, Financing]], myDate:_?DateObjectQ, ops:OptionsPattern[]]:=PriceRecurring[{myTeam}, myDate, ops];


(* ::Subsection:: *)
(*PriceProtocol*)


(* ::Subsubsection::Closed:: *)
(*PriceProtocol *)

(* determine the price of each protocol based on if it is priority or not, with rates per protocol drawn from the Object[Bill] *)
Authors[PriceProtocol]={"alou", "robert", "dima"};

DefineOptions[PriceProtocol,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PricingOutputP],
			Description -> "Determines whether the function returns a table for all pricing information that has been requested, or an association matching ProtocolPriceTableP with the same information, or a combined price of all protocol fees.",
			Category -> "General"
		},
		{
			OptionName -> Consolidation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Null | ProtocolPricingConsolidationP],
			Description -> "Determines whether the output table of this function consolidates all pricing information by Notebook, Priority, or not at all.",
			Category -> "General"
		},
		CacheOption
	}
];

PriceProtocol::ProtocolNotCompleted="The following provided protocol(s) are not yet completed and thus pricing cannot be calculated: `1`.  Please wait until these protocols are completed and then call this function again.";
PriceProtocol::ParentProtocolRequired="The following provided protocol(s) are subprotocols: `1`.  These protocols' prices are already included in the price of their parent protocols.  Please provide only completed parent protocols to the inputs of PriceProtocol.";

(* -- Protocol and empty list overloads --*)

(* singleton Protocol overload *)
PriceProtocol[myProtocol:ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], ops:OptionsPattern[]]:=priceProtocolCore[{myProtocol}, Null, ops];

(* reverse listable Core Protocol overload *)
(* also the empty list overload *)
PriceProtocol[myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...}, ops:OptionsPattern[]]:=priceProtocolCore[myProtocols, Null, ops];


(* Empty list overload with no date range *)
PriceProtocol[myInput:{}, ops:OptionsPattern[]]:=PriceProtocol[myInput, Span[Now, Now - 1 * Month], ops];

(* Empty list overload with date range *)
PriceProtocol[myInput:{}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[{safeOps, output},

	(* get the safe options *)
	safeOps=SafeOptions[PriceProtocol, ToList[ops]];

	(* pull out the OutputFormat *)
	output=Lookup[safeOps, OutputFormat];

	(* depending on the OutputFormat, return an empty list or $0*)
	Switch[{output},
		{Association}, {},
		{Table}, {},
		{TotalPrice}, 0 * USD
	]
];

(* -- Notebook overloads -- *)

(* Singleton Notebook overload with no date range *)
PriceProtocol[myNotebook:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=PriceProtocol[{myNotebook}, Span[Now, Now - 1 * Month], ops];

(* Singleton Notebook overload with date range *)
PriceProtocol[myNotebook:ObjectP[Object[LaboratoryNotebook]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceProtocol[{myNotebook}, myDateRange, ops];

(* Reverse listable Notebook overload with no date range *)
PriceProtocol[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, ops:OptionsPattern[]]:=PriceProtocol[myNotebooks, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Notebook overload with date range ---> Passes to CORE helper function *)
PriceProtocol[myNotebooks:{ObjectP[Object[LaboratoryNotebook]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, today, now, alternativesNotebooks, sortedDateRange, startDate, endDate, endDateWithTime, allProtocols},

	(* get the safe options *)
	safeOps=SafeOptions[PriceProtocol, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the notebooks as an Alternatives construct *)
	alternativesNotebooks=Download[myNotebooks, Object];

	(* pull out the start and end date from the date range (sorting, as necessary) *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get all the completed parent protocols in these notebooks *)
	(*warm up search*)
	Quiet[
		Search[
			{Object[Protocol],Object[Qualification],Object[Maintenance]},
			Status==Completed && ParentProtocol==Null && DateCompleted>startDate && DateCompleted<endDateWithTime,
			Notebooks->alternativesNotebooks,
			PublicObjects->False,
			MaxResults->50
		]
	];
	allProtocols=Search[
		{Object[Protocol], Object[Qualification], Object[Maintenance]},
		Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDateWithTime,
		Notebooks -> alternativesNotebooks,
		PublicObjects -> False
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceProtocolCore[allProtocols, myDateRange, safeOps]
];

(* -- Financing Team Overloads -- *)

(* Singleton Team overload with no date range *)
PriceProtocol[myTeam:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]]:=PriceProtocol[{myTeam}, Span[Now, Now - 1 * Month], ops];

(* Singleton Team overload with date range *)
PriceProtocol[myTeam:ObjectP[Object[Team, Financing]], myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=PriceProtocol[{myTeam}, myDateRange, ops];

(* Reverse listable Team overload with no date range*)
PriceProtocol[myTeams:{ObjectP[Object[Team, Financing]]..}, ops:OptionsPattern[]]:=PriceProtocol[myTeams, Span[Now, Now - 1 * Month], ops];

(* Reverse listable Core Team overload with date range ---> Passes to CORE helper function *)
PriceProtocol[myTeams:{ObjectP[Object[Team, Financing]]..}, myDateRange:Span[_?DateObjectQ, _?DateObjectQ], ops:OptionsPattern[]]:=Module[
	{safeOps, now, today, sortedDateRange, startDate, endDate, endDateWithTime, alternativesTeams, allNotebooks, allProtocols, alternativesNotebooks},

	(* get the safe options *)
	safeOps=SafeOptions[PriceProtocol, ToList[ops]];

	(* get the Today and Now values here so they don't change below *)
	today=Today;
	now=Now;

	(* get the start and end dates of the DateRange option *)
	(* to avoid weirdness where specifying Today will inherently not include things that were finished Today by Search, if "Today" is provided, replace Today with Now *)
	sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]];
	startDate=First[sortedDateRange];
	endDate=Last[sortedDateRange];

	(* if the end date is just a Day form, then we're actually excluding that whole day from the Search.  Since there's no MM way to actually do this efficiently, do this wonky shit *)
	endDateWithTime=If[TrueQ[DateList[endDate][[-3;;]] == {0, 0, 0}],
		DateObject[Flatten[{DateList[endDate][[;;3]], {23, 59, 59.99999}}]],
		endDate
	];

	(* get the notebooks as an Alternatives construct *)
	alternativesTeams=Alternatives @@ Download[myTeams, Object];

	(* get all the notebooks that are financed by these teams *)
	allNotebooks=Search[Object[LaboratoryNotebook], Financers == alternativesTeams];

	(* get all the notebooks as an Alternatives construct *)
	alternativesNotebooks=allNotebooks;

	(* get all the completed parent protocols in these notebooks *)
	(* if there are no notebooks financed by this team, then there are obviously also no protocols *)
	(* need to do it this way because otherwise Search will get very upset at getting an Alternatives[] field specification *)
	allProtocols=If[MatchQ[allNotebooks, {}],
		{},
		Quiet[Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False,
			MaxResults->50
		]];
		Search[
			{Object[Protocol], Object[Qualification], Object[Maintenance]},
			Status == Completed && ParentProtocol == Null && DateCompleted > startDate && DateCompleted < endDate,
			Notebooks -> alternativesNotebooks,
			PublicObjects -> False
		]
	];

	(* pass all the protocols found in these notebooks to the core protocol function *)
	priceProtocolCore[allProtocols, myDateRange, safeOps]
];

(* ----------------------- *)
(* -- priceProtocolCore -- *)
(* ----------------------- *)



(* ::Subsubsection::Closed:: *)
(* priceProtocolCore (private) *)


(* --- CORE HELPER FUNCTION --- *)

(* This function is called by the reverse-listable Notebook and Team overloads *)
(* The inputs are lists of protocols that fall into the correct time range, and start and end date *)
(* The output is (depending on the OutputFormat option) either an association matching CleaningPriceTableP or table(s) displaying the pricing information (such as notebook, samples, names, prices, etc.), or a total price of the materials *)

priceProtocolCore[
	myProtocols:{ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myDateRange:(Null | Span[_?DateObjectQ, _?DateObjectQ]),
	ops:OptionsPattern[PriceProtocol]
]:=Module[
	{
		safeOps,output,cache,consolidation,startDate,endDate,now,

		(* downloads and helper outputs *)
		allDownloadValues,objectBillPackets,tsReportPackets,protocolPackets,
		notebooks,protocols,priority,pricing,pricingLists,
		authors,dateCompleted,

		(*table and association variables*)
		allDataTable,associationOutput,totalPrice,tableOutput,numProts,
		noNotebookDataTable,noProtocolDataTable,

		(*consolidation variables*)
		gatheredByProtocol,protocolConsolidatedPreTotal,protocolConsolidatedTotals,protocolConsolidatedTable,
		gatheredByNotebook,notebookConsolidatedPreTotal,notebookConsolidatedTotals,notebookConsolidatedTable,
		gatheredByPriority,priorityConsolidatedPreTotal,priorityConsolidatedTotals,priorityConsolidatedTable,
		numNotebooks,

		(*formatted output*)
		dataTableToUse,subtotalRows,dataWithSubtotal,
		columnHeaders,singleTableTitle,sites
	},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[PriceProtocol, ToList[ops]];
	{output, consolidation, cache}=Lookup[safeOps, {OutputFormat, Consolidation, Cache}];

	(* pull out the start date and end date from the date range (unless it's Null, in which case don't worry about it) *)
	{startDate, endDate}=If[NullQ[myDateRange],
		{Null, Null},
		With[{sortedDateRange = Sort[TimeZoneConvert[List@@myDateRange/. {today -> now}, $TimeZone]]},{First[sortedDateRange], Last[sortedDateRange]}]
	];

	(* Set Now now so it doesn't change during the running of the protocol*)
	now=Now;

	(* Download the information about the the resources used by this protocol and all its subs, the , the name of the models of these objects (containers, parts, items, etc - anything that can be washed), and the notebook of the protocol *)
	(* need to quiet the FieldDoesntExist and NotLinkField messages because some resources are not sample resources and we need to distinguish these cases *)
	allDownloadValues=Quiet[
		Download[
			myProtocols,
			{
				Packet[Notebook, ParentProtocol, Status, DateCompleted, Author, Priority, Site],
				Packet[UserCommunications[Refund]],
				Packet[Notebook[Financers][BillingHistory][[All, 2]][{DateStarted, DateCompleted, Status, PricePerExperiment, PricePerPriorityExperiment}]]
			},
			Cache -> cache,
			SquashResponses -> True,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* slice out the individual downloaded lists for passing to core private helper *)
	protocolPackets=allDownloadValues[[All, 1]];
	tsReportPackets=allDownloadValues[[All, 2]];
	objectBillPackets=allDownloadValues[[All, 3]];

	(* get the info required for pricing table generation from a core helper; might return a failure *)
	pricingLists=priceProtocolFees[
		protocolPackets,
		tsReportPackets,
		objectBillPackets
	];

	If[MatchQ[pricingLists, $Failed],
		Return[$Failed]
	];


	(* get the info required for pricing table generation from a core helper *)
	{notebooks, protocols, priority, pricing, authors, dateCompleted, sites}=pricingLists;

	(* ------------------------- *)
	(* -- gather pricing info -- *)
	(* ------------------------- *)


	(* get the total price for the entire input; this will be returned if OutputFormat -> Price *)
	totalPrice=If[MatchQ[DeleteCases[pricing, Null], {}],
		0 * USD,
		Total[DeleteCases[pricing, Null]]
	];

	(* generate the table of items that will be displayed in a table or provided as an association *)
	(* in this case there is no reason to delete anything since Null and False are the same for Priority *)
	(* need to do NumberForm shenanigans if OutputFormat -> Table and Consolidation -> Null because that allows the correct number of decimal points *)
	(* if Consolidation -> Except[Null], then we're going to do the NumberForm shenanigans below so we shouldn't do them here *)
	allDataTable=MapThread[
		Function[{notebook, protocol, flag, price, site},
			Switch[{output, consolidation},
				{Table, Null}, {notebook, protocol, site, flag, NumberForm[price, {\[Infinity], 2}]},
				{ _, _}, {notebook, protocol, site, flag, price}
			]
		],
		{notebooks, protocols, priority, pricing, sites}
	];

	(* generate the output association; this will be returned if OutputFormat -> Association *)
	(* each entry of this output will match ProtocolPriceTableP *)
	associationOutput=Map[
		AssociationThread[{Notebook, Source, Site, Priority, Price, Author, DateCompleted}, #]&,
		MapThread[Join[#1, {#2, #3}]&, {allDataTable, authors, dateCompleted}]
	];

	(* generate the table of items that will be displayed that also omits the Notebook column (because all items belong to the same notebook) *)
	noNotebookDataTable=MapThread[
		Function[{protocol, flag, price, site},
			Switch[{output, consolidation},
				{Table, Null}, {protocol, site, flag, NumberForm[price, {\[Infinity], 2}]},
				{_, _}, {protocol, site, flag, price}
			]
		],
		{protocols, priority, pricing, sites}
	];

	(* generate the table of items that will be displayed that also omits the Notebook and Protocol columns (because all items belong to the same notebook and protocol) *)
	noProtocolDataTable=MapThread[
		Function[{flag, price, site},
			Switch[{output, consolidation},
				{Table, Null}, {site, flag, NumberForm[price, {\[Infinity], 2}]},
				{_, _}, {site, flag, price}
			]
		],
		{priority, pricing, sites}
	];


	(* ------------------------- *)
	(* -- Consolidated Tables -- *)
	(* ------------------------- *)

	(* -- Generate the consolidated data tables, depending on what/whether the Consolidation option was specified -- *)

	(* -- Consolidation: Notebook -- *)

	(* group all the rows in the data table by Notebook *)
	gatheredByNotebook=GatherBy[allDataTable, #[[1]]&];

	(* make a simplified table for pricing grouped by notebook, before we do the Total call. Remove any elements fro which there is no pricing rate *)
	notebookConsolidatedPreTotal=Map[
		{#[[1, 1]], DeleteCases[#[[All, 5]], Null]}&,
		gatheredByNotebook
	];

	(* get the total for each notebook *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	notebookConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		notebookConsolidatedPreTotal
	];

	(* generate the simplified-by-notebook table *)
	notebookConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{notebookConsolidatedPreTotal, notebookConsolidatedTotals}
	];

	(* -- Consolidation: Protocol -- *)

	(* group all the rows in the data table by Protocol *)
	gatheredByProtocol=GatherBy[allDataTable, #[[2]]&];

	(* make a simplified table for pricing grouped by protocol, before we do the Total call *)
	protocolConsolidatedPreTotal=Map[
		{#[[1, 2]], DeleteCases[#[[All, 5]], Null]}&,
		gatheredByProtocol
	];

	(* get the total for each protocol *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	protocolConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		protocolConsolidatedPreTotal
	];

	(* generate the simplified-by-protocol table *)
	protocolConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{protocolConsolidatedPreTotal, protocolConsolidatedTotals}
	];

	(* -- Consolidation: Priority -- *)

	(* group all the rows in the data table by instrument model *)
	gatheredByPriority=GatherBy[allDataTable, #[[3]]&];

	(* make a simplified table for pricing grouped by priority, before we do the Total call *)
	priorityConsolidatedPreTotal=Map[
		{#[[1, 3]], DeleteCases[#[[All, 5]], Null]}&,
		gatheredByPriority
	];

	(* get the total for each priority *)
	(* the NumberForm is there to ensure that each total always has 2 decimal points *)
	priorityConsolidatedTotals=Map[
		NumberForm[Total[Last[#]], {\[Infinity], 2}]&,
		priorityConsolidatedPreTotal
	];

	(* generate the simplified-by-container model table *)
	priorityConsolidatedTable=MapThread[
		{First[#1], #2}&,
		{priorityConsolidatedPreTotal, priorityConsolidatedTotals}
	];

	(* ---------------------------- *)
	(* --- Construct the tables --- *)
	(* ---------------------------- *)

	(* get the number of notebooks and number of protocols specified in this function *)
	numNotebooks=Length[DeleteDuplicates[notebooks]];
	numProts=Length[DeleteDuplicates[myProtocols]];

	(* generate the data table we are going to output (i.e., pick the one that has the appropriate number of columns, omitting the Notebook and/Or Protocol columns as necessary, or the one that goes with what was specified in the Consolidation option) *)
	dataTableToUse=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, notebookConsolidatedTable,
		{Priority, _, _}, priorityConsolidatedTable,
		{_, 1, 1}, noProtocolDataTable,
		{_, 1, _}, noNotebookDataTable,
		{_, _, _}, allDataTable
	];


	(* generate the subtotal row with the appropriate number of columns *)
	subtotalRows=Switch[{consolidation, numNotebooks, numProts},
		{Notebook | Priority, _, _}, {{"", "", ""}, {"", "Total Price", totalPrice}},
		{_, 1, 1}, {{"", "", ""}, {"", "Total Price", totalPrice}},
		{_, 1, _}, {{"", "", "", ""}, {"", "", "", "Total Price", totalPrice}},
		{_, _, _}, {{"", "", "", "", ""}, {"", "", "", "Total Price", totalPrice}}
	];

	(* generate the column header row with the appropriate number of columns *)
	columnHeaders=Switch[{consolidation, numNotebooks, numProts},
		{Notebook, _, _}, {"Site", "Notebook", "Price"},
		{Priority, _, _}, {"Site", "Priority", "Price"},
		{_, 1, 1}, {"Site", "Priority", "Price"},
		{_, 1, _}, {"Protocol", "Priority", "Site", "Price"},
		{_, _, _}, {"Notebook", "Protocol", "Site", "Priority", "Price"}
	];

	(* make the title for the table for the case where we have a single table*)
	singleTableTitle=If[NullQ[startDate],
		"Protocol Pricing",
		StringJoin["Protocol Pricing from ", DateString[startDate], " to ", DateString[endDate]]
	];

	(* get the whole data table with the subtotal row appended to it *)
	dataWithSubtotal=Join[dataTableToUse, subtotalRows];

	(* generate the table output; this will be returned if OutputFormat -> Table (the Default) *)
	(* if dataTableToUse is {}, then just return {} *)
	tableOutput=If[MatchQ[dataTableToUse, {}],
		{},
		PlotTable[dataWithSubtotal, TableHeadings -> {None, columnHeaders}, UnitForm -> False, Title -> singleTableTitle]
	];

	(* use the OutputFormat option to provide the output *)
	Switch[output,
		(* when OutputFormat -> Table *)
		Table, tableOutput,
		(* when OutputFormat -> Association *)
		Association, associationOutput,
		(* when OutputFormat -> TotalPrice *)
		TotalPrice, totalPrice
	]
];


(* ::Subsubsection::Closed:: *)
(* priceProtocolFees (private) *)


(* This function is called in the core function (priceProtocolCore) and combines determines the price per experiment based on its priority status *)

(* The inputs are the packets from the big Download Call in PriceProtocol *)
(* The outputs are lists of information about notebook, protocol, priority, and prices for the PriceProtocol output table *)

DefineOptions[priceProtocolFees,
	Options :> {
		{AllowSubprotocols -> False, BooleanP, "Indicates if subprotocols are allowed to be considered for protocol pricing."}
	}
];

priceProtocolFees[
	myProtocolPackets:{PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]...},
	myTSReportPackets:{{PacketP[Object[SupportTicket, UserCommunication]]...}...},
	myObjectBillPackets:{
		({({PacketP[Object[Bill]]...} | $Failed | Null)...} | Null)...
	},
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOptions,allowSubprotocolsQ,refundStatus,protocolObjects,protocolNotebooks,

		(* index matching lists *)
		billForEachProtocol,priorities,protocolFees,matchedDateCompleted,

		(* error checking *)
		subprotocols,notCompletedProts,missingBillsQ,

		(* output *)
		authors,sites},

	(* ----------- *)
	(* -- setup -- *)
	(* ----------- *)

	(* get safe options *)
	safeOptions=SafeOptions[priceProtocolFees, ToList[myOptions]];
	allowSubprotocolsQ=Lookup[safeOptions, AllowSubprotocols];

	(* get the refund status of each inputted protocol *)
	refundStatus=Map[
		MemberQ[Lookup[#, Refund, {}], True]&,
		myTSReportPackets
	];

	(* pull out the Object value for each protocol, and the Notebook as well *)
	protocolObjects=Lookup[myProtocolPackets , Object, {}];
	protocolNotebooks=Download[Lookup[myProtocolPackets , Notebook, {}], Object];


	(* -------------------- *)
	(* -- Error Checking -- *)
	(* -------------------- *)

	(* find the protocols that are Subprotocols *)
	subprotocols=Select[myProtocolPackets, Not[NullQ[Lookup[#, ParentProtocol]]]&];

	(* if any provided protocols are subs, throw a message and return an error *)
	If[!allowSubprotocolsQ && Not[MatchQ[subprotocols, {}]],
		(
			Message[PriceProtocol::ParentProtocolRequired, Lookup[subprotocols, Object]];
			Return[$Failed]
		)
	];

	(* find the protocols that are not yet Completed *)
	notCompletedProts=Select[myProtocolPackets, Not[MatchQ[Lookup[#, Status], Completed]]&];

	(* if there are any protocols that are not completed, throw a message and return an error *)
	If[Not[MatchQ[notCompletedProts, {}]],
		(
			Message[PriceProtocol::ProtocolNotCompleted, Lookup[notCompletedProts, Object]];
			Return[$Failed]
		)
	];

	(* -------------------------------- *)
	(* -- gather bills and notebooks -- *)
	(* -------------------------------- *)
	(* do the index matching wrt protocols, date completed, etc *)
	matchedDateCompleted=Lookup[myProtocolPackets, DateCompleted, {}];

	(*we have to choose a bill to use for each protocol. we consider when the protocol completed and when the bill was going*)
	billForEachProtocol=MapThread[
		Function[{eachProtocolPacket, billList},
			(*the bill can either be ongoing or it's a historical one*)
			FirstCase[
				Flatten[ToList@billList],
				Alternatives[
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], Status -> Open, DateCompleted -> Null}],
					KeyValuePattern[{DateStarted -> LessEqualP[Lookup[eachProtocolPacket, DateCompleted]], DateCompleted -> GreaterEqualP[Lookup[eachProtocolPacket, DateCompleted]]}]
				],
				(*indicate if we couldn't find a bill*)
				NoBillFound
			]
		],
		{
			myProtocolPackets,
			myObjectBillPackets
		}
	];

	(* ------------------------ *)
	(* -- price the protocols -- *)
	(* ------------------------ *)

	(*set up error tracking list*)
	missingBillsQ = {};

	(* look up the pricing and the type of protocol that is being done *)
	protocolFees=MapThread[
		Function[{refundedQ, dateCompleted, protPacket, billPacket},
			(*we check if the protocol finished before or after the pricing system date*)
			Which[
				(*we don't charge for refunded protocols*)
				refundedQ,
				0 USD,

				(*if this completed before the pricing system switch, then there's no Object.Bill to associate to so we dont know the protocol price*)
				dateCompleted < $PriceSystemSwitchDate,
				0 USD,

				(*if it's after the switch, then we'll want to do it based of the Priority field of the protocol*)
				True,
				If[MatchQ[Lookup[protPacket, Priority], (BooleanP | Null)] && MatchQ[billPacket, PacketP[]],

					(* just swap out the boolean for the correct price *)
					Lookup[protPacket, Priority] /. {Null -> Lookup[billPacket, PricePerExperiment], False -> Lookup[billPacket, PricePerExperiment], True -> Lookup[billPacket, PricePerPriorityExperiment]},
					(* something is really wrong, I dont think we could have gotten this far without an error *)
					Append[missingBillsQ, True];0 USD
				]
			]
		],
		{
			refundStatus,
			matchedDateCompleted,
			myProtocolPackets,
			billForEachProtocol
		}
	];

	(* throw and error if we don't have bill info for some entries *)
	If[Length[missingBillsQ]>1,Message[Pricing::NoPricingInfo]];

	(* ------------------------ *)
	(* -- prepare the output -- *)
	(* ------------------------ *)

	(* look up the priorities from the protocol packets  *)
	priorities=Lookup[myProtocolPackets, Priority, {}] /. {Null -> "Regular", False -> "Regular", True -> "Priority"};
	authors=Lookup[myProtocolPackets, Author, {}];
	sites=Download[Lookup[myProtocolPackets,Site,{}],Object];

	(* output to priceProtocolCore *)
	{protocolNotebooks, protocolObjects, priorities, protocolFees, authors, matchedDateCompleted, sites}

];