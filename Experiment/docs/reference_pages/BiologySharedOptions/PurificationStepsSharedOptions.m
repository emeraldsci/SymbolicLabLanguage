DefineUsage[preResolvePurificationSharedOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"preResolvePurificationSharedOptions[samples, options, mapThreadFriendlyOptions]","preResolvedOptions"},
        Description->"returns a list of 'preResolvedOptions' depending on the Purification master switch option and any user specified options.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into the purification step. Note that if any transfers/aliquots occur before the purification step in the experiment, they must be simulated before the purification resolver is called.",
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
              Expandable->False
            },
            IndexName->"experiment samples"
          ],
          {
            InputName->"options",
            Description->"The experiment options of the parent function that contains the purification shared options.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          IndexMatching[
            {
              InputName->"mapThreadFriendlyOptions",
              Description->"The map thread version of the experiment options of the parent function that contains the purification shared options.",
              Widget->Widget[
                Type -> Expression,
                Pattern :> {_Association..},
                Size -> Line
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"preResolvedOptions",
            Description->"The preResolved purification shared options.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "preResolveLiquidLiquidExtractionSharedOptions",
      "preResolvePrecipitationSharedOptions",
      "preResolveExtractionSolidPhaseSharedOptions",
      "preResolveMagneticBeadSeparationSharedOptions"
    },
    Author -> {"taylor.hochuli", "thomas"}
  }
];

DefineUsage[checkPurificationConflictingOptions,
  {
    BasicDefinitions -> {
      {
        "checkPurificationConflictingOptions[samples, mapThreadFriendlyOptions, messagesQ]",
        "{purificationConflictingOptions, purificationConflictingOptionsTest}",
        "returns a list of purification (precipitation, magnetic bead separation, solid-phase extraction, and/or liquid-liquid extraction) options that are set even though Purification indicates that they should not be set (it does not contain Precipitation, MagneticBeadSeparation, SolidPhaseExtraction, or LiquidLiquidExtraction, respectively). If messagesQ is true, checkPurificationConflictingOptions also returns one or more error messages (Error::PrecipitationConflictingOptions, Error::MagneticBeadSeparationConflictingOptions, Error::SolidPhaseExtractionConflictingOptions, and/or Error::LiquidLiquidExtractionConflictingOptions). If messagesQ is False, checkPurificationConflictingOptions returns tests and does not throw an error message."
      }
    },
    {
      Input :> {
        {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which mapThreadFriendlyOptions will be checked for conflicting purification options."},
        {"mapThreadFriendlyOptions", {_Association..}, "A list of associations made by calling Options`Private`mapThreadOptions[] on experiment options"},
        {"messagesQ", BooleanP, "Indicates if messages are being thrown or tests are being gathered and messages silenced."}
      },
      Output :> {
        {"purificationConflictingOptions", _List, "A list of purification options that are set even though Purification indicates that they should not be set."},
        {"purificationConflictingOptionsTest", {TestP...}, "A list of tests checking if there are conflicting purification options for the input samples."}
      },
      SeeAlso -> {"checkSolidMedia", "checkPurificationConflictingOptions"},
      Author -> {"josh.kenchel"}
    }
  }
];


DefineUsage[buildPurificationUnitOperations,
  {
    BasicDefinitions -> {
      {
        Definition->{"buildPurificationUnitOperations[samples, options, mapThreadFriendlyOptions,containerOutLabelOptionName,sampleOutLabelOptionName]","{workingSamples,purificationUnitOperations}"},
        Description->"returns a list of 'workingSamples' and 'purificationUnitOperations' built upon the preResolved purification options. The 'purificationUnitOperations' can be used to build the primitives as the input to an ExperimentRoboticCellPreparation call.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into the purification step. Note that if any transfers/aliquots occur before the purification step in the experiment, they must be simulated before the purification resolver is called.",
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
              Expandable->False
            },
            IndexName->"experiment samples"
          ],
          {
            InputName->"options",
            Description->"The experiment options of the parent function that contains the purification shared options preResolved based on user input, method, and experiment default.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          IndexMatching[
            {
              InputName->"mapThreadFriendlyOptions",
              Description->"The map thread version of the experiment options of the parent function that contains the purification shared options preResolved based on user input, method, and experiment default.",
              Widget->Widget[
                Type -> Expression,
                Pattern :> {_Association..},
                Size -> Line
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ],
          {
            InputName->"containerOutLabelOptionName",
            Description->"The option name for container out label in parent function. For example, if used in ExtractRNA, containerOutLabelOptionName is ExtractedRNAContainerLabel.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> _Symbol,
              Size -> Line
            ],
            Expandable->False
          },
          {
            InputName->"sampleOutLabelOptionName",
            Description->"The option name for sample out label in parent function. For example, if used in ExtractRNA, containerOutLabelOptionName is ExtractedRNALabel.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> _Symbol,
              Size -> Line
            ],
            Expandable->False
          }
        },
        Outputs:>{
          {
            OutputName->"workingSamples",
            Description->"The sample on which the purification unit operations acts.",
            Pattern:>{_Rule..}
          },
          {
            OutputName->"purificationUnitOperations",
            Description->"A list of SolidPhaseSeparation, LiquidLiquidExtraction, MagneticBeadSeparation, and Precipitate, that will be performed in the order listed on the 'workingSamples'.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    SeeAlso -> {"preResolvePurificationSharedOptions","optionsFromUnitOperation"},
    Author -> {"melanie.reschke","taylor.hochuli","yanzhe.zhu"}
  }
];

DefineUsage[purificationSharedOptionsTests,
  {
    BasicDefinitions -> {
      {
        "purificationSharedOptionsTests[samples, samplePackets, resolvedOptions, gatherTestsQ]",
        "{purificationStepCountTests, purificationStepCountInvalidOptions}",
        "returns a list of tests and invalid options of Purification that contain more than 3 repetition of any purification step (Precipitation, MagneticBeadSeparation, SolidPhaseExtraction, or LiquidLiquidExtraction). The maximum number of purification steps of one type per extraction is 3. If gatherTestsQ is False, purificationSharedOptionsTests returns empty tests and also returns triggered error messages (Error::LiquidLiquidExtractionStepCountLimitExceeded, Error::PrecipitationStepCountLimitExceeded, Error::SolidPhaseExtractionStepCountLimitExceeded, and/or Error::MagneticBeadSeparationStepCountLimitExceeded). If gatherTestsQ is True, purificationSharedOptionsTests returns tests and does not throw an error message."
      }
    },
    {
      Input :> {
        {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which mapThreadFriendlyOptions will be checked for conflicting purification options."},
        {"samplePackets", {PacketP[Object[Sample]]..}, "A list of packets of the 'samples'."},
        {"resolvedOptions", {_Rule..}, "The experiment options of the parent function that contains the resolved Purification option."},
        {"gatherTestsQ", BooleanP, "Indicates if tests are being gathered and messages are silenced, or tests are not gathered and messages are thrown."}
      },
      Output :> {
        {"purificationStepCountTests", {ListableP[TestP]...}, "A list of tests checking if there are more than 3 repetition of any purification step for the input samples."},
        {"purificationStepCountInvalidOptions", _List, "A list of Purification that contains more than 3 repetition of any purification step."}
      },
      SeeAlso -> {"checkSolidMedia", "checkPurificationConflictingOptions"},
      Author -> {"taylor.hochuli"}
    }
  }
];

DefineUsage[optionsFromUnitOperation,
  {
    BasicDefinitions -> {
      {
        "optionsFromUnitOperation[unitOperationPackets, unitOperationType, samples, samplesUsedList, options, mapThreadFriendlyOptions, optionMaps, stepUsedQ]", "resolvedOptions",
        "resolvedOptions",
        "returns lists of 'resolvedOptions' extracted from unit operation packets from the framework function (e.g. ExperimentRoboticCellPreparation)."
      }
    },
    {
      Input :> {
        {"unitOperationPackets", {PacketP[ObjectP[UnitOperations]]..}, "A list of packets of the resolved unit operations."},
        {"unitOperationType", {TypeP[]..}, "A list of types of unit operations that resolved options are extracted from."},
        {"samples", {ObjectP[Object[Sample]]..}, "The samples, simulated or real, that are fed to the parent function."},
        {"samplesUsedList", {{ObjectP[]...}..}, "Lists of samples that are subject to the corresponding 'unitOperationType'."},
        {"options", {_Rule..}, "The pre-resolved experiment options of the parent function that is fed to the ExperimentRoboticCellPreparation call."},
        {"mapThreadFriendlyOptions", {_Rule..}, "The map thread version of the pre-resolved experiment options of the parent function that is fed to the ExperimentRoboticCellPreparation call."},
        {"optionMaps", {_Rule..}, "A list of the incoming function's (e.g. ExperimentExtractProtein) option names,
           and their corresponding option name in the resolver function (e.g. ExperimentMagneticBeadSeparation) in the form: Incoming Function Option Name -> Resolver Function Option Name."},
        {"stepUsedQ", {BooleanP..}, "A list of booleans that indicate if the corresponding 'unitOperationType' is used for the incoming function."}
      },
      Output :> {
        {"resolvedOptions", {_Rule..}, "The fully resolved options extracted from unit operation packets."}
      },
      MoreInformation -> {},
      SeeAlso -> {
        "buildPurificationUnitOperations",
        "ExperimentRoboticCellPreparation"
      },
      Author -> {"melanie.reschke", "taylor.hochuli"}
    }
  }
];


DefineUsage[resolvePurification,
  {
    BasicDefinitions -> {
      {
        "resolvePurification[mapThreadFriendlyOptions, methods]", "resolvedOptions",
        "resolvedPurifcation",
        "returns lists of 'resolvedPurifcation' resvoled based on user and method specified Purification or purification options. If nothing is specified, it defaults to {LiquidLiquidExtraction, Precipitation}."
      }
    },
    {
      Input :> {
        {"mapThreadFriendlyOptions", {_Rule..}, "The map thread version of the unresolved or pre-resolved experiment options."},
        {"methods", {ObjectP[Object[Method]]|Custom..}, "A list of the resolved methods."}
      },
      Output :> {
        {"resolvedPurifcation", {ListableP[LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation]|None..}, "The list of resolved Purifcation values."}
      },
      MoreInformation -> {},
      SeeAlso -> {
        "buildPurificationUnitOperations",
        "preResolvePurificationSharedOptions"
      },
      Author -> {"melanie.reschke", "taylor.hochuli"}
    }
  }
];