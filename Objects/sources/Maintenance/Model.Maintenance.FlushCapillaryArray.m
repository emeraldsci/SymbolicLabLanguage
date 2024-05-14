(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-02-27 *)

DefineObjectType[Model[Maintenance, FlushCapillaryArray], {
  Description->"Definition of a set of parameters for a maintenance protocol that flushes the capillary array of fragment analyzer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    PrimaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used to flush the primary capillary.",
      Category -> "General",
      Abstract -> True
    },

    SecondaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used to flush the secondary capillary.",
      Category -> "General",
      Abstract -> True
    },

    TertiaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used to flush the tertiary capillary.",
      Category -> "General",
      Abstract -> True
    },

    SamplePreparationUnitOperations->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying the loading of the sample container with the desired solution for use in Maintenance.",
      Category -> "General"
    }
  }
}];
