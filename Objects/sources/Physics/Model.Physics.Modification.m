(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, Modification], {
	Description -> "User defined chemical or structural changes to an oligomer and its physical properties.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- Physical Properties --- *)

		Molecule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MoleculeP,
			Description -> "The molecular structure of the modification.",
			Category -> "Physical Properties"
		},
		MoleculeAdjustment -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {MoleculeP | None, MoleculeP | None},
			Headers -> {"Addition", "Removal"},
			Description -> "Changes to the molecular structure when the modification is incorporated into an oligomer.",
			Category -> "Physical Properties"
		},
		Mass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Gram / Mole],
			Units -> Gram / Mole,
			Description -> "The mass of the modification within the context of the larger oligomer chain.",
			Category -> "Physical Properties"
		},
		ExtinctionCoefficients -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0 * Nanometer], GreaterEqualP[0 * Liter / Centimeter / Mole]},
			Units -> {Nanometer, Liter / Centimeter / Mole},
			Headers -> {"Wavelength", "Molar Extinction"},
			Description -> "Denotes how strongly the modification absorbs a particular wavelength of light per sample path length.",
			Category -> "Physical Properties"
		},
		LambdaMax -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "Denotes the wavelength of the maximum absorbance value.",
			Category -> "Physical Properties"
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "Denotes the wavelength of the maximum emission value.",
			Category -> "Physical Properties"
		},
		QuantumYield -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0 * Nanometer], GreaterP[0 * Nanometer], RangeP[0, 1]},
			Units -> {Nanometer, Nanometer, None},
			Headers -> {"Excitation Peak Wavelength", "Emission Peak Wavelength", "Quantum Yield"},
			Description -> "Denotes the ratio of photons emitted over photons absorbed at a particular ExcitationPeakWavelength and EmissionPeakWavelength.",
			Category -> "Physical Properties"
		},

		(* --- Model Information --- *)

		Oligomers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Physics, Oligomer][Modifications],
			Description -> "Contains the oligomers that this modification can be used for.",
			Category -> "Model Information"
		},
    SyntheticMonomer -> {
      Format -> Multiple,
      Class -> {Strategy -> Expression, StockSolutionModel -> Link},
      Pattern :> {Strategy -> None|Boc|Fmoc|Phosphoramidite|_String, StockSolutionModel -> Null|_Link},
      Units -> {Strategy -> None, StockSolutionModel -> None},
      Relation -> {Strategy -> Null, StockSolutionModel -> Model[Sample,StockSolution]},
      Headers->{Strategy->"Strategy",StockSolutionModel->"StockSolutionModel"},
      Description -> "StockSolutions used as defaults by the synthesis experiment function for this modification. For cases where different synthetic strategies are possible (Boc and Fmoc for example), different StockSolutions might be specified.",
      Category -> "Model Information"
    },
    DownloadMonomer -> {
      Format -> Multiple,
      Class -> {Strategy -> Expression, StockSolutionModel -> Link},
      Pattern :> {Strategy -> None|Boc|Fmoc|Phosphoramidite|_String, StockSolutionModel -> Null|_Link},
      Units -> {Strategy -> None, StockSolutionModel -> None},
      Relation -> {Strategy -> Null, StockSolutionModel -> Model[Sample,StockSolution]},
      Headers->{Strategy->"Strategy",StockSolutionModel->"StockSolutionModel"},
      Description -> "StockSolutions used by the synthesis experiment function for this modification to moderate the number of reactive sites on the unmodified solid support. Different defaults can be used for different synthetic strategies (Boc and Fmoc for example).",
      Category -> "Model Information"
    }
  }
}];
