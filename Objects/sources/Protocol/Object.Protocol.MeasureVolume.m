(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureVolume], {
	Description->"A protocol for quantifying sample volumes using ultrasonic distance or weight measurements.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,LiquidLevelDetector],
				Object[Instrument,LiquidLevelDetector]
			],
			Description -> "The liquid level detection instruments used in this protocol to quantify sample volume.",
			Category -> "Volume Measurement",
			Abstract -> True
		},
		UltrasonicallyMeasured -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]|Model[Container],
			Description -> "Containers for which volume is determined by ultrasonically measuring the distance to the height of the liquid then calculating volume based on a known distance to volume function for the container.",
			Category -> "Volume Measurement"
		},
		GravimetricallyMeasured -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]|Model[Container],
			Description -> "Containers for which volume is measured by weighing the sample and calculating the volume based on its weight and known density.",
			Category -> "Volume Measurement"
		},
		WeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "Protocol executed to measure sample weights in order to back-calculate the volume from the recorded weights and known sample densities.",
			Category -> "Volume Measurement"
		},
		VolumeMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Groupings of samples and measurement parameters for liquid level detection-based volume measurement.",
			Category -> "Volume Measurement"
		},
		ErrorTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "The acceptable percent coefficient of variation of raw liquid level measurements for a given sample. Readings above this threshold will be retaken if possible and not used to update sample volumes.",
			Category -> "Volume Measurement"
		},

		
		(* --- Density Measurement --- *)
		DensityMeasurementSamples-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "Any samples for which density measurement is performed prior to volume measurement so that volume can be determined gravimetrically.",
			Category -> "Density Measurement"
		},
		Densities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> DensityP,
			Units -> (Gram/Milliliter),
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the density that will be used to convert any gravimetric measurement into a volume.",
			Category -> "Volume Measurement"
		},
		DensityMeasurementParameters -> {
			Format -> Multiple,
			Class -> {
				FixedVolume -> Real,
				NumberOfReplicates -> Integer,
				RecoupSample -> Boolean
			},
			Pattern :> {
				FixedVolume -> GreaterP[0*Micro*Liter],
				NumberOfReplicates -> GreaterP[0, 1],
				RecoupSample -> BooleanP
			},
			Units -> {
				FixedVolume -> Microliter,
				NumberOfReplicates -> None,
				RecoupSample -> None
			},
			Relation -> {
				FixedVolume -> Null,
				NumberOfReplicates -> Null,
				RecoupSample -> Null
			},
			IndexMatching -> DensityMeasurementSamples,
			Description ->  "For each member of DensityMeasurementSamples, the fixed volume to transfer and weigh, the number of replicate weighings to perform, and if the samples weighed will be recouped back into their source after weighing.",
			Category -> "Density Measurement"
		},

		(* --- Batching Information --- *)
		BatchedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Units -> None,
			Description -> "The list of containers that will have their volume measured, sorted by container groupings that will be measured simultaneously as part of the same 'batch'.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedVolumeCalibrations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,Volume],
			IndexMatching -> BatchedContainers,
			Description -> "For each member of BatchedContainers, the volume calibration that will be used to convert the raw distance measurements from the liquid level detector into volumes.",
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
		BatchedMeasurementDevices -> {
			Format -> Multiple,
			Class -> {
				LiquidLevelDetector -> Link,
				SensorArmHeight -> Real,
				TubeRack -> Link,
				PlatePlatform -> Link,
				PlateLayoutFileName -> String,
				DataFileName -> String,
				BatchNumber -> Integer
			},
			Pattern :> {
				LiquidLevelDetector -> _Link,
				SensorArmHeight -> GreaterP[0*Meter],
				TubeRack -> _Link,
				PlatePlatform -> _Link,
				PlateLayoutFileName -> _String,
				DataFileName -> _String,
				BatchNumber -> GreaterP[0,1]
			},
			Relation -> {
				LiquidLevelDetector -> Alternatives[Model[Instrument,LiquidLevelDetector],Object[Instrument,LiquidLevelDetector]],
				SensorArmHeight -> Null,
				TubeRack -> Alternatives[Model[Container,Rack],Object[Container,Rack]],
				PlatePlatform -> Alternatives[Model[Container,Rack],Object[Container,Rack]],
				PlateLayoutFileName -> Null,
				DataFileName -> Null,
				BatchNumber -> Null
			},
			Units -> {
				LiquidLevelDetector -> None,
				SensorArmHeight -> Milli Meter,
				TubeRack -> None,
				PlatePlatform -> None,
				PlateLayoutFileName -> None,
				DataFileName -> None,
				BatchNumber -> None
			},
			Headers -> {
				LiquidLevelDetector -> "LiquidLevelDetector",
				SensorArmHeight -> "SensorArmHeight",
				TubeRack -> "TubeRack",
				PlatePlatform -> "PlatePlatform",
				PlateLayoutFileName -> "PlateLayoutFileName",
				DataFileName -> "DataFileName",
				BatchNumber -> "BatchNumber"
			},
			IndexMatching -> BatchLengths,
			Description -> "For each member of BatchLengths, the measurement setup values shared by each container in the batch.",
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
			Description -> "The index in WorkingContainers of each container in BatchedContainers.",
			Category -> "Batching",
			Developer -> True
		},
		TareDistances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data,Volume]],
			Units -> None,
			Description -> "The TareDistances taken for any volume measurements taken with a LiquidLevelDetector instrument.",
			Category -> "Batching",
			Developer -> True
		},
		RawDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The csv files containing the raw unprocessed data generated by the instrument, as extracted from the spreadsheet generated by the instrument software and used for troubleshooting purposes only.",
			Category->"Experimental Results",
			Developer->True
		}
		
	}
}];
