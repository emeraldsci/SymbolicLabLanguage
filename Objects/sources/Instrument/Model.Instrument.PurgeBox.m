(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, PurgeBox], {
  Description->"The model of a sealed container that is designed to manipulate samples under a separate atmosphere.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    InternalDimensions -> {
      Format -> Single,
      Class -> {Real,Real,Real},
      Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
      Units -> {Meter,Meter,Meter},
      Description -> "The size of the space inside the purge box.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
    }
  }
}];