(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentRamanSpectroscopy*)


DefineUsage[ExperimentRamanSpectroscopy,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentRamanSpectroscopy[Samples]","Protocol"},
        Description->"generates a 'Protocol' object for performing Raman Spectroscopy on the provided 'Samples' in the THz and IR region (10 cm-1 to 3800 cm-1).",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "Raman Spectroscopy is used to measure the chemical and structural fingerprint of a material. Samples can include solids, liquids, and tablets. Each measurement can be done as a single point or a motion pattern that allows for interrogation of the spatial distribution of constituent components within the sample.",
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
            Description->"A protocol object for performing Raman spectroscopy.",
            Pattern:>ListableP[ObjectP[Object[Protocol,RamanSpectroscopy]]]
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentIRSpectroscopy",
      "ExperimentRamanSpectroscopyOptions",
      "ExperimentNMR"
    },
    Author -> {"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopyOptions*)

DefineUsage[ExperimentRamanSpectroscopyOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentRamanSpectroscopyOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for performing Raman spectroscopy on the 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be measured.",
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
            Description -> "Resolved options when ExperimentRamanSpectroscopyOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentRamanSpectroscopy."
    },
    SeeAlso -> {
      "ExperimentRamanSpectroscopy",
      "ValidExperimentRamanSpectroscopyQ"
    },
    Author -> {"alou", "robert"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentRamanSpectroscopyQ*)


DefineUsage[ValidExperimentRamanSpectroscopyQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentRamanSpectroscopyQ[Samples]", "Booleans"},
        Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentRamanSpectroscopy.",
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
            Description -> "Whether or not the ExperimentRamanSpectroscopy call is valid.  Return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary | BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentRamanSpectroscopy",
      "ExperimentRamanSpectroscopyOptions"
    },
    Author -> {"alou", "robert"}
  }
];

DefineUsage[ExperimentRamanSpectroscopyPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentRamanSpectroscopyPreview[Samples]", "Preview"},
        Description -> "returns a preview of the assay defined for 'Samples'.",
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
            Description -> "A preview of the ExperimentRamanSpectroscopy output.  Return value can be changed via the OutputFormat option.",
            Pattern :> Null
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentRamanSpectroscopy",
      "ExperimentRamanSpectroscopyOptions"
    },
    Author -> {"alou", "robert"}
  }
];