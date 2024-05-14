

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentLCMS*)

DefineUsage[ExperimentLCMS,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentLCMS[Samples]","Protocol"},
    Description -> "generates a 'Protocol' to separate and analyze 'Samples' via Liquid Chromatography Mass Spectrometry (LCMS).",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be separated via column adsorption and analyzed.",
          Expandable -> False,
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName->"Protocol",
        Description->"A protocol object that describes the LCMS experiment to be run.",
        Pattern:>ObjectP[Object[Protocol,LCMS]]
      }
    }
  }},
  MoreInformation -> {
    "If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
    "Compatible containers are Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] and Model[Container, Vessel, \"HPLC vial (high recovery)\"]."
  },
  SeeAlso -> {
    "ValidExperimentLCMSQ",
    "ExperimentLCMSOptions",
    "ExperimentLCMSPreview",
    "PlotChromatography",
    "PlotMassSpectrometry",
    "AnalyzePeaks",
    "ExperimentMassSpectrometry",
    "ExperimentHPLC",
    "ExperimentSupercriticalFluidChromatography"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"mohamad.zandian", "jireh.sacramento", "weiran.wang"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentLCMSPreview*)

DefineUsage[ExperimentLCMSPreview,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentLCMSPreview[Objects]","Preview"},
    Description -> "returns the graphical preview for ExperimentLCMS when it is called on 'objects'.  This output is always Null.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The objects to be analyzed or quantified.",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Preview",
        Description -> "Graphical preview representing the output of ExperimentLCMS.  This value is always Null.",
        Pattern :> Null
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentLCMS",
    "ValidExperimentLCMSQ",
    "ExperimentLCMSOptions"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"mohamad.zandian", "jireh.sacramento", "weiran.wang"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentLCMSOptions*)

DefineUsage[ExperimentLCMSOptions,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentLCMSOptions[Objects]","ResolvedOptions"},
    Description -> "returns the resolved options for ExperimentLCMS when it is called on 'objects'.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The objects to be separated and measured.",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "ResolvedOptions",
        Description -> "Resolved options when ExperimentLCMS is called on the input samples.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentLCMS",
    "ValidExperimentLCMSQ",
    "ExperimentLCMSPreview"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"mohamad.zandian", "jireh.sacramento", "weiran.wang"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentLCMSQ*)

DefineUsage[ValidExperimentLCMSQ,{
  BasicDefinitions -> {{
    Definition -> {"ValidExperimentLCMSQ[Objects]","Booleans"},
    Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentLCMS.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The objects to be separated and measured.",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "A1 to P24" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Booleans",
        Description -> "Whether or not the ExperimentLCMS call is valid.  Return value can be changed via the OutputFormat option.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentLCMS",
    "ExperimentLCMSOptions",
    "ExperimentLCMSPreview"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"mohamad.zandian", "jireh.sacramento", "weiran.wang"}
}];