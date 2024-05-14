(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, Volume], {
	Description->"A calibration that allows for calculation of sample volumes based on liquid level detection.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LiquidLevelDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidLevelDetector],
			Description -> "The liquid level detector instrument that generated the data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		LiquidLevelDetectorModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, LiquidLevelDetector],
			Description -> "The model of the liquid level detector instrument that generated the data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		VolumeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The volume sensor that generated the data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		VolumeSensorModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sensor, Volume],
			Description -> "The model of the volume sensor that generated the data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		VolumeSensorCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Sensor],
			Description -> "The calibration used by the volume sensor that generated the data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		ContainerModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate][VolumeCalibrations],
				Model[Container, Vessel][VolumeCalibrations],
				Model[Container, Cuvette][VolumeCalibrations]
			],
			Description -> "The models of container this path length-to-volume calibration applies to.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		Rack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Rack]
			],
			Description -> "The rack used to hold the non-self-standing containers that this path length-to-volume calibration applies to.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		RackModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack]
			],
			Description -> "The models of rack used to hold the non-self-standing containers that this path length-to-volume calibration applies to.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of buffer used during this volume calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		TareDistanceDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ|DistributionP[Millimeter],
			Description -> "The distribution of the measured height of the liquid level detector with no target vessels underneath.",
			Category -> "Experimental Results"
		},
		SensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance between the benchtop surface and the metal arm on which the volume sensor is mounted.",
			Category -> "Container Specifications"
		},
		LayoutFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The file used to instruct the volume measurement instrument which locations are relevant for measuring volume. Particularly relevant for measurement of plates or racks holding multiple tubes.",
			Category -> "General",
			Developer->True
		},
		EmptyDistanceDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ|DistributionP[Millimeter],
			Description -> "The distribution of the empty distance measurements taken of the target containers.",
			Category -> "Experimental Results"
		},
		WellEmptyDistanceDistributions -> {
			Format -> Multiple,
			Class -> {Name->Expression, Distribution->Expression},
			Pattern :> {Name->WellP, Distribution->_?DistributionParameterQ|DistributionP[Millimeter]},
			Description -> "The distribution of the empty distance measurements taken for each well of the target containers.",
			Category -> "Experimental Results",
			Headers -> {Name->"Name of Well", Distribution->"Empty Distance Distribution"}
		}
	}
}];
