(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,BioLayerInterferometer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a bio-layer interferometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
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
		BufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Milliliter],
			Units -> Milliliter,
			Description -> "The amount of buffer to prepare or resource pick.",
			Category -> "General"
		}
	}
}];
