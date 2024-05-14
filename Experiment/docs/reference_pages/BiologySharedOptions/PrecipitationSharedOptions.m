(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolvePrecipitationSharedOptions*)

DefineUsage[preResolvePrecipitationSharedOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"preResolvePrecipitationSharedOptions[samples, methods, optionMap, options, mapThreadFriendlyOptions]","{preResolvedOptions}"},
        Description->"returns a list of 'preResolvedOptions' for precipitation shared options for biology experiments that are ready for input into ExperimentPrecipitate.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into ExperimentPrecipitate.",
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
              Description->"The Object[Method]s for each of the input samples. Used to resolve the precipitation shared options if specified by the user.",
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
            Description->"A list of the incoming function's option names (to be resolved in ExperimentPrecipitate),
             and their corresponding option name in ExperimentPrecipitate in the form:
              Incoming Function Option Name -> ExperimentPrecipitate Option Name.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          {
            InputName->"options",
            Description->"The experiment options of the parent function (the function calling preResolvePrecipitationSharedOptions) that contains the precipitation shared options.",
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
              Description->"The map thread version of the experiment options of the parent function (the function calling preResolvePrecipitationSharedOptions) that contains the precipitation shared options.",
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
            Description->"The pre-resolved precipitation shared options.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentPrecipitate",
      "preResolvePurificationSharedOptions",
      "preResolveLiquidLiquidExtractionSharedOptions",
      "preResolveExtractionSolidPhaseSharedOptions",
      "preResolveMagneticBeadSeparationSharedOptions"
    },
    Author -> {"tim.pierpont"}
  }
];