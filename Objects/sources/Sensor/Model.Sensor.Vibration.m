(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor, Vibration], {
  Description->"Model of a device for measuring vibration.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    VibrationSensorType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> VibrationSensorTypeP,
      Description -> "The aspect of vibration being measured by this sensor - acceleration or velocity.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MaxVibration -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> GreaterEqualP[0*Millimeter/Second]|GreaterEqualP[0* Meter/Second^2],
      Description -> "Maximum vibration that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinVibration -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> UnitsP[Millimeter/Second]|UnitsP[0* Meter/Second^2],
      Description -> "Minimum vibration that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> GreaterP[0*Millimeter/Second]|GreaterEqualP[0* Meter/Second^2],
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
