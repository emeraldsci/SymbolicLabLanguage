(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCover sisters: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentCoverOptions*)


DefineTests[ExperimentCoverOptions,
	{
		Example[{Basic, "Create a protocol object to cover an uncovered container:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID]
			],
			_Grid
		],
		Example[{Basic, "For a variety of standard containers, the cover chosen is EngineDefault->True:"},
			ExperimentCoverOptions[
				{
					Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID],
					Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID]
				},
				OutputFormat -> List
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, EngineDefault], {True, True}]&)
			}]
		],
		Example[{Basic, "When covering multiple containers at the same time, they're based by CoverType:"},
			Module[{options},
				options=ExperimentCoverOptions[
					{
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 2" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 3" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID],
						Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID]
					},
					OutputFormat -> List
				];

				Lookup[
					options,
					CoverType
				]
			],
			{Screw, Screw, Screw, Screw, Seal}
		],
		Example[{Basic, "Resolve options to cover an uncovered container that's already on a bench:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				OutputFormat -> List
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, {Model[CoverType], Model[CoverFootprint]}], {Crimp, Crimped13mmCap}]&),
				Environment -> ObjectP[Object[Container, Bench, "Test bench for ExperimentCoverOptions tests" <> $SessionUUID]]
			}]
		],
		Example[{Additional, "Environment resolves to a BSC if SterileTechnique->True:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				SterileTechnique -> True,
				OutputFormat -> List
			],
			KeyValuePattern[{
				Environment -> ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet]]
			}]
		],
		Example[{Additional, "When covering a container with a built in cover, doesn't generate any resources for caps:"},
			Module[{options},
				options=ExperimentCoverOptions[
					Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
					OutputFormat -> List
				];

				Lookup[
					options,
					CoverType
				]
			],
			Null
		],
		Example[{Additional, "DWP resolves to a press square seal:"},
			ExperimentCoverOptions[
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				OutputFormat -> List
			],
			KeyValuePattern[
				Cover -> ObjectP[Model[Item, PlateSeal, "Plate Seal, 96-Well Square"]]
			]
		],
		Example[{Additional, "Test Robotic version:"},
			ExperimentCoverOptions[
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Preparation -> Robotic,
				OutputFormat -> List
			],
			{__Rule}
		],
		Example[{Options, OutputFormat, "OutputFormat indicates if the options should be given as a table or a list:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				OutputFormat -> List
			],
			{__Rule}
		],
		Example[{Messages, "CoverContainerConflict", "Throws and error if the given cover is not compatible with the container:"},
			ExperimentCoverOptions[
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::CoverContainerConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KeepCoveredConflict", "Cannot keep a plate covered when it's covered by a plate seal:"},
			ExperimentCoverOptions[
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"],
				KeepCovered -> True,
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::KeepCoveredConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerInstrumentConflict", "Error when a Plate Seal is given as the cover but the instrument is not a plate sealer:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"],
				Cover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"],
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::CoverContainerConflict,
				Error::PlateSealerInstrumentConflict,
				Error::CrimperConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CrimperConflict", "Error when given a crimper that does not match CrimpType:"},
			ExperimentCoverOptions[
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"],
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::CoverContainerConflict,
				Error::CrimperConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "When Preparation->Robotic, cannot use a Cap or Vessel:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				Preparation -> Robotic,
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "When Preparation->Robotic, cannot use a Cap:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				Preparation -> Robotic,
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UsePreviousCoverConflict", "If UsePreviousCover->True, the Cover option must be set to the previous cover:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				UsePreviousCover -> True,
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::UsePreviousCoverConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerIsAlreadyCovered", "Specifying a container that is already covered results in an error:"},
			ExperimentCoverOptions[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				OutputFormat -> List
			],
			{__Rule},
			Messages :> {
				Error::ContainerIsAlreadyCovered,
				Error::InvalidInput
			}
		]
	},

	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ExperimentCoverOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ExperimentCoverOptions testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ExperimentCoverOptions testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCoverOptions Testing" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench},
			allObjects={
				Object[Container, Bench, "Test bench for ExperimentCoverOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ExperimentCoverOptions testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ExperimentCoverOptions testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCoverOptions Testing" <> $SessionUUID]
			};

			testBench=Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ExperimentCoverOptions tests" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];

			UploadSample[
				{
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "0.6mL Microcentrifuge Tube"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "Lunatic Chip Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCoverOptions Testing 2" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCoverOptions Testing 3" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID,
					"Covered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Uncovered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID,
					"0.6 Microcentrifuge Tube for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Universal Cap Rack for ExperimentCoverOptions Testing 1" <> $SessionUUID,
					"Universal Cap Rack for ExperimentCoverOptions Testing 2" <> $SessionUUID,
					"Uncovered 2mL Tube for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Uncovered Lunatic chip plate for ExperimentCoverOptions Testing" <> $SessionUUID,
					"Universal black lid for ExperimentCoverOptions testing" <> $SessionUUID,
					"Universal black lid 2 for ExperimentCoverOptions testing" <> $SessionUUID,
					"Uncovered DWP 2 for ExperimentCoverOptions Testing" <> $SessionUUID
				}
			];

			(* Upload a cap that one a universal cap rack for use in the unit test*)
			UploadSample[
				{
					Model[Item, Cap, "2 mL tube cap, standard"],
					Model[Item, Cap, "50 mL tube cap"]
				},
				{
					{"A1", Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 1" <> $SessionUUID]},
					{"A1", Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 2" <> $SessionUUID]}
				},
				Name -> {
					"Cap for a 2 mL Tube on a cap rack for ExperimentCoverOptions Testing" <> $SessionUUID,
					"50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCoverOptions Testing" <> $SessionUUID
				}
			];

			Upload[<|
				Object -> Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID],
				PreviousCover -> Link[Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCoverOptions Testing" <> $SessionUUID]]
			|>];

			(* Add Cover field to Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID] *)
			UploadCover[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Cover -> Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID]
			];

			(* Set PreviousCover field for Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID]
			 and Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCoverOptions Testing" <> $SessionUUID] *)
			Upload[{
				<|
					Object -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCoverOptions Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid for ExperimentCoverOptions testing" <> $SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered DWP 2 for ExperimentCoverOptions Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid 2 for ExperimentCoverOptions testing" <> $SessionUUID]]
				|>
			}];

			(*Make all the test objects and models developer objects*)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ExperimentCoverOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCoverOptions Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCoverOptions Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCoverOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCoverOptions Testing" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentCoverQ*)

DefineTests[ValidExperimentCoverQ,
	{
		Example[{Basic, "Create a protocol object to cover an uncovered container:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "For a variety of standard containers, the cover chosen is EngineDefault->True:"},
			ValidExperimentCoverQ[
				{
					Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
					Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic, "When covering multiple containers at the same time, they're based by CoverType:"},
			ValidExperimentCoverQ[
				{
					Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
					Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
					Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 3" <> $SessionUUID],
					Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID],
					Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic, "Resolve options to cover an uncovered container that's already on a bench:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID]
			],
			True
		],
		Example[{Additional, "Environment resolves to a BSC if SterileTechnique->True:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				SterileTechnique -> True
			],
			True
		],
		Example[{Additional, "When covering a container with a built in cover, doesn't generate any resources for caps:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ValidExperimentCoverQ Testing" <> $SessionUUID]
			],
			True
		],
		Example[{Additional, "DWP resolves to a press square seal:"},
			ValidExperimentCoverQ[
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID]
			],
			True
		],
		Example[{Additional, "Test Robotic version:"},
			ValidExperimentCoverQ[
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Preparation -> Robotic
			],
			True
		],
		Example[{Options, Verbose, "Verbose option indicates if tests should be printed:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Preparation -> Robotic,
				Verbose -> Failures
			],
			False
		],
		Example[{Options, OutputFormat, "OutputFormat option indicates if the output should be a Boolean or a test summary:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Preparation -> Robotic,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Messages, "CoverContainerConflict", "Throws and error if the given cover is not compatible with the container:"},
			ValidExperimentCoverQ[
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"]
			],
			False
		],
		Example[{Messages, "KeepCoveredConflict", "Cannot keep a plate covered when it's covered by a plate seal:"},
			ValidExperimentCoverQ[
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"],
				KeepCovered -> True
			],
			False
		],
		Example[{Messages, "PlateSealerInstrumentConflict", "Error when a Plate Seal is given as the cover but the instrument is not a plate sealer:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"],
				Cover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]
			],
			False
		],
		Example[{Messages, "CrimperConflict", "Error when given a crimper that does not match CrimpType:"},
			ValidExperimentCoverQ[
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"]
			],
			False
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "When Preparation->Robotic, cannot use a Cap or Vessel:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				Preparation -> Robotic
			],
			False
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "When Preparation->Robotic, cannot use a Cap:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				Preparation -> Robotic
			],
			False
		],
		Example[{Messages, "UsePreviousCoverConflict", "If UsePreviousCover->True, the Cover option must be set to the previous cover:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "id:mnk9jORMoabZ"],
				UsePreviousCover -> True
			],
			False
		],
		Example[{Messages, "ContainerIsAlreadyCovered", "Specifying a container that is already covered results in an error:"},
			ValidExperimentCoverQ[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID]
			],
			False
		]
	},

	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ValidExperimentCoverQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ValidExperimentCoverQ testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ValidExperimentCoverQ testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ValidExperimentCoverQ Testing" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench},
			allObjects={
				Object[Container, Bench, "Test bench for ValidExperimentCoverQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ValidExperimentCoverQ testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ValidExperimentCoverQ testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ValidExperimentCoverQ Testing" <> $SessionUUID]
			};

			testBench=Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ValidExperimentCoverQ tests" <> $SessionUUID,
				DeveloperObject -> True,
				Site -> Link[$Site]
			|>];

			UploadSample[
				{
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "0.6mL Microcentrifuge Tube"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "Lunatic Chip Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID,
					"Uncovered 50mL Tube for ValidExperimentCoverQ Testing 2" <> $SessionUUID,
					"Uncovered 50mL Tube for ValidExperimentCoverQ Testing 3" <> $SessionUUID,
					"Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID,
					"Covered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Uncovered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"0.6 Microcentrifuge Tube for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Universal Cap Rack for ValidExperimentCoverQ Testing 1" <> $SessionUUID,
					"Universal Cap Rack for ValidExperimentCoverQ Testing 2" <> $SessionUUID,
					"Uncovered 2mL Tube for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Uncovered Lunatic chip plate for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"Universal black lid for ValidExperimentCoverQ testing" <> $SessionUUID,
					"Universal black lid 2 for ValidExperimentCoverQ testing" <> $SessionUUID,
					"Uncovered DWP 2 for ValidExperimentCoverQ Testing" <> $SessionUUID
				}
			];

			(* Upload a cap that one a universal cap rack for use in the unit test*)
			UploadSample[
				{
					Model[Item, Cap, "2 mL tube cap, standard"],
					Model[Item, Cap, "50 mL tube cap"]
				},
				{
					{"A1", Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 1" <> $SessionUUID]},
					{"A1", Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 2" <> $SessionUUID]}
				},
				Name -> {
					"Cap for a 2 mL Tube on a cap rack for ValidExperimentCoverQ Testing" <> $SessionUUID,
					"50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ValidExperimentCoverQ Testing" <> $SessionUUID
				}
			];

			Upload[<|
				Object -> Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID],
				PreviousCover -> Link[Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ValidExperimentCoverQ Testing" <> $SessionUUID]]
			|>];

			(* Add Cover field to Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID] *)
			UploadCover[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Cover -> Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID]
			];

			(* Set PreviousCover field for Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID]
			 and Object[Container, Plate, "Uncovered Lunatic chip plate for ValidExperimentCoverQ Testing" <> $SessionUUID] *)
			Upload[{
				<|
					Object -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered Lunatic chip plate for ValidExperimentCoverQ Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid for ValidExperimentCoverQ testing" <> $SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered DWP 2 for ValidExperimentCoverQ Testing" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid 2 for ValidExperimentCoverQ testing" <> $SessionUUID]]
				|>
			}];

			(*Make all the test objects and models developer objects*)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Test bench for ValidExperimentCoverQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ValidExperimentCoverQ Testing 4" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ValidExperimentCoverQ Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ValidExperimentCoverQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ValidExperimentCoverQ Testing" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];