(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*UploadCompanySupplier*)


(* ::Subsubsection::Closed:: *)
(*UploadCompanySupplier*)


DefineTests[
	UploadCompanySupplier,
	{
		Example[{Basic, "Upload a new Object[Company,Supplier]:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company",
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company", Phone -> Null, Website -> Null, OutOfBusiness -> False|>
		],
		Example[{Options, Upload, "Return an upload packet a new Object[Company,Supplier]:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 3",
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 3", Phone -> Null, Website -> Null, OutOfBusiness -> False|>
		],
		Example[{Options, Output, "Return a list of tests to check the validity of this upload call:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 4",
				Output -> Tests,
				Upload -> False
			],
			{_EmeraldTest..}
		],
		Example[{Options, Phone, "Specify a phone number for this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 5", Phone -> "123-456-7890", Website -> Null, OutOfBusiness -> False|>
		],
		Example[{Options, Website, "Specify a website for this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 6",
				Website -> "TheMostReliableSupplier.com",
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 6", Phone -> Null, Website -> "TheMostReliableSupplier.com", OutOfBusiness -> False|>
		],
		Example[{Options, OutOfBusiness, "Specify whether this supplier is currently out of business:"},
			UploadCompanySupplier[
				"My Previously Awesome Supplier Company 7",
				OutOfBusiness -> True,
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Previously Awesome Supplier Company 7", Phone -> Null, Website -> Null, OutOfBusiness -> True|>
		],
		Example[{Options, Orders, "Specify orders that have been placed from this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 8",
				Orders -> {Object[Transaction, Order, "id:mnk9jO3dXdpZ"], Object[Transaction, Order, "id:BYDOjv1595P9"], Object[Transaction, Order, "id:M8n3rxYAdAzG"], Object[Transaction, Order, "id:WNa4ZjRDWDqq"]},
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 8", Phone -> Null, Website -> Null, OutOfBusiness -> False, Append[Orders] -> {ECL`Link[ECL`Object[ECL`Transaction, Order, "id:mnk9jO3dXdpZ"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Transaction, Order, "id:BYDOjv1595P9"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Transaction, Order, "id:M8n3rxYAdAzG"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Transaction, Order, "id:WNa4ZjRDWDqq"], ECL`Supplier]}|>
		],
		Example[{Options, Receipts, "Specify receipts that already exist from this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 9",
				Receipts -> {Object[Report, Receipt, "id:eGakld09OMwo"], Object[Report, Receipt, "id:pZx9jon43M65"], Object[Report, Receipt, "id:4pO6dMWKoGzw"], Object[Report, Receipt, "id:Vrbp1jG3dlRo"]},
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 9", Phone -> Null, Website -> Null, OutOfBusiness -> False, Append[Receipts] -> {ECL`Link[ECL`Object[ECL`Report, ECL`Receipt, "id:eGakld09OMwo"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Report, ECL`Receipt, "id:pZx9jon43M65"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Report, ECL`Receipt, "id:4pO6dMWKoGzw"], ECL`Supplier], ECL`Link[ECL`Object[ECL`Report, ECL`Receipt, "id:Vrbp1jG3dlRo"], ECL`Supplier]}|>
		],
		Example[{Options, Products, "Specify products that already exist from this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 10",
				Products -> Object[Product, "id:aXRlGnZPZxev"],
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 10", Phone -> Null, Website -> Null, OutOfBusiness -> False, Append[Products] -> {ECL`Link[ECL`Object[Product, "id:aXRlGnZPZxev"], ECL`Supplier]}|>
		],
		Example[{Options, InstrumentsManufactured, "Specify manufactured instruments that already exist from this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 11",
				InstrumentsManufactured -> {Model[Instrument, Microwave, "id:M8n3rxYE5LdG"], Model[Instrument, PeptideSynthesizer, "id:WNa4ZjRr58Wq"]},
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 11", Phone -> Null, Website -> Null, OutOfBusiness -> False, Append[InstrumentsManufactured] -> {ECL`Link[ECL`Model[ECL`Instrument, ECL`Microwave, "id:M8n3rxYE5LdG"], ECL`Manufacturer], ECL`Link[ECL`Model[ECL`Instrument, ECL`PeptideSynthesizer, "id:WNa4ZjRr58Wq"], ECL`Manufacturer]}|>
		],
		Example[{Options, SensorsManufactured, "Specify manufactured sensors that already exist from this supplier:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 12",
				SensorsManufactured -> {Model[Sensor, Temperature, "id:kEJ9mqaVPAJB"], Model[Sensor, Weight, "id:4pO6dMWKa4A8"]},
				Upload -> False
			],
			<|Type -> Object[Company, Supplier], Name -> "My Awesome Supplier Company 12", Phone -> Null, Website -> Null, OutOfBusiness -> False, Append[SensorsManufactured] -> {ECL`Link[ECL`Model[ECL`Sensor, ECL`Temperature, "id:kEJ9mqaVPAJB"], ECL`Manufacturer], ECL`Link[ECL`Model[ECL`Sensor, ECL`Weight, "id:4pO6dMWKa4A8"], ECL`Manufacturer]}|>
		],
		Example[{Messages, "ObjectDoesNotExist", "If an object is passed as an option but it does not exist, a message is thrown:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company of Tacos",
				SensorsManufactured -> {Model[Sensor, Temperature, "Taco Sensor"]},
				Upload -> False
			],
			Null,
			Messages :> {UploadCompanySupplier::ObjectDoesNotExist, Error::InvalidOption}
		],
		Example[{Messages, "SupplierNameAlreadyExists", "A supplier cannot be uploaded if another supplier of that name already exists:"},
			UploadCompanySupplier[
				"Thermo Fisher Scientific",
				Upload -> False
			],
			Null,
			Messages :> {UploadCompanySupplier::SupplierNameAlreadyExists, Error::InvalidInput}
		],
		Example[{Messages, "UnderspecifiedInformation", "A supplier cannot be created if {Phone, Website, OutOfBusiness} are all Null:"},
			UploadCompanySupplier[
				"My Awesome Supplier Company 13",
				Phone -> Null,
				Website -> Null,
				OutOfBusiness -> Null,
				Upload -> False
			],
			Null,
			Messages :> {UploadCompanySupplier::UnderspecifiedInformation, Error::InvalidOption}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadCompanySupplierOptions*)


DefineTests[
	UploadCompanySupplierOptions,
	{
		Example[{Basic, "Inspect the resolved options from UploadCompanySupplier[] when uploading a new Object[Company,Supplier]:"},
			UploadCompanySupplierOptions[
				"My Awesome Supplier Company",
				OutputFormat -> List
			],
			{
				OrderlessPatternSequence[Phone -> Null, Website -> Null, OutOfBusiness -> False, Status -> Null,
					AccountTransfer -> Null, NewDispute -> Null, ModifiedDisputes -> Null, ActiveSupplierQualityAgreement -> Null,
					SupplierQualityAgreements -> Null, ContactStatus -> Null, ContactRole -> Null, ContactServicedSite -> Null,
					ContactEmail -> Null, ContactPhone -> Null, ContactFirstName -> Null, ContactLastName -> Null, Orders -> Null,
					Receipts -> Null, Products -> Null, InstrumentsManufactured -> Null, SensorsManufactured -> Null]
			}
		],
		Example[{Basic, "Inspect the resolved options from UploadCompanySupplier[] when uploading a new Object[Company,Supplier] and also specifying a phone number:"},
			UploadCompanySupplierOptions[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				OutputFormat -> List
			],
			{
				OrderlessPatternSequence[Phone -> "123-456-7890", Website -> Null, OutOfBusiness -> False, Status -> Null,
					AccountTransfer -> Null, NewDispute -> Null, ModifiedDisputes -> Null, ActiveSupplierQualityAgreement -> Null,
					SupplierQualityAgreements -> Null, ContactStatus -> Null, ContactRole -> Null, ContactServicedSite -> Null,
					ContactEmail -> Null, ContactPhone -> Null, ContactFirstName -> Null, ContactLastName -> Null, Orders -> Null,
					Receipts -> Null, Products -> Null, InstrumentsManufactured -> Null, SensorsManufactured -> Null]
			}
		],
		Example[{Basic, "Inspect the resolved options from UploadCompanySupplier[] when uploading a new Object[Company,Supplier] and also specifying a phone number:"},
			UploadCompanySupplierOptions[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				OutOfBusiness -> False,
				OutputFormat -> List
			],
			{
				OrderlessPatternSequence[Phone -> "123-456-7890", Website -> Null, OutOfBusiness -> False, Status -> Null,
					AccountTransfer -> Null, NewDispute -> Null, ModifiedDisputes -> Null, ActiveSupplierQualityAgreement -> Null,
					SupplierQualityAgreements -> Null, ContactStatus -> Null, ContactRole -> Null, ContactServicedSite -> Null,
					ContactEmail -> Null, ContactPhone -> Null, ContactFirstName -> Null, ContactLastName -> Null, Orders -> Null,
					Receipts -> Null, Products -> Null, InstrumentsManufactured -> Null, SensorsManufactured -> Null]
			}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			UploadCompanySupplierOptions[
				"My Awesome Supplier Company",
				OutputFormat -> List
			],
			{
				OrderlessPatternSequence[Phone -> Null, Website -> Null, OutOfBusiness -> False, Status -> Null,
					AccountTransfer -> Null, NewDispute -> Null, ModifiedDisputes -> Null, ActiveSupplierQualityAgreement -> Null,
					SupplierQualityAgreements -> Null, ContactStatus -> Null, ContactRole -> Null, ContactServicedSite -> Null,
					ContactEmail -> Null, ContactPhone -> Null, ContactFirstName -> Null, ContactLastName -> Null, Orders -> Null,
					Receipts -> Null, Products -> Null, InstrumentsManufactured -> Null, SensorsManufactured -> Null]
			}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table:"},
			UploadCompanySupplierOptions[
				"My Awesome Supplier Company",
				OutputFormat -> List
			],
			Graphics_
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadCompanySupplierQ*)


DefineTests[
	ValidUploadCompanySupplierQ,
	{
		Example[{Basic, "Determine if a valid Object[Company,Supplier] will be uploaded from UploadCompanySupplier[]:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company"
			],
			True
		],
		Example[{Basic, "Inspect the detailed tests that UploadCompanySupplier[] is running:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				Verbose -> True
			],
			True
		],
		Example[{Basic, "Inspect the detailed tests that UploadCompanySupplier[] is running. In this case, one of the tests doesn't pass because the value of the Phone option doesn't match its pattern:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "1-800-ORDER-TACOS-NOW",
				Verbose -> True
			],
			False
		],
		Example[{Options, "Verbose", "Inspect the detailed tests that UploadCompanySupplier[] is running. Use the Verbose option to show the tests that the Valid<Function>Q function is running. When Verbose->True, all of the tests will be printed:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				Verbose -> True
			],
			True
		],
		Example[{Options, "Verbose", "Inspect the detailed tests that UploadCompanySupplier[] is running. Use the Verbose option to show the tests that the Valid<Function>Q function is running. When Verbose->False, none of the tests will be printed (this is the default behavior):"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				Verbose -> False
			],
			True
		],
		Example[{Options, "Verbose", "Inspect the detailed tests that UploadCompanySupplier[] is running. Use the Verbose option to show the tests that the Valid<Function>Q function is running. When Verbose->Failures, only the failing tests will be printed:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				Verbose -> Failures
			],
			True
		],
		Example[{Options, "OutputFormat", "Inspect the detailed tests that UploadCompanySupplier[] is running. Use the OutputFormat->TestSummary to return a TestSummary of the tests that have been run. Use the Keys[...] function to see the dereferenceable keys inside of the test summary:"},
			ValidUploadCompanySupplierQ[
				"My Awesome Supplier Company 5",
				Phone -> "123-456-7890",
				OutputFormat -> TestSummary
			][Successes],
			{_EmeraldTestResult..}
		]
	}
];


(* ::Subsection::Closed:: *)
(*UploadProduct*)


(* ::Subsubsection::Closed:: *)
(*UploadProduct*)


DefineTests[
	UploadProduct,
	{
		Example[{Basic, "Upload a new Object[Product] of Methanol, anhydrous, 99.8% purity using its Sigma-Aldrich product URL:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US",
						Name->"Methanol, anhydrous, 99.8% | CH3OH (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"<>$SessionUUID],
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial,
						CatalogDescription->"High purity methanol"
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs :> {
				(* stub the response of the api call to sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" ->
							"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US", "Method" -> "GET",
						"Headers" -> <|
							"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
						|>
					|>
				] = ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/7d3a0e3c125ce4884b948b96cc7aead7.txt", ""]],
				(* stub the response of the reverse-engineered api call to get price info from sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" -> "https://www.sigmaaldrich.com/api?operation=PricingAndAvailability",
						"Method" -> "POST",
						"Headers" -> <|
							"accept" -> "*/*",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
							"x-gql-operation-name" -> "PricingAndAvailability",
							"x-gql-access-token" -> "ea816e21-7d19-11ef-90f5-8321289a8c21",
							"x-gql-country" -> "US"
						|>,
						"Body" -> <|
							"operationName" -> "PricingAndAvailability",
							"query" -> "query PricingAndAvailability($productNumber:String!,$brand:String,$quantity:Int!,$materialIds:[String!]) {
							getPricingForProduct(input:{productNumber:$productNumber,brand:$brand,quantity:$quantity,materialIds:$materialIds}) {
								materialPricing {
									packageSize
									price
								}
							}
						}",
							"variables" -> <|
								"brand" -> "SIAL",
								"materialIds" -> {"322415-VAR", "322415-PZ", "322415-900ML", "322415-8L", "322415-6L", "322415-1L", "322415-200L", "322415-200L-P2", "322415-200L-P2-SA", "322415-20L", "322415-20L-P2", "322415-250ML", "322415-2L", "322415-4X2L", "322415-6X1L", "322415-18L-P1", "322415-18L", "322415-12X100ML", "QR-028-1L", "322415-100ML", "322415-1250L-P1"},
								"productNumber" -> "322415",
								"quantity" -> 1
							|>
						|>
					|>
				] = ToExpression[ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/3ef849f6ab315a079d12676414b00bd3.txt", ""]]],
				$UsePyeclProductParser = False
			}
		],
		Example[{Basic, "Upload a new Object[Product] of DMSO (LC-MS Grade) using its ThermoFisher product URL:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"High purity DMSO",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Basic, "Upload a new Object[Product] of Diethylene glycol methyl ether manually (without scraping from a product URL) :"},
			UploadProduct[
				Name -> "Diethylene glycol methyl ether 99% (test)" <> $SessionUUID,
				Packaging -> Single,
				ProductModel -> Model[Sample, "Diethylene glycol methyl ether 99%"],
				NumberOfItems -> 1,
				SampleType -> Vial,
				DefaultContainerModel -> Model[Container, Vessel, "50mL tall sloping shoulder amber glass bottle"],
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogDescription -> "High purity diethylene glycol methyl ether",
				CatalogNumber -> "1",
				Amount -> 50 Milliliter,
				Price -> 1 USD
			],
			ObjectP[Object[Product]],
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Name", "Use the Name option to specify the name of the uploaded Object[Product]:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/268270040",
						Name->"Acetonitrile for HPLC-GC, >=99.8% (GC) (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						CatalogDescription->"Acetonitrile recommended for HPLC use",
						Amount -> 2.5 Liter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Synonyms", "Use the Synonyms option to specify the synonyms of the uploaded Object[Product]:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.fishersci.com/shop/products/methyl-ethyl-ketone-certified-acs-fisher-chemical-6/M2091",
						Synonyms->{"Ethyl methyl ketone (test)"<>$SessionUUID,"MEK","Methyl ethyl ketone"},
						Name->"Ethyl methyl ketone (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"Ethyl methyl ketone",
						Price -> 1 USD,
						Amount -> 50 Milliliter,
						Packaging -> Single,
						Supplier -> Object[Company, Supplier, "Fisher Scientific"],
						CatalogNumber -> "M2091"
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "ProductModel", "Use the ProductModel option to specify the model of the uploaded Object[Product]. This field can be a Model[Sample], Model[Container], Model[Sensor], Model[Part], Model[Plumbing], or Model[Wiring]:"},
			Quiet[
				Check[
					Block[{$Notebook=Object[LaboratoryNotebook,"id:4pO6dM5wEaLB"]},
						UploadProduct[
							"https://www.thermofisher.com/order/catalog/product/022920.K2",
							ProductModel->Model[Sample,"Chloroform, for HPLC, =99.8%, contains 0.5-1.0% ethanol as stabilizer - multiple sizes available"],
							Name->"Chloroform (test)"<>$SessionUUID,
							NumberOfItems->1,
							SampleType->Vial,
							DefaultContainerModel->Model[Container,Vessel,"4L disposable amber glass bottle for inventory chemicals"],
							CatalogDescription->"Chloroform",
							Packaging->Single,
							Amount->4Liter,
							Price->1USD,
							Supplier -> Object[Company, Supplier, "Thermo Fisher Scientific"],
							CatalogNumber -> "022920.K2"
						]
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection
		],
		Example[{Options, "ImageFile", "Use the ImageFile option to specify an image of the product of the uploaded Object[Product]. This should be a URL of an image file:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						ImageFile->"https://assets.thermofisher.com/TFS-Assets/LSG/product-images/85190-DMSO.jpg-250.jpg",
						Name->"Dimethyl sulfoxide (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"Dimethyl sulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Test["Use the ImageFile option to specify an image of the product of the uploaded Object[Product], and make sure this actually makes a cloud file:",
			Quiet[
				Check[
					prod=UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						ImageFile->"https://assets.thermofisher.com/TFS-Assets/LSG/product-images/85190-DMSO.jpg-250.jpg",
						Name->"Dimethyl sulfoxide (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"Dimethyl sulfoxide",
						Amount -> 50 Milliliter
					];Download[prod,ImageFile],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[EmeraldCloudFile]]|Warning::APIConnection,
			Variables :> {prod},
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "ProductListing", "Use the ProductListing option to specify the full name under which the product is listed:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						ProductListing->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "CatalogDescription", "Use the CatalogDescription option to specify the full description of the item as it is listed in the supplier's catalog including any relevant information on the number of samples per item, the sample type, and/or the amount per sample if that information is included in the suppliers catalog list and necessary to place an order for the correct unit of the item which this product represents:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						ProductListing->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade",
						CatalogDescription->"1 50 mL Vial of Pierce Dimethylsulfoxide (DMSO), LC-MS grade",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "KitComponents", "Use the KitComponents option to specify all the components of the given kit:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/4336948",
						ProductListing->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
						CatalogDescription->"1 Kit of 310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1",
						Name->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
						Packaging->Single,
						SampleType->Kit,
						NumberOfItems->1,
						KitComponents->{
							{1,Model[Sample,"Test Matrix Standard 1"<>$SessionUUID],Model[Container,Vessel,"Test Container Model For UploadProduct 1"<>$SessionUUID],200*Microliter,"A1",1,Model[Item,Cap,"Test Cover Model For UploadProduct 1"<>$SessionUUID],False},
							{1,Model[Sample,"Test Matrix Standard 2"<>$SessionUUID],Null,200*Microliter,"A1",2,Null,False},
							{1,Model[Sample,"Test Matrix Standard 3"<>$SessionUUID],Null,200*Microliter,"A1",3,Null,False},
							{1,Model[Sample,"Test Matrix Standard 4"<>$SessionUUID],Null,200*Microliter,"A1",4,Null,False}
						},
						Price -> 100 USD,
						Supplier -> Object[Company, Supplier, "Thermo Fisher Scientific"],
						CatalogNumber -> "4336948"
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection
		],
		Example[{Options, "Supplier", "Use the Supplier option to specify the company that supplies this product. All Object[Company,Supplier] objects can be found by performing a search (Search[Object[Company,Supplier]]):"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Supplier->Object[Company,Supplier,"Sigma Aldrich"],
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "CatalogNumber", "Use the CatalogNumber option to specify the catalog number, as given by the supplier, of this product:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190",
						CatalogNumber->"85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Manufacturer", "Use the Manufacturer option to specify the Object[Company,Supplier] that manufactured this product:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Manufacturer->Object[Company,Supplier,"Sigma Aldrich"],
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ManufacturerCatalogNumber->"34861",
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "ManufacturerCatalogNumber", "Use the ManufacturerCatalogNumber to specify the Manufacturer's catalog number for this product:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Manufacturer->Object[Company,Supplier,"Sigma Aldrich"],
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ManufacturerCatalogNumber->"34861",
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "ProductURL", "Use the ProductURL to specify the Product URL of this product:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						Packaging->Single,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Packaging", "Use the Packaging to specify if this product is a Case or an Item:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Packaging->Single,
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "SampleType", "Use the SampleType to specify the type of sample that this product is. The valid values of this option can be found by evaluating SampleDescriptionP:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						SampleType->Vial,
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "NumberOfItems", "Use the NumberOfItems option to specify the number of samples in each order of one unit of this product. If this product is an item, NumberOfItems->1. If it is a Case, NumberOfItems should be the number of items in the case:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						NumberOfItems->1,
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						Packaging->Single,
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"<>$SessionUUID],
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection
		],
		Example[{Options, "DefaultContainerModel", "Use the DefaultContainerModel option to specify the container that the product arrives in from the manufacturer:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"<>$SessionUUID],
						SampleType->Vial,
						Packaging->Single,
						NumberOfItems->1,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection
		],
		Example[{Options, "Amount", "Use the Amount option to specify amount of substance per sample. For example, if the product contained 100 mL, then Amount ->100 * Milliliter:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Amount->100 Milliliter,
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"<>$SessionUUID],
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial,
						NumberOfItems->1,
						Packaging->Single,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide"
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection
		],
		Example[{Options, "CountPerSample", "Use the CountPerSample option to specify the initial count for all objects made from this product. Here, a product for a tub of weigh boats is created. This tub has 20 individual dishes and we create one Object[Item] with Count->100 when this product is received. This option should not be specified with Amount:"},
			UploadProduct[
				Supplier->Object[Company,Supplier,"Sigma Aldrich"],
				CountPerSample->20,
				Name->"Aluminum Round Micro Weigh Dishes with Handle" <> $SessionUUID,
				(* NOTE: This 'Counted' version of this model in the lab, but using it as a test 'Counted' object should be OK. *)
				ProductModel->Model[Item, WeighBoat, "Aluminum Round Micro Weigh Dish"],
				SampleType->Tub,
				Packaging->Single,
				CatalogDescription->"1 tub of weigh dishes",
				NumberOfItems->1,
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			ObjectP[Object[Product]],
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "ShippedClean", "Use the ShippedClean option to specify that samples of this product arrive ready to be used without needing to be dishwashed:"},
			Quiet[
				Check[
					UploadProduct["https://www.thermofisher.com/order/catalog/product/329-1000?SID=srch-srp-329-1000",
						ProductModel -> Model[Container, Vessel, "100 mL Glass Bottle"],
						ShippedClean -> True,
						SampleType -> Bottle,
						Packaging -> Single,
						NumberOfItems -> 1,
						CatalogDescription -> "100mL glass bottle",
						Name -> "100mL Bottle (UploadProtocol test)" <> $SessionUUID,
						Amount -> Null
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Sterile", "Use the Sterile option to specify that samples of this product arrive sterile from the manufacturer:"},
			UploadProduct[
				ProductModel -> Model[Container, Plate, "4-well V-bottom 75mL Deep Well Plate Sterile"],
				Sterile -> True,
				SampleType -> Plate,
				Packaging -> Single,
				NumberOfItems -> 25,
				CatalogDescription -> "1 Case of 25 x Plates",
				AsepticShippingContainerType -> Individual,
				Name -> "4-well V-bottom 75mL Deep Well Plate Sterile (UploadProtocol test) " <> $SessionUUID,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogNumber -> "AE123",
				Price -> 100 USD
			],
			ObjectP[Object[Product]],
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Price", "Use the Price option to specify the price for one unit of this product:"},
			Quiet[
				Check[
					UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Price->225 USD,
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "SealedContainer", "Use the SealedContainer option to specify whether a product arrives in a sealed container:"},
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), 75 mL, LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"75mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						SealedContainer->True,
						Amount -> 50 Milliliter
					];Download[product,SealedContainer],
					True,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			True|Warning::APIConnection,
			Variables :> {product},
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "AsepticShippingContainerType", "Use the AsepticShippingContainerType option to specify the manner in which an aseptic product is packed and shipped by the manufacturer:"},
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), 100mL, LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"100mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						AsepticShippingContainerType->ResealableBulk,
						Amount -> 50 Milliliter
					];Download[product,AsepticShippingContainerType],
					ResealableBulk,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ResealableBulk|Warning::APIConnection,
			Variables :> {product},
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "AsepticRebaggingContainerType", "Use the AsepticRebaggingContainerType option to specify the type of container items of this product will be transferred to if they arrive in a non-resealable aseptic shipping container.:"},
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), 150mL, LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"150mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						AsepticShippingContainerType -> NonResealableBulk,
						AsepticRebaggingContainerType->Individual,
						Amount -> 50 Milliliter
					];Download[product,AsepticRebaggingContainerType],
					Individual,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			Individual|Warning::APIConnection,
			Variables :> {product},
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Options, "Density", "Use Density to specify Density of the Product:"},
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.thermofisher.com/order/catalog/product/85190?SID=srch-srp-85190",
						Name->"Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)"<>$SessionUUID,
						CatalogDescription->"50mL glass bottle of Dimethylsulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						Density->1.1 Gram/Milliliter,
						Amount -> 50 Milliliter
					];Download[product,Density],
					1.1 Gram/Milliliter,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			1.1 Gram / Milliliter,
			Variables :> {product},
			Stubs:>{$AllowPublicObjects=True}
		],
		Test["Use the UsageFrequency option to provide an estimate of how often this product is purchased from ECL's inventory for use in experiments. The valid value of this option can be found by evaluating UsageFrequencyP:",
			Quiet[
				Check[
					UploadProduct[
						"https://www.fishersci.com/shop/products/acetonitrile-optima-fisher-chemical-6/A9961#?keyword=Acetonitrile%20for%20HPLC-GC,%20&gt;=99.8%%20(GC",
						Name->"Acetonitrile for HPLC-GC, >=99.8% (GC)"<>$SessionUUID,
						CatalogDescription->"1 bottle of Acetonitrile for HPLC-GC, >=99.8% (GC)",
						UsageFrequency->High,
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						Price->1 USD,
						DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
						Amount -> 100 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			ObjectP[Object[Product]]|Warning::APIConnection,
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Messages, "NonUniqueName", "An Object[Product] cannot be uploaded if another Object[Product] already exists in Constellation with the same name. In the following example, there is already a product in the database with the name \"Methanol, anhydrous, 99.8%\":"},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% (test)",
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				NumberOfItems -> 1,
				Packaging -> Single,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogNumber -> "1",
				Amount -> 100 Milliliter,
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::NonUniqueName,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RequiredOptions", "An Object[Product] cannot be uploaded without certain key information. If a key field is set to Null, an error will be thrown. In the following example, Name is set to Null:"},
			UploadProduct[
				Name -> Null,
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				CatalogDescription -> "100mL of Methanol, anhydrous, 99.8%",
				Packaging -> Single,
				NumberOfItems -> 1,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogNumber -> "1",
				Amount -> 100 Milliliter,
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::RequiredOptions,
				Error::NameIsPartOfSynonyms,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CountedProduct", "CountPerSample must be provided if the underlying product model is marked as Counted:"},
			UploadProduct[
				Supplier->Object[Company,Supplier,"Sigma Aldrich"],
				Name->"Aluminum Round Micro Weigh Dishes with Handle" <> $SessionUUID,
				(* NOTE: This 'Counted' version of this model in the lab, but using it as a test 'Counted' object should be OK. *)
				ProductModel->Model[Item, WeighBoat, "Aluminum Round Micro Weigh Dish"],
				SampleType->Tub,
				Packaging->Single,
				CatalogDescription->"1 tub of weigh dishes",
				NumberOfItems->1,
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::CountedProduct,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ManufacturerOptions", "The options Manufacturer and ManufacturerCatalogNumber must either both be specified or both set to Null. In the following example, ManufacturerCatalogNumber is set but Manufacturer is set to Null:"},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				ManufacturerCatalogNumber -> "322415",
				Manufacturer -> Null,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				Packaging -> Single,
				NumberOfItems -> 1,
				CatalogNumber -> "1",
				Amount -> 100 Milliliter,
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::RequiredTogetherOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "EmeraldSuppliedProductSamples", "If Emerald Cloud Lab is the supplier of this product, NumberOfItems must be 1. In the following example, the ECL is set as the supplier of the product, but NumberOfItems is set to 2:"},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
				Supplier -> Object[Company, Supplier, "Emerald Cloud Lab"],
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100 mL Glass Bottle"],
				SampleType -> Vial,
				NumberOfItems -> 2,
				Packaging -> Single,
				CatalogNumber -> "1",
				Amount -> 100 Milliliter,
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::EmeraldSuppliedProductSamples,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AmountUnitState", "The option Amount must match the model's state of matter. In the following example, the ProductModel of Methanol has State->Liquid. Therefore, Amount cannot be set to 3 Gram:"},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				Amount -> 3 Gram,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				Packaging -> Single,
				NumberOfItems -> 1,
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::AmountUnitState,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PricePerUnitRequired", "If this product is not supplied by Emerald Cloud Lab, the Price option must be specified. In the following example, the column is not provided by the ECL so Price must be specified:"},
			UploadProduct[
				Supplier->Object[Company,Supplier,"Sigma Aldrich"],
				Name->"HiTrap Q HP Column (test)" <> $SessionUUID,
				CatalogDescription->"1 bottle of HiTrap Q HP Column (test)",
				ProductModel->Model[Item,Column,"HiTrap Q HP 5x1mL Column"],
				SampleType->Column,
				Packaging->Single,
				NumberOfItems->1,
				CatalogNumber->"1"
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::PricePerUnitRequired
			},
			Stubs:>{$AllowPublicObjects=True}
		],
		Example[{Messages, "ProductAmount", "If this product is self contained, Amount must not be specified. If this product is not self contained, Amount must be specified. In the following example, the product is not self contained but Amount is set to Null."},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				Amount -> Null,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				Packaging -> Single,
				NumberOfItems -> 1,
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::ProductAmount,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TabletFields", "The options Amount and CountPerSample cannot both be informed at the same time, unless the product model is a Model[Sample] that is a Tablet. In the following example, CountPerSample is set to 1 and Amount were automatically populated by the Sigma Aldrich website:"},
			UploadProduct[
				Name -> "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID,
				CatalogDescription -> "1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
				ProductModel -> Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				DefaultContainerModel -> Model[Container, Vessel, "100mL Rectangular LDPE Media Bottle"],
				SampleType -> Vial,
				CountPerSample -> 1,
				Amount -> 100 Milliliter,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				Packaging -> Single,
				NumberOfItems -> 1,
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::TabletSachetFields,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidSampleType", "If KitComponents is specified, SampleType must be Kit:"},
			UploadProduct[
				ProductListing->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				CatalogDescription->"1 Kit of 310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1",
				Name->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				NumberOfItems->1,
				Packaging->Single,
				Supplier->Object[Company,Supplier,"Thermo Fisher Scientific"],				SampleType->ExquisiteGoatHairBrush,
				KitComponents->{
					{1,Model[Sample,"Test Matrix Standard 1"<>$SessionUUID],Null,200*Microliter,"A1",1,Null,False},
					{1,Model[Sample,"Test Matrix Standard 2"<>$SessionUUID],Null,200*Microliter,"A1",2,Null,False},
					{1,Model[Sample,"Test Matrix Standard 3"<>$SessionUUID],Null,200*Microliter,"A1",3,Null,False},
					{1,Model[Sample,"Test Matrix Standard 4"<>$SessionUUID],Null,200*Microliter,"A1",4,Null,False}
				},
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::InvalidSampleType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidKitOptions", "If KitComponents is specified, ProductModel, DefaultContainerModel, NumberOfItems, CountPerSample, and Amount must all be Null:"},
			UploadProduct[
				ProductListing->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				CatalogDescription->"1 Kit of 310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1",
				Name->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				Packaging->Single,
				SampleType->Kit,
				NumberOfItems->1,
				Supplier->Object[Company,Supplier,"Thermo Fisher Scientific"],				ProductModel->Model[Sample,"Test Matrix Standard 2"<>$SessionUUID],
				KitComponents->{
					{1,Model[Sample,"Test Matrix Standard 1"<>$SessionUUID],Null,200*Microliter,"A1",1,Null,False},
					{1,Model[Sample,"Test Matrix Standard 2"<>$SessionUUID],Null,200*Microliter,"A1",2,Null,False},
					{1,Model[Sample,"Test Matrix Standard 3"<>$SessionUUID],Null,200*Microliter,"A1",3,Null,False},
					{1,Model[Sample,"Test Matrix Standard 4"<>$SessionUUID],Null,200*Microliter,"A1",4,Null,False}
				},
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::InvalidKitOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SingleKitComponent", "If KitComponents is specified, at least two components must be specified:"},
			UploadProduct[
				ProductListing->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				CatalogDescription->"1 Kit of 310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1",
				Name->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				Packaging->Single,
				SampleType->Kit,
				NumberOfItems->1,
				Supplier->Object[Company,Supplier,"Thermo Fisher Scientific"],				KitComponents->{
					{1,Model[Sample,"Test Matrix Standard 1"<>$SessionUUID],Null,200*Microliter,"A1",1,Null,False}
				},
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::SingleKitComponent,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidContainerIndexPosition", "If KitComponents is specified, ContainerIndex and Position must not be Null for NonSelfContainedSampleModels (and must be Null for all others):"},
			UploadProduct[
				ProductListing->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				CatalogDescription->"1 Kit of 310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1",
				Name->"310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1"<>$SessionUUID,
				Packaging->Single,
				SampleType->Kit,
				NumberOfItems->1,
				Supplier->Object[Company,Supplier,"Thermo Fisher Scientific"],				KitComponents->{
					{1,Model[Sample,"Test Matrix Standard 1"<>$SessionUUID],Null,200*Microliter,"A1",1,Null,False},
					{1,Model[Sample,"Test Matrix Standard 2"<>$SessionUUID],Null,200*Microliter,Null,2,Null,False},
					{1,Model[Sample,"Test Matrix Standard 3"<>$SessionUUID],Null,200*Microliter,"A1",Null,Null,False},
					{1,Model[Sample,"Test Matrix Standard 4"<>$SessionUUID],Null,200*Microliter,"A1",4,Null,False}
				},
				CatalogNumber -> "1",
				Price -> 1 USD
			],
			Null,
			Messages :> {
				Error::InvalidContainerIndexPosition,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RepeatedContainerIndex", "If KitComponents is specified, all components whose Containers are specified as Model[Container,Vessel] must have unique container indices:"},
			UploadProduct[
				CatalogDescription->"Fluorescent standard",
				CatalogNumber->"P3088",
				KitComponents->{
					{1,Model[Sample,"Test Fluorescence Standard For UploadProduct 1"<>$SessionUUID],Model[Container,Vessel,"Test Container Model For UploadProduct 1"<>$SessionUUID],15 Milliliter,"A1",1,Null,False},
					{1,Model[Sample,"Test Fluorescence Standard For UploadProduct 2"<>$SessionUUID],Model[Container,Vessel,"Test Container Model For UploadProduct 2"<>$SessionUUID],8 Milliliter,"A1",2,Null,False},
					{1,Model[Sample,"Test Fluorescence Standard For UploadProduct 3"<>$SessionUUID],Model[Container,Vessel,"Test Container Model For UploadProduct 2"<>$SessionUUID],4 Milliliter,"A1",2,Null,False}
				},
				Name->"Test Fluorescence Polarization Kit"<>$SessionUUID,
				NumberOfItems->1,
				Packaging->Single,
				Price->1 USD,
				ProductListing->"Test Fluorescence Polarization Kit"<>$SessionUUID,
				SampleType->Kit,
				Supplier->Object[Company,Supplier,"id:D8KAEvdq1RB3"]
			],
			Null,
			Messages :> {Error::RepeatedContainerIndex, Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedAsepticReceiving","If Sterile is True, SealedContainer is False, and AsepticShippingContainerType is Null, an error is thrown:"},
			UploadProduct[
				Name->"Milli-Q water (test 2)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				Sterile -> True,
				SealedContainer -> False,
				AsepticShippingContainerType -> Null
			],
			Null,
			Messages :> {Error::UnsupportedAsepticReceiving, Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedAsepticReceiving","If Sterile is False, SealedContainer is True, and AsepticShippingContainerType is Individual, an error is thrown:"},
			UploadProduct[
				Name->"Milli-Q water (test 3)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				Sterile -> False,
				SealedContainer -> True,
				AsepticShippingContainerType -> Individual
			],
			Null,
			Messages :> {Error::UnsupportedAsepticReceiving, Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleAsepticShippingAndReceiving","If AsepticShippingContainerType is Individual, AsepticRebaggingContainerType cannot be specified:"},
			UploadProduct[
				Name->"Milli-Q water (test 4)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				SealedContainer -> False,
				Sterile -> True,
				AsepticShippingContainerType -> Individual,
				AsepticRebaggingContainerType -> Individual
			],
			Null,
			Messages :> {Error::IncompatibleAsepticShippingAndReceiving, Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleAsepticShippingAndReceiving","If AsepticShippingContainerType is ResealableBulk, AsepticRebaggingContainerType cannot be specified:"},
			UploadProduct[
				Name->"Milli-Q water (test 5)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				SealedContainer -> False,
				Sterile -> True,
				AsepticShippingContainerType -> ResealableBulk,
				AsepticRebaggingContainerType -> Individual
			],
			Null,
			Messages :> {Error::IncompatibleAsepticShippingAndReceiving, Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleAsepticShippingAndReceiving","If AsepticShippingContainerType is NonResealableBulk, AsepticRebaggingContainerType cannot be Null:"},
			UploadProduct[
				Name->"Milli-Q water (test 6)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				SealedContainer -> False,
				Sterile -> True,
				AsepticShippingContainerType -> NonResealableBulk,
				AsepticRebaggingContainerType -> Null
			],
			Null,
			Messages :> {Error::AsepticRebaggingContainerTypeRequired, Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleAsepticShippingAndReceiving","If AsepticShippingContainerType is None, AsepticRebaggingContainerType cannot be Null:"},
			UploadProduct[
				Name->"Milli-Q water (test 7)"<>$SessionUUID,
				Supplier -> Object[Company,Supplier,"id:D8KAEvdq1RB3"],
				CatalogNumber -> "ABCD",
				Amount -> 500 Milliliter,
				Price -> 1 USD,
				CatalogDescription->"1 bottle of Milli-Q water (test)",
				Packaging->Single,
				ProductModel->Model[Sample,"Milli-Q water"],
				NumberOfItems->1,
				SampleType->Vial,
				DefaultContainerModel->Model[Container,Vessel,"2.5L Wide Neck Amber Glass Bottle"],
				SealedContainer -> False,
				Sterile -> True,
				AsepticShippingContainerType -> None,
				AsepticRebaggingContainerType -> Null
			],
			Null,
			Messages :> {Error::AsepticRebaggingContainerTypeRequired, Error::InvalidOption}
		],
		Test["Density field is populated automatically if informed in the Model:",
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.fishersci.com/shop/products/acetonitrile-optima-fisher-chemical-6/A9961#?keyword=Acetonitrile%20for%20HPLC-GC,%20&gt;=99.8%%20(GC",
						Name->"Milli-Q water (test)"<>$SessionUUID,
						CatalogDescription->"1 bottle of Milli-Q water (test)",
						ProductModel->Model[Sample,"Milli-Q water"],
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial,
						Price->1 USD,
						Amount -> 100 Milliliter,
						Packaging -> Single,
						NumberOfItems -> 1
					];Download[product,Density],
					Download[Model[Sample, "Milli-Q water"], Density],
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			Download[Model[Sample, "Milli-Q water"], Density],
			Variables :> {product},
			Stubs:>{$AllowPublicObjects=True}
		],
		Test["Make sure DateCreated is populated:",
			Quiet[
				Check[
					product=UploadProduct[
						"https://www.fishersci.com/shop/products/methanol-99-8-extra-dry-anhydrous-sc-acroseal-thermo-scientific/AC610981000#?keyword=Methanol,%20anhydrous,%2099.8%%20|%20CH3OH",
						Name->"Methanol, anhydrous, 99.8% | CH3OH (test)"<>$SessionUUID,
						CatalogDescription->"1 bottle of Methanol, anhydrous, 99.8% | CH3OH (test)",
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"<>$SessionUUID],
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial,
						Price->1 USD,
						Amount -> 100 Milliliter,
						Packaging -> Single,
						NumberOfItems -> 1
					];Download[product,DateCreated],
					Now,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption}
			],
			_?DateObjectQ,
			Variables :> {product}
		],
		Test["If no information can be retrieved from the supplied productURL, continue to upload the product object with any information available from the options:",
			UploadProduct[
				"https://www.sigmaaldrich.com/catalog/"<>$SessionUUID,
				Name -> "Diethylene glycol methyl ether 99% (test)" <> $SessionUUID,
				Packaging -> Single,
				ProductModel -> Model[Sample, "Diethylene glycol methyl ether 99%"],
				NumberOfItems -> 1,
				SampleType -> Vial,
				DefaultContainerModel -> Model[Container, Vessel, "50mL tall sloping shoulder amber glass bottle"],
				CatalogNumber -> "109908",
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				Amount -> 50 Milliliter,
				Price -> 57.50 USD,
				CatalogDescription -> "High purity diethylene glycol methyl ether"
			],
			ObjectP[Object[Product]],
			Messages :> {Warning::APIConnection},
			Stubs:>{$AllowPublicObjects=True, $UsePyeclProductParser = False}
		]
	},
	Stubs :> {findProductPriceAgain[___] := 1.0, $UseAIProductParser = False} (* If the price couldn't be found, set to 1.0 USD *),
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Upload::Warning];
		Module[{objs, existingObjs},
			objs = {
				Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				(* These are from the SetUp of tests themselves, so remove them from there *)
				Model[Sample, "Test Matrix Standard 1" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 2" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 3" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 4" <> $SessionUUID],
				Object[Product, "Template Product" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 1" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 2" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 3" <> $SessionUUID],
				Model[Container, Vessel, "Test Container Model For UploadProduct 1" <> $SessionUUID],
				Model[Container, Vessel, "Test Container Model For UploadProduct 2" <> $SessionUUID],
				Model[Item, Cap, "Test Cover Model For UploadProduct 1" <> $SessionUUID],
				Object[Product, "Methanol, anhydrous, 99.8% (test)" <> $SessionUUID],				(* these are the products that are generated by the tests themselves *)
				Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID],
				Object[Product, "Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)" <> $SessionUUID],
				Object[Product, "Diethylene glycol methyl ether 99% (test)" <> $SessionUUID],
				Object[Product, "Acetonitrile for HPLC-GC, >=99.8% (GC) (test)" <> $SessionUUID],
				Object[Product, "Ethyl methyl ketone (test)" <> $SessionUUID],
				Object[Product, "Chloroform (test)" <> $SessionUUID],
				Object[Product, "Dimethyl sulfoxide (test)" <> $SessionUUID],
				Object[Product, "310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1" <> $SessionUUID],
				Object[Product, "Acetonitrile for HPLC-GC, >=99.8% (GC)" <> $SessionUUID],
				Object[Product, "HiTrap Q HP Column (test)" <> $SessionUUID],
				Object[Product, "Test Fluorescence Polarization Kit" <> $SessionUUID],
				Object[Product, "Milli-Q water (test)" <> $SessionUUID]			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		];
		Module[{methanol, matrix1, matrix2, matrix3, matrix4, templateProd, kitComponent1, kitComponent2,
			kitComponent3, containerModel1, containerModel2, coverModel, existingProd},

			{
				methanol,
				matrix1,
				matrix2,
				matrix3,
				matrix4,
				templateProd,
				kitComponent1,
				kitComponent2,
				kitComponent3,
				containerModel1,
				containerModel2,
				coverModel,
				existingProd
			} = CreateID[{
				Model[Sample],
				Model[Sample],
				Model[Sample],
				Model[Sample],
				Model[Sample],
				Object[Product],
				Model[Sample],
				Model[Sample],
				Model[Sample],
				Model[Container, Vessel],
				Model[Container, Vessel],
				Model[Item, Cap],
				Object[Product]
			}];

			Upload[{
				<|
					Object -> methanol,
					DeveloperObject -> True,
					Name -> "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID,
					Replace[Synonyms] -> {
						"Alcohol, Methyl",
						"Alcohol, Wood",
						"Carbinol",
						"Methanol",
						"Methoxide, Sodium",
						"Methyl Alcohol",
						"Sodium Methoxide",
						"Wood Alcohol",
						"Methanol, anhydrous, 99.8% | CH3OH",
						"Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID
					},
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Methanol"]]}},
					Solvent -> Link[Model[Sample, "Methanol - LCMS grade"]],
					UsedAsSolvent -> True,
					Replace[Authors] -> {Link[$PersonID]},
					UNII -> "Y4S76JWI15",
					State -> Liquid,
					MeltingPoint -> -97.6 Celsius,
					BoilingPoint -> 64.7 Celsius,
					Replace[pKa] -> 15.3,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage, Flammable"]],
					Radioactive -> False,
					Ventilated -> True,
					Flammable -> True,
					Pyrophoric -> False,
					WaterReactive -> False,
					Fuming -> True,
					ParticularlyHazardousSubstance -> True,
					MSDSRequired -> True,
					NFPA -> {Health -> 1, Flammability -> 3, Reactivity -> 0, Special -> {}},
					DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
					BiosafetyLevel -> "BSL-1",
					Replace[IncompatibleMaterials] -> {ABS, Polyurethane},
					Replace[LiquidHandlerIncompatible] -> True
				|>,
				<|
					Object -> matrix1,
					DeveloperObject -> True,
					Name -> "Test Matrix Standard 1" <> $SessionUUID
				|>,
				<|
					Object -> matrix2,
					DeveloperObject -> True,
					Name -> "Test Matrix Standard 2" <> $SessionUUID
				|>,
				<|
					Object -> matrix3,
					DeveloperObject -> True,
					Name -> "Test Matrix Standard 3" <> $SessionUUID
				|>,
				<|
					Object -> matrix4,
					DeveloperObject -> True,
					Name -> "Test Matrix Standard 4" <> $SessionUUID
				|>,
				<|
					Object -> templateProd,
					Name -> "Template Product" <> $SessionUUID,
					Amount -> 50.` Milliliter,
					CatalogNumber -> "id:J8AY5jwzPdaB-50ML",
					Price -> Quantity[100., "USDollars"],
					ProductModel -> Link[Model[Sample, "1X PBS, pH 7.4"], Products],
					ProductListing -> "1x PBS from 10X stock, 50 mL",
					NumberOfItems -> 1,
					SampleType -> Bottle,
					Supplier -> Link[Object[Company, Supplier, "Emerald Cloud Lab"], Products],
					UsageFrequency -> Low,
					Packaging -> Single
				|>,
				<|
					Object -> kitComponent1,
					DeveloperObject -> True,
					Name -> "Test Fluorescence Standard For UploadProduct 1" <> $SessionUUID
				|>,
				<|
					Object -> kitComponent2,
					DeveloperObject -> True,
					Name -> "Test Fluorescence Standard For UploadProduct 2" <> $SessionUUID
				|>,
				<|
					Object -> kitComponent3,
					DeveloperObject -> True,
					Name -> "Test Fluorescence Standard For UploadProduct 3" <> $SessionUUID
				|>,
				<|
					Object -> containerModel1,
					DeveloperObject -> True,
					Name -> "Test Container Model For UploadProduct 1" <> $SessionUUID
				|>,
				<|
					Object -> containerModel2,
					DeveloperObject -> True,
					Name -> "Test Container Model For UploadProduct 2" <> $SessionUUID
				|>,
				<|
					Object -> coverModel,
					DeveloperObject -> True,
					Name -> "Test Cover Model For UploadProduct 1" <> $SessionUUID
				|>,
				<|
					Object -> existingProd,
					DeveloperObject -> True,
					Name -> "Methanol, anhydrous, 99.8% (test)" <> $SessionUUID
				|>
			}];
			(* parseProductURL results are memoized. Clear memoization in case previous results are still stored *)
			ClearMemoization[]
		]
	),
	SymbolTearDown :> (
		On[Upload::Warning];
		Module[{objs, existingObjs},
			objs = {
				Model[Sample, "Methanol, anhydrous, 99.8% | CH3OH" <> $SessionUUID],
				(* These are from the SetUp of tests themselves, so remove them from there *)
				Model[Sample, "Test Matrix Standard 1" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 2" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 3" <> $SessionUUID],
				Model[Sample, "Test Matrix Standard 4" <> $SessionUUID],
				Object[Product, "Template Product" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 1" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 2" <> $SessionUUID],
				Model[Sample, "Test Fluorescence Standard For UploadProduct 3" <> $SessionUUID],
				Model[Container, Vessel, "Test Container Model For UploadProduct 1" <> $SessionUUID],
				Model[Container, Vessel, "Test Container Model For UploadProduct 2" <> $SessionUUID],
				Model[Item, Cap, "Test Cover Model For UploadProduct 1" <> $SessionUUID],
				Object[Product, "Methanol, anhydrous, 99.8% (test)" <> $SessionUUID],				(* these are the products that are generated by the tests themselves *)
				Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (test)" <> $SessionUUID],
				Object[Product, "Pierce Dimethylsulfoxide (DMSO), LC-MS Grade (test)" <> $SessionUUID],
				Object[Product, "Diethylene glycol methyl ether 99% (test)" <> $SessionUUID],
				Object[Product, "Acetonitrile for HPLC-GC, >=99.8% (GC) (test)" <> $SessionUUID],
				Object[Product, "Ethyl methyl ketone (test)" <> $SessionUUID],
				Object[Product, "Chloroform (test)" <> $SessionUUID],
				Object[Product, "Dimethyl sulfoxide (test)" <> $SessionUUID],
				Object[Product, "310 Genetic Analyzer Matrix Standards, BigDye Terminator v3.1" <> $SessionUUID],
				Object[Product, "Acetonitrile for HPLC-GC, >=99.8% (GC)" <> $SessionUUID],
				Object[Product, "HiTrap Q HP Column (test)" <> $SessionUUID],
				Object[Product, "Test Fluorescence Polarization Kit" <> $SessionUUID],
				Object[Product, "Milli-Q water (test)" <> $SessionUUID]			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	)
];



(* ::Subsubsection::Closed:: *)
(*UploadProductOptions*)


DefineTests[
	UploadProductOptions,
	{
		Example[{Basic, "Inspect the resolved options when uploading a Object[Product] of Methanol, anhydrous, 99.8% purity using its Sigma-Aldrich product URL:"},
			UploadProductOptions[
				"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US",
				Name->"Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID,
				CatalogDescription->"100mL bottle of Methanol, anhydrous, 99.8%",
				ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"],
				DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
				SampleType->Vial,
				OutputFormat->List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			SetUp :> {
				If[DatabaseMemberQ[Object[Product,  "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product,  "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product,  "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product,  "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs :> {
				$AllowPublicObjects = True,
				(* stub the response of the api call to sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" ->
							"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US", "Method" -> "GET",
						"Headers" -> <|
							"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
						|>
					|>
				] = ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/7d3a0e3c125ce4884b948b96cc7aead7.txt", ""]],
				(* stub the response of the reverse-engineered api call to get price info from sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" -> "https://www.sigmaaldrich.com/api?operation=PricingAndAvailability",
						"Method" -> "POST",
						"Headers" -> <|
							"accept" -> "*/*",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
							"x-gql-operation-name" -> "PricingAndAvailability",
							"x-gql-access-token" -> "ea816e21-7d19-11ef-90f5-8321289a8c21",
							"x-gql-country" -> "US"
						|>,
						"Body" -> <|
							"operationName" -> "PricingAndAvailability",
							"query" -> "query PricingAndAvailability($productNumber:String!,$brand:String,$quantity:Int!,$materialIds:[String!]) {
							getPricingForProduct(input:{productNumber:$productNumber,brand:$brand,quantity:$quantity,materialIds:$materialIds}) {
								materialPricing {
									packageSize
									price
								}
							}
						}",
							"variables" -> <|
								"brand" -> "SIAL",
								"materialIds" -> {"322415-VAR", "322415-PZ", "322415-900ML", "322415-8L", "322415-6L", "322415-1L", "322415-200L", "322415-200L-P2", "322415-200L-P2-SA", "322415-20L", "322415-20L-P2", "322415-250ML", "322415-2L", "322415-4X2L", "322415-6X1L", "322415-18L-P1", "322415-18L", "322415-12X100ML", "QR-028-1L", "322415-100ML", "322415-1250L-P1"},
								"productNumber" -> "322415",
								"quantity" -> 1
							|>
						|>
					|>
				] = ToExpression[ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/3ef849f6ab315a079d12676414b00bd3.txt", ""]]],
				$UsePyeclProductParser = False
			}
		],
		Example[{Basic, "Inspect the resolved options when uploading a Object[Product] of DMSO (LC-MS Grade) using its ThermoFisher product URL:"},
			Quiet[
				Check[
					UploadProductOptions[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Name->"Dimethyl sulfoxide (example) "<>$SessionUUID,
						CatalogDescription->"50mL bottle of Dimethyl sulfoxide",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						OutputFormat->List,
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption,Error::ProductAmount,Error::PricePerUnitRequired}
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Basic, "Inspect the resolved options when uploading a Object[Product] of Diethylene glycol methyl ether manually (without scraping from a product URL) :"},
			UploadProductOptions[
				Packaging -> Single,
				ProductModel -> Model[Sample, "Diethylene glycol methyl ether 99%"],
				NumberOfItems -> 1,
				SampleType -> Vial,
				DefaultContainerModel -> Model[Container, Vessel, "50mL tall sloping shoulder amber glass bottle"],
				Name -> "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID,
				CatalogDescription -> "50mL bottle of Diethylene glycol methyl ether 99%",
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogNumber -> "1",
				Amount -> 50 Milliliter,
				Price -> 1 USD,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			Quiet[
				Check[
					UploadProductOptions[
						"https://www.fishersci.com/shop/products/methanol-99-8-extra-dry-anhydrous-sc-acroseal-thermo-scientific/AC610981000#?keyword=Methanol,%20anhydrous,%2099.8%%20|%20CH3OH",
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"],
						Name->"Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID,
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						CatalogDescription->"100mL bottle of Methanol, anhydrous, 99.8%",
						SampleType->Vial,
						OutputFormat->List
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption,Error::ProductAmount,Error::PricePerUnitRequired}
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table:"},
			Quiet[
				Check[
					UploadProductOptions[
						"https://www.fishersci.com/shop/products/methanol-99-8-extra-dry-anhydrous-sc-acroseal-thermo-scientific/AC610981000#?keyword=Methanol,%20anhydrous,%2099.8%%20|%20CH3OH",
						ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"],
						Name->"Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID,
						CatalogDescription->"100mL bottle of Methanol, anhydrous, 99.8%",
						DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
						SampleType->Vial
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection,Error::RequiredOptions,Error::InvalidOption,Error::ProductAmount,Error::PricePerUnitRequired}
			],
			Graphics_|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadProductQ*)


DefineTests[
	ValidUploadProductQ,
	{
		Example[{Basic, "Determine if the uploaded Object[Product] of Methanol, anhydrous, 99.8% purity will be valid when uploaded:"},
			ValidUploadProductQ[
				"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US",
				Name->"Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID,
				ProductModel->Model[Sample,"Methanol, anhydrous, 99.8% | CH3OH"],
				DefaultContainerModel->Model[Container,Vessel,"100mL Rectangular LDPE Media Bottle"],
				SampleType->Vial,
				CatalogDescription->"1 Vial of Methanol, anhydrous, 99.8% | CH3OH"
			],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Methanol, anhydrous, 99.8% | CH3OH (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{
				$AllowPublicObjects=True,
				(* stub the response of the api call to sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" ->
							"https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US", "Method" -> "GET",
						"Headers" -> <|
							"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
						|>
					|>
				] = ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/7d3a0e3c125ce4884b948b96cc7aead7.txt", ""]],
				(* stub the response of the reverse-engineered api call to get price info from sigma website since they like to block us once in a while *)
				HTTPRequestJSON[
					<|
						"URL" -> "https://www.sigmaaldrich.com/api?operation=PricingAndAvailability",
						"Method" -> "POST",
						"Headers" -> <|
							"accept" -> "*/*",
							"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
							"x-gql-operation-name" -> "PricingAndAvailability",
							"x-gql-access-token" -> "ea816e21-7d19-11ef-90f5-8321289a8c21",
							"x-gql-country" -> "US"
						|>,
						"Body" -> <|
							"operationName" -> "PricingAndAvailability",
							"query" -> "query PricingAndAvailability($productNumber:String!,$brand:String,$quantity:Int!,$materialIds:[String!]) {
							getPricingForProduct(input:{productNumber:$productNumber,brand:$brand,quantity:$quantity,materialIds:$materialIds}) {
								materialPricing {
									packageSize
									price
								}
							}
						}",
							"variables" -> <|
								"brand" -> "SIAL",
								"materialIds" -> {"322415-VAR", "322415-PZ", "322415-900ML", "322415-8L", "322415-6L", "322415-1L", "322415-200L", "322415-200L-P2", "322415-200L-P2-SA", "322415-20L", "322415-20L-P2", "322415-250ML", "322415-2L", "322415-4X2L", "322415-6X1L", "322415-18L-P1", "322415-18L", "322415-12X100ML", "QR-028-1L", "322415-100ML", "322415-1250L-P1"},
								"productNumber" -> "322415",
								"quantity" -> 1
							|>
						|>
					|>
				] = ToExpression[ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/3ef849f6ab315a079d12676414b00bd3.txt", ""]]],
				$UsePyeclProductParser = False
			}
		],
		Example[{Basic, "Determine if the uploaded Object[Product] of DMSO (LC-MS Grade) will be valid when uploaded:"},
			Quiet[
				Check[
					ValidUploadProductQ[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						Name->"Dimethyl sulfoxide (example) "<>$SessionUUID,
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"1 Vial of Dimethyl sulfoxide (example)",
						Amount -> 1 Milliliter,
						Price -> 1 USD,
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection}
			],
			True|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Basic, "Determine if the uploaded Object[Product] of Diethylene glycol methyl ether will be valid when uploaded:"},
			ValidUploadProductQ[
				Packaging -> Single,
				ProductModel -> Model[Sample, "Diethylene glycol methyl ether 99%"],
				NumberOfItems -> 1,
				SampleType -> Vial,
				DefaultContainerModel -> Model[Container, Vessel, "50mL tall sloping shoulder amber glass bottle"],
				Name -> "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogDescription -> "1 Vial of 50 mL of Diethylene glycol methyl ether 99%",
				CatalogNumber -> "1",
				Amount -> 50 Milliliter,
				Price -> 1 USD
			],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Test["Determine if the uploaded Object[Product] of Diethylene glycol methyl ether will be valid when uploaded if some required options are missing:",
			ValidUploadProductQ[
				Packaging -> Single,
				ProductModel -> Model[Sample, "Diethylene glycol methyl ether 99%"],
				NumberOfItems -> 1,
				SampleType -> Vial,
				DefaultContainerModel -> Model[Container, Vessel, "50mL tall sloping shoulder amber glass bottle"],
				Name -> "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID,
				Supplier -> Object[Company, Supplier, "Sigma Aldrich"],
				CatalogDescription -> "1 Vial of 50 mL of Diethylene glycol methyl ether 99%",
				CatalogNumber -> "1",
				Amount -> 50 Milliliter
			],
			False,
			Messages :> {Error::PricePerUnitRequired},
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Diethylene glycol methyl ether 99% (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Options, "Verbose", "Set Verbose->True to see all of the tests that ValidUploadProductQ is running. Valid values for this option are True|False|Failures:"},
			Quiet[
				Check[
					ValidUploadProductQ[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Packaging->Single,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						Name->"Dimethyl sulfoxide (example) "<>$SessionUUID,
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"1 Vial of Dimethyl sulfoxide (example)",
						Amount -> 1 Milliliter,
						Price -> 1 USD,
						Verbose->True,
						Amount -> 50 Milliliter
					],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection}
			],
			True|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		],
		Example[{Options, "OutputFormat", "Set OutputFormat->TestSummary to have the function return a TestSummary object instead of a single Boolean. The dereferenceable keys form this object can be viewed by running Keys[...] on the test summary:"},
			Quiet[
				Check[
					ValidUploadProductQ[
						"https://www.thermofisher.com/order/catalog/product/85190",
						Packaging->Single,
						Name->"Dimethyl sulfoxide (example) "<>$SessionUUID,
						ProductModel->Model[Sample,"Dimethyl sulfoxide"],
						NumberOfItems->1,
						SampleType->Vial,
						DefaultContainerModel->Model[Container,Vessel,"50mL tall sloping shoulder amber glass bottle"],
						CatalogDescription->"1 Vial of Dimethyl sulfoxide (example)",
						Amount->1 Milliliter,
						Price->1 USD,
						OutputFormat->TestSummary,
						Amount -> 50 Milliliter
					]["Successes"],
					Warning::APIConnection,
					{Warning::APIConnection}
				],
				{Warning::APIConnection}
			],
			_List|Warning::APIConnection,
			SetUp :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID]],
					EraseObject[Object[Product, "Dimethyl sulfoxide (example) "<>$SessionUUID], Force -> True, Verbose -> False]
				]
			},
			Stubs:>{$AllowPublicObjects=True, $UseAIProductParser = False}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*parseProductURL*)

(* -- Due to the quota of Gemini we should always avoid actually using AI parser. If routing to AI parser is necessary for the test, we should always stub the output -- *)

DefineTests[
	parseProductURL,
	{
		Test["Take a product url as input, output an association which contains information about this product:",
			parseProductURL["https://www.fishersci.com/shop/products/falcon-50ml-conical-centrifuge-tubes-2/1443222"],
			_Association,
			Stubs :> {$UseAIProductParser = False}
		],
		Test["If the product url is not available (i.e., Null), return $Failed:",
			parseProductURL[Null],
			$Failed,
			Stubs :> {$UseAIProductParser = False}
		],
		Test["If use of AI parser is not allowed, parser will always return $Failed if the webpage does not belong to one of these 3 vendors: thermo, fishersci, sigma:",
			parseProductURL["https://www.avantorsciences.com/us/en/product/10073654/sodium-hydroxide-33-ww-in-aqueous-solution-vwr-chemicals-bdh"],
			$Failed,
			Stubs :> {$UseAIProductParser = False}
		],
		Test["When $UseAIProductParser is set to First, function will attempt to use AI parser first; if AI parser failed, function will then try conventional parser:",
			(* Here's how this test works: ai parser will sow "used ai parser" but return $Failed, and conventional parser will return an association *)
			(* If function only used AI parser, result would be $Failed; if function only used conventional parser, or used conventional parser first, nothing would be sown *)
			(* Thus if we get both the sown value and the parsed association, the only possibility is function first tried ai parser, which failed, then attempted conventional parser *)
			Reap[
				parseProductURL["https://www.fishersci.com/shop/products/falcon-50ml-conical-centrifuge-tubes-2/1443222"],
				"test tag"<>$SessionUUID
			],
			{
				AssociationMatchP[<| Name -> "50mL Tube", Price -> EqualP[1 USD] |>, AllowForeignKeys -> True],
				{{"used ai parser"}}
			},
			Stubs :> {
				$UseAIProductParser = First,
				PyECLRequest["/ccd/ai/extract-product", ___]:=Module[{}, Sow["used ai parser", "test tag"<>$SessionUUID]; $Failed],
				PyECLRequest["/ccd/extract-product", ___] := <| "title" -> "50mL Tube", "price" -> 1.00 |>
			}
		],
		(* Gemini endpoint won't be actually hit because we are stubbing out the PyECLRequest call *)
		Test["When $UseAIProductParser is set to Last, function will attempt to use conventional parser first; if that failed, function will then try AI parser:",
			Reap[
				parseProductURL["https://www.fishersci.com/shop/products/falcon-50ml-conical-centrifuge-tubes-2/1443222"],
				"test tag"<>$SessionUUID
			],
			{
				AssociationMatchP[<| Name -> "50mL Tube", Price -> EqualP[1 USD] |>, AllowForeignKeys -> True],
				{{"used conventional parser"}}
			},
			Stubs :> {
				$UseAIProductParser = Last,
				PyECLRequest["/ccd/extract-product", ___]:=Module[{}, Sow["used conventional parser", "test tag"<>$SessionUUID]; $Failed],
				PyECLRequest["/ccd/ai/extract-product", ___] := <| "title" -> "50mL Tube", "price" -> 1.00 |>
			}
		],
		(* Gemini endpoint won't be actually hit because we are stubbing out the PyECLRequest call *)
		Test["If the price obtained from parser is 0, function will re-attempt by directly posting the pricing api:",
			parseProductURL["https://www.fishersci.com/shop/products/falcon-50ml-conical-centrifuge-tubes-2/1443222"],
			AssociationMatchP[<| Name -> "50mL Tube", Price -> EqualP[100 USD] |>, AllowForeignKeys -> True],
			Stubs :> {
				$UseAIProductParser = True,
				PyECLRequest["/ccd/ai/extract-product", ___] := <| "title" -> "50mL Tube", "price" -> 0.00, "catalog_number" -> "14-432-22" |>,
				findProductPriceAgain["14-432-22", "fisher"] := 100
			}
		],
		Test["Successfully parse information for a 2 ml tube product from fishersci:",
			parseProductURL["https://www.fishersci.com/shop/products/2-0ml-micro-centrifuge-tube/50202026"],
			_Association,
			Stubs :> {$UseAIProductParser = False}
		],
		Test["Successfully parse information for a DNA product from thermo:",
			parseProductURL["https://www.thermofisher.com/order/catalog/product/SM0241?SID=srch-srp-SM0241"],
			_Association,
			Stubs :> {$UseAIProductParser = False}
		]
	},
	SetUp :> {ClearMemoization[]}
];

(* ::Subsection::Closed:: *)
(*UploadInventory*)

DefineTests[
	UploadInventory,
	{
		Example[{Basic, "Create an Inventory object for the automatic reordering of a kit product:"},
			UploadInventory[Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID], ModelStocked -> Model[Part, InformationTechnology, "Hard drive Dev5"]],
			{ObjectP[Object[Inventory, Product]]..}
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a non-kit product:"},
			UploadInventory[Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID]],
			{ObjectP[Object[Inventory, Product]]..}
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a stock solution:"},
			UploadInventory[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]],
			{ObjectP[Object[Inventory, StockSolution]]..}
		],
		Example[{Basic, "Edit the values of an already-existing inventory object:"},
			UploadInventory[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID], ReorderThreshold -> 200 Milliliter],
			{ObjectP[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID]]}
		],
		Example[{Basic, "Edit the values of an already-existing inventory stock solution:"},
			UploadInventory[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID], Status -> Inactive],
			{ObjectP[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID]]}
		],
		Example[{Additional, "Create multiple different new Inventory objects at once:"},
			UploadInventory[{Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID], Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID]}],
			{ObjectP[Object[Inventory, StockSolution]].., ObjectP[Object[Inventory, Product]]..}
		],
		Example[{Additional, "If trying to set the name of an inventory object to one that already exists, add a UUID to the end:"},
			namedInventory=UploadInventory[Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID], Name -> "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID];
			StringMatchQ[Download[namedInventory,Name],"Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID~~__],
			{True..},
			Variables :> {namedInventory}
		],
		Example[{Options, ModelStocked, "Specify the model to be kept in stock by this inventory object:"},
			inventory=UploadInventory[Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID], ModelStocked -> Model[Part, InformationTechnology, "Hard drive Dev5"]];
			Download[inventory, ModelStocked],
			{ObjectP[Model[Part, InformationTechnology, "Hard drive Dev5"]]},
			Variables :> {inventory}
		],
		Example[{Options, ModelStocked, "Automatically set to the ProductModel field, or the first entry in the KitComponents:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site -> Object[Container, Site, "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ModelStocked],
			{
				ObjectP[Model[Item, Column, "HiTrap Q HP 5x5mL Column"]],
				ObjectP[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]]
			},
			Variables :> {inventories}
		],
		Example[{Options, ModelStocked, "Change the ModelStocked to the specified value if operating on an existing inventory object, or resolve to the existing value if left Automatic:"},
			inventories=UploadInventory[
				{
					Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
					Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID]
				},
				ModelStocked -> {
					Model[Sample, "Sodium Chloride Dev3"],
					Automatic
				}
			];
			Download[inventories, ModelStocked],
			{ObjectP[Model[Sample, "Sodium Chloride Dev3"]], ObjectP[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]]},
			Variables :> {inventories}
		],
		Example[{Options, Status, "Set the status of the existing inventory; if unspecified, automatically set to the status to the current status:"},
			inventories=UploadInventory[
				{
					Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
					Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID]
				},
				Status -> {
					Inactive,
					Automatic
				}
			];
			Download[inventories, Status],
			{Inactive, Active},
			Variables :> {inventories}
		],
		Example[{Options, Status, "Set the status of a newly-created inventory; Automatically set to Active:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Status -> {
					Inactive,
					Automatic
				}
			];
			Download[inventories, Status],
			{Inactive, Active},
			Variables :> {inventories}
		],
		Example[{Options, Site, "Set the site at which this inventory should keep samples in stock; automatically set to $Site if not specified:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site -> {
					Automatic,
					Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
				}
			];
			Download[inventories, Site],
			{ObjectP[Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]], ObjectP[Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]]},
			Variables :> {inventories}
		],
		Example[{Options, StockingMethod, "Use the StockingMethod option to specify whether to measure how much is in stock by the total volume or number of unopened containers/items in the lab:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				StockingMethod -> {
					TotalAmount,
					NumberOfStockedContainers
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, StockingMethod],
			{TotalAmount, NumberOfStockedContainers},
			Variables :> {inventories}
		],
		Example[{Options, StockingMethod, "If not specified, StockingMethod is automatically set to TotalAmount if ReorderThreshold or ReorderAmount is set to a mass or amount, or NumberOfStockedContainers if ReorderThreshold or ReorderAmount are set to integers and the object is not reusable:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ReorderThreshold -> {
					3,
					10 Liter
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, StockingMethod],
			{NumberOfStockedContainers, TotalAmount},
			Variables :> {inventories}
		],
		Example[{Options, ReorderThreshold, "Use the ReorderThreshold to indicate the value below which the sample being kept in stock is reordered:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ReorderThreshold -> {
					3,
					10 Liter
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ReorderThreshold],
			{3 Unit, 10 Liter},
			EquivalenceFunction -> Equal,
			Variables :> {inventories}
		],
		Example[{Options, ReorderThreshold, "If left unspecified, automatically set to zero with the appropriate units:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ReorderThreshold],
			{0 Unit, 0 Liter},
			EquivalenceFunction -> Equal,
			Variables :> {inventories}
		],
		Example[{Options, ReorderAmount, "Use the ReorderAmount to indicate the amount that is reordered when the amount of sample falls below ReorderThreshold:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ReorderAmount -> {
					3,
					10 Liter
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ReorderAmount],
			{3 Unit, 10 Liter},
			EquivalenceFunction -> Equal,
			Variables :> {inventories}
		],
		Example[{Options, ReorderAmount, "If left unspecified, automatically set to 1 with the appropriate units, or the TotalVolume of the stock solution if StockingMethod resolves to TotalAmount:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ReorderAmount],
			{1 Unit, 700 Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {inventories}
		],
		Example[{Options, Expires, "Specify whether the samples that are received in the course of automatic reordering have their Expires field set to True:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Expires -> {False, True},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, Expires],
			{False, True},
			Variables :> {inventories}
		],
		Example[{Options, Expires, "If left unspecified, automatically set to True if the model being ordered has Expired set to True, or if ShelfLife or UnsealedShelfLife are populated:"},
			inventories=UploadInventory[
				{
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ModelStocked -> {
					Model[Part, InformationTechnology, "Hard drive Dev5"],
					Automatic
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, Expires],
			{False, True},
			Variables :> {inventories}
		],
		Example[{Options, ShelfLife, "Use the ShelfLife to indicate the length of time after automatically-restocked samples have been received at ECL that they are considered to have expired:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ShelfLife -> {Null, 30 Day},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ShelfLife],
			{Null, 30 Day},
			Variables :> {inventories},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ShelfLife, "If left unspecified, automatically set to the value in the model's ShelfLife field:"},
			inventories=UploadInventory[
				{
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ModelStocked -> {
					Model[Part, InformationTechnology, "Hard drive Dev5"],
					Automatic
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, ShelfLife],
			{Null, 5 Year},
			Variables :> {inventories},
			EquivalenceFunction -> Equal
		],
		Example[{Options, UnsealedShelfLife, "Use the UnsealedShelfLife to indicate the length of time after automatically-restocked samples have been received at ECL that they are considered to have expired:"},
			inventories=UploadInventory[
				{
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				UnsealedShelfLife -> {Null, 30 Day},
				ModelStocked -> {
					Model[Part, InformationTechnology, "Hard drive Dev5"],
					Automatic
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, UnsealedShelfLife],
			{Null, 30 Day},
			Variables :> {inventories},
			EquivalenceFunction -> Equal
		],
		Example[{Options, UnsealedShelfLife, "If left unspecified, automatically set to the value in the model's UnsealedShelfLife field:"},
			inventories=UploadInventory[
				{
					Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				ModelStocked -> {
					Model[Part, InformationTechnology, "Hard drive Dev5"],
					Automatic
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, UnsealedShelfLife],
			{Null, 365 Day},
			Variables :> {inventories},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxNumberOfUses, "Use the MaxNumberOfUses option to specify how many times the sample being kept in stock can be used before it needs to be replaced:"},
			inventory=UploadInventory[Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID], MaxNumberOfUses -> 1000, Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]];
			Download[inventory, MaxNumberOfUses],
			{1000},
			Variables :> {inventory},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxNumberOfUses, "If left unspecified, automatically set to the MaxNumberOfUses field of the model being stocked, or Null if those do not exist:"},
			inventories=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventories, MaxNumberOfUses],
			{200, Null},
			Variables :> {inventories},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxNumberOfHours, "Use the MaxNumberOfHours option to specify how many long the sample being kept in stock can be usLed before it needs to be replaced:"},
			inventory=UploadInventory[Object[Product, "Conventional Product for UploadInventory unit tests 3" <> $SessionUUID], MaxNumberOfHours -> 300 Hour, Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]];
			Download[inventory, MaxNumberOfHours],
			{300 Hour},
			Variables :> {inventory},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxNumberOfHours, "If left unspecified, automatically set to the MaxNumberOfUses field of the model being stocked, or Null if those do not exist:"},
			inventory=UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 3" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			];
			Download[inventory, MaxNumberOfHours],
			{1000 Hour, Null},
			Variables :> {inventory},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Name, "Specify the based of the name of the Inventory objects that are created. The Site at which the inventory is stocked is automatically added for new inventory objects:"},
			NamedObject[
				UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Name -> {
					"New Product Inventory",
					"New StockSolution Inventory"
				},
				Site ->Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			]
			],
			{Object[Inventory, Product, "New Product Inventory"<>" "<>"ECL-2.01 " <> $SessionUUID], Object[Inventory, StockSolution, "New StockSolution Inventory"<>" "<>"ECL-2.01 " <> $SessionUUID]}
		],
		Test["If Upload -> False, return a list of change packets:",
			UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Upload -> False
			],
			{PacketP[Object[Inventory, Product]], PacketP[Object[Inventory, StockSolution]]}
		],
		Test["Use the cache option to pass in packets to circumvent the Download call:",
			UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Cache -> ToList[Download[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]]]
			],
			{ObjectP[Object[Inventory, Product]], ObjectP[Object[Inventory, StockSolution]]}
		],
		Test["Use the Output option to specify whether to return the options, output, tests, or preview:",
			UploadInventory[
				{
					Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
					Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]
				},
				Output -> {Result, Tests, Preview, Options}
			],
			{
				{ObjectP[Object[Inventory, Product]], ObjectP[Object[Inventory, StockSolution]]},
				{TestP..},
				Null,
				{_Rule..}
			}
		],
		Test["When modifying an existing inventory object, only the modified fields are uploaded:",
			UploadInventory[
				Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Status -> Inactive,
				Upload -> False
			],
			{AssociationMatchP[
				<|
					Object -> ObjectReferenceP[Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID]],
					Status -> Inactive
				|>,
				RequireAllKeys -> True,
				AllowForeignKeys -> False
			]},
			Variables :> {inventories},
			SetUp :> {
				Upload[
					<|
						Object -> Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
						Status -> Active
					|>
				]
			}
		],
		(* Messages *)
		Example[{Messages, "DeprecatedProducts", "Cannot create inventories for Deprecated products:"},
			UploadInventory[Object[Product, "Conventional Product for UploadInventory unit tests 4" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::DeprecatedProducts, Error::InvalidInput}
		],
		Example[{Messages, "ModelStockedRequired", "If editing an inventory for a stock solution, ModelStocked must be Null:"},
			UploadInventory[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::ModelStockedRequired, Error::InvalidOption}
		],
		Example[{Messages, "ReorderAmountUpdated", "For existing stock solution inventories, update the ReorderAmount if it is smaller than ReorderThreshold with throwing a warning:"},
			First[Download[
				UploadInventory[
					Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID],
					ReorderThreshold -> 10.1 Liter
				],
				ReorderAmount
			]],
			10.1 Liter,
			EquivalenceFunction -> EqualQ,
			Messages :> {Warning::ReorderAmountUpdated}
		],
		Example[{Messages, "ModelStockedRequired", "If creating an inventory for a stock solution, ModelStocked must be Null:"},
			UploadInventory[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::ModelStockedRequired, Error::InvalidOption}
		],
		Example[{Messages, "ModelStockedNotAllowed", "If creating a new inventory for a product, the ModelStocked must be supplied by the specified product:"},
			UploadInventory[Object[Product, "Kit Product for UploadInventory unit tests 1" <> $SessionUUID], ModelStocked -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::ModelStockedNotAllowed, Error::InvalidOption}
		],
		Example[{Messages, "ModelStockedNotAllowed", "If editing an existing inventory for a product, the ModelStocked must be supplied by the specified product:"},
			UploadInventory[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID], ModelStocked -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::ModelStockedNotAllowed, Error::InvalidOption}
		],
		Example[{Messages, "StockingMethodInvalid", "If StockingMethod is set to NumberOfStockedContainers, ReorderThreshold and ReorderAmount must be set to integer values:"},
			UploadInventory[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID], StockingMethod -> NumberOfStockedContainers, ReorderThreshold -> 5 Milliliter],
			$Failed,
			Messages :> {Error::StockingMethodInvalid, Error::InvalidOption}
		],
		Example[{Messages, "InvalidReorderAmount", "If StockingMethod is set to TotalAmount for an Object[Product] object, ReorderAmount must still be an integer value:"},
			UploadInventory[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID], StockingMethod -> TotalAmount, ReorderAmount -> 105 Milliliter],
			$Failed,
			Messages :> {Error::InvalidReorderAmount, Error::InvalidOption}
		],
		Example[{Messages, "ReorderStateMismatch", "ReorderThreshold and ReorderAmount must be compatible with the state of the samples:"},
			UploadInventory[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID], ReorderThreshold -> 5 Gram],
			$Failed,
			Messages :> {Error::ReorderStateMismatch, Error::InvalidOption}
		],
		Example[{Messages, "LowReorderAmount", "ReorderThreshold and ReorderAmount must be compatible with the state of the samples:"},
			UploadInventory[
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				ReorderAmount -> 10 Milliliter,
				ReorderThreshold -> 20 Milliliter
			],
			$Failed,
			Messages :> {Error::LowReorderAmount, Error::InvalidOption}
		],
		Example[{Messages, "ExpirationDateMismatch", "If Expires is set to True, then either ShelfLife or UnsealedShelfLife must be resolved to a time:"},
			UploadInventory[
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				Expires -> True,
				ShelfLife -> Null,
				UnsealedShelfLife -> Null
			],
			$Failed,
			Messages :> {Error::ExpirationDateMismatch, Error::InvalidOption}
		],
		Example[{Messages, "ExpirationDateMismatch", "If Expires is set to False, then ShelfLife and UnsealedShelfLife cannot be specified:"},
			UploadInventory[
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				Expires -> False,
				ShelfLife -> 1 Year
			],
			$Failed,
			Messages :> {Error::ExpirationDateMismatch, Error::InvalidOption}
		],
		Example[{Messages, "MaxNumberOfUsesInvalid", "MaxNumberOfUses can only be specified for objects that have the MaxNumberOfUses fields:"},
			UploadInventory[
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				MaxNumberOfUses -> 10
			],
			$Failed,
			Messages :> {Error::MaxNumberOfUsesInvalid, Error::InvalidOption}
		],
		Example[{Messages, "MaxNumberOfHoursInvalid", "MaxNumberOfHours can only be specified for objects that have the MaxNumberOfHours fields:"},
			UploadInventory[
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				MaxNumberOfHours -> 10 Hour
			],
			$Failed,
			Messages :> {Error::MaxNumberOfHoursInvalid, Error::InvalidOption}
		],

		(* Site related errors *)
		Example[{Messages, "IndividualSiteRequired", "Site cannot be specified as All when the input is an existing inventory object."},
			UploadInventory[
				Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> All
			],
			$Failed,
			Messages:>{Error::IndividualSiteRequired, Error::InvalidOption}
		],
		Example[{Messages, "InventorySiteNotResolved", "For public products, return an error if All cannot be resolved for Site."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> All
			],
			$Failed,
			Messages:>{Error::InventorySiteNotResolved, Error::InvalidOption},
			Stubs:>{ExternalUpload`Private`allECLSites[___]={}}
		],
		Example[{Messages, "InvalidInventorySite", "The Site option must be a member of ExperimentSites for a private product."},
			UploadInventory[
				Object[Product, "Private Product for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			],
			$Failed,
			Messages:>{Error::InvalidInventorySite, Error::InvalidOption},
			Stubs :> {$Notebook = $Notebook = Object[LaboratoryNotebook, "Test notebook for UploadInventory " <> $SessionUUID]}
		],
		Example[{Messages, "InvalidInventorySite", "The Site option must an ECL facility for public products."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> Object[Container, Site,  "ECL-2.02 " <> $SessionUUID]
			],
			$Failed,
			Messages:>{Error::InvalidInventorySite, Error::InvalidOption}
		],
		Example[{Messages, "AuthorNotFinancerMember", "Throw an error when creating an inventory for a product if $Notebook is Null but $PersonID is not an emerald person."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AuthorNotFinancerMember},
			Stubs :> {$Notebook = Null, $PersonID = Object[User, "Test user for notebook-less test protocols"]}
		],

		Example[{Messages, "AuthorNotFinancerMember", "Throw an error when creating an inventory for a product if $Notebook is not Null but $PersonID is an emerald person."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID]
			],
			$Failed,
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], $PersonID = Object[User, Emerald, "Test emerald person for UploadInventory " <> $SessionUUID]},
			Messages :> {Error::AuthorNotFinancerMember}
		],

		Example[{Messages, "AuthorNotFinancerMember", "Throw an error when creating an inventory for a product if $Notebook does not belong to the user."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AuthorNotFinancerMember},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadInventory " <> $SessionUUID], $PersonID = Object[User, "Test user for notebook-less test protocols"]}
		],

		Example[{Messages, "AuthorNotFinancerMember", "Throw an error when creating an inventory for a private product if the user does not own the product."},
			UploadInventory[
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AuthorNotFinancerMember},
			Stubs :> {
				$Notebook = Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"],
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$Site = Object[Container, Site,  "ECL-2.02 " <> $SessionUUID]
			},
			SetUp :> {
				Upload[<|Object -> Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID], Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for UploadInventory " <> $SessionUUID]]|>]
			},
			TearDown :> {Upload[<|Object -> Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID], Transfer[Notebook] -> Null|>]}
		],

		Example[{Messages, "InventorySiteCannotBeChanged", "The site of an existing inventory cannot be changed."},
			UploadInventory[
				Object[Inventory, Product, "Private Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> Object[Container, Site, "ECL-2.03 " <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InventorySiteCannotBeChanged,
				Error::InvalidOption
			}
		],
		(*this should make a single object for the product's site even though the team has other sites too*)
		Example[{Additional, Site, "Site is automatically resolved for private objects based on Site and Notebook."},
			inventory = UploadInventory[
				Object[Product, "Private Site Specific Product for UploadInventory unit tests 1" <> $SessionUUID],
				Site -> All
			];
			Download[inventory, Site],
			{ObjectP[Object[Container, Site,  "ECL-2.02 " <> $SessionUUID]]},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadInventory " <> $SessionUUID]},
			Variables:>{inventory}
		],
		Example[{Options,StockingMethod,"Resolves to TotalAmount when stocking a product with a reusable model. This will count Stocked and Available items since they are essentially interchangeable:"},
			inventory = UploadInventory[Object[Product, "Reusable Product for UploadInventory unit tests" <> $SessionUUID]];
			Download[inventory, StockingMethod],
			{TotalAmount},
			Variables:>{inventory}
		]
	},
	Stubs:>{$RequiredSearchName = $SessionUUID, $DeveloperSearch = True, $AllowPublicObjects = True, $Site = $site},
	SetUp :> (
		$CreatedObjects={};
		Block[{$AllowPublicObjects = True},
			Upload[{
				<|
					Object->Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Conventional Product Inventory for UploadInventory unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Conventional Product for UploadInventory unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->190 Milliliter,
					Replace[CurrentAmountLog]->{Now,190 Milliliter},
					ReorderThreshold->100 Milliliter,
					Replace[ReorderThresholdLog]->{Now,100 Milliliter},
					OutstandingAmount->0 Milliliter,
					Replace[OutstandingAmountLog]->{Now,0 Milliliter},
					ReorderAmount->2 Unit,
					Replace[ReorderAmountLog]->{Now,2 Unit},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>,
				<|
					Object->Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Kit Product Inventory for UploadInventory unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Kit Product for UploadInventory unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->NumberOfStockedContainers,
					CurrentAmount->4 Unit,
					Replace[CurrentAmountLog]->{Now,4 Unit},
					ReorderThreshold->2 Unit,
					Replace[ReorderThresholdLog]->{Now,2 Unit},
					OutstandingAmount->0 Unit,
					Replace[OutstandingAmountLog]->{Now,0 Unit},
					ReorderAmount->4 Unit,
					Replace[ReorderAmountLog]->{Now,4 Unit},
					Expires->False
				|>,
				<|
					Object->Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Stock Solution Inventory for UploadInventory unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1"<>$SessionUUID], Inventories]},
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->4 Liter,
					Replace[CurrentAmountLog]->{Now,4 Liter},
					ReorderThreshold->5 Liter,
					Replace[ReorderThresholdLog]->{Now,5 Liter},
					OutstandingAmount->2 Liter,
					Replace[OutstandingAmountLog]->{Now,2 Liter},
					ReorderAmount->10 Liter,
					Replace[ReorderAmountLog]->{Now,10 Liter},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>
			}];
			ClearMemoization[allECLSites];
		]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 3" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 4" <> $SessionUUID],
				Object[Product, "Reusable Product for UploadInventory unit tests" <> $SessionUUID],
				Object[Product, "Private Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Site Specific Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Private Site Specific Product for UploadInventory unit tests 1" <> $SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID],
				Model[Part, Lamp, "Stocked Lamp for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Private Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID],
				Object[Container, Site,  "ECL-2.02 " <> $SessionUUID],
				Object[Container, Site,  "ECL-2.03 " <> $SessionUUID],
				Object[LaboratoryNotebook, "Test notebook for UploadInventory "<>$SessionUUID],
				Object[Team, Financing, "Test team for UploadInventory "<>$SessionUUID],
				Object[User, Emerald, "Test emerald person for UploadInventory " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					kitProd1, kitProd2, normalProd1, normalProd2, reusableProduct, ss1, ss2, newSite3, normalProdInventory1,
					kitProdInventory1, ssInventory1, newSite, normalProd3, normalProd4, lamp1, normalProd1Private,
					normalProd1Site, normalProd1PrivateSite, newSite2, privateProdInventory1, notebook, financingTeam,
					counterweight, emeraldPerson
				},

				{
					kitProd1,
					kitProd2,
					normalProd1Private,
					normalProd1Site,
					normalProd1PrivateSite,
					normalProd1,
					normalProd2,
					normalProd3,
					normalProd4,
					reusableProduct,
					ss1,
					ss2,
					lamp1,
					normalProdInventory1,
					privateProdInventory1,
					kitProdInventory1,
					ssInventory1,
					newSite,
					newSite2,
					newSite3,
					notebook,
					financingTeam,
					counterweight,
					emeraldPerson
				} = CreateID[{
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Model[Sample, StockSolution],
					Model[Sample, StockSolution],
					Model[Part, Lamp],
					Object[Inventory, Product],
					Object[Inventory, Product],
					Object[Inventory, Product],
					Object[Inventory, StockSolution],
					Object[Container, Site],
					Object[Container, Site],
					Object[Container, Site],
					Object[LaboratoryNotebook],
					Object[Team, Financing],
					Model[Item, Counterweight],
					Object[User, Emerald]
				}];

				Upload[{
					<|
						Object->lamp1,
						DeveloperObject->True,
						Name->"Stocked Lamp for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Authors]->Link[$PersonID],
						MaxNumberOfHours->1000,
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						MaxLifeTime->2 Year,
						MinWavelength->185 Nanometer,
						MaxWavelength->185 Nanometer,
						LampType->MercuryLamp,
						LampOperationMode->Arc,
						WindowMaterial->SilicateGlass,
						Notebook->Null
					|>,
					<|
						Object->normalProd1Private,
						DeveloperObject->True,
						Name->"Private Product for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Private Product for UploadInventory unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Notebook->Link[notebook, Objects]
					|>,
					<|
						Object->normalProd1Site,
						DeveloperObject->True,
						Name->"Site Specific Product for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Site Specific Product for UploadInventory unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						UsageFrequency->High,
						Amount->50 Milliliter,
						Site->Link[newSite2],
						Notebook->Null
					|>,
					<|
						Object->normalProd1PrivateSite,
						DeveloperObject->True,
						Name->"Private Site Specific Product for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Private Site Specific Product for UploadInventory unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Amount->50 Milliliter,
						Site->Link[newSite2],
						Notebook->Link[notebook, Objects]
					|>,
					<|
						Object->normalProd1,
						DeveloperObject->True,
						Name->"Conventional Product for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventory unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Amount->50 Milliliter,
						Notebook->Null
					|>,
					<|
						Object->normalProd2,
						DeveloperObject->True,
						Name->"Conventional Product for UploadInventory unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventory unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Item, Column, "HiTrap Q HP 5x5mL Column"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x Column",
						NumberOfItems->1,
						Price->1 USD,
						UsageFrequency->High,
						Notebook->Null
					|>,
					<|
						Object->normalProd3,
						DeveloperObject->True,
						Name->"Conventional Product for UploadInventory unit tests 3"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventory unit tests 3"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[lamp1, Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x Lamp",
						NumberOfItems->1,
						Price->1 USD,
						UsageFrequency->High,
						Notebook->Null
					|>,
					<|
						Object->normalProd4,
						DeveloperObject->True,
						Deprecated->True,
						Name->"Conventional Product for UploadInventory unit tests 4"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventory unit tests 4"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[lamp1, Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x Lamp",
						NumberOfItems->1,
						Price->1 USD,
						UsageFrequency->High,
						Notebook->Null
					|>,
					<|
						Object->kitProd1,
						DeveloperObject->True,
						Name->"Kit Product for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for UploadInventory unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						},
						Notebook->Null
					|>,
					<|
						Object->kitProd2,
						DeveloperObject->True,
						Name->"Kit Product for UploadInventory unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for UploadInventory unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						},
						Notebook->Null
					|>,
					<|
						Object->ss1,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for UploadInventory unit tests 1"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[1.234, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[30.1652, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year,
						Notebook->Null
					|>,
					<|
						Object->ss2,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for UploadInventory unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for UploadInventory unit tests 2"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[2.468, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[60.3304, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year,
						Notebook->Null
					|>,
					<|
						Object->normalProdInventory1,
						DeveloperObject->True,
						Name->"Existing Conventional Product Inventory for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[normalProd1, Inventories]},
						ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->TotalAmount,
						CurrentAmount->190 Milliliter,
						Replace[CurrentAmountLog]->{Now,190 Milliliter},
						ReorderThreshold->100 Milliliter,
						Replace[ReorderThresholdLog]->{Now,100 Milliliter},
						OutstandingAmount->0 Milliliter,
						Replace[OutstandingAmountLog]->{Now,0 Milliliter},
						ReorderAmount->2 Unit,
						Replace[ReorderAmountLog]->{Now,2 Unit},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year,
						Notebook->Null
					|>,
					<|
						Object->privateProdInventory1,
						DeveloperObject->True,
						Name->"Private Conventional Product Inventory for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[normalProd1, Inventories]},
						ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite2],
						StockingMethod->TotalAmount,
						CurrentAmount->190 Milliliter,
						Replace[CurrentAmountLog]->{Now,190 Milliliter},
						ReorderThreshold->100 Milliliter,
						Replace[ReorderThresholdLog]->{Now,100 Milliliter},
						OutstandingAmount->0 Milliliter,
						Replace[OutstandingAmountLog]->{Now,0 Milliliter},
						ReorderAmount->2 Unit,
						Replace[ReorderAmountLog]->{Now,2 Unit},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year,
						Notebook->Link[notebook, Objects]
					|>,
					<|
						Object->kitProdInventory1,
						DeveloperObject->True,
						Name->"Existing Kit Product Inventory for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[kitProd1, Inventories]},
						ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->NumberOfStockedContainers,
						CurrentAmount->4 Unit,
						Replace[CurrentAmountLog]->{Now,4 Unit},
						ReorderThreshold->2 Unit,
						Replace[ReorderThresholdLog]->{Now,2 Unit},
						OutstandingAmount->0 Unit,
						Replace[OutstandingAmountLog]->{Now,0 Unit},
						ReorderAmount->4 Unit,
						Replace[ReorderAmountLog]->{Now,4 Unit},
						Expires->False,
						Notebook->Null
					|>,
					<|
						Object->ssInventory1,
						DeveloperObject->True,
						Name->"Existing Stock Solution Inventory for UploadInventory unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[ss1, Inventories]},
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->TotalAmount,
						CurrentAmount->4 Liter,
						Replace[CurrentAmountLog]->{Now,4 Liter},
						ReorderThreshold->5 Liter,
						Replace[ReorderThresholdLog]->{Now,5 Liter},
						OutstandingAmount->2 Liter,
						Replace[OutstandingAmountLog]->{Now,2 Liter},
						ReorderAmount->10 Liter,
						Replace[ReorderAmountLog]->{Now,10 Liter},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year,
						Notebook->Null
					|>,
					<|
						Object->newSite,
						Model->Link[$Site[Model][Object], Objects],
						DeveloperObject->True,
						Name->"ECL-2.01 "<>$SessionUUID,
						StreetAddress->"15500.01 Wells Port Dr",
						City->"Austin",
						State->"TX",
						PostalCode->"78728",
						PhoneNumber->"737-285-4911",
						EmeraldFacility->True,
						Notebook->Null
					|>,
					<|
						Object->newSite2,
						Model->Link[$Site[Model][Object], Objects],
						DeveloperObject->True,
						Name->"ECL-2.02 "<>$SessionUUID,
						StreetAddress->"15500.01 Wells Port Dr",
						City->"Austin",
						State->"TX",
						PhoneNumber->"737-285-4911",
						EmeraldFacility->False,
						Notebook->Null
					|>,
					<|
						Object->newSite3,
						Model->Link[$Site[Model][Object], Objects],
						DeveloperObject->True,
						Name->"ECL-2.03 "<>$SessionUUID,
						StreetAddress->"15500.01 Wells Port Dr",
						City->"Austin",
						State->"TX",
						PhoneNumber->"737-285-4911",
						EmeraldFacility->False,
						Notebook->Null
					|>,
					<|
						Object->notebook,
						Name->"Test notebook for UploadInventory "<>$SessionUUID,
						Replace[Financers]->Link[financingTeam, NotebooksFinanced]
					|>,
					<|
						Object->financingTeam,
						Name->"Test team for UploadInventory "<>$SessionUUID,
						Replace[ExperimentSites]->(Link[#, FinancingTeams]&/@{newSite2, newSite3}),
						Notebook->Null
					|>,
					<|
						Object->counterweight,
						DeveloperObject->True,
						Replace[Authors]->Link[$PersonID],
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						Notebook->Null,
						Reusable->True
					|>,
					<|
						Object->reusableProduct,
						DeveloperObject->True,
						Name-> "Reusable Product for UploadInventory unit tests" <> $SessionUUID,
						Replace[Synonyms]->{"Reusable Product for UploadInventory unit tests" <> $SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[counterweight, Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 weight",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Notebook->Null
					|>,
					<|
						Object -> emeraldPerson,
						Name -> "Test emerald person for UploadInventory " <> $SessionUUID,
						DeveloperObject -> True
					|>
				}];
				$site = newSite;
			]];
	),
	SymbolTearDown :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Kit Product for UploadInventory unit tests 2" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 2" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 3" <> $SessionUUID],
				Object[Product, "Conventional Product for UploadInventory unit tests 4" <> $SessionUUID],
				Object[Product, "Private Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Site Specific Product for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Product, "Private Site Specific Product for UploadInventory unit tests 1" <> $SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 1" <> $SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventory unit tests 2" <> $SessionUUID],
				Model[Part, Lamp, "Stocked Lamp for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, Product, "Private Conventional Product Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventory unit tests 1" <> $SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID],
				Object[Container, Site,  "ECL-2.02 " <> $SessionUUID],
				Object[Container, Site, "ECL-2.03 " <> $SessionUUID],
				Object[LaboratoryNotebook, "Test notebook for UploadInventory "<>$SessionUUID],
				Object[Team, Financing, "Test team for UploadInventory "<>$SessionUUID],
				Object[Product, "Reusable Product for UploadInventory unit tests" <> $SessionUUID],
				Object[User, Emerald, "Test emerald person for UploadInventory " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
	)

];


(* ::Subsection::Closed:: *)
(*UploadInventoryOptions*)

DefineTests[
	UploadInventoryOptions,
	{
		Example[{Basic, "Create an Inventory object for the automatic reordering of a kit product:"},
			UploadInventoryOptions[Object[Product, "Kit Product for UploadInventoryOptions unit tests 2"<>$SessionUUID], ModelStocked -> Model[Part, InformationTechnology, "Hard drive Dev5"], OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic]]..}
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a non-kit product:"},
			UploadInventoryOptions[Object[Product, "Conventional Product for UploadInventoryOptions unit tests 2"<>$SessionUUID], OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic]]..}
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a stock solution:"},
			UploadInventoryOptions[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 2"<>$SessionUUID], OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic]]..}
		],
		Example[{Basic, "Edit the values of an already-existing inventory object:"},
			UploadInventoryOptions[Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID], ReorderThreshold -> 200 Milliliter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic]]..}
		],
		Example[{Basic, "Edit the values of an already-existing inventory stock solution:"},
			UploadInventoryOptions[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID], Status -> Inactive, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic]]..}
		],
		Example[{Options, OutputFormat, "Return a grid of resolved options instead of a list of options:"},
			UploadInventoryOptions[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID], Status -> Inactive, OutputFormat -> Table],
			_Grid
		]
	},
	Stubs:>{$RequiredSearchName = $SessionUUID, $DeveloperSearch = True, $AllowPublicObjects = True, $Site = $site},
	SetUp :> (
		$CreatedObjects={};
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Upload[{
				<|
					Object->Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Conventional Product for UploadInventoryOptions unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->190 Milliliter,
					Replace[CurrentAmountLog]->{Now,190 Milliliter},
					ReorderThreshold->100 Milliliter,
					Replace[ReorderThresholdLog]->{Now,100 Milliliter},
					OutstandingAmount->0 Milliliter,
					Replace[OutstandingAmountLog]->{Now,0 Milliliter},
					ReorderAmount->2 Unit,
					Replace[ReorderAmountLog]->{Now,2 Unit},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>,
				<|
					Object->Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Kit Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Kit Product for UploadInventoryOptions unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->NumberOfStockedContainers,
					CurrentAmount->4 Unit,
					Replace[CurrentAmountLog]->{Now,4 Unit},
					ReorderThreshold->2 Unit,
					Replace[ReorderThresholdLog]->{Now,2 Unit},
					OutstandingAmount->0 Unit,
					Replace[OutstandingAmountLog]->{Now,0 Unit},
					ReorderAmount->4 Unit,
					Replace[ReorderAmountLog]->{Now,4 Unit},
					Expires->False
				|>,
				<|
					Object->Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 1"<>$SessionUUID], Inventories]},
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site, "ECL-2.01 "<>$SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->4 Liter,
					Replace[CurrentAmountLog]->{Now,4 Liter},
					ReorderThreshold->5 Liter,
					Replace[ReorderThresholdLog]->{Now,5 Liter},
					OutstandingAmount->2 Liter,
					Replace[OutstandingAmountLog]->{Now,2 Liter},
					ReorderAmount->10 Liter,
					Replace[ReorderAmountLog]->{Now,10 Liter},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>
			}]]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Product, "Kit Product for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Object[Product, "Conventional Product for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Product, "Conventional Product for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{kitProd1, kitProd2, normalProd1, normalProd2, ss1, ss2, normalProdInventory1, kitProdInventory1, ssInventory1, newSite},

				{
					kitProd1,
					kitProd2,
					normalProd1,
					normalProd2,
					ss1,
					ss2,
					normalProdInventory1,
					kitProdInventory1,
					ssInventory1,
					newSite
				} = CreateID[{
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Model[Sample, StockSolution],
					Model[Sample, StockSolution],
					Object[Inventory, Product],
					Object[Inventory, Product],
					Object[Inventory, StockSolution],
					Object[Container, Site]
				}];

				Upload[{
					<|
						Object->normalProd1,
						DeveloperObject->True,
						Name->"Conventional Product for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventoryOptions unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Amount->50 Milliliter
					|>,
					<|
						Object->normalProd2,
						DeveloperObject->True,
						Name->"Conventional Product for UploadInventoryOptions unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for UploadInventoryOptions unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Item, Column, "HiTrap Q HP 5x5mL Column"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x Column",
						NumberOfItems->1,
						Price->1 USD,
						UsageFrequency->High
					|>,
					<|
						Object->kitProd1,
						DeveloperObject->True,
						Name->"Kit Product for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for UploadInventoryOptions unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						}
					|>,
					<|
						Object->kitProd2,
						DeveloperObject->True,
						Name->"Kit Product for UploadInventoryOptions unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for UploadInventoryOptions unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						}
					|>,
					<|
						Object->ss1,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for UploadInventoryOptions unit tests 1"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[1.234, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[30.1652, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year
					|>,
					<|
						Object->ss2,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for UploadInventoryOptions unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for UploadInventoryOptions unit tests 2"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[2.468, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[60.3304, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year
					|>,
					<|
						Object->normalProdInventory1,
						DeveloperObject->True,
						Name->"Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[normalProd1, Inventories]},
						ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->TotalAmount,
						CurrentAmount->190 Milliliter,
						Replace[CurrentAmountLog]->{Now,190 Milliliter},
						ReorderThreshold->100 Milliliter,
						Replace[ReorderThresholdLog]->{Now,100 Milliliter},
						OutstandingAmount->0 Milliliter,
						Replace[OutstandingAmountLog]->{Now,0 Milliliter},
						ReorderAmount->2 Unit,
						Replace[ReorderAmountLog]->{Now,2 Unit},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year
					|>,
					<|
						Object->kitProdInventory1,
						DeveloperObject->True,
						Name->"Existing Kit Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[kitProd1, Inventories]},
						ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->NumberOfStockedContainers,
						CurrentAmount->4 Unit,
						Replace[CurrentAmountLog]->{Now,4 Unit},
						ReorderThreshold->2 Unit,
						Replace[ReorderThresholdLog]->{Now,2 Unit},
						OutstandingAmount->0 Unit,
						Replace[OutstandingAmountLog]->{Now,0 Unit},
						ReorderAmount->4 Unit,
						Replace[ReorderAmountLog]->{Now,4 Unit},
						Expires->False
					|>,
					<|
						Object->ssInventory1,
						DeveloperObject->True,
						Name->"Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[ss1, Inventories]},
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->TotalAmount,
						CurrentAmount->4 Liter,
						Replace[CurrentAmountLog]->{Now,4 Liter},
						ReorderThreshold->5 Liter,
						Replace[ReorderThresholdLog]->{Now,5 Liter},
						OutstandingAmount->2 Liter,
						Replace[OutstandingAmountLog]->{Now,2 Liter},
						ReorderAmount->10 Liter,
						Replace[ReorderAmountLog]->{Now,10 Liter},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year
					|>,
					<|
						Object->newSite,
						Model->Link[$Site[Model][Object], Objects],
						DeveloperObject->True,
						Name->"ECL-2.01 "<>$SessionUUID,
						StreetAddress->"15500.01 Wells Port Dr",
						City->"Austin",
						State->"TX",
						PhoneNumber->"737-285-4911",
						EmeraldFacility->True
					|>
				}];
				$site = newSite;
			]];
	),
	SymbolTearDown :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Product, "Kit Product for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Object[Product, "Conventional Product for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Product, "Conventional Product for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for UploadInventoryOptions unit tests 2"<>$SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for UploadInventoryOptions unit tests 1"<>$SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
	)

];


(* ::Subsection::Closed:: *)
(*ValidUploadInventoryQ*)

DefineTests[
	ValidUploadInventoryQ,
	{
		Example[{Basic, "Create an Inventory object for the automatic reordering of a kit product:"},
			ValidUploadInventoryQ[Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID], ModelStocked -> Model[Part, InformationTechnology, "Hard drive Dev5"]],
			True
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a non-kit product:"},
			ValidUploadInventoryQ[Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID]],
			True
		],
		Example[{Basic, "Create an Inventory object for the automatic reordering of a stock solution:"},
			ValidUploadInventoryQ[Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID]],
			True
		],
		Example[{Basic, "Edit the values of an already-existing inventory object:"},
			ValidUploadInventoryQ[Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ReorderThreshold -> 200 Milliliter],
			True
		],
		Example[{Basic, "Edit the values of an already-existing inventory stock solution:"},
			ValidUploadInventoryQ[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], Status -> Inactive],
			True
		],
		Example[{Options, Verbose, "Indicate how failures should be displayed:"},
			ValidUploadInventoryQ[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID], Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "Control the return value of the validity-checking function:"},
			ValidUploadInventoryQ[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "ModelStockedRequired", "If editing an inventory for a stock solution, ModelStocked must be Null:"},
			ValidUploadInventoryQ[Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID]],
			False
		],
		Example[{Messages, "ModelStockedRequired", "If creating an inventory for a stock solution, ModelStocked must be Null:"},
			ValidUploadInventoryQ[Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID], ModelStocked -> Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID]],
			False
		],
		Example[{Messages, "ModelStockedNotAllowed", "If creating a new inventory for a product, the ModelStocked must be supplied by the specified product:"},
			ValidUploadInventoryQ[Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ModelStocked -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "ModelStockedNotAllowed", "If editing an existing inventory for a product, the ModelStocked must be supplied by the specified product:"},
			ValidUploadInventoryQ[Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ModelStocked -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "StockingMethodInvalid", "If StockingMethod is set to NumberOfStockedContainers, ReorderThreshold and ReorderAmount must be set to integer values:"},
			ValidUploadInventoryQ[Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], StockingMethod -> NumberOfStockedContainers, ReorderThreshold -> 5 Milliliter],
			False
		],
		Example[{Messages, "StockingMethodInvalid", "If StockingMethod is set to TotalAmount for an Object[Product] object, ReorderAmount must still be an integer value:"},
			ValidUploadInventoryQ[Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], StockingMethod -> TotalAmount, ReorderAmount -> 5 Milliliter],
			False
		],
		Example[{Messages, "ReorderStateMismatch", "ReorderThreshold and ReorderAmount must be compatible with the state of the samples:"},
			ValidUploadInventoryQ[Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], ReorderThreshold -> 5 Gram],
			False
		],
		Example[{Messages, "ExpirationDateMismatch", "If Expires is set to True, then either ShelfLife or UnsealedShelfLife must be resolved to a time:"},
			ValidUploadInventoryQ[
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Expires -> True,
				ShelfLife -> Null,
				UnsealedShelfLife -> Null
			],
			False
		],
		Example[{Messages, "ExpirationDateMismatch", "If Expires is set to False, then ShelfLife and UnsealedShelfLife cannot be specified:"},
			ValidUploadInventoryQ[
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Expires -> False,
				ShelfLife -> 1 Year
			],
			False
		],
		Example[{Messages, "MaxNumberOfUsesInvalid", "MaxNumberOfUses can only be specified for objects that have the MaxNumberOfUses fields:"},
			ValidUploadInventoryQ[
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				MaxNumberOfUses -> 10
			],
			False
		]
	},
	Stubs:>{$RequiredSearchName = $SessionUUID, $DeveloperSearch = True, $AllowPublicObjects = True, $Site = $site},
	SetUp :> (
		$CreatedObjects={};
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Upload[{
				<|
					Object->Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->190 Milliliter,
					Replace[CurrentAmountLog]->{Now,190 Milliliter},
					ReorderThreshold->100 Milliliter,
					Replace[ReorderThresholdLog]->{Now,100 Milliliter},
					OutstandingAmount->0 Milliliter,
					Replace[OutstandingAmountLog]->{Now,0 Milliliter},
					ReorderAmount->2 Unit,
					Replace[ReorderAmountLog]->{Now,2 Unit},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>,
				<|
					Object->Object[Inventory, Product, "Existing Kit Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Kit Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], Inventories]},
					ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]],
					StockingMethod->NumberOfStockedContainers,
					CurrentAmount->4 Unit,
					Replace[CurrentAmountLog]->{Now,4 Unit},
					ReorderThreshold->2 Unit,
					Replace[ReorderThresholdLog]->{Now,2 Unit},
					OutstandingAmount->0 Unit,
					Replace[OutstandingAmountLog]->{Now,0 Unit},
					ReorderAmount->4 Unit,
					Replace[ReorderAmountLog]->{Now,4 Unit},
					Expires->False
				|>,
				<|
					Object->Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
					DeveloperObject->True,
					Name->"Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
					Replace[StockedInventory]->{Link[Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID], Inventories]},
					Status->Active,
					Author->Link[$PersonID],
					DateCreated->Now,
					Site->Link[Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]],
					StockingMethod->TotalAmount,
					CurrentAmount->4 Liter,
					Replace[CurrentAmountLog]->{Now,4 Liter},
					ReorderThreshold->5 Liter,
					Replace[ReorderThresholdLog]->{Now,5 Liter},
					OutstandingAmount->2 Liter,
					Replace[OutstandingAmountLog]->{Now,2 Liter},
					ReorderAmount->10 Liter,
					Replace[ReorderAmountLog]->{Now,10 Liter},
					Expires->True,
					ShelfLife->4 Year,
					UnsealedShelfLife->0.5 Year
				|>
			}]]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{kitProd1, kitProd2, normalProd1, normalProd2, ss1, ss2, normalProdInventory1, kitProdInventory1, ssInventory1, newSite},

				{
					kitProd1,
					kitProd2,
					normalProd1,
					normalProd2,
					ss1,
					ss2,
					normalProdInventory1,
					kitProdInventory1,
					ssInventory1,
					newSite
				} = CreateID[{
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Model[Sample, StockSolution],
					Model[Sample, StockSolution],
					Object[Inventory, Product],
					Object[Inventory, Product],
					Object[Inventory, StockSolution],
					Object[Container, Site]
				}];

				Upload[{
					<|
						Object->normalProd1,
						DeveloperObject->True,
						Name->"Conventional Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x 50. mL Bottle",
						NumberOfItems->1,
						DefaultContainerModel->Link[Model[Container, Vessel, "id:pZx9jon4RV0P"], ProductsContained],
						Price->1 USD,
						UsageFrequency->High,
						Amount->50 Milliliter
					|>,
					<|
						Object->normalProd2,
						DeveloperObject->True,
						Name->"Conventional Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Conventional Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						ProductModel->Link[Model[Item, Column, "HiTrap Q HP 5x5mL Column"], Products],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						CatalogDescription->"1 x Column",
						NumberOfItems->1,
						Price->1 USD,
						UsageFrequency->High
					|>,
					<|
						Object->kitProd1,
						DeveloperObject->True,
						Name->"Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						}
					|>,
					<|
						Object->kitProd2,
						DeveloperObject->True,
						Name->"Kit Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Kit Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID},
						Author->Link[$PersonID],
						Supplier->Link[Object[Company, Supplier, "Supplier Dev4"], Products],
						CatalogNumber->"123",
						Price->100 USD,
						UsageFrequency->VeryLow,
						Replace[KitComponents]->{
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[1.5, "Milliliters"],
								Position->"A1",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Sample, "Sodium Chloride Dev3"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
								Amount->Quantity[14, "Milligrams"],
								Position->"A2",
								ContainerIndex->1,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->3,
								ProductModel->Link[Model[Sample, "Test Model[Sample] 1 from DropShipping for MaintenanceReceiveInventory unit tests"], KitProducts],
								DefaultContainerModel->Link[Model[Container, Vessel, "2mL Tube"]],
								Amount->Quantity[1, "Milliliters"],
								Position->"A1",
								ContainerIndex->2,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>,
							<|
								NumberOfItems->1,
								ProductModel->Link[Model[Part, InformationTechnology, "Hard drive Dev5"], KitProducts],
								DefaultContainerModel->Null,
								Amount->Null,
								Position->Null,
								ContainerIndex->Null,
								DefaultCoverModel->Null,
								OpenContainer->Null
							|>
						}
					|>,
					<|
						Object->ss1,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[1.234, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[30.1652, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year
					|>,
					<|
						Object->ss2,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Name->"Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID,
						Replace[Synonyms]->{"Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID},
						State->Liquid,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[Formula]->{
							{Quantity[2.468, "Grams"], Link[Model[Sample, "Sodium Chloride"]]}
						},
						FillToVolumeSolvent->Link[Model[Sample, "Milli-Q water"]],
						TotalVolume->700 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[Composition]->{
							{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[60.3304, "Millimolar"], Link[Model[Molecule, "id:BYDOjvG676mq"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition, Incubation, FillToVolume},
						Replace[Autoclave]->False,
						Replace[AutoclaveProgram]->Null,
						MixTime->30 Minute,
						Replace[Synonyms]->{},
						Replace[IncompatibleMaterials]->{None},
						DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
						ShelfLife->5 Year,
						Expires->True,
						UnsealedShelfLife->365 Day,
						ShelfLife->5 Year
					|>,
					<|
						Object->normalProdInventory1,
						DeveloperObject->True,
						Name->"Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[normalProd1, Inventories]},
						ModelStocked->Link[Model[Sample, "Test HFIP model for MaintenanceReceiveInventory unit tests"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[newSite],
						StockingMethod->TotalAmount,
						CurrentAmount->190 Milliliter,
						Replace[CurrentAmountLog]->{Now,190 Milliliter},
						ReorderThreshold->100 Milliliter,
						Replace[ReorderThresholdLog]->{Now,100 Milliliter},
						OutstandingAmount->0 Milliliter,
						Replace[OutstandingAmountLog]->{Now,0 Milliliter},
						ReorderAmount->2 Unit,
						Replace[ReorderAmountLog]->{Now,2 Unit},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year
					|>,
					<|
						Object->kitProdInventory1,
						DeveloperObject->True,
						Name->"Existing Kit Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[kitProd1, Inventories]},
						ModelStocked->Link[Model[Part, InformationTechnology, "Hard drive Dev5"]],
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[$Site],
						StockingMethod->NumberOfStockedContainers,
						CurrentAmount->4 Unit,
						Replace[CurrentAmountLog]->{Now,4 Unit},
						ReorderThreshold->2 Unit,
						Replace[ReorderThresholdLog]->{Now,2 Unit},
						OutstandingAmount->0 Unit,
						Replace[OutstandingAmountLog]->{Now,0 Unit},
						ReorderAmount->4 Unit,
						Replace[ReorderAmountLog]->{Now,4 Unit},
						Expires->False
					|>,
					<|
						Object->ssInventory1,
						DeveloperObject->True,
						Name->"Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID,
						Replace[StockedInventory]->{Link[ss1, Inventories]},
						Status->Active,
						Author->Link[$PersonID],
						DateCreated->Now,
						Site->Link[$Site],
						StockingMethod->TotalAmount,
						CurrentAmount->4 Liter,
						Replace[CurrentAmountLog]->{Now,4 Liter},
						ReorderThreshold->5 Liter,
						Replace[ReorderThresholdLog]->{Now,5 Liter},
						OutstandingAmount->2 Liter,
						Replace[OutstandingAmountLog]->{Now,2 Liter},
						ReorderAmount->10 Liter,
						Replace[ReorderAmountLog]->{Now,10 Liter},
						Expires->True,
						ShelfLife->4 Year,
						UnsealedShelfLife->0.5 Year
					|>,
					<|
						Object->newSite,
						Model->Link[$Site[Model][Object], Objects],
						DeveloperObject->True,
						Name->"ECL-2.01 "<>$SessionUUID,
						StreetAddress->"15500.01 Wells Port Dr",
						City->"Austin",
						State->"TX",
						PhoneNumber->"737-285-4911",
						EmeraldFacility->True
					|>
				}];
				$site = newSite;
			]];
	),
	SymbolTearDown :> (
		Module[{allObjs, existingObjs},

			allObjs={
				Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Product, "Kit Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Product, "Conventional Product for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Model[Sample, StockSolution, "Stocked Salt Solution for ValidUploadInventoryQ unit tests 2"<>$SessionUUID],
				Object[Inventory, Product, "Existing Conventional Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Inventory, Product, "Existing Kit Product Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Inventory, StockSolution, "Existing Stock Solution Inventory for ValidUploadInventoryQ unit tests 1"<>$SessionUUID],
				Object[Container, Site,  "ECL-2.01 " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
	)

];

(* ::Subsection::Closed:: *)
(*UploadCompanyService*)


(* ::Subsubsection::Closed:: *)
(*UploadCompanyService*)


DefineTests[UploadCompanyService,
	{
		Example[{Basic, "Create a new company that provides service on custom-made samples:"},
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			ObjectP[Object[Company, Service]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		Example[{Basic, "Create a new company and provide only the Website information:"},
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			ObjectP[Object[Company, Service]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		(* --- options --- *)
		Example[{Options, Phone, "Specify the contact phone number of the company:"},
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354"
			],
			ObjectP[Object[Company, Service]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		Example[{Options, Website, "Specify the website of the company:"},
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			ObjectP[Object[Company, Service]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		Example[{Options, OutOfBusiness, "If the company does not longer provide the service, specify OutofBusiness to True:"},
			UploadCompanyService["non-existing company",
				Phone -> "123-123-1111",
				OutOfBusiness -> True
			],
			ObjectP[Object[Company, Service]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "non-existing company"]],
					EraseObject[Object[Company, Service, "non-existing company"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "non-existing company"]],
					EraseObject[Object[Company, Service, "non-existing company"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"non-existing company\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		Example[{Options, PreferredContainers, "Specify the know container model that this company tends to ship the samples they supply in:"},
			company=UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				PreferredContainers -> {Model[Container, Vessel, "Cryo Tube-2 mL Nunc"]}
			];
			Download[company, PreferredContainers],
			{ObjectP[Model[Container, Vessel, "Cryo Tube-2 mL Nunc"]]},
			Variables :> {
				company
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		Example[{Options, CustomSynthesizes, "Specify the custom-made sample that this company provides for customers:"},
			company=UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				CustomSynthesizes -> {Model[Sample, "Custom-synthesized DNA Oligomer- Example"]}
			];
			Download[company, CustomSynthesizes],
			{ObjectP[Model[Sample, "Custom-synthesized DNA Oligomer- Example"]]},
			Variables :> {
				company
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		],
		(* --- Messages --- *)
		Example[{Messages, "CompanyNameAlreadyExists", "If the name of the company is used, return an error:"},
			UploadCompanyService["Existing Company -Example",
				Phone -> "123-123-1111"
			],
			$Failed,
			Messages :> {
				Error::InvalidInput,
				Error::CompanyNameAlreadyExists
			},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Messages, "UnderspecifiedInformation", "Website or contact phone number should be provided:"},
			UploadCompanyService["Test Company -Example 2"],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::UnderspecifiedInformation
			}
		],

		Example[{Messages, "ObjectDoesNotExist", "If the provided object does not exist in the database, return an error:"},
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				CustomSynthesizes -> {Model[Sample, "Non-existing DNA Oligomer- Example"]}
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::ObjectDoesNotExist
			}
		],
		Test["If the provided PreferredContainer does not exist in the database, return an error:",
			UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				PreferredContainers -> {Model[Container, Vessel, "Non-existing vessel"]}
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::ObjectDoesNotExist
			}
		],
		Test["The newly-created object pass VOQ:",
			company=UploadCompanyService["Thermofisher - Example for UploadCompanyService",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			];
			ValidObjectQ[company],
			True,
			Variables :> {
				company
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"]],
					EraseObject[Object[Company, Service, "Thermofisher - Example for UploadCompanyService"], Force -> True, Verbose -> False],
					Print["The following object: Object[Company,Service,\"Thermofisher - Example for UploadCompanyService\"] does not exist in the database. Please check the test result"]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadCompanyServiceOptions*)


DefineTests[UploadCompanyServiceOptions,
	{
		Example[{Basic, "Return the reolved options when creating a new company that provides service on custom-made samples:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Return the reolved options when creating a new company and provide only the Website information:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		(* --- options --- *)
		Example[{Options, Phone, "Specify the contact phone number of the company:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, Website, "Specify the website of the company:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutOfBusiness, "If the company does not longer provide the service, specify OutofBusiness to True:"},
			UploadCompanyServiceOptions["non-existing company",
				Phone -> "123-123-1111",
				OutOfBusiness -> True,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, PreferredContainers, "Specify the know container model that this company tends to ship the samples they supply in:"},
			Lookup[UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				PreferredContainers -> {Model[Container, Vessel, "Cryo Tube-2 mL Nunc"]},
				OutputFormat -> List
			], PreferredContainers],
			{ObjectP[Model[Container, Vessel, "Cryo Tube-2 mL Nunc"]]}
		],
		Example[{Options, CustomSynthesizes, "Specify the custom-made sample that this company provides for customers:"},
			Lookup[UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				CustomSynthesizes -> {Model[Sample, "Custom-synthesized DNA Oligomer- Example"]},
				OutputFormat -> List
			], CustomSynthesizes],
			{ObjectP[Model[Sample, "Custom-synthesized DNA Oligomer- Example"]]}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table form:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			Graphics_
		],
		(* --- Messages --- *)
		Example[{Messages, "CompanyNameAlreadyExists", "If the name of the company is used, return an error:"},
			UploadCompanyServiceOptions["Existing Company -Example",
				Phone -> "123-123-1111",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::InvalidInput,
				Error::CompanyNameAlreadyExists
			},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Messages, "UnderspecifiedInformation", "Website or contact phone number should be provided:"},
			UploadCompanyServiceOptions["Test Company -Example 2", OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::InvalidOption,
				Error::UnderspecifiedInformation
			}
		],

		Example[{Messages, "ObjectDoesNotExist", "If the provided object does not exist in the database, return an error:"},
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				CustomSynthesizes -> {Model[Sample, "Non-existing DNA Oligomer- Example"]},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::InvalidOption,
				Error::ObjectDoesNotExist
			}
		],
		Test["If the provided PreferredContainer does not exist in the database, return an error:",
			UploadCompanyServiceOptions["Thermofisher - Example for UploadCompanyServiceOptions",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				PreferredContainers -> {Model[Container, Vessel, "Non-existing vessel"]},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::InvalidOption,
				Error::ObjectDoesNotExist
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCompanyServiceQ*)


DefineTests[ValidUploadCompanyServiceQ,
	{
		Example[{Basic, "Return the reolved options when creating a new company that provides service on custom-made samples:"},
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			True
		],
		Example[{Basic, "Return the reolved options when creating a new company and provide only the Website information:"},
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Website -> "https://www.thermofisher.com/us/en/home.html"
			],
			True
		],
		(* --- Options --- *)
		Example[{Options, Verbose, "Specify verbose when calling ValidUploadCompanyServiceQ:"},
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				Verbose -> True
			],
			True
		],
		Example[{Options, OutputFormat, "Specify OuputFormat when calling ValidUploadCompanyServiceQ:"},
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		(* --- Messages --- *)
		Example[{Messages, "CompanyNameAlreadyExists", "If the name of the company is used, return an error:"},
			ValidUploadCompanyServiceQ["Existing Company -Example",
				Phone -> "123-123-1111"
			],
			False,
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Messages, "UnderspecifiedInformation", "Website or contact phone number should be provided:"},
			ValidUploadCompanyServiceQ["Test Company -Example"],
			False
		],

		Example[{Messages, "ObjectDoesNotExist", "If the provided object does not exist in the database, return an error:"},
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				CustomSynthesizes -> {Model[Sample, "Non-existing DNA Oligomer- Example"]}
			],
			False
		],
		Test["If the provided PreferredContainer does not exist in the database, return an error:",
			ValidUploadCompanyServiceQ["Thermofisher - Example for ValidUploadCompanyServiceQ",
				Phone -> "866-356-0354",
				Website -> "https://www.thermofisher.com/us/en/home.html",
				PreferredContainers -> {Model[Container, Vessel, "Non-existing vessel"]}
			],
			False,
			Stubs :> {
				$DeveloperSearch=True
			}
		]
	}
];


(* ::Subsection::Closed:: *)
(*UploadLiterature*)


(* ::Subsubsection::Closed:: *)
(*UploadLiterature*)


With[
	{
		(* The following are free journal article PDFs from online. *)
		goodFile1="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930981/pdf/nihms157057.pdf",
		goodFile2="http://cancerres.aacrjournals.org/content/canres/69/13/5475.full.pdf",

		(* Download the EndNote 8 XML file from PNAS and get the path of the downloaded file. *)
		goodXMLFile=Quiet[URLDownload["http://www.pnas.org/highwire/citation/61798/endnote-8-xml", FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".xml"}]][[1]]]
	},
	DefineTests[
		UploadLiterature,
		{
			Example[
				{Basic, "Parse a single PubMed Object to create an Object[Report,Literature]:"},
				UploadLiterature[PubMed[17322918], DocumentType -> JournalArticle],
				Object[Report, Literature, "id:J8AY5jDwLplK"],
				Stubs :> {UploadLiterature[PubMed[17322918], DocumentType -> JournalArticle]=Object[Report, Literature, "id:J8AY5jDwLplK"]}
			],
			Example[
				{Basic, "Parse a single reference, whose fields have already been read in from an EndNote XML database:"},
				UploadLiterature[{"ref-type" -> {"Book"}, "author" -> {"Victor Bloomfield;", "Donald Crothers;", "Tinoco Ignacio"}, "auth-address" -> {}, "title" -> {"Nucleic Acids: Structures, Properties, and Functions"}, "full-title" -> {}, "pages" -> {}, "SampleVolume" -> {}, "number" -> {}, "edition" -> {}, "keyword" -> {}, "date" -> {}, "year" -> {"2000"}, "isbn" -> {}, "accession-num" -> {}, "abstract" -> {}, "notes" -> {}, "url" -> {}, "electronic-resource-num" -> {}, "pub-location" -> {"Sausalito, CA"}, "publisher" -> {"University Science Books"}, "section" -> {}, "pdf-urls" -> {}, "research-notes" -> {}}],
				Object[Report, Literature, "id:3em6ZvL9EkJW"],
				Stubs :> {UploadLiterature[{"ref-type" -> {"Book"}, "author" -> {"Victor Bloomfield;", "Donald Crothers;", "Tinoco Ignacio"}, "auth-address" -> {}, "title" -> {"Nucleic Acids: Structures, Properties, and Functions"}, "full-title" -> {}, "pages" -> {}, "SampleVolume" -> {}, "number" -> {}, "edition" -> {}, "keyword" -> {}, "date" -> {}, "year" -> {"2000"}, "isbn" -> {}, "accession-num" -> {}, "abstract" -> {}, "notes" -> {}, "url" -> {}, "electronic-resource-num" -> {}, "pub-location" -> {"Sausalito, CA"}, "publisher" -> {"University Science Books"}, "section" -> {}, "pdf-urls" -> {}, "research-notes" -> {}}]=Object[Report, Literature, "id:3em6ZvL9EkJW"]}
			],
			Example[
				{Basic, "Upload an Object[Report,Literature] manually, not using any automatic parsing:"},
				UploadLiterature[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				Object[Report, Literature, "id:N80DNj1lPq6D"],
				Stubs :> {UploadLiterature[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"]=Object[Report, Literature, "id:N80DNj1lPq6D"]}
			],

			(* In the following option examples, we always give the user the result as a Grid for ease of reading. However, the real test outputs as a List for easier checking. *)
			Example[
				{Options, LiteratureFiles, "Indicate any additional files that should be included in the literature report. These files can be links to online PDF files or local PDF files:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}],
				_Grid
			],
			Test[
				"Indicate any additional files that should be included in the literature report. These files can be links to online PDF files or local PDF files:",
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, OutputFormat -> List],
				{
					Edition -> Null,
					Title -> "The Bcl-2 apoptotic switch in cancer development and therapy.",
					ContactInformation -> "Department of Molecular Genetics of Cancer, The Walter and Eliza Hall Institute of Medical Research, 1G Royal Parade, Parkville, Victoria 3050, Australia. adams@wehi.edu.au",
					Journal -> "Oncogene",
					PublicationDate -> _?DateObjectQ,
					Volume -> "26",
					StartPage -> "1324",
					EndPage -> "1361",
					Issue -> "9",
					ISSN -> "0950-9232",
					ISSNType -> Print,
					DOI -> "10.1038/sj.onc.1210220",
					URL -> "http://www.ncbi.nlm.nih.gov/pubmed/17322918",
					Abstract -> _String,
					PubmedID -> "17322918",
					Keywords -> {},
					References -> {},
					Authors -> {"J. M. Adams", "S. Cory"},
					LiteratureFiles -> {"https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930981/pdf/nihms157057.pdf"},
					DocumentType -> JournalArticle,
					Automated -> True,
					Upload -> True,
					Output -> Options
				}
			],

			Example[
				{Options, DocumentType, "Indicate the type of literature that is being uploaded. DocumentType can be set to any value that matches DocumentTypeP:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}],
				_Grid
			],
			Test[
				"Indicate the type of literature that is being uploaded. DocumentType can be set to any value that matches DocumentTypeP:",
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, OutputFormat -> List],
				{
					Edition -> Null,
					Title -> "The Bcl-2 apoptotic switch in cancer development and therapy.",
					ContactInformation -> "Department of Molecular Genetics of Cancer, The Walter and Eliza Hall Institute of Medical Research, 1G Royal Parade, Parkville, Victoria 3050, Australia. adams@wehi.edu.au",
					Journal -> "Oncogene",
					PublicationDate -> _?DateObjectQ,
					Volume -> "26",
					StartPage -> "1324",
					EndPage -> "1361",
					Issue -> "9",
					ISSN -> "0950-9232",
					ISSNType -> Print,
					DOI -> "10.1038/sj.onc.1210220",
					URL -> "http://www.ncbi.nlm.nih.gov/pubmed/17322918",
					Abstract -> _String,
					PubmedID -> "17322918",
					Keywords -> {},
					References -> {},
					Authors -> {"J. M. Adams", "S. Cory"},
					LiteratureFiles -> {"https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930981/pdf/nihms157057.pdf"},
					DocumentType -> JournalArticle,
					Automated -> True,
					Upload -> True,
					Output -> Options
				}
			],

			Example[
				{Options, Title, "Use the Title option to specify the title of this piece of literature:"},
				UploadLiteratureOptions[PubMed[19549891], ContactInformation -> "Division of Hematology, Hadassah-Hebrew University Medical Center, Jerusalem, Israel.", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, ContactInformation, "Use the ContactInformation option to specify the contact information for the corresponding author:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, Journal, "Use the Journal option to specify the journal that this article was published in. The valid journals can be found by evaluating JournalP:"},
				UploadLiteratureOptions[PubMed[19549891], Journal -> "Cancer Research", DOI -> "10.1158/0008-5472.CAN-09-0424", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, PublicationDate, "Use the PublicationDate option to specify the date that the article was published:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", PublicationDate -> DateObject[{2011, 11, 2}, "Day", "Gregorian", -7.`], DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, Volume, "Use the Volume option to specify the journal volume in which the article appears:"},
				UploadLiteratureOptions[PubMed[19549891], Volume -> "69", ContactInformation -> "Division of Hematology, Hadassah-Hebrew University Medical Center, Jerusalem, Israel.", DOI -> "10.1158/0008-5472.CAN-09-0424", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, StartPage, "Use the StartPage option to specify the page on which this article begins:"},
				UploadLiteratureOptions[PubMed[22034434], StartPage -> "517", Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", PublicationDate -> DateObject[{2011, 11, 2}, "Day", "Gregorian", -7.`], DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, EndPage, "Use the EndPage option to specify the page on which this article ends:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D.E. Shaw Research", EndPage -> "537", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, Issue, "Use the Issue option to specify the journal issue in which this document appears:"},
				UploadLiteratureOptions[PubMed[22034434], Issue->"6055", Title -> "How fast-folding proteins fold", ContactInformation -> "D.E. Shaw Research", EndPage -> "537", DocumentType -> JournalArticle],
				_Grid
			],
			Example[
				{Options, Edition, "Use the Edition option to specify the edition of this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],
			Test[
				"Use the Edition option to specify the edition of this document:",
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				{LiteratureFiles -> Null, Keywords -> Null, DocumentType -> BookSection, Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ContactInformation -> Null, Journal -> Null, PublicationDate -> DateObject[{2006, 1}, "Month", Alternatives[PatternSequence[],PatternSequence["Gregorian",_?NumericQ]]], Volume -> Null, StartPage -> Null, EndPage -> Null, Issue -> Null, Edition -> "2", ISSN -> Null, ISSNType -> Null, DOI -> Null, URL -> Null, Abstract -> Null, PubmedID -> Null, References -> Null, Automated -> True, Upload -> True, Output -> Options}
			],

			Example[
				{Options, ISSN, "Use the ISSN option to specify the Interantional Standard Serial Number for this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],
			Test[
				"Use the ISSN option to specify the Interantional Standard Serial Number for this document:",
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				{LiteratureFiles -> Null, Keywords -> Null, DocumentType -> BookSection, Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ContactInformation -> Null, Journal -> Null, PublicationDate -> DateObject[{2006, 1}, "Month", Alternatives[PatternSequence[],PatternSequence["Gregorian",_?NumericQ]]], Volume -> Null, StartPage -> Null, EndPage -> Null, Issue -> Null, Edition -> "2", ISSN -> "1530-8561", ISSNType -> Print, DOI -> Null, URL -> Null, Abstract -> Null, PubmedID -> Null, References -> Null, Automated -> True, Upload -> True, Output -> Options}
			],

			Example[
				{Options, ISSNType, "Use the ISSNType option to specify the Interantional Standard Serial Number Type (Print or Electronic) for this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],
			Test[
				"Use the ISSNType option to specify the Interantional Standard Serial Number Type (Print or Electronic) for this document:",
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				{LiteratureFiles -> Null, Keywords -> Null, DocumentType -> BookSection, Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ContactInformation -> Null, Journal -> Null, PublicationDate -> DateObject[{2006, 1}, "Month", Alternatives[PatternSequence[],PatternSequence["Gregorian",_?NumericQ]]], Volume -> Null, StartPage -> Null, EndPage -> Null, Issue -> Null, Edition -> "2", ISSN -> "1530-8561", ISSNType -> Print, DOI -> Null, URL -> Null, Abstract -> Null, PubmedID -> Null, References -> Null, Automated -> True, Upload -> True, Output -> Options}
			],

			Example[
				{Options, Abstract, "Use the Abstract option to specify the abstract of this document:"},
				UploadLiteratureOptions[PubMed[10822552], Abstract -> "A novel catalytic enantioselective Strecker synthesis of chiral α-amino nitriles and α-amino acids is described and analyzed with regard to the possible mechanistic basis for stereoselectivity. Key features of the enantioselective process include (1) the use of the chiral bicyclic guanidine 1 as catalyst and (2) the use of the N-benzhydryl substituent on the imine substrate.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, PubmedID, "Use the PubmedID option to specify the PubMed specific identifier of this document:"},
				UploadLiteratureOptions[PubMed[10822552], PubmedID->"10822552", Abstract -> "A novel catalytic enantioselective Strecker synthesis of chiral α-amino nitriles and α-amino acids is described and analyzed with regard to the possible mechanistic basis for stereoselectivity. Key features of the enantioselective process include (1) the use of the chiral bicyclic guanidine 1 as catalyst and (2) the use of the N-benzhydryl substituent on the imine substrate.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, References, "Add a single model object that references this literature:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, References -> {Model[Sample, "Bcl-2 alpha"]}],
				_Grid
			],
			Test[
				"Add a single model object that references this literature:",
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, References -> {Model[Sample, "Bcl-2 alpha"]}, OutputFormat -> List],
				{Edition -> Null, Title -> "The Bcl-2 apoptotic switch in cancer development and therapy.", ContactInformation -> "Department of Molecular Genetics of Cancer, The Walter and Eliza Hall Institute of Medical Research, 1G Royal Parade, Parkville, Victoria 3050, Australia. adams@wehi.edu.au", Journal -> "Oncogene", PublicationDate -> _?DateObjectQ, Volume -> "26", StartPage -> "1324", EndPage -> "1361", Issue -> "9", ISSN -> "0950-9232", ISSNType -> Print, DOI -> "10.1038/sj.onc.1210220", URL -> "http://www.ncbi.nlm.nih.gov/pubmed/17322918", Abstract -> _String, PubmedID -> "17322918", Keywords -> {}, Authors -> {"J. M. Adams", "S. Cory"}, LiteratureFiles -> {"https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930981/pdf/nihms157057.pdf"}, DocumentType -> JournalArticle, References -> {Model[Sample, "Bcl-2 alpha"]}, Automated -> True, Upload -> True, Output -> Options}
			],
			Example[
				{Messages, "TitleCannotBeNull", "The Title option cannot be Null:"},
				UploadLiteratureOptions[Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::TitleCannotBeNull}
			],
			Example[
				{Messages, "AuthorsCannotBeNull", "The Authors option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> Null, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::AuthorsCannotBeNull}
			],
			Example[
				{Messages, "DocumentTypeCannotBeNull", "The Document option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", DocumentType -> Null, ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, PublicationDate -> DateObject["Jan 2006"], OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::DocumentTypeCannotBeNull}
			],
			Example[
				{Messages, "EditionMustBeNull", "The Edition option must be Null if the DocumentType is not a Book or Book Section:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Edition -> "1", DocumentType -> JournalArticle, ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, PublicationDate -> DateObject["Jan 2006"], OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::NullJournalFields, UploadLiterature::EditionMustBeNull}
			],
			Example[
				{Messages, "PublicationDateCannotBeNull", "The PublicationDate option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::PublicationDateCannotBeNull}
			],
			Example[
				{Messages, "FuturePublicationDate", "The Publication date cannot be set to a date in the future:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 3006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::FuturePublicationDate}
			],
			Example[
				{Messages, "InvalidPubmedID", "An Error is thrown if the given Pubmed ID is not valid:"},
				UploadLiteratureOptions[PubMed[123456789], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, References -> {Model[Sample, "Bcl-2 alpha"]}],
				_,
				Messages :> {Error::InvalidInput, UploadLiterature::InvalidPubmedID}
			],
			Example[
				{Messages, "InvalidXMLFile", "An Error is thrown if the given XML file is not valid:"},
				UploadLiteratureOptions["C:/DirectoryDoesNotExist/myXML.xml"],
				_,
				Messages :> {Error::InvalidInput, UploadLiterature::InvalidXMLFile}
			],
			Example[
				{Messages, "NullJournalFields", "If the DocumentType is set to JournalArticle, all of the fields {ContactInformation, Journal, Volume, StartPage, EndPage, PubmedID} must be non-Null:"},
				UploadLiteratureOptions[Title -> "Enantioselective synthesis of alpha-amino nitriles from N-benzhydryl imines and HCN with a chiral bicyclic guanidine as catalyst.", Authors -> {"E. J. Corey", "M. J. Grogan"}, PublicationDate -> DateObject[{2000, 7, 10}, "Day", "Gregorian", -7.`], Volume -> "1", StartPage -> "157", EndPage -> "217", Issue -> "1", ISSN -> "1523-7060", ISSNType -> Print, ContactInformation -> "Department of Chemistry and Chemical Biology, Harvard University, Cambridge, Massachusetts 02138, USA. corey@chemistry.harvard.edu", PubmedID -> "10822552", DocumentType -> JournalArticle, OutputFormat -> List],
				_,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::RequiredTogetherOptions, UploadLiterature::NullJournalFields}
			],
			Example[
				{Messages, "RequiredTogetherOptions", "If the DocumentType is set to JournalArticle, all of the fields {ContactInformation, Journal, Volume, StartPage, EndPage, PubmedID} must be non-Null:"},
				UploadLiteratureOptions[Title -> "Enantioselective synthesis of alpha-amino nitriles from N-benzhydryl imines and HCN with a chiral bicyclic guanidine as catalyst.", Authors -> {"E. J. Corey", "M. J. Grogan"}, PublicationDate -> DateObject[{2000, 7, 10}, "Day", "Gregorian", -7.`], Volume -> "1", StartPage -> "157", EndPage -> "217", Issue -> "1", ISSN -> "1523-7060", ISSNType -> Print, ContactInformation -> "Department of Chemistry and Chemical Biology, Harvard University, Cambridge, Massachusetts 02138, USA. corey@chemistry.harvard.edu", PubmedID -> "10822552", DocumentType -> JournalArticle, OutputFormat -> List],
				_,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::RequiredTogetherOptions, UploadLiterature::NullJournalFields}
			]
		},
		Stubs :> {
			PDFFileQ[___]:=True,
			UploadCloudFile[Except[_List]]:=Download[Object[EmeraldCloudFile, "Fake cloud file 1 for UploadLiteratureOptions unit tests"], Object]
		},
		TurnOffMessages :> {Warning::APIConnection}
	]
];


(* ::Subsubsection::Closed:: *)
(*UploadLiteratureOptions*)


With[
	{
		(* The following are free journal article PDFs from online. *)
		goodFile1="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2930981/pdf/nihms157057.pdf",
		goodFile2="http://cancerres.aacrjournals.org/content/canres/69/13/5475.full.pdf",

		(* Download the EndNote 8 XML file from PNAS and get the path of the downloaded file. *)
		goodXMLFile=Quiet[URLDownload["http://www.pnas.org/highwire/citation/61798/endnote-8-xml", FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".xml"}]][[1]]]
	},
	DefineTests[UploadLiteratureOptions,
		{
			Example[{Basic, "Return the resolved options when parsing an Object[Report,Literature] from a PubMed ID:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}],
				_Grid
			],
			Example[{Basic, "Return the resolved options when parsing an Object[Report,Literature] from EndNote:"},
				UploadLiteratureOptions[{"ref-type" -> {"Book"}, "author" -> {"Victor Bloomfield;", "Donald Crothers;", "Tinoco Ignacio"}, "auth-address" -> {}, "title" -> {"Nucleic Acids: Structures, Properties, and Functions"}, "full-title" -> {}, "pages" -> {}, "SampleVolume" -> {}, "number" -> {}, "edition" -> {}, "keyword" -> {}, "date" -> {}, "year" -> {"2000"}, "isbn" -> {}, "accession-num" -> {}, "abstract" -> {}, "notes" -> {}, "url" -> {}, "electronic-resource-num" -> {}, "pub-location" -> {"Sausalito, CA"}, "publisher" -> {"University Science Books"}, "section" -> {}, "pdf-urls" -> {}, "research-notes" -> {}}],
				_Grid
			],
			Example[
				{Basic, "Return the resolved options when parsing an Object[Report,Literature] manually:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],
			(* --- options --- *)
			(* In the following option examples, we always give the user the result as a Grid for ease of reading. However, the real test outputs as a List for easier checking. *)
			Example[
				{Options, LiteratureFiles, "Indicate any additional files that should be included in the literature report. These files can be links to online PDF files or local PDF files:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}],
				_Grid
			],


			Example[
				{Options, DocumentType, "Indicate the type of literature that is being uploaded. DocumentType can be set to any value that matches DocumentTypeP:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}],
				_Grid
			],


			Example[
				{Options, Keywords, "Use the Keywords option to include key descriptive words about this piece of literature:"},
				UploadLiteratureOptions[PubMed[19549891], Keywords -> {"Livin", "ML-IAP", "Tumorigenicity"}, DOI -> "10.1158/0008-5472.CAN-09-0424", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, Authors, "Use the Authors option to specify the authors of this piece of literature:"},
				UploadLiteratureOptions[PubMed[19549891], ContactInformation -> "Division of Hematology, Hadassah-Hebrew University Medical Center, Jerusalem, Israel.", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", Authors -> {"Ihab Abd-Elrahman"}, DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, ContactInformation, "Use the ContactInformation option to specify the contact information for the corresponding author:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, PublicationDate, "Use the PublicationDate option to specify the date that the article was published:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", PublicationDate -> DateObject[{2011, 11, 2}, "Day", "Gregorian", -7.`], DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, StartPage, "Use the StartPage option to specify the page on which this article begins:"},
				UploadLiteratureOptions[PubMed[22034434], StartPage -> "517", Title -> "How fast-folding proteins fold", ContactInformation -> "D. E. Shaw Research, New York, NY 10036, USA. kresten.lindorff-larsen@DEShawResearch.com", PublicationDate -> DateObject[{2011, 11, 2}, "Day", "Gregorian", -7.`], DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, EndPage, "Use the EndPage option to specify the page on which this article ends:"},
				UploadLiteratureOptions[PubMed[22034434], Title -> "How fast-folding proteins fold", ContactInformation -> "D.E. Shaw Research", EndPage -> "537", DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, Issue, "Use the Issue option to specify the journal issue in which this document appears:"},
				UploadLiteratureOptions[PubMed[22034434], Issue->"6055", Title -> "How fast-folding proteins fold", ContactInformation -> "D.E. Shaw Research", EndPage -> "537", DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, Edition, "Use the Edition option to specify the edition of this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],


			Example[
				{Options, ISSN, "Use the ISSN option to specify the Interantional Standard Serial Number for this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],


			Example[
				{Options, ISSNType, "Use the ISSNType option to specify the Interantional Standard Serial Number Type (Print or Electronic) for this document:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
				_Grid
			],


			Example[
				{Options, DOI, "Use the DOI option to specify the Digital Object Identifier of this document:"},
				UploadLiteratureOptions[PubMed[19549891], ContactInformation -> "Division of Hematology, Hadassah-Hebrew University Medical Center, Jerusalem, Israel.", DOI -> "10.1158/0008-5472.CAN-09-0424", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],


			Example[
				{Options, URL, "Use the URL option to specify where this document is :"},
				UploadLiteratureOptions[PubMed[19549891], ContactInformation -> "Division of Hematology, Hadassah-Hebrew University Medical Center, Jerusalem, Israel.", URL -> "https://pubmed.ncbi.nlm.nih.gov/19549891/", DOI -> "10.1158/0008-5472.CAN-09-0424", Title -> "The inhibitor of apoptosis protein Livin (ML-IAP) plays a dual role in tumorigenicity.", DocumentType -> JournalArticle],
				_Grid
			],

			Example[
				{Options, References, "Add a single model object that references this literature:"},
				UploadLiteratureOptions[PubMed[17322918], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, References -> {Model[Sample, "Bcl-2 alpha"]}],
				_Grid
			],

			Example[
				{Messages, "TitleCannotBeNull", "The Title option cannot be Null:"},
				UploadLiteratureOptions[Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::TitleCannotBeNull}
			],
			Example[
				{Messages, "AuthorsCannotBeNull", "The Authors option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> Null, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::AuthorsCannotBeNull}
			],
			Example[
				{Messages, "DocumentTypeCannotBeNull", "The Document option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", DocumentType -> Null, ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, PublicationDate -> DateObject["Jan 2006"], OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::DocumentTypeCannotBeNull}
			],
			Example[
				{Messages, "EditionMustBeNull", "The Edition option must be Null if the DocumentType is not a Book or Book Section:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Edition -> "1", DocumentType -> JournalArticle, ISSN -> "1530-8561", ISSNType -> Print, Authors -> {"Gary Siuzadak"}, PublicationDate -> DateObject["Jan 2006"], OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::NullJournalFields, UploadLiterature::EditionMustBeNull}
			],
			Example[
				{Messages, "PublicationDateCannotBeNull", "The PublicationDate option cannot be Null:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::PublicationDateCannotBeNull}
			],
			Example[
				{Messages, "FuturePublicationDate", "The Publication date cannot be set to a date in the future:"},
				UploadLiteratureOptions[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, ISSN -> "1530-8561", ISSNType -> Print, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 3006"], Edition -> "2", OutputFormat -> List],
				_List,
				Messages :> {Error::InvalidOption, UploadLiterature::FuturePublicationDate}
			],
			Example[
				{Messages, "InvalidPubmedID", "An Error is thrown if the given Pubmed ID is not valid:"},
				UploadLiteratureOptions[PubMed[123456789], DocumentType -> JournalArticle, LiteratureFiles -> {goodFile1}, References -> {Model[Sample, "Bcl-2 alpha"]}],
				_,
				Messages :> {Error::InvalidInput, UploadLiterature::InvalidPubmedID}
			],
			Example[
				{Messages, "InvalidXMLFile", "An Error is thrown if the given XML file is not valid:"},
				UploadLiteratureOptions["C:/DirectoryDoesNotExist/myXML.xml"],
				_,
				Messages :> {Error::InvalidInput, UploadLiterature::InvalidXMLFile}
			],
			Example[
				{Messages, "NullJournalFields", "If the DocumentType is set to JournalArticle, all of the fields {ContactInformation, Journal, Volume, StartPage, EndPage, PubmedID} must be non-Null:"},
				UploadLiteratureOptions[Title -> "Enantioselective synthesis of alpha-amino nitriles from N-benzhydryl imines and HCN with a chiral bicyclic guanidine as catalyst.", Authors -> {"E. J. Corey", "M. J. Grogan"}, PublicationDate -> DateObject[{2000, 7, 10}, "Day", "Gregorian", -7.`], Volume -> "1", StartPage -> "157", EndPage -> "217", Issue -> "1", ISSN -> "1523-7060", ISSNType -> Print, ContactInformation -> "Department of Chemistry and Chemical Biology, Harvard University, Cambridge, Massachusetts 02138, USA. corey@chemistry.harvard.edu", PubmedID -> "10822552", DocumentType -> JournalArticle, OutputFormat -> List],
				_,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::RequiredTogetherOptions, UploadLiterature::NullJournalFields}
			],
			Example[
				{Messages, "RequiredTogetherOptions", "If the DocumentType is set to JournalArticle, all of the fields {ContactInformation, Journal, Volume, StartPage, EndPage, PubmedID} must be non-Null:"},
				UploadLiteratureOptions[Title -> "Enantioselective synthesis of alpha-amino nitriles from N-benzhydryl imines and HCN with a chiral bicyclic guanidine as catalyst.", Authors -> {"E. J. Corey", "M. J. Grogan"}, PublicationDate -> DateObject[{2000, 7, 10}, "Day", "Gregorian", -7.`], Volume -> "1", StartPage -> "157", EndPage -> "217", Issue -> "1", ISSN -> "1523-7060", ISSNType -> Print, ContactInformation -> "Department of Chemistry and Chemical Biology, Harvard University, Cambridge, Massachusetts 02138, USA. corey@chemistry.harvard.edu", PubmedID -> "10822552", DocumentType -> JournalArticle, OutputFormat -> List],
				_,
				Messages :> {Error::InvalidOption, Error::InvalidOption, UploadLiterature::RequiredTogetherOptions, UploadLiterature::NullJournalFields}
			],
			Example[{Options, OutputFormat, "Return the resolved options as a list:"},
				UploadLiteratureOptions[PubMed[10822552], DOI -> "10.1021/ol990623l", DocumentType -> JournalArticle, OutputFormat -> List],
				{Rule[_Symbol, Except[Automatic | $Failed]]..}
			]
		},
		TurnOffMessages :> {Warning::APIConnection}
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadLiteratureQ*)


DefineTests[ValidUploadLiteratureQ,
	{
		Example[{Basic, "Return the resolved options when parsing an Object[Report,Literature] from a PubMed ID:"},
			ValidUploadLiteratureQ[PubMed[17322918], DocumentType -> JournalArticle],
			BooleanP
		],
		Example[{Basic, "Return the resolved options when parsing an Object[Report,Literature] from EndNote:"},
			ValidUploadLiteratureQ[{"ref-type" -> {"Book"}, "author" -> {"Victor Bloomfield;", "Donald Crothers;", "Tinoco Ignacio"}, "auth-address" -> {}, "title" -> {"Nucleic Acids: Structures, Properties, and Functions"}, "full-title" -> {}, "pages" -> {}, "SampleVolume" -> {}, "number" -> {}, "edition" -> {}, "keyword" -> {}, "date" -> {}, "year" -> {"2000"}, "isbn" -> {}, "accession-num" -> {}, "abstract" -> {}, "notes" -> {}, "url" -> {}, "electronic-resource-num" -> {}, "pub-location" -> {"Sausalito, CA"}, "publisher" -> {"University Science Books"}, "section" -> {}, "pdf-urls" -> {}, "research-notes" -> {}}],
			BooleanP
		],
		Example[
			{Basic, "Return the resolved options when parsing an Object[Report,Literature] manually:"},
			ValidUploadLiteratureQ[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2"],
			BooleanP
		],
		Example[
			{Options, Verbose, "Set Verbose->True to see all of the running tests. Verbose can be set to True|False|Failures:"},
			ValidUploadLiteratureQ[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", Verbose -> True],
			BooleanP
		],
		Example[
			{Options, OutputFormat, "Set OutputFormat->TestSummary to have to function return a TestSummary of the tests it ran:"},
			ValidUploadLiteratureQ[Title -> "The Expanding role of Mass Spectrometry in Biotechnology", Authors -> {"Gary Siuzadak"}, DocumentType -> BookSection, PublicationDate -> DateObject["Jan 2006"], Edition -> "2", OutputFormat -> TestSummary],
			_EmeraldTestSummary
		]
	},
	TurnOffMessages :> {Warning::APIConnection}
];


(* ::Subsection::Closed:: *)
(*UploadFractionCollectionMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethod*)


DefineTests[UploadFractionCollectionMethod,
	{
		Example[{Basic, "Create a new FractionCollection method using any options specified:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Basic, "Create a new FractionCollection method using any options specified:"},
			UploadFractionCollectionMethod[
				Object[Method, FractionCollection, "Template Method 1" <> $SessionUUID],
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				AbsoluteThreshold -> Quantity[20., "Milli" IndependentUnit["AbsorbanceUnit"]],
				Upload -> False
			],
			<|
				Object -> ObjectP[Object[Method, FractionCollection]],
				Type -> Object[Method, FractionCollection],
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				AbsoluteThreshold -> 20. MilliAbsorbanceUnit,
				FractionCollectionEndTime -> Null,
				FractionCollectionMode -> Threshold,
				FractionCollectionStartTime -> Null,
				MaxCollectionPeriod -> Null,
				MaxFractionVolume -> 1.8 Milliliter,
				PeakEndThreshold -> Null,
				PeakSlope -> Null,
				PeakSlopeDuration -> Null,
				Template -> Null
			|>,
			SetUp :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 1" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 1" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					Upload[
						<|
							Type -> Object[Method, FractionCollection],
							Name -> "Template Method 1" <> $SessionUUID,
							AbsoluteThreshold -> Quantity[10.`, "Milli" IndependentUnit["AbsorbanceUnit"]],
							FractionCollectionEndTime -> Null,
							FractionCollectionMode -> Threshold,
							FractionCollectionStartTime -> Null, MaxCollectionPeriod -> Null,
							MaxFractionVolume -> Quantity[1.8`, "Milliliters"],
							PeakEndThreshold -> Null, PeakSlope -> Null,
							PeakSlopeDuration -> Null, Template -> Null
						|>
					]
				]
			},
			TearDown :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 1" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 1" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
					];
				]
			}
		],
		(* --- Options --- *)
		Example[{Options, Name, "Specify the name of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, FractionCollectionStartTime, "Specify the collection start time of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionStartTime -> 3Minute],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, FractionCollectionEndTime, "Specify the collection start and end time of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionStartTime -> 3Minute, FractionCollectionEndTime -> 5Minute],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, FractionCollectionMode, "Specify the collection mode of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionMode -> Peak],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, FractionCollectionMode, "If no options provided, FractionCollectionMode will default to Threshold:"},
			Lookup[
				UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionMode -> Automatic, Upload -> False],
				FractionCollectionMode
			],
			Threshold
		],
		Example[{Options, FractionCollectionMode, "If a MaxCollectionPeriod is provided, FractionCollectionMode will default Automatic to Time:"},
			Lookup[
				UploadFractionCollectionMethod[FractionCollectionMode -> Automatic, MaxCollectionPeriod -> 2Minute, Upload -> False],
				FractionCollectionMode
			],
			Time
		],
		Example[{Options, MaxFractionVolume, "Specify the maximum collected fraction volume of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, MaxFractionVolume -> 1.5Milliliter],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, MaxFractionVolume, "MaxFractionVolume defaults Automatic to 1.8 Milliliter if FractionCollectionMode->Threshold:"},
			Lookup[
				UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionMode -> Threshold, MaxFractionVolume -> Automatic, Upload -> False],
				MaxFractionVolume
			],
			_?(MatchQ[#, 1.8Milliliter]&)
		],
		Example[{Options, MaxCollectionPeriod, "Specify the maximum period of fraction collection for the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, MaxCollectionPeriod -> 1Minute],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, MaxCollectionPeriod, "If FractionCollectionMode->Time, MaxCollectionPeriod defualts Automatic to 30 Second:"},
			Lookup[
				UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionMode -> Time, MaxCollectionPeriod -> Automatic, Upload -> False],
				MaxCollectionPeriod
			],
			_?(MatchQ[#, 30 * Second]&)
		],
		Example[{Options, AbsoluteThreshold, "Specify the absolute threshold of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, AbsoluteThreshold -> (300 * MilliAbsorbanceUnit)],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, AbsoluteThreshold, "If FractionCollectionMode->Threshold or Peak, AbsoluteThreshold defualts Automatic to 500 MilliAbsorbanceUnit:"},
			Lookup[
				UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, FractionCollectionMode -> Threshold, AbsoluteThreshold -> Automatic, Upload -> False],
				AbsoluteThreshold
			],
			_?(MatchQ[#, (500 * MilliAbsorbanceUnit)]&)
		],
		Example[{Options, PeakSlope, "Specify the peak slope of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, PeakSlope -> ((10MilliAbsorbanceUnit) / (1 * Second))],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, PeakSlopeDuration, "Specify the peak slope duration of the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, PeakSlopeDuration -> 1 * Second],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, PeakEndThreshold, "Specify the threshold that designates the end of a peak for the FractionCollection method:"},
			UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, PeakEndThreshold -> (300 * MilliAbsorbanceUnit)],
			ObjectP[Object[Method, FractionCollection]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, Template, "Use another Object[Method,FractionCollection] as the template for the creation of a new method:"},
			UploadFractionCollectionMethod[
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				Template -> Object[Method, FractionCollection, "Template Method 2" <> $SessionUUID],
				FractionCollectionMode -> Peak,
				PeakEndThreshold -> (300 * MilliAbsorbanceUnit),
				Upload -> False
			],
			<|
				Object -> ObjectP[Object[Method, FractionCollection]],
				Type -> Object[Method, FractionCollection],
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				AbsoluteThreshold -> Null,
				FractionCollectionEndTime -> Null,
				FractionCollectionMode -> Peak,
				FractionCollectionStartTime -> Null, MaxCollectionPeriod -> Null,
				MaxFractionVolume -> 1.8 Milliliter,
				PeakEndThreshold -> 300 MilliAbsorbanceUnit, PeakSlope -> 2 Milli*AbsorbanceUnit/Second,
				PeakSlopeDuration -> (0. * Second),
				Template -> LinkP[Object[Method, FractionCollection], MethodsTemplated]
			|>,
			SetUp :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 2" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 2" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					Upload[
						<|
							Type -> Object[Method, FractionCollection],
							Name -> "Template Method 2" <> $SessionUUID,
							AbsoluteThreshold -> Null,
							FractionCollectionEndTime -> Null,
							FractionCollectionMode -> Peak,
							FractionCollectionStartTime -> Null,
							MaxCollectionPeriod -> Null,
							MaxFractionVolume -> Quantity[1.8`, "Milliliters"],
							PeakEndThreshold -> Null,
							PeakSlope -> Quantity[2,Times[Power["Kiloseconds",-1],IndependentUnit["AbsorbanceUnit"]]],
							PeakSlopeDuration -> Quantity[0., "Seconds"], Template -> Null
						|>
					]
				]
			},
			TearDown :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 2" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 2" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
					];
				]
			}
		],
		(* --- Messages --- *)
		Example[{Messages, "MethodNameAlreadyExists", "If the name of the method has already been used used, return an error:"},
			UploadFractionCollectionMethod[Name -> "Existing method object name"],
			$Failed,
			Messages :> {
				Error::MethodNameAlreadyExists,
				Error::InvalidOption
			},
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Existing method object name"]]=True
			}
		],
		Example[{Messages, "FractionCollectionTiming", "If a FractionCollectionEndTime was specified, but not start time was specified after the end time provided, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionEndTime -> 15Minute, FractionCollectionStartTime -> 20Minute, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionTiming,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionTiming", "If a FractionCollectionEndTime was specified, but not start time was specified, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionEndTime -> 15Minute, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionTiming,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Time and MaxCollectionPeriod was set to Null, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Time, MaxCollectionPeriod -> Null, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Time and AbsoluteThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Time, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Threshold and AbsoluteThreshold was set to Null, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Threshold, AbsoluteThreshold -> Null, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Threshold and PeakEndThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Threshold, PeakEndThreshold -> 10 Milli*AbsorbanceUnit, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Peak and PeakSlope was set to Null, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Peak, PeakSlope -> Null],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Peak and AbsoluteThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethod[FractionCollectionMode -> Peak, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit, Upload -> False],
			$Failed,
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Test["The newly-created object pass VOQ:",
			method=UploadFractionCollectionMethod[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID];
			(* need to pause because otherwise the moment it is created DateCreated is the same as now, not before now so it freaks out *)
			Pause[5];
			ValidObjectQ[method],
			True,
			Variables :> {
				method
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethodOptions*)


DefineTests[UploadFractionCollectionMethodOptions,
	{
		Example[{Basic, "Return the resolved options of UploadFractionCollectionMethod when called with options:"},
			UploadFractionCollectionMethodOptions[AbsoluteThreshold -> 1 * AbsorbanceUnit, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Create a new FractionCollection method using any options specified:"},
			UploadFractionCollectionMethodOptions[
				Object[Method, FractionCollection, "Template Method 3" <> $SessionUUID],
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				AbsoluteThreshold -> Quantity[20., "Milli" IndependentUnit["AbsorbanceUnit"]],
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			SetUp :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 3" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 3" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					Upload[
						<|
							Type -> Object[Method, FractionCollection],
							Name -> "Template Method 3" <> $SessionUUID,
							AbsoluteThreshold -> Quantity[10.`, "Milli" IndependentUnit["AbsorbanceUnit"]],
							FractionCollectionEndTime -> Null,
							FractionCollectionMode -> Threshold,
							FractionCollectionStartTime -> Null, MaxCollectionPeriod -> Null,
							MaxFractionVolume -> Quantity[1.8`, "Milliliters"],
							PeakEndThreshold -> Null, PeakSlope -> Null,
							PeakSlopeDuration -> Null, Template -> Null
						|>
					]
				]
			},
			TearDown :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 3" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 3" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
					];
				]
			}
		],
		(* Options *)
		Example[{Options, OutputFormat, "Specify the desired OutputFormat:"},
			UploadFractionCollectionMethodOptions[AbsoluteThreshold -> 1 * AbsorbanceUnit, OutputFormat -> Table],
			Graphics_
		],
		(* Options *)
		Example[{Options, Name, "Specify the name of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				Name -> "Test name",
				OutputFormat -> List
			], Name],
			_String
		],
		Example[{Options, FractionCollectionStartTime, "Specify the collection start time of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				FractionCollectionStartTime -> 10Minute,
				OutputFormat -> List
			], FractionCollectionStartTime],
			TimeP
		],
		Example[{Options, FractionCollectionEndTime, "Specify the collection start and end time of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				FractionCollectionStartTime -> 10Minute,
				FractionCollectionEndTime -> 11Minute,
				OutputFormat -> List
			], FractionCollectionEndTime],
			TimeP
		],
		Example[{Options, FractionCollectionMode, "Specify the collection mode of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				FractionCollectionMode -> Threshold,
				OutputFormat -> List
			], FractionCollectionMode],
			Threshold
		],
		Example[{Options, MaxFractionVolume, "Specify the maximum collected fraction volume of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				MaxFractionVolume -> 1.5Milliliter,
				OutputFormat -> List
			], MaxFractionVolume],
			VolumeP
		],
		Example[{Options, MaxCollectionPeriod, "Specify the maximum period of fraction collection for the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				MaxCollectionPeriod -> 1 * Minute,
				OutputFormat -> List
			], MaxCollectionPeriod],
			TimeP
		],
		Example[{Options, AbsoluteThreshold, "Specify the absolute threshold of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				AbsoluteThreshold -> 500 * MilliAbsorbanceUnit,
				OutputFormat -> List
			], AbsoluteThreshold],
			AbsorbanceUnitP
		],
		Example[{Options, PeakSlope, "Specify the peak slope of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				PeakSlope -> ((1 * AbsorbanceUnit) / (1 * Second)),
				OutputFormat -> List
			], PeakSlope],
			_(*How do I do compound units?*)
		],
		Example[{Options, PeakSlopeDuration, "Specify the peak slope duration of the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				PeakSlopeDuration -> 1 * Second,
				OutputFormat -> List
			], PeakSlopeDuration],
			TimeP
		],
		Example[{Options, PeakEndThreshold, "Specify the threshold that designates the end of a peak for the FractionCollection method:"},
			Lookup[UploadFractionCollectionMethodOptions[
				PeakEndThreshold -> 500 * MilliAbsorbanceUnit,
				OutputFormat -> List
			], PeakEndThreshold],
			AbsorbanceUnitP
		],
		(* --- Messages --- *)
		Example[{Messages, "MethodNameAlreadyExists", "If the name of the method has already been used used, return an error:"},
			UploadFractionCollectionMethodOptions[Name -> "Existing method object name", OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::MethodNameAlreadyExists,
				Error::InvalidOption
			},
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Existing method object name"]]=True
			}
		],
		Example[{Messages, "FractionCollectionTiming", "If a FractionCollectionEndTime was specified, but not start time was specified after the end time provided, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionEndTime -> 15Minute, FractionCollectionStartTime -> 20Minute, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionTiming,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionTiming", "If a FractionCollectionEndTime was specified, but not start time was specified, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionEndTime -> 15Minute, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionTiming,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Time and MaxCollectionPeriod was set to Null, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Time, MaxCollectionPeriod -> Null, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Time and AbsoluteThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Time, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Threshold, and AbsoluteThreshold was set to Null, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Threshold, AbsoluteThreshold -> Null, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Threshold and PeakEndThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Threshold, PeakEndThreshold -> 10 Milli*AbsorbanceUnit, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Peak, and PeakSlope was set to Null, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Peak, PeakSlope -> Null, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FractionCollectionMode", "If a FractionCollectionMode was set to Peak and AbsoluteThreshold was set to a value, return an error:"},
			UploadFractionCollectionMethodOptions[FractionCollectionMode -> Time, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::FractionCollectionMode,
				Error::InvalidOption
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadFractionCollectionMethodQ*)


DefineTests[ValidUploadFractionCollectionMethodQ,
	{
		Example[{Basic, "Create a new FractionCollection method based on the provided defaults:"},
			ValidUploadFractionCollectionMethodQ[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
					EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Basic, "Create a new FractionCollection method based on the provided defaults and the values from a template object:"},
			ValidUploadFractionCollectionMethodQ[
				Object[Method, FractionCollection, "Template Method 4" <> $SessionUUID],
				Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID,
				AbsoluteThreshold -> Quantity[20., "Milli" IndependentUnit["AbsorbanceUnit"]]
			],
			True,
			SetUp :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 4" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 4" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					Upload[
						<|
							Type -> Object[Method, FractionCollection],
							Name -> "Template Method 4" <> $SessionUUID,
							AbsoluteThreshold -> Quantity[10.`, "Milli" IndependentUnit["AbsorbanceUnit"]],
							FractionCollectionEndTime -> Null,
							FractionCollectionMode -> Threshold,
							FractionCollectionStartTime -> Null, MaxCollectionPeriod -> Null,
							MaxFractionVolume -> Quantity[1.8`, "Milliliters"],
							PeakEndThreshold -> Null, PeakSlope -> Null,
							PeakSlopeDuration -> Null, Template -> Null
						|>
					]
				]
			},
			TearDown :> {
				Module[{},
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Template Method 4" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Template Method 4" <> $SessionUUID], Force -> True, Verbose -> False]
					];
					If[DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]],
						EraseObject[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID], Force -> True, Verbose -> False]
					];
				]
			}
		],

		(* --- Options --- *)
		Example[{Options, Verbose, "Specify verbose when calling ValidUploadFractionCollectionMethodQ:"},
			ValidUploadFractionCollectionMethodQ[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, Verbose -> True],
			True,
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]]=False
			}
		],
		Example[{Options, OutputFormat, "Specify OutputFormat when calling ValidUploadFractionCollectionMethodQ:"},
			ValidUploadFractionCollectionMethodQ[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID, OutputFormat -> Boolean],
			True,
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]]=False
			}
		],
		Example[{Options, Name, "Specify the name of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[Name -> "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID],
			True,
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Test FC Method 1 (UploadFractionCollectionMethod)" <> $SessionUUID]]=False
			}
		],
		Example[{Options, FractionCollectionStartTime, "Specify the collection start time of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[FractionCollectionStartTime -> 3Minute],
			True
		],
		Example[{Options, FractionCollectionEndTime, "Specify the collection start and end time of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[FractionCollectionStartTime -> 3Minute, FractionCollectionEndTime -> 5Minute],
			True
		],
		Example[{Options, FractionCollectionMode, "Specify the collection mode of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Peak],
			True
		],
		Example[{Options, MaxFractionVolume, "Specify the maximum collected fraction volume of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[MaxFractionVolume -> 1.5Milliliter],
			True
		],
		Example[{Options, MaxCollectionPeriod, "Specify the maximum period of fraction collection for the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[MaxCollectionPeriod -> 1Minute],
			True
		],
		Example[{Options, AbsoluteThreshold, "Specify the absolute threshold of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[AbsoluteThreshold -> (300 * MilliAbsorbanceUnit)],
			True
		],
		Example[{Options, PeakSlope, "Specify the peak slope of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[PeakSlope -> ((10MilliAbsorbanceUnit) / (1 * Second))],
			True
		],
		Example[{Options, PeakSlopeDuration, "Specify the peak slope duration of the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[PeakSlopeDuration -> 1 * Second],
			True
		],
		Example[{Options, PeakEndThreshold, "Specify the threshold that designates the end of a peak for the FractionCollection method:"},
			ValidUploadFractionCollectionMethodQ[PeakEndThreshold -> (300 * MilliAbsorbanceUnit)],
			True
		],

		(* --- Messages --- *)
		Test["If the name of the method has already been used used, return False:",
			ValidUploadFractionCollectionMethodQ[Name -> "Existing method object name"],
			False,
			Stubs :> {
				DatabaseMemberQ[Object[Method, FractionCollection, "Existing method object name"]]=True
			}
		],
		Test["If a FractionCollectionEndTime was specified, but not start time was specified after the end time provided, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionEndTime -> 15Minute, FractionCollectionStartTime -> 20Minute],
			False
		],
		Test["If a FractionCollectionEndTime was specified, but not start time was specified, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionEndTime -> 15Minute],
			False
		],
		Test["If a FractionCollectionMode was set to Time and MaxCollectionPeriod was set to Null, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Time, MaxCollectionPeriod -> Null],
			False
		],
		Test["If a FractionCollectionMode was set to Time and AbsoluteThreshold was set to a value, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Time, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit],
			False
		],
		Test["If a FractionCollectionMode was set to Threshold and AbsoluteThreshold was set to Null, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Threshold, AbsoluteThreshold -> Null],
			False
		],
		Test["If a FractionCollectionMode was set to Threshold and PeakEndThreshold was set to a value, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Threshold, PeakEndThreshold -> 10 Milli*AbsorbanceUnit],
			False
		],
		Test["If a FractionCollectionMode was set to Peak, and PeakSlope was set to Null, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Peak, PeakSlope -> Null],
			False
		],
		Test["If a FractionCollectionMode was set to Peak and AbsoluteThreshold was set to a value, return a False:",
			ValidUploadFractionCollectionMethodQ[FractionCollectionMode -> Peak, AbsoluteThreshold -> 10 Milli*AbsorbanceUnit],
			False
		]
	}
];



(* ::Subsection::Closed:: *)
(*UploadColumn*)


(* ::Subsubsection:: *)
(*UploadColumn*)


DefineTests[
	UploadColumn,
	{
		Module[{newColumn},
			Example[{Basic, "The basic example:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				newColumn,
				ObjectP[Model[Item, Column]],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn,oldMinPressure,newMinPressure},
			Example[{Additional, "Updates an existing column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				oldMinPressure=Download[newColumn,MinPressure];
				UploadColumn[newColumn,MinPressure->1500PSI];
				newMinPressure=Download[newColumn,MinPressure];
				{oldMinPressure,newMinPressure},
				{EqualP[1000PSI],EqualP[1500PSI]},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],

		(* === OPTIONS === *)
		Module[{newColumn},
			Example[{Options, CasingMaterial, "CasingMaterial allows specification of the material that the exterior of the column which houses the packing material is composed of:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					CasingMaterial -> ZirconiumOxide,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, CasingMaterial],
				ZirconiumOxide,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, SeparationMode, "SeparationMode allows specification of type of chromatography for which this column is suitable:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					SeparationMode -> SizeExclusion,
					ColumnType -> Preparative, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, SeparationMode],
				SizeExclusion,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ColumnLength, "ColumnLength allows specification of  internal length of the column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnLength -> 123 Millimeter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ColumnLength],
				Quantity[123., "Millimeters"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ColumnType, "ColumnType allows specification of the scale of the chromatography to be performed on the column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnType -> Guard,
					SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ColumnType],
				Guard,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ColumnVolume, "ColumnVolume allows specification of the total volume of the column. This is the sum of the packing volume and the void volume:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnVolume -> 234 Milliliter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ColumnVolume],
				Quantity[234.`, "Milliliters"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, DefaultStorageCondition, "DefaultStorageCondition allows specification of the condition in which this model columns are stored when not in use by an experiment:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, DefaultStorageCondition[StorageCondition]],
				Refrigerator,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, DefaultStorageCondition, "If ExposedSurfaces is True and DefaultStorageCondition is Automatic, resolves to Ambient Storage, Lined Enclosed:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ExposedSurfaces -> True,
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, DefaultStorageCondition],
				ObjectP[Model[StorageCondition, "Ambient Storage, Lined Enclosed"]],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, DefaultStorageCondition, "If ExposedSurfaces is False and DefaultStorageCondition is Automatic, resolves to Ambient Storage:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ExposedSurfaces -> False,
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, DefaultStorageCondition],
				ObjectP[Model[StorageCondition, "Ambient Storage"]],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Example[{Options, StorageBuffer, "StorageBuffer allows specification of the preferred buffer used to keep the resin wet while the column is stored:"},
			newColumn=UploadColumn[
				"Dummy Column"<>$SessionUUID<>CreateUUID[],
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				Products -> {Object[Product, "UploadColumn Dummy Product"]},
				StorageBuffer -> Model[Sample, "id:8qZ1VWNmdLBD"]
			];
			Download[newColumn, StorageBuffer],
			ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
			TearDown :> {EraseObject[newColumn, Force -> True]}
		],
		Module[{newColumn},
			Example[{Options, Diameter, "Diameter allows specification of internal diameter of the column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					Diameter -> 12 Centimeter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, Diameter],
				Quantity[120.`, "Millimeters"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, Dimensions, "Dimensions allows specification of the external dimensions of this model of column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					Diameter -> 12 Centimeter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {12Centimeter, 13Centimeter, 14Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, Dimensions],
				{Quantity[0.12, "Meters"], Quantity[0.13, "Meters"], Quantity[0.14, "Meters"]},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ExposedSurfaces, "Indicates if any sensitive portions of this column are open to the external environment and prone to contamination:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ExposedSurfaces -> True,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ExposedSurfaces],
				True,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, FunctionalGroup, "FunctionalGroup allows specification of the functional group displayed on the column's stationary phase:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					FunctionalGroup -> Polysaccharide,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, FunctionalGroup],
				Polysaccharide,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, IncompatibleSolvents, "IncompatibleSolvents allows specification of chemicals that are incompatible for use with this column :"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					IncompatibleSolvents -> {Model[Sample, "Tap Water"]},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, IncompatibleSolvents],
				{ObjectP[Model[Sample, "Tap Water"]]},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, InletFilterMaterial, "InletFilterMaterial allows specification of the material of the inlet filter through which the sample must travel before reaching the stationary phase:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					InletFilterMaterial -> Cellulose,
					InletFilterThickness -> 5 Millimeter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, InletFilterMaterial],
				Cellulose,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, InletFilterPoreSize, "InletFilterPoreSize allows specification of the size of the pores in the inlet filter through which the sample must travel before reaching the stationary phase:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					InletFilterPoreSize -> 220 Nanometer,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, InletFilterPoreSize],
				Quantity[0.22`, "Micrometers"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],

		Module[{newColumn},
			Example[{Options, InletFilterThickness, "InletFilterThickness allows specification of the thickness of the inlet filter through which the sample must travel before reaching the stationary phase:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					InletFilterMaterial -> Cellulose,
					InletFilterThickness -> 5 Millimeter,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, InletFilterThickness],
				Quantity[5.`, "Millimeters"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxAcceleration, "MaxAcceleration allows specification of the maximum flow rate acceleration at which to ramp the speed of pumping solvent for this column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxAcceleration -> 1 Milliliter / Minute / Minute,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxAcceleration],
				Quantity[1.`, ("Milliliters") / ("Minutes")^2],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxFlowRate, "MaxFlowRate allows specification of the maximum flow rate at which the column performs:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxFlowRate -> 10 Milliliter / Minute,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxFlowRate],
				Quantity[10.`, ("Milliliters") / ("Minutes")],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxNumberOfUses, "MaxNumberOfUses allows specification of the maximum number of injections for which this column is recommended to be used:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxNumberOfUses -> 555,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxNumberOfUses],
				555,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxpH, "MaxpH allows specification of the maximum pH the column can handle:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxpH -> 12.5,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxpH],
				12.5,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxPressure, "MaxPressure allows specification of the maximum pressure the column can handle:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxPressure -> 2323 PSI,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxPressure],
				Quantity[2323.`, ("PoundsForce") / ("Inches")^2],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MaxTemperature, "MaxTemperature allows specification of the maximum temperature at which this column can function:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MaxTemperature -> 300 Kelvin,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MaxTemperature],
				Quantity[26.85`, "DegreesCelsius"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MinFlowRate, "MinFlowRate allows specification of the minimum flow rate at which the column performs:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MinFlowRate -> 1.5 Milliliter / Minute,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MinFlowRate],
				Quantity[1.5, ("Milliliters") / ("Minutes")],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MinpH, "MinpH allows specification of the minimum pH the column can handle:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MinpH -> 3.2,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MinpH],
				3.2,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, MinPressure, "MinPressure allows specification of the minimum pressure the column can handle.:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					MinPressure -> 500 PSI,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, MinPressure],
				Quantity[500.`, ("PoundsForce") / ("Inches")^2],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		], Module[{newColumn},
		Example[{Options, MinTemperature, "MinTemperature allows specification of the minimum temperature at which this column can function:"},
			newColumn=UploadColumn[
				"Dummy Column"<>$SessionUUID<>CreateUUID[],
				MinTemperature -> 25 Celsius,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumn Dummy Product"]}
			];
			Download[newColumn, MinTemperature],
			Quantity[25.`, "DegreesCelsius"],
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
			TearDown :> {EraseObject[newColumn, Force -> True]}
		]
	],
		Module[{newColumn,newName},
			Example[{Options, Name, "Name allows specification of the name of this column model:"},
				newName="Dummy Column"<>$SessionUUID<>"Name Column 1";
				newColumn=UploadColumn[
					newName,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, Name],
				"Dummy Column"<>$SessionUUID<>"Name Column 1",
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, NominalFlowRate, "NominalFlowRate allows specification of the nominal flow rate at which the column performs:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					NominalFlowRate -> 5 Milliliter / Minute,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, NominalFlowRate],
				Quantity[5.`, ("Milliliters") / ("Minutes")],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, PackingMaterial, "PackingMaterial allows specification of the chemical composition of the packing material in the column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					PackingMaterial -> KinetexCoreShell,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, PackingMaterial],
				KinetexCoreShell,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, PackingType, "PackingType allows specification of the method used to fill the column with the resin, be that by hand packing with loose solid resin, by inserting a disposable cartridge, or with a column which has been prepacked during manufacturing:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					PackingType -> HandPacked,
					ColumnType -> Preparative, SeparationMode -> NormalPhase,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, PackingType],
				HandPacked,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ParticleSize, "ParticleSize allows specification of the size of the particles that make up the column packing material:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ParticleSize -> 100 Nanometer,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ParticleSize],
				Quantity[0.1`, "Micrometers"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, PoreSize, "PoreSize allows specification of the average size of the pores within the column packing material:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					PoreSize -> 50 Angstrom,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, PoreSize],
				Quantity[50.`, "Angstroms"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, PreferredColumnJoin, "PreferredColumnJoin allows specification of the column join that best connects a column to this column:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					PreferredColumnJoin -> Model[Plumbing, ColumnJoin, "UploadColumn Dummy ColumnJoin"],
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, PreferredColumnJoin],
				LinkP[Model[Plumbing, ColumnJoin, "UploadColumn Dummy ColumnJoin"]],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, Products, "Products allows specification of the ordering information for this model:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					Products -> {Object[Product, "UploadColumn Dummy Product"]},
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"]
				];
				Download[newColumn, Products],
				{ObjectP[Object[Product, "UploadColumn Dummy Product"]]},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, StorageCaps, "StorageCaps allows specification of whether the column has special caps needed to be placed in between installation:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					StorageCaps -> True,
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"]
				];
				Download[newColumn, StorageCaps],
				True,
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ConnectorType, "ConnectorType allows specification of how the column is connected into the flow path:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ConnectorType -> FemaleMale,
					WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"]
				];
				Download[newColumn, Connectors],
				{{"Column Inlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}, {"Column Outlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Male}},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, ResinCapacity, "ResinCapacity allows specification of the weight of the resin that the column can be packed with:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ResinCapacity -> 20 Gram,
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500,
					Diameter -> 5 Centimeter,
					MinFlowRate -> Quantity[0.05`, ("Milliliters") / ("Minutes")],
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MinPressure -> Quantity[1.`, ("PoundsForce") / ("Inches")^2],
					MaxPressure -> Quantity[3400.`, ("PoundsForce") / ("Inches")^2],
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					WettedMaterials -> {CarbonSteel},
					Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, ResinCapacity],
				Quantity[20.`, "Grams"],
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn,newName},
			Example[{Options, Synonyms, "Synonyms allows specification of the list of possible alternative names this column model goes by:"},
				newName="Dummy Column"<>$SessionUUID<>"Name Column 2";
				newColumn=UploadColumn[
					newName,
					Synonyms -> {newName, "Fakey Column"},
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, Synonyms],
				{"Dummy Column"<>$SessionUUID<>"Name Column 2", "Fakey Column"},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, Upload, "Upload allows the return on an unuploaded packet object:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]},
					Upload -> False
				];
				newColumn,
				{PacketP[Model[Item, Column]]},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		],
		Module[{newColumn},
			Example[{Options, WettedMaterials, "WettedMaterials allows the return on an unuploaded packet object:"},
				newColumn=UploadColumn[
					"Dummy Column"<>$SessionUUID<>CreateUUID[],
					ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
					MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
					MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
					MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel, Ceramic}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
					Products -> {Object[Product, "UploadColumn Dummy Product"]}
				];
				Download[newColumn, WettedMaterials],
				{CarbonSteel, Ceramic},
				Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
				TearDown :> {EraseObject[newColumn, Force -> True]}
			]
		]
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Model[Item, Column, "Dummy Column"]],
			EraseObject[Model[Item, Column, "Dummy Column"], Force -> True]
		];

		If[!DatabaseMemberQ[Object[Product, "UploadColumn Dummy Product"]],
			Upload[<|
				Type -> Object[Product],
				Name -> "UploadColumn Dummy Product",
				Supplier -> Link[Object[Company, Supplier, "id:6V0npvK6Gxba"], Products],
				CatalogDescription -> "Fake Column",
				CatalogNumber -> "XXXXXX",
				Packaging -> Case,
				SampleType -> Cartridge,
				NumberOfItems -> 100,
				DeveloperObject -> True
			|>]
		];
	}
];

DefineTests[
	UploadColumnOptions,
	{
		Example[{Basic, "Inspect the calculated options for uploading a column:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],

		(* === OPTIONS === *)
		Example[{Options, CasingMaterial, "CasingMaterial allows specification of the material that the exterior of the column which houses the packing material is composed of:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				CasingMaterial -> ZirconiumOxide,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, SeparationMode, "SeparationMode allows specification of type of chromatography for which this column is suitable:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				SeparationMode -> SizeExclusion,
				ColumnType -> Preparative, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnLength, "ColumnLength allows specification of  internal length of the column:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				ColumnLength -> 123 Millimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnType, "ColumnType allows specification of the scale of the chromatography to be performed on the column:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				ColumnType -> Guard,
				SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnVolume, "ColumnVolume allows specification of the total volume of the column. This is the sum of the packing volume and the void volume:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				ColumnVolume -> 234 Milliliter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, DefaultStorageCondition, "DefaultStorageCondition allows specification of the condition in which this model columns are stored when not in use by an experiment:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, Diameter, "Diameter allows specification of internal diameter of the column:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				Diameter -> 12 Centimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, Dimensions, "Dimensions allows specification of the external dimensions of this model of column:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				Diameter -> 12 Centimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {12Centimeter, 13Centimeter, 14Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, FunctionalGroup, "FunctionalGroup allows specification of the functional group displayed on the column's stationary phase:"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				FunctionalGroup -> Polysaccharide,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, IncompatibleSolvents, "IncompatibleSolvents allows specification of chemicals that are incompatible for use with this column :"},
			UploadColumnOptions[
				"Test Column for UploadColumnOptions",
				IncompatibleSolvents -> {Model[Sample, "Tap Water"]},
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "UploadColumnOptions Test Product"]}
			],
			_Grid,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		]
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Model[Item, Column, "Test Column for UploadColumnOptions"]],
			EraseObject[Model[Item, Column, "Test Column for UploadColumnOptions"], Force -> True]
		];

		If[!DatabaseMemberQ[Object[Product, "UploadColumnOptions Test Product"]],
			Upload[<|
				Type -> Object[Product],
				Name -> "UploadColumnOptions Test Product",
				Supplier -> Link[Object[Company, Supplier, "id:6V0npvK6Gxba"], Products],
				CatalogDescription -> "Test Column",
				CatalogNumber -> "XXXXXX",
				Packaging -> Case,
				SampleType -> Cartridge,
				NumberOfItems -> 100,
				DeveloperObject -> True
			|>]
		];
	}
];


DefineTests[
	ValidUploadColumnQ,
	{
		Example[{Basic, "Inspect the calculated options for uploading a column:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],

		(* === OPTIONS === *)
		Example[{Options, CasingMaterial, "CasingMaterial allows specification of the material that the exterior of the column which houses the packing material is composed of:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				CasingMaterial -> ZirconiumOxide,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, SeparationMode, "SeparationMode allows specification of type of chromatography for which this column is suitable:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				SeparationMode -> SizeExclusion,
				ColumnType -> Preparative, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnLength, "ColumnLength allows specification of  internal length of the column:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				ColumnLength -> 123 Millimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnType, "ColumnType allows specification of the scale of the chromatography to be performed on the column:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				ColumnType -> Guard,
				SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, ColumnVolume, "ColumnVolume allows specification of the total volume of the column. This is the sum of the packing volume and the void volume:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				ColumnVolume -> 234 Milliliter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, DefaultStorageCondition, "DefaultStorageCondition allows specification of the condition in which this model columns are stored when not in use by an experiment:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, Diameter, "Diameter allows specification of internal diameter of the column:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				Diameter -> 12 Centimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, Dimensions, "Dimensions allows specification of the external dimensions of this model of column:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				Diameter -> 12 Centimeter,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {12Centimeter, 13Centimeter, 14Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, FunctionalGroup, "FunctionalGroup allows specification of the functional group displayed on the column's stationary phase:"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				FunctionalGroup -> Polysaccharide,
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		],
		Example[{Options, IncompatibleSolvents, "IncompatibleSolvents allows specification of chemicals that are incompatible for use with this column :"},
			ValidUploadColumnQ[
				"Test Column for ValidUploadColumnQ",
				IncompatibleSolvents -> {Model[Sample, "Tap Water"]},
				ColumnType -> Preparative, SeparationMode -> NormalPhase, PackingType -> Prepacked,
				MaxNumberOfUses -> 500, Diameter -> 5 Centimeter,
				MinFlowRate -> 1 Milliliter / Minute, MaxFlowRate -> 100 Milliliter / Minute,
				MinPressure -> 1000 PSI, MaxPressure -> 5000 PSI,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"], WettedMaterials -> {CarbonSteel}, Dimensions -> {1Centimeter, 1Centimeter, 10Centimeter},
				Products -> {Object[Product, "ValidUploadColumnQ Test Product"]}
			],
			BooleanP,
			Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]}
		]
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Model[Item, Column, "Test Column for ValidUploadColumnQ"]],
			EraseObject[Model[Item, Column, "Test Column for ValidUploadColumnQ"], Force -> True]
		];

		If[!DatabaseMemberQ[Object[Product, "ValidUploadColumnQ Test Product"]],
			Upload[<|
				Type -> Object[Product],
				Name -> "ValidUploadColumnQ Test Product",
				Supplier -> Link[Object[Company, Supplier, "id:6V0npvK6Gxba"], Products],
				CatalogDescription -> "Test Column",
				CatalogNumber -> "XXXXXX",
				Packaging -> Case,
				SampleType -> Cartridge,
				NumberOfItems -> 100,
				DeveloperObject -> True
			|>]
		];
	}
];

(* ::Subsection::Closed:: *)
(*UploadPipettingMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethod*)


DefineTests[UploadPipettingMethod,
	{
		Example[{Basic, "Create a new pipetting method with a specified name and parameters:"},
			UploadPipettingMethod[
				"Test pipetting method for UploadPipettingMethod",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				Model -> Model[Sample, "Test Chemical for UploadPipettingMethod"]
			],
			ObjectReferenceP[Model[Method, Pipetting, "Test pipetting method for UploadPipettingMethod"]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Basic, "Create a new pipetting method with no name:"},
			UploadPipettingMethod[
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				Model -> Model[Sample, "Test Chemical for UploadPipettingMethod"]
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, Model, "Specify the model(s) which should use the created pipetting method by default:"},
			(
				UploadPipettingMethod[
					"Test pipetting method for UploadPipettingMethod tied to model",
					AspirationRate -> 50 Microliter / Second,
					DispenseRate -> 200 Microliter / Second,
					Model -> Model[Sample, "Test Chemical for UploadPipettingMethod"]
				];
				Download[
					Model[Sample, "Test Chemical for UploadPipettingMethod"],
					PipettingMethod[Object]
				]
			),
			ObjectReferenceP[Model[Method, Pipetting, "Test pipetting method for UploadPipettingMethod tied to model"]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationRate, "Specify the rate at which liquid should be aspirated using the created method:"},
			UploadPipettingMethod[AspirationRate -> 50 Microliter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispenseRate, "Specify the rate at which liquid should be dispensed using the created method:"},
			UploadPipettingMethod[DispenseRate -> 250 Microliter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispenseRate, "If unspecified, DispenseRate is inherited from AspirationRate:"},
			(
				myMethod=UploadPipettingMethod[AspirationRate -> 250 Microliter / Second];
				Download[myMethod, DispenseRate]
			),
			250 Microliter / Second,
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False]),
			Variables -> {myMethod}
		],
		Example[{Options, OverAspirationVolume, "Specify the volume of air drawn into the pipette tip at the end of the aspiration of a liquid:"},
			UploadPipettingMethod[OverAspirationVolume -> 30 Microliter],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, OverDispenseVolume, "Specify the volume of air drawn blown out at the end of the dispensing of a liquid:"},
			UploadPipettingMethod[OverDispenseVolume -> 50 Microliter],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationWithdrawalRate, "Specify the speed at which the pipette is removed from the liquid after an aspiration:"},
			UploadPipettingMethod[AspirationWithdrawalRate -> 0.5 Millimeter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispenseWithdrawalRate, "Specify the speed at which the pipette is removed from the liquid after a dispense:"},
			UploadPipettingMethod[DispenseWithdrawalRate -> 5 Millimeter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationEquilibrationTime, "Specify the delay length the pipette waits after aspirating before it is removed from the liquid:"},
			UploadPipettingMethod[AspirationEquilibrationTime -> 5 Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispenseEquilibrationTime, "Specify the delay length the pipette waits after dispensing before it is removed from the liquid:"},
			UploadPipettingMethod[DispenseEquilibrationTime -> 0.5 Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationMixRate, "Specify the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated:"},
			UploadPipettingMethod[AspirationMixRate -> 250 Microliter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispenseMixRate, "Specify the speed at which liquid is aspirated and dispensed in a liquid after a dispense:"},
			UploadPipettingMethod[DispenseMixRate -> 30 Microliter / Second],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationPosition, "Specify the location from which liquid should be aspirated:"},
			UploadPipettingMethod[
				AspirationPosition -> LiquidLevel,
				AspirationPositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationPosition, "If unspecified, AspirationPosition and DispensePosition will be Null and determined at runtime based on the container a sample is in:"},
			(
				myMethod=UploadPipettingMethod[AspirationRate -> 100 Microliter / Second];
				Download[myMethod, {AspirationPosition, DispensePosition}]
			),
			{Null, Null},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False]),
			Variables -> {myMethod}
		],
		Example[{Options, DispensePosition, "Specify the location from which liquid should be dispensed:"},
			UploadPipettingMethod[
				DispensePosition -> Bottom,
				DispensePositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispensePosition, "If DispensePosition is unspecified but DispensePositionOffset is specified, DispensePosition resolves to LiquidLevel:"},
			(
				myMethod=UploadPipettingMethod[
					AspirationPosition -> Bottom,
					AspirationPositionOffset -> 2 Millimeter,
					DispensePositionOffset -> 3 Millimeter
				];
				Download[myMethod, DispensePosition]
			),
			LiquidLevel,
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False]),
			Variables -> {myMethod}
		],
		Example[{Options, AspirationPositionOffset, "Specify the distance from the top of the container from which liquid should be aspirated:"},
			UploadPipettingMethod[
				AspirationPosition -> Top,
				AspirationPositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationPositionOffset, "Specify the distance from the bottom of the container from which liquid should be aspirated:"},
			UploadPipettingMethod[
				AspirationPosition -> Bottom,
				AspirationPositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, AspirationPositionOffset, "Specify the distance from the top of the liquid level from which liquid should be aspirated:"},
			UploadPipettingMethod[
				AspirationPosition -> LiquidLevel,
				AspirationPositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispensePositionOffset, "Specify the distance from the top from which liquid should be dispensed:"},
			UploadPipettingMethod[
				DispensePosition -> Top,
				DispensePositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispensePositionOffset, "Specify the distance from the bottom from which liquid should be dispensed:"},
			UploadPipettingMethod[
				DispensePosition -> Bottom,
				DispensePositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, DispensePositionOffset, "Specify the distance from the top of the liquid level from which liquid should be dispensed:"},
			UploadPipettingMethod[
				DispensePosition -> LiquidLevel,
				DispensePositionOffset -> 3 Millimeter
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Options, CorrectionCurve, "Specify the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 0 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1100 Microliter}
				}
			],
			ObjectReferenceP[],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "ExistingPipettingMethod", "A warning is thrown if the specified Model object(s) already have a PipettingMethod that will be overwritten:"},
			(
				UploadPipettingMethod[
					"Initial PipettingMethod for UploadPipettingMethod test",
					Model -> Model[Sample, "Test Chemical for UploadPipettingMethod"],
					AspirationRate -> 100 Microliter / Second,
					DispenseRate -> 200 Microliter / Second
				];
				UploadPipettingMethod[
					"Updated PipettingMethod for UploadPipettingMethod test",
					Model -> Model[Sample, "Test Chemical for UploadPipettingMethod"],
					AspirationRate -> 100 Microliter / Second,
					DispenseRate -> 200 Microliter / Second
				];
				Download[
					Model[Sample, "Test Chemical for UploadPipettingMethod"],
					PipettingMethod[Object]
				]
			),
			ObjectReferenceP[Model[Method, Pipetting, "Updated PipettingMethod for UploadPipettingMethod test"]],
			Messages :> {Warning::ExistingPipettingMethod},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "ModelNotLiquid", "A warning is thrown if the specified Model object(s) does not have a Liquid state:"},
			UploadPipettingMethod[
				Model -> Model[Sample, "Test Solid Chemical for UploadPipettingMethod"],
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			ObjectReferenceP[],
			Messages :> {Warning::ModelNotLiquid},
			SetUp :> (
				$CreatedObjects={};
				Upload[
					Association[
						Type -> Model[Sample],
						Name -> "Test Solid Chemical for UploadPipettingMethod",
						State -> Solid
					]
				]
			),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "CorrectionCurveNotMonotonic", "A warning is thrown if the specified CorrectionCurve does not have monotonically increasing actual volume values:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 0 Microliter},
					{50 Microliter, 60 Microliter},
					{60 Microliter, 55 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				}
			],
			ObjectReferenceP[],
			Messages :> {Warning::CorrectionCurveNotMonotonic},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "CorrectionCurveIncomplete", "A warning is thrown if the specified CorrectionCurve does not covers the max transfer volume 1000 uL:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 0 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter}
				}
			],
			ObjectReferenceP[],
			Messages :> {Warning::CorrectionCurveIncomplete},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "CorrectionCurveIncomplete", "A warning is thrown if the specified CorrectionCurve does not covers the min transfer volume 0 uL:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				}
			],
			ObjectReferenceP[],
			Messages :> {Warning::CorrectionCurveIncomplete},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		],
		Example[{Messages, "InvalidCorrectionCurveZeroValue", "A CorrectionCurve with a 0 Microliter target volume entry must have a 0 Microliter actual volume value:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 5 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::InvalidCorrectionCurveZeroValue}
		],
		Example[{Messages, "RoundedCorrectionCurve", "A warning is thrown if the specified CorrectionCurve has values with precision greater than 0.1 Microliter:"},
			UploadPipettingMethod[
				AspirationRate -> 100 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 0 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180.46 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				}
			],
			ObjectReferenceP[],
			Messages :> {Warning::RoundedCorrectionCurve},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (EraseObject[$CreatedObjects, Force -> True, Verbose -> False])
		]
	},
	SymbolSetUp :> (
		Upload[
			Association[
				Type -> Model[Sample],
				Name -> "Test Chemical for UploadPipettingMethod",
				State -> Liquid
			]
		]
	),
	SymbolTearDown :> (
		EraseObject[Model[Sample, "Test Chemical for UploadPipettingMethod"], Force -> True, Verbose -> False]
	)
];



(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethodModelOptions*)


DefineTests[UploadPipettingMethodModelOptions,
	{
		Example[{Basic, "Returns the resolved options for generating a pipetting method when given a name and options:"},
			UploadPipettingMethodModelOptions[
				"Test pipetting method for UploadPipettingMethodModelOptions",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			_Grid
		],
		Example[{Basic, "Returns the resolved options for generating a pipetting method when given options but no name:"},
			UploadPipettingMethodModelOptions[
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			_Grid
		],
		Example[{Options, Output, "Returns the resolved options as a list for generating a pipetting method when given when given options and a name:"},
			UploadPipettingMethodModelOptions[
				"Test pipetting method for UploadPipettingMethodModelOptions",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				OutputFormat -> List
			],
			{_Rule..}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethodModelPreview*)


DefineTests[UploadPipettingMethodModelPreview,
	{
		Example[{Basic, "Returns Null for generating a pipetting method when given a name and options:"},
			UploadPipettingMethodModelPreview[
				"Test pipetting method for UploadPipettingMethodModelPreview",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			Null
		],
		Example[{Basic, "Returns Null for generating a pipetting method when given options but no name:"},
			UploadPipettingMethodModelPreview[
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			Null
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadPipettingMethodModelQ*)


DefineTests[ValidUploadPipettingMethodModelQ,
	{
		Example[{Basic, "If all tests from UploadPipettingMethod pass, return True"},
			ValidUploadPipettingMethodModelQ[
				"Test pipetting method for ValidUploadPipettingMethodModelQ",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second
			],
			True
		],
		Example[{Basic, "If any tests from UploadPipettingMethod fail, return False"},
			ValidUploadPipettingMethodModelQ[
				"Test pipetting method for ValidUploadPipettingMethodModelQ",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				CorrectionCurve -> {
					{0 Microliter, 5 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter}
				}
			],
			False
		],
		Example[{Options, Verbose, "Print the list of tests and their results in addition to returning the overall result:"},
			ValidUploadPipettingMethodModelQ[
				"Test pipetting method for ValidUploadPipettingMethodModelQ",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				Verbose -> True
			],
			True
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidUploadPipettingMethodModelQ[
				"Test pipetting method for ValidUploadPipettingMethodModelQ",
				AspirationRate -> 50 Microliter / Second,
				DispenseRate -> 200 Microliter / Second,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	}
];


(* ::Subsection::Closed:: *)
(*UploadGradientMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethod*)


DefineTests[UploadGradientMethod,
	{
		Example[{Basic, "Create a new gradient method based on the provided inputs:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			ObjectReferenceP[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID]]
		],
		Example[{Basic, "Create a new gradient method without a name:"},
			myGradient=UploadGradientMethod[
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			ObjectReferenceP[Object[Method, Gradient]],
			Variables :> {myGradient}
		],
		Example[{Additional, "If not all timepoints are specified for all specified options, interpolates to fill in the missing timepoints:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				GradientA -> {
					{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"]},
					{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"]},
					{Quantity[10.`, "Minutes"], Quantity[15.`, "Percent"]},
					{Quantity[20.`, "Minutes"], Quantity[90.`, "Percent"]}
				},
				FlowRate -> {
					{Quantity[0.`, "Minutes"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[20.`, "Minutes"], Quantity[2.5, ("Milliliters") / ("Minutes")]}
				}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, -1]],
			{Quantity[0.5, ("Milliliters") / ("Minutes")],
				Quantity[1., ("Milliliters") / ("Minutes")],
				Quantity[1.5, ("Milliliters") / ("Minutes")],
				Quantity[2.5, ("Milliliters") / ("Minutes")]},
			EquivalenceFunction -> Equal
		],

		(* --- Options --- *)
		Example[{Options, BufferA, "Specify the chemical or stock solution used as Buffer A:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferA],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferB, "Specify the chemical or stock solution used as Buffer B:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferB -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferB],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferC, "Specify the chemical or stock solution used as Buffer C:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferC],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferD, "Specify the chemical or stock solution used as Buffer D:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferD -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferD],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferE, "Specify the chemical or stock solution used as Buffer E:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferE -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferE],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferF, "Specify the chemical or stock solution used as Buffer F:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferF -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferF],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferG, "Specify the chemical or stock solution used as Buffer G:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferG -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferG],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, BufferH, "Specify the chemical or stock solution used as Buffer H:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, BufferH -> Model[Sample, "Acetonitrile, HPLC Grade"]];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], BufferH],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]]
		],
		Example[{Options, Temperature, "Specify the temperature:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, Temperature -> 50Celsius];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Temperature],
			Quantity[50.`, "DegreesCelsius"]
		],
		Example[{Options, Temperature, "Temperature automatically resolves to Ambient and then uploaded as Null temperature:"},
			Module[
				{options,result},
				{options,result}=UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,Output->{Options,Result}];
				{
					Lookup[options,Temperature],
					Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Temperature]
				}
			],
			{Ambient,Null}
		],
		Example[{Options, Temperature, "Specify the temperature as ambient:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, Temperature -> Ambient];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Temperature],
			Null,
			EquivalenceFunction -> Equal
		],
		Example[{Options, GradientA, "Specify the gradient for buffer A:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientA -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 2}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientB, "Specify the gradient for buffer B:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientB -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 3}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientC, "Specify the gradient for buffer C:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientC -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 4}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientD, "Specify the gradient for buffer D:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientD -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 5}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientE, "Specify the gradient for buffer E:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientE -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 6}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientF, "Specify the gradient for buffer F:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientF -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 7}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientG, "Specify the gradient for buffer G:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientG -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 8}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, GradientH, "Specify the gradient for buffer H:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, GradientH -> {
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, 9}]],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
				{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
				{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
				{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
			}
		],
		Example[{Options, FlowRate, "Specify the flow rate:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID, FlowRate -> {
				{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
				{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
				{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
				{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
				{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
				{Quantity[35.1, "Minutes"], Quantity[2, ("Milliliters") / ("Minutes")]},
				{Quantity[40., "Minutes"], Quantity[2, ("Milliliters") / ("Minutes")]}}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient][[All, {1, -1}]],
			{
				{Quantity[0.`, "Minutes"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[5.`, "Minutes"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.`, "Minutes"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.1`, "Minutes"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[35.`, "Minutes"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[35.1`, "Minutes"], Quantity[2.`, ("Milliliters") / ("Minutes")]},
				{Quantity[40.`, "Minutes"], Quantity[2.`, ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, GradientStart, "Use shorthand annotation to specify the starting Buffer B composition. This option must be specified with GradientEnd and GradientDuration:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientStart -> 10 Percent,
				GradientEnd -> 50 Percent,
				GradientDuration -> 10 Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
				{Quantity[10., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, GradientEnd, "Use shorthand annotation to specify the final Buffer B composition. This option must be specified with GradientStart and GradientDuration:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientStart -> 10 Percent,
				GradientEnd -> 50 Percent,
				GradientDuration -> 10 Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
				{Quantity[10., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, GradientDuration, "Use shorthand annotation to specify the duration of a gradient. This option must be specified with GradientEnd and GradientStart:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientStart -> 10 Percent,
				GradientEnd -> 50 Percent,
				GradientDuration -> 10 Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
				{Quantity[10., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}
			},
			TearDown :> {
				EraseObject[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Force -> True, Verbose -> False]
			}
		],
		Example[{Options, FlushTime, "Use shorthand annotation to specify the amount of time 100% Buffer B is run at the end of the gradient. This option must be specified with GradientEnd, GradientStart, and GradientDuration:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				FlushTime -> 10 Minute,
				GradientStart -> 10 Percent,
				GradientEnd -> 50 Percent,
				GradientDuration -> 10 Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], {FlushTime, Gradient}],
			{
				Quantity[10., "Minutes"],
				{
					{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
					{Quantity[10., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
					{Quantity[10.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
					{Quantity[20.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}
				}
			}
		],
		Example[{Options, EquilibrationTime, "Use shorthand annotation to specify the amount of time the initial buffer composition is run at the start of the gradient. This option must be specified with GradientEnd, GradientStart, and GradientDuration:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				EquilibrationTime -> 5 Minute,
				GradientStart -> 10 Percent,
				GradientEnd -> 50 Percent,
				GradientDuration -> 10 Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], {EquilibrationTime, Gradient}],
			{Quantity[5., "Minutes"],
				{
					{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
					{Quantity[15., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}
				}
			}
		],
		Example[{Options, Gradient, "Specify the gradient (binary version):"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> {
					{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
				}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, Gradient, "Specify the gradient (4 column version):"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> {
					{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
				}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, Gradient, "Specify the gradient (8 column version):"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> {
					{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
				}
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[5.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.`, "Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[30.1`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
				{Quantity[35.`, "Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
			}
		],
		Example[{Options, Gradient, "Copy a pre-existing gradient:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID]
			];
			MatchQ[Download[
				Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], {BufferA[Object], BufferB[Object], BufferC[Object], BufferD[Object], Temperature, Gradient}],
				Download[Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID], {BufferA[Object], BufferB[Object], BufferC[Object], BufferD[Object], Temperature, Gradient}]],
			True
		],
		Example[{Options, Gradient, "Use a pre-existing gradient as a template for non-specified options:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID],
				BufferA -> Model[Sample, "Methanol"],
				Temperature -> 30Celsius,
				FlowRate -> 0.2Milliliter / Minute
			];
			Download[Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID], {BufferA[Object], BufferB[Object], BufferC[Object], BufferD[Object], Temperature, Gradient}],
			{
				Model[Sample, "id:vXl9j5qEnnRD"],
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Null,
				Null,
				Quantity[30., "DegreesCelsius"],
				{
					{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.2, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.2, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"], Quantity[85., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.2, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.2, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.2, ("Milliliters") / ("Minutes")]}
				}
			}
		],


		(* --- Messages --- *)
		Example[{Messages, "RemovedExtraGradientEntries", "Handle precision issues gracefully and remove duplicate entries:"},
			UploadGradientMethod["Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> {
					{Quantity[0.`, "Seconds"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[5.`, "Seconds"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.5`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.`, "Seconds"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1`, "Seconds"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]},
					{Quantity[35.`, "Seconds"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"], Quantity[0.`, "Percent"], Quantity[0.`, "Percent"], Quantity[1.`, ("Milliliters") / ("Minutes")]}
				}
			];
			Download[Object[Method, Gradient, "Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID], Gradient],
			{
				{Quantity[0., "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
				{Quantity[0.08333333333333333`, "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
				{Quantity[0.5, "Minutes"], Quantity[15., "Percent"], Quantity[85., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]},
				{Quantity[0.58333333333333333`, "Minutes"], Quantity[90., "Percent"], Quantity[10., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters") / ("Minutes")]}},
			EquivalenceFunction -> Equal,
			TearDown :> {
				EraseObject[Object[Method, Gradient, "Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID], Force -> True, Verbose -> False]
			},
			Messages :> {Warning::InstrumentPrecision, Warning::RemovedExtraGradientEntries}
		],
		Example[{Messages, "DuplicateName", "Fails if the specified name is already in use:"},
			UploadGradientMethod["Preexisting gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID],
				BufferA -> Model[Sample, "Methanol"],
				Temperature -> 30Celsius,
				FlowRate -> 0.2Milliliter / Minute
			],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidInput}
		],
		Example[{Messages, "GradientStartInvalid", "Fails if GradientStart is specified but GradientEnd and GradientDuration are not:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientStart -> 10 Percent,
				GradientDuration -> 10 Minute
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ShorthandGradientInvalid}
		],
		Example[{Messages, "ShorthandGradientInvalid", "Fails if GradientEnd is specified but GradientStart and GradientDuration are not:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientEnd -> 10 Percent,
				GradientDuration -> 10 Minute
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ShorthandGradientInvalid}
		],
		Example[{Messages, "ShorthandGradientInvalid", "Fails if GradientDuration is specified but GradientEnd and GradientStart are not:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				GradientEnd -> 10 Percent,
				GradientDuration -> 10 Minute
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ShorthandGradientInvalid}
		],
		Example[{Messages, "FlushTimeInvalid", "Fails if FlushTime is specified but GradientDuration, GradientEnd and GradientStart are not:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				FlushTime -> 4Minute
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::FlushTimeInvalid}
		],
		Example[{Messages, "EquilibrationTimeInvalid", "Fails if EquilibrationTime is specified but GradientDuration, GradientEnd and GradientStart are not:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				EquilibrationTime -> 4Minute
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::EquilibrationTimeInvalid}
		],
		Example[{Messages, "GradientInvalid", "Fails if the buffer composition does not add to 100% at all timepoints:"},
			UploadGradientMethod["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				Gradient -> {{5 Minute, 10 Percent, 10 Percent, 10 Percent, 10 Percent, 1 Milliliter / Minute}}
			],
			$Failed,
			Messages :> {Message[Error::InvalidOption, {Gradient}], Message[Error::GradientInvalid, {Gradient}]}
		]

	},
	SetUp :> {
		Module[{namedObjects},
			namedObjects={
				Object[Method, Gradient, "Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID],
				Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	},
	SymbolSetUp :> (
		Module[{namedObjects},
			namedObjects={
				Object[Method, Gradient, "Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID],
				Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID],
				Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];
		Module[{},
			UploadGradientMethod["Preexisting gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			]
		]
	),
	SymbolTearDown :> (
		Module[{namedObjects},
			namedObjects={
				Object[Method, Gradient, "Test overly precise gradient method for UploadGradientMethod"<>$SessionUUID],
				Object[Method, Gradient, "Preexisting gradient method for UploadGradientMethod"<>$SessionUUID],
				Object[Method, Gradient, "Test gradient method for UploadGradientMethod"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	)
];



(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodOptions*)


DefineTests[UploadGradientMethodOptions,
	{
		Example[{Basic, "Returns the options for generating a gradient method when given a name and options:"},
			UploadGradientMethodOptions["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			Graphics_
		],
		Example[{Basic, "Returns the options for generating a gradient method when given options and no name:"},
			UploadGradientMethodOptions[
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			Graphics_
		],
		Example[{Options, Output, "Returns the options as a list for generating a gradient method when given when given options and no name:"},
			UploadGradientMethodOptions["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				},
				OutputFormat -> List
			],
			{BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"], BufferC -> Null,
				BufferD -> Null, BufferE -> Null, BufferF -> Null, BufferG -> Null,
				BufferH -> Null, Temperature -> Quantity[50, "DegreesCelsius"],
				GradientA -> {{Quantity[0.`, "Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[5.`, "Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[30.`, "Minutes"],
					Quantity[15.`, "Percent"]}, {Quantity[30.099999999999998`,
					"Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[35.`, "Minutes"],
					Quantity[90.`, "Percent"]}},
				GradientB -> {{Quantity[0.`, "Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[5.`, "Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[30.`, "Minutes"],
					Quantity[85.`, "Percent"]}, {Quantity[30.099999999999998`,
					"Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[35.`, "Minutes"],
					Quantity[10.`, "Percent"]}}, GradientC -> Quantity[0, "Percent"],
				GradientD -> Quantity[0, "Percent"],
				GradientE -> Quantity[0, "Percent"],
				GradientF -> Quantity[0, "Percent"],
				GradientG -> Quantity[0, "Percent"],
				GradientH -> Quantity[0, "Percent"],
				FlowRate -> {{Quantity[0.`, "Minutes"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[5.`,
					"Minutes"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[30.`,
					"Minutes"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[
					30.099999999999998`, "Minutes"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[35.`,
					"Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}},
				Gradient -> {{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"],
					Quantity[10.`, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[5.`,
					"Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[30.`,
					"Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[
					30.099999999999998`, "Minutes"], Quantity[90.`, "Percent"],
					Quantity[10.`, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[35.`,
					"Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}}, GradientStart -> Null,
				GradientEnd -> Null, GradientDuration -> Null,
				EquilibrationTime -> Null, FlushTime -> Null, Output -> Options,
				Upload -> True},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Output, "Returns the options as a list for generating a gradient method when given options and no name:"},
			UploadGradientMethodOptions[
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				},
				OutputFormat -> List
			],
			{BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"], BufferC -> Null,
				BufferD -> Null, BufferE -> Null, BufferF -> Null, BufferG -> Null,
				BufferH -> Null, Temperature -> Quantity[50, "DegreesCelsius"],
				GradientA -> {{Quantity[0.`, "Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[5.`, "Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[30.`, "Minutes"],
					Quantity[15.`, "Percent"]}, {Quantity[30.099999999999998`,
					"Minutes"],
					Quantity[90.`, "Percent"]}, {Quantity[35.`, "Minutes"],
					Quantity[90.`, "Percent"]}},
				GradientB -> {{Quantity[0.`, "Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[5.`, "Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[30.`, "Minutes"],
					Quantity[85.`, "Percent"]}, {Quantity[30.099999999999998`,
					"Minutes"],
					Quantity[10.`, "Percent"]}, {Quantity[35.`, "Minutes"],
					Quantity[10.`, "Percent"]}}, GradientC -> Quantity[0, "Percent"],
				GradientD -> Quantity[0, "Percent"],
				GradientE -> Quantity[0, "Percent"],
				GradientF -> Quantity[0, "Percent"],
				GradientG -> Quantity[0, "Percent"],
				GradientH -> Quantity[0, "Percent"],
				FlowRate -> {{Quantity[0.`, "Minutes"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[5.`,
					"Minutes"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[30.`,
					"Minutes"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[
					30.099999999999998`, "Minutes"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[35.`,
					"Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}},
				Gradient -> {{Quantity[0.`, "Minutes"], Quantity[90.`, "Percent"],
					Quantity[10.`, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[5.`,
					"Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0.5`, ("Milliliters") / ("Minutes")]}, {Quantity[30.`,
					"Minutes"], Quantity[15.`, "Percent"], Quantity[85.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[
					30.099999999999998`, "Minutes"], Quantity[90.`, "Percent"],
					Quantity[10.`, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}, {Quantity[35.`,
					"Minutes"], Quantity[90.`, "Percent"], Quantity[10.`, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[0, "Percent"], Quantity[0, "Percent"],
					Quantity[1, ("Milliliters") / ("Minutes")]}}, GradientStart -> Null,
				GradientEnd -> Null, GradientDuration -> Null,
				EquilibrationTime -> Null, FlushTime -> Null, Output -> Options,
				Upload -> True},
			EquivalenceFunction -> Equal
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadGradientMethodQ*)


DefineTests[ValidUploadGradientMethodQ,
	{
		Example[{Basic, "If all tests from the function pass, returns True:"},
			ValidUploadGradientMethodQ["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			True
		],
		Example[{Basic, "If all tests from the function pass, returns True:"},
			ValidUploadGradientMethodQ[
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			True
		],
		Example[{Basic, "If any tests from the experiment call fail, returns False:"},
			ValidUploadGradientMethodQ[
				GradientStart -> 80Percent
			],
			False
		],
		Example[{Options, Verbose, "Print the list of tests and their results in addition to returning the overall result:"},
			ValidUploadGradientMethodQ[GradientStart -> 80Percent, Verbose -> True],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidUploadGradientMethodQ[GradientStart -> 80Percent, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodPreview*)


DefineTests[UploadGradientMethodPreview,
	{

		Example[{Basic, "Returns Null when options and input are valid:"},
			UploadGradientMethodPreview["Test gradient method for UploadGradientMethod"<>$SessionUUID,
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			Null
		],
		Example[{Basic, "Returns Null for when options are valid:"},
			UploadGradientMethodPreview[
				BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferB -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Temperature -> 50Celsius,
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[90., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[15., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[90., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[90., "Percent"]}
				},
				FlowRate -> {
					{Quantity[0., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[5., "Minutes"], Quantity[0.5, ("Milliliters") / ("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[1, ("Milliliters") / ("Minutes")]}
				}
			],
			Null
		],
		Example[{Basic, "Returns Null when options are invalid:"},
			UploadGradientMethodPreview[GradientStart -> 80Percent],
			Null,
			Messages :> {Message[Error::InvalidOption, {GradientEnd, GradientDuration}], Message[Error::ShorthandGradientInvalid]}
		]
	}
];


(* ::Subsection::Closed:: *)
(*UploadJournal*)


(* ::Subsubsection::Closed:: *)
(*UploadJournal*)


DefineTests[UploadJournal,
	{
		Example[{Basic, "Create a new journal based on the provided inputs:"},
			UploadJournal["Nature (UploadJournal Test)"],
			ObjectP[Object[Journal]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			}
		],
		(* --- Options --- *)
		Example[{Options, Synonyms, "Provide synonyms for the newly created journal:"},
			journal=UploadJournal["Journal of the American Chemical Society (UploadJournal Test)",
				Synonyms -> {"JACS (Test)", "J.Am.Chem.Soc. (Test)"}
			];
			Download[journal, Synonyms],
			{OrderlessPatternSequence["Journal of the American Chemical Society (UploadJournal Test)", "JACS (Test)", "J.Am.Chem.Soc. (Test)"]},
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Journal of the American Chemical Society (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Journal of the American Chemical Society (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Journal of the American Chemical Society (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Journal of the American Chemical Society (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, Website, "Specify the website of the journal:"},
			UploadJournal["Nature (UploadJournal Test)",
				Website -> "https://www.nature.com/"
			],
			ObjectP[Object[Journal]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			}
		],
		Example[{Options, SubjectAreas, "Provide the area of subjects of the journal:"},
			journal=UploadJournal["Nature (UploadJournal Test)",
				SubjectAreas -> {Multidiscipline}
			];
			Download[journal, SubjectAreas],
			{Multidiscipline},
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, OpenAccess, "Specify the articles published in this journal can be accessed for free:"},
			journal=UploadJournal["PLOSOne (UploadJournal Test)",
				OpenAccess -> True
			];
			Download[journal, OpenAccess],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "PLOSOne (UploadJournal Test)"]],
					EraseObject[Object[Journal, "PLOSOne (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "PLOSOne (UploadJournal Test)"]],
					EraseObject[Object[Journal, "PLOSOne (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, PublicationFrequency, "Specify how often the journal publishes a new issue:"},
			journal=UploadJournal["Nature (UploadJournal Test)",
				PublicationFrequency -> Weekly
			];
			Download[journal, PublicationFrequency],
			Weekly,
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, ISSN, "Provide ISSN of this journal:"},
			journal=UploadJournal["Nature (UploadJournal Test)",
				ISSN -> "0028-0836"
			];
			Download[journal, ISSN],
			"0028-0836",
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, OnlineISSN, "Provide Online-ISSN of this journal:"},
			journal=UploadJournal["Nature (UploadJournal Test)",
				OnlineISSN -> "1476-4687"
			];
			Download[journal, OnlineISSN],
			"1476-4687",
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, Address, "Provide office address of the publishing group:"},
			journal=UploadJournal["Nature (UploadJournal Test)",
				Address -> "One New York Plaza,Suite 4500, New York NY, 10004-1562 USA"
			];
			Download[journal, Address],
			"One New York Plaza,Suite 4500, New York NY, 10004-1562 USA",
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		Example[{Options, Discontinued, "Specify if the journal does no longer publish new issues:"},
			journal=UploadJournal["Advanced Materials Letters (UploadJournal Test)",
				Discontinued -> True
			];
			Download[journal, Discontinued],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Advanced Materials Letters (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Advanced Materials Letters (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Advanced Materials Letters (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Advanced Materials Letters (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		],
		(* --- Messages --- *)
		Example[{Messages, "JournalNameAlreadyExists", "If the journal already exists in the database, return an error:"},
			UploadJournal["Existing Journal - Example"],
			$Failed,
			Messages :> {
				Error::InvalidInput,
				Error::JournalNameAlreadyExists
			},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Test["The newly-created object pass VOQ:",
			journal=UploadJournal["Nature (UploadJournal Test)"];
			ValidObjectQ[journal],
			True,
			SetUp :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Journal, "Nature (UploadJournal Test)"]],
					EraseObject[Object[Journal, "Nature (UploadJournal Test)"], Force -> True, Verbose -> False]
				]
			},
			Variables :> {journal}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadJournalOptions*)


DefineTests[UploadJournalOptions,
	{
		Example[{Basic, "Create a new journal based on the provided inputs:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)", OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		(* --- Options --- *)
		Example[{Options, Synonyms, "Provide synonyms for the newly created journal:"},
			UploadJournalOptions["Journal of the American Chemical Society (UploadJournalOptions Test)",
				Synonyms -> {"JACS (Test)", "J.Am.Chem.Soc. (Test)"},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, Website, "Specify the website of the journal:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				Website -> "https://www.nature.com/",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, SubjectAreas, "Provide the area of subjects of the journal:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				SubjectAreas -> {Multidiscipline},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OpenAccess, "Specify the articles published in this journal can be accessed for free:"},
			UploadJournalOptions["PLOSOne (UploadJournalOptions Test)",
				OpenAccess -> True,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, PublicationFrequency, "Specify how often the journal publishes a new issue:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				PublicationFrequency -> Weekly,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, ISSN, "Provide ISSN of this journal:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				ISSN -> "0028-0836",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OnlineISSN, "Provide Online-ISSN of this journal:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				OnlineISSN -> "1476-4687",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, Address, "Provide office address of the publishing group:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)",
				Address -> "One New York Plaza,Suite 4500, New York NY, 10004-1562 USA",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, Discontinued, "Specify if the journal does no longer publish new issues:"},
			UploadJournalOptions["Advanced Materials Letters (UploadJournalOptions Test)",
				Discontinued -> True,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table form:"},
			UploadJournalOptions["Nature (UploadJournalOptions Test)", OutputFormat -> Table],
			Graphics_
		],
		(* --- Messages --- *)
		Example[{Messages, "JournalNameAlreadyExists", "If the journal already exists in the database, return an error:"},
			UploadJournalOptions["Existing Journal - Example", OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..},
			Messages :> {
				Error::InvalidInput,
				Error::JournalNameAlreadyExists
			},
			Stubs :> {
				$DeveloperSearch=True
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadJournalQ*)


DefineTests[ValidUploadJournalQ,
	{
		Example[{Basic, "Create a new journal based on the provided inputs:"},
			ValidUploadJournalQ["Nature (ValidUploadJournalQ Test)"],
			True
		],
		(* --- Options --- *)
		Example[{Options, Verbose, "Specify verbose when calling ValidUploadJournalQ:"},
			ValidUploadJournalQ["Nature (ValidUploadJournalQ Test)", Verbose -> True],
			True
		],
		Example[{Options, OutputFormat, "Specify OutputFormat when calling ValidUploadJournalQ:"},
			ValidUploadJournalQ["Nature (ValidUploadJournalQ Test)", OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],

		(* --- Messages --- *)
		Example[{Messages, "JournalNameAlreadyExists", "If the journal already exists in the database, return an error:"},
			ValidUploadJournalQ["Existing Journal - Example"],
			False,
			Stubs :> {
				$DeveloperSearch=True
			}
		]
	}
];




(* ::Subsubsection::Closed:: *)
(*ExportReport*)


DefineTests[ExportReport,
	{
		Example[
			{Basic, "Upload a report containing any desired data:"},
			ExportReport["testReportForExportReport",
				{
					{Title, "Sample Report for ExportReport"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{Code, Defer[PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"]]]},
					PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"]],
					"quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
					PlotTable[{Object[Sample, "id:zGj91aRlOA36"], Object[Sample, "id:lYq9jRzZL8X3"], Object[Sample, "id:GmzlKjYVAoNX"], Object[Sample, "id:AEqRl951OXx6"], Object[Sample, "id:AEqRl950Lp7w"], Object[Sample, "id:KBL5DvYOArxk"], Object[Sample, "id:XnlV5jmaDJa3"], Object[Sample, "id:Z1lqpMGJdWVV"]}, {ModelName, Volume}],
					{Subsubsection, "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur"},
					PlotChromatography[{Object[Data, Chromatography, "id:M8n3rx0l7738"], Object[Data, Chromatography, "id:1ZA60vLrWW66"]}]
				}
			],
			EmeraldCloudFileP | ObjectP[Object[EmeraldCloudFile]]
		],

		Example[
			{Basic, "You can specify different styles for each content or group of contents. If style is not specified, the style will default to 'Text' for string and to 'Output' for everything else:"},
			ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{#, "This is "<>ToString[#]<>" style"} & /@ List @@ ReportStyleP,
				SaveLocally -> True,
				SaveToCloud -> False
			];
			notebook=NotebookOpen[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]];
			Rasterize[notebook],
			Graphics_,
			TearDown :> {
				NotebookClose[notebook];
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]]}
		],

		Example[
			{Basic, "Use 'Defer' to avoid evaluating code:"},
			ExportReport["testReportForExportReport",
				{
					"This code will not evaluate because it is wrapped in Defer:",
					Defer[Defer[PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"]]]],
					"This code will evaluate:",
					PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"]]
				}
			],
			EmeraldCloudFileP | ObjectP[Object[EmeraldCloudFile]]
		],

		Example[{Options, SaveLocally, "Use the SaveLocally option to indicate that the report should be saved to your computer:"},
			ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]];
			}
		],
		Example[{Options, SaveLocally, "If a full file path is not given, the file will be saved in $TemporaryDirectory:"},
			ExportReport["testReportForExportReport",
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]];
			}
		],
		Example[{Options, SaveLocally, "If a file path is given but the directory does not exist, the directory will be created:"},
			ExportReport[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.nb"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.nb"}]];
				DeleteDirectory[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport"}], DeleteContents -> True];
			}
		],


		Example[{Options, SaveToCloud, "Use the SaveToCloud option to indicate that the report should be saved as a cloud file:"},
			ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveToCloud -> True
			],
			EmeraldCloudFileP | ObjectP[Object[EmeraldCloudFile]]
		],

		Example[{Options, SaveToNotebook, "Use the SaveToNotebook option to indicate that the report should open as a new page in the current notebook:"},
			cloudFile=ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveToNotebook -> True
			],
			EmeraldCloudFileP | ObjectP[Object[EmeraldCloudFile]],
			Variables :> {cloudFile},
			TearDown :> {NotebookClose[NotebookOpen[FileNameJoin[{$TemporaryDirectory, cloudFile[[-1]]}]]]}
		],

		Example[{Messages, "FileExists", "If a file already exists by the same name, it will not be overwritten:"},
			ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveToCloud -> True,
				SaveLocally -> True
			],
			$Failed,
			Messages :> {ExportReport::FileExists},
			SetUp :> {
				Export[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}], "Don't overwrite me!"]
			},
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]];
			}
		],

		Test["When only saving to the cloud no errors are thrown about existing files:",
			(
				ExportReport[FileNameJoin[{$TemporaryDirectory, "ExportReport reexport test.nb"}],
					{
						{Title, "Sample Report for ExportReport"},
						{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
						{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
					},
					SaveToCloud -> True,
					SaveLocally -> False
				];
				ExportReport[FileNameJoin[{$TemporaryDirectory, "ExportReport reexport test.nb"}],
					{
						{Title, "Sample Report for ExportReport"},
						{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
						{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
					},
					SaveToCloud -> True,
					SaveLocally -> False
				]
			),
			EmeraldCloudFileP
		],

		Test["If SaveLocally is False, the file is deleted after export and upload:",
			ExportReport[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> False
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.nb"}]],
			False
		],

		Test["If just a file name is given, uses $TemporaryDirectory and adds the .nb extension:",
			ExportReport[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True,
				SaveToCloud -> False
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.nb"}]];
			}
		],
		Test["If just a file name and extension is given, uses $TemporaryDirectory and respects the extension:",
			ExportReport["testReportForExportReport.txt",
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True,
				SaveToCloud -> False
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.txt"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "testReportForExportReport.txt"}]];
			}
		],
		Test["If a full file path is given without an extension, adds the .nb extension:",
			ExportReport[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True,
				SaveToCloud -> False
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.nb"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.nb"}]];
				DeleteDirectory[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport"}], DeleteContents -> True];
			}
		],
		Test["If a full file path is given with an extension no changes are made to the file path:",
			ExportReport[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.txt"}],
				{
					{Title, "Sample Report for ExportReport"},
					{Subsubsection, "Ut enim ad minim veniam", "Excepteur sint occaecat cupidatat non proident"},
					{"Lorem ipsum dolor sit amet, consectetur adipiscing elit", "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
				},
				SaveLocally -> True,
				SaveToCloud -> False
			];
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.txt"}]],
			True,
			TearDown :> {
				DeleteFile[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport", "testReportForExportReport.txt"}]];
				DeleteDirectory[FileNameJoin[{$TemporaryDirectory, "newDirectoryForExportReport"}], DeleteContents -> True];
			}
		]
	},

	SymbolSetUp :> {

		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];

		$CreatedObjects={};

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "Test Notebook for ExportReport"
		|>];

	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	},
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled=False,
		$Notebook=Object[LaboratoryNotebook, "Test Notebook for ExportReport"]
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadSite*)


DefineTests[
	UploadSite,
	{
		Example[{Basic, "Create a site:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"],
			ObjectP[Object[Container, Site]]
		],
		Example[{Additional, "The site is linked to the first notebook of the team:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", DefaultMailingAddress -> True];
			Download[site, Notebook],
			Alternatives @@ LinkP[Download[Object[Team, Financing, "UploadSite test team (1)"], NotebooksFinanced[Object]]],
			Variables :> {site}
		],
		Example[{Options, DefaultMailingAddress, "Specify that this is the default address to use for shipping packages to/from the team:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", DefaultMailingAddress -> True];
			Download[Object[Team, Financing, "UploadSite test team (1)"], DefaultMailingAddress],
			LinkP[site],
			Variables :> {site}
		],
		Example[{Options, DefaultMailingAddress, "Create a site, but do not set it as default shipping address team:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", DefaultMailingAddress -> Null];
			Download[Object[Team, Financing, "UploadSite test team (1)"], DefaultMailingAddress],
			Except[LinkP[site]],
			Variables :> {site}
		],
		Example[{Options, DefaultMailingAddress, "If DefaultMailingAddress is not specified and the team already has a default mailing address, the default mailing address will not change:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (3)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[Object[Team, Financing, "UploadSite test team (3)"], DefaultMailingAddress],
			Except[LinkP[site]],
			Variables :> {site}
		],
		Example[{Options, DefaultMailingAddress, "If DefaultMailingAddress is not specified and the team does not already have a default mailing address, the created site will be set as the default mailing address:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (4)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[Object[Team, Financing, "UploadSite test team (4)"], DefaultMailingAddress],
			LinkP[site],
			Variables :> {site},
			SetUp :> {
				Object[Team, Financing, "UploadSite test team (4)"]Upload[<|
					Object -> Object[Team, Financing, "UploadSite test team (4)"],
					DefaultMailingAddress -> Null
				|>
				]
			}
		],
		Example[{Options, BillingAddress, "Specify that this is the default address to use for billing. (This is only possible as a team administrator):"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", BillingAddress -> True];
			Download[Object[Team, Financing, "UploadSite test team (1)"], BillingAddress],
			LinkP[site],
			Variables :> {site}
		],
		Example[{Options, BillingAddress, "Create a site, but do not set it as default shipping address team:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", BillingAddress -> Null];
			Download[Object[Team, Financing, "UploadSite test team (1)"], BillingAddress],
			Except[LinkP[site]],
			Variables :> {site}
		],
		Example[{Options, BillingAddress, "If BillingAddress is not specified and the team already has a billing address, the default billing address will not change:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (3)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[Object[Team, Financing, "UploadSite test team (3)"], BillingAddress],
			Except[LinkP[site]],
			Variables :> {site}
		],
		Example[{Options, BillingAddress, "If BillingAddress is not specified and the team does not already have a billing address, the created site will be set as the default billing address if the user is a team administrator:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (4)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[Object[Team, Financing, "UploadSite test team (4)"], BillingAddress],
			LinkP[site],
			Variables :> {site},
			SetUp :> {
				Object[Team, Financing, "UploadSite test team (4)"]Upload[<|
					Object -> Object[Team, Financing, "UploadSite test team (4)"],
					BillingAddress -> Null
				|>
				]
			}

		],
		Example[{Options, BillingAddress, "If BillingAddress is not specified and the team does not already have a billing address, the created site will not be set as the default billing address if the user is not a team administrator:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (4)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[Object[Team, Financing, "UploadSite test team (4)"], BillingAddress],
			Null,
			Variables :> {site},
			Stubs :> {
				$PersonID=Download[Object[User, "UploadSite test user (2)"], Object]
			},
			SetUp :> {
				Object[Team, Financing, "UploadSite test team (4)"]Upload[<|
					Object -> Object[Team, Financing, "UploadSite test team (4)"],
					BillingAddress -> Null
				|>
				]
			}
		],
		Example[{Options, Name, "Give the site a name:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "My Site"];
			Download[site, Name],
			"My Site",
			Variables :> {site}
		],
		Example[{Messages, "DuplicateName", "The site name must be unique:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "My preexisting site name"],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Messages, "OptionsRequired", "When creating a site, all address fields and phone number are required:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], PostalCode -> "12345"],
			$Failed,
			Messages :> {Error::OptionsRequired, Error::InvalidOption}
		],
		Example[{Messages, "NotebookOwnership", "If a notebook is specified, the notebook must be owned by the team:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Notebook -> Object[LaboratoryNotebook, "UploadSite test notebook (3)"]],
			$Failed,
			Messages :> {Error::NotebookOwnership, Error::InvalidOption}
		],
		Example[{Messages, "InvalidBillingAddressOption", "If billing address is being set, the user must be a team administrator:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", BillingAddress -> True],
			$Failed,
			Messages :> {Error::InvalidBillingAddressOption, Error::InvalidOption},
			Stubs :> {
				$PersonID=Download[Object[User, "UploadSite test user (2)"], Object]
			}
		],


		Example[{Basic, "Edit an existing site:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], AttentionName -> "Hendrick Rooster"];
			Download[Object[Container, Site, "Test existing site for UploadSite (1)"], AttentionName],
			"Hendrick Rooster",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Additional, "Any fields in the site that were not specified in the options remain untouched:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], AttentionName -> "Hendrick Rooster"];
			Download[Object[Container, Site, "Test existing site for UploadSite (1)"], {CompanyName, AttentionName, StreetAddress, City, State, PostalCode, PhoneNumber}],
			{Null, "Hendrick Rooster", "123 Test Way", "Austin", "TX", "12345", "650-123-4567"},
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Options, DefaultMailingAddress, "Change an existing address to be the default shipping address of the team:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], DefaultMailingAddress -> True];
			Download[Object[Team, Financing, "UploadSite test team (1)"], DefaultMailingAddress],
			LinkP[Object[Container, Site, "Test existing site for UploadSite (1)"]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"];
				Upload[<|Object -> Object[Team, Financing, "UploadSite test team (1)"], DefaultMailingAddress -> Null|>]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Options, BillingAddress, "Change an existing address to be the billing address of the team:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], BillingAddress -> True];
			Download[Object[Team, Financing, "UploadSite test team (1)"], BillingAddress],
			LinkP[Object[Container, Site, "Test existing site for UploadSite (1)"]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"];
				Upload[<|Object -> Object[Team, Financing, "UploadSite test team (1)"], BillingAddress -> Null|>]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Options, Name, "Change the name of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], Name -> "My new site name"];
			Download[site, Name],
			"My new site name",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				If[DatabaseMemberQ[Object[Container, Site, "My new site name"]],
					EraseObject[Object[Container, Site, "My new site name"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "My new site name"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Messages, "DuplicateName", "The site name must be unique:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], Name -> "My preexisting site name"],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption},
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Messages, "NotebookOwnership", "If a notebook is specified, the notebook must be owned by the team:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], Notebook -> Object[LaboratoryNotebook, "UploadSite test notebook (3)"]],
			$Failed,
			Messages :> {Error::NotebookOwnership, Error::InvalidOption},
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Messages, "InvalidBillingAddressOption", "If an existing site is being set as the billing address, the user must be a team administrator:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], BillingAddress -> True],
			$Failed,
			Messages :> {Error::InvalidBillingAddressOption, Error::InvalidOption},
			Stubs :> {
				$PersonID=Download[Object[User, "UploadSite test user (2)"], Object]
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Messages, "BillingAddressPermissions", "If the site being edited is a billing address, the user must be a team administrator:"},
			UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"]],
			$Failed,
			Messages :> {Error::BillingAddressPermissions, Error::InvalidInput},
			Stubs :> {
				$PersonID=Download[Object[User, "UploadSite test user (2)"], Object]
			},
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], BillingAddress -> True, StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			}
		],
		Example[{Options, StreetAddress, "Specify the street address when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[site, StreetAddress],
			"123 Test Way",
			Variables :> {site}
		],
		Example[{Options, StreetAddress, "Change the street address of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], StreetAddress -> "456 Test Way"];
			Download[site, StreetAddress],
			"456 Test Way",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, City, "Specify the city when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "CA", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[site, City],
			"Emerald City",
			Variables :> {site}
		],
		Example[{Options, City, "Change the city of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], City -> "Emerald City"];
			Download[site, City],
			"Emerald City",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, State, "Specify the state when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "AZ", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[site, State],
			"AZ",
			Variables :> {site}
		],
		Example[{Options, State, "Change the state of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], State -> "AZ"];
			Download[site, State],
			"AZ",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, PostalCode, "Specify the PostalCode code when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "AZ", PostalCode -> "67890", Country -> "United States", PhoneNumber -> "650-123-4567"];
			Download[site, PostalCode],
			"67890",
			Variables :> {site}
		],
		Example[{Options, PostalCode, "Change the PostalCode code of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], PostalCode -> "67890"];
			Download[site, PostalCode],
			"67890",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, PhoneNumber, "Specify the phone number when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "AZ", PostalCode -> "67890", Country -> "United States", PhoneNumber -> "987-654-3210"];
			Download[site, PhoneNumber],
			"987-654-3210",
			Variables :> {site}
		],
		Example[{Options, PhoneNumber, "Change the phone number of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], PhoneNumber -> "987-654-3210"];
			Download[site, PhoneNumber],
			"987-654-3210",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, AttentionName, "Specify the attention name when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "AZ", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", AttentionName -> "Wizard Oz"];
			Download[site, AttentionName],
			"Wizard Oz",
			Variables :> {site}
		],
		Example[{Options, AttentionName, "Change the attention name of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], AttentionName -> "Wizard Oz"];
			Download[site, AttentionName],
			"Wizard Oz",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		],
		Example[{Options, CompanyName, "Specify the attention name when making a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Emerald City", State -> "AZ", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", CompanyName -> "Master Science Co"];
			Download[site, CompanyName],
			"Master Science Co",
			Variables :> {site}
		],
		Example[{Options, CompanyName, "Change the attention name of a site:"},
			site=UploadSite[Object[Team, Financing, "UploadSite test team (1)"], Object[Container, Site, "Test existing site for UploadSite (1)"], CompanyName -> "Master Science Co"];
			Download[site, CompanyName],
			"Master Science Co",
			SetUp :> {
				If[DatabaseMemberQ[Object[Container, Site, "Test existing site for UploadSite (1)"]],
					EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
				];
				UploadSite[Object[Team, Financing, "UploadSite test team (1)"], StreetAddress -> "123 Test Way", City -> "Austin", State -> "TX", PostalCode -> "12345", Country -> "United States", PhoneNumber -> "650-123-4567", Name -> "Test existing site for UploadSite (1)"]
			},
			TearDown :> {
				EraseObject[Object[Container, Site, "Test existing site for UploadSite (1)"], Force -> True, Verbose -> False]
			},
			Variables :> {site}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		With[{objectsToErase={Object[LaboratoryNotebook, "UploadSite test notebook (1)"],
			Object[LaboratoryNotebook, "UploadSite test notebook (2)"],
			Object[LaboratoryNotebook, "UploadSite test notebook (3)"],
			Object[User, "UploadSite test user (1)"],
			Object[User, "UploadSite test user (2)"],
			Object[Team, Financing, "UploadSite test team (1)"],
			Object[Team, Financing, "UploadSite test team (2)"],
			Object[Container, Site, "My preexisting site name"],
			Object[LaboratoryNotebook, "UploadSite test notebook (4)"],
			Object[LaboratoryNotebook, "UploadSite test notebook (5)"],
			Object[Team, Financing, "UploadSite test team (3)"],
			Object[Team, Financing, "UploadSite test team (4)"]}},
			EraseObject[PickList[objectsToErase, DatabaseMemberQ[objectsToErase]], Force -> True, Verbose -> False]
		];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[User],
			Name -> "UploadSite test user (1)"
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[User],
			Name -> "UploadSite test user (2)"
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[Container, Site],
			Name -> "My preexisting site name"
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[Team, Financing],
			Name -> "UploadSite test team (1)",
			Replace[Members] -> {Link[Object[User, "UploadSite test user (1)"], FinancingTeams], Link[Object[User, "UploadSite test user (2)"], FinancingTeams]},
			Replace[Administrators] -> {Link[Object[User, "UploadSite test user (1)"]]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[Team, Financing],
			Name -> "UploadSite test team (2)"
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[Team, Financing],
			Name -> "UploadSite test team (3)",
			Replace[Members] -> {Link[Object[User, "UploadSite test user (1)"], FinancingTeams], Link[Object[User, "UploadSite test user (2)"], FinancingTeams]},
			Replace[Administrators] -> {Link[Object[User, "UploadSite test user (1)"]]},
			DefaultMailingAddress -> Link[Object[Container, Site, "My preexisting site name"]],
			BillingAddress -> Link[Object[Container, Site, "My preexisting site name"]]
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[Team, Financing],
			Name -> "UploadSite test team (4)",
			Replace[Members] -> {Link[Object[User, "UploadSite test user (1)"], FinancingTeams], Link[Object[User, "UploadSite test user (2)"], FinancingTeams]},
			Replace[Administrators] -> {Link[Object[User, "UploadSite test user (1)"]]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "UploadSite test notebook (1)",
			Replace[Financers] -> {Link[Object[Team, Financing, "UploadSite test team (1)"], NotebooksFinanced]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "UploadSite test notebook (2)",
			Replace[Financers] -> {Link[Object[Team, Financing, "UploadSite test team (1)"], NotebooksFinanced]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "UploadSite test notebook (4)",
			Replace[Financers] -> {Link[Object[Team, Financing, "UploadSite test team (3)"], NotebooksFinanced]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "UploadSite test notebook (5)",
			Replace[Financers] -> {Link[Object[Team, Financing, "UploadSite test team (4)"], NotebooksFinanced]}
		|>];

		Upload[<|
			DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "UploadSite test notebook (3)"
		|>];

	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	},
	Stubs :> {
		$PersonID=Download[Object[User, "UploadSite test user (1)"], Object]
	}
];

(* ::Subsubsection::Closed:: *)
(*UploadStorageProperties*)

DefineTests[
	UploadStorageProperties,
	{
		Example[{Basic,"Upload information relevant to the storage of a model:"},
			UploadStorageProperties[
				Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID],
				Fragile -> True
			],
			ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID]]
		],
		Example[{Basic,"Set the dimensions of a rack:"},
			UploadStorageProperties[
				Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID],
				Dimensions -> {10 Centimeter, 10 Centimeter, 10 Centimeter}
			],
			ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID]]
		],
		Example[{Options,StorageOrientation,"Set the indended storage orientation of an item:"},
			UploadStorageProperties[
				Model[Item,Filter,"UploadStorageProperties test item 1 " <> $SessionUUID],
				StorageOrientation -> Side
			],
			ObjectP[Model[Item,Filter,"UploadStorageProperties test item 1 " <> $SessionUUID]]
		],
		Example[{Options,StorageOrientationImage,"Set the indended storage orientation of an item:"},
			Module[{orientationImage},
				
				orientationImage = UploadCloudFile[Image[{{0., 1., 0.}, {1., 0., 1.}, {0., 1., 0.}}]];
				
				UploadStorageProperties[
					Model[Item,Filter,"UploadStorageProperties test item 1 " <> $SessionUUID],
					StorageOrientation -> Side,
					StorageOrientationImage -> orientationImage
				]
			],
			ObjectP[Model[Item,Filter,"UploadStorageProperties test item 1 " <> $SessionUUID]]
		],
		Example[{Options,Fragile,"Indicate a rack is fragile:"},
			UploadStorageProperties[
				Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID],
				Fragile -> True
			],
			ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID]]
		],
		Example[{Options,Dimensions,"Set the dimensions of a rack:"},
			UploadStorageProperties[
				Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID],
				Dimensions -> {10 Centimeter, 10 Centimeter, 10 Centimeter}
			],
			ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 1 " <> $SessionUUID]]
		],
		Example[{Messages,"ContainerDimensionsAlreadyVerified","If a plate is already verified, new dimensions cannot be set:"},
			UploadStorageProperties[
				Model[Container,Plate,"UploadStorageProperties test plate 1 " <> $SessionUUID],
				Dimensions -> {10 Centimeter, 10 Centimeter, 10 Centimeter}
			],
			$Failed,
			Messages:>{Error::ContainerDimensionsAlreadyVerified,Error::InvalidOption}
		],
		Test["Unsync impacted StorageAvailability objects:",
			UploadStorageProperties[
				Model[Container,Rack,"UploadStorageProperties test rack 2 " <> $SessionUUID],
				Dimensions -> {10 Centimeter, 10 Centimeter, 10 Centimeter}
			],
			{
				ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 2 " <> $SessionUUID]],
				ObjectP[Object[StorageAvailability]]
			}
		],
		Test["Unsync impacted StorageAvailability objects only if there are objects in storage:",
			UploadStorageProperties[
				{Model[Container,Rack,"UploadStorageProperties test rack 3 " <> $SessionUUID]},
				Dimensions -> {10 Centimeter, 10 Centimeter, 10 Centimeter}
			],
			{ObjectP[Model[Container,Rack,"UploadStorageProperties test rack 3 " <> $SessionUUID]]}
		]
	},
	SymbolSetUp :> (
		$CreatedObjects = {};
		Module[
			{namedObjects,lurkers},
			namedObjects={
				Model[Container,Rack, "UploadStorageProperties test rack 1 " <> $SessionUUID],
				Model[Container,Rack, "UploadStorageProperties test rack 2 " <> $SessionUUID],
				Model[Container,Rack, "UploadStorageProperties test rack 3 " <> $SessionUUID],
				Model[Container,Plate, "UploadStorageProperties test plate 1 " <> $SessionUUID],
				Model[Item,Filter, "UploadStorageProperties test item 1 " <> $SessionUUID]
			};
			lurkers=PickList[namedObjects,DatabaseMemberQ[namedObjects],True];
			EraseObject[lurkers,Force->True,Verbose->False];
			
			Upload[{
				Association[
					Type -> Model[Container,Rack],
					Name -> "UploadStorageProperties test rack 1 " <> $SessionUUID,
					DeveloperObject -> True
				],
				Association[
					Type -> Model[Container,Rack],
					Name -> "UploadStorageProperties test rack 2 " <> $SessionUUID,
					DeveloperObject -> True
				],
				Association[
					Type -> Model[Container,Rack],
					Name -> "UploadStorageProperties test rack 3 " <> $SessionUUID,
					DeveloperObject -> True
				],
				Association[
					Type -> Model[Container,Plate],
					Name -> "UploadStorageProperties test plate 1 " <> $SessionUUID,
					VerifiedContainerModel -> True,
					DeveloperObject -> True
				],
				Association[
					Type -> Model[Item,Filter],
					Name -> "UploadStorageProperties test item 1 " <> $SessionUUID,
					DeveloperObject -> True
				]
			}];

			(*  set up a shell container, storage avilability and rack to go in it *)
			Module[{parentRack, targetRack, sa},
				{parentRack, targetRack, sa}=CreateID[{Object[Container, Rack], Object[Container, Rack], Object[StorageAvailability]}];
				Upload[{
					<|Object-> parentRack, Replace[Contents]-> {{"A2", Link[targetRack, Container]}}|>,
					<|Object-> targetRack, Model-> Link[Model[Container,Rack,"UploadStorageProperties test rack 3 " <> $SessionUUID], Objects], Position-> "A2", Status-> Available|>
				}]
			];

			(*  set up a shell container, storage avilability and rack to go in it *)
			Module[{parentRack, targetRack, sa},
				{parentRack, targetRack, sa}=CreateID[{Object[Container, Rack], Object[Container, Rack], Object[StorageAvailability]}];
				Upload[{
					<|Object-> parentRack, Replace[StorageAvailability]-> {{"A1", Link[sa, Container]}}, Replace[Contents]-> {{"A1", Link[targetRack, Container]}}|>,
					<|Object-> targetRack, Model-> Link[Model[Container,Rack,"UploadStorageProperties test rack 2 " <> $SessionUUID], Objects], Position-> "A1", Status-> Stocked|>
				}]
			]

		]
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		Module[
			{namedObjects,lurkers},
			namedObjects={
				Model[Container,Rack, "UploadStorageProperties test rack 1 " <> $SessionUUID],
				Model[Container,Rack, "UploadStorageProperties test rack 2 " <> $SessionUUID],
				Model[Container,Rack, "UploadStorageProperties test rack 3 " <> $SessionUUID],
				Model[Container,Plate, "UploadStorageProperties test plate 1 " <> $SessionUUID],
				Model[Item,Filter, "UploadStorageProperties test item 1 " <> $SessionUUID]
			};
			lurkers=PickList[namedObjects,DatabaseMemberQ[namedObjects],True];
			EraseObject[lurkers,Force->True,Verbose->False];
		]
	)
];