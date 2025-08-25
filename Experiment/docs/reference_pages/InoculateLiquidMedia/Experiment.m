(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* ExperimentInoculateLiquidMedia *)
DefineUsage[ExperimentInoculateLiquidMedia,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentInoculateLiquidMedia[Samples]", "Protocol"},
        Description -> "creates a 'protocol' that takes cells from the provided 'Samples' and deposit them into fresh liquid media to initiate culture growth.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples that the cells are taken from.",
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
                    "A1 to P24" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                      PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
                  ]
                },
                "Model Sample" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Protocol",
            Description -> "A protocol generated to transfer cells from the input to a liquid media.",
            Pattern :> ListableP[ObjectP[{Object[Protocol, RoboticCellPreparation], Object[Protocol, InoculateLiquidMedia]}]]
          }
        }
      }
    },
    MoreInformation -> {
      ""
    },
    SeeAlso -> {
      "ValidExperimentInoculateLiquidMediaQ",
      "ExperimentInoculateLiquidMediaOptions",
      "AnalyzeColonies",
      "AnalyzeExposureTime",
      "ExperimentPickColonies",
      "ExperimentTransfer",
      "ExperimentSpreadCells",
      "ExperimentStreakCells"
    },
    Author -> {"harrison.gronlund", "yanzhe.zhu", "lige.tonggu"}
  }
];

(* ::Section:: *)
(* ExperimentInoculateLiquidMediaOptions *)
DefineUsage[ExperimentInoculateLiquidMediaOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentInoculateLiquidMediaOptions[Samples]", "ResolvedOptions"},
        Description -> "returns the resolved options for ExperimentInoculateLiquidMedia when it is called on.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples that the cells are taken from.",
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
                    "A1 to P24" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                      PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
                  ]
                },
                "Model Sample" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentInoculateLiquidMedia is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol, Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentInoculateLiquidMedia",
      "ValidExperimentInoculateLiquidMediaQ"
    },
    Author -> {"harrison.gronlund", "yanzhe.zhu", "lige.tonggu"}
  }
];

(* ::Section:: *)
(* ValidExperimentInoculateLiquidMediaQ *)
DefineUsage[ValidExperimentInoculateLiquidMediaQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentInoculateLiquidMediaQ[Samples]", "Boolean"},
        Description -> "checks whether the provided inputs and specified options are valid for calling ExperimentInoculateLiquidMedia.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples that the cells are taken from.",
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
                    "A1 to P24" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                      PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
                  ]
                },
                "Model Sample" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Boolean",
            Description -> "Whether or not the ExperimentInoculateLiquidMedia call is valid. Return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentInoculateLiquidMedia",
      "ExperimentInoculateLiquidMediaOptions"
    },
    Author -> {"harrison.gronlund", "yanzhe.zhu", "lige.tonggu"}
  }
];
(* ::Section:: *)
(* ExperimentInoculateLiquidMediaPreview *)
DefineUsage[ExperimentInoculateLiquidMediaPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentInoculateLiquidMediaPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for taking cells from the provided 'Samples' and deposit them into fresh liquid media to initiate culture growth.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples that the cells are taken from.",
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
                    "A1 to P24" -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                      PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
                  ]
                },
                "Model Sample" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided InoculateLiquidMedia experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentInoculateLiquidMedia",
      "ExperimentInoculateLiquidMediaOptions",
      "ValidExperimentInoculateLiquidMediaQ",
      "ExperimentPickColonies",
      "ExperimentTransfer"
    },
    Author -> {"harrison.gronlund", "yanzhe.zhu", "lige.tonggu"}
  }
];