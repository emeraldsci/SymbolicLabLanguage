(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
(* ::Section:: *)
(*Widget Memoization*)

(* ::Section::Closed:: *)
(*Primitive Shared Option Set Definitions*)


(* ::Code::Initialization:: *)
(* NOTE: If we add an option here, we have to make sure to resolve it and store it in the Object[Protocol], in the *)
(* corresponding function. *)
DefineOptionSet[RoboticSamplePreparationOptions:>
  {
    {
      OptionName->Instrument,
      Default->Automatic,
      AllowNull->False,
      Widget->Widget[Type->Object,Pattern:>ObjectP[{
        Model[Instrument,LiquidHandler],
        Object[Instrument,LiquidHandler]
      }]],
      Description->"Indicates the liquid handler which should be used to perform the provided manipulations.",
      ResolutionDescription->"Automatically resolves based on the containers required by the manipulations.",
      Category->"Protocol"
    },
    {
      OptionName->TareWeighContainers,
      Default->True,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
      Description->"Indicates if empty containers should be tare weighed prior to running the experiment. Tare weighing of each container improves accuracy of any subsequent weighing or gravimetric volume measurement performed in the container.",
      Category->"Protocol"
    },
    {
      OptionName -> MeasureWeight,
      Default -> Automatic,
      Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
      ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
    },
    {
      OptionName -> MeasureVolume,
      Default -> Automatic,
      Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
      ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
    },
    {
      OptionName -> ImageSample,
      Default -> Automatic,
      Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
      ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
    }
  }
];

(* TODO: Figure out how to get ModifyOptions["ShareAll",...] to be happy with this *)
DefineOptionSet[RoboticCellPreparationOptions:>
    {
     ModifyOptions[RoboticSamplePreparationOptions,
       OptionName -> Instrument,
       Widget -> Widget[
         Type->Object,
         Pattern:>ObjectP[{
           Model[Instrument,LiquidHandler],
           Model[Instrument,ColonyHandler],
           Object[Instrument,LiquidHandler],
           Object[Instrument,ColonyHandler]
         }]
       ],
       Description -> "Indicates the liquid handler or colony handler which should be used to perform the provided manipulations."
     ],
      ModifyOptions[RoboticSamplePreparationOptions, OptionName -> TareWeighContainers],
      ModifyOptions[RoboticSamplePreparationOptions, OptionName -> MeasureWeight],
      ModifyOptions[RoboticSamplePreparationOptions, OptionName -> MeasureVolume],
      ModifyOptions[RoboticSamplePreparationOptions, OptionName -> ImageSample]
    }
];

DefineOptionSet[ManualSamplePreparationOptions:>
    {
      {
        OptionName -> MeasureWeight,
        Default -> Automatic,
        Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
        ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
        Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
      },
      {
        OptionName -> MeasureVolume,
        Default -> Automatic,
        Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
        ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
        Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
      },
      {
        OptionName -> ImageSample,
        Default -> Automatic,
        Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
        ResolutionDescription -> "Automatically set to False if the experiment involves Living cells and/or Sterile samples.",
        Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
      }
    }
];

DefineOptionSet[OptimizeUnitOperationsOption:>
    {
      {
        OptionName->OptimizeUnitOperations,
        Default->True,
        AllowNull->False,
        Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
        Description->"Indicates if the input list of unit operations should be automatically reordered to optimize the efficiency in which they will be executed in the lab.",
        Category->"General"
      }
    }
];

DefineOptionSet[CoverAtEndOption:>
    {
      {
        OptionName->CoverAtEnd,
        Default->Automatic,
        AllowNull->False,
        Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
        Description -> "Indicates if covers are placed on all plates after a group of robotic unit operations to decrease evaporation, if Preparation -> Robotic and WorkCell -> bioSTAR or STAR. Note the qPix does not have the ability to cover plates so CoverAtEnd cannot be set to True for protocols involving PickColonies, StreakCells, or SpreadCells unit operations.",
        ResolutionDescription -> "Automatically set to True if OptimizeUnitOperations->True.",
        Category->"General"
      }
    }
];

DefineOptionSet[UnitOperationPacketsOption :>
    {
      {
        OptionName -> UnitOperationPackets,
        Default -> False,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "Indicates if instead of returning a protocol object, this experiment function returns a list of unit operation packets containing resources.  This is used for resource generation by experiment functions whose unit operations consist of other unit operations (e.g., Aliquot consisting of Transfer and Mix unit operations). Note that if this option is set to True, fulfillableResourceQ will not be called.",
        Category -> "Hidden"
      }
    }
];

DefineOptionSet[DelayedMessagesOption :>
    {
      {
        OptionName -> DelayedMessages,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "Indicates if error messages should be gathered when resolving primitives and all thrown together at the end of the simulation loop, instead of being thrown in real time.",
        Category -> "Hidden"
      }
    }
];




(* ::Section:: *)
(*Primitive Definitions*)

(* this variable is important for (more or less) all primitive definitions below *)
(* it is the option names of the options that are shared but do not have corresponding fields in the Object[UnitOperation] by design *)
(* string form because that's how it is used below *)
(* not all of these are relevant to all primitives, but having extras here doesn't hurt *)
$NonUnitOperationSharedOptions = {"Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparedModelContainer", "PreparedModelAmount"};


(* ::Subsection::Closed:: *)
(*LabelSample Primitive*)


(* ::Code::Initialization:: *)
(* NOTE: LabelSample/LabelContainer is a little non-standard so if you're looking for a primitive to copy from, don't pick this one. *)

(* NOTE: We also have a special InternalExperiment`Private`parseLabelSamplePrimitive function that we run inside our *)
(* primitive loop via execute in our manual procedure. This adds sample labels to LabeledObjects if the resources *)
(* couldn't be created at experiment time (since you can't link a sample resource to a container model resource) and *)
(* also updates sample EHS information. *)
labelSamplePrimitive=Module[{labelSampleSharedOptions, labelSampleNonIndexMatchingSharedOptions, labelSampleIndexMatchingSharedOptions},
  (* Copy over all of the options from the resolver -- except for the protocol shared options (Cache, Upload, etc.) *)
  labelSampleSharedOptions=UnsortedComplement[
    Options[Experiment`Private`resolveLabelSamplePrimitive][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "Primitives"}]
  ];

  labelSampleNonIndexMatchingSharedOptions=UnsortedComplement[
    labelSampleSharedOptions,
    Cases[OptionDefinition[Experiment`Private`resolveLabelSamplePrimitive], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  labelSampleIndexMatchingSharedOptions=UnsortedComplement[
    labelSampleSharedOptions,
    labelSampleNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[LabelSample,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Label,
          Default -> Null,
          Description -> "The label of the samples that are to be prepared.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Widget[
            Type -> String,
            Pattern :> _String,
            Size -> Line
          ],
          Required -> True
        },
        {Experiment`Private`resolveLabelSamplePrimitive, Restricted},
        IndexMatchingParent->Label
      ]
    },
    (* Need to specify the Sample option to progress past the Inputs stage in Command Center. *)
    RequiredSharedOptions :> {
      IndexMatching[
        {Experiment`Private`resolveLabelSamplePrimitive, Sample},
        IndexMatchingParent -> Label
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
          IndexMatching[
            Sequence @@ ({Experiment`Private`resolveLabelSamplePrimitive, Symbol[#]}&) /@ labelSampleIndexMatchingSharedOptions,
            IndexMatchingParent -> Label
          ],
          If[Length[labelSampleNonIndexMatchingSharedOptions]==0,
            Nothing,
            Sequence @@ ({Experiment`Private`resolveLabelSamplePrimitive, Symbol[#]}&) /@ labelSampleNonIndexMatchingSharedOptions
          ]
        }
      },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR, microbioSTAR},

    ExperimentFunction -> Experiment`Private`resolveLabelSamplePrimitive,
    (* NOTE: These functions do very similar things to the manual equivalent InternalExperiment`Private`parseLabelSamplePrimitive. *)
    RoboticExporterFunction -> InternalExperiment`Private`exportLabelSampleRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseLabelSampleRoboticPrimitive,
    (* NOTE: This function always returns {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation}. *)
    MethodResolverFunction -> Experiment`Private`resolveLabelSampleMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveLabelSampleWorkCell,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseLabelSampleOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DefineIcon.png"}]],
    InputOptions->{Label},
    LabeledOptions->{Sample->Label},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Prepare samples and give them labels that can be used in other downstream unit operations.",
    Author -> "waseem.vali"
  ]
];



(* ::Subsection::Closed:: *)
(*LabelContainer Primitive*)


(* ::Code::Initialization:: *)
(* NOTE: LabelSample/LabelContainer is a little non-standard so if you're looking for a primitive to copy from, don't pick this one. *)
labelContainerPrimitive=Module[{labelContainerSharedOptions,labelContainerNonIndexMatchingSharedOptions,labelContainerIndexMatchingSharedOptions},
  labelContainerSharedOptions=UnsortedComplement[
    Options[Experiment`Private`resolveLabelContainerPrimitive][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "Primitives"}]
  ];

  labelContainerNonIndexMatchingSharedOptions=UnsortedComplement[
    labelContainerSharedOptions,
    Cases[OptionDefinition[Experiment`Private`resolveLabelContainerPrimitive], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  labelContainerIndexMatchingSharedOptions=UnsortedComplement[
    labelContainerSharedOptions,
    labelContainerNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[LabelContainer,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Label,
          Default -> Null,
          Description -> "The label of the samples that are to be prepared.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Widget[
            Type -> String,
            Pattern :> _String,
            Size -> Line
          ],
          Required -> True
        },
        {Experiment`Private`resolveLabelContainerPrimitive, Restricted},
        IndexMatchingParent->Label
      ]
    },
    (* Shared Options *)
    RequiredSharedOptions :> {
      IndexMatching[
        {Experiment`Private`resolveLabelContainerPrimitive, Container},
        IndexMatchingParent->Label
      ]
    },
    (* Shared Options *)
    With[
      {insertMe =
        {
          IndexMatching[
            Sequence @@ ({Experiment`Private`resolveLabelContainerPrimitive, Symbol[#]}&) /@ labelContainerIndexMatchingSharedOptions,
            IndexMatchingParent -> Label
          ],
          If[Length[labelContainerNonIndexMatchingSharedOptions]==0,
            Nothing,
            Sequence @@ ({Experiment`Private`resolveLabelContainerPrimitive, Symbol[#]}&) /@ labelContainerNonIndexMatchingSharedOptions
          ]
        }
      },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR, microbioSTAR},

    ExperimentFunction -> Experiment`Private`resolveLabelContainerPrimitive,
    (* NOTE: These functions don't do anything since we are guaranteed for container resources to be created at *)
    (* experiment time and also since there are no EHS options to LabelContainer, unlike in LabelSample. *)
    RoboticExporterFunction -> InternalExperiment`Private`exportLabelContainerRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseLabelContainerRoboticPrimitive,
    (* NOTE: This function always returns {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation}. *)
    MethodResolverFunction -> Experiment`Private`resolveLabelContainerMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveLabelContainerWorkCell,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseLabelContainerOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DefineIcon.png"}]],
    InputOptions->{Label},
    LabeledOptions->{Container->Label},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Prepare containers and given them labels that can be used in other downstream unit operations.",
    Author -> "waseem.vali"
  ]
];



(* ::Subsection::Closed:: *)
(*Wait Primitive*)


(* ::Code::Initialization:: *)
(* NOTE: Wait is a little non-standard so if you're looking for a primitive to copy from, don't pick this one. *)
waitPrimitive=DefinePrimitive[Wait,
  (* Input Options *)
  Options :> {
    {
      OptionName -> Duration,
      Default -> Null,
      Description -> "The amount of time to pause before continuing the execution of future unit operations.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type->Quantity,
        Pattern:>GreaterP[0 Second],
        Units->Alternatives[Hour, Minute, Second]
      ],
      Required -> True
    }
  },
  Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
  WorkCells -> {STAR, bioSTAR, microbioSTAR},
  ExperimentFunction -> Experiment`Private`resolveWaitPrimitive,
  MethodResolverFunction -> Experiment`Private`resolveWaitMethod,
  WorkCellResolverFunction -> Experiment`Private`resolveWaitWorkCell,
  RoboticExporterFunction -> InternalExperiment`Private`exportWaitPrimitive,
  RoboticParserFunction -> InternalExperiment`Private`parseWaitPrimitive,
  OutputUnitOperationParserFunction -> InternalExperiment`Private`parseWaitOutputUnitOperation,

  Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WaitIcon.png"}]],
  InputOptions->{Duration},
  Generative->False,
  Category->"Sample Preparation",
  Description->"Pauses for a specified amount of time."
];


(* ::Subsection::Closed:: *)
(*Cover Primitive*)


(* ::Code::Initialization:: *)
coverPrimitive = Module[{coverSharedOptions, coverNonIndexMatchingSharedOptions, coverIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  coverSharedOptions=UnsortedComplement[
    Options[ExperimentCover][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  coverNonIndexMatchingSharedOptions=UnsortedComplement[
    coverSharedOptions,
    Cases[OptionDefinition[ExperimentCover], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

 coverIndexMatchingSharedOptions=UnsortedComplement[
    coverSharedOptions,
    coverNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Cover,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples or containers that should be covered.",
          AllowNull -> False,
          Category -> "General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Object[Sample],Object[Container]}]
          ],
          Required -> True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
        IndexMatching[
          Sequence @@ ({ExperimentCover, Symbol[#]}&) /@ coverIndexMatchingSharedOptions,
          IndexMatchingParent -> Sample
        ],
        If[Length[coverNonIndexMatchingSharedOptions]==0,
          Nothing,
          Sequence @@ ({ExperimentCover, Symbol[#]}&) /@ coverNonIndexMatchingSharedOptions
        ]
      }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentCover,
    RoboticExporterFunction -> InternalExperiment`Private`exportCoverRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseCoverRoboticPrimitive,
    MethodResolverFunction -> Experiment`Private`resolveCoverMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseCoverOutputUnitOperation,
    WorkCellResolverFunction -> Experiment`Private`resolveExperimentCoverWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Attach caps, lids, or plate seals to the tops of containers in order to secure their contents.",
    Author -> {"robert", "alou"}
  ]
];


(* ::Subsection::Closed:: *)
(*Uncover Primitive*)


(* ::Code::Initialization:: *)
uncoverPrimitive = Module[{uncoverSharedOptions, uncoverNonIndexMatchingSharedOptions, uncoverIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  uncoverSharedOptions=UnsortedComplement[
    Options[ExperimentUncover][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  uncoverNonIndexMatchingSharedOptions=UnsortedComplement[
    uncoverSharedOptions,
    Cases[OptionDefinition[ExperimentUncover], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  uncoverIndexMatchingSharedOptions=UnsortedComplement[
    uncoverSharedOptions,
    uncoverNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Uncover,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples or containers that should be uncovered.",
          AllowNull -> False,
          Category -> "General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Object[Sample],Object[Container]}]
          ],
          Required -> True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentUncover, Symbol[#]}&) /@ uncoverIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[coverNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentUncover, Symbol[#]}&) /@ uncoverNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentUncover,
    RoboticExporterFunction -> InternalExperiment`Private`exportUncoverRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseUncoverRoboticPrimitive,
    MethodResolverFunction -> Experiment`Private`resolveUncoverMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseUncoverOutputUnitOperation,
    WorkCellResolverFunction -> Experiment`Private`resolveExperimentUncoverWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Removes caps, lids, or plate seals to the tops of containers in order to expose their contents.",
    Author -> {"robert", "alou"}
  ]
];



(* ::Subsection::Closed:: *)
(*Incubate Primitive*)


(* ::Code::Initialization:: *)
incubatePrimitive = Module[{incubateSharedOptions, incubateNonIndexMatchingSharedOptions, incubateIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  incubateSharedOptions=UnsortedComplement[
    Options[ExperimentIncubate][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions, "ExperimentFunction"}]
  ];

  incubateNonIndexMatchingSharedOptions=UnsortedComplement[
    incubateSharedOptions,
    Cases[OptionDefinition[ExperimentIncubate], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  incubateIndexMatchingSharedOptions=UnsortedComplement[
    incubateSharedOptions,
    incubateNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Incubate,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be incubated.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentIncubate, Symbol[#]}&) /@ incubateIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[incubateNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentIncubate, Symbol[#]}&) /@ incubateNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentIncubate,
    RoboticExporterFunction -> InternalExperiment`Private`exportIncubateRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseIncubateRoboticPrimitive,
    MethodResolverFunction -> Experiment`Private`resolveIncubateMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseIncubateOutputUnitOperation,
    WorkCellResolverFunction -> Experiment`Private`resolveExperimentIncubateWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","IncubateIcon.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Heat and/or mix samples for a specified period of time."
  ]
];



(* ::Subsection::Closed:: *)
(*Mix Primitive*)


(* ::Code::Initialization:: *)
mixPrimitive = Module[{mixSharedOptions, mixNonIndexMatchingSharedOptions, mixIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentMix -- except for the funtopia shared options (Cache, Upload, etc.) *)
  mixSharedOptions=UnsortedComplement[
    Options[ExperimentMix][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions, "ExperimentFunction"}]
  ];

  mixNonIndexMatchingSharedOptions=UnsortedComplement[
    mixSharedOptions,
    Cases[OptionDefinition[ExperimentMix], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  mixIndexMatchingSharedOptions=UnsortedComplement[
    mixSharedOptions,
    mixNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Mix,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be mixed.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentMix, Symbol[#]}&) /@ mixIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[mixNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentMix, Symbol[#]}&) /@ mixNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentMix,
    RoboticExporterFunction -> InternalExperiment`Private`exportMixRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseMixRoboticPrimitive,
    MethodResolverFunction -> Experiment`Private`resolveIncubateMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseMixOutputUnitOperation,
    WorkCellResolverFunction->Experiment`Private`resolveExperimentMixWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MixIcon.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    CompletedOptions->{
      AspirationDate, AspirationPressure, AspirationLiquidLevelDetected, AspirationErrorMessage, AspirationDetectedLiquidLevel
    },
    Generative->False,
    Category->"Sample Preparation",
    Description->"Heat and/or mix samples for a specified period of time."
  ]
];


(* ::Subsection::Closed:: *)
(*Transfer Primitive*)


(* ::Code::Initialization:: *)
transferPrimitive = Module[{transferSharedOptions, transferNonIndexMatchingSharedOptions, transferIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  transferSharedOptions =UnsortedComplement[
    Options[ExperimentTransfer][[All, 1]],
    (* NOTE: Amount is a hidden option in the macro experiment function that we use for the resource packets function. *)
    (* MultichannelTransferName is also a hidden option that we use for the resource packets function. *)
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "MultichannelTransferName", "Amount"}]
  ];

  transferNonIndexMatchingSharedOptions=UnsortedComplement[
    transferSharedOptions,
    Cases[OptionDefinition[ExperimentTransfer], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  transferIndexMatchingSharedOptions=UnsortedComplement[
    transferSharedOptions,
    transferNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Transfer,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Source,
          Default -> Null,
          Description -> "The samples or locations from which liquid or solid is transferred.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "New Container with Index"->{
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            },
            "Existing Container with Well Position"->{
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
            }
          ],
          Required -> True,
          Expandable -> True
        },
        {
          OptionName -> Destination,
          Default -> Null,
          Description -> "The sample or location to which the liquids/solids are transferred.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Item],Object[Container],Model[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "New Container with Index"->{
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            },
            "Existing Container with Well Position"->{
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
            "Waste"->Widget[
              Type->Enumeration,
              Pattern:>Alternatives[Waste]
            ]
          ],
          Required -> True,
          Expandable -> True
        },
        {
          OptionName -> Amount,
          Default -> Null,
          Description -> "The volumes of the samples to be transferred.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Volume" -> Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Microliter, 20 Liter],
              Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
            ],
            "Mass" -> Widget[
              Type -> Quantity,
              Pattern :> RangeP[1 Milligram, 20 Kilogram],
              Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
            ],
            "Count" -> Widget[
              Type -> Number,
              Pattern :> GreaterP[0., 1.]
            ],
            "All" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[All]
            ]
          ],
          Required -> True,
          Expandable -> True
        },
        IndexMatchingParent -> Source
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
          IndexMatching[
            Sequence @@ ({ExperimentTransfer, Symbol[#]}&) /@ transferIndexMatchingSharedOptions,
            IndexMatchingParent -> Source
          ],
          If[Length[transferNonIndexMatchingSharedOptions]==0,
            Nothing,
            Sequence @@ ({ExperimentTransfer, Symbol[#]}&) /@ transferNonIndexMatchingSharedOptions
          ]
        }
      },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentTransfer,
    RoboticExporterFunction -> InternalExperiment`Private`exportTransferRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseTransferRoboticPrimitive,
    MethodResolverFunction -> resolveTransferMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseTransferOutputUnitOperation,
    WorkCellResolverFunction->Experiment`Private`resolveExperimentTransferWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "TransferIcon.png"}]],
    LabeledOptions -> {Source -> SourceLabel, Destination -> DestinationLabel, Null->SourceContainerLabel, Null->DestinationContainerLabel},
    InputOptions -> {Source, Destination, Amount},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      (* NOTE: Manual only keys. *)
      EnvironmentalData, DefinedSourceLayers, DefinedDestinationLayers, MeasuredSourceTemperatures,
      MeasuredSourceTemperatureData, MeasuredDestinationTemperatures, MeasuredDestinationTemperatureData,
      MeasuredTransferWeights, MeasuredTransferWeightData, ResidueWeights, ResidueWeightData, DestinationSampleHandling, PercentTransferred,
      MagneticSeparation,

      (* NOTE: These are the keys for TADM data. *)
      AspirationDate, AspirationPressure, AspirationLiquidLevelDetected, AspirationErrorMessage, AspirationDetectedLiquidLevel,
      DispenseDate, DispensePressure, DispenseLiquidLevelDetected, DispenseErrorMessage, DispenseDetectedLiquidLevel,
      AspirationClassifications, AspirationClassificationConfidences
    },
    Generative -> True,
    GenerativeLabelOption -> DestinationLabel,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample from the given sources to the given destinations."
  ]
];


(* ::Subsection::Closed:: *)
(*Pellet Primitive*)


(* ::Code::Initialization:: *)
pelletPrimitive = Module[{pelletSharedOptions, pelletNonIndexMatchingSharedOptions, pelletIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  pelletSharedOptions=UnsortedComplement[
    Options[ExperimentPellet][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions, "ExperimentFunction"}]
  ];

  pelletNonIndexMatchingSharedOptions=UnsortedComplement[
    pelletSharedOptions,
    Cases[OptionDefinition[ExperimentPellet], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  pelletIndexMatchingSharedOptions=UnsortedComplement[
    pelletSharedOptions,
    pelletNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Pellet,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be pelleted.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
        IndexMatching[
          Sequence @@ ({ExperimentPellet, Symbol[#]}&) /@ pelletIndexMatchingSharedOptions,
          IndexMatchingParent -> Sample
        ],
        If[Length[pelletNonIndexMatchingSharedOptions]==0,
          Nothing,
          Sequence @@ ({ExperimentPellet, Symbol[#]}&) /@ pelletNonIndexMatchingSharedOptions
        ]
      }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentPellet,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    MethodResolverFunction -> Experiment`Private`resolvePelletMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parsePelletOutputUnitOperation,
    WorkCellResolverFunction->Experiment`Private`resolvePelletWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CentrifugeIcon.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Precipitate solids that are present in a solution, aspirate off the supernatant, and optionally resuspend the pellet in a resuspension solution.",
    Author -> "taylor.hochuli"
  ]
];



(* ::Subsection::Closed:: *)
(* Filter Primitive *)


(* ::Code::Initialization:: *)
filterPrimitive = Module[{filterSharedOptions, filterNonIndexMatchingSharedOptions, filterIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentFilter -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  filterSharedOptions =UnsortedComplement[
    Options[ExperimentFilter][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}],
      (* NOTE: We DO want to copy over the aliquot options for the manual primitive. *)
      Options[AliquotOptions][[All, 1]]
    ]
  ];

  filterNonIndexMatchingSharedOptions=UnsortedComplement[
    filterSharedOptions,
    Cases[OptionDefinition[ExperimentFilter], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  filterIndexMatchingSharedOptions=UnsortedComplement[
    filterSharedOptions,
    filterNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Filter,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be filtered.",
          AllowNull -> True,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
          IndexMatching[
            Sequence @@ ({ExperimentFilter, Symbol[#]}&) /@ filterIndexMatchingSharedOptions,
            IndexMatchingParent -> Sample
          ],
          If[Length[filterNonIndexMatchingSharedOptions]==0,
            Nothing,
            Sequence @@ ({ExperimentFilter, Symbol[#]}&) /@ filterNonIndexMatchingSharedOptions
          ]
        }
      },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR, microbioSTAR},

    ExperimentFunction -> ExperimentFilter,
    RoboticExporterFunction -> InternalExperiment`Private`exportFilterRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseFilterRoboticPrimitive,
    MethodResolverFunction -> resolveFilterMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseFilterOutputUnitOperation,
    WorkCellResolverFunction -> resolveExperimentFilterWorkCell,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FilterIcon.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel,
      FiltrateContainerOut -> FiltrateContainerLabel,
      RetentateContainerOut -> RetentateContainerLabel,
      ResuspensionBuffer -> ResuspensionBufferLabel,
      RetentateWashBuffer -> RetentateWashBufferLabel,
      (* robotic label *)
      CollectionContainer -> CollectionContainerLabel,
      Filter -> FilterLabel,
      Null -> RetentateWashBufferContainerLabel,
      Null -> ResuspensionBufferContainerLabel,
      Null -> FiltrateLabel,
      Null -> RetentateLabel,
      Null -> SampleContainerLabel,
      Null -> SampleOutLabel,
      Null -> ContainerOutLabel
    },
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    CompletedOptions -> {
      LoadingAspirationDate, LoadingAspirationPressure, LoadingAspirationLiquidLevelDetected, LoadingAspirationErrorMessage, LoadingAspirationDetectedLiquidLevel,
      LoadingDispenseDate, LoadingDispensePressure, LoadingDispenseLiquidLevelDetected, LoadingDispenseErrorMessage, LoadingDispenseDetectedLiquidLevel,

      RetentateWashAspirationDate, RetentateWashAspirationPressure, RetentateWashAspirationLiquidLevelDetected, RetentateWashAspirationErrorMessage,
      RetentateWashAspirationDetectedLiquidLevel, RetentateWashDispenseDate, RetentateWashDispensePressure, RetentateWashDispenseLiquidLevelDetected,
      RetentateWashDispenseErrorMessage, RetentateWashDispenseDetectedLiquidLevel,

      ResuspensionAspirationDate, ResuspensionAspirationPressure, ResuspensionAspirationLiquidLevelDetected, ResuspensionAspirationErrorMessage,
      ResuspensionAspirationDetectedLiquidLevel, ResuspensionDispenseDate, ResuspensionDispensePressure, ResuspensionDispenseLiquidLevelDetected,
      ResuspensionDispenseErrorMessage, ResuspensionDispenseDetectedLiquidLevel
    },
    Category -> "Sample Preparation",
    Description -> "Flow samples through various kinds of filters for a specified period of time and at a specified speed, force or pressure.",
    Author -> {"robert", "alou"}
  ]
];

(* ::Subsection:: *)
(* SPE Primitive *)

spePrimitive = Module[{speSharedOptions, speNonIndexMatchingSharedOptions, speIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentSolidPhaseExtraction -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  speSharedOptions =UnsortedComplement[
    Options[ExperimentSolidPhaseExtraction][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}],
      (* NOTE: We DO want to copy over the aliquot options for the manual primitive. *)
      Options[AliquotOptions][[All, 1]]
    ]
  ];

  speNonIndexMatchingSharedOptions=UnsortedComplement[
    speSharedOptions,
    Cases[OptionDefinition[ExperimentSolidPhaseExtraction], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  speIndexMatchingSharedOptions=UnsortedComplement[
    speSharedOptions,
    speNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[SolidPhaseExtraction,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be extracted by SolidPhaseExtraction.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True,
          NestedIndexMatching -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentSolidPhaseExtraction, Symbol[#]}&) /@ speIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[speNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentSolidPhaseExtraction, Symbol[#]}&) /@ speNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR,microbioSTAR},

    ExperimentFunction -> ExperimentSolidPhaseExtraction,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    MethodResolverFunction -> resolveSolidPhaseExtractionMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseSolidPhaseExtractionOutputUnitOperation,
    WorkCellResolverFunction -> resolveSolidPhaseExtractionWorkCell,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FilterIcon.png"}]],
    LabeledOptions -> {
      (* basic *)
      Sample -> SampleLabel,
      Null -> SampleOutLabel,
      ExtractionCartridge -> ExtractionCartridgeLabel,
      (* solution in *)
      PreFlushingSolution -> PreFlushingSolutionLabel,
      ConditioningSolution -> ConditioningSolutionLabel,
      WashingSolution -> WashingSolutionLabel,
      SecondaryWashingSolution -> SecondaryWashingSolutionLabel,
      TertiaryWashingSolution -> TertiaryWashingSolutionLabel,
      ElutingSolution -> ElutingSolutionLabel,
      (* solution out *)
      Null -> PreFlushingSampleOutLabel,
      Null -> ConditioningSampleOutLabel,
      Null -> LoadingSampleFlowthroughSampleOutLabel,
      Null -> WashingSampleOutLabel,
      Null -> SecondaryWashingSampleOutLabel,
      Null -> TertiaryWashingSampleOutLabel,
      Null -> ElutingSampleOutLabel,
      (* collection container label *)
      PreFlushingSolutionCollectionContainer -> PreFlushingCollectionContainerOutLabel,
      ConditioningSolutionCollectionContainer -> ConditioningCollectionContainerOutLabel,
      WashingSolutionCollectionContainer -> WashingCollectionContainerOutLabel,
      SecondaryWashingSolutionCollectionContainer -> SecondaryWashingCollectionContainerOutLabel,
      TertiaryWashingSolutionCollectionContainer -> TertiaryWashingCollectionContainerOutLabel,
      ElutingSolutionCollectionContainer -> ElutingCollectionContainerOutLabel,
      LoadingSampleFlowthroughContainer -> LoadingSampleFlowthroughCollectionContainerOutLabel
    },
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Flow samples through various kinds of ExtractionCartridge for a specified period of time and at a specified speed, force or pressure.",
    Author -> {"steven"}
  ]
];


(* ::Subsection::Closed:: *)
(*IncubateCells Primitive*)


(* ::Code::Initialization:: *)
incubateCellsPrimitive = Module[{incubateCellsSharedOptions, incubateCellsNonIndexMatchingSharedOptions, incubateCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubateCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  incubateCellsSharedOptions = UnsortedComplement[
    Options[ExperimentIncubateCells][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  incubateCellsNonIndexMatchingSharedOptions = UnsortedComplement[
    incubateCellsSharedOptions,
    Cases[OptionDefinition[ExperimentIncubateCells], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  incubateCellsIndexMatchingSharedOptions = UnsortedComplement[
    incubateCellsSharedOptions,
    incubateCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[IncubateCells,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The cell samples that are incubated.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
          IndexMatching[
            Sequence @@ ({ExperimentIncubateCells, Symbol[#]}&) /@ incubateCellsIndexMatchingSharedOptions,
            IndexMatchingParent -> Sample
          ],
          If[Length[incubateCellsNonIndexMatchingSharedOptions] == 0,
            Nothing,
            Sequence @@ ({ExperimentIncubateCells, Symbol[#]}&) /@ incubateCellsNonIndexMatchingSharedOptions
          ]
        }
      },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualCellPreparation, RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},

    ExperimentFunction -> ExperimentIncubateCells,
    RoboticExporterFunction -> InternalExperiment`Private`exportIncubateCellsRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseIncubateCellsRoboticPrimitive,
    MethodResolverFunction -> resolveIncubateCellsMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveIncubateCellsWorkCell,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseIncubateCellsOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "IncubateCells.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel,
      Null -> SampleContainerLabel
    },
    InputOptions -> {Sample},
    Generative -> False,
    CompletedOptions -> {
      Incubation, IncubationCondition, Temperature, CarbonDioxide, RelativeHumidity, IncubationTime, Shake, ShakingRate, ShakingRadius,
      InvertContainer, CellType, CultureAdhesion
    },
    Category -> "Cell Preparation",
    Description -> "Incubate cell samples for a specified period of time and at a specified temperature, humidity, and carbon dioxide percentage.",
    Author -> {"harrison.gronlund", "lige.tonggu"}
  ]
];



(* ::Subsection::Closed:: *)
(*Centrifuge Primitive*)


(* ::Code::Initialization:: *)
centrifugePrimitive=Module[
  {centrifugeSharedOptions, centrifugeNonIndexMatchingSharedOptions, centrifugeIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentCentrifuge -- except for the funtopia shared options (Cache, Upload, etc.) *)
  centrifugeSharedOptions =UnsortedComplement[
    Options[ExperimentCentrifuge][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  centrifugeNonIndexMatchingSharedOptions=UnsortedComplement[
    centrifugeSharedOptions,
    Cases[OptionDefinition[ExperimentCentrifuge], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  centrifugeIndexMatchingSharedOptions=UnsortedComplement[
    centrifugeSharedOptions,
    centrifugeNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Centrifuge,
  (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be centrifuged.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
        IndexMatching[
          Sequence @@ ({ExperimentCentrifuge, Symbol[#]}&) /@ centrifugeIndexMatchingSharedOptions,
          IndexMatchingParent -> Sample
        ],
        If[Length[centrifugeNonIndexMatchingSharedOptions]==0,
          Nothing,
          Sequence @@ ({ExperimentCentrifuge, Symbol[#]}&) /@ centrifugeNonIndexMatchingSharedOptions
        ]
      }
      },
      SharedOptions :> insertMe
    ],
    WorkCells -> {STAR,bioSTAR,microbioSTAR},
    ExperimentFunction -> ExperimentCentrifuge,
    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    RoboticExporterFunction -> InternalExperiment`Private`exportCentrifugeRoboticPrimitive,
    RoboticParserFunction -> InternalExperiment`Private`parseCentrifugeRoboticPrimitive,
    MethodResolverFunction -> Experiment`Private`resolveCentrifugeMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseCentrifugeOutputUnitOperation,
    WorkCellResolverFunction->Experiment`Private`resolveExperimentCentrifugeWorkCell,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "CentrifugeIcon.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel
    },
    InputOptions -> {Sample},
    Generative -> False,
    CompletedOptions -> {
      Instrument, RotorGeometry, RotorAngle, ChilledRotor, Rotor, Temperature, CounterbalanceWeight

    },
    Category -> "Sample Preparation",
    Description -> "Centrifuge samples for a specified period of time and at a specified speed or force.",
    Author -> {"robert", "alou"}
  ]
];



(* ::Subsection::Closed:: *)
(*FillToVolume Primitive*)


(* ::Code::Initialization:: *)
fillToVolumePrimitive = Module[{fillToVolumeSharedOptions, fillToVolumeNonIndexMatchingSharedOptions, fillToVolumeIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentFillToVolume -- except for the funtopia shared options (Cache, Upload, etc.) *)
  fillToVolumeSharedOptions =UnsortedComplement[
    Options[ExperimentFillToVolume][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  fillToVolumeNonIndexMatchingSharedOptions =UnsortedComplement[
    fillToVolumeSharedOptions,
    Cases[OptionDefinition[ExperimentFillToVolume], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  fillToVolumeIndexMatchingSharedOptions =UnsortedComplement[
    fillToVolumeSharedOptions,
    fillToVolumeNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[FillToVolume,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "Input samples for this analytical or preparative experiment which will be filled to a specified volume.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
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
          Required -> True
        },
        {
          OptionName -> TotalVolume,
          Default -> Null,
          Description -> "The volume to which to fill the destination sample with the source solvent.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[1 Microliter, 20 Liter],
            Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
          ],
          Required -> True
        },
        {
          OptionName -> Solvent,
          Default -> Automatic,
          Description -> "Source solvent to be transferred into the destination for this experiment.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container, Vessel],Model[Sample]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentFillToVolume, Symbol[#]}&) /@ fillToVolumeIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[fillToVolumeNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentFillToVolume, Symbol[#]}&) /@ fillToVolumeNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation},
    ExperimentFunction -> ExperimentFillToVolume,
    MethodResolverFunction -> resolveFillToVolumeMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseFillToVolumeOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FillToVolumeIcon.png"}]],
    LabeledOptions -> {Sample -> SampleLabel, Solvent -> SolventLabel},
    InputOptions -> {Sample, TotalVolume},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      (* NOTE: Manual only keys. *)
      EnvironmentalData
    },
    Generative -> False,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample from the given sources up to the specified volume of the given destinations."
  ]
];

(* ::Subsection:: *)
(* FlashChromatography Primitive *)

flashChromatographyPrimitive = Module[{flashChromatographySharedOptions, flashChromatographyNonIndexMatchingSharedOptions, flashChromatographyIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentFlashChromatography -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  flashChromatographySharedOptions =UnsortedComplement[
    Options[ExperimentFlashChromatography][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  flashChromatographyNonIndexMatchingSharedOptions=UnsortedComplement[
    flashChromatographySharedOptions,
    Cases[OptionDefinition[ExperimentFlashChromatography], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  flashChromatographyIndexMatchingSharedOptions=UnsortedComplement[
    flashChromatographySharedOptions,
    flashChromatographyNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[FlashChromatography,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be separated by flash chromatography.",
          AllowNull -> True,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentFlashChromatography, Symbol[#]}&) /@ flashChromatographyIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[flashChromatographyNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentFlashChromatography, Symbol[#]}&) /@ flashChromatographyNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},

    ExperimentFunction -> ExperimentFlashChromatography,
    MethodResolverFunction -> resolveFlashChromatographyMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseFlashChromatographyOutputUnitOperation,

    (* TODO: Ask Design for an icon, or just save a copy of the HPLC/FPLC icon as FlashChromatography.png *)
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "HPLC.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel,
      Column -> ColumnLabel,
      Cartridge -> CartridgeLabel
    },
    InputOptions -> {Sample},
    Generative -> False,
    Category -> "Sample Preparation",
    Description -> "Separate a sample via flash chromatography by flowing it through a column to which compounds in the sample will differentially adsorb.",
    Author -> {"dirk.schild"}
  ]
];



(* ::Subsection::Closed:: *)
(*AdjustpH Primitive*)


(* ::Code::Initialization:: *)
adjustpHPrimitive = Module[{adjustpHSharedOptions, adjustpHNonIndexMatchingSharedOptions, adjustpHIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentAdjustpH -- except for the funtopia shared options (Cache, Upload, etc.) *)
  adjustpHSharedOptions =UnsortedComplement[
    Options[ExperimentAdjustpH][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  adjustpHNonIndexMatchingSharedOptions =UnsortedComplement[
    adjustpHSharedOptions,
    Cases[OptionDefinition[ExperimentAdjustpH], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  adjustpHIndexMatchingSharedOptions =UnsortedComplement[
    adjustpHSharedOptions,
    adjustpHNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[AdjustpH,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be adjusted to a specified pH.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
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
          Required -> True
        },
        {
          OptionName -> NominalpH,
          Default -> Null,
          Description -> "The target pH to which the sample is to be adjusted.",
          AllowNull -> False,
          Category -> "General",
          Widget->Widget[
            Type->Number,
            Pattern:>RangeP[0,14]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentAdjustpH, Symbol[#]}&) /@ adjustpHIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[adjustpHNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentAdjustpH, Symbol[#]}&) /@ adjustpHNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation},
    ExperimentFunction -> ExperimentAdjustpH,
    MethodResolverFunction -> Experiment`Private`resolveAdjustpHMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseAdjustpHOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "AdjustpHIcon.png"}]],
    LabeledOptions -> {Sample -> SampleLabel},
    InputOptions -> {Sample, NominalpH},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      pHAchieved, pHMeasurements
    },
    Generative -> False,
    Category -> "Sample Preparation",
    Description -> "Adjusts the pHs of the given samples to the specified nominal pHs by adding acid and/or base.",
    Author -> {"daniel.shlian", "tyler.pabst"}
  ]
];



(* ::Subsection::Closed:: *)
(*Aliquot Primitive*)


(* ::Code::Initialization:: *)
aliquotPrimitive = Module[{aliquotSharedOptions, aliquotNonIndexMatchingSharedOptions, aliquotIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentAliquot -- except for the funtopia shared options (Cache, Upload, etc.) *)
  aliquotSharedOptions =UnsortedComplement[
    Options[ExperimentAliquot][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  aliquotNonIndexMatchingSharedOptions =UnsortedComplement[
    aliquotSharedOptions,
    Cases[OptionDefinition[ExperimentAliquot], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  aliquotIndexMatchingSharedOptions =UnsortedComplement[
    aliquotSharedOptions,
    aliquotNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Aliquot,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Source,
          Default -> Null,
          Description -> "The samples that should be aliquoted.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True,
          NestedIndexMatching -> True
        },
        IndexMatchingParent -> Source
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentAliquot, Symbol[#]}&) /@ aliquotIndexMatchingSharedOptions,
        IndexMatchingParent -> Source
      ],
      If[Length[aliquotNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentAliquot, Symbol[#]}&) /@ aliquotNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},
    WorkCellResolverFunction -> Experiment`Private`resolveAliquotWorkCell,
    ExperimentFunction -> ExperimentAliquot,
    MethodResolverFunction -> resolveAliquotMethod,

    (*note that we don't necessarily need these functions because they get called for the constituent RoboticUnitOperations.  However, we could have the parsers at least if we also want to populate fields in the corresponding unit operations *)
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseAliquotOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "AliquotIcon.png"}]],
    LabeledOptions -> {Source -> SourceLabel, ContainerOut -> ContainerOutLabel, AssayBuffer -> AssayBufferLabel, ConcentratedBuffer -> ConcentratedBufferLabel, BufferDiluent -> BufferDiluentLabel},
    InputOptions -> {Source},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      EnvironmentalData, Source
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample into a container and dilutes it with buffers as specified."
  ]
];



(* ::Subsection::Closed:: *)
(*Resuspend Primitive*)


(* ::Code::Initialization:: *)
resuspendPrimitive = Module[{resuspendSharedOptions, resuspendNonIndexMatchingSharedOptions, resuspendIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentResuspend -- except for the funtopia shared options (Cache, Upload, etc.) *)
  resuspendSharedOptions =UnsortedComplement[
    Options[ExperimentResuspend][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  resuspendNonIndexMatchingSharedOptions =UnsortedComplement[
    resuspendSharedOptions,
    Cases[OptionDefinition[ExperimentResuspend], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  resuspendIndexMatchingSharedOptions =UnsortedComplement[
    resuspendSharedOptions,
    resuspendNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Resuspend,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be resuspended.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentResuspend, Symbol[#]}&) /@ resuspendIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[resuspendNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentResuspend, Symbol[#]}&) /@ resuspendNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},
    ExperimentFunction -> ExperimentResuspend,
    MethodResolverFunction -> resolveResuspendMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveResuspendOrDiluteWorkCell,

    (*note that we don't necessarily need these functions because they get called for the constituent RoboticUnitOperations.  However, we could have the parsers at least if we also want to populate fields in the corresponding unit operations *)
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseResuspendOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "ResuspendIcon.png"}]],
    LabeledOptions -> {Sample -> SampleLabel, ContainerOut -> ContainerOutLabel, Diluent -> DiluentLabel, ConcentratedBuffer -> ConcentratedBufferLabel, BufferDiluent -> BufferDiluentLabel},
    InputOptions -> {Sample},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      EnvironmentalData, Sample
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample into a container and dilutes it with buffers as specified.",
    Author -> {"daniel.shlian", "tyler.pabst"}
  ]
];



(* ::Subsection::Closed:: *)
(*Dilute Primitive*)


(* ::Code::Initialization:: *)
dilutePrimitive = Module[{diluteSharedOptions, diluteNonIndexMatchingSharedOptions, diluteIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentDilute -- except for the funtopia shared options (Cache, Upload, etc.) *)
  diluteSharedOptions =UnsortedComplement[
    Options[ExperimentDilute][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  diluteNonIndexMatchingSharedOptions =UnsortedComplement[
    diluteSharedOptions,
    Cases[OptionDefinition[ExperimentDilute], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  diluteIndexMatchingSharedOptions =UnsortedComplement[
    diluteSharedOptions,
    diluteNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Dilute,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be diluted.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentDilute, Symbol[#]}&) /@ diluteIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[diluteNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentDilute, Symbol[#]}&) /@ diluteNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},
    ExperimentFunction -> ExperimentDilute,
    MethodResolverFunction -> resolveDiluteMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveResuspendOrDiluteWorkCell,

    (*note that we don't necessarily need these functions because they get called for the constituent RoboticUnitOperations.  However, we could have the parsers at least if we also want to populate fields in the corresponding unit operations *)
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "AliquotIcon.png"}]],
    LabeledOptions -> {Sample -> SampleLabel, ContainerOut -> ContainerOutLabel, Diluent -> DiluentLabel, ConcentratedBuffer -> ConcentratedBufferLabel, BufferDiluent -> BufferDiluentLabel},
    InputOptions -> {Sample},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      EnvironmentalData, Sample
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample into a container and dilutes it with buffers as specified.",
    Author -> {"malav.desai"}
  ]
];



(* ::Subsection::Closed:: *)
(*SerialDilute Primitive*)


(* ::Code::Initialization:: *)
serialDilutePrimitive = Module[{serialDiluteSharedOptions, serialDiluteNonIndexMatchingSharedOptions, serialDiluteSourceIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentAliquot -- except for the funtopia shared options (Cache, Upload, etc.) *)
  serialDiluteSharedOptions = UnsortedComplement[
    Options[ExperimentSerialDilute][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  serialDiluteNonIndexMatchingSharedOptions = UnsortedComplement[
    serialDiluteSharedOptions,
    Cases[OptionDefinition[ExperimentSerialDilute], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  serialDiluteSourceIndexMatchingSharedOptions = UnsortedComplement[
    serialDiluteSharedOptions,
    serialDiluteNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[SerialDilute,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Source,
          Default -> Null,
          Description -> "The samples that should be serially diluted.",
          AllowNull -> False,
          Category -> "General",
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
            "Model Sample" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Source
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      (* options index matched to Source *)
      IndexMatching[
        Sequence @@ ({ExperimentSerialDilute, Symbol[#]}&) /@ serialDiluteSourceIndexMatchingSharedOptions,
        IndexMatchingParent -> Source
      ],
      If[Length[serialDiluteNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentSerialDilute, Symbol[#]}&) /@ serialDiluteNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, RoboticCellPreparation},
    WorkCells -> {STAR,bioSTAR,microbioSTAR},
    ExperimentFunction -> ExperimentSerialDilute,
    MethodResolverFunction -> resolveSerialDiluteMethod,
    WorkCellResolverFunction -> resolveSerialDiluteWorkCell,

    (*note that we don't necessarily need these functions because they get called for the constituent RoboticUnitOperations.  However, we could have the parsers at least if we also want to populate fields in the corresponding unit operations *)
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "AliquotIcon.png"}]],
    LabeledOptions -> {Source -> SourceLabel, ContainerOut -> ContainerOutLabel, Diluent -> DiluentLabel, ConcentratedBuffer -> ConcentratedBufferLabel, BufferDiluent -> BufferDiluentLabel},
    InputOptions -> {Source},
    (* NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped *)
    (* if the primitive is fed back into the ExperimentBLAH function. *)
    CompletedOptions -> {
      EnvironmentalData, Source
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Transfers an amount of sample into a container and dilutes it with buffers as specified.",
    Author -> {"daniel.shlian", "tyler.pabst"}
  ]
];



(* ::Subsection::Closed:: *)
(*PCR Primitive*)


(* ::Code::Initialization:: *)
pcrPrimitive=Module[
  {pcrSharedOptions,pcrNonIndexMatchingSharedOptions,pcrIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentPCR -- except for the funtopia shared options (Cache, Upload, etc.) *)
  pcrSharedOptions=UnsortedComplement[
    Options[ExperimentPCR][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  pcrNonIndexMatchingSharedOptions=UnsortedComplement[
    pcrSharedOptions,
    Cases[OptionDefinition[ExperimentPCR],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  pcrIndexMatchingSharedOptions=UnsortedComplement[
    pcrSharedOptions,
    pcrNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[PCR,
    (* Input Options *)
    Options:>{
      IndexMatching[
        IndexMatchingParent->Sample,
        {
          OptionName->Sample,
          Default->Null,
          Description->"The sample containing the nucleic acid template for amplification.",
          AllowNull->True,
          Category->"General",
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
          Required->True
        },
        {
          OptionName->PrimerPair,
          Default->Null,
          Description->"The sample containing pair(s) of oligomer strands designed to bind to the template and serve as anchors for the polymerase.",
          AllowNull->True,
          Category->"General",
          Widget->Alternatives[
            Adder[{
              "Forward Primer"->Alternatives[
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
              "Reverse Primer"->Alternatives[
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
              ]
            }],
            Widget[Type->Enumeration,Pattern:>Alternatives[{{Null,Null}}]]
          ]
        }
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentPCR,Symbol[#]}&)/@pcrIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[pcrNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentPCR,Symbol[#]}&)/@pcrNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    Methods->{ManualSamplePreparation, ManualCellPreparation,RoboticCellPreparation},
    WorkCells->{bioSTAR,microbioSTAR},
    ExperimentFunction->ExperimentPCR,
    MethodResolverFunction->Experiment`Private`resolveExperimentPCRMethod,
    WorkCellResolverFunction->Experiment`Private`resolveExperimentPCRWorkCell,
    RoboticExporterFunction->InternalExperiment`Private`exportPCRRoboticPrimitive,
    RoboticParserFunction->InternalExperiment`Private`parsePCRRoboticPrimitive,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parsePCROutputUnitOperation,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","PCRIcon.png"}]],
    InputOptions->{Sample,PrimerPair},
    LabeledOptions->{
      Sample->SampleLabel,
      PrimerPair->PrimerPairLabel,
      Buffer->BufferLabel,
      MasterMix->MasterMixLabel,
      AssayPlate->AssayPlateLabel
    },
    Generative->True,
    Category->"Sample Preparation",
    Description->"Amplifies target sequences from nucleic acid samples.",
    Author -> {"tyler.pabst", "daniel.shlian"}
  ]
];


(* ::Subsection::Closed:: *)
(*FlowCytometry Primitive*)


(* ::Code::Initialization:: *)
flowCytometryPrimitive = Module[
  {flowCytometrySharedOptions, flowCytometryNonIndexMatchingSharedOptions,
  flowCytometryIndexMatchingSharedOptions,flowCytometryIndexMatchingSampleSharedOptions,flowCytometryIndexMatchingDetectorSharedOptions,
  flowCytometryIndexMatchingExcitationWavelengthSharedOptions,flowCytometryIndexMatchingBlankSharedOptions},
  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  flowCytometrySharedOptions =UnsortedComplement[
    Options[ExperimentFlowCytometry][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  flowCytometryNonIndexMatchingSharedOptions=UnsortedComplement[
    flowCytometrySharedOptions,
    Cases[OptionDefinition[ExperimentFlowCytometry], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  flowCytometryIndexMatchingDetectorSharedOptions=Cases[
    OptionDefinition[ExperimentFlowCytometry],
    KeyValuePattern["IndexMatching" -> "Detector"]
  ][[All, "OptionName"]];

  flowCytometryIndexMatchingExcitationWavelengthSharedOptions=Cases[
    OptionDefinition[ExperimentFlowCytometry],
    KeyValuePattern["IndexMatching" -> "ExcitationWavelength"]
  ][[All, "OptionName"]];

  flowCytometryIndexMatchingBlankSharedOptions=Cases[
    OptionDefinition[ExperimentFlowCytometry],
    KeyValuePattern["IndexMatching" -> "Blank"]
  ][[All, "OptionName"]];

  flowCytometryIndexMatchingSampleSharedOptions=UnsortedComplement[
    flowCytometrySharedOptions,
    Join[flowCytometryNonIndexMatchingSharedOptions,flowCytometryIndexMatchingDetectorSharedOptions,flowCytometryIndexMatchingExcitationWavelengthSharedOptions,flowCytometryIndexMatchingBlankSharedOptions]
  ];

  DefinePrimitive[FlowCytometry,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be analysed with the flow cytometer.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentFlowCytometry, Symbol[#]}&) /@ flowCytometryIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      IndexMatching[
        Sequence @@ ({ExperimentFlowCytometry, Symbol[#]}&) /@ flowCytometryIndexMatchingDetectorSharedOptions,
        IndexMatchingParent -> Detector
      ],
      IndexMatching[
        Sequence @@ ({ExperimentFlowCytometry, Symbol[#]}&) /@ flowCytometryIndexMatchingExcitationWavelengthSharedOptions,
        IndexMatchingParent -> ExcitationWavelength
      ],
      IndexMatching[
        Sequence @@ ({ExperimentFlowCytometry, Symbol[#]}&) /@ flowCytometryIndexMatchingBlankSharedOptions,
        IndexMatchingParent -> Blank
      ],
      If[Length[flowCytometryNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentFlowCytometry, Symbol[#]}&) /@ flowCytometryNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentFlowCytometry,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseFlowCytometryOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveFlowCytometryMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FlowCytometry.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Flows a sample through a flow cytometer.",
    Methods -> {ManualCellPreparation},
    Author -> "taylor.hochuli"
  ]
];



(* ::Subsection::Closed:: *)
(* MeasureRefractiveIndex Primitive *)


(* ::Code::Initialization:: *)
measureRefractiveIndexPrimitive = Module[
  {measureRefractiveIndexSharedOptions, measureRefractiveIndexNonIndexMatchingSharedOptions,measureRefractiveIndexIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentMeasureRefractiveIndex -- except for the funtopia shared options (Cache, Upload, etc.) *)
  measureRefractiveIndexSharedOptions = UnsortedComplement[
    Options[ExperimentMeasureRefractiveIndex][[All,1]],
    Flatten[{Options[ProtocolOptions][[All,1]], $NonUnitOperationSharedOptions}]
  ];

  measureRefractiveIndexNonIndexMatchingSharedOptions = UnsortedComplement[
    measureRefractiveIndexSharedOptions,
    Cases[OptionDefinition[ExperimentMeasureRefractiveIndex], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  measureRefractiveIndexIndexMatchingSharedOptions = UnsortedComplement[
    measureRefractiveIndexSharedOptions,
    measureRefractiveIndexNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MeasureRefractiveIndex,
    (* Input Options*)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be measured with the refractometer.",
          AllowNull -> False,
          Category -> "General",
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
                  PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options*)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentMeasureRefractiveIndex, Symbol[#]}&) /@ measureRefractiveIndexIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[measureRefractiveIndexNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentMeasureRefractiveIndex, Symbol[#]}&) /@ measureRefractiveIndexNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentMeasureRefractiveIndex,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseMeasureRefractiveIndexOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveExperimentMeasureRefractiveIndexMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MeasureRefractiveIndex.png"}]],
    LabeledOptions -> {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Measure the refractive index of sample.",
    Methods -> {ManualSamplePreparation},
    Author -> {"jireh.sacramento", "xu.yi"}
  ]
];


(* ::Subsection::*)
(*ExperimentMeasureContactAngle Primitive*)
measureContactAnglePrimitive = Module[{measureContactAngleSharedOptions, measureContactAngleNonIndexMatchingOptions, measureContactAngleIndexMatchingSharedOptions},
  (*Copy over all of the options from ExperimentMeasureContactAngle-- except for the funtopia shared options (Cache,Upload,etc.)*)
  measureContactAngleSharedOptions = UnsortedComplement[
    Options[ExperimentMeasureContactAngle][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  measureContactAngleNonIndexMatchingOptions = UnsortedComplement[
    measureContactAngleSharedOptions,
    Cases[OptionDefinition[ExperimentMeasureContactAngle], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  measureContactAngleIndexMatchingSharedOptions = UnsortedComplement[
    measureContactAngleSharedOptions,
    measureContactAngleNonIndexMatchingOptions
  ];

  DefinePrimitive[MeasureContactAngle,
    (*Input Options*)

    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"The samples that should be measured with the single fiber tensiometer.",
          AllowNull->False,
          Category->"General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item,WilhelmyPlate]}],
            ObjectTypes->{Object[Sample],Object[Container],Object[Item,WilhelmyPlate]},
            Dereference->{
              Object[Container]->Field[Contents[[All,2]]]
            }
          ],
          Required->True
        },
        {
          OptionName->WettingLiquids,
          Default->Null,
          Description->"The liquid samples that are contacted by the solid samples in order to measure the contact angle between them.",
          AllowNull->False,
          Category->"General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],
            ObjectTypes->{Model[Sample],Object[Sample],Object[Container]},
            Dereference->{
              Object[Container]->Field[Contents[[All,2]]]
            }
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (*Shared Options*)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentMeasureContactAngle,Symbol[#]} &)/@measureContactAngleIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[measureContactAngleNonIndexMatchingOptions]==0,
        Nothing,
        Sequence@@({ExperimentMeasureContactAngle,Symbol[#]} &)/@measureContactAngleNonIndexMatchingOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],

    Methods->{ManualSamplePreparation},
    ExperimentFunction->ExperimentMeasureContactAngle,
    MethodResolverFunction->Experiment`Private`resolveExperimentMeasureContactAngleMethod,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseMeasureContactAngleOutputUnitOperation,

    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MeasureContactAngle.png"}]],
    LabeledOptions->{Sample->SampleLabel,WettingLiquids->WettingLiquidLabel},
    InputOptions->{Sample,WettingLiquids},
    (*NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped
	  if the primitive is fed back into the ExperimentBLAH function.*)
    Generative->False,
    Category->"Property Measurement",
    Description->"Measure the contact angle between fiber and wetting liquid.",
    Author->{"jireh.sacramento", "alou"}
  ]
];


(* ::Subsection::*)
(*ExperimentVisualInspection Primitive*)
visualInspectionPrimitive = Module[{visualInspectionSharedOptions, visualInspectionNonIndexMatchingOptions, visualInspectionIndexMatchingSharedOptions},
  (*Copy over all of the options from ExperimentVisualInspection-- except for the funtopia shared options (Cache,Upload,etc.)*)
  visualInspectionSharedOptions = UnsortedComplement[
    Options[ExperimentVisualInspection][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  visualInspectionNonIndexMatchingOptions = UnsortedComplement[
    visualInspectionSharedOptions,
    Cases[OptionDefinition[ExperimentVisualInspection], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  visualInspectionIndexMatchingSharedOptions = UnsortedComplement[
    visualInspectionSharedOptions,
    visualInspectionNonIndexMatchingOptions
  ];

  DefinePrimitive[VisualInspection,
    (*Input Options*)

    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be adjusted to a specified pH.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            (* TODO confirm "Container with Well Position" works *)
            "Model Sample" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (*Shared Options*)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentVisualInspection, Symbol[#]} &) /@ visualInspectionIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[visualInspectionNonIndexMatchingOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentVisualInspection, Symbol[#]} &) /@ visualInspectionNonIndexMatchingOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualSamplePreparation, ManualCellPreparation},
    ExperimentFunction -> ExperimentVisualInspection,
    MethodResolverFunction -> Experiment`Private`resolveVisualInspectionMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseAdjustpHOutputUnitOperation,

    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "VisualInspection.png"}]],
    LabeledOptions -> {Sample -> SampleLabel},
    InputOptions -> {Sample},
    (*NOTE: These are the options that will be added to the CompletedPrimitives field in the parse and should be stripped
      if the primitive is fed back into the ExperimentBLAH function.*)
    Generative -> False,
    Category -> "Property Measurement",
    Description -> "Records a video of a sample container as it is agitated on a shaker/vortex.",
    Author -> {"dima"}
  ]
];


(* ::Subsection::Closed:: *)
(*ReadPlate Experiment Primitives*)


(* ::Code::Initialization:: *)
plateReaderPrimitiveTypes = {
  (* Absorbance *)
  AbsorbanceSpectroscopy,
  AbsorbanceIntensity,
  AbsorbanceKinetics,
  (* Luminescence *)
  LuminescenceSpectroscopy,
  LuminescenceIntensity,
  LuminescenceKinetics,
  (* Fluorescence *)
  FluorescenceSpectroscopy,
  FluorescenceIntensity,
  FluorescenceKinetics,
  FluorescencePolarization,
  FluorescencePolarizationKinetics,
  (* AlphaScreen *)
  AlphaScreen,
  (* Nephelometry *)
  Nephelometry,
  NephelometryKinetics
};

plateReaderPrimitiveP = Alternatives@@(Blank/@plateReaderPrimitiveTypes);

qpixPrimitiveTypes = {
  PickColonies,
  InoculateLiquidMedia,
  SpreadCells,
  StreakCells,
  ImageColonies,
  QuantifyColonies
};

qpixPrimitiveP = Alternatives@@(Blank/@qpixPrimitiveTypes);

(* The maximum number of injection samples that each plate reader can hold. *)
$MaxPlateReaderInjectionSamples=2;

(* == NOTE: CLARIOstar (can be reached by STAR/bioSTAR/microSTAR) experiments: == *)
(* AbsorbanceSpectroscopy, AbsorbanceIntensity, AbsorbanceKinetics *)
(* LuminescenceSpectroscopy, LuminescenceIntensity, LuminescenceKinetics *)
(* FluorescenceSpectroscopy, FluorescenceIntensity, FluorescenceKinetics *)
(* AlphaScreen *)

(* == NOTE: Omega (can be reached by STAR) experiments: == *)
(* AbsorbanceSpectroscopy, AbsorbanceIntensity, AbsorbanceKinetics *)
(* LuminescenceIntensity, LuminescenceKinetics *)
(* FluorescenceIntensity, FluorescenceKinetics *)

(* == NOTE: NEPHELOstar (can be reached by bioSTAR/microSTAR) experiments: == *)
(* Nephelometry, NephelometryKinetics *)

(* == NOTE: PHERAstar (can be reached by manual preparation) experiments: == *)
(* FluorescencePolarization, FluorescencePolarizationKinetics *)

(* Plate Reader Primitive Definitions *)
{
  absorbanceSpectroscopyPrimitive,
  absorbanceIntensityPrimitive,
  absorbanceKineticsPrimitive,
  luminescenceSpectroscopyPrimitive,
  luminescenceIntensityPrimitive,
  luminescenceKineticsPrimitive,
  fluorescenceSpectroscopyPrimitive,
  fluorescenceIntensityPrimitive,
  fluorescenceKineticsPrimitive,
  fluorescencePolarizationPrimitive,
  fluorescencePolarizationKineticsPrimitive,
  alphaScreenPrimitive,
  nephelometryPrimitive,
  nephelometryKineticsPrimitive
}=Module[
  {absorbanceSpectroscopySharedOptions, absorbanceIntensitySharedOptions, absorbanceKineticsSharedOptions,
  luminescenceSpectroscopySharedOptions, luminescenceIntensitySharedOptions, luminescenceKineticsSharedOptions,
  fluorescenceSpectroscopySharedOptions, fluorescenceIntensitySharedOptions, fluorescenceKineticsSharedOptions,
  fluorescencePolarizationSharedOptions, fluorescencePolarizationKineticsSharedOptions, alphaScreenSharedOptions,
  nephelometrySharedOptions, nephelometryKineticsSharedOptions, absorbanceSpectroscopyNonIndexMatchingSharedOptions,
  absorbanceIntensityNonIndexMatchingSharedOptions, absorbanceKineticsNonIndexMatchingSharedOptions,
  luminescenceSpectroscopyNonIndexMatchingSharedOptions, luminescenceIntensityNonIndexMatchingSharedOptions,
  luminescenceKineticsNonIndexMatchingSharedOptions, fluorescenceSpectroscopyNonIndexMatchingSharedOptions,
  fluorescenceIntensityNonIndexMatchingSharedOptions, fluorescenceKineticsNonIndexMatchingSharedOptions,
  fluorescencePolarizationNonIndexMatchingSharedOptions, fluorescencePolarizationKineticsNonIndexMatchingSharedOptions,
  alphaScreenNonIndexMatchingSharedOptions, nephelometryNonIndexMatchingSharedOptions,
  nephelometryKineticsNonIndexMatchingSharedOptions, absorbanceSpectroscopyIndexMatchingSharedOptions,
  absorbanceIntensityIndexMatchingSharedOptions, absorbanceKineticsIndexMatchingSharedOptions,
  luminescenceSpectroscopyIndexMatchingSharedOptions, luminescenceIntensityIndexMatchingSharedOptions,
  luminescenceKineticsIndexMatchingSharedOptions, fluorescenceSpectroscopyIndexMatchingSharedOptions,
  fluorescenceIntensityIndexMatchingSharedOptions, fluorescenceKineticsIndexMatchingSharedOptions,
  fluorescencePolarizationIndexMatchingSharedOptions, fluorescencePolarizationKineticsIndexMatchingSharedOptions,
  alphaScreenIndexMatchingSharedOptions, nephelometryIndexMatchingSharedOptions, nephelometryKineticsIndexMatchingSharedOptions},

  (* Copy over all of the options from the experiment itself -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  (* -- SharedOptions -- *)
  {
    (* Absorbance *)
    absorbanceSpectroscopySharedOptions,
    absorbanceIntensitySharedOptions,
    absorbanceKineticsSharedOptions,

    (* Luminescence *)
    luminescenceSpectroscopySharedOptions,
    luminescenceIntensitySharedOptions,
    luminescenceKineticsSharedOptions,

    (* Fluorescence *)
    fluorescenceSpectroscopySharedOptions,
    fluorescenceIntensitySharedOptions,
    fluorescenceKineticsSharedOptions,
    fluorescencePolarizationSharedOptions,
    fluorescencePolarizationKineticsSharedOptions,

    (* AlphaScreen *)
    alphaScreenSharedOptions,

    (* Nephelometry *)
    nephelometrySharedOptions,
    nephelometryKineticsSharedOptions
  } = Map[
    UnsortedComplement[
      Options[#][[All, 1]],
      Complement[
        Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}],
        (* NOTE: We DO want to copy over the aliquot options for manual experiments. *)
        Options[AliquotOptions][[All, 1]]
      ]
    ]&,
    {
      (* Absorbance *)
      ExperimentAbsorbanceSpectroscopy,
      ExperimentAbsorbanceIntensity,
      ExperimentAbsorbanceKinetics,

      (* Luminescence *)
      ExperimentLuminescenceSpectroscopy,
      ExperimentLuminescenceIntensity,
      ExperimentLuminescenceKinetics,

      (* Fluorescence *)
      ExperimentFluorescenceSpectroscopy,
      ExperimentFluorescenceIntensity,
      ExperimentFluorescenceKinetics,
      ExperimentFluorescencePolarization,
      ExperimentFluorescencePolarizationKinetics,

      (* AlphaScreen *)
      ExperimentAlphaScreen,

      (* Nephelometry *)
      ExperimentNephelometry,
      ExperimentNephelometryKinetics
    }
  ];

  (* -- NonIndexMatchingSharedOptions -- *)
  {
    (* Absorbance *)
    absorbanceSpectroscopyNonIndexMatchingSharedOptions,
    absorbanceIntensityNonIndexMatchingSharedOptions,
    absorbanceKineticsNonIndexMatchingSharedOptions,

    (* Luminescence *)
    luminescenceSpectroscopyNonIndexMatchingSharedOptions,
    luminescenceIntensityNonIndexMatchingSharedOptions,
    luminescenceKineticsNonIndexMatchingSharedOptions,

    (* Fluorescence *)
    fluorescenceSpectroscopyNonIndexMatchingSharedOptions,
    fluorescenceIntensityNonIndexMatchingSharedOptions,
    fluorescenceKineticsNonIndexMatchingSharedOptions,
    fluorescencePolarizationNonIndexMatchingSharedOptions,
    fluorescencePolarizationKineticsNonIndexMatchingSharedOptions,

    (* AlphaScreen *)
    alphaScreenNonIndexMatchingSharedOptions,

    (* Nephelometry *)
    nephelometryNonIndexMatchingSharedOptions,
    nephelometryKineticsNonIndexMatchingSharedOptions
  } = MapThread[
    UnsortedComplement[
      #1,
      Cases[OptionDefinition[#2], KeyValuePattern["IndexMatchingInput" -> Except[Null]]][[All, "OptionName"]]
    ]&,
    {
      (* SharedOptions *)
      {
        (* Absorbance *)
        absorbanceSpectroscopySharedOptions,
        absorbanceIntensitySharedOptions,
        absorbanceKineticsSharedOptions,

        (* Luminescence *)
        luminescenceSpectroscopySharedOptions,
        luminescenceIntensitySharedOptions,
        luminescenceKineticsSharedOptions,

        (* Fluorescence *)
        fluorescenceSpectroscopySharedOptions,
        fluorescenceIntensitySharedOptions,
        fluorescenceKineticsSharedOptions,
        fluorescencePolarizationSharedOptions,
        fluorescencePolarizationKineticsSharedOptions,

        (* AlphaScreen *)
        alphaScreenSharedOptions,

        (* Nephelometry *)
        nephelometrySharedOptions,
        nephelometryKineticsSharedOptions

      },
      (* ExperimentFunctions *)
      {
        (* Absorbance *)
        ExperimentAbsorbanceSpectroscopy,
        ExperimentAbsorbanceIntensity,
        ExperimentAbsorbanceKinetics,

        (* Luminescence *)
        ExperimentLuminescenceSpectroscopy,
        ExperimentLuminescenceIntensity,
        ExperimentLuminescenceKinetics,

        (* Fluorescence *)
        ExperimentFluorescenceSpectroscopy,
        ExperimentFluorescenceIntensity,
        ExperimentFluorescenceKinetics,
        ExperimentFluorescencePolarization,
        ExperimentFluorescencePolarizationKinetics,

        (* AlphaScreen *)
        ExperimentAlphaScreen,

        (* Nephelometry *)
        ExperimentNephelometry,
        ExperimentNephelometryKinetics
      }
    }
  ];

  (* -- IndexMatchingSharedOptions -- *)
  {
    (* Absorbance *)
    absorbanceSpectroscopyIndexMatchingSharedOptions,
    absorbanceIntensityIndexMatchingSharedOptions,
    absorbanceKineticsIndexMatchingSharedOptions,

    (* Luminescence *)
    luminescenceSpectroscopyIndexMatchingSharedOptions,
    luminescenceIntensityIndexMatchingSharedOptions,
    luminescenceKineticsIndexMatchingSharedOptions,

    (* Fluorescence *)
    fluorescenceSpectroscopyIndexMatchingSharedOptions,
    fluorescenceIntensityIndexMatchingSharedOptions,
    fluorescenceKineticsIndexMatchingSharedOptions,
    fluorescencePolarizationIndexMatchingSharedOptions,
    fluorescencePolarizationKineticsIndexMatchingSharedOptions,

    (* AlphaScreen *)
    alphaScreenIndexMatchingSharedOptions,

    (* Nephelometry *)
    nephelometryIndexMatchingSharedOptions,
    nephelometryKineticsIndexMatchingSharedOptions
  } = MapThread[
    UnsortedComplement[
      #1,
      #2
    ]&,
    {
      (* SharedOptions *)
      {
        (* Absorbance *)
        absorbanceSpectroscopySharedOptions,
        absorbanceIntensitySharedOptions,
        absorbanceKineticsSharedOptions,

        (* Luminescence *)
        luminescenceSpectroscopySharedOptions,
        luminescenceIntensitySharedOptions,
        luminescenceKineticsSharedOptions,

        (* Fluorescence *)
        fluorescenceSpectroscopySharedOptions,
        fluorescenceIntensitySharedOptions,
        fluorescenceKineticsSharedOptions,
        fluorescencePolarizationSharedOptions,
        fluorescencePolarizationKineticsSharedOptions,

        (* AlphaScreen *)
        alphaScreenSharedOptions,

        (* Nephelometry *)
        nephelometrySharedOptions,
        nephelometryKineticsSharedOptions

      },
      (* NonIndexMatchingSharedOptions *)
      {
        (* Absorbance *)
        absorbanceSpectroscopyNonIndexMatchingSharedOptions,
        absorbanceIntensityNonIndexMatchingSharedOptions,
        absorbanceKineticsNonIndexMatchingSharedOptions,

        (* Luminescence *)
        luminescenceSpectroscopyNonIndexMatchingSharedOptions,
        luminescenceIntensityNonIndexMatchingSharedOptions,
        luminescenceKineticsNonIndexMatchingSharedOptions,

        (* Fluorescence *)
        fluorescenceSpectroscopyNonIndexMatchingSharedOptions,
        fluorescenceIntensityNonIndexMatchingSharedOptions,
        fluorescenceKineticsNonIndexMatchingSharedOptions,
        fluorescencePolarizationNonIndexMatchingSharedOptions,
        fluorescencePolarizationKineticsNonIndexMatchingSharedOptions,

        (* AlphaScreen *)
        alphaScreenNonIndexMatchingSharedOptions,

        (* Nephelometry *)
        nephelometryNonIndexMatchingSharedOptions,
        nephelometryKineticsNonIndexMatchingSharedOptions
      }
    }
  ];

  MapThread[
    Function[
      {primitiveName, author, experimentName, indexMatchingSharedOptions, nonIndexMatchingSharedOptions, iconFile, description},
      DefinePrimitive[primitiveName,
        (* Input Options *)
        Options :> {
          IndexMatching[
            {
              OptionName -> Sample,
              Default -> Null,
              Description -> "The samples that will be measured by the plate reader instrument.",
              AllowNull -> True,
              Category -> "General",
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
              Required -> True
            },
            IndexMatchingParent -> Sample
          ]
        },
        (* Shared Options *)
        With[{insertMe =
            {
              IndexMatching[
                Sequence @@ ({experimentName, Symbol[#]}&) /@ indexMatchingSharedOptions,
                IndexMatchingParent -> Sample
              ],
              If[Length[nonIndexMatchingSharedOptions]==0,
                Nothing,
                Sequence @@ ({experimentName, Symbol[#]}&) /@ nonIndexMatchingSharedOptions
              ]
            }
        },
          SharedOptions :> insertMe
        ],
        Methods->If[
            MatchQ[primitiveName,Nephelometry|NephelometryKinetics],
              {ManualCellPreparation,RoboticCellPreparation},
              {ManualSamplePreparation,RoboticSamplePreparation,ManualCellPreparation,RoboticCellPreparation}],
        WorkCells->{STAR,bioSTAR,microbioSTAR},
        ExperimentFunction->experimentName,
        MethodResolverFunction->Experiment`Private`resolveReadPlateMethod,
        WorkCellResolverFunction->Experiment`Private`resolveReadPlateWorkCell,
        RoboticExporterFunction->InternalExperiment`Private`exportReadPlateRoboticPrimitive,
        RoboticParserFunction->InternalExperiment`Private`parseReadPlateRoboticPrimitive,
        OutputUnitOperationParserFunction->InternalExperiment`Private`parseReadPlateOutputUnitOperation,
        Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", iconFile}]],
        LabeledOptions -> {Sample -> SampleLabel},
        InputOptions -> {Sample},
        Generative -> False,
        Category -> "Sample Preparation",
        Description -> description,
        Author -> author
      ]
    ],
    {
      (* Defined Primitive Name *)
      {
        (* Absorbance *)
        AbsorbanceSpectroscopy,
        AbsorbanceIntensity,
        AbsorbanceKinetics,
        (* Luminescence *)
        LuminescenceSpectroscopy,
        LuminescenceIntensity,
        LuminescenceKinetics,
        (* Fluorescence *)
        FluorescenceSpectroscopy,
        FluorescenceIntensity,
        FluorescenceKinetics,
        FluorescencePolarization,
        FluorescencePolarizationKinetics,
        (* AlphaScreen *)
        AlphaScreen,
        (* Nephelometry *)
        Nephelometry,
        NephelometryKinetics
      },

      (* Authors *)
      {
        (* Absorbance *)
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        (* Luminescence *)
        {"ben"},
        {"yanzhe.zhu"},
        {"ben"},
        (* Fluorescence*)
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"},
        (* AlphaScreen *)
        {"jireh.sacramento", "alou"},
        (* Nephelometry *)
        {"jireh.sacramento", "alou"},
        {"jireh.sacramento", "alou"}
      },

      (* Experiment Symbol *)
      {
        (* Absorbance *)
        ExperimentAbsorbanceSpectroscopy,
        ExperimentAbsorbanceIntensity,
        ExperimentAbsorbanceKinetics,
        (* Luminescence *)
        ExperimentLuminescenceSpectroscopy,
        ExperimentLuminescenceIntensity,
        ExperimentLuminescenceKinetics,
        (* Fluorescence *)
        ExperimentFluorescenceSpectroscopy,
        ExperimentFluorescenceIntensity,
        ExperimentFluorescenceKinetics,
        ExperimentFluorescencePolarization,
        ExperimentFluorescencePolarizationKinetics,
        (* AlphaScreen *)
        ExperimentAlphaScreen,
        (* Nephelometry *)
        ExperimentNephelometry,
        ExperimentNephelometryKinetics
      },

      (* IndexMatchingSharedOptions *)
      {
        (* Absorbance *)
        absorbanceSpectroscopyIndexMatchingSharedOptions,
        absorbanceIntensityIndexMatchingSharedOptions,
        absorbanceKineticsIndexMatchingSharedOptions,
        (* Luminescence *)
        luminescenceSpectroscopyIndexMatchingSharedOptions,
        luminescenceIntensityIndexMatchingSharedOptions,
        luminescenceKineticsIndexMatchingSharedOptions,
        (* Fluorescence *)
        fluorescenceSpectroscopyIndexMatchingSharedOptions,
        fluorescenceIntensityIndexMatchingSharedOptions,
        fluorescenceKineticsIndexMatchingSharedOptions,
        fluorescencePolarizationIndexMatchingSharedOptions,
        fluorescencePolarizationKineticsIndexMatchingSharedOptions,
        (* AlphaScreen *)
        alphaScreenIndexMatchingSharedOptions,
        (* Nephelometry *)
        nephelometryIndexMatchingSharedOptions,
        nephelometryKineticsIndexMatchingSharedOptions
      },

      (* NonIndexMatchingSharedOptions *)
      {
        (* Absorbance *)
        absorbanceSpectroscopyNonIndexMatchingSharedOptions,
        absorbanceIntensityNonIndexMatchingSharedOptions,
        absorbanceKineticsNonIndexMatchingSharedOptions,
        (* Luminescence *)
        luminescenceSpectroscopyNonIndexMatchingSharedOptions,
        luminescenceIntensityNonIndexMatchingSharedOptions,
        luminescenceKineticsNonIndexMatchingSharedOptions,
        (* Fluorescence *)
        fluorescenceSpectroscopyNonIndexMatchingSharedOptions,
        fluorescenceIntensityNonIndexMatchingSharedOptions,
        fluorescenceKineticsNonIndexMatchingSharedOptions,
        fluorescencePolarizationNonIndexMatchingSharedOptions,
        fluorescencePolarizationKineticsNonIndexMatchingSharedOptions,
        (* AlphaScreen *)
        alphaScreenNonIndexMatchingSharedOptions,
        (* Nephelometry *)
        nephelometryNonIndexMatchingSharedOptions,
        nephelometryKineticsNonIndexMatchingSharedOptions
      },

      (* Icon File Name *)
      {
        (* Absorbance *)
        "PlateReader-Absorbance.png",
        "PlateReader-Absorbance.png",
        "PlateReader-Absorbance.png",
        (* Luminescence *)
        "PlateReader-Luminescence.png",
        "PlateReader-Luminescence.png",
        "PlateReader-Luminescence.png",
        (* Fluorescence *)
        "PlateReader-Luminescence.png",
        "PlateReader-Luminescence.png",
        "PlateReader-Luminescence.png",
        "PlateReader-Combined.png",
        "PlateReader-Combined.png",
        (* AlphaScreen *)
        "PlateReader-Luminescence.png",
        (* Nephelometry *)
        "PlateReader-Combined.png",
        "PlateReader-Combined.png"
      },

      (* Description *)
      {
        (* Absorbance *)
        "Measures the absorbance spectroscopy data of the input samples.",
        "Measures the absorbance intensity data of the input samples.",
        "Measures the absorbance kinetics data of the input samples.",
        (* Luminescence *)
        "Measures the luminescence spectroscopy data of the input samples.",
        "Measures the luminescence intensity data of the input samples.",
        "Measures the luminescence kinetics data of the input samples.",
        (* Fluorescence *)
        "Measures the fluorescence spectroscopy data of the input samples.",
        "Measures the fluorescence intensity data of the input samples.",
        "Measures the fluorescence kinetics data of the input samples.",
        "Measures the fluorescence polarization data of the input samples.",
        "Measures the fluorescence polarization kinetics data of the input samples.",
        (* AlphaScreen *)
        "Measures the alpha screen data of the input samples.",
        (* Nephelometry *)
        "Measures the nephelometry data of the input samples.",
        "Measures the nephelometry kinetics data of the input samples."
      }
    }
  ]
];



(* ::Subsection::Closed:: *)
(*Degas Primitive*)


(* ::Code::Initialization:: *)
degasPrimitive=Module[{degasSharedOptions,degasNonIndexMatchingSharedOptions,degasIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentDegas -- except for the protocol and simulation options (Cache, Upload, etc.) *)
  degasSharedOptions=UnsortedComplement[
    Options[ExperimentDegas][[All,1]],
    Flatten[{Options[NonBiologyFuntopiaSharedOptions][[All,1]],$NonUnitOperationSharedOptions}]
  ];

  (* get the non-index matching options *)
  degasNonIndexMatchingSharedOptions=UnsortedComplement[
    degasSharedOptions,
    Cases[OptionDefinition[ExperimentDegas],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  (* get the index matching options *)
  degasIndexMatchingSharedOptions=UnsortedComplement[
    degasSharedOptions,
    degasNonIndexMatchingSharedOptions
  ];

  (* create primitive definition *)
  DefinePrimitive[Degas,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"Input samples which will be imaged by a microscope.",
          AllowNull->True,
          Pooled->True,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "Container with Well Position"->{
              "Well Position"->Widget[
                Type->String,
                Pattern:>WellPositionP,
                Size->Line,
                PatternTooltip->"Enumeration must be any well from A1 to P24."
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentDegas,Symbol[#]}&)/@degasIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[degasNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentDegas,Symbol[#]}&)/@degasNonIndexMatchingSharedOptions
      ]
    }},
      SharedOptions:>insertMe
    ],
    Methods->{ManualSamplePreparation},
    ExperimentFunction->ExperimentDegas,
    MethodResolverFunction->resolveDegasMethod,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseDegasOutputUnitOperation,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","Degas.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Sample Preparation",
    Description->"Remove dissolved gases from the samples.",
    Author -> {"lige.tonggu"}
  ]
];


(* ::Subsection::Closed:: *)
(*ImageCells Primitive*)


(* ::Code::Initialization:: *)
imageCellsPrimitive=Module[{imageCellsSharedOptions,imageCellsNonIndexMatchingSharedOptions,imageCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentImageCells -- except for the protocol and simulation options (Cache, Upload, etc.) *)
  imageCellsSharedOptions=UnsortedComplement[
    Options[ExperimentImageCells][[All,1]],
    Flatten[{Options[NonBiologyFuntopiaSharedOptions][[All,1]],$NonUnitOperationSharedOptions}]
  ];

  (* get the non-index matching options *)
  imageCellsNonIndexMatchingSharedOptions=UnsortedComplement[
    imageCellsSharedOptions,
    Cases[OptionDefinition[ExperimentImageCells],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  (* get the index matching options *)
  imageCellsIndexMatchingSharedOptions=UnsortedComplement[
    imageCellsSharedOptions,
    imageCellsNonIndexMatchingSharedOptions
  ];

  (* create primitive definition *)
  DefinePrimitive[ImageCells,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"Input samples which will be imaged by a microscope.",
          AllowNull->True,
          NestedIndexMatching->True,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "Container with Well Position"->{
              "Well Position"->Widget[
                Type->String,
                Pattern:>WellPositionP,
                Size->Line,
                PatternTooltip->"Enumeration must be any well from A1 to P24."
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Container]}]
              ],
              "Model Sample"->Widget[
                Type -> Object,
                Pattern :> ObjectP[Model[Sample]],
                ObjectTypes -> {Model[Sample]}
              ]
            }
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentImageCells,Symbol[#]}&)/@imageCellsIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[imageCellsNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentImageCells,Symbol[#]}&)/@imageCellsNonIndexMatchingSharedOptions
      ]
    }},
      SharedOptions:>insertMe
    ],
    Methods->{RoboticCellPreparation,ManualCellPreparation},
    WorkCells->{bioSTAR,microbioSTAR},
    ExperimentFunction->ExperimentImageCells,
    RoboticExporterFunction->InternalExperiment`Private`exportImageCellsRoboticPrimitive,
    RoboticParserFunction->InternalExperiment`Private`parseImageCellsRoboticPrimitive,
    MethodResolverFunction->resolveImageCellsMethod,
    WorkCellResolverFunction->resolveImageCellsWorkCell,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseImageCellsOutputUnitOperation,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ImageCells.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Microscopy",
    Description->"Acquire microscopic images from the samples.",
    Author -> {"melanie.reschke", "yanzhe.zhu"}
  ]
];



(* ::Subsection::Closed:: *)
(*ThawCells Primitive*)


(* ::Code::Initialization:: *)
thawCellsPrimitive=Module[{thawCellsSharedOptions,thawCellsNonIndexMatchingSharedOptions,thawCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentThawCells -- except for the protocol and simulation options (Cache, Upload, etc.) *)
  thawCellsSharedOptions=UnsortedComplement[
    Options[ExperimentThawCells][[All,1]],
    Flatten[{Options[NonBiologyFuntopiaSharedOptions][[All,1]],$NonUnitOperationSharedOptions}]
  ];

  (* get the non-index matching options *)
  thawCellsNonIndexMatchingSharedOptions=UnsortedComplement[
    thawCellsSharedOptions,
    Cases[OptionDefinition[ExperimentThawCells],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  (* get the index matching options *)
  thawCellsIndexMatchingSharedOptions=UnsortedComplement[
    thawCellsSharedOptions,
    thawCellsNonIndexMatchingSharedOptions
  ];

  (* create primitive definition *)
  DefinePrimitive[ThawCells,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"Input samples which will be thawed.",
          AllowNull->True,
          NestedIndexMatching->False,
          Category->"General",
          Widget->Alternatives[
            "Sample Model"->Widget[
              Type->Object,
              Pattern:>ObjectP[Model[Sample]]
            ],
            "Existing Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "Container with Well Position"->{
              "Well Position"->Widget[
                Type->String,
                Pattern:>WellPositionP,
                Size->Line,
                PatternTooltip->"Enumeration must be any well from A1 to P24."
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentThawCells,Symbol[#]}&)/@thawCellsIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[thawCellsNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentThawCells,Symbol[#]}&)/@thawCellsNonIndexMatchingSharedOptions
      ]
    }},
      SharedOptions:>insertMe
    ],
    Methods->{RoboticCellPreparation,ManualCellPreparation},
    WorkCells->{bioSTAR, microbioSTAR},
    ExperimentFunction->ExperimentThawCells,
    RoboticExporterFunction->InternalExperiment`Private`exportThawCellsRoboticPrimitive,
    RoboticParserFunction->InternalExperiment`Private`parseThawCellsRoboticPrimitive,
    MethodResolverFunction->resolveThawCellsMethod,
    WorkCellResolverFunction->resolveThawCellsWorkCell,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseThawCellsOutputUnitOperation,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ThawCells.png"}]],
    LabeledOptions->{Sample->SampleLabel},
    InputOptions->{Sample},
    Generative->False,
    Category->"Cell Maintenance",
    Description->"Thaw a frozen vial of cells for use in downstream cell culturing.",
    Author -> "tyler.pabst"
  ]
];


(* ::Subsection::Closed:: *)
(*MagneticBeadSeparation Primitive*)


(* ::Code::Initialization:: *)
magneticBeadSeparationPrimitive=Module[
  {magneticBeadSeparationSharedOptions,magneticBeadSeparationNonIndexMatchingSharedOptions,magneticBeadSeparationIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentMagneticBeadSeparation -- except for the funtopia shared options (Cache, Upload, etc.) *)
  magneticBeadSeparationSharedOptions=UnsortedComplement[
    Options[ExperimentMagneticBeadSeparation][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  magneticBeadSeparationNonIndexMatchingSharedOptions=UnsortedComplement[
    magneticBeadSeparationSharedOptions,
    Cases[OptionDefinition[ExperimentMagneticBeadSeparation],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  magneticBeadSeparationIndexMatchingSharedOptions=UnsortedComplement[
    magneticBeadSeparationSharedOptions,
    magneticBeadSeparationNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MagneticBeadSeparation,
    (* Input Options *)
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"Input samples which will be isolated via magnetic bead separation.",
          AllowNull->True,
          NestedIndexMatching->True,
          Category->"General",
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
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentMagneticBeadSeparation,Symbol[#]}&)/@magneticBeadSeparationIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[magneticBeadSeparationNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentMagneticBeadSeparation,Symbol[#]}&)/@magneticBeadSeparationNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    Methods->{ManualSamplePreparation,RoboticSamplePreparation},
    WorkCells->{STAR,bioSTAR,microbioSTAR},
    ExperimentFunction->ExperimentMagneticBeadSeparation,
    MethodResolverFunction->Experiment`Private`resolveExperimentMagneticBeadSeparationMethod,
    WorkCellResolverFunction->Experiment`Private`resolveExperimentMagneticBeadSeparationWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseMagneticBeadSeparationRoboticPrimitive,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseMagneticBeadSeparationOutputUnitOperation,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MoveToMagnetIcon.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{
      Sample->SampleLabel,
      PreWashCollectionContainer->PreWashCollectionContainerLabel,
      EquilibrationCollectionContainer->EquilibrationCollectionContainerLabel,
      LoadingCollectionContainer->LoadingCollectionContainerLabel,
      WashCollectionContainer->WashCollectionContainerLabel,
      SecondaryWashCollectionContainer->SecondaryWashCollectionContainerLabel,
      TertiaryWashCollectionContainer->TertiaryWashCollectionContainerLabel,
      QuaternaryWashCollectionContainer->QuaternaryWashCollectionContainerLabel,
      QuinaryWashCollectionContainer->QuinaryWashCollectionContainerLabel,
      SenaryWashCollectionContainer->SenaryWashCollectionContainerLabel,
      SeptenaryWashCollectionContainer->SeptenaryWashCollectionContainerLabel,
      ElutionCollectionContainer->ElutionCollectionContainerLabel,
      Null->SampleContainerLabel,
      Null->SampleOutLabel,
      Null->ContainerOutLabel
    },
    Generative->True,
    GenerativeLabelOption->SampleOutLabel,
    Category->"Sample Preparation",
    Description->"Isolates targets from samples by using a magnetic field to separate superparamagnetic particles from suspensions.",
    Author -> {"tyler.pabst"}
  ]
];

(* ::Subsection:: *)
(*LiquidLiquidExtraction Primitive*)

liquidLiquidExtractionPrimitive=Module[
  {liquidLiquidExtractionSharedOptions,liquidLiquidExtractionNonIndexMatchingSharedOptions,liquidLiquidExtractionIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentLiquidLiquidExtraction -- except for the funtopia shared options (Cache, Upload, etc.) *)
  liquidLiquidExtractionSharedOptions=UnsortedComplement[
    Options[ExperimentLiquidLiquidExtraction][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  liquidLiquidExtractionNonIndexMatchingSharedOptions=UnsortedComplement[
    liquidLiquidExtractionSharedOptions,
    Cases[OptionDefinition[ExperimentLiquidLiquidExtraction],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  liquidLiquidExtractionIndexMatchingSharedOptions=UnsortedComplement[
    liquidLiquidExtractionSharedOptions,
    liquidLiquidExtractionNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[LiquidLiquidExtraction,
    (* Input Options *)
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          AllowNull->False,
          Description->"The samples that contain the target analyte to be isolated via liquid liquid extraction.",
          Category->"General",
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
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentLiquidLiquidExtraction,Symbol[#]}&)/@liquidLiquidExtractionIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[liquidLiquidExtractionNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentLiquidLiquidExtraction,Symbol[#]}&)/@liquidLiquidExtractionNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    Methods->{ManualSamplePreparation,RoboticSamplePreparation},
    WorkCells->{STAR,bioSTAR,microbioSTAR},
    ExperimentFunction->ExperimentLiquidLiquidExtraction,
    WorkCellResolverFunction->Experiment`Private`resolveLiquidLiquidExtractionWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","LiquidLiquidExtraction.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{
      Sample->SampleLabel,
      Null->SampleContainerLabel,
      Null->TargetLabel,
      Null->TargetContainerLabel,
      Null->ImpurityLabel,
      Null->ImpurityContainerLabel
    },
    Generative->True,
    GenerativeLabelOption->SampleOutLabel,
    Category->"Sample Preparation",
    Description->"Separates the aqueous and organic phases of given samples via pipette or phase separator, in order to isolate a target analyte that is more concentrated in either the aqueous or organic phase.",
    Author -> {"ben"}
  ]
];


(* ::Subsection:: *)
(*QuantifyCells Primitive*)


quantifyCellsPrimitive = Module[{quantifyCellsSharedOptions, quantifyCellsNonIndexMatchingSharedOptions, quantifyCellsIndexMatchingMethodsSharedOptions, quantifyCellsIndexMatchingSampleSharedOptions},
  (* Copy over all of the options from ExperimentQuantifyCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* These option names are strings *)
  quantifyCellsSharedOptions = UnsortedComplement[
    Options[ExperimentQuantifyCells][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  (* All the non index matching options *)
  quantifyCellsNonIndexMatchingSharedOptions = UnsortedComplement[
    quantifyCellsSharedOptions,
    Cases[OptionDefinition[ExperimentQuantifyCells], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  (* All the index matching options to Methods *)
  quantifyCellsIndexMatchingMethodsSharedOptions = Cases[OptionDefinition[ExperimentQuantifyCells], KeyValuePattern["IndexMatching" -> "Methods"]][[All, "OptionName"]];

  (* All the index matching options to experiment samples *)
  quantifyCellsIndexMatchingSampleSharedOptions = UnsortedComplement[
    quantifyCellsSharedOptions,
    Join[quantifyCellsNonIndexMatchingSharedOptions, quantifyCellsIndexMatchingMethodsSharedOptions]
  ];

  DefinePrimitive[QuantifyCells,
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The cell samples to be quantified.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                  PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
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
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentQuantifyCells, Symbol[#]}&) /@ quantifyCellsIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      IndexMatching[
        Sequence @@ ({ExperimentQuantifyCells, Symbol[#]}&) /@ quantifyCellsIndexMatchingMethodsSharedOptions,
        IndexMatchingParent -> Methods
      ],
      If[Length[quantifyCellsNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentQuantifyCells, Symbol[#]}&) /@ quantifyCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentQuantifyCells,
    Methods -> {ManualCellPreparation, RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR, microbioSTAR},
    MethodResolverFunction -> Experiment`Private`resolveQuantifyCellsMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveQuantifyCellsWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseQuantifyCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseQuantifyCellsOutputUnitOperation,
    (* We are not generating SamplesOut so Generative->False *)
    Generative -> False,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "QuantifyCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {Sample -> SampleLabel},
    Category -> "Property Measurement",
    Description -> "Measures the cell concentration in the provided 'Samples' with various methods. The methods that are currently supported include measuring the absorbance at 600 nm (OD600) of the 'Samples' with AbsorbanceIntensity measurement and measuring the turbidity of the 'Samples' with Nephelometry measurement.",
    Author -> {"lei.tian"}
  ]
];

(* ::Subsection:: *)
(*QuantifyColonies Primitive*)


quantifyColoniesPrimitive = Module[
  {
    quantifyColoniesSharedOptions, quantifyColoniesNonIndexMatchingSharedOptions, quantifyColoniesIndexMatchingSampleSharedOptions
  },
  (* Copy over all of the options from ExperimentQuantifyCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* These option names are strings *)
  quantifyColoniesSharedOptions = UnsortedComplement[
    Options[ExperimentQuantifyColonies][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  (* All the non index matching options *)
  quantifyColoniesNonIndexMatchingSharedOptions = UnsortedComplement[
    quantifyColoniesSharedOptions,
    Cases[OptionDefinition[ExperimentQuantifyColonies], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  (* All the index matching options to experiment samples *)
  quantifyColoniesIndexMatchingSampleSharedOptions = UnsortedComplement[
    quantifyColoniesSharedOptions,
    quantifyColoniesNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[QuantifyColonies,
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples containing microbial colonies that are counted.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "Well" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                  PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size -> Word
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentQuantifyColonies, Symbol[#]}&) /@ quantifyColoniesIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[quantifyColoniesNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentQuantifyColonies, Symbol[#]}&) /@ quantifyColoniesNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentQuantifyColonies,
    Methods -> {RoboticCellPreparation, ManualCellPreparation},
    WorkCells -> {qPix},
    MethodResolverFunction -> Experiment`Private`resolveQuantifyColoniesMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveQuantifyColoniesWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseQuantifyColoniesRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseQuantifyColoniesOutputUnitOperation,
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicroQuantifyColonies.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel,
      Null -> SampleContainerLabel,
      Null -> SampleOutLabel,
      Null -> ContainerOutLabel
    },
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Measures the colony count in the provided 'Samples' and measure colony-forming unit (CFU) for microbial sample.",
    Author -> {"lige.tonggu", "harrison.gronlund"}
  ]
];

(* ::Subsection:: *)
(*ImageColonies Primitive*)


imageColoniesPrimitive = Module[
  {
    imageColoniesSharedOptions, imageColoniesNonIndexMatchingSharedOptions, imageColoniesIndexMatchingSampleSharedOptions
  },
  (* Copy over all of the options from ExperimentQuantifyCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* These option names are strings *)
  imageColoniesSharedOptions = UnsortedComplement[
    Options[ExperimentImageColonies][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  (* All the non index matching options *)
  imageColoniesNonIndexMatchingSharedOptions = UnsortedComplement[
    imageColoniesSharedOptions,
    Cases[OptionDefinition[ExperimentImageColonies], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  (* All the index matching options to experiment samples *)
  imageColoniesIndexMatchingSampleSharedOptions = UnsortedComplement[
    imageColoniesSharedOptions,
    imageColoniesNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ImageColonies,
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that contained microbial colonies that are imaged.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {
                Object[Container] -> Field[Contents[[All, 2]]]
              }
            ],
            "Container with Well Position" -> {
              "Well Position" -> Alternatives[
                "Well" -> Widget[
                  Type -> Enumeration,
                  Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                  PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
                ],
                "Container Position" -> Widget[
                  Type -> String,
                  Pattern :> LocationPositionP,
                  PatternTooltip -> "Any valid container position.",
                  Size -> Word
                ]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentImageColonies, Symbol[#]}&) /@ imageColoniesIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[imageColoniesNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentImageColonies, Symbol[#]}&) /@ imageColoniesNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentImageColonies,
    Methods -> {RoboticCellPreparation},
    WorkCells -> {qPix},
    MethodResolverFunction -> Experiment`Private`resolveImageColoniesMethod,
    WorkCellResolverFunction -> Experiment`Private`resolveImageColoniesWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseImageColoniesRoboticPrimitive,
    OutputUnitOperationParserFunction -> None,
    (* We are not generating SamplesOut so Generative->False *)
    Generative -> False,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicroImageColonies.png"}]],
    LabeledOptions -> {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Microscopy",
    Description -> "Acquire microscopic images from the samples that contained microbial colonies.",
    Author -> {"lige.tonggu", "harrison.gronlund"}
  ]
];



(* ::Subsection:: *)
(*CoulterCount Primitive*)


coulterCountPrimitive=Module[
  {coulterCountSharedOptions,coulterCountNonIndexMatchingSharedOptions,coulterCountIndexMatchingSuitabilitySharedOptions,coulterCountIndexMatchingSampleSharedOptions},

  (* Copy over all of the options from ExperimentCoulterCount -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* These option names are strings *)
  coulterCountSharedOptions=UnsortedComplement[
    Options[ExperimentCoulterCount][[All,1]],
    Flatten[{Options[ProtocolOptions][[All,1]],$NonUnitOperationSharedOptions}]
  ];

  (* All the non-index matching options in string form! *)
  coulterCountNonIndexMatchingSharedOptions=UnsortedComplement[
    coulterCountSharedOptions,
    Cases[OptionDefinition[ExperimentCoulterCount],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  (* All the index matching suitability options in string form! with IndexMatchingParent->SuitabilitySizeStandard *)
  coulterCountIndexMatchingSuitabilitySharedOptions=Cases[
    OptionDefinition[ExperimentCoulterCount],
    KeyValuePattern["IndexMatching"->"SuitabilitySizeStandard"]
  ][[All,"OptionName"]];

  (* All the index matching sample options in string form! with IndexMatchingInput->"experiment samples" *)
  coulterCountIndexMatchingSampleSharedOptions=UnsortedComplement[
    coulterCountSharedOptions,
    Join[coulterCountNonIndexMatchingSharedOptions,coulterCountIndexMatchingSuitabilitySharedOptions]
  ];

  DefinePrimitive[CoulterCount,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"The samples (typically cells) to be counted and sized by the electrical resistance measurement.",
          AllowNull->False,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              ObjectTypes->{Object[Sample],Object[Container]},
              Dereference->{
                Object[Container]->Field[Contents[[All,2]]]
              }
            ],
            "Container with Well Position"->{
              "Well Position"->Alternatives[
                "A1 to P24"->Widget[
                  Type->Enumeration,
                  Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
                  PatternTooltip->"Enumeration must be any well from A1 to H12."
                ],
                "Container Position"->Widget[
                  Type->String,
                  Pattern:>LocationPositionP,
                  PatternTooltip->"Any valid container position.",
                  Size->Line
                ]
              ],
              "Container"->Widget[
                Type->Object,
                Pattern:>ObjectP[{Object[Container]}]
              ]
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentCoulterCount,Symbol[#]}&)/@coulterCountIndexMatchingSampleSharedOptions,
        IndexMatchingParent->Sample
      ],
      IndexMatching[
        Sequence@@({ExperimentCoulterCount,Symbol[#]}&)/@coulterCountIndexMatchingSuitabilitySharedOptions,
        IndexMatchingParent->SuitabilitySizeStandard
      ],
      If[Length[coulterCountNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentCoulterCount,Symbol[#]}&)/@coulterCountNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    ExperimentFunction->ExperimentCoulterCount,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseCoulterCountOutputUnitOperation,
    (* CoulterCount is manual for now and not integrated to robotic yet so this function really just outputs Manual ALWAYS *)
    MethodResolverFunction->Experiment`Private`resolveCoulterCountMethod,
    (* We are not generating SamplesOut so Generative->False *)
    Generative->False,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "CoulterCount.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{Sample->SampleLabel},
    Category->"Property Measurement",
    Description->"Count and size particles (typically cells) of difference sizes in the provided sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities.",
    Methods->{ManualSamplePreparation, ManualCellPreparation},
    Author->{"lei.tian"}
  ]
];


(* ::Subsection:: *)
(* LyseCells Primitive *)

lyseCellsPrimitive = Module[
  {lyseCellsSharedOptions, lyseCellsNonIndexMatchingSharedOptions, lyseCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentLyseCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  lyseCellsSharedOptions = UnsortedComplement[
    Options[ExperimentLyseCells][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  lyseCellsNonIndexMatchingSharedOptions = UnsortedComplement[
    lyseCellsSharedOptions,
    Cases[OptionDefinition[ExperimentLyseCells], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  lyseCellsIndexMatchingSharedOptions = UnsortedComplement[
    lyseCellsSharedOptions,
    lyseCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[LyseCells,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          AllowNull -> False,
          Description -> "The cell samples whose membranes are to be ruptured in the cell lysis experiment.",
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample],Object[Container]}],
            Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentLyseCells,Symbol[#]}&) /@ lyseCellsIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[lyseCellsNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentLyseCells,Symbol[#]}&) /@ lyseCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentLyseCells,
    WorkCellResolverFunction -> Experiment`Private`resolveLyseCellsWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseLyseCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseLyseCellsOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","LyseCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      Null -> PreLysisSupernatantLabel,
      PreLysisSupernatantContainer -> PreLysisSupernatantContainerLabel,
      Null -> PostClarificationPelletLabel,
      Null -> PostClarificationPelletContainerLabel,
      ClarifiedLysateContainer -> ClarifiedLysateContainerLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Ruptures the cell membranes of a cell containing sample to enable extraction of cellular components.",
    Author -> {"tyler.pabst", "daniel.shlian"}
  ]
];

(* ::Subsection:: *)
(* Precipitate Primitive *)

precipitatePrimitive = Module[
  {precipitateSharedOptions, precipitateNonIndexMatchingSharedOptions, precipitateIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentPrecipitate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  precipitateSharedOptions = UnsortedComplement[
    Options[ExperimentPrecipitate][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  precipitateNonIndexMatchingSharedOptions = UnsortedComplement[
    precipitateSharedOptions,
    Cases[OptionDefinition[ExperimentPrecipitate], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  precipitateIndexMatchingSharedOptions = UnsortedComplement[
    precipitateSharedOptions,
    precipitateNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Precipitate,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          AllowNull -> False,
          Description -> "The samples which will be precipitated.",
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample],Object[Container]}],
            Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentPrecipitate,Symbol[#]}&) /@ precipitateIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[precipitateNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentPrecipitate,Symbol[#]}&) /@ precipitateNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {STAR, bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentPrecipitate,
    WorkCellResolverFunction -> Experiment`Private`resolvePrecipitateWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","Precipitate.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      Null -> PrecipitatedSampleLabel,
      PrecipitatedSampleContainerOut -> PrecipitatedSampleContainerLabel,
      Null -> UnprecipitatedSampleLabel,
      UnprecipitatedSampleContainerOut -> UnprecipitatedSampleContainerLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Combines precipitating reagent with sample and separates the resulting precipitate and liquid phase.",
    Author -> "taylor.hochuli"
  ]
];


(* ::Subsection:: *)
(* ExtractRNA Primitive *)

extractRNAPrimitive = Module[
  {extractRNASharedOptions, extractRNANonIndexMatchingSharedOptions, extractRNAIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentExtractRNA -- except for the funtopia shared options (Cache, Upload, etc.) *)
  extractRNASharedOptions = UnsortedComplement[
    Options[ExperimentExtractRNA][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  extractRNANonIndexMatchingSharedOptions = UnsortedComplement[
    extractRNASharedOptions,
    Cases[OptionDefinition[ExperimentExtractRNA], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  extractRNAIndexMatchingSharedOptions = UnsortedComplement[
    extractRNASharedOptions,
    extractRNANonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ExtractRNA,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          AllowNull -> False,
          Description -> "The live cell, cell lysate, or partially purified RNA sample(s) from which RNA is extracted.",
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample], Object[Container]}],
            Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentExtractRNA,Symbol[#]}&) /@ extractRNAIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[extractRNANonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentExtractRNA,Symbol[#]}&) /@ extractRNANonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentExtractRNA,
    WorkCellResolverFunction -> Experiment`Private`resolveExtractRNAWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseExtractRNARoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseExtractRNAOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ExtractRNA.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      ContainerOut -> ExtractedRNAContainerLabel
    },
    Generative -> True,
    GenerativeLabelOption -> ExtractedRNALabel,
    Category -> "Sample Preparation",
    Description -> "Isolates RNA from live cell or cell lysate samples through lysing (if the input sample contains cells, rather than lysate), clearing the lysate of cellular debris by homogenization (optional), followed by one or more rounds of optional crude purification techniques including precipitation (such as a cold ethanol or isopropanol wash), liquid-liquid extraction (such as a phenol-chloroform extraction), solid phase extraction (such as a spin column), and magnetic bead separation (selectively binding RNA to magnetic beads while washing non-binding impurities from the mixture). Digestion enzymes can be added during any of these purification steps to degrade DNA in order to improve the purity of the extracted RNA. Extracted RNA can be further purified and analyzed with experiments including, but not limited to, ExperimentHPLC, ExperimentFPLC, and ExperimentPAGE (see experiment help files to learn more).",
    Author -> "melanie.reschke"
  ]
];


(* ::Subsection:: *)
(* ExtractPlasmidDNA Primitive *)

extractPlasmidDNAPrimitive = Module[
  {
    extractPlasmidDNASharedOptions, extractPlasmidDNANonIndexMatchingSharedOptions, extractPlasmidDNAIndexMatchingSharedOptions
  },

  (* Copy over all of the options from ExperimentExtractPlasmidDNA -- except for the funtopia shared options (Cache, Upload, etc.) *)
  extractPlasmidDNASharedOptions = UnsortedComplement[
    Options[ExperimentExtractPlasmidDNA][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  extractPlasmidDNANonIndexMatchingSharedOptions = UnsortedComplement[
    extractPlasmidDNASharedOptions,
    Cases[OptionDefinition[ExperimentExtractPlasmidDNA], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  extractPlasmidDNAIndexMatchingSharedOptions = UnsortedComplement[
    extractPlasmidDNASharedOptions,
    extractPlasmidDNANonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ExtractPlasmidDNA,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          AllowNull -> False,
          Description -> "The live cell, cell lysate, or partially purified plasmid DNA sample(s) from which plasmid DNA is extracted.",
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample],Object[Container]}],
            Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentExtractPlasmidDNA,Symbol[#]}&) /@ extractPlasmidDNAIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[extractPlasmidDNANonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentExtractPlasmidDNA,Symbol[#]}&) /@ extractPlasmidDNANonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentExtractPlasmidDNA,
    WorkCellResolverFunction -> Experiment`Private`resolveExtractPlasmidDNAWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ExtractPlasmidDNA.png"}]],
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> ExtractedPlasmidDNALabel,
    Category -> "Sample Preparation",
    Description -> "Isolates plasmid DNA from live cell or cell lysate through lysing (if dealing with cells, rather than lysate), then neutralizing the pH of the solution to keep plasmid DNA soluble (through renaturing) and pelleting out insoluble cell components, followed by one or more rounds of optional purification techniques including  precipitation (such as a cold ethanol or isopropanol wash), liquid-liquid extraction (such as phenol:chloroform extraction), solid phase extraction (such as spin columns), and magnetic bead separation (selectively binding plasmid DNA to magnetic beads while washing non-binding impurities from the mixture).",
    Author -> "taylor.hochuli"
  ]
];


(* ::Subsection:: *)
(* ExtractProtein Primitive *)

extractProteinPrimitive = Module[
  {extractProteinSharedOptions, extractProteinNonIndexMatchingSharedOptions, extractProteinIndexMatchingSharedOptions},

  extractProteinSharedOptions = UnsortedComplement[
    Options[ExperimentExtractProtein][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  extractProteinNonIndexMatchingSharedOptions = UnsortedComplement[
    extractProteinSharedOptions,
    Cases[OptionDefinition[ExperimentExtractProtein], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  extractProteinIndexMatchingSharedOptions = UnsortedComplement[
    extractProteinSharedOptions,
    extractProteinNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ExtractProtein,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          AllowNull -> False,
          Description -> "The live cell, cell lysate, or partially purified protein sample(s) from which protein is extracted.",
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample],Object[Container]}],
            Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentExtractProtein,Symbol[#]}&) /@ extractProteinIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[extractProteinNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentExtractProtein,Symbol[#]}&) /@ extractProteinNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentExtractProtein,
    WorkCellResolverFunction -> Experiment`Private`resolveExtractProteinWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> None,
    OutputUnitOperationParserFunction -> None,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ExtractRNA.png"}]],(* TODO change to ExtractProtein icon image *)
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Isolates protein from live cell or cell lysate through lysing (if dealing with cells, rather than lysate), followed by one or more rounds of optional purification techniques including  precipitation (such as by adding ammonium sulfate, TCA (trichloroacetic acid), or acetone etc.), liquid-liquid extraction (e.g. adding C4 and C5 alcohols (butanol, pentanol) followed by ammonium sulfate into the protein-containing aqueous solution), solid phase extraction (such as spin columns), and magnetic bead separation (selectively binding proteins to magnetic beads while washing non-binding impurities from the mixture). Note that ExperimentExtractProtein is intended to extract specific or non-specific proteins from the whole cells or cell lysate.",
    Author -> "yanzhe.zhu"
  ]
];


(* ::Subsection:: *)
(* WashCells Primitive *)

washCellsPrimitive = Module[
  {washCellsSharedOptions, washCellsNonIndexMatchingSharedOptions, washCellsIndexMatchingSharedOptions},
  washCellsSharedOptions = UnsortedComplement[
    Options[ExperimentWashCells][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  washCellsNonIndexMatchingSharedOptions = UnsortedComplement[
    washCellsSharedOptions,
    Cases[OptionDefinition[ExperimentWashCells], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  washCellsIndexMatchingSharedOptions = UnsortedComplement[
    washCellsSharedOptions,
    washCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[WashCells,
    (* Input Options *)
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          AllowNull->False,
          Description->"The cell sample that is going to be washed or changed media.",
          Category->"General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Object[Sample],Object[Container]}],
            Dereference->{Object[Container]->Field[Contents[[All,2]]]}
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentWashCells,Symbol[#]}&) /@ washCellsIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[washCellsNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentWashCells,Symbol[#]}&) /@ washCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentWashCells,
    WorkCellResolverFunction -> Experiment`Private`resolveWashCellsWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseWashCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseWashCellsOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WashCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      AliquotMediaContainer -> AliquotMediaContainerLabel,
      Null -> AliquotMediaLabel,
      ContainerOut -> ContainerOutLabel,
      Null -> SampleOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Wash living cells in order to remove impurities, debris, metabolites, and media from cell samples that prohibits further cell growth or interferes with downstream experiments.",
    Author -> "xu.yi"
  ]
];

(* ::Subsection:: *)
(* ChangeMedia Primitive *)

changeMediaPrimitive = Module[
  {changeMediaSharedOptions, changeMediaNonIndexMatchingSharedOptions, changeMediaIndexMatchingSharedOptions},
  changeMediaSharedOptions = UnsortedComplement[
    Options[ExperimentChangeMedia][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  changeMediaNonIndexMatchingSharedOptions = UnsortedComplement[
    changeMediaSharedOptions,
    Cases[OptionDefinition[ExperimentChangeMedia], KeyValuePattern["IndexMatching" -> Except["None"]]][[All,"OptionName"]]
  ];

  changeMediaIndexMatchingSharedOptions = UnsortedComplement[
    changeMediaSharedOptions,
    changeMediaNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ChangeMedia,
    (* Input Options *)
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          AllowNull->False,
          Description->"The cell sample that is going to be washed or changed media.",
          Category->"General",
          Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[{Object[Sample],Object[Container]}],
            Dereference->{Object[Container]->Field[Contents[[All,2]]]}
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentChangeMedia,Symbol[#]}&) /@ changeMediaIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[changeMediaNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentChangeMedia,Symbol[#]}&) /@ changeMediaNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells -> {bioSTAR, microbioSTAR},
    ExperimentFunction -> ExperimentChangeMedia,
    WorkCellResolverFunction -> Experiment`Private`resolveWashCellsWorkCell,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseWashCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseWashCellsOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WashCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      AliquotMediaContainer -> AliquotMediaContainerLabel,
      Null -> AliquotMediaLabel,
      ContainerOut -> ContainerOutLabel,
      Null -> SampleOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Wash living cells in order to remove impurities, debris, metabolites, and media from cell samples that prohibits further cell growth or interferes with downstream experiments.",
    Author -> "xu.yi"
  ]
];


(* ::Subsection:: *)
(*CountLiquidParticles Primitive*)


(* ::Code::Initialization:: *)
countLiquidParticlesPrimitive = Module[
  {
    countLiquidParticleSharedOptions, countLiquidParticleNonIndexMatchingSharedOptions, countLiquidParticleIndexMatchingPrimeSolutionSharedOptions,
    countLiquidParticleIndexMatchingSampleSharedOptions
  },

  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  countLiquidParticleSharedOptions =UnsortedComplement[
    Options[ExperimentCountLiquidParticles][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  countLiquidParticleNonIndexMatchingSharedOptions=UnsortedComplement[
    countLiquidParticleSharedOptions,
    Cases[OptionDefinition[ExperimentCountLiquidParticles], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  countLiquidParticleIndexMatchingPrimeSolutionSharedOptions=Cases[
    OptionDefinition[ExperimentCountLiquidParticles],
    KeyValuePattern["IndexMatching" -> "PrimeSolutions"]
  ][[All, "OptionName"]];

  countLiquidParticleIndexMatchingSampleSharedOptions=UnsortedComplement[
    countLiquidParticleSharedOptions,
    Join[countLiquidParticleNonIndexMatchingSharedOptions,countLiquidParticleIndexMatchingPrimeSolutionSharedOptions]
  ];

  DefinePrimitive[CountLiquidParticles,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be analysed with the liquid particle counter.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentCountLiquidParticles, Symbol[#]}&) /@ countLiquidParticleIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      IndexMatching[
        Sequence @@ ({ExperimentCountLiquidParticles, Symbol[#]}&) /@ countLiquidParticleIndexMatchingPrimeSolutionSharedOptions,
        IndexMatchingParent -> PrimeSolutions
      ],
      If[Length[countLiquidParticleNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentCountLiquidParticles, Symbol[#]}&) /@ countLiquidParticleNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentCountLiquidParticles,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseCountLiquidParticlesOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveCountLiquidParticlesMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "CountLiquidParticles.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Count the liquid particle sizes of a liquid sample.",
    Methods -> {ManualCellPreparation,ManualSamplePreparation},
    Author -> "melanie.reschke"
  ]
];

(* ::Subsection:: *)
(*GrowCrystal Primitive*)
growCrystalPrimitive = Module[
  {
    growCrystalSharedOptions, growCrystalNonIndexMatchingSharedOptions, growCrystalIndexMatchingSampleSharedOptions
  },
  (* Copy over all of the options from ExperimentMagneticBeadSeparation -- except for the funtopia shared options (Cache, Upload, etc.) *)
  growCrystalSharedOptions = UnsortedComplement[
    Options[ExperimentGrowCrystal][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  growCrystalNonIndexMatchingSharedOptions = UnsortedComplement[
    growCrystalSharedOptions,
    Cases[OptionDefinition[ExperimentGrowCrystal], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  growCrystalIndexMatchingSampleSharedOptions = UnsortedComplement[
    growCrystalSharedOptions,
    growCrystalNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[GrowCrystal,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The sample solutions containing target proteins or small molecules which will be plated in order to grow crystals.",
          AllowNull -> False,
          Category -> "General",
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
                  Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                  PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence@@({ExperimentGrowCrystal, Symbol[#]}&) /@ growCrystalIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[growCrystalNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence@@({ExperimentGrowCrystal, Symbol[#]}&) /@ growCrystalNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},
    ExperimentFunction -> ExperimentGrowCrystal,
    MethodResolverFunction -> None,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseGrowCrystalOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "GrowCrystal.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      CrystallizationPlate -> CrystallizationPlateLabel,
      Null -> DropSamplesOutLabel,
      Null -> ReservoirSamplesOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> DropSamplesOutLabel,
    Category -> "Sample Preparation",
    Description -> "Prepares crystallization plate designed to grow crystals, and incubate and image the prepared crystallization plate.",
    Author -> {"lige.tonggu", "thomas"}
  ]
];

(* ::Subsection:: *)
(*ICPMS Primitive*)

icpmsPrimitive = Module[
  {
    icpmsSharedOptions, icpmsNonIndexMatchingSharedOptions, icpmsIndexMatchingSampleSharedOptions,
    icpmsIndexMatchingElementsSharedOptions, icpmsIndexMatchingExternalStandardSharedOptions
  },

  (* Copy over all options from ExperimentICPMS -- except for the funtopia shared options *)
  icpmsSharedOptions = UnsortedComplement[
    Options[ExperimentICPMS][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  (* Get non-index-matching options *)
  icpmsNonIndexMatchingSharedOptions = UnsortedComplement[
    icpmsSharedOptions,
    Cases[OptionDefinition[ExperimentICPMS], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  (* Get options index match to Elements *)
  icpmsIndexMatchingElementsSharedOptions = Cases[
    OptionDefinition[ExperimentICPMS],
    KeyValuePattern["IndexMatching" -> "Elements"]
  ][[All, "OptionName"]];

  (* Get options index match to ExternalStandard *)
  icpmsIndexMatchingExternalStandardSharedOptions = Cases[
    OptionDefinition[ExperimentICPMS],
    KeyValuePattern["IndexMatching" -> "ExternalStandard"]
  ][[All, "OptionName"]];

  (* Get options index match to sample *)
  icpmsIndexMatchingSampleSharedOptions = UnsortedComplement[
    icpmsSharedOptions,
    Join[icpmsNonIndexMatchingSharedOptions,icpmsIndexMatchingElementsSharedOptions, icpmsIndexMatchingExternalStandardSharedOptions]
  ];

  DefinePrimitive[ICPMS,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be analyzed with ICP-MS instrument.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentICPMS, Symbol[#]}&) /@ icpmsIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      IndexMatching[
        Sequence @@ ({ExperimentICPMS, Symbol[#]}&) /@ icpmsIndexMatchingElementsSharedOptions,
        IndexMatchingParent -> Elements
      ],
      IndexMatching[
        Sequence @@ ({ExperimentICPMS, Symbol[#]}&) /@ icpmsIndexMatchingExternalStandardSharedOptions,
        IndexMatchingParent -> ExternalStandard
      ],
      If[Length[icpmsNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentICPMS, Symbol[#]}&) /@ icpmsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentICPMS,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseICPMSOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveExperimentICPMSMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MassSpectometry.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Atomize, ionize and analyze the elemental composition of the input analyte.",
    Methods -> {ManualSamplePreparation},
    Author -> "tyler.pabst"
  ]
];

(* ::Subsection:: *)
(*MicrowaveDigestion Primitive*)

microwaveDigestionPrimitive = Module[
  {
    microwaveDigestionSharedOptions, microwaveDigestionNonIndexMatchingSharedOptions, microwaveDigestionIndexMatchingSampleSharedOptions
  },

  (* Copy over all options from ExperimentMicrowaveDigestion -- except for the funtopia shared options *)
  microwaveDigestionSharedOptions = UnsortedComplement[
    Options[ExperimentMicrowaveDigestion][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  (* Get non-index-matching options *)
  microwaveDigestionNonIndexMatchingSharedOptions = UnsortedComplement[
    microwaveDigestionSharedOptions,
    Cases[OptionDefinition[ExperimentMicrowaveDigestion], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  (* Get options index match to sample *)
  microwaveDigestionIndexMatchingSampleSharedOptions = UnsortedComplement[
    microwaveDigestionSharedOptions,
    microwaveDigestionNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MicrowaveDigestion,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be digested with microwave reactor.",
          AllowNull -> False,
          Category -> "General",
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
            "Model Sample" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentMicrowaveDigestion, Symbol[#]}&) /@ microwaveDigestionIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[microwaveDigestionIndexMatchingSampleSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentMicrowaveDigestion, Symbol[#]}&) /@ microwaveDigestionIndexMatchingSampleSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},
    ExperimentFunction -> ExperimentMicrowaveDigestion,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseMicrowaveDigestionOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveExperimentMicrowaveDigestionMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicrowaveDigestion.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Digest sample with microwave to ensure full solubility for subsequent analysis, especially for ICP-MS.",
    Methods -> {ManualSamplePreparation},
    Author -> {"alou"}
  ]
];

(* ::Subsection:: *)
(*DynamicLightScattering Primitive*)

dynamicLightScatteringPrimitive=Module[
  {
    dynamicLightScatteringSharedOptions,dynamicLightScatteringNonIndexMatchingSharedOptions,
    dynamicLightScatteringIndexMatchingSampleSharedOptions
  },

  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  dynamicLightScatteringSharedOptions =UnsortedComplement[
    Options[ExperimentDynamicLightScattering][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions,"StandardDilutionCurve", "SerialDilutionCurve"}]
  ];

  dynamicLightScatteringNonIndexMatchingSharedOptions=UnsortedComplement[
    dynamicLightScatteringSharedOptions,
    Cases[OptionDefinition[ExperimentDynamicLightScattering], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  dynamicLightScatteringIndexMatchingSampleSharedOptions=UnsortedComplement[
    dynamicLightScatteringSharedOptions,
    dynamicLightScatteringNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[DynamicLightScattering,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be analyzed by Dynamic Light Scattering (DLS).",
          AllowNull -> False,
          Category -> "General",
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
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentDynamicLightScattering, Symbol[#]}&) /@ dynamicLightScatteringIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[dynamicLightScatteringNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentDynamicLightScattering, Symbol[#]}&) /@ dynamicLightScatteringNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods->{ManualSamplePreparation},
    ExperimentFunction -> ExperimentDynamicLightScattering,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseDynamicLightScatteringOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveDynamicLightScatteringMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "DynamicLightScattering.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Category -> "Property Measurement",
    Description -> "Determine the hydrodynamic radius of an analyte via Dynamic Light Scattering.",
    Author -> {"daniel.shlian"}
  ]
];

(* ::Subsection:: *)
(*Desiccate Primitive*)

desiccatePrimitive = Module[
  {
    desiccateSharedOptions,
    desiccateNonIndexMatchingSharedOptions,
    desiccateIndexMatchingSharedOptions
  },

  (* Copy over all of the options from ExperimentDesiccate -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  desiccateSharedOptions =UnsortedComplement[
    Options[ExperimentDesiccate][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}](*,
      (* NOTE: We DO want to copy over the aliquot options for the manual primitive. *)
      Options[AliquotOptions][[All, 1]]*)
    ]
  ];

  desiccateNonIndexMatchingSharedOptions=UnsortedComplement[
    desiccateSharedOptions,
    Cases[OptionDefinition[ExperimentDesiccate], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  desiccateIndexMatchingSharedOptions=UnsortedComplement[
    desiccateSharedOptions,
    desiccateNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Desiccate,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be desiccated.",
          AllowNull -> True,
          Category -> "General",
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample],Object[Container]}],
            ObjectTypes -> {Object[Sample], Object[Container]},
            Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentDesiccate, Symbol[#]}&) /@ desiccateIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[desiccateNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentDesiccate, Symbol[#]}&) /@ desiccateNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},
    ExperimentFunction -> ExperimentDesiccate,
    MethodResolverFunction -> Null,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseDesiccateOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "Desiccate.png"}]],
    LabeledOptions -> {
      Sample -> SampleLabel,
      SampleContainer->SampleContainerLabel,
      ContainerOut->ContainerOutLabel,
      Null->SampleOutLabel
    },
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Dries out solid substances by absorbing water molecules from the samples through exposing them to a chemical desiccant in a bell jar desiccator under vacuum or non-vacuum conditions."
  ]
];

(* ::Subsection:: *)
(*Grind Primitive*)

grindPrimitive = Module[{grindSharedOptions, grindNonIndexMatchingSharedOptions, grindIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentGrind -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  grindSharedOptions =UnsortedComplement[
    Options[ExperimentGrind][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}],
      (* NOTE: We DO want to copy over the aliquot options for the manual primitive. *)
      Options[AliquotOptions][[All, 1]]
    ]
  ];

  grindNonIndexMatchingSharedOptions=UnsortedComplement[
    grindSharedOptions,
    Cases[OptionDefinition[ExperimentGrind], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  grindIndexMatchingSharedOptions=UnsortedComplement[
    grindSharedOptions,
    grindNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[Grind,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that should be ground into smaller powder particles by grinders.",
          AllowNull -> True,
          Category -> "General",
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
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentGrind, Symbol[#]}&) /@ grindIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[grindNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentGrind, Symbol[#]}&) /@ grindNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},
    ExperimentFunction -> ExperimentGrind,
    MethodResolverFunction -> Null,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseGrindOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "Grind.png"}]],
    LabeledOptions -> {
      Sample->SampleLabel,
      ContainerOut->ContainerOutLabel,
      Null->SampleOutLabel
    },
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Reduces the size of powder particles by grinding solid substances into fine powders via a grinder (mill)."
  ]
];
(* ::Subsection:: *)
(*MeasureMeltingPoint Primitive*)

measureMeltingPointPrimitive = Module[{measureMeltingPointSharedOptions, measureMeltingPointNonIndexMatchingSharedOptions, measureMeltingPointIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentMeasureMeltingPoint -- except for the funtopia shared options (Cache, Upload, etc.) *)
  (* NOTE: If you don't have aliquot options and are reusing an aliquot option symbol, BE CAREFUL because your option will *)
  (* be complemented out since NonBiologyFuntopiaSharedOptions contains AliquotOptions. *)
  measureMeltingPointSharedOptions =UnsortedComplement[
    Options[ExperimentMeasureMeltingPoint][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "NumberOfReplicates", $NonUnitOperationSharedOptions}],
      (* NOTE: We DO want to copy over the aliquot options for the manual primitive. *)
      Options[AliquotOptions][[All, 1]]
    ]
  ];

  measureMeltingPointNonIndexMatchingSharedOptions=UnsortedComplement[
    measureMeltingPointSharedOptions,
    Cases[OptionDefinition[ExperimentMeasureMeltingPoint], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  measureMeltingPointIndexMatchingSharedOptions=UnsortedComplement[
    measureMeltingPointSharedOptions,
    measureMeltingPointNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MeasureMeltingPoint,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The input samples whose melting temperatures are measured. The input samples can be solid substances, such as powders or substances that can be easily ground into powders, that will be packed into melting point capillary tubes before measuring their melting points or melting point capillary tubes that were previously packed with powders.",
          AllowNull -> True,
          Category -> "General",
          Widget -> Alternatives[
            "Solid sample" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample],Object[Container]}],
              ObjectTypes -> {Object[Sample], Object[Container]},
              Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
            ],
            "Model Solid Sample" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ],
            "Prepacked melting point capillary tube" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container, Capillary]}],
              ObjectTypes -> {Object[Container,Capillary]}
            ]
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentMeasureMeltingPoint, Symbol[#]}&) /@ measureMeltingPointIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[measureMeltingPointNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentMeasureMeltingPoint, Symbol[#]}&) /@ measureMeltingPointNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {ManualSamplePreparation},
    ExperimentFunction -> ExperimentMeasureMeltingPoint,
    MethodResolverFunction -> Null,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseMeasureMeltingPointOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MeltingPoint.png"}]],
    LabeledOptions -> {
      Sample->SampleLabel,
      SampleContainer->SampleContainerLabel,
      Null->PreparedSampleLabel
    },
    InputOptions -> {Sample},
    Generative -> False,
    CompletedOptions -> {
      GrindingVideos,ValvePosition,DesiccationImages,
      Sensor,Pressure,Capillaries,NumberOfCapillaries,
      SealCapillary,Seals
    },
    Category -> "Sample Preparation",
    Description -> "Measures the melting points of the input 'Samples' using a melting point apparatus that applies an increasing temperature gradient to melting point capillary tubes containing a small amount of the input samples. This experiment can be performed on samples that were previously packed into melting point capillary tubes or fresh samples that need to be packed."
  ]
];

(* ::Subsection:: *)
(*CrossFlowFiltration Primitives*)
(*crossflow*)

crossflowFiltrationPrimitive = Module[
  {
    crossflowFiltrationSharedOptions, crossflowFiltrationNonIndexMatchingSharedOptions, crossflowFiltrationIndexMatchingPrimeSolutionSharedOptions,
    crossflowFiltrationIndexMatchingSampleSharedOptions
  },

  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  crossflowFiltrationSharedOptions =UnsortedComplement[
    Options[ExperimentCrossFlowFiltration][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  crossflowFiltrationNonIndexMatchingSharedOptions=UnsortedComplement[
    crossflowFiltrationSharedOptions,
    Cases[OptionDefinition[ExperimentCrossFlowFiltration], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  crossflowFiltrationIndexMatchingSampleSharedOptions=UnsortedComplement[
    crossflowFiltrationSharedOptions,
    crossflowFiltrationNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[CrossFlowFiltration,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The samples that are filtered by cross-flow filtration technique.",
          AllowNull -> False,
          Category -> "General",
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentCrossFlowFiltration, Symbol[#]}&) /@ crossflowFiltrationIndexMatchingSampleSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[crossflowFiltrationNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence @@ ({ExperimentCrossFlowFiltration, Symbol[#]}&) /@ crossflowFiltrationNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    ExperimentFunction -> ExperimentCrossFlowFiltration,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseCrossFlowFiltrationOutputUnitOperation,
    MethodResolverFunction -> Experiment`Private`resolveCrossFlowFiltrationMethod,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FilterIcon.png"}]],
    LabeledOptions ->  {
      Sample -> SampleLabel,
      RetentateContainerOut -> RetentateContainerOutLabel,
      PermeateContainerOut -> PermeateContainerOutLabel,
      Null -> SampleContainerLabel,
      Null -> RetentateSampleOutLabel,
      Null -> PermeateSampleOutLabel
    },
    InputOptions -> {Sample},
    Category -> "Sample Preparation",
    Description -> "Flow samples tangentially across the surface of the filter to be concentrated and/or exchange its own solution with another buffer solution.",
    Methods -> {ManualSamplePreparation},
    CompletedOptions -> {
      EnvironmentalData, Sample
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel
  ]
];




(* ::Subsection:: *)
(*PickColonies Primitive*)
pickColoniesPrimitive=Module[
  {pickColoniesSharedOptions,pickColoniesNonIndexMatchingSharedOptions,pickColoniesIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentPickColonies -- except for the funtopia shared options (Cache, Upload, etc.) *)
  pickColoniesSharedOptions=UnsortedComplement[
    Options[ExperimentPickColonies][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  pickColoniesNonIndexMatchingSharedOptions=UnsortedComplement[
    pickColoniesSharedOptions,
    Cases[OptionDefinition[ExperimentPickColonies],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  pickColoniesIndexMatchingSharedOptions=UnsortedComplement[
    pickColoniesSharedOptions,
    pickColoniesNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[PickColonies,
    (* Input Options *)
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"Input samples that colonies are growing on and are picked from.",
          AllowNull->False,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              Dereference->{Object[Container]->Field[Contents[[All,2]]]}
            ],
            "Container with Well Position"->{
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                PatternTooltip -> "Enumeration must be any well from A1 to H12."
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentPickColonies,Symbol[#]}&)/@pickColoniesIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[pickColoniesNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentPickColonies,Symbol[#]}&)/@pickColoniesNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    Methods->{RoboticCellPreparation},
    WorkCells->{qPix},
    ExperimentFunction->ExperimentPickColonies,
    WorkCellResolverFunction->Experiment`Private`resolvePickColoniesWorkCell,
    MethodResolverFunction-> Experiment`Private`resolvePickColoniesMethod,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parsePickColoniesRoboticPrimitive,
    OutputUnitOperationParserFunction->None,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicroPickColonies.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{
      Null->SampleOutLabel,
      Null->ContainerOutLabel
    },
    Generative->True,
    GenerativeLabelOption->SampleOutLabel,
    Category->"Cell Preparation",
    Description->"Moves bacterial colonies growing on solid media to a new liquid or solid media.",
    Author -> {"harrison.gronlund", "kelmen.low"}
  ]
];


(* ::Subsection:: *)
(*InoculateLiquidMedia Primitive*)
inoculateLiquidMediaPrimitive=Module[
  {inoculateLiquidMediaSharedOptions,inoculateLiquidMediaNonIndexMatchingSharedOptions,inoculateLiquidMediaIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentInoculateLiquidMedia -- except for the funtopia shared options (Cache, Upload, etc.) *)
  inoculateLiquidMediaSharedOptions=UnsortedComplement[
    Options[ExperimentInoculateLiquidMedia][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  inoculateLiquidMediaNonIndexMatchingSharedOptions=UnsortedComplement[
    inoculateLiquidMediaSharedOptions,
    Cases[OptionDefinition[ExperimentInoculateLiquidMedia],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  inoculateLiquidMediaIndexMatchingSharedOptions=UnsortedComplement[
    inoculateLiquidMediaSharedOptions,
    inoculateLiquidMediaNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[InoculateLiquidMedia,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "Input samples where colonies are growing that need to be transferred.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                PatternTooltip -> "Enumeration must be any well from A1 to H12."
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
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentInoculateLiquidMedia, Symbol[#]}&) /@ inoculateLiquidMediaIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[inoculateLiquidMediaNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentInoculateLiquidMedia, Symbol[#]}&) /@ inoculateLiquidMediaNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation,ManualCellPreparation},
    WorkCells -> {qPix,microbioSTAR,bioSTAR},
    ExperimentFunction -> ExperimentInoculateLiquidMedia,
    WorkCellResolverFunction -> Experiment`Private`resolveInoculateLiquidMediaWorkCell,
    MethodResolverFunction -> Experiment`Private`resolveInoculateLiquidMediaMethod,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseInoculateLiquidMediaRoboticPrimitive,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseInoculateLiquidMediaOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "InoculateLiquidMedia.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      Sample -> SampleLabel,
      Null -> SampleContainerLabel,
      Null -> SampleOutLabel,
      Null -> ContainerOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Cell Preparation",
    Description -> "Moves bacterial colonies growing on solid media or in liquid media to fresh liquid media.",
    Author -> {"harrison.gronlund", "kelmen.low"}
  ]
];

(* ::Subsection:: *)
(*SpreadCells Primitive*)
spreadCellsPrimitive=Module[
  {spreadCellsSharedOptions,spreadCellsNonIndexMatchingSharedOptions,spreadCellsIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentSpreadCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  spreadCellsSharedOptions=UnsortedComplement[
    Options[ExperimentSpreadCells][[All,1]],
    Flatten[{Options[ProtocolOptions][[All,1]], $NonUnitOperationSharedOptions}]
  ];

  spreadCellsNonIndexMatchingSharedOptions=UnsortedComplement[
    spreadCellsSharedOptions,
    Cases[OptionDefinition[ExperimentSpreadCells],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  spreadCellsIndexMatchingSharedOptions=UnsortedComplement[
    spreadCellsSharedOptions,
    spreadCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[SpreadCells,
    (* Input Options *)
    Options :> {
      IndexMatching[
        IndexMatchingParent -> Sample,
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "Input samples that are spread on solid media",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample],Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                PatternTooltip -> "Enumeration must be any well from A1 to H12."
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        }
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        IndexMatchingParent -> Sample,
        Sequence@@({ExperimentSpreadCells,Symbol[#]}&)/@spreadCellsIndexMatchingSharedOptions
      ],
      If[Length[spreadCellsNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentSpreadCells,Symbol[#]}&)/@spreadCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells->{qPix},
    ExperimentFunction -> ExperimentSpreadCells,
    WorkCellResolverFunction -> Experiment`Private`resolveSpreadAndStreakWorkCell,
    MethodResolverFunction -> Experiment`Private`resolveSpreadAndStreakMethod,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseSpreadAndStreakCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> None,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicroSpreadCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      Sample -> SampleLabel,
      Null -> SampleContainerLabel,
      Null -> SampleOutLabel,
      Null -> ContainerOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Cell Preparation",
    Description -> "Moves suspended colonies growing in liquid media to solid media and moves them across the surface of the media in a pattern to promote growth of the colonies.",
    Author -> {"yanzhe.zhu"}
  ]
];

(* ::Subsection:: *)
(*StreakCells Primitive*)
streakCellsPrimitive=Module[
  {streakCellsSharedOptions,streakCellsNonIndexMatchingSharedOptions,streakCellsIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentStreakCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  streakCellsSharedOptions=UnsortedComplement[
    Options[ExperimentStreakCells][[All,1]],
    Flatten[{Options[ProtocolOptions][[All,1]], $NonUnitOperationSharedOptions}]
  ];

  streakCellsNonIndexMatchingSharedOptions=UnsortedComplement[
    streakCellsSharedOptions,
    Cases[OptionDefinition[ExperimentStreakCells],KeyValuePattern["IndexMatching"->Except["None"]]][[All,"OptionName"]]
  ];

  streakCellsIndexMatchingSharedOptions=UnsortedComplement[
    streakCellsSharedOptions,
    streakCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[StreakCells,
    (* Input Options *)
    Options :> {
      IndexMatching[
        IndexMatchingParent -> Sample,
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "Input samples that are streak on solid media",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample],Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All,2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                PatternTooltip -> "Enumeration must be any well from A1 to H12."
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        }
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        IndexMatchingParent -> Sample,
        Sequence@@({ExperimentStreakCells,Symbol[#]}&)/@streakCellsIndexMatchingSharedOptions
      ],
      If[Length[streakCellsNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentStreakCells,Symbol[#]}&)/@streakCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],
    Methods -> {RoboticCellPreparation},
    WorkCells->{qPix},
    ExperimentFunction -> ExperimentStreakCells,
    WorkCellResolverFunction -> Experiment`Private`resolveSpreadAndStreakWorkCell,
    MethodResolverFunction -> Experiment`Private`resolveSpreadAndStreakMethod,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parseSpreadAndStreakCellsRoboticPrimitive,
    OutputUnitOperationParserFunction -> None,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MicroStreakCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {
      Sample -> SampleLabel,
      Null -> SampleContainerLabel,
      Null -> SampleOutLabel,
      Null -> ContainerOutLabel
    },
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Cell Preparation",
    Description -> "Moves suspended colonies growing in liquid media to solid media and moves them across the surface of the media in a pattern to try and isolate individual colonies.",
    Author -> {"yanzhe.zhu"}
  ]
];

(* ::Code::Initialization:: *)
freezeCellsPrimitive = Module[{freezeCellsSharedOptions, freezeCellsNonIndexMatchingSharedOptions, freezeCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentFreezeCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  freezeCellsSharedOptions = UnsortedComplement[
    Options[ExperimentFreezeCells][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  freezeCellsNonIndexMatchingSharedOptions = UnsortedComplement[
    freezeCellsSharedOptions,
    Cases[OptionDefinition[ExperimentFreezeCells], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  freezeCellsIndexMatchingSharedOptions = UnsortedComplement[
    freezeCellsSharedOptions,
    freezeCellsNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[FreezeCells,
    (* Input Options *)
    Options :> {
      IndexMatching[
        {
          OptionName -> Sample,
          Default -> Null,
          Description -> "The input cell samples to be frozen.",
          AllowNull -> False,
          Category -> "General",
          Widget -> Alternatives[
            "Sample or Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Sample], Object[Container]}],
              Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
            ],
            "Container with Well Position" -> {
              "Well Position" -> Widget[
                Type -> Enumeration,
                Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
                PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Object[Container]}]
              ]
            }
          ],
          Required -> True
        },
        IndexMatchingParent -> Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe = {
      IndexMatching[
        Sequence @@ ({ExperimentFreezeCells, Symbol[#]}&) /@ freezeCellsIndexMatchingSharedOptions,
        IndexMatchingParent -> Sample
      ],
      If[Length[freezeCellsNonIndexMatchingSharedOptions] == 0,
        Nothing,
        Sequence @@ ({ExperimentFreezeCells, Symbol[#]}&) /@ freezeCellsNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions :> insertMe
    ],

    Methods -> {ManualCellPreparation},
    ExperimentFunction -> ExperimentFreezeCells,
    MethodResolverFunction -> resolveFreezeCellsMethod,
    OutputUnitOperationParserFunction -> InternalExperiment`Private`parseFreezeCellsOutputUnitOperation,
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "FreezeCells.png"}]],
    InputOptions -> {Sample},
    LabeledOptions -> {Null -> CryogenicSampleContainerLabel},
    Generative -> True,
    GenerativeLabelOption -> CryogenicSampleContainerLabel,
    Category -> "Cell Preparation",
    Description -> "Freeze cell sample(s) under controlled conditions to enable long-term cryogenic storage.",
    Author -> "tyler.pabst"
  ]
];

(* ImageSample Primitive *)
imageSamplePrimitive = Module[
  {imageSampleSharedOptions,imageSampleNonIndexMatchingSharedOptions,imageSampleIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentImageSample -- except for the funtopia shared options (Cache, Upload, etc.) *)
  imageSampleSharedOptions = UnsortedComplement[
    Options[ExperimentImageSample][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  imageSampleNonIndexMatchingSharedOptions = UnsortedComplement[
    imageSampleSharedOptions,
    Cases[OptionDefinition[ExperimentImageSample], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  imageSampleIndexMatchingSharedOptions = UnsortedComplement[
    imageSampleSharedOptions,
    imageSampleNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[ImageSample,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"The samples or containers to be photographed.",
          AllowNull->False,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              ObjectTypes->{Object[Sample],Object[Container]},
              Dereference->{
                Object[Container]->Field[Contents[[All,2]]]
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
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentImageSample,Symbol[#]}&)/@imageSampleIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[imageSampleNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentImageSample,Symbol[#]}&)/@imageSampleNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    ExperimentFunction->ExperimentImageSample,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseImageSampleOutputUnitOperation,
    MethodResolverFunction->None,
    (* We are not generating SamplesOut so Generative->False *)
    Generative->False,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "ImageSample.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{Sample->SampleLabel},
    Category->"Property Measurement",
    Description->"Captures photographs associated with samples or containers.",
    Methods->{ManualSamplePreparation},
    Author->{"ben", "harrison.gronlund"}
  ]
];

(* MeasureWeight Primitive *)
measureWeightPrimitive = Module[
  {measureWeightSharedOptions,measureWeightNonIndexMatchingSharedOptions,measureWeightIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentMeasureWeight -- except for the funtopia shared options (Cache, Upload, etc.) *)
  measureWeightSharedOptions = UnsortedComplement[
    Options[ExperimentMeasureWeight][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  measureWeightNonIndexMatchingSharedOptions = UnsortedComplement[
    measureWeightSharedOptions,
    Cases[OptionDefinition[ExperimentMeasureWeight], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  measureWeightIndexMatchingSharedOptions = UnsortedComplement[
    measureWeightSharedOptions,
    measureWeightNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MeasureWeight,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"The samples or containers to be weighed.",
          AllowNull->False,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              ObjectTypes->{Object[Sample],Object[Container]},
              Dereference->{
                Object[Container]->Field[Contents[[All,2]]]
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
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentMeasureWeight,Symbol[#]}&)/@measureWeightIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[measureWeightNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentMeasureWeight,Symbol[#]}&)/@measureWeightNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    ExperimentFunction->ExperimentMeasureWeight,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseMeasureWeightOutputUnitOperation,
    MethodResolverFunction->None,
    (* We are not generating SamplesOut so Generative->False *)
    Generative->False,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MeasureWeight.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{Sample->SampleLabel},
    Category->"Property Measurement",
    Description->"Measures weight of given samples or containers.",
    Methods->{ManualSamplePreparation},
    Author->{"xu.yi", "harrison.gronlund"}
  ]
];

(* MeasureVolume Primitive *)
measureVolumePrimitive = Module[
  {measureVolumeSharedOptions,measureVolumeNonIndexMatchingSharedOptions,measureVolumeIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentMeasureVolume -- except for the funtopia shared options (Cache, Upload, etc.) *)
  measureVolumeSharedOptions = UnsortedComplement[
    Options[ExperimentMeasureVolume][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
  ];

  measureVolumeNonIndexMatchingSharedOptions = UnsortedComplement[
    measureVolumeSharedOptions,
    Cases[OptionDefinition[ExperimentMeasureVolume], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
  ];

  measureVolumeIndexMatchingSharedOptions = UnsortedComplement[
    measureVolumeSharedOptions,
    measureVolumeNonIndexMatchingSharedOptions
  ];

  DefinePrimitive[MeasureVolume,
    Options:>{
      IndexMatching[
        {
          OptionName->Sample,
          Default->Null,
          Description->"The samples or containers to be photographed.",
          AllowNull->False,
          Category->"General",
          Widget->Alternatives[
            "Sample or Container"->Widget[
              Type->Object,
              Pattern:>ObjectP[{Object[Sample],Object[Container]}],
              ObjectTypes->{Object[Sample],Object[Container]},
              Dereference->{
                Object[Container]->Field[Contents[[All,2]]]
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
            },
            "Model Sample"->Widget[
              Type -> Object,
              Pattern :> ObjectP[Model[Sample]],
              ObjectTypes -> {Model[Sample]}
            ]
          ],
          Required->True
        },
        IndexMatchingParent->Sample
      ]
    },
    (* Shared Options *)
    With[{insertMe={
      IndexMatching[
        Sequence@@({ExperimentMeasureVolume,Symbol[#]}&)/@measureVolumeIndexMatchingSharedOptions,
        IndexMatchingParent->Sample
      ],
      If[Length[measureVolumeNonIndexMatchingSharedOptions]==0,
        Nothing,
        Sequence@@({ExperimentMeasureVolume,Symbol[#]}&)/@measureVolumeNonIndexMatchingSharedOptions
      ]
    }
    },
      SharedOptions:>insertMe
    ],
    ExperimentFunction->ExperimentMeasureVolume,
    OutputUnitOperationParserFunction->InternalExperiment`Private`parseMeasureVolumeOutputUnitOperation,
    MethodResolverFunction->None,
    (* We are not generating SamplesOut so Generative->False *)
    Generative->False,
    Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "MeasureVolume.png"}]],
    InputOptions->{Sample},
    LabeledOptions->{Sample->SampleLabel},
    Category->"Property Measurement",
    Description->"Measures volume of given samples.",
    Methods->{ManualSamplePreparation},
    Author->{"daniel.shlian", "harrison.gronlund"}
  ]
];

(* ::Section:: *)
(*Primitive Set Definitions*)


(* ::Code::Initialization:: *)
Clear[ExperimentP];
DefinePrimitiveSet[
  ExperimentP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    fluorescencePolarizationPrimitive,
    fluorescencePolarizationKineticsPrimitive,
    alphaScreenPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    filterPrimitive,
    spePrimitive,
    pelletPrimitive,
    fillToVolumePrimitive,
    adjustpHPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    degasPrimitive,
    magneticBeadSeparationPrimitive,
    liquidLiquidExtractionPrimitive,
    precipitatePrimitive,
    flashChromatographyPrimitive,
    coulterCountPrimitive,
    countLiquidParticlesPrimitive,
    growCrystalPrimitive,
    microwaveDigestionPrimitive,
    dynamicLightScatteringPrimitive,
    desiccatePrimitive,
    grindPrimitive,
    measureMeltingPointPrimitive,
    crossflowFiltrationPrimitive,

    (* Cell Related Unit Operations *)
    thawCellsPrimitive,
    incubateCellsPrimitive,
    pcrPrimitive,
    flowCytometryPrimitive,
    imageCellsPrimitive,
    imageColoniesPrimitive,
    lyseCellsPrimitive,
    washCellsPrimitive,
    changeMediaPrimitive,
    pickColoniesPrimitive,
    spreadCellsPrimitive,
    streakCellsPrimitive,
    freezeCellsPrimitive,
    inoculateLiquidMediaPrimitive,
    extractPlasmidDNAPrimitive,
    extractRNAPrimitive,
    extractProteinPrimitive,
    quantifyCellsPrimitive,
    quantifyColoniesPrimitive,

    (* Measure property *)
    measureRefractiveIndexPrimitive,
    visualInspectionPrimitive,
    icpmsPrimitive,
    measureContactAnglePrimitive,
    imageSamplePrimitive,
    measureWeightPrimitive,
    measureVolumePrimitive
  },
  MethodOptions:>{
    ManualSamplePreparation:>{
      ManualSamplePreparationOptions
    },
    RoboticSamplePreparation:>{
      RoboticSamplePreparationOptions
    }
  }
];

Clear[SamplePreparationP];
DefinePrimitiveSet[
  SamplePreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    fluorescencePolarizationPrimitive,
    fluorescencePolarizationKineticsPrimitive,
    alphaScreenPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    filterPrimitive,
    spePrimitive,
    pelletPrimitive,
    fillToVolumePrimitive,
    adjustpHPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    measureRefractiveIndexPrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    degasPrimitive,
    magneticBeadSeparationPrimitive,
    liquidLiquidExtractionPrimitive,
    precipitatePrimitive,
    flashChromatographyPrimitive,
    coulterCountPrimitive,
    countLiquidParticlesPrimitive,
    crossflowFiltrationPrimitive,
    desiccatePrimitive,
    grindPrimitive,
    measureMeltingPointPrimitive,
    visualInspectionPrimitive,
    growCrystalPrimitive,
    microwaveDigestionPrimitive,
    measureContactAnglePrimitive,
    dynamicLightScatteringPrimitive,

    (* Synthesis *)
    pcrPrimitive,

    (* Post Processing *)
    imageSamplePrimitive,
    measureWeightPrimitive,
    measureVolumePrimitive

  },
  MethodOptions:>{
    ManualSamplePreparation:>{
      ManualSamplePreparationOptions
    },
    RoboticSamplePreparation:>{
      RoboticSamplePreparationOptions
    }
  }
];

Clear[ManualSamplePreparationP];
DefinePrimitiveSet[
  ManualSamplePreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    fluorescencePolarizationPrimitive,
    fluorescencePolarizationKineticsPrimitive,
    alphaScreenPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    filterPrimitive,
    spePrimitive,
    pelletPrimitive,
    fillToVolumePrimitive,
    adjustpHPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    measureRefractiveIndexPrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    degasPrimitive,
    magneticBeadSeparationPrimitive,
    flashChromatographyPrimitive,
    coulterCountPrimitive,
    countLiquidParticlesPrimitive,
    crossflowFiltrationPrimitive,
    desiccatePrimitive,
    grindPrimitive,
    measureMeltingPointPrimitive,
    visualInspectionPrimitive,
    growCrystalPrimitive,
    microwaveDigestionPrimitive,
    measureContactAnglePrimitive,
    dynamicLightScatteringPrimitive,

    (* Synthesis *)
    pcrPrimitive,

    (* Post Processing *)
    imageSamplePrimitive,
    measureWeightPrimitive,
    measureVolumePrimitive
  },
  MethodOptions:>{
    ManualSamplePreparation:>{
      ManualSamplePreparationOptions
    }
  }
];

Clear[RoboticSamplePreparationP];
DefinePrimitiveSet[
  RoboticSamplePreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    filterPrimitive,
    spePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    (* FP/FPK can only be done the PheraSTAR, which is not connected to a liquid handler. *)
    (* Nephelometry can only be done on the bioSTAR/microbioSTAR. *)
    alphaScreenPrimitive,
    pelletPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    magneticBeadSeparationPrimitive,
    liquidLiquidExtractionPrimitive,
    precipitatePrimitive
  },
  MethodOptions:>{
    RoboticSamplePreparation:>{
      RoboticSamplePreparationOptions
    }
  }
];

Clear[CellPreparationP];
DefinePrimitiveSet[
  CellPreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    fluorescencePolarizationPrimitive,
    fluorescencePolarizationKineticsPrimitive,
    alphaScreenPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    filterPrimitive,
    spePrimitive,
    pelletPrimitive,
    fillToVolumePrimitive,
    adjustpHPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    magneticBeadSeparationPrimitive,
    liquidLiquidExtractionPrimitive,
    coulterCountPrimitive,
    precipitatePrimitive,
    extractPlasmidDNAPrimitive,
    extractRNAPrimitive,
    extractProteinPrimitive,

    (* Cell Prep *)
    thawCellsPrimitive,
    incubateCellsPrimitive,
    pcrPrimitive,
    flowCytometryPrimitive,
    imageCellsPrimitive,
    imageColoniesPrimitive,
    lyseCellsPrimitive,
    washCellsPrimitive,
    changeMediaPrimitive,
    imageCellsPrimitive,
    pickColoniesPrimitive,
    spreadCellsPrimitive,
    streakCellsPrimitive,
    freezeCellsPrimitive,
    inoculateLiquidMediaPrimitive,
    quantifyCellsPrimitive,
    quantifyColoniesPrimitive
  },
  MethodOptions :> {
    ManualCellPreparation :> {
      ManualSamplePreparationOptions
    },
    RoboticCellPreparation :> {
      RoboticCellPreparationOptions
    }
  }
];

Clear[ManualCellPreparationP];
DefinePrimitiveSet[
  ManualCellPreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    fluorescencePolarizationPrimitive,
    fluorescencePolarizationKineticsPrimitive,
    alphaScreenPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    filterPrimitive,
    spePrimitive,
    pelletPrimitive,
    fillToVolumePrimitive,
    adjustpHPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    magneticBeadSeparationPrimitive,
    coulterCountPrimitive,

    (* Cell Prep *)
    thawCellsPrimitive,
    inoculateLiquidMediaPrimitive,
    incubateCellsPrimitive,
    pcrPrimitive,
    flowCytometryPrimitive,
    imageCellsPrimitive,
    freezeCellsPrimitive,
    quantifyCellsPrimitive,
    quantifyColoniesPrimitive
  },
  MethodOptions :> {
    ManualCellPreparation :> {
      ManualSamplePreparationOptions
    }
  }
];

Clear[RoboticCellPreparationP];
DefinePrimitiveSet[
  RoboticCellPreparationP,
  {
    (* Sample Prep UnitOperations *)
    labelSamplePrimitive,
    labelContainerPrimitive,
    waitPrimitive,
    transferPrimitive,
    incubatePrimitive,
    mixPrimitive,
    centrifugePrimitive,
    filterPrimitive,
    spePrimitive,
    aliquotPrimitive,
    absorbanceSpectroscopyPrimitive,
    absorbanceIntensityPrimitive,
    absorbanceKineticsPrimitive,
    luminescenceSpectroscopyPrimitive,
    luminescenceIntensityPrimitive,
    luminescenceKineticsPrimitive,
    fluorescenceSpectroscopyPrimitive,
    fluorescenceIntensityPrimitive,
    fluorescenceKineticsPrimitive,
    nephelometryPrimitive,
    nephelometryKineticsPrimitive,
    alphaScreenPrimitive,
    pelletPrimitive,
    coverPrimitive,
    uncoverPrimitive,
    serialDilutePrimitive,
    resuspendPrimitive,
    dilutePrimitive,
    magneticBeadSeparationPrimitive,
    liquidLiquidExtractionPrimitive,
    precipitatePrimitive,
    extractPlasmidDNAPrimitive,
    extractRNAPrimitive,
    extractProteinPrimitive,
    quantifyCellsPrimitive,
    quantifyColoniesPrimitive,

    (* Cell Unit Operations *)
    thawCellsPrimitive,
    incubateCellsPrimitive,
    imageCellsPrimitive,
    imageColoniesPrimitive,
    pcrPrimitive,
    lyseCellsPrimitive,
    washCellsPrimitive,
    changeMediaPrimitive,
    pcrPrimitive,
    pickColoniesPrimitive,
    spreadCellsPrimitive,
    streakCellsPrimitive,
    inoculateLiquidMediaPrimitive
  },
  MethodOptions :> {
    RoboticCellPreparation :> {
      RoboticCellPreparationOptions
    }
  }
];