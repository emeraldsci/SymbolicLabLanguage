(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolveExtractionSolidPhaseSharedOptions*)

DefineUsage[preResolveExtractionSolidPhaseSharedOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"preResolveExtractionSolidPhaseSharedOptions[samples, methods, optionMap, options, mapThreadFriendlyOptions]","{preResolvedOptions}"},
        Description->"returns a list of 'preResolvedOptions' for solid phase extraction shared options for biology experiments that are ready for input into ExperimentSolidPhaseExtraction.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into ExperimentSolidPhaseExtraction.",
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
            {
              InputName->"methods",
              Description->"The Object[Method]s for each of the input samples. Used to resolve the solid phase extraction shared options if specified by the user.",
              Widget->Alternatives[
                Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Method]}]
                ],
                Widget[
                  Type -> Expression,
                  Pattern :> Alternatives[Custom],
                  Size -> Line
                ]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ],
          {
            InputName->"optionMap",
            Description->"A list of the incoming function's option names (to be resolved in ExperimentSolidPhaseExtraction),
             and their corresponding option name in ExperimentSolidPhaseExtraction in the form:
              Incoming Function Option Name -> ExperimentSolidPhaseExtraction Option Name.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          {
            InputName->"options",
            Description->"The experiment options of the parent function (the function calling preResolveExtractionSolidPhaseSharedOptions) that contains the solid phase extraction shared options.",
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
              Description->"The map thread version of the experiment options of the parent function (the function calling preResolveExtractionSolidPhaseSharedOptions) that contains the solid phase extraction shared options.",
              Widget->Widget[
                Type -> Expression,
                Pattern :> {_Rule..},
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
            Description->"The pre-resolved solid phase extraction shared options.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentSolidPhaseExtraction",
      "preResolvePurificationSharedOptions",
      "preResolvePrecipitationSharedOptions",
      "preResolveLiquidLiquidExtractionSharedOptions",
      "preResolveMagneticBeadSeparationSharedOptions"
    },
    Author -> {"melanie.reschke"}
  }
];


(* ::Subsection:: *)
(*solidPhaseExtractionConflictingOptionsChecks*)
DefineUsage[solidPhaseExtractionConflictingOptionsChecks,
  {
    BasicDefinitions -> {
      {
        "solidPhaseExtractionConflictingOptionsChecks[samples, resolvedOptions, gatherTestsQ]",
        "{invalidMethodTests, invalidMethodOptions}",
        "returns a list of tests and invalid options of SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument if SolidPhaseExtractionTechnique is set to a technique that cannot be performed by the set SolidPhaseExtractionInstrument. If gatherTestsQ is False, solidPhaseExtractionConflictingOptionsChecks returns empty tests and also returns Error::ConflictingMagneticBeadSeparationMethods if triggered. If gatherTestsQ is True, solidPhaseExtractionConflictingOptionsChecks returns tests and does not throw an error message."
      }
    },
    {
      Input :> {
        {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument will be checked for compatibility."},
        {"resolvedOptions", {_Rule..}, "The experiment options of the parent function that contains the resolved SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument options."},
        {"gatherTestsQ", BooleanP, "Indicates if tests are being gathered and messages are silenced, or tests are not gathered and messages are thrown."}
      },
      Output :> {
        {"conflictingSPETechniqueInstrumentTests", {ListableP[TestP]...}, "A list of tests checking if MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode are not inconsistently specified by the method and the user."},
        {"invalidOptions", _List, "A list of SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument if SolidPhaseExtractionTechnique is set to a technique that cannot be performed by the set SolidPhaseExtractionInstrument."}
      },
      SeeAlso -> {"checkPurificationConflictingOptions","mbsMethodsConflictingOptionsTests","preResolveExtractionSolidPhaseSharedOptions"},
      Author -> {"melanie.reschke"}
    }
  }
];