(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* ExperimentStreakCells *)
DefineUsage[ExperimentStreakCells,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentStreakCells[objects]","protocol"},
        Description -> "creates a 'protocol' to transfer suspended cells from the provided sample or container 'objects' and streak them onto solid media in a destination container.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "objects",
              Description-> "The samples that cells are spread from.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position" -> {
                  "Well Position" -> Alternatives[
                    "A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
                      Type -> Enumeration,
                      Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                      PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
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
                }
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName -> "protocol",
            Description -> "Protocol generated to transfer suspended cells and streak them on solid media in a destination container.",
            Pattern :> ListableP[ObjectP[Object[Protocol,RoboticCellPreparation]]]
          }
        }
      }
    },
    MoreInformation -> {
      "Based on the cells in the input 'objects', the protocol will automatically choose the optimal streaking technique."
    },
    SeeAlso -> {
      "ValidExperimentStreakCellsQ",
      "ExperimentStreakCellsOptions",
      "ExperimentInoculateLiquidMedia",
      "ExperimentPickColonies",
      "ExperimentSpreadCells"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ExperimentStreakCellsOptions *)
DefineUsage[ExperimentStreakCellsOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentStreakCellsOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentStreakCells when it is called on.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that cells are streaked from.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                Dereference->{
                  Object[Container]->Field[Contents[[All,2]]]
                }
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description->"Resolved options when ExperimentStreakCells is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentStreakCells",
      "ValidExperimentStreakCellsQ"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ValidExperimentStreakCellsQ *)
DefineUsage[ValidExperimentStreakCellsQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentStreakCellsQ[Samples]","ResolvedOptions"},
        Description->"checks whether the provided inputs and specified options are valid for calling ExperimentStreakCells.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that cells are streaked from.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                Dereference->{
                  Object[Container]->Field[Contents[[All,2]]]
                }
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description->"Whether or not the ExperimentStreakCells call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentStreakCells",
      "ExperimentStreakCellsOptions"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];
(* ::Section:: *)
(* ExperimentStreakCellsPreview *)
DefineUsage[ExperimentStreakCellsPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentStreakCellsPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for streaking cell suspension 'Samples' onto an agar culture plate.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The suspension culture that is streaked.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                Dereference->{
                  Object[Container]->Field[Contents[[All,2]]]
                }
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided StreakCells experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentStreakCells",
      "ExperimentStreakCellsOptions",
      "ValidExperimentStreakCellsQ"
    },
    Tutorials -> {

    },
    Author -> {"harrison.gronlund"}
  }
];