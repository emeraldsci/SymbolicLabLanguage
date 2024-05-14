(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-11-18 *)

DefineObjectType[Object[Part,StickerPrinter], {
  Description->"A part used to print Constellation stickers that point to SLL objects.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {

    StickerModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item,Consumable],
      Description -> "The model of blank sticker roll that is currently installed in this printer.",
      Category -> "Part Specifications"
    },

    StickerObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Item,Consumable],
      Description -> "The blank sticker roll that is currently installed in this printer.",
      Category -> "Part Specifications"
    },

   RibbonModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item,Consumable],
      Description -> "The model of thermal transfer roll that is currently installed in this printer.",
      Category -> "Part Specifications"
    },

    RibbonObject -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Item,Consumable],
      Description -> "The thermal transfer roll that is currently installed in this printer.",
      Category -> "Part Specifications"
    },

    IP -> {
      Format -> Single,
      Class -> String,
      Pattern :> IpP,
      Description -> "The numerical identifier of this printer when connected to a network.",
      Category -> "Part Specifications"
    },

    Computer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Part,Computer][StickerPrinters],
      Description -> "Links to the computer object that is connected to this sticker printer.",
      Category -> "Part Specifications"
    }

  }
}];