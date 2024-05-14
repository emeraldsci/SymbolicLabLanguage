DefineTests[SampleUsage,
	{
		(* ---basic examples--- *)
		Example[{Basic, "Display the usage amount for each sample or model object used in the specified manipulations as a Table:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				}
			],
			_Pane
		],

		Example[{Basic, "Display the amount of all samples in your inventory and the public inventory that share the same model as the samples specified in the primitives, and the predicted remaining amount in your inventory if the manipulations were performed:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					],
					Consolidation[
						Sources -> {Object[Sample, "SampleUsage Test Red Dye Sample"], Object[Sample, "SampleUsage Test Water Sample"], Object[Sample, "SampleUsage Test Methanol Sample"]},
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destination -> {Model[Container, Plate, "id:01G6nvkKrrYm"], "C1"}
					]
				},
				InventoryComparison -> True
			],
			_Pane
		],

		Example[{Basic, "Display the usage amount for each sample or model object with defined names used in the specified manipulations as a Table:"},
			SampleUsage[
				{
					Define[
						Name -> "My Water Sample",
						Sample -> Object[Sample, "SampleUsage Test Water Sample"]
					],
					Define[
						Name -> "My Methanol Sample",
						Sample -> Object[Sample, "SampleUsage Test Methanol Sample"]
					],
					Transfer[
						Source -> "My Water Sample",
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> "My Methanol Sample",
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				}
			],
			_Pane
		],

		Example[{Additional, "Display the usage amount for each sample or model object used in the specified manipulations as a list of Associations:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				OutputFormat -> Association
			],
			{_Association..}
		],

		(* ---options--- *)
		Example[{Options, Messages, "If Messages -> False, suppresses the all the messages thrown:"},
			SampleUsage[
				{
					FillToVolume[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						FinalVolume -> 10 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Resuspend[
						Sample -> Object[Sample, "SampleUsage Test Salt Sample"],
						Volume -> 500 * Milliliter
					]
				},
				Messages -> False
			],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Table, displays a table with the usage amount for each sample or model object used in the specified manipulations:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				OutputFormat -> Table
			],
			_Pane
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Association, returns a list of associations of the usage amount for each sample or model object used in the specified manipulations:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				OutputFormat -> Association
			],
			{_Association..}
		],
		Example[{Options, Author, "The amount in the user's inventory is calculated based on the specified Author:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				Author -> Object[User, "Test user for notebook-less test protocols"]
			],
			_Pane
		],
		Example[{Options, InventoryComparison, "If InventoryComparison -> True, returns a table with the usage amount, the amount in the user's inventory, and the amount in the public inventory for all sample objects and models specified in the input primitives:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane
		],

		(* ---messages--- *)
		Example[{Messages, "InvalidPrimitiveType", "Throw a warning message if at least one input primitive with invalid manipulation type is given:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					],
					Mix[
						Sample -> Object[Sample, "SampleUsage Test Water Sample"],
						MixVolume -> 300 * Microliter,
						NumberOfMixes -> 1
					]
				}
			],
			_Pane,
			Messages :> {Warning::InvalidPrimitiveType}
		],
		Example[{Messages, "InvalidPrimitiveKeyValue", "Throw a warning message for any input primitive that contains key(s) with invalid pattern:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> True,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				}
			],
			_Pane,
			Messages :> {Warning::InvalidPrimitiveKeyValue}
		],
		Example[{Messages, "InvalidAmountLength", "Throw a warning message for any input primitive that contains mismatched amount length:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Water Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				}
			],
			_Pane,
			Messages :> {Warning::InvalidAmountLength}
		],
		Example[{Messages, "InvalidNameReference", "Throw a warning message for any object defined in input primitives that does not have a valid defined name:"},
			SampleUsage[
				{
					Define[
						Name -> "My Water Sample",
						Sample -> Object[Sample, "SampleUsage Test Water Sample"]
					],
					Define[
						Name -> "My Methanol Sample",
						Sample -> Object[Sample, "SampleUsage Test Methanol Sample"]
					],
					Transfer[
						Source -> "My Water Sample",
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> "My Salt Sample",
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				}
			],
			_Pane,
			Messages :> {Warning::InvalidNameReference}
		],
		Example[{Messages, "NoValidPrimitives", "Throw an error message and return $Failed if there are no valid primitives to use for usage amount calculation:"},
			SampleUsage[
				Mix[
					Sample -> Object[Sample, "SampleUsage Test Methanol Sample"],
					MixVolume -> 300 Microliter,
					NumberOfMixes -> 1
				]
			],
			$Failed,
			Messages :> {Warning::InvalidPrimitiveType, Error::NoValidPrimitives}
		],
		Example[{Messages, "FillToVolumePrimitiveIncluded", "Throw a warning message indicating that the usage amount displayed may not be accurate for samples used in FillToVolume primitives:"},
			SampleUsage[
				FillToVolume[
					Source -> Object[Sample, "SampleUsage Test Water Sample"],
					FinalVolume -> 10 * Milliliter,
					Destination -> Model[Container, Vessel, "50mL Tube"]
				]
			],
			_Pane,
			Messages :> {Warning::FillToVolumePrimitiveIncluded}
		],
		Example[{Messages, "NoValidObjectsToUse", "Throw an error message and return $Failed if there are no valid objects to use for usage amount calculation:"},
			SampleUsage[
				Define[
					Name -> "My Plate",
					Container -> Model[Container, Plate, "96-well PCR Plate"]
				]
			],
			$Failed,
			Messages :> {Error::NoValidObjectsToUse}
		],
		Example[{Messages, "ExcessDestinationVolume", "Throw a warning message for any FillToVolume primitive with Destination volume that exceeds FinalVolume:"},
			SampleUsage[
				FillToVolume[
					Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
					FinalVolume -> 10 * Milliliter,
					Destination -> Object[Sample, "SampleUsage Test Water Sample"]
				]
			],
			_Pane,
			Messages :> {Warning::FillToVolumePrimitiveIncluded, Warning::ExcessDestinationVolume}
		],
		Example[{Messages, "MissingObjects", "Throw a warning message for any input primitive that contains samples that do not exist in the database:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Missing Object"],
						Amount -> 10 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::MissingObjects}
		],
		Example[{Messages, "SamplesMarkedForDisposal", "Throw a warning message for any input primitive that contains samples marked for disposal:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Sample Marked for Disposal"],
						Amount -> 10 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::SamplesMarkedForDisposal}
		],
		Example[{Messages, "DiscardedSamples", "Throw a warning message for any input primitive that contains discarded samples:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Discarded Sample"],
						Amount -> 10 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::DiscardedSamples}
		],
		Example[{Messages, "ExpiredSamples", "Throw a warning message for any input primitive that contains samples that are expired:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Expired Sample"],
						Amount -> 10 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::ExpiredSamples}
		],
		Example[{Messages, "SamplesWithDeprecatedModels", "Throw a warning message for any input primitive that contains samples that have models that are deprecated:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Sample with Deprecated Model"],
						Amount -> 50 * Microliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::SamplesWithDeprecatedModels}
		],
		Example[{Messages, "DeprecatedSpecifiedModels", "Throw a warning message for any input primitive that contains sample models that are deprecated:"},
			SampleUsage[
				{
					Transfer[
						Source -> Model[Sample, "SampleUsage Test Deprecated Model"],
						Amount -> 50 * Microliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::DeprecatedSpecifiedModels}
		],
		Example[{Messages, "SamplesNotOwned", "Throw a warning message for any input primitive that contains public samples that are not owned buy the user:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Public Sample"],
						Amount -> 300 * Microliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {10 * Microliter, 20 * Microliter, 30 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::SamplesNotOwned}
		],
		Example[{Messages, "InsufficientAmount", "Throw a warning message for any input primitive that contains samples with insufficient amount to undergo all the specified manipulations:"},
			SampleUsage[
				{
					Transfer[
						Source -> Object[Sample, "SampleUsage Test Red Dye Sample"],
						Amount -> 5 * Milliliter,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					],
					Aliquot[
						Source -> Object[Sample, "SampleUsage Test Methanol Sample"],
						Amounts -> {50 * Microliter, 50 * Microliter, 25 * Microliter},
						Destinations -> {{Model[Container, Plate, "id:01G6nvkKrrYm"], "A1"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A2"}, {Model[Container, Plate, "id:01G6nvkKrrYm"], "A3"}}
					]
				},
				InventoryComparison -> True
			],
			_Pane,
			Messages :> {Warning::InsufficientAmount}
		]
	},
	SymbolSetUp :> (
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Sample, "SampleUsage Test Water Sample"],
				Object[Sample, "SampleUsage Test Methanol Sample"],
				Object[Sample, "SampleUsage Test Red Dye Sample"],
				Object[Sample, "SampleUsage Test Salt Sample"],
				Object[Sample, "SampleUsage Test Sample Marked for Disposal"],
				Object[Sample, "SampleUsage Test Discarded Sample"],
				Object[Sample, "SampleUsage Test Expired Sample"],
				Object[Sample, "SampleUsage Test Sample with Deprecated Model"],
				Object[Sample, "SampleUsage Test Public Sample"],
				Object[Container, Plate, "SampleUsage Test Plate 1"],
				Object[Container, Plate, "SampleUsage Test Plate 2"],
				Object[Container, Plate, "SampleUsage Test Plate 3"],
				Object[Container, Vessel, "SampleUsage Test 50mL Tube 1"],
				Object[Container, Vessel, "SampleUsage Test 50mL Tube 2"],
				Object[Container, Vessel, "SampleUsage Test Bottle 1"],
				Object[Container, Vessel, "SampleUsage Test Tube Marked for Disposal"],
				Object[Container, Vessel, "SampleUsage Test Discarded Tube"],
				Object[Container, Vessel, "SampleUsage Test Expired Tube"],
				Model[Sample, "SampleUsage Test Deprecated Model"]
			};
			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];
		Module[
			{
				waterSample, methanolSample, redDyeSample, saltSample, sampleToBeDisposed, discardedSample, expiredSample,
				publicSample, fakePlate1, fakePlate2, fakePlate3, fakeTube1, fakeTube2, fakeBottle, containerToBeDisposed, discardedTube,
				expiredTube, deprecatedModel, samplesWithDeprecatedModel
			},

			(* create fake containers *)
			{
				fakePlate1,
				fakePlate2,
				fakePlate3,
				fakeTube1,
				fakeTube2,
				fakeBottle,
				containerToBeDisposed,
				discardedTube,
				expiredTube,
				deprecatedModel
			}=Upload[{
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "id:01G6nvkKrrYm"], Objects], Name -> "SampleUsage Test Plate 1", DeveloperObject -> True|>,
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "id:01G6nvkKrrYm"], Objects], Name -> "SampleUsage Test Plate 2", DeveloperObject -> True|>,
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "id:01G6nvkKrrYm"], Objects], Name -> "SampleUsage Test Plate 3", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "SampleUsage Test 50mL Tube 1", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "SampleUsage Test 50mL Tube 2", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "SampleUsage Test Bottle 1", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "SampleUsage Test Tube Marked for Disposal", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "SampleUsage Test Discarded Tube", DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "SampleUsage Test Expired Tube", DeveloperObject -> True|>,
				<|Type -> Model[Sample], Name -> "SampleUsage Test Deprecated Model", State -> Liquid, Deprecated -> True, DeveloperObject -> True|>
			}];

			(* create fake samples *)
			{
				waterSample,
				methanolSample,
				redDyeSample,
				saltSample,
				sampleToBeDisposed,
				discardedSample,
				expiredSample,
				samplesWithDeprecatedModel,
				publicSample
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Methanol"],
					Model[Sample, "Red Food Dye"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "SampleUsage Test Deprecated Model"],
					Model[Sample, "Red Food Dye"]
				},
				{
					{"A1", fakeTube1},
					{"A1", fakePlate1},
					{"A1", fakeTube2},
					{"A1", fakeBottle},
					{"A1", containerToBeDisposed},
					{"A1", discardedTube},
					{"A1", expiredTube},
					{"A1", fakePlate2},
					{"A1", fakePlate3}
				},
				InitialAmount -> {
					25 * Milliliter,
					100 * Microliter,
					25 * Milliliter,
					3 * Gram,
					25 * Milliliter,
					25 * Milliliter,
					25 * Milliliter,
					500 * Microliter,
					500 * Microliter
				},
				StorageCondition -> AmbientStorage
			];

			(* secondary upload *)
			Upload[{
				<|Object -> waterSample, Name -> "SampleUsage Test Water Sample", Status -> Available, DeveloperObject -> True, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> methanolSample, Name -> "SampleUsage Test Methanol Sample", Status -> Available, DeveloperObject -> False, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> redDyeSample, Name -> "SampleUsage Test Red Dye Sample", Status -> Available, DeveloperObject -> False, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> saltSample, Name -> "SampleUsage Test Salt Sample", Status -> Available, DeveloperObject -> True, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> sampleToBeDisposed, Name -> "SampleUsage Test Sample Marked for Disposal", Status -> Available, AwaitingDisposal -> True, DeveloperObject -> True, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> discardedSample, Name -> "SampleUsage Test Discarded Sample", Status -> Discarded, DeveloperObject -> True, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> expiredSample, Name -> "SampleUsage Test Expired Sample", Status -> Available, ExpirationDate -> (Now - 1 * Day), DeveloperObject -> True, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> samplesWithDeprecatedModel, Name -> "SampleUsage Test Sample with Deprecated Model", Status -> Available, State -> Liquid, DeveloperObject -> False, Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]|>,
				<|Object -> publicSample, Name -> "SampleUsage Test Public Sample", Status -> Available, DeveloperObject -> False, Transfer[Notebook] -> Null|>
			}];
		];
	),

	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$Notebook=Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"]
	},

	SymbolTearDown :> (
		Module[{namedObjects},
			namedObjects={
				Object[Sample, "SampleUsage Test Water Sample"],
				Object[Sample, "SampleUsage Test Methanol Sample"],
				Object[Sample, "SampleUsage Test Red Dye Sample"],
				Object[Sample, "SampleUsage Test Salt Sample"],
				Object[Sample, "SampleUsage Test Sample Marked for Disposal"],
				Object[Sample, "SampleUsage Test Discarded Sample"],
				Object[Sample, "SampleUsage Test Expired Sample"],
				Object[Sample, "SampleUsage Test Sample with Deprecated Model"],
				Object[Sample, "SampleUsage Test Public Sample"],
				Object[Container, Plate, "SampleUsage Test Plate 1"],
				Object[Container, Plate, "SampleUsage Test Plate 2"],
				Object[Container, Plate, "SampleUsage Test Plate 3"],
				Object[Container, Vessel, "SampleUsage Test 50mL Tube 1"],
				Object[Container, Vessel, "SampleUsage Test 50mL Tube 2"],
				Object[Container, Vessel, "SampleUsage Test Bottle 1"],
				Object[Container, Vessel, "SampleUsage Test Tube Marked for Disposal"],
				Object[Container, Vessel, "SampleUsage Test Discarded Tube"],
				Object[Container, Vessel, "SampleUsage Test Expired Tube"],
				Model[Sample, "SampleUsage Test Deprecated Model"]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	)
];