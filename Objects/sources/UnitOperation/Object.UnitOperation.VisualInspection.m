(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,VisualInspection], {
   Description -> "A detailed set of parameters that specifies a single visual inspection step in a larger protocol.",
   CreatePrivileges -> None,
   Cache -> Session,
   Fields -> {
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
         Description -> "The samples that are being inspected.",
         Category -> "General",
         Migration -> SplitField
      },
      SampleString -> {
         Format -> Multiple,
         Class -> String,
         Pattern :> _String,
         Relation -> Null,
         Description -> "For each member of SampleLink, the samples that are being inspected.",
         Category -> "General",
         IndexMatching -> SampleLink,
         Migration -> SplitField
      },
      SampleExpression -> {
         Format -> Multiple,
         Class -> Expression,
         Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
         Relation -> Null,
         Description -> "For each member of SampleLink, the samples that are being inspected.",
         Category -> "General",
         IndexMatching -> SampleLink,
         Migration -> SplitField
      },
      SampleLabel -> {
         Format -> Multiple,
         Class -> String,
         Pattern :> _String,
         Relation -> Null,
         Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
         Category -> "General",
         IndexMatching -> SampleLink
      },
      SampleContainerLabel -> {
         Format -> Multiple,
         Class -> String,
         Pattern :> _String,
         Relation -> Null,
         Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
         Category -> "General",
         IndexMatching -> SampleLink
      },
      (* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
      WorkingSample -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Alternatives[
            Object[Sample],
            Model[Sample]
         ],
         Description -> "For each member of SampleLink, the samples to be inspected after any aliquoting, if applicable.",
         Category -> "General",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      WorkingContainer -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Alternatives[
            Object[Container],
            Model[Container]
         ],
         Description -> "For each member of SampleLink, the containers holding the samples to be inspected after any aliquoting, if applicable.",
         Category -> "General",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      Instrument -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Alternatives[
            Model[Instrument, SampleInspector],
            Object[Instrument, SampleInspector]
         ],
         Description -> "For each member of SampleLink, the sample inspector used for this visual inspection experiment step.",
         Category -> "General",
         IndexMatching -> SampleLink
      },
      InspectionCondition -> {
         Format -> Multiple,
         Class -> Expression,
         Pattern:>Alternatives[Ambient, Chilled],
         Description -> "For each member of SampleLink, the temperature condition of the chamber in which the sample is agitated & the videos is recorded during the course of the experiment.",
         Category -> "General",
         IndexMatching -> SampleLink
      },
      TemperatureEquilibrationTime -> {
         Format -> Multiple,
         Class -> Real,
         Pattern :> GreaterP[0 Second],
         Units -> Second,
         Description -> "For each member of SampleLink, the duration of wait time between between placing the sample inside the instrument and starting to shake the sample.",
         Category -> "Sample Handling",
         IndexMatching -> SampleLink
      },
      IlluminationDirection -> {
         Format -> Multiple,
         Class -> Expression,
         Pattern :> ListableP[SampleInspectorIlluminationDirectionP],
         Description -> "For each member of SampleLink, the directions of illumination that will be active during inspection, where All implies all available light sources will be active simultaneously.",
         Category -> "Imaging",
         IndexMatching -> SampleLink
      },
      LightSource -> {
         Format -> Multiple,
         Class -> Expression,
         Pattern :> ListableP[_Link],
         Relation -> Object[Part],
         Description -> "For each member of SampleLink, the sources of illumination that will be active during inspection, where All implies all available light sources will be active simultaneously.",
         Category -> "Imaging",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      BackgroundColor -> {
         Format -> Multiple,
         Class -> Expression,
         Pattern :> VisualInspectionBackgroundP,
         Description -> "For each member of SampleLink, indicates the color of the panel placed on the inside of the inspector door serving as a backdrop for the video recording as the sample is being agitated.",
         Category -> "Imaging",
         IndexMatching -> SampleLink
      },
      ColorCorrection -> {
         Format -> Multiple,
         Class -> Boolean,
         Pattern :> BooleanP,
         Description -> "For each member of SampleLink, indicates if the color correction card is placed within the video frame for downstream processing, in which the colors of the video frames are adjusted to match the reference color values on the color correction card.",
         Category -> "Data Processing",
         IndexMatching -> SampleLink
      },
      Backdrop -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Alternatives[
            Model[Part, Backdrop],
            Object[Part, Backdrop]
         ],
         Description -> "For each member of SampleLink, the magnetic panel that provides a monochromatic background for the sample container being agitated and recorded in the Sample Inspector instrument.",
         Category -> "Imaging",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      SampleMixingRate -> {
         Format -> Multiple,
         Class -> Real,
         Pattern :> GreaterP[0 RPM],
         Units -> RPM,
         Description -> "For each member of SampleLink, the value corresponding to the frequency at which the sample is rotated around the offset central axis of the Sample Inspector Vortex to agitate the sample for visualizing any particulates.",
         Category -> "Mixing",
         IndexMatching -> SampleLink
      },
      OrbitalShakerSampleMixingRate -> {
         Format -> Multiple,
         Class -> Real,
         Pattern :> GreaterP[0 RPM],
         Units -> RPM,
         Description -> "For each member of SampleLink, the frequency at which the sample is rotated around the offset central axis to agitate the sample for visualizing any particulates.",
         Category -> "Mixing",
         IndexMatching -> SampleLink
      },
      VortexSampleMixingRate -> {
         Format -> Multiple,
         Class -> Real,
         Pattern :> GreaterEqualP[0],
         Description -> "For each member of SampleLink, the value corresponding to the frequency at which the sample is rotated around the offset central axis of the Sample Inspector Vortex to agitate the sample for visualizing any particulates.",
         Category -> "Mixing",
         IndexMatching -> SampleLink
      },
      SampleMixingTime -> {
         Format -> Multiple,
         Class -> Real,
         Pattern:>GreaterP[0 Second],
         Units -> Second,
         Description -> "For each member of SampleLink, the duration of time for which the sample container is rotated around the offset central axis of the sample inspector agitator to suspend the container's contents prior to the video capture of its settling.",
         Category -> "Imaging",
         IndexMatching -> SampleLink
      },
      SampleSettlingTime -> {
         Format -> Multiple,
         Class -> Real,
         Pattern:>GreaterP[0 Second],
         Units -> Second,
         Description -> "For each member of SampleLink, the duration of time for which the camera continues recording a video of the sample container once sample mixing is paused.",
         Category -> "Imaging",
         IndexMatching -> SampleLink
      },
      SampleContainerPlacement -> {
         Format -> Multiple,
         Class -> {Link, Link, String},
         Pattern:> {_Link, _Link, LocationPositionP},
         Relation -> {Object[Container], Object[Instrument], Null},
         Description -> "For each member of SampleLink, a list of placements used to move the sample container onto the shaker in the sample inspector instrument.",
         Category -> "Placements",
         Headers -> {"Sample Container to Place", "Sample Container Destination", "Placement Position"},
         IndexMatching -> SampleLink,
         Developer -> True
      },
      BackdropPlacement -> {
         Format -> Multiple,
         Class -> {Link, Link, String},
         Pattern :> {_Link, _Link, LocationPositionP},
         Relation -> {Alternatives[Object[Part], Model[Part]], Alternatives[Object[Instrument], Model[Instrument]], Null},
         Description -> "For each member of SampleLink, a list of placements used to move the sample inspector backdrop onto the door of sample inspector instrument.",
         Category -> "Placements",
         IndexMatching -> SampleLink,
         Headers -> {"Backdrop to Place", "Backdrop Destination", "Placement Position"},
         Developer -> True
      },
      Temperature -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Object[Data, Temperature],
         Description -> "For each member of SampleLink, the data packet containing the measured temperature of the interior of the Sample Inspector instrument in which the sample was agitated and recorded.",
         Category -> "Sample Handling",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      DataFilePath -> {
         Format -> Multiple,
         Class -> String,
         Pattern :> FilePathP,
         Description -> "For each member of SampleLink, the directory for storing the recorded video files acquired in a given unit operation.",
         Category -> "General",
         IndexMatching -> SampleLink,
         Developer -> True
      },
      InspectionVideo -> {
         Format -> Multiple,
         Class -> Link,
         Pattern :> _Link,
         Relation -> Object[EmeraldCloudFile],
         Description -> "For each member of SampleLink, a video recording of the sample obtained as it was rotated around the offset central axis to agitate the contents for visualizing any particulates.",
         IndexMatching -> SampleLink,
         Category -> "Experimental Results"
      },
      SampleIndex -> {
         Format -> Multiple,
         Class -> Integer,
         Pattern :> GreaterP[0],
         Description -> "For each member of SampleLink, a numerical marker to help keep track of the original SamplesIn in the protocol object and their positions in the batched unit operations.",
         IndexMatching -> SampleLink,
         Category -> "General",
         Developer -> True
      }
   }
}];
