(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,Alarm],{
  Description->"Model information for a part that is used to alert people nearby to situations that require attention through sound and visual cues.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    Detection -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> AlarmTypeP,
      Description ->"The type of source that triggers the alarm such as fire or oxygen.",
      Category -> "Part Specifications"
    },
    AlarmWarningMethod -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> AlarmWarningMethodP,
      Description ->"The type of indication that occurs when an alarm is triggered.",
      Category -> "Part Specifications"
    },
    MinimumDetectionThreshold -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Percent],
      Units -> Percent,
      Description -> "The percentage detected of the trigger gas before the alarm is triggered.",
      Category -> "Part Specifications"
    },
    MaximumDetectionThreshold -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Percent],
      Units -> Percent,
      Description -> "The percentage detected of the trigger gas before the alarm is triggered.",
      Category -> "Part Specifications"
    },
    SensorArray -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the alarm is connected to ECL's Sensor Array network.",
      Category -> "Part Specifications"
    }
  }
}];