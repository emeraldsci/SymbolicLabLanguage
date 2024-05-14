(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,FireAlarmActivator],{
  Description->"Model information for a part that is used to trigger a fire alarm manually.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    AlarmActivationMethod -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> AlarmActivationMethodP,
      Description -> "Indicates the way in which the fire alarm is triggered.",
      Category -> "Part Specifications"
    }
  }
}];