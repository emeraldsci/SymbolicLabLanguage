(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentFluorescencePolarizationKinetics*)


DefineUsage[ExperimentFluorescencePolarizationKineticsOptions,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentFluorescencePolarizationKineticsOptions[Samples]","Protocol"},
        Description->"returns the resolved options for ExperimentFluorescencePolarizationKinetics when it is called on 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The samples for which to measure fluorescence polarization kinetics.",
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
							  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
			  ]
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"ResolvedOptions",
            Description->"Resolved options when ExperimentFluorescencePolarizationKinetics is called on the input samples.",
            Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
          }
        }
      }
    },
    MoreInformation->{
    },
    SeeAlso->{
         "ExperimentFluorescencePolarizationKinetics",
		"ExperimentFluorescencePolarizationKineticsPreview",
		"ValidExperimentFluorescencePolarizationKineticsQ"
    
    },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"axu", "ryan.bisbey"}
  }
];


(* ::Subsubsection:: *)
(*ValidExperimentFluorescencePolarizationKineticsQ*)


DefineUsage[ExperimentFluorescencePolarizationKineticsPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFluorescencePolarizationKineticsPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentFluorescencePolarizationKinetics when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure fluorescence polarization kinetics.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							]
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentFluorescencePolarizationKinetics.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentFluorescencePolarizationKinetics",
			"ExperimentFluorescencePolarizationKineticsOptions",
			"ValidExperimentFluorescencePolarizationKineticsQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"axu", "ryan.bisbey"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentFluorescencePolarizationKineticsQ*)


DefineUsage[ValidExperimentFluorescencePolarizationKineticsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentFluorescencePolarizationKineticsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentFluorescencePolarizationKinetics.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which to measure fluorescence polarization kinetics.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							]
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentFluorescencePolarizationKinetics call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFluorescencePolarizationKinetics",
			"ExperimentFluorescencePolarizationKineticsPreview",
			"ExperimentFluorescencePolarizationKineticsOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"axu", "ryan.bisbey"}
	}
];
