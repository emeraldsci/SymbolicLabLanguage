(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*PriceStorage*)


DefineTests[PriceStorage,
	{
		Example[{Basic, "Displays the pricing information for the storage of each container or item in a notebook as a monthly rate if no date range is specified:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional, "If provided no input, finds the pricing of the current notebook:"},
			PriceStorage[],
			_Pane,
			Stubs :> {
				$Notebook=(Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID][Object])
			}
		],
		Example[{Basic, "Displays the pricing information for all items with the protocol and all its subprotocols as the Source:"},
			PriceStorage[Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional, "Displays pricing information for all items with the transaction as the Source:"},
			PriceStorage[Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional, "Displays the pricing information for the storage of each container or item in several notebooks as a monthly rate if no date range is specified:"},
			PriceStorage[{Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for the storage of each container or item in a notebook within the specified date span:"},
			PriceStorage[ Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now - 3 Month, Now - 2.5 Month]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for the storage of each container or item in several notebooks in the specified date range:"},
			PriceStorage[Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID], Span[Now, Now - 1 * Week]],
			_Pane
		],
		Example[{Basic,"Display the pricing information for multi-site team:"},
			PriceStorage[Object[Team,Financing,"A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic,"Display the pricing information for multi-site team for a given time period:"},
			PriceStorage[Object[Team,Financing,"A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID],Span[Now, Now - 1 * Week]],
			_Pane
		],
		Example[{Additional, "If only one notebook was specified, don't display the notebook column in the output table:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now, Now - 1 * Week]],
			_Pane
		],
		Example[{Additional, "Date span can be specified in either order:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now - 2.5 Month, Now - 3 Month]],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, provides a list of associations matching StoragePriceTableP:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], OutputFormat -> Association],
			{StoragePriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> JSON, provides a list of JSON entries :"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], OutputFormat -> JSON],
			_String
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice and a date range is provided, provides a single price combining all storage prices:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now, Now - 1 * Month], OutputFormat -> TotalPrice],
			UnitsP[USD]
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice and a date range is not provided, provides a single monthly rate combining all storage prices:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], OutputFormat -> TotalPrice],
			UnitsP[USD / Month]
		],
		Example[{Options, Consolidation, "If Consolidation -> Notebook, consolidates all the prices for each notebook into a single row of the table:"},
			PriceStorage[{Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID]}, Consolidation -> Notebook],
			_Pane
		],
		Example[{Options, Consolidation, "If Consolidation -> Sample, consolidates all prices for each object being stored in to a single row of the table:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Consolidation -> Sample],
			_Pane
		],
		Example[{Options, Consolidation, "If Consolidation -> StorageCondition, consolidates all prices for storage condition to a single row of the table:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Consolidation -> StorageCondition],
			_Pane
		],
		Example[{Messages, "MissingBill", "If the Bill is not accessible for a given object, throw a soft message and return a table excluding items of that storage condition:"},
			PriceStorage[{Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID]}],
			_Pane,
			Messages :> {PriceStorage::MissingBill},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
						Replace[Financers] -> {}
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
						Replace[Financers] -> {
							Link[Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID], NotebooksFinanced]
						}
					|>
				}]
			}
		],
		Example[{Messages, "BillMissingStorageCondition", "Throw a soft message if the PricingRate is not populated for some waste models:"},
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID]],
			{},
			Messages :> {PriceStorage::BillMissingStorageCondition},
			SetUp :> {
				Upload[
					Association[
						Object -> Download[Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID][BillingHistory][[All, 2]], Object][[1]],
						Replace[StoragePricing] -> {}
					]
				]
			},
			TearDown :> {
				Upload[
					Association[
						Object -> Download[Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID][BillingHistory][[All, 2]], Object][[1]],
						Replace[StoragePricing] -> {
							{
								Link[Model[StorageCondition, "Ambient Storage"]],
								Quantity[1, "USDollars" / ("Centimeters"^3 * "Months")]
							},
							{
								Link[Model[StorageCondition, "Refrigerator"]],
								Quantity[2, "USDollars" / ("Centimeters"^3 * "Months")]
							},
							{
								Link[Model[StorageCondition, "Freezer"]],
								Quantity[3, "USDollars" / ("Centimeters"^3 * "Months")]
							}
						}
					]
				]
			}
		],
		Test["If no notebook or team is provided and OutputFormat -> Table, return an empty list:",
			PriceStorage[{}, OutputFormat -> Table],
			{}
		],
		Test["If no notebook or team is provided and OutputFormat -> Association, return an empty list:",
			PriceStorage[{}, OutputFormat -> Association],
			{}
		],
		Test["If no notebook or team is provided and OutputFormat -> TotalPrice, return 0*USD:",
			PriceStorage[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If the provided notebook has no objects and OutputFormat -> Table, return an empty list:",
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If the provided notebook has no objects and OutputFormat -> Association, return an empty list:",
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If the provided notebook has no objects, no date range is specified, and OutputFormat -> TotalPrice, return 0*USD/Month:",
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD / Month,
			EquivalenceFunction -> Equal
		],
		Test["If the provided notebook has no objects and OutputFormat -> TotalPrice, return 0*USD:",
			PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now - 4 Month, Now - 3.5 Month], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Ensure that the fields in the output association are populated properly in the protocol case:",
			PriceStorage[Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID], OutputFormat -> Association],
			{StoragePriceTableP..}
		],
		Test["Properly populates fields in association output in transaction case:",
			PriceStorage[Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID], OutputFormat -> Association],
			{StoragePriceTableP..}
		],
		Test["Don't include the objects that were excluded by the time span:",
			DeleteDuplicates[Lookup[
				PriceStorage[Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID], Span[Now - 3 Month, Now - 2.5 Month], OutputFormat -> Association],
				Object
			]],
			{
				OrderlessPatternSequence[
					ObjectP[Object[Part, Filter, "Test Filter 1 for PriceStorage tests"<>$SessionUUID]],
					ObjectP[Object[Item, Tips, "Test Tip 1 for PriceStorage tests"<>$SessionUUID]]
				]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceStorage testing"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 1 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 1 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 2 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 3 for PriceStorage tests"<>$SessionUUID],
				Object[Part, Filter, "Test Filter 1 for PriceStorage tests"<>$SessionUUID],
				Object[Part, Filter, "Test Filter 2 for PriceStorage tests"<>$SessionUUID],
				Object[Item, Tips, "Test Tip 1 for PriceStorage tests"<>$SessionUUID],
				Object[Item, Tips, "Test Tip 2 for PriceStorage tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID],
				Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID]}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceStorage testing"<>$SessionUUID],
				Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	Stubs:>{$DeveloperSearch = True},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme 2 (2nd site) for PriceStorage testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 4 (dual site) for PriceStorage tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceStorage testing"<>$SessionUUID],
					Object[Bill, "A test bill object 2 for PriceStorage testing"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 1 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 2 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 3 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 4 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Plate, "Test Plate 1 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Plate, "Test Plate 2 for PriceStorage tests"<>$SessionUUID],
					Object[Container, Plate, "Test Plate 3 for PriceStorage tests"<>$SessionUUID],
					Object[Part, Filter, "Test Filter 1 for PriceStorage tests"<>$SessionUUID],
					Object[Part, Filter, "Test Filter 2 for PriceStorage tests"<>$SessionUUID],
					Object[Item, Tips, "Test Tip 1 for PriceStorage tests"<>$SessionUUID],
					Object[Item, Tips, "Test Tip 2 for PriceStorage tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test protocol 2 to be the source for PriceStorage tests"<>$SessionUUID],
					Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID],
					Object[Container,Site,"Test site for PriceStorage tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet,financingTeamID,modelPricingID1,secondUploadList,syncBillingResult,objectNotebookID,objectNotebookID2,
			newBillObject,objectProtocolID,objectTransactionID,objectSiteID,modelPricingID2,financingTeamID2,objectNotebookID3,objectProtocolID2,syncBillingResult2,newBillObject2},

			modelPricingID1=CreateID[Model[Pricing]];
			modelPricingID2=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			financingTeamID2=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID3=CreateID[Object[LaboratoryNotebook]];
			objectProtocolID=CreateID[Object[Protocol, HPLC]];
			objectProtocolID2=CreateID[Object[Protocol, FPLC]];
			objectTransactionID=CreateID[Object[Transaction, Order]];
			objectSiteID=CreateID[Object[Container,Site]];

			firstSet={
				Association[
					Object->objectProtocolID,
					Name->"Test protocol to be the source for PriceStorage tests"<>$SessionUUID,
					Status->Completed,
					DeveloperObject->True
				],
				Association[
					Object->objectProtocolID2,
					Name->"Test protocol 2 to be the source for PriceStorage tests"<>$SessionUUID,
					Status->Completed,
					DeveloperObject->True
				],
				<|
					Object->objectTransactionID,
					Type->Object[Transaction,Order],
					Name->"Test transaction to be a source for PriceStorage tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->objectSiteID,
					Name->"Test site for PriceStorage tests"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object->financingTeamID,
					MaxThreads->5,
					MaxUsers->2,
					NumberOfUsers->2,
					Status->Active,
					Type->Object[Team,Financing],
					DeveloperObject->True,
					NextBillingCycle->Now - 1Day,
					Replace[CurrentPriceSchemes]->{
						{Link[modelPricingID1],Link@$Site}
					},
					Name->"A test financing team object for PriceStorage testing"<>$SessionUUID
				|>,
				<|
					Object->financingTeamID2,
					MaxThreads->5,
					MaxUsers->2,
					NumberOfUsers->2,
					Status->Active,
					Type->Object[Team,Financing],
					DeveloperObject->True,
					NextBillingCycle->Now - 1Day,
					Replace[CurrentPriceSchemes]->{
						{Link[modelPricingID1],Link@$Site},
						{Link[modelPricingID2],Link@objectSiteID}
					},
					Name->"A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID
				|>,
				<|
					Object->modelPricingID1,
					Type->Model[Pricing],
					Name->"A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID,
					PricingPlanName->"A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID,
					PlanType->Subscription,
					Site->Link[$Site],
					CommitmentLength->12 Month,
					NumberOfBaselineUsers->10,
					CommandCenterPrice->1000 USD,
					ConstellationPrice->500 USD / (1000000 Unit),
					NumberOfThreads->10,
					LabAccessFee->15000USD,
					PricePerExperiment->0 USD,
					Replace[OperatorTimePrice]->{
						{1,1 USD / Hour},
						{2,5 USD / Hour},
						{3,25 USD / Hour},
						{4,75 USD / Hour}
					},
					Replace[InstrumentPricing]->{
						{1,1 USD / Hour},
						{2,5 USD / Hour},
						{3,25 USD / Hour},
						{4,75 USD / Hour}
					},
					Replace[CleanUpPricing]->{
						{"Dishwash glass/plastic bottle",7 USD},
						{"Dishwash plate seals",1 USD},
						{"Handwash large labware",9 USD},
						{"Autoclave sterile labware",9 USD}
					},
					Replace[StockingPricing]->{
						{Link@Model[StorageCondition,"Ambient Storage"],0.05 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Ambient Storage"],0.01 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Freezer"],0.15 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Freezer"],0.05 USD / (Centimeter)^3}
					},
					Replace[WastePricing]->{
						{Chemical,7 USD / Kilogram},
						{Biohazard,7 USD / Kilogram}
					},
					Replace[StoragePricing]->{
						{
							Link[Model[StorageCondition,"Ambient Storage"]],
							Quantity[1,"USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition,"Refrigerator"]],
							Quantity[2,"USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition,"Freezer"]],
							Quantity[3,"USDollars" / ("Centimeters"^3 * "Months")]
						}
					},
					IncludedInstrumentHours->300 Hour,
					IncludedCleanings->90,
					IncludedStockingFees->450 USD,
					IncludedWasteDisposalFees->52.5 USD,
					IncludedStorage->60 Kilo * Centimeter^3,
					IncludedShipmentFees->300 * USD,
					PrivateTutoringFee->0 USD,
					DeveloperObject->True
				|>,
				<|
					Object->modelPricingID2,
					Type->Model[Pricing],
					Name->"A test subscription pricing scheme 2 (2nd site) for PriceStorage testing"<>$SessionUUID,
					PricingPlanName->"A test subscription pricing scheme 2 (2nd site) for PriceStorage testing"<>$SessionUUID,
					PlanType->Subscription,
					Site->Link[objectSiteID],
					CommitmentLength->12 Month,
					NumberOfBaselineUsers->10,
					CommandCenterPrice->1000 USD,
					ConstellationPrice->500 USD / (1000000 Unit),
					NumberOfThreads->10,
					LabAccessFee->15000USD,
					PricePerExperiment->0 USD,
					Replace[OperatorTimePrice]->{
						{1,1 USD / Hour},
						{2,5 USD / Hour},
						{3,25 USD / Hour},
						{4,75 USD / Hour}
					},
					Replace[InstrumentPricing]->{
						{1,1 USD / Hour},
						{2,5 USD / Hour},
						{3,25 USD / Hour},
						{4,75 USD / Hour}
					},
					Replace[CleanUpPricing]->{
						{"Dishwash glass/plastic bottle",7 USD},
						{"Dishwash plate seals",1 USD},
						{"Handwash large labware",9 USD},
						{"Autoclave sterile labware",9 USD}
					},
					Replace[StockingPricing]->{
						{Link@Model[StorageCondition,"Ambient Storage"],0.05 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Ambient Storage"],0.01 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Freezer"],0.15 USD / (Centimeter)^3},
						{Link@Model[StorageCondition,"Freezer"],0.05 USD / (Centimeter)^3}
					},
					Replace[WastePricing]->{
						{Chemical,7 USD / Kilogram},
						{Biohazard,7 USD / Kilogram}
					},
					Replace[StoragePricing]->{
						{
							Link[Model[StorageCondition,"Ambient Storage"]],
							Quantity[100,"USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition,"Refrigerator"]],
							Quantity[200,"USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition,"Freezer"]],
							Quantity[300,"USDollars" / ("Centimeters"^3 * "Months")]
						}
					},
					IncludedInstrumentHours->300 Hour,
					IncludedCleanings->90,
					IncludedStockingFees->450 USD,
					IncludedWasteDisposalFees->52.5 USD,
					IncludedStorage->6 Kilo * Centimeter^3,
					IncludedShipmentFees->300 * USD,
					PrivateTutoringFee->0 USD,
					DeveloperObject->True
				|>,
				<|
					Object->objectNotebookID,
					Replace[Financers]->{
						Link[financingTeamID,NotebooksFinanced]
					},
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"Test lab notebook for PriceStorage tests"<>$SessionUUID
				|>,
				<|
					Object->objectNotebookID2,
					Replace[Financers]->{
						Link[financingTeamID,NotebooksFinanced]
					},
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"Test lab notebook 2 for PriceStorage tests"<>$SessionUUID
				|>,
				<|
					Object->objectNotebookID3,
					Replace[Financers]->{
						Link[financingTeamID2,NotebooksFinanced]
					},
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"Test lab notebook 4 (dual site) for PriceStorage tests"<>$SessionUUID
				|>,
				<|
					Replace[Financers]->{
						Link[financingTeamID,NotebooksFinanced]
					},
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID
				|>,
				Association[
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					Name->"Test 2mL Tube 1 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Name->"Test 2mL Tube 2 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Refrigerator"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Name->"Test 2mL Tube 3 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Freezer"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					Site->Link[$Site],
					Replace[SiteLog]->{
						{Now - 2Month,Link@$Site,Link[objectProtocolID]},
						{Now - 3Day,Link@objectSiteID,Link[objectProtocolID]}
					},
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID2],
					Name->"Test 2mL Tube 4 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Freezer"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID3,Objects]
				],
				Association[
					Type->Object[Container,Plate],
					Model->Link[Model[Container,Plate,"96-well UV-Star Plate"],Objects],
					Site->Link[$Site],
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Status->Available,
					DeveloperObject->True,
					Name->"Test Plate 1 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Container,Plate],
					Model->Link[Model[Container,Plate,"96-well UV-Star Plate"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Name->"Test Plate 2 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					Replace[StorageConditionLog]->{
						{Now - 2 * Month,Link[Model[StorageCondition,"Refrigerator"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Container,Plate],
					Model->Link[Model[Container,Plate,"96-well UV-Star Plate"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 2 Month,
					Source->Link[objectProtocolID],
					Name->"Test Plate 3 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Freezer"]],
					Replace[StorageConditionLog]->{
						{Now - 3 * Month,Link[Model[StorageCondition,"Refrigerator"]],Link[objectProtocolID]},
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Part,Filter],
					Model->Link[Model[Part,Filter,"Miele Dishwasher Coarse Filter"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 3 Month,
					Source->Link[objectProtocolID],
					Name->"Test Filter 1 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Replace[StorageConditionLog]->{
						{Now - 3 * Month,Link[Model[StorageCondition,"Refrigerator"]],Link[objectProtocolID]},
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Link[objectProtocolID]},
						{Now - 1 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Part,Filter],
					Model->Link[Model[Part,Filter,"Miele Dishwasher Coarse Filter"],Objects],
					Site->Link[$Site],
					Status->Available,
					DeveloperObject->True,
					DatePurchased->Now - 3 Month,
					Source->Link[objectTransactionID],
					Name->"Test Filter 2 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					Replace[StorageConditionLog]->{
						{Now - 3 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Null},
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Null},
						{Now - 1 * Month,Link[Model[StorageCondition,"Refrigerator"]],Null}
					},
					Transfer[Notebook]->Link[objectNotebookID2,Objects]
				],
				Association[
					Type->Object[Item,Tips],
					Model->Link[Model[Item,Tips,"1000 uL reach tips, sterile"],Objects],
					Site->Link[$Site],
					Status->Available,
					DatePurchased->Now - 3 Month,
					DeveloperObject->True,
					Name->"Test Tip 1 for PriceStorage tests"<>$SessionUUID,
					Source->Link[objectProtocolID],
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Replace[StorageConditionLog]->{
						{Now - 3 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Link[objectProtocolID]},
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Link[objectProtocolID]},
						{Now - 1 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Link[objectProtocolID]}
					},
					Transfer[Notebook]->Link[objectNotebookID,Objects]
				],
				Association[
					Type->Object[Item,Tips],
					Model->Link[Model[Item,Tips,"1000 uL reach tips, sterile"],Objects],
					Site->Link[$Site],
					Status->Available,
					DatePurchased->Now - 3 Month,
					Source->Link[objectTransactionID],
					DeveloperObject->True,
					Name->"Test Tip 2 for PriceStorage tests"<>$SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					Replace[StorageConditionLog]->{
						{Now - 3 * Month,Link[Model[StorageCondition,"Ambient Storage"]],Null},
						{Now - 2 * Month,Link[Model[StorageCondition,"Freezer"]],Null},
						{Now - 1 * Month,Link[Model[StorageCondition,"Refrigerator"]],Null}
					},
					Transfer[Notebook]->Link[objectNotebookID2,Objects]
				]
			};

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID]],
				{PriceData::MissingBill, PriceStorage::MissingBill}
			];
			syncBillingResult2=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID]],
				{PriceData::MissingBill, PriceStorage::MissingBill}
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];
			newBillObject2=FirstCase[syncBillingResult2,ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceStorage testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month,
					DeveloperObject ->True
				|>,
				<|
					Object -> newBillObject2,
					Name -> "A test bill object 2 for PriceStorage testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month,
					DeveloperObject ->True
				|>,
				Association[
					Object -> objectTransactionID,
					Replace[SamplesOut] -> {
						Link[Object[Part, Filter, "Test Filter 2 for PriceStorage tests"<>$SessionUUID]],
						Link[Object[Item, Tips, "Test Tip 2 for PriceStorage tests"<>$SessionUUID]]
					},
					DeveloperObject ->True
				]
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> {Module[{objs, existingObjs},
		objs=Quiet[Cases[
			Flatten[{
				Object[Team, Financing, "A test financing team object for PriceStorage testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team 2 object (dual site) for PriceStorage testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceStorage testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme 2 (2nd site) for PriceStorage testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceStorage tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 4 (dual site) for PriceStorage tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceStorage testing"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 1 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 1 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 2 for PriceStorage tests"<>$SessionUUID],
				Object[Container, Plate, "Test Plate 3 for PriceStorage tests"<>$SessionUUID],
				Object[Part, Filter, "Test Filter 1 for PriceStorage tests"<>$SessionUUID],
				Object[Part, Filter, "Test Filter 2 for PriceStorage tests"<>$SessionUUID],
				Object[Item, Tips, "Test Tip 1 for PriceStorage tests"<>$SessionUUID],
				Object[Item, Tips, "Test Tip 2 for PriceStorage tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test protocol to be the source for PriceStorage tests"<>$SessionUUID],
				Object[Transaction, Order, "Test transaction to be a source for PriceStorage tests"<>$SessionUUID],
				Object[Container,Site,"Test site for PriceStorage tests"<>$SessionUUID]
			}],
			ObjectP[]
		]];
		existingObjs=PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	]}
];


(* ::Subsection::Closed:: *)
(*PriceWaste*)

DefineTests[
	PriceWaste,
	{
		(*---- Tests for the old system based on WasteGenerated ----*)
		Example[{Basic, "Displays the pricing information for each waste type used in a protocol and its subprotocols:"},
			PriceWaste[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the waste pricing information for all protocols tied to a given notebook:"},
			PriceWaste[Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 2 * Day
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceWaste[Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 1 Day
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 1 Day
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Example[{Additional,Site,"When using a different Site, properly pull information (old system):"},
			PriceWaste[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional,Site,"When using different sites for protocols, pull the information correctly (old system):"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]}],
			_Pane
		],
		Example[{Additional,Site,"When using different sites for protocols, calculates the total price correctly (old system):"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]},OutputFormat -> TotalPrice],
			(* I could not make MatchQ work so I am using RangeP even though the results are the same every time I run the test *)
			RangeP[Quantity[95.32,"USDollars"],Quantity[95.34,"USDollars"]]
		],
		Example[{Additional, "If a protocol has been refunded, do not include it in the pricing:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}],
			_Pane
		],
		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceWaste is called on a subprotocol:"},
			PriceWaste[Object[Protocol, Centrifuge, "Test Protocol Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID]],
			$Failed,
			Messages :> {PriceWaste::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceWaste is called on a protocol that is not Completed:"},
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID]],
			$Failed,
			Messages :> {PriceWaste::ProtocolNotCompleted},
			SetUp :> {Upload[<|Object -> Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], Status -> Processing|>]},
			TearDown :> {Upload[<|Object -> Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], Status -> Completed|>]}
		],
		Example[{Messages, "MissingPricingRate", "Throw a soft message if the PricingRate is not populated for some waste models:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 4 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}],
			_Pane,
			Messages :> {PriceWaste::MissingPricingRate}
		],
		Test["If PricingRate is not populated for some wastes, still return the correct total price if OutputFormat -> TotalPrice:",
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 4 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}, OutputFormat -> TotalPrice],
			GreaterP[0 * USD],
			Messages :> {PriceWaste::MissingPricingRate}
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			PriceWaste[Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID], Span[DateObject["15 February 2018"], DateObject["15 March 2018"]]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> DateObject["1 March 2018"]
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Example[{Additional, "Date span can go in either order:"},
			PriceWaste[Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID], Span[DateObject["15 March 2018"], DateObject["15 February 2018"]]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> DateObject["1 March 2018"]
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Test["If no waste was generated and OutputFormat -> Table, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no waste was generated and OutputFormat -> Association, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no waste was generated and OutputFormat -> TotalPrice, return $0.00:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching WastePriceTableP:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}, OutputFormat -> Association],
			{WastePriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of every waste type:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]}, OutputFormat -> TotalPrice],
			GreaterP[0 USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, Consolidation -> Notebook],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, Consolidation -> Protocol],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> WasteType groups all items by WasteType and sums their prices in the output table:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, Consolidation -> WasteType],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, Consolidation -> Protocol, OutputFormat -> TotalPrice],
			GreaterP[0 USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching WastePriceTableP:"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, Consolidation -> Protocol, OutputFormat -> Association],
			{WastePriceTableP..}
		],
		Test["If no waste has been generated and OutputFormat -> Table, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no waste has been generated and OutputFormat -> Association, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no waste has been generated and OutputFormat -> TotalPrice, return $0.00:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceWaste[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceWaste[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceWaste[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			DeleteDuplicates[Lookup[
				PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID], Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID]}, OutputFormat -> Association],
				Source
			]],
			{ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]], ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID]]}
		],
		Test["Specifying a span of times excludes protocols that fall outside that range:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID], Span[DateObject["15 February 2018"], DateObject["15 March 2018"]], OutputFormat -> Association],
				Source
			]],
			{ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> DateObject["1 March 2018"]
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Test["If a date range is not specified, then get all the protocols in the last month:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Association],
				Source
			]],
			{ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 3 * Week
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Span[Now - 1 * Week, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 3 * Week
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={}
			}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 3 * Week
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], OutputFormat -> Association],
				Source
			]],
			{ObjectReferenceP[Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						DateCompleted -> Now - 3 * Week
					|>
				}]
			},
			Stubs :> {
				Search[Object[LaboratoryNotebook], ___]:={Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID], Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID]},
				Search[{Object[Protocol], Object[Qualification], Object[Maintenance]}, ___]:={Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID]}
			}
		],


		(*---- Tests for only the new system (based on Object[Resource, Waste] ----*)
		(* we are stabbing $WasteResourcePricingDate because we don't know when the switch is happening *)
		Example[{Basic, "Displays the pricing information for each waste type used in a protocol and its subprotocols:"},
			PriceWaste[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceWaste[{Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID], Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]}],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Basic, "Displays the waste pricing information for all protocols tied to a given notebook:"},
			PriceWaste[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID]],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceWaste[Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID]],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Additional,Site,"When using a different Site, properly pull information (new system):"},
			PriceWaste[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional,Site,"When using different sites for protocols, pull the information correctly (new system):"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]}],
			_Pane
		],
		Example[{Additional,Site,"When using different sites for protocols, calculates the total price correctly (new system):"},
			PriceWaste[{Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID]},OutputFormat -> TotalPrice],
			(* I could not make MatchQ work so I am using RangeP even though the results are the same every time I run the test *)
			RangeP[Quantity[95.32,"USDollars"],Quantity[95.34,"USDollars"]]
		],
		Example[{Additional, "If a protocol has been refunded, do not include it in the pricing:"},
			PriceWaste[{
				Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]
			}],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceWaste is called on a subprotocol:"},
			PriceWaste[Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceWaste::ParentProtocolRequired},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceWaste is called on a protocol that is not Completed:"},
			PriceWaste[Object[Protocol, HPLC, "Test HPLC protocol 4 (incomplete) for PriceWaste tests"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceWaste::ProtocolNotCompleted},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Messages, "MissingPricingRate", "Throw a soft message if the PricingRate is not populated for some waste models:"},
			PriceWaste[{
				Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID]
			}],
			_Pane,
			Messages :> {PriceWaste::MissingPricingRate},
			SetUp :> {
				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
						Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID], Objects]
					]
				]
			},
			TearDown :> {
				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
						Transfer[Notebook] -> Null
					]
				]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If PricingRate is not populated for some wastes, still return the correct total price if OutputFormat -> TotalPrice:",
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			GreaterP[0 * USD],
			Messages :> {PriceWaste::MissingPricingRate},
			SetUp :> {
				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
						Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID], Objects]
					]
				]
			},
			TearDown :> {
				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
						Transfer[Notebook] -> Null
					]
				]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			PriceWaste[
				Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
				Span[Now - 2.5 Week, Now - 1.5 Week]
			],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Additional, "Date span can go in either order:"},
			PriceWaste[
				Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now - 2.5 Week]
			],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste was generated and OutputFormat -> Table, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> Table],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste was generated and OutputFormat -> Association, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> Association],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste was generated and OutputFormat -> TotalPrice, return $0.00:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching WastePriceTableP:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{WastePriceTableP..},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of every waste type:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			GreaterP[0 USD],
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				Consolidation -> Protocol
			],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> WasteType groups all items by WasteType and sums their prices in the output table:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				Consolidation -> WasteType
			],
			_Pane,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				Consolidation -> Protocol,
				OutputFormat -> TotalPrice
			],
			GreaterP[0 USD],
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching WastePriceTableP:"},
			PriceWaste[
				{
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]
				},
				Consolidation -> Protocol,
				OutputFormat -> Association
			],
			{WastePriceTableP..},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste has been generated and OutputFormat -> Table, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> Table],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste has been generated and OutputFormat -> Association, return an empty list:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> Association],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If no waste has been generated and OutputFormat -> TotalPrice, return $0.00:",
			PriceWaste[Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceWaste[{}, OutputFormat -> Table],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceWaste[{}, OutputFormat -> Association],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceWaste[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal,
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If a protocol has been refunded, do include it, but zero out the pricing:",
			DeleteDuplicates[Lookup[
				PriceWaste[
					{
						Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
						Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
						Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]
					},
					OutputFormat -> Association
				],
				Source
			]],
			{
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["Specifying a span of times excludes protocols that fall outside that range:",
			DeleteDuplicates[Lookup[
				PriceWaste[
					Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
					Span[Now - 2.5 Week, Now - 1.5 Week],
					OutputFormat -> Association
				],
				Source
			]],
			{
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If a date range is not specified, then get all the protocols in the last month:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID], Span[Now - 1 * Week, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID],
					Span[Now - 2.5 * Week, Now - 1.5 * Week],
					OutputFormat -> Association
				],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceWaste[Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID]],
				ObjectP[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID]]
			},
			Stubs :> {$WasteResourcePricingDate=DateObject[{2015, 1, 1, 0, 0, 1.`}, "Instant", "Gregorian", -7.`]}
		],
		Test["Objects for the test exist in the database:",
			Download[{Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceWaste testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 4 (incomplete) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 1 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 2 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 3 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 4 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 5 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 6 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 7 for PriceWaste testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceWaste"<>$SessionUUID]}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceWaste testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceWaste"<>$SessionUUID]}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceWaste testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 4 (incomplete) for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 1 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for PriceWaste testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for PriceWaste testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceWaste"<>$SessionUUID],
					Object[Container,Site, "Test extremely expensive site for PriceWaste testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceWaste testing expensive site"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceWaste testing expensive site"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID],
					Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests expensive site"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 8 for PriceWaste testing expensive site"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{financingTeamID,modelPricingID1,objectNotebookID,objectNotebookID2,firstSet,secondSet,syncBillingResult,
			newBillObject,objectProtocolID,modelPricingID2,objectProtocolID2,objectSite,objectProtocolID3},

			{
				financingTeamID,modelPricingID1,modelPricingID2,objectNotebookID,objectNotebookID2,
				objectProtocolID,objectProtocolID2,objectProtocolID3,objectSite
			}=CreateID[{
				Object[Team,Financing],Model[Pricing],Model[Pricing],Object[LaboratoryNotebook],Object[LaboratoryNotebook],
				Object[Protocol,HPLC],Object[Protocol,HPLC],Object[Protocol,HPLC],Object[Container,Site]
			}];

			firstSet=List[
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] -> {
						{Link@modelPricingID1,Link@$Site},
						{Link@modelPricingID2,Link@objectSite}
					},
					Name -> "A test financing team object for PriceWaste testing"<>$SessionUUID,
					DefaultExperimentSite->Link[$Site]
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID,
					Site->Link[$Site],
					PlanType -> Subscription,
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
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
						{Biohazard, 14 USD / Kilogram}
					},
					Replace[StoragePricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.1 USD / (Centimeter)^3 / Month},
						{Link@Model[StorageCondition, "Freezer"], 1 USD / (Centimeter)^3 / Month}
					},
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 450 USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object -> modelPricingID2,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceWaste testing expensive site"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceWaste testing expensive site"<>$SessionUUID,
					Site->Link[objectSite],
					PlanType -> Subscription,
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 10 USD / Hour},
						{2, 50 USD / Hour},
						{3, 250 USD / Hour},
						{4, 750 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 10 USD / Hour},
						{2, 50 USD / Hour},
						{3, 250 USD / Hour},
						{4, 750 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 70 USD},
						{"Dishwash plate seals", 10 USD},
						{"Handwash large labware", 90 USD},
						{"Autoclave sterile labware", 90 USD}
					},
					Replace[StockingPricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 0.5 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Ambient Storage"], 0.1 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 1.5 USD / (Centimeter)^3},
						{Link@Model[StorageCondition, "Freezer"], 0.5 USD / (Centimeter)^3}
					},
					Replace[WastePricing] -> {
						{Chemical, 70 USD / Kilogram},
						{Biohazard, 140 USD / Kilogram}
					},
					Replace[StoragePricing] -> {
						{Link@Model[StorageCondition, "Ambient Storage"], 1.0 USD / (Centimeter)^3 / Month},
						{Link@Model[StorageCondition, "Freezer"], 10 USD / (Centimeter)^3 / Month}
					},
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 450 USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object->objectSite,
					DeveloperObject->True,
					Name->"Test extremely expensive site for PriceWaste testing"<>$SessionUUID,
					Replace[WastePrices]->{
						{Chemical, 34.5 USD/Kilogram},
						{Drain, 10 USD/Kilogram}
					}
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceWaste tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceWaste tests"<>$SessionUUID
				|>,
				Association[
					Object -> objectProtocolID,
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol for PriceWaste tests"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					DateCreated -> Now - 15 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Object -> objectProtocolID3,
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol for PriceWaste tests expensive site"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					DateCreated -> Now - 15 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[objectSite],
					Replace[WasteGenerated]->{
						<|Waste -> Link@Model[Sample, "Aqueous Acidic Waste"],Weight -> Quantity[500, "Grams"]|>,
						<|Waste -> Link@Model[Sample, "Organic Basic Waste"], Weight -> Quantity[2000., "Grams"]|>
					}
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					DateCreated -> Now - 8 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					DateCreated -> Now - 15 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol 4 (incomplete) for PriceWaste tests"<>$SessionUUID,
					DateCreated -> Now - 13 Day,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID,
					DateCreated -> Now - 16 Day,
					Status -> Completed,
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, SampleManipulation],
					Name -> "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					DateCreated -> Now - 15 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Centrifuge],
					Name -> "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					DateCreated -> Now - 15 Day,
					Status -> Completed,
					ParentProtocol -> Link[objectProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				]
			];


			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			secondSet=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceWaste testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceWaste"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 1 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 2 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 3 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 4 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 5 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 6 for PriceWaste testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Sharps,
					Replace[Requestor] -> {
						Link[Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 7 for PriceWaste testing"<>$SessionUUID
				|>
			];

			Upload[secondSet];


		];
		(* New temporary test objects for old system *)
		(* This is just a straight copy of the permanent test objects currently in the database to enable us to update for support tickets *)
		Module[
			{allNamedObjects, existingObjects, test1Packets, allUploadPackets},

			(* All named objects created for these unit tests *)
			allNamedObjects = Cases[
				Flatten[{
					{
						Object[Container, Site, "Test Container Site 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Model[Instrument, HPLC, "Test Model Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, Centrifuge, "Test Protocol Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, Centrifuge, "Test Protocol Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, Centrifuge, "Test Instrument Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, Centrifuge, "Test Instrument Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, FumeHood, "Test Instrument FumeHood 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 4 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 5 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Plate, "Test Container Plate 6 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Vessel, "Test Container Vessel 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Vessel, "Test Container Vessel 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Vessel, "Test Container Vessel 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Vessel, "Test Container Vessel 4 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Container, Vessel, "Test Container Vessel 5 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 4 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 5 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 6 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 7 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Sample, "Test Sample 8 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Item, Tips, "Test Item Tips 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Item, Tips, "Test Item Tips 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Part, Filter, "Test Part Filter 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Part, Filter, "Test Part Filter 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 4 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 5 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 6 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 7 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 8 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Operator, "Test Resource Operator 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Operator, "Test Resource Operator 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Operator, "Test Resource Operator 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Sample, "Test Resource Sample 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Sample, "Test Resource Sample 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Sample, "Test Resource Sample 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[SupportTicket, UserCommunication, "Test SupportTicket UserCommunication 1 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[SupportTicket, UserCommunication, "Test SupportTicket UserCommunication 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Model[Instrument, HPLC, "Test Model Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Protocol, HPLC, "Test Protocol HPLC 4 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, Centrifuge, "Test Instrument Centrifuge 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test Instrument HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[LaboratoryNotebook, "Test LaboratoryNotebook 3 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 9 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource Instrument 10 for Old PriceWaste unit tests " <> $SessionUUID],
						Object[Team, Financing, "Test Team Financing 2 for Old PriceWaste unit tests " <> $SessionUUID]
					}
				}],
				ObjectReferenceP[]
			];

			existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];

			test1Packets = Module[
				{
					containerSite1,
					modelInstrumentHPLC1,
					modelInstrumentHPLC2,
					protocolCentrifuge1,
					protocolCentrifuge2,
					protocolHPLC1,
					protocolHPLC2,
					protocolHPLC3,
					protocolHPLC4,
					protocolSampleManipulation1,
					protocolSampleManipulation2,
					instrumentCentrifuge1,
					instrumentCentrifuge2,
					instrumentCentrifuge3,
					instrumentFumeHood1,
					instrumentHPLC1,
					instrumentHPLC2,
					instrumentHPLC3,
					containerPlate1,
					containerPlate2,
					containerPlate3,
					containerPlate4,
					containerPlate5,
					containerPlate6,
					containerVessel1,
					containerVessel2,
					containerVessel3,
					containerVessel4,
					containerVessel5,
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					itemTips1,
					itemTips2,
					laboratorynotebook1,
					laboratorynotebook2,
					laboratorynotebook3,
					partFilter1,
					partFilter2,
					resourceInstrument1,
					resourceInstrument2,
					resourceInstrument3,
					resourceInstrument4,
					resourceInstrument5,
					resourceInstrument6,
					resourceInstrument7,
					resourceInstrument8,
					resourceInstrument9,
					resourceInstrument10,
					resourceOperator1,
					resourceOperator2,
					resourceOperator3,
					resourceSample1,
					resourceSample2,
					resourceSample3,
					teamFinancing1,
					teamFinancing2,
					supportTicketUserCommunication1,
					supportTicketUserCommunication2,
					linkIDs
				},

				{
					containerSite1,
					modelInstrumentHPLC1,
					modelInstrumentHPLC2,
					protocolCentrifuge1,
					protocolCentrifuge2,
					protocolHPLC1,
					protocolHPLC2,
					protocolHPLC3,
					protocolHPLC4,
					protocolSampleManipulation1,
					protocolSampleManipulation2,
					instrumentCentrifuge1,
					instrumentCentrifuge2,
					instrumentCentrifuge3,
					instrumentFumeHood1,
					instrumentHPLC1,
					instrumentHPLC2,
					instrumentHPLC3,
					containerPlate1,
					containerPlate2,
					containerPlate3,
					containerPlate4,
					containerPlate5,
					containerPlate6,
					containerVessel1,
					containerVessel2,
					containerVessel3,
					containerVessel4,
					containerVessel5,
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					itemTips1,
					itemTips2,
					laboratorynotebook1,
					laboratorynotebook2,
					laboratorynotebook3,
					partFilter1,
					partFilter2,
					resourceInstrument1,
					resourceInstrument2,
					resourceInstrument3,
					resourceInstrument4,
					resourceInstrument5,
					resourceInstrument6,
					resourceInstrument7,
					resourceInstrument8,
					resourceInstrument9,
					resourceInstrument10,
					resourceOperator1,
					resourceOperator2,
					resourceOperator3,
					resourceSample1,
					resourceSample2,
					resourceSample3,
					teamFinancing1,
					teamFinancing2,
					supportTicketUserCommunication1,
					supportTicketUserCommunication2
				} = CreateID[
					{
						Object[Container, Site],
						Model[Instrument, HPLC],
						Model[Instrument, HPLC],
						Object[Protocol, Centrifuge],
						Object[Protocol, Centrifuge],
						Object[Protocol, HPLC],
						Object[Protocol, HPLC],
						Object[Protocol, HPLC],
						Object[Protocol, HPLC],
						Object[Protocol, SampleManipulation],
						Object[Protocol, SampleManipulation],
						Object[Instrument, Centrifuge],
						Object[Instrument, Centrifuge],
						Object[Instrument, Centrifuge],
						Object[Instrument, FumeHood],
						Object[Instrument, HPLC],
						Object[Instrument, HPLC],
						Object[Instrument, HPLC],
						Object[Container, Plate],
						Object[Container, Plate],
						Object[Container, Plate],
						Object[Container, Plate],
						Object[Container, Plate],
						Object[Container, Plate],
						Object[Container, Vessel],
						Object[Container, Vessel],
						Object[Container, Vessel],
						Object[Container, Vessel],
						Object[Container, Vessel],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Item, Tips],
						Object[Item, Tips],
						Object[LaboratoryNotebook],
						Object[LaboratoryNotebook],
						Object[LaboratoryNotebook],
						Object[Part, Filter],
						Object[Part, Filter],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Instrument],
						Object[Resource, Operator],
						Object[Resource, Operator],
						Object[Resource, Operator],
						Object[Resource, Sample],
						Object[Resource, Sample],
						Object[Resource, Sample],
						Object[Team, Financing],
						Object[Team, Financing],
						Object[SupportTicket, UserCommunication],
						Object[SupportTicket, UserCommunication]
					}
				];

				linkIDs = CreateLinkID[48];

				{
					<|
						Object -> containerSite1,
						Type -> Object[Container, Site],
						Name -> "Test Container Site 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Replace[WastePrices] -> {
							{Chemical, 3.45 USD / Kilogram},
							{Drain, 3.45 USD / Kilogram}
						}
					|>,
					<|
						Object -> modelInstrumentHPLC1,
						Type -> Model[Instrument, HPLC],
						Name -> "Test Model Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID,
						PricingCategory -> "HPLC",
						PricingRate -> 24.5 USD/Hour,
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolCentrifuge1,
						Type -> Object[Protocol, Centrifuge],
						Name -> "Test Protocol Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID,
						ParentProtocol -> Link[protocolHPLC1, Subprotocols, linkIDs[[13]]],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources]->{
							{Link[resourceInstrument5, Requestor, linkIDs[[26]]], Null, Null, Null},
							{Link[resourceSample1, Requestor, linkIDs[[27]]], Null, Null, Null},
							{Link[resourceOperator3, Requestor, linkIDs[[28]]], Null, Null, Null},
							{Link[resourceSample3, Requestor, linkIDs[[29]]], Null, Null, Null}
						},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[Subprotocols] -> {Link[protocolSampleManipulation1, ParentProtocol, linkIDs[[30]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolCentrifuge2,
						Type -> Object[Protocol, Centrifuge],
						Name -> "Test Protocol Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID,
						ParentProtocol -> Link[protocolHPLC3, Subprotocols, linkIDs[[25]]],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources] -> {{Link[resourceInstrument7, Requestor, linkIDs[[32]]], Null, Null, Null}},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolHPLC1,
						Type -> Object[Protocol, HPLC],
						Name -> "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID,
						DateCompleted -> DateObject[{2021, 3, 2, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources]->{
							{Link[resourceInstrument1, Requestor, linkIDs[[1]]], Null, Null, Null},
							{Link[resourceSample1, Requestor, linkIDs[[2]]], Null, Null, Null},
							{Link[resourceOperator1, Requestor, linkIDs[[3]]], Null, Null, Null},
							{Link[resourceInstrument2, Requestor, linkIDs[[4]]], Null, Null, Null}
						},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[SubprotocolRequiredResources]->{
							Link[resourceInstrument1, RootProtocol, linkIDs[[5]]],
							Link[resourceInstrument5, RootProtocol, linkIDs[[6]]],
							Link[resourceOperator1, RootProtocol, linkIDs[[7]]],
							Link[resourceInstrument6, RootProtocol, linkIDs[[8]]],
							Link[resourceSample1, RootProtocol, linkIDs[[9]]],
							Link[resourceOperator3, RootProtocol, linkIDs[[10]]],
							Link[resourceSample3, RootProtocol, linkIDs[[11]]],
							Link[resourceInstrument2, RootProtocol, linkIDs[[12]]]
						},
						Replace[Subprotocols] -> {Link[protocolCentrifuge1, ParentProtocol, linkIDs[[13]]]},
						Replace[UserCommunications] -> {Link[supportTicketUserCommunication1, AffectedProtocol, linkIDs[[14]]]},
						Replace[WasteGenerated] -> {<|Waste -> Link[Model[Sample, "id:KBL5DvwZrPKj"]], Weight -> 127.55 Gram|>, <|Waste -> Link[Model[Sample, "id:jLq9jXvlxOza"]], Weight -> 1478. Gram|>},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolHPLC2,
						Type -> Object[Protocol, HPLC],
						Name -> "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID,
						DateCompleted -> DateObject[{2018, 2, 28, 15, 42, 16.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources] -> {{Link[resourceInstrument3, Requestor, linkIDs[[15]]], Null, Null, Null}},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[SubprotocolRequiredResources] -> {Link[resourceInstrument3, RootProtocol, linkIDs[[16]]]},
						Replace[UserCommunications] -> {Link[supportTicketUserCommunication2, AffectedProtocol, linkIDs[[17]]]},
						Replace[WasteGenerated] -> {<|Waste -> Link[Model[Sample, "id:KBL5DvwZrPKj"]], Weight -> 100. Gram|>, <|Waste -> Link[Model[Sample, "id:jLq9jXvlxOza"]], Weight -> 2000. Gram|>},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolHPLC3,
						Type -> Object[Protocol, HPLC],
						Name -> "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID,
						DateCompleted -> DateObject[{2021, 2, 21, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources]->{
							{Link[resourceInstrument4, Requestor, linkIDs[[18]]], Null, Null, Null},
							{Link[resourceSample2, Requestor, linkIDs[[19]]], Null, Null, Null},
							{Link[resourceOperator2, Requestor, linkIDs[[20]]], Null, Null, Null}
						},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[SubprotocolRequiredResources]->{
							Link[resourceInstrument4, RootProtocol, linkIDs[[21]]],
							Link[resourceInstrument7, RootProtocol, linkIDs[[22]]],
							Link[resourceOperator2, RootProtocol, linkIDs[[23]]],
							Link[resourceSample2, RootProtocol, linkIDs[[24]]]
						},
						Replace[Subprotocols] -> {Link[protocolCentrifuge2, ParentProtocol, linkIDs[[25]]]},
						Replace[WasteGenerated] -> {<|Waste -> Link[Model[Sample, "id:KBL5DvwZrPKj"]], Weight -> 37.988 Gram|>, <|Waste -> Link[Model[Sample, "id:jLq9jXvlxOza"]], Weight -> 2301. Gram|>},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolSampleManipulation1,
						Type -> Object[Protocol, SampleManipulation],
						Name -> "Test Protocol SampleManipulation 1 for Old PriceWaste unit tests " <> $SessionUUID,
						ParentProtocol -> Link[protocolCentrifuge1, Subprotocols, linkIDs[[30]]],
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources] -> {{Link[resourceInstrument6, Requestor, linkIDs[[31]]], Null, Null, Null}},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[WasteGenerated] -> {<|Waste -> Link[Model[Sample, "id:KBL5DvwZrPKj"]], Weight -> 249.0988 Gram|>, <|Waste -> Link[Model[Sample, "id:7X104vnRY6eJ"]], Weight -> 777.77 Gram|>},
						DeveloperObject -> True
					|>,
					<|
						Object -> protocolSampleManipulation2,
						Type -> Object[Protocol, SampleManipulation],
						Name -> "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[AliquotSamplesPrices] -> {0. USD/Month},
						Replace[PurchasedItemsPrices] -> {0. USD/Month},
						Replace[RequiredResources] -> {{Link[resourceInstrument8, Requestor, linkIDs[[43]]], Null, Null, Null}},
						Replace[SamplesOutPrices] -> {0. USD/Month},
						Replace[StoragePrices] -> {0. USD/Month},
						Replace[SubprotocolRequiredResources] -> {Link[resourceInstrument8, RootProtocol, linkIDs[[44]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentCentrifuge1,
						Type -> Object[Instrument, Centrifuge],
						Name -> "Test Instrument Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Instrument, Centrifuge, "id:qdkmxzqeR16a"], Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentCentrifuge2,
						Type -> Object[Instrument, Centrifuge],
						Name -> "Test Instrument Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Instrument, Centrifuge, "id:qdkmxzqeR16a"], Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentFumeHood1,
						Type -> Object[Instrument, FumeHood],
						Name -> "Test Instrument FumeHood 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Instrument, FumeHood, "id:R8e1PjprvYOK"], Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentHPLC1,
						Type -> Object[Instrument, HPLC],
						Name -> "Test Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[modelInstrumentHPLC1, Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentHPLC2,
						Type -> Object[Instrument, HPLC],
						Name -> "Test Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[modelInstrumentHPLC1, Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate1,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:n0k9mGzRaaBn"], Objects],
						AwaitingStorageUpdate -> True,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:N80DNj1r04jW"]],
						Replace[Contents] -> {{"A1", Link[sample5, Container, linkIDs[[39]]]}, {"B2", Link[sample6, Container, linkIDs[[40]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate2,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:6V0npvK611zG"], Objects],
						AwaitingStorageUpdate -> True,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Stocked,
						StorageCondition -> Link[Model[StorageCondition, "id:vXl9j57YlZ5N"]],
						Replace[Contents] -> {{"A1", Link[sample7, Container, linkIDs[[41]]]}, {"B2", Link[sample8, Container, linkIDs[[42]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate3,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:01G6nvkKrrYm"], Objects],
						DateDiscarded -> DateObject[{2021, 3, 1, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Discarded,
						StorageCondition -> Link[Model[StorageCondition, "id:N80DNj1r04jW"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate4,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 4 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:n0k9mGzRaaBn"], Objects],
						AwaitingStorageUpdate -> True,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 27, 13, 29, 17.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate5,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 5 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:jLq9jXY4kkKW"], Objects],
						AwaitingDisposal -> True,
						AwaitingStorageUpdate -> True,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 27, 13, 29, 17.}, "Instant", "Gregorian", -7.],
						Restricted -> True,
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerPlate6,
						Type -> Object[Container, Plate],
						Name -> "Test Container Plate 6 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Plate, "id:Z1lqpMGjeekO"], Objects],
						AwaitingStorageUpdate -> True,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 27, 13, 29, 17.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:xRO9n3BVOe3z"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerVessel1,
						Type -> Object[Container, Vessel],
						Name -> "Test Container Vessel 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
						AwaitingDisposal -> True,
						AwaitingStorageUpdate -> True,
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:N80DNj1r04jW"]],
						Replace[Contents] -> {{"A1", Link[sample1, Container, linkIDs[[35]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerVessel2,
						Type -> Object[Container, Vessel],
						Name -> "Test Container Vessel 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjkY"], Objects],
						AwaitingStorageUpdate -> True,
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Reusable -> True,
						Site -> Link[containerSite1],
						Status -> Stocked,
						StorageCondition -> Link[Model[StorageCondition, "id:vXl9j57YlZ5N"]],
						Replace[Contents] -> {{"A1", Link[sample2, Container, linkIDs[[36]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerVessel3,
						Type -> Object[Container, Vessel],
						Name -> "Test Container Vessel 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Vessel, "id:D8KAEvd4V45b"], Objects],
						DateDiscarded -> DateObject[{2021, 3, 1, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Discarded,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Replace[Contents] -> {{"A1", Link[sample3, Container, linkIDs[[37]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerVessel4,
						Type -> Object[Container, Vessel],
						Name -> "Test Container Vessel 4 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Vessel, "id:8qZ1VW0Mkx0p"], Objects],
						AwaitingDisposal -> True,
						AwaitingStorageUpdate -> True,
						DateDiscarded -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						DateLastUsed -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 27, 13, 29, 17.}, "Instant", "Gregorian", -7.],
						DateUnsealed -> DateObject[{2018, 4, 9, 13, 29, 31.}, "Instant", "Gregorian", -7.],
						Restricted -> True,
						Site -> Link[containerSite1],
						Status -> Discarded,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Replace[Contents] -> {{"A1", Link[sample4, Container, linkIDs[[38]]]}},
						DeveloperObject -> True
					|>,
					<|
						Object -> containerVessel5,
						Type -> Object[Container, Vessel],
						Name -> "Test Container Vessel 5 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Container, Vessel, "id:wqW9BP7k5WLJ"], Objects],
						AwaitingStorageUpdate -> True,
						DateDiscarded -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						DateLastUsed -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 27, 13, 29, 17.}, "Instant", "Gregorian", -7.],
						DateUnsealed -> DateObject[{2018, 4, 9, 13, 29, 31.}, "Instant", "Gregorian", -7.],
						Reusable -> True,
						Site -> Link[containerSite1],
						Status -> Discarded,
						StorageCondition -> Link[Model[StorageCondition, "id:xRO9n3BVOe3z"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> sample1,
						Type -> Object[Sample],
						Name -> "Test Sample 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:7X104vnRlpDw"], Objects],
						Container -> Link[containerVessel1, Contents, 2, linkIDs[[35]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 15, 38, 8.}, "Instant", "Gregorian", -7.],
						Position -> "A1",
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> sample2,
						Type -> Object[Sample],
						Name -> "Test Sample 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:7X104vnRlpDw"], Objects],
						Container -> Link[containerVessel2, Contents, 2, linkIDs[[36]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 15, 38, 8.}, "Instant", "Gregorian", -7.],
						Position -> "A1",
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> sample3,
						Type -> Object[Sample],
						Name -> "Test Sample 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:N80DNj1rVmJX"], Objects],
						Container -> Link[containerVessel3, Contents, 2, linkIDs[[37]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 15, 38, 8.}, "Instant", "Gregorian", -7.],
						Position -> "A1",
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> sample4,
						Type -> Object[Sample],
						Name -> "Test Sample 4 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:N80DNj1rVmJX"], Objects],
						Container -> Link[containerVessel4, Contents, 2, linkIDs[[38]]],
						DateDiscarded -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						DateLastUsed -> DateObject[{2021, 8, 16, 14, 31, 30.}, "Instant", "Gregorian", -7.],
						Position -> "A1",
						Site -> Link[containerSite1],
						Status -> Discarded,
						DeveloperObject -> True
					|>,
					<|
						Object -> sample5,
						Type -> Object[Sample],
						Name -> "Test Sample 5 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:vXl9j57Y6okm"], Objects],
						Container -> Link[containerPlate1, Contents, 2, linkIDs[[39]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						MassConcentration -> 100. Gram/Liter,
						Position -> "A1",
						Site -> Link[containerSite1],
						Volume -> 0.0001 Liter,
						Well -> "A1",
						DeveloperObject -> True
					|>,
					<|
						Object -> sample6,
						Type -> Object[Sample],
						Name -> "Test Sample 6 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:vXl9j57Y6okm"], Objects],
						Container -> Link[containerPlate1, Contents, 2, linkIDs[[40]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						MassConcentration -> 102. Gram/Liter,
						Position -> "B2",
						Site -> Link[containerSite1],
						Volume -> 0.000102 Liter,
						Well -> "B2",
						DeveloperObject -> True
					|>,
					<|
						Object -> sample7,
						Type -> Object[Sample],
						Name -> "Test Sample 7 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:xRO9n3BV6Wa6"], Objects],
						Container -> Link[containerPlate2, Contents, 2, linkIDs[[41]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						MassConcentration -> 13. Gram/Liter,
						Position -> "A1",
						Site -> Link[containerSite1],
						Volume -> 0.000103 Liter,
						Well -> "A1",
						DeveloperObject -> True
					|>,
					<|
						Object -> sample8,
						Type -> Object[Sample],
						Name -> "Test Sample 8 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Sample, "id:xRO9n3BV6Wa6"], Objects],
						Container -> Link[containerPlate2, Contents, 2, linkIDs[[42]]],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						MassConcentration -> 104. Gram/Liter,
						Position -> "B2",
						Site -> Link[containerSite1],
						Volume -> 0.000104 Liter,
						Well -> "B2",
						DeveloperObject -> True
					|>,
					<|
						Object -> itemTips1,
						Type -> Object[Item, Tips],
						Name -> "Test Item Tips 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Item, Tips, "id:n0k9mGzRaaN3"], Objects],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> itemTips2,
						Type -> Object[Item, Tips],
						Name -> "Test Item Tips 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Item, Tips, "id:n0k9mGzRaaN3"], Objects],
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> laboratorynotebook1,
						Type -> Object[LaboratoryNotebook],
						Name -> "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID,
						DateLastUsed -> DateObject[{2018, 5, 17, 16, 3, 48.}, "Instant", "Gregorian", -7.],
						Replace[Financers] -> {Link[teamFinancing1, NotebooksFinanced, linkIDs[[33]]]},
						Replace[StoragePrices] -> {198.80211114361018 USD/Month},
						Replace[StoredObjects]->{
							Link[sample1],
							Link[sample2],
							Link[sample3],
							Link[sample4],
							Link[containerVessel1],
							Link[containerVessel2],
							Link[containerVessel3],
							Link[containerVessel4],
							Link[partFilter1],
							Link[sample5],
							Link[sample6],
							Link[sample7],
							Link[sample8],
							Link[containerPlate1],
							Link[containerPlate2],
							Link[containerVessel5],
							Link[containerPlate3],
							Link[containerPlate4],
							Link[containerPlate5],
							Link[containerPlate6],
							Link[itemTips1],
							Link[itemTips2]
						},
						DeveloperObject -> True
					|>,
					<|
						Object -> laboratorynotebook2,
						Type -> Object[LaboratoryNotebook],
						Name -> "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID,
						DateLastUsed -> DateObject[{2021, 8, 16, 14, 35, 5.}, "Instant", "Gregorian", -7.],
						Replace[Financers] -> {Link[teamFinancing1, NotebooksFinanced, linkIDs[[34]]]},
						Replace[StoragePrices] -> {12.093653231999996 USD/Month, -1.6110532294999997 USD/Month, -0.1963949085 USD/Month},
						Replace[StoredObjects] -> {Link[partFilter2]},
						DeveloperObject -> True
					|>,
					<|
						Object -> partFilter1,
						Type -> Object[Part, Filter],
						Name -> "Test Part Filter 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Part, Filter, "id:WNa4ZjKqEJqz"], Objects],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> partFilter2,
						Type -> Object[Part, Filter],
						Name -> "Test Part Filter 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Part, Filter, "id:xRO9n3BbAGLY"], Objects],
						DateLastUsed -> DateObject[{2018, 5, 25, 19, 32, 16.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2021, 2, 3, 8, 51, 0.}, "Instant", "Gregorian", -7.],
						Site -> Link[containerSite1],
						Status -> Available,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument1,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentHPLC1],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[5]]],
						Status -> Fulfilled,
						Time -> 14.56 Hour,
						Replace[Requestor] -> {Link[protocolHPLC1, RequiredResources, 1, linkIDs[[1]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument2,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 2 for Old PriceWaste unit tests " <> $SessionUUID,
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[12]]],
						Status -> Canceled,
						Replace[InstrumentModels] -> {Link[modelInstrumentHPLC1]},
						Replace[Requestor] -> {Link[protocolHPLC1, RequiredResources, 1, linkIDs[[4]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument3,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentHPLC1],
						RootProtocol -> Link[protocolHPLC2, SubprotocolRequiredResources, linkIDs[[16]]],
						Status -> Fulfilled,
						Time -> 26.910555555555554 Hour,
						Replace[Requestor] -> {Link[protocolHPLC2, RequiredResources, 1, linkIDs[[15]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument4,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 4 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentHPLC2],
						RootProtocol -> Link[protocolHPLC3, SubprotocolRequiredResources, linkIDs[[21]]],
						Status -> Fulfilled,
						Time -> 4.3 Hour,
						Replace[Requestor] -> {Link[protocolHPLC3, RequiredResources, 1, linkIDs[[18]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument5,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 5 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentCentrifuge1],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[6]]],
						Status -> Fulfilled,
						Time -> 0.2461 Hour,
						Replace[Requestor] -> {Link[protocolCentrifuge1, RequiredResources, 1, linkIDs[[26]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument6,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 6 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentFumeHood1],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[8]]],
						Status -> Fulfilled,
						Time -> 0.6344 Hour,
						Replace[Requestor] -> {Link[protocolSampleManipulation1, RequiredResources, 1, linkIDs[[31]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument7,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 7 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentCentrifuge2],
						RootProtocol -> Link[protocolHPLC3, SubprotocolRequiredResources, linkIDs[[22]]],
						Status -> Fulfilled,
						Time -> 0.38888333333333336 Hour,
						Replace[Requestor] -> {Link[protocolCentrifuge2, RequiredResources, 1, linkIDs[[32]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument8,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 8 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentFumeHood1],
						RootProtocol -> Link[protocolSampleManipulation2, SubprotocolRequiredResources, linkIDs[[44]]],
						Status -> Fulfilled,
						Time -> 1.3666666666666667 Hour,
						Replace[Requestor] -> {Link[protocolSampleManipulation2, RequiredResources, 1, linkIDs[[43]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceOperator1,
						Type -> Object[Resource, Operator],
						Name -> "Test Resource Operator 1 for Old PriceWaste unit tests " <> $SessionUUID,
						DateFulfilled -> DateObject[{2018, 4, 19, 18, 30, 27.}, "Instant", "Gregorian", -7.],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[7]]],
						Status -> Fulfilled,
						Replace[Requestor] -> {Link[protocolHPLC1, RequiredResources, 1, linkIDs[[3]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceOperator2,
						Type -> Object[Resource, Operator],
						Name -> "Test Resource Operator 2 for Old PriceWaste unit tests " <> $SessionUUID,
						RootProtocol -> Link[protocolHPLC3, SubprotocolRequiredResources, linkIDs[[23]]],
						Replace[Requestor] -> {Link[protocolHPLC3, RequiredResources, 1, linkIDs[[20]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceOperator3,
						Type -> Object[Resource, Operator],
						Name -> "Test Resource Operator 3 for Old PriceWaste unit tests " <> $SessionUUID,
						DateFulfilled -> DateObject[{2018, 4, 19, 18, 30, 27.}, "Instant", "Gregorian", -7.],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[10]]],
						Status -> Fulfilled,
						Replace[Requestor] -> {Link[protocolCentrifuge1, RequiredResources, 1, linkIDs[[28]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceSample1,
						Type -> Object[Resource, Sample],
						Name -> "Test Resource Sample 1 for Old PriceWaste unit tests " <> $SessionUUID,
						DateFulfilled -> DateObject[{2018, 4, 19, 18, 30, 27.}, "Instant", "Gregorian", -7.],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[9]]],
						Sample -> Link[containerVessel1],
						Status -> Fulfilled,
						Replace[Requestor] -> {Link[protocolHPLC1, RequiredResources, 1, linkIDs[[2]]], Link[protocolCentrifuge1, RequiredResources, 1, linkIDs[[27]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceSample2,
						Type -> Object[Resource, Sample],
						Name -> "Test Resource Sample 2 for Old PriceWaste unit tests " <> $SessionUUID,
						DateFulfilled -> DateObject[{2018, 4, 19, 18, 30, 26.}, "Instant", "Gregorian", -7.],
						RootProtocol -> Link[protocolHPLC3, SubprotocolRequiredResources, linkIDs[[24]]],
						Sample -> Link[itemTips1],
						Status -> Fulfilled,
						Replace[Requestor] -> {Link[protocolHPLC3, RequiredResources, 1, linkIDs[[19]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceSample3,
						Type -> Object[Resource, Sample],
						Name -> "Test Resource Sample 3 for Old PriceWaste unit tests " <> $SessionUUID,
						DateFulfilled -> DateObject[{2018, 4, 19, 18, 30, 27.}, "Instant", "Gregorian", -7.],
						RootProtocol -> Link[protocolHPLC1, SubprotocolRequiredResources, linkIDs[[11]]],
						Sample -> Link[partFilter1],
						Status -> Fulfilled,
						Replace[Requestor] -> {Link[protocolCentrifuge1, RequiredResources, 1, linkIDs[[29]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> teamFinancing1,
						Type -> Object[Team, Financing],
						Name -> "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID,
						Replace[NotebooksFinanced] -> {Link[laboratorynotebook1, Financers, linkIDs[[33]]], Link[laboratorynotebook2, Financers, linkIDs[[34]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> supportTicketUserCommunication1,
						Type -> Object[SupportTicket, UserCommunication],
						Name -> "Test SupportTicket UserCommunication 1 for Old PriceWaste unit tests " <> $SessionUUID,
						AffectedProtocol -> Link[protocolHPLC1, UserCommunications, linkIDs[[14]]],
						DeveloperObject -> True
					|>,
					<|
						Object -> supportTicketUserCommunication2,
						Type -> Object[SupportTicket, UserCommunication],
						Name -> "Test SupportTicket UserCommunication 2 for Old PriceWaste unit tests " <> $SessionUUID,
						AffectedProtocol -> Link[protocolHPLC2, UserCommunications, linkIDs[[17]]],
						Refund -> True,
						DeveloperObject -> True
					|>,
					<|Object -> modelInstrumentHPLC2, Type -> Model[Instrument, HPLC], Name -> "Test Model Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID, DeveloperObject -> True|>,
					<|
						Object -> protocolHPLC4,
						Type -> Object[Protocol, HPLC],
						Name -> "Test Protocol HPLC 4 for Old PriceWaste unit tests " <> $SessionUUID,
						Site -> Link[containerSite1],
						Status -> Completed,
						Replace[RequiredResources] -> {{Link[resourceInstrument9, Requestor, linkIDs[[45]]], Null, Null, Null}, {Link[resourceInstrument10, Requestor, linkIDs[[46]]], Null, Null, Null}},
						Replace[SubprotocolRequiredResources] -> {Link[resourceInstrument9, RootProtocol, linkIDs[[47]]]},
						Replace[WasteGenerated]->{
							<|Waste -> Link[Model[Sample, "id:KBL5DvwZrPKj"]], Weight -> 100. Gram|>,
							<|Waste -> Link[Model[Sample, "id:jLq9jXvlxOza"]], Weight -> 2000. Gram|>,
							<|Waste -> Link[Model[Sample, "id:E8zoYvNkelOa"]], Weight -> 456. Gram|>
						},
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentCentrifuge3,
						Type -> Object[Instrument, Centrifuge],
						Name -> "Test Instrument Centrifuge 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[Model[Instrument, Centrifuge, "id:qdkmxzqeR16a"], Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> instrumentHPLC3,
						Type -> Object[Instrument, HPLC],
						Name -> "Test Instrument HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Model -> Link[modelInstrumentHPLC2, Objects],
						Site -> Link[containerSite1],
						DeveloperObject -> True
					|>,
					<|
						Object -> laboratorynotebook3,
						Type -> Object[LaboratoryNotebook],
						Name -> "Test LaboratoryNotebook 3 for Old PriceWaste unit tests " <> $SessionUUID,
						Replace[Financers] -> {Link[teamFinancing2, NotebooksFinanced, linkIDs[[48]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument9,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 9 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentHPLC3],
						RootProtocol -> Link[protocolHPLC4, SubprotocolRequiredResources, linkIDs[[47]]],
						Status -> Fulfilled,
						Time -> 8.970185185185185 Hour,
						Replace[Requestor] -> {Link[protocolHPLC4, RequiredResources, 1, linkIDs[[45]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> resourceInstrument10,
						Type -> Object[Resource, Instrument],
						Name -> "Test Resource Instrument 10 for Old PriceWaste unit tests " <> $SessionUUID,
						Instrument -> Link[instrumentCentrifuge3],
						Status -> Fulfilled,
						Time -> 0.5382111111111111 Hour,
						Replace[Requestor] -> {Link[protocolHPLC4, RequiredResources, 1, linkIDs[[46]]]},
						DeveloperObject -> True
					|>,
					<|
						Object -> teamFinancing2,
						Type -> Object[Team, Financing],
						Name -> "Test Team Financing 2 for Old PriceWaste unit tests " <> $SessionUUID,
						Replace[NotebooksFinanced] -> {Link[laboratorynotebook3, Financers, linkIDs[[48]]]},
						DeveloperObject -> True
					|>
				}
			];

			(* Combine packets for upload *)
			allUploadPackets = Flatten[{test1Packets}];

			Upload[allUploadPackets]
		]
	},
	SymbolTearDown :> {Module[{objs, existingObjs},
		objs=Quiet[Cases[
			Flatten[{
				Object[Team, Financing, "A test financing team object for PriceWaste testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceWaste testing"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceWaste testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceWaste tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 2 for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 3 (refunded) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 4 (incomplete) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 5 (with missing pricing rate) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, Centrifuge, "Test centrifuge protocol 1 (subprotocol) for PriceWaste tests"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM protocol for PriceWaste tests (no waste generated)"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 1 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 2 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 3 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 4 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 5 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 6 for PriceWaste testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 7 for PriceWaste testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceWaste"<>$SessionUUID]
			}],
			ObjectP[]
		]];
		existingObjs=PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	];
	Module[
		{allNamedObjects, existingObjects},

		(* All named objects created for these unit tests *)
		allNamedObjects = Cases[
			Flatten[{
				{
					Object[Container, Site, "Test Container Site 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Model[Instrument, HPLC, "Test Model Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, Centrifuge, "Test Protocol Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, Centrifuge, "Test Protocol Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, HPLC, "Test Protocol HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, HPLC, "Test Protocol HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, HPLC, "Test Protocol HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, SampleManipulation, "Test Protocol SampleManipulation 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test Instrument Centrifuge 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test Instrument Centrifuge 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, FumeHood, "Test Instrument FumeHood 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test Instrument HPLC 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 4 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 5 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test Container Plate 6 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Vessel, "Test Container Vessel 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Vessel, "Test Container Vessel 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Vessel, "Test Container Vessel 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Vessel, "Test Container Vessel 4 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Container, Vessel, "Test Container Vessel 5 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 4 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 5 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 6 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 7 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Sample, "Test Sample 8 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Item, Tips, "Test Item Tips 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Item, Tips, "Test Item Tips 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[LaboratoryNotebook, "Test LaboratoryNotebook 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[LaboratoryNotebook, "Test LaboratoryNotebook 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Part, Filter, "Test Part Filter 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Part, Filter, "Test Part Filter 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 4 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 5 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 6 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 7 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 8 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Operator, "Test Resource Operator 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Operator, "Test Resource Operator 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Operator, "Test Resource Operator 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Sample, "Test Resource Sample 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Sample, "Test Resource Sample 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Sample, "Test Resource Sample 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Team, Financing, "Test Team Financing 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[SupportTicket, UserCommunication, "Test SupportTicket UserCommunication 1 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[SupportTicket, UserCommunication, "Test SupportTicket UserCommunication 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Model[Instrument, HPLC, "Test Model Instrument HPLC 2 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Protocol, HPLC, "Test Protocol HPLC 4 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test Instrument Centrifuge 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test Instrument HPLC 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[LaboratoryNotebook, "Test LaboratoryNotebook 3 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 9 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource Instrument 10 for Old PriceWaste unit tests " <> $SessionUUID],
					Object[Team, Financing, "Test Team Financing 2 for Old PriceWaste unit tests " <> $SessionUUID]
				}
			}],
			ObjectReferenceP[]
		];

		existingObjects = PickList[allNamedObjects, DatabaseMemberQ[allNamedObjects]];
		EraseObject[existingObjects, Force -> True, Verbose -> False];

	]}
];




(* ::Subsection::Closed:: *)
(*PriceInstrumentTime*)

DefineTests[PriceInstrumentTime,
	{
		Example[{Basic, "Displays the pricing information for each instrument used in a given protocol as a table:"},
			PriceInstrumentTime[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceInstrumentTime[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceInstrumentTime[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceInstrumentTime[Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Additional, "If a protocol has been refunded, include it, but zero out the pricing for it:"},
			outputAssociation=PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			Transpose@Lookup[outputAssociation, {Source, PricePerHour}],
			{
				{
					ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID]],
					ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
					ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
					ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
				},
				{
					Quantity[0, "USDollars" / "Hours"],
					Quantity[25., "USDollars" / "Hours"],
					Quantity[1., "USDollars" / "Hours"],
					Quantity[1., "USDollars" / "Hours"]
				}
			},
			Variables :> {outputAssociation}
		],
		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceInstrumentTime is called on a subprotocol:"},
			PriceInstrumentTime[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceInstrumentTime::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceInstrumentTime is called on a protocol that is not Completed:"},
			PriceInstrumentTime[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceInstrumentTime::ProtocolNotCompleted}
		],
		Example[{Messages, "MissingPricingLevel", "Throw a soft message if the PricingRate is not populated for some instruments:"},
			PriceInstrumentTime[{
				Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
			}],
			_Pane,
			Messages :> {Pricing::NoPricingInfo,PriceInstrumentTime::MissingPricingLevel},
			SetUp :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID], Objects]
				]
			},
			TearDown :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Null
				]
			}
		],
		Test["If PricingRate is not populated for some instruments, still return the correct total price if OutputFormat -> TotalPrice:",
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD],
			Messages :> {Pricing::NoPricingInfo,PriceInstrumentTime::MissingPricingLevel},
			SetUp :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID], Objects]
				]
			},
			TearDown :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Null
				]
			}
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceInstrumentTime[
				Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			List[
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
			],
			Variables :> {outputAssociation}
		],
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceInstrumentTime[
				Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],
		Test["If no instrument time has accumulated and OutputFormat -> Table, return an empty list:",
			PriceInstrumentTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no instrument time has accumulated and OutputFormat -> Association, return an empty list:",
			PriceInstrumentTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no instrument time has accumulated and OutputFormat -> TotalPrice, return $0.00:",
			PriceInstrumentTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Using the hidden Time option, specify whether to use the estimated or actual amount of time an instrument was used:",
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice,
				Time -> Time
			],
			UnitsP[USD]
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching InstrumentPriceTableP:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{InstrumentPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of every instrument:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				Consolidation -> Protocol
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Instrument groups all items by Instrument object and sums their prices in the output table:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				Consolidation -> Instrument
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				Consolidation -> Instrument,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching InstrumentPriceTableP:"},
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				Consolidation -> Instrument,
				OutputFormat -> Association
			],
			{InstrumentPriceTableP..}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceInstrumentTime[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceInstrumentTime[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceInstrumentTime[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			PriceInstrumentTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			RangeP[Quantity[104.1, "USDollars"], Quantity[104.3, "USDollars"]]
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			PriceInstrumentTime[
				Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			],
			RangeP[Quantity[100.33`, "USDollars"], Quantity[100.35`, "USDollars"]]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceInstrumentTime[Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceInstrumentTime[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID], Span[Now - 2 * Day, Now - 1 Day], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceInstrumentTime[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceInstrumentTime[Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID]]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID],
				Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID],
				Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
				Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID],
				Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 1 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 2 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 3 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 4 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 5 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 6 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 7 for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceInstrumentTime testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceInstrumentTime"<>$SessionUUID]}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceInstrumentTime testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceInstrumentTime"<>$SessionUUID]}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceInstrumentTime testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceInstrumentTime"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID, fplcModelID},

			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];
			fplcModelID=CreateID[Model[Instrument, FPLC]];

			firstSet=List[
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
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
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Null,
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				<|
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DeveloperObject -> False,
					Name -> "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[Model[Instrument, FPLC, "AKTA avant 25"], Objects],
					Name -> "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, Sonicator],
					Model -> Link[Model[Instrument, Sonicator, "Branson MH 5800"], Objects],
					Name -> "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Object -> fplcModelID,
					Type -> Model[Instrument, FPLC],
					Name -> "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID,
					PricingRate -> 10 USD / Hour,
					DeveloperObject->True
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[fplcModelID, Objects],
					Name -> "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID,
					DeveloperObject -> True
				|>
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceInstrumentTime testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceInstrumentTime"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 1 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 2 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 3 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 4 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 5 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 6 for PriceInstrumentTime Tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 7 for PriceInstrumentTime Tests"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceInstrumentTime testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceInstrumentTime testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceInstrumentTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceInstrumentTime test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceInstrumentTime test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceInstrumentTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceInstrumentTime test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceInstrumentTime test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceInstrument test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceInstrumentTime test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceInstrumentTime test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceInstrumentTime unit tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for PriceInstrumentTime Tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceInstrumentTime testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceInstrumentTime"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];



(* ::Subsection::Closed:: *)
(*PriceOperatorTime*)

DefineTests[PriceOperatorTime,
	{
		(* ----------- *)
		(* -- Basic -- *)
		(* ----------- *)


		Example[{Basic, "Displays the pricing information for each operator used in a given protocol as a table:"},
			PriceOperatorTime[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceOperatorTime[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceOperatorTime[Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceOperatorTime[Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceOperatorTime[
				Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			List[
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			],
			Variables :> {outputAssociation}
		],

		(* ---------------- *)
		(* -- Additional -- *)
		(* ---------------- *)


		Example[{Additional, "If a protocol has been refunded, include it in the pricing to reflect the refunded price:"},
			outputAssociation=PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			List[
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			],
			Variables :> {outputAssociation}
		],

		(* -- Time Span -- *)
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceOperatorTime[
				Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -------------- *)
		(* -- Messages -- *)
		(* -------------- *)

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceOperatorTime is called on a subprotocol:"},
			PriceOperatorTime[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceOperatorTime::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceOperatorTime is called on a protocol that is not Completed:"},
			PriceOperatorTime[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceOperatorTime::ProtocolNotCompleted}
		],


		(* -- Tests -- *)

		Test["If no operator time has accumulated and OutputFormat -> Table, return an empty list:",
			PriceOperatorTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no operator time has accumulated and OutputFormat -> Association, return an empty list:",
			PriceOperatorTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no operator time has accumulated and OutputFormat -> TotalPrice, return $0.00:",
			PriceOperatorTime[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Using the hidden Time option, specify whether to use the estimated or actual amount of time an instrument was used:",
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice,
				Time -> Time
			],
			UnitsP[USD]
		],

		(* -- Options -- *)

		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching OperatorPriceTableP:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{OperatorPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of every operator:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				Consolidation -> Protocol
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Operator groups all items by Operator object and sums their prices in the output table:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				Consolidation -> Operator
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				Consolidation -> Operator,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching OperatorPriceTableP:"},
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				Consolidation -> Operator,
				OutputFormat -> Association
			],
			{OperatorPriceTableP..}
		],

		(* -- Tests -- *)

		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceOperatorTime[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceOperatorTime[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceOperatorTime[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			Quantity[80.00, "USDollars"]
		],
		Test["If a protocol is priority, the operator time is priced accordingly:",
			PriceOperatorTime[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			Quantity[160.00, "USDollars"],
			SetUp :> {
				Upload[
					<|
						Object -> Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
						Priority -> True
					|>
				]
			},
			TearDown :> {
				Upload[
					<|
						Object -> Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
						Priority -> False
					|>
				]
			}
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			PriceOperatorTime[
				Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			],
			Quantity[80.00, "USDollars"]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceOperatorTime[Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceOperatorTime[Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID], Span[Now - 1 * Day, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceOperatorTime[Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceOperatorTime[Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID]]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID],
				Object[Instrument, FPLC, "Test FPLC instrument for PriceOperatorTime test"<>$SessionUUID],
				Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
				Object[Instrument, Sonicator, "Test Sonicator instrument for PriceOperatorTime test"<>$SessionUUID],
				Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
				Object[User, Emerald, Operator, "Test Operator 2 for PriceOperatorTime test"<>$SessionUUID],
				Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID],
				Model[User, Emerald, Operator, "Test Operator Model 2 for PriceOperatorTime test"<>$SessionUUID],
				Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 1 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 2 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 3 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 4 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 5 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 7 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 6 for PriceOperatorTime tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceOperatorTime testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceOperatorTime"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceOperatorTime testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceOperatorTime"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},

	(* ------------ *)
	(* -- Set Up -- *)
	(* ------------ *)


	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceOperatorTime test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceOperatorTime test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for PriceOperatorTime test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for PriceOperatorTime test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceOperatorTime testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceOperatorTime"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID, fplcModelID, operatorModelID, operatorModelID2},

			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];
			fplcModelID=CreateID[Model[Instrument, FPLC]];
			operatorModelID=CreateID[Model[User, Emerald, Operator]];
			operatorModelID2=CreateID[Model[User, Emerald, Operator]];

			firstSet=List[

				(* financing team *)
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1 * Day,
					Replace[CurrentPriceSchemes] -> {Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceOperatorTime testing"<>$SessionUUID
				|>,

				(* pricing model *)
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link@$Site,
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 10 USD / Hour},
						{2, 20 USD / Hour},
						{3, 30 USD / Hour},
						{4, 40 USD / Hour}
					},
					Replace[OperatorPriorityTimePrice] -> {
						{1, 20 USD / Hour},
						{2, 40 USD / Hour},
						{3, 60 USD / Hour},
						{4, 80 USD / Hour}
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
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,

				(* notebook *)
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceOperatorTime tests"<>$SessionUUID
				|>,

				(* protocols *)

				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID,
					DateCompleted -> Now - 2 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DeveloperObject -> False,
					Name -> "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID,
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				],

				(* operators *)

				Association[
					Object -> operatorModelID,
					QualificationLevel -> 2,
					Name -> "Test Operator Model for PriceOperatorTime test"<>$SessionUUID
				],
				Association[
					Object -> operatorModelID2,
					QualificationLevel -> 3,
					Name -> "Test Operator Model 2 for PriceOperatorTime test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID, Objects],
					Name -> "Test Operator for PriceOperatorTime test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID2, Objects],
					Name -> "Test Operator 2 for PriceOperatorTime test"<>$SessionUUID
				],

				(* instruments *)
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[Model[Instrument, FPLC, "AKTA avant 25"], Objects],
					Name -> "Test FPLC instrument for PriceOperatorTime test"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Type -> Object[Instrument, Sonicator],
					Model -> Link[Model[Instrument, Sonicator, "Branson MH 5800"], Objects],
					Name -> "Test Sonicator instrument for PriceOperatorTime test"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|
					Object -> fplcModelID,
					Type -> Model[Instrument, FPLC],
					Name -> "Fake Model FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID,
					PricingRate -> 10 USD / Hour,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[fplcModelID, Objects],
					Name -> "Fake Object FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceOperatorTime testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceOperatorTime"<>$SessionUUID
				|>,

				(* -- Resources - Instrument, Operator -- *)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 6 for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 3 for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 4 for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 5 for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 7 for PriceOperatorTime tests"<>$SessionUUID
				|>,

				(* operator resources *)
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 1 for PriceOperatorTime tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator 2 for PriceOperatorTime test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model 2 for PriceOperatorTime test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 2 for PriceOperatorTime tests"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceOperatorTime testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceOperatorTime testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceOperatorTime tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceOperatorTime test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceOperatorTime test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceOperatorTime test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceOperatorTime test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceOperatorTime test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceOperatorTime test (no operator used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceOperatorTime test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceOperatorTime test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceOperatorTime unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for PriceOperatorTime test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for PriceOperatorTime test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for PriceOperatorTime test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for PriceOperatorTime test"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for PriceOperatorTime tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceOperatorTime testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceOperatorTime"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];





(* ::Subsection::Closed:: *)
(*PriceMaterials*)

DefineTests[
	PriceMaterials,
	{
		Example[{Basic, "Displays the pricing information for each material used in a given protocol as a table:"},
			PriceMaterials[Object[Protocol, HPLC,"Price material test HPLC protocol 1 for notebook 1"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for each material ordered in a given transaction order as a table:"},
			PriceMaterials[Object[Transaction, Order, "id:dORYzZJVxoGD"]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols and transactions as one large table:"},
			PriceMaterials[{Object[Protocol, SampleManipulation, "id:mnk9jORxbdpY"], Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 1"<>$SessionUUID], Object[Transaction, Order, "id:D8KAEvGx84LL"]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceMaterials[Object[LaboratoryNotebook, "id:J8AY5jD1bR8a"]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, LCMS, "id:7X104vnRrNXA"],
						DeveloperObject -> False,
						DateCompleted -> Now - 2 * Day
					|>,
					<|
						Object -> Object[Protocol, LCMS, "id:xRO9n3BVKoR5"],
						DeveloperObject -> False,
						DateCompleted -> Now - 12 * Day
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[Protocol, LCMS, "id:7X104vnRrNXA"],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, LCMS, "id:xRO9n3BVKoR5"],
						DeveloperObject -> True
					|>
				}]
			}
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceMaterials[Object[Team, Financing,"Team 2 for price material test"<>$SessionUUID]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 2 for price material test"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 2"<>$SessionUUID],
						DeveloperObject -> False,
						DateCompleted -> Now - 1 * Week
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 2"<>$SessionUUID],
						DateCompleted -> Now - 1 * Week,
						DeveloperObject -> False
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook,  "Lab notebook 2 for price material test"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 2"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 2"<>$SessionUUID],
						DeveloperObject -> True
					|>
				}]
			}
		],
		Example[{Additional, "Specifying a date span excludes protocols that fall outside that range:"},
			PriceMaterials[Object[LaboratoryNotebook, "id:eGakldJ4pxke"], Span[Now, Now - 1 * Week]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, SampleManipulation, "id:dORYzZJVevYR"],
						DeveloperObject -> False,
						DateCompleted -> Now - 2 * Day
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[Protocol, SampleManipulation, "id:dORYzZJVevYR"],
						DeveloperObject -> True
					|>
				}];
				ClearMemoization[];
			},
			Stubs:>
					{
						Search[{Object[Protocol],Object[Qualification],Object[Maintenance]},_,Notebooks->{Object[LaboratoryNotebook,"id:eGakldJ4pxke"]},PublicObjects->False]:={Object[Protocol, SampleManipulation, "id:dORYzZJVevYR"]},
						Search[{Object[Transaction,Order]},_,Notebooks->{Object[LaboratoryNotebook,"id:eGakldJ4pxke"]},PublicObjects->False]:={}
					}
		],
		Example[{Additional, "Date span can go in either order:"},
			PriceMaterials[Object[LaboratoryNotebook, "id:M8n3rx0l9XqG"], Span[Now - 2*Day, Now]],
			_Pane,
			SetUp :> {
				Upload[{
					<|
						Object -> Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"],
						DeveloperObject -> False,
						DateCompleted -> Now - 1 * Day
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"],
						DeveloperObject -> True
					|>
				}]
			}
		],
		Example[{Additional, "PriceMaterials does not exclude refunded protocols:"},
			PriceMaterials[{
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID]
			}],
			_Pane
		],
		Test["For stock solutions, pull the price out of the StockSolution Price field:",
			assoc=PriceMaterials[Object[Protocol, PAGE, "id:9RdZXv1WbO56"], OutputFormat -> Association];
			Lookup[SelectFirst[assoc, MatchQ[Lookup[#, Material], Model[Sample, StockSolution, "id:KBL5DvwZVbVn"]]&], PricePerUnit],
			Download[Model[Sample, StockSolution, "id:KBL5DvwZVbVn"], Price],
			EquivalenceFunction -> Equal,
			Variables :> {assoc}
		],

		Example[{Additional, "If the protocol includes items that stem from a kit, charge the entire kit:"},
			Lookup[PriceMaterials[Object[Protocol, AbsorbanceSpectroscopy, "id:9RdZXv19qlYJ"], OutputFormat -> Association], {Material, MaterialName, Amount, PricePerUnit, Price}],
			{
				{ObjectP[Object[Product]], "Test Organic Compound Kit Product for SyncInventory unit tests", 1, 1000.` * USD, 1000.` * USD},
				{ObjectP[Object[Product]], "Test Organic Compound Kit Product for SyncInventory unit tests", 1, 72.5` * USD, 72.5` * USD},
				{ObjectP[Object[Product]], "Fake kit product with plates", 1, 1234.` * USD, 1234.` * USD},
				{ObjectP[Object[Product]], "Fake kit product with plates", 1, 89.46499999999999` * USD, 89.46499999999999` * USD},
				{ObjectP[Model[Sample]], "Milli-Q water", 500.` * Microliter, 0.661` * USD / Liter, 0.0003305` * USD},
				{ObjectP[Model[Sample]], "Milli-Q water", 500.` * Microliter, 0.0479225` * USD / Liter, 0.00002396125` * USD}
			},
			Messages :> {PriceMaterials::MissingProductInformation}
		],

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceMaterials is called on a subprotocol, since the pricing of this protocol is included in the pricing of its parent protocol:"},
			PriceMaterials[Object[Protocol, SampleManipulation, "id:lYq9jRxA4ALO"]],
			$Failed,
			Messages :> {PriceMaterials::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceMaterials is called on a protocol that is not Completed:"},
			PriceMaterials[Object[Protocol, Microscope, "id:GmzlKjPkbBEX"]],
			$Failed,
			Messages :> {PriceMaterials::ProtocolNotCompleted}
		],
		Example[{Messages, "MissingProductInformation", "Throws a soft message if the field Product is not populated for one or more samples used by the input protocols:"},
			PriceMaterials[Object[Protocol, SampleManipulation, "id:kEJ9mqR3bplX"]],
			_Pane,
			Messages :> {PriceMaterials::MissingProductInformation}
		],
		Example[{Messages, "SiteNotFound", "Throws an error if PriceMaterials is called on a protocol that is missing Site information:"},
			PriceMaterials[{Object[Protocol, HPLC, "HPLC protocol 1 missing site"<>$SessionUUID], Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"]}],
			$Failed,
			Messages :> {PriceMaterials::SiteNotFound}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> Table, return an empty list:",
			PriceMaterials[Object[Protocol, HPLC, "id:dORYzZJVkYEE"], OutputFormat -> Table],
			{}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> Association, return an empty list:",
			PriceMaterials[Object[Protocol, HPLC, "id:dORYzZJVkYEE"], OutputFormat -> Association],
			{}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> TotalPrice, return $0.00:",
			PriceMaterials[Object[Protocol, HPLC, "id:dORYzZJVkYEE"], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching MaterialsPriceTableP:"},
			PriceMaterials[{Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 3"<>$SessionUUID], Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 3"<>$SessionUUID], Object[Protocol, HPLC, "id:dORYzZJVkYEE"]}, OutputFormat -> Association],
			{MaterialsPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of all materials:"},
			PriceMaterials[{Object[Protocol, LCMS, "id:xRO9n3BVKoR5"], Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 3"<>$SessionUUID], Object[Protocol, SampleManipulation, "id:mnk9jORxbdpY"]}, OutputFormat -> TotalPrice],
			Quantity[32.1852510625, "USDollars"],
			EquivalenceFunction -> Equal
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceMaterials[{Object[Protocol, SampleManipulation, "id:mnk9jORxbdpY"]}, Consolidation -> Notebook],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Source groups all items by Source and sums their prices in the output table:"},
			PriceMaterials[{Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 3"<>$SessionUUID], Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"]}, Consolidation -> Source],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Material groups all items by Material and sums their prices in the output table:"},
			PriceMaterials[{Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 3"<>$SessionUUID], Object[Protocol, SampleManipulation, "id:GmzlKjPkbXWk"]}, Consolidation -> Material],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceMaterials[{Object[Protocol, LCMS, "id:7X104vnRrNXA"], Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"], Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 3"<>$SessionUUID]}, Consolidation -> Material, OutputFormat -> TotalPrice],
			Quantity[64.977842625, "USDollars"],
			EquivalenceFunction -> Equal
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching MaterialsPriceTableP:"},
			PriceMaterials[{Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"], Object[Protocol, SampleManipulation, "id:GmzlKjPkbXWk"], Object[Protocol, SampleManipulation, "id:GmzlKjPkbXWk"]}, Consolidation -> Material, OutputFormat -> Association],
			{MaterialsPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching MaterialsPriceTableP:"},
			PriceMaterials[{Object[Protocol, MassSpectrometry, "id:54n6evLENj6N"]}, Consolidation -> Material, OutputFormat -> Association],
			{MaterialsPriceTableP..}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceMaterials[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceMaterials[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceMaterials[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Even if a protocol has been refunded, the materials are nontheless priced:",
			DeleteDuplicates[Lookup[
				PriceMaterials[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID]
					},
					OutputFormat -> Association
				],
				Source
			]],
			{
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID]],
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID]]
			}
		],
		Test["If a transaction links to a supplier order with a notebook, do not include it in the pricing:",
			DeleteDuplicates[Lookup[
				PriceMaterials[{Object[Transaction, Order, "Fake Transaction Order 23 with dependent order for Pricing Unit testing"], Object[Transaction, Order, "Fake Transaction Order 22 with supplier order for Pricing Unit testing"]}, OutputFormat -> Association],
				Source
			]],
			{Object[Transaction, Order, "id:WNa4ZjKazK7E"]}
		],

		Test["Specifying the date range excludes protocols that fall outside that range:",
			DeleteDuplicates[Lookup[
				PriceMaterials[Object[Team, Financing,"Team 4 for price material test"<>$SessionUUID], Span[DateObject["4 January 2018"], DateObject["3 March 2018"]], OutputFormat -> Association],
				Source
			]],
			{Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 4"<>$SessionUUID][Object]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 4 for price material test"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 4"<>$SessionUUID],
						DeveloperObject -> False,
						DateCompleted -> DateObject["5 January 2018"]
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 4"<>$SessionUUID],
						DateCompleted -> DateObject["2 January 2018"],
						DeveloperObject -> False
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 4 for price material test"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 4"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 4"<>$SessionUUID],
						DeveloperObject -> True
					|>
				}]
			},
			TimeConstraint -> 300
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[PriceMaterials[Object[Team, Financing, "Team 5 for price material test"<>$SessionUUID], OutputFormat -> Association],Source, {}]],
			{Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 5"<>$SessionUUID][Object]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook,"Lab notebook 5 for price material test"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 5"<>$SessionUUID],
						DeveloperObject -> False,
						DateCompleted -> Now - 1 * Week
					|>,
					<|
						Object -> Object[Protocol, HPLC,"Price material test HPLC protocol 2 for notebook 5"<>$SessionUUID],
						DateCompleted -> DateObject["1 January 2018"],
						DeveloperObject -> False
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 5 for price material test"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC,"Price material test HPLC protocol 1 for notebook 5"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 5"<>$SessionUUID],
						DeveloperObject -> True
					|>
				}]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceMaterials[Object[LaboratoryNotebook, "Lab notebook 6 for price material test"<>$SessionUUID], Span[DateObject["1 January 2016"], DateObject["1 January 2017"]], OutputFormat -> Association],
				Source,
				{}
			]],
			{},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 6 for price material test"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC,"Price material test HPLC protocol 1 for notebook 6"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 6"<>$SessionUUID],
						DeveloperObject -> False
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook,  "Lab notebook 6 for price material test"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 6"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 6"<>$SessionUUID],
						DeveloperObject -> True
					|>
				}]
			},
			TimeConstraint -> 600
		],
		Test["If a date range is specified for a Notebook then get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceMaterials[
					Object[LaboratoryNotebook, "Lab notebook 7 for price material test"<>$SessionUUID],
					Span[DateObject[{2018,1,1,0,0,0.},"Instant","Gregorian",-7.], DateObject[{2018,1,25,0,0,0.},"Instant","Gregorian",-7.]],
					OutputFormat -> Association],
				Source,
				{}
			]],
			{Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 7"<>$SessionUUID][Object], Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 7"<>$SessionUUID][Object]},
			SetUp :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook, "Lab notebook 7 for price material test"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 7"<>$SessionUUID],
						DeveloperObject -> False
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 7"<>$SessionUUID],
						DeveloperObject -> False
					|>
				}]
			},
			TearDown :> {
				Upload[{
					<|
						Object -> Object[LaboratoryNotebook,  "Lab notebook 7 for price material test"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 1 for notebook 7"<>$SessionUUID],
						DeveloperObject -> True
					|>,
					<|
						Object -> Object[Protocol, HPLC, "Price material test HPLC protocol 2 for notebook 7"<>$SessionUUID],
						DeveloperObject -> True
					|>
				}]
			},
			TimeConstraint -> 600
		],
		Test["If the protocol invoked a maintenance subprocedure, any requested materials from that maintenance is excluded from PriceMaterials:",
			PriceMaterials[ Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], OutputFormat -> Association],
			{
				KeyValuePattern[{
					Notebook->Null,
					Source->ObjectP[Object[Protocol,FPLC,"Test FPLC Protocol in PriceMaterials test"<>$SessionUUID]],
					Material->Model[Sample,"id:qdkmxzqor36M"],
					MaterialName->"Sodium Acetate, LCMS grade",
					PricingCategory->"Product List Price",
					Amount->Quantity[4.2,"Grams"],
					PricePerUnit->Quantity[10.084000000000001,"USDollars" / "Grams"],
					Price->Quantity[42.35280000000001,"USDollars"],
					DateCompleted->Null,
					Site->$Site
				}],
				KeyValuePattern[{
					Notebook -> Null,
					Source -> ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID]],
					Material -> Model[Sample, "id:qdkmxzqor36M"],
					MaterialName -> "Sodium Acetate, LCMS grade",
					PricingCategory -> "Product Tax",
					Amount -> Quantity[4.2, "Grams"],
					PricePerUnit -> Quantity[0.6302500000000001,"USDollars"/"Grams"],
					Price -> Quantity[2.6470500000000006, "USDollars"],
					DateCompleted -> Null,
					Site -> $Site
			}]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Sample, "Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Sample, "Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Sample, "Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID],
				Object[Product, "Test product for PriceMaterials unit tests seals"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceMaterials"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID],
				Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 2 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 3 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 4 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 1"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 2"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 3"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 4"<>$SessionUUID],
				Object[Resource, Sample, "Fake seal kit resource for Price Materials FPLC unit test"<>$SessionUUID],
				Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceMaterials"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
				Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 1"<>$SessionUUID],
				Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	Stubs :> {$AllowPublicObjects = True},
	SymbolSetUp :> {
		Module[{objs, numObj, addObjs, allObjs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for PriceMaterials unit tests seals"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceMaterials"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID],
					Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 4"<>$SessionUUID],
					Object[Resource, Sample, "Fake seal kit resource for Price Materials FPLC unit test"<>$SessionUUID],
					Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID],
					Object[Sample,"Test sample for PriceMaterials"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			numObj = 7;
			addObjs = Flatten[{
				Object[Team,Financing,"Team "<>ToString[#]<>" for price material test"<>$SessionUUID],
				Object[LaboratoryNotebook,"Lab notebook "<>ToString[#]<>" for price material test"<>$SessionUUID],
				Object[Protocol,HPLC,"HPLC protocol "<>ToString[#]<>" missing site"<>$SessionUUID],
				Object[Protocol,HPLC,"Price material test HPLC protocol 1 for notebook "<>ToString[#]<>$SessionUUID],
				Object[Protocol,HPLC,"Price material test HPLC protocol 2 for notebook "<>ToString[#]<>$SessionUUID]}&/@Range[numObj]
			];
			allObjs = Join[objs,addObjs];
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{numObj, teamPackets, notebookPackets, firstSetPackets, teamObjects,notebookObjects,protocolObjects, protocolObjects1,protocolObjects2,firstUpload, sampleUpload,uploadPackets,sample1,newObjects},

			numObj = 7;

			(* fake team packets *)
			teamPackets = <|
					Type -> Object[Team, Financing],
					Name -> "Team "<> ToString[#]<>" for price material test"<>$SessionUUID,
					Replace[NotebooksFinanced] -> {},
					DeveloperObject -> True
				|>&/@Range[numObj];

			(* fake notebook packets *)
			notebookPackets = <|
					Type -> Object[LaboratoryNotebook],
					Name -> "Lab notebook "<>ToString[#]<>" for price material test"<>$SessionUUID,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "id:6V0npvmajN3G"]]},
					Replace[Financers] -> {},
					DeveloperObject -> True
				|>&/@Range[numObj];

			(* Create team, notebook, protocol objects *)
			teamObjects = Upload[teamPackets];
			notebookObjects = Upload[notebookPackets];
			protocolObjects ={};
			protocolObjects1 ={};
			protocolObjects2 ={};

			(* create resources and link them to the freshly created protocols *)
			newObjects = Upload@Flatten@(Module[
				{
					sampleResourceID1,sampleResourceID2,sampleResourceID3,sampleResourceID4,sampleResourceID5,sampleResourceID6,sampleResourceID7,sampleResourceID8,
					sampleObjectID1,sampleObjectID2,sampleObjectID3,sampleObjectID4,
					hplcObjectID1,hplcObjectID2,hplcObjectID3
				},

				With[{
					newIDs=CreateID[Flatten@{
						ConstantArray[Object[Resource,Sample],8],
						{Object[Sample],Object[Sample],Object[Container,Plate],Object[Sample]},
						ConstantArray[Object[Protocol,HPLC],3]
					}]},
					{
						sampleResourceID1,sampleResourceID2,sampleResourceID3,sampleResourceID4,sampleResourceID5,sampleResourceID6,sampleResourceID7,sampleResourceID8,
						sampleObjectID1,sampleObjectID2,sampleObjectID3,sampleObjectID4,
						hplcObjectID1,hplcObjectID2,hplcObjectID3
					}=newIDs;

					AppendTo[protocolObjects,hplcObjectID1];
					AppendTo[protocolObjects1,hplcObjectID2];
					AppendTo[protocolObjects2,hplcObjectID3];

					{
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID1,
							Amount->2.`Milliliter,
							Purchase->True,
							Sample->Link[sampleObjectID1],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:qdkmxzqor36M"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID2,
							Amount->0.2`Gram,
							Purchase->True,
							Sample->Link[sampleObjectID2],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:XnlV5jKzAvLB"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID3,
							Amount->0.2`Liter,
							Purchase->True,
							Sample->Link[sampleObjectID2],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:XnlV5jKzAvLB"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID4,
							Sample->Link[sampleObjectID3],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Container,Plate,"id:4pO6dM5kqNAM"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID5,
							Amount->100.`Milliliter,
							Purchase->True,
							Sample->Link[sampleObjectID4],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:XnlV5jKzAvLB"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID6,
							Amount->2.1`Gram,
							Purchase->True,
							Sample->Link[sampleObjectID1],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:qdkmxzqor36M"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID7,
							Amount->200.`Milliliter,
							Sample->Link[sampleObjectID2],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:XnlV5jKzAvLB"]]},
							DeveloperObject->True|>,
						<|
							Type->Object[Resource,Sample],
							Object->sampleResourceID8,
							Amount->100.`Milliliter,
							Sample->Link[sampleObjectID2],
							Status->Fulfilled,
							Replace[Models]->{Link[Model[Sample,"id:XnlV5jKzAvLB"]]},
							DeveloperObject->True|>,

						<|
							Type->Object[Sample],
							Object->sampleObjectID1,
							Name->Null,
							Model->Link[Model[Sample,"id:qdkmxzqor36M"],Objects],
							Product->Link[Object[Product,"id:3em6ZvLD1aDL"],Samples],
							State->Solid,
							DeveloperObject->True|>,
						<|
							Type->Object[Sample],
							Object->sampleObjectID2,
							Name->Null,
							Model->Link[Model[Sample,"id:XnlV5jKzAvLB"],Objects],
							Product->Link[Object[Product,"id:4pO6dM5kZkrL"],Samples],
							DeveloperObject->True|>,
						<|
							Type->Object[Container,Plate],
							Object->sampleObjectID3,
							Name->Null,
							Model->Link[Model[Container,Plate,"id:4pO6dM5kqNAM"],Objects],
							Product->Link[Object[Product,"id:eGakldJ4n4P1"],Samples],
							DeveloperObject->True|>,
						<|
							Type->Object[Sample],
							Object->sampleObjectID4,
							Name->Null,
							Model->Link[Model[Sample,"id:XnlV5jKzAvLB"],Objects],
							Product->Link[Object[Product,"id:4pO6dM5kZkrL"],Samples],
							DeveloperObject->True|>,

						<|
							Type->Object[Protocol,HPLC],
							Object->hplcObjectID1,
							Name->"HPLC protocol "<>ToString[#]<>" missing site"<>$SessionUUID,
							DateCompleted->DateObject[{2018,5,3,0,0,0.},"Instant","Gregorian",-7.],
							Status->Completed,
							Replace[SubprotocolRequiredResources]->{
								Link[sampleResourceID1,RootProtocol],
								Link[sampleResourceID2,RootProtocol],
								Link[sampleResourceID3,RootProtocol]},
							DeveloperObject->True
						|>,
						<|
							Type->Object[Protocol,HPLC],
							Object->hplcObjectID2,
							Name->"Price material test HPLC protocol 1 for notebook "<>ToString[#]<>$SessionUUID,
							DateCompleted->DateObject[{2018,1,5,0,0,0.},"Instant","Gregorian",-7.],
							Site->Link[$Site],
							Status->Completed,
							Replace[SubprotocolRequiredResources]->{
								Link[sampleResourceID4,RootProtocol],
								Link[sampleResourceID5,RootProtocol]},
							DeveloperObject->True
						|>,
						<|
							Type->Object[Protocol,HPLC],
							Object->hplcObjectID3,
							Name->"Price material test HPLC protocol 2 for notebook "<>ToString[#]<>$SessionUUID,
							DateCompleted->DateObject[{2018,1,2,0,0,0.},"Instant","Gregorian",-7.],
							Site->Link[$Site],
							Status->Completed,
							Replace[SubprotocolRequiredResources]->{
								Link[sampleResourceID6,RootProtocol],
								Link[sampleResourceID7,RootProtocol],
								Link[sampleResourceID8,RootProtocol]},
							DeveloperObject->True
						|>
					}]]&/@Range[numObj]);

			uploadPackets = Flatten[{
				<|
					Object->teamObjects[[#]],
					Replace[NotebooksFinanced] -> Link[notebookObjects[[#]],Financers]
				|>,
				<|
					Object -> notebookObjects[[#]],
					Replace[Financers] -> Link[teamObjects[[#]],NotebooksFinanced]
				|>,
				<|
					Object -> protocolObjects1[[#]],
					Transfer[Notebook] ->Link[notebookObjects[[#]],Objects]
				|>,
				<|
					Object -> protocolObjects2[[#]],
					Transfer[Notebook] ->Link[notebookObjects[[#]],Objects]
				|>,
				<|
					Object -> protocolObjects[[#]],
					Transfer[Notebook] -> Link[notebookObjects[[#]],Objects]
				|>
			}&/@Range[numObj]];
			(* generate two way links between objects that are created *)
			Upload[uploadPackets];

			(*create the first set of materials*)
			firstSetPackets=List[
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 2 for FPLC in PriceMaterials test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 3 for FPLC in PriceMaterials test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 4 for FPLC in PriceMaterials test"<>$SessionUUID
				],
				Association[
					Type -> Object[Item, Consumable],
					Model -> Link[Model[Item, Consumable, "Seal replacement kit for Avants"], Objects],
					Name -> "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID,
					Status -> Completed,
					Site -> Link[$Site],
					Notebook->Null
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID,
					Status -> Completed,
					Site -> Link[$Site],
					Notebook->Null
				],
				Association[
					Type -> Object[Maintenance, Replace, Seals],
					Name -> "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID,
					Status -> Completed,
					Site -> Link[$Site],
					Notebook->Null
				],
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
					Name -> "Test product for PriceMaterials unit tests salt"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for PriceMaterials unit tests salt"<>$SessionUUID
					},
					Notebook->Null
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
					Name -> "Test product for PriceMaterials unit tests seals"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for PriceMaterials unit tests seals"<>$SessionUUID
					}
				|>
			];

			firstUpload=Upload[firstSetPackets];

			sampleUpload=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"],
					Model[Sample, "Sodium Acetate, LCMS grade"]
				},
				{
					{"A1", Object[Container, Vessel, "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 2 for FPLC in PriceMaterials test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 3 for FPLC in PriceMaterials test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 4 for FPLC in PriceMaterials test"<>$SessionUUID]}
				},
				ECL`InternalUpload`InitialAmount -> {
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.1 Gram
				},
				Name -> {
					"Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID,
					"Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID,
					"Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID,
					"Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID
				}
			];

			Upload@List[
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for Price Materials FPLC unit test 1"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for Price Materials FPLC unit test 2"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for Price Materials FPLC unit test 3"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for Price Materials FPLC unit test 4"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Unit,
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Item, Consumable, "Seal replacement kit for Avants"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake seal kit resource for Price Materials FPLC unit test"<>$SessionUUID
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceMaterials"<>$SessionUUID
				|>,
				<|
					Object -> Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceMaterials unit tests seals"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID],
					ParentProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID], Subprotocols]
				|>
			];

			sample1 = Upload[<|
				Type -> Object[Sample],
				Name -> "Test sample for PriceMaterials"<>$SessionUUID,
				Replace[Model] -> Link[Model[Sample, "Sodium Acetate, LCMS grade"], Objects],
				DeveloperObject -> True,
				Replace[Product] -> Link[Object[Product, "Fake product 4 for PriceMaterial unit tests - fake salt v2"],Samples],
				State -> Solid
			|>];

			Upload[{
				<|
					Object -> Object[Resource, Sample, "id:J8AY5jD1OW1Z"],
					Replace[Sample] -> Link[sample1]
				|>,
				<|
					Object -> Object[Resource, Sample, "id:WNa4ZjKvbD4V"],
					Replace[Sample] -> Link[sample1]
				|>,
				<|
					Object -> Object[Resource, Sample, "id:jLq9jXvYPwZz"],
					Replace[Sample] -> Link[sample1]
				|>
			}];

		]
	},
	SymbolTearDown :> {
		Module[{objs, numObj, addObjs, allObjs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Sample, "Test Sample 1 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Product, "Test product for PriceMaterials unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for PriceMaterials unit tests seals"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceMaterials"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceMaterials test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 (refunded) in PriceMaterials test"<>$SessionUUID],
					Object[Maintenance, Replace, Seals, "Test maintenance to be excluded from PriceMaterials"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in PriceMaterials test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for Price Materials FPLC unit test 4"<>$SessionUUID],
					Object[Resource, Sample, "Fake seal kit resource for Price Materials FPLC unit test"<>$SessionUUID],
					Object[Item, Consumable, "PriceMaterials test seal kit 1 to be excluded"<>$SessionUUID],
					Object[Sample,"Test sample for PriceMaterials"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			numObj = 7;
			addObjs = Flatten[{
				Object[Team,Financing,"Team "<>ToString[#]<>" for price material test"<>$SessionUUID],
				Object[LaboratoryNotebook,"Lab notebook "<>ToString[#]<>" for price material test"<>$SessionUUID],
				Object[Protocol,HPLC,"HPLC protocol "<>ToString[#]<>" missing site"<>$SessionUUID],
				Object[Protocol,HPLC,"Price material test HPLC protocol 1 for notebook "<>ToString[#]<>$SessionUUID],
				Object[Protocol,HPLC,"Price material test HPLC protocol 2 for notebook "<>ToString[#]<>$SessionUUID]}&/@Range[numObj]
			];
			allObjs = Join[objs,addObjs];
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];


(* ::Subsection::Closed:: *)
(*PriceTransactions*)


DefineTests[PriceTransactions,
	{
		Example[{Basic, "Displays the transactional pricing information in a given transaction as a table:"},
			PriceTransactions[Object[Transaction, Order, "id:dORYzZJVxoGD"]],
			_Pane
		],
		Example[{Basic, "Displays the transactional pricing information for a list of all types of transactions as one large table:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:mnk9jORx1X7Z"], Object[Transaction, Order, "id:dORYzZJVxoGD"], Object[Transaction, ShipToUser, "id:3em6ZvLDpJP7"], Object[Transaction, DropShipping, "id:pZx9jo8nNoWP"]}],
			_Pane
		],
		Example[{Basic, "Displays the transactional pricing information for transactions tied to a given notebook:"},
			PriceTransactions[Object[LaboratoryNotebook, "id:Vrbp1jKGVMJW"]],
			_Pane
		],
		Example[{Additional, "Displays the transactional pricing information for transactions tied to multiple notebooks:"},
			PriceTransactions[{Object[LaboratoryNotebook, "id:lYq9jRxAJKw3"], Object[LaboratoryNotebook, "id:Vrbp1jKGVMJW"]}],
			_Pane
		],
		Example[{Basic, "Displays the transactional pricing information for all transactions tied to a given financing team:"},
			PriceTransactions[Object[Team, Financing, "id:lYq9jRxzbBoB"]],
			_Pane
		],
		Example[{Additional, "Displays the transactional pricing information for all transactions tied to multiple financing teams:"},
			PriceTransactions[{Object[Team, Financing, "id:1ZA60vLrdN00"], Object[Team, Financing, "id:lYq9jRxzbBoB"]}],
			_Pane
		],
		Example[{Additional, "Specifying a date span excludes transactions that fall outside that range:"},
			PriceTransactions[Object[LaboratoryNotebook, "id:XnlV5jKmqBrn"], Span[Now, Now - 2 * Day]],
			_Pane,
			SetUp :> {
				Upload[
					<|
						Object -> Object[Transaction, Order, "id:eGakldJ4EzAE"],
						DateDelivered -> Now - 1 * Day
					|>
				]
			}
		],
		Example[{Additional, "Date span can go in either order:"},
			PriceTransactions[Object[LaboratoryNotebook, "id:qdkmxzq0nBYp"], Span[Now - 3 * Week, Now]],
			_Pane
		],
		Example[{Additional, "Transactions whose samples are measured upon arrival are charged a volume-, weight- or count-measurement fee per sample, in addition to the receiving fee per model:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:rea9jlR19vme"], Object[Transaction, Order, "id:dORYzZJVxoGD"], Object[Transaction, ShipToECL, "id:bq9LA0Jx6KXA"], Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"]}],
			_Pane
		],
		Example[{Additional, "Pricing may be estimated for a pending transaction that is shipped to the user:"},
			PriceTransactions[Object[Transaction, ShipToUser, "Shipment of Column to User Site (pending)"]],
			_Pane
		],
		Example[{Additional, "If a transaction has been canceled, do not include it in the transactional pricing:"},
			PriceTransactions[{Object[Transaction, ShipToUser, "Shipment of Column to User Site (canceled)"], Object[Transaction, ShipToUser, "Shipment of Column to User Site (shipped)"]}, Consolidation -> Source],
			_Pane
		],
		Example[{Additional, "If a transaction has been refunded, do not include it in the transactional pricing:"},
			PriceTransactions[{Object[Transaction, ShipToUser, "Shipment of Column (with refunded TS report)"], Object[Transaction, ShipToUser, "Shipment of Column to User Site (shipped)"]}, Consolidation -> Source],
			_Pane
		],
		Example[{Additional, "If a transaction has been canceled, do not include it in the transactional pricing:"},
			PriceTransactions[{Object[Transaction, Order, "id:Z1lqpMz6EeZL"], Object[Transaction, Order, "id:dORYzZJVxoGD"], Object[Transaction, Order, "id:AEqRl9KzAPNv"]}],
			_Pane
		],
		Test["If a transaction links to a supplier order with a notebook, do not include it in the pricing:",
			DeleteDuplicates[Lookup[
				PriceTransactions[{Object[Transaction, Order, "Fake Transaction Order 23 with dependent order for Pricing Unit testing"], Object[Transaction, Order, "Fake Transaction Order 22 with supplier order for Pricing Unit testing"]}, OutputFormat -> Association],
				Source
			]],
			{Object[Transaction, Order, "id:WNa4ZjKazK7E"]}
		],

		Test["If a transaction has Fulfillment populated with a protocol object, don't price it in PriceTransactions (it is priced in PriceMaterials):",
			PriceTransactions[Object[Transaction, Order, "id:01G6nvwkdEK7"], OutputFormat -> Table],
			{}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> Table, return an empty list:",
			PriceTransactions[Object[LaboratoryNotebook, "id:mnk9jOR3KMOm"], OutputFormat -> Table],
			{}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> Association, return an empty list:",
			PriceTransactions[Object[LaboratoryNotebook, "id:mnk9jOR3KMOm"], OutputFormat -> Association],
			{}
		],
		Test["If no purchasable materials have accumulated and OutputFormat -> TotalPrice, return $0.00:",
			PriceTransactions[Object[LaboratoryNotebook, "id:mnk9jOR3KMOm"], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching MaterialsPriceTableP:"},
			PriceTransactions[Object[Transaction, Order, "id:D8KAEvGx84LL"], OutputFormat -> Association],
			{TransactionsPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the transactional cost of all materials:"},
			PriceTransactions[{Object[Transaction, Order, "id:XnlV5jKzMZ0n"], Object[Transaction, Order, "id:4pO6dM5k0ner"]}, OutputFormat -> TotalPrice],
			15.` * USD,
			EquivalenceFunction -> Equal
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their transactional prices in the output table:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"], Object[Transaction, Order, "id:pZx9jo8zLJaj"]}, Consolidation -> Notebook],
			_Pane
		],
		(* this has not price currently since I switched to container instead of samples (and removed measurement pricing), and this has no ContainersOut *)
		(*	Example[{Options, Consolidation, "Specifying Consolidation -> Transaction groups all items by Source and sums their transactional prices in the output table:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:bq9LA0Jx6KXA"], Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"]}, Consolidation -> Source],
			_Pane
		],*)
		Example[{Options, Consolidation, "Specifying Consolidation -> Transaction groups all items by Source and sums their transactional prices in the output table:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"], Object[Transaction, Order, "id:pZx9jo8zLJaj"]}, Consolidation -> Source],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Material groups all items by Material and sums their transactional prices in the output table:"},
			PriceTransactions[{Object[Transaction, Order, "id:pZx9jo8zLJaj"], Object[Transaction, Order, "id:D8KAEvGx84LL"]}, Consolidation -> Material],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceTransactions[{Object[Transaction, Order, "id:D8KAEvGx84LL"]}, Consolidation -> Material, OutputFormat -> TotalPrice],
			7.5` * USD,
			EquivalenceFunction -> Equal
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching MaterialsPriceTableP:"},
			PriceTransactions[{Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"], Object[Transaction, Order, "id:pZx9jo8zLJaj"]}, Consolidation -> Material, OutputFormat -> Association],
			{TransactionsPriceTableP..}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceTransactions[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceTransactions[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceTransactions[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Specifying the date range excludes transactions that fall outside that range:",
			DeleteDuplicates[Lookup[
				PriceTransactions[Object[LaboratoryNotebook, "id:O81aEBZ40MY3"], (Today - 1 * Week);;Today, OutputFormat -> Association],
				Source
			]],
			{Object[Transaction, Order, "id:dORYzZJVxoGD"]}
		],
		Test["If a date range is not specified, then get all the transactions within the last month:",
			DeleteDuplicates[Lookup[
				PriceTransactions[Object[LaboratoryNotebook, "id:O81aEBZ40MY3"], OutputFormat -> Association],
				Source,
				{}
			]],
			{Object[Transaction, Order, "id:dORYzZJVxoGD"], Object[Transaction, Order, "id:pZx9jo8zLJaj"], Object[Transaction, Order, "id:qdkmxzqo78wp"]}
		],
		Test["If a date range is specified for a Notebook and no transaction falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceTransactions[Object[LaboratoryNotebook, "id:WNa4ZjKvbmdE"], Span[DateObject["1 January 2016"], DateObject["1 January 2017"]], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook then get all the transactions that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceTransactions[Object[LaboratoryNotebook, "id:R8e1PjpRdM3J"], Span[DateObject["1 July 2017"], Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{Object[Transaction, DropShipping, "id:R8e1PjpRdjxp"]}
		],
		Test["Prices match expectation for shipped ShipToUser transaction:",
			Lookup[PriceTransactions[Object[Transaction, ShipToUser, "Shipment of Column to User Site (shipped)"], OutputFormat -> Association], {PricingCategory, Price}],
			{
				{"Shipping", 15.89 USD},
				{"Handling", 15.00 USD},
				{"Packaging Materials", 6.70 USD}
			},
			EquivalenceFunction -> (And[
				MatchQ[#1[[All, 1]], #2[[All, 1]]],
				Equal[Round[#1[[All, 2]], 0.01], Round[#2[[All, 2]], 0.01]]
			]&)
		],
		Test["Prices match expectation for pending ShipToUser transaction:",
			Lookup[PriceTransactions[Object[Transaction, ShipToUser, "Shipment of Column to User Site (pending)"], OutputFormat -> Association], {PricingCategory, Price}],
			{
				{"Shipping (estimated)", 15.29 USD},
				{"Handling", 15.00 USD},
				{"Packaging Materials", 6.70 USD}
			},
			EquivalenceFunction -> (And[
				MatchQ[#1[[All, 1]], #2[[All, 1]]],
				Equal[Round[#1[[All, 2]], 0.01], Round[#2[[All, 2]], 0.01]]
			]&)
		],
		Example[{Basic,"Prices match expectation for completed ShipToUser transaction with aliquotting by SP:"},
			Lookup[PriceTransactions[Object[Transaction, ShipToUser, "id:Vrbp1jKnaoMz"], OutputFormat -> Association], {PricingCategory, Price}],
			{
				{"Shipping", 187.75 USD},
				{"Handling", 15.00 USD},
				{"Packaging Materials", 13.00 USD},
				{"Aliquoting", 14.04 USD}
			},
			EquivalenceFunction -> (And[
				MatchQ[#1[[All, 1]], #2[[All, 1]]],
				Equal[SafeRound[#1[[All, 2]], 0.1, Round -> Up], SafeRound[#2[[All, 2]], 0.1, Round->Up]]
			]&)
		],
		Test["Prices match expectation for completed ShipToUser transaction with aliquotting by SM:",
			Quiet[Lookup[PriceTransactions[Object[Transaction, ShipToUser, "id:Y0lXejMlDLoW"], OutputFormat -> Association], {PricingCategory, Price}], Pricing::NoPricingInfo],
			{
				{"Shipping", 47.53 USD},
				{"Handling", 15.00 USD},
				{"Packaging Materials", 7.85 USD},
				{"Aliquoting", 9.48 USD}
			},
			EquivalenceFunction -> (And[
				MatchQ[#1[[All, 1]], #2[[All, 1]]],
				Equal[SafeRound[#1[[All, 2]], 0.1, Round->Up], SafeRound[#2[[All, 2]], 0.1, Round-> Up]]
			]&)
		],
		Example[{Additional,"Can price transaction between sites:"},
			PriceTransactions[Object[Transaction,SiteToSite,"Test SiteToSite transaction for PriceTransactions tests"<>$SessionUUID]],
			_Pane
		]
	},
	(* reset the DateDelivered and DateShipped to something recent *)
	SymbolSetUp :> {
		Block[{$AllowPublicObjects=True}, Module[{objs,existingObjs,container,sample,transaction,peanuts,bag,box},
			objs=Quiet[Cases[
				Flatten[{
					Object[Transaction,SiteToSite,"Test SiteToSite transaction for PriceTransactions tests"<>$SessionUUID],
					Object[Sample,"Test sample for PriceTransactions tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container for PriceTransactions tests"<>$SessionUUID],
					Object[Item,Consumable,"Test peanuts for PriceTransactions tests"<>$SessionUUID],
					Object[Container,Bag,"Test bag for PriceTransactions tests"<>$SessionUUID],
					Object[Container,Box,"Test box for PriceTransactions tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			ClearDownload[];
			ClearMemoization[];

			container =Upload[<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Container -> Link[$Site, Contents, 2],
				Site -> Link[$Site],
				Name->"Test container for PriceTransactions tests"<>$SessionUUID,
				DeveloperObject->True
			|>];
			sample = ECL`InternalUpload`UploadSample[
				Model[Sample, "Methanol"],
				{"A1", container},
				ECL`InternalUpload`InitialAmount -> 20 Milliliter,
				Status -> Stocked,
				Name->"Test sample for PriceTransactions tests"<>$SessionUUID
			];
			ECL`InternalUpload`UploadNotebook[{container, sample}, Object[LaboratoryNotebook, "Transaction Objects"]];
			transaction = Block[{$Notebook = Object[LaboratoryNotebook, "Transaction Objects"]},
					ECL`ShipBetweenSites[sample, $Site][[1]]
				];

			{peanuts,bag,box}=ECL`InternalUpload`UploadSample[
				{Model[Item,Consumable,"Packing peanuts"],Model[Container,Bag,"Medium shipping bag"],Model[Container,Box,"id:01G6nvw75mPY"]},
				ConstantArray[{"Building Slot 1",$Site},3],
				Name->{
					"Test peanuts for PriceTransactions tests"<>$SessionUUID,
					"Test bag for PriceTransactions tests"<>$SessionUUID,
					"Test box for PriceTransactions tests"<>$SessionUUID
				}
			];

			Upload[
				<|
					Object -> transaction,
					Replace[ReceivedSamples] -> Link[Download[transaction, SamplesIn[Object]]],
					Replace[ReceivedContainers] -> Link[Download[transaction, ContainersIn[Object]]],
					Replace[SamplesOut] -> Link[Download[transaction, SamplesIn[Object]]],
					Replace[ContainersOut] -> Link[Download[transaction, ContainersIn[Object]]],
					Status -> Received,
					Source -> Link[$Site],
					Replace[ShippingContainers]->Link[box],
					Replace[SecondaryContainers]->Link[bag],
					Replace[Padding]->Link[peanuts],
					Name->"Test SiteToSite transaction for PriceTransactions tests"<>$SessionUUID
				|>
			];

			(* set up dates for our permanent test objects *)
			Upload[
				{
					<|
						Object -> Object[Transaction, Order, "id:dORYzZJVxoGD"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToECL, "id:mnk9jORx1X7Z"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:4pO6dM5k0ner"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:XnlV5jKzMZ0n"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:eGakldJ4EzAE"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:Vrbp1jKD60mW"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:Z1lqpMz6EeZL"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToECL, "id:54n6evLEwzZP"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToECL, "id:rea9jlR19vme"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToECL, "id:bq9LA0Jx6KXA"],
						DateDelivered -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToECL, "id:8qZ1VW0MaxPR"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:AEqRl9KzAPNv"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:01G6nvwkdEK7"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:D8KAEvGx84LL"],
						DateDelivered -> Now - 50 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:pZx9jo8zLJaj"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, Order, "id:qdkmxzqo78wp"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, DropShipping, "id:pZx9jo8nNoWP"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, DropShipping, "id:R8e1PjpRdjxp"],
						DateDelivered -> Now - 10 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToUser, "id:3em6ZvLDpJP7"],
						DateShipped -> Now - 1 * Day
					|>,
					<|
						Object -> Object[Transaction, ShipToUser, "id:Z1lqpMz6XdBO"],
						DateShipped -> Now - 1 * Day
					|>
				}
			];
		]];
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Transaction,SiteToSite,"Test SiteToSite transaction for PriceTransactions tests"<>$SessionUUID],
					Object[Sample,"Test sample for PriceTransactions tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container for PriceTransactions tests"<>$SessionUUID],
					Object[Item,Consumable,"Test peanuts for PriceTransactions tests"<>$SessionUUID],
					Object[Item,Bag,"Test bag for PriceTransactions tests"<>$SessionUUID],
					Object[Item,Box,"Test box for PriceTransactions tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	},
	Stubs :> {
		$DeveloperSearch=True,
		$TimeZone=-7.
	}
];



(* ::Subsection::Closed:: *)
(*PriceCleaning*)

DefineTests[
	PriceCleaning,
	{

		(* ----------- *)
		(* -- Basic -- *)
		(* ----------- *)


		Example[{Basic, "Displays the pricing information for washing and autoclaving reusable objects used in a protocol as a table:"},
			PriceCleaning[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceCleaning[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceCleaning[Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceCleaning[Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceCleaning[
				Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* ---------------- *)
		(* -- Additional -- *)
		(* ---------------- *)


		Example[{Additional, "If a protocol has been refunded, include it in the pricing to reflect the refunded price:"},
			outputAssociation=PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -- Time Span -- *)
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceCleaning[
				Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -------------- *)
		(* -- Messages -- *)
		(* -------------- *)

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceCleaning is called on a subprotocol:"},
			PriceCleaning[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceCleaning::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceCleaning is called on a protocol that is not Completed:"},
			PriceCleaning[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceCleaning::ProtocolNotCompleted}
		],


		(* ----------- *)
		(* -- Tests -- *)
		(* ----------- *)

		Test["If no objects were washed or autoclaved as a result of the protocol and OutputFormat -> Table, return an empty list:",
			PriceCleaning[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no objects were washed or autoclaved as a result of the protocol and OutputFormat -> Association, return an empty list:",
			PriceCleaning[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no objects were washed or autoclaved as a result of the protocol and OutputFormat -> TotalPrice, return $0.00:",
			PriceCleaning[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],

		(* ------------- *)
		(* -- Options -- *)
		(* ------------- *)

		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching CleaningPriceTableP:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{CleaningPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the washing/autoclave cost for all objects:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				Consolidation -> Protocol
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Container groups all items by Model object and sums their prices in the output table:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				Consolidation -> ContainerModel
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> CleaningMethod groups all items by their cleaning method and sums their prices in the output table:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				Consolidation -> CleaningCategory
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				Consolidation -> ContainerModel,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching OperatorPriceTableP:"},
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]
				},
				Consolidation -> ContainerModel,
				OutputFormat -> Association
			],
			{CleaningPriceTableP..}
		],

		(* -- Tests -- *)

		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceCleaning[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceCleaning[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceCleaning[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			PriceCleaning[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			Quantity[24.00, "USDollars"]
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			PriceCleaning[
				Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			],
			Quantity[16.00, "USDollars"]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceCleaning[Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceCleaning[Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID], Span[Now - 1 * Day, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceCleaning[Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceCleaning[Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID]]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceCleaning tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceCleaning testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceCleaning"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 3 for PriceCleaning test (dishwash)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 6 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 3 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 4 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 5 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 7 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 1 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 2 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource for PriceCleaning Tests (not washable)"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceCleaning tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceCleaning testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceCleaning"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 6 for PriceCleaning tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource for PriceCleaning Tests (not washable)"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},


	(* ------------ *)
	(* -- Set Up -- *)
	(* ------------ *)


	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceCleaning tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceCleaning testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceCleaning"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for PriceCleaning test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for PriceCleaning Tests (not washable)"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID, containerID, containerID2, containerID3},

			(* create iDs for model uploads *)
			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];
			containerID=CreateID[Model[Container, Vessel]];
			containerID2=CreateID[Model[Container, Vessel]];
			containerID3=CreateID[Model[Container, Vessel]];

			(* models and bill uploads *)
			firstSet=List[

				(* financing team *)
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1 * Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceCleaning testing"<>$SessionUUID
				|>,

				(* pricing model *)
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID,
					Site->Link[$Site],
					PlanType -> Subscription,
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 10 USD / Hour},
						{2, 20 USD / Hour},
						{3, 30 USD / Hour},
						{4, 40 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 4 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 5 USD},
						{"Autoclave sterile labware", 3 USD}
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
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,

				(* notebook *)
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceCleaning tests"<>$SessionUUID
				|>,

				(* protocols *)

				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID,
					DateCompleted -> Now - 2 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DeveloperObject -> False,
					Name -> "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID,
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				],

				(* containers etc - this may not need all the objects I've made here *)
				(* TODO: may actually want more test models to check that CleaningMethod -> Null is ok *)

				Association[
					Object -> containerID,
					Sterile -> True,
					Reusability -> True,
					CleaningMethod -> Handwash,
					Name -> "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID
				],
				Association[
					Object -> containerID2,
					Sterile -> False,
					Reusability -> True,
					CleaningMethod -> DishwashPlastic,
					Name -> "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID
				],
				Association[
					Object -> containerID3,
					Sterile -> False,
					Reusability -> False,
					CleaningMethod -> Null,
					Name -> "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID2, Objects],
					Reusable -> True,
					Name -> "Test Container 3 for PriceCleaning test (dishwash)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID3, Objects],
					Reusable -> False,
					Name -> "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID
				]
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceCleaning testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceCleaning"<>$SessionUUID
				|>,

				(* -- Resources - Containers -- *)

				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 6 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 3 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 4 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 5 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 7 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 1 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 2 for PriceCleaning tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource for PriceCleaning Tests (not washable)"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceCleaning testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceCleaning testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceCleaning tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceCleaning tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceCleaning test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceCleaning test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceCleaning test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceCleaning test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceCleaning test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceCleaning test (no containers used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceCleaning testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceCleaning"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for PriceCleaning test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for PriceCleaning test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for PriceCleaning test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for PriceCleaning test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for PriceCleaning test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for PriceCleaning test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for PriceCleaning tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for PriceCleaning Tests (not washable)"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];







(* ::Subsection::Closed:: *)
(*PriceStocking*)

DefineTests[PriceStocking,
	{

		(* ----------- *)
		(* -- Basic -- *)
		(* ----------- *)

		Example[{Basic, "Displays the pricing information for restocking of public samples used in a protocol as a table:"},
			PriceStocking[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceStocking[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceStocking[Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceStocking[Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceStocking[
				Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			DeleteDuplicates@Download[Lookup[outputAssociation, Source], Object],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&),
			Variables :> {outputAssociation}
		],

		(* ---------------- *)
		(* -- Additional -- *)
		(* ---------------- *)

		Example[{Additional, "If a protocol has been refunded, include it in the pricing to reflect the refunded price:"},
			outputAssociation=PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			DeleteDuplicates@Download[Lookup[outputAssociation, Source], Object],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&),
			Variables :> {outputAssociation}
		],

		(* -- Time Span -- *)
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceStocking[
				Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			DeleteDuplicates@Download[Lookup[outputAssociation, Source], Object],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&),
			Variables :> {outputAssociation}
		],

		(* -------------- *)
		(* -- Messages -- *)
		(* -------------- *)

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceStocking is called on a subprotocol:"},
			PriceStocking[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceStocking::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceStocking is called on a protocol that is not Completed:"},
			PriceStocking[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceStocking::ProtocolNotCompleted}
		],


		(* ------------- *)
		(* -- Options -- *)
		(* ------------- *)

		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching StockingPriceTableP:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{StockingPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the restocking cost for all objects:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				Consolidation -> Protocol
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Container groups all items by Model object and sums their prices in the output table:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				Consolidation -> Model
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> CleaningMethod groups all items by their storage condition and sums their prices in the output table:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				Consolidation -> StorageCondition
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				Consolidation -> Model,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching StockingPriceTableP:"},
			PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
				},
				Consolidation -> Model,
				OutputFormat -> Association
			],
			{StockingPriceTableP..}
		],

		(* ----------- *)
		(* -- Tests -- *)
		(* ----------- *)

		Test["If no public samples were consumed as a result of the protocol and OutputFormat -> Table, return an empty list:",
			PriceStocking[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID], OutputFormat -> Table],
			{}
		],
		Test["If no public samples were consumed as a result of the protocol and OutputFormat -> Association, return an empty list:",
			PriceStocking[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID], OutputFormat -> Association],
			{}
		],
		Test["If no public samples were consumed as a result of the protocol and OutputFormat -> TotalPrice, return $0.00:",
			PriceStocking[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID], OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceStocking[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceStocking[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceStocking[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			Round[PriceStocking[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			], 0.01 USD],
			Quantity[1.50, "USDollars"]
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			Round[PriceStocking[
				Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			], 0.01 USD],
			RangeP[Quantity[6.00, "USDollars"], Quantity[6.10, "USDollars"]]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates@Download[
				Lookup[
					PriceStocking[Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID], OutputFormat -> Association],
					Source
				],
				Object
			],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&)
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceStocking[Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID], Span[Now - 1 * Day, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates@Download[
				Lookup[
					PriceStocking[Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
					Source,
					{}
				],
				Object
			],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&)
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			Download[
				Lookup[
					PriceStocking[Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID], OutputFormat -> Association],
					Source
				],
				Object
			],
			_List?(Length[Complement[
				#,
				Download[
					{
						Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
						Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
						Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID]
					},
					Object
				]
			]]==0&)
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStocking Tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceStocking testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceStocking"<>$SessionUUID],

				(*objects, models, products, resources*)
				Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID],

				Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID],

				Object[Product, "Test Product for PriceStocking test (public)"<>$SessionUUID],
				Object[Product, "Test Product for PriceStocking test 2 (private)"<>$SessionUUID],
				Object[Product, "Test Product for PriceStocking test 3 (kit)"<>$SessionUUID],
				Object[Product, "Test Product for PriceStocking test 4 (not stocked)"<>$SessionUUID],
				Object[Product, "Test Product for PriceStocking test 5 (deprecated)"<>$SessionUUID],
				Object[Product, "Test Product for PriceStocking test 6 (public)"<>$SessionUUID],

				Object[Resource, Sample, "Test Resource 1 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 2 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 3 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 4 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 5 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 6 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 7 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 8 for PriceStocking Tests"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStocking Tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceStocking testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceStocking"<>$SessionUUID],

				(*objects, models, products, resources*)
				Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID],

				Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID],

				Object[Product, "Test Product for PriceStocking test (public)"<>$SessionUUID],

				Object[Resource, Sample, "Test Resource 1 for PriceStocking Tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 8 for PriceStocking Tests"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},


	(* ------------ *)
	(* -- Set Up -- *)
	(* ------------ *)


	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStocking Tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceStocking testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceStocking"<>$SessionUUID],

					(*objects, models, products, resources*)
					Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for PriceStocking Tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{
			firstSet, newBillObject, secondUploadList, syncBillingResult,
			financingTeamID, modelPricingID1, objectNotebookID, objectNotebookID2, fplcProtocolID,
			sampleID1, sampleID2, sampleID3, sampleID4, sampleID5, productID1, productID2, productID3, productID4, productID5, productID6,
			productID1a, productID1b, productID5a, productID5b
		},

			(* create iDs for model uploads *)
			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];

			(* models: public, private, kit, no kit *)
			sampleID1=CreateID[Model[Sample]];
			sampleID2=CreateID[Model[Sample]];
			sampleID3=CreateID[Model[Sample]];
			sampleID4=CreateID[Model[Sample]];
			sampleID5=CreateID[Model[Sample]];

			(* products: stocked, not stocked, kit, private *)
			{productID1, productID1a, productID1b, productID2, productID3, productID4,
				productID5, productID5a, productID5b, productID6} = CreateID[ConstantArray[Object[Product],10]];

			(* models and bill uploads *)
			firstSet=List[

				(* financing team *)
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1 * Day,
					Replace[CurrentPriceSchemes]->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceStocking testing"<>$SessionUUID
				|>,

				(* pricing model *)
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 10 USD / Hour},
						{2, 20 USD / Hour},
						{3, 30 USD / Hour},
						{4, 40 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 4 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 5 USD},
						{"Autoclave sterile labware", 3 USD}
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
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,

				(* notebook *)
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceStocking Tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceStocking Tests"<>$SessionUUID
				|>,

				(* protocols *)

				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceStocking test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID,
					DateCompleted -> Now - 2 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceStocking test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID,
					DateCompleted -> Null,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Site -> Link[$Site],
					Status -> Completed,
					DateCompleted -> Now,
					Type -> Object[Protocol, SampleManipulation],
					DeveloperObject -> False,
					Name -> "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID,
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				],


				(*parameters to change: stocking frequency, storage condition, state, public/private*)

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
					Name -> "Test Product for PriceStocking test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1a,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product a for PriceStocking test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1b,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product b for PriceStocking test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID6,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceStocking test 6 (public)"<>$SessionUUID
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
					Name -> "Test Product for PriceStocking test 2 (private)"<>$SessionUUID
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
					Name -> "Test Product for PriceStocking test 3 (kit)"<>$SessionUUID
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
					Name -> "Test Product for PriceStocking test 4 (not stocked)"<>$SessionUUID
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
					Name -> "Test Product for PriceStocking test 5 (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5a,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceStocking test 5a (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5b,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceStocking test 5b (deprecated)"<>$SessionUUID
				],

				(* -- Model[Sample] uploads -- *)

				(* public normal sample *)
				Association[
					Object -> sampleID1,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1, ProductModel], Link[productID5, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID
				],
				(* private normal sample *)
				Association[
					Object -> sampleID2,
					Notebook -> Link[objectNotebookID, Objects],
					Replace[Products] -> {Link[productID2, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID
				],
				(* public kit sample *)
				Association[
					Object -> sampleID3,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1a, ProductModel], Link[productID5a, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> sampleID4,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1b, ProductModel], Link[productID5b, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID
				],
				(* second public sample, different storage condition *)
				Association[
					Object -> sampleID5,
					Notebook -> Null,
					Replace[Products] -> {Link[productID6, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Freezer"]],
					Name -> "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID
				],

				(* -- Object Upload -- *)
				(* public, normal sample *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID1, Objects],
					Name -> "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID
				],
				(*private sample, still has a model*)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID2, Objects],
					Name -> "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID
				],
				(* public, part of a kit *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID3, Objects],
					Name -> "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID
				],
				(* public, not stocked *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID4, Objects],
					Name -> "Test Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID
				],
				(* public, deprecated *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID5, Objects],
					Name -> "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID
				],
				(* public, no model *)
				Association[
					Type -> Object[Sample],
					Model -> Null,
					Name -> "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID
				]
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				Association[
					Object -> newBillObject,
					Name -> "A test bill object for PriceStocking testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				],
				Association[
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceStocking"<>$SessionUUID
				],

				(* update the kit product with KitComponents *)
				Association[
					Object -> Object[Product, "Test Product for PriceStocking test 3 (kit)"<>$SessionUUID],
					Replace[KitComponents] -> {
						<|
							NumberOfItems -> 1,
							ProductModel -> Link[Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID], KitProducts],
							DefaultContainerModel -> Link[Model[Container, Vessel, "50mL Tube"]],
							Amount -> 10 Milliliter,
							Position -> "A1",
							ContainerIndex -> 1,
							DefaultCoverModel -> Null,
							OpenContainer -> Null
						|>
					}
				];

				(* -- Resources -- *)

				(* normal resource for the main parent protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Amount -> 1 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 6 for PriceStocking Tests"<>$SessionUUID
				],
				(* normal resource - the protocol was refunded so it shouldnt get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Amount -> 1000 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 3 for PriceStocking Tests"<>$SessionUUID
				],
				(* normal resource for the subprotocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 4 for PriceStocking Tests"<>$SessionUUID
				],
				(* kit resource for an incomplete protocol (should not get counted) *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 5 for PriceStocking Tests"<>$SessionUUID
				],
				(* second public sample which should also get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID]],
					Amount -> 40 Milliliter,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 7 for PriceStocking Tests"<>$SessionUUID
				],
				(* private sample that should not get counted in teh parent protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID]],
					Amount -> 100 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 1 for PriceStocking Tests"<>$SessionUUID
				],
				(* public sample without a model which should not get stocked - this should be VOQ'd out *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID]],
					Amount -> 10 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 2 for PriceStocking Tests"<>$SessionUUID
				],
				(* kit resource for the top level protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID]],
					Amount -> 30 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 8 for PriceStocking Tests"<>$SessionUUID
				]
			];

			Upload[secondUploadList];

		]
	},
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceStocking testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceStocking testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceStocking Tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceStocking Tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceStocking test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceStocking test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceStocking test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceStocking test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceStocking test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceStocking test (no samples used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceStocking testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceStocking"<>$SessionUUID],

					(*objects, models, products, resources*)
					Model[Sample, "Test Model Sample for PriceStocking test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceStocking test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for PriceStocking test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceStocking test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for PriceStocking Tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for PriceStocking Tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];




(* ::Subsection::Closed:: *)
(*PriceData*)

DefineTests[PriceData,
	{
		Example[{Basic, "Displays the pricing information for the data usage of a financing team currently:"},
			PriceData[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for the data usage of a financing team for a past date:"},
			PriceData[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID], Now - 1 Month],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, provides a list of associations matching DataPriceTableP:"},
			PriceData[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID], OutputFormat -> Association],
			{DataPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> JSON, provides a list of JSON entries :"},
			PriceData[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID], OutputFormat -> JSON],
			_String
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice and a date is not provided, provides the current rate:"},
			PriceData[Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID], OutputFormat -> TotalPrice],
			UnitsP[USD]
		],
		Example[{Messages, "MissingBill", "If the Bill is not accessible for a given object, throw a soft message and return a table excluding the data charges:"},
			PriceData[{Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID], Object[LaboratoryNotebook, "Test lab notebook 2 for PriceData tests"<>$SessionUUID]}],
			_Pane,
			Messages :> {PriceData::MissingBill}
		],
		Example[{Messages, "MissingNumberOfObjects", "Throw an error when the number of objects is unable to be retrieved:"},
			PriceData[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID]],
			_Pane,
			Messages :> {PriceData::MissingNumberOfObjects},
			Stubs :> {
				GetNumOwnedObjects[x_]:=List[Association[ "team_id" -> "blah", "num_objects" -> 100000]]
			}
		],
		Example[{Messages, "MissingPricingRate", "Throw an error when the pricing rate for the data is missing:"},
			PriceData[{
				Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID]
			}],
			_Pane,
			Messages :> {PriceData::MissingPricingRate}
		],
		Test["If no team is provided and OutputFormat -> Table, return an empty list:",
			PriceData[{}, OutputFormat -> Table],
			{}
		],
		Test["If no team is provided and OutputFormat -> Association, return an empty list:",
			PriceData[{}, OutputFormat -> Association],
			{}
		],
		Test["If no team is provided and OutputFormat -> TotalPrice, return 0*USD:",
			PriceData[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 2 (no bill) for PriceData testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceData testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceData tests"<>$SessionUUID],
				Object[LaboratoryNotebook,"Test lab notebook 3 (no objects) for PriceData tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceData testing"<>$SessionUUID],
				Object[Bill, "A test bill object 2 (no data price rate) for PriceData testing"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 2 (no bill) for PriceData testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceData testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceData tests"<>$SessionUUID],
				Object[LaboratoryNotebook,"Test lab notebook 3 (no objects) for PriceData tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceData testing"<>$SessionUUID],
				Object[Bill, "A test bill object 2 (no data price rate) for PriceData testing"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 2 (no bill) for PriceData testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceData testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceData tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceData tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceData testing"<>$SessionUUID],
					Object[Bill, "A test bill object 2 (no data price rate) for PriceData testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, financingTeamID2, financingTeamID3, syncBillingResult2, newBillObject2},

			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			financingTeamID2=CreateID[Object[Team, Financing]];
			financingTeamID3=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];

			firstSet=List[
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceData testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID2,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object 2 (no bill) for PriceData testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID3,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceData testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceData testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
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
						{
							Link[Model[StorageCondition, "Ambient Storage"]],
							Quantity[1, "USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition, "Refrigerator"]],
							Quantity[2, "USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition, "Freezer"]],
							Quantity[3, "USDollars" / ("Centimeters"^3 * "Months")]
						}
					},
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceData tests"<>$SessionUUID
				|>,
				<|
					Replace[Financers] -> {
						Link[financingTeamID2, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceData tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID3, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 3 (no objects) for PriceData tests"<>$SessionUUID
				|>
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID]],
				PriceData::MissingBill
			];
			syncBillingResult2=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];
			newBillObject2=FirstCase[syncBillingResult2, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceData testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					Object -> newBillObject2,
					Name -> "A test bill object 2 (no data price rate) for PriceData testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month,
					ConstellationPrice -> Null
				|>
			];

			Upload[secondUploadList];

		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceData testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 2 (no bill) for PriceData testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceData testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceData testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceData tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceData tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceData tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceData testing"<>$SessionUUID],
					Object[Bill, "A test bill object 2 (no data price rate) for PriceData testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];




(* ::Subsection::Closed:: *)
(*PriceRecurring*)

DefineTests[PriceRecurring,
	{
		Example[{Basic, "Displays the pricing information for the data usage of a financing team currently:"},
			PriceRecurring[Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for the data usage of a financing team for a past date:"},
			PriceRecurring[Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID], Now - 1 Month],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, provides a list of associations matching DataPriceTableP:"},
			PriceRecurring[Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID], OutputFormat -> Association],
			{RecurringPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> JSON, provides a list of JSON entries :"},
			PriceRecurring[Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID], OutputFormat -> JSON],
			_String
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice and a date is not provided, provides the current rate:"},
			PriceRecurring[Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID], OutputFormat -> TotalPrice],
			UnitsP[USD]
		],
		Example[{Messages, "MissingBill", "If the Bill is not accessible for a given object, throw a soft message and return a table excluding the data charges:"},
			PriceRecurring[{Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID], Object[LaboratoryNotebook, "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID]}],
			_Pane,
			Messages :> {PriceRecurring::MissingBill}
		],
		Example[{Messages, "MissingRecurringPriceInformation", "Throw an error when some if the recurring price information is missing:"},
			PriceRecurring[{
				Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID]
			}],
			_Pane,
			Messages :> {PriceRecurring::MissingRecurringPriceInformation}
		],
		Test["If no team is provided and OutputFormat -> Table, return an empty list:",
			PriceRecurring[{}, OutputFormat -> Table],
			{}
		],
		Test["If no team is provided and OutputFormat -> Association, return an empty list:",
			PriceRecurring[{}, OutputFormat -> Association],
			{}
		],
		Test["If no team is provided and OutputFormat -> TotalPrice, return 0*USD:",
			PriceRecurring[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 2 (no bill) for PriceRecurring testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceRecurring testing"<>$SessionUUID],
				Object[Bill, "A test bill object 2 (no data price rate) for PriceRecurring testing"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 2 (no bill) for PriceRecurring testing"<>$SessionUUID],
				Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceRecurring testing"<>$SessionUUID],
				Object[Bill, "A test bill object 2 (no data price rate) for PriceRecurring testing"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 2 (no bill) for PriceRecurring testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceRecurring testing"<>$SessionUUID],
					Object[Bill, "A test bill object 2 (no data price rate) for PriceRecurring testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, financingTeamID2, financingTeamID3, syncBillingResult2, newBillObject2},

			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			financingTeamID2=CreateID[Object[Team, Financing]];
			financingTeamID3 =CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];

			firstSet=List[
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceRecurring testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID2,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object 2 (no bill) for PriceRecurring testing"<>$SessionUUID
				|>,
				<|
					Object -> financingTeamID3,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 0 USD,
					Replace[OperatorTimePrice] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
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
						{
							Link[Model[StorageCondition, "Ambient Storage"]],
							Quantity[1, "USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition, "Refrigerator"]],
							Quantity[2, "USDollars" / ("Centimeters"^3 * "Months")]
						},
						{
							Link[Model[StorageCondition, "Freezer"]],
							Quantity[3, "USDollars" / ("Centimeters"^3 * "Months")]
						}
					},
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceRecurring tests"<>$SessionUUID
				|>,
				<|
					Replace[Financers] -> {
						Link[financingTeamID2, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID3, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 3 (no objects) for PriceRecurring tests"<>$SessionUUID
				|>
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID]],
				PriceData::MissingBill
			];
			syncBillingResult2=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];
			newBillObject2=FirstCase[syncBillingResult2, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceRecurring testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					Object -> newBillObject2,
					Name -> "A test bill object 2 (no data price rate) for PriceRecurring testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month,
					CommandCenterPrice -> Null
				|>
			];

			Upload[secondUploadList];

		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceRecurring testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 2 (no bill) for PriceRecurring testing"<>$SessionUUID],
					Object[Team, Financing, "A test financing team object 3 (no pricing rate) for PriceRecurring testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceRecurring testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceRecurring tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceRecurring tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 3 (no objects) for PriceRecurring tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceRecurring testing"<>$SessionUUID],
					Object[Bill, "A test bill object 2 (no data price rate) for PriceRecurring testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];



(* ::Subsection::Closed:: *)
(*PriceExperiment*)

DefineTests[
	PriceExperiment,
	{

		(* ----------- *)
		(* -- Basic -- *)
		(* ----------- *)

		Example[{Basic, "Displays the pricing information for a protocol as a table:"},
			PriceExperiment[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceExperiment[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceExperiment[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceExperiment[Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceExperiment[
				Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			DeleteDuplicates[Lookup[outputAssociation, Source]],
			{
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID]],
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID]],
				ObjectReferenceP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* ---------------- *)
		(* -- Additional -- *)
		(* ---------------- *)

		Example[{Additional, "If a protocol has been refunded, include it, but zero out the pricing for it:"},
			outputAssociation=PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			DeleteDuplicates[Lookup[outputAssociation, Source]],
			{
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID]],
				ObjectReferenceP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectReferenceP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceExperiment[
				Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			DeleteDuplicates[Lookup[outputAssociation, Source]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -------------- *)
		(* -- Messages -- *)
		(* -------------- *)

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceExperiment is called on a subprotocol:"},
			PriceExperiment[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceExperiment::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceExperiment is called on a protocol that is not Completed:"},
			PriceExperiment[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceExperiment::ProtocolNotCompleted}
		],
		Example[{Messages, "MissingPricingLevel", "Throw a soft message if the PricingRate is not populated for some instruments or waste:"},
			PriceExperiment[{
				Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
			}],
			_Pane,
			Messages :> {Pricing::NoPricingInfo,PriceInstrumentTime::MissingPricingLevel},
			SetUp :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID], Objects]
				]
			},
			TearDown :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Null
				]
			}
		],

		(* ------------- *)
		(* -- Options -- *)
		(* ------------- *)

		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching ExperimentPriceTableP:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{ExperimentPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the cost of every instrument:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Protocol groups all items by Protocol and sums their prices in the output table:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				Consolidation -> Source
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> PricingCategory groups all items by PricingCategory object and sums their prices in the output table:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				Consolidation -> PricingCategory
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				Consolidation -> Source,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching ExperimentPriceTableP:"},
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				Consolidation -> Source,
				OutputFormat -> Association
			],
			{ExperimentPriceTableP..}
		],

		(* ----------- *)
		(* -- Tests -- *)
		(* ----------- *)


		Test["If PricingRate is not populated for some instruments or waste, still return the correct total price if OutputFormat -> TotalPrice:",
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD],
			Messages :> {Pricing::NoPricingInfo,PriceInstrumentTime::MissingPricingLevel},
			SetUp :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID], Objects]
				]
			},
			TearDown :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Transfer[Notebook] -> Null
				]
			}
		],
		Test["If no priceable events have occurred and OutputFormat -> Table, return only the experiment fee information:",
			PriceExperiment[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID], OutputFormat -> Table],
			_Pane
		],
		Test["If no priceable events have occurred and OutputFormat -> Association, return only the association for the experiment fee:",
			PriceExperiment[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID], OutputFormat -> Association],
			{ExperimentPriceTableP}
		],
		Test["If no priceable events have occurred and OutputFormat -> TotalPrice, return only the experiment fee:",
			PriceExperiment[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID], OutputFormat -> TotalPrice],
			Quantity[60.00, "USDollars"],
			EquivalenceFunction -> Equal
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceExperiment[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceExperiment[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceExperiment[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			]
		],
		Test["If the protocol is a priority protocol, then the total price should update appropriately:",
		PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			PriceExperiment[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			SetUp :> {
				Upload[
					Association[
						Object -> Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
						Priority -> True
					]
				]
			},
			TearDown :> {
				Upload@Association[
					Object -> Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Priority -> Null
				]
			}
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			Round[PriceExperiment[
				Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			], 0.1 USD],
			RangeP[Quantity[270.30, "USDollars"], Quantity[270.50, "USDollars"]]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceExperiment[Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID]]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			Lookup[
				PriceExperiment[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID], Span[Now - 2 * Day, Now - 1 Day], OutputFormat -> Association],
				Source,
				{}
			],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceExperiment[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID]]
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceExperiment[Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID]],
				ObjectP[Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID]]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
				Model[Pricing, "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceExperiment tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID],
				Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID],
				Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
				Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID],
				Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
				Object[User, Emerald, Operator, "Test Operator 2 for PriceExperiment test"<>$SessionUUID],
				Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID],
				Model[User, Emerald, Operator, "Test Operator Model 2 for PriceExperiment test"<>$SessionUUID],
				Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 2 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 3 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 4 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 5 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 6 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 7 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 2 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 3 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 4 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 5 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 6 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 7 for PriceExperiment tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceExperiment testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceExperiment"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model 2 for PriceExperiment test (reusable)"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model 3 for PriceExperiment test (not reusable)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 3 for PriceExperiment test (dishwash)"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 4 for PriceExperiment test (not reusable)"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 6 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 3 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 4 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 5 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 7 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 2 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource for PriceExperiment Tests (not washable)"<>$SessionUUID],

				Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceExperiment test 2 (private)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID],

				Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 2 (private)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 5 (public)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 6 (no model)"<>$SessionUUID],

				Object[Product, "Test Product for PriceExperiment test (public)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test 2 (private)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test 3 (kit)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test 5 (deprecated)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test 6 (public)"<>$SessionUUID],

				Object[Resource, Sample, "Test Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 2 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 3 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 4 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 5 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 6 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 7 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 8 for PriceExperiment tests"<>$SessionUUID],

				Object[Resource, Waste, "A test waste resource 1 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 2 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 3 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 4 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 5 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 6 for PriceExperiment testing"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 7 for PriceExperiment testing"<>$SessionUUID],

				Object[Sample, "Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Sample, "Test Sample 2 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Sample, "Test Sample 3 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Sample, "Test Sample 4 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID],
				Object[Product, "Test product for PriceExperiment unit tests seals"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 1 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 2 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 3 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 4 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 1"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 2"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 3"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 4"<>$SessionUUID]

			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
				Model[Pricing, "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID],
				Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID],
				Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
				Object[User, Emerald, Operator, "Test Operator 2 for PriceExperiment test"<>$SessionUUID],
				Model[User, Emerald, Operator, "Test Operator Model 2 for PriceExperiment test"<>$SessionUUID],
				Object[Resource, Instrument, "Test Instrument Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Operator, "Test Operator Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceExperiment testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceExperiment"<>$SessionUUID],
				Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID],
				Object[Resource, Sample, "Test Container Resource 6 for PriceExperiment tests"<>$SessionUUID],
				Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
				Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
				Object[Product, "Test Product for PriceExperiment test (public)"<>$SessionUUID],
				Object[Resource, Sample, "Test Resource 1 for PriceExperiment tests"<>$SessionUUID],
				Object[Resource, Waste, "A test waste resource 1 for PriceExperiment testing"<>$SessionUUID],
				Object[Sample, "Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID],
				Object[Container, Vessel, "Test Container 1 for FPLC in PriceExperiment test"<>$SessionUUID],
				Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 1"<>$SessionUUID]

			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},

	(* ------------------ *)
	(* -- SYMBOL SETUP -- *)
	(* ------------------ *)

	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator 2 for PriceExperiment test"<>$SessionUUID],
					Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model 2 for PriceExperiment test"<>$SessionUUID],
					Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 1 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 3 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 4 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 5 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 6 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Operator, "Test Operator Resource 7 for PriceExperiment tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceExperiment testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceExperiment"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 2 for PriceExperiment test (reusable)"<>$SessionUUID],
					Model[Container, Vessel, "Test Container Model 3 for PriceExperiment test (not reusable)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for PriceExperiment test (dishwash)"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for PriceExperiment test (not reusable)"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 6 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 3 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 4 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 5 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 7 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 1 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Container Resource for PriceExperiment Tests (not washable)"<>$SessionUUID],

					Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceExperiment test 2 (private)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
					Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID],

					Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceExperiment test 2 (private)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceExperiment test 5 (public)"<>$SessionUUID],
					Object[Sample, "Test Sample for PriceExperiment test 6 (no model)"<>$SessionUUID],

					Object[Product, "Test Product for PriceExperiment test (public)"<>$SessionUUID],
					Object[Product, "Test Product a for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product b for PriceStocking test (public)"<>$SessionUUID],
					Object[Product, "Test Product for PriceExperiment test 2 (private)"<>$SessionUUID],
					Object[Product, "Test Product for PriceExperiment test 3 (kit)"<>$SessionUUID],
					Object[Product, "Test Product for PriceExperiment test 4 (not stocked)"<>$SessionUUID],
					Object[Product, "Test Product for PriceExperiment test 5 (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5a (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceStocking test 5b (deprecated)"<>$SessionUUID],
					Object[Product, "Test Product for PriceExperiment test 6 (public)"<>$SessionUUID],

					Object[Resource, Sample, "Test Resource 1 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 3 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 4 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 5 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 6 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 7 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Sample, "Test Resource 8 for PriceExperiment tests"<>$SessionUUID],

					Object[Resource, Waste, "A test waste resource 1 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 2 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 3 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 4 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 5 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 6 for PriceExperiment testing"<>$SessionUUID],
					Object[Resource, Waste, "A test waste resource 7 for PriceExperiment testing"<>$SessionUUID],

					Object[Sample, "Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Sample, "Test Sample 2 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Sample, "Test Sample 3 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Sample, "Test Sample 4 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID],
					Object[Product, "Test product for PriceExperiment unit tests seals"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 1 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 2 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 3 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Container, Vessel, "Test Container 4 for FPLC in PriceExperiment test"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 1"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 2"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 3"<>$SessionUUID],
					Object[Resource, Sample, "Fake sample resource for PriceExperiment FPLC unit test 4"<>$SessionUUID]

				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID, fplcModelID, operatorModelID, operatorModelID2, containerID, containerID2, containerID3,
			sampleID1, sampleID2, sampleID3, sampleID4, sampleID5,productID1, productID1a, productID1b, productID2, productID3, productID4,
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
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID,
					PricingPlanName -> "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID,
					Site->Link[$Site],
					PlanType -> AlaCarte,
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
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
					IncludedPriorityProtocols -> 2,
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceExperiment tests"<>$SessionUUID
				|>,
				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Null,
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID,
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
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Name -> "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[Model[Instrument, FPLC, "AKTA avant 25"], Objects],
					Name -> "Test FPLC instrument for PriceExperiment test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, Sonicator],
					Model -> Link[Model[Instrument, Sonicator, "Branson MH 5800"], Objects],
					Name -> "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Object -> fplcModelID,
					Type -> Model[Instrument, FPLC],
					Name -> "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, FPLC],
					Model -> Link[fplcModelID, Objects],
					Name -> "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID,
					DeveloperObject -> True
				|>,
				Association[
					Object -> operatorModelID,
					QualificationLevel -> 2,
					Name -> "Test Operator Model for PriceExperiment test"<>$SessionUUID
				],
				Association[
					Object -> operatorModelID2,
					QualificationLevel -> 3,
					Name -> "Test Operator Model 2 for PriceExperiment test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID, Objects],
					Name -> "Test Operator for PriceExperiment test"<>$SessionUUID
				],
				Association[
					Type -> Object[User, Emerald, Operator],
					Model -> Link[operatorModelID2, Objects],
					Name -> "Test Operator 2 for PriceExperiment test"<>$SessionUUID
				],
				Association[
					Object -> containerID,
					Sterile -> True,
					Reusability -> True,
					CleaningMethod -> Handwash,
					Name -> "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID
				],
				Association[
					Object -> containerID2,
					Sterile -> False,
					Reusability -> True,
					CleaningMethod -> DishwashPlastic,
					Name -> "Test Container Model 2 for PriceExperiment test (reusable)"<>$SessionUUID
				],
				Association[
					Object -> containerID3,
					Sterile -> False,
					Reusability -> False,
					CleaningMethod -> Null,
					Name -> "Test Container Model 3 for PriceExperiment test (not reusable)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID, Objects],
					Reusable -> True,
					Name -> "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID2, Objects],
					Reusable -> True,
					Name -> "Test Container 3 for PriceExperiment test (dishwash)"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[containerID3, Objects],
					Reusable -> False,
					Name -> "Test Container 4 for PriceExperiment test (not reusable)"<>$SessionUUID
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
					Name -> "Test Product for PriceExperiment test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1a,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product a for PriceExperiment test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID1b,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product b for PriceExperiment test (public)"<>$SessionUUID
				],
				Association[
					Object -> productID6,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> Low,
					Deprecated -> False,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceExperiment test 6 (public)"<>$SessionUUID
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
					Name -> "Test Product for PriceExperiment test 2 (private)"<>$SessionUUID
				],
				(* public kit sample *)
				Association[
					Object -> productID3,
					Notebook -> Null,
					Stocked -> True,
					UsageFrequency -> VeryHigh,
					Deprecated -> False,
					NotForSale -> False,
					Name -> "Test Product for PriceExperiment test 3 (kit)"<>$SessionUUID
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
					Name -> "Test Product for PriceExperiment test 4 (not stocked)"<>$SessionUUID
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
					Name -> "Test Product for PriceExperiment test 5 (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5a,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceExperiment test 5a (deprecated)"<>$SessionUUID
				],
				Association[
					Object -> productID5b,
					Notebook -> Null,
					Stocked -> False,
					UsageFrequency -> Low,
					Deprecated -> True,
					NotForSale -> False,
					Replace[KitComponents] -> Null,
					Name -> "Test Product for PriceExperiment test 5b (deprecated)"<>$SessionUUID
				],

				(* -- Model[Sample] uploads -- *)

				(* public normal sample *)
				Association[
					Object -> sampleID1,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1, ProductModel], Link[productID5, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID
				],
				(* private normal sample *)
				Association[
					Object -> sampleID2,
					Notebook -> Link[objectNotebookID, Objects],
					Replace[Products] -> {Link[productID2, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceExperiment test 2 (private)"<>$SessionUUID
				],
				(* public kit sample *)
				Association[
					Object -> sampleID3,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1a, ProductModel], Link[productID5a, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID
				],
				(* public sample, not stocked *)
				Association[
					Object -> sampleID4,
					Notebook -> Null,
					Replace[Products] -> {Link[productID1b, ProductModel], Link[productID5b, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Name -> "Test Model Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID
				],
				(* second public sample, different storage condition *)
				Association[
					Object -> sampleID5,
					Notebook -> Null,
					Replace[Products] -> {Link[productID6, ProductModel]},
					Replace[KitProducts] -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Freezer"]],
					Name -> "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID
				],

				(* -- Object Upload -- *)
				(* public, normal sample *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID1, Objects],
					Name -> "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID
				],
				(*private sample, still has a model*)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID2, Objects],
					Name -> "Test Sample for PriceExperiment test 2 (private)"<>$SessionUUID
				],
				(* public, part of a kit *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID3, Objects],
					Name -> "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID
				],
				(* public, not stocked *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID4, Objects],
					Name -> "Test Sample for PriceExperiment test 4 (not stocked)"<>$SessionUUID
				],
				(* public, deprecated *)
				Association[
					Type -> Object[Sample],
					Model -> Link[sampleID5, Objects],
					Name -> "Test Sample for PriceExperiment test 5 (public)"<>$SessionUUID
				],
				(* public, no model *)
				Association[
					Type -> Object[Sample],
					Model -> Null,
					Name -> "Test Sample for PriceExperiment test 6 (no model)"<>$SessionUUID
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
					Name -> "Test product for PriceExperiment unit tests salt"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for PriceExperiment unit tests salt"<>$SessionUUID
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
					Name -> "Test product for PriceExperiment unit tests seals"<>$SessionUUID,
					Replace[Synonyms] -> {
						"Test product for PriceExperiment unit tests seals"<>$SessionUUID
					}
				|>,
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 1 for FPLC in PriceExperiment test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 2 for FPLC in PriceExperiment test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 3 for FPLC in PriceExperiment test"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test Container 4 for FPLC in PriceExperiment test"<>$SessionUUID
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
					Model[Sample, "Sodium Acetate, LCMS grade"]
				},
				{
					{"A1", Object[Container, Vessel, "Test Container 1 for FPLC in PriceExperiment test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 2 for FPLC in PriceExperiment test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 3 for FPLC in PriceExperiment test"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Test Container 4 for FPLC in PriceExperiment test"<>$SessionUUID]}
				},
				ECL`InternalUpload`InitialAmount -> {
					2.1 Gram,
					2.1 Gram,
					2.1 Gram,
					2.1 Gram
				},
				Name -> {
					"Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID,
					"Test Sample 2 for FPLC in PriceExperiment test"<>$SessionUUID,
					"Test Sample 3 for FPLC in PriceExperiment test"<>$SessionUUID,
					"Test Sample 4 for FPLC in PriceExperiment test"<>$SessionUUID
				}
			];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceExperiment testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceExperiment"<>$SessionUUID
				|>,
				<|
					Object -> Object[Sample, "Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 2 for FPLC in PriceExperiment test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 3 for FPLC in PriceExperiment test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID], Samples]
				|>,
				<|
					Object -> Object[Sample, "Test Sample 4 for FPLC in PriceExperiment test"<>$SessionUUID],
					Product -> Link[Object[Product, "Test product for PriceExperiment unit tests salt"<>$SessionUUID], Samples]
				|>,

				(*Instrument Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 1 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 2 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 3 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 4 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"]]
					},
					RequestedInstrument -> Link[Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, Sonicator, "Branson MH 5800"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 5 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 6 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[3.859166666666667, "Hours"],
					Instrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID]],
					Replace[InstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"]]
					},
					RequestedInstrument -> Link[Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID], RequestedResources],
					Replace[RequestedInstrumentModels] -> {
						Link[Model[Instrument, FPLC, "AKTA avant 25"], RequestedResources]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Instrument],
					DeveloperObject -> False,
					Name -> "Test Instrument Resource 7 for PriceExperiment tests"<>$SessionUUID
				|>,

				(*Operator Resources*)

				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 6 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 3 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 4 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 5 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[5, "Hours"],
					EstimatedTime -> Quantity[4, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 7 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 1 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Time -> Quantity[2.5, "Hours"],
					EstimatedTime -> Quantity[2, "Hours"],
					Operator -> Link[Object[User, Emerald, Operator, "Test Operator 2 for PriceExperiment test"<>$SessionUUID]],
					Replace[RequestedOperators] -> {
						Link[Model[User, Emerald, Operator, "Test Operator Model 2 for PriceExperiment test"<>$SessionUUID]]
					},
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Operator],
					DeveloperObject -> False,
					Name -> "Test Operator Resource 2 for PriceExperiment tests"<>$SessionUUID
				|>,

				(*cleaned container resources*)
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 6 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 3 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 4 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 5 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 7 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model for PriceExperiment test (reusable, sterile)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 1 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 2 for PriceExperiment test (reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 2 for PriceExperiment test (reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 2 for PriceExperiment test (dishwash, autoclave)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource 2 for PriceExperiment tests"<>$SessionUUID
				|>,
				<|
					Replace[RequestedModels] -> {
						Link[Model[Container, Vessel, "Test Container Model 3 for PriceExperiment test (not reusable)"<>$SessionUUID], RequestedResources]
					},
					Replace[Models] -> Link[Model[Container, Vessel, "Test Container Model 3 for PriceExperiment test (not reusable)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Container, Vessel, "Test Container 4 for PriceExperiment test (not reusable)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Container, Vessel, "Test Container 4 for PriceExperiment test (not reusable)"<>$SessionUUID]],

					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Container Resource for PriceExperiment Tests (not washable)"<>$SessionUUID
				|>,

				(*stocking resources*)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Amount -> 1 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 6 for PriceExperiment tests"<>$SessionUUID
				],
				(* normal resource - the protocol was refunded so it shouldnt get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Amount -> 1000 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 3 for PriceExperiment tests"<>$SessionUUID
				],
				(* normal resource for the subprotocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 1 (public)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 4 for PriceExperiment tests"<>$SessionUUID
				],
				(* kit resource for an incomplete protocol (should not get counted) *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID]],
					Amount -> 20 Microliter,

					Replace[Requestor] -> {Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 5 for PriceExperiment tests"<>$SessionUUID
				],
				(* second public sample which should also get counted *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 5 (public)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 5 (public)"<>$SessionUUID]],
					Amount -> 40 Milliliter,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 7 for PriceExperiment tests"<>$SessionUUID
				],
				(* private sample that should not get counted in teh parent protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 2 (private)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 2 (private)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 2 (private)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 2 (private)"<>$SessionUUID]],
					Amount -> 100 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 1 for PriceExperiment tests"<>$SessionUUID
				],
				(* public sample without a model which should not get stocked - this should be VOQ'd out *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 5 (public)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 6 (no model)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 6 (no model)"<>$SessionUUID]],
					Amount -> 10 Milligram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 2 for PriceExperiment tests"<>$SessionUUID
				],
				(* kit resource for the top level protocol *)
				Association[
					Replace[RequestedModels] -> {Link[Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID], RequestedResources]},
					Replace[Models] -> Link[Model[Sample, "Test Model Sample for PriceExperiment test 3 (kit)"<>$SessionUUID]],
					Replace[RequestedSample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID], RequestedResources],
					Replace[Sample] -> Link[Object[Sample, "Test Sample for PriceExperiment test 3 (kit)"<>$SessionUUID]],
					Amount -> 30 Gram,

					Replace[Requestor] -> {Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Test Resource 8 for PriceExperiment tests"<>$SessionUUID
				],

				<|
					Amount -> 1 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 1 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 2 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 3 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 2 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 4 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Chemical,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 5 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 3 Kilogram,
					WasteType -> Biohazard,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Cell culture waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 6 for PriceExperiment testing"<>$SessionUUID
				|>,
				<|
					Amount -> 1 Kilogram,
					WasteType -> Sharps,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID], RequiredResources, 1]
					},
					WasteDescription -> "Buffer Waste",
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID], SubprotocolRequiredResources],
					Status -> Fulfilled,
					Type -> Object[Resource, Waste],
					DeveloperObject -> False,
					Name -> "A test waste resource 7 for PriceExperiment testing"<>$SessionUUID
				|>,

				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 1 for FPLC in PriceExperiment test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for PriceExperiment FPLC unit test 1"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 2 for FPLC in PriceExperiment test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for PriceExperiment FPLC unit test 2"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 3 for FPLC in PriceExperiment test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for PriceExperiment FPLC unit test 3"<>$SessionUUID
				|>,
				<|
					Amount -> Quantity[2.1, "Grams"],
					Purchase -> True,
					Replace[Requestor] -> {
						Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], RequiredResources, 1]
					},
					RootProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID], SubprotocolRequiredResources],
					Sample -> Link[Object[Sample, "Test Sample 4 for FPLC in PriceExperiment test"<>$SessionUUID]],
					Replace[Models] -> {Link[Model[Sample, "Sodium Acetate, LCMS grade"]]},
					Status -> Fulfilled,
					Type -> Object[Resource, Sample],
					DeveloperObject -> False,
					Name -> "Fake sample resource for PriceExperiment FPLC unit test 4"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceExperiment testing"<>$SessionUUID],
					Model[Pricing, "A test ala carte pricing scheme for PriceExperiment testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceExperiment tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceExperiment test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 3 in PriceExperiment test (with instrument sans PricingLevel)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceExperiment test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceExperiment test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceExperiment test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceExperiment test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceExperiment test (no instrument used)"<>$SessionUUID],
					Object[Instrument, FPLC, "Test FPLC instrument for PriceExperiment test"<>$SessionUUID],
					Object[Instrument, FPLC, "Fake Object FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
					Object[Instrument, Sonicator, "Test Sonicator instrument for PriceExperiment test"<>$SessionUUID],
					Model[Instrument, FPLC, "Fake Model FPLC with no PricingLevel for PriceExperiment unit tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 1 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 2 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 3 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 4 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 5 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 6 for PriceExperiment tests"<>$SessionUUID],
					Object[Resource, Instrument, "Test Instrument Resource 7 for PriceExperiment tests"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceExperiment testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceExperiment"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];



(* ::Subsection::Closed:: *)
(*PriceProtocol*)

DefineTests[
	PriceProtocol,
	{

		(* ----------- *)
		(* -- Basic -- *)
		(* ----------- *)


		Example[{Basic, "Displays the pricing information for experiment fees as a table:"},
			PriceProtocol[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for a list of protocols as one large table:"},
			PriceProtocol[{Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID], Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]}],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given notebook:"},
			PriceProtocol[Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Displays the pricing information for all protocols tied to a given financing team:"},
			PriceProtocol[Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Specifying a date span excludes protocols that fall outside that range:"},
			outputAssociation=PriceProtocol[
				Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
				Span[Now - 1.5 Week, Now],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* ---------------- *)
		(* -- Additional -- *)
		(* ---------------- *)


		Example[{Additional, "If a protocol has been refunded, include it in the pricing to reflect the refunded price:"},
			outputAssociation=PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -- Time Span -- *)
		Example[{Additional, "Date span can go in either order:"},
			outputAssociation=PriceProtocol[
				Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
				Span[Now, Now - 2.5 Week],
				OutputFormat -> Association
			];
			Lookup[outputAssociation, Source],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			},
			Variables :> {outputAssociation}
		],

		(* -------------- *)
		(* -- Messages -- *)
		(* -------------- *)

		Example[{Messages, "ParentProtocolRequired", "Throws an error if PriceProtocol is called on a subprotocol:"},
			PriceProtocol[Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceProtocol test (subprotocol)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceProtocol::ParentProtocolRequired}
		],
		Example[{Messages, "ProtocolNotCompleted", "Throws an error if PriceProtocol is called on a protocol that is not Completed:"},
			PriceProtocol[Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceProtocol test (incomplete)"<>$SessionUUID]],
			$Failed,
			Messages :> {PriceProtocol::ProtocolNotCompleted}
		],


		(* ------------- *)
		(* -- Options -- *)
		(* ------------- *)

		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations matching ProtocolPriceTableP:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				OutputFormat -> Association
			],
			{ProtocolPriceTableP..}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TotalPrice, returns a single price summing the washing/autoclave cost for all objects:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Notebook groups all items by Notebook and sums their prices in the output table:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID]
				},
				Consolidation -> Notebook
			],
			_Pane
		],
		Example[{Options, Consolidation, "Specifying Consolidation -> Priority groups all items by their Priority status and sums their prices in the output table:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				Consolidation -> Priority
			],
			_Pane
		],
		Example[{Options, Consolidation, "If OutputFormat -> TotalPrice is specified, this overrides the Consolidation option and returns the total summed price:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				Consolidation -> Priority,
				OutputFormat -> TotalPrice
			],
			UnitsP[USD]
		],
		Example[{Options, Consolidation, "If OutputFormat -> Association is specified, this overrides the Consolidation option and returns a list of associations matching ProtocolPriceTableP:"},
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]
				},
				Consolidation -> Notebook,
				OutputFormat -> Association
			],
			{ProtocolPriceTableP..}
		],

		(* -- Tests -- *)

		Test["If given an empty list, returns an empty list for OutputFormat -> Table:",
			PriceProtocol[{}, OutputFormat -> Table],
			{}
		],
		Test["If given an empty list, returns an empty list for OutputFormat -> Association:",
			PriceProtocol[{}, OutputFormat -> Association],
			{}
		],
		Test["If given an empty list, returns $0.00 if OutputFormat -> TotalPrice:",
			PriceProtocol[{}, OutputFormat -> TotalPrice],
			0 * USD,
			EquivalenceFunction -> Equal
		],
		Test["If a protocol has been refunded, do not include it in the pricing:",
			PriceProtocol[
				{
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]
				},
				OutputFormat -> TotalPrice
			],
			Quantity[100.00, "USDollars"]
		],
		Test["Specifying the date range excludes protocols that fall outside that range:",
			PriceProtocol[
				Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
				Span[Now - 1.5Week, Now],
				OutputFormat -> TotalPrice
			],
			Quantity[300.00, "USDollars"]
		],
		Test["If a date range is not specified, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceProtocol[Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			}
		],
		Test["If a date range is specified for a Notebook and no protocol falls in its range, then return {}:",
			DeleteDuplicates[Lookup[
				PriceProtocol[Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID], Span[Now - 1 * Day, Now], OutputFormat -> Association],
				Source,
				{}
			]],
			{}
		],
		Test["If a date range is specified for a Notebook and get all the protocols that fall in that range:",
			DeleteDuplicates[Lookup[
				PriceProtocol[Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID], Span[Now - 1 * Week, Now - 4 * Week], OutputFormat -> Association],
				Source,
				{}
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			}
		],
		Test["If a date range is not specified for a Notebook, then get all the protocols within the last month:",
			DeleteDuplicates[Lookup[
				PriceProtocol[Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID], OutputFormat -> Association],
				Source
			]],
			{
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID]],
				ObjectP[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID]],
				ObjectP[Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID]]
			}
		],
		Test["Objects for the test exist in the database:",
			Download[{
				Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook 2 for PriceProtocol tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceProtocol test (subprotocol)"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceProtocol test (incomplete)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceProtocol test (no containers used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceProtocol testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceProtocol"<>$SessionUUID]
			}, Object],
			ListableP[ObjectReferenceP[]]
		],
		Test["Full packets for the test objects are fine:",
			{Download[{
				Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
				Model[Pricing, "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID],
				Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
				Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID],
				Object[Protocol, SampleManipulation, "Test SM Protocol for PriceProtocol test (no containers used)"<>$SessionUUID],
				Object[Bill, "A test bill object for PriceProtocol testing"<>$SessionUUID],
				Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceProtocol"<>$SessionUUID]
			}, Packet[All]], Now},
			{ListableP[PacketP[]], _}
		]
	},


	(* ------------ *)
	(* -- Set Up -- *)
	(* ------------ *)


	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceProtocol tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceProtocol test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceProtocol test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceProtocol test (no containers used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceProtocol testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceProtocol"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{firstSet, financingTeamID, modelPricingID1, secondUploadList, syncBillingResult, objectNotebookID, objectNotebookID2,
			newBillObject, fplcProtocolID},

			(* create iDs for model uploads *)
			modelPricingID1=CreateID[Model[Pricing]];
			financingTeamID=CreateID[Object[Team, Financing]];
			objectNotebookID=CreateID[Object[LaboratoryNotebook]];
			objectNotebookID2=CreateID[Object[LaboratoryNotebook]];
			fplcProtocolID=CreateID[Object[Protocol, FPLC]];

			(* models and bill uploads *)
			firstSet=List[

				(* financing team *)
				<|
					Object -> financingTeamID,
					MaxThreads -> 5,
					MaxUsers -> 2,
					NumberOfUsers -> 2,
					Status -> Active,
					Type -> Object[Team, Financing],
					DeveloperObject -> False,
					NextBillingCycle -> Now - 1 * Day,
					Replace[CurrentPriceSchemes] ->{Link[modelPricingID1],Link[$Site]},
					Name -> "A test financing team object for PriceProtocol testing"<>$SessionUUID
				|>,

				(* pricing model *)
				<|
					Object -> modelPricingID1,
					Type -> Model[Pricing],
					Name -> "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID,
					PricingPlanName -> "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID,
					PlanType -> Subscription,
					Site->Link[$Site],
					CommitmentLength -> 12 Month,
					NumberOfBaselineUsers -> 10,
					CommandCenterPrice -> 1000 USD,
					ConstellationPrice -> 500 USD / (1000000 Unit),
					NumberOfThreads -> 10,
					LabAccessFee -> 15000USD,
					PricePerExperiment -> 100 USD,
					PricePerPriorityExperiment -> 200 USD,
					Replace[OperatorTimePrice] -> {
						{1, 10 USD / Hour},
						{2, 20 USD / Hour},
						{3, 30 USD / Hour},
						{4, 40 USD / Hour}
					},
					Replace[InstrumentPricing] -> {
						{1, 1 USD / Hour},
						{2, 5 USD / Hour},
						{3, 25 USD / Hour},
						{4, 75 USD / Hour}
					},
					Replace[CleanUpPricing] -> {
						{"Dishwash glass/plastic bottle", 4 USD},
						{"Dishwash plate seals", 1 USD},
						{"Handwash large labware", 5 USD},
						{"Autoclave sterile labware", 3 USD}
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
					IncludedInstrumentHours -> 300 Hour,
					IncludedCleanings -> 90,
					IncludedStockingFees -> 450 USD,
					IncludedWasteDisposalFees -> 52.5 USD,
					IncludedStorage -> 60 Kilo * Centimeter^3,
					IncludedShipmentFees -> 300 * USD,
					PrivateTutoringFee -> 0 USD
				|>,

				(* notebook *)
				<|
					Object -> objectNotebookID,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook for PriceProtocol tests"<>$SessionUUID
				|>,
				<|
					Object -> objectNotebookID2,
					Replace[Financers] -> {
						Link[financingTeamID, NotebooksFinanced]
					},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> False,
					Name -> "Test lab notebook 2 for PriceProtocol tests"<>$SessionUUID
				|>,

				(* protocols *)

				Association[
					Object -> fplcProtocolID,
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID,
					DateCompleted -> Now - 2 Day,
					Status -> Completed,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, FPLC],
					Name -> "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Completed,
					(*we don't give a notebook, so that majority of tests will pass. will give the notebook for the relevant UTs*)
					Transfer[Notebook] -> Link[objectNotebookID2, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID,
					DateCompleted -> Now - 1 Week,
					Status -> Completed,
					Priority -> True,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 2 in PriceProtocol test (subprotocol)"<>$SessionUUID,
					DateCompleted -> Now - 2 Week,
					Status -> Completed,
					ParentProtocol -> Link[fplcProtocolID, Subprotocols],
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Type -> Object[Protocol, Incubate],
					Name -> "Test Incubate Protocol 3 in PriceProtocol test (incomplete)"<>$SessionUUID,
					DateCompleted -> Now,
					Status -> Processing,
					Transfer[Notebook] -> Link[objectNotebookID, Objects],
					Site -> Link[$Site]
				],
				Association[
					Site -> Link[$Site],
					Status -> Completed,
					Type -> Object[Protocol, SampleManipulation],
					DeveloperObject -> False,
					Name -> "Test SM Protocol for PriceProtocol test (no containers used)"<>$SessionUUID,
					Transfer[Notebook] -> Link[objectNotebookID, Objects]
				]
			];

			(*upload the first set of stuff*)
			Upload[firstSet];

			(*run sync billing in order to generate the object[bill]*)
			syncBillingResult=Quiet[
				SyncBilling[Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID]],
				PriceData::MissingBill
			];

			(*get the newly created Bill*)
			newBillObject=FirstCase[syncBillingResult, ObjectP[Object[Bill]]];

			(*now make the second set of stuff*)
			secondUploadList=List[
				<|
					Object -> newBillObject,
					Name -> "A test bill object for PriceProtocol testing"<>$SessionUUID,
					DateStarted -> Now - 1 Month
				|>,
				<|
					AffectedProtocol -> Link[Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID], UserCommunications],
					Refund -> True,
					Type -> Object[SupportTicket, UserCommunication],
					DeveloperObject -> False,
					Name -> "Test Troubleshooting Report with Refund for PriceProtocol"<>$SessionUUID
				|>
			];

			Upload[secondUploadList];


		]
	},
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Team, Financing, "A test financing team object for PriceProtocol testing"<>$SessionUUID],
					Model[Pricing, "A test subscription pricing scheme for PriceProtocol testing"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook for PriceProtocol tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test lab notebook 2 for PriceProtocol tests"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol in PriceProtocol test"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 2 in PriceProtocol test (refunded)"<>$SessionUUID],
					Object[Protocol, FPLC, "Test FPLC Protocol 4 in PriceProtocol test (different notebook; same team)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol in PriceProtocol test (priority)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 2 in PriceProtocol test (subprotocol)"<>$SessionUUID],
					Object[Protocol, Incubate, "Test Incubate Protocol 3 in PriceProtocol test (incomplete)"<>$SessionUUID],
					Object[Protocol, SampleManipulation, "Test SM Protocol for PriceProtocol test (no containers used)"<>$SessionUUID],
					Object[Bill, "A test bill object for PriceProtocol testing"<>$SessionUUID],
					Object[SupportTicket, UserCommunication, "Test Troubleshooting Report with Refund for PriceProtocol"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
