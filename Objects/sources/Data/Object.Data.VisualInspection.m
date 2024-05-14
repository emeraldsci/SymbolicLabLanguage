DefineObjectType[Object[Data, VisualInspection], {
   Description->"Data from video recording of a sample as it was agitated at constant temperature, obtained by running a visual inspection experiment.",
   CreatePrivileges->None,
   Cache->Session,
   Fields->{
      Camera->{
         Format->Single,
         Class->Link,
         Pattern:>LinkP,
         Relation->Object[Part,Camera],
         Description->"The digital camera located inside the sample inspector that was used to capture this video.",
         Category->"General"
      },
      VideoDuration->{
         Format->Single,
         Class->Real,
         Pattern:>GreaterP[0*Second],
         Units->Minute,
         Description->"The length of time for which the camera records a video of the sample as it is agitated and then allowed to settle to visualize any particulates.",
         Category->"Method Information",
         Abstract->False
      },
      InspectionCondition->{
         Format->Single,
         Class->Expression,
         Pattern:>Alternatives[Ambient, Chilled],
         Description->"The desired temperature for the interior of the inspector at which the sample is agitated and the video recorded, set prior to placing the sample inside the inspector.",
         Category->"Method Information",
         Abstract->False
      },
      ColorCorrection->{
         Format->Single,
         Class->Boolean,
         Pattern:>BooleanP,
         Description->"Indicates if the color correction card is placed visible within the video frame for downstream video processing, in which the colors of the video frames are adjusted to match the reference color values on the color correction card.",
         Category->"Method Information",
         Abstract->False
      },
      TemperatureEquilibrationTime->{
         Format->Single,
         Class->Real,
         Pattern:>GreaterP[0*Second],
         Units->Minute,
         Description->"The duration of wait time between setting the temperature of the inspector interior to the NominalTemperature and placing the sample inside the inspector.",
         Category->"Method Information",
         Abstract->False
      },
      SampleMixingRate->{
         Format->Single,
         Class->Real,
         Pattern:>GreaterP[0*RPM],
         Units->RPM,
         Description->"The frequency at which the sample is rotated around the offset central axis to agitate the sample for visualizing any particulates.",
         Category->"Method Information",
         Abstract->False
      },
      LightIntensity->{ (* link to Object containing the Light Intensity trace *)
         Format->Single,
         Class->QuantityArray,
         Pattern:>QuantityArrayP[{{Second,Lux}..}],
         Units->{Second, Lux},
         Description->"Brightness of the inspector interior as measured by the light sensor located directly adjacent to the shaker as a function of time.",
         Category->"Experimental Results",
         Abstract->True
      },
      Temperature ->{  (*(pointing to an Object that contains the Temperature trace data, RecordSensor), part of Experimental Result *)
         Format->Single,
         Class->Real,
         Pattern:>GreaterP[0*Kelvin],
         Pattern:>GreaterP[0 Kelvin],
         Units-> Celsius,
         Description->"Temperature inside the sample inspector chamber as a function of time.",
         Category->"Experimental Results",
         Abstract->True
      },
      InspectionVideo->{
         Format->Single,
         Class->Link,
         Pattern:>_Link,
         Relation->Object[EmeraldCloudFile],
         Description->"File containing the color-processed full length video of the sample being agitated and then allowed to settle.",
         Category->"Experimental Results",
         Abstract->True
      }
   }
}];