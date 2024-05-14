(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,CopyNumber],{
	Description->"Determination of the initial number of target copies in a sample, based on a standard curve of quantification cycle vs Log10 copy number.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===Method Information===*)
		Protocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,qPCR][CopyNumberAnalyses],
			Description->"The quantitative polymerase chain reaction (qPCR) protocol associated with the quantification cycle analysis used for copy number analysis.",
			Category -> "General"
		},
		Data->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,qPCR][CopyNumberAnalyses],
			Description->"The quantitative polymerase chain reaction (qPCR) data associated with the quantification cycle analysis used for copy number analysis.",
			Category -> "General"
		},
		Template->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"The nucleic acid template used for target sequence amplification.",
			Category -> "General"
		},
		ForwardPrimer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Molecule],
			Description->"The forward primer used to amplify the target sequence.",
			Category -> "General"
		},
		ReversePrimer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Molecule],
			Description->"The reverse primer used to amplify the target sequence.",
			Category -> "General"
		},
		Probe->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Molecule],
			Description->"The reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and a quencher) used to quantify the target sequence.",
			Category -> "General"
		},
		StandardCurve->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,Fit][PredictedValues],
			Description->"The standard curve used to determine the copy number.",
			Category -> "General"
		},


		(*===Analysis & Reports===*)
		CopyNumber->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The initial number of target copies in the sample, calculated based on StandardCurve.",
			Category->"Analysis & Reports",
			Abstract->True
		},
		Efficiency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Percent],
			Units->Percent,
			Description->"The polymerase chain reaction (PCR) efficiency, calculated based on the slope of StandardCurve.",
			Category->"Analysis & Reports"
		}
	}
}];
