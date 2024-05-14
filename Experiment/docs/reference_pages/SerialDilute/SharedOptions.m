(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ResolveDilutionSharedOptions,
  {
    BasicDefinitions->{
      {
        Definition -> {"ResolveDilutionSharedOptions[samples]","resolvedDilutionOptions"},
        Description -> "Resolves the dilution options provided.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples to the main experiment function that will be diluted.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[Object[Sample]]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "resolvedDilutionOptions",
            Description -> "The complete set of options which fully describe how the samples will be diluted.",
            Pattern :> {(_Rule | _RuleDelayed)...}
          }
        }
      }
    },
    MoreInformation->{},
    SeeAlso->{
      "ExperimentSerialDilute",
      "ExperimentDilute"
    },
    Author->{"harrison.gronlund", "taylor.hochuli"}
  }
];