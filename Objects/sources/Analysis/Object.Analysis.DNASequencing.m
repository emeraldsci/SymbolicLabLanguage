(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,DNASequencing],{
	Description->"Base calling analysis for assigning nucleobase sequences to DNA-sequencing data.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,Peaks][SequenceAnalysis],
			Description->"Peak picking analyses used in this base-calling sequence analysis.",
			Category -> "General"
		},
		SequenceAssignment->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The sequence of nucleobases assigned to input data by this DNA sequencing analysis.",
			Category->"Analysis & Reports",
			Abstract->True
		},
		SequenceBases->{
			Format->Multiple,
			Class->String,
			Pattern:>Alternatives["A","T","C","G","N"],
			Description->"A sequential list of the individual bases assigned to input data by this DNA sequencing analysis.",
			Category->"Analysis & Reports"
		},
		QualityValues->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of SequenceBases, the quality value of the base assignment. A quality value of >20 is considered an accurate base assignment; a quality value between 15-19 is considered a mediocre accuracy; a quality value below 15 is considered poor accuracy.",
			Category->"Analysis & Reports",
			Abstract->True,
			IndexMatching->SequenceBases
		},
		BaseProbabilities->{
			Format->Multiple,
			Class->{Real,Real,Real,Real},
			Pattern:>{RangeP[0.0,1.0],RangeP[0.0,1.0],RangeP[0.0,1.0],RangeP[0.0,1.0]},
			Headers->{"A","T","C","G"},
			Description->"For each member of SequenceBases, the individual likelihood that each DNA nucleobase corresponds to that base.",
			Category->"Analysis & Reports",
			IndexMatching -> SequenceBases
		},
		SequencePeakPositions->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0.0],
			Description->"For each member of SequenceBases, the cycle read in the input electropherograms at which the base call was assigned.",
			Category->"Analysis & Reports",
			IndexMatching -> SequenceBases
		},
		UntrimmedSequenceBases->{
			Format->Multiple,
			Class->String,
			Pattern:>Alternatives["A","T","C","G","N"],
			Description->"A sequential list of the individual bases assigned to input data prior to sequence trimming.",
			Category->"Analysis & Reports"
		},
		UntrimmedQualityValues->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of UntrimmedSequenceBases, the quality value of the base assignment.",
			Category->"Analysis & Reports",
			Abstract->True,
			IndexMatching -> UntrimmedSequenceBases
		},
		UntrimmedBaseProbabilities->{
			Format->Multiple,
			Class->{Real,Real,Real,Real},
			Pattern:>{RangeP[0.0,1.0],RangeP[0.0,1.0],RangeP[0.0,1.0],RangeP[0.0,1.0]},
			Headers->{"A","T","C","G"},
			Description->"For each member of UntrimmedSequenceBases, the individual likelihood that each DNA nucleobase corresponds to that base.",
			Category->"Analysis & Reports",
			IndexMatching -> UntrimmedSequenceBases
		},
		UntrimmedSequencePeakPositions->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0.0],
			Description->"For each member of UntrimmedSequenceBases, the cycle read in the input electropherograms at which the base call was assigned.",
			Category->"Analysis & Reports",
			IndexMatching -> UntrimmedSequenceBases
		},
		PhredQualityParameters->{
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {NumericP,NumericP,NumericP,NumericP},
			Description -> "For each member of UntrimmedSequenceBases, the four-parameter Phred quality parameters (spacing, 7peak, 3peak, resolution) for that base. Used to calculate quality values and train quality value models.",
			Category -> "Analysis & Reports",
			IndexMatching -> UntrimmedSequenceBases
		},
		SequencingElectropherogramTraceA->{
			Format -> Single,
			Class -> Compressed,
			Pattern :> CoordinatesP,
			Description->"The unitless raw electropherogram data corresponding to the nucleobase \"A\" used in this DNA sequencing analysis.",
			Category->"Analysis & Reports"
		},
		SequencingElectropherogramTraceC->{
			Format -> Single,
			Class -> Compressed,
			Pattern :> CoordinatesP,
			Description->"The unitless raw electropherogram data corresponding to the nucleobase \"C\" used in this DNA sequencing analysis.",
			Category->"Analysis & Reports"
		},
		SequencingElectropherogramTraceG->{
			Format -> Single,
			Class -> Compressed,
			Pattern :> CoordinatesP,
			Description->"The unitless raw electropherogram data corresponding to the nucleobase \"G\" used in this DNA sequencing analysis.",
			Category->"Analysis & Reports"
		},
		SequencingElectropherogramTraceT->{
			Format -> Single,
			Class -> Compressed,
			Pattern :> CoordinatesP,
			Description->"The unitless raw electropherogram data corresponding to the nucleobase \"T\" used in this DNA sequencing analysis.",
			Category->"Analysis & Reports"
		}
	}
}];
