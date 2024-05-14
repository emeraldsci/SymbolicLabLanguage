(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: billy *)
(* :Date: 2023-02-16 *)

DefineObjectType[Object[Qualification,Training,OperatorCart], {
  Description -> "A protocol that verifies an operator's ability to use the features of an operator cart.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    TestContainer->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The training object the user is asked to move to different locations on the cart.",
      Category -> "General"
    },
    Positions->{
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The cart locations that the user is asked to move the sample object into.",
      Category -> "General"
    },
    MovementPositions->{
      Format -> Multiple,
      Class -> {Link,Expression},
      Pattern :> {_Link,{LocationPositionP..}},
      Relation -> {Object[Container],Null},
      Description -> "A list of cart locations that the user is asked to move the sample object into.",
      Headers -> {"Object to Place","Placement Tree"},
      Category -> "General" (* Or just General *)
    },
    BatteryRack->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The battery rack the user is asked to find and scan.",
      Category -> "General"
    },
    SecondaryCart->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]|Model[Container],
      Description -> "The secondary utility cart the user is asked to find and scan.",
      Category -> "General"
    }
  }
}]