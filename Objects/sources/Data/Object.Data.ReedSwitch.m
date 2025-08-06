(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, ReedSwitch], {
  Description -> "Data indicating whether an enclosure has any doors open or if all doors are closed as a function of time.",
  CreatePrivileges -> None,
  Cache -> Session,

  Fields -> {

    FirstDataPoint -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The time of the first data point written in this object.",
      Category -> "General",
      Abstract -> True
    },
    LastDataPoint -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The time of the last data point written in this object.",
      Category -> "General",
      Abstract -> True
    },
    DailyLog -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this data object is a daily log. If it is, the object will be parsed to create new data objects when RecordSensor is called.",
      Category -> "General"
    },
    ReedSwitchLog -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> {{_?DateObjectQ,_?StringQ}..},
      Units -> {None, None},
      Description -> "Indicate the status of the doors as a function of time.",
      Category -> "Sensor Information",
      Abstract -> True
    },
    RawData -> {
      Format -> Multiple,
      Class -> {Link, Compressed},
      Pattern :> {_Link, {{_?DateObjectQ, _?NumericQ}..}},
      Relation -> {Object[Calibration,Sensor], Null},
      Units -> {None, None},
      Description -> "Indicates the calibration objects and the PLC readings as a function of time.",
      Headers -> {"Calibration", "Time-Series Data"},
      Category -> "Data Processing"
    }

  }
}];
