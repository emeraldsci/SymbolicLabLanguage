(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Illuminance], {
  Description->"Illuminance measured as a function of time by a sensor.",
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
    IlluminanceLog -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{None, Lux}],
      Units -> {None, Lux},
      Description -> "A record of illuminance values taken over the course of an experiment or a single data point.",
      Category -> "Data Processing",
      Abstract -> True
    },
    RawData -> {
      Format-> Multiple,
      Class-> {Link,Compressed},
      Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
      Relation -> {Object[Calibration, Sensor],Null},
      Units -> {None, None},
      Description -> "Maintenance objects and associated raw illuminance values (twincat) versus time for each datapoint in the data object.",
      Headers -> {"Calibration","Time-Series Data"},
      Category -> "Data Processing"
    },
    IlluminanceStandardDeviation -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "The calculated standard deviation for this illuminance data.",
      Category -> "Data Processing",
      Abstract -> True
    },
    IlluminanceDistribution -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> DistributionP[Lux],
      Description -> "The empirical distribution based on this illuminance data.",
      Category -> "Data Processing"
    },
    Illuminance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Lux],
      Units -> Lux,
      Description -> "The mean illuminance detected over the course of an experiment or a single data point.",
      Category -> "Data Processing",
      Abstract -> True
    }
  }
}];