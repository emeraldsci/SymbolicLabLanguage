(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, Folding], {
	Description->"A simulation to predict the secondary structure of a given nucleic acid oligomer by considering the formation of potential intramolecular Watson-Crick pairing between nucleotides.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Method Information --- *)
		StartingMaterial -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "The objects containing the source structure used in this simulation.",
			Category -> "General",
			Abstract -> True
		},
		InitialStructure -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The starting structure of the nucleic acid oligomer which will be used as a template to add additional foldings to.",
			Category -> "General",
			Abstract -> True
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FoldingSimulationMethodP,
			Description -> "The type of algorithm used to predict the folding of the macromolecule.",
			Category -> "General",
			Abstract -> True
		},
		Heuristic -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HybridizationMethodP,
			Description -> "Indicates if the algoritm optimizes for the maximum number of bonds in the structures or the minimal energy of the structures.",
			Category -> "General",
			Abstract -> True
		},
		FoldingInterval -> {
			Format -> Single,
			Class -> {Integer, Integer, Integer},
			Pattern :> {GreaterP[0,1],GreaterP[0Nucleotide,1Nucleotide],GreaterP[0Nucleotide,1Nucleotide]},
			Units -> {None, Nucleotide, Nucleotide},
			Description -> "The interval of the given starting structure over which folds will be computed.",
			Category -> "General",
			Headers -> {"Strand Index","Starting Base Number","Ending Base Number"}
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which Gibbs free energy of folded structure will be calculated.",
			Category -> "General",
			Abstract -> True
		},
		Depth -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[1, 1] | {GreaterEqualP[1, 1]} | Infinity,
			Description -> "Number of iterative folding steps conducted by the folding algorithm to reach the final structures.",
			Category -> "General"
		},
		Breadth -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[1, 1] | Infinity,
			Description -> "Number of candidate structures to propagate forward at each iterative step in the folding algorithm.",
			Category -> "General"
		},
		Consolidate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if all folds are extended to their maximum length.",
			Category -> "General"
		},
		SubOptimalStructureTolerance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0, 1] | GreaterEqualP[Quantity[0, Percent]] | GreaterEqualP[Quantity[0, KilocaloriePerMole]],
			Description -> "Threshold below which suboptimal structures will not be considered. If specified as integer, results will include all structures within the provided number of the optimal folded structure's bond count. If specified as energy, results will include all structures whose energy is within the provided absolute energy of the optimal folded structure's energy. If specified as percent, result will include all structures whose energy is within the provided percent of the optimal folded structure's energy.",
			Category -> "General"
		},
		MinLevel -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Minimum number of bases required in each fold.",
			Category -> "General"
		},
		MaxMismatch -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Maximum number of mismatches allowed in each folded duplex.",
			Category -> "General"
		},
		MinPieceSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Minimum number of consecutive paired bases required in a fold containing mismatches.",
			Category -> "General"
		},
		ExcludedSubstructures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LoopTypeP,
			Description -> "Types of substructures that are not considered by the folding algorithm.",
			Category -> "General"
		},
		MinHairpinLoopSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Lower bound (inclusive) on the allowed number of unpaired bases in a hairpin.",
			Category -> "General"
		},
		MaxHairpinLoopSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0, 1] | Infinity,
			Description -> "Upper bound (inclusive) on the allowed number of unpaired bases in a hairpin.",
			Category -> "General"
		},
		MinInternalLoopSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[2, 1],
			Units -> None,
			Description -> "Lower bound (inclusive) on the allowed number of unpaired bases in an interior loop.",
			Category -> "General",
			Abstract -> True
		},
		MaxInternalLoopSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[2, 1] | Infinity,
			Description -> "Upper bound (inclusive) on the allowed number of unpaired bases in an interior loop.",
			Category -> "General"
		},
		MinBulgeLoopSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Units -> None,
			Description -> "Lower bound (inclusive) on the allowed number of unpaired bases in a bulge loop.",
			Category -> "General"
		},
		MaxBulgeLoopSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[1, 1] | Infinity,
			Description -> "Upper bound (inclusive) on the allowed number of unpaired bases in a bulge loop.",
			Category -> "General"
		},
		MinMultipleLoopSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Lower bound (inclusive) on the allowed number of unpaired bases between each paired section in a multi loop.",
			Category -> "General"
		},
		(* --- Simulation Results --- *)
		FoldedStructures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The final folded structures resulting from the simulation starting from the initial structure.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		FoldedEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> EnergyP,
			Units -> KilocaloriePerMole,
			Description -> "For each member of FoldedStructures, the free energy of folding starting from the initial structure to the folded structure.",
			Category -> "Simulation Results",
			IndexMatching -> FoldedStructures
		},
		FoldedNumberOfBonds -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of FoldedStructures, the number of bonds in the folded structure.",
			Category -> "Simulation Results",
			IndexMatching -> FoldedStructures
		},
		FoldedPercentage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "For each member of FoldedStructures, the percent composition of the folded structure at equilibrium.",
			Category -> "Simulation Results",
			IndexMatching -> FoldedStructures

		},
		Foldings -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[FoldedStructures], Field[FoldedEnergies], Field[FoldedNumberOfBonds], Field[FoldedPercentage]}, Simulation`Private`foldsTranspose[{Field[FoldedStructures], Field[FoldedEnergies], Field[FoldedNumberOfBonds], Field[FoldedPercentage]}]],
			Pattern :> FoldingsP,
			Description -> "A table of the resulting folded structures, along with their energies, number of bonds, and precentage composition at equilibrium.",
			Category -> "Simulation Results"
		}
	}
}];
