

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatography*)


DefineUsage[ExperimentSupercriticalFluidChromatography,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentSupercriticalFluidChromatography[Samples]","Protocol"},
    Description -> "generates a 'Protocol' to separate and analyze 'Samples' via Supercritical Fluid Chromatography (SFC).",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be injected onto a column, separated, and analyzed via SFC.",
          Expandable -> False,
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position"->{
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size->Line
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]},
              OpenPaths -> {
                {
                  Object[Catalog, "Root"],
                  "Materials"
                }
              }
            ]
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName->"Protocol",
        Description->"A protocol object that describes the Supercritical Fluid Chromatography experiment to be run.",
        Pattern:>ObjectP[Object[Protocol,SupercriticalFluidChromatography]]
      }
    }
  }},
  MoreInformation -> {
    "If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
    "Compatible containers for protocols are: Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] and Model[Container, Vessel, \"HPLC vial (high recovery)\"]."
  },
  SeeAlso -> {
    "ValidExperimentSupercriticalFluidChromatographyQ",
    "ExperimentSupercriticalFluidChromatographyOptions",
    "ExperimentSupercriticalFluidChromatographyPreview",
    "AnalyzePeaks",
    "PlotChromatography",
    "ExperimentHPLC",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {
    "yanzhe.zhu", "ben"
  }
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatographyPreview*)

DefineUsage[ExperimentSupercriticalFluidChromatographyPreview,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentSupercriticalFluidChromatographyPreview[Objects]","Preview"},
    Description -> "returns the graphical preview for ExperimentSupercriticalFluidChromatography when it is called on 'objects'.  This output is always Null.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be injected onto a column, separated, and analyzed via SFC.",
          Expandable -> False,
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position"->{
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size->Line
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Preview",
        Description -> "Graphical preview representing the output of ExperimentSupercriticalFluidChromatography.  This value is always Null.",
        Pattern :> Null
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSupercriticalFluidChromatography",
    "ValidExperimentSupercriticalFluidChromatographyQ",
    "ExperimentSupercriticalFluidChromatographyOptions",
    "AnalyzePeaks",
    "PlotChromatography",
    "ExperimentHPLC",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {
    "yanzhe.zhu", "ben"
  }
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatographyOptions*)

DefineUsage[ExperimentSupercriticalFluidChromatographyOptions,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentSupercriticalFluidChromatographyOptions[Objects]","ResolvedOptions"},
    Description -> "returns the resolved options for ExperimentSupercriticalFluidChromatography when it is called on 'objects'.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be injected onto a column, separated, and analyzed via SFC.",
          Expandable -> False,
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position"->{
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size->Line
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "ResolvedOptions",
        Description -> "Resolved options when ExperimentSupercriticalFluidChromatography is called on the input samples.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSupercriticalFluidChromatography",
    "ValidExperimentSupercriticalFluidChromatographyQ",
    "ExperimentSupercriticalFluidChromatographyPreview",
    "AnalyzePeaks",
    "PlotChromatography",
    "ExperimentHPLC",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {
    "yanzhe.zhu", "ben"
  }
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentSupercriticalFluidChromatographyQ*)

DefineUsage[ValidExperimentSupercriticalFluidChromatographyQ,{
  BasicDefinitions -> {{
    Definition -> {"ValidExperimentSupercriticalFluidChromatographyQ[Objects]","Booleans"},
    Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentSupercriticalFluidChromatography.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be injected onto a column, separated, and analyzed via SFC.",
          Expandable -> False,
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position"->{
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size->Line
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Booleans",
        Description -> "Whether or not the ExperimentSupercriticalFluidChromatography call is valid.  Return value can be changed via the OutputFormat option.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSupercriticalFluidChromatography",
    "ExperimentSupercriticalFluidChromatographyOptions",
    "ExperimentSupercriticalFluidChromatographyPreview",
    "AnalyzePeaks",
    "PlotChromatography",
    "ExperimentHPLC",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {
    "yanzhe.zhu", "ben"
  }
}];