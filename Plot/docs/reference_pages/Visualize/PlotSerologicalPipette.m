(* ::Section:: *)
(*PlotSerologicalPipette*)

DefineUsage[PlotSerologicalPipette,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotSerologicalPipette[SerologicalPipette]", "Graphic"},
        Description -> "plots 'Graphic' according to the input 'SerologicalPipette'.",
        Inputs :> {
          {
            InputName -> "SerologicalPipette",
            Description -> "A serological pipette tip object.",
            Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Tips], Object[Item, Tips]}]]
          }
        },
        Outputs :> {
          {
            OutputName -> "Graphic",
            Description -> "A visual representation of the serological pipette.",
            Pattern :> ValidGraphicsP[]
          }
        }
      },
      {
        Definition -> {"PlotSerologicalPipette[SerologicalPipette, Volume]", "Graphic"},
        Description -> "plots 'Graphic' according to the input 'SerologicalPipette' filled to 'Volume'.",
        Inputs :> {
          {
            InputName -> "SerologicalPipette",
            Description ->  "A serological pipette tip object.",
            Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Tips], Object[Item, Tips]}]]
          },
          {
            InputName -> "Volume",
            Description -> "The amount of liquid to display in the serological pipette.",
            Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milliliter], Units -> Alternatives[Milliliter, Liter]]
          }
        },
        Outputs :> {
          {
            OutputName -> "Graphic",
            Description -> "A visual representation of the serological pipette.",
            Pattern :> ValidGraphicsP[]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentTransfer",
      "PlotObject",
      "PlotGraduatedCylinder"
    },
    Author -> {"ryan.bisbey"}
  }
];