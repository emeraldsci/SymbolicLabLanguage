(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HotPlate], {
  Description -> "The model for devices used to transfer heat to items, parts, and samples sat upon a heating surface.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    StirBarControl -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the device can rotate magnetic stir bars.",
      Category -> "Instrument Specifications"
    },
    MinTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The lowest set point temperature for the hot plate.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    MaxTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The highest set point temperature for the hot plate.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    MinStirRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "The slowest rotational speed set point for the hot plate.",
      Category -> "Operating Limits"
    },
    MaxStirRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 RPM],
      Units -> RPM,
      Description -> "The fastest rotational speed set point for the hot plate.",
      Category -> "Operating Limits"
    },
    StageDimensions -> {
      Format -> Single,
      Class -> {Real, Real},
      Pattern :> {GreaterP[0 Meter], GreaterP[0 Meter]},
      Units -> {Centimeter, Centimeter},
      Description -> "The size of the heating surface.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)", "Y Direction (Depth)"}
    },
    StageMaterial -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "The identity of the substance from which the heating surface is constructed.",
      Category -> "Instrument Specifications"
    }
  }
}];
