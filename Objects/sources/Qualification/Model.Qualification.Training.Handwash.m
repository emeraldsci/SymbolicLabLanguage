(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Model[Qualification,Training,Handwash], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to handwash labware.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    IndicatorSampleModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The sample, usually red food dye, that will stain the labware so that we can wash and verify that the operator successfully cleaned the labware.",
      Category -> "General"
    },
    DirtyLabwareModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The model of training specific labware that the user will be asked to handwash.",
      Category -> "General"
    },
    WaterPurifierModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument],
      Description -> "Source of purified water used to rinse the labware.",
      Category -> "General",
      Abstract -> True
    },
    FumeHoodModels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument],
      Description -> "Fume hood that is used during cleaning of labware.",
      Category -> "General"
    },
    BlowGunModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument],
      Description -> "Instrument used to blow dry the interior of the washed containers by spraying them with a stream of nitrogen gas.",
      Category -> "General"
    },
    ThermoplasticWrapModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample]|Model[Item],
      Description -> "A malleable thermoplastic wrap that is used to temporarily seal containers while cleaning.",
      Category -> "General"
    }
  }
}]