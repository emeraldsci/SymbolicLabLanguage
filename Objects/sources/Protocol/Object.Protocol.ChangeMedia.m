(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, ChangeMedia],{
  Description->"A protocol object that contains the information to change the media for cell samples.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    RequiredObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
      Description -> "Objects required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    RequiredInstruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "Instruments required for the protocol.",
      Category -> "General",
      Developer -> True
    }
  }
}];