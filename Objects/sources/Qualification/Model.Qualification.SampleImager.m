(* ::Package:: *)

DefineObjectType[Model[Qualification,SampleImager], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a sample imager.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		ImagingReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample]
			],
			Description -> "The reagent to be used for imaging in this qualification.",
			Category -> "General"
		},
		ImagingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container]
			],
			Description -> "The containers in which samples will be imaged for this qualification.",
			Category -> "General"
		}
			 																																																																								 																																																																						
	}
}];
