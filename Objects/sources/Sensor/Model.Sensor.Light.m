(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Light], {
  Description->"Model of a device for measuring Light.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxLux -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "Maximum light that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinLux -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[Lux],
      Units -> Lux,
      Description -> "Minimum light that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Lux],
      Units -> Lux,
      Description -> "This is the smallest change in light that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
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
