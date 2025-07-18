(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureConductivity*)


DefineUsage[ExperimentMeasureConductivity,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureConductivity[Samples]","Protocol"},
        Description->"generates a 'Protocol' to measure conductivity of the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The sample(s) to be measured or container(s) holding the samples which will be measured.",
				Widget->Alternatives[
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
								PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
				],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"The protocol object(s) or packet that will be used to measure conductivity of the input objects.",
            Pattern:>ListableP[ObjectP[Object[Protocol, MeasureConductivity]]]
          }
        }
      }
    },

    SeeAlso -> {
     "ExperimentMeasureConductivityOptions",
     "ExperimentMeasureConductivityPreview",
     "ValidExperimentMeasureConductivityQ",
     "ExperimentMeasurepH",
     "ExperimentMeasureVolume",
     "ExperimentMeasureWeight",
     "ExperimentMeasureDensity",
      "ExperimentStockSolution"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"xu.yi", "dima", "steven", "simon.vu", "kstepurska"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasureConductivityOptions*)


DefineUsage[ExperimentMeasureConductivityOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureConductivityOptions[Samples]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentMeasureConductivityOptions for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The sample(s) or container(s) whose conductivity will be measured.",
				Widget->Alternatives[
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
								PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
				],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description -> "Resolved options when ExperimentMeasureConductivityOptions is called on the input objects.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "This function returns the resolved options that would be fed to ExperimentMeasureConductivityOptions if it were called on these input objects."
    },
    SeeAlso -> {
      "ExperimentMeasureConductivity",
      "ExperimentMeasureConductivityPreview",
      "ValidExperimentMeasureConductivityQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
	Author -> {"xu.yi", "dima", "steven", "simon.vu", "kstepurska"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentMeasureConductivityPreview*)


DefineUsage[ExperimentMeasureConductivityPreview,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentMeasureConductivityPreview[Samples]","Preview"},
        Description -> "returns the preview for ExperimentMeasureConductivity for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose conductivity will be measured.",
				Widget->Alternatives[
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
								PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
				],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Preview",
            Description -> "Graphical preview representing the output of ExperimentMeasureConductivity. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentMeasureConductivity",
      "ExperimentMeasureConductivityOptions",
      "ValidExperimentMeasureConductivityQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"xu.yi","dima", "steven", "simon.vu", "kstepurska"}
  }
];


(* ::Subsubsection:: *)
(*ValidExperimentMeasureConductivityQ*)


DefineUsage[ValidExperimentMeasureConductivityQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMeasureConductivityQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentMeasureConductivity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers whose conductivity will be measured.",
							Widget->Alternatives[
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
											PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMeasureConductivity call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureConductivity",
			"ExperimentMeasureConductivityOptions",
			"ExperimentMeasureConductivityPreview"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"xu.yi", "dima", "steven", "simon.vu", "kstepurska"}
	}
];