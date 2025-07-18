(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


(* ::Subsection::Closed:: *)
(*PlotFreezeCells*)


DefineTests[PlotFreezeCells,
	{
		Example[
			{Basic, "Plot the results of a cell freezing experiment using a protocol object as input:"},
			PlotFreezeCells[Object[Protocol, FreezeCells, "ControlledRateFreezer Test Protocol"]],
			_Legended
		],
		
		Example[
			{Basic,"Plot the results of cell freezing experiment using a data object as input:"},
			PlotFreezeCells[Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"]],
			_Legended
		],

		Example[
			{Basic, "When the results of multiple cell freezing experiments are plotted, they appear in tab format:"},
			PlotFreezeCells[
				{
					Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"],
					Object[Protocol, FreezeCells, "ControlledRateFreezer Test Protocol"]
				}
			],
			TabView[{_String -> _Legended, _String -> _Legended}]
		],
		
		Example[
			{Messages,"PlotFreezeCellsObjectNotFound","An error will be shown if the specified input protocol cannot be found in the database:"},
			PlotFreezeCells[
				Object[Protocol,FreezeCells,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsObjectNotFound
		],
		
		Example[
			{Messages,"PlotFreezeCellsObjectNotFound","An error will be shown if the specified input data cannot be found in the database:"},
			PlotFreezeCells[
				Object[Data,FreezeCells,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsObjectNotFound
		],
		
		Example[
			{Messages,"PlotFreezeCellsNoAssociatedDataObject","An error will be shown if the input protocol object has no associated data object:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsNoAssociatedDataObject
		],

		Example[
			{Messages,"PlotFreezeCellsIncompatibleFreezingStrategy","An error will be shown if the input protocol object is from a FreezeCells protocol which used the InsulatedCooler strategy:"},
			PlotFreezeCells[
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsIncompatibleFreezingStrategy
		]

	},

	SetUp :> (
		$CreatedObjects = {}
	),

	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),

	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, controlledRateFreezer, staticFreezer, insulatedCoolerProtocol, controlledRateProtocolNoData, insulatedCoolerData, controlledRateDataNoProtocol
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Freezer Instruments *)
				Object[Instrument, ControlledRateFreezer, "Controlled Rate Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				Object[Instrument, Freezer, "Static Temperature Freezer instrument for PlotFreezeCells tests " <> $SessionUUID],
				(* Protocols *)
				Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID],
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, FreezeCells, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, FreezeCells, "ControlledRateFreezer Data without Protocol for PlotFreezeCells tests " <> $SessionUUID]
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
			(* NOTE: Object[Protocol, FreezeCells, "ControlledRateFreezer Test Protocol"] and Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"] are permanent *)
			(*  test objects. We use these in the tests and also use their data for temporary test objects so that we don't need to have multiple permanent data objects. *)
			{insulatedCoolerProtocol, controlledRateProtocolNoData} = Upload[{
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[staticFreezer],
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Protocol, FreezeCells],
					Name -> "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID,
					Replace[Freezers] -> Link[controlledRateFreezer],
					Site -> Link[$Site]
				|>
			}];

			{insulatedCoolerData, controlledRateDataNoProtocol} = Upload[{
				<|
					Type -> Object[Data, FreezeCells],
					Name -> "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID,
					Protocol -> Link[Object[Protocol, FreezeCells, "InsulatedCooler Protocol for PlotFreezeCells tests " <> $SessionUUID], Data]
				|>,
				<|
					Type -> Object[Data, FreezeCells],
					Name -> "ControlledRateFreezer Data without Protocol for PlotFreezeCells tests " <> $SessionUUID,
					(* Borrow the data fields from the permanent data object instead of keeping hundreds of data points in this file. *)
					ExpectedTemperatureData -> Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"][ExpectedTemperatureData],
					MeasuredTemperatureData -> Object[Data, FreezeCells, "ControlledRateFreezer Test Protocol"][MeasuredTemperatureData]
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
				Object[Protocol, FreezeCells, "ControlledRateFreezer Protocol without Data for PlotFreezeCells tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, FreezeCells, "InsulatedCooler Data for PlotFreezeCells tests " <> $SessionUUID],
				Object[Data, FreezeCells, "ControlledRateFreezer Data without Protocol for PlotFreezeCells tests " <> $SessionUUID]
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