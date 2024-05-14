(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-11-18 *)

DefineObjectType[Model[Part,StickerPrinter], {
  Description->"Model information for a part used to print Constellation stickers that point to SLL objects.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    Firmware -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The firmware installed that this specific to this printer model.",
      Category -> "Part Specifications"
    },

    MaxStickerWidth -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Inch],
      Units -> Inch,
      Relation -> Model[Item,Consumable],
      Description -> "The types of stickers this device is capable of printing on.",
      Category -> "Part Specifications"
    },

    MaxStickerDepth -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Inch],
      Units -> Inch,
      Relation -> Model[Item,Consumable],
      Description -> "The types of resin ribbon this device is capable of printing on.",
      Category -> "Part Specifications"
    }
  }
}];