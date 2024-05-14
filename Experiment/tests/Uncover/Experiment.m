(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentUncover: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentUncover*)


DefineTests[ExperimentUncover,
	{
		Example[{Basic, "Create a protocol object to uncover a covered container:"},
			ExperimentUncover[
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID]
			],
			ObjectP[Object[Protocol, Uncover]]
		],
		Example[{Basic, "Resolve options to uncover a covered container that's already on a bench:"},
			ExperimentUncover[
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Environment -> ObjectP[Object[Container, Bench, "Bench for ExperimentUncover tests"<>$SessionUUID]]
			}]
		],
		Example[{Basic, "Splits up containers into batches based on their environment and instrument:"},
			Module[{protocol},
				protocol=ExperimentUncover[
					{
						Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID]
					}
				];

				(* Splits up the crimped cap by itself. The crimped cap doesn't need a barcode, 3 of the containers in the second *)
				(* batch need a barcode. *)
				{
					Length /@ Download[
						protocol,
						BatchedUnitOperations[SampleLink]
					],
					Length /@ Download[
						protocol,
						BatchedUnitOperations[BarcodeCoverContainers]
					]
				}
			],
			{
				{1, 3, 1},
				{0, 2, 0}
			}
		],
		Example[{Basic, "Environment resolves to a BSC if SterileTechnique->True:"},
			ExperimentUncover[
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID],
				SterileTechnique -> True,
				Output -> Options
			],
			KeyValuePattern[{
				Environment -> ObjectP[Model[Instrument, BiosafetyCabinet]]
			}]
		],
		Example[{Basic, "Test Robotic version:"},
			ExperimentUncover[
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[]
		],
		Example[{Basic, "For a container with a barcoded cap, the operator will be asked to make sure the cap is stickered and there will be no CapRack resource. For containers with unbarcoded caps, the operator will not be asked to make sure the caps are stickered and a CapRack resource will be generated unless the cap is being discarded:"},
			Download[
				ExperimentUncover[
					{
						Object[Container, Vessel, "50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Vessel, "Covered 2mL Tube 2 for ExperimentUncover Testing"<>$SessionUUID],
						Object[Container, Vessel, "Covered 2mL Tube 3 for ExperimentUncover Testing"<>$SessionUUID]
					},
					DiscardCover->{Automatic,Automatic,True}
				],
				BatchedUnitOperations[{DiscardCover,CapRack,BarcodeCoverContainers}]
			],
			{
				{
					{False,False,True},
					{Null,ObjectP[Model[Container,Rack]],Null},
					{ObjectP[Object[Container,Vessel,"50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID]]}
				}
			}
		],
		Example[{Messages, "ContainerIsAlreadyUncovered", "Cannot uncover a plate if it's already uncovered:"},
			ExperimentUncover[
				{
					Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
					Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::ContainerIsAlreadyUncovered,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DecrimperConflict", "Cannot use a decrimper for a non crimped container:"},
			ExperimentUncover[
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"]
			],
			$Failed,
			Messages :> {
				Error::DecrimperConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiscardCover cannot be set to True if the cover has no product and cannot be replaced:"},
			ExperimentUncover[Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID], DiscardCover -> True],
			$Failed,
			Messages :> {
				Error::UnsafeDiscard,
				Error::InvalidOption
			}
		],
		Test["Resolves DiscardCover->True is UncappedTime is greater than 15 minutes:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID], UncappedTime -> 1 Hour],
				BatchedUnitOperations[DiscardCover]
			],
			{{True}}
		],
		Test["Sets DiscardCover to True when discarding a plate seal:",
			Download[
				ExperimentUncover[Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID]],
				BatchedUnitOperations[DiscardCover]
			],
			{{False}}
		],
		Test["Sets DiscardCover to False if the cover has a barcode:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID]],
				BatchedUnitOperations[DiscardCover]
			],
			{{False}},
			Messages:>{Error::NoActiveCartForCover}
		],
		Test["Sets DiscardCover to False if the cover has no product and cannot be replaced:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID]],
				BatchedUnitOperations[DiscardCover]
			],
			{{False}}
		],
		Test["Uncover two containers of the same Model with the same non-replecable cap model:",
			ExperimentUncover[
				{
					Object[Container, Cuvette, "Cuvette 1 for ExperimentUncover Testing"<>$SessionUUID],
					Object[Container, Cuvette, "Cuvette 2 for ExperimentUncover Testing"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol, Uncover]]
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentUncover[Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID], OptionsResolverOnly -> True, Output -> Options],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentUncover[Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID], OptionsResolverOnly -> True,  Output -> Result],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		]
	},

	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Bench for ExperimentUncover tests"<>$SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 2 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 3 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 2 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 3 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "50mL Tube Degas Cap with Barcode for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Lid, "Universal Black Lid for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Cuvette, "Cuvette 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Cuvette, "Cuvette 2 for ExperimentUncover Testing"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{unitTestBench, unitTestBag, numberOfExtraCovers, newObjects, containersAndCovers, containers, covers, extraCovers, ventilatedSample},

			{unitTestBench, unitTestBag} = Upload[{
				<|
					Type->Object[Container, Bench],
					Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name->"Bench for ExperimentUncover tests"<>$SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container, Bag],
					Model->Link[Model[Container, Bag, "Small inventory bag"], Objects],
					DeveloperObject->True,
					Site -> Link[$Site]
				|>
			}];

			numberOfExtraCovers = 2;

			newObjects = UploadSample[
				{
					(* Extra covers *)
					Model[Item, Cap, "id:L8kPEjn4DkZw"],
					Model[Item, Cap, "Bottle Cap, 46x23mm"],

					(* For crimp test *)
					Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],

					(* For lid test *)
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Item, Lid, "Universal Black Lid"],

					(* For plate seal test *)
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Item, PlateSeal, "Plate Seal, 96-Well Square"],

					(* For Barcode test *)
					Model[Container, Vessel, "100g opaque white plastic rectangular solid bottle"],
					Model[Item, Cap, "Bottle Cap, 46x23mm"],

					(* For no Products test *)
					Model[Container, Vessel, "25mL narrow amber glass bottle"],
					Model[Item, Cap, "Bottle Cap, 38x20mm"],

					(* For with Products test *)
					Model[Container, Vessel, "2mL Tube"],
					Model[Item, Cap, "2 mL tube cap, standard"],

					(* For discard cover test *)
					Model[Container, Vessel, "2mL Tube"],
					Model[Item, Cap, "2 mL tube cap, standard"],

					Model[Container, Vessel, "2mL Tube"],
					Model[Item, Cap, "2 mL tube cap, standard"],

					Model[Container, Vessel, "50mL Tube"],
					Model[Item, Cap, "50mL tube degas cap"],

					(* for multiple entries testing *)
					Model[Container, Cuvette, "Micro Scale Black Walled UV Quartz Cuvette"],
					Model[Item, Cap, "Cuvette Cap, 18x17mm"],
					Model[Container, Cuvette, "Micro Scale Black Walled UV Quartz Cuvette"],
					Model[Item, Cap, "Cuvette Cap, 18x17mm"]
				},
				{
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"A1", unitTestBag},
					{"Work Surface", unitTestBench},
					{"A1", unitTestBag},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench}
				},
				Name->{
					Null,
					Null,
					"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing"<>$SessionUUID,
					"Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing"<>$SessionUUID,
					"Covered DWP for ExperimentUncover Testing"<>$SessionUUID,
					"Universal Black Lid for ExperimentUncover Testing"<>$SessionUUID,
					"Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID,
					Null,
					"Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID,
					Null,
					"Container with productless cap for ExperimentUncover Testing"<>$SessionUUID,
					Null,
					"Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID,
					"2mL Tube Cap 1 for ExperimentUncover Testing"<>$SessionUUID,
					"Covered 2mL Tube 2 for ExperimentUncover Testing"<>$SessionUUID,
					"2mL Tube Cap 2 for ExperimentUncover Testing"<>$SessionUUID,
					"Covered 2mL Tube 3 for ExperimentUncover Testing"<>$SessionUUID,
					"2mL Tube Cap 3 for ExperimentUncover Testing"<>$SessionUUID,
					"50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID,
					"50mL Tube Degas Cap with Barcode for ExperimentUncover Testing"<>$SessionUUID,
					"Cuvette 1 for ExperimentUncover Testing"<>$SessionUUID,
					Null,
					"Cuvette 2 for ExperimentUncover Testing"<>$SessionUUID,
					Null
				}
			];


			(* Add a ventilated sample to one of our container to make sure we resolve fumehood without issue *)
			ventilatedSample = UploadSample[
				Model[Sample, "id:8qZ1VW0JqeED"],
				{"A1", Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID]}
			];

			(* Split our list into the extra covers and the cover-container pair list *)
			{extraCovers, containersAndCovers} = TakeDrop[newObjects, numberOfExtraCovers];

			(* Pull out containers and their covers - every other is a container *)
			containers = containersAndCovers[[1 ;; ;; 2]];
			covers = containersAndCovers[[2 ;; ;; 2]];

			(* Add Cover field to all containers involved *)
			UploadCover[
				containers,
				Cover->covers
			];

			(* Make all the test objects and models developer objects - except extra covers which we want to show up in Search *)
			Upload[<|Object->#, DeveloperObject->True|>&/@Join[containersAndCovers, {ventilatedSample}]]
		];
	),
	SymbolTearDown:>(
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Bench for ExperimentUncover tests"<>$SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 2 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 3 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 2 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 3 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Item, Cap, "50mL Tube Degas Cap with Barcode for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Cuvette, "Cuvette 1 for ExperimentUncover Testing"<>$SessionUUID],
				Object[Container, Cuvette, "Cuvette 2 for ExperimentUncover Testing"<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force->True, Verbose->False]]
		];
	)
];


DefineTests[ExperimentUncoverOptions,
	{
		Example[{Basic,"Display the option values for a protocol object to uncover a covered container:"},
			ExperimentUncoverOptions[
				Object[Container,Vessel,"Covered 2mL Tube for ExperimentUncoverOptions Testing "<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"Display the option values for a covered container that's already on a bench:"},
			ExperimentUncoverOptions[
				Object[Container,Vessel,"Covered 2mL Tube for ExperimentUncoverOptions Testing "<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"Display the option values for a Robotic Uncover version:"},
			ExperimentUncoverOptions[
				Object[Container,Plate,"Covered DWP for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Preparation->Robotic
			],
			_Grid
		]
	},
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ExperimentUncoverOptions tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for ExperimentUncoverOptions Testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{unitTestBench,  newObjects, containersAndCovers, containers, covers, ventilatedSample},

			unitTestBench = Upload[
				<|
					Type->Object[Container, Bench],
					Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name->"Test bench for ExperimentUncoverOptions tests "<>$SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>
			];

			newObjects = ECL`InternalUpload`UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Item, Cap, "2 mL tube cap, standard"]
				},
				{
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench}
				},
				Name->{
					"Covered DWP for ExperimentUncoverOptions Testing "<>$SessionUUID,
					"Universal Black Lid for ExperimentUncoverOptions Testing "<>$SessionUUID,
					"Covered 2mL Tube for ExperimentUncoverOptions Testing "<>$SessionUUID,
					"Covered 2mL Tube Cap Standard on Vial for ExperimentUncoverOptions Testing "<>$SessionUUID
				}
			];

			(* Pull out containers and their covers - every other is a container *)
			containers = newObjects[[1 ;; ;; 2]];
			covers = newObjects[[2 ;; ;; 2]];

			(* Add Cover field to all containers involved *)
			UploadCover[
				containers,
				Cover->covers
			];

		];
	),
	SymbolTearDown:>(
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentUncoverOptions tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for ExperimentUncoverOptions Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for ExperimentUncoverOptions Testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force->True, Verbose->False]]
		];
	)
];


DefineTests[ValidExperimentUncoverQ,
	{
		Example[{Basic,"Display the option values for a protocol object to uncover a covered container:"},
			ValidExperimentUncoverQ[
				Object[Container,Vessel,"Covered 2mL Tube for ValidExperimentUncoverQ Testing "<>$SessionUUID]
			],
			True
		],
		Example[{Basic,"Display the option values for a covered container that's already on a bench:"},
			ValidExperimentUncoverQ[
				Object[Container,Vessel,"Covered 2mL Tube for ValidExperimentUncoverQ Testing "<>$SessionUUID]
			],
			True
		],
		Example[{Basic,"Display the option values for a Robotic Uncover version:"},
			ValidExperimentUncoverQ[
				Object[Container,Plate,"Covered DWP for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Preparation->Robotic
			],
			True
		]
	},
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ValidExperimentUncoverQ tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for ValidExperimentUncoverQ Testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{unitTestBench,  newObjects, containersAndCovers, containers, covers, ventilatedSample},

			unitTestBench = Upload[
				<|
					Type->Object[Container, Bench],
					Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name->"Test bench for ValidExperimentUncoverQ tests "<>$SessionUUID,
					Site -> Link[$Site],
					DeveloperObject->True
				|>
			];

			newObjects = ECL`InternalUpload`UploadSample[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Item, Cap, "2 mL tube cap, standard"]
				},
				{
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench},
					{"Work Surface", unitTestBench}
				},
				Name->{
					"Covered DWP for ValidExperimentUncoverQ Testing "<>$SessionUUID,
					"Universal Black Lid for ValidExperimentUncoverQ Testing "<>$SessionUUID,
					"Covered 2mL Tube for ValidExperimentUncoverQ Testing "<>$SessionUUID,
					"Covered 2mL Tube Cap Standard on Vial for ValidExperimentUncoverQ Testing "<>$SessionUUID
				}
			];

			(* Pull out containers and their covers - every other is a container *)
			containers = newObjects[[1 ;; ;; 2]];
			covers = newObjects[[2 ;; ;; 2]];

			(* Add Cover field to all containers involved *)
			UploadCover[
				containers,
				Cover->covers
			];

		];
	),
	SymbolTearDown:>(
		ClearMemoization[];

		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentUncoverQ tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for ValidExperimentUncoverQ Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for ValidExperimentUncoverQ Testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force->True, Verbose->False]]
		];
	)
];