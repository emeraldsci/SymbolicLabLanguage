(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,RoundBottomFlaskHandling], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to use glassware with a spherical bottom.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    RoundBottomFlask -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The container type to be connected to an instrument via glass joints and keck clamps.",
      Category -> "General"
    },
    RoundBottomFlaskMatingInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument],
      Description -> "The instrument to be connected to by a type of spherical glassware via glass joints and keck clamps.",
      Category -> "General"
    }
  }
}]