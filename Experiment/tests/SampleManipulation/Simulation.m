(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*simulateSampleManipulation*)


DefineTests[simulateSampleManipulation,
	{
		Example[{Basic,"Simulate the samples created during the execution of a sample manipulation:"},
			simulateSampleManipulation[{
				Transfer[
					Source -> Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
					Amount -> 1 Milliliter,
					Destination -> Object[Container,Vessel,"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID]
				]
			}],
			{{PacketP[]..},{}}
		],
		Example[{Basic,"New amounts and locations are updated for source and destination samples:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Transfer[
						Source -> Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Amount -> 1 Milliliter,
						Destination -> Object[Container,Vessel,"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID]
					]
				}];
				{
					SelectFirst[
						simulationPackets,
						MatchQ[
							Lookup[#,Object],
							Download[Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],Object]
						]&
					],
					SelectFirst[
						simulationPackets,
						MatchQ[
							Lookup[#,Container],
							ObjectP[Object[Container,Vessel,"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID]]
						]&
					]
				}
			),
			{
				_Association?((
					Lookup[#,Volume]==(Download[
						Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Volume
					] - 1 Milliliter)
				)&),
				_Association?((Lookup[#,Volume]==1 Milliliter)&)
			},
			Variables:>{simulationPackets,defineLookup}
		],
		Example[{Additional,"Creates samples for model references in the manipulations:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My Water Sample",
						Sample -> Model[Sample, "Milli-Q water"]
					],
					Transfer[
						Source -> "My Water Sample",
						Destination -> Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Amount -> 1.5 Milliliter
					],
					Transfer[
						Source -> "My Water Sample",
						Destination -> Model[Container, Vessel, "2mL Tube"],
						Amount -> 1.5 Milliliter
					]
				}];
				
				defineLookup
			),
			{"My Water Sample" -> ObjectP[Object[Sample]]},
			Variables:>{simulationPackets,defineLookup}
		],
		Example[{Additional,"Creates containers for container model references in the manipulations and populates their contents appropriately:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My Vessel",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Consolidation[
						Sources -> {Model[Sample, "Milli-Q water"],Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID]},
						Destination -> "My Vessel",
						Amounts -> {500 Microliter, 200 Microliter}
					]
				}];
				
				SelectFirst[simulationPackets,MatchQ[Lookup[#,Object],Lookup[defineLookup,"My Vessel"]]&]
			),
			_Association?((MatchQ[Lookup[#,Contents],{{"A1",ObjectP[Object[Sample]]}}])&),
			Variables:>{simulationPackets,defineLookup}
		],
		Test["Samples defined via a location are supported:",
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My Sample",
						Sample -> {Object[Container, Plate, "Your Favorite Sample Plate"],"A1"}
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My Sample",
						Amount -> 10 Microliter
					]
				}];
				
				SelectFirst[simulationPackets,MatchQ[Lookup[#,Object],Lookup[defineLookup,"My Sample"]]&]
			),
			_Association?((MatchQ[Lookup[#,Container],ObjectP[Object[Container, Plate, "Your Favorite Sample Plate"]]])&),
			Variables:>{simulationPackets,defineLookup}
		],
		Example[{Additional,"Simulated samples whose Model is defined have their Model field appropriately populated:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My New Sample",
						Container -> Model[Container,Vessel,"2mL Tube"],
						Model -> Model[Sample,"Milli-Q water"]
					],
					Transfer[
						Source -> Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Destination -> "My New Sample",
						Amount -> 50 Microliter
					]
				}];
				
				SelectFirst[simulationPackets,MatchQ[Download[Lookup[#,Container],Object],Lookup[defineLookup,"My New Sample"]]&]
			),
			_Association?((MatchQ[Lookup[#,Model],ObjectP[Model[Sample,"Milli-Q water"]]])&),
			Variables:>{simulationPackets,defineLookup}
		],
		Example[{Additional,"Simulate filtered samples:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My Filter Plate",
						Container -> Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name -> "My Collection Plate",
						Container -> Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name -> "My Filtrate",
						Sample -> {"My Collection Plate","A1"},
						Model -> Model[Sample,"Dimethylformamide, Reagent Grade"]
					],
					Transfer[
						Source -> Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Destination -> {"My Filter Plate","A1"},
						Amount -> 1 Milliliter
					],
					Filter[
						Sample -> {{"My Filter Plate","A1"}},
						Pressure -> 20 PSI,
						Time -> 10 Second,
						CollectionContainer -> "My Collection Plate"
					]
				}];
				
				SelectFirst[simulationPackets,MatchQ[Lookup[#,Object],Lookup[defineLookup,"My Filtrate"]]&]
			),
			_Association?((MatchQ[Lookup[#,Model],ObjectP[Model[Sample,"Dimethylformamide, Reagent Grade"]]])&),
			Variables:>{simulationPackets,defineLookup}
		],
		Example[{Additional,"If a Define primitive describes a position, the output lookup points to the sample that will exist in that position:"},
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[
					{
						Define[
							Name -> "My Sample",
							Sample -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"],"A1"}
						],
						Transfer[
							Source -> Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID],
							Destination -> "My Sample",
							Amount -> 50 Microliter
						]
					}
				];
				
				Lookup[defineLookup,"My Sample"]
			),
			ObjectP[Object[Sample]],
			Variables:>{simulationPackets,defineLookup}
		],
		Test["Merge Contents field of simulated containers:",
			(
				{simulationPackets,defineLookup} = simulateSampleManipulation[{
					Define[
						Name -> "My Plate",
						Container -> Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name -> "My Sample 1",
						Sample -> {"My Plate","A1"}
					],
					Define[
						Name -> "My Sample 2",
						Sample -> {"My Plate","A2"}
					],
					Transfer[
						Source -> Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Destination -> "My Sample 1",
						Amount -> 50 Microliter
					],
					Transfer[
						Source -> Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Destination -> "My Sample 2",
						Amount -> 50 Microliter
					],
					Transfer[
						Source -> Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Destination -> {"My Plate","A3"},
						Amount -> 50 Microliter
					]
				}];
				
				MatchQ[
					Lookup[
						SelectFirst[simulationPackets,MatchQ[Lookup[#,Object],Lookup[defineLookup,"My Plate"]]&],
						Contents
					],
					{
						OrderlessPatternSequence[
							{"A1",LinkP[Lookup[defineLookup,"My Sample 1"]]},
							{"A2",LinkP[Lookup[defineLookup,"My Sample 2"]]},
							{"A3",ObjectP[Object[Sample]]}
						]
					}
				]
			),
			True,
			Variables:>{simulationPackets,defineLookup}
		],
		Test["Handles the case where no new samples are being created:",
			simulateSampleManipulation[{
				Define[
					Sample->Object[Sample, "simulateSampleManipulation test chemical"],
					Name->"test sample"
				],
				Mix[
					Sample -> "test sample",
					MixVolume -> 10 Microliter,
					NumberOfMixes -> 5
				]
			}],
			{
				{
					PacketP[Object[Sample, "simulateSampleManipulation test chemical"]],
					PacketP[Object[Container,Vessel]]
				},
				{"test sample" -> Object[Sample, "simulateSampleManipulation test chemical"]}
			},
			SetUp:>Module[{tubeObject},
				$CreatedObjects={};
				tubeObject=Upload[<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True|>];
				UploadSample[
					Model[Sample,"Milli-Q water"],
					{"A1",tubeObject},
					InitialAmount->1 Milliliter,
					Name->"simulateSampleManipulation test chemical"
				]
			],
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				testBench,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testChemical
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Bench,"Test bench for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for simulateSampleManipulation unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testEmptyContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID,
				Status->Stocked
			];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for simulateSampleManipulation unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for simulateSampleManipulation unit test "<>$SessionUUID
			];
			testChemical=UploadSample[
				Model[Sample,"Dimethylformamide, Reagent Grade"],
				{"A1",testPlate},
				Name->"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID,
				InitialAmount->1.5 Milliliter
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testChemical}]
				]
			];
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test empty 50mL tube for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for simulateSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in plate for simulateSampleManipulation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];
