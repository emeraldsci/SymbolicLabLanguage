(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,Aspiration], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to use a handheld aspirator.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    ContainerModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The container model from which the sample will be aspirated.",
      Category -> "General"
    },

    SampleModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The sample model that will be aspirated from the container.",
      Category -> "General"
    },

    SampleAmount -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Milliliter],
      Units -> Milliliter,
      Description -> "The amount of sample that will be transferred into the container.",
      Category -> "General"
    },

    Disinfectant -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The bleach solution model for disinfecting the aspiration waste container.",
      Category -> "General"
    },

    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument,BiosafetyCabinet],
      Description -> "The biosafety cabinet instrument model which contains the aspirator used to aspirate sample from the container.",
      Category -> "General"
    },

    TipModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item,Tips]|Model[Item, Consumable],
      Description -> "The tip model that will be attached to the aspirator.",
      Category -> "General"
    }
  }
}]