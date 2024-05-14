(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ian *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,GatherResource], {
  Description -> "A protocol that verifies an operator's ability to pick and store a resource.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    TestContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the user is asked to resource pick and store.",
      Category -> "General"
    }
  }
}]