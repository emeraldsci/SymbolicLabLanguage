(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sensor, Irradiance], {
  Description->"Device for measuring irradiance.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxIrradiance -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxIrradiance]],
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Description -> "The maximum irradiance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinIrradiance -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinIrradiance]],
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Description -> "The minimum irradiance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
      Pattern :> GreaterP[0*Watt/Meter^2],
      Description -> "The smallest change in irradiance that corresponds to a change in displayed value. This quantity is also known as readability, increment, scale division.",
      Category -> "Sensor Information"
    },
    ManufacturerUncertainty -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
      Pattern :> GreaterP[0*Percent],
      Description -> "The variation in accuracy of measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
      Category -> "Sensor Information"
    }
  }
}];