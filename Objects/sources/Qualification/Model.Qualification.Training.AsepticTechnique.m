(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,AsepticTechnique], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to perform aseptic technique.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument, BiosafetyCabinet]
      ],
      Description -> "The model of the biosafety cabinet instrument that is used for the training qualification of AsepticTechnique.",
      Category -> "General"
    },
    Indicator -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample]
      ],
      Description -> "Fluorescent indicator that is spread to the biosafety cabinet surface, container, etc. and is not detected at the end of the training if there is proper decontamination.",
      Category -> "General"
    },
    CulturePlates-> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample]
      ],
      Description -> "The model of the culture plates tht will be placed in the biosafety cabinet surface throughout the HandsFreeOperation process, and incubated afterwards to check the aseptic technique performance.",
      Category -> "General"
    },
    TransferSample -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample]
      ],
      Description -> "The model of the sample to transfer to the Container in the biosafety cabinet.",
      Category -> "General"
    },
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The container model to transfer the sample to in the biosafety cabinet.",
      Category -> "General"
    },
    Pipette -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument, Pipette],
        Model[Instrument, Pipette]
      ],
      Description -> "The model of the pipette instrument used for transfer inside the BSC.",
      Category -> "General"
    },
    Tips-> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item],
        Object[Item]
      ],
      Description -> "The model of the pipette tips used in this qualification with the Pipette.",
      Category -> "General"
    },
    Amount -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> VolumeP,
      Description -> "The amount of the TransferSample to transfer to the Container.",
      Category -> "General",
      Abstract -> True
    }
  }
}];