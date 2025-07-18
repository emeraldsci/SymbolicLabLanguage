(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGraduatedCylinder*)


DefineTests[PlotGraduatedCylinder,
  {
    Example[{Basic, "Plot a graduated cylinder model:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "id:qdkmxz0A88Va"]],
      _Graphics
    ],
    Example[{Basic, "Plot a graduated cylinder with a volume of liquid:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "id:KBL5DvYl33nd"], 30 Milliliter],
      _Graphics
    ],
    Example[{Basic, "Plot a graduated cylinder object:"},
      PlotGraduatedCylinder[Object[Container, GraduatedCylinder, "Example graduated cylinder for PlotGraduatedCylinder tests " <> $SessionUUID], 10 Milliliter],
      _Graphics
    ],
    Example[{Options, FieldOfView, "Plot a graduated cylinder with a volume of liquid focusing on the meniscus:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "id:KBL5DvYl33nd"], 30 Milliliter, FieldOfView -> MeniscusPoint],
      _Graphics
    ],

    (* ----- Messages tests ----- *)
    Example[{Messages, "Error::VolumeOutsidePlottableRange", "If the volume is unable to be plotted (i.e. beyond the capacity of the graduated cylinder) an error messaged is surfaced and $Failed is returned:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "id:D8KAEvdqzzkm"], 300 Milliliter],
      $Failed,
      Messages :> {Error::VolumeOutsidePlottableRange}
    ],
    Example[{Messages, "Warning::VolumeOutsideOfGraduations", "If the specified volume would be difficult to measure a warning is surfaced:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "id:P5ZnEjZ9MGdO"], 2 Milliliter],
      _Graphics,
      Messages :> {Warning::VolumeOutsideOfGraduations}
    ],
    Example[{Messages, "Error::UnableToPlotGraduatedCylinderModel", "If the input is invalid an error message is surfaced and $Failed is returned:"},
      PlotGraduatedCylinder[Model[Container, GraduatedCylinder, "New graduated cylinder model for PlotGraduatedCylinder tests " <> $SessionUUID]],
      $Failed,
      Messages :> {Error::UnableToPlotGraduatedCylinderModel}
    ]
  },
  SymbolSetUp :> (
    Module[{objects},
      objects = {
        Model[Container, GraduatedCylinder, "New graduated cylinder model for PlotGraduatedCylinder tests " <> $SessionUUID],
        Object[Container, GraduatedCylinder, "Example graduated cylinder for PlotGraduatedCylinder tests " <> $SessionUUID]
      };

      EraseObject[
        PickList[objects,DatabaseMemberQ[objects],True],
        Verbose->False,
        Force->True
      ]
    ];
    Upload[{
      <|
        Type-> Model[Container, GraduatedCylinder],
        Name -> "New graduated cylinder model for PlotGraduatedCylinder tests " <> $SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type-> Object[Container, GraduatedCylinder],
        Name -> "Example graduated cylinder for PlotGraduatedCylinder tests " <> $SessionUUID,
        Model -> Link[Model[Container, GraduatedCylinder, "id:qdkmxz0A88Va"], Objects],
        DeveloperObject -> True
      |>
    }]
  ),
  SymbolTearDown :> (
    Module[{objects},
      objects = {
        Model[Container, GraduatedCylinder, "New graduated cylinder model for PlotGraduatedCylinder tests " <> $SessionUUID],
        Object[Container, GraduatedCylinder, "Example graduated cylinder for PlotGraduatedCylinder tests " <> $SessionUUID]
      };

      EraseObject[
        PickList[objects,DatabaseMemberQ[objects],True],
        Verbose->False,
        Force->True
      ]
    ]
  )
];
