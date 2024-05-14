(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,ColumnHandling], {
  Description -> "A protocol that verifies an operator's ability to install an LC column.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Column -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item],
        Model[Item]
      ],
      Description -> "The device that an operator installs in a column compartment for training.",
      Category -> "General"
    },
    ColumnHandlingInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "The instrument that an operator installs the column on.",
      Category -> "General"
    },
    InstalledColumnImage -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The appearance data of the training column after it has been placed in the instrument.",
      Category -> "General"
    }
  }
}]