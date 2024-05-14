(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, HotPlate], {
  Description -> "A device used to transfer heat to items, parts, and samples sat upon a heating surface.",
  CreatePrivileges -> None,
  Cache -> Download,
  Fields -> {
    StirBarControl -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StirBarControl]],
      Pattern :> BooleanP,
      Description -> "Indicates if the device can rotate magnetic stir bars.",
      Category -> "Instrument Specifications"
    },
    MaxTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
      Pattern :> GreaterP[0 Kelvin],
      Description -> "The highest set point temperature for the hot plate.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    MinTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
      Pattern :> GreaterP[0 Kelvin],
      Description -> "The lowest set point temperature for the hot plate.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    NominalTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature the hot plate is currently set to maintain.",
      Category -> "Instrument Specifications",
      Abstract -> True
    },
    MinStirRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinStirRate]],
      Pattern :> GreaterEqualP[0 RPM],
      Description -> "The slowest rotational speed set point for the hot plate.",
      Category -> "Operating Limits"
    },
    MaxStirRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxStirRate]],
      Pattern :> GreaterP[0 RPM],
      Description -> "The fastest rotational speed set point for the hot plate.",
      Category -> "Operating Limits"
    },
    StageDimensions -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StageDimensions]],
      Pattern :> {GreaterP[0 Meter], GreaterP[0 Meter]},
      Description -> "The size of the heating surface.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)", "Y Direction (Depth)"}
    },
    StageMaterial -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StageMaterial]],
      Pattern :> MaterialP,
      Description -> "The identity of the substance from which the heating surface is constructed.",
      Category -> "Instrument Specifications"
    }
  }
}];