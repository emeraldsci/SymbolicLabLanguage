(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,Sidebar], {
  Description -> "A protocol that verifies an operator's ability to collect information from the Engine sidebar.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    SidebarInstrument->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Instrument]|Model[Instrument],
      Description -> "The instrument for which the user collects information via the engine sidebar.",
      Category -> "General"
    },
    InstrumentInfo->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The information the user collects via the engine sidebar about the instrument.",
      Category -> "General"
    }
  }
}]