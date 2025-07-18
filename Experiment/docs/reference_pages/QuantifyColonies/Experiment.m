(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*ExperimentQuantifyColonies*)
DefineUsage[ExperimentQuantifyColonies,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentQuantifyColonies[Samples]", "Protocol"},
        Description -> "creates a 'Protocol' object to prepare solid media plates designed to measure cell concentration of the provided 'Samples'. Once the solid media plate is constructed by spreading cells with colony handler, it is placed in an incubator for a long period of time to allow for colony growth, then imaged with a colony handler. The total colony count of each prepared solid media plate is recorded and the result can be passed back to the original samples to calculate the Colony-Forming Unit (CFU). If the provided input 'Samples' are already plated on solid media, the 'Protocol' object is to count the number of colonies and update composition of the plated cells.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples containing microbial colonies that are counted.",
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
            Description -> "The protocol object that prepares solid media plates to grow colonies of the provided 'Samples' and images and counts them in order to identify colonies on the prepared solid media plates and to update composition of the provided 'Samples'.",
            Pattern :> ObjectP[{Object[Protocol, RoboticCellPreparation], Object[Protocol, QuantifyColonies]}]
          }
        }
      }
    },
    SeeAlso -> {
      "AnalyzeColonies",
      "PlotColonies",
      "ExperimentImageColonies",
      "ExperimentPickColonies",
      "ExperimentSpreadCells",
      "ExperimentIncubateCells",
      "ExperimentQuantifyColoniesOptions",
      "ValidExperimentQuantifyColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentQuantifyColoniesOptions*)


DefineUsage[ExperimentQuantifyColoniesOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentQuantifyColoniesOptions[Samples]", "ResolvedOptions"},
        Description -> "returns the resolved options for ExperimentQuantifyColonies when it is called on 'Samples'.",
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
            Description -> "The resolved options when ExperimentQuantifyColonies is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol, Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentQuantifyColonies",
      "ValidExperimentQuantifyColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];

(* ::Subsubsection:: *)
(*ExperimentQuantifyColoniesPreview*)

DefineUsage[ExperimentQuantifyColoniesPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentQuantifyColoniesPreview[Samples]", "Preview"},
        Description -> "returns the preview for ExperimentQuantifyColonies when it is called on 'Samples'.",
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
            Description -> "Graphical preview representing the output of ExperimentQuantifyColonies.",
            Pattern :> Null
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentQuantifyColonies",
      "ExperimentQuantifyColoniesOptions",
      "ValidExperimentQuantifyColoniesQ"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentQuantifyColoniesQ*)


DefineUsage[ValidExperimentQuantifyColoniesQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentQuantifyColoniesQ[Samples]", "Boolean"},
        Description -> "checks whether the provided 'Samples' and options are valid for calling ExperimentQuantifyColonies.",
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
            Description -> "The value indicating whether the ExperimentQuantifyColonies call is valid. The return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentQuantifyColonies proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentQuantifyColonies",
      "ExperimentQuantifyColoniesOptions"
    },
    Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
  }
];