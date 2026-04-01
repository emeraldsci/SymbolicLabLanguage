(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Viscometer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a viscometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MeasurementTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterEqualP[0*Celsius],2],
			Description -> "For each member of QualificationSampleLabels, indicates the set of MeasurementTemperatures at which viscosity readings will be measured.",
			Category -> "General",
			IndexMatching -> QualificationSampleLabels
		},
		ExpectedViscosities -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Milli*Pascal*Second], 2],
			Description -> "For each member of QualificationSampleLabels, indicates the expected viscosities at given temperatures defined by MeasurementTemperatures.",
			Category -> "General",
			IndexMatching -> QualificationSampleLabels
		}
	}
}];
