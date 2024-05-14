(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Capillary], {
  Description->"A model of a very narrow cylindrical tube that is used to perform experiments on small amounts of samples.",
  CreatePrivileges->None,
  Cache->Session,
  Fields-> {
    CapillaryLength -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Centimeter],
      Units -> Centimeter,
      Description -> "The distance from one end to the other end.",
      Category -> "Container Specifications"
    },
    InnerDiameter -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "The largest distance between the inner side of walls of a capillary tube.",
      Category -> "Container Specifications"
    },
    OuterDiameter -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "The largest distance between the outer side of walls of a capillary tube.",
      Category -> "Container Specifications"
    },
    CapillaryType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Open | Closed,
      Description -> "Indicates if the capillary is Open capillary is both ends or just one end.",
      Category -> "Container Specifications"
    },
    Barcode -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if this capillary should have a barcode sticker placed on it. If a capillary is not barcoded (which is often the case), it is placed in a case for carriage purposes or in instrument positions. If set to Null, indicates that the capillary is not barcoded.",
      Category -> "Physical Properties"
    }
  }

}];
