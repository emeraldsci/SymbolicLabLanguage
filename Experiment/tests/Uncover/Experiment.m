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
		Example[{Basic, "Resolve options to uncover a covered container that's already inside a handling station:"},
			ExperimentUncover[
				Object[Container, Vessel, "Covered 2mL Tube 4 for ExperimentUncover Testing"<>$SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Environment -> ObjectP[Object[Instrument, HandlingStation, Ambient, "Handling Station for ExperimentUncover tests" <> $SessionUUID]]
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
					},
					Instrument -> {
						(* the point of this test is to test different environments; for the manual decrimper we don't need a different environment so I need to explicitly say I want the fancy crimper/decrimper *)
						Model[Instrument, Crimper, "id:P5ZnEjdkMe9O"], (* Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"] *)
						Automatic,
						Automatic,
						Automatic,
						Automatic
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
				Environment -> ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet]]
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
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentUncover[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentUncover[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentUncover[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentUncover[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn, capID, coverPackets},
				containerPackets = UploadSample[
					{
						Model[Container,Vessel,"50mL Tube"],
						Model[Item, Cap, "50 mL tube cap"]
					},
					{
						{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
						{"Work Surface", Object[Container, Bench, "The Bench of Testing"]}
					},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				{containerID, capID} = Lookup[containerPackets[[;;2]], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				coverPackets = UploadCover[containerID, Cover -> capID, Simulation -> simulationToPassIn, Upload -> False];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverPackets]];
				ExperimentUncover[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn, capID, coverPackets},
				containerPackets = UploadSample[
					{
						Model[Container,Vessel,"50mL Tube"],
						Model[Item, Cap, "50 mL tube cap"]
					},
					{
						{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
						{"Work Surface", Object[Container, Bench, "The Bench of Testing"]}
					},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				{containerID, capID} = Lookup[containerPackets[[;;2]], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				coverPackets = UploadCover[containerID, Cover -> capID, Simulation -> simulationToPassIn, Upload -> False];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverPackets]];

				ExperimentUncover[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
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
		Test["Resolves DiscardCover->True if UncappedTime is greater than 15 minutes:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID], UncappedTime -> 1 Hour],
				BatchedUnitOperations[DiscardCover]
			],
			{{True}}
		],
		Test["Resolves DiscardCover->False if the cover is cleanable, even if UncappedTime is greater than 15 minutes:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Covered 2L Glass Bottle 1 for ExperimentUncover Testing" <> $SessionUUID], UncappedTime -> 1 Hour],
				BatchedUnitOperations[DiscardCover]
			],
			{{False}}
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
				ExperimentUncover[
					Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID],
					Environment -> Object[Container, Bench, "Bench for ExperimentUncover tests"<>$SessionUUID]
				],
				BatchedUnitOperations[DiscardCover]
			],
			{{False}}
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
		],
		Test["Uncover a container with an aluminum foil lid:",
			ExperimentUncover[Object[Container, Vessel, "Erlenmeyer flask covered with aluminum foil for ExperimentUncover Testing" <> $SessionUUID]],
			ObjectP[Object[Protocol, Uncover]]
		],
		Test["If uncovering a container that is crimped and we have a matching decrimper for that cap type, then use that:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Crimped 13mm vial for ExperimentUncover Testing" <> $SessionUUID]],
				Instruments
			],
			{ObjectP[Model[Part, Decrimper]]}
		],
		(* this test assumes we don't have a 11mm manual decrimper (which at the time of writing was True; if this changes the test will have to change) *)
		Test["If uncovering a container that is crimped and we do not have a matching decrimper for that cap type, then just use the pneumatic one:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Crimped 11mm vial for ExperimentUncover Testing" <> $SessionUUID]],
				Instruments
			],
			{ObjectP[Model[Instrument, Crimper]]}
		],
		Test["If an ampoule is supplied, an AmpouleOpener is selected for the instrument:",
			Download[
				ExperimentUncover[Object[Container, Vessel, "Ampoule for ExperimentUncover Testing" <> $SessionUUID]],
				Instruments
			],
			{ObjectP[Model[Part, AmpouleOpener]]}
		],
		Test["If uncovering using a decrimper and we already have a decrimper of that model InUse by the root protocol, then resolve the decrimper to that object:",
			Lookup[
				ExperimentUncover[
					Object[Container, Vessel, "Uncovered 6 mL aspiration vial for hand-crimping in ExperimentUncover testing" <> $SessionUUID],
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP parent protocol with Decrimpers still InUse for ExperimentUncover testing" <> $SessionUUID],
					Output -> Options
				],
				Instrument
			],
			ObjectP[Object[Part, Decrimper, "Decrimper for ExperimentUncover Testing" <> $SessionUUID]]
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
			allObjects = {
				Object[Instrument, HandlingStation, Ambient, "Handling Station for ExperimentUncover tests" <> $SessionUUID],
				Object[Container, Bench, "Bench for ExperimentUncover tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 3 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 4 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 3 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 4 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Degas Cap with Barcode for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal Black Lid for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Cuvette, "Cuvette 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Cuvette, "Cuvette 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Erlenmeyer flask covered with aluminum foil for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Lid, "Aluminum foil cover 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Crimped 13mm vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "13mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Crimped 11mm vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "11mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2L Glass Bottle 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "GL45 Bottle Cap 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Ampoule for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "Ampoule cover for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 6 mL aspiration vial for hand-crimping in ExperimentUncover testing" <> $SessionUUID],
				Object[Item, Cap, "20mm vial aspiration cap for ExperimentUncover testing" <> $SessionUUID],
				Object[Part, Decrimper, "Decrimper for ExperimentUncover Testing" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test MSP parent protocol with Decrimpers still InUse for ExperimentUncover testing" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{unitTestBench, unitTestBag, unitTestHandlingStation, numberOfExtraCovers, newObjects, containersAndCovers, containers, covers, extraCovers, ventilatedSample},

			{unitTestBench, unitTestBag, unitTestHandlingStation} = Upload[{
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
				|>,
				<|
					Type->Object[Instrument, HandlingStation, Ambient],
					Model->Link[Model[Instrument, HandlingStation, Ambient, "Full Benchtop Handling Station with Macro and Analytical Balance"], Objects],
					Name->"Handling Station for ExperimentUncover tests"<>$SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>
			}];

			numberOfExtraCovers = 2;

			newObjects = UploadSample[
				{
					(* Extra covers *)
					(*1*)Model[Item, Cap, "id:L8kPEjn4DkZw"],
					(*2*)Model[Item, Cap, "Bottle Cap, 46x23mm"],

					(* For crimp test *)
					(*3*)Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
					(*4*)Model[Item, Cap, "VWR Flip Off 13mm Cap"],

					(* For lid test *)
					(*5*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					(*6*)Model[Item, Lid, "Universal Black Lid"],

					(* For plate seal test *)
					(*7*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					(*8*)Model[Item, PlateSeal, "Plate Seal, 96-Well Square"],

					(* For Barcode test *)
					(*9*)Model[Container, Vessel, "100g opaque white plastic rectangular solid bottle"],
					(*10*)Model[Item, Cap, "Bottle Cap, 46x23mm"],

					(* For no Products test *)
					(*11*)Model[Container, Vessel, "25mL narrow amber glass bottle"],
					(*12*)Model[Item, Cap, "Bottle Cap, 38x20mm"],

					(* For with Products test *)
					(*13*)Model[Container, Vessel, "2mL Tube"],
					(*14*)Model[Item, Cap, "2 mL tube cap, standard"],

					(* For discard cover test *)
					(*15*)Model[Container, Vessel, "2mL Tube"],
					(*16*)Model[Item, Cap, "2 mL tube cap, standard"],

					(*17*)Model[Container, Vessel, "2mL Tube"],
					(*18*)Model[Item, Cap, "2 mL tube cap, standard"],

					(*19*)Model[Container, Vessel, "2mL Tube"],
					(*21*)Model[Item, Cap, "2 mL tube cap, standard"],

					(*22*)Model[Container, Vessel, "50mL Tube"],
					(*23*)Model[Item, Cap, "50mL tube degas cap"],

					(*24*)Model[Container, Vessel, "id:3em6Zv9Njjbv"], (*"2L Glass Bottle"*)
					(*25*)Model[Item, Cap, "id:jLq9jXvMkYPE"], (*"GL45 Bottle Cap"*)

					(* for multiple entries testing *)
					(*26*)Model[Container, Cuvette, "Micro Scale Black Walled UV Quartz Cuvette"],
					(*27*)Model[Item, Cap, "Cuvette Cap, 18x17mm"],
					(*28*)Model[Container, Cuvette, "Micro Scale Black Walled UV Quartz Cuvette"],
					(*29*)Model[Item, Cap, "Cuvette Cap, 18x17mm"],

					(* for foil covering *)
					(*30*)Model[Container, Vessel, "id:jLq9jXY4kkXE"], (*Model[Container, Vessel, "250mL Erlenmeyer Flask"]*)
					(*31*)Model[Item, Lid, "id:7X104v1N35pw"], (*Model[Item, Lid, "Aluminum Foil Cover"]*)

					(* for decrimping *)
					(*32*)Model[Container, Vessel, "id:6V0npvmW99k1"], (*Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"]*)
          (*33*)Model[Item, Cap, "id:9RdZXv17GGDj"], (*Model[Item, Cap, "14 millimeter aluminum crimp cap with septum for 2 mL glass vial"]*)
          (*34*)Model[Container, Vessel, "id:XnlV5jNXm8oP"], (*Model[Container, Vessel, "Thermo Scientific SureSTART 2 mL Glass Crimp Top Vials, Level 2 High-Throughput Applications"]*)
          (*35*)Model[Item, Cap, "id:jLq9jXOmYw5q"], (*Model[Item, Cap, "Thermo Scientific SureSTART 11 mm Crimp Caps, White Silicone/Red PTFE"]*)

					(* for ampoule opener*)
					(*36*)Model[Container, Vessel, "id:zGj91aR3dddn"], (*Model[Container, Vessel, "1mL amber glass ampule"]*)
					(*37*)Model[Item, Cap, "id:P5ZnEjZ3oBWr"], (*Model[Item, Cap, "Amber Ampule Cover 1mL"]*)

					(* for crimp uncovering *)
					(*38*)Model[Container, Vessel, "Headspace vial, 6 mL, crimp clear flat bottom"],
					(*39*)Model[Item, Cap, "Aluminum septum caps for Metrohm Karl Fischer oven vials"]
				},
				{
					(*1*){"Work Surface", unitTestBench},
					(*2*){"Work Surface", unitTestBench},
					(*3*){"Work Surface", unitTestBench},
					(*4*){"Work Surface", unitTestBench},
					(*5*){"Work Surface", unitTestBench},
					(*6*){"Work Surface", unitTestBench},
					(*7*){"Work Surface", unitTestBench},
					(*8*){"Work Surface", unitTestBench},
					(*9*){"A1", unitTestBag},
					(*10*){"Work Surface", unitTestBench},
					(*11*){"A1", unitTestBag},
					(*12*){"Work Surface", unitTestBench},
					(*13*){"Work Surface", unitTestBench},
					(*14*){"Work Surface", unitTestBench},
					(*15*){"Work Surface", unitTestBench},
					(*16*){"Work Surface", unitTestBench},
					(*17*){"Work Surface", unitTestBench},
					(*18*){"Work Surface", unitTestBench},
					(*19*){"Working Zone Slot", unitTestHandlingStation},
					(*21*){"Working Zone Slot", unitTestHandlingStation},
					(*22*){"Work Surface", unitTestBench},
					(*23*){"Work Surface", unitTestBench},
					(*24*){"Work Surface", unitTestBench},
					(*25*){"Work Surface", unitTestBench},
					(*26*){"Work Surface", unitTestBench},
					(*27*){"Work Surface", unitTestBench},
					(*28*){"Work Surface", unitTestBench},
					(*29*){"Work Surface", unitTestBench},
					(*30*){"Work Surface", unitTestBench},
					(*31*){"Work Surface", unitTestBench},
					(*32*){"Work Surface", unitTestBench},
					(*33*){"Work Surface", unitTestBench},
					(*34*){"Work Surface", unitTestBench},
					(*35*){"Work Surface", unitTestBench},
					(*36*){"Work Surface", unitTestBench},
					(*37*){"Work Surface", unitTestBench},
					(*38*){"Work Surface", unitTestBench},
					(*39*){"Work Surface", unitTestBench}
				},
				Name->{
					(*1*)Null,
					(*2*)Null,
					(*3*)"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing"<>$SessionUUID,
					(*4*)"Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing"<>$SessionUUID,
					(*5*)"Covered DWP for ExperimentUncover Testing"<>$SessionUUID,
					(*6*)"Universal Black Lid for ExperimentUncover Testing"<>$SessionUUID,
					(*7*)"Container with PlateSeal for ExperimentUncover Testing"<>$SessionUUID,
					(*8*)Null,
					(*9*)"Container with barcoded cap for ExperimentUncover Testing"<>$SessionUUID,
					(*10*)Null,
					(*11*)"Container with productless cap for ExperimentUncover Testing"<>$SessionUUID,
					(*12*)Null,
					(*13*)"Covered 2mL Tube 1 for ExperimentUncover Testing"<>$SessionUUID,
					(*14*)"2mL Tube Cap 1 for ExperimentUncover Testing"<>$SessionUUID,
					(*15*)"Covered 2mL Tube 2 for ExperimentUncover Testing"<>$SessionUUID,
					(*16*)"2mL Tube Cap 2 for ExperimentUncover Testing"<>$SessionUUID,
					(*17*)"Covered 2mL Tube 3 for ExperimentUncover Testing"<>$SessionUUID,
					(*18*)"2mL Tube Cap 3 for ExperimentUncover Testing"<>$SessionUUID,
					(*19*)"Covered 2mL Tube 4 for ExperimentUncover Testing"<>$SessionUUID,
					(*21*)"2mL Tube Cap 4 for ExperimentUncover Testing"<>$SessionUUID,
					(*22*)"50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing"<>$SessionUUID,
					(*23*)"50mL Tube Degas Cap with Barcode for ExperimentUncover Testing"<>$SessionUUID,
					(*24*)"Covered 2L Glass Bottle 1 for ExperimentUncover Testing" <> $SessionUUID,
					(*25*)"GL45 Bottle Cap 1 for ExperimentUncover Testing" <> $SessionUUID,
					(*26*)"Cuvette 1 for ExperimentUncover Testing"<>$SessionUUID,
					(*27*)Null,
					(*28*)"Cuvette 2 for ExperimentUncover Testing"<>$SessionUUID,
					(*29*)Null,
					(*30*)"Erlenmeyer flask covered with aluminum foil for ExperimentUncover Testing" <> $SessionUUID,
					(*31*)"Aluminum foil cover 1 for ExperimentUncover Testing" <> $SessionUUID,
					(*32*)"Crimped 13mm vial for ExperimentUncover Testing" <> $SessionUUID,
					(*33*)"13mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID,
					(*34*)"Crimped 11mm vial for ExperimentUncover Testing" <> $SessionUUID,
					(*35*)"11mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID,
					(*36*)"Ampoule for ExperimentUncover Testing" <> $SessionUUID,
					(*37*)"Ampoule cover for ExperimentUncover Testing" <> $SessionUUID,
					(*38*)"Uncovered 6 mL aspiration vial for hand-crimping in ExperimentUncover testing" <> $SessionUUID,
					(*39*)"20mm vial aspiration cap for ExperimentUncover testing" <> $SessionUUID
				}
			];


			(* Add a ventilated sample to one of our container to make sure we resolve fumehood without issue *)
			{
				ventilatedSample,
				decrimper
			} = UploadSample[
				{
					Model[Sample, "id:8qZ1VW0JqeED"],
					Model[Part, Decrimper, "Manual Decrimper, 20 mm"]
				},
				{
					{"A1", Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing" <> $SessionUUID]},
					{"Work Surface", unitTestBench}
				},
				Name -> {
					Null,
					"Decrimper for ExperimentUncover Testing" <> $SessionUUID
				}
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

			mspProt = CreateID[Object[Protocol, ManualSamplePreparation]];
			Upload[{
				<|
					Object -> mspProt,
					Name -> "Test MSP parent protocol with Decrimpers still InUse for ExperimentUncover testing" <> $SessionUUID,
					RootProtocol -> Link[mspProt],
					DeveloperObject -> True
				|>
			}];
			UploadSampleStatus[decrimper, InUse, UpdatedBy -> mspProt];
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
				Object[Instrument, HandlingStation, Ambient, "Handling Station for ExperimentUncover tests" <> $SessionUUID],
				Object[Container, Bench, "Bench for ExperimentUncover tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 3 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube 4 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 3 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "2mL Tube Cap 4 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "50mL Tube Covered with Barcoded Cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Degas Cap with Barcode for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Plate, "Covered DWP for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal Black Lid for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Plate, "Container with PlateSeal for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container with barcoded cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container with productless cap for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Cuvette, "Cuvette 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Cuvette, "Cuvette 2 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Erlenmeyer flask covered with aluminum foil for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Lid, "Aluminum foil cover 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Crimped 13mm vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "13mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Crimped 11mm vial for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "11mm Crimped cover for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Covered 2L Glass Bottle 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "GL45 Bottle Cap 1 for ExperimentUncover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Ampoule for ExperimentUncover Testing" <> $SessionUUID],
				Object[Item, Cap, "Ampoule cover for ExperimentUncover Testing" <> $SessionUUID]
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


DefineTests[Uncover,
	{
		Example[{Basic, "Display the option values for a protocol object to uncover a covered container:"},
			Experiment[{
				Uncover[
					Sample -> Object[Container, Vessel, "Covered 2mL Tube for Uncover Testing "<>$SessionUUID]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> Object[Container, Vessel, "Covered 2mL Tube for Uncover Testing "<>$SessionUUID],
					Amount -> 0.1 Milliliter
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic,"Display the option values for a Robotic Uncover version:"},
			Experiment[{
				Uncover[
					Sample -> Object[Container,Plate,"Covered DWP for Uncover Testing "<>$SessionUUID]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> Object[Container,Plate,"Covered DWP for Uncover Testing "<>$SessionUUID],
					Amount -> 0.1 Milliliter
				]
			}],
			ObjectP[Object[Protocol]]
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
				Object[Container, Bench, "Test bench for Uncover tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for Uncover Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for Uncover Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for Uncover Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for Uncover Testing "<>$SessionUUID]
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
					Name->"Test bench for Uncover tests "<>$SessionUUID,
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
					"Covered DWP for Uncover Testing "<>$SessionUUID,
					"Universal Black Lid for Uncover Testing "<>$SessionUUID,
					"Covered 2mL Tube for Uncover Testing "<>$SessionUUID,
					"Covered 2mL Tube Cap Standard on Vial for Uncover Testing "<>$SessionUUID
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
				Object[Container, Bench, "Test bench for Uncover tests "<>$SessionUUID],
				Object[Container, Vessel, "Covered 2mL Tube for Uncover Testing "<>$SessionUUID],
				Object[Container, Plate, "Covered DWP for Uncover Testing "<>$SessionUUID],
				Object[Item,Cap,"Covered 2mL Tube Cap Standard on Vial for Uncover Testing "<>$SessionUUID],
				Object[Item,Lid,"Universal Black Lid for Uncover Testing "<>$SessionUUID]
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