(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[LabelSample,
  {
    BasicDefinitions -> {
      {
        Definition -> {"LabelSample[Options]","UnitOperation"},
        Description -> "generates an ExperimentSamplePreparation/ExperimentCellPreparation-compatible 'UnitOperation' that labels a sample in a container for use in other primitives.",
        Inputs :> {
          {
            InputName -> "Options",
            Description-> "The options that specify the model, amount, and container of this sample.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          }
        },
        Outputs:>{
          {
            OutputName -> "UnitOperation",
            Description -> "The primitive that represents this labeled sample.",
            Pattern :> _List
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentSamplePreparation",
      "ExperimentCellPreparation",
      "Experiment"
    },
    Author -> {"taylor.hochuli", "olatunde.olademehin"}
  }
];

(* ::Subsubsection::Closed:: *)
(*resolveLabelSamplePrimitive*)

DefineUsage[resolveLabelSamplePrimitive,
  {
    BasicDefinitions -> {
      {
        Definition -> {"resolveLabelSamplePrimitive[labels]","resolvedOptions"},
        Description -> "returns 'resolvedOptions' for given sample labels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "labels",
              Description-> "The labels for the prepared samples.",
              Widget->Widget[
                Type -> String,
                Pattern :> _String,
                Size -> Line
              ],
              Expandable->False
            },
            IndexName->"sample labels"
          ]
        },
        Outputs:>{
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options for the label sample unit operation.",
            Pattern :> _List
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentSamplePreparation",
      "ExperimentRoboticSamplePreparation",
      "Experiment"
    },
    Author -> {"taylor.hochuli", "waseem.vali", "malav.desai", "thomas"}
  }
];