(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, VisualInspection], {
	Description -> "A protocol for obtaining a live video recording of a sample as it is agitated at the specified temperature.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern:>_Link,
			Relation -> Alternatives[
				Model[Instrument, SampleInspector],
				Object[Instrument, SampleInspector]
			],
			Description -> "For each member of SamplesIn, the instrument used to perform the inspection operation.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		InspectionConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:>Alternatives[Ambient, Chilled],
			Description -> "For each member of SamplesIn, the temperature condition of the chamber in which the sample is agitated & the videos is recorded during the course of the experiment.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		TemperatureEquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Units -> Minute,
			Pattern:>GreaterP[0 Minute],
			Description -> "For each member of SamplesIn, the duration of wait time between placing the sample inside the instrument and starting to shake the sample.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		BackgroundColors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Black, White],
			Description -> "For each member of SamplesIn, the color of the panel placed on the inside of the inspector door serving as a backdrop for the video recording as the sample is being agitated.",
			Category -> "Imaging",
			IndexMatching -> SamplesIn
		},
		IlluminationDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> ListableP[SampleInspectorIlluminationDirectionP],
			Description -> "For each member of SamplesIn, the directions of illumination that will be used for inspection, where All implies all available light sources will be active simultaneously.",
			Category -> "Imaging",
			IndexMatching -> SamplesIn
		},
		ColorCorrections -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of SamplesIn, indicates if the color correction card is placed visible within the video frame for downstream processing, in which the colors of the video frames are adjusted to match the reference color values on the color correction card.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		Backdrops -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Backdrop],
				Object[Part, Backdrop]
			],
			Description -> "For each member of SamplesIn, the magnetic panel that provides a monochromatic background for the sample container being agitated and recorded in the Sample Inspector instrument.",
			Category -> "Imaging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SampleContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "For each member of SamplesIn, the list of placements used to move the sample container onto the shaker on the Visual Inspector.",
			Category -> "Placements",
			Headers -> {"Sample Container to Place", "Sample Container Destination", "Placement Position"},
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		BackdropPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part], Object[Instrument], Null},
			Description -> "For each member of SamplesIn, a list of placements used to move the sample inspector backdrop onto the door of sample inspector instrument.",
			Category -> "Placements",
			IndexMatching -> SamplesIn,
			Headers -> {"Backdrop to Place", "Backdrop Destination", "Placement Position"},
			Developer -> True
		},
		SampleMixingRates -> {
			Format -> Multiple,
			Class -> Real,
			Units -> RPM,
			Pattern :> GreaterP[0 RPM],
			Description -> "For each member of SamplesIn, the frequency at which the sample is rotated around the offset central axis of its Sample Inspector instrument shaker to agitate the sample for visualizing any particulates.",
			Category -> "Mixing",
			IndexMatching -> SamplesIn
		},
		VortexSampleMixingRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:>GreaterEqualP[0],
			Description -> "For each member of SamplesIn, the value corresponding to the frequency at which the sample is rotated around the offset central axis of the Sample Inspector Vortex to agitate the sample for visualizing any particulates.",
			Category -> "Mixing",
			IndexMatching -> SamplesIn
		},
		OrbitalShakerSampleMixingRates -> {
			Format -> Multiple,
			Class -> Real,
			Units -> RPM,
			Pattern:>GreaterP[0 RPM],
			Description -> "For each member of SamplesIn, the frequency at which the sample is rotated around the offset central axis of the Sample Inspector Orbital Shaker to agitate the sample for visualizing any particulates.",
			Category -> "Mixing",
			IndexMatching -> SamplesIn
		},
		SampleMixingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:>GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration of time for which the sample container is rotated around the offset central axis of the sample inspector agitator to suspend the container's contents prior to the video capture of its settling.",
			Category -> "Imaging",
			IndexMatching -> SamplesIn
		},
		SampleSettlingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:>GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration of time for which the camera continues recording a video of the sample container once sample mixing is paused.",
			Category -> "Imaging",
			IndexMatching -> SamplesIn
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "For each member of SamplesIn, the data packet containing the measured temperature of the interior of the Sample Inspector instrument in which the sample was agitated and recorded.",
			Category -> "Sample Handling",
			IndexMatching -> SamplesIn
		},
		DataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the directory for storing the recorded video files acquired in the course of the experiment.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		InspectionVideos -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of SamplesIn, a video recording of the sample obtained as it was rotated around the offset central axis to agitate the contents for visualizing any particulates.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results"
		},
		SampleIndices -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of SamplesIn, a numerical marker to help keep track of the original SamplesIn and their positions in the batched unit operations.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Developer -> True
		}
	}
}];