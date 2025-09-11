(* ::Section:: *)
(*PlotGraduatedCylinder*)

DefineUsage[PlotGraduatedCylinder,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotGraduatedCylinder[GraduatedCylinder]", "Graphic"},
        Description -> "plots 'Graphic' according to the input 'GraduatedCylinder'.",
        Inputs :> {
          {
            InputName -> "GraduatedCylinder",
            Description -> "A graduated cylinder object.",
            Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}]]
          }
        },
        Outputs :> {
          {
            OutputName -> "Graphic",
            Description -> "A visual representation of the graduated cylinder.",
            Pattern :> ValidGraphicsP[]
          }
        }
      },
      {
        Definition -> {"PlotGraduatedCylinder[GraduatedCylinder, Volume]", "Graphic"},
        Description -> "plots 'Graphic' according to the input 'GraduatedCylinder' filled to 'Volume'.",
        Inputs :> {
          {
            InputName -> "GraduatedCylinder",
            Description -> "A graduated cylinder object.",
            Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, GraduatedCylinder], Object[Container, GraduatedCylinder]}]]
          },
          {
            InputName -> "Volume",
            Description -> "The amount of liquid to display in the graduated cylinder.",
            Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milliliter], Units -> Alternatives[Milliliter, Liter]]
          }
        },
        Outputs :> {
          {
            OutputName -> "Graphic",
            Description -> "A visual representation of the graduated cylinder.",
            Pattern :> ValidGraphicsP[]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentFillToVolume",
      "ExperimentTransfer",
      "PlotSerologicalPipette",
      "PlotObject"
    },
    Author -> {"ryan.bisbey"}
  }
];