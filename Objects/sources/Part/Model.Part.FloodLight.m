(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,FloodLight],{
  Description->"Model information for battery driven safety lights which automatically come on if primary power source goes out.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    FloodLightSize -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FloodLightSizeP,
      Description -> "The size of the mask and the degree to which it covers your face.",
      Category -> "Part Specifications"
    },
    Wattage -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Watt],
      Units -> Watt,
      Description -> "Total wattage output of the flood light.",
      Category -> "Part Specifications"
    },
    BatteryLifetime-> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Hour],
      Units -> Hour,
      Description -> "The amount of time the battery will last before having to be replaced.",
      Category -> "Part Specifications"
    }
  }
}];