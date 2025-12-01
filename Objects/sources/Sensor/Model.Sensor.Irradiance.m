(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Irradiance], {
  Description->"Model of a device for measuring irradiance.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxIrradiance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Units -> Watt/Meter^2,
      Description -> "The maximum irradiance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinIrradiance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Units -> Watt/Meter^2,
      Description -> "The minimum irradiance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Watt/Meter^2],
      Units -> Watt/Meter^2,
      Description -> "The smallest change in irradiance that corresponds to a change in displayed value. This quantity is also known as readability, increment, scale division.",
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
