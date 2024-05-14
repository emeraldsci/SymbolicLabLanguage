(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ian *)
(* :Date: 2023-02-14 *)

DefineObjectType[Model[Qualification,Training,ParameterizeContainer], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to measure and parameterize a container.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ParameterizeTrainingContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The part or container that an operator will parameterize for training.",
      Category -> "General"
    }
  }
}]