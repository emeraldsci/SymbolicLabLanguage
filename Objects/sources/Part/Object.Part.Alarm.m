(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Alarm], {
  Description->"Model information for a part that is used to alert people nearby to situations that require attention through sound and visual cues.",
  CreatePrivileges->None,
  Cache->Download, (* TODO: make all part objects Cache -> Download *)
  Fields -> {} (* TODO: check with billy on type of sensor attached in sensornet, the fields we need for it*)
}];