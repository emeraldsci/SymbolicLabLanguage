(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolveLiquidLiquidExtractionSharedOptions*)

DefineUsage[preResolveLiquidLiquidExtractionSharedOptions,
  {
    BasicDefinitions -> {
      {
        Definition->{"preResolveLiquidLiquidExtractionSharedOptions[samples, methods, optionMap, options, mapThreadFriendlyOptions]","{preResolvedOptions}"},
        Description->"returns a list of 'preResolvedOptions' for liquid-liquid extraction shared options for biology experiments that are ready for input into ExperimentLiquidLiquidExtraction.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "samples",
              Description-> "The samples, simulated or real, that will be fed into ExperimentLiquidLiquidExtraction.",
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
              Description->"The Object[Method]s for each of the input samples. Used to resolve the liquid-liquid extraction shared options if specified by the user.",
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
            Description->"A list of the incoming function's option names (to be resolved in ExperimentLiquidLiquidExtraction),
             and their corresponding option name in ExperimentLiquidLiquidExtraction in the form:
              Incoming Function Option Name -> ExperimentLiquidLiquidExtraction Option Name.",
            Widget->Widget[
              Type -> Expression,
              Pattern :> {_Rule..},
              Size -> Line
            ],
            Expandable->False
          },
          {
            InputName->"options",
            Description->"The experiment options of the parent function (the function calling preResolveLiquidLiquidExtractionSharedOptions) that contains the liquid-liquid extraction shared options.",
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
              Description->"The map thread version of the experiment options of the parent function (the function calling preResolveLiquidLiquidExtractionSharedOptions) that contains the liquid-liquid extraction shared options.",
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
            Description->"The pre-resolved liquid-liquid extraction shared options.",
            Pattern:>{_Rule..}
          }
        }
      }
    },
    MoreInformation -> {},
    SeeAlso -> {
      "ExperimentLiquidLiquidExtraction",
      "preResolvePurificationSharedOptions",
      "preResolvePrecipitationSharedOptions",
      "preResolveExtractionSolidPhaseSharedOptions",
      "preResolveMagneticBeadSeparationSharedOptions"
    },
    Author -> {"taylor.hochuli"}
  }
];