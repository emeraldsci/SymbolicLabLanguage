

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentHPLC*)

DefineUsage[ExperimentHPLC,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentHPLC[Samples]","Protocol"},
    Description -> "generates a 'Protocol' to separate 'Samples' via high-pressure liquid chromatography (HPLC).",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Samples",
          Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via HPLC.",
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
            }
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName->"Protocol",
        Description->"A protocol object that describes the HPLC experiment to be run.",
        Pattern:>ObjectP[Object[Protocol,HPLC]]
      }
    }
  }},
  MoreInformation -> {
    "If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
    "Compatible containers for protocols using Model[Instrument, HPLC, \"Waters Acquity UPLC H-Class PDA\"] are: Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] and Model[Container, Vessel, \"HPLC vial (high recovery)\"].",
    "Compatible containers for protocols using Model[Instrument, HPLC, \"UltiMate 3000\"] are: Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
    "Compatible containers for protocols using Model[Instrument, HPLC, \"Agilent 1290 Infinity II LC System\"] are: Model[Container, Vessel, \"50mL Tube\"] and Model[Container, Vessel, \"15mL Tube\"]."
  },
  SeeAlso -> {
    "ValidExperimentHPLCQ",
    "ExperimentHPLCOptions",
    "ExperimentHPLCPreview",
    "AnalyzePeaks",
    "PlotChromatography",
    "AnalyzeFractions",
    "ExperimentMassSpectrometry",
    "ExperimentAbsorbanceSpectroscopy"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"axu", "ryan.bisbey", "waseem.vali", "robert"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentHPLCPreview*)

DefineUsage[ExperimentHPLCPreview,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentHPLCPreview[Objects]","Preview"},
    Description -> "returns the graphical preview for ExperimentHPLC when it is called on 'objects'. This output is always Null.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via HPLC.",
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
            }
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Preview",
        Description -> "Graphical preview representing the output of ExperimentHPLC.  This value is always Null.",
        Pattern :> Null
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSampleManipulation",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"axu", "ryan.bisbey", "waseem.vali"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentHPLCOptions*)

DefineUsage[ExperimentHPLCOptions,{
  BasicDefinitions -> {{
    Definition -> {"ExperimentHPLCOptions[Objects]","ResolvedOptions"},
    Description -> "returns the resolved options for ExperimentHPLC when it is called on 'objects'.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via HPLC.",
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
            }
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "ResolvedOptions",
        Description -> "Resolved options when ExperimentHPLC is called on the input samples.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSampleManipulation",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"axu", "ryan.bisbey", "waseem.vali"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentHPLCQ*)

DefineUsage[ValidExperimentHPLCQ,{
  BasicDefinitions -> {{
    Definition -> {"ValidExperimentHPLCQ[Objects]","Booleans"},
    Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentHPLC.",
    Inputs :> {
      IndexMatching[
        {
          InputName -> "Objects",
          Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via HPLC.",
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
            }
          ]
        },
        IndexName -> "experiment samples"
      ]
    },
    Outputs :> {
      {
        OutputName -> "Booleans",
        Description -> "Whether or not the ExperimentHPLC call is valid.  Return value can be changed via the OutputFormat option.",
        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
      }
    }
  }},
  MoreInformation -> {
    ""
  },
  SeeAlso -> {
    "ExperimentSampleManipulation",
    "ExperimentMassSpectrometry"
  },
  Tutorials->{
    "Sample Preparation"
  },
  Author -> {"axu", "ryan.bisbey", "waseem.vali"}
}];