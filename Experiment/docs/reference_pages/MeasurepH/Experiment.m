(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasurepH*)


DefineUsage[ExperimentMeasurepH,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasurepH[Samples]","Protocol"},
        Description->"generates a 'Protocol' to measure pH of the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers to be measured.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                ObjectTypes->{Object[Sample],Object[Container]},
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
            Description->"The protocol object(s) generated to measure pH of the input objects.",
            Pattern:>ListableP[ObjectP[Object[Protocol, MeasurepH]]]
          }
        }
      }
    },
    MoreInformation -> {
      "Based on the size/types of the container(s) in the input 'Items', the protocol will automatically choose the optimal pH measurement technique."
    },
    SeeAlso -> {
			"ValidExperimentMeasurepHQ",
			"ExperimentMeasurepHOptions",
			"ExperimentMeasurepHPreview",
			"pHDevices",
      "ExperimentMeasureVolume",
      "ExperimentWeight"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"xu.yi", "hayley", "mohamad.zandian", "thomas"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasurepHOptions*)


DefineUsage[ExperimentMeasurepHOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasurepHOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentMeasurepHOptions for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose pH will be measured.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                ObjectTypes->{Object[Sample],Object[Container]},
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
            Description -> "Resolved options when ExperimentMeasurepHOptions is called on the input objects.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "This function returns the resolved options that would be fed to ExperimentMeasurepHOptions if it were called on these input objects."
    },
    SeeAlso -> {
      "ExperimentMeasurepH",
      "ExperimentMeasurepHPreview",
      "ValidExperimentMeasurepHQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"xu.yi", "hayley", "mohamad.zandian"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasurepHPreview*)


DefineUsage[ExperimentMeasurepHPreview,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasurepHPreview[Samples]","Preview"},
        Description -> "returns the preview for ExperimentMeasurepH for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose pH will be measured.",
              Widget->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                ObjectTypes->{Object[Sample],Object[Container]},
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
            Description -> "Graphical preview representing the output of ExperimentMeasurepH. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentMeasurepH",
      "ExperimentMeasurepHOptions",
      "ValidExperimentMeasurepHQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"xu.yi", "hayley", "mohamad.zandian"}
  }
];


(* ::Subsubsection:: *)
(*ValidExperimentMeasurepHQ*)

DefineUsage[ValidExperimentMeasurepHQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMeasurepHQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentMeasurepH.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers whose pH will be measured.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
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
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMeasurepH call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasurepH",
			"ExperimentMeasurepHOptions",
			"ExperimentMeasurepHPreview"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"xu.yi", "hayley", "mohamad.zandian"}
	}
];