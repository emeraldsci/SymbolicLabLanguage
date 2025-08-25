(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-04-03 *)


DefineObjectType[Model[Instrument, pHTitrator], {
  Description->"The model for an automatic titrator that adjusts pH of samples.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SyringeVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Liter],
      Units -> Liter Milli,
      Description -> "The volume of the Syringe of this model of pHTitrator.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    MinDispenseVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Liter],
      Units -> Liter Milli,
      Description -> "The minimum volume this model of pHTitrator can dispense titrate into samples each time.",
      Category -> "Operating Limits",
      Abstract -> True
    }
  }
}];
