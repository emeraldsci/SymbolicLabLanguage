(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


(* ::Subsection::Closed:: *)
(*PlotFreezeCells*)


DefineTests[PlotFreezeCells,
	{
		Example[{Basic, "Plot the results of a cell freezing experiment using a protocol object as input:"},
			PlotFreezeCells[Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol with Data for PlotFreezeCells tests " <> $SessionUUID]],
			_TabView|_Legended
		],
		Example[{Basic, "Plot the results of cell freezing experiment using a data object as input:"},
			PlotFreezeCells[Object[Data, Temperature, "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID]],
			_Legended
		],
		Example[{Basic, "When the results of multiple cell freezing experiments are plotted, they appear in tab format:"},
			PlotFreezeCells[
				{
					Object[Data, Temperature, "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID],
					Object[Data, Temperature, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID]
				}
			],
			TabView[{_String -> _Legended, _String -> _Legended}]
		],
		Example[{Basic, "Plot the results of a cell freezing experiment from a FreezeCells protocol which used the InsulatedCooler strategy:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID]
			],
			_TabView|_Legended
		],
		Test["Given a packet to PlotFreezeCells as input:",
			PlotFreezeCells[
				Download[Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID]]
			],
			_TabView|_Legended
		],
		Example[{Options, TimeDisplayStyle, "Plot the results of a cell freezing experiment using a protocol object as input with related time series:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol with Data for PlotFreezeCells tests " <> $SessionUUID],
				TimeDisplayStyle -> Relative
			],
			_TabView|_Legended
		],
		Example[{Options, ImageSize, "Adjust the size of the image:"},
			PlotFreezeCells[
				{
					Object[Data, Temperature, "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID],
					Object[Data, Temperature, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID]
				},
				ImageSize -> 200
			],
			TabView[{_String -> _Legended, _String -> _Legended}]
		],
		Example[{Options, Output, "Setting Output to Options returns the resolved options:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Output -> Options
			],
			_List
		],
		Example[{Messages, "PlotFreezeCellsObjectNotFound", "An error will be shown if the specified input protocol cannot be found in the database:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "Not In Database For Sure"]
			],
			$Failed,
			Messages :> Error::PlotFreezeCellsObjectNotFound
		],
		Example[{Messages, "PlotFreezeCellsObjectNotFound", "An error will be shown if the specified input data cannot be found in the database:"},
			PlotFreezeCells[
				Object[Data, Temperature, "Not In Database For Sure"]
			],
			$Failed,
			Messages :> Error::PlotFreezeCellsObjectNotFound
		],
		Example[{Messages, "PlotFreezeCellsNoAssociatedDataObject", "An error will be shown if the input protocol object has no associated data object:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> Error::PlotFreezeCellsNoAssociatedDataObject
		],
		Example[{Messages, "PlotFreezeCellsIncompatibleData", "An error will be shown if the associated temperature data is missing required fields:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "Incomplete InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> Error::PlotFreezeCellsIncompatibleData
		]
	},
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, controlledRateFreezer, staticFreezer, insulatedCoolerProtocol, controlledRateProtocolNoData,
				insulatedCoolerData, controlledRateData, incompeleteData, controlledRateDataProtocol, protocolWithIncompleteData
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Freezer Instruments *)
				Object[Instrument, ControlledRateFreezer, "Controlled Rate Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				Object[Instrument, Freezer, "Static Temperature Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				(* Protocols *)
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol with Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "Incomplete InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, Temperature, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, Temperature, "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, Temperature, "Incomplete InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[objects, existsFilter],
				Force -> True,
				Verbose -> False
			];

			(* Upload some freezer instruments. *)
			{staticFreezer, controlledRateFreezer} = Upload[{
				<|
					Type -> Object[Instrument, Freezer],
					Model -> Link[Model[Instrument, Freezer, "Stirling UltraCold SU780UE"], Objects],
					Name -> "Static Temperature Freezer instrument for PlotFreezeCells tests " <> $SessionUUID,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Instrument, ControlledRateFreezer],
					Model -> Link[Model[Instrument, ControlledRateFreezer, "VIA Freeze Research"], Objects],
					Name -> "Controlled Rate Freezer instrument for PlotFreezeCells tests " <> $SessionUUID,
					Site -> Link[$Site]
				|>
			}];

			(* Upload temporary test protocols and data objects. *)
			{insulatedCoolerData, controlledRateData, incompeleteData} = Upload[{
				<|
					Type -> Object[Data, Temperature],
					Name -> "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID,
					Replace[TemperatureLog] -> Download[Object[Data, Temperature, "id:N80DNjvxMKmX"], TemperatureLog],
					Sensor -> Link[Object[Sensor, Temperature, "id:BYDOjvDzA9eD"], Data],
					FirstDataPoint -> Download[Object[Data, Temperature, "id:N80DNjvxMKmX"], FirstDataPoint],
					LastDataPoint -> Download[Object[Data, Temperature, "id:N80DNjvxMKmX"], LastDataPoint]
				|>,
				<|
					Type -> Object[Data, Temperature],
					Name -> "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID,
					Replace[TemperatureLog] -> Download[Object[Data, Temperature, "id:n0k9mGOVwk56"], TemperatureLog],
					Sensor -> Link[Object[Sensor, Temperature, "id:n0k9mG893ldw"], Data],
					FirstDataPoint -> Download[Object[Data, Temperature, "id:n0k9mGOVwk56"], FirstDataPoint],
					LastDataPoint -> Download[Object[Data, Temperature, "id:n0k9mGOVwk56"], LastDataPoint]
				|>,
				<|
					Type -> Object[Data, Temperature],
					Name -> "Incomplete InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID,
					Sensor -> Link[Object[Sensor, Temperature, "id:BYDOjvDzA9eD"], Data],
					FirstDataPoint -> Download[Object[Data, Temperature, "id:N80DNjvxMKmX"], FirstDataPoint]
				|>
			}];
			(* NOTE: Object[Protocol, FreezeCells, "ControlledRateFreezer Test Protocol"] and Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"] are permanent *)
			(*  test objects. We use these in the tests and also use their data for temporary test objects so that we don't need to have multiple permanent data objects. *)
			{insulatedCoolerProtocol, controlledRateDataProtocol, protocolWithIncompleteData, controlledRateProtocolNoData} = Upload[{
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[staticFreezer],
					Replace[Data] -> {Link[insulatedCoolerData, Protocol]},
					Replace[FreezerEnvironmentalData] -> {Link[insulatedCoolerData]},
					InsulatedCoolerFreezingTime -> 720 Minute,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "ControlledRateFreezer Protocol with Data for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[controlledRateFreezer],
					Replace[Data] -> {Link[controlledRateData, Protocol]},
					Replace[FreezerEnvironmentalData] -> {Link[controlledRateData]},
					Replace[TemperatureProfile] -> {
						{-10 Celsius, 35 Minute},
						{-10 Celsius, 45 Minute},
						{-45 Celsius, 75 Minute},
						{-45 Celsius, 80 Minute},
						{-80 Celsius, 115 Minute}
					},
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "Incomplete InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[staticFreezer],
					Replace[Data] -> {Link[incompeleteData, Protocol]},
					Replace[FreezerEnvironmentalData] -> {Link[incompeleteData]},
					InsulatedCoolerFreezingTime -> 720 Minute,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[controlledRateFreezer],
					Replace[TemperatureProfile] -> {
						{-10 Celsius, 35 Minute},
						{-10 Celsius, 45 Minute},
						{-45 Celsius, 75 Minute},
						{-45 Celsius, 80 Minute},
						{-80 Celsius, 115 Minute}
					},
					Site -> Link[$Site]
				|>
			}];

		]
	],

	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Freezer Instruments *)
				Object[Instrument, ControlledRateFreezer, "Controlled Rate Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				Object[Instrument, Freezer, "Static Temperature Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				(* Protocols *)
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol with Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "Incomplete InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, Temperature, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, Temperature, "ControlledRateFreezer Data with Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, Temperature, "Incomplete InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID]
			},
				ObjectP[]
			];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	),

	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}

];