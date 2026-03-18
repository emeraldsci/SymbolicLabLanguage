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
		},
		StandardWaterContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 MassPercent],
			Units -> MassPercent,
			Description -> "Indicates the measured amount of water present in the selected Standard.",
			Category -> "Experimental Results"
		},
		ExpectedStandardWaterContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 MassPercent],
			Units -> MassPercent,
			Description -> "Indicates the expected amount of water present in the selected Standard based on the sample's Certificate of Analysis.",
			Category -> "Experimental Results"
		},
		Titer -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram / Milliliter],
			Units -> Milligram / Milliliter,
			Description -> "The amount of water that can be titrated per unit volume by the KarlFischerReagent used in this titration.",
			Category -> "Experimental Results"
		},
		Standard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample used to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift.",
			Category -> "Standards"
		}
	}
}];
