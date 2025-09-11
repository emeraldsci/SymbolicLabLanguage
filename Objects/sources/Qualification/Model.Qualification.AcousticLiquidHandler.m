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
		},
		MaxDMSOStandardDeviation->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units->Percent,
			Description->"The upper bound allowed for the standard deviation of the DMSO concentrations measured in qualifications of this model.",
			Category->"Passing Criteria"
		},
		Sources -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]},
			Description -> "The transfer sources to test an acoustic liquid handler for the qualification.",
			Category -> "Qualifications & Maintenance"
		},
		Destinations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Container]}] | _String | {_Integer, ObjectP[Model[Container]]} | {LocationPositionP, _String | ObjectP[{Object[Container, Plate], Model[Container, Plate]}] | {_Integer, ObjectP[Model[Container]]}},
			Description -> "The transfer destinations to test an acoustic liquid handler for the qualification.",
			Category -> "Qualifications & Maintenance"
		},
		Amounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Nanoliter],
			Description -> "The transfer amounts to test an acoustic liquid handler for the qualification.",
			Category -> "Qualifications & Maintenance",
			Units -> Nanoliter
		}
	}
}];