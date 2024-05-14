(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, ThawCells],{
  Description->"A protocol object that contains the information to thaw cell samples.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    Instruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "The instruments used to gently heat the frozen cell sample until it is thawed.",
      Category->"General"
    },
    Temperatures -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Description -> "The temperature that the frozen cells are thawed at.",
      Category->"General"
    },
    Times -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Description -> "The minimum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
      Category->"General"
    },
    MaxTimes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Description -> "The maximum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
      Category->"General"
    },
    AdditionalTimes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Description -> "The duration of time that the frozen samples are placed in the instrument until the sample is fully thawed, if the minimum time did not thaw the sample.",
      Category->"General",
      Developer->True
    },

    HeatBlock -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "The heat block instrument used to thaw the cells (if one is required for this protocol).",
      Category->"General",
      Developer -> True
    },
    InitialTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Description -> "The initial temperature that the HeatBlock should be set to when setting up the instrument.",
      Category->"General",
      Developer -> True
    },

    ActualTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Description -> "The actual temperature of the heat block.",
      Category->"General",
      Developer -> True
    },

    CellThaw -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "The cell thawing instrument used to thaw the cells (if one is required for this protocol).",
      Category->"General",
      Developer -> True
    }
  }
}];