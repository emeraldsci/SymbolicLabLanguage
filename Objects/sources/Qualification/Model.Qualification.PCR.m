(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,PCR],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a thermocycler for PCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution used to dilute the reaction mixture to a 1X master mix concentration.",
			Category -> "General"
		},
		DiluentVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Microliter],
			Units -> Microliter,
			Description -> "The amount of diluent to prepare.",
			Category -> "General"
		},
		MasterMix -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The concentrated master mix to use to perform PCR.",
			Category -> "General"
		},
		MasterMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Microliter],
			Units -> Microliter,
			Description -> "The amount of master mix to resource pick.",
			Category -> "General"
		},
		Primers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The premixed set of primers to use in the PCR reactions.",
			Category -> "General"
		},
		PrimerVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Microliter],
			Units -> Microliter,
			Description -> "The volume of primers to resource pick.",
			Category -> "General"
		},
		Sample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The template DNA sample to use in the PCR reactions.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Microliter],
			Units -> Microliter,
			Description -> "The volume of sample template to resource pick.",
			Category -> "General"
		},
		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Microliter],
			Units -> Microliter,
			Description -> "The total volume of reagents in each well of the PCR plate.",
			Category -> "General"
		}
	}
}];
