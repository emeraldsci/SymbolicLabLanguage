(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ExperimentLiquidLiquidExtractionOptions*)
DefineUsage[ExperimentLiquidLiquidExtractionOptions, {

  BasicDefinitions -> {
    {
      Definition -> {"ExperimentLiquidLiquidExtractionOptions[Samples]", "ResolvedOptions"},
      Description -> "returns the resolved options for ExperimentLiquidLiquidExtraction when it is called on.",
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
                  ObjectTypes -> {Model[Sample]}
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
          OutputName -> "ResolvedOptions",
          Description -> "Resolved options when ExperimentLiquidLiquidExtraction is called on the input samples.",
          Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol, Except[Automatic|$Failed]]...}
        }
      }
    }
  },

  SeeAlso -> {
    "ValidExperimentLiquidLiquidExtractionQ",
    "ExperimentLiquidLiquidExtractionOptions"
  },
  Tutorials -> {
    "Sample Preparation"
  },
  Author -> {"ben", "thomas", "lige.tonggu"}
}];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentLiquidLiquidExtractionQ*)
DefineUsage[ValidExperimentLiquidLiquidExtractionQ, {

  BasicDefinitions -> {
    {
      Definition -> {"ValidExperimentLiquidLiquidExtractionQ[Samples]","Boolean"},
      Description -> "checks whether the provided inputs and specified options are valid for calling ExperimentLiquidLiquidExtraction.",
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
                  ObjectTypes -> {Model[Sample]}
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
          OutputName -> "Boolean",
          Description -> "Whether or not the ExperimentLiquidLiquidExtraction call is valid. Return value can be changed via the OutputFormat option.",
          Pattern :> _EmeraldTestSummary|BooleanP
        }
      }
    }
  },
  SeeAlso -> {
    "ValidExperimentLiquidLiquidExtractionQ",
    "ExperimentLiquidLiquidExtractionOptions"
  },
  Tutorials -> {
    "Sample Preparation"
  },
  Author -> {"ben", "thomas", "lige.tonggu"}
}];

(* ::Subsubsection:: *)
(*ExperimentLiquidLiquidExtractionPreview*)


DefineUsage[ExperimentLiquidLiquidExtractionPreview,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentLiquidLiquidExtractionPreview[Samples]","Preview"},
        Description->"returns Null, as there is no graphical preview of the output of ExperimentLiquidLiquidExtractionPreview.",
        Inputs:>{
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
                    ObjectTypes -> {Model[Sample]}
                  ]
                }
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Preview",
            Description->"Graphical preview representing the output of ExperimentLiquidLiquidExtractionPreview.  This value is always Null.",
            Pattern:>Null
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentLiquidLiquidExtraction",
      "ExperimentLiquidLiquidExtractionOptions",
      "ValidExperimentLiquidLiquidExtractionQ"
    },
    Author -> {"ben", "thomas", "lige.tonggu"}
  }
];