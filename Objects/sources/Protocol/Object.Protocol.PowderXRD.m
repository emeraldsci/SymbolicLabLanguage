(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, PowderXRD], {
	Description->"A powder X-ray diffraction (XRD) experiment in which a powder sample is irradiated with X-rays and the diffraction pattern is measured to determine structural information.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Current -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliampere],
			Units -> Milliampere,
			Description -> "The current used to generate the X-rays in this experiment.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Diffractometer] | Model[Instrument, Diffractometer],
			Description -> "The instrument used to measure the X-ray diffraction of samples.",
			Category -> "General"
		},
		CrystallizationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Plate] | Model[Container, Plate],
			Description -> "The crystallization plate in which the samples will reside during X-ray data collection.",
			Category -> "General"
		},
		CrystallizationPlatePreparation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PreparationMethodP,
			Description -> "Indicates if the loading of the crystallization plate should occur manually or on a robotic liquid handler.",
			Category -> "Sample Preparation"
		},
		CrystallizationPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the loading of the crystallization plate used during X-ray data collection.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CrystallizationPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to load the crystallization plate used during X-ray data collection.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		CrystallizationPlatePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, ManualSamplePreparation],
				Object[Protocol, RoboticSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "A sample preparation protocol used to load the crystallization plate used during X-ray data collection.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		SpottingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume to be loaded onto each well of the crystallization plate used during X-ray data collection.",
			Category -> "Sample Preparation"
		},
		SampleHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack] | Model[Container, Rack],
			Description -> "The rack holding the container holding the samples during X-ray data collection.",
			Category -> "General"
		},
		ExposureTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the length of time that the sample is exposed to X-rays during the collection of each data point in a scan.",
			Category -> "General"
		},
		DetectorDistances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the distance from the powder sample to the detector.",
			Category -> "General"
		},
		OmegaAngleIncrements -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*AngularDegree],
			Units -> AngularDegree,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the change in the sample's angle in relation to the X-ray source between each scan.",
			Category -> "General"
		},
		DetectorRotations-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Fixed | Sweeping,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates whether the detector stays in one positions or moves through multiple positions through the course of a sample's scans.",
			Category -> "General"
		},
		OmegaAngles -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[AngularDegree], UnitsP[AngularDegree]},
			Units -> {AngularDegree, AngularDegree},
			IndexMatching -> SamplesIn,
			Headers -> {"Min Omega Angle", "Max Omega Angle"},
			Description -> "For each member of SamplesIn, the start and end angles between the sample and X-ray source during the sample's runs. These will be set to Null if the corresponding value of DetectorRotations is set to Sweeping.",
			Category -> "General"
		},
		DetectorAngles -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[AngularDegree], UnitsP[AngularDegree]},
			Units -> {AngularDegree, AngularDegree},
			IndexMatching -> SamplesIn,
			Headers -> {"Min Detector Angle", "Max Detector Angle"},
			Description -> "For each member of SamplesIn, the start and end angles between the X-ray source and detector during the sample's runs.",
			Category -> "General"
		},
		DetectorAngleIncrements -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*AngularDegree],
			Units -> AngularDegree,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the change in the detector's angle in relation to the X-ray source between each set of scans.",
			Category -> "General"
		},
		RawDataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the file paths where the raw diffraction data files are located.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file name for all the data directories for this protocol.",
			Category -> "General",
			Developer -> True
		},
		DataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the file paths where the processed diffraction data files are located.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		MethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the file paths where the method information are located.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		PlateFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The key used to identify the plate being measured during this X-ray diffraction experiment.",
			Category -> "General",
			Developer -> True
		},
		XRDParameters -> {
			Format -> Single,
			Class -> {
				ExposureTime -> Real,
				DetectorDistance -> Real,
				OmegaAngleIncrement -> Real,
				DetectorRotation -> Expression,
				MinOmegaAngle -> Real,
				MaxOmegaAngle -> Real,
				MinDetectorAngle -> Real,
				MaxDetectorAngle -> Real,
				DetectorAngleIncrement -> Real
			},
			Pattern :> {
				ExposureTime -> GreaterP[0*Second],
				DetectorDistance -> GreaterP[0*Millimeter],
				OmegaAngleIncrement -> GreaterP[0*AngularDegree],
				DetectorRotation -> Fixed | Sweeping,
				MinOmegaAngle -> UnitsP[AngularDegree],
				MaxOmegaAngle -> UnitsP[AngularDegree],
				MinDetectorAngle -> UnitsP[AngularDegree],
				MaxDetectorAngle -> UnitsP[AngularDegree],
				DetectorAngleIncrement -> GreaterP[0*AngularDegree]
			},
			Units -> {
				ExposureTime -> Second,
				DetectorDistance -> Millimeter,
				OmegaAngleIncrement -> AngularDegree,
				DetectorRotation -> Null,
				MinOmegaAngle -> AngularDegree,
				MaxOmegaAngle -> AngularDegree,
				MinDetectorAngle -> AngularDegree,
				MaxDetectorAngle -> AngularDegree,
				DetectorAngleIncrement -> AngularDegree
			},
			Description -> "The parameters for running this PowderXRD experiment that are populated if the same for all samples and Null if not.",
			Category -> "General",
			Developer -> True
		},
		XRDParametersIndexMatched -> {
			Format -> Multiple,
			Class -> {
				Sample -> Link,
				Position -> String,
				XCoordinate -> Real,
				YCoordinate -> Real,
				ZCoordinate -> Real,
				ExposureTime -> Real,
				DetectorDistance -> Real,
				OmegaAngleIncrement -> Real,
				DetectorRotation -> Expression,
				MinOmegaAngle -> Real,
				MaxOmegaAngle -> Real,
				MinDetectorAngle -> Real,
				MaxDetectorAngle -> Real,
				DetectorAngleIncrement -> Real
			},
			Pattern :> {
				Sample -> _Link,
				Position -> WellPositionP,
				XCoordinate -> GreaterP[0],
				YCoordinate -> GreaterP[0],
				ZCoordinate -> GreaterP[-1],
				ExposureTime -> GreaterP[0*Second],
				DetectorDistance -> GreaterP[0*Millimeter],
				OmegaAngleIncrement -> GreaterP[0*AngularDegree],
				DetectorRotation -> Fixed | Sweeping,
				MinOmegaAngle -> UnitsP[AngularDegree],
				MaxOmegaAngle -> UnitsP[AngularDegree],
				MinDetectorAngle -> UnitsP[AngularDegree],
				MaxDetectorAngle -> UnitsP[AngularDegree],
				DetectorAngleIncrement -> GreaterP[0*AngularDegree]
			},
			Units -> {
				Sample -> None,
				Position -> None,
				XCoordinate -> None,
				YCoordinate -> None,
				ZCoordinate -> None,
				ExposureTime -> Second,
				DetectorDistance -> Millimeter,
				OmegaAngleIncrement -> AngularDegree,
				DetectorRotation -> Null,
				MinOmegaAngle -> AngularDegree,
				MaxOmegaAngle -> AngularDegree,
				MinDetectorAngle -> AngularDegree,
				MaxDetectorAngle -> AngularDegree,
				DetectorAngleIncrement -> AngularDegree
			},
			Relation -> {
				Sample -> Alternatives[Object[Sample],Model[Sample]],
				Position -> None,
				XCoordinate -> None,
				YCoordinate -> None,
				ZCoordinate -> None,
				ExposureTime -> None,
				DetectorDistance -> None,
				OmegaAngleIncrement -> None,
				DetectorRotation -> None,
				MinOmegaAngle -> None,
				MaxOmegaAngle -> None,
				MinDetectorAngle -> None,
				MaxDetectorAngle -> None,
				DetectorAngleIncrement -> None
			},
			Description -> "The parameters for running this PowderXRD experiment.",
			Category -> "General",
			Developer -> True
		},
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The package of X-ray transparent plate seals used to cover plates of samples in this experiment.",
			Category -> "Sample Preparation",
			Abstract -> False
		},
		ImageXRDPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the crystallization plate was imaged after it was prepared, but before it was loaded onto the diffractometer.",
			Category -> "Sample Preparation",
			Abstract -> False
		},
		ImageXRDPlateProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ImageSample],
			Description -> "The protocol that imaged the crystallization plate after it was prepared, but before it was loaded onto the diffractometer.",
			Category -> "Sample Preparation"
		},
		ImageFiles->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The file paths of the sample and diffraction images generated by the experiment.",
			Category->"General",
			Developer -> True
		},
		XRayGeneratorLogs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A logging of values from sensors associated with the module responsible for generating high energy radiation. Each time the logging feature is started a new file is created; thus there may be more than one log file per protocol.",
			Category -> "Troubleshooting",
			Developer -> True
		},
		DetectorShieldPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part], Object[Instrument], None},
			Description -> "Sets the movements the operator performs with the detector shield part. The first index of the multiple field places the detector shield against the wall of the X-ray cabinet. The second index places the detector shield onto the detector.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Part to Place", "Destination Object", "Destination Position"}
		},
		PlateAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP,
			Relation -> Alternatives[Model[Container, Rack],Object[Container, Rack]],
			Description -> "An adapter for loading the low-profile CrystallizationPlate used for in the MassTransfer procedure onto the XtalCheck-S holder.",
			Category -> "Placements",
			Developer -> True
		},
		PlateAdapterStoragePlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Model[Container, Rack],Object[Container, Rack]], Alternatives[Model[Instrument],Object[Instrument]], None},
			Description -> "Movement instruction to return a plate-holding rack to its usual position.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Adapter", "Storage Container", "Storage Position"}
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The predicted time until the instrument will complete any step for which an operator is unneeded including automated selection of X-ray generator settings, X-ray generator equilibration, and data collection.",
			Developer -> True,
			Category -> "General"
		},
		TransferType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[MassTransfer, Slurry],
			Description -> "Indicates if sample is loaded into the CrystallizationPlate as a solid or as suspension (or solution) with a subsequent drying step.",
			Category -> "General"
		},
		Pestle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Spatula], Object[Item, Spatula]],
			Description -> "A tool used to break up large or monolithic particles such that they are able to be transfered into the wells of a CrystallizationPlate by MassTransfer methods.",
			Category -> "Sample Preparation"
		},
		Spatulas -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Spatula], Object[Item, Spatula]],
			Description -> "A tool used to transfer solids in preparation of the CrystallationPlate by MassTransfer methods.",
			Category -> "Sample Preparation"
		},
		PlateSealFoils -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Consumable], Object[Item, Consumable]],
			Description -> "The source of protective covers for individual wells of the CrystallizationPlate.",
			Category -> "Sample Preparation"
		},
		Tweezer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Tweezer], Object[Item, Tweezer]],
			Description -> "A tool used to help apply and remove PlateSealFoils from the CrystallizationPlate.",
			Category -> "Sample Preparation"
		},
		TransferEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, FumeHood],
				Object[Instrument, FumeHood],
				Model[Instrument, HandlingStation, FumeHood],
				Object[Instrument, HandlingStation, FumeHood],
				Model[Instrument, Balance],
				Object[Instrument, Balance]
			],
			Description -> "The instrument with destatic infrastructure where the loading of the CrystallizationPlate is performed.",
			Category -> "Sample Preparation"
		},
		Startup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Automatic, Manual],
			Description -> "Indicates if the X-ray software and generator are to be started in fully by script or by an operator.",
			Developer -> True,
			Category -> "General"
		},
		A1XCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The X value read by the XtalCheck-S when centered over well A1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		A1YCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The Y value read by the XtalCheck-S when centered over well A1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		A1ZCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[-1],
			Description -> "The Z value read by the XtalCheck-S when centered over well A1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		A12XCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The X value read by the XtalCheck-S when centered over well A12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		A12YCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The Y value read by the XtalCheck-S when centered over well A12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		A12ZCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[-1],
			Description -> "The Z value read by the XtalCheck-S when centered over well A12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H1XCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The X value read by the XtalCheck-S when centered over well H1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H1YCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The Y value read by the XtalCheck-S when centered over well H1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H1ZCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[-1],
			Description -> "The Z value read by the XtalCheck-S when centered over well H1.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H12XCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The X value read by the XtalCheck-S when centered over well H12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H12YCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0],
			Description -> "The Y value read by the XtalCheck-S when centered over well H12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		H12ZCoordinate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[-1],
			Description -> "The Z value read by the XtalCheck-S when centered over well H12.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		},
		WellImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photodocumentation of how successfully centered in x and y and aligned in z the wells of the powder plate were.",
			Developer -> True,
			Category -> "Dimensions & Positions"
		}
	}
}];
