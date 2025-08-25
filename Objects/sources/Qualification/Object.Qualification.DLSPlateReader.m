(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, DLSPlateReader], {
	Description->"A protocol that verifies the functionality of the plate reader target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Sample Preparation *)
		LightScatteringValidationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The samples used for testing the accuracy of the light scattering results on the instrument.",
			Category -> "Sample Preparation"
		},
		LightScatteringIndependentReplicates -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "For each member of LightScatteringValidationSamples, number of independently prepared sample replicates or concentration series per sample type.",
			Category -> "Sample Preparation",
			IndexMatching -> LightScatteringValidationSamples
		},
		LightScatteringWellReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[3, 384, 1],
			Description -> "Number of technical well replicates for each sample/concentration.",
			Category -> "Sample Preparation"
		},
		LightScatteringSolventBlanks->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of LightScatteringValidationSamples, Samples used as blanks for static light scattering solvent offsets and testing cleanliness of sample preparation.",
			Category -> "Sample Preparation",
			IndexMatching -> LightScatteringValidationSamples
		},
		FilterContainerOut -> {
			Format->Single,
			Class->Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Model[Container, Plate]
				],
			Description -> "The plate or vial model that the samples and blanks are filtered into.",
			Category -> "Sample Preparation",
			Developer -> True,
			Abstract -> False
		},
		(* General *)
		LightScatteringQualificationProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,DynamicLightScattering],
			Description -> "The dynamic light scattering protocol used to interrogate DLS platereader light scattering performance.",
			Category -> "General"
		},
		VerifySource->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the source samples for this qualification should be verified by an independent absorbance spectroscopy experiment.",
			Category -> "General"
		},
		VerifySourceAbsorbanceSpectroscopyProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol used to verify source samples for this qualificaiton.",
			Category -> "General"
		}
	}
}];
