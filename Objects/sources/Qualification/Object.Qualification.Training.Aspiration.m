(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,Aspiration], {
  Description -> "A protocol that verifies an operator's ability to use a handheld aspirator.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    SampleObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description -> "The sample object that will be aspirated from the container.",
      Category -> "General"
    },

    ContainerObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "The container object that will be weighed before addition of the sample and after removal of the sample by aspiration.",
      Category -> "General"
    },

    Disinfectant -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The freshly prepared bleach solution object for disinfecting the aspiration waste container.",
      Category -> "General"
    },

    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument,BiosafetyCabinet],Model[Instrument,BiosafetyCabinet]],
      Description -> "The biosafety cabinet instrument object which contains the aspirator used to aspirate sample from the container.",
      Category -> "General"
    },

    TipObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Item,Tips],Model[Item,Tips],Object[Item, Consumable],Model[Item, Consumable]],
      Description -> "The tip object that will be attached to the aspirator.",
      Category -> "General"
    },

    TransferSubprotocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "The protocol object corresponding to the addition of sample to the tared SampleContainer.",
      Category -> "General"
    },

    TareContainerProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "The MeasureWeight protocol for taring the container prior to aspiration.",
      Category -> "General"
    },

    MeasureWeightProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "The MeasureWeight protocol for weighing the container after aspiration.",
      Category -> "General"
    },

    ImageSampleProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "The ImageSample protocol for the sample after aspiration.",
      Category -> "General"
    }
  }
}]