(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentLiquidLiquidExtraction*)

DefineUsage[ExperimentLiquidLiquidExtraction,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentLiquidLiquidExtraction[Samples]", "Protocol"},
        Description -> "creates a 'Protocol' object to separate the aqueous and organic phases of 'Samples' via pipette or phase separator, in order to isolate a target analyte that is more concentrated in either the aqueous or organic phase.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples that contain the target analyte to be isolated via liquid liquid extraction.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  ObjectTypes -> {Object[Sample], Object[Container]},
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "A1 to H12" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
                      PatternTooltip -> "Enumeration must be any well from A1 to H12."
                    ],
                    "Container Position" -> Widget[
                      Type -> String,
                      Pattern :> LocationPositionP,
                      PatternTooltip -> "Any valid container position.",
                      Size -> Line
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
                  ],
                  "Model Sample"->Widget[
                    Type -> Object,
                    Pattern :> ObjectP[Model[Sample]],
                    ObjectTypes -> {Model[Sample]},
                    OpenPaths -> {
                      {
                        Object[Catalog, "Root"],
                        "Materials"
                      }
                    }
                  ]
                }
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Protocol",
            Description -> "The protocol object(s) describing how to run the liquid liquid experiment.",
            Pattern :> ListableP[ObjectP[Object[Protocol, RoboticSamplePreparation]]]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentLiquidLiquidExtractionOptions",
      "ValidExperimentLiquidLiquidExtractionQ",
      "ExperimentSamplePreparation"
    },
    Tutorials -> {},
    Author -> {"ben", "thomas", "lige.tonggu"}
  }
];