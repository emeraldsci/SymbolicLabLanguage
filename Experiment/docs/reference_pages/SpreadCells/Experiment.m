(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* ExperimentSpreadCells *)
DefineUsage[ExperimentSpreadCells,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentSpreadCells[objects]","protocol"},
        Description -> "creates a 'protocol' to transfer suspended cells from the provided sample or container 'objects' and spread them onto solid media in a destination container.",
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
            Description -> "Protocol generated to transfer suspended cells and spread them on solid media in a destination container.",
            Pattern :> ListableP[ObjectP[Object[Protocol,RoboticCellPreparation]]]
          }
        }
      }
    },
    MoreInformation -> {
      "Based on the cells in the input 'objects', the protocol will automatically choose the optimal spreading technique."
    },
    SeeAlso -> {
      "ValidExperimentSpreadCellsQ",
      "ExperimentSpreadCellsOptions",
      "ExperimentInoculateLiquidMedia",
      "ExperimentPickColonies",
      "ExperimentStreakCells"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ExperimentSpreadCellsOptions *)
DefineUsage[ExperimentSpreadCellsOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentSpreadCellsOptions[Samples]","ResolvedOptions"},
        Description->"generates a 'ResolvedOptions' object to spread the input 'Samples' onto agar culture plates.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that cells are spread from.",
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
            Description->"Resolved options when ExperimentSpreadCells is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentSpreadCells",
      "ValidExperimentSpreadCellsQ"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ValidExperimentSpreadCellsQ *)
DefineUsage[ValidExperimentSpreadCellsQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentSpreadCellsQ[Samples]","ResolvedOptions"},
        Description->"checks whether the provided inputs and specified options are valid for calling ExperimentSpreadCells.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that cells are spread from.",
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
            Description->"Whether or not the ExperimentSpreadCells call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentSpreadCells",
      "ExperimentSpreadCellsOptions"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];
(* ::Section:: *)
(* ExperimentSpreadCellsPreview *)
DefineUsage[ExperimentSpreadCellsPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentSpreadCellsPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for spreading cell suspension 'Samples' onto an agar culture plate.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The suspension culture that is spread.",
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
            Description -> "A graphical representation of the provided SpreadCells experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentSpreadCells",
      "ExperimentSpreadCellsOptions",
      "ValidExperimentSpreadCellsQ"
    },
    Tutorials -> {

    },
    Author -> {"harrison.gronlund"}
  }
];