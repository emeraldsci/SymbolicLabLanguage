(* ::Package:: *)

DefineObjectType[Model[Qualification,pHMeter], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a pH meter.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		(* Method Information *)
		pHStandards ->  {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Standards models of known pH that will be measured during qualifications.",
			Category -> "General"
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
			Description -> "For each member of pHStandards, the probe used in this protocol to measure the pH of the standard.",
			IndexMatching -> pHStandards,
			Category -> "General"
		},
		QualificationProbes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
			Description -> "The probes used in this protocol to measure the pH of the standard.",
			Category -> "General",
			Abstract -> True
		},
		Replicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times each pH standard will be read to determine measurement precision.",
			Category -> "General"
		},
		MeasurementVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Milliliter],
			Units -> Milliliter,
			Description -> "The volume of standard to prepare (for droplet-based meters, this is the volume required per replicate).",
			Category -> "General"
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container model to put the samples into prior to pH measurement.",
			Category -> "General"
		},
		MaxpHRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent relative standard deviation of replicate pH measurements.",
			Category -> "Acceptance Criteria"
		},
		MaxpHRSDs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "For each member of QualificationProbes, the maximum acceptable percent relative standard deviation of replicate pH measurements.",
			IndexMatching -> QualificationProbes,
			Category ->  "Acceptance Criteria"
		},
		MaxpHError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The maximum acceptable absolute difference between measured pH and expected pH.",
			Category -> "Acceptance Criteria"
		},
		MaxpHErrors -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "For each member of QualificationProbes, the maximum acceptable absolute difference between measured pH and expected pH.",
			IndexMatching -> QualificationProbes,
			Category ->  "Acceptance Criteria"
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
		ExpectedPercentSlope -> {
			Format -> Single,
			Class -> VariableUnit ,
			Pattern :> Alternatives[LessP[0 Millivolt], GreaterP[0 Percent]],
			Description -> "The expected percent slope for a graph of millivolts vs. pH.",
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
		}
	}
}];
