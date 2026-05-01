(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentOvenDry*)

DefineUsage[ValidExperimentOvenDryQ,
  {
    BasicDefinitions -> {
      {
        Definition->{"ValidExperimentOvenDryQ[Samples]","valid"},
        Description->"determines if the samples or containers are properly specified and can be oven dried.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers that should be oven dried.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample], Model[Container]}]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"valid",
            Description->"A boolean indicating if the samples or containers are properly specified and can be oven dried.",
            Pattern:>BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentOvenDryOptions",
      "ExperimentOvenDry",
      "ExperimentManualSamplePreparation"
    },
    Tutorials -> {},
    Author -> {"daniel.shlian"}
  }
];


DefineUsage[ExperimentOvenDryOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentOvenDryOptions[Samples]","ResolvedOptions"},
        Description->"calculates the full set of options which determine how the oven drying will be performed.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers that should be oven dried.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample],Model[Container]}]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description->"The full set of options which determine how the oven drying will be performed.",
            Pattern:>BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentOvenDryOptions",
      "ExperimentOvenDry",
      "ExperimentManualSamplePreparation"
    },
    Tutorials -> {},
    Author -> {"daniel.shlian"}
  }
];

DefineUsage[ExperimentOvenDryPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentOvenDryPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for oven drying input 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples or containers to be oven dried.",
              Widget ->
                  Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Sample], Model[Container]}]
                  ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided OvenDry experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentOvenDry",
      "ValidExperimentOvenDryQ",
      "ExperimentOvenDryOptions",
      "ExperimentManualSamplePreparation"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"daniel.shlian"}
  }
];