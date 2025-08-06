(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

DefineUsage[ValidExperimentBioconjugationQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentBioconjugationQ[SamplePools, NewIdentityModels]", "Boolean"},
        Description -> "returns a 'Boolean' indicating the validity of an ExperimentBioconjugaton call for covalently binding input 'SamplePools' to create new molecules characterized by 'NewIdentityModels'.",
        Inputs :> {
          {
            InputName -> "SamplePools",
            Description -> "The samples to be chemically linked together into a pool.",
            Widget -> Alternatives[
              "Sample or Container"->Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                ObjectTypes -> {Object[Sample], Object[Container]},
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
                }
              ],
              "Model Sample"->Widget[
                Type -> Object,
                Pattern :> ObjectP[Model[Sample]],
                ObjectTypes -> {Model[Sample]}
              ]
            ],
            Expandable -> False,
            NestedIndexMatching->True
          }
        },
        Outputs :> {
          {
            OutputName -> "Boolean",
            Description -> "A True/False value indicating the validity of the provided ExperimentBioconjugaton call.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentBioconjugaton will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentBioconjugaton",
      "ExperimentBioconjugatonOptions",
      "ExperimentBioconjugatonPreview"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jireh.sacramento", "xu.yi", "steven", "cgullekson", "clayton.schwarz", "millie.shah"}
  }
];


(* ::Subsection:: *)
(*ExperimentBioconjugationOptions*)


DefineUsage[ExperimentBioconjugationOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentBioconjugationOptions[SamplePools, NewIdentityModels]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for covalently binding input 'SamplePools' to create new molecules characterized by 'NewIdentityModels'.",
        Inputs :> {
          {
            InputName -> "SamplePools",
            Description -> "The samples to be chemically linked together into a pool.",
            Widget -> Alternatives[
              "Sample or Container"->Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                ObjectTypes -> {Object[Sample], Object[Container]},
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
                }
              ],
              "Model Sample"->Widget[
                Type -> Object,
                Pattern :> ObjectP[Model[Sample]],
                ObjectTypes -> {Model[Sample]}
              ]
            ],
            Expandable -> False,
            NestedIndexMatching->True
          }
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentBioconjugationOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentBioconjugation."
    },
    SeeAlso -> {
      "ExperimentBioconjugation",
      "ValidExperimentBioconjugationQ",
      "ExperimentBioconjugationPreview"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jireh.sacramento", "xu.yi", "steven", "cgullekson", "clayton.schwarz", "millie.shah"}
  }
];

(* ::Subsection:: *)
(*ExperimentBioconjugationPreview*)


DefineUsage[ExperimentBioconjugationPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentBioconjugationPreview[SamplePools, NewIdentityModels]", "Preview"},
        Description -> "generates a graphical 'Preview' for the process of covalently binding input 'SamplePools' to create new molecules characterized by 'NewIdentityModels'.",
        Inputs :> {
          {
            InputName -> "SamplePools",
            Description -> "The samples to be chemically linked together into a pool.",
            Widget -> Alternatives[
              "Sample or Container"->Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                ObjectTypes -> {Object[Sample], Object[Container]},
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
                }
              ],
              "Model Sample"->Widget[
                Type -> Object,
                Pattern :> ObjectP[Model[Sample]],
                ObjectTypes -> {Model[Sample]}
              ]
            ],
            Expandable -> False,
            NestedIndexMatching->True
          }
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided Bioconjugation experiment.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentBioconjugation",
      "ValidExperimentBioconjugationQ",
      "ExperimentBioconjugationOptions"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jireh.sacramento", "xu.yi", "steven", "cgullekson", "millie.shah"}
  }
];