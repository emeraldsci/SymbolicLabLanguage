(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, ThawCells],{
  Description->"A detailed set of parameters that specifies the thawing of frozen cells vials.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    SampleLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample],
        Model[Sample],
        Model[Container],
        Object[Container]
      ],
      Description -> "The sample that is thawed during this unit operation.",
      Category -> "General",
      Migration->SplitField
    },
    SampleString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The sample that is thawed during this unit operation.",
      Category -> "General",
      Migration->SplitField
    },
    SampleExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
      Relation -> Null,
      Description -> "The sample that is thawed during this unit operation.",
      Category -> "General",
      Migration->SplitField
    },
    SampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
      Category -> "General",
      IndexMatching -> SampleLink
    },
    SampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the label of the sample container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
      Category -> "General",
      IndexMatching -> SampleLink
    },
    ContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container of the sample that will be thawed.",
      Category -> "General",
      Migration->SplitField
    },
    ContainerString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The container of the sample that will be thawed.",
      Category -> "General",
      Migration->SplitField
    },
    Instrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument, CellThaw],
        Object[Instrument, CellThaw],

        Model[Instrument, HeatBlock],
        Object[Instrument, HeatBlock]
      ],
      Description -> "For each member of SampleLink, the instrument used to gently heat the cryovial until the sample inside is thawed.",
      Category->"Thawing",
      IndexMatching -> SampleLink
    },
    Time -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "For each member of SampleLink, the minimum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
      Category->"Thawing",
      IndexMatching -> SampleLink
    },
    MaxTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "For each member of SampleLink, the maximum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
      Category->"Thawing",
      IndexMatching -> SampleLink
    },
    Temperature -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature that the frozen cells are thawed at.",
      Category->"Thawing",
      IndexMatching -> SampleLink
    },
    Method -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Method, ThawCells],
      Description -> "For each member of SampleLink, the default method parameters to use when thawing these cells.",
      Category->"Thawing",
      IndexMatching -> SampleLink
    }
  }
}];