(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Illuminance], {
  Description->"Model of a device for measuring illuminance.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxIlluminance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "The maximum illuminance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinIlluminance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "The minimum illuminance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Lux],
      Units -> Lux,
      Description -> "The smallest change in illuminance that corresponds to a change in displayed value. This quantity is also known as readability, increment, scale division.",
      Category -> "Sensor Information"
    },
    ManufacturerUncertainty -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Percent],
      Units -> Percent,
      Description -> "The variation in accuracy of measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
      Category -> "Sensor Information"
    }
  }
}];
