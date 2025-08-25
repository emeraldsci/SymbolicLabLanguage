(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Incubator], {
  Description->"A protocol that verifies the functionality of the incubator target.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SamplePreparationProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
      Description -> "The sample manipulation protocol used to generate the test samples.",
      Category -> "Sample Preparation"
    },
    FullyDissolved ->{
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if all components in the solution appear fully dissolved by visual inspection.",
      Category -> "Experimental Results"
    },
    TimePeriod->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Day],
      Units->Day,
      Description->"The time period over which to qualify the Incubator.",
      Category->"General"
    },
    SamplingRate->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0 Hour],
      Units->Hour,
      Description->"The rate at which to downsample the Incubator data before analysis.",
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
    CarbonDioxideData->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{None,Percent}],
      Units->{None,Percent},
      Description->"The downsampled carbon dioxide data assessed by this qualification.",
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
      Relation->{Object[Maintenance],Null,Null},
      Description->"The start datetime and end datetime for any time periods within the qual assessment period that the target is actively undergoing a maintenance.",
      Category->"Experimental Results",
      Headers->{"Maintenance","Start Date","End Date"}
    },
    Temperature->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Kelvin],
      Units->Celsius,
      Description->"The temperature at which to qualify the Incubator.",
      Category->"General"
    },
    RelativeHumidity->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Percent],
      Units->Percent,
      Description->"The RelativeHumidity at which to qualify the Incubator.",
      Category->"General"
    },
    CarbonDioxide->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0 Percent],
      Units->Percent,
      Description->"The CarbonDioxide level at which to qualify the Incubator.",
      Category->"General"
    }
  }
}];
