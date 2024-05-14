(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,Condenser], {
  Description -> "A protocol that verifies an operator's ability to perform a SnapText task.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    CondenserFilePath->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The file path for the batch file operators are asked to run to demonstrate their ability to use Condenser.",
      Category -> "General"
    },
    CondenserInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument],
        Object[Instrument]
      ],
      Description -> "The instrument whose PC should be used to run a script through condenser.",
      Category -> "General",
      Abstract -> True
    }
  }
}];