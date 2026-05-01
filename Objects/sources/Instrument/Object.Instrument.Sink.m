(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Sink], {
  Description->"The water supply that dispenses tap water for laboratory applications.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    WaterGenerated -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],WaterGenerated]],
      Pattern :> ObjectReferenceP[Object[Model]],
      Description -> "The type of water that this instrument dispenses.",
      Category -> "Instrument Specifications"
    },
    WaterReservoir -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container],
      Description -> "The instrument internal container that holds the water sample.",
      Category -> "Instrument Specifications",
      Developer -> True
    },
    WaterSample -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The sample object representing the current water sample dispensed by the instrument.",
      Category -> "Instrument Specifications",
      Developer -> True
    }
  }
}];
