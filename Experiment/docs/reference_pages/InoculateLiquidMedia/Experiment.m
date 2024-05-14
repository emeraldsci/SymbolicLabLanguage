(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* ExperimentInoculateLiquidMedia *)
DefineUsage[ExperimentInoculateLiquidMedia,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentInoculateLiquidMedia[objects]","protocol"},
        Description -> "creates a 'protocol' that takes colonies from the provided sample or container 'objects' and deposit them into liquid media.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "objects",
              Description-> "The samples that the colonies are taken from.",
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
            Description -> "Protocol generated to transfer colonies from the input to a liquid media.",
            Pattern :> ListableP[ObjectP[Object[Protocol,RoboticCellPreparation]]]
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
    Author -> {"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ExperimentInoculateLiquidMediaOptions *)
DefineUsage[ExperimentInoculateLiquidMediaOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentInoculateLiquidMediaOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentInoculateLiquidMedia when it is called on",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that the colonies are taken from.",
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
            Description->"Resolved options when ExperimentInoculateLiquidMedia is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentInoculateLiquidMedia",
      "ValidExperimentInoculateLiquidMediaQ"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];

(* ::Section:: *)
(* ValidExperimentInoculateLiquidMediaQ *)
DefineUsage[ValidExperimentInoculateLiquidMediaQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentInoculateLiquidMediaQ[Samples]","ResolvedOptions"},
        Description->"checks whether the provided inputs and specified options are valid for calling ExperimentInoculateLiquidMedia.",
        Inputs:> {
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples that the colonies are taken from.",
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
            Description->"Whether or not the ExperimentInoculateLiquidMedia call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentInoculateLiquidMedia",
      "ExperimentInoculateLiquidMediaOptions"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];