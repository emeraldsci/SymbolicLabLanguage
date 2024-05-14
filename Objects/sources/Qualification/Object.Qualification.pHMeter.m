(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,pHMeter], {
	Description->"A protocol that verifies the functionality of the pH meter target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
			Description -> "For each member of QualificationSamples, the probe used in this protocol to measure the pH of the standard.",
			IndexMatching -> QualificationSamples,
			Category -> "General",
			Abstract -> True
		},
		pHData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,pH],
			Description -> "For each member of QualificationSamples, the pH information collected using the target pH Meter.",
			IndexMatching -> QualificationSamples,
			Category -> "Experimental Results"
		},
		MeasurementAccuracy -> {
			Format -> Multiple,
			Class -> {pH -> Real, ExpectedpH -> Real, Passing -> Boolean},
			Pattern :> {pH -> pHP, ExpectedpH -> pHP, Passing -> BooleanP},
			Description -> "For each member of QualificationSamples, the measured pH, expected pH, and whether or not the value meets the MaxpHError criterion.",
			IndexMatching -> QualificationSamples,
			Headers -> {pH -> "pH", ExpectedpH -> "Expected pH", Passing -> "Passing"},
			Category -> "Experimental Results"
		},
		MeasurementPrecision -> {
			Format -> Multiple,
			Class -> {Standard -> Link, pHDistribution -> Expression, RSD -> Real, Passing -> Boolean},
			Pattern :> {Standard -> _Link, pHDistribution -> DistributionP[], RSD -> GreaterEqualP[0Percent], Passing -> BooleanP},
			Relation -> {Standard -> Object[Sample], pHDistribution -> Null, RSD -> Null, Passing -> Null},
			Units -> {Standard -> None, pHDistribution -> None, RSD -> Percent, Passing -> None},
			Description -> "For each qualification sample, the pH distribution from replicate pH measurements, and whether or not the %RSD meets the MaxpHRSD criterion.",
			Headers -> {Standard -> "Standard", pHDistribution -> "pH Distribution", RSD -> "% Relative Standard Deviation", Passing -> "Passing"},
			Category -> "Experimental Results"
		},
		MeasurementPrecisionNew -> {
			Format -> Multiple,
			Class -> {Probe->Link,Standard -> Link, pHDistribution -> Expression, RSD -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link,Standard -> _Link, pHDistribution -> DistributionP[], RSD -> GreaterEqualP[0Percent], Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument,pHMeter]|Object[Part,pHProbe],Standard -> Object[Sample], pHDistribution -> Null, RSD -> Null, Passing -> Null},
			Units -> {Probe-> None,Standard -> None, pHDistribution -> None, RSD -> Percent, Passing -> None},
			Description -> "For each qualification sample, the pH distribution from replicate pH measurements, and whether or not the %RSD meets the MaxpHRSD criterion.",
			Headers -> {Probe->"Probe",Standard -> "Standard", pHDistribution -> "pH Distribution", RSD -> "% Relative Standard Deviation", Passing -> "Passing"},
			Category -> "Experimental Results"
		},
		MeasurementPrecisions -> {
			Format -> Multiple,
			Class -> {Probe->Link,Standard -> Link, pHDistribution -> Expression, RSD -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link,Standard -> _Link, pHDistribution -> DistributionP[], RSD -> GreaterEqualP[0Percent], Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument,pHMeter]|Object[Part,pHProbe],Standard -> Object[Sample], pHDistribution -> Null, RSD -> Null, Passing -> Null},
			Units -> {Probe-> None,Standard -> None, pHDistribution -> None, RSD -> Percent, Passing -> None},
			Description -> "For each qualification sample, the pH distribution from replicate pH measurements, and whether or not the %RSD meets the MaxpHRSD criterion.",
			Headers -> {Probe->"Probe",Standard -> "Standard", pHDistribution -> "pH Distribution", RSD -> "% Relative Standard Deviation", Passing -> "Passing"},
			Category -> "Experimental Results"
		},
		Slope -> {
			Format -> Single,
			Class -> {Slope -> Real, Ratio -> Real, Passing -> Boolean},
			Pattern :> {Slope -> LessP[0 Millivolt], Ratio -> GreaterP[0], Passing -> BooleanP},
			Units -> {Slope -> Millivolt, Ratio -> None, Passing -> None},
			Headers -> {Slope -> "Slope", Ratio -> "Slope/Expected Slope", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		SlopeNew -> {
			Format -> Multiple,
			Class -> {Probe->Link, Slope -> VariableUnit, Ratio -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link, Slope -> Alternatives[LessP[0 Millivolt],GreaterP[0 Percent]], Ratio -> GreaterP[0], Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument,pHMeter]|Object[Part,pHProbe],Slope -> Null, Ratio -> Null, Passing -> Null},
			Headers -> {Probe->"Probe", Slope -> "Slope", Ratio -> "Slope/Expected Slope", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		Slopes -> {
			Format -> Multiple,
			Class -> {Probe->Link, Slope -> VariableUnit, Ratio -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link, Slope -> Alternatives[LessP[0 Millivolt],GreaterP[0 Percent]], Ratio -> GreaterP[0], Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument,pHMeter]|Object[Part,pHProbe],Slope -> Null, Ratio -> Null, Passing -> Null},
			Headers -> {Probe->"Probe", Slope -> "Slope", Ratio -> "Slope/Expected Slope", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		DimensionlessSlope -> {
			Format -> Single,
			Class -> {Slope -> Real, Ratio -> Real, Passing -> Boolean},
			Pattern :> {Slope -> GreaterP[0], Ratio -> GreaterP[0], Passing -> BooleanP},
			Units -> {Slope -> None, Ratio -> None, Passing -> None},
			Headers -> {Slope -> "Slope", Ratio -> "Slope/Expected Slope", Passing -> "Passing"},
			Description -> "The slope of the graph of pH vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		Offset -> {
			Format -> Single,
			Class -> {Offset -> Real, Passing -> Boolean},
			Pattern :> {Offset -> VoltageP, Passing -> BooleanP},
			Units -> {Offset -> Millivolt, Passing -> None},
			Headers -> {Offset -> "Offset", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		Offsets -> {
			Format -> Multiple,
			Class -> {Probe->Link, Offset -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link, Offset -> VoltageP, Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument, pHMeter]|Object[Part,pHProbe],Offset -> Null,Passing -> Null},
			Units -> {Probe->None,Offset -> Millivolt, Passing -> None},
			Headers -> {Probe->"Probe",Offset -> "Offset", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		OffsetNew -> {
			Format -> Multiple,
			Class -> {Probe->Link, Offset -> Real, Passing -> Boolean},
			Pattern :> {Probe->_Link, Offset -> VoltageP, Passing -> BooleanP},
			Relation -> {Probe->Object[Instrument, pHMeter]|Object[Part,pHProbe],Offset -> Null,Passing -> Null},
			Units -> {Probe->None,Offset -> Millivolt, Passing -> None},
			Headers -> {Probe->"Probe",Offset -> "Offset", Passing -> "Passing"},
			Description -> "The slope of the graph of millivolts vs. pH, it's ratio to the expected slope, and whether it falls within the min and max acceptable slopes.",
			Category -> "Experimental Results"
		},
		MaxpHError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The maximum acceptable absolute difference between measured pH and expected pH.",
			Category -> "Acceptance Criteria"
		},
		MaxpHRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent relative standard deviation of replicate pH measurements.",
			Category -> "Acceptance Criteria"
		},
		MaxOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Millivolt],
			Units -> Millivolt,
			Description -> "The maximum absolute difference between 0 millivolts and the measured millivolt value at pH 7.",
			Category -> "Acceptance Criteria"
		},
		ExpectedSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LessP[0Millivolt],
			Units -> Millivolt,
			Description -> "The expected slope for a graph of millivolts vs. pH.",
			Category -> "Acceptance Criteria"
		},
		ExpectedDimensionlessSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The expected slope for a graph of pH vs. pH.",
			Category -> "Acceptance Criteria"
		},
		MinSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The minimum ratio of the calculated slope to the expected slope.",
			Category -> "Acceptance Criteria"
		},
		MaxSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The maximum ratio of the calculated slope to the expected slope.",
			Category -> "Acceptance Criteria"
		},
		(* Sample Preparation *)
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the pH Standards.",
			Category -> "Sample Preparation"
		}
	}
}];
