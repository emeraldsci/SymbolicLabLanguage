(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ExperimentPAGEOptions *)
DefineUsage[ExperimentPAGEOptions,
    {
        BasicDefinitions -> {
            {
                Definition -> {"ExperimentPAGEOptions[inputs]", "ResolvedOptions"},
                Description -> "outputs the resolved options of ExperimentPAGE with the provided inputs and specified options.",
                Inputs :> {
                    IndexMatching[
                        {
                            InputName -> "Samples",
                            Description -> "The samples to be run through polyacrylamide gel electrophoresis.",
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
                                },
                                "Model Sample" -> Widget[
                                    Type -> Object,
                                    Pattern :> ObjectP[Model[Sample]],
                                    ObjectTypes -> {Model[Sample]}
                                ]
                            ],
                            Expandable -> False
                        },
                        IndexName -> "experiment samples"
                    ]
                },
                Outputs :> {
                    {
                        OutputName -> "ResolvedOptions",
                        Description -> "Resolved options when ExperimentPAGE is called on the input sample(s).",
                        Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
                    }
                }
            }
        },
        SeeAlso ->
            {
                "ExperimentPAGE",
                "ExperimentPAGEPreview",
                "ValidExperimentPAGEQ"
            },
        Tutorials -> {
            "Sample Preparation"
        },
        Author -> {"ryan.bisbey", "hanming.yang", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
    }
];

(* ExperimentPAGEPreview *)
DefineUsage[ExperimentPAGEPreview,
  {
    BasicDefinitions->
        {
          {
            Definition->{"ExperimentPAGEPreview[inputs]","Preview"},
            Description->"currently ExperimentPAGE does not have a preview.",
            Inputs:> {
                IndexMatching[
                    {
                        InputName -> "Samples",
                        Description -> "The samples to be run through polyacrylamide gel electrophoresis.",
                        Widget -> Alternatives[
                            "Sample or Container"->Widget[
                                Type -> Object,
                                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                                ObjectTypes -> {Object[Sample], Object[Container]},
                                Dereference -> {
                                    Object[Container] -> Field[Contents[[All, 2]]]
                                }
                            ],
                            "Model Sample"->Widget[
                                Type -> Object,
                                Pattern :> ObjectP[Model[Sample]],
                                ObjectTypes -> {Model[Sample]}
                            ]
                        ],
                        Expandable -> False
                    },
                    IndexName -> "experiment samples"
                ]
            },
            Outputs:>{
              {
                OutputName->"Preview",
                Description->"Graphical preview representing the output of ExperimentPAGE. This value is always Null.",
                Pattern:>Null
              }
            }
          }
        },
    SeeAlso->
        {
          "ExperimentPAGE",
          "ExperimentPAGEOptions",
          "ValidExperimentPAGEQ"
        },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"ryan.bisbey", "hanming.yang", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
  }
];

(* ValidExperimentPAGEQ *)
DefineUsage[ValidExperimentPAGEQ,
  {
    BasicDefinitions->
        {
          {
            Definition->{"ValidExperimentPAGEQ[inputs]","Boolean"},
            Description->"checks whether the provided inputs and specified options are valid for calling ExperimentPAGE.",
            Inputs:> {
                IndexMatching[
                    {
                        InputName -> "Samples",
                        Description -> "The samples to be run through polyacrylamide gel electrophoresis.",
                        Widget -> Alternatives[
                            "Sample or Container"->Widget[
                                Type -> Object,
                                Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                                ObjectTypes -> {Object[Sample], Object[Container]},
                                Dereference -> {
                                    Object[Container] -> Field[Contents[[All, 2]]]
                                }
                            ],
                            "Model Sample"->Widget[
                                Type -> Object,
                                Pattern :> ObjectP[Model[Sample]],
                                ObjectTypes -> {Model[Sample]}
                            ]
                        ],
                        Expandable -> False
                    },
                    IndexName -> "experiment samples"
                ]
            },
            Outputs->{
              {
                OutputName->"Boolean",
                Description->"Whether or not the ExperimentPAGE call is valid. Return Value can be changed via the OutputFormat option.",
                Pattern:>_EmeraldTestSummary|BooleanP
              }
            }
          }
        },
    SeeAlso->
        {
          "ExperimentPAGE",
          "ExperimentPAGEOptions",
          "ExperimentPAGEPreview"
        },
    Tutorials->{
      "Sample Preparation"
    },
    Author->{"ryan.bisbey", "hanming.yang", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
  }
];