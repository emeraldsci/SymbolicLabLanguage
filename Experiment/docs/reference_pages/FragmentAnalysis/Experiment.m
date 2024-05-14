             (* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentCapillaryElectrophoresis Usage *)


DefineUsage[ExperimentFragmentAnalysis, {
  BasicDefinitions -> {
    {
      Definition -> {"ExperimentFragmentAnalysis[Samples]", "Protocol"},
      Description -> "generates a 'Protocol' object for running qualitative or quantitative fragment analysis of up to 96 DNA or RNA samples in a single run using an array-based capillary electrophoresis instrument. The nucleic acid analytes are separated based on fragment size as the sample runs while there is an applied electric potential across the capillaries filled with a gel matrix.",
      Inputs :> {
        IndexMatching[
          {
            InputName -> "Samples",
            Description -> "The samples that contain nucleic acid analytes (DNA or RNA) to be separated by size using an applied electric potential as it runs through a thin hollow tube containing a gel matrix. An optimum analysis method for use depends on the sample analyte type (DNA or RNA), analysis strategy (quantitative or qualitative), analyte concentration (Standard (nanogram/microliter) or High Sensitivity (picogram/microliter)) and range of fragment size (lowest and highest number of base pairs or nucleotides).",
            Widget -> Alternatives[
              "Sample or Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                ObjectTypes -> {Object[Sample], Object[Container]},
                Dereference -> {
                  Object[Container] -> Field[Contents[[All, 2]]]
                }
              ],
              "Container with Well Position" -> {
                "Well Position" -> Alternatives[
                  "A1 to H12" -> Widget[
                    Type -> Enumeration,
                    Pattern :> Alternatives @@ Flatten[AllWells[]],
                    PatternTooltip -> "Enumeration must be any well from A1 to H12."
                  ],
                  "Container Position" -> Widget[
                    Type -> String,
                    Pattern :> LocationPositionP,
                    PatternTooltip -> "Any valid container position.",
                    Size -> Line
                  ]
                ],
                "Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Container]}]
                ]
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
          Description -> "A protocol object for running a fragment analysis experiment via capillary electrophoresis using a Fragment Analyzer instrument.",
          Pattern :> ObjectP[Object[Protocol,FragmentAnalysis]]
        }
      }
    }
  },
  MoreInformation -> {
    "Each run is required to use all 96 wells of a plate containing a combination of samples, blanks (if applicable) and ladders (at least one is recommended (H12 for a 96-capillary array)).",
    "The specified ladder by the appropriate AnalysisMethod is preferred to be in well H12 of the SamplePlate for proper data processing.",
    "There are 20 manufacturer analysis methods that are used as templates for most of the parameters of the experiment. The optimum analysis method is based on the capillary array's length and analysis strategy required, as well as characteristics of the sample (analyte type, concentration, fragment size range)."
  },
  SeeAlso -> {
    "ExperimentFragmentAnalysisOptions",
    "ValidExperimentFragmentAnalysisQ",
    "ExperimentFragmentAnalysisPreview",
    "PlotFragmentAnalysis"
  },
  Tutorials -> {
    "Sample Preparation"
  },
  Author -> {
    "jireh.sacramento"
  }
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentFragmentAnalysisOptions*)

DefineUsage[ExperimentFragmentAnalysisOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentFragmentAnalysisOptions[Samples]", "ResolvedOptions"},
        Description->"generates the 'ResolvedOptions' for performing a fragment analysis experiment on the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be analyzed using Fragment Analysis for the separation and analysis of nucleic acid samples by fragment size.",
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
            Description->"Resolved options describing how the Fragment Analysis is run when ExperimentFragmentAnalysis is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation->{
      "The options returned by ExperimentFragmentAnalysisOptions may be passed directly to ExperimentFragmentAnalysis."
    },
    SeeAlso->{
      "ExperimentFragmentAnalysis",
      "ValidExperimentFragmentAnalysisQ",
      "PlotFragmentAnalysis"
    },
    Author->{
      "jireh.sacramento"
    }
  }
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentFragmentAnalysisQ*)


DefineUsage[ValidExperimentFragmentAnalysisQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentFragmentAnalysisQ[Samples]", "Boolean"},
        Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentFragmentAnalysis.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be analyzed using Fragment Analysis experiment for the separation and analysis of nucleic acid samples by fragment size.",
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
            OutputName->"Boolean",
            Description->"The value indicating whether the ExperimentFragmentAnalysis call is valid with the specified options on the provided samples. The return value can be changed via the OutputFormat option.",
            Pattern:>_EmeraldTestSummary|BooleanP
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentFragmentAnalysis",
      "ExperimentFragmentAnalysisOptions",
      "PlotFragmentAnalysis"
    },
    Author->{
      "jireh.sacramento"
    }
  }
];



DefineUsage[ExperimentFragmentAnalysisPreview,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentFragmentAnalysisPreview[Samples]","Preview"},
        Description->"returns a graphical preview of the Fragment Analysis experiment defined for 'Samples'. This output is always Null.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be analyzed using Fragment  Analysis experiment for the separation and analysis of nucleic acid samples by fragment size.",
              Widget->Widget[
                Type->Object,
                Pattern :> ObjectP[{Object[Sample],Object[Container]}],
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
            OutputName->"Preview",
            Description->"A graphical preview of the ExperimentFragmentAnalysis output. Return value can be changed via the OutputFormat option.",
            Pattern:>Null
          }
        }
      }
    },
    MoreInformation->{
      "Due to the nature of ExperimentFragmentAnalysis, no graphical preview is available for ExperimentFragmentAnalysis. ExperimentFragmentAnalysisPreview always returns Null."
    },
    SeeAlso->{
      "ExperimentFragmentAnalysis",
      "ExperimentFragmentAnalysisOptions",
      "ValidExperimentFragmentAnalysisQ",
      "PlotFragmentAnalysis"
    },
    Author->{
      "jireh.sacramento"
    }
  }
];
