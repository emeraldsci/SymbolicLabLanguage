(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, SampleImager], {
	Description->"A protocol that verifies the functionality of the sample imager target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		ImagingDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ImagingDirectionP,ImagingDirectionP},
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, the direction(s) from which each sample is imaged.",
			Category -> "General"
		},
		IlluminationDirections->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {IlluminationDirectionP},
			IndexMatching -> QualificationSamples,
			Description->"For each member of QualificationSamples, the direction(s) from which the sample is illuminated.",
			Category -> "General"
		}	
		
	}
}];
