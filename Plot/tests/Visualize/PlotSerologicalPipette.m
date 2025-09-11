(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSerologicalPipette*)

DefineTests[PlotSerologicalPipette,
  {
    Example[{Basic, "Plot a serological pipette model:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:R8e1PjRDbO7d"]],
      _Graphics
    ],
    Example[{Basic, "Plot a serological pipette with a volume of liquid:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:pZx9jonGJmkp"], 4 Milliliter],
      _Graphics
    ],
    Example[{Basic, "Plot a serological pipette object:"},
      PlotSerologicalPipette[Object[Item, Tips, "Example serological pipette for PlotSerologicalPipette tests " <> $SessionUUID], 8 Milliliter],
      _Graphics
    ],
    Example[{Options, FieldOfView, "Plot a serological pipette with a volume of liquid focusing on the meniscus:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:kEJ9mqaVP6nV"], 14 Milliliter, FieldOfView -> MeniscusPoint],
      _Graphics
    ],

    (* ----- Messages tests ----- *)
    Example[{Messages, "Error::VolumeOutsidePlottableRange", "If the volume is unable to be plotted (i.e. beyond the capacity of the serological pipette) an error messaged is surfaced and $Failed is returned:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:zGj91aR3d6MJ"], 10 Milliliter],
      $Failed,
      Messages :> {Error::VolumeOutsidePlottableRange}
    ],
    Example[{Messages, "Warning::VolumeOutsideOfGraduations", "If the specified volume would be difficult to measure a warning is surfaced:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:aXRlGnZmOJdv"], 2 Milliliter],
      _Graphics,
      Messages :> {Warning::VolumeOutsideOfGraduations}
    ],
    Example[{Messages, "Error::UnableToPlotTipModel", "If the input is invalid an error message is surfaced and $Failed is returned:"},
      PlotSerologicalPipette[Model[Item, Tips, "New serological pipette model for PlotSerologicalPipette tests " <> $SessionUUID]],
      $Failed,
      Messages :> {Error::UnableToPlotTipModel}
    ],
    Example[{Messages, "Error::InvalidPipetteType", "If the input is not a sereological pipette, an error message is surfaced and $Failed is returned:"},
      PlotSerologicalPipette[Model[Item, Tips, "id:rea9jl1or6YL"]], (* PipetteType -> Micropipette for this object. *)
      $Failed,
      Messages :> {Error::InvalidPipetteType}
    ]
  },
  SymbolSetUp :> (
    Module[{objects},
      objects = {
        Model[Item, Tips, "New serological pipette model for PlotSerologicalPipette tests " <> $SessionUUID],
        Object[Item, Tips, "Example serological pipette for PlotSerologicalPipette tests " <> $SessionUUID]
      };

      EraseObject[
        PickList[objects,DatabaseMemberQ[objects],True],
        Verbose->False,
        Force->True
      ]
    ];
    Upload[{
      <|
        Type-> Model[Item, Tips],
        Name -> "New serological pipette model for PlotSerologicalPipette tests " <> $SessionUUID,
        PipetteType -> Serological,
        DeveloperObject -> True
      |>,
      <|
        Type-> Object[Item, Tips],
        Name -> "Example serological pipette for PlotSerologicalPipette tests " <> $SessionUUID,
        Model -> Link[Model[Item, Tips, "id:D8KAEvdqzb8b"], Objects],
        DeveloperObject -> True
      |>
    }]
  ),
  SymbolTearDown :> (
    Module[{objects},
      objects = {
        Model[Item, Tips, "New serological pipette model for PlotSerologicalPipette tests " <> $SessionUUID],
        Object[Item, Tips, "Example serological pipette for PlotSerologicalPipette tests " <> $SessionUUID]
      };

      EraseObject[
        PickList[objects,DatabaseMemberQ[objects],True],
        Verbose->False,
        Force->True
      ]
    ]
  )
];
