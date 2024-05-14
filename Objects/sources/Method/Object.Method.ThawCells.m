(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, ThawCells],{
  Description->"A set of method parameters used to thaw a frozen cell culture.",
  CreatePrivileges->None,
  Cache->Session,
  Fields-> {
    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument, CellThaw],
        Model[Instrument, HeatBlock]
      ],
      Description -> "The instrument used to thaw the cells.",
      Category-> "General"
    },
    Temperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Celsius],
      Units -> Celsius,
      Description -> "The temperature used to thaw the cells. This option can only be set when using a heat block (the temperature is automatically adjusted based on phase change when using an automatic cell thawer).",
      Category-> "General"
    }
  }
}];