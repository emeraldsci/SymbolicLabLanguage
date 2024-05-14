(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Light], {
  Description->"Light measured detected as a function of date and time by a light sensor.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    FirstDataPoint -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The date of the first data point in this object.",
      Category -> "General",
      Abstract -> True
    },
    LastDataPoint -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The date of the last data point in this object.",
      Category -> "General",
      Abstract -> True
    },
    DailyLog -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the sensor using a function called RecordSensor.",
      Category -> "General"
    },
    LuxLog -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{None, Lux}],
      Units -> {None, Lux},
      Description -> "Light as they appear vs date/time during the course of an experiment or single data point.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    RawData -> {
      Format-> Multiple,
      Class-> {Link,Compressed},
      Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
      Relation -> {Object[Calibration, Sensor],Null},
      Units -> {None, None},
      Description -> "Maintenance objects and associated raw light count vs date/time data for each datapoint in the data object.",
      Headers -> {"Calibration","Time-Series Data"},
      Category -> "Data Processing"
    },
    LuxStandardDeviation -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "The calculated standard deviation for this data.",
      Category -> "Data Processing",
      Abstract -> True
    },
    LuxDistribution -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> DistributionP[Lux],
      Description -> "The empirical distribution based on this data.",
      Category -> "Data Processing"
    },
    Light -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "Total light detected over the course of an experiment or single data point.",
      Category -> "Data Processing",
      Abstract -> True
    }
  }
}];