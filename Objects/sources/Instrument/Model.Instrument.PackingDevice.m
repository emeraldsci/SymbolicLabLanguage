(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PackingDevice], {
  Description->"Model of an instrument for packing finely-ground powders inside a melting point capillary tube before measuring melting point by a melting point apparatus",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    NumberOfCapillaries -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the device has for simultaneous packing of melting point capillaries.",
      Category -> "Instrument Specifications"
    }
  }
}];