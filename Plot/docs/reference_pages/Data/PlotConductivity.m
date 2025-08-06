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
        Description -> "generates a graphical plot of the data stored in the conductivity data object.",
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
      },
      {
        Definition -> {"PlotConductivity[protocol]", "plot"},
        Description -> "creates a 'plot' of the conductivity data found in the Data field of 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "The protocol object containing conductivity data objects.",
            Widget -> Alternatives[
              Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, MeasureConductivity]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "The figure generated from data found in the MeasureConductivity protocol.",
            Pattern :> ValidGraphicsP[]
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