(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,AsepticTechnique], {
  Description -> "A protocol that verifies an operator's ability to use a handheld aspirator.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    WaterSample -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "Water sample used for transfer inside the BSC.",
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
    }
  }
}];