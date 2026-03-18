(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sensor, Illuminance], {
  Description->"Device for measuring illuminance.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxIlluminance -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxIlluminance]],
      Pattern :> GreaterEqualP[0*Lux],
      Description -> "The maximum illuminance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinIlluminance -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinIlluminance]],
      Pattern :> GreaterEqualP[0*Lux],
      Description -> "The minimum illuminance that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
      Pattern :> GreaterP[0*Lux],
      Description -> "The smallest change in illuminance that corresponds to a change in displayed value. This quantity is also known as readability, increment, scale division.",
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