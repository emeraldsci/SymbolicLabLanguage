(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, Replace, pHProbe], {
  Description->"A protocol that replaces a pH Probe on the target pH meter.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    pHMeter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Instrument,pHMeter],
      Description -> "The instrument to which the target pH probe is connected.",
      Category -> "General"
    }
  }
}];