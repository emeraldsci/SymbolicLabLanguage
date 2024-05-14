(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: martin.lopez *)
(* :Date: 2023-02-08 *)

DefineObjectType[Model[Qualification,Training,SlurryTransfer], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to transfer a viscous liquid.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    SlurryTransferPreparatoryUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "The list of sample preparation unit operations performed to test the user's ability to perform a slurry transfer.",
      Category -> "General"
    }
  }
}]