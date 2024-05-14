(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: Shahrier *)
(* :Date: 2023-06-02 *)

DefineObjectType[Object[Qualification,Training,Storage], {
  Description -> "A qualification model to a test user's ability to complete a storage sample.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    StorageObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Container],Object[Container]],
      Description -> "The objects that are to be stored in order to test the user's knowledge of proper storage techniques.",
      Category -> "Storage Skills"
    },
    StorageAnswers -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "The user input storage condition answers in the procedure.",
      Category -> "Storage Skills"
    },
    StorageConditionAnswers -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleStorageTypeP,
      Description -> "The operator's responses when asked the storage condition of each of the StorageObjects.",
      Category -> "Storage Skills"
    },
    StorageModuleFinalStorage -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Rack],
      Description -> "The location where the StorageObjects will be stored at the end of the Qualification.",
      Category -> "General"
    }
  }
}]