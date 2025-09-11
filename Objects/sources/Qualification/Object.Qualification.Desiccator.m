(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Desiccator], {
	Description -> "A protocol that verifies the functionality of the desiccator target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		QualificationSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The sample used to verify whether a desiccator effectively absorbs water molecules from the samples during desiccation.",
			Category -> "General"
		},
		Amount -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The mass of the QualificationSample used to verify whether a desiccator effectively absorbs water molecules from the samples during desiccation.",
			Category -> "General"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method for drying a sample (removing water or solvent molecules from the solid) to verify the desiccator's effectiveness in absorbing water molecules during desiccation. Available methods include StandardDesiccant, DesiccantUnderVacuum, and Vacuum.",
			Category -> "General"
		},
		Desiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "A hygroscopic chemical used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		DesiccantAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 Gram], GreaterEqualP[0 Milliliter]],
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Duration of time that the sample is dried with the lid off via desiccation inside a desiccator.",
			Category->"Drying"
		},
		HydratedSampleImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A link to an image file from the QualificationSample before the desiccation.",
			Category -> "Passing Criteria"
		},
		DrySampleImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A link to an image file from the QualificationSample after the desiccation.",
			Category -> "Passing Criteria"
		}
	}
}];
