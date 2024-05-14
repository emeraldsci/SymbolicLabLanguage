(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotConductivity*)


DefineUsage[PlotConductivity,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotConductivity[conductivityData]", "plot"},
        Description -> "generates a graphical plot of the data stored in the pH data object.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "conductivityData",
              Description -> "The Conductivity Data object(s) you wish to plot.",
              Widget -> Widget[Type->Object, Pattern:>ObjectP[Object[Data,Conductivity]]]
            },
            IndexName -> "conductivityData"
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
      "ExperimentMeasureConductivity",
      "PlotObject"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];