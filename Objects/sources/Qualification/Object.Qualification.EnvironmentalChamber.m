(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,EnvironmentalChamber], {
  Description->"A protocol that verifies the functionality of the EnvironmentalChamber target.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    MeanTarget->{
      Format->Single,
      Class->Expression,
      Pattern:>{GreaterEqualP[0 Celsius]|Null,GreaterEqualP[0 Percent]|Null},
      Description->"The target temperature and relative humidity of the target EnvironmentalChamber.",
      Category->"General"
    },
    TimePeriod->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Day],
      Units->Day,
      Description->"The time period over which to qualify the EnvironmentalChamber.",
      Category->"General"
    },
    SamplingRate->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0 Hour],
      Units->Hour,
      Description->"The rate at which to downsample the EnvironmentalChamber data before analysis.",
      Category->"General"
    },
    TemperatureData->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{None,Celsius}],
      Units->{None,Celsius},
      Description->"The downsampled temperature data assessed by this qualification.",
      Category->"Experimental Results"
    },
    RelativeHumidityData->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{None,Percent}],
      Units->{None,Percent},
      Description->"The downsampled relative humidity data assessed by this qualification.",
      Category->"Experimental Results"
    },
    MaintenanceTimePeriods->{
      Format->Multiple,
      Class->{Link,Date,Date},
      Pattern:>{_Link,_?DateObjectQ,_?DateObjectQ},
      Relation->{Object[Maintenance]|Object[Qualification]|Object[Protocol],Null,Null},
      Description->"The start datetime and end datetime for any time periods within the qual assessment period that the target is actively running a maintenance, protocol, or qualification.",
      Category->"Experimental Results",
      Headers->{"Maintenance","Start Date","End Date"}
    }
  }
}];
