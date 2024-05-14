(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentCountLiquidParticlesQ*)

DefineUsage[ValidExperimentCountLiquidParticlesQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentCountLiquidParticlesQ[Samples]", "Boolean"},
        Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentCountLiquidParticles.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a light obscuration experiment.",
              Widget ->
                  Widget[
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
            OutputName -> "Boolean",
            Description -> "A True/False value indicating the validity of the provided ExperimentCountLiquidParticles call.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentCountLiquidParticles proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentCountLiquidParticles",
      "ExperimentCountLiquidParticlesOptions",
      "ExperimentCountLiquidParticlesPreview",
      "ExperimentDynamicLightScattering"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jihan.kim", "lige.tonggu", "weiran.wang", "kstepurska"}
  }
];

(* ::Subsection:: *)
(*ExperimentCountLiquidParticlesOptions*)


DefineUsage[ExperimentCountLiquidParticlesOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentCountLiquidParticlesOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for conducting a light obscuration experiment on 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a light obscuration experiment.",
              Widget ->
                  Widget[
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
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentCountLiquidParticlesOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentCountLiquidParticles."
    },
    SeeAlso -> {
      "ExperimentCountLiquidParticles",
      "ValidExperimentCountLiquidParticlesQ",
      "ExperimentCountLiquidParticlesPreview",
      "ExperimentDynamicLightScattering"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jihan.kim", "lige.tonggu", "weiran.wang", "kstepurska"}
  }
];

(* ::Subsection:: *)
(*ExperimentCountLiquidParticlesPreview*)


DefineUsage[ExperimentCountLiquidParticlesPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentCountLiquidParticlesPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for conducting a light obscuration experiment on input 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a light obscurating experiment.",
              Widget ->
                  Widget[
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
            Description -> "A graphical representation of the provided LightObscuration experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentCountLiquidParticles",
      "ValidExperimentCountLiquidParticlesQ",
      "ExperimentCountLiquidParticlesOptions",
      "ExperimentDynamicLightScattering"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jihan.kim", "lige.tonggu", "weiran.wang", "kstepurska"}
  }
];