(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,KVMSwitch], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to use all models of KVM switches in the lab.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

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