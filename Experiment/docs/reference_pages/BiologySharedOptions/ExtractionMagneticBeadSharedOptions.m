(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolveMagneticBeadSeparationSharedOptions*)

DefineUsage[preResolveMagneticBeadSeparationSharedOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"preResolveMagneticBeadSeparationSharedOptions[samples, methods, optionMap, options, mapThreadFriendlyOptions]","{preResolvedOptions}"},
        Description->"returns a list of 'preResolvedOptions' for magnetic bead separation shared options for biology experiments that are ready for input into ExperimentMagneticBeadSeparation. The options are pre-resolved based on user input, resolved method, and default for the biology experiments.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into ExperimentMagneticBeadSeparation.",
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
              Description->"The Object[Method]s for each of the input samples. Used to resolve the magnetic bead separation shared options if specified by the user.",
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
            Description->"A list of the incoming function's option names (to be resolved in ExperimentMagneticBeadSeparation),
             and their corresponding option name in ExperimentMagneticBeadSeparation in the form:
              Incoming Function Option Name -> ExperimentMagneticBeadSeparation Option Name.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          {
            InputName->"options",
            Description->"The experiment options of the parent function (the function calling preResolveMagneticBeadSeparationSharedOptions) that contains the magnetic bead separation shared options.",
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
              Description->"The map thread version of the experiment options of the parent function (the function calling preResolveMagneticBeadSeparationSharedOptions) that contains the magnetic bead separation shared options.",
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
            Description->"The pre-resolved magnetic bead separation shared options.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentMagneticBeadSeparation",
      "preResolvePurificationSharedOptions",
      "preResolvePrecipitationSharedOptions",
      "preResolveExtractionSolidPhaseSharedOptions",
      "preResolveLiquidLiquidExtractionSharedOptions"
    },
    Author -> {"yanzhe.zhu"}
  }
];

(* ::Subsection:: *)
(*mbsMethodsConflictingOptionsTests*)
DefineUsage[mbsMethodsConflictingOptionsTests,
  {
    BasicDefinitions -> {
      {
        "mbsMethodsConflictingOptionsTests[samples, resolvedOptions, gatherTestsQ]",
        "{invalidMethodTests, invalidMethodOptions}",
        "returns a list of tests and invalid options of Method if MagneticBeadSeparationSelectionStrategy or MagneticBeadSeparationMode is specified differently by the method and the user. For non-index-matching options MagneticBeadSeparationMode and MagneticBeadSeparationSelectionStrategy, the values are required to be the same within an experiment. If gatherTestsQ is False, mbsMethodsConflictingOptionsTests returns empty tests and also returns Error::ConflictingMagneticBeadSeparationMethods if triggered. If gatherTestsQ is True, mbsMethodsConflictingOptionsTests returns tests and does not throw an error message."
      }
    },
    {
      Input :> {
        {"samples", {ObjectP[Object[Sample]]..}, "A sample object or list of sample objects for which MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode from resolvedOptions and from the resolved Method will be checked for consistency."},
        {"resolvedOptions", {_Rule..}, "The experiment options of the parent function that contains the resolved MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode option and resolved Method."},
        {"gatherTestsQ", BooleanP, "Indicates if tests are being gathered and messages are silenced, or tests are not gathered and messages are thrown."}
      },
      Output :> {
        {"invalidMBSTests", {ListableP[TestP]...}, "A list of tests checking if MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode are not inconsistently specified by the method and the user."},
        {"invalidMethodOptions", _List, "A list of Method if there is MagneticBeadSeparationSelectionStrategy or MagneticBeadSeparationMode inconsistently specified by the method and the user."}
      },
      SeeAlso -> {"ValidObjectQ", "checkPurificationConflictingOptions","solidPhaseExtractionConflictingOptionsChecks","preResolveMagneticBeadSeparationSharedOptions"},
      Author -> {"yanzhe.zhu"}
    }
  }
];