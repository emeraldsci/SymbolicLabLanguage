(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentAdjustpH*)


DefineUsage[ExperimentAdjustpH,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentAdjustpH[Samples,targetpHs]","Protocol"},
        Description->"generates a 'Protocol' to adjust the pH of the provided 'Samples' to the 'targetpHs'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers to be measured.",
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
			              "A1 to H12" -> Widget[
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
	              }
              ],
              Expandable->True
            },
            {
              InputName->"targetpHs",
              Description->"The desired pH for each sample.",
              Widget->Widget[
                Type -> Number,
                Pattern :> RangeP[0,14]
              ],
              Expandable->True
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
			"ValidExperimentAdjustpHQ",
			"ExperimentAdjustpHOptions",
			"ExperimentAdjustpHPreview",
			"pHDevices",
      "ExperimentMeasureVolume",
      "ExperimentWeight"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"hayley", "mohamad.zandian"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentAdjustpHOptions*)


DefineUsage[ExperimentAdjustpHOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentAdjustpHOptions[Samples,targetpHs]","ResolvedOptions"},
        Description->"returns the resolved options for ExperimentAdjustpHOptions for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose pH will be measured.",
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
										"A1 to H12" -> Widget[
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
								}
							],
              Expandable->True
            },
            {
              InputName->"targetpHs",
              Description->"The desired pH for each sample.",
              Widget->Widget[
                Type -> Number,
                Pattern :> RangeP[0,14]
              ],
              Expandable->True
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description -> "Resolved options when ExperimentAdjustpHOptions is called on the input objects.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "This function returns the resolved options that would be fed to ExperimentAdjustpHOptions if it were called on these input objects."
    },
    SeeAlso -> {
      "ExperimentAdjustpH",
      "ExperimentAdjustpHPreview",
      "ValidExperimentAdjustpHQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"hayley", "mohamad.zandian"}
  }
];



(* ::Subsubsection:: *)
(*ExperimentAdjustpHPreview*)


DefineUsage[ExperimentAdjustpHPreview,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentAdjustpHPreview[Samples,targetpHs]","Preview"},
        Description -> "returns the preview for ExperimentAdjustpH for the requested 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples or containers whose pH will be measured.",
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
										"A1 to H12" -> Widget[
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
								}
							],
              Expandable->True
            },
            {
              InputName->"targetpHs",
              Description->"The desired pH for each sample.",
              Widget->Widget[
                Type -> Number,
                Pattern :> RangeP[0,14]
              ],
              Expandable->True
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Preview",
            Description -> "Graphical preview representing the output of ExperimentAdjustpH. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentAdjustpH",
      "ExperimentAdjustpHOptions",
      "ValidExperimentAdjustpHQ"
    },
    Tutorials->{
			"Sample Preparation"
		},
    Author -> {"hayley", "mohamad.zandian"}
  }
];


(* ::Subsubsection:: *)
(*ValidExperimentAdjustpHQ*)

DefineUsage[ValidExperimentAdjustpHQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentAdjustpHQ[Samples,targetpHs]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentAdjustpH.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers whose pH will be measured.",
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
										"A1 to H12" -> Widget[
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
								}
							],
							Expandable->True
						},
            {
              InputName->"targetpHs",
              Description->"The desired pH for each sample.",
              Widget->Widget[
                Type -> Number,
                Pattern :> RangeP[0,14]
              ],
              Expandable->True
            },
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentAdjustpH call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentAdjustpH",
			"ExperimentAdjustpHOptions",
			"ExperimentAdjustpHPreview"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}
];