(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,PCR],{
	Description->"A protocol that verifies the functionality of the thermocycler target for PCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		FluorescenceIntensityProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,FluorescenceIntensity],
			Description->"The fluorescence intensity protocol used to quantify the amount of template after a PCR protocol.",
			Category -> "General"
		},
		Template -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The template DNA sample to use in the PCR reactions.",
			Category -> "General"
		},
		Primers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The premixed set of primers to use in the PCR reactions.",
			Category -> "General"
		},
		MasterMix -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The concentrated master mix to use to perform PCR.",
			Category -> "General"
		},
		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The solution used to dilute the reaction mixture to a 1X master mix concentration.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the microwave test samples.",
			Category -> "Sample Preparation"
		}
	}
}];
