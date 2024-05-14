(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, EpitopeBinning], {
  Description->"Fitting of the unknown kinetic rates in a ReactionMechanism using experimental or simulated kinetic trajectories.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SamplesIn -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The samples for which the epitope binning analysis was performed.",
      Category -> "General",
      Abstract -> True
    },
    Threshold -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "The cutoff factor to distinguish between blocking and non-blocking pairs.",
      Category -> "General"
    },
    SlowBindingThreshold -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "The cutoff factor to distinguish between blocking and non-blocking pairs for interactions when the competing species exhibits slow binding.",
      Category -> "General"
    },
    SlowBindingSpecies ->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ObjectP[],
      Description -> "Species that are considered to bind more slowly during competition steps and were processed using SlowBinderThreshold.",
      Category -> "General"
    },
    (* pairs with weights that can be used in the graph *)
    (* this field can sometimes be a problem when the baseline is higher than the observed response *)
    CompetitionData -> {
      Format -> Multiple,
      Class ->{Expression, Expression, Real},
      Pattern :> {(ObjectP[]|_String), (ObjectP[]|_String), GreaterEqualP[-500]},
      Units -> {None, None, None},
      Description -> "The measured binning response for a given pair of bound and unbound antibodies.",
      Headers -> {"Loaded Antibody", "Competing Antibody", "Normalized Response"},
      Category -> "Analysis & Reports"
    },
    BinnedInputs ->{
      Format -> Multiple,
      Class-> {Expression, Integer},
      Pattern:> {(ObjectP[]|_String), GreaterP[0]},
      Description -> "A list of the input objects with their associated bins as defined by the Threshold.",
      Headers -> {"Antibody","Bin"},
      Category -> "Analysis & Reports"
    }
  }
}];
