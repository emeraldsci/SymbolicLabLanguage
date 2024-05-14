

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, DecrimpingHead], {
  Description->"A model for a part that attaches to an Object[Instrument, Crimper] that is used to removing crimped caps from vials.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    CoverFootprint -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CoverFootprintP,
      Description -> "The footprint of the crimped covers that the crimping head is compatible with.",
      Category -> "Physical Properties"
    }
  }
}];
