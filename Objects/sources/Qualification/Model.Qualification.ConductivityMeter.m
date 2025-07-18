(* ::Package:: *)

DefineObjectType[Model[Qualification,ConductivityMeter], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a conductivity meter.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* Method Information *)
		ConductivityStandards ->  {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Standards models of known conductivity that will be measured during qualifications.",
			Category -> "General",
			Abstract -> True
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, ConductivityProbe],
			Description -> "For each member of ConductivityStandards, the probe(s) used in this protocol to measure the conductivity of the sample(s).",
			IndexMatching -> ConductivityStandards,
			Category -> "General",
			Abstract -> True
		},
		CalibrationStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[Sample]|Model[Sample],
			Description -> "The standard sample which is used to calibrate the conductivity meter before we perform the measurements of ConductivityStandards.",
			Category -> "Calibration",
			Abstract -> True
		},
		SecondaryCalibrationStandard ->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"A secondary calibration standard used to calibrate probes of the conductivity meter that require two-point calibration before we perform the measurements of ConductivityStandards.",
			Category->"Calibration",
			Abstract->True
		}
	}
}];
