DefineTests[ExperimentPrepareTransporter,
	{
		Example[{Basic, "Function generates an Object[Protocol, PrepareTransporter] for items needs cold-transport:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareTransporter]]
		],
		Example[{Basic, "Function generates an Object[Protocol, PrepareTransporter] for items needs warmed-transport:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "2mL Tube"]},
				TransportTemperature -> 100 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareTransporter]]
		],
		Example[{Basic, "Function takes Object[Container] as input:"},
			ExperimentPrepareTransporter[
				{Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareTransporter]]
		],
		Example[{Additional, "Function takes Object[Item] as input:"},
			ExperimentPrepareTransporter[
				{Object[Item, Consumable, "Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareTransporter]]
		],
		Example[{Additional, "Function takes Model[Item] as input:"},
			ExperimentPrepareTransporter[
				{Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareTransporter]]
		],
		Example[{Additional, "Function will not re-use transporters that's already running by the root protocol:"},
			Lookup[
				ExperimentPrepareTransporter[
					{Model[Container, Vessel, "50mL Tube"]},
					TransportTemperature -> 4 Celsius,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					Output -> Options
				],
				Transporter
			],
			ObjectP[Model[Instrument, PortableCooler]]
		],
		Example[{Additional, "Function can handle a mixture of inputs, including Object[Sample], Object[Container], Object[Item], Model[Container], Model[Item]:"},
			ExperimentPrepareTransporter[
				{
					Object[Sample, "Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Sample, "Test sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Item, Column, "Test column model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Item, Consumable, "Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Item, Column, "Test column 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Container, Vessel, "50mL Tube"]
				},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			ObjectP[]
		],
		Example[{Additional, "When multiple Object[Sample] from the same container are supplied as input, the container will only be counted once when trying to fit them into the potential Transporters:"},
			protocol = ExperimentPrepareTransporter[
				{
					Object[Sample, "Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Sample, "Test plate sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Sample, "Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Sample, "Test plate sample 3 for ExperimentPrepareTransporter" <> $SessionUUID]
				},
				TransportTemperature -> {80 Celsius, 80 Celsius, 4 Celsius, 80 Celsius},
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			{
				DeleteDuplicates[Cases[Download[protocol, RequiredResources[[All,1]][Object]], ObjectP[Object[Resource, Instrument]]]],
				Download[protocol, Transporters],
				Lookup[Download[protocol, ResolvedOptions], Transporter]
			},
			{
				(* 1 more count when heaters are involved because we also need a fume hood *)
				{ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]]},
				{ObjectP[Model[Instrument, PortableHeater]], ObjectP[Model[Instrument, PortableCooler]]},
				{ObjectP[Model[Instrument, PortableHeater]], ObjectP[Model[Instrument, PortableHeater]], ObjectP[Model[Instrument, PortableCooler]], ObjectP[Model[Instrument, PortableHeater]]}
			},
			Variables :> {protocol}
		],
		Example[{Additional, "When multiple identical Object[Container] are supplied as input, the duplicated ones are disregarded when trying to fit them into the potential Transporters:"},
			protocol = ExperimentPrepareTransporter[
				{
					Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID]
				},
				TransportTemperature -> 80 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			DeleteDuplicates[Cases[Download[protocol, RequiredResources[[All,1]][Object]], ObjectP[Object[Resource, Instrument]]]],
			(* 1 more count when heaters are involved because we also need a fume hood *)
			{ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]]},
			Variables :> {protocol}
		],
		Example[{Additional, "When multiple identical Model[Container] are supplied as input, it will be interpreted as having multiple instances of the same kind of container:"},
			protocol = ExperimentPrepareTransporter[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				TransportTemperature -> 80 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			DeleteDuplicates[Cases[Download[protocol, RequiredResources[[All,1]][Object]], ObjectP[Object[Resource, Instrument]]]],
			(* 1 more count when heaters are involved because we also need a fume hood *)
			{ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]], ObjectP[Object[Resource, Instrument]]},
			Variables :> {protocol}
		],
		Example[{Options, Upload, "Function output packet instead of object if Upload -> False:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Upload -> False
			],
			{PacketP[]..}
		],
		Example[{Options, Transporter, "One can specify an Object[Instrument, PortableCooler] to indicate which exact transporter to pick:"},
			Lookup[
				ExperimentPrepareTransporter[
					{Model[Container, Vessel, "50mL Tube"]},
					TransportTemperature -> 4 Celsius,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Output -> Options,
					Transporter -> Object[Instrument, PortableCooler, "Test portable cooler 1 for ExperimentPrepareTransporter" <> $SessionUUID]
				],
				Transporter
			],
			ObjectP[Object[Instrument, PortableCooler, "Test portable cooler 1 for ExperimentPrepareTransporter" <> $SessionUUID]]
		],
		Example[{Options, Transporter, "When specifying the same Model[Instrument] as Transporter for multiple items, only one will be picked as long as they all can fit:"},
			protocol = ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"]
			];
			DeleteDuplicates[Cases[Download[protocol, RequiredResources[[All,1]][Object]], ObjectP[Object[Resource, Instrument]]]],
			{ObjectP[Object[Resource, Instrument]]},
			Variables :> {protocol}
		],
		Example[{Options, TransportTemperature, "TransportTemperature can be specified, and sometimes must be specified to resolve other options:"},
			Download[
				ExperimentPrepareTransporter[
					{Model[Container, Vessel, "50mL Tube"]},
					TransportTemperature -> -20 Celsius,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
				],
				Temperatures
			],
			{EqualP[-20 Celsius]}
		],
		Example[{Options, TransportTemperature, "For Object[Sample] and Object[Item] type of inputs, if TransportTemperature is not specified, the TransportTemperature of the object will be used:"},
			Download[
				ExperimentPrepareTransporter[
					{Object[Sample, "Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID], Object[Item, Consumable, "Test item 2 for ExperimentPrepareTransporter" <> $SessionUUID]},
					TransportTemperature -> Automatic,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
				],
				Temperatures
			],
			{EqualP[4 Celsius], EqualP[-10 Celsius]}
		],
		Example[{Options, TransportTemperature, "For Object[Sample] and Object[Item] type of inputs, if TransportTemperature is not specified and the TransportTemperature field of the object is Null, the TransportTemperature of the model will be used instead:"},
			Download[
				ExperimentPrepareTransporter[
					{Object[Sample, "Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID], Object[Item, Consumable, "Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
					TransportTemperature -> Automatic,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
				],
				Temperatures
			],
			{EqualP[80 Celsius], EqualP[4 Celsius]}
		],
		Example[{Options, IgnoreOversizedItems, "If IgnoreOversizedItems -> True, function ignores input items that can't physically fit to any available transporters:"},
			Lookup[
				ExperimentPrepareTransporter[
					{Model[Container, Vessel, "20L Polypropylene Carboy"], Model[Container, Vessel, "50mL Tube"]},
					TransportTemperature -> 4 Celsius,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Output -> Options,
					IgnoreOversizedItems -> True
				],
				Transporter
			],
			{Null, ObjectP[Model[Instrument]]},
			Messages :> {Warning::OversizedItem}
		],
		Example[{Options, Resource, "If Resource options are specified, the TemperatureControlledResources and ResourcePlacements fields will be populated with the resource objects:"},
			protocol = ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Resource -> {
					Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]
				}
			];
			Download[protocol, {TemperatureControlledResources, ResourcePlacements}],
			{
				{
					ObjectP[Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID]],
					ObjectP[Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]]
				},
				{
					{ObjectP[Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID]], ObjectP[Model[Instrument, PortableCooler]]},
					{ObjectP[Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]], ObjectP[Model[Instrument, PortableCooler]]}
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, Resource, "When oversized items exist, it will be excluded from the TemperatureControlledResources field, and in the ResourcePlacement field it will have Null as corresponding transporter:"},
			protocol = ExperimentPrepareTransporter[
				{Model[Container, Vessel, "20L Polypropylene Carboy"], Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Resource -> {
					Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]
				}
			];
			Download[protocol, {TemperatureControlledResources, ResourcePlacements}],
			{
				{
					ObjectP[Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]]
				},
				{
					{ObjectP[Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID]], Null},
					{ObjectP[Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID]], ObjectP[Model[Instrument, PortableCooler]]}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::OversizedItem}
		],
		Example[{Options, Resource, "If Resource options are not specified, the TemperatureControlledResources and ResourcePlacements fields will be populated with the input objects instead:"},
			protocol = ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			Download[protocol, {TemperatureControlledResources, ResourcePlacements}],
			{
				{
					ObjectP[Model[Container, Vessel, "50mL Tube"]],
					ObjectP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					{ObjectP[Model[Container, Vessel, "50mL Tube"]], ObjectP[Model[Instrument, PortableCooler]]},
					{ObjectP[Model[Container, Vessel, "50mL Tube"]], ObjectP[Model[Instrument, PortableCooler]]}
				}
			},
			Variables :> {protocol}
		],
		Example[{Messages, "NoParentProtocol", "This function is only meant to be called as subprotocol, thus ParentProtocol -> Null is not acceptable:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Null
			],
			$Failed,
			Messages :> {Error::NoParentProtocol}
		],
		Example[{Messages, "OversizedItem", "If IgnoreOversizedItems -> False, and if there are items that can't physically fit to any available transporters, function will output $Failed:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "20L Polypropylene Carboy"], Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				IgnoreOversizedItems -> False
			],
			$Failed,
			Messages :> {Error::OversizedItem, Error::InvalidOption, Error::InvalidInput, Error::InsufficientTransporterDimensions}
		],
		Example[{Messages, "UnsupportedTemperature", "When TransportTemperature is set or resolved to a value that no transporter supports, function will output $Failed and throw message:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "2mL Tube"]},
				TransportTemperature -> 35 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UnsupportedTemperature, Error::InvalidOption}
		],
		Example[{Messages, "NoTransportTemperature", "TransportTemperature must be specified for Model[Container] type of input, otherwise an error will be thrown:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> Automatic,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::NoTransportTemperature, Error::InvalidOption, Error::UnsupportedTemperature}
		],
		Example[{Messages, "InsufficientTransporterSpace", "If items cannot fit in a specified Transporter object because too many other items are already there, an error will be thrown:"},
			protocol1 = ExperimentPrepareTransporter[
				Model[Container, Vessel, "id:aXRlGnZmOONB"],
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			protocol2 = ExperimentPrepareTransporter[
				Table[Model[Container, Vessel, "id:aXRlGnZmOONB"], 10],
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID]
			];
			{protocol1, protocol2},
			{ObjectP[], $Failed},
			Messages :> {Error::InsufficientTransporterSpace, Error::InvalidOption},
			Variables :> {protocol1, protocol2}
		],
		Example[{Messages, "InsufficientTransporterDimensions", "If item cannot fit in a specified Transporter Object or Model because its Dimensions exceeds the InternalDimensions of the transporter, an error will be thrown:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "20L Polypropylene Carboy"]},
				TransportTemperature -> 4 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				IgnoreOversizedItems -> False
			],
			$Failed,
			Messages :> {Error::InsufficientTransporterDimensions, Error::InvalidOption}
		],
		Example[{Messages, "InconsistentTemperatureSetting", "If the current NominalTemperature of the specified Transporter object does not match the TransportTemperature option, an error will be thrown:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> -20 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::InconsistentTemperatureSetting, Error::InvalidOption}
		],
		Example[{Messages, "IncorrectTemperatureRange", "If the allowed temperature range of the specified Transporter does not match the TransportTemperature option, an error will be thrown:"},
			ExperimentPrepareTransporter[
				{Model[Container, Vessel, "50mL Tube"]},
				TransportTemperature -> -80 Celsius,
				ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Transporter -> Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"]
			],
			$Failed,
			Messages :> {Error::IncorrectTemperatureRange, Error::InvalidOption}
		],
		Test["When a mix of multiple duplicated objects are supplied as input, the function's internal remove and restore duplicate feature works well:",

			(* This test may be a bit hard to understand, but the essence is we supply specific transporter model as Transporter option, and we want to make sure after option resolver it doesn't change *)
			(* The option resolver does some complicated handling to remove then restore duplicate object inputs so we want to make sure it works as expected *)
			randomContainerLists = RandomSample[
				Flatten[{
					ConstantArray[Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID], 9],
					ConstantArray[Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID], 3],
					ConstantArray[Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentPrepareTransporter" <> $SessionUUID], 2],
					ConstantArray[Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID], 6]
				}],
				20
			];
			containerToTransporterRule = {
				Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID] -> Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"],
				Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID] -> Model[Instrument, PortableCooler, "id:4pO6dM5MoKdo"],
				Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentPrepareTransporter" <> $SessionUUID] -> Model[Instrument, PortableCooler, "id:eGakldJdO9le"],
				Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID] -> Model[Instrument, PortableCooler, "id:jLq9jXqEreBq"]
			};
			transporter = randomContainerLists /. containerToTransporterRule;
			Lookup[
				ExperimentPrepareTransporter[
					randomContainerLists,
					TransportTemperature -> 4 Celsius,
					Transporter -> transporter,
					ParentProtocol -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					Output -> Options
				],
				Transporter
			],
			transporter,
			Variables :> {transporter, randomContainerLists, containerToTransporterRule}
		]
	},
	Stubs :> { $Site = Object[Container, Site, "id:kEJ9mqJxOl63"] (* Use ECL-2 for test *) },
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Model[Item, Column, "Test column model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Bench, "Test bench for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Consumable, "Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Consumable, "Test item 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Column, "Test column 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 20L Carboy 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Instrument, PortableCooler, "Test portable cooler 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 3 for ExperimentPrepareTransporter" <> $SessionUUID],
				Model[Sample, "Test sample model for ExperimentPrepareTransporter" <> $SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True];

			Upload[{
				Association[
					Type -> Model[Item, Consumable],
					Name -> "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					TransportTemperature -> 4 Celsius,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Dimensions -> {0.1 Meter, 0.2 Meter, 0.2 Meter}
				],
				Association[
					Type -> Model[Item, Column],
					Name -> "Test column model 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					TransportTemperature -> 4 Celsius,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Dimensions -> {0.05 Meter, 0.05 Meter, 0.25 Meter}
				],
				Association[
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentPrepareTransporter" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[Object[Container, Site, "id:kEJ9mqJxOl63"]]
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					Status -> Processing,
					OperationStatus -> OperatorProcessing,
					Site -> Link[Object[Container, Site, "id:kEJ9mqJxOl63"]]
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					Status -> Processing,
					OperationStatus -> OperatorProcessing,
					Site -> Link[Object[Container, Site, "id:kEJ9mqJxOl63"]]
				],
				Association[
					Type -> Model[Sample],
					Name -> "Test sample model for ExperimentPrepareTransporter" <> $SessionUUID,
					TransportTemperature -> 80 Celsius,
					State -> Liquid,
					DeveloperObject -> True,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				]
			}];

			UploadSample[
				{
					Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Item, Column, "Test column model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "20L Polypropylene Carboy"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				Table[{"Bench Top Slot", Object[Container, Bench, "Test bench for ExperimentPrepareTransporter" <> $SessionUUID]}, 8],
				Name -> {
					"Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test item 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test column 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test 50mL Tube 3 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test 20L Carboy 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID
				}
			];

			UploadSample[
				{
					Model[Sample, "Test sample model for ExperimentPrepareTransporter" <> $SessionUUID],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID]},
					{"A1", Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
					{"A2", Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID]},
					{"A3", Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID]}
				},
				Name -> {
					"Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test sample 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test plate sample 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					"Test plate sample 3 for ExperimentPrepareTransporter" <> $SessionUUID
				}
			];

			Upload[{
				Association[
					Type -> Object[Resource, Sample],
					Name -> "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID
				],
				Association[
					Type -> Object[Resource, Sample],
					Name -> "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID
				],
				Association[
					Type -> Object[Instrument, PortableCooler],
					Model -> Link[Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"], Objects],
					Name -> "Test portable cooler 1 for ExperimentPrepareTransporter" <> $SessionUUID,
					Site -> Link[Object[Container, Site, "id:kEJ9mqJxOl63"]],
					NominalTemperature -> 4 Celsius
				],
				Association[
					Type -> Object[Instrument, PortableCooler],
					Model -> Link[Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"], Objects],
					Name -> "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID,
					Site -> Link[Object[Container, Site, "id:kEJ9mqJxOl63"]],
					NominalTemperature -> 4 Celsius
				],
				Association[
					Object -> Object[Sample, "Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
					TransportTemperature -> 4 Celsius
				],
				Association[
					Object -> Object[Sample, "Test plate sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					TransportTemperature -> 4 Celsius
				],
				Association[
					Object -> Object[Sample, "Test plate sample 3 for ExperimentPrepareTransporter" <> $SessionUUID],
					TransportTemperature -> 4 Celsius
				],
				Association[
					Object -> Object[Sample, "Test sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					TransportTemperature -> 4 Celsius
				],
				Association[
					Object -> Object[Item, Consumable, "Test item 2 for ExperimentPrepareTransporter" <> $SessionUUID],
					TransportTemperature -> -10 Celsius
				]
			}];

			UploadInstrumentStatus[Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID], Running, UpdatedBy -> Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID]];

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Model[Item, Consumable, "Test item model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Model[Item, Column, "Test column model 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Bench, "Test bench for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Protocol, HPLC, "Test protocol 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Protocol, HPLC, "Test protocol 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Consumable, "Test item 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Consumable, "Test item 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Item, Column, "Test column 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Vessel, "Test 20L Carboy 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Instrument, PortableCooler, "Test portable cooler 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Instrument, PortableCooler, "Test portable cooler 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Resource, Sample, "Test resource object 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Resource, Sample, "Test resource object 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Container, Plate, "Test DWP 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 1 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 2 for ExperimentPrepareTransporter" <> $SessionUUID],
				Object[Sample, "Test plate sample 3 for ExperimentPrepareTransporter" <> $SessionUUID],
				Model[Sample, "Test sample model for ExperimentPrepareTransporter" <> $SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True];
		]
	}
]