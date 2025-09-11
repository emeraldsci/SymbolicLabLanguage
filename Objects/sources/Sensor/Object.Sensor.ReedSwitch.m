(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Sensor, ReedSwitch], {
  Description->"A device to monitor if an enclosure has any doors open or if all doors are closed",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    NumberOfSwitches -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "The number of reed switches wired in series to a single sensing channel.",
      Category -> "Sensor Information"
    }
  }
}];