(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,BioLayerInterferometer],{
	Description->"A protocol that verifies the functionality of the bio-layer interferometer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Sample]|Model[Sample]),
			Description -> "The buffer used for dilutions, blanks, and equilibration.",
			Category -> "General"
		},
		QuantitationStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Sample]|Model[Sample]),
			Description -> "The solution with a known amount of analyte, which is used to generate a standard curve for the quantitation of analyte concentration in the input samples.",
			Category -> "General"
		},
		PreparatoryUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, consolidations, aliquiots, mixes and diutions that will be performed in the order listed to prepare samples for the qualification.",
			Category -> "Sample Preparation"
		}
	}
}];
