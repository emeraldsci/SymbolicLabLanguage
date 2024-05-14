(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Shahrier *)
(* :Date: 2023-05-30 *)

DefineObjectType[Model[Qualification, Training, Storage], {
  Description -> "A qualification model to a test user's ability to store a sample.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
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
    },
    StorageModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The model of object(s) that the user will be asked to store to test their knowledge of proper storage techniques.",
      Category -> "Storage Skills"
    },
    StorageModels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The models that the user will be asked to store to test their knowledge of proper storage techniques.",
      Category -> "Storage Skills"
    },
    StorageConditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleStorageTypeP,
      Relation -> Null,
      Description -> "For each member of StorageModels, the storage condition assigned in order to test the operator's use of the Object Identifier.",
      Category -> "Storage Skills",
      IndexMatching -> StorageModels
    },
    StorageModuleFinalStorage -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container,Rack]|Object[Container,Rack],
      Description -> "The location where the StorageObjects will be stored at the end of the Qualification.",
      Category -> "General"
    }
  }
}]