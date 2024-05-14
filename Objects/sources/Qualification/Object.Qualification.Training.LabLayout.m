(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,LabLayout], {
  Description -> "A protocol that verifies an operator's ability to navigate the lab using Zone, Row, and Slot designations.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ObjectsToFind -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container],
      Description -> "The list of objects the user is asked to find based on just its zone row and slot designation.",
      Category -> "General"
    },
    ObjectsFound->{
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The list of objects the user found and scanned given just its zone row and slot designation.",
      Category -> "General"
    }
  }
}]