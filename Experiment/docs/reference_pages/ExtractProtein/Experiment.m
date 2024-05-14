(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentExtractRNA*)

DefineUsage[ExperimentExtractProtein,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentExtractProtein[Samples]","Protocol"},
        Description->"creates a 'Protocol' object for isolating proteins from live cell or cell lysate 'Samples', followed by one or more rounds of optional purification techniques including  precipitation (such as by adding ammonium sulfate, TCA (trichloroacetic acid), or acetone etc.), liquid-liquid extraction (e.g. adding C4 and C5 alcohols (butanol, pentanol) followed by ammonium sulfate into the protein-containing aqueous solution), solid phase extraction (such as spin columns), and magnetic bead separation (selectively binding proteins to magnetic beads while washing non-binding impurities from the mixture). Note that ExperimentExtractProtein is intended to extract specific or non-specific proteins from the whole cells or cell lysate. If subcellular fractionation is desired to acquire cytosolic, membrane, or nuclear proteins, please see ExperimentExtractSubcellularProtein.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The cell or cell lysate samples from which proteins are to be extracted",
              Widget->Alternatives[
                "Sample or Container"->Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Container with Well Position"->{
                  "Well Position"->Widget[
                    Type->String,
                    Pattern:>WellPositionP,
                    Size->Line,
                    PatternTooltip->"Enumeration must be any well from A1 to H12."
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
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"Protocol generated to isolate proteins from cells or cell lysates in the input object(s) or containter(s).",
            Pattern:>ObjectP[Object[Protocol,RoboticCellPreparation]]
          }
        }
      }
    },
    MoreInformation->{

    },
    SeeAlso->{
      ExperimentExtractProteinOptions,
      ValidExperimentExtractProteinQ,
      ExperimentExtractSubcellularProtein,
      ExperimentHarvestProtein,
      ExperimentExtractPlasmidDNA,
      ExperimentExtractGenomicDNA,
      ExperimentExtractRNA,
      ExperimentLyseCells,
      ExperimentSolidPhaseExtraction,
      ExperimentLiquidLiquidExtraction,
      ExperimentPrecipitation,
      ExperimentMagneticBeadSeparation,
      ExperimentTotalProteinDetection,
      ExperimentTotalProteinQuantification,
      ExperimentWestern,
      ExperimentPAGE,
      ExperimentELISA,
      ExperimentHPLC,
      ExperimentFPLC,
      ExperimentLCMS
    },
    Tutorials->{

    },
    Author->{
      "yanzhe.zhu"
    }

  }];