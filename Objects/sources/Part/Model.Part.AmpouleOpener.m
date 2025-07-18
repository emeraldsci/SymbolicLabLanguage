(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, AmpouleOpener], {
  Description -> "Model information for a tool used to crack open glass ampoules.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    MinBulbDiameter -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Millimeter],
      Units -> Millimeter,
      Description -> "Minimum bulb diameter the ampoule opener can open.",
      Category -> "Physical Properties"
    },
    MaxBulbDiameter->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Millimeter],
      Units->Millimeter,
      Description -> "Maximum bulb diameter the ampoule opener can open.",
      Category -> "Physical Properties"
    },
    MinVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Milliliter],
      Units -> Milliliter,
      Description -> "The smallest standard form-factor ampoule size the ampoule opener can open.",
      Category -> "Physical Properties"
    },
    MaxVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Milliliter],
      Units -> Milliliter,
      Description -> "The largest standard form-factor ampoule size the ampoule opener can open.",
      Category -> "Physical Properties"
    },
    Color->{
      Format->Single,
      Class->Expression,
      Pattern:>ColorP,
      Description -> "The hue of the body of the opener.",
      Category -> "Physical Properties"
    }
  }
}];
