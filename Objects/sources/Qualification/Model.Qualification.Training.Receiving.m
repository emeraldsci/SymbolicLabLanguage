(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: adam.abushaer *)
(* :Date: 2023-02-14 *)

DefineObjectType[Model[Qualification,Training,Receiving], {
  Description -> "A qualification model to test user's ability to receive an item that has arrived at ECL.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ReceivingItems -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item,Tips],Model[Item,Consumable],Model[Item,Cap],Model[Item,Spatula],Model[Item,Filter],Model[Item,Tweezer],Model[Item,WeighBoat],Model[Container,Vessel]],
      Description -> "The model of the item that an operator receives.",
      Category -> "General"
    }
  }
}]