(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,GraduatedCylinderTransfer], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to use a graduated cylinder.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GraduatedCylinderBufferModel->{
				Units -> None,
				Relation -> Model[Sample],
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model of buffer that will be transferred to test the user's graduated cylinder transfer skills. Defaults to MilliQ water.",
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
			GraduatedCylinderModels->{
				Units -> None,
				Relation -> Model[Container, GraduatedCylinder],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The models of graduated cylinder that will be used to test the user's ability to accurately transfer volumes of a test sample using graduated cylinders.",
				Category -> "Graduated Cylinder Skills"
				}
	}
}
]