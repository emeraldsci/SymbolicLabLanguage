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
      "ExperimentSpreadCellsPreview",
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
        Description->"returns the resolved options for ExperimentSpreadCells when it is called on",
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