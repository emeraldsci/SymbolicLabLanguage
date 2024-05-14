(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Rocker], {
  Description->"Device for agitating liquids via rocking (often while being incubated at set temperatures as well).",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    TemperatureControl -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureControl]],
      Pattern :> Water | Air | None,
      Description -> "Type of temperature controller whether by forced air or using a contact solution.",
      Category -> "Instrument Specifications"
    },
    MinRotationRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRotationRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Minimum speed the instrument can perform a full cycle of rocking at.",
      Category -> "Operating Limits"
    },
    MaxRotationRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Maximum speed the instrument can perform a full cycle of rocking at.",
      Category -> "Operating Limits"
    },
    MinTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
      Pattern :> GreaterP[0*Kelvin],
      Description -> "Minimum temperature at which the roller can incubate.",
      Category -> "Operating Limits"
    },
    MaxTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
      Pattern :> GreaterP[0*Kelvin],
      Description -> "Maximum temperature at which the roller can incubate.",
      Category -> "Operating Limits"
    },
    InternalDimensions -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
      Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
      Description -> "The size of space inside the roller in the X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
      Category -> "Dimensions & Positions"
    }
  }
}];
