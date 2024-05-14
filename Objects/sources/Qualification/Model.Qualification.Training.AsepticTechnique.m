(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,AsepticTechnique], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to perform aseptic technique.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument, BiosafetyCabinet],
        Model[Instrument, BiosafetyCabinet]
      ],
      Description -> "The BiosafetyCabinet Instrument that is selected for the training qualification of AsepticTechique.",
      Category -> "General"
    },
    SerologicalPipettePipetusTransferContainers -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description -> "The containers that buffer will be pipetted into with the pipetus serological pipette.",
      Category -> "General"
    },
    SerologicalPipettePipetusInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument, Pipette],
        Model[Instrument, Pipette]
      ],
      Description -> "The pipetus serological pipette instrument used for transfer inside the BSC.",
      Category -> "Pipetting Skills"
    },
    SerologicalPipettePipetusTips -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item],
        Object[Item]
      ],
      Description -> "The model of the pipette tips used for this pipette in this qualification with the pipetus serological pipette.",
      Category -> "General"
    },
    SerologicalPipettePipetusBufferVolumes -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 * Milliliter],
      Units -> Milliliter,
      Description -> "The amount of sample that will be transferred into the container.",
      Category -> "General"
    }
  }
}];