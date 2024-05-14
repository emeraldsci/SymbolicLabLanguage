(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Shahrier *)
(* :Date: 2023-06-02 *)

DefineObjectType[Object[Qualification,Training,FumeHoodTransfer], {
  Description -> "A protocol that verifies an operator's ability to complete a transfer inside a fume hood.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    FumeHoodTransferSamplePreparationProtocol ->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,ManualSamplePreparation],
      Description->"The Manual Sample Preparation sub protocol that tests the user's fumehood skills.",
      Category->"FumeHood Transfer Skills"
    },
    FumeHoodTransferPreparatoryUnitOperations -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> SamplePreparationP,
    Description -> "The list of sample preparation unit operations performed to test the user's ability in using the Fumehood.",
    Category -> "FumeHood Transfer Skills"
  }}
}]