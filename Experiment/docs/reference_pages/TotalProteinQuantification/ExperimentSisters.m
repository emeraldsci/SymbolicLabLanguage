(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*ExperimentTotalProteinQuantificationPreview*)

DefineUsage[ExperimentTotalProteinQuantificationPreview,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentTotalProteinQuantificationPreview[Samples]","Preview"},
        Description->"returns the graphical preview for ExperimentTotalProteinQuantification when it is called on 'Samples'. This preview is always Null.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be run in an absorbance- or fluorescence-based total protein concentration determination assay. The concentration of proteins present in the samples is determined by change in absorbance or fluorescence of a dye at a specific wavelength.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Preview",
            Description->"Graphical preview representing the output of ExperimentTotalProteinQuantification.  This value is always Null.",
            Pattern:>Null
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentTotalProteinQuantification",
      "ExperimentTotalProteinQuantificationOptions",
      "ValidExperimentTotalProteinQuantificationQ",
      "AnalyzeTotalProteinQuantification"
    },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"jireh.sacramento", "andrey.shur", "lei.tian", "jihan.kim", "kstepurska", "eqian", "spencer.clark"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ExperimentTotalProteinQuantificationOptions*)

DefineUsage[ExperimentTotalProteinQuantificationOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentTotalProteinQuantificationOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentTotalProteinQuantification when it is called on 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be run in an absorbance- or fluorescence-based total protein concentration determination assay. The concentration of proteins present in the samples is determined by change in absorbance or fluorescence of a dye at a specific wavelength.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description->"Resolved options when ExperimentTotalProteinQuantification is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentTotalProteinQuantification",
      "ExperimentTotalProteinQuantificationPreview",
      "ValidExperimentTotalProteinQuantificationQ",
      "AnalyzeTotalProteinQuantification"
    },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"jireh.sacramento", "andrey.shur", "lei.tian", "jihan.kim", "kstepurska", "eqian", "spencer.clark"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentTotalProteinQuantificationQ*)

DefineUsage[ValidExperimentTotalProteinQuantificationQ,
  {
    BasicDefinitions->{
      {
        Definition->{"ValidExperimentTotalProteinQuantificationQ[Samples]","Boolean"},
        Description->"checks whether the provided inputs and specified options are valid for calling ExperimentTotalProteinQuantification.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples to be run in an absorbance- or fluorescence-based total protein concentration determination assay. The concentration of proteins present in the samples is determined by change in absorbance or fluorescence of a dye at a specific wavelength.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs->{
          {
            OutputName->"Boolean",
            Description->"Whether or not the ExperimentTotalProteinQuantification call is valid. Return value can be changed via the OutputFormat option.",
            Pattern:>_EmeraldTestSummary|BooleanP
          }
        }
      }
    },
    SeeAlso->{
      "ExperimentTotalProteinQuantification",
      "ExperimentTotalProteinQuantificationOptions",
      "ExperimentTotalProteinQuantificationPreview",
      "AnalyzeTotalProteinQuantification"
    },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"jireh.sacramento", "andrey.shur", "lei.tian", "jihan.kim", "kstepurska", "eqian", "spencer.clark"}
  }
];