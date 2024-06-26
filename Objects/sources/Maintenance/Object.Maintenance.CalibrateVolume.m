(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibrateVolume], {
	Description->"A protocol that calibrates distance-based ultrasonic volume measurement in plates or vessels.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		Volumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The list of volume points that were used to generate the calibration fit.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of replicate containers this calibration maintenance uses.",
			Category -> "Sample Preparation"
		},
		TargetBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The buffer samples this maintenance uses to fill incrementally the calibration containers.",
			Category -> "Sample Preparation"
		},
		TargetContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The specific containers this maintenance uses as replicates to calibrate the target container model.",
			Category -> "Sample Preparation"
		},
				
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The disposable pipette tips used to aspirate and dispense liquid volumes during this calibration maintenance.",
			Category -> "Sample Preparation"
		},
		GraduatedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The graduated cylinders used to measure out volume increments to set up the calibration curve.",
			Category -> "Sample Preparation"
		},
		MeasuringInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The measuring instruments used to measure out volume increments to set up the calibration curve.",
			Category -> "Sample Preparation"
		},
		SensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The height at which the sensor arm was set initially to bring the liquid level sensor as close as possible to the neck of the vessel.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		
		BlankFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file names that are given to the blank plate data files generated by the liquid level detector.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file names that are given to the blank plate data files generated by the liquid level detector.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ContainerAdaptor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Container]|Object[Container]),
			Description -> "The adaptor needed to hold the containers before they can be read by the liquid level detector.",
			Category -> "Sample Preparation"
		},
		VolumeIncrements -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The volume increments that are added to each specific calibration container, starting with the first volume in the Volumes field.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BufferReceivingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "For each member of VolumeIncrements, the container to which the volume increment of buffer is added.",
			IndexMatching -> VolumeIncrements,
			Category -> "Sample Preparation",
			Developer -> True
		},
		BufferMeasurementDevices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description -> "For each member of VolumeIncrements, the measuring device used to dispense the increment into the associated buffer receiving container.",
			IndexMatching -> VolumeIncrements,
			Category -> "Sample Preparation",
			Developer -> True
		},
		DispenserCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solvent with which to clean the bottle top dispenser tubing.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PlateLayoutFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the file used to specify the layout settings for the liquid level detector's distance measurements of the target containers.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		TubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The rack in which the target containers are held for liquid level measurements.",
			Category -> "Experimental Results"
		},
		TubeRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container], Model[Container] | Object[Container], Null},
			Description -> "Placement instructions specifying the locations in the tube rack where the target containers are placed.",
			Headers -> {"Object to Place","Destination Object","Destination Position"},
			Developer -> True,
			Category -> "Placements"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample], Null},
			Headers -> {"Container","Placement Tree"},
			Description -> "A list of rules specifying the locations on the liquid handler deck where target containers are placed prior to standard volume transferring.",
			Category -> "Placements"
		},
		VolumeCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration][Maintenance],
			Description -> "The Liquid level-to-volume calibration generated using the data created by this maintenance.",
			Category -> "Experimental Results"
		},
		PathLengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The path lengths for each well in each of the target containers, calculated from the empty and standard distances measured by the liquid level detector.",
			Category -> "Experimental Results"
		},
		EmptyDistances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "Liquid level measurements of the empty target vessels.",
			Category -> "Experimental Results"
		},
		TareDistance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "A tared liquid level measurement with no vessel beneath the sensor.",
			Category -> "Experimental Results"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the Calibrated Volumes.",
			Category -> "Sample Preparation"
		},
		EmptyDistanceMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Automatic,IndexMatching,Average],
			Description -> "For container models with multiple wells, describes whether the calibration generated has a shared empty distance for all wells (Average), or an individual distance for each well (IndexMatching). Automatic resolves in the parser to the average method if the empty distances measured are homogeneous and IndexMatching otherwise.",
			Category -> "Method Information"
		}
		
	}
}];
