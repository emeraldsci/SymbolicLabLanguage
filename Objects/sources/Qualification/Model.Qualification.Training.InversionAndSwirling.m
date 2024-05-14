(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,InversionAndSwirling], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to mix by inversion and swirling.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    InversionSwirlingUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A series of UnitOperations that asks the operator to prepare a sample in flask by inversion and a sample in tube by swirling operations while in post processing the samples out gets imaged once they have gone through the mixing operations such that they can be verified as the part of the qualification to ensure they are completely mixed.",
      Category -> "Sample Preparation"
    }
  }
}];