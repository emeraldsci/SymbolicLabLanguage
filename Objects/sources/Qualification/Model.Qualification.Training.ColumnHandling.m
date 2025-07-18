(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,ColumnHandling], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to install an LC column.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Column -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item],
      Description -> "The device that an operator installs in a column compartment for training.",
      Category -> "General"
    }
  }
}]