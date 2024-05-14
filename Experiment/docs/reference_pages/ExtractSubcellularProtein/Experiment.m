(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentExtractRNA*)

DefineUsage[ExperimentExtractSubcellularProtein,
  {
    BasicDefinitions->{
      {
        Definition->{"ExperimentExtractSubcellularProtein[Samples]","Protocol"},
        Description->"creates a 'Protocol' object for isolating subcellular proteins from live cells or cell lysate 'Samples', then fractionate and collect cellular components from one or more subcellular fractions (cytosolic, membrane, and nuclear) by centrifugation or filtration, followed by one or more rounds of optional purification techniques including precipitation (such as by adding ammonium sulfate, TCA (trichloroacetic acid), or acetone etc.), liquid-liquid extraction (e.g. adding C4 and C5 alcohols (butanol, pentanol) followed by ammonium sulfate into the protein-containing aqueous solution), solid phase extraction (such as spin columns), and magnetic bead separation (selectively binding proteins to magnetic beads while washing non-binding impurities from the mixture). Note that ExperimentExtractSubcellularProtein is intended to extract subcellular fractionated proteins from the cells or lysate. If no fractionation is desired, please see ExperimentExtractProtein.",
        Inputs:>{
          IndexMatching[
            {
              InputName->"Samples",
              Description->"The cell or cell lysate samples from which subcellular proteins are to be extracted",
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
            Description->"Protocol generated to isolate subcellular proteins from cells or cell lysates in the input object(s) or containter(s).",
            Pattern:>ObjectP[Object[Protocol,RoboticCellPreparation]]
          }
        }
      }
    },
    MoreInformation->{

    },
    SeeAlso->{
      ExperimentExtractSubcellularProteinOptions,
      ValidExperimentExtractSubcellularProteinQ,
      ExperimentExtractProtein,
      ExperimentHarvestProtein,
      ExperimentExtractOrganelle,
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