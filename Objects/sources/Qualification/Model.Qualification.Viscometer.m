(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Viscometer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a viscometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		QualificationSampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined strings to provide as input to the ExperimentMeasureViscosity experiment call.",
			Category -> "General",
			Developer -> True
		},
		MeasurementTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterEqualP[0*Celsius],2],
			Description -> "For each member of QualificationSampleLabels, indicates the set of MeasurementTemperatures at which viscosity readings will be measured.",
			IndexMatching -> QualificationSampleLabels,
			Category -> "General"
		},
		ExpectedViscosities -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Milli*Pascal*Second], 2],
			Description -> "For each member of QualificationSampleLabels, indicates the expected viscosities at given temperatures defined by MeasurementTemperatures.",
			IndexMatching -> QualificationSampleLabels,
			Category -> "General"
		}
	}
}];
