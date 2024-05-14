(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Shahrier *)
(* :Date: 2023-06-02 *)

DefineObjectType[Object[Qualification,Training,MissingItem], {
  Description -> "A protocol that verifies an operator's ability to locate objects based on their location history.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    MissingItem -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Types[Object[Item]],
      Description -> "The missing item that the user is asked to find.",
      Category -> "General"
    }
  }
}]