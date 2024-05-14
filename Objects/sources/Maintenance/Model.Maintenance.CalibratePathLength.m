(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CalibratePathLength], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates absorbance measurements to sample path lengths in a plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container for which this path length-to-volume calibration was generated.",
			Category -> "Calibration Parameters",
			Abstract -> True
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
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to calibrate absorbance to path length in this model of maintenance.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of replicate containers used in this model of maintenance.",
			Category -> "General"
		},
		WavelengthRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0 Nanometer], GreaterP[0 Nanometer]},
			Units -> {Nanometer, Nanometer},
			Description -> "The inclusive span of wavelengths to average absorbance over in the calibration curve.",
			Headers -> {"From", "To"},
			Category -> "General"
		},
		MaxSingleError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The maximum error of any single point in this calibration before maintenances of this model are determined to be Anomalous.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MaxMeanError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The maximum limit of average error of all points in this calibration before maintenances of this model are determined to be Anomalous.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];
