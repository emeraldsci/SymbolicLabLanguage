(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, BindingKinetics], {
  Description->"Fitting of the unknown kinetic rates in a ReactionMechanism using experimental or simulated kinetic trajectories.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    Solution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The sample for which the kinetics analysis was performed.",
      Category -> "General",
      Abstract -> True
    },
    FitMechanism -> {
      Format -> Multiple,
      Class -> Compressed,
      Pattern :> ReactionMechanismP,
      Units -> None,
      Description -> "A ReactionMechanism containing some unknown kinetic rates, which is fitted by this analysis.",
      Category -> "General"
    },
    AssociationTrainingData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The association data that the kinetic rates are fit to.",
      Category -> "General"
    },
    DissociationTrainingData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The dissociation data that the kinetic rates are fit to.",
      Category -> "General"
    },
    AssociationRates -> {
      Format -> Multiple,
      Class -> {Expression, Real},
      Pattern :> {_Symbol, NumericP},
      Units -> {None, None},
      Description -> "The unknown rate variables from the FitMechanism along with their fitted values in 1/Molar*Second.",
      Category -> "Analysis & Reports",
      Headers->{"Rate Variable Name", "Fitted Value"}
    },
    DissociationRates -> {
      Format -> Multiple,
      Class -> {Expression, Real},
      Pattern :> {_Symbol, NumericP},
      Units -> {None, None},
      Description -> "The unknown rate variables from the FitMechanism along with their fitted values in 1/Second.",
      Category -> "Analysis & Reports",
      Headers->{"Rate Variable Name", "Fitted Value"}
    },
    DissociationConstants ->{
      Format -> Multiple,
      Class->Real,
      Pattern:>NumericP,
      Units->None,
      Description -> "The Dissociation constant for the binding of the analyte to the surface bound ligand. If multiple interactions are indicated by the FitModel, a dissociation constant is reported for each interaction in the order it appears in the reaction mechanism.",
      Category -> "Analysis & Reports"
    },
    (* AssociationRatesError -> {
      Format -> Multiple,
      Class -> {Expression, Real},
      Pattern :> {_Symbol, NumericP},
      Units -> {None, None},
      Description -> "The error in the fitted association rates.",
      Category -> "Analysis & Reports",
      Headers->{"Rate Variable Name", "Fitted Value Error"}
    },
    DissociationRatesError -> {
      Format -> Multiple,
      Class -> {Expression, Real},
      Pattern :> {_Symbol, NumericP},
      Units -> {None, None},
      Description -> "The error in the fitted dissociation rates.",
      Category -> "Analysis & Reports",
      Headers->{"Rate Variable Name", "Fitted Value Error"}
    },*)
    (*PredictedAssociationTrajectories -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second, Nano Meter}],
      Units -> {Second, Nano Meter},
      Description -> "The kinetic association trajectories predicted by the fit models.",
      Category -> "Analysis & Reports"
    },
    PredictedDissociationTrajectories -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second, Nano Meter}],
      Units -> {Second, Nano Meter},
      Description -> "The kinetic dissociation trajectories predicted by the fit models.",
      Category -> "Analysis & Reports"
    },*)
    PredictedTrajectories -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second, Nano Meter}],
      Units -> {Second, Nano Meter},
      Description -> "The kinetic trajectories predicted by the fit models.",
      Category -> "Analysis & Reports"
    },
    NumberOfIterations -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "The number of steps required to by the optimizer to solve for the kinetic rates, which is a measure of how difficult the fitting was. For individual fits, the number of steps is given for each data set that was fit.",
      Category -> "Analysis & Reports"
    },
    Residuals -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> NumericP,
      Units -> None,
      Description -> "The minimum value of the objective function, which is achieved at the solution of the optimization problem (i.e. the fitted rates).  This is a measure of how well the fitted model matches the training data.",
      Category -> "Analysis & Reports"
    },
    SumSquaredError -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "Sum of squared errors across all training trajectories and predicted trajectories.",
      Category -> "Statistical Information"
    },
    IndividualFitRates -> {
      Format -> Multiple,
      Class -> {Expression, Real},
      Pattern :> {_Symbol, NumericP},
      Units -> {None, None},
      Description -> "The list of unitless fit parameters for each set of data in cases where the fitting is performed on each data set individually.",
      Category -> "Analysis & Reports",
      Headers->{"Rate Variable Name", "Fitted Value"}
    }
  }
}];
