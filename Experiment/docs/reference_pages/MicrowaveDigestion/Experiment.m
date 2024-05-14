(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMicrowaveDigestion*)


DefineUsage[ExperimentMicrowaveDigestion,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMicrowaveDigestion[Samples]","Protocol"},
        Description->"generates a 'Protocol' for performing microwave digestion on the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "Microwave digestion is used break down organic and inorganic samples into their fully oxidized constituent elements. It is most commonly used to prepare samples for elemental analysis techniques, and employs high temperature conditions in the presence of strongly acidic and oxidizing reagents.",
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
            OutputName->"Protocol",
            Description->"A protocol object for performing microwave digestion.",
            Pattern:>ObjectP[Object[Protocol,MicrowaveDigestion]]
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentMicrowaveDigestionOptions",
      "ValidExperimentMicrowaveDigestionQ"
    },
    Author -> {"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMicrowaveDigestionOptions*)

DefineUsage[ExperimentMicrowaveDigestionOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentMicrowaveDigestionOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for performing microwave digestion on the 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be digested.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                Dereference->{
                  Object[Container]->Field[Contents[[All,2]]]
                }
              ],
              Expandable->False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentMicrowaveDigestionOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentMicrowaveDigestion."
    },
    SeeAlso -> {
      "ExperimentMicrowaveDigestion",
      "ValidExperimentMicrowaveDigestionQ"
    },
    Author -> {"alou", "robert"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMicrowaveDigestionQ*)


DefineUsage[ValidExperimentMicrowaveDigestionQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentMicrowaveDigestionQ[Samples]", "Booleans"},
        Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentMicrowaveDigestion.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be measured.",
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
                }
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Booleans",
            Description -> "Whether or not the ExperimentMicrowaveDigestion call is valid.  Return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary | BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentMicrowaveDigestion",
      "ExperimentMicrowaveDigestionOptions"
    },
    Author -> {"alou", "robert"}
  }
];

DefineUsage[ExperimentMicrowaveDigestionPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentMicrowaveDigestionPreview[Samples]", "Preview"},
        Description -> "returns a preview of the temperature profile specified for each of the 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be measured.",
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
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
            Description -> "A preview of the ExperimentMicrowaveDigestion output.  Return value can be changed via the OutputFormat option.",
            Pattern :> Null
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentMicrowaveDigestion",
      "ExperimentMicrowaveDigestionOptions"
    },
    Author -> {"alou", "robert"}
  }
];