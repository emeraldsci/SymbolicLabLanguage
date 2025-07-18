(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*resolveWaitPrimitive*)


DefineUsage[resolveWaitPrimitive,
  {
    BasicDefinitions -> {
      {
        Definition -> {"resolveWaitPrimitive[Duration]","ResolvedOptions"},
        Description -> "returns 'ResolvedOptions' for given druation.",
        Inputs :> {
          {
            InputName -> "Duration",
            Description-> "The duration to wait for.",
            Widget->Widget[
              Type -> Quantity,
              Pattern :> GreaterP[0 Second],
              Units -> Alternatives[Second, Minute, Hour]
            ],
            Expandable->False
          }
        },
        Outputs:>{
          {
            OutputName -> "ResolvedOptions",
            Description -> "The resolved options for the wait primitive.",
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
    Author -> {"malav.desai", "waseem.vali", "thomas"}
  }];