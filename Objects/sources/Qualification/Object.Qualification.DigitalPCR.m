(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,DigitalPCR],{
	Description->"A protocol that verifies the functionality of the thermocycler target for digital PCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Flattened resource lists for resource picking *)
		QualificationForwardPrimers-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The forward primers that this experiment uses to amplify target sequences from input samples.",
			Category -> "General"
		},
		QualificationReversePrimers-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The reverse primers that this experiment uses to amplify target sequences from input samples.",
			Category -> "General"
		},

		QualificationProbes-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The probes that this experiment uses to generate signal during target amplification.",
			Category -> "General"
		},

		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The solution used to dilute the reaction mixture to a 1x master mix concentration.",
			Category -> "General"
		},

		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The total volume of reagents in each reaction mixture.",
			Category -> "General"
		},

		(* Primitives for sample prep *)
		QualificationSampleNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of sample names defined in PreparatoryUnitOperations for use as experimental inputs.",
			Category -> "Sample Preparation"
		},

		QualificationPrimerPairNames -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{_String,_String}..},
			Description -> "A list of primer pair names defined in PreparatoryUnitOperations for use as experimental inputs.",
			Category -> "Sample Preparation"
		},

		QualificationProbeNames -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_String)..},
			Description -> "A list of probe names defined in PreparatoryUnitOperations for use as experimental inputs.",
			Category -> "Sample Preparation"
		},

		PreparatoryUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, consolidations, aliquots, mixes and dilutions that will be performed in the order listed to prepare samples for the qualification.",
			Category -> "Sample Preparation"
		}
	}
}];
