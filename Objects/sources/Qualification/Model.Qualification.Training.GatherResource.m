(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ian *)
(* :Date: 2023-02-16 *)

DefineObjectType[Model[Qualification,Training,GatherResource], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to pick and store a resource.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    StickyRack -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container, Rack],
      Description -> "The type of rack operators pick in order to then place all other resources inside, demonstrating Engine's ability to move a group of items inside a rack with just one scan.",
      Category -> "General"
    }
  }
}]