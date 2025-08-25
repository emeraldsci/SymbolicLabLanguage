(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,FragmentAnalyzer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a FragmentAnalyzer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		AnalysisMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Object[Method,FragmentAnalysis],
			Description -> "The pre-set parameters recommended by the Instrument Manufacturer for the FragmentAnalysis protocol to be used in the qualification.",
			Category -> "General"
		},
		AnalysisStrategy ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalysisStrategyP,
			Description -> "The type of technique (Qualitative or Quantitative) to be tested in this qualification. Qualitative testing evaluates whether the instrument correctly separates and detects fragment sizes within the SizeErrorTolerance and SizePrecisionTolerance specified by the manufacturer. Quantitative testing, in addition to qualitative testing, assesses whether the detected fragment size concentrations in standard samples fall within the QuantityErrorTolerance and QuantityPrecisionTolerance defined by the manufacturer.",
			Category -> "General"
		},
		SizePrecisionTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The maximum coefficient of variation (% CV) determined from the means of the detected fragment sizes that will allow the fragment size determination to be considered a pass by this qualification model. The % CV per target peak is calculated using standard deviation divided by mean of all comparable peaks detected.",
			Category->"General"
		},
		SizeErrorTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The maximum % Error calculated from the difference between the expected and actual size of a fragment that will allow the fragment size determination to be considered a pass by this qualification model.",
			Category->"General"
		},
		QuantityPrecisionTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The maximum coefficient of variation (% CV) for all measured total nucleotide concentrations that will allow the quantitation to be considered a pass by this qualification model. The % CV is calculated using standard deviation divided by mean of all total nuceotide concentration measurements.",
			Category->"General"
		},
		QuantityErrorTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The maximum % Error calculated from the difference between the expected and actual total nucleotide concentration that will allow the quantitation to be considered a pass by this qualification model.",
			Category->"General"
		}
	}
}];
