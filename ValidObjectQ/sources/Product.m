(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validProductQTests*)


Error::NonUniqueName="There is already a `1` with the name `2`. The name field must be unique for all `1` objects. Please change the value of this options.";
Error::RequiredTogetherOptions="The options `2` are required together for `1`. Please supply non-Null value for both options, or set both to Null.";
Error::RequiredTogetherOptionsFromExternalSource = "For input type `1`, because options `3` have been set by `4`, `2` options are also required. Please specify value for option `2`, or set `3` to Null manually.";
Error::RequiredTogetherOptionsCannotFindFromExternalSource = "For input type `1`, because you have specified option `2`, option `3` is also required but cannot be found from `4`. Please manually specify `3` options, or change `2` to Null.";
Error::RequiredTogetherOptionsConflictFromExternalSource = "For input type `1`, because options `2` have been set by `4`, `3` options are also required but can't be found from `4`. Please specify values for the `3` options, or set `2` to Null manually.";
Error::RequiredOptions="The options `1` are required but are currently set to Null for input(s) `2`. Please specify values for these options.";
Error::UnableToFindInfo = "`4` was unable to find information about the following options `1` from `3` for input(s) `2`. Please specify values for these options manually.";
Error::UnableToResolveOption = "The options `1` are required but are not able to be determined automatically for input type `2`. Please specify values for these options manually.";
Error::NameIsPartOfSynonyms="The Name of this input type `1` must be a member of its Synonyms. Please change the value of these options.";
Error::DefaultContainerModel="Products that are not sample or chemical must not have the `1` option specified. Please change the value of this option.";
Error::ProductAmount="`1` must be specified for sample type product except if the sample is tablet or sachet. Please provide value for `1` option.";
Error::ProductAmountFromExternalSource = "`1` must be specified for sample type product except if the sample is tablet or sachet; however, it can't be found from `2`. Please provide value for `1` option.";
Error::EmeraldSuppliedProductSamples="If Emerald Cloud Lab is the supplier of this product, `1` must be 1. Currently, its value is `2`. Please change the value of this option.";
Error::AmountUnitState="The option `3` must match the model's state of matter. Currently, Amount is `1` and the product model's state of matter is `2`. This does not match. Solid cannot have amount specified in volume units. Please correct the Amount option.";
Error::AmountUnitStateFromExternalSource = "The option `3` must match the model's state of matter. Currently, Amount is `1` according to `4` and the product model's state of matter is `2`. This does not match. Solid cannot have amount specified in volume units. Please manually correct the Amount option.";
Error::PricePerUnitRequired="If `1` is not supplied by Emerald Cloud Lab, the `2` option must be specified. Please change the value of this option.";
Error::PricePerUnitRequiredFromExternalSource="If `1` is not supplied by Emerald Cloud Lab, the `2` option must be specified but can't be found from `3`. Please change the value of this option.";
Error::TabletSachetFields="The options `1` and `2` cannot both be informed at the same time, unless the product model is a Model[Sample] that is a Tablet or Sachet. Please change the value of these fields.";
Error::InvalidKitOptions="If the `1` option was specified and not Null, the following options must be Null: `2` in order to create a kit. Please change `2` to Null, or change `1` to Null.";
Error::InvalidKitOptionsFromExternalSource="Since you have specified `1` option, the following options must be Null: `2` in order to create a kit, but they are currently set to `3` according to `4`. Please set `2` to Null manually, or change `1` to Null.";
Error::InvalidKitOptionsWithExternalSource="You have specified `2` option to `3`; however, option `1` is set to non-Null according to `4`, which means `2` must be Null. Please set `2` to Null manually, or change `1` to Null.";
Error::InvalidKitOptionsBetweenExternalSource="Option `1` is set to non-Null and `2` is set to `3`, both according to `4`; however, this is not allowed. Please set `2` to Null manually, or change `1` to Null.";
Error::InvalidSampleType="Since the `1` option was specified, the `2` option must be set to Kit, which is not the case now. Please change `2` to Kit, or set `1` to Null.";
Error::InvalidSampleTypeFromExternalSource="Since the `1` option was specified, the `2` option must be set to Kit, but it's currently set to `3` according to `4`. Please change `2` to Kit, or set `1` to Null.";
Error::InvalidSampleTypeWithExternalSource="You have set `2` option to `3`, which is not allowed since `1` option is set to non-Null according to `4`, which means `2` must be Kit. Please change `2` to Kit, or manually set `1` to Null.";
Error::InvalidSampleTypeBetweenExternalSource="The `2` option to `3` and `1` option is set to non-Null, both according to `4`, which is not allowed. Please change `2` to Kit, or manually set `1` to Null.";
Error::SingleKitComponent="The `1` option was specified, but only one component was provided. A kit must have at least two separate components; if only one component is desired, use the non-kit options and inputs, such as DefaultContainerModel, ProductModel, DefaultCoverModel, Amount, CountPerSample.";
Error::SingleKitComponentFromExternalSource="The option `1` was set to `2` according to `3`, which has only one component. This is not allowed; a kit must have at least two separate components. If only one component is desired, use the non-kit options and inputs, such as DefaultContainerModel, ProductModel, DefaultCoverModel, Amount, CountPerSample.";
Error::InvalidContainerIndexPosition="The `1` option was specified, but for at least one entry the ContainerIndex and/or Position entries were specified incorrectly. For each entry of KitComponents, ContainerIndex and Position must not be Null if ProductModel is a NonSelfContainedSampleModel, and must be Null if ProductModel is anything else.";
Error::RepeatedContainerIndex="The ContainerIndex entries in the `1` option cannot be repeated in cases where the DefaultContainerModel is a Model[Container,Vessel]. Please specify a unique ContainerIndex for each component.";
Error::StickerKitInParallelNotAllowed="Since you did not provide value for `2` option, `1` must be set to Null. Please change your `1` to Null, or supply values for `2`.";
Error::StickerKitInParallelNotAllowedFromExternalSource="The `1` option was set to `3` according to `4`, which is not allowed because you have set `2` option to Null. Please either manually set `1` to Null, or supply values for `2`.";
Error::StickerKitInParallelNotAllowedBetweenExternalSource="The `1` option was set to `3`, while option `2` was set to Null, both according to `4`. This is not allowed; please manually set `1` to Null, or supply values for `2`.";
Error::InvalidProductSite="The current `1` option `2` is not a member of an allowed ExperimentSites. The value of Site can be `3` or Null if the product pricing is not site dependent.";
Error::InvalidProductSiteFromExternalSource = "The current `1` option is set to `2` according to `4`, is not a member of an allowed ExperimentSites. The value of Site can be `3` or Null if the product pricing is not site dependent.";
Error::DefaultContainerModelTooManyPositions="A Model[Container,Plate] with more than 1 well cannot be specified as the `1` option. Please use an alternative or leave the option Null. If you are trying to create a product of a plate which contains multiple samples, please use the KitComponents option instead.";
Error::UnsupportedAsepticReceiving="`1`, indicating the use of aseptic sample receiving techniques; however, `2`, indicating the use of standard receiving techniques. If aseptic receiving techniques are desired, please set `3`. If standard receiving techniques are desired, please set `4`.";
Error::IncompatibleAsepticShippingAndReceiving="`1`";
Error::AsepticRebaggingContainerTypeRequired="`1`";
Error::CountedProduct="`1` option must be specified when the associated ProductModel is marked as counted. Please provide value to option `1`.";
Error::CountedProductFromExternalSource="`1` option must be specified when the associated ProductModel is marked as counted; however, UploadProduct is not able to find information from `2`. Please manually supply value for `1`.";
Error::NotCountedProduct="`1` option must be Null when the associated ProductModel is not marked as counted. Please set option `1` to Null.";
Error::NotCountedProductFromExternalSource="`1` option must be Null when the associated ProductModel is marked as counted; however, UploadProduct incorrectly set it to `3` according to `2`. Please manually set option `1` to Null.";
Error::MutuallyExclusiveOptions = "The following two options: `1` and `2` are mutually exclusive, meaning one and only one of the two must be specified, and the other one must be Null. Please check your options and correct that accordingly.";
Error::CountedKitProduct = "Counted models are not allowed to be included as part of the KitComponent option since product has no way to track the initial count. Please either remove that model from KitComponent, or create a new non-kit product of that single model.";
Error::DeprecatedModelOption = "The following model(s) `2` in the `1` option(s) are deprecated and therefore cannot be used. Please check your options and provide alternatives.";
Error::StockSolutionProduct = "You have specified a Model[Sample, StockSolution] as the ProductModel option, which is not allowed except for external Model[Sample, StockSolution, Standard]. If you believe this product should be ordered from external supplier, please find or create an equivalent Model[Sample] or Model[Sample, StockSolution, Standard] and use that instead; if you believe this product should be prepared in lab via ECL, Please use UploadInventory function instead of UploadProduct.";
Error::PublicProductModel = "You have specified a public model `1` as the ProductModel option, which is not allowed. Only ECL personnel are allowed to create public Object[Product] using a public ProductModel. Please use an alternative ProductModel, or contact ECL to have this product created, if needed.";
Error::MissingDefaultContainerModel = "You have to specify the DefaultContainerModel for the sample product since you have already specified DefaultCoverModel. Please either set DefaultCoverModel to Null, or specify the DefaultContainerModel as well.";
Error::MissingCryoContainerCoverModel = "Options `1` must be specified for products of `2`, which require(s) cryogenic receiving and storage. If unsure, please verify with the manufacturer.";
Error::CryoSampleCoverBardode = "Options `1` is expected to have Barcode set to False or Null for the product of the cryogenic sample(s) `2`. Please correct the fields or double check the DefaultStorageCondition of the sample model.";
Error::CryoSampleKitNotSupported = "Option `1` is not expected to contain any cryogenic sample(s); however, the kit contains the sample model(s) `2` that require(s) cryogenic receiving and storage. Please check the DefaultStorageCondition of the sample model(s), or contact ECL to have this kit product created.";

DefineOptions[
	validProductQTests,
	Options :> {additionalValidQTestOptions}
];

validProductQTests[packet : PacketP[Object[Product]], ops:OptionsPattern[]] := Module[
	{
		supplier,identifier,resolvedKitComponents,kitProductModels,kitQ,validContainerIndex,validVesselIndex,nameAlreadyExistsQ,prodExistsQ,
		existingInventoryObjs,prodModelPacket,kitModelCounts,defaultContainerModelPacket,allTypes,disallowedPublicSamples,openContainer,
		experimentSites,asepticReceivingIndicatedString,standardReceivingIndicatedString,asepticReceivingCorrectionString,
		standardReceivingCorrectionString,incompatibleAsepticShippingAndReceivingString,
		asepticRebaggingContainerTypeRequiredString, safeOps, fieldSource, cache, object, fastAssoc,
		allowedExperimentSitesList
	},

	(* read options *)
	safeOps = SafeOptions[validProductQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];

	fastAssoc = updateFastAssoc[{{Products, Packet[Deprecated,CountPerSample]}}, packet, cache];

	(* Stash the object reference of the supplier but with the Name and not the ID *)
	supplier = Download[Lookup[packet, Supplier], Object];

	identifier = FirstCase[Lookup[packet, {Name, Object, ProductModel}], Except[_Missing | Null], packet];

	(* pull out KitComponents because that changes a lot of what we do below *)
	resolvedKitComponents = Lookup[packet, KitComponents];
	kitProductModels = Lookup[resolvedKitComponents, ProductModel, Null];
	kitQ = MatchQ[resolvedKitComponents, {(_Association)..}];

	(* figure out if we're making a new product or not, and if something with this name already exists *)
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
		kitModelCounts,
		defaultContainerModelPacket,
		experimentSites
	} = Quiet[Download[
		packet,
		{
			Packet[ProductModel[{Tablet,Sachet,State,Notebook,OpenContainer,Counted}]],
			KitComponents[[All,ProductModel]][Counted],
			Packet[DefaultContainerModel[{Deprecated,OpenContainer,Positions}]],
			Notebook[Financers][ExperimentSites][Object]
		},
		Cache -> cache
	], {Download::FieldDoesntExist, Download::MissingField}];

	allowedExperimentSitesList = Download[Flatten[{experimentSites}], Object];

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

			(* Make a list of all container index and container model pairs *)
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

	(* Define a helper function to help generate better error messages *)
	fancyRiffle[stringList:{_String..},separatorWord_String]:=Switch[Length[stringList],
		LessP[2],
			First[stringList],
		EqualP[2],
			StringRiffle[stringList," " <> separatorWord <> " "],
		_,
			Module[{riffledString},
				riffledString = StringRiffle[stringList,", " <> separatorWord <> " "];
				StringReplace[riffledString,", " <> separatorWord <> " " -> ", ",Length[stringList] - 2]
			]
	];

	(* Set error string variables for aseptic rebagging tests *)
	(* Error::UnsupportedAsepticReceiving *)
	{
		asepticReceivingIndicatedString,
		standardReceivingIndicatedString,
		asepticReceivingCorrectionString,
		standardReceivingCorrectionString
	} = Module[
		{
			asepticReceivingIndicatedStrings,standardReceivingIndicatedStrings
		},

		asepticReceivingIndicatedStrings = {
			If[TrueQ[Lookup[packet,Sterile]] && MatchQ[Lookup[packet,SealedContainer],False | Null],
				{
					(* What is set *)
					"Sterile is specified as True",
					(* Correction for standard receiving *)
					"Sterile to False"
				},
				Nothing
			],
			If[!NullQ[Lookup[packet,AsepticShippingContainerType]],
				{
					(* What is set *)
					"AsepticShippingContainerType is specified as " <> ToString[Lookup[packet,AsepticShippingContainerType]],
					(* Correction for standard receiving *)
					"AsepticShippingContainerType to Null"
				},
				Nothing
			],
			If[!NullQ[Lookup[packet,AsepticRebaggingContainerType]],
				{
					(* What is set *)
					"AsepticRebaggingContainerType is specified as " <> ToString[Lookup[packet,AsepticRebaggingContainerType]],
					(* Correction for standard receiving *)
					"AsepticRebaggingContainerType to Null"
				},
				Nothing
			]
		};

		standardReceivingIndicatedStrings = {
			If[TrueQ[Lookup[packet,SealedContainer]],
				{
					(* What is set *)
					"SealedContainer is specified as True",
					(* Correction for aseptic receiving *)
					"SealedContainer to False"
				},
				Nothing
			],
			If[MatchQ[Lookup[packet,Sterile],False],
				{
					(* What is set *)
					"Sterile is specified as False",
					(* Correction for aseptic receiving *)
					"Sterile to True"
				},
				Nothing
			],
			If[NullQ[Lookup[packet,AsepticShippingContainerType]],
				{
					(* What is set *)
					"AsepticShippingContainerType is specified as Null",
					(* Correction for aseptic receiving *)
					"AsepticShippingContainerType to a non null value"
				},
				Nothing
			]
		};

		If[
			And[
				Length[asepticReceivingIndicatedStrings] > 0,
				Length[standardReceivingIndicatedStrings] > 0
			],
			{
				fancyRiffle[asepticReceivingIndicatedStrings[[All,1]], "and"],
				fancyRiffle[standardReceivingIndicatedStrings[[All,1]], "and"],
				fancyRiffle[standardReceivingIndicatedStrings[[All,2]], "and"],
				fancyRiffle[asepticReceivingIndicatedStrings[[All,2]], "and"]
			},
			{"","","",""}
		]
	];

	(* Error::IncompatibleAsepticShippingAndReceiving *)
	incompatibleAsepticShippingAndReceivingString = If[
		And[
			MatchQ[Lookup[packet,AsepticShippingContainerType],Individual|ResealableBulk],
			MatchQ[Lookup[packet,AsepticRebaggingContainerType],Except[Null]]
		],
		"AsepticShippingContainerType is specified as " <> ToString[Lookup[packet,AsepticShippingContainerType]] <> " and AsepticRebaggingContainerType is specified as " <> ToString[Lookup[packet,AsepticRebaggingContainerType]] <> ". Rebagging is only supported for non resealable bulk shipping containers.",
		""
	];

	(* Error::AsepticRebaggingContainerTypeRequired *)
	asepticRebaggingContainerTypeRequiredString = Switch[
		{
			Lookup[packet,AsepticShippingContainerType],
			Lookup[packet,AsepticRebaggingContainerType]
		},
		{NonResealableBulk,Null},
			"AsepticShippingContainerType is specified as NonResealableBulk; however, AsepticRebaggingContainerType is Null. AsepticRebaggingContainerType must be specified if AsepticShippingContainerType is NonResealableBulk.",
		(* Error::AsepticRebaggingContainerTypeRequired *)
		{None,Null},
			"AsepticShippingContainerType is specified as None, indicating uncertainty in the shipping container type; however, AsepticRebaggingContainerType is Null. AsepticRebaggingContainerType must be specified if AsepticShippingContainerType is None in case rebagging is required when the shipping container type is determined upon package arrival.",
		{_,_},
			""
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
			Message -> Automatic,
			FieldSource -> fieldSource,
			ParentFunction -> "UploadProduct"
		],

		RequiredTogetherTest[
			packet,
			{Manufacturer, ManufacturerCatalogNumber},
			Message -> Automatic
		],

		(* -- Site tests -- *)

		(* verify that the site is valid for the customer. For any active product, site must be in ExperimentSites. *)
		Test["Private products have a Site field that is Null or a member of the ExperimentSites ("<>ToString[allowedExperimentSitesList, FormatType -> InputForm]<>"):",
			Or[
				MatchQ[Lookup[packet, Site, Null], Null],
				MatchQ[Lookup[packet, Notebook, Null], Null], (*skip public products*)
				MemberQ[allowedExperimentSitesList, Download[Lookup[packet, Site], Object]]
			],
			True,
			Message -> Switch[Lookup[fieldSource, Site],
				User, {Hold[Error::InvalidProductSite], Site, Lookup[packet, Site, Null], allowedExperimentSitesList},
				Template, {Hold[Error::InvalidProductSiteFromExternalSource], Site, Lookup[packet, Site, Null], allowedExperimentSitesList, "Template option"},
				Field, {Hold[Error::InvalidProductSiteFromExternalSource], Site, Lookup[packet, Site, Null], allowedExperimentSitesList, "database"},
				(* This option can't come from resolver or parser, so no need to handle those cases separately *)
				_, {Hold[Error::InvalidProductSite], Site, Lookup[packet, Site, Null], allowedExperimentSitesList}
			]
		],

		Test["Public products have a Site field that is Null or a member of Emerald facilities:",
			Or[
				MatchQ[Lookup[packet, Site, Null], Null],
				MatchQ[Lookup[packet, Notebook, Null], ObjectP[]], (*skip private products*)
				MemberQ[ECLSites, Download[Lookup[packet, Site], Object]]
			],
			True,
			Message -> Switch[Lookup[fieldSource, Site],
				User, {Hold[Error::InvalidProductSite], Site, Lookup[packet, Site, Null], ECLSites},
				Template, {Hold[Error::InvalidProductSiteFromExternalSource], Site, Lookup[packet, Site, Null], ECLSites, "Template option"},
				Field, {Hold[Error::InvalidProductSiteFromExternalSource], Site, Lookup[packet, Site, Null], ECLSites, "database"},
				(* This option can't come from resolver or parser, so no need to handle those cases separately *)
				_, {Hold[Error::InvalidProductSite], Site, Lookup[packet, Site, Null], ECLSites}
			]
		],

		Test["If KitComponents is not populated, then StickerKitInParallel must not be populated:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				NullQ[Lookup[packet, StickerKitInParallel, Null]],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, {StickerKitInParallel, KitComponents}],
				{(User | Resolved), _}, {Hold[Error::StickerKitInParallelNotAllowed], StickerKitInParallel, KitComponents},
				{Template, (User | Resolved)}, {Hold[Error::StickerKitInParallelNotAllowedFromExternalSource], StickerKitInParallel, KitComponents, Lookup[packet, StickerKitInParallel], "Template option"},
				{Field, (User | Resolved)}, {Hold[Error::StickerKitInParallelNotAllowedFromExternalSource], StickerKitInParallel, KitComponents, Lookup[packet, StickerKitInParallel], "database"},
				{Template, Template}, {Hold[Error::StickerKitInParallelNotAllowedBetweenExternalSource], StickerKitInParallel, KitComponents, Lookup[packet, StickerKitInParallel], "Template option"},
				{Field, Field}, {Hold[Error::StickerKitInParallelNotAllowedBetweenExternalSource], StickerKitInParallel, KitComponents, Lookup[packet, StickerKitInParallel], "database"},
				{_, _}, {Hold[Error::StickerKitInParallelNotAllowed], StickerKitInParallel, KitComponents}
			]
		],

		UniquelyInformedTest[packet,
			{ProductModel, KitComponents},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		Test["If KitComponents is populated, SampleType must be Kit:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, SampleType], Kit]
			],
			True,
			Message -> Switch[Lookup[fieldSource, {KitComponents, SampleType}],
				{User, User}, {Hold[Error::InvalidSampleType], KitComponents, SampleType},
				{User, Template}, {Hold[Error::InvalidSampleTypeFromExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Template option"},
				{User, External}, {Hold[Error::InvalidSampleTypeFromExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Supplier webpage"},
				{User, Field}, {Hold[Error::InvalidSampleTypeFromExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "database"},
				{Template, User}, {Hold[Error::InvalidSampleTypeWithExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Template option"},
				{External, User}, {Hold[Error::InvalidSampleTypeWithExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Supplier webpage"},
				{Field, User}, {Hold[Error::InvalidSampleTypeWithExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "database"},
				{Template, Template}, {Hold[Error::InvalidSampleTypeBetweenExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Template option"},
				{External, External}, {Hold[Error::InvalidSampleTypeBetweenExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "Supplier webpage"},
				{Field, Field}, {Hold[Error::InvalidSampleTypeBetweenExternalSource], KitComponents, SampleType, Lookup[packet, SampleType], "database"},
				{_, _}, {Hold[Error::InvalidSampleType], KitComponents, SampleType}
			]
		],

		Test["If KitComponents is populated, DefaultContainerModel must be Null:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, DefaultContainerModel], Null]
			],
			True,
			Message -> Switch[Lookup[fieldSource, {KitComponents, DefaultContainerModel}],
				{User, User}, {Hold[Error::InvalidKitOptions], KitComponents, DefaultContainerModel},
				{User, Template}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "Template option"},
				{User, Field}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "database"},
				{Template, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "Template option"},
				{Field, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "database"},
				{Template, Template}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "Template option"},
				{Field, Field}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, DefaultContainerModel, Lookup[packet, DefaultContainerModel], "database"},
				{_, _}, {Hold[Error::InvalidKitOptions], KitComponents, DefaultContainerModel}
			]
		],

		Test["If KitComponents is populated, Amount must be Null:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, Amount], Null]
			],
			True,
			Message -> Switch[Lookup[fieldSource, {KitComponents, Amount}],
				{User, User}, {Hold[Error::InvalidKitOptions], KitComponents, Amount},
				{User, Template}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, Amount, Lookup[packet, Amount], "Template option"},
				{User, Field}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, Amount, Lookup[packet, Amount], "database"},
				{Template, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, Amount, Lookup[packet, Amount], "Template option"},
				{Field, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, Amount, Lookup[packet, Amount], "database"},
				{Template, Template}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, Amount, Lookup[packet, Amount], "Template option"},
				{Field, Field}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, Amount, Lookup[packet, Amount], "database"},
				{_, _}, {Hold[Error::InvalidKitOptions], KitComponents, Amount}
			]
		],

		Test["If KitComponents is populated, CountPerSample must be Null:",
			If[MatchQ[Lookup[packet, KitComponents, {}], {}],
				True,
				MatchQ[Lookup[packet, CountPerSample], Null]
			],
			True,
			Message -> Switch[Lookup[fieldSource, {KitComponents, CountPerSample}],
				{User, User}, {Hold[Error::InvalidKitOptions], KitComponents, CountPerSample},
				{User, Template}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "Template option"},
				{User, Field}, {Hold[Error::InvalidKitOptionsFromExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "database"},
				{Template, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "Template option"},
				{Field, User}, {Hold[Error::InvalidKitOptionsWithExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "database"},
				{Template, Template}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "Template option"},
				{Field, Field}, {Hold[Error::InvalidKitOptionsBetweenExternalSource], KitComponents, CountPerSample, Lookup[packet, CountPerSample], "database"},
				{_, _}, {Hold[Error::InvalidKitOptions], KitComponents, CountPerSample}
			]
		],

		Test["If KitComponents is populated, it must have more than one entry (otherwise it is not a kit):",
			MatchQ[Length[Lookup[packet, KitComponents, {}]], 0 | GreaterEqualP[2, 1]],
			True,
			Message -> Switch[Lookup[fieldSource, KitComponents],
				User, {Hold[Error::SingleKitComponent], KitComponents},
				Template, {Hold[Error::SingleKitComponentFromExternalSource], KitComponents, Lookup[packet, KitComponents], "Template option"},
				Field, {Hold[Error::SingleKitComponentFromExternalSource], KitComponents, Lookup[packet, KitComponents], "database"},
				_, {Hold[Error::SingleKitComponent], KitComponents}
			]
		],

		Test["The contents of the Name field is a member of the Synonyms field:",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> {Hold[Error::NameIsPartOfSynonyms], identifier}
		],

		Test["CountPerSample is provided if the product model is counted:",
			(* Samples have Tablet field which is similar to Counted, but has its own checks. Kits also get their own test *)
			Or[
				kitQ,
				MatchQ[prodModelPacket, ObjectP[Model[Sample]]],
				MatchQ[
					{If[NullQ[prodModelPacket], Null, Lookup[prodModelPacket, Counted]], Lookup[packet, CountPerSample, Null]},
					{Null|False|$Failed, _} | {True, _Integer}
				]
			],
			True,
			Message -> Switch[Lookup[fieldSource, CountPerSample],
				User, {Hold[Error::CountedProduct], CountPerSample},
				Template, {Hold[Error::CountedProductFromExternalSource], CountPerSample, "Template option"},
				External, {Hold[Error::CountedProductFromExternalSource], CountPerSample, "supplier webpage"},
				Field, {Hold[Error::CountedProductFromExternalSource], CountPerSample, "database"},
				_, {Hold[Error::CountedProduct], CountPerSample}
			]
		],

		Test["CountPerSample is provided only if the product model is counted:",
			(* Samples have Tablet field which is similar to Counted, but has its own checks. Kits also get their own test *)
			Or[
				kitQ,
				MatchQ[prodModelPacket, ObjectP[Model[Sample]]],
				MatchQ[
					{If[NullQ[prodModelPacket], Null, Lookup[prodModelPacket, Counted]], Lookup[packet, CountPerSample, Null]},
					{Null|False|$Failed, Null} | {True, _}
				]
			],
			True,
			Message -> Switch[Lookup[fieldSource, CountPerSample],
				User, {Hold[Error::NotCountedProduct], CountPerSample},
				Template, {Hold[Error::NotCountedProductFromExternalSource], CountPerSample, "Template option", Lookup[packet, CountPerSample]},
				External, {Hold[Error::NotCountedProductFromExternalSource], CountPerSample, "supplier webpage", Lookup[packet, CountPerSample]},
				Field, {Hold[Error::NotCountedProductFromExternalSource], CountPerSample, "database", Lookup[packet, CountPerSample]},
				_, {Hold[Error::NotCountedProduct], CountPerSample}
			]
		],

		Test["Kits can't have any counted models as the product has no way to track the initial count:",
			If[kitQ,
				!MemberQ[kitModelCounts,True],
				True
			],
			True,
			Message -> {Hold[Error::CountedKitProduct], identifier}
		],

		Test["Amount and CountPerSample cannot both be informed at the same time except for when it's a Sample Chemical and the sample contains Tablets or Sachets:",
			{
				If[MatchQ[prodModelPacket, ObjectP[Model[Sample]]],
					MemberQ[Lookup[prodModelPacket, {Tablet, Sachet}, Null], True],
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
			Message -> {Hold[Error::TabletSachetFields], Amount, CountPerSample}
		],

		Test["If the product is for a sample that is not self-contained, Amount is informed (unless the sample contains Tablets or Sachets):",
			If[!kitQ && MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample]]],
				MatchQ[
					{Lookup[prodModelPacket, Object], If[MatchQ[prodModelPacket, ObjectP[Model[Sample]]], MemberQ[Lookup[prodModelPacket, {Tablet, Sachet}, Null], True], Null], Lookup[packet, Amount, Null]},
					Alternatives[
						{SelfContainedSampleModelP, NullP, NullP},
						(* Make a hard-coded exception for packing peanuts, which are a consumable but need Amount for pricing *)
						{NonSelfContainedSampleModelP | ObjectP[Model[Item, Consumable, "id:R8e1PjpkODwJ"]], NullP | False, Except[NullP]},
						{NonSelfContainedSampleModelP | ObjectP[Model[Item, Consumable, "id:R8e1PjpkODwJ"]], True, _}
					]

				],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, Amount],
				(User | Resolved), {Hold[Error::ProductAmount], Amount},
				External, {Hold[Error::ProductAmountFromExternalSource], Amount, "supplier webpage"},
				Template, {Hold[Error::ProductAmountFromExternalSource], Amount, "template object"},
				Field, {Hold[Error::ProductAmountFromExternalSource], Amount, "database"},
				_, {Hold[Error::ProductAmount], Amount}
			]
		],
		
		Test["If DefaultContainerModel is informed, it is not Deprecated:",
			If[Not[NullQ[defaultContainerModelPacket]],
				Not[TrueQ[Lookup[defaultContainerModelPacket, Deprecated]]],
				True
			],
			True
		],

		(* DefaultContainerModel should NOT be null for NonSelfContainedSampleModelP, *)
		(* or, alternatively, a Model[Container,ProteinCapillaryElectrophoresisCartridge] *)
		(* product that isnt a sample but contains an insert, so needs DefaultContainerModel populated *)
		Test["If the product is for anything but a non-self-contained sample (except cartridge inserts, which are an exception), DefaultContainerModel is Null:",
			If[MatchQ[Lookup[packet, ProductModel], Except[Alternatives[NonSelfContainedSampleModelP, ObjectP[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert]]]]],
				MatchQ[
					{Lookup[packet, ProductModel], Lookup[packet, DefaultContainerModel]},
					{Except[NonSelfContainedSampleModelP], NullP} | {NonSelfContainedSampleModelP, _} | {Null, _}
				],
				True
			],
			True,
			Message -> {Hold[Error::DefaultContainerModel], DefaultContainerModel}
		],

		(* DefaultContainerModel and DefaultCoverModel must both specified to verified models for cryogenic samples *)
		Test["If the product is for a cryogenic sample, which should not be taken to parametrization, DefaultContainerModel and DefaultCoverModel must both specified to verified models:",
			If[MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample]]],
				MatchQ[
					Quiet[Download[
						Lookup[packet,{ProductModel, DefaultContainerModel, DefaultCoverModel}],
						{{DefaultStorageCondition},{VerifiedContainerModel},{VerifiedCoverModel}}
					]],
					(* In order to download only once, the code logic is essentially, if the product model is a sample, the downloaded fields above is either {{cryo}, {True}, {True}} or {{Non-Cryo}, {anything}, {anything}}*)
					Alternatives[
						(*"Cryogenic Storage"*)
						{{ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]},{True},{True}},
						{{Except[ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]]}, _, _}
					]
				],
				True
			],
			True,
			Message -> {Hold[Error::MissingCryoContainerCoverModel], {DefaultContainerModel, DefaultCoverModel}, Lookup[packet, ProductModel]}
		],
		(* For cryogenic samples, we do not expect the cover model to have Barcode->True, or they arrive as a kit. These are more like the field settings are wrong for the product, unless we are proven wrong in future. Note that this is seperated from the above error not based on theme, but more about we expect this to hold true, while the above is expected to be reverted once cryo receiving v2 is only to accommodate potentially unverified containers *)
		Test["If the product is for a cryogenic sample, the verified cover should not be stickered:",
			If[MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample]]],
				MatchQ[Quiet[Download[
					Lookup[packet, {ProductModel, DefaultCoverModel}],
					{{DefaultStorageCondition}, {Object, Barcode}}
				]],
					(* In order to download only once, the code logic is essentially, if the product model is a sample, the downloaded fields above is either {{cryo}, {coverModel, Null|False|$Failed}} or {{Non-Cryo}, {anything}}*)
					Alternatives[
						(*"Cryogenic Storage"*)
						{{ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]}, {ObjectP[], Except[True]}},
						{{ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]}, Null},(* No cover case handled by MissingCryoContainerCoverModel*)
						{{Except[ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]]}, _}
					]
				],
				True
			],
			True,
			Message -> {Hold[Error::CryoSampleCoverBardode], DefaultCoverModel, Lookup[packet, ProductModel]}
		],
		Module[{cryoSamplesInKit},
			Test["Cryogenic samples are not expected to come as part of a kit:",
				cryoSamplesInKit = PickList[kitProductModels, Download[kitProductModels, DefaultStorageCondition], ObjectP[Model[StorageCondition, "id:6V0npvmE09vG"]]];
				If[kitQ,
					MatchQ[cryoSamplesInKit, {}],
					True
				],
				True,
				Message -> {Hold[Error::CryoSampleKitNotSupported], KitComponents, cryoSamplesInKit}
			]
		],

		(* DefaultContainerModel cannot have more than 1 position if it is a plate *)
		Test["If the DefaultContainerModel is a Model[Container,Plate], the container cannot have more than 1 position:",
			If[MatchQ[defaultContainerModelPacket, PacketP[Model[Container,Plate]]],
				MatchQ[Length[Lookup[defaultContainerModelPacket,Positions]], 1],
				True
			],
			True,
			Message -> {Hold[Error::DefaultContainerModelTooManyPositions], DefaultContainerModel}
		],

		(* Tests if product is made at Emerald *)
		Test["If Emerald is the supplier, NumberOfItems is 1:",
			{supplier, Lookup[packet, NumberOfItems]},
			Alternatives[
				(* Object[Company, Supplier, "Emerald Cloud Lab"] *)
				{Object[Company, Supplier, "id:eGakld01qrkB"], 1},
				{Except[Object[Company, Supplier, "id:eGakld01qrkB"]], _}
			],
			Message -> {Hold[Error::EmeraldSuppliedProductSamples], NumberOfItems, Lookup[packet, NumberOfItems]}
		],
		
		Test["Products cannot exist for Model[Sample, StockSolution]s (external Model[Sample, StockSolution, Standard]s are ok):",
			Or[
				MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample, StockSolution, Standard]]] && Not[MatchQ[Lookup[packet, Supplier], LinkP[Object[Company, Supplier, "Emerald Cloud Lab"]]]],
				Not[MatchQ[Lookup[packet, ProductModel], ObjectP[Model[Sample, StockSolution]]]]
			],
			True
		],

		Test["Amount must be appropriate for liquid with known density:",
			Module[{amount, density},
				amount = Lookup[packet, Amount];
				density = Lookup[packet, Density];
				If[QuantityQ[amount] && !MatchQ[density, Null],
					With[{modelState = Lookup[prodModelPacket, State]},
						Or[
							(* Liquid can have amount specified as Mass or Volume if Density is informed *)
							!MatchQ[modelState, Liquid],
							MassQ[amount] && MatchQ[modelState, Liquid],
							VolumeQ[amount] && MatchQ[modelState, Liquid]
						]
					],
					True
				]
			],
			True
		],

		Test["Amount must be appropriate for liquid without known density:",
			Module[{amount, density},
				amount = Lookup[packet, Amount];
				density = Lookup[packet, Density];
				If[QuantityQ[amount] && MatchQ[density, Null],
					With[{modelState = Lookup[prodModelPacket, State]},
						Or[
							(* Liquid can have amount specified as Volume only if Density is not informed *)
							!MatchQ[modelState, Liquid],
							VolumeQ[amount] && MatchQ[modelState, Liquid]
						]
					],
					True
				]
			],
			True
		],

		Test["Amount must be appropriate for solid:",
			Module[{amount, density},
				amount = Lookup[packet, Amount];
				density = Lookup[packet, Density];
				If[QuantityQ[amount],
					With[{modelState = Lookup[prodModelPacket, State]},
						Or[
							(* Solid can have amount specified as Mass, count or Mole *)
							!MatchQ[modelState, Solid],
							(MassQ[amount] || AmountQ[amount] || MatchQ[amount,GreaterP[0Unit,1Unit]]) && MatchQ[modelState, Solid]
						]
					],
					True
				]
			],
			True,
			Message -> Switch[Lookup[fieldSource, Amount],
				(User | Resolved), {Hold[Error::AmountUnitState], Lookup[packet,Amount],If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null], Amount},
				External, {Hold[Error::AmountUnitStateFromExternalSource], Lookup[packet,Amount],If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null], Amount, "supplier webpage"},
				Template, {Hold[Error::AmountUnitStateFromExternalSource], Lookup[packet,Amount],If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null], Amount, "template object"},
				Field, {Hold[Error::AmountUnitStateFromExternalSource], Lookup[packet,Amount],If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null], Amount, "database"},
				_, {Hold[Error::AmountUnitState], Lookup[packet,Amount],If[MatchQ[prodModelPacket,PacketP[]],Lookup[prodModelPacket,State],Null], Amount}
			]
		],

		(* If product isn't supplied by ET / ECL, it must have a list price *)
		Test["If the product is not generated internally by the ECL, Price must be populated:",
			(* Object[Company, Supplier, "Emerald Cloud Lab"] *)
			If[Not[MatchQ[supplier, ObjectP[Object[Company, Supplier, "id:eGakld01qrkB"]]]],
				Not[NullQ[Lookup[packet, Price]]],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, Price],
				(User | Resolved), {Hold[Error::PricePerUnitRequired], identifier, Price},
				External, {Hold[Error::PricePerUnitRequiredFromExternalSource], identifier, Price, "supplier webpage"},
				Template, {Hold[Error::PricePerUnitRequiredFromExternalSource], identifier, Price, "template object"},
				Field, {Hold[Error::PricePerUnitRequiredFromExternalSource], identifier, Price, "database"},
				_, {Hold[Error::PricePerUnitRequired], identifier, Price}
			]
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

		Test["If ProductModel is not public, Product must also not be public:",
			Or[
				(* if ProductModel isn't populated (i.e., we have a kit) then don't worry about this test *)
				NullQ[Lookup[packet, ProductModel]],
				(* If product is public, skip this test (we'll deal with it in the next test *)
				Or[
					NullQ[Lookup[packet, Notebook]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],TrueQ[$AllowPublicObjects]]
				],
				(* if we are not specifying Notebook in the packet and $AllowPublicObjects goes to False - raw Upload will always make sure we get a notebook assigned to the object by the time it uploads
				so don't worry about this test as well *)
				Or[
					Not[NullQ[Lookup[packet, Notebook]]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],!TrueQ[$AllowPublicObjects]]
				] && Not[NullQ[Lookup[prodModelPacket, Notebook]]]
			],
			True
		],

		Test["If ProductModel is public, Product must also be public:",
			Or[
				(* if ProductModel isn't populated (i.e., we have a kit) then don't worry about this test *)
				NullQ[Lookup[packet, ProductModel]],
				(* if we are not specifying Notebook in the packet and $AllowPublicObjects goes to True
				it is equivalent to Notebook will be Null *)
				Or[
					NullQ[Lookup[packet, Notebook]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],TrueQ[$AllowPublicObjects]]
				]&& NullQ[Lookup[prodModelPacket, Notebook]],
				(* If product is not public, skip this test, as we dealt with it in the previous test *)
				Or[
					Not[NullQ[Lookup[packet, Notebook]]],
					And[MatchQ[Lookup[packet, Notebook], _Missing],!TrueQ[$AllowPublicObjects]]
				]
			],
			True
		],

		Test["ContainerIndex is not repeated for any kit components whose DefaultContainerModel is a Model[Container,Vessel]:",
			kitQ && MemberQ[validVesselIndex, False],
			False,
			Message -> {Hold[Error::RepeatedContainerIndex], KitComponents}
		],

		Test["ContainerIndex/Position is correctly set:",
			kitQ && MemberQ[validContainerIndex, False],
			False,
			Message -> {Hold[Error::InvalidContainerIndexPosition], KitComponents}
		],

		(* if the product already exists then who cares, or if the name doesn't already exist we're also good *)
		Test["The Name must be unique among all Object[Product]s:",
			prodExistsQ || Not[nameAlreadyExistsQ],
			True,
			Message -> {Hold[Error::NonUniqueName], Object[Product],identifier}
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
		],

		(* -- Aseptic Receiving Tests -- *)
		Test["Ambiguous Aseptic Receiving specified. Please adjust the Sterile, SealedContainer, AsepticShippingContainerType, or AsepticRebaggingContainerType fields.",
			MatchQ[asepticReceivingIndicatedString,""],
			True,
			Message->{Hold[Error::UnsupportedAsepticReceiving],
				asepticReceivingIndicatedString,
				standardReceivingIndicatedString,
				asepticReceivingCorrectionString,
				standardReceivingCorrectionString
			}
		],

		Test["Rebagging is only supported for non resealable bulk containers",
			MatchQ[incompatibleAsepticShippingAndReceivingString,""],
			True,
			Message -> {Hold[Error::IncompatibleAsepticShippingAndReceiving], incompatibleAsepticShippingAndReceivingString}
		],

		Test["Rebagging is required for unknown and nonresealable bulk aseptic shipping containers:",
			MatchQ[asepticRebaggingContainerTypeRequiredString,""],
			True,
			Message -> {Hold[Error::AsepticRebaggingContainerTypeRequired], asepticRebaggingContainerTypeRequiredString}
		]
	}
];

errorToOptionMap[Object[Product]] := {
	"Error::NonUniqueName" -> Name,
	"Error::UnsupportedAsepticReceiving" -> {Sterile, SealedContainer, AsepticShippingContainerType},
	"Error::IncompatibleAsepticShippingAndReceiving" -> {AsepticShippingContainerType,AsepticRebaggingContainerType},
	"Error::AsepticRebaggingContainerTypeRequired" -> {AsepticShippingContainerType,AsepticRebaggingContainerType}
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
