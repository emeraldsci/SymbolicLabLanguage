(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sample, StockSolution, Standard], {
	Description->"Model information for solutions used to collect standard data for instrument/assay calibration or comparison to experimental data.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StandardComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Molecule]
			],
			Description -> "The contents of the standard that are used for calibration or comparison to experimental samples.",
			Category -> "Formula"
		},
		StandardConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "For each member of StandardComponents, the manufacturer provided or theoretical micromolar concentration.",
			IndexMatching -> StandardComponents,
			Category -> "Formula"
		},
		StandardMassConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "For each member of StandardComponents, the manufacturer provided or theoretical mass concentration.",
			IndexMatching -> StandardComponents,
			Category -> "Formula"
		},
		StandardMolecularWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of StandardComponents, the molecular weight (the mass of one mole of the molecule).",
			IndexMatching -> StandardComponents,
			Category -> "Formula"
		},
		StandardLengths -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 BasePair, 1 BasePair] | GreaterP[0 Nucleotide, 1 Nucleotide],
			Description -> "For each member of StandardComponents, the length of the analyte in monomers.",
			IndexMatching -> StandardComponents,
			Category -> "Formula"
		},
		(* Experimental Results *)
		ReferenceNMR -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify the expected NMR spectrum for this standard.",
			Category -> "Experimental Results"
		},
		ReferenceChromatographs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify expected analytical HPLC traces for this standard.",
			Category -> "Experimental Results"
		},
		ReferenceMassSpectra -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify the expected mass spectrometry spectrum for this standard.",
			Category -> "Experimental Results"
		},
		ReferencePeaksPositiveMode -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "A list of reference mass-to-charge ratio (m/z) values expected in an obtained mass spectra of the standard analyzed by mass spectrometry in positive ion mode.",
			Category -> "Experimental Results"
		},
		ReferencePeaksNegativeMode -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "A list of reference mass-to-charge ratio (m/z) values expected in an obtained mass spectra of the standard analyzed by mass spectrometry in negative ion mode.",
			Category -> "Experimental Results"
		},
		LadderAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Ladder][Ladder],
			Description -> "The standard curve analyses created from this standard model when used as a ladder.",
			Category -> "Analysis & Reports"
		},
		CompatibleIonSource-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization that this standard is compatible with when using it for mass spectrometry.",
			Category -> "General"
		},
		PreferredSpottingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpottingMethodP,
			Description -> "The preferred plate spotting method to use for this standard when performing MALDI mass spectrometry with it.",
			Category -> "General"
		}
	}
}];
