(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDissolvedOxygen*)


DefineUsage[PlotDissolvedOxygen,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotDissolvedOxygen[dissolvedOxygenData]", "plot"},
        Description -> "generates a graphical plot of the data stored in the dissolved oxygen data object.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dissolvedOxygenData",
              Description -> "The DissolvedOxygen Data object(s) you wish to plot.",
              Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Data,DissolvedOxygen]]]
            },
            IndexName -> "dissolvedOxygenData"
          ]
        },
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "A graphical representation of the spectra.",
            Pattern :> _Graphics
          }
        }
      },
      {
        Definition -> {"PlotDissolvedOxygen[protocol]", "plot"},
        Description -> "creates a 'plot' of the dissolved oxygen data found in the Data field of 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "The protocol object containing dissolved oxygen data objects.",
            Widget -> Alternatives[
              Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, MeasureDissolvedOxygen]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "The figure generated from data found in the dissolved oxygen protocol.",
            Pattern :> ValidGraphicsP[]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentMeasureDissolvedOxygen",
      "PlotObject"
    },
    Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"}
  }
];