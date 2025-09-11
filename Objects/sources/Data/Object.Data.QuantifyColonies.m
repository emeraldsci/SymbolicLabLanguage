(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, QuantifyColonies], {
  Description -> "Information related to the colonies quantification performed on the sample by analysis of the appearance of the colonies.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    QuantificationColonySamples -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample][Data],
      Description -> "The list of plated cells containing colonies on solid media plates to be imaged and analyzed. For prepared sample, it only consists of the SamplesIn.",
      Category -> "General"
    },
    QuantificationColonyDilutionFactors -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[1],
      Description -> "For each member of QuantificationColonySamples, the factors by which the cells in SamplesIn are diluted when preparing QuantificationColonySamples. For prepared sample, this number is always 1.",
      IndexMatching -> QuantificationColonySamples,
      Category -> "General"
    },
    AllColonyAppearanceLog -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{_?DateObjectQ, _Link}..},
      Description -> "For each member of QuantificationColonySamples, a historical record of the appearance data containing the physical appearances of colonies.",
      IndexMatching -> QuantificationColonySamples,
      Category -> "Imaging Data"
    },
    (* Analysis & Reports *)
    ColonyAnalysisLog -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{_?DateObjectQ, _Link}..},
      Description -> "For each member of QuantificationColonySamples, a historical record of the colony analyses performed on the image files in order to count and categorize the colonies.",
      IndexMatching -> QuantificationColonySamples,
      Category -> "Analysis & Reports"
    },
    TotalColonyCountsLog -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{_?DateObjectQ, GreaterEqualP[0]}..},
      Description -> "For each member of QuantificationColonySamples, a historical record of the number of colonies detected from appearance data.",
      IndexMatching -> QuantificationColonySamples,
      Abstract -> True,
      Category -> "Analysis & Reports"
    },
    MinReliableColonyCount -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "The smallest number of colonies that can be counted on a solid media plate to provide a statistically reliable estimate of the concentration of microorganisms in a sample.",
      Category -> "Analysis & Reports"
    },
    MaxReliableColonyCount -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "The largest number of colonies that can be counted on a solid media plate beyond which accurate counting becomes impractical and unreliable.",
      Category -> "Analysis & Reports"
    },
    NumberOfStableIntervals -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "The number of consecutive intervals during which the number of colonies from TotalColonyCountsLog remain stable (do not increase). This metric helps determine whether all viable colonies have been accounted when calculating Colony Forming Units (CFU). Stability in total colony counts indicates that the growth phase has plateaued, ensuring an accurate count of all viable colonies present.",
      Category -> "Analysis & Reports"
    },
    ColonyGrowthAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis, ColonyGrowth],
      Description -> "For each member of QuantificationColonySamples, the latest colony growth analysis performed in order to track TotalColonyCount and morphological properties changes.",
      IndexMatching -> QuantificationColonySamples,
      Category -> "Analysis & Reports"
    },
    TotalColonyCounts -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of QuantificationColonySamples, the total number of detected colonies on the solid media plate, adjusted by multiplying QuantificationColonyDilutionFactors. If multiple measurements exist for a given QuantificationColonyDilutionFactor, the value is determined by either the latest colony count or the most recent count that falls within the reliable countable range.",
      IndexMatching -> QuantificationColonySamples,
      Category -> "Analysis & Reports"
    },
    CountableColony -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates whether, in the presence of multiple measurements or multiple QuantificationColonySamples, at least one number of detected colonies falls within the reliable countable range.",
      Category -> "Analysis & Reports"
    },
    PopulationTotalColonyCount -> {
      Format -> Multiple,
      Headers -> {"Identity Model", "average PopulationTotalColonyCount"},
      Class -> {Link, Real},
      Pattern :> {_Link, GreaterEqualP[0]},
      Relation-> {Model[Cell], Null},
      Description -> "The count represents the number of each detected colonies population, adjusted by multiplying with QuantificationColonyDilutionFactors. If multiple measurements exist for a given QuantificationColonyDilutionFactor, the value is determined by either the latest colony count or the most recent count within the reliable countable range. For multiple QuantificationColonySamples, it represents the average population count from QuantificationColonySamples with reliable total colony counts. If none of the samples are reliable, the average is taken from all QuantificationColonySamples.",
      Category -> "Analysis & Reports"
    },
    CellConcentration -> {
      Format -> Multiple,
      Headers -> {"Amount", "Identity Model", "Date"},
      Class -> {VariableUnit, Link, Date},
      Pattern :> {CompositionP, _Link, _?DateObjectQ},
      Relation -> {Null, IdentityModelTypeP, Null},
      Description -> "The updated composition for cell models in SamplesIn calculated from PopulationTotalColonyCount, associated with experiment start time. For multiple QuantificationColonySamples, it represents the average cell concentration from QuantificationColonySamples with reliable total colony counts. If none of the samples are reliable, the average is taken from all QuantificationColonySamples.",
      Abstract -> True,
      Category -> "Analysis & Reports"
    }
  }
}];
