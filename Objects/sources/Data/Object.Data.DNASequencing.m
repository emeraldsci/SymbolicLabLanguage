(* ::Package:: *)

DefineObjectType[Object[Data, DNASequencing], {
	Description->"DNA sequencing measures the fluorescent wavelength and intensity emitted from a labeled nucleotide and assigns the identity of the nucleotide.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Method Information --- *)
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "The well in the plate from which the fluorescence sequencing data were collected.",
			Category -> "General"
		},
		InjectionIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Description -> "The numeric position indicating when this data was measured for the experiment, where 1 indicates the first injection. Injections are performed in consecutive runs from the same well with the same run parameters.",
			Category -> "General"
		},
		(*AdenosineTripshophateTerminator->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is thymine.",
			Category -> "General"
			},
		ThymidineTripshophateTerminator->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is adenine.",
			Category -> "General"
			},
		GuanosineTripshophateTerminator->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is cytosine.",
			Category -> "General"
			},
		CytosineTriphosphateTerminator->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is guanine.",
			Category -> "General"
			},*)

		(* --- Experimental Results --- *)
		SequencingElectropherogramChannel1 -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{ArbitraryUnit,ArbitraryUnit}],
			Units -> {ArbitraryUnit,ArbitraryUnit},
			Description -> "The raw electropherogram data for one channel obtained by the instrument in terms of the intensity of the fluorescent signal over time.",
			Category -> "Experimental Results"
		},
		SequencingElectropherogramChannel2 -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{ArbitraryUnit,ArbitraryUnit}],
			Units -> {ArbitraryUnit,ArbitraryUnit},
			Description -> "The raw electropherogram data for one channel obtained by the instrument in terms of the intensity of the fluorescent signal over time.",
			Category -> "Experimental Results"
		},
		SequencingElectropherogramChannel3 -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{ArbitraryUnit,ArbitraryUnit}],
			Units -> {ArbitraryUnit,ArbitraryUnit},
			Description -> "The raw electropherogram data for one channel obtained by the instrument in terms of the intensity of the fluorescent signal over time.",
			Category -> "Experimental Results"
		},
		SequencingElectropherogramChannel4 -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{ArbitraryUnit,ArbitraryUnit}],
			Units -> {ArbitraryUnit,ArbitraryUnit},
			Description -> "The raw electropherogram data for one channel obtained by the instrument in terms of the intensity of the fluorescent signal over time.",
			Category -> "Experimental Results"
		},

		(* --- Data Processing --- *)
		Channel1BaseAssignment -> {
			Format -> Single,
			Class -> String,
			Pattern :> Alternatives["A","T","G","C","Unknown"],
			Description -> "The assignment of the nucleotide base for one channel of raw electropheogram data.",
			Category -> "Data Processing"
		},
		Channel2BaseAssignment -> {
			Format -> Single,
			Class -> String,
			Pattern :> Alternatives["A","T","G","C","Unknown"],
			Description -> "The assignment of the nucleotide base for one channel of raw electropheogram data.",
			Category -> "Data Processing"
		},
		Channel3BaseAssignment -> {
			Format -> Single,
			Class -> String,
			Pattern :> Alternatives["A","T","G","C","Unknown"],
			Description -> "The assignment of the nucleotide base for one channel of raw electropheogram data.",
			Category -> "Data Processing"
		},
		Channel4BaseAssignment -> {
			Format -> Single,
			Class -> String,
			Pattern :> Alternatives["A","T","G","C","Unknown"],
			Description -> "The assignment of the nucleotide base for one channel of raw electropheogram data.",
			Category -> "Data Processing"
		},

		(* --- Analysis & Reports --- *)
		SequenceAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of base-calling analyses conducted on the fluorescence intensity data from the raw electropherogram.",
			Category -> "Analysis & Reports"
		},
		SequencingAssignments -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of base pair assignments from analyses conducted on the fluorescence intensity data from the raw electropherogram.",
			Category -> "Analysis & Reports"
		},
		QualityValues -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "A list of the quality values of the base assignments analyses indicating the accuracy of the base assignment. A quality value of >20 is considered an accurate base assignment; a quality value between 15-19 is considered a mediocre accuracy; a quality value below 15 is considered poor accuracy.",
			Category -> "Analysis & Reports"
		}
	}
}]
