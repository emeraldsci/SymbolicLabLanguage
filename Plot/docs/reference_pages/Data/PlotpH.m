(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotpH*)


DefineUsage[PlotpH,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotpH[pHData]", "plot"},
        Description -> "generates a graphical plot of the data stored in the pH data object.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "pHData",
              Description -> "The pH Data object(s) you wish to plot.",
              Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Data,pH]]]
            },
            IndexName -> "pHData"
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
      "ExperimentMeasurepH",
      "PlotObject"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];