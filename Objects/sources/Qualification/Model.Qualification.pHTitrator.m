(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-07-30 *)

DefineObjectType[Model[Qualification, pHTitrator], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a pHTitrator.",
  CreatePrivileges -> None,
  Cache->Session,
  Fields -> {
    pHMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "The frequency of rotation the mixing instrument should use to mix the water sample in qualification.",
      Category -> "Mixing"
    },
    pHMixImpeller -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
      Description -> "The impeller used in the mixer responsible for stirring the water sample in between acid/base additions.",
      Category -> "Mixing",
      Developer -> True
    },
    TitrationContainerCap->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item, Cap],
        Object[Item, Cap]
      ],
      Description -> "The cap that is used to assemble pH probe, overhead stir rod and tube of pHTitrator during qualification using the water sample.",
      Category->"General"
    },
    AcidVolume -> {
      Format->Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Milliliter],
      Units -> Milliliter,
      Developer->True,
      Description->"The volume of acid to be added into qualification water sample in pHTitrator qualification.",
      Category->"General"
    },
    BaseVolume -> {
      Format->Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Milliliter],
      Units -> Milliliter,
      Developer->True,
      Description->"The volume of base to be added into qualification water sample in pHTitrator qualification.",
      Category->"General"
    },
    WaterVolume -> {
      Format->Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Milliliter],
      Units -> Milliliter,
      Developer->True,
      Description->"The volume of water sample used in pHTitrator qualification.",
      Category->"General"
    },
    BufferVolume -> {
      Format->Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Milliliter],
      Units -> Milliliter,
      Developer->True,
      Description->"The volume of buffer samples used in pHTitrator qualification.",
      Category->"General"
    },
    pHTolerance ->{
      Format->Single,
      Class -> Real,
      Pattern :> GreaterP[0.01],
      Units -> None,
      Developer->True,
      Description->"The maximum deviation from the pH target in pHTitrator qualification with water sample.",
      Category->"General"
    },
    NominalpHs->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> RangeP[0, 14],
      Units -> None,
      Developer->True,
      Description -> "The pH values specified as the desired target in the qualification with buffer sample.",
      Category -> "General"
    }
  }
}];