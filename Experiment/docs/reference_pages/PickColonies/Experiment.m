(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* ExperimentPickColonies *)
DefineUsage[ExperimentPickColonies,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentPickColonies[objects]","protocol"},
        Description -> "creates a 'protocol' to pick colonies from the provided sample or container 'objects' and deposit them into a destination container.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "objects",
              Description-> "The samples that colonies are picked from.",
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
            Description -> "Protocol generated to pick colonies and deposit them into a container.",
            Pattern :> ListableP[ObjectP[Object[Protocol,RoboticCellPreparation]]]
          }
        }
      }
    },
    MoreInformation -> {
      "Based on the colonies(s) in the input 'objects', the protocol will automatically choose the optimal picking technique."
    },
    SeeAlso -> {
      "ValidExperimentPickColoniesQ",
      "ExperimentPickColoniesOptions",
      "AnalyzeColonies",
      "AnalyzeExposureTime",
      "ExperimentInoculateLiquidMedia",
      "ExperimentSpreadCells",
      "ExperimentStreakCells"
    },
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ExperimentPickColoniesOptions *)
DefineUsage[ExperimentPickColoniesOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentPickColoniesOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentPickColonies when it is called on",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that colonies are picked from.",
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
            Description->"Resolved options when ExperimentPickColonies is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentPickColonies",
      "ValidExperimentPickColoniesQ"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ValidExperimentPickColoniesQ *)
DefineUsage[ValidExperimentPickColoniesQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentPickColoniesQ[Samples]","ResolvedOptions"},
        Description->"checks whether the provided inputs and specified options are valid for calling ExperimentPickColonies.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that colonies are picked from.",
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
            Description->"Whether or not the ExperimentPickColonies call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentPickColonies",
      "ExperimentPickColoniesOptions"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];