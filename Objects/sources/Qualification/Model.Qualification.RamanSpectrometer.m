(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, RamanSpectrometer], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a Raman spectrometer.",
  CreatePrivileges -> None,
  Cache->Session,
  Fields -> {
    SamplingPatternsTested -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SinglePoint,Spiral, FilledSpiral, FilledSquare,Rings,Grid,Coordinates],
      Description -> "The sampling patterns that are tested in by the qualification.",
      Category -> "General"
    }
  }
}];
