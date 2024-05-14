(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validProductQTests*)


Error::NonUniqueName="There is already a `1` with the name `2`. The name field must be unique for all `1` objects. Please change the value of this options.";
Error::RequiredTogetherOptions="The options `2` are required together for `1`.";
Error::RequiredOptions="The options `1` are required but are currently set to Null for input(s) `2`. Please specify values for these options.";
Error::ManufacturerOptions="The options {Manufacturer,ManufacturerCatalogNumber} should both be specified or both be set to Null. Currently their values are `1`. Please change the values of these options.";
Error::NameIsPartOfSynonyms="The Name of this product must be a member of its Synonyms. Please change the value of these options.";
Error::DefaultContainerModel="Products that are self-contained must not have the DefaultContainerModel option specified. Please change the value of this option.";
Error::ProductAmount="If this product is self contained, Amount must not be specified. If this product is not self contained, Amount must be specified. Please change the values of these options.";
Error::EmeraldSuppliedProductSamples="If Emerald Cloud Lab is the supplier of this product, NumberOfItems must be 1. Currently, its value is `1`. Please change the value of this option.";
Error::EmeraldSuppliedProductContainer="If Emerald Cloud Lab is the supplier of this product, DefaultContainerModel must be a preferred vessel. To see the possible preferred vessels, evaluate PreferredContainer[All]. Please change the value of this option.";
Error::AmountUnitState="The option Amount must match the model's state of matter. Currently, Amount is `1` and the product model's state of matter is `2`. This does not match. Please change the value of these options.";
Error::PricePerUnitRequired="If `1` is not supplied by Emerald Cloud Lab, the Price option must be specified. Please change the value of this option.";
Error::TabletFields="The options Amount and CountPerSample cannot both be informed at the same time, unless the product model is a Model[Sample] that is a Tablet. Please change the value of these fields.";
Error::InvalidKitOptions="If the KitComponents option was specified and not Null, the following options must also be specified: `1`.  These options must be Null if creating a kit.";
Error::InvalidSampleType="The KitComponents option was specified, but the SampleType option was not set to Kit.  This option must be set to Kit if creating a kit.";
Error::SingleKitComponent="The KitComponents option was specified, but only one component was provided.  A kit must have at least two separate components; if only one component is desired, use the non-kit options.";
Error::InvalidContainerIndexPosition="The KitComponents option was specified, but for at least one entry the ContainerIndex and/or Position entires were specified incorrectly.  For each entry of KitComponents, ContainerIndex and Position must not be Null if ProductModel is a NonSelfContainedSampleModel, and must be Null if ProductModel is anything else.";
Error::RepeatedContainerIndex="The KitComponents repeats ContainerIndex entries in cases where the DefaultContainerModel is a Model[Container,Vessel]. Please specify a unique ContainerIndex for each component.";
Error::KitModelAlreadyHasProduct="The KitComponents option was specified, but for the following component ProductModel(s) `1`, a product already exists for that item (see the Products and KitProducts fields).  ProductModels in kits must be exclusive to that kit and cannot have other products tied to them.";
Error::StickerKitInParallelUnused="StickerKitInParallel can only be set if KitComponents is supplied. Please check these values for `1`.";
Error::InvalidProductSite="The Site field is not a member of the ExperimentSites of `1`. The value of Site can be `2` or Null if the product pricing is not site dependent.";
Error::DefaultContainerModelTooManyPositions="If DefaultContainerModel is specified as a Model[Container,Plate], then the plate can not have more than 1 well.";

validProductQTests[packet : PacketP[Object[Product]]] := Module[
	{
		supplier,identifier,resolvedKitComponents,kitQ,validContainerIndex,validVesselIndex,nameAlreadyExistsQ,prodExistsQ,
		existingInventoryObjs,prodModelPacket,defaultContainerModelPacket,allTypes,disallowedPublicSamples,openContainer,
		experimentSites
	},

	(* Stash the object reference of the supplier but with the Name and not the ID *)
	supplier = Download[Lookup[packet, Supplier], Object];

	identifier = FirstCase[Lookup[packet, {Name, Object, ProductModel}], Except[_Missing | Null], packet];

	(* pull out KitComponents because that changes a lot of what we do below *)
	resolvedKitComponents = Lookup[packet, KitComponents];
	kitQ = MatchQ[resolvedKitComponents, {(_Association)..}];

	(* figure out if we're making a new product or not, and if something with this name already exists  *)
	{prodExistsQ, nameAlreadyExistsQ} = If[MatchQ[Lookup[packet, Name], Null],
		{
			DatabaseMemberQ[packet],
			False
		},
		DatabaseMemberQ[{packet, Append[Lookup[packet, Type], Lookup[packet, Name]]}]
	];

	(* get all the types of the existing Samples of this product *)
	allTypes = DeleteDuplicates[Download[Lookup[packet, Samples, {}], Type]];

	(* do some weird shenanigans to only do one Search (or zero, if necessary) *)
	{
		existingInventoryObjs,
		disallowedPublicSamples
	} = Which[
		Not[prodExistsQ] && NullQ[Lookup[packet, Notebook]],
			{{}, {}},
		prodExistsQ && NullQ[Lookup[packet, Notebook]],
			{
				Search[Object[Inventory, Product], StockedInventory == Lookup[packet, Object] && Status == Active && (ReorderThreshold > 0 Unit || ReorderThreshold > 0 Milliliter || ReorderThreshold > 0 Gram)],
				{}
			},
		Not[prodExistsQ] && Not[NullQ[Lookup[packet, Notebook]]],
			{
				{},
				Search[allTypes, Product == Lookup[packet, Object] && Status != Discarded && Notebook == Null]
			},
		True,
			Search[
				{
					{Object[Inventory, Product]},
					allTypes
				},
				{
					StockedInventory == Lookup[packet, Object] && Status == Active && (ReorderThreshold > 0 Unit || ReorderThreshold > 0 Milliliter || ReorderThreshold > 0 Gram),
					Product == Lookup[packet, Object] && Status != Discarded && Notebook == Null
				}
			]
	];

	(* get all the stuff I need for future Downloads *)
	{
		prodModelPacket,
		defaultContainerModelPacket,
		experimentSites
	} = Quiet[Download[
		packet,
		{
			Packet[ProductModel[{Tablet,State,Notebook,OpenContainer}]],
			Packet[DefaultContainerModel[{Deprecated,OpenContainer,Positions}]],
			Notebook[Financers][ExperimentSites][Object]
		}
	], {Download::FieldDoesntExist, Download::MissingField}];

	(* Get OpenContainer value from product model *)
	openContainer=If[NullQ[prodModelPacket],Null,Lookup[prodModelPacket,OpenContainer]];

	(* ContainerIndex and Position can be Null if and only if ProductModel is not a sample *)
	validContainerIndex = If[kitQ,
		Map[
			MatchQ[
				Lookup[#, {ContainerIndex, Position, ProductModel}],
				Alternatives[
					{Null, Null, Except[ObjectP[Model[Sample]], ObjectP[]]},
					{Except[Null], Except[Null], ObjectP[Model[Sample]]}
				]
			]&,
			resolvedKitComponents
		]
	];

	(* ContainerIndex cannot be used multiple times for vessels *)
	validVesselIndex = If[kitQ,
		Module[{indexContainerPairs,duplicatedIndices},

			(* Make a list of all container index and container model pairs  *)
			indexContainerPairs=Lookup[resolvedKitComponents,{ContainerIndex,DefaultContainerModel}];

			(* Create a list of all duplicated indices *)
			duplicatedIndices=DeleteCases[GatherBy[indexContainerPairs,First],{{_Integer, ObjectP[]}}];

			(* Check if any of the container models are vessels *)
			Map[
				Function[duplicatedIndexPairs,
					And@@Map[
						MatchQ[Last[#],Except[ObjectP[Model[Container,Vessel]]]]&,
						duplicatedIndexPairs
					]
				],
				duplicatedIndices
			]
		]
	];

	{
		(* Required fields *)
		NotNullFieldTest[packet,
			{
				Author,
				Supplier,
				CatalogNumber,
				CatalogDescription,
				Packaging,
				SampleType,
				Name,
				NumberOfItems
			},
			Message -> Hold[Error::RequiredOptions],
			MessageArguments -> {identifier}
		],

		RequiredTogetherTest[
			packet,
			{Manufacturer, ManufacturerCatalogNumber},
			Message -> Hold[Error::RequiredTogetherOptions],
			MessageArguments -> {identifier, {Manufacturer, ManufacturerCatalogNumber}}
		],

		(* -- Site tests -- *)

		(* verify that the site is valid for the customer. For any active product, site must be in ExperimentSites. *)
		Test["Private products have a Site field that is Null or a member of the ExperimentSites:",
			If[
				Or[
					MatchQ[Lookup[packet, Site, Null], Null],
					MatchQ[Lookup[packet, Notebook, Null], Null] (*skip public products*)
				],
				True,
				MemberQ[Download[Flatten[ToList[experimentSites]], Object], Download[Lookup[packet, Site], Object]]
			],
			True,
			Message -> Hold[Error::InvalidProductSite],
			MessageArguments -> {Lookup[packet, Site, Null], Download[Flatten[ToList[experimentSites]], Object]}
		],

		Test["Public products have a Site field matching an EmeraldFacility or Null:",
			If[
				Or[
					MatchQ[Lookup[packet, Site, Null], Null],
					MatchQ[Lookup[packet, Notebook, Null], ObjectP[]] (*skip private products*)
				],
				True,
				MemberQ[ECLSites, Download[Lookup[packet, Site], Object]]
			],
			True,
			Message -> Hold[Error::InvalidProductSite],
			MessageArguments -> {Lookup[packet, Site, Null], Download[Flatten[ToList[experimentSites]], Object]}
		],

		Test["If KitComponents is not populated, then StickerKitInParallel must not be populated:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				NullQ[Lookup[packet, StickerKitInParallel, Null]],
				True
			],
			True,
			Message -> Hold[Error::StickerKitInParallelUnused],
			MessageArguments -> {identifier}
		],

		Test["If KitComponents is not populated, ProductModel must be populated:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				MatchQ[Lookup[packet, ProductModel], ObjectP[]],
				True
			],
			True
		],

		Test["If KitComponents is populated, SampleType must be Kit:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, SampleType], Kit]
			],

			True,
			Message -> Hold[Error::InvalidSampleType],
			MessageArguments -> {identifier}
		],

		Test["If KitComponents is populated, DefaultContainerModel, Amount, CountPerSample, and ProductModel must all be Null:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, {DefaultContainerModel, Amount, CountPerSample, ProductModel}], {Null, Null, Null, Null}]
			],
			True,
			Message -> Hold[Error::InvalidKitOptions],
			MessageArguments -> {{DefaultContainerModel, Amount, CountPerSample, ProductModel}}
		],

		Test["If KitComponents is populated, it must have more than one entry (otherwise it is not a kit):",
			MatchQ[Length[Lookup[packet, KitComponents, {}]], 0 | GreaterEqualP[2, 1]],
			True,
			Message -> Hold[Error::SingleKitComponent],
			MessageArguments -> {}
		],
		
		

		Test[
			"The contents of the Name field is a member of the Synonyms field:",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsPartOfSynonyms],
			MessageArguments -> {identifier}
		],

		Test["Amount and CountPerSample cannot both be informed at the same time except for when it's a Sample Chemical and the sample contains Tablets:",
			{
				If[MatchQ[prodModelPacket, ObjectP[Model[Sample]]],
					Lookup[prodModelPacket, Tablet],
					False
				],
				Lookup[packet, Amount, Null],
				Lookup[packet, CountPerSample, Null]
			},
			Alternatives[
				{False | $Failed | Null, NullP, NullP},
				{False | $Failed | Null, Except[NullP], NullP},
				{False | $Failed | Null, NullP, Except[NullP]},
				{True, NullP, _},
				{True, Except[NullP], _}
			],
			Message -> Hold[Error::TabletFields],
			MessageArguments -> {identifier}
		],

		Test["If the product is for a sample that is not self-contained, Amount is informed (unless the sample contains Tablets):",
			If[!kitQ && MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample]]],
				MatchQ[
					{Lookup[prodModelPacket, Object], If[MatchQ[prodModelPacket, ObjectP[Model[Sample]]], Lookup[prodModelPacket, Tablet], Null], Lookup[packet, Amount, Null]},
					Alternatives[
						{SelfContainedSampleModelP, NullP, NullP},
						(* Make a hard-coded exception for packing peanuts, which are a consumable but need Amount for pricing *)
						{NonSelfContainedSampleModelP | ObjectP[Model[Sample, Consumable, "id:R8e1PjpkODwJ"]], NullP | False, Except[NullP]},
						{NonSelfContainedSampleModelP | ObjectP[Model[Sample, Consumable, "id:R8e1PjpkODwJ"]], True, _}
					]

				],
				True
			],
			True,
			Message -> Hold[Error::ProductAmount],
			MessageArguments -> {identifier}
		],
		
		Test["If DefaultContainerModel is informed, it is not Deprecated:",
			If[Not[NullQ[defaultContainerModelPacket]],
				Not[TrueQ[Lookup[defaultContainerModelPacket, Deprecated]]],
				True
			],
			True
		],

		(* DefaultContainerModel should NOT be null for NonSelfContainedSampleModelP, *)
		(* or, alternatively, a Model[Container,ProteinCapillaryElectrophoresisCartridgep *)
		(* product that isnt a sample but contains an insert, so needs DefaultContainerModel populated *)
		Test["If the product is for anything but a non-self-contained sample (except cartridge inserts, which are an exception), DefaultContainerModel is Null:",
			If[MatchQ[Lookup[packet, ProductModel], Except[Alternatives[NonSelfContainedSampleModelP, ObjectP[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert]]]]],
				MatchQ[
					{Lookup[packet, ProductModel], Lookup[packet, DefaultContainerModel]},
					{Except[NonSelfContainedSampleModelP], NullP} | {NonSelfContainedSampleModelP, _}
				],
				True
			],
			True,
			Message -> Hold[Error::DefaultContainerModel],
			MessageArguments -> {identifier}
		],

		(* DefaultContainerModel cannot have more than 1 position if it is a plate *)
		Test["If the DefaultContainerModel is a Model[Container,Plate], the container cannot have more than 1 position:",
			If[MatchQ[defaultContainerModelPacket,TypeP[Model[Container,Plate]]],
				MatchQ[Length[Lookup[defaultContainerModelPacket,Positions]], 1],
				True
			],
			True,
			Message -> Hold[Error::DefaultContainerModelTooManyPositions]
		],

		(* Tests if product is made at Emerald *)
		Test["If Emerald is the supplier, NumberOfItems is 1:",
			{supplier, Lookup[packet, NumberOfItems]},
			Alternatives[
				(* Object[Company, Supplier, "Emerald Cloud Lab"] *)
				{Object[Company, Supplier, "id:eGakld01qrkB"], 1},
				{Except[Object[Company, Supplier, "id:eGakld01qrkB"]], _}
			],
			Message -> Hold[Error::EmeraldSuppliedProductSamples],
			MessageArguments -> {identifier}
		],
		
		Test["Products cannot exist for Model[Sample, StockSolution]s (external Model[Sample, StockSolution, Standard]s are ok):",
			Or[
				MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample, StockSolution, Standard]]] && Not[MatchQ[Lookup[packet, Supplier], LinkP[Object[Company, Supplier, "Emerald Cloud Lab"]]]],
				Not[MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample, StockSolution]]]]
			],
			True
		],
		
		Test["Amount must be appropriate for the model state:",
			Module[{amount, density},
				amount = Lookup[packet, Amount];
				density = Lookup[packet, Density];
				If[QuantityQ[amount],
					With[{modelState = Lookup[prodModelPacket, State]},
						Or[
							(* Liquid can have amount specified as Mass if Density is informed *)
							MassQ[amount] && !MatchQ[density, Null] && MatchQ[modelState, Liquid],
							VolumeQ[amount] && MatchQ[modelState, Liquid],
							(MassQ[amount] || AmountQ[amount] || MatchQ[amount,GreaterP[0Unit,1Unit]]) && MatchQ[modelState, Solid],
							MatchQ[modelState, Null | Gas]
						]
					],
					True
				]
			],
			True,
			Message -> Hold[Error::AmountUnitState],
			MessageArguments -> {identifier,If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null]}
		],

		(* If product isn't supplied by ET / ECL, it must have a list price *)
		Test["If the product is not generated internally by the ECL, Price must be populated:",
			(* Object[Company, Supplier, "Emerald Cloud Lab"] *)
			If[Not[MatchQ[supplier, ObjectP[Object[Company, Supplier, "id:eGakld01qrkB"]]]],
				Not[NullQ[Lookup[packet, Price]]],
				True
			],
			True,
			Message -> Hold[Error::PricePerUnitRequired],
			MessageArguments -> {identifier}
		],

		(* If a product is stocked (i.e., has an existing inventory object for it) it must have a price *)
		Test["If the product is stocked (i.e., has an existing inventory object for it), Price must be populated:",
			Which[
				(* if the object doesn't actually exist yet then just assume this is fine *)
				Not[prodExistsQ], True,
				Length[existingInventoryObjs] > 0, !NullQ[Lookup[packet, Price, Null]],
				True, True
			],
			True
		],

		(* If a product is stocked (i.e., has an existing inventory object for it), it must have UsageFrequency informed *)
		Test["If the product is stocked (i.e., has an existing inventory object for it), UsageFrequency must be populated:",
			Which[
				(* if the object doesn't actually exist yet then just assume this is fine *)
				Not[prodExistsQ], True,
				Length[existingInventoryObjs] > 0, !NullQ[Lookup[packet, UsageFrequency, Null]],
				True, True
			],
			True
		],

		(* If a product is Stocked, it must have UsageFrequency informed *)
		Test["If the product is stocked, i.e. Stocked->True, UsageFrequency must be populated:",
			If[TrueQ[Lookup[packet, Stocked]],
				!NullQ[Lookup[packet, UsageFrequency, Null]],
				True
			],
			True
		],

		(* this check is needed such that PriceMaterials works from the customer side *)
		(* if a public sample is picked whose product is owned by a different team, PriceMaterials can't access that sample *)
		Test["If the product has a notebook, linked non-discarded samples cannot be public:",
			MatchQ[disallowedPublicSamples, {}],
			True
		],

		Test["If Product or ProductModel are not public, the other must also not be public:",
			Or[
				(* if ProductModel isn't populated (i.e., we have a kit) then don't worry about this test *)
				NullQ[Lookup[packet, ProductModel]],
				(* if we are not specifying Notebook in the packet and $AllowPublicObjects goes to True
				it is equivalent to Notebook will be Null *)
				Or[
					NullQ[Lookup[packet, Notebook]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],TrueQ[$AllowPublicObjects]]
				]&& NullQ[Lookup[prodModelPacket, Notebook]],
				(* if we are not specifying Notebook in the packet and $AllowPublicObjects goes to False - raw Upload will always make sure we get a notebook assigned to the object by the time it uploads
				so don't worry about this test as well *)
				Or[
					Not[NullQ[Lookup[packet, Notebook]]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],!TrueQ[$AllowPublicObjects]]
				] && Not[NullQ[Lookup[prodModelPacket, Notebook]]]
			],
			True
		],

		Test["ContainerIndex is not repeated for any kit components whose DefaultContainerModel is a Model[Container,Vessel]:",
			kitQ && MemberQ[validVesselIndex, False],
			False,
			Message -> Hold[Error::RepeatedContainerIndex],
			MessageArguments -> {identifier}
		],

		Test["ContainerIndex/Position is correctly set:",
			kitQ && MemberQ[validContainerIndex, False],
			False,
			Message -> Hold[Error::InvalidContainerIndexPosition],
			MessageArguments -> {identifier}
		],

		(* if the product already exists then who cares, or if the name doesn't already exist we're also good *)
		Test["The Name must be unique among all Object[Product]s:",
			prodExistsQ || Not[nameAlreadyExistsQ],
			True,
			Message -> Hold[Error::NonUniqueName],
			MessageArguments -> {Object[Product],identifier}
		],

		Test["If DefaultCoverModel is populated, DefaultContainerModel must also be populated for any samples:",
			(* if the product model is not a Model[Sample] then return True *)
			If[MatchQ[Lookup[Replace[prodModelPacket,Null-> {}], Object, Null], ObjectP[Model[Sample]]],

				(* if there is a cover model and the product points at a model sample, we need a container model too*)
				If[MatchQ[Lookup[packet, DefaultCoverModel, Null], Null],
					True,
					MatchQ[Lookup[packet, DefaultContainerModel],ObjectP[]]
				],
				True
			],
			True
		],

		Test["The OpenContainer must be populated, if OpenContainer is populated in DefaultContainerModel:",
			If[
				MatchQ[defaultContainerModelPacket,Null],
				True,
				If[
					MatchQ[Lookup[defaultContainerModelPacket, OpenContainer, Null], Null|False],
					True,
					MatchQ[Lookup[packet, OpenContainer],Lookup[defaultContainerModelPacket, OpenContainer]]
				]
			],
			True
		]
	}
];

errorToOptionMap[Object[Product]] := {
	"Error::RequiredOptions" -> {Author,
		Supplier,
		CatalogNumber,
		CatalogDescription,
		Packaging,
		SampleType,
		Name,
		NumberOfItems},
	"Error::RequiredTogetherOptions" -> {Manufacturer, ManufacturerCatalogNumber},
	"Error::StickerKitInParallelUnused" -> {KitComponents, StickerKitInParallel},
	"Error::InvalidSampleType" -> {KitComponents, SampleType},
	"Error::InvalidKitOptions" -> {KitComponents, DefaultContainerModel, Amount, CountPerSample, ProductModel},
	"Error::SingleKitComponent" -> {KitComponents},
	"Error::InvalidContainerIndexPosition" -> {KitComponents, ContainerIndex, Position},
	"Error::NameIsPartOfSynonyms" -> {Name, Synonyms},
	"Error::TabletFields" -> {Amount, CountPerSample},
	"Error::DefaultContainerModel" -> {ProductModel, "NonSelfContainedSampleModelP"},
	"Error::EmeraldSuppliedProductSamples" -> {Supplier, NumberOfItems},
	"Error::AmountUnitState" -> {Amount,State},
	"Error::PricePerUnitRequired" -> {Price},
	"Error::ProductAmount" -> {Amount},
	"Error::InvalidContainerIndexPosition" -> {ContainerIndex, Position},
	"Error::KitModelAlreadyHasProduct" -> KitComponents,
	"Error::NonUniqueName" -> Name
};


(* ::Subsection:: *)
(*validProductCapillaryELISACartridgeQTests*)


validProductCapillaryELISACartridgeQTests[packet : PacketP[Object[Product, CapillaryELISACartridge]]] := With[
	{
		(* get the packet for the ManufacturingSpecifications *)
		manufacturingSpecPackets = Download[Lookup[packet, ManufacturingSpecifications], Packet[AnalyteName, AnalyteMolecule]]
	},
	{
		NotNullFieldTest[packet, {(*MinOrderQuantity,*)CartridgeType}],

		(* Analytes information must be populated for cartridges that are not customizable *)
		If[!MatchQ[Lookup[packet, CartridgeType], Customizable],
			NotNullFieldTest[packet, {AnalyteNames, AnalyteMolecules, ManufacturingSpecifications}],
			NullFieldTest[packet, {AnalyteNames, AnalyteMolecules, ManufacturingSpecifications}]
		],

		(* Length of Analytes information should match the CartridgeType - or smaller *)
		Test["Number of AnalyteNames should match the CartridgeType:",
			MatchQ[{Lookup[packet, CartridgeType], Length[Lookup[packet, AnalyteNames]]}, {SinglePlex72X1, 1} | {MultiAnalyte16X4, LessEqualP[4]} | {MultiAnalyte32X4, LessEqualP[4]} | {MultiPlex32X8, LessEqualP[8]} | {Customizable, 0}],
			True
		],

		(* AnalyteNames and ManufacturingSpecifications should match each other - Also, they should not have Null members *)
		Test["AnalyteNames should match ManufacturingSpecifications:",
			And @@ (
				MapThread[
					If[!NullQ[#1] && !NullQ[#2],
						MatchQ[#1, Lookup[#2, AnalyteName]],
						False
					]&,
					{Lookup[packet, AnalyteNames], manufacturingSpecPackets}
				]
			),
			True
		],

		(* AnalyteNames and ManufacturingSpecifications should match each other - Also, they should not have Null members *)
		Test["AnalyteMolecules should match ManufacturingSpecifications:",
			And @@ (
				MapThread[
					If[!NullQ[#1] && !NullQ[#2],
						MatchQ[Download[#1, ID], Download[Lookup[#2, AnalyteMolecule], ID]],
						False
					]&,
					{Lookup[packet, AnalyteMolecules], manufacturingSpecPackets}
				]
			),
			True
		]

	}
];


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Product],validProductQTests];
registerValidQTestFunction[Object[Product,CapillaryELISACartridge],validProductCapillaryELISACartridgeQTests];
