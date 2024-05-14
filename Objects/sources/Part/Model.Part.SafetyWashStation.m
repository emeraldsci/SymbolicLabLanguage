(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,SafetyWashStation],{
  Description->"Model information for an emergency station that is used to wash hazardous contaminants from the body.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    EyeWashStation -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the safety wash station includes an eye wash station.",
      Category -> "Part Specifications"
    },
    EmergencyShower -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the safety wash station includes an emergency shower.",
      Category -> "Part Specifications"
    },
    ModestyScreen -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the safety wash station includes a modesty screen.",
      Category -> "Part Specifications"
    },
    Dunnage -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the safety wash station includes a dunnage bin.",
      Category -> "Part Specifications"
    },
    DunnageVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Liter],
      Units -> Liter,
      Description -> "The total amount of water that the dunnage can be filled with.",
      Category -> "Part Specifications"
    }
  }
}];