

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, CrimpingHead], {
  Description->"A model for a part that attaches to an Object[Instrument, Crimper] that is used to attached crimped caps to vials.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    CoverFootprint -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CoverFootprintP,
      Description -> "The footprint of the crimped covers that the crimping head is compatible with.",
      Category -> "Physical Properties"
    },
    CrimpType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CrimpTypeP,
      Description -> "The type of crimped covers that the crimping head is compatible with.",
      Category -> "Physical Properties"
    }
  }
}];
