(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,Troubleshooting], {
  Description -> "A protocol that verifies an operator's ability to file support tickets.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    TestContainer->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The \"broken\" training object for which the user is asked to file a ticket.",
      Category -> "General"
    },
    ErrorEncountered -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates whether the protocol compiler error has already been encountered by the user.",
      Category -> "General"
    }
  }
}]