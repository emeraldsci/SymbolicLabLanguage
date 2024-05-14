(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,LiquidParticleCounter],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a liquid particle counter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		BlankSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for checking the behaviours of the instrument under a blank sample.",
			Category -> "Analytes"
		},
		IntensityTestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for checking the behaviours of the instrument under a blank sample.",
			Category -> "Analytes"
		},
		DilutionTestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for testing diluting a series of different samples, current (Dec - 2022) this test is not in use.",
			Category -> "Analytes"
		}
	}
}];