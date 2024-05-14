(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: adam.abushaer *)
(* :Date: 2023-05-22 *)

DefineObjectType[Object[Qualification,Training,SampleTemperatureHandling], {
  Description -> "A protocol that verifies an operator's ability to pick, transport, and store samples with different storage conditions.",
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
    TestShelf -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container, Shelf],
      Description -> "The shelf that the test container is placed upon by the user.",
      Category -> "General"
    },
    PortableCooler->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Instrument],Object[Instrument]],
      Description->"The portable instrument for keeping samples chilled.",
      Category->"General"
    }
  }
}]