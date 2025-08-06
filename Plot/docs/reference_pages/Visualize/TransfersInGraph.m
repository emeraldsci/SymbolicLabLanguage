(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(*TODO: Discuss if temporal links can be used, or if the date option should always be used*)

DefineUsage[TransfersInGraph,
  {
    BasicDefinitions -> {
      {
        Definition -> {"TransfersInGraph[Samples]", "Graph"},
        Description -> "generates visual maps that show the transfers of source samples into destination 'Samples' through multiple transfer levels. The vertices (nodes or points) represent individual samples, while the edges (links) illustrate transfers into those samples. Hovering over a vertex displays a brief table with sample information, while hovering over an edge reveals details about the transfer from the source to the destination. These graphs provide insight into a sample's history and origins, tracing it back to the original sample received from the supplier. This information is particularly valuable when investigating issues related to sample preparation.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples for which a graphical representation of the transfers into the sample are created.", (*TODO: Clean up grammar*)
              Expandable -> False,
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
                      PatternTooltip -> "Any valid container position.", (*TODO: Come up with something better and do replace global*)
                      Size -> Line
                    ]
                  ],
                  "Container" -> Widget[
                    Type -> Object,
                    Pattern :> ObjectP[{Object[Container]}]
                  ]
                }
              ]
            },
            IndexName -> "samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Graph",
            Description -> "The graph showing samples which were transferred into the destination sample.",
            Pattern :> _Graph
          }
        }
      }
    },
    SeeAlso -> {
      (*TransfersOutGraph, which will be the opposite of this function tracking transfers out
      "UpstreamSampleUsage", (*Phase out this function*)
      "DownstreamSampleUsage",  (*Phase out this function*)*)
      (*TODO: Sample location history function that Melanie is working on*)
      "PlotContents",
      "PlotLocation"
    },
    Author -> {"dirk.schild"}
  }];