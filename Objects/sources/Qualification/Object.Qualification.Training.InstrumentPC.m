(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,InstrumentPC], {
  Description -> "A protocol that verifies an operator's ability to use an instrument PC.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    InstrumentPCAnswer->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"String uploaded by operator per training qualification's text entry task.",
      Category->"General"
    },
    ImageFile -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "A cropped image file containing a snap shot of the InstrumentPC VNC view.",
      Category -> "General"
    }
  }
}];