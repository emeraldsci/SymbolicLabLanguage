(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentAgaroseGelElectrophoresisQ*)


DefineUsage[ValidExperimentAgaroseGelElectrophoresisQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentAgaroseGelElectrophoresisQ[Samples]", "Boolean"},
        Description -> "returns a 'Boolean' indicating the validity of an ExperimentAgaroseGelElectrophoresis call for conducting electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run through an agarose gel and analyzed and/or purified via gel electrophoresis.",
              Widget ->
                  Alternatives[
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
                  ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Boolean",
            Description -> "A True/False value indicating the validity of the provided ExperimentAgaroseGelElectrophoresis call.",
            Pattern :> BooleanP
          }
        }
      }
    },
    MoreInformation -> {
      "This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentAgaroseGelElectrophoresis proper, will return a valid experiment."
    },
    SeeAlso -> {
      "ExperimentAgaroseGelElectrophoresis",
      "ExperimentAgaroseGelElectrophoresisOptions",
      "ExperimentAgaroseGelElectrophoresisPreview",
      "AnalyzePeaks",
      "ExperimentPAGE"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"mohamad.zandian", "hayley", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
  }
];


(* ::Subsection:: *)
(*ExperimentAgaroseGelElectrophoresisOptions*)


DefineUsage[ExperimentAgaroseGelElectrophoresisOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentAgaroseGelElectrophoresisOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for conducting electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run through an agarose gel and analyzed and/or purified via gel electrophoresis.",
              Widget ->
                  Alternatives[
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
                  ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentAgaroseGelElectrophoresisOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentAgaroseGelElectrophoresis."
    },
    SeeAlso -> {
      "ExperimentAgaroseGelElectrophoresis",
      "ValidExperimentAgaroseGelElectrophoresisQ",
      "ExperimentAgaroseGelElectrophoresisPreview",
      "AnalyzePeaks",
      "ExperimentPAGE"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"mohamad.zandian", "hayley", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
  }
];

(* ::Subsection:: *)
(*ExperimentAgaroseGelElectrophoresisPreview*)


DefineUsage[ExperimentAgaroseGelElectrophoresisPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentAgaroseGelElectrophoresisPreview[Samples]", "Preview"},
        Description -> "generates a graphical 'Preview' for conducting electrophoretic size and charged based separation on input 'Samples' by running them through agarose gels.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be run through an agarose gel and analyzed and/or purified via gel electrophoresis.",
              Widget ->
                  Alternatives[
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
                  ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A graphical representation of the provided AgaroseGelElectrophoresis experiment. This value is always Null.",
            Pattern :> Null
          }
        }
      }
    },
    MoreInformation -> {

    },
    SeeAlso -> {
      "ExperimentAgaroseGelElectrophoresis",
      "ValidExperimentAgaroseGelElectrophoresisQ",
      "ExperimentAgaroseGelElectrophoresisOptions",
      "AnalyzePeaks",
      "ExperimentPAGE"
    },
    Tutorials -> {
      "Sample Preparation"
    },
    Author -> {"mohamad.zandian", "hayley", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
  }
];