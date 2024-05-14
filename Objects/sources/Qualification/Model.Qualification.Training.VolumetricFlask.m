(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,VolumetricFlask], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to fill a volumetric flask.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VolumetricFlaskModels->{
				Units -> None,
				Relation -> Model[Container, Vessel, VolumetricFlask],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model(s) of volumetric flasks that will be used to test the user's ability to measure amounts of a test sample using volumetric flasks. Note that the same model can be repeated for fidelity.",
				Category -> "Volumetric Flask Skills"
				}
	}
}
]