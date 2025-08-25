(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureDissolvedOxygen*)


DefineUsage[ExperimentMeasureDissolvedOxygen,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureDissolvedOxygen[Samples]","Protocol"},
        Description->"generates a 'Protocol' to measure the dissolved oxygen of the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers to be measured.",
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
            OutputName->"Protocol",
            Description->"The protocol object(s) generated to measure DissolvedOxygen of the input objects.",
            Pattern:>ListableP[ObjectP[Object[Protocol, MeasureDissolvedOxygen]]]
          }
        }
      }
    },
    MoreInformation -> {
      "Based on the size/types of the container(s) in the input 'Items', the protocol will automatically choose the optimal DissolvedOxygen measurement technique."
    },
    SeeAlso -> {
		"ValidExperimentMeasureDissolvedOxygenQ",
		"ExperimentMeasureDissolvedOxygenOptions",
		"ExperimentMeasureDissolvedOxygenPreview",
		"ExperimentMeasureConductivity",
		"ExperimentMeasurepH"
    },
    Author -> {"axu", "waseem.vali", "malav.desai", "cgullekson"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasureDissolvedOxygenOptions*)


DefineUsage[ExperimentMeasureDissolvedOxygenOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureDissolvedOxygenOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentMeasureDissolvedOxygenOptions for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose DissolvedOxygen will be measured.",
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
            Description -> "Resolved options when ExperimentMeasureDissolvedOxygenOptions is called on the input objects.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "This function returns the resolved options that would be fed to ExperimentMeasureDissolvedOxygenOptions if it were called on these input objects."
    },
    SeeAlso -> {
      "ExperimentMeasureDissolvedOxygen",
      "ExperimentMeasureDissolvedOxygenPreview",
      "ValidExperimentMeasureDissolvedOxygenQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"axu", "waseem.vali", "malav.desai", "cgullekson"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasureDissolvedOxygenPreview*)


DefineUsage[ExperimentMeasureDissolvedOxygenPreview,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureDissolvedOxygenPreview[Samples]","Preview"},
        Description -> "returns the preview for ExperimentMeasureDissolvedOxygen for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose DissolvedOxygen will be measured.",
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
            Description -> "Graphical preview representing the output of ExperimentMeasureDissolvedOxygen. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentMeasureDissolvedOxygen",
      "ExperimentMeasureDissolvedOxygenOptions",
      "ValidExperimentMeasureDissolvedOxygenQ"
    },
    Author -> {"axu", "waseem.vali", "malav.desai", "cgullekson"}
  }
];


(* ::Subsubsection:: *)
(*ValidExperimentMeasureDissolvedOxygenQ*)

DefineUsage[ValidExperimentMeasureDissolvedOxygenQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMeasureDissolvedOxygenQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentMeasureDissolvedOxygen.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers whose DissolvedOxygen will be measured.",
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
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMeasureDissolvedOxygen call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureDissolvedOxygen",
			"ExperimentMeasureDissolvedOxygenOptions",
			"ExperimentMeasureDissolvedOxygenPreview"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"axu", "waseem.vali", "malav.desai", "cgullekson"}
	}
];