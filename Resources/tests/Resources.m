(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Resources: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Resource*)


DefineTests[
	Resource,
	{
		Example[{Basic, "Constructs a sample Resource construct:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter
			],
			_?ValidResourceQ
		],
		Example[{Basic, "Constructs a instrument Resource construct:"},
			Resource[
				Instrument -> Model[Instrument, Pipette, "Pipet-Aid XP"],
				Time -> 1 Hour
			],
			_?ValidResourceQ
		],
		Example[{Basic, "Constructs an operator Resource construct:"},
			Resource[
				Operator -> Object[User, Emerald, Operator, "id:dORYzZJ5YV3E"],
				Time -> 3 Hour
			],
			_?ValidResourceQ
		],
		Example[{Basic, "Construct a waste Resource construct:"},
			Resource[
				Waste -> Model[Sample, "Chemical Waste"],
				Amount -> 5 Kilogram
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Allows dereferencing from construct:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter
			][Sample],
			Model[Sample, "Absolute Ethanol, Anhydrous"]
		],
		Example[{Additional, "Name a resource that needs to be referenced from different fields:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter,
				Name -> "Reused Ethanol Resource"
			][Name],
			"Reused Ethanol Resource"
		],
		Example[{Additional, "Sample Resource can be a specific sample:"},
			Resource[
				Sample -> Object[Sample, "id:WNa4ZjKovzeZ"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Sample Resource can list multiple acceptable modelContainers:"},
			Resource[
				Sample -> Object[Sample, "id:WNa4ZjKovzeZ"],
				Container -> {
					Model[Container, Vessel, "250mL Glass Bottle"],
					Model[Container, Vessel, "500mL Glass Bottle"],
					Model[Container, Vessel, "1L Glass Bottle"]
				},
				Amount -> 100 Milli Liter
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Sample Resource can be a specified with a unitless amount, indicating a discrete number is required:"},
			Resource[
				Sample -> Model[Item, Consumable, "Disposable Pasteur Glass Pipet"],
				Amount -> 3
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Use UpdateCount->False to indicate the UploadResourceStatus should not update the count field in the picked sample when marking the resource as fulfilled:"},
			Resource[
				Sample -> Model[Item, Consumable, "Disposable Pasteur Glass Pipet"],
				Amount -> 3,
				UpdateCount -> False
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Indicate that we should dispose of the sample picked to satisfy the resource if we have to make it:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter,
				AutomaticDisposal -> False
			][AutomaticDisposal],
			False
		],
		Example[{Additional, "Indicate that a resource that can be used to handle (e.g. filter) specific amount of liquid will be requested:"},
			Resource[
				Sample -> Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 30 kDa"],
				VolumeOfUses -> 100 Milliliter
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Instrument Resource be multiple acceptable models:"},
			Resource[
				Instrument -> {Model[Instrument, Pipette, "PIPETMAN P200"], Model[Instrument, Pipette, "PIPETMAN P1000"]},
				Time -> 1 Hour
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Instrument Resource can be a specific instrument:"},
			Resource[
				Instrument -> Object[Instrument, Pipette, "id:n0k9mGzRaDDn"],
				Time -> 1 Hour
			],
			_?ValidResourceQ
		],
		Example[{Additional, "The number of required uses can be specified for a sample resource:"},
			Resource[
				Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
				NumberOfUses -> 10
			],
			_?ValidResourceQ
		],
		Example[{Additional, "ContainerName and Well can be specified to indicate where the resource should be prepared:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Amount -> 100 Micro Liter,
				ContainerName -> "test",
				Well -> "A1"
			],
			_?ValidResourceQ
		],
		Example[{Additional, "Sterile can be specified to indicate if the sample to be picked must be sterile:"},
			Resource[
				Sample -> Model[Sample, "Nuclease-free Water"],
				Container -> Model[Container, Vessel, "2mL Tube"],
				Amount -> 100 Microliter,
				Sterile -> True
			],
			_?ValidResourceQ
		],
		Example[{Messages, "InvalidResource", "Shows a message when a mandatory key is missing:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"]
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "Shows a message when specification has invalid keys:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Thing -> "invalid key"
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "Shows a message when keys have invalid values:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> "invalid key"
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "AmbiguousType", "Returns $Failed when the resource type is ambiguous:"},
			Resource[
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> "invalid key"
			],
			$Failed,
			Messages :> {Message[Resource::AmbiguousType]}
		],
		Example[{Messages, "InvalidResource", "Shows a message when more then one type of model of sample is requested at the same time:"},
			Resource[Sample -> {Model[Sample, "Absolute Ethanol, Anhydrous"], Model[Sample, StockSolution, "70% Ethanol"]}, Amount -> 1 Liter],
			_Resource,
			Messages :> {Resource::InvalidResource}
		],
		Example[{Messages, "InvalidResource", "Shows a message when the number of operators is not equal the length of time needed:"},
			Resource[Operator -> Object[User, "id:-1"], Time -> {2 Hour, 4 Hour}],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "Shows a message when the a water resource isn't provided with a container:"},
			Resource[Sample -> Model[Sample, "Milli-Q water"],
				Amount -> 1 Liter],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "Container can only be specified for non-self-contained samples:"},
			Resource[
				Sample -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"]
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "ContainerName and Well can only be specified with when Container is specified:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Amount -> 100 Micro Liter,
				ContainerName -> "test",
				Well -> "A1"
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],
		Example[{Messages, "InvalidResource", "ContainerName and Well keys must be both specified or both Null:"},
			Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Amount -> 100 Micro Liter,
				ContainerName -> "test"
			],
			_Resource,
			Messages :> {Message[Resource::InvalidResource]}
		],

		Test["Extracts the underlying object when Sample is specified as a sample blob:",
			Resource[
				Sample -> Sample[Model -> Model[Sample, "Absolute Ethanol, Anhydrous"]],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter
			][Sample],
			Model[Sample, "Absolute Ethanol, Anhydrous"]
		],
		Test["Extracts the underlying object when Sample is specified as a container blob:",
			Resource[
				Sample -> Container[Model -> Model[Container,Plate,"96-well 2mL Deep Well Plate"]]
			][Sample],
			Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		]
	}
];


(* ::Subsection::Closed:: *)
(*ValidResourceQ*)


DefineTests[
	ValidResourceQ,
	{
		Example[{Basic, "Takes in a sample Resource and returns a booleans indicating if all tests have passed:"},
			ValidResourceQ[Resource[
				Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
				Container -> Model[Container, Vessel, "250mL Glass Bottle"],
				Amount -> 100 Milli Liter]],
			True
		],
		Example[{Basic, "Takes in an instrument Resource and returns a booleans indicating if all tests have passed:"},
			ValidResourceQ[Resource[
				Instrument -> Model[Instrument, Pipette, "Pipet-Aid XP"],
				Time -> 1 Hour
			]],
			True
		],
		Example[{Basic, "Takes in an operator Resource and returns a booleans indicating if all tests have passed:"},
			ValidResourceQ[Resource[
				Operator -> Object[User, Emerald, Developer, "id:zGj91a7b9wPE"],
				Time -> 1 Hour
			]],
			True
		],
		Example[{Basic, "Takes in a waste Resource and returns a boolean indicating if all tests have passed:"},
			ValidResourceQ[Resource[
				Waste -> Model[Sample, "Chemical Waste"],
				Amount -> 5 Kilogram
			]],
			True
		],
		Example[{Additional, "Takes in multiple Resource and returns a single boolean indicating if all are valid:"},
			ValidResourceQ[{
				Resource[
					Sample -> Model[Sample, "Isopropanol"],
					Container -> Model[Container, Vessel, "500mL Glass Bottle"],
					Amount -> 100 Milli Liter],
				Resource[
					Instrument -> Model[Instrument, Pipette, "EasyPet 3"],
					Time -> 1 Hour
				],
				Resource[
					Operator -> Object[User, Emerald, Developer, "id:zGj91a7b9wPE"],
					Time -> 1 Hour
				]
			}
			],
			True
		],

		Example[{Additional, "If a resource is created for a specific sample and in a model container, amount must be specified:"},
			ValidResourceQ[
				Resource[
					Association[
						Sample -> Object[Sample, "id:WNa4ZjKovzeZ"],
						Container -> Model[Container, Vessel, "250mL Glass Bottle"],
						Type -> Object[Resource, Sample]
					]
				]
			],
			False
		],

		Example[{Additional, "Fresh->True can only be specified for a stock solution sample:"},
			ValidResourceQ[
				Resource[
					Association[
						Sample -> Model[Sample, "Isopropanol"],
						Amount-> 1 Liter,
						Fresh -> True,
						Type -> Object[Resource, Sample]
					]
				]
			],
			False
		],

		Test["Allow Fresh->True:",
			ValidResourceQ[
				Resource[
					Association[
						Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],
						Amount-> 1 Liter,
						Fresh -> True,
						Type -> Object[Resource, Sample]
					]
				]
			],
			True
		],
		Test["Allow specifying NumberOfUses:",
			ValidResourceQ[
				Resource[Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
					NumberOfUses -> 5]
			],
			True
		],
		Example[{Options, Verbose, "Verbose->True dynamically prints results of each Test as they are run:"},
			ValidResourceQ[
				Resource[
					Sample -> Model[Sample, "Piperidine"],
					Container -> Model[Container, Vessel, "250mL Glass Bottle"],
					Amount -> 100 Milli Liter
				],
				Verbose -> True],
			True
		],
		Example[{Options, OutputFormat, "OutputFormat->Boolean when given a list of Resources, returns a single of results:"},
			ValidResourceQ[{
				Resource[
					Sample -> Model[Sample, "Trifluoroacetic acid"],
					Container -> Model[Container, Vessel, "250mL Glass Bottle, Sterile"],
					Amount -> 100 Milli Liter],
				Resource[
					Instrument -> Model[Instrument, Pipette, "Sterile Cell Culture Pipet-Aid XP"],
					Time -> 1 Hour
				],
				Resource[
					Operator -> Object[User, Emerald, Developer, "id:zGj91a7b9wPE"],
					Time -> 1 Hour
				]
			}, OutputFormat->Boolean
			],
			{True, True, True}
		],
		Test["Rent can't be set for a fluid sample:",
			ValidResourceQ[
				Resource[
					Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
					Container -> Model[Container, Vessel, "250mL Glass Bottle"],
					Amount -> 100 Milli Liter,
					Rent -> True
				]
			],
			False,
			Messages :> Message[Resource::InvalidResource]
		],
		Test["RentContainer can't be set for a non-fluid sample:",
			ValidResourceQ[
				Resource[
					Sample -> Model[Container, Vessel, "2mL Tube"],
					RentContainer -> True
				]
			],
			False,
			Messages :> Message[Resource::InvalidResource]
		],
		Test["Untracked can't be set if Amount is specified:",
			ValidResourceQ[
				Resource[
					Sample -> Model[Sample, "Absolute Ethanol, Anhydrous"],
					Amount -> 100 Milli Liter,
					Untracked -> True
				]
			],
			False,
			Messages :> Message[Resource::InvalidResource]
		]
	}
];


(* ::Subsection::Closed:: *)
(*RequireResources*)


DefineTests[
	RequireResources,
	{
		Example[{Basic, "Returns a list of packets consisting of the protocol packet with the RequiredResources field populated, as well as the list of new resource packets:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					Replace[Checkpoints] -> {
						{"Preparing Samples", 2 Hour, "Samples and ladders are prepared for loading into the gel.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 1*Hour]]},
						{"Running the Gel", 4 Hour, "Samples are separated according to their electrophoretic mobility.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]},
						{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]}
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>,
				Upload -> False
			],
			{Alternatives[PacketP[Object[Protocol, PAGE]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Operator]], PacketP[Object[Resource, Operator]], PacketP[Object[Resource, Operator]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Instrument]], PacketP[Object[Resource, Operator]], PacketP[Object[Resource, Operator]], PacketP[Object[Resource, Operator]]]..}
		],
		Example[{Basic, "Returns the object(s) that were updated and for which resources were created:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			],
			ObjectP[Object[Protocol, PAGE]],
			Variables :> {protocol}
		],
		Example[{Basic, "Successfully populate the RequiredResources field of a protocol for an indexed multiple field:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[InstrumentLog] -> {
						{Now, Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]},
						{Now + 1*Second, Link[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]]},
						{Now + 2*Second, Link[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]]},
						{Now + 3*Second, Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]}
					}
				|>
			];
			Download[protocol, RequiredResources],
			{
				{ObjectP[Object[Resource, Instrument]], InstrumentLog, 1, 2},
				{ObjectP[Object[Resource, Instrument]], InstrumentLog, 4, 2}
			},
			Variables :> {protocol}
		],
		Example[{Basic, "Upload a protocol with prepared samples:"},
			protocol = ExperimentCentrifuge["Container 1",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Container 1",
						Container -> Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]
					],
					Transfer[
						Source -> Model[Sample, "Isopropanol"],
						Amount -> 30*Microliter,
						Destination -> {"A1", "Container 1"}
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 30*Microliter,
						Destination -> {"A2", "Container 1"}
					]
				}
			];
			Download[protocol, {RequiredResources, PreparedSamples, SamplesIn}],
			{
				{Except[{_, SamplesIn, _, _}]..},
				{
					{_String, SamplesIn, 1, Null, Null},
					{_String, SamplesIn, 2, Null, Null},
					{"Container 1", ContainersIn, 1, Null, Null}
				},
				{Except[ObjectP[Object[Sample]]], Except[ObjectP[Object[Sample]]]}
			},
			Variables :> {protocol}
		],
		Example[{Additional, "It is not necessary to wrap Resource representations with Link in unambiguous cases:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]],
						Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]],
						Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>,
				Upload -> False
			],
			{Alternatives[
				PacketP[Object[Protocol, PAGE]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Instrument]]
			]..}
		],
		Example[{Basic, "Returns a list of packets consisting of the protocol packet with the RequiredResources field populated, as well as the list of new resource packets, using Object Samples that have populated TransportConditions:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE,"id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels]->{
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					Replace[Checkpoints] -> {
						{"Preparing Samples", 2 Hour, "Samples and ladders are prepared for loading into the gel.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 1*Hour]]},
						{"Running the Gel", 4 Hour, "Samples are separated according to their electrophoretic mobility.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]},
						{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]}
					},
					ReservoirBuffer -> Link[Resource[Sample -> Object[Sample, "1X TBE buffer with 7M Urea with TransportCondition Chilled" <> $SessionUUID], Amount -> Quantity[100,"Milliliters"],Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Object[Sample, "1X TBE buffer with 7M Urea with TransportCondition Chilled" <> $SessionUUID], Amount -> Quantity[100,"Milliliters"],Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3,"Hours"]]]
				|>,
				Upload -> False
			],

			{Alternatives[
				PacketP[Object[Protocol, PAGE]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Operator]],
				PacketP[Object[Resource, Operator]],
				PacketP[Object[Resource, Operator]],
				PacketP[Object[Resource, Sample]],
				PacketP[Object[Resource, Instrument]],
				PacketP[Object[Resource, Operator]],
				PacketP[Object[Resource, Operator]],
				PacketP[Object[Resource, Operator]]]..}
		],
		Example[{Additional, "Successfully populates ContainerName and Well keys in Object[Resource], if specified in the Resource blob:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[1, "Milliliters"]
						]
					],
					GelBuffer -> Link[
						Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]
					]
				|>
			];
			resources = Download[protocol, RequiredResources][[All, 1]];
			Download[resources, {ContainerName, Well}],
			{{"test", "A1"}, {Null, Null}},
			Variables :> {protocol, resources}
		],
		Example[{Additional,UnusedIntegratedInstrument, "Successfully populates UnusedIntegratedInstrument key in Object[Resource,Instrument], if specified in the Resource blob:"},
			Module[{protocol,resources},
				protocol=RequireResources[
					<|
						Type->Object[Protocol,RoboticSamplePreparation],
						Replace[RequiredInstruments]->{
							Link[Resource[Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],Time->5Minute,UnusedIntegratedInstrument->True]],
							Link[Resource[Instrument->Model[Instrument,Centrifuge,"VSpin"],Time->5Minute]]
						},
						DeveloperObject->True
					|>
				];
				resources=Download[protocol,RequiredResources][[All,1]];
				Download[resources,UnusedIntegratedInstrument]
			],
			{True,Null}
		],
		Example[{Options, RootProtocol, "Specify the root protocol (i.e., the highest-level parent of the current protocol) to be placed into all resources:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>,
				RootProtocol -> Object[Protocol, PAGE, "id:n0k9mG81EPA1"]
			];
			Download[protocol, RequiredResources[[All, 1]][RootProtocol][Object]],
			{ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]]..},
			Variables :> {protocol}
		],
		Example[{Options, RootProtocol, "Specify the root protocol with with a list of protocols if providing more than one packet:"},
			protocols = RequireResources[
				{
					<|
						Type -> Object[Protocol, PAGE],
						Replace[Gels] -> {
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
						},
						ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
					|>,
					<|
						Type -> Object[Protocol, Transfer],
						Replace[SamplesIn] -> {
							Link[Resource[Sample -> Object[Sample, "id:3em6ZvL4prMB"], Amount -> 10*Milliliter], Protocols],
							Link[Resource[Sample -> Model[Sample, "id:M8n3rx0DjPrE"], Amount -> 10*Milliliter], Protocols]
						}
					|>
				},
				RootProtocol -> {Object[Protocol, PAGE, "id:n0k9mG81EPA1"], Object[Protocol, PAGE, "id:6V0npvmJXqe8"]}
			];
			{Download[protocols[[1]], RequiredResources[[All, 1]][RootProtocol][Object]], Download[protocols[[2]], RequiredResources[[All, 1]][RootProtocol][Object]]},
			{
				{ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]]..},
				{ObjectP[Object[Protocol, PAGE, "id:6V0npvmJXqe8"]]}
			},
			Variables :> {protocols}
		],
		Example[{Options, Upload, "If Upload -> False, return all change packets, comprised of both the updated parent packet and the new resource packets:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>,
				Upload -> False
			],
			{Alternatives[PacketP[Object[Protocol, PAGE]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Sample]], PacketP[Object[Resource, Instrument]]]..}
		],
		Example[{Options, SimulationMode, "If SimulationMode -> True, then use SimulateCreateID to make the IDs.  This is faster than using CreateID if we're not uploading anyway.  However, these IDs cannot be uploaded; an error will be thrown:"},
			RequireResources[
				{
					<|
						Type -> Object[Protocol, PAGE],
						Replace[Gels] -> {
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
						},
						ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
					|>
				},
				RootProtocol -> {Object[Protocol, PAGE, "id:n0k9mG81EPA1"]},
				SimulationMode -> True
			],
			$Failed,
			Messages :> {Upload::MissingObject}
		],
		Example[{Options, SimulationMode, "If SimulationMode -> True, then use SimulateCreateID to make the IDs.  This is faster than using CreateID if we're not uploading anyway:"},
			RequireResources[
				{
					<|
						Type -> Object[Protocol, PAGE],
						Replace[Gels] -> {
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
						},
						ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
						Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
					|>
				},
				RootProtocol -> {Object[Protocol, PAGE, "id:n0k9mG81EPA1"]},
				SimulationMode -> True,
				Upload -> False
			],
			{PacketP[]..}
		],
		Example[{Messages, "OptionLengthMismatch", "If the length of the input objects doesn't match the length of the RootProtocol option (only if RootProtocol is specified as a list), throw an error:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>,
				RootProtocol -> {Object[Protocol, PAGE, "id:n0k9mG81EPA1"], Object[Protocol, PAGE, "id:6V0npvmJXqe8"]}
			],
			$Failed,
			Messages :> {RequireResources::OptionLengthMismatch}
		],
		Example[{Messages, "AmbiguousName", "Fail if the same Name has been used for two different Resources:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"],Name -> "Bad Name"]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "Bad Name"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			],
			$Failed,
			Messages :> {RequireResources::AmbiguousName}
		],
		Example[{Messages, "AmbiguousRelation", "Fields with ambiguous backlinks must have Link wrapped around any Resource representations:"},
			RequireResources[
				<|
					Object -> Object[Protocol, PAGE, "id:54n6evLrOmEP"],
					Type -> Object[Protocol, PAGE],
					Replace[ContainersOut] -> {Resource[Sample -> Model[Container, Vessel, "2mL Tube"]]}
				|>
			],
			$Failed,
			Messages :> {RequireResources::AmbiguousRelation}
		],
		Example[{Messages, "InvalidDestinationWell", "The requested well must exist in the requested container model(s):"},
			RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "O1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			],
			$Failed,
			Messages :> {RequireResources::InvalidDestinationWell}
		],
		Example[{Messages, "DuplicateDestinationWell", "Error if multiple resource representations with different resource parameters are requested in the same Well of the same ContainerName:"},
			RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					],
					GelBuffer -> Link[
						Resource[
							Sample -> Model[Sample, "Milli-Q water"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			],
			$Failed,
			Messages :> {RequireResources::DuplicateDestinationWell}
		],
		Example[{Messages, "ConflictContainerModels", "Error if the same ContainerName is assigned to different lists of container models in different resources:"},
			RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					],
					GelBuffer -> Link[
						Resource[
							Sample -> Model[Sample, "Milli-Q water"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
							ContainerName -> "test",
							Well -> "A2",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			],
			$Failed,
			Messages :> {RequireResources::ConflictContainerModels}
		],
		Example[{Messages, "InvalidExistingContainerName", "Error if the newly requested resource has a conflicting container model request with an existing resource:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			];
			RequireResources[
				<|
					Object -> protocol,
					GelBuffer -> Link[
						Resource[
							Sample -> Model[Sample, "Milli-Q water"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
							ContainerName -> "test",
							Well -> "A2",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			],
			$Failed,
			Messages :> {RequireResources::InvalidExistingContainerName},
			Variables :> {protocol}
		],
		Example[{Messages, "InvalidExistingContainerName", "Error if the newly requested resource has a conflicting well request with an existing resource:"},
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[
						Resource[
							Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			];
			RequireResources[
				<|
					Object -> protocol,
					GelBuffer -> Link[
						Resource[
							Sample -> Model[Sample, "Milli-Q water"],
							Container -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "384-well UV-Star Plate"]},
							ContainerName -> "test",
							Well -> "A1",
							Amount -> Quantity[0.1, "Milliliters"]
						]
					]
				|>
			],
			$Failed,
			Messages :> {RequireResources::InvalidExistingContainerName},
			Variables :> {protocol}
		],
		Test["Successfully populate the RequiredResources field of a protocol for normal Single and Multiple fields:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			];
			Download[protocol, RequiredResources],
			{
				{ObjectP[Object[Resource, Sample]], Gels, 1, Null},
				{ObjectP[Object[Resource, Sample]], Gels, 2, Null},
				{ObjectP[Object[Resource, Sample]], Gels, 3, Null},
				{ObjectP[Object[Resource, Sample]], ReservoirBuffer, Null, Null},
				{ObjectP[Object[Resource, Sample]], GelBuffer, Null, Null},
				{ObjectP[Object[Resource, Instrument]], Instrument, Null, Null}
			},
			Variables :> {protocol}
		],
		Test["Successfully populate the RequiredResources field of a protocol for named multiple fields:",
			protocol = RequireResources[
				<|
					Type -> Object[Qualification,EngineBenchmark],
					Replace[Tools] -> {
						<|
							Screwdriver -> Link[Resource[Sample -> Model[Item, Screwdriver,"id:BYDOjv15p03l"]]],
							RubberMallet -> Link[Resource[Sample -> Model[Item, RubberMallet,"id:KBL5DvYkXZ4k"]]]
						|>
					}
				|>
			];
			Download[protocol, RequiredResources],
			{
				{ObjectP[Object[Resource, Sample]], Tools, 1, Screwdriver},
				{ObjectP[Object[Resource, Sample]], Tools, 1, RubberMallet}
			},
			Variables :> {protocol}
		],
		Test["If one resource is used to populate two separate fields, the same resource object is in both entries to RequiredResources:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			];
			{resource1, resource2} = Download[protocol, {RequiredResources[[4, 1]][Object], RequiredResources[[5, 1]][Object]}];
			resource1 === resource2,
			True,
			Variables :> {protocol, resource1, resource2}
		],
		Test["Populate the protocol fields with the proper values:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Object[Item, Gel, "id:mnk9jOR0Lrvb"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
					Instrument -> Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]
				|>
			];
			Download[protocol, {Gels, ReservoirBuffer, GelBuffer, Instrument}],
			{
				{
					ObjectP[Model[Item, Gel, "id:KBL5DvYl3eJw"]],
					ObjectP[Model[Item, Gel, "id:KBL5DvYl3eJw"]],
					ObjectP[Object[Item, Gel, "id:mnk9jOR0Lrvb"]]
				},
				ObjectP[Model[Sample, StockSolution, "id:WNa4ZjRr5l94"]],
				ObjectP[Model[Sample, StockSolution, "id:WNa4ZjRr5l94"]],
				ObjectP[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]]
			},
			Variables :> {protocol}
		],
		Test["Handle things properly if there are no resources at all:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					ReservoirBuffer -> Link[Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"]]
				|>
			],
			ObjectP[Object[Protocol, PAGE]],
			Variables :> {protocol}
		],
		Test["Handle case where resource and method packets are passed in (these are accepted but nothing happens with them):",
			RequireResources[
				{
					<|
						Type -> Object[Protocol, PAGE],
						Replace[Gels] -> {
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
							Link[Resource[Sample -> Object[Item, Gel, "id:mnk9jOR0Lrvb"]]]
						},
						ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
						GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
						Instrument -> Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]
					|>,
					<|
						Type -> Object[Resource, Sample],
						Name -> "Fake resource 1"
					|>,
					<|
						Type -> Object[Method, Gradient],
						Name -> "Fake gradient method 1"
					|>
				},
				Upload -> False
			],
			{PacketP[]..}
		],
		Test["Populate the resource fields with the proper values:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"],Untracked->True]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"],Rent->True]],
						Link[Resource[Sample -> Object[Item, Gel, "id:mnk9jOR0Lrvb"]]]
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Container -> Model[Container, Vessel, "250mL Glass Bottle"],Amount -> Quantity[100, "Milliliters"], Fresh -> True, RentContainer->True]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
					Instrument -> Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"], DeckLayout -> Model[DeckLayout,"Test DeckLayout for Electrophoresis Instrument for RequireResources"]]]
				|>,
				RootProtocol -> Object[Protocol, PAGE, "id:n0k9mG81EPA1"]
			];
			resources = Download[protocol, RequiredResources[[All, 1]][Object]];
			Quiet[Download[resources, {Object, Status, DateInCart, RootProtocol, Sample, Models, Instrument, InstrumentModels, EstimatedTime, DeckLayouts, Fresh, Rent,RentContainer,Untracked}]],
			{
				{
					ObjectP[Object[Resource, Sample]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					Null,
					{ObjectP[Model[Item, Gel, "id:KBL5DvYl3eJw"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed,
					Null,
					Null,
					Null,
					True
				},
				{
					ObjectP[Object[Resource, Sample]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					Null,
					{ObjectP[Model[Item, Gel, "id:KBL5DvYl3eJw"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed,
					Null,
					True,
					Null,
					Null
				},
				{
					ObjectP[Object[Resource, Sample]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					ObjectP[Object[Item, Gel, "id:mnk9jOR0Lrvb"]],
					{ObjectP[Model[Item, Gel, "id:KBL5DvYl3eJw"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed,
					Null,
					Null,
					Null,
					Null
				},
				{
					ObjectP[Object[Resource, Sample]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					Null,
					{ObjectP[Model[Sample, StockSolution, "id:WNa4ZjRr5l94"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed,
					True,
					Null,
					True,
					Null
				},
				{
					ObjectP[Object[Resource, Sample]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					Null,
					{ObjectP[Model[Sample, StockSolution, "id:WNa4ZjRr5l94"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed,
					Null,
					Null,
					Null,
					Null
				},
				{
					ObjectP[Object[Resource, Instrument]],
					InCart,
					_?DateObjectQ,
					ObjectP[Object[Protocol, PAGE, "id:n0k9mG81EPA1"]],
					$Failed,
					$Failed,
					ObjectP[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]],
					{ObjectP[Model[Instrument, Electrophoresis, "id:J8AY5jwzPPE7"]]},
					UnitsP[Hour],
					{ObjectP[Model[DeckLayout,"Test DeckLayout for Electrophoresis Instrument for RequireResources"]]},
					$Failed,
					$Failed,
					$Failed,
					$Failed
				}
			},
			Variables :> {protocol, resources}
		],
		Test["Successfully populate the RequiredResources field of a protocol for an indexed multiple field:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[InstrumentLog] -> {
						{Now, Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]},
						{Now + 1*Second, Link[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]]},
						{Now + 2*Second, Link[Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"]]},
						{Now + 3*Second, Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]}
					}
				|>
			];
			Download[protocol, RequiredResources],
			{
				{ObjectP[Object[Resource, Instrument]], InstrumentLog, 1, 2},
				{ObjectP[Object[Resource, Instrument]], InstrumentLog, 4, 2}
			},
			Variables :> {protocol}
		],
		Test["Successfully populate the RequiredResources field of Model item that has limitation on how much volume this item can be used for:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, CrossFlowFiltration],
					Replace[CrossFlowFilters] -> {
						Link[
							Resource[
								Sample -> Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 10 kDa"],
								Name -> "Test resource " <> ToString[Unique[]],
								VolumeOfUses ->100 Milliliter
							]
						],
						Link[
							Resource[
								Sample -> Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 30 kDa"],
								Name -> "Test resource " <> ToString[Unique[]],
								VolumeOfUses ->50 Milliliter
							]
						],
						Link[
							Resource[
								Sample -> Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 50 kDa"],
								Name -> "Test resource " <> ToString[Unique[]],
								VolumeOfUses ->75 Milliliter
							]
						]
					}
				|>
			];
			Download[protocol, RequiredResources],
			{
				{ObjectP[Object[Resource, Sample]], CrossFlowFilters, 1, Null},
				{ObjectP[Object[Resource, Sample]], CrossFlowFilters, 2, Null},
				{ObjectP[Object[Resource, Sample]], CrossFlowFilters, 3, Null}
			},
			Variables :> {protocol}
		],
		Test["Populate the Checkpoint and EstimatedTime field of operator resources created in a given entry of RequireResources:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					Replace[Checkpoints] -> {
						{"Preparing Samples", 2 Hour, "Samples and ladders are prepared for loading into the gel.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 1*Hour]]},
						{"Running the Gel", 4 Hour, "Samples are separated according to their electrophoretic mobility.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]},
						{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]}
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			];
			operatorResources = Cases[Download[protocol, RequiredResources[[All, 1]]], ObjectP[Object[Resource, Operator]]];
			Download[operatorResources, {Checkpoint, EstimatedTime}],
			{
				{"Preparing Samples", EqualP[1 Hour]},
				{"Running the Gel", EqualP[30 Minute]},
				{"Returning Materials", EqualP[30 Minute]}
			},
			Variables :> {protocol, operatorResources}
		],
		Test["Populate the Checkpoint field of operator resources created in a given entry of RequireResources:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, PAGE],
					Replace[Gels] -> {
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
						Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]]
					},
					Replace[Checkpoints] -> {
						{"Preparing Samples", 2 Hour, "Samples and ladders are prepared for loading into the gel.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 1*Hour]]},
						{"Running the Gel", 4 Hour, "Samples are separated according to their electrophoretic mobility.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]},
						{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:mnk9jOR04Yzm"], Time -> 30*Minute]]}
					},
					ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"], Name -> "TBE Buffer Resource"]],
					Instrument -> Link[Resource[Instrument -> Model[Instrument, Electrophoresis, "Ranger"], Time -> Quantity[3, "Hours"]]]
				|>
			];
			Download[protocol, Checkpoints],
			{
				{"Preparing Samples", UnitsP[Minute], "Samples and ladders are prepared for loading into the gel.", ObjectP[Model[User, Emerald]]},
				{"Running the Gel", UnitsP[Minute], "Samples are separated according to their electrophoretic mobility.", ObjectP[Model[User, Emerald]]},
				{"Returning Materials", UnitsP[Minute], "Samples are returned to storage.", ObjectP[Model[User, Emerald]]}
			},
			Variables :> {protocol}
		],
		Test["If a subprotocol is requesting a specific sample that the parent protocol already has reserved, do not create a resource for this item:",
			protocol = RequireResources[
				<|
					Type -> Object[Protocol, Transfer],
					Replace[SamplesIn] -> {
						Link[Resource[Sample -> Object[Sample, "id:3em6ZvL4prMB"], Amount -> 10*Milliliter], Protocols],
						Link[Resource[Sample -> Model[Sample, "id:M8n3rx0DjPrE"], Amount -> 10*Milliliter], Protocols]
					}
				|>,
				RootProtocol -> Object[Protocol, PAGE, "id:6V0npvmJXqe8"]
			];
			Download[protocol, RequiredResources[[All, 1]][{Object, Sample, Models}]],
			(* the key point here is that there is only one resource created and not two; that's because the resource blob requesting a specific sample is already requested by its parent protocol *)
			{{ObjectP[Object[Resource, Sample]], Null, {ObjectP[Model[Sample, "id:M8n3rx0DjPrE"]]}}},
			Variables :> {protocol}
		],
		Test["Auto-generate a container resource for a water resource:",
			protocol = With[
				{id = CreateID[Object[Protocol,HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						BufferD -> Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]
					|>,
					RootProtocol -> id
				]
			];
			Download[protocol, RequiredResources[[All, 1]][{Sample, Models,RootProtocol}]],
			{
				{Null, {ObjectP[Model[Sample, "Milli-Q water"]]},ObjectP[protocol]},
				{Null, {ObjectP[Model[Container, Vessel, "50mL Tube"]]},ObjectP[protocol]}
			},
			Variables :> {protocol}
		],
		Test["Auto-generated container resource has same Requestor as original water resource:",
			protocol = With[
				{id = CreateID[Object[Protocol, HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						BufferD -> Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]
					|>,
					RootProtocol -> id
				]
			];
			Download[protocol, RequiredResources[[All, 1]][Requestor]],
			{
				{ObjectP[protocol]},
				{ObjectP[protocol]}
			},
			Variables :> {protocol}
		],
		Test["Auto-generated container resources and water resources point at each other:",
			protocol = With[
				{id = CreateID[Object[Protocol, HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						BufferD -> Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]
					|>,
					RootProtocol -> id
				]
			];
			SameObjectQ[
				First[Download[protocol, RequiredResources[[All, 1]][ContainerResource]]],
				Download[protocol, RequiredResources[[All, 1]][Object]][[2]]
			],
			True,
			Variables :> {protocol}
		],
		Test["Don't make a container resource when a water resource is under the $MicroWaterMaximum:",
			protocol = With[
				{id = CreateID[Object[Protocol,HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						BufferD -> Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 1 Milliliter, Container -> Model[Container, Vessel, "2mL Tube"]]
					|>,
					RootProtocol -> id
				]
			];
			Download[protocol, RequiredResources[[All, 1]][{Sample, Models, RootProtocol}]],
			{
				{Null, {ObjectP[Model[Sample, "Milli-Q water"]]}, ObjectP[protocol]}
			},
			Variables :> {protocol}
		],
		Test["Sets UpdateCount->False when the resource indicates the count shouldn't be changed and Null when UpdateCount is unspecified or set to True:",
			protocol = With[
				{id = CreateID[Object[Protocol,Transfer]]},
				RequireResources[
					<|
						Object -> id,
						Replace[Tips] -> {
							Resource[Sample -> Model[Item,Tips, "25 mL plastic barrier serological pipets, sterile"],Amount->1],
							Resource[Sample -> Model[Item,Tips, "25 mL plastic barrier serological pipets, sterile"],Amount->1,UpdateCount->True],
							Resource[Sample -> Model[Item,Tips, "1000 uL Hamilton barrier tips, sterile"],Amount->1,UpdateCount->False]
						}
					|>,
					RootProtocol -> id
				]
			];
			Download[protocol, RequiredResources[[All, 1]][{Models,UpdateCount}]],
			{
				{{ObjectP[Model[Item,Tips, "25 mL plastic barrier serological pipets, sterile"]]},Null},
				{{ObjectP[Model[Item,Tips, "25 mL plastic barrier serological pipets, sterile"]]},Null},
				{{ObjectP[Model[Item,Tips, "1000 uL Hamilton barrier tips, sterile"]]},False}
			},
			Variables :> {protocol}
		],
		Test["Sets Rent flag based on the value of RentByDefault, but respects direct setting of Rent:",
			protocol = With[
				{id = CreateID[Object[Protocol, HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						(* BufferACap is RentByDefault = True*)
						BufferACap -> Resource[Sample -> Model[Item, Cap, "id:BYDOjvG8Kp1q"]],
						(* Remaining caps are all RentByDefault = Null *)
						BufferBCap -> Resource[Sample -> Model[Item, Cap, "id:wqW9BP4Y06aR"], Rent -> True],
						BufferCCap -> Resource[Sample -> Model[Item, Cap, "id:wqW9BP4Y06aR"], Rent -> False],
						BufferDCap -> Resource[Sample -> Model[Item, Cap, "id:wqW9BP4Y06aR"]]
					|>,
					RootProtocol -> id
				]
			];
			resourceTuples = Download[protocol, RequiredResources];
			Download[
				{
					FirstCase[resourceTuples, {_,BufferACap,__}],
					FirstCase[resourceTuples, {_,BufferBCap,__}],
					FirstCase[resourceTuples, {_,BufferCCap,__}],
					FirstCase[resourceTuples, {_,BufferDCap,__}]
				}[[All, 1]],
				Rent
			],
			{True,True,Null,Null},
			Variables :> {protocol, resourceTuples}
		],
		Test["Handles the case where the requested sample doesn't have a model:",
			With[
				{id = CreateID[Object[Protocol, HPLC]]},
				RequireResources[
					<|
						Object -> id,
						Type -> Object[Protocol, HPLC],
						BufferA -> Resource[Sample -> Object[Sample, "RequireResources UnitTest No-Model Sample" <> $SessionUUID]]
					|>,
					RootProtocol -> id
				]
			],
			ObjectP[Object[Protocol]]
		],
		Test["Sets AwaitingDisposal appropriately:",
			Module[{protocol},
				protocol=First@RequireResources[
					{
						<|
							Type -> Object[Protocol, PAGE],
							Replace[Gels] -> {
								Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
								Link[Resource[Sample -> Model[Item, Gel, "TBE-Urea cassette, 10%"]]],
								Link[Resource[Sample -> Object[Item, Gel, "id:mnk9jOR0Lrvb"]]]
							},
							ReservoirBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"],AutomaticDisposal->False]],
							GelBuffer -> Link[Resource[Sample -> Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"], Amount -> Quantity[100, "Milliliters"]]],
							Instrument -> Link[Resource[Instrument -> Object[Instrument, Electrophoresis, "id:GmzlKjPxe63X"], Time -> Quantity[3, "Hours"]]]
						|>
					}
				];
				Quiet[Download[protocol, RequiredResources[[All, 1]]][AutomaticDisposal], Download::FieldDoesntExist]
			],
			{True, True, True, False, True, $Failed}
		],
		Test["Populate correct indices for named single field in RequiredResources:",
			protocol=First@RequireResources[
				{
					<|
						Type -> Object[Qualification, EngineBenchmark],
						Hammer -> <|RubberMallet -> Link[Resource[Sample -> Model[Item, RubberMallet,"id:KBL5DvYkXZ4k"]]], Color -> GrayLevel[0]|>
					|>
				}
			];
			Download[protocol, RequiredResources],
			{
				{
					LinkP[Object[Resource]],
					Hammer,
					Null,
					RubberMallet
				}
			},
			Variables :> {protocol}
		],
		Test["Populate correct indices for index single field in RequiredResources:",
			protocol=First@RequireResources[
				{
					<|
						Type -> Object[Protocol, DifferentialScanningCalorimetry],
						CleaningSolutions -> {
							Link[
								Resource[
									Sample -> Model[Sample, "Milli-Q water"],
									Amount -> Quantity[100, "Milliliters"],
									Container -> Model[Container, Vessel, "DSC Wash Vessel"],
									RentContainer -> True
								]
							],
							Null,
							Null
						}
					|>
				}
			];
			Download[protocol, RequiredResources],
			{
				{
					LinkP[Object[Resource]],
					CleaningSolutions,
					1,
					Null
				},
				___
			},
			Variables :> {protocol}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for RequireResources testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for the Buffer" <> $SessionUUID],
					Object[Sample, "1X TBE buffer with 7M Urea with TransportCondition Chilled" <> $SessionUUID],
					Object[Sample, "RequireResources UnitTest No-Model Sample" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
		];
		Module[{testBench, testContainer, testSample},
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Bench for RequireResources testing" <> $SessionUUID,
				DeveloperObject ->True,
				StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
			|>];

			testContainer = ECL`InternalUpload`UploadSample[
				Model[Container, Vessel, "5mL Tube"],
				{"Bench Top Slot", testBench},
				Name -> "Container for the Buffer" <> $SessionUUID
			];

			testSample = ECL`InternalUpload`UploadSample[
				Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
				{"A1", testContainer},
				Name -> "1X TBE buffer with 7M Urea with TransportCondition Chilled" <> $SessionUUID,
				InitialAmount -> 300Milliliter
			];
			Upload[<|Object -> testSample, TransportCondition -> Link[Model[TransportCondition, "Chilled"]]|>];

			Upload[<|Type -> Object[Sample], Name -> "RequireResources UnitTest No-Model Sample" <> $SessionUUID|>];


		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for RequireResources testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for the Buffer" <> $SessionUUID],
					Object[Sample, "1X TBE buffer with 7M Urea with TransportCondition Chilled" <> $SessionUUID],
					Object[Sample, "RequireResources UnitTest No-Model Sample" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
		]
	)
];



(* ::Subsection::Closed:: *)
(*fulfillableResourceQ*)


DefineTests[fulfillableResourceQ,
	{
		Example[{Basic, "Checks to see if a requested resource can be fulfilled given the current state of the lab:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:eGakldJ8oJke"]],
			True
		],
		Example[{Basic, "Checks resource to see if a requested resource can be fulfilled given the current state of the lab:"},
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter]],
			True
		],
		Example[{Basic, "Checks to see if a request on a specific sample has enough volume available to be fulfilled:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:jLq9jXvxpRlx"]],
			True
		],
		Example[{Basic, "Checks to see if a request on a specific sample has enough volume available to be fulfilled:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:N80DNj1pLRrl"], Amount -> 75*Microliter]],
			True
		],
		Example[{Additional, "Checks to see whether an instrument request is fulfillable:"},
			fulfillableResourceQ[{Object[Resource, Instrument, "id:1ZA60vLXepaw"], Object[Resource, Instrument, "id:Z1lqpMzm0O7z"]}],
			True
		],
		Example[{Additional, "Checks to see whether an instrument resource request is fulfillable:"},
			fulfillableResourceQ[
				{
					Resource[Instrument -> Object[Instrument, HPLC, "id:R8e1PjprXOEv"], Time -> 3*Hour],
					Resource[Instrument -> Model[Instrument, HPLC, "id:E8zoYvNjAKnw"], Time -> 3*Hour]
				}
			],
			True
		],
		Example[{Additional, "Checks to see whether an operator request is fulfillable:"},
			fulfillableResourceQ[Object[Resource, Operator, "id:4pO6dM5EwDNr"]],
			True
		],
		Example[{Additional, "Checks to see whether an operator resource request is fulfillable:"},
			fulfillableResourceQ[Resource[Operator -> Object[User, Emerald, Operator, "id:Z1lqpMzm0Pj9"]]],
			True
		],
		Example[{Additional, "Do not check resources that are simulated (backward compatible version, remove after SM is dead):"},
			fulfillableResourceQ[
				{Resource[<|Sample -> Object[Sample, "id:J8AY5jDZxZ8B"], Type -> Object[Resource, Sample]|>], Resource[<|Sample -> Object[Container, Vessel, "id:Q0ht2lIIr0CX"], Type -> Object[Resource, Sample]|>], Resource[ <|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[10, "Minutes"],  Type -> Object[Resource, Operator]|>], Resource[  <|Operator -> Model[User, Emerald, Operator, "Level 1"],    Time -> Quantity[0, "Minutes"],Type -> Object[Resource,Operator]|>], Resource[<|Operator -> Model[User, Emerald,      Operator, "Level 1"], Time -> Quantity[30, "Minutes"], Type -> Object[Resource, Operator]|>], Resource[<|Operator -> Model[User, Emerald,      Operator, "Level 1"],    Time -> Quantity[1, "Hours"], Type -> Object[Resource, Operator]|>], Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[15, "Minutes"], Type -> Object[Resource, Operator]|>]},
				Cache -> {
					<|Object -> Object[Sample, "id:J8AY5jDZxZ8B"], Simulated -> True|>,
					<|Object -> Object[Container, Vessel, "id:Q0ht2lIIr0CX"], Simulated -> True|>
				},
				Simulation -> Simulation[{
					<|Object -> Object[Sample, "id:J8AY5jDZxZ8B"], Simulated -> True|>,
					<|Object -> Object[Container, Vessel, "id:Q0ht2lIIr0CX"], Simulated -> True|>
				}]
			],
			True
		],
		Example[{Additional, "Do not check resources that are simulated:"},
			fulfillableResourceQ[
				{
					Resource[<|Sample -> Object[Sample, "id:J8AY5jDZxZ8B"], Type -> Object[Resource, Sample]|>],
					Resource[<|Sample -> Object[Container, Vessel, "id:Q0ht2lIIr0CX"], Type -> Object[Resource, Sample]|>],
					Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[10, "Minutes"],  Type -> Object[Resource, Operator]|>],
					Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[0, "Minutes"],Type -> Object[Resource,Operator]|>],
					Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[30, "Minutes"], Type -> Object[Resource, Operator]|>],
					Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[1, "Hours"], Type -> Object[Resource, Operator]|>],
					Resource[<|Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> Quantity[15, "Minutes"], Type -> Object[Resource, Operator]|>]
				},
				Simulation->Simulation[
					{
						<|Object->Object[Sample, "id:J8AY5jDZxZ8B"], Status->Available|>,
						<|Object->Object[Container, Vessel, "id:Q0ht2lIIr0CX"], Status->Available|>
					}
				]
			],
			True
		],
		Example[{Options, Messages, "If Messages -> False, suppress the messages thrown indicating why a resource may be invalid:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:pZx9jo8Ad890"], Messages -> False],
			False,
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> Boolean, return a list of Booleans index matched with the inputs:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:pZx9jo8Ad890"]}, OutputFormat -> Boolean],
			{True, False},
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> SingleBoolean (default), return a single Boolean indicating if all provided resources are fulfillable:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:pZx9jo8Ad890"]}, OutputFormat -> SingleBoolean],
			False,
			 Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print which tests failed for each input object:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:pZx9jo8Ad890"]}, Verbose -> Failures],
			False,
			 Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Options, Author, "If the item does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the SamplesNotOwned error:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:o1k9jAGJKbJx"]}, Author -> Object[User, "Fake user 1 for FulfillableResourceQ unit tests"], OutputFormat -> Boolean],
			{True},
			Stubs :> {
				$Notebook = Download[Object[LaboratoryNotebook, "Fake notebook 2 for FulfillableResourceQ unit tests"], Object],
				$PersonID = Object[User, Emerald, Developer, "steven"]
			}
		],
		Example[{Options, Author, "If the item does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the SamplesNotOwned error:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:o1k9jAGJKbJx"]}, Author -> {Object[User, "Fake user 1 for FulfillableResourceQ unit tests"]}, OutputFormat -> Boolean],
			{True},
			Stubs :> {
				$Notebook = Download[Object[LaboratoryNotebook, "Fake notebook 2 for FulfillableResourceQ unit tests"], Object],
				$PersonID = Object[User, Emerald, Developer, "steven"]
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "If a resource is provided that includes an object that does not exist, throw an error and return False:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:2222j3jj3j3"], Amount -> 50*Microliter]],
			False,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "SamplesMarkedForDisposal", "If the requested sample is marked for disposal, throw an error and return False:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:4pO6dM5wa3Xo"], Amount -> 2*Microliter]],
			False,
			Messages :> {Error::SamplesMarkedForDisposal, Error::InvalidInput}
		],
		Example[{Options, Subprotocol, "If the requested sample is marked for disposal but we're in a subprotocol don't throw an error since users can enqueue an experiment and then indicate samples should be diposed on completion:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:4pO6dM5wa3Xo"], Amount -> 2*Microliter],Subprotocol->True],
			True
		],
		Test["Handles the case where the sample is marked for disposal when Subprotocol is True for that specific sample:",
			fulfillableResourceQ[{Resource[Sample -> Object[Sample, "id:4pO6dM5wa3Xo"], Amount -> 2*Microliter],Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter]},Subprotocol->{True,False}],
			True
		],
		Example[{Messages, "DeprecatedModels", "If the requested model is deprecated, throw an error and return False:"},
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, "id:01G6nvwMaEZ7"], Amount -> 50*Microliter], Resource[Sample -> Object[Sample, "id:Vrbp1jK57MVx"], Amount -> 3*Microliter]}, OutputFormat -> Boolean],
			{False, False},
			Messages :> {Error::DeprecatedModels, Error::InvalidInput}
		],
		Example[{Messages, "DiscardedSamples", "If the requested sample is deprecated, throw an error and return False:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:XnlV5jK17Bq8"], Amount -> 2*Microliter]],
			False,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Example[{Messages, "ExpiredSamples", "If the requested sample is expired, throw a warning but still return True:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter]],
			True,
			Messages :> {Warning::ExpiredSamples}
		],
		Example[{Messages, "RentedKit", "If a kit model is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable from kits, throw a message and return False:"},
			fulfillableResourceQ[Resource[Sample -> Model[Item,Column,"Model Column 3 for FulfillableResourceQ unit tests (rented kits)"], Rent -> True]],
			False,
			Messages :> {Error::RentedKit, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Test["If the requested sample is expired but the resource is for a subprotocol don't throw any messages, since we've already started:",
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter],Subprotocol->True],
			True
		],
		Test["If the requested sample is expired and Subprotocol is True for that specific sample don't throw any messages:",
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter],Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter]},Subprotocol->{False,True}],
			True
		],
		Example[{Messages, "OptionLengthMismatch", "If the Subprotocol option is provided but is not index matched with the input, throw an error:"},
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter],Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter]},Subprotocol->{False,True, False}],
			$Failed,
			Messages :> {Error::OptionLengthMismatch}
		],
		Example[{Messages, "RetiredInstrument", "If an instrument is specified but it is retired, throw an error and return False:"},
			fulfillableResourceQ[Resource[Instrument -> Object[Instrument, HPLC, "id:R8e1PjpXWada"], Time -> 3*Hour]],
			False,
			Messages :> {Error::RetiredInstrument, Error::InvalidInput}
		],
		Example[{Messages, "DeprecatedInstrument", "If an instrument is specified but it has a deprecated model, throw an error and return False:"},
			fulfillableResourceQ[Resource[Instrument -> Model[Instrument, HPLC, "id:lYq9jRxnqBAY"], Time -> 3*Hour]],
			False,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput}
		],
		Example[{Messages, "DeckLayoutUnavailable", "If an instrument is specified and the DeckLayout with it is not available for that instrument, throw an error and return False:"},
			fulfillableResourceQ[Resource[Instrument -> Model[Instrument, HPLC, "id:lYq9jRxnqBAY"], DeckLayout -> Model[DeckLayout,"Test DeckLayout for Electrophoresis Instrument for RequireResources"]]],
			False,
			Messages :> {Error::DeprecatedInstrument, Error::DeckLayoutUnavailable, Error::InvalidInput}
		],
		Example[{Messages, "InstrumentUndergoingMaintenance", "If an instrument is specified but it is undergoing maintenance, throw a warning but still return True:"},
			fulfillableResourceQ[Resource[Instrument -> Object[Instrument, HPLC, "id:vXl9j578l1Pk"], Time -> 4*Hour]],
			True,
			Messages :> {Warning::InstrumentUndergoingMaintenance}
		],
		Example[{Messages, "InsufficientTotalVolume", "If a model chemical is requested and the amount requested exceeds the total volume available in the lab across all samples, throw a message and return False for that resource:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:pZx9jo8Ad890"]}, OutputFormat -> Boolean],
			{True, False},
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Messages, "InsufficientTotalVolume", "If a model chemical is requested and the amount requested exceeds the total volume available in the lab across all samples, throw a message and return False for that resource:"},
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 4*Liter]],
			False,
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Test["If a model chemical is requested and there are zero instances of any kind of that model in the lab, throw a message and return False for that resource:",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Fake model with no objects or product for fulfillableResources unit tests"], Amount -> 5*Milligram]],
			False,
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableModel", "If a consumable model is requested and all copies in the lab are currently reserved, throw a message and return False for that resource:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:R8e1PjprLp1K"]],
			False,
			Messages :> {Error::NoAvailableModel, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableModel", "If a consumable model is requested in a resource and all copies in the lab are currently reserved, throw a message and return False for that resource:"},
			fulfillableResourceQ[Resource[Sample -> Model[Item,Consumable,"id:vXl9j578pWOd"]]],
			False,
			Messages :> {Error::NoAvailableModel, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableSample", "If a kit model is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable from kits, this is actually fine and this is True:"},
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Test Benz[a]anthracene for fulfillableResources kit tests"], Amount -> 1.1*Gram]],
			True,
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		(* note that this used to throw the NoAvailableSample message, but now it doesn't do that anymore and throws InsufficientTotalVolume.  It could conceivably still hit that error but TODO write a test that does *)
		Example[{Messages, "NoAvailableSample", "If a model in a hermetic container is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable, throw a message and return False:"},
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Fake hermetic sample model for fulfillableResourceQ tests"], Amount -> 150 Milliliter]],
			True,
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {$DeveloperSearch = True}
		],
		Test["If a model in a hermetic container is requested and the amount does NOT exceed the volume/mass of any one sample of that model in the lab or the maximum amount orderable, only throw a warning:",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Fake hermetic sample model for fulfillableResourceQ tests"], Amount -> 97 Milliliter]],
			True,
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {$DeveloperSearch = True}
		],
		Example[{Messages, "DeprecatedProduct", "If a consumable model is requested in a resource and there is no non-deprecated product available, throw a warning saying it might be aborted:"},
			fulfillableResourceQ[Resource[Sample -> Model[Item,Consumable,"Model consumable 345 for FulfillableResourceQ unit tests"]]],
			True,
			Messages :> {Warning::DeprecatedProduct}
		],
		Example[{Messages, "InsufficientVolume", "If a sample is requested and the amount requested exceeds the amount available, throw a message but still return True:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:bq9LA0JXjZxz"]],
			True,
			Messages :> {Warning::InsufficientVolume}
		],
		Example[{Messages, "InsufficientVolume", "If a sample is requested and the amount requested exceeds the amount available, throw a message but still return True:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:7X104vnYkWRR"], Amount -> 400*Microliter]],
			True,
			Messages :> {Warning::InsufficientVolume}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a consumable sample is requested and there is already a request for this item, throw a message and return False:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:dORYzZJpLMRD"]],
			False,
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a consumable sample is requested and there is already a request for this item, throw a message and return False:"},
			fulfillableResourceQ[Resource[Sample -> Object[Item,Consumable,"id:BYDOjvGlLRb9"]]],
			False,
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a part is requested and there is already a request for this item, still return True because all parts are Reusable and thus both can be fulfilled:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:N80DNj1pAz4W"], Object[Resource, Sample, "id:xRO9n3BjbYez"]}, OutputFormat -> Boolean],
			{True, True}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a part is requested and there is already a request for this item, still return True because all parts are Reusable and thus both can be fulfilled:"},
			fulfillableResourceQ[Resource[Sample -> Object[Part, BeamStop, "Part resource for fulfillableResource(s/Q) unit tests"]]],
			True
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a container is requested and there is already a request for that container, throw a message and return false only if that container is either Disposable or is cleaned via Dishwash:"},
			fulfillableResourceQ[Resource[Sample -> Object[Container, Vessel, "id:eGakldJ8Zo0G"]]],
			False,
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Example[{Messages, "ContainerTooSmall", "If a ContainerModel is specified and the model specified needs to be moved to that container model but the MaxVolume of the destination is too low, throw a message and return an error:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:Vrbp1jKoALBw"]],
			False,
			Messages :> {Error::ContainerTooSmall, Error::InvalidInput}
		],
		Example[{Messages, "ContainerTooSmall", "If a ContainerModel is specified and the model specified needs to be moved to that container model but the MaxVolume of the destination is too low, throw a message and return an error:"},
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "id:vXl9j578pO5e"], Container -> Model[Container, Vessel, "id:8qZ1VW0DjYeL"], Amount -> 550*Milliliter]],
			False,
			Messages :> {Error::ContainerTooSmall, Error::InvalidInput}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:KBL5Dvwr1kqd"]],
			True,
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:D8KAEvGloG7K"], Container -> Model[Container, Vessel, "id:8qZ1VW0DjYeL"], Amount -> 400*Milliliter]],
			True,
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified with ContainerName and Well and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			fulfillableResourceQ[{
				Resource[
					Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Container -> Model[Container, Plate, "96-well 1mL Deep Well Plate"],
					Amount -> 1 Milliliter,
					ContainerName -> "test",
					Well -> "A1"
				],
				Resource[
					Sample -> Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
					Container -> Model[Container, Plate, "96-well 1mL Deep Well Plate"],
					Amount -> 1 Milliliter,
					ContainerName -> "test",
					Well -> "A2"
				]
			}],
			True,
			Messages :> {Warning::SampleMustBeMoved,Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but not all the samples in the same container are being requested, throw a soft warning to move the sample but still return True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Amount -> 1 Milliliter,
					ContainerName -> "test",
					Well -> "A1"
				]
			],
			True,
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but it does not match the existing position of the sample, throw a soft warning to move the sample but still return True:"},
			fulfillableResourceQ[{
				Resource[
					Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Amount -> 1 Milliliter,
					ContainerName -> "test",
					Well -> "A1"
				],
				Resource[
					Sample -> Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
					Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Amount -> 1 Milliliter,
					ContainerName -> "test",
					Well -> "A3"
				]
			}],
			True,
			Messages :> {Warning::SampleMustBeMoved,Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but an additional sample is also requested, throw a soft warning to move the sample but still return True:"},
			Module[{protocol,resources},
				protocol=RequireResources[
					<|
						Type -> Object[Protocol,RoboticSamplePreparation],
						Replace[RequiredObjects]->Link[{
							Resource[
								Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
								Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
								Amount -> 1 Milliliter,
								ContainerName -> "test",
								Well -> "A1"
							],
							Resource[
								Sample -> Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
								Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
								Amount -> 1 Milliliter,
								ContainerName -> "test",
								Well -> "A2"
							],
							Resource[
								Sample -> Model[Sample, StockSolution, "1x TBE Buffer"],
								Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
								Amount -> 1 Milliliter,
								ContainerName -> "test",
								Well -> "A3"
							]
						}]
					|>
				];
				resources=Download[protocol,RequiredResources][[All,1]];
				fulfillableResourceQ[resources]
			],
			True,
			Messages :> {Warning::SampleMustBeMoved,Warning::SampleMustBeMoved}
		],
		Test["If sample resources are requested with ContainerName and Well and they exactly match the current contents of the container, use the samples directly:",
			Module[{protocol,resources},
				protocol=RequireResources[
					<|
						Type -> Object[Protocol,RoboticSamplePreparation],
						Replace[RequiredObjects] -> Link[{
							Resource[
								Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
								Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
								Amount -> 1 Milliliter,
								ContainerName -> "test",
								Well -> "A1"
							],
							Resource[
								Sample -> Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
								Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
								Amount -> 1 Milliliter,
								ContainerName -> "test",
								Well -> "A2"
							]
						}]
					|>
				];
				resources=Download[protocol,RequiredResources][[All,1]];
				fulfillableResourceQ[resources]
			],
			True
		],
		Example[{Messages, "SamplesOutOfStock", "If a model is requested and there is not currently enough of that model in the lab, but a product exists from which we can reorder this item, throw a warning that the samples must be ordered but still return True:"},
			fulfillableResourceQ[Resource[Sample -> Model[Item,Consumable,"id:D8KAEvGlKM8O"]]],
			True,
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
				(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = False
			}
		],
		Test["If a model is requested and there is enough of it in the lab but all of it is InUse and the product is Stocked, still throw a warning that the sample is out of stock:",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Developer model 1 for fulfillableResources SamplesOutOfStock tests"], Amount -> 1*Milliliter]],
			True,
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
			(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = True
			}
		],
		Test["If a model is requested and there is enough of it in the lab but all of it is InUse and the product is NOT stocked, don't throw a warning since we'll just wait:",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "Developer model 3 for fulfillableResources SamplesOutOfStock tests"], Amount -> 1*Milliliter]],
			True,
			Stubs :> {
			(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified but the sample is already in that container model, throw no warning since the item does not need to be moved:"},
			fulfillableResourceQ[Object[Resource, Sample, "id:jLq9jXvxpBdW"]],
			True
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified but the sample is already in that container model, throw no warning since the item does not need to be moved:"},
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:D8KAEvGloG7K"], Container -> Model[Container, Vessel, "id:J8AY5jDkq9m7"], Amount -> 400*Milliliter]],
			True
		],
		Example[{Messages, "SamplesNotOwned", "If a specific sample was requested and that sample is not owned by a notebook that the Author has access to, throw an error and return False:"},
			fulfillableResourceQ[{Object[Resource, Sample, "id:zGj91a7wRewv"], Object[Resource, Sample, "id:o1k9jAGJKbJx"]}, OutputFormat -> Boolean],
			{False, True},
			Messages :> {Error::SamplesNotOwned, Error::InvalidInput},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "id:AEqRl9Kz5Yzv"]}
		],
		Test["Checks to see if a stock solution resource can be fulfilled if there is enough in the lab:",
			fulfillableResourceQ[Object[Resource, Sample, "id:4pO6dM5EV56o"]],
			True
		],
		Test["Checks to see if a stock solution resource can be fulfilled if there is enough in the lab (resource):",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, StockSolution, "id:Z1lqpMzmNrYM"], Amount -> 100*Milliliter]],
			True
		],
		Test["For a consumable StockSolution specifically, if the quantity available in lab is less than the amount requested, still return True because we can just make more of the StockSolution in the lab:",
			fulfillableResourceQ[{Object[Resource, Sample, "id:4pO6dM5EV56o"], Object[Resource, Sample, "id:Vrbp1jKoAKpx"]}],
			True
		],
		Test["For a consumable StockSolution specifically, if the quantity available in lab is less than the amount requested, still return True because we can just make more of the StockSolution in the lab (resource):",
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, StockSolution, "id:Z1lqpMzmNrYM"], Amount -> 100*Milliliter], Resource[Sample -> Model[Sample, StockSolution, "id:Z1lqpMzmNrYM"], Amount -> 1*Liter]}],
			True
		],
		Test["For a consumable model, if not all copies in the lab are reserved, then that resource can be fulfilled:",
			fulfillableResourceQ[Object[Resource, Sample, "id:XnlV5jKRoKV8"]],
			True
		],
		Test["For a consumable model, if not all copies in the lab are reserved, then that resource can be fulfilled (resource):",
			fulfillableResourceQ[Resource[Sample -> Model[Item,Consumable,"id:N80DNj1pLvqq"]]],
			True
		],
		Test["For a non-consumable model that is SelfContained, if not all copies in the lab are reserved, then this resource can be fulfilled:",
			fulfillableResourceQ[Object[Resource, Sample, "id:D8KAEvGlo5rY"]],
			True
		],
		Test["For a non-consumable model that is SelfContained, if all copies in the lab are reserved, this is still okay and the resource can be fulfilled (resource):",
			fulfillableResourceQ[Resource[Sample -> Model[Item,Column,"id:8qZ1VW0DjzdA"]]],
			True
		],
		Test["For a resource requesting a specific container that is normally consumable, if this container has contents, it is _no longer_ consumable (and thus multiple reservations can be made on it):",
			fulfillableResourceQ[{Object[Resource, Sample, "id:J8AY5jD1vo5b"], Object[Resource, Sample, "id:8qZ1VW0MzKVA"]}],
			True
		],
		Test["For a resource requesting a specific container that is normally consumable, if this container has contents, it is _no longer_ consumable (and thus multiple reservations can be made on it) (resource):",
			fulfillableResourceQ[Resource[Sample -> Object[Container, Vessel, "id:Vrbp1jKDaJPm"]]],
			True
		],
		Test["If a sample is requested, but the amount requested exceeds the difference between the total amount in the lab and the amount already reserved, then throw a message but still return True:",
			fulfillableResourceQ[{Object[Resource, Sample, "id:KBL5Dvwr1VZN"], Object[Resource, Sample, "id:jLq9jXvxpRlx"]}, OutputFormat -> Boolean],
			{True, True},
			Messages :> {Warning::InsufficientVolume}
		],
		Test["If a sample is requested, but the amount requested exceeds the difference between the total amount in the lab and the amount already reserved and Output -> Tests, suppress the messages and return a list of tests:",
			fulfillableResourceQ[{Object[Resource, Sample, "id:KBL5Dvwr1VZN"], Object[Resource, Sample, "id:jLq9jXvxpRlx"]}, Verbose->True, OutputFormat -> Boolean, Output -> Tests],
			{__EmeraldTest}
		],
		Test["If a sample is requested, but the amount requested exceeds the difference between the total amount in the lab and the amount already reserved, then throw a message but still return True (resource):",
			fulfillableResourceQ[Resource[Sample -> Object[Sample, "id:N80DNj1pLRrl"], Amount -> 150*Microliter]],
			True,
			Messages :> {Warning::InsufficientVolume}
		],
		Test["If a consumable sample has several requests, but all others are still InCart, return True for the request that is either Outstanding or InUse:",
			fulfillableResourceQ[{Object[Resource, Sample, "id:dORYzZJpLMRD"], Object[Resource, Sample, "id:eGakldJ8oMaE"]}, OutputFormat -> Boolean],
			{False, True},
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Test["If a consumable sample has no other requests, then it can be fulfilled with one:",
			fulfillableResourceQ[Object[Resource, Sample, "id:pZx9jo8AdMxj"]],
			True
		],
		Test["If a consumable sample has no other requests, then it can be fulfilled with one (resource):",
			fulfillableResourceQ[Resource[Sample -> Object[Item,Consumable,"id:M8n3rx0DGP1G"]]],
			True
		],
		Test["If a ContainerModel is specified and the model requested needs to be moved to that container model, check the MaxVolume of the destination to make sure it is not too small:",
			fulfillableResourceQ[{Object[Resource, Sample, "id:4pO6dM5EVPZB"], Object[Resource, Sample, "id:Vrbp1jKoALBw"]}, OutputFormat -> Boolean],
			{True, False},
			Messages :> {Error::ContainerTooSmall, Error::InvalidInput}
		],
		Test["Water resources are always fulfillable:",
			fulfillableResourceQ[Object[Resource, Sample, "id:AEqRl9KNk1e5"]],
			True,
			TimeConstraint -> 240
		],
		Test["Water resources are always fulfillable (resource):",
			fulfillableResourceQ[Resource[Sample -> Model[Sample, "id:8qZ1VWNmdLBD"], Amount -> 18*Liter, Container -> Model[Container, Vessel, "id:3em6Zv9NjjkY"]]],
			True,
			TimeConstraint -> 240
		],
		Test["Function fulfillableResourceQ works with the Cache option:",
			fulfillableResourceQ[
				Object[Resource, Sample, "id:jLq9jXvxpRlx"],
				Cache -> {
					<|
						Object -> Object[Resource, Sample, "id:jLq9jXvxpRlx"],
						ID -> "id:jLq9jXvxpRlx",
						Type -> Object[Resource, Sample],
						Models -> {Link[Model[Sample, "id:qdkmxzqeJzAY"], RequestedResources, "R8e1PjBNvxeK"]},
						Sample -> Link[Object[Sample, "id:N80DNj1pLRrl"], RequestedResources, "GmzlKjN3GBz9"],
						Amount -> 150. Microliter,
						ContainerModels -> {},
						Status -> Outstanding,
						Preparation->Null
					|>
				}
			],
			True
		],
		Test["Function fulfillableResourceQ works with theFastTrack option and automatically returns True (even if it would otherwise return False, since it isn't error checking):",
			fulfillableResourceQ[{Object[Resource, Sample, "id:jLq9jXvxpRlx"]}, FastTrack -> True],
			True
		],
		Test["Function fulfillableResourceQ works with theFastTrack option and automatically returns True (even if it would otherwise return False, since it isn't error checking):",
			fulfillableResourceQ[{Object[Resource, Sample, "id:jLq9jXvxpRlx"]}, FastTrack -> True, OutputFormat -> Boolean],
			{True}
		],
		Test["Function fulfillableResourceQ works with theFastTrack option and automatically returns True (even if it would otherwise return False) (resources):",
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, "id:vXl9j578pO5e"], Container -> Model[Container, Vessel, "id:8qZ1VW0DjYeL"], Amount -> 550*Milliliter]}, FastTrack -> True],
			True
		],
		Test["Function fulfillableResourceQ works with theFastTrack option and automatically returns True (even if it would otherwise return False) (resources):",
			fulfillableResourceQ[{Resource[Sample -> Model[Sample, "id:vXl9j578pO5e"], Container -> Model[Container, Vessel, "id:8qZ1VW0DjYeL"], Amount -> 550*Milliliter]}, FastTrack -> True, OutputFormat -> Boolean],
			{True}
		],
		Test["When given an empty list and OutputFormat -> SingleBoolean, returns True:",
			fulfillableResourceQ[{}, OutputFormat -> SingleBoolean],
			True
		],
		Test["When given an empty list and OutputFormat -> Boolean, returns {}:",
			fulfillableResourceQ[{}, OutputFormat -> Boolean],
			{}
		],
		Test["Resources that are already InUse are fulfillable even if the samples they refer to are set for Disposal:",
			fulfillableResourceQ[Object[Resource, Sample, "id:kEJ9mqR4BWn8"]],
			True
		],
		Test["Resources that are already Outstanding are fulfillable even if the samples they refer to are set for Disposal:",
			fulfillableResourceQ[Object[Resource, Sample, "Disposal Resource Outstanding for FulfillableResourceQ unit tests"]],
			True
		],
		Test["Resources for plumbing objects are properly fulfillable:",
			fulfillableResourceQ[Resource[Sample -> Model[Plumbing, Valve, "Chem Lab Gas Valve"]]],
			True
		],
		Test["Resources for items that have more than 200 instances are tested for fulfillability slightly differently for performance reasons:",
			fulfillableResourceQ[Resource[Sample -> Model[Item, Tips, "Fake tips model for high-quantity item fulfillableResourceQ test"]]],
			True
		],
		Test["Resources for samples whose products have CountPerSample populated but Count actually doesn't exist still works and doesn't trainwreck:",
			fulfillableResourceQ[Resource[Sample -> Model[Part, NMRDepthGauge, "Bruker Sample Depth Gauge"]]],
			True
		],
		Test["Resources for items that have many instances that are also counted works properly if the resource does not request the count:",
			fulfillableResourceQ[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"]]],
			True
		],
		Test["Resources for items that have many instances that are also counted works properly if the resource does not request the count:",
			fulfillableResourceQ[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"]]],
			True
		],
		Test["Resources for Object items can be searched based on Number of uses:",
			fulfillableResourceQ[Resource[
				Sample -> Object[Item, Electrode, ReferenceElectrode, "test reference electrode (75 uses)" <> $SessionUUID],
				NumberOfUses -> 10
			]],
			True,
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Test["Resources for Object items can be searched based on Number of uses and returns false when Number of required uses exceeds the maximum:",
			fulfillableResourceQ[Resource[
				Sample -> Object[Item, Electrode, ReferenceElectrode, "test reference electrode (75 uses)" <> $SessionUUID],
				NumberOfUses -> 430
			]],
			False,
			Messages :> {Error::ExceedsMaxNumberOfUses, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Test["Resources for stock solution models with VolumeIncrements populated must not request more than $MaxNumberOfFulfillmentPreps * Max[VolumeIncrements]:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"],
				Amount -> 7 Milliliter
			]],
			False,
			Messages :> {Error::NonScalableStockSolutionVolumeTooHigh, Error::InvalidInput}
		],
		Test["Resources for Model items can be searched based on Number of uses:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Item, Electrode, ReferenceElectrode, "reference electrode test model" <> $SessionUUID],
				NumberOfUses -> 135
			]],
			True
		],
		Test["Resources for Model items can be searched based on Number of uses and returns true when Number of required uses exceeds the maximum:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Item, Electrode, ReferenceElectrode, "reference electrode test model" <> $SessionUUID],
				NumberOfUses -> 435
			]],
			True,
			Messages :> {Warning::SamplesOutOfStock}
		],
		Test["Resources for Object Containers can be searched based on Number of uses:",
			fulfillableResourceQ[Resource[
				Sample -> Object[Container, ProteinCapillaryElectrophoresisCartridge,  "test container cartridge with insert (75 uses)" <> $SessionUUID],
				NumberOfUses -> 10
			]],
			True
		],
		Test["Resources for Object Containers can be searched based on Number of uses and returns false when Number of required uses exceeds the maximum:",
			fulfillableResourceQ[Resource[
				Sample -> Object[Container, ProteinCapillaryElectrophoresisCartridge,  "test container cartridge with insert (75 uses)" <> $SessionUUID],
				NumberOfUses -> 135
			]],
			False,
			Messages :> {Error::ExceedsMaxNumberOfUses, Error::InvalidInput}
		],
		Test["Resources for Model Containers can be searched based on Number of uses:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
				NumberOfUses -> 10
			]],
			True
		],
		Test["Resources for Model Containers can be searched based on Number of uses and returns true when Number of required uses exceeds the maximum:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
				NumberOfUses -> 135
			]],
			True,
			Messages :> {Warning::SamplesOutOfStock}
		],
		(* weird test; basically, if we had 4 containers of a given model, 3 of which are InUse and owned by a notebook-ed protocol, the previous code would recognize only 1 container is able to be picked, but count the InUse resources for those containers as still being outstanding *)
		(* the result would be that it would say another resource of this model is not fulfillable, even if it is Available and not owned *)
		Test["Don't get confused by notebook-ed protocols already having some containers InUse if there is enough of an available given container publicly anyway:",
			fulfillableResourceQ[Resource[
				Sample -> Model[Container, Vessel, "Test vessel for fulfillableResourceQ tests" <> $SessionUUID]
			]],
			True,
			Messages :> {Warning::DeprecatedProduct}
		],
		Test["If making a resource for a container that doesn't have a product itself but instead has a product for the sample it's holding, recognize that and don't freak out/throw an error:",
			fulfillableResourceQ[Resource[Sample -> Model[Container, Vessel, Filter, "Test filter model 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID]]],
			True
		],
		Test["If making multiple resources where they're requesting the same thing and it's a model, this works properly and returns the correct value (True):",
			fulfillableResourceQ[{
				Resource[
					Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
					NumberOfUses -> 10
				],
				Resource[
					Sample -> Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
					NumberOfUses -> 10
				]
			}],
			True
		],
		Test["If making multiple resources where they're requesting the same thing and it's an Object, this works properly and returns the correct value (False):",
			fulfillableResourceQ[{
				Resource[
					Sample -> Object[Container, ProteinCapillaryElectrophoresisCartridge, "test container cartridge with insert (75 uses)" <> $SessionUUID],
					NumberOfUses -> 135
				],
				Resource[
					Sample -> Object[Container, ProteinCapillaryElectrophoresisCartridge, "test container cartridge with insert (75 uses)" <> $SessionUUID],
					NumberOfUses -> 135
				]
			}],
			False,
			Messages :> {Error::ExceedsMaxNumberOfUses, Error::InvalidInput}
		],
		Example[{Messages, "InvalidSterileRequest", "If Sterile is set to True in the resource, the requested model must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test StorageBuffer sample model for fulfillableResourceQ tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			False,
			Messages :> {Error::InvalidSterileRequest, Error::InvalidInput}
		],
		Example[{Messages, "InvalidSterileRequest", "If Sterile is set to True in the resource, the requested model must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			True
		],
		Example[{Messages, "InvalidSterileRequest", "If Sterile is set to True in the resource, the requested sample must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			False,
			Messages :> {Error::InvalidSterileRequest, Error::InvalidInput}
		],
		Example[{Messages, "InvalidSterileRequest", "If Sterile is set to True in the resource, the requested sample must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Object[Sample, "Test sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			True
		],
		Example[{Messages, "ContainerNotSterile", "If Sterile is set to True in the resource and Container is specified, the container must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter,
					Container -> Model[Container, Vessel, "Test vessel for fulfillableResourceQ tests" <> $SessionUUID]
				]
			],
			False,
			Messages :> {Error::ContainerNotSterile, Error::InvalidInput}
		],
		Example[{Messages, "ContainerNotSterile", "If Sterile is set to True in the resource and Container is specified, the container must also have Sterile -> True:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter,
					(* 2mL tubes are Sterile -> True *)
					Container -> Model[Container, Vessel, "2mL Tube"]
				]
			],
			True
		],

		Example[{Messages, "SamplesOutOfStock", "If Sterile is set to True but the product tied to the requested model is sterile and we don't have anything available, then Warning::SamplesOutOfStock is thrown as normal:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test sterile model 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			True,
			Messages :> {Warning::SamplesOutOfStock}
		],
		Example[{Messages, "InsufficientTotalVolume", "If Sterile is set to True but the product tied to the requested model is NOT sterile and we don't have anything available, then an error is thrown:"},
			fulfillableResourceQ[
				Resource[
					Sample -> Model[Sample, "Test sterile model 3 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Sterile -> True,
					Amount -> 100 Microliter
				]
			],
			False,
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput}
		],

		(* Instrument Ownership tests *)
		Example[{Options, Author, "For a single unlisted resource object, if the requested instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResourceQ[
				Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
				Author -> Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
				OutputFormat -> Boolean
			],
			{True},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "For a single unlisted resource, if the requested instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResourceQ[
				Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResourceQ Tests " <> $SessionUUID]],
				Author -> Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
				OutputFormat -> Boolean
			],
			{True},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "If the requested instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResourceQ[
				{
					Object[Resource, Instrument, "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID]
				},
				Author -> Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
				OutputFormat -> Boolean
			],
			{True, True, True},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "For an instrument resource, if $Notebook is not the same as the notebook of the requested instrument, but it is available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResourceQ[
				{
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResourceQ Tests " <> $SessionUUID]],
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResourceQ Tests " <> $SessionUUID]],
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResourceQ Tests " <> $SessionUUID]]
				},
				Author -> Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
				OutputFormat -> Boolean
			],
			{True, True, True},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "If a specific instrument is requested that is not owned by a notebook that the Author has access to, throw an error and return False:"},
			fulfillableResourceQ[
				{
					Object[Resource, Instrument, "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 2 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID]
				},
				OutputFormat -> Boolean
			],
			{True, False, True, True},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 3 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "For a resource, throw an error and return False if the author does not have access to a specific instrument:"},
			fulfillableResourceQ[
				{
					Object[Resource, Instrument, "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 2 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID]
				},
				OutputFormat -> Boolean
			],
			{True, False, True, True},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 3 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID]
			}
		]
	},
	Stubs :> {
		$DeveloperSearch = True,
		$PersonID = Download[Object[User, "Fake user 1 for FulfillableResourceQ unit tests"], Object]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridge, "test container cartridge with insert (75 uses)" <> $SessionUUID],
					Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge test Insert" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "test CESDS cartridge Insert" <> $SessionUUID],
					Model[Container, Vessel, "Test vessel for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Bench, "Test bench for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for fulfillableResourceQ tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "reference electrode test model" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "test reference electrode (75 uses)" <> $SessionUUID],
					Object[User, "Test User (fulfillableResourceQ unit tests)" <> $SessionUUID],
					Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
					Object[User, "Test Author for fulfillableResourceQ Tests 3 " <> $SessionUUID],
					Object[Team, Financing, "Test Team (fulfillableResourceQ unit tests)" <> $SessionUUID],
					Object[Team, Financing, "Test Financing Team for fulfillableResourceQ Tests 2 " <> $SessionUUID],
					Object[Team, Financing, "Test Financing Team for fulfillableResourceQ Tests 3 " <> $SessionUUID],
					Object[LaboratoryNotebook, "Test Notebook 1 (fulfillableResourceQ unit tests)" <> $SessionUUID],
					Object[LaboratoryNotebook, "Test Notebook 2 (fulfillableResourceQ unit tests)" <> $SessionUUID],
					Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 3 " <> $SessionUUID],
					Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 4 " <> $SessionUUID],
					Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
					Object[Product, "Test product 1 for StorageBuffer sample/container for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Product, "Test product 2 for ProteinCapillaryElectrophoresisCartridge for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Product, "Test product 3 for ReferenceElectrode for fulfillableResourceQ tests" <> $SessionUUID],
					Model[Container, Vessel, Filter, "Test filter model 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Vessel, Filter, "Test filter 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Container, Plate, "Test DWP for fulfillableResourceQ tests" <> $SessionUUID],
					Model[Sample, "Test StorageBuffer sample model for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Sample, "Test StorageBuffer sample for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
					Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
					Download[
						Object[Protocol, HPLC, "Test protocol for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
						{Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}
					],
					Model[Sample, "Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Model[Sample, "Test sterile model 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Model[Sample, "Test sterile model 3 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Sample, "Test sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Sample, "Test sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container for sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container for sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Product, "Test sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Object[Product, "Test non-sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
					Model[Instrument, HPLC, "Test HPLC Model 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 2 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					cartridgeContainerModel, cartridgeContainer, cartridgeContainerWithInsert, cartridgeInsertModel,
					cartridgeInsert, testBench, testContainer1, testContainer2, testContainer3, testContainer4,
					containerModel, testUser1, testTeam1, testNotebook1, testNotebook2, testProtocol1, itemWithUses,
					allProtResources, filterModel, testContainer5, stockedContainer1, stockedContainer2, itemModel,
					stockedContainer3, stockedContainer4, stockedContainer5, waterModel, product, product2, product3,
					plate, allSamples, testSterileModel1, testSterileModel2, testSterileModel3, sterileContainer1, sterileContainer2,
					sterileProduct1, nonSterileProduct1, testSite, testUser2, testUser3, testTeam2, testTeam3, testNotebook3,
					testNotebook4, testNotebook5,hplcModel1, hplcInstrument1, hplcInstrument2, hplcInstrument3, hplcInstrument4,
					testInstrumentResource1, testInstrumentResource2, testInstrumentResource3, testInstrumentResource4,
					linkID1, linkID2, linkID3, linkID4, linkID5, linkID6, linkID7, linkID8, linkID9, linkID10, linkID11,
					linkID12, linkID13, linkID14
				},

				{
					testSite,
					testBench,
					cartridgeContainerModel,
					cartridgeContainerWithInsert,
					cartridgeInsertModel,
					cartridgeInsert,
					containerModel,
					filterModel,
					waterModel,
					itemModel,
					itemWithUses,
					testUser1,
					testUser2,
					testUser3,
					testTeam1,
					testTeam2,
					testTeam3,
					testNotebook1,
					testNotebook2,
					testNotebook3,
					testNotebook4,
					testNotebook5,
					testProtocol1,
					product,
					product2,
					product3,
					sterileProduct1,
					nonSterileProduct1,
					hplcModel1,
					hplcInstrument1,
					hplcInstrument2,
					hplcInstrument3,
					hplcInstrument4,
					testInstrumentResource1,
					testInstrumentResource2,
					testInstrumentResource3,
					testInstrumentResource4
				} = CreateID[{
					Object[Container, Site],
					Object[Container, Bench],
					Model[Container, ProteinCapillaryElectrophoresisCartridge],
					Object[Container, ProteinCapillaryElectrophoresisCartridge],
					Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Model[Container, Vessel],
					Model[Container, Vessel, Filter],
					Model[Sample],
					Model[Item, Electrode, ReferenceElectrode],
					Object[Item, Electrode, ReferenceElectrode],
					Object[User],
					Object[User],
					Object[User],
					Object[Team, Financing],
					Object[Team, Financing],
					Object[Team, Financing],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Object[Protocol, HPLC],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Model[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Resource, Instrument],
					Object[Resource, Instrument],
					Object[Resource, Instrument],
					Object[Resource, Instrument]
				}];

				{
					linkID1, linkID2, linkID3, linkID4, linkID5,
					linkID6, linkID7, linkID8, linkID9, linkID10,
					linkID11, linkID12, linkID13, linkID14
				} =
					CreateLinkID[14];

				Upload[{
					<|
						Object -> testSite,
						Append[FinancingTeams] -> {
							Link[testTeam2, ExperimentSites, linkID7],
							Link[testTeam3, ExperimentSites, linkID11]
						},
						Name -> "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID
					|>,
					<|
						Object -> hplcModel1,
						Replace@Objects -> {
							Link[hplcInstrument1, Model, linkID1],
							Link[hplcInstrument2, Model, linkID6],
							Link[hplcInstrument3, Model, linkID12],
							Link[hplcInstrument4, Model, linkID14]
						},
						Name -> "Test HPLC Model 1 For fulfillableResourceQ Tests " <> $SessionUUID
					|>,
					<|
						Object -> hplcInstrument1,
						Model -> Link[hplcModel1, Objects, linkID1],
						Name -> "Test HPLC Instrument 1 For fulfillableResourceQ Tests " <> $SessionUUID,
						Site -> Link[testSite]
					|>,
					<|
						Object -> hplcInstrument2,
						Model -> Link[hplcModel1, Objects, linkID6],
						Name -> "Test HPLC Instrument 2 For fulfillableResourceQ Tests " <> $SessionUUID,
						Site -> Link[testSite]
					|>,
					<|
						Object -> hplcInstrument3,
						Model -> Link[hplcModel1, Objects, linkID12],
						Name -> "Test HPLC Instrument 3 For fulfillableResourceQ Tests " <> $SessionUUID,
						Site -> Link[testSite]
					|>,
					<|
						Object -> hplcInstrument4,
						Model -> Link[hplcModel1, Objects, linkID14],
						Name -> "Test HPLC Instrument 4 For fulfillableResourceQ Tests " <> $SessionUUID,
						Site -> Link[testSite]
					|>,
					<|
						Object -> testUser2,
						Name -> "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID,
						Append[FinancingTeams] -> {Link[testTeam2, Members, linkID2]},
						Email -> $SessionUUID <> "fulfillableResourceQ.nonexistent.email2@ecl.com"
					|>,
					<|
						Object -> testUser3,
						Name -> "Test Author for fulfillableResourceQ Tests 3 " <> $SessionUUID,
						Append[FinancingTeams] -> {Link[testTeam3, Members, linkID8]},
						Email -> $SessionUUID <> "fulfillableResourceQ.nonexistent.email3@ecl.com"
					|>,
					<|
						Object -> testTeam2,
						Append[Members] -> {Link[testUser2, FinancingTeams, linkID2]},
						Append[Notebooks] -> {
							Link[testNotebook3, Editors, linkID4],
							Link[testNotebook5, Editors, linkID13]
						},
						Append[NotebooksFinanced] -> {
							Link[testNotebook3, Financers, linkID3]
						},
						Name -> "Test Financing Team for fulfillableResourceQ Tests 2 " <> $SessionUUID,
						DefaultExperimentSite -> Link[testSite],
						Append@ExperimentSites -> {Link[testSite, FinancingTeams, linkID7]}
					|>,
					<|
						Object -> testTeam3,
						Append[Members] -> {Link[testUser3, FinancingTeams, linkID8]},
						Append[Notebooks] -> {Link[testNotebook4, Editors, linkID9]},
						Append[NotebooksFinanced] -> {Link[testNotebook4, Financers, linkID10]},
						Name -> "Test Financing Team for fulfillableResourceQ Tests 3 " <> $SessionUUID,
						DefaultExperimentSite -> Link[$Site],
						Replace@ExperimentSites -> Link[testSite, FinancingTeams, linkID11]
					|>,
					<|
						Object -> testNotebook3,
						Name -> "fulfillableResourceQ Standard Financing Test Notebook 3 " <> $SessionUUID,
						Append[Financers] -> {Link[testTeam2, NotebooksFinanced, linkID3]},
						Append[Editors] -> {Link[testTeam2, Notebooks, linkID4]}
					|>,
					<|
						Object -> testNotebook4,
						Name -> "fulfillableResourceQ Standard Financing Test Notebook 4 " <> $SessionUUID,
						Append[Financers] -> {Link[testTeam3, NotebooksFinanced, linkID10]},
						Append[Editors] -> {Link[testTeam3, Notebooks, linkID9]}
					|>,
					<|
						Object -> testNotebook5,
						Name -> "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID,
						Append[Editors] -> {Link[testTeam2, Notebooks, linkID13]}
					|>,
					<|
						Object -> testInstrumentResource1,
						Instrument -> Link[hplcInstrument1],
						Name -> "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource2,
						Instrument -> Link[hplcInstrument2],
						Name -> "Test Resource 2 For fulfillableResourceQ Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource3,
						Instrument -> Link[hplcInstrument3],
						Name -> "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource4,
						Instrument -> Link[hplcInstrument4],
						Name -> "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testBench,
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for fulfillableResourceQ tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>,
					<|
						Object -> cartridgeContainerModel,
						Name -> "container cartridge test model" <> $SessionUUID,
						Type -> Model[Container, ProteinCapillaryElectrophoresisCartridge],
						CartridgeImageFile -> Link[Object[EmeraldCloudFile, "id:Y0lXejM70m91"]],
						ExperimentType -> CESDS,
						OnBoardRunningBuffer -> Link[Model[Item, Consumable, "Prefilled Top Running Buffer Vial"]],
						CapillaryLength -> 17 Centimeter,
						CapillaryDiameter -> 50 Micrometer,
						CapillaryMaterial -> Silica,
						CapillaryCoating -> None,
						MaxNumberOfUses -> 200,
						MaxInjections -> 200,
						OptimalMaxInjections -> 100,
						MaxInjectionsPerBatch -> 48,
						MinVoltage -> 0 Volt,
						MaxVoltage -> 6500 Volt,
						MinAssayVolume -> 50 Microliter,
						MaxAssayVolume -> 200 Microliter,
						MinMolecularWeightCESDS -> 10 Kilodalton,
						MaxMolecularWeightCESDS -> 270 Kilodalton,
						Expires -> True,
						ShelfLife -> 12 Month,
						Reusable -> True,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Footprint -> MauriceCartridge,
						Replace[Positions] -> {
							<|
								Name -> "Cartridge Insert Slot",
								Footprint -> MauriceCartridgeInsert,
								MaxWidth -> Null,
								MaxDepth -> Null,
								MaxHeight -> Null
							|>
						},
						DeveloperObject -> True
					|>,
					<|
						Object -> cartridgeContainerWithInsert,
						Name -> "test container cartridge with insert (75 uses)" <> $SessionUUID,
						Type -> Object[Container, ProteinCapillaryElectrophoresisCartridge],
						Model -> Link[cartridgeContainerModel, Objects],
						NumberOfUses -> 75,
						Status -> Available,
						Transfer[Notebook] -> Null,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>,
					<|
						Object -> cartridgeInsertModel,
						Name -> "CESDS Cartridge test Insert" <> $SessionUUID,
						Type -> Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
						Footprint -> MauriceCartridgeInsert,
						Replace[Positions] -> {
							<|Name -> "Vial Slot", Footprint -> MauriceRunningBufferVial, MaxWidth -> Null, MaxDepth -> Null, MaxHeight -> Null|>
						},
						DeveloperObject -> True
					|>,
					<|
						Object -> cartridgeInsert,
						Type -> Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
						Model -> Link[cartridgeInsertModel, Objects],
						Name -> "test CESDS cartridge Insert" <> $SessionUUID,
						Status -> Available,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>,
					<|
						Object -> containerModel,
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Name -> "Test vessel for fulfillableResourceQ tests" <> $SessionUUID,
						Replace[Synonyms] -> {"Test vessel for fulfillableResourceQ tests" <> $SessionUUID},
						Replace[Authors] -> {Link[$PersonID]},
						Expires -> False,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Reusable -> False,
						Ampoule -> False,
						Hermetic -> False,
						Squeezable -> False,
						PermanentlySealed -> False,
						Opaque -> False,
						PreferredBalance -> Analytical,
						PreferredCamera -> Small,
						Replace[CompatibleCameras] -> {Small},
						PreferredIllumination -> Side,
						Unimageable -> False,
						DisposableCaps -> True,
						Aspiratable -> True,
						Dispensable -> True,
						MinTemperature -> -100 Celsius,
						MaxTemperature -> 200 Celsius,
						MinVolume -> 10 Microliter,
						MaxVolume -> 2 Milliliter,
						Dimensions -> {1 Centimeter, 1 Centimeter, 2 Centimeter},
						CrossSectionalShape -> Circle,
						Footprint -> CEVial,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Open, MaxWidth -> 0.9 Centimeter, MaxDepth -> 0.9 Centimeter, MaxHeight -> 1.9 Centimeter|>},
						Replace[PositionPlotting] -> {<|Name -> "A1", XOffset -> 0.5 Centimeter, YOffset -> 0.5 Centimeter, ZOffset -> 0.1 Centimeter, CrossSectionalShape -> Circle, Rotation -> 0|>},
						Sterile -> False,
						Stocked -> False,
						InternalDiameter -> 0.9 Centimeter
					|>,
					<|
						Object -> filterModel,
						DeveloperObject -> True,
						Name -> "Test filter model 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID,
						Replace[Synonyms] -> {"Test filter model 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID},
						Replace[Authors] -> {Link[$PersonID]},
						Expires -> False,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Reusable -> False,
						Ampoule -> False,
						Hermetic -> False,
						Squeezable -> False,
						PermanentlySealed -> False,
						Opaque -> False,
						PreferredBalance -> Analytical,
						PreferredCamera -> Small,
						Replace[CompatibleCameras] -> {Small},
						PreferredIllumination -> Side,
						Unimageable -> False,
						DisposableCaps -> True,
						Aspiratable -> True,
						Dispensable -> True,
						MinTemperature -> -100 Celsius,
						MaxTemperature -> 200 Celsius,
						MinVolume -> 10 Microliter,
						MaxVolume -> 2 Milliliter,
						Dimensions -> {1 Centimeter, 1 Centimeter, 2 Centimeter},
						CrossSectionalShape -> Circle,
						Footprint -> CEVial,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Open, MaxWidth -> 0.9 Centimeter, MaxDepth -> 0.9 Centimeter, MaxHeight -> 1.9 Centimeter|>},
						Replace[PositionPlotting] -> {<|Name -> "A1", XOffset -> 0.5 Centimeter, YOffset -> 0.5 Centimeter, ZOffset -> 0.1 Centimeter, CrossSectionalShape -> Circle, Rotation -> 0|>},
						Sterile -> False,
						Stocked -> False,
						InternalDiameter -> 0.9 Centimeter,
						StorageBuffer -> True,
						StorageBufferVolume -> 1 Milliliter
					|>,
					<|
						Object -> waterModel,
						DeveloperObject -> True,
						Name -> "Test StorageBuffer sample model for fulfillableResourceQ tests" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						State -> Liquid
					|>,
					<|
						Object -> itemModel,
						DeveloperObject -> True,
						Name -> "reference electrode test model" <> $SessionUUID,
						Replace[Authors] -> {Link[$PersonID]},
						Coated -> False,
						Dimensions -> {0.003 Meter, 0.003 Meter, 0.003 Meter},
						ReferenceElectrodeType -> "Bare-Ag",
						ElectrodeShape -> Rod,
						MinPotential -> -2.5 Volt,
						MaxPotential -> 2.5 Volt,
						Preparable -> False,
						SonicationSensitive -> True,
						SolutionVolume -> 1 Milliliter,
						Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
						BulkMaterial -> Silver,
						MaxNumberOfUses -> 500,
						Replace[WettedMaterials] -> {Silver},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>,
					<|
						Object -> itemWithUses,
						Model -> Link[itemModel, Objects],
						NumberOfUses -> 75,
						Name -> "test reference electrode (75 uses)" <> $SessionUUID,
						Status -> Available,
						Transfer[Notebook] -> Null,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>,
					<|
						Object -> testUser1,
						DeveloperObject -> True,
						Name -> "Test User (fulfillableResourceQ unit tests)" <> $SessionUUID
					|>,
					<|
						Object -> testTeam1,
						DeveloperObject -> True,
						Name -> "Test Team (fulfillableResourceQ unit tests)" <> $SessionUUID,
						Replace[Members] -> {Link[testUser1, FinancingTeams]}
					|>,
					<|
						Object -> testNotebook1,
						DeveloperObject -> True,
						Name -> "Test Notebook 1 (fulfillableResourceQ unit tests)" <> $SessionUUID,
						Replace[Financers] -> {Link[testTeam1, NotebooksFinanced]},
						Replace[Editors] -> {Link[testTeam1, Notebooks]},
						Replace[Viewers] -> {Link[testTeam1, Notebooks]},
						Replace[Authors] -> {Link[testUser1]},
						Replace[Administrators] -> {Link[testUser1]}
					|>,
					<|
						Object -> testNotebook2,
						DeveloperObject -> True,
						Name -> "Test Notebook 2 (fulfillableResourceQ unit tests)" <> $SessionUUID,
						Replace[Financers] -> {Link[testTeam1, NotebooksFinanced]},
						Replace[Editors] -> {Link[testTeam1, Notebooks]},
						Replace[Viewers] -> {Link[testTeam1, Notebooks]},
						Replace[Authors] -> {Link[testUser1]},
						Replace[Administrators] -> {Link[testUser1]}
					|>,
					<|
						Object -> product,
						DeveloperObject -> True,
						Transfer[Notebook] -> Null,
						Name -> "Test product 1 for StorageBuffer sample/container for fulfillableResourceQ tests" <> $SessionUUID,
						ProductModel -> Link[waterModel, Products],
						DefaultContainerModel -> Link[filterModel, ProductsContained],
						Stocked -> True,
						Amount -> 1 Milliliter
					|>,
					<|
						Object -> product2,
						DeveloperObject -> True,
						Transfer[Notebook] -> Null,
						Name -> "Test product 2 for ProteinCapillaryElectrophoresisCartridge for fulfillableResourceQ tests" <> $SessionUUID,
						ProductModel -> Link[cartridgeContainerModel, Products],
						Packaging -> Case,
						NumberOfItems -> 10,
						SampleType -> Plate,
						EstimatedLeadTime -> 3 Day
					|>,
					<|
						Object -> product3,
						DeveloperObject -> True,
						Transfer[Notebook] -> Null,
						Name -> "Test product 3 for ReferenceElectrode for fulfillableResourceQ tests" <> $SessionUUID,
						ProductModel -> Link[itemModel, Products],
						Packaging -> Single,
						NumberOfItems -> 1,
						SampleType -> Electrode,
						EstimatedLeadTime -> 3 Day
					|>,
					<|
						Object -> sterileProduct1,
						DeveloperObject -> True,
						Transfer[Notebook] -> Null,
						Name -> "Test sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID,
						DefaultContainerModel -> Link[Model[Container, Vessel, "2mL Tube"], ProductsContained],
						Stocked -> True,
						Sterile -> True,
						Amount -> 1 Milliliter
					|>,
					<|
						Object -> nonSterileProduct1,
						DeveloperObject -> True,
						Transfer[Notebook] -> Null,
						Name -> "Test non-sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID,
						DefaultContainerModel -> Link[Model[Container, Vessel, "2mL Tube"], ProductsContained],
						Stocked -> True,
						Sterile -> False,
						Amount -> 1 Milliliter
					|>
				}];

				testSterileModel1 = UploadSampleModel[
					"Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "Water"]},
						{100 Milligram / Milliliter, Model[Molecule, "Sodium Chloride"]}
					},
					State -> Liquid,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Expires -> True,
					ShelfLife -> 1 Month,
					UnsealedShelfLife -> 2 Week,
					MSDSFile -> NotApplicable,
					Flammable -> False,
					BiosafetyLevel -> "BSL-1",
					IncompatibleMaterials -> {None},
					Sterile -> True
				];
				testSterileModel2 = UploadSampleModel[
					"Test sterile model 2 for fulfillableResourceQ unit tests" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "Water"]},
						{100 Milligram / Milliliter, Model[Molecule, "Sodium Chloride"]}
					},
					State -> Liquid,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Expires -> True,
					ShelfLife -> 1 Month,
					UnsealedShelfLife -> 2 Week,
					MSDSFile -> NotApplicable,
					Flammable -> False,
					BiosafetyLevel -> "BSL-1",
					IncompatibleMaterials -> {None},
					Sterile -> True,
					Products -> {sterileProduct1}
				];
				testSterileModel3 = UploadSampleModel[
					"Test sterile model 3 for fulfillableResourceQ unit tests" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "Water"]},
						{100 Milligram / Milliliter, Model[Molecule, "Sodium Chloride"]}
					},
					State -> Liquid,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Expires -> True,
					ShelfLife -> 1 Month,
					UnsealedShelfLife -> 2 Week,
					MSDSFile -> NotApplicable,
					Flammable -> False,
					BiosafetyLevel -> "BSL-1",
					IncompatibleMaterials -> {None},
					Sterile -> True,
					Products -> {nonSterileProduct1}
				];

				(* place the insert in its cartridge to make a not empty cartridge *)
				Upload[<|Object -> cartridgeContainerWithInsert, Replace[Contents] -> {{"Cartridge Insert Slot", Link[cartridgeInsert, Container]}}|>];

				Upload[<|Object -> #, Status -> Available, ExpirationDate -> Null, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{cartridgeContainer, cartridgeContainerWithInsert, cartridgeInsert}], ObjectP[]]];
				{
					testContainer1,
					testContainer2,
					testContainer3,
					testContainer4,
					testContainer5,
					stockedContainer1,
					stockedContainer2,
					stockedContainer3,
					stockedContainer4,
					stockedContainer5,
					plate,
					sterileContainer1,
					sterileContainer2
				} = ECL`InternalUpload`UploadSample[
					{
						containerModel,
						containerModel,
						containerModel,
						containerModel,
						filterModel,
						containerModel,
						containerModel,
						containerModel,
						containerModel,
						containerModel,
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
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
						{"Work Surface", testBench}
					},
					Name -> {
						"Test container 1 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 2 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 3 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 4 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID,
						"Test filter 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 1 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 2 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 3 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 4 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container 5 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test DWP for fulfillableResourceQ tests" <> $SessionUUID,
						"Test container for sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID,
						"Test container for sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID
					},
					FastTrack -> True,
					Status->Join[
						ConstantArray[Available,4],
						ConstantArray[Stocked,6],
						{Available},
						{Stocked, Stocked}
					]
				];
				allSamples = ECL`InternalUpload`UploadSample[
					{
						waterModel,
						Model[Sample, StockSolution, "1x TBE Buffer"],
						Model[Sample, StockSolution, "1x TBE Buffer"],
						testSterileModel1,
						testSterileModel1
					},
					{
						{"A1", testContainer5},
						{"A1",plate},
						{"A2",plate},
						{"A1", sterileContainer1},
						{"A1", sterileContainer2}
					},
					Name -> {
						"Test StorageBuffer sample for fulfillableResourceQ tests" <> $SessionUUID,
						"Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID,
						"Test sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID,
						"Test sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID
					},
					InitialAmount -> 1 Milliliter,
					Status -> {Stocked,Available,Available, Available, Available},
					Sterile -> {
						Automatic,
						Automatic,
						Automatic,
						True,
						True
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Join[{testContainer1, testContainer2, testContainer3, testContainer4, testContainer5, stockedContainer1, stockedContainer2, stockedContainer3, stockedContainer4, stockedContainer5, plate, testContainer1, testContainer2}, allSamples]];

				(* make the user object; this doesn't really need to have anything? *)
				ECL`InternalUpload`UploadNotebook[
					{testContainer1, testContainer2, testContainer3, hplcInstrument1, hplcInstrument2, hplcInstrument3},
					{testNotebook1, testNotebook1, testNotebook1, testNotebook3, testNotebook4, testNotebook5}
				];

				Block[{$Notebook = testNotebook1},
					ECL`InternalUpload`UploadProtocol[<|
						Object -> testProtocol1,
						ResolvedOptions -> {},
						UnresolvedOptions -> {},
						DeveloperObject -> True,
						Name -> "Test protocol for ownership bug for fulfillableResourceQ tests" <> $SessionUUID,
						Replace[ContainersIn] -> {
							Link[Resource[Sample -> testContainer1], Protocols],
							Link[Resource[Sample -> testContainer2], Protocols],
							Link[Resource[Sample -> testContainer3], Protocols]
						}
					|>]
				];
				UploadSampleStatus[{testContainer1, testContainer2, testContainer3}, InUse, UpdatedBy -> testProtocol1];
				allProtResources = Download[testProtocol1, RequiredResources[[All, 1]][Object]];
				UploadResourceStatus[allProtResources, InUse, UpdatedBy -> testProtocol1, FastTrack -> True];
			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					{
						Object[Container, Site, "Test Site 1 For fulfillableResourceQ Tests " <> $SessionUUID],
						Model[Container, ProteinCapillaryElectrophoresisCartridge, "container cartridge test model" <> $SessionUUID],
						Object[Container, ProteinCapillaryElectrophoresisCartridge, "test container cartridge with insert (75 uses)" <> $SessionUUID],
						Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge test Insert" <> $SessionUUID],
						Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "test CESDS cartridge Insert" <> $SessionUUID],
						Model[Container, Vessel, "Test vessel for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Bench, "Test bench for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 1 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 2 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 3 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 4 for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 1 for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 2 for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 3 for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 4 for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container 5 for fulfillableResourceQ tests" <> $SessionUUID],
						Model[Item, Electrode, ReferenceElectrode, "reference electrode test model" <> $SessionUUID],
						Object[Item, Electrode, ReferenceElectrode, "test reference electrode (75 uses)" <> $SessionUUID],
						Object[User, "Test User (fulfillableResourceQ unit tests)" <> $SessionUUID],
						Object[User, "Test Author for fulfillableResourceQ Tests 2 " <> $SessionUUID],
						Object[User, "Test Author for fulfillableResourceQ Tests 3 " <> $SessionUUID],
						Object[Team, Financing, "Test Team (fulfillableResourceQ unit tests)" <> $SessionUUID],
						Object[Team, Financing, "Test Financing Team for fulfillableResourceQ Tests 2 " <> $SessionUUID],
						Object[Team, Financing, "Test Financing Team for fulfillableResourceQ Tests 3 " <> $SessionUUID],
						Object[LaboratoryNotebook, "Test Notebook 1 (fulfillableResourceQ unit tests)" <> $SessionUUID],
						Object[LaboratoryNotebook, "Test Notebook 2 (fulfillableResourceQ unit tests)" <> $SessionUUID],
						Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 3 " <> $SessionUUID],
						Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 4 " <> $SessionUUID],
						Object[LaboratoryNotebook, "fulfillableResourceQ Standard Financing Test Notebook 5 " <> $SessionUUID],
						Object[Product, "Test product 1 for StorageBuffer sample/container for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Product, "Test product 2 for ProteinCapillaryElectrophoresisCartridge for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Product, "Test product 3 for ReferenceElectrode for fulfillableResourceQ tests" <> $SessionUUID],
						Model[Container, Vessel, Filter, "Test filter model 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Vessel, Filter, "Test filter 1 with StorageBuffer for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Container, Plate, "Test DWP for fulfillableResourceQ tests" <> $SessionUUID],
						Model[Sample, "Test StorageBuffer sample model for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Sample, "Test StorageBuffer sample for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Sample, "Test sample 1 for fulfillableResourceQ tests" <> $SessionUUID],
						Object[Sample, "Test sample 2 for fulfillableResourceQ tests" <> $SessionUUID],
						Download[
							Object[Protocol, HPLC, "Test protocol for ownership bug for fulfillableResourceQ tests" <> $SessionUUID],
							{Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}
						],
						Model[Sample, "Test sterile model 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Model[Sample, "Test sterile model 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Model[Sample, "Test sterile model 3 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Sample, "Test sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Sample, "Test sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container for sterile object 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Container, Vessel, "Test container for sterile object 2 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Product, "Test sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Object[Product, "Test non-sterile product 1 for fulfillableResourceQ unit tests" <> $SessionUUID],
						Model[Instrument, HPLC, "Test HPLC Model 1 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 1 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 2 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 3 For fulfillableResourceQ Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 4 For fulfillableResourceQ Tests " <> $SessionUUID]
					}
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*fulfillableResources*)


DefineTests[fulfillableResources,
	{
		Example[{Basic, "Checks to see if a requested resource can be fulfilled given the current state of the lab:"},
			fulfillableResources[Object[Resource, Sample, "id:eGakldJ8oJke"]],
			fulfillableResourcesP
		],
		Example[{Additional, "SpecificItem", "Works on a resource blob requesting a specific Object:"},
			fulfillableResources[
				Resource[Sample -> Object[Container, Plate, "Test DWP for fulfillableResources unit tests" <> $SessionUUID]]
			],
			fulfillableResourcesP
		],
		Example[{Basic, "Checks resource to see if a requested resource can be fulfilled given the current state of the lab:"},
			fulfillableResources[Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter]],
			fulfillableResourcesP
		],
		Example[{Basic, "Checks to see if a request on a specific sample has enough volume available to be fulfilled:"},
			fulfillableResources[Object[Resource, Sample, "id:jLq9jXvxpRlx"]],
			fulfillableResourcesP
		],
		Example[{Basic, "Checks to see if a request on a specific sample has enough volume available to be fulfilled:"},
			fulfillableResources[Resource[Sample -> Object[Sample, "id:N80DNj1pLRrl"], Amount -> 75*Microliter]],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether an instrument request is fulfillable:"},
			fulfillableResources[{Object[Resource, Instrument, "id:1ZA60vLXepaw"], Object[Resource, Instrument, "id:Z1lqpMzm0O7z"]}],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether an instrument resource request is fulfillable:"},
			fulfillableResources[
				{
					Resource[Instrument -> Object[Instrument, HPLC, "id:R8e1PjprXOEv"], Time -> 3*Hour],
					Resource[Instrument -> Model[Instrument, HPLC, "id:E8zoYvNjAKnw"], Time -> 3*Hour]
				}
			],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether a storage instrument resource request is fulfillable if two models are provided:"},
			fulfillableResources[
					Resource[
						Instrument -> {
							Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for fulfillableResources" <> $SessionUUID],
							Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"]
						},
						Time -> 3*Hour
					]
			],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether an operator request is fulfillable:"},
			fulfillableResources[Object[Resource, Operator, "id:4pO6dM5EwDNr"]],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether an operator resource request is fulfillable:"},
			fulfillableResources[Resource[Operator -> Object[User, Emerald, Operator, "id:Z1lqpMzm0Pj9"]]],
			fulfillableResourcesP
		],
		Example[{Additional, "Checks to see whether item resources with VolumeOfUses is fulfillable:"},
			fulfillableResources[
				{
					Resource[<|Sample -> Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"], VolumeOfUses -> Quantity[200, "Milliliters"], Name -> "1", Type -> Object[Resource, Sample]|>],
					Resource[<|Sample -> Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"], VolumeOfUses -> Quantity[200, "Milliliters"], Name -> "2", Type -> Object[Resource, Sample]|>]
				}
			],
			fulfillableResourcesP
		],
		Example[{Options, Messages, "If Messages -> False, suppress the messages thrown indicating why a resource may be invalid:"},
			fulfillableResources[Object[Resource, Sample, "id:pZx9jo8Ad890"], Messages -> False],
			fulfillableResourcesP,
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Options, Author, "If the item does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the SamplesNotOwned error:"},
			fulfillableResources[{Object[Resource, Sample, "id:o1k9jAGJKbJx"]}, Author -> Object[User, "Fake user 1 for FulfillableResourceQ unit tests"]],
			fulfillableResourcesP,
			Stubs :> {
				$Notebook = Download[Object[LaboratoryNotebook, "Fake notebook 2 for FulfillableResourceQ unit tests"], Object],
				$PersonID = Object[User, Emerald, Developer, "steven"]
			}
		],
		Example[{Messages, "MissingObjects", "If a resource is provided that includes an object that does not exist, throw an error and return False:"},
			fulfillableResources[Resource[Sample -> Object[Sample, "id:2222j3jj3j3"], Amount -> 50*Microliter]],
			fulfillableResourcesP,
			Messages :> {Error::MissingObjects, Error::InvalidInput}
		],
		Example[{Messages, "MissingObjects", "If several resources are provided and only one doesn't exist, still succesfully test the rest of them:"},
			Lookup[fulfillableResources[
				{
					Resource[Sample -> Object[Sample, "id:2222j3jj3j3"], Amount -> 50*Microliter],
					Resource[Operator -> Object[User, Emerald, Operator, "id:Z1lqpMzm0Pj9"]],
					Resource[Sample -> Model[Item, Consumable, "id:vXl9j578pWOd"]],
					Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter]
				}
			], MissingObjects],
			{ObjectP[Object[Resource]]},
			Messages :> {Error::MissingObjects, Error::NoAvailableModel, Error::InvalidInput}
		],
		Example[{Messages, "ContainerNotAutoclaveCompatible", "If a sterile stock solution is requested, it must be in a autoclave compatible container:"},
			fulfillableResources[Resource[Sample -> Model[Sample, StockSolution, "Test Autoclaved StockSolution for fulfillableResources tests" <> $SessionUUID], Amount -> 50*Microliter, Container -> Model[Container, Vessel, "50mL Tube"]]],
			fulfillableResourcesP,
			Messages :> {Error::ContainerNotAutoclaveCompatible, Error::InvalidInput}
		],
		Example[{Messages, "OptionLengthMismatch", "If the Subprotocol option is provided but is not index matched with the input, throw an error:"},
			fulfillableResources[{Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter], Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter]},Subprotocol->{False,True, False}],
			$Failed,
			Messages :> {Error::OptionLengthMismatch}
		],
		Example[{Messages, "SamplesMarkedForDisposal", "If the requested sample is marked for disposal, throw an error and return False:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:4pO6dM5wa3Xo"], Amount -> 2*Microliter]], SamplesMarkedForDisposal],
			{ObjectP[Object[Resource]]},
			Messages :> {Error::SamplesMarkedForDisposal, Error::InvalidInput}
		],
		Test["If the requested sample is marked for disposal but we're in a subprotocol don't throw an error since users can enqueue an experiment and then indicate samples should be disposed on completion:",
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:4pO6dM5wa3Xo"], Amount -> 2*Microliter], Subprotocol->True], SamplesMarkedForDisposal],
			{}
		],
		Example[{Messages, "DeprecatedModels", "If the requested model is deprecated, throw an error and return False:"},
			Lookup[fulfillableResources[{Resource[Sample -> Model[Sample, "id:01G6nvwMaEZ7"], Amount -> 50*Microliter], Resource[Sample -> Object[Sample, "id:Vrbp1jK57MVx"], Amount -> 3*Microliter]}], DeprecatedModels],
			{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::DeprecatedModels, Error::InvalidInput}
		],
		Example[{Messages, "RentedKit", "If a kit model is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable from kits, throw a message and return False:"},
			Lookup[fulfillableResources[Resource[Sample -> Model[Item, Column,"Model Column 3 for FulfillableResourceQ unit tests (rented kits)"], Rent -> True]], RentedKit],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::RentedKit, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "DeprecatedProduct", "If a consumable model is requested in a resource and there is no non-deprecated product available, throw a warning saying it might be aborted:"},
			Lookup[fulfillableResources[Resource[Sample -> Model[Item, Consumable, "Model consumable 345 for FulfillableResourceQ unit tests"]]], DeprecatedProduct],
			{ObjectP[Object[Resource]]},
			Messages :> {Warning::DeprecatedProduct}
		],
		Example[{Messages, "DiscardedSamples", "If the requested sample is deprecated, throw an error and return False:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:XnlV5jK17Bq8"], Amount -> 2*Microliter]], DiscardedSamples],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Test["If the requested sample is deprecated, throw an error and return False, works even if the object sample is Model-less:",
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "Discarded Sample without Model for FRQ Testing"], Amount -> 2*Microliter]], DiscardedSamples],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Example[{Messages, "ExpiredSamples", "If the requested sample is expired, throw a warning but still return True:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter]], ExpiredSamples],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Warning::ExpiredSamples}
		],
		Test["If the requested sample is expired and the resource is for a subprotocol don't throw a warning since we've already started:",
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:P5ZnEjdzWMKE"], Amount -> 3*Microliter], Subprotocol->True], ExpiredSamples],
			{}
		],
		Example[{Messages, "RetiredInstrument", "If an instrument is specified but it is retired, throw an error and return False:"},
			Lookup[fulfillableResources[Resource[Instrument -> Object[Instrument, HPLC, "id:R8e1PjpXWada"], Time -> 3*Hour]], RetiredInstrument],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Error::RetiredInstrument, Error::InvalidInput}
		],
		Example[{Messages, "DeprecatedInstrument", "If an instrument is specified but it has a deprecated model, throw an error and return False:"},
			Lookup[fulfillableResources[Resource[Instrument -> Model[Instrument, HPLC, "id:lYq9jRxnqBAY"], Time -> 3*Hour]], DeprecatedInstrument],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput}
		],
		Example[{Messages, "DeckLayoutUnavailable", "If an instrument is specified and the DeckLayout with it is not available for that instrument, throw an error and return False:"},
			Lookup[fulfillableResources[Resource[Instrument -> Model[Instrument, HPLC, "id:lYq9jRxnqBAY"], DeckLayout -> Model[DeckLayout,"Test DeckLayout for Electrophoresis Instrument for RequireResources"]]], DeckLayoutUnavailable],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Error::DeprecatedInstrument, Error::DeckLayoutUnavailable, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableStoragePosition", "If a CrystalIncubator Model is specified and no plate slot is not available for that instrument, throw a warning and return True:"},
			Lookup[fulfillableResources[Resource[Instrument -> Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for fulfillableResources" <> $SessionUUID]]], StoragePositionUnavailable],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Warning::NoAvailableStoragePosition}
		],
		Example[{Messages, "NoAvailableStoragePosition", "If a CrystalIncubator is specified and no plate slot is not available for that instrument, throw a warning and return True:"},
			Lookup[fulfillableResources[Resource[Instrument -> Object[Instrument, CrystalIncubator, "Test Crystal Incubator for fulfillableResources" <> $SessionUUID]]], StoragePositionUnavailable],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Warning::NoAvailableStoragePosition}
		],
		Example[{Messages, "SiteUnknown", "If specified instruments do not have site, throw an error and return False:"},
			fulfillableResources[Resource[Instrument -> Model[Instrument, CrystalIncubator, "Test Siteless Instrument Model for fulfillableResources" <> $SessionUUID]]],
			fulfillableResourcesP,
			Messages :> {Error::SiteUnknown, Error::InvalidInput}
		],
		Example[{Messages, "NoSuitableSite", "If specified instruments do not have site, throw an error and return True:"},
			fulfillableResources[Resource[Instrument -> Object[Instrument, CrystalIncubator, "Test Crystal Incubator 2 for fulfillableResources" <> $SessionUUID]]],
			fulfillableResourcesP,
			Messages :> {Error::NoSuitableSite}
		],
		Example[{Messages, "InstrumentUndergoingMaintenance", "If an instrument is specified but it is undergoing maintenance, throw a warning but still return True:"},
			Lookup[fulfillableResources[Resource[Instrument -> Object[Instrument, HPLC, "id:vXl9j578l1Pk"], Time -> 4*Hour]], InstrumentUndergoingMaintenance],
			{ObjectP[Object[Resource, Instrument]]},
			Messages :> {Warning::InstrumentUndergoingMaintenance}
		],
		Example[{Messages, "InsufficientTotalVolume", "If a model chemical is requested and the amount requested exceeds the total volume available in the lab across all samples, throw a message and return False for that resource:"},
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:pZx9jo8Ad890"]}], InsufficientTotalVolume],
			{ObjectP[Object[Resource, Sample, "id:pZx9jo8Ad890"]]},
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Test["If a model chemical is requested and there are zero instances of any kind of that model in the lab, throw a message and return False for that resource:",
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Fake model with no objects or product for fulfillableResources unit tests"], Amount -> 5*Milligram]], InsufficientTotalVolume],
			{PacketP[Object[Resource, Sample]]},
			Messages :> {Error::InsufficientTotalVolume, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableModel", "If a consumable model is requested and all copies in the lab are currently reserved, throw a message and return False for that resource:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:R8e1PjprLp1K"]], NoAvailableModel],
			{ObjectP[Object[Resource, Sample, "id:R8e1PjprLp1K"]]},
			Messages :> {Error::NoAvailableModel, Error::InvalidInput}
		],
		Example[{Messages, "NoAvailableSample", "If a kit model is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable from kits, this is actually still fine:"},
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Test Benz[a]anthracene for fulfillableResources kit tests"], Amount -> 1.1*Gram]], NoAvailableSample],
			{},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		(* note that this used to throw the NoAvailableSample message, but now it doesn't do that anymore and throws InsufficientTotalVolume.  It could conceivably still hit that error but TODO write a test that does *)
		Example[{Messages, "NoAvailableSample", "If a model in a hermetic container is requested and the amount exceeds the volume/mass of any one sample of that model in the lab and exceed the maximum amount orderable, throw a message and return False:"},
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Fake hermetic sample model for fulfillableResourceQ tests"], Amount -> 150 Milliliter]], NoAvailableSample],
			{},
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Test["If a model in a hermetic container is requested and the amount does NOT exceed the volume/mass of any one sample of that model in the lab or the maximum amount orderable, only throw a warning:",
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Fake hermetic sample model for fulfillableResourceQ tests"], Amount -> 97 Milliliter]], NoAvailableSample],
			{},
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "InsufficientVolume", "If a sample is requested and the amount requested exceeds the amount available, throw a message and return False:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:bq9LA0JXjZxz"]], InsufficientVolume],
			{ObjectP[Object[Resource, Sample, "id:bq9LA0JXjZxz"]]},
			Messages :> {Warning::InsufficientVolume}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a consumable sample is requested and there is already a request for this item, throw a message and return False:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:dORYzZJpLMRD"]], ResourceAlreadyReserved],
			{ObjectP[Object[Resource, Sample, "id:dORYzZJpLMRD"]]},
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a consumable sample is requested and there is already a request for this item, throw a message and return False:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Item,Consumable,"id:BYDOjvGlLRb9"]]], ResourceAlreadyReserved],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::ResourceAlreadyReserved, Error::InvalidInput}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a part is requested and there is already a request for this item, still return True because all parts are Reusable and thus both can be fulfilled:"},
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:N80DNj1pAz4W"], Object[Resource, Sample, "id:xRO9n3BjbYez"]}], ResourceAlreadyReserved],
			{}
		],
		Example[{Messages, "ResourceAlreadyReserved", "If a part is requested and there is already a request for this item, still return True because all parts are Reusable and thus both can be fulfilled:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Part, BeamStop, "Part resource for fulfillableResource(s/Q) unit tests"]]], ResourceAlreadyReserved],
			{}
		],
		Example[{Messages, "ContainerTooSmall", "If a ContainerModel is specified and the model specified needs to be moved to that container model but the MaxVolume of the destination is too low, throw a message and return an error:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:Vrbp1jKoALBw"]], ContainerTooSmall],
			{ObjectP[Object[Resource, Sample, "id:Vrbp1jKoALBw"]]},
			Messages :> {Error::ContainerTooSmall, Error::InvalidInput}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:KBL5Dvwr1kqd"]], SampleMustBeMoved],
			{ObjectP[Object[Resource, Sample, "id:KBL5Dvwr1kqd"]]},
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:D8KAEvGloG7K"], Container -> Model[Container, Vessel, "id:8qZ1VW0DjYeL"], Amount -> 400*Milliliter]], SampleMustBeMoved],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified with ContainerName and Well and the sample needs to be moved to that container model, throw a soft warning but still return True:"},
			Lookup[
				fulfillableResources[{
					Resource[
						Sample -> Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 1mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A1"
					],
					Resource[
						Sample -> Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 1mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A2"
					]
				}],
				{Fulfillable,SampleMustBeMoved}
			],
			{{True,True},{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}},
			Messages :> {Warning::SampleMustBeMoved,Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but not all the samples in the same container are being requested, throw a soft warning to move the sample but still return True:"},
			Lookup[
				fulfillableResources[
					Resource[
						Sample -> Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A1"
					]
				],
				{Fulfillable, SampleMustBeMoved}
			],
			{{True}, {ObjectP[Object[Resource, Sample]]}},
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but it does not match the existing position of the sample, throw a soft warning to move the sample but still return True:"},
			Lookup[
				fulfillableResources[{
					Resource[
						Sample -> Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A1"
					],
					Resource[
						Sample -> Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A3"
					]
				}],
				{Fulfillable, SampleMustBeMoved}
			],
			{{True, True}, {ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}},
			Messages :> {Warning::SampleMustBeMoved, Warning::SampleMustBeMoved}
		],
		Example[{Messages, "SampleMustBeMoved", "If a sample resource is requested with ContainerName and Well but an additional sample is also requested, throw a soft warning to move the sample but still return True:"},
			Lookup[
				fulfillableResources[{
					Resource[
						Sample -> Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A1"
					],
					Resource[
						Sample -> Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A2"
					],
					Resource[
						Sample -> Model[Sample, StockSolution, "1x TBE Buffer"],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A3"
					]
				}],
				{Fulfillable, SampleMustBeMoved}
			],
			{{True, True, True}, {ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}},
			Messages :> {Warning::SampleMustBeMoved, Warning::SampleMustBeMoved}
		],
		Test["If sample resources are requested with ContainerName and Well and they exactly match the current contents of the container, use the samples directly:",
			Lookup[
				fulfillableResources[{
					Resource[
						Sample -> Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A1"
					],
					Resource[
						Sample -> Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 1 Milliliter,
						ContainerName -> "test",
						Well -> "A2"
					]
				}],
				{Fulfillable, SampleMustBeMoved}
			],
			{{True, True}, {}}
		],
		Example[{Messages, "SamplesOutOfStock", "If a model is requested and there is not currently enough of that model in the lab, but a product exists from which we can reorder this item, throw a warning that the samples must be ordered but still return True:"},
			Lookup[fulfillableResources[Resource[Sample -> Model[Item,Consumable,"id:D8KAEvGlKM8O"]]], SamplesOutOfStock],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
				(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = False
			}
		],
		Test["If a model is requested and there is enough of it in the lab but all of it is InUse and the product is Stocked, still throw a warning that the sample is out of stock:",
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Developer model 1 for fulfillableResources SamplesOutOfStock tests"], Amount -> 1*Milliliter]], SamplesOutOfStock],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Warning::SamplesOutOfStock},
			Stubs :> {
			(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = True
			}
		],
		Test["If a model is requested and there is enough of it in the lab but all of it is InUse and the product is NOT stocked, don't throw a warning since we'll just wait:",
			Lookup[fulfillableResources[Resource[Sample -> Model[Sample, "Developer model 3 for fulfillableResources SamplesOutOfStock tests"], Amount -> 1*Milliliter]], SamplesOutOfStock],
			{},
			Stubs :> {
			(* need to do this for this specific test because this test overlaps with objects in ShipToECL stuff and I don't want to step on those toes *)
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified but the sample is already in that container model, throw no warning since the item does not need to be moved:"},
			Lookup[fulfillableResources[Object[Resource, Sample, "id:jLq9jXvxpBdW"]], SampleMustBeMoved],
			{}
		],
		Example[{Messages, "SampleMustBeMoved", "If a ContainerModel is specified but the sample is already in that container model, throw no warning since the item does not need to be moved:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "id:D8KAEvGloG7K"], Container -> Model[Container, Vessel, "id:J8AY5jDkq9m7"], Amount -> 400*Milliliter]], SampleMustBeMoved],
			{}
		],
		Example[{Messages, "SampleInTransit", "If a resource's sample has a status of Transit and the destination is ECL, throw warning but return True and list sample in SamplesInTransit key:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "Chemical 6 for FulfillableResourceQ unit tests (in Transit)"], Amount -> 100 Microliter]], {Fulfillable,SamplesInTransit}],
			{{True}, {ObjectP[Object[Resource, Sample]]}},
			Messages :> {Warning::SamplesInTransit}
		],
		Example[{Messages, "SamplesShippedFromECL", "If a resource's sample has a status of Transit and the destination is not ECL, throw error and return False and list sample in SamplesShippedFromECL key:"},
			Lookup[fulfillableResources[Resource[Sample -> Object[Sample, "Chemical for FulfillableResourceQ unit tests (SamplesShippedFromECL)"], Amount -> 100 Microliter]], {Fulfillable,SamplesShippedFromECL}],
			{{False}, {ObjectP[Object[Resource, Sample]]}},
			Messages :> {Error::SamplesShippedFromECL, Error::InvalidInput}
		],
		Example[{Messages, "SamplesNotOwned", "If a specific sample was requested and that sample is not owned by a notebook the Author has access to, throw an error and return False:"},
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:zGj91a7wRewv"], Object[Resource, Sample, "id:o1k9jAGJKbJx"]}], SamplesNotOwned],
			{ObjectP[Object[Resource, Sample, "id:zGj91a7wRewv"]]},
			Messages :> {Error::SamplesNotOwned, Error::InvalidInput},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "id:AEqRl9Kz5Yzv"]}
		],
		Example[{Messages, "NonScalableStockSolutionVolumeTooHigh", "Resources for stock solution models with VolumeIncrements populated must not request more than $MaxNumberOfFulfillmentPreps * Max[VolumeIncrements]:"},
			Lookup[
				fulfillableResources[Resource[
					Sample -> Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"],
					Amount -> 7 Milliliter
				]],
				NonScalableStockSolutionVolumeTooHigh
			],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::NonScalableStockSolutionVolumeTooHigh, Error::InvalidInput}
		],
		Example[{Messages, "NonScalableStockSolutionVolumeTooHigh", "VolumeOfUses cannot exceed the MaxVolumeUses of a single model:"},
			Lookup[
				fulfillableResources[
					{
						Resource[<|Sample -> Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"], VolumeOfUses -> Quantity[200, "Milliliters"], Name -> "1", Type -> Object[Resource, Sample]|>],
						Resource[<|Sample -> Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"], VolumeOfUses -> Quantity[310, "Milliliters"], Name -> "2", Type -> Object[Resource, Sample]|>]
					}
				],
				ExceedsMaxVolumeOfUses
			],
			{ObjectP[Object[Resource, Sample]]},
			Messages :> {Error::ExceedsMaxVolumesCanBeUsed, Error::InvalidInput}
		],
		Example[{Messages, "NonScalableStockSolutionVolumeTooHigh", "Two VolumeOfUses cannot be specified for the same resource (resources with the same name):"},
			resourceObject = Download[Object[Resource, Sample, "Test Resource for fulfillableResources 1 " <> $SessionUUID], Object];
			resourceID = Download[Object[Resource, Sample, "Test Resource for fulfillableResources 1 " <> $SessionUUID], ID];
			Lookup[
				fulfillableResources[
					{
						<|
							Models->{
								Link[Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"]]
							},
							Sample -> Null,
							Amount -> Null,
							ContainerModels -> {},
							Status -> Outstanding,
							Rent -> Null,
							NumberOfUses -> Null,
							VolumeOfUses -> Quantity[200, "Milliliters"],
							Name -> "Test Resource for fulfillableResources 1 " <> $SessionUUID,
							Object -> resourceObject,
							ID -> resourceID,
							Type -> Object[Resource, Sample]
						|>,
						<|
							Models->{
								Link[Model[Item, Filter, MicrofluidicChip, "id:mnk9jOkW03wb"]]
							},
							Sample -> Null,
							Amount -> Null,
							ContainerModels -> {},
							Status -> Outstanding,
							Rent -> Null,
							NumberOfUses -> Null,
							VolumeOfUses -> Quantity[220, "Milliliters"],
							Name -> "Test Resource for fulfillableResources 1 " <> $SessionUUID,
							Object -> resourceObject,
							ID -> resourceID,
							Type -> Object[Resource, Sample]
						|>
					}
				],
				ConflictingVolumeOfUses
			],

			{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]},

			Messages :> {Error::TwoVolumeOfUsesSpecifiedForOneResource, Error::InvalidInput},

			Variables :> {resourceObject, resourceID}
		],
		Test["If a specific public sample is requested for a root protocol throw an error:",
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:vXl9j57q8Gad"]}], SamplesNotOwned],
			{ObjectP[Object[Resource, Sample, "id:vXl9j57q8Gad"]]},
			Messages :> {Error::SamplesNotOwned, Error::InvalidInput},
			Stubs :> {
				$Notebook = Object[LaboratoryNotebook, "id:AEqRl9Kz5Yzv"],
				$PersonID = Object[User, "Fake user 2 for FulfillableResourceQ unit tests"]
			}
		],
		Example[{Options, Subprotocol, "If a specific public sample is requested for a subprotocol don't throw an error since the parent may have picked the sample but not transferred ownership:"},
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:vXl9j57q8Gad"]}, Subprotocol -> True], SamplesNotOwned],
			{},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "id:AEqRl9Kz5Yzv"]}
		],
		Test["If the requested sample is public and Subprotocol is True for that specific sample don't throw any messages:",
			Lookup[fulfillableResources[{Object[Resource, Sample, "id:eGakldJ8oJke"], Object[Resource, Sample, "id:vXl9j57q8Gad"]}, Subprotocol -> {False, True}], SamplesNotOwned],
			{},
			Stubs :> {$Notebook = Object[LaboratoryNotebook, "id:AEqRl9Kz5Yzv"]}
		],
		Test["When given an empty list, return an association with an empty list at every entry except Site:",
			fulfillableResources[{}],
			<|
				Resources -> {},
				Fulfillable -> {},
				InsufficientVolume -> {},
				ResourceAlreadyReserved -> {},
				NoAvailableSample -> {},
				InsufficientTotalVolume -> {},
				NoAvailableModel -> {},
				DeprecatedProduct -> {},
				ContainerTooSmall -> {},
				SampleMustBeMoved -> {},
				MissingObjects -> {},
				SamplesMarkedForDisposal -> {},
				DeprecatedModels -> {},
				DiscardedSamples -> {},
				ExpiredSamples -> {},
				InstrumentsNotOwned -> {},
				RetiredInstrument -> {},
				DeprecatedInstrument -> {},
				DeckLayoutUnavailable -> {},
				StoragePositionUnavailable -> {},
				InstrumentUndergoingMaintenance -> {},
				SamplesOutOfStock -> {},
				SamplesNotOwned -> {},
				SamplesInTransit -> {},
				SamplesInTransitPackets -> {},
				SamplesShippedFromECL -> {},
				RentedKit -> {},
				ExceedsMaxNumberOfUses -> {},
				ExceedsMaxVolumeOfUses -> {},
				ConflictingVolumeOfUses -> {},
				NonScalableStockSolutionVolumeTooHigh -> {},
				InvalidSterileRequest -> {},
				ContainerNotSterile -> {},
				SamplesOffSite -> {},
				Site -> ObjectP[Object[Container, Site]]
			|>
		],
		Test["If several resources are provided and only some are fulfillable, populate the Fulfillable key properly:",
			Lookup[fulfillableResources[
				{
					Resource[Sample -> Object[Sample, "id:2222j3jj3j3"], Amount -> 50*Microliter],
					Resource[Operator -> Object[User, Emerald, Operator, "id:Z1lqpMzm0Pj9"]],
					Resource[Sample -> Model[Item,Consumable,"id:vXl9j578pWOd"]],
					Resource[Sample -> Model[Sample, "id:GmzlKjPx4PM5"], Amount -> 90*Milliliter]
				}
			], Fulfillable],
			{False, True, False, True},
			Messages :> {Error::MissingObjects, Error::NoAvailableModel, Error::InvalidInput}
		],
		Test["Resources for plumbing objects are properly fulfillable:",
			fulfillableResources[Resource[Sample -> Model[Plumbing, Valve, "Chem Lab Gas Valve"]]],
			fulfillableResourcesP
		],
		Test["Resources for items that have more than 200 instances are tested for fulfillability slightly differently for performance reasons:",
			fulfillableResources[Resource[Sample -> Model[Item, Tips, "Fake tips model for high-quantity item fulfillableResourceQ test"]]],
			fulfillableResourcesP
		],
		Example[{Additional, "Multisite", "If the resource is in transit to ECL, use Destination for the Site of it:"},
			(*resource request with specification of the Site that does not have the instance, but will have it*)
			Lookup[
				fulfillableResources[Resource[Sample -> Object[Sample, "Test transit sample  for fulfillableResources unit tests" <> $SessionUUID]]],
				Site
			],
			ObjectP[Object[Container, Site, "Test site 1 for fulfillableResources" <> $SessionUUID]],
			Messages :> {Warning::SamplesInTransit}
		],

		Example[{Additional,"Plumbing Amounts","Supports searching for tubing Size when Amount is a distance:"},
			Lookup[
				fulfillableResources[Resource[Sample -> Model[Plumbing, Tubing, "PharmaPure #16"], Amount -> 1 Meter]],
				{Fulfillable,SamplesOutOfStock}
			],
			{{True},{}}
		],
		Example[{Additional, "Default Site", "If the same number of resources are at two different sites, use DefaultExperimentSite:"},
			(*resource request with specification of the Site that does not have the instance, but will have it*)
			Lookup[
				fulfillableResources[
					{
						Resource[Sample -> Object[Container,Vessel,"Test tube 4 for fulfillableResources" <> $SessionUUID]],
						Resource[Sample -> Object[Container,Vessel,"Test tube 3 for fulfillableResources" <> $SessionUUID]]
					},
					Author -> Object[User,"Fake User for fulfillableResources "<>$SessionUUID]
				],
				Site
			],
			ObjectP[Object[Container, Site, "Test site 1 for fulfillableResources" <> $SessionUUID]]
		],
		Example[{Additional, "Default Site", "When using DefaultExperimentSite, prioritize RootProtocol of the resources over the author:"},
			(*resource request with specification of the Site that does not have the instance, but will have it*)
			Lookup[
				fulfillableResources[
					{Object[Resource,Sample, "Test sample resource 2 for fulfillableResources "<>$SessionUUID]},
					Author -> Object[User,"Fake User for fulfillableResources "<>$SessionUUID]
				],
				Site
			],
			ObjectP[Object[Container, Site, "Test site 3 for fulfillableResources" <> $SessionUUID]]
		],
		Example[{Additional,"State conversion", "Properly works with cases of the liquid requested by weight:"},
			fulfillableResources[Object[Resource,Sample, "Test sample resource 2 for fulfillableResources "<>$SessionUUID]],
			fulfillableResourcesP
		],

		(* instrument ownership tests *)
		Example[{Options, Author, "For a single unlisted instrument resource object, if the instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResources[
				Object[Resource, Instrument, "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID],
				Author -> Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			],
			fulfillableResourcesP,
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "For a single unlisted instrument resource, if the instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResources[
				Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID]],
				Author -> Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			],
			fulfillableResourcesP,
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "If the instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResources[
				{
					Object[Resource, Instrument, "Test Resource 1 For fulfillableResources Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID],
					Object[Resource, Instrument, "Test Resource 4 For fulfillableResources Tests " <> $SessionUUID]
				},
				Author -> Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			],
			fulfillableResourcesP,
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Options, Author, "For instrument resources, if the instrument does not have the same notebook as $Notebook, but is a notebook available to the Author, don't throw the InstrumentsNotOwned error:"},
			fulfillableResources[
				{
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResources Tests " <> $SessionUUID]],
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID]],
					Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResources Tests " <> $SessionUUID]]
				},
				Author -> Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			],
			fulfillableResourcesP,
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "For a single unlisted instrument resource object, if a specific instrument is that is not owned by a notebook the Author has access to, throw an error and return False:"},
			Lookup[
				fulfillableResources[
					Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID]
				],
				InstrumentsNotOwned
			],
			{
				ObjectP[Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID]]
			},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "For a single unlisted instrument resource, if a specific instrument is that is not owned by a notebook the Author has access to, throw an error and return False:"},
			Lookup[
				Lookup[
					fulfillableResources[
						Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID]]
					],
					InstrumentsNotOwned
				],
				Instrument
			],
			{
				ObjectP[Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID]]
			},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "If a specific instrument is that is not owned by a notebook the Author has access to, throw an error and return False:"},
			Lookup[
				fulfillableResources[
					{
						Object[Resource, Instrument, "Test Resource 1 For fulfillableResources Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID],
						Object[Resource, Instrument, "Test Resource 4 For fulfillableResources Tests " <> $SessionUUID]
					}
				],
				InstrumentsNotOwned
			],
			{
				ObjectP[Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID]]
			},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		],
		Example[{Messages, "InstrumentsNotOwned", "For instrument resources, if a specific instrument is that is not owned by a notebook the Author has access to, throw an error and return False:"},
			Lookup[
				Lookup[
					fulfillableResources[
						{
							Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResources Tests " <> $SessionUUID]],
							Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID]],
							Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID]],
							Resource[Instrument -> Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResources Tests " <> $SessionUUID]]
						}
					],
					InstrumentsNotOwned
				],
				Instrument
			],
			{
				ObjectP[Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID]]
			},
			Messages :> {Error::InstrumentsNotOwned, Error::InvalidInput},
			Stubs :> {
				$Site = Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				$Notebook = Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				$PersonID = Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID]
			}
		]
	},
	Stubs :> {
		$EmailEnabled = False,
		$DeveloperSearch = True,
		$PersonID = Download[Object[User, "Fake user 1 for FulfillableResourceQ unit tests"], Object]
	},
	SymbolSetUp :> (
		$CreatedObjects = {};

		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test bench for fulfillableResources tests" <> $SessionUUID],
				Object[Container, Plate, "Test DWP for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "Test CrystallizationPlate for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 3 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 1 for fulfillableResources" <> $SessionUUID],
				Object[Sample, "Test transit sample  for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Site, "Test site 1 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test site 2 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test site 3 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for fulfillableResources" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Siteless Instrument Model for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator 2 for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Siteless Instrument for fulfillableResources" <> $SessionUUID],
				Model[Sample, "Test sample model for fulfillableResources "<>$SessionUUID],
				Object[Sample, "Test sample 4 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Resource,Sample, "Test sample resource for fulfillableResources "<>$SessionUUID],
				Object[Resource,Sample, "Test sample resource 2 for fulfillableResources "<>$SessionUUID],
				Object[Container,Vessel,"Test tube for fulfillableResources unit tests" <> $SessionUUID],
				Object[Team,Financing,"Fake team 1 for FulfillableResources unit tests" <> $SessionUUID],
				Object[Team,Financing,"Fake team 2 for FulfillableResources unit tests" <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team for fulfillableResources Tests 3 " <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team for fulfillableResources Tests 4 " <> $SessionUUID],
				Object[Container,Vessel,"Test tube 3 for fulfillableResources" <> $SessionUUID],
				Object[Container,Vessel,"Test tube 4 for fulfillableResources" <> $SessionUUID],
				Object[User,"Fake User for fulfillableResources "<>$SessionUUID],
				Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID],
				Object[User, "Test Author for fulfillableResources Tests 3 " <> $SessionUUID],
				Object[Protocol,"Fake protocol for fulfillableResources"<>$SessionUUID],
				Object[LaboratoryNotebook,"Fake notebook for fulfillableResources"<>$SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 3 " <> $SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				Model[Sample, StockSolution, "Test Autoclaved StockSolution for fulfillableResources tests" <> $SessionUUID],
				Object[Resource, Sample, "Test Resource for fulfillableResources 1 " <> $SessionUUID],
				Object[Plumbing,Tubing,"fulfillableResources Test tubing 1 "<>$SessionUUID],
				Object[Plumbing,Tubing,"fulfillableResources Test tubing 2 "<>$SessionUUID],
				Model[Instrument, HPLC, "Test HPLC Model 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 4 For fulfillableResources Tests " <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, plate, xtalPlate, samplesInVessels, container1, sample1, testSite1, testSite2, testSite3,
					testSite4, testCrystalIncubatorModel, testCrystalIncubatorModel2, testCrystalIncubator, testCrystalIncubator2,
					testCrystalIncubator3, testSampleModel, tube1, resource1, resource2, testNotebook1, testNotebook2,
					testNotebook3, testNotebook4, testUser1, testUser2, testUser3, hplcModel1, hplcInstrument1, hplcInstrument2,
					hplcInstrument3, hplcInstrument4, testInstrumentResource1, testInstrumentResource2, testInstrumentResource3,
					testInstrumentResource4, testTeam3, testTeam4, linkID1, linkID2, linkID3, linkID4, linkID5, linkID6,
					linkID7, linkID8, linkID9, linkID10, linkID11, linkID12, linkID13, linkID14
				},
				(* set up test bench and dishwasher as a location for the vessels/caps *)
				{testBench,testSampleModel} =Upload[{
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Test bench for fulfillableResources tests"<>$SessionUUID,
						Site->Link[$Site]
					|>,
					<|
						Type->Model[Sample],
						Name->"Test sample model for fulfillableResources "<>$SessionUUID,
						State->Liquid,
						Density->1Gram / Milliliter,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
					|>
				}];

				(* set up containers *)
				{plate, xtalPlate, tube1} = ECL`InternalUpload`UploadSample[
					{
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Bench Top Slot", Object[Container, Bench, "Test bench for fulfillableResources tests" <> $SessionUUID]},
						{"Bench Top Slot", Object[Container, Bench, "Test bench for fulfillableResources tests" <> $SessionUUID]},
						{"Bench Top Slot", Object[Container, Bench, "Test bench for fulfillableResources tests" <> $SessionUUID]}
					},
					Name -> {
						"Test DWP for fulfillableResources unit tests" <> $SessionUUID,
						"Test CrystallizationPlate for fulfillableResources unit tests" <> $SessionUUID,
						"Test tube for fulfillableResources unit tests" <> $SessionUUID
					}
				];

				(* set up samples *)
				samplesInVessels = ECL`InternalUpload`UploadSample[
					{
						Model[Sample, StockSolution, "1x TBE Buffer"],
						Model[Sample, StockSolution, "1x TBE Buffer"],
						Model[Sample, StockSolution, "480 mg/L Caffeine in 40% Methanol"],
						testSampleModel
					},
					{
						{"A1", plate},
						{"A2", plate},
						{"A1Drop1", xtalPlate},
						{"A1", tube1}
					},
					InitialAmount -> {1 Milliliter, 1 Milliliter, 10 Microliter,20 Milliliter},
					Name -> {
						"Test sample 1 for fulfillableResources unit tests" <> $SessionUUID,
						"Test sample 2 for fulfillableResources unit tests" <> $SessionUUID,
						"Test sample 3 for fulfillableResources unit tests" <> $SessionUUID,
						"Test sample 4 for fulfillableResources unit tests" <> $SessionUUID
					}
				];
				Upload[<|Object -> #|>& /@ Join[{plate, xtalPlate}, samplesInVessels]];

				{container1, testSite1, testSite2, testSite3, resource1, resource2, testNotebook1, testUser1} = Upload[{
					<|
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Site -> Link[$Site],
						Name -> "Test tube 1 for fulfillableResources" <> $SessionUUID
					|>,
					<|
						Type -> Object[Container, Site],
						Name -> "Test site 1 for fulfillableResources" <> $SessionUUID,
						Append[FinancingTeams] -> Link[Object[Team, Financing, "Fake team 2 for FulfillableResourceQ unit tests"], ExperimentSites]
					|>,
					<|
						Type -> Object[Container, Site],
						Name -> "Test site 2 for fulfillableResources" <> $SessionUUID
					|>,
					<|
						Type -> Object[Container, Site],
						Name -> "Test site 3 for fulfillableResources" <> $SessionUUID
					|>,
					<|
						Type->Object[Resource,Sample],
						Name->"Test sample resource for fulfillableResources "<>$SessionUUID,
						Amount->1Milliliter,
						Replace[Models]->{Link[testSampleModel]}
					|>,
					<|
						Type->Object[Resource,Sample],
						Name->"Test sample resource 2 for fulfillableResources "<>$SessionUUID,
						Amount->1Gram,
						Replace[Models]->{Link[testSampleModel]}
					|>,
					<|
						Type->Object[LaboratoryNotebook],
						Name->"Fake notebook for fulfillableResources"<>$SessionUUID
					|>,
					<|
						Type -> Object[User],
						Name -> "Fake User for fulfillableResources "<>$SessionUUID
					|>
				}];

				Upload[{
					<|
						Type -> Object[Team, Financing],
						Name -> "Fake team 1 for FulfillableResources unit tests" <> $SessionUUID,
						Replace[Members] -> Link[testUser1, FinancingTeams],
						Replace[ExperimentSites] -> {
							Link[testSite1,FinancingTeams],
							Link[testSite2,FinancingTeams],
							Link[testSite3,FinancingTeams]
						},
						DefaultExperimentSite -> Link[testSite1]
					|>,
					<|
						Type -> Object[Team, Financing],
						Name -> "Fake team 2 for FulfillableResources unit tests" <> $SessionUUID,
						Replace[ExperimentSites] -> {
							Link[testSite1,FinancingTeams],
							Link[testSite2,FinancingTeams],
							Link[testSite3,FinancingTeams]
						},
						Replace[NotebooksFinanced] -> Link[testNotebook1, Financers],
						DefaultExperimentSite -> Link[testSite3]
					|>,
					<|
						Type -> Object[Protocol],
						Name -> "Fake protocol for fulfillableResources"<>$SessionUUID,
						Replace[SubprotocolRequiredResources] -> Link[resource2, RootProtocol],
						Notebook -> Link[testNotebook1]
					|>,
					<|
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Site -> Link[testSite1],
						Name -> "Test tube 3 for fulfillableResources" <> $SessionUUID
					|>,
					<|
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Site -> Link[testSite2],
						Name -> "Test tube 4 for fulfillableResources" <> $SessionUUID
					|>,
					<|
						Type -> Model[Sample, StockSolution],
						Name -> "Test Autoclaved StockSolution for fulfillableResources tests" <> $SessionUUID,
						Autoclave -> True,
						AutoclaveProgram -> Universal,
						Replace[Formula] -> {
							{500 Milliliter, Link[Model[Sample, "Milli-Q water"]]},
							{500 Milliliter, Link[Model[Sample, "Methanol"]]}
						}
					|>,
					<|
						Type -> Object[Resource, Sample],
						Name -> "Test Resource for fulfillableResources 1 " <> $SessionUUID
					|>,
					<|
						Type -> Object[Plumbing,Tubing],
						Name -> "fulfillableResources Test tubing 1 "<>$SessionUUID,
						Model -> Link[Model[Plumbing, Tubing, "PharmaPure #16"],Objects],
						Size -> 10 Meter,
						Status -> Available,
						Transfer[Notebook] -> Null
					|>,
					<|
						Type -> Object[Plumbing,Tubing],
						Name -> "fulfillableResources Test tubing 2 "<>$SessionUUID,
						Model -> Link[Model[Plumbing, Tubing, "PharmaPure #16"],Objects],
						Size -> 0.5 Meter,
						Status -> Available,
						Transfer[Notebook] -> Null
					|>
				}];

				(* instrument ownership objects *)
				{
					testSite4,
					testUser2,
					testUser3,
					testTeam3,
					testTeam4,
					testNotebook2,
					testNotebook3,
					testNotebook4,
					hplcModel1,
					hplcInstrument1,
					hplcInstrument2,
					hplcInstrument3,
					hplcInstrument4,
					testInstrumentResource1,
					testInstrumentResource2,
					testInstrumentResource3,
					testInstrumentResource4
				} = CreateID[{
					Object[Container, Site],
					Object[User],
					Object[User],
					Object[Team, Financing],
					Object[Team, Financing],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Object[LaboratoryNotebook],
					Model[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Instrument, HPLC],
					Object[Resource, Instrument],
					Object[Resource, Instrument],
					Object[Resource, Instrument],
					Object[Resource, Instrument]
				}];

				{
					linkID1, linkID2, linkID3, linkID4, linkID5,
					linkID6, linkID7, linkID8, linkID9, linkID10,
					linkID11, linkID12, linkID13, linkID14
				} =
					CreateLinkID[14];

				Upload[{
					<|
						Object -> testSite4,
						Append[FinancingTeams] -> {
							Link[testTeam3, ExperimentSites, linkID7],
							Link[testTeam4, ExperimentSites, linkID11]
						},
						Name ->
							"Test Site 4 For fulfillableResources Tests " <> $SessionUUID
					|>,
					<|
						Object -> hplcModel1,
						Replace@Objects -> {
							Link[hplcInstrument1, Model, linkID1],
							Link[hplcInstrument2, Model, linkID6],
							Link[hplcInstrument3, Model, linkID12],
							Link[hplcInstrument4, Model, linkID14]
						},
						Name -> "Test HPLC Model 1 For fulfillableResources Tests " <> $SessionUUID
					|>,
					<|
						Object -> hplcInstrument1,
						Model -> Link[hplcModel1, Objects, linkID1],
						Name -> "Test HPLC Instrument 1 For fulfillableResources Tests " <> $SessionUUID,
						Site -> Link[testSite4]
					|>,
					<|
						Object -> hplcInstrument2,
						Model -> Link[hplcModel1, Objects, linkID6],
						Name -> "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID,
						Site -> Link[testSite4]
					|>,
					<|
						Object -> hplcInstrument3,
						Model -> Link[hplcModel1, Objects, linkID12],
						Name -> "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID,
						Site -> Link[testSite4]
					|>,
					<|
						Object -> hplcInstrument4,
						Model -> Link[hplcModel1, Objects, linkID14],
						Name -> "Test HPLC Instrument 4 For fulfillableResources Tests " <> $SessionUUID,
						Site -> Link[testSite4]
					|>,
					<|
						Object -> testUser2,
						Name -> "Test Author for fulfillableResources Tests 2 " <> $SessionUUID,
						Append[FinancingTeams] -> {Link[testTeam3, Members, linkID2]},
						Email -> $SessionUUID <> "fulfillableResources.nonexistent.email2@ecl.com"
					|>,
					<|
						Object -> testUser3,
						Name -> "Test Author for fulfillableResources Tests 3 " <> $SessionUUID,
						Append[FinancingTeams] -> {Link[testTeam4, Members, linkID8]},
						Email -> $SessionUUID <> "fulfillableResources.nonexistent.email3@ecl.com"
					|>,
					<|
						Object -> testTeam3,
						Append[Members] -> {Link[testUser2, FinancingTeams, linkID2]},
						Append[Notebooks] -> {
							Link[testNotebook2, Editors, linkID4],
							Link[testNotebook4, Editors, linkID13]
						},
						Append[NotebooksFinanced] -> {
							Link[testNotebook2, Financers, linkID3]
						},
						Name -> "Test Financing Team for fulfillableResources Tests 3 " <> $SessionUUID,
						DefaultExperimentSite -> Link[testSite4],
						Append@ExperimentSites -> {Link[testSite4, FinancingTeams, linkID7]}
					|>,
					<|
						Object -> testTeam4,
						Append[Members] -> {Link[testUser3, FinancingTeams, linkID8]},
						Append[Notebooks] -> {Link[testNotebook3, Editors, linkID9]},
						Append[NotebooksFinanced] -> {Link[testNotebook3, Financers, linkID10]},
						Name -> "Test Financing Team for fulfillableResources Tests 4 " <> $SessionUUID,
						DefaultExperimentSite -> Link[testSite4],
						Replace@ExperimentSites -> Link[testSite4, FinancingTeams, linkID11]
					|>,
					<|
						Object -> testNotebook2,
						Name -> "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID,
						Append[Financers] -> {Link[testTeam3, NotebooksFinanced, linkID3]},
						Append[Editors] -> {Link[testTeam3, Notebooks, linkID4]}
					|>,
					<|
						Object -> testNotebook3,
						Name -> "fulfillableResources Standard Financing Test Notebook 3 " <> $SessionUUID,
						Append[Financers] -> {Link[testTeam4, NotebooksFinanced, linkID10]},
						Append[Editors] -> {Link[testTeam4, Notebooks, linkID9]}
					|>,
					<|
						Object -> testNotebook4,
						Name -> "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID,
						Append[Editors] -> {Link[testTeam3, Notebooks, linkID13]}
					|>,
					<|
						Object -> testInstrumentResource1,
						Instrument -> Link[hplcInstrument1],
						Name -> "Test Resource 1 For fulfillableResources Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource2,
						Instrument -> Link[hplcInstrument2],
						Name -> "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource3,
						Instrument -> Link[hplcInstrument3],
						Name -> "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID,
						Status -> Outstanding
					|>,
					<|
						Object -> testInstrumentResource4,
						Instrument -> Link[hplcInstrument4],
						Name -> "Test Resource 4 For fulfillableResources Tests " <> $SessionUUID,
						Status -> Outstanding
					|>
				}];

				(* make the user object; this doesn't really need to have anything? *)
				ECL`InternalUpload`UploadNotebook[
					{hplcInstrument1, hplcInstrument2, hplcInstrument3},
					{testNotebook2, testNotebook3, testNotebook4}
				];
				(* end of instrument ownership objects *)


				sample1 = ECL`InternalUpload`UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", container1},
					Name -> "Test transit sample  for fulfillableResources unit tests" <> $SessionUUID,
					InitialAmount -> 20 Milliliter
				];
				(* Change the sample status to Transit *)
				Upload[<|Object -> sample1, Destination -> Link[testSite1], Status -> Transit|>];

				(* Create a test instrument *)
				{testCrystalIncubatorModel,testCrystalIncubatorModel2} =Upload[{
					<|
						Type->Model[Instrument,CrystalIncubator],
						Name->"Test Crystal Incubator Model for fulfillableResources"<>$SessionUUID,
						MinTemperature->3 Celsius,
						MaxTemperature->29 Celsius,
						Append[ImagingModes]->{VisibleLightImaging,UVImaging},
						Append[MicroscopeModes]->{BrightField,Polarized},
						MaxPlateDimensions->{130 Millimeter,86 Millimeter,45 Millimeter},
						Capacity->1,
						Replace[Positions]-><|Name->"Plate Slot",Footprint->Open,MaxWidth->0.2 Meter,MaxDepth->0.38 Meter,MaxHeight->0.6 Meter|>,
						Replace[PositionPlotting]-><|Name->"Plate Slot",XOffset->0.4 Meter,YOffset->0.2 Meter,ZOffset->1.48 Meter,CrossSectionalShape->Rectangle,Rotation->0.`|>,
						Transfer[Notebook]->Null
					|>,<|
						Type->Model[Instrument,CrystalIncubator],
						Name->"Test Siteless Instrument Model for fulfillableResources"<>$SessionUUID,
						MinTemperature->3 Celsius,
						MaxTemperature->29 Celsius,
						Append[ImagingModes]->{VisibleLightImaging},
						Append[MicroscopeModes]->{BrightField},
						MaxPlateDimensions->{130 Millimeter,86 Millimeter,45 Millimeter},
						Capacity->1,
						Replace[Positions]-><|Name->"Plate Slot",Footprint->Open,MaxWidth->0.2 Meter,MaxDepth->0.38 Meter,MaxHeight->0.6 Meter|>,
						Replace[PositionPlotting]-><|Name->"Plate Slot",XOffset->0.4 Meter,YOffset->0.2 Meter,ZOffset->1.48 Meter,CrossSectionalShape->Rectangle,Rotation->0.`|>,
						Transfer[Notebook]->Null
					|>
				}];
				{testCrystalIncubator,testCrystalIncubator2,testCrystalIncubator3} =Upload[{
					<|
						Type->Object[Instrument,CrystalIncubator],
						Name->"Test Crystal Incubator for fulfillableResources"<>$SessionUUID,
						Model->Link[testCrystalIncubatorModel,Objects],
						Transfer[Notebook]->Null,
						Site->Link[$Site]
					|>,
					<|
						Type->Object[Instrument,CrystalIncubator],
						Name->"Test Crystal Incubator 2 for fulfillableResources"<>$SessionUUID,
						Model->Link[testCrystalIncubatorModel,Objects],
						Transfer[Notebook]->Null,
						Site->Link[testSite2]
					|>,
					<|
						Type->Object[Instrument,CrystalIncubator],
						Name->"Test Siteless Instrument for fulfillableResources"<>$SessionUUID,
						Model->Link[testCrystalIncubatorModel2,Objects],
						Transfer[Notebook]->Null,
						Site->Null
					|>
				}];
				UploadInstrumentStatus[{testCrystalIncubator,testCrystalIncubator2,testCrystalIncubator3}, ConstantArray[Available,3]];
				(* Upload a plate to the only storage slot of the test crystal incubator so it can not accept more plates. *)
				ECL`InternalUpload`UploadLocation[xtalPlate, {"Plate Slot", testCrystalIncubator}];
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},

			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Test bench for fulfillableResources tests" <> $SessionUUID],
				Object[Container, Plate, "Test DWP for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "Test CrystallizationPlate for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 1 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 2 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Sample, "Test sample 3 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 1 for fulfillableResources" <> $SessionUUID],
				Object[Sample, "Test transit sample  for fulfillableResources unit tests" <> $SessionUUID],
				Object[Container, Site, "Test site 1 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test site 2 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test site 3 for fulfillableResources" <> $SessionUUID],
				Object[Container, Site, "Test Site 4 For fulfillableResources Tests " <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for fulfillableResources" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Siteless Instrument Model for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator 2 for fulfillableResources" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Siteless Instrument for fulfillableResources" <> $SessionUUID],
				Model[Sample, "Test sample model for fulfillableResources "<>$SessionUUID],
				Object[Sample, "Test sample 4 for fulfillableResources unit tests" <> $SessionUUID],
				Object[Resource,Sample, "Test sample resource for fulfillableResources "<>$SessionUUID],
				Object[Resource,Sample, "Test sample resource 2 for fulfillableResources "<>$SessionUUID],
				Object[Container,Vessel,"Test tube for fulfillableResources unit tests" <> $SessionUUID],
				Object[Team,Financing,"Fake team 1 for FulfillableResources unit tests" <> $SessionUUID],
				Object[Team,Financing,"Fake team 2 for FulfillableResources unit tests" <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team for fulfillableResources Tests 3 " <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team for fulfillableResources Tests 4 " <> $SessionUUID],
				Object[Container,Vessel,"Test tube 3 for fulfillableResources" <> $SessionUUID],
				Object[Container,Vessel,"Test tube 4 for fulfillableResources" <> $SessionUUID],
				Object[User,"Fake User for fulfillableResources "<>$SessionUUID],
				Object[User, "Test Author for fulfillableResources Tests 2 " <> $SessionUUID],
				Object[User, "Test Author for fulfillableResources Tests 3 " <> $SessionUUID],
				Object[Protocol,"Fake protocol for fulfillableResources"<>$SessionUUID],
				Object[LaboratoryNotebook,"Fake notebook for fulfillableResources"<>$SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 2 " <> $SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 3 " <> $SessionUUID],
				Object[LaboratoryNotebook, "fulfillableResources Standard Financing Test Notebook 4 " <> $SessionUUID],
				Model[Sample, StockSolution, "Test Autoclaved StockSolution for fulfillableResources tests" <> $SessionUUID],
				Object[Resource, Sample, "Test Resource for fulfillableResources 1 " <> $SessionUUID],
				Object[Plumbing,Tubing,"fulfillableResources Test tubing 1 "<>$SessionUUID],
				Object[Plumbing,Tubing,"fulfillableResources Test tubing 2 "<>$SessionUUID],
				Model[Instrument, HPLC, "Test HPLC Model 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 2 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 3 For fulfillableResources Tests " <> $SessionUUID],
				Object[Instrument, HPLC, "Test HPLC Instrument 4 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 1 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 2 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 3 For fulfillableResources Tests " <> $SessionUUID],
				Object[Resource, Instrument, "Test Resource 4 For fulfillableResources Tests " <> $SessionUUID]
			}], ObjectP[]];

			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[allObjects, Force -> True, Verbose -> False]
		];
		Unset[$CreatedObjects]
	)
];


(* ::Subsection:: *)
(*AllowedResourcePickingNotebooks*)

DefineTests[AllowedResourcePickingNotebooks,
	{
		Test["If given nothing, return empty list:",
			AllowedResourcePickingNotebooks[Null, Null],
			{}
		],
		Test["If given empty lists, return empty list:",
			AllowedResourcePickingNotebooks[{}, {}],
			{}
		],
		Test["If given a sharing team that is ViewOnly, do not return its notebooks:",
			AllowedResourcePickingNotebooks[{}, {Object[Team, Sharing, "Test Sharing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]}],
			{}
		],
		Test["If given a sharing team that is not ViewOnly, return its notebooks:",
			AllowedResourcePickingNotebooks[{}, {Object[Team, Sharing, "Test Sharing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]}],
			{ObjectP[Object[LaboratoryNotebook, "Test Sharing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]]}
		],
		Test["If given multiple financing teams, return their notebooks:",
			AllowedResourcePickingNotebooks[
				{
					Object[Team, Financing, "Test Financing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
					Object[Team, Financing, "Test Financing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]
				},
				{}
			],
			{ObjectP[Object[LaboratoryNotebook, "Test Financing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]], ObjectP[Object[LaboratoryNotebook, "Test Financing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]]}
		],
		Test["If given financing and sharing notebooks, return everything that isn't ViewOnly:",
			AllowedResourcePickingNotebooks[
				{
					Object[Team, Financing, "Test Financing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
					Object[Team, Financing, "Test Financing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]
				},
				{
					Object[Team, Sharing, "Test Sharing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
					Object[Team, Sharing, "Test Sharing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]
				}
			],
			{ObjectP[Object[LaboratoryNotebook]]..}
		]
	},
	SetUp :> (
		ClearMemoization[]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Team, Financing, "Test Financing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Sharing, "Test Sharing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Sharing, "Test Sharing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Financing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Financing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Sharing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Sharing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{financingTeam1, financingTeam2, sharingTeam1, sharingTeam2, financingNotebook1, financingNotebook2, sharingNotebook1, sharingNotebook2},
			{
				financingTeam1,
				financingTeam2,
				sharingTeam1,
				sharingTeam2,
				financingNotebook1,
				financingNotebook2,
				sharingNotebook1,
				sharingNotebook2
			} = CreateID[{
				Object[Team, Financing],
				Object[Team, Financing],
				Object[Team, Sharing],
				Object[Team, Sharing],
				Object[LaboratoryNotebook],
				Object[LaboratoryNotebook],
				Object[LaboratoryNotebook],
				Object[LaboratoryNotebook]
			}];
			Upload[{
				<|
					Object -> financingTeam1,
					DeveloperObject -> True,
					Name -> "Test Financing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID,
					Replace[Notebooks] -> {Link[financingNotebook1, Editors]},
					Replace[NotebooksFinanced] -> {Link[financingNotebook1, Financers]}
				|>,
				<|
					Object -> financingTeam2,
					DeveloperObject -> True,
					Name -> "Test Financing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID,
					Replace[Notebooks] -> {Link[financingNotebook2, Editors]},
					Replace[NotebooksFinanced] -> {Link[financingNotebook2, Financers]}
				|>,
				<|
					Object -> sharingTeam1,
					DeveloperObject -> True,
					Name -> "Test Sharing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID,
					Replace[Notebooks] -> {Link[sharingNotebook1, Viewers]},
					ViewOnly -> False
				|>,
				<|
					Object -> sharingTeam2,
					DeveloperObject -> True,
					Name -> "Test Sharing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID,
					Replace[Notebooks] -> {Link[sharingNotebook2, Viewers]},
					ViewOnly -> True
				|>,
				<|
					Object -> financingNotebook1,
					DeveloperObject -> True,
					Name -> "Test Financing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID
				|>,
				<|
					Object -> financingNotebook2,
					DeveloperObject -> True,
					Name -> "Test Financing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID
				|>,
				<|
					Object -> sharingNotebook1,
					DeveloperObject -> True,
					Name -> "Test Sharing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID
				|>,
				<|
					Object -> sharingNotebook2,
					DeveloperObject -> True,
					Name -> "Test Sharing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID
				|>
			}]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Team, Financing, "Test Financing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Financing, "Test Financing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Sharing, "Test Sharing Team 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[Team, Sharing, "Test Sharing Team 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Financing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Financing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Sharing Notebook 1 for AllowedResourcePickingNotebooks tests" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Sharing Notebook 2 for AllowedResourcePickingNotebooks tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsubsection::Closed:: *)
(*ModelObjectType*)

DefineTests[
	ModelObjectType,
	{
		Test["modelInstrument object converted to instrument type:",
			ModelObjectType[Model[Instrument, LiquidHandler, "id:12"]],
			Object[Instrument, LiquidHandler]
		],

		Test["modelInstrument type converted to instrument type:",
			ModelObjectType[Model[Instrument, LiquidHandler]],
			Object[Instrument, LiquidHandler]
		],

		Test["model object converted to sample type:",
			ModelObjectType[Model[Sample, "2,5-Dihydroxybenzoic acid"]],
			Object[Sample]
		],

		Test["model type converted to sample type:",
			ModelObjectType[Model[Sample]],
			Object[Sample]
		],

		Test["modelContainer object converted to container type:",
			ModelObjectType[Model[Container, Plate, "96-well UV-Star Plate"]],
			Object[Container, Plate]
		],

		Test["modelContainer type converted to container type:",
			ModelObjectType[Model[Container, Plate]],
			Object[Container, Plate]
		],

		Test["If given non-model type, return $Failed:",
			ModelObjectType[Object[Container, Vessel]],
			$Failed
		]
	},
	Stubs :> {
		Download[objRef:ObjectReferenceP[],Type]:=Most[objRef],
		Download[objRefs:{ObjectReferenceP[]..},Type]:=Download[#,Type]&/@objRefs
	}
];

(* ::Subsection::Closed:: *)
(* RootProtocol *)
DefineTests[RootProtocol,
	{
		Example[{Basic, "Returns the root when given a subprotocol:"},
			RootProtocol[Object[Protocol, ImageSample, "id:XnlV5jKZlLXP"]],
			Object[Qualification, PlateReader, "id:aXRlGn6JB6LB"]
		],
		Example[{Basic, "Returns the same protocol when given a protocol with no parent:"},
			RootProtocol[Object[Qualification, PlateReader, "id:aXRlGn6JB6LB"]],
			Object[Qualification, PlateReader, "id:aXRlGn6JB6LB"]
		]
    }
];

(* ::Subsection::Closed:: *)
(* ScanValue *)
DefineTests[ScanValue,
	{
		Example[{Basic, "Returns the provided container since its sticker can be directly scanned:"},
			ScanValue[Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID], Object[Container, Rack, "ScanValue Test Rack 1 " <> $SessionUUID]],
			Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID]
		],
		Example[{Basic, "When given a sample returns its container since the sample itself cannot be scanned:"},
			ScanValue[Object[Sample, "ScanValue Test Sample 1 " <> $SessionUUID], Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID]],
			Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID]
		],
		Example[{Basic, "When given a sample with AsepticTransportContainerType -> Bulk, returns the container:"},
			ScanValue[Object[Item, "ScanValue Test Self-Contained Bulk Aseptic Sample" <> $SessionUUID], Object[Container, Bag, Aseptic, "ScanValue Test Bulk Aseptic Bag" <> $SessionUUID]],
			ObjectP[Object[Container, Bag, Aseptic, "ScanValue Test Bulk Aseptic Bag" <> $SessionUUID]]
		],
		Example[{Basic, "When given a fluid sample with AsepticTransportContainerType -> Bulk, returns the container of the container:"},
			ScanValue[Object[Sample, "ScanValue Test Fluid Bulk Aseptic Sample" <> $SessionUUID], Object[Container, Vessel, "ScanValue Test Fluid Bulk Aseptic Container" <> $SessionUUID]],
			ObjectP[Object[Container, Bag, Aseptic, "ScanValue Test Fluid Bulk Aseptic Bag" <> $SessionUUID]]
		],
		Example[{Basic, "When given a sample with AsepticTransportContainerType -> Individual, returns the container:"},
			ScanValue[Object[Item, "ScanValue Test Self-Contained Individual Aseptic Sample" <> $SessionUUID], Object[Container, Bag, Aseptic, "ScanValue Test Individual Aseptic Bag" <> $SessionUUID]],
			ObjectP[Object[Container, Bag, Aseptic, "ScanValue Test Individual Aseptic Bag" <> $SessionUUID]]
		],
		Example[{Basic, "When given a fluid sample with AsepticTransportContainerType -> Individual, returns the container of the container:"},
			ScanValue[Object[Sample, "ScanValue Test Fluid Individual Aseptic Sample" <> $SessionUUID], Object[Container, Vessel, "ScanValue Test Fluid Individual Aseptic Container" <> $SessionUUID]],
			ObjectP[Object[Container, Bag, Aseptic, "ScanValue Test Fluid Individual Aseptic Bag" <> $SessionUUID]]
		]
	},
    SymbolSetUp :> (
			Module[{objects,existingObjects},
				objects=Quiet[Cases[
					Flatten[{
						Object[Container, Bench, "Test bench for ScanValue" <> $SessionUUID],
						Model[Item, "Test sample item for ScanValue" <> $SessionUUID],
						Model[Sample, "Test sample model for ScanValue" <> $SessionUUID],
						Model[Container, Vessel, "Test container model for ScanValue" <> $SessionUUID],
						Model[Container, Bag, Aseptic, "Test bag model for ScanValue" <> $SessionUUID],
						Object[Container, Bag, Aseptic, "ScanValue Test Bulk Aseptic Bag" <> $SessionUUID],
						Object[Container, Bag, Aseptic, "ScanValue Test Fluid Bulk Aseptic Bag" <> $SessionUUID],
						Object[Container, Bag, Aseptic, "ScanValue Test Individual Aseptic Bag" <> $SessionUUID],
						Object[Container, Bag, Aseptic, "ScanValue Test Fluid Individual Aseptic Bag" <> $SessionUUID],
						Object[Container, Vessel, "ScanValue Test Fluid Bulk Aseptic Container" <> $SessionUUID],
						Object[Container, Vessel, "ScanValue Test Fluid Individual Aseptic Container" <> $SessionUUID],
						Object[Item, "ScanValue Test Self-Contained Bulk Aseptic Sample" <> $SessionUUID],
						Object[Item, "ScanValue Test Self-Contained Individual Aseptic Sample" <> $SessionUUID],
						Object[Sample, "ScanValue Test Fluid Bulk Aseptic Sample" <> $SessionUUID],
						Object[Sample, "ScanValue Test Fluid Individual Aseptic Sample" <> $SessionUUID],
						Object[Sample, "ScanValue Test Sample 1 " <> $SessionUUID],
						Object[Sample, "ScanValue Test Sample 2 " <> $SessionUUID],
						Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID],
						Object[Container, Vessel, "ScanValue Test Container 2 " <> $SessionUUID],
						Object[Container, Rack, "ScanValue Test Rack 1 " <> $SessionUUID]
					}],
					ObjectP[]
				]];
				existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
				EraseObject[existingObjects,Force->True,Verbose->False]
			];
			Module[{
				testBench, tube1, tube2, rack1, waterSample1, waterSample2, asepticItemModel, asepticFluidSampleModel, asepticContainerModel, asepticBagModel,
				asepticSample1, asepticSample2, asepticSample3, asepticSample4, asepticContainer1, asepticContainer2, asepticBag1, asepticBag2, asepticBag3, asepticBag4
			},
				$CreatedObjects = {};

				{testBench, asepticItemModel, asepticFluidSampleModel, asepticContainerModel, asepticBagModel, tube1, tube2, rack1} = Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ScanValue" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>,
					<|
						Type -> Model[Item],
						Name -> "Test sample item for ScanValue" <> $SessionUUID,
						DeveloperObject -> True,
						AsepticTransportContainerType -> Bulk,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>,
					<|
						Type -> Model[Sample],
						Name -> "Test sample model for ScanValue" <> $SessionUUID,
						DeveloperObject -> True,
						AsepticTransportContainerType -> Bulk,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Container, Vessel],
						Name -> "Test container model for ScanValue" <> $SessionUUID,
						DeveloperObject -> True,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> Null, MaxDepth -> Null, MaxHeight -> Null|>}
					|>,
					<|
						Type -> Model[Container, Bag, Aseptic],
						Name -> "Test bag model for ScanValue" <> $SessionUUID,
						DeveloperObject -> True,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> Null, MaxDepth -> Null, MaxHeight -> Null|>}
					|>,
					<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"],Objects], Name -> "ScanValue Test Container 1 " <> $SessionUUID|>,
					<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"],Objects], Name -> "ScanValue Test Container 2 " <> $SessionUUID|>,
					<|Type -> Object[Container,Rack], Model -> Link[Model[Container, Rack, "id:BYDOjv1VAAml"],Objects], Name -> "ScanValue Test Rack 1 " <> $SessionUUID|>
				}];

				{
					asepticBag1,
					asepticBag2,
					asepticBag3,
					asepticBag4
				}=ECL`InternalUpload`UploadSample[
					{
						asepticBagModel,
						asepticBagModel,
						asepticBagModel,
						asepticBagModel
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"ScanValue Test Bulk Aseptic Bag" <> $SessionUUID,
						"ScanValue Test Fluid Bulk Aseptic Bag" <> $SessionUUID,
						"ScanValue Test Individual Aseptic Bag" <> $SessionUUID,
						"ScanValue Test Fluid Individual Aseptic Bag" <> $SessionUUID
					}
				];

				{asepticContainer1, asepticContainer2} = ECL`InternalUpload`UploadSample[
					{
						asepticContainerModel,
						asepticContainerModel
					},
					{
						{"A1", asepticBag2},
						{"A1", asepticBag4}
					},
					Status -> Available,
					Name -> {
						"ScanValue Test Fluid Bulk Aseptic Container" <> $SessionUUID,
						"ScanValue Test Fluid Individual Aseptic Container" <> $SessionUUID
					}
				];

				{
					asepticSample1,
					asepticSample2,
					asepticSample3,
					asepticSample4,
					waterSample1,
					waterSample2
				}=ECL`InternalUpload`UploadSample[
					{
						asepticItemModel,
						asepticFluidSampleModel,
						asepticItemModel,
						asepticFluidSampleModel,
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", asepticBag1},
						{"A1", asepticContainer1},
						{"A1", asepticBag3},
						{"A1", asepticContainer2},
						{"A1", tube1},
						{"A1", tube2}
					},
					Status -> Available,
					Name -> {
						"ScanValue Test Self-Contained Bulk Aseptic Sample" <> $SessionUUID,
						"ScanValue Test Fluid Bulk Aseptic Sample" <> $SessionUUID,
						"ScanValue Test Self-Contained Individual Aseptic Sample" <> $SessionUUID,
						"ScanValue Test Fluid Individual Aseptic Sample" <> $SessionUUID,
						"ScanValue Test Sample 1 " <> $SessionUUID,
						"ScanValue Test Sample 2 " <> $SessionUUID
					},
					InitialAmount -> {
						Null,
						100*Milliliter,
						Null,
						100*Milliliter,
						100 Microliter,
						100 Microliter
					}
				];

			]
		),
		SymbolTearDown :> Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ScanValue" <> $SessionUUID],
					Model[Item, "Test sample item for ScanValue" <> $SessionUUID],
					Model[Sample, "Test sample model for ScanValue" <> $SessionUUID],
					Model[Container, Vessel, "Test container model for ScanValue" <> $SessionUUID],
					Model[Container, Bag, Aseptic, "Test bag model for ScanValue" <> $SessionUUID],
					Object[Container, Bag, Aseptic, "ScanValue Test Bulk Aseptic Bag" <> $SessionUUID],
					Object[Container, Bag, Aseptic, "ScanValue Test Fluid Bulk Aseptic Bag" <> $SessionUUID],
					Object[Container, Bag, Aseptic, "ScanValue Test Individual Aseptic Bag" <> $SessionUUID],
					Object[Container, Bag, Aseptic, "ScanValue Test Fluid Individual Aseptic Bag" <> $SessionUUID],
					Object[Container, Vessel, "ScanValue Test Fluid Bulk Aseptic Container" <> $SessionUUID],
					Object[Container, Vessel, "ScanValue Test Fluid Individual Aseptic Container" <> $SessionUUID],
					Object[Item, "ScanValue Test Self-Contained Bulk Aseptic Sample" <> $SessionUUID],
					Object[Item, "ScanValue Test Self-Contained Individual Aseptic Sample" <> $SessionUUID],
					Object[Sample, "ScanValue Test Fluid Bulk Aseptic Sample" <> $SessionUUID],
					Object[Sample, "ScanValue Test Fluid Individual Aseptic Sample" <> $SessionUUID],
					Object[Sample, "ScanValue Test Sample 1 " <> $SessionUUID],
					Object[Sample, "ScanValue Test Sample 2 " <> $SessionUUID],
					Object[Container, Vessel, "ScanValue Test Container 1 " <> $SessionUUID],
					Object[Container, Vessel, "ScanValue Test Container 2 " <> $SessionUUID],
					Object[Container, Rack, "ScanValue Test Rack 1 " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
			EraseObject[existingObjects,Force->True,Verbose->False]
		]
];


(* ::Subsection::Closed:: *)
(* ResourcesOnCart *)
DefineTests[ResourcesOnCart,
	{
		Example[{Basic, "Returns a list of resources currently on a cart, excluding samples and covers on containers:"},
			ResourcesOnCart[{
				Object[Sample, "ResourcesOnCart Test 1 " <> $SessionUUID],
				Object[Sample, "ResourcesOnCart Test 2 " <> $SessionUUID],
				Object[Container, Vessel, "ResourcesOnCart Test 1 " <> $SessionUUID],
				Object[Container, Vessel, "ResourcesOnCart Test 2 " <> $SessionUUID],
				Object[Container, Vessel, "ResourcesOnCart Test 3 " <> $SessionUUID],
				Object[Item, Cap, "ResourcesOnCart Cap 1" <> $SessionUUID],
				Object[Instrument, Pipette, "ResourcesOnCart Test Pipette 1 " <> $SessionUUID]
			}],
			{ObjectP[Object[Container, Vessel]], ObjectP[Object[Container, Vessel]], ObjectP[Object[Container, Vessel]], ObjectP[Object[Instrument, Pipette]]}
		],
		Example[{Basic, "Ignore stacked plates:"},
			ResourcesOnCart[{
				Object[Container, Plate, "ResourcesOnCart Test Plate 1 " <> $SessionUUID],
				Object[Container, Plate, "ResourcesOnCart Test Plate 2 " <> $SessionUUID]
			}],
			{ObjectP[Object[Container, Plate]]}
		],
		Example[{Additional, "By default, this function ignores items that's in portable cooler or heater even if they are on cart:"},
			ResourcesOnCart[
				{
					Object[Container, Vessel, "ResourcesOnCart Test 1 " <> $SessionUUID],
					Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 1 " <> $SessionUUID],
					Object[Container, Vessel, "ResourcesOnCart Test tube in heater 1 " <> $SessionUUID]
				}
			],
			{ObjectP[Object[Container, Vessel, "ResourcesOnCart Test 1 " <> $SessionUUID]]}
		],
		Example[{Options, IncludePortableCooler, "When IncludePortableCooler -> True, function will also include items that are in portable cooler EVEN IF it's not on a cart:"},
			ResourcesOnCart[{Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 2 " <> $SessionUUID]}, IncludePortableCooler -> True],
			{ObjectP[{Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 2 " <> $SessionUUID]}], ObjectP[{Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in cooler 2 " <> $SessionUUID]}]}
		],
		Example[{Options, IncludePortableHeater, "When IncludePortableCooler -> True, function will also include items that are in portable heater EVEN IF it's not on a cart:"},
			ResourcesOnCart[{Object[Container, Vessel, "ResourcesOnCart Test tube in heater 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in heater 2 " <> $SessionUUID]}, IncludePortableHeater -> True],
			{ObjectP[{Object[Container, Vessel, "ResourcesOnCart Test tube in heater 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in heater 2 " <> $SessionUUID]}], ObjectP[{Object[Container, Vessel, "ResourcesOnCart Test tube in heater 1 " <> $SessionUUID], Object[Container, Vessel, "ResourcesOnCart Test tube in heater 2 " <> $SessionUUID]}]}
		]
	},
	SymbolSetUp :> Module[
		{tubePacket,cartPacket,capPacket, tube1,tube2, tube3,cap1,pipette,cart,waterSample1,waterSample2,
		cartPacket2,platePackets,cart2,plate1,plate2,pipettePacket, cooler1, cooler2, heater1, heater2, coolerPacket, heaterPacket,
		coolertube1, coolertube2, heatertube1, heatertube2},
		$CreatedObjects = {};

		tubePacket = <|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects]|>;
		capPacket = <|Type -> Object[Item,Cap], Model -> Link[Model[Item, Cap, "Tube Cap, Opaque 13x6mm"], Objects]|>;
		cartPacket = <|Type -> Object[Container, OperatorCart], Model -> Link[Model[Container, OperatorCart, "Chemistry Lab Cart"], Objects]|>;
		cartPacket2 = <|Type -> Object[Container, OperatorCart], Model -> Link[Model[Container, OperatorCart, "Chemistry Lab Cart"], Objects]|>;
		coolerPacket = <| Type -> Object[Instrument, PortableCooler], Model -> Link[Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"], Objects] |>;
		heaterPacket = <| Type -> Object[Instrument, PortableHeater], Model -> Link[Model[Instrument, PortableHeater, "id:3em6ZvLv7bZv"], Objects] |>;
		
		platePackets = {
			Association[
				Type -> Object[Container,Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "ResourcesOnCart Test Plate 1 " <> $SessionUUID
			],
			Association[
				Type -> Object[Container,Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "ResourcesOnCart Test Plate 2 " <> $SessionUUID
			]
		};

		pipettePacket = <|
			Type -> Object[Instrument, Pipette],
				Model -> Link[Model[Instrument, Pipette, "Eppendorf Research Plus, 8-channel 10uL"], Objects],
				Name -> "ResourcesOnCart Test Pipette 1 " <> $SessionUUID
		|>;

		{tube1, tube2, tube3, cap1, pipette, cart, cart2, plate1, plate2, cooler1, cooler2, heater1, heater2, coolertube1, coolertube2, heatertube1, heatertube2} = Upload[Flatten@{
			Append[tubePacket, Name -> "ResourcesOnCart Test 1 " <> $SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test 2 " <> $SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test 3 " <> $SessionUUID],
			Append[capPacket, Name -> "ResourcesOnCart Cap 1" <> $SessionUUID],
			pipettePacket,
			cartPacket,
			cartPacket2,
			platePackets,
			Append[coolerPacket, Name -> "ResourceOnCart Test cooler on cart "<>$SessionUUID],
			Append[coolerPacket, Name -> "ResourceOnCart Test cooler off cart "<>$SessionUUID],
			Append[heaterPacket, Name -> "ResourceOnCart Test heater on cart "<>$SessionUUID],
			Append[heaterPacket, Name -> "ResourceOnCart Test heater off cart "<>$SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test tube in cooler 1 " <> $SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test tube in cooler 2 " <> $SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test tube in heater 1 " <> $SessionUUID],
			Append[tubePacket, Name -> "ResourcesOnCart Test tube in heater 2 " <> $SessionUUID]
		}];
		UploadCover[tube3, Cover -> cap1];
		
		ECL`InternalUpload`UploadStack[plate1, plate2];
		
		{waterSample1, waterSample2} = ECL`InternalUpload`UploadSample[
			{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			{{"A1", tube1}, {"A1", tube2}},
			InitialAmount -> {100 Microliter, 100 Microliter},
			Name -> {"ResourcesOnCart Test 1 " <> $SessionUUID, "ResourcesOnCart Test 2 " <> $SessionUUID}
		];

		ECL`InternalUpload`UploadLocation[
			{tube1, tube2, tube3, pipette, plate1, cooler1, heater1},
			{{"Tray Slot", cart}, {"Tray Slot", cart}, {"Tray Slot", cart}, {"Tray Slot", cart}, {"Tray Slot", cart2}, {"Tray Slot", cart}, {"Tray Slot", cart}},
			FastTrack -> True
		];

		ECL`InternalUpload`UploadLocation[
			{coolertube1, coolertube2, heatertube1, heatertube2},
			{{"A1", cooler1}, {"A1", cooler2}, {"Sample Slot", heater1}, {"Sample Slot", heater2}},
			FastTrack -> True
		]
	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(* ModelInstances *)
DefineTests[ModelInstances,
	{
		Example[{Basic, "Returns potential samples of isopropanol which can be used to satisfy the requested resource:"},
			ModelInstances[
				Object[Resource, Sample, "Sample Resource for ModelInstances unit tests" <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID]
			],
			{_Association..}
		],
	    Example[{Basic, "Returns potential samples of isopropanol which can be used to satisfy the requested resource:"},
			ModelInstances[
				Object[Resource, Sample, "ModelInstances Test Filter Resource 1 " <> $SessionUUID],
				Object[Protocol, CrossFlowFiltration, "ModelInstances Test CFF Protocol " <> $SessionUUID]
			],
			{_Association..}
		],
	    Example[{Basic, "Returns an empty list if the volume is not fulfilled:"},
		    ModelInstances[
			    Object[Resource, Sample, "ModelInstances Test Filter Resource 1 " <> $SessionUUID],
			    Object[Protocol, CrossFlowFiltration, "ModelInstances Test CFF Protocol " <> $SessionUUID],
			    MaxVolumeOfUses -> 300 Milliliter,
			    VolumeOfUsesRequired -> 301 Milliliter
		    ],
			{}
		],
		(* Containers are not supported right now - only Samples and Items
		Example[{Basic, "In the case where a container is requested, empty stocked containers are returned:"},
			ModelInstances[
				Object[Resource,Sample, "Container Resource for ModelInstances unit tests" <> $SessionUUID],
				Object[Protocol,Transfer,"ModelInstances Test Transfer Protocol " <> $SessionUUID]
			],
			{_Association..}
		],*)
		Example[{Options, OutputFormat, "Show a table of potential options along with their key properties:"},
			ModelInstances[
				Object[Resource, Sample, "Sample Resource for ModelInstances unit tests" <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				OutputFormat -> Table
			],
			_Pane
		],
		Example[{Options, Well, "Specify which position the resource should be in for finding the potential samples:"},
			ModelInstances[
				Object[Resource, Sample, "Plate Resource Sample 3 for ModelInstances unit tests" <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Well -> "A3"
			],
			{_Association..}
		],
		Example[{Options, Well, "Specify which position the resource should be in for finding the potential samples. If the position does not match, return an empty list:"},
			ModelInstances[
				Object[Resource, Sample, "Plate Resource Sample 2 for ModelInstances unit tests" <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Well -> "A1"
			],
			{}
		],
		Example[{Options, Well, "Specify which position the sample model should be in for finding the potential samples:"},
			ModelInstances[
				Model[Sample, "Test sample model for ModelInstances unit tests" <> $SessionUUID],
				50Microliter,
				{Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				{},
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Well -> "A3"
			],
			{KeyValuePattern["Value" -> ObjectP[Object[Sample, "Test sample 3 for ModelInstances unit tests" <> $SessionUUID]]]}
		],
		Example[{Options, Well, "Specify which position the sample model should be in for finding the potential samples. If the position does not match, return an empty list:"},
			ModelInstances[
				Model[Sample, "Test sample model for ModelInstances unit tests" <> $SessionUUID],
				50Microliter,
				{Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				{},
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Well -> "A2"
			],
			{}
		],
		Example[{Options, Hermetic, "Specify whether samples in hermetic containers should be included as potential instances:"},
			ModelInstances[
				Model[Sample, "Test sample model for ModelInstances unit tests" <> $SessionUUID],
				50Microliter,
				{},
				{},
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
				Hermetic -> True
			],
			{KeyValuePattern["Value" -> ObjectP[Object[Sample, "Test sample 4 for ModelInstances unit tests" <> $SessionUUID]]]}
		]
	},
	SymbolSetUp :> Module[{allObjects,existsFilter,sampleModel,tube1,tube2,tube3,plate,sample1,sample2,sample3,sample4,parentMSPProtocol,transferProtocol,resources,sampleResource,containerResource,cffProtocolID,
		filterResourcePacket,cffFilterResource,rspProtocolID,rspResourcePacket,rspProtocolResources},
		$CreatedObjects = {};

		allObjects = {
			Object[Sample, "Test sample 1 for ModelInstances unit tests" <> $SessionUUID],
			Object[Sample, "Test sample 2 for ModelInstances unit tests" <> $SessionUUID],
			Object[Sample, "Test sample 3 for ModelInstances unit tests" <> $SessionUUID],
			Object[Sample, "Test sample 4 for ModelInstances unit tests" <> $SessionUUID],
			Object[Container, Vessel, "Test tube 1 for ModelInstances unit tests" <> $SessionUUID],
			Object[Container, Vessel, "Test tube 2 for ModelInstances unit tests" <> $SessionUUID],
			Object[Container, Vessel, "Test tube 3 for ModelInstances unit tests" <> $SessionUUID],
			Object[Container,Plate, "Test plate for ModelInstances unit tests" <> $SessionUUID],
			Object[Protocol, ManualSamplePreparation, "ModelInstances Test MSP Protocol " <> $SessionUUID],
			Object[Protocol, Transfer, "ModelInstances Test Transfer Protocol " <> $SessionUUID],
			Object[Protocol, RoboticSamplePreparation, "ModelInstances Test RSP Protocol " <> $SessionUUID],
			Object[Resource, Sample, "Sample Resource for ModelInstances unit tests" <> $SessionUUID],
			Object[Protocol, CrossFlowFiltration, "ModelInstances Test CFF Protocol " <> $SessionUUID],
			Object[Resource, Sample, "ModelInstances Test Filter Resource 1 " <> $SessionUUID],
			Object[Resource, Sample, "Container Resource for ModelInstances unit tests" <> $SessionUUID],
			Object[Resource, Sample, "Plate Resource Sample 1 for ModelInstances unit tests" <> $SessionUUID],
			Object[Resource, Sample, "Plate Resource Sample 2 for ModelInstances unit tests" <> $SessionUUID],
			Object[Resource, Sample, "Plate Resource Sample 3 for ModelInstances unit tests" <> $SessionUUID],
			Model[Sample, "Test sample model for ModelInstances unit tests" <> $SessionUUID]
		};

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter = DatabaseMemberQ[allObjects];

		Quiet[EraseObject[PickList[allObjects, existsFilter], Force -> True, Verbose -> False]];

		sampleModel = UploadSampleModel["Test sample model for ModelInstances unit tests" <> $SessionUUID,
			Composition->{
				{100 VolumePercent, Model[Molecule, "Water"]},
				{100 Milligram/Milliliter, Model[Molecule, "Sodium Chloride"]}
			},
			State -> Liquid,
			DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
			Expires -> True,
			ShelfLife -> 1 Month,
			UnsealedShelfLife -> 2 Week,
			MSDSFile -> NotApplicable,
			Flammable -> False,
			BiosafetyLevel -> "BSL-1",
			IncompatibleMaterials -> {None}
		];

		{tube1, tube2, plate, tube3} = Upload[{
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],Objects],
				Name -> "Test tube 1 for ModelInstances unit tests" <> $SessionUUID
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],Objects],
				Name -> "Test tube 2 for ModelInstances unit tests" <> $SessionUUID
			|>,
			<|
				Type -> Object[Container,Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
				Name -> "Test plate for ModelInstances unit tests" <> $SessionUUID
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],Objects],
				Name -> "Test tube 3 for ModelInstances unit tests" <> $SessionUUID,
				Hermetic -> True
			|>
		}];

		{sample1, sample2, sample3, sample4} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample, "Isopropanol"],
				Model[Sample, "Isopropanol"],
				sampleModel,
				sampleModel
			},
			{
				{"A1", tube1},
				{"A1", tube2},
				{"A3", plate},
				{"A1", tube3}
			},
			InitialAmount -> {
				100 Microliter,
				100 Microliter,
				100 Microliter,
				100 Microliter
			},
			Name -> {
				"Test sample 1 for ModelInstances unit tests" <> $SessionUUID,
				"Test sample 2 for ModelInstances unit tests" <> $SessionUUID,
				"Test sample 3 for ModelInstances unit tests" <> $SessionUUID,
				"Test sample 4 for ModelInstances unit tests" <> $SessionUUID
			}
		];

		parentMSPProtocol = Upload[<|Type -> Object[Protocol, ManualSamplePreparation], Name -> "ModelInstances Test MSP Protocol "<>$SessionUUID|>];
		transferProtocol = ExperimentTransfer[
			Model[Sample, "Isopropanol"],
			Model[Container, Vessel, "2mL Tube"],
			50 Microliter,
			Name -> "ModelInstances Test Transfer Protocol " <> $SessionUUID,
			ParentProtocol -> parentMSPProtocol
		];

		resources = Download[transferProtocol, BatchedUnitOperations[[1]][RequiredResources]];

		sampleResource = FirstCase[resources, {res_, SourceLink, _, _} :> res][Object];
		containerResource = FirstCase[resources, {res_, DestinationLink, _, _} :> res][Object];
		
		cffProtocolID = CreateID[Object[Protocol, CrossFlowFiltration]];
		filterResourcePacket = <|
			Object -> cffProtocolID,
			Type -> Object[Protocol, CrossFlowFiltration],
			Replace[CrossFlowFilters] -> {
				Link[
					Resource[
						Sample -> Model[Item, Filter, MicrofluidicChip, "id:M8n3rxnoDY79"],
						Name -> "ModelInstances Test Filter Resource 1 " <> $SessionUUID,
						VolumeOfUses -> 100 Milliliter
					]
				]
			},
			Name -> "ModelInstances Test CFF Protocol " <> $SessionUUID
		|>;
		
		RequireResources[filterResourcePacket];
		cffFilterResource= FirstOrDefault[Download[cffProtocolID, RequiredResources[[All, 1]][Object]]];

		rspProtocolID = CreateID[Object[Protocol, RoboticSamplePreparation]];
		rspResourcePacket = <|
			Object -> rspProtocolID,
			Type -> Object[Protocol, RoboticSamplePreparation],
			Replace[RequiredObjects] -> {
				Link[
					Resource[
						Sample -> sampleModel,
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 100 Microliter
					]
				],
				Link[
					Resource[
						Sample -> sampleModel,
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 100 Microliter,
						ContainerName -> "test",
						Well -> "A1"
					]
				],
				Link[
					Resource[
						Sample -> sampleModel,
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Amount -> 100 Microliter,
						ContainerName -> "test",
						Well -> "A3"
					]
				]
			},
			Name -> "ModelInstances Test RSP Protocol " <> $SessionUUID
		|>;
		RequireResources[rspResourcePacket];
		rspProtocolResources = Download[rspProtocolID, RequiredResources[[All, 1]][Object]];
		
		Upload[{
			<|Object -> sampleResource, Name -> "Sample Resource for ModelInstances unit tests" <> $SessionUUID|>,
			<|Object -> cffFilterResource, Name -> "ModelInstances Test Filter Resource 1 " <> $SessionUUID|>,
			<|Object -> containerResource, Name -> "Container Resource for ModelInstances unit tests" <> $SessionUUID|>,
			<|Object -> rspProtocolResources[[1]], Name -> "Plate Resource Sample 1 for ModelInstances unit tests" <> $SessionUUID|>,
			<|Object -> rspProtocolResources[[2]], Name -> "Plate Resource Sample 2 for ModelInstances unit tests" <> $SessionUUID|>,
			<|Object -> rspProtocolResources[[3]], Name -> "Plate Resource Sample 3 for ModelInstances unit tests" <> $SessionUUID|>
		}]

	],
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(*ConsolidationInstances*)


DefineTests[
	ConsolidationInstances,
	{
		Test["For a Model[Sample] request with a volume returns a list with possible samples which can be consolidated to fulfill the resource:",
			ConsolidationInstances[
				Model[Sample,"Fake Acetonitrile HPLC grade model for resource consolidation testing"],
				8.5*Liter,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			Association[
				"PossibleSamples" -> {OrderlessPatternSequence[Object[Sample, "id:Z1lqpMzzmEPO"],Object[Sample, "id:dORYzZJJpxjE"], Object[Sample, "id:eGakldJJ8E7x"], Object[Sample, "id:4pO6dM55E0Pz"], Object[Sample, "id:Vrbp1jKKo6Lm"], Object[Sample, "id:4pO6dM555RwM"]]},
				"SamplesAmounts" -> {OrderlessPatternSequence[Quantity[2.`,"Liters"],Quantity[4.`,"Liters"],Quantity[5.`,"Liters"],Quantity[4.`,"Liters"],Quantity[1.`,"Liters"],Quantity[2.`,"Liters"]]},
				"UserOwned" -> {OrderlessPatternSequence[False, False, False, True, True, True]},
				"RequestedModel" -> Model[Sample, "Fake Acetonitrile HPLC grade model for resource consolidation testing"]
			],
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["For a Model[Sample] request with a mass returns a list with possible samples which can be consolidated to fulfill the resource:",
			ConsolidationInstances[
				Model[Sample,"Fake salt chemical model for resource consolidation testing"],
				8.5*Gram,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			Association[
				"PossibleSamples" -> {OrderlessPatternSequence[Object[Sample, "id:qdkmxzqqe74V"], Object[Sample, "id:R8e1Pjppr9Av"], Object[Sample, "id:O81aEBZZp9dx"], Object[Sample, "id:AEqRl9KKNAra"], Object[Sample, "id:o1k9jAGGZ3xa"]]},
				"SamplesAmounts" -> {OrderlessPatternSequence[Quantity[2.`,"Grams"],Quantity[4.`,"Grams"],Quantity[5.`,"Grams"],Quantity[4.`,"Grams"],Quantity[1.5`,"Grams"]]},
				"UserOwned" -> {OrderlessPatternSequence[False, False, False, True, True]},
				"RequestedModel" -> Model[Sample, "Fake salt chemical model for resource consolidation testing"]
			],
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["For a Model[Sample,StockSolution] returns a list with possible samples which can be consolidated to fulfill the resource:",
			ConsolidationInstances[
				Model[Sample,StockSolution,"Fake 70% Ethanol model for resource consolidation testing"],
				8.5*Liter,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			Association[
				"PossibleSamples" -> {OrderlessPatternSequence[Object[Sample, "id:Vrbp1jKKo6LE"], Object[Sample, "id:XnlV5jKKRMYB"], Object[Sample, "id:qdkmxzqqe74M"], Object[Sample, "id:n0k9mG881Ld6"], Object[Sample, "id:01G6nvwwlALr"]]},
				"SamplesAmounts" -> {OrderlessPatternSequence[Quantity[2.`,"Liters"],Quantity[4.`,"Liters"],Quantity[5.`,"Liters"],Quantity[4.`,"Liters"],Quantity[1.5`,"Liters"]]},
				"UserOwned" -> {OrderlessPatternSequence[False, False, False, True, True]},
				"RequestedModel"-> Model[Sample,StockSolution,"Fake 70% Ethanol model for resource consolidation testing"]
			],
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["PossibleSamples includes both user owned and public samples since we'll decide later which samples to use:",
			ConsolidationInstances[
				Model[Sample,StockSolution,"Fake 70% Ethanol model for resource consolidation testing"],
				5.1*Liter,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			Association[
				"PossibleSamples" -> {OrderlessPatternSequence[Object[Sample, "id:Vrbp1jKKo6LE"],Object[Sample, "id:XnlV5jKKRMYB"],Object[Sample, "id:qdkmxzqqe74M"], Object[Sample, "id:n0k9mG881Ld6"], Object[Sample, "id:01G6nvwwlALr"]]},
				"SamplesAmounts" -> {OrderlessPatternSequence[Quantity[2.`,"Liters"],Quantity[4.`,"Liters"],Quantity[5.`,"Liters"],Quantity[4.`,"Liters"],Quantity[1.5`,"Liters"]]},
				"UserOwned" -> {OrderlessPatternSequence[False, False, False, True, True]},
				"RequestedModel" -> Model[Sample, StockSolution, "Fake 70% Ethanol model for resource consolidation testing"]
			],
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Module[{assoc},
			Test["A sample that is InUse by the given protocol can be included in the consolidation:",
				assoc=ConsolidationInstances[
					Model[Sample,"Fake Acetonitrile HPLC grade model for resource consolidation testing"],
					6.9*Liter,
					{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
					Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
					Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
				];
				Cases[Transpose[{Lookup[assoc, "PossibleSamples"],Download[Lookup[assoc, "PossibleSamples"], Status]}], {ObjectP[],InUse}][[All, 1]][Name],
				{"Sample with volume 8 (InUse by same protocol) for resource consolidation testing"},
				Stubs:>{
					$DeveloperSearch=True,
					$Site=Null
				}
			]
		],
		Test["For a model with no available sets that could fulfill the resource when consolidated, returns an empty list:",
			ConsolidationInstances[
				Model[Sample,"Fake chemical model 2 with insufficient sample volumes for resource consolidation testing"],
				4*Liter,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			{},
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["For a Model[Item,Consumable], returns an empty list:",
			ConsolidationInstances[
				Model[Item,Consumable,"id:R8e1PjRDbOXn"],
				Null,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			{},
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["For counted items such as Model[Item,Tips], returns an empty list:",
			ConsolidationInstances[
				Model[Item,Tips,"id:rea9jl1or6YL"],
				10,
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			{},
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Test["If there are no public or owned samples with total sufficient amount available to fulfill the resource, returns an empty list:",
			ConsolidationInstances[
				Model[Sample,"Fake salt chemical model for resource consolidation testing"],
				20 Gram,
				{Object[LaboratoryNotebook, "id:eGakldJJ8E7q"]},
				Object[Protocol, HPLC, "id:dORYzZJJpxjw"],
				Object[Protocol, HPLC, "id:dORYzZJJpxjw"]
			],
			{},
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		],
		Module[{assoc},
			Test["Samples that have AwaitingDisposal set to True are not included in the available sample set:",
				assoc=ConsolidationInstances[
					Model[Sample,"Fake Acetonitrile HPLC grade model for resource consolidation testing"],
					8.5*Liter,
					{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
					Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
					Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
				];
				Download[Lookup[assoc, "PossibleSamples"], AwaitingDisposal],
				{Null, Null, Null, Null, Null, Null},
				Stubs:>{
					$DeveloperSearch=True,
					$Site=Null
				}
			]
		],
		Test["Takes in a list of requested models and amounts now:",
			ConsolidationInstances[
				{Model[Sample, "Fake Acetonitrile HPLC grade model for resource consolidation testing"], Model[Sample,"Fake salt chemical model for resource consolidation testing"], Model[Item,Tips,"id:rea9jl1or6YL"]},
				{8.5 * Liter, 20 Gram, 10},
				{Object[LaboratoryNotebook,"id:eGakldJJ8E7q"]},
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"],
				Object[Protocol,HPLC,"id:dORYzZJJpxjw"]
			],
			{_Association, {}, {}},
			Stubs:>{
				$DeveloperSearch=True,
				$Site=Null
			}
		]
	}
];



