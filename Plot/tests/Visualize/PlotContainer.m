(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotContainer*)


DefineTests[PlotContainer,
	{
		Example[{Basic, "Plot a container model:"},
			PlotContainer[Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID]],
			_Graphics
		],
		Example[{Basic, "Plot a container with a volume of liquid:"},
			PlotContainer[Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID], 0.6 Milliliter],
			_Graphics
		],
		Example[{Basic, "Plot a container object:"},
			PlotContainer[Object[Container, Vessel, "test container object for PlotContainer unit test "<>$SessionUUID], 1.05 Milliliter],
			_Graphics
		],
		Example[{Options, FieldOfView, "Plot a container with a volume of liquid focusing on the meniscus:"},
			PlotContainer[Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID], 0.6 Milliliter, FieldOfView -> MeniscusPoint],
			_Graphics
		],

		Test["Plot the full view if the container does not have labeled ticks even though the FieldOfView is set to MeniscusPoint:",
			PlotContainer[Model[Container, Vessel, "test container model 2 for PlotContainer unit test "<>$SessionUUID], 7 Milliliter, FieldOfView -> MeniscusPoint],
			_Graphics
		],

		(* ----- Messages tests ----- *)
		Example[{Messages, "VolumeOutsidePlottableRange", "If the volume is unable to be plotted (i.e. beyond the capacity of the container) an error messaged is surfaced and $Failed is returned:"},
			PlotContainer[Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID], 300 Milliliter],
			$Failed,
			Messages :> {Error::VolumeOutsidePlottableRange}
		],
		Example[{Messages, "VolumeOutsideOfGraduations", "If the specified volume would be difficult to measure a warning is surfaced:"},
			PlotContainer[Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID], 0.1 Milliliter],
			_Graphics,
			Messages :> {Warning::VolumeOutsideOfGraduations}
		],
		Example[{Messages, "UnableToPlotGraduatedCylinderModel", "If the input is invalid an error message is surfaced and $Failed is returned:"},
			PlotContainer[Model[Container, Vessel, "test container model 3 for PlotContainer unit test "<>$SessionUUID]],
			$Failed,
			Messages :> {Error::UnableToPlotContainerModel}
		]
	},
	SymbolSetUp :> (
		Module[{objects},
			objects = {
				Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID],
				Model[Container, Vessel, "test container model 2 for PlotContainer unit test "<>$SessionUUID],
				Model[Container, Vessel, "test container model 3 for PlotContainer unit test "<>$SessionUUID],
				Object[Container, Vessel, "test container object for PlotContainer unit test "<>$SessionUUID]
			};

			EraseObject[
				PickList[objects, DatabaseMemberQ[objects], True],
				Verbose -> False,
				Force -> True
			]
		];
		Block[{$DeveloperUpload = True},
			Module[{vesselModel1, vesselModel2, vesselModel3, vessel1},
				{
					vesselModel1,
					vesselModel2,
					vesselModel3,
					vessel1
				} = CreateID[{
					Model[Container, Vessel],
					Model[Container, Vessel],
					Model[Container, Vessel],
					Object[Container, Vessel]
				}];
				Upload[{
					<|
						Object -> vesselModel1,
						CrossSectionalShape -> Circle,
						Dimensions -> {Quantity[0.01289, "Meters"], Quantity[0.01289, "Meters"], Quantity[0.04561, "Meters"]},
						Replace[GraduationLabels] -> {Null, Null, Null, "0.5", Null, Null, Null, Null, "1.0", Null, Null, Null, Null, "1.5"},
						Replace[Graduations] -> {Quantity[0.2, "Milliliters"], Quantity[0.3, "Milliliters"], Quantity[0.4, "Milliliters"], Quantity[0.5, "Milliliters"], Quantity[0.6, "Milliliters"], Quantity[0.7, "Milliliters"], Quantity[0.8, "Milliliters"], Quantity[0.9, "Milliliters"], Quantity[1., "Milliliters"], Quantity[1.1, "Milliliters"], Quantity[1.2, "Milliliters"], Quantity[1.3, "Milliliters"], Quantity[1.4, "Milliliters"], Quantity[1.5, "Milliliters"]},
						Replace[GraduationTypes] -> {Short, Short, Short, Labeled, Short, Short, Short, Short, Labeled, Short, Short, Short, Short, Labeled},
						Name -> "test container model 1 for PlotContainer unit test "<>$SessionUUID
					|>,
					<|
						Object -> vesselModel2,
						CrossSectionalShape -> Circle,
						Dimensions -> {Quantity[0.02877, "Meters"], Quantity[0.02877, "Meters"], Quantity[0.11468, "Meters"]},
						Replace[Graduations] -> {Quantity[5., "Milliliters"], Quantity[7.5, "Milliliters"], Quantity[10., "Milliliters"], Quantity[12.5, "Milliliters"], Quantity[15., "Milliliters"], Quantity[17.5, "Milliliters"], Quantity[20., "Milliliters"], Quantity[22.5, "Milliliters"], Quantity[25., "Milliliters"], Quantity[27.5, "Milliliters"], Quantity[30., "Milliliters"], Quantity[32.5, "Milliliters"], Quantity[35., "Milliliters"], Quantity[37.5, "Milliliters"], Quantity[40., "Milliliters"], Quantity[42.5, "Milliliters"], Quantity[45., "Milliliters"], Quantity[47.5, "Milliliters"], Quantity[50., "Milliliters"]},
						Replace[GraduationTypes] -> {Long, Short, Long, Short, Long, Short, Long, Short, Long, Short, Long, Short, Long, Short, Long, Short, Long, Short, Long},
						Replace[GraduationLabels] -> {Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null},
						Name -> "test container model 2 for PlotContainer unit test "<>$SessionUUID
					|>,
					<|
						Object -> vesselModel3,
						Name -> "test container model 3 for PlotContainer unit test "<>$SessionUUID
					|>,
					<|
						Object -> vessel1,
						Name -> "test container object for PlotContainer unit test "<>$SessionUUID,
						Model -> Link[vesselModel1, Objects]
					|>
				}]
			]
		]
	),
	SymbolTearDown :> (
		Module[{objects},
			objects = {
				Model[Container, Vessel, "test container model 1 for PlotContainer unit test "<>$SessionUUID],
				Model[Container, Vessel, "test container model 2 for PlotContainer unit test "<>$SessionUUID],
				Model[Container, Vessel, "test container model 3 for PlotContainer unit test "<>$SessionUUID],
				Object[Container, Vessel, "test container object for PlotContainer unit test "<>$SessionUUID]
			};

			EraseObject[
				PickList[objects, DatabaseMemberQ[objects], True],
				Verbose -> False,
				Force -> True
			]
		]
	)
];
