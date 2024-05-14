(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,Desiccator], {
	Description->"A model of an instrument used to keep internal samples dry through the use of a vacuum and/or desiccants.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SampleType -> {
			Format->Single,
			Class->Expression,
			Pattern:>Open|Closed,
			Description->"The type of sample that are intended to occupy this model of desiccator. Open SampleType leaves the container of the sample open and isolated to actively dry the sample inside whereas Closed SampleType is for long term storage and leaves the containers closed while sharing the desiccator with many containers.",
			Category->"Instrument Specifications"
		},
		Desiccant->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item],
			Description->"The model of drying agent used to keep the contents of the desiccator dry.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		DesiccantCapacity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Gram],
			Units->Gram,
			Description->"The weight of the desiccant the desiccator is cable of holding.",
			Category->"Instrument Specifications"
		},
		DesiccantReplacementFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Week],
			Units->Week,
			Description->"The frequency with which the desiccant should be replaced.",
			Category->"Instrument Specifications"
		},
		Vacuumable->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the contents of the desiccator can be evacuated using a vacuum source.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		MinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"Minimum internal pressure the desiccator can withstand (as designated by its pressure gauge).",
			Category->"Instrument Specifications",
			Abstract->True
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Vaccuum pump used to create low pressure atmosphere inside the desiccator.",
			Category -> "Instrument Specifications"
		},
		SampleLocation->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{LocationPositionP, ObjectP[Model[Instrument, Desiccator]]},
			Description->"The location in the instrument where desiccant is placed.",
			Category->"Instrument Specifications"
		},
		DrierLocation->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{LocationPositionP, ObjectP[Model[Instrument, Desiccator]]},
			Description->"The location in the instrument where samples are placed.",
			Category->"Instrument Specifications"
		}
	}
}];
