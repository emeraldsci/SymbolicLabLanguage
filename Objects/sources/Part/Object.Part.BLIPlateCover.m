(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, BLIPlateCover], {
  Description->"A plate cover used to prevent evaporation from the assay plate during a Bio-Layer Interferometry experiment.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    Columns -> {
      Format -> Computable,
      Expression:> SafeEvaluate[{Field[Model]},Download[Field[Model],Columns]],
      Pattern :> GreaterP[0, 1],
      Description -> "The number of columns of well covers.",
      Category -> "Part Specifications"
    },
    Rows -> {
      Format -> Computable,
      Expression:> SafeEvaluate[{Field[Model]},Download[Field[Model],Rows]],
      Pattern :> GreaterP[0, 1],
      Description -> "The number of rows of well covers.",
      Category -> "Part Specifications"
    },
    Reusable -> {
      Format -> Computable,
      Expression:> SafeEvaluate[{Field[Model]},Download[Field[Model],Reusable]],
      Pattern :> BooleanP,
      Description -> "Indicates if the plate cover can be washed and reused.",
      Category -> "Part Specifications"
    },
    InternalDimensions -> {
      Format -> Computable,
      Expression:> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Description -> "The internal dimensions of this model of plate cover.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    },
    ExternalDimensions -> {
      Format -> Computable,
      Expression:> SafeEvaluate[{Field[Model]},Download[Field[Model],ExternalDimensions]],
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Description -> "The external dimensions of this model of plate cover.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    }
  }
}];