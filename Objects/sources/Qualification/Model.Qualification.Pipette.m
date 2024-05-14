(* ::Package:: *)

DefineObjectType[Model[Qualification, Pipette], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a pipette.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the buffer that will be used in this Qualification.",
			Category -> "General"
		},
		BufferReservoirModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container in which the buffer is prepared in, prior to pipetting.",
			Category -> "General"
		},
		BufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*(Micro*Liter)],
			Units -> Liter,
			Description -> "The volumes that will be pipetted into each container for this Qualification.",
			Category -> "General"
		},
		TipModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The model of the pipetting tip that will be used for this Qualification.",
			Category -> "General"
		}
	}
}];
