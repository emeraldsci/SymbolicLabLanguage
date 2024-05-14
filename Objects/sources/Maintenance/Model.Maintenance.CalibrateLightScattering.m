(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, CalibrateLightScattering], {
  Description->"Definition of a set of parameters for a maintenance protocol that calibrates the scattered light intensity of a MultimodeSpectrophotometer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    CalibrationStandard -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Model[Sample],
      Description -> "The standard sample which is used to calibrate the scattered light intensity of a MultimodeSpectrophotometer.",
      Category -> "General",
      Abstract -> True
    },
    (* uni clip loading fields *)
    CapillaryLoading->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Robotic, Manual],
      Description->"The loading method for capillaries.",
      Category -> "General"
    }
  }
}];
