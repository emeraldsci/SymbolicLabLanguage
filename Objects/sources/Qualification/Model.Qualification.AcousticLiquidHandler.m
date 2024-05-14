(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,AcousticLiquidHandler],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of an acoustic liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		InputPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"A list of transfers, consolidations, aliquots that will be performed in the order listed to test an acoustic liquid handler for the qualification.",
			Category->"Qualifications & Maintenance"
		},
		InputUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description->"A list of transfers, consolidations, aliquots that will be performed in the order listed to test an acoustic liquid handler for the qualification.",
			Category->"Qualifications & Maintenance"
		}
	}
}];