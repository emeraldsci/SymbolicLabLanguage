(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsage[ExperimentWashCells,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentWashCells[Samples]","Protocol"},
        Description->"creates a 'Protocol' object to wash living cells in order to remove impurities, debris, metablis, and media from cell samples that prohibits further cell growth or interfers with downstream experiments.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The cell samples to be washed by removing old buffer and adding fresh buffer.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type -> Object,
                  Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                  Dereference -> {
                    Object[Container] -> Field[Contents[[All, 2]]]
                  }
                ],
                "Container with Well Position"->{
                  "Well Position"->Alternatives[
                    "A1 to P24"->Widget[
                      Type->Enumeration,
                      Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
                      PatternTooltip->"Enumeration must be any well from A1 to P24."
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
              Expandable->False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"The protocol object(s) describing how to preform the cell wash procedure.",
            Pattern:>ListableP[ObjectP[Object[Protocol, RoboticCellPreparation]]]
          }
        }
      }
    },
    SeeAlso -> {
      "ValidExperimentWashCellsQ",
      "ExperimentWashCellsOptions",
      "ExperimentChangeMedia"
    },
    Tutorials -> {},
    Author -> {"xu.yi"}
  }
];

DefineUsage[WashCells,
  {
    BasicDefinitions -> {
      {"WashCells[washCellsRules]","primitive","generates an ExperimentRoboticCellPreparation-compatible 'primitive' that describes a wash cells process."}
    },
    Input:>{
      {
        "washCellsRules",
        {
          Sample-> ListableP[(ObjectP[{Object[Sample], Object[Container]}]|
              ObjectP[{Object[Container]}]|
              {Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]], LocationPositionP})]
        },
        "The list of key/value pairs specifying the samples in the WashCells primitive."
      }
    },
    Output:>{
      {"primitive",_WashCells,"A robotic cell preparation primitive containing information for specification and execution of a general wash cells process."}
    },
    Sync -> Automatic,
    SeeAlso -> {
      "ExperimentRoboticCellPreparation",
      "ChangeMedia",
      "Incubate",
      "Pellet",
      "Transfer",
      "ExperimentWashCells",
      "ExperimentChangeMedia"
    },
    Author -> {"xu.yi"}
  }
];