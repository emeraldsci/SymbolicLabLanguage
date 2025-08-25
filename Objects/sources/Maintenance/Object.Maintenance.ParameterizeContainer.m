(* ::Package:: *)

(* Package *)

DefineObjectType[Object[Maintenance,ParameterizeContainer],{
	Description->"A protocol that parameterizes the dimensions, shape, and properties of new containers that are received.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ParameterizationModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel][Parameterizations],
				Model[Container,Plate][Parameterizations],
				Model[Container,PhaseSeparator][Parameterizations]
			],
			Description->"For each member of Containers, the model of the container that this maintenance is parameterizing.",
			Category->"Qualifications & Maintenance",
			IndexMatching->Containers,
			Abstract->True
		},
		Containers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"The specific container vessels that this maintenance is parameterizing.",
			Category->"Qualifications & Maintenance",
			Abstract->True
		},
		EquivalentContainers->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of Containers, the IDs of container matching the model of the container being parameterized.",
			Category->"Qualifications & Maintenance"
					(* todo: does this want to be index matched to Containers? *)
		},

		PossibleMatchingContainerFootprints -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The list of containers with possible matching footprints for the containers being parameterized. It is continuously updated during the Maintenance based on operator feedback.",
			Category->"Qualifications & Maintenance",
			Developer -> True
		},
		PossibleMatchingContainerFootprintsResult -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"The operators assessment of each of the displayed PossibleMatchingContainerFootprints.",
			Category->"Qualifications & Maintenance",
			Developer ->True
		},
		IdentifiedFootprint->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "The footprint of the container that the operator has identified.",
			Category -> "Qualifications & Maintenance"
		},

		MeasureWeightMask->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of Containers, decides whether a TareWeight should be taken.",
			Category -> "General",
			IndexMatching->Containers
		},

		PotentialEquivalentContainer->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The ID of a container with a potential footprint matching that of the container being parameterized.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},

		PotentialFootprintMatch->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Determines if the scanned container in question truly does have a matching footprint to the container being parameterized.",
			Category -> "General",
			Developer->True
		},

		MeasureDensityMask->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of Containers, decides whether the density of the sample should be measured.",
			Category -> "General",
			IndexMatching->Containers
		},
		ImageSampleMask->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of Containers, decides whether the sample should be imaged.",
			Category -> "General",
			IndexMatching->Containers
		},
		CurrentEquivalentContainer->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The ID of a container matching the model of the container being parameterized.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		CurrentEquivalentContainerObject->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The object reference of a container matching the model of the container being parameterized.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		CurrentEquivalentContainerVerified->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the appropriate properties of the properties of the CurrentEquivalentContainer have been verified to match the model of the container being parameterized.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		(* measurements taken during parameterization *)
		ParameterizationMeasurementsLog -> {
			Format -> Multiple,
			Class -> {
				Date,
				Link,
				Expression,
				Expression,
				Boolean,
				Link
			},
			Pattern :> {
				_?DateObjectQ,
				_Link,
				ParameterizationMeasurementTypeP,
				DistanceP|_?NumericQ|CrossSectionalShapeP|WellShapeP,
				BooleanP,
				_Link
			},
			Relation -> {
				Null,
				Alternatives[
					Model[Container,Vessel],
					Model[Container,Plate],
					Model[Container,PhaseSeparator]
				],
				Null,
				Null,
				Null,
				Object[User,Emerald]
			},
			Units -> {
				None,
				None,
				None,
				None,
				None,
				None
			},
			Description -> "A log of all measurements taken during the parameterization of this set of container models.",
			Headers -> {
				"Time Evaluated",
				"Container Model",
				"Type",
				"Measurement",
				"Accepted",
				"Operator"
			},
			Category -> "Parameterization Measurements"
		},
		ContainerHasSkirtFlange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the container has an additional bump around the skirt at the perimiter of the container.",
			Category -> "Parameterization Measurements"
		},
		OverallDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the overall dimensions make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfOverallDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times we have been forced to start over from the beginning.",
			Category -> "Parameterization Measurements"
		},
		Caliper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The specific caliper used to perform measurements in this protocol.",
			Category -> "Qualifications & Maintenance"
		},
		Calipers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The specific caliper used to perform measurements in this protocol.",
			Category -> "Qualifications & Maintenance"
		},
		HeightGauge -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument,DistanceGauge],Model[Instrument,DistanceGauge]],
			Description->"The specific height gauge used to perform measurements in this protocol.",
			Category->"Qualifications & Maintenance"
		},
		DepthGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The specific depth gauge used to perform measurements in this protocol.",
			Category -> "Qualifications & Maintenance"
		},
		BatteryRequirements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Battery], Model[Part, Battery]],
			Description -> "The batteries required for the calipers and gauges used in this protocol.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		CaliperBatteryRequirements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Battery], Model[Part, Battery]],
			Description -> "The batteries required for the caliper used in this protocol.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		HeightGaugeBatteryRequirements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Battery], Model[Part, Battery]],
			Description -> "The batteries required for the height gauge used in this protocol.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		DepthGaugeBatteryRequirements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Battery], Model[Part, Battery]],
			Description -> "The batteries required for the depth gauge used in this protocol.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		CalibrationBlockFields -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "For each member of CalibrationBlocks, the field name in this maintenance that they are stored for verifying distances and placing plates on top.",
			Developer -> True,
			IndexMatching -> CalibrationBlocks,
			Category -> "Qualifications & Maintenance"
		},
		CalibrationBlocksVerified -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CalibrationBlocks, indicates if the calibration block is free of cracks and good to use as precision standards.",
			Developer -> True,
			IndexMatching -> CalibrationBlocks,
			Category -> "Qualifications & Maintenance"
		},
		CalibrationBlocks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "The calibration blocks used in this maintenance for verifying distances and placing plates on top.",
			Developer -> True,
			Category -> "Qualifications & Maintenance"
		},
		CalibrationBlockVerificationMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "A list of measurements that verify if the calibration blocks stored in CalibrationBlockFields is good to use as precision standards.",
			Category -> "Parameterization Measurements"
		},
		CalibrationBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A precisely machined block used for verifying distance measuring instruments in this protocol.",
			Category -> "Qualifications & Maintenance"
		},
		FirstPlateBottomMeasuringJig -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A jig used for placing plates on top of in order to probe their bottom geometry.",
			Category -> "Qualifications & Maintenance"
		},
		SecondPlateBottomMeasuringJig -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A jig used for placing plates on top of in order to probe their bottom geometry.",
			Category -> "Qualifications & Maintenance"
		},
		ThirdPlateBottomMeasuringJig -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A jig used for placing plates on top of in order to probe their bottom geometry.",
			Category -> "Qualifications & Maintenance"
		},
		FourthPlateBottomMeasuringJig -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A jig used for placing plates on top of in order to probe their bottom geometry.",
			Category -> "Qualifications & Maintenance"
		},
		FifthPlateBottomMeasuringJig -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, CalibrationDistanceBlock],Model[Item, CalibrationDistanceBlock]],
			Description -> "A jig used for placing plates on top of in order to probe their bottom geometry.",
			Category -> "Qualifications & Maintenance"
		},
		RetryMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to retry in the case of inconsistencies.",
			Category -> "Parameterization Measurements"
		},
		NumberOfMeasurementRetries -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have retried measurements in an attempt for consistencies.",
			Category -> "Parameterization Measurements"
		},
		OuterDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the specific measurement fields to determine the outer width/length dimensions.",
			Category -> "Parameterization Measurements"
		},
		HeightDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to determine the height dimensions.",
			Category -> "Parameterization Measurements"
		},
		HorizontalWellDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to determine the well dimensions (spacing, well diameter, margin) in the horizontal direction.",
			Category -> "Parameterization Measurements"
		},
		VerticalWellDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to determine the well dimensions (spacing, well diameter, margin) in the vertical direction.",
			Category -> "Parameterization Measurements"
		},
		BottomCavityDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to determine the bottom cavity dimensions.",
			Category -> "Parameterization Measurements"
		},
		WellDepthDimensionMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "Indicates the measurements to determine the well depth dimensions.",
			Category -> "Parameterization Measurements"
		},
		(* specific dimensions fields below!! *)
		(*********************************************************)
		OuterDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the outer width/length measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfOuterDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the outer width/length measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		HeightDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the height measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfHeightDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the height measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		HorizontalWellDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the horizontal well measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfHorizontalWellDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the horizontal well measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		VerticalWellDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the vertical well measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfVerticalWellDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the vertical well measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		BottomCavityDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the bottom cavity measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfBottomCavityDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the bottom cavity measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		WellDepthDimensionsConsistency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the well depth measurements make sense and could have all come from the expected geometry of the same object.",
			Category -> "Parameterization Measurements"
		},
		NumberOfWellDepthDimensionsParameterizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times we have looped over the well depth measurements instructions.",
			Category -> "Parameterization Measurements"
		},
		PrimaryOuterDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the caliper before the OuterDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryOuterDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the caliper before the OuterDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryOuterDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the caliper before the OuterDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryBottomXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement left to right length along the bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryBottomXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement left to right length along the bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryBottomYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement front to back length along the bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryBottomYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement front to back length along the bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryTopXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement left to right length along the top of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryTopXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement left to right length along the top of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryTopYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement front to back length along the top of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryTopYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement front to back length along the top of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryMiddleXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement left to right length above a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryMiddleXMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement left to right length above a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryMiddleYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement front to back length above a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryMiddleYMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement front to back length above a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryHeightDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the height gauge before the HeightDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryHeightDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the height gauge before the HeightDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryHeightDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the height gauge before the HeightDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryFlangeHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the base to the top of a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryFlangeHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement from the base to the top of a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		TertiaryFlangeHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement from the base to the top of a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		QuaternaryFlangeHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Quaternary measurement from the base to the top of a ridge along the outside bottom of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryTotalHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the base to topmost portion of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryTotalHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement from the base to topmost portion of the plate.",
			Category -> "Parameterization Measurements"
		},
		TertiaryTotalHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement from the base to topmost portion of the plate.",
			Category -> "Parameterization Measurements"
		},
		QuaternaryTotalHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Quaternary measurement from the base to topmost portion of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the caliper before the HorizontalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the caliper before the HorizontalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the caliper before the HorizontalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryXMarginLeftMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the left edge of the plate to the closest edge of the inside cavity of the well along the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryXMarginRightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the right edge of the plate to the closest edge of the inside cavity of the well along the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryColumnNumberMeasurement -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The latest final Primary indication of the number of columns of wells in the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellXDimensionMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the interior width of the cavity of the well in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellXDimensionMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the interior width of the cavity of the well in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellXSpacingMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the smallest distance between the cavities of two nearby wells in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellXSpacingMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the smallest distance between the cavities of two nearby wells in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellXMaxWidthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the largest distance between inner surface of the cavities of two farthest wells in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellXMinMaxWidthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the smallest distance between inner surface of the cavities of two farthest wells in the left to right dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryVerticalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the caliper before the VerticalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryVerticalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the caliper before the VerticalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryVerticalWellDimensionsCaliperVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the caliper before the VerticalWellDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellShapeMeasurement -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrossSectionalShapeP,
			Units -> None,
			Description -> "The latest final Primary identification of the shape of the well.",
			Category -> "Parameterization Measurements"
		},
		PrimaryRowNumberMeasurement -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The latest final Primary indication of the number of rows of wells in the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellYDimensionMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the interior width of the cavity of the well in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellYDimensionMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the interior width of the cavity of the well in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellYSpacingMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the smallest distance between the cavities of two nearby wells in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellYSpacingMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the smallest distance between the cavities of two nearby wells in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellYMaxWidthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the largest distance between inner surface of the cavities of two farthest wells in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellYMinMaxWidthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the smallest distance between inner surface of the cavities of two farthest wells in the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryYMarginTopMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the back edge of the plate to the closest edge of the inside cavity of the well along the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryYMarginBottomMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement from the front edge of the plate to the closest edge of the inside cavity of the well along the front to back dimension.",
			Category -> "Parameterization Measurements"
		},
		PrimaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the height gauge before the BottomCavityDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the height gauge before the BottomCavityDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the height gauge before the BottomCavityDimensions instructions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnNoBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the plate height while it is not sitting on any jig.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnNoBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the plate height while it is not sitting on any jig.",
			Category -> "Parameterization Measurements"
		},
		TertiaryPlateOnNoBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of the plate height while it is not sitting on any jig.",
			Category -> "Parameterization Measurements"
		},
		PrimaryFirstBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of the first jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryFirstBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of the first jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnFirstBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of a plate when placed on the first jig block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnFirstBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of a plate when placed on the first jig block.",
			Category -> "Parameterization Measurements"
		},
		PrimarySecondBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of the second jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondarySecondBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of the second jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnSecondBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of a plate when placed on the second jig block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnSecondBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of a plate when placed on the second jig block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryThirdBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of the third jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryThirdBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of the third jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnThirdBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of a plate when placed on the third jig block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnThirdBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of a plate when placed on the third jig block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryFourthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of the fourth jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryFourthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of the fourth jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnFourthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of a plate when placed on the fourth jig block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnFourthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of a plate when placed on the fourth jig block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryFifthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of the fifth jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		SecondaryFifthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of the fifth jig block used to probe the bottom shape of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryPlateOnFifthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of the height of a plate when placed on the fifth jig block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryPlateOnFifthBlockHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of the height of a plate when placed on the fifth jig block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement of a known width block obtained by the depth gauge before the WellDepthDimensions block.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement of a known width block obtained by the depth gauge before the WellDepthDimensions block.",
			Category -> "Parameterization Measurements"
		},
		TertiaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement of a known width block obtained by the depth gauge before the WellDepthDimensions block.",
			Category -> "Parameterization Measurements"
		},
		PrimaryDepthRodHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement obtained when the depth rod is placed on the table with no plate in the way.",
			Category -> "Parameterization Measurements"
		},
		PrimaryDepthRodPlateHeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement obtained when the depth rod is placed on the highest part of the plate.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement obtained when the depth rod is placed into the lowest point in the cavity of a well.",
			Category -> "Parameterization Measurements"
		},
		SecondaryWellDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement obtained when the depth rod is placed into the lowest point in the cavity of a well.",
			Category -> "Parameterization Measurements"
		},
		TertiaryWellDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement obtained when the depth rod is placed into the lowest point in the cavity of a well.",
			Category -> "Parameterization Measurements"
		},
		QuaternaryWellDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Quaternary measurement obtained when the depth rod is placed into the lowest point in the cavity of a well.",
			Category -> "Parameterization Measurements"
		},
		QuinaryWellDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Quinary measurement obtained when the depth rod is placed into the lowest point in the cavity of a well.",
			Category -> "Parameterization Measurements"
		},
		PrimaryWellBottomShapeMeasurement -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellShapeP,
			Units -> None,
			Description -> "The latest final Primary identification of the shape of the well bottom.",
			Category -> "Parameterization Measurements"
		},
		PrimaryConicalDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Primary measurement obtained when the depth rod is positioned at the inflection point between the straight and the conical section of the well interior geometry.",
			Category -> "Parameterization Measurements"
		},
		SecondaryConicalDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Secondary measurement obtained when the depth rod is positioned at the inflection point between the straight and the conical section of the well interior geometry.",
			Category -> "Parameterization Measurements"
		},
		TertiaryConicalDepthMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Object[Data][Maintenance],
			Description -> "The latest final Tertiary measurement obtained when the depth rod is positioned at the inflection point between the straight and the conical section of the well interior geometry.",
			Category -> "Parameterization Measurements"
		},
		StorageOrientationMeasurementItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items whose optimal storage orientation is determined during parameterization.",
			Category -> "Qualifications & Maintenance"
		},
		FragileMeasurementItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items whose fragility is evaluated during parameterization.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];
