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
      Default -> True,
      Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
    },
    {
      OptionName -> MeasureVolume,
      Default -> True,
      Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
    },
    {
      OptionName -> ImageSample,
      Default -> True,
      Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
      AllowNull -> True,
      Category -> "Post Experiment",
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
        Default -> True,
        Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
        Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
      },
      {
        OptionName -> MeasureVolume,
        Default -> True,
        Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
        Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
      },
      {
        OptionName -> ImageSample,
        Default -> True,
        Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
        AllowNull -> False,
        Category -> "Post Experiment",
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



(* ::Section::Closed:: *)
(*Work Cell to Model Lookup*)


(* ::Code::Initialization:: *)
(* NOTE: List the liquid handlers from smaller to larger here. The order in which they are listed is the preference *)
(* order and we'd like to use the smaller liquid handlers over the larger liquid handlers, if possible, because they're *)
(* cheaper. *)
$WorkCellsToInstruments=<|
  STAR->{
    Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], (* "Hamilton STARlet" *)
    Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"], (* "Super STAR" *)
    Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"] (* "Super STAR (Limited)" *)
  },
  bioSTAR->{
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]
  },
  microbioSTAR->{
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]
  },
  qPix->{
    Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]
  }
|>;

$InstrumentsToWorkCells:=Flatten[
  MapThread[
    Function[{models, cellName}, # -> cellName&/@models],
    {Values[$WorkCellsToInstruments], Keys[Experiment`Private`$WorkCellsToInstruments]}
  ],
  1
];

$WorkCellToExperimentFunction=<|
  STAR -> ExperimentRoboticSamplePreparation,
  bioSTAR -> ExperimentRoboticCellPreparation,
  microbioSTAR -> ExperimentRoboticCellPreparation,
  qPix -> ExperimentRoboticCellPreparation
|>;

ScriptGeneratingPrimitiveFunctionP=Experiment|ExperimentSamplePreparation|ExperimentCellPreparation;
ManualPrimitiveMethodsP=Experiment|ManualSamplePreparation|ManualCellPreparation;
RoboticPrimitiveMethodsP=Experiment|RoboticSamplePreparation|RoboticCellPreparation;

PrimitiveMethodsP=Experiment|ManualSamplePreparation|RoboticSamplePreparation|ManualCellPreparation|RoboticCellPreparation;



(* ::Section:: *)
(*Primitive Definitions*)


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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives", "ExperimentFunction"}]
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
            }
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "ExperimentFunction", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
          Required -> True
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
          Required -> True
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
          Required -> True
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
      MeasuredTransferWeights, MeasuredTransferWeightData, DestinationSampleHandling, PercentTransferred,
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives", "ExperimentFunction"}]
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
            }
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
    WorkCellResolverFunction->Experiment`Private`resolveExperimentCentrifugeWorkCell,

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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  filterSharedOptions =UnsortedComplement[
    Options[ExperimentFilter][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}],
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  speSharedOptions =UnsortedComplement[
    Options[ExperimentSolidPhaseExtraction][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}],
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
            }
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
    Author -> {"robert", "alou"}
  ]
];


(* ::Subsection::Closed:: *)
(*IncubateCells Primitive*)


(* ::Code::Initialization:: *)
incubateCellsPrimitive = Module[{incubateCellsSharedOptions, incubateCellsNonIndexMatchingSharedOptions, incubateCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentIncubateCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  incubateCellsSharedOptions = UnsortedComplement[
    Options[ExperimentIncubateCells][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    (* don't have any labeled options right now and for whatever reason empty list is not allowed so commenting this out so that if we need to add some we can find it easily *)
    (*LabeledOptions -> {},*)
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  flashChromatographySharedOptions =UnsortedComplement[
    Options[ExperimentFlashChromatography][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Author -> {"Yahya.Benslimane", "dima"}
  ]
];



(* ::Subsection::Closed:: *)
(*AdjustpH Primitive*)


(* ::Code::Initialization:: *)
adjustpHPrimitive = Module[{adjustpHSharedOptions, adjustpHNonIndexMatchingSharedOptions, adjustpHIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentAdjustpH -- except for the funtopia shared options (Cache, Upload, etc.) *)
  adjustpHSharedOptions =UnsortedComplement[
    Options[ExperimentAdjustpH][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
    WorkCells -> {STAR},
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation"}]
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

    Methods -> {ManualSamplePreparation, RoboticSamplePreparation},
    WorkCells -> {STAR},
    ExperimentFunction -> ExperimentResuspend,
    MethodResolverFunction -> resolveResuspendMethod,

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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation"}]
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
          Description -> "The samples that should be diluteed.",
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

    Methods -> {ManualSamplePreparation, RoboticSamplePreparation},
    WorkCells -> {STAR},
    ExperimentFunction -> ExperimentDilute,
    MethodResolverFunction -> resolveDiluteMethod,

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
    Author -> {"waseem.vali", "ryan.bisbey"}
  ]
];



(* ::Subsection::Closed:: *)
(*SerialDilute Primitive*)


(* ::Code::Initialization:: *)
serialDilutePrimitive = Module[{serialDiluteSharedOptions, serialDiluteNonIndexMatchingSharedOptions, serialDiluteSourceIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentAliquot -- except for the funtopia shared options (Cache, Upload, etc.) *)
  serialDiluteSharedOptions = UnsortedComplement[
    Options[ExperimentSerialDilute][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
    WorkCells -> {STAR},
    ExperimentFunction -> ExperimentSerialDilute,
    MethodResolverFunction -> resolveSerialDiluteMethod,

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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
                }
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
                }
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
flowCytometryPrimitive = Module[{flowCytometrySharedOptions, flowCytometryNonIndexMatchingSharedOptions,
  flowCytometryIndexMatchingSharedOptions,flowCytometryIndexMatchingSampleSharedOptions,flowCytometryIndexMatchingDetectorSharedOptions,
  flowCytometryIndexMatchingExcitationWavelengthSharedOptions,flowCytometryIndexMatchingBlankSharedOptions},
  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  flowCytometrySharedOptions =UnsortedComplement[
    Options[ExperimentFlowCytometry][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Author -> "hanming.yang"
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
    Flatten[{Options[ProtocolOptions][[All,1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
            }
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
          Widget -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Sample]]
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

    Methods -> {ManualSamplePreparation},
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
    Author -> {"eunbin.go", "jihan.kim"}
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

(* The maximum number of injection samples that each plate reader can hold. *)
$MaxPlateReaderInjectionSamples=2;

(* == NOTE: CLARIOstar (can be reached by STAR/bioSTAR/microSTAR) experiments: == *)
(* AbsorbanceSpectrosocopy, AbsorbanceIntensity, AbsorbanceKinetics *)
(* LuminescenceSpectrosocopy, LuminescenceIntensity, LuminescenceKinetics *)
(* FluorescenceSpectrosocopy, FluorescenceIntensity, FluorescenceKinetics *)
(* AlphaScreen *)

(* == NOTE: Omega (can be reached by STAR) experiments: == *)
(* AbsorbanceSpectrosocopy, AbsorbanceIntensity, AbsorbanceKinetics *)
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
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
        Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}],
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
                }
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
        {"Yahya.Benslimane", "dima"},
        {"Yahya.Benslimane", "dima"},
        {"Yahya.Benslimane", "dima"},
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
    Flatten[{Options[FuntopiaSharedOptions][[All,1]],"Simulation"}]
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
    Author -> {"eunbin.go", "axu"}
  ]
];


(* ::Subsection::Closed:: *)
(*ImageCells Primitive*)


(* ::Code::Initialization:: *)
imageCellsPrimitive=Module[{imageCellsSharedOptions,imageCellsNonIndexMatchingSharedOptions,imageCellsIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentImageCells -- except for the protocol and simulation options (Cache, Upload, etc.) *)
  imageCellsSharedOptions=UnsortedComplement[
    Options[ExperimentImageCells][[All,1]],
    Flatten[{Options[FuntopiaSharedOptions][[All,1]],"Simulation"}]
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
    WorkCells->{bioSTAR},
    ExperimentFunction->ExperimentImageCells,
    RoboticExporterFunction->InternalExperiment`Private`exportImageCellsRoboticPrimitive,
    RoboticParserFunction->InternalExperiment`Private`parseImageCellsRoboticPrimitive,
    MethodResolverFunction->resolveImageCellsMethod,
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
    Flatten[{Options[FuntopiaSharedOptions][[All,1]],"Simulation"}]
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
    Author -> "tim.pierpont"
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Author -> {"Yahya.Benslimane", "dima"}
  ]
];

(* ::Subsection:: *)
(*LiquidLiquidExtraction Primitive*)

liquidLiquidExtractionPrimitive=Module[
  {liquidLiquidExtractionSharedOptions,liquidLiquidExtractionNonIndexMatchingSharedOptions,liquidLiquidExtractionIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentliquidLiquidExtraction -- except for the funtopia shared options (Cache, Upload, etc.) *)
  liquidLiquidExtractionSharedOptions=UnsortedComplement[
    Options[ExperimentLiquidLiquidExtraction][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Author -> {"Yahya.Benslimane", "dima"}
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
    Flatten[{Options[ProtocolOptions][[All,1]],"Simulation","PreparatoryUnitOperations","PreparatoryPrimitives"}]
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
    Methods->{ManualSamplePreparation},
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Author -> "tim.pierpont"
  ]
];


(* ::Subsection:: *)
(* ExtractRNA Primitive *)

extractRNAPrimitive = Module[
  {extractRNASharedOptions, extractRNANonIndexMatchingSharedOptions, extractRNAIndexMatchingSharedOptions},
  (* Copy over all of the options from ExperimentextractRNA -- except for the funtopia shared options (Cache, Upload, etc.) *)
  extractRNASharedOptions = UnsortedComplement[
    Options[ExperimentExtractRNA][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Description -> "Wash living cells in order to remove impurities, debris, metablis, and media from cell samples that prohibits further cell growth or interfers with downstream experiments.",
    Author -> "xu.yi"
  ]
];

(* ::Subsection:: *)
(* ChangeMedia Primitive *)

changeMediaPrimitive = Module[
  {changeMediaSharedOptions, changeMediaNonIndexMatchingSharedOptions, changeMediaIndexMatchingSharedOptions},
  changeMediaSharedOptions = UnsortedComplement[
    Options[ExperimentChangeMedia][[All,1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Description -> "Wash living cells in order to remove impurities, debris, metablis, and media from cell samples that prohibits further cell growth or interfers with downstream experiments.",
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Methods -> {ManualCellPreparation,ManualSamplePreparation}
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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

Authors[ICPMS]:= {"hanming.yang"}

icpmsPrimitive = Module[
  {
    icpmsSharedOptions, icpmsNonIndexMatchingSharedOptions, icpmsIndexMatchingSampleSharedOptions,
    icpmsIndexMatchingElementsSharedOptions, icpmsIndexMatchingExternalStandardSharedOptions
  },

  (* Copy over all options from ExperimentICPMS -- except for the funtopia shared options *)
  icpmsSharedOptions = UnsortedComplement[
    Options[ExperimentICPMS][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Methods -> {ManualSamplePreparation}
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Icon -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", "autoclave.png"}]],
    LabeledOptions ->  {Sample -> SampleLabel},
    InputOptions -> {Sample},
    Generative -> True,
    GenerativeLabelOption -> SampleOutLabel,
    Category -> "Sample Preparation",
    Description -> "Digest sample with microwave to ensure full solubility for subsequent analysis, especially for ICP-MS.",
    Methods -> {ManualSamplePreparation},
    Author -> {"kelmen.low", "harrison.gronlund"}
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives","StandardDilutionCurve", "SerialDilutionCurve"}]
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
          Description -> "The samples that should be analzyed by Dynamic Light Scattering (DLS).",
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
    Author -> {"kelmen.low", "harrison.gronlund"}
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  desiccateSharedOptions =UnsortedComplement[
    Options[ExperimentDesiccate][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}](*,
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  grindSharedOptions =UnsortedComplement[
    Options[ExperimentGrind][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}],
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
  (* be complemented out since FuntopiaSharedOptions contains AliquotOptions. *)
  measureMeltingPointSharedOptions =UnsortedComplement[
    Options[ExperimentMeasureMeltingPoint][[All, 1]],
    Complement[
      Flatten[{Options[ProtocolOptions][[All, 1]], "NumberOfReplicates", "Simulation", "EnableSamplePreparation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}],
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
      Null->PreparedSampleLabel,
      PreparedSampleContainer->PreparedSampleContainerLabel
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

crossflowFiltrationPrimitive = Module[
  {
    crossflowFiltrationSharedOptions, crossflowFiltrationNonIndexMatchingSharedOptions, crossflowFiltrationIndexMatchingPrimeSolutionSharedOptions,
    crossflowFiltrationIndexMatchingSampleSharedOptions
  },

  (* Copy over all of the options from ExperimentTransfer -- except for the funtopia shared options (Cache, Upload, etc.) *)
  crossflowFiltrationSharedOptions =UnsortedComplement[
    Options[ExperimentCrossFlowFiltration][[All, 1]],
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Flatten[{Options[ProtocolOptions][[All, 1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    Methods -> {RoboticCellPreparation},
    WorkCells -> {qPix},
    ExperimentFunction -> ExperimentInoculateLiquidMedia,
    WorkCellResolverFunction -> Experiment`Private`resolveInoculateLiquidMediaWorkCell,
    MethodResolverFunction -> Experiment`Private`resolveInoculateLiquidMediaMethod,
    RoboticExporterFunction -> None,
    RoboticParserFunction -> InternalExperiment`Private`parsePickColoniesRoboticPrimitive,
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
    Flatten[{Options[ProtocolOptions][[All,1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    RoboticParserFunction -> None,
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
    Author -> {"Yahya.Benslimane", "dima"}
  ]
];

(* ::Subsection:: *)
(*StreakCells Primitive*)
streakCellsPrimitive=Module[
  {streakCellsSharedOptions,streakCellsNonIndexMatchingSharedOptions,streakCellsIndexMatchingSharedOptions},

  (* Copy over all of the options from ExperimentStreakCells -- except for the funtopia shared options (Cache, Upload, etc.) *)
  streakCellsSharedOptions=UnsortedComplement[
    Options[ExperimentStreakCells][[All,1]],
    Flatten[{Options[ProtocolOptions][[All,1]], "Simulation", "PreparatoryUnitOperations", "PreparatoryPrimitives"}]
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
    RoboticParserFunction -> None,
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
    Author -> {"Yahya.Benslimane", "dima"}
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
    lyseCellsPrimitive,
    washCellsPrimitive,
    changeMediaPrimitive,
    pickColoniesPrimitive,
    spreadCellsPrimitive,
    streakCellsPrimitive,
    inoculateLiquidMediaPrimitive,
    extractPlasmidDNAPrimitive,
    extractRNAPrimitive,
    extractProteinPrimitive,

    (* Measure property *)
    measureRefractiveIndexPrimitive,
    visualInspectionPrimitive,
    icpmsPrimitive,
    measureContactAnglePrimitive
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
    washCellsPrimitive,
    changeMediaPrimitive,

    (* Synthesis *)
    pcrPrimitive

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
    pcrPrimitive
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
    precipitatePrimitive,
    washCellsPrimitive,
    changeMediaPrimitive
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
    lyseCellsPrimitive,
    washCellsPrimitive,
    changeMediaPrimitive,
    imageCellsPrimitive,
    pickColoniesPrimitive,
    spreadCellsPrimitive,
    streakCellsPrimitive,
    inoculateLiquidMediaPrimitive
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
    inoculateLiquidMediaPrimitive,

    (* Cell Prep *)
    thawCellsPrimitive,
    incubateCellsPrimitive,
    pcrPrimitive,
    flowCytometryPrimitive,
    imageCellsPrimitive
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

    (* Cell Unit Operations *)
    thawCellsPrimitive,
    incubateCellsPrimitive,
    imageCellsPrimitive,
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



(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(* ExperimentSamplePreparation *)


(* ::Code::Initialization:: *)
Error::InvalidUnitOperationHeads="The following unit operation types, `1`, at indices, `2`, are not allowed unit operation types for `3`. Please consult the documentation for `3` or construct your experiment call in the command builder.";
Error::InvalidUnitOperationOptions="The following options, `1`, at indices, `2`, are not valid options for the unit operations, `3`, in `4`. Please only specify valid options for the unit operations chosen.";
Error::InvalidUnitOperationValues="The following options, `1`, at indices, `2`, do not match the allowed pattern for the unit operations, `3`, in `4`. Please make sure that these options match their allowed patterns for `3`.";
Error::InvalidUnitOperationRequiredOptions="The following options, `1`, are required to specify a valid `3` unit operation at indices, `2`, for `4`. Please specify these options in order to specify a valid experiment.";
Error::InvalidUnitOperationMethods="The following methods, `1`, at positions, `2`, are not valid methods for `3`. The supported methods for `3` are `4`. Please remove any incorrectly specified unit operation methods to create a protocol";
Error::InvalidMethodOptions="The following unit operation method heads, `1`, at indices, `3`, have the following invalid options, `2`. Please remove these options in order to specific a valid unit operation method head.";
Error::InvalidMultipleUnitOperationGroups="The inputted unit operations require `1` groupings in order to run in the given order, `2`, via the following preparation methods `3`. Please call the function Experiment[...] instead if you wish to run these unit operations. The current function only supports running one group of unit operations at a time.";
Error::NoWorkCellsPossibleForUnitOperation="The unit operation, `1`, at index, `2`, requires too many containers or instruments in a single work cell when combined with the previous unit operations and thus cannot be executed with the previous unit operations on the same work cell. This `1` unit operation requires, `3` additional container footprints, `4` additional instruments, and `5` additional tips. This results in a total of `6` container footprints, `7` instruments, `8` stacked tip positions of type `9`, and `10` non-stacked tip positions of type `11` for the work cell group. Please split up these unit operations into multiple groups or let ExperimentSamplePreparation automatically resolve the unit operation grouping. Please consult the ExperimentRoboticSamplePreparation/ExperimentRoboticCellPreparation documentation for more information about the available work cells.";
Error::UnknownLabels="The following label(s), `1`, are not defined for the following unit operations at indices, `2`, for unit operations, `3`. Please make sure that the given labels are all defined using another unit operation (such as LabelSample or LabelContainer) before being used in another unit operation.";
Error::UnableToAutofillUnitOperation="We were unable to automatically fill out the input to the unit operation(s), `1`, at indices, `2`. Please specify the inputs to these unit operations.";
Error::NoAvailableUnitOperationMethods="The following unit operations, `1`, at indices, `2` have no available methods that can satisfy all of the specified options for the given samples. Please modify the options given in order to specify a valid unit operation.";
Error::OverwrittenLabels="The following labels, `1`, were overwritten at indices, `2`, for unit operations, `3`. Please make sure that you do not try to reuse the same label when labeling new samples/containers. Please change the labels used at these unit operation indices.";
Error::NoUnitOperations="An empty list of unit operations was given to the function `1`. At least one unit operation must be given in order to specify a valid protocol. Please specify at least one unit operation.";
Error::InjectionSamplesUsedElsewhere="The injection sample(s), `1`, are required by other unit operations (not as injection samples) at indices, `2`. Injection sample(s) must be placed inside of the plate reader instrument(s) and cannot be used on deck. Please split up these unit operations into multiple batches if you would like to use these samples as both injection samples and on deck.";
Warning::TransferDestinationExpanded="The unit operation, `1`, has a singleton container model listed as the destination for multiple sources. Transfer will transfer each of the specified sources into a new instance of the specified destination container model. If the same destination is desired, please consider adding an index to the container model or using the labeling system.";
Error::WorkCellDoesntMatchPattern="The resolved work cell for the primitive, `1`, does not match WorkCellP. Please check your WorkCellResolverFunction or WorkCell option to DefinePrimitive";
Error::WorkCellIsIncompatibleWithMethod="The following method, `1`, is set for the primitive `2`, however, the only WorkCell types compatible with this primitive are of type `3`, which conflict with the chosen method. WorkCell types bioSTAR and microbioSTAR are only compatible with ExperimentRoboticCellPreparation and STAR is only compatible with ExperimentRoboticSamplePreparation. Please review primitive method specification to allow appropriate WorkCell selection.";
Error::WorkCellIsIncompatible="The following workcell, `1`, is set for primitive `2`, however, this experiment can only be performed in the following workcells, `3`. Please change the specified workcell or review the required instrumentation for your protocol to make sure it can be fulfilled by the workcell of your choice.";
Warning::UncoverUnitOperationAdded="The unit operation, `1`, requires that the container(s), `2`, to be uncovered in order to access the samples inside of the container. However, at the time of this unit operation, these containers will be covered with lid(s). An Uncover unit operation has been added automatically before this unit operation in order to uncover the container(s).";
Warning::NoRunTime="The unit operation at index `1` resolved by function `2` did not return valid RunTime. Please investigate.";

(* Cache of previous results in the format {PrimitiveFrameworkFunction, myPrimitives_List} => simulation. *)
(* NOTE: This is important for simulateSamplePreparationPackets since the container overload call MSP first before *)
(* the sample overload does and we need the simulation to not happen again. This is also a performance enhancement. *)
$PrimitiveFrameworkOutputCache=<||>;

(* Store previous resolver results in the form of {resolverFunction, inputs, options, simulationHash} => output. *)
(* NOTE: Onto the regular output specification, we always append the list of captured messages so that messages are thrown *)
(* again if there was an issue. *)
(* NOTE: We hash our simulations because it's faster than doing a straight MatchQ. Additionally, the SimulatedObjects key *)
(* in the simulation can change once we upload our unit operations, so we key drop SimulatedObjects before we hash. *)
$PrimitiveFrameworkResolverOutputCache=<||>;

(* Helper function to KeyDrop if our resolver cache gets too large. *)
(* NOTE: Keys will return keys in order of first added to last added. *)
resizePrimitiveFrameworkCache[]:=If[Length[Keys[$PrimitiveFrameworkResolverOutputCache]]>250,
  KeyDropFrom[
    $PrimitiveFrameworkResolverOutputCache,
    Take[Keys[$PrimitiveFrameworkResolverOutputCache], Ceiling[Length[Keys[$PrimitiveFrameworkResolverOutputCache]]/2]]
  ];
];

(* NOTE: We keep the input pattern here extremely vague because we want to give the user informative messages if their *)
(* input doesn't match the primitive set pattern. *)
(* NOTE: We use the exact same logic for all Experiment, ExperimentSamplePreparation, ExperimentRoboticSamplePreparation, etc. so we use this *)
(* meta function installer. *)
installPrimitiveFunction[myOuterFunction_, myOuterHeldPrimitiveSet_]:=With[{myFunction=myOuterFunction, myHeldPrimitiveSet=myOuterHeldPrimitiveSet},
  Switch[myFunction,
    (* For robotic sample preparation *)
    ExperimentRoboticSamplePreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra options: *)
          RoboticSamplePreparationOptions
        }
      ],
    (* For robotic cell preparation *)
    ExperimentRoboticCellPreparation,
      DefineOptions[myFunction,
        Options :> {
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,

          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra Options. *)
          RoboticCellPreparationOptions
        }
      ],
    (* For manual sample preparation *)
    ExperimentManualSamplePreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },

          (* Extra Options: *)
          ManualSamplePreparationOptions
        }
      ],
    (* For manual cell preparation: *)
    ExperimentManualCellPreparation,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,
          PreparedResourcesOption,

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          }
        }
      ],
    (* For Script generating functions *)
    ScriptGeneratingPrimitiveFunctionP,
      DefineOptions[myFunction,
        Options:>{
          ProtocolOptions,
          SimulationOption,
          DebugOption,
          OptimizeUnitOperationsOption,
          CoverAtEndOption,
          UnitOperationPacketsOption,
          DelayedMessagesOption,

          {
            OptionName -> MeasureWeight,
            Default -> True,
            Description -> "Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },
          {
            OptionName -> MeasureVolume,
            Default -> True,
            Description -> "Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },
          {
            OptionName -> ImageSample,
            Default -> True,
            Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
            AllowNull -> False,
            Category -> "Post Experiment",
            Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
          },

          (* NOTE: This function can return additional outputs of Input and Simulation. *)
          {
            OptionName->Output,
            Default->Result,
            AllowNull->True,
            Widget->Alternatives[
              Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]],
              Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Input, Simulation]]]
            ],
            Description->"Indicate what the function should return.",
            Category->"Hidden"
          },

          {
            OptionName->PreviewFinalizedUnitOperations,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if Output->Input should return the unit operations in their finalized form (with optimization, if OptimizeUnitOperations->True, and unit operation method wrappers, if they were not originally specified).",
            Category->"Hidden"
          },

          {
            OptionName->InputsFunction,
            Default->False,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if we're being called from ExperimentBLAHInputs. If InputsFunction->True and PreviewFinalizedUnitOperations->True, we will return calculated inputs with method groupings. Otherwise, we will return optimized primitives with method groupings.",
            Category->"Hidden"
          },
          {
            OptionName->IgnoreWarnings,
            Default->True,
            AllowNull->False,
            Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
            Description->"Indicates if the script should be continued even if warnings are thrown.",
            Category->"General"
          }
        }
      ]
  ];

(* Install empty list overload that throws an error. *)
myFunction[myPrimitives:{}, myOptions:OptionsPattern[]]:=Module[{},
  Message[Error::NoUnitOperations, myFunction];

  $Failed
];

(* Install overload the redirects to the main function. *)
myFunction[myPrimitive:Except[_List], myOptions:OptionsPattern[]]:=myFunction[{myPrimitive}, myOptions];

(* Install the main function. *)
myFunction[myPrimitives_List, myOptions:OptionsPattern[]]:=Block[{$ProgressPrinting=False},Module[
  {outputSpecification, output, gatherTests, safeOps, safeOpsTests, primitiveSetInformation, allPrimitiveInformation, primitiveHeads,
    invalidPrimitiveHeadsWithIndices, invalidPrimitiveOptionKeysWithIndices, invalidPrimitiveOptionPatternsWithIndices,
    invalidPrimitiveRequiredOptionsWithIndices, templatedOptions, templateTests, inheritedOptions, expandedSafeOps,
    invalidMethodWrappers, invalidMethodWrapperPositions, primitiveMethods, flattenedPrimitives, primitivesWithResolvedMethods,resolvedPrimitiveMethodResult,
    invalidPrimitiveMethodIndices, primitivesWithPreresolvedInputs, invalidLabelPrimitivesWithIndices, invalidAutofillPrimitivesWithIndices,
    invalidResolvePrimitiveMethodsWithIndices, allResolverTests, allPrimitiveGroupings, allPrimitiveGroupingWorkCellInstruments, currentPrimitiveGrouping,
    currentPrimitiveGroupingLabeledObjects, currentPrimitiveGroupingFootprints, currentPrimitiveGroupingTips,
    fakeContainer, fakeWaterSample, currentSimulation, previousSimulation, resolvedPrimitives, currentPrimitiveGroupingDateStarted, currentPrimitiveDateStarted, primitiveMethodIndexToOptionsLookup, invalidMethodOptionsWithIndices,
    allPrimitiveOptionGroupings, allPrimitiveInputGroupings, noInstrumentsPossibleErrorsWithIndices, currentPrimitiveGroupingPotentialWorkCellInstruments,
    currentPrimitiveOptionGrouping, currentPrimitiveInputGrouping, allPrimitiveGroupingResources, allTipModels, workCellModelPackets,
    workCellObjectPackets, tipModelPackets, microbialQ, footprintInformationKeys, allPrimitiveGroupingTips, allPrimitiveGroupingFootprints,
    allLabelFieldsWithIndicesGroupings, allPrimitiveOptionsWithLabelFieldsGroupings, currentLabelFieldsWithIndices,
    primitiveIndexToScriptVariableLookup, outputResult, currentPrimitiveGroupingRunTimes, allPrimitiveGroupingRunTimes,
    flattenedIndexMatchingPrimitives, cacheBall, containerPackets, samplePackets, sampleModelPackets, allContainerContentsPackets, allSamplePackets, allContainerModelPackets, containerModelToPosition,allContainerPackets,
    transferDestinationSampleLabelCounter, debug, invalidInputIndices, simulatedObjectsToLabelOutput, parentProtocolStack, rootProtocol,
    resolvedInput, allPrimitiveInputsWithLabelFieldsGroupings, allUnresolvedPrimitiveGroupings, currentUnresolvedPrimitiveGrouping,
    invalidResolverPrimitives, incompatibleWorkCellAndMethod, resolvedOptions, fakeWaterSimulation, errorCheckingMessageCell, simulationPreparationMessageCell,
    primitiveMethodMessageCell, simulation, parentProtocol, allObjects, missingObjects,intersectionLabels,overwrittenLabels,
    allOverwrittenLabelsWithIndices, optimizedPrimitives, nonIndexMatchingPrimitiveOptions, optimizeUnitOperations,
    doNotOptimizeQ, frqTests, nonObjectResources, currentPrimitiveGroupingIntegratedInstrumentsResources, allPrimitiveGroupingIntegratedInstrumentResources,
    sanitizedPrimitives, validLengthsQList, throwMessageWithPrimitiveIndex, allPrimitiveGroupingIncubatorContainerResources,
    currentPrimitiveGroupingIncubatorPlateResources, allPrimitiveGroupingAmbientContainerResources, currentPrimitiveGroupingAmbientPlateResources,
    fulfillableQ, allPrimitiveGroupingWorkCellIdlingConditionHistory, currentPrimitiveGroupingWorkCellIdlingConditionHistory,
    startNewPrimitiveGrouping, computeLabeledObjectsAndFutureLabeledObjects, finalOutput, allPrimitiveGroupingUnitOperationPackets,allPrimitiveGroupingBatchedUnitOperationPackets,
    currentPrimitiveGroupingUnitOperationPackets, currentPrimitiveGroupingBatchedUnitOperationPackets, sanitizedPrimitivesWithUnitOperationObjects, labelFieldGroupings,
    allUnresolvedPrimitivesWithLabelFieldGroupings, previewFinalizedUnitOperations, modelContainerFields,
    objectSampleFields, modelSampleFields, objectContainerFields, unitOperationPacketsQ, outputRules, invalidInjectorResourcesWithIndices,
    outputUnitOperationObjectsFromCache, liquidHandlerCompatibleRacks, accumulatedFulfillableResourceQ,delayedMessagesQ,
    liquidHandlerCompatibleRackPackets, inputsFunctionQ, coverOptimizedPrimitives, addedCoverAtEndPrimitiveQ, index, coverAtEnd,
    ignoreWarnings, primitiveIndexToOutputUnitOperationLookup, tipResources, nonTipResources, gatheredTipResources, combinedTipResources,
    counterWeightResources, counterWeightResourceReplacementRules, uniqueCounterweightResources, combinedCounterWeightResources,
    accumulatedFRQTests, placeholderFunction,userWorkCellChoice,specifiedWorkCell,containerModelFieldsList,totalWorkCellTime
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Are we running in debug mode? *)
  debug=Lookup[ToList[myOptions], Debug, False];
  simulation=Lookup[ToList[myOptions], Simulation, Null];
  parentProtocol=Lookup[ToList[myOptions], ParentProtocol, Null];
  optimizeUnitOperations=Lookup[ToList[myOptions], OptimizeUnitOperations, True];
  coverAtEnd=Lookup[ToList[myOptions], CoverAtEnd, Automatic]/.{Automatic->optimizeUnitOperations};
  previewFinalizedUnitOperations=Lookup[ToList[myOptions], PreviewFinalizedUnitOperations, True];
  inputsFunctionQ=Lookup[ToList[myOptions], InputsFunction, False];
  unitOperationPacketsQ = Lookup[ToList[myOptions], UnitOperationPackets, False];
  delayedMessagesQ = Which[
    (* If it is specified, use it *)
    !NullQ[Lookup[ToList[myOptions], DelayedMessages, Null]],
    Lookup[ToList[myOptions], DelayedMessages, Null],

    (* If debug is true, turn off delayed messages *)
    debug,False,

    (* Otherwise set to True *)
    True,True
  ];

  (* Set our size limit to a large number if we're debugging. *)
  If[MatchQ[debug, True],
    $SummaryBoxDataSizeLimit=10^15
  ];

  (* See if we already have a cached result. We only cache results when there are no errors thrown. *)
  If[KeyExistsQ[$PrimitiveFrameworkOutputCache, {myFunction, myPrimitives, MemberQ[output, Tests]}],
    (* NOTE: We can't use our cache if the user is asking for Output->Result because we need to generate a new protocol *)
    (* object. UNLESS they also gave us a simulation -- we assume that this means they won't upload the result. *)
    (* NOTE: Even if the user is asking for a new protocol and we can't use $PrimitiveFrameworkOutputCache, our primitive *)
    (* specific cache should save us a lot of time still. *)
    (* NOTE: This is used in the primitive framework since aliquot resolution happens both in resolveSamplePrepOptionsNew and *)
    (* in resolveAliquotOptions and we want it to memoize. *)
    If[Or[
        MemberQ[output, Result] && MatchQ[simulation, SimulationP],
        !MemberQ[output, Result]
      ],
      Return[outputSpecification/.Lookup[$PrimitiveFrameworkOutputCache, Key[{myFunction, myPrimitives, ToList[myOptions], MemberQ[output, Tests]}]]]
    ]
  ];

  (* Resize our cache, if necessary. *)
  resizePrimitiveFrameworkCache[];

  (* Update our global simulation, if we have one. This is because we lookup directly from $CurrentSimulation to find *)
  (* SimulatedObjects. *)
  If[MatchQ[$CurrentSimulation, SimulationP] && !MatchQ[Lookup[$CurrentSimulation[[1]], Updated], True],
    $CurrentSimulation=UpdateSimulation[Simulation[], $CurrentSimulation];
  ];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOps,safeOpsTests}=If[gatherTests,
    SafeOptions[myFunction,ToList[myOptions],AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[myFunction,ToList[myOptions],AutoCorrect->False],{}}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (* Sanitize our inputs. *)
  sanitizedPrimitivesWithUnitOperationObjects=(sanitizeInputs[myPrimitives]/.{link:LinkP[] :> Download[link, Object]});

  (* Make sure that there aren't invalid objects. *)
  (* don't actually pull objects out of cache or simulation *)
  allObjects=DeleteDuplicates[Cases[{sanitizedPrimitivesWithUnitOperationObjects, KeyDrop[Association[myOptions], {Cache, Simulation}]}, ObjectP[], Infinity]];
  missingObjects=PickList[
    allObjects,
    DatabaseMemberQ[allObjects, Simulation->simulation],
    False
  ];

  If[Length[missingObjects]>0,
    Message[Error::MissingObjects, missingObjects];
    Message[Error::InvalidInput, missingObjects];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (* -- STAGE 0: Convert any Object[UnitOperation]s that we have into Unit Operation Primitives -- *)
  If[debug, Echo["Beginning Stage 0: Converting any Object[UnitOperation]s to Unit Operation Primitives"]];

  (* Replace the unit operation objects. *)
  sanitizedPrimitives=Module[{userInputtedUnitOperationObjectsWithoutBoxForms, userInputtedUnitOperationObjects, userInputtedUnitOperationPackets, userInputtedUnitOperationObjectToPrimitive},
    (* If the user copied the box form of the unit operation object, we will get something that looks like Head[PacketP[]]. *)
    (* Convert these into raw unit operation objects. *)
    userInputtedUnitOperationObjectsWithoutBoxForms=(If[MatchQ[#, (_Symbol)[PacketP[]]], Lookup[#[[1]], Object], #]&)/@sanitizedPrimitivesWithUnitOperationObjects;

    (* Find any unit operation objects that were given as input. *)
    userInputtedUnitOperationObjects=DeleteDuplicates@Cases[userInputtedUnitOperationObjectsWithoutBoxForms, ObjectReferenceP[Object[UnitOperation]], Infinity];

    (* Download our unit operation objects. *)
    userInputtedUnitOperationPackets=Download[userInputtedUnitOperationObjects, Packet[All], Simulation -> simulation];

    (* Convert each of these packets into a primitive. *)
    userInputtedUnitOperationObjectToPrimitive=(
      Lookup[#, Object]->ConstellationViewers`Private`UnitOperationPrimitive[#, IncludeCompletedOptions->False, IncludeEmptyOptions->False]
    &)/@userInputtedUnitOperationPackets;

    (sanitizeInputs[userInputtedUnitOperationObjectsWithoutBoxForms/.userInputtedUnitOperationObjectToPrimitive]/.{link:LinkP[] :> Download[link, Object]})
  ];

  (* -- STAGE 1: Primitive Pattern Checks -- *)
  If[debug, Echo["Beginning stage 1: InitialPrimitive error checking"]];

  (* Tell the user that we're error checking. *)
  errorCheckingMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Checking Given Unit Operations For Basic Errors",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, myHeldPrimitiveSet];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
  primitiveHeads=Keys[allPrimitiveInformation];

  (* Figure out what methods (wrapper headers) are allowed by looking at the primitive methods allowed in each of our primitives. *)
  primitiveMethods=DeleteDuplicates[Flatten[Lookup[Values[allPrimitiveInformation], Methods]]];

  (* First go through our unflattened primitives and see if there are any invalid method heads. *)
  invalidMethodWrapperPositions=Position[
    sanitizedPrimitives,
    (* Get everything that does not look like a single primitive or a valid method wrapper head. *)
    _?(MatchQ[#, Except[_Symbol[_Association]]] && !MatchQ[#, (Alternatives@@primitiveMethods)[___]]&),
    1,
    Heads->False
  ];
  invalidMethodWrappers=Extract[sanitizedPrimitives, invalidMethodWrapperPositions];

  (* If we have things that look like invalid wrappers, yell and return early. *)
  If[Length[invalidMethodWrappers]>0,
    Message[Error::InvalidUnitOperationMethods, (Head/@invalidMethodWrappers), invalidMethodWrapperPositions, myFunction, primitiveMethods];
    Message[Error::InvalidInput, invalidMethodWrappers];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Now that we've verified that any primitive wrappers that we were given are valid, flatten out our primitives so we can *)
  (* map like normal. *)

  (* NOTE: We add the key PrimitiveMethod->PrimitiveMethodP if our primitive was originally in a method wrapper head. *)
  (* This option isn't exposed to the user and is only used internally in this function to resolve things. It is automatically *)
  (* included in our primitive pattern builder though. *)

  (* NOTE: We also add the PrimitiveMethodIndex->_Integer key if the primitive was originally in a method wrapper head. *)
  (* This is so that we can respect the user's wishes in terms of splitting up the work cell runs. *)
  flattenedPrimitives=Which[
    (* If the user gave us some primitive method wrappers, make sure to fill out the PrimitiveMethodIndex. *)
    !MatchQ[sanitizedPrimitives, {_Symbol[_Association]..}],
      MapThread[
        Function[{listElement, listIndex},
          (* Does this look like a wrapper and not an individual primitive? *)
          If[MatchQ[listElement, Except[_Symbol[_Association]]],
            (* We have a method wrapper. *)
            Sequence@@(
              (
                Head[#]@Append[
                  (* NOTE: If our primitive is so messed up, we will not get an association when we take off the head. *)
                  (* Attempt to get it into a valid format for later error checking. *)
                  If[MatchQ[#[[1]], _Association],
                    #[[1]],
                    Association[(Switch[#, _Rule, #, _Symbol, #->Null, _, Nothing]&)/@(List@@#)]
                  ],
                  {
                    PrimitiveMethod->Head[listElement],
                    PrimitiveMethodIndex->listIndex
                  }
                ]
              (* NOTE: We're filtering out _Rule here because each primitive wrapper can have additional options that can be set. *)
              &)/@(Cases[List@@listElement, Except[_Rule]])
            ),
            (* We just have a single primitive. *)
            listElement
          ]
        ],
        {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
      ],
    (* If the user is calling RSP or RCP directly, they're telling us that they want the UOs to be done in a single run. *)
    MatchQ[myFunction, ExperimentRoboticSamplePreparation | ExperimentRoboticCellPreparation],
      (
        Head[#]@Append[
          #[[1]],
          PrimitiveMethodIndex->1
        ]
      &)/@sanitizedPrimitives,
    (* Otherwise, there is no PrimitiveMethodIndex information to set. *)
    True,
      sanitizedPrimitives
  ];

  (* Helper function to prepend primitive index information to a message association. *)
  throwMessageWithPrimitiveIndex[messageAssociation_, index_, primitiveHead_, simulation_]:=Module[{permanentlyIgnoredMessages},
    (* Only bother throwing the message if it's not Error::InvalidInput or Error::InvalidOption. *)
    permanentlyIgnoredMessages = {Hold[Error::InvalidInput],Hold[Error::InvalidOption]};
    If[And[
        !MatchQ[Lookup[messageAssociation, MessageName], Alternatives@@permanentlyIgnoredMessages],
        !MatchQ[ReleaseHold[Lookup[messageAssociation, MessageName]], $Off[_]]
      ],
      Module[{messageTemplate, numberOfMessageArguments, specialHoldHead, messageSymbol, messageTag, newMessageTemplate, messageArguments},
        (* Get the text of our message template. *)
        (* NOTE: Some messages don't evaluate by themselves (ex. Lookup::invrl). *)
        messageTemplate=If[MatchQ[ReleaseHold[Lookup[messageAssociation, MessageName]], _String],
          ReleaseHold[Lookup[messageAssociation, MessageName]],
          With[{messageHead=First[ReleaseHold[Lookup[messageAssociation, MessageName]]]},
            ReleaseHold[Lookup[messageAssociation, MessageName]] /. Messages[messageHead]
          ]
        ];

        (* Get the number of arguments that we have. *)
        numberOfMessageArguments=Length[Lookup[messageAssociation, MessageArguments]];

        (* Create a special hold head that we will replace our Hold[messageName] with. *)
        SetAttributes[specialHoldHead, HoldAll];

        (* Extract the message symbol and tag. *)
        messageSymbol=Extract[Lookup[messageAssociation, MessageName], {1,1}];
        messageTag=Extract[Lookup[messageAssociation, MessageName], {1,2}];

        (* Create a new message template string. *)
        newMessageTemplate="The following message was thrown at unit operation index `"<>ToString[numberOfMessageArguments+1]<>"` ("<>ToString[primitiveHead]<>"): "<>ToString[messageTemplate];

        (* If we have a simulation, map any simulated sample IDs into labels. *)
        (* NOTE: We could get the samples in ObjectP[] form or in string form since ObjectToString could have been called. *)
        messageArguments=If[MatchQ[simulation, SimulationP],
          Module[{objectToLabelRules, stringObjectToLabelRules},
            (* Create our simulated sample to label replace rules. *)
            objectToLabelRules=(ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[simulation[[1]], Labels];
            stringObjectToLabelRules=If[Length[Lookup[simulation[[1]], Labels]]>0,
              Rule@@@Transpose[{ObjectToString[Lookup[simulation[[1]], Labels][[All, 2]], OutputFormat->Expression], Lookup[simulation[[1]], Labels][[All, 1]]}],
              {}
            ];

            (If[MatchQ[#, _String], StringReplace[#, stringObjectToLabelRules], #/.objectToLabelRules]&)/@Lookup[messageAssociation, MessageArguments]
          ],
          Lookup[messageAssociation, MessageArguments]
        ];

        (* Block our the head of our message name. This prevents us from overwriting in the real codebase since *)
        (* message name information is stored in the LanguageDefinition under the head (see Language`ExtendedDefinition *)
        (* if you're interested). *)
        With[{insertedMessageSymbol=messageSymbol},
          Block[{insertedMessageSymbol},
            Module[{messageNameWithSpecialHoldHead, heldMessageSet},
              (* Replace the hold around the message name with our special hold head. *)
              messageNameWithSpecialHoldHead=Lookup[messageAssociation, MessageName]/.{Hold->specialHoldHead};

              (* Create a held set that will overwrite the message name. *)
              heldMessageSet=With[{insertMe1=messageNameWithSpecialHoldHead, insertMe2=newMessageTemplate},
                Hold[insertMe1=insertMe2]
              ]/.{specialHoldHead[sym_]:>sym};

              (* Do the set. *)
              ReleaseHold[heldMessageSet];

              (* Throw the message that has been modified. *)
              With[{insertMe=messageTag},
                Message[
                  MessageName[insertedMessageSymbol, insertMe],
                  Sequence@@Append[messageArguments, index]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ];

  (* Keep track of invalid primitives to throw messages about. *)
  invalidPrimitiveHeadsWithIndices={};
  invalidPrimitiveOptionKeysWithIndices={};
  invalidPrimitiveOptionPatternsWithIndices={};
  invalidPrimitiveRequiredOptionsWithIndices={};

  (* Go through each of our primitives and check them. *)
  MapThread[
    Function[{currentPrimitive, primitiveIndex},
      Module[{primitiveDefinition},
        (* Get the definition for this primitive, within the primitive set. *)
        primitiveDefinition=Lookup[allPrimitiveInformation, Head[currentPrimitive]];

        Which[
          (* First, check that the primitive head exists in our primitive set. *)
          !MatchQ[Head[currentPrimitive], Alternatives@@primitiveHeads],
            AppendTo[invalidPrimitiveHeadsWithIndices, {Head[currentPrimitive], primitiveIndex}],

          (* Next, make sure that for the primitive head that we have, all the options match their pattern. *)
          (* NOTE: We specifically form the primitive pattern for each primitive set to only include the options that relate *)
          (* to that primtiive set (for each primitive). So, we can first just do a pattern match to see if all the options are okay. *)
          !MatchQ[currentPrimitive, Lookup[primitiveDefinition, Pattern]],
            Module[{invalidOptionKeys, invalidOptionPatterns, requiredOptions, missingRequiredOptions},
              (* Get any options that don't exist in the primitive definition. *)
              invalidOptionKeys=Complement[
                Keys[currentPrimitive[[1]]],
                Flatten[{Lookup[Lookup[primitiveDefinition, OptionDefinition], "OptionSymbol"], PrimitiveMethod, PrimitiveMethodIndex}]
              ];

              If[Length[invalidOptionKeys]>0,
                AppendTo[invalidPrimitiveOptionKeysWithIndices, {invalidOptionKeys, primitiveIndex, Head[currentPrimitive]}];
              ];

              (* Get any options that don't match their pattern. *)
              invalidOptionPatterns=KeyValueMap[
                Function[{option, value},
                  Module[{optionPattern},
                    (* Get the pattern for this option. If the option doesn't exist in the definition, just skip over it because it *)
                    (* will be covered by our invalidOptionKeys check. *)
                    optionPattern=ReleaseHold@Lookup[
                      FirstCase[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["OptionSymbol"->option], <|"Pattern"->_|>],
                      "Pattern"
                    ];

                    If[!MatchQ[value, optionPattern],
                      option,
                      Nothing
                    ]
                  ]
                ],
                currentPrimitive[[1]]
              ];

              If[Length[invalidOptionPatterns]>0,
                AppendTo[invalidPrimitiveOptionPatternsWithIndices, {invalidOptionPatterns, primitiveIndex, Head[currentPrimitive]}];
              ];

              (* Detect if we are missing required options. *)
              requiredOptions=Lookup[Cases[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["Required"->True]], "OptionSymbol"];
              missingRequiredOptions=Complement[requiredOptions, Keys[currentPrimitive[[1]]]];

              If[Length[missingRequiredOptions]>0,
                AppendTo[invalidPrimitiveRequiredOptionsWithIndices, {missingRequiredOptions, primitiveIndex, Head[currentPrimitive]}];
              ];
            ],

          (* In our pattern we exempted the first input options from being required (even if it was marked as Required) because *)
          (* it can usually be autofilled. This is true for all primitives except for the first one. If we're the first primitive, *)
          (* make sure that we have our first primitive filled out. *)
          MatchQ[primitiveIndex, 1] && Length[Lookup[primitiveDefinition, InputOptions]]>0,
            Module[{firstInputOption},
              firstInputOption=FirstOrDefault[Lookup[primitiveDefinition, InputOptions]];

              If[!KeyExistsQ[currentPrimitive[[1]], firstInputOption],
                AppendTo[invalidPrimitiveRequiredOptionsWithIndices, {{firstInputOption}, primitiveIndex, Head[currentPrimitive]}]
              ];
            ],

          (* All of the primitives look good! *)
          True,
          Null
        ]
      ]
    ],
    {flattenedPrimitives, Range[Length[flattenedPrimitives]]}
  ];

  (* If we encountered any bad primitives, yell about them and return $Failed. *)
  If[Length[invalidPrimitiveHeadsWithIndices]>0,
    Message[Error::InvalidUnitOperationHeads, invalidPrimitiveHeadsWithIndices[[All,1]], invalidPrimitiveHeadsWithIndices[[All,2]], myFunction];
  ];

  If[Length[invalidPrimitiveOptionKeysWithIndices]>0,
    Message[Error::InvalidUnitOperationOptions, invalidPrimitiveOptionKeysWithIndices[[All,1]], invalidPrimitiveOptionKeysWithIndices[[All,2]], invalidPrimitiveOptionKeysWithIndices[[All,3]], myFunction];
  ];

  If[Length[invalidPrimitiveOptionPatternsWithIndices]>0,
    Message[Error::InvalidUnitOperationValues, invalidPrimitiveOptionPatternsWithIndices[[All,1]], invalidPrimitiveOptionPatternsWithIndices[[All,2]], invalidPrimitiveOptionPatternsWithIndices[[All,3]], myFunction];
  ];

  If[Length[invalidPrimitiveRequiredOptionsWithIndices]>0,
    Message[Error::InvalidUnitOperationRequiredOptions, invalidPrimitiveRequiredOptionsWithIndices[[All,1]], invalidPrimitiveRequiredOptionsWithIndices[[All,2]], invalidPrimitiveRequiredOptionsWithIndices[[All,3]], myFunction];
  ];

  If[Or[
    Length[invalidPrimitiveHeadsWithIndices]>0,
    Length[invalidPrimitiveOptionKeysWithIndices]>0,
    Length[invalidPrimitiveOptionPatternsWithIndices]>0,
    Length[invalidPrimitiveRequiredOptionsWithIndices]>0
  ],
    (* NOTE: If we're in the builder, we don't want to include the entire unit operation since they won't blob in the text display. *)
    If[MatchQ[$ShortenErrorMessages, True],
      Message[
        Error::InvalidInput,
        shortenPrimitives[
          flattenedPrimitives[[DeleteDuplicates[Flatten[{
            invalidPrimitiveHeadsWithIndices[[All,2]],
            invalidPrimitiveOptionKeysWithIndices[[All,2]],
            invalidPrimitiveOptionPatternsWithIndices[[All,2]],
            invalidPrimitiveRequiredOptionsWithIndices[[All,2]]
          }]]]]
        ]
      ],
      Message[
        Error::InvalidInput,
        flattenedPrimitives[[DeleteDuplicates[Flatten[{
          invalidPrimitiveHeadsWithIndices[[All,2]],
          invalidPrimitiveOptionKeysWithIndices[[All,2]],
          invalidPrimitiveOptionPatternsWithIndices[[All,2]],
          invalidPrimitiveRequiredOptionsWithIndices[[All,2]]
        }]]]]
      ]
    ];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Expand the options for each of our primitives so that we have index-matching. *)
  (* Since ExpandIndexMatchedInputs only works on functions, we have to make a "fake" function with the same information *)
  (* as our primitive so that we can do the expanding. *)
  {flattenedIndexMatchingPrimitives, nonIndexMatchingPrimitiveOptions, validLengthsQList}=Transpose@MapThread[
    Function[{primitive, primitiveIndex},
      Block[{placeholderFunction},
        Module[{primitiveInformation, optionDefinition, primaryInputOption, optionsWithListedPrimaryInput, expandedPrimitive, nonIndexMatchingOptionsForPrimitiveHead, nonIndexMatchingOptions, validLengthsQ, destinationUpdateWarning, expandedOptions, multipleMultipleExpandedOptions, expandedOptionsWithoutMultipleMultiples},
          (* Lookup our primitive information. *)
          primitiveInformation=Lookup[Lookup[primitiveSetInformation, Primitives], Head[primitive], {}];

          (* Lookup the option definition of this primitive. *)
          optionDefinition=Lookup[primitiveInformation, OptionDefinition];

          (* Take the option definition for the head of this primitive and set it as the option definition of our fake function. *)
          placeholderFunction /: OptionDefinition[placeholderFunction] = OverwriteAliquotOptionDefinition[placeholderFunction, optionDefinition];

          (* NOTE: Even though we shouldn't have any inputs, we have to put some inputs and output here, otherwise DefineUsage *)
          (* will get angry. There is no index matching to the usage, so this is just for show. *)
          DefineUsage[placeholderFunction,
            {
              BasicDefinitions -> {
                {
                  Definition -> {"ExperimentAbsorbanceIntensity[samples]", "protocol"},
                  Description -> "",
                  Inputs :> {
                    {
                      InputName -> "samples",
                      Description -> "The samples to be measured.",
                      Widget -> Adder[Widget[
                        Type -> Enumeration,
                        Pattern :> Alternatives[Null]
                      ]],
                      Expandable -> False
                    }
                  },
                  Outputs :> {
                    {
                      OutputName -> "protocol",
                      Description -> "A protocol object for measuring absorbance of samples at a specific wavelength.",
                      Pattern :> ObjectP[Object[Protocol, AbsorbanceIntensity]]
                    }
                  }
                }
              },
              SeeAlso -> {
                "Download"
              },
              Author -> {
                "thomas"
              }
            }
          ];
          (* Get our primary input option. *)
          primaryInputOption=FirstOrDefault[Lookup[primitiveInformation, InputOptions], Null];

          (* Always ToList our primary input option. This is because if we are given ONLY singletons, the expander will *)
          (* leave everything as a singleton. We always want lists for consistency. *)
          (* NOTE: Make sure not to ToList if our primary input option isn't IndexMatching (as in the case of Wait). *)
          (* NOTE: This logic is mirrored in UploadUnitOperation so make sure that if it changes here to also change it there. *)
          optionsWithListedPrimaryInput=If[And[
              MatchQ[primaryInputOption, Except[Null]],
              KeyExistsQ[primitive[[1]], primaryInputOption],
              !MatchQ[
                Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionSymbol"->primaryInputOption], <||>], "IndexMatching", "None"],
                "None"
              ],
              (* NOTE: If there's already an expanded input or option, we don't have to ToList our primary input. In fact, we cannot *)
              (* since if another input is over length 1, this will cause our primitive to not expand. *)
              !MemberQ[
                (
                  If[!KeyExistsQ[primitive[[1]], Lookup[#, "OptionSymbol"]],
                    True,
                    MatchQ[
                      Lookup[primitive[[1]], Lookup[#, "OptionSymbol"]],
                      ReleaseHold@Lookup[
                        #,
                        "SingletonPattern",
                        _
                      ]
                    ]
                  ]
                &)/@Cases[optionDefinition, KeyValuePattern["IndexMatchingParent"->ToString@primaryInputOption]],
                False
              ]
            ],
            Normal@Append[
              primitive[[1]],
              primaryInputOption->{Lookup[primitive[[1]], primaryInputOption]}
            ],
            Normal@(primitive[[1]])
          ];

          (* We take each container model to be a different container in SP. If the user specifies multiple sources and one destination container in the form of a model in a transfer primitive, we will expand that to a bunch of container models so each source ends up getting transferred to a different container. We are giving user a warning about this. *)
          destinationUpdateWarning=If[
            And[
              MatchQ[primitive,_Transfer],
              Length[ToList[Lookup[optionsWithListedPrimaryInput,primaryInputOption]]]>1,
              MatchQ[Lookup[optionsWithListedPrimaryInput,Destination],ObjectP[Model[Container]]]
            ],
            Message[Warning::TransferDestinationExpanded,primitive]
          ];

          (* If we don't have any options at all, then don't try to expand the options. *)
          (* NOTE: There's some stupid shit that I (Thomas) wrote 4 years ago in ValidInputLengthsQ where it hardcode checks *)
          (* the input against the length of AliquotContainer. *)
          expandedOptions = ExpandIndexMatchedInputs[
            placeholderFunction,
            (* We don't have an input, but just pass down Null to make the expander happy. *)
            {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
            optionsWithListedPrimaryInput,
            1,
            FastTrack -> True,
            Messages -> False
          ][[2]];

          (* get the multiple multiple options for Filter *)
          multipleMultipleExpandedOptions = {
            RetentateWashBuffer,
            RetentateWashVolume,
            NumberOfRetentateWashes,
            RetentateWashDrainTime,
            RetentateWashCentrifugeIntensity,
            RetentateWashMix,
            NumberOfRetentateWashMixes,
            RetentateWashPressure,
            RetentateWashBufferLabel,
            RetentateWashBufferContainerLabel,
            WashFlowThroughLabel,
            WashFlowThroughContainerLabel,
            WashFlowThroughContainer,
            WashFlowThroughDestinationWell,
            WashFlowThroughStorageCondition
          };

          expandedOptionsWithoutMultipleMultiples = ReplaceRule[
            expandedOptions,
            Select[optionsWithListedPrimaryInput,MemberQ[multipleMultipleExpandedOptions,Keys[#]]&]
          ];

          expandedPrimitive=If[Length[optionsWithListedPrimaryInput]>0,
            Head[primitive]@Association@expandedOptionsWithoutMultipleMultiples,
            primitive
          ];

          (* See if this primitive has an index matching issue. *)
          validLengthsQ=Module[{myMessageList, messageHandler},
            myMessageList = {};

            messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
              (* Keep track of the messages thrown during evaluation of the test. *)
              AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
            ];

            SafeAddHandler[{"MessageTextFilter", messageHandler},
              Module[{validLengthsResult},
                (* Are our index-matched options valid? *)
                validLengthsResult=Quiet@ValidInputLengthsQ[
                  placeholderFunction,
                  {ConstantArray[Null, Length[ToList[Lookup[primitive[[1]], primaryInputOption]]]]},
                  optionsWithListedPrimaryInput,
                  Messages->True
                ];

                (* If they are not, throw some messages with prepended primitive index information. *)
                If[MatchQ[validLengthsResult, False],
                  Map[
                    throwMessageWithPrimitiveIndex[#, primitiveIndex, Head[primitive], currentSimulation]&,
                    myMessageList
                  ]
                ];

                (* Return our result. *)
                validLengthsResult
              ]
            ]
          ];

          (* Figure out what non-index-matching options we have in this primitive. This is for OptimizeUnitOperations *)
          (* combination later. *)
          nonIndexMatchingOptionsForPrimitiveHead=Cases[optionDefinition, KeyValuePattern["IndexMatching"->"None"]][[All,"OptionSymbol"]];
          nonIndexMatchingOptions=Cases[
            optionsWithListedPrimaryInput,
            Verbatim[Rule][Alternatives@@nonIndexMatchingOptionsForPrimitiveHead, _]
          ];

          {
            expandedPrimitive,
            nonIndexMatchingOptions,
            validLengthsQ
          }
        ]
      ]
    ],
    {flattenedPrimitives, Range[Length[flattenedPrimitives]]}
  ];

  (* For each primitive method index, look and see if we have any auxillary options that have been set. Keep track of them. *)
  invalidMethodOptionsWithIndices={};
  primitiveMethodIndexToOptionsLookup=MapThread[
    Function[{listElement, listIndex},
      (* Does this look like a wrapper and not an individual primitive? *)
      (* NOTE: We're doing the exact opposite as we did up above, here we ONLY want the additional option rules. *)
      If[MatchQ[listElement, Except[_Symbol[_Association]]],
        Module[{suppliedOptions, methodOptionDefinitions, methodOptionPattern},
          (* Get the options given for this primitive wrapper. *)
          suppliedOptions=Cases[List@@listElement, _Rule];

          (* Do some quick error checking to make sure that the options given here. *)
          methodOptionDefinitions=Lookup[Lookup[primitiveSetInformation, MethodOptions], Head[listElement], {}];
          methodOptionPattern=Alternatives@@((Lookup[#,"OptionSymbol"]->ReleaseHold[Lookup[#,"Pattern"]]&)/@methodOptionDefinitions);

          If[!MatchQ[suppliedOptions, {methodOptionPattern...}],
            AppendTo[invalidMethodOptionsWithIndices, {Head[listElement], Cases[suppliedOptions, Except[methodOptionPattern]], listIndex}];
          ];

          listIndex->suppliedOptions
        ],
        listIndex->{}
      ]
    ],
    {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
  ];

  If[Length[invalidMethodOptionsWithIndices]>0,
    Message[Error::InvalidMethodOptions, invalidMethodOptionsWithIndices[[All,1]], invalidMethodOptionsWithIndices[[All,2]], invalidMethodOptionsWithIndices[[All,3]]];
  ];

  (* If we threw a valid lengths error, return $Failed. *)
  (* NOTE: We do this down here because we also want to throw pattern doesn't match errors before we return early. *)
  If[MemberQ[validLengthsQList, False],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[myFunction,{sanitizedPrimitives},ToList[myOptions],Output->{Result,Tests}],
    {ApplyTemplateOptions[myFunction,{sanitizedPrimitives},ToList[myOptions]],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[myFunction,{sanitizedPrimitives},inheritedOptions]];

  (* Remove our error checking cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[errorCheckingMessageCell];
  ];

  (* -- STAGE 2: Pre-Resolve the Method to run each Primitive -- *)
  If[debug, Echo["Beginning stage 2: pre-resolving method"]];

  (* Tell the user that we're removing our primitive methods. *)
  primitiveMethodMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Calculating Allowable Work Cells",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* Resolve the method by which to perform each of our primitives. *)
  (* NOTE: If it's not obvious which method to use, we will have a PrimitiveMethod->ListableP[PrimitiveMethodsP] in the *)
  (* primitive here. *)
  (* If this is the case, we will resolve the primitive method in-line during the simulation loop. *)
  resolvedPrimitiveMethodResult=Check[
    resolvePrimitiveMethods[myFunction, flattenedIndexMatchingPrimitives, myHeldPrimitiveSet],
    $Failed,
    {Error::InvalidSuppliedPrimitiveMethod}
  ];

  If[MatchQ[resolvedPrimitiveMethodResult, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> $Failed,
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  {primitivesWithResolvedMethods, invalidPrimitiveMethodIndices}=resolvedPrimitiveMethodResult;

  (* -- STAGE 3: Pre-resolve any primary input keys that are expected to "autofill" -- *)
  If[debug, Echo["Beginning stage 3: pre-resolve any autofilling"]];

  (* Automatically propagate the primary input from the previous primitive to the next primitive, unless the previous *)
  (* primitive is generative. This is so that we can more easily resolve the Volume key in LabelSample[...] inside of *)
  (* our simulation MapThread. *)
  {primitivesWithPreresolvedInputs, doNotOptimizeQ}=Transpose@If[Length[primitivesWithResolvedMethods]==1,
    {{First[primitivesWithResolvedMethods], False}},
    (* Fold over our partition will pre-resolve all primitives. *)
    (* NOTE: We have to Fold here and not Map because if there is a sequence like: *)
    (* {Incubate[Sample->"taco"], Mix[Time->15 Minute], Mix[Time->15 Minute]} *)
    (* We need to propagate the "taco" to the first and second Mix primitives. Therefore, we need to map over our *)
    (* propagated list. *)
    FoldList[
      Function[{firstPrimitiveAndBoolean, secondPrimitive},
        Module[{firstPrimitive, firstPrimitiveInformation, firstPrimitiveGenerativeQ, secondPrimitiveInformation, firstPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOptionDefinition, secondPrimitiveGenerativeLabelOptions},
          (* The first argument to our function is the outpu of the last function -- {primitive, doNotOptimizeQ}. *)
          firstPrimitive=First@firstPrimitiveAndBoolean;

          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[firstPrimitive]];

          (* Are we dealing with a Generative primitive? *)
          firstPrimitiveGenerativeQ=Lookup[firstPrimitiveInformation, Generative];

          (* Lookup information about our second primitive. *)
          secondPrimitiveInformation=Lookup[allPrimitiveInformation, Head[secondPrimitive]];

          (* What option corresponds to the first input for each primitive type? *)
          firstPrimitivePrimaryInputOption=FirstOrDefault[Lookup[firstPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOption=FirstOrDefault[Lookup[secondPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOptionDefinition=FirstCase[Lookup[secondPrimitiveInformation, OptionDefinition], KeyValuePattern["OptionSymbol"->secondPrimitivePrimaryInputOption]];
          secondPrimitiveGenerativeLabelOptions=Lookup[secondPrimitiveInformation, LabeledOptions][[All,2]];

          (* If we're dealing with a generative first primitive, we can't autofill our second primitive. *)
          If[MatchQ[firstPrimitiveGenerativeQ, True],
            {
              secondPrimitive,
              (* NOTE: Do not optimize this primitive (combine it with others) if it is missing the primary input option *)
              (* since we can't fill it out bc the first primitive is generative. *)
              Or[
                !KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption],
                MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]]
              ]
            },
            (* Otherwise, we can pre-resolve our second primitive with the input from our first primitive, if we don't *)
            (* already have input information for our second primitive. *)
            (* Should we fill out the input to the second primitive? *)
            If[
              Or[
                KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption] && !MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]],
                !(KeyExistsQ[firstPrimitive[[1]], firstPrimitivePrimaryInputOption] && !MatchQ[Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption], ListableP[Automatic]]),
                !MatchQ[
                  Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption],
                  ReleaseHold[Lookup[secondPrimitivePrimaryInputOptionDefinition,"Pattern"]]
                ]
              ],
              (* Primary input option to the second primitive is already filled out or the primary input option to the first primitive is not filled out. Nothing to do. *)
              {
                secondPrimitive,
                False
              },
              (* Primary input option to the second primitive is NOT filled out. Fill it out using the first primitive's primary input. *)
              {
                Head[secondPrimitive]@Prepend[
                  secondPrimitive[[1]],
                  secondPrimitivePrimaryInputOption->Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption]
                ],
                False
              }
            ]
          ]
        ]
      ],
      {
        First[primitivesWithResolvedMethods],
        Module[{firstPrimitiveInformation, firstPrimitiveGenerativeLabelOptions},
          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[First[primitivesWithResolvedMethods]]];
          firstPrimitiveGenerativeLabelOptions=Lookup[firstPrimitiveInformation, LabeledOptions][[All,2]];

          (* NOTE: Do not optimize this primitive (combine it with others) if there are label options. The label *)
          (* options may show up downstream and we can't combine those into a single primitive. *)
          Or@@(KeyExistsQ[First[primitivesWithResolvedMethods][[1]], #]&/@firstPrimitiveGenerativeLabelOptions)
        ]
      },
      Rest@primitivesWithResolvedMethods
    ]
  ];

  (* -- STAGE 4: If OptimizeUnitOperations->True, reorganize and combine the primitives. -- *)
  If[debug, Echo["Beginning stage 4: reorganizing and combining primitives"]];

  (* NOTE: We optimize primitives by (1) hoisting LabelSample/Container unit operations to the front if they don't refer *)
  (* to specific samples, (2) converting mix via pipette unit operations to transfer unit operations, and (3) combining *)
  (* unit operations of the same type that are adjacent to one another. *)
  optimizedPrimitives=If[MatchQ[optimizeUnitOperations, True] && Length[primitivesWithPreresolvedInputs]>1 && MatchQ[previewFinalizedUnitOperations, True],
    Module[{labelHoistedPrimitives, reorderedNonIndexMatchingPrimitiveOptions, convertedMixToTransferPrimitives, indexedUserInitalizedLabels, indexedUserUsedLabels},
      (* 1) Hoist LabelSample/LabelContainer to the front if they don't refer to specific samples. *)
      labelHoistedPrimitives=Module[{labelSamplePositions, labelContainerPositions},
        (* NOTE: We don't want to hoist unit operations up to the front if the user gives us a PrimitiveMethodIndex that is not 1. *)
        labelSamplePositions=Position[
          primitivesWithPreresolvedInputs,
          LabelSample[KeyValuePattern[Sample->ListableP[ObjectP[Model[Sample]]]]?(MatchQ[Lookup[#, PrimitiveMethodIndex], Except[_Integer]|1]&)]
        ];

        labelContainerPositions=Position[
          primitivesWithPreresolvedInputs,
          LabelContainer[KeyValuePattern[Container->ListableP[ObjectP[Model[Container]]]]?(MatchQ[Lookup[#, PrimitiveMethodIndex], Except[_Integer]|1]&)]
        ];

        Join[
          Extract[primitivesWithPreresolvedInputs, labelSamplePositions],
          Extract[primitivesWithPreresolvedInputs, labelContainerPositions],
          Delete[primitivesWithPreresolvedInputs, Join[labelSamplePositions, labelContainerPositions]]
        ]
      ];

      (* Reorder our non index matching options based on this hoisting. *)
      reorderedNonIndexMatchingPrimitiveOptions=labelHoistedPrimitives/.Rule@@@Transpose[{primitivesWithPreresolvedInputs, nonIndexMatchingPrimitiveOptions}];

      (* 2) Convert mix via pipette unit operations to transfer unit operations with transfer amount being the mix volume. *)
      convertedMixToTransferPrimitives=Module[
        {mixByPipettePrimitives, downloadInformation, fastCacheBall, primitiveReplaceRules},

        mixByPipettePrimitives=Cases[
          labelHoistedPrimitives,
          (* NOTE: We need to make sure that the user didn't specify any keys that indicate this primitive should do more than just *)
          (* pipette mixing (ex. thawing). *)
          (Mix|Incubate)[
            KeyValuePattern[{
              Sample -> ListableP[ObjectP[Object[Sample]] | {_, ObjectP[Object[Container]]|_String}|_String],
              MixType -> ListableP[Pipette]
            }]?(
              Length[Complement[Keys[Select[#,Function[{value},!MatchQ[value,{Null..}]]]], {Sample, MixType, NumberOfMixes, MixVolume, Temperature, MixFlowRate, MixPosition, MixPositionOffset, Tips, TipType, TipMaterial, MultichannelMix, DeviceChannel, PrimitiveMethod, PrimitiveMethodIndex}]]==0
            &)
          ]
        ];

        (* Download the volumes of any samples that we have. *)
        downloadInformation=Quiet[
          Flatten@Download[
            DeleteDuplicates[Download[Cases[mixByPipettePrimitives, ObjectP[{Object[Sample], Object[Container]}], Infinity], Object]],
            {
              Packet[Volume, Contents],
              Packet[Contents[[All,2]][Volume]]
            },
            Simulation->simulation
          ],
          {Download::FieldDoesntExist, Download::NotLinkField}
        ];

        fastCacheBall = makeFastAssocFromCache[Cases[downloadInformation, _Association]];

        (* For each mix by pipette primitive, convert them to transfer primitives. *)
        primitiveReplaceRules=Map[
          Function[{mixByPipettePrimitive},
            mixByPipettePrimitive->Transfer[{
              Source->Lookup[mixByPipettePrimitive[[1]], Sample],
              Destination->Lookup[mixByPipettePrimitive[[1]], Sample],
              Amount->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], MixVolume], ListableP[VolumeP]],
                Lookup[mixByPipettePrimitive[[1]], MixVolume],
                Map[
                  Function[{input},
                    Which[
                      (* Note if the sample volume is 0, we are not going to use 0 uL as our transfer volume. This is going to break in Transfer. Instead, we can do our default 100 uL since the user likely will transfer some liquid in first *)
                      MatchQ[input, ObjectP[Object[Sample]]]&&!NullQ[Lookup[fetchPacketFromFastAssoc[input, fastCacheBall], Volume]]&&(TrueQ[Lookup[fetchPacketFromFastAssoc[input, fastCacheBall], Volume]>0Microliter]),
                      SafeRound[Lookup[fetchPacketFromFastAssoc[input, fastCacheBall], Volume]/2, 1 Microliter],
                      MatchQ[input, ObjectP[Object[Container]]],
                      Module[{contents},
                        contents=Lookup[fetchPacketFromFastAssoc[input, fastCacheBall], Contents];
                        Which[
                          Length[contents]==0,
                          100 Microliter,
                          !NullQ[Lookup[fetchPacketFromFastAssoc[contents[[1]][[2]], fastCacheBall], Volume]]&&(TrueQ[Lookup[fetchPacketFromFastAssoc[contents[[1]][[2]], fastCacheBall], Volume]>0Microliter]),
                          SafeRound[Lookup[fetchPacketFromFastAssoc[contents[[1]][[2]], fastCacheBall], Volume]/2, 1 Microliter],
                          True,
                          100 Microliter
                        ]
                      ],
                      MatchQ[input, {_, ObjectP[Object[Container]]}],
                      Module[{contents, sample},
                        contents=Lookup[fetchPacketFromFastAssoc[input[[2]], fastCacheBall], Contents];
                        sample=FirstCase[contents, {input[[1]], sample_}:>sample, Null];

                        Which[
                          !MatchQ[sample, ObjectP[Object[Sample]]],
                          100 Microliter,
                          !NullQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Volume]]&&(TrueQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Volume]>0Microliter]),
                          SafeRound[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Volume]/2, 1 Microliter],
                          True,
                          100 Microliter
                        ]
                      ],
                      True,
                      100 Microliter
                    ]
                  ],
                  Lookup[mixByPipettePrimitive[[1]], Sample]
                ]
              ],
              (* NOTE: At this point, all unit operations are assume to be expanded so any new options also must be expanded. *)
              AspirationMix->ConstantArray[True, Length[Lookup[mixByPipettePrimitive[[1]], Sample]]],
              NumberOfAspirationMixes->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], NumberOfMixes, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], NumberOfMixes, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], NumberOfMixes, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]/.{Automatic->15}
                )
              ],
              AspirationMixRate->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], MixFlowRate, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], MixFlowRate, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], MixFlowRate, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              SourceTemperature->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], Temperature, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], Temperature, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], Temperature, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]/.{Automatic->Ambient}
                )
              ],
              Tips->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], Tips, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], Tips, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], Tips, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              TipType->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], TipType, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], TipType, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], TipType, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              TipMaterial->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], TipMaterial, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], TipMaterial, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], TipMaterial, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              DeviceChannel->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], DeviceChannel, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], DeviceChannel, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], DeviceChannel, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              MixPosition->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], AspirationPosition, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], AspirationPosition, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], AspirationPosition, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              MixPositionOffset->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], AspirationPositionOffset, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], AspirationPositionOffset, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], AspirationPositionOffset, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              MultichannelMix->If[MatchQ[Lookup[mixByPipettePrimitive[[1]], MultichannelTransfer, Automatic], _List],
                Lookup[mixByPipettePrimitive[[1]], MultichannelTransfer, Automatic],
                (
                  ConstantArray[
                    Lookup[mixByPipettePrimitive[[1]], MultichannelTransfer, Automatic],
                    Length[Lookup[mixByPipettePrimitive[[1]], Sample]]
                  ]
                )
              ],
              DispenseMix->ConstantArray[False, Length[Lookup[mixByPipettePrimitive[[1]], Sample]]],
              PrimitiveMethod->Lookup[mixByPipettePrimitive[[1]], PrimitiveMethod],
              If[KeyExistsQ[mixByPipettePrimitive[[1]], PrimitiveMethodIndex],
                PrimitiveMethodIndex->Lookup[mixByPipettePrimitive[[1]], PrimitiveMethodIndex],
                Nothing
              ]
            }]
          ],
          mixByPipettePrimitives
        ];

        labelHoistedPrimitives/.primitiveReplaceRules
      ];

      (* Based on the label options in the primitive, figure out what labels are initialized by the user. *)
      indexedUserInitalizedLabels=Map[
        Function[{primitive},
          Module[{primitiveInformation, primitiveLabeledOptions},
            (* Lookup information about our primitive. *)
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveLabeledOptions=Lookup[primitiveInformation, LabeledOptions];

            (* Lookup all of our label options and see if the user gave us anything. *)
            DeleteDuplicates@Cases[Flatten[Lookup[primitive[[1]], primitiveLabeledOptions[[All,2]], Null]], _String]
          ]
        ],
        convertedMixToTransferPrimitives
      ];

      (* Figure out which labels are being specified by the user in Object widgets. *)
      indexedUserUsedLabels=Map[
        Function[{primitive},
          DeleteDuplicates@Flatten@KeyValueMap[
            Function[{option, value},
              Module[{primitiveInformation, primitiveOptionDefinitions, optionDefinition},
                (* Lookup information about our primitive. *)
                primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

                (* Lookup information about this option. *)
                optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                (* Do does this option allow for PreparedSample or PreparedContainer? *)
                Which[
                  MatchQ[optionDefinition, Null],
                  (* We don't know about this option. *)
                  Nothing,
                  (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                  (* Cases will only look inside of lists, not associations. *)
                  Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                  (* Nothing to replace. *)
                  Nothing,
                  True,
                  (* We may potentially have some labels. *)
                  Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption, unknownLabels, knownLabels, optionValueWithoutUnknownLabels},
                    (* Match the value of our option to the widget that we have. *)
                    (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                    matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                    (* Look for matched object widgets that have labels. *)
                    (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                    (* to separate legit strings from objects that were turned into strings. *)
                    objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                    (* This will give us our labels. *)
                    (StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}]
                  ]
                ]
              ]
            ],
            primitive[[1]]
          ]
        ],
        convertedMixToTransferPrimitives
      ];

      (* 3) Combine unit operations of the same type that are adjacent to one another.*)
      Module[{groupedPrimitives, currentGroupedPrimitives, nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions, allSpecifiedPreparation, roboticQ, allSpecifiedModelContainers, allSpecifiedObjectContainers, allSpecifiedObjectSamples, allFootprintDownloads, sampleToContainerLookup, labelContainerPrimitives, labelSamplePrimitives, labelToContainerLookup, labelToSampleLookup, containerFootprintTuples, containerFootprintTuplesNoDup, allUniqueFootprintsRule, fullDeckForCurrentPrimitiveGroupQ},
        (* Group our primitives. *)
        groupedPrimitives={};
        currentGroupedPrimitives={};

        (* Group our non-index-matching options while we're at it. *)
        nonIndexMatchingOptionsForGroups={};
        currentNonIndexMatchingOptions=Null;

        (* Roughly count how many containers and footprints we have. If we have too many to fit on deck all at once, try to not combine them for now so we can do better grouping later in resolver *)
        (* We only need to care about Robotic ones *)
        allSpecifiedPreparation = Lookup[labelHoistedPrimitives[[All,1]],PrimitiveMethod,Automatic];
        (* Here we check all the preparation to see if Robotic is required (meaning that we can only do Robotic). We cannot PickList only Robotic primitives since our LabelSample/LabelContainer will still be Manual/Automatic here. The transfer primitives are still string labels because we don't have simulated objects yet. To count the correct number, we must get all primitives. Again, this is a rough estimate now. *)
        roboticQ = MemberQ[allSpecifiedPreparation, {RoboticSamplePreparation}];

        (* We should try to avoid doing a download here so count only the labeled new containers as a rough estimate. Do it all together before MapThread to avoid unnecessary multiple download calls *)
        allSpecifiedModelContainers=Download[Cases[Flatten[Values[convertedMixToTransferPrimitives[[All,1]]]],ObjectP[Model[Container]]],Object];
        (* Get all objects we need too. Need to delete duplicates since each object is placed once anyway *)
        allSpecifiedObjectContainers=DeleteDuplicates[
          Download[
            Cases[Flatten[Values[convertedMixToTransferPrimitives[[All,1]]]],ObjectP[Object[Container]]],
            Object
          ]
        ];
        allSpecifiedObjectSamples=DeleteDuplicates[
          Download[
            Cases[Flatten[Values[convertedMixToTransferPrimitives[[All,1]]]],ObjectP[Object[Sample]]],
            Object
          ]
        ];
        (* This is a small download to get the footprints of the required containers. It will slow down the code a little but will be a good estimate for our check. This is also a one-time download only *)
        allFootprintDownloads=Quiet[
          Download[
            {
              allSpecifiedObjectSamples,
              allSpecifiedObjectSamples,
              allSpecifiedObjectContainers,
              allSpecifiedModelContainers
            },
            {
              {Container[Object]},
              {Packet[Container[Model[{Footprint}]]]},
              {Packet[Model[{Footprint}]]},
              {Packet[Footprint]}
            },
            Simulation->simulation
          ],
          {Download::FieldDoesntExist,Download::NotLinkField}
        ];

        (* Sample to container Tuple *)
        sampleToContainerLookup=MapThread[
          (Download[#1,Object]->#2)&,
          {allSpecifiedObjectSamples,Flatten[allFootprintDownloads[[1]]]}
        ];

        (* Get the LabelContainer and LabelSample rules to better check footprint *)
        labelContainerPrimitives=Cases[convertedMixToTransferPrimitives,_LabelContainer];
        labelSamplePrimitives=Cases[convertedMixToTransferPrimitives,_LabelSample];

        labelToContainerLookup=Flatten@Map[
          Function[{labelContainer},
            If[KeyExistsQ[labelContainer,Label]&&KeyExistsQ[labelContainer,Container],
              MapThread[(#1->Download[#2,Object])&,{Lookup[labelContainer,Label],Lookup[labelContainer,Container]}],
              {}
            ]
          ],
          labelContainerPrimitives[[All,1]]
        ];

        labelToSampleLookup=Flatten@Map[
          Function[{labelSample},
            If[KeyExistsQ[labelSample,Label]&&KeyExistsQ[labelSample,Sample],
              MapThread[(#1->Download[#2,Object])&,{Lookup[labelSample,Label],Lookup[labelSample,Sample]}],
              {}
            ]
          ],
          labelSamplePrimitives[[All,1]]
        ];

        (* Group the Object[xxx] container and sample container with the footprint download info. Need to flatten out the extra layer of list. Need to do this since user can give us an Object[Sample] that is inside the specified Object[Container] *)
        containerFootprintTuples=Join[
          (* NOTE: Some of our samples may be discarded, but we want to make sure that we don't crash here. *)
          Cases[Transpose[{Flatten[allFootprintDownloads[[1]]],Flatten[allFootprintDownloads[[2]]]}], {ObjectP[], _}],
          Transpose[{allSpecifiedObjectContainers,Flatten[allFootprintDownloads[[3]]]}]
        ];

        (* Delete the duplicated Object[Contaienr] for footprint counting *)
        containerFootprintTuplesNoDup=DeleteDuplicatesBy[containerFootprintTuples,#[[1]]&];

        (* Get all unique footprints. For Object[Container], we count the non-duplicated ones. For Model[Container], since each Model means a new resource picking, we need to count them all *)
        allUniqueFootprintsRule=Join[
          Map[
            (#[[1]]->Lookup[#[[2]],Footprint,Null])&,
            containerFootprintTuplesNoDup
          ],
          Map[
            (Lookup[#,Object]->Lookup[#,Footprint,Null])&,
            Flatten[allFootprintDownloads[[4]]]
          ]
        ];

        (* Define a small helper to tally the footprints for our current primitive group and check if we are beyond the potential limit of full deck *)
        fullDeckForCurrentPrimitiveGroupQ[primitiveGroup_]:=Module[
          {currentGroupSpecifiedModelContainers,currentGroupSpecifiedObjectContainers,currentGroupSpecifiedObjectSamples,currentGroupSpecifiedLabelesObjects,uniqueCurrentGroupObjectContainers,uniqueFootprints,uniqueFootprintsTally,potentialFullDeckQ},

          (* We should try to avoid doing a download here so count only the labeled new containers as a rough estimate *)
          currentGroupSpecifiedModelContainers=Download[Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Model[Container]]],Object];
          (* Get all objects we need too. Need to delete duplicates since each object is placed once anyway *)
          currentGroupSpecifiedObjectContainers=DeleteDuplicates[
            Download[
              Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Object[Container]]],
              Object
            ]
          ];
          currentGroupSpecifiedObjectSamples=DeleteDuplicates[
            Download[
              Cases[Flatten[Values[primitiveGroup[[All,1]]]],ObjectP[Object[Sample]]],
              Object
            ]
          ];
          currentGroupSpecifiedLabelesObjects=Cases[Flatten[Values[primitiveGroup[[All,1]]]],_String]/.Join[labelToContainerLookup,labelToSampleLookup/.sampleToContainerLookup];
          (* Get unique containers from the Object[Sample] and Object[Container] *)
          uniqueCurrentGroupObjectContainers=DeleteDuplicates[Join[currentGroupSpecifiedObjectContainers,currentGroupSpecifiedObjectSamples/.sampleToContainerLookup,Cases[currentGroupSpecifiedLabelesObjects,ObjectP[Object[Container]]]]];

          (* Count the unique footprints and tally them *)
          uniqueFootprints=Join[currentGroupSpecifiedModelContainers,Cases[currentGroupSpecifiedLabelesObjects,ObjectP[Model[Container]]],uniqueCurrentGroupObjectContainers]/.allUniqueFootprintsRule;

          uniqueFootprintsTally=(#[[1]]->#[[2]])&/@(Tally[uniqueFootprints]);

          (* Check if we are approaching a full deck and group accordingly. Note that if our UOs can end up all fit together on deck, we will still group them into a single protocol after resolver *)
          potentialFullDeckQ=Or[
            Length[primitiveGroup]>50,
            (* 50 mL tube. Max 12. Leave 2 Extra for Resources *)
            TrueQ[Lookup[uniqueFootprintsTally,Conical50mLTube,0]>=10],
            (* 2 mL tube or 1.5 mL tube or 0.5 mL tube. Max 60. Leave 10 Extra for Resources *)
            TrueQ[Lookup[uniqueFootprintsTally,MicrocentrifugeTube,0]>=50],
            (* Plate. Max 15. Leave 3 Extra for Resources *)
            TrueQ[Count[uniqueFootprintsTally,Plate]>=12]
          ]

        ];

        (* Go through our primitives and figure out our groupings. *)
        MapThread[
          Function[{primitive, nonIndexMatchingOptions, doNotOptimize, index},
            Which[
              (* If our current grouping is empty, append our primitive. *)
              Length[currentGroupedPrimitives]==0,
              Module[{},
                AppendTo[currentGroupedPrimitives, primitive];
                currentNonIndexMatchingOptions = nonIndexMatchingOptions;
              ],
              (* We can add the primitive to our current group if: *)
              And[
                (* 1) our primitive heads are the same *)
                MatchQ[Head[currentGroupedPrimitives[[1]]], Head[primitive]],
                (* 2) we weren't told to not optimize *)
                !TrueQ[doNotOptimize],
                (* 3) the primitive isn't using a label that was initialized in the previous group *)
                !MemberQ[
                  Flatten[indexedUserInitalizedLabels[[Length[Flatten[groupedPrimitives]]+1;;Length[Flatten[groupedPrimitives]]+Length[currentGroupedPrimitives]]]],
                  Alternatives@@(indexedUserUsedLabels[[index]])
                ],
                (* 4) the primitive has a method in common with the other primitives *)
                MemberQ[
                  Intersection@@(ToList[Lookup[#[[1]], PrimitiveMethod]]&/@currentGroupedPrimitives),
                  Alternatives@@Lookup[primitive[[1]], PrimitiveMethod]
                ],
                (* 5) the non-index matching options of this primitive match those that are in our current grouping. *)
                MatchQ[nonIndexMatchingOptions, currentNonIndexMatchingOptions],
                (* 6) The PrimitiveMethodIndex of these primitives does not conflict. *)
                Or[
                  MatchQ[Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic], Automatic],
                  !MemberQ[
                    Cases[Flatten[Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&/@currentGroupedPrimitives], Except[Automatic]],
                    Except[Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic]]
                  ]
                ],
                (* 7) We can potentially get all our containers onto the robot and we do not have too many containers *)
                Not[
                  fullDeckForCurrentPrimitiveGroupQ[currentGroupedPrimitives]&&roboticQ
                ]
              ],
              AppendTo[currentGroupedPrimitives, primitive],
              (* Otherwise, we have to start our new grouping. *)
              True,
              Module[{},
                AppendTo[groupedPrimitives, currentGroupedPrimitives];
                currentGroupedPrimitives={primitive};

                AppendTo[nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions];
                currentNonIndexMatchingOptions = nonIndexMatchingOptions;
              ]
            ]
          ],
          {convertedMixToTransferPrimitives, reorderedNonIndexMatchingPrimitiveOptions, doNotOptimizeQ, Range[Length[convertedMixToTransferPrimitives]]}
        ];

        (* If we have a grouping left over, make sure to add it to our overall grouping. *)
        If[Length[currentGroupedPrimitives]>0,
          AppendTo[groupedPrimitives, currentGroupedPrimitives];
          currentGroupedPrimitives={};

          AppendTo[nonIndexMatchingOptionsForGroups, currentNonIndexMatchingOptions];
          currentNonIndexMatchingOptions=Null;
        ];

        (* Combine these primitives. *)
        MapThread[
          Function[{primitiveGroup, nonIndexMatchingOptionsGroup},
            (* If we only have one primitive in this group, nothing to do. *)
            If[Length[primitiveGroup]==1,
              primitiveGroup[[1]],
              Module[
                {primitiveInformation, optionDefinition, nonIndexMatchingOptions, primitiveHead, primitiveAssociations,
                  primitiveAssociationsWithoutSingletonOptions, indexMatchingOptions, indexMatchingOptionDefaults,indexMatchingOptionDefaultsPerPrimitive,
                  primitiveAssociationsWithAllIndexMatchingOptions, listifiedPrimitiveAssociationsWithAllIndexMatchingOptions},

                (* Get the head of the primitive type and convert the rest into associations. *)
                primitiveHead=Head[primitiveGroup[[1]]];
                primitiveAssociations=(#[[1]]&)/@primitiveGroup;

                (* Lookup our primitive information. *)
                primitiveInformation=Lookup[Lookup[primitiveSetInformation, Primitives], primitiveHead, {}];

                (* Lookup the option definition of this primitive. *)
                optionDefinition=Lookup[primitiveInformation, OptionDefinition];

                (* Get the names of the non index matching options to not join. *)
                (* NOTE: All primitives should have their PrimitiveMethod key by now. *)
                nonIndexMatchingOptions=nonIndexMatchingOptionsGroup[[All,1]];

                (* Only include keys in these primitive associations that are index matching. *)
                primitiveAssociationsWithoutSingletonOptions=(
                  Association@Cases[Normal@#, Verbatim[Rule][Except[Alternatives@@nonIndexMatchingOptions], _]]
                      &)/@primitiveAssociations;

                (* Get all of the option names that are index matching in this primitive group. *)
                indexMatchingOptions=Complement[
                  DeleteDuplicates[Flatten[Keys/@primitiveAssociationsWithoutSingletonOptions]],
                  {PrimitiveMethod}
                ];

                (* Get the defaults for these index matching options. *)
                indexMatchingOptionDefaults=(
                  #->ReleaseHold@Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionSymbol"->#], <|"Default"->Null|>], "Default"]
                      &)/@indexMatchingOptions;

                (* Make sure our index matching options are expanded in the correct way *)
                indexMatchingOptionDefaultsPerPrimitive=Map[
                  Function[
                    {primitiveSingle},
                    Module[
                      {firstIndexMatchingValueInPrimitive,primitiveLength,indexMatchingKeys,indexMatchingValues},
                      indexMatchingKeys=Keys[indexMatchingOptionDefaults];
                      indexMatchingValues=Lookup[primitiveSingle,indexMatchingKeys,Null];
                      firstIndexMatchingValueInPrimitive=FirstCase[indexMatchingValues,Except[Null]];
                      primitiveLength=Length[firstIndexMatchingValueInPrimitive];
                      KeyValueMap[
                        #1->ConstantArray[#2,primitiveLength]&,
                        Association@indexMatchingOptionDefaults
                      ]
                    ]
                  ],
                  primitiveAssociationsWithoutSingletonOptions
                ];

                (* Make sure that each association has the full set of index matching options. *)
                primitiveAssociationsWithAllIndexMatchingOptions=MapThread[
                  Merge[{#1, Association@#2}, First]&,
                  {primitiveAssociationsWithoutSingletonOptions,indexMatchingOptionDefaultsPerPrimitive}
                ];

                (* If the value of the index matching option is not already a list, we need to listify it before we merge the values together for optimization. *)
                (* Map through each of the pirimtive association we have *)
                listifiedPrimitiveAssociationsWithAllIndexMatchingOptions=Map[
                  Function[
                    {individualAssociation},
                    (* Map through each key in our association *)
                    Association@KeyValueMap[
                      Which[
                        (* If it is not in a list, ToList it *)
                        MatchQ[#2,Except[_List]],(#1->ToList[#2]),
                        (* A special case for value already in a list. We allow list {position,container} as values for a lot of the keys, like Sample key in the LabelSample primitive. We cannot just merge it! That will turn {A1,container1} and {A1,container2} into a flattened list {A1,container1,A2,container2}. This is NOT correct and will create down-stream issues! We should turn that into an extra layer of list. *)
                        (* NOTE: We don't want to wrap an additional list around {"A1", "A1"}. This should probably use the SingletonPattern logic that we use in other cases. *)
                        MatchQ[#2,{WellPositionP,ObjectP[{Model[Container],Object[Container]}]|Except[WellPositionP, _String]}],(#1->List[#2]),
                        (* Otherwise, our option is already in a list and we can go with it. *)
                        True,#1->#2
                      ]&,
                      individualAssociation
                    ]
                  ],
                  primitiveAssociationsWithAllIndexMatchingOptions
                ];

                (* Construct the combined primitive. *)
                primitiveHead@@{
                  (* Merged index matching options, using the already listed values prepared above. We can just join the lists together here and they will be index matched. *)
                  Sequence@@Normal@Merge[listifiedPrimitiveAssociationsWithAllIndexMatchingOptions, (Join@@(#)&)],
                  (* Singleton options. *)
                  Sequence@@nonIndexMatchingOptionsGroup,
                  (* Internal PrimitiveMethod option. *)
                  PrimitiveMethod->FirstOrDefault@Intersection[Lookup[primitiveAssociations, PrimitiveMethod]],
                  (* Internal PrimitiveMethodIndex option. *)
                  PrimitiveMethodIndex->FirstCase[Flatten[Lookup[primitiveAssociations, PrimitiveMethodIndex, Automatic]], _Integer, Automatic]
                }
              ]
            ]
          ],
          {groupedPrimitives, nonIndexMatchingOptionsForGroups}
        ]
      ]
    ],
    primitivesWithPreresolvedInputs
  ];

  (* Remove our primitive method cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[primitiveMethodMessageCell];
  ];

  (* -- STAGE 5: Simulation Loop to Resolve Primitives and Resolve Primitive Groupings --*)
  If[debug, Echo["Beginning stage 5: Main resolving/simulation loop"]];

  (* Tell the user that we're removing our primitive methods. *)
  simulationPreparationMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    PrintTemporary[
      Row[{
        Constellation`Private`constellationImage[$ConstellationIconSize],
        Spacer[10],
        "Initializing virtual laboratory for protocol simulation",
        If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
      }]
    ]
  ];

  (* -- Resolver Globals -- *)
  (* Keep track of any primitives with bad labels that don't match their option patterns. *)
  invalidLabelPrimitivesWithIndices={};

  (* Keep track of any invalid input autofills -- this can really only happen during the first primitive. *)
  invalidAutofillPrimitivesWithIndices={};

  (* Keep track of primitives that cannot be performed by any methods. *)
  invalidResolvePrimitiveMethodsWithIndices={};

  (* Keep track of the tests that we get back from each resolver function. *)
  allResolverTests={};

  (* Keep track of the label fields that we get, with the primitive indices that they correspond to -- {label_String->LabelField[]...} *)
  allLabelFieldsWithIndicesGroupings={};

  (* NOTE: We have to have this current label fields and NOT append to the total list when within a workcell grouping because *)
  (* we do not want to be replacing labels to LabelFields[...] WITHIN a work cell grouping, since it's self contained. We DO want *)
  (* to replace labels with LabelFields[...] within an Experiment group (NOT ManualSamplePreparation) though since they will ultimately be *)
  (* split up. *)
  currentLabelFieldsWithIndices={};

  (* -- Primitive Method Grouping Globals -- *)
  (* Keep track of the total list of groupings that we have and our current grouping. *)
  allPrimitiveGroupings={};
  allUnresolvedPrimitiveGroupings={};
  allPrimitiveInputGroupings={};
  allPrimitiveOptionGroupings={};

  allPrimitiveGroupingResources={};
  allPrimitiveGroupingUnitOperationPackets={};
  allPrimitiveGroupingBatchedUnitOperationPackets={};
  (* NOTE: This is the format:*)
  (*
    {
      {
        containerFootprint:FootprintP,
        liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
        container:ObjectP[Object[Container]],
        resource:ResourceP
      }..
    }.
  *)
  allPrimitiveGroupingFootprints={};
  allPrimitiveGroupingTips={};
  allPrimitiveGroupingIntegratedInstrumentResources={};
  allPrimitiveGroupingWorkCellInstruments={};
  allPrimitiveGroupingIncubatorContainerResources={};
  allPrimitiveGroupingAmbientContainerResources={};
  allPrimitiveGroupingWorkCellIdlingConditionHistory={};
  allPrimitiveGroupingRunTimes={};

  (* Keep track of the current things required to be on the workcell deck. *)
  currentPrimitiveGrouping={};
  currentUnresolvedPrimitiveGrouping={};
  currentPrimitiveInputGrouping={};
  currentPrimitiveOptionGrouping={};

  (* NOTE: The following will MAINLY be used in robotic protocols. It will also be used for LabelSample/LabelContainer *)
  (* in Manual protocols. *)
  currentPrimitiveGroupingLabeledObjects={}; (* {(_String->ResourceP)..} *)
  currentPrimitiveGroupingUnitOperationPackets={}; (* {{PacketP[Object[UnitOperation]]..}..} *)
  currentPrimitiveGroupingBatchedUnitOperationPackets={}; (* {{PacketP[Object[UnitOperation]]..}..} *)

  (* NOTE: The following will NOT be filled out for a ManualSamplePreparation/Experiment grouping because we have no *)
  (* footprint/tip limitations. *)
  currentPrimitiveGroupingFootprints={}; (* {{FootprintP, ObjectP[Object[Container]], ResourceP}..} *)
  currentPrimitiveGroupingTips={}; (* {Resource[Sample->Model[Item, Tips], Amount->_Integer]..} *)
  currentPrimitiveGroupingIntegratedInstrumentsResources={}; (* {InstrumentResourceP..} *)
  (* These are the potential Model[Instrument, LiquidHandler] or Model[Instrument, ColonyHandler]s that meet the requirements. *)
  currentPrimitiveGroupingPotentialWorkCellInstruments={}; (* {ObjectP[{Model[Instrument, LiquidHandler],Model[InstrumentColonyHandler]}]..} *)

  (* These are, respectively, the Object[Container]s that should be placed in the incubator for the start of the run *)
  (* and the Object[Container]s that should be place Ambient-ly (either on deck or off deck) since they don't *)
  (* contain cells. *)
  currentPrimitiveGroupingIncubatorPlateResources={}; (* {ResourceP..} *)
  currentPrimitiveGroupingAmbientPlateResources={}; (* {ResourceP..} *)
  currentPrimitiveGroupingWorkCellIdlingConditionHistory={}; (* {(ObjectP[Object[Container]] -> WorkCellIdlingConditionP)..} *)
  currentPrimitiveGroupingRunTimes={}; (* {(TimeP|Null)..} *)

  (* Keep track of primitives that cannot fit on any work cell, regardless of grouping. *)
  noInstrumentsPossibleErrorsWithIndices={};

  (* Keep track of any overwritten labels. *)
  allOverwrittenLabelsWithIndices={};

  (* Keep track of if we've already added an automatic cover primitive to CoverAtEnd for robotic groupings. *)
  addedCoverAtEndPrimitiveQ=False;

  (* Initialize our primitive index to 1. *)
  index=1;

	(* Helper function overload *)
	startNewPrimitiveGrouping[]:=startNewPrimitiveGrouping[False];
  (* Helper function that will reset our lists for us. *)
  startNewPrimitiveGrouping[cleanUpBool_]:=Module[{startNewGroupingQ},
    (* Set this variable to continue since Return[] doesn't work as expected. *)
    startNewGroupingQ=True;

    If[Length[currentPrimitiveGrouping]>0,
      (* Should we add a cover primitive and go back to the top of our MapThread to add the cover primitive's information to *)
      (* our grouping before REALLY starting a new grouping? *)
      If[And[
        MatchQ[optimizeUnitOperations, True],
        MatchQ[previewFinalizedUnitOperations, True],
        MatchQ[coverAtEnd, True],
        MatchQ[Lookup[currentPrimitiveGrouping[[1]][[1]], PrimitiveMethod], RoboticSamplePreparation|RoboticCellPreparation],
        !MatchQ[Lookup[currentPrimitiveGrouping[[1]][[1]], WorkCell], qPix],
        MatchQ[addedCoverAtEndPrimitiveQ, False],
        Length[invalidResolverPrimitives]==0
      ],
        Module[
          {uniqueContainersInGrouping, uniqueContainersInGroupingLabelLookup, currentGroupingCoverPrimitives, coveredContainers,
            rawContainersToCover, lidInternalDimensions2D, rawContainersToCoverDownload, containerCanCoverQ, containersToCover},
          (* Get all of the unique containers that were manipulated in our current primitive grouping. *)
          (* NOTE: We only get the plates here because we cannot cover vessels. *)
          uniqueContainersInGrouping=Cases[currentPrimitiveGroupingFootprints[[All,3]], ObjectP[Object[Container, Plate]]];
          uniqueContainersInGroupingLabelLookup=Cases[Lookup[currentSimulation[[1]], Labels], Verbatim[Rule][_String, ObjectP[uniqueContainersInGrouping]]];

          (* Get any cover primitives that are within our grouping. *)
          currentGroupingCoverPrimitives=Cases[currentPrimitiveGrouping, _Cover];

          (* Get the containers that we are operating on. Also translate everything into objects if possible. *)
          coveredContainers=DeleteDuplicates[Flatten[{(Lookup[#[[1]], Sample]&)/@currentGroupingCoverPrimitives}]/.uniqueContainersInGroupingLabelLookup];

          (* Get our containers to cover. *)
          rawContainersToCover=Complement[
            uniqueContainersInGroupingLabelLookup[[All,2]],
            coveredContainers
          ];

          {{{lidInternalDimensions2D}},rawContainersToCoverDownload}=Quiet[
            Download[
              {
                {Model[Item, Lid, "id:N80DNj16AaKA"]},
                rawContainersToCover
              },
              {
                {InternalDimensions2D},
                {
                  Packet[Cover,Model,AwaitingDisposal],
                  Packet[Model[{CoverFootprints,CoverTypes,ExternalDimensions3D}]]
                }
              },
              Simulation->currentSimulation
            ],
            Download::FieldDoesntExist
          ];

          containerCanCoverQ=Map[
            And[
              (* No cover currently *)
              NullQ[Lookup[#[[1]],Cover]],
              (* Not flagged for awaiting disposal so that the simulation does not mess up with cover primitive calculation*)
              Not[TrueQ[Lookup[#[[1]],AwaitingDisposal]]],
              (* Can accept Place Lid *)
              MatchQ[Lookup[#[[2]],CoverFootprints],{___, LidSBSUniversal, ___}],
              MatchQ[Lookup[#[[2]],CoverTypes],{___, Place, ___}],
              Or[
                NullQ[lidInternalDimensions2D],
                MatchQ[
                  (* Top dimensions is at the largest z *)
                  LastOrDefault[SortBy[Lookup[#[[2]],ExternalDimensions3D],Last],Null],
                  Alternatives[
                    Null,
                    (* 0.5mm smaller on both x and y *)
                    {LessEqualP[(lidInternalDimensions2D[[1]]/.(Null->200Millimeter))-0.5Millimeter],LessEqualP[(lidInternalDimensions2D[[2]]/.(Null->200Millimeter))-0.5Millimeter],_}
                  ]
                ]
              ]
            ]&,
            rawContainersToCoverDownload
          ];

          (* Make sure that these containers really do not have covers on them. Then, translate to labels if possible. *)
          containersToCover=PickList[
            rawContainersToCover,
            containerCanCoverQ,
            True
          ]/.(Reverse/@uniqueContainersInGroupingLabelLookup);

          (* If we have containers to cover at the end of our robotic grouping, insert the cover primitive. *)
          If[Length[containersToCover]>0,
            (* Set this flag to True. It resets when we actually start a new grouping. *)
            addedCoverAtEndPrimitiveQ=True;

            Module[{primitiveMethodIndexOfLastPrimitive},
              (* Get the primitive method index of the last primitive. We have to specify the PrimitiveMethodIndex so that we *)
              (* will be okay adding the Cover primitive to the previous method index grouping. *)
              primitiveMethodIndexOfLastPrimitive=Lookup[Last[currentPrimitiveGrouping][[1]], PrimitiveMethodIndex, Automatic];

              (* Insert this into our coverOptimizedPrimitives and Continue[] to automatically go to the next iteration of the While[...] loop. *)
              (* NOTE: We insert at the same index because we want to add the cover primitive BEFORE we go to the next grouping. Unless *)
              (* we're calling this function because we're at the very end of our list of primitives. *)
							(* we have an edge case where we may be trying to create a new cover primitive during the cleanup phase below, and we want to add the cover primitive at the end *)
							(* if we are not cleaning up though, we will need to Continue[] to resolve the cover primitive before re-resolving the final primitive, so make this decision based off the cleaning-up Boolean *)
              If[index==Length[coverOptimizedPrimitives] && TrueQ[cleanUpBool],
                Module[{},
                  coverOptimizedPrimitives=Insert[coverOptimizedPrimitives, Cover[Sample->containersToCover, Preparation->Robotic, PrimitiveMethodIndex->primitiveMethodIndexOfLastPrimitive], index+1];

                  (* NOTE: This makes us exist out of this helper function and back into the while loop. *)
                  startNewGroupingQ=False;
                ],
                Module[{},

                  (* We are here since we need to add a new Cover primitive into our old group, after we decide we need to start a new group. *)
                  (* When we decide we need to start a new group, we already processed the newest primitive and simulated everything. Since it will be in the new group, we need to remove the simulation there and we will do it again in the correct group.
    Note that previousSimulation and currentSimulation are both variables set up in the While loop *)
                  (* We don't do this in the clean up case as that is not to start a new group. It is to conclude the whole set of unit operations. We are not skipping anything there. *)
                  currentSimulation=previousSimulation;

                  coverOptimizedPrimitives=Insert[coverOptimizedPrimitives, Cover[Sample->containersToCover, Preparation->Robotic, PrimitiveMethodIndex->primitiveMethodIndexOfLastPrimitive], index];

                  Continue[];
                ]
              ];
            ]
          ];
        ];
      ];

      If[startNewGroupingQ,
        (* Reset our flag since we're really starting a new grouping. *)
        addedCoverAtEndPrimitiveQ=False;

        (* Setup a new grouping and add this primitive to that new grouping. *)
        AppendTo[allPrimitiveGroupings, currentPrimitiveGrouping];
        AppendTo[allUnresolvedPrimitiveGroupings, currentUnresolvedPrimitiveGrouping];
        AppendTo[allPrimitiveInputGroupings, currentPrimitiveInputGrouping];
        AppendTo[allPrimitiveOptionGroupings, currentPrimitiveOptionGrouping];
        AppendTo[allPrimitiveGroupingFootprints, currentPrimitiveGroupingFootprints];
        AppendTo[allPrimitiveGroupingTips, currentPrimitiveGroupingTips];
        AppendTo[allPrimitiveGroupingIntegratedInstrumentResources, currentPrimitiveGroupingIntegratedInstrumentsResources];
        AppendTo[allPrimitiveGroupingWorkCellInstruments, currentPrimitiveGroupingPotentialWorkCellInstruments];
        AppendTo[allPrimitiveGroupingIncubatorContainerResources, currentPrimitiveGroupingIncubatorPlateResources];
        AppendTo[allPrimitiveGroupingAmbientContainerResources, currentPrimitiveGroupingAmbientPlateResources];
        AppendTo[allPrimitiveGroupingWorkCellIdlingConditionHistory, currentPrimitiveGroupingWorkCellIdlingConditionHistory];
        AppendTo[allPrimitiveGroupingResources, currentPrimitiveGroupingLabeledObjects];
        AppendTo[allPrimitiveGroupingUnitOperationPackets, currentPrimitiveGroupingUnitOperationPackets];
        AppendTo[allPrimitiveGroupingBatchedUnitOperationPackets, currentPrimitiveGroupingBatchedUnitOperationPackets];
        AppendTo[allPrimitiveGroupingRunTimes, currentPrimitiveGroupingRunTimes];
        AppendTo[allLabelFieldsWithIndicesGroupings, currentLabelFieldsWithIndices];

        (* Reset our tracking variables. *)
        currentPrimitiveGrouping={};
        currentUnresolvedPrimitiveGrouping={};
        currentPrimitiveInputGrouping={};
        currentPrimitiveOptionGrouping={};
        currentPrimitiveGroupingFootprints={};
        currentPrimitiveGroupingTips={};
        currentPrimitiveGroupingIntegratedInstrumentsResources={};
        currentPrimitiveGroupingPotentialWorkCellInstruments={};
        currentPrimitiveGroupingIncubatorPlateResources={};
        currentPrimitiveGroupingAmbientPlateResources={};
        currentPrimitiveGroupingWorkCellIdlingConditionHistory={};
        currentPrimitiveGroupingLabeledObjects={};
        currentPrimitiveGroupingUnitOperationPackets={};
        currentPrimitiveGroupingBatchedUnitOperationPackets={};
        currentPrimitiveGroupingRunTimes={};
        currentLabelFieldsWithIndices={};
        (* Record the date we are starting the primitive resolving, if this is a new group *)
        currentPrimitiveGroupingDateStarted=currentPrimitiveDateStarted;
      ];
    ]
  ];

  (* Create a single fake water sample to use for any unknown labels during our resolving processing. *)
  (* This will be our first sample in our simulation. *)
  {fakeContainer, fakeWaterSample, fakeWaterSimulation}=simulateFakeWaterSample[];

  (* Get our current simulation. *)
  currentSimulation=UpdateSimulation[
    If[MatchQ[Lookup[safeOps, Simulation], Null],
      Simulation[],
      Lookup[safeOps, Simulation]
    ],
    fakeWaterSimulation
  ];

  (* Find all racks that we can use on the liquid handler. Figure out how many individual vessels that we can place *)
  (* inside of each of these racks. Also note that we need to include spacers in here *)
  liquidHandlerCompatibleRacks = hamiltonRackModelSearch["Memoization"];
  (* Download the necessary information about our workcells and potential tips before we go into our loop. *)
  allTipModels = hamiltonTipModelSearch["Memoization"];
  modelContainerFields = Flatten[{SamplePreparationCacheFields[Model[Container], Format -> List], Immobile, MetaXpressPrefix, HighPrecisionPositionRequired, CoverTypes}];
  objectContainerFields = Flatten[{SamplePreparationCacheFields[Object[Container], Format -> List], CoverLog}];
  objectSampleFields = SamplePreparationCacheFields[Object[Sample], Format -> List];
  modelSampleFields = SamplePreparationCacheFields[Model[Sample], Format -> List];

  {
    workCellModelPackets,
    workCellObjectPackets,
    liquidHandlerCompatibleRackPackets,
    tipModelPackets,
    samplePackets,
    sampleModelPackets,
    containerPackets,
    parentProtocolStack
  }=Quiet[
    With[{insertMe1=Packet@@objectSampleFields,insertMe2=Packet@@objectContainerFields,insertMe3=Packet@@modelSampleFields},
      Download[
        {
          Flatten[Values[$WorkCellsToInstruments]],
          (* NOTE: We can be told by the user to use a specific Object[Instrument, LiquidHandler] either thourgh the global *)
          (* Instrument option or via the primitive grouping wrapper Instrument option. *)
          DeleteDuplicates@Download[Cases[Join[primitiveMethodIndexToOptionsLookup,{Lookup[safeOps,Instrument]}], ObjectP[Object[Instrument]], Infinity], Object],
          liquidHandlerCompatibleRacks,
          allTipModels,
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Sample]], Infinity], Object]],
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Model[Sample]], Infinity], Object]],
          DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Container]], Infinity], Object]],
          {parentProtocol} /. {Null -> Nothing}
        },
        Evaluate[{
          List@Packet[Name, AvailableFootprints, MaxNonStackedTipPositions, MaxStackedTipPositions, IntegratedInstruments, MaxIncubatorPlatePositions, MaxOffDeckStoragePositions],
          List@Packet[Name, Model],
          List@Packet[Name, Positions, Footprint],
          List@Packet[Object, Name, PipetteType, Sterile, RNaseFree, WideBore,Filtered,GelLoading,Aspirator, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint],
          {
            insertMe1,
            Packet[Container[objectContainerFields]],
            Packet[Container[Model[modelContainerFields]]],
            Packet[Container[Model[LiquidHandlerAdapter][{Footprint}]]]
          },
          {
            insertMe3
          },
          {
            insertMe2,
            Packet[Field[Contents[[All,2]]][objectSampleFields]],
            Packet[Field[Contents[[All,2]]][Model][modelSampleFields]],
            Packet[Model[modelContainerFields]],
            Packet[Model[LiquidHandlerAdapter][{Footprint}]]
          },
          {Object, ParentProtocol..[Object]}
        }],
        Simulation -> currentSimulation
      ]
    ],
    {Download::FieldDoesntExist,Download::NotLinkField,Download::Part}
  ];

  (* get the root protocol here; in this case Null means that we don't have a parent (so root is self) *)
  rootProtocol = If[NullQ[parentProtocol],
    Null,
    LastOrDefault[Cases[Flatten[parentProtocolStack], ObjectP[]]]
  ];

  cacheBall=FlattenCachePackets[{workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets, samplePackets, sampleModelPackets, containerPackets}];

  {workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets}=Flatten/@{workCellModelPackets, workCellObjectPackets, liquidHandlerCompatibleRackPackets, tipModelPackets};

  (* Get all Object[Sample]s and Model[Sample]s referenced in our primitives and see if we can find any *)
  (* microbial cells in them. This will be used for defaulting the work cell to use for each of the unit operations. *)
  (* If we're dealing with microbes at all and are on the robot, use the microbioSTAR. *)
  microbialQ=Module[{sampleAndContainerCache},
    sampleAndContainerCache=FlattenCachePackets[{samplePackets, sampleModelPackets}];

    Or[
      MemberQ[sampleAndContainerCache, KeyValuePattern[{CellType->MicrobialCellTypeP}]],
      MemberQ[
        Download[Cases[Lookup[sampleAndContainerCache, Composition],ObjectP[],Infinity], Object],
        ObjectReferenceP[{Model[Cell, Bacteria], Model[Cell, Yeast]}]
      ]
    ]
  ];

  (* Build a lookup relating each liquid handler adapter to the maximum number of vessels that can fit into each adapter. *)

  (* Helper function to figure out how many footprints are going to be used on the liquid handler deck given footprint information *)
  (* in the form: *)
  (*
	{
	  {
		Footprint->containerFootprint:FootprintP,
		LiquidHandlerAdapter->liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
		Container->container:ObjectP[Object[Container]],
		Resource->resource:ResourceP,
		HighPrecisionPositionRequired->highPrecisionPositionContainer:Boolean,
		(* to track future resource consolidation *)
		Index->index,
		(* to show the container grouping/resource consolidation *)
		(* this containerModels is the updates possible list of containers, with small containers (MaxVolume < consolidated volume) removed *)
		ContainerModels->containerModels,
		ContainerName->containerName,
		Well->well,
		(* NOTE: This is only populated for resources that are coming out of a ThawCells unit operation since *)
		(* we don't want to group together vials on the same liquid handler adapter if they should be thawed *)
		(* for different amounts of time. *)
		IncubationTime->incubationTime:(TimeP|Null)
	  }..
	}.
  *)
  footprintInformationKeys={
    Footprint,
    LiquidHandlerAdapter,
    Container,
    Resource,
    HighPrecisionPositionRequired,
    Index,
    ContainerModels,
    ContainerName,
    Well,
    IncubationTime
  };
  tallyFootprints[footprintInformation_List]:=Module[{nonAdaptedFootprintInformation, adaptedFootprintInformation, groupedAdaptedFootprintInformation, groupedTalliedAdaptedFootprintInformation, convertedAdaptedFootprints},
    (* Get all of the footprints that aren't in a liquid handler adapter. *)
    nonAdaptedFootprintInformation=Cases[footprintInformation, KeyValuePattern[LiquidHandlerAdapter->Null]];
    adaptedFootprintInformation=Cases[footprintInformation, KeyValuePattern[LiquidHandlerAdapter->Except[Null]]];

    (* Group our adapted footprints by the incubation time entry before we perform a tally. This is because we don't want *)
    (* containers with different incubation times to go onto the same liquid handler rack. *)
    groupedAdaptedFootprintInformation=GatherBy[adaptedFootprintInformation, Lookup[#,IncubationTime]&];
    groupedTalliedAdaptedFootprintInformation=(Sequence@@Tally[Lookup[#,LiquidHandlerAdapter]]&)/@groupedAdaptedFootprintInformation;

    (* Tally up the adapted footprints, taking into account which adapters they're in. *)
    (* NOTE: Here we're assuming that liquid handler adapters can only hold vessels of the same footprint, aka, we're doing *)
    (* Length[Lookup[liquidHandlerAdapterPacket, Positions]] which might be an invalid assumption in the future. *)
    convertedAdaptedFootprints=If[Length[adaptedFootprintInformation]>0,
      MapThread[
        Function[{liquidHandlerAdapter, count},
          Module[{liquidHandlerAdapterPacket},
            (* Get the packet of liquid handler adapter. *)
            liquidHandlerAdapterPacket=fetchPacketFromCache[liquidHandlerAdapter, liquidHandlerCompatibleRackPackets];

            Sequence@@ConstantArray[
              Lookup[liquidHandlerAdapterPacket, Footprint],
              Ceiling[count/Length[Lookup[liquidHandlerAdapterPacket, Positions]]]
            ]
          ]
        ],
        Transpose[groupedTalliedAdaptedFootprintInformation]
      ],
      {}
    ];

    Tally[Join[Lookup[nonAdaptedFootprintInformation,Footprint,{}], convertedAdaptedFootprints]]
  ];

  (* Keep track of primitives that we have a problem resolving. *)
  invalidResolverPrimitives={};

  (* Keep track of which primitives resulted in failed workcell selection *)
  incompatibleWorkCellAndMethod={};

  (* Create a variable to keep track of our FRQ tests, if we have any. *)
  frqTests={};

  (* create a variable to compile together all the resources we need to call FRQ on at the end of the UOs, not between each one *)
  nonObjectResources={};

  (* Keep track of if our primitives have unfulfillable resources. *)
  fulfillableQ=True;

  (* Keep track of any output unit operation objects that we retrieved from our resolver cache. If we're trying to upload *)
  (* this protocol, then we will need to change the object IDs since we don't want to point to previously used object IDs. *)
  outputUnitOperationObjectsFromCache={};

  (* Remove our message cell. *)
  If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
    NotebookDelete[simulationPreparationMessageCell];
  ];
  (* Before we start our MapThread, create a new unique label session. *)
  (* NOTE: This session helper function will enable the proper functioning of CreateUniqueLabel[...] inside of our *)
  (* resolver functions. It also supports nested sessions (ExperimentSP called inside of ExperimentSP). *)
  (* In cases where a unit operation uses other unit ops inside it (Ex. MBS creates Transfer unit ops) we don't want to *)
  (* reset the label session because then duplicate labels will be created *)
  If[!unitOperationPacketsQ,
    StartUniqueLabelsSession[];
  ];

  (* Copy over our list of optimized primitives. We will automatically insert Cover primitives into this list if we *)
  (* 1) are robotic and detect that a container that has KeepCovered->True was manipulated *)
  (* 2) are at the end of a robotic grouping, detect that there are uncovered containers at the end of the grouping, and CoverAtEnd->True. *)
  (* In order to do any cover optimization, OptimizeUnitOperations must be True. *)
  coverOptimizedPrimitives=optimizedPrimitives;

  (* Initialize our list of resolved primitives. *)
  resolvedPrimitives={};

  (* Record the date we are starting the primitive resolving *)
  currentPrimitiveGroupingDateStarted=Now;
  currentPrimitiveDateStarted=Now;

  (* Resolve our primitives! *)
  While[index<=Length[coverOptimizedPrimitives],
    Module[
      {primitive,primitiveInformation, primitiveOptionDefinitions, primaryInputOption, primitiveOptionsWithResolvedPrimaryInput,
        allPrimitiveOptionsWithSimulatedObjects, inputsFromPrimitiveOptions, optionsFromPrimitiveOptions, resolvedPrimitiveMethod,
        resolverFunction, resolvedOptions, newSimulation, resolverTests, simulatedObjectsToLabel, unitOperationPacketsMinusOptions,
        resolvedOptionsWithPrimitiveOptionsOnly, resolvedPrimitive, primitiveMethodIndex, unitOperationPacketsRaw, unitOperationPackets,batchedUnitOperationPackets,
        resolvedOptionsWithNoSimulatedObjects, newLabelFieldKeys, runTimeEstimate, resolverErrorQ, messagesThrown,
        primitiveResolvingMessageCell, resolvedWorkCell, requestedInstrument, newSimulationWithoutOverwrittenLabels,
        primaryInputOptionDefinition, safeResolverOptions, newLabelFields, inputsWithNoSimulatedObjects,
        optionsWithNoSimulatedObjects, usedResolverCacheQ, delayedMessagesFalseMessagesBool, savedDelayedMessagesFalseMessagesBool,
        emptyContainerFailureQ, hardResolverFailureQ, inputsFromPrimitiveOptionsWithExpandedTransfers,
        optionsFromPrimitiveOptionsWithExpandedTransfers, emptyWellFailureQ, nonExistedWellFailureQ, preparation,
        inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers,
        downloadInformation,fastCacheBall},

      (* Get our current primitive. *)
      primitive=coverOptimizedPrimitives[[index]];

      currentPrimitiveDateStarted=Now;

      (* Lookup information about our primitive. *)
      primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
      primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

      (* Tell the user that we're about to resolve our primitive. *)
      primitiveResolvingMessageCell=If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
        PrintTemporary[
          Row[{
            Lookup[primitiveInformation, Icon],
            Spacer[10],
            "Calculating Options for "<>ToString[Head[primitive]]<>" Unit Operation ("<>ToString[index]<>"/"<>ToString[Length[coverOptimizedPrimitives]]<>")",
            If[Not[$CloudEvaluation], ProgressIndicator[Appearance->"Percolate"], Nothing]
          }]
        ]
      ];

      (* -- Finish Autofilling the Primary Input, if necessary -- *)
      (* We previously tried to autofill all primary input keys for our primitives during stage 2, but we may not have been *)
      (* able to if the primitive before us was a generative primitive. If that was the case, autofill it now. *)
      (* NOTE: This implies that all generative primitives MUST give us a label for the SamplesOut that they generate *)
      (* because this is the only way that we will be able to autofill the next primitive. *)
      primaryInputOption=FirstOrDefault[Lookup[primitiveInformation, InputOptions]];
      primaryInputOptionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->primaryInputOption],Null];

      (* Make sure that we actually have a primary input option and if we do, see if it's specified. *)
      (* NOTE: We are assuming that the primary input option is either ENTIRELY automatic or is specified. *)
      primitiveOptionsWithResolvedPrimaryInput=If[MatchQ[primaryInputOption, Null] || MatchQ[Lookup[primitive[[1]], primaryInputOption, Automatic], Except[Automatic]],
        primitive[[1]],
        (* If we are actually the first primitive, we have to throw an error here since we can't resolve the input key for the first primitive. *)
        If[MatchQ[index, 1],
          AppendTo[invalidAutofillPrimitivesWithIndices, {primitive, index}];

          (* NOTE: Since we're using the singleton fakeWaterSample here, it should expand to whatever length we need it to expand to. *)
          Append[
            primitive[[1]],
            primaryInputOption->fakeWaterSample
          ],
          (* Otherwise, autofill from the previous primitive. *)
          Module[{previousPrimitive, previousPrimitiveInformation, resolvedPrimaryInput},
            (* Get the previous primitive. *)
            previousPrimitive=If[Length[currentPrimitiveGrouping]==0,
              Last[Flatten[allPrimitiveGroupings]],
              Last[currentPrimitiveGrouping]
            ];

            (* Get the information for the previous primitive. *)
            previousPrimitiveInformation=Lookup[allPrimitiveInformation, Head[previousPrimitive]];

            (* Autofill our current primary input from our previous primitive. *)
            resolvedPrimaryInput=Which[
              (* Last primitive was generative. Get the label option of the generative output. *)
              (* NOTE: We only take _String here because sometimes the label can intentionally be set to Null. We also *)
              (* flatten in the case of pooled labels (ex. WashCells). *)
              And[
                MatchQ[Lookup[previousPrimitiveInformation, Generative], True],
                MatchQ[{"Test String"}, ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]]
              ],
                Cases[Flatten@ToList@Lookup[previousPrimitive[[1]], Lookup[previousPrimitiveInformation, GenerativeLabelOption]], _String],

              (* Last primitive had an AliquotSampleLabel Option and it isn't completely Null. *)
              (* NOTE: Here we are assuming that 1) the only time that the input is going to change containers, without *)
              (* the primitive being generative, is due to an aliquot and 2) if there is an aliquot, the resulting samples *)
              (* will always be given a label under the AliquotSampleLabel option. *)
              And[
                KeyExistsQ[previousPrimitive[[1]], AliquotSampleLabel],
                !MatchQ[Lookup[previousPrimitive[[1]], AliquotSampleLabel], ListableP[Null]],
                MatchQ[{"Test String"}, ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]]
              ],
                Module[{primaryInput, aliquotSampleLabels},
                  (* Do we have a primary input option as well? *)
                  primaryInput=If[!MatchQ[FirstOrDefault[Lookup[primitiveInformation, InputOptions]], Null],
                    Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[primitiveInformation, InputOptions]]],
                    {}
                  ];

                  (* Get our aliquot label option. *)
                  aliquotSampleLabels=Lookup[previousPrimitive[[1]], AliquotSampleLabel];

                  (* Is our primary Input the same length as our aliquot label option? *)
                  Which[
                    (* Is our aliquot label option completely filled out? If so, then just use it. *)
                    !MemberQ[ToList[aliquotSampleLabels], Null],
                      ToList[aliquotSampleLabels],
                    (* Otherwise, this implies that our aliquot label option has some Nulls in it. *)
                    (* If our primary input option is the same length as our aliquot label option, then autofill from that. *)
                    (* NOTE: This SHOULD be the case unless we have a very weird situation going on. *)
                    Length[primaryInput]==Length[aliquotSampleLabels],
                      MapThread[
                        Function[{input, aliquotSampleLabel},
                          If[MatchQ[aliquotSampleLabel, Null],
                            input,
                            aliquotSampleLabel
                          ]
                        ],
                        {primaryInput, aliquotSampleLabels}
                      ],
                    (* Otherwise, just use the aliquot label option, but without Nulls. *)
                    True,
                      Cases[ToList[aliquotSampleLabels], Except[Null]]
                  ]
                ],

              (* Last primitive had primary input. Take that. *)
              And[
                !MatchQ[FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]], Null],
                MatchQ[
                  Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]]],
                  ReleaseHold[Lookup[primaryInputOptionDefinition,"Pattern"]]
                ]
              ],
                Lookup[previousPrimitive[[1]], FirstOrDefault[Lookup[previousPrimitiveInformation, InputOptions]]],

              (* Don't know what to take! Use a water sample and report an error. *)
              True,
                Module[{},
                  AppendTo[invalidAutofillPrimitivesWithIndices, {primitive, index}];
                  fakeWaterSample
                ]
            ];

            (* Add our resolved primary input to our primitive. *)
            Append[
              primitive[[1]],
              primaryInputOption->resolvedPrimaryInput
            ]
          ]
        ]
      ];

      (* -- Call our Primitive Method Resolver Function -- *)
      (* For each option in our primitive, replace any labels with their respective objects. *)
      (* If we find an invalid label (that hasn't been initialized yet), keep track of it. *)
      allPrimitiveOptionsWithSimulatedObjects=KeyValueMap[
        Function[{option, value},
          Module[{optionDefinition},
            (* Lookup information about this option. *)
            optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

            (* Do does this option allow for PreparedSample or PreparedContainer? *)
            Which[
              MatchQ[optionDefinition, Null],
                (* We don't know about this option. *)
                Nothing,
              (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
              (* Cases will only look inside of lists, not associations. *)
              Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                (* Nothing to replace. *)
                option->value,
              True,
                (* We may potentially have some labels. *)
                Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption, unknownLabels, knownLabels, optionValueWithoutUnknownLabels},
                  (* Match the value of our option to the widget that we have. *)
                  (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                  matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                  (* Look for matched object widgets that have labels. *)
                  (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                  (* to separate legit strings from objects that were turned into strings. *)
                  objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                  (* This will give us our labels. *)
                  labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                  (* Do we have labels that we don't know about? *)
                  unknownLabels=Complement[labelsInOption, Lookup[currentSimulation[[1]], Labels][[All,1]]];
                  knownLabels=Complement[labelsInOption, unknownLabels];

                  (* If we have unknown labels, replace those labels with fake water samples/containers. *)
                  optionValueWithoutUnknownLabels=If[Length[unknownLabels]>0,
                    AppendTo[invalidLabelPrimitivesWithIndices,{unknownLabels,index,primitive}];

                    value/.{(Alternatives@@unknownLabels)->fakeWaterSample},
                    value
                  ];

                  (* Replace any other labels that we have with their values from our simulation. *)
                  option-> (
                    optionValueWithoutUnknownLabels /. (#1 -> Lookup[Lookup[currentSimulation[[1]], Labels], #1]&) /@ knownLabels
                  )
                ]
            ]
          ]
        ],
        primitiveOptionsWithResolvedPrimaryInput
      ];

      (* Separate out our primitive options into inputs and function options. *)
      inputsFromPrimitiveOptions=(Lookup[allPrimitiveOptionsWithSimulatedObjects, #, Null]&)/@Lookup[primitiveInformation, InputOptions];
      optionsFromPrimitiveOptions=Cases[
        allPrimitiveOptionsWithSimulatedObjects,
        Verbatim[Rule][
          Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
          _
        ]
      ];

      (* Download some necessary information for transfer splitting and rearranging. Need to do this after every primitive resolving, based on the most recent simulation *)
      (* Get the containers and destinations of any samples that we have. *)
      downloadInformation=If[
        And[
          MatchQ[primitive,_Transfer],
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        (* Only do Download if we need to since this information is only needed in Transfer splitting and expansion *)
        Quiet[
          Download[
            {
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]],
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container]]],
              Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Model[Container]]]
            },
            {
              {
                Packet[Container, Position, NumberOfWells, Model, Ventilated, Volume],
                Packet[Model[Ventilated]],
                Packet[Container[Model]],
                Packet[Container[Model][NumberOfWells]]
              },
              {
                Packet[Contents[[All, 2]][{Ventilated, Position, Container, Volume}]],
                Packet[Contents[[All, 2]][Model][{Ventilated}]],
                Packet[Model,Contents],
                Packet[Model[{NumberOfWells,Positions}]]
              },
              {
                Packet[NumberOfWells,Positions]
              }
            },
            Simulation->currentSimulation,
            Cache->cacheBall
          ],
          {Download::FieldDoesntExist, Download::NotLinkField}
        ],
        {{},{},{}}
      ];
      fastCacheBall = makeFastAssocFromCache[Cases[Flatten[downloadInformation], _Association]];
      allContainerContentsPackets=Flatten[downloadInformation[[2,All,1]]];
      allSamplePackets=Flatten[downloadInformation[[1,All,1]]];
      allContainerModelPackets=DeleteDuplicates@Flatten[{downloadInformation[[2,All,4]],downloadInformation[[3]]}];
      containerModelToPosition=Map[
        Lookup[#,Object]->Lookup[Lookup[#,Positions],Name]&,
        allContainerModelPackets
      ];
      allContainerPackets=DeleteDuplicates@Flatten[downloadInformation[[2,All,3]]];

      (* Track the counter of "transfer destination sample" because we may need to create some labels below for split transfers before calling ExperimentTransfer. However, we may not end up using these if we end up resolving to Manual *)
      transferDestinationSampleLabelCounter=Lookup[Constellation`Private`$UniqueLabelLookup,"transfer destination sample",0];

      (* NOTE: Not all inputs are required (ex. PCR). If we don't find the input, pass down Automatic. *)
      (* NOTE: If we have a Transfer primitive and we're transferring less than 450mL in this primitive (the maximum *)
      (* amount to transfer robotically in a single primitive) or if the user has specified to perform this primitive *)
      (* robotically, we have to expand any transfers more than 970 Microliter into multiple transfers. *)
      (* NOTE: We use this when resolving the primitive method to see if we should be robotic. *)
      {inputsFromPrimitiveOptionsWithExpandedTransfers, optionsFromPrimitiveOptionsWithExpandedTransfers}=If[And[
          MatchQ[primitive,_Transfer],
          MatchQ[Total[Append[Cases[Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount], VolumeP],0Milliliter]], LessEqualP[450 Milliliter]],
          MemberQ[Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount], (GreaterP[970 Microliter]|All)],
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        Module[{allDestinations,allDestinationWells,allTransferAmounts,convertedTransferAmounts, largeVolumePositions, volumesToReplace, currentModelContainerInteger, expandedSources, expandedDestinations, expandedAmounts, expandedDestinationLabels, expandedOptions, allPreviousTransfers, containerObjectToUsedPositions},

          (* Get the destination information to help us decide the amount for All transfer *)
          allDestinations=Lookup[allPrimitiveOptionsWithSimulatedObjects,Destination]/.{object:LinkP[]:>Download[object,Object]};
          allDestinationWells=Lookup[
            allPrimitiveOptionsWithSimulatedObjects,
            DestinationWell,
            ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
          ];
          allTransferAmounts=Lookup[allPrimitiveOptionsWithSimulatedObjects, Amount];
          (* Initialize previous transfer tracking for each transfer in this UO *)
          allPreviousTransfers={};
          (* Create a temporary map of simulated container ID to used positions. This is to help us resolve DestinationWell. *)
          (* We have to do this here because we don't actually know what wells are going to be used until time of transfer in the MapThread so this is cheating a bit. *)
          (* This is the same logic as in ExperimentTransfer *)
          containerObjectToUsedPositions=Association[Map[
            If[MatchQ[Lookup[#, Contents, {}],$Failed|{}],
              Lookup[#, Object] -> {},
              Lookup[#, Object] -> Lookup[#, Contents][[All,1]]
            ]&,
            allContainerPackets
          ]];

          (* Convert the All amount transfers to volume transfers *)
          convertedTransferAmounts=MapThread[
            Function[
              {source,sourceWell,amount,destination,destinationWell,transferIndex},
              Module[
                {sourceContainerObject,sourceSampleObject,sourceSamplePacket,resolvedSourceWell,destinationSampleObject,destinationSamplePacket,destinationContainerObject,destinationContainerModel,resolvedDestinationWell,defaultWaterModelVolume,defaultModelVolume,previousTransfersInAmounts,previousTransfersOutAmounts,totalTransferredInAmount,totalTransferredOutAmount,totalTransferredAmount,finalAmount},

                (* Get the sample object *)
                sourceSampleObject=If[MatchQ[source, ObjectP[Object[Sample]]],
                  Download[source,Object],
                  Null
                ];

                sourceSamplePacket=fetchPacketFromFastAssoc[sourceSampleObject, fastCacheBall];

                (* Get the container object. Set to the sample's container if it is a sample *)
                sourceContainerObject=Which[
                  MatchQ[source, {_, ObjectP[Object[Container]]}],
                    Download[source[[2]],Object],
                  MatchQ[source,ObjectP[Object[Container]]],
                    Download[source,Object],
                  !NullQ[sourceSamplePacket],
                    Download[Lookup[sourceSamplePacket,Container],Object],
                  (* If we have an indexed container, make sure to keep it so we can recognize the same container later. *)
                  MatchQ[source, {_Integer, ObjectP[Model[Container]]}],
                    {source[[1]],Download[source[[2]],Object]},
                  True,
                    Null
                ];

                (* Resolve the source well option, using the same logic from ExperimentTransfer, so that we can decide the exact sample to change All amount to amount *)
                (* NOTE: If you want to change this, please also change ExperimentTransfer. Resolving source well shows up in multiple branches in ExperimentTransfer. *)
                resolvedSourceWell=Which[
                  (* Did the user give us an option? *)
                  MatchQ[sourceWell, Except[Automatic]],
                    sourceWell,
                  !NullQ[sourceSamplePacket],
                    Lookup[sourceSamplePacket,Position],
                  (* We do not care about source well if we are dealing with a sample model since we won't be able to transfer into it *)
                  MatchQ[source,ObjectP[Model[Sample]]],
                    Null,
                  (* Were we given {_String, ObjectP[Object[Container]]} as input? *)
                  MatchQ[source, {_String, ObjectP[Object[Container]]}],
                    source[[1]],
                  (* Do we have a sample in this container that is non-empty? *)
                  (* The sample must be liquid to be transferred robotically so we only need to consider volume here *)
                  MatchQ[source,ObjectP[Object[Container]]]&&MatchQ[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container->ObjectP[sourceContainerObject], Volume -> GreaterP[0 Liter]}], Null], PacketP[]],
                    Lookup[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container->ObjectP[sourceContainerObject], Volume -> GreaterP[0 Liter]}], Null], Position],
                  (* Do we have a destination transfer into this container later? If so, take the destination well of that. *)
                  MatchQ[FirstCase[Transpose[{allDestinations, allDestinationWells}], {ObjectP[sourceContainerObject], position_String}:>position], _String],
                    FirstCase[Transpose[{allDestinations, allDestinationWells}], {ObjectP[sourceContainerObject], position_String}:>position],
                  (* Give up and use "A1". *)
                  True,
                    "A1"
                ];

                (* Get the sample object *)
                destinationSampleObject=If[MatchQ[destination, ObjectP[Object[Sample]]],
                  Download[destination,Object],
                  Null
                ];

                destinationSamplePacket=fetchPacketFromFastAssoc[destinationSampleObject, fastCacheBall];

                (* Resolve the destination *)
                destinationContainerObject=Which[
                  MatchQ[destination, {_, ObjectP[Object[Container]]}],
                    Download[destination[[2]],Object],
                  MatchQ[destination,ObjectP[Object[Container]]],
                    Download[destination,Object],
                  !NullQ[destinationSamplePacket],
                    Download[Lookup[destinationSamplePacket,Container],Object],
                  (* If we have an indexed container, make sure to keep it so we can recognize the same container later. *)
                  MatchQ[destination, {_Integer, ObjectP[Model[Container]]}],
                    {destination[[1]],Download[destination[[2]],Object]},
                  (* We do not care about destination container if it is a pure model since we will treat it as a new container every time *)
                  True,
                    Null
                ];
                (* Get the destination's model packet *)
                destinationContainerModel=Which[
                  MatchQ[destinationContainerObject,ObjectP[Object[Container]]],
                    Download[Lookup[fetchPacketFromFastAssoc[destinationContainerObject,fastCacheBall],Model],Object],
                  MatchQ[destinationContainerObject,{_,ObjectP[Model[Container]]}],
                    destinationContainerObject[[2]],
                  True,
                    Null
                ];
                (* Resolve the destination well option, using the same logic from ExperimentTransfer, so that we can look at the sample transfer history correctly *)
                (* NOTE: If you want to change this, please also change ExperimentTransfer. Resolving destination well shows up in multiple branches in ExperimentTransfer. *)
                resolvedDestinationWell=Which[
                  MatchQ[destinationWell, Except[Automatic]],
                    destinationWell,
                  !NullQ[destinationSamplePacket],
                    Lookup[destinationSamplePacket,Position],
                  (* Well/Container *)
                  MatchQ[destination, {_String, ObjectP[Object[Container]]}],
                    destination[[1]],
                  (* Container object - Find first empty position *)
                  MatchQ[destination,ObjectP[Object[Container]]],
                    Module[{emptyPositions},
                      (* Try to get the empty positions of this container. *)
                      emptyPositions=UnsortedComplement[
                        Lookup[containerModelToPosition,destinationContainerModel],
                        (* Used position in container before *)
                        Lookup[containerObjectToUsedPositions,destinationContainerObject,{}],
                        (* Destination of previous transfers *)
                        Cases[allPreviousTransfers,{_,_,destinationContainerObject,_,_}][[All,4]]
                      ];
                      FirstOrDefault[emptyPositions, "A1"]
                    ],
                  (* Container model with index - Find first empty position *)
                  MatchQ[destination,{_Integer, ObjectP[Model[Container]]}],
                    Module[{emptyPositions},
                      (* Try to get the empty positions of this container. *)
                      emptyPositions=UnsortedComplement[
                        Lookup[containerModelToPosition,destinationContainerModel],
                        (* Used position in container before *)
                        Lookup[containerObjectToUsedPositions,destinationContainerObject,{}],
                        (* Destination of previous transfers *)
                        Cases[allPreviousTransfers,{_,_,destinationContainerObject,_,_}][[All,4]]
                      ];
                      FirstOrDefault[emptyPositions, "A1"]
                    ],
                  True,
                    "A1"
                ];
                (* By default, we request 1.5 mL resource for Model[Sample,"Milli-Q water"] in Transfer resolution, if no Amount is provided *)
                defaultWaterModelVolume=$MicroWaterMaximum;
                (* By default, we request 1mL resource for Model[Sample] (except water) in Transfer resolution, if no Amount is provided *)
                defaultModelVolume=1Milliliter;
                (* Check if we have transferred any sample into the destination well BEFORE this transfer  *)
                (* Get the transfers that have gone into this position/sample earlier and get the list of the transfer amounts *)
                previousTransfersInAmounts=Cases[
                  allPreviousTransfers,
                  {_,_,sourceContainerObject,resolvedSourceWell,amount:VolumeP}:>amount
                ];
                previousTransfersOutAmounts=Cases[
                  allPreviousTransfers,
                  {sourceContainerObject,resolvedSourceWell,_,_,amount:VolumeP}:>amount
                ];

                (* Get the total amount of samples. If there is no sample, set to 0 *)
                totalTransferredInAmount=If[MatchQ[previousTransfersInAmounts,{}],
                  0Milliliter,
                  Total[previousTransfersInAmounts]
                ];
                totalTransferredOutAmount=If[MatchQ[previousTransfersOutAmounts,{}],
                  0Milliliter,
                  Total[previousTransfersOutAmounts]
                ];

                totalTransferredAmount=totalTransferredInAmount-totalTransferredOutAmount;

                (* Get the sample volume to replace All *)
                finalAmount=Which[
                  (* Keep the amount if it is not All *)
                  !MatchQ[amount,All],
                    amount,
                  MatchQ[source,ObjectP[Object[Sample]]],
                    (* Old sample volume + any transfer into the sample *)
                    Max[Lookup[sourceSamplePacket, Volume, defaultModelVolume]+totalTransferredAmount,0Milliliter],
                  (* For model sample, default to their resource fulfillment volume *)
                  MatchQ[source,ObjectP[Model[Sample,"id:8qZ1VWNmdLBD"]]],
                    defaultWaterModelVolume,
                  MatchQ[source,ObjectP[Model[Sample]]],
                    defaultModelVolume,
                  (* Container. Find the existing sample volume and add the transfer volume *)
                  (* If none available, safely set to the default volume *)
                  MatchQ[source,{_String, ObjectP[Object[Container]]}|ObjectP[Object[Container]]],
                    Max[
                      Total[{
                        Lookup[FirstCase[allContainerContentsPackets, KeyValuePattern[{Container -> ObjectP[sourceContainerObject], Position -> resolvedSourceWell}], <||>], Volume, 0Milliliter],
                        totalTransferredAmount
                      }],
                      0Milliliter
                    ]/.{amount:EqualP[0Milliliter]:>defaultModelVolume},
                  (* Index model container. Use the transfer volume *)
                  (* If none available, safely set to the default volume *)
                  MatchQ[source,{_, ObjectP[Model[Container]]}],
                    Max[totalTransferredAmount,0Milliliter]/.{amount:EqualP[0Milliliter]:>defaultModelVolume},
                  True,
                    defaultModelVolume
                ];
                (* Record this transfer *)
                AppendTo[allPreviousTransfers,{sourceContainerObject,resolvedSourceWell,destinationContainerObject,resolvedDestinationWell,finalAmount}];
                finalAmount
              ]
            ],
            {
              Lookup[allPrimitiveOptionsWithSimulatedObjects, Source],
              (* SourceWell *)
              Lookup[
                allPrimitiveOptionsWithSimulatedObjects,
                SourceWell,
                ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
              ],
              allTransferAmounts,
              allDestinations,
              allDestinationWells,
              Range[Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]
            }
          ];

          (* Get all positions in which we have an amount greater than 970 Microliter. *)
          largeVolumePositions=Position[convertedTransferAmounts, GreaterP[970 Microliter]];

          (* Get the volumes that should replace these large volumes. *)
          (* This step is to split any transfer over 970 uL into multiple transfers. This logic here matches the logic in splitTransfersBy970  *)
          (* here we are splitting the transfer evenly rather than in 970 increments.  This is because if we want to transfer 970.5 uL, we don't want to transfer 970 uL then 0.5 uL.  We want to do 970.5 uL / 2. This can avoid doing an invalid transfer - < 1 uL transfer is invalid and also can improve the inaccuracy of each individual transfer *)
          (* the way this happens is a little goofy; basically take the total amount to transfer, and divide it by the quotient + 1 (if there is a remainder); if there is no remainder, just do it in 970 increments directly *)
          volumesToReplace=Map[
            Module[
              {quotient,mod},
              mod=Mod[#, 970 Microliter];
              quotient=Quotient[#, 970 Microliter];
              If[MatchQ[mod,0Microliter],
                ConstantArray[970Microliter, quotient],
                ConstantArray[RoundOptionPrecision[#/(quotient+1), 10^-1 Microliter, Round -> Down, AvoidZero -> True], (quotient+1)]
              ]
            ]&,
            Extract[convertedTransferAmounts, largeVolumePositions]
          ];

          (* Keep track of an integer to make Model[Container]s distinct when we expand them. *)
          currentModelContainerInteger=Max[
            Append[
              Cases[Flatten[Lookup[allPrimitiveOptionsWithSimulatedObjects, {Source, Destination}]], _Integer],
              1
            ]
          ];

          (* Expand the source/destination inputs and options. *)
          expandedSources=ReplacePart[
            Lookup[allPrimitiveOptionsWithSimulatedObjects, Source],
            MapThread[
              Function[{position, volumeList},
                If[MatchQ[Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position], ObjectP[Model[Container]]],
                  Module[{returnValue},
                    returnValue=position->Sequence@@ConstantArray[
                      {currentModelContainerInteger, Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position]},
                      Length[volumeList]
                    ];

                    currentModelContainerInteger=currentModelContainerInteger+1;

                    returnValue
                  ],
                  position->Sequence@@ConstantArray[
                    Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source], position],
                    Length[volumeList]
                  ]
                ]
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          expandedDestinations=ReplacePart[
            Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination],
            MapThread[
              Function[{position, volumeList},
                If[MatchQ[Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position], ObjectP[Model[Container]]],
                  Module[{returnValue},
                    returnValue=position->Sequence@@ConstantArray[
                      {currentModelContainerInteger, Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position]},
                      Length[volumeList]
                    ];

                    currentModelContainerInteger=currentModelContainerInteger+1;

                    returnValue
                  ],
                  position->Sequence@@ConstantArray[
                    Extract[Lookup[allPrimitiveOptionsWithSimulatedObjects, Destination], position],
                    Length[volumeList]
                  ]
                ]
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          expandedAmounts=ReplacePart[
            convertedTransferAmounts,
            MapThread[
              Function[{position, volumeList},
                position->Sequence@@volumeList
              ],
              {largeVolumePositions, volumesToReplace}
            ]
          ];

          (* When we expand the volumes, we also need to make sure our destinations are kept the same. *)
          (* This is not an issue for a normal transfer with a set destination but can be a problem if our destination is a container and we are looking for the first non-empty position *)
          (* We do this by feeding the same DestinationLabel to transfer if not set *)
          expandedDestinationLabels=Module[
            {suppliedDestinationLabels,destinationLabelReplacementRules},
            suppliedDestinationLabels=Lookup[allPrimitiveOptionsWithSimulatedObjects,DestinationLabel,ConstantArray[Automatic,Length[Lookup[allPrimitiveOptionsWithSimulatedObjects, Source]]]];
            destinationLabelReplacementRules=MapThread[
              If[MatchQ[suppliedDestinationLabels[[#1[[1]]]],_String],
                (* If there is already a label provided by the user, expand it (this is the same as other options) *)
                #1->Sequence@@ConstantArray[suppliedDestinationLabels[[#1[[1]]]],Length[#2]],
                (* If there is no existing label, create a unique label *)
                #1->Sequence@@ConstantArray[CreateUniqueLabel["transfer destination sample"],Length[#2]]
              ]&,
              {
                largeVolumePositions,
                volumesToReplace
              }
            ];
            ReplacePart[suppliedDestinationLabels,destinationLabelReplacementRules]
          ];

          expandedOptions=Module[{primitiveOptionDefinitions, indexMatchingOptionSymbols, indexMatchingOptions, nonIndexMatchingOptions, expandedIndexMatchingOptions},
            (* Get the option definition. *)
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

            (* Get the index matching options. *)
            indexMatchingOptionSymbols=Lookup[
              DeleteDuplicates@Cases[primitiveOptionDefinitions,
                Alternatives[
                  KeyValuePattern[{"IndexMatchingParent"->Except[Null]}],
                  KeyValuePattern[{"IndexMatchingInput"->Except[Null]}]
                  ]
                ],
              "OptionSymbol"
            ];
            indexMatchingOptions=Cases[
              optionsFromPrimitiveOptions,
              Verbatim[Rule][
                Alternatives@@indexMatchingOptionSymbols,
                _
              ]
            ];
            nonIndexMatchingOptions=Complement[
              optionsFromPrimitiveOptions,
              indexMatchingOptions
            ];

            (* Expand the index matching options. *)
            (* NOTE: We have to specify to only normalize the association here because there was a bug where Normal was converting *)
            (* options with AngularDegree to radians. *)
            expandedIndexMatchingOptions=Normal[
              KeyValueMap[
                Function[{key, option},
                  key->ReplacePart[
                    option,
                    MapThread[
                      Function[{position, volumeList},
                        position->Sequence@@ConstantArray[
                          Extract[option, position],
                          Length[volumeList]
                        ]
                      ],
                      {largeVolumePositions, volumesToReplace}
                    ]
                  ]
                ],
                Association[indexMatchingOptions]
              ],
              Association
            ];

            Join[ReplaceRule[expandedIndexMatchingOptions,DestinationLabel->expandedDestinationLabels], nonIndexMatchingOptions]
          ];

          {
            {
              expandedSources,
              expandedDestinations,
              expandedAmounts
            },
            expandedOptions
          }
        ],
        {inputsFromPrimitiveOptions, optionsFromPrimitiveOptions}
      ];

      (* If we have a Transfer primitive, detect transfers that are defined in row order instead of column order and *)
      (* rearrange them. *)
      (* Exclude the transfers specified as MultiProbeHead transfers since that is not necessary and can lead to problems *)
      (* For back-to-back MPH transfers, we may have combined multiple UOs into one UO as of now. They may have different volumes/pipetting parameters. If we rearrange in row instead of column, we may actually break the MPH MxN format *)
      {inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers}=If[And[
          MatchQ[primitive,_Transfer],
          Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]]>1,
          !MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Automatic], ListableP[ManualPrimitiveMethodsP]],
          MatchQ[optimizeUnitOperations, True],
          MatchQ[previewFinalizedUnitOperations, True]
        ],
        Module[
          {sourceWells, destinationWells, sourceContainers, destinationContainers, groupedTransfers, nonIndexMatchingOptionsForTransfer,
            transposed384WellNamesByColumn, idealWellOrder, reorderedIndices, groupedTransfersWithoutReusingDestinations},

          (* Get the source and destination wells that we're transferring from/to. *)
          sourceWells=MapThread[
            Function[{source, sourceWellOption},
              Which[
                (* If the source well option is set, use that. *)
                MatchQ[sourceWellOption, _String],
                  sourceWellOption,
                (* If we're given the source well in the input, use that. *)
                MatchQ[source, {_String, _}],
                  source[[1]],
                (* If we have a sample, lookup the position of the sample from the packet. *)
                MatchQ[source, ObjectP[Object[Sample]]],
                  Lookup[fetchPacketFromFastAssoc[source, fastCacheBall], Position],
                (* Otherwise, assume that we're going to aspirate from "A1". *)
                True,
                  "A1"
              ]
            ],
            {
              inputsFromPrimitiveOptionsWithExpandedTransfers[[1]],
              Lookup[
                optionsFromPrimitiveOptionsWithExpandedTransfers,
                SourceWell,
                ConstantArray[Automatic, Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]]]
              ]
            }
          ];

          destinationWells=MapThread[
            Function[{destination, destinationWellOption},
              Which[
                (* If the source well option is set, use that. *)
                MatchQ[destinationWellOption, _String],
                  destinationWellOption,
                (* If we're given the source well in the input, use that. *)
                MatchQ[destination, {_String, _}],
                  destination[[1]],
                (* If we have a sample, lookup the position of the sample from the packet. *)
                MatchQ[destination, ObjectP[Object[Sample]]],
                  Lookup[fetchPacketFromFastAssoc[destination, fastCacheBall], Position],
                (* Otherwise, assume that we're going to aspirate from "A1". *)
                True,
                  "A1"
              ]
            ],
            {
              inputsFromPrimitiveOptionsWithExpandedTransfers[[2]],
              Lookup[
                optionsFromPrimitiveOptionsWithExpandedTransfers,
                DestinationWell,
                ConstantArray[Automatic, Length[inputsFromPrimitiveOptionsWithExpandedTransfers[[2]]]]
              ]
            }
          ];

          (* Get the source containers/destination containers that we're transferring to/from. *)
          sourceContainers=Map[
            Function[{source},
              Which[
                MatchQ[source, ObjectP[Object[Sample]]],
                  Download[Lookup[fetchPacketFromFastAssoc[source, fastCacheBall], Container], Object],
                MatchQ[source, ObjectP[Object[Container]]],
                  source,
                MatchQ[source, {_, ObjectP[Object[Container]]}],
                  source[[2]],
                True,
                  source
              ]
            ],
            inputsFromPrimitiveOptionsWithExpandedTransfers[[1]]
          ];

          destinationContainers=Map[
            Function[{destination},
              Which[
                MatchQ[destination, ObjectP[Object[Sample]]],
                  Download[Lookup[fetchPacketFromFastAssoc[destination, fastCacheBall], Container], Object],
                MatchQ[destination, ObjectP[Object[Container]]],
                  destination,
                MatchQ[destination, {_, ObjectP[Object[Container]]}],
                  destination[[2]],
                True,
                  destination
              ]
            ],
            inputsFromPrimitiveOptionsWithExpandedTransfers[[2]]
          ];

          nonIndexMatchingOptionsForTransfer=Cases[OptionDefinition[ExperimentTransfer],KeyValuePattern["IndexMatching" -> "None"]][[All, "OptionSymbol"]];

          (* Split our transfers into groups of the same sources and destinations. *)
          (* NOTE: We also split by tip type here because we don't want to rearrange transfer order across different tip types *)
          (* if tip types have been specified. This is because we can mess up full plate stamps this way. Imagine the scenario where *)
          (* we have the following transfer destinations {"A1", "A1", ..., "H12"} with the tips {tip1, tip2, ..., tip2}. If we optimized *)
          (* across the group we would get {"A1", "A2", ..., "H12", "A1"} and would mess up our perfect plate stamp. *)
          (* We also want to avoid grouping MPH transfers with other transfers as we don't want to rearrange MPH transfers *)
          groupedTransfers=SplitBy[
            Transpose[{
              sourceContainers,
              destinationContainers,
              sourceWells,
              destinationWells,
              Transpose[inputsFromPrimitiveOptionsWithExpandedTransfers],
              If[MatchQ[Normal@KeyDrop[optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer], {}],
                ConstantArray[{}, Length[sourceContainers]],
                (* Remove non index-matching options back so we don't expand them unexpectedly *)
                OptionsHandling`Private`mapThreadOptions[ExperimentTransfer, Normal@KeyDrop[optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer]]
              ],
              Lookup[optionsFromPrimitiveOptionsWithExpandedTransfers, Tips, ConstantArray[Automatic, Length[sourceContainers]]],
              (* Treat any non MultiProbeHead transfers as Automatic for grouping purposes *)
              Replace[
                Lookup[optionsFromPrimitiveOptionsWithExpandedTransfers, DeviceChannel, ConstantArray[Automatic, Length[sourceContainers]]],
                {Except[MultiProbeHead]->Automatic},
                1
              ]
            }],
            ({#[[1]], #[[2]], #[[7]], #[[8]]}&)
          ];

          (* Split transfer groups further so that we don't use a destination sample in the group as a source (since this would result in an incorrect transfer). *)
          groupedTransfersWithoutReusingDestinations=Map[
            Function[{transferGroup},
              Module[{allTransferSubgroups, currentTransferSubgroup, currentTransferSubgroupDestinationContainerAndWells},
                allTransferSubgroups={};
                currentTransferSubgroup={};
                currentTransferSubgroupDestinationContainerAndWells={};

                Map[
                  Function[{transferTuple},
                    If[!MemberQ[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[1]], transferTuple[[3]]}],
                      Module[{},
                        AppendTo[currentTransferSubgroup, transferTuple];
                        AppendTo[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[2]], transferTuple[[4]]}];
                      ],
                      Module[{},
                        AppendTo[allTransferSubgroups, currentTransferSubgroup];

                        currentTransferSubgroup={};
                        currentTransferSubgroupDestinationContainerAndWells={};

                        AppendTo[currentTransferSubgroup, transferTuple];
                        AppendTo[currentTransferSubgroupDestinationContainerAndWells, {transferTuple[[2]], transferTuple[[4]]}];
                      ]
                    ]
                  ],
                  transferGroup
                ];

                If[Length[currentTransferSubgroup]>0,
                  AppendTo[allTransferSubgroups, currentTransferSubgroup]
                ];

                Sequence@@allTransferSubgroups
              ]
            ],
            groupedTransfers
          ];

          (* Assign the transposed 384-well plate well order to a variable since it's slow to compute *)
          transposed384WellNamesByColumn = Transpose[AllWells[NumberOfWells -> 384]];

          (* Define ideal well orders for common plate layouts *)
          idealWellOrder[96] = Flatten[Transpose[AllWells[]]];
          (* for 384-well plates we want to preserve "sub-plates" in the order and in the column order *)
          idealWellOrder[384] = Flatten[{Transpose@map384["A1"], Transpose@map384["B1"], Transpose@map384["A2"], Transpose@map384["B2"]}];
          (* For any other number of wells, use 96-well layout *)
          idealWellOrder[_] = idealWellOrder[96];

          (* For each transfer group, see if the source wells or destination wells are in row order instead of column order. *)
          (* If so, transpose the order. *)
          reorderedIndices=Map[
            Function[{transferGroup},
              (* If we only have one transfer in our group or this group is for MPH transfer, just return the index. *)
              If[(Length[transferGroup]==1)||MatchQ[transferGroup[[1,-1]],MultiProbeHead],
                transferGroup,
                Module[
                  {sourceContainer, destinationContainer, sourceIdealOrdering, destinationIdealOrdering, useSourceIdealOrderingQ,
                    idealOrderingToUse, wellToIndexLookup, wellToNumberOfTimesSeenLookup},

                  (* Get our source and destination container. *)
                  sourceContainer=First@First@transferGroup;
                  destinationContainer=(First@transferGroup)[[2]];

                  (* What's the ideal ordering for our source and destination containers. *)
                  sourceIdealOrdering=Which[
                    MatchQ[sourceContainer, ObjectP[Object[Container, Vessel]]],
                      ConstantArray["A1", Length[transferGroup]],
                    MatchQ[sourceContainer, ObjectP[Object[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[Lookup[fetchPacketFromFastAssoc[sourceContainer, fastCacheBall], Model], fastCacheBall], NumberOfWells]],
                    MatchQ[sourceContainer, ObjectP[Model[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[sourceContainer, fastCacheBall], NumberOfWells]],
                    MatchQ[sourceContainer, {_, ObjectP[Model[Container, Plate]]}],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[sourceContainer[[2]], fastCacheBall], NumberOfWells]],
                    True,
                      idealWellOrder[96]
                  ];

                  destinationIdealOrdering=Which[
                    MatchQ[destinationContainer, ObjectP[Object[Container, Vessel]]],
                      ConstantArray["A1", Length[transferGroup]],
                    MatchQ[destinationContainer, ObjectP[Object[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[Lookup[fetchPacketFromFastAssoc[destinationContainer, fastCacheBall], Model], fastCacheBall], NumberOfWells]],
                    MatchQ[destinationContainer, ObjectP[Model[Container, Plate]]],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[destinationContainer, fastCacheBall], NumberOfWells]],
                    MatchQ[destinationContainer, {_, ObjectP[Model[Container, Plate]]}],
                      idealWellOrder[Lookup[fetchPacketFromFastAssoc[destinationContainer[[2]], fastCacheBall], NumberOfWells]],
                    True,
                      idealWellOrder[96]
                  ];

                  (* Which ideal ordering should we use? *)
                  useSourceIdealOrderingQ=Length[LongestCommonSequence[transferGroup[[All,3]], sourceIdealOrdering]] >= Length[LongestCommonSequence[transferGroup[[All,4]], destinationIdealOrdering]];
                  idealOrderingToUse=If[useSourceIdealOrderingQ,
                    sourceIdealOrdering,
                    destinationIdealOrdering
                  ];

                  (* Create a lookup of well to index. *)
                  wellToIndexLookup=Rule@@@Transpose[{idealOrderingToUse, Range[Length[idealOrderingToUse]]}];

                  (* NOTE: If we're transferring into the same well multiple times, we want to try to go through the entire plate ordering first *)
                  (* before we transfer into that well again. The most common example of this is when we have to expand the volume that *)
                  (* the user gives us so the well ordering actually looks like {"A1", "A1", "A2", "A2" ..}. We want to transform this into *)
                  (* {"A1", "A2", ..., "A1", "A2", ...} aka two full plate stamps. *)

                  (* Create a lookup of the number of times we've seen the well in the ideal ordering. *)
                  wellToNumberOfTimesSeenLookup = <||>;

                  (* Create the reordering for our transfer group. *)
                  If[useSourceIdealOrderingQ,
                    SortBy[
                      transferGroup[[All,;;-2]],
                      Function[{group},
                        wellToNumberOfTimesSeenLookup[group[[3]]]=Lookup[wellToNumberOfTimesSeenLookup,group[[3]],0]+1;
                        Lookup[wellToIndexLookup,group[[3]]]+(Lookup[wellToNumberOfTimesSeenLookup,group[[3]]]*Length[idealOrderingToUse])
                      ]
                    ],
                    SortBy[
                      transferGroup[[All,;;-2]],
                      Function[{group},
                        wellToNumberOfTimesSeenLookup[group[[4]]]=Lookup[wellToNumberOfTimesSeenLookup,group[[4]],0]+1;
                        Lookup[wellToIndexLookup,group[[4]]]+(Lookup[wellToNumberOfTimesSeenLookup,group[[4]]]*Length[idealOrderingToUse])
                      ]
                    ]
                  ]
                ]
              ]
            ],
            groupedTransfersWithoutReusingDestinations
          ];

          (* NOTE: 5 is the index of the inputs, 6 is the index of the options. We want to combine all of the reordered groups into one *)
          (* big reordered list. *)
          (* NOTE: We have to be careful of the inputs list since there can be multiple inputs in the case of Transfer so we have to Transpose. *)
          (* For the options, we just have to Flatten and merge all the options into a list together. *)
          {
            Join@@@Transpose[Transpose/@(reorderedIndices[[All,All,5]])],
            (* Add non index-matching options back *)
            (* NOTE: We have to specify to only normalize the association here because there was a bug where Normal was converting *)
            (* options with AngularDegree to radians. *)
            Normal[Join[Merge[Flatten[(reorderedIndices[[All, All, 6]])], Join],KeyTake[Association@optionsFromPrimitiveOptionsWithExpandedTransfers,nonIndexMatchingOptionsForTransfer]], Association]
          }
        ],
        {inputsFromPrimitiveOptionsWithExpandedTransfers, optionsFromPrimitiveOptionsWithExpandedTransfers}
      ];

      (* Do we have a resolved PrimitiveMethod by which to resolve/simulate this primitive? *)
      resolvedPrimitiveMethod=If[MatchQ[Lookup[primitive[[1]], PrimitiveMethod], _Symbol],
        Lookup[primitive[[1]], PrimitiveMethod],
        (* Otherwise, we have to call the primitive method resolver function. *)
        Module[{primitiveResolverMethod,potentialRawMethods,potentialMethods},
          (* Lookup the method resolver function. *)
          primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];

          (* Pass down the inputs and options down to the resolver function. *)
          (* NOTE: We have to quiet here because we'll internally call the method resolver function again by calling the *)
          (* experiment function, so if there are messages, they'll be thrown there. *)
          potentialRawMethods=If[MatchQ[primitive, plateReaderPrimitiveP],
            Quiet[
              ToList@primitiveResolverMethod[
                Sequence@@inputFromPrimitiveOptionsWithRearrangedTransfers,
                Object[Protocol, Head[primitive]],
                Join[
                  optionsFromPrimitiveOptionsWithRearrangedTransfers,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall,
                    Output->Result
                  }
                ]
              ]
            ],
            Quiet[
              ToList@primitiveResolverMethod[
                Sequence@@inputFromPrimitiveOptionsWithRearrangedTransfers,
                Join[
                  optionsFromPrimitiveOptionsWithRearrangedTransfers,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall,
                    Output->Result
                  }
                ]
              ]
            ]
          ];

          (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
          (* on the experiment function that we're in. *)
          potentialMethods=Flatten@{
            Which[
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation],
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualCellPreparation],
              MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation|ManualCellPreparation|Experiment],
              True,
                {}
            ],
            Which[
              MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation],
              MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticCellPreparation],
              MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation|RoboticCellPreparation|Experiment],
              True,
                {}
            ]
          };

          (* From potentially multiple methods, pick the best one to use to resolve the primitive. *)
          Which[
            (* If we aren't able to perform this primitive via any method, default to Experiment and throw an error. *)
            Length[potentialMethods]==0,
              Module[{},
                AppendTo[invalidResolvePrimitiveMethodsWithIndices, {primitive, index}];

                Experiment
              ],
            (* Are we in a Manual or Robotic specific experiment function? *)
            (* NOTE: Even if these methods aren't part of the returned list, we will pass the Preparation option down *)
            (* to the experiment function later and its method resolver function should yell at us if this is a problem. *)
            MatchQ[myFunction, ExperimentManualSamplePreparation],
              ManualSamplePreparation,
            MatchQ[myFunction, ExperimentManualCellPreparation],
              ManualCellPreparation,
            MatchQ[myFunction, ExperimentRoboticSamplePreparation],
              RoboticSamplePreparation,
            MatchQ[myFunction, ExperimentRoboticCellPreparation],
              RoboticCellPreparation,
            (* If we only have one method, then it's clear which one to use. *)
            Length[potentialMethods]==1,
              First[potentialMethods],
            (* Do we already have a primitive in our primitive grouping and we can continue that method type? *)
            (* OTHERWISE, we will need to start a new primitive grouping. *)
            Length[currentPrimitiveGrouping]>0 && MemberQ[potentialMethods, Lookup[First[currentPrimitiveGrouping][[1]], PrimitiveMethod]],
              Lookup[First[currentPrimitiveGrouping][[1]], PrimitiveMethod],
            (* If we're choosing between Manual/non-Manual AND we're not LabelSample/LabelContainer/Wait, pick non-Manual. *)
            And[
              Length[potentialMethods]>1,
              MemberQ[potentialMethods, Except[ManualPrimitiveMethodsP]],
              !MatchQ[primitive, _LabelSample|_LabelContainer|_Wait],
              Or[
                Not[MatchQ[primitive, _Transfer]],
                And[
                  MatchQ[primitive, _Transfer] && Max[Flatten[{Cases[primitive[Amount], VolumeP], 0 Milliliter}]] <= 10 Milliliter,
                  !MemberQ[ToList[primitive[Amount]],All]
                ]
              ]
            ],
              FirstOrDefault[Cases[potentialMethods, Except[ManualPrimitiveMethodsP]]],
            (* if we're choosing between Manual/non-Manual and have a Transfer that is more than 10 mL or use All, pick Manual *)
            And[
              Length[potentialMethods]>1,
              MemberQ[potentialMethods, Except[RoboticPrimitiveMethodsP]],
              MatchQ[primitive, _Transfer],
              Or[
                Max[Flatten[{Cases[primitive[Amount], VolumeP], 0 Milliliter}]] > 10 Milliliter,
                MemberQ[ToList[primitive[Amount]],All]
              ]
            ],
              FirstOrDefault[Cases[potentialMethods, Except[RoboticPrimitiveMethodsP]]],
            (* If we're just starting off and all of our primitives can be done manually, just choose manual. *)
            And[
              Length[allPrimitiveGroupings]==0,
              MemberQ[Intersection@@((ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives), ManualPrimitiveMethodsP]
            ],
              FirstOrDefault[Cases[potentialMethods, ManualPrimitiveMethodsP]],
            (* Try to solve the method globally for all primitives if we haven't started grouping at all. *)
            Length[allPrimitiveGroupings]==0 && Length[Intersection@@((ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives)]>0,
              Module[{allPrimitiveMethods},
                (* Try to get a common method between ALL primitives. *)
                (* NOTE: We stash the primitive methods that match the primitive method pattern ahead of time before calling the *)
                (* method resolver, so the intersection here may be incorrect. *)
                allPrimitiveMethods=(ToList[Lookup[#[[1]], PrimitiveMethod]]&)/@coverOptimizedPrimitives;

                (* Favor robotic methods over manual methods. *)
                First@SortBy[
                  Intersection[potentialMethods, Intersection@@allPrimitiveMethods],
                  (Position[{RoboticSamplePreparation, RoboticCellPreparation, ManualSamplePreparation, ManualCellPreparation}, #, 5]&)
                ]
              ],
            (* Otherwise, pick based on what the other primitives within the local vicinity of this primitive look like. *)
            (* We only look ahead because at this point, we're going to start a new method grouping so we don't care about the past. *)
            True,
              Module[{nextRealPrimitiveIndex, surroundingPrimitives,surroundingPrimitiveMethods,mostCommonPrimitiveMethods},
                (* Get the first future index that does not contain _LabelSample|_LabelContainer|_Wait. *)
                (* This is because these primitives can always be performed via any method so it doesn't give us any additional *)
                (* information to include these. *)
                nextRealPrimitiveIndex=FirstPosition[coverOptimizedPrimitives[[index;;-1]], Except[_LabelSample|_LabelContainer|_Wait], {1}][[1]] + index - 1;

                (* Get the primitives that surround this primitive. *)
                surroundingPrimitives=Take[
                  coverOptimizedPrimitives,
                  {
                    index,
                    Min[{Length[coverOptimizedPrimitives], nextRealPrimitiveIndex+5}]
                  }
                ];

                (* Lookup the PrimitiveMethod keys from these primitives. *)
                surroundingPrimitiveMethods=Cases[(Lookup[#[[1]], PrimitiveMethod, Automatic]&)/@surroundingPrimitives, Except[Automatic]];

                (* Of our potential methods, get the ones that are the most common, in relation to our surrounding primitives. *)
                mostCommonPrimitiveMethods=UnsortedIntersection[potentialMethods,Commonest[Flatten[surroundingPrimitiveMethods]], DeleteDuplicates -> True];

                (* If we have nothing in common with our surrounding primitives, just take the first method. *)
                If[Length[mostCommonPrimitiveMethods]==0,
                  FirstOrDefault[potentialMethods, Experiment],
                  First[mostCommonPrimitiveMethods]
                ]
              ]
          ]
        ]
      ];

      (* If we are in a Transfer primitive and ended up going with robotic, then set the inputs/options to the expanded ones. *)
      If[MatchQ[primitive, _Transfer] && MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
        {inputsFromPrimitiveOptions, optionsFromPrimitiveOptions}={inputFromPrimitiveOptionsWithRearrangedTransfers, optionsFromPrimitiveOptionsWithRearrangedTransfers};,
        (* Otherwise we need to reset the label for "transfer destination sample" in $UniqueLabelLookup *)
        If[MatchQ[transferDestinationSampleLabelCounter,0],
          KeyDropFrom[Constellation`Private`$UniqueLabelLookup,"transfer destination sample"],
          Constellation`Private`$UniqueLabelLookup["transfer destination sample"]=transferDestinationSampleLabelCounter
        ];
      ];

      (* Lookup our primitive method index. *)
      primitiveMethodIndex=Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic];

      (* Check if we are going to have a covered container for our next step. If yes, throw a warning and add Uncover UnitOperation *)
      (* This is performed after we have the resolvedPrimitiveMethod since we only need this in RSP/RCP *)
      If[
        And[
          MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
          (* If we are going to start a new group, make sure we skip this Uncover task. This is because our currentPrimitiveGroupingDateStarted has not been updated for new group - which happens at the end of the loop *)
          !MatchQ[
            (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
            {(ManualPrimitiveMethodsP)..}
          ]
        ],
        Module[
          {uncoverRequiredQ},
          (* Check on the primitive information to decide if we need the cover off. We need the cover off except for covered incubation, or an Uncover unit operation *)
          (* also for IncubateCells (where we actually _need_ it to be covered) *)
          (* The only other possible case is covered plate reading. exportReadPlateRoboticPrimitive automatically insert Uncover/Cover commands if the plate is covered but RetainCover->False. We don't have to worry about that here  *)
          uncoverRequiredQ=Or[
            MatchQ[Head[primitive],Except[Incubate|Mix|Uncover|IncubateCells]],
            And[
              MatchQ[Head[primitive], (Incubate|Mix)],
              (* We automatically resolve to Pipette mixing. Check if we specify Shake by MixType option or related options *)
              !Or[
                MatchQ[Lookup[optionsFromPrimitiveOptions,MixType,Automatic],ListableP[Shake]],
                MemberQ[Lookup[optionsFromPrimitiveOptions,#,Automatic]&/@{Time,MixRate,Temperature,ResidualIncubation,ResidualTemperature}, Except[ListableP[(Automatic|False|Null|Ambient)]]]
              ]
            ]
          ];

          If[TrueQ[uncoverRequiredQ],
            Module[{primitiveSamples,primitiveContainers,primitiveCoverDownload,platesWithCover,plateCoveredInProtocol,objectToLabelRules,plateLabelsCoveredInProtocol},
              (* Check allPrimitiveOptionsWithSimulatedObjects to get any plate that we plan to use in this primitive *)
              primitiveSamples=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]];
              primitiveContainers=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container,Plate]]];
              (* Download the cover and log information *)
              primitiveCoverDownload=Quiet[
                Download[
                  {primitiveSamples,primitiveContainers},
                  {
                    {
                      Packet[Container[{Cover, CoverLog}]],
                      Packet[Container[Cover[{Model}]]],
                      Packet[Container[Cover[Model[{CoverType}]]]]
                    },
                    {
                      Packet[Cover, CoverLog],
                      Packet[Cover[{Model}]],
                      Packet[Cover[Model[{CoverType}]]]
                    }
                  },
                  Simulation->currentSimulation,
                  Cache->cacheBall
                ],
                {Download::FieldDoesntExist,Download::NotLinkField}
              ];

              (* Only check the plates that are now covered *)
              platesWithCover=Cases[Flatten[primitiveCoverDownload,1],{KeyValuePattern[{Object->ObjectP[Object[Container, Plate]],Cover->Except[Null]}],_,_}];

              (* Make sure only worry about the containers that are covered within our primitive resolver *)
              (* The plate may be covered before the experiment but we always uncover when we load the deck. That means, the Cover from before this primitive resolver does not count here for Automatic Uncover *)
              (* Also check if the cover is a black lid. PCR may put plate seal on top and that is fine for downstream manipulations *)
              plateCoveredInProtocol=DeleteDuplicates@Map[
                If[
                  And[
                    MemberQ[
                      ToList@Lookup[#[[1]],CoverLog,{}],
                      {GreaterEqualP[currentPrimitiveGroupingDateStarted],On,_,_}
                    ],
                    MatchQ[
                      Lookup[#[[2]]/.{Null-><||>},Model,Null],
                      ObjectP[Model[Item, Lid]]
                    ],
                    MatchQ[
                      Lookup[#[[3]]/.{Null-><||>},CoverType,Null],
                      Place
                    ]
                  ],
                  Lookup[#[[1]],Object],
                  Nothing
                ]&,
                platesWithCover
              ];

              (* Convert the objects to labels so we can add Uncover UO and also give user clear message *)
              objectToLabelRules=If[!NullQ[currentSimulation],
                (ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[currentSimulation[[1]], Labels],
                {}
              ];
              plateLabelsCoveredInProtocol=plateCoveredInProtocol/.objectToLabelRules;

              If[Length[plateCoveredInProtocol]>0,
                (* we are not throwing this warning if we have an IncubateCells UO in the stack *)
                If[Not[MemberQ[coverOptimizedPrimitives, _IncubateCells]],
                  Message[Warning::UncoverUnitOperationAdded,primitive,plateLabelsCoveredInProtocol]
                ];
                coverOptimizedPrimitives=Insert[
                  coverOptimizedPrimitives,
                  Uncover[Sample->plateLabelsCoveredInProtocol,Preparation->Robotic,PrimitiveMethodIndex->primitiveMethodIndex],
                  index
                ];
                Continue[];
              ]
            ]
          ]
        ]
      ];

      (* Check if we are going to have an uncovered container for our next step. If yes and it's a unit operation that _requires_ a covered container, throw a warning and add Cover UnitOperation *)
      (* This is performed after we have the resolvedPrimitiveMethod since we only need this in RSP/RCP *)
      If[
        And[
          MatchQ[resolvedPrimitiveMethod, Except[ManualPrimitiveMethodsP]],
          (* If we are going to start a new group, make sure we skip this Cover task. This is because our currentPrimitiveGroupingDateStarted has not been updated for new group - which happens at the end of the loop *)
          !MatchQ[
            (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
            {(ManualPrimitiveMethodsP)..}
          ]
        ],
        Module[
          {coverRequiredQ},
          (* Check on the primitive information to decide if we need the cover on.  Currently we _always_ need the cover on when going to an IncubateCells primitive *)
          coverRequiredQ = MatchQ[Head[primitive], IncubateCells];

          If[TrueQ[coverRequiredQ],
            Module[{primitiveSamples,primitiveContainers,primitiveCoverDownload,platesWithoutCover,plateCoveredInProtocol,objectToLabelRules,plateLabelsWithoutCover},
              (* Check allPrimitiveOptionsWithSimulatedObjects to get any plate that we plan to use in this primitive *)
              primitiveSamples=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Sample]]];
              primitiveContainers=Cases[Flatten[Values[allPrimitiveOptionsWithSimulatedObjects]], ObjectP[Object[Container,Plate]]];
              (* Download the cover and log information *)
              primitiveCoverDownload=Quiet[
                Download[
                  {primitiveSamples,primitiveContainers},
                  {
                    {
                      Packet[Container[{Cover, CoverLog}]],
                      Packet[Container[Cover[{Model}]]],
                      Packet[Container[Cover[Model[{CoverType}]]]]
                    },
                    {
                      Packet[Cover, CoverLog],
                      Packet[Cover[{Model}]],
                      Packet[Cover[Model[{CoverType}]]]
                    }
                  },
                  Simulation->currentSimulation,
                  Cache->cacheBall
                ],
                {Download::FieldDoesntExist,Download::NotLinkField}
              ];

              (* Only check the plates that are now covered *)
              platesWithoutCover = Cases[Flatten[primitiveCoverDownload, 1], {KeyValuePattern[{Object -> ObjectP[Object[Container, Plate]], Cover -> Null}], _, _}];

              (* Convert the objects to labels so we can add Cover UO and also give user clear message *)
              objectToLabelRules=If[!NullQ[currentSimulation],
                (ObjectReferenceP[#[[2]]]|LinkP[#[[2]]]->#[[1]]&)/@Lookup[currentSimulation[[1]], Labels],
                {}
              ];
              plateLabelsWithoutCover = Lookup[platesWithoutCover[[All, 1]], Object, {}] /. objectToLabelRules;

              If[Length[plateLabelsWithoutCover] > 0,
                coverOptimizedPrimitives = Insert[
                  coverOptimizedPrimitives,
                  Cover[Sample -> plateLabelsWithoutCover, Preparation -> Robotic, PrimitiveMethodIndex -> primitiveMethodIndex],
                  index
                ];
                Continue[];
              ]
            ]
          ]
        ]
      ];

      (* Get user requested liquid handler -- this can come either from the global Instrument option or within a *)
      (* primitive grouping option. *)
      requestedInstrument=Which[
        MatchQ[Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex, <||>], Instrument, Null], ObjectP[{Model[Instrument], Object[Instrument]}]],
          Lookup[Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex], Instrument],
        MatchQ[Lookup[safeOps,Instrument], ObjectP[{Model[Instrument], Object[Instrument]}]],
          Lookup[safeOps,Instrument],
        True,
          Automatic
      ];

      (* Do we know what WorkCell we're going to use (if we're doing this via RoboticBLAH)? *)
      resolvedWorkCell=If[MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
        (* We don't use work cells for manual methods. *)
        Null,
        (* When we have more than one work cell in a primitive, we will need to resolve the work cell. *)
        If[Length[ToList[Lookup[primitiveInformation, WorkCells]]]==1,
          First[ToList[Lookup[primitiveInformation, WorkCells]]],
          Module[{workCellResolverFunction, potentialWorkCells, requestedWorkCell, allowedWorkCells},
            (* Lookup the method resolver function. *)
            workCellResolverFunction=Lookup[primitiveInformation, WorkCellResolverFunction];

            (* Pass down the inputs and options down to the work cell resolver function. *)
            potentialWorkCells=ToList@If[MatchQ[primitive, plateReaderPrimitiveP],
              workCellResolverFunction[
                Lookup[primitiveInformation, ExperimentFunction],
                Sequence@@inputsFromPrimitiveOptions,
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall
                  }
                ]
              ],
              workCellResolverFunction[
                Sequence@@inputsFromPrimitiveOptions,
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Simulation->currentSimulation,
                    Cache->cacheBall
                  }
                ]
              ]
            ];
            (* if the user picked a workcell that is not possible, create warning *)
            userWorkCellChoice=Lookup[allPrimitiveOptionsWithSimulatedObjects,WorkCell,Automatic];
            (* Convert liquid handler object to work cell shortcut symbol (e.g. bioSTAR) *)
            requestedWorkCell=Which[
              (* Nothing requested - all work cells are at least possible *)
              MatchQ[requestedInstrument,Automatic],
              Keys[Experiment`Private`$WorkCellsToInstruments],
              (* Convert requested model to work cell *)
              MatchQ[requestedInstrument,ObjectP[Model[Instrument]]],
              Lookup[$InstrumentsToWorkCells,Lookup[fetchPacketFromCache[requestedInstrument,workCellObjectPackets],Object]],
              (* Convert requested instrument to work cell *)
              MatchQ[requestedInstrument,ObjectP[Object[Instrument]]],
              Lookup[$InstrumentsToWorkCells,Lookup[fetchPacketFromCache[requestedInstrument,workCellObjectPackets],Model][Object]]
            ];

            (* Check if the specified work cell is compatible with the primitive *)
            specifiedWorkCell=If[MatchQ[userWorkCellChoice,Automatic],
              (* If Instrument option is specified, requestedWorkCell is single, matching WorkCellP. Otherwise just do Automatic *)
              If[MatchQ[requestedWorkCell,WorkCellP],
                requestedWorkCell,
                Automatic
              ],
              userWorkCellChoice
            ];

            If[Not[MemberQ[Append[potentialWorkCells,Automatic],specifiedWorkCell]],
              Message[Error::WorkCellIsIncompatible,specifiedWorkCell,primitive,potentialWorkCells];
              AppendTo[incompatibleWorkCellAndMethod,index];,

              (* don't allow using STAR if user picks RCP, or using bioSTAR/microbioSTAR if user picks RSP  *)
              Which[
                MatchQ[resolvedPrimitiveMethod, RoboticSamplePreparation] && (Not[MemberQ[potentialWorkCells, STAR]] || MatchQ[specifiedWorkCell, Alternatives[bioSTAR,microbioSTAR]]),
                  Message[Error::WorkCellIsIncompatibleWithMethod,resolvedPrimitiveMethod,primitive,Intersection[potentialWorkCells,{STAR}]];
                  AppendTo[incompatibleWorkCellAndMethod,index];,
                MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && (Not[MemberQ[potentialWorkCells, Alternatives[bioSTAR,microbioSTAR]]] || MatchQ[specifiedWorkCell, STAR]),
                  Message[Error::WorkCellIsIncompatibleWithMethod,resolvedPrimitiveMethod,primitive,Intersection[potentialWorkCells,{bioSTAR,microbioSTAR}]];
                  AppendTo[incompatibleWorkCellAndMethod,index];,
                True,
                  Nothing
              ];
            ];

            (* Figure out which work cells are actually possible given the user request and the instrument constraints *)
            allowedWorkCells = UnsortedIntersection[potentialWorkCells, ToList[requestedWorkCell], DeleteDuplicates -> True];

            (* preferences for workcells but not requirements *)
            Which[
              (* pass through user choice *)
              Not[MatchQ[userWorkCellChoice,Automatic]],
                userWorkCellChoice,
              (* if we already have a workcell chosen for our group and we can keep using it then do that *)
              And[
                MatchQ[Length[currentPrimitiveGrouping], GreaterP[0]],
                MemberQ[allowedWorkCells, Lookup[currentPrimitiveGrouping[[-1]][[1]], WorkCell]]
              ],
                Lookup[currentPrimitiveGrouping[[-1]][[1]], WorkCell],
              (* if we are in RSP, and we can use STAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticSamplePreparation] && MemberQ[allowedWorkCells, STAR],
                STAR,
              (* if we are in RCP and we have microbial samples and we can use microbioSTAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && MemberQ[potentialWorkCells, microbioSTAR] && MatchQ[microbialQ, True],
                microbioSTAR,
              (* if we are in RCP and we don't have microbial samples and we can use bioSTAR then do that *)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && MemberQ[potentialWorkCells, bioSTAR] && Not[MatchQ[microbialQ, True]],
                bioSTAR,
              (* failsafe clause: if we are in RCP, prefer either bioSTAR or microbioSTAR, or just pick the first workcell*)
              MatchQ[resolvedPrimitiveMethod, RoboticCellPreparation] && Length[Cases[potentialWorkCells,bioSTAR|microbioSTAR]]>0,
                FirstCase[potentialWorkCells, bioSTAR|microbioSTAR,First[potentialWorkCells]],
              (* If we get to here, it means STAR is not one of the potentialWorkCells but we must pick it anyway *)
              MatchQ[resolvedPrimitiveMethod,RoboticSamplePreparation],
                STAR,
              (* If we get here, it means bioSTAR or microbioSTAR are not one of the potentialWorkCells but we must pick it anyway *)
              MatchQ[resolvedPrimitiveMethod,RoboticCellPreparation],
                bioSTAR,
              MatchQ[allowedWorkCells,{__}],
              First[allowedWorkCells],
              (* ideally never reached, but this makes sure we pick any workcell *)
              True,
                First[potentialWorkCells]
            ]
          ]
        ]
      ];

      (* Check to make sure that the work cell matches WorkCellP. If not, warn the developer that something went wrong. *)
      (* resolvedWorkCell can be Null when doing the unit operation manually. *)
      If[!MatchQ[resolvedWorkCell, WorkCellP|Null],
        Message[Error::WorkCellDoesntMatchPattern, primitive];
      ];

      (* Lookup the function to call that goes with our resolved method. *)
      resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

      (* -- With the Primitive Method resolved, call our actual resolver function -- *)

      (* Get our safe options, based off of our option definitions in our primitive definition. This is because *)
      (* our primitive option definition might be different than the option definition in the resolver function if *)
      (* the resolver function is shared for multiple primitive types. *)
      safeResolverOptions=Module[{placeholderFunction},
        (* Take the option definition for the head of this primitive and set it as the option definition of our fake function. *)
        placeholderFunction /: OptionDefinition[placeholderFunction] = Lookup[primitiveInformation, OptionDefinition];

        Normal@KeyDrop[
          Association@SafeOptions[placeholderFunction, optionsFromPrimitiveOptions],
          Lookup[primitiveInformation, InputOptions]
        ]
      ];

      (* Resolve our primitive. *)
      (* NOTE: If we are dealing with a non-manual method, we must also ask for the resources that we will need *)
      (* to execute the primitive. This will be used for workcell grouping and we also will need to place the resources on *)
      (* deck in order to generate the JSON to perform the workcell protocol. *)

      (* Keep track of if we used the cache for this primitive. This signals that we need to add unitOperationObjects *)
      (* to outputUnitOperationObjectsFromCache. *)
      usedResolverCacheQ=False;

      (* Define a bool that will be used to detect if any message was thrown when delayedMessages -> False *)
      delayedMessagesFalseMessagesBool = False;

      (* Get the resolver output and the messages thrown. *)
      (* NOTE: messagesThrown is in the format {<|MessageName->Hold[messageName], MessageArguments->_List|>}. *)
      {
        resolvedOptions,
        newSimulation,
        resolverTests,
        unitOperationPacketsRaw,
        runTimeEstimate,
        messagesThrown
      }=Module[{myMessageList, messageHandler},
        myMessageList = {};

        messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
          (* Keep track of the messages thrown during evaluation of the test. *)
          AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
        ];

        SafeAddHandler[{"MessageTextFilter", messageHandler},
          Module[
            {options, simulation, tests, result, timeEstimate, errorMessagesThrownQ,
              resolverPlateReaderRule, simulationHash, userReaderRequest},

            (* Helper function to see if myMessageList contains an Error. *)
            errorMessagesThrownQ[]:=MemberQ[myMessageList, KeyValuePattern[{MessageName->Hold[Verbatim[MessageName][Except[Warning],_]]}]];

            (* Translate between our primitive method wrappers and preparation option. *)
            preparation=resolvedPrimitiveMethod/.{
              ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
              RoboticSamplePreparation|RoboticCellPreparation->Robotic
            };

            (* Initialize our variables. *)
            (* NOTE: Result will be an non-RequireResource'd Object[UnitOperation] in the case that the unit operation *)
            (* is being run via a non-manual method. *)
            options={};
            simulation=Null;
            tests={};
            result={};
            timeEstimate=Null;

            (* Get the hash of our simulation. We drop SimulatedObjects because previously non-uploaded unit operations *)
            (* can be seen as simulated by the Simulation, but once uploaded are now non-simulated, causing the simulation *)
            (* to be different on the second run through, causing the cache to not be triggered. *)
            (* NOTE: We can probably make the hashing function smarter in the future. *)
            simulationHash=Hash[KeyDrop[currentSimulation[[1]], SimulatedObjects]];

            (* Check if the user asked for a given instrument - if so we can't intervene and we should get an error later when finalizing liquid handler *)
            userReaderRequest=Lookup[safeResolverOptions,Instrument];

            (* If a specific Hamilton was requested, we need to make sure we use the instruments integrated with this model *)
            (* Currently this only applies for plate reader experiments which have different plate reader models associated with different Hamilton models *)
            resolverPlateReaderRule=If[MatchQ[primitive,plateReaderPrimitiveP] && MatchQ[requestedInstrument,ObjectP[]] && MatchQ[userReaderRequest,Automatic],
              Module[{requestedModel,integratedInstruments,plateReader,nephReader,readerToRequest},

                (* Grab the requested liquid handler *)
                requestedModel=If[MatchQ[requestedInstrument,ObjectP[Model[Instrument]]],
                  requestedInstrument,
                  Lookup[fetchPacketFromCache[requestedInstrument,workCellObjectPackets],Model][Object]
                ];

                (* Grab the instruments connected to this liquid handler *)
                integratedInstruments=Lookup[fetchPacketFromCache[requestedModel,Join[workCellObjectPackets,workCellModelPackets]],IntegratedInstruments];

                (* Get the models of interest - right now we only have one plate reader/neph. If this changed we could run into trouble here *)
                plateReader=FirstCase[integratedInstruments,ObjectP[Model[Instrument,PlateReader]]];
                nephReader=FirstCase[integratedInstruments,ObjectP[Model[Instrument, Nephelometer]]];

                (* Request the neph, or the plate reader for our PlateReader unit op *)
                readerToRequest=If[MatchQ[primitive, _Nephelometry|_NephelometryKinetics],
                  nephReader,
                  plateReader
                ];

                (* Prepare the option to send down to the plate reader experiment resolver *)
                Instrument->readerToRequest
              ],
              Nothing
            ];

            (* Evaluate the resolver function. Turn off message printing while doing so (we'll throw messages later). *)
            (* NOTE: Preparation is not an option if the experiment function can only be performed manually. *)
            (* NOTE: Do NOT send down the Cache->cacheBall option to the experiment function since the cache ball can contain *)
            (* historic packets that are not up to date with the simulation now. We expect the values of objects to change *)
            (* frequently since we're simulating changes in the lab. *)
            Block[{$Messages},
              Module[{},
                Which[
                  (* If we have a LabelSample primitive, we ALWAYS ask for the Object[UnitOperation] and send down a full *)
                  (* primitive list so that it can resolve the Volume key. *)
                  MatchQ[primitive, _LabelSample|_LabelContainer],
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence @@ inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation -> currentSimulation,
                              Output -> {Options, Simulation, If[gatherTests, Tests, Nothing], Result},
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ],

                              (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                              If[MatchQ[primitive, _LabelSample],
                                Primitives -> primitivesWithPreresolvedInputs,
                                Nothing
                              ],

                              (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                              If[MatchQ[primitive, _LabelSample],
                                ParentProtocol -> parentProtocol,
                                Nothing
                              ]
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Tests, Result},
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],

                            (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                            If[MatchQ[primitive, _LabelSample],
                              Primitives->primitivesWithPreresolvedInputs,
                              Nothing
                            ],

                            (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                            If[MatchQ[primitive, _LabelSample],
                              ParentProtocol->parentProtocol,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,result,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,result}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,result,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Result},
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],

                            (* NOTE: Option to send down the full primitive list for LabelSample but not LabelContainer. *)
                            If[MatchQ[primitive, _LabelSample],
                              Primitives->primitivesWithPreresolvedInputs,
                              Nothing
                            ],

                            (* NOTE: Option to send down the parent protocol so we can perform the volume check correctly. *)
                            If[MatchQ[primitive, _LabelSample],
                              ParentProtocol->parentProtocol,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,result,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,result}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,result,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ],

                  (* If we're using a work cell, we ALWAYS ask for Object[UnitOperation] and on deck containers. *)
                  !MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence@@inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation->currentSimulation,
                              Output->{Options, Simulation, If[gatherTests, Tests, Nothing], Result, RunTime},
                              (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                              If[MatchQ[primitive,_Cover|_Uncover],
                                FastTrack->True,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                                WorkCell->resolvedWorkCell,
                                Nothing
                              ],
                              Upload->False
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Tests, Result, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                              WorkCell->resolvedWorkCell,
                              Nothing
                            ],
                            resolverPlateReaderRule,
                            Upload->False
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,result,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            Output->{Options, Simulation, Result, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                              WorkCell->resolvedWorkCell,
                              Nothing
                            ],
                            resolverPlateReaderRule,
                            Upload->False
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,result,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,result,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ],

                  (* OTHERWISE, we have a manual primitive and we don't care about the resource packets, on deck containers, *)
                  (* or runtime etc. *)
                  True,
                  Module[{},
                    (* Print debug statement if asked. *)
                    If[MatchQ[debug, True],
                      Echo[
                        {
                          DateObject[],
                          Sequence@@inputsFromPrimitiveOptions,
                          ReplaceRule[
                            safeResolverOptions,
                            {
                              Simulation->currentSimulation,
                              ParentProtocol->parentProtocol,
                              Output->{Options, Simulation, If[gatherTests, Tests, Nothing]},
                              (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                              If[MatchQ[primitive,_Cover|_Uncover],
                                FastTrack->True,
                                Nothing
                              ],
                              If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                                Preparation->preparation,
                                Nothing
                              ]
                            }
                          ]
                        },
                        resolverFunction
                      ];
                    ];

                    If[MatchQ[gatherTests, True],
                      Module[{fullResolverOptions},
                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            ParentProtocol->parentProtocol,
                            Output->{Options, Simulation, Tests,RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,tests,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,tests,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,tests,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ],
                      Module[{imageSample,measureVolume,measureWeight,
                        primitiveImageSample,primitiveMeasureVolume,primitiveMeasureWeight,
                        resolvedImageSample,resolvedMeasureVolume,resolvedMeasureWeight,fullResolverOptions},

                        (* Get the post-processing option values from the sample preparation function or Automatic if
                        they don't have post-processing options (like ExperimentManualCellPreparation) *)
                        imageSample=Lookup[safeOps,ImageSample,Automatic];
                        measureVolume=Lookup[safeOps,MeasureVolume,Automatic];
                        measureWeight=Lookup[safeOps,MeasureWeight,Automatic];

                        (* Get the post-processing option values from this primitive *)
                        primitiveImageSample=Lookup[safeResolverOptions,ImageSample];
                        primitiveMeasureVolume=Lookup[safeResolverOptions,MeasureVolume];
                        primitiveMeasureWeight=Lookup[safeResolverOptions,MeasureWeight];

                        (* If preparation is Manual and the primitive doesn't have a post-processing option specified,
                        then use the value resolved for the MSP, otherwise don't change the value *)
                        resolvedImageSample=Switch[{primitiveImageSample,preparation},
                          {Automatic,Manual},ImageSample->imageSample,
                          {_,_},Nothing
                        ];
                        resolvedMeasureVolume=Switch[{primitiveMeasureVolume,preparation},
                          {Automatic,Manual},MeasureVolume->measureVolume,
                          {_,_},Nothing
                        ];
                        resolvedMeasureWeight=Switch[{primitiveMeasureWeight,preparation},
                          {Automatic,Manual},MeasureWeight->measureWeight,
                          {_,_},Nothing
                        ];

                        fullResolverOptions=ReplaceRule[
                          safeResolverOptions,
                          {
                            Simulation->currentSimulation,
                            ParentProtocol->parentProtocol,
                            Output->{Options, Simulation, RunTime},
                            (* NOTE: FastTrack->True prevents Error::ContainerIsAlreadyCovered and Error::NoActiveCartForCover since we don't simulate cover state or the cover environment on active cart. *)
                            If[MatchQ[primitive,_Cover|_Uncover],
                              FastTrack->True,
                              Nothing
                            ],
                            If[MemberQ[Options[resolverFunction][[All,1]], "Preparation"],
                              Preparation->preparation,
                              Nothing
                            ],
                            resolvedImageSample,
                            resolvedMeasureVolume,
                            resolvedMeasureWeight,
                            resolverPlateReaderRule
                          }
                        ];

                        If[KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          usedResolverCacheQ=True;
                          {options,simulation,timeEstimate,myMessageList,Constellation`Private`$UniqueLabelLookup}=Lookup[$PrimitiveFrameworkResolverOutputCache, Key[{resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}]],
                          {options,simulation,timeEstimate}=resolverFunction[
                            Sequence@@inputsFromPrimitiveOptions,
                            fullResolverOptions
                          ]
                        ];

                        If[And[
                          !KeyExistsQ[$PrimitiveFrameworkResolverOutputCache, {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}],
                          !errorMessagesThrownQ[]
                        ],
                          AppendTo[
                            $PrimitiveFrameworkResolverOutputCache,
                            {resolverFunction, inputsFromPrimitiveOptions, KeyDrop[fullResolverOptions, {Cache, Simulation}], simulationHash}->{options,simulation,myMessageList,Constellation`Private`$UniqueLabelLookup}
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ];

            (* Return our information. *)
            {
              options,
              simulation,
              tests,
              result,
              timeEstimate,
              myMessageList
            }
          ]
        ]
      ];

      (* NOTE: We have to do this because of some weirdness with weird RoundOptionsPrecision warnings that get detected *)
      savedDelayedMessagesFalseMessagesBool = delayedMessagesFalseMessagesBool;

      (* These three errors are all hard framework errors that make it such that the experiment function doesn't continue. *)
      (* If one of these happen, we have to handle it to fail gracefully. *)
      emptyContainerFailureQ=MatchQ[unitOperationPacketsRaw, $Failed] && (MemberQ[messagesThrown, <|MessageName -> Hold[Error::EmptyContainers], _|>] || MatchQ[resolvedOptions, $Failed]);
      emptyWellFailureQ=MatchQ[unitOperationPacketsRaw, $Failed] && (MemberQ[messagesThrown, <|MessageName -> Hold[Error::ContainerEmptyWells], _|>] || MatchQ[resolvedOptions, $Failed]);
      nonExistedWellFailureQ=MatchQ[unitOperationPacketsRaw, $Failed] && (MemberQ[messagesThrown, <|MessageName -> Hold[Error::WellDoesNotExist], _|>] || MatchQ[resolvedOptions, $Failed]);
      (* NOTE: Here, since if delayedMessages -> False, we don't know what errors have been thrown, assume the worst *)
      hardResolverFailureQ = emptyContainerFailureQ || emptyWellFailureQ || nonExistedWellFailureQ || savedDelayedMessagesFalseMessagesBool;

      (* If the simulation that we get back doesn't match SimulationP, set it to an empty simulation. This is due to *)
      (* some weird Command Center bugs that have arisen. *)
      newSimulation=If[!MatchQ[newSimulation, SimulationP],
        Simulation[],
        newSimulation
      ];

      (* If unitOperationPacketsRaw is a single packet, ToList it. *)
      (* This is because we can get back a list of multiple unit operation packets from the resource packets function *)
      (* since you can have sub UnitOperations inside of your UnitOperation (ex. Transfer inside of Filter). *)
      (* NOTE: The last case is to stop trainwrecking in case we get back $Failed. *)
      (* NOTE: We need to separate the BatchedUnitOperations from the other types of unit operations, do this by the UnitOperationType field *)
      (* We only do this for the qpix unit operations *)
      {unitOperationPacketsMinusOptions, batchedUnitOperationPackets}=Which[
        MatchQ[unitOperationPacketsRaw, Alternatives[{PacketP[]..}, PacketP[]]],
        {
          Cases[ToList[unitOperationPacketsRaw], Alternatives[
            KeyValuePattern[UnitOperationType -> Input | Output | Calculated | Optimized],
            KeyValuePattern[
              {UnitOperationType -> Batched,
                Type -> Except[TypeP[
                  {
                    Object[UnitOperation,PickColonies],
                    Object[UnitOperation,InoculateLiquidMedia],
                    Object[UnitOperation,SpreadCells],
                    Object[UnitOperation,StreakCells]
                  }
                ]]
              }
            ]
          ]],
          Cases[ToList[unitOperationPacketsRaw], KeyValuePattern[
            {UnitOperationType -> Batched,
              Type -> TypeP[
                {
                  Object[UnitOperation,PickColonies],
                  Object[UnitOperation,InoculateLiquidMedia],
                  Object[UnitOperation,SpreadCells],
                  Object[UnitOperation,StreakCells]
                }
              ]
            }
          ]]
        },
        True,
          {{},{}}
      ];

      (* add the resolved options and unresolved options to the first unit operation packet (i.e., the one that goes into the top level OutputUnitOperations field) *)
      (* note that this ALWAYS ASSUMES the first packet here is the one that goes into OutputUnitOperations and the rest are accessory packets (either that they are RoboticUnitOperations, or the qpix BatchedUnitOperations, or something else) *)
      unitOperationPackets = If[MatchQ[unitOperationPacketsMinusOptions, {PacketP[]..}],
        Flatten[{
          Join[
            First[unitOperationPacketsMinusOptions],
            <|
              UnresolvedUnitOperationOptions -> Normal[KeyDrop[safeResolverOptions, {Simulation, Cache}], Association],
              ResolvedUnitOperationOptions -> Normal[KeyDrop[resolvedOptions, {Simulation, Cache}], Association]
            |>
          ],
          Rest[unitOperationPacketsMinusOptions]
        }],
        {}
      ];

      (* If we used the cache, then add our unit operation objects to outputUnitOperationObjectsFromCache. *)
      If[MatchQ[usedResolverCacheQ, True] && Length[unitOperationPackets]>0,
        outputUnitOperationObjectsFromCache=Join[outputUnitOperationObjectsFromCache, Lookup[unitOperationPackets, Object]];
      ];

      (* Print debug statement if asked. *)
      If[MatchQ[debug, True],
        Echo[
          {DateObject[],Normal@KeyDrop[resolvedOptions, Cache], newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown},
          "{resolvedOptions, newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown}"
        ]
      ];

      (* if we have not returned the legal RunTime, throw a warning (not on prod! and not for non-developer) *)
      If[
        And[
          MatchQ[ProductionQ[],Except[True]],
          MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
          MatchQ[preparation,Robotic],
          MatchQ[runTimeEstimate,Except[TimeP]],
          (* we explicitly exclude LabelContainer/LabelSample primitives from this check since they are not capable of returning RunTime*)
          !MatchQ[resolverFunction, Experiment`Private`resolveLabelContainerPrimitive | Experiment`Private`resolveLabelSamplePrimitive]
        ],
        (
          MapThread[
            ManifoldEcho[#1, #2]&,
            {
              {resolverFunction, inputsFromPrimitiveOptions, safeResolverOptions, If[MatchQ[resolvedOptions, Except[$Failed]], Normal@KeyDrop[resolvedOptions, Cache], resolvedOptions], newSimulation, resolverTests, unitOperationPackets, runTimeEstimate, messagesThrown},
              {"resolverFunction", "inputsFromPrimitiveOptions", "safeResolverOptions", "resolvedOptions", "newSimulation", "resolverTests", "unitOperationPackets", "runTimeEstimate", "messagesThrown"}
            }
          ];
          Message[Warning::NoRunTime, index, resolverFunction]
        )
      ];

      (* If we got back invalid inputs or invalid options, add this primitive to our list of invalid inputs. *)
      resolverErrorQ = Which[
        (* NOTE: We would normally do the Check[...] to get this, but due to the non-standard way we're capturing *)
        (* messages, we have to do this instead. *)
        (* NOTE: Once again if DelayedMessages -> False, if any message was thrown, assume the worst *)
        MemberQ[messagesThrown || savedDelayedMessagesFalseMessagesBool, KeyValuePattern[{MessageName->(Hold[Error::InvalidOption]|Hold[Error::InvalidInput])}]],
          True,
        hardResolverFailureQ,
          True,
        gatherTests,
          Not[RunUnitTest[<|"Tests" -> resolverTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
        True,
          False
      ];

      If[MatchQ[resolverErrorQ, True],
        AppendTo[invalidResolverPrimitives, index];
      ];

      (* Append any tests we got back to our global resolver tests list. *)
      allResolverTests=AppendTo[allResolverTests, resolverTests];

      (* See what new label fields we have. Keep track of the primitive index that we got these new label fields. *)
      newLabelFieldKeys=Complement[
        Join[Lookup[newSimulation[[1]], LabelFields][[All,1]], Lookup[newSimulation[[1]], Labels][[All,1]]],
        Lookup[currentSimulation[[1]], LabelFields][[All,1]]
      ];

      (* Add all new Labels to the LabelField key in the simulation. *)
      newLabelFields=Join[
        Cases[Lookup[newSimulation[[1]], LabelFields], Verbatim[Rule][Alternatives@@newLabelFieldKeys,_]],
        (#->#&)/@Intersection[Complement[Lookup[newSimulation[[1]], Labels][[All,1]], Lookup[newSimulation[[1]], LabelFields][[All,1]]], newLabelFieldKeys]
      ];

      (* Did we get back new labels that point to a different object? *)
      intersectionLabels=Intersection[Lookup[newSimulation[[1]],Labels][[All,1]],Lookup[currentSimulation[[1]],Labels][[All,1]]];
      overwrittenLabels=If[
        !MatchQ[Download[Lookup[Lookup[newSimulation[[1]],Labels],#],Object],Download[Lookup[Lookup[currentSimulation[[1]],Labels],#],Object]],
          #,
          Nothing
        ]&/@intersectionLabels;

      (* If we have labels that are trying to overwrite old labels, don't let that happen. *)
      (* NOTE: Also have to put the unit operation packets into the simulation since we will try to download from them and *)
      (* they will not yet be uploaded. *)
      newSimulationWithoutOverwrittenLabels=If[Length[overwrittenLabels]>0,
        AppendTo[allOverwrittenLabelsWithIndices, {overwrittenLabels, index, primitive}];

        Simulation[
          Packets->Lookup[newSimulation[[1]], Packets],
          Labels->Cases[Lookup[newSimulation[[1]], Labels], Verbatim[Rule][Except[Alternatives@@overwrittenLabels],_]],
          LabelFields->Cases[newLabelFields, Verbatim[Rule][Except[Alternatives@@overwrittenLabels],_]],
          Updated->False,
          SimulatedObjects->Lookup[newSimulation[[1]], SimulatedObjects]
        ],
        Simulation[
          Packets->Lookup[newSimulation[[1]], Packets],
          Labels->Lookup[newSimulation[[1]], Labels],
          LabelFields->newLabelFields,
          SimulatedObjects->Lookup[newSimulation[[1]], SimulatedObjects]
        ]
      ];

      (* For each message that was thrown, overwrite the message text to have the primitive index at the beginning of *)
      (* the message. *)
      (* NOTE: We have to wait until this point in the code to throw the errors because we need the updated simulation *)
      (* in order to map simulated samples to their labels since the simulated sample IDs should be hidden from the user. *)
      Map[
        throwMessageWithPrimitiveIndex[#, index, Head[primitive], newSimulationWithoutOverwrittenLabels]&,
        messagesThrown
      ];

      (* Store our previous simulation temporarily since we may need it in our FRQ call. This is because we want to *)
      (* look at resource availability BEFORE the experiment has been run. *)
      previousSimulation=currentSimulation;

      (* Update our current simulation with the simulation that we got back from our primitive. *)
      currentSimulation=UpdateSimulation[currentSimulation, newSimulationWithoutOverwrittenLabels];

      (* Filter out any options that aren't in our option definition. *)
      resolvedOptionsWithPrimitiveOptionsOnly=(If[!MemberQ[Lookup[primitiveOptionDefinitions, "OptionSymbol"], #[[1]]], Nothing, #]&)/@resolvedOptions;

      (* -- Insert our Resolved Options back into Primitive form to return them -- *)

      (* Create a map to convert any simulated objects back to their labels. *)
      simulatedObjectsToLabel=Module[{allObjectsInSimulation, simulatedQ},
        (* Get all objects out of our simulation. *)
        allObjectsInSimulation=Download[Lookup[currentSimulation[[1]], Labels][[All,2]], Object];

        (* Figure out which objects are simulated. *)
        simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

        (Reverse/@PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ])/.{link_Link:>Download[link,Object]}
      ];

      (* Make sure that we're not returning simulated objects. *)
      resolvedOptionsWithNoSimulatedObjects=resolvedOptionsWithPrimitiveOptionsOnly/.simulatedObjectsToLabel;
      inputsWithNoSimulatedObjects=inputsFromPrimitiveOptions/.simulatedObjectsToLabel;
      optionsWithNoSimulatedObjects=optionsFromPrimitiveOptions/.simulatedObjectsToLabel;

      (* Put our resolved options (and inputs, which don't need to be resolved, back into primitive format. *)
      resolvedPrimitive=If[hardResolverFailureQ,
        primitive,
        Head[primitive][Association@Join[
          (* Make sure to convert all containers to samples since the functions will do this internally and we need the *)
          (* index matching to work out. *)
          (* NOTE: ExperimentTransfer/Cover/Uncover leaves containers alone so do not do this for those experiments. *)
          If[MatchQ[Head[primitive], Transfer|Cover|Uncover],
            Rule@@@Transpose[{Lookup[primitiveInformation, InputOptions], inputsFromPrimitiveOptions}],
            Module[{inputOptionsWithContainers,currentContainerPackets,containerToAllSampleLookup,allcontainerToSamples,positionToSampleLookup,allpositionsToSamples},
              inputOptionsWithContainers=(
                #->Lookup[allPrimitiveOptionsWithSimulatedObjects, #, Null]
                    &)/@Lookup[primitiveInformation, InputOptions];


              currentContainerPackets=Download[
                DeleteDuplicates[Cases[inputsFromPrimitiveOptions, ObjectP[Object[Container]], Infinity]],
                Packet[Contents],
                Simulation->previousSimulation
              ];

              (* Build a look up to transfer container to all the sample inside that container *)
              containerToAllSampleLookup=(Lookup[#, Object] -> Sequence@@Download[Lookup[#, Contents][[All,2]], Object]&)/@currentContainerPackets;

              positionToSampleLookup=Flatten[Module[{object,allSamples,allPositions},

                object=Lookup[#, Object];
                allSamples=Download[Lookup[#, Contents][[All,2]], Object];
                allPositions=Lookup[#, Contents][[All,1]];

                MapThread[({#1,object}->#2)&,{allPositions,allSamples}]

              ]&/@currentContainerPackets,1];

              (* Replace simulated objects with their labels. *)
              allpositionsToSamples=inputOptionsWithContainers/.positionToSampleLookup;


              allcontainerToSamples=allpositionsToSamples/.containerToAllSampleLookup;

              (
                (* Replace simulated (and real) containers with simulated (and real) samples. *)
                allcontainerToSamples
              )/.Reverse/@Lookup[previousSimulation[[1]], Labels]
            ]
          ],
          (* Add our primitive options based on the resolved information we got back. *)
          (* Remove any simulated objects and replace them with labels. *)
          resolvedOptionsWithNoSimulatedObjects,

          (* These aren't really options to the primitive, so make sure to add them back. *)
          (* NOTE: We don't use the "safe" primitive method here, we use the original one given by the user as to not change *)
          (* the command builder view. *)
          {
            PrimitiveMethod->resolvedPrimitiveMethod,
            PrimitiveMethodIndex->primitiveMethodIndex,
            WorkCell->resolvedWorkCell,
            (* add the resolved options and unresolved options to the first unit operation packet (i.e., the one that goes into the top level OutputUnitOperations field) *)
            (* need to do this here in addition to what we did before because if dealing with a unit operation that doesn't return unit operation packets then we need a different way to make it into the unit operation object *)
            UnresolvedUnitOperationOptions -> Normal[KeyDrop[safeResolverOptions, {Simulation, Cache}], Association],
            ResolvedUnitOperationOptions -> Normal[KeyDrop[resolvedOptionsWithNoSimulatedObjects, {Simulation, Cache}], Association]
          }
        ]]
      ];

      (* We're about to return. Remove our temporary print cell. *)
      If[MatchQ[$ECLApplication, CommandCenter|Mathematica],
        NotebookDelete[primitiveResolvingMessageCell]
      ];

      (* -- Figure out our Primitive Method Groupings -- *)
      Which[
        (* We never have to worry about deck capacity for manual primitives. Therefore, we do NOT *)
        (* do the resource deck checking that we do for work cell primitives. *)
        MatchQ[resolvedPrimitiveMethod, ManualPrimitiveMethodsP],
          Module[{},
            (* Do we have an existing group of the same method (or non-initialized group)? If so, we can safely append. *)
            (* Otherwise, we first have to clear it, then append. *)
            If[Or[
                (* If the user didn't specify that we should use a new primitive grouping, we're allowed to add it to *)
                (* the previous one. *)
                !Or[
                  MatchQ[
                    Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic],
                    Automatic
                  ],
                  MatchQ[
                    (Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&)/@currentPrimitiveGrouping,
                    (* NOTE: PrimitiveMethodIndex is going to exist in the non-resolved primitive as well. *)
                    {(Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic]|Automatic)...}
                  ]
                ],
                !MatchQ[
                  (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
                  {resolvedPrimitiveMethod...}
                ]
              ],
              startNewPrimitiveGrouping[];
            ];

            (* Fill out our new grouping with our primitive information. *)
            AppendTo[currentPrimitiveGrouping, resolvedPrimitive];
            AppendTo[currentUnresolvedPrimitiveGrouping, Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]];
            AppendTo[currentPrimitiveInputGrouping, inputsWithNoSimulatedObjects];
            AppendTo[currentPrimitiveOptionGrouping, resolvedOptionsWithNoSimulatedObjects];
            AppendTo[currentPrimitiveGroupingUnitOperationPackets, unitOperationPackets];
            AppendTo[currentPrimitiveGroupingBatchedUnitOperationPackets, batchedUnitOperationPackets];
            currentLabelFieldsWithIndices=Join[
              currentLabelFieldsWithIndices,
              (#[[1]]->LabelField[#[[2]], index]&)/@newLabelFields
            ];

            (* 1) Call FRQ if we have required resource (this is the case for LabelContainer and LabelSample). *)
            (* For other manual primitives, FRQ is called in the resource packets function by the experiment function. *)

            (* 2) Add the resources created by LabelContainer/LabelSample to currentPrimitiveGroupingLabeledObjects so *)
            (* that they will be included in the protocol-level LabeledObjects. *)

            (* 3) We do NOT keep track of UnitOperation packets, even though we have them, for Preparation->Manual and *)
            (* instead rely on OutputUnitOperationParserFunction to resolve the Sample key in the Object[UnitOperation] *)
            (* to be consistent with all other manual unit operations. *)
            If[MatchQ[unitOperationPackets, {PacketP[]..}],
              Module[{labeledObjectsLookup, allResourceBlobs, nonSimulatedResourceBlobs, newFrqTests, newFulfillableQ,
                objectResources, newNonObjectResources},
                (* Lookup the LabeledObjects field from our packet. *)
                labeledObjectsLookup=Rule@@@((Sequence@@Lookup[#, Replace[LabeledObjects], {}]&)/@unitOperationPackets);

                (* NOTE: We are adding resources here because we can still have a LabelSample/LabelContainer primitive *)
                (* in a manual group. *)
                currentPrimitiveGroupingLabeledObjects=Join[currentPrimitiveGroupingLabeledObjects, labeledObjectsLookup];

                (* Get all of the resources in our unit operation packet. *)
                allResourceBlobs=DeleteDuplicates[Cases[Normal/@unitOperationPackets,_Resource,Infinity]];

                (* Exclude simulated resources using the current simulation here. FRQ usually does this for us, but *)
                (* we are passing down a previous simulation which may not have newly simulated objects in it. *)
                nonSimulatedResourceBlobs=Module[{objectsInResourceBlobs,simulatedObjects},
                  (* Get all of the objects from the resource blobs. *)
                  objectsInResourceBlobs=DeleteDuplicates[Cases[allResourceBlobs, ObjectReferenceP[], Infinity]];

                  (* Figure out which objects are simulated. *)
                  (* note that although elsewhere in this code we don't want to count things in $CurrentSimulation as "simulated", here we do because FRQ will not work nicely with any simulated objects, $CurrentSimulation or not *)
                  simulatedObjects=If[MatchQ[$CurrentSimulation, SimulationP],
                    Intersection[Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]], objectsInResourceBlobs],
                    Intersection[Lookup[currentSimulation[[1]], SimulatedObjects], objectsInResourceBlobs]
                  ];

                  (* Only check if non-simulated objects are fulfillable. *)
                  (
                    If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
                      Nothing,
                      #
                    ]
                  &)/@allResourceBlobs
                ];

                (* split up the resources that have Sample set to an Object vs all the rest of them *)
                (* doing this because we must call FRQ on the objects at the proper time between unit operations, but for performance sake, would like to save all the models (which are considerably slower) to the end of the SP call *)
                objectResources = Select[nonSimulatedResourceBlobs, MatchQ[#[Sample], ObjectP[Object]]&];
                newNonObjectResources = DeleteCases[nonSimulatedResourceBlobs, Alternatives @@ objectResources];

                (* call fulfillableResourceQ on all the resources we created *)
                (* NOTE: we want to look at resource availability BEFORE the experiment has been run. *)
                (* if UnitOperationPackets -> True, then we are not calling frq right now because it will get called by whatever was asking for the UnitOperationPackets *)
                {newFulfillableQ, newFrqTests} = Which[
                  MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {True, {}},
                  gatherTests, Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation, Output -> {Result, Tests}],
                  True, {Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation], {}}
                ];

                (* Append our new non-Object Resources *)
                AppendTo[nonObjectResources, newNonObjectResources];

                (* Append our new FRQ tests. *)
                AppendTo[frqTests, newFrqTests];

                (* If we aren't fulfillable, keep track of that globally. *)
                If[MatchQ[newFulfillableQ, False],
                  fulfillableQ=False;
                ];
              ]
            ];
          ],

        (* Otherwise, we must have a work cell primitive. Do the resource checks that relate to 1) footprint, 2) tips, *)
        (* and 3) integrated instruments. *)
        True,
          Module[
            {sampleAndContainerResourceBlobs, updatedSampleAndContainerResourceBlobs,sampleAndContainerResourceBlobToIncubationTimeLookup, instrumentResourceObjects, instrumentResourceModels,
              sampleObjects, nonSampleObjects, resourceCache, newFootprintResult, currentFootprintResult, currentFootprintResultNoDuplicates,
              allFootprintResult, newFootprintTally, currentPrimitiveGroupingResourceBlobs, currentPrimitiveGroupingMagnetizationRackResourceBlobs,
              currentUOResourceBlobs, currentUOMagnetizationRackResourceBlobs, singlePrimitiveFootprintTally, allTipResources,
              flattenedStackedTipTuples, singlePrimitiveFlattenedStackedTipTuples, flattenedNonStackedTipTuples, singlePrimitiveFlattenedNonStackedTipTuples,
              filteredInstruments, newLabeledObjectsLookup,startingIncubatorContainers, singlePrimitiveStartingIncubatorContainers,
              startingAmbientContainers, singlePrimitiveStartingAmbientContainers,
              instrumentResourceBlobs, tipResourceBlobs, objectContainersFromResourcesExistQ, objectContainerPacketsFromResource,
              incubatorPlateResources, ambientPlateResources, newPlateFootprintResult, labeledObjectsLookup, allResourceBlobs,
              samplesAndContainerObjects, newFootprintResultNoDuplicates, workCellIdlingConditions, objectsToDownloadFrom,
              fieldsToDownloadFrom, allInstrumentResourceModels, highPrecisionPositionContainersBools, singlePrimitiveHighPrecisionPositionContainersBools,
              currentPrimitiveGroupingIntegratedInstruments, tipAdapterUsedQ},

            (* Setup a new grouping if our current grouping isn't the same work cell type. *)
            If[Or[
                (* If the user told us that we should use a different method index, we're forced to split. *)
                !MatchQ[
                  (Lookup[#[[1]], PrimitiveMethodIndex, Automatic]&)/@currentPrimitiveGrouping,
                  (* NOTE: PrimitiveMethodIndex is going to exist in the non-resolved primitive as well. *)
                  {(Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic]|Automatic)...}
                ],
                (* If the user told us that we have to use a new primitive method. *)
                !MatchQ[
                  (Lookup[#[[1]], PrimitiveMethod]&)/@currentPrimitiveGrouping,
                  {(Lookup[resolvedPrimitive[[1]], PrimitiveMethod])...}
                ],
                (* Or if they left the primitive method index to be Automatic and... *)
                And[
                  MatchQ[
                    Lookup[primitive[[1]], PrimitiveMethodIndex, Automatic],
                    Automatic
                  ],
                  Or[
                    (* The user told us to use a different work cell. *)
                    !MatchQ[
                      (Lookup[#[[1]], WorkCell]&)/@currentPrimitiveGrouping,
                      {(Lookup[resolvedPrimitive[[1]], WorkCell])...}
                    ],
                    (* Or we have more than $MaxPlateReaderInjectionSamples injection sample resources, we can't fit them in a single group. *)
                    Module[{injectionResourceGroups},
                      (* NOTE: We don't have to check for the number of injection resource groups here because that is covered *)
                      (* by the plate reader instrument resources. *)
                      injectionResourceGroups=computeInjectionSampleResourceGroups[currentPrimitiveGrouping];

                      MemberQ[
                        (MatchQ[Length[#], GreaterP[$MaxPlateReaderInjectionSamples]]&)/@injectionResourceGroups[[All,2]],
                        True
                      ]
                    ],
                    (* If our injection samples show up elsewhere, we have to start a new group since we can't put injection samples *)
                    (* inside of the plate reader and on deck. *)
                    MatchQ[
                      Length[computeInvalidInjectionSampleResources[currentPrimitiveGrouping, currentPrimitiveGroupingUnitOperationPackets]],
                      GreaterP[0]
                    ]
                  ]
                ]
              ],
              startNewPrimitiveGrouping[];
            ];

            (* Lookup the LabeledObjects field from our packet. *)
            labeledObjectsLookup=ReplaceAll[
              Rule@@@((Sequence@@Lookup[#, Replace[LabeledObjects], {}]&)/@unitOperationPackets),
              {$Failed->{}}
            ]/.{link:Verbatim[Link][Resource[___]]:>First[link]};

            (* Get all of the resources in our unit operation packet. *)
            allResourceBlobs=DeleteDuplicates[Cases[Normal/@unitOperationPackets,_Resource,Infinity]];

            (* check we are using tip adapter in our unit operations *)
            tipAdapterUsedQ = MatchQ[
              FirstCase[allResourceBlobs, Resource[KeyValuePattern[Sample->Model[Item, "id:Y0lXejMp6aRV"]]],{}],
              _Resource];

            (* Call FRQ on our new resources. *)
            Module[{nonSimulatedResourceBlobs, newFrqTests, newFulfillableQ, objectResources, newNonObjectResources},
              (* Exclude simulated resources using the current simulation here. FRQ usually does this for us, but *)
              (* we are passing down a previous simulation which may not have newly simulated objects in it. *)
              nonSimulatedResourceBlobs=Module[{objectsInResourceBlobs,simulatedObjects},
                (* Get all of the objects from the resource blobs. *)
                objectsInResourceBlobs=DeleteDuplicates[Cases[allResourceBlobs, ObjectReferenceP[], Infinity]];

                (* Figure out which objects are simulated. *)
                (* note that although elsewhere in this code we don't want to count things in $CurrentSimulation as "simulated", here we do because FRQ will not work nicely with any simulated objects, $CurrentSimulation or not *)
                simulatedObjects=If[MatchQ[$CurrentSimulation, SimulationP],
                  Intersection[Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]], objectsInResourceBlobs],
                  Intersection[Lookup[currentSimulation[[1]], SimulatedObjects], objectsInResourceBlobs]
                ];

                (* Only check if non-simulated objects are fulfillable. *)
                (
                  If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
                    Nothing,
                    #
                  ]
                &)/@allResourceBlobs
              ];

              (* split up the resources that have Sample set to an Object vs all the rest of them *)
              (* doing this because we must call FRQ on the objects at the proper time between unit operations, but for performance sake, would like to save all the models (which are considerably slower) to the end of the SP call *)
              objectResources = Select[nonSimulatedResourceBlobs, MatchQ[#[Sample], ObjectP[Object]]&];
              newNonObjectResources = DeleteCases[nonSimulatedResourceBlobs, Alternatives @@ objectResources];

              (* call fulfillableResourceQ on all the resources we created *)
              (* NOTE: we want to look at resource availability BEFORE the experiment has been run. *)
              (* if UnitOperationPackets -> True, then we aren't calling FRQ because the function that called it will do it instead *)
              {newFulfillableQ, newFrqTests} = Which[
                MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {True, {}},
                gatherTests, Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation, Output -> {Result, Tests}],
                True, {Resources`Private`fulfillableResourceQ[objectResources, Simulation->previousSimulation], {}}
              ];

              (* Append our new non-Object Resources *)
              AppendTo[nonObjectResources, newNonObjectResources];

              (* Append our new FRQ tests. *)
              AppendTo[frqTests, newFrqTests];

              (* If we aren't fulfillable, keep track of that globally. *)
              If[MatchQ[newFulfillableQ, False],
                fulfillableQ=False;
              ];
            ];

            (* TODO: Need to deal with resource constraints differently according to the work cell type that we're on. *)

            (* Figure out what new labeled objects we have from this primitive. *)
            (* NOTE: There may be other new objects that we require on deck that are NOT labeled. This is only for *)
            (* keeping track of what we should put in the protocol-level LabeledObjects/FutureLabeledObjects fields. *)
            newLabeledObjectsLookup=Module[{newLabeledObjectKeys},
              newLabeledObjectKeys=Complement[
                labeledObjectsLookup[[All,1]],
                currentPrimitiveGroupingLabeledObjects[[All,1]]
              ];

              DeleteDuplicates@Cases[
                labeledObjectsLookup,
                Verbatim[Rule][Alternatives@@newLabeledObjectKeys, _]
              ]
            ];

            (* Lookup the footprints of any samples/containers/etc. For sample resources, we really care about the *)
            (* container to see if we already have an equivalent resource. *)
            (* NOTE: Object[Resource, Sample] is used for samples, containers, items, and parts. We explicitly leave out *)
            (* Model[Item, Tips] since we check that seperately. Lid spacers go on each plate, so if we can fit the plates *)
            (* we can fit the lid spacers. We assume that we can fit all the lids since we're constrained by plates, not lids. *)
            sampleAndContainerResourceBlobs=Module[
              {allResourcesWithoutInjectionSamples, allResourcesWithoutItems},

              allResourcesWithoutInjectionSamples=If[MatchQ[unitOperationPackets, {PacketP[]..}],
                DeleteDuplicates[
                  Cases[
                    Normal/@KeyDrop[unitOperationPackets, {Replace[PrimaryInjectionSampleLink], Replace[SecondaryInjectionSampleLink], Replace[TertiaryInjectionSample], Replace[QuaternaryInjectionSample]}],
                    _Resource,
                    Infinity
                  ]
                ],
                {}
              ];

              allResourcesWithoutItems=Cases[
                allResourcesWithoutInjectionSamples,
                Resource[
                  KeyValuePattern[{
                    Type->Object[Resource,Sample],
                    Sample->Except[ObjectReferenceP[{
                      Model[Item, Tips],
                      Object[Item, Tips],
                      Model[Item, Lid],
                      Object[Item, Lid],
                      Model[Item, PlateSeal],
                      Object[Item,PlateSeal],
                      Model[Item, LidSpacer],
                      Object[Item, LidSpacer],
                      Object[Item, MagnetizationRack],
                      Model[Item, MagnetizationRack]
                    }] | ObjectReferenceP[Model[Item,"id:Y0lXejMp6aRV"]]] (*"Hamilton MultipProbeHead tip rack"*)
                  }]
                ]
              ];

              allResourcesWithoutItems
            ];

            samplesAndContainerObjects=Flatten[(
              If[KeyExistsQ[#[[1]], Container],
                Lookup[#[[1]], Container],
                Lookup[#[[1]], Sample]
              ]
            &)/@sampleAndContainerResourceBlobs];

            (* Do we have a ThawCells unit operation? If so, create a map of sample/container resources to the thawing time *)
            (* for each of these samples. This is so that we don't put samples into the same liquid handler adapter if *)
            (* they have different thawing times. *)
            sampleAndContainerResourceBlobToIncubationTimeLookup=If[!MemberQ[unitOperationPackets, PacketP[Object[UnitOperation, ThawCells]]],
              {},
              Module[{thawCellsUnitOperationPackets},
                (* Get the thaw cells unit operation packets. *)
                thawCellsUnitOperationPackets=Cases[unitOperationPackets, PacketP[Object[UnitOperation, ThawCells]]];

                (* Assume that the Times field will always be index matched to the SampleLink field. Use that to create a lookup. *)
                Rule@@@Transpose[{Flatten[Lookup[thawCellsUnitOperationPackets, Replace[SampleLink]]], Flatten[Lookup[thawCellsUnitOperationPackets, Replace[Time]]]}]
              ]
            ];

            (* Gather the models of any requested instruments. *)
            instrumentResourceBlobs=Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]];
            instrumentResourceObjects=Download[(Lookup[#[[1]], Instrument]&)/@instrumentResourceBlobs, Object];
            instrumentResourceModels=instrumentResourceObjects/.{
              Rule[
                ObjectP[Cases[instrumentResourceObjects, ObjectP[Object[Instrument]]]],
                Download[Cases[instrumentResourceObjects, ObjectP[Object[Instrument]]], Model[Object]]
              ]
            };

            (* gather instruments from primitive grouping resource blobs *)
            currentPrimitiveGroupingIntegratedInstruments=Download[(Lookup[#[[1]], Instrument]&)/@currentPrimitiveGroupingIntegratedInstrumentsResources, Object];

            (* gather only instrument models from our resources *)
            allInstrumentResourceModels=DeleteDuplicates@Flatten[{
              instrumentResourceModels,
              currentPrimitiveGroupingIntegratedInstruments/. {
                Rule[
                  ObjectP[Cases[Flatten[{instrumentResourceObjects,currentPrimitiveGroupingIntegratedInstruments}], ObjectP[Object[Instrument]]]],
                  Download[Cases[Flatten[{instrumentResourceObjects,currentPrimitiveGroupingIntegratedInstruments}], ObjectP[Object[Instrument]]], Model[Object]]
                ]
              }
            }];

            (* Gather the tip models that we need for this primitive. *)
            tipResourceBlobs=Cases[
              allResourceBlobs,
              Resource[KeyValuePattern[Sample -> LinkP[Model[Item, Tips]]|ObjectReferenceP[Model[Item, Tips]]]]
            ]/.{link_Link :> Download[link, Object]};

            (* Further split up samplesAndContainerObjects into samples and not samples. *)
            sampleObjects=Download[Cases[samplesAndContainerObjects, ObjectP[Object[Sample]]], Object];
            nonSampleObjects=Download[UnsortedComplement[samplesAndContainerObjects, sampleObjects], Object];

            (* join the objects we're Downloading from together *)
            objectsToDownloadFrom = Join[
              sampleObjects,
              nonSampleObjects,
              If[MatchQ[unitOperationPackets,{PacketP[]..}],
                Lookup[unitOperationPackets, Object],
                {}
              ]
            ];
            containerModelFieldsList = {Name,Footprint,CoverFootprints,CoverTypes,LiquidHandlerAdapter,HighPrecisionPositionRequired,Dimensions,TareWeight,WellDepth,Positions,MaxVolume,MinVolume};
            (* NOTE: We are assuming here that all of the "non-samples" that we're given will have a Footprint field in their Model. *)
            (* NOTE: We are downloading the simulated version of our unit operation packet here to get the simulated Object[...] *)
            (* of any Model[...] resources that should be created by SimulateResources for us. *)
            (* make the fields that we're downloading from; importantly, don't get Model fields from things that aren't models *)
            fieldsToDownloadFrom = Map[
              Switch[#,
                ObjectP[Object[UnitOperation]],
                {Packet[All]},
                ObjectP[Object[Sample]],
                {
                  Packet[Container, Name],
                  Packet[Container[{Name, Model}]],
                  Packet[Container[Model][containerModelFieldsList]]
                },
                ObjectP[Object[Container]],
                {
                  Packet[Model, KeepCovered, Cover, Name],
                  Packet[Model[containerModelFieldsList]]
                },
                ObjectP[Model[Container]],
                {
                  Packet[Sequence@@containerModelFieldsList]
                },
                _,
                {
                  Packet[
                    Model,
                    Name,
                    Footprint,
                    LiquidHandlerAdapter
                  ],
                  Packet[
                    Model[containerModelFieldsList]
                  ]
                }
              ]&,
              objectsToDownloadFrom
            ];

            resourceCache=Flatten@Quiet[
              Download[
                objectsToDownloadFrom,
                Evaluate[fieldsToDownloadFrom],
                Simulation->currentSimulation,
                Cache->cacheBall
              ],
              {Download::FieldDoesntExist, Download::NotLinkField}
            ];

            cacheBall=FlattenCachePackets[{cacheBall, resourceCache}];

            (* Find all of the footprint of all the containers that we need to place in the work cell for this primitive. *)
            (* Before we calculate the footprint required, we need to combine the resources required across different unit operations and eliminate unnecessary footprints *)
            (* This includes two different cases: *)
            (* 1) Multiple resources of the same Model[Sample] and their total volume still fit in the same container's MaxVolume. We can create one resource and request the total volume *)
            (* 2) Multiple resources require the same incubation parameters and same container model. We can share the same container model but put the resources into different wells *)
            (* Update the resources to include containerName and well to show their possible consolidations with previous resource blobs *)
            updatedSampleAndContainerResourceBlobs=Module[
              {currentPrimitiveGroupingTuples,accumulatedResourceTuples},

              (* Parse the previous resources to be in tuples of {sampleModel,containerModel,containerName,well} *)
              currentPrimitiveGroupingTuples=Map[
                If[
                  And[
                    MatchQ[Lookup[#,Resource],Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]]],
                    (* Make sure the resource blob does not have existing container name. If it has a container name, we should not put new resources into the same container *)
                    !KeyExistsQ[Lookup[#,Resource][[1]],ContainerName],
                    (* We have set ConsolidateTransferResources key as True in transfer if it is to fulfill one Model[Sample] resource and can be combined *)
                    TrueQ[Lookup[Lookup[#,Resource][[1]],ConsolidateTransferResources,False]]
                  ],
                  (* Only care about Model[Sample] resource with a specified container model and volume *)
                  {
                    Download[Lookup[Lookup[#,Resource][[1]],Sample],Object],
                    (* Use the updated container list (instead of the full list from resource blob) *)
                    Lookup[#,ContainerModels],
                    Lookup[Lookup[#,Resource][[1]],SourceTemperature,Null],
                    Lookup[Lookup[#,Resource][[1]],SourceEquilibrationTime,Null],
                    Lookup[Lookup[#,Resource][[1]],MaxSourceEquilibrationTime,Null],
                    Lookup[Lookup[#,Resource][[1]],Amount],
                    Lookup[#,ContainerName],
                    Lookup[#,Well]
                  },
                  Nothing
                ]&,
                currentPrimitiveGroupingFootprints
              ];
              (* Track any new resource with existing resource list too so we don't over-consolidate or use duplicated wells *)
              accumulatedResourceTuples=currentPrimitiveGroupingTuples;

              (* We only perform possible consolidations on sample resources with Container. All other resources will remain unchanged *)
              (* Note that within one primitive, we do NOT have resource with the same Model[Sample] that can be consolidated together because that would have been done within the resource packets of the experiment function *)
              Map[
                Function[
                  {resourceBlob},
                  If[
                    And[
                      MatchQ[resourceBlob,Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]]],
                      (* Make sure the resource blob does not have existing container name. If it has a container name, we should not put new resources into the same container *)
                      !KeyExistsQ[resourceBlob[[1]],ContainerName]
                    ],
                    Module[
                      {containerModels,sampleModel,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,accumulatedResourceTuplesMatchingContainerModels,existingSampleModelResourceTuples,existingContainerModelResourceTuples,containerNameVolumeTuples,containerNamePositionTuples,updatedContainerModels,containerName,well,newResourceTuple,updatedAccumulatedResourceTuples},
                      containerModels=ToList[Download[Lookup[resourceBlob[[1]],Container],Object]];
                      (* Get the model of the sample *)
                      sampleModel=Download[Lookup[resourceBlob[[1]],Sample],Object];
                      (* Get the incubation parameters (this has to match for the resources to consolidate or group *)
                      sourceTemperature=Lookup[resourceBlob[[1]],SourceTemperature,Null];
                      sourceEquilibrationTime=Lookup[resourceBlob[[1]],SourceEquilibrationTime,Null];
                      maxSourceEquilibrationTime=Lookup[resourceBlob[[1]],MaxSourceEquilibrationTime,Null];
                      volume=Lookup[resourceBlob[[1]],Amount];

                      (* Get the accumulated resources with at least one matching container model *)
                      accumulatedResourceTuplesMatchingContainerModels=Select[
                        accumulatedResourceTuples,
                        IntersectingQ[#[[2]],containerModels]&
                      ];
                      (* Get the existing resources with the same model and container model. See if we can fit the new volume into the same resource *)
                      existingSampleModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{sampleModel,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];
                      (* Get the existing resources with the same container model and incubation parameters see if it has more position for new resource *)
                      existingContainerModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{_,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];

                      (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                      containerNameVolumeTuples=Map[
                        Function[
                          {resourceTupleGroup},
                          Module[
                            {totalVolume,commonContainers,containerModelPackets,containerMaxVolumes,containerMinVolumes,sourceContainerDeadVolumes,qualifiedContainers},
                            totalVolume=Total[Flatten[{resourceTupleGroup[[All,-3]],volume}]];
                            commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                            containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                            containerMaxVolumes=Lookup[containerModelPackets,MaxVolume,Null];
                            containerMinVolumes=Lookup[containerModelPackets,MinVolume,Null];
                            (* Get the dead volume of the container *)
                            (* use the MinVolume of the container as the required dead volume. If not available, use 10% of max volume *)
                            sourceContainerDeadVolumes=MapThread[
                              If[!NullQ[#2],
                                #2,
                                0.1 * #1
                              ]&,
                              {containerMaxVolumes,containerMinVolumes}
                            ];

                            (* Select the large enough container model(s) *)
                            qualifiedContainers=MapThread[
                              If[TrueQ[(totalVolume+#3)<#2],
                                #1,
                                Nothing
                              ]&,
                              {commonContainers,containerMaxVolumes,sourceContainerDeadVolumes}
                            ];

                            If[Length[qualifiedContainers]==0,
                              (* Do no track if the volume is too large for all models *)
                              Nothing,
                              (* Track the total volume, updated container models and containerName/well tuple  *)
                              {totalVolume,qualifiedContainers,resourceTupleGroup[[1,-2]],resourceTupleGroup[[1,-1]]}
                            ]
                          ]
                        ],
                        GatherBy[existingSampleModelResourceTuples,(#[[-2;;-1]])&]
                      ];

                      containerNamePositionTuples=Map[
                        Function[
                          {resourceTupleGroup},
                          Module[
                            {commonContainers,containerModelPackets,containerPositions,occupiedPositions,qualifiedContainers,emptyPosition},
                            commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                            containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                            containerPositions=Lookup[containerModelPackets,Positions,{}];

                            (* Get the positions occupied *)
                            occupiedPositions=DeleteDuplicates[resourceTupleGroup[[All,-1]]];

                            (* Select the large enough container model(s) and track container model and first open position *)
                            qualifiedContainers=MapThread[
                              If[MatchQ[Complement[Lookup[#2,Name,{}],occupiedPositions],{}],
                                Nothing,
                                {#1,Sort@Complement[Lookup[#2,Name,{}],occupiedPositions]}
                              ]&,
                              {commonContainers,containerPositions}
                            ];

                            (* We always fill resource containers in sorted order so select the common empty position of all container models to use *)
                            emptyPosition=If[Length[qualifiedContainers]>0,
                              First[Intersection@@(qualifiedContainers[[All,2]])],
                              Null
                            ];

                            If[Length[qualifiedContainers]==0,
                              (* Do no track if the volume is too large for all models *)
                              Nothing,
                              (* Track the first open position, updated container models and containerName/well tuple  *)
                              {qualifiedContainers[[All,1]],emptyPosition,resourceTupleGroup[[1,-2]]}
                            ]
                          ]
                        ],
                        GatherBy[existingContainerModelResourceTuples,(#[[-2]])&]
                      ];

                      (* Select the existing resource position to consolidate or create a new one *)
                      {updatedContainerModels,containerName,well}=Which[
                        Length[containerNameVolumeTuples]>0,
                        (* Select the resource position that prepares largest volume to get the best efficiency for resouce consolidation *)
                        ReverseSortBy[containerNameVolumeTuples,First][[1,2;;4]],
                        Length[containerNamePositionTuples]>0,
                        (* Use the first possible position *)
                        {containerNamePositionTuples[[1,1]],containerNamePositionTuples[[1,3]],containerNamePositionTuples[[1,2]]},
                        True,
                        (* Use a UUID and "A1" position for new resource *)
                        {containerModels,CreateUUID[],"A1"}
                      ];

                      (* create the new resource tuple to be tracked and also return the updated *)
                      newResourceTuple={sampleModel,updatedContainerModels,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,containerName,well};

                      (* Update the accumulated resource tuple list to reflect updated containerModels for the same containerName *)
                      updatedAccumulatedResourceTuples=ReplacePart[
                        accumulatedResourceTuples,
                        ({#,2}->updatedContainerModels)&/@Flatten[Position[accumulatedResourceTuples,{___,containerName,_}]]
                      ];

                      accumulatedResourceTuples=Append[updatedAccumulatedResourceTuples,newResourceTuple];
                      {resourceBlob,updatedContainerModels,containerName,well}
                    ],
                    (* Other resource blobs remain unchanged *)
                    {resourceBlob,Lookup[resourceBlob[[1]],Container,{}],CreateUUID[],Null}
                  ]
                ],
                sampleAndContainerResourceBlobs
              ]
            ];

            (* NOTE: This is in the format: *)
            (*
              {
                {
                  containerFootprint:FootprintP,
                  liquidHandlerAdapter:(ObjectP[Model[Container, Rack]]|Null),
                  container:ObjectP[Object[Container]],
                  resource:ResourceP,
                  highPrecisionPositionContainer:Boolean,
                  (* to track future resource consolidation *)
                  index,
                  (* to show the container grouping/resource consolidation *)
                  (* this containerModels is the updates possible list of containers, with small containers (MaxVolume < consolidated volume) removed *)
                  containerModels,
                  containerName,
                  well,
                  (* NOTE: This is only populated for resources that are coming out of a ThawCells unit operation since *)
                  (* we don't want to group together vials on the same liquid handler adapter if they should be thawed *)
                  (* for different amounts of time. *)
                  incubationTime:(TimeP|Null)
                }..
              }.
            *)
            currentFootprintResult=Map[
              Function[{resourceContainerNameTuple},
                Module[{container,resource,containerModels,containerName,well},
                  {resource,containerModels,containerName,well}=resourceContainerNameTuple;
                  (* Get the container of the sample. *)
                  container=Which[
                    !MatchQ[containerModels,{}],
                    (* Use the first possible container for footprint purpose *)
                    First[containerModels],
                    !MatchQ[resource,Resource[KeyValuePattern[Type->Object[Resource,Sample]]]],
                    Null,
                    KeyExistsQ[resource[[1]],Container],
                    (* Container in resource can be a list but we limit them to have the same footprint in UO resolvers *)
                    First[ToList[Download[Lookup[resource[[1]],Container],Object]]],
                    MatchQ[Lookup[resource[[1]],Sample],ObjectP[Object[Sample]]],
                    Download[
                      Lookup[fetchPacketFromCache[Lookup[resource[[1]],Sample],resourceCache],Container],
                      Object
                    ],
                    MatchQ[Lookup[resource[[1]],Sample],ObjectP[{Object[],Model[]}]],
                    Download[Lookup[resource[[1]],Sample],Object],
                    True,
                    Null
                  ];

                  Module[{containerModelPacket,footprint,liquidHandlerAdapter,highPrecisionPositionRequired},
                    (* Get the packet of the container model. *)
                    containerModelPacket=Which[
                      MatchQ[container,ObjectP[{Object[Container],Object[Item]}]],
                      fetchPacketFromCache[
                        Lookup[fetchPacketFromCache[container,resourceCache],Model],
                        resourceCache
                      ],
                      MatchQ[container,ObjectP[{Model[Container],Model[Item]}]],
                      fetchPacketFromCache[container,resourceCache],
                      True,
                      Null
                    ];

                    (* Get the direct footprint of the container model. *)
                    footprint=If[NullQ[containerModelPacket],
                      Null,
                      Lookup[containerModelPacket,Footprint]
                    ];

                    (* Get the footprint of the liquid handler adapter (if we need to use one). *)
                    liquidHandlerAdapter=If[NullQ[containerModelPacket],
                      Null,
                      Download[Lookup[containerModelPacket,LiquidHandlerAdapter],Object]/.{$Failed->Null}
                    ];

                    (* Get the precision boolean of the container model. *)
                    highPrecisionPositionRequired=If[NullQ[containerModelPacket],
                      Null,
                      Lookup[containerModelPacket,HighPrecisionPositionRequired]/.{($Failed|_Missing)->Null}
                    ];

                    Which[
                      (* Don't include resources for simulated containers since these simulated containers are already *)
                      (* counted for by the Model[Container] resources that were made by upstream primitives. *)
                      MatchQ[container,ObjectP[Object[]]] && MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], container],
                        Nothing,
                      MatchQ[container,ObjectP[Object[]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            Download[container,Object],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      (* We do not use simulated object for counterweights since we are going to do 1 counterweight object per model *)
                      MatchQ[container,ObjectP[Model[Item,Counterweight]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            Download[container,Object],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      MatchQ[container,ObjectP[Model[]]],
                        AssociationThread[
                          footprintInformationKeys,
                          {
                            footprint,
                            liquidHandlerAdapter,
                            (* NOTE: If we have a Model[...], lookup its simulated Object[...] from the simulation. *)
                            (* This is the Object[...] that will be used in future resource requests. *)
                            Module[{unitOperationPacketWithResource,position,simulatedObject},
                              (* Find which unit operation packet (we may have multiple due to unit operation "subs") our *)
                              (* resource is in. *)
                              unitOperationPacketWithResource=FirstCase[unitOperationPackets,_?(MemberQ[Normal[#],resource,Infinity]&)];

                              (* Figure out what field our resource is in. *)
                              (* NOTE: We're going to find where our resource was because we did a Cases[...] of our *)
                              (* unit operation packet to get the resources in the first place. *)
                              position=FirstPosition[unitOperationPacketWithResource,resource,$Failed]/.{Replace[x_]:>x};

                              (* Get the simulated version of our resource from the SimulateResource'd simulated *)
                              (* unit operation. *)
                              simulatedObject=Extract[
                                fetchPacketFromCache[Lookup[unitOperationPacketWithResource,Object],cacheBall],
                                position
                              ];

                              Download[simulatedObject,Object]
                            ],
                            resource,
                            highPrecisionPositionRequired,
                            index,
                            containerModels,
                            containerName,
                            well,
                            Lookup[sampleAndContainerResourceBlobToIncubationTimeLookup, resource, Null]
                          }
                        ],
                      True,
                        Nothing
                    ]
                  ]
                ]
              ],
              updatedSampleAndContainerResourceBlobs
            ];

            (* Merge footprint results that show up multiple times that are the same but just have different incubation times. *)
            (* Pick the longest incubation time when merging if there are multiple. *)
            currentFootprintResult=(Module[{times},
              times=Cases[Lookup[#,IncubationTime], TimeP];

              If[Length[times]==0,
                Join[First[#], <|IncubationTime->Null|>],
                Join[First[#], <|IncubationTime->Max[times]|>]
              ]
            ]&)/@GatherBy[currentFootprintResult, KeyDrop[#,IncubationTime]&];

            (* Remove any duplicates (same object or same container name) from the current primitive's footprint result *)
            currentFootprintResultNoDuplicates=DeleteDuplicatesBy[
              DeleteDuplicatesBy[currentFootprintResult, (Lookup[#,Container]&)],
              (Lookup[#,ContainerName]&)
            ];

            (* Remove any footprints that are already in the workcell from a previous primitive. *)
            (* This can be the same container object (sample ID or container ID), or the same containerName *)
            newFootprintResult=Select[
              currentFootprintResult,
              (And[
                !MemberQ[Lookup[currentPrimitiveGroupingFootprints,Container,{}], Lookup[#,Container]],
                !MemberQ[Lookup[currentPrimitiveGroupingFootprints,ContainerName,{}], Lookup[#,ContainerName]]
              ]&)
            ];
            (* Get rid of any duplicates from the new container list. *)
            newFootprintResultNoDuplicates=DeleteDuplicatesBy[
              DeleteDuplicatesBy[newFootprintResult, (Lookup[#,Container]&)],
              (Lookup[#,ContainerName]&)
            ];

            (* Join this with our existing footprints. *)
            allFootprintResult=Join[newFootprintResultNoDuplicates, currentPrimitiveGroupingFootprints];

            (* DeleteDuplicates by the container and resource ID. *)
            (* NOTE: We are effectively LEAVING OUT some of our label->footprint rules here because you can have a label *)
            (* for the sample and a label for the container and we only want to count the footprint once. *)
            newFootprintTally=tallyFootprints[allFootprintResult];

            (* Append a plate footprint to newFootprintTally if there is a Model[Item,MagnetizationRack] or Object[Item,MagnetizationRack] *)
            (* Anywhere in the previous resources *)
            currentPrimitiveGroupingResourceBlobs = Cases[currentPrimitiveGroupingUnitOperationPackets,_Resource,Infinity];

            (* Get the MagnetizationRack resource blobs *)
            currentPrimitiveGroupingMagnetizationRackResourceBlobs=Cases[currentPrimitiveGroupingResourceBlobs,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]]];
            (* If there is a magnetization rack resource blob, increment the counter of footprint Plate in newFootprintTally by 1 *)
            (* Otherwise do nothing *)
            newFootprintTally=If[!MatchQ[currentPrimitiveGroupingMagnetizationRackResourceBlobs,{}],
              If[MemberQ[newFootprintTally,{Plate,_Integer}],
                newFootprintTally/.{Plate,x_Integer}:>{Plate,x+1},
                Append[newFootprintTally,{Plate,1}]
              ],
              newFootprintTally
            ];
            (* Also count for only this primitive just in case we need to start a new protocol in the script here *)
            singlePrimitiveFootprintTally=tallyFootprints[currentFootprintResultNoDuplicates];

            (* Do the same append to this variable if there is a Model[Item,MagnetizationRack] or Object[Item,MagnetizationRack] *)
            (* Anywhere in the current uo resources *)
            currentUOResourceBlobs = Cases[unitOperationPackets,_Resource,Infinity];

            (* Get the MagnetizationRack resource blobs *)
            currentUOMagnetizationRackResourceBlobs=Cases[currentUOResourceBlobs,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]]];
            (* If there is a magnetization rack resource blob, increment the counter of footprint Plate in newFootprintTally by 1 *)
            (* Otherwise do nothing *)
            singlePrimitiveFootprintTally=If[!MatchQ[currentUOMagnetizationRackResourceBlobs,{}],
              If[MemberQ[singlePrimitiveFootprintTally,{Plate,_Integer}],
                singlePrimitiveFootprintTally/.{Plate,x_Integer}:>{Plate,x+1},
                Append[singlePrimitiveFootprintTally,{Plate,1}]
              ],
              singlePrimitiveFootprintTally
            ];

            (* Get a list of all of tip resources that we need. *)
            allTipResources=Flatten[{tipResourceBlobs, currentPrimitiveGroupingTips}];

            (* Figure out the number of stacked and non-stacked tips that we're going to have in the form of *)
            (* {{ObjectP[Model[Item, Tip]], tipCountRequired_Integer}..} *)
            {flattenedStackedTipTuples, flattenedNonStackedTipTuples}=partitionTips[tipModelPackets, allTipResources, currentPrimitiveGrouping];
            {singlePrimitiveFlattenedStackedTipTuples, singlePrimitiveFlattenedNonStackedTipTuples}=partitionTips[tipModelPackets, tipResourceBlobs, {resolvedPrimitive}];

            (* -- Compute the starting positions (Ambient or Incubator) of our new containers with Footprint->Plate. -- *)
            (* NOTE: In order to do this, for our current primitive grouping (with our new primitive added), we need to *)
            (* compute the starting positions of the containers (Incubator or Ambient) based on if they have cells in *)
            (* them. Then, we need to march through the idling condition history to make sure that we don't run out of *)
            (* Ambient or Incubator positions. *)

            (* NOTE: We only care about containers that have a Plate footprint (taking into account adapters as well) because *)
            (* these are the only types of containers that we can move around on the deck. Everything else will stay where *)
            (* it is originally placed. *)

            (* NOTE: Any Model[Container]s must start off Ambient because they cannot have cells in them. *)
            (* NOTE: We also want to download the CellType from these containers BEFORE any simulation occurs. *)

            (* Filter out to only care about plates or vessels that have adapters (that will make them into plates). *)
            newPlateFootprintResult=Cases[newFootprintResultNoDuplicates, KeyValuePattern[{Footprint->Plate,LiquidHandlerAdapter->Except[Null]}]];

            objectContainersFromResourcesExistQ=If[MatchQ[$CurrentSimulation, SimulationP],
              Module[{allSimulatedObjects},
                allSimulatedObjects=Join[Lookup[$CurrentSimulation[[1]], SimulatedObjects], Lookup[currentSimulation[[1]], SimulatedObjects]];

                (!MemberQ[allSimulatedObjects, #]&)/@Lookup[newPlateFootprintResult,Container,{}]
              ],
              (!MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], #]&)/@Lookup[newPlateFootprintResult,Container,{}]
            ];

            objectContainerPacketsFromResource=Quiet[
              Download[
                PickList[Lookup[newPlateFootprintResult,Container,{}], objectContainersFromResourcesExistQ, True],
                Packet[Contents[[All,2]][{CellType}]]
              ],
              {Download::FieldDoesntExist, Download::NotLinkField}
            ];

            (* Separate out the containers that should go on deck from the containers that should go in the incubator. *)

            (* Containers that go into the incubator must be Object[Container]s (in order to previously have cells in them). *)
            (* And must already exist in the database. *)
            incubatorPlateResources=Select[
              Transpose[{
                PickList[Lookup[newPlateFootprintResult,Resource,{}], objectContainersFromResourcesExistQ, True],
                objectContainerPacketsFromResource
              }],
              Not[MatchQ[#[[2]], $Failed]] && MemberQ[Lookup[Flatten[#[[2]]], CellType, Null], Except[Null|$Failed]]&
            ][[All, 1]];

            (* The ambient containers are the ones that we're not putting in the incubator. *)
            ambientPlateResources=DeleteDuplicates@Join[
              (* The rest of the Object[Container]s that actually exist that aren't going into the incubator. *)
              UnsortedComplement[
                PickList[Lookup[newPlateFootprintResult,Resource,{}], objectContainersFromResourcesExistQ, True],
                incubatorPlateResources
              ],
              (* Plus any Model[Container] resources. *)
              Cases[Lookup[newPlateFootprintResult,Resource,{}], KeyValuePattern[Sample->ObjectP[Model[Container]]]]
            ];

            (* Get the Object[Container]s (some may be simulated) that correspond to all our starting incubator/ambient *)
            (* containers. *)
            (* NOTE: We're filtering out containers that need an adapter here. *)
            startingIncubatorContainers=(
              Lookup[FirstCase[allFootprintResult, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            startingAmbientContainers=(
              Lookup[FirstCase[allFootprintResult, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            (*which containers require high Precision*)
            highPrecisionPositionContainersBools=allFootprintResult[[All,5]];

            (* Repeat for this only primitive *)
            singlePrimitiveStartingIncubatorContainers=(
              Lookup[FirstCase[newFootprintResultNoDuplicates, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            singlePrimitiveStartingAmbientContainers=(
              Lookup[FirstCase[newFootprintResultNoDuplicates, KeyValuePattern[{LiquidHandlerAdapter->Null,Resource->#}],{}],Container,Nothing]
            &)/@Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            (*which containers require high Precision*)
            singlePrimitiveHighPrecisionPositionContainersBools=Lookup[newFootprintResultNoDuplicates,HighPrecisionPositionRequired];

            (* Get the Object[Container]s that must be OnDeck/Incubator because we're going to use them in our primitive. *)
            (* NOTE: This is slightly incorrect because we're assuming that no single primitive can exceed the on deck *)
            (* capacity. That is, we're treating Ambient the same as OnDeck. *)
            (* NOTE: Object[UnitOperation, IncubateCells] is the only unit operation that can put containers INTO the incubator. *)
            workCellIdlingConditions=If[MatchQ[Lookup[FirstOrDefault[unitOperationPackets,{}], Object], ObjectP[Object[UnitOperation, IncubateCells]]],
              (* Assume that everything that is required by IncubateCells and is Footprint->Plate will end up going into the incubator. *)
              Join[
                (#->Incubator&)/@Cases[currentFootprintResult, {Plate, ___}][[All,3]],
                (#->Ambient&)/@Cases[currentFootprintResult, {Except[Plate], ___}][[All,3]]
              ],
              (#->Ambient&)/@currentFootprintResult[[All,3]]
            ];
            (* If we've already have a list of potential instruments, then work to whittle down that list and see if we *)
            (* can fit in this primitive. Otherwise, start with our full list. *)
            filteredInstruments=filterInstruments[
              Which[
                MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                  {requestedInstrument},
                MatchQ[currentPrimitiveGroupingPotentialWorkCellInstruments, {ObjectP[{Model[Instrument], Object[Instrument]}]..}],
                  currentPrimitiveGroupingPotentialWorkCellInstruments,
                True,
                  Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
              ],
              newFootprintTally,
              startingAmbientContainers,
              startingIncubatorContainers,
              Join[currentPrimitiveGroupingWorkCellIdlingConditionHistory, workCellIdlingConditions],
              Length[flattenedStackedTipTuples],
              Length[flattenedNonStackedTipTuples],
              allInstrumentResourceModels,
              highPrecisionPositionContainersBools,
              Flatten[{workCellObjectPackets, workCellModelPackets}],
              tipAdapterUsedQ
            ];


            Which[
              (* If we have instruments that can perform this primitive (along with the rest of the primitives in our *)
              (* current group), just update the instrument list. *)
              Length[filteredInstruments]>0,
               currentPrimitiveGroupingPotentialWorkCellInstruments=filteredInstruments,

              (* OTHERWISE: There are no instruments to fit all of our primitives, plus our current primitive, on deck. *)

              (* Is the user forcing us to put this primitive into the current method index group? *)
              MatchQ[primitiveMethodIndex, Except[Automatic]],
                (* Don't update the instrument list, just log an error. *)
                Message[
                  Error::NoWorkCellsPossibleForUnitOperation,
                  Head[resolvedPrimitive],
                  index,
                  tallyFootprints[newFootprintResultNoDuplicates],
                  ObjectToString[DeleteDuplicates[instrumentResourceModels], Cache->cacheBall],
                  Length[tipResourceBlobs],
                  newFootprintTally,
                  ObjectToString[allInstrumentResourceModels, Cache->cacheBall],
                  Length[flattenedStackedTipTuples],
                  ObjectToString[flattenedStackedTipTuples[[All,1]], Cache->tipModelPackets],

                  (* NOTE: If we're using a tip adapter, we will be using 1 more non-stacked tip position, which can cause the deck to not fit our tips. *)
                  If[tipAdapterUsedQ,
                    Length[flattenedNonStackedTipTuples]+1,
                    Length[flattenedNonStackedTipTuples]
                  ],
                  If[tipAdapterUsedQ,
                    ObjectToString[Append[flattenedNonStackedTipTuples[[All,1]], Model[Item, "Hamilton 96 MultiProbeHead Tip Adapter (Used for NxM shifted pipetting)"]], Cache->tipModelPackets],
                    ObjectToString[flattenedNonStackedTipTuples[[All,1]], Cache->tipModelPackets]
                  ]
                ];
                AppendTo[noInstrumentsPossibleErrorsWithIndices, {Head[resolvedPrimitive], index, primitive}],

              (* If we aren't able to put this primitive on deck due to capacity requirements and the user isn't forcing *)
              (* us to put the primitive in a certain group (PrimitiveMethodIndex), then start a new group. *)
              True,
               Module[{filteredInstrumentsStartingFromFullList},
                (* Start a new grouping. *)
                startNewPrimitiveGrouping[];

                (* Start from our FULL list of instruments for our work cell, then whittle it down again. *)
                filteredInstrumentsStartingFromFullList=filterInstruments[
                  If[MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                    {requestedInstrument},
                    Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
                  ],
                  singlePrimitiveFootprintTally,
                  singlePrimitiveStartingAmbientContainers,
                  singlePrimitiveStartingIncubatorContainers,
                  workCellIdlingConditions,
                  Length[singlePrimitiveFlattenedStackedTipTuples],
                  Length[singlePrimitiveFlattenedStackedTipTuples],
                  allInstrumentResourceModels,
                  singlePrimitiveHighPrecisionPositionContainersBools,
                  Flatten[{workCellObjectPackets,workCellModelPackets}],
                  (* this is for the Tip Adapter, since we are starting a new group, we can't have one yet*)
                  tipAdapterUsedQ
                ];
                (* If we STILL don't have any instruments that we can use, make sure to record an error and just *)
                (* use all instruments for resolving. *)
                currentPrimitiveGroupingPotentialWorkCellInstruments=If[Length[filteredInstrumentsStartingFromFullList]==0,
                   Message[
                     Error::NoWorkCellsPossibleForUnitOperation,
                     Head[resolvedPrimitive],
                     index,
                     tallyFootprints[newFootprintResultNoDuplicates],
                     ObjectToString[instrumentResourceModels, Cache->cacheBall],
                     Length[tipResourceBlobs],
                     newFootprintTally,
                     ObjectToString[allInstrumentResourceModels, Cache->cacheBall],
                     Length[flattenedStackedTipTuples],
                     ObjectToString[flattenedStackedTipTuples[[All,1]], Cache->tipModelPackets],
                     Length[flattenedNonStackedTipTuples],
                     ObjectToString[flattenedNonStackedTipTuples[[All,1]], Cache->tipModelPackets]
                   ];

                  (* NOTE: We still append here so that we can keep track of our invalid inputs. *)
                  AppendTo[noInstrumentsPossibleErrorsWithIndices, {Head[resolvedPrimitive], index, primitive}];

                   If[MatchQ[requestedInstrument,ObjectP[{Model[Instrument], Object[Instrument]}]],
                     {requestedInstrument},
                     Lookup[$WorkCellsToInstruments, Lookup[resolvedPrimitive[[1]], WorkCell]]
                   ],
                  filteredInstrumentsStartingFromFullList
                ];
              ]
            ];

            (* Fill out our new grouping with our primitive information. *)
            AppendTo[currentPrimitiveGrouping, resolvedPrimitive];
            AppendTo[currentUnresolvedPrimitiveGrouping, Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]];
            AppendTo[currentPrimitiveInputGrouping, inputsWithNoSimulatedObjects];
            (* If we are in a subprotocol, export all resolved options to RSP here in currentPrimitiveOptionGrouping (and then in allPrimitiveOptionGroupings) for our final script. *)
            (* We do not do this for stand-alone user-submitted script so that it matches the exact input from the user and we do not need the generated labels (described below) anywhere else *)
            (* This is necessary for subprotocol script when it is used as the sample prep for PreparatoryUnitOperations. *)
            (* When the PrepUOs are calculated for an experiment, we generate necessary automatic labels in our resolved options. The automatic labels are unique across the entire UOs (script) *)
            (* For example, we may have RSP-MSP-RSP UOs as part of the script and each does 2 transfers. Then our labels will be like "transfer destination sample 1" & "2" in first RSP UO, "3" & "4" in MSP UO and "5" & "6" in the last RSP UO *)
            (* If the corresponding labels are used in the main experiment, they show up in the PreparedSamples field of the protocol *)
            (* For example, we may have "myPlate" as the experiment input and "myPlate" has a transferred sample in the PrepUOs with an automatic label "transfer destination sample 6". The PreparedSamples field will list it as {"transfer destination sample 6", SamplesIn, 1, Null, Null} *)
            (* Here, the plate label "myPlate" is specified by the user but its content sample's label "transfer destination sample 6" is generated automatically by Transfer *)
            (* When the script is generated, it becomes 3 separate protocols (RSP-MSP-RSP), if the resolved labels are not feeded into the script, it has no memory of the previous labels when each individual SP protocol is generated. *)
            (* We must make sure the SAME labels are used in the real experiment protocols so we can associate the main experiment's PreparedSamples with the sample prep protocol *)
            If[MatchQ[parentProtocol,ObjectP[]],
              AppendTo[currentPrimitiveOptionGrouping, resolvedOptionsWithNoSimulatedObjects],
              AppendTo[currentPrimitiveOptionGrouping, optionsWithNoSimulatedObjects]
            ];
            AppendTo[currentPrimitiveGroupingRunTimes, runTimeEstimate];
            currentPrimitiveGroupingAmbientPlateResources=Join[currentPrimitiveGroupingAmbientPlateResources, ambientPlateResources];
            currentPrimitiveGroupingIncubatorPlateResources=Join[currentPrimitiveGroupingIncubatorPlateResources, incubatorPlateResources];
            currentPrimitiveGroupingWorkCellIdlingConditionHistory=Join[currentPrimitiveGroupingWorkCellIdlingConditionHistory, workCellIdlingConditions];
            currentPrimitiveGroupingFootprints=Join[currentPrimitiveGroupingFootprints, newFootprintResultNoDuplicates];
            currentPrimitiveGroupingTips=Join[currentPrimitiveGroupingTips, tipResourceBlobs];
            currentPrimitiveGroupingIntegratedInstrumentsResources=Join[currentPrimitiveGroupingIntegratedInstrumentsResources, instrumentResourceBlobs];
            currentPrimitiveGroupingLabeledObjects=Join[currentPrimitiveGroupingLabeledObjects, newLabeledObjectsLookup];
            currentPrimitiveGroupingUnitOperationPackets=Append[currentPrimitiveGroupingUnitOperationPackets, unitOperationPackets];
            currentPrimitiveGroupingBatchedUnitOperationPackets=Append[currentPrimitiveGroupingBatchedUnitOperationPackets, batchedUnitOperationPackets];

            (* Add our primitive index. *)
            currentLabelFieldsWithIndices=Join[
              currentLabelFieldsWithIndices,
              (#[[1]]->LabelField[#[[2]], index]&)/@newLabelFields
            ];

            (* Are we supposed to optimize our robotic keep covered? *)
            If[MatchQ[optimizeUnitOperations, True] && index>1 && !MatchQ[coverOptimizedPrimitives[[index-1]], _Cover],
              Module[{containerPackets, keepCoveredContainers, filteredKeepCoveredContainers},
                (* See if we have any Object[Container]s from this latest unit operation packet that have KeepCovered->True. *)
                containerPackets=Cases[resourceCache, PacketP[Object[Container]]];
                keepCoveredContainers=Cases[
                  containerPackets,
                  KeyValuePattern[{
                    KeepCovered->True,
                    Cover->Null
                  }]
                ];

                (* Make sure that these containers can be covered with the universal lid. *)
                filteredKeepCoveredContainers=PickList[
                  keepCoveredContainers,
                  (fetchPacketFromCache[Lookup[#, Model], resourceCache]&)/@keepCoveredContainers,
                  KeyValuePattern[{CoverFootprints->{___, LidSBSUniversal, ___}, CoverTypes->{___, Place, ___}}]
                ];

                (* Convert any simulated objects to their labels. *)
                If[Length[filteredKeepCoveredContainers]>0,
                  coverOptimizedPrimitives=Insert[
                    coverOptimizedPrimitives,
                    Cover[Sample->Lookup[filteredKeepCoveredContainers, Object]/.simulatedObjectsToLabel, Preparation->Robotic],
                    index+1
                  ]
                ];
              ]
            ];
          ]
      ];

      (* Return our resolved primitive. *)
      AppendTo[resolvedPrimitives, resolvedPrimitive];

      (* If we're at the end of our list of primitives, make sure to clean up our current primitive group. *)
      If[index==Length[coverOptimizedPrimitives],
        startNewPrimitiveGrouping[True];
      ];

      (* Increment our index. *)
      index=index+1;
    ]
  ];

  (* Resolving is over. End our unique label session. *)
  (* In cases where a unit operation uses other unit ops inside it (Ex. MBS creates Transfer unit ops) we don't want to *)
  (* reset the label session because then duplicate labels will be created *)
  If[!unitOperationPacketsQ,
    EndUniqueLabelsSession[];
  ];

  (* get all the tips resources *)
  tipResources = Select[Flatten[nonObjectResources], MatchQ[#[Sample], ObjectP[Model[Item, Tips]]] && IntegerQ[#[Amount]]&];
  counterWeightResources = Select[Flatten[nonObjectResources], MatchQ[#[Sample], ObjectP[Model[Item, Counterweight]]]&];
  nonTipResources = DeleteCases[Flatten[nonObjectResources], Alternatives @@ tipResources];

  (* combine the tip resources together, but only up to 96 at a time  *)
  gatheredTipResources = GatherBy[tipResources, #[Sample]&];
  combinedTipResources = Map[
    Function[{resources},
      Module[{resourceSample, tipAmount, partitionedTipAmount},

        resourceSample = resources[[1]][Sample];
        tipAmount = Total[Cases[#[Amount]& /@ resources, _Integer]];
        partitionedTipAmount = Flatten[{
          ConstantArray[96, Quotient[tipAmount, 96]],
          Mod[tipAmount, 96]
        }];

        Map[
          Resource[
            Sample -> resourceSample,
            Amount -> #,
            Name -> ToString[Unique[]]
          ]&,
          partitionedTipAmount
        ]
      ]
    ],
    gatheredTipResources
  ];

  (* combine the counter weight resources together, one per model only *)
  (* this is valid on robotic because the robotic centrifuges only have two positions, meaning that only 1 counterweight is needed at a time *)
  (* centrifuge resources are created in Centrifuge UOs and only created for robotic UOs *)
  uniqueCounterweightResources=Map[
    (#->Resource[Sample->#,Name->CreateUUID[]])&,
    DeleteDuplicates[Download[Lookup[counterWeightResources[[All,1]],Sample,{}],Object]]
  ];
  combinedCounterWeightResources=Download[Lookup[counterWeightResources[[All,1]],Sample,{}],Object]/.uniqueCounterweightResources;
  counterWeightResourceReplacementRules=Normal[AssociationThread[counterWeightResources,combinedCounterWeightResources]];

  (* call FRQ on all the accumulated resource blobs that we've gathered in the MapThread *)
  (* if UnitOperationPackets -> True, then we aren't calling FRQ because the function that called it will do it instead *)
  {accumulatedFulfillableResourceQ, accumulatedFRQTests} = Which[
    MatchQ[$ECLApplication, Engine] || unitOperationPacketsQ, {<||>, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[Flatten[{nonTipResources, combinedTipResources, combinedCounterWeightResources}], Simulation->simulation, Output -> {Result, Tests}],
    True, {Resources`Private`fulfillableResourceQ[Flatten[{nonTipResources, combinedTipResources, combinedCounterWeightResources}], Simulation->simulation], {}}
  ];

  (* Throw errors that we discovered during the MapThread. *)
  If[Length[allOverwrittenLabelsWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::OverwrittenLabels, allOverwrittenLabelsWithIndices[[All,1]], allOverwrittenLabelsWithIndices[[All,2]], shortenPrimitives[allOverwrittenLabelsWithIndices[[All,3]]]],
      Message[Error::OverwrittenLabels, allOverwrittenLabelsWithIndices[[All,1]], allOverwrittenLabelsWithIndices[[All,2]], allOverwrittenLabelsWithIndices[[All,3]]]
    ];
  ];

  If[Length[invalidLabelPrimitivesWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::UnknownLabels, invalidLabelPrimitivesWithIndices[[All,1]], invalidLabelPrimitivesWithIndices[[All,2]], shortenPrimitives[invalidLabelPrimitivesWithIndices[[All,3]]]],
      Message[Error::UnknownLabels, invalidLabelPrimitivesWithIndices[[All,1]], invalidLabelPrimitivesWithIndices[[All,2]], invalidLabelPrimitivesWithIndices[[All,3]]]
    ];
  ];

  If[Length[invalidAutofillPrimitivesWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::UnableToAutofillUnitOperation, shortenPrimitives[invalidAutofillPrimitivesWithIndices[[All,1]]], invalidAutofillPrimitivesWithIndices[[All,2]]],
      Message[Error::UnableToAutofillUnitOperation, invalidAutofillPrimitivesWithIndices[[All,1]], invalidAutofillPrimitivesWithIndices[[All,2]]]
    ];
  ];

  If[Length[invalidResolvePrimitiveMethodsWithIndices]>0,
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::NoAvailableUnitOperationMethods, shortenPrimitives[invalidResolvePrimitiveMethodsWithIndices[[All,1]]], invalidResolvePrimitiveMethodsWithIndices[[All,2]]],
      Message[Error::NoAvailableUnitOperationMethods, invalidResolvePrimitiveMethodsWithIndices[[All,1]], invalidResolvePrimitiveMethodsWithIndices[[All,2]]]
    ];
  ];

  (* If we have plate reader primitives, find other places where injector samples are used outside of the injector sample fields. *)
  invalidInjectorResourcesWithIndices=Join@@MapThread[
    computeInvalidInjectionSampleResources,
    {allPrimitiveGroupings, allPrimitiveGroupingUnitOperationPackets}
  ];

  If[Length[invalidInjectorResourcesWithIndices]>0,
    Message[Error::InjectionSamplesUsedElsewhere, ObjectToString[invalidInjectorResourcesWithIndices[[All,1]]], invalidInjectorResourcesWithIndices[[All,2]]];
  ];

  (* If we encountered FRQ problems, return $Failed. *)
  If[MatchQ[fulfillableQ, False] || MatchQ[accumulatedFulfillableResourceQ, False],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> {
        Flatten@{
          safeOpsTests,
          templateTests,
          frqTests,
          accumulatedFRQTests
        },
        Sequence@@allResolverTests
      },
      Options -> $Failed,
      Preview -> Null,
      Input -> myPrimitives
    }];
  ];

  (* Keep track of our invalid inputs. *)
  invalidInputIndices=DeleteDuplicates[Flatten[{
    invalidResolvePrimitiveMethodsWithIndices[[All,2]],
    invalidAutofillPrimitivesWithIndices[[All,2]],
    invalidLabelPrimitivesWithIndices[[All,2]],
    noInstrumentsPossibleErrorsWithIndices[[All,2]],
    invalidResolverPrimitives,
    allOverwrittenLabelsWithIndices[[All,2]],
    invalidInjectorResourcesWithIndices[[All,2]],
    incompatibleWorkCellAndMethod
  }]];

  (* if we are supposed to return unit operation packets, then do that here *)
  (* NOTE: Even if we have invalid inputs, we have to return our packets here because experiments that call us are expecting *)
  (* that. *)
  If[TrueQ[unitOperationPacketsQ],
    If[Length[invalidInputIndices]>0 && Not[gatherTests],
      If[MatchQ[$ShortenErrorMessages, True],
        Message[Error::InvalidInput, shortenPrimitives[coverOptimizedPrimitives[[invalidInputIndices]]]],
        Message[Error::InvalidInput, coverOptimizedPrimitives[[invalidInputIndices]]]
      ];
    ];

    (* Return the run time too. If we are here, we are called by a Robotic compatible function that generates sub RoboticUnitOperations.*)
    (* ExperimentRoboticSamplePreparation or ExperimentRoboticCellPreparation has been called directly and we can do time estimate based on the sub UOs. We should be guaranteed to have only one group *)
    totalWorkCellTime=Max[{
      1Minute,
      Total[ToList[Replace[First[allPrimitiveGroupingRunTimes],{Except[TimeP]->0Minute}, {1}]]]
    }];

    Return[outputSpecification/.{
      Result-> {Flatten[allPrimitiveGroupingUnitOperationPackets],totalWorkCellTime},
      Tests->If[gatherTests,
        {
          Flatten@{
            safeOpsTests,
            templateTests,
            frqTests,
            accumulatedFRQTests
          },
          Sequence@@allResolverTests
        },
        Null
      ],
      Simulation->currentSimulation,
      Input->Null
    }]
  ];

  (* -- STAGE 6: Creating Upload Packets -- *)
  If[debug, Echo["Beginning stage 6: creating upload packets"]];

  (* Helper function to pass down post-processing options. *)
  postProcessingOption[myOptionSymbol_, myUnresolvedOptions_List, myUserSpecifiedMethodGroupOptions_List, myGlobalOptions_]:=Which[
    KeyExistsQ[myUnresolvedOptions, myOptionSymbol] && !MatchQ[Lookup[myUnresolvedOptions, myOptionSymbol], Automatic],
      Nothing,
    KeyExistsQ[myUserSpecifiedMethodGroupOptions, myOptionSymbol] && !MatchQ[Lookup[myUnresolvedOptions, myOptionSymbol], Automatic],
      myOptionSymbol->Lookup[myUnresolvedOptions, myOptionSymbol],
    KeyExistsQ[myGlobalOptions, myOptionSymbol] && !MatchQ[Lookup[myGlobalOptions, myOptionSymbol], Automatic],
      myOptionSymbol->Lookup[myGlobalOptions, myOptionSymbol],
    True,
      Nothing
  ];

  (* Resolve any options that we have for this function that aren't automatic. *)
  resolvedOptions=If[MatchQ[FirstOrDefault[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]]], ObjectP[]],
    ReplaceRule[safeOps,
      {
        Instrument->FirstOrDefault[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]]],
        If[MemberQ[safeOps[[All,1]], CoverAtEnd],
          CoverAtEnd->coverAtEnd,
          Nothing
        ]
      }
    ],
    safeOps
  ];

  (* Helper function to compute the labeled and future labeled objects. *)

  (* NOTE: Some of our LabeledObjects can't be resolved at ResourcePicking time because some of the objects are *)
  (* either not referencable using the current Resource system, or the objects will only exist at Parse time. The *)
  (* framework will detect these labels that refer to resources with simulated objects and put them in *)
  (* FutureLabeledObjects if there is not another valid resource that can be used to resolve the label at RP time. *)

  (* Example 1:
    "source sample label"->Resource[Sample->Model[Sample, "Milli-Q water"], Container->Model[Container, Vessel, "2mL Tube"]]
    "source container label"->Object[Container, Vessel, "simulated 2mL Tube"]
  *)

  (* Example 2:
    "destination container label"->Model[Container, Vessel, "2mL Tube"]
    "destination sample label"->Object[Sample, "simulated sample in 2mL Tube that will only exist after parse"]
  *)

  (* NOTE: In Manual, we get unit operation packets back from the resolver function when calling LabelSample/Container. Other than *)
  (* LabelSample/Container, we do NOT get resources from the resolver functions so myLabeledObjects will be empty. *)
  (* NOTE: This function is called using Flatten[allPrimitiveGroupingResources]. *)
  computeLabeledObjectsAndFutureLabeledObjects[myLabeledObjects:{_Rule...}, options:OptionsPattern[]]:=Module[
    {
      nonExistentContainersAndSamples, nonSimulatedLabeledObjectResourceLookup, simulatedLabeledObjectResourceLookup,
      simulatedContainerLabeledObjectResourceLookup, simulatedSampleLabeledObjectResourceLookup, labeledObjectLabelFieldLookup,
      filteredSimulatedLabeledObjectResourceLookup, simulatedContainerPackets, simulatedSamplePackets,
      simulatedSampleContainerPackets, simulatedContainerLabels, simulatedSampleLabels, futureLabeledObjects,
      allSimulationLabelLookup,sortedLabeledObjects,sortedFutureLabeledObjects,existentContainersAndSamples,
      nonSimulatedLabeledObjectLinkLookup
    },

    (* OVERVIEW: We categorize our labeled objects into four categories: *)
    (* 1A) We get Resources for them (from Replace[LabeledObjects] in the unit operation packet returned) and the resource *)
    (* does NOT point to a simulated object. We put this into LabeledObjects at the protocol level. *)
    (* 1B) We don't have a resource for the label, but the object that the label points to is not simulated. Note that this *)
    (* happens when we are doing manual unit operations and don't get resources (unlike in robotic). *)
    (* The above two cases should always be the first since they are REAL objects and nothing need to be done in the protocol to get them *)
    (* 2) We get Resources for them (from Replace[LabeledObjects] in the unit operation packet returned) and the resource *)
    (* DOES point to a simulated object. This has to go into FutureLabeledObjects. *)
    (* The resources are fulfilled in resource picking and can be poulated directly. This should go after the real objects. *)
    (* 3) We get a LabelField, telling us how to download the resolved object from the subprotocol field after it's finished. *)
    (* LabelField should go next because these fields are populated directly in the protocols. Once the subprotocol (manual) or the unit operation (robotic) is completed, the fields are directly available *)
    (* 4) We find the simulated object in the Labels field from our simulation. *)
    (* Dereferencing from other labeled objects last to avoid creating sample lable <-> container label loops *)
    (* We favor 1), 2), 3), 4) -- in that order. *)

    (* First, try to get the labels that have simulated Resources associated with them. *)
    {nonExistentContainersAndSamples, existentContainersAndSamples}=Module[
      {allResourceContainerAndSampleObjects, allLabelContainerAndSampleObjects, allContainerAndSampleObjects, allContainerAndSampleObjectsSimulatedQ},

      (* NOTE: Some of our Resources will point to simulated samples. This is because the samples may not exist in the *)
      (* {Container, Well} syntax of the LabelSample primitive. We will detect these later and fill them out in the parser. *)
      allResourceContainerAndSampleObjects=DeleteDuplicates@Cases[
        myLabeledObjects[[All,2]],
        ObjectReferenceP[{Object[Sample], Object[Container]}],
        Infinity
      ];
      (* NOTE: Some of our Labels in the Simulation[...] will also not exist. *)
      allLabelContainerAndSampleObjects=DeleteDuplicates@Cases[
        Lookup[currentSimulation[[1]], Labels][[All,2]],
        ObjectReferenceP[{Object[Sample], Object[Container]}],
        Infinity
      ];

      allContainerAndSampleObjects=DeleteDuplicates[Join[allResourceContainerAndSampleObjects, allLabelContainerAndSampleObjects]];

      allContainerAndSampleObjectsSimulatedQ=If[MatchQ[$CurrentSimulation, SimulationP],
        Module[{allSimulatedObjectsUOOnly},
          allSimulatedObjectsUOOnly=DeleteCases[Lookup[currentSimulation[[1]], SimulatedObjects], Alternatives @@ Lookup[$CurrentSimulation[[1]], SimulatedObjects]];

          (* The variable namespace here is confusing and hard to deconvolute but worth explaining: *)
          (* 1.) allObjectsInSimulation are all the Labeled objects inside of the currentSimulation (i.e., the simulation that came out of the options resolvers) *)
          (* 2.) allSimulatedObjectsUOOnly are the SimulatedObjects that exist in the currentSimulation, but NOT in $CurrentSimulation *)
          (* The reason we want this is because if it's in $CurrentSimulation, then we are in the global simulation space and the objects were put there by Upload.  For all intents and purposes, those are "real" objects, and not ones we need to replace with labels.*)
          (* 3.) Thus, the MemberQ will only return True if the objects are labeled by currentSimulation and NOT in $CurrentSimulation*)
          (MemberQ[allSimulatedObjectsUOOnly, #]&)/@allContainerAndSampleObjects
        ],
        (MemberQ[Lookup[currentSimulation[[1]], SimulatedObjects], #]&)/@allContainerAndSampleObjects
      ];

      {
        PickList[
          allContainerAndSampleObjects,
          allContainerAndSampleObjectsSimulatedQ,
          True
        ],
        PickList[
          allContainerAndSampleObjects,
          allContainerAndSampleObjectsSimulatedQ,
          False
        ]
      }
    ];

    (* This gives us 1A) (non-simulation dependent resources) and almost 3) (simulation dependent resources, before filtering). *)
    {nonSimulatedLabeledObjectResourceLookup, simulatedLabeledObjectResourceLookup}=Module[{uniqueLabeledObjectResourceLookup,labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects,nonSimulatedLookup},
      (* Merge any duplicate labels that we have. We might have a real resource for the first primitive that actually *)
      (* needs to pick that sample/container and then resources for a simulated sample/container in subsequent primitives. *)
      uniqueLabeledObjectResourceLookup=Normal@Merge[
        myLabeledObjects,
        (* NOTE: Try to find the first resource that doesn't include a simulated object, if we can't find any, then *)
        (* just pick the first one. *)
        (FirstCase[#, _?(!MemberQ[#, Alternatives@@nonExistentContainersAndSamples, Infinity]&), #[[1]]]&)
      ];

      (* Our labeling system is such that multiple labels can be attached to a single sample/container. Make sure that if *)
      (* there are multiple labels being assigned to a single sample/container, we pick the resource that points to a non simulated *)
      (* sample/container if possible. *)
      (* NOTE: This is because after we simulate a model->object, if we label the same sample/container again, it'll make a resource *)
      (* for the simulated sample/container when we want to point to the real model. *)
      labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects=Flatten@Map[
        Function[{labeledObjectList},
          (* Do we have multiple labels that point to the same object and is that object simulated? *)
          If[Length[labeledObjectList]>1 && MemberQ[labeledObjectList, Alternatives@@nonExistentContainersAndSamples, Infinity],
            Module[{realResource},
              (* Get the first resource that don't contain nonExistantContainersAndSamples. *)
              realResource=FirstCase[
                Lookup[uniqueLabeledObjectResourceLookup, labeledObjectList[[All,1]]],
                _?(!MemberQ[#, Alternatives@@nonExistentContainersAndSamples, Infinity]&),
                Null
              ];

              (* If we didn't find anything, don't touch things. *)
              If[MatchQ[realResource, Null],
                (#->Lookup[uniqueLabeledObjectResourceLookup, #]&)/@labeledObjectList[[All,1]],
                (#->realResource&)/@labeledObjectList[[All,1]]
              ]
            ],
            (* No, just use the regular value we previously had. *)
            (#->Lookup[uniqueLabeledObjectResourceLookup, #]&)/@labeledObjectList[[All,1]]
          ]
        ],
        (* Group our labeled object lookup by labels that point to the same object. *)
        Values[GroupBy[Cases[Lookup[currentSimulation[[1]], Labels], Verbatim[Rule][Alternatives@@myLabeledObjects[[All,1]], _]], (#[[2]] &)]]
      ];

      nonSimulatedLookup=Select[
        labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects,
        (!MemberQ[#[[2]], Alternatives@@nonExistentContainersAndSamples, Infinity]&)
      ];

      {
        nonSimulatedLookup,
        UnsortedComplement[labeledObjectResourceLookupWithoutFutureSimulatedDuplicateObjects, nonSimulatedLookup]
      }
    ];

    (* Get the objects that are in allLabeledObjects that already exist and aren't in 1A) (we don't have resources for these). This happens *)
    (* when we have manual methods. *)
    (* NOTE: Don't include non simulated objects for which we have labels for. *)
    nonSimulatedLabeledObjectLinkLookup=(#[[1]]->Link[#[[2]]]&)/@Cases[
      Lookup[currentSimulation[[1]], Labels],
      Verbatim[Rule][Except[Alternatives@@(nonSimulatedLabeledObjectResourceLookup[[All,1]])], Alternatives@@existentContainersAndSamples]
    ];

    (* This will give us 2). *)
    filteredSimulatedLabeledObjectResourceLookup=Cases[
      simulatedLabeledObjectResourceLookup,
      Verbatim[Rule][
        Except[Alternatives@@(Flatten[{nonSimulatedLabeledObjectResourceLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]]}])],
        _
      ]
    ];

    (* For the labeled objects that still point to simulated objects, break them into the ones that point *)
    (* to simulated samples and the ones that point to simulated containers. We SHOULDN'T have any other simulated *)
    (* types other than those that can't be resolved at RP time. *)
    simulatedContainerLabeledObjectResourceLookup=Cases[
      filteredSimulatedLabeledObjectResourceLookup,
      Verbatim[Rule][_, Resource[KeyValuePattern[{Sample->ObjectReferenceP[Object[Container]]}]]]
    ];
    simulatedSampleLabeledObjectResourceLookup=UnsortedComplement[filteredSimulatedLabeledObjectResourceLookup, simulatedContainerLabeledObjectResourceLookup];

    (* Find the labels for which we have LabelFields for. Exclude labels for which we've already found non-simulated *)
    (* resources for via 1) and 2). This will give us 3). *)
    (* NOTE: Don't include LabelFields here that just have _String in them. This is useless information if we couldn't *)
    (* previously find a resource that went along with the label. *)
    (* allLabelFieldsWithIndicesGroupings is in the correct order of manipulation index since we always AppendTo the new UO group to the end. *)
    labeledObjectLabelFieldLookup=Cases[
      Flatten[allLabelFieldsWithIndicesGroupings],
      Verbatim[Rule][
        Except[Alternatives@@(Join[nonSimulatedLabeledObjectResourceLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]], filteredSimulatedLabeledObjectResourceLookup[[All,1]]])],
        Verbatim[LabelField][Except[_String], _]
      ]
    ];

    (* Get the labels from our simulation that are simulated AND do not show up in our resource list/label fields already. *)
    (* This is excluding 1), 2), and 3). This will give us 4). *)
    allSimulationLabelLookup=Cases[
      Lookup[currentSimulation[[1]], Labels],
      Verbatim[Rule][
        Except[Alternatives@@(Flatten[{nonSimulatedLabeledObjectResourceLookup[[All,1]], labeledObjectLabelFieldLookup[[All,1]], nonSimulatedLabeledObjectLinkLookup[[All,1]], filteredSimulatedLabeledObjectResourceLookup[[All,1]]}])],
        _
      ]
    ];

    (* Now we have to download information for 2) and 4) in order to put them into proper FutureLabeledObjects form. *)
    (* For the containers, get the contents and try to relate that to a non-simulated label. *)
    (* For the samples, get the container and try to relate that to a non-simulated label. *)
    {simulatedContainerPackets, simulatedSamplePackets, simulatedSampleContainerPackets, simulatedContainerLabels, simulatedSampleLabels}=Module[
      {sampleSimulationLabelLookup, containerSimulationLabelLookup, allSimulatedSamples, allSimulatedContainers},

      (* Separate 4) into containers and samples. *)
      sampleSimulationLabelLookup=Cases[allSimulationLabelLookup, Verbatim[Rule][_, ObjectReferenceP[Object[Sample]]]];
      containerSimulationLabelLookup=Cases[allSimulationLabelLookup, Verbatim[Rule][_, ObjectReferenceP[Object[Container]]]];

      (* Get all simulated containers and samples. *)
      allSimulatedSamples=Flatten[{
        (Lookup[#[[1]], Sample]&)/@simulatedSampleLabeledObjectResourceLookup[[All,2]],
        sampleSimulationLabelLookup[[All,2]]
      }];
      allSimulatedContainers=Flatten[{
        (Lookup[#[[1]], Sample]&)/@simulatedContainerLabeledObjectResourceLookup[[All,2]],
        containerSimulationLabelLookup[[All,2]]
      }];

      {
        Sequence@@(Flatten/@Download[
          {
            allSimulatedContainers,
            allSimulatedSamples,
            allSimulatedSamples
          },
          {
            {Packet[Object, Contents]},
            {Packet[Object, Container]},
            {Packet[Container[Contents]]}
          },
          Simulation->currentSimulation
        ]
        ),
        Flatten[{simulatedContainerLabeledObjectResourceLookup[[All,1]], containerSimulationLabelLookup[[All,1]]}],
        Flatten[{simulatedSampleLabeledObjectResourceLookup[[All,1]], sampleSimulationLabelLookup[[All,1]]}]
      }
    ];

    (* Convert these simulated containers and samples into the expected FutureLabeledObjects field format. *)
    futureLabeledObjects=Module[
      {
        containerFutureLabeledObjects, sampleFutureLabeledObjects,validContainerFutureLabeledObjects,validSampleFutureLabeledObjects,
        noContainerFutureLabeledObjects,noContainerLabelFutureLabeledObjectsLookup
      },

      (* Relate each container to its non-simulated sample label. *)
      containerFutureLabeledObjects=MapThread[
        Function[{containerPacket, containerLabel},
          Module[{samplesInContainer},
            (* Get the sample objects that are in this container. *)
            samplesInContainer=Download[Lookup[containerPacket, Contents][[All,2]], Object];

            (* "Future Label"->{"Existing Label","Relation to Existing Label's Object"} *)
            containerLabel->{
              FirstCase[
                Lookup[currentSimulation[[1]], Labels],
                Verbatim[Rule][sampleLabel_String, Alternatives@@samplesInContainer]:>sampleLabel,
                Null
              ],
              Container
            }
          ]
        ],
        {
          simulatedContainerPackets,
          simulatedContainerLabels
        }
      ];

      (* Relate each container to its non-simulated sample label. *)
      sampleFutureLabeledObjects=MapThread[
        Function[{samplePacket, sampleContainerPacket, sampleLabel},
          Module[{container},
            (* Get the container of the simulated sample. *)
            container=Download[Lookup[samplePacket, Container], Object];

            (* "Future Label"->{"Existing Label","Relation to Existing Label's Object"} *)
            sampleLabel->{
              FirstCase[
                Lookup[currentSimulation[[1]], Labels],
                Verbatim[Rule][containerLabel_String, container]:>containerLabel,
                Null
              ],
              FirstCase[
                Lookup[sampleContainerPacket, Contents],
                {position_String, LinkP[Download[Lookup[samplePacket, Object], Object]]}:>position,
                Null
              ]
            }
          ]
        ],
        {simulatedSamplePackets, simulatedSampleContainerPackets, simulatedSampleLabels}
      ];

      (* remove cases of resolved "label"->{Null,XX} since they are not valid *)
      validSampleFutureLabeledObjects=DeleteCases[sampleFutureLabeledObjects,Rule[_,{Null,_}]];
      validContainerFutureLabeledObjects=DeleteCases[containerFutureLabeledObjects,Rule[_,{Null,_}]];

      (* in a rare case that we have a "sample label" but not "container label", pull in the LabelField[] for that "sample label" *)
      noContainerFutureLabeledObjects = Cases[Join[sampleFutureLabeledObjects,containerFutureLabeledObjects],Verbatim[Rule][_,{Null,_}]][[All,1]];
      noContainerLabelFutureLabeledObjectsLookup = Cases[
        Flatten[allLabelFieldsWithIndicesGroupings],
        Verbatim[Rule][
          Alternatives@@noContainerFutureLabeledObjects,
          (* we restrict the pattern here in case of an unknown failure mode upstream, we should _only_ have proper LabelField[] here *)
          Verbatim[LabelField][Except[_String], _]
        ]
      ];

      (* Return our information. *)
      Join[validContainerFutureLabeledObjects, validSampleFutureLabeledObjects, labeledObjectLabelFieldLookup, noContainerLabelFutureLabeledObjectsLookup]
    ];

    (* Sort our LabeledObjects and FutureLabeledObjects to show up in the order that they show up in the Simulation's *)
    (* Label key. *)
    sortedLabeledObjects=SortBy[
      Join[List@@@nonSimulatedLabeledObjectResourceLookup, List@@@nonSimulatedLabeledObjectLinkLookup],
      (FirstOrDefault@Flatten@FirstPosition[Lookup[currentSimulation[[1]], Labels][[All,1]], #[[1]], {Infinity}]&)
    ];

    sortedFutureLabeledObjects=SortBy[
      futureLabeledObjects,
      (FirstOrDefault@Flatten@FirstPosition[Lookup[currentSimulation[[1]], Labels][[All,1]], #[[1]], {Infinity}]&)
    ];

    (* Return LabeledObjects for RP-time and FutureLabeledObjects. *)
    {
      sortedLabeledObjects,
      sortedFutureLabeledObjects
    }
  ];

  (* For each primitive grouping, figure out the label fields that should be used. *)
  labelFieldGroupings=MapThread[
    Function[{index, method},
      Flatten[allLabelFieldsWithIndicesGroupings[[1;;index-1]]]
    ],
    {
      Range[Length[allPrimitiveGroupings]],
      (Lookup[#[[1]][[1]], PrimitiveMethod]&)/@allPrimitiveGroupings
    }
  ];

  (* Compute our primitives with label fields. *)
  (* NOTE: We have to do this outside of the MapThread because inside of the MapThread we are still determining what *)
  (* primitives go with each grouping. We only want to use LabelFields to replace labels from previous groupings *)
  (* since labels within our own grouping will be replace by the SP function itself. *)
  {allUnresolvedPrimitivesWithLabelFieldGroupings, allPrimitiveInputsWithLabelFieldsGroupings, allPrimitiveOptionsWithLabelFieldsGroupings}=If[Length[invalidInputIndices]>0,
    {{},{},{}},
    Transpose@MapThread[
      Function[{labelFieldLookup, unresolvedPrimitiveGrouping, inputGrouping, optionGrouping},
        Transpose@MapThread[
          Function[{unresolvedPrimitive, inputs, options},
            Module[{primitiveInformation, primitiveOptionDefinitions, primitiveInputsWithLabelFields, primitiveOptionsWithLabelFields},
              (* Lookup primitive information. *)
              primitiveInformation=Lookup[allPrimitiveInformation, Head[unresolvedPrimitive]];
              primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

              (* For each option in our primitive, replace any labels with their label fields. *)
              (* If we find an invalid label (that hasn't been intialized yet), keep track of it. *)
              {primitiveInputsWithLabelFields, primitiveOptionsWithLabelFields}=(KeyValueMap[
                Function[{option, value},
                  Module[{optionDefinition},
                    (* Lookup information about this option. *)
                    optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                    (* Do does this option allow for PreparedSample or PreparedContainer? *)
                    Which[
                      MatchQ[optionDefinition, Null],
                      (* We don't know about this option. *)
                      Nothing,
                      (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                      (* Cases will only look inside of lists, not associations. *)
                      Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                      (* Nothing to replace. *)
                      option->value,
                      True,
                      (* We may potentially have some labels. *)
                      Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                        (* Match the value of our option to the widget that we have. *)
                        (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                        matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                        (* Look for matched object widgets that have labels. *)
                        (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                        (* to separate legit strings from objects that were turned into strings. *)
                        objectWidgetsWithLabels=Cases[matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                        (* This will give us our labels. *)
                        labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                        (* Replace any other labels that we have with their values from our simulation. *)
                        option-> (
                          value /. (#1 -> Lookup[labelFieldLookup, #1]&) /@ Intersection[labelsInOption, labelFieldLookup[[All,1]]]
                        )
                      ]
                    ]
                  ]
                ],
                Association@#
              ]&)/@{Rule@@@Transpose[{Lookup[primitiveInformation, InputOptions], inputs}], options};

              {
                Head[unresolvedPrimitive]@@Join[primitiveInputsWithLabelFields, primitiveOptionsWithLabelFields],
                primitiveInputsWithLabelFields[[All,2]],
                primitiveOptionsWithLabelFields
              }
            ]
          ],
          {unresolvedPrimitiveGrouping, inputGrouping, optionGrouping}
        ]
      ],
      {
        labelFieldGroupings,
        allUnresolvedPrimitiveGroupings,
        allPrimitiveInputGroupings,
        allPrimitiveOptionGroupings
      }
    ]
  ];

  (* Keep track of the primitive index to assignment variable that we're putting in the script. *)
  primitiveIndexToScriptVariableLookup={};
  primitiveIndexToOutputUnitOperationLookup={};

  (* We should create a script if we have more than one primitive grouping that needs to be executed. *)
  outputResult=Which[
    (* We had invalid inputs and should not create any packets. *)
    Length[invalidInputIndices]>0,
      $Failed,

    (* Create a script that will link these all primitive groups together. *)
    And[
      MatchQ[myFunction, ScriptGeneratingPrimitiveFunctionP],
      Length[allPrimitiveGroupings]>1
    ],
      Module[
        {heldScriptCells, heldCompoundExpression, uploadPackets},

        (* Go through our grouped primitives and create script cells. *)
        heldScriptCells=Flatten[
          MapThread[
            Function[{resolvedPrimitiveGroup, unresolvedPrimitiveGroup, instrument, indexGroup},
              Module[{workCellFunction, newVariableName, heldVariableAssignment, specialHoldHead, specialHoldHead2, allLabelFields, allDownloadSyntax,allLabeledObjects,allLabeledObjectsWithNames,allLabeledObjectsJoined,restrictSamplesCommand},
                (* Figure out what ExperimentBLAH[...] function to call for our group of primitives. *)
                workCellFunction=If[MatchQ[instrument, Null],
                  ExperimentManualSamplePreparation,
                  ToExpression["Experiment"<>ToString@Lookup[First[resolvedPrimitiveGroup][[1]], PrimitiveMethod]]
                ];

                (* Figure out what to call this next variable. *)
                newVariableName=ToExpression[
                  "Global`my"<>ToString[workCellFunction]<>"Protocol"<>ToString[First[indexGroup]],
                  InputForm,
                  Hold
                ];

                (* Setup our hold heads. *)
                SetAttributes[specialHoldHead, HoldAll];
                SetAttributes[specialHoldHead2, HoldAll];

                (* Append this variable name to our index to variable name lookup. *)
                (* NOTE: The variables names in this lookup are all held in case they're already defined. *)

                (* NOTE: We use this lookup when we need to get to the OutputUnitOperation first before we download the resulting field. *)
                primitiveIndexToOutputUnitOperationLookup=Join[
                  primitiveIndexToOutputUnitOperationLookup,
                  (With[{insertMe=#},
                    #->holdCompositionList[Sequence,{newVariableName, Hold[OutputUnitOperations[[insertMe]]]}]
                  ]&)/@indexGroup
                ];

                (* This is just the held variable name. *)
                primitiveIndexToScriptVariableLookup=Join[primitiveIndexToScriptVariableLookup, (#->newVariableName&)/@indexGroup];

                (* Put these primitives into the correct format, within a hold. *)
                heldVariableAssignment=If[MatchQ[workCellFunction, ExperimentManualSamplePreparation],
                  With[{insertMe1=newVariableName, insertMe2=workCellFunction, insertMe3=unresolvedPrimitiveGroup, insertMe5=parentProtocol},
                    holdCompositionList[Set, {insertMe1, Hold[insertMe2[insertMe3, ParentProtocol -> insertMe5]]}]
                  ],
                  With[{insertMe1=newVariableName, insertMe2=workCellFunction, insertMe3=unresolvedPrimitiveGroup, insertMe4=instrument, insertMe5=parentProtocol},
                    holdCompositionList[Set, {insertMe1, Hold[insertMe2[insertMe3, Instrument->insertMe4, ParentProtocol -> insertMe5]]}]
                  ]
                ];

                (* Get all label fields out and create the corresponding download syntax. *)
                (* NOTE: We can't do the regular replace rule here because we need to do more complicated holding. *)
                allLabelFields=Cases[heldVariableAssignment, _LabelField, Infinity];
                allDownloadSyntax=(
                  If[MatchQ[#,LabelField[_String,_]],
                    (* NOTE: This becomes LookupLabeledObject[variableName, label]. *)
                    With[{insertMe1=Lookup[primitiveIndexToScriptVariableLookup, #[[2]]], insertMe2=#[[1]]},
                      Append[insertMe1, insertMe2]/.{Hold->specialHoldHead2}
                    ],
                    (* NOTE: This becomes Download[Download[variableName, OutputUnitOperation[[#]]], labelField]. *)
                    With[{insertMe1=Lookup[primitiveIndexToOutputUnitOperationLookup, #[[2]]], insertMe2=#[[1]]},
                      Hold[insertMe1, insertMe2]/.{Hold->specialHoldHead}
                    ]
                  ]
                &)/@allLabelFields;

                (* Set the labeled samples to Restricted *)
                (* Get the LabeledObjects field. This is in the form of {{"Label",Object[xxx]}...} *)
                allLabeledObjectsWithNames=Map[
                  With[{insertMe1=#},
                    Append[insertMe1,LabeledObjects]/.{Hold->specialHoldHead}
                  ]&,
                  DeleteDuplicates[primitiveIndexToScriptVariableLookup[[All,2]]]
                ];

                (* Get [[All,2]] of the LabeledObjects field. This is for only the objects *)
                allLabeledObjects=Map[
                  With[{insertMe1=#},
                    holdCompositionList[Part,{Hold[insertMe1],Hold[All],Hold[2]}]
                  ]&,
                  allLabeledObjectsWithNames
                ];

                allLabeledObjectsJoined=holdCompositionList[Join,allLabeledObjects];

                (* Restrict our samples *)
                (* Note that we are repeating this for the samples we already restricted earlier. This is to make sure the newly generated samples are also getting restricted too. For example, we picked a contianer earlier and did a Transfer of ss, we want the Object[Sample] to be restricted too so the sample is not picked up by another protocol. User can still refer to this container in later part of the script *)
                (* We only do this if we are not at the very last script cell. If we are at the last, we unrestict everything instead *)
                restrictSamplesCommand=If[!MatchQ[indexGroup,Last[Unflatten[Range[Length[Flatten[allPrimitiveGroupings]]], allPrimitiveGroupings]]],
                  With[{insertMe1=allLabeledObjectsJoined},
                    holdComposition[RestrictLabeledSamples,insertMe1]
                  ],
                  With[{insertMe1=allLabeledObjectsJoined},
                    holdComposition[UnrestrictLabeledSamples,insertMe1]
                    ]
                ];

                (* Convert any LabelField[...] syntax that we have to instead be downloads from our assigned variables. *)
                ReplaceAll[
                  {heldVariableAssignment,restrictSamplesCommand},
                  MapThread[#1->#2&,{allLabelFields,allDownloadSyntax}]
                ]/.{specialHoldHead->Download, specialHoldHead2->LookupLabeledObject}
              ]
            ],
            {
              allPrimitiveGroupings,
              allUnresolvedPrimitivesWithLabelFieldGroupings,
              FirstOrDefault/@allPrimitiveGroupingWorkCellInstruments,
              Unflatten[Range[Length[Flatten[allPrimitiveGroupings]]], allPrimitiveGroupings]
            }
          ]
        ];

        (* First, we need to go from {Hold[Set[...]], Hold[Set[...]]} to Hold[CompoundExpression[Set[...], Set[...]]]. *)
        heldCompoundExpression=With[{insertMe=heldScriptCells},
          holdCompositionList[CompoundExpression, insertMe]
        ];

        (* lookup if we need to add IgnoreWarnings to the script that we are generating - if users wish to Ignore them, we should let them *)
        ignoreWarnings = Lookup[safeOps, IgnoreWarnings];

        (* Then, put this into a script call. *)
        (* If we were told to Upload->False, append that before releasing the hold. *)
        uploadPackets=If[MatchQ[Lookup[safeOps, Upload], False] || !MemberQ[output, Result],
          With[{insertMe=Fold[Append,heldCompoundExpression, {Upload->False, ParentProtocol -> parentProtocol, IgnoreWarnings->ignoreWarnings,TimeConstraint->2 Hour, Autogenerated -> True}]},
            ECL`ExperimentScript@@insertMe
          ],
          With[{insertMe = Fold[Append,heldCompoundExpression, {ParentProtocol -> parentProtocol,IgnoreWarnings->ignoreWarnings,TimeConstraint->2 Hour, Autogenerated -> True}]},
            ECL`ExperimentScript@@insertMe
          ]
        ];

        uploadPackets
      ],

    (* Throw an error. Only the Experiment/ExperimentSamplePreparation[...] function can generate scripts. *)
    Length[allPrimitiveGroupings]>1,
      Module[{},
        Message[Error::InvalidMultipleUnitOperationGroups, Length[allPrimitiveGroupings], Map[Head,allPrimitiveGroupings,{2}], (Lookup[First[#][[1]], PrimitiveMethod]&)/@allPrimitiveGroupings];

        $Failed
      ],

    (* BELOW THIS LINE WE ARE GUARANTEED TO HAVE ONE PRIMITIVE GROUPING ONLY. *)

    (* We have one ManualSamplePreparation/ManualCellPreparation group. *)
    (* Create an Object[Protocol, ManualSamplePreparation/ManualCellPreparation]. *)
    Or[
      MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentManualCellPreparation],
      And[
        MatchQ[myFunction, Experiment|ExperimentSamplePreparation],
        MatchQ[Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod], ManualSamplePreparation|ManualCellPreparation]
      ],
      And[
        MatchQ[myFunction, ExperimentCellPreparation],
        MatchQ[Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod], ManualCellPreparation]
      ]
    ],
      Module[
        {protocolAndPrimitiveType, protocolPacket, labeledObjects, futureLabeledObjects, primitiveMethodIndex,
          userSpecifiedMethodGroupOptions, inputUnitOperationPackets, optimizedUnitOperationPackets, calculatedUnitOperationPackets,
          supplementaryPackets, outputUnitOperationsMinusResolvedOptions, outputUnitOperationPackets,
          primGroupingsWithLabels, outputUnitOperationPacketsWithLabelSampleAndContainer,simulatedObjectsToLabel},

        (* Depending on what function we're in, either make a ManualSamplePreparation or ManualCellPreparation protocol. *)
        protocolAndPrimitiveType=Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod];

        (* Get the options that the user gave us. *)
        primitiveMethodIndex=Lookup[First[allPrimitiveGroupings][[1]][[1]], PrimitiveMethodIndex];
        userSpecifiedMethodGroupOptions=If[!MatchQ[primitiveMethodIndex, _Integer],
          {},
          Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex]
        ];

        (* Get our labeled objects for the Object[Protocol] level. *)
        {labeledObjects, futureLabeledObjects}=computeLabeledObjectsAndFutureLabeledObjects[Flatten[allPrimitiveGroupingResources]];

        (* Convert our unit operation primitives into unit operation objects. *)
        inputUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@flattenedIndexMatchingPrimitives,
          UnitOperationType->Input,
          Preparation->Manual,
          FastTrack->True,
          Upload->False
        ];

        optimizedUnitOperationPackets = UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ coverOptimizedPrimitives,
          UnitOperationType -> Optimized,
          Preparation -> Manual,
          FastTrack -> True,
          Upload -> False
        ];

        (* Create a map to convert any simulated objects back to their labels. *)
        simulatedObjectsToLabel = Module[{allObjectsInSimulation, simulatedQ},
          (* Get all objects out of our simulation. *)
          allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

          (Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
        ];

        primGroupingsWithLabels = First[allPrimitiveGroupings]/.simulatedObjectsToLabel;

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        calculatedUnitOperationPackets = UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ primGroupingsWithLabels,
          UnitOperationType -> Calculated,
          Preparation -> Manual,
          Upload -> False
        ];

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        outputUnitOperationsMinusResolvedOptions = UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&) /@ primGroupingsWithLabels,
          UnitOperationType -> Output,
          Preparation -> Manual,
          Upload -> False
        ];

        (* note that we need to add these back in because UploadUnitOperation doesn't put them in the field directly even if they're in the input *)
        outputUnitOperationPackets = MapThread[
          Join[
            #1,
            <|
              UnresolvedUnitOperationOptions -> #2[UnresolvedUnitOperationOptions],
              ResolvedUnitOperationOptions -> #2[ResolvedUnitOperationOptions]
            |>
          ]&,
          {outputUnitOperationsMinusResolvedOptions, primGroupingsWithLabels}
        ];

        (* NOTE: Our LabelSample/LabelContainer unit operation packets in manual are already made and have resources inside *)
        (* of them. For all other indices, we should have Null since we will not have asked for Output->Result from the Experiment *)
        (* function -- with the exception of LabelSample/LabelContainer. *)
        (* The only thing we would like to change from the output result of LabelSample/LabelContainer is that we want to make sure we are using the correct NEW unit operation ID. If a user runs the same command multiple times without clearing Memoization, we are not calling the LabelSample/LabelContainer resolver again. That means, the packet in allPrimitiveGroupingUnitOperationPackets has an existing Object[UnitOperation,LabelSample/LabelContainer] that may have been uploaded before. We should not use it again to cause multiple protocols sharing the same UO. *)
        (* We basically can combine the newly created UO ID from outputUnitOperationPackets, with the packets with resources from LabelContainer/LabelSample UO in allPrimitiveGroupingUnitOperationPackets *)
        outputUnitOperationPacketsWithLabelSampleAndContainer=MapThread[
          If[MatchQ[#2, PacketP[]], Join[#2,KeyTake[#1,Object]], #1]&,
          {outputUnitOperationPackets, Flatten[(If[MatchQ[#, {}], Null, #]&)/@First[allPrimitiveGroupingUnitOperationPackets]]}
        ];

        (* Gather all up of our auxilliary packets. *)
        supplementaryPackets=Cases[
          Join[
            inputUnitOperationPackets,
            optimizedUnitOperationPackets,
            calculatedUnitOperationPackets,
            outputUnitOperationPacketsWithLabelSampleAndContainer
          ],
          Except[Null]
        ];

        (* Create our protocol packet. *)
        protocolPacket=<|
          Object->CreateID[Object[Protocol, protocolAndPrimitiveType]],

          Replace[InputUnitOperations]->(Link[#, Protocol]&)/@Lookup[inputUnitOperationPackets, Object],
          Replace[OptimizedUnitOperations]->(Link[#, Protocol]&)/@Lookup[optimizedUnitOperationPackets, Object],
          Replace[CalculatedUnitOperations]->(Link[#, Protocol]&)/@Lookup[calculatedUnitOperationPackets, Object],
          Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[outputUnitOperationPacketsWithLabelSampleAndContainer, Object],

          (* NOTE: Resolved starts off the same as Unresolved and we update it inside of the loop. *)
          Module[{unresolvedUnitOperationInputs},
            unresolvedUnitOperationInputs=Map[
              Function[{unresolvedInputs},
                If[Length[unresolvedInputs]==1,
                  First[unresolvedInputs]/.{obj:ObjectP[]:>Download[obj, Object]},
                  unresolvedInputs/.{obj:ObjectP[]:>Download[obj, Object]}
                ]
              ],
              First[allPrimitiveInputsWithLabelFieldsGroupings]
            ];

            Sequence@@{
              Replace[UnresolvedUnitOperationInputs]->unresolvedUnitOperationInputs,
              Replace[ResolvedUnitOperationInputs]->unresolvedUnitOperationInputs
            }
          ],

          Module[{unresolvedUnitOperationOptions},
            unresolvedUnitOperationOptions=MapThread[
              Function[{unresolvedPrimitive, unresolvedOptions},
                (* If we're dealing with LabelSample, LabelContainer, or Wait, fill out special other fields in the object so that we'll *)
                (* do the picking. *)
                If[MatchQ[Head[unresolvedPrimitive], LabelSample|LabelContainer|Wait],
                  unresolvedOptions/.{obj:ObjectP[]:>Download[obj, Object]},
                  Join[
                    unresolvedOptions,
                    (* NOTE: These post-processing options only apply to ManualSamplePreparation. *)
                    If[MatchQ[protocolAndPrimitiveType, ManualSamplePreparation],
                      {
                        (* If the user has specific post-processing options to the primitive already, use those. *)
                        (* If the user has specific post-processing options as part of our method group use that. *)
                        (* If the user has specified them to the function itself (as SafeOptions), use that. *)
                        (* Otherwise, let the specific experiment function resolve the options. *)
                        postProcessingOption[MeasureWeight, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps],
                        postProcessingOption[ImageSample, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps],
                        postProcessingOption[MeasureVolume, unresolvedOptions, userSpecifiedMethodGroupOptions, safeOps]
                      },
                      {}
                    ]
                  ]/.{obj:ObjectP[]:>Download[obj, Object]}
                ]
              ],
              {
                First[allUnresolvedPrimitiveGroupings],
                First[allPrimitiveOptionsWithLabelFieldsGroupings]
              }
            ];

            Sequence@@{
              Replace[UnresolvedUnitOperationOptions]->unresolvedUnitOperationOptions,
              Replace[ResolvedUnitOperationOptions]->unresolvedUnitOperationOptions
            }
          ],

          Replace[LabeledObjects]->labeledObjects,
          Replace[FutureLabeledObjects]->futureLabeledObjects,

          ResolvedOptions->safeOps,

          Replace[Checkpoints]->{
            {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.", Null},
            {
              If[MatchQ[protocolAndPrimitiveType, ManualSamplePreparation],
                "Sample Preparation",
                "Cell Preparation"
              ],
              0 Minute,
              "The given unit operations are executed, in the order in which they are specified.",
              Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->0 Minute]
            },
            {"Returning Materials",15 Minute,"Samples are returned to storage.",Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15 Minute]}
          },

          MeasureWeight->Lookup[safeOps,MeasureWeight,True],
          MeasureVolume->Lookup[safeOps,MeasureVolume,True],
          ImageSample->Lookup[safeOps,ImageSample,True],

          Replace[PreparedResources]->Link[Lookup[safeOps,PreparedResources,Null],Preparation]
        |>;

        (* Upload if asked to. *)
        Which[
          !MemberQ[output, Result],
            Null,
          True,
            ECL`InternalUpload`UploadProtocol[
              protocolPacket,
              supplementaryPackets,
              Upload->Lookup[safeOps,Upload],
              Confirm->Lookup[safeOps,Confirm],
              ParentProtocol->Lookup[safeOps,ParentProtocol],
              Priority->Lookup[safeOps,Priority],
              StartDate->Lookup[safeOps,StartDate],
              HoldOrder->Lookup[safeOps,HoldOrder],
              QueuePosition->Lookup[safeOps,QueuePosition],
              ConstellationMessage->{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]},
              Simulation->currentSimulation
            ]
        ]
      ],

    (* We have one work cell group. Create a work cell protocol object. *)
    True,
      Module[
        {
          protocolType, allTipResources, tipRackResources, protocolPacket, tareContainers, labeledObjects, futureLabeledObjects, uniqueInstrumentResources, instrumentResourcesWithUpdatedTimeEstimate, cellContainerLinkResources, nonCellContainerLinkResources,
          livingCellContainerLinkResources, userSpecifiedOptions, primitiveMethodIndex, primitiveMethod, inputUnitOperationPackets, optimizedUnitOperationPackets,
          calculatedUnitOperationPackets, supplementaryPackets, skipTareFunction, samplesIn, containersIn, tipResourceReplacementRules,
          outputUnitOperationPackets, subOutputUnitOperationPackets, requiredObjects, plateReaderFields, simulatedObjectsToLabel,
          allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources, instrumentResourceReplaceRules, overclockQ, supplementaryPacketsMinusRootProtocol,
          overclockingPacket,
          allTransferUnitOperations, tipAdapter, tipAdapterResourceReplacementRule, tipAdapterResource, magnetizationRackResourceReplacementRules, modelSampleResourceReplacementRules
        },

        (* Depending on what function we're in, either make a ManualSamplePreparation or ManualCellPreparation protocol. *)
        protocolType=Lookup[First[Flatten[allPrimitiveGroupings]][[1]], PrimitiveMethod];

        (* figure out if we are using a tip adapter in any of the Transfer UOs in the group *)
        allTransferUnitOperations = Flatten@PickList[First[allPrimitiveGroupingUnitOperationPackets],MatchQ[_Transfer]/@First[allPrimitiveGroupings]];
        tipAdapter = If[Length[allTransferUnitOperations]==0, Null,
          FirstCase[Lookup[allTransferUnitOperations, TipAdapter], _Resource, Null]
        ];

        (* Get our labeled objects for the Object[Protocol] level. *)
        {labeledObjects, futureLabeledObjects}=computeLabeledObjectsAndFutureLabeledObjects[Flatten[allPrimitiveGroupingResources]];

        (* Compute our tip placements and tip resource replacement rules. *)
        (* NOTE: We have to perform tip resource replacement for each of our calculated unit operations (with tip resources inside) *)
        (* because each of our unit operations is making tip resources individually but the framework will group them together *)
        (* into combined resources. *)
        {allTipResources, tipRackResources, tipResourceReplacementRules} = Module[
          {flattenedStackedTipTuples, flattenedNonStackedTipTuples, stackedTipResources, nonStackedTipResources},

          (* Figure out the number of stacked and non-stacked tips that we're going to have in the form of *)
          (* {{ObjectP[Model[Item, Tip]], tipCountRequired_Integer}..} *)
          {flattenedStackedTipTuples, flattenedNonStackedTipTuples}=partitionTips[tipModelPackets, First[allPrimitiveGroupingTips], First[allPrimitiveGroupings]];

          (* Make resources for our stacked and non-stacked tip tuples. *)
          stackedTipResources=(Resource[Sample->#[[1]], Amount->#[[2]], UpdateCount -> False, Name->CreateUUID[]]&)/@flattenedStackedTipTuples;
          nonStackedTipResources=(Resource[Sample->#[[1]], Amount->#[[2]], UpdateCount -> False, Name->CreateUUID[]]&)/@flattenedNonStackedTipTuples;

          (* Return placement tuples in form {{tip object, {positions..}}..} *)
          {
            Join[
              stackedTipResources,
              nonStackedTipResources
            ],
            (* We only ask for tip racks if we're going onto the bioSTAR/microbioSTAR. *)
            (* On the regular STARs, the plan is to have the operator grab the entire blister pack of tips *)
            (* and move that to the liquid handler, load the tips from that, then put the blister pack back in the VLM. *)
            (* On the bioSTAR/microbioSTAR, the plan is to have the operator grab the entire blister pack to tips and a tip box, *)
            (* move to the BSC, then load in the tips sterile. *)
            (* NOTE that this isn't how it works right now, for the bioSTAR, we load in tips directly, but this is the plan. *)
            If[MatchQ[myFunction, ExperimentCellPreparation|ExperimentRoboticCellPreparation],
              With[{length = If[NullQ[tipAdapter], Length[nonStackedTipResources], Length[nonStackedTipResources]+1]},
                Table[
                  Resource[
                    Sample->Model[Container,Rack,"id:7X104vn9E4nZ"],
                    Name->CreateUUID[]
                  ],
                  length]
              ],
              {}
            ], (* Model[Container, Rack, "Sterile Hamilton Tip Box"] *)
            (* NOTE: This isn't entirely accurate because if we have multiple racks of tips of the same model, it'll be replaced *)
            (* with the first resource instance -- instead of tracking with the exact Object[Item, Tip]s that were used. *)
            (Resource[KeyValuePattern[Sample->(ObjectReferenceP[Lookup[#[[1]], Sample]]|LinkP[Lookup[#[[1]], Sample]])]] -> #&)/@Join[stackedTipResources, nonStackedTipResources]
          }
        ];

        (* Combine the sample resources *)
        (* This includes two different cases: *)
        (* 1) Multiple resources of the same Model[Sample] and their total volume still fit in the same container's MaxVolume. We can create one resource and request the total volume *)
        (* 2) Multiple resources require the same incubation parameters and same container model. We can share the same container model but put the resources into different wells *)
        (* This part is the same as what we did for footprint check in UO resolver *)
        modelSampleResourceReplacementRules=Module[
          {modelSampleResources,modelSampleResourcesToCombine,resourceCache,accumulatedResourceTuples,modelSampleResourcesWithContainerNames},
          modelSampleResources=Cases[
            allPrimitiveGroupingUnitOperationPackets,
            Resource[KeyValuePattern[{Type->Object[Resource,Sample],Sample->ObjectP[Model[Sample]],Amount->VolumeP,Container->ListableP[ObjectP[Model[Container]]],ConsolidateTransferResources->True}]],
            Infinity
          ];
          modelSampleResourcesToCombine=Select[
            modelSampleResources,
            !KeyExistsQ[#[[1]],ContainerName]&
          ];
          (* Download some information about the container models to make a smaller cache for future lookup *)
          resourceCache=Flatten@Quiet[
            Download[
              DeleteDuplicates@Flatten[Lookup[modelSampleResourcesToCombine[[All,1]],Container,{}]],
              Packet[Positions,MaxVolume,MinVolume],
              Simulation->currentSimulation,
              Cache->cacheBall
            ],
            {Download::FieldDoesntExist, Download::NotLinkField}
          ];

          (* Track the processed resource blobs *)
          accumulatedResourceTuples={};
          modelSampleResourcesWithContainerNames=Map[
            Function[
              {resourceBlob},
              Module[
                {containerModels,containerModelPacket,containerMaxVolume,containerPositions,sampleModel,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,accumulatedResourceTuplesMatchingContainerModels,existingSampleModelResourceTuples,existingContainerModelResourceTuples,containerNameVolumeTuples,containerNamePositionTuples,updatedContainerModels,containerName,well,newResourceTuple,updatedAccumulatedResourceTuples},
                (* Get all the possible models *)
                containerModels=ToList[Download[Lookup[resourceBlob[[1]],Container],Object]];
                (* Get the model of the sample *)
                sampleModel=Download[Lookup[resourceBlob[[1]],Sample],Object];
                (* Get the incubation parameters (this has to match for the resources to consolidate or group *)
                sourceTemperature=Lookup[resourceBlob[[1]],SourceTemperature,Null];
                sourceEquilibrationTime=Lookup[resourceBlob[[1]],SourceEquilibrationTime,Null];
                maxSourceEquilibrationTime=Lookup[resourceBlob[[1]],MaxSourceEquilibrationTime,Null];
                volume=Lookup[resourceBlob[[1]],Amount];

                (* Get the accumulated resources with at least one matching container model *)
                accumulatedResourceTuplesMatchingContainerModels=Select[
                  accumulatedResourceTuples,
                  IntersectingQ[#[[2]],containerModels]&
                ];

                (* Get the existing resources with the same model and container model. See if we can fit the new volume into the same resource *)
                existingSampleModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{sampleModel,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];
                (* Get the existing resources with the same container model and incubation parameters see if it has more position for new resource *)
                existingContainerModelResourceTuples=Cases[accumulatedResourceTuplesMatchingContainerModels,{_,_,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,_,_,_}];

                (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                (* Group the existing resource tuples by ContainerName and Well. If we consolidate some of the previous resources, we have assigned the same well and will need to add the volumes together *)
                containerNameVolumeTuples=Map[
                  Function[
                    {resourceTupleGroup},
                    Module[
                      {totalVolume,commonContainers,containerModelPackets,containerMaxVolumes,containerMinVolumes,sourceContainerDeadVolumes,qualifiedContainers},
                      totalVolume=Total[Flatten[{resourceTupleGroup[[All,-3]],volume}]];
                      commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                      containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                      containerMaxVolumes=Lookup[containerModelPackets,MaxVolume,Null];
                      containerMinVolumes=Lookup[containerModelPackets,MinVolume,Null];
                      (* Get the dead volume of the container *)
                      (* use the MinVolume of the container as the required dead volume. If not available, use 10% of max volume *)
                      sourceContainerDeadVolumes=MapThread[
                        If[!NullQ[#2],
                          #2,
                          0.1 * #1
                        ]&,
                        {containerMaxVolumes,containerMinVolumes}
                      ];

                      (* Select the large enough container model(s) *)
                      qualifiedContainers=MapThread[
                        If[TrueQ[(totalVolume+#3)<#2],
                          #1,
                          Nothing
                        ]&,
                        {commonContainers,containerMaxVolumes,sourceContainerDeadVolumes}
                      ];

                      If[Length[qualifiedContainers]==0,
                        (* Do no track if the volume is too large for all models *)
                        Nothing,
                        (* Track the total volume, updated container models and containerName/well tuple  *)
                        {totalVolume,qualifiedContainers,resourceTupleGroup[[1,-2]],resourceTupleGroup[[1,-1]]}
                      ]
                    ]
                  ],
                  GatherBy[existingSampleModelResourceTuples,(#[[-2;;-1]])&]
                ];

                containerNamePositionTuples=Map[
                  Function[
                    {resourceTupleGroup},
                    Module[
                      {commonContainers,containerModelPackets,containerPositions,occupiedPositions,qualifiedContainers,emptyPosition},
                      commonContainers=UnsortedIntersection[containerModels,resourceTupleGroup[[1,2]]];
                      containerModelPackets=fetchPacketFromCache[#,resourceCache]&/@commonContainers;
                      containerPositions=Lookup[containerModelPackets,Positions,{}];

                      (* Get the positions occupied *)
                      occupiedPositions=DeleteDuplicates[resourceTupleGroup[[All,-1]]];

                      (* Select the large enough container model(s) and track container model and first open position *)
                      qualifiedContainers=MapThread[
                        If[MatchQ[Complement[Lookup[#2,Name,{}],occupiedPositions],{}],
                          Nothing,
                          {#1,Sort@Complement[Lookup[#2,Name,{}],occupiedPositions]}
                        ]&,
                        {commonContainers,containerPositions}
                      ];

                      (* We always fill resource containers in sorted order so select the common empty position of all container models to use *)
                      emptyPosition=If[Length[qualifiedContainers]>0,
                        First[Intersection@@(qualifiedContainers[[All,2]])],
                        Null
                      ];

                      If[Length[qualifiedContainers]==0,
                        (* Do no track if the volume is too large for all models *)
                        Nothing,
                        (* Track the first open position, updated container models and containerName/well tuple  *)
                        {qualifiedContainers[[All,1]],emptyPosition,resourceTupleGroup[[1,-2]]}
                      ]
                    ]
                  ],
                  GatherBy[existingContainerModelResourceTuples,(#[[-2]])&]
                ];

                (* Select the existing resource position to consolidate or create a new one *)
                {updatedContainerModels,containerName,well}=Which[
                  Length[containerNameVolumeTuples]>0,
                  (* Select the resource position that prepares largest volume to get the best efficiency for resouce consolidation *)
                  ReverseSortBy[containerNameVolumeTuples,First][[1,2;;4]],
                  Length[containerNamePositionTuples]>0,
                  (* Use the first possible position *)
                  {containerNamePositionTuples[[1,1]],containerNamePositionTuples[[1,3]],containerNamePositionTuples[[1,2]]},
                  True,
                  (* Use a UUID and "A1" position for new resource *)
                  {containerModels,CreateUUID[],"A1"}
                ];

                (* create the new resource tuple to be tracked and also return the updated *)
                newResourceTuple={sampleModel,updatedContainerModels,sourceTemperature,sourceEquilibrationTime,maxSourceEquilibrationTime,volume,containerName,well};

                (* Update the accumulated resource tuple list to reflect updated containerModels for the same containerName *)
                updatedAccumulatedResourceTuples=ReplacePart[
                  accumulatedResourceTuples,
                  ({#,2}->updatedContainerModels)&/@Flatten[Position[accumulatedResourceTuples,{___,containerName,_}]]
                ];

                accumulatedResourceTuples=Append[updatedAccumulatedResourceTuples,newResourceTuple];
                {resourceBlob,updatedContainerModels,containerName,well}
              ]
            ],
            DeleteDuplicates[modelSampleResourcesToCombine]
          ];

          (* Group modelSampleResourcesWithContainerNames by ContainerName and Well so we can create resources to update *)
          Flatten@Map[
            Function[
              {resourceTuples},
              Module[
                {resourceBlobs,containerModel,containerName,well,containerModelPacket,containerMaxVolume,containerMinVolume,sourceContainerDeadVolume,totalVolume,newResource},
                resourceBlobs=resourceTuples[[All,1]];
                (* Use the first container model as the model since we are going to use this to determine dead volume *)
                (* Have to use the last resource's model list because we may have deleted some models as we go on and we don't go back to update the models of previous handled resource *)
                containerModel=First[resourceTuples[[-1,2]]];
                containerName=resourceTuples[[1,3]];
                well=resourceTuples[[1,4]];

                (* Get the dead volume of the container *)
                containerModelPacket=fetchPacketFromCache[containerModel,resourceCache];
                containerMaxVolume=Lookup[containerModelPacket,MaxVolume,Null];
                containerMinVolume=Lookup[containerModelPacket,MinVolume,Null];
                sourceContainerDeadVolume=Which[
                  NullQ[containerMinVolume]&&NullQ[containerMaxVolume],
                  0Microliter,
                  NullQ[containerMinVolume],
                  0.1*containerMaxVolume,
                  True,
                  containerMinVolume
                ];

                (* Add total resource volume with dead volume *)
                totalVolume=Total[Lookup[resourceBlobs[[All,1]],Amount]]+sourceContainerDeadVolume;
                newResource=Resource[
                  Join[
                    resourceTuples[[1,1,1]],
                    <|
                      Amount->totalVolume,
                      Name->CreateUUID[],
                      Container->containerModel,
                      ContainerName->containerName,
                      Well->well
                    |>
                  ]
                ];
                (#->newResource)&/@resourceBlobs
              ]
            ],
            (* Group the resources with same container name and well *)
            GatherBy[modelSampleResourcesWithContainerNames,(#[[3;;4]])&]
          ]
        ];

        (* Compute MagnetizationRack resource replacement rules. Similar to tips, we want all magnetization rack  *)
        (* resources to be replaced with the same resource because the same magnetization rack is used for every uo that needs it *)
        magnetizationRackResourceReplacementRules = Module[{magnetizationRackResources,uniqueMagnetizationRacks},
          magnetizationRackResources = Cases[allPrimitiveGroupingUnitOperationPackets,KeyValuePattern[Sample -> LinkP[Model[Item, MagnetizationRack]]|ObjectReferenceP[Model[Item, MagnetizationRack]]],Infinity];
          uniqueMagnetizationRacks = DeleteDuplicates[Lookup[#,Sample]&/@magnetizationRackResources];
          (Resource[KeyValuePattern[Sample->(ObjectP[#])]] -> Resource[Sample->#, Name -> CreateUUID[]]&)/@uniqueMagnetizationRacks
        ];

        (* Determine if we want to get the tare weight for an object *)
        skipTareFunction[containerResource_, cache_]:=Module[{containerObject,containerPacket,containerModelPacket,containerModelsToNotTareWeigh},
          (* Get the container object. *)
          containerObject=Lookup[containerResource[[1]], Sample];

          (* Get the packet. *)
          {containerPacket,containerModelPacket}=If[MatchQ[containerObject,ObjectP[Model[Container]]],
            {<||>,fetchPacketFromCache[containerObject,cache]},
            Module[{packet,model,modelPacket},
              packet = fetchPacketFromCache[containerObject,cache];
              model = Lookup[packet,Model,Null];
              modelPacket = fetchPacketFromCache[model,cache];
              {packet,modelPacket}
            ]
          ];

          containerModelsToNotTareWeigh={
            (* Phytip columns -- we throw these out at the end so there's no point in tare weighing. *)
            Model[Container, Vessel, "id:zGj91a7nlzM6"]
          };

          Or[
            (* It's impossible to tare this container -- note that this matches the logic in MeasureWeight. *)
            !MatchQ[Lookup[containerModelPacket, Object], ObjectP[MeasureWeightModelContainerTypes]],
            MatchQ[Lookup[containerModelPacket,Immobile,Null],True],
            MatchQ[Lookup[containerModelPacket,Ampoule,Null],True],
            Length[Lookup[containerPacket,Contents,{}]]!=0,

            (* Or we just don't want to tare weight this container. *)
            MatchQ[Lookup[containerPacket,TareWeight,Null],MassP],
            MatchQ[Lookup[containerModelPacket,Object,Null],ObjectReferenceP[containerModelsToNotTareWeigh]]
          ]
        ];

        (* Get our containers that we need to tare. *)
        tareContainers=If[MatchQ[Lookup[resolvedOptions, TareWeighContainers], False],
          {},
          Module[{containerResources, containerCache},
            (* Get all of the container resources. We only care about containers because if we already have a sample *)
            (* in it, we cannot get a tare weight. We are looking for empty containers. *)
            (* NOTE: Lookup from LabeledObjects because these objects will exist immediately after resource picking. *)
            containerResources=Cases[
              labeledObjects[[All,2]],
              Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]
            ];

            (* Make sure that we have all of the cache information. *)
            containerCache=Flatten@Download[
              {
                Cases[containerResources, ObjectP[Object[Container]], Infinity],
                Cases[containerResources, ObjectP[Model[Container]], Infinity]
              },
              {
                {Packet[TareWeight, Model, Contents], Packet[Model[{Immobile, Object}]]},
                {Packet[Immobile, Object]}
              },
              Cache->cacheBall,
              Simulation->currentSimulation
            ];

            PickList[containerResources, (skipTareFunction[#, containerCache]&)/@containerResources, False]
          ]
        ];

        (* When dealing with cell samples, we do NOT want to post-process them after the robotic protocol is complete. *)
        (* This is because post-processing will take too long and kill the cells. We therefore store container resources *)
        (* that will have cells in them in a separate field so that we don't pass them down to the post-processing *)
        (* subprotocols. Also determine whether a container contains Living cells. *)
        {cellContainerLinkResources, livingCellContainerLinkResources, nonCellContainerLinkResources}=If[MatchQ[protocolType,RoboticCellPreparation],
          Module[
            {simulatedObjects, containerResult, simulatedContainers, labeledContainers, containerResources,
              sampleResult, simulatedSamples, sampleObjects, sampleResources, containerContentPackets,
              containerIncludesCellsQ, nonCellContainerResources,cellContainerResources, sampleContainsCellsQ,
              containerIncludesLivingCellsQ, sampleContainsLivingCellsQ, nonCellSampleResources, cellSampleResources, livingCellContainerResources},

            (* Get the objects that correspond to our labels. *)
            (* NOTE: Lookup from LabeledObjects because these objects will exist immediately after resource picking. *)
            simulatedObjects=(Lookup[Lookup[currentSimulation[[1]], Labels],#]&)/@labeledObjects[[All,1]];

            (* Partition labeled objects into containers and samples. *)
            containerResult=PickList[labeledObjects, simulatedObjects, ObjectP[Object[Container]]];
            simulatedContainers=Cases[simulatedObjects, ObjectP[Object[Container]]];
            {labeledContainers, containerResources}=If[Length[containerResult]==0,
              {{},{}},
              Transpose[containerResult]
            ];

            sampleResult=PickList[labeledObjects, simulatedObjects, ObjectP[Object[Sample]]];
            simulatedSamples=Cases[simulatedObjects, ObjectP[Object[Sample]]];
            {sampleObjects, sampleResources}=If[Length[sampleResult]==0,
              {{},{}},
              Transpose[sampleResult]
            ];

            (* Download information from our simulated objects. *)
            (* NOTE: We are downloading from the very last simulation here so this will reflect the contents of the *)
            (* containers after all manipulations on the robot are completed. *)
            {samplePackets, containerContentPackets}=Quiet[
              Download[
                {
                  simulatedSamples,
                  simulatedContainers
                },
                {
                  {Packet[CellType]},
                  {Packet[Contents[[All,2]][{CellType, Living}]]}
                },
                Cache->cacheBall,
                Simulation->currentSimulation
              ],
              {Download::NotLinkField}
            ];
            samplePackets=Flatten@samplePackets;
            containerContentPackets=Flatten/@containerContentPackets;

            (* Determine which containers/samples contain cells. *)
            containerIncludesCellsQ=(MemberQ[Lookup[#, CellType, Null], Except[Null]]&)/@containerContentPackets;
            sampleContainsCellsQ=(MatchQ[Lookup[#, CellType], CellTypeP]&)/@samplePackets;

            (* Determine which containers contain Living cells. *)
            containerIncludesLivingCellsQ=(MemberQ[Lookup[#, Living, Null], True]&)/@containerContentPackets;

            (* Pick containers/samples that will not have cell samples in them, and those that will have living cells. *)
            nonCellContainerResources=PickList[containerResources, containerIncludesCellsQ, False];
            cellContainerResources=PickList[containerResources, containerIncludesCellsQ];
            livingCellContainerResources=PickList[containerResources, containerIncludesLivingCellsQ];

            nonCellSampleResources=PickList[sampleResources, sampleContainsCellsQ, False];
            cellSampleResources=PickList[sampleResources, sampleContainsCellsQ];

            (* Return the value accordingly *)
            {Join[cellContainerResources, cellSampleResources], livingCellContainerResources, Join[nonCellContainerResources, nonCellSampleResources]}
          ],
          {{},{},labeledObjects[[All,2]]}
        ];

        (* ASSUME that each primitive knows how many instrument models will be available on deck. Right now the only *)
        (* primitive that can use multiple of the same Model[Instrument] at the same time is the Incubate/Mix primitive *)
        (* and since every liquid handler as exactly 4 incubate positions on deck, this is hard coded into the Incubate/Mix *)
        (* primitive when it resolves its Batches option. *)
        (* Therefore, we only make 1 request for each Model[Instrument] on/off deck. *)
        uniqueInstrumentResources=DeleteDuplicatesBy[
          Flatten[allPrimitiveGroupingIntegratedInstrumentResources],
          (Download[Lookup[#[[1]], Instrument], Object]&)
        ];

        (* Replace each instrument resource with the entire length of time that it'll take to complete the entire run *)
        (* since we can't release the integrations mid-run. *)
        totalWorkCellTime=Max[{
          1 Minute,
          Total[ToList[Replace[First[allPrimitiveGroupingRunTimes],{Except[TimeP]->0 Minute},{1}]]]
        }];

        instrumentResourcesWithUpdatedTimeEstimate=(
          Resource[
            Instrument->Lookup[#[[1]], Instrument],
            Name->CreateUUID[],
            Time->totalWorkCellTime
          ]
        &)/@uniqueInstrumentResources;

        (* Create instrument resource replace rules to replace instrument resources inside of the output unit operations. *)
        instrumentResourceReplaceRules=(
          Verbatim[Resource][KeyValuePattern[Instrument->ObjectP[Lookup[#[[1]], Instrument]]]]->#
        &)/@instrumentResourcesWithUpdatedTimeEstimate;

        (* Figure out what primitive method we're dealing with for this group. *)
        primitiveMethod=Lookup[Flatten[allPrimitiveGroupings][[1]][[1]], PrimitiveMethod];
        primitiveMethodIndex=Lookup[Flatten[allPrimitiveGroupings][[1]][[1]], PrimitiveMethodIndex];

        (* Get the options that the user gave us. *)
        userSpecifiedOptions=If[!MatchQ[primitiveMethodIndex, _Integer],
          safeOps,
          ReplaceRule[safeOps, Lookup[primitiveMethodIndexToOptionsLookup, primitiveMethodIndex]]
        ];

        (* Convert our unit operation primitives into unit operation objects. *)
        inputUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@flattenedIndexMatchingPrimitives,
          UnitOperationType->Input,
          Preparation->Robotic,
          FastTrack->True,
          Upload->False
        ];

        optimizedUnitOperationPackets=UploadUnitOperation[
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@coverOptimizedPrimitives,
          UnitOperationType->Optimized,
          Preparation->Robotic,
          FastTrack->True,
          Upload -> False
        ];

        (* Create a map to convert any simulated objects back to their labels. *)
        simulatedObjectsToLabel = Module[{allObjectsInSimulation, simulatedQ},
          (* Get all objects out of our simulation. *)
          allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

          (Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
        ];

        (* NOTE: Cannot fast track here because the options don't come back from the resolver expanded and FastTrack *)
        (* assumes that things are already expanded. *)
        calculatedUnitOperationPackets=UploadUnitOperation[
          (* NOTE: We have to translate from Object[...]s back to labels so that we don't try to upload simulated objects. *)
          (Head[#]@KeyDrop[#[[1]], {PrimitiveMethod, PrimitiveMethodIndex, WorkCell}]&)/@(First[allPrimitiveGroupings]/.simulatedObjectsToLabel),
          UnitOperationType->Calculated,
          Preparation->Robotic,
          Upload->False
        ];

        tipAdapterResource = If[!NullQ[tipAdapter],Resource[Sample->Model[Item,"id:Y0lXejMp6aRV"],Rent->True,Name->CreateUUID[]]];
        tipAdapterResourceReplacementRule = If[NullQ[tipAdapter],
          {},
          {Rule[
            Resource[KeyValuePattern[Sample->(ObjectReferenceP[Model[Item,"id:Y0lXejMp6aRV"]] | LinkP[Model[Item,"id:Y0lXejMp6aRV"]])]],
            tipAdapterResource
          ]}
        ];

        (* NOTE: We put resources in our unit operation packets for Preparation->Robotic. *)
        (* NOTE: Our unitOperationPackets is a list since we get back a list of unit operation packets back from the *)
        (* resource packets function since our unit operation can have a unit operation sub (ex. Transfer inside Filter). *)
        {outputUnitOperationPackets, subOutputUnitOperationPackets}=Module[{unitOperationObjectsReplaceRules},
          (* Create new IDs for any unit operations that we fetched from our cache. *)
          unitOperationObjectsReplaceRules=If[Length[outputUnitOperationObjectsFromCache]>0,
            Rule@@@Transpose[{
              outputUnitOperationObjectsFromCache,
              CreateID[Download[outputUnitOperationObjectsFromCache, Type]]
            }],
            {}
          ];

          Transpose@Map[
            Function[{unitOperationPackets},
              Module[{strippedUnitOperationPackets},
                (* Strip off the LabeledObjects field from the Object[UnitOperation]s. They should only be kept *)
                (* in the parent protocol. *)
                strippedUnitOperationPackets=(KeyDrop[#, Replace[LabeledObjects]]&)/@unitOperationPackets;

                {
                  Join[
                    First[strippedUnitOperationPackets],
                    <|
                      UnitOperationType->Output,
                      Preparation->Robotic
                    |>
                  ],
                  Rest[strippedUnitOperationPackets]
                }
              ]

            ],
            (First[allPrimitiveGroupingUnitOperationPackets]/.Join[tipResourceReplacementRules,magnetizationRackResourceReplacementRules,modelSampleResourceReplacementRules,tipAdapterResourceReplacementRule,counterWeightResourceReplacementRules])/.unitOperationObjectsReplaceRules
          ]
        ];

        (* -- Compute Injection Sample Resources for Plate Reader Primitives -- *)
        plateReaderFields=Module[{injectionResourceGroups},

          (* NOTE: We already did error checking during our MapThread to make sure that we don't have more than 2 *)
          (* injection samples. *)
          injectionResourceGroups=computeInjectionSampleResourceGroups[First[allPrimitiveGroupings]];

          MapThread[
            Function[{instrumentObject, injectionResources, index},
              Module[{primaryInjectionSample, secondaryInjectionSample, numberOfInjectionContainers, anyInjectionsQ,
                washVolume, fields},

                primaryInjectionSample = If[Length[injectionResources]>0,
                  injectionResources[[1]],
                  Null
                ];
                secondaryInjectionSample = If[Length[injectionResources]>1,
                  injectionResources[[2]],
                  Null
                ];

                numberOfInjectionContainers = Which[
                  !NullQ[secondaryInjectionSample],
                  2,
                  !NullQ[primaryInjectionSample],
                  1,
                  True,
                  0
                ];

                anyInjectionsQ = Or[
                  !NullQ[primaryInjectionSample],
                  !NullQ[secondaryInjectionSample]
                ];


                (* Wash each line being used with the flush volume - request a little extra to avoid air in the lines *)
                (* Always multiply by 2 - either we'll use same resource for prepping and flushing or we have two lines to flush *)
                washVolume = ($BMGFlushVolume + 2.5 Milliliter) * 2;

                (*
                  Prepping/Flushing Overview:
                  - ethanol (25mL per line) PrimaryPreppingSolvent
                  - water (25mL per line) SecondaryPreppingSolvent
                  - prime samples ($BMGPrimeVolume)
                  - run
                  - ethanol (25mL per line) PrimaryFlushingSolvent
                  - water (25mL per line) SecondaryFlushingSolvent

                  - If using 1 line, request 1 x 50mL of 70% Ethanol and 1 x 50mL of Water
                  - If using 2 lines, request 2 x 50mL of 70% Ethanol and 2 x 50mL of Water
                *)

                (* Populate fields needed to clean the lines before/after the run *)
                fields=If[anyInjectionsQ,
                  {
                    PlateReader -> FirstCase[
                      instrumentResourcesWithUpdatedTimeEstimate,
                      Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[instrumentObject]}]],
                      Null
                    ],
                    InjectionSample -> primaryInjectionSample,
                    SecondaryInjectionSample -> secondaryInjectionSample,

                    PrimaryPreppingSolvent -> Resource@@{
                      Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
                      Name->"Primary Solvent Container 1"
                    },
                    SecondaryPreppingSolvent -> Resource@@{
                      Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
                      Name->"Secondary Solvent Container 1"
                    },

                    PrimaryFlushingSolvent -> Resource@@{
                      Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
                      (* If we have only one injection container then we are only priming one line and we can use the same resource for set-up and tear-down *)
                      If[numberOfInjectionContainers==1,
                        Name->"Primary Solvent Container 1",
                        Name->"Primary Solvent Container 2"
                      ]
                    },
                    SecondaryFlushingSolvent -> Resource@@{
                      Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
                      (* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
                      Amount->washVolume,
                      Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
                      (* If we have only one injection container then we are only priming one line and we can use the same resource for set-up and tear-down *)
                      If[numberOfInjectionContainers==1,
                        Name->"Secondary Solvent Container 1",
                        Name->"Secondary Solvent Container 2"
                      ]
                    }
                  },
                  (* NOTE: Even if we don't have any injections, we have to populate the Primary and SecondaryPlateReader fields *)
                  (* so that we setup the method in the software. *)
                  {
                    PlateReader -> FirstCase[
                      instrumentResourcesWithUpdatedTimeEstimate,
                      Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[instrumentObject]}]],
                      Null
                    ]
                  }
                ];

                (* Append PrimaryPlateReader or SecondaryPlateReader prefixes to our plate reader fields. *)
                (* NOTE: We also have a field called PlateReader already so we have to account for that when prepending. *)
                Sequence@@Which[
                  MatchQ[index, 1],
                    (If[MatchQ[#[[1]], PlateReader], ToExpression["Primary"<>ToString[#[[1]]]], ToExpression["PrimaryPlateReader"<>ToString[#[[1]]]]] -> #[[2]]&)/@fields,
                  MatchQ[index, 2],
                    (If[MatchQ[#[[1]], PlateReader], ToExpression["Secondary"<>ToString[#[[1]]]], ToExpression["SecondaryPlateReader"<>ToString[#[[1]]]]] -> #[[2]]&)/@fields,
                  True,
                    {}
                ]
              ]
            ],
            {Keys[injectionResourceGroups], Values[injectionResourceGroups], Range[Length[Keys[injectionResourceGroups]]]}
          ]
        ];

        (* Make sure to replace the injection sample resources inside of the plate reader output unit operations, if they *)
        (* exist. *)
        (* NOTE: This contains both outputUnitOperationPackets and subOutputUnitOperationPackets. *)
        allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources=Module[
          {primaryPlateReaderInjectionSampleReplaceRules, secondaryPlateReaderInjectionSampleReplaceRules},

          (* Create replace rules. *)
          primaryPlateReaderInjectionSampleReplaceRules={
            If[KeyExistsQ[plateReaderFields, PrimaryPlateReaderInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, PrimaryPlateReaderInjectionSample][Sample]]}]]->Lookup[plateReaderFields, PrimaryPlateReaderInjectionSample],
              Nothing
            ],
            If[KeyExistsQ[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample][Sample]]}]]->Lookup[plateReaderFields, PrimaryPlateReaderSecondaryInjectionSample],
              Nothing
            ]
          };

          secondaryPlateReaderInjectionSampleReplaceRules={
            If[KeyExistsQ[plateReaderFields, SecondaryPlateReaderInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, SecondaryPlateReaderInjectionSample][Sample]]}]]->Lookup[plateReaderFields, SecondaryPlateReaderInjectionSample],
              Nothing
            ],
            If[KeyExistsQ[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample],
              Verbatim[Resource][KeyValuePattern[{Sample->ObjectP[Lookup[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample][Sample]]}]]->Lookup[plateReaderFields, SecondaryPlateReaderSecondaryInjectionSample],
              Nothing
            ]
          };

          Map[
            Function[{outputUnitOperationPacket},
              If[!MatchQ[Lookup[outputUnitOperationPacket, Object], ObjectP[Object[UnitOperation, #]&/@plateReaderPrimitiveTypes]],
                (* NOTE: Also replace any instrument resources with our global ones. *)
                Association[Normal[outputUnitOperationPacket]/.instrumentResourceReplaceRules],
                Module[{replaceRulesToUse},
                  replaceRulesToUse=If[MatchQ[Lookup[outputUnitOperationPacket, Instrument], Verbatim[Resource][KeyValuePattern[{Instrument->ObjectP[Lookup[plateReaderFields, PrimaryPlateReader][Instrument]]}]]],
                    primaryPlateReaderInjectionSampleReplaceRules,
                    secondaryPlateReaderInjectionSampleReplaceRules
                  ];

                  Association@Append[
                    (* NOTE: Also replace any instrument resources with our global ones. *)
                    Normal[outputUnitOperationPacket]/.instrumentResourceReplaceRules,
                    {
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[PrimaryInjectionSampleLink]],
                        Replace[PrimaryInjectionSampleLink]->Lookup[outputUnitOperationPacket, Replace[PrimaryInjectionSampleLink]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[SecondaryInjectionSampleLink]],
                        Replace[SecondaryInjectionSampleLink]->Lookup[outputUnitOperationPacket, Replace[SecondaryInjectionSampleLink]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[TertiaryInjectionSample]],
                        Replace[TertiaryInjectionSample]->Lookup[outputUnitOperationPacket, Replace[TertiaryInjectionSample]]/.replaceRulesToUse,
                        Nothing
                      ],
                      If[KeyExistsQ[outputUnitOperationPacket, Replace[QuaternaryInjectionSample]],
                        Replace[QuaternaryInjectionSample]->Lookup[outputUnitOperationPacket, Replace[QuaternaryInjectionSample]]/.replaceRulesToUse,
                        Nothing
                      ]
                    }
                  ]
                ]
              ]
            ],
            Flatten[{outputUnitOperationPackets, subOutputUnitOperationPackets}]
          ]
        ];


        (* Gather all up of our auxilliary packets. *)
        supplementaryPacketsMinusRootProtocol=Cases[
          Join[
            inputUnitOperationPackets,
            optimizedUnitOperationPackets,
            calculatedUnitOperationPackets,
            allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources,
            Flatten@allPrimitiveGroupingBatchedUnitOperationPackets
          ],
          Except[Null]
        ];

        (* determine if we need to overclock our threads or not; we only do this if there is an IncubateCells unit operation somewhere in the stack *)
        (* note that I am a little worried about the RoboticUnitOperations field recursively down ultimately including an IncubateCells such that we miss it and don't do Overclocking *)
        (* thus, I'm checking _all_ the supplementary packets for an Object[UnitOperation, IncubateCells] to be absolutely sure *)
        overclockQ = MemberQ[supplementaryPacketsMinusRootProtocol, PacketP[Object[UnitOperation, IncubateCells]]];

        (* if we are overclocking and we are not the parent protocol, set Overclock -> True in the root protocol (if we are the parent then we deal with this below) *)
        overclockingPacket = If[overclockQ && Not[NullQ[parentProtocol]],
          <|Object -> rootProtocol, Overclock -> True|>,
          Nothing
        ];
        supplementaryPackets = Flatten[{supplementaryPacketsMinusRootProtocol, overclockingPacket}];

        (* Compute SamplesIn/ContainersIn. *)
        samplesIn=Cases[Download[labeledObjects[[All,2]], Object], ObjectReferenceP[Object[Sample]],Infinity];
        containersIn=(Lookup[fetchPacketFromCache[#, cacheBall], Container]&)/@samplesIn;

        (* Include non-simulated resources in our RequiredObjects field. *)
        requiredObjects=Module[
          {
            sampleResourceBlobs, objectsInResourceBlobs,simulatedQ,simulatedObjects,
            nonSimulatedSampleResourceBlobs, cellResources
          },

          (* Get our resources out of our unit operation packets. *)
          sampleResourceBlobs=DeleteDuplicates@Cases[
            supplementaryPackets,
            Resource[KeyValuePattern[Type->Object[Resource, Sample]]],
            Infinity
          ];

          (* Get all of the objects from the resource blobs. *)
          objectsInResourceBlobs=DeleteDuplicates[Cases[sampleResourceBlobs, ObjectReferenceP[], Infinity]];

          (* Figure out which objects are simulated. *)
          simulatedQ = simulatedObjectQs[objectsInResourceBlobs, currentSimulation];
          simulatedObjects=PickList[objectsInResourceBlobs, simulatedQ];

          (* Only check if non-simulated objects are fulfillable. *)
          nonSimulatedSampleResourceBlobs = (
            If[MemberQ[#, Alternatives @@ simulatedObjects, Infinity],
              Nothing,
              #
            ]
          &)/@sampleResourceBlobs;

          (* We also want to exclude any objects that contain cells - they will be picked later in procedures at *)
          (* more opportune times so the cells do not die *)
          (* Get the sample resources that contain cells *)
          (* NOTE: This is a very similar process to how the variable cellContainerLinkResources is generated *)
          (* However, that variable contains the cell resources AFTER the protocol, here we want the cell resources *)
          (* BEFORE the protocol *)
          (* NOTE: We only do this if the work cell is the qpix *)
          cellResources = If[MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[{Object[Instrument,ColonyHandler], Model[Instrument,ColonyHandler]}]],
            Module[
              {
                nonSimulatedObjects,sampleObjects,containerObjects,containerContentPackets,
                containerIncludesCellsQ,sampleContainsCellsQ,cellSamples,cellContainers
              },

              (* Get all of the non simulated objects *)
              nonSimulatedObjects = UnsortedComplement[objectsInResourceBlobs,simulatedObjects];

              (* Separate the simulated objects into simulated samples and simulated containers *)
              sampleObjects = Cases[nonSimulatedObjects, ObjectP[Object[Sample]]];
              containerObjects = Cases[nonSimulatedObjects, ObjectP[Object[Container]]];

              (* Download information from our objects. *)
              (* NOTE: We are downloading from the very first simulation here so this will reflect the contents of the *)
              (* containers before all manipulations on the robot are completed. *)
              {samplePackets, containerContentPackets}=Quiet[
                Download[
                  {
                    sampleObjects,
                    containerObjects
                  },
                  {
                    {Packet[CellType]},
                    {Packet[Contents[[All,2]][{CellType}]]}
                  },
                  Cache->cacheBall,
                  Simulation->simulation
                ],
                {Download::NotLinkField,Download::MissingCacheField}
              ];

              (* Flatten the packets *)
              samplePackets=Flatten@samplePackets;
              containerContentPackets=Flatten/@containerContentPackets;

              (* Determine the which container/samples contains cells. *)
              containerIncludesCellsQ=(MemberQ[Lookup[#, CellType, Null], CellTypeP]&)/@containerContentPackets;
              sampleContainsCellsQ=(MatchQ[Lookup[#, CellType], CellTypeP]&)/@samplePackets;

              (* Pick containers/samples that will not have cell samples in them. *)
              cellSamples=PickList[sampleObjects, sampleContainsCellsQ];
              cellContainers=PickList[containerObjects, containerIncludesCellsQ];

              (
                If[MemberQ[#, Alternatives@@Join[cellSamples,cellContainers], Infinity],
                  #,
                  Nothing
                ]&)/@sampleResourceBlobs
            ],
            {}
          ];

          (* Exclude the cell Resources *)
          UnsortedComplement[nonSimulatedSampleResourceBlobs,cellResources]
        ];

        (* Create a protocol object for these manipulations. *)
        protocolPacket=(<|
          Object->CreateID[Object[Protocol, protocolType]],
          Type->Object[Protocol, protocolType],

          Replace[SamplesIn]->(Link[#,Protocols]&)/@samplesIn,
          Replace[ContainersIn]->(Link[#,Protocols]&)/@containersIn,

          Replace[InputUnitOperations]->(Link[#, Protocol]&)/@Lookup[inputUnitOperationPackets, Object],
          Replace[OptimizedUnitOperations]->(Link[#, Protocol]&)/@Lookup[optimizedUnitOperationPackets, Object],
          Replace[CalculatedUnitOperations]->(Link[#, Protocol]&)/@Lookup[calculatedUnitOperationPackets, Object],

          (* NOTE: We don't use allOutputUnitOperationPacketsWithConsolidatedInjectionSampleResources here since that contains *)
          (* packets from both outputUnitOperationPackets and subOutputUnitOperationPackets. *)
          Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[outputUnitOperationPackets, Object],

          (* if we have an IncubateCells unit operation in here and we are the root protocol, set Overclock -> True *)
          (* if we have an IncubateCells unit operation but we are not the root protocol, then the root protocol has been set to Overclock -> True above *)
          If[NullQ[parentProtocol] && overclockQ,
            Overclock -> True,
            Nothing
          ],

          (* NOTE: We only upload the ColonyHandler field for RCP protocols, not RSP *)
          If[MatchQ[myFunction,ExperimentRoboticCellPreparation],
            ColonyHandler -> If[MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[{Object[Instrument,ColonyHandler], Model[Instrument,ColonyHandler]}]],
              Resource[
                Instrument->If[MemberQ[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,ColonyHandler]]],
                  (* If we have instrument object, go with it *)
                  FirstCase[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,ColonyHandler]]],
                  (* Allow all supported instrument models *)
                  DeleteDuplicates[Download[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],Object]]
                ],
                (* NOTE: We should be given back valid time estimates here, but it we're not default to 1 minute so we make *)
                (* a valid resource and don't error on upload. *)
                Time->Max[totalWorkCellTime, 1 Minute]
              ],
              Null
            ],
            Nothing
          ],

          LiquidHandler->If[MemberQ[Flatten[allPrimitiveGroupingWorkCellInstruments], ObjectP[{Object[Instrument,LiquidHandler],Model[Instrument,LiquidHandler]}]],
            Resource[
              Instrument->If[MemberQ[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,LiquidHandler]]],
                (* If we have instrument object, go with it *)
                FirstCase[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],ObjectP[Object[Instrument,LiquidHandler]]],
                (* Allow all supported instrument models *)
                DeleteDuplicates[Download[DeleteDuplicates[Flatten[allPrimitiveGroupingWorkCellInstruments]],Object]]
              ],
              (* NOTE: We should be given back valid time estimates here, but it we're not default to 1 minute so we make *)
              (* a valid resource and don't error on upload. *)
              Time->Max[totalWorkCellTime, 1 Minute]
            ],
            Null
          ],
          RunTime->Max[totalWorkCellTime, 1 Minute],

          Replace[RequiredInstruments]->instrumentResourcesWithUpdatedTimeEstimate,

          (* Include Plate Reader Fields. *)
          Sequence@@plateReaderFields,

          Replace[LabeledObjects]->labeledObjects,
          Replace[FutureLabeledObjects]->futureLabeledObjects,

          (* NOTE: We need this field because not all of our objects will be labeled. *)
          (* TODO: Use Integrations option for robotic instrument selection. *)
          Replace[RequiredObjects]->requiredObjects,
          Replace[RequiredTips]->allTipResources,
          If[NullQ[tipAdapterResource], Nothing, TipAdapter->tipAdapterResource],

          Replace[TipRacks]->tipRackResources,

          Replace[InitialContainerIdlingConditions]->Join[
            ({#, Ambient}&)/@Flatten[allPrimitiveGroupingAmbientContainerResources],
            ({#, Incubator}&)/@Flatten[allPrimitiveGroupingIncubatorContainerResources]
          ],

          ResolvedOptions->safeOps,

          Replace[TaredContainers]->tareContainers,
          Replace[CellContainers]->cellContainerLinkResources,
          Replace[LivingCellContainers] -> livingCellContainerLinkResources,
          Replace[PostProcessingContainers]->nonCellContainerLinkResources,

          MeasureWeight->If[!KeyExistsQ[userSpecifiedOptions, MeasureWeight] || MatchQ[Lookup[userSpecifiedOptions, MeasureWeight], Automatic],
            True,
            Lookup[userSpecifiedOptions, MeasureWeight]
          ],
          MeasureVolume->If[!KeyExistsQ[userSpecifiedOptions, MeasureVolume] || MatchQ[Lookup[userSpecifiedOptions, MeasureVolume], Automatic],
            True,
            Lookup[userSpecifiedOptions, MeasureVolume]
          ],
          ImageSample->If[!KeyExistsQ[userSpecifiedOptions, ImageSample] || MatchQ[Lookup[userSpecifiedOptions, ImageSample], Automatic],
            True,
            Lookup[userSpecifiedOptions, ImageSample]
          ],

          Replace[Checkpoints]->{
            {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15 Minute]},
            {
              "Liquid Handling",
              totalWorkCellTime,
              "The given unit operations are executed, in the order in which they are specified.",
              Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->totalWorkCellTime]
            },
            {"Sample Post-Processing",1 Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Minute]},
            {"Returning Materials",15 Minute,"Samples are returned to storage.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15 Minute]}
          },

          MeasureWeight->Lookup[safeOps,MeasureWeight, True],
          MeasureVolume->Lookup[safeOps,MeasureVolume, True],
          ImageSample->Lookup[safeOps,ImageSample, True],

          Replace[PreparedResources]->Link[Lookup[safeOps,PreparedResources,Null],Preparation]
        |>)/.modelSampleResourceReplacementRules;

        (* Upload if asked to. *)
        Which[
          !MemberQ[output, Result],
            Null,
          True,
            ECL`InternalUpload`UploadProtocol[
              protocolPacket,
              supplementaryPackets,
              Upload->Lookup[safeOps,Upload],
              Confirm->Lookup[safeOps,Confirm],
              ParentProtocol->Lookup[safeOps,ParentProtocol],
              Priority->Lookup[safeOps,Priority],
              StartDate->Lookup[safeOps,StartDate],
              HoldOrder->Lookup[safeOps,HoldOrder],
              QueuePosition->Lookup[safeOps,QueuePosition],
              ConstellationMessage->{Object[Protocol]},
              Simulation->currentSimulation
            ]
        ]
    ]
  ];

  (* -- STAGE 7: Output -- *)
  If[debug, Echo["Beginning stage 7: Returning and memoizing output"]];

	(* Create a map to convert any simulated objects back to their labels. *)
	simulatedObjectsToLabelOutput=Module[{allObjectsInSimulation, simulatedQ},
		(* Get all objects out of our simulation. *)
		allObjectsInSimulation=Download[Lookup[currentSimulation[[1]], Labels][[All,2]], Object];

		(* Figure out which objects are simulated. *)
		simulatedQ = simulatedObjectQs[allObjectsInSimulation, currentSimulation];

		(Reverse/@PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ])/.{link_Link:>Download[link,Object]}
	];

  (* Convert the resolved input primitives into a format that the command builder can understand. *)
  (* Has the command builder asked us for a finalized version of our primitives? *)
  (* NOTE: If we get PreviewFinalizedUnitOperations->True, we want to return our primitives with new method wrappers around *)
  (* them. This is in contrast to False where we shouldn't add method wrappers if they didn't exist. This also implies that *)
  (* if False, we shouldn't optimize. This is because if we're not previewing the final UOs, the front end needs the primitives *)
  (* in the same form that it fed them in so that the command builder doesn't keep crazily rearranging the UOs. *)
  resolvedInput=If[MatchQ[previewFinalizedUnitOperations, True],
    (* Yes, return resolved primitives with the method wrappers around them. *)
    Module[{calculatedPrimitivesWithMethodWrappers, anyPrimitiveP, primitivePositions},
      (* Get our calculated primitives with method wrappers. *)
      calculatedPrimitivesWithMethodWrappers=Map[
        Function[{primitiveGroup},
          Module[{primitiveMethod, cleanPrimitives},
            (* Figure out what primitive method we're dealing with for this group. *)
            primitiveMethod=Lookup[First[primitiveGroup][[1]], PrimitiveMethod];

            (* Strip out the PrimitiveMethod and PrimitiveMethodIndex keys since they're internal and shouldn't be returned *)
            (* to the user. *)
            cleanPrimitives=Map[
              Function[primitive,
                Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
                  (* Lookup information about our primitive. *)
                  primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                  primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
                  resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

                  (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
                  If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                    Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
                    Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptionsWorkCell}]
                  ]
                ]
              ],
              primitiveGroup
            ]/.simulatedObjectsToLabelOutput;

            (* We should not put a head on our primitives we're not in a script generating function. *)
            If[!MatchQ[myFunction, ScriptGeneratingPrimitiveFunctionP],
              Sequence@@cleanPrimitives,
              primitiveMethod[Sequence@@cleanPrimitives]
            ]
          ]
        ],
        allPrimitiveGroupings
      ];

      (* Our calculated primitives should index match to our optimized primitives. *)

      (* NOTE: Since we didn't optimize above, we should have the same number of primitives inputted as resolved. *)
      anyPrimitiveP=Alternatives@@(Blank[#]&/@primitiveHeads);
      primitivePositions=Position[calculatedPrimitivesWithMethodWrappers, anyPrimitiveP, 2];

      (* If we're called by ExperimentBLAHInputs, return the primitives with fully calculated options. Otherwise, assume that *)
      (* we're being called by the front end and return the minimal set of options (from the optimized primitives) as not to *)
      (* overwhelm the user in the front end and also not to tell the front end that every calculated option is "specified". *)
      If[MatchQ[inputsFunctionQ, True],
        calculatedPrimitivesWithMethodWrappers,
        Module[{cleanOptimizedPrimitives},
          (* Clean up our optimized primitives. *)
          cleanOptimizedPrimitives=Map[
            Function[primitive,
              Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
                (* Lookup information about our primitive. *)
                primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
                primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
                resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

                (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
                If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
                  Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
                  Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, WorkCell}]
                ]
              ]
            ],
            coverOptimizedPrimitives
          ];

          (* Replace our primitives with the original optimized ones. *)
          ReplacePart[calculatedPrimitivesWithMethodWrappers, Rule@@@Transpose[{primitivePositions, cleanOptimizedPrimitives}]]
        ]
      ]
    ],
    (* No. Return resolved primitives only with method wrappers if the user originally included them. *)
    (* NOTE: In this case, we made sure not to optimize our unit operations above, even if the user specified *)
    (* OptimizedUnitOperations->True since we don't want to change the user's primitives before the optimization page in the CB. *)
    Module[{resolvedFlattenedPrimitives, anyPrimitiveP, primitivePositions},
      (* Drop our internal keys from these resolved primitives. *)
      resolvedFlattenedPrimitives=Map[
        Function[primitive,
          Module[{primitiveInformation, primitiveOptionDefinitions,resolverFunction},
            (* Lookup information about our primitive. *)
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];
            resolverFunction=Lookup[primitiveInformation, ExperimentFunction, Null];

            (* Only drop the WorkCell option if it's not a real option for our experiment function. *)
            If[MemberQ[Options[resolverFunction][[All,1]], "WorkCell"],
              Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}],
              Head[primitive]@KeyDrop[primitive[[1]], {PrimitiveMethod, PrimitiveMethodIndex, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, WorkCell}]
            ]
          ]
        ],
        Flatten[allPrimitiveGroupings]
      ];

      (* NOTE: Since we didn't optimize above, we should have the same number of primitives inputted as resolved. *)
      anyPrimitiveP=Alternatives@@(Blank[#]&/@primitiveHeads);
      primitivePositions=Position[sanitizedPrimitives, anyPrimitiveP, 2];

      (* Replace our primitives with the resolved ones. *)
      ReplacePart[sanitizedPrimitives, Rule@@@Transpose[{primitivePositions, (resolvedFlattenedPrimitives)/.simulatedObjectsToLabelOutput}]]
    ]
  ];

  If[Length[invalidInputIndices]>0 && Not[gatherTests],
    If[MatchQ[$ShortenErrorMessages, True],
      Message[Error::InvalidInput, shortenPrimitives[coverOptimizedPrimitives[[invalidInputIndices]]]],
      Message[Error::InvalidInput, coverOptimizedPrimitives[[invalidInputIndices]]]
    ];
  ];

  (* NOTE: We need a Output->Simulation to this function so that we can return a simulation back, in the case that we're called from *)
  (* PreparatoryUnitOperations. *)

  (* Return the requested output *)
  outputRules={
    Result -> outputResult,
    Preview -> Null,
    Options -> resolvedOptions,
    (* NOTE: We return our tests in an indexed format so that we can show specific tests on the unit operation edit screen *)
    (* via ValidQTestsJSON. The first list is expected to be the general function tests, the rest of the lists are index matched *)
    (* to the unit operations. *)
    Tests->If[gatherTests,
      {
        Flatten@{
          safeOpsTests,
          templateTests,
          frqTests,
          accumulatedFRQTests
        },
        Sequence@@allResolverTests
      },
      Null
    ],
    Input->resolvedInput,
    Simulation->currentSimulation
  };
  finalOutput=outputSpecification /. outputRules;

  (* Cache the value right before returning if we didn't have any issues. *)
  If[Length[invalidResolverPrimitives]==0,
    $PrimitiveFrameworkOutputCache[{myFunction, myPrimitives, ToList[myOptions], gatherTests}] = outputRules;
  ];

  finalOutput
]];

(* Install the options function. *)
Module[{optionsFunction},
  optionsFunction=ToExpression[SymbolName[myFunction]<>"Options"];

  With[{myOptionsFunction=optionsFunction},

    DefineOptions[myOptionsFunction,
      Options:>{
        {
          OptionName->OutputFormat,
          Default->Table,
          AllowNull->False,
          Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
          Description->"Indicates whether the function returns a table or a list of the options."
        }
      },
      SharedOptions :> {myFunction}
    ];

    Authors[myOptionsFunction] := {"thomas"};

    myOptionsFunction[myPrimitives_List,myOptions:OptionsPattern[myOptionsFunction]]:=Module[
      {listedOptions,preparedOptions,resolvedOptions},

      listedOptions=ToList[myOptions];

      (* Send in the correct Output option and remove OutputFormat option *)
      preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

      resolvedOptions=myFunction[myPrimitives,preparedOptions];

      (* Return the option as a list or table *)
      If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
        LegacySLL`Private`optionsToTable[resolvedOptions,myFunction],
        resolvedOptions
      ]
    ];

    myOptionsFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myOptionsFunction[{myPrimitive},myOptions];
  ];
];

(* Install the ValidQ function. *)
Module[{validQFunction},
  validQFunction=ToExpression["Valid"<>SymbolName[myFunction]<>"Q"];

  With[{myValidQFunction=validQFunction},

    DefineOptions[myValidQFunction,
      Options:>{
        VerboseOption,
        OutputFormatOption
      },
      SharedOptions :> {myFunction}
    ];

    Authors[myValidQFunction] := {"thomas"};


    myValidQFunction[myPrimitives_List,myOptions:OptionsPattern[myValidQFunction]]:=Module[
      {listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

      listedInput=myPrimitives;
      listedOptions=ToList[myOptions];

      (* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
      preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

      (* Call the function to get a list of tests *)
      functionTests=myFunction[myPrimitives,preparedOptions];

      initialTestDescription="All provided options and inputs match their provided patterns and containers are not empty (no further testing can proceed if this test fails):";

      allTests=If[MatchQ[functionTests,$Failed],
        {Test[initialTestDescription,False,True]},
        Module[{initialTest,validObjectBooleans,voqWarnings,objects},
          initialTest=Test[initialTestDescription,True,True];

          objects=DeleteDuplicates[Cases[listedInput, ObjectReferenceP[], Infinity]];

          (* Create warnings for invalid objects *)
          validObjectBooleans=ValidObjectQ[objects,OutputFormat->Boolean];
          voqWarnings=MapThread[
            Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
              #2,
              True
            ]&,
            {objects,validObjectBooleans}
          ];

          (* Get all the tests/warnings *)
          Flatten[Join[{initialTest},functionTests,voqWarnings]]
        ]
      ];

      (* Lookup test running options *)
      safeOps=SafeOptions[myValidQFunction,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
      {verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

      (* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
      Lookup[
        RunUnitTest[
          <|ToString[myFunction]->allTests|>,
          Verbose->verbose,
          OutputFormat->outputFormat
        ],
        ToString[myFunction]
      ]
    ];

    myValidQFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myValidQFunction]]:=myValidQFunction[{myPrimitive},myOptions];
  ];
];

(* Install the inputs function. *)
Module[{inputsFunction},
  inputsFunction=ToExpression[SymbolName[myFunction]<>"Inputs"];

  With[{myInputsFunction=inputsFunction},

    DefineOptions[myInputsFunction,
      Options:>{},
      SharedOptions :> {myFunction}
    ];

    Authors[myInputsFunction] := {"thomas"};

    myInputsFunction[myPrimitives_List,myOptions:OptionsPattern[myInputsFunction]]:=Module[
      {listedOptions,preparedOptions},

      listedOptions=ToList[myOptions];

      (* Send in the correct Output option *)
      preparedOptions=Join[listedOptions,{Output->Input, InputsFunction->True}];

      myFunction[myPrimitives,preparedOptions]
    ];

    myInputsFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myInputsFunction[{myPrimitive},myOptions];
  ];
];

(* Install the preview function. *)
Module[{previewFunction},
  previewFunction=ToExpression[SymbolName[myFunction]<>"Preview"];

  With[{myPreviewFunction=previewFunction},

    DefineOptions[myPreviewFunction,
      Options:>{},
      SharedOptions :> {myFunction}
    ];

    Authors[myPreviewFunction] := {"thomas"};

    myPreviewFunction[myPrimitives_List,myOptions:OptionsPattern[myPreviewFunction]]:=Null;

    myPreviewFunction[myPrimitive:Except[_List],myOptions:OptionsPattern[myOptionsFunction]]:=myPreviewFunction[{myPrimitive},myOptions];
  ];
];

];

installPrimitiveFunction[Experiment, Hold[ExperimentP]];

installPrimitiveFunction[ExperimentSamplePreparation, Hold[SamplePreparationP]];
installPrimitiveFunction[ExperimentManualSamplePreparation, Hold[ManualSamplePreparationP]];
installPrimitiveFunction[ExperimentRoboticSamplePreparation, Hold[RoboticSamplePreparationP]];

installPrimitiveFunction[ExperimentCellPreparation, Hold[CellPreparationP]];
installPrimitiveFunction[ExperimentManualCellPreparation, Hold[ManualCellPreparationP]];
installPrimitiveFunction[ExperimentRoboticCellPreparation, Hold[RoboticCellPreparationP]];

shortenPrimitives[myList_List]:=myList/.{primitive:(_Symbol)[_Association]:>(ToString[Head[primitive]]<>"[...]")};



(* ::Subsubsection::Closed:: *)
(*LookupLabeledObject*)


(* ::Code::Initialization:: *)
Authors[LookupLabeledObject]={"dima","thomas"};

Error::LabeledObjectsDoNotExist="The LabeledObjects field does not exist in the following protocol type(s), `1`. Please only give a ManualSamplePreparation, ManualCellPreparation, RoboticSamplePreparation, or RoboticCellPreparation protocol object as input to this function.";
Error::LabelNotFound="The labels, `1`, were not found in the protocol object, `2`. The existing labels in the protocol object(s) (via the LabeledObjects field) are `3`. This means that either the label given was not specified in the protocol object(s) or that the protocol object is still processing and hasn't created the labeled sample/container yet.";
Error::NoProtocolsInScript="The script `1` does not contain any Protocols";
Warning::MultipleLabeledObjects="The labels, `1`, are present in multiple protocols. The output labels are for the last protocol containing this Label.";

(* Public helper function to lookup a labeled object. *)
DefineOptions[LookupLabeledObject,
	Options :> {
		{
			OptionName -> Script,
			Description -> "Indicates if the input is a script.",
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Hidden"
		},
		{
			OptionName -> OutputFormat,
			Description -> "Indicates whether the function returns a single object without a list or a list with the single object inside if there is only one object returned.",
			Default -> List,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Single, List]],
			Category -> "Hidden"
		}
	}
];

(* script overloads *)
LookupLabeledObject[myScript:ObjectP[Object[Notebook, Script]], myLabel:_String]:=LookupLabeledObject[myScript, {myLabel}, OutputFormat -> Single];
LookupLabeledObject[myScript:ObjectP[Object[Notebook, Script]], myLabels:{_String..}, ops:OptionsPattern[]]:=Module[{protocols,outputFormat},

	protocols=Download[myScript, Protocols];

	(* get the OutputFormat option *)
	outputFormat=Lookup[SafeOptions[LookupLabeledObject, ToList[ops]], OutputFormat];

	(* if there are no protocols, error out *)
	If[Length[protocols] == 0,
		Message[Error::NoProtocolsInScript, myScript]; Return[$Failed],

		LookupLabeledObject[Download[myScript, Protocols[Object]], myLabels, Script -> True, OutputFormat -> outputFormat]
	]
];

(* protocol overloads *)
LookupLabeledObject[myProtocol:ObjectP[Object[Protocol]], myLabel_String]:=LookupLabeledObject[{myProtocol}, {myLabel}, OutputFormat -> Single];
LookupLabeledObject[myProtocol:ObjectP[Object[Protocol]], myLabels:{_String..}, ops:OptionsPattern[]]:=Module[{outputFormat},

	(* get the OutputFormat option *)
	outputFormat=Lookup[SafeOptions[LookupLabeledObject, ToList[ops]], OutputFormat];

	LookupLabeledObject[{myProtocol}, myLabels, OutputFormat -> outputFormat]
];

(* Simulation overload *)
LookupLabeledObject[mySimulation:SimulationP, myLabel_String]:=LookupLabeledObject[mySimulation, {myLabel}];
LookupLabeledObject[mySimulation:SimulationP, myLabels:{_String..}]:=Lookup[Lookup[mySimulation[[1]], Labels], myLabels, Null];

(* CORE overload *)
LookupLabeledObject[myProtocols:{ObjectP[Object[Protocol]]...}, myLabels:{_String..}, ops:OptionsPattern[]]:=Module[
	{scriptQ, outputFormat, labeledObjectsExistQ, labeledObjects, missingLabels, initialResults, multipleHitsLabels, result},

	(* check if we were given a script *)
	scriptQ=Lookup[SafeOptions[LookupLabeledObject, ToList[ops]], Script];

	(* get the OutputFormat option *)
	outputFormat=Lookup[SafeOptions[LookupLabeledObject, ToList[ops]], OutputFormat];

	(* Make sure the LabeledObjects field exists in the protocol type. *)
	labeledObjectsExistQ=MemberQ[Fields[#, Output -> Short], LabeledObjects]& /@ Download[myProtocols, Type];

	(* check if protocols might have labeled objects *)
	Which[
		(* all protocols don't have LabeledObjects, error out *)
		!Or@@labeledObjectsExistQ,
		Message[Error::LabeledObjectsDoNotExist, PickList[myProtocols, labeledObjectsExistQ, False]];
		Return[$Failed],

		(* _some_ protocols don't have LabeledObject, just throw a warning *)
		And[
			MemberQ[labeledObjectsExistQ, False],
			!scriptQ
		],
		Message[Error::LabeledObjectsDoNotExist, PickList[myProtocols, labeledObjectsExistQ, False]];
	];

	(* Download the LabeledObjects field. *)
	labeledObjects=Download[PickList[myProtocols, labeledObjectsExistQ], LabeledObjects];

	missingLabels=UnsortedComplement[myLabels, Flatten[labeledObjects,1][[All, 1]]];

	(* If we don't find the label, throw an error. The label is in the format of {label string, object} *)
	If[Length[missingLabels] > 0,
		Message[Error::LabelNotFound, missingLabels, myProtocols, DeleteDuplicates[Flatten[labeledObjects,1][[All, 1]]]];
	];

	(* Return the corresponding object(s). If not presented, return Null *)
	(* do a first pass *)
	initialResults = Download[Lookup[Apply[Rule, labeledObjects, {2}], #, Nothing],Object]&/@myLabels;

	multipleHitsLabels={};
	result = MapThread[Function[{objects, label},
		Switch[Length[objects],
		0, Null,
		1, First@objects,
		GreaterP[1],AppendTo[multipleHitsLabels, label];Last[objects]
	]],{initialResults, myLabels}];

	(* if we got a label that was used in multiple protocols, throw a warning *)
	If[Length[multipleHitsLabels]>0,Message[Warning::MultipleLabeledObjects,multipleHitsLabels]];

	(* return a non-list if we have only one and if the input label was given non-listed *)
	If[Length[result] == 1 && MatchQ[outputFormat, Single], First[result], result]
];



(* ::Subsubsection::Closed:: *)
(*RestrictLabeledSamples/UnrestrictLabeledSamples*)


(* ::Code::Initialization:: *)
Authors[RestrictLabeledSamples]={"dima"};
Authors[UnrestrictLabeledSamples]={"dima"};


(* ::Code::Initialization:: *)
(* public helpers to restrict/unrestrict all non-public Objects from a given protocol *)
RestrictLabeledSamples[object:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]]:=RestrictLabeledSamples[{object}];
RestrictLabeledSamples[objects:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]..}]:=Module[
  {allLabeledObjectData, nonPublicObjects},

  allLabeledObjectData = Download[objects, {Object, Notebook[Object]}];

  (*Get only non-public Objects*)
  nonPublicObjects = DeleteCases[allLabeledObjectData, {_,Null}][[All,1]];

  (*RestrictSamples*)
  RestrictSamples[nonPublicObjects]
];

UnrestrictLabeledSamples[object:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]]:=UnrestrictLabeledSamples[{object}];
UnrestrictLabeledSamples[objects:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]..}]:=Module[
  {allLabeledObjectData, nonPublicObjects},

  allLabeledObjectData = Download[objects, {Object, Notebook[Object]}];

  (*Get only non-public Objects*)
  nonPublicObjects = DeleteCases[allLabeledObjectData, {_,Null}][[All,1]];

  (*UnrestrictSamples*)
  UnrestrictSamples[nonPublicObjects]
];

(* Helper function. *)
listToString[myList_List]:=Switch[Length[myList],
  (* If there is only one element in the list, there is no formatting to do. *)
  1,
    "1) "<>ToString[myList[[1]]],
  (* If there are two elements in the list, add an "or" between them. *)
  2,
    StringJoin@{"1) ",myList[[1]]," and 2) ", myList[[2]]},
  _,
    (* Otherwise, there are more than 2 elements. Riffle in commas and then add "or" before the last element. *)
    StringJoin@Insert[Riffle[MapThread[ToString[#1]<>") "<>#2&, {Range[Length[myList]], myList}],", "],"and ",-2]
];

(* Get all of the injection samples in this robotic group from the Plate Reader unit operations. *)
(* Returns {(PrimitiveHead->{_Resource..})..} *)
computeInjectionSampleResourceGroups[myResolvedPrimitives_List]:=Module[
  {plateReaderPrimitives, partitionedPlateReaderPrimitives},

  (* Get the plate reader primitives. *)
  plateReaderPrimitives=Cases[myResolvedPrimitives, plateReaderPrimitiveP];

  (* If we don't have any plate reader primitives, we don't have any injection samples that we have *)
  (* to separately load. *)
  If[Length[plateReaderPrimitives]==0,
    Return[{}];
  ];

  (* Partition our plate reader primitives by the resolved instrument (convert to model if we have an object). *)
  partitionedPlateReaderPrimitives=Values@GroupBy[plateReaderPrimitives, (Download[Lookup[#[[1]], Instrument], Object]/.{object:ObjectP[Object[]]->Download[object, Model[Object]]}&)];

  Map[
    Function[{plateReaderPrimitiveGroup},
      Module[{resolvedReadPlateAssociations, allInjectionSamples, allInjectionVolumes,
        uniqueInjectionSamples, injectionSampleVolumeLookup, resources},
        (* Strip out associations *)
        resolvedReadPlateAssociations = First/@plateReaderPrimitiveGroup;

        (* Extract injection samples from associations, defaulting to Null if not specified *)
        allInjectionSamples = Flatten[Map[
          Lookup[#,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null]&,
          resolvedReadPlateAssociations
        ]];

        (* Extract injection volumes from associations, defaulting to Null if not specified *)
        allInjectionVolumes = Flatten[Map[
          Lookup[#,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume},Null]&,
          resolvedReadPlateAssociations
        ]];

        uniqueInjectionSamples = DeleteDuplicates@DeleteCases[Flatten@allInjectionSamples,Null];

        injectionSampleVolumeLookup = If[Length[uniqueInjectionSamples] > 0,
          Merge[
            MapThread[
              If[NullQ[#1],
                Nothing,
                Download[#1,Object] -> #2
              ]&,
              {allInjectionSamples,allInjectionVolumes}
            ],
            Total
          ],
          <||>
        ];

        (* Create replace rules to replace any existing resources we may have made. *)
        resources=KeyValueMap[
          Function[{sample, volume},
            (* Create a resource for the sample *)
            If[MatchQ[volume + $BMGPrimeVolume, LessEqualP[50 Milliliter]],
              Resource@@{
                Sample -> sample,
                (* Include volume lost due to priming lines (compiler sets to 1mL)
                - prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
                Amount -> (volume + $BMGPrimeVolume),

                (* Specify a container if we're working with a model or if current container isn't workable *)
                If[MatchQ[sample,ObjectP[Object[Sample]]],
                  Nothing,
                  Container -> Model[Container, Vessel, "50mL Tube"]
                ],
                Name->CreateUUID[]
              },
              Sequence@@(
                Resource@@{
                  Sample -> sample,
                  (* Include volume lost due to priming lines (compiler sets to 1mL)
                  - prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
                  Amount -> #,

                  (* Specify a container if we're working with a model or if current container isn't workable *)
                  If[MatchQ[sample,ObjectP[Object[Sample]]],
                    Nothing,
                    Container -> Model[Container, Vessel, "50mL Tube"]
                  ],
                  Name->CreateUUID[]
                }
                    &)/@QuantityPartition[volume + $BMGPrimeVolume, 50 Milliliter]
            ]
          ],
          injectionSampleVolumeLookup
        ];

        Lookup[resolvedReadPlateAssociations[[1]], Instrument] -> resources
      ]
    ],
    partitionedPlateReaderPrimitives
  ]
];

(* Returns {{invalidSampleObject, primitiveIndex}..}. *)
computeInvalidInjectionSampleResources[myResolvedPrimitives_List, myUnitOperationPackets_List]:=Module[
  {plateReaderPrimitives, resolvedReadPlateAssociations, allInjectionSamples, allResourcesWithoutInjectionSampleFields, invalidInjectionResourcePositions},

  (* Get the plate reader primitives. *)
  plateReaderPrimitives=Cases[myResolvedPrimitives, plateReaderPrimitiveP];

  (* Strip out associations *)
  resolvedReadPlateAssociations = First/@plateReaderPrimitiveGroup;

  (* NOTE: We only care about Object[Sample]s here! *)
  allInjectionSamples = Cases[
    Join@@Map[
      Lookup[#,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null]&,
      resolvedReadPlateAssociations
    ],
    ObjectP[Object[Sample]]
  ];

  (* These SHOULD not include any injection sample resources. *)
  allResourcesWithoutInjectionSampleFields=DeleteDuplicates[
    Cases[
      Normal@KeyDrop[
        #,
        {Replace[PrimaryInjectionSampleLink], Replace[SecondaryInjectionSampleLink], Replace[TertiaryInjectionSample], Replace[QuaternaryInjectionSample]}
      ]&/@myUnitOperationPackets,
      _Resource,
      Infinity
    ]
  ];

  (* Try to find invalid injection resources. *)
  invalidInjectionResourcePositions=Position[
    allResourcesWithoutInjectionSampleFields,
    Verbatim[Resource][KeyValuePattern[{Sample -> ObjectP[allInjectionSamples]}]]
  ][[All,1]];

  If[Length[invalidInjectionResourcePositions]>0,
    Transpose[{
      (Lookup[#[[1]], Sample]&)/@Extract[allResourcesWithoutInjectionSampleFields, invalidInjectionResourcePositions],
      invalidInjectionResourcePositions
    }],
    {}
  ]
];

(* ValidateUnitOperationsJSON *)
ValidateUnitOperationsJSON[myPrimitives_List, myOptions:OptionsPattern[]]:=Module[
  {primitiveSetInformation, allPrimitiveInformation, sanitizedPrimitives, flattenedPrimitives, cacheBall,
    primitivesWithPreresolvedInputs, primitiveMessages},

  (* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];

  (* Replace the unit operation objects. *)
  sanitizedPrimitives=Module[{sanitizedPrimitivesWithUnitOperationObjects, userInputtedUnitOperationObjects, userInputtedUnitOperationPackets, userInputtedUnitOperationObjectToPrimitive},
    (* Sanitize our inputs. *)
    sanitizedPrimitivesWithUnitOperationObjects=(sanitizeInputs[myPrimitives]/.{link:LinkP[] :> Download[link, Object]});

    (* Find any unit operation objects that were given as input. *)
    userInputtedUnitOperationObjects=DeleteDuplicates@Cases[sanitizedPrimitivesWithUnitOperationObjects, ObjectReferenceP[Object[UnitOperation]], Infinity];

    (* Download our unit operation objects. *)
    userInputtedUnitOperationPackets=Download[userInputtedUnitOperationObjects, Packet[All]];

    (* Convert each of these packets into a primitive. *)
    userInputtedUnitOperationObjectToPrimitive=(Lookup[#, Object]->ConstellationViewers`Private`UnitOperationPrimitive[#, IncludeCompletedOptions->False, IncludeEmptyOptions->False]&)/@userInputtedUnitOperationPackets;

    (sanitizeInputs[sanitizedPrimitivesWithUnitOperationObjects/.userInputtedUnitOperationObjectToPrimitive]/.{link:LinkP[] :> Download[link, Object]})
  ];

  (* Flatten out our primitives, setting the PrimitiveMethod option if the method wrapper is given. *)
  flattenedPrimitives=MapThread[
    Function[{listElement, listIndex},
      (* Does this look like a wrapper and not an individual primitive? *)
      If[MatchQ[listElement, Except[_Symbol[_Association]]],
        (* We have a method wrapper. *)
        Sequence@@(
          (
            Head[#]@Append[
              #[[1]],
              {
                PrimitiveMethod->Head[listElement],
                PrimitiveMethodIndex->listIndex
              }
            ]
          (* NOTE: We're filtering out _Rule here because each primitive wrapper can have additional options that can be set. *)
          &)/@(Cases[List@@listElement, Except[_Rule]])
        ),
        (* We just have a single primitive. *)
        listElement
      ]
    ],
    {sanitizedPrimitives, Range[Length[sanitizedPrimitives]]}
  ];

  (* Get our cache ball. *)
  cacheBall=Module[{modelContainerFields, objectContainerFields, objectSampleFields},
    modelContainerFields=SamplePreparationCacheFields[Model[Container],Format->List];
    objectContainerFields=SamplePreparationCacheFields[Object[Container],Format->List];
    objectSampleFields=SamplePreparationCacheFields[Object[Sample],Format->List];

    FlattenCachePackets@Quiet[
      With[{insertMe1=Packet@@objectSampleFields,insertMe2=Packet@@objectContainerFields},
        Download[
          {
            DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Sample]], Infinity], Object]],
            DeleteDuplicates[Download[Cases[flattenedPrimitives, ObjectReferenceP[Object[Container]], Infinity], Object]]
          },
          {
            {insertMe1, Packet[Container[objectContainerFields]],Packet[Container[Model[modelContainerFields]]]},
            {insertMe2, Packet[Contents[[All,2]][objectSampleFields]], Packet[Model[modelContainerFields]]}
          }
        ]
      ],
      {Download::FieldDoesntExist,Download::NotLinkField,Download::Part}
    ]
  ];

  (* Try to "autofill" the next primitive's input, if we find it missing. *)
  (* Automatically propagate the primary input from the previous primitive to the next primitive, unless the previous *)
  (* primitive is generative. This is so that we can more easily resolve the Volume key in DefineSample[...] inside of *)
  (* our simulation MapThread. *)
  primitivesWithPreresolvedInputs=If[Length[flattenedPrimitives]==1,
    flattenedPrimitives,
    (* Fold over our partition will pre-resolve all primitives. *)
    (* NOTE: We have to Fold here and not Map because if there is a sequence like: *)
    (* {Incubate[Sample->"taco"], Mix[Time->15 Minute], Mix[Time->15 Minute]} *)
    (* We need to propagate the "taco" to the first and second Mix primitives. Therefore, we need to map over our *)
    (* propagated list. *)
    FoldList[
      Function[{firstPrimitive, secondPrimitive},
        Module[{firstPrimitiveInformation, firstPrimitiveGenerativeQ, secondPrimitiveInformation, firstPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOption, secondPrimitivePrimaryInputOptionDefinition, secondPrimitiveGenerativeLabelOptions},
          (* For our primitive type, lookup the information about it from our primitive lookup. *)
          firstPrimitiveInformation=Lookup[allPrimitiveInformation, Head[firstPrimitive]];

          (* Are we dealing with a Generative primitive? *)
          firstPrimitiveGenerativeQ=Lookup[firstPrimitiveInformation, Generative];

          (* Lookup information about our second primitive. *)
          secondPrimitiveInformation=Lookup[allPrimitiveInformation, Head[secondPrimitive]];

          (* What option corresponds to the first input for each primitive type? *)
          firstPrimitivePrimaryInputOption=FirstOrDefault[Lookup[firstPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOption=FirstOrDefault[Lookup[secondPrimitiveInformation, InputOptions], Null];
          secondPrimitivePrimaryInputOptionDefinition=FirstCase[Lookup[secondPrimitiveInformation, OptionDefinition], KeyValuePattern["OptionSymbol"->secondPrimitivePrimaryInputOption]];
          secondPrimitiveGenerativeLabelOptions=Lookup[secondPrimitiveInformation, LabeledOptions][[All,2]];

          (* If we're dealing with a generative first primitive, we can't autofill our second primitive. *)
          If[MatchQ[firstPrimitiveGenerativeQ, True],
            secondPrimitive,
            (* Otherwise, we can pre-resolve our second primitive with the input from our first primitive, if we don't *)
            (* already have input information for our second primitive. *)
            (* Should we fill out the input to the second primitive? *)
            If[
              Or[
                KeyExistsQ[secondPrimitive[[1]], secondPrimitivePrimaryInputOption] && !MatchQ[Lookup[secondPrimitive[[1]], secondPrimitivePrimaryInputOption], ListableP[Automatic]],
                !(KeyExistsQ[firstPrimitive[[1]], firstPrimitivePrimaryInputOption] && !MatchQ[Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption], ListableP[Automatic]]),
                !MatchQ[
                  Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption],
                  ReleaseHold[Lookup[secondPrimitivePrimaryInputOptionDefinition,"Pattern"]]
                ]
              ],
              (* Primary input option to the second primitive is already filled out or the primary input option to the first primitive is not filled out. Nothing to do. *)
              secondPrimitive,
              (* Primary input option to the second primitive is NOT filled out. Fill it out using the first primitive's primary input. *)
              Head[secondPrimitive]@Prepend[
                secondPrimitive[[1]],
                secondPrimitivePrimaryInputOption->Lookup[firstPrimitive[[1]], firstPrimitivePrimaryInputOption]
              ]
            ]
          ]
        ]
      ],
      flattenedPrimitives
    ]
  ];

  (* Call each primitive's method resolver function, keeping track of any errors that were thrown. *)
  primitiveMessages=Map[
    Function[{primitive},
      Module[{primitiveInformation,primitiveResolverMethod,inputsFromPrimitiveOptions,optionsFromPrimitiveOptions,
        inputsWithAutomatics,potentialRawMethods,messageStrings,filteredMessageStrings,potentialMethods,evaluationData,
        conflictingPreparationAndMethodWrapperText,conflictingMethodResolverText},

        (* Lookup information about our primitive. *)
        primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];

        (* Lookup the method resolver function. *)
        primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];

        (* Separate out our primitive options into inputs and function options. *)
        inputsFromPrimitiveOptions=(#->Lookup[primitive[[1]], #, Automatic]&)/@Lookup[primitiveInformation, InputOptions];
        optionsFromPrimitiveOptions=Cases[
          Normal[primitive[[1]]],
          Verbatim[Rule][
            Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
            _
          ]
        ];

        (* Change the labels in our inputs into Automatics because they're not simulated yet. *)
        inputsWithAutomatics=Module[{primitiveInformation, primitiveOptionDefinitions},
          (* Lookup information about this primitive. *)
          primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
          primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

          (* Only bother swapping out labels with Automatics if we're dealing with an input option. This is because the *)
          (* method resolver function will not accept labels for the inputs, but will accept labels for the options. *)
          KeyValueMap[
            Function[{option, value},
              Module[{optionDefinition},
                (* Lookup information about this option. *)
                optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                (* Do does this option allow for PreparedSample or PreparedContainer? *)
                Which[
                  (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                  (* Cases will only look inside of lists, not associations. *)
                  Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                  (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                ]
              ]
            ],
            Association@inputsFromPrimitiveOptions
          ]
        ];

        (* Pass down the inputs and options down to the resolver function. *)
        evaluationData=Block[{$Messages},
          $Messages = {};
          EvaluationData[
            If[MatchQ[primitive, plateReaderPrimitiveP],
              ToList@primitiveResolverMethod[
                Sequence@@(inputsWithAutomatics[[All,2]]),
                Object[Protocol, Head[primitive]],
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Cache->cacheBall,
                    (* Pass down the Preparation option if our primitive was in a method wrapper. *)
                    If[!MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Null], Null] && !KeyExistsQ[primitive[[1]], Preparation],
                      Preparation->Lookup[primitive[[1]], PrimitiveMethod, Null]/.{
                        ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
                        RoboticSamplePreparation|RoboticCellPreparation->Robotic
                      },
                      Nothing
                    ]
                  }
                ]
              ],
              ToList@primitiveResolverMethod[
                Sequence@@(inputsWithAutomatics[[All,2]]),
                Join[
                  optionsFromPrimitiveOptions,
                  {
                    Cache->cacheBall,
                    (* Pass down the Preparation option if our primitive was in a method wrapper. *)
                    If[!MatchQ[Lookup[primitive[[1]], PrimitiveMethod, Null], Null] && !KeyExistsQ[primitive[[1]], Preparation],
                      Preparation->Lookup[primitive[[1]], PrimitiveMethod, Null]/.{
                        ManualSamplePreparation|ManualCellPreparation|Experiment -> Manual,
                        RoboticSamplePreparation|RoboticCellPreparation->Robotic
                      },
                      Nothing
                    ]
                  }
                ]
              ]
            ]
          ]
        ];

        (* Lookup from our evaluation data. *)
        potentialRawMethods=Lookup[evaluationData,"Result"];
        messageStrings=Lookup[evaluationData,"MessagesText"];

        (* Remove Warning::UnknownOption and remove the message heads. *)
        filteredMessageStrings=Function[{errorString},
          Module[{functionHead,functionMessage},
            (* Parse out the function head and the function message. *)
            {functionHead,functionMessage}=Check[
              First[StringCases[errorString,((x:(__~~"::"~~__))~~" : "~~y___):>{x,y}]],
              {Null,Null}
            ];

            (* If we weren't able to successfully parse our the message, don't throw anything. *)
            If[!MatchQ[{functionHead,functionMessage},{Null,Null}],
              (* Don't throw Warning::UnknownOption. RunUnitTest is a degenerate function that sometimes will throw things that we don't want. *)
              If[MatchQ[functionHead,"Warning::UnknownOption"],
                Nothing,
                functionMessage
              ]
            ]
          ]
        ]/@messageStrings;

        (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
        (* on the experiment function that we're in. *)
        conflictingPreparationAndMethodWrapperText=Module[{preparationOption, primitiveMethod},
          (* Lookup the preparation option. *)
          preparationOption=Lookup[primitive[[1]], Preparation, Null];
          primitiveMethod=Lookup[primitive[[1]], PrimitiveMethod, Null];

          (* If the preparation option was given and it doesn't match the primitive method, include an additional error. *)
          If[Or[
              MatchQ[preparationOption, Manual] && MatchQ[primitiveMethod, RoboticSamplePreparation|RoboticCellPreparation],
              MatchQ[preparationOption, Robotic] && MatchQ[primitiveMethod, ManualSamplePreparation|ManualCellPreparation|Experiment]
            ],
            "The preparation option for this unit operation was specified as "<>ToString[preparationOption]<>" but the primitive is placed in a "<>ToString[primitiveMethod]<>" group. Please resolve this conflict in order to generate a valid unit operation.",
            Nothing
          ]
        ];

        (* The given Preparation or method wrapper head doesn't support the methods returned by the method resolver function. *)
        conflictingMethodResolverText=Module[{preparationOption, primitiveMethod},
          (* Lookup the preparation option. *)
          preparationOption=Lookup[primitive[[1]], Preparation, Null];
          primitiveMethod=Lookup[primitive[[1]], PrimitiveMethod, Null];

          (* If the preparation option was given and it doesn't match the primitive method, include an additional error. *)
          Which[
            (* NOTE: This means that the primitive method resolver function is defined incorrectly in terms of taking in Automatics. *)
            (* Something didn't pattern match. Instead of yelling at the user, just quiet this. *)
            !MatchQ[potentialRawMethods, Manual|Robotic|_List],
              "",
            And[
              MatchQ[preparationOption, Robotic] || MatchQ[primitiveMethod, RoboticSamplePreparation|RoboticCellPreparation],
              !MemberQ[potentialRawMethods, Robotic]
            ],
              "The unit operation was specified as Robotic but based on the options/inputs specified, it is not compatible with the Robotic method. Please let the Preparation of this unit operation resolve automatically.",
            And[
              MatchQ[preparationOption, Manual] || MatchQ[primitiveMethod, ManualSamplePreparation|ManualCellPreparation],
              !MemberQ[potentialRawMethods, Manual]
            ],
              "The unit operation was specified as Manual but based on the options/inputs specified, it is not compatible with the Manual method. Please let the Preparation of this unit operation resolve automatically.",
            True,
              ""
          ]
        ];

        StringRiffle@Flatten@{
          filteredMessageStrings,
          conflictingPreparationAndMethodWrapperText,
          conflictingMethodResolverText
        }
      ]
    ],
    flattenedPrimitives
  ];

  (* Return JSON association. *)
  ExportJSON@{
    "Messages"->primitiveMessages
  }
];

(* Helper function to memoize the creation of a fake water sample in a 50mL tube. This is for speed. *)
simulateFakeWaterSample[]:=simulateFakeWaterSample[]=Module[{newContainerPackets, newContainerObject, simulationWithContainerPackets, newSamplePackets},
  (* Create a new container. *)
  (* DANGER: This uses the first shelf of the room temperature VLM. This is probably not a good idea and should be changed for something more sustainable. *)
  newContainerPackets = UploadSample[
    Model[Container, Vessel, "50mL Tube"],
    {"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]}, (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
    FastTrack->True,
    SimulationMode -> True,
    Upload -> False
  ];
  newContainerObject = Lookup[newContainerPackets[[1]], Object];

  (* Update it with the container packets. *)
  simulationWithContainerPackets = Simulation[newContainerPackets];

  (* Put some water in our container. *)
  newSamplePackets = UploadSample[
    Model[Sample, "Milli-Q water"],
    {"A1", newContainerObject},
    State->Liquid,
    InitialAmount->25 Milliliter,
    Simulation -> simulationWithContainerPackets,
    SimulationMode -> True,
    FastTrack->True,
    Upload -> False
  ];

  {
    newContainerObject,
    Lookup[newSamplePackets[[1]], Object],
    UpdateSimulation[simulationWithContainerPackets, Simulation[newSamplePackets]]
  }
];



(* ::Subsubsection::Closed:: *)
(*holdComposition*)


(* ::Code::Initialization:: *)
(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition,HoldAll];



(* ::Subsubsection::Closed:: *)
(*holdCompositionList*)


(* ::Code::Initialization:: *)
(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
  (* Join the held heads. *)
  joinedHelds=Join[helds];

  (* Swap the outter most hold with f. Then hold the result. *)
  With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionTimesList,HoldAll];



(* ::Subsubsection::Closed:: *)
(*stackableTipPositions/nonStackableTipPositions*)


(* ::Code::Initialization:: *)
(* "STARlet", "Super STAR", "microbioSTAR" *)
stackableTipPositions[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]|Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]|Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]|Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]]:={
  {"Deck Slot","Tip Carrier Slot 2","A1"},
  {"Deck Slot","Tip Carrier Slot 2","B1"},
  {"Deck Slot","Tip Carrier Slot 2","C1"},
  {"Deck Slot","Tip Carrier Slot 2","D1"},
  {"Deck Slot","Tip Carrier Slot 2","E1"}
};

(* "Super STAR", "microbioSTAR" *)

nonStackableTipPositions[Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]|Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]|Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  {"Deck Slot","Tip Carrier Slot 1","C1"},
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","Tip Carrier Slot 1","E1"}
};

(* "STARlet" *)

nonStackableTipPositions[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  {"Deck Slot","Tip Carrier Slot 1","C1"},
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","MALDI Carrier Slot","Tip Slot"}
};

(* "bioSTAR" and "microbioSTAR" *)
stackableTipPositions[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]|Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]:={};

nonStackableTipPositions[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]|Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]:={
  {"Deck Slot","Tip Carrier Slot 1","A1"},
  {"Deck Slot","Tip Carrier Slot 1","B1"},
  (* NOTE: We leave the third position on the first carrier empty as a tip hand off position. *)
  {"Deck Slot","Tip Carrier Slot 1","D1"},
  {"Deck Slot","Tip Carrier Slot 2","A1"},
  {"Deck Slot","Tip Carrier Slot 2","B1"},
  {"Deck Slot","Tip Carrier Slot 2","C1"},
  {"Deck Slot","Tip Carrier Slot 2","D1"}
};



(* ::Subsubsection::Closed:: *)
(*lookupPrimitiveDefinition*)


(* ::Code::Initialization:: *)
lookupPrimitiveDefinition[myPrimitiveName_Symbol]:=Lookup[Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[ExperimentP]], Primitives], myPrimitiveName];



(* ::Subsubsection::Closed:: *)
(*allActiveInstrumentPackets*)

(* function that gets all active instrument packets and memoizes it so that SimulateResources can go fast and stay fast *)
allActiveInstrumentPackets[myTypes:{TypeP[]...}]:=Module[
  {cache, relevantCache},
  cache = allActiveInstrumentPacketsCache["Memoization"];

  (* do this so that we're not calling DatabaseMemberQ on every instrument in the database; only on the ones that we actually care about *)
  relevantCache = Select[cache, MemberQ[myTypes, Model @@ Lookup[#, Type]]&];
  PickList[relevantCache,DatabaseMemberQ[relevantCache]]
];

allActiveInstrumentPacketsCache[fakeString_String]:=allActiveInstrumentPacketsCache[fakeString] = Module[
  {allInstruments},
  (*Add allActiveInstrumentPackets to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`allActiveInstrumentPacketsCache];

  allInstruments = Search[Object[Instrument], Status != Retired && DeveloperObject!=True];
  Download[allInstruments, Packet[Model, Site]]
];

(* ::Subsubsection::Closed:: *)
(*hamiltonTipModelSearch*)

(* memoized search for hamilton tips *)
hamiltonTipModelSearch[fakeString_String]:=hamiltonTipModelSearch[fakeString] = Module[
  {},

  (*Add hamiltonTipModelSearch to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`hamiltonTipModelSearch];

  Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True && DeveloperObject != True]

];


(* ::Subsubsection::Closed:: *)
(*hamiltonRackModelSearch*)

(* memoized search for hamilton tips *)
hamiltonRackModelSearch[fakeString_String]:=hamiltonRackModelSearch[fakeString] = Module[
  {},

  (*Add hamiltonRackModelSearch to list of Memoized functions*)
  AppendTo[$Memoization,Experiment`Private`hamiltonRackModelSearch];

  Search[{Model[Container, Rack], Model[Container, Spacer]}, LiquidHandlerPrefix != Null && DeveloperObject != True]

];

(* ::Subsubsection::Closed:: *)
(*SimulateResources*)


(* ::Code::Initialization:: *)
(* Helper Functions *)
DefineOptions[
  SimulateResources,
  Options:>{
    {PooledSamplesIn -> Null, ListableP[ListableP[Null|ObjectP[Object[Sample]]]], "The SamplesIn in their pooling form, if the function that's calling SimulateResources is a pooling function. This option MUST be passed for pooling functions since SamplesIn in the protocol object is flattened and we need information about the pooling groups to do aliquot resolving."},
    {IgnoreWaterResources -> False, BooleanP, "Indicates if resources picking water models should NOT be simulated.  This is specifically relevant when SimulateProcedure calls SimulateResources, because otherwise simulated resource picking would not properly replicate what happens in the lab."},
    CacheOption,
    SimulationOption,
    ParentProtocolOption}
];

Warning::AmbiguousNameResources="The following resource names, `1`, were detected in resources with different resource parameters inside of the protocol packet, `2`, when passed down to SimulateResources. Make sure to only pass down resources with unique names for unique sets of resource parameters.";
Error::SimulateResourcesInvalidBacklink="The following link, `1`, was specified for the following field, `2`, in UploadResources, however, this object type is not specified in that field's Relations. Please run ValidUploadQ to find the invalid field before calling SimulateResources.";

(* NOTE: OptionsPattern[] thinks that {} can be part of options, so we have to define the main overload first. *)
(* Do NOT reorder the definitions of SimulateResources here. *)
SimulateResources[
  myProtocolPacket:PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}, {Object}],
  myAccessoryPacket:{PacketP[]...}|Null,
  myOptions:OptionsPattern[SimulateResources]
]:=Module[
  {safeOptions, cache, simulation, parentProtocol, finalProtocolPacket, finalProtocolPacketWithoutNameOption, finalAccessoryPacket, uploadResult, currentSimulation, accessoryObjects},

  (* Get our options. *)
  safeOptions=SafeOptions[SimulateResources, ToList[myOptions]];
  cache=Lookup[safeOptions, Cache];
  simulation=Lookup[safeOptions, Simulation];
  parentProtocol=Lookup[safeOptions, ParentProtocol];

  (* We have to detect and replace any resources that had the same name but different resource parameters. This will cause *)
  (* UploadProtocol to fail. *)
  {finalProtocolPacket, finalAccessoryPacket}=Module[{allResources, badResourceNames, badResources, badResourceReplaceRules},
    (* First, detect any resources that have the same name but different resource parameters. This will cause UploadProtocol to fail. *)
    allResources = DeleteDuplicates[Cases[{myProtocolPacket, myAccessoryPacket}, _Resource, Infinity]];
    badResourceNames = (If[!SameQ@@#, #[[1]][Name], Nothing]&)/@GatherBy[allResources, (If[!MatchQ[#[Name], _String], CreateUUID[], #[Name]]&)];
    badResources = Select[allResources, (MatchQ[#[Name], Alternatives@@badResourceNames]&)];

    (* If we found bad resources, we will throw a warning if we're logged in as a developer. *)
    If[Length[badResources] && MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
      Message[Warning::AmbiguousNameResources, badResourceNames, Lookup[myProtocolPacket, Object]];
    ];

    (* Replace these bad resources in our protocol/accessory packets. *)
    badResourceReplaceRules=(# -> Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@badResources;

    {myProtocolPacket/.badResourceReplaceRules, myAccessoryPacket/.badResourceReplaceRules}
  ];

  (* UploadProtocol tries to pull out the name option from the ResolvedOptions field, so drop it because otherwise *)
  (* DuplicateName error is thrown *)
  finalProtocolPacketWithoutNameOption=If[KeyExistsQ[finalProtocolPacket,ResolvedOptions],
    Module[{tempFinalProtocolPacket},
      tempFinalProtocolPacket=finalProtocolPacket;
      tempFinalProtocolPacket[ResolvedOptions]=KeyDrop[Lookup[finalProtocolPacket,ResolvedOptions,{}],Name];
      tempFinalProtocolPacket
    ],
    finalProtocolPacket
  ];

  (* Upload our protocol object, get back all of the resources etc. *)
  uploadResult=If[MatchQ[finalAccessoryPacket, {}],
    UploadProtocol[
      finalProtocolPacketWithoutNameOption,
      Simulation->simulation,
      ParentProtocol->parentProtocol,
      (* NOTE: This option will make it such that simulated samples are not attempted to be put into the PreparedSamples field. *)
      (* This functionality is intended when preparing samples via the PreparatoryUnitOperations option. *)
      IgnorePreparedSamples->True,
      SkipUploadProtocolStatus->True,
      SimulationMode -> True,
      Upload->False
    ],
    UploadProtocol[
      finalProtocolPacketWithoutNameOption,
      finalAccessoryPacket,
      Simulation->simulation,
      ParentProtocol->parentProtocol,
      (* NOTE: This option will make it such that simulated samples are not attempted to be put into the PreparedSamples field. *)
      (* This functionality is intended when preparing samples via the PreparatoryUnitOperations option. *)
      IgnorePreparedSamples->True,
      SkipUploadProtocolStatus->True,
      SimulationMode -> True,
      Upload->False
    ]
  ];

  (* Make our upload result into a simulation. *)
  currentSimulation=If[MatchQ[simulation, Null],
    UpdateSimulation[Simulation[],Simulation[Packets->ToList[uploadResult]]],
    UpdateSimulation[simulation,Simulation[Packets->ToList[uploadResult]]]
  ];

  (* Get the accessory objects. *)
  accessoryObjects=If[MatchQ[finalAccessoryPacket,{PacketP[]..}],
    Lookup[finalAccessoryPacket, Object],
    Null
  ];

  (* Call the main overload. *)
  SimulateResources[
    Lookup[finalProtocolPacketWithoutNameOption, Object],
    accessoryObjects,
    Simulation->currentSimulation,
    ParentProtocol->parentProtocol,
    Cache->cache,
    PooledSamplesIn->Lookup[ToList[myOptions], PooledSamplesIn, Null]
  ]
];

SimulateResources[
  protocol:PacketP[{Object[Protocol], Object[Maintenance], Object[Qualification]}, {Object}],
  myOptions:OptionsPattern[SimulateResources]
]:=Module[{},
  SimulateResources[protocol, Null, myOptions]
];

Error::RequiredPooledSamplesIn="The option PooledSamplesIn MUST be specified to SimulateResources if given a non SP Object[Protocol] that relates to a pooling experiment function. The PooledSamplesIn option should be of the same level of listing as the resolved options specified in the ResolvedOptions field.";
SimulateResources[
  myProtocol:ObjectReferenceP[{Object[Protocol], Object[Maintenance], Object[Qualification]}],
  myAccessoryObjects:{(ObjectReferenceP[]|LinkP[])...}|Null,
  myOptions:OptionsPattern[SimulateResources]
]:=Module[
  {
    currentSimulation,unavailableObjectPackets,availablePackets, fields,targetlabeledObjectsResourceBlobs,okSamplePositions,
    resourceFilteredDownload,fulfilledSamplePositions,unfulfilledSamplePositions,requiredResources,resourceData,resourceSampleData,
    resourceSampleContainerModels,duplicateFreeResourceData,duplicateFreeSampleData, newSampleInputs,samplesWithContainerResources,samplesWithContainerResourcesNoDup,
    samplesWithoutContainerResources,newContainersForSamplesNoDup,newContainersForSamples,newContainersForSamplePackets,allContainers,allWells,allSamples,allAmounts,
    newSampleWithHistoryPackets,newSamplePackets,newSamples,allResources,sampleResourceUpdatePackets,resourceToSampleRules,linkReplace,
    typeToBackLinkRules,pickedResourcesPackets,protocolResourceDownload,accessoryPacketObjects,instrumentStatusPackets,
    fieldDownloadCache,notebook,updatePackets,fulfilledResourcesToSamples,unfulfilledResourceToSampleRules, targetlabeledObjectsResourcePackets,
    targetInstrumentResources, okInstrumentPositions,instrumentResourceFilteredDownload,fulfilledInstrumentPositions,fulfilledResourcesToInstruments,
    unfulfilledInstrumentPositions,unfulfilledInstrumentResourceModels,unfulfilledInstrumentResources, potentialInstrumentObjectsForModels,
    unfulfilledResourceToInstruments, instrumentResourceUpdatePackets,safeOptions,cache,simulation,parentProtocol,simulatedProtocolPacket,
    experimentFunction, protocolPacket, accessoryPackets, unavailableInstrumentPackets, resourceInstrumentData, allInstrumentPackets,
    protocolFields, accessoryPacketFields, potentialInstrumentObjectsForModelsPackets, notAvailableInstrumentPackets,
    containerResourcesToFulfill, allResourcePackets, containerResourceUpdatePackets, targetlabeledObjectsResourcePacketsWithWaters,
    ignoreWaterResources, protocolSite
  },

  (* Get our options. *)
  safeOptions=SafeOptions[SimulateResources, ToList[myOptions]];
  cache=Lookup[safeOptions, Cache];
  simulation=Lookup[safeOptions, Simulation];
  parentProtocol=Lookup[safeOptions, ParentProtocol];
  ignoreWaterResources = Lookup[safeOptions, IgnoreWaterResources];

  (* Set our current simulation. *)
  currentSimulation=If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Figure out our accessory packet objects. *)
  accessoryPacketObjects=If[MatchQ[myAccessoryObjects, {(ObjectP[]|LinkP[])..}],
    Download[myAccessoryObjects, Object],
    {}
  ];

  (* get all the protocol object fields because doing Packet[All] doesn't work well *)
  protocolFields = Packet @@ Fields[Download[myProtocol, Type], Output -> Short];

  (* need to get a little more creative with the accessory packets because if they aren't all one type, then you can't do this trick *)
  accessoryPacketFields = If[Not[NullQ[myAccessoryObjects]] && Length[DeleteDuplicates[Download[myAccessoryObjects, Type]]] == 1,
    Packet @@ Fields[Download[myAccessoryObjects[[1]], Type], Output -> Short],
    Packet[All]
  ];

  (* download from the protocol's required resources *)
  (* NOTE: We download ALL fields in the protocol object and accessory object since we have to lookup the value of fields in them to *)
  (* replace with resources. The alternative way this used to work is to download RequiredResources first, then only download the backlink *)
  (* fields in the protocol/accessory objects, but since everything is simulated it shouldn't actually hit the database and thus is better *)
  (* to download everything up front. *)
  {protocolResourceDownload, protocolPacket, accessoryPackets}=Quiet[
    Download[
      {
        Join[{myProtocol}, accessoryPacketObjects],
        {myProtocol},
        accessoryPacketObjects
      },
      {
        {
          RequiredResources,
          Packet[RequiredResources[[All,1]][{Sample,Models,ContainerModels,ContainerName,Well,Amount,Instrument,InstrumentModels, ContainerResource}]],
          Packet[RequiredResources[[All,1]][Sample][{Composition,Model,Status,CurrentProtocol}]],
          RequiredResources[[All,1]][Sample][Container][Model][Object],
          Packet[RequiredResources[[All, 1]][Instrument][{Model, Status, CurrentProtocol}]]
        },
        {protocolFields},
        {accessoryPacketFields}
      },
      Simulation->currentSimulation
    ],
    {Download::NotLinkField,Download::FieldDoesntExist,Download::ObjectDoesNotExist}
  ];

  protocolPacket=FirstOrDefault@Flatten[protocolPacket];
  protocolSite = Download[Lookup[protocolPacket, Site], Object];
  accessoryPackets=Flatten[accessoryPackets];
  (* NOTE: We can get some $Failed results in our download, so we need to transform those into empty lists before we can call Join. *)
  protocolResourceDownload=(Join@@(#/.{$Failed->{}})&)/@Transpose[protocolResourceDownload];

  (* NOTE: We have to strip link IDs here because the logic that uses this cache depends on it. *)
  fieldDownloadCache=Flatten[{protocolPacket, accessoryPackets}]/.link_Link:>RemoveLinkID[link];

  (* find the sample packets that are not available and whose currentprotocol isn't the input protocol *)
  unavailableObjectPackets=Cases[protocolResourceDownload[[3]],KeyValuePattern[{Status->Except[Available],CurrentProtocol->Except[LinkP[myProtocol]]}]];
  unavailableInstrumentPackets = Cases[protocolResourceDownload[[5]],KeyValuePattern[{Status->Except[Available],CurrentProtocol->Except[LinkP[myProtocol]]}]];

  (* create packets to set any of the unavailable samples to available *)
  availablePackets=If[!MatchQ[Flatten[{unavailableObjectPackets, unavailableInstrumentPackets}],{}],
    (* NOTE: We should technically be using UploadSampleStatus/UploadInstrumentStatus here, but that function will do a lot of un-necessary things like *)
    (* busing the ReadyCheck cache. We do this for speed. *)
    (
      <|
        Object->#,
        Status->Available,
        CurrentProtocol->Null
      |>
    &)/@Lookup[Flatten[{unavailableObjectPackets, unavailableInstrumentPackets}],Object],
    {}
  ];

  (* the list of fields in the second column of RequiredResources *)
  fields=Cases[First[protocolResourceDownload][[All,2]], Except[Null]];

  (* no fields to look at, return early *)
  If[MatchQ[fields,{}],
    Return[currentSimulation];
  ];

  (* find any resources pointing to the target fields *)
  targetlabeledObjectsResourceBlobs=Download[
    Cases[First[protocolResourceDownload],{ObjectP[Object[Resource,Sample]],Alternatives@@fields,_,_}][[All,1]],
    Object
  ];
  targetInstrumentResources=Download[
    Cases[First[protocolResourceDownload],{ObjectP[Object[Resource,Instrument]],Alternatives@@fields,_,_}][[All,1]],
    Object
  ];

  (* get the packets for the resources we're going to fulfill, and pull out the container resources, if applicable *)
  targetlabeledObjectsResourcePacketsWithWaters = fetchPacketFromCache[#, protocolResourceDownload[[2]]]& /@ targetlabeledObjectsResourceBlobs;

  (* if IgnoreWaterResources -> True, filter out the water resources here *)
  (* we do this because SimulateProcedure's use of SimulateResources really does not want us to simulate fulfilling water resources because it doesn't replicate how it ever actually happens in the lab and thus messes with the framework *)
  targetlabeledObjectsResourcePackets = If[TrueQ[ignoreWaterResources],
    DeleteCases[targetlabeledObjectsResourcePacketsWithWaters, KeyValuePattern[{ContainerResource -> ObjectP[]}]],
    targetlabeledObjectsResourcePacketsWithWaters
  ];

  containerResourcesToFulfill = Download[
    Cases[Lookup[targetlabeledObjectsResourcePackets, ContainerResource], ObjectP[]],
    Object
  ];

  (* Set all of our resources to be picked. *)
  pickedResourcesPackets=(<|Object->#, Status->InUse|>&)/@Flatten[{Lookup[targetlabeledObjectsResourcePackets, Object, {}], containerResourcesToFulfill}];

  (* update our simulation *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[Packets->Flatten[{pickedResourcesPackets, availablePackets}]]];

  (* find any resource positions that are of type Object[Resource, Instrument] *)
  okInstrumentPositions=Position[
    Download[First[protocolResourceDownload][[All,1]],Object],
    ObjectP[targetInstrumentResources],
    1,
    Heads->False
  ];

  (* extract only the data relating to resources of interest *)
  instrumentResourceFilteredDownload=Extract[#,okInstrumentPositions]&/@protocolResourceDownload;

  (* find the positions of resources that aren't already pointing to an Object so we can skip it, unless that object needs to be in a different container model *)
  fulfilledInstrumentPositions=Position[
    instrumentResourceFilteredDownload[[2]],
    _?(MatchQ[Lookup[#,Instrument],ObjectP[Object[Instrument]]]&),
    1,
    Heads->False
  ];

  (* Create rules of existing fulfilled resources to their fulfilled instruments. *)
  fulfilledResourcesToInstruments=(
    Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Object], Object]->Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Instrument], Object]
  &)/@Flatten[fulfilledInstrumentPositions];

  (* get the positions that remain unfulfilled *)
  unfulfilledInstrumentPositions=DeleteCases[List/@Range[Length[First[instrumentResourceFilteredDownload]]],Alternatives@@fulfilledInstrumentPositions];

  (* Get the instrument resources that still need to be fulfilled and the instrument models that will fulfill them. *)
  {unfulfilledInstrumentResources, unfulfilledInstrumentResourceModels}=If[Length[Flatten[unfulfilledInstrumentPositions]]==0,
    {{},{}},
    Transpose[
      ({
        Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], Object], Object],
        Download[Lookup[instrumentResourceFilteredDownload[[2]][[#]], InstrumentModels], Object]
      }&)/@Flatten[unfulfilledInstrumentPositions]
    ]
  ];

  (* Search for instrument objects that aren't deprecated that will fulfill these resources. *)
  (* if we don't have any instrument resources then don't bother doing this *)
  allInstrumentPackets = If[MatchQ[unfulfilledInstrumentResourceModels, {}],
    {},
    allActiveInstrumentPackets[DeleteDuplicates[Download[Flatten[unfulfilledInstrumentResourceModels], Type]]]
  ];

  (* get the instrument objects specific to our instruments in question; must be the correct site *)
  potentialInstrumentObjectsForModels = Map[
    Function[{instrumentModels},
      (* if we don't actually know the protocol's site, then just pick whatever *)
      ToList[Lookup[SelectFirst[allInstrumentPackets, MatchQ[Lookup[#, Model], ObjectP[instrumentModels]] && (NullQ[protocolSite] || MatchQ[Lookup[#, Site], ObjectP[protocolSite]])&, {}], Object, {}]]
    ],
    unfulfilledInstrumentResourceModels
  ];

  (* get the instrument packets for the things objects we're going for *)
  potentialInstrumentObjectsForModelsPackets = Download[potentialInstrumentObjectsForModels, Packet[Status]];

  (* Link up these instrument resources to an acceptable instrument. *)
  (* NOTE: If there are no non-retired-or-undergoing maintenance objects, we'll replace with Null here. *)
  {unfulfilledResourceToInstruments, instrumentResourceUpdatePackets}=If[Length[unfulfilledInstrumentResources]==0,
    {{},{}},
    Transpose@MapThread[
      Function[{instrumentResource, instrumentPackets},
        {
          instrumentResource->FirstOrDefault[Lookup[instrumentPackets, Object, {}], Null],
          <|
            Object->instrumentResource,
            Instrument->Link[FirstOrDefault[Lookup[instrumentPackets, Object, {}], Null]],
            Status->InUse
          |>
        }
      ],
      {unfulfilledInstrumentResources, potentialInstrumentObjectsForModelsPackets}
    ]
  ];

  (* NOTE 2: If we only ended up with UndergoingMaintenance ones, we need to set the instrument back to Available manually here; this is only in simulation land so we're not actually messing it up *)
  (* theoretically that can cause problems if the UndergoingMaintenance (or I suppose Running) instrument is not in its base state, but that's better than nothing *)
  notAvailableInstrumentPackets = Select[Flatten[potentialInstrumentObjectsForModelsPackets], MatchQ[Lookup[#, Status], UndergoingMaintenance|Running]&];
  instrumentStatusPackets = UploadInstrumentStatus[
    Lookup[notAvailableInstrumentPackets, Object, {}],
    Available,
    FastTrack -> True,
    SimulationMode -> True,
    Upload -> False,
    (* this is SUPER DUMB but seemingly UploadInstrumentStatus will not allow anything to set UndergoingMaintenance instruments to Available except for quals if they failed the previous qual *)
    (* this means that if the instrument the above Search found is UndergoingMaintenance from a failed qual, we're not going to actually set it to Available which can mess with procedure simulation later *)
    (* to get around this, I need to spoof a qual to do this setting back to Available.  Since UploadInstrumentStatus Downloads the CurrentInstruments field of the UpdatedBy, I need to make a fake packet to get {} so it doesn't throw ObjectDoesNotExist errors *)
    (* again agreed that this is super dumb.  But this allows us to be a little less dependent on the current state of the lab when simulating resources *)
    UpdatedBy -> <|Object -> SimulateCreateID[Object[Qualification, EngineBenchmark]], CurrentInstruments -> {}|>
  ];

  (* find any resource positions that are of type Object[Resource, Sample] *)
  (* NOTE: In certain cases, when there are too many resources, Position can error out with a recursion limit when using ObjectP. *)
  (* Since we're downloading objects here, Alterantives should be fine. *)
  okSamplePositions=Position[
    Download[First[protocolResourceDownload][[All,1]],Object],
    Alternatives@@Lookup[targetlabeledObjectsResourcePackets, Object, {}],
    1,
    Heads->False
  ];

  (* extract only the data relating to resources of interest *)
  resourceFilteredDownload=Extract[#,okSamplePositions]&/@protocolResourceDownload;

  (* find the positions of resources that aren't already pointing to an Object so we can skip it, unless that object needs to be in a different container model *)
  (* note that index 4 here refers to the container model; this used to be Last, but we added an extra value to Download and that caused issues *)
  fulfilledSamplePositions=Position[
    Transpose[{resourceFilteredDownload[[2]],resourceFilteredDownload[[4]]}],
    _?(
      And[
        MatchQ[Lookup[First[#],Sample],ObjectP[{Object[Sample],Object[Part],Object[Item],Object[Container],Object[Plumbing],Object[Wiring]}]],
        (
          Or[
            MatchQ[Lookup[First[#],ContainerModels],{}],
            MemberQ[Download[Lookup[First[#],ContainerModels],Object],Download[Last[#],Object]]
          ]
        )
      ]
    &),
    1,
    Heads->False
  ];

  (* Create rules of existing fulfilled resources to their fulfilled samples/containers. *)
  fulfilledResourcesToSamples=(
    Download[Lookup[resourceFilteredDownload[[2]][[#]], Object], Object]->Download[Lookup[resourceFilteredDownload[[2]][[#]], Sample], Object]
  &)/@Flatten[fulfilledSamplePositions];

  (* get the positions that remain unfulfilled *)
  unfulfilledSamplePositions=DeleteCases[List/@Range[Length[First[resourceFilteredDownload]]],Alternatives@@fulfilledSamplePositions];

  (* extract the download data that is okay to fake *)
  {requiredResources,resourceData,resourceSampleData,resourceSampleContainerModels,resourceInstrumentData}=Extract[#,unfulfilledSamplePositions]&/@resourceFilteredDownload;

  (* remove any repeated resources from the resourceData and resourceSampleData so we don't create extra objects *)
  {duplicateFreeResourceData,duplicateFreeSampleData}=If[Length[resourceData]>0,
    Transpose[
      DeleteDuplicatesBy[
        Transpose[{resourceData,resourceSampleData}],
        (Lookup[First[#],Object]&)
      ]
    ],
    {{}, {}}
  ];

  (* create all the information needed to call UploadSample *)
  newSampleInputs=MapThread[
    Function[{resourcePacket,resourceSample},
      Module[{model,initialAmount,newContainerModel,containerName,well},

        (* model of thing to create *)
        model=If[!MatchQ[Lookup[resourcePacket,Models],{}],
          (* the first item in models list if there's something there *)
          First[Lookup[resourcePacket,Models]],
          (* the model of the sample, otherwise its composition *)
          FirstCase[
            Quiet[Lookup[resourceSample,{Model,Composition}]],
            Except[Null]
          ]
        ];

        (* amount of thing to create *)
        initialAmount = Switch[Lookup[resourcePacket, Amount],
          UnitsP[Unit], Unitless[Floor[Lookup[resourcePacket, Amount]]],
          UnitsP[], Lookup[resourcePacket, Amount],
          _, Null
        ];

        (* container of new thing *)
        newContainerModel=Which[

          (* a specific model is requested, pick the first one *)
          Length[Lookup[resourcePacket,ContainerModels]]>0,First[Lookup[resourcePacket,ContainerModels]],

          (* none requested but it's a mass or volume, choose the preferred container *)
          MatchQ[initialAmount,(MassP|VolumeP)],PreferredContainer[initialAmount],

          (* non-self contained sample, stick it in 50 mL tube *)
          MatchQ[model,NonSelfContainedSampleModelP],Model[Container,Vessel,"50mL Tube"],

          (* otherwise put it in the empty simulation room *)
          True, Object[Container, Room, "id:AEqRl9KmEAz5"]
        ];

        (* If there is no container name, the container is always unique. *)
        containerName=Lookup[resourcePacket,ContainerName]/.{Null->CreateUUID[]};
        well=Lookup[resourcePacket,Well];

        (* return each resource with its model, amount, and container *)
        {Lookup[resourcePacket,Object],model,initialAmount,newContainerModel,containerName,well}
      ]
    ],
    {duplicateFreeResourceData,duplicateFreeSampleData}
  ];

  (* split the new objects into those that also need a container made and those that do not *)
  (* Only need to create one container for each ContainerName *)
  samplesWithContainerResources=Cases[newSampleInputs,{_,_,_,ObjectP[Model[Container]],_,_}];
  samplesWithContainerResourcesNoDup=GatherBy[samplesWithContainerResources,(#[[-2]])&];
  (* ValidResourceQ guarantees that we have ContainerModels if we have ContainerName so no need to consider it here *)
  samplesWithoutContainerResources=Cases[newSampleInputs,{_,_,_,Object[Container, Room, "id:AEqRl9KmEAz5"],_,_}]; (* Object[Container, Room, "Empty Room for Simulated Objects"] *)

  (* get the notebook of our protocol packet. *)
  notebook=Lookup[fetchPacketFromCache[myProtocol, fieldDownloadCache], Notebook];

  (* make containers for those samples that need it *)
  newContainersForSamplePackets=If[Length[samplesWithContainerResources]>0,
    UploadSample[
      samplesWithContainerResourcesNoDup[[All,1,-3]],
      ConstantArray[{"A1",Object[Container, Room, "id:AEqRl9KmEAz5"]}, Length[samplesWithContainerResourcesNoDup]], (* Object[Container,Room,"Empty Room for Simulated Objects"] *)
      Notebook->notebook,
      UpdatedBy->myProtocol,
      SimulationMode->True,
      FastTrack->True,
      Upload->False,
      Simulation->currentSimulation
    ],
    {}
  ];

  (* update our simulation *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[Packets->newContainersForSamplePackets]];

  (* get the new container packets from all the packets *)
  newContainersForSamplesNoDup=If[Length[samplesWithContainerResourcesNoDup]>0,
    Take[newContainersForSamplePackets,Length[samplesWithContainerResourcesNoDup]],
    {}
  ];
  newContainersForSamples=Flatten@MapThread[
    ConstantArray[#1,Length[#2]]&,
    {newContainersForSamplesNoDup,samplesWithContainerResourcesNoDup}
  ];

  (* rejoin the lists of resources, containers, samples, and amounts *)
  allResources=Join[samplesWithContainerResources[[All,1]],samplesWithoutContainerResources[[All,1]]];
  allResourcePackets = fetchPacketFromCache[#, protocolResourceDownload[[2]]]& /@ allResources;
  allContainers=Join[newContainersForSamples,samplesWithoutContainerResources[[All,-3]]];
  allWells=Join[(samplesWithContainerResources[[All,-1]])/.{Null->"A1"},ConstantArray["A1",Length[samplesWithoutContainerResources]]];
  allSamples=Join[samplesWithContainerResources[[All,2]],samplesWithoutContainerResources[[All,2]]];
  allAmounts=Join[samplesWithContainerResources[[All,3]],samplesWithoutContainerResources[[All,3]]];

  (* upload the new samples into A1 of their corresponding containers with the initial amounts *)
  newSampleWithHistoryPackets=If[Length[allSamples]>0,
    UploadSample[
      allSamples,
      MapThread[
        {#1,#2}&,
        {allWells,allContainers}
      ],
      InitialAmount->allAmounts,
      FastTrack->True,
      Notebook->notebook,
      Upload->False,
      UpdatedBy->myProtocol,
      SimulationMode->True,
      Simulation->currentSimulation
    ],
    {}
  ];

  (* drop the sample history packets because they break ValidUploadQ *)
  newSamplePackets=KeyDrop[#,{Append[SampleHistory],Replace[SampleHistory]}]&/@newSampleWithHistoryPackets;

  (* grab the new samples *)
  newSamples=Download[Take[newSamplePackets,Length[allSamples]],Object];

  (* create packets to update the resources and to relate resources to their samples *)
  {sampleResourceUpdatePackets,unfulfilledResourceToSampleRules}=If[Length[allResources]>0,
    Transpose[
      MapThread[
        {
          <|
            Object->#1,
            Sample->Link[#2],
            Status->InUse
          |>,
          #1->#2
        }&,
        {allResources,newSamples}
      ]
    ],
    {{}, {}}
  ];

  (* create packets to update the container resources (if applicable) with the containers of the corresponding water samples *)
  containerResourceUpdatePackets = MapThread[
    If[MatchQ[Lookup[#1, ContainerResource], ObjectP[Object[Resource, Sample]]],
      <|
        Object -> Download[Lookup[#1, ContainerResource], Object],
        Sample -> Link[#2],
        Status -> InUse
      |>,
      Nothing
    ]&,
    {allResourcePackets, allContainers}
  ];


  (* Join all of our resource to sample rules. *)
  resourceToSampleRules=Join[unfulfilledResourceToSampleRules,fulfilledResourcesToSamples,unfulfilledResourceToInstruments,fulfilledResourcesToInstruments];

  (* function to swap link objects *)
  linkReplace:=Function[
    {backLinkRules,oldLink,newTarget},
    ReplaceAll[
      oldLink,
      Link[_,___]:>DeleteCases[Link[newTarget,Sequence@@(newTarget[Type]/.backLinkRules)],Nothing]
    ]
  ];

  (* create a list of rules pointing a field position to their expected backlink *)
  typeToBackLinkRules:=Function[
    {fieldRelations},
    Flatten[
      ReplaceAll[
        fieldRelations,
        {
          (type:Object[__])[backLink___] :> (#->{backLink}&/@Types[type]),
          (type:Object[__]) :> (#->Nothing &/@Types[type]),
          (Model[__][__]|Model[__]):>Nothing
        }
      ]
    ]
  ];

  (* For each of our packets, create updates to replace any models with the objects that we created. *)
  updatePackets=MapThread[
    Function[{object, objectRequiredResources},
      Module[{groupedResources, packet, replacedFields},
        (* group resources/samples by the field they are going to *)
        groupedResources=GroupBy[
          (* NOTE: Only include resources here for which we have replace rules. *)
          (* Follows the logic above about how we only replace things visible in the main protocol object. *)
          Cases[objectRequiredResources/.{link:LinkP[]:>Download[link,Object]}, {Alternatives@@resourceToSampleRules[[All,1]], _, _, _}]/.resourceToSampleRules,
          (#[[2]]&)->(DeleteCases[{Download[#[[1]], Object],#[[3]],#[[4]]},Null]&)
        ];

        (* fetch the packet for this object. *)
        (* this is so that we can get the current value of the field that we're slotting in our resource value into. *)
        packet=fetchPacketFromCache[object, fieldDownloadCache];

        (* go through every field that is being altered and insert the new sample links *)
        replacedFields=KeyValueMap[
          Function[{field,samplesAndPositions},
            Module[{fieldContents,fieldRelations,listedFieldRelations,newLink,keyedPosition,subFieldRelations,listedSubFieldRelations,replacements,backlinkRules,specificContents,typesInRelations},
              (* see where the links in this field are supposed to go *)
              fieldRelations=LookupTypeDefinition[object[Type][field],Relation];
              listedFieldRelations = If[MatchQ[fieldRelations, _Alternatives],
                List @@ fieldRelations,
                ToList[fieldRelations]
              ];

              (* lookup the current contents of the field *)
              fieldContents=Lookup[packet,field];

              (* act based on whether we're working on a single field or any other type of field *)
              Switch[Rest[First[samplesAndPositions]],
                (* single field (not named single) *)
                {},
                  (* replace the current link with a link to the new sample *)
                  Module[{},
                    backlinkRules=typeToBackLinkRules[listedFieldRelations];
                    typesInRelations=Cases[
                      listedFieldRelations,
                      (type : Object[___] | Model[___])|(type : (Object[___] | Model[___]))[___]  :> type,
                      Infinity
                    ];

                    (* Make sure that the contents in the upload packet can actually be uploaded. *)
                    If[!MatchQ[fieldContents, ObjectP[typesInRelations]],
                      Message[Error::SimulateResourcesInvalidBacklink, ToString[fieldContents], field];

                      Return[$Failed, Module];
                    ];

                    field->linkReplace[backlinkRules,fieldContents,First[First[samplesAndPositions]]]
                  ],
                _,
                  (* not a single field *)
                  replacements=Map[
                    Function[{sampleAndPosition},

                      (* wrap key around any field names *)
                      keyedPosition=Replace[Rest[sampleAndPosition],x_Symbol:>Key[x],{1}];

                      subFieldRelations=Switch[keyedPosition,
                        {Key[_Symbol]},First[First[keyedPosition]]/.fieldRelations (* Named Single *),
                        {_Integer} && Or[MatchQ[fieldRelations, _Alternatives],TypeQ[fieldRelations]],fieldRelations, (* Multiple *)
                        {_Integer}, fieldRelations[[Last[keyedPosition]]], (* Indexed Single *)
                        {_Integer,_Integer},fieldRelations[[Last[keyedPosition]]] (* Indexed Multiple *),
                        {_Integer,Key[_Symbol]},First[Last[keyedPosition]]/.fieldRelations (* Named Multiple *)
                      ];

                      listedSubFieldRelations=If[MatchQ[subFieldRelations,_Alternatives],
                        List@@subFieldRelations,
                        ToList[subFieldRelations]
                      ];

                      backlinkRules=typeToBackLinkRules[listedSubFieldRelations];
                      typesInRelations=Cases[
                        Flatten[listedFieldRelations],
                        (type : Object[___] | Model[___])|(type : (Object[___] | Model[___]))[___]  :> type,
                        Infinity
                      ];
                      specificContents=Extract[fieldContents, keyedPosition];

                      (* Make sure that the contents in the upload packet can actually be uploaded. *)
                      If[!MatchQ[specificContents, ObjectP[typesInRelations]],
                        Message[Error::SimulateResourcesInvalidBacklink, ToString[specificContents], field];

                        Return[$Failed, Module];
                      ];

                      (* extract the link currently sitting in the position specified and replace it with the new sample *)
                      newLink=linkReplace[
                        typeToBackLinkRules[listedSubFieldRelations],
                        specificContents,
                        First[sampleAndPosition]
                      ];

                      (* point the position to the new link *)
                      keyedPosition->newLink
                    ],
                    samplesAndPositions
                  ];

                (* use replacepart to insert the new links *)
                If[ListQ[fieldContents],
                  Replace[field]->ReplacePart[fieldContents,replacements],
                  field->ReplacePart[fieldContents,replacements]
                ]
              ]
            ]
          ],
          groupedResources
        ];

        (* create packet to upload to the protocol object *)
        Join[<|Object->object|>,Association@@replacedFields]
      ]
    ],
    {
      Join[{Download[myProtocol, Object]}, accessoryPacketObjects],
      Join[{Lookup[protocolPacket, RequiredResources, {}]}, Lookup[accessoryPackets, RequiredResources, {}]]
    }
  ];

  (* update our simulation *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[Packets->Flatten[{sampleResourceUpdatePackets, containerResourceUpdatePackets, instrumentResourceUpdatePackets, newSamplePackets, updatePackets, instrumentStatusPackets}]]];

  (* Download our protocol packet again. *)
  simulatedProtocolPacket=Quiet[Download[myProtocol, Packet[SamplesIn, ResolvedOptions], Simulation->currentSimulation]];

  (* Get our experiment function we're being called from. *)
  experimentFunction = If[MemberQ[Flatten[Values[If[MatchQ[$ECLApplication,CommandCenter],Experiment`Private`experimentFunctionTypeLookup,ProcedureFramework`Private`experimentFunctionTypeLookup]]], Lookup[simulatedProtocolPacket, Type]],
    FirstCase[
      Normal@If[MatchQ[$ECLApplication,CommandCenter],Experiment`Private`experimentFunctionTypeLookup,ProcedureFramework`Private`experimentFunctionTypeLookup],
      (Verbatim[Rule][function_, Lookup[simulatedProtocolPacket, Type]|{___, Lookup[simulatedProtocolPacket, Type], ___}]:>function)
    ],
    Null
  ];

  (* Download our SamplesIn again (after resources have been simulated) and update the WorkingSamples if we have sample prep options. *)
  (* Simulate any sample prep that we may have encountered and fill out the WorkingSamples field of the protocol object. *)
  (* NOTE: If we're one of the framework functions, don't bother updating WorkingSamples since they don't get updated in these protocol objects. *)
  (* NOTE: if we're in global simulation $Simulation = True land, then don't do this because that means we're simulating a full procedure and thus will get the _actual_ simulated WorkingSamples later on *)
  (* NOTE: Also, we rely on ProcedureFramework`Private`experimentFunctionTypeLookup to go from our type to experiment function to use,
  unless we're in CC in which case we don't have access to the PF. *)
  (* we check here that the Options for the function include Centrifuge, Filter, Mix and Incubate - presence of all 4 means that we have sample prep options *)
  currentSimulation=Which[
      And[
        !MatchQ[Lookup[simulatedProtocolPacket, Object], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation], Object[Protocol, RoboticSamplePreparation], Object[Protocol, RoboticCellPreparation]}]],
        Not[$Simulation],
        !MatchQ[experimentFunction, Null],
        MatchQ[Lookup[simulatedProtocolPacket, SamplesIn], {ObjectP[]..}],
        MatchQ[Lookup[simulatedProtocolPacket, ResolvedOptions], _List],
        Length[
          Intersection[
            Keys[Options[experimentFunction]],
            {"Centrifuge","Filter","Mix","Incubate"}
          ]
        ]>0
    ],
      Module[{samples, options, expandedResolvedOptions, workingSamples, workingSamplesSimulation, validInputLengthQ, numReplicates, expandedAliquotSampleLabelsWithReplicates},

        (* Get our inputs and options and expand resolved options. *)
        {samples, options}=Download[myProtocol, {SamplesIn, ResolvedOptions}, Simulation -> currentSimulation];

        (* If we have the PooledSamplesIn option give, overwrite our samples option. *)
        With[{insertMe=experimentFunction},
          If[MatchQ[Lookup[safeOptions, PooledSamplesIn], Except[Null]] && MatchQ[Lookup[First[Lookup[Usage[insertMe],"Input"]],"NestedIndexMatching"], True],
            samples=Lookup[safeOptions, PooledSamplesIn];
          ]
        ];

        (* NOTE: If we have a pooling function, we MUST be given this option. If not, throw an error. *)
        With[{insertMe=experimentFunction},
          If[MatchQ[Lookup[First[Lookup[Usage[insertMe],"Input"]],"NestedIndexMatching"], True] && MatchQ[Lookup[safeOptions, PooledSamplesIn], Null],
            Message[Error::RequiredPooledSamplesIn];

            Return[$Failed];
          ]
        ];


        (* Sanitize the samples used in this function *)
        (* NOTE: ExperimentAdjustpH has two inputs so we have to hard code this. *)
        validInputLengthQ=If[MatchQ[experimentFunction, ExperimentAdjustpH],
          ValidInputLengthsQ[experimentFunction,{samples, ConstantArray[7, Length[samples]]},options,1,Messages->False],
          ValidInputLengthsQ[experimentFunction,{samples},options,1,Messages->False]
        ];

        (* get the number of replicates value *)
        numReplicates=Lookup[options,NumberOfReplicates];

        (* Sanitize samples if the validInputLengthQ is not valid and number of replicates in the resolvedOptions is specified*)
        If[
          And[Not[validInputLengthQ],(numReplicates>1)],
          samples=samples[[;;;;numReplicates]];
        ];

        (* NOTE: ExperimentAdjustpH has two inputs so we have to hard code this. *)
        expandedResolvedOptions=Which[
          MatchQ[experimentFunction, ExperimentAdjustpH],
            Last[ExpandIndexMatchedInputs[experimentFunction, {samples, ConstantArray[7, Length[samples]]}, options]],
          True,
            Last[ExpandIndexMatchedInputs[experimentFunction, {samples}, options]]
        ];

        (* NOTE: It shouldn't actually matter what experiment function we pass down here...but the track record for going that route has been spotty *)
        {workingSamples, workingSamplesSimulation}=simulateSamplesResourcePacketsNew[
          experimentFunction,
          samples,
          expandedResolvedOptions,
          Cache -> cache,
          Simulation -> currentSimulation
        ];

        (* Check if we need to re-expand working samples *)
        If[
          And[Not[validInputLengthQ],(numReplicates>1)],
          workingSamples=Flatten[(ConstantArray[#,numReplicates]&/@workingSamples),1];
        ];

        (* Note that we are now doing a manual expansion of the option AliquotSampleLabel. Our options are not expanded with numReplicates because we collapsed "samples" above. However, workingSamples has been expected with replicates. Apply the same expansion to AliquotSampleLabel for our simulation *)
        expandedAliquotSampleLabelsWithReplicates=If[
          And[Not[validInputLengthQ],TrueQ[(numReplicates>1)],!SameLengthQ[Lookup[expandedResolvedOptions, AliquotSampleLabel,{}],workingSamples]],
          Flatten[(ConstantArray[#,numReplicates]&/@Lookup[expandedResolvedOptions, AliquotSampleLabel,{}]),1],
          Lookup[expandedResolvedOptions, AliquotSampleLabel,{}]
        ];

        UpdateSimulation[
          UpdateSimulation[currentSimulation, workingSamplesSimulation],
          Simulation[
            Packets->{
              <|
                Object->myProtocol,
                Replace[WorkingSamples]->(Link/@workingSamples),
                Replace[WorkingContainers]->(Link/@DeleteDuplicates@Download[Download[workingSamples, Container, Simulation->workingSamplesSimulation], Object])
              |>
            },
            Labels->If[KeyExistsQ[expandedResolvedOptions, AliquotSampleLabel],
              Rule@@@Cases[
                Transpose[{expandedAliquotSampleLabelsWithReplicates, workingSamples}],
                {_String, ObjectP[]}
              ],
              {}
            ],
            LabelFields->If[KeyExistsQ[expandedResolvedOptions, AliquotSampleLabel],
              Rule@@@Cases[
                Transpose[{expandedAliquotSampleLabelsWithReplicates, Field[AliquotSamples[[#]]]&/@Range[Length[expandedAliquotSampleLabelsWithReplicates]]}],
                {_String, _Field}
              ],
              {}
            ]
          ]
        ]
      ],
    (* if we are not doing sample prep but are a Protocol (and not Maintenance or Qualification), just fill in WorkingSamples and WorkingContainers from SamplesIn and ContainersIn of the protocol *)
    MatchQ[myProtocol, ObjectP[Object[Protocol]]],
      Module[{samples, containers},
        (* quieting this because for qualifications and maintenances, these fields don't exist*)
        {samples, containers} = Quiet[Download[myProtocol, {SamplesIn, ContainersIn}, Simulation -> currentSimulation], Download::FieldDoesntExist];
        UpdateSimulation[
          currentSimulation,
          Simulation[<|
            Object -> myProtocol,
            (* this removes any $Failed/Null from samples/containers *)
            Replace[WorkingSamples] -> Cases[(Link /@ ToList[samples]), LinkP[]],
            Replace[WorkingContainers] -> Cases[(Link /@ ToList[containers]), LinkP[]]
          |>]
        ]
      ],
    True,
      currentSimulation
  ];

  (* Return the updated simulation. *)
  currentSimulation
];

SimulateResources[
  myProtocol:ObjectReferenceP[{Object[Protocol], Object[Maintenance], Object[Qualification]}],
  myOptions:OptionsPattern[SimulateResources]
]:=SimulateResources[myProtocol, Null, myOptions];



(* ::Subsubsection::Closed:: *)
(*resolvePrimitiveMethods*)


(* ::Code::Initialization:: *)
Error::InvalidSuppliedPrimitiveMethod="The following primitives, `1`, at indices, `2`, have the following primitive methods specified, `3`. These primitive methods are not valid for the given primitives. Please let the primitive method resolve automatically or move the primitive into a valid method wrapper.";

resolvePrimitiveMethods[myFunction_, myPrimitives_List, myHeldPrimitiveSet_Hold]:=Module[
  {primitiveSetInformation, allPrimitivesInformation, primitiveToAllowedMethodsLookup, singleMethodResolvedPrimitives,
    invalidPrimitiveMethodsWithIndices},

  (* Lookup our primitive set information again. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, myHeldPrimitiveSet];
  allPrimitivesInformation=Lookup[primitiveSetInformation, Primitives];

  (* Build an easy to use lookup of our primitive head to the allowed methods for that primitive. *)
  primitiveToAllowedMethodsLookup=(Lookup[#,PrimitiveHead]->Lookup[#, Methods]&)/@Values[allPrimitivesInformation];

  (* STEP 1: Certain primitives can only be performed via one method (ex. HPLC can only be done manually). Resolve the *)
  (* method for these primitives. *)

  (* Keep track of primitives that were given to us with a PrimitiveMethod by the user, but don't allow for that PrimitiveMethod. *)
  invalidPrimitiveMethodsWithIndices={};

  singleMethodResolvedPrimitives=MapThread[
    Function[{primitive, index},
      Which[
        (* This primitive already has a PrimitiveMethod key so we don't have anything to resolve. But, we error check *)
        (* to make sure that this method is valid. *)
        KeyExistsQ[primitive[[1]], PrimitiveMethod] && MatchQ[Lookup[primitive[[1]], PrimitiveMethod], Except[Automatic]],
          Module[{givenPrimitiveMethod, methods},
            (* The user gave us a PrimitiveMethod. Make sure that this primitive allows for that primitive method. *)
            givenPrimitiveMethod=Lookup[primitive[[1]], PrimitiveMethod];

            (* Lookup the allowable methods for this primitive head. *)
            methods=Lookup[
              Lookup[allPrimitivesInformation, Head[primitive]],
              Methods
            ];

            If[!MemberQ[methods, givenPrimitiveMethod],
              AppendTo[invalidPrimitiveMethodsWithIndices, {Head[primitive], givenPrimitiveMethod, index}];
            ];

            (* Return the primitive. *)
            primitive
          ],
        (* Are we in a specific function? *)
        MatchQ[myFunction, ExperimentManualSamplePreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->ManualSamplePreparation
          ],
        MatchQ[myFunction, ExperimentManualCellPreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->ManualCellPreparation
          ],
        MatchQ[myFunction, ExperimentRoboticSamplePreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->RoboticSamplePreparation
          ],
        MatchQ[myFunction, ExperimentRoboticCellPreparation],
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->RoboticCellPreparation
          ],
        (* Otherwise, see if we only have one allowed method for this primitive head. *)
        Length[Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]]==1,
          Head[primitive]@Append[
            primitive[[1]],
            PrimitiveMethod->FirstOrDefault[Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]]
          ],
        (* TODO: Otherwise, call the method resolver function for the primitive to try and narrow down the list. *)
        True,
          Module[
            {allPrimitiveInformation, primitiveInformation, primitiveResolverMethod, primitiveOptionDefinitions, inputsFromPrimitiveOptions,
              optionsFromPrimitiveOptions, inputsWithAutomatics, optionsWithAutomatics, potentialRawMethods, potentialMethods},

            (* Lookup the method resolver function. *)
            allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
            primitiveInformation=Lookup[allPrimitiveInformation, Head[primitive]];
            primitiveResolverMethod=Lookup[primitiveInformation, MethodResolverFunction];
            primitiveOptionDefinitions=Lookup[primitiveInformation, OptionDefinition];

            (* Separate out our primitive options into inputs and function options. *)
            inputsFromPrimitiveOptions=(#->Lookup[primitive[[1]], #, Automatic]&)/@Lookup[primitiveInformation, InputOptions];
            optionsFromPrimitiveOptions=Cases[
              Normal[primitive[[1]], Association],
              Verbatim[Rule][
                Except[Alternatives[PrimitiveMethod, PrimitiveMethodIndex, WorkCell, (Sequence@@Lookup[primitiveInformation, InputOptions])]],
                _
              ]
            ];

            (* If we're in Transfer, the transfers will be split into multiple transfers with 970 Microliters in the main resolution loop. *)
            (* Set the volume of any transfers over 970 Microliter so that the resolver doesn't think it can only be manual. *)
            inputsFromPrimitiveOptions=If[MatchQ[primitive, _Transfer],
              inputsFromPrimitiveOptions/.{vol:GreaterP[970 Microliter]:>970 Microliter},
              inputsFromPrimitiveOptions
            ];

            (* Change any labels to Automatics since we don't have any simulated objects that correspond to the labels yet. *)
            inputsWithAutomatics=KeyValueMap[
              Function[{option, value},
                Module[{optionDefinition},
                  (* Lookup information about this option. *)
                  optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                  (* Do does this option allow for PreparedSample or PreparedContainer? *)
                  Which[
                    (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                    (* Cases will only look inside of lists, not associations. *)
                    Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                    (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                  ]
                ]
              ],
              Association@inputsFromPrimitiveOptions
            ];

            optionsWithAutomatics=KeyValueMap[
              Function[{option, value},
                Module[{optionDefinition},
                  (* Lookup information about this option. *)
                  optionDefinition=FirstCase[primitiveOptionDefinitions,KeyValuePattern["OptionSymbol"->option],Null];

                  (* Do does this option allow for PreparedSample or PreparedContainer? *)
                  Which[
                    (* NOTE: We have to convert any associations (widgets automatically evaluate into associations) because *)
                    (* Cases will only look inside of lists, not associations. *)
                    Length[Cases[Lookup[optionDefinition, "Widget"]/.{w_Widget :> Normal[w[[1]]]}, (PreparedContainer->True)|(PreparedSample->True), Infinity]]==0,
                    (* Nothing to replace. *)
                    option->value,
                    True,
                    (* We may potentially have some labels. *)
                    Module[{matchedWidgetInformation, objectWidgetsWithLabels, labelsInOption},
                      (* Match the value of our option to the widget that we have. *)
                      (* NOTE: This is the same function that we use in the command builder to match values to widgets. *)
                      matchedWidgetInformation=AppHelpers`Private`matchValueToWidget[value,optionDefinition];

                      (* Look for matched object widgets that have labels. *)
                      (* NOTE: A little wonky here, all of the Data fields from the AppHelpers function gets returned as a string, so we need *)
                      (* to separate legit strings from objects that were turned into strings. *)
                      objectWidgetsWithLabels=Cases[ToList@matchedWidgetInformation, KeyValuePattern[{"Type" -> "Object", "Data" -> _?(!StringStartsQ[#, "Object["] && !StringStartsQ[#, "Model["]&)}], Infinity];

                      (* This will give us our labels. *)
                      labelsInOption=(StringReplace[#,"\""->""]&)/@Lookup[objectWidgetsWithLabels, "Data", {}];

                      (* Replace any labels that we have with Automatics. *)
                      option-> (
                        value /. (Alternatives@@labelsInOption -> Automatic)
                      )
                    ]
                  ]
                ]
              ],
              Association@optionsFromPrimitiveOptions
            ];

            (* Pass down the inputs and options down to the resolver function. *)
            (* NOTE: We have to quiet here because we'll internally call the method resolver function again by calling the *)
            (* experiment function, so if there are messages, they'll be thrown there. *)
            potentialRawMethods=If[MatchQ[primitive, plateReaderPrimitiveP],
              Quiet[
                ToList@primitiveResolverMethod[
                  Sequence@@Values[inputsWithAutomatics],
                  Object[Protocol, Head[primitive]],
                  Join[
                    optionsWithAutomatics,
                    {
                      Output->Result
                    }
                  ]
                ]
              ],
              Quiet[
                ToList@primitiveResolverMethod[
                  Sequence@@Values[inputsWithAutomatics],
                  Join[
                    optionsWithAutomatics,
                    {
                      Output->Result
                    }
                  ]
                ]
              ]
            ];

            (* NOTE: We always return Manual/Robotic from our method resolver function. Add Cell or Sample depending *)
            (* on the experiment function that we're in. *)
            potentialMethods=Flatten@{
              Which[
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation],
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, ExperimentManualCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], ManualCellPreparation],
                MemberQ[potentialRawMethods, Manual] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], ManualSamplePreparation|ManualCellPreparation|Experiment],
                True,
                {}
              ],
              Which[
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticSamplePreparation|ExperimentSamplePreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation],
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, ExperimentRoboticCellPreparation|ExperimentCellPreparation],
                Cases[Lookup[primitiveInformation, Methods], RoboticCellPreparation],
                MemberQ[potentialRawMethods, Robotic] && MatchQ[myFunction, Experiment],
                Cases[Lookup[primitiveInformation, Methods], RoboticSamplePreparation|RoboticCellPreparation|Experiment],
                True,
                {}
              ]
            };

            Head[primitive]@Append[
              primitive[[1]],
              PrimitiveMethod->If[MatchQ[potentialMethods, {PrimitiveMethodsP..}],
                potentialMethods,
                Lookup[primitiveToAllowedMethodsLookup, Head[primitive], {}]
              ]
            ]
          ]
      ]
    ],
    {myPrimitives, Range[Length[myPrimitives]]}
  ];

  If[Length[invalidPrimitiveMethodsWithIndices]>0,
    Message[Error::InvalidSuppliedPrimitiveMethod, invalidPrimitiveMethodsWithIndices[[All,1]], invalidPrimitiveMethodsWithIndices[[All,3]], invalidPrimitiveMethodsWithIndices[[All,2]]];
  ];

  (* Return our resolved result. *)
  {
    singleMethodResolvedPrimitives,
    DeleteDuplicates[Flatten[{invalidPrimitiveMethodsWithIndices[[All,3]]}]]
  }
];



(* ::Subsubsection::Closed:: *)
(*tallySubsetQ*)


(* ::Code::Initialization:: *)
(* Helper function that returns True if the first tally contains all of the elements of the second tally. *)
tallySubsetQ[tally1_List,tally2_List]:=And@@Map[
  Function[{secondTallyElement},
    Module[{firstTallyElement},
      (* Find the element of the second tally within the first tally. *)
      firstTallyElement=FirstCase[tally1, {secondTallyElement[[1]], _}, Null];

      (* If were unable to find the element in the first tally, or the number in the first tally *)
      (* is less than the number in the second tally, then we're not a subset. *)
      And[
        !MatchQ[firstTallyElement, Null],
        MatchQ[firstTallyElement[[2]], GreaterEqualP[secondTallyElement[[2]]]]
      ]
    ]
  ],
  tally2
];

(* Helper function that will filter out any instruments that are not compatible with the given
1) Footprint requirements
2) Tip Requirements
3) Integrated Instrument Requirements
4) Idling Condition Requirements. *)
filterInstruments[
  potentialInstruments_List,
  newFootprintTally_List,
  startingAmbientContainers_List,
  startingIncubatorContainers_List,
  workCellIdlingConditionHistory_List, (* {(ObjectP[Object[Container]] -> Incubator|Ambient)..} *)
  stackedTipPositionsNeeded_Integer,
  nonStackedTipPositionsNeeded_Integer,
  instrumentResourceModels_List,
  highPrecisionPositionContainersBools_List,
  cache_List,
  tipAdapterUsed_?BooleanQ
]:=Map[
  Function[{potentialInstrument},
    Module[{potentialInstrumentAsModel, instrumentModelPacket, availableFootprints, maxNonStackedTipPositions,
      maxStackedTipPositions, integratedInstrumentModels, maxIncubatorPlatePositions, updatedMaxOffDeckStoragePositions, updatedMaxNonStackedTipPositions,
      currentAmbientContainers, currentIncubatorContainers, highPrecisionContainerTally, maxOffDeckStoragePositions,
      maxAmbientPlatePositions},

      (* Convert to a model if necessary. *)
      potentialInstrumentAsModel=If[MatchQ[potentialInstrument, ObjectP[Model[Instrument]]],
        potentialInstrument,
        Lookup[fetchPacketFromCache[potentialInstrument, cache], Model]
      ];

      (* Get the packet for this instrument. *)
      instrumentModelPacket=fetchPacketFromCache[potentialInstrumentAsModel, cache];

      (* Short circuit if we have a Object/Model[Instrument,ColonyHandler], the qpix does not have all of these checks *)
      If[MatchQ[instrumentModelPacket, PacketP[{Object[Instrument,ColonyHandler],Model[Instrument,ColonyHandler]}]],
        Return[potentialInstruments, Module]
      ];

      (* Lookup information from this instrument. *)
      availableFootprints=Lookup[instrumentModelPacket, AvailableFootprints];
      maxNonStackedTipPositions=With[{lookup = Lookup[instrumentModelPacket, MaxNonStackedTipPositions]/.Null->0},
        (* if we are using a tip adapter, we need to take out one position from the non-stacked instruments *)
        If[tipAdapterUsed,
          If[lookup==0, 0, lookup-1],
          lookup
        ]];
      maxStackedTipPositions=Lookup[instrumentModelPacket, MaxStackedTipPositions]/.Null->0;
      integratedInstrumentModels=Lookup[instrumentModelPacket, IntegratedInstruments];
      maxIncubatorPlatePositions=Lookup[instrumentModelPacket, MaxIncubatorPlatePositions];
      maxOffDeckStoragePositions=Lookup[instrumentModelPacket, MaxOffDeckStoragePositions];

      (* If we have too many non stacked tips, put them off deck. *)
      (* NOTE: We only have off deck tip storage on the bioSTAR/microbioSTAR since it requires a HMotion. We can only *)
      (* use non stacked tips on the bioSTAR/microbioSTAR due to sterility requirements. Also, we need non stacked tips *)
      (* since we need a tip box to load up the tips in the first place (non stacked tips can't fit in the tip box. *)
      {updatedMaxOffDeckStoragePositions, updatedMaxNonStackedTipPositions}=If[And[
          MatchQ[nonStackedTipPositionsNeeded, GreaterP[maxNonStackedTipPositions]],
          MatchQ[nonStackedTipPositionsNeeded, LessEqualP[maxNonStackedTipPositions + maxOffDeckStoragePositions]]
        ],
        {
          maxOffDeckStoragePositions-(nonStackedTipPositionsNeeded-maxNonStackedTipPositions),
          nonStackedTipPositionsNeeded
        },
        {
          maxOffDeckStoragePositions,
          maxNonStackedTipPositions
        }
      ];

      (* Get the total number of ambient deck positions that we have available to us for plates (the number of positions *)
      (* available for plates on deck plus the number of off deck plate positions). *)
      maxAmbientPlatePositions=updatedMaxOffDeckStoragePositions + Lookup[Rule@@@availableFootprints, Plate, 0];

      (* If we have too many on deck positions, put some of them *)

      (* Filter out this instrument if the basic requirements (1-3) don't match up. *)
      If[Or[
          (* Has to be able to fit all necessary footprints. *)
          (* NOTE: Add the additional off deck plate storage positions we have to our available footprints. *)
          !tallySubsetQ[
            List@@@ReplaceRule[Rule@@@availableFootprints, Plate->maxAmbientPlatePositions],
            newFootprintTally
          ],

          (* Has to be able to fit all tips, stacked and non-stacked. *)
          !MatchQ[stackedTipPositionsNeeded, LessEqualP[maxStackedTipPositions]],
          !MatchQ[nonStackedTipPositionsNeeded, LessEqualP[updatedMaxNonStackedTipPositions]],

          (* Has to be integrated with all required instrument models. *)
          (* since instrumentResourceModels can be a list or a list of lists (because instrument models can be either) need to do it this way.  Also note that if you have a resource requesting more than one instrument, the corresponding liquid handler only needs one *)
          !AllTrue[
            Download[instrumentResourceModels, Object],
            MemberQ[Download[integratedInstrumentModels, Object], Alternatives @@ ToList[#]]&
          ]
        ],
        Return[Nothing, Module];
      ];

      (* Otherwise, check the idling condition requirements. *)

      (* NOTE: We're only making associations here because doing KeyExistsQ on it is faster. *)
      (* NOTE: This is only checking containers that are Footprint->Plate because that is the only type of container *)
      (* that we can move around. *)
      currentAmbientContainers=Association@((#->Null&)/@startingAmbientContainers);
      currentIncubatorContainers=Association@((#->Null&)/@startingIncubatorContainers);

      (* If we don't have incubation positions (not on the bioSTAR/microbioSTAR) or we have too many plates just starting off, return False. *)
      If[Or[
          And[MatchQ[currentAmbientContainers, _Integer], MatchQ[maxAmbientPlatePositions, Null]],
          And[MatchQ[currentIncubatorContainers, _Integer], MatchQ[maxIncubatorPlatePositions, Null]],
          MatchQ[Length[currentAmbientContainers], GreaterP[maxAmbientPlatePositions]],
          MatchQ[Length[currentIncubatorContainers], GreaterP[maxIncubatorPlatePositions]]
        ],
        Return[Nothing, Module];
      ];

      (* Map through the idling conditions and make changes to our lists of labels. If we ever exceed the ambient or *)
      (* incubator capacity, do not include this instrument. *)
      Map[
        Function[{idlingConditionChange},
          (* If this label isn't in our starting plate label lookup, it must not have Footprint->Plate so just ignore it. *)
          (* Otherwise, if this plate label is changing locations, update our lookups. *)
          Which[
            KeyExistsQ[currentAmbientContainers, idlingConditionChange[[1]]],
              If[MatchQ[idlingConditionChange[[2]], Ambient],
                Null,

                KeyDropFrom[currentAmbientContainers, idlingConditionChange[[1]]];
                AppendTo[currentIncubatorContainers, idlingConditionChange[[1]]->Null];
              ],
            KeyExistsQ[currentIncubatorContainers, idlingConditionChange[[1]]],
              If[MatchQ[idlingConditionChange[[2]], Incubator],
                Null,

                KeyDropFrom[currentIncubatorContainers, idlingConditionChange[[1]]];
                AppendTo[currentAmbientContainers, idlingConditionChange[[1]]->Null];
              ],
            True,
              Null
          ];

          (* If we've run out of positions, filter out this instrument. *)
          (* NOTE: We assume that we will have enough ambient deck . *)
          If[Or[
              And[MatchQ[currentAmbientContainers, _Integer], MatchQ[maxAmbientPlatePositions, Null]],
              And[MatchQ[currentIncubatorContainers, _Integer], MatchQ[maxIncubatorPlatePositions, Null]],
              MatchQ[Length[currentAmbientContainers], GreaterP[maxAmbientPlatePositions]],
              MatchQ[Length[currentIncubatorContainers], GreaterP[maxIncubatorPlatePositions]]
            ],
              Return[Nothing, Module];
          ];
        ],
        workCellIdlingConditionHistory
      ];

      (*Check how many of the container models have HighPrecisionPositionRequired True*)
      highPrecisionContainerTally=Count[highPrecisionPositionContainersBools,True];

      (*Filter out instruments that can not handle the high precision tally *)
      (*The starlet only has one high precision position*)
      If[
        MatchQ[Download[potentialInstrumentAsModel,Object],ObjectP[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"]]]&&MatchQ[highPrecisionContainerTally,GreaterP[1]],
        Return[Nothing, Module];
      ];

      (* We've passed all of our checks. Return the instrument. *)
      potentialInstrument
    ]
  ],
  potentialInstruments
];

(* This is the minimum buffer of tips that we want to be in each tip box since we can use more tips than we expect in each *)
(* tip box due to incorrect tip counts in SLL or interrupted hamilton runs. *)
$HamiltonTipBoxBuffer=12;

partitionTips[tipModelPackets_List, allTipResources_List, primitiveGrouping_List]:=Module[
  {tipModelsForMultiProbeHeadTransfers, allTips, talliedTipModels, partitionedTipCountLookup, requiredStackedTipTypes, requiredNonStackedTipTypes},

  (* Return early if we don't have any tips to partition. *)
  If[MatchQ[allTipResources, {}],
    Return[{{},{}}];
  ];

  (* --  Figure out what tip models will be used in multi probe head transfers. -- *)
  (* EXPLANATION: This is important because a multi probe head transfer requires a full rack of 96 tips. So, if we had *)
  (* a 96 head transfer followed by a single transfer, we would need 97 (plus extra tips for the rack abandonment issue) *)
  (* tips, but we can't request for those 97 tips to be in a single stack (96 on the bottom, 1 on the top) because the *)
  (* 96 head transfer will happen first, so it'll need to throw out the tip on the top rack to reach the full tip rack below, *)
  (* then when we get to the single transfer, we won't have any tips left. *)
  (* We get around this by seeing what tip models have a 96 head (MultiProbeHead) transfer associated with them and then *)
  (* making sure that we have the partial tip request on another tip position. Our tip selection code in selectTipsForPipetting *)
  (* in the robotic exporter for transfer/mix selects non-full tips first to preserve full tip rack levels for multi head *)
  (* transfers. *)
  (* NOTE: This only affects stacked tip models since non stacked tip models will always have their partial (non 96) racks *)
  (* on different positions on deck. *)
  tipModelsForMultiProbeHeadTransfers=DeleteDuplicates@Flatten@Map[
    Function[transferPrimitive,
      Module[{tips, deviceChannel, listedTips, listedDeviceChannel},
        {tips, deviceChannel}=Lookup[transferPrimitive[[1]], {Tips, DeviceChannel}];

        (* NOTE: Don't want to use ExpandIndexMatchedInputs here because it's wasteful. Do manual expanding. *)
        {listedTips, listedDeviceChannel}=Switch[{tips, deviceChannel},
          {_List, _List},
          {tips, deviceChannel},
          {Except[_List], _List},
          {ConstantArray[tips, Length[deviceChannel]], deviceChannel},
          {_List, Except[_List]},
          {tips, ConstantArray[deviceChannel, Length[tips]]},
          {Except[_List], Except[_List]},
          {{tips}, {deviceChannel}}
        ];

        (* For pipetting Mix, the DeviceChannel is Null and automatically excluded here *)
        Download[Cases[PickList[listedTips, listedDeviceChannel, MultiProbeHead], ObjectP[Model[Item, Tips]]], Object]
      ]
    ],
    (* Consider both Transfer and pipetting Mix *)
    Cases[primitiveGrouping, (_Transfer|_Mix)]
  ];

  (* Expand our tip resources so that every model is listed the number of times that tip is used. *)
  allTips=Flatten[(ConstantArray[Lookup[#[[1]], Sample], Lookup[#[[1]], Amount]]&)/@allTipResources];

  (* Tally our tip models. *)
  talliedTipModels=(Rule@@#&)/@Tally[allTips];

  (* Build lookup relating tip type to a list of tip counts partitioned by sample. For example, if we need *)
  (* 100 300ul stackable tips, <| Model[Item, Tip, "300ul tips"] -> {4,96} ...|> *)
  partitionedTipCountLookup = Association@KeyValueMap[
    Function[{tipModel,requiredCount},
      Module[{tipPacket,stackSize,maxUsableTipCountPerStack,fullLayersNeeded,tipRemainder,extraLayersNeeded,numberOfFullTipBoxesNeeded,numberOfOtherLayersNeeded,tipBoxCounts},
        (* Fetch tip model packet *)
        tipPacket = fetchPacketFromCache[tipModel,tipModelPackets];

        (* Fetch the number of levels in a stack *)
        stackSize = If[MatchQ[Lookup[tipPacket,MaxStackSize], GreaterP[1]],
          Lookup[tipPacket,MaxStackSize],
          1
        ];

        (* NOTE: For every tip box, we want to make sure that we are requesting AT LEAST $HamiltonTipBoxBuffer extra tips. This is because *)
        (* our tip counts may not be exactly precise due to pipetting issues (re-performing the pipetting will result in extra tips being used) *)
        (* or incorrect tip counts in the tip objects. *)
        (* NOTE: Also, Hamilton may discard the top layer of a tip rack if it has less than 8 tips -- so $HamiltonTipBoxBuffer has *)
        (* to be AT LEAST 8. *)
        maxUsableTipCountPerStack = Lookup[tipPacket,NumberOfTips] - $HamiltonTipBoxBuffer;

        (* Get the number of layers of tips that we will need. *)
        {fullLayersNeeded, tipRemainder} = QuotientRemainder[requiredCount,maxUsableTipCountPerStack];

        (* For tips required in MultiProbeHead transfer, we need extra tip rack at the bottom rack so we don't have collision issue when tip size delta is 3 *)
        (* More details in https://app.asana.com/0/1202908637230347/1203437241522836/f *)
        (* Need one extra layer for each tip object *)
        (* If we are requiring an extra tip box below since we want 2 tip positions per tip type, we don't really need an extra here *)
        extraLayersNeeded=If[MemberQ[tipModelsForMultiProbeHeadTransfers, ObjectP[tipModel]]&&(Floor[fullLayersNeeded/stackSize]>0)&&!MatchQ[stackSize, 1],
          Ceiling[fullLayersNeeded/(stackSize-1)],
          0
        ];

        (* Get the number of full tip boxes that we need. *)
        numberOfFullTipBoxesNeeded = Floor[(fullLayersNeeded+extraLayersNeeded)/stackSize];
        numberOfOtherLayersNeeded = (fullLayersNeeded+extraLayersNeeded) - (numberOfFullTipBoxesNeeded * stackSize);

        (* Create the list of the amounts of tips that we need in each of our tip boxes. *)
        tipBoxCounts = Prepend[
          Table[Lookup[tipPacket,NumberOfTips] * stackSize, numberOfFullTipBoxesNeeded],
          (* NOTE: We have to add $HamiltonTipBoxBuffer here again because tipRemainder will add another layer *)
          (* to our entire request, and we want $HamiltonTipBoxBuffer on each layer we request. *)
          Which[
            tipRemainder > 0 && numberOfOtherLayersNeeded > 0,
              (Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded) + tipRemainder + $HamiltonTipBoxBuffer,
            tipRemainder > 0,
              tipRemainder + $HamiltonTipBoxBuffer,
            numberOfOtherLayersNeeded > 0,
              (Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded),
            True,
              Nothing
          ]
        ];

        (* If we have stacked tips, make sure there are two instances of the stacked tips on deck in different spots *)
        (* if we're using the multi-probe head. This is because if there are single transfers in between the MPH transfers, *)
        (* we may need to throw out entire rack layers, which can make us run out of tips. This can be avoided by having *)
        (* two positions on deck since selectTipsForPipetting will prefer used boxes of tips to not throw out layers. *)
        If[
          And[
            (* If our tip model is non-stacked, we don't have to worry about the 96 head issue and discarding partial rack *)
            (* issue that we described earlier since all tip racks will be on different positions. *)
            !MatchQ[stackSize, 1],
            (* If we're not using our tip model for a multi probe head transfer, then we don't have to do any special tip arrangement on deck. *)
            MemberQ[tipModelsForMultiProbeHeadTransfers, ObjectP[tipModel]],
            (* If we have more than one position on deck for this tip type, we shouldn't run into the 96 head issue. *)
            !(Length[tipBoxCounts]>1)
          ],
          tipBoxCounts=Append[tipBoxCounts, Lookup[tipPacket,NumberOfTips] * stackSize];
        ];

        (* Return rule *)
        tipModel -> tipBoxCounts
      ]
    ],
    Association@talliedTipModels
  ];

  (* Extract required tip types that are stacked *)
  requiredStackedTipTypes = Select[
    DeleteDuplicates[allTips],
    TrueQ[Lookup[fetchPacketFromCache[#,tipModelPackets],MaxStackSize] > 1]&
  ];

  (* Extract required tip types that are not stacked *)
  requiredNonStackedTipTypes = UnsortedComplement[DeleteDuplicates[allTips],requiredStackedTipTypes];

  (* Build tuples of a stacked tip type and its required count for each sample request in the form: *)
  (* {{tip type, tip count required}..}. *)
  {
    Join@@Map[
      Function[tipModel,
        {tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
      ],
      requiredStackedTipTypes
    ],
    Join@@Map[
      Function[tipModel,
        {tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
      ],
      requiredNonStackedTipTypes
    ]
  }
];


(* helper function to determine if the input objects are Simulated or not; this is not as simple as looking at SimulatedObjects because $CreatedObjects makes things more complicated; see comments below *)
simulatedObjectQs[mySamples:{ObjectP[]...}, mySimulation_Simulation]:=If[MatchQ[$CurrentSimulation, SimulationP],
  Module[{allSimulatedObjectsUOOnly},
    allSimulatedObjectsUOOnly=DeleteCases[Lookup[mySimulation[[1]], SimulatedObjects], Alternatives @@ Lookup[$CurrentSimulation[[1]], SimulatedObjects]];

    (* The variable namespace here is confusing and hard to deconvolute but worth explaining: *)
    (* 1.) Lookup[mySimulation[[1]], SimulatedObjects] are all the Labeled objects inside of the currentSimulation (i.e., the simulation that came out of the options resolvers) *)
    (* 2.) allSimulatedObjectsUOOnly are the SimulatedObjects that exist in the currentSimulation, but NOT in $CurrentSimulation *)
    (* The reason we want this is because if it's in $CurrentSimulation, then we are in the global simulation space and the objects were put there by Upload.  For all intents and purposes, those are "real" objects, and not ones we need to replace with labels.*)
    (* 3.) Thus, the MemberQ will only return True if the objects are labeled by currentSimulation and NOT in $CurrentSimulation*)
    (MemberQ[allSimulatedObjectsUOOnly, #]&)/@mySamples
  ],
  (MemberQ[Lookup[mySimulation[[1]], SimulatedObjects], #]&)/@mySamples
];