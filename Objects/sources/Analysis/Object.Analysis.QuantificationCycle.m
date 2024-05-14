(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,QuantificationCycle],{
	Description->"Determination of the amplification cycle at which the fluorescence in a quantitative polymerase chain reaction (qPCR) can be detected above the background fluorescence, which is defined as either the point at which the amplification curve crosses the target-specific threshold (Threshold method) or the inflection point of the amplification curve (InflectionPoint method).",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===Method Information===*)
		Protocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,qPCR][QuantificationCycleAnalyses],
			Description->"The quantitative polymerase chain reaction (qPCR) protocol associated with the data used for analysis.",
			Category -> "General"
		},
		Method->{
			Format->Single,
			Class->Expression,
			Pattern:>Threshold|InflectionPoint,
			Description->"The calculation method used for quantification cycle analysis.",
			Category -> "General",
			Abstract->True
		},
		Domain->{
			Format->Single,
			Class->{Integer,Integer},
			Pattern:>{GreaterP[0 Cycle],GreaterP[0 Cycle]},
			Units->{Cycle,Cycle},
			Description->"The first and last cycle delimiting the range for analysis.",
			Headers->{"Min","Max"},
			Category -> "General"
		},
		BaselineDomain->{
			Format->Single,
			Class->{Integer,Integer},
			Pattern:>{GreaterP[0 Cycle],GreaterP[0 Cycle]},
			Units->{Cycle,Cycle},
			Description->"The first and last cycle delimiting the range of the baseline.",
			Headers->{"Min","Max"},
			Category -> "General"
		},
		SmoothingRadius->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Cycle],
			Units->Cycle,
			Description->"The radius in cycles for GaussianFilter smoothing of the normalized and baseline-subtracted amplification curve, applicable to the InflectionPoint method.",
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
			Description->"The forward primer used to amplify the target sequence, applicable to the Threshold method.",
			Category -> "General"
		},
		ReversePrimer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Molecule],
			Description->"The reverse primer used to amplify the target sequence, applicable to the Threshold method.",
			Category -> "General"
		},
		Probe->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Molecule],
			Description->"The reporter probe (composed of a short, sequence-specific oligomer conjugated with a reporter and quencher) used to quantify the target sequence, applicable to the Threshold method.",
			Category -> "General"
		},
		FittingDataPoints->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Cycle,RFU}],
			Units->{Cycle,RFU},
			Description->"The processed amplification curve data points in Domain for interpolation (Threshold method) or logistic curve fitting (InflectionPoint method).",
			Category -> "General"
		},
		ExcitationWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"The excitation wavelength associated with the amplification curve.",
			Category -> "General"
		},
		EmissionWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"The emission wavelength associated with the amplification curve.",
			Category -> "General"
		},
		Threshold->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 RFU],
			Units->RFU,
			Description->"The fluorescence signal significantly above baseline fluorescence at which amplification is considered to have begun, applicable to the Threshold method.",
			Category -> "General"
		},


		(*===Analysis & Reports===*)
		AmplificationFit->{
			Format->Single,
			Class->Expression,
			Pattern:>_Function,
			Description->"The logistic curve fit to the amplification curve data points, applicable to the InflectionPoint method.",
			Category->"Analysis & Reports"
		},
		QuantificationCycle->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Cycle],
			Units->Cycle,
			Description->"The amplification cycle at which the fluorescence in a quantitative polymerase chain reaction (qPCR) can be detected above the background fluorescence, determined using either the Threshold or InflectionPoint method.",
			Category->"Analysis & Reports",
			Abstract->True
		},
		StandardCurveAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"The linear fit analyses that use this quantification cycle analysis as a data point for fitting a standard curve.",
			Category->"Analysis & Reports"
		},
		CopyNumberAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"The copy number analyses based on this quantification cycle analysis.",
			Category->"Analysis & Reports"
		}
	}
}];
