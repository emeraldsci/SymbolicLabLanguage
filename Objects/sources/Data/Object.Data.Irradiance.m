(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Irradiance], {
  Description->"Irradiance measured as a function of time by a sensor.",
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
    IrradianceLog -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{None,Watt/Meter^2}],
      Units -> {None, Watt/Meter^2},
      Description -> "A record of irradiance values taken over the course of an experiment or a single data point.",
      Category -> "Data Processing",
      Abstract -> True
    },
    RawData -> {
      Format-> Multiple,
      Class-> {Link,Compressed},
      Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
      Relation -> {Object[Calibration, Sensor],Null},
      Units -> {None, None},
      Description -> "Maintenance objects and associated raw irradiance values (twincat) vs time for each datapoint in the data object.",
      Headers -> {"Calibration","Time-Series Data"},
      Category -> "Data Processing"
    },
    IrradianceStandardDeviation -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Units -> Watt/Meter^2,
      Description -> "The calculated standard deviation for this irradiance data.",
      Category -> "Data Processing",
      Abstract -> True
    },
    IrradianceDistribution -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> DistributionP[Watt/Meter^2],
      Description -> "The empirical distribution based on this irradiance data.",
      Category -> "Data Processing"
    },
    Irradiance -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Watt/Meter^2],
      Units -> Watt/Meter^2,
      Description -> "The mean irradiance detected over the course of an experiment or a single data point.",
      Category -> "Data Processing",
      Abstract -> True
    }
  }
}];