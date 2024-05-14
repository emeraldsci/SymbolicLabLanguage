(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Vibration], {
  Description->"Model of a device for measuring vibration.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxVibration -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Millimeter/Second],
      Units -> Millimeter/Second,
      Description -> "Maximum vibration that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinVibration -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[Millimeter/Second],
      Units -> Millimeter/Second,
      Description -> "Minimum vibration that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Millimeter/Second],
      Units -> Millimeter/Second,
      Description -> "This is the smallest change in vibration that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
      Category -> "Sensor Information"
    },
    ManufacturerUncertainty -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Percent],
      Units -> Percent,
      Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
      Category -> "Sensor Information"
    }
  }
}];
