(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*runSyncBilling*)

DefineTests[runSyncBilling,
	{
		Example[{Basic, "Create a new billing object for a financing team with no bill but with a pricing scheme:"},
			runSyncBilling[Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID], Notify -> False];
			Download[Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID], {CurrentBills[[All,1]], CurrentBills[[All,1]][Notebook]}],
			{{ObjectP[Object[Bill]]..},{ObjectP[Object[LaboratoryNotebook,"Test lab notebook for runSyncBilling tests"<>$SessionUUID]]..}},
			TimeConstraint -> 400
		],
		Example[{Options, Notify, "Returns a table summarizing the results of the SyncBilling when Notify -> False:"},
			runSyncBilling[Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID], Notify -> False],
			_Pane,
			TimeConstraint -> 300
		],
		(*tasks wont be created on test db so this wont be spamming anyone*)
		Example[{Options, Notify, "Use the Notify option to alert business team when SyncBilling is complete:"},
			runSyncBilling[Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID], Notify -> True],
			_Pane,
			TimeConstraint -> 300
		],
		Example[{Additional, "Returns a message indicating that no active teams were found when given an empty list:"},
			runSyncBilling[{}, Notify -> False],
			_String,
			TimeConstraint -> 300
		]
	},
	Stubs :> {$DeveloperSearch = True},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for runSyncBilling testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for runSyncBilling tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for runSyncBilling test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for runSyncBilling test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for runSyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Bill, "A test bill object for runSyncBilling testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for runSyncBilling"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for runSyncBilling test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for runSyncBilling test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for runSyncBilling test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for runSyncBilling test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for runSyncBilling Tests (not washable)"<>$SessionUUID],

					Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for runSyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for runSyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for runSyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for runSyncBilling test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for runSyncBilling tests"<>$SessionUUID],

					Object[Resource, Waste, "A test waste resource 1 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for runSyncBilling testing"<>$SessionUUID],

					Object[Sample, "Test Sample 1 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 5 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for runSyncBilling unit tests seals"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 5 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 4"<>$SessionUUID],

					Object[Transaction, ShipToECL, "Test ShipToECL transaction for runSyncBilling testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID, fplcModelID, operatorModelID, operatorModelID2, containerID, containerID2, containerID3,
			sampleID1, sampleID2, sampleID3, sampleID4, sampleID5, productID1, productID1a, productID1b, productID2, productID3, productID4,
			productID5, productID5a, productID5b, productID6, sampleUpload},

			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];
			fplcModelID=CreateID[Model[Instrument, FPLC]];
			operatorModelID=CreateID[Model[User, Emerald, Operator]];
			operatorModelID2=CreateID[Model[User, Emerald, Operator]];
			containerID=CreateID[Model[Container, Vessel]];
			containerID2=CreateID[Model[Container, Vessel]];
			containerID3=CreateID[Model[Container, Vessel]];
			sampleID1=CreateID[Model[Sample]];
			sampleID2=CreateID[Model[Sample]];
			sampleID3=CreateID[Model[Sample]];
			sampleID4=CreateID[Model[Sample]];
			sampleID5=CreateID[Model[Sample]];
			{productID1, productID1a, productID1b, productID2, productID3, productID4,
				productID5, productID5a, productID5b, productID6} = CreateID[ConstantArray[Object[Product],10]];

			firstSet=List[
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> True,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test ala carte pricing scheme for runSyncBilling testing"<>$SessionUUID,
					PricingPlanName -> "A test ala carte pricing scheme for runSyncBilling testing"<>$SessionUUID,
					PlanType -> AlaCarte,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					IncludedConstellationStorage -> 20000000 Unit,
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 60 USD,
					PricePerPriorityExperiment -> 120 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[OperatorPriorityTimePrice] -> {
						{1, 25 USD / Hour},
						{2, 50 USD / Hour},
						{3, 75 USD / Hour},
						{4, 100 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 7 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 9 USD},
						{"Autoclave sterile labware", 9 USD}
					},
					Replace[StockingPricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.05 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Ambient Storage"], 0.01 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.15 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.05 USD / (Centimeter)^3}
					},
					Replace[WastePricing] -> {
						{Chemical, 7 USD / Kilogram},
						{Biohazard, 7 USD / Kilogram}
					},
					Replace[StoragePricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.1 USD / (Centimeter)^3 / Month},
						{Link@Model[StorageCondition, "Freezer"], 1 USD / (Centimeter)^3 / Month}
					},
					IncludedPriorityProtocols -> 1,
					IncludedInstrumentHours -> 3 Hour,
					IncludedCleanings -> 1,
					IncludedStockingFees -> 5 USD,
					IncludedWasteDisposalFees -> 10 USD,
					IncludedStorage -> 1 Kilo * Centimeter^3,
					IncludedShipmentFees -> 150 USD,
					PrivateTutoringFee -> 200 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "Test lab notebook for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "Test lab notebook 2 for runSyncBilling tests"<>$SessionUUID
				|>,
				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Null,
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site],
					DeveloperObject->True
				],
				<|
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Name -> "Test SM Protocol for runSyncBilling test (no instrument used)"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[Model[Instrument, FPLC, "AKTA avant 25"], Objects],
					Name -> "Test FPLC instrument for runSyncBilling test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, Sonicator],
					Model -> Link[Model[Instrument, Sonicator, "Branson MH 5800"], Objects],
					Name -> "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Object -> fplcModelID,
					Type -> Model[Instrument, FPLC],
					DeveloperObject -> True,
					Name -> "Fake Model FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[fplcModelID, Objects],
					Name -> "Fake Object FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				Association[
					Object -> operatorModelID,
					QualificationLevel -> 2,
					Name -> "Test Operator Model for runSyncBilling test"<>$SessionUUID
				],
				Association[
					Object -> operatorModelID2,
					QualificationLevel -> 3,
					Name -> "Test Operator Model 2 for runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID, Objects],
					Name -> "Test Operator for runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID2, Objects],
					Name -> "Test Operator 2 for runSyncBilling test"<>$SessionUUID
				],
				Association[
					Object -> containerID,
					Sterile -> True,
					Reusability -> True,
					CleaningMethod -> Handwash,
					Name -> "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID
				],
				Association[
					Object -> containerID2,
					Sterile -> False,
					Reusability -> True,
					CleaningMethod -> DishwashPlastic,
					Name -> "Test Container Model 2 for runSyncBilling test (reusable)"<>$SessionUUID
				],
				Association[
					Object -> containerID3,
					Sterile -> False,
					Reusability -> False,
					CleaningMethod -> Null,
					Name -> "Test Container Model 3 for runSyncBilling test (not reusable)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID2, Objects],
					Reusable -> True,
					Name -> "Test Container 3 for runSyncBilling test (dishwash)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID3, Objects],
					Reusable -> False,
					Name -> "Test Container 4 for runSyncBilling test (not reusable)"<>$SessionUUID
				],

				(* -- Object[Product] uploads -- *)
				(* public normal sample (stocked, not a kit) *)
				Association[
					Object -> productID1,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1a,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product a for runSyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1b,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product b for runSyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID6,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 6 (public)"<>$SessionUUID
				],
				(* private normal sample (stocked, not a kit) *)
				Association[
					Object -> productID2,
					Notebook -> Link[objectNotebookID, Objects],
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 2 (private)"<>$SessionUUID
				],
				(*TODO: this needs to be updated to point at a kit with some other shit maybe*)
				(* public kit sample *)
				Association[
					Object -> productID3,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Name -> "Test Product for runSyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> productID4,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* deprecated public product *)
				Association[
					Object -> productID5,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 5 (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5a,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 5a (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5b,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for runSyncBilling test 5b (deprecated)"<>$SessionUUID
				],

				(* -- Model[Sample] uploads -- *)

				(* public normal sample *)
				Association[
					Object -> sampleID1,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1, ProductModel], Link[productID5, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID
				],
				(* private normal sample *)
				Association[
					Object -> sampleID2,
					Notebook -> Link[objectNotebookID, Objects],
					Replace[Products] -> {Link[productID2, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for runSyncBilling test 2 (private)"<>$SessionUUID
				],
				(* public kit sample *)
				Association[
					Object -> sampleID3,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1a, ProductModel], Link[productID5a, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> sampleID4,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1b, ProductModel], Link[productID5b, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* second public sample, different storage condition *)
				Association[
					Object -> sampleID5,
					Notebook -> Null,
					Replace[Products] -> {Link[productID6, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Freezer"]],
					Name -> "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID
				],

				(* -- Object Upload -- *)
				(* public, normal sample *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID1, Objects],
					Name -> "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID
				],
				(*private sample, still has a model*)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID2, Objects],
					Notebook -> Link[objectNotebookID, Objects],
					Name -> "Test Sample for runSyncBilling test 2 (private)"<>$SessionUUID
				],
				(* public, part of a kit *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID3, Objects],
					Name -> "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public, not stocked *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID4, Objects],
					Name -> "Test Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* public, deprecated *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID5, Objects],
					Name -> "Test Sample for runSyncBilling test 5 (public)"<>$SessionUUID
				],
				(* public, no model *)
				Association[
					Type -> Object[Sample],
					Model -> Null,
					Name -> "Test Sample for runSyncBilling test 6 (no model)"<>$SessionUUID
				],

				(*products for materials*)
				<|
					Amount -> Quantity[5., "Grams"],
					CatalogDescription -> "1 x 5. g Null",
					CatalogNumber -> "FAKE123-4",
					DefaultContainerModel -> Link[Model[Container, Vessel, "50mL Tube"], ProductsContained],
					NumberOfItems -> 1,
					Packaging -> Single,
					Price -> Quantity[50.42, "USDollars"],
					Type -> Object[Product],
					UsageFrequency -> VeryHigh,
					DeveloperObject -> True,
					Name -> "Test product for runSyncBilling unit tests salt"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for runSyncBilling unit tests salt"<>$SessionUUID
					}
				|>,
				<|
					CatalogDescription -> "Small zip lock bag with accoutrements",
					CatalogNumber -> "28952642",
					Deprecated -> False,
					EstimatedLeadTime -> Quantity[1., "Days"],
					NumberOfItems -> 1,
					Packaging -> Pack,
					Price -> Quantity[511., "USDollars"],
					ProductURL -> "https://www.cytivalifesciences.com/en/us/support/products/akta-avant-25-28930842",
					SampleType -> Part,
					Type -> Object[Product],
					UsageFrequency -> High,
					DeveloperObject -> True,
					Name -> "Test product for runSyncBilling unit tests seals"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for runSyncBilling unit tests seals"<>$SessionUUID
					}
				|>,
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 1 for FPLC in runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 2 for FPLC in runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 3 for FPLC in runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 4 for FPLC in runSyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 5 for FPLC in runSyncBilling test"<>$SessionUUID
				]
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*put some samples into the containers*)
			sampleUpload=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"]
				},
				{
					{"A1", Object[Container, Vessel, "Test Container 1 for FPLC in runSyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 2 for FPLC in runSyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 3 for FPLC in runSyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 4 for FPLC in runSyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 5 for FPLC in runSyncBilling test"<>$SessionUUID]}
				},
				ECL`InternalUpload`InitialAmount -> {
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.5 Gram
				},
				Name -> {
					"Test Sample 1 for FPLC in runSyncBilling test"<>$SessionUUID,
					"Test Sample 2 for FPLC in runSyncBilling test"<>$SessionUUID,
					"Test Sample 3 for FPLC in runSyncBilling test"<>$SessionUUID,
					"Test Sample 4 for FPLC in runSyncBilling test"<>$SessionUUID,
					"Test Sample 5 for FPLC in runSyncBilling test"<>$SessionUUID
				}
			];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for runSyncBilling testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> True,
					Name -> "Test Troubleshooting Report with Refund for runSyncBilling"<>$SessionUUID
				|>,
				<|
					Object -> Object[Sample, "Test Sample 1 for FPLC in runSyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 2 for FPLC in runSyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 3 for FPLC in runSyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 4 for FPLC in runSyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 5 for FPLC in runSyncBilling test"<>$SessionUUID],
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				|>,

				(*transaction*)
				Association[
					Type -> Object[Transaction, ShipToECL],
					Name -> "Test ShipToECL transaction for runSyncBilling testing"<>$SessionUUID,
					Status -> Received,
					DateDelivered -> Now - 1 Day,
					Notebook -> Link[objectNotebookID, Objects],
					Destination -> Link[$Site],
					Replace[SamplesOut] -> {Link[Object[Sample, "Test Sample 5 for FPLC in runSyncBilling test"<>$SessionUUID]]},
					Replace[ContainersOut] -> {Link[Object[Container, Vessel, "Test Container 5 for FPLC in runSyncBilling test"<>$SessionUUID]]}
				],

				(*Instrument Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 1 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 2 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 3 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 4 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 5 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 6 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 7 for runSyncBilling tests"<>$SessionUUID
				|>,

				(*Operator Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 6 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 3 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 4 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 5 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 7 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 1 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator 2 for runSyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model 2 for runSyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 2 for runSyncBilling tests"<>$SessionUUID
				|>,

				(*cleaned container resources*)
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 6 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 3 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 4 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 5 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 7 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 1 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 2 for runSyncBilling test (reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 2 for runSyncBilling test (reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 2 for runSyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 3 for runSyncBilling test (not reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 3 for runSyncBilling test (not reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 4 for runSyncBilling test (not reusable)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 4 for runSyncBilling test (not reusable)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource for runSyncBilling Tests (not washable)"<>$SessionUUID
				|>,

				(*stocking resources*)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 1 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 6 for runSyncBilling tests"<>$SessionUUID
				],
				(* normal resource - the protocol was refunded so it shouldnt get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 1000 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 3 for runSyncBilling tests"<>$SessionUUID
				],
				(* normal resource for the subprotocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 4 for runSyncBilling tests"<>$SessionUUID
				],
				(* kit resource for an incomplete protocol (should not get counted) *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 5 for runSyncBilling tests"<>$SessionUUID
				],
				(* second public sample which should also get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 5 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 5 (public)"<>$SessionUUID]],
					Amount -> 40 Milliliter,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 7 for runSyncBilling tests"<>$SessionUUID
				],
				(* private sample that should not get counted in teh parent protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 2 (private)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 2 (private)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 2 (private)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 2 (private)"<>$SessionUUID]],
					Amount -> 100 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 1 for runSyncBilling tests"<>$SessionUUID
				],
				(* public sample without a model which should not get stocked - this should be VOQ'd out *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 6 (no model)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 6 (no model)"<>$SessionUUID]],
					Amount -> 10 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 2 for runSyncBilling tests"<>$SessionUUID
				],
				(* kit resource for the top level protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID]],
					Amount -> 30 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 8 for runSyncBilling tests"<>$SessionUUID
				],

				<|
					Amount -> 1 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 1 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 2 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 3 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 4 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 5 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 6 for runSyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Sharps,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 7 for runSyncBilling testing"<>$SessionUUID
				|>,
				(*TODO: start fixing with models here*)
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 1 for FPLC in runSyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for runSyncBilling FPLC unit test 1"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 2 for FPLC in runSyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for runSyncBilling FPLC unit test 2"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 3 for FPLC in runSyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for runSyncBilling FPLC unit test 3"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 4 for FPLC in runSyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for runSyncBilling FPLC unit test 4"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for runSyncBilling testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for runSyncBilling testing"<>$SessionUUID],

					Object[LaboratoryNotebook, "Test lab notebook for runSyncBilling tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in runSyncBilling test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in runSyncBilling test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in runSyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in runSyncBilling test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in runSyncBilling test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in runSyncBilling test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in runSyncBilling test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for runSyncBilling test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for runSyncBilling test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for runSyncBilling test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for runSyncBilling unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for runSyncBilling test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for runSyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for runSyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for runSyncBilling test"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Bill, "A test bill object for runSyncBilling testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for runSyncBilling"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for runSyncBilling test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for runSyncBilling test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for runSyncBilling test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for runSyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for runSyncBilling test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for runSyncBilling test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for runSyncBilling Tests (not washable)"<>$SessionUUID],

					Model[Sample, "Test Model Sample for runSyncBilling test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for runSyncBilling test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for runSyncBilling test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for runSyncBilling test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for runSyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for runSyncBilling tests"<>$SessionUUID],

					Object[Resource, Waste, "A test waste resource 1 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for runSyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for runSyncBilling testing"<>$SessionUUID],

					Object[Sample, "Test Sample 1 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 5 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Product, "Test product for runSyncBilling unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for runSyncBilling unit tests seals"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 5 for FPLC in runSyncBilling test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for runSyncBilling FPLC unit test 4"<>$SessionUUID],

					Object[Transaction, ShipToECL, "Test ShipToECL transaction for runSyncBilling testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];



(* ::Subsection::Closed:: *)
(*SyncBilling*)

DefineTests[SyncBilling,
	{
		Example[{Basic, "Create a new billing object for a financing team with no bill but with a pricing scheme:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Verbose -> True];
			{{result}, {{notebook}}} =Download[
				{
					{Object[Team,Financing,"A test financing team object for SyncBilling testing"<>$SessionUUID]},
					{Object[LaboratoryNotebook,"Test lab notebook for SyncBilling tests"<>$SessionUUID]}
				},
				{
					{CurrentBills[[All, 1]][Type],CurrentBills[[All, 1]][Notebook][Object]},
					{Object}
				}];
			And@@MapThread[MatchQ[#1,#2]&,{result, {{Object[Bill]}, {notebook}}}],
			True,
			TimeConstraint -> 300,
			Variables:>{notebook, result}
		],
		Example[{Basic, "Display the packets for the proposed changes:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Verbose -> True],
			{PacketP[{Object[Team], Object[Bill], Object[EmeraldCloudFile]}]..},
			TimeConstraint -> 300
		],
		Example[{Basic, "Display the packets for the proposed changes:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Verbose -> True],
			{PacketP[{Object[Team], Object[Bill], Object[EmeraldCloudFile]}]..},
			TimeConstraint -> 300
		],
		Example[{Options, Notify, "Makes asana tasks:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Notify -> False, Verbose -> True],
			{PacketP[{Object[Team], Object[Bill], Object[EmeraldCloudFile]}]..},
			TimeConstraint -> 300
		],
		Example[{Options, Verbose, "Adds progress output to track the progress of the function:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Verbose -> True],
			{PacketP[{Object[Team], Object[Bill], Object[EmeraldCloudFile]}]..},
			TimeConstraint -> 300
		],

		Example[{Messages, "FinancingTeamDoesNotExist", "Returns messages if the team does not exist:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing not real"], Upload -> False, Verbose -> True],
			$Failed,
			Messages :> {SyncBilling::FinancingTeamDoesNotExist},
			TimeConstraint -> 300
		],
		Example[{Messages, "ActiveTeamsOnly", "Display the message if the team is not active:"},
			SyncBilling[Object[Team, Financing, "A test financing not active team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Verbose -> True],
			$Failed,
			Messages :> {SyncBilling::ActiveTeamsOnly},
			TimeConstraint -> 300
		],
		Example[{Messages, "PricingFunctionFailed", "Display the message if the pricing function fails:"},
			SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID], Upload -> False, Fail -> True],
			$Failed,
			Messages :> {SyncBilling::PricingFunctionFailed},
			TimeConstraint -> 300
		],
		Example[{Additional, "Multi-site","Creates new bills if the team is configured to be bill for using 2 sites:"},
			SyncBilling[Object[Team, Financing, "A test financing team object 2 for SyncBilling testing"<>$SessionUUID]];
			Download[Object[Team, Financing, "A test financing team object 2 for SyncBilling testing"<>$SessionUUID],Length[CurrentBills]],
			2,
			(* we wipe this so we can be sure we don't have any lingering Object[Bills] in there *)
			SetUp:>{Upload[<|Object->Object[Team, Financing, "A test financing team object 2 for SyncBilling testing"<>$SessionUUID],Replace[CurrentBills]->{}|>]},
			TimeConstraint -> 300
		]
	},
	Stubs :> {$DeveloperSearch = True},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 2 for SyncBilling testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing not active team object for SyncBilling testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for SyncBilling testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme (2nd site) for SyncBilling testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for SyncBilling tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for SyncBilling tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 3 for SyncBilling tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for SyncBilling test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for SyncBilling test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for SyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Bill, "A test bill object for SyncBilling testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for SyncBilling"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for SyncBilling test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for SyncBilling test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for SyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for SyncBilling test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for SyncBilling test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 5 for SyncBilling test"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for SyncBilling Tests (not washable)"],

					Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for SyncBilling tests"<>$SessionUUID],

					Object[Resource, Waste, "A test waste resource 1 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for SyncBilling testing"<>$SessionUUID],

					Object[Sample, "Test Sample 1 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 5 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for SyncBilling unit tests seals"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 5 for FPLC in SyncBilling test"<>$SessionUUID],

					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 4"<>$SessionUUID],

					Object[Transaction, ShipToECL, "Test ShipToECL transaction for SyncBilling testing"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 1 for SyncBilling tests"<>$SessionUUID],
					Object[Container, Plate, "Test Plate 1 for SyncBilling tests"<>$SessionUUID],
					Object[Container,Site,"Test site 1 for SyncBilling"<>$SessionUUID],
					Object[Container,Site,"Test site 2 for SyncBilling"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet,financingTeamID,financingTeamID2,modelPricingID1,secondUploadList,syncBillingResult,objectNotebookID,objectNotebookID2,
			newBillObject,fplcProtocolID,fplcModelID,operatorModelID,operatorModelID2,containerID,containerID2,containerID3,
			sampleID1,sampleID2,sampleID3,sampleID4,sampleID5,productID1,productID1a,productID1b,productID2,
			productID3,productID4,productID5,productID5a,productID5b,productID6,sampleUpload,siteID,modelPricingID2,financingTeamID3,objectNotebookID3,siteID2},

			modelPricingID1=CreateID[Model[Pricing]];
			modelPricingID2=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			financingTeamID2=CreateID[Object[Team, Financing]];
			financingTeamID3=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID3=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];
			fplcModelID=CreateID[Model[Instrument, FPLC]];
			operatorModelID=CreateID[Model[User, Emerald, Operator]];
			operatorModelID2=CreateID[Model[User, Emerald, Operator]];
			containerID=CreateID[Model[Container, Vessel]];
			containerID2=CreateID[Model[Container, Vessel]];
			containerID3=CreateID[Model[Container, Vessel]];
			sampleID1=CreateID[Model[Sample]];
			sampleID2=CreateID[Model[Sample]];
			sampleID3=CreateID[Model[Sample]];
			sampleID4=CreateID[Model[Sample]];
			sampleID5=CreateID[Model[Sample]];
			siteID=CreateID[Object[Container,Site]];
			siteID2=CreateID[Object[Container,Site]];
			{productID1, productID1a, productID1b, productID2, productID3, productID4,
				productID5, productID5a, productID5b, productID6} = CreateID[ConstantArray[Object[Product],10]];

			firstSet=List[
				<|
					Object->siteID,
					Name->"Test site 1 for SyncBilling"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->siteID2,
					Name->"Test site 2 for SyncBilling"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> True,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] -> {Link[modelPricingID1],Link[siteID]},
					Name -> "A test financing team object for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID2,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Type -> Object[Team, Financing],
					DeveloperObject -> True,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] -> {Link[modelPricingID1],Link[siteID]},
					Name -> "A test financing not active team object for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID3,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> True,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] -> {
						{Link[modelPricingID1],Link[siteID]},
						{Link[modelPricingID2],Link[$Site]}
					},
					Name -> "A test financing team object 2 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test ala carte pricing scheme for SyncBilling testing"<>$SessionUUID,
					PricingPlanName -> "A test ala carte pricing scheme for SyncBilling testing"<>$SessionUUID,
					PlanType -> AlaCarte,
					Site->Link[siteID],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					IncludedConstellationStorage -> 20000000 Unit,
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 60 USD,
					PricePerPriorityExperiment -> 120 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[OperatorPriorityTimePrice] -> {
						{1, 25 USD / Hour},
						{2, 50 USD / Hour},
						{3, 75 USD / Hour},
						{4, 100 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 7 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 9 USD},
						{"Autoclave sterile labware", 9 USD}
					},
					Replace[StockingPricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.05 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Ambient Storage"], 0.01 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.15 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.05 USD / (Centimeter)^3}
					},
					Replace[WastePricing] -> {
						{Chemical, 7 USD / Kilogram},
						{Biohazard, 7 USD / Kilogram}
					},
					Replace[StoragePricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.1 USD / (Centimeter)^3 / Month},
						{Link@Model[StorageCondition, "Freezer"], 1 USD / (Centimeter)^3 / Month}
					},
					IncludedPriorityProtocols -> 1,
					IncludedInstrumentHours -> 3 Hour,
					IncludedCleanings -> 1,
					IncludedStockingFees -> 5 USD,
					IncludedWasteDisposalFees -> 10 USD,
					IncludedStorage -> 1 Kilo * Centimeter^3,
					IncludedShipmentFees -> 150 USD,
					PrivateTutoringFee -> 200 USD
				|>,
				<|
					Object -> modelPricingID2,
					Type -> Model[Pricing],
					Name -> "A test ala carte pricing scheme (2nd site) for SyncBilling testing"<>$SessionUUID,
					PricingPlanName -> "A test ala carte pricing scheme (2nd site) for SyncBilling testing"<>$SessionUUID,
					PlanType -> AlaCarte,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					IncludedConstellationStorage -> 20000000 Unit,
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 60 USD,
					PricePerPriorityExperiment -> 120 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[OperatorPriorityTimePrice] -> {
						{1, 25 USD / Hour},
						{2, 50 USD / Hour},
						{3, 75 USD / Hour},
						{4, 100 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 7 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 9 USD},
						{"Autoclave sterile labware", 9 USD}
					},
					Replace[StockingPricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.05 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Ambient Storage"], 0.01 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.15 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.05 USD / (Centimeter)^3}
					},
					Replace[WastePricing] -> {
						{Chemical, 7 USD / Kilogram},
						{Biohazard, 7 USD / Kilogram}
					},
					Replace[StoragePricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.1 USD / (Centimeter)^3 / Month},
						{Link@Model[StorageCondition, "Freezer"], 1 USD / (Centimeter)^3 / Month}
					},
					IncludedPriorityProtocols -> 1,
					IncludedInstrumentHours -> 3 Hour,
					IncludedCleanings -> 1,
					IncludedStockingFees -> 5 USD,
					IncludedWasteDisposalFees -> 10 USD,
					IncludedStorage -> 1 Kilo * Centimeter^3,
					IncludedShipmentFees -> 150 USD,
					PrivateTutoringFee -> 200 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "Test lab notebook for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "Test lab notebook 2 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID3,
					Replace[Financers] -> {
						Link[financingTeamID3, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "Test lab notebook 3 for SyncBilling tests"<>$SessionUUID
				|>,
				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in SyncBilling test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Null,
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in SyncBilling test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				<|
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Name -> "Test SM Protocol for SyncBilling test (no instrument used)"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[Model[Instrument, FPLC, "AKTA avant 25"], Objects],
					Name -> "Test FPLC instrument for SyncBilling test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, Sonicator],
					Model -> Link[Model[Instrument, Sonicator, "Branson MH 5800"], Objects],
					Name -> "Test Sonicator instrument for SyncBilling test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Object -> fplcModelID,
					Type -> Model[Instrument, FPLC],
					DeveloperObject -> True,
					Name -> "Fake Model FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[fplcModelID, Objects],
					Name -> "Fake Object FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				Association[
					Object -> operatorModelID,
					QualificationLevel -> 2,
					Name -> "Test Operator Model for SyncBilling test"<>$SessionUUID
				],
				Association[
					Object -> operatorModelID2,
					QualificationLevel -> 3,
					Name -> "Test Operator Model 2 for SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID, Objects],
					Name -> "Test Operator for SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID2, Objects],
					Name -> "Test Operator 2 for SyncBilling test"<>$SessionUUID
				],
				Association[
					Object -> containerID,
					Sterile -> True,
					Reusability -> True,
					CleaningMethod -> Handwash,
					Name -> "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID
				],
				Association[
					Object -> containerID2,
					Sterile -> False,
					Reusability -> True,
					CleaningMethod -> DishwashPlastic,
					Name -> "Test Container Model 2 for SyncBilling test (reusable)"<>$SessionUUID
				],
				Association[
					Object -> containerID3,
					Sterile -> False,
					Reusability -> False,
					CleaningMethod -> Null,
					Name -> "Test Container Model 3 for SyncBilling test (not reusable)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container for SyncBilling test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID2, Objects],
					Reusable -> True,
					Name -> "Test Container 3 for SyncBilling test (dishwash)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID3, Objects],
					Reusable -> False,
					Name -> "Test Container 4 for SyncBilling test (not reusable)"<>$SessionUUID
				],

				(* -- Object[Product] uploads -- *)
				(* public normal sample (stocked, not a kit) *)
				Association[
					Object -> productID1,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1a,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product a for SyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1b,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product b for SyncBilling test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID6,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 6 (public)"<>$SessionUUID
				],
				(* private normal sample (stocked, not a kit) *)
				Association[
					Object -> productID2,
					Notebook -> Link[objectNotebookID, Objects],
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 2 (private)"<>$SessionUUID
				],
				(*TODO: this needs to be updated to point at a kit with some other shit maybe*)
				(* public kit sample *)
				Association[
					Object -> productID3,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Name -> "Test Product for SyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> productID4,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* deprecated public product *)
				Association[
					Object -> productID5,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 5 (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5a,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 5a (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5b,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for SyncBilling test 5b (deprecated)"<>$SessionUUID
				],

				(* -- Model[Sample] uploads -- *)

				(* public normal sample *)
				Association[
					Object -> sampleID1,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1, ProductModel], Link[productID5, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID
				],
				(* private normal sample *)
				Association[
					Object -> sampleID2,
					Notebook -> Link[objectNotebookID, Objects],
					Replace[Products] -> {Link[productID2, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for SyncBilling test 2 (private)"<>$SessionUUID
				],
				(* public kit sample *)
				Association[
					Object -> sampleID3,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1a, ProductModel], Link[productID5a, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> sampleID4,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1b, ProductModel], Link[productID5b, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* second public sample, different storage condition *)
				Association[
					Object -> sampleID5,
					Notebook -> Null,
					Replace[Products] -> {Link[productID6, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Freezer"]],
					Name -> "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID
				],

				(* -- Owned Objects for Storage -- *)
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well UV-Star Plate"], Objects],
					DatePurchased -> Now - 2 Month,
					DateLastUsed -> Now - 3 Week,
					Source -> Link[fplcProtocolID],
					Status -> Available,
					Name -> "Test Plate 1 for SyncBilling tests"<>$SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Replace[StorageConditionLog] -> {
						{Now - 2 * Month, Link[Model[StorageCondition, "Ambient Storage"]], Link[fplcProtocolID]}
					},
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					DatePurchased -> Now - 2 Month,
					DateLastUsed -> Now + 3 Week,
					Source -> Link[fplcProtocolID],
					Status -> Available,
					Name -> "Test 2mL Tube 1 for SyncBilling tests"<>$SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Replace[StorageConditionLog] -> {
						{Now - 2 * Month, Link[Model[StorageCondition, "Ambient Storage"]], Link[fplcProtocolID]}
					},
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				],

				(* -- Object Upload -- *)
				(* public, normal sample *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID1, Objects],
					Name -> "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID
				],
				(*private sample, still has a model*)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID2, Objects],
					Notebook -> Link[objectNotebookID, Objects],
					Name -> "Test Sample for SyncBilling test 2 (private)"<>$SessionUUID
				],
				(* public, part of a kit *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID3, Objects],
					Name -> "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID
				],
				(* public, not stocked *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID4, Objects],
					Name -> "Test Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID
				],
				(* public, deprecated *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID5, Objects],
					Name -> "Test Sample for SyncBilling test 5 (public)"<>$SessionUUID
				],
				(* public, no model *)
				Association[
					Type -> Object[Sample],
					Model -> Null,
					Name -> "Test Sample for SyncBilling test 6 (no model)"<>$SessionUUID
				],

				(*products for materials*)
				<|
					Amount -> Quantity[5., "Grams"],
					CatalogDescription -> "1 x 5. g Null",
					CatalogNumber -> "FAKE123-4",
					DefaultContainerModel -> Link[Model[Container, Vessel, "50mL Tube"], ProductsContained],
					NumberOfItems -> 1,
					Packaging -> Single,
					Price -> Quantity[50.42, "USDollars"],
					Type -> Object[Product],
					UsageFrequency -> VeryHigh,
					DeveloperObject -> True,
					Name -> "Test product for SyncBilling unit tests salt"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for SyncBilling unit tests salt"<>$SessionUUID
					}
				|>,
				<|
					CatalogDescription -> "Small zip lock bag with accoutrements",
					CatalogNumber -> "28952642",
					Deprecated -> False,
					EstimatedLeadTime -> Quantity[1., "Days"],
					NumberOfItems -> 1,
					Packaging -> Pack,
					Price -> Quantity[511., "USDollars"],
					ProductURL -> "https://www.cytivalifesciences.com/en/us/support/products/akta-avant-25-28930842",
					SampleType -> Part,
					Type -> Object[Product],
					UsageFrequency -> High,
					DeveloperObject -> True,
					Name -> "Test product for SyncBilling unit tests seals"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for SyncBilling unit tests seals"<>$SessionUUID
					}
				|>,
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 1 for FPLC in SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 2 for FPLC in SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 3 for FPLC in SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 4 for FPLC in SyncBilling test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 5 for FPLC in SyncBilling test"<>$SessionUUID
				]
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*put some samples into the containers*)
			sampleUpload=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"]
				},
				{
					{"A1", Object[Container, Vessel, "Test Container 1 for FPLC in SyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 2 for FPLC in SyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 3 for FPLC in SyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 4 for FPLC in SyncBilling test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 5 for FPLC in SyncBilling test"<>$SessionUUID]}
				},
				ECL`InternalUpload`InitialAmount -> {
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.5 Gram
				},
				Name -> {
					"Test Sample 1 for FPLC in SyncBilling test"<>$SessionUUID,
					"Test Sample 2 for FPLC in SyncBilling test"<>$SessionUUID,
					"Test Sample 3 for FPLC in SyncBilling test"<>$SessionUUID,
					"Test Sample 4 for FPLC in SyncBilling test"<>$SessionUUID,
					"Test Sample 5 for FPLC in SyncBilling test"<>$SessionUUID
				}
			];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for SyncBilling testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> True,
					Name -> "Test Troubleshooting Report with Refund for SyncBilling"<>$SessionUUID
				|>,
				<|
					Object -> Object[Sample, "Test Sample 1 for FPLC in SyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 2 for FPLC in SyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 3 for FPLC in SyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 4 for FPLC in SyncBilling test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 5 for FPLC in SyncBilling test"<>$SessionUUID],
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				|>,

				(*transaction*)
				Association[
					Type -> Object[Transaction, ShipToECL],
					Name -> "Test ShipToECL transaction for SyncBilling testing"<>$SessionUUID,
					Status -> Received,
					DateDelivered -> Now - 1 Day,
					Notebook -> Link[objectNotebookID, Objects],
					Destination -> Link[$Site],
					Replace[SamplesOut] -> {Link[Object[Sample, "Test Sample 5 for FPLC in SyncBilling test"<>$SessionUUID]]},
					Replace[ContainersOut] -> {Link[Object[Container, Vessel, "Test Container 5 for FPLC in SyncBilling test"<>$SessionUUID]]}
				],

				(*Instrument Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 1 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 2 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 3 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 4 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 5 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 6 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> True,
					Name -> "Test Instrument Resource 7 for SyncBilling tests"<>$SessionUUID
				|>,

				(*Operator Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 6 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 3 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 4 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 5 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 7 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 1 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator 2 for SyncBilling test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model 2 for SyncBilling test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> True,
					Name -> "Test Operator Resource 2 for SyncBilling tests"<>$SessionUUID
				|>,

				(*cleaned container resources*)
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 6 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 3 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 4 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 5 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 7 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 1 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 2 for SyncBilling test (reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 2 for SyncBilling test (reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource 2 for SyncBilling tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 3 for SyncBilling test (not reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 3 for SyncBilling test (not reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 4 for SyncBilling test (not reusable)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 4 for SyncBilling test (not reusable)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Container Resource for SyncBilling Tests (not washable)"
				|>,

				(*stocking resources*)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 1 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 6 for SyncBilling tests"<>$SessionUUID
				],
				(* normal resource - the protocol was refunded so it shouldnt get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 1000 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 3 for SyncBilling tests"<>$SessionUUID
				],
				(* normal resource for the subprotocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 4 for SyncBilling tests"<>$SessionUUID
				],
				(* kit resource for an incomplete protocol (should not get counted) *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 5 for SyncBilling tests"<>$SessionUUID
				],
				(* second public sample which should also get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 5 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 5 (public)"<>$SessionUUID]],
					Amount -> 40 Milliliter,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 7 for SyncBilling tests"<>$SessionUUID
				],
				(* private sample that should not get counted in teh parent protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 2 (private)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 2 (private)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 2 (private)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 2 (private)"<>$SessionUUID]],
					Amount -> 100 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 1 for SyncBilling tests"<>$SessionUUID
				],
				(* public sample without a model which should not get stocked - this should be VOQ'd out *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 6 (no model)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 6 (no model)"<>$SessionUUID]],
					Amount -> 10 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 2 for SyncBilling tests"<>$SessionUUID
				],
				(* kit resource for the top level protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID]],
					Amount -> 30 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Test Resource 8 for SyncBilling tests"<>$SessionUUID
				],

				<|
					Amount -> 1 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 1 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 2 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 3 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 4 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 5 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 6 for SyncBilling testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Sharps,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> True,
					Name -> "A test waste resource 7 for SyncBilling testing"<>$SessionUUID
				|>,
				(*TODO: start fixing with models here*)
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 1 for FPLC in SyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for SyncBilling FPLC unit test 1"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 2 for FPLC in SyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for SyncBilling FPLC unit test 2"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 3 for FPLC in SyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for SyncBilling FPLC unit test 3"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 4 for FPLC in SyncBilling test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> True,
					Name -> "Fake sample resource for SyncBilling FPLC unit test 4"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for SyncBilling testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing not active team object for SyncBilling testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for SyncBilling testing"<>$SessionUUID],

					Object[LaboratoryNotebook, "Test lab notebook for SyncBilling tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for SyncBilling tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in SyncBilling test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in SyncBilling test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in SyncBilling test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in SyncBilling test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in SyncBilling test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in SyncBilling test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in SyncBilling test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for SyncBilling test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for SyncBilling test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for SyncBilling test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for SyncBilling unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for SyncBilling test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for SyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for SyncBilling test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for SyncBilling test"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Bill, "A test bill object for SyncBilling testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for SyncBilling"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for SyncBilling test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for SyncBilling test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for SyncBilling test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for SyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for SyncBilling test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for SyncBilling test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for SyncBilling test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for SyncBilling Tests (not washable)"],

					Model[Sample, "Test Model Sample for SyncBilling test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for SyncBilling test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for SyncBilling test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for SyncBilling test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for SyncBilling test (public)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for SyncBilling test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for SyncBilling tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for SyncBilling tests"<>$SessionUUID],

					Object[Resource, Waste, "A test waste resource 1 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for SyncBilling testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for SyncBilling testing"<>$SessionUUID],

					Object[Sample, "Test Sample 1 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Sample, "Test Sample 5 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Product, "Test product for SyncBilling unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for SyncBilling unit tests seals"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 5 for FPLC in SyncBilling test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for SyncBilling FPLC unit test 4"<>$SessionUUID],

					Object[Transaction, ShipToECL, "Test ShipToECL transaction for SyncBilling testing"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 1 for SyncBilling tests"<>$SessionUUID],
					Object[Container, Plate, "Test Plate 1 for SyncBilling tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];

(* ::Subsection::Closed:: *)
(*updateCurrentBillDiscounts*)
DefineTests[updateCurrentBillDiscounts,
	{
		Example[{Basic,"Function can upload something with multiple bills:"},
			updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 1 for updateCurrentBillDiscounts"<>$SessionUUID]],
			{ObjectP[]..}
		],
		Example[{Basic,"Function can upload something with a single bill:"},
			updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 2 for updateCurrentBillDiscounts"<>$SessionUUID]],
			{ObjectP[]}
		],
		Example[{Basic,"Proper fields are updated in Object[Bill]:"},
			Module[{initialBillPacket,updatedBillPacket,fieldsToCheck},
				initialBillPacket=Download[Object[Team,Financing,"Test financing team 2 for updateCurrentBillDiscounts"<>$SessionUUID],Packet[CurrentBills[All]]][[1]];
				updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 2 for updateCurrentBillDiscounts"<>$SessionUUID]];
				updatedBillPacket=Download[Object[Team,Financing,"Test financing team 2 for updateCurrentBillDiscounts"<>$SessionUUID],Packet[CurrentBills[All]]][[1]];
				fieldsToCheck={IncludedPriorityProtocols,IncludedInstrumentHours,IncludedCleanings,IncludedStockingFees,IncludedWasteDisposalFees,IncludedStorage,IncludedShipmentFees};
				Map[MatchQ[Lookup[initialBillPacket,#],Lookup[updatedBillPacket,#]]&,fieldsToCheck]
			],
			ConstantArray[False,7]
		],
		Example[{Options,Upload,"Returns valid upload packets with Upload->False:"},
			Module[{packets},
				packets=updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 1 for updateCurrentBillDiscounts"<>$SessionUUID],Upload->False];
				{packets,ValidUploadQ@packets}
			],
			{{PacketP[]..},True}
		],
		Example[{Messages,"NotConfiguredTeam","Error out if the financing team is not configured properly (date):"},
			updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 3 for updateCurrentBillDiscounts"<>$SessionUUID],Upload->False],
			$Failed,
			Messages:>{SyncBilling::NotConfiguredTeam}
		],
		Example[{Messages,"NotConfiguredTeam","Error out if the financing team is not configured properly (price scheme):"},
			updateCurrentBillDiscounts[Object[Team,Financing,"Test financing team 4 for updateCurrentBillDiscounts"<>$SessionUUID],Upload->False],
			$Failed,
			Messages:>{SyncBilling::NotConfiguredTeam}
		]
	},
	(* we are resetting our bills all the time so we don't have to make 15 of them *)
	SetUp:>{Upload[{
		<|
			Object->Object[Bill,"Test bill 1 for updateCurrentBillDiscounts"<>$SessionUUID],
			NumberOfThreads->1,
			IncludedPriorityProtocols->1,
			IncludedInstrumentHours->10Hour,
			IncludedCleanings->10,
			IncludedStockingFees->100 USD,
			IncludedWasteDisposalFees->10 USD,
			IncludedStorage->1 Kilo * Centimeter^3,
			IncludedShipmentFees->100 USD
		|>,
		<|
			Object->Object[Bill,"Test bill 2 for updateCurrentBillDiscounts"<>$SessionUUID],
			NumberOfThreads->5,
			IncludedPriorityProtocols->5,
			IncludedInstrumentHours->50Hour,
			IncludedCleanings->50,
			IncludedStockingFees->500 USD,
			IncludedWasteDisposalFees->50 USD,
			IncludedStorage->5 Kilo * Centimeter^3,
			IncludedShipmentFees->500 USD,
			DateStarted->DateObject[{2022,1,2,1,00,00}]
		|>,
		<|
			Object->Object[Bill,"Test bill 3 for updateCurrentBillDiscounts"<>$SessionUUID],
			NumberOfThreads->1,
			IncludedPriorityProtocols->1,
			IncludedInstrumentHours->10Hour,
			IncludedCleanings->10,
			IncludedStockingFees->100 USD,
			IncludedWasteDisposalFees->10 USD,
			IncludedStorage->1 Kilo * Centimeter^3,
			IncludedShipmentFees->100 USD
		|>
	}]},
	SymbolSetUp:>{Module[
		{
			objs,existingObjs,teamID1,teamID2,teamID3,teamID4,
			siteID1,siteID2,
			pricingID1,pricingID2,pricingID3,
			billID1,billID2,billID3,
			uploadPackets
		},

		objs=Quiet[Cases[
			Flatten[{
				Table[Object[Team,Financing,"Test financing team "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,4}],
				Table[Object[Container,Site,"Test site "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,2}],
				Table[Model[Pricing,"Test pricing scheme "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,3}],
				Table[Object[Bill,"Test bill "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,3}]
			}],
			ObjectP[]
		]];
		existingObjs=PickList[objs,DatabaseMemberQ[objs]];
		EraseObject[existingObjs,Force->True,Verbose->False];

		{
			teamID1,teamID2,teamID3,teamID4,
			siteID1,siteID2,
			pricingID1,pricingID2,pricingID3,
			billID1,billID2,billID3
		}=CreateID[Flatten[{
			ConstantArray[Object[Team,Financing],4],
			ConstantArray[Object[Container,Site],2],
			ConstantArray[Model[Pricing],3],
			ConstantArray[Object[Bill],3]
		}]];

		uploadPackets=Flatten[{
			<|
				Object->siteID1,
				Name->"Test site 1 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Object->siteID2,
				Name->"Test site 2 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Object->billID1,
				DeveloperObject->True,
				Name->"Test bill 1 for updateCurrentBillDiscounts"<>$SessionUUID,
				Site->Link[siteID1],
				NumberOfThreads->1,
				IncludedPriorityProtocols->1,
				IncludedInstrumentHours->10Hour,
				IncludedCleanings->10,
				IncludedStockingFees->100 USD,
				IncludedWasteDisposalFees->10 USD,
				IncludedStorage->1 Kilo * Centimeter^3,
				IncludedShipmentFees->100 USD,
				DateStarted->DateObject[{2022, 1, 2, 1, 00, 00}]
			|>,
			<|
				Object->billID2,
				DeveloperObject->True,
				Name->"Test bill 2 for updateCurrentBillDiscounts"<>$SessionUUID,
				Site->Link[siteID2],
				NumberOfThreads->5,
				IncludedPriorityProtocols->5,
				IncludedInstrumentHours->50Hour,
				IncludedCleanings->50,
				IncludedStockingFees->500 USD,
				IncludedWasteDisposalFees->50 USD,
				IncludedStorage->5 Kilo * Centimeter^3,
				IncludedShipmentFees->500 USD,
				DateStarted->DateObject[{2022, 1, 2, 1, 00, 00}]
			|>,
			<|
				Object->billID3,
				DeveloperObject->True,
				Name->"Test bill 3 for updateCurrentBillDiscounts"<>$SessionUUID,
				Site->Link[siteID2],
				NumberOfThreads->1,
				IncludedPriorityProtocols->1,
				IncludedInstrumentHours->10Hour,
				IncludedCleanings->10,
				IncludedStockingFees->100 USD,
				IncludedWasteDisposalFees->10 USD,
				IncludedStorage->1 Kilo * Centimeter^3,
				IncludedShipmentFees->100 USD,
				DateStarted->DateObject[{2022, 1, 2, 1, 00, 00}]
			|>,
			<|
				Object->teamID1,
				Name->"Test financing team 1 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NextBillingCycle->DateObject[{2022, 2, 2, 1, 00, 00}],
				MaxThreads->1,
				Replace[ThreadLog]->{
					{DateObject[{2022, 1, 2, 1, 00, 00}],DateObject[{2022, 1, 15, 1, 00, 00}],1},
					{DateObject[{2022, 1, 15, 1, 00, 00}],Null,5}
				},
				Replace[CurrentPriceSchemes]->{
					{Link[pricingID1],Link[siteID1]},
					{Link[pricingID2],Link[siteID2]}
				},
				Replace[CurrentBills]->{
					{Link[billID1],Link[siteID1]},
					{Link[billID3],Link[siteID2]}
				}
			|>,
			<|
				Object->teamID2,
				Name->"Test financing team 2 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NextBillingCycle->DateObject[{2022, 2, 2, 1, 00, 00}],
				MaxThreads->1,
				Replace[ThreadLog]->{
					{DateObject[{2021, 1, 2, 1, 00, 00}],DateObject[{2022, 1, 15, 1, 00, 00}],1},
					{DateObject[{2021, 1, 15, 1, 00, 00}],Null,5}
				},
				Replace[CurrentPriceSchemes]->{
					{Link[pricingID1],Link[siteID1]}
				},
				Replace[CurrentBills]->{
					{Link[billID1],Link[siteID1]}
				}
			|>,
			<|
				Object->teamID3,
				Name->"Test financing team 3 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NextBillingCycle->Null,
				Replace[CurrentPriceSchemes]->{
					{Link[pricingID1],Link[siteID1]},
					{Link[pricingID2],Link[siteID2]}
				}
			|>,
			<|
				Object->teamID4,
				Name->"Test financing team 4 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NextBillingCycle->DateObject[{2022, 2, 2, 1, 00, 00}],
				Replace[CurrentPriceSchemes]->{}
			|>,
			<|
				Object->pricingID1,
				Name->"Test pricing scheme 1 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NumberOfThreads->1,
				Replace[NumberOfThreadsLog]->{
					{DateObject[{2022, 1, 2, 1, 00, 00}],1},
					{DateObject[{2022, 1, 15, 1, 00, 00}],5}
				},
				IncludedPriorityProtocols->1,
				IncludedInstrumentHours->10Hour,
				IncludedCleanings->10,
				IncludedStockingFees->100 USD,
				IncludedWasteDisposalFees->10 USD,
				IncludedStorage->1 Kilo * Centimeter^3,
				IncludedShipmentFees->100 USD,
				Site->Link[siteID1]
			|>,
			<|
				Object->pricingID2,
				Name->"Test pricing scheme 2 for updateCurrentBillDiscounts"<>$SessionUUID,
				DeveloperObject->True,
				NumberOfThreads->1,
				Replace[NumberOfThreadsLog]->{
					{DateObject[{2022, 1, 2, 1, 00, 00}],1},
					{DateObject[{2022, 1, 15, 1, 00, 00}],5}
				},
				IncludedPriorityProtocols->1,
				IncludedInstrumentHours->10Hour,
				IncludedCleanings->10,
				IncludedStockingFees->100 USD,
				IncludedWasteDisposalFees->10 USD,
				IncludedStorage->1 Kilo * Centimeter^3,
				IncludedShipmentFees->100 USD,
				Site->Link[siteID2]
			|>
		}];

		Upload@uploadPackets
	];
	},
	SymbolTearDown:>{Module[
		{objs,existingObjs},

		objs=Quiet[Cases[
			Flatten[{
				Table[Object[Team,Financing,"Test financing team "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,4}],
				Table[Object[Container,Site,"Test site "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,2}],
				Table[Model[Pricing,"Test pricing scheme "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,3}],
				Table[Object[Bill,"Test bill "<>ToString[n]<>" for updateCurrentBillDiscounts"<>$SessionUUID],{n,1,3}]
			}],
			ObjectP[]
		]];
		existingObjs=PickList[objs,DatabaseMemberQ[objs]];
		EraseObject[existingObjs,Force->True,Verbose->False];
	]}
];


(* ::Subsection::Closed:: *)
(*ExportBillingData*)

DefineTests[ExportBillingData,
	{
		Example[{Basic, "Data can be exported from a bill:"},
			ExportBillingData[Object[Bill, "Test bill for ExportBillingData"], FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]],
			_String
		],
		Example[{Basic, "Data can be exported from multiple bills:"},
			ExportBillingData[{Object[Bill, "Test bill for ExportBillingData"], Object[Bill, "Test empty bill for ExportBillingData"]}, FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]],
			{_String, _String}
		],
		Example[{Basic, "If there is no data in one of the categories, exports a message about it:"},
			(* In MM > 12.0.1 on Manifold, Import needs "XLSX" format specified *)
			importedData=Import[ExportBillingData[Object[Bill, "Test empty bill for ExportBillingData"], FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]], "XLSX"];
			importedData[[2, 1]],
			{"No Data in the Object for this type of Charges"},
			Variables :> {importedData}
		],
		Test["InstrumentTime Charges are collapsed to unique instrument:",
			(* In MM > 12.0.1 on Manifold, Import needs "XLSX" format specified *)
			importedData=Import[ExportBillingData[Object[Bill, "Test bill for ExportBillingData"], FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]], "XLSX"];
			{Length[importedData[[2]]], Length[importedData[[12]]]},
			{2, 4},
			Variables :> {importedData}
		]
	},
	SetUp :> Module[
		{allFileNames},
		(* all possible files that we might have exported *)
		allFileNames={
			"ExportBillingData1team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx",
			"ExportBillingData2team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx"
		};

		(* if the file exists, erase it *)
		If[
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]],
			DeleteFile[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]]
		]& /@ allFileNames;
	],
	TearDown :> Module[
		{allFileNames},
		(* all possible files that we might have exported *)
		allFileNames={
			"ExportBillingData1team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx",
			"ExportBillingData2team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx"
		};

		(* if the file exists, erase it *)
		If[
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]],
			DeleteFile[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]]
		]& /@ allFileNames;
	],
	SymbolSetUp :> Module[
		{
			billObjectID1, billObjectID2, financingTeamID1, financingTeamID2,
			uploadPacket, smProtocol1, smProtocol2, allObjects
		},

		(* make sure that there is a temporary directory we will be working with *)
		Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]]];

		(* all objects used for testing *)
		allObjects={
			Object[Bill, "Test bill for ExportBillingData"],
			Object[Bill, "Test empty bill for ExportBillingData"],
			Object[Team, Financing, "ExportBillingData1team"],
			Object[Team, Financing, "ExportBillingData2team"],
			Object[Protocol, SampleManipulation, "Test SM protocol for ExportBillingData"],
			Object[Protocol, SampleManipulation, "Test SM protocol 2 for ExportBillingData"]
		};

		(* erase existing objects *)
		EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False];

		(* create IDs for test objects *)
		{financingTeamID1, financingTeamID2}=CreateID[{Object[Team, Financing], Object[Team, Financing]}];
		{billObjectID1, billObjectID2}=CreateID[{Object[Bill], Object[Bill]}];
		{smProtocol1, smProtocol2}=CreateID[{Object[Protocol, SampleManipulation], Object[Protocol, SampleManipulation]}];

		(* form an upload packet *)
		uploadPacket={
			<|
				Object -> financingTeamID1,
				Name -> "ExportBillingData1team",
				DeveloperObject -> True
			|>,
			<|
				Object -> financingTeamID2,
				Name -> "ExportBillingData2team",
				DeveloperObject -> True
			|>,
			<|
				Object -> smProtocol1,
				Name -> "Test SM protocol for ExportBillingData",
				DeveloperObject -> True
			|>,
			<|
				Object -> smProtocol2,
				Name -> "Test SM protocol 2 for ExportBillingData",
				DeveloperObject -> True
			|>,
			<|
				Object -> billObjectID1,
				DeveloperObject -> True,
				Status -> Outstanding,
				Organization -> Link[financingTeamID1, BillingHistory, 2],
				DateCompleted -> DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.],
				Replace[OperatorTimeCharges] -> {},
				Replace[InstrumentTimeCharges] -> {
					{
						DateObject[{2021, 1, 1, 2, 19, 3.}, "Instant", "Gregorian", -7.],
						Link[smProtocol1],
						Link[Object[Instrument, Balance, "id:4pO6dMWvnrqw"]], 1,
						Quantity[0.501181, "Hours"],
						Quantity[0., "Hours"],
						Quantity[0., "USDollars"]
					},
					{
						DateObject[{2021, 1, 2, 2, 19, 3.}, "Instant", "Gregorian", -7.],
						Link[smProtocol2],
						Link[Object[Instrument, Balance, "id:4pO6dMWvnrqw"]], 1,
						Quantity[0.501181, "Hours"],
						Quantity[0., "Hours"],
						Quantity[0., "USDollars"]
					}
				},
				Replace[CleanUpCharges] -> {},
				Replace[StockingCharges] -> {},
				Replace[WasteDisposalCharges] -> {},
				Replace[StorageCharges] -> {},
				Replace[ShippingCharges] -> {},
				Replace[CertificationCharges] -> {},
				Replace[MaterialPurchases] -> {},
				Replace[ExperimentsCharged] -> {},
				Name -> "Test bill for ExportBillingData"
			|>,
			<|
				Object -> billObjectID2,
				DeveloperObject -> True,
				Status -> Outstanding,
				Organization -> Link[financingTeamID2, BillingHistory, 2],
				DateCompleted -> DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.],
				Replace[OperatorTimeCharges] -> {},
				Replace[InstrumentTimeCharges] -> {},
				Replace[CleanUpCharges] -> {},
				Replace[StockingCharges] -> {},
				Replace[WasteDisposalCharges] -> {},
				Replace[StorageCharges] -> {},
				Replace[ShippingCharges] -> {},
				Replace[CertificationCharges] -> {},
				Replace[MaterialPurchases] -> {},
				Replace[ExperimentsCharged] -> {},
				Name -> "Test empty bill for ExportBillingData"
			|>};

		(* upload *)
		Upload[uploadPacket];
	],
	SymbolTearDown :> Module[
		{allObjects, allFileNames},

		(* clean up all the objects used in testing*)
		(* all objects used for testing *)
		allObjects={
			Object[Bill, "Test bill for ExportBillingData"],
			Object[Bill, "Test empty bill for ExportBillingData"],
			Object[Team, Financing, "ExportBillingData1team"],
			Object[Team, Financing, "ExportBillingData2team"],
			Object[Protocol, SampleManipulation, "Test SM protocol for ExportBillingData"],
			Object[Protocol, SampleManipulation, "Test SM protocol 2 for ExportBillingData"]
		};

		(* erase existing objects *)
		EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False];

		allFileNames={
			"ExportBillingData1team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx",
			"ExportBillingData2team"<>DateString[(DateObject[{2021, 3, 1, 1, 00, 0.}, "Instant", "Gregorian", -7.] - Quantity[1, "Day"]), {"Year", "MonthName", "Day"}]<>".xlsx"
		};

		(* if the file exists, erase it *)
		If[
			FileExistsQ[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]],
			DeleteFile[FileNameJoin[{$TemporaryDirectory, "exportBillingData", #}]]
		]& /@ allFileNames;

		(* delete the directory*)
		DeleteDirectory[FileNameJoin[{$TemporaryDirectory, "exportBillingData"}]];
	]
];
