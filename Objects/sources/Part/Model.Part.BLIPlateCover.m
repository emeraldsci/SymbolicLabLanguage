(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, BLIPlateCover], {
  Description -> "A model of a plate cover used to prevent evaporation from the assay plate during a Bio-Layer Interferometry experiment.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Columns -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> GreaterP[0, 1],
      Description -> "The number of columns of well covers.",
      Category -> "Part Specifications"
    },
    Rows -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> GreaterP[0, 1],
      Description -> "The number of rows of well covers.",
      Category -> "Part Specifications"
    },
    Reusable -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if the plate cover can be washed and reused.",
      Category -> "Part Specifications"
    },
    InternalDimensions -> {
      Format -> Single,
      Class -> {Real, Real, Real},
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Units ->{Meter,Meter,Meter},
      Description -> "The internal dimensions of this model of plate cover.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    },
    ExternalDimensions -> {
      Format -> Single,
      Class -> {Real, Real, Real},
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Units ->{Meter,Meter,Meter},
      Description -> "The external dimensions of this model of plate cover.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    }
  }
}];