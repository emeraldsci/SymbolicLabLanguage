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
    },
    TestLabware -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container]|Model[Part]|Object[Part]|Model[Item]|Object[Item],
      Description -> "Additional items the operator is asked to pick and store.",
      Category -> "General"
    },
    StickyRackUsed -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if all items were scanned into a blue bin during resource picking as instructed.",
      Category -> "General",
      Developer -> True
    },
    LabwareDestination -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The location where the operator is asked to move the labware in order to demonstrate the use of racks.",
      Category -> "General"
    },
    StickyRack -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container, Rack]|Object[Container, Rack],
      Description -> "The rack operators pick in order to then place all other resources inside, demonstrating Engine's ability to move a group of items inside a rack with just one scan.",
      Category -> "General"
    }
  }
}]