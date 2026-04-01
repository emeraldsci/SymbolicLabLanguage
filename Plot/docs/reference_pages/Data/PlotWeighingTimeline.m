(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotWeighingTimeline *)

DefineUsage[PlotWeighingTimeline,
  {
    BasicDefinitions -> {
      {
        Definition-> {"PlotWeighingTimeline[TransferUnitOperations]", "Plots"},
        Description->" provides graphical 'Plots' of the weight log and weighing events (taring balance, empty container weight, etc.) during batched 'TransferUnitOperations'.",
        Inputs :> {
          IndexMatching[
            IndexName -> "transfer unit operations",
            {
              InputName -> "TransferUnitOperations",
              Description -> "Batched transfer unit operation(s) involving use of a balance and thus involving weight measurement.",
              Widget -> Alternatives[
                Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Object[UnitOperation, Transfer]]
                ]
              ]
            }
          ]
        },
        Outputs :> {
          {
            OutputName -> "Plots",
            Description -> "Graphical representation(s) of the weight log and weighing events (taring balance, empty container weight, etc.) that occurred during the input transfer unit operation(s).",
            Pattern :> ListableP[(ValidGraphicsP[]|_Column)]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentTransfer",
      "ExperimentManualSamplePreparation"
    },
    Author -> {"taylor.hochuli"},
    Preview -> True
  }
];