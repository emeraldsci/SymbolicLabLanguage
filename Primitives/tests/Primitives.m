DefineTests[
  DefinePrimitive,
  {
    Example[{Basic,"Define a primitive:"},
      (* NOTE: We have to stub out these functions manually since we don't want to define a unit operation object type just for testing. *)
      Module[{mixLookup,fields},
        mixLookup=Constellation`Private`getUnitOperationsSplitFieldsLookup[Object[UnitOperation, Mix]];
        fields=Fields[Object[UnitOperation, Mix], Output -> Short];

        Block[{$PrimitiveSetPrimitiveLookup={}, Fields, Constellation`Private`getUnitOperationsSplitFieldsLookup},
          Constellation`Private`getUnitOperationsSplitFieldsLookup[_]:=mixLookup;
          Fields[_, Output -> Short]:=fields;

          Module[{TestPrimitive, mixSharedOptions, mixNonIndexMatchingSharedOptions, mixIndexMatchingSharedOptions},
            (* Copy over all of the options from ExperimentMix -- except for the funtopia shared options (Cache, Upload, etc.) *)
            mixSharedOptions=UnsortedComplement[
              Options[ExperimentMix][[All, 1]],
              Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
            ];

            mixNonIndexMatchingSharedOptions=UnsortedComplement[
              mixSharedOptions,
              Cases[OptionDefinition[ExperimentMix], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
            ];

            mixIndexMatchingSharedOptions=UnsortedComplement[
              mixSharedOptions,
              mixNonIndexMatchingSharedOptions
            ];

            DefinePrimitive[TestPrimitive,
              (* Input Options *)
              Options :> {
                IndexMatching[
                  {
                    OptionName -> Sample,
                    Default -> Null,
                    Description -> "The samples that should be tested.",
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
              Generative->False,
              Category->"Sample Preparation",
              Description->"Heat and/or mix samples for a specified period of time."
            ]
          ]
        ]
      ],
      _Association
    ]
  },
  Stubs:>{
    TypeP[Object[UnitOperation]]:=Object[UnitOperation, _]
  }
];

DefineTests[
  DefinePrimitiveSet,
  {
    Example[{Basic,"Define a primitive set:"},
      (* NOTE: We have to stub out these functions manually since we don't want to define a unit operation object type just for testing. *)
      Module[{mixLookup,fields},
        mixLookup=Constellation`Private`getUnitOperationsSplitFieldsLookup[Object[UnitOperation, Mix]];
        fields=Fields[Object[UnitOperation, Mix], Output -> Short];

        Block[{$PrimitiveSetPrimitiveLookup=<||>, Fields, Constellation`Private`getUnitOperationsSplitFieldsLookup},
          Constellation`Private`getUnitOperationsSplitFieldsLookup[_]:=mixLookup;
          Fields[_, Output -> Short]:=fields;

          Module[{TestPrimitive, mixSharedOptions, mixNonIndexMatchingSharedOptions, mixIndexMatchingSharedOptions, primitiveInformation, TestPrimitiveSetP},
            (* Copy over all of the options from ExperimentMix -- except for the funtopia shared options (Cache, Upload, etc.) *)
            mixSharedOptions=UnsortedComplement[
              Options[ExperimentMix][[All, 1]],
              Flatten[{Options[ProtocolOptions][[All, 1]], $NonUnitOperationSharedOptions}]
            ];

            mixNonIndexMatchingSharedOptions=UnsortedComplement[
              mixSharedOptions,
              Cases[OptionDefinition[ExperimentMix], KeyValuePattern["IndexMatching" -> Except["None"]]][[All, "OptionName"]]
            ];

            mixIndexMatchingSharedOptions=UnsortedComplement[
              mixSharedOptions,
              mixNonIndexMatchingSharedOptions
            ];

            primitiveInformation=DefinePrimitive[TestPrimitive,
              (* Input Options *)
              Options :> {
                IndexMatching[
                  {
                    OptionName -> Sample,
                    Default -> Null,
                    Description -> "The samples that should be tested.",
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
              Generative->False,
              Category->"Sample Preparation",
              Description->"Heat and/or mix samples for a specified period of time."
            ];

            DefinePrimitiveSet[TestPrimitiveSetP,
              {
                primitiveInformation
              }
            ];

            TestPrimitiveSetP
          ]
        ]
      ],
      Except[_Symbol]
    ]
  },
  Stubs:>{
    TypeP[Object[UnitOperation]]:=Object[UnitOperation, _]
  }
];

