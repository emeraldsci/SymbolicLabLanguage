(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,MeasureLiquidHandlerDeckAccuracy],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the deck offsets of a liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SBSCalibrationTool->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Plate],
			Description->"Calibration tool used to measure the physical position of the SBS plate positions.",
			Category->"General"
		},
		TipCalibrationTool->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Plate],
			Description->"Calibration tool used to measure the physical position of the tip positions.",
			Category->"General"
		},
		NumberOfPositions->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of positions on which we will measure how close the perfect theoretical coordinates of the carrier positions to the experimental positions.",
			Category->"General"
		},
		NumberOfWells->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[4,1],
			Units->None,
			Description->"Number of individual wells per plate that will be used to characterize the position of the plate in space.",
			Category->"General"
		}
	}
}];