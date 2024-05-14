(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: martin.lopez *)
(* :Date: 2023-02-08 *)

DefineObjectType[Object[Qualification,Training,SlurryTransfer], {
  Description -> "A protocol that verifies an operator's ability to transfer a viscous liquid.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    SlurryTransferSamplePreparationProtocol ->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,ManualSamplePreparation],
      Description->"The protocol that tests the user's slurry transfer skills.",
      Category->"General"
    },
    SampleImagingProtocol -> {
      Format-> Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Object[Protocol,ImageSample],
      Description-> "The ImageSample subprotocol that asks the operator to image the sample containers that went through slurry transfer.",
      Category-> "General"
    }
  }
}]