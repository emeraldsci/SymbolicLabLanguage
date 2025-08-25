(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(* PlotPeaksTable *)


DefineUsage[PlotPeaksTable,
  {
    BasicDefinitions -> {
      {
        Definition -> {"PlotPeaksTable[analysisObjects]","peaksTables"},
        Description -> "Produces peaksTables with the peak information for each of the input analysisObjects which displays peak information such as peak width, peak area, peak height, and peak labels.",
        Inputs :> {
          IndexMatching[
            IndexName -> "analysis objects",
            {
              InputName -> "analysisObjects",
              Description -> "Peak analysis object(s) containing peak information such as peak width, peak area, peak height, and peak labels.",
              Widget -> Alternatives[
                Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, Peaks]]],
                Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, Peaks]]]]
              ]
            }
          ]
        },
        Outputs:>{
          {
            OutputName -> "peaksTables",
            Description -> "Table(s) containing peak information, such as peak width, peak area, peak height, and peak labels, for each peak analysis object where information can be added or removed and peak labels can be updated.",
            Pattern :> ListableP[(_DynamicModule|_Grid)]
          }
        }
      }
    },
    SeeAlso -> {
      "PlotPeaks"
    },
    Author -> {"taylor.hochuli", "david.ascough"},
    Preview -> True
  }
];