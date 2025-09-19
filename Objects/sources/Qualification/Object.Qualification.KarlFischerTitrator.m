(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,KarlFischerTitrator],{
	Description->"A protocol that verifies the functionality of the KarlFischerTitrator instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		WaterContent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 MassPercent],
			Units -> MassPercent,
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, indicates the measured amount of water present in each sample.",
			Category -> "Experimental Results"
		},
		ExpectedWaterContent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 MassPercent],
			Units -> MassPercent,
			IndexMatching -> QualificationSamples,
			Description -> "For each member of QualificationSamples, indicates the expected amount of water present in each sample based on the sample's Certificate of Analysis.",
			Category -> "Experimental Results"
		}
	}
}];