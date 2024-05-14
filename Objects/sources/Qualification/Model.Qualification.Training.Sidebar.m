(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,Sidebar], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to collect information from the Engine sidebar.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    SidebarInstrumentModel->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument],
      Description -> "The instrument model for the object for which the user collects information via the engine sidebar.",
      Category -> "General"
    }
  }
}]