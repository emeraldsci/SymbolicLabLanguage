(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,KVMSwitch], {
  Description -> "A protocol that verifies an operator's ability to use all models of KVM switches in the lab.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    KVM4PortImage -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The image files taken of the 4 port KVM display monitor.",
      Category -> "General"
    },

    KVM8PortImage -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The image files taken of the 8 port KVM display monitor.",
      Category -> "General"
    },

    Training8PortKVMSwitch -> {
      Format->Single,
      Class-> Link,
      Pattern :> _Link,
      Relation -> Model[Part,KVMSwitch]|Object[Part,KVMSwitch],
      Description -> "The 8 port KVM Switch that will be selected during the KVM user qualification.",
      Category -> "General"
    },

    Training4PortKVMSwitch -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Part,KVMSwitch]|Object[Part,KVMSwitch],
      Description -> "The 4 port KVM Switch that will be selected during the KVM user qualification.",
      Category -> "General"
    }

  }
}];