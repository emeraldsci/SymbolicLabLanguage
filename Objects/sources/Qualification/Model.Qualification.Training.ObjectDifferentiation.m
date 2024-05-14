(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Model[Qualification,Training,ObjectDifferentiation], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to differentiate between different types of objects.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ContainerModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The model of container the user is asked to scan in order to test their ability to identify a container.",
      Category -> "General"
    },
    RackModel->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The model of rack the user is asked to scan in order to test their ability to identify a rack.",
      Category -> "General"
    }

  }
}]