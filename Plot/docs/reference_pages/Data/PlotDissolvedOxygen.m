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
      }
    },
    SeeAlso -> {
      "ExperimentMeasureDissolvedOxygen",
      "PlotObject"
    },
    Author -> {"eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"}
  }
];