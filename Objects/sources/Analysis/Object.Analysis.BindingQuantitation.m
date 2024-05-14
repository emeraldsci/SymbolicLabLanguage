(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, BindingQuantitation], {
  Description->"Concentrations of the target analyte as calculated from analyte association rates with respect to standard curve.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SamplesIn -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The samples for which the total protein concentration is being quantified.",
      Category -> "General"
    },
    AssayData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The primary data upon which the analysis was performed.",
      Category -> "General"
    },

    (* the fit parameters *)
    SamplesInConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterP[0*Nano*Molar], GreaterP[0*Milli*Gram/Milliliter]],
      Units -> None,
      Description -> "For each member of SamplesIn, the concentrations calculated from the standard curve.",
      Category -> "Analysis & Reports",
      IndexMatching->SamplesIn
    },
    ConcentrationDistributions->{
      Format->Multiple,
      Class->Expression,
      Pattern:>DistributionP[],
      Description->"For each member of SamplesIn, the statistical distribution of the analyte concentrations calculated by this analysis.",
      IndexMatching->SamplesIn,
      Category -> "Analysis & Reports"
    },
    Rate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> NumericP,
      Units -> 1/Second,
      Description -> "For each member of SamplesIn, the fitted values the binding rate of each sample.",
      Category -> "Analysis & Reports",
      IndexMatching->SamplesIn
    },
    RateError->{
      Format->Multiple,
      Class->Real,
      Pattern:> NumericP,
      Units -> 1/Second,
      Description->"For each member of SamplesIn, the error in the fitted analyte association rates calculated by this analysis.",
      IndexMatching->SamplesIn,
      Category -> "Analysis & Reports"
    },
    EquilibriumResponse -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> RangeP[-1000 Nano Meter, 1000 Nano Meter],
      Units -> Nano Meter,
      Description -> "For each member of SamplesIn, the fitted values the equilibrium response of each sample.",
      Category -> "Analysis & Reports",
      IndexMatching -> SamplesIn
    },
    EquilibriumResponseError->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterP[0 Nanometer],
      Units -> Nanometer,
      Description->"For each member of SamplesIn, the error in the equilibrium response calculated by this analysis.",
      IndexMatching->SamplesIn,
      Category -> "Analysis & Reports"
    },
    SamplesInFitting -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :>_Link,
      Relation -> Object[Analysis, Fit],
      Description -> "For each member of SamplesIn, the fitting analysis of the sample data.",
      IndexMatching -> SamplesIn,
      Category -> "General"
    },
    StandardData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The data used to generate the standard curve.",
      Category -> "General"
    },
    StandardDataFitAnalysis -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :>_Link,
      Relation -> Object[Analysis, Fit],
      Description -> "For each member of StandardData, the fitting analysis of the sample data.",
      IndexMatching -> StandardData,
      Category -> "General"
    },
    StandardConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterP[0*Nano*Molar], GreaterP[0*Milli*Gram/Milliliter], GreaterP[0*Gram/Liter]],
      Units -> None,
      Description -> "For each member of StandardData, the concentration of the standard solution used to generate that data.",
      Category -> "General",
      IndexMatching -> StandardData
    },
    StandardCurveFitAnalysis -> {
      Format -> Single,
      Class -> Link,
      Pattern :>_Link,
      Relation -> Object[Analysis, Fit],
      Description -> "The fitting analysis of the standard curve.",
      Category -> "Analysis & Reports"
    }
  }
}];
