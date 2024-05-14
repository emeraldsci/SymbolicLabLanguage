(* ::Subsection:: *)
(*ExperimentDegasPreview*)


DefineTests[
	ExperimentDegasPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentDegas:"},
			ExperimentDegasPreview[{Object[Sample,"DegasPreview Test Water Sample 1"<> $SessionUUID],Object[Sample,"DegasPreview Test Water Sample 2"<> $SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentDegasOptions:"},
			ExperimentDegasOptions[{Object[Sample,"DegasPreview Test Water Sample 3"<> $SessionUUID],Object[Sample,"DegasPreview Test Water Sample 1"<> $SessionUUID]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentDegasQ:"},
			ValidExperimentDegasQ[{Object[Sample,"DegasPreview Test Water Sample 1"<> $SessionUUID],Object[Sample,"DegasPreview Test Water Sample 2"<> $SessionUUID]},Verbose->Failures],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		ClearMemoization[];
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for DegasPreview" <> $SessionUUID],
				Object[Container, Vessel, "DegasPreview Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DegasPreview Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DegasPreview Test Tube 3" <> $SessionUUID],
				Object[Sample, "DegasPreview Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "DegasPreview Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "DegasPreview Test Water Sample 3" <> $SessionUUID]
			};
			
			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		
		Module[{testBench, testBenchPacket, numberOfTestContainers, allTestContainerModels, allTestContainerLabels, allTestSampleContainers, allTestSampleContainerPackets, allTestSampleModels, allTestSampleLabels, allTestSamplePackets},
			testBench = CreateID[Object[Container,Bench]];
			testBenchPacket = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{$Site[AllowedPositions][[1]],$Site},
				Name->"Test Bench for ExperimentDegasPreview"<>$SessionUUID,
				ID->testBench[ID],
				FastTrack->True,
				Upload->False
			];
			
			numberOfTestContainers = 3;
			allTestContainerModels = ConstantArray[Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25mL Flask, Reaction, 14/20 Outer Joint, Valve, Airfree, Schlenk"]*) numberOfTestContainers];
			allTestContainerLabels = Map["DegasPreview Test Tube "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			allTestSampleContainers = CreateID[ConstantArray[Object[Container,Vessel], numberOfTestContainers]];
			allTestSampleContainerPackets = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels,
				ID->allTestSampleContainers[ID],
				Status->Available,
				Cache->testBenchPacket,
				Upload->False
			];
			
			(* Create some samples *)
			allTestSampleModels = ConstantArray[Model[Sample, "id:8qZ1VWNmdLBD"] (*Model[Sample, "Milli-Q water"]*), numberOfTestContainers];
			allTestSampleLabels = Map["DegasPreview Test Water Sample "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			
			allTestSamplePackets = UploadSample[allTestSampleModels,
				Map[{"A1",#}&,allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->{
					10 Milliliter,
					10 Milliliter,
					10 Milliliter
				},
				StorageCondition->AmbientStorage,
				Status->Available,
				Cache->allTestSampleContainerPackets,
				Upload->False
			];
			
			Upload[Join[testBenchPacket,allTestSampleContainerPackets,allTestSamplePackets]];
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];




(* ::Subsection:: *)
(*ExperimentDegasOptions*)


DefineTests[
	ExperimentDegasOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentDegasOptions[{Object[Sample,"DegasOptions Test Water Sample 1"<> $SessionUUID],Object[Sample,"DegasOptions Test Water Sample 2"<> $SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentDegasOptions[{Object[Sample,"DegasOptions Test Water Sample 3"<> $SessionUUID]},DegasType->FreezePumpThaw,SpargingGas->Nitrogen],
			_Grid,
			Messages:>{Error::InvalidOption,Error::SpargingOnlyMismatch}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentDegasOptions[{Object[Sample,"DegasOptions Test Water Sample 1"<> $SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Block[{$DeveloperUpload=True,$AllowPublicObjects=True},
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		ClearMemoization[];
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for ExperimentDegasOptions" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 3" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 3" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testBench, testBenchPacket, numberOfTestContainers, allTestContainerModels, allTestContainerLabels, allTestSampleContainers, allTestSampleContainerPackets, allTestSampleModels, allTestSampleLabels, allTestSamplePackets},
			testBench = CreateID[Object[Container,Bench]];
			testBenchPacket = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{$Site[AllowedPositions][[1]],$Site},
				Name->"Test Bench for ExperimentDegasOptions"<>$SessionUUID,
				ID->testBench[ID],
				FastTrack->True,
				Upload->False
			];
			
			numberOfTestContainers = 3;
			allTestContainerModels = ConstantArray[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), numberOfTestContainers];
			allTestContainerLabels = Map["DegasOptions Test Tube "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			allTestSampleContainers = CreateID[ConstantArray[Object[Container,Vessel], numberOfTestContainers]];
			allTestSampleContainerPackets = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels,
				ID->allTestSampleContainers[ID],
				Status->Available,
				Cache->testBenchPacket,
				Upload->False
			];

			(* Create some samples *)
			allTestSampleModels = ConstantArray[Model[Sample, "id:8qZ1VWNmdLBD"] (*Model[Sample, "Milli-Q water"]*), numberOfTestContainers];
			allTestSampleLabels = Map["DegasOptions Test Water Sample "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			
			allTestSamplePackets = UploadSample[allTestSampleModels,
				Map[{"A1",#}&,allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->{
					10 Milliliter,
					10 Milliliter,
					10 Milliliter
				},
				StorageCondition->AmbientStorage,
				Status->Available,
				Cache->allTestSampleContainerPackets,
				Upload->False
			];
			
			Upload[Join[testBenchPacket,allTestSampleContainerPackets,allTestSamplePackets]];
		]
	],

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for ExperimentDegasOptions" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DegasOptions Test Tube 3" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "DegasOptions Test Water Sample 3" <> $SessionUUID]
			};
			
			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];


(* ::Subsection:: *)
(*ValidExperimentDegasQ*)


DefineTests[
	ValidExperimentDegasQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentDegasQ[{Object[Sample,"ValidExperimentDegasQ Test Water Sample 1"<> $SessionUUID],Object[Sample,"ValidExperimentDegasQ Test Water Sample 3"<> $SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentDegasQ[Object[Sample,"ValidExperimentDegasQ Test Water Sample 2"<> $SessionUUID],Method->Sparging],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentDegasQ[Object[Sample,"ValidExperimentDegasQ Test Water Sample 1"<> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentDegasQ[Object[Sample,"ValidExperimentDegasQ Test Water Sample 1"<> $SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>Block[{$DeveloperUpload=True,$AllowPublicObjects=True},
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		ClearMemoization[];
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for ValidExperimentDegasQ" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 3" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 3" <> $SessionUUID],
				Object[Container, Vessel, "DegasValid Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DegasValid Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DegasValid Test Tube 3" <> $SessionUUID],
				Object[Sample, "DegasValid Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "DegasValid Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "DegasValid Test Water Sample 3" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		
		Module[{testBench, testBenchPacket, numberOfTestContainers, allTestContainerModels, allTestContainerLabels, allTestSampleContainers, allTestSampleContainerPackets, allTestSampleModels, allTestSampleLabels, allTestSamplePackets},
			testBench = CreateID[Object[Container,Bench]];
			testBenchPacket = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{$Site[AllowedPositions][[1]],$Site},
				Name->"Test Bench for ValidExperimentDegasQ"<>$SessionUUID,
				ID->testBench[ID],
				FastTrack->True,
				Upload->False
			];
			
			numberOfTestContainers = 3;
			allTestContainerModels = ConstantArray[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), numberOfTestContainers];
			allTestContainerLabels = Map["ValidExperimentDegasQ Test Tube "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			allTestSampleContainers = CreateID[ConstantArray[Object[Container,Vessel], numberOfTestContainers]];
			allTestSampleContainerPackets = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels,
				ID->allTestSampleContainers[ID],
				Status->Available,
				Cache->testBenchPacket,
				Upload->False
			];
			
			(* Create some samples *)
			allTestSampleModels = ConstantArray[Model[Sample, "id:8qZ1VWNmdLBD"] (*Model[Sample,Milli-Q water]*), numberOfTestContainers];
			allTestSampleLabels = Map["ValidExperimentDegasQ Test Water Sample "<>ToString[#]<>$SessionUUID&, Range[numberOfTestContainers]];
			
			allTestSamplePackets = UploadSample[allTestSampleModels,
				Map[{"A1",#}&,allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->{
					10 Milliliter,
					10 Milliliter,
					10 Milliliter
				},
				StorageCondition->AmbientStorage,
				Status->Available,
				Cache->allTestSampleContainerPackets,
				Upload->False
			];
			
			Upload[Join[testBenchPacket,allTestSampleContainerPackets,allTestSamplePackets]];
		]
	],

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for ValidExperimentDegasQ" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentDegasQ Test Tube 3" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentDegasQ Test Water Sample 3" <> $SessionUUID]
			};
			
			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];

(* ::Subsection:: *)
(*Degas*)


DefineTests[
	Degas,
	{
		Test["Use a Degas unit operation to call ExperimentSamplePreparation and generate a protocol:",
			ExperimentSamplePreparation[{
				Degas[
					Sample -> Object[Sample,"Degas Unit Operation Test Water Sample 1"<> $SessionUUID]
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a Degas unit operation to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				Degas[
					Sample -> Object[Sample,"Degas Unit Operation Test Water Sample 1"<> $SessionUUID]
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a set of unit operations to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				LabelContainer[
					Label -> "My Degas Container",
					Container -> Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
				],
				Transfer[
					Source -> Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Destination -> "My Degas Container",
					Amount -> 10 Milliliter
				],
				Degas[
					Sample -> "My Degas Container"
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		ClearMemoization[];
		$CreatedObjects = {};
		
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Bench, "Test Bench for Degas Unit Operation Test" <> $SessionUUID],
				Object[Container, Vessel, "Degas Unit Operation Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "Degas Unit Operation Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "Degas Unit Operation Test Tube 3" <> $SessionUUID],
				Object[Sample, "Degas Unit Operation Test Water Sample 1" <> $SessionUUID],
				Object[Sample, "Degas Unit Operation Test Water Sample 2" <> $SessionUUID],
				Object[Sample, "Degas Unit Operation Test Water Sample 3" <> $SessionUUID]
			};
			
			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			];
		];
		
		Block[{$DeveloperUpload=True,$AllowPublicObjects=True},
			Module[{testtube1, testtube2, testtube3, testTubePackets, waterSamplePackets, testBench, testBenchPacket}, (* Create a test bench *)
				testBench = CreateID[Object[Container, Bench]];
				testBenchPacket = UploadSample[
					Model[Container, Bench, "The Bench of Testing"],
					{$Site[AllowedPositions][[1]], $Site},
					Name -> "Test Bench for Degas Unit Operation Test" <> $SessionUUID,
					ID -> testBench[ID],
					FastTrack -> True,
					Upload -> False
				];
				
				(* Create some containers *)
				{
					testtube1,
					testtube2,
					testtube3
				} = CreateID[ConstantArray[Object[Container, Vessel], 3]];
				
				testTubePackets = UploadSample[
					{
						Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25mL Flask, Reaction, 14/20 Outer Joint, Valve, Airfree, Schlenk"]*)
						Model[Container, Vessel, "id:54n6evnwBGBq"], (*Model[Container, Vessel, "25mL Flask, Reaction, 14/20 Outer Joint, Valve, Airfree, Schlenk"]*)
						Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25mL Flask, Reaction, 14/20 Outer Joint, Valve, Airfree, Schlenk"]*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Degas Unit Operation Test Tube 1" <> $SessionUUID,
						"Degas Unit Operation Test Tube 2" <> $SessionUUID,
						"Degas Unit Operation Test Tube 3" <> $SessionUUID
					},
					ID -> {testtube1, testtube2, testtube3}[ID],
					Cache -> testBenchPacket,
					Upload -> False
				];
				
				(* Create some samples *)
				waterSamplePackets = ECL`InternalUpload`UploadSample[
					{
						Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
						Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
						Model[Sample, "id:8qZ1VWNmdLBD"] (*Model[Sample, "Milli-Q water"]*)
					},
					{
						{"A1", testtube1},
						{"A1", testtube2},
						{"A1", testtube3}
					},
					Name -> {
						"Degas Unit Operation Test Water Sample 1" <> $SessionUUID,
						"Degas Unit Operation Test Water Sample 2" <> $SessionUUID,
						"Degas Unit Operation Test Water Sample 3" <> $SessionUUID
					},
					InitialAmount -> {
						10 Milliliter,
						10 Milliliter,
						10 Milliliter
					},
					Cache -> testTubePackets,
					StorageCondition -> AmbientStorage,
					Upload -> False
				];
				
				Upload[Flatten[{testBenchPacket,testTubePackets,waterSamplePackets}]]
			]
		]
	},

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];
