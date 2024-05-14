(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,ReversePipetting], {
  Description -> "A protocol that verifies an operator's ability to implement reverse pipetting technique.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ReversePipettingSamplePreparationProtocol ->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,ManualSamplePreparation],
      Description->"The protocol that tests the user's reverse pipetting skills.",
      Category->"General"
    },
    SampleImagingProtocol -> {
      Format-> Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Object[Protocol,ImageSample],
      Description-> "The ImageSample subprotocol that asks the operator to image the sample containers that went through reverse pipetting.",
      Category-> "General"
    },
    VolumeMeasurementProtocol -> {
      Format-> Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Object[Protocol,MeasureVolume],
      Description-> "The MeasureVolume subprotocol that asks the operator to measure the volume of the samples that went through reverse pipetting.",
      Category-> "General"
    },
    MeasurementContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
      Description -> "The Containers to be used for reverse pipetting practical to transfer samples into.",
      Category -> "General"
    },
    TareWeights -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data, Weight],
      Description -> "Weight data measured on empty container.",
      Category -> "General"
    },
    WeightMeasurementProtocols -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, MeasureWeight],
      Description -> "The MeasureWeight subprotocol before and after sample transfer in this reverse pipetting practical.",
      Category -> "General"
    },
    ReversePipettingPreparatoryUnitOperations -> {
      Format-> Multiple,
      Class-> Expression,
      Pattern:> SamplePreparationP,
      Description-> "The list of sample preparation unit operations performed to test the user's ability to perform a reverse pipetting transfer.",
      Category-> "General"
    }
  }
}];