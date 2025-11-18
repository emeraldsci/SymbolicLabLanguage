(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2025 Emerald Cloud Lab, Inc.*)


modelGraduatedCylinderTransferFields = {
	GraduatedCylinderBufferModel->{
		Units -> None,
		Relation -> Model[Sample],
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Description -> "The model of buffer that will be transferred to test the user's graduated cylinder transfer skills. Defaults to MilliQ water.",
		Category -> "Graduated Cylinder Skills"
	},
	GraduatedCylinderModels->{
		Units -> None,
		Relation -> Model[Container, GraduatedCylinder],
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Description -> "The models of graduated cylinder that will be used to test the user's ability to accurately transfer volumes of a test sample using graduated cylinders.",
		Category -> "Graduated Cylinder Skills"
	},
	GraduatedCylinderBufferVolumes->{
		Units -> None,
		Relation -> Null,
		Format -> Multiple,
		Class -> Expression,
		Pattern :> GreaterEqualP[0*(Micro*Liter)],
		IndexMatching -> GraduatedCylinderModels,
		Description -> "For each member of GraduatedCylinderModels, the volume that will be transferred into the destination container for this Qualification.",
		Category -> "Graduated Cylinder Skills"
	},
	GradingCriteria->{
		Format -> Multiple,
		Class -> Real,
		Pattern:>GreaterP[0],
		Units->None,
		IndexMatching -> GraduatedCylinderModels,
		Description -> "For each member of GraduatedCylinderModels, the permitted deviation from the target GraduatedCylinderBufferVolumes defined as a multiple of the graduated cylinder model's Resolution. Specifically, the maximum allowable deviation to pass qualification is calculated by multiplying the GradingCriteria by the Resolution. For example, if a graduated cylinder model has a Resolution of 2 milliliters and the GradingCriteria is 2.5, then the deviation must be less than 5 milliliters for the training practical to pass.",
		Category -> "Passing Criteria"
	}
};

With[
	{fields=modelGraduatedCylinderTransferFields},

	DefineObjectType[
		Model[Maintenance,Training,GraduatedCylinderTransfer],
		{
			Description->"Definition of a set of parameters for a maintenance protocol that allows an operator to practice using a graduated cylinder.",
			CreatePrivileges->None,
			Cache->Session,
			Fields -> fields
		}
	]
];