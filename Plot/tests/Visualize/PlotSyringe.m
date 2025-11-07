(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSyringe*)

DefineTests[PlotSyringe,
	{
		Example[{Basic, "Plot a syringe model:"},
			ValidGraphicsQ[PlotSyringe[Model[Container, Syringe, "id:P5ZnEj4P88OL"]]],
			True
		],
		Example[{Basic, "Plot a syringe with a volume of liquid:"},
			ValidGraphicsQ[PlotSyringe[Model[Container, Syringe, "id:P5ZnEj4P88OL"], 15 Milliliter]],
			True
		],
		Example[{Basic, "Plot a syringe object:"},
			ValidGraphicsQ[PlotSyringe[Object[Container, Syringe, "Example syringe for PlotSyringe tests " <> $SessionUUID], 15 Milliliter]],
			True
		],
		Example[{Options, FieldOfView, "Plot a graduated cylinder with a volume of liquid focusing on the meniscus:"},
			ValidGraphicsQ[PlotSyringe[Model[Container, Syringe, "id:P5ZnEj4P88OL"], 15 Milliliter, FieldOfView -> MeniscusPoint]],
			True
		],

		(* messages tests *)

		Example[{Messages, "Error::VolumeOutsidePlottableRange", "If the volume is unable to be plotted (i.e. beyond the capacity of the graduated cylinder) an error messaged is surfaced and $Failed is returned:"},
			PlotSyringe[Model[Container, Syringe, "id:P5ZnEj4P88OL"], 300 Milliliter],
			$Failed,
			Messages :> {Error::VolumeOutsidePlottableRange}
		],
		Example[{Messages, "Warning::VolumeOutsideOfGraduations", "If the specified volume would be difficult to measure a warning is surfaced:"},
			ValidGraphicsQ[PlotSyringe[Model[Container, Syringe, "id:P5ZnEj4P88OL"], 24.5 Milliliter]],
			True,
			Messages :> {Warning::VolumeOutsideOfGraduations}
		],
		Example[{Messages, "Error::UnableToPlotSyringeModelTypesFilled", "If the input is invalid an error message is surfaced and $Failed is returned:"},
			PlotSyringe[Model[Container, Syringe, "New syringe model 1 for PlotSyringe tests " <> $SessionUUID]],
			$Failed,
			Messages :> {Error::UnableToPlotSyringeModelTypesFilled}
		],
		Example[{Messages, "Error::UnableToPlotSyringeModelMismatchedLengths", "If the input is invalid an error message is surfaced and $Failed is returned:"},
			PlotSyringe[Model[Container, Syringe, "New syringe model 2 for PlotSyringe tests " <> $SessionUUID]],
			$Failed,
			Messages :> {Error::UnableToPlotSyringeModelMismatchedLengths}
		]
	},
	SymbolSetUp :> (
		Module[{objects},
			objects = {
				Object[Container, Syringe, "Example syringe for PlotSyringe tests " <> $SessionUUID],
				Model[Container, Syringe, "New syringe model 1 for PlotSyringe tests " <> $SessionUUID],
				Model[Container, Syringe, "New syringe model 2 for PlotSyringe tests " <> $SessionUUID]
			};

			EraseObject[
				PickList[objects,DatabaseMemberQ[objects],True],
				Verbose->False,
				Force->True
			]
		];
		Upload[{
			<|
				Type-> Object[Container, Syringe],
				Name -> "Example syringe for PlotSyringe tests " <> $SessionUUID,
				Model -> Link[Model[Container, Syringe, "id:P5ZnEj4P88OL"], Objects], (* Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"] *)
				DeveloperObject -> True
			|>,
			<|
				Type-> Model[Container, Syringe],
				Name -> "New syringe model 1 for PlotSyringe tests " <> $SessionUUID,
				DeveloperObject -> True,
				Replace[Graduations] -> {0 Milliliter, 2 Milliliter, 4 Milliliter, 6 Milliliter},
				Replace[GraduationTypes] -> {Long, Short, Short, Labeled},
				Replace[GraduationLabels] -> {}
			|>,
			<|
				Type-> Model[Container, Syringe],
				Name -> "New syringe model 2 for PlotSyringe tests " <> $SessionUUID,
				DeveloperObject -> True,
				Replace[Graduations] -> {0 Milliliter, 2 Milliliter, 4 Milliliter, 6 Milliliter},
				Replace[GraduationTypes] -> {Long, Short, Short, Labeled},
				Replace[GraduationLabels] -> {Null, Null, "4"}
			|>
		}]
	),
	SymbolTearDown :> (
		Module[{objects},
			objects = {
				Object[Container, Syringe, "Example syringe for PlotSyringe tests " <> $SessionUUID],
				Model[Container, Syringe, "New syringe model 1 for PlotSyringe tests " <> $SessionUUID],
				Model[Container, Syringe, "New syringe model 2 for PlotSyringe tests " <> $SessionUUID]
			};

			EraseObject[
				PickList[objects,DatabaseMemberQ[objects],True],
				Verbose->False,
				Force->True
			]
		]
	)
];