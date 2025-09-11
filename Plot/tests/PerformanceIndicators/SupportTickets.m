(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*GreaterDateQ*)

DefineTests[GreaterDateQ, {
	Example[{Basic, "Compare two dates:"},
		GreaterDateQ[Today, Today - 2 Day],
		True
	],
	Example[{Basic, "Compare two dates:"},
		GreaterDateQ[Today, Today],
		False
	],
	Example[{Basic, "Compare two dates:"},
		GreaterDateQ[Today-5 Day, Today - 2 Day],
		False
	]
	}
];

(* ::Subsection:: *)
(*GreaterEqualDateQ*)

DefineTests[GreaterEqualDateQ, {
	Example[{Basic, "Compare two dates:"},
		GreaterEqualDateQ[Today, Today - 2 Day],
		True
	],
	Example[{Basic, "Compare two dates:"},
		GreaterEqualDateQ[Today, Today],
		True
	],
	Example[{Basic, "Compare two dates:"},
		GreaterEqualDateQ[Today-5 Day, Today - 2 Day],
		False
	]
	}
];

(* ::Subsection:: *)
(*LessDateQ*)

DefineTests[LessDateQ, {
	Example[{Basic, "Compare two dates:"},
		LessDateQ[Today - 2 Day, Today],
		True
	],
	Example[{Basic, "Compare two dates:"},
		LessDateQ[Today, Today],
		False
	],
	Example[{Basic, "Compare two dates:"},
		LessDateQ[Today - 2 Day, Today-5 Day],
		False
	]
}
];

(* ::Subsection:: *)
(*LessEqualDateQ*)

DefineTests[LessEqualDateQ, {
	Example[{Basic, "Compare two dates:"},
		LessEqualDateQ[Today - 2 Day, Today],
		True
	],
	Example[{Basic, "Compare two dates:"},
		LessEqualDateQ[Today, Today],
		True
	],
	Example[{Basic, "Compare two dates:"},
		LessEqualDateQ[Today - 2 Day, Today-5 Day],
		False
	]
}
];

(* ::Subsection:: *)
(*EqualDateQ*)

DefineTests[EqualDateQ, {
	Example[{Basic, "Compare two dates:"},
		EqualDateQ[Today - 2 Day, Today],
		False
	],
	Example[{Basic, "Compare two dates:"},
		EqualDateQ[Today, Today],
		True
	]
}
];

(* ::Subsection:: *)
(*minTime*)

DefineTests[minTime, {
	Example[{Basic, "Pick the oldest date from a list of 3 dates:"},
		minTime[{Today - 2 Day, Today, DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4.]}],
		_?DateObjectQ
	],
	Example[{Basic, "Pick the oldest date from a list of two dates:"},
		minTime[{Today, DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4.]}],
		_?DateObjectQ
	],
	Example[{Basic, "Pick the oldest date from a list of 1 date:"},
		minTime[{DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4.], DateObject[{2021,1,1,0,0,0}, "Instant", "Gregorian", -4.]}],
		_?DateObjectQ
	]
}
];

(* ::Subsection:: *)
(*LessEqualDateQ*)

DefineTests[maxTime, {
	Example[{Basic, "Pick the newest date from a list of 3 dates:"},
		maxTime[{DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4], DateObject[{2011,1,1,0,0,0}, "Instant", "Gregorian", -4], DateObject[{2021,1,1,0,0,0}, "Instant", "Gregorian", -4]}],
		_?DateObjectQ
	],
	Example[{Basic, "Pick the newest date from a list of two dates:"},
		maxTime[{DateObject[{2021,1,1,0,0,0}, "Instant", "Gregorian", -4.], DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4.]}],
		_?DateObjectQ
	],
	Example[{Basic, "Pick the oldest date from a list of 1 date:"},
		maxTime[{DateObject[{2001,1,1,0,0,0}, "Instant", "Gregorian", -4.]}],
		_?DateObjectQ
	]
}
];


(* ::Subsection:: *)
(*PlotSupportRate*)
DefineTests[PlotSupportRate, {
	Example[{Basic, "Create a grid of plots of troubleshooting rate between last 2 month to last month:"},
		PlotSupportRate[Today - 2 Month, Today - 1 Month],
		_Grid
	],
	Example[{Basic, "Create a grid of plots of troubleshooting rate with given time period:"},
		PlotSupportRate[1 Week],
		_Grid,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a grid of plots of troubleshooting rate with no input:"},
		PlotSupportRate[],
		_Grid,
		Stubs :> {Today = DateObject[List[2025, 1, 15, 13, 27, 32.4604522`], "Instant", "Gregorian", -4.`]}
	]
}
];

(* ::Subsection:: *)
(*PlotSupportDistributions*)
DefineTests[PlotSupportDistributions, {
		Example[{Basic, "Create a histogram of troubleshooting with no input:"},
			PlotSupportDistributions[],
			_Legended
		],
		Example[{Basic, "Create a histogram of troubleshooting for protocol type RSP and HPLC:"},
			PlotSupportDistributions[{Object[Protocol, RoboticSamplePreparation], Object[Protocol, HPLC]}],
			_Legended
		],
		Example[{Basic, "Create a histogram of troubleshooting for protocol type MSP for the last week"},
			PlotSupportDistributions[{Object[Protocol, ManualSamplePreparation]}, 1 Week],
			_Legended
		],
		Example[{Basic, "Create a histogram of troubleshooting for protocol type HPLC and MSP between last 2 month to last month:"},
			PlotSupportDistributions[{Object[Protocol, HPLC], Object[Protocol, ManualSamplePreparation]}, Today - 2 Month, Today - 1 Month],
			_Legended
		],
		Example[{Message, "NoProtocols", "Print a message and returns $Failed if no protocols with selected protocol types exist within the requested date range:"},
			PlotSupportDistributions[{Object[Protocol, RoboticSamplePreparation]}, 1 Week],
			$Failed,
			Messages :> {PlotSupportDistributions::NoProtocols}
		],
		Example[{Additional, "Create a histogram of troubleshooting when no trouble shooting tickets for specified protocol type is found:"},
			PlotSupportDistributions[{Object[Protocol, HPLC]}, 1 Week],
			_Legended
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$RequiredSearchName = "TroubleshootingDistributions",
		$DeveloperSearch = True
	},
	SymbolSetUp :> (
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for TroubleshootingDistributions" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions water sample" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions RSP protocol" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 1" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 2" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 3" <> $SessionUUID],
				Object[Sample, "TroubleshootingDistributions HPLC sample" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol without ticket" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol with ticket 1" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol with ticket 2" <> $SessionUUID],
				Object[Protocol, RoboticSamplePreparation, "TroubleshootingDistributions RSP protocol with ticket" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 1" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 2" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 3" <> $SessionUUID]
			};
			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				allObjects, testBench, plate1, plate2, plate3, plate4, plate5, hplcSample, protocol1, protocol2, protocol3,
				protocol4, protocol5, protocol6, protocol7, notebook, tickets
			},
			allObjects = {
				Object[Container, Bench, "Test bench for TroubleshootingDistributions" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions water sample" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions RSP protocol" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 1" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 2" <> $SessionUUID],
				Object[Container, Plate, "Plate for TroubleshootingDistributions MSP protocol 3" <> $SessionUUID],
				Object[Sample, "TroubleshootingDistributions HPLC sample" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol without ticket" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol with ticket 1" <> $SessionUUID],
				Object[Protocol, HPLC, "TroubleshootingDistributions HPLC protocol with ticket 2" <> $SessionUUID],
				Object[Protocol, RoboticSamplePreparation, "TroubleshootingDistributions RSP protocol with ticket" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 1" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 2" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "TroubleshootingDistributions MSP protocol with ticket 3" <> $SessionUUID]
			};
			(* Create a test water sample to generate test HPLC protocol. *)
			testBench = Upload[<|
				Type  ->  Object[Container, Bench],
				Model  ->  Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name  ->  "Test bench for TroubleshootingDistributions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject  ->  True
			|>];
			plate1 = ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				{"Work Surface", testBench},
				Name -> "Plate for TroubleshootingDistributions water sample" <> $SessionUUID
			];
			hplcSample = ECL`InternalUpload`UploadSample[
				Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
				{"A1", plate1},
				InitialAmount -> 100 Microliter,
				Name -> "TroubleshootingDistributions HPLC sample" <> $SessionUUID
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {plate1, hplcSample};

			(* Create a test container to generate test RSP protocol. *)
			plate2 = ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				{"Work Surface", testBench},
				Name -> "Plate for TroubleshootingDistributions RSP protocol" <> $SessionUUID
			];
			(* Create test containers to generate test MSP protocol. *)
			plate3 = ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well UV-Star Plate"],
				{"Work Surface", testBench},
				Name -> "Plate for TroubleshootingDistributions MSP protocol 1" <> $SessionUUID
			];
			plate4 = ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well UV-Star Plate"],
				{"Work Surface", testBench},
				Name -> "Plate for TroubleshootingDistributions MSP protocol 2" <> $SessionUUID
			];
			plate5= ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well UV-Star Plate"],
				{"Work Surface", testBench},
				Name -> "Plate for TroubleshootingDistributions MSP protocol 3" <> $SessionUUID
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {plate2, plate3, plate4, plate5};

			(* Generate test HPLC, RSP, MSP protocols. *)
			protocol1 = ExperimentHPLC[hplcSample];
			protocol2 = ExperimentHPLC[hplcSample];
			protocol3 = ExperimentHPLC[hplcSample];
			protocol4 = ExperimentRoboticSamplePreparation[Cover[Sample -> plate2]];
			protocol5 = ExperimentManualSamplePreparation[Cover[Sample -> plate3]];
			protocol6 = ExperimentManualSamplePreparation[Cover[Sample -> plate4]];
			protocol7 = ExperimentManualSamplePreparation[Cover[Sample -> plate5]];

			(* Update protocol status. *)
			Upload[<|
				Object -> protocol1,
				Name -> "TroubleshootingDistributions HPLC protocol without ticket" <> $SessionUUID,
				DateCreated -> Today - 1 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol2,
				Name -> "TroubleshootingDistributions HPLC protocol with ticket 1" <> $SessionUUID,
				DateCreated -> Today - 1 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol3,
				Name -> "TroubleshootingDistributions HPLC protocol with ticket 2" <> $SessionUUID,
				DateCreated -> Today - 40 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today - 39 Day, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol4,
				Name -> "TroubleshootingDistributions RSP protocol with ticket" <> $SessionUUID,
				DateCreated -> Today - 10 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today - 9 Day, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol5,
				Name -> "TroubleshootingDistributions MSP protocol with ticket 1" <> $SessionUUID,
				DateCreated -> Today - 1 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol6,
				Name -> "TroubleshootingDistributions MSP protocol with ticket 2" <> $SessionUUID,
				DateCreated -> Today - 3 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today - 4 Day, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];
			Upload[<|
				Object -> protocol7,
				Name -> "TroubleshootingDistributions MSP protocol with ticket 3" <> $SessionUUID,
				DateCreated -> Today - 40 Day,
				Status -> Completed,
				Replace[StatusLog] -> {{Today - 39 Day, Completed, Link[$PersonID]}},
				DeveloperObject -> True
			|>];

			(* Create Notebook. *)
			notebook = Upload[<|Type -> Object[LaboratoryNotebook]|>];
			Upload[<|Object -> notebook, DeveloperObject -> True|>];

			(* Create Tickets. *)
			tickets = RequestSupport[
				{
					{Operations, "Missing Resource", "Couldn't find Object[Container,Vessel,\"id:ABC\"]"},
					{Operations, "My robot is dead and crying", "I come to it and see nothing but tears."},
					{Operations, "Spilled Sample", "I accidentally knocked over Object[Container, Plate,\"Plate for TroubleshootingDistributions RSP protocol\" <> $SessionUUID]"},
					{Operations, "Spilled Sample", "I accidentally knocked over Object[Container, Plate,\"Plate for TroubleshootingDistributions MSP protocol 1\" <> $SessionUUID]"},
					{Operations, "Spilled Sample", "I accidentally knocked over Object[Container, Plate,\"Plate for TroubleshootingDistributions MSP protocol 2\" <> $SessionUUID]"},
					{Operations, "Spilled Sample", "I accidentally knocked over Object[Container, Plate,\"Plate for TroubleshootingDistributions MSP protocol 3\" <> $SessionUUID]"}
				},
				AffectedProtocol -> {protocol2, protocol3, protocol4, protocol5, protocol6, protocol7},
				SourceProtocol -> {protocol2, protocol3, protocol4, protocol5, protocol6, protocol7},
				ErrorCategory -> {"Missing Items", Null, Null, Null, Null, Null},
				Resolved -> {True, False, False, True, True, True},
				Blocked -> {False, False, True, False, False, False},
				Notebook -> notebook,
				SystematicChanges -> {True, False, False, False, False, False}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ tickets;
		];
	),
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection:: *)
(*PlotTotalSupportRate*)
DefineTests[PlotTotalSupportRate, {
	Example[{Basic, "Create a grid of plots of total troubleshooting rate for a month:"},
		PlotTotalSupportRate[1 Month],
		_Grid,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a grid of plots of total troubleshooting rate for the last month with 2 day interval:"},
		PlotTotalSupportRate[1 Month, 2 Day],
		_Grid,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a grid of plots of total troubleshooting rate between last 2 month to last month with 1 day interval:"},
		PlotTotalSupportRate[Today - 2 Month,Today - 1 Month, 1 Day],
		_Grid
	],
	Example[{Options, Site, "Create a grid of plots of total troubleshooting rate between last 2 month to last month with 1 day interval for all sites:"},
		PlotTotalSupportRate[Today - 2 Month,Today - 1 Month, 1 Day, Site->Null],
		_Grid
	],
	Example[{Options, Site, "Create a grid of plots of total troubleshooting rate between last 2 month to last month with 1 day interval for the specified site:"},
		PlotTotalSupportRate[Today - 2 Month,Today - 1 Month, 1 Day, Site->$Site],
		_Grid
	]
}
];

	(* ::Subsection:: *)
	(*PlotSupportTimeline*)
DefineTests[PlotSupportTimeline, {
		Example[{Basic, "Show overall troubleshooting rates for the last month"},
			PlotSupportTimeline[],
			ValidGraphicsP[]
		],
		Example[{Basic, "Create a plot showing troubleshooting for the last two weeks:"},
			PlotSupportTimeline[2 Week],
			ValidGraphicsP[]
		],
		Example[{Basic, "Fully specify the start date, end date and time interval for the data:"},
			PlotSupportTimeline[Today-7 Day, Today-1 Day, 1 Day],
			ValidGraphicsP[]
		],
		Example[{Basic, "Include specific protocol types to display troubleshooting rates for specific protocols:"},
			PlotSupportTimeline[Object[Protocol,ImageSample], Today-7 Day, Today-1 Day, 1 Day],
			ValidGraphicsP[]
		],
		Example[{Additional, "Specify that data should be shown for the last week with a time interval of 1 day:"},
			PlotSupportTimeline[1 Week, 1 Day],
			ValidGraphicsP[]
		],
		Example[{Messages, "NoProtocols", "Print a message and returns $Failed if no protocols exist within the requested date range:"},
			PlotSupportTimeline[Object[Protocol, CapillaryGelElectrophoresisSDS], 1 Week, 1 Day],
			$Failed,
			Messages :> {PlotSupportTimeline::NoProtocols}
		],
		Example[{Options, Tags, "Display the troubleshooting protocols with ErrorCategory -> \"Missing Items\":"},
			PlotSupportTimeline[Today-7 Day, Today-1 Day, 1 Day, Tags -> "Missing Items"],
			ValidGraphicsP[]
		],
		Example[{Options, Annotation, "Include a vertical line epilog demarcating an event:"},
			PlotSupportTimeline[Today-7 Day, Today-1 Day, 1 Day, Annotation -> {Today-3 Day, "VLM Outage"}],
			ValidGraphicsP[]
		],
		Example[{Options, SampleManipulationSplit, "Divides SampleManipulation protocols into MicroLiquidHandling or MacroLiquidHandling:"},
			PlotSupportTimeline[Object[Protocol, SampleManipulation], Today-7 Day, Today-1 Day, 1 Day, SampleManipulationSplit -> True],
			ValidGraphicsP[]
		],
		Example[{Options, RemoveMonitoringTickets, "Indicate that monitoring tickets such as long tasks and force quits should be shown:"},
			PlotSupportTimeline[Object[Protocol, ManualSamplePreparation], Today-7 Day, Today-1 Day, 1 Day, RemoveMonitoringTickets -> False],
			ValidGraphicsP[]
		],
		Example[{Options, Display, "Show both the rate (tickets/protocol) and the number of tickets:"},
			PlotSupportTimeline[Object[Protocol,ManualSamplePreparation], Today-7 Day, Today-1 Day, 1 Day, Display -> Both],
			_Pane
		],
		Example[{Options, SearchCriteria, "Add additional criteria to the search:"},
			PlotSupportTimeline[Object[Protocol,ImageSample], Today-7 Day, Today-1 Day, 1 Day, Display -> Both],
			_Pane
		],
		Example[{Options, ExcludeCanaryProtocols, "Indicates if the tickets generated for a root canary protocol should be shown:"},
			PlotSupportTimeline[Object[Protocol,ManualSamplePreparation], Today-7 Day, Today-1 Day, 1 Day, ExcludeCanaryProtocols -> True],
			ValidGraphicsP[]
		]
	},
	Stubs :> {
		$RequiredSearchName = "TroubleshootingTimeline",
		$DeveloperSearch = True
	},
	SymbolSetUp :> Module[{notebookPacket,notebook,tubePacket,tube1,tube2,waterSample1,
		waterSample2,protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,protocol7,protocol8,protocol9,protocol10,tickets,
		statusPackets,namePackets},

		$CreatedObjects={};

		notebookPacket = <|Type -> Object[LaboratoryNotebook]|>;
		tubePacket = <|Type -> Object[Container,Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects]|>;

		{tube1, tube2, notebook} = Upload[{tubePacket, tubePacket, notebookPacket}];

		{waterSample1, waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", tube1}, {"A1", tube2}},
			ECL`InternalUpload`InitialAmount -> {100 Microliter, 100 Microliter}
		];

		protocol1 = ExperimentImageSample[waterSample1];
		protocol2 = ExperimentImageSample[waterSample2];
		protocol3 = ExperimentImageSample[waterSample1];
		protocol4 = ExperimentImageSample[waterSample1];
		{protocol5,protocol6,protocol7,protocol8,protocol9,protocol10} = Upload[{
			<|Type -> Object[Protocol, SampleManipulation], LiquidHandlingScale -> MicroLiquidHandling|>,
			<|Type -> Object[Protocol, SampleManipulation], LiquidHandlingScale -> MicroLiquidHandling|>,
			<|Type -> Object[Protocol, SampleManipulation], LiquidHandlingScale -> MacroLiquidHandling|>,
			<|Type -> Object[Protocol, ManualSamplePreparation]|>,
			<|Type -> Object[Protocol, ManualSamplePreparation]|>,
			<|Type -> Object[Protocol, ManualSamplePreparation]|>
		}];

		Upload[<|Object -> #, RootProtocol -> Link[#]|>& /@ {protocol5,protocol6,protocol7,protocol8,protocol9,protocol10}];

		tickets = RequestSupport[
			{
				{Operations, "Compile Error", "Compile threw Missing[NotFound]"},
				{Operations, "Parse Error", "Parser return $Failed"},
				{Operations, "Missing Resource", "Couldn't find Object[Container,Vessel,\"id:ABC\"]"},
				{Operations, "My robot is dead and crying", "I come to it and see nothing but tears."},
				{Operations, "Instrument gears grinding", "Loud grinding noise when camera moves"},
				{Operations, "Spilled Sample", "I accidentally knocked over Object[Container,Vessel,\"id:123\"]"}

			},
			AffectedProtocol  ->  {protocol1, protocol2, protocol3, protocol5, protocol4,protocol6},
			SourceProtocol  ->  {protocol1, protocol2, protocol3, protocol5, protocol4,protocol6},
			ErrorCategory  ->  {"Science Function Error", "Science Function Error", "Missing Items",Null,Null,Null},
			Resolved  ->  {True, False, False, False, False, False},
			Blocked  ->  {False, False, True, True, True, True},
			Notebook  ->  notebook,
			SystematicChanges  ->  {True, False, False, False, False, False}
		];

		RequestSupport[Last[tickets], Blocked -> False];

		statusPackets=MapIndexed[
			With[
				(* make sure all are created within 1 week *)
				{date=Now-Mod[First[#2], 7, 1]*Day},
				<|
					Object -> #1,
					DateCompleted -> date,
					Status -> Completed,
					Replace[StatusLog] -> {{date, Completed, Link[$PersonID]}}
				|>
			]&,
			{protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,protocol7,protocol8,protocol9,protocol10}
		];

		namePackets = Map[
			<|
				Object -> #,
				Name -> StringReplace[#[ID] <> " TroubleshootingTimeline", "id:" -> ""],
				DeveloperObject -> True
			|>&,
			Join[tickets, {notebook,tube1,tube2,waterSample1,waterSample2,protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,protocol7,protocol8,protocol9,protocol10}]
		];

		Upload[Join[statusPackets,namePackets]]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects,Force -> True,Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection:: *)
(*PlotSampleManipulationSupportTimeline*)
DefineTests[PlotSampleManipulationSupportTimeline, {
	Example[{Basic, "Create a plot of troubleshooting timeline of protocol type MSP with no input:"},
		PlotSampleManipulationSupportTimeline[],
		_Legended,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a plot of troubleshooting timeline of protocol type MSP in the last 2 weeks:"},
		PlotSampleManipulationSupportTimeline[2 Week],
		_Legended,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a plot of troubleshooting timeline of protocol type MSP in the last week with 1 day interval:"},
		PlotSampleManipulationSupportTimeline[1 Week, 1 Day],
		_Legended,
		Stubs :> {Today = Now -2 Month}
	],
	Example[{Basic, "Create a plot of troubleshooting timeline of protocol type MSP between last 2 month to last month:"},
		PlotSampleManipulationSupportTimeline[Today - 2 Month, Today - 1 Month, 1 Day],
		_Legended
	]
}
];

(* ::Subsection::Closed:: *)
(* TroubleshootingTable *)
DefineTests[TroubleshootingTable,
    {
        Example[{Basic, "Show all tickets associated with a given protocol type over the last week (the ticket occurred within a root or subprotocol of this type):"},
            TroubleshootingTable[Object[Protocol, ImageSample]],
            _Pane|{}
        ],
		Example[{Basic, "Look for specific tickets by specifying blocking tickets created in the last week that haven't yet been resolved:"},
			TroubleshootingTable[Object[Protocol, ImageSample], 1 Week, Blocker -> True, Resolved -> False],
			_Pane|{}
		],
		Example[{Basic, "Use All to indicate you'd like to see tickets for any ticket created in the last 3 days:"},
			TroubleshootingTable[All, 3 Day],
			_Pane|{}
		],
		Example[{Basic, "Directly indicate the protocols whose tickets should be shown:"},
			TroubleshootingTable[{Object[Protocol, ImageSample, "Test Protocol 1 TroubleshootingTable "<>$SessionUUID], Object[Protocol,ImageSample, "Test Protocol 2 TroubleshootingTable "<>$SessionUUID]}, 1 Week],
			_Pane|{}
		],
		Example[{Messages, "NoTicketsFound", "If the search criteria specified in the option are too strict no tickets may be found:"},
			TroubleshootingTable[Object[Protocol, ImageSample], Now + 1 Day, Now + 2 Day],
			Null,
			Messages :> {TroubleshootingTable::NoTicketsFound}
		],
		Example[{Options,Blocker, "Indicate you want to show non blocking tickets created in the last week:"},
			TroubleshootingTable[Object[Protocol, ImageSample], 1 Week, Blocker -> False],
			_Pane|{}
		],
		Example[{Options,Resolved, "Indicate you want to show open tickets created from 2.5 days ago to now:"},
			TroubleshootingTable[Object[Protocol, ImageSample], Now - 2.6 Day, Now, Resolved -> False],
			_Pane|{}
		],
		Example[{Options,SystematicChanges, "Indicate you want to show tickets that have root cause fixes pushed in the last 3 months:"},
			TroubleshootingTable[All,3 Month, SystematicChanges -> True],
			_Pane|{}
		],
		Example[{Options,Detailed, "Indicate you want to show a table with additional timing and customer information:"},
			TroubleshootingTable[Object[Protocol, ImageSample], 1 Week, Blocker -> True,Detailed -> True],
			_Pane|{}
		],
		Example[{Options,ErrorCategory, "Show only tickets tagged as \"Science Function Error\" errors:"},
			TroubleshootingTable[Object[Protocol, ImageSample], 1 Week, ErrorCategory -> "Science Function Error"],
			_Pane|{}
		],
		Example[{Options,ErrorCategory, "Show only tickets for Micro SM protocols:"},
			TroubleshootingTable[Object[Protocol, SampleManipulation], 1 Week, MicroLiquidHandling -> True],
			_Pane | {}
		],
		Example[{Options,RemoveMonitoringTickets, "Indicate that monitoring tickets such as long tasks and force quits should be shown:"},
			TroubleshootingTable[Object[Protocol, ManualSamplePreparation], Now-10 Day, Now, RemoveMonitoringTickets -> False],
			_Pane | {}
		]
	},
	Stubs :> {
		$RequiredSearchName="TroubleshootingTable",
		$DeveloperSearch=True
	},
	SymbolSetUp :> Module[{notebookPacket,notebook,tubePacket,tube1,tube2,waterSample1,
		waterSample2,protocol1,protocol2,protocol3,protocol4,protocol5,protocol6,tickets},

		$CreatedObjects={};

		notebookPacket = <|Type -> Object[LaboratoryNotebook]|>;
		tubePacket = <|Type -> Object[Container,Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects]|>;

		{tube1, tube2, notebook} = Upload[{tubePacket, tubePacket, notebookPacket}];

		{waterSample1, waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", tube1}, {"A1", tube2}},
			ECL`InternalUpload`InitialAmount -> {100 Microliter, 100 Microliter}
		];

		protocol1 = ExperimentImageSample[waterSample1];
		protocol2 = ExperimentImageSample[waterSample2];
		protocol3 = ExperimentImageSample[waterSample1];
		protocol4 = ExperimentImageSample[waterSample1];
		{protocol5, protocol6} = Upload[{
			<|Type -> Object[Protocol, SampleManipulation], LiquidHandlingScale -> MicroLiquidHandling|>,
			<|Type -> Object[Protocol, ManualSamplePreparation]|>
		}];
		Upload[<|Object -> #, RootProtocol -> Link[#]|>& /@ {protocol5,protocol6}];

		tickets = RequestSupport[
			{
				{Operations, "Compile Error", "Compile threw Missing[NotFound]"},
				{Operations, "Parse Error", "Parser return $Failed"},
				{Operations, "Missing Resource", "Couldn't find Object[Container,Vessel,\"id:ABC\"]"},
				{Operations, "My robot is dead and crying", "I come to it and see nothing but tears."},
				{Operations, "Instrument gears grinding", "Loud grinding noise when camera moves"},
				{Operations, "Instrument gears grinding", "Loud grinding noise when camera moves"}
			},
			AffectedProtocol  ->  {protocol1, protocol2, protocol3, protocol5, protocol4,protocol6},
			SourceProtocol  ->  {protocol1, protocol2, protocol3, protocol5, protocol4,protocol6},
			ErrorCategory  ->  {"Science Function Error", "Science Function Error", "Missing Items",Null,Null,Null},
			Resolved -> {True, False, False, False, False,False},
			Blocked -> {False, False, True, True, True,True},
			Notebook -> notebook,
			SystematicChanges -> {True, False, False, False, False, False}
		];

		RequestSupport[Last[tickets], Blocked -> False];

		Upload[
			Map[
				<|
					Object -> #,
					OperationStatus -> ScientificSupport,
					Replace[StatusLog] -> {{Now - 3 Hour, ScientificSupport, Link[$PersonID]}}
				|>&,
				{protocol3, protocol4}
			]
		];

		Upload[
			Join[
				Map[
					<|
						Object -> #,
						Name -> StringReplace[#[ID] <> " TroubleshootingTable", "id:" -> ""],
						DeveloperObject -> True
					|>&,
					Join[tickets, {notebook,tube1,tube2,waterSample1,waterSample2,protocol3,protocol4,protocol5,protocol6}]
				],
				{
					<|
						Object -> protocol1,
						Name -> "Test Protocol 1 TroubleshootingTable " <> $SessionUUID,
						DeveloperObject -> True
					|>,
					<|
						Object -> protocol2,
						Name -> "Test Protocol 2 TroubleshootingTable " <> $SessionUUID,
						DeveloperObject -> True
					|>
				}
			]
		]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(* TroubleshootingTable *)
DefineTests[BlockerTable,
	{
		Example[{Basic, "Show all open blocking tickets:"},
			BlockerTable[],
			_Pane|{}
		],
		Example[{Basic, "Blocker table calls TroubleshootingTable and inherits its options:"},
			BlockerTable[3 Day],
			_Pane|{}
		]
	},
	Stubs :> {
		$RequiredSearchName="BlockerTable",
		$DeveloperSearch=True
	},
	SymbolSetUp :> Module[{notebookPacket,tubePacket,tube1,tube2,notebook,waterSample1,waterSample2,protocol1,protocol2,tickets},
		$CreatedObjects={};

		notebookPacket = <|Type -> Object[LaboratoryNotebook]|>;
		tubePacket = <|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects]|>;

		{tube1, tube2, notebook} = Upload[{tubePacket, tubePacket, notebookPacket}];

		{waterSample1, waterSample2} = ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", tube1}, {"A1", tube2}},
			ECL`InternalUpload`InitialAmount -> {100 Microliter,100 Microliter}
		];

		protocol1 = ExperimentPAGE[{waterSample1,waterSample2}];
		protocol2 = ExperimentPAGE[{waterSample1,waterSample2}];

		tickets = RequestSupport[
			{
				{Operations, "Sad Compile", "Really Sad"},
				{Operations, "Sad Parse", "Really Sad"}
			},
			AffectedProtocol -> {protocol1, protocol2},
			ErrorCategory -> {"Science Function Error", "Science Function Error"},
			Notebook -> notebook,
			Blocked -> {True, True}
		];

		Upload[
			Map[
				<|Object -> #,Name -> StringReplace[#[ID] <> " BlockerTable", "id:"  ->  ""], DeveloperObject -> True|>&,
				Join[tickets, {notebook, tube1, tube2, waterSample1, waterSample2, protocol1, protocol2}]
			]
		]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(* TroubleshootingErrorSources *)
DefineTests[TroubleshootingErrorSources,
	{
		Example[{Basic, "Show all unique troubleshooting tags:"},
			TroubleshootingErrorSources[],
			{_String..}
		],
		Example[{Test, "Show all unique troubleshooting tags:"},
			TroubleshootingErrorSources["Memoize me"],
			{_String..}
		]
	},
	Stubs :> {
		$RequiredSearchName = "TroubleshootingErrorSources",
		$DeveloperSearch = True
	},
	SymbolSetUp :> Module[
		{notebook, tickets},
		$CreatedObjects = {};

		notebook = Upload[<|Type  ->  Object[LaboratoryNotebook]|>];

		tickets = RequestSupport[
			{
				{Operations, "Sad Compile", "Really Sad"},
				{Operations, "Sad Parse", "Really Sad"}
			},
			Notebook  ->  notebook,
			ErrorCategory  ->  {"Science Function Error", "Science Function Error"}
		];

		Upload[<|Object -> #, Name -> StringReplace[#[ID] <> " TroubleshootingErrorSources", "id:"  ->  ""], DeveloperObject -> True|>& /@ tickets]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(* PlotLongTaskTimeline *)
DefineTests[PlotLongTaskTimeline,
	{
		Example[{Basic, "Show the percentage of tasks that were classified as long tasks in the last month for all protocols:"},
			PlotLongTaskTimeline[],
			ValidGraphicsP[]
		],
		Example[{Basic, "Show the absolute number of long tasks in the last 5 days:"},
			PlotLongTaskTimeline[5 Day, 1 Day, Display -> Absolute],
			ValidGraphicsP[]
		],
		Example[{Basic, "Show tasks in MeasureVolume protocols during a specific period that look longer than expected:"},
			PlotLongTaskTimeline[Object[Protocol, MeasureVolume], Now - 5 Day, Now - 1 Day, Day],
			ValidGraphicsP[]
		],
		Example[{Options,LongTaskTime, "Specify that any tasks that took more than 20 minutes should be shown:"},
			PlotLongTaskTimeline[5 Day, LongTaskTime -> 20 Minute],
			ValidGraphicsP[]
		],
		Example[{Options,Display, "Indicate that the total number of long tasks should be shown along with the relative number:"},
			PlotLongTaskTimeline[5 Day, Display  ->  All],
			_Grid
		],
		Example[{Options,OutputFormat, "Indicate that the output should be raw data in lieu of a plot:"},
			PlotLongTaskTimeline[5 Day, Display  ->  All, OutputFormat  ->  List],
			{_Rule, _Rule, _Rule, _Rule}
		]
	},
	Stubs :> {
		$RequiredSearchName = "PlotLongTaskTimeline",
		$DeveloperSearch = True
	},
	SymbolSetUp :> Module[
		{tubePacket,tube1,tube2,waterSample1,waterSample2,protocol1,protocol2,protocol3,namePackets,completedTasksPackets},
		$CreatedObjects={};

		tubePacket = <|Type -> Object[Container,Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects]|>;

		{tube1, tube2} = Upload[{tubePacket, tubePacket}];

		{waterSample1, waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", tube1}, {"A1", tube2}},
			ECL`InternalUpload`InitialAmount -> {100 Microliter, 100 Microliter}
		];

		protocol1 = ExperimentImageSample[waterSample1];
		protocol2 = ExperimentImageSample[waterSample2];
		protocol3 = ExperimentMeasureVolume[waterSample1];

		namePackets = <|Object -> #, Name -> StringReplace[#[ID] <> " PlotLongTaskTimeline", "id:"  ->  ""], DeveloperObject -> True|>& /@ {protocol1, protocol2, protocol3};

		completedTasksPackets={
			<|
				Object -> protocol1,
				DateStarted -> (Now - 7 Day),
				Replace[CompletedTasks] -> {
					{Now - 3 Day, Now - 3 Day + 50 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 3 Day, Now - 3 Day + 50 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 50 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 5 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 1 Day, Now - 1 Day + 50 Minute,Link[$PersonID], "123", "ResourcePicking"}
				}
			|>,
			<|
				Object -> protocol2,
				DateStarted -> (Now - 6 Day),
				Replace[CompletedTasks] -> {
					{Now - 3 Day, Now - 3 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 3 Day, Now - 3 Day + 5 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 5 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 1 Day, Now - 1 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"}
				}
			|>,
			<|
				Object -> protocol3,
				DateStarted -> (Now - 5 Day),
				Replace[CompletedTasks] -> {
					{Now - 3 Day, Now - 3 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 3 Day, Now - 3 Day + 5 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 2 Day, Now - 2 Day + 5 Minute,Link[$PersonID], "123", "ResourcePicking"},
					{Now - 1 Day, Now - 1 Day + 555 Minute,Link[$PersonID], "123", "ResourcePicking"}
				}
			|>
		};

		Upload[Join[namePackets, completedTasksPackets]]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
]