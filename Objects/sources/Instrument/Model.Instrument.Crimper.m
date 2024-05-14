

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Crimper], {
  Description->"A model for an instrument that secures crimped caps to containers.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    MinPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> PressureP,
      Units -> PSI,
      Description -> "Indicates the minium pressure rating for the cap.",
      Category -> "Operating Limits"
    },
    MaxPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "Indicates the maximum pressure rating for the cap.",
      Category -> "Physical Properties"
    }
  }
}];
