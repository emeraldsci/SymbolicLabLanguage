(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[LabelContainer,
  {
    BasicDefinitions -> {
      {
        Definition -> {"LabelContainer[Options]","UnitOperation"},
        Description -> "generates an ExperimentSamplePreparation/ExperimentCellPreparation-compatible 'UnitOperation' that labels a container for use in other primitives.",
        Inputs :> {
          {
            InputName -> "options",
            Description-> "The options that specify the model of this container.",
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
            Description -> "The primitive that represents this labeled container.",
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
(*resolveLabelContainerPrimitive*)


DefineUsage[resolveLabelContainerPrimitive,
  {
    BasicDefinitions -> {
      {
        Definition -> {"resolveLabelContainerPrimitive[labels]","resolvedOptions"},
        Description -> "returns 'resolvedOptions' for given container labels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "labels",
              Description-> "The labels for the prepared containers.",
              Widget->Widget[
                Type -> String,
                Pattern :> _String,
                Size -> Line
              ],
              Expandable->False
            },
            IndexName->"container labels"
          ]
        },
        Outputs:>{
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options for the label container primitive.",
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
  }];