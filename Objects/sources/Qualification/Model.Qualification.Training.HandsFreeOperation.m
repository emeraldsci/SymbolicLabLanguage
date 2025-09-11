(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,HandsFreeOperation], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to work in HandsFreeOperation mode with foot pedals.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument, BiosafetyCabinet],
        Model[Instrument, HandlingStation, BiosafetyCabinet]
      ],
      Description -> "The model of the biosafety cabinet where the hands free operation occurs.",
      Category -> "General"
    },
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container],
      Description -> "The container model used to practice scanning and moving in HandsFreeOperation.",
      Category -> "General"
    }
  }
}];