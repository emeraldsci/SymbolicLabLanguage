(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CalibrateVolume], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates volume measurements of samples in plates or vessels.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container for which this path length-to-volume calibration was generated.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		RackModel-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack]],
			Description -> "The models of rack used to hold the non-self-standing containers that this path length-to-volume calibration applies to.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to calibrate a volume fit in this model of maintenance.",
			Category -> "General",
			Abstract -> True
		},
		BufferReservoirModel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The container the calibration buffer will be held in before being dispensed to the containers being calibrated.",
			Category -> "General"
		},
		VolumeBuffer->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[1],
			Units->None,
			Description->"Factor to multiply the minimum required buffer volume by to determine how much total buffer will be created.",
			Category -> "General"
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of replicate containers used in this model of calibration.",
			Category -> "General"
		},
		VolumeRanges->{
			Format->Multiple,
			Class->{Real,Real,Integer},
			Pattern:>{GreaterP[0Microliter],GreaterP[0Microliter],GreaterP[1]},
			Units->{Milliliter,Milliliter,None},
			Description->"The volumes used for calibration will fall into these ranges.",
			Category -> "General",
			Headers->{"Start Volume", "End Volume", "Number of Volumes in Range"}
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
		LayoutFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the file used to specify the layout settings for the liquid level detector's distance measurements of the target containers.",
			Category -> "Sample Preparation",
			Developer -> True
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
