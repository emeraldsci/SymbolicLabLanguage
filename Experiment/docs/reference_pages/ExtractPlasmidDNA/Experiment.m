(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentExtractPlasmidDNA*)

DefineUsage[ExperimentExtractPlasmidDNA,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentExtractPlasmidDNA[Samples]","Protocol"},
        Description->"creates a 'Protocol' object for isolating plasmid DNA from live cell or cell lysate 'Samples' through lysing (if dealing with cells, rather than lysate), then neutralizing the pH of the solution to keep plasmid DNA soluble (through renaturing) and pelleting out insoluble cell components, followed by one or more rounds of optional purification techniques including  precipitation (such as a cold ethanol or isopropanol wash), liquid-liquid extraction (such as phenol:chloroform extraction), solid phase extraction (such as spin columns), and magnetic bead separation (selectively binding plasmid DNA to magnetic beads while washing non-binding impurities from the mixture).",
        Inputs:>{
          IndexMatching[
            IndexName->"experiment samples",
            {
              InputName->"Samples",
              Description->"The live cell or cell lysate samples from which plasmid DNA is to be extracted.",
              Widget->Alternatives[
                "Sample or Container"->Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Container with Well Position"->{
                  "Well Position" -> Alternatives[
                    "A1 to H12" -> Widget[
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
              Expandable->False
            }
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"Protocol generated to isolate plasmid DNA from live cell(s) or cell lysate(s) in the input object(s) or container(s).",
            Pattern:>ObjectP[Object[Protocol,ExtractPlasmidDNA]]
          }
        }
      }
    },
    SeeAlso->{
      ExperimentExtractRNA,
      ExperimentExtractProtein,
      ExperimentLyseCells,
      ExperimentSolidPhaseExtraction,
      ExperimentLiquidLiquidExtraction,
      ExperimentPrecipitate,
      ExperimentMagneticBeadSeparation
    },
    Author->{"taylor.hochuli"}
  }];