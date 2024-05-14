(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,RoundBottomFlaskHandling], {
  Description -> "A protocol that verifies an operator's ability to use glassware with a spherical bottom.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    RoundBottomFlask -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container] | Object[Container],
      Description -> "The container type to be connected to an instrument via glass joints and keck clamps.",
      Category -> "General"
    },
    RoundBottomFlaskMatingInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "The instrument to be connected to by a type of spherical glassware via glass joints and keck clamps.",
      Category -> "General"
    },
    InstalledFlaskImage -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The appearance data of the round bottom flask after it has been installed to an instrument.",
      Category -> "General"
    }
  }
}]