(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*CompatibleFootprintQ*)

DefineTests[CompatibleFootprintQ,
	{
		Example[{Basic, "Looks through the CompatibleAdapters to determine if an adapter can be used to fit the sample on the instrument 1:"},
			CompatibleFootprintQ[Model[Instrument, Shaker, "id:N80DNj15vreD"], Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"]],
			True
		],
		Example[{Basic, "Looks through the CompatibleAdapters to determine if an adapter can be used to fit the sample on the instrument 2:"},
			CompatibleFootprintQ[Model[Instrument, Shaker, "id:N80DNj15vreD"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"]],
			True
		],
		Example[{Basic, "Looks through the CompatibleAdapters to determine if an adapter can be used to fit the sample on the instrument 3:"},
			CompatibleFootprintQ[Model[Instrument, Shaker, "id:N80DNj15vreD"], Model[Container, Vessel, "1L Glass Bottle"]],
			False
		],
		Example[{Basic, "Returns a boolean that indicates if there is a position on the instrument that can fit the given sample:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"]],
			True
		],
		Example[{Basic, "Returns a boolean that indicates if there is a position on the instrument that can fit the given sample:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"]],
			False
		],
		Example[{Basic, "CompatibleFootprintQ is listable:"},
			CompatibleFootprintQ[{Model[Instrument, Vortex, "id:dORYzZn0o45q"], Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]}, Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], ExactMatch -> {True, False}, MinWidth -> {Null, Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"][RollerSpacing]}],
			{False, False}
		],
		Example[{Additional, "CompatibleFootprintQ can check Model[Container]s in addition to instruments:"},
			CompatibleFootprintQ[{Model[Container, CentrifugeBucket, "Test bucket model for CompatibleFootprintQ"], Model[Instrument, Vortex, "id:dORYzZn0o45q"]}, Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"]],
			{True, True}
		],
		Example[{Additional, "Both the Locations and the containers can be pooled:"},
			CompatibleFootprintQ[
				{
					{
						Model[Instrument, Vortex, "id:dORYzZn0o45q"],
						Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]
					},
					{
						Model[Instrument, Vortex, "id:dORYzZn0o45q"],
						Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]
					}
				},
				{
					Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"],
					Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"]
				}
			],
			{{False, False}, {False, False}}
		],
		Example[{Additional, "Both the specified the pooled options for each of the pooled locations and containers:"},
			CompatibleFootprintQ[
				{
					{
						Model[Instrument, Vortex, "id:dORYzZn0o45q"],
						Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]
					},
					{
						Model[Instrument, Vortex, "id:dORYzZn0o45q"],
						Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]
					}
				},
				{
					Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"],
					Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"]
				},
				ExactMatch -> {{True, False}, {True, True}},
				MinWidth -> {{Null, Quantity[9.525`, "Centimeters"]}, {Quantity[9.525`, "Centimeters"], Null}}

			],
			{{False, False}, {False, False}}
		],
		Example[{Options, Tolerance, "Tolerance controls the tolerance between the measurement of the container and of the instrument's position. Since measurement is never perfect, this defaults to .5 Centimeters:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"], Tolerance -> 0Meter],
			False
		],
		Example[{Options, Tolerance, "Tolerance controls the tolerance between the measurement of the container and of the instrument's position. Since measurement is never perfect, this defaults to .5 Centimeters:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"]],
			True
		],
		Example[{Options, ExactMatch, "When ExactMatch->True, an exact match between the container's dimensions and the model's position's dimensions is evaluated, given the set Tolerance allowed:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:qdkmxz0A8YJm"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"]],
			False
		],
		Example[{Options, ExactMatch, "When ExactMatch->False, an exact match between the container's dimensions and the model's position's dimensions is evaluated, given the set Tolerance allowed:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:qdkmxz0A8YJm"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], ExactMatch -> False],
			False
		],
		Example[{Options, MinWidth, "When there is a MinWidth for an instrument (spacing required between roller pins), it can be specified using the MinWidth option:"},
			CompatibleFootprintQ[Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], ExactMatch -> False],
			True
		],
		Example[{Options, MinWidth, "When there is a MinWidth for an instrument (spacing required between roller pins), it can be specified using the MinWidth option:"},
			CompatibleFootprintQ[Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], ExactMatch -> False, MinWidth -> Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"][RollerSpacing]],
			False
		],
		Example[{Options, Position, "When Position->All, all positions in the instrument will be considered when trying to determine compatibility of the sample:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], Position -> All, ExactMatch -> False],
			True
		],
		Example[{Options, Position, "When Position is set to a specific position name, only that name will be considered during compaitibility determination:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], Position -> "2", ExactMatch -> False],
			False
		],
		Example[{Options, FlattenOutput, "Returns a lists of list results when FlattenOutput->False, regardless how many input containers are specified:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"], FlattenOutput -> False],
			{{True}}
		],
		Example[{Messages, "PositionNotFound", "When Position is set to a specific position name, if that position name doesn't appear in the instrument's list of positions an error is thrown:"},
			CompatibleFootprintQ[Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"], Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"], Position -> "Not A Position"],
			False,
			Messages :> {Error::PositionNotFound}
		]
	},
	SymbolSetUp :> (
		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container, Plate, "Test container 1 for CompatibleFootprintQ"],
			Object[Container, Vessel, "Test container 2 for CompatibleFootprintQ"],
			Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"],
			Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"],
			Model[Container, CentrifugeBucket, "Test bucket model for CompatibleFootprintQ"]
		}];

		EraseObject[
			PickList[
				{
					Object[Container, Plate, "Test container 1 for CompatibleFootprintQ"],
					Object[Container, Vessel, "Test container 2 for CompatibleFootprintQ"],
					Object[Sample, "Test sample in deep-well plate for CompatibleFootprintQ"],
					Object[Sample, "Test sample in 50mL tube for CompatibleFootprintQ"],
					Model[Container, CentrifugeBucket, "Test bucket model for CompatibleFootprintQ"]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];

		(* Create some empty containers *)
		{emptyContainer1, emptyContainer2, modelCentrifugeBucket}=Upload[{
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test container 1 for CompatibleFootprintQ",
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test container 2 for CompatibleFootprintQ",
				DeveloperObject -> True
			|>,
			<|
				Type -> Model[Container, CentrifugeBucket],
				Name -> "Test bucket model for CompatibleFootprintQ",
				Replace[Positions] -> {
					<|Name -> "A1", Footprint -> Plate, MaxWidth -> 0.1296 * Meter, MaxDepth -> 0.0874 * Meter, MaxHeight -> Null|>,
					<|Name -> "B1", Footprint -> Plate, MaxWidth -> 0.1296 * Meter, MaxDepth -> 0.0874 * Meter, MaxHeight -> Null|>
				},
				DeveloperObject -> True
			|>
		}];

		(* Create some water samples *)
		{waterSample1, waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", emptyContainer1}, {"A1", emptyContainer2}},
			InitialAmount -> {1 Milliliter, 50 Milliliter},
			Name -> {"Test sample in deep-well plate for CompatibleFootprintQ", "Test sample in 50mL tube for CompatibleFootprintQ"}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object -> waterSample1, DeveloperObject -> True|>,
			<|Object -> waterSample2, DeveloperObject -> True|>
		}];
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	),
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*AliquotContainers*)

DefineTests[AliquotContainers,
	{
		Example[{Basic, "Returns a list of containers that the sample can be aliquoted (considering the sample's volume) into to fit on a postion on the given instrument:"},
			AliquotContainers[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for AliquotContainers"]],
			{Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:E8zoYveRllM7"]}
		],
		Example[{Basic, "Returns a list of containers that the sample can be aliquoted (considering the sample's volume) into to fit on a postion on the given instrument:"},
			AliquotContainers[Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], Object[Sample, "Test sample in 50mL tube for AliquotContainers"], ExactMatch -> False, MinWidth -> Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"][RollerSpacing]],
			{Model[Container, Vessel, "id:zGj91aR3ddXJ"], Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:Vrbp1jG800Zm"]}
		],
		Example[{Basic, "AliquotContainers is listable:"},
			AliquotContainers[{Model[Instrument, Vortex, "id:dORYzZn0o45q"], Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"]}, Object[Sample, "Test sample in 50mL tube for AliquotContainers"], ExactMatch -> {True, False}, MinWidth -> {Null, Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"][RollerSpacing]}],
			{{}, {Model[Container, Vessel, "id:zGj91aR3ddXJ"], Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:Vrbp1jG800Zm"]}}
		],
		Example[{Options, Tolerance, "Tolerance controls the tolerance between the measurement of the container and of the instrument's position. Since measurement is never perfect, this defaults to .5 Centimeters:"},
			AliquotContainers[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for AliquotContainers"], Tolerance -> 0Meter],
			{}
		],
		Example[{Options, Tolerance, "Tolerance controls the tolerance between the measurement of the container and of the instrument's position. Since measurement is never perfect, this defaults to .5 Centimeters:"},
			AliquotContainers[Model[Instrument, Vortex, "id:dORYzZn0o45q"], Object[Sample, "Test sample in deep-well plate for AliquotContainers"]],
			{Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:E8zoYveRllM7"]}
		],
		Example[{Options, ExactMatch, "When ExactMatch->True, an exact match between the container's dimensions and the model's position's dimensions is evaluated, given the set Tolerance allowed:"},
			AliquotContainers[Model[Instrument, Vortex, "id:qdkmxz0A8YJm"], Object[Sample, "Test sample in 50mL tube for AliquotContainers"]],
			{}
		],
		Example[{Options, ExactMatch, "When ExactMatch->False, an exact match between the container's dimensions and the model's position's dimensions is evaluated, given the set Tolerance allowed:"},
			AliquotContainers[Model[Instrument, Vortex, "id:qdkmxz0A8YJm"], Object[Sample, "Test sample in 50mL tube for AliquotContainers"], ExactMatch -> False],
			{}
		],
		Example[{Options, MinWidth, "When there is a MinWidth for an instrument (spacing required between roller pins), it can be specified using the MinWidth option:"},
			AliquotContainers[Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], Object[Sample, "Test sample in 50mL tube for AliquotContainers"], ExactMatch -> False],
			{
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				Model[Container, Vessel, "id:jLq9jXvA8ewR"],
				Model[Container, Vessel, "id:01G6nvwPempK"],
				Model[Container, Vessel, "id:J8AY5jwzPPR7"],
				Model[Container, Vessel, "id:aXRlGnZmOONB"],
				Model[Container, Vessel, "id:zGj91aR3ddXJ"],
				Model[Container, Vessel, "id:3em6Zv9Njjbv"],
				Model[Container, Vessel, "id:Vrbp1jG800Zm"]
			}
		],
		Example[{Options, MinWidth, "When there is a MinWidth for an instrument (spacing required between roller pins), it can be specified using the MinWidth option:"},
			AliquotContainers[Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], Object[Sample, "Test sample in 50mL tube for AliquotContainers"], ExactMatch -> False, MinWidth -> Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"][RollerSpacing]],
			{Model[Container, Vessel, "id:zGj91aR3ddXJ"], Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:Vrbp1jG800Zm"]}
		]
	},
	SymbolSetUp :> (
		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container, Plate, "Test container 1 for AliquotContainers"],
			Object[Container, Vessel, "Test container 2 for AliquotContainers"],
			Object[Sample, "Test sample in deep-well plate for AliquotContainers"],
			Object[Sample, "Test sample in 50mL tube for AliquotContainers"]
		}];

		EraseObject[
			PickList[
				{
					Object[Container, Plate, "Test container 1 for AliquotContainers"],
					Object[Container, Vessel, "Test container 2 for AliquotContainers"],
					Object[Sample, "Test sample in deep-well plate for AliquotContainers"],
					Object[Sample, "Test sample in 50mL tube for AliquotContainers"]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];

		(* Create some empty containers *)
		{emptyContainer1, emptyContainer2}=Upload[{
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test container 1 for AliquotContainers",
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test container 2 for AliquotContainers",
				DeveloperObject -> True
			|>
		}];

		(* Create some water samples *)
		{waterSample1, waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", emptyContainer1}, {"A1", emptyContainer2}},
			InitialAmount -> {1 Milliliter, 50 Milliliter},
			Name -> {"Test sample in deep-well plate for AliquotContainers", "Test sample in 50mL tube for AliquotContainers"}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object -> waterSample1, DeveloperObject -> True|>,
			<|Object -> waterSample2, DeveloperObject -> True|>
		}];
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	),
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*RackFinder*)

DefineTests[RackFinder,
	{
		Example[{Basic, "Returns a rack model given a 2mL tube:"},
			RackFinder[Model[Container,Vessel,"2mL Tube"]],
			ObjectP[Model[Container,Rack]]
		],
		Example[{Basic, "Returns a rack model given a 50mL tube:"},
			RackFinder[Model[Container,Vessel,"50mL Tube"]],
			ObjectP[Model[Container,Rack]]
		],
		Example[{Options, ReturnAllRacks, "Specify to return all possible racks:"},
			RackFinder[Model[Container,Vessel,"50mL Tube"], ReturnAllRacks->True],
			{ObjectP[Model[Container,Rack]]..},
			Stubs :> {
				(* doing this because the 50mL Tube racks are not DeveloperObject and are real and we want to see them *)
				$DeveloperSearch = False
			}
		],
		Example[{Options, RequireSinglePositionPosition, "Return the rack that only have single potision: "},
			RackFinder[
				{
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "15mL Tube"]
				},
				RequireSinglePositionPosition -> True
			],
			{
				ObjectP[Model[Container, Rack, "id:GmzlKjY5EEdE"]],
				ObjectP[Model[Container, Rack, "id:R8e1PjRDbbo7"]]
			}
		],
		Example[{Options, ThermalConductiveRack, "Return the metallic rack for HIAC:"},
			RackFinder[
				{
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "15mL Tube"]
				},
				ThermalConductiveRack->True
			],
			{
				ObjectP[Model[Container, Rack, "50mL HIAC Tube Rack"]],
				ObjectP[Model[Container, Rack, "15mL HIAC Tube Rack"]]
			},
			Stubs :> {
				(* doing this because the HIAC rack is not DeveloperObject and is real and we want to see it *)
				$DeveloperSearch = False
			}
		],
		Example[{Options, Cache, "Pass the cache to the function:"},
			RackFinder[Model[Container,Vessel,"50mL Tube"], Cache->ToList[Download[Model[Container,Vessel,"50mL Tube"],Packet[All]]]],
			ObjectP[Model[Container,Rack]]
		]
	},
	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$DeveloperSearch = True
	},
	SetUp :> {
		ClearDownload[];
		ClearMemoization[];
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test bench for RackFinder tests" <> $SessionUUID],
				Model[Container, Rack, "Test rack model for RackFinder tests" <> $SessionUUID],
				Object[Container, Rack, "Test rack object for RackFinder tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		Module[{testBench, testModelRack, testRack},
			{
				testBench,
				testModelRack
			} = Upload[{
				<|
					Type -> Object[Container, Bench],
					Name -> "Test bench for RackFinder tests" <> $SessionUUID,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]
				|>,
				(* note that this thing is deliberately invalid because I want to make sure the mere existence of an invalid rack not to break everything *)
				<|
					Type -> Model[Container, Rack],
					DeveloperObject -> True,
					Name -> "Test rack model for RackFinder tests" <> $SessionUUID
				|>
			}];
			testRack = ECL`InternalUpload`UploadSample[
				testModelRack,
				{"Work Surface", testBench},
				Name -> "Test rack object for RackFinder tests" <> $SessionUUID,
				FastTrack -> True
			];
			Upload[<|Object -> testRack, DeveloperObject -> True|>]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test bench for RackFinder tests" <> $SessionUUID],
				Model[Container, Rack, "Test rack model for RackFinder tests" <> $SessionUUID],
				Object[Container, Rack, "Test rack object for RackFinder tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		]
	)
];