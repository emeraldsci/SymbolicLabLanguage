(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCover*)

DefineUsage[ExperimentOvenDry,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentOvenDry[Samples]","Protocol"},
        Description->"creates a 'Protocol' object that will dry samples or glassware in order to remove water or pyrogens, and then cool the samples or glassware in a desiccator.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or glassware that should be oven dried and then cooled.",
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
            OutputName->"Protocol",
            Description->"The protocol object(s) describing how to perform the requested drying and cooling.",
            Pattern:>ListableP[ObjectP[Object[Protocol,OvenDry]]]
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentOvenDryOptions",
      "ValidExperimentOvenDryOptions",
      "ExperimentSamplePreparation"
    },
    Tutorials -> {},
    Author -> {"daniel.shlian"}
  }
]