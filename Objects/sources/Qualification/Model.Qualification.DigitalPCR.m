(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,DigitalPCR],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a thermocycler for digital PCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Sample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The template DNA sample to use in the ddPCR reactions.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of Samples, the volume of sample template to resource pick.",
			Category -> "General"
		},

		ForwardPrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The oligomer that binds target sequence on the antisense strand of the template.",
			Category -> "General"
		},
		ForwardPrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of ForwardPrimers, the volume of sample template to resource pick.",
			Category -> "General",
			IndexMatching -> ForwardPrimers
		},

		ReversePrimers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The oligomer that binds target sequence on the sense strand of the template.",
			Category -> "General"
		},
		ReversePrimerVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of ReversePrimers, the volume of sample template to resource pick.",
			Category -> "General",
			IndexMatching -> ReversePrimers
		},

		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The fluorescently labeled oligomer that is used to quantify the amount of target sequence.",
			Category -> "General"
		},
		ProbeVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of Probes, the volume of sample template to resource pick.",
			Category -> "General",
			IndexMatching -> Probes
		},

		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "For each member of Samples, the solution added to the reaction mixture after all components are added to reach the ReactionVolume.",
			Category -> "General"
		},
		DiluentVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of Samples, the amount of diluent to prepare.",
			Category -> "General"
		},

		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The total volume of reagents in each reaction mixture.",
			Category -> "General"
		}
	}
}];
