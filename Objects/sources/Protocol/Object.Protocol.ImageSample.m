

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, ImageSample],{
	Description->"A protocol to image samples in a container.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Method Information ---  *)
		PlateImagerInstruments->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Alternatives[
				Object[Instrument, PlateImager],
				Model[Instrument, PlateImager]
			],
			Description->"The plate imager instruments used to image samples specified in this protocol.",
			Category -> "General"
		},
		SampleImagerInstruments->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Alternatives[
				Object[Instrument, SampleImager],
				Model[Instrument, SampleImager]
			],
			Description->"The sample imager instruments used to image samples specified in this protocol.",
			Category -> "General"
		},
		ImageContainers -> {
			Format->Multiple,
			Class->Boolean,
			Pattern :> BooleanP,
			IndexMatching -> ContainersIn,
			Description->"For each member of ContainersIn, indicates whether images will be taken of the container or the samples contained within.",
			Category -> "General"
		},
		ImagingDirections -> {
			Format->Multiple,
			Class->Expression,
			Pattern :> {ImagingDirectionP..},
			Description->"For each member of SamplesIn, the direction(s) from which each sample is imaged.",
			Category -> "General"
		},
		IlluminationDirections->{
			Format->Multiple,
			Class->Expression,
			Pattern :> {IlluminationDirectionP..},
			Description->"For each member of SamplesIn, the direction(s) from which the sample is illuminated.",
			Category -> "General"
		},
		
		(* --- Batching --- *)
		BatchedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Units -> None,
			Description -> "The list of containers that will be imaged, sorted by container groupings that will be measured simultaneously as part of the same 'batch'.",
			Category -> "Batching",
			Developer -> True
		},
		TubeRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Model[Container,Rack] | Object[Container,Rack], Null},
			IndexMatching -> BatchedContainers,
			Description -> "For each member of BatchedContainers, placement instructions specifying the locations in the tube rack where the target containers are placed.",
			Category -> "Batching",
			Headers -> {"Object to Place","Destination Object","Destination Position"},
			Developer->True
		},
		(* For placement of plates / racks / vessels into imaging apparatus; will have one entry per batch *)
		(* Would have been in BatchedImagingParameters, but requires nested links *)
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "For each member of BatchLengths, a list of placements used to place the container to be imaged in the appropriate deck position of the imaging apparatus.",
			IndexMatching -> BatchLengths,
			Category -> "Batching",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		(* Use this one batching field for both plate and sample imager *)
		BatchedImagingParameters -> {
			Format -> Multiple,
			Class -> {
				(* For both plate and sample imager *)
				Imager -> Link,
				ImagingDirection -> Expression,
				IlluminationDirection -> Expression,
				SecondaryRack -> Link,
				ImageFilePrefix -> String,
				BatchNumber -> Integer,
				(* Plate imager specific *)
				Wells -> Expression,
				PlateMethodFileName -> String,
				RunTime -> Real,
				FieldOfView -> Integer,
				(* Sample imager specific *)
				ImagingDistance -> Real,
				Pedestals -> Expression,
				ExposureTime -> Real,
				FocalLength -> Integer
			},
			Pattern :> {
				(* For both plate and sample imager *)
				Imager -> _Link,
				ImagingDirection -> {ImagingDirectionP..},
				IlluminationDirection -> {IlluminationDirectionP..},
				SecondaryRack -> _Link,
				ImageFilePrefix -> _String,
				BatchNumber -> _Integer,
				(* Plate imager specific *)
				Wells -> {WellPositionP..},
				PlateMethodFileName -> _String,
				RunTime -> TimeP,
				FieldOfView -> DistanceP,
				(* Sample imager specific *)
				ImagingDistance -> DistanceP,
				Pedestals -> ImagingPedestalP,
				ExposureTime -> TimeP,
				FocalLength -> DistanceP
			},
			Relation -> {
				(* For both plate and sample imager *)
				Imager -> Alternatives[
					Model[Instrument, PlateImager],
					Object[Instrument, PlateImager],
					Model[Instrument, SampleImager],
					Object[Instrument, SampleImager]
				],
				ImagingDirection -> Null,
				IlluminationDirection -> Null,
				SecondaryRack -> Alternatives[
					Model[Container,Rack],
					Object[Container,Rack]
				],
				ImageFilePrefix -> Null,
				BatchNumber -> _Integer,
				(* Plate imager specific *)
				Wells -> Null,
				PlateMethodFileName -> Null,
				RunTime -> Null,
				FieldOfView -> Null,
				(* Sample imager specific *)
				ImagingDistance -> Null,
				Pedestals -> Null,
				ExposureTime -> Null,
				FocalLength -> Null
			},
			Units -> {
				(* For both plate and sample imager *)
				Imager -> None,
				ImagingDirection -> None,
				IlluminationDirection -> None,
				SecondaryRack -> None,
				ImageFilePrefix -> None,
				BatchNumber -> None,
				(* Plate imager specific *)
				Wells -> None,
				PlateMethodFileName -> None,
				RunTime -> Minute,
				FieldOfView -> Millimeter,
				(* Sample imager specific *)
				ImagingDistance -> Centimeter,
				Pedestals -> None,
				ExposureTime -> Millisecond,
				FocalLength -> Millimeter
			},
			Headers -> {
				(* For both plate and sample imager *)
				Imager -> "Imager",
				ImagingDirection -> "Imaging Direction",
				IlluminationDirection -> "Illumination Direction",
				SecondaryRack -> "Secondary Rack",
				ImageFilePrefix -> "PlateImager Data File Prefix",
				BatchNumber -> "Batch Number",
				(* Plate imager specific *)
				Wells -> "Wells to Image",
				PlateMethodFileName -> "PlateImager Method File Name",
				RunTime -> "Run Time",
				FieldOfView -> "Horizontal Field of View",
				(* Sample imager specific *)
				ImagingDistance -> "Distance from Camera",
				Pedestals -> "Pedestals",
				ExposureTime -> "Exposure Time",
				FocalLength -> "Focal Length"
			},
			IndexMatching -> BatchLengths,
			Description -> "For each member of BatchLengths, the imaging parameters shared by all containers in the batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedImagingParametersNew -> {
			Format -> Multiple,
			Class -> {
				(* For both plate and sample imager *)
				Imager -> Link,
				ImageContainer -> Boolean,
				ImagingDirection -> Expression,
				IlluminationDirection -> Expression,
				SecondaryRack -> Link,
				ImageFilePrefix -> String,
				BatchNumber -> Integer,
				(* Plate imager specific *)
				Wells -> Expression,
				PlateMethodFileName -> String,
				RunTime -> Real,
				FieldOfView -> Integer,
				(* Sample imager specific *)
				ImagingDistance -> Real,
				Pedestals -> Expression,
				ExposureTime -> Real,
				FocalLength -> Integer
			},
			Pattern :> {
				(* For both plate and sample imager *)
				Imager -> _Link,
				ImageContainer -> BooleanP,
				ImagingDirection -> {ImagingDirectionP..},
				IlluminationDirection -> {IlluminationDirectionP..},
				SecondaryRack -> _Link,
				ImageFilePrefix -> _String,
				BatchNumber -> _Integer,
				(* Plate imager specific *)
				Wells -> {WellPositionP..},
				PlateMethodFileName -> _String,
				RunTime -> TimeP,
				FieldOfView -> DistanceP,
				(* Sample imager specific *)
				ImagingDistance -> DistanceP,
				Pedestals -> ImagingPedestalP,
				ExposureTime -> TimeP,
				FocalLength -> DistanceP
			},
			Relation -> {
				(* For both plate and sample imager *)
				Imager -> Alternatives[
					Model[Instrument, PlateImager],
					Object[Instrument, PlateImager],
					Model[Instrument, SampleImager],
					Object[Instrument, SampleImager]
				],
				ImageContainer -> Null,
				ImagingDirection -> Null,
				IlluminationDirection -> Null,
				SecondaryRack -> Alternatives[
					Model[Container,Rack],
					Object[Container,Rack]
				],
				ImageFilePrefix -> Null,
				BatchNumber -> _Integer,
				(* Plate imager specific *)
				Wells -> Null,
				PlateMethodFileName -> Null,
				RunTime -> Null,
				FieldOfView -> Null,
				(* Sample imager specific *)
				ImagingDistance -> Null,
				Pedestals -> Null,
				ExposureTime -> Null,
				FocalLength -> Null
			},
			Units -> {
				(* For both plate and sample imager *)
				Imager -> None,
				ImageContainer -> None,
				ImagingDirection -> None,
				IlluminationDirection -> None,
				SecondaryRack -> None,
				ImageFilePrefix -> None,
				BatchNumber -> None,
				(* Plate imager specific *)
				Wells -> None,
				PlateMethodFileName -> None,
				RunTime -> Minute,
				FieldOfView -> Millimeter,
				(* Sample imager specific *)
				ImagingDistance -> Centimeter,
				Pedestals -> None,
				ExposureTime -> Millisecond,
				FocalLength -> Millimeter
			},
			Headers -> {
				(* For both plate and sample imager *)
				Imager -> "Imager",
				ImageContainer -> "Image Container",
				ImagingDirection -> "Imaging Direction",
				IlluminationDirection -> "Illumination Direction",
				SecondaryRack -> "Secondary Rack",
				ImageFilePrefix -> "PlateImager Data File Prefix",
				BatchNumber -> "Batch Number",
				(* Plate imager specific *)
				Wells -> "Wells to Image",
				PlateMethodFileName -> "PlateImager Method File Name",
				RunTime -> "Run Time",
				FieldOfView -> "Horizontal Field of View",
				(* Sample imager specific *)
				ImagingDistance -> "Distance from Camera",
				Pedestals -> "Pedestals",
				ExposureTime -> "Exposure Time",
				FocalLength -> "Focal Length"
			},
			IndexMatching -> BatchLengths,
			Description -> "For each member of BatchLengths, the imaging parameters shared by all containers in the batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of containers per batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedContainerIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Batching",
			Developer -> True
		},
		
		
		(* --- DEPRECATED --- *)
		(* Became PlateImagerInstruments, SampleImagerInstruments *)
		Imager->{
			Format->Single,
			Class->Link,
			Pattern :> _Link,
			Relation->Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description->"The instrument used to image samples specified in this protocol.",
			Category -> "General"
		},
		(* Replaced by new field called IlluminationDirections *)
		Illumination->{
			Format->Single,
			Class->Expression,
			Pattern :> IlluminationDirectionP,
			Description->"The direction from which the sample is illuminated.",
			Category -> "General"
		},
		(* Subsumed by BatchedImagingParameters *)
		ImagingDistances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Inch,
			Description -> "For each member of ContainersIn, the distance from the camera lens to the front-to-back midpoint of the object being imaged.",
			IndexMatching -> ContainersIn,
			Category -> "General"
		},
		(* Subsumed by BatchedImagingParameters *)
		Pedestals -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ImagingPedestalP,
			Description -> "For each member of ContainersIn, a symbol indicating which pedestals are used to raise the container to appropriate imaging height.",
			Category -> "General",
			Developer->True
		},
		(* Subsumed by BatchedImagingParameters *)
		RunTime->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The estimated time it should take the automated camera to image the samples in that container.",
			Category -> "General",
			Developer->True
		},
		(* Subsumed by BatchedImagingParameters *)
		(* Seems like we need to keep this for plate imaging. May make sense to make it specific to plate imaging. *)
		FieldsOfView->{
			Format->Multiple,
			Class->Expression,
			Pattern :> CameraFieldOfViewP,
			Description->"For each member of ContainersIn, the horizonal length of the image of the container taken in this protocol.",
			Category -> "General",
			IndexMatching->ContainersIn
		},
		(* Partially replaced by TubeRackPlacements *)
		ContainerPlacements->{
			Format->Multiple,
			Class->{Link,Link,String},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation->{Object[Container],Object[Container],Null},
			Description->"Deck placement instructions for plates being imaged.",
			Category -> "General",
			Headers->{"Object to Place","Destination Object","Destination Position"}
		},
		(* Subsumed by BatchedImagingParameters *)
		SecondaryContainer->{
			Format->Single,
			Class->Link,
			Pattern :> _Link,
			Relation->Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"Model of a secondary container that is used to hold the samples during imaging.",
			Category -> "General"
		},
		(* Will be subsumed by BatchedImagingParameters *)
		ExposureTime->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Second],
			Units->Millisecond,
			Description->"The length of time for which a camera shutter stays open.",
			Category -> "General"
		},
		(* Subsumed by BatchedImagingParameters *)
		ImageFilePrefixes->{
			Format->Multiple,
			Class->String,
			Pattern :> _String,
			Description->"The file prefix used to name all of the output images for that container's samples.",
			Category -> "General",
			Developer->True
		},
		(* Subsumed by BatchedImagingParameters *)
		ImagerFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern :> FilePathP,
			Description->"The filepath that corresponds to the file that will run this protocol.",
			Category -> "General",
			Developer->True
		},
		(* Since this is now weirdly batch-indexed, removing and having it link only to the Object[Data, Appearance] objects *)
		RulerImageData->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Object[Data][Protocol],
			Description->"Appearance data of the ruler used to determine the scale of all other appearance data produced by this protocol.",
			Category->"Experimental Results"
		},
		(* Related to cameranet, and we're cutting direct CameraNet imaging out of ImageSample *)
		Cameras->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Alternatives[
				Object[Part,Camera],
				Model[Part,Camera]
			],
			Description->"The cameras used to capture an image of the vessels.",
			Category -> "General"
		},
		ImageFiles->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The file folders of the image files generated from experiment run.",
			Category->"General",
			Developer -> True
		}
	}
}];
