(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,ObjectDifferentiation], {
  Description -> "A protocol that verifies an operator's ability to differentiate between different types of objects.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ContainerObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The container object the user is asked to scan in order to test their ability to identify a container.",
      Category -> "General"
    },
    RackObject->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The rack object the user is asked to scan in order to test their ability to identify a rack.",
      Category -> "General"
    },
    ScannedContainer->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The id the user scans when asked to identify the container.",
      Category -> "General"
    },
    ScannedRack->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The id the user scans when asked to identify the container.",
      Category -> "General"
    },
    ScannedCap->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The id the user scans when asked to identify the container.",
      Category -> "General"
    }
  }
}]