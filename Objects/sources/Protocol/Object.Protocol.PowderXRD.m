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
		CrystallizationPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
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
			Description -> "Indicates if the crystallization plate was imaged after it was prepared and dried, but before it was loaded onto the diffractometer.",
			Category -> "Sample Preparation",
			Abstract -> False
		},
		ImageXRDPlateProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ImageSample],
			Description -> "The protocol that imaged the crystallization plate after it was prepared and dried, but before it was loaded onto the diffractometer.",
			Category -> "Sample Preparation"
		}

	}
}];
