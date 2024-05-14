

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibratePathLength], {
	Description->"A protocol that generates a calibration for sample absorbance to path length using a plate reader and liquid level detector.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Volumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The list of volume points that were used to generate the calibration fit.",
			Category -> "Sample Preparation"
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of replicate containers this calibration maintenance uses.",
			Category -> "Sample Preparation",
			Abstract -> True
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
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The liquid handler instrument that transfers standard volumes of the target buffer to the target containers to make a standard curve for calibration.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		LiquidHandlerPrimaryKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The key this maintenance uses to indentify the robotic liquid handling program used to transfer buffer to the calibration containers.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		EstimatedProgramTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "Estimated time for which the buffer transfer, plate reading and liquid level detection program will run on the liquid handler.",
			Category -> "Sample Preparation",
			Developer -> True
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
			Description -> "Pipette tips used for the protocol.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		LiquidLevelDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The liquid level detector instrument that measures liquid level for this maintenance.",
			Category -> "Path Length Measurement",
			Abstract -> True
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]| Object[Sample], Null},
			Headers -> {"Container","Placement Tree"},
			Description -> "A list of rules specifying the locations on the liquid handler deck where target containers are placed prior to standard volume transferring.",
			Category -> "Placements"
		},
		PathLengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The measured path lengths for each well in each of the target containers.",
			Category -> "Experimental Results"
		},
		PathLengthCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration][Maintenance],
			Description -> "The absorbance-to-path-length calibration generated using the data created by this maintenance.",
			Category -> "Experimental Results"
		},
		EmptyDistances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "Liquid level measurements of the empty target plates.",
			Category -> "Experimental Results"
		},
		EmptyAbsorbance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "Absorbance measurements of the empty target plates.",
			Category -> "Experimental Results"
		},
		StandardDistances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "Liquid level measurements of the target plates containing set increments of the specified liquid.",
			Category -> "Experimental Results"
		}
	}
}];
