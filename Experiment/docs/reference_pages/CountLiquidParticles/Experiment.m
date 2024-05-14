(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentCountLiquidParticles*)

DefineUsage[ExperimentCountLiquidParticles,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentCountLiquidParticles[Samples]", "Protocol"},
        Description -> "generates a 'Protocol' object to run a high accuracy light obscuration (HIAC) experiment to count liquid particles of different sizes.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be flow through the light obscuration detector.",
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
            OutputName -> "Protocol",
            Description -> "A protocol object that describes the light obscuration experiment to be run.",
            Pattern :> ObjectP[Object[Protocol, CountLiquidParticles]]
          }
        }
      }
    },
    MoreInformation -> {
    },
    SeeAlso -> {
      "ExperimentCountLiquidParticlesOptions",
      "ExperimentCountLiquidParticlesPreview",
      "ValidExperimentCountLiquidParticlesQ",
      "ExperimentDynamicLightScattering",
      "ExperimentNephelometry"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"jihan.kim", "lige.tonggu", "weiran.wang", "kstepurska"}
  }
];

(* ::Subsubsection::Closed:: *)
(*CountLiquidParticles*)

DefineUsage[CountLiquidParticles,
  {
    BasicDefinitions -> {
      {
        Definition -> {"CountLiquidParticles[Options]","UnitOperation"},
        Description -> "generates an ExperimentSamplePreparation-compatible 'UnitOperation' that run a high accuracy light obscuration (HIAC) experiment to count liquid particles of different sizes.",
        Inputs :> {
          {
            InputName -> "options",
            Description-> "The options that specify the sample and other experimental parameters for counting liquid particles of different sizes.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          }
        },
        Outputs:>{
          {
            OutputName -> "UnitOperation",
            Description -> "The unit operation that represents this measurement.",
            Pattern :> _List
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentCountLiquidParticles",
      "UploadCountLiquidParticlesMethod",
      "ExperimentSamplePreparation",
      "Experiment"
    },
    Author -> {"jihan.kim", "lige.tonggu"}
  }
];