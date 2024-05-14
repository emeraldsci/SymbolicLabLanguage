(* ::Package:: *)

DefineObjectType[Model[Qualification,PlateImager], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a plate imager.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		IlluminationDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {IlluminationDirectionP..},
			Description -> "For each member of SamplesOut from the SamplePreparationProtocol, the direction(s) from which the sample is illuminated.",
			Category -> "General"
		}
	}
}];
