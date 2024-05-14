(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,ReversePipetting], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to implement reverse pipetting technique.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ReversePipettingPreparatoryUnitOperations -> {
      Format-> Multiple,
      Class-> Expression,
      Pattern:> SamplePreparationP,
      Description-> "The list of sample preparation unit operations performed to test the user's ability to perform a reverse pipetting transfer.",
      Category-> "General"
    },
    SampleModels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The Model of liquid sample used for this practical.",
      Category -> "General"
    },
    ContainerModels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container, Vessel],
      Description -> "For each member of SampleModels, The Model of container for liquid sample to be transferred in.",
      Category -> "General",
      IndexMatching -> SampleModels
    },
    TransferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Milliliter],
      Units -> Milliliter,
      Description -> "For each member of SampleModels, indicate the volume to be transfered in this practical.",
      Category -> "General",
      IndexMatching -> SampleModels
    }
  }
}];