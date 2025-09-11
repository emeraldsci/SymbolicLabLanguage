(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*ExperimentImageColonies*)
DefineUsage[ExperimentImageColonies,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentImageColonies[Samples]", "Protocol"},
        Description -> "creates a 'Protocol' for acquiring bright-field, absorbance or fluorescence images of the provided 'Samples' on a plate using a colony handler.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples that contained microbial colonies that are imaged.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "Well" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                      PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                    ],
                    "Container Position" -> Widget[
                      Type -> String,
                      Pattern :> LocationPositionP,
                      PatternTooltip -> "Any valid container position.",
                      Size -> Word
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
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
            Description -> "The protocol object generated to acquire images of the provided 'Samples'.",
            Pattern :> ObjectP[Object[Protocol, RoboticCellPreparation]]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentQuantifyColonies",
      "ExperimentPickColonies",
      "ExperimentImageCells",
      "ExperimentImageSample",
      "ExperimentImageColoniesOptions",
      "ValidExperimentImageColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentImageColoniesOptions*)


DefineUsage[ExperimentImageColoniesOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentImageColoniesOptions[Samples]", "ResolvedOptions"},
        Description -> "returns the resolved options for ExperimentImageColonies when it is called on 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples that contained microbial colonies that are imaged.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "Well" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                      PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                    ],
                    "Container Position" -> Widget[
                      Type -> String,
                      Pattern :> LocationPositionP,
                      PatternTooltip -> "Any valid container position.",
                      Size -> Word
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
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
            Description -> "The resolved options when ExperimentImageColonies is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentImageColonies",
      "ValidExperimentImageColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];

(* ::Subsubsection:: *)
(*ExperimentImageColoniesPreview*)

DefineUsage[ExperimentImageColoniesPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentImageColoniesPreview[Samples]", "Preview"},
        Description -> "returns the preview for ExperimentImageColonies when it is called on 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples that contained microbial colonies that are imaged.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "Well" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                      PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                    ],
                    "Container Position" -> Widget[
                      Type -> String,
                      Pattern :> LocationPositionP,
                      PatternTooltip -> "Any valid container position.",
                      Size -> Word
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
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
            OutputName -> "Preview",
            Description -> "Graphical preview representing the output of ExperimentImageColonies.",
            Pattern :> Null
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentImageColonies",
      "ExperimentImageColoniesOptions",
      "ValidExperimentImageColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentImageColoniesQ*)


DefineUsage[ValidExperimentImageColoniesQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentImageColoniesQ[Samples]", "Boolean"},
        Description -> "checks whether the provided 'Samples' and options are valid for calling ExperimentImageColonies.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples that contained microbial colonies that are imaged.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "Well" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                      PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                    ],
                    "Container Position" -> Widget[
                      Type -> String,
                      Pattern :> LocationPositionP,
                      PatternTooltip -> "Any valid container position.",
                      Size -> Word
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
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
            Description -> "The value indicating whether the ExperimentImageColonies call is valid. The return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentImageColonies proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentImageColonies",
      "ExperimentImageColoniesOptions"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];