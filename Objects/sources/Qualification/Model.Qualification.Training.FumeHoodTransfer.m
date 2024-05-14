(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Shahrier *)
(* :Date: 2023-05-30 *)

DefineObjectType[Model[Qualification, Training, FumeHoodTransfer], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to complete a transfer inside a fume hood.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    FumeHoodTransferPreparatoryUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "The list of sample preparation unit operations performed to test the user's ability in using the Fumehood.",
      Category -> "FumeHood Transfer Skills"
    },
    UserQualificationFrequency -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> UserQualificationFrequencyP,
      Relation -> Null,
      Description -> "The intended frequency that the user qualification that this model defines should be performed.",
      Category -> "General"
    },
    Modules -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> UserQualificationModulesP,
      Relation -> Null,
      Description -> "A list of the skills that this model of qualification assesses.",
      Category -> "General"
    }
  }
}]