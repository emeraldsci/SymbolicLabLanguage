(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentDynamicLightScatteringQ*)

DefineUsage[ValidExperimentDynamicLightScatteringQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentDynamicLightScatteringQ[Samples]", "Boolean"},
        Description -> "returns a 'Boolean' indicating the validity of an ExperimentDynamicLightScattering call for conducting electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a dynamic light scattering experiment.",
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
            Description -> "A True/False value indicating the validity of the provided ExperimentDynamicLightScattering call.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentDynamicLightScattering proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentDynamicLightScattering",
      "ExperimentDynamicLightScatteringOptions",
      "ExperimentDynamicLightScatteringPreview",
      "ExperimentThermalShift"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "millie.shah", "spencer.clark"}
  }
];

(* ::Subsection:: *)
(*ExperimentDynamicLightScatteringOptions*)


DefineUsage[ExperimentDynamicLightScatteringOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentDynamicLightScatteringOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for conducting a dynamic light scattering experiment on 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a dynamic light scattering experiment.",
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
            Description -> "Resolved options when ExperimentDynamicLightScatteringOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentDynamicLightScattering."
    },
    SeeAlso -> {
      "ExperimentDynamicLightScattering",
      "ValidExperimentDynamicLightScatteringQ",
      "ExperimentDynamicLightScatteringPreview",
      "ExperimentThermalShift"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "millie.shah", "spencer.clark"}
  }
];

(* ::Subsection:: *)
(*ExperimentDynamicLightScatteringPreview*)


DefineUsage[ExperimentDynamicLightScatteringPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentDynamicLightScatteringPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for conducting a dynamic light scattering experiment on input 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run in a dynamic light scattering experiment.",
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
            Description -> "A graphical representation of the provided DynamicLightScattering experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentDynamicLightScattering",
      "ValidExperimentDynamicLightScatteringQ",
      "ExperimentDynamicLightScatteringOptions",
      "ExperimentThermalShift"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "millie.shah", "spencer.clark"}
  }
];