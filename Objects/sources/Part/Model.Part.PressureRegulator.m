(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, PressureRegulator], {
  Description->"Model information for a pressure regulator used for controlling pressure output.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* ----- Operating Limits ----- *)

    MinPressure->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[-20 PSI],
      Units->PSI,
      Description->"Minimum pressure this regulator can output.",
      Category->"Operating Limits",
      Abstract->True
    },

    MaxPressure->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 PSI],
      Units->PSI,
      Description->"Maximum pressure this regulator can output.",
      Category->"Operating Limits",
      Abstract->True
    }
  }
}];