(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentImageColonies: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentImageColonies*)


DefineTests[ExperimentImageColonies,
	{
		(* ===Basic===*)
		Example[{Basic, "Create a protocol object to image a single bacterial sample:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColonies" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Create a protocol object to image a single bacterial plate:"},
			ExperimentImageColonies[
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColonies" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Create a protocol object to image several samples:"},
			ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 2 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ExperimentImageColonies" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		(* ===Options=== *)
		Example[{Options, Instrument, "Instrument indicates the instrument to image samples:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				Instrument -> Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentImageColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentImageColonies" <> $SessionUUID]]
			}]
		],
		Example[{Options, ImagingStrategies, "ImagingStrategies indicates the presets which describe how to expose the colonies to light:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, DarkRedFluorescence},
				Output -> Options
			],
			KeyValuePattern[{
				ImagingStrategies -> {BrightField, DarkRedFluorescence},
				ExposureTimes -> {Automatic, Automatic}
			}]
		],
		Example[{Options, ExposureTimes, "ExposureTimes indicates the length of time to allow the camera to capture an image and can be singleton:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ExposureTimes -> 100 Millisecond,
				Output -> Options
			],
			KeyValuePattern[{
				ImagingStrategies -> BrightField,
				ExposureTimes -> 100 Millisecond
			}]
		],
		Example[{Options, ExposureTimes, "ExposureTimes indicates the length of time to allow the camera to capture an image and can be a list:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen},
				ExposureTimes -> {10 Millisecond, 15 Millisecond},
				Output -> Options
			],
			KeyValuePattern[{
				ImagingStrategies -> {BrightField, BlueWhiteScreen},
				ExposureTimes -> {10 Millisecond, 15 Millisecond}
			}]
		],
		Example[{Options, SampleLabel, "SampleLabel can be given:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				SampleLabel -> "my test bacterial sample" <> $SessionUUID,
				Output -> Options
			],
			KeyValuePattern[{
				SampleLabel -> "my test bacterial sample" <> $SessionUUID
			}]
		],
		Example[{Options, SampleContainerLabel, "SampleContainerLabel can be given:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				SampleContainerLabel -> "my test bacterial plate" <> $SessionUUID,
				Output -> Options
			],
			KeyValuePattern[{
				SampleContainerLabel -> "my test bacterial plate" <> $SessionUUID
			}]
		],
		(* ===Messages=== *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentImageColonies[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentImageColonies[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentImageColonies[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentImageColonies[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "id:O81aEBZjRXvx"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 10 Gram,
					State -> Solid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentImageColonies[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "id:O81aEBZjRXvx"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 10 Gram,
					State -> Solid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentImageColonies[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "UnsupportedColonyTypes", "Throws an error if the input sample is not bacterial or yeast:"},
			ExperimentImageColonies[
				Object[Sample, "Mammalian cells for ExperimentImageColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonSolidSamples,
				Error::UnsupportedColonyTypes,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonSolidSamples", "Throws an error if the input sample is not solid:"},
			ExperimentImageColonies[
				Object[Sample, "Liquid Media Bacterial cells for ExperimentImageColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonSolidSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "Throws an error if model of the sample is deprecated:"},
			ExperimentImageColonies[
				Object[Sample, "Bacterial cells Deprecated for ExperimentImageColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonOmniTrayContainer", "Throws an error if the container of prepared sample is not a SBS plate:"},
			ExperimentImageColonies[
				Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentImageColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonOmniTrayContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonOmniTrayContainer", "Throws an error if the container of prepared sample has more than 1 well:"},
			ExperimentImageColonies[
				Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentImageColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonOmniTrayContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedSamples", "Throws an error if the input samples contain duplicates:"},
			ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InstrumentPrecision", "Throws a warning if option is rounded:"},
			options = ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ExposureTimes -> 100.1 Millisecond,
				Output -> Options
			];
			Lookup[options, ExposureTimes],
			100 Millisecond,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Messages, "ImagingOptionMismatch", "Throws an error if the length of ImagingStrategies and ExposureTimes are different:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence},
				ExposureTimes -> {3 Millisecond, 5 Millisecond}
			],
			$Failed,
			Messages :> {
				Error::ImagingOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ImagingOptionMismatch", "Throws an error if ImagingStrategies is a list but ExposureTimes is a single value:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, GreenFluorescence, OrangeFluorescence},
				ExposureTimes -> 3 Millisecond
			],
			$Failed,
			Messages :> {
				Error::ImagingOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MissingBrightField", "Throws an error if no BrightField specified for ImagingStrategies option:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {VioletFluorescence, GreenFluorescence, OrangeFluorescence}
			],
			$Failed,
			Messages :> {
				Error::MissingBrightField,
				Error::InvalidOption
			}
		],
		Test["The OutputUnitOperations field is populated:",
			protocol = ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 4 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen}
			];
			Download[protocol, OutputUnitOperations],
			{ObjectP[Object[UnitOperation, ImageColonies]]},
			Variables :> {protocol}
		],
		Test["If the two samples have the same imaging parameters after converting to a list, they can be grouped in the same unit operation:",
			protocol = ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 8 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 9 for ExperimentImageColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {BrightField, {BrightField}}
			];
			Download[protocol, OutputUnitOperations[BatchedUnitOperations]],
			{{ObjectP[Object[UnitOperation, ImageColonies]]}},
			Variables :> {protocol}
		],
		Test["If the two samples have different imaging parameters, they cannot be grouped in the same batched unit operation:",
			protocol = ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 10 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 11 for ExperimentImageColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {BrightField, {BrightField, BlueWhiteScreen}}
			];
			Length@Download[protocol, OutputUnitOperations[[1]][BatchedUnitOperations]],
			2,
			Variables :> {protocol}
		],
		Test["If the two samples have same imaging parameters but one singleton one list, they can be grouped in the same batched unit operation:",
			protocol = ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 6 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 7 for ExperimentImageColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {BrightField, {BrightField}}
			];
			Length@Download[protocol, OutputUnitOperations[[1]][BatchedUnitOperations]],
			1,
			Variables :> {protocol}
		],
		Test["BatchedUnitOperations field is populated when more than 2 samples have the same imaging parameters and grouped together:",
			protocol = ExperimentImageColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 12 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 13 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 14 for ExperimentImageColonies" <> $SessionUUID]
				}
			];
			Length@Download[protocol, OutputUnitOperations[[1]][BatchedUnitOperations]],
			2,
			Variables :> {protocol}
		],
		Test["A resource for an optical filter is found, if there is BlueWhiteScreen in ImagingStrategies option:",
			protocol = ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 5 for ExperimentImageColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen}
			];
			{
				MemberQ[Download[protocol, RequiredObjects], ObjectP[Model[Part, OpticalFilter]]],
				Download[protocol, OutputUnitOperations[AbsorbanceFilter]]
			},
			{True, {ObjectP[Model[Part, OpticalFilter]]}},
			Variables :> {protocol}
		],
		Test["The generated RCP, requires the Magnetic Hazard Safety certification:",
			Module[{protocol,requiredCerts},
				protocol = ExperimentImageColonies[
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColonies" <> $SessionUUID]
				];
				requiredCerts = Download[protocol,RequiredCertifications];
				MemberQ[requiredCerts,ObjectP[Model[Certification, "id:XnlV5jNAkGmM"]]]
			],
			True
		],
		(* ===Additional=== *)
		Example[{Additional, "If Simulation is included in the specified Output, a Simulation is returned:"},
			ExperimentImageColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentImageColonies" <> $SessionUUID],
				Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test yeast plate for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test depreciated bacterial model plate for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test InvalidContainerModels plate 1 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test InvalidContainerModels plate 2 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 3 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 4 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 5 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 6 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 7 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 8 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 9 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 10 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 11 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 12 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 13 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 14 for ExperimentImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 15 for ExperimentImageColonies" <> $SessionUUID],
				Model[Cell, Yeast, "Yeast Model Cell for ExperimentImageColonies" <> $SessionUUID],
				Model[Sample, "Liquid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Yeast cells Model for ExperimentImageColonies" <> $SessionUUID],
				Model[Sample, "Bacterial cells Deprecated Model for ExperimentImageColonies" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Yeast cells for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells Deprecated for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Mammalian cells for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 2 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 4 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 5 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 6 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 7 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 8 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 9 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 10 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 11 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 12 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 13 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 14 for ExperimentImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 15 for ExperimentImageColonies" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, testPlate2, testPlate3, testPlate4, testPlate5, testPlate6, testPlate7, testPlate8, testPlate9,
				testPlate10, testPlate11, testPlate12, testPlate13, testPlate14, testPlate15, testPlate16, testPlate17,
				testPlate18, testPlate19, testPlate20, testPlate21, yeastCellModel, liquidMediaBacteriaModel, solidMediaBacteriaModel,
				solidMediaYeastModel, deprecatedBacteriaModel, mammalianModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentImageColonies" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				(*Upload a test instrument object*)
				Upload[
					<|
						Type -> Object[Instrument, ColonyHandler],
						Model -> Link[Model[Instrument, ColonyHandler, "QPix 420 HT"], Objects],
						Name -> "Test imaging instrument object for ExperimentImageColonies" <> $SessionUUID,
						Site -> Link[$Site]
					|>
				];

				{
					testPlate1, testPlate2, testPlate3, testPlate4, testPlate5, testPlate6, testPlate7, testPlate8,
					testPlate9, testPlate10, testPlate11, testPlate12, testPlate13, testPlate14, testPlate15, testPlate16,
					testPlate17, testPlate18, testPlate19, testPlate20, testPlate21} = UploadSample[
					{
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Delta 8 Wash Tray"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"]
					},
					ConstantArray[{"Work Surface", testBench}, 21],
					Name -> {
						"Test liquid bacterial plate for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 1 for ExperimentImageColonies" <> $SessionUUID,
						"Test yeast plate for ExperimentImageColonies" <> $SessionUUID,
						"Test depreciated bacterial model plate for ExperimentImageColonies" <> $SessionUUID,
						"Test InvalidContainerModels plate 1 for ExperimentImageColonies" <> $SessionUUID,
						"Test InvalidContainerModels plate 2 for ExperimentImageColonies" <> $SessionUUID,
						"Test mammalian plate for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 2 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 3 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 4 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 5 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 6 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 7 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 8 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 9 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 10 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 11 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 12 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 13 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 14 for ExperimentImageColonies" <> $SessionUUID,
						"Test bacterial plate 15 for ExperimentImageColonies" <> $SessionUUID
					}
				];

				(* Create yeast cell model *)
				yeastCellModel = UploadYeastCell[
					"Yeast Model Cell for ExperimentImageColonies" <> $SessionUUID,
					CellType -> Yeast,
					CultureAdhesion -> SolidMedia,
					BiosafetyLevel -> "BSL-2",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None}
				];

				(* Create some sample models *)
				{liquidMediaBacteriaModel, solidMediaBacteriaModel, solidMediaYeastModel, deprecatedBacteriaModel, mammalianModel} = UploadSampleModel[
					{
						"Liquid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Yeast cells Model for ExperimentImageColonies" <> $SessionUUID,
						"Bacterial cells Deprecated Model for ExperimentImageColonies" <> $SessionUUID,
						"Mammalian cells Model for ExperimentImageColonies" <> $SessionUUID
					},
					Composition -> {
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, yeastCellModel}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Bacterial, Yeast, Bacterial, Mammalian},
					CultureAdhesion -> {Suspension, SolidMedia, SolidMedia, SolidMedia, Adherent},
					Living -> True
				];
				Upload[<|Object -> deprecatedBacteriaModel, Deprecated -> True|>];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					{
						liquidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaYeastModel,
						deprecatedBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						mammalianModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel
					},
					{
						{"A1", testPlate1},
						{"A1", testPlate2},
						{"A1", testPlate3},
						{"A1", testPlate4},
						{"A1", testPlate5},
						{"A1", testPlate6},
						{"A1", testPlate7},
						{"A1", testPlate8},
						{"A1", testPlate9},
						{"A1", testPlate10},
						{"A1", testPlate11},
						{"A1", testPlate12},
						{"A1", testPlate13},
						{"A1", testPlate14},
						{"A1", testPlate15},
						{"A1", testPlate16},
						{"A1", testPlate17},
						{"A1", testPlate18},
						{"A1", testPlate19},
						{"A1", testPlate20},
						{"A1", testPlate21}
					},
					InitialAmount -> {
						300 Microliter,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						300 Microliter,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram
					},
					State -> {Liquid, Solid, Solid, Solid, Solid, Solid, Liquid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid, Solid},
					Name -> {
						"Liquid Media Bacterial cells for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 1 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Yeast cells for ExperimentImageColonies" <> $SessionUUID,
						"Bacterial cells Deprecated for ExperimentImageColonies" <> $SessionUUID,
						"Bacterial cells in InvalidContainerModels 1 for ExperimentImageColonies" <> $SessionUUID,
						"Bacterial cells in InvalidContainerModels 2 for ExperimentImageColonies" <> $SessionUUID,
						"Mammalian cells for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 2 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 4 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 5 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 6 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 7 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 8 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 9 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 10 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 11 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 12 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 13 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 14 for ExperimentImageColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 15 for ExperimentImageColonies" <> $SessionUUID
					}
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentImageColonies" <> $SessionUUID],
					Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test yeast plate for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test depreciated bacterial model plate for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test InvalidContainerModels plate 1 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test InvalidContainerModels plate 2 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 3 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 4 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 5 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 6 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 7 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 8 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 9 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 10 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 11 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 12 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 13 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 14 for ExperimentImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 15 for ExperimentImageColonies" <> $SessionUUID],
					Model[Cell, Yeast, "Yeast Model Cell for ExperimentImageColonies" <> $SessionUUID],
					Model[Sample, "Liquid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Yeast cells Model for ExperimentImageColonies" <> $SessionUUID],
					Model[Sample, "Bacterial cells Deprecated Model for ExperimentImageColonies" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells Deprecated for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Mammalian cells for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 2 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 4 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 5 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 6 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 7 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 8 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 9 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 10 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 11 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 12 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 13 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 14 for ExperimentImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 15 for ExperimentImageColonies" <> $SessionUUID]
					}
				}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentImageColoniesQ*)


DefineTests[ValidExperimentImageColoniesQ,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns a Boolean indicating the validity of a ImageColonies experimental setup on a sample:"},
			ValidExperimentImageColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentImageColoniesQ" <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a ImageColonies experimental setup on a sample:"},
			ValidExperimentImageColoniesQ[
				Object[Sample, "Mammalian cells for ValidExperimentImageColoniesQ" <> $SessionUUID]
			],
			False
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a ImageColonies experimental setup on multiple samples:"},
			ValidExperimentImageColoniesQ[
				{
					Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ValidExperimentImageColoniesQ" <> $SessionUUID]
				}
			],
			True
		],
		(* ===Options=== *)
		Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentImageColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Verbose -> True
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentImageColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				ImagingStrategies -> BrightField,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test yeast plate for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 3 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Model[Cell, Yeast, "Yeast Model Cell for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Model[Sample, "Solid Media Yeast cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Yeast cells for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Sample, "Mammalian cells for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentImageColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentImageColoniesQ" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, testPlate2, testPlate3, testPlate4, testPlate5, yeastCellModel, solidMediaBacteriaModel,
				solidMediaYeastModel, mammalianModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ValidExperimentImageColoniesQ" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				{testPlate1, testPlate2, testPlate3, testPlate4, testPlate5} = UploadSample[
					{
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"]
					},
					ConstantArray[{"Work Surface", testBench}, 5],
					Name -> {
						"Test bacterial plate 1 for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Test yeast plate for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Test mammalian plate for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Test bacterial plate 2 for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Test bacterial plate 3 for ValidExperimentImageColoniesQ" <> $SessionUUID
					}
				];

				(* Create yeast cell model *)
				yeastCellModel = UploadYeastCell[
					"Yeast Model Cell for ValidExperimentImageColoniesQ" <> $SessionUUID,
					CellType -> Yeast,
					CultureAdhesion -> SolidMedia,
					BiosafetyLevel -> "BSL-2",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None}
				];

				(* Create some sample models *)
				{solidMediaBacteriaModel, solidMediaYeastModel, mammalianModel} = UploadSampleModel[
					{
						"Solid Media Bacterial cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Solid Media Yeast cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Mammalian cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID
					},
					Composition -> {
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, yeastCellModel}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Yeast, Mammalian},
					CultureAdhesion -> {SolidMedia, SolidMedia, Adherent},
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					{
						solidMediaBacteriaModel,
						solidMediaYeastModel,
						mammalianModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel
					},
					{
						{"A1", testPlate1},
						{"A1", testPlate2},
						{"A1", testPlate3},
						{"A1", testPlate4},
						{"A1", testPlate5}
					},
					InitialAmount -> {
						10 Gram,
						10 Gram,
						300 Microliter,
						10 Gram,
						10 Gram
					},
					State -> {Solid, Solid, Liquid, Solid, Solid},
					Name -> {
						"Solid Media Bacterial cells 1 for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Solid Media Yeast cells for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Mammalian cells for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Solid Media Bacterial cells 2 for ValidExperimentImageColoniesQ" <> $SessionUUID,
						"Solid Media Bacterial cells 3 for ValidExperimentImageColoniesQ" <> $SessionUUID
					}
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test yeast plate for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 3 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Model[Cell, Yeast, "Yeast Model Cell for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Model[Sample, "Solid Media Yeast cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Mammalian cells for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentImageColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentImageColoniesQ" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentImageColoniesPreview*)

DefineTests[ExperimentImageColoniesPreview,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns nothing for sample used in a ImageColonies experiment:"},
			ExperimentImageColoniesPreview[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesPreview" <> $SessionUUID]
			],
			Null
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentImageColoniesPreview" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColoniesPreview" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColoniesPreview" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesPreview" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, solidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentImageColoniesPreview" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					{"Work Surface", testBench},
					Name -> "Test bacterial plate 1 for ExperimentImageColoniesPreview" <> $SessionUUID
				];

				(* Create some sample models *)
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model for ExperimentImageColoniesPreview" <> $SessionUUID,
					Composition -> {{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					solidMediaBacteriaModel,
					{"A1", testPlate1},
					InitialAmount -> 10 Gram,
					State -> Solid,
					Name -> "Solid Media Bacterial cells 1 for ExperimentImageColoniesPreview" <> $SessionUUID
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentImageColoniesPreview" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColoniesPreview" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColoniesPreview" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesPreview" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentImageColoniesOptions*)

DefineTests[ExperimentImageColoniesOptions,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns options for sample used in a ImageColonies experiment:"},
			ExperimentImageColoniesOptions[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesOptions" <> $SessionUUID]
			],
			_Grid
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentImageColoniesOptions" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColoniesOptions" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColoniesOptions" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesOptions" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, solidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentImageColoniesOptions" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					{"Work Surface", testBench},
					Name -> "Test bacterial plate 1 for ExperimentImageColoniesOptions" <> $SessionUUID
				];

				(* Create some sample models *)
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model for ExperimentImageColoniesOptions" <> $SessionUUID,
					Composition -> {{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					solidMediaBacteriaModel,
					{"A1", testPlate1},
					InitialAmount -> 10 Gram,
					State -> Solid,
					Name -> "Solid Media Bacterial cells 1 for ExperimentImageColoniesOptions" <> $SessionUUID
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentImageColoniesOptions" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentImageColoniesOptions" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentImageColoniesOptions" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentImageColoniesOptions" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ImageColonies*)
(* This is the unit test for the primitive heads *)

DefineTests[ImageColonies,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns a robotic cell preparation protocol or script to run a ImageColonies experiment:"},
			ExperimentRoboticCellPreparation[
				ImageColonies[
					Sample -> Object[Sample, "Solid Media Bacterial cells 1 for ImageColonies" <> $SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Additional, "Can use Experiment for building the protocol from a set of primitives:"},
			ExperimentCellPreparation[
				{
					LabelSample[
						Label -> "my sample",
						Sample -> Object[Sample, "Solid Media Bacterial cells 1 for ImageColonies" <> $SessionUUID]
					],
					IncubateCells[
						Sample -> "my sample",
						Incubator -> Model[Instrument, Incubator, "Bactomat HERAcell 240i TT 10 for Bacteria"],
						Preparation -> Manual,
						Time -> 10 Hour
					],
					ImageColonies[
						Sample -> "my sample"
					]
				}
			],
			ObjectP[Object[Notebook, Script]]
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ImageColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ImageColonies" <> $SessionUUID],
				Object[Item, Lid, "Test bacterial cover 1 for ImageColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ImageColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ImageColonies" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, testCover1, solidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ImageColonies" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					{"Work Surface", testBench},
					Name -> "Test bacterial plate 1 for ImageColonies" <> $SessionUUID
				];

				testCover1 = UploadSample[
					Model[Item, Lid, "96 Well Greiner Plate Lid"],
					{"Work Surface", testBench},
					Name -> "Test bacterial cover 1 for ImageColonies" <> $SessionUUID
				];

				(* Create some sample models *)
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model for ImageColonies" <> $SessionUUID,
					Composition -> {{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					solidMediaBacteriaModel,
					{"A1", testPlate1},
					InitialAmount -> 10 Gram,
					State -> Solid,
					Name -> "Solid Media Bacterial cells 1 for ImageColonies" <> $SessionUUID
				];

				(* Upload Cover *)
				UploadCover[testPlate1, Cover -> testCover1]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ImageColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ImageColonies" <> $SessionUUID],
					Object[Item, Lid, "Test bacterial cover 1 for ImageColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ImageColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ImageColonies" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];
