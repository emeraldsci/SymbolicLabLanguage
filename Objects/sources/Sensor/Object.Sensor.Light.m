(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Sensor, Light], {
  Description->"Device for measuring Light.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    MaxLux -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLux]],
      Pattern :> GreaterEqualP[0*Lux],
      Description -> "Maximum light that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    MinLux -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLux]],
      Pattern :> UnitsP[Lux],
      Description -> "Minimum light that can be reliably read by this model of sensor.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    Resolution -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
      Pattern :> GreaterP[0*Lux],
      Description -> "This is the smallest change in light that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
      Category -> "Sensor Information"
    },
    ManufacturerUncertainty -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerUncertainty]],
      Pattern :> GreaterP[0*Percent],
      Description -> "This is the variation in measurements taken under the same conditions as reported by the manufacturer, stored as a +/- percentage of the reading.",
      Category -> "Sensor Information"
    }
  }
}];