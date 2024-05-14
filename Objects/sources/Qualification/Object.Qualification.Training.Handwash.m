(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,Handwash], {
  Description -> "A protocol that verifies an operator's ability to handwash labware.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    IndicatorSample -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample]|Object[Sample],
      Description -> "The sample, usually red food dye, that will stain the labware so that we can wash and verify that the operator successfully cleaned the labware.",
      Category -> "General"
    },
    DirtyLabware -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The training specific labware that the user will be asked to handwash.",
      Category -> "General"
    },
    WaterPurifier -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "Source of purified water used to rinse the labware.",
      Category -> "Cleaning"
    },
    BlowGun -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "The instrument used to blow dry the interior of the washed containers by spraying them with a stream of nitrogen gas.",
      Category -> "Cleaning"
    },
    FumeHood -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "Fume hood used during cleaning of labware.",
      Category -> "Cleaning"
    },
    ThermoplasticWrap -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item],
        Model[Item]
      ],
      Description -> "A malleable thermoplastic wrap that is used to temporarily seal containers while cleaning.",
      Category -> "Cleaning"
    },
    PrimaryCleaningSolvent -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The primary solvent with which to wash the dirty labware.",
      Category -> "Cleaning"
    },
    LabwareImageSampleSubprotocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ImageSample],
      Description -> "The imaging protocol in which the user will image the cleaned labware to ensure that the labware has been sufficiently cleaned.",
      Category -> "General"
    }
  }
}]
